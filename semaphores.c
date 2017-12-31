#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
// //#include "proc.h"
// #include "spinlock.h"
// #include "sleeplock.h"
#include "semaphores.h"

// typedef struct sem{
// 	struct spinlock lk;		// spinlock
// 	int value;				// value to set semaphore to
// }sem_t;

void
sem_init(sem_t *sem,int value)
{
	sem->maxval = value;
  	sem->value = value;
  	sem->locked = 0;
  	initlock(&(sem->lk), "sem lock");
}

void
sem_up(sem_t *sem)
{
	//cprintf("acquire\n");
	//acquire(&(sem->lk));
	if (sem->locked == 1)
	{	
		acquire(&(sem->lk));
		sem->value++;
		sem->locked = 0;
		wakeup(sem);
		release(&(sem->lk));
	}
	//release(&(sem->lk));
}

void 
sem_down(sem_t *sem)
{
	//acquire(&(sem->lk));
	if (sem->locked == 0)
	{
		acquire(&(sem->lk));
		//if (sem->value -1 == 0)
	  	sem->locked = 1;
		sem->value--;
		release(&(sem->lk));
	}
	else
	{
		acquire(&(sem->lk));
		//cprintf("EDV\n");
		while(sem->locked)
		{
    		//cprintf("HERE\n");
    		sleep(sem, &(sem->lk));
		}
		sem->value--;
		release(&(sem->lk));
	}
}


