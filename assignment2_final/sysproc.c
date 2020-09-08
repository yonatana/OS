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

int
sys_thread_create(void)
{
  char* start_func;
  char* stack;
  int stack_size;
  argptr(0,&start_func,sizeof(start_func));
  argptr(1,&stack,sizeof(stack));
  argint(2,&stack_size);
  return thread_create((void*(*)())start_func,(void*)stack,(uint)stack_size);
}

int
sys_thread_getId(void)
{
    return thread_getId();
}

int
sys_thread_getProcId(void)
{
    return thread_getProcId();
}

int
sys_thread_join(void)
{
  int thread_id;  
  char* ret_val;
  argint(0,&thread_id);
  argptr(1,&ret_val,sizeof(ret_val));
  return thread_join(thread_id,(void**)&ret_val);
}

int
sys_thread_exit(void)
{
    char* ret_val;
    argptr(0,&ret_val,sizeof(ret_val));
    thread_exit((void*)ret_val);
    return 0; // not reached
}

int 
sys_binary_semaphore_create(void){
  int initial_value;
  argint(0,&initial_value);
  return binary_semaphore_create(initial_value);
}

int 
sys_binary_semaphore_down(void){
   int binary_semaphore_ID;
  argint(0,&binary_semaphore_ID);
  return binary_semaphore_down(binary_semaphore_ID);
}
int 
sys_binary_semaphore_up(void){
   int binary_semaphore_ID;
  argint(0,&binary_semaphore_ID);
  return binary_semaphore_up(binary_semaphore_ID);
}
