

#include "types.h"
#include "stat.h"
#include "user.h"
//#include "semaphore.h"
#include "boundedbuffer.h"

#define STACK_SIZE 1024
#define NUM_OF_PRINTS 3

int the_lock;
struct semaphore* sem;
struct BB* buf;


void* printme(){
  int i;
  for(;;){
    binary_semaphore_down(the_lock);
    for(i = 0; i < 3; i++){
      printf(1, "Process %d Thread %d is running\n", thread_getProcId(),  thread_getId());
    }
    binary_semaphore_up(the_lock);
  }
  return 0;
}

void binary_semaphore_test(int num_of_threads){
  int i;
  void* current_stack;
  the_lock = binary_semaphore_create(1);
  for(i = 0; i < num_of_threads; i++){
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme,current_stack,STACK_SIZE);
  }
}


int main(int argc, char** argv){
  //task1_test();
  int num_of_threads;
  num_of_threads = atoi(argv[1]);
  binary_semaphore_test(num_of_threads);
  wait(); //main thread should not cross that line (program never finishes)
  exit();
  return 1;
  
}