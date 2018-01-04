#include "types.h"
#include "stat.h"
#include "user.h"
#include "semaphores.h"

int
main(int argc,char *argv[])
{
	char temp1[4];
	int pid;
	sem_t *writers;
	sem_t *readers;
	char *h = shmget("325");
	char *p ;
	writers = (sem_t *)h;
	sem_init(writers, 1);
	readers = (sem_t *)(h+sizeof(sem_t));
	sem_init(readers, 4);
	p = h + 2*sizeof(sem_t);
	p[0] = 'A';
	p[1] = 'B';
	p[2] = 'C';
	p[3] = 'D';
	pid = fork();
	if (pid)
	{
		wait();
		while (isActive(writers))
			continue;
		sem_down(readers);
		for (int i=0;i<4;i++)
			temp1[i] = p[i];
		sem_up(readers);
		
		wait();
		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		printf(1,"Parent is Writing\n");
		for (int i=0;i<4;i++)
		{
			p[i] = temp1[3-i];
			printf(1,"%c ",p[i]);
		}
		printf(1,"\n");
		sem_up(writers);	
	}
	else
	{	
		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		printf(1,"Child is Writing\n");
		p[1] = 'W';
		for (int i=0;i<4;i++)
			printf(1,"%c ",p[i]);	
		printf(1,"\n");
		sem_up(writers);
	}

	if (pid)
		wait();
	exit();	
}