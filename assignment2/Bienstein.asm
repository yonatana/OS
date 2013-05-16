
_Bienstein:     file format elf32-i386


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
       6:	a1 78 1e 00 00       	mov    0x1e78,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 94 13 00 00       	call   13a7 <semaphore_down>
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
      1b:	a1 78 1e 00 00       	mov    0x1e78,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 d6 13 00 00       	call   13fe <semaphore_up>
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
      30:	a1 80 1e 00 00       	mov    0x1e80,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 2f 15 00 00       	call   1573 <BB_put>
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
      4c:	a1 80 1e 00 00       	mov    0x1e80,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 7f 15 00 00       	call   15d8 <BB_pop>
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
      61:	a1 90 1e 00 00       	mov    0x1e90,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 fe 14 00 00       	call   1573 <BB_put>
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
      7d:	a1 90 1e 00 00       	mov    0x1e90,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 4e 15 00 00       	call   15d8 <BB_pop>
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
      92:	a1 ac 1e 00 00       	mov    0x1eac,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 39 15 00 00       	call   15d8 <BB_pop>
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
      a7:	a1 ac 1e 00 00       	mov    0x1eac,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 b8 14 00 00       	call   1573 <BB_put>
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
      c3:	a1 84 1e 00 00       	mov    0x1e84,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 9c 14 00 00       	call   1573 <BB_put>
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
      df:	a1 84 1e 00 00       	mov    0x1e84,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 ec 14 00 00       	call   15d8 <BB_pop>
}
      ec:	c9                   	leave  
      ed:	c3                   	ret    

000000ee <student>:

// student simulation
void* student(){
      ee:	55                   	push   %ebp
      ef:	89 e5                	mov    %esp,%ebp
      f1:	83 ec 48             	sub    $0x48,%esp
   

    enter_bar();
      f4:	e8 07 ff ff ff       	call   0 <enter_bar>
    int tid = thread_getId();
      f9:	e8 32 0d 00 00       	call   e30 <thread_getId>
      fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i;
    for(i = 0; i < tid % 5; i++){
     101:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     108:	e9 e7 00 00 00       	jmp    1f4 <student+0x106>
      struct Action* drink_action = malloc(sizeof(struct Action));
     10d:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     114:	e8 0a 11 00 00       	call   1223 <malloc>
     119:	89 45 ec             	mov    %eax,-0x14(%ebp)
      memset(drink_action,0,sizeof(struct Action));
     11c:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     123:	00 
     124:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     12b:	00 
     12c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     12f:	89 04 24             	mov    %eax,(%esp)
     132:	e8 ac 0a 00 00       	call   be3 <memset>
      drink_action->action_type = DRINK_ORDER;
     137:	8b 45 ec             	mov    -0x14(%ebp),%eax
     13a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      drink_action->cup = 0;
     140:	8b 45 ec             	mov    -0x14(%ebp),%eax
     143:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
      drink_action->tid = tid;
     14a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     14d:	8b 55 f0             	mov    -0x10(%ebp),%edx
     150:	89 50 08             	mov    %edx,0x8(%eax)
      place_action(drink_action);//Order a Drink
     153:	8b 45 ec             	mov    -0x14(%ebp),%eax
     156:	89 04 24             	mov    %eax,(%esp)
     159:	e8 cc fe ff ff       	call   2a <place_action>
      struct Cup * cup = get_drink();	//get the drink from the BB
     15e:	e8 14 ff ff ff       	call   77 <get_drink>
     163:	89 45 e8             	mov    %eax,-0x18(%ebp)
      //need to write to file intsead of screen TODO
      printf(1,"Student %d is having his %d drink, with cup %d\n",tid,i+1,cup->id);
     166:	8b 45 e8             	mov    -0x18(%ebp),%eax
     169:	8b 00                	mov    (%eax),%eax
     16b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     16e:	83 c2 01             	add    $0x1,%edx
     171:	89 44 24 10          	mov    %eax,0x10(%esp)
     175:	89 54 24 0c          	mov    %edx,0xc(%esp)
     179:	8b 45 f0             	mov    -0x10(%ebp),%eax
     17c:	89 44 24 08          	mov    %eax,0x8(%esp)
     180:	c7 44 24 04 f0 16 00 	movl   $0x16f0,0x4(%esp)
     187:	00 
     188:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     18f:	e8 ab 0d 00 00       	call   f3f <printf>
      sleep(1);
     194:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     19b:	e8 78 0c 00 00       	call   e18 <sleep>
      struct Action* return_action = malloc(sizeof(struct Action));
     1a0:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     1a7:	e8 77 10 00 00       	call   1223 <malloc>
     1ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      memset(return_action,0,sizeof(struct Action));
     1af:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     1b6:	00 
     1b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     1be:	00 
     1bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1c2:	89 04 24             	mov    %eax,(%esp)
     1c5:	e8 19 0a 00 00       	call   be3 <memset>
      return_action->action_type = RETURN_CUP;
     1ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1cd:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
      return_action->cup=cup;
     1d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
     1d9:	89 50 04             	mov    %edx,0x4(%eax)
      return_action->tid = tid;
     1dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1df:	8b 55 f0             	mov    -0x10(%ebp),%edx
     1e2:	89 50 08             	mov    %edx,0x8(%eax)
      place_action(return_action);
     1e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1e8:	89 04 24             	mov    %eax,(%esp)
     1eb:	e8 3a fe ff ff       	call   2a <place_action>
   

    enter_bar();
    int tid = thread_getId();
    int i;
    for(i = 0; i < tid % 5; i++){
     1f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1f4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     1f7:	ba 67 66 66 66       	mov    $0x66666667,%edx
     1fc:	89 c8                	mov    %ecx,%eax
     1fe:	f7 ea                	imul   %edx
     200:	d1 fa                	sar    %edx
     202:	89 c8                	mov    %ecx,%eax
     204:	c1 f8 1f             	sar    $0x1f,%eax
     207:	29 c2                	sub    %eax,%edx
     209:	89 d0                	mov    %edx,%eax
     20b:	c1 e0 02             	shl    $0x2,%eax
     20e:	01 d0                	add    %edx,%eax
     210:	89 ca                	mov    %ecx,%edx
     212:	29 c2                	sub    %eax,%edx
     214:	3b 55 f4             	cmp    -0xc(%ebp),%edx
     217:	0f 8f f0 fe ff ff    	jg     10d <student+0x1f>
      return_action->cup=cup;
      return_action->tid = tid;
      place_action(return_action);
    }
    //need to write to file intsead of screen TODO
    printf(1,"Student %d is drunk, and trying to go home\n",thread_getId());
     21d:	e8 0e 0c 00 00       	call   e30 <thread_getId>
     222:	89 44 24 08          	mov    %eax,0x8(%esp)
     226:	c7 44 24 04 20 17 00 	movl   $0x1720,0x4(%esp)
     22d:	00 
     22e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     235:	e8 05 0d 00 00       	call   f3f <printf>
    leave_bar();
     23a:	e8 d6 fd ff ff       	call   15 <leave_bar>
    thread_exit(0);
     23f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     246:	e8 fd 0b 00 00       	call   e48 <thread_exit>
    return 0;
     24b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     250:	c9                   	leave  
     251:	c3                   	ret    

00000252 <bartender>:

//bartender simulation
void* bartender(){
     252:	55                   	push   %ebp
     253:	89 e5                	mov    %esp,%ebp
     255:	83 ec 58             	sub    $0x58,%esp
    void* ret_val = 0;
     258:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int tid = thread_getId();
     25f:	e8 cc 0b 00 00       	call   e30 <thread_getId>
     264:	89 45 f0             	mov    %eax,-0x10(%ebp)
    double amount =0;
     267:	d9 ee                	fldz   
     269:	dd 5d e8             	fstpl  -0x18(%ebp)
    double buf_size =0;
     26c:	d9 ee                	fldz   
     26e:	dd 5d e0             	fstpl  -0x20(%ebp)
    for(;;){
	struct Action* bartender_action = get_action();	
     271:	e8 d0 fd ff ff       	call   46 <get_action>
     276:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(bartender_action->action_type == DRINK_ORDER){
     279:	8b 45 dc             	mov    -0x24(%ebp),%eax
     27c:	8b 00                	mov    (%eax),%eax
     27e:	83 f8 01             	cmp    $0x1,%eax
     281:	75 3c                	jne    2bf <bartender+0x6d>
	    struct Cup* current_cup = get_clean_cup();
     283:	e8 04 fe ff ff       	call   8c <get_clean_cup>
     288:	89 45 d8             	mov    %eax,-0x28(%ebp)
	    //need to write to file intsead of screen TODO
	    printf(1,"Bartender %d is making drink with cup %d\n",tid,current_cup->id);
     28b:	8b 45 d8             	mov    -0x28(%ebp),%eax
     28e:	8b 00                	mov    (%eax),%eax
     290:	89 44 24 0c          	mov    %eax,0xc(%esp)
     294:	8b 45 f0             	mov    -0x10(%ebp),%eax
     297:	89 44 24 08          	mov    %eax,0x8(%esp)
     29b:	c7 44 24 04 4c 17 00 	movl   $0x174c,0x4(%esp)
     2a2:	00 
     2a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2aa:	e8 90 0c 00 00       	call   f3f <printf>
	    serve_drink(current_cup);
     2af:	8b 45 d8             	mov    -0x28(%ebp),%eax
     2b2:	89 04 24             	mov    %eax,(%esp)
     2b5:	e8 a1 fd ff ff       	call   5b <serve_drink>
     2ba:	e9 c4 00 00 00       	jmp    383 <bartender+0x131>
	}
	else if(bartender_action->action_type == RETURN_CUP){
     2bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
     2c2:	8b 00                	mov    (%eax),%eax
     2c4:	83 f8 02             	cmp    $0x2,%eax
     2c7:	0f 85 b6 00 00 00    	jne    383 <bartender+0x131>
	  struct Cup* current_cup = bartender_action->cup;  
     2cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
     2d0:	8b 40 04             	mov    0x4(%eax),%eax
     2d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	  return_cup(current_cup);
     2d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     2d9:	89 04 24             	mov    %eax,(%esp)
     2dc:	e8 dc fd ff ff       	call   bd <return_cup>
	  //need to write to file intsead of screen TODO
	  printf(1,"Bartender %d returned cup %d\n",tid,current_cup->id);
     2e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     2e4:	8b 00                	mov    (%eax),%eax
     2e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
     2ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2ed:	89 44 24 08          	mov    %eax,0x8(%esp)
     2f1:	c7 44 24 04 76 17 00 	movl   $0x1776,0x4(%esp)
     2f8:	00 
     2f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     300:	e8 3a 0c 00 00       	call   f3f <printf>
	  
	  amount = DBB->full->value;
     305:	a1 84 1e 00 00       	mov    0x1e84,%eax
     30a:	8b 40 0c             	mov    0xc(%eax),%eax
     30d:	8b 40 08             	mov    0x8(%eax),%eax
     310:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     313:	db 45 c4             	fildl  -0x3c(%ebp)
     316:	dd 5d e8             	fstpl  -0x18(%ebp)
	  buf_size = DBB->buffer_size;
     319:	a1 84 1e 00 00       	mov    0x1e84,%eax
     31e:	8b 00                	mov    (%eax),%eax
     320:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     323:	db 45 c4             	fildl  -0x3c(%ebp)
     326:	dd 5d e0             	fstpl  -0x20(%ebp)
	  
	  if(amount/buf_size >= 0.6){
     329:	dd 45 e8             	fldl   -0x18(%ebp)
     32c:	dc 75 e0             	fdivl  -0x20(%ebp)
     32f:	dd 05 68 18 00 00    	fldl   0x1868
     335:	d9 c9                	fxch   %st(1)
     337:	df e9                	fucomip %st(1),%st
     339:	dd d8                	fstp   %st(0)
     33b:	0f 93 c0             	setae  %al
     33e:	84 c0                	test   %al,%al
     340:	74 21                	je     363 <bartender+0x111>
	    printf(1,"Go Clean Boy %d\n");
     342:	c7 44 24 04 94 17 00 	movl   $0x1794,0x4(%esp)
     349:	00 
     34a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     351:	e8 e9 0b 00 00       	call   f3f <printf>
	    binary_semaphore_up(cup_boy_lock);
     356:	a1 a8 1e 00 00       	mov    0x1ea8,%eax
     35b:	89 04 24             	mov    %eax,(%esp)
     35e:	e8 fd 0a 00 00       	call   e60 <binary_semaphore_up>
	    }
	if(bartender_action->action_type == GO_HOME){
     363:	8b 45 dc             	mov    -0x24(%ebp),%eax
     366:	8b 00                	mov    (%eax),%eax
     368:	83 f8 03             	cmp    $0x3,%eax
     36b:	75 16                	jne    383 <bartender+0x131>
	  free(bartender_action);
     36d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     370:	89 04 24             	mov    %eax,(%esp)
     373:	e8 7c 0d 00 00       	call   10f4 <free>
	  thread_exit(ret_val);
     378:	8b 45 f4             	mov    -0xc(%ebp),%eax
     37b:	89 04 24             	mov    %eax,(%esp)
     37e:	e8 c5 0a 00 00       	call   e48 <thread_exit>
	}
      }
	free(bartender_action);
     383:	8b 45 dc             	mov    -0x24(%ebp),%eax
     386:	89 04 24             	mov    %eax,(%esp)
     389:	e8 66 0d 00 00       	call   10f4 <free>
    }
     38e:	e9 de fe ff ff       	jmp    271 <bartender+0x1f>

00000393 <cup_boy>:
    return 0;
}


// Cup boy simulation
void* cup_boy(void){
     393:	55                   	push   %ebp
     394:	89 e5                	mov    %esp,%ebp
     396:	83 ec 28             	sub    $0x28,%esp
  void* ret_val = 0;
     399:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  cup_boy_lock = binary_semaphore_create(0);
     3a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3a7:	e8 a4 0a 00 00       	call   e50 <binary_semaphore_create>
     3ac:	a3 a8 1e 00 00       	mov    %eax,0x1ea8
  int i,n;
  for(;;){
    if(finished_shift){
     3b1:	a1 7c 1e 00 00       	mov    0x1e7c,%eax
     3b6:	85 c0                	test   %eax,%eax
     3b8:	74 0b                	je     3c5 <cup_boy+0x32>
      thread_exit(ret_val);
     3ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3bd:	89 04 24             	mov    %eax,(%esp)
     3c0:	e8 83 0a 00 00       	call   e48 <thread_exit>
    }

    n =DBB->full->value;
     3c5:	a1 84 1e 00 00       	mov    0x1e84,%eax
     3ca:	8b 40 0c             	mov    0xc(%eax),%eax
     3cd:	8b 40 08             	mov    0x8(%eax),%eax
     3d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
   
    
    for(i = 1; i < n; i++){
     3d3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     3da:	eb 40                	jmp    41c <cup_boy+0x89>
	struct Cup* current_cup = wash_dirty();
     3dc:	e8 f8 fc ff ff       	call   d9 <wash_dirty>
     3e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sleep(1);
     3e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3eb:	e8 28 0a 00 00       	call   e18 <sleep>
	add_clean_cup(current_cup);
     3f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     3f3:	89 04 24             	mov    %eax,(%esp)
     3f6:	e8 a6 fc ff ff       	call   a1 <add_clean_cup>
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
     3fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     3fe:	8b 00                	mov    (%eax),%eax
     400:	89 44 24 08          	mov    %eax,0x8(%esp)
     404:	c7 44 24 04 a5 17 00 	movl   $0x17a5,0x4(%esp)
     40b:	00 
     40c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     413:	e8 27 0b 00 00       	call   f3f <printf>
    }

    n =DBB->full->value;
   
    
    for(i = 1; i < n; i++){
     418:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     41c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     422:	7c b8                	jl     3dc <cup_boy+0x49>
	sleep(1);
	add_clean_cup(current_cup);
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
    }
    if(!DBB->full->value){
     424:	a1 84 1e 00 00       	mov    0x1e84,%eax
     429:	8b 40 0c             	mov    0xc(%eax),%eax
     42c:	8b 40 08             	mov    0x8(%eax),%eax
     42f:	85 c0                	test   %eax,%eax
     431:	75 0b                	jne    43e <cup_boy+0xab>
      thread_exit(ret_val);
     433:	8b 45 f0             	mov    -0x10(%ebp),%eax
     436:	89 04 24             	mov    %eax,(%esp)
     439:	e8 0a 0a 00 00       	call   e48 <thread_exit>
    }
   binary_semaphore_down(cup_boy_lock); 
     43e:	a1 a8 1e 00 00       	mov    0x1ea8,%eax
     443:	89 04 24             	mov    %eax,(%esp)
     446:	e8 0d 0a 00 00       	call   e58 <binary_semaphore_down>
  }
     44b:	e9 61 ff ff ff       	jmp    3b1 <cup_boy+0x1e>

00000450 <join_peoples>:
  return ret_val;
}

// thread_joins on students and bartenders

void join_peoples(int* tids,int num_of_peoples){
     450:	55                   	push   %ebp
     451:	89 e5                	mov    %esp,%ebp
     453:	83 ec 28             	sub    $0x28,%esp
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     456:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     45d:	eb 1e                	jmp    47d <join_peoples+0x2d>
    thread_join(tids[i],&ret_val);
     45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     462:	c1 e0 02             	shl    $0x2,%eax
     465:	03 45 08             	add    0x8(%ebp),%eax
     468:	8b 00                	mov    (%eax),%eax
     46a:	8d 55 f0             	lea    -0x10(%ebp),%edx
     46d:	89 54 24 04          	mov    %edx,0x4(%esp)
     471:	89 04 24             	mov    %eax,(%esp)
     474:	e8 c7 09 00 00       	call   e40 <thread_join>
// thread_joins on students and bartenders

void join_peoples(int* tids,int num_of_peoples){
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     479:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     47d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     480:	3b 45 0c             	cmp    0xc(%ebp),%eax
     483:	7c da                	jl     45f <join_peoples+0xf>
    thread_join(tids[i],&ret_val);
  }
}
     485:	c9                   	leave  
     486:	c3                   	ret    

00000487 <values_array_index>:


//return the index to put the value {A, B, C, S, M}
//				     {0, 1, 2, 3, 4}
int values_array_index(char* input_buf, int char_index){
     487:	55                   	push   %ebp
     488:	89 e5                	mov    %esp,%ebp
 if(input_buf[char_index] == 'A')
     48a:	8b 45 0c             	mov    0xc(%ebp),%eax
     48d:	03 45 08             	add    0x8(%ebp),%eax
     490:	0f b6 00             	movzbl (%eax),%eax
     493:	3c 41                	cmp    $0x41,%al
     495:	75 07                	jne    49e <values_array_index+0x17>
   return 0;
     497:	b8 00 00 00 00       	mov    $0x0,%eax
     49c:	eb 55                	jmp    4f3 <values_array_index+0x6c>
 if(input_buf[char_index] == 'B')
     49e:	8b 45 0c             	mov    0xc(%ebp),%eax
     4a1:	03 45 08             	add    0x8(%ebp),%eax
     4a4:	0f b6 00             	movzbl (%eax),%eax
     4a7:	3c 42                	cmp    $0x42,%al
     4a9:	75 07                	jne    4b2 <values_array_index+0x2b>
   return 1;
     4ab:	b8 01 00 00 00       	mov    $0x1,%eax
     4b0:	eb 41                	jmp    4f3 <values_array_index+0x6c>
 if(input_buf[char_index] == 'C')
     4b2:	8b 45 0c             	mov    0xc(%ebp),%eax
     4b5:	03 45 08             	add    0x8(%ebp),%eax
     4b8:	0f b6 00             	movzbl (%eax),%eax
     4bb:	3c 43                	cmp    $0x43,%al
     4bd:	75 07                	jne    4c6 <values_array_index+0x3f>
   return 2;
     4bf:	b8 02 00 00 00       	mov    $0x2,%eax
     4c4:	eb 2d                	jmp    4f3 <values_array_index+0x6c>
 if(input_buf[char_index] == 'S')
     4c6:	8b 45 0c             	mov    0xc(%ebp),%eax
     4c9:	03 45 08             	add    0x8(%ebp),%eax
     4cc:	0f b6 00             	movzbl (%eax),%eax
     4cf:	3c 53                	cmp    $0x53,%al
     4d1:	75 07                	jne    4da <values_array_index+0x53>
   return 3;
     4d3:	b8 03 00 00 00       	mov    $0x3,%eax
     4d8:	eb 19                	jmp    4f3 <values_array_index+0x6c>
 if(input_buf[char_index] == 'M')
     4da:	8b 45 0c             	mov    0xc(%ebp),%eax
     4dd:	03 45 08             	add    0x8(%ebp),%eax
     4e0:	0f b6 00             	movzbl (%eax),%eax
     4e3:	3c 4d                	cmp    $0x4d,%al
     4e5:	75 07                	jne    4ee <values_array_index+0x67>
   return 4;
     4e7:	b8 04 00 00 00       	mov    $0x4,%eax
     4ec:	eb 05                	jmp    4f3 <values_array_index+0x6c>
 //error
 return -1;
     4ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     4f3:	5d                   	pop    %ebp
     4f4:	c3                   	ret    

000004f5 <parse_buffer>:

//parsing the configuration file
void parse_buffer(char* input_buf,int* values_array){
     4f5:	55                   	push   %ebp
     4f6:	89 e5                	mov    %esp,%ebp
     4f8:	53                   	push   %ebx
     4f9:	83 ec 24             	sub    $0x24,%esp
 int i;
 int num_of_chars = strlen(input_buf);
     4fc:	8b 45 08             	mov    0x8(%ebp),%eax
     4ff:	89 04 24             	mov    %eax,(%esp)
     502:	e8 b7 06 00 00       	call   bbe <strlen>
     507:	89 45 f0             	mov    %eax,-0x10(%ebp)
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     50a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     511:	eb 7e                	jmp    591 <parse_buffer+0x9c>
    if(input_buf[i] == 'A' || input_buf[i] == 'B' || input_buf[i] == 'C' || input_buf[i] == 'S' || input_buf[i] == 'M'){
     513:	8b 45 f4             	mov    -0xc(%ebp),%eax
     516:	03 45 08             	add    0x8(%ebp),%eax
     519:	0f b6 00             	movzbl (%eax),%eax
     51c:	3c 41                	cmp    $0x41,%al
     51e:	74 34                	je     554 <parse_buffer+0x5f>
     520:	8b 45 f4             	mov    -0xc(%ebp),%eax
     523:	03 45 08             	add    0x8(%ebp),%eax
     526:	0f b6 00             	movzbl (%eax),%eax
     529:	3c 42                	cmp    $0x42,%al
     52b:	74 27                	je     554 <parse_buffer+0x5f>
     52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     530:	03 45 08             	add    0x8(%ebp),%eax
     533:	0f b6 00             	movzbl (%eax),%eax
     536:	3c 43                	cmp    $0x43,%al
     538:	74 1a                	je     554 <parse_buffer+0x5f>
     53a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     53d:	03 45 08             	add    0x8(%ebp),%eax
     540:	0f b6 00             	movzbl (%eax),%eax
     543:	3c 53                	cmp    $0x53,%al
     545:	74 0d                	je     554 <parse_buffer+0x5f>
     547:	8b 45 f4             	mov    -0xc(%ebp),%eax
     54a:	03 45 08             	add    0x8(%ebp),%eax
     54d:	0f b6 00             	movzbl (%eax),%eax
     550:	3c 4d                	cmp    $0x4d,%al
     552:	75 39                	jne    58d <parse_buffer+0x98>
       index = values_array_index(input_buf,i);
     554:	8b 45 f4             	mov    -0xc(%ebp),%eax
     557:	89 44 24 04          	mov    %eax,0x4(%esp)
     55b:	8b 45 08             	mov    0x8(%ebp),%eax
     55e:	89 04 24             	mov    %eax,(%esp)
     561:	e8 21 ff ff ff       	call   487 <values_array_index>
     566:	89 45 ec             	mov    %eax,-0x14(%ebp)
       temp_str = &input_buf[i];
     569:	8b 45 f4             	mov    -0xc(%ebp),%eax
     56c:	03 45 08             	add    0x8(%ebp),%eax
     56f:	89 45 e8             	mov    %eax,-0x18(%ebp)
       values_array[index] = atoi(temp_str+4);
     572:	8b 45 ec             	mov    -0x14(%ebp),%eax
     575:	c1 e0 02             	shl    $0x2,%eax
     578:	89 c3                	mov    %eax,%ebx
     57a:	03 5d 0c             	add    0xc(%ebp),%ebx
     57d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     580:	83 c0 04             	add    $0x4,%eax
     583:	89 04 24             	mov    %eax,(%esp)
     586:	e8 6c 07 00 00       	call   cf7 <atoi>
     58b:	89 03                	mov    %eax,(%ebx)
void parse_buffer(char* input_buf,int* values_array){
 int i;
 int num_of_chars = strlen(input_buf);
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     58d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     591:	8b 45 f4             	mov    -0xc(%ebp),%eax
     594:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     597:	0f 8c 76 ff ff ff    	jl     513 <parse_buffer+0x1e>
       index = values_array_index(input_buf,i);
       temp_str = &input_buf[i];
       values_array[index] = atoi(temp_str+4);
    }
 }
}
     59d:	83 c4 24             	add    $0x24,%esp
     5a0:	5b                   	pop    %ebx
     5a1:	5d                   	pop    %ebp
     5a2:	c3                   	ret    

000005a3 <main>:


int main(int argc, char** argv) {
     5a3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     5a7:	83 e4 f0             	and    $0xfffffff0,%esp
     5aa:	ff 71 fc             	pushl  -0x4(%ecx)
     5ad:	55                   	push   %ebp
     5ae:	89 e5                	mov    %esp,%ebp
     5b0:	51                   	push   %ecx
     5b1:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  int M;	// maximum number of students that can be at the bar at once
  int fconf;
  int conf_size;
  struct stat bufstat;
  
  fconf = open("con.conf",O_RDONLY);
     5b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     5be:	00 
     5bf:	c7 04 24 c1 17 00 00 	movl   $0x17c1,(%esp)
     5c6:	e8 fd 07 00 00       	call   dc8 <open>
     5cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  fstat(fconf,&bufstat);
     5ce:	8d 45 98             	lea    -0x68(%ebp),%eax
     5d1:	89 44 24 04          	mov    %eax,0x4(%esp)
     5d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5d8:	89 04 24             	mov    %eax,(%esp)
     5db:	e8 00 08 00 00       	call   de0 <fstat>
  conf_size = bufstat.size;
     5e0:	8b 45 a8             	mov    -0x58(%ebp),%eax
     5e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  char bufconf[conf_size];
     5e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5e9:	8d 50 ff             	lea    -0x1(%eax),%edx
     5ec:	89 55 e8             	mov    %edx,-0x18(%ebp)
     5ef:	8d 50 0f             	lea    0xf(%eax),%edx
     5f2:	b8 10 00 00 00       	mov    $0x10,%eax
     5f7:	83 e8 01             	sub    $0x1,%eax
     5fa:	01 d0                	add    %edx,%eax
     5fc:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     603:	00 00 00 
     606:	ba 00 00 00 00       	mov    $0x0,%edx
     60b:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     611:	6b c0 10             	imul   $0x10,%eax,%eax
     614:	29 c4                	sub    %eax,%esp
     616:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     61a:	83 c0 0f             	add    $0xf,%eax
     61d:	c1 e8 04             	shr    $0x4,%eax
     620:	c1 e0 04             	shl    $0x4,%eax
     623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  read(fconf,bufconf,conf_size);
     626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     629:	8b 55 ec             	mov    -0x14(%ebp),%edx
     62c:	89 54 24 08          	mov    %edx,0x8(%esp)
     630:	89 44 24 04          	mov    %eax,0x4(%esp)
     634:	8b 45 f0             	mov    -0x10(%ebp),%eax
     637:	89 04 24             	mov    %eax,(%esp)
     63a:	e8 61 07 00 00       	call   da0 <read>
  int inputs_parsed[5]; //{Aval, Bval, Cval, Sval, Mval}
  
  parse_buffer(bufconf, inputs_parsed);
     63f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     642:	8d 55 84             	lea    -0x7c(%ebp),%edx
     645:	89 54 24 04          	mov    %edx,0x4(%esp)
     649:	89 04 24             	mov    %eax,(%esp)
     64c:	e8 a4 fe ff ff       	call   4f5 <parse_buffer>
  A = inputs_parsed[0];
     651:	8b 45 84             	mov    -0x7c(%ebp),%eax
     654:	89 45 e0             	mov    %eax,-0x20(%ebp)
  B = inputs_parsed[1];
     657:	8b 45 88             	mov    -0x78(%ebp),%eax
     65a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  C = inputs_parsed[2];
     65d:	8b 45 8c             	mov    -0x74(%ebp),%eax
     660:	89 45 d8             	mov    %eax,-0x28(%ebp)
  S = inputs_parsed[3];
     663:	8b 45 90             	mov    -0x70(%ebp),%eax
     666:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  M = inputs_parsed[4];
     669:	8b 45 94             	mov    -0x6c(%ebp),%eax
     66c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  
  printf(1,"A: %d B: %d C: %d  S: %d M: %d\n",A,B,C,S,M);
     66f:	8b 45 d0             	mov    -0x30(%ebp),%eax
     672:	89 44 24 18          	mov    %eax,0x18(%esp)
     676:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     679:	89 44 24 14          	mov    %eax,0x14(%esp)
     67d:	8b 45 d8             	mov    -0x28(%ebp),%eax
     680:	89 44 24 10          	mov    %eax,0x10(%esp)
     684:	8b 45 dc             	mov    -0x24(%ebp),%eax
     687:	89 44 24 0c          	mov    %eax,0xc(%esp)
     68b:	8b 45 e0             	mov    -0x20(%ebp),%eax
     68e:	89 44 24 08          	mov    %eax,0x8(%esp)
     692:	c7 44 24 04 cc 17 00 	movl   $0x17cc,0x4(%esp)
     699:	00 
     69a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6a1:	e8 99 08 00 00       	call   f3f <printf>
  
  void* students_stacks[S];
     6a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     6a9:	8d 50 ff             	lea    -0x1(%eax),%edx
     6ac:	89 55 cc             	mov    %edx,-0x34(%ebp)
     6af:	c1 e0 02             	shl    $0x2,%eax
     6b2:	8d 50 0f             	lea    0xf(%eax),%edx
     6b5:	b8 10 00 00 00       	mov    $0x10,%eax
     6ba:	83 e8 01             	sub    $0x1,%eax
     6bd:	01 d0                	add    %edx,%eax
     6bf:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     6c6:	00 00 00 
     6c9:	ba 00 00 00 00       	mov    $0x0,%edx
     6ce:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     6d4:	6b c0 10             	imul   $0x10,%eax,%eax
     6d7:	29 c4                	sub    %eax,%esp
     6d9:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     6dd:	83 c0 0f             	add    $0xf,%eax
     6e0:	c1 e8 04             	shr    $0x4,%eax
     6e3:	c1 e0 04             	shl    $0x4,%eax
     6e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  void* bartenders_stacks[B];
     6e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
     6ec:	8d 50 ff             	lea    -0x1(%eax),%edx
     6ef:	89 55 c4             	mov    %edx,-0x3c(%ebp)
     6f2:	c1 e0 02             	shl    $0x2,%eax
     6f5:	8d 50 0f             	lea    0xf(%eax),%edx
     6f8:	b8 10 00 00 00       	mov    $0x10,%eax
     6fd:	83 e8 01             	sub    $0x1,%eax
     700:	01 d0                	add    %edx,%eax
     702:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     709:	00 00 00 
     70c:	ba 00 00 00 00       	mov    $0x0,%edx
     711:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     717:	6b c0 10             	imul   $0x10,%eax,%eax
     71a:	29 c4                	sub    %eax,%esp
     71c:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     720:	83 c0 0f             	add    $0xf,%eax
     723:	c1 e8 04             	shr    $0x4,%eax
     726:	c1 e0 04             	shl    $0x4,%eax
     729:	89 45 c0             	mov    %eax,-0x40(%ebp)
  void* cup_boy_stack;
  int i;
  int student_tids[S];
     72c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     72f:	8d 50 ff             	lea    -0x1(%eax),%edx
     732:	89 55 bc             	mov    %edx,-0x44(%ebp)
     735:	c1 e0 02             	shl    $0x2,%eax
     738:	8d 50 0f             	lea    0xf(%eax),%edx
     73b:	b8 10 00 00 00       	mov    $0x10,%eax
     740:	83 e8 01             	sub    $0x1,%eax
     743:	01 d0                	add    %edx,%eax
     745:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     74c:	00 00 00 
     74f:	ba 00 00 00 00       	mov    $0x0,%edx
     754:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     75a:	6b c0 10             	imul   $0x10,%eax,%eax
     75d:	29 c4                	sub    %eax,%esp
     75f:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     763:	83 c0 0f             	add    $0xf,%eax
     766:	c1 e8 04             	shr    $0x4,%eax
     769:	c1 e0 04             	shl    $0x4,%eax
     76c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  //int bartender_tids[B];
  finished_shift = 0; // cup_boy changes it to 1 if all students left the bar and sends Action => GO_HOME to bartenders
     76f:	c7 05 7c 1e 00 00 00 	movl   $0x0,0x1e7c
     776:	00 00 00 

  
  file_to_write = open("out.txt",(O_CREATE | O_WRONLY)); //
     779:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     780:	00 
     781:	c7 04 24 ec 17 00 00 	movl   $0x17ec,(%esp)
     788:	e8 3b 06 00 00       	call   dc8 <open>
     78d:	a3 8c 1e 00 00       	mov    %eax,0x1e8c
  if(file_to_write == -1){
     792:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
     797:	83 f8 ff             	cmp    $0xffffffff,%eax
     79a:	75 19                	jne    7b5 <main+0x212>
      printf(1,"There was an error opening out.txt\n");
     79c:	c7 44 24 04 f4 17 00 	movl   $0x17f4,0x4(%esp)
     7a3:	00 
     7a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7ab:	e8 8f 07 00 00       	call   f3f <printf>
      exit();
     7b0:	e8 d3 05 00 00       	call   d88 <exit>
  }
  
  
  //Databases
   bouncer = semaphore_create(M);		//this is the bouncer to the Beinstein
     7b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
     7b8:	89 04 24             	mov    %eax,(%esp)
     7bb:	e8 44 0b 00 00       	call   1304 <semaphore_create>
     7c0:	a3 78 1e 00 00       	mov    %eax,0x1e78
   ABB = BB_create(A); 				//this is a BB for student actions: drink, ans for a dring
     7c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7c8:	89 04 24             	mov    %eax,(%esp)
     7cb:	e8 8c 0c 00 00       	call   145c <BB_create>
     7d0:	a3 80 1e 00 00       	mov    %eax,0x1e80
   DrinkBB = BB_create(A);			//this is a BB holding the drinks that are ready to be drinking
     7d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7d8:	89 04 24             	mov    %eax,(%esp)
     7db:	e8 7c 0c 00 00       	call   145c <BB_create>
     7e0:	a3 90 1e 00 00       	mov    %eax,0x1e90
   CBB = BB_create(C);				//this is a BB hold clean cups
     7e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
     7e8:	89 04 24             	mov    %eax,(%esp)
     7eb:	e8 6c 0c 00 00       	call   145c <BB_create>
     7f0:	a3 ac 1e 00 00       	mov    %eax,0x1eac
   DBB = BB_create(C);				//this is a BB hold dirty cups
     7f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
     7f8:	89 04 24             	mov    %eax,(%esp)
     7fb:	e8 5c 0c 00 00       	call   145c <BB_create>
     800:	a3 84 1e 00 00       	mov    %eax,0x1e84
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
     805:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     80c:	e8 3f 06 00 00       	call   e50 <binary_semaphore_create>
     811:	a3 a8 1e 00 00       	mov    %eax,0x1ea8
   general_mutex = binary_semaphore_create(1);
     816:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     81d:	e8 2e 06 00 00       	call   e50 <binary_semaphore_create>
     822:	a3 88 1e 00 00       	mov    %eax,0x1e88

   //initialize C clean cups
   struct Cup* cup_array[C];
     827:	8b 45 d8             	mov    -0x28(%ebp),%eax
     82a:	8d 50 ff             	lea    -0x1(%eax),%edx
     82d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
     830:	c1 e0 02             	shl    $0x2,%eax
     833:	8d 50 0f             	lea    0xf(%eax),%edx
     836:	b8 10 00 00 00       	mov    $0x10,%eax
     83b:	83 e8 01             	sub    $0x1,%eax
     83e:	01 d0                	add    %edx,%eax
     840:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     847:	00 00 00 
     84a:	ba 00 00 00 00       	mov    $0x0,%edx
     84f:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     855:	6b c0 10             	imul   $0x10,%eax,%eax
     858:	29 c4                	sub    %eax,%esp
     85a:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     85e:	83 c0 0f             	add    $0xf,%eax
     861:	c1 e8 04             	shr    $0x4,%eax
     864:	c1 e0 04             	shl    $0x4,%eax
     867:	89 45 b0             	mov    %eax,-0x50(%ebp)
   for(i = 0; i < C; i++){
     86a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     871:	eb 38                	jmp    8ab <main+0x308>
      cup_array[i] = malloc(sizeof(struct Cup)); //TODO free cups
     873:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     87a:	e8 a4 09 00 00       	call   1223 <malloc>
     87f:	8b 55 b0             	mov    -0x50(%ebp),%edx
     882:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     885:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      //memset(cup_array[i],0,sizeof(void*)*STACK_SIZE);
      cup_array[i]->id = i;
     888:	8b 45 b0             	mov    -0x50(%ebp),%eax
     88b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     88e:	8b 04 90             	mov    (%eax,%edx,4),%eax
     891:	8b 55 f4             	mov    -0xc(%ebp),%edx
     894:	89 10                	mov    %edx,(%eax)
      add_clean_cup(cup_array[i]);
     896:	8b 45 b0             	mov    -0x50(%ebp),%eax
     899:	8b 55 f4             	mov    -0xc(%ebp),%edx
     89c:	8b 04 90             	mov    (%eax,%edx,4),%eax
     89f:	89 04 24             	mov    %eax,(%esp)
     8a2:	e8 fa f7 ff ff       	call   a1 <add_clean_cup>
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
   general_mutex = binary_semaphore_create(1);

   //initialize C clean cups
   struct Cup* cup_array[C];
   for(i = 0; i < C; i++){
     8a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ae:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     8b1:	7c c0                	jl     873 <main+0x2d0>
      cup_array[i]->id = i;
      add_clean_cup(cup_array[i]);
   }
   
   //initialize cup_boy
   cup_boy_stack = (void*)malloc(sizeof(void*)*STACK_SIZE);
     8b3:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     8ba:	e8 64 09 00 00       	call   1223 <malloc>
     8bf:	89 45 ac             	mov    %eax,-0x54(%ebp)
   memset(cup_boy_stack,0,sizeof(void*)*STACK_SIZE);
     8c2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     8c9:	00 
     8ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     8d1:	00 
     8d2:	8b 45 ac             	mov    -0x54(%ebp),%eax
     8d5:	89 04 24             	mov    %eax,(%esp)
     8d8:	e8 06 03 00 00       	call   be3 <memset>
   if(thread_create((void*)cup_boy,cup_boy_stack,sizeof(void*)*STACK_SIZE) < 0){
     8dd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     8e4:	00 
     8e5:	8b 45 ac             	mov    -0x54(%ebp),%eax
     8e8:	89 44 24 04          	mov    %eax,0x4(%esp)
     8ec:	c7 04 24 93 03 00 00 	movl   $0x393,(%esp)
     8f3:	e8 30 05 00 00       	call   e28 <thread_create>
     8f8:	85 c0                	test   %eax,%eax
     8fa:	79 19                	jns    915 <main+0x372>
     printf(2,"Failed to create cupboy thread. Exiting...\n");
     8fc:	c7 44 24 04 18 18 00 	movl   $0x1818,0x4(%esp)
     903:	00 
     904:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     90b:	e8 2f 06 00 00       	call   f3f <printf>
    exit();
     910:	e8 73 04 00 00       	call   d88 <exit>
   }
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     915:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     91c:	eb 5b                	jmp    979 <main+0x3d6>
      bartenders_stacks[i] = (void*)malloc(sizeof(void*)*STACK_SIZE);
     91e:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     925:	e8 f9 08 00 00       	call   1223 <malloc>
     92a:	8b 55 c0             	mov    -0x40(%ebp),%edx
     92d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     930:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(bartenders_stacks[i],0,sizeof(void*)*STACK_SIZE);
     933:	8b 45 c0             	mov    -0x40(%ebp),%eax
     936:	8b 55 f4             	mov    -0xc(%ebp),%edx
     939:	8b 04 90             	mov    (%eax,%edx,4),%eax
     93c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     943:	00 
     944:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     94b:	00 
     94c:	89 04 24             	mov    %eax,(%esp)
     94f:	e8 8f 02 00 00       	call   be3 <memset>
     thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
     954:	8b 45 c0             	mov    -0x40(%ebp),%eax
     957:	8b 55 f4             	mov    -0xc(%ebp),%edx
     95a:	8b 04 90             	mov    (%eax,%edx,4),%eax
     95d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     964:	00 
     965:	89 44 24 04          	mov    %eax,0x4(%esp)
     969:	c7 04 24 52 02 00 00 	movl   $0x252,(%esp)
     970:	e8 b3 04 00 00       	call   e28 <thread_create>
     printf(2,"Failed to create cupboy thread. Exiting...\n");
    exit();
   }
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     975:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     979:	8b 45 f4             	mov    -0xc(%ebp),%eax
     97c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     97f:	7c 9d                	jl     91e <main+0x37b>
     thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
      //bartender_tids[i] = 
  }
   
   //initialize S students
   for(i = 0; i < S; i++){//TODO test for fail
     981:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     988:	eb 64                	jmp    9ee <main+0x44b>
      students_stacks[i] = malloc(sizeof(void*)*STACK_SIZE);
     98a:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     991:	e8 8d 08 00 00       	call   1223 <malloc>
     996:	8b 55 c8             	mov    -0x38(%ebp),%edx
     999:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     99c:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
     99f:	8b 45 c8             	mov    -0x38(%ebp),%eax
     9a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9a5:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9a8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     9af:	00 
     9b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     9b7:	00 
     9b8:	89 04 24             	mov    %eax,(%esp)
     9bb:	e8 23 02 00 00       	call   be3 <memset>
      student_tids[i] = thread_create((void*)student,students_stacks[i],sizeof(void*)*STACK_SIZE);
     9c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
     9c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9c6:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9c9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     9d0:	00 
     9d1:	89 44 24 04          	mov    %eax,0x4(%esp)
     9d5:	c7 04 24 ee 00 00 00 	movl   $0xee,(%esp)
     9dc:	e8 47 04 00 00       	call   e28 <thread_create>
     9e1:	8b 55 b8             	mov    -0x48(%ebp),%edx
     9e4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     9e7:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
      //bartender_tids[i] = 
  }
   
   //initialize S students
   for(i = 0; i < S; i++){//TODO test for fail
     9ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9f1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     9f4:	7c 94                	jl     98a <main+0x3e7>
      students_stacks[i] = malloc(sizeof(void*)*STACK_SIZE);
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
      student_tids[i] = thread_create((void*)student,students_stacks[i],sizeof(void*)*STACK_SIZE);
  }
  
   join_peoples(student_tids,S); //join students
     9f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
     9f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     9fc:	89 54 24 04          	mov    %edx,0x4(%esp)
     a00:	89 04 24             	mov    %eax,(%esp)
     a03:	e8 48 fa ff ff       	call   450 <join_peoples>
   finished_shift = 1;
     a08:	c7 05 7c 1e 00 00 01 	movl   $0x1,0x1e7c
     a0f:	00 00 00 
    
    
   //join_peoples(bartender_tids,B); //join bartenders
   sleep(2); // delay so exit will not come before threads finished TODO (need better soloution)
     a12:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     a19:	e8 fa 03 00 00       	call   e18 <sleep>
   
   
   if(finished_shift){
     a1e:	a1 7c 1e 00 00       	mov    0x1e7c,%eax
     a23:	85 c0                	test   %eax,%eax
     a25:	74 0d                	je     a34 <main+0x491>
      binary_semaphore_up(cup_boy_lock); 
     a27:	a1 a8 1e 00 00       	mov    0x1ea8,%eax
     a2c:	89 04 24             	mov    %eax,(%esp)
     a2f:	e8 2c 04 00 00       	call   e60 <binary_semaphore_up>
    }
    
    
   if(close(file_to_write) == -1){
     a34:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
     a39:	89 04 24             	mov    %eax,(%esp)
     a3c:	e8 6f 03 00 00       	call   db0 <close>
     a41:	83 f8 ff             	cmp    $0xffffffff,%eax
     a44:	75 19                	jne    a5f <main+0x4bc>
    printf(1,"There was an error closing out.txt\n");
     a46:	c7 44 24 04 44 18 00 	movl   $0x1844,0x4(%esp)
     a4d:	00 
     a4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a55:	e8 e5 04 00 00       	call   f3f <printf>
    exit();
     a5a:	e8 29 03 00 00       	call   d88 <exit>
   }
   
  //free cup_boy_stack
  free(cup_boy_stack);
     a5f:	8b 45 ac             	mov    -0x54(%ebp),%eax
     a62:	89 04 24             	mov    %eax,(%esp)
     a65:	e8 8a 06 00 00       	call   10f4 <free>
  
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     a6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a71:	eb 15                	jmp    a88 <main+0x4e5>
    free(cup_array[i]);
     a73:	8b 45 b0             	mov    -0x50(%ebp),%eax
     a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a79:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a7c:	89 04 24             	mov    %eax,(%esp)
     a7f:	e8 70 06 00 00       	call   10f4 <free>
  //free cup_boy_stack
  free(cup_boy_stack);
  
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     a84:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a8b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     a8e:	7c e3                	jl     a73 <main+0x4d0>
    free(cup_array[i]);
  }

  //free bartenders_stacks
  for(i = 0; i < B; i++){
     a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a97:	eb 15                	jmp    aae <main+0x50b>
   free(bartenders_stacks[i]); 
     a99:	8b 45 c0             	mov    -0x40(%ebp),%eax
     a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a9f:	8b 04 90             	mov    (%eax,%edx,4),%eax
     aa2:	89 04 24             	mov    %eax,(%esp)
     aa5:	e8 4a 06 00 00       	call   10f4 <free>
  for(i = 0; i < C; i++){
    free(cup_array[i]);
  }

  //free bartenders_stacks
  for(i = 0; i < B; i++){
     aaa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ab1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     ab4:	7c e3                	jl     a99 <main+0x4f6>
   free(bartenders_stacks[i]); 
  }
  //free students_stacks
  for(i = 0; i < S; i++){
     ab6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     abd:	eb 15                	jmp    ad4 <main+0x531>
   free(students_stacks[i]); 
     abf:	8b 45 c8             	mov    -0x38(%ebp),%eax
     ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ac5:	8b 04 90             	mov    (%eax,%edx,4),%eax
     ac8:	89 04 24             	mov    %eax,(%esp)
     acb:	e8 24 06 00 00       	call   10f4 <free>
  //free bartenders_stacks
  for(i = 0; i < B; i++){
   free(bartenders_stacks[i]); 
  }
  //free students_stacks
  for(i = 0; i < S; i++){
     ad0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     ada:	7c e3                	jl     abf <main+0x51c>
   free(students_stacks[i]); 
  }
  semaphore_free(bouncer);
     adc:	a1 78 1e 00 00       	mov    0x1e78,%eax
     ae1:	89 04 24             	mov    %eax,(%esp)
     ae4:	e8 5f 09 00 00       	call   1448 <semaphore_free>
  BB_free(ABB);
     ae9:	a1 80 1e 00 00       	mov    0x1e80,%eax
     aee:	89 04 24             	mov    %eax,(%esp)
     af1:	e8 b8 0b 00 00       	call   16ae <BB_free>
  BB_free(DrinkBB);
     af6:	a1 90 1e 00 00       	mov    0x1e90,%eax
     afb:	89 04 24             	mov    %eax,(%esp)
     afe:	e8 ab 0b 00 00       	call   16ae <BB_free>
  BB_free(CBB);
     b03:	a1 ac 1e 00 00       	mov    0x1eac,%eax
     b08:	89 04 24             	mov    %eax,(%esp)
     b0b:	e8 9e 0b 00 00       	call   16ae <BB_free>
  BB_free(DBB);
     b10:	a1 84 1e 00 00       	mov    0x1e84,%eax
     b15:	89 04 24             	mov    %eax,(%esp)
     b18:	e8 91 0b 00 00       	call   16ae <BB_free>
 
  exit();
     b1d:	e8 66 02 00 00       	call   d88 <exit>
     b22:	90                   	nop
     b23:	90                   	nop

00000b24 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     b24:	55                   	push   %ebp
     b25:	89 e5                	mov    %esp,%ebp
     b27:	57                   	push   %edi
     b28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     b29:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b2c:	8b 55 10             	mov    0x10(%ebp),%edx
     b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
     b32:	89 cb                	mov    %ecx,%ebx
     b34:	89 df                	mov    %ebx,%edi
     b36:	89 d1                	mov    %edx,%ecx
     b38:	fc                   	cld    
     b39:	f3 aa                	rep stos %al,%es:(%edi)
     b3b:	89 ca                	mov    %ecx,%edx
     b3d:	89 fb                	mov    %edi,%ebx
     b3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
     b42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     b45:	5b                   	pop    %ebx
     b46:	5f                   	pop    %edi
     b47:	5d                   	pop    %ebp
     b48:	c3                   	ret    

00000b49 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     b49:	55                   	push   %ebp
     b4a:	89 e5                	mov    %esp,%ebp
     b4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     b4f:	8b 45 08             	mov    0x8(%ebp),%eax
     b52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     b55:	90                   	nop
     b56:	8b 45 0c             	mov    0xc(%ebp),%eax
     b59:	0f b6 10             	movzbl (%eax),%edx
     b5c:	8b 45 08             	mov    0x8(%ebp),%eax
     b5f:	88 10                	mov    %dl,(%eax)
     b61:	8b 45 08             	mov    0x8(%ebp),%eax
     b64:	0f b6 00             	movzbl (%eax),%eax
     b67:	84 c0                	test   %al,%al
     b69:	0f 95 c0             	setne  %al
     b6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b70:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     b74:	84 c0                	test   %al,%al
     b76:	75 de                	jne    b56 <strcpy+0xd>
    ;
  return os;
     b78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     b7b:	c9                   	leave  
     b7c:	c3                   	ret    

00000b7d <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b7d:	55                   	push   %ebp
     b7e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     b80:	eb 08                	jmp    b8a <strcmp+0xd>
    p++, q++;
     b82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b86:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     b8a:	8b 45 08             	mov    0x8(%ebp),%eax
     b8d:	0f b6 00             	movzbl (%eax),%eax
     b90:	84 c0                	test   %al,%al
     b92:	74 10                	je     ba4 <strcmp+0x27>
     b94:	8b 45 08             	mov    0x8(%ebp),%eax
     b97:	0f b6 10             	movzbl (%eax),%edx
     b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
     b9d:	0f b6 00             	movzbl (%eax),%eax
     ba0:	38 c2                	cmp    %al,%dl
     ba2:	74 de                	je     b82 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     ba4:	8b 45 08             	mov    0x8(%ebp),%eax
     ba7:	0f b6 00             	movzbl (%eax),%eax
     baa:	0f b6 d0             	movzbl %al,%edx
     bad:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb0:	0f b6 00             	movzbl (%eax),%eax
     bb3:	0f b6 c0             	movzbl %al,%eax
     bb6:	89 d1                	mov    %edx,%ecx
     bb8:	29 c1                	sub    %eax,%ecx
     bba:	89 c8                	mov    %ecx,%eax
}
     bbc:	5d                   	pop    %ebp
     bbd:	c3                   	ret    

00000bbe <strlen>:

uint
strlen(char *s)
{
     bbe:	55                   	push   %ebp
     bbf:	89 e5                	mov    %esp,%ebp
     bc1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     bc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     bcb:	eb 04                	jmp    bd1 <strlen+0x13>
     bcd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bd4:	03 45 08             	add    0x8(%ebp),%eax
     bd7:	0f b6 00             	movzbl (%eax),%eax
     bda:	84 c0                	test   %al,%al
     bdc:	75 ef                	jne    bcd <strlen+0xf>
    ;
  return n;
     bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     be1:	c9                   	leave  
     be2:	c3                   	ret    

00000be3 <memset>:

void*
memset(void *dst, int c, uint n)
{
     be3:	55                   	push   %ebp
     be4:	89 e5                	mov    %esp,%ebp
     be6:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     be9:	8b 45 10             	mov    0x10(%ebp),%eax
     bec:	89 44 24 08          	mov    %eax,0x8(%esp)
     bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
     bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
     bf7:	8b 45 08             	mov    0x8(%ebp),%eax
     bfa:	89 04 24             	mov    %eax,(%esp)
     bfd:	e8 22 ff ff ff       	call   b24 <stosb>
  return dst;
     c02:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c05:	c9                   	leave  
     c06:	c3                   	ret    

00000c07 <strchr>:

char*
strchr(const char *s, char c)
{
     c07:	55                   	push   %ebp
     c08:	89 e5                	mov    %esp,%ebp
     c0a:	83 ec 04             	sub    $0x4,%esp
     c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
     c10:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     c13:	eb 14                	jmp    c29 <strchr+0x22>
    if(*s == c)
     c15:	8b 45 08             	mov    0x8(%ebp),%eax
     c18:	0f b6 00             	movzbl (%eax),%eax
     c1b:	3a 45 fc             	cmp    -0x4(%ebp),%al
     c1e:	75 05                	jne    c25 <strchr+0x1e>
      return (char*)s;
     c20:	8b 45 08             	mov    0x8(%ebp),%eax
     c23:	eb 13                	jmp    c38 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     c25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     c29:	8b 45 08             	mov    0x8(%ebp),%eax
     c2c:	0f b6 00             	movzbl (%eax),%eax
     c2f:	84 c0                	test   %al,%al
     c31:	75 e2                	jne    c15 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c38:	c9                   	leave  
     c39:	c3                   	ret    

00000c3a <gets>:

char*
gets(char *buf, int max)
{
     c3a:	55                   	push   %ebp
     c3b:	89 e5                	mov    %esp,%ebp
     c3d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c47:	eb 44                	jmp    c8d <gets+0x53>
    cc = read(0, &c, 1);
     c49:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c50:	00 
     c51:	8d 45 ef             	lea    -0x11(%ebp),%eax
     c54:	89 44 24 04          	mov    %eax,0x4(%esp)
     c58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c5f:	e8 3c 01 00 00       	call   da0 <read>
     c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c6b:	7e 2d                	jle    c9a <gets+0x60>
      break;
    buf[i++] = c;
     c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c70:	03 45 08             	add    0x8(%ebp),%eax
     c73:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     c77:	88 10                	mov    %dl,(%eax)
     c79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     c7d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     c81:	3c 0a                	cmp    $0xa,%al
     c83:	74 16                	je     c9b <gets+0x61>
     c85:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     c89:	3c 0d                	cmp    $0xd,%al
     c8b:	74 0e                	je     c9b <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c90:	83 c0 01             	add    $0x1,%eax
     c93:	3b 45 0c             	cmp    0xc(%ebp),%eax
     c96:	7c b1                	jl     c49 <gets+0xf>
     c98:	eb 01                	jmp    c9b <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     c9a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c9e:	03 45 08             	add    0x8(%ebp),%eax
     ca1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     ca4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ca7:	c9                   	leave  
     ca8:	c3                   	ret    

00000ca9 <stat>:

int
stat(char *n, struct stat *st)
{
     ca9:	55                   	push   %ebp
     caa:	89 e5                	mov    %esp,%ebp
     cac:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     caf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     cb6:	00 
     cb7:	8b 45 08             	mov    0x8(%ebp),%eax
     cba:	89 04 24             	mov    %eax,(%esp)
     cbd:	e8 06 01 00 00       	call   dc8 <open>
     cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     cc9:	79 07                	jns    cd2 <stat+0x29>
    return -1;
     ccb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cd0:	eb 23                	jmp    cf5 <stat+0x4c>
  r = fstat(fd, st);
     cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
     cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
     cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cdc:	89 04 24             	mov    %eax,(%esp)
     cdf:	e8 fc 00 00 00       	call   de0 <fstat>
     ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cea:	89 04 24             	mov    %eax,(%esp)
     ced:	e8 be 00 00 00       	call   db0 <close>
  return r;
     cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     cf5:	c9                   	leave  
     cf6:	c3                   	ret    

00000cf7 <atoi>:

int
atoi(const char *s)
{
     cf7:	55                   	push   %ebp
     cf8:	89 e5                	mov    %esp,%ebp
     cfa:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     cfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     d04:	eb 23                	jmp    d29 <atoi+0x32>
    n = n*10 + *s++ - '0';
     d06:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d09:	89 d0                	mov    %edx,%eax
     d0b:	c1 e0 02             	shl    $0x2,%eax
     d0e:	01 d0                	add    %edx,%eax
     d10:	01 c0                	add    %eax,%eax
     d12:	89 c2                	mov    %eax,%edx
     d14:	8b 45 08             	mov    0x8(%ebp),%eax
     d17:	0f b6 00             	movzbl (%eax),%eax
     d1a:	0f be c0             	movsbl %al,%eax
     d1d:	01 d0                	add    %edx,%eax
     d1f:	83 e8 30             	sub    $0x30,%eax
     d22:	89 45 fc             	mov    %eax,-0x4(%ebp)
     d25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d29:	8b 45 08             	mov    0x8(%ebp),%eax
     d2c:	0f b6 00             	movzbl (%eax),%eax
     d2f:	3c 2f                	cmp    $0x2f,%al
     d31:	7e 0a                	jle    d3d <atoi+0x46>
     d33:	8b 45 08             	mov    0x8(%ebp),%eax
     d36:	0f b6 00             	movzbl (%eax),%eax
     d39:	3c 39                	cmp    $0x39,%al
     d3b:	7e c9                	jle    d06 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d40:	c9                   	leave  
     d41:	c3                   	ret    

00000d42 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d42:	55                   	push   %ebp
     d43:	89 e5                	mov    %esp,%ebp
     d45:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
     d4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
     d51:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     d54:	eb 13                	jmp    d69 <memmove+0x27>
    *dst++ = *src++;
     d56:	8b 45 f8             	mov    -0x8(%ebp),%eax
     d59:	0f b6 10             	movzbl (%eax),%edx
     d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d5f:	88 10                	mov    %dl,(%eax)
     d61:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d65:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     d6d:	0f 9f c0             	setg   %al
     d70:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     d74:	84 c0                	test   %al,%al
     d76:	75 de                	jne    d56 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     d78:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d7b:	c9                   	leave  
     d7c:	c3                   	ret    
     d7d:	90                   	nop
     d7e:	90                   	nop
     d7f:	90                   	nop

00000d80 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d80:	b8 01 00 00 00       	mov    $0x1,%eax
     d85:	cd 40                	int    $0x40
     d87:	c3                   	ret    

00000d88 <exit>:
SYSCALL(exit)
     d88:	b8 02 00 00 00       	mov    $0x2,%eax
     d8d:	cd 40                	int    $0x40
     d8f:	c3                   	ret    

00000d90 <wait>:
SYSCALL(wait)
     d90:	b8 03 00 00 00       	mov    $0x3,%eax
     d95:	cd 40                	int    $0x40
     d97:	c3                   	ret    

00000d98 <pipe>:
SYSCALL(pipe)
     d98:	b8 04 00 00 00       	mov    $0x4,%eax
     d9d:	cd 40                	int    $0x40
     d9f:	c3                   	ret    

00000da0 <read>:
SYSCALL(read)
     da0:	b8 05 00 00 00       	mov    $0x5,%eax
     da5:	cd 40                	int    $0x40
     da7:	c3                   	ret    

00000da8 <write>:
SYSCALL(write)
     da8:	b8 10 00 00 00       	mov    $0x10,%eax
     dad:	cd 40                	int    $0x40
     daf:	c3                   	ret    

00000db0 <close>:
SYSCALL(close)
     db0:	b8 15 00 00 00       	mov    $0x15,%eax
     db5:	cd 40                	int    $0x40
     db7:	c3                   	ret    

00000db8 <kill>:
SYSCALL(kill)
     db8:	b8 06 00 00 00       	mov    $0x6,%eax
     dbd:	cd 40                	int    $0x40
     dbf:	c3                   	ret    

00000dc0 <exec>:
SYSCALL(exec)
     dc0:	b8 07 00 00 00       	mov    $0x7,%eax
     dc5:	cd 40                	int    $0x40
     dc7:	c3                   	ret    

00000dc8 <open>:
SYSCALL(open)
     dc8:	b8 0f 00 00 00       	mov    $0xf,%eax
     dcd:	cd 40                	int    $0x40
     dcf:	c3                   	ret    

00000dd0 <mknod>:
SYSCALL(mknod)
     dd0:	b8 11 00 00 00       	mov    $0x11,%eax
     dd5:	cd 40                	int    $0x40
     dd7:	c3                   	ret    

00000dd8 <unlink>:
SYSCALL(unlink)
     dd8:	b8 12 00 00 00       	mov    $0x12,%eax
     ddd:	cd 40                	int    $0x40
     ddf:	c3                   	ret    

00000de0 <fstat>:
SYSCALL(fstat)
     de0:	b8 08 00 00 00       	mov    $0x8,%eax
     de5:	cd 40                	int    $0x40
     de7:	c3                   	ret    

00000de8 <link>:
SYSCALL(link)
     de8:	b8 13 00 00 00       	mov    $0x13,%eax
     ded:	cd 40                	int    $0x40
     def:	c3                   	ret    

00000df0 <mkdir>:
SYSCALL(mkdir)
     df0:	b8 14 00 00 00       	mov    $0x14,%eax
     df5:	cd 40                	int    $0x40
     df7:	c3                   	ret    

00000df8 <chdir>:
SYSCALL(chdir)
     df8:	b8 09 00 00 00       	mov    $0x9,%eax
     dfd:	cd 40                	int    $0x40
     dff:	c3                   	ret    

00000e00 <dup>:
SYSCALL(dup)
     e00:	b8 0a 00 00 00       	mov    $0xa,%eax
     e05:	cd 40                	int    $0x40
     e07:	c3                   	ret    

00000e08 <getpid>:
SYSCALL(getpid)
     e08:	b8 0b 00 00 00       	mov    $0xb,%eax
     e0d:	cd 40                	int    $0x40
     e0f:	c3                   	ret    

00000e10 <sbrk>:
SYSCALL(sbrk)
     e10:	b8 0c 00 00 00       	mov    $0xc,%eax
     e15:	cd 40                	int    $0x40
     e17:	c3                   	ret    

00000e18 <sleep>:
SYSCALL(sleep)
     e18:	b8 0d 00 00 00       	mov    $0xd,%eax
     e1d:	cd 40                	int    $0x40
     e1f:	c3                   	ret    

00000e20 <uptime>:
SYSCALL(uptime)
     e20:	b8 0e 00 00 00       	mov    $0xe,%eax
     e25:	cd 40                	int    $0x40
     e27:	c3                   	ret    

00000e28 <thread_create>:
SYSCALL(thread_create)
     e28:	b8 16 00 00 00       	mov    $0x16,%eax
     e2d:	cd 40                	int    $0x40
     e2f:	c3                   	ret    

00000e30 <thread_getId>:
SYSCALL(thread_getId)
     e30:	b8 17 00 00 00       	mov    $0x17,%eax
     e35:	cd 40                	int    $0x40
     e37:	c3                   	ret    

00000e38 <thread_getProcId>:
SYSCALL(thread_getProcId)
     e38:	b8 18 00 00 00       	mov    $0x18,%eax
     e3d:	cd 40                	int    $0x40
     e3f:	c3                   	ret    

00000e40 <thread_join>:
SYSCALL(thread_join)
     e40:	b8 19 00 00 00       	mov    $0x19,%eax
     e45:	cd 40                	int    $0x40
     e47:	c3                   	ret    

00000e48 <thread_exit>:
SYSCALL(thread_exit)
     e48:	b8 1a 00 00 00       	mov    $0x1a,%eax
     e4d:	cd 40                	int    $0x40
     e4f:	c3                   	ret    

00000e50 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     e50:	b8 1b 00 00 00       	mov    $0x1b,%eax
     e55:	cd 40                	int    $0x40
     e57:	c3                   	ret    

00000e58 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     e58:	b8 1c 00 00 00       	mov    $0x1c,%eax
     e5d:	cd 40                	int    $0x40
     e5f:	c3                   	ret    

00000e60 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     e60:	b8 1d 00 00 00       	mov    $0x1d,%eax
     e65:	cd 40                	int    $0x40
     e67:	c3                   	ret    

00000e68 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     e68:	55                   	push   %ebp
     e69:	89 e5                	mov    %esp,%ebp
     e6b:	83 ec 28             	sub    $0x28,%esp
     e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
     e71:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     e74:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e7b:	00 
     e7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
     e7f:	89 44 24 04          	mov    %eax,0x4(%esp)
     e83:	8b 45 08             	mov    0x8(%ebp),%eax
     e86:	89 04 24             	mov    %eax,(%esp)
     e89:	e8 1a ff ff ff       	call   da8 <write>
}
     e8e:	c9                   	leave  
     e8f:	c3                   	ret    

00000e90 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e90:	55                   	push   %ebp
     e91:	89 e5                	mov    %esp,%ebp
     e93:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     e96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     e9d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     ea1:	74 17                	je     eba <printint+0x2a>
     ea3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     ea7:	79 11                	jns    eba <printint+0x2a>
    neg = 1;
     ea9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb3:	f7 d8                	neg    %eax
     eb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
     eb8:	eb 06                	jmp    ec0 <printint+0x30>
  } else {
    x = xx;
     eba:	8b 45 0c             	mov    0xc(%ebp),%eax
     ebd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     ec0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     ec7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     eca:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ecd:	ba 00 00 00 00       	mov    $0x0,%edx
     ed2:	f7 f1                	div    %ecx
     ed4:	89 d0                	mov    %edx,%eax
     ed6:	0f b6 90 58 1e 00 00 	movzbl 0x1e58(%eax),%edx
     edd:	8d 45 dc             	lea    -0x24(%ebp),%eax
     ee0:	03 45 f4             	add    -0xc(%ebp),%eax
     ee3:	88 10                	mov    %dl,(%eax)
     ee5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     ee9:	8b 55 10             	mov    0x10(%ebp),%edx
     eec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ef2:	ba 00 00 00 00       	mov    $0x0,%edx
     ef7:	f7 75 d4             	divl   -0x2c(%ebp)
     efa:	89 45 ec             	mov    %eax,-0x14(%ebp)
     efd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f01:	75 c4                	jne    ec7 <printint+0x37>
  if(neg)
     f03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f07:	74 2a                	je     f33 <printint+0xa3>
    buf[i++] = '-';
     f09:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f0c:	03 45 f4             	add    -0xc(%ebp),%eax
     f0f:	c6 00 2d             	movb   $0x2d,(%eax)
     f12:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     f16:	eb 1b                	jmp    f33 <printint+0xa3>
    putc(fd, buf[i]);
     f18:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f1b:	03 45 f4             	add    -0xc(%ebp),%eax
     f1e:	0f b6 00             	movzbl (%eax),%eax
     f21:	0f be c0             	movsbl %al,%eax
     f24:	89 44 24 04          	mov    %eax,0x4(%esp)
     f28:	8b 45 08             	mov    0x8(%ebp),%eax
     f2b:	89 04 24             	mov    %eax,(%esp)
     f2e:	e8 35 ff ff ff       	call   e68 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     f33:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f3b:	79 db                	jns    f18 <printint+0x88>
    putc(fd, buf[i]);
}
     f3d:	c9                   	leave  
     f3e:	c3                   	ret    

00000f3f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     f3f:	55                   	push   %ebp
     f40:	89 e5                	mov    %esp,%ebp
     f42:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     f45:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     f4c:	8d 45 0c             	lea    0xc(%ebp),%eax
     f4f:	83 c0 04             	add    $0x4,%eax
     f52:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     f55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     f5c:	e9 7d 01 00 00       	jmp    10de <printf+0x19f>
    c = fmt[i] & 0xff;
     f61:	8b 55 0c             	mov    0xc(%ebp),%edx
     f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f67:	01 d0                	add    %edx,%eax
     f69:	0f b6 00             	movzbl (%eax),%eax
     f6c:	0f be c0             	movsbl %al,%eax
     f6f:	25 ff 00 00 00       	and    $0xff,%eax
     f74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     f77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f7b:	75 2c                	jne    fa9 <printf+0x6a>
      if(c == '%'){
     f7d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     f81:	75 0c                	jne    f8f <printf+0x50>
        state = '%';
     f83:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     f8a:	e9 4b 01 00 00       	jmp    10da <printf+0x19b>
      } else {
        putc(fd, c);
     f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f92:	0f be c0             	movsbl %al,%eax
     f95:	89 44 24 04          	mov    %eax,0x4(%esp)
     f99:	8b 45 08             	mov    0x8(%ebp),%eax
     f9c:	89 04 24             	mov    %eax,(%esp)
     f9f:	e8 c4 fe ff ff       	call   e68 <putc>
     fa4:	e9 31 01 00 00       	jmp    10da <printf+0x19b>
      }
    } else if(state == '%'){
     fa9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     fad:	0f 85 27 01 00 00    	jne    10da <printf+0x19b>
      if(c == 'd'){
     fb3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     fb7:	75 2d                	jne    fe6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fbc:	8b 00                	mov    (%eax),%eax
     fbe:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     fc5:	00 
     fc6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     fcd:	00 
     fce:	89 44 24 04          	mov    %eax,0x4(%esp)
     fd2:	8b 45 08             	mov    0x8(%ebp),%eax
     fd5:	89 04 24             	mov    %eax,(%esp)
     fd8:	e8 b3 fe ff ff       	call   e90 <printint>
        ap++;
     fdd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     fe1:	e9 ed 00 00 00       	jmp    10d3 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
     fe6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     fea:	74 06                	je     ff2 <printf+0xb3>
     fec:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     ff0:	75 2d                	jne    101f <printf+0xe0>
        printint(fd, *ap, 16, 0);
     ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ff5:	8b 00                	mov    (%eax),%eax
     ff7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     ffe:	00 
     fff:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1006:	00 
    1007:	89 44 24 04          	mov    %eax,0x4(%esp)
    100b:	8b 45 08             	mov    0x8(%ebp),%eax
    100e:	89 04 24             	mov    %eax,(%esp)
    1011:	e8 7a fe ff ff       	call   e90 <printint>
        ap++;
    1016:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    101a:	e9 b4 00 00 00       	jmp    10d3 <printf+0x194>
      } else if(c == 's'){
    101f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1023:	75 46                	jne    106b <printf+0x12c>
        s = (char*)*ap;
    1025:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1028:	8b 00                	mov    (%eax),%eax
    102a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    102d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1031:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1035:	75 27                	jne    105e <printf+0x11f>
          s = "(null)";
    1037:	c7 45 f4 70 18 00 00 	movl   $0x1870,-0xc(%ebp)
        while(*s != 0){
    103e:	eb 1e                	jmp    105e <printf+0x11f>
          putc(fd, *s);
    1040:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1043:	0f b6 00             	movzbl (%eax),%eax
    1046:	0f be c0             	movsbl %al,%eax
    1049:	89 44 24 04          	mov    %eax,0x4(%esp)
    104d:	8b 45 08             	mov    0x8(%ebp),%eax
    1050:	89 04 24             	mov    %eax,(%esp)
    1053:	e8 10 fe ff ff       	call   e68 <putc>
          s++;
    1058:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    105c:	eb 01                	jmp    105f <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    105e:	90                   	nop
    105f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1062:	0f b6 00             	movzbl (%eax),%eax
    1065:	84 c0                	test   %al,%al
    1067:	75 d7                	jne    1040 <printf+0x101>
    1069:	eb 68                	jmp    10d3 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    106b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    106f:	75 1d                	jne    108e <printf+0x14f>
        putc(fd, *ap);
    1071:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1074:	8b 00                	mov    (%eax),%eax
    1076:	0f be c0             	movsbl %al,%eax
    1079:	89 44 24 04          	mov    %eax,0x4(%esp)
    107d:	8b 45 08             	mov    0x8(%ebp),%eax
    1080:	89 04 24             	mov    %eax,(%esp)
    1083:	e8 e0 fd ff ff       	call   e68 <putc>
        ap++;
    1088:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    108c:	eb 45                	jmp    10d3 <printf+0x194>
      } else if(c == '%'){
    108e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1092:	75 17                	jne    10ab <printf+0x16c>
        putc(fd, c);
    1094:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1097:	0f be c0             	movsbl %al,%eax
    109a:	89 44 24 04          	mov    %eax,0x4(%esp)
    109e:	8b 45 08             	mov    0x8(%ebp),%eax
    10a1:	89 04 24             	mov    %eax,(%esp)
    10a4:	e8 bf fd ff ff       	call   e68 <putc>
    10a9:	eb 28                	jmp    10d3 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    10ab:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    10b2:	00 
    10b3:	8b 45 08             	mov    0x8(%ebp),%eax
    10b6:	89 04 24             	mov    %eax,(%esp)
    10b9:	e8 aa fd ff ff       	call   e68 <putc>
        putc(fd, c);
    10be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10c1:	0f be c0             	movsbl %al,%eax
    10c4:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c8:	8b 45 08             	mov    0x8(%ebp),%eax
    10cb:	89 04 24             	mov    %eax,(%esp)
    10ce:	e8 95 fd ff ff       	call   e68 <putc>
      }
      state = 0;
    10d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    10da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    10de:	8b 55 0c             	mov    0xc(%ebp),%edx
    10e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10e4:	01 d0                	add    %edx,%eax
    10e6:	0f b6 00             	movzbl (%eax),%eax
    10e9:	84 c0                	test   %al,%al
    10eb:	0f 85 70 fe ff ff    	jne    f61 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    10f1:	c9                   	leave  
    10f2:	c3                   	ret    
    10f3:	90                   	nop

000010f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10f4:	55                   	push   %ebp
    10f5:	89 e5                	mov    %esp,%ebp
    10f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10fa:	8b 45 08             	mov    0x8(%ebp),%eax
    10fd:	83 e8 08             	sub    $0x8,%eax
    1100:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1103:	a1 74 1e 00 00       	mov    0x1e74,%eax
    1108:	89 45 fc             	mov    %eax,-0x4(%ebp)
    110b:	eb 24                	jmp    1131 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    110d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1110:	8b 00                	mov    (%eax),%eax
    1112:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1115:	77 12                	ja     1129 <free+0x35>
    1117:	8b 45 f8             	mov    -0x8(%ebp),%eax
    111a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    111d:	77 24                	ja     1143 <free+0x4f>
    111f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1122:	8b 00                	mov    (%eax),%eax
    1124:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1127:	77 1a                	ja     1143 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1129:	8b 45 fc             	mov    -0x4(%ebp),%eax
    112c:	8b 00                	mov    (%eax),%eax
    112e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1131:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1134:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1137:	76 d4                	jbe    110d <free+0x19>
    1139:	8b 45 fc             	mov    -0x4(%ebp),%eax
    113c:	8b 00                	mov    (%eax),%eax
    113e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1141:	76 ca                	jbe    110d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1143:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1146:	8b 40 04             	mov    0x4(%eax),%eax
    1149:	c1 e0 03             	shl    $0x3,%eax
    114c:	89 c2                	mov    %eax,%edx
    114e:	03 55 f8             	add    -0x8(%ebp),%edx
    1151:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1154:	8b 00                	mov    (%eax),%eax
    1156:	39 c2                	cmp    %eax,%edx
    1158:	75 24                	jne    117e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    115a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    115d:	8b 50 04             	mov    0x4(%eax),%edx
    1160:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1163:	8b 00                	mov    (%eax),%eax
    1165:	8b 40 04             	mov    0x4(%eax),%eax
    1168:	01 c2                	add    %eax,%edx
    116a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    116d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1170:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1173:	8b 00                	mov    (%eax),%eax
    1175:	8b 10                	mov    (%eax),%edx
    1177:	8b 45 f8             	mov    -0x8(%ebp),%eax
    117a:	89 10                	mov    %edx,(%eax)
    117c:	eb 0a                	jmp    1188 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1181:	8b 10                	mov    (%eax),%edx
    1183:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1186:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1188:	8b 45 fc             	mov    -0x4(%ebp),%eax
    118b:	8b 40 04             	mov    0x4(%eax),%eax
    118e:	c1 e0 03             	shl    $0x3,%eax
    1191:	03 45 fc             	add    -0x4(%ebp),%eax
    1194:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1197:	75 20                	jne    11b9 <free+0xc5>
    p->s.size += bp->s.size;
    1199:	8b 45 fc             	mov    -0x4(%ebp),%eax
    119c:	8b 50 04             	mov    0x4(%eax),%edx
    119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11a2:	8b 40 04             	mov    0x4(%eax),%eax
    11a5:	01 c2                	add    %eax,%edx
    11a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11aa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    11ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11b0:	8b 10                	mov    (%eax),%edx
    11b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11b5:	89 10                	mov    %edx,(%eax)
    11b7:	eb 08                	jmp    11c1 <free+0xcd>
  } else
    p->s.ptr = bp;
    11b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
    11bf:	89 10                	mov    %edx,(%eax)
  freep = p;
    11c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11c4:	a3 74 1e 00 00       	mov    %eax,0x1e74
}
    11c9:	c9                   	leave  
    11ca:	c3                   	ret    

000011cb <morecore>:

static Header*
morecore(uint nu)
{
    11cb:	55                   	push   %ebp
    11cc:	89 e5                	mov    %esp,%ebp
    11ce:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    11d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    11d8:	77 07                	ja     11e1 <morecore+0x16>
    nu = 4096;
    11da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    11e1:	8b 45 08             	mov    0x8(%ebp),%eax
    11e4:	c1 e0 03             	shl    $0x3,%eax
    11e7:	89 04 24             	mov    %eax,(%esp)
    11ea:	e8 21 fc ff ff       	call   e10 <sbrk>
    11ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    11f2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    11f6:	75 07                	jne    11ff <morecore+0x34>
    return 0;
    11f8:	b8 00 00 00 00       	mov    $0x0,%eax
    11fd:	eb 22                	jmp    1221 <morecore+0x56>
  hp = (Header*)p;
    11ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1202:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1205:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1208:	8b 55 08             	mov    0x8(%ebp),%edx
    120b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    120e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1211:	83 c0 08             	add    $0x8,%eax
    1214:	89 04 24             	mov    %eax,(%esp)
    1217:	e8 d8 fe ff ff       	call   10f4 <free>
  return freep;
    121c:	a1 74 1e 00 00       	mov    0x1e74,%eax
}
    1221:	c9                   	leave  
    1222:	c3                   	ret    

00001223 <malloc>:

void*
malloc(uint nbytes)
{
    1223:	55                   	push   %ebp
    1224:	89 e5                	mov    %esp,%ebp
    1226:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1229:	8b 45 08             	mov    0x8(%ebp),%eax
    122c:	83 c0 07             	add    $0x7,%eax
    122f:	c1 e8 03             	shr    $0x3,%eax
    1232:	83 c0 01             	add    $0x1,%eax
    1235:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1238:	a1 74 1e 00 00       	mov    0x1e74,%eax
    123d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1244:	75 23                	jne    1269 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1246:	c7 45 f0 6c 1e 00 00 	movl   $0x1e6c,-0x10(%ebp)
    124d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1250:	a3 74 1e 00 00       	mov    %eax,0x1e74
    1255:	a1 74 1e 00 00       	mov    0x1e74,%eax
    125a:	a3 6c 1e 00 00       	mov    %eax,0x1e6c
    base.s.size = 0;
    125f:	c7 05 70 1e 00 00 00 	movl   $0x0,0x1e70
    1266:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1269:	8b 45 f0             	mov    -0x10(%ebp),%eax
    126c:	8b 00                	mov    (%eax),%eax
    126e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1271:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1274:	8b 40 04             	mov    0x4(%eax),%eax
    1277:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    127a:	72 4d                	jb     12c9 <malloc+0xa6>
      if(p->s.size == nunits)
    127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    127f:	8b 40 04             	mov    0x4(%eax),%eax
    1282:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1285:	75 0c                	jne    1293 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1287:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128a:	8b 10                	mov    (%eax),%edx
    128c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    128f:	89 10                	mov    %edx,(%eax)
    1291:	eb 26                	jmp    12b9 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1293:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1296:	8b 40 04             	mov    0x4(%eax),%eax
    1299:	89 c2                	mov    %eax,%edx
    129b:	2b 55 ec             	sub    -0x14(%ebp),%edx
    129e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    12a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a7:	8b 40 04             	mov    0x4(%eax),%eax
    12aa:	c1 e0 03             	shl    $0x3,%eax
    12ad:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    12b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    12b6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    12b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12bc:	a3 74 1e 00 00       	mov    %eax,0x1e74
      return (void*)(p + 1);
    12c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12c4:	83 c0 08             	add    $0x8,%eax
    12c7:	eb 38                	jmp    1301 <malloc+0xde>
    }
    if(p == freep)
    12c9:	a1 74 1e 00 00       	mov    0x1e74,%eax
    12ce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    12d1:	75 1b                	jne    12ee <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    12d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    12d6:	89 04 24             	mov    %eax,(%esp)
    12d9:	e8 ed fe ff ff       	call   11cb <morecore>
    12de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    12e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12e5:	75 07                	jne    12ee <malloc+0xcb>
        return 0;
    12e7:	b8 00 00 00 00       	mov    $0x0,%eax
    12ec:	eb 13                	jmp    1301 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f7:	8b 00                	mov    (%eax),%eax
    12f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    12fc:	e9 70 ff ff ff       	jmp    1271 <malloc+0x4e>
}
    1301:	c9                   	leave  
    1302:	c3                   	ret    
    1303:	90                   	nop

00001304 <semaphore_create>:
#include "semaphore.h"
#include "types.h"
#include "user.h"


struct semaphore* semaphore_create(int initial_semaphore_value){
    1304:	55                   	push   %ebp
    1305:	89 e5                	mov    %esp,%ebp
    1307:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* sem=malloc(sizeof(struct semaphore)); 
    130a:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    1311:	e8 0d ff ff ff       	call   1223 <malloc>
    1316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // acquire semaphors
  sem->s1 = binary_semaphore_create(1);
    1319:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1320:	e8 2b fb ff ff       	call   e50 <binary_semaphore_create>
    1325:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1328:	89 02                	mov    %eax,(%edx)
  
  // s2 should be initialized with the min{1,initial_semaphore_value}
  if(initial_semaphore_value >= 1){
    132a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    132e:	7e 14                	jle    1344 <semaphore_create+0x40>
    sem->s2 = binary_semaphore_create(1);
    1330:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1337:	e8 14 fb ff ff       	call   e50 <binary_semaphore_create>
    133c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    133f:	89 42 04             	mov    %eax,0x4(%edx)
    1342:	eb 11                	jmp    1355 <semaphore_create+0x51>
  }else{
    sem->s2 = binary_semaphore_create(initial_semaphore_value);
    1344:	8b 45 08             	mov    0x8(%ebp),%eax
    1347:	89 04 24             	mov    %eax,(%esp)
    134a:	e8 01 fb ff ff       	call   e50 <binary_semaphore_create>
    134f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1352:	89 42 04             	mov    %eax,0x4(%edx)
  }
  
  if(sem->s1 == -1 || sem->s2 == -1){
    1355:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1358:	8b 00                	mov    (%eax),%eax
    135a:	83 f8 ff             	cmp    $0xffffffff,%eax
    135d:	74 0b                	je     136a <semaphore_create+0x66>
    135f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1362:	8b 40 04             	mov    0x4(%eax),%eax
    1365:	83 f8 ff             	cmp    $0xffffffff,%eax
    1368:	75 26                	jne    1390 <semaphore_create+0x8c>
     printf(1,"we had a probalem initialize in semaphore_create\n");
    136a:	c7 44 24 04 78 18 00 	movl   $0x1878,0x4(%esp)
    1371:	00 
    1372:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1379:	e8 c1 fb ff ff       	call   f3f <printf>
     free(sem);
    137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1381:	89 04 24             	mov    %eax,(%esp)
    1384:	e8 6b fd ff ff       	call   10f4 <free>
     return 0;
    1389:	b8 00 00 00 00       	mov    $0x0,%eax
    138e:	eb 15                	jmp    13a5 <semaphore_create+0xa1>
  }
  //initialize value
  sem->value = initial_semaphore_value;//dynamic
    1390:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1393:	8b 55 08             	mov    0x8(%ebp),%edx
    1396:	89 50 08             	mov    %edx,0x8(%eax)
  sem->initial_value = initial_semaphore_value;//static
    1399:	8b 45 f4             	mov    -0xc(%ebp),%eax
    139c:	8b 55 08             	mov    0x8(%ebp),%edx
    139f:	89 50 0c             	mov    %edx,0xc(%eax)
  
  return sem;
    13a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    13a5:	c9                   	leave  
    13a6:	c3                   	ret    

000013a7 <semaphore_down>:
void semaphore_down(struct semaphore* sem ){
    13a7:	55                   	push   %ebp
    13a8:	89 e5                	mov    %esp,%ebp
    13aa:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s2);
    13ad:	8b 45 08             	mov    0x8(%ebp),%eax
    13b0:	8b 40 04             	mov    0x4(%eax),%eax
    13b3:	89 04 24             	mov    %eax,(%esp)
    13b6:	e8 9d fa ff ff       	call   e58 <binary_semaphore_down>
  binary_semaphore_down(sem->s1);
    13bb:	8b 45 08             	mov    0x8(%ebp),%eax
    13be:	8b 00                	mov    (%eax),%eax
    13c0:	89 04 24             	mov    %eax,(%esp)
    13c3:	e8 90 fa ff ff       	call   e58 <binary_semaphore_down>
  sem->value--;	
    13c8:	8b 45 08             	mov    0x8(%ebp),%eax
    13cb:	8b 40 08             	mov    0x8(%eax),%eax
    13ce:	8d 50 ff             	lea    -0x1(%eax),%edx
    13d1:	8b 45 08             	mov    0x8(%ebp),%eax
    13d4:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value > 0){
    13d7:	8b 45 08             	mov    0x8(%ebp),%eax
    13da:	8b 40 08             	mov    0x8(%eax),%eax
    13dd:	85 c0                	test   %eax,%eax
    13df:	7e 0e                	jle    13ef <semaphore_down+0x48>
   binary_semaphore_up(sem->s2);
    13e1:	8b 45 08             	mov    0x8(%ebp),%eax
    13e4:	8b 40 04             	mov    0x4(%eax),%eax
    13e7:	89 04 24             	mov    %eax,(%esp)
    13ea:	e8 71 fa ff ff       	call   e60 <binary_semaphore_up>
  }
  binary_semaphore_up(sem->s1); 
    13ef:	8b 45 08             	mov    0x8(%ebp),%eax
    13f2:	8b 00                	mov    (%eax),%eax
    13f4:	89 04 24             	mov    %eax,(%esp)
    13f7:	e8 64 fa ff ff       	call   e60 <binary_semaphore_up>
}
    13fc:	c9                   	leave  
    13fd:	c3                   	ret    

000013fe <semaphore_up>:
void semaphore_up(struct semaphore* sem ){
    13fe:	55                   	push   %ebp
    13ff:	89 e5                	mov    %esp,%ebp
    1401:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
    1404:	8b 45 08             	mov    0x8(%ebp),%eax
    1407:	8b 00                	mov    (%eax),%eax
    1409:	89 04 24             	mov    %eax,(%esp)
    140c:	e8 47 fa ff ff       	call   e58 <binary_semaphore_down>
  sem->value++;	
    1411:	8b 45 08             	mov    0x8(%ebp),%eax
    1414:	8b 40 08             	mov    0x8(%eax),%eax
    1417:	8d 50 01             	lea    0x1(%eax),%edx
    141a:	8b 45 08             	mov    0x8(%ebp),%eax
    141d:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value ==1){
    1420:	8b 45 08             	mov    0x8(%ebp),%eax
    1423:	8b 40 08             	mov    0x8(%eax),%eax
    1426:	83 f8 01             	cmp    $0x1,%eax
    1429:	75 0e                	jne    1439 <semaphore_up+0x3b>
   binary_semaphore_up(sem->s2); 
    142b:	8b 45 08             	mov    0x8(%ebp),%eax
    142e:	8b 40 04             	mov    0x4(%eax),%eax
    1431:	89 04 24             	mov    %eax,(%esp)
    1434:	e8 27 fa ff ff       	call   e60 <binary_semaphore_up>
   }
  binary_semaphore_up(sem->s1);
    1439:	8b 45 08             	mov    0x8(%ebp),%eax
    143c:	8b 00                	mov    (%eax),%eax
    143e:	89 04 24             	mov    %eax,(%esp)
    1441:	e8 1a fa ff ff       	call   e60 <binary_semaphore_up>
}
    1446:	c9                   	leave  
    1447:	c3                   	ret    

00001448 <semaphore_free>:

void semaphore_free(struct semaphore* sem){
    1448:	55                   	push   %ebp
    1449:	89 e5                	mov    %esp,%ebp
    144b:	83 ec 18             	sub    $0x18,%esp
  free(sem);
    144e:	8b 45 08             	mov    0x8(%ebp),%eax
    1451:	89 04 24             	mov    %eax,(%esp)
    1454:	e8 9b fc ff ff       	call   10f4 <free>
}
    1459:	c9                   	leave  
    145a:	c3                   	ret    
    145b:	90                   	nop

0000145c <BB_create>:
#include "types.h"
#include "user.h"


struct BB* 
BB_create(int max_capacity){
    145c:	55                   	push   %ebp
    145d:	89 e5                	mov    %esp,%ebp
    145f:	83 ec 38             	sub    $0x38,%esp
  //initialize
  struct BB* buf = malloc(sizeof(struct BB));
    1462:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
    1469:	e8 b5 fd ff ff       	call   1223 <malloc>
    146e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
    1471:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    1478:	00 
    1479:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1480:	00 
    1481:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1484:	89 04 24             	mov    %eax,(%esp)
    1487:	e8 57 f7 ff ff       	call   be3 <memset>
 
  buf->buffer_size = max_capacity;
    148c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    148f:	8b 55 08             	mov    0x8(%ebp),%edx
    1492:	89 10                	mov    %edx,(%eax)
  buf->mutex = binary_semaphore_create(1);  
    1494:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    149b:	e8 b0 f9 ff ff       	call   e50 <binary_semaphore_create>
    14a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14a3:	89 42 04             	mov    %eax,0x4(%edx)
  buf->empty = semaphore_create(max_capacity);
    14a6:	8b 45 08             	mov    0x8(%ebp),%eax
    14a9:	89 04 24             	mov    %eax,(%esp)
    14ac:	e8 53 fe ff ff       	call   1304 <semaphore_create>
    14b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14b4:	89 42 08             	mov    %eax,0x8(%edx)
  buf->full = semaphore_create(0);
    14b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    14be:	e8 41 fe ff ff       	call   1304 <semaphore_create>
    14c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14c6:	89 42 0c             	mov    %eax,0xc(%edx)
  buf->pointer_to_elements = malloc(sizeof(void*)*max_capacity);
    14c9:	8b 45 08             	mov    0x8(%ebp),%eax
    14cc:	c1 e0 02             	shl    $0x2,%eax
    14cf:	89 04 24             	mov    %eax,(%esp)
    14d2:	e8 4c fd ff ff       	call   1223 <malloc>
    14d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14da:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->pointer_to_elements,0,sizeof(void*)*max_capacity);
    14dd:	8b 45 08             	mov    0x8(%ebp),%eax
    14e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    14e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ea:	8b 40 1c             	mov    0x1c(%eax),%eax
    14ed:	89 54 24 08          	mov    %edx,0x8(%esp)
    14f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14f8:	00 
    14f9:	89 04 24             	mov    %eax,(%esp)
    14fc:	e8 e2 f6 ff ff       	call   be3 <memset>
  buf->count = 0;
    1501:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1504:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  //check the semaphorses
  if(buf->mutex == -1 || buf->empty == 0 || buf->full == 0){
    150b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    150e:	8b 40 04             	mov    0x4(%eax),%eax
    1511:	83 f8 ff             	cmp    $0xffffffff,%eax
    1514:	74 14                	je     152a <BB_create+0xce>
    1516:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1519:	8b 40 08             	mov    0x8(%eax),%eax
    151c:	85 c0                	test   %eax,%eax
    151e:	74 0a                	je     152a <BB_create+0xce>
    1520:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1523:	8b 40 0c             	mov    0xc(%eax),%eax
    1526:	85 c0                	test   %eax,%eax
    1528:	75 44                	jne    156e <BB_create+0x112>
   printf(1,"we had a problam getting semaphores at BB create mutex %d empty %d full %d\n",buf->mutex,buf->empty,buf->full);
    152a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    152d:	8b 48 0c             	mov    0xc(%eax),%ecx
    1530:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1533:	8b 50 08             	mov    0x8(%eax),%edx
    1536:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1539:	8b 40 04             	mov    0x4(%eax),%eax
    153c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    1540:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1544:	89 44 24 08          	mov    %eax,0x8(%esp)
    1548:	c7 44 24 04 ac 18 00 	movl   $0x18ac,0x4(%esp)
    154f:	00 
    1550:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1557:	e8 e3 f9 ff ff       	call   f3f <printf>
   BB_free(buf);
    155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155f:	89 04 24             	mov    %eax,(%esp)
    1562:	e8 47 01 00 00       	call   16ae <BB_free>
   
   buf =0;  
    1567:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  }
  return buf;
    156e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1571:	c9                   	leave  
    1572:	c3                   	ret    

00001573 <BB_put>:

void BB_put(struct BB* bb, void* element)
{ 
    1573:	55                   	push   %ebp
    1574:	89 e5                	mov    %esp,%ebp
    1576:	83 ec 18             	sub    $0x18,%esp
  semaphore_down(bb->empty);
    1579:	8b 45 08             	mov    0x8(%ebp),%eax
    157c:	8b 40 08             	mov    0x8(%eax),%eax
    157f:	89 04 24             	mov    %eax,(%esp)
    1582:	e8 20 fe ff ff       	call   13a7 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    1587:	8b 45 08             	mov    0x8(%ebp),%eax
    158a:	8b 40 04             	mov    0x4(%eax),%eax
    158d:	89 04 24             	mov    %eax,(%esp)
    1590:	e8 c3 f8 ff ff       	call   e58 <binary_semaphore_down>
   //insert item
  bb->pointer_to_elements[bb->count] = element;
    1595:	8b 45 08             	mov    0x8(%ebp),%eax
    1598:	8b 50 1c             	mov    0x1c(%eax),%edx
    159b:	8b 45 08             	mov    0x8(%ebp),%eax
    159e:	8b 40 10             	mov    0x10(%eax),%eax
    15a1:	c1 e0 02             	shl    $0x2,%eax
    15a4:	01 c2                	add    %eax,%edx
    15a6:	8b 45 0c             	mov    0xc(%ebp),%eax
    15a9:	89 02                	mov    %eax,(%edx)
  bb->count++;
    15ab:	8b 45 08             	mov    0x8(%ebp),%eax
    15ae:	8b 40 10             	mov    0x10(%eax),%eax
    15b1:	8d 50 01             	lea    0x1(%eax),%edx
    15b4:	8b 45 08             	mov    0x8(%ebp),%eax
    15b7:	89 50 10             	mov    %edx,0x10(%eax)
  binary_semaphore_up(bb->mutex);
    15ba:	8b 45 08             	mov    0x8(%ebp),%eax
    15bd:	8b 40 04             	mov    0x4(%eax),%eax
    15c0:	89 04 24             	mov    %eax,(%esp)
    15c3:	e8 98 f8 ff ff       	call   e60 <binary_semaphore_up>
  semaphore_up(bb->full);
    15c8:	8b 45 08             	mov    0x8(%ebp),%eax
    15cb:	8b 40 0c             	mov    0xc(%eax),%eax
    15ce:	89 04 24             	mov    %eax,(%esp)
    15d1:	e8 28 fe ff ff       	call   13fe <semaphore_up>
}
    15d6:	c9                   	leave  
    15d7:	c3                   	ret    

000015d8 <BB_pop>:

void* BB_pop(struct BB* bb)
{
    15d8:	55                   	push   %ebp
    15d9:	89 e5                	mov    %esp,%ebp
    15db:	83 ec 28             	sub    $0x28,%esp
  
  void* element_to_pop;
  semaphore_down(bb->full);
    15de:	8b 45 08             	mov    0x8(%ebp),%eax
    15e1:	8b 40 0c             	mov    0xc(%eax),%eax
    15e4:	89 04 24             	mov    %eax,(%esp)
    15e7:	e8 bb fd ff ff       	call   13a7 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    15ec:	8b 45 08             	mov    0x8(%ebp),%eax
    15ef:	8b 40 04             	mov    0x4(%eax),%eax
    15f2:	89 04 24             	mov    %eax,(%esp)
    15f5:	e8 5e f8 ff ff       	call   e58 <binary_semaphore_down>
  element_to_pop = bb->pointer_to_elements[0];
    15fa:	8b 45 08             	mov    0x8(%ebp),%eax
    15fd:	8b 40 1c             	mov    0x1c(%eax),%eax
    1600:	8b 00                	mov    (%eax),%eax
    1602:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(!element_to_pop){
    1605:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1609:	75 14                	jne    161f <BB_pop+0x47>
  printf(1,"we have uninitialize element\n");
    160b:	c7 44 24 04 f8 18 00 	movl   $0x18f8,0x4(%esp)
    1612:	00 
    1613:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    161a:	e8 20 f9 ff ff       	call   f3f <printf>
  }
  
  // shift left all elements at the array
  int i;
  for(i = 0; i < bb->count ; i++){
    161f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1626:	eb 4b                	jmp    1673 <BB_pop+0x9b>
    if(i != (bb->count -1)){
    1628:	8b 45 08             	mov    0x8(%ebp),%eax
    162b:	8b 40 10             	mov    0x10(%eax),%eax
    162e:	83 e8 01             	sub    $0x1,%eax
    1631:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1634:	74 25                	je     165b <BB_pop+0x83>
      bb->pointer_to_elements[i] = bb->pointer_to_elements[i+1];
    1636:	8b 45 08             	mov    0x8(%ebp),%eax
    1639:	8b 40 1c             	mov    0x1c(%eax),%eax
    163c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    163f:	c1 e2 02             	shl    $0x2,%edx
    1642:	01 c2                	add    %eax,%edx
    1644:	8b 45 08             	mov    0x8(%ebp),%eax
    1647:	8b 40 1c             	mov    0x1c(%eax),%eax
    164a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    164d:	83 c1 01             	add    $0x1,%ecx
    1650:	c1 e1 02             	shl    $0x2,%ecx
    1653:	01 c8                	add    %ecx,%eax
    1655:	8b 00                	mov    (%eax),%eax
    1657:	89 02                	mov    %eax,(%edx)
    1659:	eb 14                	jmp    166f <BB_pop+0x97>
    }else{
      bb->pointer_to_elements[i] = 0;
    165b:	8b 45 08             	mov    0x8(%ebp),%eax
    165e:	8b 40 1c             	mov    0x1c(%eax),%eax
    1661:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1664:	c1 e2 02             	shl    $0x2,%edx
    1667:	01 d0                	add    %edx,%eax
    1669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  printf(1,"we have uninitialize element\n");
  }
  
  // shift left all elements at the array
  int i;
  for(i = 0; i < bb->count ; i++){
    166f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1673:	8b 45 08             	mov    0x8(%ebp),%eax
    1676:	8b 40 10             	mov    0x10(%eax),%eax
    1679:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    167c:	7f aa                	jg     1628 <BB_pop+0x50>
     }
     
  }
  
  
  bb->count--;
    167e:	8b 45 08             	mov    0x8(%ebp),%eax
    1681:	8b 40 10             	mov    0x10(%eax),%eax
    1684:	8d 50 ff             	lea    -0x1(%eax),%edx
    1687:	8b 45 08             	mov    0x8(%ebp),%eax
    168a:	89 50 10             	mov    %edx,0x10(%eax)
  
  binary_semaphore_up(bb->mutex);
    168d:	8b 45 08             	mov    0x8(%ebp),%eax
    1690:	8b 40 04             	mov    0x4(%eax),%eax
    1693:	89 04 24             	mov    %eax,(%esp)
    1696:	e8 c5 f7 ff ff       	call   e60 <binary_semaphore_up>
  semaphore_up(bb->empty);
    169b:	8b 45 08             	mov    0x8(%ebp),%eax
    169e:	8b 40 08             	mov    0x8(%eax),%eax
    16a1:	89 04 24             	mov    %eax,(%esp)
    16a4:	e8 55 fd ff ff       	call   13fe <semaphore_up>
  
  return element_to_pop;
    16a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    16ac:	c9                   	leave  
    16ad:	c3                   	ret    

000016ae <BB_free>:

void BB_free(struct BB* bb){
    16ae:	55                   	push   %ebp
    16af:	89 e5                	mov    %esp,%ebp
    16b1:	83 ec 18             	sub    $0x18,%esp
  semaphore_free(bb->empty);
    16b4:	8b 45 08             	mov    0x8(%ebp),%eax
    16b7:	8b 40 08             	mov    0x8(%eax),%eax
    16ba:	89 04 24             	mov    %eax,(%esp)
    16bd:	e8 86 fd ff ff       	call   1448 <semaphore_free>
  semaphore_free(bb->full);
    16c2:	8b 45 08             	mov    0x8(%ebp),%eax
    16c5:	8b 40 0c             	mov    0xc(%eax),%eax
    16c8:	89 04 24             	mov    %eax,(%esp)
    16cb:	e8 78 fd ff ff       	call   1448 <semaphore_free>
  free(bb->pointer_to_elements);
    16d0:	8b 45 08             	mov    0x8(%ebp),%eax
    16d3:	8b 40 1c             	mov    0x1c(%eax),%eax
    16d6:	89 04 24             	mov    %eax,(%esp)
    16d9:	e8 16 fa ff ff       	call   10f4 <free>
  free(bb);
    16de:	8b 45 08             	mov    0x8(%ebp),%eax
    16e1:	89 04 24             	mov    %eax,(%esp)
    16e4:	e8 0b fa ff ff       	call   10f4 <free>
}
    16e9:	c9                   	leave  
    16ea:	c3                   	ret    
