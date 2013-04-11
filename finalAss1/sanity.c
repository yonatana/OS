// Test for RR scheduling policy.

#include "types.h"
#include "stat.h"
#include "user.h"
#include "limits.h"

#define N  500
#define NUM_Of_CHILDREN 30

struct child_stat{
  int wTime;
  int rTime;
  int tTime;
  int pid;
};

void
threeqtest(void)
{
  int wTime;
  int rTime;
  int pid;
  int wpid;
  int j;
  int i;
  struct child_stat child_array [NUM_Of_CHILDREN];
  int cid;
  int sum_wTime;
  int sum_rTime;
  int sum_tTime;
  double avg_wTime;
  double avg_rTime;
  double avg_tTime;
  int first_child = INT_MAX;
    

 
      for(j=0; j<NUM_Of_CHILDREN ; j++){
	  pid = fork();
	  cid = j;
	  if(pid == 0) break;
      }
    
    if(pid == 0){
	//cid = getpid();
	//cid = cid - first_child;
	if((cid % 3) == 0)
	  nice();
	if((cid % 3) == 1){
	  nice();
	  nice();
      }  
      for (i=0;i<N;i++){
	  printf(1, "child %d pid prints for the %d time\n",cid,i);
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
      child_array[k].tTime = child_array[k].wTime + child_array[k].rTime;
      child_array[k].pid = wpid;
      k++;
   }
   
   // find min pid in all children
   for(k = 0;k< NUM_Of_CHILDREN;k++){
      if(first_child > child_array[k].pid)
	first_child = child_array[k].pid;
   }
   
   // decrease first_child from all children to get id's 0-29
   for(k = 0;k< NUM_Of_CHILDREN;k++){
      child_array[k].pid = child_array[k].pid - first_child;
   }
   
    for(k = 0; k < NUM_Of_CHILDREN; k++){
      sum_wTime = sum_wTime + child_array[k].wTime;
      sum_rTime = sum_rTime + child_array[k].rTime;
      sum_tTime = sum_tTime + child_array[k].tTime;
    }
    avg_wTime = (double)sum_wTime/(double)NUM_Of_CHILDREN;
    avg_rTime = (double)sum_rTime/(double)NUM_Of_CHILDREN;
    avg_tTime = (double)sum_tTime/(double)NUM_Of_CHILDREN;
    printf(1,"---Total Stats---\n");
    printf(1,"Average waiting time: %d\n",(int)avg_wTime);
    printf(1,"Average running time: %d\n",(int)avg_rTime);
    printf(1,"Average turnaround time: %d\n\n",(int)avg_tTime);
    
    sum_rTime = 0;
    sum_tTime = 0;
    sum_wTime = 0;
    avg_wTime = 0;
    avg_rTime = 0;
    avg_tTime = 0;
    
    // print HIGH priority processes
     for(k = 0; k < NUM_Of_CHILDREN; k++){
      if((child_array[k].pid % 3) == 2) {
	sum_wTime = sum_wTime + child_array[k].wTime;
	sum_rTime = sum_rTime + child_array[k].rTime;
	sum_tTime = sum_tTime + child_array[k].tTime;
      }
    }
    
    avg_wTime = (double)sum_wTime/(NUM_Of_CHILDREN / 3);
    avg_rTime = (double)sum_rTime/(NUM_Of_CHILDREN / 3);
    avg_tTime = (double)sum_tTime/(NUM_Of_CHILDREN / 3);
    printf(1,"---Group High Priority Stats---\n");
    printf(1,"Average waiting time: %d\n",(int)avg_wTime);
    printf(1,"Average running time: %d\n",(int)avg_rTime);
    printf(1,"Average turnaround time: %d\n\n",(int)avg_tTime);
    
    sum_rTime = 0;
    sum_tTime = 0;
    sum_wTime = 0;
    avg_wTime = 0;
    avg_rTime = 0;
    avg_tTime = 0;
    
     // print MEDIUM priority processes
     for(k = 0; k < NUM_Of_CHILDREN; k++){
      if((child_array[k].pid % 3) == 0){
	sum_wTime = sum_wTime + child_array[k].wTime;
	sum_rTime = sum_rTime + child_array[k].rTime;
	sum_tTime = sum_tTime + child_array[k].tTime;
      }
    }
    
    avg_wTime = (double)sum_wTime/(NUM_Of_CHILDREN / 3);
    avg_rTime = (double)sum_rTime/(NUM_Of_CHILDREN / 3);
    avg_tTime = (double)sum_tTime/(NUM_Of_CHILDREN / 3);
    printf(1,"---Group Medium Priority Stats---\n");
    printf(1,"Average waiting time: %d\n",(int)avg_wTime);
    printf(1,"Average running time: %d\n",(int)avg_rTime);
    printf(1,"Average turnaround time: %d\n\n",(int)avg_tTime);
    
    sum_rTime = 0;
    sum_tTime = 0;
    sum_wTime = 0;
    avg_wTime = 0;
    avg_rTime = 0;
    avg_tTime = 0;
    
     // print LOW priority processes
     for(k = 0; k < NUM_Of_CHILDREN; k++){
      if((child_array[k].pid % 3) == 1) {
	sum_wTime = sum_wTime + child_array[k].wTime;
	sum_rTime = sum_rTime + child_array[k].rTime;
	sum_tTime = sum_tTime + child_array[k].tTime;
      }
    }
    
    avg_wTime = (double)sum_wTime/(NUM_Of_CHILDREN / 3);
    avg_rTime = (double)sum_rTime/(NUM_Of_CHILDREN / 3);
    avg_tTime = (double)sum_tTime/(NUM_Of_CHILDREN / 3);
    printf(1,"---Group Low Priority Stats---\n");
    printf(1,"Average waiting time: %d\n",(int)avg_wTime);
    printf(1,"Average running time: %d\n",(int)avg_rTime);
    printf(1,"Average turnaround time: %d\n\n",(int)avg_tTime);
    
    // print each child stats
    printf(1,"---Each Child Stats---\n");
    for (k=0;k<NUM_Of_CHILDREN;k++){
      printf(1, "child %d wTime: %d rTime: %d tTime: %d \n",child_array[k].pid,child_array[k].wTime,child_array[k].rTime,child_array[k].tTime);
    }
}
int
main(void)
{
  threeqtest();
  exit();
}
