
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
       6:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 bc 13 00 00       	call   13cf <semaphore_down>
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
      1b:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 fe 13 00 00       	call   1426 <semaphore_up>
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
      30:	a1 dc 1e 00 00       	mov    0x1edc,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 57 15 00 00       	call   159b <BB_put>
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
      4c:	a1 dc 1e 00 00       	mov    0x1edc,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 bf 15 00 00       	call   1618 <BB_pop>
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
      61:	a1 ec 1e 00 00       	mov    0x1eec,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 26 15 00 00       	call   159b <BB_put>
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
      7d:	a1 ec 1e 00 00       	mov    0x1eec,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 8e 15 00 00       	call   1618 <BB_pop>
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
      92:	a1 08 1f 00 00       	mov    0x1f08,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 79 15 00 00       	call   1618 <BB_pop>
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
      a7:	a1 08 1f 00 00       	mov    0x1f08,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 e0 14 00 00       	call   159b <BB_put>
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
      c3:	a1 e0 1e 00 00       	mov    0x1ee0,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 c4 14 00 00       	call   159b <BB_put>
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
      df:	a1 e0 1e 00 00       	mov    0x1ee0,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 2c 15 00 00       	call   1618 <BB_pop>
}
      ec:	c9                   	leave  
      ed:	c3                   	ret    

000000ee <student>:

// student simulation
void* student(){
      ee:	55                   	push   %ebp
      ef:	89 e5                	mov    %esp,%ebp
      f1:	83 ec 48             	sub    $0x48,%esp
   // void* ret_val = 0;
    enter_bar();
      f4:	e8 07 ff ff ff       	call   0 <enter_bar>
    //binary_semaphore_down(general_mutex);
    int tid = thread_getId();
      f9:	e8 5a 0d 00 00       	call   e58 <thread_getId>
      fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
   // binary_semaphore_up(general_mutex);
    tid = tid % 5;
     101:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     104:	ba 67 66 66 66       	mov    $0x66666667,%edx
     109:	89 c8                	mov    %ecx,%eax
     10b:	f7 ea                	imul   %edx
     10d:	d1 fa                	sar    %edx
     10f:	89 c8                	mov    %ecx,%eax
     111:	c1 f8 1f             	sar    $0x1f,%eax
     114:	29 c2                	sub    %eax,%edx
     116:	89 d0                	mov    %edx,%eax
     118:	c1 e0 02             	shl    $0x2,%eax
     11b:	01 d0                	add    %edx,%eax
     11d:	89 ca                	mov    %ecx,%edx
     11f:	29 c2                	sub    %eax,%edx
     121:	89 d0                	mov    %edx,%eax
     123:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i;
    for(i = 0; i < tid; i++){
     126:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     12d:	e9 b1 00 00 00       	jmp    1e3 <student+0xf5>
	struct Action* drink_action = malloc(sizeof(struct Action));
     132:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     139:	e8 0d 11 00 00       	call   124b <malloc>
     13e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	drink_action->action_type = DRINK_ORDER;
     141:	8b 45 ec             	mov    -0x14(%ebp),%eax
     144:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	drink_action->cup = 0;
     14a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     14d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	drink_action->tid = tid;
     154:	8b 45 ec             	mov    -0x14(%ebp),%eax
     157:	8b 55 f0             	mov    -0x10(%ebp),%edx
     15a:	89 50 08             	mov    %edx,0x8(%eax)
	place_action(drink_action);//Order a Drink
     15d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     160:	89 04 24             	mov    %eax,(%esp)
     163:	e8 c2 fe ff ff       	call   2a <place_action>
	struct Cup * cup = get_drink();	//get the drink from the BB
     168:	e8 0a ff ff ff       	call   77 <get_drink>
     16d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//need to write to file intsead of screen TODO
	printf(1,"Student %d is having his %d drink, with cup %d\n",tid,i+1,cup->id);
     170:	8b 45 e8             	mov    -0x18(%ebp),%eax
     173:	8b 00                	mov    (%eax),%eax
     175:	8b 55 f4             	mov    -0xc(%ebp),%edx
     178:	83 c2 01             	add    $0x1,%edx
     17b:	89 44 24 10          	mov    %eax,0x10(%esp)
     17f:	89 54 24 0c          	mov    %edx,0xc(%esp)
     183:	8b 45 f0             	mov    -0x10(%ebp),%eax
     186:	89 44 24 08          	mov    %eax,0x8(%esp)
     18a:	c7 44 24 04 3c 17 00 	movl   $0x173c,0x4(%esp)
     191:	00 
     192:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     199:	e8 c9 0d 00 00       	call   f67 <printf>
	sleep(1);
     19e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1a5:	e8 96 0c 00 00       	call   e40 <sleep>
	struct Action* retrun_action = malloc(sizeof(struct Action));
     1aa:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     1b1:	e8 95 10 00 00       	call   124b <malloc>
     1b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	retrun_action->action_type = RETURN_CUP;
     1b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1bc:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
	retrun_action->cup=cup;
     1c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
     1c8:	89 50 04             	mov    %edx,0x4(%eax)
	retrun_action->tid = tid;
     1cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
     1d1:	89 50 08             	mov    %edx,0x8(%eax)
	place_action(retrun_action);
     1d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1d7:	89 04 24             	mov    %eax,(%esp)
     1da:	e8 4b fe ff ff       	call   2a <place_action>
    //binary_semaphore_down(general_mutex);
    int tid = thread_getId();
   // binary_semaphore_up(general_mutex);
    tid = tid % 5;
    int i;
    for(i = 0; i < tid; i++){
     1df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     1e9:	0f 8c 43 ff ff ff    	jl     132 <student+0x44>
	retrun_action->cup=cup;
	retrun_action->tid = tid;
	place_action(retrun_action);
    }
    //need to write to file intsead of screen TODO
    printf(1,"Student %d is drunk, and trying to go home\n",thread_getId());
     1ef:	e8 64 0c 00 00       	call   e58 <thread_getId>
     1f4:	89 44 24 08          	mov    %eax,0x8(%esp)
     1f8:	c7 44 24 04 6c 17 00 	movl   $0x176c,0x4(%esp)
     1ff:	00 
     200:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     207:	e8 5b 0d 00 00       	call   f67 <printf>
    leave_bar();
     20c:	e8 04 fe ff ff       	call   15 <leave_bar>
    thread_exit(0);
     211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     218:	e8 53 0c 00 00       	call   e70 <thread_exit>
    return 0;
     21d:	b8 00 00 00 00       	mov    $0x0,%eax
}
     222:	c9                   	leave  
     223:	c3                   	ret    

00000224 <bartender>:

//bartender simulation
void* bartender(){
     224:	55                   	push   %ebp
     225:	89 e5                	mov    %esp,%ebp
     227:	83 ec 48             	sub    $0x48,%esp
    void* ret_val = 0;
     22a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int tid = thread_getId();
     231:	e8 22 0c 00 00       	call   e58 <thread_getId>
     236:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(;;){
	struct Action* bartender_action = get_action();	
     239:	e8 08 fe ff ff       	call   46 <get_action>
     23e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(bartender_action->action_type == DRINK_ORDER){
     241:	8b 45 ec             	mov    -0x14(%ebp),%eax
     244:	8b 00                	mov    (%eax),%eax
     246:	83 f8 01             	cmp    $0x1,%eax
     249:	75 39                	jne    284 <bartender+0x60>
	    struct Cup* current_cup = get_clean_cup();
     24b:	e8 3c fe ff ff       	call   8c <get_clean_cup>
     250:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    //need to write to file intsead of screen TODO
	    printf(1,"Bartender %d is making drink with cup %d\n",tid,current_cup->id);
     253:	8b 45 e8             	mov    -0x18(%ebp),%eax
     256:	8b 00                	mov    (%eax),%eax
     258:	89 44 24 0c          	mov    %eax,0xc(%esp)
     25c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     25f:	89 44 24 08          	mov    %eax,0x8(%esp)
     263:	c7 44 24 04 98 17 00 	movl   $0x1798,0x4(%esp)
     26a:	00 
     26b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     272:	e8 f0 0c 00 00       	call   f67 <printf>
	    serve_drink(current_cup);
     277:	8b 45 e8             	mov    -0x18(%ebp),%eax
     27a:	89 04 24             	mov    %eax,(%esp)
     27d:	e8 d9 fd ff ff       	call   5b <serve_drink>
     282:	eb 72                	jmp    2f6 <bartender+0xd2>
	}
	else if(bartender_action->action_type == RETURN_CUP){
     284:	8b 45 ec             	mov    -0x14(%ebp),%eax
     287:	8b 00                	mov    (%eax),%eax
     289:	83 f8 02             	cmp    $0x2,%eax
     28c:	75 68                	jne    2f6 <bartender+0xd2>
	  struct Cup* current_cup = bartender_action->cup;  
     28e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     291:	8b 40 04             	mov    0x4(%eax),%eax
     294:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  return_cup(current_cup);
     297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     29a:	89 04 24             	mov    %eax,(%esp)
     29d:	e8 1b fe ff ff       	call   bd <return_cup>
	  //need to write to file intsead of screen TODO
	  printf(1,"Bartender %d returned cup %d\n",tid,current_cup->id);
     2a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2a5:	8b 00                	mov    (%eax),%eax
     2a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
     2ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2ae:	89 44 24 08          	mov    %eax,0x8(%esp)
     2b2:	c7 44 24 04 c2 17 00 	movl   $0x17c2,0x4(%esp)
     2b9:	00 
     2ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2c1:	e8 a1 0c 00 00       	call   f67 <printf>
	    
	  if(((DBB->count * 100) / DBB->buffer_size) >= 60){ //wakeup cup_boy
     2c6:	a1 e0 1e 00 00       	mov    0x1ee0,%eax
     2cb:	8b 40 10             	mov    0x10(%eax),%eax
     2ce:	6b c0 64             	imul   $0x64,%eax,%eax
     2d1:	8b 15 e0 1e 00 00    	mov    0x1ee0,%edx
     2d7:	8b 12                	mov    (%edx),%edx
     2d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     2dc:	89 c2                	mov    %eax,%edx
     2de:	c1 fa 1f             	sar    $0x1f,%edx
     2e1:	f7 7d d4             	idivl  -0x2c(%ebp)
     2e4:	83 f8 3b             	cmp    $0x3b,%eax
     2e7:	7e 0d                	jle    2f6 <bartender+0xd2>
	      binary_semaphore_up(cup_boy_lock);
     2e9:	a1 04 1f 00 00       	mov    0x1f04,%eax
     2ee:	89 04 24             	mov    %eax,(%esp)
     2f1:	e8 92 0b 00 00       	call   e88 <binary_semaphore_up>
	    }
	}
	if(bartender_action->action_type == GO_HOME){
     2f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2f9:	8b 00                	mov    (%eax),%eax
     2fb:	83 f8 03             	cmp    $0x3,%eax
     2fe:	75 0b                	jne    30b <bartender+0xe7>
	  thread_exit(ret_val);
     300:	8b 45 f4             	mov    -0xc(%ebp),%eax
     303:	89 04 24             	mov    %eax,(%esp)
     306:	e8 65 0b 00 00       	call   e70 <thread_exit>
	}
	free(bartender_action);
     30b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     30e:	89 04 24             	mov    %eax,(%esp)
     311:	e8 06 0e 00 00       	call   111c <free>
	//TODO remove
	//bartender_action->action_type = UNDEFINED;
	//bartender_action->cup = 0;
    }
     316:	e9 1e ff ff ff       	jmp    239 <bartender+0x15>

0000031b <cup_boy>:
    return ret_val;
}


// Cup boy simulation
void* cup_boy(){
     31b:	55                   	push   %ebp
     31c:	89 e5                	mov    %esp,%ebp
     31e:	83 ec 28             	sub    $0x28,%esp
  void* ret_val = 0;
     321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  cup_boy_lock = binary_semaphore_create(0);
     328:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     32f:	e8 44 0b 00 00       	call   e78 <binary_semaphore_create>
     334:	a3 04 1f 00 00       	mov    %eax,0x1f04
  for(;;){
    if(finished_shift){
     339:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
     33e:	85 c0                	test   %eax,%eax
     340:	74 0b                	je     34d <cup_boy+0x32>
	thread_exit(ret_val);
     342:	8b 45 f0             	mov    -0x10(%ebp),%eax
     345:	89 04 24             	mov    %eax,(%esp)
     348:	e8 23 0b 00 00       	call   e70 <thread_exit>
    }
    int n = BB_size(DBB);//TODO is it bad?
     34d:	a1 e0 1e 00 00       	mov    0x1ee0,%eax
     352:	89 04 24             	mov    %eax,(%esp)
     355:	e8 76 13 00 00       	call   16d0 <BB_size>
     35a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int i;
    
    for(i = 0; i < n; i++){
     35d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     364:	eb 40                	jmp    3a6 <cup_boy+0x8b>
	struct Cup* current_cup = wash_dirty();
     366:	e8 6e fd ff ff       	call   d9 <wash_dirty>
     36b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sleep(1);
     36e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     375:	e8 c6 0a 00 00       	call   e40 <sleep>
	add_clean_cup(current_cup);
     37a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     37d:	89 04 24             	mov    %eax,(%esp)
     380:	e8 1c fd ff ff       	call   a1 <add_clean_cup>
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
     385:	8b 45 e8             	mov    -0x18(%ebp),%eax
     388:	8b 00                	mov    (%eax),%eax
     38a:	89 44 24 08          	mov    %eax,0x8(%esp)
     38e:	c7 44 24 04 e0 17 00 	movl   $0x17e0,0x4(%esp)
     395:	00 
     396:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     39d:	e8 c5 0b 00 00       	call   f67 <printf>
	thread_exit(ret_val);
    }
    int n = BB_size(DBB);//TODO is it bad?
    int i;
    
    for(i = 0; i < n; i++){
     3a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     3a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     3ac:	7c b8                	jl     366 <cup_boy+0x4b>
	sleep(1);
	add_clean_cup(current_cup);
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
    }
   binary_semaphore_down(cup_boy_lock); 
     3ae:	a1 04 1f 00 00       	mov    0x1f04,%eax
     3b3:	89 04 24             	mov    %eax,(%esp)
     3b6:	e8 c5 0a 00 00       	call   e80 <binary_semaphore_down>
  }
     3bb:	e9 79 ff ff ff       	jmp    339 <cup_boy+0x1e>

000003c0 <join_peoples>:
  return 0;
}

// thread_joins on students and bartenders
void join_peoples(int* tids,int num_of_peoples){
     3c0:	55                   	push   %ebp
     3c1:	89 e5                	mov    %esp,%ebp
     3c3:	83 ec 28             	sub    $0x28,%esp
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     3c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3cd:	eb 1e                	jmp    3ed <join_peoples+0x2d>
      thread_join(tids[i],&ret_val);
     3cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d2:	c1 e0 02             	shl    $0x2,%eax
     3d5:	03 45 08             	add    0x8(%ebp),%eax
     3d8:	8b 00                	mov    (%eax),%eax
     3da:	8d 55 f0             	lea    -0x10(%ebp),%edx
     3dd:	89 54 24 04          	mov    %edx,0x4(%esp)
     3e1:	89 04 24             	mov    %eax,(%esp)
     3e4:	e8 7f 0a 00 00       	call   e68 <thread_join>

// thread_joins on students and bartenders
void join_peoples(int* tids,int num_of_peoples){
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     3e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     3ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
     3f3:	7c da                	jl     3cf <join_peoples+0xf>
      thread_join(tids[i],&ret_val);
  }
}
     3f5:	c9                   	leave  
     3f6:	c3                   	ret    

000003f7 <release_workers>:


//release the workers(bartenders + cup_boy) that run in infinite loops 
void release_workers(int num_of_bartenders){
     3f7:	55                   	push   %ebp
     3f8:	89 e5                	mov    %esp,%ebp
     3fa:	83 ec 28             	sub    $0x28,%esp
 int i;
 struct Action* release_bartender_action = 0;
     3fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 release_bartender_action->action_type = GO_HOME;
     404:	8b 45 f0             	mov    -0x10(%ebp),%eax
     407:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
 release_bartender_action->cup = 0;
     40d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     410:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 //release bartenders
 for(i = 0; i< num_of_bartenders; i++){
     417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     41e:	eb 0f                	jmp    42f <release_workers+0x38>
    place_action(release_bartender_action);
     420:	8b 45 f0             	mov    -0x10(%ebp),%eax
     423:	89 04 24             	mov    %eax,(%esp)
     426:	e8 ff fb ff ff       	call   2a <place_action>
 int i;
 struct Action* release_bartender_action = 0;
 release_bartender_action->action_type = GO_HOME;
 release_bartender_action->cup = 0;
 //release bartenders
 for(i = 0; i< num_of_bartenders; i++){
     42b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     42f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     432:	3b 45 08             	cmp    0x8(%ebp),%eax
     435:	7c e9                	jl     420 <release_workers+0x29>
    place_action(release_bartender_action);
 }
 //release cup_boy
 binary_semaphore_up(cup_boy_lock);
     437:	a1 04 1f 00 00       	mov    0x1f04,%eax
     43c:	89 04 24             	mov    %eax,(%esp)
     43f:	e8 44 0a 00 00       	call   e88 <binary_semaphore_up>
}
     444:	c9                   	leave  
     445:	c3                   	ret    

00000446 <values_array_index>:


//return the index to put the value {A, B, C, S, M}
//				     {0, 1, 2, 3, 4}
int values_array_index(char* input_buf, int char_index){
     446:	55                   	push   %ebp
     447:	89 e5                	mov    %esp,%ebp
 if(input_buf[char_index] == 'A')
     449:	8b 45 0c             	mov    0xc(%ebp),%eax
     44c:	03 45 08             	add    0x8(%ebp),%eax
     44f:	0f b6 00             	movzbl (%eax),%eax
     452:	3c 41                	cmp    $0x41,%al
     454:	75 07                	jne    45d <values_array_index+0x17>
   return 0;
     456:	b8 00 00 00 00       	mov    $0x0,%eax
     45b:	eb 55                	jmp    4b2 <values_array_index+0x6c>
 if(input_buf[char_index] == 'B')
     45d:	8b 45 0c             	mov    0xc(%ebp),%eax
     460:	03 45 08             	add    0x8(%ebp),%eax
     463:	0f b6 00             	movzbl (%eax),%eax
     466:	3c 42                	cmp    $0x42,%al
     468:	75 07                	jne    471 <values_array_index+0x2b>
   return 1;
     46a:	b8 01 00 00 00       	mov    $0x1,%eax
     46f:	eb 41                	jmp    4b2 <values_array_index+0x6c>
 if(input_buf[char_index] == 'C')
     471:	8b 45 0c             	mov    0xc(%ebp),%eax
     474:	03 45 08             	add    0x8(%ebp),%eax
     477:	0f b6 00             	movzbl (%eax),%eax
     47a:	3c 43                	cmp    $0x43,%al
     47c:	75 07                	jne    485 <values_array_index+0x3f>
   return 2;
     47e:	b8 02 00 00 00       	mov    $0x2,%eax
     483:	eb 2d                	jmp    4b2 <values_array_index+0x6c>
 if(input_buf[char_index] == 'S')
     485:	8b 45 0c             	mov    0xc(%ebp),%eax
     488:	03 45 08             	add    0x8(%ebp),%eax
     48b:	0f b6 00             	movzbl (%eax),%eax
     48e:	3c 53                	cmp    $0x53,%al
     490:	75 07                	jne    499 <values_array_index+0x53>
   return 3;
     492:	b8 03 00 00 00       	mov    $0x3,%eax
     497:	eb 19                	jmp    4b2 <values_array_index+0x6c>
 if(input_buf[char_index] == 'M')
     499:	8b 45 0c             	mov    0xc(%ebp),%eax
     49c:	03 45 08             	add    0x8(%ebp),%eax
     49f:	0f b6 00             	movzbl (%eax),%eax
     4a2:	3c 4d                	cmp    $0x4d,%al
     4a4:	75 07                	jne    4ad <values_array_index+0x67>
   return 4;
     4a6:	b8 04 00 00 00       	mov    $0x4,%eax
     4ab:	eb 05                	jmp    4b2 <values_array_index+0x6c>
 //error
 return -1;
     4ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     4b2:	5d                   	pop    %ebp
     4b3:	c3                   	ret    

000004b4 <parse_buffer>:

//parsing the configuration file
void parse_buffer(char* input_buf,int* values_array){
     4b4:	55                   	push   %ebp
     4b5:	89 e5                	mov    %esp,%ebp
     4b7:	53                   	push   %ebx
     4b8:	83 ec 24             	sub    $0x24,%esp
 int i;
 int num_of_chars = strlen(input_buf);
     4bb:	8b 45 08             	mov    0x8(%ebp),%eax
     4be:	89 04 24             	mov    %eax,(%esp)
     4c1:	e8 20 07 00 00       	call   be6 <strlen>
     4c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     4c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4d0:	eb 7e                	jmp    550 <parse_buffer+0x9c>
    if(input_buf[i] == 'A' || input_buf[i] == 'B' || input_buf[i] == 'C' || input_buf[i] == 'S' || input_buf[i] == 'M'){
     4d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d5:	03 45 08             	add    0x8(%ebp),%eax
     4d8:	0f b6 00             	movzbl (%eax),%eax
     4db:	3c 41                	cmp    $0x41,%al
     4dd:	74 34                	je     513 <parse_buffer+0x5f>
     4df:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e2:	03 45 08             	add    0x8(%ebp),%eax
     4e5:	0f b6 00             	movzbl (%eax),%eax
     4e8:	3c 42                	cmp    $0x42,%al
     4ea:	74 27                	je     513 <parse_buffer+0x5f>
     4ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ef:	03 45 08             	add    0x8(%ebp),%eax
     4f2:	0f b6 00             	movzbl (%eax),%eax
     4f5:	3c 43                	cmp    $0x43,%al
     4f7:	74 1a                	je     513 <parse_buffer+0x5f>
     4f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fc:	03 45 08             	add    0x8(%ebp),%eax
     4ff:	0f b6 00             	movzbl (%eax),%eax
     502:	3c 53                	cmp    $0x53,%al
     504:	74 0d                	je     513 <parse_buffer+0x5f>
     506:	8b 45 f4             	mov    -0xc(%ebp),%eax
     509:	03 45 08             	add    0x8(%ebp),%eax
     50c:	0f b6 00             	movzbl (%eax),%eax
     50f:	3c 4d                	cmp    $0x4d,%al
     511:	75 39                	jne    54c <parse_buffer+0x98>
       index = values_array_index(input_buf,i);
     513:	8b 45 f4             	mov    -0xc(%ebp),%eax
     516:	89 44 24 04          	mov    %eax,0x4(%esp)
     51a:	8b 45 08             	mov    0x8(%ebp),%eax
     51d:	89 04 24             	mov    %eax,(%esp)
     520:	e8 21 ff ff ff       	call   446 <values_array_index>
     525:	89 45 ec             	mov    %eax,-0x14(%ebp)
       temp_str = &input_buf[i];
     528:	8b 45 f4             	mov    -0xc(%ebp),%eax
     52b:	03 45 08             	add    0x8(%ebp),%eax
     52e:	89 45 e8             	mov    %eax,-0x18(%ebp)
       values_array[index] = atoi(temp_str+4);
     531:	8b 45 ec             	mov    -0x14(%ebp),%eax
     534:	c1 e0 02             	shl    $0x2,%eax
     537:	89 c3                	mov    %eax,%ebx
     539:	03 5d 0c             	add    0xc(%ebp),%ebx
     53c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     53f:	83 c0 04             	add    $0x4,%eax
     542:	89 04 24             	mov    %eax,(%esp)
     545:	e8 d5 07 00 00       	call   d1f <atoi>
     54a:	89 03                	mov    %eax,(%ebx)
void parse_buffer(char* input_buf,int* values_array){
 int i;
 int num_of_chars = strlen(input_buf);
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     54c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     550:	8b 45 f4             	mov    -0xc(%ebp),%eax
     553:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     556:	0f 8c 76 ff ff ff    	jl     4d2 <parse_buffer+0x1e>
       index = values_array_index(input_buf,i);
       temp_str = &input_buf[i];
       values_array[index] = atoi(temp_str+4);
    }
 }
}
     55c:	83 c4 24             	add    $0x24,%esp
     55f:	5b                   	pop    %ebx
     560:	5d                   	pop    %ebp
     561:	c3                   	ret    

00000562 <main>:


int main(int argc, char** argv) {
     562:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     566:	83 e4 f0             	and    $0xfffffff0,%esp
     569:	ff 71 fc             	pushl  -0x4(%ecx)
     56c:	55                   	push   %ebp
     56d:	89 e5                	mov    %esp,%ebp
     56f:	51                   	push   %ecx
     570:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  int M;	// maximum number of students that can be at the bar at once
  int fconf;
  int conf_size;
  struct stat bufstat;
  
  fconf = open("con.conf",O_RDONLY);
     576:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     57d:	00 
     57e:	c7 04 24 fc 17 00 00 	movl   $0x17fc,(%esp)
     585:	e8 66 08 00 00       	call   df0 <open>
     58a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  fstat(fconf,&bufstat);
     58d:	8d 45 8c             	lea    -0x74(%ebp),%eax
     590:	89 44 24 04          	mov    %eax,0x4(%esp)
     594:	8b 45 f0             	mov    -0x10(%ebp),%eax
     597:	89 04 24             	mov    %eax,(%esp)
     59a:	e8 69 08 00 00       	call   e08 <fstat>
  conf_size = bufstat.size;
     59f:	8b 45 9c             	mov    -0x64(%ebp),%eax
     5a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  char bufconf[conf_size];
     5a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5a8:	8d 50 ff             	lea    -0x1(%eax),%edx
     5ab:	89 55 e8             	mov    %edx,-0x18(%ebp)
     5ae:	8d 50 0f             	lea    0xf(%eax),%edx
     5b1:	b8 10 00 00 00       	mov    $0x10,%eax
     5b6:	83 e8 01             	sub    $0x1,%eax
     5b9:	01 d0                	add    %edx,%eax
     5bb:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     5c2:	00 00 00 
     5c5:	ba 00 00 00 00       	mov    $0x0,%edx
     5ca:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     5d0:	6b c0 10             	imul   $0x10,%eax,%eax
     5d3:	29 c4                	sub    %eax,%esp
     5d5:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     5d9:	83 c0 0f             	add    $0xf,%eax
     5dc:	c1 e8 04             	shr    $0x4,%eax
     5df:	c1 e0 04             	shl    $0x4,%eax
     5e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  read(fconf,bufconf,conf_size);
     5e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
     5eb:	89 54 24 08          	mov    %edx,0x8(%esp)
     5ef:	89 44 24 04          	mov    %eax,0x4(%esp)
     5f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5f6:	89 04 24             	mov    %eax,(%esp)
     5f9:	e8 ca 07 00 00       	call   dc8 <read>
  int inputs_parsed[5]; //{Aval, Bval, Cval, Sval, Mval}
  
  parse_buffer(bufconf, inputs_parsed);
     5fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     601:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
     607:	89 54 24 04          	mov    %edx,0x4(%esp)
     60b:	89 04 24             	mov    %eax,(%esp)
     60e:	e8 a1 fe ff ff       	call   4b4 <parse_buffer>
  A = inputs_parsed[0];
     613:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
     619:	89 45 e0             	mov    %eax,-0x20(%ebp)
  B = inputs_parsed[1];
     61c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
     622:	89 45 dc             	mov    %eax,-0x24(%ebp)
  C = inputs_parsed[2];
     625:	8b 45 80             	mov    -0x80(%ebp),%eax
     628:	89 45 d8             	mov    %eax,-0x28(%ebp)
  S = inputs_parsed[3];
     62b:	8b 45 84             	mov    -0x7c(%ebp),%eax
     62e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  M = inputs_parsed[4];
     631:	8b 45 88             	mov    -0x78(%ebp),%eax
     634:	89 45 d0             	mov    %eax,-0x30(%ebp)
  
  printf(1,"A: %d B: %d C: %d  S: %d M: %d\n",A,B,C,S,M);
     637:	8b 45 d0             	mov    -0x30(%ebp),%eax
     63a:	89 44 24 18          	mov    %eax,0x18(%esp)
     63e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     641:	89 44 24 14          	mov    %eax,0x14(%esp)
     645:	8b 45 d8             	mov    -0x28(%ebp),%eax
     648:	89 44 24 10          	mov    %eax,0x10(%esp)
     64c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     64f:	89 44 24 0c          	mov    %eax,0xc(%esp)
     653:	8b 45 e0             	mov    -0x20(%ebp),%eax
     656:	89 44 24 08          	mov    %eax,0x8(%esp)
     65a:	c7 44 24 04 08 18 00 	movl   $0x1808,0x4(%esp)
     661:	00 
     662:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     669:	e8 f9 08 00 00       	call   f67 <printf>
  
  void* students_stacks[S];
     66e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     671:	8d 50 ff             	lea    -0x1(%eax),%edx
     674:	89 55 cc             	mov    %edx,-0x34(%ebp)
     677:	c1 e0 02             	shl    $0x2,%eax
     67a:	8d 50 0f             	lea    0xf(%eax),%edx
     67d:	b8 10 00 00 00       	mov    $0x10,%eax
     682:	83 e8 01             	sub    $0x1,%eax
     685:	01 d0                	add    %edx,%eax
     687:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     68e:	00 00 00 
     691:	ba 00 00 00 00       	mov    $0x0,%edx
     696:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     69c:	6b c0 10             	imul   $0x10,%eax,%eax
     69f:	29 c4                	sub    %eax,%esp
     6a1:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     6a5:	83 c0 0f             	add    $0xf,%eax
     6a8:	c1 e8 04             	shr    $0x4,%eax
     6ab:	c1 e0 04             	shl    $0x4,%eax
     6ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
  void* bartenders_stacks[B];
     6b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
     6b4:	8d 50 ff             	lea    -0x1(%eax),%edx
     6b7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
     6ba:	c1 e0 02             	shl    $0x2,%eax
     6bd:	8d 50 0f             	lea    0xf(%eax),%edx
     6c0:	b8 10 00 00 00       	mov    $0x10,%eax
     6c5:	83 e8 01             	sub    $0x1,%eax
     6c8:	01 d0                	add    %edx,%eax
     6ca:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     6d1:	00 00 00 
     6d4:	ba 00 00 00 00       	mov    $0x0,%edx
     6d9:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     6df:	6b c0 10             	imul   $0x10,%eax,%eax
     6e2:	29 c4                	sub    %eax,%esp
     6e4:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     6e8:	83 c0 0f             	add    $0xf,%eax
     6eb:	c1 e8 04             	shr    $0x4,%eax
     6ee:	c1 e0 04             	shl    $0x4,%eax
     6f1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  void* cup_boy_stack;
  int i;
  int student_tids[S];
     6f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     6f7:	8d 50 ff             	lea    -0x1(%eax),%edx
     6fa:	89 55 bc             	mov    %edx,-0x44(%ebp)
     6fd:	c1 e0 02             	shl    $0x2,%eax
     700:	8d 50 0f             	lea    0xf(%eax),%edx
     703:	b8 10 00 00 00       	mov    $0x10,%eax
     708:	83 e8 01             	sub    $0x1,%eax
     70b:	01 d0                	add    %edx,%eax
     70d:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     714:	00 00 00 
     717:	ba 00 00 00 00       	mov    $0x0,%edx
     71c:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     722:	6b c0 10             	imul   $0x10,%eax,%eax
     725:	29 c4                	sub    %eax,%esp
     727:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     72b:	83 c0 0f             	add    $0xf,%eax
     72e:	c1 e8 04             	shr    $0x4,%eax
     731:	c1 e0 04             	shl    $0x4,%eax
     734:	89 45 b8             	mov    %eax,-0x48(%ebp)
  int bartender_tids[B];
     737:	8b 45 dc             	mov    -0x24(%ebp),%eax
     73a:	8d 50 ff             	lea    -0x1(%eax),%edx
     73d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
     740:	c1 e0 02             	shl    $0x2,%eax
     743:	8d 50 0f             	lea    0xf(%eax),%edx
     746:	b8 10 00 00 00       	mov    $0x10,%eax
     74b:	83 e8 01             	sub    $0x1,%eax
     74e:	01 d0                	add    %edx,%eax
     750:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     757:	00 00 00 
     75a:	ba 00 00 00 00       	mov    $0x0,%edx
     75f:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     765:	6b c0 10             	imul   $0x10,%eax,%eax
     768:	29 c4                	sub    %eax,%esp
     76a:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     76e:	83 c0 0f             	add    $0xf,%eax
     771:	c1 e8 04             	shr    $0x4,%eax
     774:	c1 e0 04             	shl    $0x4,%eax
     777:	89 45 b0             	mov    %eax,-0x50(%ebp)
  int finished_shift = 0; // cup_boy changes it to 1 if all students left the bar and sends Action => GO_HOME to bartenders
     77a:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)

  
  file_to_write = open("out.txt",(O_CREATE | O_WRONLY)); //
     781:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     788:	00 
     789:	c7 04 24 28 18 00 00 	movl   $0x1828,(%esp)
     790:	e8 5b 06 00 00       	call   df0 <open>
     795:	a3 e8 1e 00 00       	mov    %eax,0x1ee8
  if(file_to_write == -1){
     79a:	a1 e8 1e 00 00       	mov    0x1ee8,%eax
     79f:	83 f8 ff             	cmp    $0xffffffff,%eax
     7a2:	75 19                	jne    7bd <main+0x25b>
      printf(1,"There was an error opening out.txt\n");
     7a4:	c7 44 24 04 30 18 00 	movl   $0x1830,0x4(%esp)
     7ab:	00 
     7ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7b3:	e8 af 07 00 00       	call   f67 <printf>
      exit();
     7b8:	e8 f3 05 00 00       	call   db0 <exit>
  }
  
  
  //Databases
   bouncer = semaphore_create(M);		//this is the bouncer to the Beinstein
     7bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
     7c0:	89 04 24             	mov    %eax,(%esp)
     7c3:	e8 64 0b 00 00       	call   132c <semaphore_create>
     7c8:	a3 d4 1e 00 00       	mov    %eax,0x1ed4
   ABB = BB_create(A); 				//this is a BB for student actions: drink, ans for a dring
     7cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7d0:	89 04 24             	mov    %eax,(%esp)
     7d3:	e8 ac 0c 00 00       	call   1484 <BB_create>
     7d8:	a3 dc 1e 00 00       	mov    %eax,0x1edc
   DrinkBB = BB_create(A);			//this is a BB holding the drinks that are ready to be drinking
     7dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7e0:	89 04 24             	mov    %eax,(%esp)
     7e3:	e8 9c 0c 00 00       	call   1484 <BB_create>
     7e8:	a3 ec 1e 00 00       	mov    %eax,0x1eec
   CBB = BB_create(C);				//this is a BB hold clean cups
     7ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
     7f0:	89 04 24             	mov    %eax,(%esp)
     7f3:	e8 8c 0c 00 00       	call   1484 <BB_create>
     7f8:	a3 08 1f 00 00       	mov    %eax,0x1f08
   DBB = BB_create(C);				//this is a BB hold dirty cups
     7fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
     800:	89 04 24             	mov    %eax,(%esp)
     803:	e8 7c 0c 00 00       	call   1484 <BB_create>
     808:	a3 e0 1e 00 00       	mov    %eax,0x1ee0
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
     80d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     814:	e8 5f 06 00 00       	call   e78 <binary_semaphore_create>
     819:	a3 04 1f 00 00       	mov    %eax,0x1f04
   general_mutex = binary_semaphore_create(1);
     81e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     825:	e8 4e 06 00 00       	call   e78 <binary_semaphore_create>
     82a:	a3 e4 1e 00 00       	mov    %eax,0x1ee4

   //initialize C clean cups
   struct Cup* cup_array[C];
     82f:	8b 45 d8             	mov    -0x28(%ebp),%eax
     832:	8d 50 ff             	lea    -0x1(%eax),%edx
     835:	89 55 a8             	mov    %edx,-0x58(%ebp)
     838:	c1 e0 02             	shl    $0x2,%eax
     83b:	8d 50 0f             	lea    0xf(%eax),%edx
     83e:	b8 10 00 00 00       	mov    $0x10,%eax
     843:	83 e8 01             	sub    $0x1,%eax
     846:	01 d0                	add    %edx,%eax
     848:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     84f:	00 00 00 
     852:	ba 00 00 00 00       	mov    $0x0,%edx
     857:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     85d:	6b c0 10             	imul   $0x10,%eax,%eax
     860:	29 c4                	sub    %eax,%esp
     862:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     866:	83 c0 0f             	add    $0xf,%eax
     869:	c1 e8 04             	shr    $0x4,%eax
     86c:	c1 e0 04             	shl    $0x4,%eax
     86f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
   for(i = 0; i < C; i++){
     872:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     879:	eb 38                	jmp    8b3 <main+0x351>
      cup_array[i] = malloc(sizeof(struct Cup)); //TODO free cups
     87b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     882:	e8 c4 09 00 00       	call   124b <malloc>
     887:	8b 55 a4             	mov    -0x5c(%ebp),%edx
     88a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     88d:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      cup_array[i]->id = i;
     890:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     893:	8b 55 f4             	mov    -0xc(%ebp),%edx
     896:	8b 04 90             	mov    (%eax,%edx,4),%eax
     899:	8b 55 f4             	mov    -0xc(%ebp),%edx
     89c:	89 10                	mov    %edx,(%eax)
      add_clean_cup(cup_array[i]);
     89e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     8a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8a4:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8a7:	89 04 24             	mov    %eax,(%esp)
     8aa:	e8 f2 f7 ff ff       	call   a1 <add_clean_cup>
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
   general_mutex = binary_semaphore_create(1);

   //initialize C clean cups
   struct Cup* cup_array[C];
   for(i = 0; i < C; i++){
     8af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     8b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8b6:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     8b9:	7c c0                	jl     87b <main+0x319>
      cup_array[i]->id = i;
      add_clean_cup(cup_array[i]);
   }
   
   //initialize cup_boy
   cup_boy_stack = (void*)malloc(sizeof(void*)*STACK_SIZE);
     8bb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     8c2:	e8 84 09 00 00       	call   124b <malloc>
     8c7:	89 45 a0             	mov    %eax,-0x60(%ebp)
    memset(cup_boy_stack,0,sizeof(void*)*1024);
     8ca:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     8d1:	00 
     8d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     8d9:	00 
     8da:	8b 45 a0             	mov    -0x60(%ebp),%eax
     8dd:	89 04 24             	mov    %eax,(%esp)
     8e0:	e8 26 03 00 00       	call   c0b <memset>
   if(thread_create((void*)cup_boy,cup_boy_stack,sizeof(void*)*1024) < 0){
     8e5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     8ec:	00 
     8ed:	8b 45 a0             	mov    -0x60(%ebp),%eax
     8f0:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f4:	c7 04 24 1b 03 00 00 	movl   $0x31b,(%esp)
     8fb:	e8 50 05 00 00       	call   e50 <thread_create>
     900:	85 c0                	test   %eax,%eax
     902:	79 19                	jns    91d <main+0x3bb>
     printf(2,"Failed to create cupboy thread. Exiting...\n");
     904:	c7 44 24 04 54 18 00 	movl   $0x1854,0x4(%esp)
     90b:	00 
     90c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     913:	e8 4f 06 00 00       	call   f67 <printf>
    exit();
     918:	e8 93 04 00 00       	call   db0 <exit>
   }
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     91d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     924:	eb 64                	jmp    98a <main+0x428>
      bartenders_stacks[i] = (void*)malloc(sizeof(void*)*STACK_SIZE);
     926:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     92d:	e8 19 09 00 00       	call   124b <malloc>
     932:	8b 55 c0             	mov    -0x40(%ebp),%edx
     935:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     938:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(bartenders_stacks[i],0,sizeof(void*)*1024);
     93b:	8b 45 c0             	mov    -0x40(%ebp),%eax
     93e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     941:	8b 04 90             	mov    (%eax,%edx,4),%eax
     944:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     94b:	00 
     94c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     953:	00 
     954:	89 04 24             	mov    %eax,(%esp)
     957:	e8 af 02 00 00       	call   c0b <memset>
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
     95c:	8b 45 c0             	mov    -0x40(%ebp),%eax
     95f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     962:	8b 04 90             	mov    (%eax,%edx,4),%eax
     965:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     96c:	00 
     96d:	89 44 24 04          	mov    %eax,0x4(%esp)
     971:	c7 04 24 24 02 00 00 	movl   $0x224,(%esp)
     978:	e8 d3 04 00 00       	call   e50 <thread_create>
     97d:	8b 55 b0             	mov    -0x50(%ebp),%edx
     980:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     983:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     printf(2,"Failed to create cupboy thread. Exiting...\n");
    exit();
   }
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     986:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     98d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     990:	7c 94                	jl     926 <main+0x3c4>
      memset(bartenders_stacks[i],0,sizeof(void*)*1024);
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
  }
   
   //initialize S students
   for(i = 0; i < S; i++){//TODO test for fail
     992:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     999:	eb 64                	jmp    9ff <main+0x49d>
      students_stacks[i] = malloc(sizeof(void*)*STACK_SIZE);
     99b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     9a2:	e8 a4 08 00 00       	call   124b <malloc>
     9a7:	8b 55 c8             	mov    -0x38(%ebp),%edx
     9aa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     9ad:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
     9b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
     9b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9b6:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9b9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     9c0:	00 
     9c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     9c8:	00 
     9c9:	89 04 24             	mov    %eax,(%esp)
     9cc:	e8 3a 02 00 00       	call   c0b <memset>
      student_tids[i] = thread_create((void*)student,students_stacks[i],sizeof(void*)*STACK_SIZE);
     9d1:	8b 45 c8             	mov    -0x38(%ebp),%eax
     9d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9d7:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9da:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     9e1:	00 
     9e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e6:	c7 04 24 ee 00 00 00 	movl   $0xee,(%esp)
     9ed:	e8 5e 04 00 00       	call   e50 <thread_create>
     9f2:	8b 55 b8             	mov    -0x48(%ebp),%edx
     9f5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     9f8:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(bartenders_stacks[i],0,sizeof(void*)*1024);
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
  }
   
   //initialize S students
   for(i = 0; i < S; i++){//TODO test for fail
     9fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a02:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     a05:	7c 94                	jl     99b <main+0x439>
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
      student_tids[i] = thread_create((void*)student,students_stacks[i],sizeof(void*)*STACK_SIZE);
  }
  
   
   join_peoples(student_tids,S); //join students
     a07:	8b 45 b8             	mov    -0x48(%ebp),%eax
     a0a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     a0d:	89 54 24 04          	mov    %edx,0x4(%esp)
     a11:	89 04 24             	mov    %eax,(%esp)
     a14:	e8 a7 f9 ff ff       	call   3c0 <join_peoples>
   finished_shift = 1;
     a19:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
   if(finished_shift){
     a20:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
     a24:	74 0d                	je     a33 <main+0x4d1>
    binary_semaphore_up(cup_boy_lock); 
     a26:	a1 04 1f 00 00       	mov    0x1f04,%eax
     a2b:	89 04 24             	mov    %eax,(%esp)
     a2e:	e8 55 04 00 00       	call   e88 <binary_semaphore_up>
   }
   release_workers(B);
     a33:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a36:	89 04 24             	mov    %eax,(%esp)
     a39:	e8 b9 f9 ff ff       	call   3f7 <release_workers>
   join_peoples(bartender_tids,B); //join bartenders
     a3e:	8b 45 b0             	mov    -0x50(%ebp),%eax
     a41:	8b 55 dc             	mov    -0x24(%ebp),%edx
     a44:	89 54 24 04          	mov    %edx,0x4(%esp)
     a48:	89 04 24             	mov    %eax,(%esp)
     a4b:	e8 70 f9 ff ff       	call   3c0 <join_peoples>
   sleep(2); // delay so exit will not come before threads finished TODO (need better soloution)
     a50:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     a57:	e8 e4 03 00 00       	call   e40 <sleep>
   
   if(close(file_to_write) == -1){
     a5c:	a1 e8 1e 00 00       	mov    0x1ee8,%eax
     a61:	89 04 24             	mov    %eax,(%esp)
     a64:	e8 6f 03 00 00       	call   dd8 <close>
     a69:	83 f8 ff             	cmp    $0xffffffff,%eax
     a6c:	75 19                	jne    a87 <main+0x525>
    printf(1,"There was an error closing out.txt\n");
     a6e:	c7 44 24 04 80 18 00 	movl   $0x1880,0x4(%esp)
     a75:	00 
     a76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a7d:	e8 e5 04 00 00       	call   f67 <printf>
    exit();
     a82:	e8 29 03 00 00       	call   db0 <exit>
   }
   
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     a87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a8e:	eb 15                	jmp    aa5 <main+0x543>
    free(cup_array[i]);
     a90:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     a93:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a96:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a99:	89 04 24             	mov    %eax,(%esp)
     a9c:	e8 7b 06 00 00       	call   111c <free>
    exit();
   }
   
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     aa1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aa8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     aab:	7c e3                	jl     a90 <main+0x52e>
    free(cup_array[i]);
  }
  
  //free cup_boy_stack
  free(cup_boy_stack);
     aad:	8b 45 a0             	mov    -0x60(%ebp),%eax
     ab0:	89 04 24             	mov    %eax,(%esp)
     ab3:	e8 64 06 00 00       	call   111c <free>
  
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     ab8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     abf:	eb 15                	jmp    ad6 <main+0x574>
   free(bartenders_stacks[i]); 
     ac1:	8b 45 c0             	mov    -0x40(%ebp),%eax
     ac4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ac7:	8b 04 90             	mov    (%eax,%edx,4),%eax
     aca:	89 04 24             	mov    %eax,(%esp)
     acd:	e8 4a 06 00 00       	call   111c <free>
  
  //free cup_boy_stack
  free(cup_boy_stack);
  
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     ad2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     adc:	7c e3                	jl     ac1 <main+0x55f>
   free(bartenders_stacks[i]); 
  }
  
  //free students_stacks
  for(i = 0; i < S; i++){
     ade:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ae5:	eb 15                	jmp    afc <main+0x59a>
   free(students_stacks[i]); 
     ae7:	8b 45 c8             	mov    -0x38(%ebp),%eax
     aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
     aed:	8b 04 90             	mov    (%eax,%edx,4),%eax
     af0:	89 04 24             	mov    %eax,(%esp)
     af3:	e8 24 06 00 00       	call   111c <free>
  for(i = 0; i < B; i++){
   free(bartenders_stacks[i]); 
  }
  
  //free students_stacks
  for(i = 0; i < S; i++){
     af8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aff:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     b02:	7c e3                	jl     ae7 <main+0x585>
   free(students_stacks[i]); 
  }
  
  semaphore_free(bouncer);
     b04:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
     b09:	89 04 24             	mov    %eax,(%esp)
     b0c:	e8 5f 09 00 00       	call   1470 <semaphore_free>
  BB_free(ABB);
     b11:	a1 dc 1e 00 00       	mov    0x1edc,%eax
     b16:	89 04 24             	mov    %eax,(%esp)
     b19:	e8 91 0b 00 00       	call   16af <BB_free>
  BB_free(DrinkBB);
     b1e:	a1 ec 1e 00 00       	mov    0x1eec,%eax
     b23:	89 04 24             	mov    %eax,(%esp)
     b26:	e8 84 0b 00 00       	call   16af <BB_free>
  BB_free(CBB);
     b2b:	a1 08 1f 00 00       	mov    0x1f08,%eax
     b30:	89 04 24             	mov    %eax,(%esp)
     b33:	e8 77 0b 00 00       	call   16af <BB_free>
  BB_free(DBB);
     b38:	a1 e0 1e 00 00       	mov    0x1ee0,%eax
     b3d:	89 04 24             	mov    %eax,(%esp)
     b40:	e8 6a 0b 00 00       	call   16af <BB_free>
 
  exit();
     b45:	e8 66 02 00 00       	call   db0 <exit>
     b4a:	90                   	nop
     b4b:	90                   	nop

00000b4c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     b4c:	55                   	push   %ebp
     b4d:	89 e5                	mov    %esp,%ebp
     b4f:	57                   	push   %edi
     b50:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     b51:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b54:	8b 55 10             	mov    0x10(%ebp),%edx
     b57:	8b 45 0c             	mov    0xc(%ebp),%eax
     b5a:	89 cb                	mov    %ecx,%ebx
     b5c:	89 df                	mov    %ebx,%edi
     b5e:	89 d1                	mov    %edx,%ecx
     b60:	fc                   	cld    
     b61:	f3 aa                	rep stos %al,%es:(%edi)
     b63:	89 ca                	mov    %ecx,%edx
     b65:	89 fb                	mov    %edi,%ebx
     b67:	89 5d 08             	mov    %ebx,0x8(%ebp)
     b6a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     b6d:	5b                   	pop    %ebx
     b6e:	5f                   	pop    %edi
     b6f:	5d                   	pop    %ebp
     b70:	c3                   	ret    

00000b71 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     b71:	55                   	push   %ebp
     b72:	89 e5                	mov    %esp,%ebp
     b74:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     b77:	8b 45 08             	mov    0x8(%ebp),%eax
     b7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     b7d:	90                   	nop
     b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
     b81:	0f b6 10             	movzbl (%eax),%edx
     b84:	8b 45 08             	mov    0x8(%ebp),%eax
     b87:	88 10                	mov    %dl,(%eax)
     b89:	8b 45 08             	mov    0x8(%ebp),%eax
     b8c:	0f b6 00             	movzbl (%eax),%eax
     b8f:	84 c0                	test   %al,%al
     b91:	0f 95 c0             	setne  %al
     b94:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b98:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     b9c:	84 c0                	test   %al,%al
     b9e:	75 de                	jne    b7e <strcpy+0xd>
    ;
  return os;
     ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     ba3:	c9                   	leave  
     ba4:	c3                   	ret    

00000ba5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba5:	55                   	push   %ebp
     ba6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     ba8:	eb 08                	jmp    bb2 <strcmp+0xd>
    p++, q++;
     baa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     bae:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     bb2:	8b 45 08             	mov    0x8(%ebp),%eax
     bb5:	0f b6 00             	movzbl (%eax),%eax
     bb8:	84 c0                	test   %al,%al
     bba:	74 10                	je     bcc <strcmp+0x27>
     bbc:	8b 45 08             	mov    0x8(%ebp),%eax
     bbf:	0f b6 10             	movzbl (%eax),%edx
     bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
     bc5:	0f b6 00             	movzbl (%eax),%eax
     bc8:	38 c2                	cmp    %al,%dl
     bca:	74 de                	je     baa <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     bcc:	8b 45 08             	mov    0x8(%ebp),%eax
     bcf:	0f b6 00             	movzbl (%eax),%eax
     bd2:	0f b6 d0             	movzbl %al,%edx
     bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd8:	0f b6 00             	movzbl (%eax),%eax
     bdb:	0f b6 c0             	movzbl %al,%eax
     bde:	89 d1                	mov    %edx,%ecx
     be0:	29 c1                	sub    %eax,%ecx
     be2:	89 c8                	mov    %ecx,%eax
}
     be4:	5d                   	pop    %ebp
     be5:	c3                   	ret    

00000be6 <strlen>:

uint
strlen(char *s)
{
     be6:	55                   	push   %ebp
     be7:	89 e5                	mov    %esp,%ebp
     be9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     bec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     bf3:	eb 04                	jmp    bf9 <strlen+0x13>
     bf5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     bf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bfc:	03 45 08             	add    0x8(%ebp),%eax
     bff:	0f b6 00             	movzbl (%eax),%eax
     c02:	84 c0                	test   %al,%al
     c04:	75 ef                	jne    bf5 <strlen+0xf>
    ;
  return n;
     c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     c09:	c9                   	leave  
     c0a:	c3                   	ret    

00000c0b <memset>:

void*
memset(void *dst, int c, uint n)
{
     c0b:	55                   	push   %ebp
     c0c:	89 e5                	mov    %esp,%ebp
     c0e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     c11:	8b 45 10             	mov    0x10(%ebp),%eax
     c14:	89 44 24 08          	mov    %eax,0x8(%esp)
     c18:	8b 45 0c             	mov    0xc(%ebp),%eax
     c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
     c1f:	8b 45 08             	mov    0x8(%ebp),%eax
     c22:	89 04 24             	mov    %eax,(%esp)
     c25:	e8 22 ff ff ff       	call   b4c <stosb>
  return dst;
     c2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c2d:	c9                   	leave  
     c2e:	c3                   	ret    

00000c2f <strchr>:

char*
strchr(const char *s, char c)
{
     c2f:	55                   	push   %ebp
     c30:	89 e5                	mov    %esp,%ebp
     c32:	83 ec 04             	sub    $0x4,%esp
     c35:	8b 45 0c             	mov    0xc(%ebp),%eax
     c38:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     c3b:	eb 14                	jmp    c51 <strchr+0x22>
    if(*s == c)
     c3d:	8b 45 08             	mov    0x8(%ebp),%eax
     c40:	0f b6 00             	movzbl (%eax),%eax
     c43:	3a 45 fc             	cmp    -0x4(%ebp),%al
     c46:	75 05                	jne    c4d <strchr+0x1e>
      return (char*)s;
     c48:	8b 45 08             	mov    0x8(%ebp),%eax
     c4b:	eb 13                	jmp    c60 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     c4d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     c51:	8b 45 08             	mov    0x8(%ebp),%eax
     c54:	0f b6 00             	movzbl (%eax),%eax
     c57:	84 c0                	test   %al,%al
     c59:	75 e2                	jne    c3d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c60:	c9                   	leave  
     c61:	c3                   	ret    

00000c62 <gets>:

char*
gets(char *buf, int max)
{
     c62:	55                   	push   %ebp
     c63:	89 e5                	mov    %esp,%ebp
     c65:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c6f:	eb 44                	jmp    cb5 <gets+0x53>
    cc = read(0, &c, 1);
     c71:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c78:	00 
     c79:	8d 45 ef             	lea    -0x11(%ebp),%eax
     c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
     c80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c87:	e8 3c 01 00 00       	call   dc8 <read>
     c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c93:	7e 2d                	jle    cc2 <gets+0x60>
      break;
    buf[i++] = c;
     c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c98:	03 45 08             	add    0x8(%ebp),%eax
     c9b:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     c9f:	88 10                	mov    %dl,(%eax)
     ca1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     ca5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     ca9:	3c 0a                	cmp    $0xa,%al
     cab:	74 16                	je     cc3 <gets+0x61>
     cad:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     cb1:	3c 0d                	cmp    $0xd,%al
     cb3:	74 0e                	je     cc3 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cb8:	83 c0 01             	add    $0x1,%eax
     cbb:	3b 45 0c             	cmp    0xc(%ebp),%eax
     cbe:	7c b1                	jl     c71 <gets+0xf>
     cc0:	eb 01                	jmp    cc3 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     cc2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc6:	03 45 08             	add    0x8(%ebp),%eax
     cc9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     ccc:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ccf:	c9                   	leave  
     cd0:	c3                   	ret    

00000cd1 <stat>:

int
stat(char *n, struct stat *st)
{
     cd1:	55                   	push   %ebp
     cd2:	89 e5                	mov    %esp,%ebp
     cd4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cd7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     cde:	00 
     cdf:	8b 45 08             	mov    0x8(%ebp),%eax
     ce2:	89 04 24             	mov    %eax,(%esp)
     ce5:	e8 06 01 00 00       	call   df0 <open>
     cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     cf1:	79 07                	jns    cfa <stat+0x29>
    return -1;
     cf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cf8:	eb 23                	jmp    d1d <stat+0x4c>
  r = fstat(fd, st);
     cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
     cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
     d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d04:	89 04 24             	mov    %eax,(%esp)
     d07:	e8 fc 00 00 00       	call   e08 <fstat>
     d0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d12:	89 04 24             	mov    %eax,(%esp)
     d15:	e8 be 00 00 00       	call   dd8 <close>
  return r;
     d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     d1d:	c9                   	leave  
     d1e:	c3                   	ret    

00000d1f <atoi>:

int
atoi(const char *s)
{
     d1f:	55                   	push   %ebp
     d20:	89 e5                	mov    %esp,%ebp
     d22:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     d25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     d2c:	eb 23                	jmp    d51 <atoi+0x32>
    n = n*10 + *s++ - '0';
     d2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d31:	89 d0                	mov    %edx,%eax
     d33:	c1 e0 02             	shl    $0x2,%eax
     d36:	01 d0                	add    %edx,%eax
     d38:	01 c0                	add    %eax,%eax
     d3a:	89 c2                	mov    %eax,%edx
     d3c:	8b 45 08             	mov    0x8(%ebp),%eax
     d3f:	0f b6 00             	movzbl (%eax),%eax
     d42:	0f be c0             	movsbl %al,%eax
     d45:	01 d0                	add    %edx,%eax
     d47:	83 e8 30             	sub    $0x30,%eax
     d4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
     d4d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d51:	8b 45 08             	mov    0x8(%ebp),%eax
     d54:	0f b6 00             	movzbl (%eax),%eax
     d57:	3c 2f                	cmp    $0x2f,%al
     d59:	7e 0a                	jle    d65 <atoi+0x46>
     d5b:	8b 45 08             	mov    0x8(%ebp),%eax
     d5e:	0f b6 00             	movzbl (%eax),%eax
     d61:	3c 39                	cmp    $0x39,%al
     d63:	7e c9                	jle    d2e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d68:	c9                   	leave  
     d69:	c3                   	ret    

00000d6a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d6a:	55                   	push   %ebp
     d6b:	89 e5                	mov    %esp,%ebp
     d6d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     d70:	8b 45 08             	mov    0x8(%ebp),%eax
     d73:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     d76:	8b 45 0c             	mov    0xc(%ebp),%eax
     d79:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     d7c:	eb 13                	jmp    d91 <memmove+0x27>
    *dst++ = *src++;
     d7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     d81:	0f b6 10             	movzbl (%eax),%edx
     d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d87:	88 10                	mov    %dl,(%eax)
     d89:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d8d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     d95:	0f 9f c0             	setg   %al
     d98:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     d9c:	84 c0                	test   %al,%al
     d9e:	75 de                	jne    d7e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     da0:	8b 45 08             	mov    0x8(%ebp),%eax
}
     da3:	c9                   	leave  
     da4:	c3                   	ret    
     da5:	90                   	nop
     da6:	90                   	nop
     da7:	90                   	nop

00000da8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     da8:	b8 01 00 00 00       	mov    $0x1,%eax
     dad:	cd 40                	int    $0x40
     daf:	c3                   	ret    

00000db0 <exit>:
SYSCALL(exit)
     db0:	b8 02 00 00 00       	mov    $0x2,%eax
     db5:	cd 40                	int    $0x40
     db7:	c3                   	ret    

00000db8 <wait>:
SYSCALL(wait)
     db8:	b8 03 00 00 00       	mov    $0x3,%eax
     dbd:	cd 40                	int    $0x40
     dbf:	c3                   	ret    

00000dc0 <pipe>:
SYSCALL(pipe)
     dc0:	b8 04 00 00 00       	mov    $0x4,%eax
     dc5:	cd 40                	int    $0x40
     dc7:	c3                   	ret    

00000dc8 <read>:
SYSCALL(read)
     dc8:	b8 05 00 00 00       	mov    $0x5,%eax
     dcd:	cd 40                	int    $0x40
     dcf:	c3                   	ret    

00000dd0 <write>:
SYSCALL(write)
     dd0:	b8 10 00 00 00       	mov    $0x10,%eax
     dd5:	cd 40                	int    $0x40
     dd7:	c3                   	ret    

00000dd8 <close>:
SYSCALL(close)
     dd8:	b8 15 00 00 00       	mov    $0x15,%eax
     ddd:	cd 40                	int    $0x40
     ddf:	c3                   	ret    

00000de0 <kill>:
SYSCALL(kill)
     de0:	b8 06 00 00 00       	mov    $0x6,%eax
     de5:	cd 40                	int    $0x40
     de7:	c3                   	ret    

00000de8 <exec>:
SYSCALL(exec)
     de8:	b8 07 00 00 00       	mov    $0x7,%eax
     ded:	cd 40                	int    $0x40
     def:	c3                   	ret    

00000df0 <open>:
SYSCALL(open)
     df0:	b8 0f 00 00 00       	mov    $0xf,%eax
     df5:	cd 40                	int    $0x40
     df7:	c3                   	ret    

00000df8 <mknod>:
SYSCALL(mknod)
     df8:	b8 11 00 00 00       	mov    $0x11,%eax
     dfd:	cd 40                	int    $0x40
     dff:	c3                   	ret    

00000e00 <unlink>:
SYSCALL(unlink)
     e00:	b8 12 00 00 00       	mov    $0x12,%eax
     e05:	cd 40                	int    $0x40
     e07:	c3                   	ret    

00000e08 <fstat>:
SYSCALL(fstat)
     e08:	b8 08 00 00 00       	mov    $0x8,%eax
     e0d:	cd 40                	int    $0x40
     e0f:	c3                   	ret    

00000e10 <link>:
SYSCALL(link)
     e10:	b8 13 00 00 00       	mov    $0x13,%eax
     e15:	cd 40                	int    $0x40
     e17:	c3                   	ret    

00000e18 <mkdir>:
SYSCALL(mkdir)
     e18:	b8 14 00 00 00       	mov    $0x14,%eax
     e1d:	cd 40                	int    $0x40
     e1f:	c3                   	ret    

00000e20 <chdir>:
SYSCALL(chdir)
     e20:	b8 09 00 00 00       	mov    $0x9,%eax
     e25:	cd 40                	int    $0x40
     e27:	c3                   	ret    

00000e28 <dup>:
SYSCALL(dup)
     e28:	b8 0a 00 00 00       	mov    $0xa,%eax
     e2d:	cd 40                	int    $0x40
     e2f:	c3                   	ret    

00000e30 <getpid>:
SYSCALL(getpid)
     e30:	b8 0b 00 00 00       	mov    $0xb,%eax
     e35:	cd 40                	int    $0x40
     e37:	c3                   	ret    

00000e38 <sbrk>:
SYSCALL(sbrk)
     e38:	b8 0c 00 00 00       	mov    $0xc,%eax
     e3d:	cd 40                	int    $0x40
     e3f:	c3                   	ret    

00000e40 <sleep>:
SYSCALL(sleep)
     e40:	b8 0d 00 00 00       	mov    $0xd,%eax
     e45:	cd 40                	int    $0x40
     e47:	c3                   	ret    

00000e48 <uptime>:
SYSCALL(uptime)
     e48:	b8 0e 00 00 00       	mov    $0xe,%eax
     e4d:	cd 40                	int    $0x40
     e4f:	c3                   	ret    

00000e50 <thread_create>:
SYSCALL(thread_create)
     e50:	b8 16 00 00 00       	mov    $0x16,%eax
     e55:	cd 40                	int    $0x40
     e57:	c3                   	ret    

00000e58 <thread_getId>:
SYSCALL(thread_getId)
     e58:	b8 17 00 00 00       	mov    $0x17,%eax
     e5d:	cd 40                	int    $0x40
     e5f:	c3                   	ret    

00000e60 <thread_getProcId>:
SYSCALL(thread_getProcId)
     e60:	b8 18 00 00 00       	mov    $0x18,%eax
     e65:	cd 40                	int    $0x40
     e67:	c3                   	ret    

00000e68 <thread_join>:
SYSCALL(thread_join)
     e68:	b8 19 00 00 00       	mov    $0x19,%eax
     e6d:	cd 40                	int    $0x40
     e6f:	c3                   	ret    

00000e70 <thread_exit>:
SYSCALL(thread_exit)
     e70:	b8 1a 00 00 00       	mov    $0x1a,%eax
     e75:	cd 40                	int    $0x40
     e77:	c3                   	ret    

00000e78 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     e78:	b8 1b 00 00 00       	mov    $0x1b,%eax
     e7d:	cd 40                	int    $0x40
     e7f:	c3                   	ret    

00000e80 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     e80:	b8 1c 00 00 00       	mov    $0x1c,%eax
     e85:	cd 40                	int    $0x40
     e87:	c3                   	ret    

00000e88 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     e88:	b8 1d 00 00 00       	mov    $0x1d,%eax
     e8d:	cd 40                	int    $0x40
     e8f:	c3                   	ret    

00000e90 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     e90:	55                   	push   %ebp
     e91:	89 e5                	mov    %esp,%ebp
     e93:	83 ec 28             	sub    $0x28,%esp
     e96:	8b 45 0c             	mov    0xc(%ebp),%eax
     e99:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     e9c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     ea3:	00 
     ea4:	8d 45 f4             	lea    -0xc(%ebp),%eax
     ea7:	89 44 24 04          	mov    %eax,0x4(%esp)
     eab:	8b 45 08             	mov    0x8(%ebp),%eax
     eae:	89 04 24             	mov    %eax,(%esp)
     eb1:	e8 1a ff ff ff       	call   dd0 <write>
}
     eb6:	c9                   	leave  
     eb7:	c3                   	ret    

00000eb8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     eb8:	55                   	push   %ebp
     eb9:	89 e5                	mov    %esp,%ebp
     ebb:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     ebe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     ec5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     ec9:	74 17                	je     ee2 <printint+0x2a>
     ecb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     ecf:	79 11                	jns    ee2 <printint+0x2a>
    neg = 1;
     ed1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
     edb:	f7 d8                	neg    %eax
     edd:	89 45 ec             	mov    %eax,-0x14(%ebp)
     ee0:	eb 06                	jmp    ee8 <printint+0x30>
  } else {
    x = xx;
     ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ee5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     eef:	8b 4d 10             	mov    0x10(%ebp),%ecx
     ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ef5:	ba 00 00 00 00       	mov    $0x0,%edx
     efa:	f7 f1                	div    %ecx
     efc:	89 d0                	mov    %edx,%eax
     efe:	0f b6 90 b4 1e 00 00 	movzbl 0x1eb4(%eax),%edx
     f05:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f08:	03 45 f4             	add    -0xc(%ebp),%eax
     f0b:	88 10                	mov    %dl,(%eax)
     f0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     f11:	8b 55 10             	mov    0x10(%ebp),%edx
     f14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f1a:	ba 00 00 00 00       	mov    $0x0,%edx
     f1f:	f7 75 d4             	divl   -0x2c(%ebp)
     f22:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f29:	75 c4                	jne    eef <printint+0x37>
  if(neg)
     f2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f2f:	74 2a                	je     f5b <printint+0xa3>
    buf[i++] = '-';
     f31:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f34:	03 45 f4             	add    -0xc(%ebp),%eax
     f37:	c6 00 2d             	movb   $0x2d,(%eax)
     f3a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     f3e:	eb 1b                	jmp    f5b <printint+0xa3>
    putc(fd, buf[i]);
     f40:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f43:	03 45 f4             	add    -0xc(%ebp),%eax
     f46:	0f b6 00             	movzbl (%eax),%eax
     f49:	0f be c0             	movsbl %al,%eax
     f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
     f50:	8b 45 08             	mov    0x8(%ebp),%eax
     f53:	89 04 24             	mov    %eax,(%esp)
     f56:	e8 35 ff ff ff       	call   e90 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     f5b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     f5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f63:	79 db                	jns    f40 <printint+0x88>
    putc(fd, buf[i]);
}
     f65:	c9                   	leave  
     f66:	c3                   	ret    

00000f67 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     f67:	55                   	push   %ebp
     f68:	89 e5                	mov    %esp,%ebp
     f6a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     f6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     f74:	8d 45 0c             	lea    0xc(%ebp),%eax
     f77:	83 c0 04             	add    $0x4,%eax
     f7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     f7d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     f84:	e9 7d 01 00 00       	jmp    1106 <printf+0x19f>
    c = fmt[i] & 0xff;
     f89:	8b 55 0c             	mov    0xc(%ebp),%edx
     f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f8f:	01 d0                	add    %edx,%eax
     f91:	0f b6 00             	movzbl (%eax),%eax
     f94:	0f be c0             	movsbl %al,%eax
     f97:	25 ff 00 00 00       	and    $0xff,%eax
     f9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     f9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fa3:	75 2c                	jne    fd1 <printf+0x6a>
      if(c == '%'){
     fa5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     fa9:	75 0c                	jne    fb7 <printf+0x50>
        state = '%';
     fab:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     fb2:	e9 4b 01 00 00       	jmp    1102 <printf+0x19b>
      } else {
        putc(fd, c);
     fb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     fba:	0f be c0             	movsbl %al,%eax
     fbd:	89 44 24 04          	mov    %eax,0x4(%esp)
     fc1:	8b 45 08             	mov    0x8(%ebp),%eax
     fc4:	89 04 24             	mov    %eax,(%esp)
     fc7:	e8 c4 fe ff ff       	call   e90 <putc>
     fcc:	e9 31 01 00 00       	jmp    1102 <printf+0x19b>
      }
    } else if(state == '%'){
     fd1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     fd5:	0f 85 27 01 00 00    	jne    1102 <printf+0x19b>
      if(c == 'd'){
     fdb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     fdf:	75 2d                	jne    100e <printf+0xa7>
        printint(fd, *ap, 10, 1);
     fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fe4:	8b 00                	mov    (%eax),%eax
     fe6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     fed:	00 
     fee:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     ff5:	00 
     ff6:	89 44 24 04          	mov    %eax,0x4(%esp)
     ffa:	8b 45 08             	mov    0x8(%ebp),%eax
     ffd:	89 04 24             	mov    %eax,(%esp)
    1000:	e8 b3 fe ff ff       	call   eb8 <printint>
        ap++;
    1005:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1009:	e9 ed 00 00 00       	jmp    10fb <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    100e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1012:	74 06                	je     101a <printf+0xb3>
    1014:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1018:	75 2d                	jne    1047 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    101a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    101d:	8b 00                	mov    (%eax),%eax
    101f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1026:	00 
    1027:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    102e:	00 
    102f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1033:	8b 45 08             	mov    0x8(%ebp),%eax
    1036:	89 04 24             	mov    %eax,(%esp)
    1039:	e8 7a fe ff ff       	call   eb8 <printint>
        ap++;
    103e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1042:	e9 b4 00 00 00       	jmp    10fb <printf+0x194>
      } else if(c == 's'){
    1047:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    104b:	75 46                	jne    1093 <printf+0x12c>
        s = (char*)*ap;
    104d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1050:	8b 00                	mov    (%eax),%eax
    1052:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1055:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1059:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    105d:	75 27                	jne    1086 <printf+0x11f>
          s = "(null)";
    105f:	c7 45 f4 a4 18 00 00 	movl   $0x18a4,-0xc(%ebp)
        while(*s != 0){
    1066:	eb 1e                	jmp    1086 <printf+0x11f>
          putc(fd, *s);
    1068:	8b 45 f4             	mov    -0xc(%ebp),%eax
    106b:	0f b6 00             	movzbl (%eax),%eax
    106e:	0f be c0             	movsbl %al,%eax
    1071:	89 44 24 04          	mov    %eax,0x4(%esp)
    1075:	8b 45 08             	mov    0x8(%ebp),%eax
    1078:	89 04 24             	mov    %eax,(%esp)
    107b:	e8 10 fe ff ff       	call   e90 <putc>
          s++;
    1080:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1084:	eb 01                	jmp    1087 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1086:	90                   	nop
    1087:	8b 45 f4             	mov    -0xc(%ebp),%eax
    108a:	0f b6 00             	movzbl (%eax),%eax
    108d:	84 c0                	test   %al,%al
    108f:	75 d7                	jne    1068 <printf+0x101>
    1091:	eb 68                	jmp    10fb <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1093:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1097:	75 1d                	jne    10b6 <printf+0x14f>
        putc(fd, *ap);
    1099:	8b 45 e8             	mov    -0x18(%ebp),%eax
    109c:	8b 00                	mov    (%eax),%eax
    109e:	0f be c0             	movsbl %al,%eax
    10a1:	89 44 24 04          	mov    %eax,0x4(%esp)
    10a5:	8b 45 08             	mov    0x8(%ebp),%eax
    10a8:	89 04 24             	mov    %eax,(%esp)
    10ab:	e8 e0 fd ff ff       	call   e90 <putc>
        ap++;
    10b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10b4:	eb 45                	jmp    10fb <printf+0x194>
      } else if(c == '%'){
    10b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    10ba:	75 17                	jne    10d3 <printf+0x16c>
        putc(fd, c);
    10bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10bf:	0f be c0             	movsbl %al,%eax
    10c2:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c6:	8b 45 08             	mov    0x8(%ebp),%eax
    10c9:	89 04 24             	mov    %eax,(%esp)
    10cc:	e8 bf fd ff ff       	call   e90 <putc>
    10d1:	eb 28                	jmp    10fb <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    10d3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    10da:	00 
    10db:	8b 45 08             	mov    0x8(%ebp),%eax
    10de:	89 04 24             	mov    %eax,(%esp)
    10e1:	e8 aa fd ff ff       	call   e90 <putc>
        putc(fd, c);
    10e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10e9:	0f be c0             	movsbl %al,%eax
    10ec:	89 44 24 04          	mov    %eax,0x4(%esp)
    10f0:	8b 45 08             	mov    0x8(%ebp),%eax
    10f3:	89 04 24             	mov    %eax,(%esp)
    10f6:	e8 95 fd ff ff       	call   e90 <putc>
      }
      state = 0;
    10fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1102:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1106:	8b 55 0c             	mov    0xc(%ebp),%edx
    1109:	8b 45 f0             	mov    -0x10(%ebp),%eax
    110c:	01 d0                	add    %edx,%eax
    110e:	0f b6 00             	movzbl (%eax),%eax
    1111:	84 c0                	test   %al,%al
    1113:	0f 85 70 fe ff ff    	jne    f89 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1119:	c9                   	leave  
    111a:	c3                   	ret    
    111b:	90                   	nop

0000111c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    111c:	55                   	push   %ebp
    111d:	89 e5                	mov    %esp,%ebp
    111f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1122:	8b 45 08             	mov    0x8(%ebp),%eax
    1125:	83 e8 08             	sub    $0x8,%eax
    1128:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    112b:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
    1130:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1133:	eb 24                	jmp    1159 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1135:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1138:	8b 00                	mov    (%eax),%eax
    113a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    113d:	77 12                	ja     1151 <free+0x35>
    113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1142:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1145:	77 24                	ja     116b <free+0x4f>
    1147:	8b 45 fc             	mov    -0x4(%ebp),%eax
    114a:	8b 00                	mov    (%eax),%eax
    114c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    114f:	77 1a                	ja     116b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1151:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1154:	8b 00                	mov    (%eax),%eax
    1156:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1159:	8b 45 f8             	mov    -0x8(%ebp),%eax
    115c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    115f:	76 d4                	jbe    1135 <free+0x19>
    1161:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1164:	8b 00                	mov    (%eax),%eax
    1166:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1169:	76 ca                	jbe    1135 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    116b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    116e:	8b 40 04             	mov    0x4(%eax),%eax
    1171:	c1 e0 03             	shl    $0x3,%eax
    1174:	89 c2                	mov    %eax,%edx
    1176:	03 55 f8             	add    -0x8(%ebp),%edx
    1179:	8b 45 fc             	mov    -0x4(%ebp),%eax
    117c:	8b 00                	mov    (%eax),%eax
    117e:	39 c2                	cmp    %eax,%edx
    1180:	75 24                	jne    11a6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    1182:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1185:	8b 50 04             	mov    0x4(%eax),%edx
    1188:	8b 45 fc             	mov    -0x4(%ebp),%eax
    118b:	8b 00                	mov    (%eax),%eax
    118d:	8b 40 04             	mov    0x4(%eax),%eax
    1190:	01 c2                	add    %eax,%edx
    1192:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1195:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1198:	8b 45 fc             	mov    -0x4(%ebp),%eax
    119b:	8b 00                	mov    (%eax),%eax
    119d:	8b 10                	mov    (%eax),%edx
    119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11a2:	89 10                	mov    %edx,(%eax)
    11a4:	eb 0a                	jmp    11b0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    11a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11a9:	8b 10                	mov    (%eax),%edx
    11ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    11b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11b3:	8b 40 04             	mov    0x4(%eax),%eax
    11b6:	c1 e0 03             	shl    $0x3,%eax
    11b9:	03 45 fc             	add    -0x4(%ebp),%eax
    11bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11bf:	75 20                	jne    11e1 <free+0xc5>
    p->s.size += bp->s.size;
    11c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11c4:	8b 50 04             	mov    0x4(%eax),%edx
    11c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ca:	8b 40 04             	mov    0x4(%eax),%eax
    11cd:	01 c2                	add    %eax,%edx
    11cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    11d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11d8:	8b 10                	mov    (%eax),%edx
    11da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11dd:	89 10                	mov    %edx,(%eax)
    11df:	eb 08                	jmp    11e9 <free+0xcd>
  } else
    p->s.ptr = bp;
    11e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
    11e7:	89 10                	mov    %edx,(%eax)
  freep = p;
    11e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11ec:	a3 d0 1e 00 00       	mov    %eax,0x1ed0
}
    11f1:	c9                   	leave  
    11f2:	c3                   	ret    

000011f3 <morecore>:

static Header*
morecore(uint nu)
{
    11f3:	55                   	push   %ebp
    11f4:	89 e5                	mov    %esp,%ebp
    11f6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    11f9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1200:	77 07                	ja     1209 <morecore+0x16>
    nu = 4096;
    1202:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1209:	8b 45 08             	mov    0x8(%ebp),%eax
    120c:	c1 e0 03             	shl    $0x3,%eax
    120f:	89 04 24             	mov    %eax,(%esp)
    1212:	e8 21 fc ff ff       	call   e38 <sbrk>
    1217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    121a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    121e:	75 07                	jne    1227 <morecore+0x34>
    return 0;
    1220:	b8 00 00 00 00       	mov    $0x0,%eax
    1225:	eb 22                	jmp    1249 <morecore+0x56>
  hp = (Header*)p;
    1227:	8b 45 f4             	mov    -0xc(%ebp),%eax
    122a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    122d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1230:	8b 55 08             	mov    0x8(%ebp),%edx
    1233:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1236:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1239:	83 c0 08             	add    $0x8,%eax
    123c:	89 04 24             	mov    %eax,(%esp)
    123f:	e8 d8 fe ff ff       	call   111c <free>
  return freep;
    1244:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
}
    1249:	c9                   	leave  
    124a:	c3                   	ret    

0000124b <malloc>:

void*
malloc(uint nbytes)
{
    124b:	55                   	push   %ebp
    124c:	89 e5                	mov    %esp,%ebp
    124e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1251:	8b 45 08             	mov    0x8(%ebp),%eax
    1254:	83 c0 07             	add    $0x7,%eax
    1257:	c1 e8 03             	shr    $0x3,%eax
    125a:	83 c0 01             	add    $0x1,%eax
    125d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1260:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
    1265:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1268:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    126c:	75 23                	jne    1291 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    126e:	c7 45 f0 c8 1e 00 00 	movl   $0x1ec8,-0x10(%ebp)
    1275:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1278:	a3 d0 1e 00 00       	mov    %eax,0x1ed0
    127d:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
    1282:	a3 c8 1e 00 00       	mov    %eax,0x1ec8
    base.s.size = 0;
    1287:	c7 05 cc 1e 00 00 00 	movl   $0x0,0x1ecc
    128e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1291:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1294:	8b 00                	mov    (%eax),%eax
    1296:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1299:	8b 45 f4             	mov    -0xc(%ebp),%eax
    129c:	8b 40 04             	mov    0x4(%eax),%eax
    129f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    12a2:	72 4d                	jb     12f1 <malloc+0xa6>
      if(p->s.size == nunits)
    12a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a7:	8b 40 04             	mov    0x4(%eax),%eax
    12aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    12ad:	75 0c                	jne    12bb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    12af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b2:	8b 10                	mov    (%eax),%edx
    12b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12b7:	89 10                	mov    %edx,(%eax)
    12b9:	eb 26                	jmp    12e1 <malloc+0x96>
      else {
        p->s.size -= nunits;
    12bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12be:	8b 40 04             	mov    0x4(%eax),%eax
    12c1:	89 c2                	mov    %eax,%edx
    12c3:	2b 55 ec             	sub    -0x14(%ebp),%edx
    12c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    12cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12cf:	8b 40 04             	mov    0x4(%eax),%eax
    12d2:	c1 e0 03             	shl    $0x3,%eax
    12d5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    12d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12db:	8b 55 ec             	mov    -0x14(%ebp),%edx
    12de:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    12e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12e4:	a3 d0 1e 00 00       	mov    %eax,0x1ed0
      return (void*)(p + 1);
    12e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ec:	83 c0 08             	add    $0x8,%eax
    12ef:	eb 38                	jmp    1329 <malloc+0xde>
    }
    if(p == freep)
    12f1:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
    12f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    12f9:	75 1b                	jne    1316 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    12fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    12fe:	89 04 24             	mov    %eax,(%esp)
    1301:	e8 ed fe ff ff       	call   11f3 <morecore>
    1306:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    130d:	75 07                	jne    1316 <malloc+0xcb>
        return 0;
    130f:	b8 00 00 00 00       	mov    $0x0,%eax
    1314:	eb 13                	jmp    1329 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1316:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1319:	89 45 f0             	mov    %eax,-0x10(%ebp)
    131c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    131f:	8b 00                	mov    (%eax),%eax
    1321:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1324:	e9 70 ff ff ff       	jmp    1299 <malloc+0x4e>
}
    1329:	c9                   	leave  
    132a:	c3                   	ret    
    132b:	90                   	nop

0000132c <semaphore_create>:
#include "semaphore.h"
#include "types.h"
#include "user.h"


struct semaphore* semaphore_create(int initial_semaphore_value){
    132c:	55                   	push   %ebp
    132d:	89 e5                	mov    %esp,%ebp
    132f:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* sem=malloc(sizeof(struct semaphore)); 
    1332:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    1339:	e8 0d ff ff ff       	call   124b <malloc>
    133e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // acquire semaphors
  sem->s1 = binary_semaphore_create(1);
    1341:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1348:	e8 2b fb ff ff       	call   e78 <binary_semaphore_create>
    134d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1350:	89 02                	mov    %eax,(%edx)
  
  // s2 should be initialized with the min{1,initial_semaphore_value}
  if(initial_semaphore_value >= 1){
    1352:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1356:	7e 14                	jle    136c <semaphore_create+0x40>
    sem->s2 = binary_semaphore_create(1);
    1358:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    135f:	e8 14 fb ff ff       	call   e78 <binary_semaphore_create>
    1364:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1367:	89 42 04             	mov    %eax,0x4(%edx)
    136a:	eb 11                	jmp    137d <semaphore_create+0x51>
  }else{
    sem->s2 = binary_semaphore_create(initial_semaphore_value);
    136c:	8b 45 08             	mov    0x8(%ebp),%eax
    136f:	89 04 24             	mov    %eax,(%esp)
    1372:	e8 01 fb ff ff       	call   e78 <binary_semaphore_create>
    1377:	8b 55 f4             	mov    -0xc(%ebp),%edx
    137a:	89 42 04             	mov    %eax,0x4(%edx)
  }
  
  if(sem->s1 == -1 || sem->s2 == -1){
    137d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1380:	8b 00                	mov    (%eax),%eax
    1382:	83 f8 ff             	cmp    $0xffffffff,%eax
    1385:	74 0b                	je     1392 <semaphore_create+0x66>
    1387:	8b 45 f4             	mov    -0xc(%ebp),%eax
    138a:	8b 40 04             	mov    0x4(%eax),%eax
    138d:	83 f8 ff             	cmp    $0xffffffff,%eax
    1390:	75 26                	jne    13b8 <semaphore_create+0x8c>
     printf(1,"we had a probalem initialize in semaphore_create\n");
    1392:	c7 44 24 04 ac 18 00 	movl   $0x18ac,0x4(%esp)
    1399:	00 
    139a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13a1:	e8 c1 fb ff ff       	call   f67 <printf>
     free(sem);
    13a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a9:	89 04 24             	mov    %eax,(%esp)
    13ac:	e8 6b fd ff ff       	call   111c <free>
     return 0;
    13b1:	b8 00 00 00 00       	mov    $0x0,%eax
    13b6:	eb 15                	jmp    13cd <semaphore_create+0xa1>
  }
  //initialize value
  sem->value = initial_semaphore_value;//dynamic
    13b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13bb:	8b 55 08             	mov    0x8(%ebp),%edx
    13be:	89 50 08             	mov    %edx,0x8(%eax)
  sem->initial_value = initial_semaphore_value;//static
    13c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13c4:	8b 55 08             	mov    0x8(%ebp),%edx
    13c7:	89 50 0c             	mov    %edx,0xc(%eax)
  
  return sem;
    13ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    13cd:	c9                   	leave  
    13ce:	c3                   	ret    

000013cf <semaphore_down>:
void semaphore_down(struct semaphore* sem ){
    13cf:	55                   	push   %ebp
    13d0:	89 e5                	mov    %esp,%ebp
    13d2:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s2);
    13d5:	8b 45 08             	mov    0x8(%ebp),%eax
    13d8:	8b 40 04             	mov    0x4(%eax),%eax
    13db:	89 04 24             	mov    %eax,(%esp)
    13de:	e8 9d fa ff ff       	call   e80 <binary_semaphore_down>
  binary_semaphore_down(sem->s1);
    13e3:	8b 45 08             	mov    0x8(%ebp),%eax
    13e6:	8b 00                	mov    (%eax),%eax
    13e8:	89 04 24             	mov    %eax,(%esp)
    13eb:	e8 90 fa ff ff       	call   e80 <binary_semaphore_down>
  sem->value--;	
    13f0:	8b 45 08             	mov    0x8(%ebp),%eax
    13f3:	8b 40 08             	mov    0x8(%eax),%eax
    13f6:	8d 50 ff             	lea    -0x1(%eax),%edx
    13f9:	8b 45 08             	mov    0x8(%ebp),%eax
    13fc:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value > 0){
    13ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1402:	8b 40 08             	mov    0x8(%eax),%eax
    1405:	85 c0                	test   %eax,%eax
    1407:	7e 0e                	jle    1417 <semaphore_down+0x48>
   binary_semaphore_up(sem->s2);
    1409:	8b 45 08             	mov    0x8(%ebp),%eax
    140c:	8b 40 04             	mov    0x4(%eax),%eax
    140f:	89 04 24             	mov    %eax,(%esp)
    1412:	e8 71 fa ff ff       	call   e88 <binary_semaphore_up>
  }
  binary_semaphore_up(sem->s1); 
    1417:	8b 45 08             	mov    0x8(%ebp),%eax
    141a:	8b 00                	mov    (%eax),%eax
    141c:	89 04 24             	mov    %eax,(%esp)
    141f:	e8 64 fa ff ff       	call   e88 <binary_semaphore_up>
}
    1424:	c9                   	leave  
    1425:	c3                   	ret    

00001426 <semaphore_up>:
void semaphore_up(struct semaphore* sem ){
    1426:	55                   	push   %ebp
    1427:	89 e5                	mov    %esp,%ebp
    1429:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
    142c:	8b 45 08             	mov    0x8(%ebp),%eax
    142f:	8b 00                	mov    (%eax),%eax
    1431:	89 04 24             	mov    %eax,(%esp)
    1434:	e8 47 fa ff ff       	call   e80 <binary_semaphore_down>
  sem->value++;	
    1439:	8b 45 08             	mov    0x8(%ebp),%eax
    143c:	8b 40 08             	mov    0x8(%eax),%eax
    143f:	8d 50 01             	lea    0x1(%eax),%edx
    1442:	8b 45 08             	mov    0x8(%ebp),%eax
    1445:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value ==1){
    1448:	8b 45 08             	mov    0x8(%ebp),%eax
    144b:	8b 40 08             	mov    0x8(%eax),%eax
    144e:	83 f8 01             	cmp    $0x1,%eax
    1451:	75 0e                	jne    1461 <semaphore_up+0x3b>
   binary_semaphore_up(sem->s2); 
    1453:	8b 45 08             	mov    0x8(%ebp),%eax
    1456:	8b 40 04             	mov    0x4(%eax),%eax
    1459:	89 04 24             	mov    %eax,(%esp)
    145c:	e8 27 fa ff ff       	call   e88 <binary_semaphore_up>
   }
  binary_semaphore_up(sem->s1);
    1461:	8b 45 08             	mov    0x8(%ebp),%eax
    1464:	8b 00                	mov    (%eax),%eax
    1466:	89 04 24             	mov    %eax,(%esp)
    1469:	e8 1a fa ff ff       	call   e88 <binary_semaphore_up>
}
    146e:	c9                   	leave  
    146f:	c3                   	ret    

00001470 <semaphore_free>:

void semaphore_free(struct semaphore* sem){
    1470:	55                   	push   %ebp
    1471:	89 e5                	mov    %esp,%ebp
    1473:	83 ec 18             	sub    $0x18,%esp
  free(sem);
    1476:	8b 45 08             	mov    0x8(%ebp),%eax
    1479:	89 04 24             	mov    %eax,(%esp)
    147c:	e8 9b fc ff ff       	call   111c <free>
}
    1481:	c9                   	leave  
    1482:	c3                   	ret    
    1483:	90                   	nop

00001484 <BB_create>:
#include "types.h"
#include "user.h"


struct BB* 
BB_create(int max_capacity){
    1484:	55                   	push   %ebp
    1485:	89 e5                	mov    %esp,%ebp
    1487:	83 ec 38             	sub    $0x38,%esp
  //initialize
  struct BB* buf = malloc(sizeof(struct BB));
    148a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
    1491:	e8 b5 fd ff ff       	call   124b <malloc>
    1496:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
    1499:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    14a0:	00 
    14a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14a8:	00 
    14a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ac:	89 04 24             	mov    %eax,(%esp)
    14af:	e8 57 f7 ff ff       	call   c0b <memset>
 
  buf->buffer_size = max_capacity;
    14b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b7:	8b 55 08             	mov    0x8(%ebp),%edx
    14ba:	89 10                	mov    %edx,(%eax)
  buf->mutex = binary_semaphore_create(1);  
    14bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14c3:	e8 b0 f9 ff ff       	call   e78 <binary_semaphore_create>
    14c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14cb:	89 42 04             	mov    %eax,0x4(%edx)
  buf->empty = semaphore_create(max_capacity);
    14ce:	8b 45 08             	mov    0x8(%ebp),%eax
    14d1:	89 04 24             	mov    %eax,(%esp)
    14d4:	e8 53 fe ff ff       	call   132c <semaphore_create>
    14d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14dc:	89 42 08             	mov    %eax,0x8(%edx)
  buf->full = semaphore_create(0);
    14df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    14e6:	e8 41 fe ff ff       	call   132c <semaphore_create>
    14eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14ee:	89 42 0c             	mov    %eax,0xc(%edx)
  buf->pointer_to_elements = malloc(sizeof(void*)*max_capacity);
    14f1:	8b 45 08             	mov    0x8(%ebp),%eax
    14f4:	c1 e0 02             	shl    $0x2,%eax
    14f7:	89 04 24             	mov    %eax,(%esp)
    14fa:	e8 4c fd ff ff       	call   124b <malloc>
    14ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1502:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->pointer_to_elements,0,sizeof(void*)*max_capacity);
    1505:	8b 45 08             	mov    0x8(%ebp),%eax
    1508:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    150f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1512:	8b 40 1c             	mov    0x1c(%eax),%eax
    1515:	89 54 24 08          	mov    %edx,0x8(%esp)
    1519:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1520:	00 
    1521:	89 04 24             	mov    %eax,(%esp)
    1524:	e8 e2 f6 ff ff       	call   c0b <memset>
  buf->count = 0;//TODO remove or not
    1529:	8b 45 f4             	mov    -0xc(%ebp),%eax
    152c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  //check the semaphorses
  if(buf->mutex == -1 || buf->empty == 0 || buf->full == 0){
    1533:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1536:	8b 40 04             	mov    0x4(%eax),%eax
    1539:	83 f8 ff             	cmp    $0xffffffff,%eax
    153c:	74 14                	je     1552 <BB_create+0xce>
    153e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1541:	8b 40 08             	mov    0x8(%eax),%eax
    1544:	85 c0                	test   %eax,%eax
    1546:	74 0a                	je     1552 <BB_create+0xce>
    1548:	8b 45 f4             	mov    -0xc(%ebp),%eax
    154b:	8b 40 0c             	mov    0xc(%eax),%eax
    154e:	85 c0                	test   %eax,%eax
    1550:	75 44                	jne    1596 <BB_create+0x112>
   printf(1,"we had a problam getting semaphores at BB create mutex %d empty %d full %d\n",buf->mutex,buf->empty,buf->full);
    1552:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1555:	8b 48 0c             	mov    0xc(%eax),%ecx
    1558:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155b:	8b 50 08             	mov    0x8(%eax),%edx
    155e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1561:	8b 40 04             	mov    0x4(%eax),%eax
    1564:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    1568:	89 54 24 0c          	mov    %edx,0xc(%esp)
    156c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1570:	c7 44 24 04 e0 18 00 	movl   $0x18e0,0x4(%esp)
    1577:	00 
    1578:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    157f:	e8 e3 f9 ff ff       	call   f67 <printf>
   BB_free(buf);
    1584:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1587:	89 04 24             	mov    %eax,(%esp)
    158a:	e8 20 01 00 00       	call   16af <BB_free>
   //free(buf->pointer_to_elements);//TODO remove
   //free(buf);
   buf =0;  
    158f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  }
  return buf;
    1596:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1599:	c9                   	leave  
    159a:	c3                   	ret    

0000159b <BB_put>:

void BB_put(struct BB* bb, void* element)
{ //TODO mix
    159b:	55                   	push   %ebp
    159c:	89 e5                	mov    %esp,%ebp
    159e:	83 ec 18             	sub    $0x18,%esp
  bb->pointer_to_elements[bb->count] = element;
  bb->count++;
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->full);
  */
  semaphore_down(bb->empty);
    15a1:	8b 45 08             	mov    0x8(%ebp),%eax
    15a4:	8b 40 08             	mov    0x8(%eax),%eax
    15a7:	89 04 24             	mov    %eax,(%esp)
    15aa:	e8 20 fe ff ff       	call   13cf <semaphore_down>
  binary_semaphore_down(bb->mutex);
    15af:	8b 45 08             	mov    0x8(%ebp),%eax
    15b2:	8b 40 04             	mov    0x4(%eax),%eax
    15b5:	89 04 24             	mov    %eax,(%esp)
    15b8:	e8 c3 f8 ff ff       	call   e80 <binary_semaphore_down>
   //insert item
  bb->pointer_to_elements[bb->end] = element;
    15bd:	8b 45 08             	mov    0x8(%ebp),%eax
    15c0:	8b 50 1c             	mov    0x1c(%eax),%edx
    15c3:	8b 45 08             	mov    0x8(%ebp),%eax
    15c6:	8b 40 18             	mov    0x18(%eax),%eax
    15c9:	c1 e0 02             	shl    $0x2,%eax
    15cc:	01 c2                	add    %eax,%edx
    15ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    15d1:	89 02                	mov    %eax,(%edx)
  ++bb->end;
    15d3:	8b 45 08             	mov    0x8(%ebp),%eax
    15d6:	8b 40 18             	mov    0x18(%eax),%eax
    15d9:	8d 50 01             	lea    0x1(%eax),%edx
    15dc:	8b 45 08             	mov    0x8(%ebp),%eax
    15df:	89 50 18             	mov    %edx,0x18(%eax)
  bb->end = bb->end%bb->buffer_size;
    15e2:	8b 45 08             	mov    0x8(%ebp),%eax
    15e5:	8b 40 18             	mov    0x18(%eax),%eax
    15e8:	8b 55 08             	mov    0x8(%ebp),%edx
    15eb:	8b 0a                	mov    (%edx),%ecx
    15ed:	89 c2                	mov    %eax,%edx
    15ef:	c1 fa 1f             	sar    $0x1f,%edx
    15f2:	f7 f9                	idiv   %ecx
    15f4:	8b 45 08             	mov    0x8(%ebp),%eax
    15f7:	89 50 18             	mov    %edx,0x18(%eax)
  binary_semaphore_up(bb->mutex);
    15fa:	8b 45 08             	mov    0x8(%ebp),%eax
    15fd:	8b 40 04             	mov    0x4(%eax),%eax
    1600:	89 04 24             	mov    %eax,(%esp)
    1603:	e8 80 f8 ff ff       	call   e88 <binary_semaphore_up>
  semaphore_up(bb->full);
    1608:	8b 45 08             	mov    0x8(%ebp),%eax
    160b:	8b 40 0c             	mov    0xc(%eax),%eax
    160e:	89 04 24             	mov    %eax,(%esp)
    1611:	e8 10 fe ff ff       	call   1426 <semaphore_up>
    
}
    1616:	c9                   	leave  
    1617:	c3                   	ret    

00001618 <BB_pop>:

void* BB_pop(struct BB* bb)
{//TODO clean and mix
    1618:	55                   	push   %ebp
    1619:	89 e5                	mov    %esp,%ebp
    161b:	83 ec 28             	sub    $0x28,%esp
  
  void* element_to_pop;
  semaphore_down(bb->full);
    161e:	8b 45 08             	mov    0x8(%ebp),%eax
    1621:	8b 40 0c             	mov    0xc(%eax),%eax
    1624:	89 04 24             	mov    %eax,(%esp)
    1627:	e8 a3 fd ff ff       	call   13cf <semaphore_down>
  binary_semaphore_down(bb->mutex);
    162c:	8b 45 08             	mov    0x8(%ebp),%eax
    162f:	8b 40 04             	mov    0x4(%eax),%eax
    1632:	89 04 24             	mov    %eax,(%esp)
    1635:	e8 46 f8 ff ff       	call   e80 <binary_semaphore_down>
  element_to_pop = bb-> pointer_to_elements[bb->start];
    163a:	8b 45 08             	mov    0x8(%ebp),%eax
    163d:	8b 50 1c             	mov    0x1c(%eax),%edx
    1640:	8b 45 08             	mov    0x8(%ebp),%eax
    1643:	8b 40 14             	mov    0x14(%eax),%eax
    1646:	c1 e0 02             	shl    $0x2,%eax
    1649:	01 d0                	add    %edx,%eax
    164b:	8b 00                	mov    (%eax),%eax
    164d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->pointer_to_elements[bb->start] =0;
    1650:	8b 45 08             	mov    0x8(%ebp),%eax
    1653:	8b 50 1c             	mov    0x1c(%eax),%edx
    1656:	8b 45 08             	mov    0x8(%ebp),%eax
    1659:	8b 40 14             	mov    0x14(%eax),%eax
    165c:	c1 e0 02             	shl    $0x2,%eax
    165f:	01 d0                	add    %edx,%eax
    1661:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
    1667:	8b 45 08             	mov    0x8(%ebp),%eax
    166a:	8b 40 14             	mov    0x14(%eax),%eax
    166d:	8d 50 01             	lea    0x1(%eax),%edx
    1670:	8b 45 08             	mov    0x8(%ebp),%eax
    1673:	89 50 14             	mov    %edx,0x14(%eax)
  bb->start = bb->start%bb->buffer_size;
    1676:	8b 45 08             	mov    0x8(%ebp),%eax
    1679:	8b 40 14             	mov    0x14(%eax),%eax
    167c:	8b 55 08             	mov    0x8(%ebp),%edx
    167f:	8b 0a                	mov    (%edx),%ecx
    1681:	89 c2                	mov    %eax,%edx
    1683:	c1 fa 1f             	sar    $0x1f,%edx
    1686:	f7 f9                	idiv   %ecx
    1688:	8b 45 08             	mov    0x8(%ebp),%eax
    168b:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
    168e:	8b 45 08             	mov    0x8(%ebp),%eax
    1691:	8b 40 04             	mov    0x4(%eax),%eax
    1694:	89 04 24             	mov    %eax,(%esp)
    1697:	e8 ec f7 ff ff       	call   e88 <binary_semaphore_up>
  semaphore_up(bb->empty);
    169c:	8b 45 08             	mov    0x8(%ebp),%eax
    169f:	8b 40 08             	mov    0x8(%eax),%eax
    16a2:	89 04 24             	mov    %eax,(%esp)
    16a5:	e8 7c fd ff ff       	call   1426 <semaphore_up>
  return element_to_pop;
    16aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->empty);
  
  return element_to_pop;*/
}
    16ad:	c9                   	leave  
    16ae:	c3                   	ret    

000016af <BB_free>:

void BB_free(struct BB* bb){
    16af:	55                   	push   %ebp
    16b0:	89 e5                	mov    %esp,%ebp
    16b2:	83 ec 18             	sub    $0x18,%esp
  free(bb->pointer_to_elements);
    16b5:	8b 45 08             	mov    0x8(%ebp),%eax
    16b8:	8b 40 1c             	mov    0x1c(%eax),%eax
    16bb:	89 04 24             	mov    %eax,(%esp)
    16be:	e8 59 fa ff ff       	call   111c <free>
  free(bb);
    16c3:	8b 45 08             	mov    0x8(%ebp),%eax
    16c6:	89 04 24             	mov    %eax,(%esp)
    16c9:	e8 4e fa ff ff       	call   111c <free>
}
    16ce:	c9                   	leave  
    16cf:	c3                   	ret    

000016d0 <BB_size>:

int BB_size(struct BB* bb){
    16d0:	55                   	push   %ebp
    16d1:	89 e5                	mov    %esp,%ebp
    16d3:	83 ec 28             	sub    $0x28,%esp
  printf(1,"size\n");
    16d6:	c7 44 24 04 2c 19 00 	movl   $0x192c,0x4(%esp)
    16dd:	00 
    16de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16e5:	e8 7d f8 ff ff       	call   f67 <printf>
  int ans =0;
    16ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  semaphore_down(bb->full);
    16f1:	8b 45 08             	mov    0x8(%ebp),%eax
    16f4:	8b 40 0c             	mov    0xc(%eax),%eax
    16f7:	89 04 24             	mov    %eax,(%esp)
    16fa:	e8 d0 fc ff ff       	call   13cf <semaphore_down>
  binary_semaphore_down(bb->mutex);
    16ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1702:	8b 40 04             	mov    0x4(%eax),%eax
    1705:	89 04 24             	mov    %eax,(%esp)
    1708:	e8 73 f7 ff ff       	call   e80 <binary_semaphore_down>
  ans = bb->full->value;
    170d:	8b 45 08             	mov    0x8(%ebp),%eax
    1710:	8b 40 0c             	mov    0xc(%eax),%eax
    1713:	8b 40 08             	mov    0x8(%eax),%eax
    1716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  binary_semaphore_up(bb->mutex);
    1719:	8b 45 08             	mov    0x8(%ebp),%eax
    171c:	8b 40 04             	mov    0x4(%eax),%eax
    171f:	89 04 24             	mov    %eax,(%esp)
    1722:	e8 61 f7 ff ff       	call   e88 <binary_semaphore_up>
  semaphore_up(bb->empty);
    1727:	8b 45 08             	mov    0x8(%ebp),%eax
    172a:	8b 40 08             	mov    0x8(%eax),%eax
    172d:	89 04 24             	mov    %eax,(%esp)
    1730:	e8 f1 fc ff ff       	call   1426 <semaphore_up>
  return ans;
    1735:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1738:	c9                   	leave  
    1739:	c3                   	ret    
