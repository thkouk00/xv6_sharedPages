#include "types.h"
#include "stat.h"
#include "user.h"
#include "semaphores.h"

int
main(int argc,char *argv[])
{
	char *h = shmget("51");
	sem_t *writers;
	writers = (sem_t *)h;
	char *p;
	p = h+sizeof(sem_t);
	sem_init(writers,1);
	int pid;
	pid = fork();
	sleep(1);
	if (pid)
	{	
		//wait();
		sleep(1);
		while(isActive(writers))
			continue;
		sem_down(writers);
		p[0] = 'A';
		p[1] = 'D';
		//p[2] = 'C';
		printf(1,"Parent %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		p[1] = 'K';
		printf(1,"ParentAfter %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		sem_up(writers);		
	}
	else
	{
		while(isActive(writers))
			continue;
		sem_down(writers);
		p[0] = 'Z';
		p[1] = 'Y';
		p[2] = 'X';
		printf(1,"Child initially %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		p[1] = 'J';
		printf(1,"Child %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		sem_up(writers);
	}

	if (pid)
		wait();
	exit();	
}