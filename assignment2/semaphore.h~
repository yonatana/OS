#include "types.h"
#include "mmu.h"
#include "param.h"
#include "proc.h"
#include "user.h"


struct semaphore {
  int s1;//semaphore 1 id
  int s2;//semaphore 2 id	  
  int value;
  int initial_value;
};

struct semaphore* semaphore_create(int initial_semaphore_value);
void semaphore_down(struct semaphore* sem );
void semaphore_up(struct semaphore* sem );