#include "types.h"
#include "stat.h"
#include "user.h"
#include "semaphores.h"

int
main(int argc,char *argv[])
{
	char temp[4];
	char temp1[4];
	int pid;
	sem_t *writers;
	sem_t *readers;
	sleep(1);
	char *h = shmget("325");
	char *p ;
	writers = (sem_t *)h;
	sem_init(writers, 1);
	readers = (sem_t *)(h+sizeof(sem_t));
	sem_init(readers, 4);
	int *writing;
	int *reading;
	writing = (int*)(h + 2*sizeof(sem_t));
	reading = (int*)(h + 2*sizeof(sem_t) + sizeof(int *));
	*writing = *reading = 0;
	p = h + 2*sizeof(sem_t) + 2*sizeof(int);
	p[0] = 'A';
	p[1] = 'B';
	p[2] = 'C';
	p[3] = 'D';
	pid = fork();
	if (pid)
	{
		//wait();
		while(*writing);
		sem_down(readers);
		printf(1," reader down child\n");
		*reading = 1;
		for (int i=0;i<4;i++)
			temp1[i] = p[i];
		printf(1,"giname\n");
		sem_up(readers);
		*reading = 0;
		wait();
		while (*reading || *writing);
		sem_down(writers);
		*writing = 1;
		for (int i=0;i<4;i++)
			printf(1,"%c ",temp1[i]);
		printf(1,"\n");
		sem_up(writers);
		*writing = 0;
		// while (*reading )//|| *writing);
		// 	printf(1,"@\n");
		// printf(1,"Before writer down parent\n");
		// sem_down(writers);
		// printf(1,"After writer down parent\n");
		// *writing = 1;
		// *p = 'I';
		// printf(1,"Parent %c %x\n",*p,(unsigned int) p);
		// //wait();
		// printf(1,"Parent After %c %x\n",*p,(unsigned int) p);
		// sem_up(writers);
		// *writing = 0;
		// printf(1,"Out writer down parent\n");
	}
	else
	{	//metabliti temp na krataei posa atoma diabazoyn
		while (*writing);
		sem_down(readers);
		printf(1,"Before reader down child\n");
		//printf(1,"After reader down child\n");
		*reading = 1;  
		for (int i=0;i<4;i++)
			temp[i] = p[i];
		temp[3] = '5';
		printf(1,"giname11\n");
		sem_up(readers);
		//printf(1,"Out reader down child\n");
		*reading = 0;
		
		while (*reading || *writing);
		sem_down(writers);
		for (int i=0;i<4;i++)
			printf(1,"%c ",temp[i]);	
		printf(1,"\n");
		sem_up(writers);
		*writing = 0;

		// while (*reading || *writing)
		// 	printf(1,"$\n");
		// printf(1,"Before writer down child\n");
		// sem_down(writers);
		// printf(1,"After writer down child\n");
		// *writing = 1;
		// for (int i=0;i<4;i++)
		// 	printf(1,"%c ",temp[i]);
		// printf(1,"\nChild %c %x\n",*p,(unsigned int) p);
		// *p = '1';
		// printf(1,"Child After %c %x\n",*p,(unsigned int) p);
		// sem_up(writers);
		// printf(1,"Out writer down child\n");
		// *writing = 0;
	}

	if (pid)
		wait();
	exit();	
}