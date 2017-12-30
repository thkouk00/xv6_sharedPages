#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc,char *argv[])
{
	//int key = 51;
	//printf(1,"key %d\n",key);
	int pid ;
	// pid = fork();
	// sleep(1);

	char *h = shmget("51");
	sem_t *writers;
	writers = (sem_t *)h;
	char *p;
	p = h+sizeof(writers);
	sem_init(writers, 1);
	pid = fork();
	sleep(1);
	if (pid)
	{	
		wait();
		sem_down(writers);
		p[0] = 'A';
		p[1] = 'D';
		p[2] = 'C';
		//sem_up(writers);
		printf(1,"Parent %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		printf(1,"ParentAfter %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		//sem_down(writers);
		p[1] = 'K';
		printf(1,"ParentAfterK %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		sem_up(writers);		
	}
	else
	{
		sem_down(writers);
		printf(1,"Child initially %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		p[1] = 'J';
		printf(1,"Child %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		sem_up(writers);
	}

	exit();	
}