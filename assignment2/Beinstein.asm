
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
       6:	a1 70 1e 00 00       	mov    0x1e70,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 30 14 00 00       	call   1443 <semaphore_down>
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
      1b:	a1 70 1e 00 00       	mov    0x1e70,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 72 14 00 00       	call   149a <semaphore_up>
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
      30:	a1 78 1e 00 00       	mov    0x1e78,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 92 15 00 00       	call   15d6 <BB_put>
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
      4c:	a1 78 1e 00 00       	mov    0x1e78,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 e2 15 00 00       	call   163b <BB_pop>
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
      61:	a1 88 1e 00 00       	mov    0x1e88,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 61 15 00 00       	call   15d6 <BB_put>
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
      7d:	a1 88 1e 00 00       	mov    0x1e88,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 b1 15 00 00       	call   163b <BB_pop>
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
      92:	a1 90 1e 00 00       	mov    0x1e90,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 9c 15 00 00       	call   163b <BB_pop>
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
      a7:	a1 90 1e 00 00       	mov    0x1e90,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 1b 15 00 00       	call   15d6 <BB_put>
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
      c3:	a1 7c 1e 00 00       	mov    0x1e7c,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 ff 14 00 00       	call   15d6 <BB_put>
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
      df:	a1 7c 1e 00 00       	mov    0x1e7c,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 4f 15 00 00       	call   163b <BB_pop>
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
     102:	a1 80 1e 00 00       	mov    0x1e80,%eax
     107:	89 04 24             	mov    %eax,(%esp)
     10a:	e8 e5 0d 00 00       	call   ef4 <binary_semaphore_down>
    int k = thread_getId();
     10f:	e8 b8 0d 00 00       	call   ecc <thread_getId>
     114:	89 45 ec             	mov    %eax,-0x14(%ebp)
    binary_semaphore_up(general_mutex);
     117:	a1 80 1e 00 00       	mov    0x1e80,%eax
     11c:	89 04 24             	mov    %eax,(%esp)
     11f:	e8 d8 0d 00 00       	call   efc <binary_semaphore_up>
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
     15c:	e8 5e 11 00 00       	call   12bf <malloc>
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
     18d:	a1 80 1e 00 00       	mov    0x1e80,%eax
     192:	89 04 24             	mov    %eax,(%esp)
     195:	e8 5a 0d 00 00       	call   ef4 <binary_semaphore_down>
	printf(1,"Student %d is having his %d drink, with cup %d\n",thread_getId(),i+1,student_action->cup->id);
     19a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     19d:	8b 40 04             	mov    0x4(%eax),%eax
     1a0:	8b 18                	mov    (%eax),%ebx
     1a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1a5:	8d 70 01             	lea    0x1(%eax),%esi
     1a8:	e8 1f 0d 00 00       	call   ecc <thread_getId>
     1ad:	89 5c 24 10          	mov    %ebx,0x10(%esp)
     1b1:	89 74 24 0c          	mov    %esi,0xc(%esp)
     1b5:	89 44 24 08          	mov    %eax,0x8(%esp)
     1b9:	c7 44 24 04 0c 17 00 	movl   $0x170c,0x4(%esp)
     1c0:	00 
     1c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1c8:	e8 0e 0e 00 00       	call   fdb <printf>
	binary_semaphore_up(general_mutex);
     1cd:	a1 80 1e 00 00       	mov    0x1e80,%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 22 0d 00 00       	call   efc <binary_semaphore_up>
	sleep(1);
     1da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1e1:	e8 ce 0c 00 00       	call   eb4 <sleep>
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
     20a:	a1 80 1e 00 00       	mov    0x1e80,%eax
     20f:	89 04 24             	mov    %eax,(%esp)
     212:	e8 dd 0c 00 00       	call   ef4 <binary_semaphore_down>
    printf(1,"Student %d is drunk, and trying to go home\n",thread_getId());
     217:	e8 b0 0c 00 00       	call   ecc <thread_getId>
     21c:	89 44 24 08          	mov    %eax,0x8(%esp)
     220:	c7 44 24 04 3c 17 00 	movl   $0x173c,0x4(%esp)
     227:	00 
     228:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     22f:	e8 a7 0d 00 00       	call   fdb <printf>
    binary_semaphore_up(general_mutex);
     234:	a1 80 1e 00 00       	mov    0x1e80,%eax
     239:	89 04 24             	mov    %eax,(%esp)
     23c:	e8 bb 0c 00 00       	call   efc <binary_semaphore_up>
    leave_bar();
     241:	e8 cf fd ff ff       	call   15 <leave_bar>
    thread_exit(ret_val);
     246:	8b 45 f0             	mov    -0x10(%ebp),%eax
     249:	89 04 24             	mov    %eax,(%esp)
     24c:	e8 93 0c 00 00       	call   ee4 <thread_exit>
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
     279:	a1 80 1e 00 00       	mov    0x1e80,%eax
     27e:	89 04 24             	mov    %eax,(%esp)
     281:	e8 6e 0c 00 00       	call   ef4 <binary_semaphore_down>
	if(((DBB->count * 100) / DBB->buffer_size) >= 60){ //wakeup cup_boy
     286:	a1 7c 1e 00 00       	mov    0x1e7c,%eax
     28b:	8b 40 10             	mov    0x10(%eax),%eax
     28e:	6b c0 64             	imul   $0x64,%eax,%eax
     291:	8b 15 7c 1e 00 00    	mov    0x1e7c,%edx
     297:	8b 12                	mov    (%edx),%edx
     299:	89 55 e4             	mov    %edx,-0x1c(%ebp)
     29c:	89 c2                	mov    %eax,%edx
     29e:	c1 fa 1f             	sar    $0x1f,%edx
     2a1:	f7 7d e4             	idivl  -0x1c(%ebp)
     2a4:	83 f8 3b             	cmp    $0x3b,%eax
     2a7:	7e 0d                	jle    2b6 <bartender+0x59>
	  binary_semaphore_up(cup_boy_lock);
     2a9:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
     2ae:	89 04 24             	mov    %eax,(%esp)
     2b1:	e8 46 0c 00 00       	call   efc <binary_semaphore_up>
	}
	binary_semaphore_up(general_mutex);
     2b6:	a1 80 1e 00 00       	mov    0x1e80,%eax
     2bb:	89 04 24             	mov    %eax,(%esp)
     2be:	e8 39 0c 00 00       	call   efc <binary_semaphore_up>
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
     2dd:	a1 80 1e 00 00       	mov    0x1e80,%eax
     2e2:	89 04 24             	mov    %eax,(%esp)
     2e5:	e8 0a 0c 00 00       	call   ef4 <binary_semaphore_down>
	    printf(1,"Bartender %d is making drink with cup %d\n",thread_getId(),current_cup->id);
     2ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2ed:	8b 18                	mov    (%eax),%ebx
     2ef:	e8 d8 0b 00 00       	call   ecc <thread_getId>
     2f4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     2f8:	89 44 24 08          	mov    %eax,0x8(%esp)
     2fc:	c7 44 24 04 68 17 00 	movl   $0x1768,0x4(%esp)
     303:	00 
     304:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     30b:	e8 cb 0c 00 00       	call   fdb <printf>
	    binary_semaphore_up(general_mutex);
     310:	a1 80 1e 00 00       	mov    0x1e80,%eax
     315:	89 04 24             	mov    %eax,(%esp)
     318:	e8 df 0b 00 00       	call   efc <binary_semaphore_up>
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
     33d:	a1 80 1e 00 00       	mov    0x1e80,%eax
     342:	89 04 24             	mov    %eax,(%esp)
     345:	e8 aa 0b 00 00       	call   ef4 <binary_semaphore_down>
	    printf(1,"Bartender %d returned cup %d\n",thread_getId(),current_cup->id);
     34a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     34d:	8b 18                	mov    (%eax),%ebx
     34f:	e8 78 0b 00 00       	call   ecc <thread_getId>
     354:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     358:	89 44 24 08          	mov    %eax,0x8(%esp)
     35c:	c7 44 24 04 92 17 00 	movl   $0x1792,0x4(%esp)
     363:	00 
     364:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     36b:	e8 6b 0c 00 00       	call   fdb <printf>
	    binary_semaphore_up(general_mutex);
     370:	a1 80 1e 00 00       	mov    0x1e80,%eax
     375:	89 04 24             	mov    %eax,(%esp)
     378:	e8 7f 0b 00 00       	call   efc <binary_semaphore_up>
	}
	if(bartender_action->action_type == GO_HOME){
     37d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     380:	8b 00                	mov    (%eax),%eax
     382:	83 f8 03             	cmp    $0x3,%eax
     385:	75 0b                	jne    392 <bartender+0x135>
	  thread_exit(ret_val);
     387:	8b 45 f0             	mov    -0x10(%ebp),%eax
     38a:	89 04 24             	mov    %eax,(%esp)
     38d:	e8 52 0b 00 00       	call   ee4 <thread_exit>
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
     3be:	e8 29 0b 00 00       	call   eec <binary_semaphore_create>
     3c3:	a3 8c 1e 00 00       	mov    %eax,0x1e8c
  for(;;){
    if(finished_shift){
     3c8:	a1 74 1e 00 00       	mov    0x1e74,%eax
     3cd:	85 c0                	test   %eax,%eax
     3cf:	74 0b                	je     3dc <cup_boy+0x32>
	thread_exit(ret_val);
     3d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3d4:	89 04 24             	mov    %eax,(%esp)
     3d7:	e8 08 0b 00 00       	call   ee4 <thread_exit>
    }
    int n = DBB->count;
     3dc:	a1 7c 1e 00 00       	mov    0x1e7c,%eax
     3e1:	8b 40 10             	mov    0x10(%eax),%eax
     3e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int i;
    struct Cup* current_cup = 0;
     3e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    //test for
    binary_semaphore_down(general_mutex);
     3ee:	a1 80 1e 00 00       	mov    0x1e80,%eax
     3f3:	89 04 24             	mov    %eax,(%esp)
     3f6:	e8 f9 0a 00 00       	call   ef4 <binary_semaphore_down>
    printf(1,"Big for\n");
     3fb:	c7 44 24 04 b0 17 00 	movl   $0x17b0,0x4(%esp)
     402:	00 
     403:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     40a:	e8 cc 0b 00 00       	call   fdb <printf>
    binary_semaphore_up(general_mutex);
     40f:	a1 80 1e 00 00       	mov    0x1e80,%eax
     414:	89 04 24             	mov    %eax,(%esp)
     417:	e8 e0 0a 00 00       	call   efc <binary_semaphore_up>
    
    
    for(i = 0; i < n; i++){
     41c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     423:	eb 6e                	jmp    493 <cup_boy+0xe9>
	current_cup = wash_dirty();
     425:	e8 af fc ff ff       	call   d9 <wash_dirty>
     42a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sleep(1);
     42d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     434:	e8 7b 0a 00 00       	call   eb4 <sleep>
	add_clean_cup(current_cup);
     439:	8b 45 e8             	mov    -0x18(%ebp),%eax
     43c:	89 04 24             	mov    %eax,(%esp)
     43f:	e8 5d fc ff ff       	call   a1 <add_clean_cup>
	//need to write to file intsead of screen TODO
	binary_semaphore_down(general_mutex);
     444:	a1 80 1e 00 00       	mov    0x1e80,%eax
     449:	89 04 24             	mov    %eax,(%esp)
     44c:	e8 a3 0a 00 00       	call   ef4 <binary_semaphore_down>
	 printf(1,"Small for\n");
     451:	c7 44 24 04 b9 17 00 	movl   $0x17b9,0x4(%esp)
     458:	00 
     459:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     460:	e8 76 0b 00 00       	call   fdb <printf>
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
     465:	8b 45 e8             	mov    -0x18(%ebp),%eax
     468:	8b 00                	mov    (%eax),%eax
     46a:	89 44 24 08          	mov    %eax,0x8(%esp)
     46e:	c7 44 24 04 c4 17 00 	movl   $0x17c4,0x4(%esp)
     475:	00 
     476:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     47d:	e8 59 0b 00 00       	call   fdb <printf>
	binary_semaphore_up(general_mutex);
     482:	a1 80 1e 00 00       	mov    0x1e80,%eax
     487:	89 04 24             	mov    %eax,(%esp)
     48a:	e8 6d 0a 00 00       	call   efc <binary_semaphore_up>
    binary_semaphore_down(general_mutex);
    printf(1,"Big for\n");
    binary_semaphore_up(general_mutex);
    
    
    for(i = 0; i < n; i++){
     48f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     493:	8b 45 f4             	mov    -0xc(%ebp),%eax
     496:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     499:	7c 8a                	jl     425 <cup_boy+0x7b>
	binary_semaphore_down(general_mutex);
	 printf(1,"Small for\n");
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
	binary_semaphore_up(general_mutex);
    }
   binary_semaphore_down(cup_boy_lock); 
     49b:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
     4a0:	89 04 24             	mov    %eax,(%esp)
     4a3:	e8 4c 0a 00 00       	call   ef4 <binary_semaphore_down>
  }
     4a8:	e9 1b ff ff ff       	jmp    3c8 <cup_boy+0x1e>

000004ad <join_peoples>:
}

// thread_joins on students and bartenders
void join_peoples(int* tids,int num_of_peoples){
     4ad:	55                   	push   %ebp
     4ae:	89 e5                	mov    %esp,%ebp
     4b0:	83 ec 28             	sub    $0x28,%esp
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     4b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4ba:	eb 1e                	jmp    4da <join_peoples+0x2d>
      thread_join(tids[i],&ret_val);
     4bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4bf:	c1 e0 02             	shl    $0x2,%eax
     4c2:	03 45 08             	add    0x8(%ebp),%eax
     4c5:	8b 00                	mov    (%eax),%eax
     4c7:	8d 55 f0             	lea    -0x10(%ebp),%edx
     4ca:	89 54 24 04          	mov    %edx,0x4(%esp)
     4ce:	89 04 24             	mov    %eax,(%esp)
     4d1:	e8 06 0a 00 00       	call   edc <thread_join>

// thread_joins on students and bartenders
void join_peoples(int* tids,int num_of_peoples){
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     4d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     4da:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
     4e0:	7c da                	jl     4bc <join_peoples+0xf>
      thread_join(tids[i],&ret_val);
  }
}
     4e2:	c9                   	leave  
     4e3:	c3                   	ret    

000004e4 <release_workers>:


//release the workers(bartenders + cup_boy) that run in infinite loops 
void release_workers(int num_of_bartenders){
     4e4:	55                   	push   %ebp
     4e5:	89 e5                	mov    %esp,%ebp
     4e7:	83 ec 28             	sub    $0x28,%esp
 int i;
 struct Action* release_bartender_action = 0;
     4ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 release_bartender_action->action_type = GO_HOME;
     4f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4f4:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
 release_bartender_action->cup = 0;
     4fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 //release bartenders
 for(i = 0; i< num_of_bartenders; i++){
     504:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     50b:	eb 0f                	jmp    51c <release_workers+0x38>
    place_action(release_bartender_action);
     50d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     510:	89 04 24             	mov    %eax,(%esp)
     513:	e8 12 fb ff ff       	call   2a <place_action>
 int i;
 struct Action* release_bartender_action = 0;
 release_bartender_action->action_type = GO_HOME;
 release_bartender_action->cup = 0;
 //release bartenders
 for(i = 0; i< num_of_bartenders; i++){
     518:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     51c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51f:	3b 45 08             	cmp    0x8(%ebp),%eax
     522:	7c e9                	jl     50d <release_workers+0x29>
    place_action(release_bartender_action);
 }
 
 //release cup_boy
 binary_semaphore_up(cup_boy_lock);
     524:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
     529:	89 04 24             	mov    %eax,(%esp)
     52c:	e8 cb 09 00 00       	call   efc <binary_semaphore_up>
}
     531:	c9                   	leave  
     532:	c3                   	ret    

00000533 <values_array_index>:


//return the index to put the value {A, B, C, S, M}
//				     {0, 1, 2, 3, 4}
int values_array_index(char* input_buf, int char_index){
     533:	55                   	push   %ebp
     534:	89 e5                	mov    %esp,%ebp
 if(input_buf[char_index] == 'A')
     536:	8b 45 0c             	mov    0xc(%ebp),%eax
     539:	03 45 08             	add    0x8(%ebp),%eax
     53c:	0f b6 00             	movzbl (%eax),%eax
     53f:	3c 41                	cmp    $0x41,%al
     541:	75 07                	jne    54a <values_array_index+0x17>
   return 0;
     543:	b8 00 00 00 00       	mov    $0x0,%eax
     548:	eb 55                	jmp    59f <values_array_index+0x6c>
 if(input_buf[char_index] == 'B')
     54a:	8b 45 0c             	mov    0xc(%ebp),%eax
     54d:	03 45 08             	add    0x8(%ebp),%eax
     550:	0f b6 00             	movzbl (%eax),%eax
     553:	3c 42                	cmp    $0x42,%al
     555:	75 07                	jne    55e <values_array_index+0x2b>
   return 1;
     557:	b8 01 00 00 00       	mov    $0x1,%eax
     55c:	eb 41                	jmp    59f <values_array_index+0x6c>
 if(input_buf[char_index] == 'C')
     55e:	8b 45 0c             	mov    0xc(%ebp),%eax
     561:	03 45 08             	add    0x8(%ebp),%eax
     564:	0f b6 00             	movzbl (%eax),%eax
     567:	3c 43                	cmp    $0x43,%al
     569:	75 07                	jne    572 <values_array_index+0x3f>
   return 2;
     56b:	b8 02 00 00 00       	mov    $0x2,%eax
     570:	eb 2d                	jmp    59f <values_array_index+0x6c>
 if(input_buf[char_index] == 'S')
     572:	8b 45 0c             	mov    0xc(%ebp),%eax
     575:	03 45 08             	add    0x8(%ebp),%eax
     578:	0f b6 00             	movzbl (%eax),%eax
     57b:	3c 53                	cmp    $0x53,%al
     57d:	75 07                	jne    586 <values_array_index+0x53>
   return 3;
     57f:	b8 03 00 00 00       	mov    $0x3,%eax
     584:	eb 19                	jmp    59f <values_array_index+0x6c>
 if(input_buf[char_index] == 'M')
     586:	8b 45 0c             	mov    0xc(%ebp),%eax
     589:	03 45 08             	add    0x8(%ebp),%eax
     58c:	0f b6 00             	movzbl (%eax),%eax
     58f:	3c 4d                	cmp    $0x4d,%al
     591:	75 07                	jne    59a <values_array_index+0x67>
   return 4;
     593:	b8 04 00 00 00       	mov    $0x4,%eax
     598:	eb 05                	jmp    59f <values_array_index+0x6c>
 //error
 return -1;
     59a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     59f:	5d                   	pop    %ebp
     5a0:	c3                   	ret    

000005a1 <parse_buffer>:

//parsing the configuration file
void parse_buffer(char* input_buf,int* values_array){
     5a1:	55                   	push   %ebp
     5a2:	89 e5                	mov    %esp,%ebp
     5a4:	53                   	push   %ebx
     5a5:	83 ec 24             	sub    $0x24,%esp
 int i;
 int num_of_chars = strlen(input_buf);
     5a8:	8b 45 08             	mov    0x8(%ebp),%eax
     5ab:	89 04 24             	mov    %eax,(%esp)
     5ae:	e8 a7 06 00 00       	call   c5a <strlen>
     5b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     5b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     5bd:	eb 7e                	jmp    63d <parse_buffer+0x9c>
    if(input_buf[i] == 'A' || input_buf[i] == 'B' || input_buf[i] == 'C' || input_buf[i] == 'S' || input_buf[i] == 'M'){
     5bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5c2:	03 45 08             	add    0x8(%ebp),%eax
     5c5:	0f b6 00             	movzbl (%eax),%eax
     5c8:	3c 41                	cmp    $0x41,%al
     5ca:	74 34                	je     600 <parse_buffer+0x5f>
     5cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cf:	03 45 08             	add    0x8(%ebp),%eax
     5d2:	0f b6 00             	movzbl (%eax),%eax
     5d5:	3c 42                	cmp    $0x42,%al
     5d7:	74 27                	je     600 <parse_buffer+0x5f>
     5d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5dc:	03 45 08             	add    0x8(%ebp),%eax
     5df:	0f b6 00             	movzbl (%eax),%eax
     5e2:	3c 43                	cmp    $0x43,%al
     5e4:	74 1a                	je     600 <parse_buffer+0x5f>
     5e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5e9:	03 45 08             	add    0x8(%ebp),%eax
     5ec:	0f b6 00             	movzbl (%eax),%eax
     5ef:	3c 53                	cmp    $0x53,%al
     5f1:	74 0d                	je     600 <parse_buffer+0x5f>
     5f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f6:	03 45 08             	add    0x8(%ebp),%eax
     5f9:	0f b6 00             	movzbl (%eax),%eax
     5fc:	3c 4d                	cmp    $0x4d,%al
     5fe:	75 39                	jne    639 <parse_buffer+0x98>
       index = values_array_index(input_buf,i);
     600:	8b 45 f4             	mov    -0xc(%ebp),%eax
     603:	89 44 24 04          	mov    %eax,0x4(%esp)
     607:	8b 45 08             	mov    0x8(%ebp),%eax
     60a:	89 04 24             	mov    %eax,(%esp)
     60d:	e8 21 ff ff ff       	call   533 <values_array_index>
     612:	89 45 ec             	mov    %eax,-0x14(%ebp)
       temp_str = &input_buf[i];
     615:	8b 45 f4             	mov    -0xc(%ebp),%eax
     618:	03 45 08             	add    0x8(%ebp),%eax
     61b:	89 45 e8             	mov    %eax,-0x18(%ebp)
       values_array[index] = atoi(temp_str+4);
     61e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     621:	c1 e0 02             	shl    $0x2,%eax
     624:	89 c3                	mov    %eax,%ebx
     626:	03 5d 0c             	add    0xc(%ebp),%ebx
     629:	8b 45 e8             	mov    -0x18(%ebp),%eax
     62c:	83 c0 04             	add    $0x4,%eax
     62f:	89 04 24             	mov    %eax,(%esp)
     632:	e8 5c 07 00 00       	call   d93 <atoi>
     637:	89 03                	mov    %eax,(%ebx)
void parse_buffer(char* input_buf,int* values_array){
 int i;
 int num_of_chars = strlen(input_buf);
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     639:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     63d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     640:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     643:	0f 8c 76 ff ff ff    	jl     5bf <parse_buffer+0x1e>
       index = values_array_index(input_buf,i);
       temp_str = &input_buf[i];
       values_array[index] = atoi(temp_str+4);
    }
 }
}
     649:	83 c4 24             	add    $0x24,%esp
     64c:	5b                   	pop    %ebx
     64d:	5d                   	pop    %ebp
     64e:	c3                   	ret    

0000064f <main>:


int main(int argc, char** argv) {
     64f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     653:	83 e4 f0             	and    $0xfffffff0,%esp
     656:	ff 71 fc             	pushl  -0x4(%ecx)
     659:	55                   	push   %ebp
     65a:	89 e5                	mov    %esp,%ebp
     65c:	51                   	push   %ecx
     65d:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  int M;	// maximum number of students that can be at the bar at once
  int fconf;
  int conf_size;
  struct stat bufstat;
  
  fconf = open("con.conf",O_RDONLY);
     663:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     66a:	00 
     66b:	c7 04 24 e0 17 00 00 	movl   $0x17e0,(%esp)
     672:	e8 ed 07 00 00       	call   e64 <open>
     677:	89 45 f0             	mov    %eax,-0x10(%ebp)
  fstat(fconf,&bufstat);
     67a:	8d 45 8c             	lea    -0x74(%ebp),%eax
     67d:	89 44 24 04          	mov    %eax,0x4(%esp)
     681:	8b 45 f0             	mov    -0x10(%ebp),%eax
     684:	89 04 24             	mov    %eax,(%esp)
     687:	e8 f0 07 00 00       	call   e7c <fstat>
  conf_size = bufstat.size;
     68c:	8b 45 9c             	mov    -0x64(%ebp),%eax
     68f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  char bufconf[conf_size];
     692:	8b 45 ec             	mov    -0x14(%ebp),%eax
     695:	8d 50 ff             	lea    -0x1(%eax),%edx
     698:	89 55 e8             	mov    %edx,-0x18(%ebp)
     69b:	8d 50 0f             	lea    0xf(%eax),%edx
     69e:	b8 10 00 00 00       	mov    $0x10,%eax
     6a3:	83 e8 01             	sub    $0x1,%eax
     6a6:	01 d0                	add    %edx,%eax
     6a8:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     6af:	00 00 00 
     6b2:	ba 00 00 00 00       	mov    $0x0,%edx
     6b7:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     6bd:	6b c0 10             	imul   $0x10,%eax,%eax
     6c0:	29 c4                	sub    %eax,%esp
     6c2:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     6c6:	83 c0 0f             	add    $0xf,%eax
     6c9:	c1 e8 04             	shr    $0x4,%eax
     6cc:	c1 e0 04             	shl    $0x4,%eax
     6cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  read(fconf,bufconf,conf_size);
     6d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
     6d8:	89 54 24 08          	mov    %edx,0x8(%esp)
     6dc:	89 44 24 04          	mov    %eax,0x4(%esp)
     6e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6e3:	89 04 24             	mov    %eax,(%esp)
     6e6:	e8 51 07 00 00       	call   e3c <read>
  int inputs_parsed[5]; //{Aval, Bval, Cval, Sval, Mval}
  
  parse_buffer(bufconf, inputs_parsed);
     6eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6ee:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
     6f4:	89 54 24 04          	mov    %edx,0x4(%esp)
     6f8:	89 04 24             	mov    %eax,(%esp)
     6fb:	e8 a1 fe ff ff       	call   5a1 <parse_buffer>
  A = inputs_parsed[0];
     700:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
     706:	89 45 e0             	mov    %eax,-0x20(%ebp)
  B = inputs_parsed[1];
     709:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
     70f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  C = inputs_parsed[2];
     712:	8b 45 80             	mov    -0x80(%ebp),%eax
     715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  S = inputs_parsed[3];
     718:	8b 45 84             	mov    -0x7c(%ebp),%eax
     71b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  M = inputs_parsed[4];
     71e:	8b 45 88             	mov    -0x78(%ebp),%eax
     721:	89 45 d0             	mov    %eax,-0x30(%ebp)
  
  printf(1,"A: %d B: %d C: %d  S: %d M: %d\n",A,B,C,S,M);
     724:	8b 45 d0             	mov    -0x30(%ebp),%eax
     727:	89 44 24 18          	mov    %eax,0x18(%esp)
     72b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     72e:	89 44 24 14          	mov    %eax,0x14(%esp)
     732:	8b 45 d8             	mov    -0x28(%ebp),%eax
     735:	89 44 24 10          	mov    %eax,0x10(%esp)
     739:	8b 45 dc             	mov    -0x24(%ebp),%eax
     73c:	89 44 24 0c          	mov    %eax,0xc(%esp)
     740:	8b 45 e0             	mov    -0x20(%ebp),%eax
     743:	89 44 24 08          	mov    %eax,0x8(%esp)
     747:	c7 44 24 04 ec 17 00 	movl   $0x17ec,0x4(%esp)
     74e:	00 
     74f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     756:	e8 80 08 00 00       	call   fdb <printf>
  
  void* students_stacks[S];
     75b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     75e:	8d 50 ff             	lea    -0x1(%eax),%edx
     761:	89 55 cc             	mov    %edx,-0x34(%ebp)
     764:	c1 e0 02             	shl    $0x2,%eax
     767:	8d 50 0f             	lea    0xf(%eax),%edx
     76a:	b8 10 00 00 00       	mov    $0x10,%eax
     76f:	83 e8 01             	sub    $0x1,%eax
     772:	01 d0                	add    %edx,%eax
     774:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     77b:	00 00 00 
     77e:	ba 00 00 00 00       	mov    $0x0,%edx
     783:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     789:	6b c0 10             	imul   $0x10,%eax,%eax
     78c:	29 c4                	sub    %eax,%esp
     78e:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     792:	83 c0 0f             	add    $0xf,%eax
     795:	c1 e8 04             	shr    $0x4,%eax
     798:	c1 e0 04             	shl    $0x4,%eax
     79b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  void* bartenders_stacks[B];
     79e:	8b 45 dc             	mov    -0x24(%ebp),%eax
     7a1:	8d 50 ff             	lea    -0x1(%eax),%edx
     7a4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
     7a7:	c1 e0 02             	shl    $0x2,%eax
     7aa:	8d 50 0f             	lea    0xf(%eax),%edx
     7ad:	b8 10 00 00 00       	mov    $0x10,%eax
     7b2:	83 e8 01             	sub    $0x1,%eax
     7b5:	01 d0                	add    %edx,%eax
     7b7:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     7be:	00 00 00 
     7c1:	ba 00 00 00 00       	mov    $0x0,%edx
     7c6:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     7cc:	6b c0 10             	imul   $0x10,%eax,%eax
     7cf:	29 c4                	sub    %eax,%esp
     7d1:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     7d5:	83 c0 0f             	add    $0xf,%eax
     7d8:	c1 e8 04             	shr    $0x4,%eax
     7db:	c1 e0 04             	shl    $0x4,%eax
     7de:	89 45 c0             	mov    %eax,-0x40(%ebp)
  void* cup_boy_stack;
  int i;
  int student_tids[S];
     7e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7e4:	8d 50 ff             	lea    -0x1(%eax),%edx
     7e7:	89 55 bc             	mov    %edx,-0x44(%ebp)
     7ea:	c1 e0 02             	shl    $0x2,%eax
     7ed:	8d 50 0f             	lea    0xf(%eax),%edx
     7f0:	b8 10 00 00 00       	mov    $0x10,%eax
     7f5:	83 e8 01             	sub    $0x1,%eax
     7f8:	01 d0                	add    %edx,%eax
     7fa:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     801:	00 00 00 
     804:	ba 00 00 00 00       	mov    $0x0,%edx
     809:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     80f:	6b c0 10             	imul   $0x10,%eax,%eax
     812:	29 c4                	sub    %eax,%esp
     814:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     818:	83 c0 0f             	add    $0xf,%eax
     81b:	c1 e8 04             	shr    $0x4,%eax
     81e:	c1 e0 04             	shl    $0x4,%eax
     821:	89 45 b8             	mov    %eax,-0x48(%ebp)
  int bartender_tids[B];
     824:	8b 45 dc             	mov    -0x24(%ebp),%eax
     827:	8d 50 ff             	lea    -0x1(%eax),%edx
     82a:	89 55 b4             	mov    %edx,-0x4c(%ebp)
     82d:	c1 e0 02             	shl    $0x2,%eax
     830:	8d 50 0f             	lea    0xf(%eax),%edx
     833:	b8 10 00 00 00       	mov    $0x10,%eax
     838:	83 e8 01             	sub    $0x1,%eax
     83b:	01 d0                	add    %edx,%eax
     83d:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     844:	00 00 00 
     847:	ba 00 00 00 00       	mov    $0x0,%edx
     84c:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     852:	6b c0 10             	imul   $0x10,%eax,%eax
     855:	29 c4                	sub    %eax,%esp
     857:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     85b:	83 c0 0f             	add    $0xf,%eax
     85e:	c1 e8 04             	shr    $0x4,%eax
     861:	c1 e0 04             	shl    $0x4,%eax
     864:	89 45 b0             	mov    %eax,-0x50(%ebp)
  int finished_shift = 0; // cup_boy changes it to 1 if all students left the bar and sends Action => GO_HOME to bartenders
     867:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)

  
  file_to_write = open("out.txt",(O_CREATE | O_WRONLY)); //
     86e:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     875:	00 
     876:	c7 04 24 0c 18 00 00 	movl   $0x180c,(%esp)
     87d:	e8 e2 05 00 00       	call   e64 <open>
     882:	a3 84 1e 00 00       	mov    %eax,0x1e84
  if(file_to_write == -1){
     887:	a1 84 1e 00 00       	mov    0x1e84,%eax
     88c:	83 f8 ff             	cmp    $0xffffffff,%eax
     88f:	75 19                	jne    8aa <main+0x25b>
      printf(1,"There was an error opening out.txt\n");
     891:	c7 44 24 04 14 18 00 	movl   $0x1814,0x4(%esp)
     898:	00 
     899:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8a0:	e8 36 07 00 00       	call   fdb <printf>
      exit();
     8a5:	e8 7a 05 00 00       	call   e24 <exit>
  }
  
  
  //Databases
   bouncer = semaphore_create(M);		//this is the bouncer to the Beinstein
     8aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
     8ad:	89 04 24             	mov    %eax,(%esp)
     8b0:	e8 eb 0a 00 00       	call   13a0 <semaphore_create>
     8b5:	a3 70 1e 00 00       	mov    %eax,0x1e70
   ABB = BB_create(A); 				//this is a BB for student actions: drink, ans for a dring
     8ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
     8bd:	89 04 24             	mov    %eax,(%esp)
     8c0:	e8 33 0c 00 00       	call   14f8 <BB_create>
     8c5:	a3 78 1e 00 00       	mov    %eax,0x1e78
   DrinkBB = BB_create(A);			//this is a BB holding the drinks that are ready to be drinking
     8ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
     8cd:	89 04 24             	mov    %eax,(%esp)
     8d0:	e8 23 0c 00 00       	call   14f8 <BB_create>
     8d5:	a3 88 1e 00 00       	mov    %eax,0x1e88
   CBB = BB_create(C);				//this is a BB hold clean cups
     8da:	8b 45 d8             	mov    -0x28(%ebp),%eax
     8dd:	89 04 24             	mov    %eax,(%esp)
     8e0:	e8 13 0c 00 00       	call   14f8 <BB_create>
     8e5:	a3 90 1e 00 00       	mov    %eax,0x1e90
   DBB = BB_create(C);				//this is a BB hold dirty cups
     8ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
     8ed:	89 04 24             	mov    %eax,(%esp)
     8f0:	e8 03 0c 00 00       	call   14f8 <BB_create>
     8f5:	a3 7c 1e 00 00       	mov    %eax,0x1e7c
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
     8fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     901:	e8 e6 05 00 00       	call   eec <binary_semaphore_create>
     906:	a3 8c 1e 00 00       	mov    %eax,0x1e8c
   general_mutex = binary_semaphore_create(1);
     90b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     912:	e8 d5 05 00 00       	call   eec <binary_semaphore_create>
     917:	a3 80 1e 00 00       	mov    %eax,0x1e80

   //initialize C clean cups
   struct Cup* cup_array[C];
     91c:	8b 45 d8             	mov    -0x28(%ebp),%eax
     91f:	8d 50 ff             	lea    -0x1(%eax),%edx
     922:	89 55 a8             	mov    %edx,-0x58(%ebp)
     925:	c1 e0 02             	shl    $0x2,%eax
     928:	8d 50 0f             	lea    0xf(%eax),%edx
     92b:	b8 10 00 00 00       	mov    $0x10,%eax
     930:	83 e8 01             	sub    $0x1,%eax
     933:	01 d0                	add    %edx,%eax
     935:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     93c:	00 00 00 
     93f:	ba 00 00 00 00       	mov    $0x0,%edx
     944:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     94a:	6b c0 10             	imul   $0x10,%eax,%eax
     94d:	29 c4                	sub    %eax,%esp
     94f:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     953:	83 c0 0f             	add    $0xf,%eax
     956:	c1 e8 04             	shr    $0x4,%eax
     959:	c1 e0 04             	shl    $0x4,%eax
     95c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
   for(i = 0; i < C; i++){
     95f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     966:	eb 38                	jmp    9a0 <main+0x351>
      cup_array[i] = (Cup*)malloc(sizeof(Cup)); //TODO free cups
     968:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     96f:	e8 4b 09 00 00       	call   12bf <malloc>
     974:	8b 55 a4             	mov    -0x5c(%ebp),%edx
     977:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     97a:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      cup_array[i]->id = i;
     97d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     980:	8b 55 f4             	mov    -0xc(%ebp),%edx
     983:	8b 04 90             	mov    (%eax,%edx,4),%eax
     986:	8b 55 f4             	mov    -0xc(%ebp),%edx
     989:	89 10                	mov    %edx,(%eax)
      add_clean_cup(cup_array[i]);
     98b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     98e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     991:	8b 04 90             	mov    (%eax,%edx,4),%eax
     994:	89 04 24             	mov    %eax,(%esp)
     997:	e8 05 f7 ff ff       	call   a1 <add_clean_cup>
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
   general_mutex = binary_semaphore_create(1);

   //initialize C clean cups
   struct Cup* cup_array[C];
   for(i = 0; i < C; i++){
     99c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9a3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     9a6:	7c c0                	jl     968 <main+0x319>
      cup_array[i]->id = i;
      add_clean_cup(cup_array[i]);
   }
   
   //initialize cup_boy
   cup_boy_stack = (void*)malloc(STACK_SIZE);
     9a8:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
     9af:	e8 0b 09 00 00       	call   12bf <malloc>
     9b4:	89 45 a0             	mov    %eax,-0x60(%ebp)
   thread_create((void*)cup_boy,cup_boy_stack,STACK_SIZE); 
     9b7:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     9be:	00 
     9bf:	8b 45 a0             	mov    -0x60(%ebp),%eax
     9c2:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c6:	c7 04 24 aa 03 00 00 	movl   $0x3aa,(%esp)
     9cd:	e8 f2 04 00 00       	call   ec4 <thread_create>
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     9d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9d9:	eb 43                	jmp    a1e <main+0x3cf>
      bartenders_stacks[i] = (void*)malloc(STACK_SIZE);
     9db:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
     9e2:	e8 d8 08 00 00       	call   12bf <malloc>
     9e7:	8b 55 c0             	mov    -0x40(%ebp),%edx
     9ea:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     9ed:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],STACK_SIZE);
     9f0:	8b 45 c0             	mov    -0x40(%ebp),%eax
     9f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9f6:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9f9:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     a00:	00 
     a01:	89 44 24 04          	mov    %eax,0x4(%esp)
     a05:	c7 04 24 5d 02 00 00 	movl   $0x25d,(%esp)
     a0c:	e8 b3 04 00 00       	call   ec4 <thread_create>
     a11:	8b 55 b0             	mov    -0x50(%ebp),%edx
     a14:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a17:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
   //initialize cup_boy
   cup_boy_stack = (void*)malloc(STACK_SIZE);
   thread_create((void*)cup_boy,cup_boy_stack,STACK_SIZE); 
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     a1a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a21:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     a24:	7c b5                	jl     9db <main+0x38c>
      bartenders_stacks[i] = (void*)malloc(STACK_SIZE);
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],STACK_SIZE);
  }
   
   //initialize S students
   for(i = 0; i < S; i++){
     a26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a2d:	eb 43                	jmp    a72 <main+0x423>
      students_stacks[i] = (void*)malloc(STACK_SIZE);
     a2f:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
     a36:	e8 84 08 00 00       	call   12bf <malloc>
     a3b:	8b 55 c8             	mov    -0x38(%ebp),%edx
     a3e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a41:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      student_tids[i] = thread_create((void*)student,students_stacks[i],STACK_SIZE);
     a44:	8b 45 c8             	mov    -0x38(%ebp),%eax
     a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a4a:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a4d:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     a54:	00 
     a55:	89 44 24 04          	mov    %eax,0x4(%esp)
     a59:	c7 04 24 ee 00 00 00 	movl   $0xee,(%esp)
     a60:	e8 5f 04 00 00       	call   ec4 <thread_create>
     a65:	8b 55 b8             	mov    -0x48(%ebp),%edx
     a68:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a6b:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      bartenders_stacks[i] = (void*)malloc(STACK_SIZE);
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],STACK_SIZE);
  }
   
   //initialize S students
   for(i = 0; i < S; i++){
     a6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a75:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     a78:	7c b5                	jl     a2f <main+0x3e0>
      student_tids[i] = thread_create((void*)student,students_stacks[i],STACK_SIZE);
  }
  

   
   join_peoples(student_tids,S); //join students
     a7a:	8b 45 b8             	mov    -0x48(%ebp),%eax
     a7d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     a80:	89 54 24 04          	mov    %edx,0x4(%esp)
     a84:	89 04 24             	mov    %eax,(%esp)
     a87:	e8 21 fa ff ff       	call   4ad <join_peoples>
   finished_shift = 1;
     a8c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
   if(finished_shift){
     a93:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
     a97:	74 0d                	je     aa6 <main+0x457>
    binary_semaphore_up(cup_boy_lock); 
     a99:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
     a9e:	89 04 24             	mov    %eax,(%esp)
     aa1:	e8 56 04 00 00       	call   efc <binary_semaphore_up>
   }
   release_workers(B);
     aa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
     aa9:	89 04 24             	mov    %eax,(%esp)
     aac:	e8 33 fa ff ff       	call   4e4 <release_workers>
   join_peoples(bartender_tids,B); //join bartenders
     ab1:	8b 45 b0             	mov    -0x50(%ebp),%eax
     ab4:	8b 55 dc             	mov    -0x24(%ebp),%edx
     ab7:	89 54 24 04          	mov    %edx,0x4(%esp)
     abb:	89 04 24             	mov    %eax,(%esp)
     abe:	e8 ea f9 ff ff       	call   4ad <join_peoples>
   sleep(2); // delay so exit will not come before threads finished TODO (need better soloution)
     ac3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     aca:	e8 e5 03 00 00       	call   eb4 <sleep>
   
   if(close(file_to_write) == -1){
     acf:	a1 84 1e 00 00       	mov    0x1e84,%eax
     ad4:	89 04 24             	mov    %eax,(%esp)
     ad7:	e8 70 03 00 00       	call   e4c <close>
     adc:	83 f8 ff             	cmp    $0xffffffff,%eax
     adf:	75 19                	jne    afa <main+0x4ab>
    printf(1,"There was an error closing out.txt\n");
     ae1:	c7 44 24 04 38 18 00 	movl   $0x1838,0x4(%esp)
     ae8:	00 
     ae9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     af0:	e8 e6 04 00 00       	call   fdb <printf>
    exit();
     af5:	e8 2a 03 00 00       	call   e24 <exit>
   }
   
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     afa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b01:	eb 15                	jmp    b18 <main+0x4c9>
    free(cup_array[i]);
     b03:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     b06:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b09:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b0c:	89 04 24             	mov    %eax,(%esp)
     b0f:	e8 7c 06 00 00       	call   1190 <free>
    exit();
   }
   
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     b14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b1b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     b1e:	7c e3                	jl     b03 <main+0x4b4>
    free(cup_array[i]);
  }
  
  //free cup_boy_stack
  free(cup_boy_stack);
     b20:	8b 45 a0             	mov    -0x60(%ebp),%eax
     b23:	89 04 24             	mov    %eax,(%esp)
     b26:	e8 65 06 00 00       	call   1190 <free>
  
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b32:	eb 15                	jmp    b49 <main+0x4fa>
   free(bartenders_stacks[i]); 
     b34:	8b 45 c0             	mov    -0x40(%ebp),%eax
     b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b3a:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b3d:	89 04 24             	mov    %eax,(%esp)
     b40:	e8 4b 06 00 00       	call   1190 <free>
  
  //free cup_boy_stack
  free(cup_boy_stack);
  
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     b45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b4c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     b4f:	7c e3                	jl     b34 <main+0x4e5>
   free(bartenders_stacks[i]); 
  }
  
  //free students_stacks
  for(i = 0; i < S; i++){
     b51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b58:	eb 15                	jmp    b6f <main+0x520>
   free(students_stacks[i]); 
     b5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
     b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b60:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b63:	89 04 24             	mov    %eax,(%esp)
     b66:	e8 25 06 00 00       	call   1190 <free>
  for(i = 0; i < B; i++){
   free(bartenders_stacks[i]); 
  }
  
  //free students_stacks
  for(i = 0; i < S; i++){
     b6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b72:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     b75:	7c e3                	jl     b5a <main+0x50b>
   free(students_stacks[i]); 
  }
  
  semaphore_free(bouncer);
     b77:	a1 70 1e 00 00       	mov    0x1e70,%eax
     b7c:	89 04 24             	mov    %eax,(%esp)
     b7f:	e8 60 09 00 00       	call   14e4 <semaphore_free>
  BB_free(ABB);
     b84:	a1 78 1e 00 00       	mov    0x1e78,%eax
     b89:	89 04 24             	mov    %eax,(%esp)
     b8c:	e8 66 0b 00 00       	call   16f7 <BB_free>
  BB_free(DrinkBB);
     b91:	a1 88 1e 00 00       	mov    0x1e88,%eax
     b96:	89 04 24             	mov    %eax,(%esp)
     b99:	e8 59 0b 00 00       	call   16f7 <BB_free>
  BB_free(CBB);
     b9e:	a1 90 1e 00 00       	mov    0x1e90,%eax
     ba3:	89 04 24             	mov    %eax,(%esp)
     ba6:	e8 4c 0b 00 00       	call   16f7 <BB_free>
  BB_free(DBB);
     bab:	a1 7c 1e 00 00       	mov    0x1e7c,%eax
     bb0:	89 04 24             	mov    %eax,(%esp)
     bb3:	e8 3f 0b 00 00       	call   16f7 <BB_free>
 
  exit();
     bb8:	e8 67 02 00 00       	call   e24 <exit>
     bbd:	90                   	nop
     bbe:	90                   	nop
     bbf:	90                   	nop

00000bc0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     bc0:	55                   	push   %ebp
     bc1:	89 e5                	mov    %esp,%ebp
     bc3:	57                   	push   %edi
     bc4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     bc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
     bc8:	8b 55 10             	mov    0x10(%ebp),%edx
     bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
     bce:	89 cb                	mov    %ecx,%ebx
     bd0:	89 df                	mov    %ebx,%edi
     bd2:	89 d1                	mov    %edx,%ecx
     bd4:	fc                   	cld    
     bd5:	f3 aa                	rep stos %al,%es:(%edi)
     bd7:	89 ca                	mov    %ecx,%edx
     bd9:	89 fb                	mov    %edi,%ebx
     bdb:	89 5d 08             	mov    %ebx,0x8(%ebp)
     bde:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     be1:	5b                   	pop    %ebx
     be2:	5f                   	pop    %edi
     be3:	5d                   	pop    %ebp
     be4:	c3                   	ret    

00000be5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     be5:	55                   	push   %ebp
     be6:	89 e5                	mov    %esp,%ebp
     be8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     beb:	8b 45 08             	mov    0x8(%ebp),%eax
     bee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     bf1:	90                   	nop
     bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
     bf5:	0f b6 10             	movzbl (%eax),%edx
     bf8:	8b 45 08             	mov    0x8(%ebp),%eax
     bfb:	88 10                	mov    %dl,(%eax)
     bfd:	8b 45 08             	mov    0x8(%ebp),%eax
     c00:	0f b6 00             	movzbl (%eax),%eax
     c03:	84 c0                	test   %al,%al
     c05:	0f 95 c0             	setne  %al
     c08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     c0c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     c10:	84 c0                	test   %al,%al
     c12:	75 de                	jne    bf2 <strcpy+0xd>
    ;
  return os;
     c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     c17:	c9                   	leave  
     c18:	c3                   	ret    

00000c19 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c19:	55                   	push   %ebp
     c1a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     c1c:	eb 08                	jmp    c26 <strcmp+0xd>
    p++, q++;
     c1e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     c22:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     c26:	8b 45 08             	mov    0x8(%ebp),%eax
     c29:	0f b6 00             	movzbl (%eax),%eax
     c2c:	84 c0                	test   %al,%al
     c2e:	74 10                	je     c40 <strcmp+0x27>
     c30:	8b 45 08             	mov    0x8(%ebp),%eax
     c33:	0f b6 10             	movzbl (%eax),%edx
     c36:	8b 45 0c             	mov    0xc(%ebp),%eax
     c39:	0f b6 00             	movzbl (%eax),%eax
     c3c:	38 c2                	cmp    %al,%dl
     c3e:	74 de                	je     c1e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     c40:	8b 45 08             	mov    0x8(%ebp),%eax
     c43:	0f b6 00             	movzbl (%eax),%eax
     c46:	0f b6 d0             	movzbl %al,%edx
     c49:	8b 45 0c             	mov    0xc(%ebp),%eax
     c4c:	0f b6 00             	movzbl (%eax),%eax
     c4f:	0f b6 c0             	movzbl %al,%eax
     c52:	89 d1                	mov    %edx,%ecx
     c54:	29 c1                	sub    %eax,%ecx
     c56:	89 c8                	mov    %ecx,%eax
}
     c58:	5d                   	pop    %ebp
     c59:	c3                   	ret    

00000c5a <strlen>:

uint
strlen(char *s)
{
     c5a:	55                   	push   %ebp
     c5b:	89 e5                	mov    %esp,%ebp
     c5d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     c60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     c67:	eb 04                	jmp    c6d <strlen+0x13>
     c69:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c70:	03 45 08             	add    0x8(%ebp),%eax
     c73:	0f b6 00             	movzbl (%eax),%eax
     c76:	84 c0                	test   %al,%al
     c78:	75 ef                	jne    c69 <strlen+0xf>
    ;
  return n;
     c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     c7d:	c9                   	leave  
     c7e:	c3                   	ret    

00000c7f <memset>:

void*
memset(void *dst, int c, uint n)
{
     c7f:	55                   	push   %ebp
     c80:	89 e5                	mov    %esp,%ebp
     c82:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     c85:	8b 45 10             	mov    0x10(%ebp),%eax
     c88:	89 44 24 08          	mov    %eax,0x8(%esp)
     c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
     c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
     c93:	8b 45 08             	mov    0x8(%ebp),%eax
     c96:	89 04 24             	mov    %eax,(%esp)
     c99:	e8 22 ff ff ff       	call   bc0 <stosb>
  return dst;
     c9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ca1:	c9                   	leave  
     ca2:	c3                   	ret    

00000ca3 <strchr>:

char*
strchr(const char *s, char c)
{
     ca3:	55                   	push   %ebp
     ca4:	89 e5                	mov    %esp,%ebp
     ca6:	83 ec 04             	sub    $0x4,%esp
     ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
     cac:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     caf:	eb 14                	jmp    cc5 <strchr+0x22>
    if(*s == c)
     cb1:	8b 45 08             	mov    0x8(%ebp),%eax
     cb4:	0f b6 00             	movzbl (%eax),%eax
     cb7:	3a 45 fc             	cmp    -0x4(%ebp),%al
     cba:	75 05                	jne    cc1 <strchr+0x1e>
      return (char*)s;
     cbc:	8b 45 08             	mov    0x8(%ebp),%eax
     cbf:	eb 13                	jmp    cd4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     cc1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     cc5:	8b 45 08             	mov    0x8(%ebp),%eax
     cc8:	0f b6 00             	movzbl (%eax),%eax
     ccb:	84 c0                	test   %al,%al
     ccd:	75 e2                	jne    cb1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     ccf:	b8 00 00 00 00       	mov    $0x0,%eax
}
     cd4:	c9                   	leave  
     cd5:	c3                   	ret    

00000cd6 <gets>:

char*
gets(char *buf, int max)
{
     cd6:	55                   	push   %ebp
     cd7:	89 e5                	mov    %esp,%ebp
     cd9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ce3:	eb 44                	jmp    d29 <gets+0x53>
    cc = read(0, &c, 1);
     ce5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     cec:	00 
     ced:	8d 45 ef             	lea    -0x11(%ebp),%eax
     cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
     cf4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     cfb:	e8 3c 01 00 00       	call   e3c <read>
     d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     d03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d07:	7e 2d                	jle    d36 <gets+0x60>
      break;
    buf[i++] = c;
     d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d0c:	03 45 08             	add    0x8(%ebp),%eax
     d0f:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     d13:	88 10                	mov    %dl,(%eax)
     d15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     d19:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     d1d:	3c 0a                	cmp    $0xa,%al
     d1f:	74 16                	je     d37 <gets+0x61>
     d21:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     d25:	3c 0d                	cmp    $0xd,%al
     d27:	74 0e                	je     d37 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d2c:	83 c0 01             	add    $0x1,%eax
     d2f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     d32:	7c b1                	jl     ce5 <gets+0xf>
     d34:	eb 01                	jmp    d37 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     d36:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d3a:	03 45 08             	add    0x8(%ebp),%eax
     d3d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     d40:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d43:	c9                   	leave  
     d44:	c3                   	ret    

00000d45 <stat>:

int
stat(char *n, struct stat *st)
{
     d45:	55                   	push   %ebp
     d46:	89 e5                	mov    %esp,%ebp
     d48:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     d52:	00 
     d53:	8b 45 08             	mov    0x8(%ebp),%eax
     d56:	89 04 24             	mov    %eax,(%esp)
     d59:	e8 06 01 00 00       	call   e64 <open>
     d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     d61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d65:	79 07                	jns    d6e <stat+0x29>
    return -1;
     d67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d6c:	eb 23                	jmp    d91 <stat+0x4c>
  r = fstat(fd, st);
     d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
     d71:	89 44 24 04          	mov    %eax,0x4(%esp)
     d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d78:	89 04 24             	mov    %eax,(%esp)
     d7b:	e8 fc 00 00 00       	call   e7c <fstat>
     d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d86:	89 04 24             	mov    %eax,(%esp)
     d89:	e8 be 00 00 00       	call   e4c <close>
  return r;
     d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     d91:	c9                   	leave  
     d92:	c3                   	ret    

00000d93 <atoi>:

int
atoi(const char *s)
{
     d93:	55                   	push   %ebp
     d94:	89 e5                	mov    %esp,%ebp
     d96:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     d99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     da0:	eb 23                	jmp    dc5 <atoi+0x32>
    n = n*10 + *s++ - '0';
     da2:	8b 55 fc             	mov    -0x4(%ebp),%edx
     da5:	89 d0                	mov    %edx,%eax
     da7:	c1 e0 02             	shl    $0x2,%eax
     daa:	01 d0                	add    %edx,%eax
     dac:	01 c0                	add    %eax,%eax
     dae:	89 c2                	mov    %eax,%edx
     db0:	8b 45 08             	mov    0x8(%ebp),%eax
     db3:	0f b6 00             	movzbl (%eax),%eax
     db6:	0f be c0             	movsbl %al,%eax
     db9:	01 d0                	add    %edx,%eax
     dbb:	83 e8 30             	sub    $0x30,%eax
     dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
     dc1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     dc5:	8b 45 08             	mov    0x8(%ebp),%eax
     dc8:	0f b6 00             	movzbl (%eax),%eax
     dcb:	3c 2f                	cmp    $0x2f,%al
     dcd:	7e 0a                	jle    dd9 <atoi+0x46>
     dcf:	8b 45 08             	mov    0x8(%ebp),%eax
     dd2:	0f b6 00             	movzbl (%eax),%eax
     dd5:	3c 39                	cmp    $0x39,%al
     dd7:	7e c9                	jle    da2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     ddc:	c9                   	leave  
     ddd:	c3                   	ret    

00000dde <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     dde:	55                   	push   %ebp
     ddf:	89 e5                	mov    %esp,%ebp
     de1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     de4:	8b 45 08             	mov    0x8(%ebp),%eax
     de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     dea:	8b 45 0c             	mov    0xc(%ebp),%eax
     ded:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     df0:	eb 13                	jmp    e05 <memmove+0x27>
    *dst++ = *src++;
     df2:	8b 45 f8             	mov    -0x8(%ebp),%eax
     df5:	0f b6 10             	movzbl (%eax),%edx
     df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     dfb:	88 10                	mov    %dl,(%eax)
     dfd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     e01:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     e05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     e09:	0f 9f c0             	setg   %al
     e0c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     e10:	84 c0                	test   %al,%al
     e12:	75 de                	jne    df2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     e14:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e17:	c9                   	leave  
     e18:	c3                   	ret    
     e19:	90                   	nop
     e1a:	90                   	nop
     e1b:	90                   	nop

00000e1c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e1c:	b8 01 00 00 00       	mov    $0x1,%eax
     e21:	cd 40                	int    $0x40
     e23:	c3                   	ret    

00000e24 <exit>:
SYSCALL(exit)
     e24:	b8 02 00 00 00       	mov    $0x2,%eax
     e29:	cd 40                	int    $0x40
     e2b:	c3                   	ret    

00000e2c <wait>:
SYSCALL(wait)
     e2c:	b8 03 00 00 00       	mov    $0x3,%eax
     e31:	cd 40                	int    $0x40
     e33:	c3                   	ret    

00000e34 <pipe>:
SYSCALL(pipe)
     e34:	b8 04 00 00 00       	mov    $0x4,%eax
     e39:	cd 40                	int    $0x40
     e3b:	c3                   	ret    

00000e3c <read>:
SYSCALL(read)
     e3c:	b8 05 00 00 00       	mov    $0x5,%eax
     e41:	cd 40                	int    $0x40
     e43:	c3                   	ret    

00000e44 <write>:
SYSCALL(write)
     e44:	b8 10 00 00 00       	mov    $0x10,%eax
     e49:	cd 40                	int    $0x40
     e4b:	c3                   	ret    

00000e4c <close>:
SYSCALL(close)
     e4c:	b8 15 00 00 00       	mov    $0x15,%eax
     e51:	cd 40                	int    $0x40
     e53:	c3                   	ret    

00000e54 <kill>:
SYSCALL(kill)
     e54:	b8 06 00 00 00       	mov    $0x6,%eax
     e59:	cd 40                	int    $0x40
     e5b:	c3                   	ret    

00000e5c <exec>:
SYSCALL(exec)
     e5c:	b8 07 00 00 00       	mov    $0x7,%eax
     e61:	cd 40                	int    $0x40
     e63:	c3                   	ret    

00000e64 <open>:
SYSCALL(open)
     e64:	b8 0f 00 00 00       	mov    $0xf,%eax
     e69:	cd 40                	int    $0x40
     e6b:	c3                   	ret    

00000e6c <mknod>:
SYSCALL(mknod)
     e6c:	b8 11 00 00 00       	mov    $0x11,%eax
     e71:	cd 40                	int    $0x40
     e73:	c3                   	ret    

00000e74 <unlink>:
SYSCALL(unlink)
     e74:	b8 12 00 00 00       	mov    $0x12,%eax
     e79:	cd 40                	int    $0x40
     e7b:	c3                   	ret    

00000e7c <fstat>:
SYSCALL(fstat)
     e7c:	b8 08 00 00 00       	mov    $0x8,%eax
     e81:	cd 40                	int    $0x40
     e83:	c3                   	ret    

00000e84 <link>:
SYSCALL(link)
     e84:	b8 13 00 00 00       	mov    $0x13,%eax
     e89:	cd 40                	int    $0x40
     e8b:	c3                   	ret    

00000e8c <mkdir>:
SYSCALL(mkdir)
     e8c:	b8 14 00 00 00       	mov    $0x14,%eax
     e91:	cd 40                	int    $0x40
     e93:	c3                   	ret    

00000e94 <chdir>:
SYSCALL(chdir)
     e94:	b8 09 00 00 00       	mov    $0x9,%eax
     e99:	cd 40                	int    $0x40
     e9b:	c3                   	ret    

00000e9c <dup>:
SYSCALL(dup)
     e9c:	b8 0a 00 00 00       	mov    $0xa,%eax
     ea1:	cd 40                	int    $0x40
     ea3:	c3                   	ret    

00000ea4 <getpid>:
SYSCALL(getpid)
     ea4:	b8 0b 00 00 00       	mov    $0xb,%eax
     ea9:	cd 40                	int    $0x40
     eab:	c3                   	ret    

00000eac <sbrk>:
SYSCALL(sbrk)
     eac:	b8 0c 00 00 00       	mov    $0xc,%eax
     eb1:	cd 40                	int    $0x40
     eb3:	c3                   	ret    

00000eb4 <sleep>:
SYSCALL(sleep)
     eb4:	b8 0d 00 00 00       	mov    $0xd,%eax
     eb9:	cd 40                	int    $0x40
     ebb:	c3                   	ret    

00000ebc <uptime>:
SYSCALL(uptime)
     ebc:	b8 0e 00 00 00       	mov    $0xe,%eax
     ec1:	cd 40                	int    $0x40
     ec3:	c3                   	ret    

00000ec4 <thread_create>:
SYSCALL(thread_create)
     ec4:	b8 16 00 00 00       	mov    $0x16,%eax
     ec9:	cd 40                	int    $0x40
     ecb:	c3                   	ret    

00000ecc <thread_getId>:
SYSCALL(thread_getId)
     ecc:	b8 17 00 00 00       	mov    $0x17,%eax
     ed1:	cd 40                	int    $0x40
     ed3:	c3                   	ret    

00000ed4 <thread_getProcId>:
SYSCALL(thread_getProcId)
     ed4:	b8 18 00 00 00       	mov    $0x18,%eax
     ed9:	cd 40                	int    $0x40
     edb:	c3                   	ret    

00000edc <thread_join>:
SYSCALL(thread_join)
     edc:	b8 19 00 00 00       	mov    $0x19,%eax
     ee1:	cd 40                	int    $0x40
     ee3:	c3                   	ret    

00000ee4 <thread_exit>:
SYSCALL(thread_exit)
     ee4:	b8 1a 00 00 00       	mov    $0x1a,%eax
     ee9:	cd 40                	int    $0x40
     eeb:	c3                   	ret    

00000eec <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     eec:	b8 1b 00 00 00       	mov    $0x1b,%eax
     ef1:	cd 40                	int    $0x40
     ef3:	c3                   	ret    

00000ef4 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     ef4:	b8 1c 00 00 00       	mov    $0x1c,%eax
     ef9:	cd 40                	int    $0x40
     efb:	c3                   	ret    

00000efc <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     efc:	b8 1d 00 00 00       	mov    $0x1d,%eax
     f01:	cd 40                	int    $0x40
     f03:	c3                   	ret    

00000f04 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     f04:	55                   	push   %ebp
     f05:	89 e5                	mov    %esp,%ebp
     f07:	83 ec 28             	sub    $0x28,%esp
     f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
     f0d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     f10:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     f17:	00 
     f18:	8d 45 f4             	lea    -0xc(%ebp),%eax
     f1b:	89 44 24 04          	mov    %eax,0x4(%esp)
     f1f:	8b 45 08             	mov    0x8(%ebp),%eax
     f22:	89 04 24             	mov    %eax,(%esp)
     f25:	e8 1a ff ff ff       	call   e44 <write>
}
     f2a:	c9                   	leave  
     f2b:	c3                   	ret    

00000f2c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f2c:	55                   	push   %ebp
     f2d:	89 e5                	mov    %esp,%ebp
     f2f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     f32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     f39:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     f3d:	74 17                	je     f56 <printint+0x2a>
     f3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f43:	79 11                	jns    f56 <printint+0x2a>
    neg = 1;
     f45:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
     f4f:	f7 d8                	neg    %eax
     f51:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f54:	eb 06                	jmp    f5c <printint+0x30>
  } else {
    x = xx;
     f56:	8b 45 0c             	mov    0xc(%ebp),%eax
     f59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     f5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     f63:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f69:	ba 00 00 00 00       	mov    $0x0,%edx
     f6e:	f7 f1                	div    %ecx
     f70:	89 d0                	mov    %edx,%eax
     f72:	0f b6 90 50 1e 00 00 	movzbl 0x1e50(%eax),%edx
     f79:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f7c:	03 45 f4             	add    -0xc(%ebp),%eax
     f7f:	88 10                	mov    %dl,(%eax)
     f81:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     f85:	8b 55 10             	mov    0x10(%ebp),%edx
     f88:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f8e:	ba 00 00 00 00       	mov    $0x0,%edx
     f93:	f7 75 d4             	divl   -0x2c(%ebp)
     f96:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f9d:	75 c4                	jne    f63 <printint+0x37>
  if(neg)
     f9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fa3:	74 2a                	je     fcf <printint+0xa3>
    buf[i++] = '-';
     fa5:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fa8:	03 45 f4             	add    -0xc(%ebp),%eax
     fab:	c6 00 2d             	movb   $0x2d,(%eax)
     fae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     fb2:	eb 1b                	jmp    fcf <printint+0xa3>
    putc(fd, buf[i]);
     fb4:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fb7:	03 45 f4             	add    -0xc(%ebp),%eax
     fba:	0f b6 00             	movzbl (%eax),%eax
     fbd:	0f be c0             	movsbl %al,%eax
     fc0:	89 44 24 04          	mov    %eax,0x4(%esp)
     fc4:	8b 45 08             	mov    0x8(%ebp),%eax
     fc7:	89 04 24             	mov    %eax,(%esp)
     fca:	e8 35 ff ff ff       	call   f04 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     fcf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     fd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     fd7:	79 db                	jns    fb4 <printint+0x88>
    putc(fd, buf[i]);
}
     fd9:	c9                   	leave  
     fda:	c3                   	ret    

00000fdb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     fdb:	55                   	push   %ebp
     fdc:	89 e5                	mov    %esp,%ebp
     fde:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     fe1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     fe8:	8d 45 0c             	lea    0xc(%ebp),%eax
     feb:	83 c0 04             	add    $0x4,%eax
     fee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     ff1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ff8:	e9 7d 01 00 00       	jmp    117a <printf+0x19f>
    c = fmt[i] & 0xff;
     ffd:	8b 55 0c             	mov    0xc(%ebp),%edx
    1000:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1003:	01 d0                	add    %edx,%eax
    1005:	0f b6 00             	movzbl (%eax),%eax
    1008:	0f be c0             	movsbl %al,%eax
    100b:	25 ff 00 00 00       	and    $0xff,%eax
    1010:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1013:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1017:	75 2c                	jne    1045 <printf+0x6a>
      if(c == '%'){
    1019:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    101d:	75 0c                	jne    102b <printf+0x50>
        state = '%';
    101f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1026:	e9 4b 01 00 00       	jmp    1176 <printf+0x19b>
      } else {
        putc(fd, c);
    102b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    102e:	0f be c0             	movsbl %al,%eax
    1031:	89 44 24 04          	mov    %eax,0x4(%esp)
    1035:	8b 45 08             	mov    0x8(%ebp),%eax
    1038:	89 04 24             	mov    %eax,(%esp)
    103b:	e8 c4 fe ff ff       	call   f04 <putc>
    1040:	e9 31 01 00 00       	jmp    1176 <printf+0x19b>
      }
    } else if(state == '%'){
    1045:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1049:	0f 85 27 01 00 00    	jne    1176 <printf+0x19b>
      if(c == 'd'){
    104f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1053:	75 2d                	jne    1082 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1055:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1058:	8b 00                	mov    (%eax),%eax
    105a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1061:	00 
    1062:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1069:	00 
    106a:	89 44 24 04          	mov    %eax,0x4(%esp)
    106e:	8b 45 08             	mov    0x8(%ebp),%eax
    1071:	89 04 24             	mov    %eax,(%esp)
    1074:	e8 b3 fe ff ff       	call   f2c <printint>
        ap++;
    1079:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    107d:	e9 ed 00 00 00       	jmp    116f <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    1082:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1086:	74 06                	je     108e <printf+0xb3>
    1088:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    108c:	75 2d                	jne    10bb <printf+0xe0>
        printint(fd, *ap, 16, 0);
    108e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1091:	8b 00                	mov    (%eax),%eax
    1093:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    109a:	00 
    109b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    10a2:	00 
    10a3:	89 44 24 04          	mov    %eax,0x4(%esp)
    10a7:	8b 45 08             	mov    0x8(%ebp),%eax
    10aa:	89 04 24             	mov    %eax,(%esp)
    10ad:	e8 7a fe ff ff       	call   f2c <printint>
        ap++;
    10b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10b6:	e9 b4 00 00 00       	jmp    116f <printf+0x194>
      } else if(c == 's'){
    10bb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    10bf:	75 46                	jne    1107 <printf+0x12c>
        s = (char*)*ap;
    10c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10c4:	8b 00                	mov    (%eax),%eax
    10c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    10c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    10cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10d1:	75 27                	jne    10fa <printf+0x11f>
          s = "(null)";
    10d3:	c7 45 f4 5c 18 00 00 	movl   $0x185c,-0xc(%ebp)
        while(*s != 0){
    10da:	eb 1e                	jmp    10fa <printf+0x11f>
          putc(fd, *s);
    10dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10df:	0f b6 00             	movzbl (%eax),%eax
    10e2:	0f be c0             	movsbl %al,%eax
    10e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e9:	8b 45 08             	mov    0x8(%ebp),%eax
    10ec:	89 04 24             	mov    %eax,(%esp)
    10ef:	e8 10 fe ff ff       	call   f04 <putc>
          s++;
    10f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10f8:	eb 01                	jmp    10fb <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    10fa:	90                   	nop
    10fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10fe:	0f b6 00             	movzbl (%eax),%eax
    1101:	84 c0                	test   %al,%al
    1103:	75 d7                	jne    10dc <printf+0x101>
    1105:	eb 68                	jmp    116f <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1107:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    110b:	75 1d                	jne    112a <printf+0x14f>
        putc(fd, *ap);
    110d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1110:	8b 00                	mov    (%eax),%eax
    1112:	0f be c0             	movsbl %al,%eax
    1115:	89 44 24 04          	mov    %eax,0x4(%esp)
    1119:	8b 45 08             	mov    0x8(%ebp),%eax
    111c:	89 04 24             	mov    %eax,(%esp)
    111f:	e8 e0 fd ff ff       	call   f04 <putc>
        ap++;
    1124:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1128:	eb 45                	jmp    116f <printf+0x194>
      } else if(c == '%'){
    112a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    112e:	75 17                	jne    1147 <printf+0x16c>
        putc(fd, c);
    1130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1133:	0f be c0             	movsbl %al,%eax
    1136:	89 44 24 04          	mov    %eax,0x4(%esp)
    113a:	8b 45 08             	mov    0x8(%ebp),%eax
    113d:	89 04 24             	mov    %eax,(%esp)
    1140:	e8 bf fd ff ff       	call   f04 <putc>
    1145:	eb 28                	jmp    116f <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1147:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    114e:	00 
    114f:	8b 45 08             	mov    0x8(%ebp),%eax
    1152:	89 04 24             	mov    %eax,(%esp)
    1155:	e8 aa fd ff ff       	call   f04 <putc>
        putc(fd, c);
    115a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    115d:	0f be c0             	movsbl %al,%eax
    1160:	89 44 24 04          	mov    %eax,0x4(%esp)
    1164:	8b 45 08             	mov    0x8(%ebp),%eax
    1167:	89 04 24             	mov    %eax,(%esp)
    116a:	e8 95 fd ff ff       	call   f04 <putc>
      }
      state = 0;
    116f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1176:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    117a:	8b 55 0c             	mov    0xc(%ebp),%edx
    117d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1180:	01 d0                	add    %edx,%eax
    1182:	0f b6 00             	movzbl (%eax),%eax
    1185:	84 c0                	test   %al,%al
    1187:	0f 85 70 fe ff ff    	jne    ffd <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    118d:	c9                   	leave  
    118e:	c3                   	ret    
    118f:	90                   	nop

00001190 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
    1193:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1196:	8b 45 08             	mov    0x8(%ebp),%eax
    1199:	83 e8 08             	sub    $0x8,%eax
    119c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    119f:	a1 6c 1e 00 00       	mov    0x1e6c,%eax
    11a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11a7:	eb 24                	jmp    11cd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11ac:	8b 00                	mov    (%eax),%eax
    11ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11b1:	77 12                	ja     11c5 <free+0x35>
    11b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11b9:	77 24                	ja     11df <free+0x4f>
    11bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11be:	8b 00                	mov    (%eax),%eax
    11c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11c3:	77 1a                	ja     11df <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11c8:	8b 00                	mov    (%eax),%eax
    11ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11d3:	76 d4                	jbe    11a9 <free+0x19>
    11d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11d8:	8b 00                	mov    (%eax),%eax
    11da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11dd:	76 ca                	jbe    11a9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    11df:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11e2:	8b 40 04             	mov    0x4(%eax),%eax
    11e5:	c1 e0 03             	shl    $0x3,%eax
    11e8:	89 c2                	mov    %eax,%edx
    11ea:	03 55 f8             	add    -0x8(%ebp),%edx
    11ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11f0:	8b 00                	mov    (%eax),%eax
    11f2:	39 c2                	cmp    %eax,%edx
    11f4:	75 24                	jne    121a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    11f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11f9:	8b 50 04             	mov    0x4(%eax),%edx
    11fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11ff:	8b 00                	mov    (%eax),%eax
    1201:	8b 40 04             	mov    0x4(%eax),%eax
    1204:	01 c2                	add    %eax,%edx
    1206:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1209:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    120c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    120f:	8b 00                	mov    (%eax),%eax
    1211:	8b 10                	mov    (%eax),%edx
    1213:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1216:	89 10                	mov    %edx,(%eax)
    1218:	eb 0a                	jmp    1224 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    121a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    121d:	8b 10                	mov    (%eax),%edx
    121f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1222:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1224:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1227:	8b 40 04             	mov    0x4(%eax),%eax
    122a:	c1 e0 03             	shl    $0x3,%eax
    122d:	03 45 fc             	add    -0x4(%ebp),%eax
    1230:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1233:	75 20                	jne    1255 <free+0xc5>
    p->s.size += bp->s.size;
    1235:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1238:	8b 50 04             	mov    0x4(%eax),%edx
    123b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    123e:	8b 40 04             	mov    0x4(%eax),%eax
    1241:	01 c2                	add    %eax,%edx
    1243:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1246:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1249:	8b 45 f8             	mov    -0x8(%ebp),%eax
    124c:	8b 10                	mov    (%eax),%edx
    124e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1251:	89 10                	mov    %edx,(%eax)
    1253:	eb 08                	jmp    125d <free+0xcd>
  } else
    p->s.ptr = bp;
    1255:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1258:	8b 55 f8             	mov    -0x8(%ebp),%edx
    125b:	89 10                	mov    %edx,(%eax)
  freep = p;
    125d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1260:	a3 6c 1e 00 00       	mov    %eax,0x1e6c
}
    1265:	c9                   	leave  
    1266:	c3                   	ret    

00001267 <morecore>:

static Header*
morecore(uint nu)
{
    1267:	55                   	push   %ebp
    1268:	89 e5                	mov    %esp,%ebp
    126a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    126d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1274:	77 07                	ja     127d <morecore+0x16>
    nu = 4096;
    1276:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    127d:	8b 45 08             	mov    0x8(%ebp),%eax
    1280:	c1 e0 03             	shl    $0x3,%eax
    1283:	89 04 24             	mov    %eax,(%esp)
    1286:	e8 21 fc ff ff       	call   eac <sbrk>
    128b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    128e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1292:	75 07                	jne    129b <morecore+0x34>
    return 0;
    1294:	b8 00 00 00 00       	mov    $0x0,%eax
    1299:	eb 22                	jmp    12bd <morecore+0x56>
  hp = (Header*)p;
    129b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    129e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    12a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12a4:	8b 55 08             	mov    0x8(%ebp),%edx
    12a7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    12aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12ad:	83 c0 08             	add    $0x8,%eax
    12b0:	89 04 24             	mov    %eax,(%esp)
    12b3:	e8 d8 fe ff ff       	call   1190 <free>
  return freep;
    12b8:	a1 6c 1e 00 00       	mov    0x1e6c,%eax
}
    12bd:	c9                   	leave  
    12be:	c3                   	ret    

000012bf <malloc>:

void*
malloc(uint nbytes)
{
    12bf:	55                   	push   %ebp
    12c0:	89 e5                	mov    %esp,%ebp
    12c2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12c5:	8b 45 08             	mov    0x8(%ebp),%eax
    12c8:	83 c0 07             	add    $0x7,%eax
    12cb:	c1 e8 03             	shr    $0x3,%eax
    12ce:	83 c0 01             	add    $0x1,%eax
    12d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    12d4:	a1 6c 1e 00 00       	mov    0x1e6c,%eax
    12d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12e0:	75 23                	jne    1305 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    12e2:	c7 45 f0 64 1e 00 00 	movl   $0x1e64,-0x10(%ebp)
    12e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12ec:	a3 6c 1e 00 00       	mov    %eax,0x1e6c
    12f1:	a1 6c 1e 00 00       	mov    0x1e6c,%eax
    12f6:	a3 64 1e 00 00       	mov    %eax,0x1e64
    base.s.size = 0;
    12fb:	c7 05 68 1e 00 00 00 	movl   $0x0,0x1e68
    1302:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1305:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1308:	8b 00                	mov    (%eax),%eax
    130a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1310:	8b 40 04             	mov    0x4(%eax),%eax
    1313:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1316:	72 4d                	jb     1365 <malloc+0xa6>
      if(p->s.size == nunits)
    1318:	8b 45 f4             	mov    -0xc(%ebp),%eax
    131b:	8b 40 04             	mov    0x4(%eax),%eax
    131e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1321:	75 0c                	jne    132f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1323:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1326:	8b 10                	mov    (%eax),%edx
    1328:	8b 45 f0             	mov    -0x10(%ebp),%eax
    132b:	89 10                	mov    %edx,(%eax)
    132d:	eb 26                	jmp    1355 <malloc+0x96>
      else {
        p->s.size -= nunits;
    132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1332:	8b 40 04             	mov    0x4(%eax),%eax
    1335:	89 c2                	mov    %eax,%edx
    1337:	2b 55 ec             	sub    -0x14(%ebp),%edx
    133a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    133d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1340:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1343:	8b 40 04             	mov    0x4(%eax),%eax
    1346:	c1 e0 03             	shl    $0x3,%eax
    1349:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    134f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1352:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1355:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1358:	a3 6c 1e 00 00       	mov    %eax,0x1e6c
      return (void*)(p + 1);
    135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1360:	83 c0 08             	add    $0x8,%eax
    1363:	eb 38                	jmp    139d <malloc+0xde>
    }
    if(p == freep)
    1365:	a1 6c 1e 00 00       	mov    0x1e6c,%eax
    136a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    136d:	75 1b                	jne    138a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    136f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1372:	89 04 24             	mov    %eax,(%esp)
    1375:	e8 ed fe ff ff       	call   1267 <morecore>
    137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1381:	75 07                	jne    138a <malloc+0xcb>
        return 0;
    1383:	b8 00 00 00 00       	mov    $0x0,%eax
    1388:	eb 13                	jmp    139d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    138a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    138d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1390:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1393:	8b 00                	mov    (%eax),%eax
    1395:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1398:	e9 70 ff ff ff       	jmp    130d <malloc+0x4e>
}
    139d:	c9                   	leave  
    139e:	c3                   	ret    
    139f:	90                   	nop

000013a0 <semaphore_create>:
#include "semaphore.h"
#include "types.h"
#include "user.h"


struct semaphore* semaphore_create(int initial_semaphore_value){
    13a0:	55                   	push   %ebp
    13a1:	89 e5                	mov    %esp,%ebp
    13a3:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* sem=malloc(sizeof(struct semaphore)); 
    13a6:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    13ad:	e8 0d ff ff ff       	call   12bf <malloc>
    13b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // acquire semaphors
  sem->s1 = binary_semaphore_create(1);
    13b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13bc:	e8 2b fb ff ff       	call   eec <binary_semaphore_create>
    13c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13c4:	89 02                	mov    %eax,(%edx)
  
  // s2 should be initialized with the min{1,initial_semaphore_value}
  if(initial_semaphore_value >= 1){
    13c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    13ca:	7e 14                	jle    13e0 <semaphore_create+0x40>
    sem->s2 = binary_semaphore_create(1);
    13cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13d3:	e8 14 fb ff ff       	call   eec <binary_semaphore_create>
    13d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13db:	89 42 04             	mov    %eax,0x4(%edx)
    13de:	eb 11                	jmp    13f1 <semaphore_create+0x51>
  }else{
    sem->s2 = binary_semaphore_create(initial_semaphore_value);
    13e0:	8b 45 08             	mov    0x8(%ebp),%eax
    13e3:	89 04 24             	mov    %eax,(%esp)
    13e6:	e8 01 fb ff ff       	call   eec <binary_semaphore_create>
    13eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13ee:	89 42 04             	mov    %eax,0x4(%edx)
  }
  
  if(sem->s1 == -1 || sem->s2 == -1){
    13f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f4:	8b 00                	mov    (%eax),%eax
    13f6:	83 f8 ff             	cmp    $0xffffffff,%eax
    13f9:	74 0b                	je     1406 <semaphore_create+0x66>
    13fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13fe:	8b 40 04             	mov    0x4(%eax),%eax
    1401:	83 f8 ff             	cmp    $0xffffffff,%eax
    1404:	75 26                	jne    142c <semaphore_create+0x8c>
     printf(1,"we had a probalem initialize in semaphore_create\n");
    1406:	c7 44 24 04 64 18 00 	movl   $0x1864,0x4(%esp)
    140d:	00 
    140e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1415:	e8 c1 fb ff ff       	call   fdb <printf>
     free(sem);
    141a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141d:	89 04 24             	mov    %eax,(%esp)
    1420:	e8 6b fd ff ff       	call   1190 <free>
     return 0;
    1425:	b8 00 00 00 00       	mov    $0x0,%eax
    142a:	eb 15                	jmp    1441 <semaphore_create+0xa1>
  }
  //initialize value
  sem->value = initial_semaphore_value;//dynamic
    142c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142f:	8b 55 08             	mov    0x8(%ebp),%edx
    1432:	89 50 08             	mov    %edx,0x8(%eax)
  sem->initial_value = initial_semaphore_value;//static
    1435:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1438:	8b 55 08             	mov    0x8(%ebp),%edx
    143b:	89 50 0c             	mov    %edx,0xc(%eax)
  
  return sem;
    143e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1441:	c9                   	leave  
    1442:	c3                   	ret    

00001443 <semaphore_down>:
void semaphore_down(struct semaphore* sem ){
    1443:	55                   	push   %ebp
    1444:	89 e5                	mov    %esp,%ebp
    1446:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s2);
    1449:	8b 45 08             	mov    0x8(%ebp),%eax
    144c:	8b 40 04             	mov    0x4(%eax),%eax
    144f:	89 04 24             	mov    %eax,(%esp)
    1452:	e8 9d fa ff ff       	call   ef4 <binary_semaphore_down>
  binary_semaphore_down(sem->s1);
    1457:	8b 45 08             	mov    0x8(%ebp),%eax
    145a:	8b 00                	mov    (%eax),%eax
    145c:	89 04 24             	mov    %eax,(%esp)
    145f:	e8 90 fa ff ff       	call   ef4 <binary_semaphore_down>
  sem->value--;	
    1464:	8b 45 08             	mov    0x8(%ebp),%eax
    1467:	8b 40 08             	mov    0x8(%eax),%eax
    146a:	8d 50 ff             	lea    -0x1(%eax),%edx
    146d:	8b 45 08             	mov    0x8(%ebp),%eax
    1470:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value > 0){
    1473:	8b 45 08             	mov    0x8(%ebp),%eax
    1476:	8b 40 08             	mov    0x8(%eax),%eax
    1479:	85 c0                	test   %eax,%eax
    147b:	7e 0e                	jle    148b <semaphore_down+0x48>
   binary_semaphore_up(sem->s2);
    147d:	8b 45 08             	mov    0x8(%ebp),%eax
    1480:	8b 40 04             	mov    0x4(%eax),%eax
    1483:	89 04 24             	mov    %eax,(%esp)
    1486:	e8 71 fa ff ff       	call   efc <binary_semaphore_up>
  }
  binary_semaphore_up(sem->s1); 
    148b:	8b 45 08             	mov    0x8(%ebp),%eax
    148e:	8b 00                	mov    (%eax),%eax
    1490:	89 04 24             	mov    %eax,(%esp)
    1493:	e8 64 fa ff ff       	call   efc <binary_semaphore_up>
}
    1498:	c9                   	leave  
    1499:	c3                   	ret    

0000149a <semaphore_up>:
void semaphore_up(struct semaphore* sem ){
    149a:	55                   	push   %ebp
    149b:	89 e5                	mov    %esp,%ebp
    149d:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
    14a0:	8b 45 08             	mov    0x8(%ebp),%eax
    14a3:	8b 00                	mov    (%eax),%eax
    14a5:	89 04 24             	mov    %eax,(%esp)
    14a8:	e8 47 fa ff ff       	call   ef4 <binary_semaphore_down>
  sem->value++;	
    14ad:	8b 45 08             	mov    0x8(%ebp),%eax
    14b0:	8b 40 08             	mov    0x8(%eax),%eax
    14b3:	8d 50 01             	lea    0x1(%eax),%edx
    14b6:	8b 45 08             	mov    0x8(%ebp),%eax
    14b9:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value ==1){
    14bc:	8b 45 08             	mov    0x8(%ebp),%eax
    14bf:	8b 40 08             	mov    0x8(%eax),%eax
    14c2:	83 f8 01             	cmp    $0x1,%eax
    14c5:	75 0e                	jne    14d5 <semaphore_up+0x3b>
   binary_semaphore_up(sem->s2); 
    14c7:	8b 45 08             	mov    0x8(%ebp),%eax
    14ca:	8b 40 04             	mov    0x4(%eax),%eax
    14cd:	89 04 24             	mov    %eax,(%esp)
    14d0:	e8 27 fa ff ff       	call   efc <binary_semaphore_up>
   }
  binary_semaphore_up(sem->s1);
    14d5:	8b 45 08             	mov    0x8(%ebp),%eax
    14d8:	8b 00                	mov    (%eax),%eax
    14da:	89 04 24             	mov    %eax,(%esp)
    14dd:	e8 1a fa ff ff       	call   efc <binary_semaphore_up>
}
    14e2:	c9                   	leave  
    14e3:	c3                   	ret    

000014e4 <semaphore_free>:

void semaphore_free(struct semaphore* sem){
    14e4:	55                   	push   %ebp
    14e5:	89 e5                	mov    %esp,%ebp
    14e7:	83 ec 18             	sub    $0x18,%esp
  free(sem);
    14ea:	8b 45 08             	mov    0x8(%ebp),%eax
    14ed:	89 04 24             	mov    %eax,(%esp)
    14f0:	e8 9b fc ff ff       	call   1190 <free>
}
    14f5:	c9                   	leave  
    14f6:	c3                   	ret    
    14f7:	90                   	nop

000014f8 <BB_create>:
#include "types.h"
#include "user.h"


struct BB* 
BB_create(int max_capacity){
    14f8:	55                   	push   %ebp
    14f9:	89 e5                	mov    %esp,%ebp
    14fb:	83 ec 38             	sub    $0x38,%esp
  //initialize
  struct BB* buf = malloc(sizeof(struct BB));
    14fe:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
    1505:	e8 b5 fd ff ff       	call   12bf <malloc>
    150a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  buf->buffer_size = max_capacity;
    150d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1510:	8b 55 08             	mov    0x8(%ebp),%edx
    1513:	89 10                	mov    %edx,(%eax)
  buf->mutex = binary_semaphore_create(1);  
    1515:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    151c:	e8 cb f9 ff ff       	call   eec <binary_semaphore_create>
    1521:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1524:	89 42 04             	mov    %eax,0x4(%edx)
  buf->empty = semaphore_create(max_capacity);
    1527:	8b 45 08             	mov    0x8(%ebp),%eax
    152a:	89 04 24             	mov    %eax,(%esp)
    152d:	e8 6e fe ff ff       	call   13a0 <semaphore_create>
    1532:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1535:	89 42 08             	mov    %eax,0x8(%edx)
  buf->full = semaphore_create(0);
    1538:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    153f:	e8 5c fe ff ff       	call   13a0 <semaphore_create>
    1544:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1547:	89 42 0c             	mov    %eax,0xc(%edx)
  void** elements_array = (void**)malloc(sizeof(void*) * max_capacity); 
    154a:	8b 45 08             	mov    0x8(%ebp),%eax
    154d:	c1 e0 02             	shl    $0x2,%eax
    1550:	89 04 24             	mov    %eax,(%esp)
    1553:	e8 67 fd ff ff       	call   12bf <malloc>
    1558:	89 45 f0             	mov    %eax,-0x10(%ebp)
  buf->pointer_to_elements = elements_array;  
    155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155e:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1561:	89 50 14             	mov    %edx,0x14(%eax)
  buf->count = 0;
    1564:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1567:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  //check the semaphorses
  if(buf->mutex == -1 || buf->empty == 0 || buf->full == 0){
    156e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1571:	8b 40 04             	mov    0x4(%eax),%eax
    1574:	83 f8 ff             	cmp    $0xffffffff,%eax
    1577:	74 14                	je     158d <BB_create+0x95>
    1579:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157c:	8b 40 08             	mov    0x8(%eax),%eax
    157f:	85 c0                	test   %eax,%eax
    1581:	74 0a                	je     158d <BB_create+0x95>
    1583:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1586:	8b 40 0c             	mov    0xc(%eax),%eax
    1589:	85 c0                	test   %eax,%eax
    158b:	75 44                	jne    15d1 <BB_create+0xd9>
   printf(1,"we had a problam getting semaphores at BB create mutex %d empty %d full %d\n",buf->mutex,buf->empty,buf->full);
    158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1590:	8b 48 0c             	mov    0xc(%eax),%ecx
    1593:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1596:	8b 50 08             	mov    0x8(%eax),%edx
    1599:	8b 45 f4             	mov    -0xc(%ebp),%eax
    159c:	8b 40 04             	mov    0x4(%eax),%eax
    159f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    15a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
    15a7:	89 44 24 08          	mov    %eax,0x8(%esp)
    15ab:	c7 44 24 04 98 18 00 	movl   $0x1898,0x4(%esp)
    15b2:	00 
    15b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15ba:	e8 1c fa ff ff       	call   fdb <printf>
   free(buf);
    15bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c2:	89 04 24             	mov    %eax,(%esp)
    15c5:	e8 c6 fb ff ff       	call   1190 <free>
   buf =0;  
    15ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  }
  return buf;
    15d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    15d4:	c9                   	leave  
    15d5:	c3                   	ret    

000015d6 <BB_put>:

void BB_put(struct BB* bb, void* element)
{ 
    15d6:	55                   	push   %ebp
    15d7:	89 e5                	mov    %esp,%ebp
    15d9:	83 ec 18             	sub    $0x18,%esp
  semaphore_down(bb->empty);
    15dc:	8b 45 08             	mov    0x8(%ebp),%eax
    15df:	8b 40 08             	mov    0x8(%eax),%eax
    15e2:	89 04 24             	mov    %eax,(%esp)
    15e5:	e8 59 fe ff ff       	call   1443 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    15ea:	8b 45 08             	mov    0x8(%ebp),%eax
    15ed:	8b 40 04             	mov    0x4(%eax),%eax
    15f0:	89 04 24             	mov    %eax,(%esp)
    15f3:	e8 fc f8 ff ff       	call   ef4 <binary_semaphore_down>
   //insert item
  bb->pointer_to_elements[bb->count] = element;
    15f8:	8b 45 08             	mov    0x8(%ebp),%eax
    15fb:	8b 50 14             	mov    0x14(%eax),%edx
    15fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1601:	8b 40 10             	mov    0x10(%eax),%eax
    1604:	c1 e0 02             	shl    $0x2,%eax
    1607:	01 c2                	add    %eax,%edx
    1609:	8b 45 0c             	mov    0xc(%ebp),%eax
    160c:	89 02                	mov    %eax,(%edx)
  bb->count++;
    160e:	8b 45 08             	mov    0x8(%ebp),%eax
    1611:	8b 40 10             	mov    0x10(%eax),%eax
    1614:	8d 50 01             	lea    0x1(%eax),%edx
    1617:	8b 45 08             	mov    0x8(%ebp),%eax
    161a:	89 50 10             	mov    %edx,0x10(%eax)
  binary_semaphore_up(bb->mutex);
    161d:	8b 45 08             	mov    0x8(%ebp),%eax
    1620:	8b 40 04             	mov    0x4(%eax),%eax
    1623:	89 04 24             	mov    %eax,(%esp)
    1626:	e8 d1 f8 ff ff       	call   efc <binary_semaphore_up>
  semaphore_up(bb->full);
    162b:	8b 45 08             	mov    0x8(%ebp),%eax
    162e:	8b 40 0c             	mov    0xc(%eax),%eax
    1631:	89 04 24             	mov    %eax,(%esp)
    1634:	e8 61 fe ff ff       	call   149a <semaphore_up>
  
}
    1639:	c9                   	leave  
    163a:	c3                   	ret    

0000163b <BB_pop>:

void* BB_pop(struct BB* bb)
{
    163b:	55                   	push   %ebp
    163c:	89 e5                	mov    %esp,%ebp
    163e:	83 ec 28             	sub    $0x28,%esp

  semaphore_down(bb->full);
    1641:	8b 45 08             	mov    0x8(%ebp),%eax
    1644:	8b 40 0c             	mov    0xc(%eax),%eax
    1647:	89 04 24             	mov    %eax,(%esp)
    164a:	e8 f4 fd ff ff       	call   1443 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    164f:	8b 45 08             	mov    0x8(%ebp),%eax
    1652:	8b 40 04             	mov    0x4(%eax),%eax
    1655:	89 04 24             	mov    %eax,(%esp)
    1658:	e8 97 f8 ff ff       	call   ef4 <binary_semaphore_down>
  void* element_to_pop = bb->pointer_to_elements[0];
    165d:	8b 45 08             	mov    0x8(%ebp),%eax
    1660:	8b 40 14             	mov    0x14(%eax),%eax
    1663:	8b 00                	mov    (%eax),%eax
    1665:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // shift left all elements at the array
  int i;
  for(i = 0; i < bb->count ; i++){
    1668:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    166f:	eb 4b                	jmp    16bc <BB_pop+0x81>
    if(i != (bb->count -1)){
    1671:	8b 45 08             	mov    0x8(%ebp),%eax
    1674:	8b 40 10             	mov    0x10(%eax),%eax
    1677:	83 e8 01             	sub    $0x1,%eax
    167a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    167d:	74 25                	je     16a4 <BB_pop+0x69>
      bb->pointer_to_elements[i] = bb->pointer_to_elements[i+1];
    167f:	8b 45 08             	mov    0x8(%ebp),%eax
    1682:	8b 40 14             	mov    0x14(%eax),%eax
    1685:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1688:	c1 e2 02             	shl    $0x2,%edx
    168b:	01 c2                	add    %eax,%edx
    168d:	8b 45 08             	mov    0x8(%ebp),%eax
    1690:	8b 40 14             	mov    0x14(%eax),%eax
    1693:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1696:	83 c1 01             	add    $0x1,%ecx
    1699:	c1 e1 02             	shl    $0x2,%ecx
    169c:	01 c8                	add    %ecx,%eax
    169e:	8b 00                	mov    (%eax),%eax
    16a0:	89 02                	mov    %eax,(%edx)
    16a2:	eb 14                	jmp    16b8 <BB_pop+0x7d>
    }else{
      bb->pointer_to_elements[i] = 0;
    16a4:	8b 45 08             	mov    0x8(%ebp),%eax
    16a7:	8b 40 14             	mov    0x14(%eax),%eax
    16aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
    16ad:	c1 e2 02             	shl    $0x2,%edx
    16b0:	01 d0                	add    %edx,%eax
    16b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  semaphore_down(bb->full);
  binary_semaphore_down(bb->mutex);
  void* element_to_pop = bb->pointer_to_elements[0];
  // shift left all elements at the array
  int i;
  for(i = 0; i < bb->count ; i++){
    16b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    16bc:	8b 45 08             	mov    0x8(%ebp),%eax
    16bf:	8b 40 10             	mov    0x10(%eax),%eax
    16c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    16c5:	7f aa                	jg     1671 <BB_pop+0x36>
      bb->pointer_to_elements[i] = bb->pointer_to_elements[i+1];
    }else{
      bb->pointer_to_elements[i] = 0;
     }
  }
  bb->count--;
    16c7:	8b 45 08             	mov    0x8(%ebp),%eax
    16ca:	8b 40 10             	mov    0x10(%eax),%eax
    16cd:	8d 50 ff             	lea    -0x1(%eax),%edx
    16d0:	8b 45 08             	mov    0x8(%ebp),%eax
    16d3:	89 50 10             	mov    %edx,0x10(%eax)
  binary_semaphore_up(bb->mutex);
    16d6:	8b 45 08             	mov    0x8(%ebp),%eax
    16d9:	8b 40 04             	mov    0x4(%eax),%eax
    16dc:	89 04 24             	mov    %eax,(%esp)
    16df:	e8 18 f8 ff ff       	call   efc <binary_semaphore_up>
  semaphore_up(bb->empty);
    16e4:	8b 45 08             	mov    0x8(%ebp),%eax
    16e7:	8b 40 08             	mov    0x8(%eax),%eax
    16ea:	89 04 24             	mov    %eax,(%esp)
    16ed:	e8 a8 fd ff ff       	call   149a <semaphore_up>
  
  return element_to_pop;
    16f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    16f5:	c9                   	leave  
    16f6:	c3                   	ret    

000016f7 <BB_free>:

void BB_free(struct BB* bb){
    16f7:	55                   	push   %ebp
    16f8:	89 e5                	mov    %esp,%ebp
    16fa:	83 ec 18             	sub    $0x18,%esp
    free(bb);
    16fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1700:	89 04 24             	mov    %eax,(%esp)
    1703:	e8 88 fa ff ff       	call   1190 <free>
    1708:	c9                   	leave  
    1709:	c3                   	ret    
