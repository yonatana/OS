#include "boundedbuffer.h"
#include "types.h"
#include "user.h"

struct BB* 
BB_create(int max_capacity){
  //initialize
  struct BB* buf = malloc(sizeof(struct BB));
  buf->buffer_size = max_capacity;
  buf->mutex = binary_semaphore_create (1);
  buf-> empty_slots = semaphore_create(max_capacity));
  buf->full_slots = semaphore_create(0));
  //check the semaphorses
  if(mutex == -1 || empty_slots == 0 || full_slots == 0){
   printf(1,"we had a probalme getting semaphores at BB create");
   free(buf);
   buf =0;  
  }
  return buf;
}

void BB_put(struct BB* bb, void* element)}
{
  void *temp_item;
  int count = 0;
  int flag =0;//if we found a place to put the item
  semaphore_down(bb->empty_slots);//filling the empty slots
  binary_semaphore_down(bb->mutex);//get the key to the counter (enter CS)
  while(!flag){
    //looking at the counter for an empty slot 
    for(temp_item = bb->elements; temp_item < &bb->elements[bb->buffer_size]; temp_item++){
      if(temp_item){//not empty
	count++;
	continue;
      }
      //found an empty slot
      temp_item = element;
      flag =1;
      break;
    }
    if(!flag){//we didnt found a place
      //relaese
      //wait\sleep
      //try again
    }
  }
  binary_semaphore_up(bb->mutex);//realse the key to the counter.
  semaphore_up(bb->full_slots);//
}

void* BB_pop(struct BB* bb)
{
  void* temp_item;
  int count = 0;
  int flag =0;
  semaphore_down(bb->full_slots);//taking one item
  binary_semaphore_down(bb->mutex);//get the key to the counter (enter CS)
    while(!flag){
    //look at the counter for an item
    for(temp_item = bb->elements; temp_item < &bb->elements[bb->buffer_size]; temp_item++){
      if(!temp_item){//empty place
	count++;
	continue;
      }
      bb->elements[count] = 0;//remove an item
      break;
    }
    if(!flag){//we didnt found a place
      //relaese
      //wait\sleep
      //try again
    }
   }
  binary_semaphore_up(bb->mutex);//relaese the key
  semaphore_up(bb->empty_slots);
  return temp_item;
}