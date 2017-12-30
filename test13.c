#include "types.h"
#include "stat.h"
#include "user.h"
#include "semaphores.h"



int
main(int argc,char *argv[])
{
	sem_t *writers;	
	char *p = shmget("65");
	writers = (sem_t*)p;
	//sem_init(readers, 16);
	sem_init(writers, 1);
	int *buffer;
	buffer = (int *)(p+sizeof(writers));
	buffer[0] = 0;
	int pid;
	pid = fork();
	if (pid)
	{
		wait();
		sem_down(writers);
		//sleep(1);
		printf(1,"fork %d\n",pid);
		printf(1,"Parent before writer\n");
		for (int i=0;i<1000;i++)
		{
			//wait();
			buffer[0]++;
			//printf(1,"PARENT\n");
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
			//printf(1,"CHILD\n");
		}
		printf(1,"Child buffer[0]:%d\n",buffer[0]);
		sem_up(writers);
	}
	//printf(1,"buffer[0]:%d\n",buffer[0]);
	

	exit();	
}

	// char *p = shmget("51");
	// *p = 'a';
	// printf(1,"%c %x\n",*p,(unsigned int) p);
	// char *pp = shmget("9876543321");
	// *pp = 'b';
	// printf(1,"%c %x\n",*pp,(unsigned int) pp);
	// shmrem("51");
	// p = 0;
	// p = shmget("12");
	// *p = 'J';
	// printf(1,"%c %x\n",*p,(unsigned int) p);
	// char *q = shmget("1");
	// *q = 'G';
	// printf(1,"%c %x\n",*q,(unsigned int) q);