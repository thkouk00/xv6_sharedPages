#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc,char *argv[])
{
	int pid;
	sem_t *writers;
	sleep(1);
	char *h = shmget("325");
	char *p ;
	writers = (sem_t *)h;
	sem_init(writers, 1);
	p = h+sizeof(writers);
	pid = fork();
	if (pid)
	{
		sem_down(writers);
		*p = 'I';
		printf(1,"Parent %c %x\n",*p,(unsigned int) p);
		//wait();
		printf(1,"Parent After %c %x\n",*p,(unsigned int) p);
		sem_up(writers);
	}
	else
	{
		sem_down(writers);
		printf(1,"Child %c %x\n",*p,(unsigned int) p);
		*p = '1';
		printf(1,"Child After %c %x\n",*p,(unsigned int) p);
		sem_up(writers);
	}
	
	exit();	
}