#include "spinlock.h"
#include "sleeplock.h"

typedef struct sem{
	struct spinlock lk;		// spinlock
	int value;				// value to set semaphore to
	int maxval;				// same as value
	int isactive;			// true if value != maxvalue else false
	int locked;				// true if value == 0 else false
}sem_t;