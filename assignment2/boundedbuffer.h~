#include "types.h"
#include "param.h"
#include "user.h"
#include "semaphore.h"



struct BB {
volatile int buffer_size;
volatile int mutex;//protect the CS
  struct semaphore* empty; // empty slots
  struct semaphore* full; // full slots
volatile int count;
volatile int start;
volatile int end;
 void** pointer_to_elements; //need to be at least max_capacity
};


struct BB* BB_create(int max_capacity);
void BB_put(struct BB* bb, void* element);
void* BB_pop(struct BB* bb);
void BB_free(struct BB* bb);
int BB_size(struct BB* bb);
int BB_buffer_size(struct BB* bb);