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
	initlock(&(sem->slk.lk), "sem lock");
	sem->value = value;
}

void
sem_up(sem_t *sem)
{
	sem->value++;
	acquire(&(sem->lk));
}

void 
sem_down(sem_t *sem)
{
	if (sem->value == 0 )

	else
		sem->value--;
	release(&(sem->lk));
}



