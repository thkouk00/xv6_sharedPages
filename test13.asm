
_test13:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:



int
main(int argc,char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 14             	sub    $0x14,%esp
	sem_t *writers;
	sem_t *readers;	
	char *p = shmget("65");
  14:	68 30 09 00 00       	push   $0x930
  19:	e8 14 05 00 00       	call   532 <shmget>
  1e:	89 c3                	mov    %eax,%ebx
	writers = (sem_t*)p;
	readers = (sem_t*)(p+sizeof(sem_t));
  20:	8d 70 44             	lea    0x44(%eax),%esi
	sem_init(readers, 16);
  23:	58                   	pop    %eax
  24:	5a                   	pop    %edx
  25:	6a 10                	push   $0x10
  27:	56                   	push   %esi
  28:	e8 15 05 00 00       	call   542 <sem_init>
	sem_init(writers, 1);
  2d:	59                   	pop    %ecx
  2e:	5f                   	pop    %edi
  2f:	6a 01                	push   $0x1
  31:	53                   	push   %ebx
  32:	e8 0b 05 00 00       	call   542 <sem_init>
	int *buffer;
	buffer = (int *)(p+2*sizeof(sem_t));
	buffer[0] = 1;
	printf(1,"buf0 %d\n",buffer[0]);
  37:	83 c4 0c             	add    $0xc,%esp
	readers = (sem_t*)(p+sizeof(sem_t));
	sem_init(readers, 16);
	sem_init(writers, 1);
	int *buffer;
	buffer = (int *)(p+2*sizeof(sem_t));
	buffer[0] = 1;
  3a:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
  41:	00 00 00 
	printf(1,"buf0 %d\n",buffer[0]);
  44:	6a 01                	push   $0x1
  46:	68 33 09 00 00       	push   $0x933
  4b:	6a 01                	push   $0x1
  4d:	e8 be 05 00 00       	call   610 <printf>
	int sum;
	int pid;
	pid = fork();
  52:	e8 33 04 00 00       	call   48a <fork>
	if (pid)
  57:	83 c4 10             	add    $0x10,%esp
  5a:	85 c0                	test   %eax,%eax
  5c:	0f 84 fe 00 00 00    	je     160 <main+0x160>
	{
		//wait();
		while (isActive(writers) || isActive(readers))
  62:	83 ec 0c             	sub    $0xc,%esp
  65:	53                   	push   %ebx
  66:	e8 ef 04 00 00       	call   55a <isActive>
  6b:	83 c4 10             	add    $0x10,%esp
  6e:	85 c0                	test   %eax,%eax
  70:	75 f0                	jne    62 <main+0x62>
  72:	83 ec 0c             	sub    $0xc,%esp
  75:	56                   	push   %esi
  76:	e8 df 04 00 00       	call   55a <isActive>
  7b:	83 c4 10             	add    $0x10,%esp
  7e:	85 c0                	test   %eax,%eax
  80:	75 e0                	jne    62 <main+0x62>
			continue;
		sem_down(writers);
  82:	83 ec 0c             	sub    $0xc,%esp
  85:	53                   	push   %ebx
  86:	e8 c7 04 00 00       	call   552 <sem_down>
		printf(1,"Parent before writer\n");
  8b:	59                   	pop    %ecx
  8c:	5f                   	pop    %edi
  8d:	68 3c 09 00 00       	push   $0x93c
  92:	6a 01                	push   $0x1
  94:	e8 77 05 00 00       	call   610 <printf>
  99:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
		for (int i=0;i<1000;i++)
		{
			buffer[0]++;
		}
		printf(1,"Parent buffer[0]:%d\n",buffer[0]);
  9f:	83 c4 0c             	add    $0xc,%esp
  a2:	05 e8 03 00 00       	add    $0x3e8,%eax
  a7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  ad:	50                   	push   %eax
  ae:	68 52 09 00 00       	push   $0x952
  b3:	6a 01                	push   $0x1
  b5:	e8 56 05 00 00       	call   610 <printf>
		sem_up(writers);
  ba:	89 1c 24             	mov    %ebx,(%esp)
  bd:	e8 88 04 00 00       	call   54a <sem_up>
		
		sleep(5);
  c2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  c9:	e8 54 04 00 00       	call   522 <sleep>
		
		while(isActive(writers))
  ce:	83 c4 10             	add    $0x10,%esp
  d1:	83 ec 0c             	sub    $0xc,%esp
  d4:	53                   	push   %ebx
  d5:	e8 80 04 00 00       	call   55a <isActive>
  da:	83 c4 10             	add    $0x10,%esp
  dd:	85 c0                	test   %eax,%eax
  df:	75 f0                	jne    d1 <main+0xd1>
			continue;
		sem_down(readers);
  e1:	83 ec 0c             	sub    $0xc,%esp
  e4:	56                   	push   %esi
  e5:	e8 68 04 00 00       	call   552 <sem_down>
		printf(1,"Parent is reading\n");
  ea:	58                   	pop    %eax
  eb:	5a                   	pop    %edx
  ec:	68 67 09 00 00       	push   $0x967
  f1:	6a 01                	push   $0x1
  f3:	e8 18 05 00 00       	call   610 <printf>
		sum = buffer[0];
		sum -= 555;
  f8:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
		sem_up(readers);
  fe:	89 34 24             	mov    %esi,(%esp)
		while(isActive(writers))
			continue;
		sem_down(readers);
		printf(1,"Parent is reading\n");
		sum = buffer[0];
		sum -= 555;
 101:	8d b8 d5 fd ff ff    	lea    -0x22b(%eax),%edi
		sem_up(readers);
 107:	e8 3e 04 00 00       	call   54a <sem_up>

		//wait();
		while (isActive(writers) || isActive(readers))
 10c:	83 c4 10             	add    $0x10,%esp
 10f:	83 ec 0c             	sub    $0xc,%esp
 112:	53                   	push   %ebx
 113:	e8 42 04 00 00       	call   55a <isActive>
 118:	83 c4 10             	add    $0x10,%esp
 11b:	85 c0                	test   %eax,%eax
 11d:	75 f0                	jne    10f <main+0x10f>
 11f:	83 ec 0c             	sub    $0xc,%esp
 122:	56                   	push   %esi
 123:	e8 32 04 00 00       	call   55a <isActive>
 128:	83 c4 10             	add    $0x10,%esp
 12b:	85 c0                	test   %eax,%eax
 12d:	75 e0                	jne    10f <main+0x10f>
			continue;
		sem_down(writers);
 12f:	83 ec 0c             	sub    $0xc,%esp
 132:	53                   	push   %ebx
 133:	e8 1a 04 00 00       	call   552 <sem_down>
		printf(1,"Parent sum:%d\n",sum);
 138:	83 c4 0c             	add    $0xc,%esp
 13b:	57                   	push   %edi
 13c:	68 7a 09 00 00       	push   $0x97a
 141:	6a 01                	push   $0x1
 143:	e8 c8 04 00 00       	call   610 <printf>
		sem_up(writers);
 148:	89 1c 24             	mov    %ebx,(%esp)
 14b:	e8 fa 03 00 00       	call   54a <sem_up>
		printf(1,"Child sum:%d\n",sum);
		sem_up(writers);
	}
		
	if (pid)
		wait();
 150:	e8 45 03 00 00       	call   49a <wait>
 155:	83 c4 10             	add    $0x10,%esp
	exit();	
 158:	e8 35 03 00 00       	call   492 <exit>
 15d:	8d 76 00             	lea    0x0(%esi),%esi
		printf(1,"Parent sum:%d\n",sum);
		sem_up(writers);
	}
	else
	{
		while (isActive(writers) || isActive(readers))
 160:	83 ec 0c             	sub    $0xc,%esp
 163:	53                   	push   %ebx
 164:	e8 f1 03 00 00       	call   55a <isActive>
 169:	83 c4 10             	add    $0x10,%esp
 16c:	85 c0                	test   %eax,%eax
 16e:	75 f0                	jne    160 <main+0x160>
 170:	83 ec 0c             	sub    $0xc,%esp
 173:	56                   	push   %esi
 174:	e8 e1 03 00 00       	call   55a <isActive>
 179:	83 c4 10             	add    $0x10,%esp
 17c:	85 c0                	test   %eax,%eax
 17e:	75 e0                	jne    160 <main+0x160>
			continue;
		sem_down(writers);
 180:	83 ec 0c             	sub    $0xc,%esp
 183:	53                   	push   %ebx
 184:	e8 c9 03 00 00       	call   552 <sem_down>
		printf(1,"Child before writer\n");
 189:	59                   	pop    %ecx
 18a:	5f                   	pop    %edi
 18b:	68 89 09 00 00       	push   $0x989
 190:	6a 01                	push   $0x1
 192:	e8 79 04 00 00       	call   610 <printf>
 197:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
		for (int i=0;i<2000;i++)
		{
			buffer[0]--;
		}
		printf(1,"Child buffer[0]:%d\n",buffer[0]);
 19d:	83 c4 0c             	add    $0xc,%esp
 1a0:	2d d0 07 00 00       	sub    $0x7d0,%eax
 1a5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
 1ab:	50                   	push   %eax
 1ac:	68 9e 09 00 00       	push   $0x99e
 1b1:	6a 01                	push   $0x1
 1b3:	e8 58 04 00 00       	call   610 <printf>
		sem_up(writers);
 1b8:	89 1c 24             	mov    %ebx,(%esp)
 1bb:	e8 8a 03 00 00       	call   54a <sem_up>

		while(isActive(writers))
 1c0:	83 c4 10             	add    $0x10,%esp
 1c3:	83 ec 0c             	sub    $0xc,%esp
 1c6:	53                   	push   %ebx
 1c7:	e8 8e 03 00 00       	call   55a <isActive>
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	85 c0                	test   %eax,%eax
 1d1:	75 f0                	jne    1c3 <main+0x1c3>
			continue;
		sem_down(readers);
 1d3:	83 ec 0c             	sub    $0xc,%esp
 1d6:	56                   	push   %esi
 1d7:	e8 76 03 00 00       	call   552 <sem_down>
		printf(1,"Child is reading\n");
 1dc:	58                   	pop    %eax
 1dd:	5a                   	pop    %edx
 1de:	68 b2 09 00 00       	push   $0x9b2
 1e3:	6a 01                	push   $0x1
 1e5:	e8 26 04 00 00       	call   610 <printf>
		sum = buffer[0];
		sum += 1000;
 1ea:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
		sem_up(readers);
 1f0:	89 34 24             	mov    %esi,(%esp)
		while(isActive(writers))
			continue;
		sem_down(readers);
		printf(1,"Child is reading\n");
		sum = buffer[0];
		sum += 1000;
 1f3:	8d b8 e8 03 00 00    	lea    0x3e8(%eax),%edi
		sem_up(readers);
 1f9:	e8 4c 03 00 00       	call   54a <sem_up>

		while (isActive(writers) || isActive(readers))
 1fe:	83 c4 10             	add    $0x10,%esp
 201:	83 ec 0c             	sub    $0xc,%esp
 204:	53                   	push   %ebx
 205:	e8 50 03 00 00       	call   55a <isActive>
 20a:	83 c4 10             	add    $0x10,%esp
 20d:	85 c0                	test   %eax,%eax
 20f:	75 f0                	jne    201 <main+0x201>
 211:	83 ec 0c             	sub    $0xc,%esp
 214:	56                   	push   %esi
 215:	e8 40 03 00 00       	call   55a <isActive>
 21a:	83 c4 10             	add    $0x10,%esp
 21d:	85 c0                	test   %eax,%eax
 21f:	75 e0                	jne    201 <main+0x201>
			continue;
		sem_down(writers);
 221:	83 ec 0c             	sub    $0xc,%esp
 224:	53                   	push   %ebx
 225:	e8 28 03 00 00       	call   552 <sem_down>
		printf(1,"Child sum:%d\n",sum);
 22a:	83 c4 0c             	add    $0xc,%esp
 22d:	57                   	push   %edi
 22e:	68 c4 09 00 00       	push   $0x9c4
 233:	6a 01                	push   $0x1
 235:	e8 d6 03 00 00       	call   610 <printf>
		sem_up(writers);
 23a:	89 1c 24             	mov    %ebx,(%esp)
 23d:	e8 08 03 00 00       	call   54a <sem_up>
 242:	83 c4 10             	add    $0x10,%esp
 245:	e9 0e ff ff ff       	jmp    158 <main+0x158>
 24a:	66 90                	xchg   %ax,%ax
 24c:	66 90                	xchg   %ax,%ax
 24e:	66 90                	xchg   %ax,%ax

00000250 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 25a:	89 c2                	mov    %eax,%edx
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 260:	83 c1 01             	add    $0x1,%ecx
 263:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 267:	83 c2 01             	add    $0x1,%edx
 26a:	84 db                	test   %bl,%bl
 26c:	88 5a ff             	mov    %bl,-0x1(%edx)
 26f:	75 ef                	jne    260 <strcpy+0x10>
    ;
  return os;
}
 271:	5b                   	pop    %ebx
 272:	5d                   	pop    %ebp
 273:	c3                   	ret    
 274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 27a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000280 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
 285:	8b 55 08             	mov    0x8(%ebp),%edx
 288:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 28b:	0f b6 02             	movzbl (%edx),%eax
 28e:	0f b6 19             	movzbl (%ecx),%ebx
 291:	84 c0                	test   %al,%al
 293:	75 1e                	jne    2b3 <strcmp+0x33>
 295:	eb 29                	jmp    2c0 <strcmp+0x40>
 297:	89 f6                	mov    %esi,%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2a0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2a3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2a6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2a9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2ad:	84 c0                	test   %al,%al
 2af:	74 0f                	je     2c0 <strcmp+0x40>
 2b1:	89 f1                	mov    %esi,%ecx
 2b3:	38 d8                	cmp    %bl,%al
 2b5:	74 e9                	je     2a0 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2b7:	29 d8                	sub    %ebx,%eax
}
 2b9:	5b                   	pop    %ebx
 2ba:	5e                   	pop    %esi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2c0:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2c2:	29 d8                	sub    %ebx,%eax
}
 2c4:	5b                   	pop    %ebx
 2c5:	5e                   	pop    %esi
 2c6:	5d                   	pop    %ebp
 2c7:	c3                   	ret    
 2c8:	90                   	nop
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002d0 <strlen>:

uint
strlen(char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2d6:	80 39 00             	cmpb   $0x0,(%ecx)
 2d9:	74 12                	je     2ed <strlen+0x1d>
 2db:	31 d2                	xor    %edx,%edx
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
 2e0:	83 c2 01             	add    $0x1,%edx
 2e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2e7:	89 d0                	mov    %edx,%eax
 2e9:	75 f5                	jne    2e0 <strlen+0x10>
    ;
  return n;
}
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 2ed:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    
 2f1:	eb 0d                	jmp    300 <memset>
 2f3:	90                   	nop
 2f4:	90                   	nop
 2f5:	90                   	nop
 2f6:	90                   	nop
 2f7:	90                   	nop
 2f8:	90                   	nop
 2f9:	90                   	nop
 2fa:	90                   	nop
 2fb:	90                   	nop
 2fc:	90                   	nop
 2fd:	90                   	nop
 2fe:	90                   	nop
 2ff:	90                   	nop

00000300 <memset>:

void*
memset(void *dst, int c, uint n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 307:	8b 4d 10             	mov    0x10(%ebp),%ecx
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	89 d7                	mov    %edx,%edi
 30f:	fc                   	cld    
 310:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 312:	89 d0                	mov    %edx,%eax
 314:	5f                   	pop    %edi
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    
 317:	89 f6                	mov    %esi,%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <strchr>:

char*
strchr(const char *s, char c)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	53                   	push   %ebx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 32a:	0f b6 10             	movzbl (%eax),%edx
 32d:	84 d2                	test   %dl,%dl
 32f:	74 1d                	je     34e <strchr+0x2e>
    if(*s == c)
 331:	38 d3                	cmp    %dl,%bl
 333:	89 d9                	mov    %ebx,%ecx
 335:	75 0d                	jne    344 <strchr+0x24>
 337:	eb 17                	jmp    350 <strchr+0x30>
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 340:	38 ca                	cmp    %cl,%dl
 342:	74 0c                	je     350 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 344:	83 c0 01             	add    $0x1,%eax
 347:	0f b6 10             	movzbl (%eax),%edx
 34a:	84 d2                	test   %dl,%dl
 34c:	75 f2                	jne    340 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 34e:	31 c0                	xor    %eax,%eax
}
 350:	5b                   	pop    %ebx
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <gets>:

char*
gets(char *buf, int max)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 366:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 368:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 36b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 36e:	eb 29                	jmp    399 <gets+0x39>
    cc = read(0, &c, 1);
 370:	83 ec 04             	sub    $0x4,%esp
 373:	6a 01                	push   $0x1
 375:	57                   	push   %edi
 376:	6a 00                	push   $0x0
 378:	e8 2d 01 00 00       	call   4aa <read>
    if(cc < 1)
 37d:	83 c4 10             	add    $0x10,%esp
 380:	85 c0                	test   %eax,%eax
 382:	7e 1d                	jle    3a1 <gets+0x41>
      break;
    buf[i++] = c;
 384:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 388:	8b 55 08             	mov    0x8(%ebp),%edx
 38b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 38d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 38f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 393:	74 1b                	je     3b0 <gets+0x50>
 395:	3c 0d                	cmp    $0xd,%al
 397:	74 17                	je     3b0 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 399:	8d 5e 01             	lea    0x1(%esi),%ebx
 39c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 39f:	7c cf                	jl     370 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ab:	5b                   	pop    %ebx
 3ac:	5e                   	pop    %esi
 3ad:	5f                   	pop    %edi
 3ae:	5d                   	pop    %ebp
 3af:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3b5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3bc:	5b                   	pop    %ebx
 3bd:	5e                   	pop    %esi
 3be:	5f                   	pop    %edi
 3bf:	5d                   	pop    %ebp
 3c0:	c3                   	ret    
 3c1:	eb 0d                	jmp    3d0 <stat>
 3c3:	90                   	nop
 3c4:	90                   	nop
 3c5:	90                   	nop
 3c6:	90                   	nop
 3c7:	90                   	nop
 3c8:	90                   	nop
 3c9:	90                   	nop
 3ca:	90                   	nop
 3cb:	90                   	nop
 3cc:	90                   	nop
 3cd:	90                   	nop
 3ce:	90                   	nop
 3cf:	90                   	nop

000003d0 <stat>:

int
stat(char *n, struct stat *st)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	56                   	push   %esi
 3d4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d5:	83 ec 08             	sub    $0x8,%esp
 3d8:	6a 00                	push   $0x0
 3da:	ff 75 08             	pushl  0x8(%ebp)
 3dd:	e8 f0 00 00 00       	call   4d2 <open>
  if(fd < 0)
 3e2:	83 c4 10             	add    $0x10,%esp
 3e5:	85 c0                	test   %eax,%eax
 3e7:	78 27                	js     410 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3e9:	83 ec 08             	sub    $0x8,%esp
 3ec:	ff 75 0c             	pushl  0xc(%ebp)
 3ef:	89 c3                	mov    %eax,%ebx
 3f1:	50                   	push   %eax
 3f2:	e8 f3 00 00 00       	call   4ea <fstat>
 3f7:	89 c6                	mov    %eax,%esi
  close(fd);
 3f9:	89 1c 24             	mov    %ebx,(%esp)
 3fc:	e8 b9 00 00 00       	call   4ba <close>
  return r;
 401:	83 c4 10             	add    $0x10,%esp
 404:	89 f0                	mov    %esi,%eax
}
 406:	8d 65 f8             	lea    -0x8(%ebp),%esp
 409:	5b                   	pop    %ebx
 40a:	5e                   	pop    %esi
 40b:	5d                   	pop    %ebp
 40c:	c3                   	ret    
 40d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 415:	eb ef                	jmp    406 <stat+0x36>
 417:	89 f6                	mov    %esi,%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	53                   	push   %ebx
 424:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 427:	0f be 11             	movsbl (%ecx),%edx
 42a:	8d 42 d0             	lea    -0x30(%edx),%eax
 42d:	3c 09                	cmp    $0x9,%al
 42f:	b8 00 00 00 00       	mov    $0x0,%eax
 434:	77 1f                	ja     455 <atoi+0x35>
 436:	8d 76 00             	lea    0x0(%esi),%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 440:	8d 04 80             	lea    (%eax,%eax,4),%eax
 443:	83 c1 01             	add    $0x1,%ecx
 446:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44a:	0f be 11             	movsbl (%ecx),%edx
 44d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 450:	80 fb 09             	cmp    $0x9,%bl
 453:	76 eb                	jbe    440 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 455:	5b                   	pop    %ebx
 456:	5d                   	pop    %ebp
 457:	c3                   	ret    
 458:	90                   	nop
 459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000460 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	56                   	push   %esi
 464:	53                   	push   %ebx
 465:	8b 5d 10             	mov    0x10(%ebp),%ebx
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 46e:	85 db                	test   %ebx,%ebx
 470:	7e 14                	jle    486 <memmove+0x26>
 472:	31 d2                	xor    %edx,%edx
 474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 478:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 47c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 47f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 482:	39 da                	cmp    %ebx,%edx
 484:	75 f2                	jne    478 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 486:	5b                   	pop    %ebx
 487:	5e                   	pop    %esi
 488:	5d                   	pop    %ebp
 489:	c3                   	ret    

0000048a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 48a:	b8 01 00 00 00       	mov    $0x1,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <exit>:
SYSCALL(exit)
 492:	b8 02 00 00 00       	mov    $0x2,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <wait>:
SYSCALL(wait)
 49a:	b8 03 00 00 00       	mov    $0x3,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <pipe>:
SYSCALL(pipe)
 4a2:	b8 04 00 00 00       	mov    $0x4,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <read>:
SYSCALL(read)
 4aa:	b8 05 00 00 00       	mov    $0x5,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <write>:
SYSCALL(write)
 4b2:	b8 10 00 00 00       	mov    $0x10,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <close>:
SYSCALL(close)
 4ba:	b8 15 00 00 00       	mov    $0x15,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <kill>:
SYSCALL(kill)
 4c2:	b8 06 00 00 00       	mov    $0x6,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <exec>:
SYSCALL(exec)
 4ca:	b8 07 00 00 00       	mov    $0x7,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <open>:
SYSCALL(open)
 4d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <mknod>:
SYSCALL(mknod)
 4da:	b8 11 00 00 00       	mov    $0x11,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <unlink>:
SYSCALL(unlink)
 4e2:	b8 12 00 00 00       	mov    $0x12,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <fstat>:
SYSCALL(fstat)
 4ea:	b8 08 00 00 00       	mov    $0x8,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <link>:
SYSCALL(link)
 4f2:	b8 13 00 00 00       	mov    $0x13,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <mkdir>:
SYSCALL(mkdir)
 4fa:	b8 14 00 00 00       	mov    $0x14,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <chdir>:
SYSCALL(chdir)
 502:	b8 09 00 00 00       	mov    $0x9,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <dup>:
SYSCALL(dup)
 50a:	b8 0a 00 00 00       	mov    $0xa,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <getpid>:
SYSCALL(getpid)
 512:	b8 0b 00 00 00       	mov    $0xb,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <sbrk>:
SYSCALL(sbrk)
 51a:	b8 0c 00 00 00       	mov    $0xc,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <sleep>:
SYSCALL(sleep)
 522:	b8 0d 00 00 00       	mov    $0xd,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <uptime>:
SYSCALL(uptime)
 52a:	b8 0e 00 00 00       	mov    $0xe,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <shmget>:
SYSCALL(shmget)		//mine
 532:	b8 16 00 00 00       	mov    $0x16,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <shmrem>:
SYSCALL(shmrem)		//mine
 53a:	b8 17 00 00 00       	mov    $0x17,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <sem_init>:
SYSCALL(sem_init)	//mine
 542:	b8 18 00 00 00       	mov    $0x18,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <sem_up>:
SYSCALL(sem_up)		//mine
 54a:	b8 19 00 00 00       	mov    $0x19,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <sem_down>:
SYSCALL(sem_down)	//mine
 552:	b8 1a 00 00 00       	mov    $0x1a,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <isActive>:
 55a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    
 562:	66 90                	xchg   %ax,%ax
 564:	66 90                	xchg   %ax,%ax
 566:	66 90                	xchg   %ax,%ax
 568:	66 90                	xchg   %ax,%ax
 56a:	66 90                	xchg   %ax,%ax
 56c:	66 90                	xchg   %ax,%ax
 56e:	66 90                	xchg   %ax,%ax

00000570 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
 575:	53                   	push   %ebx
 576:	89 c6                	mov    %eax,%esi
 578:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 57b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 57e:	85 db                	test   %ebx,%ebx
 580:	74 7e                	je     600 <printint+0x90>
 582:	89 d0                	mov    %edx,%eax
 584:	c1 e8 1f             	shr    $0x1f,%eax
 587:	84 c0                	test   %al,%al
 589:	74 75                	je     600 <printint+0x90>
    neg = 1;
    x = -xx;
 58b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 58d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 594:	f7 d8                	neg    %eax
 596:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 599:	31 ff                	xor    %edi,%edi
 59b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 59e:	89 ce                	mov    %ecx,%esi
 5a0:	eb 08                	jmp    5aa <printint+0x3a>
 5a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5a8:	89 cf                	mov    %ecx,%edi
 5aa:	31 d2                	xor    %edx,%edx
 5ac:	8d 4f 01             	lea    0x1(%edi),%ecx
 5af:	f7 f6                	div    %esi
 5b1:	0f b6 92 dc 09 00 00 	movzbl 0x9dc(%edx),%edx
  }while((x /= base) != 0);
 5b8:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 5ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 5bd:	75 e9                	jne    5a8 <printint+0x38>
  if(neg)
 5bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5c2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 5c5:	85 c0                	test   %eax,%eax
 5c7:	74 08                	je     5d1 <printint+0x61>
    buf[i++] = '-';
 5c9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 5ce:	8d 4f 02             	lea    0x2(%edi),%ecx
 5d1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 5d5:	8d 76 00             	lea    0x0(%esi),%esi
 5d8:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5db:	83 ec 04             	sub    $0x4,%esp
 5de:	83 ef 01             	sub    $0x1,%edi
 5e1:	6a 01                	push   $0x1
 5e3:	53                   	push   %ebx
 5e4:	56                   	push   %esi
 5e5:	88 45 d7             	mov    %al,-0x29(%ebp)
 5e8:	e8 c5 fe ff ff       	call   4b2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ed:	83 c4 10             	add    $0x10,%esp
 5f0:	39 df                	cmp    %ebx,%edi
 5f2:	75 e4                	jne    5d8 <printint+0x68>
    putc(fd, buf[i]);
}
 5f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f7:	5b                   	pop    %ebx
 5f8:	5e                   	pop    %esi
 5f9:	5f                   	pop    %edi
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret    
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 600:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 602:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 609:	eb 8b                	jmp    596 <printint+0x26>
 60b:	90                   	nop
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000610 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 616:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 619:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 61f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 622:	89 45 d0             	mov    %eax,-0x30(%ebp)
 625:	0f b6 1e             	movzbl (%esi),%ebx
 628:	83 c6 01             	add    $0x1,%esi
 62b:	84 db                	test   %bl,%bl
 62d:	0f 84 b0 00 00 00    	je     6e3 <printf+0xd3>
 633:	31 d2                	xor    %edx,%edx
 635:	eb 39                	jmp    670 <printf+0x60>
 637:	89 f6                	mov    %esi,%esi
 639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 640:	83 f8 25             	cmp    $0x25,%eax
 643:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 646:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 64b:	74 18                	je     665 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 650:	83 ec 04             	sub    $0x4,%esp
 653:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 656:	6a 01                	push   $0x1
 658:	50                   	push   %eax
 659:	57                   	push   %edi
 65a:	e8 53 fe ff ff       	call   4b2 <write>
 65f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 662:	83 c4 10             	add    $0x10,%esp
 665:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 668:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 66c:	84 db                	test   %bl,%bl
 66e:	74 73                	je     6e3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 670:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 672:	0f be cb             	movsbl %bl,%ecx
 675:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 678:	74 c6                	je     640 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 67a:	83 fa 25             	cmp    $0x25,%edx
 67d:	75 e6                	jne    665 <printf+0x55>
      if(c == 'd'){
 67f:	83 f8 64             	cmp    $0x64,%eax
 682:	0f 84 f8 00 00 00    	je     780 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 688:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 68e:	83 f9 70             	cmp    $0x70,%ecx
 691:	74 5d                	je     6f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 693:	83 f8 73             	cmp    $0x73,%eax
 696:	0f 84 84 00 00 00    	je     720 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 69c:	83 f8 63             	cmp    $0x63,%eax
 69f:	0f 84 ea 00 00 00    	je     78f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6a5:	83 f8 25             	cmp    $0x25,%eax
 6a8:	0f 84 c2 00 00 00    	je     770 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ae:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6b1:	83 ec 04             	sub    $0x4,%esp
 6b4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6b8:	6a 01                	push   $0x1
 6ba:	50                   	push   %eax
 6bb:	57                   	push   %edi
 6bc:	e8 f1 fd ff ff       	call   4b2 <write>
 6c1:	83 c4 0c             	add    $0xc,%esp
 6c4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6c7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6ca:	6a 01                	push   $0x1
 6cc:	50                   	push   %eax
 6cd:	57                   	push   %edi
 6ce:	83 c6 01             	add    $0x1,%esi
 6d1:	e8 dc fd ff ff       	call   4b2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6da:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6dd:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6df:	84 db                	test   %bl,%bl
 6e1:	75 8d                	jne    670 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e6:	5b                   	pop    %ebx
 6e7:	5e                   	pop    %esi
 6e8:	5f                   	pop    %edi
 6e9:	5d                   	pop    %ebp
 6ea:	c3                   	ret    
 6eb:	90                   	nop
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6f8:	6a 00                	push   $0x0
 6fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6fd:	89 f8                	mov    %edi,%eax
 6ff:	8b 13                	mov    (%ebx),%edx
 701:	e8 6a fe ff ff       	call   570 <printint>
        ap++;
 706:	89 d8                	mov    %ebx,%eax
 708:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 70b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 70d:	83 c0 04             	add    $0x4,%eax
 710:	89 45 d0             	mov    %eax,-0x30(%ebp)
 713:	e9 4d ff ff ff       	jmp    665 <printf+0x55>
 718:	90                   	nop
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 720:	8b 45 d0             	mov    -0x30(%ebp),%eax
 723:	8b 18                	mov    (%eax),%ebx
        ap++;
 725:	83 c0 04             	add    $0x4,%eax
 728:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 72b:	b8 d2 09 00 00       	mov    $0x9d2,%eax
 730:	85 db                	test   %ebx,%ebx
 732:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 735:	0f b6 03             	movzbl (%ebx),%eax
 738:	84 c0                	test   %al,%al
 73a:	74 23                	je     75f <printf+0x14f>
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 740:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 743:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 746:	83 ec 04             	sub    $0x4,%esp
 749:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 74b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 74e:	50                   	push   %eax
 74f:	57                   	push   %edi
 750:	e8 5d fd ff ff       	call   4b2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 755:	0f b6 03             	movzbl (%ebx),%eax
 758:	83 c4 10             	add    $0x10,%esp
 75b:	84 c0                	test   %al,%al
 75d:	75 e1                	jne    740 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 75f:	31 d2                	xor    %edx,%edx
 761:	e9 ff fe ff ff       	jmp    665 <printf+0x55>
 766:	8d 76 00             	lea    0x0(%esi),%esi
 769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 770:	83 ec 04             	sub    $0x4,%esp
 773:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 776:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 779:	6a 01                	push   $0x1
 77b:	e9 4c ff ff ff       	jmp    6cc <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	b9 0a 00 00 00       	mov    $0xa,%ecx
 788:	6a 01                	push   $0x1
 78a:	e9 6b ff ff ff       	jmp    6fa <printf+0xea>
 78f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 792:	83 ec 04             	sub    $0x4,%esp
 795:	8b 03                	mov    (%ebx),%eax
 797:	6a 01                	push   $0x1
 799:	88 45 e4             	mov    %al,-0x1c(%ebp)
 79c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 79f:	50                   	push   %eax
 7a0:	57                   	push   %edi
 7a1:	e8 0c fd ff ff       	call   4b2 <write>
 7a6:	e9 5b ff ff ff       	jmp    706 <printf+0xf6>
 7ab:	66 90                	xchg   %ax,%ax
 7ad:	66 90                	xchg   %ax,%ax
 7af:	90                   	nop

000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b1:	a1 80 0c 00 00       	mov    0xc80,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b6:	89 e5                	mov    %esp,%ebp
 7b8:	57                   	push   %edi
 7b9:	56                   	push   %esi
 7ba:	53                   	push   %ebx
 7bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c3:	39 c8                	cmp    %ecx,%eax
 7c5:	73 19                	jae    7e0 <free+0x30>
 7c7:	89 f6                	mov    %esi,%esi
 7c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 7d0:	39 d1                	cmp    %edx,%ecx
 7d2:	72 1c                	jb     7f0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	39 d0                	cmp    %edx,%eax
 7d6:	73 18                	jae    7f0 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d8:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7da:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dc:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7de:	72 f0                	jb     7d0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	39 d0                	cmp    %edx,%eax
 7e2:	72 f4                	jb     7d8 <free+0x28>
 7e4:	39 d1                	cmp    %edx,%ecx
 7e6:	73 f0                	jae    7d8 <free+0x28>
 7e8:	90                   	nop
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7f3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7f6:	39 d7                	cmp    %edx,%edi
 7f8:	74 19                	je     813 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7fd:	8b 50 04             	mov    0x4(%eax),%edx
 800:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 803:	39 f1                	cmp    %esi,%ecx
 805:	74 23                	je     82a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 807:	89 08                	mov    %ecx,(%eax)
  freep = p;
 809:	a3 80 0c 00 00       	mov    %eax,0xc80
}
 80e:	5b                   	pop    %ebx
 80f:	5e                   	pop    %esi
 810:	5f                   	pop    %edi
 811:	5d                   	pop    %ebp
 812:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 813:	03 72 04             	add    0x4(%edx),%esi
 816:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 819:	8b 10                	mov    (%eax),%edx
 81b:	8b 12                	mov    (%edx),%edx
 81d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 820:	8b 50 04             	mov    0x4(%eax),%edx
 823:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 826:	39 f1                	cmp    %esi,%ecx
 828:	75 dd                	jne    807 <free+0x57>
    p->s.size += bp->s.size;
 82a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 82d:	a3 80 0c 00 00       	mov    %eax,0xc80
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 832:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 835:	8b 53 f8             	mov    -0x8(%ebx),%edx
 838:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 83a:	5b                   	pop    %ebx
 83b:	5e                   	pop    %esi
 83c:	5f                   	pop    %edi
 83d:	5d                   	pop    %ebp
 83e:	c3                   	ret    
 83f:	90                   	nop

00000840 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	56                   	push   %esi
 845:	53                   	push   %ebx
 846:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 849:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 84c:	8b 15 80 0c 00 00    	mov    0xc80,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 852:	8d 78 07             	lea    0x7(%eax),%edi
 855:	c1 ef 03             	shr    $0x3,%edi
 858:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 85b:	85 d2                	test   %edx,%edx
 85d:	0f 84 a3 00 00 00    	je     906 <malloc+0xc6>
 863:	8b 02                	mov    (%edx),%eax
 865:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 868:	39 cf                	cmp    %ecx,%edi
 86a:	76 74                	jbe    8e0 <malloc+0xa0>
 86c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 872:	be 00 10 00 00       	mov    $0x1000,%esi
 877:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 87e:	0f 43 f7             	cmovae %edi,%esi
 881:	ba 00 80 00 00       	mov    $0x8000,%edx
 886:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 88c:	0f 46 da             	cmovbe %edx,%ebx
 88f:	eb 10                	jmp    8a1 <malloc+0x61>
 891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 89a:	8b 48 04             	mov    0x4(%eax),%ecx
 89d:	39 cf                	cmp    %ecx,%edi
 89f:	76 3f                	jbe    8e0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a1:	39 05 80 0c 00 00    	cmp    %eax,0xc80
 8a7:	89 c2                	mov    %eax,%edx
 8a9:	75 ed                	jne    898 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 8ab:	83 ec 0c             	sub    $0xc,%esp
 8ae:	53                   	push   %ebx
 8af:	e8 66 fc ff ff       	call   51a <sbrk>
  if(p == (char*)-1)
 8b4:	83 c4 10             	add    $0x10,%esp
 8b7:	83 f8 ff             	cmp    $0xffffffff,%eax
 8ba:	74 1c                	je     8d8 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 8bc:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 8bf:	83 ec 0c             	sub    $0xc,%esp
 8c2:	83 c0 08             	add    $0x8,%eax
 8c5:	50                   	push   %eax
 8c6:	e8 e5 fe ff ff       	call   7b0 <free>
  return freep;
 8cb:	8b 15 80 0c 00 00    	mov    0xc80,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 8d1:	83 c4 10             	add    $0x10,%esp
 8d4:	85 d2                	test   %edx,%edx
 8d6:	75 c0                	jne    898 <malloc+0x58>
        return 0;
 8d8:	31 c0                	xor    %eax,%eax
 8da:	eb 1c                	jmp    8f8 <malloc+0xb8>
 8dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 8e0:	39 cf                	cmp    %ecx,%edi
 8e2:	74 1c                	je     900 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 8e4:	29 f9                	sub    %edi,%ecx
 8e6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8e9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8ec:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 8ef:	89 15 80 0c 00 00    	mov    %edx,0xc80
      return (void*)(p + 1);
 8f5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8fb:	5b                   	pop    %ebx
 8fc:	5e                   	pop    %esi
 8fd:	5f                   	pop    %edi
 8fe:	5d                   	pop    %ebp
 8ff:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 900:	8b 08                	mov    (%eax),%ecx
 902:	89 0a                	mov    %ecx,(%edx)
 904:	eb e9                	jmp    8ef <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 906:	c7 05 80 0c 00 00 84 	movl   $0xc84,0xc80
 90d:	0c 00 00 
 910:	c7 05 84 0c 00 00 84 	movl   $0xc84,0xc84
 917:	0c 00 00 
    base.s.size = 0;
 91a:	b8 84 0c 00 00       	mov    $0xc84,%eax
 91f:	c7 05 88 0c 00 00 00 	movl   $0x0,0xc88
 926:	00 00 00 
 929:	e9 3e ff ff ff       	jmp    86c <malloc+0x2c>
