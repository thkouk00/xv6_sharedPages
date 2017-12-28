#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc,char *argv[])
{
	//int key = 51;
	//printf(1,"key %d\n",key);
	char *p = shmget("51");
	*p = 'a';
	printf(1,"%c %x\n",*p,(unsigned int) p);
	char *pp = shmget("9876543321");
	*pp = 'b';
	printf(1,"%c %x\n",*pp,(unsigned int) pp);
	shmrem("51");
	p = 0;
	p = shmget("12");
	*p = 'J';
	printf(1,"%c %x\n",*p,(unsigned int) p);
	char *q = shmget("1");
	*q = 'G';
	printf(1,"%c %x\n",*q,(unsigned int) q);
	//memset(p, 0, 4096);
	//memset(pp, 0, 4096);

	exit();	
}