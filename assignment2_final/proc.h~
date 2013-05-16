// Segments in proc->gdt.
#define NSEGS     7

// Per-CPU state
struct cpu {
  uchar id;                    // Local APIC ID; index into cpus[] below
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;        // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  
  // Cpu-local storage variables; see below
  struct cpu *cpu;
  struct proc *proc;           // The currently-running process.
};

struct binary_semaphore{
 int value;//0 is locked, 1 is free
 int initialize;//if > 0 then the semaphore was initialize
 int waiting;//how meny are sleeping on this semaphore
 int first_in_queue; //place of first
 int last_in_queue; //place of last
} binary_semaphore;

extern struct cpu cpus[NCPU];
extern int ncpu;

// Per-CPU variables, holding pointers to the
// current cpu and to the current process.
// The asm suffix tells gcc to use "%gs:0" to refer to cpu
// and "%gs:4" to refer to proc.  seginit sets up the
// %gs segment register so that %gs refers to the memory
// holding those two variables in the local cpu's struct cpu.
// This is similar to how thread-local variables are implemented
// in thread libraries such as Linux pthreads.
extern struct cpu *cpu asm("%gs:0");       // &cpus[cpunum()]
extern struct proc *proc asm("%gs:4");     // cpus[cpunum()].proc

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

// States of process:
// 		{ UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE }
// States of thread:
//		{ RUNNING, READY, BLOCKED, TERMINATED } 

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE , READY, BLOCKED, TERMINATED };


typedef void (*sighandler_t)(void);

// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  volatile int pid;            // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct file *temp_ofile;     //temp files for deletion ###########on thread create we point it to ofile, on thread_exit we point ofile back ti temp_ofile 
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)
  int is_thread;		// Is the process a thread: 0 => process is not a thread. 1 => process is a thread.
  int thread_joined;		// Identifier of the thread that needs to be waited for. Initialized to -1 => no thread to wait for
  int tid;			//all thread from same father have special id
  int wait_for_sem;		//the Id of semaphore this thread is waiting for
  //int sem_queue_pos[128];	// while waiting to a semaphore, this is the place in queue (array of semaphores to wait at)
  void* ret_val;		// thread return value
  int sem_queue_pos;		// while waiting to a semaphore, this is the place in queue (array of semaphores to wait at)
  int num_of_thread_child;	//number of thread made by that process
  
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap