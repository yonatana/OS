
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
       6:	a1 70 1f 00 00       	mov    0x1f70,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 0c 14 00 00       	call   141f <semaphore_down>
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
      1b:	a1 70 1f 00 00       	mov    0x1f70,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 4e 14 00 00       	call   1476 <semaphore_up>
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
      30:	a1 78 1f 00 00       	mov    0x1f78,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 a7 15 00 00       	call   15eb <BB_put>
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
      4c:	a1 78 1f 00 00       	mov    0x1f78,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 f7 15 00 00       	call   1650 <BB_pop>
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
      61:	a1 88 1f 00 00       	mov    0x1f88,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 76 15 00 00       	call   15eb <BB_put>
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
      7d:	a1 88 1f 00 00       	mov    0x1f88,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 c6 15 00 00       	call   1650 <BB_pop>
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
      92:	a1 a4 1f 00 00       	mov    0x1fa4,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 b1 15 00 00       	call   1650 <BB_pop>
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
      a7:	a1 a4 1f 00 00       	mov    0x1fa4,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 30 15 00 00       	call   15eb <BB_put>
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
      c3:	a1 7c 1f 00 00       	mov    0x1f7c,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 14 15 00 00       	call   15eb <BB_put>
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
      df:	a1 7c 1f 00 00       	mov    0x1f7c,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 64 15 00 00       	call   1650 <BB_pop>
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
      f9:	e8 aa 0d 00 00       	call   ea8 <thread_getId>
      fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i;
    for(i = 0; i < tid % 5; i++){
     101:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     108:	e9 0c 01 00 00       	jmp    219 <student+0x12b>
      printf(1,"Student %d is for i: %d\n",tid,i+1);
     10d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     110:	83 c0 01             	add    $0x1,%eax
     113:	89 44 24 0c          	mov    %eax,0xc(%esp)
     117:	8b 45 f0             	mov    -0x10(%ebp),%eax
     11a:	89 44 24 08          	mov    %eax,0x8(%esp)
     11e:	c7 44 24 04 68 17 00 	movl   $0x1768,0x4(%esp)
     125:	00 
     126:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     12d:	e8 85 0e 00 00       	call   fb7 <printf>
      struct Action* drink_action = malloc(sizeof(struct Action));
     132:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     139:	e8 5d 11 00 00       	call   129b <malloc>
     13e:	89 45 ec             	mov    %eax,-0x14(%ebp)
      memset(drink_action,0,sizeof(struct Action));
     141:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     148:	00 
     149:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     150:	00 
     151:	8b 45 ec             	mov    -0x14(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 ff 0a 00 00       	call   c5b <memset>
      drink_action->action_type = DRINK_ORDER;
     15c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     15f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      drink_action->cup = 0;
     165:	8b 45 ec             	mov    -0x14(%ebp),%eax
     168:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
      drink_action->tid = tid;
     16f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     172:	8b 55 f0             	mov    -0x10(%ebp),%edx
     175:	89 50 08             	mov    %edx,0x8(%eax)
      place_action(drink_action);//Order a Drink
     178:	8b 45 ec             	mov    -0x14(%ebp),%eax
     17b:	89 04 24             	mov    %eax,(%esp)
     17e:	e8 a7 fe ff ff       	call   2a <place_action>
      struct Cup * cup = get_drink();	//get the drink from the BB
     183:	e8 ef fe ff ff       	call   77 <get_drink>
     188:	89 45 e8             	mov    %eax,-0x18(%ebp)
      //need to write to file intsead of screen TODO
      printf(1,"Student %d is having his %d drink, with cup %d\n",tid,i+1,cup->id);
     18b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     18e:	8b 00                	mov    (%eax),%eax
     190:	8b 55 f4             	mov    -0xc(%ebp),%edx
     193:	83 c2 01             	add    $0x1,%edx
     196:	89 44 24 10          	mov    %eax,0x10(%esp)
     19a:	89 54 24 0c          	mov    %edx,0xc(%esp)
     19e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1a1:	89 44 24 08          	mov    %eax,0x8(%esp)
     1a5:	c7 44 24 04 84 17 00 	movl   $0x1784,0x4(%esp)
     1ac:	00 
     1ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1b4:	e8 fe 0d 00 00       	call   fb7 <printf>
      sleep(1);
     1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1c0:	e8 cb 0c 00 00       	call   e90 <sleep>
      struct Action* return_action = malloc(sizeof(struct Action));
     1c5:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     1cc:	e8 ca 10 00 00       	call   129b <malloc>
     1d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      memset(return_action,0,sizeof(struct Action));
     1d4:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     1db:	00 
     1dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     1e3:	00 
     1e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1e7:	89 04 24             	mov    %eax,(%esp)
     1ea:	e8 6c 0a 00 00       	call   c5b <memset>
      return_action->action_type = RETURN_CUP;
     1ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f2:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
      return_action->cup=cup;
     1f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
     1fe:	89 50 04             	mov    %edx,0x4(%eax)
      return_action->tid = tid;
     201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     204:	8b 55 f0             	mov    -0x10(%ebp),%edx
     207:	89 50 08             	mov    %edx,0x8(%eax)
      place_action(return_action);
     20a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     20d:	89 04 24             	mov    %eax,(%esp)
     210:	e8 15 fe ff ff       	call   2a <place_action>
   

    enter_bar();
    int tid = thread_getId();
    int i;
    for(i = 0; i < tid % 5; i++){
     215:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     219:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     21c:	ba 67 66 66 66       	mov    $0x66666667,%edx
     221:	89 c8                	mov    %ecx,%eax
     223:	f7 ea                	imul   %edx
     225:	d1 fa                	sar    %edx
     227:	89 c8                	mov    %ecx,%eax
     229:	c1 f8 1f             	sar    $0x1f,%eax
     22c:	29 c2                	sub    %eax,%edx
     22e:	89 d0                	mov    %edx,%eax
     230:	c1 e0 02             	shl    $0x2,%eax
     233:	01 d0                	add    %edx,%eax
     235:	89 ca                	mov    %ecx,%edx
     237:	29 c2                	sub    %eax,%edx
     239:	3b 55 f4             	cmp    -0xc(%ebp),%edx
     23c:	0f 8f cb fe ff ff    	jg     10d <student+0x1f>
      return_action->cup=cup;
      return_action->tid = tid;
      place_action(return_action);
    }
    //need to write to file intsead of screen TODO
    printf(1,"Student %d is drunk, and trying to go home\n",thread_getId());
     242:	e8 61 0c 00 00       	call   ea8 <thread_getId>
     247:	89 44 24 08          	mov    %eax,0x8(%esp)
     24b:	c7 44 24 04 b4 17 00 	movl   $0x17b4,0x4(%esp)
     252:	00 
     253:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     25a:	e8 58 0d 00 00       	call   fb7 <printf>
    leave_bar();
     25f:	e8 b1 fd ff ff       	call   15 <leave_bar>
    thread_exit(0);
     264:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     26b:	e8 50 0c 00 00       	call   ec0 <thread_exit>
    return 0;
     270:	b8 00 00 00 00       	mov    $0x0,%eax
}
     275:	c9                   	leave  
     276:	c3                   	ret    

00000277 <bartender>:

//bartender simulation
void* bartender(){
     277:	55                   	push   %ebp
     278:	89 e5                	mov    %esp,%ebp
     27a:	83 ec 58             	sub    $0x58,%esp
    void* ret_val = 0;
     27d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int tid = thread_getId();
     284:	e8 1f 0c 00 00       	call   ea8 <thread_getId>
     289:	89 45 f0             	mov    %eax,-0x10(%ebp)
    double amount =0;
     28c:	d9 ee                	fldz   
     28e:	dd 5d e8             	fstpl  -0x18(%ebp)
    double buf_size =0;
     291:	d9 ee                	fldz   
     293:	dd 5d e0             	fstpl  -0x20(%ebp)
    for(;;){
	struct Action* bartender_action = get_action();	
     296:	e8 ab fd ff ff       	call   46 <get_action>
     29b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(bartender_action->action_type == DRINK_ORDER){
     29e:	8b 45 dc             	mov    -0x24(%ebp),%eax
     2a1:	8b 00                	mov    (%eax),%eax
     2a3:	83 f8 01             	cmp    $0x1,%eax
     2a6:	75 3c                	jne    2e4 <bartender+0x6d>
	    struct Cup* current_cup = get_clean_cup();
     2a8:	e8 df fd ff ff       	call   8c <get_clean_cup>
     2ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
	    //need to write to file intsead of screen TODO
	    printf(1,"Bartender %d is making drink with cup %d\n",tid,current_cup->id);
     2b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
     2b3:	8b 00                	mov    (%eax),%eax
     2b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
     2b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2bc:	89 44 24 08          	mov    %eax,0x8(%esp)
     2c0:	c7 44 24 04 e0 17 00 	movl   $0x17e0,0x4(%esp)
     2c7:	00 
     2c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2cf:	e8 e3 0c 00 00       	call   fb7 <printf>
	    serve_drink(current_cup);
     2d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
     2d7:	89 04 24             	mov    %eax,(%esp)
     2da:	e8 7c fd ff ff       	call   5b <serve_drink>
     2df:	e9 c4 00 00 00       	jmp    3a8 <bartender+0x131>
	}
	else if(bartender_action->action_type == RETURN_CUP){
     2e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     2e7:	8b 00                	mov    (%eax),%eax
     2e9:	83 f8 02             	cmp    $0x2,%eax
     2ec:	0f 85 b6 00 00 00    	jne    3a8 <bartender+0x131>
	  struct Cup* current_cup = bartender_action->cup;  
     2f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
     2f5:	8b 40 04             	mov    0x4(%eax),%eax
     2f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	  return_cup(current_cup);
     2fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     2fe:	89 04 24             	mov    %eax,(%esp)
     301:	e8 b7 fd ff ff       	call   bd <return_cup>
	  //need to write to file intsead of screen TODO
	  printf(1,"Bartender %d returned cup %d\n",tid,current_cup->id);
     306:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     309:	8b 00                	mov    (%eax),%eax
     30b:	89 44 24 0c          	mov    %eax,0xc(%esp)
     30f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     312:	89 44 24 08          	mov    %eax,0x8(%esp)
     316:	c7 44 24 04 0a 18 00 	movl   $0x180a,0x4(%esp)
     31d:	00 
     31e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     325:	e8 8d 0c 00 00       	call   fb7 <printf>
	  
	  amount = DBB->full->value;
     32a:	a1 7c 1f 00 00       	mov    0x1f7c,%eax
     32f:	8b 40 0c             	mov    0xc(%eax),%eax
     332:	8b 40 08             	mov    0x8(%eax),%eax
     335:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     338:	db 45 c4             	fildl  -0x3c(%ebp)
     33b:	dd 5d e8             	fstpl  -0x18(%ebp)
	  buf_size = DBB->buffer_size;
     33e:	a1 7c 1f 00 00       	mov    0x1f7c,%eax
     343:	8b 00                	mov    (%eax),%eax
     345:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     348:	db 45 c4             	fildl  -0x3c(%ebp)
     34b:	dd 5d e0             	fstpl  -0x20(%ebp)
	  
	  if(amount/buf_size >= 0.6){
     34e:	dd 45 e8             	fldl   -0x18(%ebp)
     351:	dc 75 e0             	fdivl  -0x20(%ebp)
     354:	dd 05 60 19 00 00    	fldl   0x1960
     35a:	d9 c9                	fxch   %st(1)
     35c:	df e9                	fucomip %st(1),%st
     35e:	dd d8                	fstp   %st(0)
     360:	0f 93 c0             	setae  %al
     363:	84 c0                	test   %al,%al
     365:	74 21                	je     388 <bartender+0x111>
	    printf(1,"Go Clean Boy %d\n");
     367:	c7 44 24 04 28 18 00 	movl   $0x1828,0x4(%esp)
     36e:	00 
     36f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     376:	e8 3c 0c 00 00       	call   fb7 <printf>
	    binary_semaphore_up(cup_boy_lock);
     37b:	a1 a0 1f 00 00       	mov    0x1fa0,%eax
     380:	89 04 24             	mov    %eax,(%esp)
     383:	e8 50 0b 00 00       	call   ed8 <binary_semaphore_up>
	    }
	if(bartender_action->action_type == GO_HOME){
     388:	8b 45 dc             	mov    -0x24(%ebp),%eax
     38b:	8b 00                	mov    (%eax),%eax
     38d:	83 f8 03             	cmp    $0x3,%eax
     390:	75 16                	jne    3a8 <bartender+0x131>
	  free(bartender_action);
     392:	8b 45 dc             	mov    -0x24(%ebp),%eax
     395:	89 04 24             	mov    %eax,(%esp)
     398:	e8 cf 0d 00 00       	call   116c <free>
	  thread_exit(ret_val);
     39d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3a0:	89 04 24             	mov    %eax,(%esp)
     3a3:	e8 18 0b 00 00       	call   ec0 <thread_exit>
	}
      }
	free(bartender_action);
     3a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
     3ab:	89 04 24             	mov    %eax,(%esp)
     3ae:	e8 b9 0d 00 00       	call   116c <free>
    }
     3b3:	e9 de fe ff ff       	jmp    296 <bartender+0x1f>

000003b8 <cup_boy>:
    return 0;
}


// Cup boy simulation
void* cup_boy(void){
     3b8:	55                   	push   %ebp
     3b9:	89 e5                	mov    %esp,%ebp
     3bb:	83 ec 28             	sub    $0x28,%esp
  void* ret_val = 0;
     3be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
   printf(1,"Clean Boy came to work\n");
     3c5:	c7 44 24 04 39 18 00 	movl   $0x1839,0x4(%esp)
     3cc:	00 
     3cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3d4:	e8 de 0b 00 00       	call   fb7 <printf>
  cup_boy_lock = binary_semaphore_create(0);
     3d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3e0:	e8 e3 0a 00 00       	call   ec8 <binary_semaphore_create>
     3e5:	a3 a0 1f 00 00       	mov    %eax,0x1fa0
  int i,n;
  for(;;){
    printf(1,"finished_shift: %d\n", finished_shift);
     3ea:	a1 74 1f 00 00       	mov    0x1f74,%eax
     3ef:	89 44 24 08          	mov    %eax,0x8(%esp)
     3f3:	c7 44 24 04 51 18 00 	movl   $0x1851,0x4(%esp)
     3fa:	00 
     3fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     402:	e8 b0 0b 00 00       	call   fb7 <printf>
    if(finished_shift){
     407:	a1 74 1f 00 00       	mov    0x1f74,%eax
     40c:	85 c0                	test   %eax,%eax
     40e:	74 1f                	je     42f <cup_boy+0x77>
     printf(1,"Clean Boy- dead\n");
     410:	c7 44 24 04 65 18 00 	movl   $0x1865,0x4(%esp)
     417:	00 
     418:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     41f:	e8 93 0b 00 00       	call   fb7 <printf>
      thread_exit(ret_val);
     424:	8b 45 f0             	mov    -0x10(%ebp),%eax
     427:	89 04 24             	mov    %eax,(%esp)
     42a:	e8 91 0a 00 00       	call   ec0 <thread_exit>
    }

    n =DBB->full->value;
     42f:	a1 7c 1f 00 00       	mov    0x1f7c,%eax
     434:	8b 40 0c             	mov    0xc(%eax),%eax
     437:	8b 40 08             	mov    0x8(%eax),%eax
     43a:	89 45 ec             	mov    %eax,-0x14(%ebp)
   
    
    for(i = 1; i < n; i++){
     43d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     444:	eb 40                	jmp    486 <cup_boy+0xce>
	struct Cup* current_cup = wash_dirty();
     446:	e8 8e fc ff ff       	call   d9 <wash_dirty>
     44b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sleep(1);
     44e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     455:	e8 36 0a 00 00       	call   e90 <sleep>
	add_clean_cup(current_cup);
     45a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     45d:	89 04 24             	mov    %eax,(%esp)
     460:	e8 3c fc ff ff       	call   a1 <add_clean_cup>
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
     465:	8b 45 e8             	mov    -0x18(%ebp),%eax
     468:	8b 00                	mov    (%eax),%eax
     46a:	89 44 24 08          	mov    %eax,0x8(%esp)
     46e:	c7 44 24 04 76 18 00 	movl   $0x1876,0x4(%esp)
     475:	00 
     476:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     47d:	e8 35 0b 00 00       	call   fb7 <printf>
    }

    n =DBB->full->value;
   
    
    for(i = 1; i < n; i++){
     482:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     486:	8b 45 f4             	mov    -0xc(%ebp),%eax
     489:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     48c:	7c b8                	jl     446 <cup_boy+0x8e>
	sleep(1);
	add_clean_cup(current_cup);
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
    }
   printf(1,"Clean Boy- sleep\n");
     48e:	c7 44 24 04 92 18 00 	movl   $0x1892,0x4(%esp)
     495:	00 
     496:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     49d:	e8 15 0b 00 00       	call   fb7 <printf>
   binary_semaphore_down(cup_boy_lock); 
     4a2:	a1 a0 1f 00 00       	mov    0x1fa0,%eax
     4a7:	89 04 24             	mov    %eax,(%esp)
     4aa:	e8 21 0a 00 00       	call   ed0 <binary_semaphore_down>
   printf(1,"Clean Boy- awake\n");
     4af:	c7 44 24 04 a4 18 00 	movl   $0x18a4,0x4(%esp)
     4b6:	00 
     4b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4be:	e8 f4 0a 00 00       	call   fb7 <printf>
  }
     4c3:	e9 22 ff ff ff       	jmp    3ea <cup_boy+0x32>

000004c8 <join_peoples>:
  return ret_val;
}

// thread_joins on students and bartenders

void join_peoples(int* tids,int num_of_peoples){
     4c8:	55                   	push   %ebp
     4c9:	89 e5                	mov    %esp,%ebp
     4cb:	83 ec 28             	sub    $0x28,%esp
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     4ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4d5:	eb 1e                	jmp    4f5 <join_peoples+0x2d>
    thread_join(tids[i],&ret_val);
     4d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4da:	c1 e0 02             	shl    $0x2,%eax
     4dd:	03 45 08             	add    0x8(%ebp),%eax
     4e0:	8b 00                	mov    (%eax),%eax
     4e2:	8d 55 f0             	lea    -0x10(%ebp),%edx
     4e5:	89 54 24 04          	mov    %edx,0x4(%esp)
     4e9:	89 04 24             	mov    %eax,(%esp)
     4ec:	e8 c7 09 00 00       	call   eb8 <thread_join>
// thread_joins on students and bartenders

void join_peoples(int* tids,int num_of_peoples){
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     4f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     4f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
     4fb:	7c da                	jl     4d7 <join_peoples+0xf>
    thread_join(tids[i],&ret_val);
  }
}
     4fd:	c9                   	leave  
     4fe:	c3                   	ret    

000004ff <values_array_index>:


//return the index to put the value {A, B, C, S, M}
//				     {0, 1, 2, 3, 4}
int values_array_index(char* input_buf, int char_index){
     4ff:	55                   	push   %ebp
     500:	89 e5                	mov    %esp,%ebp
 if(input_buf[char_index] == 'A')
     502:	8b 45 0c             	mov    0xc(%ebp),%eax
     505:	03 45 08             	add    0x8(%ebp),%eax
     508:	0f b6 00             	movzbl (%eax),%eax
     50b:	3c 41                	cmp    $0x41,%al
     50d:	75 07                	jne    516 <values_array_index+0x17>
   return 0;
     50f:	b8 00 00 00 00       	mov    $0x0,%eax
     514:	eb 55                	jmp    56b <values_array_index+0x6c>
 if(input_buf[char_index] == 'B')
     516:	8b 45 0c             	mov    0xc(%ebp),%eax
     519:	03 45 08             	add    0x8(%ebp),%eax
     51c:	0f b6 00             	movzbl (%eax),%eax
     51f:	3c 42                	cmp    $0x42,%al
     521:	75 07                	jne    52a <values_array_index+0x2b>
   return 1;
     523:	b8 01 00 00 00       	mov    $0x1,%eax
     528:	eb 41                	jmp    56b <values_array_index+0x6c>
 if(input_buf[char_index] == 'C')
     52a:	8b 45 0c             	mov    0xc(%ebp),%eax
     52d:	03 45 08             	add    0x8(%ebp),%eax
     530:	0f b6 00             	movzbl (%eax),%eax
     533:	3c 43                	cmp    $0x43,%al
     535:	75 07                	jne    53e <values_array_index+0x3f>
   return 2;
     537:	b8 02 00 00 00       	mov    $0x2,%eax
     53c:	eb 2d                	jmp    56b <values_array_index+0x6c>
 if(input_buf[char_index] == 'S')
     53e:	8b 45 0c             	mov    0xc(%ebp),%eax
     541:	03 45 08             	add    0x8(%ebp),%eax
     544:	0f b6 00             	movzbl (%eax),%eax
     547:	3c 53                	cmp    $0x53,%al
     549:	75 07                	jne    552 <values_array_index+0x53>
   return 3;
     54b:	b8 03 00 00 00       	mov    $0x3,%eax
     550:	eb 19                	jmp    56b <values_array_index+0x6c>
 if(input_buf[char_index] == 'M')
     552:	8b 45 0c             	mov    0xc(%ebp),%eax
     555:	03 45 08             	add    0x8(%ebp),%eax
     558:	0f b6 00             	movzbl (%eax),%eax
     55b:	3c 4d                	cmp    $0x4d,%al
     55d:	75 07                	jne    566 <values_array_index+0x67>
   return 4;
     55f:	b8 04 00 00 00       	mov    $0x4,%eax
     564:	eb 05                	jmp    56b <values_array_index+0x6c>
 //error
 return -1;
     566:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     56b:	5d                   	pop    %ebp
     56c:	c3                   	ret    

0000056d <parse_buffer>:

//parsing the configuration file
void parse_buffer(char* input_buf,int* values_array){
     56d:	55                   	push   %ebp
     56e:	89 e5                	mov    %esp,%ebp
     570:	53                   	push   %ebx
     571:	83 ec 24             	sub    $0x24,%esp
 int i;
 int num_of_chars = strlen(input_buf);
     574:	8b 45 08             	mov    0x8(%ebp),%eax
     577:	89 04 24             	mov    %eax,(%esp)
     57a:	e8 b7 06 00 00       	call   c36 <strlen>
     57f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     582:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     589:	eb 7e                	jmp    609 <parse_buffer+0x9c>
    if(input_buf[i] == 'A' || input_buf[i] == 'B' || input_buf[i] == 'C' || input_buf[i] == 'S' || input_buf[i] == 'M'){
     58b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     58e:	03 45 08             	add    0x8(%ebp),%eax
     591:	0f b6 00             	movzbl (%eax),%eax
     594:	3c 41                	cmp    $0x41,%al
     596:	74 34                	je     5cc <parse_buffer+0x5f>
     598:	8b 45 f4             	mov    -0xc(%ebp),%eax
     59b:	03 45 08             	add    0x8(%ebp),%eax
     59e:	0f b6 00             	movzbl (%eax),%eax
     5a1:	3c 42                	cmp    $0x42,%al
     5a3:	74 27                	je     5cc <parse_buffer+0x5f>
     5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a8:	03 45 08             	add    0x8(%ebp),%eax
     5ab:	0f b6 00             	movzbl (%eax),%eax
     5ae:	3c 43                	cmp    $0x43,%al
     5b0:	74 1a                	je     5cc <parse_buffer+0x5f>
     5b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5b5:	03 45 08             	add    0x8(%ebp),%eax
     5b8:	0f b6 00             	movzbl (%eax),%eax
     5bb:	3c 53                	cmp    $0x53,%al
     5bd:	74 0d                	je     5cc <parse_buffer+0x5f>
     5bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5c2:	03 45 08             	add    0x8(%ebp),%eax
     5c5:	0f b6 00             	movzbl (%eax),%eax
     5c8:	3c 4d                	cmp    $0x4d,%al
     5ca:	75 39                	jne    605 <parse_buffer+0x98>
       index = values_array_index(input_buf,i);
     5cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cf:	89 44 24 04          	mov    %eax,0x4(%esp)
     5d3:	8b 45 08             	mov    0x8(%ebp),%eax
     5d6:	89 04 24             	mov    %eax,(%esp)
     5d9:	e8 21 ff ff ff       	call   4ff <values_array_index>
     5de:	89 45 ec             	mov    %eax,-0x14(%ebp)
       temp_str = &input_buf[i];
     5e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5e4:	03 45 08             	add    0x8(%ebp),%eax
     5e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
       values_array[index] = atoi(temp_str+4);
     5ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ed:	c1 e0 02             	shl    $0x2,%eax
     5f0:	89 c3                	mov    %eax,%ebx
     5f2:	03 5d 0c             	add    0xc(%ebp),%ebx
     5f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     5f8:	83 c0 04             	add    $0x4,%eax
     5fb:	89 04 24             	mov    %eax,(%esp)
     5fe:	e8 6c 07 00 00       	call   d6f <atoi>
     603:	89 03                	mov    %eax,(%ebx)
void parse_buffer(char* input_buf,int* values_array){
 int i;
 int num_of_chars = strlen(input_buf);
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     605:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     609:	8b 45 f4             	mov    -0xc(%ebp),%eax
     60c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     60f:	0f 8c 76 ff ff ff    	jl     58b <parse_buffer+0x1e>
       index = values_array_index(input_buf,i);
       temp_str = &input_buf[i];
       values_array[index] = atoi(temp_str+4);
    }
 }
}
     615:	83 c4 24             	add    $0x24,%esp
     618:	5b                   	pop    %ebx
     619:	5d                   	pop    %ebp
     61a:	c3                   	ret    

0000061b <main>:


int main(int argc, char** argv) {
     61b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     61f:	83 e4 f0             	and    $0xfffffff0,%esp
     622:	ff 71 fc             	pushl  -0x4(%ecx)
     625:	55                   	push   %ebp
     626:	89 e5                	mov    %esp,%ebp
     628:	51                   	push   %ecx
     629:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  int M;	// maximum number of students that can be at the bar at once
  int fconf;
  int conf_size;
  struct stat bufstat;
  
  fconf = open("con.conf",O_RDONLY);
     62f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     636:	00 
     637:	c7 04 24 b6 18 00 00 	movl   $0x18b6,(%esp)
     63e:	e8 fd 07 00 00       	call   e40 <open>
     643:	89 45 f0             	mov    %eax,-0x10(%ebp)
  fstat(fconf,&bufstat);
     646:	8d 45 98             	lea    -0x68(%ebp),%eax
     649:	89 44 24 04          	mov    %eax,0x4(%esp)
     64d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     650:	89 04 24             	mov    %eax,(%esp)
     653:	e8 00 08 00 00       	call   e58 <fstat>
  conf_size = bufstat.size;
     658:	8b 45 a8             	mov    -0x58(%ebp),%eax
     65b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  char bufconf[conf_size];
     65e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     661:	8d 50 ff             	lea    -0x1(%eax),%edx
     664:	89 55 e8             	mov    %edx,-0x18(%ebp)
     667:	8d 50 0f             	lea    0xf(%eax),%edx
     66a:	b8 10 00 00 00       	mov    $0x10,%eax
     66f:	83 e8 01             	sub    $0x1,%eax
     672:	01 d0                	add    %edx,%eax
     674:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     67b:	00 00 00 
     67e:	ba 00 00 00 00       	mov    $0x0,%edx
     683:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     689:	6b c0 10             	imul   $0x10,%eax,%eax
     68c:	29 c4                	sub    %eax,%esp
     68e:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     692:	83 c0 0f             	add    $0xf,%eax
     695:	c1 e8 04             	shr    $0x4,%eax
     698:	c1 e0 04             	shl    $0x4,%eax
     69b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  read(fconf,bufconf,conf_size);
     69e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
     6a4:	89 54 24 08          	mov    %edx,0x8(%esp)
     6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
     6ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6af:	89 04 24             	mov    %eax,(%esp)
     6b2:	e8 61 07 00 00       	call   e18 <read>
  int inputs_parsed[5]; //{Aval, Bval, Cval, Sval, Mval}
  
  parse_buffer(bufconf, inputs_parsed);
     6b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6ba:	8d 55 84             	lea    -0x7c(%ebp),%edx
     6bd:	89 54 24 04          	mov    %edx,0x4(%esp)
     6c1:	89 04 24             	mov    %eax,(%esp)
     6c4:	e8 a4 fe ff ff       	call   56d <parse_buffer>
  A = inputs_parsed[0];
     6c9:	8b 45 84             	mov    -0x7c(%ebp),%eax
     6cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  B = inputs_parsed[1];
     6cf:	8b 45 88             	mov    -0x78(%ebp),%eax
     6d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  C = inputs_parsed[2];
     6d5:	8b 45 8c             	mov    -0x74(%ebp),%eax
     6d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  S = inputs_parsed[3];
     6db:	8b 45 90             	mov    -0x70(%ebp),%eax
     6de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  M = inputs_parsed[4];
     6e1:	8b 45 94             	mov    -0x6c(%ebp),%eax
     6e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  
  printf(1,"A: %d B: %d C: %d  S: %d M: %d\n",A,B,C,S,M);
     6e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
     6ea:	89 44 24 18          	mov    %eax,0x18(%esp)
     6ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     6f1:	89 44 24 14          	mov    %eax,0x14(%esp)
     6f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
     6f8:	89 44 24 10          	mov    %eax,0x10(%esp)
     6fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
     6ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
     703:	8b 45 e0             	mov    -0x20(%ebp),%eax
     706:	89 44 24 08          	mov    %eax,0x8(%esp)
     70a:	c7 44 24 04 c0 18 00 	movl   $0x18c0,0x4(%esp)
     711:	00 
     712:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     719:	e8 99 08 00 00       	call   fb7 <printf>
  
  void* students_stacks[S];
     71e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     721:	8d 50 ff             	lea    -0x1(%eax),%edx
     724:	89 55 cc             	mov    %edx,-0x34(%ebp)
     727:	c1 e0 02             	shl    $0x2,%eax
     72a:	8d 50 0f             	lea    0xf(%eax),%edx
     72d:	b8 10 00 00 00       	mov    $0x10,%eax
     732:	83 e8 01             	sub    $0x1,%eax
     735:	01 d0                	add    %edx,%eax
     737:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     73e:	00 00 00 
     741:	ba 00 00 00 00       	mov    $0x0,%edx
     746:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     74c:	6b c0 10             	imul   $0x10,%eax,%eax
     74f:	29 c4                	sub    %eax,%esp
     751:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     755:	83 c0 0f             	add    $0xf,%eax
     758:	c1 e8 04             	shr    $0x4,%eax
     75b:	c1 e0 04             	shl    $0x4,%eax
     75e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  void* bartenders_stacks[B];
     761:	8b 45 dc             	mov    -0x24(%ebp),%eax
     764:	8d 50 ff             	lea    -0x1(%eax),%edx
     767:	89 55 c4             	mov    %edx,-0x3c(%ebp)
     76a:	c1 e0 02             	shl    $0x2,%eax
     76d:	8d 50 0f             	lea    0xf(%eax),%edx
     770:	b8 10 00 00 00       	mov    $0x10,%eax
     775:	83 e8 01             	sub    $0x1,%eax
     778:	01 d0                	add    %edx,%eax
     77a:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     781:	00 00 00 
     784:	ba 00 00 00 00       	mov    $0x0,%edx
     789:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     78f:	6b c0 10             	imul   $0x10,%eax,%eax
     792:	29 c4                	sub    %eax,%esp
     794:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     798:	83 c0 0f             	add    $0xf,%eax
     79b:	c1 e8 04             	shr    $0x4,%eax
     79e:	c1 e0 04             	shl    $0x4,%eax
     7a1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  void* cup_boy_stack;
  int i;
  int student_tids[S];
     7a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7a7:	8d 50 ff             	lea    -0x1(%eax),%edx
     7aa:	89 55 bc             	mov    %edx,-0x44(%ebp)
     7ad:	c1 e0 02             	shl    $0x2,%eax
     7b0:	8d 50 0f             	lea    0xf(%eax),%edx
     7b3:	b8 10 00 00 00       	mov    $0x10,%eax
     7b8:	83 e8 01             	sub    $0x1,%eax
     7bb:	01 d0                	add    %edx,%eax
     7bd:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     7c4:	00 00 00 
     7c7:	ba 00 00 00 00       	mov    $0x0,%edx
     7cc:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     7d2:	6b c0 10             	imul   $0x10,%eax,%eax
     7d5:	29 c4                	sub    %eax,%esp
     7d7:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     7db:	83 c0 0f             	add    $0xf,%eax
     7de:	c1 e8 04             	shr    $0x4,%eax
     7e1:	c1 e0 04             	shl    $0x4,%eax
     7e4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  //int bartender_tids[B];
  finished_shift = 0; // cup_boy changes it to 1 if all students left the bar and sends Action => GO_HOME to bartenders
     7e7:	c7 05 74 1f 00 00 00 	movl   $0x0,0x1f74
     7ee:	00 00 00 

  
  file_to_write = open("out.txt",(O_CREATE | O_WRONLY)); //
     7f1:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     7f8:	00 
     7f9:	c7 04 24 e0 18 00 00 	movl   $0x18e0,(%esp)
     800:	e8 3b 06 00 00       	call   e40 <open>
     805:	a3 84 1f 00 00       	mov    %eax,0x1f84
  if(file_to_write == -1){
     80a:	a1 84 1f 00 00       	mov    0x1f84,%eax
     80f:	83 f8 ff             	cmp    $0xffffffff,%eax
     812:	75 19                	jne    82d <main+0x212>
      printf(1,"There was an error opening out.txt\n");
     814:	c7 44 24 04 e8 18 00 	movl   $0x18e8,0x4(%esp)
     81b:	00 
     81c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     823:	e8 8f 07 00 00       	call   fb7 <printf>
      exit();
     828:	e8 d3 05 00 00       	call   e00 <exit>
  }
  
  
  //Databases
   bouncer = semaphore_create(M);		//this is the bouncer to the Beinstein
     82d:	8b 45 d0             	mov    -0x30(%ebp),%eax
     830:	89 04 24             	mov    %eax,(%esp)
     833:	e8 44 0b 00 00       	call   137c <semaphore_create>
     838:	a3 70 1f 00 00       	mov    %eax,0x1f70
   ABB = BB_create(A); 				//this is a BB for student actions: drink, ans for a dring
     83d:	8b 45 e0             	mov    -0x20(%ebp),%eax
     840:	89 04 24             	mov    %eax,(%esp)
     843:	e8 8c 0c 00 00       	call   14d4 <BB_create>
     848:	a3 78 1f 00 00       	mov    %eax,0x1f78
   DrinkBB = BB_create(A);			//this is a BB holding the drinks that are ready to be drinking
     84d:	8b 45 e0             	mov    -0x20(%ebp),%eax
     850:	89 04 24             	mov    %eax,(%esp)
     853:	e8 7c 0c 00 00       	call   14d4 <BB_create>
     858:	a3 88 1f 00 00       	mov    %eax,0x1f88
   CBB = BB_create(C);				//this is a BB hold clean cups
     85d:	8b 45 d8             	mov    -0x28(%ebp),%eax
     860:	89 04 24             	mov    %eax,(%esp)
     863:	e8 6c 0c 00 00       	call   14d4 <BB_create>
     868:	a3 a4 1f 00 00       	mov    %eax,0x1fa4
   DBB = BB_create(C);				//this is a BB hold dirty cups
     86d:	8b 45 d8             	mov    -0x28(%ebp),%eax
     870:	89 04 24             	mov    %eax,(%esp)
     873:	e8 5c 0c 00 00       	call   14d4 <BB_create>
     878:	a3 7c 1f 00 00       	mov    %eax,0x1f7c
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
     87d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     884:	e8 3f 06 00 00       	call   ec8 <binary_semaphore_create>
     889:	a3 a0 1f 00 00       	mov    %eax,0x1fa0
   general_mutex = binary_semaphore_create(1);
     88e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     895:	e8 2e 06 00 00       	call   ec8 <binary_semaphore_create>
     89a:	a3 80 1f 00 00       	mov    %eax,0x1f80

   //initialize C clean cups
   struct Cup* cup_array[C];
     89f:	8b 45 d8             	mov    -0x28(%ebp),%eax
     8a2:	8d 50 ff             	lea    -0x1(%eax),%edx
     8a5:	89 55 b4             	mov    %edx,-0x4c(%ebp)
     8a8:	c1 e0 02             	shl    $0x2,%eax
     8ab:	8d 50 0f             	lea    0xf(%eax),%edx
     8ae:	b8 10 00 00 00       	mov    $0x10,%eax
     8b3:	83 e8 01             	sub    $0x1,%eax
     8b6:	01 d0                	add    %edx,%eax
     8b8:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     8bf:	00 00 00 
     8c2:	ba 00 00 00 00       	mov    $0x0,%edx
     8c7:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     8cd:	6b c0 10             	imul   $0x10,%eax,%eax
     8d0:	29 c4                	sub    %eax,%esp
     8d2:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     8d6:	83 c0 0f             	add    $0xf,%eax
     8d9:	c1 e8 04             	shr    $0x4,%eax
     8dc:	c1 e0 04             	shl    $0x4,%eax
     8df:	89 45 b0             	mov    %eax,-0x50(%ebp)
   for(i = 0; i < C; i++){
     8e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     8e9:	eb 38                	jmp    923 <main+0x308>
      cup_array[i] = malloc(sizeof(struct Cup)); //TODO free cups
     8eb:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     8f2:	e8 a4 09 00 00       	call   129b <malloc>
     8f7:	8b 55 b0             	mov    -0x50(%ebp),%edx
     8fa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     8fd:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      //memset(cup_array[i],0,sizeof(void*)*STACK_SIZE);
      cup_array[i]->id = i;
     900:	8b 45 b0             	mov    -0x50(%ebp),%eax
     903:	8b 55 f4             	mov    -0xc(%ebp),%edx
     906:	8b 04 90             	mov    (%eax,%edx,4),%eax
     909:	8b 55 f4             	mov    -0xc(%ebp),%edx
     90c:	89 10                	mov    %edx,(%eax)
      add_clean_cup(cup_array[i]);
     90e:	8b 45 b0             	mov    -0x50(%ebp),%eax
     911:	8b 55 f4             	mov    -0xc(%ebp),%edx
     914:	8b 04 90             	mov    (%eax,%edx,4),%eax
     917:	89 04 24             	mov    %eax,(%esp)
     91a:	e8 82 f7 ff ff       	call   a1 <add_clean_cup>
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
   general_mutex = binary_semaphore_create(1);

   //initialize C clean cups
   struct Cup* cup_array[C];
   for(i = 0; i < C; i++){
     91f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     923:	8b 45 f4             	mov    -0xc(%ebp),%eax
     926:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     929:	7c c0                	jl     8eb <main+0x2d0>
      cup_array[i]->id = i;
      add_clean_cup(cup_array[i]);
   }
   
   //initialize cup_boy
   cup_boy_stack = (void*)malloc(sizeof(void*)*STACK_SIZE);
     92b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     932:	e8 64 09 00 00       	call   129b <malloc>
     937:	89 45 ac             	mov    %eax,-0x54(%ebp)
   memset(cup_boy_stack,0,sizeof(void*)*STACK_SIZE);
     93a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     941:	00 
     942:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     949:	00 
     94a:	8b 45 ac             	mov    -0x54(%ebp),%eax
     94d:	89 04 24             	mov    %eax,(%esp)
     950:	e8 06 03 00 00       	call   c5b <memset>
   if(thread_create((void*)cup_boy,cup_boy_stack,sizeof(void*)*STACK_SIZE) < 0){
     955:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     95c:	00 
     95d:	8b 45 ac             	mov    -0x54(%ebp),%eax
     960:	89 44 24 04          	mov    %eax,0x4(%esp)
     964:	c7 04 24 b8 03 00 00 	movl   $0x3b8,(%esp)
     96b:	e8 30 05 00 00       	call   ea0 <thread_create>
     970:	85 c0                	test   %eax,%eax
     972:	79 19                	jns    98d <main+0x372>
     printf(2,"Failed to create cupboy thread. Exiting...\n");
     974:	c7 44 24 04 0c 19 00 	movl   $0x190c,0x4(%esp)
     97b:	00 
     97c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     983:	e8 2f 06 00 00       	call   fb7 <printf>
    exit();
     988:	e8 73 04 00 00       	call   e00 <exit>
   }
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     98d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     994:	eb 5b                	jmp    9f1 <main+0x3d6>
      bartenders_stacks[i] = (void*)malloc(sizeof(void*)*STACK_SIZE);
     996:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     99d:	e8 f9 08 00 00       	call   129b <malloc>
     9a2:	8b 55 c0             	mov    -0x40(%ebp),%edx
     9a5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     9a8:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(bartenders_stacks[i],0,sizeof(void*)*STACK_SIZE);
     9ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
     9ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9b1:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9b4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     9bb:	00 
     9bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     9c3:	00 
     9c4:	89 04 24             	mov    %eax,(%esp)
     9c7:	e8 8f 02 00 00       	call   c5b <memset>
     thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
     9cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
     9cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9d2:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9d5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     9dc:	00 
     9dd:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e1:	c7 04 24 77 02 00 00 	movl   $0x277,(%esp)
     9e8:	e8 b3 04 00 00       	call   ea0 <thread_create>
     printf(2,"Failed to create cupboy thread. Exiting...\n");
    exit();
   }
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     9ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     9f7:	7c 9d                	jl     996 <main+0x37b>
     thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
      //bartender_tids[i] = 
  }
   
   //initialize S students
   for(i = 0; i < S; i++){//TODO test for fail
     9f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a00:	eb 64                	jmp    a66 <main+0x44b>
      students_stacks[i] = malloc(sizeof(void*)*STACK_SIZE);
     a02:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     a09:	e8 8d 08 00 00       	call   129b <malloc>
     a0e:	8b 55 c8             	mov    -0x38(%ebp),%edx
     a11:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a14:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
     a17:	8b 45 c8             	mov    -0x38(%ebp),%eax
     a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a1d:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a20:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     a27:	00 
     a28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     a2f:	00 
     a30:	89 04 24             	mov    %eax,(%esp)
     a33:	e8 23 02 00 00       	call   c5b <memset>
      student_tids[i] = thread_create((void*)student,students_stacks[i],sizeof(void*)*STACK_SIZE);
     a38:	8b 45 c8             	mov    -0x38(%ebp),%eax
     a3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a3e:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a41:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     a48:	00 
     a49:	89 44 24 04          	mov    %eax,0x4(%esp)
     a4d:	c7 04 24 ee 00 00 00 	movl   $0xee,(%esp)
     a54:	e8 47 04 00 00       	call   ea0 <thread_create>
     a59:	8b 55 b8             	mov    -0x48(%ebp),%edx
     a5c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a5f:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
      //bartender_tids[i] = 
  }
   
   //initialize S students
   for(i = 0; i < S; i++){//TODO test for fail
     a62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a69:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     a6c:	7c 94                	jl     a02 <main+0x3e7>
      students_stacks[i] = malloc(sizeof(void*)*STACK_SIZE);
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
      student_tids[i] = thread_create((void*)student,students_stacks[i],sizeof(void*)*STACK_SIZE);
  }
  
   join_peoples(student_tids,S); //join students
     a6e:	8b 45 b8             	mov    -0x48(%ebp),%eax
     a71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     a74:	89 54 24 04          	mov    %edx,0x4(%esp)
     a78:	89 04 24             	mov    %eax,(%esp)
     a7b:	e8 48 fa ff ff       	call   4c8 <join_peoples>
   finished_shift = 1;
     a80:	c7 05 74 1f 00 00 01 	movl   $0x1,0x1f74
     a87:	00 00 00 
    
    
   //join_peoples(bartender_tids,B); //join bartenders
   sleep(2); // delay so exit will not come before threads finished TODO (need better soloution)
     a8a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     a91:	e8 fa 03 00 00       	call   e90 <sleep>
   
   
   if(finished_shift){
     a96:	a1 74 1f 00 00       	mov    0x1f74,%eax
     a9b:	85 c0                	test   %eax,%eax
     a9d:	74 0d                	je     aac <main+0x491>
      binary_semaphore_up(cup_boy_lock); 
     a9f:	a1 a0 1f 00 00       	mov    0x1fa0,%eax
     aa4:	89 04 24             	mov    %eax,(%esp)
     aa7:	e8 2c 04 00 00       	call   ed8 <binary_semaphore_up>
    }
    
    
   if(close(file_to_write) == -1){
     aac:	a1 84 1f 00 00       	mov    0x1f84,%eax
     ab1:	89 04 24             	mov    %eax,(%esp)
     ab4:	e8 6f 03 00 00       	call   e28 <close>
     ab9:	83 f8 ff             	cmp    $0xffffffff,%eax
     abc:	75 19                	jne    ad7 <main+0x4bc>
    printf(1,"There was an error closing out.txt\n");
     abe:	c7 44 24 04 38 19 00 	movl   $0x1938,0x4(%esp)
     ac5:	00 
     ac6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     acd:	e8 e5 04 00 00       	call   fb7 <printf>
    exit();
     ad2:	e8 29 03 00 00       	call   e00 <exit>
   }
   
  //free cup_boy_stack
  free(cup_boy_stack);
     ad7:	8b 45 ac             	mov    -0x54(%ebp),%eax
     ada:	89 04 24             	mov    %eax,(%esp)
     add:	e8 8a 06 00 00       	call   116c <free>
  
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     ae2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ae9:	eb 15                	jmp    b00 <main+0x4e5>
    free(cup_array[i]);
     aeb:	8b 45 b0             	mov    -0x50(%ebp),%eax
     aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
     af1:	8b 04 90             	mov    (%eax,%edx,4),%eax
     af4:	89 04 24             	mov    %eax,(%esp)
     af7:	e8 70 06 00 00       	call   116c <free>
  //free cup_boy_stack
  free(cup_boy_stack);
  
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     afc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b03:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     b06:	7c e3                	jl     aeb <main+0x4d0>
    free(cup_array[i]);
  }
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     b08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b0f:	eb 15                	jmp    b26 <main+0x50b>
   free(bartenders_stacks[i]); 
     b11:	8b 45 c0             	mov    -0x40(%ebp),%eax
     b14:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b17:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b1a:	89 04 24             	mov    %eax,(%esp)
     b1d:	e8 4a 06 00 00       	call   116c <free>
  //free cups
  for(i = 0; i < C; i++){
    free(cup_array[i]);
  }
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     b22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b29:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     b2c:	7c e3                	jl     b11 <main+0x4f6>
   free(bartenders_stacks[i]); 
  }
  //free students_stacks
  for(i = 0; i < S; i++){
     b2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b35:	eb 15                	jmp    b4c <main+0x531>
   free(students_stacks[i]); 
     b37:	8b 45 c8             	mov    -0x38(%ebp),%eax
     b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b3d:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b40:	89 04 24             	mov    %eax,(%esp)
     b43:	e8 24 06 00 00       	call   116c <free>
  //free bartenders_stacks
  for(i = 0; i < B; i++){
   free(bartenders_stacks[i]); 
  }
  //free students_stacks
  for(i = 0; i < S; i++){
     b48:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b4f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     b52:	7c e3                	jl     b37 <main+0x51c>
   free(students_stacks[i]); 
  }
  semaphore_free(bouncer);
     b54:	a1 70 1f 00 00       	mov    0x1f70,%eax
     b59:	89 04 24             	mov    %eax,(%esp)
     b5c:	e8 5f 09 00 00       	call   14c0 <semaphore_free>
  BB_free(ABB);
     b61:	a1 78 1f 00 00       	mov    0x1f78,%eax
     b66:	89 04 24             	mov    %eax,(%esp)
     b69:	e8 b8 0b 00 00       	call   1726 <BB_free>
  BB_free(DrinkBB);
     b6e:	a1 88 1f 00 00       	mov    0x1f88,%eax
     b73:	89 04 24             	mov    %eax,(%esp)
     b76:	e8 ab 0b 00 00       	call   1726 <BB_free>
  BB_free(CBB);
     b7b:	a1 a4 1f 00 00       	mov    0x1fa4,%eax
     b80:	89 04 24             	mov    %eax,(%esp)
     b83:	e8 9e 0b 00 00       	call   1726 <BB_free>
  BB_free(DBB);
     b88:	a1 7c 1f 00 00       	mov    0x1f7c,%eax
     b8d:	89 04 24             	mov    %eax,(%esp)
     b90:	e8 91 0b 00 00       	call   1726 <BB_free>
 
  exit();
     b95:	e8 66 02 00 00       	call   e00 <exit>
     b9a:	90                   	nop
     b9b:	90                   	nop

00000b9c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     b9c:	55                   	push   %ebp
     b9d:	89 e5                	mov    %esp,%ebp
     b9f:	57                   	push   %edi
     ba0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     ba1:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ba4:	8b 55 10             	mov    0x10(%ebp),%edx
     ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
     baa:	89 cb                	mov    %ecx,%ebx
     bac:	89 df                	mov    %ebx,%edi
     bae:	89 d1                	mov    %edx,%ecx
     bb0:	fc                   	cld    
     bb1:	f3 aa                	rep stos %al,%es:(%edi)
     bb3:	89 ca                	mov    %ecx,%edx
     bb5:	89 fb                	mov    %edi,%ebx
     bb7:	89 5d 08             	mov    %ebx,0x8(%ebp)
     bba:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     bbd:	5b                   	pop    %ebx
     bbe:	5f                   	pop    %edi
     bbf:	5d                   	pop    %ebp
     bc0:	c3                   	ret    

00000bc1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     bc1:	55                   	push   %ebp
     bc2:	89 e5                	mov    %esp,%ebp
     bc4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     bc7:	8b 45 08             	mov    0x8(%ebp),%eax
     bca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     bcd:	90                   	nop
     bce:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd1:	0f b6 10             	movzbl (%eax),%edx
     bd4:	8b 45 08             	mov    0x8(%ebp),%eax
     bd7:	88 10                	mov    %dl,(%eax)
     bd9:	8b 45 08             	mov    0x8(%ebp),%eax
     bdc:	0f b6 00             	movzbl (%eax),%eax
     bdf:	84 c0                	test   %al,%al
     be1:	0f 95 c0             	setne  %al
     be4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     be8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     bec:	84 c0                	test   %al,%al
     bee:	75 de                	jne    bce <strcpy+0xd>
    ;
  return os;
     bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     bf3:	c9                   	leave  
     bf4:	c3                   	ret    

00000bf5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bf5:	55                   	push   %ebp
     bf6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     bf8:	eb 08                	jmp    c02 <strcmp+0xd>
    p++, q++;
     bfa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     bfe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     c02:	8b 45 08             	mov    0x8(%ebp),%eax
     c05:	0f b6 00             	movzbl (%eax),%eax
     c08:	84 c0                	test   %al,%al
     c0a:	74 10                	je     c1c <strcmp+0x27>
     c0c:	8b 45 08             	mov    0x8(%ebp),%eax
     c0f:	0f b6 10             	movzbl (%eax),%edx
     c12:	8b 45 0c             	mov    0xc(%ebp),%eax
     c15:	0f b6 00             	movzbl (%eax),%eax
     c18:	38 c2                	cmp    %al,%dl
     c1a:	74 de                	je     bfa <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     c1c:	8b 45 08             	mov    0x8(%ebp),%eax
     c1f:	0f b6 00             	movzbl (%eax),%eax
     c22:	0f b6 d0             	movzbl %al,%edx
     c25:	8b 45 0c             	mov    0xc(%ebp),%eax
     c28:	0f b6 00             	movzbl (%eax),%eax
     c2b:	0f b6 c0             	movzbl %al,%eax
     c2e:	89 d1                	mov    %edx,%ecx
     c30:	29 c1                	sub    %eax,%ecx
     c32:	89 c8                	mov    %ecx,%eax
}
     c34:	5d                   	pop    %ebp
     c35:	c3                   	ret    

00000c36 <strlen>:

uint
strlen(char *s)
{
     c36:	55                   	push   %ebp
     c37:	89 e5                	mov    %esp,%ebp
     c39:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     c3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     c43:	eb 04                	jmp    c49 <strlen+0x13>
     c45:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     c49:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c4c:	03 45 08             	add    0x8(%ebp),%eax
     c4f:	0f b6 00             	movzbl (%eax),%eax
     c52:	84 c0                	test   %al,%al
     c54:	75 ef                	jne    c45 <strlen+0xf>
    ;
  return n;
     c56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     c59:	c9                   	leave  
     c5a:	c3                   	ret    

00000c5b <memset>:

void*
memset(void *dst, int c, uint n)
{
     c5b:	55                   	push   %ebp
     c5c:	89 e5                	mov    %esp,%ebp
     c5e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     c61:	8b 45 10             	mov    0x10(%ebp),%eax
     c64:	89 44 24 08          	mov    %eax,0x8(%esp)
     c68:	8b 45 0c             	mov    0xc(%ebp),%eax
     c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
     c6f:	8b 45 08             	mov    0x8(%ebp),%eax
     c72:	89 04 24             	mov    %eax,(%esp)
     c75:	e8 22 ff ff ff       	call   b9c <stosb>
  return dst;
     c7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c7d:	c9                   	leave  
     c7e:	c3                   	ret    

00000c7f <strchr>:

char*
strchr(const char *s, char c)
{
     c7f:	55                   	push   %ebp
     c80:	89 e5                	mov    %esp,%ebp
     c82:	83 ec 04             	sub    $0x4,%esp
     c85:	8b 45 0c             	mov    0xc(%ebp),%eax
     c88:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     c8b:	eb 14                	jmp    ca1 <strchr+0x22>
    if(*s == c)
     c8d:	8b 45 08             	mov    0x8(%ebp),%eax
     c90:	0f b6 00             	movzbl (%eax),%eax
     c93:	3a 45 fc             	cmp    -0x4(%ebp),%al
     c96:	75 05                	jne    c9d <strchr+0x1e>
      return (char*)s;
     c98:	8b 45 08             	mov    0x8(%ebp),%eax
     c9b:	eb 13                	jmp    cb0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     c9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     ca1:	8b 45 08             	mov    0x8(%ebp),%eax
     ca4:	0f b6 00             	movzbl (%eax),%eax
     ca7:	84 c0                	test   %al,%al
     ca9:	75 e2                	jne    c8d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
     cb0:	c9                   	leave  
     cb1:	c3                   	ret    

00000cb2 <gets>:

char*
gets(char *buf, int max)
{
     cb2:	55                   	push   %ebp
     cb3:	89 e5                	mov    %esp,%ebp
     cb5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cbf:	eb 44                	jmp    d05 <gets+0x53>
    cc = read(0, &c, 1);
     cc1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     cc8:	00 
     cc9:	8d 45 ef             	lea    -0x11(%ebp),%eax
     ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
     cd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     cd7:	e8 3c 01 00 00       	call   e18 <read>
     cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     cdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ce3:	7e 2d                	jle    d12 <gets+0x60>
      break;
    buf[i++] = c;
     ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ce8:	03 45 08             	add    0x8(%ebp),%eax
     ceb:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     cef:	88 10                	mov    %dl,(%eax)
     cf1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     cf5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     cf9:	3c 0a                	cmp    $0xa,%al
     cfb:	74 16                	je     d13 <gets+0x61>
     cfd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     d01:	3c 0d                	cmp    $0xd,%al
     d03:	74 0e                	je     d13 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d08:	83 c0 01             	add    $0x1,%eax
     d0b:	3b 45 0c             	cmp    0xc(%ebp),%eax
     d0e:	7c b1                	jl     cc1 <gets+0xf>
     d10:	eb 01                	jmp    d13 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     d12:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d16:	03 45 08             	add    0x8(%ebp),%eax
     d19:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     d1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d1f:	c9                   	leave  
     d20:	c3                   	ret    

00000d21 <stat>:

int
stat(char *n, struct stat *st)
{
     d21:	55                   	push   %ebp
     d22:	89 e5                	mov    %esp,%ebp
     d24:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d27:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     d2e:	00 
     d2f:	8b 45 08             	mov    0x8(%ebp),%eax
     d32:	89 04 24             	mov    %eax,(%esp)
     d35:	e8 06 01 00 00       	call   e40 <open>
     d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     d3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d41:	79 07                	jns    d4a <stat+0x29>
    return -1;
     d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d48:	eb 23                	jmp    d6d <stat+0x4c>
  r = fstat(fd, st);
     d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
     d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
     d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d54:	89 04 24             	mov    %eax,(%esp)
     d57:	e8 fc 00 00 00       	call   e58 <fstat>
     d5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d62:	89 04 24             	mov    %eax,(%esp)
     d65:	e8 be 00 00 00       	call   e28 <close>
  return r;
     d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     d6d:	c9                   	leave  
     d6e:	c3                   	ret    

00000d6f <atoi>:

int
atoi(const char *s)
{
     d6f:	55                   	push   %ebp
     d70:	89 e5                	mov    %esp,%ebp
     d72:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     d75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     d7c:	eb 23                	jmp    da1 <atoi+0x32>
    n = n*10 + *s++ - '0';
     d7e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d81:	89 d0                	mov    %edx,%eax
     d83:	c1 e0 02             	shl    $0x2,%eax
     d86:	01 d0                	add    %edx,%eax
     d88:	01 c0                	add    %eax,%eax
     d8a:	89 c2                	mov    %eax,%edx
     d8c:	8b 45 08             	mov    0x8(%ebp),%eax
     d8f:	0f b6 00             	movzbl (%eax),%eax
     d92:	0f be c0             	movsbl %al,%eax
     d95:	01 d0                	add    %edx,%eax
     d97:	83 e8 30             	sub    $0x30,%eax
     d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
     d9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     da1:	8b 45 08             	mov    0x8(%ebp),%eax
     da4:	0f b6 00             	movzbl (%eax),%eax
     da7:	3c 2f                	cmp    $0x2f,%al
     da9:	7e 0a                	jle    db5 <atoi+0x46>
     dab:	8b 45 08             	mov    0x8(%ebp),%eax
     dae:	0f b6 00             	movzbl (%eax),%eax
     db1:	3c 39                	cmp    $0x39,%al
     db3:	7e c9                	jle    d7e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     db5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     db8:	c9                   	leave  
     db9:	c3                   	ret    

00000dba <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     dba:	55                   	push   %ebp
     dbb:	89 e5                	mov    %esp,%ebp
     dbd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     dc0:	8b 45 08             	mov    0x8(%ebp),%eax
     dc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
     dc9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     dcc:	eb 13                	jmp    de1 <memmove+0x27>
    *dst++ = *src++;
     dce:	8b 45 f8             	mov    -0x8(%ebp),%eax
     dd1:	0f b6 10             	movzbl (%eax),%edx
     dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     dd7:	88 10                	mov    %dl,(%eax)
     dd9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     ddd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     de1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     de5:	0f 9f c0             	setg   %al
     de8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     dec:	84 c0                	test   %al,%al
     dee:	75 de                	jne    dce <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
     df3:	c9                   	leave  
     df4:	c3                   	ret    
     df5:	90                   	nop
     df6:	90                   	nop
     df7:	90                   	nop

00000df8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     df8:	b8 01 00 00 00       	mov    $0x1,%eax
     dfd:	cd 40                	int    $0x40
     dff:	c3                   	ret    

00000e00 <exit>:
SYSCALL(exit)
     e00:	b8 02 00 00 00       	mov    $0x2,%eax
     e05:	cd 40                	int    $0x40
     e07:	c3                   	ret    

00000e08 <wait>:
SYSCALL(wait)
     e08:	b8 03 00 00 00       	mov    $0x3,%eax
     e0d:	cd 40                	int    $0x40
     e0f:	c3                   	ret    

00000e10 <pipe>:
SYSCALL(pipe)
     e10:	b8 04 00 00 00       	mov    $0x4,%eax
     e15:	cd 40                	int    $0x40
     e17:	c3                   	ret    

00000e18 <read>:
SYSCALL(read)
     e18:	b8 05 00 00 00       	mov    $0x5,%eax
     e1d:	cd 40                	int    $0x40
     e1f:	c3                   	ret    

00000e20 <write>:
SYSCALL(write)
     e20:	b8 10 00 00 00       	mov    $0x10,%eax
     e25:	cd 40                	int    $0x40
     e27:	c3                   	ret    

00000e28 <close>:
SYSCALL(close)
     e28:	b8 15 00 00 00       	mov    $0x15,%eax
     e2d:	cd 40                	int    $0x40
     e2f:	c3                   	ret    

00000e30 <kill>:
SYSCALL(kill)
     e30:	b8 06 00 00 00       	mov    $0x6,%eax
     e35:	cd 40                	int    $0x40
     e37:	c3                   	ret    

00000e38 <exec>:
SYSCALL(exec)
     e38:	b8 07 00 00 00       	mov    $0x7,%eax
     e3d:	cd 40                	int    $0x40
     e3f:	c3                   	ret    

00000e40 <open>:
SYSCALL(open)
     e40:	b8 0f 00 00 00       	mov    $0xf,%eax
     e45:	cd 40                	int    $0x40
     e47:	c3                   	ret    

00000e48 <mknod>:
SYSCALL(mknod)
     e48:	b8 11 00 00 00       	mov    $0x11,%eax
     e4d:	cd 40                	int    $0x40
     e4f:	c3                   	ret    

00000e50 <unlink>:
SYSCALL(unlink)
     e50:	b8 12 00 00 00       	mov    $0x12,%eax
     e55:	cd 40                	int    $0x40
     e57:	c3                   	ret    

00000e58 <fstat>:
SYSCALL(fstat)
     e58:	b8 08 00 00 00       	mov    $0x8,%eax
     e5d:	cd 40                	int    $0x40
     e5f:	c3                   	ret    

00000e60 <link>:
SYSCALL(link)
     e60:	b8 13 00 00 00       	mov    $0x13,%eax
     e65:	cd 40                	int    $0x40
     e67:	c3                   	ret    

00000e68 <mkdir>:
SYSCALL(mkdir)
     e68:	b8 14 00 00 00       	mov    $0x14,%eax
     e6d:	cd 40                	int    $0x40
     e6f:	c3                   	ret    

00000e70 <chdir>:
SYSCALL(chdir)
     e70:	b8 09 00 00 00       	mov    $0x9,%eax
     e75:	cd 40                	int    $0x40
     e77:	c3                   	ret    

00000e78 <dup>:
SYSCALL(dup)
     e78:	b8 0a 00 00 00       	mov    $0xa,%eax
     e7d:	cd 40                	int    $0x40
     e7f:	c3                   	ret    

00000e80 <getpid>:
SYSCALL(getpid)
     e80:	b8 0b 00 00 00       	mov    $0xb,%eax
     e85:	cd 40                	int    $0x40
     e87:	c3                   	ret    

00000e88 <sbrk>:
SYSCALL(sbrk)
     e88:	b8 0c 00 00 00       	mov    $0xc,%eax
     e8d:	cd 40                	int    $0x40
     e8f:	c3                   	ret    

00000e90 <sleep>:
SYSCALL(sleep)
     e90:	b8 0d 00 00 00       	mov    $0xd,%eax
     e95:	cd 40                	int    $0x40
     e97:	c3                   	ret    

00000e98 <uptime>:
SYSCALL(uptime)
     e98:	b8 0e 00 00 00       	mov    $0xe,%eax
     e9d:	cd 40                	int    $0x40
     e9f:	c3                   	ret    

00000ea0 <thread_create>:
SYSCALL(thread_create)
     ea0:	b8 16 00 00 00       	mov    $0x16,%eax
     ea5:	cd 40                	int    $0x40
     ea7:	c3                   	ret    

00000ea8 <thread_getId>:
SYSCALL(thread_getId)
     ea8:	b8 17 00 00 00       	mov    $0x17,%eax
     ead:	cd 40                	int    $0x40
     eaf:	c3                   	ret    

00000eb0 <thread_getProcId>:
SYSCALL(thread_getProcId)
     eb0:	b8 18 00 00 00       	mov    $0x18,%eax
     eb5:	cd 40                	int    $0x40
     eb7:	c3                   	ret    

00000eb8 <thread_join>:
SYSCALL(thread_join)
     eb8:	b8 19 00 00 00       	mov    $0x19,%eax
     ebd:	cd 40                	int    $0x40
     ebf:	c3                   	ret    

00000ec0 <thread_exit>:
SYSCALL(thread_exit)
     ec0:	b8 1a 00 00 00       	mov    $0x1a,%eax
     ec5:	cd 40                	int    $0x40
     ec7:	c3                   	ret    

00000ec8 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     ec8:	b8 1b 00 00 00       	mov    $0x1b,%eax
     ecd:	cd 40                	int    $0x40
     ecf:	c3                   	ret    

00000ed0 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     ed0:	b8 1c 00 00 00       	mov    $0x1c,%eax
     ed5:	cd 40                	int    $0x40
     ed7:	c3                   	ret    

00000ed8 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     ed8:	b8 1d 00 00 00       	mov    $0x1d,%eax
     edd:	cd 40                	int    $0x40
     edf:	c3                   	ret    

00000ee0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     ee0:	55                   	push   %ebp
     ee1:	89 e5                	mov    %esp,%ebp
     ee3:	83 ec 28             	sub    $0x28,%esp
     ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ee9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     eec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     ef3:	00 
     ef4:	8d 45 f4             	lea    -0xc(%ebp),%eax
     ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
     efb:	8b 45 08             	mov    0x8(%ebp),%eax
     efe:	89 04 24             	mov    %eax,(%esp)
     f01:	e8 1a ff ff ff       	call   e20 <write>
}
     f06:	c9                   	leave  
     f07:	c3                   	ret    

00000f08 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f08:	55                   	push   %ebp
     f09:	89 e5                	mov    %esp,%ebp
     f0b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     f0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     f15:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     f19:	74 17                	je     f32 <printint+0x2a>
     f1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f1f:	79 11                	jns    f32 <printint+0x2a>
    neg = 1;
     f21:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     f28:	8b 45 0c             	mov    0xc(%ebp),%eax
     f2b:	f7 d8                	neg    %eax
     f2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f30:	eb 06                	jmp    f38 <printint+0x30>
  } else {
    x = xx;
     f32:	8b 45 0c             	mov    0xc(%ebp),%eax
     f35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     f38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     f3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f45:	ba 00 00 00 00       	mov    $0x0,%edx
     f4a:	f7 f1                	div    %ecx
     f4c:	89 d0                	mov    %edx,%eax
     f4e:	0f b6 90 50 1f 00 00 	movzbl 0x1f50(%eax),%edx
     f55:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f58:	03 45 f4             	add    -0xc(%ebp),%eax
     f5b:	88 10                	mov    %dl,(%eax)
     f5d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     f61:	8b 55 10             	mov    0x10(%ebp),%edx
     f64:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     f67:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f6a:	ba 00 00 00 00       	mov    $0x0,%edx
     f6f:	f7 75 d4             	divl   -0x2c(%ebp)
     f72:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f75:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f79:	75 c4                	jne    f3f <printint+0x37>
  if(neg)
     f7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f7f:	74 2a                	je     fab <printint+0xa3>
    buf[i++] = '-';
     f81:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f84:	03 45 f4             	add    -0xc(%ebp),%eax
     f87:	c6 00 2d             	movb   $0x2d,(%eax)
     f8a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     f8e:	eb 1b                	jmp    fab <printint+0xa3>
    putc(fd, buf[i]);
     f90:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f93:	03 45 f4             	add    -0xc(%ebp),%eax
     f96:	0f b6 00             	movzbl (%eax),%eax
     f99:	0f be c0             	movsbl %al,%eax
     f9c:	89 44 24 04          	mov    %eax,0x4(%esp)
     fa0:	8b 45 08             	mov    0x8(%ebp),%eax
     fa3:	89 04 24             	mov    %eax,(%esp)
     fa6:	e8 35 ff ff ff       	call   ee0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     fab:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     faf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     fb3:	79 db                	jns    f90 <printint+0x88>
    putc(fd, buf[i]);
}
     fb5:	c9                   	leave  
     fb6:	c3                   	ret    

00000fb7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     fb7:	55                   	push   %ebp
     fb8:	89 e5                	mov    %esp,%ebp
     fba:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     fbd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     fc4:	8d 45 0c             	lea    0xc(%ebp),%eax
     fc7:	83 c0 04             	add    $0x4,%eax
     fca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     fcd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     fd4:	e9 7d 01 00 00       	jmp    1156 <printf+0x19f>
    c = fmt[i] & 0xff;
     fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
     fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fdf:	01 d0                	add    %edx,%eax
     fe1:	0f b6 00             	movzbl (%eax),%eax
     fe4:	0f be c0             	movsbl %al,%eax
     fe7:	25 ff 00 00 00       	and    $0xff,%eax
     fec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     fef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ff3:	75 2c                	jne    1021 <printf+0x6a>
      if(c == '%'){
     ff5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     ff9:	75 0c                	jne    1007 <printf+0x50>
        state = '%';
     ffb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1002:	e9 4b 01 00 00       	jmp    1152 <printf+0x19b>
      } else {
        putc(fd, c);
    1007:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    100a:	0f be c0             	movsbl %al,%eax
    100d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1011:	8b 45 08             	mov    0x8(%ebp),%eax
    1014:	89 04 24             	mov    %eax,(%esp)
    1017:	e8 c4 fe ff ff       	call   ee0 <putc>
    101c:	e9 31 01 00 00       	jmp    1152 <printf+0x19b>
      }
    } else if(state == '%'){
    1021:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1025:	0f 85 27 01 00 00    	jne    1152 <printf+0x19b>
      if(c == 'd'){
    102b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    102f:	75 2d                	jne    105e <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1031:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1034:	8b 00                	mov    (%eax),%eax
    1036:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    103d:	00 
    103e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1045:	00 
    1046:	89 44 24 04          	mov    %eax,0x4(%esp)
    104a:	8b 45 08             	mov    0x8(%ebp),%eax
    104d:	89 04 24             	mov    %eax,(%esp)
    1050:	e8 b3 fe ff ff       	call   f08 <printint>
        ap++;
    1055:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1059:	e9 ed 00 00 00       	jmp    114b <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    105e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1062:	74 06                	je     106a <printf+0xb3>
    1064:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1068:	75 2d                	jne    1097 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    106a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    106d:	8b 00                	mov    (%eax),%eax
    106f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1076:	00 
    1077:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    107e:	00 
    107f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1083:	8b 45 08             	mov    0x8(%ebp),%eax
    1086:	89 04 24             	mov    %eax,(%esp)
    1089:	e8 7a fe ff ff       	call   f08 <printint>
        ap++;
    108e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1092:	e9 b4 00 00 00       	jmp    114b <printf+0x194>
      } else if(c == 's'){
    1097:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    109b:	75 46                	jne    10e3 <printf+0x12c>
        s = (char*)*ap;
    109d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10a0:	8b 00                	mov    (%eax),%eax
    10a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    10a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    10a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10ad:	75 27                	jne    10d6 <printf+0x11f>
          s = "(null)";
    10af:	c7 45 f4 68 19 00 00 	movl   $0x1968,-0xc(%ebp)
        while(*s != 0){
    10b6:	eb 1e                	jmp    10d6 <printf+0x11f>
          putc(fd, *s);
    10b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10bb:	0f b6 00             	movzbl (%eax),%eax
    10be:	0f be c0             	movsbl %al,%eax
    10c1:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c5:	8b 45 08             	mov    0x8(%ebp),%eax
    10c8:	89 04 24             	mov    %eax,(%esp)
    10cb:	e8 10 fe ff ff       	call   ee0 <putc>
          s++;
    10d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    10d4:	eb 01                	jmp    10d7 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    10d6:	90                   	nop
    10d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10da:	0f b6 00             	movzbl (%eax),%eax
    10dd:	84 c0                	test   %al,%al
    10df:	75 d7                	jne    10b8 <printf+0x101>
    10e1:	eb 68                	jmp    114b <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    10e3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    10e7:	75 1d                	jne    1106 <printf+0x14f>
        putc(fd, *ap);
    10e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10ec:	8b 00                	mov    (%eax),%eax
    10ee:	0f be c0             	movsbl %al,%eax
    10f1:	89 44 24 04          	mov    %eax,0x4(%esp)
    10f5:	8b 45 08             	mov    0x8(%ebp),%eax
    10f8:	89 04 24             	mov    %eax,(%esp)
    10fb:	e8 e0 fd ff ff       	call   ee0 <putc>
        ap++;
    1100:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1104:	eb 45                	jmp    114b <printf+0x194>
      } else if(c == '%'){
    1106:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    110a:	75 17                	jne    1123 <printf+0x16c>
        putc(fd, c);
    110c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    110f:	0f be c0             	movsbl %al,%eax
    1112:	89 44 24 04          	mov    %eax,0x4(%esp)
    1116:	8b 45 08             	mov    0x8(%ebp),%eax
    1119:	89 04 24             	mov    %eax,(%esp)
    111c:	e8 bf fd ff ff       	call   ee0 <putc>
    1121:	eb 28                	jmp    114b <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1123:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    112a:	00 
    112b:	8b 45 08             	mov    0x8(%ebp),%eax
    112e:	89 04 24             	mov    %eax,(%esp)
    1131:	e8 aa fd ff ff       	call   ee0 <putc>
        putc(fd, c);
    1136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1139:	0f be c0             	movsbl %al,%eax
    113c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1140:	8b 45 08             	mov    0x8(%ebp),%eax
    1143:	89 04 24             	mov    %eax,(%esp)
    1146:	e8 95 fd ff ff       	call   ee0 <putc>
      }
      state = 0;
    114b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1152:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1156:	8b 55 0c             	mov    0xc(%ebp),%edx
    1159:	8b 45 f0             	mov    -0x10(%ebp),%eax
    115c:	01 d0                	add    %edx,%eax
    115e:	0f b6 00             	movzbl (%eax),%eax
    1161:	84 c0                	test   %al,%al
    1163:	0f 85 70 fe ff ff    	jne    fd9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1169:	c9                   	leave  
    116a:	c3                   	ret    
    116b:	90                   	nop

0000116c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    116c:	55                   	push   %ebp
    116d:	89 e5                	mov    %esp,%ebp
    116f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1172:	8b 45 08             	mov    0x8(%ebp),%eax
    1175:	83 e8 08             	sub    $0x8,%eax
    1178:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    117b:	a1 6c 1f 00 00       	mov    0x1f6c,%eax
    1180:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1183:	eb 24                	jmp    11a9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1185:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1188:	8b 00                	mov    (%eax),%eax
    118a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    118d:	77 12                	ja     11a1 <free+0x35>
    118f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1192:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1195:	77 24                	ja     11bb <free+0x4f>
    1197:	8b 45 fc             	mov    -0x4(%ebp),%eax
    119a:	8b 00                	mov    (%eax),%eax
    119c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    119f:	77 1a                	ja     11bb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11a4:	8b 00                	mov    (%eax),%eax
    11a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11af:	76 d4                	jbe    1185 <free+0x19>
    11b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11b4:	8b 00                	mov    (%eax),%eax
    11b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11b9:	76 ca                	jbe    1185 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    11bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11be:	8b 40 04             	mov    0x4(%eax),%eax
    11c1:	c1 e0 03             	shl    $0x3,%eax
    11c4:	89 c2                	mov    %eax,%edx
    11c6:	03 55 f8             	add    -0x8(%ebp),%edx
    11c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11cc:	8b 00                	mov    (%eax),%eax
    11ce:	39 c2                	cmp    %eax,%edx
    11d0:	75 24                	jne    11f6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    11d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11d5:	8b 50 04             	mov    0x4(%eax),%edx
    11d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11db:	8b 00                	mov    (%eax),%eax
    11dd:	8b 40 04             	mov    0x4(%eax),%eax
    11e0:	01 c2                	add    %eax,%edx
    11e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11e5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    11e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11eb:	8b 00                	mov    (%eax),%eax
    11ed:	8b 10                	mov    (%eax),%edx
    11ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11f2:	89 10                	mov    %edx,(%eax)
    11f4:	eb 0a                	jmp    1200 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    11f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11f9:	8b 10                	mov    (%eax),%edx
    11fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11fe:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1200:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1203:	8b 40 04             	mov    0x4(%eax),%eax
    1206:	c1 e0 03             	shl    $0x3,%eax
    1209:	03 45 fc             	add    -0x4(%ebp),%eax
    120c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    120f:	75 20                	jne    1231 <free+0xc5>
    p->s.size += bp->s.size;
    1211:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1214:	8b 50 04             	mov    0x4(%eax),%edx
    1217:	8b 45 f8             	mov    -0x8(%ebp),%eax
    121a:	8b 40 04             	mov    0x4(%eax),%eax
    121d:	01 c2                	add    %eax,%edx
    121f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1222:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1225:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1228:	8b 10                	mov    (%eax),%edx
    122a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    122d:	89 10                	mov    %edx,(%eax)
    122f:	eb 08                	jmp    1239 <free+0xcd>
  } else
    p->s.ptr = bp;
    1231:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1234:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1237:	89 10                	mov    %edx,(%eax)
  freep = p;
    1239:	8b 45 fc             	mov    -0x4(%ebp),%eax
    123c:	a3 6c 1f 00 00       	mov    %eax,0x1f6c
}
    1241:	c9                   	leave  
    1242:	c3                   	ret    

00001243 <morecore>:

static Header*
morecore(uint nu)
{
    1243:	55                   	push   %ebp
    1244:	89 e5                	mov    %esp,%ebp
    1246:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1249:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1250:	77 07                	ja     1259 <morecore+0x16>
    nu = 4096;
    1252:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1259:	8b 45 08             	mov    0x8(%ebp),%eax
    125c:	c1 e0 03             	shl    $0x3,%eax
    125f:	89 04 24             	mov    %eax,(%esp)
    1262:	e8 21 fc ff ff       	call   e88 <sbrk>
    1267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    126a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    126e:	75 07                	jne    1277 <morecore+0x34>
    return 0;
    1270:	b8 00 00 00 00       	mov    $0x0,%eax
    1275:	eb 22                	jmp    1299 <morecore+0x56>
  hp = (Header*)p;
    1277:	8b 45 f4             	mov    -0xc(%ebp),%eax
    127a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    127d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1280:	8b 55 08             	mov    0x8(%ebp),%edx
    1283:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1286:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1289:	83 c0 08             	add    $0x8,%eax
    128c:	89 04 24             	mov    %eax,(%esp)
    128f:	e8 d8 fe ff ff       	call   116c <free>
  return freep;
    1294:	a1 6c 1f 00 00       	mov    0x1f6c,%eax
}
    1299:	c9                   	leave  
    129a:	c3                   	ret    

0000129b <malloc>:

void*
malloc(uint nbytes)
{
    129b:	55                   	push   %ebp
    129c:	89 e5                	mov    %esp,%ebp
    129e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12a1:	8b 45 08             	mov    0x8(%ebp),%eax
    12a4:	83 c0 07             	add    $0x7,%eax
    12a7:	c1 e8 03             	shr    $0x3,%eax
    12aa:	83 c0 01             	add    $0x1,%eax
    12ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    12b0:	a1 6c 1f 00 00       	mov    0x1f6c,%eax
    12b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12bc:	75 23                	jne    12e1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    12be:	c7 45 f0 64 1f 00 00 	movl   $0x1f64,-0x10(%ebp)
    12c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12c8:	a3 6c 1f 00 00       	mov    %eax,0x1f6c
    12cd:	a1 6c 1f 00 00       	mov    0x1f6c,%eax
    12d2:	a3 64 1f 00 00       	mov    %eax,0x1f64
    base.s.size = 0;
    12d7:	c7 05 68 1f 00 00 00 	movl   $0x0,0x1f68
    12de:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12e4:	8b 00                	mov    (%eax),%eax
    12e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    12e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ec:	8b 40 04             	mov    0x4(%eax),%eax
    12ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    12f2:	72 4d                	jb     1341 <malloc+0xa6>
      if(p->s.size == nunits)
    12f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f7:	8b 40 04             	mov    0x4(%eax),%eax
    12fa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    12fd:	75 0c                	jne    130b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    12ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1302:	8b 10                	mov    (%eax),%edx
    1304:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1307:	89 10                	mov    %edx,(%eax)
    1309:	eb 26                	jmp    1331 <malloc+0x96>
      else {
        p->s.size -= nunits;
    130b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    130e:	8b 40 04             	mov    0x4(%eax),%eax
    1311:	89 c2                	mov    %eax,%edx
    1313:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1316:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1319:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    131c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    131f:	8b 40 04             	mov    0x4(%eax),%eax
    1322:	c1 e0 03             	shl    $0x3,%eax
    1325:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1328:	8b 45 f4             	mov    -0xc(%ebp),%eax
    132b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    132e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1331:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1334:	a3 6c 1f 00 00       	mov    %eax,0x1f6c
      return (void*)(p + 1);
    1339:	8b 45 f4             	mov    -0xc(%ebp),%eax
    133c:	83 c0 08             	add    $0x8,%eax
    133f:	eb 38                	jmp    1379 <malloc+0xde>
    }
    if(p == freep)
    1341:	a1 6c 1f 00 00       	mov    0x1f6c,%eax
    1346:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1349:	75 1b                	jne    1366 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    134b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    134e:	89 04 24             	mov    %eax,(%esp)
    1351:	e8 ed fe ff ff       	call   1243 <morecore>
    1356:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1359:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    135d:	75 07                	jne    1366 <malloc+0xcb>
        return 0;
    135f:	b8 00 00 00 00       	mov    $0x0,%eax
    1364:	eb 13                	jmp    1379 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1366:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1369:	89 45 f0             	mov    %eax,-0x10(%ebp)
    136c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136f:	8b 00                	mov    (%eax),%eax
    1371:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1374:	e9 70 ff ff ff       	jmp    12e9 <malloc+0x4e>
}
    1379:	c9                   	leave  
    137a:	c3                   	ret    
    137b:	90                   	nop

0000137c <semaphore_create>:
#include "semaphore.h"
#include "types.h"
#include "user.h"


struct semaphore* semaphore_create(int initial_semaphore_value){
    137c:	55                   	push   %ebp
    137d:	89 e5                	mov    %esp,%ebp
    137f:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* sem=malloc(sizeof(struct semaphore)); 
    1382:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    1389:	e8 0d ff ff ff       	call   129b <malloc>
    138e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // acquire semaphors
  sem->s1 = binary_semaphore_create(1);
    1391:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1398:	e8 2b fb ff ff       	call   ec8 <binary_semaphore_create>
    139d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13a0:	89 02                	mov    %eax,(%edx)
  
  // s2 should be initialized with the min{1,initial_semaphore_value}
  if(initial_semaphore_value >= 1){
    13a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    13a6:	7e 14                	jle    13bc <semaphore_create+0x40>
    sem->s2 = binary_semaphore_create(1);
    13a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13af:	e8 14 fb ff ff       	call   ec8 <binary_semaphore_create>
    13b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13b7:	89 42 04             	mov    %eax,0x4(%edx)
    13ba:	eb 11                	jmp    13cd <semaphore_create+0x51>
  }else{
    sem->s2 = binary_semaphore_create(initial_semaphore_value);
    13bc:	8b 45 08             	mov    0x8(%ebp),%eax
    13bf:	89 04 24             	mov    %eax,(%esp)
    13c2:	e8 01 fb ff ff       	call   ec8 <binary_semaphore_create>
    13c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13ca:	89 42 04             	mov    %eax,0x4(%edx)
  }
  
  if(sem->s1 == -1 || sem->s2 == -1){
    13cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13d0:	8b 00                	mov    (%eax),%eax
    13d2:	83 f8 ff             	cmp    $0xffffffff,%eax
    13d5:	74 0b                	je     13e2 <semaphore_create+0x66>
    13d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13da:	8b 40 04             	mov    0x4(%eax),%eax
    13dd:	83 f8 ff             	cmp    $0xffffffff,%eax
    13e0:	75 26                	jne    1408 <semaphore_create+0x8c>
     printf(1,"we had a probalem initialize in semaphore_create\n");
    13e2:	c7 44 24 04 70 19 00 	movl   $0x1970,0x4(%esp)
    13e9:	00 
    13ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13f1:	e8 c1 fb ff ff       	call   fb7 <printf>
     free(sem);
    13f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f9:	89 04 24             	mov    %eax,(%esp)
    13fc:	e8 6b fd ff ff       	call   116c <free>
     return 0;
    1401:	b8 00 00 00 00       	mov    $0x0,%eax
    1406:	eb 15                	jmp    141d <semaphore_create+0xa1>
  }
  //initialize value
  sem->value = initial_semaphore_value;//dynamic
    1408:	8b 45 f4             	mov    -0xc(%ebp),%eax
    140b:	8b 55 08             	mov    0x8(%ebp),%edx
    140e:	89 50 08             	mov    %edx,0x8(%eax)
  sem->initial_value = initial_semaphore_value;//static
    1411:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1414:	8b 55 08             	mov    0x8(%ebp),%edx
    1417:	89 50 0c             	mov    %edx,0xc(%eax)
  
  return sem;
    141a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    141d:	c9                   	leave  
    141e:	c3                   	ret    

0000141f <semaphore_down>:
void semaphore_down(struct semaphore* sem ){
    141f:	55                   	push   %ebp
    1420:	89 e5                	mov    %esp,%ebp
    1422:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s2);
    1425:	8b 45 08             	mov    0x8(%ebp),%eax
    1428:	8b 40 04             	mov    0x4(%eax),%eax
    142b:	89 04 24             	mov    %eax,(%esp)
    142e:	e8 9d fa ff ff       	call   ed0 <binary_semaphore_down>
  binary_semaphore_down(sem->s1);
    1433:	8b 45 08             	mov    0x8(%ebp),%eax
    1436:	8b 00                	mov    (%eax),%eax
    1438:	89 04 24             	mov    %eax,(%esp)
    143b:	e8 90 fa ff ff       	call   ed0 <binary_semaphore_down>
  sem->value--;	
    1440:	8b 45 08             	mov    0x8(%ebp),%eax
    1443:	8b 40 08             	mov    0x8(%eax),%eax
    1446:	8d 50 ff             	lea    -0x1(%eax),%edx
    1449:	8b 45 08             	mov    0x8(%ebp),%eax
    144c:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value > 0){
    144f:	8b 45 08             	mov    0x8(%ebp),%eax
    1452:	8b 40 08             	mov    0x8(%eax),%eax
    1455:	85 c0                	test   %eax,%eax
    1457:	7e 0e                	jle    1467 <semaphore_down+0x48>
   binary_semaphore_up(sem->s2);
    1459:	8b 45 08             	mov    0x8(%ebp),%eax
    145c:	8b 40 04             	mov    0x4(%eax),%eax
    145f:	89 04 24             	mov    %eax,(%esp)
    1462:	e8 71 fa ff ff       	call   ed8 <binary_semaphore_up>
  }
  binary_semaphore_up(sem->s1); 
    1467:	8b 45 08             	mov    0x8(%ebp),%eax
    146a:	8b 00                	mov    (%eax),%eax
    146c:	89 04 24             	mov    %eax,(%esp)
    146f:	e8 64 fa ff ff       	call   ed8 <binary_semaphore_up>
}
    1474:	c9                   	leave  
    1475:	c3                   	ret    

00001476 <semaphore_up>:
void semaphore_up(struct semaphore* sem ){
    1476:	55                   	push   %ebp
    1477:	89 e5                	mov    %esp,%ebp
    1479:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
    147c:	8b 45 08             	mov    0x8(%ebp),%eax
    147f:	8b 00                	mov    (%eax),%eax
    1481:	89 04 24             	mov    %eax,(%esp)
    1484:	e8 47 fa ff ff       	call   ed0 <binary_semaphore_down>
  sem->value++;	
    1489:	8b 45 08             	mov    0x8(%ebp),%eax
    148c:	8b 40 08             	mov    0x8(%eax),%eax
    148f:	8d 50 01             	lea    0x1(%eax),%edx
    1492:	8b 45 08             	mov    0x8(%ebp),%eax
    1495:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value ==1){
    1498:	8b 45 08             	mov    0x8(%ebp),%eax
    149b:	8b 40 08             	mov    0x8(%eax),%eax
    149e:	83 f8 01             	cmp    $0x1,%eax
    14a1:	75 0e                	jne    14b1 <semaphore_up+0x3b>
   binary_semaphore_up(sem->s2); 
    14a3:	8b 45 08             	mov    0x8(%ebp),%eax
    14a6:	8b 40 04             	mov    0x4(%eax),%eax
    14a9:	89 04 24             	mov    %eax,(%esp)
    14ac:	e8 27 fa ff ff       	call   ed8 <binary_semaphore_up>
   }
  binary_semaphore_up(sem->s1);
    14b1:	8b 45 08             	mov    0x8(%ebp),%eax
    14b4:	8b 00                	mov    (%eax),%eax
    14b6:	89 04 24             	mov    %eax,(%esp)
    14b9:	e8 1a fa ff ff       	call   ed8 <binary_semaphore_up>
}
    14be:	c9                   	leave  
    14bf:	c3                   	ret    

000014c0 <semaphore_free>:

void semaphore_free(struct semaphore* sem){
    14c0:	55                   	push   %ebp
    14c1:	89 e5                	mov    %esp,%ebp
    14c3:	83 ec 18             	sub    $0x18,%esp
  free(sem);
    14c6:	8b 45 08             	mov    0x8(%ebp),%eax
    14c9:	89 04 24             	mov    %eax,(%esp)
    14cc:	e8 9b fc ff ff       	call   116c <free>
}
    14d1:	c9                   	leave  
    14d2:	c3                   	ret    
    14d3:	90                   	nop

000014d4 <BB_create>:
#include "types.h"
#include "user.h"


struct BB* 
BB_create(int max_capacity){
    14d4:	55                   	push   %ebp
    14d5:	89 e5                	mov    %esp,%ebp
    14d7:	83 ec 38             	sub    $0x38,%esp
  //initialize
  struct BB* buf = malloc(sizeof(struct BB));
    14da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
    14e1:	e8 b5 fd ff ff       	call   129b <malloc>
    14e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
    14e9:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    14f0:	00 
    14f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14f8:	00 
    14f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fc:	89 04 24             	mov    %eax,(%esp)
    14ff:	e8 57 f7 ff ff       	call   c5b <memset>
 
  buf->buffer_size = max_capacity;
    1504:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1507:	8b 55 08             	mov    0x8(%ebp),%edx
    150a:	89 10                	mov    %edx,(%eax)
  buf->mutex = binary_semaphore_create(1);  
    150c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1513:	e8 b0 f9 ff ff       	call   ec8 <binary_semaphore_create>
    1518:	8b 55 f4             	mov    -0xc(%ebp),%edx
    151b:	89 42 04             	mov    %eax,0x4(%edx)
  buf->empty = semaphore_create(max_capacity);
    151e:	8b 45 08             	mov    0x8(%ebp),%eax
    1521:	89 04 24             	mov    %eax,(%esp)
    1524:	e8 53 fe ff ff       	call   137c <semaphore_create>
    1529:	8b 55 f4             	mov    -0xc(%ebp),%edx
    152c:	89 42 08             	mov    %eax,0x8(%edx)
  buf->full = semaphore_create(0);
    152f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1536:	e8 41 fe ff ff       	call   137c <semaphore_create>
    153b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    153e:	89 42 0c             	mov    %eax,0xc(%edx)
  buf->pointer_to_elements = malloc(sizeof(void*)*max_capacity);
    1541:	8b 45 08             	mov    0x8(%ebp),%eax
    1544:	c1 e0 02             	shl    $0x2,%eax
    1547:	89 04 24             	mov    %eax,(%esp)
    154a:	e8 4c fd ff ff       	call   129b <malloc>
    154f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1552:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->pointer_to_elements,0,sizeof(void*)*max_capacity);
    1555:	8b 45 08             	mov    0x8(%ebp),%eax
    1558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1562:	8b 40 1c             	mov    0x1c(%eax),%eax
    1565:	89 54 24 08          	mov    %edx,0x8(%esp)
    1569:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1570:	00 
    1571:	89 04 24             	mov    %eax,(%esp)
    1574:	e8 e2 f6 ff ff       	call   c5b <memset>
  buf->count = 0;
    1579:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  //check the semaphorses
  if(buf->mutex == -1 || buf->empty == 0 || buf->full == 0){
    1583:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1586:	8b 40 04             	mov    0x4(%eax),%eax
    1589:	83 f8 ff             	cmp    $0xffffffff,%eax
    158c:	74 14                	je     15a2 <BB_create+0xce>
    158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1591:	8b 40 08             	mov    0x8(%eax),%eax
    1594:	85 c0                	test   %eax,%eax
    1596:	74 0a                	je     15a2 <BB_create+0xce>
    1598:	8b 45 f4             	mov    -0xc(%ebp),%eax
    159b:	8b 40 0c             	mov    0xc(%eax),%eax
    159e:	85 c0                	test   %eax,%eax
    15a0:	75 44                	jne    15e6 <BB_create+0x112>
   printf(1,"we had a problam getting semaphores at BB create mutex %d empty %d full %d\n",buf->mutex,buf->empty,buf->full);
    15a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a5:	8b 48 0c             	mov    0xc(%eax),%ecx
    15a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15ab:	8b 50 08             	mov    0x8(%eax),%edx
    15ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15b1:	8b 40 04             	mov    0x4(%eax),%eax
    15b4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    15b8:	89 54 24 0c          	mov    %edx,0xc(%esp)
    15bc:	89 44 24 08          	mov    %eax,0x8(%esp)
    15c0:	c7 44 24 04 a4 19 00 	movl   $0x19a4,0x4(%esp)
    15c7:	00 
    15c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15cf:	e8 e3 f9 ff ff       	call   fb7 <printf>
   BB_free(buf);
    15d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15d7:	89 04 24             	mov    %eax,(%esp)
    15da:	e8 47 01 00 00       	call   1726 <BB_free>
   
   buf =0;  
    15df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  }
  return buf;
    15e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    15e9:	c9                   	leave  
    15ea:	c3                   	ret    

000015eb <BB_put>:

void BB_put(struct BB* bb, void* element)
{ 
    15eb:	55                   	push   %ebp
    15ec:	89 e5                	mov    %esp,%ebp
    15ee:	83 ec 18             	sub    $0x18,%esp
  semaphore_down(bb->empty);
    15f1:	8b 45 08             	mov    0x8(%ebp),%eax
    15f4:	8b 40 08             	mov    0x8(%eax),%eax
    15f7:	89 04 24             	mov    %eax,(%esp)
    15fa:	e8 20 fe ff ff       	call   141f <semaphore_down>
  binary_semaphore_down(bb->mutex);
    15ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1602:	8b 40 04             	mov    0x4(%eax),%eax
    1605:	89 04 24             	mov    %eax,(%esp)
    1608:	e8 c3 f8 ff ff       	call   ed0 <binary_semaphore_down>
   //insert item
  bb->pointer_to_elements[bb->count] = element;
    160d:	8b 45 08             	mov    0x8(%ebp),%eax
    1610:	8b 50 1c             	mov    0x1c(%eax),%edx
    1613:	8b 45 08             	mov    0x8(%ebp),%eax
    1616:	8b 40 10             	mov    0x10(%eax),%eax
    1619:	c1 e0 02             	shl    $0x2,%eax
    161c:	01 c2                	add    %eax,%edx
    161e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1621:	89 02                	mov    %eax,(%edx)
  bb->count++;
    1623:	8b 45 08             	mov    0x8(%ebp),%eax
    1626:	8b 40 10             	mov    0x10(%eax),%eax
    1629:	8d 50 01             	lea    0x1(%eax),%edx
    162c:	8b 45 08             	mov    0x8(%ebp),%eax
    162f:	89 50 10             	mov    %edx,0x10(%eax)
  binary_semaphore_up(bb->mutex);
    1632:	8b 45 08             	mov    0x8(%ebp),%eax
    1635:	8b 40 04             	mov    0x4(%eax),%eax
    1638:	89 04 24             	mov    %eax,(%esp)
    163b:	e8 98 f8 ff ff       	call   ed8 <binary_semaphore_up>
  semaphore_up(bb->full);
    1640:	8b 45 08             	mov    0x8(%ebp),%eax
    1643:	8b 40 0c             	mov    0xc(%eax),%eax
    1646:	89 04 24             	mov    %eax,(%esp)
    1649:	e8 28 fe ff ff       	call   1476 <semaphore_up>
}
    164e:	c9                   	leave  
    164f:	c3                   	ret    

00001650 <BB_pop>:

void* BB_pop(struct BB* bb)
{
    1650:	55                   	push   %ebp
    1651:	89 e5                	mov    %esp,%ebp
    1653:	83 ec 28             	sub    $0x28,%esp
  
  void* element_to_pop;
  semaphore_down(bb->full);
    1656:	8b 45 08             	mov    0x8(%ebp),%eax
    1659:	8b 40 0c             	mov    0xc(%eax),%eax
    165c:	89 04 24             	mov    %eax,(%esp)
    165f:	e8 bb fd ff ff       	call   141f <semaphore_down>
  binary_semaphore_down(bb->mutex);
    1664:	8b 45 08             	mov    0x8(%ebp),%eax
    1667:	8b 40 04             	mov    0x4(%eax),%eax
    166a:	89 04 24             	mov    %eax,(%esp)
    166d:	e8 5e f8 ff ff       	call   ed0 <binary_semaphore_down>
  element_to_pop = bb->pointer_to_elements[0];
    1672:	8b 45 08             	mov    0x8(%ebp),%eax
    1675:	8b 40 1c             	mov    0x1c(%eax),%eax
    1678:	8b 00                	mov    (%eax),%eax
    167a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(!element_to_pop){
    167d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1681:	75 14                	jne    1697 <BB_pop+0x47>
  printf(1,"we have uninitialize element\n");
    1683:	c7 44 24 04 f0 19 00 	movl   $0x19f0,0x4(%esp)
    168a:	00 
    168b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1692:	e8 20 f9 ff ff       	call   fb7 <printf>
  }
  
  // shift left all elements at the array
  int i;
  for(i = 0; i < bb->count ; i++){
    1697:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    169e:	eb 4b                	jmp    16eb <BB_pop+0x9b>
    if(i != (bb->count -1)){
    16a0:	8b 45 08             	mov    0x8(%ebp),%eax
    16a3:	8b 40 10             	mov    0x10(%eax),%eax
    16a6:	83 e8 01             	sub    $0x1,%eax
    16a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    16ac:	74 25                	je     16d3 <BB_pop+0x83>
      bb->pointer_to_elements[i] = bb->pointer_to_elements[i+1];
    16ae:	8b 45 08             	mov    0x8(%ebp),%eax
    16b1:	8b 40 1c             	mov    0x1c(%eax),%eax
    16b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    16b7:	c1 e2 02             	shl    $0x2,%edx
    16ba:	01 c2                	add    %eax,%edx
    16bc:	8b 45 08             	mov    0x8(%ebp),%eax
    16bf:	8b 40 1c             	mov    0x1c(%eax),%eax
    16c2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16c5:	83 c1 01             	add    $0x1,%ecx
    16c8:	c1 e1 02             	shl    $0x2,%ecx
    16cb:	01 c8                	add    %ecx,%eax
    16cd:	8b 00                	mov    (%eax),%eax
    16cf:	89 02                	mov    %eax,(%edx)
    16d1:	eb 14                	jmp    16e7 <BB_pop+0x97>
    }else{
      bb->pointer_to_elements[i] = 0;
    16d3:	8b 45 08             	mov    0x8(%ebp),%eax
    16d6:	8b 40 1c             	mov    0x1c(%eax),%eax
    16d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    16dc:	c1 e2 02             	shl    $0x2,%edx
    16df:	01 d0                	add    %edx,%eax
    16e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  printf(1,"we have uninitialize element\n");
  }
  
  // shift left all elements at the array
  int i;
  for(i = 0; i < bb->count ; i++){
    16e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    16eb:	8b 45 08             	mov    0x8(%ebp),%eax
    16ee:	8b 40 10             	mov    0x10(%eax),%eax
    16f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    16f4:	7f aa                	jg     16a0 <BB_pop+0x50>
     }
     
  }
  
  
  bb->count--;
    16f6:	8b 45 08             	mov    0x8(%ebp),%eax
    16f9:	8b 40 10             	mov    0x10(%eax),%eax
    16fc:	8d 50 ff             	lea    -0x1(%eax),%edx
    16ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1702:	89 50 10             	mov    %edx,0x10(%eax)
  
  binary_semaphore_up(bb->mutex);
    1705:	8b 45 08             	mov    0x8(%ebp),%eax
    1708:	8b 40 04             	mov    0x4(%eax),%eax
    170b:	89 04 24             	mov    %eax,(%esp)
    170e:	e8 c5 f7 ff ff       	call   ed8 <binary_semaphore_up>
  semaphore_up(bb->empty);
    1713:	8b 45 08             	mov    0x8(%ebp),%eax
    1716:	8b 40 08             	mov    0x8(%eax),%eax
    1719:	89 04 24             	mov    %eax,(%esp)
    171c:	e8 55 fd ff ff       	call   1476 <semaphore_up>
  
  return element_to_pop;
    1721:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1724:	c9                   	leave  
    1725:	c3                   	ret    

00001726 <BB_free>:

void BB_free(struct BB* bb){
    1726:	55                   	push   %ebp
    1727:	89 e5                	mov    %esp,%ebp
    1729:	83 ec 18             	sub    $0x18,%esp
  semaphore_free(bb->empty);
    172c:	8b 45 08             	mov    0x8(%ebp),%eax
    172f:	8b 40 08             	mov    0x8(%eax),%eax
    1732:	89 04 24             	mov    %eax,(%esp)
    1735:	e8 86 fd ff ff       	call   14c0 <semaphore_free>
  semaphore_free(bb->full);
    173a:	8b 45 08             	mov    0x8(%ebp),%eax
    173d:	8b 40 0c             	mov    0xc(%eax),%eax
    1740:	89 04 24             	mov    %eax,(%esp)
    1743:	e8 78 fd ff ff       	call   14c0 <semaphore_free>
  free(bb->pointer_to_elements);
    1748:	8b 45 08             	mov    0x8(%ebp),%eax
    174b:	8b 40 1c             	mov    0x1c(%eax),%eax
    174e:	89 04 24             	mov    %eax,(%esp)
    1751:	e8 16 fa ff ff       	call   116c <free>
  free(bb);
    1756:	8b 45 08             	mov    0x8(%ebp),%eax
    1759:	89 04 24             	mov    %eax,(%esp)
    175c:	e8 0b fa ff ff       	call   116c <free>
}
    1761:	c9                   	leave  
    1762:	c3                   	ret    
