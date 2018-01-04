#include "types.h"
#include "stat.h"
#include "user.h"
#include "semaphores.h"



int
main(int argc,char *argv[])
{
	sem_t *writers;
	sem_t *readers;	
	char *p = shmget("65");
	writers = (sem_t*)p;
	readers = (sem_t*)(p+sizeof(sem_t));
	sem_init(readers, 16);
	sem_init(writers, 1);
	int *buffer;
	buffer = (int *)(p+2*sizeof(sem_t));
	buffer[0] = 1;
	printf(1,"buf0 %d\n",buffer[0]);
	int sum;
	int pid;
	pid = fork();
	if (pid)
	{
		//wait();
		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		printf(1,"Parent before writer\n");
		for (int i=0;i<1000;i++)
		{
			buffer[0]++;
		}
		printf(1,"Parent buffer[0]:%d\n",buffer[0]);
		sem_up(writers);
		
		sleep(5);
		
		while(isActive(writers))
			continue;
		sem_down(readers);
		printf(1,"Parent is reading\n");
		sum = buffer[0];
		sum -= 555;
		sem_up(readers);

		//wait();
		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		printf(1,"Parent sum:%d\n",sum);
		sem_up(writers);
	}
	else
	{
		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		printf(1,"Child before writer\n");
		for (int i=0;i<2000;i++)
		{
			buffer[0]--;
		}
		printf(1,"Child buffer[0]:%d\n",buffer[0]);
		sem_up(writers);

		while(isActive(writers))
			continue;
		sem_down(readers);
		printf(1,"Child is reading\n");
		sum = buffer[0];
		sum += 1000;
		sem_up(readers);

		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		printf(1,"Child sum:%d\n",sum);
		sem_up(writers);
	}
		
	if (pid)
		wait();
	exit();	
}
