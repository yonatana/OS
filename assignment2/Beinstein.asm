
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
       6:	a1 30 1f 00 00       	mov    0x1f30,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 52 14 00 00       	call   1465 <semaphore_down>
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
      1b:	a1 30 1f 00 00       	mov    0x1f30,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 94 14 00 00       	call   14bc <semaphore_up>
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
      30:	a1 38 1f 00 00       	mov    0x1f38,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 fd 15 00 00       	call   1641 <BB_put>
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
      4c:	a1 38 1f 00 00       	mov    0x1f38,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 65 16 00 00       	call   16be <BB_pop>
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
      61:	a1 48 1f 00 00       	mov    0x1f48,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 cc 15 00 00       	call   1641 <BB_put>
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
      7d:	a1 48 1f 00 00       	mov    0x1f48,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 34 16 00 00       	call   16be <BB_pop>
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
      92:	a1 64 1f 00 00       	mov    0x1f64,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 1f 16 00 00       	call   16be <BB_pop>
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
      a7:	a1 64 1f 00 00       	mov    0x1f64,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 86 15 00 00       	call   1641 <BB_put>
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
      c3:	a1 3c 1f 00 00       	mov    0x1f3c,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 6a 15 00 00       	call   1641 <BB_put>
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
      df:	a1 3c 1f 00 00       	mov    0x1f3c,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 d2 15 00 00       	call   16be <BB_pop>
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
      f3:	83 ec 40             	sub    $0x40,%esp
    void* ret_val = 0;
      f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    int i =0;
      fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    enter_bar();
     104:	e8 f7 fe ff ff       	call   0 <enter_bar>
    int tid = thread_getId();
     109:	e8 e2 0d 00 00       	call   ef0 <thread_getId>
     10e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(i = 0; i < tid%5; i++){
     111:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     118:	e9 b6 00 00 00       	jmp    1d3 <student+0xe5>
	//struct Action* student_action = (Action*)malloc(sizeof(Action));
	struct Action* student_action = malloc(sizeof(Action));
     11d:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     124:	e8 ba 11 00 00       	call   12e3 <malloc>
     129:	89 45 e8             	mov    %eax,-0x18(%ebp)
	student_action->action_type = DRINK_ORDER;
     12c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     12f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	student_action->cup = 0;
     135:	8b 45 e8             	mov    -0x18(%ebp),%eax
     138:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	student_action->tid = tid;
     13f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     142:	8b 55 ec             	mov    -0x14(%ebp),%edx
     145:	89 50 08             	mov    %edx,0x8(%eax)
	place_action(student_action);
     148:	8b 45 e8             	mov    -0x18(%ebp),%eax
     14b:	89 04 24             	mov    %eax,(%esp)
     14e:	e8 d7 fe ff ff       	call   2a <place_action>
	struct Cup * cup = get_drink();
     153:	e8 1f ff ff ff       	call   77 <get_drink>
     158:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	//student_action->cup = get_drink();
	//need to write to file intsead of screen TODO
	printf(1,"Student %d is having his %d drink, with cup %d\n",thread_getId(),i+1,student_action->cup->id);
     15b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     15e:	8b 40 04             	mov    0x4(%eax),%eax
     161:	8b 18                	mov    (%eax),%ebx
     163:	8b 45 f4             	mov    -0xc(%ebp),%eax
     166:	8d 70 01             	lea    0x1(%eax),%esi
     169:	e8 82 0d 00 00       	call   ef0 <thread_getId>
     16e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
     172:	89 74 24 0c          	mov    %esi,0xc(%esp)
     176:	89 44 24 08          	mov    %eax,0x8(%esp)
     17a:	c7 44 24 04 78 17 00 	movl   $0x1778,0x4(%esp)
     181:	00 
     182:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     189:	e8 71 0e 00 00       	call   fff <printf>
	sleep(1);
     18e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     195:	e8 3e 0d 00 00       	call   ed8 <sleep>
	struct Action* ret = malloc(sizeof(struct Action));
     19a:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     1a1:	e8 3d 11 00 00       	call   12e3 <malloc>
     1a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	ret->action_type = RETURN_CUP;
     1a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ac:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
	ret->cup = cup;
     1b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     1b8:	89 50 04             	mov    %edx,0x4(%eax)
	ret->tid = tid;
     1bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1be:	8b 55 ec             	mov    -0x14(%ebp),%edx
     1c1:	89 50 08             	mov    %edx,0x8(%eax)
	place_action(ret);
     1c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 5b fe ff ff       	call   2a <place_action>
void* student(){
    void* ret_val = 0;
    int i =0;
    enter_bar();
    int tid = thread_getId();
    for(i = 0; i < tid%5; i++){
     1cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1d3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
     1d6:	ba 67 66 66 66       	mov    $0x66666667,%edx
     1db:	89 c8                	mov    %ecx,%eax
     1dd:	f7 ea                	imul   %edx
     1df:	d1 fa                	sar    %edx
     1e1:	89 c8                	mov    %ecx,%eax
     1e3:	c1 f8 1f             	sar    $0x1f,%eax
     1e6:	29 c2                	sub    %eax,%edx
     1e8:	89 d0                	mov    %edx,%eax
     1ea:	c1 e0 02             	shl    $0x2,%eax
     1ed:	01 d0                	add    %edx,%eax
     1ef:	89 ca                	mov    %ecx,%edx
     1f1:	29 c2                	sub    %eax,%edx
     1f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
     1f6:	0f 8f 21 ff ff ff    	jg     11d <student+0x2f>
	ret->cup = cup;
	ret->tid = tid;
	place_action(ret);
    }
    //need to write to file intsead of screen TODO
    printf(1,"Student %d is drunk, and trying to go home\n",thread_getId());
     1fc:	e8 ef 0c 00 00       	call   ef0 <thread_getId>
     201:	89 44 24 08          	mov    %eax,0x8(%esp)
     205:	c7 44 24 04 a8 17 00 	movl   $0x17a8,0x4(%esp)
     20c:	00 
     20d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     214:	e8 e6 0d 00 00       	call   fff <printf>
    leave_bar();
     219:	e8 f7 fd ff ff       	call   15 <leave_bar>
    thread_exit(ret_val);
     21e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     221:	89 04 24             	mov    %eax,(%esp)
     224:	e8 df 0c 00 00       	call   f08 <thread_exit>
    //thread_exit(0);
    return 0;
     229:	b8 00 00 00 00       	mov    $0x0,%eax
}
     22e:	83 c4 40             	add    $0x40,%esp
     231:	5b                   	pop    %ebx
     232:	5e                   	pop    %esi
     233:	5d                   	pop    %ebp
     234:	c3                   	ret    

00000235 <bartender>:

//bartender simulation
void* bartender(){
     235:	55                   	push   %ebp
     236:	89 e5                	mov    %esp,%ebp
     238:	83 ec 48             	sub    $0x48,%esp
    void* ret_val = 0;
     23b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   
    //double n,bufSize;
    int tid = thread_getId();
     242:	e8 a9 0c 00 00       	call   ef0 <thread_getId>
     247:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    for(;;){
	struct Action* bartender_action = get_action();
     24a:	e8 f7 fd ff ff       	call   46 <get_action>
     24f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(bartender_action->action_type == DRINK_ORDER){
     252:	8b 45 ec             	mov    -0x14(%ebp),%eax
     255:	8b 00                	mov    (%eax),%eax
     257:	83 f8 01             	cmp    $0x1,%eax
     25a:	75 39                	jne    295 <bartender+0x60>
	    struct Cup* current_cup  = get_clean_cup();
     25c:	e8 2b fe ff ff       	call   8c <get_clean_cup>
     261:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    //need to write to file intsead of screen TODO
	   printf(1,"Bartender %d is making drink with cup #%d\n",tid,current_cup->id); 
     264:	8b 45 e8             	mov    -0x18(%ebp),%eax
     267:	8b 00                	mov    (%eax),%eax
     269:	89 44 24 0c          	mov    %eax,0xc(%esp)
     26d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     270:	89 44 24 08          	mov    %eax,0x8(%esp)
     274:	c7 44 24 04 d4 17 00 	movl   $0x17d4,0x4(%esp)
     27b:	00 
     27c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     283:	e8 77 0d 00 00       	call   fff <printf>
	    serve_drink(current_cup);
     288:	8b 45 e8             	mov    -0x18(%ebp),%eax
     28b:	89 04 24             	mov    %eax,(%esp)
     28e:	e8 c8 fd ff ff       	call   5b <serve_drink>
     293:	eb 75                	jmp    30a <bartender+0xd5>
	}
	else if(bartender_action->action_type == RETURN_CUP){
     295:	8b 45 ec             	mov    -0x14(%ebp),%eax
     298:	8b 00                	mov    (%eax),%eax
     29a:	83 f8 02             	cmp    $0x2,%eax
     29d:	75 6b                	jne    30a <bartender+0xd5>
	    struct Cup * current_cup = bartender_action->cup;
     29f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2a2:	8b 40 04             	mov    0x4(%eax),%eax
     2a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    return_cup(current_cup);
     2a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2ab:	89 04 24             	mov    %eax,(%esp)
     2ae:	e8 0a fe ff ff       	call   bd <return_cup>
	    //need to write to file intsead of screen TODO
	    printf(1,"Bartender %d returned cup #%d\n",tid,current_cup->id);
     2b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2b6:	8b 00                	mov    (%eax),%eax
     2b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
     2bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2bf:	89 44 24 08          	mov    %eax,0x8(%esp)
     2c3:	c7 44 24 04 00 18 00 	movl   $0x1800,0x4(%esp)
     2ca:	00 
     2cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2d2:	e8 28 0d 00 00       	call   fff <printf>
	
	  //60% should we wake the cup_boy
	  if((((DBB->full->value) * 100) / (DBB->buffer_size)) >= 60){ //wakeup cup_boy
     2d7:	a1 3c 1f 00 00       	mov    0x1f3c,%eax
     2dc:	8b 40 0c             	mov    0xc(%eax),%eax
     2df:	8b 40 08             	mov    0x8(%eax),%eax
     2e2:	6b c0 64             	imul   $0x64,%eax,%eax
     2e5:	8b 15 3c 1f 00 00    	mov    0x1f3c,%edx
     2eb:	8b 12                	mov    (%edx),%edx
     2ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     2f0:	89 c2                	mov    %eax,%edx
     2f2:	c1 fa 1f             	sar    $0x1f,%edx
     2f5:	f7 7d d4             	idivl  -0x2c(%ebp)
     2f8:	83 f8 3b             	cmp    $0x3b,%eax
     2fb:	7e 0d                	jle    30a <bartender+0xd5>
	    binary_semaphore_up(cup_boy_lock);
     2fd:	a1 60 1f 00 00       	mov    0x1f60,%eax
     302:	89 04 24             	mov    %eax,(%esp)
     305:	e8 16 0c 00 00       	call   f20 <binary_semaphore_up>
	  }  
	}
	if(bartender_action->action_type == GO_HOME){
     30a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     30d:	8b 00                	mov    (%eax),%eax
     30f:	83 f8 03             	cmp    $0x3,%eax
     312:	75 0b                	jne    31f <bartender+0xea>
	  thread_exit(ret_val);
     314:	8b 45 f4             	mov    -0xc(%ebp),%eax
     317:	89 04 24             	mov    %eax,(%esp)
     31a:	e8 e9 0b 00 00       	call   f08 <thread_exit>
	}
	free(bartender_action);
     31f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     322:	89 04 24             	mov    %eax,(%esp)
     325:	e8 8a 0e 00 00       	call   11b4 <free>
	//bartender_action->action_type = UNDEFINED;
	//bartender_action->cup = 0;
    }
     32a:	e9 1b ff ff ff       	jmp    24a <bartender+0x15>

0000032f <cup_boy>:
    return ret_val;
}


// Cup boy simulation
void* cup_boy(){
     32f:	55                   	push   %ebp
     330:	89 e5                	mov    %esp,%ebp
     332:	83 ec 28             	sub    $0x28,%esp
  //int i, n;
  void* ret_val = 0;
     335:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  cup_boy_lock = binary_semaphore_create(0);
     33c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     343:	e8 c8 0b 00 00       	call   f10 <binary_semaphore_create>
     348:	a3 60 1f 00 00       	mov    %eax,0x1f60
    //if(finished_shift){
	//thread_exit(ret_val);
    //}
    
    
    int n = DBB->full->value;
     34d:	a1 3c 1f 00 00       	mov    0x1f3c,%eax
     352:	8b 40 0c             	mov    0xc(%eax),%eax
     355:	8b 40 08             	mov    0x8(%eax),%eax
     358:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int i;
    for(i = 0; i < n; i++){
     35b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     362:	eb 40                	jmp    3a4 <cup_boy+0x75>
	struct Cup* current_cup = wash_dirty();
     364:	e8 70 fd ff ff       	call   d9 <wash_dirty>
     369:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sleep(1);
     36c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     373:	e8 60 0b 00 00       	call   ed8 <sleep>
	add_clean_cup(current_cup);
     378:	8b 45 e8             	mov    -0x18(%ebp),%eax
     37b:	89 04 24             	mov    %eax,(%esp)
     37e:	e8 1e fd ff ff       	call   a1 <add_clean_cup>
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
     383:	8b 45 e8             	mov    -0x18(%ebp),%eax
     386:	8b 00                	mov    (%eax),%eax
     388:	89 44 24 08          	mov    %eax,0x8(%esp)
     38c:	c7 44 24 04 1f 18 00 	movl   $0x181f,0x4(%esp)
     393:	00 
     394:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     39b:	e8 5f 0c 00 00       	call   fff <printf>
    //}
    
    
    int n = DBB->full->value;
    int i;
    for(i = 0; i < n; i++){
     3a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     3a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     3aa:	7c b8                	jl     364 <cup_boy+0x35>
	sleep(1);
	add_clean_cup(current_cup);
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
    }
   binary_semaphore_down(cup_boy_lock); 
     3ac:	a1 60 1f 00 00       	mov    0x1f60,%eax
     3b1:	89 04 24             	mov    %eax,(%esp)
     3b4:	e8 5f 0b 00 00       	call   f18 <binary_semaphore_down>
  }
     3b9:	eb 92                	jmp    34d <cup_boy+0x1e>

000003bb <tests>:
  return ret_val;
}

int tests(int t){
     3bb:	55                   	push   %ebp
     3bc:	89 e5                	mov    %esp,%ebp
     3be:	83 ec 18             	sub    $0x18,%esp
 if(!t){
     3c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     3c5:	75 14                	jne    3db <tests+0x20>
   printf(1,"Test is bad!!!\n");
     3c7:	c7 44 24 04 3b 18 00 	movl   $0x183b,0x4(%esp)
     3ce:	00 
     3cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3d6:	e8 24 0c 00 00       	call   fff <printf>
 }
 return 0;
     3db:	b8 00 00 00 00       	mov    $0x0,%eax
}
     3e0:	c9                   	leave  
     3e1:	c3                   	ret    

000003e2 <join_peoples>:

// thread_joins on students and bartenders
void join_peoples(int* tids,int num_of_peoples){
     3e2:	55                   	push   %ebp
     3e3:	89 e5                	mov    %esp,%ebp
     3e5:	83 ec 28             	sub    $0x28,%esp
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     3e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3ef:	eb 1e                	jmp    40f <join_peoples+0x2d>
      thread_join(tids[i],&ret_val);
     3f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3f4:	c1 e0 02             	shl    $0x2,%eax
     3f7:	03 45 08             	add    0x8(%ebp),%eax
     3fa:	8b 00                	mov    (%eax),%eax
     3fc:	8d 55 f0             	lea    -0x10(%ebp),%edx
     3ff:	89 54 24 04          	mov    %edx,0x4(%esp)
     403:	89 04 24             	mov    %eax,(%esp)
     406:	e8 f5 0a 00 00       	call   f00 <thread_join>

// thread_joins on students and bartenders
void join_peoples(int* tids,int num_of_peoples){
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     40b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     40f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     412:	3b 45 0c             	cmp    0xc(%ebp),%eax
     415:	7c da                	jl     3f1 <join_peoples+0xf>
      thread_join(tids[i],&ret_val);
  }
}
     417:	c9                   	leave  
     418:	c3                   	ret    

00000419 <release_workers>:


//release the workers(bartenders + cup_boy) that run in infinite loops 
void release_workers(int num_of_bartenders){
     419:	55                   	push   %ebp
     41a:	89 e5                	mov    %esp,%ebp
     41c:	83 ec 28             	sub    $0x28,%esp
 int i;
 struct Action* release_bartender_action = 0;
     41f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 release_bartender_action->action_type = GO_HOME;
     426:	8b 45 f0             	mov    -0x10(%ebp),%eax
     429:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
 release_bartender_action->cup = 0;
     42f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     432:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 //release bartenders
 for(i = 0; i< num_of_bartenders; i++){
     439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     440:	eb 0f                	jmp    451 <release_workers+0x38>
    place_action(release_bartender_action);
     442:	8b 45 f0             	mov    -0x10(%ebp),%eax
     445:	89 04 24             	mov    %eax,(%esp)
     448:	e8 dd fb ff ff       	call   2a <place_action>
 int i;
 struct Action* release_bartender_action = 0;
 release_bartender_action->action_type = GO_HOME;
 release_bartender_action->cup = 0;
 //release bartenders
 for(i = 0; i< num_of_bartenders; i++){
     44d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     451:	8b 45 f4             	mov    -0xc(%ebp),%eax
     454:	3b 45 08             	cmp    0x8(%ebp),%eax
     457:	7c e9                	jl     442 <release_workers+0x29>
    place_action(release_bartender_action);
 }
 
 //release cup_boy
 binary_semaphore_up(cup_boy_lock);
     459:	a1 60 1f 00 00       	mov    0x1f60,%eax
     45e:	89 04 24             	mov    %eax,(%esp)
     461:	e8 ba 0a 00 00       	call   f20 <binary_semaphore_up>
}
     466:	c9                   	leave  
     467:	c3                   	ret    

00000468 <values_array_index>:


//return the index to put the value {A, B, C, S, M}
//				     {0, 1, 2, 3, 4}
int values_array_index(char* input_buf, int char_index){
     468:	55                   	push   %ebp
     469:	89 e5                	mov    %esp,%ebp
 if(input_buf[char_index] == 'A')
     46b:	8b 45 0c             	mov    0xc(%ebp),%eax
     46e:	03 45 08             	add    0x8(%ebp),%eax
     471:	0f b6 00             	movzbl (%eax),%eax
     474:	3c 41                	cmp    $0x41,%al
     476:	75 07                	jne    47f <values_array_index+0x17>
   return 0;
     478:	b8 00 00 00 00       	mov    $0x0,%eax
     47d:	eb 55                	jmp    4d4 <values_array_index+0x6c>
 if(input_buf[char_index] == 'B')
     47f:	8b 45 0c             	mov    0xc(%ebp),%eax
     482:	03 45 08             	add    0x8(%ebp),%eax
     485:	0f b6 00             	movzbl (%eax),%eax
     488:	3c 42                	cmp    $0x42,%al
     48a:	75 07                	jne    493 <values_array_index+0x2b>
   return 1;
     48c:	b8 01 00 00 00       	mov    $0x1,%eax
     491:	eb 41                	jmp    4d4 <values_array_index+0x6c>
 if(input_buf[char_index] == 'C')
     493:	8b 45 0c             	mov    0xc(%ebp),%eax
     496:	03 45 08             	add    0x8(%ebp),%eax
     499:	0f b6 00             	movzbl (%eax),%eax
     49c:	3c 43                	cmp    $0x43,%al
     49e:	75 07                	jne    4a7 <values_array_index+0x3f>
   return 2;
     4a0:	b8 02 00 00 00       	mov    $0x2,%eax
     4a5:	eb 2d                	jmp    4d4 <values_array_index+0x6c>
 if(input_buf[char_index] == 'S')
     4a7:	8b 45 0c             	mov    0xc(%ebp),%eax
     4aa:	03 45 08             	add    0x8(%ebp),%eax
     4ad:	0f b6 00             	movzbl (%eax),%eax
     4b0:	3c 53                	cmp    $0x53,%al
     4b2:	75 07                	jne    4bb <values_array_index+0x53>
   return 3;
     4b4:	b8 03 00 00 00       	mov    $0x3,%eax
     4b9:	eb 19                	jmp    4d4 <values_array_index+0x6c>
 if(input_buf[char_index] == 'M')
     4bb:	8b 45 0c             	mov    0xc(%ebp),%eax
     4be:	03 45 08             	add    0x8(%ebp),%eax
     4c1:	0f b6 00             	movzbl (%eax),%eax
     4c4:	3c 4d                	cmp    $0x4d,%al
     4c6:	75 07                	jne    4cf <values_array_index+0x67>
   return 4;
     4c8:	b8 04 00 00 00       	mov    $0x4,%eax
     4cd:	eb 05                	jmp    4d4 <values_array_index+0x6c>
 //error
 return -1;
     4cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     4d4:	5d                   	pop    %ebp
     4d5:	c3                   	ret    

000004d6 <parse_buffer>:

//parsing the configuration file
void parse_buffer(char* input_buf,int* values_array){
     4d6:	55                   	push   %ebp
     4d7:	89 e5                	mov    %esp,%ebp
     4d9:	53                   	push   %ebx
     4da:	83 ec 24             	sub    $0x24,%esp
 int i;
 int num_of_chars = strlen(input_buf);
     4dd:	8b 45 08             	mov    0x8(%ebp),%eax
     4e0:	89 04 24             	mov    %eax,(%esp)
     4e3:	e8 96 07 00 00       	call   c7e <strlen>
     4e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     4eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4f2:	eb 7e                	jmp    572 <parse_buffer+0x9c>
    if(input_buf[i] == 'A' || input_buf[i] == 'B' || input_buf[i] == 'C' || input_buf[i] == 'S' || input_buf[i] == 'M'){
     4f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f7:	03 45 08             	add    0x8(%ebp),%eax
     4fa:	0f b6 00             	movzbl (%eax),%eax
     4fd:	3c 41                	cmp    $0x41,%al
     4ff:	74 34                	je     535 <parse_buffer+0x5f>
     501:	8b 45 f4             	mov    -0xc(%ebp),%eax
     504:	03 45 08             	add    0x8(%ebp),%eax
     507:	0f b6 00             	movzbl (%eax),%eax
     50a:	3c 42                	cmp    $0x42,%al
     50c:	74 27                	je     535 <parse_buffer+0x5f>
     50e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     511:	03 45 08             	add    0x8(%ebp),%eax
     514:	0f b6 00             	movzbl (%eax),%eax
     517:	3c 43                	cmp    $0x43,%al
     519:	74 1a                	je     535 <parse_buffer+0x5f>
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51e:	03 45 08             	add    0x8(%ebp),%eax
     521:	0f b6 00             	movzbl (%eax),%eax
     524:	3c 53                	cmp    $0x53,%al
     526:	74 0d                	je     535 <parse_buffer+0x5f>
     528:	8b 45 f4             	mov    -0xc(%ebp),%eax
     52b:	03 45 08             	add    0x8(%ebp),%eax
     52e:	0f b6 00             	movzbl (%eax),%eax
     531:	3c 4d                	cmp    $0x4d,%al
     533:	75 39                	jne    56e <parse_buffer+0x98>
       index = values_array_index(input_buf,i);
     535:	8b 45 f4             	mov    -0xc(%ebp),%eax
     538:	89 44 24 04          	mov    %eax,0x4(%esp)
     53c:	8b 45 08             	mov    0x8(%ebp),%eax
     53f:	89 04 24             	mov    %eax,(%esp)
     542:	e8 21 ff ff ff       	call   468 <values_array_index>
     547:	89 45 ec             	mov    %eax,-0x14(%ebp)
       temp_str = &input_buf[i];
     54a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     54d:	03 45 08             	add    0x8(%ebp),%eax
     550:	89 45 e8             	mov    %eax,-0x18(%ebp)
       values_array[index] = atoi(temp_str+4);
     553:	8b 45 ec             	mov    -0x14(%ebp),%eax
     556:	c1 e0 02             	shl    $0x2,%eax
     559:	89 c3                	mov    %eax,%ebx
     55b:	03 5d 0c             	add    0xc(%ebp),%ebx
     55e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     561:	83 c0 04             	add    $0x4,%eax
     564:	89 04 24             	mov    %eax,(%esp)
     567:	e8 4b 08 00 00       	call   db7 <atoi>
     56c:	89 03                	mov    %eax,(%ebx)
void parse_buffer(char* input_buf,int* values_array){
 int i;
 int num_of_chars = strlen(input_buf);
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     56e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     572:	8b 45 f4             	mov    -0xc(%ebp),%eax
     575:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     578:	0f 8c 76 ff ff ff    	jl     4f4 <parse_buffer+0x1e>
       index = values_array_index(input_buf,i);
       temp_str = &input_buf[i];
       values_array[index] = atoi(temp_str+4);
    }
 }
}
     57e:	83 c4 24             	add    $0x24,%esp
     581:	5b                   	pop    %ebx
     582:	5d                   	pop    %ebp
     583:	c3                   	ret    

00000584 <main>:


int main(int argc, char** argv) {
     584:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     588:	83 e4 f0             	and    $0xfffffff0,%esp
     58b:	ff 71 fc             	pushl  -0x4(%ecx)
     58e:	55                   	push   %ebp
     58f:	89 e5                	mov    %esp,%ebp
     591:	51                   	push   %ecx
     592:	81 ec c4 00 00 00    	sub    $0xc4,%esp
  int M;	// maximum number of students that can be at the bar at once
  int fconf;
  int conf_size;
  struct stat bufstat;
  
  fconf = open("con.conf",O_RDONLY);
     598:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     59f:	00 
     5a0:	c7 04 24 4b 18 00 00 	movl   $0x184b,(%esp)
     5a7:	e8 dc 08 00 00       	call   e88 <open>
     5ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  fstat(fconf,&bufstat);
     5af:	8d 45 88             	lea    -0x78(%ebp),%eax
     5b2:	89 44 24 04          	mov    %eax,0x4(%esp)
     5b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5b9:	89 04 24             	mov    %eax,(%esp)
     5bc:	e8 df 08 00 00       	call   ea0 <fstat>
  conf_size = bufstat.size;
     5c1:	8b 45 98             	mov    -0x68(%ebp),%eax
     5c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  char bufconf[conf_size];
     5c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ca:	8d 50 ff             	lea    -0x1(%eax),%edx
     5cd:	89 55 e8             	mov    %edx,-0x18(%ebp)
     5d0:	8d 50 0f             	lea    0xf(%eax),%edx
     5d3:	b8 10 00 00 00       	mov    $0x10,%eax
     5d8:	83 e8 01             	sub    $0x1,%eax
     5db:	01 d0                	add    %edx,%eax
     5dd:	c7 85 64 ff ff ff 10 	movl   $0x10,-0x9c(%ebp)
     5e4:	00 00 00 
     5e7:	ba 00 00 00 00       	mov    $0x0,%edx
     5ec:	f7 b5 64 ff ff ff    	divl   -0x9c(%ebp)
     5f2:	6b c0 10             	imul   $0x10,%eax,%eax
     5f5:	29 c4                	sub    %eax,%esp
     5f7:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     5fb:	83 c0 0f             	add    $0xf,%eax
     5fe:	c1 e8 04             	shr    $0x4,%eax
     601:	c1 e0 04             	shl    $0x4,%eax
     604:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  read(fconf,bufconf,conf_size);
     607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     60a:	8b 55 ec             	mov    -0x14(%ebp),%edx
     60d:	89 54 24 08          	mov    %edx,0x8(%esp)
     611:	89 44 24 04          	mov    %eax,0x4(%esp)
     615:	8b 45 f0             	mov    -0x10(%ebp),%eax
     618:	89 04 24             	mov    %eax,(%esp)
     61b:	e8 40 08 00 00       	call   e60 <read>
  int inputs_parsed[5]; //{Aval, Bval, Cval, Sval, Mval}
  
  parse_buffer(bufconf, inputs_parsed);
     620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     623:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
     629:	89 54 24 04          	mov    %edx,0x4(%esp)
     62d:	89 04 24             	mov    %eax,(%esp)
     630:	e8 a1 fe ff ff       	call   4d6 <parse_buffer>
  A = inputs_parsed[0];
     635:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
     63b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  B = inputs_parsed[1];
     63e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
     644:	89 45 dc             	mov    %eax,-0x24(%ebp)
  C = inputs_parsed[2];
     647:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
     64d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  S = inputs_parsed[3];
     650:	8b 45 80             	mov    -0x80(%ebp),%eax
     653:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  M = inputs_parsed[4];
     656:	8b 45 84             	mov    -0x7c(%ebp),%eax
     659:	89 45 d0             	mov    %eax,-0x30(%ebp)
  
  printf(1,"A: %d B: %d C: %d  S: %d M: %d\n",A,B,C,S,M);
     65c:	8b 45 d0             	mov    -0x30(%ebp),%eax
     65f:	89 44 24 18          	mov    %eax,0x18(%esp)
     663:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     666:	89 44 24 14          	mov    %eax,0x14(%esp)
     66a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     66d:	89 44 24 10          	mov    %eax,0x10(%esp)
     671:	8b 45 dc             	mov    -0x24(%ebp),%eax
     674:	89 44 24 0c          	mov    %eax,0xc(%esp)
     678:	8b 45 e0             	mov    -0x20(%ebp),%eax
     67b:	89 44 24 08          	mov    %eax,0x8(%esp)
     67f:	c7 44 24 04 54 18 00 	movl   $0x1854,0x4(%esp)
     686:	00 
     687:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     68e:	e8 6c 09 00 00       	call   fff <printf>
  
  void* students_stacks[S];
     693:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     696:	8d 50 ff             	lea    -0x1(%eax),%edx
     699:	89 55 cc             	mov    %edx,-0x34(%ebp)
     69c:	c1 e0 02             	shl    $0x2,%eax
     69f:	8d 50 0f             	lea    0xf(%eax),%edx
     6a2:	b8 10 00 00 00       	mov    $0x10,%eax
     6a7:	83 e8 01             	sub    $0x1,%eax
     6aa:	01 d0                	add    %edx,%eax
     6ac:	c7 85 64 ff ff ff 10 	movl   $0x10,-0x9c(%ebp)
     6b3:	00 00 00 
     6b6:	ba 00 00 00 00       	mov    $0x0,%edx
     6bb:	f7 b5 64 ff ff ff    	divl   -0x9c(%ebp)
     6c1:	6b c0 10             	imul   $0x10,%eax,%eax
     6c4:	29 c4                	sub    %eax,%esp
     6c6:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     6ca:	83 c0 0f             	add    $0xf,%eax
     6cd:	c1 e8 04             	shr    $0x4,%eax
     6d0:	c1 e0 04             	shl    $0x4,%eax
     6d3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  void* bartenders_stacks[B];
     6d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
     6d9:	8d 50 ff             	lea    -0x1(%eax),%edx
     6dc:	89 55 c4             	mov    %edx,-0x3c(%ebp)
     6df:	c1 e0 02             	shl    $0x2,%eax
     6e2:	8d 50 0f             	lea    0xf(%eax),%edx
     6e5:	b8 10 00 00 00       	mov    $0x10,%eax
     6ea:	83 e8 01             	sub    $0x1,%eax
     6ed:	01 d0                	add    %edx,%eax
     6ef:	c7 85 64 ff ff ff 10 	movl   $0x10,-0x9c(%ebp)
     6f6:	00 00 00 
     6f9:	ba 00 00 00 00       	mov    $0x0,%edx
     6fe:	f7 b5 64 ff ff ff    	divl   -0x9c(%ebp)
     704:	6b c0 10             	imul   $0x10,%eax,%eax
     707:	29 c4                	sub    %eax,%esp
     709:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     70d:	83 c0 0f             	add    $0xf,%eax
     710:	c1 e8 04             	shr    $0x4,%eax
     713:	c1 e0 04             	shl    $0x4,%eax
     716:	89 45 c0             	mov    %eax,-0x40(%ebp)
  void* cup_boy_stack;
  int i;
  int student_tids[S];
     719:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     71c:	8d 50 ff             	lea    -0x1(%eax),%edx
     71f:	89 55 bc             	mov    %edx,-0x44(%ebp)
     722:	c1 e0 02             	shl    $0x2,%eax
     725:	8d 50 0f             	lea    0xf(%eax),%edx
     728:	b8 10 00 00 00       	mov    $0x10,%eax
     72d:	83 e8 01             	sub    $0x1,%eax
     730:	01 d0                	add    %edx,%eax
     732:	c7 85 64 ff ff ff 10 	movl   $0x10,-0x9c(%ebp)
     739:	00 00 00 
     73c:	ba 00 00 00 00       	mov    $0x0,%edx
     741:	f7 b5 64 ff ff ff    	divl   -0x9c(%ebp)
     747:	6b c0 10             	imul   $0x10,%eax,%eax
     74a:	29 c4                	sub    %eax,%esp
     74c:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     750:	83 c0 0f             	add    $0xf,%eax
     753:	c1 e8 04             	shr    $0x4,%eax
     756:	c1 e0 04             	shl    $0x4,%eax
     759:	89 45 b8             	mov    %eax,-0x48(%ebp)
  int bartender_tids[B];
     75c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     75f:	8d 50 ff             	lea    -0x1(%eax),%edx
     762:	89 55 b4             	mov    %edx,-0x4c(%ebp)
     765:	c1 e0 02             	shl    $0x2,%eax
     768:	8d 50 0f             	lea    0xf(%eax),%edx
     76b:	b8 10 00 00 00       	mov    $0x10,%eax
     770:	83 e8 01             	sub    $0x1,%eax
     773:	01 d0                	add    %edx,%eax
     775:	c7 85 64 ff ff ff 10 	movl   $0x10,-0x9c(%ebp)
     77c:	00 00 00 
     77f:	ba 00 00 00 00       	mov    $0x0,%edx
     784:	f7 b5 64 ff ff ff    	divl   -0x9c(%ebp)
     78a:	6b c0 10             	imul   $0x10,%eax,%eax
     78d:	29 c4                	sub    %eax,%esp
     78f:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     793:	83 c0 0f             	add    $0xf,%eax
     796:	c1 e8 04             	shr    $0x4,%eax
     799:	c1 e0 04             	shl    $0x4,%eax
     79c:	89 45 b0             	mov    %eax,-0x50(%ebp)
  int finished_shift = 0; // cup_boy changes it to 1 if all students left the bar and sends Action => GO_HOME to bartenders
     79f:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  int test;
  
  file_to_write = open("out.txt",(O_CREATE | O_WRONLY)); //
     7a6:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     7ad:	00 
     7ae:	c7 04 24 74 18 00 00 	movl   $0x1874,(%esp)
     7b5:	e8 ce 06 00 00       	call   e88 <open>
     7ba:	a3 44 1f 00 00       	mov    %eax,0x1f44
  if(file_to_write == -1){
     7bf:	a1 44 1f 00 00       	mov    0x1f44,%eax
     7c4:	83 f8 ff             	cmp    $0xffffffff,%eax
     7c7:	75 19                	jne    7e2 <main+0x25e>
      printf(1,"There was an error opening out.txt\n");
     7c9:	c7 44 24 04 7c 18 00 	movl   $0x187c,0x4(%esp)
     7d0:	00 
     7d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7d8:	e8 22 08 00 00       	call   fff <printf>
      exit();
     7dd:	e8 66 06 00 00       	call   e48 <exit>
  }
  
  
  //Databases
   bouncer = semaphore_create(M);		//this is the bouncer to the Beinstein
     7e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
     7e5:	89 04 24             	mov    %eax,(%esp)
     7e8:	e8 d7 0b 00 00       	call   13c4 <semaphore_create>
     7ed:	a3 30 1f 00 00       	mov    %eax,0x1f30
   ABB = BB_create(A); 				//this is a BB for student actions: drink, ans for a dring
     7f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7f5:	89 04 24             	mov    %eax,(%esp)
     7f8:	e8 1f 0d 00 00       	call   151c <BB_create>
     7fd:	a3 38 1f 00 00       	mov    %eax,0x1f38
   DrinkBB = BB_create(A);			//this is a BB holding the drinks that are ready to be drinking
     802:	8b 45 e0             	mov    -0x20(%ebp),%eax
     805:	89 04 24             	mov    %eax,(%esp)
     808:	e8 0f 0d 00 00       	call   151c <BB_create>
     80d:	a3 48 1f 00 00       	mov    %eax,0x1f48
   CBB = BB_create(C);				//this is a BB hold clean cups
     812:	8b 45 d8             	mov    -0x28(%ebp),%eax
     815:	89 04 24             	mov    %eax,(%esp)
     818:	e8 ff 0c 00 00       	call   151c <BB_create>
     81d:	a3 64 1f 00 00       	mov    %eax,0x1f64
   DBB = BB_create(C);				//this is a BB hold dirty cups
     822:	8b 45 d8             	mov    -0x28(%ebp),%eax
     825:	89 04 24             	mov    %eax,(%esp)
     828:	e8 ef 0c 00 00       	call   151c <BB_create>
     82d:	a3 3c 1f 00 00       	mov    %eax,0x1f3c
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
     832:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     839:	e8 d2 06 00 00       	call   f10 <binary_semaphore_create>
     83e:	a3 60 1f 00 00       	mov    %eax,0x1f60
   general_mutex = binary_semaphore_create(1);
     843:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     84a:	e8 c1 06 00 00       	call   f10 <binary_semaphore_create>
     84f:	a3 40 1f 00 00       	mov    %eax,0x1f40

   //initialize C clean cups
   struct Cup* cup_array[C];
     854:	8b 45 d8             	mov    -0x28(%ebp),%eax
     857:	8d 50 ff             	lea    -0x1(%eax),%edx
     85a:	89 55 a8             	mov    %edx,-0x58(%ebp)
     85d:	c1 e0 02             	shl    $0x2,%eax
     860:	8d 50 0f             	lea    0xf(%eax),%edx
     863:	b8 10 00 00 00       	mov    $0x10,%eax
     868:	83 e8 01             	sub    $0x1,%eax
     86b:	01 d0                	add    %edx,%eax
     86d:	c7 85 64 ff ff ff 10 	movl   $0x10,-0x9c(%ebp)
     874:	00 00 00 
     877:	ba 00 00 00 00       	mov    $0x0,%edx
     87c:	f7 b5 64 ff ff ff    	divl   -0x9c(%ebp)
     882:	6b c0 10             	imul   $0x10,%eax,%eax
     885:	29 c4                	sub    %eax,%esp
     887:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     88b:	83 c0 0f             	add    $0xf,%eax
     88e:	c1 e8 04             	shr    $0x4,%eax
     891:	c1 e0 04             	shl    $0x4,%eax
     894:	89 45 a4             	mov    %eax,-0x5c(%ebp)
   for(i = 0; i < C; i++){
     897:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     89e:	eb 38                	jmp    8d8 <main+0x354>
      cup_array[i] = (Cup*)malloc(sizeof(Cup)); //TODO free cups
     8a0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     8a7:	e8 37 0a 00 00       	call   12e3 <malloc>
     8ac:	8b 55 a4             	mov    -0x5c(%ebp),%edx
     8af:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     8b2:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      cup_array[i]->id = i;
     8b5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     8b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8bb:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8be:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8c1:	89 10                	mov    %edx,(%eax)
      add_clean_cup(cup_array[i]);
     8c3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     8c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8c9:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8cc:	89 04 24             	mov    %eax,(%esp)
     8cf:	e8 cd f7 ff ff       	call   a1 <add_clean_cup>
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
   general_mutex = binary_semaphore_create(1);

   //initialize C clean cups
   struct Cup* cup_array[C];
   for(i = 0; i < C; i++){
     8d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     8de:	7c c0                	jl     8a0 <main+0x31c>
   
   //initialize cup_boy
   //cup_boy_stack = (void*)malloc(STACK_SIZE);
   //thread_create((void*)cup_boy,cup_boy_stack,STACK_SIZE); 
   
   cup_boy_stack = malloc(sizeof(void*)*STACK_SIZE);
     8e0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     8e7:	e8 f7 09 00 00       	call   12e3 <malloc>
     8ec:	89 45 a0             	mov    %eax,-0x60(%ebp)
   memset(cup_boy_stack,0,sizeof(void*)*STACK_SIZE);
     8ef:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     8f6:	00 
     8f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     8fe:	00 
     8ff:	8b 45 a0             	mov    -0x60(%ebp),%eax
     902:	89 04 24             	mov    %eax,(%esp)
     905:	e8 99 03 00 00       	call   ca3 <memset>
   test = thread_create((void*)cup_boy,cup_boy_stack,STACK_SIZE); 
     90a:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     911:	00 
     912:	8b 45 a0             	mov    -0x60(%ebp),%eax
     915:	89 44 24 04          	mov    %eax,0x4(%esp)
     919:	c7 04 24 2f 03 00 00 	movl   $0x32f,(%esp)
     920:	e8 c3 05 00 00       	call   ee8 <thread_create>
     925:	89 45 9c             	mov    %eax,-0x64(%ebp)
   tests(test);
     928:	8b 45 9c             	mov    -0x64(%ebp),%eax
     92b:	89 04 24             	mov    %eax,(%esp)
     92e:	e8 88 fa ff ff       	call   3bb <tests>
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     933:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     93a:	eb 69                	jmp    9a5 <main+0x421>
      bartenders_stacks[i] = malloc(sizeof(void*)*STACK_SIZE);
     93c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     943:	e8 9b 09 00 00       	call   12e3 <malloc>
     948:	8b 55 c0             	mov    -0x40(%ebp),%edx
     94b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     94e:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(bartenders_stacks[i],0,sizeof(void*)*STACK_SIZE);
     951:	8b 45 c0             	mov    -0x40(%ebp),%eax
     954:	8b 55 f4             	mov    -0xc(%ebp),%edx
     957:	8b 04 90             	mov    (%eax,%edx,4),%eax
     95a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     961:	00 
     962:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     969:	00 
     96a:	89 04 24             	mov    %eax,(%esp)
     96d:	e8 31 03 00 00       	call   ca3 <memset>
      test = thread_create((void*)bartender,bartenders_stacks[i],STACK_SIZE);
     972:	8b 45 c0             	mov    -0x40(%ebp),%eax
     975:	8b 55 f4             	mov    -0xc(%ebp),%edx
     978:	8b 04 90             	mov    (%eax,%edx,4),%eax
     97b:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     982:	00 
     983:	89 44 24 04          	mov    %eax,0x4(%esp)
     987:	c7 04 24 35 02 00 00 	movl   $0x235,(%esp)
     98e:	e8 55 05 00 00       	call   ee8 <thread_create>
     993:	89 45 9c             	mov    %eax,-0x64(%ebp)
      tests(test);
     996:	8b 45 9c             	mov    -0x64(%ebp),%eax
     999:	89 04 24             	mov    %eax,(%esp)
     99c:	e8 1a fa ff ff       	call   3bb <tests>
   memset(cup_boy_stack,0,sizeof(void*)*STACK_SIZE);
   test = thread_create((void*)cup_boy,cup_boy_stack,STACK_SIZE); 
   tests(test);
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     9a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9a8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     9ab:	7c 8f                	jl     93c <main+0x3b8>
      test = thread_create((void*)bartender,bartenders_stacks[i],STACK_SIZE);
      tests(test);
  }
   
   //initialize S students
   for(i = 0; i < S; i++){
     9ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9b4:	eb 75                	jmp    a2b <main+0x4a7>
      students_stacks[i] = (void*)malloc(sizeof(void*)*STACK_SIZE);
     9b6:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     9bd:	e8 21 09 00 00       	call   12e3 <malloc>
     9c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
     9c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     9c8:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
     9cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
     9ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9d1:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9d4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     9db:	00 
     9dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     9e3:	00 
     9e4:	89 04 24             	mov    %eax,(%esp)
     9e7:	e8 b7 02 00 00       	call   ca3 <memset>
      student_tids[i] = thread_create((void*)student,students_stacks[i],STACK_SIZE);
     9ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
     9ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9f2:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9f5:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     9fc:	00 
     9fd:	89 44 24 04          	mov    %eax,0x4(%esp)
     a01:	c7 04 24 ee 00 00 00 	movl   $0xee,(%esp)
     a08:	e8 db 04 00 00       	call   ee8 <thread_create>
     a0d:	8b 55 b8             	mov    -0x48(%ebp),%edx
     a10:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a13:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      tests(student_tids[i]);
     a16:	8b 45 b8             	mov    -0x48(%ebp),%eax
     a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a1c:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a1f:	89 04 24             	mov    %eax,(%esp)
     a22:	e8 94 f9 ff ff       	call   3bb <tests>
      test = thread_create((void*)bartender,bartenders_stacks[i],STACK_SIZE);
      tests(test);
  }
   
   //initialize S students
   for(i = 0; i < S; i++){
     a27:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a2e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     a31:	7c 83                	jl     9b6 <main+0x432>
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
      student_tids[i] = thread_create((void*)student,students_stacks[i],STACK_SIZE);
      tests(student_tids[i]);
  }
  //join students
    printf(1,"join students\n");
     a33:	c7 44 24 04 a0 18 00 	movl   $0x18a0,0x4(%esp)
     a3a:	00 
     a3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a42:	e8 b8 05 00 00       	call   fff <printf>
    for(i=0;i<S;i++){
     a47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a4e:	eb 46                	jmp    a96 <main+0x512>
     test = thread_join(student_tids[i],0); 
     a50:	8b 45 b8             	mov    -0x48(%ebp),%eax
     a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a56:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     a60:	00 
     a61:	89 04 24             	mov    %eax,(%esp)
     a64:	e8 97 04 00 00       	call   f00 <thread_join>
     a69:	89 45 9c             	mov    %eax,-0x64(%ebp)
      printf(1,"join student: %d \n", i);
     a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a6f:	89 44 24 08          	mov    %eax,0x8(%esp)
     a73:	c7 44 24 04 af 18 00 	movl   $0x18af,0x4(%esp)
     a7a:	00 
     a7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a82:	e8 78 05 00 00       	call   fff <printf>
     tests(test);
     a87:	8b 45 9c             	mov    -0x64(%ebp),%eax
     a8a:	89 04 24             	mov    %eax,(%esp)
     a8d:	e8 29 f9 ff ff       	call   3bb <tests>
      student_tids[i] = thread_create((void*)student,students_stacks[i],STACK_SIZE);
      tests(student_tids[i]);
  }
  //join students
    printf(1,"join students\n");
    for(i=0;i<S;i++){
     a92:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a99:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     a9c:	7c b2                	jl     a50 <main+0x4cc>
     test = thread_join(student_tids[i],0); 
      printf(1,"join student: %d \n", i);
     tests(test);
    }
    printf(1,"done join student:\n");
     a9e:	c7 44 24 04 c2 18 00 	movl   $0x18c2,0x4(%esp)
     aa5:	00 
     aa6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     aad:	e8 4d 05 00 00       	call   fff <printf>
   
   //join_peoples(student_tids,S); //join students
   finished_shift = 1;
     ab2:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
   if(finished_shift){
     ab9:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
     abd:	74 0d                	je     acc <main+0x548>
    binary_semaphore_up(cup_boy_lock); 
     abf:	a1 60 1f 00 00       	mov    0x1f60,%eax
     ac4:	89 04 24             	mov    %eax,(%esp)
     ac7:	e8 54 04 00 00       	call   f20 <binary_semaphore_up>
   }
   release_workers(B);
     acc:	8b 45 dc             	mov    -0x24(%ebp),%eax
     acf:	89 04 24             	mov    %eax,(%esp)
     ad2:	e8 42 f9 ff ff       	call   419 <release_workers>
   join_peoples(bartender_tids,B); //join bartenders
     ad7:	8b 45 b0             	mov    -0x50(%ebp),%eax
     ada:	8b 55 dc             	mov    -0x24(%ebp),%edx
     add:	89 54 24 04          	mov    %edx,0x4(%esp)
     ae1:	89 04 24             	mov    %eax,(%esp)
     ae4:	e8 f9 f8 ff ff       	call   3e2 <join_peoples>
   sleep(2); // delay so exit will not come before threads finished TODO (need better soloution)
     ae9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     af0:	e8 e3 03 00 00       	call   ed8 <sleep>
   
   if(close(file_to_write) == -1){
     af5:	a1 44 1f 00 00       	mov    0x1f44,%eax
     afa:	89 04 24             	mov    %eax,(%esp)
     afd:	e8 6e 03 00 00       	call   e70 <close>
     b02:	83 f8 ff             	cmp    $0xffffffff,%eax
     b05:	75 19                	jne    b20 <main+0x59c>
    printf(1,"There was an error closing out.txt\n");
     b07:	c7 44 24 04 d8 18 00 	movl   $0x18d8,0x4(%esp)
     b0e:	00 
     b0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b16:	e8 e4 04 00 00       	call   fff <printf>
    exit();
     b1b:	e8 28 03 00 00       	call   e48 <exit>
   }
   
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     b20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b27:	eb 15                	jmp    b3e <main+0x5ba>
    free(cup_array[i]);
     b29:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b2f:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b32:	89 04 24             	mov    %eax,(%esp)
     b35:	e8 7a 06 00 00       	call   11b4 <free>
    exit();
   }
   
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     b3a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b41:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     b44:	7c e3                	jl     b29 <main+0x5a5>
    free(cup_array[i]);
  }
  
  //free cup_boy_stack
  free(cup_boy_stack);
     b46:	8b 45 a0             	mov    -0x60(%ebp),%eax
     b49:	89 04 24             	mov    %eax,(%esp)
     b4c:	e8 63 06 00 00       	call   11b4 <free>
  
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     b51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b58:	eb 15                	jmp    b6f <main+0x5eb>
   free(bartenders_stacks[i]); 
     b5a:	8b 45 c0             	mov    -0x40(%ebp),%eax
     b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b60:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b63:	89 04 24             	mov    %eax,(%esp)
     b66:	e8 49 06 00 00       	call   11b4 <free>
  
  //free cup_boy_stack
  free(cup_boy_stack);
  
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     b6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b72:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     b75:	7c e3                	jl     b5a <main+0x5d6>
   free(bartenders_stacks[i]); 
  }
  
  //free students_stacks
  for(i = 0; i < S; i++){
     b77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b7e:	eb 15                	jmp    b95 <main+0x611>
   free(students_stacks[i]); 
     b80:	8b 45 c8             	mov    -0x38(%ebp),%eax
     b83:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b86:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b89:	89 04 24             	mov    %eax,(%esp)
     b8c:	e8 23 06 00 00       	call   11b4 <free>
  for(i = 0; i < B; i++){
   free(bartenders_stacks[i]); 
  }
  
  //free students_stacks
  for(i = 0; i < S; i++){
     b91:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b98:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     b9b:	7c e3                	jl     b80 <main+0x5fc>
   free(students_stacks[i]); 
  }
  
  semaphore_free(bouncer);
     b9d:	a1 30 1f 00 00       	mov    0x1f30,%eax
     ba2:	89 04 24             	mov    %eax,(%esp)
     ba5:	e8 5c 09 00 00       	call   1506 <semaphore_free>
  BB_free(ABB);
     baa:	a1 38 1f 00 00       	mov    0x1f38,%eax
     baf:	89 04 24             	mov    %eax,(%esp)
     bb2:	e8 9e 0b 00 00       	call   1755 <BB_free>
  BB_free(DrinkBB);
     bb7:	a1 48 1f 00 00       	mov    0x1f48,%eax
     bbc:	89 04 24             	mov    %eax,(%esp)
     bbf:	e8 91 0b 00 00       	call   1755 <BB_free>
  BB_free(CBB);
     bc4:	a1 64 1f 00 00       	mov    0x1f64,%eax
     bc9:	89 04 24             	mov    %eax,(%esp)
     bcc:	e8 84 0b 00 00       	call   1755 <BB_free>
  BB_free(DBB);
     bd1:	a1 3c 1f 00 00       	mov    0x1f3c,%eax
     bd6:	89 04 24             	mov    %eax,(%esp)
     bd9:	e8 77 0b 00 00       	call   1755 <BB_free>
 
  exit();
     bde:	e8 65 02 00 00       	call   e48 <exit>
     be3:	90                   	nop

00000be4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     be4:	55                   	push   %ebp
     be5:	89 e5                	mov    %esp,%ebp
     be7:	57                   	push   %edi
     be8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     be9:	8b 4d 08             	mov    0x8(%ebp),%ecx
     bec:	8b 55 10             	mov    0x10(%ebp),%edx
     bef:	8b 45 0c             	mov    0xc(%ebp),%eax
     bf2:	89 cb                	mov    %ecx,%ebx
     bf4:	89 df                	mov    %ebx,%edi
     bf6:	89 d1                	mov    %edx,%ecx
     bf8:	fc                   	cld    
     bf9:	f3 aa                	rep stos %al,%es:(%edi)
     bfb:	89 ca                	mov    %ecx,%edx
     bfd:	89 fb                	mov    %edi,%ebx
     bff:	89 5d 08             	mov    %ebx,0x8(%ebp)
     c02:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     c05:	5b                   	pop    %ebx
     c06:	5f                   	pop    %edi
     c07:	5d                   	pop    %ebp
     c08:	c3                   	ret    

00000c09 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     c09:	55                   	push   %ebp
     c0a:	89 e5                	mov    %esp,%ebp
     c0c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     c0f:	8b 45 08             	mov    0x8(%ebp),%eax
     c12:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     c15:	90                   	nop
     c16:	8b 45 0c             	mov    0xc(%ebp),%eax
     c19:	0f b6 10             	movzbl (%eax),%edx
     c1c:	8b 45 08             	mov    0x8(%ebp),%eax
     c1f:	88 10                	mov    %dl,(%eax)
     c21:	8b 45 08             	mov    0x8(%ebp),%eax
     c24:	0f b6 00             	movzbl (%eax),%eax
     c27:	84 c0                	test   %al,%al
     c29:	0f 95 c0             	setne  %al
     c2c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     c30:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     c34:	84 c0                	test   %al,%al
     c36:	75 de                	jne    c16 <strcpy+0xd>
    ;
  return os;
     c38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     c3b:	c9                   	leave  
     c3c:	c3                   	ret    

00000c3d <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c3d:	55                   	push   %ebp
     c3e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     c40:	eb 08                	jmp    c4a <strcmp+0xd>
    p++, q++;
     c42:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     c46:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     c4a:	8b 45 08             	mov    0x8(%ebp),%eax
     c4d:	0f b6 00             	movzbl (%eax),%eax
     c50:	84 c0                	test   %al,%al
     c52:	74 10                	je     c64 <strcmp+0x27>
     c54:	8b 45 08             	mov    0x8(%ebp),%eax
     c57:	0f b6 10             	movzbl (%eax),%edx
     c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c5d:	0f b6 00             	movzbl (%eax),%eax
     c60:	38 c2                	cmp    %al,%dl
     c62:	74 de                	je     c42 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     c64:	8b 45 08             	mov    0x8(%ebp),%eax
     c67:	0f b6 00             	movzbl (%eax),%eax
     c6a:	0f b6 d0             	movzbl %al,%edx
     c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     c70:	0f b6 00             	movzbl (%eax),%eax
     c73:	0f b6 c0             	movzbl %al,%eax
     c76:	89 d1                	mov    %edx,%ecx
     c78:	29 c1                	sub    %eax,%ecx
     c7a:	89 c8                	mov    %ecx,%eax
}
     c7c:	5d                   	pop    %ebp
     c7d:	c3                   	ret    

00000c7e <strlen>:

uint
strlen(char *s)
{
     c7e:	55                   	push   %ebp
     c7f:	89 e5                	mov    %esp,%ebp
     c81:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     c84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     c8b:	eb 04                	jmp    c91 <strlen+0x13>
     c8d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c94:	03 45 08             	add    0x8(%ebp),%eax
     c97:	0f b6 00             	movzbl (%eax),%eax
     c9a:	84 c0                	test   %al,%al
     c9c:	75 ef                	jne    c8d <strlen+0xf>
    ;
  return n;
     c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     ca1:	c9                   	leave  
     ca2:	c3                   	ret    

00000ca3 <memset>:

void*
memset(void *dst, int c, uint n)
{
     ca3:	55                   	push   %ebp
     ca4:	89 e5                	mov    %esp,%ebp
     ca6:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     ca9:	8b 45 10             	mov    0x10(%ebp),%eax
     cac:	89 44 24 08          	mov    %eax,0x8(%esp)
     cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
     cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
     cb7:	8b 45 08             	mov    0x8(%ebp),%eax
     cba:	89 04 24             	mov    %eax,(%esp)
     cbd:	e8 22 ff ff ff       	call   be4 <stosb>
  return dst;
     cc2:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cc5:	c9                   	leave  
     cc6:	c3                   	ret    

00000cc7 <strchr>:

char*
strchr(const char *s, char c)
{
     cc7:	55                   	push   %ebp
     cc8:	89 e5                	mov    %esp,%ebp
     cca:	83 ec 04             	sub    $0x4,%esp
     ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
     cd0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     cd3:	eb 14                	jmp    ce9 <strchr+0x22>
    if(*s == c)
     cd5:	8b 45 08             	mov    0x8(%ebp),%eax
     cd8:	0f b6 00             	movzbl (%eax),%eax
     cdb:	3a 45 fc             	cmp    -0x4(%ebp),%al
     cde:	75 05                	jne    ce5 <strchr+0x1e>
      return (char*)s;
     ce0:	8b 45 08             	mov    0x8(%ebp),%eax
     ce3:	eb 13                	jmp    cf8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     ce5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     ce9:	8b 45 08             	mov    0x8(%ebp),%eax
     cec:	0f b6 00             	movzbl (%eax),%eax
     cef:	84 c0                	test   %al,%al
     cf1:	75 e2                	jne    cd5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     cf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     cf8:	c9                   	leave  
     cf9:	c3                   	ret    

00000cfa <gets>:

char*
gets(char *buf, int max)
{
     cfa:	55                   	push   %ebp
     cfb:	89 e5                	mov    %esp,%ebp
     cfd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d07:	eb 44                	jmp    d4d <gets+0x53>
    cc = read(0, &c, 1);
     d09:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     d10:	00 
     d11:	8d 45 ef             	lea    -0x11(%ebp),%eax
     d14:	89 44 24 04          	mov    %eax,0x4(%esp)
     d18:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     d1f:	e8 3c 01 00 00       	call   e60 <read>
     d24:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     d27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d2b:	7e 2d                	jle    d5a <gets+0x60>
      break;
    buf[i++] = c;
     d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d30:	03 45 08             	add    0x8(%ebp),%eax
     d33:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     d37:	88 10                	mov    %dl,(%eax)
     d39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     d3d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     d41:	3c 0a                	cmp    $0xa,%al
     d43:	74 16                	je     d5b <gets+0x61>
     d45:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     d49:	3c 0d                	cmp    $0xd,%al
     d4b:	74 0e                	je     d5b <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d50:	83 c0 01             	add    $0x1,%eax
     d53:	3b 45 0c             	cmp    0xc(%ebp),%eax
     d56:	7c b1                	jl     d09 <gets+0xf>
     d58:	eb 01                	jmp    d5b <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     d5a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d5e:	03 45 08             	add    0x8(%ebp),%eax
     d61:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     d64:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d67:	c9                   	leave  
     d68:	c3                   	ret    

00000d69 <stat>:

int
stat(char *n, struct stat *st)
{
     d69:	55                   	push   %ebp
     d6a:	89 e5                	mov    %esp,%ebp
     d6c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     d76:	00 
     d77:	8b 45 08             	mov    0x8(%ebp),%eax
     d7a:	89 04 24             	mov    %eax,(%esp)
     d7d:	e8 06 01 00 00       	call   e88 <open>
     d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d89:	79 07                	jns    d92 <stat+0x29>
    return -1;
     d8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d90:	eb 23                	jmp    db5 <stat+0x4c>
  r = fstat(fd, st);
     d92:	8b 45 0c             	mov    0xc(%ebp),%eax
     d95:	89 44 24 04          	mov    %eax,0x4(%esp)
     d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d9c:	89 04 24             	mov    %eax,(%esp)
     d9f:	e8 fc 00 00 00       	call   ea0 <fstat>
     da4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     daa:	89 04 24             	mov    %eax,(%esp)
     dad:	e8 be 00 00 00       	call   e70 <close>
  return r;
     db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     db5:	c9                   	leave  
     db6:	c3                   	ret    

00000db7 <atoi>:

int
atoi(const char *s)
{
     db7:	55                   	push   %ebp
     db8:	89 e5                	mov    %esp,%ebp
     dba:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     dbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     dc4:	eb 23                	jmp    de9 <atoi+0x32>
    n = n*10 + *s++ - '0';
     dc6:	8b 55 fc             	mov    -0x4(%ebp),%edx
     dc9:	89 d0                	mov    %edx,%eax
     dcb:	c1 e0 02             	shl    $0x2,%eax
     dce:	01 d0                	add    %edx,%eax
     dd0:	01 c0                	add    %eax,%eax
     dd2:	89 c2                	mov    %eax,%edx
     dd4:	8b 45 08             	mov    0x8(%ebp),%eax
     dd7:	0f b6 00             	movzbl (%eax),%eax
     dda:	0f be c0             	movsbl %al,%eax
     ddd:	01 d0                	add    %edx,%eax
     ddf:	83 e8 30             	sub    $0x30,%eax
     de2:	89 45 fc             	mov    %eax,-0x4(%ebp)
     de5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     de9:	8b 45 08             	mov    0x8(%ebp),%eax
     dec:	0f b6 00             	movzbl (%eax),%eax
     def:	3c 2f                	cmp    $0x2f,%al
     df1:	7e 0a                	jle    dfd <atoi+0x46>
     df3:	8b 45 08             	mov    0x8(%ebp),%eax
     df6:	0f b6 00             	movzbl (%eax),%eax
     df9:	3c 39                	cmp    $0x39,%al
     dfb:	7e c9                	jle    dc6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e00:	c9                   	leave  
     e01:	c3                   	ret    

00000e02 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     e02:	55                   	push   %ebp
     e03:	89 e5                	mov    %esp,%ebp
     e05:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     e08:	8b 45 08             	mov    0x8(%ebp),%eax
     e0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
     e11:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     e14:	eb 13                	jmp    e29 <memmove+0x27>
    *dst++ = *src++;
     e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e19:	0f b6 10             	movzbl (%eax),%edx
     e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e1f:	88 10                	mov    %dl,(%eax)
     e21:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     e25:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     e2d:	0f 9f c0             	setg   %al
     e30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     e34:	84 c0                	test   %al,%al
     e36:	75 de                	jne    e16 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e3b:	c9                   	leave  
     e3c:	c3                   	ret    
     e3d:	90                   	nop
     e3e:	90                   	nop
     e3f:	90                   	nop

00000e40 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e40:	b8 01 00 00 00       	mov    $0x1,%eax
     e45:	cd 40                	int    $0x40
     e47:	c3                   	ret    

00000e48 <exit>:
SYSCALL(exit)
     e48:	b8 02 00 00 00       	mov    $0x2,%eax
     e4d:	cd 40                	int    $0x40
     e4f:	c3                   	ret    

00000e50 <wait>:
SYSCALL(wait)
     e50:	b8 03 00 00 00       	mov    $0x3,%eax
     e55:	cd 40                	int    $0x40
     e57:	c3                   	ret    

00000e58 <pipe>:
SYSCALL(pipe)
     e58:	b8 04 00 00 00       	mov    $0x4,%eax
     e5d:	cd 40                	int    $0x40
     e5f:	c3                   	ret    

00000e60 <read>:
SYSCALL(read)
     e60:	b8 05 00 00 00       	mov    $0x5,%eax
     e65:	cd 40                	int    $0x40
     e67:	c3                   	ret    

00000e68 <write>:
SYSCALL(write)
     e68:	b8 10 00 00 00       	mov    $0x10,%eax
     e6d:	cd 40                	int    $0x40
     e6f:	c3                   	ret    

00000e70 <close>:
SYSCALL(close)
     e70:	b8 15 00 00 00       	mov    $0x15,%eax
     e75:	cd 40                	int    $0x40
     e77:	c3                   	ret    

00000e78 <kill>:
SYSCALL(kill)
     e78:	b8 06 00 00 00       	mov    $0x6,%eax
     e7d:	cd 40                	int    $0x40
     e7f:	c3                   	ret    

00000e80 <exec>:
SYSCALL(exec)
     e80:	b8 07 00 00 00       	mov    $0x7,%eax
     e85:	cd 40                	int    $0x40
     e87:	c3                   	ret    

00000e88 <open>:
SYSCALL(open)
     e88:	b8 0f 00 00 00       	mov    $0xf,%eax
     e8d:	cd 40                	int    $0x40
     e8f:	c3                   	ret    

00000e90 <mknod>:
SYSCALL(mknod)
     e90:	b8 11 00 00 00       	mov    $0x11,%eax
     e95:	cd 40                	int    $0x40
     e97:	c3                   	ret    

00000e98 <unlink>:
SYSCALL(unlink)
     e98:	b8 12 00 00 00       	mov    $0x12,%eax
     e9d:	cd 40                	int    $0x40
     e9f:	c3                   	ret    

00000ea0 <fstat>:
SYSCALL(fstat)
     ea0:	b8 08 00 00 00       	mov    $0x8,%eax
     ea5:	cd 40                	int    $0x40
     ea7:	c3                   	ret    

00000ea8 <link>:
SYSCALL(link)
     ea8:	b8 13 00 00 00       	mov    $0x13,%eax
     ead:	cd 40                	int    $0x40
     eaf:	c3                   	ret    

00000eb0 <mkdir>:
SYSCALL(mkdir)
     eb0:	b8 14 00 00 00       	mov    $0x14,%eax
     eb5:	cd 40                	int    $0x40
     eb7:	c3                   	ret    

00000eb8 <chdir>:
SYSCALL(chdir)
     eb8:	b8 09 00 00 00       	mov    $0x9,%eax
     ebd:	cd 40                	int    $0x40
     ebf:	c3                   	ret    

00000ec0 <dup>:
SYSCALL(dup)
     ec0:	b8 0a 00 00 00       	mov    $0xa,%eax
     ec5:	cd 40                	int    $0x40
     ec7:	c3                   	ret    

00000ec8 <getpid>:
SYSCALL(getpid)
     ec8:	b8 0b 00 00 00       	mov    $0xb,%eax
     ecd:	cd 40                	int    $0x40
     ecf:	c3                   	ret    

00000ed0 <sbrk>:
SYSCALL(sbrk)
     ed0:	b8 0c 00 00 00       	mov    $0xc,%eax
     ed5:	cd 40                	int    $0x40
     ed7:	c3                   	ret    

00000ed8 <sleep>:
SYSCALL(sleep)
     ed8:	b8 0d 00 00 00       	mov    $0xd,%eax
     edd:	cd 40                	int    $0x40
     edf:	c3                   	ret    

00000ee0 <uptime>:
SYSCALL(uptime)
     ee0:	b8 0e 00 00 00       	mov    $0xe,%eax
     ee5:	cd 40                	int    $0x40
     ee7:	c3                   	ret    

00000ee8 <thread_create>:
SYSCALL(thread_create)
     ee8:	b8 16 00 00 00       	mov    $0x16,%eax
     eed:	cd 40                	int    $0x40
     eef:	c3                   	ret    

00000ef0 <thread_getId>:
SYSCALL(thread_getId)
     ef0:	b8 17 00 00 00       	mov    $0x17,%eax
     ef5:	cd 40                	int    $0x40
     ef7:	c3                   	ret    

00000ef8 <thread_getProcId>:
SYSCALL(thread_getProcId)
     ef8:	b8 18 00 00 00       	mov    $0x18,%eax
     efd:	cd 40                	int    $0x40
     eff:	c3                   	ret    

00000f00 <thread_join>:
SYSCALL(thread_join)
     f00:	b8 19 00 00 00       	mov    $0x19,%eax
     f05:	cd 40                	int    $0x40
     f07:	c3                   	ret    

00000f08 <thread_exit>:
SYSCALL(thread_exit)
     f08:	b8 1a 00 00 00       	mov    $0x1a,%eax
     f0d:	cd 40                	int    $0x40
     f0f:	c3                   	ret    

00000f10 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     f10:	b8 1b 00 00 00       	mov    $0x1b,%eax
     f15:	cd 40                	int    $0x40
     f17:	c3                   	ret    

00000f18 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     f18:	b8 1c 00 00 00       	mov    $0x1c,%eax
     f1d:	cd 40                	int    $0x40
     f1f:	c3                   	ret    

00000f20 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     f20:	b8 1d 00 00 00       	mov    $0x1d,%eax
     f25:	cd 40                	int    $0x40
     f27:	c3                   	ret    

00000f28 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     f28:	55                   	push   %ebp
     f29:	89 e5                	mov    %esp,%ebp
     f2b:	83 ec 28             	sub    $0x28,%esp
     f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
     f31:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     f34:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     f3b:	00 
     f3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
     f3f:	89 44 24 04          	mov    %eax,0x4(%esp)
     f43:	8b 45 08             	mov    0x8(%ebp),%eax
     f46:	89 04 24             	mov    %eax,(%esp)
     f49:	e8 1a ff ff ff       	call   e68 <write>
}
     f4e:	c9                   	leave  
     f4f:	c3                   	ret    

00000f50 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f50:	55                   	push   %ebp
     f51:	89 e5                	mov    %esp,%ebp
     f53:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     f56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     f5d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     f61:	74 17                	je     f7a <printint+0x2a>
     f63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f67:	79 11                	jns    f7a <printint+0x2a>
    neg = 1;
     f69:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     f70:	8b 45 0c             	mov    0xc(%ebp),%eax
     f73:	f7 d8                	neg    %eax
     f75:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f78:	eb 06                	jmp    f80 <printint+0x30>
  } else {
    x = xx;
     f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
     f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     f80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     f87:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f8d:	ba 00 00 00 00       	mov    $0x0,%edx
     f92:	f7 f1                	div    %ecx
     f94:	89 d0                	mov    %edx,%eax
     f96:	0f b6 90 10 1f 00 00 	movzbl 0x1f10(%eax),%edx
     f9d:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fa0:	03 45 f4             	add    -0xc(%ebp),%eax
     fa3:	88 10                	mov    %dl,(%eax)
     fa5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     fa9:	8b 55 10             	mov    0x10(%ebp),%edx
     fac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     faf:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fb2:	ba 00 00 00 00       	mov    $0x0,%edx
     fb7:	f7 75 d4             	divl   -0x2c(%ebp)
     fba:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fc1:	75 c4                	jne    f87 <printint+0x37>
  if(neg)
     fc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fc7:	74 2a                	je     ff3 <printint+0xa3>
    buf[i++] = '-';
     fc9:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fcc:	03 45 f4             	add    -0xc(%ebp),%eax
     fcf:	c6 00 2d             	movb   $0x2d,(%eax)
     fd2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     fd6:	eb 1b                	jmp    ff3 <printint+0xa3>
    putc(fd, buf[i]);
     fd8:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fdb:	03 45 f4             	add    -0xc(%ebp),%eax
     fde:	0f b6 00             	movzbl (%eax),%eax
     fe1:	0f be c0             	movsbl %al,%eax
     fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
     fe8:	8b 45 08             	mov    0x8(%ebp),%eax
     feb:	89 04 24             	mov    %eax,(%esp)
     fee:	e8 35 ff ff ff       	call   f28 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     ff3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     ff7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ffb:	79 db                	jns    fd8 <printint+0x88>
    putc(fd, buf[i]);
}
     ffd:	c9                   	leave  
     ffe:	c3                   	ret    

00000fff <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     fff:	55                   	push   %ebp
    1000:	89 e5                	mov    %esp,%ebp
    1002:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1005:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    100c:	8d 45 0c             	lea    0xc(%ebp),%eax
    100f:	83 c0 04             	add    $0x4,%eax
    1012:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1015:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    101c:	e9 7d 01 00 00       	jmp    119e <printf+0x19f>
    c = fmt[i] & 0xff;
    1021:	8b 55 0c             	mov    0xc(%ebp),%edx
    1024:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1027:	01 d0                	add    %edx,%eax
    1029:	0f b6 00             	movzbl (%eax),%eax
    102c:	0f be c0             	movsbl %al,%eax
    102f:	25 ff 00 00 00       	and    $0xff,%eax
    1034:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1037:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    103b:	75 2c                	jne    1069 <printf+0x6a>
      if(c == '%'){
    103d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1041:	75 0c                	jne    104f <printf+0x50>
        state = '%';
    1043:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    104a:	e9 4b 01 00 00       	jmp    119a <printf+0x19b>
      } else {
        putc(fd, c);
    104f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1052:	0f be c0             	movsbl %al,%eax
    1055:	89 44 24 04          	mov    %eax,0x4(%esp)
    1059:	8b 45 08             	mov    0x8(%ebp),%eax
    105c:	89 04 24             	mov    %eax,(%esp)
    105f:	e8 c4 fe ff ff       	call   f28 <putc>
    1064:	e9 31 01 00 00       	jmp    119a <printf+0x19b>
      }
    } else if(state == '%'){
    1069:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    106d:	0f 85 27 01 00 00    	jne    119a <printf+0x19b>
      if(c == 'd'){
    1073:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1077:	75 2d                	jne    10a6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1079:	8b 45 e8             	mov    -0x18(%ebp),%eax
    107c:	8b 00                	mov    (%eax),%eax
    107e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1085:	00 
    1086:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    108d:	00 
    108e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1092:	8b 45 08             	mov    0x8(%ebp),%eax
    1095:	89 04 24             	mov    %eax,(%esp)
    1098:	e8 b3 fe ff ff       	call   f50 <printint>
        ap++;
    109d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10a1:	e9 ed 00 00 00       	jmp    1193 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    10a6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    10aa:	74 06                	je     10b2 <printf+0xb3>
    10ac:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    10b0:	75 2d                	jne    10df <printf+0xe0>
        printint(fd, *ap, 16, 0);
    10b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10b5:	8b 00                	mov    (%eax),%eax
    10b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    10be:	00 
    10bf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    10c6:	00 
    10c7:	89 44 24 04          	mov    %eax,0x4(%esp)
    10cb:	8b 45 08             	mov    0x8(%ebp),%eax
    10ce:	89 04 24             	mov    %eax,(%esp)
    10d1:	e8 7a fe ff ff       	call   f50 <printint>
        ap++;
    10d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10da:	e9 b4 00 00 00       	jmp    1193 <printf+0x194>
      } else if(c == 's'){
    10df:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    10e3:	75 46                	jne    112b <printf+0x12c>
        s = (char*)*ap;
    10e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10e8:	8b 00                	mov    (%eax),%eax
    10ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    10ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    10f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10f5:	75 27                	jne    111e <printf+0x11f>
          s = "(null)";
    10f7:	c7 45 f4 fc 18 00 00 	movl   $0x18fc,-0xc(%ebp)
        while(*s != 0){
    10fe:	eb 1e                	jmp    111e <printf+0x11f>
          putc(fd, *s);
    1100:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1103:	0f b6 00             	movzbl (%eax),%eax
    1106:	0f be c0             	movsbl %al,%eax
    1109:	89 44 24 04          	mov    %eax,0x4(%esp)
    110d:	8b 45 08             	mov    0x8(%ebp),%eax
    1110:	89 04 24             	mov    %eax,(%esp)
    1113:	e8 10 fe ff ff       	call   f28 <putc>
          s++;
    1118:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    111c:	eb 01                	jmp    111f <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    111e:	90                   	nop
    111f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1122:	0f b6 00             	movzbl (%eax),%eax
    1125:	84 c0                	test   %al,%al
    1127:	75 d7                	jne    1100 <printf+0x101>
    1129:	eb 68                	jmp    1193 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    112b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    112f:	75 1d                	jne    114e <printf+0x14f>
        putc(fd, *ap);
    1131:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1134:	8b 00                	mov    (%eax),%eax
    1136:	0f be c0             	movsbl %al,%eax
    1139:	89 44 24 04          	mov    %eax,0x4(%esp)
    113d:	8b 45 08             	mov    0x8(%ebp),%eax
    1140:	89 04 24             	mov    %eax,(%esp)
    1143:	e8 e0 fd ff ff       	call   f28 <putc>
        ap++;
    1148:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    114c:	eb 45                	jmp    1193 <printf+0x194>
      } else if(c == '%'){
    114e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1152:	75 17                	jne    116b <printf+0x16c>
        putc(fd, c);
    1154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1157:	0f be c0             	movsbl %al,%eax
    115a:	89 44 24 04          	mov    %eax,0x4(%esp)
    115e:	8b 45 08             	mov    0x8(%ebp),%eax
    1161:	89 04 24             	mov    %eax,(%esp)
    1164:	e8 bf fd ff ff       	call   f28 <putc>
    1169:	eb 28                	jmp    1193 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    116b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1172:	00 
    1173:	8b 45 08             	mov    0x8(%ebp),%eax
    1176:	89 04 24             	mov    %eax,(%esp)
    1179:	e8 aa fd ff ff       	call   f28 <putc>
        putc(fd, c);
    117e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1181:	0f be c0             	movsbl %al,%eax
    1184:	89 44 24 04          	mov    %eax,0x4(%esp)
    1188:	8b 45 08             	mov    0x8(%ebp),%eax
    118b:	89 04 24             	mov    %eax,(%esp)
    118e:	e8 95 fd ff ff       	call   f28 <putc>
      }
      state = 0;
    1193:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    119a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    119e:	8b 55 0c             	mov    0xc(%ebp),%edx
    11a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11a4:	01 d0                	add    %edx,%eax
    11a6:	0f b6 00             	movzbl (%eax),%eax
    11a9:	84 c0                	test   %al,%al
    11ab:	0f 85 70 fe ff ff    	jne    1021 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    11b1:	c9                   	leave  
    11b2:	c3                   	ret    
    11b3:	90                   	nop

000011b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11b4:	55                   	push   %ebp
    11b5:	89 e5                	mov    %esp,%ebp
    11b7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11ba:	8b 45 08             	mov    0x8(%ebp),%eax
    11bd:	83 e8 08             	sub    $0x8,%eax
    11c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11c3:	a1 2c 1f 00 00       	mov    0x1f2c,%eax
    11c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11cb:	eb 24                	jmp    11f1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11d0:	8b 00                	mov    (%eax),%eax
    11d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11d5:	77 12                	ja     11e9 <free+0x35>
    11d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11dd:	77 24                	ja     1203 <free+0x4f>
    11df:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11e2:	8b 00                	mov    (%eax),%eax
    11e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11e7:	77 1a                	ja     1203 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11ec:	8b 00                	mov    (%eax),%eax
    11ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11f7:	76 d4                	jbe    11cd <free+0x19>
    11f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11fc:	8b 00                	mov    (%eax),%eax
    11fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1201:	76 ca                	jbe    11cd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1203:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1206:	8b 40 04             	mov    0x4(%eax),%eax
    1209:	c1 e0 03             	shl    $0x3,%eax
    120c:	89 c2                	mov    %eax,%edx
    120e:	03 55 f8             	add    -0x8(%ebp),%edx
    1211:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1214:	8b 00                	mov    (%eax),%eax
    1216:	39 c2                	cmp    %eax,%edx
    1218:	75 24                	jne    123e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    121a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    121d:	8b 50 04             	mov    0x4(%eax),%edx
    1220:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1223:	8b 00                	mov    (%eax),%eax
    1225:	8b 40 04             	mov    0x4(%eax),%eax
    1228:	01 c2                	add    %eax,%edx
    122a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    122d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1230:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1233:	8b 00                	mov    (%eax),%eax
    1235:	8b 10                	mov    (%eax),%edx
    1237:	8b 45 f8             	mov    -0x8(%ebp),%eax
    123a:	89 10                	mov    %edx,(%eax)
    123c:	eb 0a                	jmp    1248 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    123e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1241:	8b 10                	mov    (%eax),%edx
    1243:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1246:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1248:	8b 45 fc             	mov    -0x4(%ebp),%eax
    124b:	8b 40 04             	mov    0x4(%eax),%eax
    124e:	c1 e0 03             	shl    $0x3,%eax
    1251:	03 45 fc             	add    -0x4(%ebp),%eax
    1254:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1257:	75 20                	jne    1279 <free+0xc5>
    p->s.size += bp->s.size;
    1259:	8b 45 fc             	mov    -0x4(%ebp),%eax
    125c:	8b 50 04             	mov    0x4(%eax),%edx
    125f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1262:	8b 40 04             	mov    0x4(%eax),%eax
    1265:	01 c2                	add    %eax,%edx
    1267:	8b 45 fc             	mov    -0x4(%ebp),%eax
    126a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    126d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1270:	8b 10                	mov    (%eax),%edx
    1272:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1275:	89 10                	mov    %edx,(%eax)
    1277:	eb 08                	jmp    1281 <free+0xcd>
  } else
    p->s.ptr = bp;
    1279:	8b 45 fc             	mov    -0x4(%ebp),%eax
    127c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    127f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1281:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1284:	a3 2c 1f 00 00       	mov    %eax,0x1f2c
}
    1289:	c9                   	leave  
    128a:	c3                   	ret    

0000128b <morecore>:

static Header*
morecore(uint nu)
{
    128b:	55                   	push   %ebp
    128c:	89 e5                	mov    %esp,%ebp
    128e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1291:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1298:	77 07                	ja     12a1 <morecore+0x16>
    nu = 4096;
    129a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    12a1:	8b 45 08             	mov    0x8(%ebp),%eax
    12a4:	c1 e0 03             	shl    $0x3,%eax
    12a7:	89 04 24             	mov    %eax,(%esp)
    12aa:	e8 21 fc ff ff       	call   ed0 <sbrk>
    12af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    12b2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    12b6:	75 07                	jne    12bf <morecore+0x34>
    return 0;
    12b8:	b8 00 00 00 00       	mov    $0x0,%eax
    12bd:	eb 22                	jmp    12e1 <morecore+0x56>
  hp = (Header*)p;
    12bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    12c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12c8:	8b 55 08             	mov    0x8(%ebp),%edx
    12cb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    12ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12d1:	83 c0 08             	add    $0x8,%eax
    12d4:	89 04 24             	mov    %eax,(%esp)
    12d7:	e8 d8 fe ff ff       	call   11b4 <free>
  return freep;
    12dc:	a1 2c 1f 00 00       	mov    0x1f2c,%eax
}
    12e1:	c9                   	leave  
    12e2:	c3                   	ret    

000012e3 <malloc>:

void*
malloc(uint nbytes)
{
    12e3:	55                   	push   %ebp
    12e4:	89 e5                	mov    %esp,%ebp
    12e6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12e9:	8b 45 08             	mov    0x8(%ebp),%eax
    12ec:	83 c0 07             	add    $0x7,%eax
    12ef:	c1 e8 03             	shr    $0x3,%eax
    12f2:	83 c0 01             	add    $0x1,%eax
    12f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    12f8:	a1 2c 1f 00 00       	mov    0x1f2c,%eax
    12fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1300:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1304:	75 23                	jne    1329 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1306:	c7 45 f0 24 1f 00 00 	movl   $0x1f24,-0x10(%ebp)
    130d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1310:	a3 2c 1f 00 00       	mov    %eax,0x1f2c
    1315:	a1 2c 1f 00 00       	mov    0x1f2c,%eax
    131a:	a3 24 1f 00 00       	mov    %eax,0x1f24
    base.s.size = 0;
    131f:	c7 05 28 1f 00 00 00 	movl   $0x0,0x1f28
    1326:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1329:	8b 45 f0             	mov    -0x10(%ebp),%eax
    132c:	8b 00                	mov    (%eax),%eax
    132e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1331:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1334:	8b 40 04             	mov    0x4(%eax),%eax
    1337:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    133a:	72 4d                	jb     1389 <malloc+0xa6>
      if(p->s.size == nunits)
    133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    133f:	8b 40 04             	mov    0x4(%eax),%eax
    1342:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1345:	75 0c                	jne    1353 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1347:	8b 45 f4             	mov    -0xc(%ebp),%eax
    134a:	8b 10                	mov    (%eax),%edx
    134c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    134f:	89 10                	mov    %edx,(%eax)
    1351:	eb 26                	jmp    1379 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1353:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1356:	8b 40 04             	mov    0x4(%eax),%eax
    1359:	89 c2                	mov    %eax,%edx
    135b:	2b 55 ec             	sub    -0x14(%ebp),%edx
    135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1361:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1364:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1367:	8b 40 04             	mov    0x4(%eax),%eax
    136a:	c1 e0 03             	shl    $0x3,%eax
    136d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1370:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1373:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1376:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1379:	8b 45 f0             	mov    -0x10(%ebp),%eax
    137c:	a3 2c 1f 00 00       	mov    %eax,0x1f2c
      return (void*)(p + 1);
    1381:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1384:	83 c0 08             	add    $0x8,%eax
    1387:	eb 38                	jmp    13c1 <malloc+0xde>
    }
    if(p == freep)
    1389:	a1 2c 1f 00 00       	mov    0x1f2c,%eax
    138e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1391:	75 1b                	jne    13ae <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1393:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1396:	89 04 24             	mov    %eax,(%esp)
    1399:	e8 ed fe ff ff       	call   128b <morecore>
    139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13a5:	75 07                	jne    13ae <malloc+0xcb>
        return 0;
    13a7:	b8 00 00 00 00       	mov    $0x0,%eax
    13ac:	eb 13                	jmp    13c1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b7:	8b 00                	mov    (%eax),%eax
    13b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    13bc:	e9 70 ff ff ff       	jmp    1331 <malloc+0x4e>
}
    13c1:	c9                   	leave  
    13c2:	c3                   	ret    
    13c3:	90                   	nop

000013c4 <semaphore_create>:
#include "semaphore.h"
#include "types.h"
#include "user.h"


struct semaphore* semaphore_create(int initial_semaphore_value){
    13c4:	55                   	push   %ebp
    13c5:	89 e5                	mov    %esp,%ebp
    13c7:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* sem=malloc(sizeof(struct semaphore)); 
    13ca:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    13d1:	e8 0d ff ff ff       	call   12e3 <malloc>
    13d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // acquire semaphors
  sem->s1 = binary_semaphore_create(1);
    13d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13e0:	e8 2b fb ff ff       	call   f10 <binary_semaphore_create>
    13e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13e8:	89 02                	mov    %eax,(%edx)
  
  // s2 should be initialized with the min{1,initial_semaphore_value}
  if(initial_semaphore_value >= 1){
    13ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    13ee:	7e 14                	jle    1404 <semaphore_create+0x40>
    sem->s2 = binary_semaphore_create(1);
    13f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13f7:	e8 14 fb ff ff       	call   f10 <binary_semaphore_create>
    13fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13ff:	89 42 04             	mov    %eax,0x4(%edx)
    1402:	eb 11                	jmp    1415 <semaphore_create+0x51>
  }else{
    sem->s2 = binary_semaphore_create(initial_semaphore_value);
    1404:	8b 45 08             	mov    0x8(%ebp),%eax
    1407:	89 04 24             	mov    %eax,(%esp)
    140a:	e8 01 fb ff ff       	call   f10 <binary_semaphore_create>
    140f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1412:	89 42 04             	mov    %eax,0x4(%edx)
  }
  if(sem->s1 == -1 || sem->s2 == -1){
    1415:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1418:	8b 00                	mov    (%eax),%eax
    141a:	83 f8 ff             	cmp    $0xffffffff,%eax
    141d:	74 0b                	je     142a <semaphore_create+0x66>
    141f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1422:	8b 40 04             	mov    0x4(%eax),%eax
    1425:	83 f8 ff             	cmp    $0xffffffff,%eax
    1428:	75 2d                	jne    1457 <semaphore_create+0x93>
     printf(1,"we had a probalem initialize in semaphore_create\n");
    142a:	c7 44 24 04 04 19 00 	movl   $0x1904,0x4(%esp)
    1431:	00 
    1432:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1439:	e8 c1 fb ff ff       	call   fff <printf>
     free(sem);
    143e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1441:	89 04 24             	mov    %eax,(%esp)
    1444:	e8 6b fd ff ff       	call   11b4 <free>
     sem =0;
    1449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     return 0;
    1450:	b8 00 00 00 00       	mov    $0x0,%eax
    1455:	eb 0c                	jmp    1463 <semaphore_create+0x9f>
  }
  //initialize value
  sem->value = initial_semaphore_value;//dynamic
    1457:	8b 45 f4             	mov    -0xc(%ebp),%eax
    145a:	8b 55 08             	mov    0x8(%ebp),%edx
    145d:	89 50 08             	mov    %edx,0x8(%eax)
  //sem->initial_value = initial_semaphore_value;//static
  
  return sem;
    1460:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1463:	c9                   	leave  
    1464:	c3                   	ret    

00001465 <semaphore_down>:
void semaphore_down(struct semaphore* sem ){
    1465:	55                   	push   %ebp
    1466:	89 e5                	mov    %esp,%ebp
    1468:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s2);
    146b:	8b 45 08             	mov    0x8(%ebp),%eax
    146e:	8b 40 04             	mov    0x4(%eax),%eax
    1471:	89 04 24             	mov    %eax,(%esp)
    1474:	e8 9f fa ff ff       	call   f18 <binary_semaphore_down>
  binary_semaphore_down(sem->s1);
    1479:	8b 45 08             	mov    0x8(%ebp),%eax
    147c:	8b 00                	mov    (%eax),%eax
    147e:	89 04 24             	mov    %eax,(%esp)
    1481:	e8 92 fa ff ff       	call   f18 <binary_semaphore_down>
  sem->value--;	
    1486:	8b 45 08             	mov    0x8(%ebp),%eax
    1489:	8b 40 08             	mov    0x8(%eax),%eax
    148c:	8d 50 ff             	lea    -0x1(%eax),%edx
    148f:	8b 45 08             	mov    0x8(%ebp),%eax
    1492:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value > 0){
    1495:	8b 45 08             	mov    0x8(%ebp),%eax
    1498:	8b 40 08             	mov    0x8(%eax),%eax
    149b:	85 c0                	test   %eax,%eax
    149d:	7e 0e                	jle    14ad <semaphore_down+0x48>
   binary_semaphore_up(sem->s2);
    149f:	8b 45 08             	mov    0x8(%ebp),%eax
    14a2:	8b 40 04             	mov    0x4(%eax),%eax
    14a5:	89 04 24             	mov    %eax,(%esp)
    14a8:	e8 73 fa ff ff       	call   f20 <binary_semaphore_up>
  }
  binary_semaphore_up(sem->s1); 
    14ad:	8b 45 08             	mov    0x8(%ebp),%eax
    14b0:	8b 00                	mov    (%eax),%eax
    14b2:	89 04 24             	mov    %eax,(%esp)
    14b5:	e8 66 fa ff ff       	call   f20 <binary_semaphore_up>
}
    14ba:	c9                   	leave  
    14bb:	c3                   	ret    

000014bc <semaphore_up>:
void semaphore_up(struct semaphore* sem ){
    14bc:	55                   	push   %ebp
    14bd:	89 e5                	mov    %esp,%ebp
    14bf:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
    14c2:	8b 45 08             	mov    0x8(%ebp),%eax
    14c5:	8b 00                	mov    (%eax),%eax
    14c7:	89 04 24             	mov    %eax,(%esp)
    14ca:	e8 49 fa ff ff       	call   f18 <binary_semaphore_down>
  sem->value++;	
    14cf:	8b 45 08             	mov    0x8(%ebp),%eax
    14d2:	8b 40 08             	mov    0x8(%eax),%eax
    14d5:	8d 50 01             	lea    0x1(%eax),%edx
    14d8:	8b 45 08             	mov    0x8(%ebp),%eax
    14db:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value ==1){
    14de:	8b 45 08             	mov    0x8(%ebp),%eax
    14e1:	8b 40 08             	mov    0x8(%eax),%eax
    14e4:	83 f8 01             	cmp    $0x1,%eax
    14e7:	75 0e                	jne    14f7 <semaphore_up+0x3b>
   binary_semaphore_up(sem->s2); 
    14e9:	8b 45 08             	mov    0x8(%ebp),%eax
    14ec:	8b 40 04             	mov    0x4(%eax),%eax
    14ef:	89 04 24             	mov    %eax,(%esp)
    14f2:	e8 29 fa ff ff       	call   f20 <binary_semaphore_up>
   }
  binary_semaphore_up(sem->s1);
    14f7:	8b 45 08             	mov    0x8(%ebp),%eax
    14fa:	8b 00                	mov    (%eax),%eax
    14fc:	89 04 24             	mov    %eax,(%esp)
    14ff:	e8 1c fa ff ff       	call   f20 <binary_semaphore_up>
}
    1504:	c9                   	leave  
    1505:	c3                   	ret    

00001506 <semaphore_free>:

void semaphore_free(struct semaphore* sem){
    1506:	55                   	push   %ebp
    1507:	89 e5                	mov    %esp,%ebp
    1509:	83 ec 18             	sub    $0x18,%esp
  free(sem);
    150c:	8b 45 08             	mov    0x8(%ebp),%eax
    150f:	89 04 24             	mov    %eax,(%esp)
    1512:	e8 9d fc ff ff       	call   11b4 <free>
}
    1517:	c9                   	leave  
    1518:	c3                   	ret    
    1519:	90                   	nop
    151a:	90                   	nop
    151b:	90                   	nop

0000151c <BB_create>:
#include "types.h"
#include "user.h"


struct BB* 
BB_create(int max_capacity){
    151c:	55                   	push   %ebp
    151d:	89 e5                	mov    %esp,%ebp
    151f:	83 ec 38             	sub    $0x38,%esp
  //initialize
  struct BB* buf = malloc(sizeof(struct BB));
    1522:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
    1529:	e8 b5 fd ff ff       	call   12e3 <malloc>
    152e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
    1531:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    1538:	00 
    1539:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1540:	00 
    1541:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1544:	89 04 24             	mov    %eax,(%esp)
    1547:	e8 57 f7 ff ff       	call   ca3 <memset>
 
  buf->buffer_size = max_capacity;
    154c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    154f:	8b 55 08             	mov    0x8(%ebp),%edx
    1552:	89 10                	mov    %edx,(%eax)
  buf->mutex = binary_semaphore_create(1);  
    1554:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    155b:	e8 b0 f9 ff ff       	call   f10 <binary_semaphore_create>
    1560:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1563:	89 42 04             	mov    %eax,0x4(%edx)
  buf->empty = semaphore_create(max_capacity);
    1566:	8b 45 08             	mov    0x8(%ebp),%eax
    1569:	89 04 24             	mov    %eax,(%esp)
    156c:	e8 53 fe ff ff       	call   13c4 <semaphore_create>
    1571:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1574:	89 42 08             	mov    %eax,0x8(%edx)
  buf->full = semaphore_create(0);
    1577:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    157e:	e8 41 fe ff ff       	call   13c4 <semaphore_create>
    1583:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1586:	89 42 0c             	mov    %eax,0xc(%edx)
  
  //void** elements_array = (void**)malloc(sizeof(void*) * max_capacity); 
  //memset(buf->elements_array,0,sizeof(void*)*max_capacity);
  //buf->pointer_to_elements = elements_array;  
  
  buf->pointer_to_elements = malloc(sizeof(void*)*max_capacity);
    1589:	8b 45 08             	mov    0x8(%ebp),%eax
    158c:	c1 e0 02             	shl    $0x2,%eax
    158f:	89 04 24             	mov    %eax,(%esp)
    1592:	e8 4c fd ff ff       	call   12e3 <malloc>
    1597:	8b 55 f4             	mov    -0xc(%ebp),%edx
    159a:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->pointer_to_elements,0,sizeof(void*)*max_capacity);
    159d:	8b 45 08             	mov    0x8(%ebp),%eax
    15a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    15a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15aa:	8b 40 1c             	mov    0x1c(%eax),%eax
    15ad:	89 54 24 08          	mov    %edx,0x8(%esp)
    15b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    15b8:	00 
    15b9:	89 04 24             	mov    %eax,(%esp)
    15bc:	e8 e2 f6 ff ff       	call   ca3 <memset>
  
  buf->count = 0;
    15c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c4:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  //check the semaphorses
  if(buf->mutex == -1 || buf->empty == 0 || buf->full == 0){
    15cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15ce:	8b 40 04             	mov    0x4(%eax),%eax
    15d1:	83 f8 ff             	cmp    $0xffffffff,%eax
    15d4:	74 14                	je     15ea <BB_create+0xce>
    15d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15d9:	8b 40 08             	mov    0x8(%eax),%eax
    15dc:	85 c0                	test   %eax,%eax
    15de:	74 0a                	je     15ea <BB_create+0xce>
    15e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15e3:	8b 40 0c             	mov    0xc(%eax),%eax
    15e6:	85 c0                	test   %eax,%eax
    15e8:	75 52                	jne    163c <BB_create+0x120>
   printf(1,"we had a problam getting semaphores at BB create mutex %d empty %d full %d\n",buf->mutex,buf->empty,buf->full);
    15ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15ed:	8b 48 0c             	mov    0xc(%eax),%ecx
    15f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15f3:	8b 50 08             	mov    0x8(%eax),%edx
    15f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15f9:	8b 40 04             	mov    0x4(%eax),%eax
    15fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    1600:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1604:	89 44 24 08          	mov    %eax,0x8(%esp)
    1608:	c7 44 24 04 38 19 00 	movl   $0x1938,0x4(%esp)
    160f:	00 
    1610:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1617:	e8 e3 f9 ff ff       	call   fff <printf>
   free(buf->pointer_to_elements);
    161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    161f:	8b 40 1c             	mov    0x1c(%eax),%eax
    1622:	89 04 24             	mov    %eax,(%esp)
    1625:	e8 8a fb ff ff       	call   11b4 <free>
   free(buf);
    162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    162d:	89 04 24             	mov    %eax,(%esp)
    1630:	e8 7f fb ff ff       	call   11b4 <free>
   buf =0;  
    1635:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  }
  return buf;
    163c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    163f:	c9                   	leave  
    1640:	c3                   	ret    

00001641 <BB_put>:

void BB_put(struct BB* bb, void* element)
{ 
    1641:	55                   	push   %ebp
    1642:	89 e5                	mov    %esp,%ebp
    1644:	83 ec 18             	sub    $0x18,%esp
  bb->pointer_to_elements[bb->count] = element;
  bb->count++;
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->full);
  */
  semaphore_down(bb->empty);
    1647:	8b 45 08             	mov    0x8(%ebp),%eax
    164a:	8b 40 08             	mov    0x8(%eax),%eax
    164d:	89 04 24             	mov    %eax,(%esp)
    1650:	e8 10 fe ff ff       	call   1465 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    1655:	8b 45 08             	mov    0x8(%ebp),%eax
    1658:	8b 40 04             	mov    0x4(%eax),%eax
    165b:	89 04 24             	mov    %eax,(%esp)
    165e:	e8 b5 f8 ff ff       	call   f18 <binary_semaphore_down>
   //insert item
  bb->pointer_to_elements[bb->end] = element;
    1663:	8b 45 08             	mov    0x8(%ebp),%eax
    1666:	8b 50 1c             	mov    0x1c(%eax),%edx
    1669:	8b 45 08             	mov    0x8(%ebp),%eax
    166c:	8b 40 18             	mov    0x18(%eax),%eax
    166f:	c1 e0 02             	shl    $0x2,%eax
    1672:	01 c2                	add    %eax,%edx
    1674:	8b 45 0c             	mov    0xc(%ebp),%eax
    1677:	89 02                	mov    %eax,(%edx)
  ++bb->end;
    1679:	8b 45 08             	mov    0x8(%ebp),%eax
    167c:	8b 40 18             	mov    0x18(%eax),%eax
    167f:	8d 50 01             	lea    0x1(%eax),%edx
    1682:	8b 45 08             	mov    0x8(%ebp),%eax
    1685:	89 50 18             	mov    %edx,0x18(%eax)
  bb->end = bb->end%bb->buffer_size;
    1688:	8b 45 08             	mov    0x8(%ebp),%eax
    168b:	8b 40 18             	mov    0x18(%eax),%eax
    168e:	8b 55 08             	mov    0x8(%ebp),%edx
    1691:	8b 0a                	mov    (%edx),%ecx
    1693:	89 c2                	mov    %eax,%edx
    1695:	c1 fa 1f             	sar    $0x1f,%edx
    1698:	f7 f9                	idiv   %ecx
    169a:	8b 45 08             	mov    0x8(%ebp),%eax
    169d:	89 50 18             	mov    %edx,0x18(%eax)
  binary_semaphore_up(bb->mutex);
    16a0:	8b 45 08             	mov    0x8(%ebp),%eax
    16a3:	8b 40 04             	mov    0x4(%eax),%eax
    16a6:	89 04 24             	mov    %eax,(%esp)
    16a9:	e8 72 f8 ff ff       	call   f20 <binary_semaphore_up>
  semaphore_up(bb->full);
    16ae:	8b 45 08             	mov    0x8(%ebp),%eax
    16b1:	8b 40 0c             	mov    0xc(%eax),%eax
    16b4:	89 04 24             	mov    %eax,(%esp)
    16b7:	e8 00 fe ff ff       	call   14bc <semaphore_up>
    
}
    16bc:	c9                   	leave  
    16bd:	c3                   	ret    

000016be <BB_pop>:

void* BB_pop(struct BB* bb)
{
    16be:	55                   	push   %ebp
    16bf:	89 e5                	mov    %esp,%ebp
    16c1:	83 ec 28             	sub    $0x28,%esp
  
  void* element_to_pop;
  semaphore_down(bb->full);
    16c4:	8b 45 08             	mov    0x8(%ebp),%eax
    16c7:	8b 40 0c             	mov    0xc(%eax),%eax
    16ca:	89 04 24             	mov    %eax,(%esp)
    16cd:	e8 93 fd ff ff       	call   1465 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    16d2:	8b 45 08             	mov    0x8(%ebp),%eax
    16d5:	8b 40 04             	mov    0x4(%eax),%eax
    16d8:	89 04 24             	mov    %eax,(%esp)
    16db:	e8 38 f8 ff ff       	call   f18 <binary_semaphore_down>
  element_to_pop = bb-> pointer_to_elements[bb->start];
    16e0:	8b 45 08             	mov    0x8(%ebp),%eax
    16e3:	8b 50 1c             	mov    0x1c(%eax),%edx
    16e6:	8b 45 08             	mov    0x8(%ebp),%eax
    16e9:	8b 40 14             	mov    0x14(%eax),%eax
    16ec:	c1 e0 02             	shl    $0x2,%eax
    16ef:	01 d0                	add    %edx,%eax
    16f1:	8b 00                	mov    (%eax),%eax
    16f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->pointer_to_elements[bb->start] =0;
    16f6:	8b 45 08             	mov    0x8(%ebp),%eax
    16f9:	8b 50 1c             	mov    0x1c(%eax),%edx
    16fc:	8b 45 08             	mov    0x8(%ebp),%eax
    16ff:	8b 40 14             	mov    0x14(%eax),%eax
    1702:	c1 e0 02             	shl    $0x2,%eax
    1705:	01 d0                	add    %edx,%eax
    1707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
    170d:	8b 45 08             	mov    0x8(%ebp),%eax
    1710:	8b 40 14             	mov    0x14(%eax),%eax
    1713:	8d 50 01             	lea    0x1(%eax),%edx
    1716:	8b 45 08             	mov    0x8(%ebp),%eax
    1719:	89 50 14             	mov    %edx,0x14(%eax)
  bb->start = bb->start%bb->buffer_size;
    171c:	8b 45 08             	mov    0x8(%ebp),%eax
    171f:	8b 40 14             	mov    0x14(%eax),%eax
    1722:	8b 55 08             	mov    0x8(%ebp),%edx
    1725:	8b 0a                	mov    (%edx),%ecx
    1727:	89 c2                	mov    %eax,%edx
    1729:	c1 fa 1f             	sar    $0x1f,%edx
    172c:	f7 f9                	idiv   %ecx
    172e:	8b 45 08             	mov    0x8(%ebp),%eax
    1731:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
    1734:	8b 45 08             	mov    0x8(%ebp),%eax
    1737:	8b 40 04             	mov    0x4(%eax),%eax
    173a:	89 04 24             	mov    %eax,(%esp)
    173d:	e8 de f7 ff ff       	call   f20 <binary_semaphore_up>
  semaphore_up(bb->empty);
    1742:	8b 45 08             	mov    0x8(%ebp),%eax
    1745:	8b 40 08             	mov    0x8(%eax),%eax
    1748:	89 04 24             	mov    %eax,(%esp)
    174b:	e8 6c fd ff ff       	call   14bc <semaphore_up>
  return element_to_pop;
    1750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->empty);
  
  return element_to_pop;*/
}
    1753:	c9                   	leave  
    1754:	c3                   	ret    

00001755 <BB_free>:

void BB_free(struct BB* bb){
    1755:	55                   	push   %ebp
    1756:	89 e5                	mov    %esp,%ebp
    1758:	83 ec 18             	sub    $0x18,%esp
  free(bb->pointer_to_elements);
    175b:	8b 45 08             	mov    0x8(%ebp),%eax
    175e:	8b 40 1c             	mov    0x1c(%eax),%eax
    1761:	89 04 24             	mov    %eax,(%esp)
    1764:	e8 4b fa ff ff       	call   11b4 <free>
  free(bb);
    1769:	8b 45 08             	mov    0x8(%ebp),%eax
    176c:	89 04 24             	mov    %eax,(%esp)
    176f:	e8 40 fa ff ff       	call   11b4 <free>
    1774:	c9                   	leave  
    1775:	c3                   	ret    
