#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

//TODO include


struct semaphore* semaphore_create(int initial_semaphore_value){
  struct semaphore* sem;
  sem->value =initial_semaphore_value;
  
}
void semaphore_down(struct semaphore* sem );
void semaphore_up(struct semaphore* sem );