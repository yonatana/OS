#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "fcntl.h"
#include "stat.h"
#include "fs.h"
#include "file.h"

#define SHM_TABLE_SIZE 1024
#define NUM_OF_SEGMENTS 32
enum shmstate {UNINITIALIZED, UNLINKED, LINKED};

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;


typedef struct shmobj{
 struct spinlock lock;
 int key;
 uint size;
 char* addr[NUM_OF_SEGMENTS];
 char* virtual_addr;
 int shmstate;
 int pages_amount;
 int linkcounter;
}shmobj;

struct {
  struct spinlock lock;
  struct shmobj shmarray[SHM_TABLE_SIZE];
} shmtable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

int swap_enabled = 0;

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}



//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm(kalloc)) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;
  createInternalProcess("inSwapper",(void*)inSwapper);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
 
  pid = np->pid;
  np->state = RUNNABLE;
  safestrcpy(np->name, proc->name, sizeof(proc->name));
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

void
register_handler(sighandler_t sighandler)
{
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
  if ((proc->tf->esp & 0xFFF) == 0)
    panic("esp_offset == 0");

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
          = proc->tf->eip;
  proc->tf->esp -= 4;

    /* update eip */
  proc->tf->eip = (uint)sighandler;
}


struct proc* find_inswapper(){
  struct proc *p;
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(strncmp(p->name,"inSwapper",9) == 0) //found inSwapper
      return p;
  }
  cprintf("unable to find inSwapper\n");
  return 0;
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      
      
      //wake up inswapper
      if(p->state == RUNNABLE_SUSPENDED && p->swapped){
	p = find_inswapper(); //change p to inswapper 
	p->state = RUNNABLE;  //wakeup inswapper
      }
      
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
	
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    initlog();
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  if(proc->pid > 2 && swap_enabled){
    release(&ptable.lock);
    swapOut(proc);
    acquire(&ptable.lock);
  }else{
    proc->state = SLEEPING_SUSPENDED;
  }
  
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == SLEEPING_SUSPENDED && p->chan == chan){
      p->state = RUNNABLE_SUSPENDED;
      if(!p->swapped)
	p->state = RUNNABLE;
    }
 
  }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING_SUSPENDED){
        p->state = RUNNABLE_SUSPENDED;
	if(!p->swapped)
	  p->state = RUNNABLE;
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie",
  [SLEEPING_SUSPENDED] "sleeping_suspended",
  [RUNNABLE_SUSPENDED] "runnable_suspended"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

void createInternalProcess(const char *name, void (*entrypoint)()){
  
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    cprintf("createInternalProcess error in allocproc\n");

   // Copy process state from p.
  if((np->pgdir = setupkvm(kalloc)) == 0)
   cprintf("createInternalProcess error in setupkvm\n");
 
  memset(np->tf, 0, sizeof(*np->tf));
  np->tf->cs = (SEG_UCODE << 3) | 0;
  np->tf->ds = (SEG_UDATA << 3) | 0;
  np->tf->es = np->tf->ds;
  np->tf->ss = np->tf->ds;
  np->tf->eflags = FL_IF;
   
   
  np->sz = initproc->sz;
  np->parent = initproc;
  *np->tf = *initproc->tf;
  // Clear %eax so that fork returns 0 in the child.
  //np->tf->eax = 0;
  // Set starting point of inswapper
  //np->cwd = idup(initproc->cwd);
  np->cwd = namei("/");
  np->context->eip = (uint)entrypoint;


  
 np->state = RUNNABLE;
 safestrcpy(np->name, name, (strlen(name) + 1));

}

int
kernel_unlink(char* path)
{
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

//   if(argstr(0, &path) < 0)
//     return -1;
  if((dp = nameiparent(path, name)) == 0)
    return -1;

  begin_trans();

  ilock(dp);

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  /*
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    goto bad;
  }
*/
  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  commit_trans();

  return 0;

bad:
  iunlockput(dp);
  commit_trans();
  return -1;
}

int
kernel_fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}

struct inode*
kernel_create(char *path, short type, short major, short minor)
{
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];
   //cprintf("nameiparent path: %s\n",path);
  if((dp = nameiparent(path, name)) == 0)
    return 0;
  
  ilock(dp);
  
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
  }
  
  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);
  return ip;
}

struct file* kernel_open(char* path, int omode){
  int fd;
  struct file *f;
  struct inode *ip;
  if(omode & O_CREATE){
    begin_trans();
    ip = kernel_create(path, T_FILE, 0, 0);
    commit_trans();
    if(ip == 0)
      return 0;
  } else {
//     cprintf("kernel_open - path is %s\n",path);
    if((ip = namei(path)) == 0)
      return 0;
    //cprintf("kernel_open - path is %s passed namei\n",path);
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
      iunlockput(ip);
      return 0;
    }
  }
//   cprintf("kernel_open - before filealloc path %s\n",path);
  if((f = filealloc()) == 0 || (fd = kernel_fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    return 0;
  }
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return f;
//return fd;
  //return 0;
}

void reverse(char* str, int length){
    int i = 0, j = length-1;
    char tmp;
    while (i < j) {
        tmp = str[i];
        str[i] = str[j];
        str[j] = tmp;
        i++; j--;
    }
}

int itoa(int n, char* out)
{
    // if negative, need 1 char for the sign
    int sign = n < 0? 1: 0;
    int i = 0;
    if (n == 0) {
        out[i++] = '0';
    } else if (n < 0) {
        out[i++] = '-';
        n = -n;
    }
    while (n > 0) {
        out[i++] = '0' + n % 10;
        n /= 10;
    }
    out[i] = '\0';
    reverse(out + sign, i - sign);
    return 0;
}

void strcat(char* ans,int j,char* first, char* second){
   int length1 = strlen(first);
   int length2 = strlen(second);
   int length =length1 + length2+j;
   //cprintf("first %s length1 %d\n",first,length1);
   //cprintf("second %s length2 %d\n",second,length2);
   int i = 0;
   while(i < length){
     //cprintf("ans %s i %d j %d\n",ans,i,j);
     if(i < length1){
      ans[i+j] = first[i];
     }else{
      ans[i+j] = second[i - length1]; 
     }
     i++;
   }
   //cprintf("final ans %s\n",ans);
}



void swapOut(struct proc* p){
  //create flie
  char id_as_str[3]; // need to pre determine number of digits in p->pid
  itoa(p->pid,id_as_str);
  char path[strlen(id_as_str) + 5];
  strcat(path,0,id_as_str,".swap");
  p->swapped_file = kernel_open(path,O_CREATE | O_WRONLY);
  
  pte_t *pte;
  int i;
  uint pa;
  for(i = 0; i < p->sz; i += PGSIZE){
    if((pte = walkpgdir(p->pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    //cprintf("p->swapped_file %d\n",p->swapped_file);
    if(filewrite(p->swapped_file,p2v(pa),PGSIZE) < 0)
      panic("filewrite: error in swapOut");
  }
      
  int fd;
  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] && p->ofile[fd] == p->swapped_file){
     fileclose(p->ofile[fd]);
     p->ofile[fd] = 0;
     break;
    }
  }
  p->swapped_file = 0;
  p->swapped = 1;
  
  deallocuvm(p->pgdir,p->sz,0);
  p->state = SLEEPING_SUSPENDED;
  
}

void swapIn(struct proc* p){
//   cprintf("swapIN\n");
  //create flie
  char id_as_str[3]; // need to pre determine number of digits in p->pid
  itoa(p->pid,id_as_str);
  char path[strlen(id_as_str) + 5];
  path[6] = '\0';
//   path[0] = '/';
  strcat(path,0,id_as_str,".swap");
  //cprintf("swapIn - passed strcat path: %s\n",path);
  release(&ptable.lock);
  int test;
  p->swapped_file = kernel_open(path,O_RDONLY);
//   p->swapped_file = p->ofile[p->swapped_file_fd];
//   cprintf("swapIn - passed open pid %d p->sz %d\n",p->pid,p->sz);
  p->pgdir = setupkvm();
  test = allocuvm(p->pgdir,0,p->sz); //changed from KERNBASE
//   cprintf("swapIn - passed allocuvm pid %d returned %d\n",p->pid,test);
//   cprintf("swapFile ip: %d\n",p->swapped_file->ip->size);
  test = loaduvm(p->pgdir,0,p->swapped_file->ip,0,p->sz);
//   cprintf("swapIn - passed loaduvm pid %d returned %d\n",p->pid,test);
  test++;
  int fd;
  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] && p->ofile[fd] == p->swapped_file){
     fileclose(p->ofile[fd]);
     p->ofile[fd] = 0;
     break;
    }
  }
  p->swapped_file = 0;
//   cprintf("swapIn - passed fileclose pid %d\n",p->pid);
  test = kernel_unlink(path);
  //test++;
//   cprintf("swapIn - passed kernel_unlink pid %d returned %d\n",p->pid,test);
  acquire(&ptable.lock);
}

int first = 1;
void inSwapper(){
  release(&ptable.lock);
  for(;;){
    struct proc *p;
    acquire(&ptable.lock);
    //cprintf("inSwapper\n");
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state == RUNNABLE_SUSPENDED && p->swapped){
	//cprintf("calling swapIn process %d\n",p->pid);
	swapIn(p);
	p->swapped = 0;
	p->state = RUNNABLE;
      }
    }
    proc->state = SLEEPING;
    //cprintf("inSwapper finished proc->pid %d\n",proc->pid);
    sched();
    release(&ptable.lock);
  }
}


int enableSwapping(){
  swap_enabled = 1;
  return swap_enabled;
}
int disableSwapping(){
  swap_enabled = 0;
  return swap_enabled;
}
int num_of_pages(int proc_pid){
  struct proc *p;
  int counter = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid != proc_pid)
      continue;
    int i;
    int j;
    
    pte_t *pgtab;
    for(i = 0; i < NPDENTRIES ;i++){
      if(p->pgdir[i]& PTE_P){ 
	pgtab = (pte_t*)p2v(PTE_ADDR(p->pgdir[i]));
	for(j = 0; j < NPTENTRIES; j++){
	  if((pgtab[j] & PTE_P) && (pgtab[j] & PTE_U)){
	    counter++;
	  }
	}
      }
    }
    break;
  }
  release(&ptable.lock);
  return counter; 
}

int shmget(int key, uint size, int shmflg){
  int rounded_size;
  acquire(&shmtable.lock);
  if(shmflg == GET){
   if(shmtable.shmarray[key].shmstate == UNINITIALIZED){ //no shared memory object with that key
    cprintf("shmget(GET)-shmarray failure\n");
    release(&shmtable.lock);
    return -1; 
   }else{
     release(&shmtable.lock);
     return key;
   } 
  }
  if(shmflg == CREAT){
    if(shmtable.shmarray[key].shmstate != UNINITIALIZED){ //already created shared memory with that key
      release(&shmtable.lock);
      return -1;
    }
    int i = 0;
    int k;
    shmtable.shmarray[key].pages_amount = 0;
    shmtable.shmarray[key].key = key;
    rounded_size = PGROUNDUP(size);
    shmtable.shmarray[key].size = rounded_size;
    shmtable.shmarray[key].shmstate = UNLINKED;
    shmtable.shmarray[key].linkcounter = 0;
    shmtable.shmarray[key].virtual_addr = 0;
    //shmtable.shmarray[key] = newShmObj;
    for(k = 0; k < rounded_size; k+= PGSIZE){
	if(!(shmtable.shmarray[key].addr[i] = kalloc())){
	  cprintf("shmget(create)-kalloc failure\n");
	}
	shmtable.shmarray[key].pages_amount++;
	i++;
    }
    
  }
  release(&shmtable.lock);
  return key; 
  //return (int) shmtable.shmarray[key].addr[0];
}

int shmdel(int shmid){
  if(shmtable.shmarray[shmid].shmstate == UNLINKED && !shmtable.shmarray[shmid].linkcounter){
    int i;
    for(i = 0; i < shmtable.shmarray[shmid].pages_amount;i++){
      kfree(shmtable.shmarray[shmid].addr[i]);
    }
    shmtable.shmarray[shmid].pages_amount = 0;
    shmtable.shmarray[shmid].size = 0;
    shmtable.shmarray[shmid].shmstate = UNINITIALIZED;
  }else{
   return -1; 
  }
 return 0; 
}

int find_key(const void *shmaddr ){
  int ret =-1;
  int j;
  for(j=0;j<SHM_TABLE_SIZE;j++){
    if(proc->va[j]==shmaddr){
      ret = j;
      break;
      
    }
  }
  return ret;
}

void *shmat(int shmid, int shmflg){
  char * memory;
  uint size;
  void* ret = (void*) -1;
  int i;
  int flag_for =0;
  acquire(&shmtable.lock);
  if(shmtable.shmarray[shmid].size > 0){
    size = PGROUNDUP(proc->sz);
    ret =(void*)size;
    if(size + PGSIZE >= KERNBASE){
      cprintf("shmat:not enogh memory\n");
      release(&shmtable.lock);
      return (void*)-1;
    }
    //all is fine
    for(i = 0;shmtable.shmarray[shmid].addr[i] && size < KERNBASE;i++){
      //find the adress of the memory
      memory = shmtable.shmarray[shmid].addr[i];
      flag_for =1; //we did at least one page
      if(shmflg == SHM_RDONLY){
	mappages(proc->pgdir, (char*)size, PGSIZE, v2p(memory), PTE_U); 
	size += PGSIZE;
	break;
      }
      else if(shmflg == SHM_RDWR){
	mappages(proc->pgdir, (char*)size, PGSIZE, v2p(memory), PTE_W|PTE_U);
	size += PGSIZE;
	break;
      }
      else{//default
	flag_for = 0;
	size += PGSIZE;
      }
    }//end of for 
    if(flag_for){
      proc->sz =size;
      shmtable.shmarray[shmid].linkcounter++;
    }
    else{
      ret =(void*) -1;
      cprintf("shmat: no shmflg (flag_for = 0\n");
    }
  }
  else{ 
    cprintf("shmat: the memory isn't there\n");
    release(&shmtable.lock);
    return (void*)-1;
  }
  shmtable.shmarray[shmid].virtual_addr =ret;
  proc->va[shmid]=ret;
  release(&shmtable.lock);
  return ret; 
}

int shmdt(const void *shmaddr){
  pte_t *pte;
  uint numOfPages;
  pte = walkpgdir(proc->pgdir, (char*)shmaddr, 0);
  acquire(&shmtable.lock);
  int shmid = find_key(shmaddr);
  shmtable.shmarray[shmid].linkcounter--;
  numOfPages = shmtable.shmarray[shmid].pages_amount;
  void *shmaddr2 = (void*)shmaddr;
  
  for(; shmaddr2  < shmaddr + numOfPages*PGSIZE; shmaddr2 += PGSIZE)
  {
    pte = walkpgdir(proc->pgdir, (char*)shmaddr2, 0);
    if(!pte)
      shmaddr2 += (NPTENTRIES - 1) * PGSIZE;
    *pte = 0;
  }
  if(!shmtable.shmarray[shmid].linkcounter){
    shmtable.shmarray[shmid].shmstate = UNLINKED;
    cprintf("freeing all the memory\n");
    shmdel(shmid);
  }
 release(&shmtable.lock);
 return 0; 
}
void* get_share_memory_address(int key){
  void * ret =0;
  acquire(&shmtable.lock);
  ret = shmtable.shmarray[key].addr[0];
  release(&shmtable.lock);
 return ret;
}
