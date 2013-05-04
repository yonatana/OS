
_threadtest:     file format elf32-i386


Disassembly of section .text:

00000000 <printme>:
#include "types.h"
#include "stat.h"
#include "user.h"

void *retval;
void *printme(int* c) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    printf(1,"Hi. I'm thread %d\n", getpid());
   6:	e8 49 04 00 00       	call   454 <getpid>
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 37 09 00 	movl   $0x937,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 50 05 00 00       	call   573 <printf>
    *c=*c+1;
  23:	8b 45 08             	mov    0x8(%ebp),%eax
  26:	8b 00                	mov    (%eax),%eax
  28:	8d 50 01             	lea    0x1(%eax),%edx
  2b:	8b 45 08             	mov    0x8(%ebp),%eax
  2e:	89 10                	mov    %edx,(%eax)
    printf(1,"C: %d\n", *c);
  30:	8b 45 08             	mov    0x8(%ebp),%eax
  33:	8b 00                	mov    (%eax),%eax
  35:	89 44 24 08          	mov    %eax,0x8(%esp)
  39:	c7 44 24 04 4a 09 00 	movl   $0x94a,0x4(%esp)
  40:	00 
  41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  48:	e8 26 05 00 00       	call   573 <printf>
    thread_exit(retval);
  4d:	a1 10 0c 00 00       	mov    0xc10,%eax
  52:	89 04 24             	mov    %eax,(%esp)
  55:	e8 3a 04 00 00       	call   494 <thread_exit>
    return 0;
  5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  5f:	c9                   	leave  
  60:	c3                   	ret    

00000061 <main>:

int main() {
  61:	55                   	push   %ebp
  62:	89 e5                	mov    %esp,%ebp
  64:	83 e4 f0             	and    $0xfffffff0,%esp
  67:	83 ec 40             	sub    $0x40,%esp
    int i, tids[4];
    int tid;
    int counter =0;
  6a:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  71:	00 
    void* stack = (void*)malloc(1024);
  72:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  79:	e8 d9 07 00 00       	call   857 <malloc>
  7e:	89 44 24 38          	mov    %eax,0x38(%esp)
    uint stack_size = 1024;
  82:	c7 44 24 34 00 04 00 	movl   $0x400,0x34(%esp)
  89:	00 
    for (i = 0; i < 4; i++) {
  8a:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
  91:	00 
  92:	eb 4d                	jmp    e1 <main+0x80>
      printf(1,"counter: %d\n", &counter);
  94:	8d 44 24 1c          	lea    0x1c(%esp),%eax
  98:	89 44 24 08          	mov    %eax,0x8(%esp)
  9c:	c7 44 24 04 51 09 00 	movl   $0x951,0x4(%esp)
  a3:	00 
  a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ab:	e8 c3 04 00 00       	call   573 <printf>
        tids[i] = thread_create(printme(&counter), stack, stack_size);
  b0:	8d 44 24 1c          	lea    0x1c(%esp),%eax
  b4:	89 04 24             	mov    %eax,(%esp)
  b7:	e8 44 ff ff ff       	call   0 <printme>
  bc:	8b 54 24 34          	mov    0x34(%esp),%edx
  c0:	89 54 24 08          	mov    %edx,0x8(%esp)
  c4:	8b 54 24 38          	mov    0x38(%esp),%edx
  c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  cc:	89 04 24             	mov    %eax,(%esp)
  cf:	e8 a0 03 00 00       	call   474 <thread_create>
  d4:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  d8:	89 44 94 20          	mov    %eax,0x20(%esp,%edx,4)
    int i, tids[4];
    int tid;
    int counter =0;
    void* stack = (void*)malloc(1024);
    uint stack_size = 1024;
    for (i = 0; i < 4; i++) {
  dc:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
  e1:	83 7c 24 3c 03       	cmpl   $0x3,0x3c(%esp)
  e6:	7e ac                	jle    94 <main+0x33>
      printf(1,"counter: %d\n", &counter);
        tids[i] = thread_create(printme(&counter), stack, stack_size);
	
    }
    for (i = 0; i < 4; i++) {
  e8:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
  ef:	00 
  f0:	eb 5d                	jmp    14f <main+0xee>
        printf(1,"Trying to join with tid%d\n", tids[i]);
  f2:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  f6:	8b 44 84 20          	mov    0x20(%esp,%eax,4),%eax
  fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  fe:	c7 44 24 04 5e 09 00 	movl   $0x95e,0x4(%esp)
 105:	00 
 106:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 10d:	e8 61 04 00 00       	call   573 <printf>
        thread_join(tids[i], &retval);
 112:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 116:	8b 44 84 20          	mov    0x20(%esp,%eax,4),%eax
 11a:	c7 44 24 04 10 0c 00 	movl   $0xc10,0x4(%esp)
 121:	00 
 122:	89 04 24             	mov    %eax,(%esp)
 125:	e8 62 03 00 00       	call   48c <thread_join>
        printf(1,"Joined with tid%d\n", tids[i]);
 12a:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 12e:	8b 44 84 20          	mov    0x20(%esp,%eax,4),%eax
 132:	89 44 24 08          	mov    %eax,0x8(%esp)
 136:	c7 44 24 04 79 09 00 	movl   $0x979,0x4(%esp)
 13d:	00 
 13e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 145:	e8 29 04 00 00       	call   573 <printf>
    for (i = 0; i < 4; i++) {
      printf(1,"counter: %d\n", &counter);
        tids[i] = thread_create(printme(&counter), stack, stack_size);
	
    }
    for (i = 0; i < 4; i++) {
 14a:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
 14f:	83 7c 24 3c 03       	cmpl   $0x3,0x3c(%esp)
 154:	7e 9c                	jle    f2 <main+0x91>
 156:	eb 01                	jmp    159 <main+0xf8>
    }
    for(;;){
      tid = wait();
      if(tid == -1)
	break;
    }
 158:	90                   	nop
        printf(1,"Trying to join with tid%d\n", tids[i]);
        thread_join(tids[i], &retval);
        printf(1,"Joined with tid%d\n", tids[i]);
    }
    for(;;){
      tid = wait();
 159:	e8 7e 02 00 00       	call   3dc <wait>
 15e:	89 44 24 30          	mov    %eax,0x30(%esp)
      if(tid == -1)
 162:	83 7c 24 30 ff       	cmpl   $0xffffffff,0x30(%esp)
 167:	75 ef                	jne    158 <main+0xf7>
	break;
 169:	90                   	nop
    }
    exit();
 16a:	e8 65 02 00 00       	call   3d4 <exit>
 16f:	90                   	nop

00000170 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 175:	8b 4d 08             	mov    0x8(%ebp),%ecx
 178:	8b 55 10             	mov    0x10(%ebp),%edx
 17b:	8b 45 0c             	mov    0xc(%ebp),%eax
 17e:	89 cb                	mov    %ecx,%ebx
 180:	89 df                	mov    %ebx,%edi
 182:	89 d1                	mov    %edx,%ecx
 184:	fc                   	cld    
 185:	f3 aa                	rep stos %al,%es:(%edi)
 187:	89 ca                	mov    %ecx,%edx
 189:	89 fb                	mov    %edi,%ebx
 18b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 18e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 191:	5b                   	pop    %ebx
 192:	5f                   	pop    %edi
 193:	5d                   	pop    %ebp
 194:	c3                   	ret    

00000195 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1a1:	90                   	nop
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	0f b6 10             	movzbl (%eax),%edx
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	88 10                	mov    %dl,(%eax)
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	84 c0                	test   %al,%al
 1b5:	0f 95 c0             	setne  %al
 1b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1bc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 1c0:	84 c0                	test   %al,%al
 1c2:	75 de                	jne    1a2 <strcpy+0xd>
    ;
  return os;
 1c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c7:	c9                   	leave  
 1c8:	c3                   	ret    

000001c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1cc:	eb 08                	jmp    1d6 <strcmp+0xd>
    p++, q++;
 1ce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	0f b6 00             	movzbl (%eax),%eax
 1dc:	84 c0                	test   %al,%al
 1de:	74 10                	je     1f0 <strcmp+0x27>
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 10             	movzbl (%eax),%edx
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	0f b6 00             	movzbl (%eax),%eax
 1ec:	38 c2                	cmp    %al,%dl
 1ee:	74 de                	je     1ce <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	0f b6 00             	movzbl (%eax),%eax
 1f6:	0f b6 d0             	movzbl %al,%edx
 1f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	0f b6 c0             	movzbl %al,%eax
 202:	89 d1                	mov    %edx,%ecx
 204:	29 c1                	sub    %eax,%ecx
 206:	89 c8                	mov    %ecx,%eax
}
 208:	5d                   	pop    %ebp
 209:	c3                   	ret    

0000020a <strlen>:

uint
strlen(char *s)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 210:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 217:	eb 04                	jmp    21d <strlen+0x13>
 219:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 21d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 220:	03 45 08             	add    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	75 ef                	jne    219 <strlen+0xf>
    ;
  return n;
 22a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <memset>:

void*
memset(void *dst, int c, uint n)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 235:	8b 45 10             	mov    0x10(%ebp),%eax
 238:	89 44 24 08          	mov    %eax,0x8(%esp)
 23c:	8b 45 0c             	mov    0xc(%ebp),%eax
 23f:	89 44 24 04          	mov    %eax,0x4(%esp)
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	89 04 24             	mov    %eax,(%esp)
 249:	e8 22 ff ff ff       	call   170 <stosb>
  return dst;
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <strchr>:

char*
strchr(const char *s, char c)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 04             	sub    $0x4,%esp
 259:	8b 45 0c             	mov    0xc(%ebp),%eax
 25c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 25f:	eb 14                	jmp    275 <strchr+0x22>
    if(*s == c)
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	3a 45 fc             	cmp    -0x4(%ebp),%al
 26a:	75 05                	jne    271 <strchr+0x1e>
      return (char*)s;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	eb 13                	jmp    284 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 271:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	84 c0                	test   %al,%al
 27d:	75 e2                	jne    261 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 27f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <gets>:

char*
gets(char *buf, int max)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 293:	eb 44                	jmp    2d9 <gets+0x53>
    cc = read(0, &c, 1);
 295:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 29c:	00 
 29d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2ab:	e8 3c 01 00 00       	call   3ec <read>
 2b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2b7:	7e 2d                	jle    2e6 <gets+0x60>
      break;
    buf[i++] = c;
 2b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bc:	03 45 08             	add    0x8(%ebp),%eax
 2bf:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 2c3:	88 10                	mov    %dl,(%eax)
 2c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 2c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2cd:	3c 0a                	cmp    $0xa,%al
 2cf:	74 16                	je     2e7 <gets+0x61>
 2d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d5:	3c 0d                	cmp    $0xd,%al
 2d7:	74 0e                	je     2e7 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2dc:	83 c0 01             	add    $0x1,%eax
 2df:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2e2:	7c b1                	jl     295 <gets+0xf>
 2e4:	eb 01                	jmp    2e7 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2e6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ea:	03 45 08             	add    0x8(%ebp),%eax
 2ed:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f3:	c9                   	leave  
 2f4:	c3                   	ret    

000002f5 <stat>:

int
stat(char *n, struct stat *st)
{
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
 2f8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 302:	00 
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	89 04 24             	mov    %eax,(%esp)
 309:	e8 06 01 00 00       	call   414 <open>
 30e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 315:	79 07                	jns    31e <stat+0x29>
    return -1;
 317:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 31c:	eb 23                	jmp    341 <stat+0x4c>
  r = fstat(fd, st);
 31e:	8b 45 0c             	mov    0xc(%ebp),%eax
 321:	89 44 24 04          	mov    %eax,0x4(%esp)
 325:	8b 45 f4             	mov    -0xc(%ebp),%eax
 328:	89 04 24             	mov    %eax,(%esp)
 32b:	e8 fc 00 00 00       	call   42c <fstat>
 330:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 333:	8b 45 f4             	mov    -0xc(%ebp),%eax
 336:	89 04 24             	mov    %eax,(%esp)
 339:	e8 be 00 00 00       	call   3fc <close>
  return r;
 33e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <atoi>:

int
atoi(const char *s)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 349:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 350:	eb 23                	jmp    375 <atoi+0x32>
    n = n*10 + *s++ - '0';
 352:	8b 55 fc             	mov    -0x4(%ebp),%edx
 355:	89 d0                	mov    %edx,%eax
 357:	c1 e0 02             	shl    $0x2,%eax
 35a:	01 d0                	add    %edx,%eax
 35c:	01 c0                	add    %eax,%eax
 35e:	89 c2                	mov    %eax,%edx
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	0f b6 00             	movzbl (%eax),%eax
 366:	0f be c0             	movsbl %al,%eax
 369:	01 d0                	add    %edx,%eax
 36b:	83 e8 30             	sub    $0x30,%eax
 36e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 371:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	0f b6 00             	movzbl (%eax),%eax
 37b:	3c 2f                	cmp    $0x2f,%al
 37d:	7e 0a                	jle    389 <atoi+0x46>
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	0f b6 00             	movzbl (%eax),%eax
 385:	3c 39                	cmp    $0x39,%al
 387:	7e c9                	jle    352 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 389:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38c:	c9                   	leave  
 38d:	c3                   	ret    

0000038e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3a0:	eb 13                	jmp    3b5 <memmove+0x27>
    *dst++ = *src++;
 3a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3a5:	0f b6 10             	movzbl (%eax),%edx
 3a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ab:	88 10                	mov    %dl,(%eax)
 3ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3b1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3b9:	0f 9f c0             	setg   %al
 3bc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 3c0:	84 c0                	test   %al,%al
 3c2:	75 de                	jne    3a2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c7:	c9                   	leave  
 3c8:	c3                   	ret    
 3c9:	90                   	nop
 3ca:	90                   	nop
 3cb:	90                   	nop

000003cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3cc:	b8 01 00 00 00       	mov    $0x1,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <exit>:
SYSCALL(exit)
 3d4:	b8 02 00 00 00       	mov    $0x2,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <wait>:
SYSCALL(wait)
 3dc:	b8 03 00 00 00       	mov    $0x3,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <pipe>:
SYSCALL(pipe)
 3e4:	b8 04 00 00 00       	mov    $0x4,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <read>:
SYSCALL(read)
 3ec:	b8 05 00 00 00       	mov    $0x5,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <write>:
SYSCALL(write)
 3f4:	b8 10 00 00 00       	mov    $0x10,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <close>:
SYSCALL(close)
 3fc:	b8 15 00 00 00       	mov    $0x15,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <kill>:
SYSCALL(kill)
 404:	b8 06 00 00 00       	mov    $0x6,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <exec>:
SYSCALL(exec)
 40c:	b8 07 00 00 00       	mov    $0x7,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <open>:
SYSCALL(open)
 414:	b8 0f 00 00 00       	mov    $0xf,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <mknod>:
SYSCALL(mknod)
 41c:	b8 11 00 00 00       	mov    $0x11,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <unlink>:
SYSCALL(unlink)
 424:	b8 12 00 00 00       	mov    $0x12,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <fstat>:
SYSCALL(fstat)
 42c:	b8 08 00 00 00       	mov    $0x8,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <link>:
SYSCALL(link)
 434:	b8 13 00 00 00       	mov    $0x13,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <mkdir>:
SYSCALL(mkdir)
 43c:	b8 14 00 00 00       	mov    $0x14,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <chdir>:
SYSCALL(chdir)
 444:	b8 09 00 00 00       	mov    $0x9,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <dup>:
SYSCALL(dup)
 44c:	b8 0a 00 00 00       	mov    $0xa,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <getpid>:
SYSCALL(getpid)
 454:	b8 0b 00 00 00       	mov    $0xb,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <sbrk>:
SYSCALL(sbrk)
 45c:	b8 0c 00 00 00       	mov    $0xc,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <sleep>:
SYSCALL(sleep)
 464:	b8 0d 00 00 00       	mov    $0xd,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <uptime>:
SYSCALL(uptime)
 46c:	b8 0e 00 00 00       	mov    $0xe,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <thread_create>:
SYSCALL(thread_create)
 474:	b8 16 00 00 00       	mov    $0x16,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <thread_getId>:
SYSCALL(thread_getId)
 47c:	b8 17 00 00 00       	mov    $0x17,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <thread_getProcId>:
SYSCALL(thread_getProcId)
 484:	b8 18 00 00 00       	mov    $0x18,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <thread_join>:
SYSCALL(thread_join)
 48c:	b8 19 00 00 00       	mov    $0x19,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <thread_exit>:
SYSCALL(thread_exit)
 494:	b8 1a 00 00 00       	mov    $0x1a,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 49c:	55                   	push   %ebp
 49d:	89 e5                	mov    %esp,%ebp
 49f:	83 ec 28             	sub    $0x28,%esp
 4a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4af:	00 
 4b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	89 04 24             	mov    %eax,(%esp)
 4bd:	e8 32 ff ff ff       	call   3f4 <write>
}
 4c2:	c9                   	leave  
 4c3:	c3                   	ret    

000004c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d5:	74 17                	je     4ee <printint+0x2a>
 4d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4db:	79 11                	jns    4ee <printint+0x2a>
    neg = 1;
 4dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e7:	f7 d8                	neg    %eax
 4e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ec:	eb 06                	jmp    4f4 <printint+0x30>
  } else {
    x = xx;
 4ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 501:	ba 00 00 00 00       	mov    $0x0,%edx
 506:	f7 f1                	div    %ecx
 508:	89 d0                	mov    %edx,%eax
 50a:	0f b6 90 f0 0b 00 00 	movzbl 0xbf0(%eax),%edx
 511:	8d 45 dc             	lea    -0x24(%ebp),%eax
 514:	03 45 f4             	add    -0xc(%ebp),%eax
 517:	88 10                	mov    %dl,(%eax)
 519:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 51d:	8b 55 10             	mov    0x10(%ebp),%edx
 520:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 523:	8b 45 ec             	mov    -0x14(%ebp),%eax
 526:	ba 00 00 00 00       	mov    $0x0,%edx
 52b:	f7 75 d4             	divl   -0x2c(%ebp)
 52e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 531:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 535:	75 c4                	jne    4fb <printint+0x37>
  if(neg)
 537:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 53b:	74 2a                	je     567 <printint+0xa3>
    buf[i++] = '-';
 53d:	8d 45 dc             	lea    -0x24(%ebp),%eax
 540:	03 45 f4             	add    -0xc(%ebp),%eax
 543:	c6 00 2d             	movb   $0x2d,(%eax)
 546:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 54a:	eb 1b                	jmp    567 <printint+0xa3>
    putc(fd, buf[i]);
 54c:	8d 45 dc             	lea    -0x24(%ebp),%eax
 54f:	03 45 f4             	add    -0xc(%ebp),%eax
 552:	0f b6 00             	movzbl (%eax),%eax
 555:	0f be c0             	movsbl %al,%eax
 558:	89 44 24 04          	mov    %eax,0x4(%esp)
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	89 04 24             	mov    %eax,(%esp)
 562:	e8 35 ff ff ff       	call   49c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 567:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 56b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56f:	79 db                	jns    54c <printint+0x88>
    putc(fd, buf[i]);
}
 571:	c9                   	leave  
 572:	c3                   	ret    

00000573 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 573:	55                   	push   %ebp
 574:	89 e5                	mov    %esp,%ebp
 576:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 579:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 580:	8d 45 0c             	lea    0xc(%ebp),%eax
 583:	83 c0 04             	add    $0x4,%eax
 586:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 589:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 590:	e9 7d 01 00 00       	jmp    712 <printf+0x19f>
    c = fmt[i] & 0xff;
 595:	8b 55 0c             	mov    0xc(%ebp),%edx
 598:	8b 45 f0             	mov    -0x10(%ebp),%eax
 59b:	01 d0                	add    %edx,%eax
 59d:	0f b6 00             	movzbl (%eax),%eax
 5a0:	0f be c0             	movsbl %al,%eax
 5a3:	25 ff 00 00 00       	and    $0xff,%eax
 5a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5af:	75 2c                	jne    5dd <printf+0x6a>
      if(c == '%'){
 5b1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b5:	75 0c                	jne    5c3 <printf+0x50>
        state = '%';
 5b7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5be:	e9 4b 01 00 00       	jmp    70e <printf+0x19b>
      } else {
        putc(fd, c);
 5c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c6:	0f be c0             	movsbl %al,%eax
 5c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cd:	8b 45 08             	mov    0x8(%ebp),%eax
 5d0:	89 04 24             	mov    %eax,(%esp)
 5d3:	e8 c4 fe ff ff       	call   49c <putc>
 5d8:	e9 31 01 00 00       	jmp    70e <printf+0x19b>
      }
    } else if(state == '%'){
 5dd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5e1:	0f 85 27 01 00 00    	jne    70e <printf+0x19b>
      if(c == 'd'){
 5e7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5eb:	75 2d                	jne    61a <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5f9:	00 
 5fa:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 601:	00 
 602:	89 44 24 04          	mov    %eax,0x4(%esp)
 606:	8b 45 08             	mov    0x8(%ebp),%eax
 609:	89 04 24             	mov    %eax,(%esp)
 60c:	e8 b3 fe ff ff       	call   4c4 <printint>
        ap++;
 611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 615:	e9 ed 00 00 00       	jmp    707 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 61a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 61e:	74 06                	je     626 <printf+0xb3>
 620:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 624:	75 2d                	jne    653 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 626:	8b 45 e8             	mov    -0x18(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 632:	00 
 633:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 63a:	00 
 63b:	89 44 24 04          	mov    %eax,0x4(%esp)
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	89 04 24             	mov    %eax,(%esp)
 645:	e8 7a fe ff ff       	call   4c4 <printint>
        ap++;
 64a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64e:	e9 b4 00 00 00       	jmp    707 <printf+0x194>
      } else if(c == 's'){
 653:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 657:	75 46                	jne    69f <printf+0x12c>
        s = (char*)*ap;
 659:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 661:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 665:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 669:	75 27                	jne    692 <printf+0x11f>
          s = "(null)";
 66b:	c7 45 f4 8c 09 00 00 	movl   $0x98c,-0xc(%ebp)
        while(*s != 0){
 672:	eb 1e                	jmp    692 <printf+0x11f>
          putc(fd, *s);
 674:	8b 45 f4             	mov    -0xc(%ebp),%eax
 677:	0f b6 00             	movzbl (%eax),%eax
 67a:	0f be c0             	movsbl %al,%eax
 67d:	89 44 24 04          	mov    %eax,0x4(%esp)
 681:	8b 45 08             	mov    0x8(%ebp),%eax
 684:	89 04 24             	mov    %eax,(%esp)
 687:	e8 10 fe ff ff       	call   49c <putc>
          s++;
 68c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 690:	eb 01                	jmp    693 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 692:	90                   	nop
 693:	8b 45 f4             	mov    -0xc(%ebp),%eax
 696:	0f b6 00             	movzbl (%eax),%eax
 699:	84 c0                	test   %al,%al
 69b:	75 d7                	jne    674 <printf+0x101>
 69d:	eb 68                	jmp    707 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 69f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6a3:	75 1d                	jne    6c2 <printf+0x14f>
        putc(fd, *ap);
 6a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a8:	8b 00                	mov    (%eax),%eax
 6aa:	0f be c0             	movsbl %al,%eax
 6ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b1:	8b 45 08             	mov    0x8(%ebp),%eax
 6b4:	89 04 24             	mov    %eax,(%esp)
 6b7:	e8 e0 fd ff ff       	call   49c <putc>
        ap++;
 6bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c0:	eb 45                	jmp    707 <printf+0x194>
      } else if(c == '%'){
 6c2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c6:	75 17                	jne    6df <printf+0x16c>
        putc(fd, c);
 6c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6cb:	0f be c0             	movsbl %al,%eax
 6ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d2:	8b 45 08             	mov    0x8(%ebp),%eax
 6d5:	89 04 24             	mov    %eax,(%esp)
 6d8:	e8 bf fd ff ff       	call   49c <putc>
 6dd:	eb 28                	jmp    707 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6df:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6e6:	00 
 6e7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ea:	89 04 24             	mov    %eax,(%esp)
 6ed:	e8 aa fd ff ff       	call   49c <putc>
        putc(fd, c);
 6f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f5:	0f be c0             	movsbl %al,%eax
 6f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fc:	8b 45 08             	mov    0x8(%ebp),%eax
 6ff:	89 04 24             	mov    %eax,(%esp)
 702:	e8 95 fd ff ff       	call   49c <putc>
      }
      state = 0;
 707:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 70e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 712:	8b 55 0c             	mov    0xc(%ebp),%edx
 715:	8b 45 f0             	mov    -0x10(%ebp),%eax
 718:	01 d0                	add    %edx,%eax
 71a:	0f b6 00             	movzbl (%eax),%eax
 71d:	84 c0                	test   %al,%al
 71f:	0f 85 70 fe ff ff    	jne    595 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 725:	c9                   	leave  
 726:	c3                   	ret    
 727:	90                   	nop

00000728 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 728:	55                   	push   %ebp
 729:	89 e5                	mov    %esp,%ebp
 72b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72e:	8b 45 08             	mov    0x8(%ebp),%eax
 731:	83 e8 08             	sub    $0x8,%eax
 734:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 737:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 73c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 73f:	eb 24                	jmp    765 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 749:	77 12                	ja     75d <free+0x35>
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 751:	77 24                	ja     777 <free+0x4f>
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	8b 00                	mov    (%eax),%eax
 758:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75b:	77 1a                	ja     777 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	89 45 fc             	mov    %eax,-0x4(%ebp)
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76b:	76 d4                	jbe    741 <free+0x19>
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 00                	mov    (%eax),%eax
 772:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 775:	76 ca                	jbe    741 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	c1 e0 03             	shl    $0x3,%eax
 780:	89 c2                	mov    %eax,%edx
 782:	03 55 f8             	add    -0x8(%ebp),%edx
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	39 c2                	cmp    %eax,%edx
 78c:	75 24                	jne    7b2 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	8b 50 04             	mov    0x4(%eax),%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	8b 00                	mov    (%eax),%eax
 799:	8b 40 04             	mov    0x4(%eax),%eax
 79c:	01 c2                	add    %eax,%edx
 79e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	8b 10                	mov    (%eax),%edx
 7ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ae:	89 10                	mov    %edx,(%eax)
 7b0:	eb 0a                	jmp    7bc <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	8b 10                	mov    (%eax),%edx
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bf:	8b 40 04             	mov    0x4(%eax),%eax
 7c2:	c1 e0 03             	shl    $0x3,%eax
 7c5:	03 45 fc             	add    -0x4(%ebp),%eax
 7c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cb:	75 20                	jne    7ed <free+0xc5>
    p->s.size += bp->s.size;
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	8b 50 04             	mov    0x4(%eax),%edx
 7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d6:	8b 40 04             	mov    0x4(%eax),%eax
 7d9:	01 c2                	add    %eax,%edx
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e4:	8b 10                	mov    (%eax),%edx
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	89 10                	mov    %edx,(%eax)
 7eb:	eb 08                	jmp    7f5 <free+0xcd>
  } else
    p->s.ptr = bp;
 7ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f3:	89 10                	mov    %edx,(%eax)
  freep = p;
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	a3 0c 0c 00 00       	mov    %eax,0xc0c
}
 7fd:	c9                   	leave  
 7fe:	c3                   	ret    

000007ff <morecore>:

static Header*
morecore(uint nu)
{
 7ff:	55                   	push   %ebp
 800:	89 e5                	mov    %esp,%ebp
 802:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 805:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 80c:	77 07                	ja     815 <morecore+0x16>
    nu = 4096;
 80e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 815:	8b 45 08             	mov    0x8(%ebp),%eax
 818:	c1 e0 03             	shl    $0x3,%eax
 81b:	89 04 24             	mov    %eax,(%esp)
 81e:	e8 39 fc ff ff       	call   45c <sbrk>
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 826:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 82a:	75 07                	jne    833 <morecore+0x34>
    return 0;
 82c:	b8 00 00 00 00       	mov    $0x0,%eax
 831:	eb 22                	jmp    855 <morecore+0x56>
  hp = (Header*)p;
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	8b 55 08             	mov    0x8(%ebp),%edx
 83f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	83 c0 08             	add    $0x8,%eax
 848:	89 04 24             	mov    %eax,(%esp)
 84b:	e8 d8 fe ff ff       	call   728 <free>
  return freep;
 850:	a1 0c 0c 00 00       	mov    0xc0c,%eax
}
 855:	c9                   	leave  
 856:	c3                   	ret    

00000857 <malloc>:

void*
malloc(uint nbytes)
{
 857:	55                   	push   %ebp
 858:	89 e5                	mov    %esp,%ebp
 85a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85d:	8b 45 08             	mov    0x8(%ebp),%eax
 860:	83 c0 07             	add    $0x7,%eax
 863:	c1 e8 03             	shr    $0x3,%eax
 866:	83 c0 01             	add    $0x1,%eax
 869:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 86c:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 871:	89 45 f0             	mov    %eax,-0x10(%ebp)
 874:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 878:	75 23                	jne    89d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 87a:	c7 45 f0 04 0c 00 00 	movl   $0xc04,-0x10(%ebp)
 881:	8b 45 f0             	mov    -0x10(%ebp),%eax
 884:	a3 0c 0c 00 00       	mov    %eax,0xc0c
 889:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 88e:	a3 04 0c 00 00       	mov    %eax,0xc04
    base.s.size = 0;
 893:	c7 05 08 0c 00 00 00 	movl   $0x0,0xc08
 89a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a0:	8b 00                	mov    (%eax),%eax
 8a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	8b 40 04             	mov    0x4(%eax),%eax
 8ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ae:	72 4d                	jb     8fd <malloc+0xa6>
      if(p->s.size == nunits)
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	8b 40 04             	mov    0x4(%eax),%eax
 8b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b9:	75 0c                	jne    8c7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 10                	mov    (%eax),%edx
 8c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c3:	89 10                	mov    %edx,(%eax)
 8c5:	eb 26                	jmp    8ed <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	8b 40 04             	mov    0x4(%eax),%eax
 8cd:	89 c2                	mov    %eax,%edx
 8cf:	2b 55 ec             	sub    -0x14(%ebp),%edx
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 40 04             	mov    0x4(%eax),%eax
 8de:	c1 e0 03             	shl    $0x3,%eax
 8e1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ea:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f0:	a3 0c 0c 00 00       	mov    %eax,0xc0c
      return (void*)(p + 1);
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	83 c0 08             	add    $0x8,%eax
 8fb:	eb 38                	jmp    935 <malloc+0xde>
    }
    if(p == freep)
 8fd:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 902:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 905:	75 1b                	jne    922 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 907:	8b 45 ec             	mov    -0x14(%ebp),%eax
 90a:	89 04 24             	mov    %eax,(%esp)
 90d:	e8 ed fe ff ff       	call   7ff <morecore>
 912:	89 45 f4             	mov    %eax,-0xc(%ebp)
 915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 919:	75 07                	jne    922 <malloc+0xcb>
        return 0;
 91b:	b8 00 00 00 00       	mov    $0x0,%eax
 920:	eb 13                	jmp    935 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 922:	8b 45 f4             	mov    -0xc(%ebp),%eax
 925:	89 45 f0             	mov    %eax,-0x10(%ebp)
 928:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 930:	e9 70 ff ff ff       	jmp    8a5 <malloc+0x4e>
}
 935:	c9                   	leave  
 936:	c3                   	ret    
