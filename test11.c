#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc,char *argv[])
{
	//int key = 51;
	//printf(1,"key %d\n",key);
	int pid ;
	pid = fork();
	sleep(1);

	char *p = shmget("51");
	//char *s = shmget("151");
	// pid = fork();
	// sleep(1);
	if (pid)
	{	
		p[0] = 'A';
		p[1] = 'D';
		p[2] = 'C';
		//s[0] = '4';
		printf(1,"Parent %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		//printf(1,"%c Parent %c %c %c %x\n",s[0],p[0],p[1],p[2],(unsigned int) p);
		wait();
		printf(1,"ParentAfter %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		p[1] = 'K';
		printf(1,"ParentAfterK %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		//printf(1,"%c ParentAfterK %c %c %c %x\n",s[0],p[0],p[1],p[2],(unsigned int) p);
	}
	else
	{
		printf(1,"Child initially %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
		//printf(1,"%c Child initially %c %c %c %x\n",s[0],p[0],p[1],p[2],(unsigned int) p);
		p[1] = 'J';
		//s[0] = 'Y';
		printf(1,"Child %c %c %c %x\n",p[0],p[1],p[2],(unsigned int) p);
	}

	exit();	
}