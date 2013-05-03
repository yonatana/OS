
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
   6:	e8 2d 04 00 00       	call   438 <getpid>
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 33 09 00 	movl   $0x933,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 4c 05 00 00       	call   56f <printf>
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
  39:	c7 44 24 04 46 09 00 	movl   $0x946,0x4(%esp)
  40:	00 
  41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  48:	e8 22 05 00 00       	call   56f <printf>
    thread_exit(retval);
  4d:	a1 00 0c 00 00       	mov    0xc00,%eax
  52:	89 04 24             	mov    %eax,(%esp)
  55:	e8 1e 04 00 00       	call   478 <thread_exit>
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
  79:	e8 d5 07 00 00       	call   853 <malloc>
  7e:	89 44 24 38          	mov    %eax,0x38(%esp)
    uint stack_size = 1024;
  82:	c7 44 24 34 00 04 00 	movl   $0x400,0x34(%esp)
  89:	00 
    for (i = 0; i < 4; i++) {
  8a:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
  91:	00 
  92:	eb 31                	jmp    c5 <main+0x64>
        tids[i] = thread_create(printme(&counter), stack, stack_size);
  94:	8d 44 24 1c          	lea    0x1c(%esp),%eax
  98:	89 04 24             	mov    %eax,(%esp)
  9b:	e8 60 ff ff ff       	call   0 <printme>
  a0:	8b 54 24 34          	mov    0x34(%esp),%edx
  a4:	89 54 24 08          	mov    %edx,0x8(%esp)
  a8:	8b 54 24 38          	mov    0x38(%esp),%edx
  ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  b0:	89 04 24             	mov    %eax,(%esp)
  b3:	e8 a0 03 00 00       	call   458 <thread_create>
  b8:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  bc:	89 44 94 20          	mov    %eax,0x20(%esp,%edx,4)
    int i, tids[4];
    int tid;
    int counter =0;
    void* stack = (void*)malloc(1024);
    uint stack_size = 1024;
    for (i = 0; i < 4; i++) {
  c0:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
  c5:	83 7c 24 3c 03       	cmpl   $0x3,0x3c(%esp)
  ca:	7e c8                	jle    94 <main+0x33>
        tids[i] = thread_create(printme(&counter), stack, stack_size);
	
    }
    for (i = 0; i < 4; i++) {
  cc:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
  d3:	00 
  d4:	eb 5d                	jmp    133 <main+0xd2>
        printf(1,"Trying to join with tid%d\n", tids[i]);
  d6:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  da:	8b 44 84 20          	mov    0x20(%esp,%eax,4),%eax
  de:	89 44 24 08          	mov    %eax,0x8(%esp)
  e2:	c7 44 24 04 4d 09 00 	movl   $0x94d,0x4(%esp)
  e9:	00 
  ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f1:	e8 79 04 00 00       	call   56f <printf>
        thread_join(tids[i], &retval);
  f6:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  fa:	8b 44 84 20          	mov    0x20(%esp,%eax,4),%eax
  fe:	c7 44 24 04 00 0c 00 	movl   $0xc00,0x4(%esp)
 105:	00 
 106:	89 04 24             	mov    %eax,(%esp)
 109:	e8 62 03 00 00       	call   470 <thread_join>
        printf(1,"Joined with tid%d\n", tids[i]);
 10e:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 112:	8b 44 84 20          	mov    0x20(%esp,%eax,4),%eax
 116:	89 44 24 08          	mov    %eax,0x8(%esp)
 11a:	c7 44 24 04 68 09 00 	movl   $0x968,0x4(%esp)
 121:	00 
 122:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 129:	e8 41 04 00 00       	call   56f <printf>
    uint stack_size = 1024;
    for (i = 0; i < 4; i++) {
        tids[i] = thread_create(printme(&counter), stack, stack_size);
	
    }
    for (i = 0; i < 4; i++) {
 12e:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
 133:	83 7c 24 3c 03       	cmpl   $0x3,0x3c(%esp)
 138:	7e 9c                	jle    d6 <main+0x75>
 13a:	eb 01                	jmp    13d <main+0xdc>
    }
    for(;;){
      tid = wait();
      if(tid == -1)
	break;
    }
 13c:	90                   	nop
        printf(1,"Trying to join with tid%d\n", tids[i]);
        thread_join(tids[i], &retval);
        printf(1,"Joined with tid%d\n", tids[i]);
    }
    for(;;){
      tid = wait();
 13d:	e8 7e 02 00 00       	call   3c0 <wait>
 142:	89 44 24 30          	mov    %eax,0x30(%esp)
      if(tid == -1)
 146:	83 7c 24 30 ff       	cmpl   $0xffffffff,0x30(%esp)
 14b:	75 ef                	jne    13c <main+0xdb>
	break;
 14d:	90                   	nop
    }
    exit();
 14e:	e8 65 02 00 00       	call   3b8 <exit>
 153:	90                   	nop

00000154 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	57                   	push   %edi
 158:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 159:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15c:	8b 55 10             	mov    0x10(%ebp),%edx
 15f:	8b 45 0c             	mov    0xc(%ebp),%eax
 162:	89 cb                	mov    %ecx,%ebx
 164:	89 df                	mov    %ebx,%edi
 166:	89 d1                	mov    %edx,%ecx
 168:	fc                   	cld    
 169:	f3 aa                	rep stos %al,%es:(%edi)
 16b:	89 ca                	mov    %ecx,%edx
 16d:	89 fb                	mov    %edi,%ebx
 16f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 172:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 175:	5b                   	pop    %ebx
 176:	5f                   	pop    %edi
 177:	5d                   	pop    %ebp
 178:	c3                   	ret    

00000179 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 185:	90                   	nop
 186:	8b 45 0c             	mov    0xc(%ebp),%eax
 189:	0f b6 10             	movzbl (%eax),%edx
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	88 10                	mov    %dl,(%eax)
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	0f b6 00             	movzbl (%eax),%eax
 197:	84 c0                	test   %al,%al
 199:	0f 95 c0             	setne  %al
 19c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 1a4:	84 c0                	test   %al,%al
 1a6:	75 de                	jne    186 <strcpy+0xd>
    ;
  return os;
 1a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ab:	c9                   	leave  
 1ac:	c3                   	ret    

000001ad <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ad:	55                   	push   %ebp
 1ae:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1b0:	eb 08                	jmp    1ba <strcmp+0xd>
    p++, q++;
 1b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	84 c0                	test   %al,%al
 1c2:	74 10                	je     1d4 <strcmp+0x27>
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	0f b6 10             	movzbl (%eax),%edx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	0f b6 00             	movzbl (%eax),%eax
 1d0:	38 c2                	cmp    %al,%dl
 1d2:	74 de                	je     1b2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	0f b6 00             	movzbl (%eax),%eax
 1da:	0f b6 d0             	movzbl %al,%edx
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	0f b6 00             	movzbl (%eax),%eax
 1e3:	0f b6 c0             	movzbl %al,%eax
 1e6:	89 d1                	mov    %edx,%ecx
 1e8:	29 c1                	sub    %eax,%ecx
 1ea:	89 c8                	mov    %ecx,%eax
}
 1ec:	5d                   	pop    %ebp
 1ed:	c3                   	ret    

000001ee <strlen>:

uint
strlen(char *s)
{
 1ee:	55                   	push   %ebp
 1ef:	89 e5                	mov    %esp,%ebp
 1f1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1fb:	eb 04                	jmp    201 <strlen+0x13>
 1fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 201:	8b 45 fc             	mov    -0x4(%ebp),%eax
 204:	03 45 08             	add    0x8(%ebp),%eax
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 ef                	jne    1fd <strlen+0xf>
    ;
  return n;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <memset>:

void*
memset(void *dst, int c, uint n)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
 216:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 219:	8b 45 10             	mov    0x10(%ebp),%eax
 21c:	89 44 24 08          	mov    %eax,0x8(%esp)
 220:	8b 45 0c             	mov    0xc(%ebp),%eax
 223:	89 44 24 04          	mov    %eax,0x4(%esp)
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	89 04 24             	mov    %eax,(%esp)
 22d:	e8 22 ff ff ff       	call   154 <stosb>
  return dst;
 232:	8b 45 08             	mov    0x8(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <strchr>:

char*
strchr(const char *s, char c)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 04             	sub    $0x4,%esp
 23d:	8b 45 0c             	mov    0xc(%ebp),%eax
 240:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 243:	eb 14                	jmp    259 <strchr+0x22>
    if(*s == c)
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	0f b6 00             	movzbl (%eax),%eax
 24b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 24e:	75 05                	jne    255 <strchr+0x1e>
      return (char*)s;
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	eb 13                	jmp    268 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 255:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 259:	8b 45 08             	mov    0x8(%ebp),%eax
 25c:	0f b6 00             	movzbl (%eax),%eax
 25f:	84 c0                	test   %al,%al
 261:	75 e2                	jne    245 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 263:	b8 00 00 00 00       	mov    $0x0,%eax
}
 268:	c9                   	leave  
 269:	c3                   	ret    

0000026a <gets>:

char*
gets(char *buf, int max)
{
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
 26d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 277:	eb 44                	jmp    2bd <gets+0x53>
    cc = read(0, &c, 1);
 279:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 280:	00 
 281:	8d 45 ef             	lea    -0x11(%ebp),%eax
 284:	89 44 24 04          	mov    %eax,0x4(%esp)
 288:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 28f:	e8 3c 01 00 00       	call   3d0 <read>
 294:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 297:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 29b:	7e 2d                	jle    2ca <gets+0x60>
      break;
    buf[i++] = c;
 29d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a0:	03 45 08             	add    0x8(%ebp),%eax
 2a3:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 2a7:	88 10                	mov    %dl,(%eax)
 2a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 2ad:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b1:	3c 0a                	cmp    $0xa,%al
 2b3:	74 16                	je     2cb <gets+0x61>
 2b5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b9:	3c 0d                	cmp    $0xd,%al
 2bb:	74 0e                	je     2cb <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c0:	83 c0 01             	add    $0x1,%eax
 2c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c6:	7c b1                	jl     279 <gets+0xf>
 2c8:	eb 01                	jmp    2cb <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2ca:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ce:	03 45 08             	add    0x8(%ebp),%eax
 2d1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d7:	c9                   	leave  
 2d8:	c3                   	ret    

000002d9 <stat>:

int
stat(char *n, struct stat *st)
{
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp
 2dc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2e6:	00 
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	89 04 24             	mov    %eax,(%esp)
 2ed:	e8 06 01 00 00       	call   3f8 <open>
 2f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f9:	79 07                	jns    302 <stat+0x29>
    return -1;
 2fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 300:	eb 23                	jmp    325 <stat+0x4c>
  r = fstat(fd, st);
 302:	8b 45 0c             	mov    0xc(%ebp),%eax
 305:	89 44 24 04          	mov    %eax,0x4(%esp)
 309:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30c:	89 04 24             	mov    %eax,(%esp)
 30f:	e8 fc 00 00 00       	call   410 <fstat>
 314:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	89 04 24             	mov    %eax,(%esp)
 31d:	e8 be 00 00 00       	call   3e0 <close>
  return r;
 322:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 325:	c9                   	leave  
 326:	c3                   	ret    

00000327 <atoi>:

int
atoi(const char *s)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 32d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 334:	eb 23                	jmp    359 <atoi+0x32>
    n = n*10 + *s++ - '0';
 336:	8b 55 fc             	mov    -0x4(%ebp),%edx
 339:	89 d0                	mov    %edx,%eax
 33b:	c1 e0 02             	shl    $0x2,%eax
 33e:	01 d0                	add    %edx,%eax
 340:	01 c0                	add    %eax,%eax
 342:	89 c2                	mov    %eax,%edx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	0f be c0             	movsbl %al,%eax
 34d:	01 d0                	add    %edx,%eax
 34f:	83 e8 30             	sub    $0x30,%eax
 352:	89 45 fc             	mov    %eax,-0x4(%ebp)
 355:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	0f b6 00             	movzbl (%eax),%eax
 35f:	3c 2f                	cmp    $0x2f,%al
 361:	7e 0a                	jle    36d <atoi+0x46>
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	0f b6 00             	movzbl (%eax),%eax
 369:	3c 39                	cmp    $0x39,%al
 36b:	7e c9                	jle    336 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 36d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 370:	c9                   	leave  
 371:	c3                   	ret    

00000372 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 384:	eb 13                	jmp    399 <memmove+0x27>
    *dst++ = *src++;
 386:	8b 45 f8             	mov    -0x8(%ebp),%eax
 389:	0f b6 10             	movzbl (%eax),%edx
 38c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 38f:	88 10                	mov    %dl,(%eax)
 391:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 395:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 399:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 39d:	0f 9f c0             	setg   %al
 3a0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 3a4:	84 c0                	test   %al,%al
 3a6:	75 de                	jne    386 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ab:	c9                   	leave  
 3ac:	c3                   	ret    
 3ad:	90                   	nop
 3ae:	90                   	nop
 3af:	90                   	nop

000003b0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b0:	b8 01 00 00 00       	mov    $0x1,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <exit>:
SYSCALL(exit)
 3b8:	b8 02 00 00 00       	mov    $0x2,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <wait>:
SYSCALL(wait)
 3c0:	b8 03 00 00 00       	mov    $0x3,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <pipe>:
SYSCALL(pipe)
 3c8:	b8 04 00 00 00       	mov    $0x4,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <read>:
SYSCALL(read)
 3d0:	b8 05 00 00 00       	mov    $0x5,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <write>:
SYSCALL(write)
 3d8:	b8 10 00 00 00       	mov    $0x10,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <close>:
SYSCALL(close)
 3e0:	b8 15 00 00 00       	mov    $0x15,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <kill>:
SYSCALL(kill)
 3e8:	b8 06 00 00 00       	mov    $0x6,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <exec>:
SYSCALL(exec)
 3f0:	b8 07 00 00 00       	mov    $0x7,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <open>:
SYSCALL(open)
 3f8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <mknod>:
SYSCALL(mknod)
 400:	b8 11 00 00 00       	mov    $0x11,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <unlink>:
SYSCALL(unlink)
 408:	b8 12 00 00 00       	mov    $0x12,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <fstat>:
SYSCALL(fstat)
 410:	b8 08 00 00 00       	mov    $0x8,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <link>:
SYSCALL(link)
 418:	b8 13 00 00 00       	mov    $0x13,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <mkdir>:
SYSCALL(mkdir)
 420:	b8 14 00 00 00       	mov    $0x14,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <chdir>:
SYSCALL(chdir)
 428:	b8 09 00 00 00       	mov    $0x9,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <dup>:
SYSCALL(dup)
 430:	b8 0a 00 00 00       	mov    $0xa,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <getpid>:
SYSCALL(getpid)
 438:	b8 0b 00 00 00       	mov    $0xb,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <sbrk>:
SYSCALL(sbrk)
 440:	b8 0c 00 00 00       	mov    $0xc,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <sleep>:
SYSCALL(sleep)
 448:	b8 0d 00 00 00       	mov    $0xd,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <uptime>:
SYSCALL(uptime)
 450:	b8 0e 00 00 00       	mov    $0xe,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <thread_create>:
SYSCALL(thread_create)
 458:	b8 16 00 00 00       	mov    $0x16,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <thread_getId>:
SYSCALL(thread_getId)
 460:	b8 17 00 00 00       	mov    $0x17,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <thread_getProcId>:
SYSCALL(thread_getProcId)
 468:	b8 18 00 00 00       	mov    $0x18,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <thread_join>:
SYSCALL(thread_join)
 470:	b8 19 00 00 00       	mov    $0x19,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <thread_exit>:
SYSCALL(thread_exit)
 478:	b8 1a 00 00 00       	mov    $0x1a,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
 480:	b8 1b 00 00 00       	mov    $0x1b,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
 488:	b8 1c 00 00 00       	mov    $0x1c,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
 490:	b8 1d 00 00 00       	mov    $0x1d,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 498:	55                   	push   %ebp
 499:	89 e5                	mov    %esp,%ebp
 49b:	83 ec 28             	sub    $0x28,%esp
 49e:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ab:	00 
 4ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4af:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	89 04 24             	mov    %eax,(%esp)
 4b9:	e8 1a ff ff ff       	call   3d8 <write>
}
 4be:	c9                   	leave  
 4bf:	c3                   	ret    

000004c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4cd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d1:	74 17                	je     4ea <printint+0x2a>
 4d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4d7:	79 11                	jns    4ea <printint+0x2a>
    neg = 1;
 4d9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e3:	f7 d8                	neg    %eax
 4e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e8:	eb 06                	jmp    4f0 <printint+0x30>
  } else {
    x = xx;
 4ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fd:	ba 00 00 00 00       	mov    $0x0,%edx
 502:	f7 f1                	div    %ecx
 504:	89 d0                	mov    %edx,%eax
 506:	0f b6 90 e0 0b 00 00 	movzbl 0xbe0(%eax),%edx
 50d:	8d 45 dc             	lea    -0x24(%ebp),%eax
 510:	03 45 f4             	add    -0xc(%ebp),%eax
 513:	88 10                	mov    %dl,(%eax)
 515:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 519:	8b 55 10             	mov    0x10(%ebp),%edx
 51c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 51f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 522:	ba 00 00 00 00       	mov    $0x0,%edx
 527:	f7 75 d4             	divl   -0x2c(%ebp)
 52a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 531:	75 c4                	jne    4f7 <printint+0x37>
  if(neg)
 533:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 537:	74 2a                	je     563 <printint+0xa3>
    buf[i++] = '-';
 539:	8d 45 dc             	lea    -0x24(%ebp),%eax
 53c:	03 45 f4             	add    -0xc(%ebp),%eax
 53f:	c6 00 2d             	movb   $0x2d,(%eax)
 542:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 546:	eb 1b                	jmp    563 <printint+0xa3>
    putc(fd, buf[i]);
 548:	8d 45 dc             	lea    -0x24(%ebp),%eax
 54b:	03 45 f4             	add    -0xc(%ebp),%eax
 54e:	0f b6 00             	movzbl (%eax),%eax
 551:	0f be c0             	movsbl %al,%eax
 554:	89 44 24 04          	mov    %eax,0x4(%esp)
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	89 04 24             	mov    %eax,(%esp)
 55e:	e8 35 ff ff ff       	call   498 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 563:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56b:	79 db                	jns    548 <printint+0x88>
    putc(fd, buf[i]);
}
 56d:	c9                   	leave  
 56e:	c3                   	ret    

0000056f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 56f:	55                   	push   %ebp
 570:	89 e5                	mov    %esp,%ebp
 572:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 575:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 57c:	8d 45 0c             	lea    0xc(%ebp),%eax
 57f:	83 c0 04             	add    $0x4,%eax
 582:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 585:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 58c:	e9 7d 01 00 00       	jmp    70e <printf+0x19f>
    c = fmt[i] & 0xff;
 591:	8b 55 0c             	mov    0xc(%ebp),%edx
 594:	8b 45 f0             	mov    -0x10(%ebp),%eax
 597:	01 d0                	add    %edx,%eax
 599:	0f b6 00             	movzbl (%eax),%eax
 59c:	0f be c0             	movsbl %al,%eax
 59f:	25 ff 00 00 00       	and    $0xff,%eax
 5a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ab:	75 2c                	jne    5d9 <printf+0x6a>
      if(c == '%'){
 5ad:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b1:	75 0c                	jne    5bf <printf+0x50>
        state = '%';
 5b3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ba:	e9 4b 01 00 00       	jmp    70a <printf+0x19b>
      } else {
        putc(fd, c);
 5bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c2:	0f be c0             	movsbl %al,%eax
 5c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	89 04 24             	mov    %eax,(%esp)
 5cf:	e8 c4 fe ff ff       	call   498 <putc>
 5d4:	e9 31 01 00 00       	jmp    70a <printf+0x19b>
      }
    } else if(state == '%'){
 5d9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5dd:	0f 85 27 01 00 00    	jne    70a <printf+0x19b>
      if(c == 'd'){
 5e3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5e7:	75 2d                	jne    616 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5f5:	00 
 5f6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5fd:	00 
 5fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	89 04 24             	mov    %eax,(%esp)
 608:	e8 b3 fe ff ff       	call   4c0 <printint>
        ap++;
 60d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 611:	e9 ed 00 00 00       	jmp    703 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 616:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 61a:	74 06                	je     622 <printf+0xb3>
 61c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 620:	75 2d                	jne    64f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 622:	8b 45 e8             	mov    -0x18(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 62e:	00 
 62f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 636:	00 
 637:	89 44 24 04          	mov    %eax,0x4(%esp)
 63b:	8b 45 08             	mov    0x8(%ebp),%eax
 63e:	89 04 24             	mov    %eax,(%esp)
 641:	e8 7a fe ff ff       	call   4c0 <printint>
        ap++;
 646:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64a:	e9 b4 00 00 00       	jmp    703 <printf+0x194>
      } else if(c == 's'){
 64f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 653:	75 46                	jne    69b <printf+0x12c>
        s = (char*)*ap;
 655:	8b 45 e8             	mov    -0x18(%ebp),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 65d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 665:	75 27                	jne    68e <printf+0x11f>
          s = "(null)";
 667:	c7 45 f4 7b 09 00 00 	movl   $0x97b,-0xc(%ebp)
        while(*s != 0){
 66e:	eb 1e                	jmp    68e <printf+0x11f>
          putc(fd, *s);
 670:	8b 45 f4             	mov    -0xc(%ebp),%eax
 673:	0f b6 00             	movzbl (%eax),%eax
 676:	0f be c0             	movsbl %al,%eax
 679:	89 44 24 04          	mov    %eax,0x4(%esp)
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	89 04 24             	mov    %eax,(%esp)
 683:	e8 10 fe ff ff       	call   498 <putc>
          s++;
 688:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 68c:	eb 01                	jmp    68f <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 68e:	90                   	nop
 68f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 692:	0f b6 00             	movzbl (%eax),%eax
 695:	84 c0                	test   %al,%al
 697:	75 d7                	jne    670 <printf+0x101>
 699:	eb 68                	jmp    703 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 69b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 69f:	75 1d                	jne    6be <printf+0x14f>
        putc(fd, *ap);
 6a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	0f be c0             	movsbl %al,%eax
 6a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ad:	8b 45 08             	mov    0x8(%ebp),%eax
 6b0:	89 04 24             	mov    %eax,(%esp)
 6b3:	e8 e0 fd ff ff       	call   498 <putc>
        ap++;
 6b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6bc:	eb 45                	jmp    703 <printf+0x194>
      } else if(c == '%'){
 6be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c2:	75 17                	jne    6db <printf+0x16c>
        putc(fd, c);
 6c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c7:	0f be c0             	movsbl %al,%eax
 6ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ce:	8b 45 08             	mov    0x8(%ebp),%eax
 6d1:	89 04 24             	mov    %eax,(%esp)
 6d4:	e8 bf fd ff ff       	call   498 <putc>
 6d9:	eb 28                	jmp    703 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6db:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6e2:	00 
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	89 04 24             	mov    %eax,(%esp)
 6e9:	e8 aa fd ff ff       	call   498 <putc>
        putc(fd, c);
 6ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f1:	0f be c0             	movsbl %al,%eax
 6f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f8:	8b 45 08             	mov    0x8(%ebp),%eax
 6fb:	89 04 24             	mov    %eax,(%esp)
 6fe:	e8 95 fd ff ff       	call   498 <putc>
      }
      state = 0;
 703:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 70a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 70e:	8b 55 0c             	mov    0xc(%ebp),%edx
 711:	8b 45 f0             	mov    -0x10(%ebp),%eax
 714:	01 d0                	add    %edx,%eax
 716:	0f b6 00             	movzbl (%eax),%eax
 719:	84 c0                	test   %al,%al
 71b:	0f 85 70 fe ff ff    	jne    591 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 721:	c9                   	leave  
 722:	c3                   	ret    
 723:	90                   	nop

00000724 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 724:	55                   	push   %ebp
 725:	89 e5                	mov    %esp,%ebp
 727:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72a:	8b 45 08             	mov    0x8(%ebp),%eax
 72d:	83 e8 08             	sub    $0x8,%eax
 730:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 733:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 738:	89 45 fc             	mov    %eax,-0x4(%ebp)
 73b:	eb 24                	jmp    761 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 745:	77 12                	ja     759 <free+0x35>
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74d:	77 24                	ja     773 <free+0x4f>
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 00                	mov    (%eax),%eax
 754:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 757:	77 1a                	ja     773 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 767:	76 d4                	jbe    73d <free+0x19>
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 771:	76 ca                	jbe    73d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	8b 40 04             	mov    0x4(%eax),%eax
 779:	c1 e0 03             	shl    $0x3,%eax
 77c:	89 c2                	mov    %eax,%edx
 77e:	03 55 f8             	add    -0x8(%ebp),%edx
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	39 c2                	cmp    %eax,%edx
 788:	75 24                	jne    7ae <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 78a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78d:	8b 50 04             	mov    0x4(%eax),%edx
 790:	8b 45 fc             	mov    -0x4(%ebp),%eax
 793:	8b 00                	mov    (%eax),%eax
 795:	8b 40 04             	mov    0x4(%eax),%eax
 798:	01 c2                	add    %eax,%edx
 79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a3:	8b 00                	mov    (%eax),%eax
 7a5:	8b 10                	mov    (%eax),%edx
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	89 10                	mov    %edx,(%eax)
 7ac:	eb 0a                	jmp    7b8 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	8b 10                	mov    (%eax),%edx
 7b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 40 04             	mov    0x4(%eax),%eax
 7be:	c1 e0 03             	shl    $0x3,%eax
 7c1:	03 45 fc             	add    -0x4(%ebp),%eax
 7c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c7:	75 20                	jne    7e9 <free+0xc5>
    p->s.size += bp->s.size;
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 50 04             	mov    0x4(%eax),%edx
 7cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	01 c2                	add    %eax,%edx
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e0:	8b 10                	mov    (%eax),%edx
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	89 10                	mov    %edx,(%eax)
 7e7:	eb 08                	jmp    7f1 <free+0xcd>
  } else
    p->s.ptr = bp;
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ef:	89 10                	mov    %edx,(%eax)
  freep = p;
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	a3 fc 0b 00 00       	mov    %eax,0xbfc
}
 7f9:	c9                   	leave  
 7fa:	c3                   	ret    

000007fb <morecore>:

static Header*
morecore(uint nu)
{
 7fb:	55                   	push   %ebp
 7fc:	89 e5                	mov    %esp,%ebp
 7fe:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 801:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 808:	77 07                	ja     811 <morecore+0x16>
    nu = 4096;
 80a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 811:	8b 45 08             	mov    0x8(%ebp),%eax
 814:	c1 e0 03             	shl    $0x3,%eax
 817:	89 04 24             	mov    %eax,(%esp)
 81a:	e8 21 fc ff ff       	call   440 <sbrk>
 81f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 822:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 826:	75 07                	jne    82f <morecore+0x34>
    return 0;
 828:	b8 00 00 00 00       	mov    $0x0,%eax
 82d:	eb 22                	jmp    851 <morecore+0x56>
  hp = (Header*)p;
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 835:	8b 45 f0             	mov    -0x10(%ebp),%eax
 838:	8b 55 08             	mov    0x8(%ebp),%edx
 83b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 83e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 841:	83 c0 08             	add    $0x8,%eax
 844:	89 04 24             	mov    %eax,(%esp)
 847:	e8 d8 fe ff ff       	call   724 <free>
  return freep;
 84c:	a1 fc 0b 00 00       	mov    0xbfc,%eax
}
 851:	c9                   	leave  
 852:	c3                   	ret    

00000853 <malloc>:

void*
malloc(uint nbytes)
{
 853:	55                   	push   %ebp
 854:	89 e5                	mov    %esp,%ebp
 856:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 859:	8b 45 08             	mov    0x8(%ebp),%eax
 85c:	83 c0 07             	add    $0x7,%eax
 85f:	c1 e8 03             	shr    $0x3,%eax
 862:	83 c0 01             	add    $0x1,%eax
 865:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 868:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 86d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 870:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 874:	75 23                	jne    899 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 876:	c7 45 f0 f4 0b 00 00 	movl   $0xbf4,-0x10(%ebp)
 87d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 880:	a3 fc 0b 00 00       	mov    %eax,0xbfc
 885:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 88a:	a3 f4 0b 00 00       	mov    %eax,0xbf4
    base.s.size = 0;
 88f:	c7 05 f8 0b 00 00 00 	movl   $0x0,0xbf8
 896:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 899:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89c:	8b 00                	mov    (%eax),%eax
 89e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	8b 40 04             	mov    0x4(%eax),%eax
 8a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8aa:	72 4d                	jb     8f9 <malloc+0xa6>
      if(p->s.size == nunits)
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 40 04             	mov    0x4(%eax),%eax
 8b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b5:	75 0c                	jne    8c3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	8b 10                	mov    (%eax),%edx
 8bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bf:	89 10                	mov    %edx,(%eax)
 8c1:	eb 26                	jmp    8e9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 40 04             	mov    0x4(%eax),%eax
 8c9:	89 c2                	mov    %eax,%edx
 8cb:	2b 55 ec             	sub    -0x14(%ebp),%edx
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	c1 e0 03             	shl    $0x3,%eax
 8dd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8e6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ec:	a3 fc 0b 00 00       	mov    %eax,0xbfc
      return (void*)(p + 1);
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	83 c0 08             	add    $0x8,%eax
 8f7:	eb 38                	jmp    931 <malloc+0xde>
    }
    if(p == freep)
 8f9:	a1 fc 0b 00 00       	mov    0xbfc,%eax
 8fe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 901:	75 1b                	jne    91e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 903:	8b 45 ec             	mov    -0x14(%ebp),%eax
 906:	89 04 24             	mov    %eax,(%esp)
 909:	e8 ed fe ff ff       	call   7fb <morecore>
 90e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 915:	75 07                	jne    91e <malloc+0xcb>
        return 0;
 917:	b8 00 00 00 00       	mov    $0x0,%eax
 91c:	eb 13                	jmp    931 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 921:	89 45 f0             	mov    %eax,-0x10(%ebp)
 924:	8b 45 f4             	mov    -0xc(%ebp),%eax
 927:	8b 00                	mov    (%eax),%eax
 929:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 92c:	e9 70 ff ff ff       	jmp    8a1 <malloc+0x4e>
}
 931:	c9                   	leave  
 932:	c3                   	ret    
