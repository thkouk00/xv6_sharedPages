#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "semaphores.h"
//#include "proc.h"



void
sem_init(sem_t *sem,int value)
{
	//sem->maxval = value;
  	sem->value = value;
  	sem->locked = 0;
  	initlock(&(sem->lk), "sem lock");
}

void
sem_up(sem_t *sem)
{
	
	acquire(&(sem->lk));
	sem->value++;
	sem->locked = 0;
	wakeup(sem);
	release(&(sem->lk));

}

void 
sem_down(sem_t *sem)
{
	//acquire(&(sem->lk));
	if (!sem->locked)		// if unlocked
	{
		acquire(&(sem->lk));
		if (sem->value == 1)
		{
	  		sem->locked = 1;
	  		//cprintf("sem down lock\n");
		}
		sem->value--;
		//cprintf("value %d\n",sem->value);
		release(&(sem->lk));
	}
	else						// if locked
	{
		acquire(&(sem->lk));
		//cprintf("EDV %d\n",sem->locked);
		while(sem->locked)
		{
    		sleep(sem, &(sem->lk));
		}
		if (sem->value == 1)
	  		sem->locked = 1;
	  	else
	  		sem->locked = 0;
		sem->value--;
		release(&(sem->lk));
	}
}


