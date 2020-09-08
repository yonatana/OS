

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

void* printme2(){
  void* ret_val = 0;
  printf(1, "thread: %d of process: %d\n", thread_getId(), thread_getProcId());
  thread_exit(ret_val);
  return 0;
}

void task1_test(){
  int i;
  void* ret_val;
  void* current_stack;
  for(i=0; i < 12; i++){
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme2,current_stack,STACK_SIZE);
  }
  for(i=1; i < 13; i++){
   thread_join(i,&ret_val);
  }

}

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

void* printme3(){
  int i;
  for(;;){
    semaphore_down(sem);
    for(i = 0; i < 3; i++){
      printf(1, "Process %d Thread %d is running\n", thread_getProcId(),  thread_getId());
    }
    semaphore_up(sem);
  }
  return 0;
}

void counting_semaphore_test(int num_of_threads){
  int i;
  void* current_stack;
  sem = semaphore_create(1);
  for(i = 0; i < num_of_threads; i++){
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme3,current_stack,STACK_SIZE);
  }
}

void* printme4(){
  void* sheker = 0;
  for(;;){
    BB_put(buf,sheker);
//     printf(1, "Process %d Thread %d puted\n", thread_getProcId(),  thread_getId());

  }
  return 0;
}

void* printme5(){
  for(;;){
    BB_pop(buf);
//     printf(1, "Process %d Thread %d poped\n", thread_getProcId(),  thread_getId());
  }
  return 0;
}

void bounded_buffer_test(int num_of_producers,int num_of_consumers){
  int i;
  void* current_stack;
  buf = BB_create(4);
  for(i = 0; i < num_of_producers; i++){
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme4,current_stack,STACK_SIZE);
  }
  for(i = 0; i < num_of_consumers; i++){
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme5,current_stack,STACK_SIZE);
  }
}

int main(int argc, char** argv){
  //task1_test();
  int num_of_threads;
  num_of_threads = atoi(argv[1]);
  binary_semaphore_test(num_of_threads);
  //counting_semaphore_test(num_of_threads);
  //bounded_buffer_test(num_of_threads,num_of_threads);
  wait(); //main thread should not cross that line (program never finishes)
  exit();
  return 1;
  
}