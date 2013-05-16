#include "fcntl.h"
#include "boundedbuffer.h"
#include "types.h"
#include "user.h"
#include "stat.h"


#define STACK_SIZE 1024
enum action_type { UNDEFINED, DRINK_ORDER, RETURN_CUP, GO_HOME};

typedef struct Cup{
  int id;
}Cup;

typedef struct Action {
  int action_type;
  Cup* cup;
  int tid;
}Action;

struct semaphore* bouncer; //this is the bouncer to the Beinstein
struct BB* ABB; //this is a BB for student actions: drink, ans for a dring
struct BB* DrinkBB; //this is a BB holding the drinks that are ready to be drinking
struct BB* CBB; //this is a BB hold clean cups
struct BB* DBB; //this is a BB hold dirty cups
int file_to_write; //file descriptor to write to
int cup_boy_lock; //a lock for the cup boy to sleep on (binary semaphore)
int finished_shift;//TODO clean it
int general_mutex;

// Used to allow students to enter the bar, and thus is
// called by the students. If the bar is full (the semaphore’s value is 0), 
// the student should wait until another student leaves the bar and frees up space. 
void enter_bar(){
  semaphore_down(bouncer);
}

// Used to allow students to leave the bar once they are drunk, 
// and thus is called by the students. 
// When a student leaves the bar, he frees up a place for another student to enter.
void leave_bar(){
  semaphore_up(bouncer);
}

// This function is called by a student whenever he wants to perform an action:
// place an order for a drink from the bar or return a dirty cup. 
// The action is placed at the end of the buffer.
void place_action(Action* action){
  BB_put(ABB,action);
}

// This function is called by a bartender whenever one is free to deal with students’ actions. 
// The Action located at the beginning of the buffer is returned and removed. 
// If there are no actions, the bartender will wait until more actions arrive.
Action* get_action(){
  return BB_pop(ABB);
}

// This function is called by the bartender whenever he finishes to make a drink (ordered by a student). 
// The cup the drink is made in is placed in the DrinkBB.
void serve_drink(Cup* cup){
  BB_put(DrinkBB,cup);
} 

// This function is called by a student after he places an order for a drink, 
// while he waits for his order to be made. 
// If there is a drink ready in the buffer, he will take it (denoted by the cup the drink was made in). 
// If not, he will wait until a drink becomes available
Cup* get_drink(){
  return BB_pop(DrinkBB);
}

// This function is called by a bartender whenever he wishes to make a drink and needs a clean cup for it. 
// If there are no clean cups left, the bartender should wait until the cup boy returns with clean cups.
Cup* get_clean_cup(){
  return BB_pop(CBB);
}

// This function is called by the cup boy when he wishes to add a clean cup he just washed.
void add_clean_cup(Cup* cup){
  BB_put(CBB,cup);
}

// This function is called by a bartender whenever a student finished to drink his drink
// and wishes to return the cup used (i.e when the type of the action the bartender received from 
// ABB is 2 - returning a dirty cup). 
// If at least 60% of the cups are dirty, the cup boy will be notified.
void return_cup(Cup* cup){
  BB_put(DBB,cup);
}

// This function will be called by the cup boy when he wishes to get a dirty cup to clean. 
Cup* wash_dirty(){
  return BB_pop(DBB);
}

// student simulation
void* student(){
   

    enter_bar();
    int tid = thread_getId();
    int i;
    for(i = 0; i < tid % 5; i++){
      printf(1,"Student %d is for i: %d\n",tid,i+1);
      struct Action* drink_action = malloc(sizeof(struct Action));
      memset(drink_action,0,sizeof(struct Action));
      drink_action->action_type = DRINK_ORDER;
      drink_action->cup = 0;
      drink_action->tid = tid;
      place_action(drink_action);//Order a Drink
      struct Cup * cup = get_drink();	//get the drink from the BB
      //need to write to file intsead of screen TODO
      printf(1,"Student %d is having his %d drink, with cup %d\n",tid,i+1,cup->id);
      sleep(1);
      struct Action* return_action = malloc(sizeof(struct Action));
      memset(return_action,0,sizeof(struct Action));
      return_action->action_type = RETURN_CUP;
      return_action->cup=cup;
      return_action->tid = tid;
      place_action(return_action);
    }
    //need to write to file intsead of screen TODO
    printf(1,"Student %d is drunk, and trying to go home\n",thread_getId());
    leave_bar();
    thread_exit(0);
    return 0;
}

//bartender simulation
void* bartender(){
    void* ret_val = 0;
    int tid = thread_getId();
    double amount =0;
    double buf_size =0;
    for(;;){
	struct Action* bartender_action = get_action();	
	if(bartender_action->action_type == DRINK_ORDER){
	    struct Cup* current_cup = get_clean_cup();
	    //need to write to file intsead of screen TODO
	    printf(1,"Bartender %d is making drink with cup %d\n",tid,current_cup->id);
	    serve_drink(current_cup);
	}
	else if(bartender_action->action_type == RETURN_CUP){
	  struct Cup* current_cup = bartender_action->cup;  
	  return_cup(current_cup);
	  //need to write to file intsead of screen TODO
	  printf(1,"Bartender %d returned cup %d\n",tid,current_cup->id);
	  
	  amount = DBB->full->value;
	  buf_size = DBB->buffer_size;
	  
	  if(amount/buf_size >= 0.6){
	    printf(1,"Go Clean Boy %d\n");
	    binary_semaphore_up(cup_boy_lock);
	    }
	if(bartender_action->action_type == GO_HOME){
	  free(bartender_action);
	  thread_exit(ret_val);
	}
      }
	free(bartender_action);
    }
    return 0;
}


// Cup boy simulation
void* cup_boy(void){
  void* ret_val = 0;
  cup_boy_lock = binary_semaphore_create(0);
  int i,n;
  for(;;){
    if(finished_shift){
      thread_exit(ret_val);
    }

    n =DBB->full->value;
   
    
    for(i = 1; i < n; i++){
	struct Cup* current_cup = wash_dirty();
	sleep(1);
	add_clean_cup(current_cup);
	//need to write to file intsead of screen TODO
	printf(1,"Cup boy added clean cup %d\n",current_cup->id);
    }
   printf(1,"Clean Boy- sleep\n");
   binary_semaphore_down(cup_boy_lock); 
   printf(1,"Clean Boy- awake\n");
  }
  return ret_val;
}

// thread_joins on students and bartenders

void join_peoples(int* tids,int num_of_peoples){
  void* ret_val;
  int i;
  for(i = 0; i < num_of_peoples; i++){
    thread_join(tids[i],&ret_val);
  }
}


//return the index to put the value {A, B, C, S, M}
//				     {0, 1, 2, 3, 4}
int values_array_index(char* input_buf, int char_index){
 if(input_buf[char_index] == 'A')
   return 0;
 if(input_buf[char_index] == 'B')
   return 1;
 if(input_buf[char_index] == 'C')
   return 2;
 if(input_buf[char_index] == 'S')
   return 3;
 if(input_buf[char_index] == 'M')
   return 4;
 //error
 return -1;
}

//parsing the configuration file
void parse_buffer(char* input_buf,int* values_array){
 int i;
 int num_of_chars = strlen(input_buf);
 int index;
 char* temp_str;
 for(i = 0;i < num_of_chars; i++){
    if(input_buf[i] == 'A' || input_buf[i] == 'B' || input_buf[i] == 'C' || input_buf[i] == 'S' || input_buf[i] == 'M'){
       index = values_array_index(input_buf,i);
       temp_str = &input_buf[i];
       values_array[index] = atoi(temp_str+4);
    }
 }
}


int main(int argc, char** argv) {
  //variables
  int A;	// number of slots to Actions that can be received
  int B;	// number of bartenders 
  int C;	// number of cups
  int S;	// number of students
  int M;	// maximum number of students that can be at the bar at once
  int fconf;
  int conf_size;
  struct stat bufstat;
  
  fconf = open("con.conf",O_RDONLY);
  fstat(fconf,&bufstat);
  conf_size = bufstat.size;
  char bufconf[conf_size];
  read(fconf,bufconf,conf_size);
  int inputs_parsed[5]; //{Aval, Bval, Cval, Sval, Mval}
  
  parse_buffer(bufconf, inputs_parsed);
  A = inputs_parsed[0];
  B = inputs_parsed[1];
  C = inputs_parsed[2];
  S = inputs_parsed[3];
  M = inputs_parsed[4];
  
  printf(1,"A: %d B: %d C: %d  S: %d M: %d\n",A,B,C,S,M);
  
  void* students_stacks[S];
  void* bartenders_stacks[B];
  void* cup_boy_stack;
  int i;
  int student_tids[S];
  //int bartender_tids[B];
  finished_shift = 0; // cup_boy changes it to 1 if all students left the bar and sends Action => GO_HOME to bartenders

  
  file_to_write = open("out.txt",(O_CREATE | O_WRONLY)); //
  if(file_to_write == -1){
      printf(1,"There was an error opening out.txt\n");
      exit();
  }
  
  
  //Databases
   bouncer = semaphore_create(M);		//this is the bouncer to the Beinstein
   ABB = BB_create(A); 				//this is a BB for student actions: drink, ans for a dring
   DrinkBB = BB_create(A);			//this is a BB holding the drinks that are ready to be drinking
   CBB = BB_create(C);				//this is a BB hold clean cups
   DBB = BB_create(C);				//this is a BB hold dirty cups
   cup_boy_lock = binary_semaphore_create(0); 	// initial cup_boy with 0 so he goes to sleep imidietly on first call to down
   general_mutex = binary_semaphore_create(1);

   //initialize C clean cups
   struct Cup* cup_array[C];
   for(i = 0; i < C; i++){
      cup_array[i] = malloc(sizeof(struct Cup)); //TODO free cups
      //memset(cup_array[i],0,sizeof(void*)*STACK_SIZE);
      cup_array[i]->id = i;
      add_clean_cup(cup_array[i]);
   }
   
   //initialize cup_boy
   cup_boy_stack = (void*)malloc(sizeof(void*)*STACK_SIZE);
   memset(cup_boy_stack,0,sizeof(void*)*STACK_SIZE);
   if(thread_create((void*)cup_boy,cup_boy_stack,sizeof(void*)*STACK_SIZE) < 0){
     printf(2,"Failed to create cupboy thread. Exiting...\n");
    exit();
   }
   
   //initialize B bartenders
   for(i = 0; i < B; i++){
      bartenders_stacks[i] = (void*)malloc(sizeof(void*)*STACK_SIZE);
      memset(bartenders_stacks[i],0,sizeof(void*)*STACK_SIZE);
     thread_create((void*)bartender,bartenders_stacks[i],sizeof(void*)*STACK_SIZE);//TODO test
      //bartender_tids[i] = 
  }
   
   //initialize S students
   for(i = 0; i < S; i++){//TODO test for fail
      students_stacks[i] = malloc(sizeof(void*)*STACK_SIZE);
      memset(students_stacks[i],0,sizeof(void*)*STACK_SIZE);
      student_tids[i] = thread_create((void*)student,students_stacks[i],sizeof(void*)*STACK_SIZE);
  }
  
   join_peoples(student_tids,S); //join students
   finished_shift = 1;
    
    
   //join_peoples(bartender_tids,B); //join bartenders
   sleep(2); // delay so exit will not come before threads finished TODO (need better soloution)
   
   
   if(finished_shift){
      binary_semaphore_up(cup_boy_lock); 
    }
    
    
   if(close(file_to_write) == -1){
    printf(1,"There was an error closing out.txt\n");
    exit();
   }
   
  //free cup_boy_stack
  free(cup_boy_stack);
  
  //after all students have finished need to exit all bartenders and cup boy, and free all memory allocation
  //free cups
  for(i = 0; i < C; i++){
    free(cup_array[i]);
  }
  //free bartenders_stacks
  for(i = 0; i < B; i++){
   free(bartenders_stacks[i]); 
  }
  //free students_stacks
  for(i = 0; i < S; i++){
   free(students_stacks[i]); 
  }
  semaphore_free(bouncer);
  BB_free(ABB);
  BB_free(DrinkBB);
  BB_free(CBB);
  BB_free(DBB);
 
  exit();
  return 0;
}