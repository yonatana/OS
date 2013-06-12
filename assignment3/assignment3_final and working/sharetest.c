#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "mmu.h"
#include "param.h"


int main(){
  int key = 1;
  int test;
  char* childMem = 0;
  char* parentMem = 0;
  printf(1,"Child has %s in his virtual address\n",childMem);
  printf(1,"Parent has %s in his virtual address\n",parentMem);
  key = shmget(key,PGSIZE,CREAT);
  printf(1,"Parent created shared memory segment\n");
  if(fork() == 0){ //child section
     test = shmget(key,PGSIZE,GET);
     if(test < 0){
	printf(1,"could not get(GET)\n");
	exit();
     }
     childMem = shmat(key,SHM_RDWR);
     //printf(1,"Child got %x as shared memory address\n",childMem);
     strcpy(childMem, "Hello World");
     printf(1,"Child writen '%s' to shared memory\n",childMem);
     sleep(300);
     printf(1,"Child calling shmdt\n");
     shmdt(childMem);
     exit();
  }
  // parent section
  
  parentMem = shmat(key,SHM_RDWR);
  wait();
  //printf(1,"Parent got %x as shared memory address\n",parentMem);
  printf(1,"Parent read '%s' from shared memory\n",parentMem);
  printf(1,"Parent calling shmdt\n");
  shmdt(parentMem);
  exit();
  return 1;  
}


//   char box =0;
//   const void * addr = 0;
//   printf(1,"box has: %d Gulot\n",box);
//   key = shmget(key,PGSIZE,CREAT);
//   //create a child
//   if(fork()==0){
//     printf(1,"child will share the box\n");
//     test = shmget(key,PGSIZE,GET);
//   
//     if(test < 0){
//       printf(1,"could not get(get)\n");
//     }
//     else{
//       addr = shmat(key,SHM_RDWR); 
//       test2 = (char*)addr;
//       test2[0] = 'S';
//       printf(1,"TEST\n");
//       //*addr = ;
//     }
//     if(addr == (char*)-1){
//       printf(1,"could not shmat(RDWR)\n");
//     }
//     else{
//       printf(1,"child will put a Gula in the box\n");
//       box++;
//       printf(1,"child see %d Gulot in the box\n",box);
//       printf(1,"addr: %d\n",addr);
//       }
//      exit(); 
//     }
//   else{
//    wait();
//    addr = shmat(key, SHM_RDWR);
//    printf(1,"father see %d Gulot in the box\n",box);
//    printf(1,"addr: %d\n",addr);
//   }
  
  //the sun change shit
  
  //the father agree
  
  //finish and die