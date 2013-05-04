

#include "types.h"
#include "stat.h"
#include "user.h"

void *retval;
void *printme(int* c) {
    printf(1,"Hi. I'm thread %d\n", getpid());
    *c=*c+1;
    printf(1,"C: %d\n", *c);
    thread_exit(retval);
    return 0;
}

int main() {
    int i, tids[4];
    int tid;
    int counter =0;
    void* stack = (void*)malloc(1024);
    uint stack_size = 1024;
    for (i = 0; i < 4; i++) {
        tids[i] = thread_create(printme(&counter), stack, stack_size);
	
    }
    for (i = 0; i < 4; i++) {
        printf(1,"Trying to join with tid%d\n", tids[i]);
        thread_join(tids[i], &retval);
        printf(1,"Joined with tid%d\n", tids[i]);
    }
    for(;;){
      tid = wait();
      if(tid == -1)
	break;
    }
    exit();
    return 0;
}