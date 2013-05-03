#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct semaphore {
  struct semphore s1;
  struct semphore s2;	  
  int value;
};
