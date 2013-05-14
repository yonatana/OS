
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
       6:	a1 1c 20 00 00       	mov    0x201c,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 38 14 00 00       	call   144b <semaphore_down>
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
      1b:	a1 1c 20 00 00       	mov    0x201c,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 7a 14 00 00       	call   14a2 <semaphore_up>
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
      30:	a1 24 20 00 00       	mov    0x2024,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 d3 15 00 00       	call   1617 <BB_put>
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
      4c:	a1 24 20 00 00       	mov    0x2024,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 3b 16 00 00       	call   1694 <BB_pop>
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
      61:	a1 34 20 00 00       	mov    0x2034,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 a2 15 00 00       	call   1617 <BB_put>
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
      7d:	a1 34 20 00 00       	mov    0x2034,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 0a 16 00 00       	call   1694 <BB_pop>
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
      92:	a1 50 20 00 00       	mov    0x2050,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 f5 15 00 00       	call   1694 <BB_pop>
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
      a7:	a1 50 20 00 00       	mov    0x2050,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 5c 15 00 00       	call   1617 <BB_put>
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
      c3:	a1 28 20 00 00       	mov    0x2028,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 40 15 00 00       	call   1617 <BB_put>
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
      df:	a1 28 20 00 00       	mov    0x2028,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 a8 15 00 00       	call   1694 <BB_pop>
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
      f9:	e8 d6 0d 00 00       	call   ed4 <thread_getId>
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
     139:	e8 89 11 00 00       	call   12c7 <malloc>
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
     18a:	c7 44 24 04 00 18 00 	movl   $0x1800,0x4(%esp)
     191:	00 
     192:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     199:	e8 45 0e 00 00       	call   fe3 <printf>
	sleep(1);
     19e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1a5:	e8 12 0d 00 00       	call   ebc <sleep>
	struct Action* retrun_action = malloc(sizeof(struct Action));
     1aa:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     1b1:	e8 11 11 00 00       	call   12c7 <malloc>
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
     1ef:	e8 e0 0c 00 00       	call   ed4 <thread_getId>
     1f4:	89 44 24 08          	mov    %eax,0x8(%esp)
     1f8:	c7 44 24 04 30 18 00 	movl   $0x1830,0x4(%esp)
     1ff:	00 
     200:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     207:	e8 d7 0d 00 00       	call   fe3 <printf>
    leave_bar();
     20c:	e8 04 fe ff ff       	call   15 <leave_bar>
    thread_exit(0);
     211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     218:	e8 cf 0c 00 00       	call   eec <thread_exit>
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
     227:	83 ec 58             	sub    $0x58,%esp
    void* ret_val = 0;
     22a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int tid = thread_getId();
     231:	e8 9e 0c 00 00       	call   ed4 <thread_getId>
     236:	89 45 f0             	mov    %eax,-0x10(%ebp)
    double amount =0;
     239:	d9 ee                	fldz   
     23b:	dd 5d e8             	fstpl  -0x18(%ebp)
    double buf_size =0;
     23e:	d9 ee                	fldz   
     240:	dd 5d e0             	fstpl  -0x20(%ebp)
    for(;;){
	struct Action* bartender_action = get_action();	
     243:	e8 fe fd ff ff       	call   46 <get_action>
     248:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(bartender_action->action_type == DRINK_ORDER){
     24b:	8b 45 dc             	mov    -0x24(%ebp),%eax
     24e:	8b 00                	mov    (%eax),%eax
     250:	83 f8 01             	cmp    $0x1,%eax
     253:	75 3c                	jne    291 <bartender+0x6d>
	    struct Cup* current_cup = get_clean_cup();
     255:	e8 32 fe ff ff       	call   8c <get_clean_cup>
     25a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	    //need to write to file intsead of screen TODO
	    printf(1,"Bartender %d is making drink with cup %d\n",tid,current_cup->id);
     25d:	8b 45 d8             	mov    -0x28(%ebp),%eax
     260:	8b 00                	mov    (%eax),%eax
     262:	89 44 24 0c          	mov    %eax,0xc(%esp)
     266:	8b 45 f0             	mov    -0x10(%ebp),%eax
     269:	89 44 24 08          	mov    %eax,0x8(%esp)
     26d:	c7 44 24 04 5c 18 00 	movl   $0x185c,0x4(%esp)
     274:	00 
     275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     27c:	e8 62 0d 00 00       	call   fe3 <printf>
	    serve_drink(current_cup);
     281:	8b 45 d8             	mov    -0x28(%ebp),%eax
     284:	89 04 24             	mov    %eax,(%esp)
     287:	e8 cf fd ff ff       	call   5b <serve_drink>
     28c:	e9 b9 00 00 00       	jmp    34a <bartender+0x126>
	}
	else if(bartender_action->action_type == RETURN_CUP){
     291:	8b 45 dc             	mov    -0x24(%ebp),%eax
     294:	8b 00                	mov    (%eax),%eax
     296:	83 f8 02             	cmp    $0x2,%eax
     299:	0f 85 ab 00 00 00    	jne    34a <bartender+0x126>
	  struct Cup* current_cup = bartender_action->cup;  
     29f:	8b 45 dc             	mov    -0x24(%ebp),%eax
     2a2:	8b 40 04             	mov    0x4(%eax),%eax
     2a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	  return_cup(current_cup);
     2a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     2ab:	89 04 24             	mov    %eax,(%esp)
     2ae:	e8 0a fe ff ff       	call   bd <return_cup>
	  //need to write to file intsead of screen TODO
	  printf(1,"Bartender %d returned cup %d\n",tid,current_cup->id);
     2b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     2b6:	8b 00                	mov    (%eax),%eax
     2b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
     2bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2bf:	89 44 24 08          	mov    %eax,0x8(%esp)
     2c3:	c7 44 24 04 86 18 00 	movl   $0x1886,0x4(%esp)
     2ca:	00 
     2cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2d2:	e8 0c 0d 00 00       	call   fe3 <printf>
	  amount = DBB->full->value;
     2d7:	a1 28 20 00 00       	mov    0x2028,%eax
     2dc:	8b 40 0c             	mov    0xc(%eax),%eax
     2df:	8b 40 08             	mov    0x8(%eax),%eax
     2e2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     2e5:	db 45 c4             	fildl  -0x3c(%ebp)
     2e8:	dd 5d e8             	fstpl  -0x18(%ebp)
	  buf_size = DBB->buffer_size;
     2eb:	a1 28 20 00 00       	mov    0x2028,%eax
     2f0:	8b 00                	mov    (%eax),%eax
     2f2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     2f5:	db 45 c4             	fildl  -0x3c(%ebp)
     2f8:	dd 5d e0             	fstpl  -0x20(%ebp)

	  if(amount/buf_size >= 0.6){
     2fb:	dd 45 e8             	fldl   -0x18(%ebp)
     2fe:	dc 75 e0             	fdivl  -0x20(%ebp)
     301:	dd 05 b8 19 00 00    	fldl   0x19b8
     307:	d9 c9                	fxch   %st(1)
     309:	df e9                	fucomip %st(1),%st
     30b:	dd d8                	fstp   %st(0)
     30d:	0f 93 c0             	setae  %al
     310:	84 c0                	test   %al,%al
     312:	74 21                	je     335 <bartender+0x111>
	    printf(1,"Go Clean Boy %d\n");
     314:	c7 44 24 04 a4 18 00 	movl   $0x18a4,0x4(%esp)
     31b:	00 
     31c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     323:	e8 bb 0c 00 00       	call   fe3 <printf>
	    binary_semaphore_up(cup_boy_lock);
     328:	a1 4c 20 00 00       	mov    0x204c,%eax
     32d:	89 04 24             	mov    %eax,(%esp)
     330:	e8 cf 0b 00 00       	call   f04 <binary_semaphore_up>
	    }
	if(bartender_action->action_type == GO_HOME){
     335:	8b 45 dc             	mov    -0x24(%ebp),%eax
     338:	8b 00                	mov    (%eax),%eax
     33a:	83 f8 03             	cmp    $0x3,%eax
     33d:	75 0b                	jne    34a <bartender+0x126>
	  thread_exit(ret_val);
     33f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     342:	89 04 24             	mov    %eax,(%esp)
     345:	e8 a2 0b 00 00       	call   eec <thread_exit>
	}
	}
	free(bartender_action);
     34a:	8b 45 dc             	mov    -0x24(%ebp),%eax
     34d:	89 04 24             	mov    %eax,(%esp)
     350:	e8 43 0e 00 00       	call   1198 <free>
	//TODO remove
	//bartender_action->action_type = UNDEFINED;
	//bartender_action->cup = 0;
    }
     355:	e9 e9 fe ff ff       	jmp    243 <bartender+0x1f>

0000035a <cup_boy>:
    return ret_val;
}


// Cup boy simulation
void* cup_boy(void){
     35a:	55                   	push   %ebp
     35b:	89 e5                	mov    %esp,%ebp
     35d:	83 ec 28             	sub    $0x28,%esp
  void* ret_val = 0;
     360:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
   printf(1,"Clean Boy came to work\n");
     367:	c7 44 24 04 b5 18 00 	movl   $0x18b5,0x4(%esp)
     36e:	00 
     36f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     376:	e8 68 0c 00 00       	call   fe3 <printf>
  cup_boy_lock = binary_semaphore_create(0);
     37b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     382:	e8 6d 0b 00 00       	call   ef4 <binary_semaphore_create>
     387:	a3 4c 20 00 00       	mov    %eax,0x204c
     38c:	eb 01                	jmp    38f <cup_boy+0x35>
    }
   binary_semaphore_down(cup_boy_lock); 
   if(finished_shift){
	thread_exit(ret_val);
    }
  }
     38e:	90                   	nop
   printf(1,"Clean Boy came to work\n");
  cup_boy_lock = binary_semaphore_create(0);
  int i,n;
  for(;;){
     //n = BB_size(DBB);//TODO is it bad?
    n =DBB->full->value;
     38f:	a1 28 20 00 00       	mov    0x2028,%eax
     394:	8b 40 0c             	mov    0xc(%eax),%eax
     397:	8b 40 08             	mov    0x8(%eax),%eax
     39a:	89 45 ec             	mov    %eax,-0x14(%ebp)
   
    
    for(i = 0; i < n; i++){
     39d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3a4:	eb 40                	jmp    3e6 <cup_boy+0x8c>
	struct Cup* current_cup = wash_dirty();
     3a6:	e8 2e fd ff ff       	call   d9 <wash_dirty>
     3ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sleep(1);
     3ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3b5:	e8 02 0b 00 00       	call   ebc <sleep>
	add_clean_cup(current_cup);
     3ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
     3bd:	89 04 24             	mov    %eax,(%esp)
     3c0:	e8 dc fc ff ff       	call   a1 <add_clean_cup>
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
     3c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     3c8:	8b 00                	mov    (%eax),%eax
     3ca:	89 44 24 08          	mov    %eax,0x8(%esp)
     3ce:	c7 44 24 04 cd 18 00 	movl   $0x18cd,0x4(%esp)
     3d5:	00 
     3d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3dd:	e8 01 0c 00 00       	call   fe3 <printf>
  for(;;){
     //n = BB_size(DBB);//TODO is it bad?
    n =DBB->full->value;
   
    
    for(i = 0; i < n; i++){
     3e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     3e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     3ec:	7c b8                	jl     3a6 <cup_boy+0x4c>
	sleep(1);
	add_clean_cup(current_cup);
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
    }
   binary_semaphore_down(cup_boy_lock); 
     3ee:	a1 4c 20 00 00       	mov    0x204c,%eax
     3f3:	89 04 24             	mov    %eax,(%esp)
     3f6:	e8 01 0b 00 00       	call   efc <binary_semaphore_down>
   if(finished_shift){
     3fb:	a1 20 20 00 00       	mov    0x2020,%eax
     400:	85 c0                	test   %eax,%eax
     402:	74 8a                	je     38e <cup_boy+0x34>
	thread_exit(ret_val);
     404:	8b 45 f0             	mov    -0x10(%ebp),%eax
     407:	89 04 24             	mov    %eax,(%esp)
     40a:	e8 dd 0a 00 00       	call   eec <thread_exit>
    }
  }
     40f:	e9 7a ff ff ff       	jmp    38e <cup_boy+0x34>

00000414 <join_peoples>:
  return 0;
}

// thread_joins on students and bartenders

void join_peoples(int* tids,int num_of_peoples){
     414:	55                   	push   %ebp
     415:	89 e5                	mov    %esp,%ebp
     417:	83 ec 28             	sub    $0x28,%esp
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     41a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     421:	eb 1e                	jmp    441 <join_peoples+0x2d>
      thread_join(tids[i],&ret_val);
     423:	8b 45 f4             	mov    -0xc(%ebp),%eax
     426:	c1 e0 02             	shl    $0x2,%eax
     429:	03 45 08             	add    0x8(%ebp),%eax
     42c:	8b 00                	mov    (%eax),%eax
     42e:	8d 55 f0             	lea    -0x10(%ebp),%edx
     431:	89 54 24 04          	mov    %edx,0x4(%esp)
     435:	89 04 24             	mov    %eax,(%esp)
     438:	e8 a7 0a 00 00       	call   ee4 <thread_join>
// thread_joins on students and bartenders

void join_peoples(int* tids,int num_of_peoples){
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
     43d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     441:	8b 45 f4             	mov    -0xc(%ebp),%eax
     444:	3b 45 0c             	cmp    0xc(%ebp),%eax
     447:	7c da                	jl     423 <join_peoples+0xf>
      thread_join(tids[i],&ret_val);
  }
}
     449:	c9                   	leave  
     44a:	c3                   	ret    

0000044b <release_workers>:


//release the workers(bartenders + cup_boy) that run in infinite loops 
void release_workers(int num_of_bartenders){
     44b:	55                   	push   %ebp
     44c:	89 e5                	mov    %esp,%ebp
     44e:	83 ec 28             	sub    $0x28,%esp
 int i;
 struct Action* release_bartender_action = 0;
     451:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 release_bartender_action->action_type = GO_HOME;
     458:	8b 45 f0             	mov    -0x10(%ebp),%eax
     45b:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
 release_bartender_action->cup = 0;
     461:	8b 45 f0             	mov    -0x10(%ebp),%eax
     464:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 //release bartenders
 for(i = 0; i< num_of_bartenders; i++){
     46b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     472:	eb 0f                	jmp    483 <release_workers+0x38>
    place_action(release_bartender_action);
     474:	8b 45 f0             	mov    -0x10(%ebp),%eax
     477:	89 04 24             	mov    %eax,(%esp)
     47a:	e8 ab fb ff ff       	call   2a <place_action>
 int i;
 struct Action* release_bartender_action = 0;
 release_bartender_action->action_type = GO_HOME;
 release_bartender_action->cup = 0;
 //release bartenders
 for(i = 0; i< num_of_bartenders; i++){
     47f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     483:	8b 45 f4             	mov    -0xc(%ebp),%eax
     486:	3b 45 08             	cmp    0x8(%ebp),%eax
     489:	7c e9                	jl     474 <release_workers+0x29>
    place_action(release_bartender_action);
 }
 //release cup_boy
 binary_semaphore_up(cup_boy_lock);
     48b:	a1 4c 20 00 00       	mov    0x204c,%eax
     490:	89 04 24             	mov    %eax,(%esp)
     493:	e8 6c 0a 00 00       	call   f04 <binary_semaphore_up>
}
     498:	c9                   	leave  
     499:	c3                   	ret    

0000049a <values_array_index>:


//return the index to put the value {A, B, C, S, M}
//				     {0, 1, 2, 3, 4}
int values_array_index(char* input_buf, int char_index){
     49a:	55                   	push   %ebp
     49b:	89 e5                	mov    %esp,%ebp
 if(input_buf[char_index] == 'A')
     49d:	8b 45 0c             	mov    0xc(%ebp),%eax
     4a0:	03 45 08             	add    0x8(%ebp),%eax
     4a3:	0f b6 00             	movzbl (%eax),%eax
     4a6:	3c 41                	cmp    $0x41,%al
     4a8:	75 07                	jne    4b1 <values_array_index+0x17>
   return 0;
     4aa:	b8 00 00 00 00       	mov    $0x0,%eax
     4af:	eb 55                	jmp    506 <values_array_index+0x6c>
 if(input_buf[char_index] == 'B')
     4b1:	8b 45 0c             	mov    0xc(%ebp),%eax
     4b4:	03 45 08             	add    0x8(%ebp),%eax
     4b7:	0f b6 00             	movzbl (%eax),%eax
     4ba:	3c 42                	cmp    $0x42,%al
     4bc:	75 07                	jne    4c5 <values_array_index+0x2b>
   return 1;
     4be:	b8 01 00 00 00       	mov    $0x1,%eax
     4c3:	eb 41                	jmp    506 <values_array_index+0x6c>
 if(input_buf[char_index] == 'C')
     4c5:	8b 45 0c             	mov    0xc(%ebp),%eax
     4c8:	03 45 08             	add    0x8(%ebp),%eax
     4cb:	0f b6 00             	movzbl (%eax),%eax
     4ce:	3c 43                	cmp    $0x43,%al
     4d0:	75 07                	jne    4d9 <values_array_index+0x3f>
   return 2;
     4d2:	b8 02 00 00 00       	mov    $0x2,%eax
     4d7:	eb 2d                	jmp    506 <values_array_index+0x6c>
 if(input_buf[char_index] == 'S')
     4d9:	8b 45 0c             	mov    0xc(%ebp),%eax
     4dc:	03 45 08             	add    0x8(%ebp),%eax
     4df:	0f b6 00             	movzbl (%eax),%eax
     4e2:	3c 53                	cmp    $0x53,%al
     4e4:	75 07                	jne    4ed <values_array_index+0x53>
   return 3;
     4e6:	b8 03 00 00 00       	mov    $0x3,%eax
     4eb:	eb 19                	jmp    506 <values_array_index+0x6c>
 if(input_buf[char_index] == 'M')
     4ed:	8b 45 0c             	mov    0xc(%ebp),%eax
     4f0:	03 45 08             	add    0x8(%ebp),%eax
     4f3:	0f b6 00             	movzbl (%eax),%eax
     4f6:	3c 4d                	cmp    $0x4d,%al
     4f8:	75 07                	jne    501 <values_array_index+0x67>
   return 4;
     4fa:	b8 04 00 00 00       	mov    $0x4,%eax
     4ff:	eb 05                	jmp    506 <values_array_index+0x6c>
 //error
 return -1;
     501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     506:	5d                   	pop    %ebp
     507:	c3                   	ret    

00000508 <parse_buffer>:

//parsing the configuration file
void parse_buffer(char* input_buf,int* values_array){
     508:	55                   	push   %ebp
     509:	89 e5                	mov    %esp,%ebp
     50b:	53                   	push   %ebx
     50c:	83 ec 24             	sub    $0x24,%esp
 int i;
 int num_of_chars = strlen(input_buf);
     50f:	8b 45 08             	mov    0x8(%ebp),%eax
     512:	89 04 24             	mov    %eax,(%esp)
     515:	e8 48 07 00 00       	call   c62 <strlen>
     51a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     51d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     524:	eb 7e                	jmp    5a4 <parse_buffer+0x9c>
    if(input_buf[i] == 'A' || input_buf[i] == 'B' || input_buf[i] == 'C' || input_buf[i] == 'S' || input_buf[i] == 'M'){
     526:	8b 45 f4             	mov    -0xc(%ebp),%eax
     529:	03 45 08             	add    0x8(%ebp),%eax
     52c:	0f b6 00             	movzbl (%eax),%eax
     52f:	3c 41                	cmp    $0x41,%al
     531:	74 34                	je     567 <parse_buffer+0x5f>
     533:	8b 45 f4             	mov    -0xc(%ebp),%eax
     536:	03 45 08             	add    0x8(%ebp),%eax
     539:	0f b6 00             	movzbl (%eax),%eax
     53c:	3c 42                	cmp    $0x42,%al
     53e:	74 27                	je     567 <parse_buffer+0x5f>
     540:	8b 45 f4             	mov    -0xc(%ebp),%eax
     543:	03 45 08             	add    0x8(%ebp),%eax
     546:	0f b6 00             	movzbl (%eax),%eax
     549:	3c 43                	cmp    $0x43,%al
     54b:	74 1a                	je     567 <parse_buffer+0x5f>
     54d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     550:	03 45 08             	add    0x8(%ebp),%eax
     553:	0f b6 00             	movzbl (%eax),%eax
     556:	3c 53                	cmp    $0x53,%al
     558:	74 0d                	je     567 <parse_buffer+0x5f>
     55a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     55d:	03 45 08             	add    0x8(%ebp),%eax
     560:	0f b6 00             	movzbl (%eax),%eax
     563:	3c 4d                	cmp    $0x4d,%al
     565:	75 39                	jne    5a0 <parse_buffer+0x98>
       index = values_array_index(input_buf,i);
     567:	8b 45 f4             	mov    -0xc(%ebp),%eax
     56a:	89 44 24 04          	mov    %eax,0x4(%esp)
     56e:	8b 45 08             	mov    0x8(%ebp),%eax
     571:	89 04 24             	mov    %eax,(%esp)
     574:	e8 21 ff ff ff       	call   49a <values_array_index>
     579:	89 45 ec             	mov    %eax,-0x14(%ebp)
       temp_str = &input_buf[i];
     57c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     57f:	03 45 08             	add    0x8(%ebp),%eax
     582:	89 45 e8             	mov    %eax,-0x18(%ebp)
       values_array[index] = atoi(temp_str+4);
     585:	8b 45 ec             	mov    -0x14(%ebp),%eax
     588:	c1 e0 02             	shl    $0x2,%eax
     58b:	89 c3                	mov    %eax,%ebx
     58d:	03 5d 0c             	add    0xc(%ebp),%ebx
     590:	8b 45 e8             	mov    -0x18(%ebp),%eax
     593:	83 c0 04             	add    $0x4,%eax
     596:	89 04 24             	mov    %eax,(%esp)
     599:	e8 fd 07 00 00       	call   d9b <atoi>
     59e:	89 03                	mov    %eax,(%ebx)
void parse_buffer(char* input_buf,int* values_array){
 int i;
 int num_of_chars = strlen(input_buf);
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
     5a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     5a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     5aa:	0f 8c 76 ff ff ff    	jl     526 <parse_buffer+0x1e>
       index = values_array_index(input_buf,i);
       temp_str = &input_buf[i];
       values_array[index] = atoi(temp_str+4);
    }
 }
}
     5b0:	83 c4 24             	add    $0x24,%esp
     5b3:	5b                   	pop    %ebx
     5b4:	5d                   	pop    %ebp
     5b5:	c3                   	ret    

000005b6 <main>:


int main(int argc, char** argv) {
     5b6:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     5ba:	83 e4 f0             	and    $0xfffffff0,%esp
     5bd:	ff 71 fc             	pushl  -0x4(%ecx)
     5c0:	55                   	push   %ebp
     5c1:	89 e5                	mov    %esp,%ebp
     5c3:	51                   	push   %ecx
     5c4:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  int M;	// maximum number of students that can be at the bar at once
  int fconf;
  int conf_size;
  struct stat bufstat;
  
  fconf = open("con.conf",O_RDONLY);
     5ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     5d1:	00 
     5d2:	c7 04 24 e9 18 00 00 	movl   $0x18e9,(%esp)
     5d9:	e8 8e 08 00 00       	call   e6c <open>
     5de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  fstat(fconf,&bufstat);
     5e1:	8d 45 8c             	lea    -0x74(%ebp),%eax
     5e4:	89 44 24 04          	mov    %eax,0x4(%esp)
     5e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5eb:	89 04 24             	mov    %eax,(%esp)
     5ee:	e8 91 08 00 00       	call   e84 <fstat>
  conf_size = bufstat.size;
     5f3:	8b 45 9c             	mov    -0x64(%ebp),%eax
     5f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  char bufconf[conf_size];
     5f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5fc:	8d 50 ff             	lea    -0x1(%eax),%edx
     5ff:	89 55 e8             	mov    %edx,-0x18(%ebp)
     602:	8d 50 0f             	lea    0xf(%eax),%edx
     605:	b8 10 00 00 00       	mov    $0x10,%eax
     60a:	83 e8 01             	sub    $0x1,%eax
     60d:	01 d0                	add    %edx,%eax
     60f:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     616:	00 00 00 
     619:	ba 00 00 00 00       	mov    $0x0,%edx
     61e:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     624:	6b c0 10             	imul   $0x10,%eax,%eax
     627:	29 c4                	sub    %eax,%esp
     629:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     62d:	83 c0 0f             	add    $0xf,%eax
     630:	c1 e8 04             	shr    $0x4,%eax
     633:	c1 e0 04             	shl    $0x4,%eax
     636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  read(fconf,bufconf,conf_size);
     639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     63c:	8b 55 ec             	mov    -0x14(%ebp),%edx
     63f:	89 54 24 08          	mov    %edx,0x8(%esp)
     643:	89 44 24 04          	mov    %eax,0x4(%esp)
     647:	8b 45 f0             	mov    -0x10(%ebp),%eax
     64a:	89 04 24             	mov    %eax,(%esp)
     64d:	e8 f2 07 00 00       	call   e44 <read>
  int inputs_parsed[5]; //{Aval, Bval, Cval, Sval, Mval}
  
  parse_buffer(bufconf, inputs_parsed);
     652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     655:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
     65b:	89 54 24 04          	mov    %edx,0x4(%esp)
     65f:	89 04 24             	mov    %eax,(%esp)
     662:	e8 a1 fe ff ff       	call   508 <parse_buffer>
  A = inputs_parsed[0];
     667:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
     66d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  B = inputs_parsed[1];
     670:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
     676:	89 45 dc             	mov    %eax,-0x24(%ebp)
  C = inputs_parsed[2];
     679:	8b 45 80             	mov    -0x80(%ebp),%eax
     67c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  S = inputs_parsed[3];
     67f:	8b 45 84             	mov    -0x7c(%ebp),%eax
     682:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  M = inputs_parsed[4];
     685:	8b 45 88             	mov    -0x78(%ebp),%eax
     688:	89 45 d0             	mov    %eax,-0x30(%ebp)
  
  printf(1,"A: %d B: %d C: %d  S: %d M: %d\n",A,B,C,S,M);
     68b:	8b 45 d0             	mov    -0x30(%ebp),%eax
     68e:	89 44 24 18          	mov    %eax,0x18(%esp)
     692:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     695:	89 44 24 14          	mov    %eax,0x14(%esp)
     699:	8b 45 d8             	mov    -0x28(%ebp),%eax
     69c:	89 44 24 10          	mov    %eax,0x10(%esp)
     6a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     6a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
     6a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     6aa:	89 44 24 08          	mov    %eax,0x8(%esp)
     6ae:	c7 44 24 04 f4 18 00 	movl   $0x18f4,0x4(%esp)
     6b5:	00 
     6b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6bd:	e8 21 09 00 00       	call   fe3 <printf>
  
  void* students_stacks[S];
     6c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     6c5:	8d 50 ff             	lea    -0x1(%eax),%edx
     6c8:	89 55 cc             	mov    %edx,-0x34(%ebp)
     6cb:	c1 e0 02             	shl    $0x2,%eax
     6ce:	8d 50 0f             	lea    0xf(%eax),%edx
     6d1:	b8 10 00 00 00       	mov    $0x10,%eax
     6d6:	83 e8 01             	sub    $0x1,%eax
     6d9:	01 d0                	add    %edx,%eax
     6db:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     6e2:	00 00 00 
     6e5:	ba 00 00 00 00       	mov    $0x0,%edx
     6ea:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     6f0:	6b c0 10             	imul   $0x10,%eax,%eax
     6f3:	29 c4                	sub    %eax,%esp
     6f5:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     6f9:	83 c0 0f             	add    $0xf,%eax
     6fc:	c1 e8 04             	shr    $0x4,%eax
     6ff:	c1 e0 04             	shl    $0x4,%eax
     702:	89 45 c8             	mov    %eax,-0x38(%ebp)
  void* bartenders_stacks[B];
     705:	8b 45 dc             	mov    -0x24(%ebp),%eax
     708:	8d 50 ff             	lea    -0x1(%eax),%edx
     70b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
     70e:	c1 e0 02             	shl    $0x2,%eax
     711:	8d 50 0f             	lea    0xf(%eax),%edx
     714:	b8 10 00 00 00       	mov    $0x10,%eax
     719:	83 e8 01             	sub    $0x1,%eax
     71c:	01 d0                	add    %edx,%eax
     71e:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     725:	00 00 00 
     728:	ba 00 00 00 00       	mov    $0x0,%edx
     72d:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     733:	6b c0 10             	imul   $0x10,%eax,%eax
     736:	29 c4                	sub    %eax,%esp
     738:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     73c:	83 c0 0f             	add    $0xf,%eax
     73f:	c1 e8 04             	shr    $0x4,%eax
     742:	c1 e0 04             	shl    $0x4,%eax
     745:	89 45 c0             	mov    %eax,-0x40(%ebp)
  void* cup_boy_stack;
  int i;
  int student_tids[S];
     748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     74b:	8d 50 ff             	lea    -0x1(%eax),%edx
     74e:	89 55 bc             	mov    %edx,-0x44(%ebp)
     751:	c1 e0 02             	shl    $0x2,%eax
     754:	8d 50 0f             	lea    0xf(%eax),%edx
     757:	b8 10 00 00 00       	mov    $0x10,%eax
     75c:	83 e8 01             	sub    $0x1,%eax
     75f:	01 d0                	add    %edx,%eax
     761:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     768:	00 00 00 
     76b:	ba 00 00 00 00       	mov    $0x0,%edx
     770:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     776:	6b c0 10             	imul   $0x10,%eax,%eax
     779:	29 c4                	sub    %eax,%esp
     77b:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     77f:	83 c0 0f             	add    $0xf,%eax
     782:	c1 e8 04             	shr    $0x4,%eax
     785:	c1 e0 04             	shl    $0x4,%eax
     788:	89 45 b8             	mov    %eax,-0x48(%ebp)
  int bartender_tids[B];
     78b:	8b 45 dc             	mov    -0x24(%ebp),%eax
     78e:	8d 50 ff             	lea    -0x1(%eax),%edx
     791:	89 55 b4             	mov    %edx,-0x4c(%ebp)
     794:	c1 e0 02             	shl    $0x2,%eax
     797:	8d 50 0f             	lea    0xf(%eax),%edx
     79a:	b8 10 00 00 00       	mov    $0x10,%eax
     79f:	83 e8 01             	sub    $0x1,%eax
     7a2:	01 d0                	add    %edx,%eax
     7a4:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     7ab:	00 00 00 
     7ae:	ba 00 00 00 00       	mov    $0x0,%edx
     7b3:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     7b9:	6b c0 10             	imul   $0x10,%eax,%eax
     7bc:	29 c4                	sub    %eax,%esp
     7be:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     7c2:	83 c0 0f             	add    $0xf,%eax
     7c5:	c1 e8 04             	shr    $0x4,%eax
     7c8:	c1 e0 04             	shl    $0x4,%eax
     7cb:	89 45 b0             	mov    %eax,-0x50(%ebp)
  int finished_shift = 0; // cup_boy changes it to 1 if all students left the bar and sends Action => GO_HOME to bartenders
     7ce:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)

  
  file_to_write = open("out.txt",(O_CREATE | O_WRONLY)); //
     7d5:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     7dc:	00 
     7dd:	c7 04 24 14 19 00 00 	movl   $0x1914,(%esp)
     7e4:	e8 83 06 00 00       	call   e6c <open>
     7e9:	a3 30 20 00 00       	mov    %eax,0x2030
  if(file_to_write == -1){
     7ee:	a1 30 20 00 00       	mov    0x2030,%eax
     7f3:	83 f8 ff             	cmp    $0xffffffff,%eax
     7f6:	75 19                	jne    811 <main+0x25b>
      printf(1,"There was an error opening out.txt\n");
     7f8:	c7 44 24 04 1c 19 00 	movl   $0x191c,0x4(%esp)
     7ff:	00 
     800:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     807:	e8 d7 07 00 00       	call   fe3 <printf>
      exit();
     80c:	e8 1b 06 00 00       	call   e2c <exit>
  }
  
  
  //Databases
   bouncer = semaphore_create(M);		//this is the bouncer to the Beinstein
     811:	8b 45 d0             	mov    -0x30(%ebp),%eax
     814:	89 04 24             	mov    %eax,(%esp)
     817:	e8 8c 0b 00 00       	call   13a8 <semaphore_create>
     81c:	a3 1c 20 00 00       	mov    %eax,0x201c
   ABB = BB_create(A); 				//this is a BB for student actions: drink, ans for a dring
     821:	8b 45 e0             	mov    -0x20(%ebp),%eax
     824:	89 04 24             	mov    %eax,(%esp)
     827:	e8 d4 0c 00 00       	call   1500 <BB_create>
     82c:	a3 24 20 00 00       	mov    %eax,0x2024
   DrinkBB = BB_create(A);			//this is a BB holding the drinks that are ready to be drinking
     831:	8b 45 e0             	mov    -0x20(%ebp),%eax
     834:	89 04 24             	mov    %eax,(%esp)
     837:	e8 c4 0c 00 00       	call   1500 <BB_create>
     83c:	a3 34 20 00 00       	mov    %eax,0x2034
   CBB = BB_create(C);				//this is a BB hold clean cups
     841:	8b 45 d8             	mov    -0x28(%ebp),%eax
     844:	89 04 24             	mov    %eax,(%esp)
     847:	e8 b4 0c 00 00       	call   1500 <BB_create>
     84c:	a3 50 20 00 00       	mov    %eax,0x2050
   DBB = BB_create(C);				//this is a BB hold dirty cups
     851:	8b 45 d8             	mov    -0x28(%ebp),%eax
     854:	89 04 24             	mov    %eax,(%esp)
     857:	e8 a4 0c 00 00       	call   1500 <BB_create>
     85c:	a3 28 20 00 00       	mov    %eax,0x2028
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
     861:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     868:	e8 87 06 00 00       	call   ef4 <binary_semaphore_create>
     86d:	a3 4c 20 00 00       	mov    %eax,0x204c
   general_mutex = binary_semaphore_create(1);
     872:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     879:	e8 76 06 00 00       	call   ef4 <binary_semaphore_create>
     87e:	a3 2c 20 00 00       	mov    %eax,0x202c

   //initialize C clean cups
   struct Cup* cup_array[C];
     883:	8b 45 d8             	mov    -0x28(%ebp),%eax
     886:	8d 50 ff             	lea    -0x1(%eax),%edx
     889:	89 55 a8             	mov    %edx,-0x58(%ebp)
     88c:	c1 e0 02             	shl    $0x2,%eax
     88f:	8d 50 0f             	lea    0xf(%eax),%edx
     892:	b8 10 00 00 00       	mov    $0x10,%eax
     897:	83 e8 01             	sub    $0x1,%eax
     89a:	01 d0                	add    %edx,%eax
     89c:	c7 85 74 ff ff ff 10 	movl   $0x10,-0x8c(%ebp)
     8a3:	00 00 00 
     8a6:	ba 00 00 00 00       	mov    $0x0,%edx
     8ab:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
     8b1:	6b c0 10             	imul   $0x10,%eax,%eax
     8b4:	29 c4                	sub    %eax,%esp
     8b6:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     8ba:	83 c0 0f             	add    $0xf,%eax
     8bd:	c1 e8 04             	shr    $0x4,%eax
     8c0:	c1 e0 04             	shl    $0x4,%eax
     8c3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
   for(i = 0; i < C; i++){
     8c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     8cd:	eb 38                	jmp    907 <main+0x351>
      cup_array[i] = malloc(sizeof(struct Cup)); //TODO free cups
     8cf:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     8d6:	e8 ec 09 00 00       	call   12c7 <malloc>
     8db:	8b 55 a4             	mov    -0x5c(%ebp),%edx
     8de:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     8e1:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      cup_array[i]->id = i;
     8e4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     8e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8ea:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8f0:	89 10                	mov    %edx,(%eax)
      add_clean_cup(cup_array[i]);
     8f2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     8f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8f8:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8fb:	89 04 24             	mov    %eax,(%esp)
     8fe:	e8 9e f7 ff ff       	call   a1 <add_clean_cup>
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
   general_mutex = binary_semaphore_create(1);

   //initialize C clean cups
   struct Cup* cup_array[C];
   for(i = 0; i < C; i++){
     903:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     907:	8b 45 f4             	mov    -0xc(%ebp),%eax
     90a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     90d:	7c c0                	jl     8cf <main+0x319>
      cup_array[i]->id = i;
      add_clean_cup(cup_array[i]);
   }
   
   //initialize cup_boy
   cup_boy_stack = (void*)malloc(sizeof(void*)*STACK_SIZE);
     90f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     916:	e8 ac 09 00 00       	call   12c7 <malloc>
     91b:	89 45 a0             	mov    %eax,-0x60(%ebp)
    memset(cup_boy_stack,0,sizeof(void*)*1024);
     91e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     925:	00 
     926:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     92d:	00 
     92e:	8b 45 a0             	mov    -0x60(%ebp),%eax
     931:	89 04 24             	mov    %eax,(%esp)
     934:	e8 4e 03 00 00       	call   c87 <memset>
   if(thread_create((void*)cup_boy,cup_boy_stack,sizeof(void*)*1024) < 0){
     939:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     940:	00 
     941:	8b 45 a0             	mov    -0x60(%ebp),%eax
     944:	89 44 24 04          	mov    %eax,0x4(%esp)
     948:	c7 04 24 5a 03 00 00 	movl   $0x35a,(%esp)
     94f:	e8 78 05 00 00       	call   ecc <thread_create>
     954:	85 c0                	test   %eax,%eax
     956:	79 19                	jns    971 <main+0x3bb>
     printf(2,"Failed to create cupboy thread. Exiting...\n");
     958:	c7 44 24 04 40 19 00 	movl   $0x1940,0x4(%esp)
     95f:	00 
     960:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     967:	e8 77 06 00 00       	call   fe3 <printf>
    exit();
     96c:	e8 bb 04 00 00       	call   e2c <exit>
   }
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     971:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     978:	eb 64                	jmp    9de <main+0x428>
      bartenders_stacks[i] = (void*)malloc(sizeof(void*)*STACK_SIZE);
     97a:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     981:	e8 41 09 00 00       	call   12c7 <malloc>
     986:	8b 55 c0             	mov    -0x40(%ebp),%edx
     989:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     98c:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(bartenders_stacks[i],0,sizeof(void*)*1024);
     98f:	8b 45 c0             	mov    -0x40(%ebp),%eax
     992:	8b 55 f4             	mov    -0xc(%ebp),%edx
     995:	8b 04 90             	mov    (%eax,%edx,4),%eax
     998:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     99f:	00 
     9a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     9a7:	00 
     9a8:	89 04 24             	mov    %eax,(%esp)
     9ab:	e8 d7 02 00 00       	call   c87 <memset>
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
     9b0:	8b 45 c0             	mov    -0x40(%ebp),%eax
     9b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9b6:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9b9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     9c0:	00 
     9c1:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c5:	c7 04 24 24 02 00 00 	movl   $0x224,(%esp)
     9cc:	e8 fb 04 00 00       	call   ecc <thread_create>
     9d1:	8b 55 b0             	mov    -0x50(%ebp),%edx
     9d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     9d7:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     printf(2,"Failed to create cupboy thread. Exiting...\n");
    exit();
   }
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
     9da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9de:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9e1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     9e4:	7c 94                	jl     97a <main+0x3c4>
      memset(bartenders_stacks[i],0,sizeof(void*)*1024);
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
  }
   
   //initialize S students
   for(i = 0; i < S; i++){//TODO test for fail
     9e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9ed:	eb 64                	jmp    a53 <main+0x49d>
      students_stacks[i] = malloc(sizeof(void*)*STACK_SIZE);
     9ef:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     9f6:	e8 cc 08 00 00       	call   12c7 <malloc>
     9fb:	8b 55 c8             	mov    -0x38(%ebp),%edx
     9fe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a01:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
     a04:	8b 45 c8             	mov    -0x38(%ebp),%eax
     a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a0a:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a0d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     a14:	00 
     a15:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     a1c:	00 
     a1d:	89 04 24             	mov    %eax,(%esp)
     a20:	e8 62 02 00 00       	call   c87 <memset>
      student_tids[i] = thread_create((void*)student,students_stacks[i],sizeof(void*)*STACK_SIZE);
     a25:	8b 45 c8             	mov    -0x38(%ebp),%eax
     a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a2b:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a2e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     a35:	00 
     a36:	89 44 24 04          	mov    %eax,0x4(%esp)
     a3a:	c7 04 24 ee 00 00 00 	movl   $0xee,(%esp)
     a41:	e8 86 04 00 00       	call   ecc <thread_create>
     a46:	8b 55 b8             	mov    -0x48(%ebp),%edx
     a49:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     a4c:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
      memset(bartenders_stacks[i],0,sizeof(void*)*1024);
      bartender_tids[i] = thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
  }
   
   //initialize S students
   for(i = 0; i < S; i++){//TODO test for fail
     a4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a56:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     a59:	7c 94                	jl     9ef <main+0x439>
      students_stacks[i] = malloc(sizeof(void*)*STACK_SIZE);
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
      student_tids[i] = thread_create((void*)student,students_stacks[i],sizeof(void*)*STACK_SIZE);
  }
  
   printf(1,"Join peopele\n");
     a5b:	c7 44 24 04 6c 19 00 	movl   $0x196c,0x4(%esp)
     a62:	00 
     a63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a6a:	e8 74 05 00 00       	call   fe3 <printf>
   join_peoples(student_tids,S); //join students
     a6f:	8b 45 b8             	mov    -0x48(%ebp),%eax
     a72:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     a75:	89 54 24 04          	mov    %edx,0x4(%esp)
     a79:	89 04 24             	mov    %eax,(%esp)
     a7c:	e8 93 f9 ff ff       	call   414 <join_peoples>
   finished_shift = 1;
     a81:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
   if(finished_shift){
     a88:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
     a8c:	74 0d                	je     a9b <main+0x4e5>
    binary_semaphore_up(cup_boy_lock); 
     a8e:	a1 4c 20 00 00       	mov    0x204c,%eax
     a93:	89 04 24             	mov    %eax,(%esp)
     a96:	e8 69 04 00 00       	call   f04 <binary_semaphore_up>
   }
    printf(1,"Done Join peopele\n");
     a9b:	c7 44 24 04 7a 19 00 	movl   $0x197a,0x4(%esp)
     aa2:	00 
     aa3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     aaa:	e8 34 05 00 00       	call   fe3 <printf>
   release_workers(B);
     aaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
     ab2:	89 04 24             	mov    %eax,(%esp)
     ab5:	e8 91 f9 ff ff       	call   44b <release_workers>
   join_peoples(bartender_tids,B); //join bartenders
     aba:	8b 45 b0             	mov    -0x50(%ebp),%eax
     abd:	8b 55 dc             	mov    -0x24(%ebp),%edx
     ac0:	89 54 24 04          	mov    %edx,0x4(%esp)
     ac4:	89 04 24             	mov    %eax,(%esp)
     ac7:	e8 48 f9 ff ff       	call   414 <join_peoples>
   sleep(2); // delay so exit will not come before threads finished TODO (need better soloution)
     acc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ad3:	e8 e4 03 00 00       	call   ebc <sleep>
   
   if(close(file_to_write) == -1){
     ad8:	a1 30 20 00 00       	mov    0x2030,%eax
     add:	89 04 24             	mov    %eax,(%esp)
     ae0:	e8 6f 03 00 00       	call   e54 <close>
     ae5:	83 f8 ff             	cmp    $0xffffffff,%eax
     ae8:	75 19                	jne    b03 <main+0x54d>
    printf(1,"There was an error closing out.txt\n");
     aea:	c7 44 24 04 90 19 00 	movl   $0x1990,0x4(%esp)
     af1:	00 
     af2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     af9:	e8 e5 04 00 00       	call   fe3 <printf>
    exit();
     afe:	e8 29 03 00 00       	call   e2c <exit>
   }
   
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     b03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b0a:	eb 15                	jmp    b21 <main+0x56b>
    free(cup_array[i]);
     b0c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     b0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b12:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b15:	89 04 24             	mov    %eax,(%esp)
     b18:	e8 7b 06 00 00       	call   1198 <free>
    exit();
   }
   
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
     b1d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b24:	3b 45 d8             	cmp    -0x28(%ebp),%eax
     b27:	7c e3                	jl     b0c <main+0x556>
    free(cup_array[i]);
  }
  
  //free cup_boy_stack
  free(cup_boy_stack);
     b29:	8b 45 a0             	mov    -0x60(%ebp),%eax
     b2c:	89 04 24             	mov    %eax,(%esp)
     b2f:	e8 64 06 00 00       	call   1198 <free>
  
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b3b:	eb 15                	jmp    b52 <main+0x59c>
   free(bartenders_stacks[i]); 
     b3d:	8b 45 c0             	mov    -0x40(%ebp),%eax
     b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b43:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b46:	89 04 24             	mov    %eax,(%esp)
     b49:	e8 4a 06 00 00       	call   1198 <free>
  
  //free cup_boy_stack
  free(cup_boy_stack);
  
  //free bartenders_stacks
  for(i = 0; i < B; i++){
     b4e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b55:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     b58:	7c e3                	jl     b3d <main+0x587>
   free(bartenders_stacks[i]); 
  }
  
  //free students_stacks
  for(i = 0; i < S; i++){
     b5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     b61:	eb 15                	jmp    b78 <main+0x5c2>
   free(students_stacks[i]); 
     b63:	8b 45 c8             	mov    -0x38(%ebp),%eax
     b66:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b69:	8b 04 90             	mov    (%eax,%edx,4),%eax
     b6c:	89 04 24             	mov    %eax,(%esp)
     b6f:	e8 24 06 00 00       	call   1198 <free>
  for(i = 0; i < B; i++){
   free(bartenders_stacks[i]); 
  }
  
  //free students_stacks
  for(i = 0; i < S; i++){
     b74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b7b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
     b7e:	7c e3                	jl     b63 <main+0x5ad>
   free(students_stacks[i]); 
  }
  
  semaphore_free(bouncer);
     b80:	a1 1c 20 00 00       	mov    0x201c,%eax
     b85:	89 04 24             	mov    %eax,(%esp)
     b88:	e8 5f 09 00 00       	call   14ec <semaphore_free>
  BB_free(ABB);
     b8d:	a1 24 20 00 00       	mov    0x2024,%eax
     b92:	89 04 24             	mov    %eax,(%esp)
     b95:	e8 91 0b 00 00       	call   172b <BB_free>
  BB_free(DrinkBB);
     b9a:	a1 34 20 00 00       	mov    0x2034,%eax
     b9f:	89 04 24             	mov    %eax,(%esp)
     ba2:	e8 84 0b 00 00       	call   172b <BB_free>
  BB_free(CBB);
     ba7:	a1 50 20 00 00       	mov    0x2050,%eax
     bac:	89 04 24             	mov    %eax,(%esp)
     baf:	e8 77 0b 00 00       	call   172b <BB_free>
  BB_free(DBB);
     bb4:	a1 28 20 00 00       	mov    0x2028,%eax
     bb9:	89 04 24             	mov    %eax,(%esp)
     bbc:	e8 6a 0b 00 00       	call   172b <BB_free>
 
  exit();
     bc1:	e8 66 02 00 00       	call   e2c <exit>
     bc6:	90                   	nop
     bc7:	90                   	nop

00000bc8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     bc8:	55                   	push   %ebp
     bc9:	89 e5                	mov    %esp,%ebp
     bcb:	57                   	push   %edi
     bcc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     bcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
     bd0:	8b 55 10             	mov    0x10(%ebp),%edx
     bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd6:	89 cb                	mov    %ecx,%ebx
     bd8:	89 df                	mov    %ebx,%edi
     bda:	89 d1                	mov    %edx,%ecx
     bdc:	fc                   	cld    
     bdd:	f3 aa                	rep stos %al,%es:(%edi)
     bdf:	89 ca                	mov    %ecx,%edx
     be1:	89 fb                	mov    %edi,%ebx
     be3:	89 5d 08             	mov    %ebx,0x8(%ebp)
     be6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     be9:	5b                   	pop    %ebx
     bea:	5f                   	pop    %edi
     beb:	5d                   	pop    %ebp
     bec:	c3                   	ret    

00000bed <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     bed:	55                   	push   %ebp
     bee:	89 e5                	mov    %esp,%ebp
     bf0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     bf3:	8b 45 08             	mov    0x8(%ebp),%eax
     bf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     bf9:	90                   	nop
     bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
     bfd:	0f b6 10             	movzbl (%eax),%edx
     c00:	8b 45 08             	mov    0x8(%ebp),%eax
     c03:	88 10                	mov    %dl,(%eax)
     c05:	8b 45 08             	mov    0x8(%ebp),%eax
     c08:	0f b6 00             	movzbl (%eax),%eax
     c0b:	84 c0                	test   %al,%al
     c0d:	0f 95 c0             	setne  %al
     c10:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     c14:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     c18:	84 c0                	test   %al,%al
     c1a:	75 de                	jne    bfa <strcpy+0xd>
    ;
  return os;
     c1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     c1f:	c9                   	leave  
     c20:	c3                   	ret    

00000c21 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c21:	55                   	push   %ebp
     c22:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     c24:	eb 08                	jmp    c2e <strcmp+0xd>
    p++, q++;
     c26:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     c2a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     c2e:	8b 45 08             	mov    0x8(%ebp),%eax
     c31:	0f b6 00             	movzbl (%eax),%eax
     c34:	84 c0                	test   %al,%al
     c36:	74 10                	je     c48 <strcmp+0x27>
     c38:	8b 45 08             	mov    0x8(%ebp),%eax
     c3b:	0f b6 10             	movzbl (%eax),%edx
     c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     c41:	0f b6 00             	movzbl (%eax),%eax
     c44:	38 c2                	cmp    %al,%dl
     c46:	74 de                	je     c26 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     c48:	8b 45 08             	mov    0x8(%ebp),%eax
     c4b:	0f b6 00             	movzbl (%eax),%eax
     c4e:	0f b6 d0             	movzbl %al,%edx
     c51:	8b 45 0c             	mov    0xc(%ebp),%eax
     c54:	0f b6 00             	movzbl (%eax),%eax
     c57:	0f b6 c0             	movzbl %al,%eax
     c5a:	89 d1                	mov    %edx,%ecx
     c5c:	29 c1                	sub    %eax,%ecx
     c5e:	89 c8                	mov    %ecx,%eax
}
     c60:	5d                   	pop    %ebp
     c61:	c3                   	ret    

00000c62 <strlen>:

uint
strlen(char *s)
{
     c62:	55                   	push   %ebp
     c63:	89 e5                	mov    %esp,%ebp
     c65:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     c68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     c6f:	eb 04                	jmp    c75 <strlen+0x13>
     c71:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c78:	03 45 08             	add    0x8(%ebp),%eax
     c7b:	0f b6 00             	movzbl (%eax),%eax
     c7e:	84 c0                	test   %al,%al
     c80:	75 ef                	jne    c71 <strlen+0xf>
    ;
  return n;
     c82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     c85:	c9                   	leave  
     c86:	c3                   	ret    

00000c87 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c87:	55                   	push   %ebp
     c88:	89 e5                	mov    %esp,%ebp
     c8a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     c8d:	8b 45 10             	mov    0x10(%ebp),%eax
     c90:	89 44 24 08          	mov    %eax,0x8(%esp)
     c94:	8b 45 0c             	mov    0xc(%ebp),%eax
     c97:	89 44 24 04          	mov    %eax,0x4(%esp)
     c9b:	8b 45 08             	mov    0x8(%ebp),%eax
     c9e:	89 04 24             	mov    %eax,(%esp)
     ca1:	e8 22 ff ff ff       	call   bc8 <stosb>
  return dst;
     ca6:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ca9:	c9                   	leave  
     caa:	c3                   	ret    

00000cab <strchr>:

char*
strchr(const char *s, char c)
{
     cab:	55                   	push   %ebp
     cac:	89 e5                	mov    %esp,%ebp
     cae:	83 ec 04             	sub    $0x4,%esp
     cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
     cb4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     cb7:	eb 14                	jmp    ccd <strchr+0x22>
    if(*s == c)
     cb9:	8b 45 08             	mov    0x8(%ebp),%eax
     cbc:	0f b6 00             	movzbl (%eax),%eax
     cbf:	3a 45 fc             	cmp    -0x4(%ebp),%al
     cc2:	75 05                	jne    cc9 <strchr+0x1e>
      return (char*)s;
     cc4:	8b 45 08             	mov    0x8(%ebp),%eax
     cc7:	eb 13                	jmp    cdc <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     cc9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     ccd:	8b 45 08             	mov    0x8(%ebp),%eax
     cd0:	0f b6 00             	movzbl (%eax),%eax
     cd3:	84 c0                	test   %al,%al
     cd5:	75 e2                	jne    cb9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     cd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
     cdc:	c9                   	leave  
     cdd:	c3                   	ret    

00000cde <gets>:

char*
gets(char *buf, int max)
{
     cde:	55                   	push   %ebp
     cdf:	89 e5                	mov    %esp,%ebp
     ce1:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ce4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ceb:	eb 44                	jmp    d31 <gets+0x53>
    cc = read(0, &c, 1);
     ced:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     cf4:	00 
     cf5:	8d 45 ef             	lea    -0x11(%ebp),%eax
     cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
     cfc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     d03:	e8 3c 01 00 00       	call   e44 <read>
     d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     d0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d0f:	7e 2d                	jle    d3e <gets+0x60>
      break;
    buf[i++] = c;
     d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d14:	03 45 08             	add    0x8(%ebp),%eax
     d17:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     d1b:	88 10                	mov    %dl,(%eax)
     d1d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     d21:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     d25:	3c 0a                	cmp    $0xa,%al
     d27:	74 16                	je     d3f <gets+0x61>
     d29:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     d2d:	3c 0d                	cmp    $0xd,%al
     d2f:	74 0e                	je     d3f <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d34:	83 c0 01             	add    $0x1,%eax
     d37:	3b 45 0c             	cmp    0xc(%ebp),%eax
     d3a:	7c b1                	jl     ced <gets+0xf>
     d3c:	eb 01                	jmp    d3f <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     d3e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d42:	03 45 08             	add    0x8(%ebp),%eax
     d45:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d4b:	c9                   	leave  
     d4c:	c3                   	ret    

00000d4d <stat>:

int
stat(char *n, struct stat *st)
{
     d4d:	55                   	push   %ebp
     d4e:	89 e5                	mov    %esp,%ebp
     d50:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     d5a:	00 
     d5b:	8b 45 08             	mov    0x8(%ebp),%eax
     d5e:	89 04 24             	mov    %eax,(%esp)
     d61:	e8 06 01 00 00       	call   e6c <open>
     d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d6d:	79 07                	jns    d76 <stat+0x29>
    return -1;
     d6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d74:	eb 23                	jmp    d99 <stat+0x4c>
  r = fstat(fd, st);
     d76:	8b 45 0c             	mov    0xc(%ebp),%eax
     d79:	89 44 24 04          	mov    %eax,0x4(%esp)
     d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d80:	89 04 24             	mov    %eax,(%esp)
     d83:	e8 fc 00 00 00       	call   e84 <fstat>
     d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d8e:	89 04 24             	mov    %eax,(%esp)
     d91:	e8 be 00 00 00       	call   e54 <close>
  return r;
     d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     d99:	c9                   	leave  
     d9a:	c3                   	ret    

00000d9b <atoi>:

int
atoi(const char *s)
{
     d9b:	55                   	push   %ebp
     d9c:	89 e5                	mov    %esp,%ebp
     d9e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     da1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     da8:	eb 23                	jmp    dcd <atoi+0x32>
    n = n*10 + *s++ - '0';
     daa:	8b 55 fc             	mov    -0x4(%ebp),%edx
     dad:	89 d0                	mov    %edx,%eax
     daf:	c1 e0 02             	shl    $0x2,%eax
     db2:	01 d0                	add    %edx,%eax
     db4:	01 c0                	add    %eax,%eax
     db6:	89 c2                	mov    %eax,%edx
     db8:	8b 45 08             	mov    0x8(%ebp),%eax
     dbb:	0f b6 00             	movzbl (%eax),%eax
     dbe:	0f be c0             	movsbl %al,%eax
     dc1:	01 d0                	add    %edx,%eax
     dc3:	83 e8 30             	sub    $0x30,%eax
     dc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
     dc9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     dcd:	8b 45 08             	mov    0x8(%ebp),%eax
     dd0:	0f b6 00             	movzbl (%eax),%eax
     dd3:	3c 2f                	cmp    $0x2f,%al
     dd5:	7e 0a                	jle    de1 <atoi+0x46>
     dd7:	8b 45 08             	mov    0x8(%ebp),%eax
     dda:	0f b6 00             	movzbl (%eax),%eax
     ddd:	3c 39                	cmp    $0x39,%al
     ddf:	7e c9                	jle    daa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     de1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     de4:	c9                   	leave  
     de5:	c3                   	ret    

00000de6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     de6:	55                   	push   %ebp
     de7:	89 e5                	mov    %esp,%ebp
     de9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     dec:	8b 45 08             	mov    0x8(%ebp),%eax
     def:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     df2:	8b 45 0c             	mov    0xc(%ebp),%eax
     df5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     df8:	eb 13                	jmp    e0d <memmove+0x27>
    *dst++ = *src++;
     dfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
     dfd:	0f b6 10             	movzbl (%eax),%edx
     e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e03:	88 10                	mov    %dl,(%eax)
     e05:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     e09:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     e0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     e11:	0f 9f c0             	setg   %al
     e14:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     e18:	84 c0                	test   %al,%al
     e1a:	75 de                	jne    dfa <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     e1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e1f:	c9                   	leave  
     e20:	c3                   	ret    
     e21:	90                   	nop
     e22:	90                   	nop
     e23:	90                   	nop

00000e24 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e24:	b8 01 00 00 00       	mov    $0x1,%eax
     e29:	cd 40                	int    $0x40
     e2b:	c3                   	ret    

00000e2c <exit>:
SYSCALL(exit)
     e2c:	b8 02 00 00 00       	mov    $0x2,%eax
     e31:	cd 40                	int    $0x40
     e33:	c3                   	ret    

00000e34 <wait>:
SYSCALL(wait)
     e34:	b8 03 00 00 00       	mov    $0x3,%eax
     e39:	cd 40                	int    $0x40
     e3b:	c3                   	ret    

00000e3c <pipe>:
SYSCALL(pipe)
     e3c:	b8 04 00 00 00       	mov    $0x4,%eax
     e41:	cd 40                	int    $0x40
     e43:	c3                   	ret    

00000e44 <read>:
SYSCALL(read)
     e44:	b8 05 00 00 00       	mov    $0x5,%eax
     e49:	cd 40                	int    $0x40
     e4b:	c3                   	ret    

00000e4c <write>:
SYSCALL(write)
     e4c:	b8 10 00 00 00       	mov    $0x10,%eax
     e51:	cd 40                	int    $0x40
     e53:	c3                   	ret    

00000e54 <close>:
SYSCALL(close)
     e54:	b8 15 00 00 00       	mov    $0x15,%eax
     e59:	cd 40                	int    $0x40
     e5b:	c3                   	ret    

00000e5c <kill>:
SYSCALL(kill)
     e5c:	b8 06 00 00 00       	mov    $0x6,%eax
     e61:	cd 40                	int    $0x40
     e63:	c3                   	ret    

00000e64 <exec>:
SYSCALL(exec)
     e64:	b8 07 00 00 00       	mov    $0x7,%eax
     e69:	cd 40                	int    $0x40
     e6b:	c3                   	ret    

00000e6c <open>:
SYSCALL(open)
     e6c:	b8 0f 00 00 00       	mov    $0xf,%eax
     e71:	cd 40                	int    $0x40
     e73:	c3                   	ret    

00000e74 <mknod>:
SYSCALL(mknod)
     e74:	b8 11 00 00 00       	mov    $0x11,%eax
     e79:	cd 40                	int    $0x40
     e7b:	c3                   	ret    

00000e7c <unlink>:
SYSCALL(unlink)
     e7c:	b8 12 00 00 00       	mov    $0x12,%eax
     e81:	cd 40                	int    $0x40
     e83:	c3                   	ret    

00000e84 <fstat>:
SYSCALL(fstat)
     e84:	b8 08 00 00 00       	mov    $0x8,%eax
     e89:	cd 40                	int    $0x40
     e8b:	c3                   	ret    

00000e8c <link>:
SYSCALL(link)
     e8c:	b8 13 00 00 00       	mov    $0x13,%eax
     e91:	cd 40                	int    $0x40
     e93:	c3                   	ret    

00000e94 <mkdir>:
SYSCALL(mkdir)
     e94:	b8 14 00 00 00       	mov    $0x14,%eax
     e99:	cd 40                	int    $0x40
     e9b:	c3                   	ret    

00000e9c <chdir>:
SYSCALL(chdir)
     e9c:	b8 09 00 00 00       	mov    $0x9,%eax
     ea1:	cd 40                	int    $0x40
     ea3:	c3                   	ret    

00000ea4 <dup>:
SYSCALL(dup)
     ea4:	b8 0a 00 00 00       	mov    $0xa,%eax
     ea9:	cd 40                	int    $0x40
     eab:	c3                   	ret    

00000eac <getpid>:
SYSCALL(getpid)
     eac:	b8 0b 00 00 00       	mov    $0xb,%eax
     eb1:	cd 40                	int    $0x40
     eb3:	c3                   	ret    

00000eb4 <sbrk>:
SYSCALL(sbrk)
     eb4:	b8 0c 00 00 00       	mov    $0xc,%eax
     eb9:	cd 40                	int    $0x40
     ebb:	c3                   	ret    

00000ebc <sleep>:
SYSCALL(sleep)
     ebc:	b8 0d 00 00 00       	mov    $0xd,%eax
     ec1:	cd 40                	int    $0x40
     ec3:	c3                   	ret    

00000ec4 <uptime>:
SYSCALL(uptime)
     ec4:	b8 0e 00 00 00       	mov    $0xe,%eax
     ec9:	cd 40                	int    $0x40
     ecb:	c3                   	ret    

00000ecc <thread_create>:
SYSCALL(thread_create)
     ecc:	b8 16 00 00 00       	mov    $0x16,%eax
     ed1:	cd 40                	int    $0x40
     ed3:	c3                   	ret    

00000ed4 <thread_getId>:
SYSCALL(thread_getId)
     ed4:	b8 17 00 00 00       	mov    $0x17,%eax
     ed9:	cd 40                	int    $0x40
     edb:	c3                   	ret    

00000edc <thread_getProcId>:
SYSCALL(thread_getProcId)
     edc:	b8 18 00 00 00       	mov    $0x18,%eax
     ee1:	cd 40                	int    $0x40
     ee3:	c3                   	ret    

00000ee4 <thread_join>:
SYSCALL(thread_join)
     ee4:	b8 19 00 00 00       	mov    $0x19,%eax
     ee9:	cd 40                	int    $0x40
     eeb:	c3                   	ret    

00000eec <thread_exit>:
SYSCALL(thread_exit)
     eec:	b8 1a 00 00 00       	mov    $0x1a,%eax
     ef1:	cd 40                	int    $0x40
     ef3:	c3                   	ret    

00000ef4 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     ef4:	b8 1b 00 00 00       	mov    $0x1b,%eax
     ef9:	cd 40                	int    $0x40
     efb:	c3                   	ret    

00000efc <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     efc:	b8 1c 00 00 00       	mov    $0x1c,%eax
     f01:	cd 40                	int    $0x40
     f03:	c3                   	ret    

00000f04 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     f04:	b8 1d 00 00 00       	mov    $0x1d,%eax
     f09:	cd 40                	int    $0x40
     f0b:	c3                   	ret    

00000f0c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     f0c:	55                   	push   %ebp
     f0d:	89 e5                	mov    %esp,%ebp
     f0f:	83 ec 28             	sub    $0x28,%esp
     f12:	8b 45 0c             	mov    0xc(%ebp),%eax
     f15:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     f18:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     f1f:	00 
     f20:	8d 45 f4             	lea    -0xc(%ebp),%eax
     f23:	89 44 24 04          	mov    %eax,0x4(%esp)
     f27:	8b 45 08             	mov    0x8(%ebp),%eax
     f2a:	89 04 24             	mov    %eax,(%esp)
     f2d:	e8 1a ff ff ff       	call   e4c <write>
}
     f32:	c9                   	leave  
     f33:	c3                   	ret    

00000f34 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f34:	55                   	push   %ebp
     f35:	89 e5                	mov    %esp,%ebp
     f37:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     f3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     f41:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     f45:	74 17                	je     f5e <printint+0x2a>
     f47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f4b:	79 11                	jns    f5e <printint+0x2a>
    neg = 1;
     f4d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     f54:	8b 45 0c             	mov    0xc(%ebp),%eax
     f57:	f7 d8                	neg    %eax
     f59:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f5c:	eb 06                	jmp    f64 <printint+0x30>
  } else {
    x = xx;
     f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
     f61:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     f64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     f6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f71:	ba 00 00 00 00       	mov    $0x0,%edx
     f76:	f7 f1                	div    %ecx
     f78:	89 d0                	mov    %edx,%eax
     f7a:	0f b6 90 fc 1f 00 00 	movzbl 0x1ffc(%eax),%edx
     f81:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f84:	03 45 f4             	add    -0xc(%ebp),%eax
     f87:	88 10                	mov    %dl,(%eax)
     f89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     f8d:	8b 55 10             	mov    0x10(%ebp),%edx
     f90:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f96:	ba 00 00 00 00       	mov    $0x0,%edx
     f9b:	f7 75 d4             	divl   -0x2c(%ebp)
     f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fa5:	75 c4                	jne    f6b <printint+0x37>
  if(neg)
     fa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fab:	74 2a                	je     fd7 <printint+0xa3>
    buf[i++] = '-';
     fad:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fb0:	03 45 f4             	add    -0xc(%ebp),%eax
     fb3:	c6 00 2d             	movb   $0x2d,(%eax)
     fb6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     fba:	eb 1b                	jmp    fd7 <printint+0xa3>
    putc(fd, buf[i]);
     fbc:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fbf:	03 45 f4             	add    -0xc(%ebp),%eax
     fc2:	0f b6 00             	movzbl (%eax),%eax
     fc5:	0f be c0             	movsbl %al,%eax
     fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
     fcc:	8b 45 08             	mov    0x8(%ebp),%eax
     fcf:	89 04 24             	mov    %eax,(%esp)
     fd2:	e8 35 ff ff ff       	call   f0c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     fd7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     fdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     fdf:	79 db                	jns    fbc <printint+0x88>
    putc(fd, buf[i]);
}
     fe1:	c9                   	leave  
     fe2:	c3                   	ret    

00000fe3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     fe3:	55                   	push   %ebp
     fe4:	89 e5                	mov    %esp,%ebp
     fe6:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     fe9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     ff0:	8d 45 0c             	lea    0xc(%ebp),%eax
     ff3:	83 c0 04             	add    $0x4,%eax
     ff6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     ff9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1000:	e9 7d 01 00 00       	jmp    1182 <printf+0x19f>
    c = fmt[i] & 0xff;
    1005:	8b 55 0c             	mov    0xc(%ebp),%edx
    1008:	8b 45 f0             	mov    -0x10(%ebp),%eax
    100b:	01 d0                	add    %edx,%eax
    100d:	0f b6 00             	movzbl (%eax),%eax
    1010:	0f be c0             	movsbl %al,%eax
    1013:	25 ff 00 00 00       	and    $0xff,%eax
    1018:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    101b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    101f:	75 2c                	jne    104d <printf+0x6a>
      if(c == '%'){
    1021:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1025:	75 0c                	jne    1033 <printf+0x50>
        state = '%';
    1027:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    102e:	e9 4b 01 00 00       	jmp    117e <printf+0x19b>
      } else {
        putc(fd, c);
    1033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1036:	0f be c0             	movsbl %al,%eax
    1039:	89 44 24 04          	mov    %eax,0x4(%esp)
    103d:	8b 45 08             	mov    0x8(%ebp),%eax
    1040:	89 04 24             	mov    %eax,(%esp)
    1043:	e8 c4 fe ff ff       	call   f0c <putc>
    1048:	e9 31 01 00 00       	jmp    117e <printf+0x19b>
      }
    } else if(state == '%'){
    104d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1051:	0f 85 27 01 00 00    	jne    117e <printf+0x19b>
      if(c == 'd'){
    1057:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    105b:	75 2d                	jne    108a <printf+0xa7>
        printint(fd, *ap, 10, 1);
    105d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1060:	8b 00                	mov    (%eax),%eax
    1062:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1069:	00 
    106a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1071:	00 
    1072:	89 44 24 04          	mov    %eax,0x4(%esp)
    1076:	8b 45 08             	mov    0x8(%ebp),%eax
    1079:	89 04 24             	mov    %eax,(%esp)
    107c:	e8 b3 fe ff ff       	call   f34 <printint>
        ap++;
    1081:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1085:	e9 ed 00 00 00       	jmp    1177 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    108a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    108e:	74 06                	je     1096 <printf+0xb3>
    1090:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1094:	75 2d                	jne    10c3 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1096:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1099:	8b 00                	mov    (%eax),%eax
    109b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    10a2:	00 
    10a3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    10aa:	00 
    10ab:	89 44 24 04          	mov    %eax,0x4(%esp)
    10af:	8b 45 08             	mov    0x8(%ebp),%eax
    10b2:	89 04 24             	mov    %eax,(%esp)
    10b5:	e8 7a fe ff ff       	call   f34 <printint>
        ap++;
    10ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10be:	e9 b4 00 00 00       	jmp    1177 <printf+0x194>
      } else if(c == 's'){
    10c3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    10c7:	75 46                	jne    110f <printf+0x12c>
        s = (char*)*ap;
    10c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10cc:	8b 00                	mov    (%eax),%eax
    10ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    10d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    10d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10d9:	75 27                	jne    1102 <printf+0x11f>
          s = "(null)";
    10db:	c7 45 f4 c0 19 00 00 	movl   $0x19c0,-0xc(%ebp)
        while(*s != 0){
    10e2:	eb 1e                	jmp    1102 <printf+0x11f>
          putc(fd, *s);
    10e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10e7:	0f b6 00             	movzbl (%eax),%eax
    10ea:	0f be c0             	movsbl %al,%eax
    10ed:	89 44 24 04          	mov    %eax,0x4(%esp)
    10f1:	8b 45 08             	mov    0x8(%ebp),%eax
    10f4:	89 04 24             	mov    %eax,(%esp)
    10f7:	e8 10 fe ff ff       	call   f0c <putc>
          s++;
    10fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1100:	eb 01                	jmp    1103 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1102:	90                   	nop
    1103:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1106:	0f b6 00             	movzbl (%eax),%eax
    1109:	84 c0                	test   %al,%al
    110b:	75 d7                	jne    10e4 <printf+0x101>
    110d:	eb 68                	jmp    1177 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    110f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1113:	75 1d                	jne    1132 <printf+0x14f>
        putc(fd, *ap);
    1115:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1118:	8b 00                	mov    (%eax),%eax
    111a:	0f be c0             	movsbl %al,%eax
    111d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1121:	8b 45 08             	mov    0x8(%ebp),%eax
    1124:	89 04 24             	mov    %eax,(%esp)
    1127:	e8 e0 fd ff ff       	call   f0c <putc>
        ap++;
    112c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1130:	eb 45                	jmp    1177 <printf+0x194>
      } else if(c == '%'){
    1132:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1136:	75 17                	jne    114f <printf+0x16c>
        putc(fd, c);
    1138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    113b:	0f be c0             	movsbl %al,%eax
    113e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1142:	8b 45 08             	mov    0x8(%ebp),%eax
    1145:	89 04 24             	mov    %eax,(%esp)
    1148:	e8 bf fd ff ff       	call   f0c <putc>
    114d:	eb 28                	jmp    1177 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    114f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1156:	00 
    1157:	8b 45 08             	mov    0x8(%ebp),%eax
    115a:	89 04 24             	mov    %eax,(%esp)
    115d:	e8 aa fd ff ff       	call   f0c <putc>
        putc(fd, c);
    1162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1165:	0f be c0             	movsbl %al,%eax
    1168:	89 44 24 04          	mov    %eax,0x4(%esp)
    116c:	8b 45 08             	mov    0x8(%ebp),%eax
    116f:	89 04 24             	mov    %eax,(%esp)
    1172:	e8 95 fd ff ff       	call   f0c <putc>
      }
      state = 0;
    1177:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    117e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1182:	8b 55 0c             	mov    0xc(%ebp),%edx
    1185:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1188:	01 d0                	add    %edx,%eax
    118a:	0f b6 00             	movzbl (%eax),%eax
    118d:	84 c0                	test   %al,%al
    118f:	0f 85 70 fe ff ff    	jne    1005 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1195:	c9                   	leave  
    1196:	c3                   	ret    
    1197:	90                   	nop

00001198 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1198:	55                   	push   %ebp
    1199:	89 e5                	mov    %esp,%ebp
    119b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    119e:	8b 45 08             	mov    0x8(%ebp),%eax
    11a1:	83 e8 08             	sub    $0x8,%eax
    11a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11a7:	a1 18 20 00 00       	mov    0x2018,%eax
    11ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11af:	eb 24                	jmp    11d5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11b4:	8b 00                	mov    (%eax),%eax
    11b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11b9:	77 12                	ja     11cd <free+0x35>
    11bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11c1:	77 24                	ja     11e7 <free+0x4f>
    11c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11c6:	8b 00                	mov    (%eax),%eax
    11c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11cb:	77 1a                	ja     11e7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11d0:	8b 00                	mov    (%eax),%eax
    11d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11db:	76 d4                	jbe    11b1 <free+0x19>
    11dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11e0:	8b 00                	mov    (%eax),%eax
    11e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11e5:	76 ca                	jbe    11b1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    11e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ea:	8b 40 04             	mov    0x4(%eax),%eax
    11ed:	c1 e0 03             	shl    $0x3,%eax
    11f0:	89 c2                	mov    %eax,%edx
    11f2:	03 55 f8             	add    -0x8(%ebp),%edx
    11f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11f8:	8b 00                	mov    (%eax),%eax
    11fa:	39 c2                	cmp    %eax,%edx
    11fc:	75 24                	jne    1222 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    11fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1201:	8b 50 04             	mov    0x4(%eax),%edx
    1204:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1207:	8b 00                	mov    (%eax),%eax
    1209:	8b 40 04             	mov    0x4(%eax),%eax
    120c:	01 c2                	add    %eax,%edx
    120e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1211:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1214:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1217:	8b 00                	mov    (%eax),%eax
    1219:	8b 10                	mov    (%eax),%edx
    121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    121e:	89 10                	mov    %edx,(%eax)
    1220:	eb 0a                	jmp    122c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    1222:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1225:	8b 10                	mov    (%eax),%edx
    1227:	8b 45 f8             	mov    -0x8(%ebp),%eax
    122a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    122c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    122f:	8b 40 04             	mov    0x4(%eax),%eax
    1232:	c1 e0 03             	shl    $0x3,%eax
    1235:	03 45 fc             	add    -0x4(%ebp),%eax
    1238:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    123b:	75 20                	jne    125d <free+0xc5>
    p->s.size += bp->s.size;
    123d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1240:	8b 50 04             	mov    0x4(%eax),%edx
    1243:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1246:	8b 40 04             	mov    0x4(%eax),%eax
    1249:	01 c2                	add    %eax,%edx
    124b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    124e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1251:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1254:	8b 10                	mov    (%eax),%edx
    1256:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1259:	89 10                	mov    %edx,(%eax)
    125b:	eb 08                	jmp    1265 <free+0xcd>
  } else
    p->s.ptr = bp;
    125d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1260:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1263:	89 10                	mov    %edx,(%eax)
  freep = p;
    1265:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1268:	a3 18 20 00 00       	mov    %eax,0x2018
}
    126d:	c9                   	leave  
    126e:	c3                   	ret    

0000126f <morecore>:

static Header*
morecore(uint nu)
{
    126f:	55                   	push   %ebp
    1270:	89 e5                	mov    %esp,%ebp
    1272:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1275:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    127c:	77 07                	ja     1285 <morecore+0x16>
    nu = 4096;
    127e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1285:	8b 45 08             	mov    0x8(%ebp),%eax
    1288:	c1 e0 03             	shl    $0x3,%eax
    128b:	89 04 24             	mov    %eax,(%esp)
    128e:	e8 21 fc ff ff       	call   eb4 <sbrk>
    1293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1296:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    129a:	75 07                	jne    12a3 <morecore+0x34>
    return 0;
    129c:	b8 00 00 00 00       	mov    $0x0,%eax
    12a1:	eb 22                	jmp    12c5 <morecore+0x56>
  hp = (Header*)p;
    12a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    12a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12ac:	8b 55 08             	mov    0x8(%ebp),%edx
    12af:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    12b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12b5:	83 c0 08             	add    $0x8,%eax
    12b8:	89 04 24             	mov    %eax,(%esp)
    12bb:	e8 d8 fe ff ff       	call   1198 <free>
  return freep;
    12c0:	a1 18 20 00 00       	mov    0x2018,%eax
}
    12c5:	c9                   	leave  
    12c6:	c3                   	ret    

000012c7 <malloc>:

void*
malloc(uint nbytes)
{
    12c7:	55                   	push   %ebp
    12c8:	89 e5                	mov    %esp,%ebp
    12ca:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12cd:	8b 45 08             	mov    0x8(%ebp),%eax
    12d0:	83 c0 07             	add    $0x7,%eax
    12d3:	c1 e8 03             	shr    $0x3,%eax
    12d6:	83 c0 01             	add    $0x1,%eax
    12d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    12dc:	a1 18 20 00 00       	mov    0x2018,%eax
    12e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12e8:	75 23                	jne    130d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    12ea:	c7 45 f0 10 20 00 00 	movl   $0x2010,-0x10(%ebp)
    12f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12f4:	a3 18 20 00 00       	mov    %eax,0x2018
    12f9:	a1 18 20 00 00       	mov    0x2018,%eax
    12fe:	a3 10 20 00 00       	mov    %eax,0x2010
    base.s.size = 0;
    1303:	c7 05 14 20 00 00 00 	movl   $0x0,0x2014
    130a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    130d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1310:	8b 00                	mov    (%eax),%eax
    1312:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1315:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1318:	8b 40 04             	mov    0x4(%eax),%eax
    131b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    131e:	72 4d                	jb     136d <malloc+0xa6>
      if(p->s.size == nunits)
    1320:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1323:	8b 40 04             	mov    0x4(%eax),%eax
    1326:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1329:	75 0c                	jne    1337 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    132b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    132e:	8b 10                	mov    (%eax),%edx
    1330:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1333:	89 10                	mov    %edx,(%eax)
    1335:	eb 26                	jmp    135d <malloc+0x96>
      else {
        p->s.size -= nunits;
    1337:	8b 45 f4             	mov    -0xc(%ebp),%eax
    133a:	8b 40 04             	mov    0x4(%eax),%eax
    133d:	89 c2                	mov    %eax,%edx
    133f:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1342:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1345:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1348:	8b 45 f4             	mov    -0xc(%ebp),%eax
    134b:	8b 40 04             	mov    0x4(%eax),%eax
    134e:	c1 e0 03             	shl    $0x3,%eax
    1351:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1354:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1357:	8b 55 ec             	mov    -0x14(%ebp),%edx
    135a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    135d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1360:	a3 18 20 00 00       	mov    %eax,0x2018
      return (void*)(p + 1);
    1365:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1368:	83 c0 08             	add    $0x8,%eax
    136b:	eb 38                	jmp    13a5 <malloc+0xde>
    }
    if(p == freep)
    136d:	a1 18 20 00 00       	mov    0x2018,%eax
    1372:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1375:	75 1b                	jne    1392 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1377:	8b 45 ec             	mov    -0x14(%ebp),%eax
    137a:	89 04 24             	mov    %eax,(%esp)
    137d:	e8 ed fe ff ff       	call   126f <morecore>
    1382:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1389:	75 07                	jne    1392 <malloc+0xcb>
        return 0;
    138b:	b8 00 00 00 00       	mov    $0x0,%eax
    1390:	eb 13                	jmp    13a5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1392:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1395:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1398:	8b 45 f4             	mov    -0xc(%ebp),%eax
    139b:	8b 00                	mov    (%eax),%eax
    139d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    13a0:	e9 70 ff ff ff       	jmp    1315 <malloc+0x4e>
}
    13a5:	c9                   	leave  
    13a6:	c3                   	ret    
    13a7:	90                   	nop

000013a8 <semaphore_create>:
#include "semaphore.h"
#include "types.h"
#include "user.h"


struct semaphore* semaphore_create(int initial_semaphore_value){
    13a8:	55                   	push   %ebp
    13a9:	89 e5                	mov    %esp,%ebp
    13ab:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* sem=malloc(sizeof(struct semaphore)); 
    13ae:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    13b5:	e8 0d ff ff ff       	call   12c7 <malloc>
    13ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // acquire semaphors
  sem->s1 = binary_semaphore_create(1);
    13bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13c4:	e8 2b fb ff ff       	call   ef4 <binary_semaphore_create>
    13c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13cc:	89 02                	mov    %eax,(%edx)
  
  // s2 should be initialized with the min{1,initial_semaphore_value}
  if(initial_semaphore_value >= 1){
    13ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    13d2:	7e 14                	jle    13e8 <semaphore_create+0x40>
    sem->s2 = binary_semaphore_create(1);
    13d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13db:	e8 14 fb ff ff       	call   ef4 <binary_semaphore_create>
    13e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13e3:	89 42 04             	mov    %eax,0x4(%edx)
    13e6:	eb 11                	jmp    13f9 <semaphore_create+0x51>
  }else{
    sem->s2 = binary_semaphore_create(initial_semaphore_value);
    13e8:	8b 45 08             	mov    0x8(%ebp),%eax
    13eb:	89 04 24             	mov    %eax,(%esp)
    13ee:	e8 01 fb ff ff       	call   ef4 <binary_semaphore_create>
    13f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13f6:	89 42 04             	mov    %eax,0x4(%edx)
  }
  
  if(sem->s1 == -1 || sem->s2 == -1){
    13f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13fc:	8b 00                	mov    (%eax),%eax
    13fe:	83 f8 ff             	cmp    $0xffffffff,%eax
    1401:	74 0b                	je     140e <semaphore_create+0x66>
    1403:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1406:	8b 40 04             	mov    0x4(%eax),%eax
    1409:	83 f8 ff             	cmp    $0xffffffff,%eax
    140c:	75 26                	jne    1434 <semaphore_create+0x8c>
     printf(1,"we had a probalem initialize in semaphore_create\n");
    140e:	c7 44 24 04 c8 19 00 	movl   $0x19c8,0x4(%esp)
    1415:	00 
    1416:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    141d:	e8 c1 fb ff ff       	call   fe3 <printf>
     free(sem);
    1422:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1425:	89 04 24             	mov    %eax,(%esp)
    1428:	e8 6b fd ff ff       	call   1198 <free>
     return 0;
    142d:	b8 00 00 00 00       	mov    $0x0,%eax
    1432:	eb 15                	jmp    1449 <semaphore_create+0xa1>
  }
  //initialize value
  sem->value = initial_semaphore_value;//dynamic
    1434:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1437:	8b 55 08             	mov    0x8(%ebp),%edx
    143a:	89 50 08             	mov    %edx,0x8(%eax)
  sem->initial_value = initial_semaphore_value;//static
    143d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1440:	8b 55 08             	mov    0x8(%ebp),%edx
    1443:	89 50 0c             	mov    %edx,0xc(%eax)
  
  return sem;
    1446:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1449:	c9                   	leave  
    144a:	c3                   	ret    

0000144b <semaphore_down>:
void semaphore_down(struct semaphore* sem ){
    144b:	55                   	push   %ebp
    144c:	89 e5                	mov    %esp,%ebp
    144e:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s2);
    1451:	8b 45 08             	mov    0x8(%ebp),%eax
    1454:	8b 40 04             	mov    0x4(%eax),%eax
    1457:	89 04 24             	mov    %eax,(%esp)
    145a:	e8 9d fa ff ff       	call   efc <binary_semaphore_down>
  binary_semaphore_down(sem->s1);
    145f:	8b 45 08             	mov    0x8(%ebp),%eax
    1462:	8b 00                	mov    (%eax),%eax
    1464:	89 04 24             	mov    %eax,(%esp)
    1467:	e8 90 fa ff ff       	call   efc <binary_semaphore_down>
  sem->value--;	
    146c:	8b 45 08             	mov    0x8(%ebp),%eax
    146f:	8b 40 08             	mov    0x8(%eax),%eax
    1472:	8d 50 ff             	lea    -0x1(%eax),%edx
    1475:	8b 45 08             	mov    0x8(%ebp),%eax
    1478:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value > 0){
    147b:	8b 45 08             	mov    0x8(%ebp),%eax
    147e:	8b 40 08             	mov    0x8(%eax),%eax
    1481:	85 c0                	test   %eax,%eax
    1483:	7e 0e                	jle    1493 <semaphore_down+0x48>
   binary_semaphore_up(sem->s2);
    1485:	8b 45 08             	mov    0x8(%ebp),%eax
    1488:	8b 40 04             	mov    0x4(%eax),%eax
    148b:	89 04 24             	mov    %eax,(%esp)
    148e:	e8 71 fa ff ff       	call   f04 <binary_semaphore_up>
  }
  binary_semaphore_up(sem->s1); 
    1493:	8b 45 08             	mov    0x8(%ebp),%eax
    1496:	8b 00                	mov    (%eax),%eax
    1498:	89 04 24             	mov    %eax,(%esp)
    149b:	e8 64 fa ff ff       	call   f04 <binary_semaphore_up>
}
    14a0:	c9                   	leave  
    14a1:	c3                   	ret    

000014a2 <semaphore_up>:
void semaphore_up(struct semaphore* sem ){
    14a2:	55                   	push   %ebp
    14a3:	89 e5                	mov    %esp,%ebp
    14a5:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
    14a8:	8b 45 08             	mov    0x8(%ebp),%eax
    14ab:	8b 00                	mov    (%eax),%eax
    14ad:	89 04 24             	mov    %eax,(%esp)
    14b0:	e8 47 fa ff ff       	call   efc <binary_semaphore_down>
  sem->value++;	
    14b5:	8b 45 08             	mov    0x8(%ebp),%eax
    14b8:	8b 40 08             	mov    0x8(%eax),%eax
    14bb:	8d 50 01             	lea    0x1(%eax),%edx
    14be:	8b 45 08             	mov    0x8(%ebp),%eax
    14c1:	89 50 08             	mov    %edx,0x8(%eax)
  if(sem->value ==1){
    14c4:	8b 45 08             	mov    0x8(%ebp),%eax
    14c7:	8b 40 08             	mov    0x8(%eax),%eax
    14ca:	83 f8 01             	cmp    $0x1,%eax
    14cd:	75 0e                	jne    14dd <semaphore_up+0x3b>
   binary_semaphore_up(sem->s2); 
    14cf:	8b 45 08             	mov    0x8(%ebp),%eax
    14d2:	8b 40 04             	mov    0x4(%eax),%eax
    14d5:	89 04 24             	mov    %eax,(%esp)
    14d8:	e8 27 fa ff ff       	call   f04 <binary_semaphore_up>
   }
  binary_semaphore_up(sem->s1);
    14dd:	8b 45 08             	mov    0x8(%ebp),%eax
    14e0:	8b 00                	mov    (%eax),%eax
    14e2:	89 04 24             	mov    %eax,(%esp)
    14e5:	e8 1a fa ff ff       	call   f04 <binary_semaphore_up>
}
    14ea:	c9                   	leave  
    14eb:	c3                   	ret    

000014ec <semaphore_free>:

void semaphore_free(struct semaphore* sem){
    14ec:	55                   	push   %ebp
    14ed:	89 e5                	mov    %esp,%ebp
    14ef:	83 ec 18             	sub    $0x18,%esp
  free(sem);
    14f2:	8b 45 08             	mov    0x8(%ebp),%eax
    14f5:	89 04 24             	mov    %eax,(%esp)
    14f8:	e8 9b fc ff ff       	call   1198 <free>
}
    14fd:	c9                   	leave  
    14fe:	c3                   	ret    
    14ff:	90                   	nop

00001500 <BB_create>:
#include "types.h"
#include "user.h"


struct BB* 
BB_create(int max_capacity){
    1500:	55                   	push   %ebp
    1501:	89 e5                	mov    %esp,%ebp
    1503:	83 ec 38             	sub    $0x38,%esp
  //initialize
  struct BB* buf = malloc(sizeof(struct BB));
    1506:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
    150d:	e8 b5 fd ff ff       	call   12c7 <malloc>
    1512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
    1515:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    151c:	00 
    151d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1524:	00 
    1525:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1528:	89 04 24             	mov    %eax,(%esp)
    152b:	e8 57 f7 ff ff       	call   c87 <memset>
 
  buf->buffer_size = max_capacity;
    1530:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1533:	8b 55 08             	mov    0x8(%ebp),%edx
    1536:	89 10                	mov    %edx,(%eax)
  buf->mutex = binary_semaphore_create(1);  
    1538:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    153f:	e8 b0 f9 ff ff       	call   ef4 <binary_semaphore_create>
    1544:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1547:	89 42 04             	mov    %eax,0x4(%edx)
  buf->empty = semaphore_create(max_capacity);
    154a:	8b 45 08             	mov    0x8(%ebp),%eax
    154d:	89 04 24             	mov    %eax,(%esp)
    1550:	e8 53 fe ff ff       	call   13a8 <semaphore_create>
    1555:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1558:	89 42 08             	mov    %eax,0x8(%edx)
  buf->full = semaphore_create(0);
    155b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1562:	e8 41 fe ff ff       	call   13a8 <semaphore_create>
    1567:	8b 55 f4             	mov    -0xc(%ebp),%edx
    156a:	89 42 0c             	mov    %eax,0xc(%edx)
  buf->pointer_to_elements = malloc(sizeof(void*)*max_capacity);
    156d:	8b 45 08             	mov    0x8(%ebp),%eax
    1570:	c1 e0 02             	shl    $0x2,%eax
    1573:	89 04 24             	mov    %eax,(%esp)
    1576:	e8 4c fd ff ff       	call   12c7 <malloc>
    157b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    157e:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->pointer_to_elements,0,sizeof(void*)*max_capacity);
    1581:	8b 45 08             	mov    0x8(%ebp),%eax
    1584:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    158b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158e:	8b 40 1c             	mov    0x1c(%eax),%eax
    1591:	89 54 24 08          	mov    %edx,0x8(%esp)
    1595:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    159c:	00 
    159d:	89 04 24             	mov    %eax,(%esp)
    15a0:	e8 e2 f6 ff ff       	call   c87 <memset>
  buf->count = 0;//TODO remove or not
    15a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a8:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  //check the semaphorses
  if(buf->mutex == -1 || buf->empty == 0 || buf->full == 0){
    15af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15b2:	8b 40 04             	mov    0x4(%eax),%eax
    15b5:	83 f8 ff             	cmp    $0xffffffff,%eax
    15b8:	74 14                	je     15ce <BB_create+0xce>
    15ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15bd:	8b 40 08             	mov    0x8(%eax),%eax
    15c0:	85 c0                	test   %eax,%eax
    15c2:	74 0a                	je     15ce <BB_create+0xce>
    15c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c7:	8b 40 0c             	mov    0xc(%eax),%eax
    15ca:	85 c0                	test   %eax,%eax
    15cc:	75 44                	jne    1612 <BB_create+0x112>
   printf(1,"we had a problam getting semaphores at BB create mutex %d empty %d full %d\n",buf->mutex,buf->empty,buf->full);
    15ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15d1:	8b 48 0c             	mov    0xc(%eax),%ecx
    15d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15d7:	8b 50 08             	mov    0x8(%eax),%edx
    15da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15dd:	8b 40 04             	mov    0x4(%eax),%eax
    15e0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    15e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
    15e8:	89 44 24 08          	mov    %eax,0x8(%esp)
    15ec:	c7 44 24 04 fc 19 00 	movl   $0x19fc,0x4(%esp)
    15f3:	00 
    15f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15fb:	e8 e3 f9 ff ff       	call   fe3 <printf>
   BB_free(buf);
    1600:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1603:	89 04 24             	mov    %eax,(%esp)
    1606:	e8 20 01 00 00       	call   172b <BB_free>
   //free(buf->pointer_to_elements);//TODO remove
   //free(buf);
   buf =0;  
    160b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  }
  return buf;
    1612:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1615:	c9                   	leave  
    1616:	c3                   	ret    

00001617 <BB_put>:

void BB_put(struct BB* bb, void* element)
{ //TODO mix
    1617:	55                   	push   %ebp
    1618:	89 e5                	mov    %esp,%ebp
    161a:	83 ec 18             	sub    $0x18,%esp
  bb->pointer_to_elements[bb->count] = element;
  bb->count++;
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->full);
  */
  semaphore_down(bb->empty);
    161d:	8b 45 08             	mov    0x8(%ebp),%eax
    1620:	8b 40 08             	mov    0x8(%eax),%eax
    1623:	89 04 24             	mov    %eax,(%esp)
    1626:	e8 20 fe ff ff       	call   144b <semaphore_down>
  binary_semaphore_down(bb->mutex);
    162b:	8b 45 08             	mov    0x8(%ebp),%eax
    162e:	8b 40 04             	mov    0x4(%eax),%eax
    1631:	89 04 24             	mov    %eax,(%esp)
    1634:	e8 c3 f8 ff ff       	call   efc <binary_semaphore_down>
   //insert item
  bb->pointer_to_elements[bb->end] = element;
    1639:	8b 45 08             	mov    0x8(%ebp),%eax
    163c:	8b 50 1c             	mov    0x1c(%eax),%edx
    163f:	8b 45 08             	mov    0x8(%ebp),%eax
    1642:	8b 40 18             	mov    0x18(%eax),%eax
    1645:	c1 e0 02             	shl    $0x2,%eax
    1648:	01 c2                	add    %eax,%edx
    164a:	8b 45 0c             	mov    0xc(%ebp),%eax
    164d:	89 02                	mov    %eax,(%edx)
  ++bb->end;
    164f:	8b 45 08             	mov    0x8(%ebp),%eax
    1652:	8b 40 18             	mov    0x18(%eax),%eax
    1655:	8d 50 01             	lea    0x1(%eax),%edx
    1658:	8b 45 08             	mov    0x8(%ebp),%eax
    165b:	89 50 18             	mov    %edx,0x18(%eax)
  bb->end = bb->end%bb->buffer_size;
    165e:	8b 45 08             	mov    0x8(%ebp),%eax
    1661:	8b 40 18             	mov    0x18(%eax),%eax
    1664:	8b 55 08             	mov    0x8(%ebp),%edx
    1667:	8b 0a                	mov    (%edx),%ecx
    1669:	89 c2                	mov    %eax,%edx
    166b:	c1 fa 1f             	sar    $0x1f,%edx
    166e:	f7 f9                	idiv   %ecx
    1670:	8b 45 08             	mov    0x8(%ebp),%eax
    1673:	89 50 18             	mov    %edx,0x18(%eax)
  binary_semaphore_up(bb->mutex);
    1676:	8b 45 08             	mov    0x8(%ebp),%eax
    1679:	8b 40 04             	mov    0x4(%eax),%eax
    167c:	89 04 24             	mov    %eax,(%esp)
    167f:	e8 80 f8 ff ff       	call   f04 <binary_semaphore_up>
  semaphore_up(bb->full);
    1684:	8b 45 08             	mov    0x8(%ebp),%eax
    1687:	8b 40 0c             	mov    0xc(%eax),%eax
    168a:	89 04 24             	mov    %eax,(%esp)
    168d:	e8 10 fe ff ff       	call   14a2 <semaphore_up>
    
}
    1692:	c9                   	leave  
    1693:	c3                   	ret    

00001694 <BB_pop>:

void* BB_pop(struct BB* bb)
{//TODO clean and mix
    1694:	55                   	push   %ebp
    1695:	89 e5                	mov    %esp,%ebp
    1697:	83 ec 28             	sub    $0x28,%esp
  
  void* element_to_pop;
  semaphore_down(bb->full);
    169a:	8b 45 08             	mov    0x8(%ebp),%eax
    169d:	8b 40 0c             	mov    0xc(%eax),%eax
    16a0:	89 04 24             	mov    %eax,(%esp)
    16a3:	e8 a3 fd ff ff       	call   144b <semaphore_down>
  binary_semaphore_down(bb->mutex);
    16a8:	8b 45 08             	mov    0x8(%ebp),%eax
    16ab:	8b 40 04             	mov    0x4(%eax),%eax
    16ae:	89 04 24             	mov    %eax,(%esp)
    16b1:	e8 46 f8 ff ff       	call   efc <binary_semaphore_down>
  element_to_pop = bb-> pointer_to_elements[bb->start];
    16b6:	8b 45 08             	mov    0x8(%ebp),%eax
    16b9:	8b 50 1c             	mov    0x1c(%eax),%edx
    16bc:	8b 45 08             	mov    0x8(%ebp),%eax
    16bf:	8b 40 14             	mov    0x14(%eax),%eax
    16c2:	c1 e0 02             	shl    $0x2,%eax
    16c5:	01 d0                	add    %edx,%eax
    16c7:	8b 00                	mov    (%eax),%eax
    16c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->pointer_to_elements[bb->start] =0;
    16cc:	8b 45 08             	mov    0x8(%ebp),%eax
    16cf:	8b 50 1c             	mov    0x1c(%eax),%edx
    16d2:	8b 45 08             	mov    0x8(%ebp),%eax
    16d5:	8b 40 14             	mov    0x14(%eax),%eax
    16d8:	c1 e0 02             	shl    $0x2,%eax
    16db:	01 d0                	add    %edx,%eax
    16dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
    16e3:	8b 45 08             	mov    0x8(%ebp),%eax
    16e6:	8b 40 14             	mov    0x14(%eax),%eax
    16e9:	8d 50 01             	lea    0x1(%eax),%edx
    16ec:	8b 45 08             	mov    0x8(%ebp),%eax
    16ef:	89 50 14             	mov    %edx,0x14(%eax)
  bb->start = bb->start%bb->buffer_size;
    16f2:	8b 45 08             	mov    0x8(%ebp),%eax
    16f5:	8b 40 14             	mov    0x14(%eax),%eax
    16f8:	8b 55 08             	mov    0x8(%ebp),%edx
    16fb:	8b 0a                	mov    (%edx),%ecx
    16fd:	89 c2                	mov    %eax,%edx
    16ff:	c1 fa 1f             	sar    $0x1f,%edx
    1702:	f7 f9                	idiv   %ecx
    1704:	8b 45 08             	mov    0x8(%ebp),%eax
    1707:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
    170a:	8b 45 08             	mov    0x8(%ebp),%eax
    170d:	8b 40 04             	mov    0x4(%eax),%eax
    1710:	89 04 24             	mov    %eax,(%esp)
    1713:	e8 ec f7 ff ff       	call   f04 <binary_semaphore_up>
  semaphore_up(bb->empty);
    1718:	8b 45 08             	mov    0x8(%ebp),%eax
    171b:	8b 40 08             	mov    0x8(%eax),%eax
    171e:	89 04 24             	mov    %eax,(%esp)
    1721:	e8 7c fd ff ff       	call   14a2 <semaphore_up>
  return element_to_pop;
    1726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->empty);
  
  return element_to_pop;*/
}
    1729:	c9                   	leave  
    172a:	c3                   	ret    

0000172b <BB_free>:

void BB_free(struct BB* bb){
    172b:	55                   	push   %ebp
    172c:	89 e5                	mov    %esp,%ebp
    172e:	83 ec 18             	sub    $0x18,%esp
  free(bb->pointer_to_elements);
    1731:	8b 45 08             	mov    0x8(%ebp),%eax
    1734:	8b 40 1c             	mov    0x1c(%eax),%eax
    1737:	89 04 24             	mov    %eax,(%esp)
    173a:	e8 59 fa ff ff       	call   1198 <free>
  free(bb);
    173f:	8b 45 08             	mov    0x8(%ebp),%eax
    1742:	89 04 24             	mov    %eax,(%esp)
    1745:	e8 4e fa ff ff       	call   1198 <free>
}
    174a:	c9                   	leave  
    174b:	c3                   	ret    

0000174c <BB_size>:

int BB_size(struct BB* bb){
    174c:	55                   	push   %ebp
    174d:	89 e5                	mov    %esp,%ebp
    174f:	83 ec 28             	sub    $0x28,%esp
  printf(1,"size\n");
    1752:	c7 44 24 04 48 1a 00 	movl   $0x1a48,0x4(%esp)
    1759:	00 
    175a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1761:	e8 7d f8 ff ff       	call   fe3 <printf>
  int ans =0;
    1766:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  semaphore_down(bb->full);
    176d:	8b 45 08             	mov    0x8(%ebp),%eax
    1770:	8b 40 0c             	mov    0xc(%eax),%eax
    1773:	89 04 24             	mov    %eax,(%esp)
    1776:	e8 d0 fc ff ff       	call   144b <semaphore_down>
  binary_semaphore_down(bb->mutex);
    177b:	8b 45 08             	mov    0x8(%ebp),%eax
    177e:	8b 40 04             	mov    0x4(%eax),%eax
    1781:	89 04 24             	mov    %eax,(%esp)
    1784:	e8 73 f7 ff ff       	call   efc <binary_semaphore_down>
  ans = bb->full->value;
    1789:	8b 45 08             	mov    0x8(%ebp),%eax
    178c:	8b 40 0c             	mov    0xc(%eax),%eax
    178f:	8b 40 08             	mov    0x8(%eax),%eax
    1792:	89 45 f4             	mov    %eax,-0xc(%ebp)
  binary_semaphore_up(bb->mutex);
    1795:	8b 45 08             	mov    0x8(%ebp),%eax
    1798:	8b 40 04             	mov    0x4(%eax),%eax
    179b:	89 04 24             	mov    %eax,(%esp)
    179e:	e8 61 f7 ff ff       	call   f04 <binary_semaphore_up>
  semaphore_up(bb->empty);
    17a3:	8b 45 08             	mov    0x8(%ebp),%eax
    17a6:	8b 40 08             	mov    0x8(%eax),%eax
    17a9:	89 04 24             	mov    %eax,(%esp)
    17ac:	e8 f1 fc ff ff       	call   14a2 <semaphore_up>
  return ans;
    17b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    17b4:	c9                   	leave  
    17b5:	c3                   	ret    

000017b6 <BB_buffer_size>:
int BB_buffer_size(struct BB* bb){
    17b6:	55                   	push   %ebp
    17b7:	89 e5                	mov    %esp,%ebp
    17b9:	83 ec 28             	sub    $0x28,%esp
  printf(1,"buffer_size\n");
    17bc:	c7 44 24 04 4e 1a 00 	movl   $0x1a4e,0x4(%esp)
    17c3:	00 
    17c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17cb:	e8 13 f8 ff ff       	call   fe3 <printf>
  int ans =0;
    17d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  binary_semaphore_down(bb->mutex);
    17d7:	8b 45 08             	mov    0x8(%ebp),%eax
    17da:	8b 40 04             	mov    0x4(%eax),%eax
    17dd:	89 04 24             	mov    %eax,(%esp)
    17e0:	e8 17 f7 ff ff       	call   efc <binary_semaphore_down>
  ans = bb->buffer_size;
    17e5:	8b 45 08             	mov    0x8(%ebp),%eax
    17e8:	8b 00                	mov    (%eax),%eax
    17ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  binary_semaphore_up(bb->mutex);
    17ed:	8b 45 08             	mov    0x8(%ebp),%eax
    17f0:	8b 40 04             	mov    0x4(%eax),%eax
    17f3:	89 04 24             	mov    %eax,(%esp)
    17f6:	e8 09 f7 ff ff       	call   f04 <binary_semaphore_up>
  return ans;
    17fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fe:	c9                   	leave  
    17ff:	c3                   	ret    
