#include "types.h"
#include "stat.h"
#include "user.h"


#define MAX_ALLOCATION 0x80000000

void* my_memory;

void swappedOut_blocked_test(){
  int pid;
  pid = fork();
  if(pid == 0){ //child process
    printf(1,"Process %d is sleeping\n",getpid());
    sleep(500);
  }
  
  my_memory = sbrk(MAX_ALLOCATION);
  if(pid == 0){ //child process exit
    free(my_memory);
    exit();
  }
}




int main(int argc, char** argv){
  int pid;
  int parent_pid = getpid();
  int pages_count;
  
  printf(1,"enableSwapping\n");
  enableSwapping();
  pid = fork();
  if(pid == 0){
    
    sleep(300);
    pages_count = num_of_pages(parent_pid);
    printf(1,"parent nummber of pages while swaping enabled: %d\n",pages_count);
    printf(1,"child %d do ls- we expect to see %d.swap (parent_pid)\n",getpid(),parent_pid);
    exec("ls",argv);
    }
  
  
  printf(1,"parent is wating and will be swaped out\n");
  while (wait() != -1){} //main thread should not cross that line (program never finishes)
  
////////////////////////part 2 after disabling
  printf(1,"disbleSwapping\n");
  disableSwapping();
  pid = fork();
  if(pid == 0){
    
    sleep(800);
    pages_count = num_of_pages(parent_pid);
    printf(1,"parent nummber of pages while swaping disabled: %d\n",pages_count);
    printf(1,"child %d do ls- we expect NOT to see %d.swap (the parent_pid.swap)\n",getpid(),parent_pid);
    exec("ls",argv);
    }
  
  printf(1,"parent is wating and will not be swaped out\n");
  while (wait() != -1){} //main thread should not cross that line (program never finishes)
  
  
  
  
  
  exit();
  return 1;
  
}