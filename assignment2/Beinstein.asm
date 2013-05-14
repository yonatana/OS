
_Beinstein:     file format elf32-i386


Disassembly of section .text:

00000000 <enter_bar>:
int general_mutex;

// Used to allow students to enter the bar, and thus is
// called by the students. If the bar is full (the semaphore’s value is 0), 
// the student should wait until another student leaves the bar and frees up space. 
void enter_bar(){
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  semaphore_down(bouncer);
       6:	a1 60 1e 00 00       	mov    0x1e60,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 ec 13 00 00       	call   13ff <semaphore_down>
}
      13:	c9                   	leave  
      14:	c3                   	ret    

00000015 <leave_bar>:

// Used to allow students to leave the bar once they are drunk, 
// and thus is called by the students. 
// When a student leaves the bar, he frees up a place for another student to enter.
void leave_bar(){
      15:	55                   	push   %ebp
      16:	89 e5                	mov    %esp,%ebp
      18:	83 ec 18             	sub    $0x18,%esp
  semaphore_up(bouncer);
      1b:	a1 60 1e 00 00       	mov    0x1e60,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 2e 14 00 00       	call   1456 <semaphore_up>
}
      28:	c9                   	leave  
      29:	c3                   	ret    

0000002a <place_action>:

// This function is called by a student whenever he wants to perform an action:
// place an order for a drink from the bar or return a dirty cup. 
// The action is placed at the end of the buffer.
void place_action(Action* action){
      2a:	55                   	push   %ebp
      2b:	89 e5                	mov    %esp,%ebp
      2d:	83 ec 18             	sub    $0x18,%esp
  BB_put(ABB,action);
      30:	a1 68 1e 00 00       	mov    0x1e68,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 95 15 00 00       	call   15d9 <BB_put>
}
      44:	c9                   	leave  
      45:	c3                   	ret    

00000046 <get_action>:

// This function is called by a bartender whenever one is free to deal with students’ actions. 
// The Action located at the beginning of the buffer is returned and removed. 
// If there are no actions, the bartender will wait until more actions arrive.
Action* get_action(){
      46:	55                   	push   %ebp
      47:	89 e5                	mov    %esp,%ebp
      49:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(ABB);
      4c:	a1 68 1e 00 00       	mov    0x1e68,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 fd 15 00 00       	call   1656 <BB_pop>
}
      59:	c9                   	leave  
      5a:	c3                   	ret    

0000005b <serve_drink>:

// This function is called by the bartender whenever he finishes to make a drink (ordered by a student). 
// The cup the drink is made in is placed in the DrinkBB.
void serve_drink(Cup* cup){
      5b:	55                   	push   %ebp
      5c:	89 e5                	mov    %esp,%ebp
      5e:	83 ec 18             	sub    $0x18,%esp
  BB_put(DrinkBB,cup);
      61:	a1 78 1e 00 00       	mov    0x1e78,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 64 15 00 00       	call   15d9 <BB_put>
} 
      75:	c9                   	leave  
      76:	c3                   	ret    

00000077 <get_drink>:

// This function is called by a student after he places an order for a drink, 
// while he waits for his order to be made. 
// If there is a drink ready in the buffer, he will take it (denoted by the cup the drink was made in). 
// If not, he will wait until a drink becomes available
Cup* get_drink(){
      77:	55                   	push   %ebp
      78:	89 e5                	mov    %esp,%ebp
      7a:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(DrinkBB);
      7d:	a1 78 1e 00 00       	mov    0x1e78,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 cc 15 00 00       	call   1656 <BB_pop>
}
      8a:	c9                   	leave  
      8b:	c3                   	ret    

0000008c <get_clean_cup>:

// This function is called by a bartender whenever he wishes to make a drink and needs a clean cup for it. 
// If there are no clean cups left, the bartender should wait until the cup boy returns with clean cups.
Cup* get_clean_cup(){
      8c:	55                   	push   %ebp
      8d:	89 e5                	mov    %esp,%ebp
      8f:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(CBB);
      92:	a1 94 1e 00 00       	mov    0x1e94,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 b7 15 00 00       	call   1656 <BB_pop>
}
      9f:	c9                   	leave  
      a0:	c3                   	ret    

000000a1 <add_clean_cup>:

// This function is called by the cup boy when he wishes to add a clean cup he just washed.
void add_clean_cup(Cup* cup){
      a1:	55                   	push   %ebp
      a2:	89 e5                	mov    %esp,%ebp
      a4:	83 ec 18             	sub    $0x18,%esp
  BB_put(CBB,cup);
      a7:	a1 94 1e 00 00       	mov    0x1e94,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 1e 15 00 00       	call   15d9 <BB_put>
}
      bb:	c9                   	leave  
      bc:	c3                   	ret    

000000bd <return_cup>:

// This function is called by a bartender whenever a student finished to drink his drink
// and wishes to return the cup used (i.e when the type of the action the bartender received from 
// ABB is 2 - returning a dirty cup). 
// If at least 60% of the cups are dirty, the cup boy will be notified.
void return_cup(Cup* cup){
      bd:	55                   	push   %ebp
      be:	89 e5                	mov    %esp,%ebp
      c0:	83 ec 18             	sub    $0x18,%esp
  BB_put(DBB,cup);
      c3:	a1 6c 1e 00 00       	mov    0x1e6c,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 02 15 00 00       	call   15d9 <BB_put>
}
      d7:	c9                   	leave  
      d8:	c3                   	ret    

000000d9 <wash_dirty>:

// This function will be called by the cup boy when he wishes to get a dirty cup to clean. 
Cup* wash_dirty(){
      d9:	55                   	push   %ebp
      da:	89 e5                	mov    %esp,%ebp
      dc:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(DBB);
      df:	a1 6c 1e 00 00       	mov    0x1e6c,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 6a 15 00 00       	call   1656 <BB_pop>
}
      ec:	c9                   	leave  
      ed:	c3                   	ret    

000000ee <student>:

// student simulation
void* student(){
      ee:	55                   	push   %ebp
      ef:	89 e5                	mov    %esp,%ebp
      f1:	56                   	push   %esi
      f2:	53                   	push   %ebx
      f3:	83 ec 30             	sub    $0x30,%esp
    void* ret_val = 0;
      f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    enter_bar();
      fd:	e8 fe fe ff ff       	call   0 <enter_bar>
    binary_semaphore_down(general_mutex);
     102:	a1 70 1e 00 00       	mov    0x1e70,%eax
     107:	89 04 24             	mov    %eax,(%esp)
     10a:	e8 a1 0d 00 00       	call   eb0 <binary_semaphore_down>
    int k = thread_getId();
     10f:	e8 74 0d 00 00       	call   e88 <thread_getId>
     114:	89 45 ec             	mov    %eax,-0x14(%ebp)
    binary_semaphore_up(general_mutex);
     117:	a1 70 1e 00 00       	mov    0x1e70,%eax
     11c:	89 04 24             	mov    %eax,(%esp)
     11f:	e8 94 0d 00 00       	call   eb8 <binary_semaphore_up>
    k = k % 5;
     124:	8b 4d ec             	mov    -0x14(%ebp),%ecx
     127:	ba 67 66 66 66       	mov    $0x66666667,%edx
     12c:	89 c8                	mov    %ecx,%eax
     12e:	f7 ea                	imul   %edx
     130:	d1 fa                	sar    %edx
     132:	89 c8                	mov    %ecx,%eax
     134:	c1 f8 1f             	sar    $0x1f,%eax
     137:	29 c2                	sub    %eax,%edx
     139:	89 d0                	mov    %edx,%eax
     13b:	c1 e0 02             	shl    $0x2,%eax
     13e:	01 d0                	add    %edx,%eax
     140:	89 ca                	mov    %ecx,%edx
     142:	29 c2                	sub    %eax,%edx
     144:	89 d0                	mov    %edx,%eax
     146:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int i;
    for(i = 0; i < k; i++){
     149:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     150:	e9 a9 00 00 00       	jmp    1fe <student+0x110>
	struct Action* student_action = (Action*)malloc(sizeof(Action));
     155:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     15c:	e8 1a 11 00 00       	call   127b <malloc>
     161:	89 45 e8             	mov    %eax,-0x18(%ebp)
	student_action->action_type = DRINK_ORDER;
     164:	8b 45 e8             	mov    -0x18(%ebp),%eax
     167:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	student_action->cup = 0;
     16d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     170:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	place_action(student_action);
     177:	8b 45 e8             	mov    -0x18(%ebp),%eax
     17a:	89 04 24             	mov    %eax,(%esp)
     17d:	e8 a8 fe ff ff       	call   2a <place_action>
	student_action->cup = get_drink();
     182:	e8 f0 fe ff ff       	call   77 <get_drink>
     187:	8b 55 e8             	mov    -0x18(%ebp),%edx
     18a:	89 42 04             	mov    %eax,0x4(%edx)
	//need to write to file intsead of screen TODO
	binary_semaphore_down(general_mutex);
     18d:	a1 70 1e 00 00       	mov    0x1e70,%eax
     192:	89 04 24             	mov    %eax,(%esp)
     195:	e8 16 0d 00 00       	call   eb0 <binary_semaphore_down>
	printf(1,"Student %d is having his %d drink, with cup %d\n",thread_getId(),i+1,student_action->cup->id);
     19a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     19d:	8b 40 04             	mov    0x4(%eax),%eax
     1a0:	8b 18                	mov    (%eax),%ebx
     1a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1a5:	8d 70 01             	lea    0x1(%eax),%esi
     1a8:	e8 db 0c 00 00       	call   e88 <thread_getId>
     1ad:	89 5c 24 10          	mov    %ebx,0x10(%esp)
     1b1:	89 74 24 0c          	mov    %esi,0xc(%esp)
     1b5:	89 44 24 08          	mov    %eax,0x8(%esp)
     1b9:	c7 44 24 04 10 17 00 	movl   $0x1710,0x4(%esp)
     1c0:	00 
     1c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1c8:	e8 ca 0d 00 00       	call   f97 <printf>
	binary_semaphore_up(general_mutex);
     1cd:	a1 70 1e 00 00       	mov    0x1e70,%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 de 0c 00 00       	call   eb8 <binary_semaphore_up>
	sleep(1);
     1da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1e1:	e8 8a 0c 00 00       	call   e70 <sleep>
	student_action->action_type = RETURN_CUP;
     1e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1e9:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
	place_action(student_action);
     1ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1f2:	89 04 24             	mov    %eax,(%esp)
     1f5:	e8 30 fe ff ff       	call   2a <place_action>
    binary_semaphore_down(general_mutex);
    int k = thread_getId();
    binary_semaphore_up(general_mutex);
    k = k % 5;
    int i;
    for(i = 0; i < k; i++){
     1fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     201:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     204:	0f 8c 4b ff ff ff    	jl     155 <student+0x67>
	sleep(1);
	student_action->action_type = RETURN_CUP;
	place_action(student_action);
    }
    //need to write to file intsead of screen TODO
    binary_semaphore_down(general_mutex);
     20a:	a1 70 1e 00 00       	mov    0x1e70,%eax
     20f:	89 04 24             	mov    %eax,(%esp)
     212:	e8 99 0c 00 00       	call   eb0 <binary_semaphore_down>
    printf(1,"Student %d is drunk, and trying to go home\n",thread_getId());
     217:	e8 6c 0c 00 00       	call   e88 <thread_getId>
     21c:	89 44 24 08          	mov    %eax,0x8(%esp)
     220:	c7 44 24 04 40 17 00 	movl   $0x1740,0x4(%esp)
     227:	00 
     228:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     22f:	e8 63 0d 00 00       	call   f97 <printf>
    binary_semaphore_up(general_mutex);
     234:	a1 70 1e 00 00       	mov    0x1e70,%eax
     239:	89 04 24             	mov    %eax,(%esp)
     23c:	e8 77 0c 00 00       	call   eb8 <binary_semaphore_up>
    leave_bar();
     241:	e8 cf fd ff ff       	call   15 <leave_bar>
    thread_exit(ret_val);
     246:	8b 45 f0             	mov    -0x10(%ebp),%eax
     249:	89 04 24             	mov    %eax,(%esp)
     24c:	e8 4f 0c 00 00       	call   ea0 <thread_exit>
    return 0;
     251:	b8 00 00 00 00       	mov    $0x0,%eax
}
     256:	83 c4 30             	add    $0x30,%esp
     259:	5b                   	pop    %ebx
     25a:	5e                   	pop    %esi
     25b:	5d                   	pop    %ebp
     25c:	c3                   	ret    

0000025d <bartender>:

//bartender simulation
void* bartender(){
     25d:	55                   	push   %ebp
     25e:	89 e5                	mov    %esp,%ebp
     260:	53                   	push   %ebx
     261:	83 ec 34             	sub    $0x34,%esp
    void* ret_val = 0;
     264:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
   
    struct Cup* current_cup = 0;
     26b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for(;;){
	struct Action* bartender_action = 0;
     272:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	binary_semaphore_down(general_mutex);
     279:	a1 70 1e 00 00       	mov    0x1e70,%eax
     27e:	89 04 24             	mov    %eax,(%esp)
     281:	e8 2a 0c 00 00       	call   eb0 <binary_semaphore_down>
	if(((DBB->count * 100) / DBB->buffer_size) >= 60){ //wakeup cup_boy
     286:	a1 6c 1e 00 00       	mov    0x1e6c,%eax
     28b:	8b 40 10             	mov    0x10(%eax),%eax
     28e:	6b c0 64             	imul   $0x64,%eax,%eax
     291:	8b 15 6c 1e 00 00    	mov    0x1e6c,%edx
     297:	8b 12                	mov    (%edx),%edx
     299:	89 55 e4             	mov    %edx,-0x1c(%ebp)
     29c:	89 c2                	mov    %eax,%edx
     29e:	c1 fa 1f             	sar    $0x1f,%edx
     2a1:	f7 7d e4             	idivl  -0x1c(%ebp)
     2a4:	83 f8 3b             	cmp    $0x3b,%eax
     2a7:	7e 0d                	jle    2b6 <bartender+0x59>
	  binary_semaphore_up(cup_boy_lock);
     2a9:	a1 90 1e 00 00       	mov    0x1e90,%eax
     2ae:	89 04 24             	mov    %eax,(%esp)
     2b1:	e8 02 0c 00 00       	call   eb8 <binary_semaphore_up>
	}
	binary_semaphore_up(general_mutex);
     2b6:	a1 70 1e 00 00       	mov    0x1e70,%eax
     2bb:	89 04 24             	mov    %eax,(%esp)
     2be:	e8 f5 0b 00 00       	call   eb8 <binary_semaphore_up>
	bartender_action = get_action();
     2c3:	e8 7e fd ff ff       	call   46 <get_action>
     2c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(bartender_action->action_type == DRINK_ORDER){
     2cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2ce:	8b 00                	mov    (%eax),%eax
     2d0:	83 f8 01             	cmp    $0x1,%eax
     2d3:	75 53                	jne    328 <bartender+0xcb>
	    current_cup = get_clean_cup();
     2d5:	e8 b2 fd ff ff       	call   8c <get_clean_cup>
     2da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    //need to write to file intsead of screen TODO
	    binary_semaphore_down(general_mutex);
     2dd:	a1 70 1e 00 00       	mov    0x1e70,%eax
     2e2:	89 04 24             	mov    %eax,(%esp)
     2e5:	e8 c6 0b 00 00       	call   eb0 <binary_semaphore_down>
	    printf(1,"Bartender %d is making drink with cup %d\n",thread_getId(),current_cup->id);
     2ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2ed:	8b 18                	mov    (%eax),%ebx
     2ef:	e8 94 0b 00 00       	call   e88 <thread_getId>
     2f4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     2f8:	89 44 24 08          	mov    %eax,0x8(%esp)
     2fc:	c7 44 24 04 6c 17 00 	movl   $0x176c,0x4(%esp)
     303:	00 
     304:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     30b:	e8 87 0c 00 00       	call   f97 <printf>
	    binary_semaphore_up(general_mutex);
     310:	a1 70 1e 00 00       	mov    0x1e70,%eax
     315:	89 04 24             	mov    %eax,(%esp)
     318:	e8 9b 0b 00 00       	call   eb8 <binary_semaphore_up>
	    serve_drink(current_cup);
     31d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     320:	89 04 24             	mov    %eax,(%esp)
     323:	e8 33 fd ff ff       	call   5b <serve_drink>
	}
	if(bartender_action->action_type == RETURN_CUP){
     328:	8b 45 ec             	mov    -0x14(%ebp),%eax
     32b:	8b 00                	mov    (%eax),%eax
     32d:	83 f8 02             	cmp    $0x2,%eax
     330:	75 4b                	jne    37d <bartender+0x120>
	    return_cup(current_cup);
     332:	8b 45 f4             	mov    -0xc(%ebp),%eax
     335:	89 04 24             	mov    %eax,(%esp)
     338:	e8 80 fd ff ff       	call   bd <return_cup>
	    //need to write to file intsead of screen TODO
	    binary_semaphore_down(general_mutex);
     33d:	a1 70 1e 00 00       	mov    0x1e70,%eax
     342:	89 04 24             	mov    %eax,(%esp)
     345:	e8 66 0b 00 00       	call   eb0 <binary_semaphore_down>
	    printf(1,"Bartender %d returned cup %d\n",thread_getId(),current_cup->id);
     34a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     34d:	8b 18                	mov    (%eax),%ebx
     34f:	e8 34 0b 00 00       	call   e88 <thread_getId>
     354:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     358:	89 44 24 08          	mov    %eax,0x8(%esp)
     35c:	c7 44 24 04 96 17 00 	movl   $0x1796,0x4(%esp)
     363:	00 
     364:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     36b:	e8 27 0c 00 00       	call   f97 <printf>
	    binary_semaphore_up(general_mutex);
     370:	a1 70 1e 00 00       	mov    0x1e70,%eax
     375:	89 04 24             	mov    %eax,(%esp)
     378:	e8 3b 0b 00 00       	call   eb8 <binary_semaphore_up>
	}
	if(bartender_action->action_type == GO_HOME){
     37d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     380:	8b 00                	mov    (%eax),%eax
     382:	83 f8 03             	cmp    $0x3,%eax
     385:	75 0b                	jne    392 <bartender+0x135>
	  thread_exit(ret_val);
     387:	8b 45 f0             	mov    -0x10(%ebp),%eax
     38a:	89 04 24             	mov    %eax,(%esp)
     38d:	e8 0e 0b 00 00       	call   ea0 <thread_exit>
	}
	bartender_action->action_type = UNDEFINED;
     392:	8b 45 ec             	mov    -0x14(%ebp),%eax
     395:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	bartender_action->cup = 0;
     39b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     39e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    }
     3a5:	e9 c8 fe ff ff       	jmp    272 <bartender+0x15>

000003aa <cup_boy>:
}


// Cup boy simulation
void* cup_boy(){
     3aa:	55                   	push   %ebp
     3ab:	89 e5                	mov    %esp,%ebp
     3ad:	83 ec 28             	sub    $0x28,%esp
  void* ret_val = 0;
     3b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  cup_boy_lock = binary_semaphore_create(0);
     3b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3be:	e8 e5 0a 00 00       	call   ea8 <binary_semaphore_create>
     3c3:	a3 90 1e 00 00       	mov    %eax,0x1e90
  for(;;){
    if(finished_shift){
     3c8:	a1 64 1e 00 00       	mov    0x1e64,%eax
     3cd:	85 c0                	test   %eax,%eax
     3cf:	74 0b                	je     3dc <cup_boy+0x32>
	thread_exit(ret_val);
     3d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3d4:	89 04 24             	mov    %eax,(%esp)
     3d7:	e8 c4 0a 00 00       	call   ea0 <thread_exit>
    }
    int n = DBB->count;
     3dc:	a1 6c 1e 00 00       	mov    0x1e6c,%eax
     3e1:	8b 40 10             	mov    0x10(%eax),%eax
     3e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int i;
    struct Cup* current_cup = 0;
     3e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    for(i = 0; i < n; i++){
     3ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3f5:	eb 5a                	jmp    451 <cup_boy+0xa7>
	current_cup = wash_dirty();
     3f7:	e8 dd fc ff ff       	call   d9 <wash_dirty>
     3fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sleep(1);
     3ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     406:	e8 65 0a 00 00       	call   e70 <sleep>
	add_clean_cup(current_cup);
     40b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     40e:	89 04 24             	mov    %eax,(%esp)
     411:	e8 8b fc ff ff       	call   a1 <add_clean_cup>
	//need to write to file intsead of screen TODO
	binary_semaphore_down(general_mutex);
     416:	a1 70 1e 00 00       	mov    0x1e70,%eax
     41b:	89 04 24             	mov    %eax,(%esp)
     41e:	e8 8d 0a 00 00       	call   eb0 <binary_semaphore_down>
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
     423:	8b 45 e8             	mov    -0x18(%ebp),%eax
     426:	8b 00                	mov    (%eax),%eax
     428:	89 44 24 08          	mov    %eax,0x8(%esp)
     42c:	c7 44 24 04 b4 17 00 	movl   $0x17b4,0x4(%esp)
     433:	00 
     434:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     43b:	e8 57 0b 00 00       	call   f97 <printf>
	binary_semaphore_up(general_mutex);
     440:	a1 70 1e 00 00       	mov    0x1e70,%eax
     445:	89 04 24             	mov    %eax,(%esp)
     448:	e8 6b 0a 00 00       	call   eb8 <binary_semaphore_up>
	thread_exit(ret_val);
    }
    int n = DBB->count;
    int i;
    struct Cup* current_cup = 0;
    for(i = 0; i < n; i++){
     44d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     451:	8b 45 f4             	mov    -0xc(%ebp),%eax
     454:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     457:	7c 9e                	jl     3f7 <cup_boy+0x4d>
	//need to write to file intsead of screen TODO
	binary_semaphore_down(general_mutex);
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
	binary_semaphore_up(general_mutex);
    }
   binary_semaphore_down(cup_boy_lock); 
     459:	a1 90 1e 00 00       	mov    0x1e90,%eax
     45e:	89 04 24             	mov    %eax,(%esp)
     461:	e8 4a 0a 00 00       	call   eb0 <binary_semaphore_down>
  }
     466:	e9 5d ff ff ff       	jmp    3c8 <cup_boy+0x1e>

0000046b <join_peoples>:
}

// thread_joins on students and bartenders
void join_peoples(int* tids,int num_of_peoples){
     46b:	55                   	push   %ebp
     46c:	89 e5                	mov    %esp,%ebp
     46e:	83 ec 28             	sub    $0x28,%esp
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     471:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     478:	eb 1e                	jmp    498 <join_peoples+0x2d>
      thread_join(tids[i],&ret_val);
     47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     47d:	c1 e0 02             	shl    $0x2,%eax
     480:	03 45 08             	add    0x8(%ebp),%eax
     483:	8b 00                	mov    (%eax),%eax
     485:	8d 55 f0             	lea    -0x10(%ebp),%edx
     488:	89 54 24 04          	mov    %edx,0x4(%esp)
     48c:	89 04 24             	mov    %eax,(%esp)
     48f:	e8 04 0a 00 00       	call   e98 <thread_join>

// thread_joins on students and bartenders
void join_peoples(int* tids,int num_of_peoples){
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     494:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     498:	8b 45 f4             	mov    -0xc(%ebp),%eax
     49b:	3b 45 0c             	cmp    0xc(%ebp),%eax
     49e:	7c da                	jl     47a <join_peoples+0xf>
      thread_join(tids[i],&ret_val);
  }
}
     4a0:	c9                   	leave  
     4a1:	c3                   	ret    

000004a2 <release_workers>:


//release the workers(bartenders + cup_boy) that run in infinite loops 
void release_workers(int num_of_bartenders){
     4a2:	55                   	push   %ebp
     4a3:	89 e5                	mov    %esp,%ebp
     4a5:	83 ec 28             	sub    $0x28,%esp
 int i;
 struct Action* release_bartender_action = 0;
     4a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 release_bartender_action->action_type = GO_HOME;
     4af:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4b2:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
 release_bartender_action->cup = 0;
     4b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 //release bartenders
 for(i = 0; i< num_of_bartenders; i++){
     4c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4c9:	eb 0f                	jmp    4da <release_workers+0x38>
    place_action(release_bartender_action);
     4cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4ce:	89 04 24             	mov    %eax,(%esp)
     4d1:	e8 54 fb ff ff       	call   2a <place_action>
 int i;
 struct Action* release_bartender_action = 0;
 release_bartender_action->action_type = GO_HOME;
 release_bartender_action->cup = 0;
 //release bartenders
 for(i = 0; i< num_of_bartenders; i++){
     4d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     4da:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4dd:	3b 45 08             	cmp    0x8(%ebp),%eax
     4e0:	7c e9                	jl     4cb <release_workers+0x29>
    place_action(release_bartender_action);
 }
 
 //release cup_boy
 binary_semaphore_up(cup_boy_lock);
     4e2:	a1 90 1e 00 00       	mov    0x1e90,%eax
     4e7:	89 04 24             	mov    %eax,(%esp)
     4ea:	e8 c9 09 00 00       	call   eb8 <binary_semaphore_up>
}
     4ef:	c9                   	leave  
     4f0:	c3                   	ret    

000004f1 <values_array_index>:


//return the index to put the value {A, B, C, S, M}
//				     {0, 1, 2, 3, 4}
int values_array_index(char* input_buf, int char_index){
     4f1:	55                   	push   %ebp
     4f2:	89 e5                	mov    %esp,%ebp
 if(input_buf[char_index] == 'A')
     4f4:	8b 45 0c             	mov    0xc(%ebp),%eax
     4f7:	03 45 08             	add    0x8(%ebp),%eax
     4fa:	0f b6 00             	movzbl (%eax),%eax
     4fd:	3c 41                	cmp    $0x41,%al
     4ff:	75 07                	jne    508 <values_array_index+0x17>
   return 0;
     501:	b8 00 00 00 00       	mov    $0x0,%eax
     506:	eb 55                	jmp    55d <values_array_index+0x6c>
 if(input_buf[char_index] == 'B')
     508:	8b 45 0c             	mov    0xc(%ebp),%eax
     50b:	03 45 08             	add    0x8(%ebp),%eax
     50e:	0f b6 00             	movzbl (%eax),%eax
     511:	3c 42                	cmp    $0x42,%al
     513:	75 07                	jne    51c <values_array_index+0x2b>
   return 1;
     515:	b8 01 00 00 00       	mov    $0x1,%eax
     51a:	eb 41                	jmp    55d <values_array_index+0x6c>
 if(input_buf[char_index] == 'C')
     51c:	8b 45 0c             	mov    0xc(%ebp),%eax
     51f:	03 45 08             	add    0x8(%ebp),%eax
     522:	0f b6 00             	movzbl (%eax),%eax
     525:	3c 43                	cmp    $0x43,%al
     527:	75 07                	jne    530 <values_array_index+0x3f>
   return 2;
     529:	b8 02 00 00 00       	mov    $0x2,%eax
     52e:	eb 2d                	jmp    55d <values_array_index+0x6c>
 if(input_buf[char_index] == 'S')
     530:	8b 45 0c             	mov    0xc(%ebp),%eax
     533:	03 45 08             	add    0x8(%ebp),%eax
     536:	0f b6 00             	movzbl (%eax),%eax
     539:	3c 53                	cmp    $0x53,%al
     53b:	75 07                	jne    544 <values_array_index+0x53>
   return 3;
     53d:	b8 03 00 00 00       	mov    $0x3,%eax
     542:	eb 19                	jmp    55d <values_array_index+0x6c>
 if(input_buf[char_index] == 'M')
     544:	8b 45 0c             	mov    0xc(%ebp),%eax
     547:	03 45 08             	add    0x8(%ebp),%eax
     54a:	0f b6 00             	movzbl (%eax),%eax
     54d:	3c 4d                	cmp    $0x4d,%al
     54f:	75 07                	jne    558 <values_array_index+0x67>
   return 4;
     551:	b8 04 00 00 00       	mov    $0x4,%eax
     556:	eb 05                	jmp    55d <values_array_index+0x6c>
 //error
 return -1;
     558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     55d:	5d                   	pop    %ebp
     55e:	c3                   	ret    

0000055f <parse_buffer>:

//parsing the configuration file
void parse_buffer(char* input_buf,int* values_array){
     55f:	55                   	push   %ebp
     560:	89 e5                	mov    %esp,%ebp
     562:	53                   	push   %ebx
     563:	83 ec 24             	sub    $0x24,%esp
 int i;
 int num_of_chars = strlen(input_buf);
     566:	8b 45 08             	mov    0x8(%ebp),%eax
     569:	89 04 24             	mov    %eax,(%esp)
     56c:	e8 a5 06 00 00       	call   c16 <strlen>
     571:	89 45 f0             	mov    %eax,-0x10(%ebp)
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     574:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     57b:	eb 7e                	jmp    5fb <parse_buffer+0x9c>
    if(input_buf[i] == 'A' || input_buf[i] == 'B' || input_buf[i] == 'C' || input_buf[i] == 'S' || input_buf[i] == 'M'){
     57d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     580:	03 45 08             	add    0x8(%ebp),%eax
     583:	0f b6 00             	movzbl (%eax),%eax
     586:	3c 41                	cmp    $0x41,%al
     588:	74 34                	je     5be <parse_buffer+0x5f>
     58a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     58d:	03 45 08             	add    0x8(%ebp),%eax
     590:	0f b6 00             	movzbl (%eax),%eax
     593:	3c 42                	cmp    $0x42,%al
     595:	74 27                	je     5be <parse_buffer+0x5f>
     597:	8b 45 f4             	mov    -0xc(%ebp),%eax
     59a:	03 45 08             	add    0x8(%ebp),%eax
     59d:	0f b6 00             	movzbl (%eax),%eax
     5a0:	3c 43                	cmp    $0x43,%al
     5a2:	74 1a                	je     5be <parse_buffer+0x5f>
     5a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a7:	03 45 08             	add    0x8(%ebp),%eax
     5aa:	0f b6 00             	movzbl (%eax),%eax
     5ad:	3c 53                	cmp    $0x53,%al
     5af:	74 0d                	je     5be <parse_buffer+0x5f>
     5b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5b4:	03 45 08             	add    0x8(%ebp),%eax
     5b7:	0f b6 00             	movzbl (%eax),%eax
     5ba:	3c 4d                	cmp    $0x4d,%al
     5bc:	75 39                	jne    5f7 <parse_buffer+0x98>
       index = values_array_index(input_buf,i);
     5be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5c1:	89 44 24 04          	mov    %eax,0x4(%esp)
     5c5:	8b 45 08             	mov    0x8(%ebp),%eax
     5c8:	89 04 24             	mov    %eax,(%esp)
     5cb:	e8 21 ff ff ff       	call   4f1 <values_array_index>
     5d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
       temp_str = &input_buf[i];
     5d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5d6:	03 45 08             	add    0x8(%ebp),%eax
     5d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
       values_array[index] = atoi(temp_str+4);
     5dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5df:	c1 e0 02             	shl    $0x2,%eax
     5e2:	89 c3                	mov    %eax,%ebx
     5e4:	03 5d 0c             	add    0xc(%ebp),%ebx
     5e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5ea:	83 c0 04             	add    $0x4,%eax
     5ed:	89 04 24             	mov    %eax,(%esp)
     5f0:	e8 5a 07 00 00       	call   d4f <atoi>
     5f5:	89 03                	mov    %eax,(%ebx)
void parse_buffer(char* input_buf,int* values_array){
 int i;
 int num_of_chars = strlen(input_buf);
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     5f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     5fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     601:	0f 8c 76 ff ff ff    	jl     57d <parse_buffer+0x1e>
       index = values_array_index(input_buf,i);
       temp_str = &input_buf[i];
       values_array[index] = atoi(temp_str+4);
    }
 }
}
     607:	83 c4 24             	add    $0x24,%esp
     60a:	5b                   	pop    %ebx
     60b:	5d                   	pop    %ebp
     60c:	c3                   	ret    

0000060d <main>:


int main(int argc, char** argv) {
     60d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     611:	83 e4 f0             	and    $0xfffffff0,%esp
     614:	ff 71 fc             	pushl  -0x4(%ecx)
     617:	55                   	push   %ebp
     618:	89 e5                	mov    %esp,%ebp
     61a:	51                   	push   %ecx
     61b:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  int M;	// maximum number of students that can be at the bar at once
  int fconf;
  int conf_size;
  struct stat bufstat;
  
  fconf = open("con.conf",O_RDONLY);
     621:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     628:	00 
     629:	c7 04 24 d0 17 00 00 	movl   $0x17d0,(%esp)
     630:	e8 eb 07 00 00       	call   e20 <open>
     635:	89 45 f0             	mov    %eax,-0x10(%ebp)
  fstat(fconf,&bufstat);
     638:	8d 45 8c             	lea    -0x74(%ebp),%eax
     63b:	89 44 24 04          	mov    %eax,0x4(%esp)
     63f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     642:	89 04 24             	mov    %eax,(%esp)
     645:	e8 ee 07 00 00       	call   e38 <fstat>
  conf_size = bufstat.size;
     64a:	8b 45 9c             	mov    -0x64(%ebp),%eax
     64d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  char bufconf[conf_size];
     650:	8b 45 ec             	mov    -0x14(%ebp),%eax
     653:	8d 50 ff             	lea    -0x1(%eax),%edx
     656:	89 55 e8             	mov    %edx,-0x18(%ebp)
     659:	8d 50 0f             	lea    0xf(%eax),%edx
     65c:	b8 10 00 00 00       	mov    $0x10,%eax
     661:	83 e8 01             	sub    $0x1,%eax
     664:	01 d0                	add    %edx,%eax
     666:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     66d:	00 00 00 
     670:	ba 00 00 00 00       	mov    $0x0,%edx
     675:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     67b:	6b c0 10             	imul   $0x10,%eax,%eax
     67e:	29 c4                	sub    %eax,%esp
     680:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     684:	83 c0 0f             	add    $0xf,%eax
     687:	c1 e8 04             	shr    $0x4,%eax
     68a:	c1 e0 04             	shl    $0x4,%eax
     68d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  read(fconf,bufconf,conf_size);
     690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     693:	8b 55 ec             	mov    -0x14(%ebp),%edx
     696:	89 54 24 08          	mov    %edx,0x8(%esp)
     69a:	89 44 24 04          	mov    %eax,0x4(%esp)
     69e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6a1:	89 04 24             	mov    %eax,(%esp)
     6a4:	e8 4f 07 00 00       	call   df8 <read>
  int inputs_parsed[5]; //{Aval, Bval, Cval, Sval, Mval}
  
  parse_buffer(bufconf, inputs_parsed);
     6a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6ac:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
     6b2:	89 54 24 04          	mov    %edx,0x4(%esp)
     6b6:	89 04 24             	mov    %eax,(%esp)
     6b9:	e8 a1 fe ff ff       	call   55f <parse_buffer>
  A = inputs_parsed[0];
     6be:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
     6c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  B = inputs_parsed[1];
     6c7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
     6cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  C = inputs_parsed[2];
     6d0:	8b 45 80             	mov    -0x80(%ebp),%eax
     6d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  S = inputs_parsed[3];
     6d6:	8b 45 84             	mov    -0x7c(%ebp),%eax
     6d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  M = inputs_parsed[4];
     6dc:	8b 45 88             	mov    -0x78(%ebp),%eax
     6df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  
  printf(1,"A: %d B: %d C: %d  S: %d M: %d\n",A,B,C,S,M);
     6e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
     6e5:	89 44 24 18          	mov    %eax,0x18(%esp)
     6e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     6ec:	89 44 24 14          	mov    %eax,0x14(%esp)
     6f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
     6f3:	89 44 24 10          	mov    %eax,0x10(%esp)
     6f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
     6fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
     6fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
     701:	89 44 24 08          	mov    %eax,0x8(%esp)
     705:	c7 44 24 04 dc 17 00 	movl   $0x17dc,0x4(%esp)
     70c:	00 
     70d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     714:	e8 7e 08 00 00       	call   f97 <printf>
  
  void* students_stacks[S];
     719:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     71c:	8d 50 ff             	lea    -0x1(%eax),%edx
     71f:	89 55 cc             	mov    %edx,-0x34(%ebp)
     722:	c1 e0 02             	shl    $0x2,%eax
     725:	8d 50 0f             	lea    0xf(%eax),%edx
     728:	b8 10 00 00 00       	mov    $0x10,%eax
     72d:	83 e8 01             	sub    $0x1,%eax
     730:	01 d0                	add    %edx,%eax
     732:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     739:	00 00 00 
     73c:	ba 00 00 00 00       	mov    $0x0,%edx
     741:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     747:	6b c0 10             	imul   $0x10,%eax,%eax
     74a:	29 c4                	sub    %eax,%esp
     74c:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     750:	83 c0 0f             	add    $0xf,%eax
     753:	c1 e8 04             	shr    $0x4,%eax
     756:	c1 e0 04             	shl    $0x4,%eax
     759:	89 45 c8             	mov    %eax,-0x38(%ebp)
  void* bartenders_stacks[B];
     75c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     75f:	8d 50 ff             	lea    -0x1(%eax),%edx
     762:	89 55 c4             	mov    %edx,-0x3c(%ebp)
     765:	c1 e0 02             	shl    $0x2,%eax
     768:	8d 50 0f             	lea    0xf(%eax),%edx
     76b:	b8 10 00 00 00       	mov    $0x10,%eax
     770:	83 e8 01             	sub    $0x1,%eax
     773:	01 d0                	add    %edx,%eax
     775:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     77c:	00 00 00 
     77f:	ba 00 00 00 00       	mov    $0x0,%edx
     784:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     78a:	6b c0 10             	imul   $0x10,%eax,%eax
     78d:	29 c4                	sub    %eax,%esp
     78f:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     793:	83 c0 0f             	add    $0xf,%eax
     796:	c1 e8 04             	shr    $0x4,%eax
     799:	c1 e0 04             	shl    $0x4,%eax
     79c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  void* cup_boy_stack;
  int i;
  int student_tids[S];
     79f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7a2:	8d 50 ff             	lea    -0x1(%eax),%edx
     7a5:	89 55 bc             	mov    %edx,-0x44(%ebp)
     7a8:	c1 e0 02             	shl    $0x2,%eax
     7ab:	8d 50 0f             	lea    0xf(%eax),%edx
     7ae:	b8 10 00 00 00       	mov    $0x10,%eax
     7b3:	83 e8 01             	sub    $0x1,%eax
     7b6:	01 d0                	add    %edx,%eax
     7b8:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     7bf:	00 00 00 
     7c2:	ba 00 00 00 00       	mov    $0x0,%edx
     7c7:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     7cd:	6b c0 10             	imul   $0x10,%eax,%eax
     7d0:	29 c4                	sub    %eax,%esp
     7d2:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     7d6:	83 c0 0f             	add    $0xf,%eax
     7d9:	c1 e8 04             	shr    $0x4,%eax
     7dc:	c1 e0 04             	shl    $0x4,%eax
     7df:	89 45 b8             	mov    %eax,-0x48(%ebp)
  int bartender_tids[B];
     7e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
     7e5:	8d 50 ff             	lea    -0x1(%eax),%edx
     7e8:	89 55 b4             	mov    %edx,-0x4c(%ebp)
     7eb:	c1 e0 02             	shl    $0x2,%eax
     7ee:	8d 50 0f             	lea    0xf(%eax),%edx
     7f1:	b8 10 00 00 00       	mov    $0x10,%eax
     7f6:	83 e8 01             	sub    $0x1,%eax
     7f9:	01 d0                	add    %edx,%eax
     7fb:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     802:	00 00 00 
     805:	ba 00 00 00 00       	mov    $0x0,%edx
     80a:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     810:	6b c0 10             	imul   $0x10,%eax,%eax
     813:	29 c4                	sub    %eax,%esp
     815:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     819:	83 c0 0f             	add    $0xf,%eax
     81c:	c1 e8 04             	shr    $0x4,%eax
     81f:	c1 e0 04             	shl    $0x4,%eax
     822:	89 45 b0             	mov    %eax,-0x50(%ebp)
  int finished_shift = 0; // cup_boy changes it to 1 if all students left the bar and sends Action => GO_HOME to bartenders
     825:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)

  
  file_to_write = open("out.txt",(O_CREATE | O_WRONLY)); //
     82c:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     833:	00 
     834:	c7 04 24 fc 17 00 00 	movl   $0x17fc,(%esp)
     83b:	e8 e0 05 00 00       	call   e20 <open>
     840:	a3 74 1e 00 00       	mov    %eax,0x1e74
  if(file_to_write == -1){
     845:	a1 74 1e 00 00       	mov    0x1e74,%eax
     84a:	83 f8 ff             	cmp    $0xffffffff,%eax
     84d:	75 19                	jne    868 <main+0x25b>
      printf(1,"There was an error opening out.txt\n");
     84f:	c7 44 24 04 04 18 00 	movl   $0x1804,0x4(%esp)
     856:	00 
     857:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     85e:	e8 34 07 00 00       	call   f97 <printf>
      exit();
     863:	e8 78 05 00 00       	call   de0 <exit>
  }
  
  
  //Databases
   bouncer = semaphore_create(M);		//this is the bouncer to the Beinstein
     868:	8b 45 d0             	mov    -0x30(%ebp),%eax
     86b:	89 04 24             	mov    %eax,(%esp)
     86e:	e8 e9 0a 00 00       	call   135c <semaphore_create>
     873:	a3 60 1e 00 00       	mov    %eax,0x1e60
   ABB = BB_create(A); 				//this is a BB for student actions: drink, ans for a dring
     878:	8b 45 e0             	mov    -0x20(%ebp),%eax
     87b:	89 04 24             	mov    %eax,(%esp)
     87e:	e8 31 0c 00 00       	call   14b4 <BB_create>
     883:	a3 68 1e 00 00       	mov    %eax,0x1e68
   DrinkBB = BB_create(A);			//this is a BB holding the drinks that are ready to be drinking
     888:	8b 45 e0             	mov    -0x20(%ebp),%eax
     88b:	89 04 24             	mov    %eax,(%esp)
     88e:	e8 21 0c 00 00       	call   14b4 <BB_create>
     893:	a3 78 1e 00 00       	mov    %eax,0x1e78
   CBB = BB_create(C);				//this is a BB hold clean cups
     898:	8b 45 d8             	mov    -0x28(%ebp),%eax
     89b:	89 04 24             	mov    %eax,(%esp)
     89e:	e8 11 0c 00 00       	call   14b4 <BB_create>
     8a3:	a3 94 1e 00 00       	mov    %eax,0x1e94
   DBB = BB_create(C);				//this is a BB hold dirty cups
     8a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
     8ab:	89 04 24             	mov    %eax,(%esp)
     8ae:	e8 01 0c 00 00       	call   14b4 <BB_create>
     8b3:	a3 6c 1e 00 00       	mov    %eax,0x1e6c
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
     8b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     8bf:	e8 e4 05 00 00       	call   ea8 <binary_semaphore_create>
     8c4:	a3 90 1e 00 00       	mov    %eax,0x1e90
   general_mutex = binary_semaphore_create(1);
     8c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8d0:	e8 d3 05 00 00       	call   ea8 <binary_semaphore_create>
     8d5:	a3 70 1e 00 00       	mov    %eax,0x1e70

   //initialize C clean cups
   struct Cup* cup_array[C];
     8da:	8b 45 d8             	mov    -0x28(%ebp),%eax
     8dd:	8d 50 ff             	lea    -0x1(%eax),%edx
     8e0:	89 55 a8             	mov    %edx,-0x58(%ebp)
     8e3:	c1 e0 02             	shl    $0x2,%eax
     8e6:	8d 50 0f             	lea    0xf(%eax),%edx
     8e9:	b8 10 00 00 00       	mov    $0x10,%eax
     8ee:	83 e8 01             	sub    $0x1,%eax
     8f1:	01 d0                	add    %edx,%eax
     8f3:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     8fa:	00 00 00 
     8fd:	ba 00 00 00 00       	mov    $0x0,%edx
     902:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     908:	6b c0 10             	imul   $0x10,%eax,%eax
     90b:	29 c4                	sub    %eax,%esp
     90d:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     911:	83 c0 0f             	add    $0xf,%eax
     914:	c1 e8 04             	shr    $0x4,%eax
     917:	c1 e0 04             	shl    $0x4,%eax
     91a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
   for(i = 0; i < C; i++){
     91d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     924:	eb 38                	jmp    95e <main+0x351>
      cup_array[i] = (Cup*)malloc(sizeof(Cup)); //TODO free cups
     926:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     92d:	e8 49 09 00 00       	call   127b <malloc>
     932:	8b 55 a4             	mov    -0x5c(%ebp),%edx
     935:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     938:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      cup_array[i]->id = i;
     93b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     93e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     941:	8b 04 90             	mov    (%eax,%edx,4),%eax
     944:	8b 55 f4             	mov    -0xc(%ebp),%edx
     947:	89 10                	mov    %edx,(%eax)
      add_clean_cup(cup_array[i]);
     949:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     94c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     94f:	8b 04 90             	mov    (%eax,%edx,4),%eax
     952:	89 04 24             	mov    %eax,(%esp)
     955:	e8 47 f7 ff ff       	call   a1 <add_clean_cup>
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
   general_mutex = binary_semaphore_create(1);

   //initialize C clean cups
   struct Cup* cup_array[C];
   for(i = 0; i < C; i++){
     95a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     961:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     964:	7c c0                	jl     926 <main+0x319>
      cup_array[i]->id = i;
      add_clean_cup(cup_array[i]);
   }
   
   //initialize cup_boy
   cup_boy_stack = (void*)malloc(STACK_SIZE);
     966:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
     96d:	e8 09 09 00 00       	call   127b <malloc>
     972:	89 45 a0             	mov    %eax,-0x60(%ebp)
   thread_create((void*)cup_boy,cup_boy_stack,STACK_SIZE); 
     975:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     97c:	00 
     97d:	8b 45 a0             	mov    -0x60(%ebp),%eax
     980:	89 44 24 04          	mov    %eax,0x4(%esp)
     984:	c7 04 24 aa 03 00 00 	movl   $0x3aa,(%esp)
     98b:	e8 f0 04 00 00       	call   e80 <thread_create>
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     990:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     997:	eb 43                	jmp    9dc <main+0x3cf>
      bartenders_stacks[i] = (void*)malloc(STACK_SIZE);
     999:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
     9a0:	e8 d6 08 00 00       	call   127b <malloc>
     9a5:	8b 55 c0             	mov    -0x40(%ebp),%edx
     9a8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     9ab:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],STACK_SIZE);
     9ae:	8b 45 c0             	mov    -0x40(%ebp),%eax
     9b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9b4:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9b7:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     9be:	00 
     9bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c3:	c7 04 24 5d 02 00 00 	movl   $0x25d,(%esp)
     9ca:	e8 b1 04 00 00       	call   e80 <thread_create>
     9cf:	8b 55 b0             	mov    -0x50(%ebp),%edx
     9d2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     9d5:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
   //initialize cup_boy
   cup_boy_stack = (void*)malloc(STACK_SIZE);
   thread_create((void*)cup_boy,cup_boy_stack,STACK_SIZE); 
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     9d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9df:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     9e2:	7c b5                	jl     999 <main+0x38c>
      bartenders_stacks[i] = (void*)malloc(STACK_SIZE);
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],STACK_SIZE);
  }
   
   //initialize S students
   for(i = 0; i < S; i++){
     9e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9eb:	eb 43                	jmp    a30 <main+0x423>
      students_stacks[i] = (void*)malloc(STACK_SIZE);
     9ed:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
     9f4:	e8 82 08 00 00       	call   127b <malloc>
     9f9:	8b 55 c8             	mov    -0x38(%ebp),%edx
     9fc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     9ff:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      student_tids[i] = thread_create((void*)student,students_stacks[i],STACK_SIZE);
     a02:	8b 45 c8             	mov    -0x38(%ebp),%eax
     a05:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a08:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a0b:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     a12:	00 
     a13:	89 44 24 04          	mov    %eax,0x4(%esp)
     a17:	c7 04 24 ee 00 00 00 	movl   $0xee,(%esp)
     a1e:	e8 5d 04 00 00       	call   e80 <thread_create>
     a23:	8b 55 b8             	mov    -0x48(%ebp),%edx
     a26:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a29:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      bartenders_stacks[i] = (void*)malloc(STACK_SIZE);
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],STACK_SIZE);
  }
   
   //initialize S students
   for(i = 0; i < S; i++){
     a2c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a33:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     a36:	7c b5                	jl     9ed <main+0x3e0>
      student_tids[i] = thread_create((void*)student,students_stacks[i],STACK_SIZE);
  }
  

   
   join_peoples(student_tids,S); //join students
     a38:	8b 45 b8             	mov    -0x48(%ebp),%eax
     a3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     a3e:	89 54 24 04          	mov    %edx,0x4(%esp)
     a42:	89 04 24             	mov    %eax,(%esp)
     a45:	e8 21 fa ff ff       	call   46b <join_peoples>
   finished_shift = 1;
     a4a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
   if(finished_shift){
     a51:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
     a55:	74 0d                	je     a64 <main+0x457>
    binary_semaphore_up(cup_boy_lock); 
     a57:	a1 90 1e 00 00       	mov    0x1e90,%eax
     a5c:	89 04 24             	mov    %eax,(%esp)
     a5f:	e8 54 04 00 00       	call   eb8 <binary_semaphore_up>
   }
   release_workers(B);
     a64:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a67:	89 04 24             	mov    %eax,(%esp)
     a6a:	e8 33 fa ff ff       	call   4a2 <release_workers>
   join_peoples(bartender_tids,B); //join bartenders
     a6f:	8b 45 b0             	mov    -0x50(%ebp),%eax
     a72:	8b 55 dc             	mov    -0x24(%ebp),%edx
     a75:	89 54 24 04          	mov    %edx,0x4(%esp)
     a79:	89 04 24             	mov    %eax,(%esp)
     a7c:	e8 ea f9 ff ff       	call   46b <join_peoples>
   sleep(2); // delay so exit will not come before threads finished TODO (need better soloution)
     a81:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     a88:	e8 e3 03 00 00       	call   e70 <sleep>
   
   if(close(file_to_write) == -1){
     a8d:	a1 74 1e 00 00       	mov    0x1e74,%eax
     a92:	89 04 24             	mov    %eax,(%esp)
     a95:	e8 6e 03 00 00       	call   e08 <close>
     a9a:	83 f8 ff             	cmp    $0xffffffff,%eax
     a9d:	75 19                	jne    ab8 <main+0x4ab>
    printf(1,"There was an error closing out.txt\n");
     a9f:	c7 44 24 04 28 18 00 	movl   $0x1828,0x4(%esp)
     aa6:	00 
     aa7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     aae:	e8 e4 04 00 00       	call   f97 <printf>
    exit();
     ab3:	e8 28 03 00 00       	call   de0 <exit>
   }
   
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     ab8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     abf:	eb 15                	jmp    ad6 <main+0x4c9>
    free(cup_array[i]);
     ac1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     ac4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ac7:	8b 04 90             	mov    (%eax,%edx,4),%eax
     aca:	89 04 24             	mov    %eax,(%esp)
     acd:	e8 7a 06 00 00       	call   114c <free>
    exit();
   }
   
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     ad2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     adc:	7c e3                	jl     ac1 <main+0x4b4>
    free(cup_array[i]);
  }
  
  //free cup_boy_stack
  free(cup_boy_stack);
     ade:	8b 45 a0             	mov    -0x60(%ebp),%eax
     ae1:	89 04 24             	mov    %eax,(%esp)
     ae4:	e8 63 06 00 00       	call   114c <free>
  
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     ae9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     af0:	eb 15                	jmp    b07 <main+0x4fa>
   free(bartenders_stacks[i]); 
     af2:	8b 45 c0             	mov    -0x40(%ebp),%eax
     af5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     af8:	8b 04 90             	mov    (%eax,%edx,4),%eax
     afb:	89 04 24             	mov    %eax,(%esp)
     afe:	e8 49 06 00 00       	call   114c <free>
  
  //free cup_boy_stack
  free(cup_boy_stack);
  
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     b03:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b0a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     b0d:	7c e3                	jl     af2 <main+0x4e5>
   free(bartenders_stacks[i]); 
  }
  
  //free students_stacks
  for(i = 0; i < S; i++){
     b0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b16:	eb 15                	jmp    b2d <main+0x520>
   free(students_stacks[i]); 
     b18:	8b 45 c8             	mov    -0x38(%ebp),%eax
     b1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b1e:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b21:	89 04 24             	mov    %eax,(%esp)
     b24:	e8 23 06 00 00       	call   114c <free>
  for(i = 0; i < B; i++){
   free(bartenders_stacks[i]); 
  }
  
  //free students_stacks
  for(i = 0; i < S; i++){
     b29:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b30:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     b33:	7c e3                	jl     b18 <main+0x50b>
   free(students_stacks[i]); 
  }
  
  semaphore_free(bouncer);
     b35:	a1 60 1e 00 00       	mov    0x1e60,%eax
     b3a:	89 04 24             	mov    %eax,(%esp)
     b3d:	e8 5e 09 00 00       	call   14a0 <semaphore_free>
  BB_free(ABB);
     b42:	a1 68 1e 00 00       	mov    0x1e68,%eax
     b47:	89 04 24             	mov    %eax,(%esp)
     b4a:	e8 9e 0b 00 00       	call   16ed <BB_free>
  BB_free(DrinkBB);
     b4f:	a1 78 1e 00 00       	mov    0x1e78,%eax
     b54:	89 04 24             	mov    %eax,(%esp)
     b57:	e8 91 0b 00 00       	call   16ed <BB_free>
  BB_free(CBB);
     b5c:	a1 94 1e 00 00       	mov    0x1e94,%eax
     b61:	89 04 24             	mov    %eax,(%esp)
     b64:	e8 84 0b 00 00       	call   16ed <BB_free>
  BB_free(DBB);
     b69:	a1 6c 1e 00 00       	mov    0x1e6c,%eax
     b6e:	89 04 24             	mov    %eax,(%esp)
     b71:	e8 77 0b 00 00       	call   16ed <BB_free>
 
  exit();
     b76:	e8 65 02 00 00       	call   de0 <exit>
     b7b:	90                   	nop

00000b7c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     b7c:	55                   	push   %ebp
     b7d:	89 e5                	mov    %esp,%ebp
     b7f:	57                   	push   %edi
     b80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     b81:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b84:	8b 55 10             	mov    0x10(%ebp),%edx
     b87:	8b 45 0c             	mov    0xc(%ebp),%eax
     b8a:	89 cb                	mov    %ecx,%ebx
     b8c:	89 df                	mov    %ebx,%edi
     b8e:	89 d1                	mov    %edx,%ecx
     b90:	fc                   	cld    
     b91:	f3 aa                	rep stos %al,%es:(%edi)
     b93:	89 ca                	mov    %ecx,%edx
     b95:	89 fb                	mov    %edi,%ebx
     b97:	89 5d 08             	mov    %ebx,0x8(%ebp)
     b9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     b9d:	5b                   	pop    %ebx
     b9e:	5f                   	pop    %edi
     b9f:	5d                   	pop    %ebp
     ba0:	c3                   	ret    

00000ba1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     ba1:	55                   	push   %ebp
     ba2:	89 e5                	mov    %esp,%ebp
     ba4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     ba7:	8b 45 08             	mov    0x8(%ebp),%eax
     baa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     bad:	90                   	nop
     bae:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb1:	0f b6 10             	movzbl (%eax),%edx
     bb4:	8b 45 08             	mov    0x8(%ebp),%eax
     bb7:	88 10                	mov    %dl,(%eax)
     bb9:	8b 45 08             	mov    0x8(%ebp),%eax
     bbc:	0f b6 00             	movzbl (%eax),%eax
     bbf:	84 c0                	test   %al,%al
     bc1:	0f 95 c0             	setne  %al
     bc4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     bc8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     bcc:	84 c0                	test   %al,%al
     bce:	75 de                	jne    bae <strcpy+0xd>
    ;
  return os;
     bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     bd3:	c9                   	leave  
     bd4:	c3                   	ret    

00000bd5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bd5:	55                   	push   %ebp
     bd6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     bd8:	eb 08                	jmp    be2 <strcmp+0xd>
    p++, q++;
     bda:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     bde:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     be2:	8b 45 08             	mov    0x8(%ebp),%eax
     be5:	0f b6 00             	movzbl (%eax),%eax
     be8:	84 c0                	test   %al,%al
     bea:	74 10                	je     bfc <strcmp+0x27>
     bec:	8b 45 08             	mov    0x8(%ebp),%eax
     bef:	0f b6 10             	movzbl (%eax),%edx
     bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
     bf5:	0f b6 00             	movzbl (%eax),%eax
     bf8:	38 c2                	cmp    %al,%dl
     bfa:	74 de                	je     bda <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     bfc:	8b 45 08             	mov    0x8(%ebp),%eax
     bff:	0f b6 00             	movzbl (%eax),%eax
     c02:	0f b6 d0             	movzbl %al,%edx
     c05:	8b 45 0c             	mov    0xc(%ebp),%eax
     c08:	0f b6 00             	movzbl (%eax),%eax
     c0b:	0f b6 c0             	movzbl %al,%eax
     c0e:	89 d1                	mov    %edx,%ecx
     c10:	29 c1                	sub    %eax,%ecx
     c12:	89 c8                	mov    %ecx,%eax
}
     c14:	5d                   	pop    %ebp
     c15:	c3                   	ret    

00000c16 <strlen>:

uint
strlen(char *s)
{
     c16:	55                   	push   %ebp
     c17:	89 e5                	mov    %esp,%ebp
     c19:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     c1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     c23:	eb 04                	jmp    c29 <strlen+0x13>
     c25:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c2c:	03 45 08             	add    0x8(%ebp),%eax
     c2f:	0f b6 00             	movzbl (%eax),%eax
     c32:	84 c0                	test   %al,%al
     c34:	75 ef                	jne    c25 <strlen+0xf>
    ;
  return n;
     c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     c39:	c9                   	leave  
     c3a:	c3                   	ret    

00000c3b <memset>:

void*
memset(void *dst, int c, uint n)
{
     c3b:	55                   	push   %ebp
     c3c:	89 e5                	mov    %esp,%ebp
     c3e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     c41:	8b 45 10             	mov    0x10(%ebp),%eax
     c44:	89 44 24 08          	mov    %eax,0x8(%esp)
     c48:	8b 45 0c             	mov    0xc(%ebp),%eax
     c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
     c4f:	8b 45 08             	mov    0x8(%ebp),%eax
     c52:	89 04 24             	mov    %eax,(%esp)
     c55:	e8 22 ff ff ff       	call   b7c <stosb>
  return dst;
     c5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c5d:	c9                   	leave  
     c5e:	c3                   	ret    

00000c5f <strchr>:

char*
strchr(const char *s, char c)
{
     c5f:	55                   	push   %ebp
     c60:	89 e5                	mov    %esp,%ebp
     c62:	83 ec 04             	sub    $0x4,%esp
     c65:	8b 45 0c             	mov    0xc(%ebp),%eax
     c68:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     c6b:	eb 14                	jmp    c81 <strchr+0x22>
    if(*s == c)
     c6d:	8b 45 08             	mov    0x8(%ebp),%eax
     c70:	0f b6 00             	movzbl (%eax),%eax
     c73:	3a 45 fc             	cmp    -0x4(%ebp),%al
     c76:	75 05                	jne    c7d <strchr+0x1e>
      return (char*)s;
     c78:	8b 45 08             	mov    0x8(%ebp),%eax
     c7b:	eb 13                	jmp    c90 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     c7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     c81:	8b 45 08             	mov    0x8(%ebp),%eax
     c84:	0f b6 00             	movzbl (%eax),%eax
     c87:	84 c0                	test   %al,%al
     c89:	75 e2                	jne    c6d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     c8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c90:	c9                   	leave  
     c91:	c3                   	ret    

00000c92 <gets>:

char*
gets(char *buf, int max)
{
     c92:	55                   	push   %ebp
     c93:	89 e5                	mov    %esp,%ebp
     c95:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c9f:	eb 44                	jmp    ce5 <gets+0x53>
    cc = read(0, &c, 1);
     ca1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     ca8:	00 
     ca9:	8d 45 ef             	lea    -0x11(%ebp),%eax
     cac:	89 44 24 04          	mov    %eax,0x4(%esp)
     cb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     cb7:	e8 3c 01 00 00       	call   df8 <read>
     cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     cbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cc3:	7e 2d                	jle    cf2 <gets+0x60>
      break;
    buf[i++] = c;
     cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc8:	03 45 08             	add    0x8(%ebp),%eax
     ccb:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     ccf:	88 10                	mov    %dl,(%eax)
     cd1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     cd5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     cd9:	3c 0a                	cmp    $0xa,%al
     cdb:	74 16                	je     cf3 <gets+0x61>
     cdd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     ce1:	3c 0d                	cmp    $0xd,%al
     ce3:	74 0e                	je     cf3 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ce8:	83 c0 01             	add    $0x1,%eax
     ceb:	3b 45 0c             	cmp    0xc(%ebp),%eax
     cee:	7c b1                	jl     ca1 <gets+0xf>
     cf0:	eb 01                	jmp    cf3 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     cf2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cf6:	03 45 08             	add    0x8(%ebp),%eax
     cf9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     cfc:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cff:	c9                   	leave  
     d00:	c3                   	ret    

00000d01 <stat>:

int
stat(char *n, struct stat *st)
{
     d01:	55                   	push   %ebp
     d02:	89 e5                	mov    %esp,%ebp
     d04:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     d0e:	00 
     d0f:	8b 45 08             	mov    0x8(%ebp),%eax
     d12:	89 04 24             	mov    %eax,(%esp)
     d15:	e8 06 01 00 00       	call   e20 <open>
     d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d21:	79 07                	jns    d2a <stat+0x29>
    return -1;
     d23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d28:	eb 23                	jmp    d4d <stat+0x4c>
  r = fstat(fd, st);
     d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
     d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
     d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d34:	89 04 24             	mov    %eax,(%esp)
     d37:	e8 fc 00 00 00       	call   e38 <fstat>
     d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d42:	89 04 24             	mov    %eax,(%esp)
     d45:	e8 be 00 00 00       	call   e08 <close>
  return r;
     d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     d4d:	c9                   	leave  
     d4e:	c3                   	ret    

00000d4f <atoi>:

int
atoi(const char *s)
{
     d4f:	55                   	push   %ebp
     d50:	89 e5                	mov    %esp,%ebp
     d52:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     d55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     d5c:	eb 23                	jmp    d81 <atoi+0x32>
    n = n*10 + *s++ - '0';
     d5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d61:	89 d0                	mov    %edx,%eax
     d63:	c1 e0 02             	shl    $0x2,%eax
     d66:	01 d0                	add    %edx,%eax
     d68:	01 c0                	add    %eax,%eax
     d6a:	89 c2                	mov    %eax,%edx
     d6c:	8b 45 08             	mov    0x8(%ebp),%eax
     d6f:	0f b6 00             	movzbl (%eax),%eax
     d72:	0f be c0             	movsbl %al,%eax
     d75:	01 d0                	add    %edx,%eax
     d77:	83 e8 30             	sub    $0x30,%eax
     d7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
     d7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d81:	8b 45 08             	mov    0x8(%ebp),%eax
     d84:	0f b6 00             	movzbl (%eax),%eax
     d87:	3c 2f                	cmp    $0x2f,%al
     d89:	7e 0a                	jle    d95 <atoi+0x46>
     d8b:	8b 45 08             	mov    0x8(%ebp),%eax
     d8e:	0f b6 00             	movzbl (%eax),%eax
     d91:	3c 39                	cmp    $0x39,%al
     d93:	7e c9                	jle    d5e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     d95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d98:	c9                   	leave  
     d99:	c3                   	ret    

00000d9a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d9a:	55                   	push   %ebp
     d9b:	89 e5                	mov    %esp,%ebp
     d9d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     da0:	8b 45 08             	mov    0x8(%ebp),%eax
     da3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     da6:	8b 45 0c             	mov    0xc(%ebp),%eax
     da9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     dac:	eb 13                	jmp    dc1 <memmove+0x27>
    *dst++ = *src++;
     dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
     db1:	0f b6 10             	movzbl (%eax),%edx
     db4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     db7:	88 10                	mov    %dl,(%eax)
     db9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     dbd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     dc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     dc5:	0f 9f c0             	setg   %al
     dc8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     dcc:	84 c0                	test   %al,%al
     dce:	75 de                	jne    dae <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     dd0:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dd3:	c9                   	leave  
     dd4:	c3                   	ret    
     dd5:	90                   	nop
     dd6:	90                   	nop
     dd7:	90                   	nop

00000dd8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     dd8:	b8 01 00 00 00       	mov    $0x1,%eax
     ddd:	cd 40                	int    $0x40
     ddf:	c3                   	ret    

00000de0 <exit>:
SYSCALL(exit)
     de0:	b8 02 00 00 00       	mov    $0x2,%eax
     de5:	cd 40                	int    $0x40
     de7:	c3                   	ret    

00000de8 <wait>:
SYSCALL(wait)
     de8:	b8 03 00 00 00       	mov    $0x3,%eax
     ded:	cd 40                	int    $0x40
     def:	c3                   	ret    

00000df0 <pipe>:
SYSCALL(pipe)
     df0:	b8 04 00 00 00       	mov    $0x4,%eax
     df5:	cd 40                	int    $0x40
     df7:	c3                   	ret    

00000df8 <read>:
SYSCALL(read)
     df8:	b8 05 00 00 00       	mov    $0x5,%eax
     dfd:	cd 40                	int    $0x40
     dff:	c3                   	ret    

00000e00 <write>:
SYSCALL(write)
     e00:	b8 10 00 00 00       	mov    $0x10,%eax
     e05:	cd 40                	int    $0x40
     e07:	c3                   	ret    

00000e08 <close>:
SYSCALL(close)
     e08:	b8 15 00 00 00       	mov    $0x15,%eax
     e0d:	cd 40                	int    $0x40
     e0f:	c3                   	ret    

00000e10 <kill>:
SYSCALL(kill)
     e10:	b8 06 00 00 00       	mov    $0x6,%eax
     e15:	cd 40                	int    $0x40
     e17:	c3                   	ret    

00000e18 <exec>:
SYSCALL(exec)
     e18:	b8 07 00 00 00       	mov    $0x7,%eax
     e1d:	cd 40                	int    $0x40
     e1f:	c3                   	ret    

00000e20 <open>:
SYSCALL(open)
     e20:	b8 0f 00 00 00       	mov    $0xf,%eax
     e25:	cd 40                	int    $0x40
     e27:	c3                   	ret    

00000e28 <mknod>:
SYSCALL(mknod)
     e28:	b8 11 00 00 00       	mov    $0x11,%eax
     e2d:	cd 40                	int    $0x40
     e2f:	c3                   	ret    

00000e30 <unlink>:
SYSCALL(unlink)
     e30:	b8 12 00 00 00       	mov    $0x12,%eax
     e35:	cd 40                	int    $0x40
     e37:	c3                   	ret    

00000e38 <fstat>:
SYSCALL(fstat)
     e38:	b8 08 00 00 00       	mov    $0x8,%eax
     e3d:	cd 40                	int    $0x40
     e3f:	c3                   	ret    

00000e40 <link>:
SYSCALL(link)
     e40:	b8 13 00 00 00       	mov    $0x13,%eax
     e45:	cd 40                	int    $0x40
     e47:	c3                   	ret    

00000e48 <mkdir>:
SYSCALL(mkdir)
     e48:	b8 14 00 00 00       	mov    $0x14,%eax
     e4d:	cd 40                	int    $0x40
     e4f:	c3                   	ret    

00000e50 <chdir>:
SYSCALL(chdir)
     e50:	b8 09 00 00 00       	mov    $0x9,%eax
     e55:	cd 40                	int    $0x40
     e57:	c3                   	ret    

00000e58 <dup>:
SYSCALL(dup)
     e58:	b8 0a 00 00 00       	mov    $0xa,%eax
     e5d:	cd 40                	int    $0x40
     e5f:	c3                   	ret    

00000e60 <getpid>:
SYSCALL(getpid)
     e60:	b8 0b 00 00 00       	mov    $0xb,%eax
     e65:	cd 40                	int    $0x40
     e67:	c3                   	ret    

00000e68 <sbrk>:
SYSCALL(sbrk)
     e68:	b8 0c 00 00 00       	mov    $0xc,%eax
     e6d:	cd 40                	int    $0x40
     e6f:	c3                   	ret    

00000e70 <sleep>:
SYSCALL(sleep)
     e70:	b8 0d 00 00 00       	mov    $0xd,%eax
     e75:	cd 40                	int    $0x40
     e77:	c3                   	ret    

00000e78 <uptime>:
SYSCALL(uptime)
     e78:	b8 0e 00 00 00       	mov    $0xe,%eax
     e7d:	cd 40                	int    $0x40
     e7f:	c3                   	ret    

00000e80 <thread_create>:
SYSCALL(thread_create)
     e80:	b8 16 00 00 00       	mov    $0x16,%eax
     e85:	cd 40                	int    $0x40
     e87:	c3                   	ret    

00000e88 <thread_getId>:
SYSCALL(thread_getId)
     e88:	b8 17 00 00 00       	mov    $0x17,%eax
     e8d:	cd 40                	int    $0x40
     e8f:	c3                   	ret    

00000e90 <thread_getProcId>:
SYSCALL(thread_getProcId)
     e90:	b8 18 00 00 00       	mov    $0x18,%eax
     e95:	cd 40                	int    $0x40
     e97:	c3                   	ret    

00000e98 <thread_join>:
SYSCALL(thread_join)
     e98:	b8 19 00 00 00       	mov    $0x19,%eax
     e9d:	cd 40                	int    $0x40
     e9f:	c3                   	ret    

00000ea0 <thread_exit>:
SYSCALL(thread_exit)
     ea0:	b8 1a 00 00 00       	mov    $0x1a,%eax
     ea5:	cd 40                	int    $0x40
     ea7:	c3                   	ret    

00000ea8 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     ea8:	b8 1b 00 00 00       	mov    $0x1b,%eax
     ead:	cd 40                	int    $0x40
     eaf:	c3                   	ret    

00000eb0 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     eb0:	b8 1c 00 00 00       	mov    $0x1c,%eax
     eb5:	cd 40                	int    $0x40
     eb7:	c3                   	ret    

00000eb8 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     eb8:	b8 1d 00 00 00       	mov    $0x1d,%eax
     ebd:	cd 40                	int    $0x40
     ebf:	c3                   	ret    

00000ec0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     ec0:	55                   	push   %ebp
     ec1:	89 e5                	mov    %esp,%ebp
     ec3:	83 ec 28             	sub    $0x28,%esp
     ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ec9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     ecc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     ed3:	00 
     ed4:	8d 45 f4             	lea    -0xc(%ebp),%eax
     ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
     edb:	8b 45 08             	mov    0x8(%ebp),%eax
     ede:	89 04 24             	mov    %eax,(%esp)
     ee1:	e8 1a ff ff ff       	call   e00 <write>
}
     ee6:	c9                   	leave  
     ee7:	c3                   	ret    

00000ee8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ee8:	55                   	push   %ebp
     ee9:	89 e5                	mov    %esp,%ebp
     eeb:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     eee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     ef5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     ef9:	74 17                	je     f12 <printint+0x2a>
     efb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     eff:	79 11                	jns    f12 <printint+0x2a>
    neg = 1;
     f01:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     f08:	8b 45 0c             	mov    0xc(%ebp),%eax
     f0b:	f7 d8                	neg    %eax
     f0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f10:	eb 06                	jmp    f18 <printint+0x30>
  } else {
    x = xx;
     f12:	8b 45 0c             	mov    0xc(%ebp),%eax
     f15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     f18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     f1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f25:	ba 00 00 00 00       	mov    $0x0,%edx
     f2a:	f7 f1                	div    %ecx
     f2c:	89 d0                	mov    %edx,%eax
     f2e:	0f b6 90 40 1e 00 00 	movzbl 0x1e40(%eax),%edx
     f35:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f38:	03 45 f4             	add    -0xc(%ebp),%eax
     f3b:	88 10                	mov    %dl,(%eax)
     f3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     f41:	8b 55 10             	mov    0x10(%ebp),%edx
     f44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f4a:	ba 00 00 00 00       	mov    $0x0,%edx
     f4f:	f7 75 d4             	divl   -0x2c(%ebp)
     f52:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f55:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f59:	75 c4                	jne    f1f <printint+0x37>
  if(neg)
     f5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f5f:	74 2a                	je     f8b <printint+0xa3>
    buf[i++] = '-';
     f61:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f64:	03 45 f4             	add    -0xc(%ebp),%eax
     f67:	c6 00 2d             	movb   $0x2d,(%eax)
     f6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     f6e:	eb 1b                	jmp    f8b <printint+0xa3>
    putc(fd, buf[i]);
     f70:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f73:	03 45 f4             	add    -0xc(%ebp),%eax
     f76:	0f b6 00             	movzbl (%eax),%eax
     f79:	0f be c0             	movsbl %al,%eax
     f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
     f80:	8b 45 08             	mov    0x8(%ebp),%eax
     f83:	89 04 24             	mov    %eax,(%esp)
     f86:	e8 35 ff ff ff       	call   ec0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     f8b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     f8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f93:	79 db                	jns    f70 <printint+0x88>
    putc(fd, buf[i]);
}
     f95:	c9                   	leave  
     f96:	c3                   	ret    

00000f97 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     f97:	55                   	push   %ebp
     f98:	89 e5                	mov    %esp,%ebp
     f9a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     f9d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     fa4:	8d 45 0c             	lea    0xc(%ebp),%eax
     fa7:	83 c0 04             	add    $0x4,%eax
     faa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     fad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     fb4:	e9 7d 01 00 00       	jmp    1136 <printf+0x19f>
    c = fmt[i] & 0xff;
     fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
     fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fbf:	01 d0                	add    %edx,%eax
     fc1:	0f b6 00             	movzbl (%eax),%eax
     fc4:	0f be c0             	movsbl %al,%eax
     fc7:	25 ff 00 00 00       	and    $0xff,%eax
     fcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     fcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fd3:	75 2c                	jne    1001 <printf+0x6a>
      if(c == '%'){
     fd5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     fd9:	75 0c                	jne    fe7 <printf+0x50>
        state = '%';
     fdb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     fe2:	e9 4b 01 00 00       	jmp    1132 <printf+0x19b>
      } else {
        putc(fd, c);
     fe7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     fea:	0f be c0             	movsbl %al,%eax
     fed:	89 44 24 04          	mov    %eax,0x4(%esp)
     ff1:	8b 45 08             	mov    0x8(%ebp),%eax
     ff4:	89 04 24             	mov    %eax,(%esp)
     ff7:	e8 c4 fe ff ff       	call   ec0 <putc>
     ffc:	e9 31 01 00 00       	jmp    1132 <printf+0x19b>
      }
    } else if(state == '%'){
    1001:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1005:	0f 85 27 01 00 00    	jne    1132 <printf+0x19b>
      if(c == 'd'){
    100b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    100f:	75 2d                	jne    103e <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1011:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1014:	8b 00                	mov    (%eax),%eax
    1016:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    101d:	00 
    101e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1025:	00 
    1026:	89 44 24 04          	mov    %eax,0x4(%esp)
    102a:	8b 45 08             	mov    0x8(%ebp),%eax
    102d:	89 04 24             	mov    %eax,(%esp)
    1030:	e8 b3 fe ff ff       	call   ee8 <printint>
        ap++;
    1035:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1039:	e9 ed 00 00 00       	jmp    112b <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    103e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1042:	74 06                	je     104a <printf+0xb3>
    1044:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1048:	75 2d                	jne    1077 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    104a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    104d:	8b 00                	mov    (%eax),%eax
    104f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1056:	00 
    1057:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    105e:	00 
    105f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1063:	8b 45 08             	mov    0x8(%ebp),%eax
    1066:	89 04 24             	mov    %eax,(%esp)
    1069:	e8 7a fe ff ff       	call   ee8 <printint>
        ap++;
    106e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1072:	e9 b4 00 00 00       	jmp    112b <printf+0x194>
      } else if(c == 's'){
    1077:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    107b:	75 46                	jne    10c3 <printf+0x12c>
        s = (char*)*ap;
    107d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1080:	8b 00                	mov    (%eax),%eax
    1082:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1085:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1089:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    108d:	75 27                	jne    10b6 <printf+0x11f>
          s = "(null)";
    108f:	c7 45 f4 4c 18 00 00 	movl   $0x184c,-0xc(%ebp)
        while(*s != 0){
    1096:	eb 1e                	jmp    10b6 <printf+0x11f>
          putc(fd, *s);
    1098:	8b 45 f4             	mov    -0xc(%ebp),%eax
    109b:	0f b6 00             	movzbl (%eax),%eax
    109e:	0f be c0             	movsbl %al,%eax
    10a1:	89 44 24 04          	mov    %eax,0x4(%esp)
    10a5:	8b 45 08             	mov    0x8(%ebp),%eax
    10a8:	89 04 24             	mov    %eax,(%esp)
    10ab:	e8 10 fe ff ff       	call   ec0 <putc>
          s++;
    10b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10b4:	eb 01                	jmp    10b7 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    10b6:	90                   	nop
    10b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10ba:	0f b6 00             	movzbl (%eax),%eax
    10bd:	84 c0                	test   %al,%al
    10bf:	75 d7                	jne    1098 <printf+0x101>
    10c1:	eb 68                	jmp    112b <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    10c3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    10c7:	75 1d                	jne    10e6 <printf+0x14f>
        putc(fd, *ap);
    10c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10cc:	8b 00                	mov    (%eax),%eax
    10ce:	0f be c0             	movsbl %al,%eax
    10d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    10d5:	8b 45 08             	mov    0x8(%ebp),%eax
    10d8:	89 04 24             	mov    %eax,(%esp)
    10db:	e8 e0 fd ff ff       	call   ec0 <putc>
        ap++;
    10e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10e4:	eb 45                	jmp    112b <printf+0x194>
      } else if(c == '%'){
    10e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    10ea:	75 17                	jne    1103 <printf+0x16c>
        putc(fd, c);
    10ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10ef:	0f be c0             	movsbl %al,%eax
    10f2:	89 44 24 04          	mov    %eax,0x4(%esp)
    10f6:	8b 45 08             	mov    0x8(%ebp),%eax
    10f9:	89 04 24             	mov    %eax,(%esp)
    10fc:	e8 bf fd ff ff       	call   ec0 <putc>
    1101:	eb 28                	jmp    112b <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1103:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    110a:	00 
    110b:	8b 45 08             	mov    0x8(%ebp),%eax
    110e:	89 04 24             	mov    %eax,(%esp)
    1111:	e8 aa fd ff ff       	call   ec0 <putc>
        putc(fd, c);
    1116:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1119:	0f be c0             	movsbl %al,%eax
    111c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1120:	8b 45 08             	mov    0x8(%ebp),%eax
    1123:	89 04 24             	mov    %eax,(%esp)
    1126:	e8 95 fd ff ff       	call   ec0 <putc>
      }
      state = 0;
    112b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1132:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1136:	8b 55 0c             	mov    0xc(%ebp),%edx
    1139:	8b 45 f0             	mov    -0x10(%ebp),%eax
    113c:	01 d0                	add    %edx,%eax
    113e:	0f b6 00             	movzbl (%eax),%eax
    1141:	84 c0                	test   %al,%al
    1143:	0f 85 70 fe ff ff    	jne    fb9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1149:	c9                   	leave  
    114a:	c3                   	ret    
    114b:	90                   	nop

0000114c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    114c:	55                   	push   %ebp
    114d:	89 e5                	mov    %esp,%ebp
    114f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1152:	8b 45 08             	mov    0x8(%ebp),%eax
    1155:	83 e8 08             	sub    $0x8,%eax
    1158:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    115b:	a1 5c 1e 00 00       	mov    0x1e5c,%eax
    1160:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1163:	eb 24                	jmp    1189 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1165:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1168:	8b 00                	mov    (%eax),%eax
    116a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    116d:	77 12                	ja     1181 <free+0x35>
    116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1172:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1175:	77 24                	ja     119b <free+0x4f>
    1177:	8b 45 fc             	mov    -0x4(%ebp),%eax
    117a:	8b 00                	mov    (%eax),%eax
    117c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    117f:	77 1a                	ja     119b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1181:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1184:	8b 00                	mov    (%eax),%eax
    1186:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1189:	8b 45 f8             	mov    -0x8(%ebp),%eax
    118c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    118f:	76 d4                	jbe    1165 <free+0x19>
    1191:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1194:	8b 00                	mov    (%eax),%eax
    1196:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1199:	76 ca                	jbe    1165 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    119b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    119e:	8b 40 04             	mov    0x4(%eax),%eax
    11a1:	c1 e0 03             	shl    $0x3,%eax
    11a4:	89 c2                	mov    %eax,%edx
    11a6:	03 55 f8             	add    -0x8(%ebp),%edx
    11a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11ac:	8b 00                	mov    (%eax),%eax
    11ae:	39 c2                	cmp    %eax,%edx
    11b0:	75 24                	jne    11d6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    11b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11b5:	8b 50 04             	mov    0x4(%eax),%edx
    11b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11bb:	8b 00                	mov    (%eax),%eax
    11bd:	8b 40 04             	mov    0x4(%eax),%eax
    11c0:	01 c2                	add    %eax,%edx
    11c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11c5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    11c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11cb:	8b 00                	mov    (%eax),%eax
    11cd:	8b 10                	mov    (%eax),%edx
    11cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11d2:	89 10                	mov    %edx,(%eax)
    11d4:	eb 0a                	jmp    11e0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    11d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11d9:	8b 10                	mov    (%eax),%edx
    11db:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11de:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    11e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11e3:	8b 40 04             	mov    0x4(%eax),%eax
    11e6:	c1 e0 03             	shl    $0x3,%eax
    11e9:	03 45 fc             	add    -0x4(%ebp),%eax
    11ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11ef:	75 20                	jne    1211 <free+0xc5>
    p->s.size += bp->s.size;
    11f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11f4:	8b 50 04             	mov    0x4(%eax),%edx
    11f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11fa:	8b 40 04             	mov    0x4(%eax),%eax
    11fd:	01 c2                	add    %eax,%edx
    11ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1202:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1205:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1208:	8b 10                	mov    (%eax),%edx
    120a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    120d:	89 10                	mov    %edx,(%eax)
    120f:	eb 08                	jmp    1219 <free+0xcd>
  } else
    p->s.ptr = bp;
    1211:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1214:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1217:	89 10                	mov    %edx,(%eax)
  freep = p;
    1219:	8b 45 fc             	mov    -0x4(%ebp),%eax
    121c:	a3 5c 1e 00 00       	mov    %eax,0x1e5c
}
    1221:	c9                   	leave  
    1222:	c3                   	ret    

00001223 <morecore>:

static Header*
morecore(uint nu)
{
    1223:	55                   	push   %ebp
    1224:	89 e5                	mov    %esp,%ebp
    1226:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1229:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1230:	77 07                	ja     1239 <morecore+0x16>
    nu = 4096;
    1232:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1239:	8b 45 08             	mov    0x8(%ebp),%eax
    123c:	c1 e0 03             	shl    $0x3,%eax
    123f:	89 04 24             	mov    %eax,(%esp)
    1242:	e8 21 fc ff ff       	call   e68 <sbrk>
    1247:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    124a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    124e:	75 07                	jne    1257 <morecore+0x34>
    return 0;
    1250:	b8 00 00 00 00       	mov    $0x0,%eax
    1255:	eb 22                	jmp    1279 <morecore+0x56>
  hp = (Header*)p;
    1257:	8b 45 f4             	mov    -0xc(%ebp),%eax
    125a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    125d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1260:	8b 55 08             	mov    0x8(%ebp),%edx
    1263:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1266:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1269:	83 c0 08             	add    $0x8,%eax
    126c:	89 04 24             	mov    %eax,(%esp)
    126f:	e8 d8 fe ff ff       	call   114c <free>
  return freep;
    1274:	a1 5c 1e 00 00       	mov    0x1e5c,%eax
}
    1279:	c9                   	leave  
    127a:	c3                   	ret    

0000127b <malloc>:

void*
malloc(uint nbytes)
{
    127b:	55                   	push   %ebp
    127c:	89 e5                	mov    %esp,%ebp
    127e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1281:	8b 45 08             	mov    0x8(%ebp),%eax
    1284:	83 c0 07             	add    $0x7,%eax
    1287:	c1 e8 03             	shr    $0x3,%eax
    128a:	83 c0 01             	add    $0x1,%eax
    128d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1290:	a1 5c 1e 00 00       	mov    0x1e5c,%eax
    1295:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1298:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    129c:	75 23                	jne    12c1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    129e:	c7 45 f0 54 1e 00 00 	movl   $0x1e54,-0x10(%ebp)
    12a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12a8:	a3 5c 1e 00 00       	mov    %eax,0x1e5c
    12ad:	a1 5c 1e 00 00       	mov    0x1e5c,%eax
    12b2:	a3 54 1e 00 00       	mov    %eax,0x1e54
    base.s.size = 0;
    12b7:	c7 05 58 1e 00 00 00 	movl   $0x0,0x1e58
    12be:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12c4:	8b 00                	mov    (%eax),%eax
    12c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    12c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12cc:	8b 40 04             	mov    0x4(%eax),%eax
    12cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    12d2:	72 4d                	jb     1321 <malloc+0xa6>
      if(p->s.size == nunits)
    12d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d7:	8b 40 04             	mov    0x4(%eax),%eax
    12da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    12dd:	75 0c                	jne    12eb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    12df:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12e2:	8b 10                	mov    (%eax),%edx
    12e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12e7:	89 10                	mov    %edx,(%eax)
    12e9:	eb 26                	jmp    1311 <malloc+0x96>
      else {
        p->s.size -= nunits;
    12eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ee:	8b 40 04             	mov    0x4(%eax),%eax
    12f1:	89 c2                	mov    %eax,%edx
    12f3:	2b 55 ec             	sub    -0x14(%ebp),%edx
    12f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    12fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ff:	8b 40 04             	mov    0x4(%eax),%eax
    1302:	c1 e0 03             	shl    $0x3,%eax
    1305:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1308:	8b 45 f4             	mov    -0xc(%ebp),%eax
    130b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    130e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1311:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1314:	a3 5c 1e 00 00       	mov    %eax,0x1e5c
      return (void*)(p + 1);
    1319:	8b 45 f4             	mov    -0xc(%ebp),%eax
    131c:	83 c0 08             	add    $0x8,%eax
    131f:	eb 38                	jmp    1359 <malloc+0xde>
    }
    if(p == freep)
    1321:	a1 5c 1e 00 00       	mov    0x1e5c,%eax
    1326:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1329:	75 1b                	jne    1346 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    132b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    132e:	89 04 24             	mov    %eax,(%esp)
    1331:	e8 ed fe ff ff       	call   1223 <morecore>
    1336:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    133d:	75 07                	jne    1346 <malloc+0xcb>
        return 0;
    133f:	b8 00 00 00 00       	mov    $0x0,%eax
    1344:	eb 13                	jmp    1359 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1346:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1349:	89 45 f0             	mov    %eax,-0x10(%ebp)
    134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    134f:	8b 00                	mov    (%eax),%eax
    1351:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1354:	e9 70 ff ff ff       	jmp    12c9 <malloc+0x4e>
}
    1359:	c9                   	leave  
    135a:	c3                   	ret    
    135b:	90                   	nop

0000135c <semaphore_create>:
#include "semaphore.h"
#include "types.h"
#include "user.h"


struct semaphore* semaphore_create(int initial_semaphore_value){
    135c:	55                   	push   %ebp
    135d:	89 e5                	mov    %esp,%ebp
    135f:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* sem=malloc(sizeof(struct semaphore)); 
    1362:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    1369:	e8 0d ff ff ff       	call   127b <malloc>
    136e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // acquire semaphors
  sem->s1 = binary_semaphore_create(1);
    1371:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1378:	e8 2b fb ff ff       	call   ea8 <binary_semaphore_create>
    137d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1380:	89 02                	mov    %eax,(%edx)
  
  // s2 should be initialized with the min{1,initial_semaphore_value}
  if(initial_semaphore_value >= 1){
    1382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1386:	7e 14                	jle    139c <semaphore_create+0x40>
    sem->s2 = binary_semaphore_create(1);
    1388:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    138f:	e8 14 fb ff ff       	call   ea8 <binary_semaphore_create>
    1394:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1397:	89 42 04             	mov    %eax,0x4(%edx)
    139a:	eb 11                	jmp    13ad <semaphore_create+0x51>
  }else{
    sem->s2 = binary_semaphore_create(initial_semaphore_value);
    139c:	8b 45 08             	mov    0x8(%ebp),%eax
    139f:	89 04 24             	mov    %eax,(%esp)
    13a2:	e8 01 fb ff ff       	call   ea8 <binary_semaphore_create>
    13a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13aa:	89 42 04             	mov    %eax,0x4(%edx)
  }
  
  if(sem->s1 == -1 || sem->s2 == -1){
    13ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b0:	8b 00                	mov    (%eax),%eax
    13b2:	83 f8 ff             	cmp    $0xffffffff,%eax
    13b5:	74 0b                	je     13c2 <semaphore_create+0x66>
    13b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ba:	8b 40 04             	mov    0x4(%eax),%eax
    13bd:	83 f8 ff             	cmp    $0xffffffff,%eax
    13c0:	75 26                	jne    13e8 <semaphore_create+0x8c>
     printf(1,"we had a probalem initialize in semaphore_create\n");
    13c2:	c7 44 24 04 54 18 00 	movl   $0x1854,0x4(%esp)
    13c9:	00 
    13ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13d1:	e8 c1 fb ff ff       	call   f97 <printf>
     free(sem);
    13d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13d9:	89 04 24             	mov    %eax,(%esp)
    13dc:	e8 6b fd ff ff       	call   114c <free>
     return 0;
    13e1:	b8 00 00 00 00       	mov    $0x0,%eax
    13e6:	eb 15                	jmp    13fd <semaphore_create+0xa1>
  }
  //initialize value
  sem->value = initial_semaphore_value;//dynamic
    13e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13eb:	8b 55 08             	mov    0x8(%ebp),%edx
    13ee:	89 50 08             	mov    %edx,0x8(%eax)
  sem->initial_value = initial_semaphore_value;//static
    13f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f4:	8b 55 08             	mov    0x8(%ebp),%edx
    13f7:	89 50 0c             	mov    %edx,0xc(%eax)
  
  return sem;
    13fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    13fd:	c9                   	leave  
    13fe:	c3                   	ret    

000013ff <semaphore_down>:
void semaphore_down(struct semaphore* sem ){
    13ff:	55                   	push   %ebp
    1400:	89 e5                	mov    %esp,%ebp
    1402:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s2);
    1405:	8b 45 08             	mov    0x8(%ebp),%eax
    1408:	8b 40 04             	mov    0x4(%eax),%eax
    140b:	89 04 24             	mov    %eax,(%esp)
    140e:	e8 9d fa ff ff       	call   eb0 <binary_semaphore_down>
  binary_semaphore_down(sem->s1);
    1413:	8b 45 08             	mov    0x8(%ebp),%eax
    1416:	8b 00                	mov    (%eax),%eax
    1418:	89 04 24             	mov    %eax,(%esp)
    141b:	e8 90 fa ff ff       	call   eb0 <binary_semaphore_down>
  sem->value--;	
    1420:	8b 45 08             	mov    0x8(%ebp),%eax
    1423:	8b 40 08             	mov    0x8(%eax),%eax
    1426:	8d 50 ff             	lea    -0x1(%eax),%edx
    1429:	8b 45 08             	mov    0x8(%ebp),%eax
    142c:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value > 0){
    142f:	8b 45 08             	mov    0x8(%ebp),%eax
    1432:	8b 40 08             	mov    0x8(%eax),%eax
    1435:	85 c0                	test   %eax,%eax
    1437:	7e 0e                	jle    1447 <semaphore_down+0x48>
   binary_semaphore_up(sem->s2);
    1439:	8b 45 08             	mov    0x8(%ebp),%eax
    143c:	8b 40 04             	mov    0x4(%eax),%eax
    143f:	89 04 24             	mov    %eax,(%esp)
    1442:	e8 71 fa ff ff       	call   eb8 <binary_semaphore_up>
  }
  binary_semaphore_up(sem->s1); 
    1447:	8b 45 08             	mov    0x8(%ebp),%eax
    144a:	8b 00                	mov    (%eax),%eax
    144c:	89 04 24             	mov    %eax,(%esp)
    144f:	e8 64 fa ff ff       	call   eb8 <binary_semaphore_up>
}
    1454:	c9                   	leave  
    1455:	c3                   	ret    

00001456 <semaphore_up>:
void semaphore_up(struct semaphore* sem ){
    1456:	55                   	push   %ebp
    1457:	89 e5                	mov    %esp,%ebp
    1459:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
    145c:	8b 45 08             	mov    0x8(%ebp),%eax
    145f:	8b 00                	mov    (%eax),%eax
    1461:	89 04 24             	mov    %eax,(%esp)
    1464:	e8 47 fa ff ff       	call   eb0 <binary_semaphore_down>
  sem->value++;	
    1469:	8b 45 08             	mov    0x8(%ebp),%eax
    146c:	8b 40 08             	mov    0x8(%eax),%eax
    146f:	8d 50 01             	lea    0x1(%eax),%edx
    1472:	8b 45 08             	mov    0x8(%ebp),%eax
    1475:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value ==1){
    1478:	8b 45 08             	mov    0x8(%ebp),%eax
    147b:	8b 40 08             	mov    0x8(%eax),%eax
    147e:	83 f8 01             	cmp    $0x1,%eax
    1481:	75 0e                	jne    1491 <semaphore_up+0x3b>
   binary_semaphore_up(sem->s2); 
    1483:	8b 45 08             	mov    0x8(%ebp),%eax
    1486:	8b 40 04             	mov    0x4(%eax),%eax
    1489:	89 04 24             	mov    %eax,(%esp)
    148c:	e8 27 fa ff ff       	call   eb8 <binary_semaphore_up>
   }
  binary_semaphore_up(sem->s1);
    1491:	8b 45 08             	mov    0x8(%ebp),%eax
    1494:	8b 00                	mov    (%eax),%eax
    1496:	89 04 24             	mov    %eax,(%esp)
    1499:	e8 1a fa ff ff       	call   eb8 <binary_semaphore_up>
}
    149e:	c9                   	leave  
    149f:	c3                   	ret    

000014a0 <semaphore_free>:

void semaphore_free(struct semaphore* sem){
    14a0:	55                   	push   %ebp
    14a1:	89 e5                	mov    %esp,%ebp
    14a3:	83 ec 18             	sub    $0x18,%esp
  free(sem);
    14a6:	8b 45 08             	mov    0x8(%ebp),%eax
    14a9:	89 04 24             	mov    %eax,(%esp)
    14ac:	e8 9b fc ff ff       	call   114c <free>
}
    14b1:	c9                   	leave  
    14b2:	c3                   	ret    
    14b3:	90                   	nop

000014b4 <BB_create>:
#include "types.h"
#include "user.h"


struct BB* 
BB_create(int max_capacity){
    14b4:	55                   	push   %ebp
    14b5:	89 e5                	mov    %esp,%ebp
    14b7:	83 ec 38             	sub    $0x38,%esp
  //initialize
  struct BB* buf = malloc(sizeof(struct BB));
    14ba:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
    14c1:	e8 b5 fd ff ff       	call   127b <malloc>
    14c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
    14c9:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    14d0:	00 
    14d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14d8:	00 
    14d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14dc:	89 04 24             	mov    %eax,(%esp)
    14df:	e8 57 f7 ff ff       	call   c3b <memset>
 
  buf->buffer_size = max_capacity;
    14e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e7:	8b 55 08             	mov    0x8(%ebp),%edx
    14ea:	89 10                	mov    %edx,(%eax)
  buf->mutex = binary_semaphore_create(1);  
    14ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14f3:	e8 b0 f9 ff ff       	call   ea8 <binary_semaphore_create>
    14f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14fb:	89 42 04             	mov    %eax,0x4(%edx)
  buf->empty = semaphore_create(max_capacity);
    14fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1501:	89 04 24             	mov    %eax,(%esp)
    1504:	e8 53 fe ff ff       	call   135c <semaphore_create>
    1509:	8b 55 f4             	mov    -0xc(%ebp),%edx
    150c:	89 42 08             	mov    %eax,0x8(%edx)
  buf->full = semaphore_create(0);
    150f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1516:	e8 41 fe ff ff       	call   135c <semaphore_create>
    151b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    151e:	89 42 0c             	mov    %eax,0xc(%edx)
  
  //void** elements_array = (void**)malloc(sizeof(void*) * max_capacity); 
  //memset(buf->elements_array,0,sizeof(void*)*max_capacity);
  //buf->pointer_to_elements = elements_array;  
  
  buf->pointer_to_elements = malloc(sizeof(void*)*max_capacity);
    1521:	8b 45 08             	mov    0x8(%ebp),%eax
    1524:	c1 e0 02             	shl    $0x2,%eax
    1527:	89 04 24             	mov    %eax,(%esp)
    152a:	e8 4c fd ff ff       	call   127b <malloc>
    152f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1532:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->pointer_to_elements,0,sizeof(void*)*max_capacity);
    1535:	8b 45 08             	mov    0x8(%ebp),%eax
    1538:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    153f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1542:	8b 40 1c             	mov    0x1c(%eax),%eax
    1545:	89 54 24 08          	mov    %edx,0x8(%esp)
    1549:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1550:	00 
    1551:	89 04 24             	mov    %eax,(%esp)
    1554:	e8 e2 f6 ff ff       	call   c3b <memset>
  
  buf->count = 0;
    1559:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  //check the semaphorses
  if(buf->mutex == -1 || buf->empty == 0 || buf->full == 0){
    1563:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1566:	8b 40 04             	mov    0x4(%eax),%eax
    1569:	83 f8 ff             	cmp    $0xffffffff,%eax
    156c:	74 14                	je     1582 <BB_create+0xce>
    156e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1571:	8b 40 08             	mov    0x8(%eax),%eax
    1574:	85 c0                	test   %eax,%eax
    1576:	74 0a                	je     1582 <BB_create+0xce>
    1578:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157b:	8b 40 0c             	mov    0xc(%eax),%eax
    157e:	85 c0                	test   %eax,%eax
    1580:	75 52                	jne    15d4 <BB_create+0x120>
   printf(1,"we had a problam getting semaphores at BB create mutex %d empty %d full %d\n",buf->mutex,buf->empty,buf->full);
    1582:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1585:	8b 48 0c             	mov    0xc(%eax),%ecx
    1588:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158b:	8b 50 08             	mov    0x8(%eax),%edx
    158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1591:	8b 40 04             	mov    0x4(%eax),%eax
    1594:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    1598:	89 54 24 0c          	mov    %edx,0xc(%esp)
    159c:	89 44 24 08          	mov    %eax,0x8(%esp)
    15a0:	c7 44 24 04 88 18 00 	movl   $0x1888,0x4(%esp)
    15a7:	00 
    15a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15af:	e8 e3 f9 ff ff       	call   f97 <printf>
   free(buf->pointer_to_elements);
    15b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15b7:	8b 40 1c             	mov    0x1c(%eax),%eax
    15ba:	89 04 24             	mov    %eax,(%esp)
    15bd:	e8 8a fb ff ff       	call   114c <free>
   free(buf);
    15c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c5:	89 04 24             	mov    %eax,(%esp)
    15c8:	e8 7f fb ff ff       	call   114c <free>
   buf =0;  
    15cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  }
  return buf;
    15d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    15d7:	c9                   	leave  
    15d8:	c3                   	ret    

000015d9 <BB_put>:

void BB_put(struct BB* bb, void* element)
{ 
    15d9:	55                   	push   %ebp
    15da:	89 e5                	mov    %esp,%ebp
    15dc:	83 ec 18             	sub    $0x18,%esp
  bb->pointer_to_elements[bb->count] = element;
  bb->count++;
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->full);
  */
  semaphore_down(bb->empty);
    15df:	8b 45 08             	mov    0x8(%ebp),%eax
    15e2:	8b 40 08             	mov    0x8(%eax),%eax
    15e5:	89 04 24             	mov    %eax,(%esp)
    15e8:	e8 12 fe ff ff       	call   13ff <semaphore_down>
  binary_semaphore_down(bb->mutex);
    15ed:	8b 45 08             	mov    0x8(%ebp),%eax
    15f0:	8b 40 04             	mov    0x4(%eax),%eax
    15f3:	89 04 24             	mov    %eax,(%esp)
    15f6:	e8 b5 f8 ff ff       	call   eb0 <binary_semaphore_down>
   //insert item
  bb->pointer_to_elements[bb->end] = element;
    15fb:	8b 45 08             	mov    0x8(%ebp),%eax
    15fe:	8b 50 1c             	mov    0x1c(%eax),%edx
    1601:	8b 45 08             	mov    0x8(%ebp),%eax
    1604:	8b 40 18             	mov    0x18(%eax),%eax
    1607:	c1 e0 02             	shl    $0x2,%eax
    160a:	01 c2                	add    %eax,%edx
    160c:	8b 45 0c             	mov    0xc(%ebp),%eax
    160f:	89 02                	mov    %eax,(%edx)
  ++bb->end;
    1611:	8b 45 08             	mov    0x8(%ebp),%eax
    1614:	8b 40 18             	mov    0x18(%eax),%eax
    1617:	8d 50 01             	lea    0x1(%eax),%edx
    161a:	8b 45 08             	mov    0x8(%ebp),%eax
    161d:	89 50 18             	mov    %edx,0x18(%eax)
  bb->end = bb->end%bb->buffer_size;
    1620:	8b 45 08             	mov    0x8(%ebp),%eax
    1623:	8b 40 18             	mov    0x18(%eax),%eax
    1626:	8b 55 08             	mov    0x8(%ebp),%edx
    1629:	8b 0a                	mov    (%edx),%ecx
    162b:	89 c2                	mov    %eax,%edx
    162d:	c1 fa 1f             	sar    $0x1f,%edx
    1630:	f7 f9                	idiv   %ecx
    1632:	8b 45 08             	mov    0x8(%ebp),%eax
    1635:	89 50 18             	mov    %edx,0x18(%eax)
  binary_semaphore_up(bb->mutex);
    1638:	8b 45 08             	mov    0x8(%ebp),%eax
    163b:	8b 40 04             	mov    0x4(%eax),%eax
    163e:	89 04 24             	mov    %eax,(%esp)
    1641:	e8 72 f8 ff ff       	call   eb8 <binary_semaphore_up>
  semaphore_up(bb->full);
    1646:	8b 45 08             	mov    0x8(%ebp),%eax
    1649:	8b 40 0c             	mov    0xc(%eax),%eax
    164c:	89 04 24             	mov    %eax,(%esp)
    164f:	e8 02 fe ff ff       	call   1456 <semaphore_up>
    
}
    1654:	c9                   	leave  
    1655:	c3                   	ret    

00001656 <BB_pop>:

void* BB_pop(struct BB* bb)
{
    1656:	55                   	push   %ebp
    1657:	89 e5                	mov    %esp,%ebp
    1659:	83 ec 28             	sub    $0x28,%esp
  
  void* element_to_pop;
  semaphore_down(bb->full);
    165c:	8b 45 08             	mov    0x8(%ebp),%eax
    165f:	8b 40 0c             	mov    0xc(%eax),%eax
    1662:	89 04 24             	mov    %eax,(%esp)
    1665:	e8 95 fd ff ff       	call   13ff <semaphore_down>
  binary_semaphore_down(bb->mutex);
    166a:	8b 45 08             	mov    0x8(%ebp),%eax
    166d:	8b 40 04             	mov    0x4(%eax),%eax
    1670:	89 04 24             	mov    %eax,(%esp)
    1673:	e8 38 f8 ff ff       	call   eb0 <binary_semaphore_down>
  element_to_pop = bb-> pointer_to_elements[bb->start];
    1678:	8b 45 08             	mov    0x8(%ebp),%eax
    167b:	8b 50 1c             	mov    0x1c(%eax),%edx
    167e:	8b 45 08             	mov    0x8(%ebp),%eax
    1681:	8b 40 14             	mov    0x14(%eax),%eax
    1684:	c1 e0 02             	shl    $0x2,%eax
    1687:	01 d0                	add    %edx,%eax
    1689:	8b 00                	mov    (%eax),%eax
    168b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->pointer_to_elements[bb->start] =0;
    168e:	8b 45 08             	mov    0x8(%ebp),%eax
    1691:	8b 50 1c             	mov    0x1c(%eax),%edx
    1694:	8b 45 08             	mov    0x8(%ebp),%eax
    1697:	8b 40 14             	mov    0x14(%eax),%eax
    169a:	c1 e0 02             	shl    $0x2,%eax
    169d:	01 d0                	add    %edx,%eax
    169f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
    16a5:	8b 45 08             	mov    0x8(%ebp),%eax
    16a8:	8b 40 14             	mov    0x14(%eax),%eax
    16ab:	8d 50 01             	lea    0x1(%eax),%edx
    16ae:	8b 45 08             	mov    0x8(%ebp),%eax
    16b1:	89 50 14             	mov    %edx,0x14(%eax)
  bb->start = bb->start%bb->buffer_size;
    16b4:	8b 45 08             	mov    0x8(%ebp),%eax
    16b7:	8b 40 14             	mov    0x14(%eax),%eax
    16ba:	8b 55 08             	mov    0x8(%ebp),%edx
    16bd:	8b 0a                	mov    (%edx),%ecx
    16bf:	89 c2                	mov    %eax,%edx
    16c1:	c1 fa 1f             	sar    $0x1f,%edx
    16c4:	f7 f9                	idiv   %ecx
    16c6:	8b 45 08             	mov    0x8(%ebp),%eax
    16c9:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
    16cc:	8b 45 08             	mov    0x8(%ebp),%eax
    16cf:	8b 40 04             	mov    0x4(%eax),%eax
    16d2:	89 04 24             	mov    %eax,(%esp)
    16d5:	e8 de f7 ff ff       	call   eb8 <binary_semaphore_up>
  semaphore_up(bb->empty);
    16da:	8b 45 08             	mov    0x8(%ebp),%eax
    16dd:	8b 40 08             	mov    0x8(%eax),%eax
    16e0:	89 04 24             	mov    %eax,(%esp)
    16e3:	e8 6e fd ff ff       	call   1456 <semaphore_up>
  return element_to_pop;
    16e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->empty);
  
  return element_to_pop;*/
}
    16eb:	c9                   	leave  
    16ec:	c3                   	ret    

000016ed <BB_free>:

void BB_free(struct BB* bb){
    16ed:	55                   	push   %ebp
    16ee:	89 e5                	mov    %esp,%ebp
    16f0:	83 ec 18             	sub    $0x18,%esp
  free(bb->pointer_to_elements);
    16f3:	8b 45 08             	mov    0x8(%ebp),%eax
    16f6:	8b 40 1c             	mov    0x1c(%eax),%eax
    16f9:	89 04 24             	mov    %eax,(%esp)
    16fc:	e8 4b fa ff ff       	call   114c <free>
  free(bb);
    1701:	8b 45 08             	mov    0x8(%ebp),%eax
    1704:	89 04 24             	mov    %eax,(%esp)
    1707:	e8 40 fa ff ff       	call   114c <free>
    170c:	c9                   	leave  
    170d:	c3                   	ret    
