#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc,char *argv[])
{
	int pid;
	pid = fork();
	sleep(1);
	char *p = shmget("325");
	//*p = 'G';
	if (pid)
	{
		*p = 'I';
		printf(1,"Parent %c %x\n",*p,(unsigned int) p);
		wait();
		printf(1,"Parent After %c %x\n",*p,(unsigned int) p);
	}
	else
	{
		printf(1,"Child %c %x\n",*p,(unsigned int) p);
		*p = '1';
		printf(1,"Child After %c %x\n",*p,(unsigned int) p);
		char *k = shmget("12");
		*k = 'G';
		printf(1,"Child k page %c %x\n",*k,(unsigned int) k);
		shmrem("12");
	}
	//shmrem("51");
	

	exit();	
}