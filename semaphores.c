#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "semaphores.h"
//#include "proc.h"



void
sem_init(sem_t *sem,int value)	//initialize semaphores structure
{
	sem->maxval = value;
  	sem->value = value;
	sem->isactive = 0;
  	sem->locked = 0;
  	initlock(&(sem->lk), "sem lock");
}

void
sem_up(sem_t *sem)				//increase semaphore and wakes up sleeping procs if exist
{
	
	acquire(&(sem->lk));
	sem->value++;
	if (sem->value == sem->maxval)
		sem->isactive = 0;
	sem->locked = 0;
	wakeup(sem);
	release(&(sem->lk));

}

void 
sem_down(sem_t *sem)			//decrease semaphore , if locked == 1 sleep 
{
	acquire(&(sem->lk));
	if (!sem->locked)		// if unlocked
	{
		//acquire(&(sem->lk));
		if (sem->value == 1)
	  		sem->locked = 1;
		sem->value--;
		sem->isactive = 1;
		//release(&(sem->lk));
	}
	else					// if locked
	{
		//acquire(&(sem->lk));
		while(sem->locked)
    		sleep(sem, &(sem->lk));
		if (sem->value == 1)
	  		sem->locked = 1;
	  	else
	  		sem->locked = 0;
		sem->value--;
		sem->isactive = 1;
		//release(&(sem->lk));
	}
	release(&(sem->lk));
}

int
isActive(sem_t *sem)
{
	return (sem->isactive == 1) ? 1 : 0 ;
}


