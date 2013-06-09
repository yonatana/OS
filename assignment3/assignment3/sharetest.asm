
_sharetest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"
#include "mmu.h"
#include "param.h"

int main(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int key = 1;
   9:	c7 44 24 18 01 00 00 	movl   $0x1,0x18(%esp)
  10:	00 
  char box =0;
  11:	c6 44 24 17 00       	movb   $0x0,0x17(%esp)
  char* addr;
  int test =0;
  16:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  1d:	00 
  printf(1,"box has: %d Gulot\n",box);
  1e:	0f be 44 24 17       	movsbl 0x17(%esp),%eax
  23:	89 44 24 08          	mov    %eax,0x8(%esp)
  27:	c7 44 24 04 c4 09 00 	movl   $0x9c4,0x4(%esp)
  2e:	00 
  2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  36:	e8 c4 05 00 00       	call   5ff <printf>
  shmget(key,PGSIZE,CREAT);
  3b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  42:	00 
  43:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  4a:	00 
  4b:	8b 44 24 18          	mov    0x18(%esp),%eax
  4f:	89 04 24             	mov    %eax,(%esp)
  52:	e8 a9 04 00 00       	call   500 <shmget>
  //create a child
  if(fork()==0){
  57:	e8 e4 03 00 00       	call   440 <fork>
  5c:	85 c0                	test   %eax,%eax
  5e:	0f 85 23 01 00 00    	jne    187 <main+0x187>
    printf(1,"child will share the box\n");
  64:	c7 44 24 04 d7 09 00 	movl   $0x9d7,0x4(%esp)
  6b:	00 
  6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  73:	e8 87 05 00 00       	call   5ff <printf>
    test = shmget(key,PGSIZE,GET);
  78:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  7f:	00 
  80:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  87:	00 
  88:	8b 44 24 18          	mov    0x18(%esp),%eax
  8c:	89 04 24             	mov    %eax,(%esp)
  8f:	e8 6c 04 00 00       	call   500 <shmget>
  94:	89 44 24 10          	mov    %eax,0x10(%esp)
  
    if(test < 0){
  98:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  9d:	79 16                	jns    b5 <main+0xb5>
      printf(1,"could not get(get)\n");
  9f:	c7 44 24 04 f1 09 00 	movl   $0x9f1,0x4(%esp)
  a6:	00 
  a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ae:	e8 4c 05 00 00       	call   5ff <printf>
  b3:	eb 5e                	jmp    113 <main+0x113>
    }
    else{
      addr = shmat(key, SHM_RDWR); 
  b5:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  bc:	00 
  bd:	8b 44 24 18          	mov    0x18(%esp),%eax
  c1:	89 04 24             	mov    %eax,(%esp)
  c4:	e8 47 04 00 00       	call   510 <shmat>
  c9:	89 44 24 1c          	mov    %eax,0x1c(%esp)
      printf(1,"*:%d\n",test);
  cd:	8b 44 24 10          	mov    0x10(%esp),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 05 0a 00 	movl   $0xa05,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 16 05 00 00       	call   5ff <printf>
      *addr = box;
  e9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  ed:	0f b6 54 24 17       	movzbl 0x17(%esp),%edx
  f2:	88 10                	mov    %dl,(%eax)
      printf(1,"*:%d\n",test-1);
  f4:	8b 44 24 10          	mov    0x10(%esp),%eax
  f8:	83 e8 01             	sub    $0x1,%eax
  fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  ff:	c7 44 24 04 05 0a 00 	movl   $0xa05,0x4(%esp)
 106:	00 
 107:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 10e:	e8 ec 04 00 00       	call   5ff <printf>
    }
    if(addr == (char*)-1){
 113:	83 7c 24 1c ff       	cmpl   $0xffffffff,0x1c(%esp)
 118:	75 16                	jne    130 <main+0x130>
      printf(1,"could not shmat(RDWR)\n");
 11a:	c7 44 24 04 0b 0a 00 	movl   $0xa0b,0x4(%esp)
 121:	00 
 122:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 129:	e8 d1 04 00 00       	call   5ff <printf>
 12e:	eb 52                	jmp    182 <main+0x182>
    }
    else{
      printf(1,"child will put a Gula in the box\n");
 130:	c7 44 24 04 24 0a 00 	movl   $0xa24,0x4(%esp)
 137:	00 
 138:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13f:	e8 bb 04 00 00       	call   5ff <printf>
      box++;
 144:	80 44 24 17 01       	addb   $0x1,0x17(%esp)
      printf(1,"child see %d Gulot in the box\n",box);
 149:	0f be 44 24 17       	movsbl 0x17(%esp),%eax
 14e:	89 44 24 08          	mov    %eax,0x8(%esp)
 152:	c7 44 24 04 48 0a 00 	movl   $0xa48,0x4(%esp)
 159:	00 
 15a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 161:	e8 99 04 00 00       	call   5ff <printf>
      printf(1,"addr: %d\n",addr);
 166:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 16a:	89 44 24 08          	mov    %eax,0x8(%esp)
 16e:	c7 44 24 04 67 0a 00 	movl   $0xa67,0x4(%esp)
 175:	00 
 176:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 17d:	e8 7d 04 00 00       	call   5ff <printf>
      }
     exit(); 
 182:	e8 c1 02 00 00       	call   448 <exit>
    }
  else{
   wait();
 187:	e8 c4 02 00 00       	call   450 <wait>
   addr = shmat(key, SHM_RDWR);
 18c:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
 193:	00 
 194:	8b 44 24 18          	mov    0x18(%esp),%eax
 198:	89 04 24             	mov    %eax,(%esp)
 19b:	e8 70 03 00 00       	call   510 <shmat>
 1a0:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   printf(1,"father see %d Gulot in the box\n",box);
 1a4:	0f be 44 24 17       	movsbl 0x17(%esp),%eax
 1a9:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ad:	c7 44 24 04 74 0a 00 	movl   $0xa74,0x4(%esp)
 1b4:	00 
 1b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bc:	e8 3e 04 00 00       	call   5ff <printf>
   printf(1,"addr: %d\n",addr);
 1c1:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1c5:	89 44 24 08          	mov    %eax,0x8(%esp)
 1c9:	c7 44 24 04 67 0a 00 	movl   $0xa67,0x4(%esp)
 1d0:	00 
 1d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d8:	e8 22 04 00 00       	call   5ff <printf>
  //the father agree
  
  //finish and die
  
  
  exit();
 1dd:	e8 66 02 00 00       	call   448 <exit>
 1e2:	90                   	nop
 1e3:	90                   	nop

000001e4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	57                   	push   %edi
 1e8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1ec:	8b 55 10             	mov    0x10(%ebp),%edx
 1ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f2:	89 cb                	mov    %ecx,%ebx
 1f4:	89 df                	mov    %ebx,%edi
 1f6:	89 d1                	mov    %edx,%ecx
 1f8:	fc                   	cld    
 1f9:	f3 aa                	rep stos %al,%es:(%edi)
 1fb:	89 ca                	mov    %ecx,%edx
 1fd:	89 fb                	mov    %edi,%ebx
 1ff:	89 5d 08             	mov    %ebx,0x8(%ebp)
 202:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 205:	5b                   	pop    %ebx
 206:	5f                   	pop    %edi
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    

00000209 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 215:	90                   	nop
 216:	8b 45 0c             	mov    0xc(%ebp),%eax
 219:	0f b6 10             	movzbl (%eax),%edx
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	88 10                	mov    %dl,(%eax)
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	84 c0                	test   %al,%al
 229:	0f 95 c0             	setne  %al
 22c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 230:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 234:	84 c0                	test   %al,%al
 236:	75 de                	jne    216 <strcpy+0xd>
    ;
  return os;
 238:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 240:	eb 08                	jmp    24a <strcmp+0xd>
    p++, q++;
 242:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 246:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	74 10                	je     264 <strcmp+0x27>
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	0f b6 10             	movzbl (%eax),%edx
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	38 c2                	cmp    %al,%dl
 262:	74 de                	je     242 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	0f b6 00             	movzbl (%eax),%eax
 26a:	0f b6 d0             	movzbl %al,%edx
 26d:	8b 45 0c             	mov    0xc(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	0f b6 c0             	movzbl %al,%eax
 276:	89 d1                	mov    %edx,%ecx
 278:	29 c1                	sub    %eax,%ecx
 27a:	89 c8                	mov    %ecx,%eax
}
 27c:	5d                   	pop    %ebp
 27d:	c3                   	ret    

0000027e <strlen>:

uint
strlen(char *s)
{
 27e:	55                   	push   %ebp
 27f:	89 e5                	mov    %esp,%ebp
 281:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 284:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 28b:	eb 04                	jmp    291 <strlen+0x13>
 28d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 291:	8b 45 fc             	mov    -0x4(%ebp),%eax
 294:	03 45 08             	add    0x8(%ebp),%eax
 297:	0f b6 00             	movzbl (%eax),%eax
 29a:	84 c0                	test   %al,%al
 29c:	75 ef                	jne    28d <strlen+0xf>
    ;
  return n;
 29e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2a9:	8b 45 10             	mov    0x10(%ebp),%eax
 2ac:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	89 04 24             	mov    %eax,(%esp)
 2bd:	e8 22 ff ff ff       	call   1e4 <stosb>
  return dst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <strchr>:

char*
strchr(const char *s, char c)
{
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 04             	sub    $0x4,%esp
 2cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2d3:	eb 14                	jmp    2e9 <strchr+0x22>
    if(*s == c)
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2de:	75 05                	jne    2e5 <strchr+0x1e>
      return (char*)s;
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	eb 13                	jmp    2f8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	84 c0                	test   %al,%al
 2f1:	75 e2                	jne    2d5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f8:	c9                   	leave  
 2f9:	c3                   	ret    

000002fa <gets>:

char*
gets(char *buf, int max)
{
 2fa:	55                   	push   %ebp
 2fb:	89 e5                	mov    %esp,%ebp
 2fd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 307:	eb 44                	jmp    34d <gets+0x53>
    cc = read(0, &c, 1);
 309:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 310:	00 
 311:	8d 45 ef             	lea    -0x11(%ebp),%eax
 314:	89 44 24 04          	mov    %eax,0x4(%esp)
 318:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 31f:	e8 3c 01 00 00       	call   460 <read>
 324:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 327:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 32b:	7e 2d                	jle    35a <gets+0x60>
      break;
    buf[i++] = c;
 32d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 330:	03 45 08             	add    0x8(%ebp),%eax
 333:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 337:	88 10                	mov    %dl,(%eax)
 339:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 33d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 341:	3c 0a                	cmp    $0xa,%al
 343:	74 16                	je     35b <gets+0x61>
 345:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 349:	3c 0d                	cmp    $0xd,%al
 34b:	74 0e                	je     35b <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 350:	83 c0 01             	add    $0x1,%eax
 353:	3b 45 0c             	cmp    0xc(%ebp),%eax
 356:	7c b1                	jl     309 <gets+0xf>
 358:	eb 01                	jmp    35b <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 35a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 35b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 35e:	03 45 08             	add    0x8(%ebp),%eax
 361:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <stat>:

int
stat(char *n, struct stat *st)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 376:	00 
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	89 04 24             	mov    %eax,(%esp)
 37d:	e8 06 01 00 00       	call   488 <open>
 382:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 389:	79 07                	jns    392 <stat+0x29>
    return -1;
 38b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 390:	eb 23                	jmp    3b5 <stat+0x4c>
  r = fstat(fd, st);
 392:	8b 45 0c             	mov    0xc(%ebp),%eax
 395:	89 44 24 04          	mov    %eax,0x4(%esp)
 399:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39c:	89 04 24             	mov    %eax,(%esp)
 39f:	e8 fc 00 00 00       	call   4a0 <fstat>
 3a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3aa:	89 04 24             	mov    %eax,(%esp)
 3ad:	e8 be 00 00 00       	call   470 <close>
  return r;
 3b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b5:	c9                   	leave  
 3b6:	c3                   	ret    

000003b7 <atoi>:

int
atoi(const char *s)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3c4:	eb 23                	jmp    3e9 <atoi+0x32>
    n = n*10 + *s++ - '0';
 3c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c9:	89 d0                	mov    %edx,%eax
 3cb:	c1 e0 02             	shl    $0x2,%eax
 3ce:	01 d0                	add    %edx,%eax
 3d0:	01 c0                	add    %eax,%eax
 3d2:	89 c2                	mov    %eax,%edx
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	0f b6 00             	movzbl (%eax),%eax
 3da:	0f be c0             	movsbl %al,%eax
 3dd:	01 d0                	add    %edx,%eax
 3df:	83 e8 30             	sub    $0x30,%eax
 3e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	0f b6 00             	movzbl (%eax),%eax
 3ef:	3c 2f                	cmp    $0x2f,%al
 3f1:	7e 0a                	jle    3fd <atoi+0x46>
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	0f b6 00             	movzbl (%eax),%eax
 3f9:	3c 39                	cmp    $0x39,%al
 3fb:	7e c9                	jle    3c6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 400:	c9                   	leave  
 401:	c3                   	ret    

00000402 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
 405:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 40e:	8b 45 0c             	mov    0xc(%ebp),%eax
 411:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 414:	eb 13                	jmp    429 <memmove+0x27>
    *dst++ = *src++;
 416:	8b 45 f8             	mov    -0x8(%ebp),%eax
 419:	0f b6 10             	movzbl (%eax),%edx
 41c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41f:	88 10                	mov    %dl,(%eax)
 421:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 425:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 429:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 42d:	0f 9f c0             	setg   %al
 430:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 434:	84 c0                	test   %al,%al
 436:	75 de                	jne    416 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 438:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43b:	c9                   	leave  
 43c:	c3                   	ret    
 43d:	90                   	nop
 43e:	90                   	nop
 43f:	90                   	nop

00000440 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 440:	b8 01 00 00 00       	mov    $0x1,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <exit>:
SYSCALL(exit)
 448:	b8 02 00 00 00       	mov    $0x2,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <wait>:
SYSCALL(wait)
 450:	b8 03 00 00 00       	mov    $0x3,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <pipe>:
SYSCALL(pipe)
 458:	b8 04 00 00 00       	mov    $0x4,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <read>:
SYSCALL(read)
 460:	b8 05 00 00 00       	mov    $0x5,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <write>:
SYSCALL(write)
 468:	b8 10 00 00 00       	mov    $0x10,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <close>:
SYSCALL(close)
 470:	b8 15 00 00 00       	mov    $0x15,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <kill>:
SYSCALL(kill)
 478:	b8 06 00 00 00       	mov    $0x6,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <exec>:
SYSCALL(exec)
 480:	b8 07 00 00 00       	mov    $0x7,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <open>:
SYSCALL(open)
 488:	b8 0f 00 00 00       	mov    $0xf,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <mknod>:
SYSCALL(mknod)
 490:	b8 11 00 00 00       	mov    $0x11,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <unlink>:
SYSCALL(unlink)
 498:	b8 12 00 00 00       	mov    $0x12,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <fstat>:
SYSCALL(fstat)
 4a0:	b8 08 00 00 00       	mov    $0x8,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <link>:
SYSCALL(link)
 4a8:	b8 13 00 00 00       	mov    $0x13,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <mkdir>:
SYSCALL(mkdir)
 4b0:	b8 14 00 00 00       	mov    $0x14,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <chdir>:
SYSCALL(chdir)
 4b8:	b8 09 00 00 00       	mov    $0x9,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <dup>:
SYSCALL(dup)
 4c0:	b8 0a 00 00 00       	mov    $0xa,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <getpid>:
SYSCALL(getpid)
 4c8:	b8 0b 00 00 00       	mov    $0xb,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <sbrk>:
SYSCALL(sbrk)
 4d0:	b8 0c 00 00 00       	mov    $0xc,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <sleep>:
SYSCALL(sleep)
 4d8:	b8 0d 00 00 00       	mov    $0xd,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <uptime>:
SYSCALL(uptime)
 4e0:	b8 0e 00 00 00       	mov    $0xe,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <enableSwapping>:
SYSCALL(enableSwapping)
 4e8:	b8 16 00 00 00       	mov    $0x16,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <disableSwapping>:
SYSCALL(disableSwapping)
 4f0:	b8 17 00 00 00       	mov    $0x17,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <num_of_pages>:
SYSCALL(num_of_pages)
 4f8:	b8 18 00 00 00       	mov    $0x18,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <shmget>:
SYSCALL(shmget)
 500:	b8 19 00 00 00       	mov    $0x19,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <shmdel>:
SYSCALL(shmdel)
 508:	b8 1a 00 00 00       	mov    $0x1a,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <shmat>:
SYSCALL(shmat)
 510:	b8 1b 00 00 00       	mov    $0x1b,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <shmdt>:
SYSCALL(shmdt)
 518:	b8 1c 00 00 00       	mov    $0x1c,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <get_share_memory_address>:
 520:	b8 1d 00 00 00       	mov    $0x1d,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	83 ec 28             	sub    $0x28,%esp
 52e:	8b 45 0c             	mov    0xc(%ebp),%eax
 531:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 534:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 53b:	00 
 53c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 53f:	89 44 24 04          	mov    %eax,0x4(%esp)
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	89 04 24             	mov    %eax,(%esp)
 549:	e8 1a ff ff ff       	call   468 <write>
}
 54e:	c9                   	leave  
 54f:	c3                   	ret    

00000550 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 556:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 55d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 561:	74 17                	je     57a <printint+0x2a>
 563:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 567:	79 11                	jns    57a <printint+0x2a>
    neg = 1;
 569:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 570:	8b 45 0c             	mov    0xc(%ebp),%eax
 573:	f7 d8                	neg    %eax
 575:	89 45 ec             	mov    %eax,-0x14(%ebp)
 578:	eb 06                	jmp    580 <printint+0x30>
  } else {
    x = xx;
 57a:	8b 45 0c             	mov    0xc(%ebp),%eax
 57d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 587:	8b 4d 10             	mov    0x10(%ebp),%ecx
 58a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58d:	ba 00 00 00 00       	mov    $0x0,%edx
 592:	f7 f1                	div    %ecx
 594:	89 d0                	mov    %edx,%eax
 596:	0f b6 90 d8 0c 00 00 	movzbl 0xcd8(%eax),%edx
 59d:	8d 45 dc             	lea    -0x24(%ebp),%eax
 5a0:	03 45 f4             	add    -0xc(%ebp),%eax
 5a3:	88 10                	mov    %dl,(%eax)
 5a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 5a9:	8b 55 10             	mov    0x10(%ebp),%edx
 5ac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b2:	ba 00 00 00 00       	mov    $0x0,%edx
 5b7:	f7 75 d4             	divl   -0x2c(%ebp)
 5ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c1:	75 c4                	jne    587 <printint+0x37>
  if(neg)
 5c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5c7:	74 2a                	je     5f3 <printint+0xa3>
    buf[i++] = '-';
 5c9:	8d 45 dc             	lea    -0x24(%ebp),%eax
 5cc:	03 45 f4             	add    -0xc(%ebp),%eax
 5cf:	c6 00 2d             	movb   $0x2d,(%eax)
 5d2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 5d6:	eb 1b                	jmp    5f3 <printint+0xa3>
    putc(fd, buf[i]);
 5d8:	8d 45 dc             	lea    -0x24(%ebp),%eax
 5db:	03 45 f4             	add    -0xc(%ebp),%eax
 5de:	0f b6 00             	movzbl (%eax),%eax
 5e1:	0f be c0             	movsbl %al,%eax
 5e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e8:	8b 45 08             	mov    0x8(%ebp),%eax
 5eb:	89 04 24             	mov    %eax,(%esp)
 5ee:	e8 35 ff ff ff       	call   528 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5f3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fb:	79 db                	jns    5d8 <printint+0x88>
    putc(fd, buf[i]);
}
 5fd:	c9                   	leave  
 5fe:	c3                   	ret    

000005ff <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5ff:	55                   	push   %ebp
 600:	89 e5                	mov    %esp,%ebp
 602:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 605:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 60c:	8d 45 0c             	lea    0xc(%ebp),%eax
 60f:	83 c0 04             	add    $0x4,%eax
 612:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 615:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 61c:	e9 7d 01 00 00       	jmp    79e <printf+0x19f>
    c = fmt[i] & 0xff;
 621:	8b 55 0c             	mov    0xc(%ebp),%edx
 624:	8b 45 f0             	mov    -0x10(%ebp),%eax
 627:	01 d0                	add    %edx,%eax
 629:	0f b6 00             	movzbl (%eax),%eax
 62c:	0f be c0             	movsbl %al,%eax
 62f:	25 ff 00 00 00       	and    $0xff,%eax
 634:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 637:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 63b:	75 2c                	jne    669 <printf+0x6a>
      if(c == '%'){
 63d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 641:	75 0c                	jne    64f <printf+0x50>
        state = '%';
 643:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 64a:	e9 4b 01 00 00       	jmp    79a <printf+0x19b>
      } else {
        putc(fd, c);
 64f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 652:	0f be c0             	movsbl %al,%eax
 655:	89 44 24 04          	mov    %eax,0x4(%esp)
 659:	8b 45 08             	mov    0x8(%ebp),%eax
 65c:	89 04 24             	mov    %eax,(%esp)
 65f:	e8 c4 fe ff ff       	call   528 <putc>
 664:	e9 31 01 00 00       	jmp    79a <printf+0x19b>
      }
    } else if(state == '%'){
 669:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 66d:	0f 85 27 01 00 00    	jne    79a <printf+0x19b>
      if(c == 'd'){
 673:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 677:	75 2d                	jne    6a6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 679:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 685:	00 
 686:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 68d:	00 
 68e:	89 44 24 04          	mov    %eax,0x4(%esp)
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	89 04 24             	mov    %eax,(%esp)
 698:	e8 b3 fe ff ff       	call   550 <printint>
        ap++;
 69d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a1:	e9 ed 00 00 00       	jmp    793 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 6a6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6aa:	74 06                	je     6b2 <printf+0xb3>
 6ac:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b0:	75 2d                	jne    6df <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6be:	00 
 6bf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6c6:	00 
 6c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6cb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ce:	89 04 24             	mov    %eax,(%esp)
 6d1:	e8 7a fe ff ff       	call   550 <printint>
        ap++;
 6d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6da:	e9 b4 00 00 00       	jmp    793 <printf+0x194>
      } else if(c == 's'){
 6df:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6e3:	75 46                	jne    72b <printf+0x12c>
        s = (char*)*ap;
 6e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f5:	75 27                	jne    71e <printf+0x11f>
          s = "(null)";
 6f7:	c7 45 f4 94 0a 00 00 	movl   $0xa94,-0xc(%ebp)
        while(*s != 0){
 6fe:	eb 1e                	jmp    71e <printf+0x11f>
          putc(fd, *s);
 700:	8b 45 f4             	mov    -0xc(%ebp),%eax
 703:	0f b6 00             	movzbl (%eax),%eax
 706:	0f be c0             	movsbl %al,%eax
 709:	89 44 24 04          	mov    %eax,0x4(%esp)
 70d:	8b 45 08             	mov    0x8(%ebp),%eax
 710:	89 04 24             	mov    %eax,(%esp)
 713:	e8 10 fe ff ff       	call   528 <putc>
          s++;
 718:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 71c:	eb 01                	jmp    71f <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 71e:	90                   	nop
 71f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 722:	0f b6 00             	movzbl (%eax),%eax
 725:	84 c0                	test   %al,%al
 727:	75 d7                	jne    700 <printf+0x101>
 729:	eb 68                	jmp    793 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 72b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 72f:	75 1d                	jne    74e <printf+0x14f>
        putc(fd, *ap);
 731:	8b 45 e8             	mov    -0x18(%ebp),%eax
 734:	8b 00                	mov    (%eax),%eax
 736:	0f be c0             	movsbl %al,%eax
 739:	89 44 24 04          	mov    %eax,0x4(%esp)
 73d:	8b 45 08             	mov    0x8(%ebp),%eax
 740:	89 04 24             	mov    %eax,(%esp)
 743:	e8 e0 fd ff ff       	call   528 <putc>
        ap++;
 748:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 74c:	eb 45                	jmp    793 <printf+0x194>
      } else if(c == '%'){
 74e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 752:	75 17                	jne    76b <printf+0x16c>
        putc(fd, c);
 754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 757:	0f be c0             	movsbl %al,%eax
 75a:	89 44 24 04          	mov    %eax,0x4(%esp)
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	89 04 24             	mov    %eax,(%esp)
 764:	e8 bf fd ff ff       	call   528 <putc>
 769:	eb 28                	jmp    793 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 76b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 772:	00 
 773:	8b 45 08             	mov    0x8(%ebp),%eax
 776:	89 04 24             	mov    %eax,(%esp)
 779:	e8 aa fd ff ff       	call   528 <putc>
        putc(fd, c);
 77e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 781:	0f be c0             	movsbl %al,%eax
 784:	89 44 24 04          	mov    %eax,0x4(%esp)
 788:	8b 45 08             	mov    0x8(%ebp),%eax
 78b:	89 04 24             	mov    %eax,(%esp)
 78e:	e8 95 fd ff ff       	call   528 <putc>
      }
      state = 0;
 793:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 79a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 79e:	8b 55 0c             	mov    0xc(%ebp),%edx
 7a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a4:	01 d0                	add    %edx,%eax
 7a6:	0f b6 00             	movzbl (%eax),%eax
 7a9:	84 c0                	test   %al,%al
 7ab:	0f 85 70 fe ff ff    	jne    621 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7b1:	c9                   	leave  
 7b2:	c3                   	ret    
 7b3:	90                   	nop

000007b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b4:	55                   	push   %ebp
 7b5:	89 e5                	mov    %esp,%ebp
 7b7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ba:	8b 45 08             	mov    0x8(%ebp),%eax
 7bd:	83 e8 08             	sub    $0x8,%eax
 7c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c3:	a1 f4 0c 00 00       	mov    0xcf4,%eax
 7c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7cb:	eb 24                	jmp    7f1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	8b 00                	mov    (%eax),%eax
 7d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d5:	77 12                	ja     7e9 <free+0x35>
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7dd:	77 24                	ja     803 <free+0x4f>
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	8b 00                	mov    (%eax),%eax
 7e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e7:	77 1a                	ja     803 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f7:	76 d4                	jbe    7cd <free+0x19>
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 801:	76 ca                	jbe    7cd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 803:	8b 45 f8             	mov    -0x8(%ebp),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	c1 e0 03             	shl    $0x3,%eax
 80c:	89 c2                	mov    %eax,%edx
 80e:	03 55 f8             	add    -0x8(%ebp),%edx
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	39 c2                	cmp    %eax,%edx
 818:	75 24                	jne    83e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 81a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81d:	8b 50 04             	mov    0x4(%eax),%edx
 820:	8b 45 fc             	mov    -0x4(%ebp),%eax
 823:	8b 00                	mov    (%eax),%eax
 825:	8b 40 04             	mov    0x4(%eax),%eax
 828:	01 c2                	add    %eax,%edx
 82a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	8b 00                	mov    (%eax),%eax
 835:	8b 10                	mov    (%eax),%edx
 837:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83a:	89 10                	mov    %edx,(%eax)
 83c:	eb 0a                	jmp    848 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	8b 10                	mov    (%eax),%edx
 843:	8b 45 f8             	mov    -0x8(%ebp),%eax
 846:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 848:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84b:	8b 40 04             	mov    0x4(%eax),%eax
 84e:	c1 e0 03             	shl    $0x3,%eax
 851:	03 45 fc             	add    -0x4(%ebp),%eax
 854:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 857:	75 20                	jne    879 <free+0xc5>
    p->s.size += bp->s.size;
 859:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85c:	8b 50 04             	mov    0x4(%eax),%edx
 85f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 862:	8b 40 04             	mov    0x4(%eax),%eax
 865:	01 c2                	add    %eax,%edx
 867:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 86d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 870:	8b 10                	mov    (%eax),%edx
 872:	8b 45 fc             	mov    -0x4(%ebp),%eax
 875:	89 10                	mov    %edx,(%eax)
 877:	eb 08                	jmp    881 <free+0xcd>
  } else
    p->s.ptr = bp;
 879:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 87f:	89 10                	mov    %edx,(%eax)
  freep = p;
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	a3 f4 0c 00 00       	mov    %eax,0xcf4
}
 889:	c9                   	leave  
 88a:	c3                   	ret    

0000088b <morecore>:

static Header*
morecore(uint nu)
{
 88b:	55                   	push   %ebp
 88c:	89 e5                	mov    %esp,%ebp
 88e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 891:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 898:	77 07                	ja     8a1 <morecore+0x16>
    nu = 4096;
 89a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8a1:	8b 45 08             	mov    0x8(%ebp),%eax
 8a4:	c1 e0 03             	shl    $0x3,%eax
 8a7:	89 04 24             	mov    %eax,(%esp)
 8aa:	e8 21 fc ff ff       	call   4d0 <sbrk>
 8af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b6:	75 07                	jne    8bf <morecore+0x34>
    return 0;
 8b8:	b8 00 00 00 00       	mov    $0x0,%eax
 8bd:	eb 22                	jmp    8e1 <morecore+0x56>
  hp = (Header*)p;
 8bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c8:	8b 55 08             	mov    0x8(%ebp),%edx
 8cb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d1:	83 c0 08             	add    $0x8,%eax
 8d4:	89 04 24             	mov    %eax,(%esp)
 8d7:	e8 d8 fe ff ff       	call   7b4 <free>
  return freep;
 8dc:	a1 f4 0c 00 00       	mov    0xcf4,%eax
}
 8e1:	c9                   	leave  
 8e2:	c3                   	ret    

000008e3 <malloc>:

void*
malloc(uint nbytes)
{
 8e3:	55                   	push   %ebp
 8e4:	89 e5                	mov    %esp,%ebp
 8e6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e9:	8b 45 08             	mov    0x8(%ebp),%eax
 8ec:	83 c0 07             	add    $0x7,%eax
 8ef:	c1 e8 03             	shr    $0x3,%eax
 8f2:	83 c0 01             	add    $0x1,%eax
 8f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8f8:	a1 f4 0c 00 00       	mov    0xcf4,%eax
 8fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 900:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 904:	75 23                	jne    929 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 906:	c7 45 f0 ec 0c 00 00 	movl   $0xcec,-0x10(%ebp)
 90d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 910:	a3 f4 0c 00 00       	mov    %eax,0xcf4
 915:	a1 f4 0c 00 00       	mov    0xcf4,%eax
 91a:	a3 ec 0c 00 00       	mov    %eax,0xcec
    base.s.size = 0;
 91f:	c7 05 f0 0c 00 00 00 	movl   $0x0,0xcf0
 926:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	8b 40 04             	mov    0x4(%eax),%eax
 937:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93a:	72 4d                	jb     989 <malloc+0xa6>
      if(p->s.size == nunits)
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	8b 40 04             	mov    0x4(%eax),%eax
 942:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 945:	75 0c                	jne    953 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 947:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94a:	8b 10                	mov    (%eax),%edx
 94c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94f:	89 10                	mov    %edx,(%eax)
 951:	eb 26                	jmp    979 <malloc+0x96>
      else {
        p->s.size -= nunits;
 953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 956:	8b 40 04             	mov    0x4(%eax),%eax
 959:	89 c2                	mov    %eax,%edx
 95b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	8b 40 04             	mov    0x4(%eax),%eax
 96a:	c1 e0 03             	shl    $0x3,%eax
 96d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 970:	8b 45 f4             	mov    -0xc(%ebp),%eax
 973:	8b 55 ec             	mov    -0x14(%ebp),%edx
 976:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 979:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97c:	a3 f4 0c 00 00       	mov    %eax,0xcf4
      return (void*)(p + 1);
 981:	8b 45 f4             	mov    -0xc(%ebp),%eax
 984:	83 c0 08             	add    $0x8,%eax
 987:	eb 38                	jmp    9c1 <malloc+0xde>
    }
    if(p == freep)
 989:	a1 f4 0c 00 00       	mov    0xcf4,%eax
 98e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 991:	75 1b                	jne    9ae <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 993:	8b 45 ec             	mov    -0x14(%ebp),%eax
 996:	89 04 24             	mov    %eax,(%esp)
 999:	e8 ed fe ff ff       	call   88b <morecore>
 99e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a5:	75 07                	jne    9ae <malloc+0xcb>
        return 0;
 9a7:	b8 00 00 00 00       	mov    $0x0,%eax
 9ac:	eb 13                	jmp    9c1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b7:	8b 00                	mov    (%eax),%eax
 9b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9bc:	e9 70 ff ff ff       	jmp    931 <malloc+0x4e>
}
 9c1:	c9                   	leave  
 9c2:	c3                   	ret    
