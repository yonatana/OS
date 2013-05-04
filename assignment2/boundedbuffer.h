#include "types.h"
#include "mmu.h"
#include "param.h"
#include "proc.h"
#include "user.h"

structBB{
 int buffer_size;
 int mutex;//protect the CS
 int empty_semaphore;
 int full_semaphore;
 void* elements[buffer_size];
}

struct BB* BB_create(int max_capacity);
void BB_put(struct BB* bb, void* element);
void* BB_pop(struct BB* bb);