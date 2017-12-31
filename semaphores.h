//#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"
//#include "semaphores.h"

typedef struct sem{
	struct spinlock lk;		// spinlock
	int value;				// value to set semaphore to
	int maxval;
	int locked;
}sem_t;