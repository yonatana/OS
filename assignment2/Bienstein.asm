
_Bienstein:     file format elf32-i386


Disassembly of section .text:

00000000 <enter_bar>:

int M,A,C,S,B,fd;


void enter_bar() //bouncer
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  semaphore_down(bouncer);
       6:	a1 bc 1e 00 00       	mov    0x1ebc,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 32 13 00 00       	call   1345 <semaphore_down>
}
      13:	c9                   	leave  
      14:	c3                   	ret    

00000015 <leave_bar>:

void leave_bar() //bouncer
{
      15:	55                   	push   %ebp
      16:	89 e5                	mov    %esp,%ebp
      18:	83 ec 18             	sub    $0x18,%esp
  semaphore_up(bouncer);
      1b:	a1 bc 1e 00 00       	mov    0x1ebc,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 74 13 00 00       	call   139c <semaphore_up>
}
      28:	c9                   	leave  
      29:	c3                   	ret    

0000002a <place_action>:

void place_action(struct Action* action) //ABB
{
      2a:	55                   	push   %ebp
      2b:	89 e5                	mov    %esp,%ebp
      2d:	83 ec 18             	sub    $0x18,%esp
  BB_put(ABB, action);
      30:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 dd 14 00 00       	call   1521 <BB_put>
}
      44:	c9                   	leave  
      45:	c3                   	ret    

00000046 <get_action>:

struct Action* get_action() //ABB
{
      46:	55                   	push   %ebp
      47:	89 e5                	mov    %esp,%ebp
      49:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(ABB);
      4c:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 45 15 00 00       	call   159e <BB_pop>
}
      59:	c9                   	leave  
      5a:	c3                   	ret    

0000005b <serve_drink>:

void serve_drink(struct Cup* cup) //DrinkBB
{
      5b:	55                   	push   %ebp
      5c:	89 e5                	mov    %esp,%ebp
      5e:	83 ec 18             	sub    $0x18,%esp
  BB_put(DrinkBB,cup);
      61:	a1 dc 1e 00 00       	mov    0x1edc,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 ac 14 00 00       	call   1521 <BB_put>
}
      75:	c9                   	leave  
      76:	c3                   	ret    

00000077 <get_drink>:

struct Cup* get_drink() //DrinkBB
{
      77:	55                   	push   %ebp
      78:	89 e5                	mov    %esp,%ebp
      7a:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(DrinkBB);
      7d:	a1 dc 1e 00 00       	mov    0x1edc,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 14 15 00 00       	call   159e <BB_pop>
}
      8a:	c9                   	leave  
      8b:	c3                   	ret    

0000008c <get_clean_cup>:

struct Cup* get_clean_cup() //CBB
{
      8c:	55                   	push   %ebp
      8d:	89 e5                	mov    %esp,%ebp
      8f:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(CBB);
      92:	a1 fc 1e 00 00       	mov    0x1efc,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 ff 14 00 00       	call   159e <BB_pop>
}
      9f:	c9                   	leave  
      a0:	c3                   	ret    

000000a1 <add_clean_cup>:

void add_clean_cup(struct Cup* cup) //CBB
{
      a1:	55                   	push   %ebp
      a2:	89 e5                	mov    %esp,%ebp
      a4:	83 ec 18             	sub    $0x18,%esp
  BB_put(CBB,cup);
      a7:	a1 fc 1e 00 00       	mov    0x1efc,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 66 14 00 00       	call   1521 <BB_put>
}
      bb:	c9                   	leave  
      bc:	c3                   	ret    

000000bd <return_cup>:

void return_cup(struct Cup* cup) //DBB
{
      bd:	55                   	push   %ebp
      be:	89 e5                	mov    %esp,%ebp
      c0:	83 ec 18             	sub    $0x18,%esp
  BB_put(DBB,cup);
      c3:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 4a 14 00 00       	call   1521 <BB_put>
}
      d7:	c9                   	leave  
      d8:	c3                   	ret    

000000d9 <wash_dirty>:

struct Cup* wash_dirty() //DBB
{
      d9:	55                   	push   %ebp
      da:	89 e5                	mov    %esp,%ebp
      dc:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(DBB);
      df:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 b2 14 00 00       	call   159e <BB_pop>
}
      ec:	c9                   	leave  
      ed:	c3                   	ret    

000000ee <getconf>:

int getconf(void)
{
      ee:	55                   	push   %ebp
      ef:	89 e5                	mov    %esp,%ebp
      f1:	81 ec 28 02 00 00    	sub    $0x228,%esp
  int fdin,rd;
  char buf[512];
  memset(&buf,0,512);
      f7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
      fe:	00 
      ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     106:	00 
     107:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     10d:	89 04 24             	mov    %eax,(%esp)
     110:	e8 6e 0a 00 00       	call   b83 <memset>
  
  if((fdin = open("con.conf",O_RDONLY)) < 0)
     115:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     11c:	00 
     11d:	c7 04 24 58 16 00 00 	movl   $0x1658,(%esp)
     124:	e8 3f 0c 00 00       	call   d68 <open>
     129:	89 45 f0             	mov    %eax,-0x10(%ebp)
     12c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     130:	79 1e                	jns    150 <getconf+0x62>
  {
    printf(2,"Couldn't open the conf file\n");
     132:	c7 44 24 04 61 16 00 	movl   $0x1661,0x4(%esp)
     139:	00 
     13a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     141:	e8 99 0d 00 00       	call   edf <printf>
    return -1;
     146:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     14b:	e9 60 01 00 00       	jmp    2b0 <getconf+0x1c2>
  }
  
  if((rd = read(fdin, &buf, 512)) <= 0)
     150:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     157:	00 
     158:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     15e:	89 44 24 04          	mov    %eax,0x4(%esp)
     162:	8b 45 f0             	mov    -0x10(%ebp),%eax
     165:	89 04 24             	mov    %eax,(%esp)
     168:	e8 d3 0b 00 00       	call   d40 <read>
     16d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     170:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     174:	7f 1e                	jg     194 <getconf+0xa6>
  {
    printf(2,"Couldn't read from conf file\n");
     176:	c7 44 24 04 7e 16 00 	movl   $0x167e,0x4(%esp)
     17d:	00 
     17e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     185:	e8 55 0d 00 00       	call   edf <printf>
    return -1;
     18a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     18f:	e9 1c 01 00 00       	jmp    2b0 <getconf+0x1c2>
  }
  
  int i = 0;
     194:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(;i<rd;i++)
     19b:	eb 20                	jmp    1bd <getconf+0xcf>
    if(buf[i] == '\n')
     19d:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     1a3:	03 45 f4             	add    -0xc(%ebp),%eax
     1a6:	0f b6 00             	movzbl (%eax),%eax
     1a9:	3c 0a                	cmp    $0xa,%al
     1ab:	75 0c                	jne    1b9 <getconf+0xcb>
      buf[i] = 0;
     1ad:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     1b3:	03 45 f4             	add    -0xc(%ebp),%eax
     1b6:	c6 00 00             	movb   $0x0,(%eax)
    printf(2,"Couldn't read from conf file\n");
    return -1;
  }
  
  int i = 0;
  for(;i<rd;i++)
     1b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     1c3:	7c d8                	jl     19d <getconf+0xaf>
    if(buf[i] == '\n')
      buf[i] = 0;

  for(i=0;i<rd;i++)
     1c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     1cc:	e9 ce 00 00 00       	jmp    29f <getconf+0x1b1>
  {
    if(buf[i] == '=')
     1d1:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     1d7:	03 45 f4             	add    -0xc(%ebp),%eax
     1da:	0f b6 00             	movzbl (%eax),%eax
     1dd:	3c 3d                	cmp    $0x3d,%al
     1df:	0f 85 b6 00 00 00    	jne    29b <getconf+0x1ad>
    {
      switch(buf[i-1])
     1e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1e8:	83 e8 01             	sub    $0x1,%eax
     1eb:	0f b6 84 05 ec fd ff 	movzbl -0x214(%ebp,%eax,1),%eax
     1f2:	ff 
     1f3:	0f be c0             	movsbl %al,%eax
     1f6:	83 e8 41             	sub    $0x41,%eax
     1f9:	83 f8 12             	cmp    $0x12,%eax
     1fc:	0f 87 99 00 00 00    	ja     29b <getconf+0x1ad>
     202:	8b 04 85 9c 16 00 00 	mov    0x169c(,%eax,4),%eax
     209:	ff e0                	jmp    *%eax
      {
	case 'M':
	  M = atoi(&buf[i+1]);
     20b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     20e:	8d 50 01             	lea    0x1(%eax),%edx
     211:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     217:	01 d0                	add    %edx,%eax
     219:	89 04 24             	mov    %eax,(%esp)
     21c:	e8 76 0a 00 00       	call   c97 <atoi>
     221:	a3 e0 1e 00 00       	mov    %eax,0x1ee0
	  break;
     226:	eb 73                	jmp    29b <getconf+0x1ad>
	case 'A':
	   A = atoi(&buf[i+1]);
     228:	8b 45 f4             	mov    -0xc(%ebp),%eax
     22b:	8d 50 01             	lea    0x1(%eax),%edx
     22e:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     234:	01 d0                	add    %edx,%eax
     236:	89 04 24             	mov    %eax,(%esp)
     239:	e8 59 0a 00 00       	call   c97 <atoi>
     23e:	a3 b8 1e 00 00       	mov    %eax,0x1eb8
	  break;
     243:	eb 56                	jmp    29b <getconf+0x1ad>
	case 'C':
	   C = atoi(&buf[i+1]);
     245:	8b 45 f4             	mov    -0xc(%ebp),%eax
     248:	8d 50 01             	lea    0x1(%eax),%edx
     24b:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     251:	01 d0                	add    %edx,%eax
     253:	89 04 24             	mov    %eax,(%esp)
     256:	e8 3c 0a 00 00       	call   c97 <atoi>
     25b:	a3 d4 1e 00 00       	mov    %eax,0x1ed4
	  break;
     260:	eb 39                	jmp    29b <getconf+0x1ad>
	case 'S':
	   S = atoi(&buf[i+1]);
     262:	8b 45 f4             	mov    -0xc(%ebp),%eax
     265:	8d 50 01             	lea    0x1(%eax),%edx
     268:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     26e:	01 d0                	add    %edx,%eax
     270:	89 04 24             	mov    %eax,(%esp)
     273:	e8 1f 0a 00 00       	call   c97 <atoi>
     278:	a3 c8 1e 00 00       	mov    %eax,0x1ec8
	  break;
     27d:	eb 1c                	jmp    29b <getconf+0x1ad>
	case 'B':
	   B = atoi(&buf[i+1]);
     27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     282:	8d 50 01             	lea    0x1(%eax),%edx
     285:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     28b:	01 d0                	add    %edx,%eax
     28d:	89 04 24             	mov    %eax,(%esp)
     290:	e8 02 0a 00 00       	call   c97 <atoi>
     295:	a3 cc 1e 00 00       	mov    %eax,0x1ecc
	  break;
     29a:	90                   	nop
  int i = 0;
  for(;i<rd;i++)
    if(buf[i] == '\n')
      buf[i] = 0;

  for(i=0;i<rd;i++)
     29b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     29f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     2a5:	0f 8c 26 ff ff ff    	jl     1d1 <getconf+0xe3>
	   B = atoi(&buf[i+1]);
	  break;
      }
    }
  }
  return 0;
     2ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2b0:	c9                   	leave  
     2b1:	c3                   	ret    

000002b2 <student_func>:

void* student_func(void)
{
     2b2:	55                   	push   %ebp
     2b3:	89 e5                	mov    %esp,%ebp
     2b5:	83 ec 48             	sub    $0x48,%esp
  int tid = thread_getId();
     2b8:	e8 13 0b 00 00       	call   dd0 <thread_getId>
     2bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i = 0;
     2c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
  enter_bar();
     2c7:	e8 34 fd ff ff       	call   0 <enter_bar>
  for(;i < tid%5;i++)
     2cc:	e9 b2 00 00 00       	jmp    383 <student_func+0xd1>
  {
    struct Action* get = malloc(sizeof(struct Action)); //create the get_drink action
     2d1:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     2d8:	e8 e6 0e 00 00       	call   11c3 <malloc>
     2dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    get->type = GET_DRINK;
     2e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    get->cup = 0;
     2e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    get->tid = tid;
     2f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
     2f9:	89 50 08             	mov    %edx,0x8(%eax)
    place_action(get);
     2fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2ff:	89 04 24             	mov    %eax,(%esp)
     302:	e8 23 fd ff ff       	call   2a <place_action>
    struct Cup * cup = get_drink();			//get cup from DrinkBB buffer
     307:	e8 6b fd ff ff       	call   77 <get_drink>
     30c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(fd,"Student %d is having his %d drink, with cup %d\n",tid,i+1,cup->id);
     30f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     312:	8b 10                	mov    (%eax),%edx
     314:	8b 45 f4             	mov    -0xc(%ebp),%eax
     317:	8d 48 01             	lea    0x1(%eax),%ecx
     31a:	a1 c0 1e 00 00       	mov    0x1ec0,%eax
     31f:	89 54 24 10          	mov    %edx,0x10(%esp)
     323:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     327:	8b 55 f0             	mov    -0x10(%ebp),%edx
     32a:	89 54 24 08          	mov    %edx,0x8(%esp)
     32e:	c7 44 24 04 e8 16 00 	movl   $0x16e8,0x4(%esp)
     335:	00 
     336:	89 04 24             	mov    %eax,(%esp)
     339:	e8 a1 0b 00 00       	call   edf <printf>
    sleep(1);
     33e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     345:	e8 6e 0a 00 00       	call   db8 <sleep>
    struct Action* put = malloc(sizeof(struct Action));
     34a:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     351:	e8 6d 0e 00 00       	call   11c3 <malloc>
     356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    put->type = PUT_DRINK;
     359:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     35c:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    put->cup = cup;
     362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     365:	8b 55 e8             	mov    -0x18(%ebp),%edx
     368:	89 50 04             	mov    %edx,0x4(%eax)
    put->tid = tid;
     36b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     36e:	8b 55 f0             	mov    -0x10(%ebp),%edx
     371:	89 50 08             	mov    %edx,0x8(%eax)
    place_action(put);
     374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     377:	89 04 24             	mov    %eax,(%esp)
     37a:	e8 ab fc ff ff       	call   2a <place_action>
{
  int tid = thread_getId();
  int i = 0;
  
  enter_bar();
  for(;i < tid%5;i++)
     37f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     383:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     386:	ba 67 66 66 66       	mov    $0x66666667,%edx
     38b:	89 c8                	mov    %ecx,%eax
     38d:	f7 ea                	imul   %edx
     38f:	d1 fa                	sar    %edx
     391:	89 c8                	mov    %ecx,%eax
     393:	c1 f8 1f             	sar    $0x1f,%eax
     396:	29 c2                	sub    %eax,%edx
     398:	89 d0                	mov    %edx,%eax
     39a:	c1 e0 02             	shl    $0x2,%eax
     39d:	01 d0                	add    %edx,%eax
     39f:	89 ca                	mov    %ecx,%edx
     3a1:	29 c2                	sub    %eax,%edx
     3a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
     3a6:	0f 8f 25 ff ff ff    	jg     2d1 <student_func+0x1f>
    put->type = PUT_DRINK;
    put->cup = cup;
    put->tid = tid;
    place_action(put);
  }
  printf(fd,"Student %d is drunk, and trying to go home\n",tid);
     3ac:	a1 c0 1e 00 00       	mov    0x1ec0,%eax
     3b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
     3b4:	89 54 24 08          	mov    %edx,0x8(%esp)
     3b8:	c7 44 24 04 18 17 00 	movl   $0x1718,0x4(%esp)
     3bf:	00 
     3c0:	89 04 24             	mov    %eax,(%esp)
     3c3:	e8 17 0b 00 00       	call   edf <printf>
  leave_bar();
     3c8:	e8 48 fc ff ff       	call   15 <leave_bar>
  thread_exit(0);
     3cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3d4:	e8 0f 0a 00 00       	call   de8 <thread_exit>
  return 0;
     3d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
     3de:	c9                   	leave  
     3df:	c3                   	ret    

000003e0 <bartender_func>:

void* bartender_func(void)
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	83 ec 48             	sub    $0x48,%esp
  double n,bufSize;
  int tid = thread_getId();
     3e6:	e8 e5 09 00 00       	call   dd0 <thread_getId>
     3eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;;)
  {
    struct Action * act = get_action();
     3ee:	e8 53 fc ff ff       	call   46 <get_action>
     3f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(act->type == GET_DRINK)
     3f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3f9:	8b 00                	mov    (%eax),%eax
     3fb:	83 f8 01             	cmp    $0x1,%eax
     3fe:	75 3d                	jne    43d <bartender_func+0x5d>
    {
      struct Cup * cup = get_clean_cup();
     400:	e8 87 fc ff ff       	call   8c <get_clean_cup>
     405:	89 45 ec             	mov    %eax,-0x14(%ebp)
      printf(fd,"Bartender %d is making drink with cup #%d\n",tid,cup->id);
     408:	8b 45 ec             	mov    -0x14(%ebp),%eax
     40b:	8b 10                	mov    (%eax),%edx
     40d:	a1 c0 1e 00 00       	mov    0x1ec0,%eax
     412:	89 54 24 0c          	mov    %edx,0xc(%esp)
     416:	8b 55 f4             	mov    -0xc(%ebp),%edx
     419:	89 54 24 08          	mov    %edx,0x8(%esp)
     41d:	c7 44 24 04 44 17 00 	movl   $0x1744,0x4(%esp)
     424:	00 
     425:	89 04 24             	mov    %eax,(%esp)
     428:	e8 b2 0a 00 00       	call   edf <printf>
      serve_drink(cup);
     42d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     430:	89 04 24             	mov    %eax,(%esp)
     433:	e8 23 fc ff ff       	call   5b <serve_drink>
     438:	e9 b2 00 00 00       	jmp    4ef <bartender_func+0x10f>
    }
    else if(act->type == PUT_DRINK)
     43d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     440:	8b 00                	mov    (%eax),%eax
     442:	83 f8 02             	cmp    $0x2,%eax
     445:	0f 85 a4 00 00 00    	jne    4ef <bartender_func+0x10f>
    {
      struct Cup * cup = act->cup;
     44b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     44e:	8b 40 04             	mov    0x4(%eax),%eax
     451:	89 45 e8             	mov    %eax,-0x18(%ebp)
      return_cup(cup);
     454:	8b 45 e8             	mov    -0x18(%ebp),%eax
     457:	89 04 24             	mov    %eax,(%esp)
     45a:	e8 5e fc ff ff       	call   bd <return_cup>
      printf(fd,"Bartender %d returned cup #%d\n",tid,cup->id);
     45f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     462:	8b 10                	mov    (%eax),%edx
     464:	a1 c0 1e 00 00       	mov    0x1ec0,%eax
     469:	89 54 24 0c          	mov    %edx,0xc(%esp)
     46d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     470:	89 54 24 08          	mov    %edx,0x8(%esp)
     474:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
     47b:	00 
     47c:	89 04 24             	mov    %eax,(%esp)
     47f:	e8 5b 0a 00 00       	call   edf <printf>
      
      n = DBB->full->value;
     484:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
     489:	8b 40 0c             	mov    0xc(%eax),%eax
     48c:	8b 40 08             	mov    0x8(%eax),%eax
     48f:	89 45 d0             	mov    %eax,-0x30(%ebp)
     492:	db 45 d0             	fildl  -0x30(%ebp)
     495:	dd 5d e0             	fstpl  -0x20(%ebp)
      bufSize = DBB->buffer_size;
     498:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
     49d:	8b 00                	mov    (%eax),%eax
     49f:	89 45 d0             	mov    %eax,-0x30(%ebp)
     4a2:	db 45 d0             	fildl  -0x30(%ebp)
     4a5:	dd 5d d8             	fstpl  -0x28(%ebp)
      if(n/bufSize >= 0.6)
     4a8:	dd 45 e0             	fldl   -0x20(%ebp)
     4ab:	dc 75 d8             	fdivl  -0x28(%ebp)
     4ae:	dd 05 f8 18 00 00    	fldl   0x18f8
     4b4:	d9 c9                	fxch   %st(1)
     4b6:	df e9                	fucomip %st(1),%st
     4b8:	dd d8                	fstp   %st(0)
     4ba:	0f 93 c0             	setae  %al
     4bd:	84 c0                	test   %al,%al
     4bf:	74 2e                	je     4ef <bartender_func+0x10f>
      {
	dirtycups = n;
     4c1:	dd 45 e0             	fldl   -0x20(%ebp)
     4c4:	d9 7d d6             	fnstcw -0x2a(%ebp)
     4c7:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
     4cb:	b4 0c                	mov    $0xc,%ah
     4cd:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
     4d1:	d9 6d d4             	fldcw  -0x2c(%ebp)
     4d4:	db 5d d0             	fistpl -0x30(%ebp)
     4d7:	d9 6d d6             	fldcw  -0x2a(%ebp)
     4da:	8b 45 d0             	mov    -0x30(%ebp),%eax
     4dd:	a3 c4 1e 00 00       	mov    %eax,0x1ec4
	binary_semaphore_up(cupsem);
     4e2:	a1 e4 1e 00 00       	mov    0x1ee4,%eax
     4e7:	89 04 24             	mov    %eax,(%esp)
     4ea:	e8 11 09 00 00       	call   e00 <binary_semaphore_up>
      }
    }
    free(act);
     4ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4f2:	89 04 24             	mov    %eax,(%esp)
     4f5:	e8 9a 0b 00 00       	call   1094 <free>
  }
     4fa:	e9 ef fe ff ff       	jmp    3ee <bartender_func+0xe>

000004ff <cupboy_func>:
  return 0;
}

void* cupboy_func(void)
{
     4ff:	55                   	push   %ebp
     500:	89 e5                	mov    %esp,%ebp
     502:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  
  for(;;)
  {
    //n = dirtycups;
    n = DBB->full->value;
     505:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
     50a:	8b 40 0c             	mov    0xc(%eax),%eax
     50d:	8b 40 08             	mov    0x8(%eax),%eax
     510:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0;i<n;i++)
     513:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     51a:	eb 41                	jmp    55d <cupboy_func+0x5e>
    {
      struct Cup * cup = wash_dirty();
     51c:	e8 b8 fb ff ff       	call   d9 <wash_dirty>
     521:	89 45 ec             	mov    %eax,-0x14(%ebp)
      sleep(1);
     524:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     52b:	e8 88 08 00 00       	call   db8 <sleep>
      add_clean_cup(cup);
     530:	8b 45 ec             	mov    -0x14(%ebp),%eax
     533:	89 04 24             	mov    %eax,(%esp)
     536:	e8 66 fb ff ff       	call   a1 <add_clean_cup>
      printf(fd,"Cup boy added clean cup #%d\n",cup->id);    
     53b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     53e:	8b 10                	mov    (%eax),%edx
     540:	a1 c0 1e 00 00       	mov    0x1ec0,%eax
     545:	89 54 24 08          	mov    %edx,0x8(%esp)
     549:	c7 44 24 04 8f 17 00 	movl   $0x178f,0x4(%esp)
     550:	00 
     551:	89 04 24             	mov    %eax,(%esp)
     554:	e8 86 09 00 00       	call   edf <printf>
  
  for(;;)
  {
    //n = dirtycups;
    n = DBB->full->value;
    for(i=0;i<n;i++)
     559:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     55d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     560:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     563:	7c b7                	jl     51c <cupboy_func+0x1d>
      struct Cup * cup = wash_dirty();
      sleep(1);
      add_clean_cup(cup);
      printf(fd,"Cup boy added clean cup #%d\n",cup->id);    
    }
    binary_semaphore_down(cupsem);
     565:	a1 e4 1e 00 00       	mov    0x1ee4,%eax
     56a:	89 04 24             	mov    %eax,(%esp)
     56d:	e8 86 08 00 00       	call   df8 <binary_semaphore_down>
  }
     572:	eb 91                	jmp    505 <cupboy_func+0x6>

00000574 <main>:
}


int 
main(void)
{
     574:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     578:	83 e4 f0             	and    $0xfffffff0,%esp
     57b:	ff 71 fc             	pushl  -0x4(%ecx)
     57e:	55                   	push   %ebp
     57f:	89 e5                	mov    %esp,%ebp
     581:	53                   	push   %ebx
     582:	51                   	push   %ecx
     583:	83 ec 50             	sub    $0x50,%esp
     586:	89 e0                	mov    %esp,%eax
     588:	89 c3                	mov    %eax,%ebx
  printf(1,"Running simulation...\nPlease run 'cat Synch_problem_log.txt' to see results\n");
     58a:	c7 44 24 04 ac 17 00 	movl   $0x17ac,0x4(%esp)
     591:	00 
     592:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     599:	e8 41 09 00 00       	call   edf <printf>
  close(1);
     59e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5a5:	e8 a6 07 00 00       	call   d50 <close>
  if((fd = open("Synch_problem_log.txt",(O_WRONLY | O_CREATE))) < 0)
     5aa:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     5b1:	00 
     5b2:	c7 04 24 f9 17 00 00 	movl   $0x17f9,(%esp)
     5b9:	e8 aa 07 00 00       	call   d68 <open>
     5be:	a3 c0 1e 00 00       	mov    %eax,0x1ec0
     5c3:	a1 c0 1e 00 00       	mov    0x1ec0,%eax
     5c8:	85 c0                	test   %eax,%eax
     5ca:	79 1e                	jns    5ea <main+0x76>
  {
    printf(2,"Couldn't open the log file\n");
     5cc:	c7 44 24 04 0f 18 00 	movl   $0x180f,0x4(%esp)
     5d3:	00 
     5d4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     5db:	e8 ff 08 00 00       	call   edf <printf>
    return -1;
     5e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     5e5:	e9 ce 04 00 00       	jmp    ab8 <main+0x544>
  }
  if (getconf() == -1)
     5ea:	e8 ff fa ff ff       	call   ee <getconf>
     5ef:	83 f8 ff             	cmp    $0xffffffff,%eax
     5f2:	75 0a                	jne    5fe <main+0x8a>
  {
    return -1;
     5f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     5f9:	e9 ba 04 00 00       	jmp    ab8 <main+0x544>
  }
  fd=1;
     5fe:	c7 05 c0 1e 00 00 01 	movl   $0x1,0x1ec0
     605:	00 00 00 
  void * barStack[B];
     608:	a1 cc 1e 00 00       	mov    0x1ecc,%eax
     60d:	8d 50 ff             	lea    -0x1(%eax),%edx
     610:	89 55 f0             	mov    %edx,-0x10(%ebp)
     613:	c1 e0 02             	shl    $0x2,%eax
     616:	8d 50 0f             	lea    0xf(%eax),%edx
     619:	b8 10 00 00 00       	mov    $0x10,%eax
     61e:	83 e8 01             	sub    $0x1,%eax
     621:	01 d0                	add    %edx,%eax
     623:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     62a:	ba 00 00 00 00       	mov    $0x0,%edx
     62f:	f7 75 c4             	divl   -0x3c(%ebp)
     632:	6b c0 10             	imul   $0x10,%eax,%eax
     635:	29 c4                	sub    %eax,%esp
     637:	8d 44 24 0c          	lea    0xc(%esp),%eax
     63b:	83 c0 0f             	add    $0xf,%eax
     63e:	c1 e8 04             	shr    $0x4,%eax
     641:	c1 e0 04             	shl    $0x4,%eax
     644:	89 45 ec             	mov    %eax,-0x14(%ebp)
  void * studStack[S];
     647:	a1 c8 1e 00 00       	mov    0x1ec8,%eax
     64c:	8d 50 ff             	lea    -0x1(%eax),%edx
     64f:	89 55 e8             	mov    %edx,-0x18(%ebp)
     652:	c1 e0 02             	shl    $0x2,%eax
     655:	8d 50 0f             	lea    0xf(%eax),%edx
     658:	b8 10 00 00 00       	mov    $0x10,%eax
     65d:	83 e8 01             	sub    $0x1,%eax
     660:	01 d0                	add    %edx,%eax
     662:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     669:	ba 00 00 00 00       	mov    $0x0,%edx
     66e:	f7 75 c4             	divl   -0x3c(%ebp)
     671:	6b c0 10             	imul   $0x10,%eax,%eax
     674:	29 c4                	sub    %eax,%esp
     676:	8d 44 24 0c          	lea    0xc(%esp),%eax
     67a:	83 c0 0f             	add    $0xf,%eax
     67d:	c1 e8 04             	shr    $0x4,%eax
     680:	c1 e0 04             	shl    $0x4,%eax
     683:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int studTid[S];
     686:	a1 c8 1e 00 00       	mov    0x1ec8,%eax
     68b:	8d 50 ff             	lea    -0x1(%eax),%edx
     68e:	89 55 e0             	mov    %edx,-0x20(%ebp)
     691:	c1 e0 02             	shl    $0x2,%eax
     694:	8d 50 0f             	lea    0xf(%eax),%edx
     697:	b8 10 00 00 00       	mov    $0x10,%eax
     69c:	83 e8 01             	sub    $0x1,%eax
     69f:	01 d0                	add    %edx,%eax
     6a1:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     6a8:	ba 00 00 00 00       	mov    $0x0,%edx
     6ad:	f7 75 c4             	divl   -0x3c(%ebp)
     6b0:	6b c0 10             	imul   $0x10,%eax,%eax
     6b3:	29 c4                	sub    %eax,%esp
     6b5:	8d 44 24 0c          	lea    0xc(%esp),%eax
     6b9:	83 c0 0f             	add    $0xf,%eax
     6bc:	c1 e8 04             	shr    $0x4,%eax
     6bf:	c1 e0 04             	shl    $0x4,%eax
     6c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int i = 0;  
     6c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  bouncer = semaphore_create(M);
     6cc:	a1 e0 1e 00 00       	mov    0x1ee0,%eax
     6d1:	89 04 24             	mov    %eax,(%esp)
     6d4:	e8 cb 0b 00 00       	call   12a4 <semaphore_create>
     6d9:	a3 bc 1e 00 00       	mov    %eax,0x1ebc
  cupsem = binary_semaphore_create(1/*,"cupboy"*/);
     6de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6e5:	e8 06 07 00 00       	call   df0 <binary_semaphore_create>
     6ea:	a3 e4 1e 00 00       	mov    %eax,0x1ee4
  ABB = BB_create(A);
     6ef:	a1 b8 1e 00 00       	mov    0x1eb8,%eax
     6f4:	89 04 24             	mov    %eax,(%esp)
     6f7:	e8 00 0d 00 00       	call   13fc <BB_create>
     6fc:	a3 d0 1e 00 00       	mov    %eax,0x1ed0
  DrinkBB = BB_create(A);
     701:	a1 b8 1e 00 00       	mov    0x1eb8,%eax
     706:	89 04 24             	mov    %eax,(%esp)
     709:	e8 ee 0c 00 00       	call   13fc <BB_create>
     70e:	a3 dc 1e 00 00       	mov    %eax,0x1edc
  CBB = BB_create(C);
     713:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
     718:	89 04 24             	mov    %eax,(%esp)
     71b:	e8 dc 0c 00 00       	call   13fc <BB_create>
     720:	a3 fc 1e 00 00       	mov    %eax,0x1efc
  DBB = BB_create(C);
     725:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
     72a:	89 04 24             	mov    %eax,(%esp)
     72d:	e8 ca 0c 00 00       	call   13fc <BB_create>
     732:	a3 d8 1e 00 00       	mov    %eax,0x1ed8
  struct Cup* cups[C];
     737:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
     73c:	8d 50 ff             	lea    -0x1(%eax),%edx
     73f:	89 55 d8             	mov    %edx,-0x28(%ebp)
     742:	c1 e0 02             	shl    $0x2,%eax
     745:	8d 50 0f             	lea    0xf(%eax),%edx
     748:	b8 10 00 00 00       	mov    $0x10,%eax
     74d:	83 e8 01             	sub    $0x1,%eax
     750:	01 d0                	add    %edx,%eax
     752:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     759:	ba 00 00 00 00       	mov    $0x0,%edx
     75e:	f7 75 c4             	divl   -0x3c(%ebp)
     761:	6b c0 10             	imul   $0x10,%eax,%eax
     764:	29 c4                	sub    %eax,%esp
     766:	8d 44 24 0c          	lea    0xc(%esp),%eax
     76a:	83 c0 0f             	add    $0xf,%eax
     76d:	c1 e8 04             	shr    $0x4,%eax
     770:	c1 e0 04             	shl    $0x4,%eax
     773:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  for(;i<C;i++)
     776:	eb 41                	jmp    7b9 <main+0x245>
  {
    cups[i] = malloc(sizeof(struct Cup));
     778:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     77f:	e8 3f 0a 00 00       	call   11c3 <malloc>
     784:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     787:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     78a:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    cups[i]->id = i;
     78d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     790:	8b 55 f4             	mov    -0xc(%ebp),%edx
     793:	8b 04 90             	mov    (%eax,%edx,4),%eax
     796:	8b 55 f4             	mov    -0xc(%ebp),%edx
     799:	89 10                	mov    %edx,(%eax)
    BB_put(CBB,cups[i]);
     79b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     79e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7a1:	8b 14 90             	mov    (%eax,%edx,4),%edx
     7a4:	a1 fc 1e 00 00       	mov    0x1efc,%eax
     7a9:	89 54 24 04          	mov    %edx,0x4(%esp)
     7ad:	89 04 24             	mov    %eax,(%esp)
     7b0:	e8 6c 0d 00 00       	call   1521 <BB_put>
  DrinkBB = BB_create(A);
  CBB = BB_create(C);
  DBB = BB_create(C);
  struct Cup* cups[C];
  
  for(;i<C;i++)
     7b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7b9:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
     7be:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     7c1:	7c b5                	jl     778 <main+0x204>
    cups[i] = malloc(sizeof(struct Cup));
    cups[i]->id = i;
    BB_put(CBB,cups[i]);
  }
  
  void* cupStack = malloc(sizeof(void*)*1024);
     7c3:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     7ca:	e8 f4 09 00 00       	call   11c3 <malloc>
     7cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  memset(cupStack,0,sizeof(void*)*1024);
     7d2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     7d9:	00 
     7da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     7e1:	00 
     7e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
     7e5:	89 04 24             	mov    %eax,(%esp)
     7e8:	e8 96 03 00 00       	call   b83 <memset>
  if(thread_create(cupboy_func,cupStack,sizeof(void*)*1024) < 0)
     7ed:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     7f4:	00 
     7f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
     7f8:	89 44 24 04          	mov    %eax,0x4(%esp)
     7fc:	c7 04 24 ff 04 00 00 	movl   $0x4ff,(%esp)
     803:	e8 c0 05 00 00       	call   dc8 <thread_create>
     808:	85 c0                	test   %eax,%eax
     80a:	79 19                	jns    825 <main+0x2b1>
  {
    printf(2,"Failed to create cupboy thread. Exiting...\n");
     80c:	c7 44 24 04 2c 18 00 	movl   $0x182c,0x4(%esp)
     813:	00 
     814:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     81b:	e8 bf 06 00 00       	call   edf <printf>
    exit();
     820:	e8 03 05 00 00       	call   d28 <exit>
  }
  
  for(i=0;i<B;i++)
     825:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     82c:	e9 82 00 00 00       	jmp    8b3 <main+0x33f>
  {
    barStack[i] = malloc(sizeof(void*)*1024);
     831:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     838:	e8 86 09 00 00       	call   11c3 <malloc>
     83d:	8b 55 ec             	mov    -0x14(%ebp),%edx
     840:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     843:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    memset(barStack[i],0,sizeof(void*)*1024);
     846:	8b 45 ec             	mov    -0x14(%ebp),%eax
     849:	8b 55 f4             	mov    -0xc(%ebp),%edx
     84c:	8b 04 90             	mov    (%eax,%edx,4),%eax
     84f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     856:	00 
     857:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     85e:	00 
     85f:	89 04 24             	mov    %eax,(%esp)
     862:	e8 1c 03 00 00       	call   b83 <memset>
    if(thread_create(bartender_func,barStack[i],sizeof(void*)*1024) < 0)
     867:	8b 45 ec             	mov    -0x14(%ebp),%eax
     86a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     86d:	8b 04 90             	mov    (%eax,%edx,4),%eax
     870:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     877:	00 
     878:	89 44 24 04          	mov    %eax,0x4(%esp)
     87c:	c7 04 24 e0 03 00 00 	movl   $0x3e0,(%esp)
     883:	e8 40 05 00 00       	call   dc8 <thread_create>
     888:	85 c0                	test   %eax,%eax
     88a:	79 23                	jns    8af <main+0x33b>
    {
      printf(2,"Failed to create bartender thread #%d. Exiting...\n",i+1);
     88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     88f:	83 c0 01             	add    $0x1,%eax
     892:	89 44 24 08          	mov    %eax,0x8(%esp)
     896:	c7 44 24 04 58 18 00 	movl   $0x1858,0x4(%esp)
     89d:	00 
     89e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     8a5:	e8 35 06 00 00       	call   edf <printf>
      exit();
     8aa:	e8 79 04 00 00       	call   d28 <exit>
  {
    printf(2,"Failed to create cupboy thread. Exiting...\n");
    exit();
  }
  
  for(i=0;i<B;i++)
     8af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     8b3:	a1 cc 1e 00 00       	mov    0x1ecc,%eax
     8b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     8bb:	0f 8c 70 ff ff ff    	jl     831 <main+0x2bd>
    {
      printf(2,"Failed to create bartender thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }
  for(i=0;i<S;i++)
     8c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     8c8:	e9 94 00 00 00       	jmp    961 <main+0x3ed>
  {
    studStack[i] = malloc(sizeof(void*)*1024);
     8cd:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     8d4:	e8 ea 08 00 00       	call   11c3 <malloc>
     8d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     8dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     8df:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    memset(studStack[i],0,sizeof(void*)*1024);
     8e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8e8:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8eb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     8f2:	00 
     8f3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     8fa:	00 
     8fb:	89 04 24             	mov    %eax,(%esp)
     8fe:	e8 80 02 00 00       	call   b83 <memset>
    if((studTid[i] = thread_create(student_func,studStack[i],sizeof(void*)*1024)) < 0)
     903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     906:	8b 55 f4             	mov    -0xc(%ebp),%edx
     909:	8b 04 90             	mov    (%eax,%edx,4),%eax
     90c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     913:	00 
     914:	89 44 24 04          	mov    %eax,0x4(%esp)
     918:	c7 04 24 b2 02 00 00 	movl   $0x2b2,(%esp)
     91f:	e8 a4 04 00 00       	call   dc8 <thread_create>
     924:	8b 55 dc             	mov    -0x24(%ebp),%edx
     927:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     92a:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     92d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     930:	8b 55 f4             	mov    -0xc(%ebp),%edx
     933:	8b 04 90             	mov    (%eax,%edx,4),%eax
     936:	85 c0                	test   %eax,%eax
     938:	79 23                	jns    95d <main+0x3e9>
    {
      printf(2,"Failed to create student thread #%d. Exiting...\n",i+1);
     93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     93d:	83 c0 01             	add    $0x1,%eax
     940:	89 44 24 08          	mov    %eax,0x8(%esp)
     944:	c7 44 24 04 8c 18 00 	movl   $0x188c,0x4(%esp)
     94b:	00 
     94c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     953:	e8 87 05 00 00       	call   edf <printf>
      exit();
     958:	e8 cb 03 00 00       	call   d28 <exit>
    {
      printf(2,"Failed to create bartender thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }
  for(i=0;i<S;i++)
     95d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     961:	a1 c8 1e 00 00       	mov    0x1ec8,%eax
     966:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     969:	0f 8c 5e ff ff ff    	jl     8cd <main+0x359>
      printf(2,"Failed to create student thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }

  for(i=0;i<S;i++)
     96f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     976:	eb 55                	jmp    9cd <main+0x459>
  {
    if(thread_join(studTid[i],0) != 0)
     978:	8b 45 dc             	mov    -0x24(%ebp),%eax
     97b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     97e:	8b 04 90             	mov    (%eax,%edx,4),%eax
     981:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     988:	00 
     989:	89 04 24             	mov    %eax,(%esp)
     98c:	e8 4f 04 00 00       	call   de0 <thread_join>
     991:	85 c0                	test   %eax,%eax
     993:	74 23                	je     9b8 <main+0x444>
    {
      printf(2,"Failed to join on student thread #%d. Exiting...\n",i+1);
     995:	8b 45 f4             	mov    -0xc(%ebp),%eax
     998:	83 c0 01             	add    $0x1,%eax
     99b:	89 44 24 08          	mov    %eax,0x8(%esp)
     99f:	c7 44 24 04 c0 18 00 	movl   $0x18c0,0x4(%esp)
     9a6:	00 
     9a7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     9ae:	e8 2c 05 00 00       	call   edf <printf>
      exit();
     9b3:	e8 70 03 00 00       	call   d28 <exit>
    }
    
    free(studStack[i]);
     9b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     9bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9be:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9c1:	89 04 24             	mov    %eax,(%esp)
     9c4:	e8 cb 06 00 00       	call   1094 <free>
      printf(2,"Failed to create student thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }

  for(i=0;i<S;i++)
     9c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9cd:	a1 c8 1e 00 00       	mov    0x1ec8,%eax
     9d2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     9d5:	7c a1                	jl     978 <main+0x404>
    }
    
    free(studStack[i]);
  }
  
  for(i=0;i<B;i++)
     9d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9de:	eb 15                	jmp    9f5 <main+0x481>
    free(barStack[i]);
     9e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     9e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9e6:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9e9:	89 04 24             	mov    %eax,(%esp)
     9ec:	e8 a3 06 00 00       	call   1094 <free>
    }
    
    free(studStack[i]);
  }
  
  for(i=0;i<B;i++)
     9f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9f5:	a1 cc 1e 00 00       	mov    0x1ecc,%eax
     9fa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     9fd:	7c e1                	jl     9e0 <main+0x46c>
    free(barStack[i]);
  free(cupStack);
     9ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
     a02:	89 04 24             	mov    %eax,(%esp)
     a05:	e8 8a 06 00 00       	call   1094 <free>
  
  for(i=0;i<C;i++)
     a0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a11:	eb 15                	jmp    a28 <main+0x4b4>
    free(cups[i]);
     a13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a19:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a1c:	89 04 24             	mov    %eax,(%esp)
     a1f:	e8 70 06 00 00       	call   1094 <free>
  
  for(i=0;i<B;i++)
    free(barStack[i]);
  free(cupStack);
  
  for(i=0;i<C;i++)
     a24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a28:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
     a2d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a30:	7c e1                	jl     a13 <main+0x49f>
    free(cups[i]);
  

  free(CBB->pointer_to_elements);
     a32:	a1 fc 1e 00 00       	mov    0x1efc,%eax
     a37:	8b 40 1c             	mov    0x1c(%eax),%eax
     a3a:	89 04 24             	mov    %eax,(%esp)
     a3d:	e8 52 06 00 00       	call   1094 <free>
  free(DBB->pointer_to_elements);
     a42:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
     a47:	8b 40 1c             	mov    0x1c(%eax),%eax
     a4a:	89 04 24             	mov    %eax,(%esp)
     a4d:	e8 42 06 00 00       	call   1094 <free>
  free(CBB);
     a52:	a1 fc 1e 00 00       	mov    0x1efc,%eax
     a57:	89 04 24             	mov    %eax,(%esp)
     a5a:	e8 35 06 00 00       	call   1094 <free>
  free(DBB);
     a5f:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
     a64:	89 04 24             	mov    %eax,(%esp)
     a67:	e8 28 06 00 00       	call   1094 <free>
  
  free(ABB->pointer_to_elements);
     a6c:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
     a71:	8b 40 1c             	mov    0x1c(%eax),%eax
     a74:	89 04 24             	mov    %eax,(%esp)
     a77:	e8 18 06 00 00       	call   1094 <free>
  free(DrinkBB->pointer_to_elements);
     a7c:	a1 dc 1e 00 00       	mov    0x1edc,%eax
     a81:	8b 40 1c             	mov    0x1c(%eax),%eax
     a84:	89 04 24             	mov    %eax,(%esp)
     a87:	e8 08 06 00 00       	call   1094 <free>
  free(ABB);
     a8c:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
     a91:	89 04 24             	mov    %eax,(%esp)
     a94:	e8 fb 05 00 00       	call   1094 <free>
  free(DrinkBB);
     a99:	a1 dc 1e 00 00       	mov    0x1edc,%eax
     a9e:	89 04 24             	mov    %eax,(%esp)
     aa1:	e8 ee 05 00 00       	call   1094 <free>
  close(fd);
     aa6:	a1 c0 1e 00 00       	mov    0x1ec0,%eax
     aab:	89 04 24             	mov    %eax,(%esp)
     aae:	e8 9d 02 00 00       	call   d50 <close>
  exit();
     ab3:	e8 70 02 00 00       	call   d28 <exit>
     ab8:	89 dc                	mov    %ebx,%esp
  return 0;
     aba:	8d 65 f8             	lea    -0x8(%ebp),%esp
     abd:	59                   	pop    %ecx
     abe:	5b                   	pop    %ebx
     abf:	5d                   	pop    %ebp
     ac0:	8d 61 fc             	lea    -0x4(%ecx),%esp
     ac3:	c3                   	ret    

00000ac4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     ac4:	55                   	push   %ebp
     ac5:	89 e5                	mov    %esp,%ebp
     ac7:	57                   	push   %edi
     ac8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     ac9:	8b 4d 08             	mov    0x8(%ebp),%ecx
     acc:	8b 55 10             	mov    0x10(%ebp),%edx
     acf:	8b 45 0c             	mov    0xc(%ebp),%eax
     ad2:	89 cb                	mov    %ecx,%ebx
     ad4:	89 df                	mov    %ebx,%edi
     ad6:	89 d1                	mov    %edx,%ecx
     ad8:	fc                   	cld    
     ad9:	f3 aa                	rep stos %al,%es:(%edi)
     adb:	89 ca                	mov    %ecx,%edx
     add:	89 fb                	mov    %edi,%ebx
     adf:	89 5d 08             	mov    %ebx,0x8(%ebp)
     ae2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     ae5:	5b                   	pop    %ebx
     ae6:	5f                   	pop    %edi
     ae7:	5d                   	pop    %ebp
     ae8:	c3                   	ret    

00000ae9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     ae9:	55                   	push   %ebp
     aea:	89 e5                	mov    %esp,%ebp
     aec:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     aef:	8b 45 08             	mov    0x8(%ebp),%eax
     af2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     af5:	90                   	nop
     af6:	8b 45 0c             	mov    0xc(%ebp),%eax
     af9:	0f b6 10             	movzbl (%eax),%edx
     afc:	8b 45 08             	mov    0x8(%ebp),%eax
     aff:	88 10                	mov    %dl,(%eax)
     b01:	8b 45 08             	mov    0x8(%ebp),%eax
     b04:	0f b6 00             	movzbl (%eax),%eax
     b07:	84 c0                	test   %al,%al
     b09:	0f 95 c0             	setne  %al
     b0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     b14:	84 c0                	test   %al,%al
     b16:	75 de                	jne    af6 <strcpy+0xd>
    ;
  return os;
     b18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     b1b:	c9                   	leave  
     b1c:	c3                   	ret    

00000b1d <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b1d:	55                   	push   %ebp
     b1e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     b20:	eb 08                	jmp    b2a <strcmp+0xd>
    p++, q++;
     b22:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b26:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     b2a:	8b 45 08             	mov    0x8(%ebp),%eax
     b2d:	0f b6 00             	movzbl (%eax),%eax
     b30:	84 c0                	test   %al,%al
     b32:	74 10                	je     b44 <strcmp+0x27>
     b34:	8b 45 08             	mov    0x8(%ebp),%eax
     b37:	0f b6 10             	movzbl (%eax),%edx
     b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
     b3d:	0f b6 00             	movzbl (%eax),%eax
     b40:	38 c2                	cmp    %al,%dl
     b42:	74 de                	je     b22 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     b44:	8b 45 08             	mov    0x8(%ebp),%eax
     b47:	0f b6 00             	movzbl (%eax),%eax
     b4a:	0f b6 d0             	movzbl %al,%edx
     b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
     b50:	0f b6 00             	movzbl (%eax),%eax
     b53:	0f b6 c0             	movzbl %al,%eax
     b56:	89 d1                	mov    %edx,%ecx
     b58:	29 c1                	sub    %eax,%ecx
     b5a:	89 c8                	mov    %ecx,%eax
}
     b5c:	5d                   	pop    %ebp
     b5d:	c3                   	ret    

00000b5e <strlen>:

uint
strlen(char *s)
{
     b5e:	55                   	push   %ebp
     b5f:	89 e5                	mov    %esp,%ebp
     b61:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     b64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     b6b:	eb 04                	jmp    b71 <strlen+0x13>
     b6d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     b71:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b74:	03 45 08             	add    0x8(%ebp),%eax
     b77:	0f b6 00             	movzbl (%eax),%eax
     b7a:	84 c0                	test   %al,%al
     b7c:	75 ef                	jne    b6d <strlen+0xf>
    ;
  return n;
     b7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     b81:	c9                   	leave  
     b82:	c3                   	ret    

00000b83 <memset>:

void*
memset(void *dst, int c, uint n)
{
     b83:	55                   	push   %ebp
     b84:	89 e5                	mov    %esp,%ebp
     b86:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     b89:	8b 45 10             	mov    0x10(%ebp),%eax
     b8c:	89 44 24 08          	mov    %eax,0x8(%esp)
     b90:	8b 45 0c             	mov    0xc(%ebp),%eax
     b93:	89 44 24 04          	mov    %eax,0x4(%esp)
     b97:	8b 45 08             	mov    0x8(%ebp),%eax
     b9a:	89 04 24             	mov    %eax,(%esp)
     b9d:	e8 22 ff ff ff       	call   ac4 <stosb>
  return dst;
     ba2:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ba5:	c9                   	leave  
     ba6:	c3                   	ret    

00000ba7 <strchr>:

char*
strchr(const char *s, char c)
{
     ba7:	55                   	push   %ebp
     ba8:	89 e5                	mov    %esp,%ebp
     baa:	83 ec 04             	sub    $0x4,%esp
     bad:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     bb3:	eb 14                	jmp    bc9 <strchr+0x22>
    if(*s == c)
     bb5:	8b 45 08             	mov    0x8(%ebp),%eax
     bb8:	0f b6 00             	movzbl (%eax),%eax
     bbb:	3a 45 fc             	cmp    -0x4(%ebp),%al
     bbe:	75 05                	jne    bc5 <strchr+0x1e>
      return (char*)s;
     bc0:	8b 45 08             	mov    0x8(%ebp),%eax
     bc3:	eb 13                	jmp    bd8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     bc5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     bc9:	8b 45 08             	mov    0x8(%ebp),%eax
     bcc:	0f b6 00             	movzbl (%eax),%eax
     bcf:	84 c0                	test   %al,%al
     bd1:	75 e2                	jne    bb5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     bd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     bd8:	c9                   	leave  
     bd9:	c3                   	ret    

00000bda <gets>:

char*
gets(char *buf, int max)
{
     bda:	55                   	push   %ebp
     bdb:	89 e5                	mov    %esp,%ebp
     bdd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     be0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     be7:	eb 44                	jmp    c2d <gets+0x53>
    cc = read(0, &c, 1);
     be9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bf0:	00 
     bf1:	8d 45 ef             	lea    -0x11(%ebp),%eax
     bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
     bf8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     bff:	e8 3c 01 00 00       	call   d40 <read>
     c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c0b:	7e 2d                	jle    c3a <gets+0x60>
      break;
    buf[i++] = c;
     c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c10:	03 45 08             	add    0x8(%ebp),%eax
     c13:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     c17:	88 10                	mov    %dl,(%eax)
     c19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     c1d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     c21:	3c 0a                	cmp    $0xa,%al
     c23:	74 16                	je     c3b <gets+0x61>
     c25:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     c29:	3c 0d                	cmp    $0xd,%al
     c2b:	74 0e                	je     c3b <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c30:	83 c0 01             	add    $0x1,%eax
     c33:	3b 45 0c             	cmp    0xc(%ebp),%eax
     c36:	7c b1                	jl     be9 <gets+0xf>
     c38:	eb 01                	jmp    c3b <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     c3a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c3e:	03 45 08             	add    0x8(%ebp),%eax
     c41:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     c44:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c47:	c9                   	leave  
     c48:	c3                   	ret    

00000c49 <stat>:

int
stat(char *n, struct stat *st)
{
     c49:	55                   	push   %ebp
     c4a:	89 e5                	mov    %esp,%ebp
     c4c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c56:	00 
     c57:	8b 45 08             	mov    0x8(%ebp),%eax
     c5a:	89 04 24             	mov    %eax,(%esp)
     c5d:	e8 06 01 00 00       	call   d68 <open>
     c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     c65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c69:	79 07                	jns    c72 <stat+0x29>
    return -1;
     c6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c70:	eb 23                	jmp    c95 <stat+0x4c>
  r = fstat(fd, st);
     c72:	8b 45 0c             	mov    0xc(%ebp),%eax
     c75:	89 44 24 04          	mov    %eax,0x4(%esp)
     c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c7c:	89 04 24             	mov    %eax,(%esp)
     c7f:	e8 fc 00 00 00       	call   d80 <fstat>
     c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c8a:	89 04 24             	mov    %eax,(%esp)
     c8d:	e8 be 00 00 00       	call   d50 <close>
  return r;
     c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     c95:	c9                   	leave  
     c96:	c3                   	ret    

00000c97 <atoi>:

int
atoi(const char *s)
{
     c97:	55                   	push   %ebp
     c98:	89 e5                	mov    %esp,%ebp
     c9a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     c9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     ca4:	eb 23                	jmp    cc9 <atoi+0x32>
    n = n*10 + *s++ - '0';
     ca6:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ca9:	89 d0                	mov    %edx,%eax
     cab:	c1 e0 02             	shl    $0x2,%eax
     cae:	01 d0                	add    %edx,%eax
     cb0:	01 c0                	add    %eax,%eax
     cb2:	89 c2                	mov    %eax,%edx
     cb4:	8b 45 08             	mov    0x8(%ebp),%eax
     cb7:	0f b6 00             	movzbl (%eax),%eax
     cba:	0f be c0             	movsbl %al,%eax
     cbd:	01 d0                	add    %edx,%eax
     cbf:	83 e8 30             	sub    $0x30,%eax
     cc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
     cc5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cc9:	8b 45 08             	mov    0x8(%ebp),%eax
     ccc:	0f b6 00             	movzbl (%eax),%eax
     ccf:	3c 2f                	cmp    $0x2f,%al
     cd1:	7e 0a                	jle    cdd <atoi+0x46>
     cd3:	8b 45 08             	mov    0x8(%ebp),%eax
     cd6:	0f b6 00             	movzbl (%eax),%eax
     cd9:	3c 39                	cmp    $0x39,%al
     cdb:	7e c9                	jle    ca6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     cdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     ce0:	c9                   	leave  
     ce1:	c3                   	ret    

00000ce2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     ce2:	55                   	push   %ebp
     ce3:	89 e5                	mov    %esp,%ebp
     ce5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     ce8:	8b 45 08             	mov    0x8(%ebp),%eax
     ceb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     cee:	8b 45 0c             	mov    0xc(%ebp),%eax
     cf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     cf4:	eb 13                	jmp    d09 <memmove+0x27>
    *dst++ = *src++;
     cf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     cf9:	0f b6 10             	movzbl (%eax),%edx
     cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     cff:	88 10                	mov    %dl,(%eax)
     d01:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d05:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     d0d:	0f 9f c0             	setg   %al
     d10:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     d14:	84 c0                	test   %al,%al
     d16:	75 de                	jne    cf6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     d18:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d1b:	c9                   	leave  
     d1c:	c3                   	ret    
     d1d:	90                   	nop
     d1e:	90                   	nop
     d1f:	90                   	nop

00000d20 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d20:	b8 01 00 00 00       	mov    $0x1,%eax
     d25:	cd 40                	int    $0x40
     d27:	c3                   	ret    

00000d28 <exit>:
SYSCALL(exit)
     d28:	b8 02 00 00 00       	mov    $0x2,%eax
     d2d:	cd 40                	int    $0x40
     d2f:	c3                   	ret    

00000d30 <wait>:
SYSCALL(wait)
     d30:	b8 03 00 00 00       	mov    $0x3,%eax
     d35:	cd 40                	int    $0x40
     d37:	c3                   	ret    

00000d38 <pipe>:
SYSCALL(pipe)
     d38:	b8 04 00 00 00       	mov    $0x4,%eax
     d3d:	cd 40                	int    $0x40
     d3f:	c3                   	ret    

00000d40 <read>:
SYSCALL(read)
     d40:	b8 05 00 00 00       	mov    $0x5,%eax
     d45:	cd 40                	int    $0x40
     d47:	c3                   	ret    

00000d48 <write>:
SYSCALL(write)
     d48:	b8 10 00 00 00       	mov    $0x10,%eax
     d4d:	cd 40                	int    $0x40
     d4f:	c3                   	ret    

00000d50 <close>:
SYSCALL(close)
     d50:	b8 15 00 00 00       	mov    $0x15,%eax
     d55:	cd 40                	int    $0x40
     d57:	c3                   	ret    

00000d58 <kill>:
SYSCALL(kill)
     d58:	b8 06 00 00 00       	mov    $0x6,%eax
     d5d:	cd 40                	int    $0x40
     d5f:	c3                   	ret    

00000d60 <exec>:
SYSCALL(exec)
     d60:	b8 07 00 00 00       	mov    $0x7,%eax
     d65:	cd 40                	int    $0x40
     d67:	c3                   	ret    

00000d68 <open>:
SYSCALL(open)
     d68:	b8 0f 00 00 00       	mov    $0xf,%eax
     d6d:	cd 40                	int    $0x40
     d6f:	c3                   	ret    

00000d70 <mknod>:
SYSCALL(mknod)
     d70:	b8 11 00 00 00       	mov    $0x11,%eax
     d75:	cd 40                	int    $0x40
     d77:	c3                   	ret    

00000d78 <unlink>:
SYSCALL(unlink)
     d78:	b8 12 00 00 00       	mov    $0x12,%eax
     d7d:	cd 40                	int    $0x40
     d7f:	c3                   	ret    

00000d80 <fstat>:
SYSCALL(fstat)
     d80:	b8 08 00 00 00       	mov    $0x8,%eax
     d85:	cd 40                	int    $0x40
     d87:	c3                   	ret    

00000d88 <link>:
SYSCALL(link)
     d88:	b8 13 00 00 00       	mov    $0x13,%eax
     d8d:	cd 40                	int    $0x40
     d8f:	c3                   	ret    

00000d90 <mkdir>:
SYSCALL(mkdir)
     d90:	b8 14 00 00 00       	mov    $0x14,%eax
     d95:	cd 40                	int    $0x40
     d97:	c3                   	ret    

00000d98 <chdir>:
SYSCALL(chdir)
     d98:	b8 09 00 00 00       	mov    $0x9,%eax
     d9d:	cd 40                	int    $0x40
     d9f:	c3                   	ret    

00000da0 <dup>:
SYSCALL(dup)
     da0:	b8 0a 00 00 00       	mov    $0xa,%eax
     da5:	cd 40                	int    $0x40
     da7:	c3                   	ret    

00000da8 <getpid>:
SYSCALL(getpid)
     da8:	b8 0b 00 00 00       	mov    $0xb,%eax
     dad:	cd 40                	int    $0x40
     daf:	c3                   	ret    

00000db0 <sbrk>:
SYSCALL(sbrk)
     db0:	b8 0c 00 00 00       	mov    $0xc,%eax
     db5:	cd 40                	int    $0x40
     db7:	c3                   	ret    

00000db8 <sleep>:
SYSCALL(sleep)
     db8:	b8 0d 00 00 00       	mov    $0xd,%eax
     dbd:	cd 40                	int    $0x40
     dbf:	c3                   	ret    

00000dc0 <uptime>:
SYSCALL(uptime)
     dc0:	b8 0e 00 00 00       	mov    $0xe,%eax
     dc5:	cd 40                	int    $0x40
     dc7:	c3                   	ret    

00000dc8 <thread_create>:
SYSCALL(thread_create)
     dc8:	b8 16 00 00 00       	mov    $0x16,%eax
     dcd:	cd 40                	int    $0x40
     dcf:	c3                   	ret    

00000dd0 <thread_getId>:
SYSCALL(thread_getId)
     dd0:	b8 17 00 00 00       	mov    $0x17,%eax
     dd5:	cd 40                	int    $0x40
     dd7:	c3                   	ret    

00000dd8 <thread_getProcId>:
SYSCALL(thread_getProcId)
     dd8:	b8 18 00 00 00       	mov    $0x18,%eax
     ddd:	cd 40                	int    $0x40
     ddf:	c3                   	ret    

00000de0 <thread_join>:
SYSCALL(thread_join)
     de0:	b8 19 00 00 00       	mov    $0x19,%eax
     de5:	cd 40                	int    $0x40
     de7:	c3                   	ret    

00000de8 <thread_exit>:
SYSCALL(thread_exit)
     de8:	b8 1a 00 00 00       	mov    $0x1a,%eax
     ded:	cd 40                	int    $0x40
     def:	c3                   	ret    

00000df0 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     df0:	b8 1b 00 00 00       	mov    $0x1b,%eax
     df5:	cd 40                	int    $0x40
     df7:	c3                   	ret    

00000df8 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     df8:	b8 1c 00 00 00       	mov    $0x1c,%eax
     dfd:	cd 40                	int    $0x40
     dff:	c3                   	ret    

00000e00 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     e00:	b8 1d 00 00 00       	mov    $0x1d,%eax
     e05:	cd 40                	int    $0x40
     e07:	c3                   	ret    

00000e08 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     e08:	55                   	push   %ebp
     e09:	89 e5                	mov    %esp,%ebp
     e0b:	83 ec 28             	sub    $0x28,%esp
     e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
     e11:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     e14:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e1b:	00 
     e1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
     e1f:	89 44 24 04          	mov    %eax,0x4(%esp)
     e23:	8b 45 08             	mov    0x8(%ebp),%eax
     e26:	89 04 24             	mov    %eax,(%esp)
     e29:	e8 1a ff ff ff       	call   d48 <write>
}
     e2e:	c9                   	leave  
     e2f:	c3                   	ret    

00000e30 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e30:	55                   	push   %ebp
     e31:	89 e5                	mov    %esp,%ebp
     e33:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     e36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     e3d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     e41:	74 17                	je     e5a <printint+0x2a>
     e43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     e47:	79 11                	jns    e5a <printint+0x2a>
    neg = 1;
     e49:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     e50:	8b 45 0c             	mov    0xc(%ebp),%eax
     e53:	f7 d8                	neg    %eax
     e55:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e58:	eb 06                	jmp    e60 <printint+0x30>
  } else {
    x = xx;
     e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
     e5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     e60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     e67:	8b 4d 10             	mov    0x10(%ebp),%ecx
     e6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e6d:	ba 00 00 00 00       	mov    $0x0,%edx
     e72:	f7 f1                	div    %ecx
     e74:	89 d0                	mov    %edx,%eax
     e76:	0f b6 90 98 1e 00 00 	movzbl 0x1e98(%eax),%edx
     e7d:	8d 45 dc             	lea    -0x24(%ebp),%eax
     e80:	03 45 f4             	add    -0xc(%ebp),%eax
     e83:	88 10                	mov    %dl,(%eax)
     e85:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     e89:	8b 55 10             	mov    0x10(%ebp),%edx
     e8c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e92:	ba 00 00 00 00       	mov    $0x0,%edx
     e97:	f7 75 d4             	divl   -0x2c(%ebp)
     e9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ea1:	75 c4                	jne    e67 <printint+0x37>
  if(neg)
     ea3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ea7:	74 2a                	je     ed3 <printint+0xa3>
    buf[i++] = '-';
     ea9:	8d 45 dc             	lea    -0x24(%ebp),%eax
     eac:	03 45 f4             	add    -0xc(%ebp),%eax
     eaf:	c6 00 2d             	movb   $0x2d,(%eax)
     eb2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     eb6:	eb 1b                	jmp    ed3 <printint+0xa3>
    putc(fd, buf[i]);
     eb8:	8d 45 dc             	lea    -0x24(%ebp),%eax
     ebb:	03 45 f4             	add    -0xc(%ebp),%eax
     ebe:	0f b6 00             	movzbl (%eax),%eax
     ec1:	0f be c0             	movsbl %al,%eax
     ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
     ec8:	8b 45 08             	mov    0x8(%ebp),%eax
     ecb:	89 04 24             	mov    %eax,(%esp)
     ece:	e8 35 ff ff ff       	call   e08 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     ed3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     ed7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     edb:	79 db                	jns    eb8 <printint+0x88>
    putc(fd, buf[i]);
}
     edd:	c9                   	leave  
     ede:	c3                   	ret    

00000edf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     edf:	55                   	push   %ebp
     ee0:	89 e5                	mov    %esp,%ebp
     ee2:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     ee5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     eec:	8d 45 0c             	lea    0xc(%ebp),%eax
     eef:	83 c0 04             	add    $0x4,%eax
     ef2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     ef5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     efc:	e9 7d 01 00 00       	jmp    107e <printf+0x19f>
    c = fmt[i] & 0xff;
     f01:	8b 55 0c             	mov    0xc(%ebp),%edx
     f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f07:	01 d0                	add    %edx,%eax
     f09:	0f b6 00             	movzbl (%eax),%eax
     f0c:	0f be c0             	movsbl %al,%eax
     f0f:	25 ff 00 00 00       	and    $0xff,%eax
     f14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     f17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f1b:	75 2c                	jne    f49 <printf+0x6a>
      if(c == '%'){
     f1d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     f21:	75 0c                	jne    f2f <printf+0x50>
        state = '%';
     f23:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     f2a:	e9 4b 01 00 00       	jmp    107a <printf+0x19b>
      } else {
        putc(fd, c);
     f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f32:	0f be c0             	movsbl %al,%eax
     f35:	89 44 24 04          	mov    %eax,0x4(%esp)
     f39:	8b 45 08             	mov    0x8(%ebp),%eax
     f3c:	89 04 24             	mov    %eax,(%esp)
     f3f:	e8 c4 fe ff ff       	call   e08 <putc>
     f44:	e9 31 01 00 00       	jmp    107a <printf+0x19b>
      }
    } else if(state == '%'){
     f49:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     f4d:	0f 85 27 01 00 00    	jne    107a <printf+0x19b>
      if(c == 'd'){
     f53:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     f57:	75 2d                	jne    f86 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     f59:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f5c:	8b 00                	mov    (%eax),%eax
     f5e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     f65:	00 
     f66:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f6d:	00 
     f6e:	89 44 24 04          	mov    %eax,0x4(%esp)
     f72:	8b 45 08             	mov    0x8(%ebp),%eax
     f75:	89 04 24             	mov    %eax,(%esp)
     f78:	e8 b3 fe ff ff       	call   e30 <printint>
        ap++;
     f7d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     f81:	e9 ed 00 00 00       	jmp    1073 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
     f86:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     f8a:	74 06                	je     f92 <printf+0xb3>
     f8c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     f90:	75 2d                	jne    fbf <printf+0xe0>
        printint(fd, *ap, 16, 0);
     f92:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f95:	8b 00                	mov    (%eax),%eax
     f97:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     f9e:	00 
     f9f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     fa6:	00 
     fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
     fab:	8b 45 08             	mov    0x8(%ebp),%eax
     fae:	89 04 24             	mov    %eax,(%esp)
     fb1:	e8 7a fe ff ff       	call   e30 <printint>
        ap++;
     fb6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     fba:	e9 b4 00 00 00       	jmp    1073 <printf+0x194>
      } else if(c == 's'){
     fbf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     fc3:	75 46                	jne    100b <printf+0x12c>
        s = (char*)*ap;
     fc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fc8:	8b 00                	mov    (%eax),%eax
     fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     fcd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     fd5:	75 27                	jne    ffe <printf+0x11f>
          s = "(null)";
     fd7:	c7 45 f4 00 19 00 00 	movl   $0x1900,-0xc(%ebp)
        while(*s != 0){
     fde:	eb 1e                	jmp    ffe <printf+0x11f>
          putc(fd, *s);
     fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fe3:	0f b6 00             	movzbl (%eax),%eax
     fe6:	0f be c0             	movsbl %al,%eax
     fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
     fed:	8b 45 08             	mov    0x8(%ebp),%eax
     ff0:	89 04 24             	mov    %eax,(%esp)
     ff3:	e8 10 fe ff ff       	call   e08 <putc>
          s++;
     ff8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     ffc:	eb 01                	jmp    fff <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     ffe:	90                   	nop
     fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1002:	0f b6 00             	movzbl (%eax),%eax
    1005:	84 c0                	test   %al,%al
    1007:	75 d7                	jne    fe0 <printf+0x101>
    1009:	eb 68                	jmp    1073 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    100b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    100f:	75 1d                	jne    102e <printf+0x14f>
        putc(fd, *ap);
    1011:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1014:	8b 00                	mov    (%eax),%eax
    1016:	0f be c0             	movsbl %al,%eax
    1019:	89 44 24 04          	mov    %eax,0x4(%esp)
    101d:	8b 45 08             	mov    0x8(%ebp),%eax
    1020:	89 04 24             	mov    %eax,(%esp)
    1023:	e8 e0 fd ff ff       	call   e08 <putc>
        ap++;
    1028:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    102c:	eb 45                	jmp    1073 <printf+0x194>
      } else if(c == '%'){
    102e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1032:	75 17                	jne    104b <printf+0x16c>
        putc(fd, c);
    1034:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1037:	0f be c0             	movsbl %al,%eax
    103a:	89 44 24 04          	mov    %eax,0x4(%esp)
    103e:	8b 45 08             	mov    0x8(%ebp),%eax
    1041:	89 04 24             	mov    %eax,(%esp)
    1044:	e8 bf fd ff ff       	call   e08 <putc>
    1049:	eb 28                	jmp    1073 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    104b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1052:	00 
    1053:	8b 45 08             	mov    0x8(%ebp),%eax
    1056:	89 04 24             	mov    %eax,(%esp)
    1059:	e8 aa fd ff ff       	call   e08 <putc>
        putc(fd, c);
    105e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1061:	0f be c0             	movsbl %al,%eax
    1064:	89 44 24 04          	mov    %eax,0x4(%esp)
    1068:	8b 45 08             	mov    0x8(%ebp),%eax
    106b:	89 04 24             	mov    %eax,(%esp)
    106e:	e8 95 fd ff ff       	call   e08 <putc>
      }
      state = 0;
    1073:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    107a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    107e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1081:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1084:	01 d0                	add    %edx,%eax
    1086:	0f b6 00             	movzbl (%eax),%eax
    1089:	84 c0                	test   %al,%al
    108b:	0f 85 70 fe ff ff    	jne    f01 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1091:	c9                   	leave  
    1092:	c3                   	ret    
    1093:	90                   	nop

00001094 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1094:	55                   	push   %ebp
    1095:	89 e5                	mov    %esp,%ebp
    1097:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    109a:	8b 45 08             	mov    0x8(%ebp),%eax
    109d:	83 e8 08             	sub    $0x8,%eax
    10a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10a3:	a1 b4 1e 00 00       	mov    0x1eb4,%eax
    10a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    10ab:	eb 24                	jmp    10d1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10b0:	8b 00                	mov    (%eax),%eax
    10b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10b5:	77 12                	ja     10c9 <free+0x35>
    10b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10bd:	77 24                	ja     10e3 <free+0x4f>
    10bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10c2:	8b 00                	mov    (%eax),%eax
    10c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    10c7:	77 1a                	ja     10e3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10cc:	8b 00                	mov    (%eax),%eax
    10ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
    10d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10d7:	76 d4                	jbe    10ad <free+0x19>
    10d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10dc:	8b 00                	mov    (%eax),%eax
    10de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    10e1:	76 ca                	jbe    10ad <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    10e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10e6:	8b 40 04             	mov    0x4(%eax),%eax
    10e9:	c1 e0 03             	shl    $0x3,%eax
    10ec:	89 c2                	mov    %eax,%edx
    10ee:	03 55 f8             	add    -0x8(%ebp),%edx
    10f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10f4:	8b 00                	mov    (%eax),%eax
    10f6:	39 c2                	cmp    %eax,%edx
    10f8:	75 24                	jne    111e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    10fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10fd:	8b 50 04             	mov    0x4(%eax),%edx
    1100:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1103:	8b 00                	mov    (%eax),%eax
    1105:	8b 40 04             	mov    0x4(%eax),%eax
    1108:	01 c2                	add    %eax,%edx
    110a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    110d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1110:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1113:	8b 00                	mov    (%eax),%eax
    1115:	8b 10                	mov    (%eax),%edx
    1117:	8b 45 f8             	mov    -0x8(%ebp),%eax
    111a:	89 10                	mov    %edx,(%eax)
    111c:	eb 0a                	jmp    1128 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    111e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1121:	8b 10                	mov    (%eax),%edx
    1123:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1126:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1128:	8b 45 fc             	mov    -0x4(%ebp),%eax
    112b:	8b 40 04             	mov    0x4(%eax),%eax
    112e:	c1 e0 03             	shl    $0x3,%eax
    1131:	03 45 fc             	add    -0x4(%ebp),%eax
    1134:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1137:	75 20                	jne    1159 <free+0xc5>
    p->s.size += bp->s.size;
    1139:	8b 45 fc             	mov    -0x4(%ebp),%eax
    113c:	8b 50 04             	mov    0x4(%eax),%edx
    113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1142:	8b 40 04             	mov    0x4(%eax),%eax
    1145:	01 c2                	add    %eax,%edx
    1147:	8b 45 fc             	mov    -0x4(%ebp),%eax
    114a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    114d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1150:	8b 10                	mov    (%eax),%edx
    1152:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1155:	89 10                	mov    %edx,(%eax)
    1157:	eb 08                	jmp    1161 <free+0xcd>
  } else
    p->s.ptr = bp;
    1159:	8b 45 fc             	mov    -0x4(%ebp),%eax
    115c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    115f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1161:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1164:	a3 b4 1e 00 00       	mov    %eax,0x1eb4
}
    1169:	c9                   	leave  
    116a:	c3                   	ret    

0000116b <morecore>:

static Header*
morecore(uint nu)
{
    116b:	55                   	push   %ebp
    116c:	89 e5                	mov    %esp,%ebp
    116e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1171:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1178:	77 07                	ja     1181 <morecore+0x16>
    nu = 4096;
    117a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1181:	8b 45 08             	mov    0x8(%ebp),%eax
    1184:	c1 e0 03             	shl    $0x3,%eax
    1187:	89 04 24             	mov    %eax,(%esp)
    118a:	e8 21 fc ff ff       	call   db0 <sbrk>
    118f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1192:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1196:	75 07                	jne    119f <morecore+0x34>
    return 0;
    1198:	b8 00 00 00 00       	mov    $0x0,%eax
    119d:	eb 22                	jmp    11c1 <morecore+0x56>
  hp = (Header*)p;
    119f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    11a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11a8:	8b 55 08             	mov    0x8(%ebp),%edx
    11ab:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    11ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11b1:	83 c0 08             	add    $0x8,%eax
    11b4:	89 04 24             	mov    %eax,(%esp)
    11b7:	e8 d8 fe ff ff       	call   1094 <free>
  return freep;
    11bc:	a1 b4 1e 00 00       	mov    0x1eb4,%eax
}
    11c1:	c9                   	leave  
    11c2:	c3                   	ret    

000011c3 <malloc>:

void*
malloc(uint nbytes)
{
    11c3:	55                   	push   %ebp
    11c4:	89 e5                	mov    %esp,%ebp
    11c6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11c9:	8b 45 08             	mov    0x8(%ebp),%eax
    11cc:	83 c0 07             	add    $0x7,%eax
    11cf:	c1 e8 03             	shr    $0x3,%eax
    11d2:	83 c0 01             	add    $0x1,%eax
    11d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    11d8:	a1 b4 1e 00 00       	mov    0x1eb4,%eax
    11dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    11e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11e4:	75 23                	jne    1209 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    11e6:	c7 45 f0 ac 1e 00 00 	movl   $0x1eac,-0x10(%ebp)
    11ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11f0:	a3 b4 1e 00 00       	mov    %eax,0x1eb4
    11f5:	a1 b4 1e 00 00       	mov    0x1eb4,%eax
    11fa:	a3 ac 1e 00 00       	mov    %eax,0x1eac
    base.s.size = 0;
    11ff:	c7 05 b0 1e 00 00 00 	movl   $0x0,0x1eb0
    1206:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1209:	8b 45 f0             	mov    -0x10(%ebp),%eax
    120c:	8b 00                	mov    (%eax),%eax
    120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1211:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1214:	8b 40 04             	mov    0x4(%eax),%eax
    1217:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    121a:	72 4d                	jb     1269 <malloc+0xa6>
      if(p->s.size == nunits)
    121c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    121f:	8b 40 04             	mov    0x4(%eax),%eax
    1222:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1225:	75 0c                	jne    1233 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1227:	8b 45 f4             	mov    -0xc(%ebp),%eax
    122a:	8b 10                	mov    (%eax),%edx
    122c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    122f:	89 10                	mov    %edx,(%eax)
    1231:	eb 26                	jmp    1259 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1233:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1236:	8b 40 04             	mov    0x4(%eax),%eax
    1239:	89 c2                	mov    %eax,%edx
    123b:	2b 55 ec             	sub    -0x14(%ebp),%edx
    123e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1241:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1244:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1247:	8b 40 04             	mov    0x4(%eax),%eax
    124a:	c1 e0 03             	shl    $0x3,%eax
    124d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1250:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1253:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1256:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1259:	8b 45 f0             	mov    -0x10(%ebp),%eax
    125c:	a3 b4 1e 00 00       	mov    %eax,0x1eb4
      return (void*)(p + 1);
    1261:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1264:	83 c0 08             	add    $0x8,%eax
    1267:	eb 38                	jmp    12a1 <malloc+0xde>
    }
    if(p == freep)
    1269:	a1 b4 1e 00 00       	mov    0x1eb4,%eax
    126e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1271:	75 1b                	jne    128e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1273:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1276:	89 04 24             	mov    %eax,(%esp)
    1279:	e8 ed fe ff ff       	call   116b <morecore>
    127e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1285:	75 07                	jne    128e <malloc+0xcb>
        return 0;
    1287:	b8 00 00 00 00       	mov    $0x0,%eax
    128c:	eb 13                	jmp    12a1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    128e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1291:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1294:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1297:	8b 00                	mov    (%eax),%eax
    1299:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    129c:	e9 70 ff ff ff       	jmp    1211 <malloc+0x4e>
}
    12a1:	c9                   	leave  
    12a2:	c3                   	ret    
    12a3:	90                   	nop

000012a4 <semaphore_create>:
#include "semaphore.h"
#include "types.h"
#include "user.h"


struct semaphore* semaphore_create(int initial_semaphore_value){
    12a4:	55                   	push   %ebp
    12a5:	89 e5                	mov    %esp,%ebp
    12a7:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* sem=malloc(sizeof(struct semaphore)); 
    12aa:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    12b1:	e8 0d ff ff ff       	call   11c3 <malloc>
    12b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // acquire semaphors
  sem->s1 = binary_semaphore_create(1);
    12b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c0:	e8 2b fb ff ff       	call   df0 <binary_semaphore_create>
    12c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12c8:	89 02                	mov    %eax,(%edx)
  
  // s2 should be initialized with the min{1,initial_semaphore_value}
  if(initial_semaphore_value >= 1){
    12ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12ce:	7e 14                	jle    12e4 <semaphore_create+0x40>
    sem->s2 = binary_semaphore_create(1);
    12d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12d7:	e8 14 fb ff ff       	call   df0 <binary_semaphore_create>
    12dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12df:	89 42 04             	mov    %eax,0x4(%edx)
    12e2:	eb 11                	jmp    12f5 <semaphore_create+0x51>
  }else{
    sem->s2 = binary_semaphore_create(initial_semaphore_value);
    12e4:	8b 45 08             	mov    0x8(%ebp),%eax
    12e7:	89 04 24             	mov    %eax,(%esp)
    12ea:	e8 01 fb ff ff       	call   df0 <binary_semaphore_create>
    12ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12f2:	89 42 04             	mov    %eax,0x4(%edx)
  }
  if(sem->s1 == -1 || sem->s2 == -1){
    12f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f8:	8b 00                	mov    (%eax),%eax
    12fa:	83 f8 ff             	cmp    $0xffffffff,%eax
    12fd:	74 0b                	je     130a <semaphore_create+0x66>
    12ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1302:	8b 40 04             	mov    0x4(%eax),%eax
    1305:	83 f8 ff             	cmp    $0xffffffff,%eax
    1308:	75 2d                	jne    1337 <semaphore_create+0x93>
     printf(1,"we had a probalem initialize in semaphore_create\n");
    130a:	c7 44 24 04 08 19 00 	movl   $0x1908,0x4(%esp)
    1311:	00 
    1312:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1319:	e8 c1 fb ff ff       	call   edf <printf>
     free(sem);
    131e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1321:	89 04 24             	mov    %eax,(%esp)
    1324:	e8 6b fd ff ff       	call   1094 <free>
     sem =0;
    1329:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     return 0;
    1330:	b8 00 00 00 00       	mov    $0x0,%eax
    1335:	eb 0c                	jmp    1343 <semaphore_create+0x9f>
  }
  //initialize value
  sem->value = initial_semaphore_value;//dynamic
    1337:	8b 45 f4             	mov    -0xc(%ebp),%eax
    133a:	8b 55 08             	mov    0x8(%ebp),%edx
    133d:	89 50 08             	mov    %edx,0x8(%eax)
  //sem->initial_value = initial_semaphore_value;//static
  
  return sem;
    1340:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1343:	c9                   	leave  
    1344:	c3                   	ret    

00001345 <semaphore_down>:
void semaphore_down(struct semaphore* sem ){
    1345:	55                   	push   %ebp
    1346:	89 e5                	mov    %esp,%ebp
    1348:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s2);
    134b:	8b 45 08             	mov    0x8(%ebp),%eax
    134e:	8b 40 04             	mov    0x4(%eax),%eax
    1351:	89 04 24             	mov    %eax,(%esp)
    1354:	e8 9f fa ff ff       	call   df8 <binary_semaphore_down>
  binary_semaphore_down(sem->s1);
    1359:	8b 45 08             	mov    0x8(%ebp),%eax
    135c:	8b 00                	mov    (%eax),%eax
    135e:	89 04 24             	mov    %eax,(%esp)
    1361:	e8 92 fa ff ff       	call   df8 <binary_semaphore_down>
  sem->value--;	
    1366:	8b 45 08             	mov    0x8(%ebp),%eax
    1369:	8b 40 08             	mov    0x8(%eax),%eax
    136c:	8d 50 ff             	lea    -0x1(%eax),%edx
    136f:	8b 45 08             	mov    0x8(%ebp),%eax
    1372:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value > 0){
    1375:	8b 45 08             	mov    0x8(%ebp),%eax
    1378:	8b 40 08             	mov    0x8(%eax),%eax
    137b:	85 c0                	test   %eax,%eax
    137d:	7e 0e                	jle    138d <semaphore_down+0x48>
   binary_semaphore_up(sem->s2);
    137f:	8b 45 08             	mov    0x8(%ebp),%eax
    1382:	8b 40 04             	mov    0x4(%eax),%eax
    1385:	89 04 24             	mov    %eax,(%esp)
    1388:	e8 73 fa ff ff       	call   e00 <binary_semaphore_up>
  }
  binary_semaphore_up(sem->s1); 
    138d:	8b 45 08             	mov    0x8(%ebp),%eax
    1390:	8b 00                	mov    (%eax),%eax
    1392:	89 04 24             	mov    %eax,(%esp)
    1395:	e8 66 fa ff ff       	call   e00 <binary_semaphore_up>
}
    139a:	c9                   	leave  
    139b:	c3                   	ret    

0000139c <semaphore_up>:
void semaphore_up(struct semaphore* sem ){
    139c:	55                   	push   %ebp
    139d:	89 e5                	mov    %esp,%ebp
    139f:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
    13a2:	8b 45 08             	mov    0x8(%ebp),%eax
    13a5:	8b 00                	mov    (%eax),%eax
    13a7:	89 04 24             	mov    %eax,(%esp)
    13aa:	e8 49 fa ff ff       	call   df8 <binary_semaphore_down>
  sem->value++;	
    13af:	8b 45 08             	mov    0x8(%ebp),%eax
    13b2:	8b 40 08             	mov    0x8(%eax),%eax
    13b5:	8d 50 01             	lea    0x1(%eax),%edx
    13b8:	8b 45 08             	mov    0x8(%ebp),%eax
    13bb:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value ==1){
    13be:	8b 45 08             	mov    0x8(%ebp),%eax
    13c1:	8b 40 08             	mov    0x8(%eax),%eax
    13c4:	83 f8 01             	cmp    $0x1,%eax
    13c7:	75 0e                	jne    13d7 <semaphore_up+0x3b>
   binary_semaphore_up(sem->s2); 
    13c9:	8b 45 08             	mov    0x8(%ebp),%eax
    13cc:	8b 40 04             	mov    0x4(%eax),%eax
    13cf:	89 04 24             	mov    %eax,(%esp)
    13d2:	e8 29 fa ff ff       	call   e00 <binary_semaphore_up>
   }
  binary_semaphore_up(sem->s1);
    13d7:	8b 45 08             	mov    0x8(%ebp),%eax
    13da:	8b 00                	mov    (%eax),%eax
    13dc:	89 04 24             	mov    %eax,(%esp)
    13df:	e8 1c fa ff ff       	call   e00 <binary_semaphore_up>
}
    13e4:	c9                   	leave  
    13e5:	c3                   	ret    

000013e6 <semaphore_free>:

void semaphore_free(struct semaphore* sem){
    13e6:	55                   	push   %ebp
    13e7:	89 e5                	mov    %esp,%ebp
    13e9:	83 ec 18             	sub    $0x18,%esp
  free(sem);
    13ec:	8b 45 08             	mov    0x8(%ebp),%eax
    13ef:	89 04 24             	mov    %eax,(%esp)
    13f2:	e8 9d fc ff ff       	call   1094 <free>
}
    13f7:	c9                   	leave  
    13f8:	c3                   	ret    
    13f9:	90                   	nop
    13fa:	90                   	nop
    13fb:	90                   	nop

000013fc <BB_create>:
#include "types.h"
#include "user.h"


struct BB* 
BB_create(int max_capacity){
    13fc:	55                   	push   %ebp
    13fd:	89 e5                	mov    %esp,%ebp
    13ff:	83 ec 38             	sub    $0x38,%esp
  //initialize
  struct BB* buf = malloc(sizeof(struct BB));
    1402:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
    1409:	e8 b5 fd ff ff       	call   11c3 <malloc>
    140e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
    1411:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    1418:	00 
    1419:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1420:	00 
    1421:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1424:	89 04 24             	mov    %eax,(%esp)
    1427:	e8 57 f7 ff ff       	call   b83 <memset>
 
  buf->buffer_size = max_capacity;
    142c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142f:	8b 55 08             	mov    0x8(%ebp),%edx
    1432:	89 10                	mov    %edx,(%eax)
  buf->mutex = binary_semaphore_create(1);  
    1434:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    143b:	e8 b0 f9 ff ff       	call   df0 <binary_semaphore_create>
    1440:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1443:	89 42 04             	mov    %eax,0x4(%edx)
  buf->empty = semaphore_create(max_capacity);
    1446:	8b 45 08             	mov    0x8(%ebp),%eax
    1449:	89 04 24             	mov    %eax,(%esp)
    144c:	e8 53 fe ff ff       	call   12a4 <semaphore_create>
    1451:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1454:	89 42 08             	mov    %eax,0x8(%edx)
  buf->full = semaphore_create(0);
    1457:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    145e:	e8 41 fe ff ff       	call   12a4 <semaphore_create>
    1463:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1466:	89 42 0c             	mov    %eax,0xc(%edx)
  
  //void** elements_array = (void**)malloc(sizeof(void*) * max_capacity); 
  //memset(buf->elements_array,0,sizeof(void*)*max_capacity);
  //buf->pointer_to_elements = elements_array;  
  
  buf->pointer_to_elements = malloc(sizeof(void*)*max_capacity);
    1469:	8b 45 08             	mov    0x8(%ebp),%eax
    146c:	c1 e0 02             	shl    $0x2,%eax
    146f:	89 04 24             	mov    %eax,(%esp)
    1472:	e8 4c fd ff ff       	call   11c3 <malloc>
    1477:	8b 55 f4             	mov    -0xc(%ebp),%edx
    147a:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->pointer_to_elements,0,sizeof(void*)*max_capacity);
    147d:	8b 45 08             	mov    0x8(%ebp),%eax
    1480:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1487:	8b 45 f4             	mov    -0xc(%ebp),%eax
    148a:	8b 40 1c             	mov    0x1c(%eax),%eax
    148d:	89 54 24 08          	mov    %edx,0x8(%esp)
    1491:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1498:	00 
    1499:	89 04 24             	mov    %eax,(%esp)
    149c:	e8 e2 f6 ff ff       	call   b83 <memset>
  
  buf->count = 0;
    14a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a4:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  //check the semaphorses
  if(buf->mutex == -1 || buf->empty == 0 || buf->full == 0){
    14ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ae:	8b 40 04             	mov    0x4(%eax),%eax
    14b1:	83 f8 ff             	cmp    $0xffffffff,%eax
    14b4:	74 14                	je     14ca <BB_create+0xce>
    14b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b9:	8b 40 08             	mov    0x8(%eax),%eax
    14bc:	85 c0                	test   %eax,%eax
    14be:	74 0a                	je     14ca <BB_create+0xce>
    14c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c3:	8b 40 0c             	mov    0xc(%eax),%eax
    14c6:	85 c0                	test   %eax,%eax
    14c8:	75 52                	jne    151c <BB_create+0x120>
   printf(1,"we had a problam getting semaphores at BB create mutex %d empty %d full %d\n",buf->mutex,buf->empty,buf->full);
    14ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14cd:	8b 48 0c             	mov    0xc(%eax),%ecx
    14d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d3:	8b 50 08             	mov    0x8(%eax),%edx
    14d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d9:	8b 40 04             	mov    0x4(%eax),%eax
    14dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    14e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
    14e4:	89 44 24 08          	mov    %eax,0x8(%esp)
    14e8:	c7 44 24 04 3c 19 00 	movl   $0x193c,0x4(%esp)
    14ef:	00 
    14f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14f7:	e8 e3 f9 ff ff       	call   edf <printf>
   free(buf->pointer_to_elements);
    14fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ff:	8b 40 1c             	mov    0x1c(%eax),%eax
    1502:	89 04 24             	mov    %eax,(%esp)
    1505:	e8 8a fb ff ff       	call   1094 <free>
   free(buf);
    150a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    150d:	89 04 24             	mov    %eax,(%esp)
    1510:	e8 7f fb ff ff       	call   1094 <free>
   buf =0;  
    1515:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  }
  return buf;
    151c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    151f:	c9                   	leave  
    1520:	c3                   	ret    

00001521 <BB_put>:

void BB_put(struct BB* bb, void* element)
{ 
    1521:	55                   	push   %ebp
    1522:	89 e5                	mov    %esp,%ebp
    1524:	83 ec 18             	sub    $0x18,%esp
  bb->pointer_to_elements[bb->count] = element;
  bb->count++;
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->full);
  */
  semaphore_down(bb->empty);
    1527:	8b 45 08             	mov    0x8(%ebp),%eax
    152a:	8b 40 08             	mov    0x8(%eax),%eax
    152d:	89 04 24             	mov    %eax,(%esp)
    1530:	e8 10 fe ff ff       	call   1345 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    1535:	8b 45 08             	mov    0x8(%ebp),%eax
    1538:	8b 40 04             	mov    0x4(%eax),%eax
    153b:	89 04 24             	mov    %eax,(%esp)
    153e:	e8 b5 f8 ff ff       	call   df8 <binary_semaphore_down>
   //insert item
  bb->pointer_to_elements[bb->end] = element;
    1543:	8b 45 08             	mov    0x8(%ebp),%eax
    1546:	8b 50 1c             	mov    0x1c(%eax),%edx
    1549:	8b 45 08             	mov    0x8(%ebp),%eax
    154c:	8b 40 18             	mov    0x18(%eax),%eax
    154f:	c1 e0 02             	shl    $0x2,%eax
    1552:	01 c2                	add    %eax,%edx
    1554:	8b 45 0c             	mov    0xc(%ebp),%eax
    1557:	89 02                	mov    %eax,(%edx)
  ++bb->end;
    1559:	8b 45 08             	mov    0x8(%ebp),%eax
    155c:	8b 40 18             	mov    0x18(%eax),%eax
    155f:	8d 50 01             	lea    0x1(%eax),%edx
    1562:	8b 45 08             	mov    0x8(%ebp),%eax
    1565:	89 50 18             	mov    %edx,0x18(%eax)
  bb->end = bb->end%bb->buffer_size;
    1568:	8b 45 08             	mov    0x8(%ebp),%eax
    156b:	8b 40 18             	mov    0x18(%eax),%eax
    156e:	8b 55 08             	mov    0x8(%ebp),%edx
    1571:	8b 0a                	mov    (%edx),%ecx
    1573:	89 c2                	mov    %eax,%edx
    1575:	c1 fa 1f             	sar    $0x1f,%edx
    1578:	f7 f9                	idiv   %ecx
    157a:	8b 45 08             	mov    0x8(%ebp),%eax
    157d:	89 50 18             	mov    %edx,0x18(%eax)
  binary_semaphore_up(bb->mutex);
    1580:	8b 45 08             	mov    0x8(%ebp),%eax
    1583:	8b 40 04             	mov    0x4(%eax),%eax
    1586:	89 04 24             	mov    %eax,(%esp)
    1589:	e8 72 f8 ff ff       	call   e00 <binary_semaphore_up>
  semaphore_up(bb->full);
    158e:	8b 45 08             	mov    0x8(%ebp),%eax
    1591:	8b 40 0c             	mov    0xc(%eax),%eax
    1594:	89 04 24             	mov    %eax,(%esp)
    1597:	e8 00 fe ff ff       	call   139c <semaphore_up>
    
}
    159c:	c9                   	leave  
    159d:	c3                   	ret    

0000159e <BB_pop>:

void* BB_pop(struct BB* bb)
{
    159e:	55                   	push   %ebp
    159f:	89 e5                	mov    %esp,%ebp
    15a1:	83 ec 28             	sub    $0x28,%esp
  
  void* element_to_pop;
  semaphore_down(bb->full);
    15a4:	8b 45 08             	mov    0x8(%ebp),%eax
    15a7:	8b 40 0c             	mov    0xc(%eax),%eax
    15aa:	89 04 24             	mov    %eax,(%esp)
    15ad:	e8 93 fd ff ff       	call   1345 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    15b2:	8b 45 08             	mov    0x8(%ebp),%eax
    15b5:	8b 40 04             	mov    0x4(%eax),%eax
    15b8:	89 04 24             	mov    %eax,(%esp)
    15bb:	e8 38 f8 ff ff       	call   df8 <binary_semaphore_down>
  element_to_pop = bb-> pointer_to_elements[bb->start];
    15c0:	8b 45 08             	mov    0x8(%ebp),%eax
    15c3:	8b 50 1c             	mov    0x1c(%eax),%edx
    15c6:	8b 45 08             	mov    0x8(%ebp),%eax
    15c9:	8b 40 14             	mov    0x14(%eax),%eax
    15cc:	c1 e0 02             	shl    $0x2,%eax
    15cf:	01 d0                	add    %edx,%eax
    15d1:	8b 00                	mov    (%eax),%eax
    15d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->pointer_to_elements[bb->start] =0;
    15d6:	8b 45 08             	mov    0x8(%ebp),%eax
    15d9:	8b 50 1c             	mov    0x1c(%eax),%edx
    15dc:	8b 45 08             	mov    0x8(%ebp),%eax
    15df:	8b 40 14             	mov    0x14(%eax),%eax
    15e2:	c1 e0 02             	shl    $0x2,%eax
    15e5:	01 d0                	add    %edx,%eax
    15e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
    15ed:	8b 45 08             	mov    0x8(%ebp),%eax
    15f0:	8b 40 14             	mov    0x14(%eax),%eax
    15f3:	8d 50 01             	lea    0x1(%eax),%edx
    15f6:	8b 45 08             	mov    0x8(%ebp),%eax
    15f9:	89 50 14             	mov    %edx,0x14(%eax)
  bb->start = bb->start%bb->buffer_size;
    15fc:	8b 45 08             	mov    0x8(%ebp),%eax
    15ff:	8b 40 14             	mov    0x14(%eax),%eax
    1602:	8b 55 08             	mov    0x8(%ebp),%edx
    1605:	8b 0a                	mov    (%edx),%ecx
    1607:	89 c2                	mov    %eax,%edx
    1609:	c1 fa 1f             	sar    $0x1f,%edx
    160c:	f7 f9                	idiv   %ecx
    160e:	8b 45 08             	mov    0x8(%ebp),%eax
    1611:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
    1614:	8b 45 08             	mov    0x8(%ebp),%eax
    1617:	8b 40 04             	mov    0x4(%eax),%eax
    161a:	89 04 24             	mov    %eax,(%esp)
    161d:	e8 de f7 ff ff       	call   e00 <binary_semaphore_up>
  semaphore_up(bb->empty);
    1622:	8b 45 08             	mov    0x8(%ebp),%eax
    1625:	8b 40 08             	mov    0x8(%eax),%eax
    1628:	89 04 24             	mov    %eax,(%esp)
    162b:	e8 6c fd ff ff       	call   139c <semaphore_up>
  return element_to_pop;
    1630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->empty);
  
  return element_to_pop;*/
}
    1633:	c9                   	leave  
    1634:	c3                   	ret    

00001635 <BB_free>:

void BB_free(struct BB* bb){
    1635:	55                   	push   %ebp
    1636:	89 e5                	mov    %esp,%ebp
    1638:	83 ec 18             	sub    $0x18,%esp
  free(bb->pointer_to_elements);
    163b:	8b 45 08             	mov    0x8(%ebp),%eax
    163e:	8b 40 1c             	mov    0x1c(%eax),%eax
    1641:	89 04 24             	mov    %eax,(%esp)
    1644:	e8 4b fa ff ff       	call   1094 <free>
  free(bb);
    1649:	8b 45 08             	mov    0x8(%ebp),%eax
    164c:	89 04 24             	mov    %eax,(%esp)
    164f:	e8 40 fa ff ff       	call   1094 <free>
    1654:	c9                   	leave  
    1655:	c3                   	ret    
