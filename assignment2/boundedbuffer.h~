#include "types.h"
#include "param.h"
#include "user.h"
#include "semaphore.h"



struct BB {
 int buffer_size;
 int mutex;//protect the CS
  struct semaphore* empty; // empty slots
  struct semaphore* full; // full slots
 int count;
 void** pointer_to_elements; //need to be at least max_capacity
};


struct BB* BB_create(int max_capacity);
void BB_put(struct BB* bb, void* element);
void* BB_pop(struct BB* bb);
void BB_free(struct BB* bb);