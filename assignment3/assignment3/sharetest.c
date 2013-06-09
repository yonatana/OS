#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "mmu.h"
#include "param.h"


int main(){
  int key = 1;
  int test;
  char* my_str;
  const void* childMem = 0;
  const void* parentMem;
  key = shmget(key,PGSIZE,CREAT);
  if(fork() == 0){
     printf(1,"child will share memory\n");
     test = shmget(key,PGSIZE,GET);
     if(test < 0){
	printf(1,"could not get(GET)\n");
	exit();
     }
     printf(1,"child before shmat %d\n",childMem);
     childMem = shmat(key,SHM_RDWR);
     printf(1,"child after shmat %d\n",childMem);
     my_str = (char*)childMem;
     printf(1,"child before change\n");
     strcpy(my_str,"a");
     printf(1,"child after change \n");
     exit();
  }
  // parent section
  wait();
  parentMem = shmat(key,SHM_RDWR);
  my_str = (char*)parentMem;
  printf(1,"Parent %s\n",my_str);
  
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