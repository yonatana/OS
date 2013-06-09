#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "mmu.h"
#include "param.h"

int main(){
  int key = 1;
  char box =0;
  char* addr;
  int test =0;
  printf(1,"box has: %d Gulot\n",box);
  shmget(key,PGSIZE,CREAT);
  //create a child
  if(fork()==0){
    printf(1,"child will share the box\n");
    test = shmget(key,PGSIZE,GET);
  
    if(test < 0){
      printf(1,"could not get(get)\n");
    }
    else{
      addr = shmat(key, SHM_RDWR); 
      printf(1,"*:%d\n",test);
      *addr = box;
      printf(1,"*:%d\n",test-1);
    }
    if(addr == (char*)-1){
      printf(1,"could not shmat(RDWR)\n");
    }
    else{
      printf(1,"child will put a Gula in the box\n");
      box++;
      printf(1,"child see %d Gulot in the box\n",box);
      printf(1,"addr: %d\n",addr);
      }
     exit(); 
    }
  else{
   wait();
   addr = shmat(key, SHM_RDWR);
   printf(1,"father see %d Gulot in the box\n",box);
   printf(1,"addr: %d\n",addr);
  }
  
  //the sun change shit
  
  //the father agree
  
  //finish and die
  
  
  exit();
  return 1;  
}