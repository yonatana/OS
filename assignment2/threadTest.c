

#include "types.h"
#include "stat.h"
#include "user.h"

#define STACK_SIZE 1024
#define NUM_OF_PRINTS 3



void *printme(int* sem) {
  int j;
  if(thread_getId() != thread_getProcId()){
    for(;;){
      binary_semaphore_down(*sem);
      for(j = 0; j < NUM_OF_PRINTS; j++){
	  printf(1,"Process %d Thread %d is running\n",thread_getProcId(),thread_getId());
      }
      binary_semaphore_up(*sem);    
    }
  }
  return 0;
}

int main(int argc, char** argv) {
    int num_of_threads = atoi(argv[1]);
    int i;
    int the_lock;
    the_lock = binary_semaphore_create(1);
    void * stack;
    for(i = 0; i < num_of_threads; i++){
      
	stack = (void*)malloc (STACK_SIZE);
	thread_create(printme(&the_lock),stack,STACK_SIZE);
    }
    for(;;){
	if(wait() == -1)
	  break;
    }
    exit();
    return 0;
}