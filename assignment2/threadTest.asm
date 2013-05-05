
_threadTest:     file format elf32-i386


Disassembly of section .text:

00000000 <printme>:
#define STACK_SIZE 1024
#define NUM_OF_PRINTS 3



void *printme(int* sem) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  int j;
  if(thread_getId() != thread_getProcId()){
   7:	e8 08 04 00 00       	call   414 <thread_getId>
   c:	89 c3                	mov    %eax,%ebx
   e:	e8 09 04 00 00       	call   41c <thread_getProcId>
  13:	39 c3                	cmp    %eax,%ebx
  15:	74 57                	je     6e <printme+0x6e>
    for(;;){
      binary_semaphore_down(*sem);
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	8b 00                	mov    (%eax),%eax
  1c:	89 04 24             	mov    %eax,(%esp)
  1f:	e8 18 04 00 00       	call   43c <binary_semaphore_down>
      for(j = 0; j < NUM_OF_PRINTS; j++){
  24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  2b:	eb 2c                	jmp    59 <printme+0x59>
	  printf(1,"Process %d Thread %d is running\n",thread_getProcId(),thread_getId());
  2d:	e8 e2 03 00 00       	call   414 <thread_getId>
  32:	89 c3                	mov    %eax,%ebx
  34:	e8 e3 03 00 00       	call   41c <thread_getProcId>
  39:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  41:	c7 44 24 04 14 0a 00 	movl   $0xa14,0x4(%esp)
  48:	00 
  49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  50:	e8 ce 04 00 00       	call   523 <printf>
void *printme(int* sem) {
  int j;
  if(thread_getId() != thread_getProcId()){
    for(;;){
      binary_semaphore_down(*sem);
      for(j = 0; j < NUM_OF_PRINTS; j++){
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
  5d:	7e ce                	jle    2d <printme+0x2d>
	  printf(1,"Process %d Thread %d is running\n",thread_getProcId(),thread_getId());
      }
      binary_semaphore_up(*sem);    
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8b 00                	mov    (%eax),%eax
  64:	89 04 24             	mov    %eax,(%esp)
  67:	e8 d8 03 00 00       	call   444 <binary_semaphore_up>
    }
  6c:	eb a9                	jmp    17 <printme+0x17>
  }
  return 0;
  6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  73:	83 c4 24             	add    $0x24,%esp
  76:	5b                   	pop    %ebx
  77:	5d                   	pop    %ebp
  78:	c3                   	ret    

00000079 <main>:

int main(int argc, char** argv) {
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	83 e4 f0             	and    $0xfffffff0,%esp
  7f:	83 ec 20             	sub    $0x20,%esp
    int num_of_threads = atoi(argv[1]);
  82:	8b 45 0c             	mov    0xc(%ebp),%eax
  85:	83 c0 04             	add    $0x4,%eax
  88:	8b 00                	mov    (%eax),%eax
  8a:	89 04 24             	mov    %eax,(%esp)
  8d:	e8 49 02 00 00       	call   2db <atoi>
  92:	89 44 24 18          	mov    %eax,0x18(%esp)
    int i;
    int the_lock;
    the_lock = binary_semaphore_create(1);
  96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9d:	e8 92 03 00 00       	call   434 <binary_semaphore_create>
  a2:	89 44 24 10          	mov    %eax,0x10(%esp)
    void * stack;
    for(i = 0; i < num_of_threads; i++){
  a6:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  ad:	00 
  ae:	eb 39                	jmp    e9 <main+0x70>
      
	stack = (void*)malloc (STACK_SIZE);
  b0:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  b7:	e8 4b 07 00 00       	call   807 <malloc>
  bc:	89 44 24 14          	mov    %eax,0x14(%esp)
	thread_create(printme(&the_lock),stack,STACK_SIZE);
  c0:	8d 44 24 10          	lea    0x10(%esp),%eax
  c4:	89 04 24             	mov    %eax,(%esp)
  c7:	e8 34 ff ff ff       	call   0 <printme>
  cc:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  d3:	00 
  d4:	8b 54 24 14          	mov    0x14(%esp),%edx
  d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  dc:	89 04 24             	mov    %eax,(%esp)
  df:	e8 28 03 00 00       	call   40c <thread_create>
    int num_of_threads = atoi(argv[1]);
    int i;
    int the_lock;
    the_lock = binary_semaphore_create(1);
    void * stack;
    for(i = 0; i < num_of_threads; i++){
  e4:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  e9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  ed:	3b 44 24 18          	cmp    0x18(%esp),%eax
  f1:	7c bd                	jl     b0 <main+0x37>
  f3:	eb 01                	jmp    f6 <main+0x7d>
	thread_create(printme(&the_lock),stack,STACK_SIZE);
    }
    for(;;){
	if(wait() == -1)
	  break;
    }
  f5:	90                   	nop
      
	stack = (void*)malloc (STACK_SIZE);
	thread_create(printme(&the_lock),stack,STACK_SIZE);
    }
    for(;;){
	if(wait() == -1)
  f6:	e8 79 02 00 00       	call   374 <wait>
  fb:	83 f8 ff             	cmp    $0xffffffff,%eax
  fe:	75 f5                	jne    f5 <main+0x7c>
	  break;
 100:	90                   	nop
    }
    exit();
 101:	e8 66 02 00 00       	call   36c <exit>
 106:	90                   	nop
 107:	90                   	nop

00000108 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	57                   	push   %edi
 10c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 10d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 110:	8b 55 10             	mov    0x10(%ebp),%edx
 113:	8b 45 0c             	mov    0xc(%ebp),%eax
 116:	89 cb                	mov    %ecx,%ebx
 118:	89 df                	mov    %ebx,%edi
 11a:	89 d1                	mov    %edx,%ecx
 11c:	fc                   	cld    
 11d:	f3 aa                	rep stos %al,%es:(%edi)
 11f:	89 ca                	mov    %ecx,%edx
 121:	89 fb                	mov    %edi,%ebx
 123:	89 5d 08             	mov    %ebx,0x8(%ebp)
 126:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 129:	5b                   	pop    %ebx
 12a:	5f                   	pop    %edi
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    

0000012d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 139:	90                   	nop
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	0f b6 10             	movzbl (%eax),%edx
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	88 10                	mov    %dl,(%eax)
 145:	8b 45 08             	mov    0x8(%ebp),%eax
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	84 c0                	test   %al,%al
 14d:	0f 95 c0             	setne  %al
 150:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 154:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 158:	84 c0                	test   %al,%al
 15a:	75 de                	jne    13a <strcpy+0xd>
    ;
  return os;
 15c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15f:	c9                   	leave  
 160:	c3                   	ret    

00000161 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 164:	eb 08                	jmp    16e <strcmp+0xd>
    p++, q++;
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	84 c0                	test   %al,%al
 176:	74 10                	je     188 <strcmp+0x27>
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	0f b6 10             	movzbl (%eax),%edx
 17e:	8b 45 0c             	mov    0xc(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	38 c2                	cmp    %al,%dl
 186:	74 de                	je     166 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	0f b6 d0             	movzbl %al,%edx
 191:	8b 45 0c             	mov    0xc(%ebp),%eax
 194:	0f b6 00             	movzbl (%eax),%eax
 197:	0f b6 c0             	movzbl %al,%eax
 19a:	89 d1                	mov    %edx,%ecx
 19c:	29 c1                	sub    %eax,%ecx
 19e:	89 c8                	mov    %ecx,%eax
}
 1a0:	5d                   	pop    %ebp
 1a1:	c3                   	ret    

000001a2 <strlen>:

uint
strlen(char *s)
{
 1a2:	55                   	push   %ebp
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1af:	eb 04                	jmp    1b5 <strlen+0x13>
 1b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1b8:	03 45 08             	add    0x8(%ebp),%eax
 1bb:	0f b6 00             	movzbl (%eax),%eax
 1be:	84 c0                	test   %al,%al
 1c0:	75 ef                	jne    1b1 <strlen+0xf>
    ;
  return n;
 1c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c5:	c9                   	leave  
 1c6:	c3                   	ret    

000001c7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c7:	55                   	push   %ebp
 1c8:	89 e5                	mov    %esp,%ebp
 1ca:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1cd:	8b 45 10             	mov    0x10(%ebp),%eax
 1d0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	89 04 24             	mov    %eax,(%esp)
 1e1:	e8 22 ff ff ff       	call   108 <stosb>
  return dst;
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <strchr>:

char*
strchr(const char *s, char c)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	83 ec 04             	sub    $0x4,%esp
 1f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f7:	eb 14                	jmp    20d <strchr+0x22>
    if(*s == c)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	3a 45 fc             	cmp    -0x4(%ebp),%al
 202:	75 05                	jne    209 <strchr+0x1e>
      return (char*)s;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	eb 13                	jmp    21c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 209:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	0f b6 00             	movzbl (%eax),%eax
 213:	84 c0                	test   %al,%al
 215:	75 e2                	jne    1f9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 217:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <gets>:

char*
gets(char *buf, int max)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22b:	eb 44                	jmp    271 <gets+0x53>
    cc = read(0, &c, 1);
 22d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 234:	00 
 235:	8d 45 ef             	lea    -0x11(%ebp),%eax
 238:	89 44 24 04          	mov    %eax,0x4(%esp)
 23c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 243:	e8 3c 01 00 00       	call   384 <read>
 248:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24f:	7e 2d                	jle    27e <gets+0x60>
      break;
    buf[i++] = c;
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
 254:	03 45 08             	add    0x8(%ebp),%eax
 257:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 25b:	88 10                	mov    %dl,(%eax)
 25d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0a                	cmp    $0xa,%al
 267:	74 16                	je     27f <gets+0x61>
 269:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26d:	3c 0d                	cmp    $0xd,%al
 26f:	74 0e                	je     27f <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 271:	8b 45 f4             	mov    -0xc(%ebp),%eax
 274:	83 c0 01             	add    $0x1,%eax
 277:	3b 45 0c             	cmp    0xc(%ebp),%eax
 27a:	7c b1                	jl     22d <gets+0xf>
 27c:	eb 01                	jmp    27f <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 27e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 282:	03 45 08             	add    0x8(%ebp),%eax
 285:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 288:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28b:	c9                   	leave  
 28c:	c3                   	ret    

0000028d <stat>:

int
stat(char *n, struct stat *st)
{
 28d:	55                   	push   %ebp
 28e:	89 e5                	mov    %esp,%ebp
 290:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 293:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 29a:	00 
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	89 04 24             	mov    %eax,(%esp)
 2a1:	e8 06 01 00 00       	call   3ac <open>
 2a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2ad:	79 07                	jns    2b6 <stat+0x29>
    return -1;
 2af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b4:	eb 23                	jmp    2d9 <stat+0x4c>
  r = fstat(fd, st);
 2b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c0:	89 04 24             	mov    %eax,(%esp)
 2c3:	e8 fc 00 00 00       	call   3c4 <fstat>
 2c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ce:	89 04 24             	mov    %eax,(%esp)
 2d1:	e8 be 00 00 00       	call   394 <close>
  return r;
 2d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d9:	c9                   	leave  
 2da:	c3                   	ret    

000002db <atoi>:

int
atoi(const char *s)
{
 2db:	55                   	push   %ebp
 2dc:	89 e5                	mov    %esp,%ebp
 2de:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e8:	eb 23                	jmp    30d <atoi+0x32>
    n = n*10 + *s++ - '0';
 2ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ed:	89 d0                	mov    %edx,%eax
 2ef:	c1 e0 02             	shl    $0x2,%eax
 2f2:	01 d0                	add    %edx,%eax
 2f4:	01 c0                	add    %eax,%eax
 2f6:	89 c2                	mov    %eax,%edx
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	0f b6 00             	movzbl (%eax),%eax
 2fe:	0f be c0             	movsbl %al,%eax
 301:	01 d0                	add    %edx,%eax
 303:	83 e8 30             	sub    $0x30,%eax
 306:	89 45 fc             	mov    %eax,-0x4(%ebp)
 309:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	0f b6 00             	movzbl (%eax),%eax
 313:	3c 2f                	cmp    $0x2f,%al
 315:	7e 0a                	jle    321 <atoi+0x46>
 317:	8b 45 08             	mov    0x8(%ebp),%eax
 31a:	0f b6 00             	movzbl (%eax),%eax
 31d:	3c 39                	cmp    $0x39,%al
 31f:	7e c9                	jle    2ea <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 321:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 324:	c9                   	leave  
 325:	c3                   	ret    

00000326 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 338:	eb 13                	jmp    34d <memmove+0x27>
    *dst++ = *src++;
 33a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33d:	0f b6 10             	movzbl (%eax),%edx
 340:	8b 45 fc             	mov    -0x4(%ebp),%eax
 343:	88 10                	mov    %dl,(%eax)
 345:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 349:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 351:	0f 9f c0             	setg   %al
 354:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 358:	84 c0                	test   %al,%al
 35a:	75 de                	jne    33a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    
 361:	90                   	nop
 362:	90                   	nop
 363:	90                   	nop

00000364 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 364:	b8 01 00 00 00       	mov    $0x1,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <exit>:
SYSCALL(exit)
 36c:	b8 02 00 00 00       	mov    $0x2,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <wait>:
SYSCALL(wait)
 374:	b8 03 00 00 00       	mov    $0x3,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <pipe>:
SYSCALL(pipe)
 37c:	b8 04 00 00 00       	mov    $0x4,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <read>:
SYSCALL(read)
 384:	b8 05 00 00 00       	mov    $0x5,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <write>:
SYSCALL(write)
 38c:	b8 10 00 00 00       	mov    $0x10,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <close>:
SYSCALL(close)
 394:	b8 15 00 00 00       	mov    $0x15,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <kill>:
SYSCALL(kill)
 39c:	b8 06 00 00 00       	mov    $0x6,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <exec>:
SYSCALL(exec)
 3a4:	b8 07 00 00 00       	mov    $0x7,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <open>:
SYSCALL(open)
 3ac:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <mknod>:
SYSCALL(mknod)
 3b4:	b8 11 00 00 00       	mov    $0x11,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <unlink>:
SYSCALL(unlink)
 3bc:	b8 12 00 00 00       	mov    $0x12,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <fstat>:
SYSCALL(fstat)
 3c4:	b8 08 00 00 00       	mov    $0x8,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <link>:
SYSCALL(link)
 3cc:	b8 13 00 00 00       	mov    $0x13,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <mkdir>:
SYSCALL(mkdir)
 3d4:	b8 14 00 00 00       	mov    $0x14,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <chdir>:
SYSCALL(chdir)
 3dc:	b8 09 00 00 00       	mov    $0x9,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <dup>:
SYSCALL(dup)
 3e4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <getpid>:
SYSCALL(getpid)
 3ec:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <sbrk>:
SYSCALL(sbrk)
 3f4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <sleep>:
SYSCALL(sleep)
 3fc:	b8 0d 00 00 00       	mov    $0xd,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <uptime>:
SYSCALL(uptime)
 404:	b8 0e 00 00 00       	mov    $0xe,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <thread_create>:
SYSCALL(thread_create)
 40c:	b8 16 00 00 00       	mov    $0x16,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <thread_getId>:
SYSCALL(thread_getId)
 414:	b8 17 00 00 00       	mov    $0x17,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <thread_getProcId>:
SYSCALL(thread_getProcId)
 41c:	b8 18 00 00 00       	mov    $0x18,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <thread_join>:
SYSCALL(thread_join)
 424:	b8 19 00 00 00       	mov    $0x19,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <thread_exit>:
SYSCALL(thread_exit)
 42c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
 434:	b8 1b 00 00 00       	mov    $0x1b,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
 43c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
 444:	b8 1d 00 00 00       	mov    $0x1d,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 28             	sub    $0x28,%esp
 452:	8b 45 0c             	mov    0xc(%ebp),%eax
 455:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 458:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 45f:	00 
 460:	8d 45 f4             	lea    -0xc(%ebp),%eax
 463:	89 44 24 04          	mov    %eax,0x4(%esp)
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	89 04 24             	mov    %eax,(%esp)
 46d:	e8 1a ff ff ff       	call   38c <write>
}
 472:	c9                   	leave  
 473:	c3                   	ret    

00000474 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 47a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 481:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 485:	74 17                	je     49e <printint+0x2a>
 487:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 48b:	79 11                	jns    49e <printint+0x2a>
    neg = 1;
 48d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 494:	8b 45 0c             	mov    0xc(%ebp),%eax
 497:	f7 d8                	neg    %eax
 499:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49c:	eb 06                	jmp    4a4 <printint+0x30>
  } else {
    x = xx;
 49e:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b1:	ba 00 00 00 00       	mov    $0x0,%edx
 4b6:	f7 f1                	div    %ecx
 4b8:	89 d0                	mov    %edx,%eax
 4ba:	0f b6 90 30 0d 00 00 	movzbl 0xd30(%eax),%edx
 4c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4c4:	03 45 f4             	add    -0xc(%ebp),%eax
 4c7:	88 10                	mov    %dl,(%eax)
 4c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 4cd:	8b 55 10             	mov    0x10(%ebp),%edx
 4d0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d6:	ba 00 00 00 00       	mov    $0x0,%edx
 4db:	f7 75 d4             	divl   -0x2c(%ebp)
 4de:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e5:	75 c4                	jne    4ab <printint+0x37>
  if(neg)
 4e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4eb:	74 2a                	je     517 <printint+0xa3>
    buf[i++] = '-';
 4ed:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4f0:	03 45 f4             	add    -0xc(%ebp),%eax
 4f3:	c6 00 2d             	movb   $0x2d,(%eax)
 4f6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 4fa:	eb 1b                	jmp    517 <printint+0xa3>
    putc(fd, buf[i]);
 4fc:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4ff:	03 45 f4             	add    -0xc(%ebp),%eax
 502:	0f b6 00             	movzbl (%eax),%eax
 505:	0f be c0             	movsbl %al,%eax
 508:	89 44 24 04          	mov    %eax,0x4(%esp)
 50c:	8b 45 08             	mov    0x8(%ebp),%eax
 50f:	89 04 24             	mov    %eax,(%esp)
 512:	e8 35 ff ff ff       	call   44c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 517:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 51b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51f:	79 db                	jns    4fc <printint+0x88>
    putc(fd, buf[i]);
}
 521:	c9                   	leave  
 522:	c3                   	ret    

00000523 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 523:	55                   	push   %ebp
 524:	89 e5                	mov    %esp,%ebp
 526:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 529:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 530:	8d 45 0c             	lea    0xc(%ebp),%eax
 533:	83 c0 04             	add    $0x4,%eax
 536:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 540:	e9 7d 01 00 00       	jmp    6c2 <printf+0x19f>
    c = fmt[i] & 0xff;
 545:	8b 55 0c             	mov    0xc(%ebp),%edx
 548:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54b:	01 d0                	add    %edx,%eax
 54d:	0f b6 00             	movzbl (%eax),%eax
 550:	0f be c0             	movsbl %al,%eax
 553:	25 ff 00 00 00       	and    $0xff,%eax
 558:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 55b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55f:	75 2c                	jne    58d <printf+0x6a>
      if(c == '%'){
 561:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 565:	75 0c                	jne    573 <printf+0x50>
        state = '%';
 567:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56e:	e9 4b 01 00 00       	jmp    6be <printf+0x19b>
      } else {
        putc(fd, c);
 573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	89 44 24 04          	mov    %eax,0x4(%esp)
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	89 04 24             	mov    %eax,(%esp)
 583:	e8 c4 fe ff ff       	call   44c <putc>
 588:	e9 31 01 00 00       	jmp    6be <printf+0x19b>
      }
    } else if(state == '%'){
 58d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 591:	0f 85 27 01 00 00    	jne    6be <printf+0x19b>
      if(c == 'd'){
 597:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 59b:	75 2d                	jne    5ca <printf+0xa7>
        printint(fd, *ap, 10, 1);
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5a9:	00 
 5aa:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5b1:	00 
 5b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	89 04 24             	mov    %eax,(%esp)
 5bc:	e8 b3 fe ff ff       	call   474 <printint>
        ap++;
 5c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c5:	e9 ed 00 00 00       	jmp    6b7 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 5ca:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ce:	74 06                	je     5d6 <printf+0xb3>
 5d0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d4:	75 2d                	jne    603 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d9:	8b 00                	mov    (%eax),%eax
 5db:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5e2:	00 
 5e3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5ea:	00 
 5eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	89 04 24             	mov    %eax,(%esp)
 5f5:	e8 7a fe ff ff       	call   474 <printint>
        ap++;
 5fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fe:	e9 b4 00 00 00       	jmp    6b7 <printf+0x194>
      } else if(c == 's'){
 603:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 607:	75 46                	jne    64f <printf+0x12c>
        s = (char*)*ap;
 609:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60c:	8b 00                	mov    (%eax),%eax
 60e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 619:	75 27                	jne    642 <printf+0x11f>
          s = "(null)";
 61b:	c7 45 f4 35 0a 00 00 	movl   $0xa35,-0xc(%ebp)
        while(*s != 0){
 622:	eb 1e                	jmp    642 <printf+0x11f>
          putc(fd, *s);
 624:	8b 45 f4             	mov    -0xc(%ebp),%eax
 627:	0f b6 00             	movzbl (%eax),%eax
 62a:	0f be c0             	movsbl %al,%eax
 62d:	89 44 24 04          	mov    %eax,0x4(%esp)
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	89 04 24             	mov    %eax,(%esp)
 637:	e8 10 fe ff ff       	call   44c <putc>
          s++;
 63c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 640:	eb 01                	jmp    643 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 642:	90                   	nop
 643:	8b 45 f4             	mov    -0xc(%ebp),%eax
 646:	0f b6 00             	movzbl (%eax),%eax
 649:	84 c0                	test   %al,%al
 64b:	75 d7                	jne    624 <printf+0x101>
 64d:	eb 68                	jmp    6b7 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 653:	75 1d                	jne    672 <printf+0x14f>
        putc(fd, *ap);
 655:	8b 45 e8             	mov    -0x18(%ebp),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	0f be c0             	movsbl %al,%eax
 65d:	89 44 24 04          	mov    %eax,0x4(%esp)
 661:	8b 45 08             	mov    0x8(%ebp),%eax
 664:	89 04 24             	mov    %eax,(%esp)
 667:	e8 e0 fd ff ff       	call   44c <putc>
        ap++;
 66c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 670:	eb 45                	jmp    6b7 <printf+0x194>
      } else if(c == '%'){
 672:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 676:	75 17                	jne    68f <printf+0x16c>
        putc(fd, c);
 678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67b:	0f be c0             	movsbl %al,%eax
 67e:	89 44 24 04          	mov    %eax,0x4(%esp)
 682:	8b 45 08             	mov    0x8(%ebp),%eax
 685:	89 04 24             	mov    %eax,(%esp)
 688:	e8 bf fd ff ff       	call   44c <putc>
 68d:	eb 28                	jmp    6b7 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 68f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 696:	00 
 697:	8b 45 08             	mov    0x8(%ebp),%eax
 69a:	89 04 24             	mov    %eax,(%esp)
 69d:	e8 aa fd ff ff       	call   44c <putc>
        putc(fd, c);
 6a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a5:	0f be c0             	movsbl %al,%eax
 6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 95 fd ff ff       	call   44c <putc>
      }
      state = 0;
 6b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6be:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c2:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c8:	01 d0                	add    %edx,%eax
 6ca:	0f b6 00             	movzbl (%eax),%eax
 6cd:	84 c0                	test   %al,%al
 6cf:	0f 85 70 fe ff ff    	jne    545 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d5:	c9                   	leave  
 6d6:	c3                   	ret    
 6d7:	90                   	nop

000006d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d8:	55                   	push   %ebp
 6d9:	89 e5                	mov    %esp,%ebp
 6db:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6de:	8b 45 08             	mov    0x8(%ebp),%eax
 6e1:	83 e8 08             	sub    $0x8,%eax
 6e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e7:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 6ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ef:	eb 24                	jmp    715 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f9:	77 12                	ja     70d <free+0x35>
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 701:	77 24                	ja     727 <free+0x4f>
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	8b 00                	mov    (%eax),%eax
 708:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70b:	77 1a                	ja     727 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	89 45 fc             	mov    %eax,-0x4(%ebp)
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71b:	76 d4                	jbe    6f1 <free+0x19>
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 725:	76 ca                	jbe    6f1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	8b 40 04             	mov    0x4(%eax),%eax
 72d:	c1 e0 03             	shl    $0x3,%eax
 730:	89 c2                	mov    %eax,%edx
 732:	03 55 f8             	add    -0x8(%ebp),%edx
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	39 c2                	cmp    %eax,%edx
 73c:	75 24                	jne    762 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	8b 50 04             	mov    0x4(%eax),%edx
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	8b 40 04             	mov    0x4(%eax),%eax
 74c:	01 c2                	add    %eax,%edx
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	8b 10                	mov    (%eax),%edx
 75b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75e:	89 10                	mov    %edx,(%eax)
 760:	eb 0a                	jmp    76c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 10                	mov    (%eax),%edx
 767:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 76c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	c1 e0 03             	shl    $0x3,%eax
 775:	03 45 fc             	add    -0x4(%ebp),%eax
 778:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77b:	75 20                	jne    79d <free+0xc5>
    p->s.size += bp->s.size;
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	8b 50 04             	mov    0x4(%eax),%edx
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	01 c2                	add    %eax,%edx
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 791:	8b 45 f8             	mov    -0x8(%ebp),%eax
 794:	8b 10                	mov    (%eax),%edx
 796:	8b 45 fc             	mov    -0x4(%ebp),%eax
 799:	89 10                	mov    %edx,(%eax)
 79b:	eb 08                	jmp    7a5 <free+0xcd>
  } else
    p->s.ptr = bp;
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a3:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	a3 4c 0d 00 00       	mov    %eax,0xd4c
}
 7ad:	c9                   	leave  
 7ae:	c3                   	ret    

000007af <morecore>:

static Header*
morecore(uint nu)
{
 7af:	55                   	push   %ebp
 7b0:	89 e5                	mov    %esp,%ebp
 7b2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7bc:	77 07                	ja     7c5 <morecore+0x16>
    nu = 4096;
 7be:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
 7c8:	c1 e0 03             	shl    $0x3,%eax
 7cb:	89 04 24             	mov    %eax,(%esp)
 7ce:	e8 21 fc ff ff       	call   3f4 <sbrk>
 7d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7da:	75 07                	jne    7e3 <morecore+0x34>
    return 0;
 7dc:	b8 00 00 00 00       	mov    $0x0,%eax
 7e1:	eb 22                	jmp    805 <morecore+0x56>
  hp = (Header*)p;
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ec:	8b 55 08             	mov    0x8(%ebp),%edx
 7ef:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f5:	83 c0 08             	add    $0x8,%eax
 7f8:	89 04 24             	mov    %eax,(%esp)
 7fb:	e8 d8 fe ff ff       	call   6d8 <free>
  return freep;
 800:	a1 4c 0d 00 00       	mov    0xd4c,%eax
}
 805:	c9                   	leave  
 806:	c3                   	ret    

00000807 <malloc>:

void*
malloc(uint nbytes)
{
 807:	55                   	push   %ebp
 808:	89 e5                	mov    %esp,%ebp
 80a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80d:	8b 45 08             	mov    0x8(%ebp),%eax
 810:	83 c0 07             	add    $0x7,%eax
 813:	c1 e8 03             	shr    $0x3,%eax
 816:	83 c0 01             	add    $0x1,%eax
 819:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 81c:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 821:	89 45 f0             	mov    %eax,-0x10(%ebp)
 824:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 828:	75 23                	jne    84d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 82a:	c7 45 f0 44 0d 00 00 	movl   $0xd44,-0x10(%ebp)
 831:	8b 45 f0             	mov    -0x10(%ebp),%eax
 834:	a3 4c 0d 00 00       	mov    %eax,0xd4c
 839:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 83e:	a3 44 0d 00 00       	mov    %eax,0xd44
    base.s.size = 0;
 843:	c7 05 48 0d 00 00 00 	movl   $0x0,0xd48
 84a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 850:	8b 00                	mov    (%eax),%eax
 852:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	8b 40 04             	mov    0x4(%eax),%eax
 85b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85e:	72 4d                	jb     8ad <malloc+0xa6>
      if(p->s.size == nunits)
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	8b 40 04             	mov    0x4(%eax),%eax
 866:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 869:	75 0c                	jne    877 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8b 10                	mov    (%eax),%edx
 870:	8b 45 f0             	mov    -0x10(%ebp),%eax
 873:	89 10                	mov    %edx,(%eax)
 875:	eb 26                	jmp    89d <malloc+0x96>
      else {
        p->s.size -= nunits;
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8b 40 04             	mov    0x4(%eax),%eax
 87d:	89 c2                	mov    %eax,%edx
 87f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8b 40 04             	mov    0x4(%eax),%eax
 88e:	c1 e0 03             	shl    $0x3,%eax
 891:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 55 ec             	mov    -0x14(%ebp),%edx
 89a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a0:	a3 4c 0d 00 00       	mov    %eax,0xd4c
      return (void*)(p + 1);
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	83 c0 08             	add    $0x8,%eax
 8ab:	eb 38                	jmp    8e5 <malloc+0xde>
    }
    if(p == freep)
 8ad:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 8b2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b5:	75 1b                	jne    8d2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ba:	89 04 24             	mov    %eax,(%esp)
 8bd:	e8 ed fe ff ff       	call   7af <morecore>
 8c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c9:	75 07                	jne    8d2 <malloc+0xcb>
        return 0;
 8cb:	b8 00 00 00 00       	mov    $0x0,%eax
 8d0:	eb 13                	jmp    8e5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 00                	mov    (%eax),%eax
 8dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e0:	e9 70 ff ff ff       	jmp    855 <malloc+0x4e>
}
 8e5:	c9                   	leave  
 8e6:	c3                   	ret    
 8e7:	90                   	nop

000008e8 <semaphore_create>:
#include "semaphore.h"
#include "types.h"
#include "user.h"


struct semaphore* semaphore_create(int initial_semaphore_value){
 8e8:	55                   	push   %ebp
 8e9:	89 e5                	mov    %esp,%ebp
 8eb:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* sem=malloc(sizeof(struct semaphore));;
 8ee:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
 8f5:	e8 0d ff ff ff       	call   807 <malloc>
 8fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // acquire semaphors
  sem->s1 = binary_semaphore_create (1);
 8fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 904:	e8 2b fb ff ff       	call   434 <binary_semaphore_create>
 909:	8b 55 f4             	mov    -0xc(%ebp),%edx
 90c:	89 02                	mov    %eax,(%edx)
  sem->s2 = binary_semaphore_create(1);
 90e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 915:	e8 1a fb ff ff       	call   434 <binary_semaphore_create>
 91a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 91d:	89 42 04             	mov    %eax,0x4(%edx)
  if(sem->s1 == -1 || sem->s2 == -1){
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	8b 00                	mov    (%eax),%eax
 925:	83 f8 ff             	cmp    $0xffffffff,%eax
 928:	74 0b                	je     935 <semaphore_create+0x4d>
 92a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92d:	8b 40 04             	mov    0x4(%eax),%eax
 930:	83 f8 ff             	cmp    $0xffffffff,%eax
 933:	75 26                	jne    95b <semaphore_create+0x73>
     printf(1,"we had a probalem initialize in semaphore_create");
 935:	c7 44 24 04 3c 0a 00 	movl   $0xa3c,0x4(%esp)
 93c:	00 
 93d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 944:	e8 da fb ff ff       	call   523 <printf>
   free(sem);
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	89 04 24             	mov    %eax,(%esp)
 94f:	e8 84 fd ff ff       	call   6d8 <free>
   return 0;
 954:	b8 00 00 00 00       	mov    $0x0,%eax
 959:	eb 15                	jmp    970 <semaphore_create+0x88>
  }
  //initialize value
  sem->value = initial_semaphore_value;//dinamic
 95b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95e:	8b 55 08             	mov    0x8(%ebp),%edx
 961:	89 50 08             	mov    %edx,0x8(%eax)
  sem->initial_value = initial_semaphore_value;//static
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	8b 55 08             	mov    0x8(%ebp),%edx
 96a:	89 50 0c             	mov    %edx,0xc(%eax)
  
  return sem;
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 970:	c9                   	leave  
 971:	c3                   	ret    

00000972 <semaphore_down>:
void semaphore_down(struct semaphore* sem ){
 972:	55                   	push   %ebp
 973:	89 e5                	mov    %esp,%ebp
 975:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
 978:	8b 45 08             	mov    0x8(%ebp),%eax
 97b:	8b 00                	mov    (%eax),%eax
 97d:	89 04 24             	mov    %eax,(%esp)
 980:	e8 b7 fa ff ff       	call   43c <binary_semaphore_down>
  binary_semaphore_down(sem->s2);
 985:	8b 45 08             	mov    0x8(%ebp),%eax
 988:	8b 40 04             	mov    0x4(%eax),%eax
 98b:	89 04 24             	mov    %eax,(%esp)
 98e:	e8 a9 fa ff ff       	call   43c <binary_semaphore_down>
  sem->value--;	
 993:	8b 45 08             	mov    0x8(%ebp),%eax
 996:	8b 40 08             	mov    0x8(%eax),%eax
 999:	8d 50 ff             	lea    -0x1(%eax),%edx
 99c:	8b 45 08             	mov    0x8(%ebp),%eax
 99f:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value > 0){
 9a2:	8b 45 08             	mov    0x8(%ebp),%eax
 9a5:	8b 40 08             	mov    0x8(%eax),%eax
 9a8:	85 c0                	test   %eax,%eax
 9aa:	7e 0e                	jle    9ba <semaphore_down+0x48>
   binary_semaphore_up(sem->s2);
 9ac:	8b 45 08             	mov    0x8(%ebp),%eax
 9af:	8b 40 04             	mov    0x4(%eax),%eax
 9b2:	89 04 24             	mov    %eax,(%esp)
 9b5:	e8 8a fa ff ff       	call   444 <binary_semaphore_up>
  }
  binary_semaphore_up(sem->s1); 
 9ba:	8b 45 08             	mov    0x8(%ebp),%eax
 9bd:	8b 00                	mov    (%eax),%eax
 9bf:	89 04 24             	mov    %eax,(%esp)
 9c2:	e8 7d fa ff ff       	call   444 <binary_semaphore_up>
}
 9c7:	c9                   	leave  
 9c8:	c3                   	ret    

000009c9 <semaphore_up>:
void semaphore_up(struct semaphore* sem ){
 9c9:	55                   	push   %ebp
 9ca:	89 e5                	mov    %esp,%ebp
 9cc:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
 9cf:	8b 45 08             	mov    0x8(%ebp),%eax
 9d2:	8b 00                	mov    (%eax),%eax
 9d4:	89 04 24             	mov    %eax,(%esp)
 9d7:	e8 60 fa ff ff       	call   43c <binary_semaphore_down>
  sem->value++;	
 9dc:	8b 45 08             	mov    0x8(%ebp),%eax
 9df:	8b 40 08             	mov    0x8(%eax),%eax
 9e2:	8d 50 01             	lea    0x1(%eax),%edx
 9e5:	8b 45 08             	mov    0x8(%ebp),%eax
 9e8:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value ==1){
 9eb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ee:	8b 40 08             	mov    0x8(%eax),%eax
 9f1:	83 f8 01             	cmp    $0x1,%eax
 9f4:	75 0e                	jne    a04 <semaphore_up+0x3b>
   binary_semaphore_up(sem->s2); 
 9f6:	8b 45 08             	mov    0x8(%ebp),%eax
 9f9:	8b 40 04             	mov    0x4(%eax),%eax
 9fc:	89 04 24             	mov    %eax,(%esp)
 9ff:	e8 40 fa ff ff       	call   444 <binary_semaphore_up>
   }
  binary_semaphore_up(sem->s1);
 a04:	8b 45 08             	mov    0x8(%ebp),%eax
 a07:	8b 00                	mov    (%eax),%eax
 a09:	89 04 24             	mov    %eax,(%esp)
 a0c:	e8 33 fa ff ff       	call   444 <binary_semaphore_up>
 a11:	c9                   	leave  
 a12:	c3                   	ret    
