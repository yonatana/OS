// Test for RR scheduling policy.

#include "types.h"
#include "stat.h"
#include "user.h"

#define N  1000
#define NUM_Of_CHILDREN 10

struct child_stat{
  int wTime;
  int rTime;
  int pid;
};

void
rrtest(void)
{
  int wTime;
  int rTime;
  int tTime;
  int pid;
  int wpid;
  int j;
  int i;
  int num_of_forks =NUM_Of_CHILDREN;
  struct child_stat child_array [NUM_Of_CHILDREN];
  
  printf(1, "RRsanity test\n");

    for(j=0; j<num_of_forks; j++){
	pid = fork();
	if(pid == 0) break;
    }
    
    if(pid == 0){    
    for (i=0;i<N;i++){
	printf(1, "child %d pid prints for the %d time\n",getpid(),i);
      }
      exit();
    }
   int k = 0;  
   while ((wpid = wait2(&wTime,&rTime))) {
   if (wpid == -1) {
      break;
      }
      child_array[k].wTime = wTime;
      child_array[k].rTime = rTime;
      child_array[k].pid = wpid;
      k++;
   }
    for(k = 0; k < NUM_Of_CHILDREN; k++){
      tTime = child_array[k].wTime + child_array[k].rTime;
      printf(1, "child %d wTime: %d rTime: %d tTime: %d \n",child_array[k].pid,child_array[k].wTime,child_array[k].rTime,tTime);
    }
}
int
main(void)
{
  rrtest();
  exit();
}
