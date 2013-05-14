
_threadTest:     file format elf32-i386


Disassembly of section .text:

00000000 <printme2>:

int the_lock;
struct semaphore* sem;
struct BB* buf;

void* printme2(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  void* ret_val = 0;
   7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  printf(1, "thread: %d of process: %d\n", thread_getId(), thread_getProcId());
   e:	e8 25 06 00 00       	call   638 <thread_getProcId>
  13:	89 c3                	mov    %eax,%ebx
  15:	e8 16 06 00 00       	call   630 <thread_getId>
  1a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  22:	c7 44 24 04 b8 0e 00 	movl   $0xeb8,0x4(%esp)
  29:	00 
  2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  31:	e8 09 07 00 00       	call   73f <printf>
  thread_exit(ret_val);
  36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  39:	89 04 24             	mov    %eax,(%esp)
  3c:	e8 07 06 00 00       	call   648 <thread_exit>
  return 0;
  41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  46:	83 c4 24             	add    $0x24,%esp
  49:	5b                   	pop    %ebx
  4a:	5d                   	pop    %ebp
  4b:	c3                   	ret    

0000004c <task1_test>:

void task1_test(){
  4c:	55                   	push   %ebp
  4d:	89 e5                	mov    %esp,%ebp
  4f:	83 ec 28             	sub    $0x28,%esp
  int i;
  void* ret_val;
  void* current_stack;
  for(i=0; i < 12; i++){
  52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  59:	eb 2e                	jmp    89 <task1_test+0x3d>
      current_stack = (void*)malloc(STACK_SIZE);
  5b:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  62:	e8 bc 09 00 00       	call   a23 <malloc>
  67:	89 45 f0             	mov    %eax,-0x10(%ebp)
      thread_create((void*)printme2,current_stack,STACK_SIZE);
  6a:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  71:	00 
  72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  75:	89 44 24 04          	mov    %eax,0x4(%esp)
  79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80:	e8 a3 05 00 00       	call   628 <thread_create>

void task1_test(){
  int i;
  void* ret_val;
  void* current_stack;
  for(i=0; i < 12; i++){
  85:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  89:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
  8d:	7e cc                	jle    5b <task1_test+0xf>
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme2,current_stack,STACK_SIZE);
  }
  for(i=1; i < 13; i++){
  8f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  96:	eb 16                	jmp    ae <task1_test+0x62>
   thread_join(i,&ret_val);
  98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a2:	89 04 24             	mov    %eax,(%esp)
  a5:	e8 96 05 00 00       	call   640 <thread_join>
  void* current_stack;
  for(i=0; i < 12; i++){
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme2,current_stack,STACK_SIZE);
  }
  for(i=1; i < 13; i++){
  aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  ae:	83 7d f4 0c          	cmpl   $0xc,-0xc(%ebp)
  b2:	7e e4                	jle    98 <task1_test+0x4c>
   thread_join(i,&ret_val);
  }

}
  b4:	c9                   	leave  
  b5:	c3                   	ret    

000000b6 <printme>:

void* printme(){
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	53                   	push   %ebx
  ba:	83 ec 24             	sub    $0x24,%esp
  int i;
  for(;;){
    binary_semaphore_down(the_lock);
  bd:	a1 f0 13 00 00       	mov    0x13f0,%eax
  c2:	89 04 24             	mov    %eax,(%esp)
  c5:	e8 8e 05 00 00       	call   658 <binary_semaphore_down>
    for(i = 0; i < 3; i++){
  ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  d1:	eb 2c                	jmp    ff <printme+0x49>
      printf(1, "Process %d Thread %d is running\n", thread_getProcId(),  thread_getId());
  d3:	e8 58 05 00 00       	call   630 <thread_getId>
  d8:	89 c3                	mov    %eax,%ebx
  da:	e8 59 05 00 00       	call   638 <thread_getProcId>
  df:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  e7:	c7 44 24 04 d4 0e 00 	movl   $0xed4,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 44 06 00 00       	call   73f <printf>

void* printme(){
  int i;
  for(;;){
    binary_semaphore_down(the_lock);
    for(i = 0; i < 3; i++){
  fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  ff:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
 103:	7e ce                	jle    d3 <printme+0x1d>
      printf(1, "Process %d Thread %d is running\n", thread_getProcId(),  thread_getId());
    }
    binary_semaphore_up(the_lock);
 105:	a1 f0 13 00 00       	mov    0x13f0,%eax
 10a:	89 04 24             	mov    %eax,(%esp)
 10d:	e8 4e 05 00 00       	call   660 <binary_semaphore_up>
  }
 112:	eb a9                	jmp    bd <printme+0x7>

00000114 <binary_semaphore_test>:
  return 0;
}

void binary_semaphore_test(int num_of_threads){
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	83 ec 28             	sub    $0x28,%esp
  int i;
  void* current_stack;
  the_lock = binary_semaphore_create(1);
 11a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 121:	e8 2a 05 00 00       	call   650 <binary_semaphore_create>
 126:	a3 f0 13 00 00       	mov    %eax,0x13f0
  for(i = 0; i < num_of_threads; i++){
 12b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 132:	eb 2e                	jmp    162 <binary_semaphore_test+0x4e>
      current_stack = (void*)malloc(STACK_SIZE);
 134:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 13b:	e8 e3 08 00 00       	call   a23 <malloc>
 140:	89 45 f0             	mov    %eax,-0x10(%ebp)
      thread_create((void*)printme,current_stack,STACK_SIZE);
 143:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 14a:	00 
 14b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 14e:	89 44 24 04          	mov    %eax,0x4(%esp)
 152:	c7 04 24 b6 00 00 00 	movl   $0xb6,(%esp)
 159:	e8 ca 04 00 00       	call   628 <thread_create>

void binary_semaphore_test(int num_of_threads){
  int i;
  void* current_stack;
  the_lock = binary_semaphore_create(1);
  for(i = 0; i < num_of_threads; i++){
 15e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 162:	8b 45 f4             	mov    -0xc(%ebp),%eax
 165:	3b 45 08             	cmp    0x8(%ebp),%eax
 168:	7c ca                	jl     134 <binary_semaphore_test+0x20>
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme,current_stack,STACK_SIZE);
  }
}
 16a:	c9                   	leave  
 16b:	c3                   	ret    

0000016c <printme3>:

void* printme3(){
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	53                   	push   %ebx
 170:	83 ec 24             	sub    $0x24,%esp
  int i;
  for(;;){
    semaphore_down(sem);
 173:	a1 ec 13 00 00       	mov    0x13ec,%eax
 178:	89 04 24             	mov    %eax,(%esp)
 17b:	e8 27 0a 00 00       	call   ba7 <semaphore_down>
    for(i = 0; i < 3; i++){
 180:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 187:	eb 2c                	jmp    1b5 <printme3+0x49>
      printf(1, "Process %d Thread %d is running\n", thread_getProcId(),  thread_getId());
 189:	e8 a2 04 00 00       	call   630 <thread_getId>
 18e:	89 c3                	mov    %eax,%ebx
 190:	e8 a3 04 00 00       	call   638 <thread_getProcId>
 195:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 199:	89 44 24 08          	mov    %eax,0x8(%esp)
 19d:	c7 44 24 04 d4 0e 00 	movl   $0xed4,0x4(%esp)
 1a4:	00 
 1a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ac:	e8 8e 05 00 00       	call   73f <printf>

void* printme3(){
  int i;
  for(;;){
    semaphore_down(sem);
    for(i = 0; i < 3; i++){
 1b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1b5:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
 1b9:	7e ce                	jle    189 <printme3+0x1d>
      printf(1, "Process %d Thread %d is running\n", thread_getProcId(),  thread_getId());
    }
    semaphore_up(sem);
 1bb:	a1 ec 13 00 00       	mov    0x13ec,%eax
 1c0:	89 04 24             	mov    %eax,(%esp)
 1c3:	e8 36 0a 00 00       	call   bfe <semaphore_up>
  }
 1c8:	eb a9                	jmp    173 <printme3+0x7>

000001ca <counting_semaphore_test>:
  return 0;
}

void counting_semaphore_test(int num_of_threads){
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 28             	sub    $0x28,%esp
  int i;
  void* current_stack;
  sem = semaphore_create(1);
 1d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d7:	e8 28 09 00 00       	call   b04 <semaphore_create>
 1dc:	a3 ec 13 00 00       	mov    %eax,0x13ec
  for(i = 0; i < num_of_threads; i++){
 1e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e8:	eb 2e                	jmp    218 <counting_semaphore_test+0x4e>
      current_stack = (void*)malloc(STACK_SIZE);
 1ea:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 1f1:	e8 2d 08 00 00       	call   a23 <malloc>
 1f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      thread_create((void*)printme3,current_stack,STACK_SIZE);
 1f9:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 200:	00 
 201:	8b 45 f0             	mov    -0x10(%ebp),%eax
 204:	89 44 24 04          	mov    %eax,0x4(%esp)
 208:	c7 04 24 6c 01 00 00 	movl   $0x16c,(%esp)
 20f:	e8 14 04 00 00       	call   628 <thread_create>

void counting_semaphore_test(int num_of_threads){
  int i;
  void* current_stack;
  sem = semaphore_create(1);
  for(i = 0; i < num_of_threads; i++){
 214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 218:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21b:	3b 45 08             	cmp    0x8(%ebp),%eax
 21e:	7c ca                	jl     1ea <counting_semaphore_test+0x20>
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme3,current_stack,STACK_SIZE);
  }
}
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <printme4>:

void* printme4(){
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
 225:	83 ec 28             	sub    $0x28,%esp
  void* sheker = 0;
 228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(;;){
    BB_put(buf,sheker);
 22f:	a1 f4 13 00 00       	mov    0x13f4,%eax
 234:	8b 55 f4             	mov    -0xc(%ebp),%edx
 237:	89 54 24 04          	mov    %edx,0x4(%esp)
 23b:	89 04 24             	mov    %eax,(%esp)
 23e:	e8 3e 0b 00 00       	call   d81 <BB_put>
//     printf(1, "Process %d Thread %d puted\n", thread_getProcId(),  thread_getId());

  }
 243:	eb ea                	jmp    22f <printme4+0xd>

00000245 <printme5>:
  return 0;
}

void* printme5(){
 245:	55                   	push   %ebp
 246:	89 e5                	mov    %esp,%ebp
 248:	83 ec 18             	sub    $0x18,%esp
  for(;;){
    BB_pop(buf);
 24b:	a1 f4 13 00 00       	mov    0x13f4,%eax
 250:	89 04 24             	mov    %eax,(%esp)
 253:	e8 a6 0b 00 00       	call   dfe <BB_pop>
//     printf(1, "Process %d Thread %d poped\n", thread_getProcId(),  thread_getId());
  }
 258:	eb f1                	jmp    24b <printme5+0x6>

0000025a <bounded_buffer_test>:
  return 0;
}

void bounded_buffer_test(int num_of_producers,int num_of_consumers){
 25a:	55                   	push   %ebp
 25b:	89 e5                	mov    %esp,%ebp
 25d:	83 ec 28             	sub    $0x28,%esp
  int i;
  void* current_stack;
  buf = BB_create(4);
 260:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 267:	e8 f0 09 00 00       	call   c5c <BB_create>
 26c:	a3 f4 13 00 00       	mov    %eax,0x13f4
  for(i = 0; i < num_of_producers; i++){
 271:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 278:	eb 2e                	jmp    2a8 <bounded_buffer_test+0x4e>
      current_stack = (void*)malloc(STACK_SIZE);
 27a:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 281:	e8 9d 07 00 00       	call   a23 <malloc>
 286:	89 45 f0             	mov    %eax,-0x10(%ebp)
      thread_create((void*)printme4,current_stack,STACK_SIZE);
 289:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 290:	00 
 291:	8b 45 f0             	mov    -0x10(%ebp),%eax
 294:	89 44 24 04          	mov    %eax,0x4(%esp)
 298:	c7 04 24 22 02 00 00 	movl   $0x222,(%esp)
 29f:	e8 84 03 00 00       	call   628 <thread_create>

void bounded_buffer_test(int num_of_producers,int num_of_consumers){
  int i;
  void* current_stack;
  buf = BB_create(4);
  for(i = 0; i < num_of_producers; i++){
 2a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 2a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ab:	3b 45 08             	cmp    0x8(%ebp),%eax
 2ae:	7c ca                	jl     27a <bounded_buffer_test+0x20>
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme4,current_stack,STACK_SIZE);
  }
  for(i = 0; i < num_of_consumers; i++){
 2b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2b7:	eb 2e                	jmp    2e7 <bounded_buffer_test+0x8d>
      current_stack = (void*)malloc(STACK_SIZE);
 2b9:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
 2c0:	e8 5e 07 00 00       	call   a23 <malloc>
 2c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      thread_create((void*)printme5,current_stack,STACK_SIZE);
 2c8:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
 2cf:	00 
 2d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d7:	c7 04 24 45 02 00 00 	movl   $0x245,(%esp)
 2de:	e8 45 03 00 00       	call   628 <thread_create>
  buf = BB_create(4);
  for(i = 0; i < num_of_producers; i++){
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme4,current_stack,STACK_SIZE);
  }
  for(i = 0; i < num_of_consumers; i++){
 2e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 2e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2ed:	7c ca                	jl     2b9 <bounded_buffer_test+0x5f>
      current_stack = (void*)malloc(STACK_SIZE);
      thread_create((void*)printme5,current_stack,STACK_SIZE);
  }
}
 2ef:	c9                   	leave  
 2f0:	c3                   	ret    

000002f1 <main>:

int main(int argc, char** argv){
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp
 2f4:	83 e4 f0             	and    $0xfffffff0,%esp
 2f7:	83 ec 20             	sub    $0x20,%esp
  //task1_test();
  int num_of_threads;
  num_of_threads = atoi(argv[1]);
 2fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fd:	83 c0 04             	add    $0x4,%eax
 300:	8b 00                	mov    (%eax),%eax
 302:	89 04 24             	mov    %eax,(%esp)
 305:	e8 ed 01 00 00       	call   4f7 <atoi>
 30a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  binary_semaphore_test(num_of_threads);
 30e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 312:	89 04 24             	mov    %eax,(%esp)
 315:	e8 fa fd ff ff       	call   114 <binary_semaphore_test>
  //counting_semaphore_test(num_of_threads);
  //bounded_buffer_test(num_of_threads,num_of_threads);
  wait(); //main thread should not cross that line (program never finishes)
 31a:	e8 71 02 00 00       	call   590 <wait>
  exit();
 31f:	e8 64 02 00 00       	call   588 <exit>

00000324 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	57                   	push   %edi
 328:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 329:	8b 4d 08             	mov    0x8(%ebp),%ecx
 32c:	8b 55 10             	mov    0x10(%ebp),%edx
 32f:	8b 45 0c             	mov    0xc(%ebp),%eax
 332:	89 cb                	mov    %ecx,%ebx
 334:	89 df                	mov    %ebx,%edi
 336:	89 d1                	mov    %edx,%ecx
 338:	fc                   	cld    
 339:	f3 aa                	rep stos %al,%es:(%edi)
 33b:	89 ca                	mov    %ecx,%edx
 33d:	89 fb                	mov    %edi,%ebx
 33f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 342:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 345:	5b                   	pop    %ebx
 346:	5f                   	pop    %edi
 347:	5d                   	pop    %ebp
 348:	c3                   	ret    

00000349 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 349:	55                   	push   %ebp
 34a:	89 e5                	mov    %esp,%ebp
 34c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 355:	90                   	nop
 356:	8b 45 0c             	mov    0xc(%ebp),%eax
 359:	0f b6 10             	movzbl (%eax),%edx
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	88 10                	mov    %dl,(%eax)
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	0f b6 00             	movzbl (%eax),%eax
 367:	84 c0                	test   %al,%al
 369:	0f 95 c0             	setne  %al
 36c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 370:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 374:	84 c0                	test   %al,%al
 376:	75 de                	jne    356 <strcpy+0xd>
    ;
  return os;
 378:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 37b:	c9                   	leave  
 37c:	c3                   	ret    

0000037d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 37d:	55                   	push   %ebp
 37e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 380:	eb 08                	jmp    38a <strcmp+0xd>
    p++, q++;
 382:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 386:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	0f b6 00             	movzbl (%eax),%eax
 390:	84 c0                	test   %al,%al
 392:	74 10                	je     3a4 <strcmp+0x27>
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	0f b6 10             	movzbl (%eax),%edx
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	0f b6 00             	movzbl (%eax),%eax
 3a0:	38 c2                	cmp    %al,%dl
 3a2:	74 de                	je     382 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	0f b6 00             	movzbl (%eax),%eax
 3aa:	0f b6 d0             	movzbl %al,%edx
 3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b0:	0f b6 00             	movzbl (%eax),%eax
 3b3:	0f b6 c0             	movzbl %al,%eax
 3b6:	89 d1                	mov    %edx,%ecx
 3b8:	29 c1                	sub    %eax,%ecx
 3ba:	89 c8                	mov    %ecx,%eax
}
 3bc:	5d                   	pop    %ebp
 3bd:	c3                   	ret    

000003be <strlen>:

uint
strlen(char *s)
{
 3be:	55                   	push   %ebp
 3bf:	89 e5                	mov    %esp,%ebp
 3c1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3cb:	eb 04                	jmp    3d1 <strlen+0x13>
 3cd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d4:	03 45 08             	add    0x8(%ebp),%eax
 3d7:	0f b6 00             	movzbl (%eax),%eax
 3da:	84 c0                	test   %al,%al
 3dc:	75 ef                	jne    3cd <strlen+0xf>
    ;
  return n;
 3de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e1:	c9                   	leave  
 3e2:	c3                   	ret    

000003e3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e3:	55                   	push   %ebp
 3e4:	89 e5                	mov    %esp,%ebp
 3e6:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 3e9:	8b 45 10             	mov    0x10(%ebp),%eax
 3ec:	89 44 24 08          	mov    %eax,0x8(%esp)
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	89 04 24             	mov    %eax,(%esp)
 3fd:	e8 22 ff ff ff       	call   324 <stosb>
  return dst;
 402:	8b 45 08             	mov    0x8(%ebp),%eax
}
 405:	c9                   	leave  
 406:	c3                   	ret    

00000407 <strchr>:

char*
strchr(const char *s, char c)
{
 407:	55                   	push   %ebp
 408:	89 e5                	mov    %esp,%ebp
 40a:	83 ec 04             	sub    $0x4,%esp
 40d:	8b 45 0c             	mov    0xc(%ebp),%eax
 410:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 413:	eb 14                	jmp    429 <strchr+0x22>
    if(*s == c)
 415:	8b 45 08             	mov    0x8(%ebp),%eax
 418:	0f b6 00             	movzbl (%eax),%eax
 41b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 41e:	75 05                	jne    425 <strchr+0x1e>
      return (char*)s;
 420:	8b 45 08             	mov    0x8(%ebp),%eax
 423:	eb 13                	jmp    438 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 425:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 429:	8b 45 08             	mov    0x8(%ebp),%eax
 42c:	0f b6 00             	movzbl (%eax),%eax
 42f:	84 c0                	test   %al,%al
 431:	75 e2                	jne    415 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 433:	b8 00 00 00 00       	mov    $0x0,%eax
}
 438:	c9                   	leave  
 439:	c3                   	ret    

0000043a <gets>:

char*
gets(char *buf, int max)
{
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 440:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 447:	eb 44                	jmp    48d <gets+0x53>
    cc = read(0, &c, 1);
 449:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 450:	00 
 451:	8d 45 ef             	lea    -0x11(%ebp),%eax
 454:	89 44 24 04          	mov    %eax,0x4(%esp)
 458:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 45f:	e8 3c 01 00 00       	call   5a0 <read>
 464:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 46b:	7e 2d                	jle    49a <gets+0x60>
      break;
    buf[i++] = c;
 46d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 470:	03 45 08             	add    0x8(%ebp),%eax
 473:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 477:	88 10                	mov    %dl,(%eax)
 479:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 47d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 481:	3c 0a                	cmp    $0xa,%al
 483:	74 16                	je     49b <gets+0x61>
 485:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 489:	3c 0d                	cmp    $0xd,%al
 48b:	74 0e                	je     49b <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 48d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 490:	83 c0 01             	add    $0x1,%eax
 493:	3b 45 0c             	cmp    0xc(%ebp),%eax
 496:	7c b1                	jl     449 <gets+0xf>
 498:	eb 01                	jmp    49b <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 49a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 49b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49e:	03 45 08             	add    0x8(%ebp),%eax
 4a1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a7:	c9                   	leave  
 4a8:	c3                   	ret    

000004a9 <stat>:

int
stat(char *n, struct stat *st)
{
 4a9:	55                   	push   %ebp
 4aa:	89 e5                	mov    %esp,%ebp
 4ac:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4b6:	00 
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	89 04 24             	mov    %eax,(%esp)
 4bd:	e8 06 01 00 00       	call   5c8 <open>
 4c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c9:	79 07                	jns    4d2 <stat+0x29>
    return -1;
 4cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4d0:	eb 23                	jmp    4f5 <stat+0x4c>
  r = fstat(fd, st);
 4d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4dc:	89 04 24             	mov    %eax,(%esp)
 4df:	e8 fc 00 00 00       	call   5e0 <fstat>
 4e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ea:	89 04 24             	mov    %eax,(%esp)
 4ed:	e8 be 00 00 00       	call   5b0 <close>
  return r;
 4f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4f5:	c9                   	leave  
 4f6:	c3                   	ret    

000004f7 <atoi>:

int
atoi(const char *s)
{
 4f7:	55                   	push   %ebp
 4f8:	89 e5                	mov    %esp,%ebp
 4fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 504:	eb 23                	jmp    529 <atoi+0x32>
    n = n*10 + *s++ - '0';
 506:	8b 55 fc             	mov    -0x4(%ebp),%edx
 509:	89 d0                	mov    %edx,%eax
 50b:	c1 e0 02             	shl    $0x2,%eax
 50e:	01 d0                	add    %edx,%eax
 510:	01 c0                	add    %eax,%eax
 512:	89 c2                	mov    %eax,%edx
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	0f b6 00             	movzbl (%eax),%eax
 51a:	0f be c0             	movsbl %al,%eax
 51d:	01 d0                	add    %edx,%eax
 51f:	83 e8 30             	sub    $0x30,%eax
 522:	89 45 fc             	mov    %eax,-0x4(%ebp)
 525:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 529:	8b 45 08             	mov    0x8(%ebp),%eax
 52c:	0f b6 00             	movzbl (%eax),%eax
 52f:	3c 2f                	cmp    $0x2f,%al
 531:	7e 0a                	jle    53d <atoi+0x46>
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	0f b6 00             	movzbl (%eax),%eax
 539:	3c 39                	cmp    $0x39,%al
 53b:	7e c9                	jle    506 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 53d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 540:	c9                   	leave  
 541:	c3                   	ret    

00000542 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 542:	55                   	push   %ebp
 543:	89 e5                	mov    %esp,%ebp
 545:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 54e:	8b 45 0c             	mov    0xc(%ebp),%eax
 551:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 554:	eb 13                	jmp    569 <memmove+0x27>
    *dst++ = *src++;
 556:	8b 45 f8             	mov    -0x8(%ebp),%eax
 559:	0f b6 10             	movzbl (%eax),%edx
 55c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 55f:	88 10                	mov    %dl,(%eax)
 561:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 565:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 569:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 56d:	0f 9f c0             	setg   %al
 570:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 574:	84 c0                	test   %al,%al
 576:	75 de                	jne    556 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 578:	8b 45 08             	mov    0x8(%ebp),%eax
}
 57b:	c9                   	leave  
 57c:	c3                   	ret    
 57d:	90                   	nop
 57e:	90                   	nop
 57f:	90                   	nop

00000580 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 580:	b8 01 00 00 00       	mov    $0x1,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <exit>:
SYSCALL(exit)
 588:	b8 02 00 00 00       	mov    $0x2,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <wait>:
SYSCALL(wait)
 590:	b8 03 00 00 00       	mov    $0x3,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <pipe>:
SYSCALL(pipe)
 598:	b8 04 00 00 00       	mov    $0x4,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <read>:
SYSCALL(read)
 5a0:	b8 05 00 00 00       	mov    $0x5,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <write>:
SYSCALL(write)
 5a8:	b8 10 00 00 00       	mov    $0x10,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <close>:
SYSCALL(close)
 5b0:	b8 15 00 00 00       	mov    $0x15,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <kill>:
SYSCALL(kill)
 5b8:	b8 06 00 00 00       	mov    $0x6,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <exec>:
SYSCALL(exec)
 5c0:	b8 07 00 00 00       	mov    $0x7,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <open>:
SYSCALL(open)
 5c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <mknod>:
SYSCALL(mknod)
 5d0:	b8 11 00 00 00       	mov    $0x11,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <unlink>:
SYSCALL(unlink)
 5d8:	b8 12 00 00 00       	mov    $0x12,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <fstat>:
SYSCALL(fstat)
 5e0:	b8 08 00 00 00       	mov    $0x8,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <link>:
SYSCALL(link)
 5e8:	b8 13 00 00 00       	mov    $0x13,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <mkdir>:
SYSCALL(mkdir)
 5f0:	b8 14 00 00 00       	mov    $0x14,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <chdir>:
SYSCALL(chdir)
 5f8:	b8 09 00 00 00       	mov    $0x9,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <dup>:
SYSCALL(dup)
 600:	b8 0a 00 00 00       	mov    $0xa,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <getpid>:
SYSCALL(getpid)
 608:	b8 0b 00 00 00       	mov    $0xb,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <sbrk>:
SYSCALL(sbrk)
 610:	b8 0c 00 00 00       	mov    $0xc,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <sleep>:
SYSCALL(sleep)
 618:	b8 0d 00 00 00       	mov    $0xd,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <uptime>:
SYSCALL(uptime)
 620:	b8 0e 00 00 00       	mov    $0xe,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <thread_create>:
SYSCALL(thread_create)
 628:	b8 16 00 00 00       	mov    $0x16,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <thread_getId>:
SYSCALL(thread_getId)
 630:	b8 17 00 00 00       	mov    $0x17,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <thread_getProcId>:
SYSCALL(thread_getProcId)
 638:	b8 18 00 00 00       	mov    $0x18,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <thread_join>:
SYSCALL(thread_join)
 640:	b8 19 00 00 00       	mov    $0x19,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <thread_exit>:
SYSCALL(thread_exit)
 648:	b8 1a 00 00 00       	mov    $0x1a,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
 650:	b8 1b 00 00 00       	mov    $0x1b,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
 658:	b8 1c 00 00 00       	mov    $0x1c,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
 660:	b8 1d 00 00 00       	mov    $0x1d,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 668:	55                   	push   %ebp
 669:	89 e5                	mov    %esp,%ebp
 66b:	83 ec 28             	sub    $0x28,%esp
 66e:	8b 45 0c             	mov    0xc(%ebp),%eax
 671:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 674:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 67b:	00 
 67c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 67f:	89 44 24 04          	mov    %eax,0x4(%esp)
 683:	8b 45 08             	mov    0x8(%ebp),%eax
 686:	89 04 24             	mov    %eax,(%esp)
 689:	e8 1a ff ff ff       	call   5a8 <write>
}
 68e:	c9                   	leave  
 68f:	c3                   	ret    

00000690 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 696:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 69d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6a1:	74 17                	je     6ba <printint+0x2a>
 6a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6a7:	79 11                	jns    6ba <printint+0x2a>
    neg = 1;
 6a9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b3:	f7 d8                	neg    %eax
 6b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b8:	eb 06                	jmp    6c0 <printint+0x30>
  } else {
    x = xx;
 6ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6cd:	ba 00 00 00 00       	mov    $0x0,%edx
 6d2:	f7 f1                	div    %ecx
 6d4:	89 d0                	mov    %edx,%eax
 6d6:	0f b6 90 cc 13 00 00 	movzbl 0x13cc(%eax),%edx
 6dd:	8d 45 dc             	lea    -0x24(%ebp),%eax
 6e0:	03 45 f4             	add    -0xc(%ebp),%eax
 6e3:	88 10                	mov    %dl,(%eax)
 6e5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 6e9:	8b 55 10             	mov    0x10(%ebp),%edx
 6ec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6f2:	ba 00 00 00 00       	mov    $0x0,%edx
 6f7:	f7 75 d4             	divl   -0x2c(%ebp)
 6fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 701:	75 c4                	jne    6c7 <printint+0x37>
  if(neg)
 703:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 707:	74 2a                	je     733 <printint+0xa3>
    buf[i++] = '-';
 709:	8d 45 dc             	lea    -0x24(%ebp),%eax
 70c:	03 45 f4             	add    -0xc(%ebp),%eax
 70f:	c6 00 2d             	movb   $0x2d,(%eax)
 712:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 716:	eb 1b                	jmp    733 <printint+0xa3>
    putc(fd, buf[i]);
 718:	8d 45 dc             	lea    -0x24(%ebp),%eax
 71b:	03 45 f4             	add    -0xc(%ebp),%eax
 71e:	0f b6 00             	movzbl (%eax),%eax
 721:	0f be c0             	movsbl %al,%eax
 724:	89 44 24 04          	mov    %eax,0x4(%esp)
 728:	8b 45 08             	mov    0x8(%ebp),%eax
 72b:	89 04 24             	mov    %eax,(%esp)
 72e:	e8 35 ff ff ff       	call   668 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 733:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 73b:	79 db                	jns    718 <printint+0x88>
    putc(fd, buf[i]);
}
 73d:	c9                   	leave  
 73e:	c3                   	ret    

0000073f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 73f:	55                   	push   %ebp
 740:	89 e5                	mov    %esp,%ebp
 742:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 745:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 74c:	8d 45 0c             	lea    0xc(%ebp),%eax
 74f:	83 c0 04             	add    $0x4,%eax
 752:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 75c:	e9 7d 01 00 00       	jmp    8de <printf+0x19f>
    c = fmt[i] & 0xff;
 761:	8b 55 0c             	mov    0xc(%ebp),%edx
 764:	8b 45 f0             	mov    -0x10(%ebp),%eax
 767:	01 d0                	add    %edx,%eax
 769:	0f b6 00             	movzbl (%eax),%eax
 76c:	0f be c0             	movsbl %al,%eax
 76f:	25 ff 00 00 00       	and    $0xff,%eax
 774:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 777:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 77b:	75 2c                	jne    7a9 <printf+0x6a>
      if(c == '%'){
 77d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 781:	75 0c                	jne    78f <printf+0x50>
        state = '%';
 783:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 78a:	e9 4b 01 00 00       	jmp    8da <printf+0x19b>
      } else {
        putc(fd, c);
 78f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 792:	0f be c0             	movsbl %al,%eax
 795:	89 44 24 04          	mov    %eax,0x4(%esp)
 799:	8b 45 08             	mov    0x8(%ebp),%eax
 79c:	89 04 24             	mov    %eax,(%esp)
 79f:	e8 c4 fe ff ff       	call   668 <putc>
 7a4:	e9 31 01 00 00       	jmp    8da <printf+0x19b>
      }
    } else if(state == '%'){
 7a9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7ad:	0f 85 27 01 00 00    	jne    8da <printf+0x19b>
      if(c == 'd'){
 7b3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7b7:	75 2d                	jne    7e6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bc:	8b 00                	mov    (%eax),%eax
 7be:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7c5:	00 
 7c6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7cd:	00 
 7ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d2:	8b 45 08             	mov    0x8(%ebp),%eax
 7d5:	89 04 24             	mov    %eax,(%esp)
 7d8:	e8 b3 fe ff ff       	call   690 <printint>
        ap++;
 7dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e1:	e9 ed 00 00 00       	jmp    8d3 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 7e6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7ea:	74 06                	je     7f2 <printf+0xb3>
 7ec:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7f0:	75 2d                	jne    81f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f5:	8b 00                	mov    (%eax),%eax
 7f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7fe:	00 
 7ff:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 806:	00 
 807:	89 44 24 04          	mov    %eax,0x4(%esp)
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	89 04 24             	mov    %eax,(%esp)
 811:	e8 7a fe ff ff       	call   690 <printint>
        ap++;
 816:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 81a:	e9 b4 00 00 00       	jmp    8d3 <printf+0x194>
      } else if(c == 's'){
 81f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 823:	75 46                	jne    86b <printf+0x12c>
        s = (char*)*ap;
 825:	8b 45 e8             	mov    -0x18(%ebp),%eax
 828:	8b 00                	mov    (%eax),%eax
 82a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 82d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 835:	75 27                	jne    85e <printf+0x11f>
          s = "(null)";
 837:	c7 45 f4 f5 0e 00 00 	movl   $0xef5,-0xc(%ebp)
        while(*s != 0){
 83e:	eb 1e                	jmp    85e <printf+0x11f>
          putc(fd, *s);
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	0f b6 00             	movzbl (%eax),%eax
 846:	0f be c0             	movsbl %al,%eax
 849:	89 44 24 04          	mov    %eax,0x4(%esp)
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
 850:	89 04 24             	mov    %eax,(%esp)
 853:	e8 10 fe ff ff       	call   668 <putc>
          s++;
 858:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 85c:	eb 01                	jmp    85f <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 85e:	90                   	nop
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	0f b6 00             	movzbl (%eax),%eax
 865:	84 c0                	test   %al,%al
 867:	75 d7                	jne    840 <printf+0x101>
 869:	eb 68                	jmp    8d3 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 86b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 86f:	75 1d                	jne    88e <printf+0x14f>
        putc(fd, *ap);
 871:	8b 45 e8             	mov    -0x18(%ebp),%eax
 874:	8b 00                	mov    (%eax),%eax
 876:	0f be c0             	movsbl %al,%eax
 879:	89 44 24 04          	mov    %eax,0x4(%esp)
 87d:	8b 45 08             	mov    0x8(%ebp),%eax
 880:	89 04 24             	mov    %eax,(%esp)
 883:	e8 e0 fd ff ff       	call   668 <putc>
        ap++;
 888:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 88c:	eb 45                	jmp    8d3 <printf+0x194>
      } else if(c == '%'){
 88e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 892:	75 17                	jne    8ab <printf+0x16c>
        putc(fd, c);
 894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 897:	0f be c0             	movsbl %al,%eax
 89a:	89 44 24 04          	mov    %eax,0x4(%esp)
 89e:	8b 45 08             	mov    0x8(%ebp),%eax
 8a1:	89 04 24             	mov    %eax,(%esp)
 8a4:	e8 bf fd ff ff       	call   668 <putc>
 8a9:	eb 28                	jmp    8d3 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8ab:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8b2:	00 
 8b3:	8b 45 08             	mov    0x8(%ebp),%eax
 8b6:	89 04 24             	mov    %eax,(%esp)
 8b9:	e8 aa fd ff ff       	call   668 <putc>
        putc(fd, c);
 8be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c1:	0f be c0             	movsbl %al,%eax
 8c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c8:	8b 45 08             	mov    0x8(%ebp),%eax
 8cb:	89 04 24             	mov    %eax,(%esp)
 8ce:	e8 95 fd ff ff       	call   668 <putc>
      }
      state = 0;
 8d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8de:	8b 55 0c             	mov    0xc(%ebp),%edx
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	01 d0                	add    %edx,%eax
 8e6:	0f b6 00             	movzbl (%eax),%eax
 8e9:	84 c0                	test   %al,%al
 8eb:	0f 85 70 fe ff ff    	jne    761 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8f1:	c9                   	leave  
 8f2:	c3                   	ret    
 8f3:	90                   	nop

000008f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8fa:	8b 45 08             	mov    0x8(%ebp),%eax
 8fd:	83 e8 08             	sub    $0x8,%eax
 900:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 903:	a1 e8 13 00 00       	mov    0x13e8,%eax
 908:	89 45 fc             	mov    %eax,-0x4(%ebp)
 90b:	eb 24                	jmp    931 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	8b 00                	mov    (%eax),%eax
 912:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 915:	77 12                	ja     929 <free+0x35>
 917:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91d:	77 24                	ja     943 <free+0x4f>
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 927:	77 1a                	ja     943 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 931:	8b 45 f8             	mov    -0x8(%ebp),%eax
 934:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 937:	76 d4                	jbe    90d <free+0x19>
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 00                	mov    (%eax),%eax
 93e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 941:	76 ca                	jbe    90d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 943:	8b 45 f8             	mov    -0x8(%ebp),%eax
 946:	8b 40 04             	mov    0x4(%eax),%eax
 949:	c1 e0 03             	shl    $0x3,%eax
 94c:	89 c2                	mov    %eax,%edx
 94e:	03 55 f8             	add    -0x8(%ebp),%edx
 951:	8b 45 fc             	mov    -0x4(%ebp),%eax
 954:	8b 00                	mov    (%eax),%eax
 956:	39 c2                	cmp    %eax,%edx
 958:	75 24                	jne    97e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 95a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95d:	8b 50 04             	mov    0x4(%eax),%edx
 960:	8b 45 fc             	mov    -0x4(%ebp),%eax
 963:	8b 00                	mov    (%eax),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	01 c2                	add    %eax,%edx
 96a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	8b 00                	mov    (%eax),%eax
 975:	8b 10                	mov    (%eax),%edx
 977:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97a:	89 10                	mov    %edx,(%eax)
 97c:	eb 0a                	jmp    988 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	8b 10                	mov    (%eax),%edx
 983:	8b 45 f8             	mov    -0x8(%ebp),%eax
 986:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 988:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98b:	8b 40 04             	mov    0x4(%eax),%eax
 98e:	c1 e0 03             	shl    $0x3,%eax
 991:	03 45 fc             	add    -0x4(%ebp),%eax
 994:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 997:	75 20                	jne    9b9 <free+0xc5>
    p->s.size += bp->s.size;
 999:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99c:	8b 50 04             	mov    0x4(%eax),%edx
 99f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a2:	8b 40 04             	mov    0x4(%eax),%eax
 9a5:	01 c2                	add    %eax,%edx
 9a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9aa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b0:	8b 10                	mov    (%eax),%edx
 9b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b5:	89 10                	mov    %edx,(%eax)
 9b7:	eb 08                	jmp    9c1 <free+0xcd>
  } else
    p->s.ptr = bp;
 9b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9bf:	89 10                	mov    %edx,(%eax)
  freep = p;
 9c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c4:	a3 e8 13 00 00       	mov    %eax,0x13e8
}
 9c9:	c9                   	leave  
 9ca:	c3                   	ret    

000009cb <morecore>:

static Header*
morecore(uint nu)
{
 9cb:	55                   	push   %ebp
 9cc:	89 e5                	mov    %esp,%ebp
 9ce:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9d8:	77 07                	ja     9e1 <morecore+0x16>
    nu = 4096;
 9da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9e1:	8b 45 08             	mov    0x8(%ebp),%eax
 9e4:	c1 e0 03             	shl    $0x3,%eax
 9e7:	89 04 24             	mov    %eax,(%esp)
 9ea:	e8 21 fc ff ff       	call   610 <sbrk>
 9ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9f2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9f6:	75 07                	jne    9ff <morecore+0x34>
    return 0;
 9f8:	b8 00 00 00 00       	mov    $0x0,%eax
 9fd:	eb 22                	jmp    a21 <morecore+0x56>
  hp = (Header*)p;
 9ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a08:	8b 55 08             	mov    0x8(%ebp),%edx
 a0b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a11:	83 c0 08             	add    $0x8,%eax
 a14:	89 04 24             	mov    %eax,(%esp)
 a17:	e8 d8 fe ff ff       	call   8f4 <free>
  return freep;
 a1c:	a1 e8 13 00 00       	mov    0x13e8,%eax
}
 a21:	c9                   	leave  
 a22:	c3                   	ret    

00000a23 <malloc>:

void*
malloc(uint nbytes)
{
 a23:	55                   	push   %ebp
 a24:	89 e5                	mov    %esp,%ebp
 a26:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a29:	8b 45 08             	mov    0x8(%ebp),%eax
 a2c:	83 c0 07             	add    $0x7,%eax
 a2f:	c1 e8 03             	shr    $0x3,%eax
 a32:	83 c0 01             	add    $0x1,%eax
 a35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a38:	a1 e8 13 00 00       	mov    0x13e8,%eax
 a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a44:	75 23                	jne    a69 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a46:	c7 45 f0 e0 13 00 00 	movl   $0x13e0,-0x10(%ebp)
 a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a50:	a3 e8 13 00 00       	mov    %eax,0x13e8
 a55:	a1 e8 13 00 00       	mov    0x13e8,%eax
 a5a:	a3 e0 13 00 00       	mov    %eax,0x13e0
    base.s.size = 0;
 a5f:	c7 05 e4 13 00 00 00 	movl   $0x0,0x13e4
 a66:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6c:	8b 00                	mov    (%eax),%eax
 a6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a74:	8b 40 04             	mov    0x4(%eax),%eax
 a77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a7a:	72 4d                	jb     ac9 <malloc+0xa6>
      if(p->s.size == nunits)
 a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7f:	8b 40 04             	mov    0x4(%eax),%eax
 a82:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a85:	75 0c                	jne    a93 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8a:	8b 10                	mov    (%eax),%edx
 a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8f:	89 10                	mov    %edx,(%eax)
 a91:	eb 26                	jmp    ab9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a96:	8b 40 04             	mov    0x4(%eax),%eax
 a99:	89 c2                	mov    %eax,%edx
 a9b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa7:	8b 40 04             	mov    0x4(%eax),%eax
 aaa:	c1 e0 03             	shl    $0x3,%eax
 aad:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ab6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abc:	a3 e8 13 00 00       	mov    %eax,0x13e8
      return (void*)(p + 1);
 ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac4:	83 c0 08             	add    $0x8,%eax
 ac7:	eb 38                	jmp    b01 <malloc+0xde>
    }
    if(p == freep)
 ac9:	a1 e8 13 00 00       	mov    0x13e8,%eax
 ace:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ad1:	75 1b                	jne    aee <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ad6:	89 04 24             	mov    %eax,(%esp)
 ad9:	e8 ed fe ff ff       	call   9cb <morecore>
 ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ae1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ae5:	75 07                	jne    aee <malloc+0xcb>
        return 0;
 ae7:	b8 00 00 00 00       	mov    $0x0,%eax
 aec:	eb 13                	jmp    b01 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af7:	8b 00                	mov    (%eax),%eax
 af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 afc:	e9 70 ff ff ff       	jmp    a71 <malloc+0x4e>
}
 b01:	c9                   	leave  
 b02:	c3                   	ret    
 b03:	90                   	nop

00000b04 <semaphore_create>:
#include "semaphore.h"
#include "types.h"
#include "user.h"


struct semaphore* semaphore_create(int initial_semaphore_value){
 b04:	55                   	push   %ebp
 b05:	89 e5                	mov    %esp,%ebp
 b07:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* sem=malloc(sizeof(struct semaphore)); 
 b0a:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
 b11:	e8 0d ff ff ff       	call   a23 <malloc>
 b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // acquire semaphors
  sem->s1 = binary_semaphore_create(1);
 b19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b20:	e8 2b fb ff ff       	call   650 <binary_semaphore_create>
 b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b28:	89 02                	mov    %eax,(%edx)
  
  // s2 should be initialized with the min{1,initial_semaphore_value}
  if(initial_semaphore_value >= 1){
 b2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 b2e:	7e 14                	jle    b44 <semaphore_create+0x40>
    sem->s2 = binary_semaphore_create(1);
 b30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b37:	e8 14 fb ff ff       	call   650 <binary_semaphore_create>
 b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b3f:	89 42 04             	mov    %eax,0x4(%edx)
 b42:	eb 11                	jmp    b55 <semaphore_create+0x51>
  }else{
    sem->s2 = binary_semaphore_create(initial_semaphore_value);
 b44:	8b 45 08             	mov    0x8(%ebp),%eax
 b47:	89 04 24             	mov    %eax,(%esp)
 b4a:	e8 01 fb ff ff       	call   650 <binary_semaphore_create>
 b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b52:	89 42 04             	mov    %eax,0x4(%edx)
  }
  
  if(sem->s1 == -1 || sem->s2 == -1){
 b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b58:	8b 00                	mov    (%eax),%eax
 b5a:	83 f8 ff             	cmp    $0xffffffff,%eax
 b5d:	74 0b                	je     b6a <semaphore_create+0x66>
 b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b62:	8b 40 04             	mov    0x4(%eax),%eax
 b65:	83 f8 ff             	cmp    $0xffffffff,%eax
 b68:	75 26                	jne    b90 <semaphore_create+0x8c>
     printf(1,"we had a probalem initialize in semaphore_create\n");
 b6a:	c7 44 24 04 fc 0e 00 	movl   $0xefc,0x4(%esp)
 b71:	00 
 b72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b79:	e8 c1 fb ff ff       	call   73f <printf>
     free(sem);
 b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b81:	89 04 24             	mov    %eax,(%esp)
 b84:	e8 6b fd ff ff       	call   8f4 <free>
     return 0;
 b89:	b8 00 00 00 00       	mov    $0x0,%eax
 b8e:	eb 15                	jmp    ba5 <semaphore_create+0xa1>
  }
  //initialize value
  sem->value = initial_semaphore_value;//dynamic
 b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b93:	8b 55 08             	mov    0x8(%ebp),%edx
 b96:	89 50 08             	mov    %edx,0x8(%eax)
  sem->initial_value = initial_semaphore_value;//static
 b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9c:	8b 55 08             	mov    0x8(%ebp),%edx
 b9f:	89 50 0c             	mov    %edx,0xc(%eax)
  
  return sem;
 ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 ba5:	c9                   	leave  
 ba6:	c3                   	ret    

00000ba7 <semaphore_down>:
void semaphore_down(struct semaphore* sem ){
 ba7:	55                   	push   %ebp
 ba8:	89 e5                	mov    %esp,%ebp
 baa:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s2);
 bad:	8b 45 08             	mov    0x8(%ebp),%eax
 bb0:	8b 40 04             	mov    0x4(%eax),%eax
 bb3:	89 04 24             	mov    %eax,(%esp)
 bb6:	e8 9d fa ff ff       	call   658 <binary_semaphore_down>
  binary_semaphore_down(sem->s1);
 bbb:	8b 45 08             	mov    0x8(%ebp),%eax
 bbe:	8b 00                	mov    (%eax),%eax
 bc0:	89 04 24             	mov    %eax,(%esp)
 bc3:	e8 90 fa ff ff       	call   658 <binary_semaphore_down>
  sem->value--;	
 bc8:	8b 45 08             	mov    0x8(%ebp),%eax
 bcb:	8b 40 08             	mov    0x8(%eax),%eax
 bce:	8d 50 ff             	lea    -0x1(%eax),%edx
 bd1:	8b 45 08             	mov    0x8(%ebp),%eax
 bd4:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value > 0){
 bd7:	8b 45 08             	mov    0x8(%ebp),%eax
 bda:	8b 40 08             	mov    0x8(%eax),%eax
 bdd:	85 c0                	test   %eax,%eax
 bdf:	7e 0e                	jle    bef <semaphore_down+0x48>
   binary_semaphore_up(sem->s2);
 be1:	8b 45 08             	mov    0x8(%ebp),%eax
 be4:	8b 40 04             	mov    0x4(%eax),%eax
 be7:	89 04 24             	mov    %eax,(%esp)
 bea:	e8 71 fa ff ff       	call   660 <binary_semaphore_up>
  }
  binary_semaphore_up(sem->s1); 
 bef:	8b 45 08             	mov    0x8(%ebp),%eax
 bf2:	8b 00                	mov    (%eax),%eax
 bf4:	89 04 24             	mov    %eax,(%esp)
 bf7:	e8 64 fa ff ff       	call   660 <binary_semaphore_up>
}
 bfc:	c9                   	leave  
 bfd:	c3                   	ret    

00000bfe <semaphore_up>:
void semaphore_up(struct semaphore* sem ){
 bfe:	55                   	push   %ebp
 bff:	89 e5                	mov    %esp,%ebp
 c01:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
 c04:	8b 45 08             	mov    0x8(%ebp),%eax
 c07:	8b 00                	mov    (%eax),%eax
 c09:	89 04 24             	mov    %eax,(%esp)
 c0c:	e8 47 fa ff ff       	call   658 <binary_semaphore_down>
  sem->value++;	
 c11:	8b 45 08             	mov    0x8(%ebp),%eax
 c14:	8b 40 08             	mov    0x8(%eax),%eax
 c17:	8d 50 01             	lea    0x1(%eax),%edx
 c1a:	8b 45 08             	mov    0x8(%ebp),%eax
 c1d:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value ==1){
 c20:	8b 45 08             	mov    0x8(%ebp),%eax
 c23:	8b 40 08             	mov    0x8(%eax),%eax
 c26:	83 f8 01             	cmp    $0x1,%eax
 c29:	75 0e                	jne    c39 <semaphore_up+0x3b>
   binary_semaphore_up(sem->s2); 
 c2b:	8b 45 08             	mov    0x8(%ebp),%eax
 c2e:	8b 40 04             	mov    0x4(%eax),%eax
 c31:	89 04 24             	mov    %eax,(%esp)
 c34:	e8 27 fa ff ff       	call   660 <binary_semaphore_up>
   }
  binary_semaphore_up(sem->s1);
 c39:	8b 45 08             	mov    0x8(%ebp),%eax
 c3c:	8b 00                	mov    (%eax),%eax
 c3e:	89 04 24             	mov    %eax,(%esp)
 c41:	e8 1a fa ff ff       	call   660 <binary_semaphore_up>
}
 c46:	c9                   	leave  
 c47:	c3                   	ret    

00000c48 <semaphore_free>:

void semaphore_free(struct semaphore* sem){
 c48:	55                   	push   %ebp
 c49:	89 e5                	mov    %esp,%ebp
 c4b:	83 ec 18             	sub    $0x18,%esp
  free(sem);
 c4e:	8b 45 08             	mov    0x8(%ebp),%eax
 c51:	89 04 24             	mov    %eax,(%esp)
 c54:	e8 9b fc ff ff       	call   8f4 <free>
}
 c59:	c9                   	leave  
 c5a:	c3                   	ret    
 c5b:	90                   	nop

00000c5c <BB_create>:
#include "types.h"
#include "user.h"


struct BB* 
BB_create(int max_capacity){
 c5c:	55                   	push   %ebp
 c5d:	89 e5                	mov    %esp,%ebp
 c5f:	83 ec 38             	sub    $0x38,%esp
  //initialize
  struct BB* buf = malloc(sizeof(struct BB));
 c62:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
 c69:	e8 b5 fd ff ff       	call   a23 <malloc>
 c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
 c71:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 c78:	00 
 c79:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 c80:	00 
 c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c84:	89 04 24             	mov    %eax,(%esp)
 c87:	e8 57 f7 ff ff       	call   3e3 <memset>
 
  buf->buffer_size = max_capacity;
 c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c8f:	8b 55 08             	mov    0x8(%ebp),%edx
 c92:	89 10                	mov    %edx,(%eax)
  buf->mutex = binary_semaphore_create(1);  
 c94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c9b:	e8 b0 f9 ff ff       	call   650 <binary_semaphore_create>
 ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ca3:	89 42 04             	mov    %eax,0x4(%edx)
  buf->empty = semaphore_create(max_capacity);
 ca6:	8b 45 08             	mov    0x8(%ebp),%eax
 ca9:	89 04 24             	mov    %eax,(%esp)
 cac:	e8 53 fe ff ff       	call   b04 <semaphore_create>
 cb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 cb4:	89 42 08             	mov    %eax,0x8(%edx)
  buf->full = semaphore_create(0);
 cb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 cbe:	e8 41 fe ff ff       	call   b04 <semaphore_create>
 cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 cc6:	89 42 0c             	mov    %eax,0xc(%edx)
  
  //void** elements_array = (void**)malloc(sizeof(void*) * max_capacity); 
  //memset(buf->elements_array,0,sizeof(void*)*max_capacity);
  //buf->pointer_to_elements = elements_array;  
  
  buf->pointer_to_elements = malloc(sizeof(void*)*max_capacity);
 cc9:	8b 45 08             	mov    0x8(%ebp),%eax
 ccc:	c1 e0 02             	shl    $0x2,%eax
 ccf:	89 04 24             	mov    %eax,(%esp)
 cd2:	e8 4c fd ff ff       	call   a23 <malloc>
 cd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 cda:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->pointer_to_elements,0,sizeof(void*)*max_capacity);
 cdd:	8b 45 08             	mov    0x8(%ebp),%eax
 ce0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cea:	8b 40 1c             	mov    0x1c(%eax),%eax
 ced:	89 54 24 08          	mov    %edx,0x8(%esp)
 cf1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 cf8:	00 
 cf9:	89 04 24             	mov    %eax,(%esp)
 cfc:	e8 e2 f6 ff ff       	call   3e3 <memset>
  
  buf->count = 0;
 d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d04:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  //check the semaphorses
  if(buf->mutex == -1 || buf->empty == 0 || buf->full == 0){
 d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d0e:	8b 40 04             	mov    0x4(%eax),%eax
 d11:	83 f8 ff             	cmp    $0xffffffff,%eax
 d14:	74 14                	je     d2a <BB_create+0xce>
 d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d19:	8b 40 08             	mov    0x8(%eax),%eax
 d1c:	85 c0                	test   %eax,%eax
 d1e:	74 0a                	je     d2a <BB_create+0xce>
 d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d23:	8b 40 0c             	mov    0xc(%eax),%eax
 d26:	85 c0                	test   %eax,%eax
 d28:	75 52                	jne    d7c <BB_create+0x120>
   printf(1,"we had a problam getting semaphores at BB create mutex %d empty %d full %d\n",buf->mutex,buf->empty,buf->full);
 d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2d:	8b 48 0c             	mov    0xc(%eax),%ecx
 d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d33:	8b 50 08             	mov    0x8(%eax),%edx
 d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d39:	8b 40 04             	mov    0x4(%eax),%eax
 d3c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 d40:	89 54 24 0c          	mov    %edx,0xc(%esp)
 d44:	89 44 24 08          	mov    %eax,0x8(%esp)
 d48:	c7 44 24 04 30 0f 00 	movl   $0xf30,0x4(%esp)
 d4f:	00 
 d50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d57:	e8 e3 f9 ff ff       	call   73f <printf>
   free(buf->pointer_to_elements);
 d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d5f:	8b 40 1c             	mov    0x1c(%eax),%eax
 d62:	89 04 24             	mov    %eax,(%esp)
 d65:	e8 8a fb ff ff       	call   8f4 <free>
   free(buf);
 d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d6d:	89 04 24             	mov    %eax,(%esp)
 d70:	e8 7f fb ff ff       	call   8f4 <free>
   buf =0;  
 d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  }
  return buf;
 d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 d7f:	c9                   	leave  
 d80:	c3                   	ret    

00000d81 <BB_put>:

void BB_put(struct BB* bb, void* element)
{ 
 d81:	55                   	push   %ebp
 d82:	89 e5                	mov    %esp,%ebp
 d84:	83 ec 18             	sub    $0x18,%esp
  bb->pointer_to_elements[bb->count] = element;
  bb->count++;
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->full);
  */
  semaphore_down(bb->empty);
 d87:	8b 45 08             	mov    0x8(%ebp),%eax
 d8a:	8b 40 08             	mov    0x8(%eax),%eax
 d8d:	89 04 24             	mov    %eax,(%esp)
 d90:	e8 12 fe ff ff       	call   ba7 <semaphore_down>
  binary_semaphore_down(bb->mutex);
 d95:	8b 45 08             	mov    0x8(%ebp),%eax
 d98:	8b 40 04             	mov    0x4(%eax),%eax
 d9b:	89 04 24             	mov    %eax,(%esp)
 d9e:	e8 b5 f8 ff ff       	call   658 <binary_semaphore_down>
   //insert item
  bb->pointer_to_elements[bb->end] = element;
 da3:	8b 45 08             	mov    0x8(%ebp),%eax
 da6:	8b 50 1c             	mov    0x1c(%eax),%edx
 da9:	8b 45 08             	mov    0x8(%ebp),%eax
 dac:	8b 40 18             	mov    0x18(%eax),%eax
 daf:	c1 e0 02             	shl    $0x2,%eax
 db2:	01 c2                	add    %eax,%edx
 db4:	8b 45 0c             	mov    0xc(%ebp),%eax
 db7:	89 02                	mov    %eax,(%edx)
  ++bb->end;
 db9:	8b 45 08             	mov    0x8(%ebp),%eax
 dbc:	8b 40 18             	mov    0x18(%eax),%eax
 dbf:	8d 50 01             	lea    0x1(%eax),%edx
 dc2:	8b 45 08             	mov    0x8(%ebp),%eax
 dc5:	89 50 18             	mov    %edx,0x18(%eax)
  bb->end = bb->end%bb->buffer_size;
 dc8:	8b 45 08             	mov    0x8(%ebp),%eax
 dcb:	8b 40 18             	mov    0x18(%eax),%eax
 dce:	8b 55 08             	mov    0x8(%ebp),%edx
 dd1:	8b 0a                	mov    (%edx),%ecx
 dd3:	89 c2                	mov    %eax,%edx
 dd5:	c1 fa 1f             	sar    $0x1f,%edx
 dd8:	f7 f9                	idiv   %ecx
 dda:	8b 45 08             	mov    0x8(%ebp),%eax
 ddd:	89 50 18             	mov    %edx,0x18(%eax)
  binary_semaphore_up(bb->mutex);
 de0:	8b 45 08             	mov    0x8(%ebp),%eax
 de3:	8b 40 04             	mov    0x4(%eax),%eax
 de6:	89 04 24             	mov    %eax,(%esp)
 de9:	e8 72 f8 ff ff       	call   660 <binary_semaphore_up>
  semaphore_up(bb->full);
 dee:	8b 45 08             	mov    0x8(%ebp),%eax
 df1:	8b 40 0c             	mov    0xc(%eax),%eax
 df4:	89 04 24             	mov    %eax,(%esp)
 df7:	e8 02 fe ff ff       	call   bfe <semaphore_up>
    
}
 dfc:	c9                   	leave  
 dfd:	c3                   	ret    

00000dfe <BB_pop>:

void* BB_pop(struct BB* bb)
{
 dfe:	55                   	push   %ebp
 dff:	89 e5                	mov    %esp,%ebp
 e01:	83 ec 28             	sub    $0x28,%esp
  
  void* element_to_pop;
  semaphore_down(bb->full);
 e04:	8b 45 08             	mov    0x8(%ebp),%eax
 e07:	8b 40 0c             	mov    0xc(%eax),%eax
 e0a:	89 04 24             	mov    %eax,(%esp)
 e0d:	e8 95 fd ff ff       	call   ba7 <semaphore_down>
  binary_semaphore_down(bb->mutex);
 e12:	8b 45 08             	mov    0x8(%ebp),%eax
 e15:	8b 40 04             	mov    0x4(%eax),%eax
 e18:	89 04 24             	mov    %eax,(%esp)
 e1b:	e8 38 f8 ff ff       	call   658 <binary_semaphore_down>
  element_to_pop = bb-> pointer_to_elements[bb->start];
 e20:	8b 45 08             	mov    0x8(%ebp),%eax
 e23:	8b 50 1c             	mov    0x1c(%eax),%edx
 e26:	8b 45 08             	mov    0x8(%ebp),%eax
 e29:	8b 40 14             	mov    0x14(%eax),%eax
 e2c:	c1 e0 02             	shl    $0x2,%eax
 e2f:	01 d0                	add    %edx,%eax
 e31:	8b 00                	mov    (%eax),%eax
 e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->pointer_to_elements[bb->start] =0;
 e36:	8b 45 08             	mov    0x8(%ebp),%eax
 e39:	8b 50 1c             	mov    0x1c(%eax),%edx
 e3c:	8b 45 08             	mov    0x8(%ebp),%eax
 e3f:	8b 40 14             	mov    0x14(%eax),%eax
 e42:	c1 e0 02             	shl    $0x2,%eax
 e45:	01 d0                	add    %edx,%eax
 e47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
 e4d:	8b 45 08             	mov    0x8(%ebp),%eax
 e50:	8b 40 14             	mov    0x14(%eax),%eax
 e53:	8d 50 01             	lea    0x1(%eax),%edx
 e56:	8b 45 08             	mov    0x8(%ebp),%eax
 e59:	89 50 14             	mov    %edx,0x14(%eax)
  bb->start = bb->start%bb->buffer_size;
 e5c:	8b 45 08             	mov    0x8(%ebp),%eax
 e5f:	8b 40 14             	mov    0x14(%eax),%eax
 e62:	8b 55 08             	mov    0x8(%ebp),%edx
 e65:	8b 0a                	mov    (%edx),%ecx
 e67:	89 c2                	mov    %eax,%edx
 e69:	c1 fa 1f             	sar    $0x1f,%edx
 e6c:	f7 f9                	idiv   %ecx
 e6e:	8b 45 08             	mov    0x8(%ebp),%eax
 e71:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
 e74:	8b 45 08             	mov    0x8(%ebp),%eax
 e77:	8b 40 04             	mov    0x4(%eax),%eax
 e7a:	89 04 24             	mov    %eax,(%esp)
 e7d:	e8 de f7 ff ff       	call   660 <binary_semaphore_up>
  semaphore_up(bb->empty);
 e82:	8b 45 08             	mov    0x8(%ebp),%eax
 e85:	8b 40 08             	mov    0x8(%eax),%eax
 e88:	89 04 24             	mov    %eax,(%esp)
 e8b:	e8 6e fd ff ff       	call   bfe <semaphore_up>
  return element_to_pop;
 e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->empty);
  
  return element_to_pop;*/
}
 e93:	c9                   	leave  
 e94:	c3                   	ret    

00000e95 <BB_free>:

void BB_free(struct BB* bb){
 e95:	55                   	push   %ebp
 e96:	89 e5                	mov    %esp,%ebp
 e98:	83 ec 18             	sub    $0x18,%esp
  free(bb->pointer_to_elements);
 e9b:	8b 45 08             	mov    0x8(%ebp),%eax
 e9e:	8b 40 1c             	mov    0x1c(%eax),%eax
 ea1:	89 04 24             	mov    %eax,(%esp)
 ea4:	e8 4b fa ff ff       	call   8f4 <free>
  free(bb);
 ea9:	8b 45 08             	mov    0x8(%ebp),%eax
 eac:	89 04 24             	mov    %eax,(%esp)
 eaf:	e8 40 fa ff ff       	call   8f4 <free>
 eb4:	c9                   	leave  
 eb5:	c3                   	ret    
