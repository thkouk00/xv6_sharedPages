#include "types.h"
#include "stat.h"
#include "user.h"
#include "semaphores.h"

//check for max shared pages - 32 in total

int
main(int argc,char *argv[])
{
	int n = 32;				//if i increase n , max shared pages error will occur
	int i;
	char *key = "12345";
	char *addr[n];
	int pid;
	// pid = fork();
	// pid = fork();
	// pid = fork();
	// pid = fork();
	// pid = fork(); 		//if i allow this , max process per page error will occur
	if (pid || !pid)
	{
		for (i=0;i<n;i++)
		{
			*key += i+2;
			addr[i] = shmget(key);
			//addr[i][0] = 'a';			//compiler complaining when i comment printf
			printf(1,"%d-%x , key:%s\n",i,(unsigned int) addr[i],key);
			sleep(5);
		}
	}
	
	exit();	
}