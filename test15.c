#include "types.h"
#include "stat.h"
#include "user.h"
#include "semaphores.h"


int main(void)
{
	int i;
	char *p = shmget("1267534567");
	
	sem_t *readers , *writers;
	writers = (sem_t*)p;
	readers = (sem_t*)(p + sizeof(sem_t));
	sem_init(writers,1);
	sem_init(readers,2);
	int m = 2*sizeof(sem_t);
	int sum;
	int *sum1;
	int *buffer;
	buffer = (int*)(p + m);
	int n = 10;
	for (i=0;i<n;i++)
		buffer[i] = i+1;
	m += n*sizeof(int);
	sum1 = (int*)(p + m);
	m += sizeof(int);
	int pid;
	pid = fork();
	pid = fork();
	*sum1 = 1;
	sum = 0;
	buffer[2] = 0;
	if (pid)
	{
		//wait();
		sleep(5);
		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		for (i=0;i<n;i++)
		{	if (i==2)
				continue;
			buffer[2] += buffer[i]; 
		}
		*sum1 = buffer[2];
		printf(1,"Parent buf%d:%d sum:%d\n",2,buffer[2],*sum1);
		sem_up(writers);

		while (isActive(writers))
			continue;
		sem_down(readers);
		for (i=0;i<n;i++)
			sum += buffer[i]; 
		sem_up(readers);
		
	}
	else
	{
		sleep(5);
		
		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		
		for (i=0;i<n;i++)
		{
			if (i==2)
				continue;
			buffer[2] += buffer[i]; 
		}
		*sum1 = buffer[2];
		printf(1,"Child buf%d:%d sum:%d\n",2,buffer[2],*sum1);
		sem_up(writers);
		
		while (isActive(writers))
			continue;
		sem_down(readers);
		
		for (i=0;i<n;i++)
			sum -= buffer[i]; 

		sem_up(readers);
	}

	if (pid)
		wait();
	exit();
}



















