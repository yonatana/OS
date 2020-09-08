#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_enableSwapping(void){
  return enableSwapping();
}
int sys_disableSwapping(void){
  return disableSwapping();
}
int sys_num_of_pages(void){
  int proc_pid;
  if(argint(0, &proc_pid) < 0)
    return -1;
  return num_of_pages(proc_pid);
}

int sys_shmget(void){
 int key;
 int size;
 int shmflg;
 
 if(argint(0, &key) < 0)
    return -1;
 if(argint(1, &size) < 0)
    return -1;
 if(argint(2, &shmflg) < 0)
    return -1;
 
 return shmget(key,size,shmflg);
}

int sys_shmdel(void){
  int shmid;
  if(argint(0, &shmid) < 0)
    return -1;
  return shmdel(shmid);
}


void* sys_shmat(void){
 void *shmat(int shmid, int shmflg);
 int shmid;
 int shmflg;
  if(argint(0, &shmid) < 0)
    return (void*)-1;
   if(argint(1, &shmflg) < 0)
    return (void*)-1;
 
   
 return shmat(shmid,shmflg);
  
}

int sys_shmdt(void){
   void *shmaddr;
   if(argptr(0, (void*)&shmaddr,sizeof(void*)) < 0){
     return -1;
   }
   return shmdt(shmaddr);
}

void* sys_get_share_memory_address(void){
  int key;
  if(argint(0, &key) < 0)
    return (void*)-1;
  return get_share_memory_address(key);
}