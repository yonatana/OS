// Test for RR scheduling policy.

#include "types.h"
#include "stat.h"
#include "user.h"

#define N  1000

void
grttest(void)
{
  int wpid;
  int i;
  printf(1, "Father pid is %d\n",getpid());
  sleep(1000); // maybe suppose to be 10 (linux's manual)
  fork();
  for(i = 0; i < 50; i++){
	printf(1, "process %d is printing for the %d time\n",getpid(),i);
  }
  while((wpid = wait())){
   if(wpid == -1)
     break;
   exit();
  }
}
int
main(void)
{
  grttest();
  exit();
}
