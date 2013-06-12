
_swaptest:     file format elf32-i386


Disassembly of section .text:

00000000 <swappedOut_blocked_test>:

#define MAX_ALLOCATION 0x80000000

void* my_memory;

void swappedOut_blocked_test(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int pid;
  pid = fork();
   6:	e8 41 04 00 00       	call   44c <fork>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == 0){ //child process
   e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  12:	75 29                	jne    3d <swappedOut_blocked_test+0x3d>
    printf(1,"Process %d is sleeping\n",getpid());
  14:	e8 bb 04 00 00       	call   4d4 <getpid>
  19:	89 44 24 08          	mov    %eax,0x8(%esp)
  1d:	c7 44 24 04 d0 09 00 	movl   $0x9d0,0x4(%esp)
  24:	00 
  25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  2c:	e8 da 05 00 00       	call   60b <printf>
    sleep(500);
  31:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  38:	e8 a7 04 00 00       	call   4e4 <sleep>
  }
  
  my_memory = sbrk(MAX_ALLOCATION);
  3d:	c7 04 24 00 00 00 80 	movl   $0x80000000,(%esp)
  44:	e8 93 04 00 00       	call   4dc <sbrk>
  49:	a3 cc 0d 00 00       	mov    %eax,0xdcc
  if(pid == 0){ //child process exit
  4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  52:	75 12                	jne    66 <swappedOut_blocked_test+0x66>
    free(my_memory);
  54:	a1 cc 0d 00 00       	mov    0xdcc,%eax
  59:	89 04 24             	mov    %eax,(%esp)
  5c:	e8 5f 07 00 00       	call   7c0 <free>
    exit();
  61:	e8 ee 03 00 00       	call   454 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:




int main(int argc, char** argv){
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int parent_pid = getpid();
  71:	e8 5e 04 00 00       	call   4d4 <getpid>
  76:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  int pages_count;
  
  printf(1,"enableSwapping\n");
  7a:	c7 44 24 04 e8 09 00 	movl   $0x9e8,0x4(%esp)
  81:	00 
  82:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  89:	e8 7d 05 00 00       	call   60b <printf>
  enableSwapping();
  8e:	e8 61 04 00 00       	call   4f4 <enableSwapping>
  pid = fork();
  93:	e8 b4 03 00 00       	call   44c <fork>
  98:	89 44 24 18          	mov    %eax,0x18(%esp)
  if(pid == 0){
  9c:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  a1:	75 70                	jne    113 <main+0xab>
    
    sleep(300);
  a3:	c7 04 24 2c 01 00 00 	movl   $0x12c,(%esp)
  aa:	e8 35 04 00 00       	call   4e4 <sleep>
    pages_count = num_of_pages(parent_pid);
  af:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  b3:	89 04 24             	mov    %eax,(%esp)
  b6:	e8 49 04 00 00       	call   504 <num_of_pages>
  bb:	89 44 24 14          	mov    %eax,0x14(%esp)
    printf(1,"parent nummber of pages while swaping enabled: %d\n",pages_count);
  bf:	8b 44 24 14          	mov    0x14(%esp),%eax
  c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  c7:	c7 44 24 04 f8 09 00 	movl   $0x9f8,0x4(%esp)
  ce:	00 
  cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d6:	e8 30 05 00 00       	call   60b <printf>
    printf(1,"child %d do ls- we expect to see %d.swap (parent_pid)\n",getpid(),parent_pid);
  db:	e8 f4 03 00 00       	call   4d4 <getpid>
  e0:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  ec:	c7 44 24 04 2c 0a 00 	movl   $0xa2c,0x4(%esp)
  f3:	00 
  f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fb:	e8 0b 05 00 00       	call   60b <printf>
    exec("ls",argv);
 100:	8b 45 0c             	mov    0xc(%ebp),%eax
 103:	89 44 24 04          	mov    %eax,0x4(%esp)
 107:	c7 04 24 63 0a 00 00 	movl   $0xa63,(%esp)
 10e:	e8 79 03 00 00       	call   48c <exec>
    }
  
  
  printf(1,"parent is wating and will be swaped out\n");
 113:	c7 44 24 04 68 0a 00 	movl   $0xa68,0x4(%esp)
 11a:	00 
 11b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 122:	e8 e4 04 00 00       	call   60b <printf>
  while (wait() != -1){} //main thread should not cross that line (program never finishes)
 127:	90                   	nop
 128:	e8 2f 03 00 00       	call   45c <wait>
 12d:	83 f8 ff             	cmp    $0xffffffff,%eax
 130:	75 f6                	jne    128 <main+0xc0>
  
////////////////////////part 2 after disabling
  printf(1,"disbleSwapping\n");
 132:	c7 44 24 04 91 0a 00 	movl   $0xa91,0x4(%esp)
 139:	00 
 13a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 141:	e8 c5 04 00 00       	call   60b <printf>
  disableSwapping();
 146:	e8 b1 03 00 00       	call   4fc <disableSwapping>
  pid = fork();
 14b:	e8 fc 02 00 00       	call   44c <fork>
 150:	89 44 24 18          	mov    %eax,0x18(%esp)
  if(pid == 0){
 154:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 159:	75 70                	jne    1cb <main+0x163>
    
    sleep(800);
 15b:	c7 04 24 20 03 00 00 	movl   $0x320,(%esp)
 162:	e8 7d 03 00 00       	call   4e4 <sleep>
    pages_count = num_of_pages(parent_pid);
 167:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 16b:	89 04 24             	mov    %eax,(%esp)
 16e:	e8 91 03 00 00       	call   504 <num_of_pages>
 173:	89 44 24 14          	mov    %eax,0x14(%esp)
    printf(1,"parent nummber of pages while swaping disabled: %d\n",pages_count);
 177:	8b 44 24 14          	mov    0x14(%esp),%eax
 17b:	89 44 24 08          	mov    %eax,0x8(%esp)
 17f:	c7 44 24 04 a4 0a 00 	movl   $0xaa4,0x4(%esp)
 186:	00 
 187:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18e:	e8 78 04 00 00       	call   60b <printf>
    printf(1,"child %d do ls- we expect NOT to see %d.swap (the parent_pid.swap)\n",getpid(),parent_pid);
 193:	e8 3c 03 00 00       	call   4d4 <getpid>
 198:	8b 54 24 1c          	mov    0x1c(%esp),%edx
 19c:	89 54 24 0c          	mov    %edx,0xc(%esp)
 1a0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a4:	c7 44 24 04 d8 0a 00 	movl   $0xad8,0x4(%esp)
 1ab:	00 
 1ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b3:	e8 53 04 00 00       	call   60b <printf>
    exec("ls",argv);
 1b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bf:	c7 04 24 63 0a 00 00 	movl   $0xa63,(%esp)
 1c6:	e8 c1 02 00 00       	call   48c <exec>
    }
  
  printf(1,"parent is wating and will not be swaped out\n");
 1cb:	c7 44 24 04 1c 0b 00 	movl   $0xb1c,0x4(%esp)
 1d2:	00 
 1d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1da:	e8 2c 04 00 00       	call   60b <printf>
  while (wait() != -1){} //main thread should not cross that line (program never finishes)
 1df:	90                   	nop
 1e0:	e8 77 02 00 00       	call   45c <wait>
 1e5:	83 f8 ff             	cmp    $0xffffffff,%eax
 1e8:	75 f6                	jne    1e0 <main+0x178>
  
  
  
  
  
  exit();
 1ea:	e8 65 02 00 00       	call   454 <exit>
 1ef:	90                   	nop

000001f0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1f8:	8b 55 10             	mov    0x10(%ebp),%edx
 1fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fe:	89 cb                	mov    %ecx,%ebx
 200:	89 df                	mov    %ebx,%edi
 202:	89 d1                	mov    %edx,%ecx
 204:	fc                   	cld    
 205:	f3 aa                	rep stos %al,%es:(%edi)
 207:	89 ca                	mov    %ecx,%edx
 209:	89 fb                	mov    %edi,%ebx
 20b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 20e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 211:	5b                   	pop    %ebx
 212:	5f                   	pop    %edi
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    

00000215 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 215:	55                   	push   %ebp
 216:	89 e5                	mov    %esp,%ebp
 218:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 221:	90                   	nop
 222:	8b 45 0c             	mov    0xc(%ebp),%eax
 225:	0f b6 10             	movzbl (%eax),%edx
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	88 10                	mov    %dl,(%eax)
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	84 c0                	test   %al,%al
 235:	0f 95 c0             	setne  %al
 238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 240:	84 c0                	test   %al,%al
 242:	75 de                	jne    222 <strcpy+0xd>
    ;
  return os;
 244:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 247:	c9                   	leave  
 248:	c3                   	ret    

00000249 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 249:	55                   	push   %ebp
 24a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 24c:	eb 08                	jmp    256 <strcmp+0xd>
    p++, q++;
 24e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 252:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	84 c0                	test   %al,%al
 25e:	74 10                	je     270 <strcmp+0x27>
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	0f b6 10             	movzbl (%eax),%edx
 266:	8b 45 0c             	mov    0xc(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	38 c2                	cmp    %al,%dl
 26e:	74 de                	je     24e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	0f b6 d0             	movzbl %al,%edx
 279:	8b 45 0c             	mov    0xc(%ebp),%eax
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	0f b6 c0             	movzbl %al,%eax
 282:	89 d1                	mov    %edx,%ecx
 284:	29 c1                	sub    %eax,%ecx
 286:	89 c8                	mov    %ecx,%eax
}
 288:	5d                   	pop    %ebp
 289:	c3                   	ret    

0000028a <strlen>:

uint
strlen(char *s)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 290:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 297:	eb 04                	jmp    29d <strlen+0x13>
 299:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a0:	03 45 08             	add    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	84 c0                	test   %al,%al
 2a8:	75 ef                	jne    299 <strlen+0xf>
    ;
  return n;
 2aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ad:	c9                   	leave  
 2ae:	c3                   	ret    

000002af <memset>:

void*
memset(void *dst, int c, uint n)
{
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
 2b2:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2b5:	8b 45 10             	mov    0x10(%ebp),%eax
 2b8:	89 44 24 08          	mov    %eax,0x8(%esp)
 2bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	89 04 24             	mov    %eax,(%esp)
 2c9:	e8 22 ff ff ff       	call   1f0 <stosb>
  return dst;
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d1:	c9                   	leave  
 2d2:	c3                   	ret    

000002d3 <strchr>:

char*
strchr(const char *s, char c)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	83 ec 04             	sub    $0x4,%esp
 2d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2dc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2df:	eb 14                	jmp    2f5 <strchr+0x22>
    if(*s == c)
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	0f b6 00             	movzbl (%eax),%eax
 2e7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2ea:	75 05                	jne    2f1 <strchr+0x1e>
      return (char*)s;
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	eb 13                	jmp    304 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2f1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	0f b6 00             	movzbl (%eax),%eax
 2fb:	84 c0                	test   %al,%al
 2fd:	75 e2                	jne    2e1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
 304:	c9                   	leave  
 305:	c3                   	ret    

00000306 <gets>:

char*
gets(char *buf, int max)
{
 306:	55                   	push   %ebp
 307:	89 e5                	mov    %esp,%ebp
 309:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 30c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 313:	eb 44                	jmp    359 <gets+0x53>
    cc = read(0, &c, 1);
 315:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 31c:	00 
 31d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 320:	89 44 24 04          	mov    %eax,0x4(%esp)
 324:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 32b:	e8 3c 01 00 00       	call   46c <read>
 330:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 333:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 337:	7e 2d                	jle    366 <gets+0x60>
      break;
    buf[i++] = c;
 339:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33c:	03 45 08             	add    0x8(%ebp),%eax
 33f:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 343:	88 10                	mov    %dl,(%eax)
 345:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 349:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 34d:	3c 0a                	cmp    $0xa,%al
 34f:	74 16                	je     367 <gets+0x61>
 351:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 355:	3c 0d                	cmp    $0xd,%al
 357:	74 0e                	je     367 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 359:	8b 45 f4             	mov    -0xc(%ebp),%eax
 35c:	83 c0 01             	add    $0x1,%eax
 35f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 362:	7c b1                	jl     315 <gets+0xf>
 364:	eb 01                	jmp    367 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 366:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 367:	8b 45 f4             	mov    -0xc(%ebp),%eax
 36a:	03 45 08             	add    0x8(%ebp),%eax
 36d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 370:	8b 45 08             	mov    0x8(%ebp),%eax
}
 373:	c9                   	leave  
 374:	c3                   	ret    

00000375 <stat>:

int
stat(char *n, struct stat *st)
{
 375:	55                   	push   %ebp
 376:	89 e5                	mov    %esp,%ebp
 378:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 382:	00 
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	89 04 24             	mov    %eax,(%esp)
 389:	e8 06 01 00 00       	call   494 <open>
 38e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 395:	79 07                	jns    39e <stat+0x29>
    return -1;
 397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 39c:	eb 23                	jmp    3c1 <stat+0x4c>
  r = fstat(fd, st);
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a8:	89 04 24             	mov    %eax,(%esp)
 3ab:	e8 fc 00 00 00       	call   4ac <fstat>
 3b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b6:	89 04 24             	mov    %eax,(%esp)
 3b9:	e8 be 00 00 00       	call   47c <close>
  return r;
 3be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3c1:	c9                   	leave  
 3c2:	c3                   	ret    

000003c3 <atoi>:

int
atoi(const char *s)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3d0:	eb 23                	jmp    3f5 <atoi+0x32>
    n = n*10 + *s++ - '0';
 3d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d5:	89 d0                	mov    %edx,%eax
 3d7:	c1 e0 02             	shl    $0x2,%eax
 3da:	01 d0                	add    %edx,%eax
 3dc:	01 c0                	add    %eax,%eax
 3de:	89 c2                	mov    %eax,%edx
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	0f b6 00             	movzbl (%eax),%eax
 3e6:	0f be c0             	movsbl %al,%eax
 3e9:	01 d0                	add    %edx,%eax
 3eb:	83 e8 30             	sub    $0x30,%eax
 3ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3f1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
 3f8:	0f b6 00             	movzbl (%eax),%eax
 3fb:	3c 2f                	cmp    $0x2f,%al
 3fd:	7e 0a                	jle    409 <atoi+0x46>
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
 402:	0f b6 00             	movzbl (%eax),%eax
 405:	3c 39                	cmp    $0x39,%al
 407:	7e c9                	jle    3d2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 409:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 40c:	c9                   	leave  
 40d:	c3                   	ret    

0000040e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 420:	eb 13                	jmp    435 <memmove+0x27>
    *dst++ = *src++;
 422:	8b 45 f8             	mov    -0x8(%ebp),%eax
 425:	0f b6 10             	movzbl (%eax),%edx
 428:	8b 45 fc             	mov    -0x4(%ebp),%eax
 42b:	88 10                	mov    %dl,(%eax)
 42d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 431:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 435:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 439:	0f 9f c0             	setg   %al
 43c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 440:	84 c0                	test   %al,%al
 442:	75 de                	jne    422 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 444:	8b 45 08             	mov    0x8(%ebp),%eax
}
 447:	c9                   	leave  
 448:	c3                   	ret    
 449:	90                   	nop
 44a:	90                   	nop
 44b:	90                   	nop

0000044c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 44c:	b8 01 00 00 00       	mov    $0x1,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <exit>:
SYSCALL(exit)
 454:	b8 02 00 00 00       	mov    $0x2,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <wait>:
SYSCALL(wait)
 45c:	b8 03 00 00 00       	mov    $0x3,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <pipe>:
SYSCALL(pipe)
 464:	b8 04 00 00 00       	mov    $0x4,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <read>:
SYSCALL(read)
 46c:	b8 05 00 00 00       	mov    $0x5,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <write>:
SYSCALL(write)
 474:	b8 10 00 00 00       	mov    $0x10,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <close>:
SYSCALL(close)
 47c:	b8 15 00 00 00       	mov    $0x15,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <kill>:
SYSCALL(kill)
 484:	b8 06 00 00 00       	mov    $0x6,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <exec>:
SYSCALL(exec)
 48c:	b8 07 00 00 00       	mov    $0x7,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <open>:
SYSCALL(open)
 494:	b8 0f 00 00 00       	mov    $0xf,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <mknod>:
SYSCALL(mknod)
 49c:	b8 11 00 00 00       	mov    $0x11,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <unlink>:
SYSCALL(unlink)
 4a4:	b8 12 00 00 00       	mov    $0x12,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <fstat>:
SYSCALL(fstat)
 4ac:	b8 08 00 00 00       	mov    $0x8,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <link>:
SYSCALL(link)
 4b4:	b8 13 00 00 00       	mov    $0x13,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <mkdir>:
SYSCALL(mkdir)
 4bc:	b8 14 00 00 00       	mov    $0x14,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <chdir>:
SYSCALL(chdir)
 4c4:	b8 09 00 00 00       	mov    $0x9,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <dup>:
SYSCALL(dup)
 4cc:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <getpid>:
SYSCALL(getpid)
 4d4:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <sbrk>:
SYSCALL(sbrk)
 4dc:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <sleep>:
SYSCALL(sleep)
 4e4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <uptime>:
SYSCALL(uptime)
 4ec:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <enableSwapping>:
SYSCALL(enableSwapping)
 4f4:	b8 16 00 00 00       	mov    $0x16,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <disableSwapping>:
SYSCALL(disableSwapping)
 4fc:	b8 17 00 00 00       	mov    $0x17,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <num_of_pages>:
SYSCALL(num_of_pages)
 504:	b8 18 00 00 00       	mov    $0x18,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <shmget>:
SYSCALL(shmget)
 50c:	b8 19 00 00 00       	mov    $0x19,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <shmdel>:
SYSCALL(shmdel)
 514:	b8 1a 00 00 00       	mov    $0x1a,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <shmat>:
SYSCALL(shmat)
 51c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <shmdt>:
SYSCALL(shmdt)
 524:	b8 1c 00 00 00       	mov    $0x1c,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <get_share_memory_address>:
 52c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	83 ec 28             	sub    $0x28,%esp
 53a:	8b 45 0c             	mov    0xc(%ebp),%eax
 53d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 540:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 547:	00 
 548:	8d 45 f4             	lea    -0xc(%ebp),%eax
 54b:	89 44 24 04          	mov    %eax,0x4(%esp)
 54f:	8b 45 08             	mov    0x8(%ebp),%eax
 552:	89 04 24             	mov    %eax,(%esp)
 555:	e8 1a ff ff ff       	call   474 <write>
}
 55a:	c9                   	leave  
 55b:	c3                   	ret    

0000055c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55c:	55                   	push   %ebp
 55d:	89 e5                	mov    %esp,%ebp
 55f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 562:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 569:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 56d:	74 17                	je     586 <printint+0x2a>
 56f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 573:	79 11                	jns    586 <printint+0x2a>
    neg = 1;
 575:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 57c:	8b 45 0c             	mov    0xc(%ebp),%eax
 57f:	f7 d8                	neg    %eax
 581:	89 45 ec             	mov    %eax,-0x14(%ebp)
 584:	eb 06                	jmp    58c <printint+0x30>
  } else {
    x = xx;
 586:	8b 45 0c             	mov    0xc(%ebp),%eax
 589:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 58c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 593:	8b 4d 10             	mov    0x10(%ebp),%ecx
 596:	8b 45 ec             	mov    -0x14(%ebp),%eax
 599:	ba 00 00 00 00       	mov    $0x0,%edx
 59e:	f7 f1                	div    %ecx
 5a0:	89 d0                	mov    %edx,%eax
 5a2:	0f b6 90 ac 0d 00 00 	movzbl 0xdac(%eax),%edx
 5a9:	8d 45 dc             	lea    -0x24(%ebp),%eax
 5ac:	03 45 f4             	add    -0xc(%ebp),%eax
 5af:	88 10                	mov    %dl,(%eax)
 5b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 5b5:	8b 55 10             	mov    0x10(%ebp),%edx
 5b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5be:	ba 00 00 00 00       	mov    $0x0,%edx
 5c3:	f7 75 d4             	divl   -0x2c(%ebp)
 5c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5cd:	75 c4                	jne    593 <printint+0x37>
  if(neg)
 5cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d3:	74 2a                	je     5ff <printint+0xa3>
    buf[i++] = '-';
 5d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
 5d8:	03 45 f4             	add    -0xc(%ebp),%eax
 5db:	c6 00 2d             	movb   $0x2d,(%eax)
 5de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 5e2:	eb 1b                	jmp    5ff <printint+0xa3>
    putc(fd, buf[i]);
 5e4:	8d 45 dc             	lea    -0x24(%ebp),%eax
 5e7:	03 45 f4             	add    -0xc(%ebp),%eax
 5ea:	0f b6 00             	movzbl (%eax),%eax
 5ed:	0f be c0             	movsbl %al,%eax
 5f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f4:	8b 45 08             	mov    0x8(%ebp),%eax
 5f7:	89 04 24             	mov    %eax,(%esp)
 5fa:	e8 35 ff ff ff       	call   534 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ff:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 607:	79 db                	jns    5e4 <printint+0x88>
    putc(fd, buf[i]);
}
 609:	c9                   	leave  
 60a:	c3                   	ret    

0000060b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 60b:	55                   	push   %ebp
 60c:	89 e5                	mov    %esp,%ebp
 60e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 611:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 618:	8d 45 0c             	lea    0xc(%ebp),%eax
 61b:	83 c0 04             	add    $0x4,%eax
 61e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 621:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 628:	e9 7d 01 00 00       	jmp    7aa <printf+0x19f>
    c = fmt[i] & 0xff;
 62d:	8b 55 0c             	mov    0xc(%ebp),%edx
 630:	8b 45 f0             	mov    -0x10(%ebp),%eax
 633:	01 d0                	add    %edx,%eax
 635:	0f b6 00             	movzbl (%eax),%eax
 638:	0f be c0             	movsbl %al,%eax
 63b:	25 ff 00 00 00       	and    $0xff,%eax
 640:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 643:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 647:	75 2c                	jne    675 <printf+0x6a>
      if(c == '%'){
 649:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64d:	75 0c                	jne    65b <printf+0x50>
        state = '%';
 64f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 656:	e9 4b 01 00 00       	jmp    7a6 <printf+0x19b>
      } else {
        putc(fd, c);
 65b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65e:	0f be c0             	movsbl %al,%eax
 661:	89 44 24 04          	mov    %eax,0x4(%esp)
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	89 04 24             	mov    %eax,(%esp)
 66b:	e8 c4 fe ff ff       	call   534 <putc>
 670:	e9 31 01 00 00       	jmp    7a6 <printf+0x19b>
      }
    } else if(state == '%'){
 675:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 679:	0f 85 27 01 00 00    	jne    7a6 <printf+0x19b>
      if(c == 'd'){
 67f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 683:	75 2d                	jne    6b2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 685:	8b 45 e8             	mov    -0x18(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 691:	00 
 692:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 699:	00 
 69a:	89 44 24 04          	mov    %eax,0x4(%esp)
 69e:	8b 45 08             	mov    0x8(%ebp),%eax
 6a1:	89 04 24             	mov    %eax,(%esp)
 6a4:	e8 b3 fe ff ff       	call   55c <printint>
        ap++;
 6a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ad:	e9 ed 00 00 00       	jmp    79f <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 6b2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6b6:	74 06                	je     6be <printf+0xb3>
 6b8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6bc:	75 2d                	jne    6eb <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c1:	8b 00                	mov    (%eax),%eax
 6c3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6ca:	00 
 6cb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6d2:	00 
 6d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d7:	8b 45 08             	mov    0x8(%ebp),%eax
 6da:	89 04 24             	mov    %eax,(%esp)
 6dd:	e8 7a fe ff ff       	call   55c <printint>
        ap++;
 6e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e6:	e9 b4 00 00 00       	jmp    79f <printf+0x194>
      } else if(c == 's'){
 6eb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6ef:	75 46                	jne    737 <printf+0x12c>
        s = (char*)*ap;
 6f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 701:	75 27                	jne    72a <printf+0x11f>
          s = "(null)";
 703:	c7 45 f4 49 0b 00 00 	movl   $0xb49,-0xc(%ebp)
        while(*s != 0){
 70a:	eb 1e                	jmp    72a <printf+0x11f>
          putc(fd, *s);
 70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70f:	0f b6 00             	movzbl (%eax),%eax
 712:	0f be c0             	movsbl %al,%eax
 715:	89 44 24 04          	mov    %eax,0x4(%esp)
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	89 04 24             	mov    %eax,(%esp)
 71f:	e8 10 fe ff ff       	call   534 <putc>
          s++;
 724:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 728:	eb 01                	jmp    72b <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 72a:	90                   	nop
 72b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72e:	0f b6 00             	movzbl (%eax),%eax
 731:	84 c0                	test   %al,%al
 733:	75 d7                	jne    70c <printf+0x101>
 735:	eb 68                	jmp    79f <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 737:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 73b:	75 1d                	jne    75a <printf+0x14f>
        putc(fd, *ap);
 73d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	0f be c0             	movsbl %al,%eax
 745:	89 44 24 04          	mov    %eax,0x4(%esp)
 749:	8b 45 08             	mov    0x8(%ebp),%eax
 74c:	89 04 24             	mov    %eax,(%esp)
 74f:	e8 e0 fd ff ff       	call   534 <putc>
        ap++;
 754:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 758:	eb 45                	jmp    79f <printf+0x194>
      } else if(c == '%'){
 75a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75e:	75 17                	jne    777 <printf+0x16c>
        putc(fd, c);
 760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 763:	0f be c0             	movsbl %al,%eax
 766:	89 44 24 04          	mov    %eax,0x4(%esp)
 76a:	8b 45 08             	mov    0x8(%ebp),%eax
 76d:	89 04 24             	mov    %eax,(%esp)
 770:	e8 bf fd ff ff       	call   534 <putc>
 775:	eb 28                	jmp    79f <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 777:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 77e:	00 
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	89 04 24             	mov    %eax,(%esp)
 785:	e8 aa fd ff ff       	call   534 <putc>
        putc(fd, c);
 78a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78d:	0f be c0             	movsbl %al,%eax
 790:	89 44 24 04          	mov    %eax,0x4(%esp)
 794:	8b 45 08             	mov    0x8(%ebp),%eax
 797:	89 04 24             	mov    %eax,(%esp)
 79a:	e8 95 fd ff ff       	call   534 <putc>
      }
      state = 0;
 79f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7a6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	01 d0                	add    %edx,%eax
 7b2:	0f b6 00             	movzbl (%eax),%eax
 7b5:	84 c0                	test   %al,%al
 7b7:	0f 85 70 fe ff ff    	jne    62d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7bd:	c9                   	leave  
 7be:	c3                   	ret    
 7bf:	90                   	nop

000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c6:	8b 45 08             	mov    0x8(%ebp),%eax
 7c9:	83 e8 08             	sub    $0x8,%eax
 7cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cf:	a1 c8 0d 00 00       	mov    0xdc8,%eax
 7d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d7:	eb 24                	jmp    7fd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e1:	77 12                	ja     7f5 <free+0x35>
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e9:	77 24                	ja     80f <free+0x4f>
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f3:	77 1a                	ja     80f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	8b 00                	mov    (%eax),%eax
 7fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 803:	76 d4                	jbe    7d9 <free+0x19>
 805:	8b 45 fc             	mov    -0x4(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80d:	76 ca                	jbe    7d9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 80f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 812:	8b 40 04             	mov    0x4(%eax),%eax
 815:	c1 e0 03             	shl    $0x3,%eax
 818:	89 c2                	mov    %eax,%edx
 81a:	03 55 f8             	add    -0x8(%ebp),%edx
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 00                	mov    (%eax),%eax
 822:	39 c2                	cmp    %eax,%edx
 824:	75 24                	jne    84a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	8b 50 04             	mov    0x4(%eax),%edx
 82c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82f:	8b 00                	mov    (%eax),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	01 c2                	add    %eax,%edx
 836:	8b 45 f8             	mov    -0x8(%ebp),%eax
 839:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 83c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83f:	8b 00                	mov    (%eax),%eax
 841:	8b 10                	mov    (%eax),%edx
 843:	8b 45 f8             	mov    -0x8(%ebp),%eax
 846:	89 10                	mov    %edx,(%eax)
 848:	eb 0a                	jmp    854 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 84a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84d:	8b 10                	mov    (%eax),%edx
 84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 852:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	8b 40 04             	mov    0x4(%eax),%eax
 85a:	c1 e0 03             	shl    $0x3,%eax
 85d:	03 45 fc             	add    -0x4(%ebp),%eax
 860:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 863:	75 20                	jne    885 <free+0xc5>
    p->s.size += bp->s.size;
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
 868:	8b 50 04             	mov    0x4(%eax),%edx
 86b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86e:	8b 40 04             	mov    0x4(%eax),%eax
 871:	01 c2                	add    %eax,%edx
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 879:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87c:	8b 10                	mov    (%eax),%edx
 87e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 881:	89 10                	mov    %edx,(%eax)
 883:	eb 08                	jmp    88d <free+0xcd>
  } else
    p->s.ptr = bp;
 885:	8b 45 fc             	mov    -0x4(%ebp),%eax
 888:	8b 55 f8             	mov    -0x8(%ebp),%edx
 88b:	89 10                	mov    %edx,(%eax)
  freep = p;
 88d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 890:	a3 c8 0d 00 00       	mov    %eax,0xdc8
}
 895:	c9                   	leave  
 896:	c3                   	ret    

00000897 <morecore>:

static Header*
morecore(uint nu)
{
 897:	55                   	push   %ebp
 898:	89 e5                	mov    %esp,%ebp
 89a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 89d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8a4:	77 07                	ja     8ad <morecore+0x16>
    nu = 4096;
 8a6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8ad:	8b 45 08             	mov    0x8(%ebp),%eax
 8b0:	c1 e0 03             	shl    $0x3,%eax
 8b3:	89 04 24             	mov    %eax,(%esp)
 8b6:	e8 21 fc ff ff       	call   4dc <sbrk>
 8bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8be:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8c2:	75 07                	jne    8cb <morecore+0x34>
    return 0;
 8c4:	b8 00 00 00 00       	mov    $0x0,%eax
 8c9:	eb 22                	jmp    8ed <morecore+0x56>
  hp = (Header*)p;
 8cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d4:	8b 55 08             	mov    0x8(%ebp),%edx
 8d7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8dd:	83 c0 08             	add    $0x8,%eax
 8e0:	89 04 24             	mov    %eax,(%esp)
 8e3:	e8 d8 fe ff ff       	call   7c0 <free>
  return freep;
 8e8:	a1 c8 0d 00 00       	mov    0xdc8,%eax
}
 8ed:	c9                   	leave  
 8ee:	c3                   	ret    

000008ef <malloc>:

void*
malloc(uint nbytes)
{
 8ef:	55                   	push   %ebp
 8f0:	89 e5                	mov    %esp,%ebp
 8f2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f5:	8b 45 08             	mov    0x8(%ebp),%eax
 8f8:	83 c0 07             	add    $0x7,%eax
 8fb:	c1 e8 03             	shr    $0x3,%eax
 8fe:	83 c0 01             	add    $0x1,%eax
 901:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 904:	a1 c8 0d 00 00       	mov    0xdc8,%eax
 909:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 910:	75 23                	jne    935 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 912:	c7 45 f0 c0 0d 00 00 	movl   $0xdc0,-0x10(%ebp)
 919:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91c:	a3 c8 0d 00 00       	mov    %eax,0xdc8
 921:	a1 c8 0d 00 00       	mov    0xdc8,%eax
 926:	a3 c0 0d 00 00       	mov    %eax,0xdc0
    base.s.size = 0;
 92b:	c7 05 c4 0d 00 00 00 	movl   $0x0,0xdc4
 932:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 935:	8b 45 f0             	mov    -0x10(%ebp),%eax
 938:	8b 00                	mov    (%eax),%eax
 93a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 940:	8b 40 04             	mov    0x4(%eax),%eax
 943:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 946:	72 4d                	jb     995 <malloc+0xa6>
      if(p->s.size == nunits)
 948:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94b:	8b 40 04             	mov    0x4(%eax),%eax
 94e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 951:	75 0c                	jne    95f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 956:	8b 10                	mov    (%eax),%edx
 958:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95b:	89 10                	mov    %edx,(%eax)
 95d:	eb 26                	jmp    985 <malloc+0x96>
      else {
        p->s.size -= nunits;
 95f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 962:	8b 40 04             	mov    0x4(%eax),%eax
 965:	89 c2                	mov    %eax,%edx
 967:	2b 55 ec             	sub    -0x14(%ebp),%edx
 96a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 970:	8b 45 f4             	mov    -0xc(%ebp),%eax
 973:	8b 40 04             	mov    0x4(%eax),%eax
 976:	c1 e0 03             	shl    $0x3,%eax
 979:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 97c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 982:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 985:	8b 45 f0             	mov    -0x10(%ebp),%eax
 988:	a3 c8 0d 00 00       	mov    %eax,0xdc8
      return (void*)(p + 1);
 98d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 990:	83 c0 08             	add    $0x8,%eax
 993:	eb 38                	jmp    9cd <malloc+0xde>
    }
    if(p == freep)
 995:	a1 c8 0d 00 00       	mov    0xdc8,%eax
 99a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 99d:	75 1b                	jne    9ba <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 99f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9a2:	89 04 24             	mov    %eax,(%esp)
 9a5:	e8 ed fe ff ff       	call   897 <morecore>
 9aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b1:	75 07                	jne    9ba <malloc+0xcb>
        return 0;
 9b3:	b8 00 00 00 00       	mov    $0x0,%eax
 9b8:	eb 13                	jmp    9cd <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c3:	8b 00                	mov    (%eax),%eax
 9c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9c8:	e9 70 ff ff ff       	jmp    93d <malloc+0x4e>
}
 9cd:	c9                   	leave  
 9ce:	c3                   	ret    
