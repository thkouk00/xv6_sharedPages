#include "types.h"
#include "stat.h"
#include "user.h"
#include "semaphores.h"



int
main(int argc,char *argv[])
{
	sem_t *writers;
	//sem_t *readers;	
	char *p = shmget("65");
	writers = (sem_t*)p;
	//readers = (sem_t*)(p+sizeof(writers));
	//sem_init(readers, 16);
	printf(1,"HERE\n");
	sem_init(writers, 1);
	int *buffer;
	//buffer = (int *)(&p[sizeof(writers)+sizeof(readers)]);
	buffer = (int *)(p+sizeof(writers));
	buffer[0] = 1;
	printf(1,"buf0 %d\n",buffer[0]);
	int pid;
	pid = fork();
	if (pid)
	{
		//wait();
		sem_down(writers);
		printf(1,"fork %d\n",pid);
		printf(1,"Parent before writer\n");
		for (int i=0;i<1000;i++)
		{
			buffer[0]++;
		}
		printf(1,"Parent buffer[0]:%d\n",buffer[0]);
		sem_up(writers);
	}
	else
	{
		sem_down(writers);
		printf(1,"fork %d\n",pid);
		printf(1,"Child before writer\n");
		for (int i=0;i<1000;i++)
		{
			buffer[0]--;
		}
		printf(1,"Child buffer[0]:%d\n",buffer[0]);
		sem_up(writers);
	}
		

	exit();	
}
