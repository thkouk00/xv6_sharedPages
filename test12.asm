
_test12:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "semaphores.h"

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
  11:	83 ec 24             	sub    $0x24,%esp
	char temp1[4];
	int pid;
	sem_t *writers;
	sem_t *readers;
	char *h = shmget("325");
  14:	68 80 08 00 00       	push   $0x880
  19:	e8 64 04 00 00       	call   482 <shmget>
	char *p ;
	writers = (sem_t *)h;
	sem_init(writers, 1);
  1e:	5f                   	pop    %edi
  1f:	5a                   	pop    %edx
  20:	6a 01                	push   $0x1
  22:	50                   	push   %eax
{
	char temp1[4];
	int pid;
	sem_t *writers;
	sem_t *readers;
	char *h = shmget("325");
  23:	89 c3                	mov    %eax,%ebx
	char *p ;
	writers = (sem_t *)h;
	sem_init(writers, 1);
	readers = (sem_t *)(h+sizeof(sem_t));
  25:	8d 73 44             	lea    0x44(%ebx),%esi
	sem_t *writers;
	sem_t *readers;
	char *h = shmget("325");
	char *p ;
	writers = (sem_t *)h;
	sem_init(writers, 1);
  28:	e8 65 04 00 00       	call   492 <sem_init>
	readers = (sem_t *)(h+sizeof(sem_t));
	sem_init(readers, 4);
  2d:	59                   	pop    %ecx
  2e:	5f                   	pop    %edi
  2f:	6a 04                	push   $0x4
  31:	56                   	push   %esi
  32:	e8 5b 04 00 00       	call   492 <sem_init>
	p = h + 2*sizeof(sem_t);
	p[0] = 'A';
  37:	c6 83 88 00 00 00 41 	movb   $0x41,0x88(%ebx)
	p[1] = 'B';
  3e:	c6 83 89 00 00 00 42 	movb   $0x42,0x89(%ebx)
	p[2] = 'C';
  45:	c6 83 8a 00 00 00 43 	movb   $0x43,0x8a(%ebx)
	p[3] = 'D';
  4c:	c6 83 8b 00 00 00 44 	movb   $0x44,0x8b(%ebx)
	pid = fork();
  53:	e8 82 03 00 00       	call   3da <fork>
	//pid = fork();
	if (pid)
  58:	83 c4 10             	add    $0x10,%esp
  5b:	85 c0                	test   %eax,%eax
  5d:	0f 85 85 00 00 00    	jne    e8 <main+0xe8>
		printf(1,"\n");
		sem_up(writers);	
	}
	else
	{	
		while (isActive(writers) || isActive(readers))
  63:	83 ec 0c             	sub    $0xc,%esp
  66:	53                   	push   %ebx
  67:	e8 3e 04 00 00       	call   4aa <isActive>
  6c:	83 c4 10             	add    $0x10,%esp
  6f:	85 c0                	test   %eax,%eax
  71:	75 f0                	jne    63 <main+0x63>
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	56                   	push   %esi
  77:	e8 2e 04 00 00       	call   4aa <isActive>
  7c:	83 c4 10             	add    $0x10,%esp
  7f:	85 c0                	test   %eax,%eax
  81:	75 e0                	jne    63 <main+0x63>
			continue;
		sem_down(writers);
  83:	83 ec 0c             	sub    $0xc,%esp
		printf(1,"Child is Writing\n");
		p[1] = 'W';
		for (int i=0;i<4;i++)
  86:	31 f6                	xor    %esi,%esi
	}
	else
	{	
		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
  88:	53                   	push   %ebx
  89:	e8 14 04 00 00       	call   4a2 <sem_down>
		printf(1,"Child is Writing\n");
  8e:	58                   	pop    %eax
  8f:	5a                   	pop    %edx
  90:	68 9b 08 00 00       	push   $0x89b
  95:	6a 01                	push   $0x1
  97:	e8 c4 04 00 00       	call   560 <printf>
		p[1] = 'W';
  9c:	c6 83 89 00 00 00 57 	movb   $0x57,0x89(%ebx)
  a3:	83 c4 10             	add    $0x10,%esp
		for (int i=0;i<4;i++)
			printf(1,"%c ",p[i]);	
  a6:	0f be 84 33 88 00 00 	movsbl 0x88(%ebx,%esi,1),%eax
  ad:	00 
  ae:	83 ec 04             	sub    $0x4,%esp
		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		printf(1,"Child is Writing\n");
		p[1] = 'W';
		for (int i=0;i<4;i++)
  b1:	83 c6 01             	add    $0x1,%esi
			printf(1,"%c ",p[i]);	
  b4:	50                   	push   %eax
  b5:	68 97 08 00 00       	push   $0x897
  ba:	6a 01                	push   $0x1
  bc:	e8 9f 04 00 00       	call   560 <printf>
		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		printf(1,"Child is Writing\n");
		p[1] = 'W';
		for (int i=0;i<4;i++)
  c1:	83 c4 10             	add    $0x10,%esp
  c4:	83 fe 04             	cmp    $0x4,%esi
  c7:	75 dd                	jne    a6 <main+0xa6>
			printf(1,"%c ",p[i]);	
		printf(1,"\n");
  c9:	83 ec 08             	sub    $0x8,%esp
  cc:	68 ab 08 00 00       	push   $0x8ab
  d1:	6a 01                	push   $0x1
  d3:	e8 88 04 00 00       	call   560 <printf>
		sem_up(writers);
  d8:	89 1c 24             	mov    %ebx,(%esp)
  db:	e8 ba 03 00 00       	call   49a <sem_up>
  e0:	83 c4 10             	add    $0x10,%esp
	}

	exit();	
  e3:	e8 fa 02 00 00       	call   3e2 <exit>
	p[3] = 'D';
	pid = fork();
	//pid = fork();
	if (pid)
	{
		wait();
  e8:	e8 fd 02 00 00       	call   3ea <wait>
		while (isActive(writers))
  ed:	83 ec 0c             	sub    $0xc,%esp
  f0:	53                   	push   %ebx
  f1:	e8 b4 03 00 00       	call   4aa <isActive>
  f6:	83 c4 10             	add    $0x10,%esp
  f9:	85 c0                	test   %eax,%eax
  fb:	75 f0                	jne    ed <main+0xed>
			continue;
		sem_down(readers);
  fd:	83 ec 0c             	sub    $0xc,%esp
 100:	56                   	push   %esi
 101:	e8 9c 03 00 00       	call   4a2 <sem_down>
 106:	83 c4 10             	add    $0x10,%esp
		for (int i=0;i<4;i++)
 109:	31 c0                	xor    %eax,%eax
			temp1[i] = p[i];
 10b:	0f b6 94 03 88 00 00 	movzbl 0x88(%ebx,%eax,1),%edx
 112:	00 
	{
		wait();
		while (isActive(writers))
			continue;
		sem_down(readers);
		for (int i=0;i<4;i++)
 113:	83 c0 01             	add    $0x1,%eax
			temp1[i] = p[i];
 116:	88 54 28 e3          	mov    %dl,-0x1d(%eax,%ebp,1)
	{
		wait();
		while (isActive(writers))
			continue;
		sem_down(readers);
		for (int i=0;i<4;i++)
 11a:	83 f8 04             	cmp    $0x4,%eax
 11d:	75 ec                	jne    10b <main+0x10b>
			temp1[i] = p[i];
		sem_up(readers);
 11f:	83 ec 0c             	sub    $0xc,%esp
 122:	56                   	push   %esi
 123:	e8 72 03 00 00       	call   49a <sem_up>
		

		while (isActive(writers) || isActive(readers))
 128:	83 c4 10             	add    $0x10,%esp
 12b:	83 ec 0c             	sub    $0xc,%esp
 12e:	53                   	push   %ebx
 12f:	e8 76 03 00 00       	call   4aa <isActive>
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	75 f0                	jne    12b <main+0x12b>
 13b:	83 ec 0c             	sub    $0xc,%esp
 13e:	56                   	push   %esi
 13f:	e8 66 03 00 00       	call   4aa <isActive>
 144:	83 c4 10             	add    $0x10,%esp
 147:	85 c0                	test   %eax,%eax
 149:	75 e0                	jne    12b <main+0x12b>
			continue;
		sem_down(writers);
 14b:	83 ec 0c             	sub    $0xc,%esp
		printf(1,"Parent is Writing\n");
		for (int i=0;i<4;i++)
 14e:	31 ff                	xor    %edi,%edi
		sem_up(readers);
		

		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
 150:	53                   	push   %ebx
 151:	e8 4c 03 00 00       	call   4a2 <sem_down>
		printf(1,"Parent is Writing\n");
 156:	59                   	pop    %ecx
 157:	5e                   	pop    %esi
 158:	68 84 08 00 00       	push   $0x884
 15d:	6a 01                	push   $0x1
 15f:	8d 75 e4             	lea    -0x1c(%ebp),%esi
 162:	e8 f9 03 00 00       	call   560 <printf>
 167:	83 c4 10             	add    $0x10,%esp
		for (int i=0;i<4;i++)
		{
			p[i] = temp1[3-i];
 16a:	0f be 46 03          	movsbl 0x3(%esi),%eax
			printf(1,"%c ",p[i]);
 16e:	83 ec 04             	sub    $0x4,%esp
 171:	83 ee 01             	sub    $0x1,%esi
			continue;
		sem_down(writers);
		printf(1,"Parent is Writing\n");
		for (int i=0;i<4;i++)
		{
			p[i] = temp1[3-i];
 174:	88 84 3b 88 00 00 00 	mov    %al,0x88(%ebx,%edi,1)
			printf(1,"%c ",p[i]);
 17b:	50                   	push   %eax

		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		printf(1,"Parent is Writing\n");
		for (int i=0;i<4;i++)
 17c:	83 c7 01             	add    $0x1,%edi
		{
			p[i] = temp1[3-i];
			printf(1,"%c ",p[i]);
 17f:	68 97 08 00 00       	push   $0x897
 184:	6a 01                	push   $0x1
 186:	e8 d5 03 00 00       	call   560 <printf>

		while (isActive(writers) || isActive(readers))
			continue;
		sem_down(writers);
		printf(1,"Parent is Writing\n");
		for (int i=0;i<4;i++)
 18b:	83 c4 10             	add    $0x10,%esp
 18e:	83 ff 04             	cmp    $0x4,%edi
 191:	75 d7                	jne    16a <main+0x16a>
 193:	e9 31 ff ff ff       	jmp    c9 <main+0xc9>
 198:	66 90                	xchg   %ax,%ax
 19a:	66 90                	xchg   %ax,%ax
 19c:	66 90                	xchg   %ax,%ax
 19e:	66 90                	xchg   %ax,%ax

000001a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1aa:	89 c2                	mov    %eax,%edx
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1b0:	83 c1 01             	add    $0x1,%ecx
 1b3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1b7:	83 c2 01             	add    $0x1,%edx
 1ba:	84 db                	test   %bl,%bl
 1bc:	88 5a ff             	mov    %bl,-0x1(%edx)
 1bf:	75 ef                	jne    1b0 <strcpy+0x10>
    ;
  return os;
}
 1c1:	5b                   	pop    %ebx
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    
 1c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	56                   	push   %esi
 1d4:	53                   	push   %ebx
 1d5:	8b 55 08             	mov    0x8(%ebp),%edx
 1d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1db:	0f b6 02             	movzbl (%edx),%eax
 1de:	0f b6 19             	movzbl (%ecx),%ebx
 1e1:	84 c0                	test   %al,%al
 1e3:	75 1e                	jne    203 <strcmp+0x33>
 1e5:	eb 29                	jmp    210 <strcmp+0x40>
 1e7:	89 f6                	mov    %esi,%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 1f0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1f3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1f6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1f9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1fd:	84 c0                	test   %al,%al
 1ff:	74 0f                	je     210 <strcmp+0x40>
 201:	89 f1                	mov    %esi,%ecx
 203:	38 d8                	cmp    %bl,%al
 205:	74 e9                	je     1f0 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 207:	29 d8                	sub    %ebx,%eax
}
 209:	5b                   	pop    %ebx
 20a:	5e                   	pop    %esi
 20b:	5d                   	pop    %ebp
 20c:	c3                   	ret    
 20d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 210:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 212:	29 d8                	sub    %ebx,%eax
}
 214:	5b                   	pop    %ebx
 215:	5e                   	pop    %esi
 216:	5d                   	pop    %ebp
 217:	c3                   	ret    
 218:	90                   	nop
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000220 <strlen>:

uint
strlen(char *s)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 226:	80 39 00             	cmpb   $0x0,(%ecx)
 229:	74 12                	je     23d <strlen+0x1d>
 22b:	31 d2                	xor    %edx,%edx
 22d:	8d 76 00             	lea    0x0(%esi),%esi
 230:	83 c2 01             	add    $0x1,%edx
 233:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 237:	89 d0                	mov    %edx,%eax
 239:	75 f5                	jne    230 <strlen+0x10>
    ;
  return n;
}
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 23d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 23f:	5d                   	pop    %ebp
 240:	c3                   	ret    
 241:	eb 0d                	jmp    250 <memset>
 243:	90                   	nop
 244:	90                   	nop
 245:	90                   	nop
 246:	90                   	nop
 247:	90                   	nop
 248:	90                   	nop
 249:	90                   	nop
 24a:	90                   	nop
 24b:	90                   	nop
 24c:	90                   	nop
 24d:	90                   	nop
 24e:	90                   	nop
 24f:	90                   	nop

00000250 <memset>:

void*
memset(void *dst, int c, uint n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 257:	8b 4d 10             	mov    0x10(%ebp),%ecx
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	89 d7                	mov    %edx,%edi
 25f:	fc                   	cld    
 260:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 262:	89 d0                	mov    %edx,%eax
 264:	5f                   	pop    %edi
 265:	5d                   	pop    %ebp
 266:	c3                   	ret    
 267:	89 f6                	mov    %esi,%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 27a:	0f b6 10             	movzbl (%eax),%edx
 27d:	84 d2                	test   %dl,%dl
 27f:	74 1d                	je     29e <strchr+0x2e>
    if(*s == c)
 281:	38 d3                	cmp    %dl,%bl
 283:	89 d9                	mov    %ebx,%ecx
 285:	75 0d                	jne    294 <strchr+0x24>
 287:	eb 17                	jmp    2a0 <strchr+0x30>
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 290:	38 ca                	cmp    %cl,%dl
 292:	74 0c                	je     2a0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 294:	83 c0 01             	add    $0x1,%eax
 297:	0f b6 10             	movzbl (%eax),%edx
 29a:	84 d2                	test   %dl,%dl
 29c:	75 f2                	jne    290 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 29e:	31 c0                	xor    %eax,%eax
}
 2a0:	5b                   	pop    %ebx
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret    
 2a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <gets>:

char*
gets(char *buf, int max)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
 2b5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 2b8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 2bb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2be:	eb 29                	jmp    2e9 <gets+0x39>
    cc = read(0, &c, 1);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	6a 01                	push   $0x1
 2c5:	57                   	push   %edi
 2c6:	6a 00                	push   $0x0
 2c8:	e8 2d 01 00 00       	call   3fa <read>
    if(cc < 1)
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	85 c0                	test   %eax,%eax
 2d2:	7e 1d                	jle    2f1 <gets+0x41>
      break;
    buf[i++] = c;
 2d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2d8:	8b 55 08             	mov    0x8(%ebp),%edx
 2db:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 2dd:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 2df:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2e3:	74 1b                	je     300 <gets+0x50>
 2e5:	3c 0d                	cmp    $0xd,%al
 2e7:	74 17                	je     300 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e9:	8d 5e 01             	lea    0x1(%esi),%ebx
 2ec:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ef:	7c cf                	jl     2c0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2fb:	5b                   	pop    %ebx
 2fc:	5e                   	pop    %esi
 2fd:	5f                   	pop    %edi
 2fe:	5d                   	pop    %ebp
 2ff:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 300:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 303:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 305:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 309:	8d 65 f4             	lea    -0xc(%ebp),%esp
 30c:	5b                   	pop    %ebx
 30d:	5e                   	pop    %esi
 30e:	5f                   	pop    %edi
 30f:	5d                   	pop    %ebp
 310:	c3                   	ret    
 311:	eb 0d                	jmp    320 <stat>
 313:	90                   	nop
 314:	90                   	nop
 315:	90                   	nop
 316:	90                   	nop
 317:	90                   	nop
 318:	90                   	nop
 319:	90                   	nop
 31a:	90                   	nop
 31b:	90                   	nop
 31c:	90                   	nop
 31d:	90                   	nop
 31e:	90                   	nop
 31f:	90                   	nop

00000320 <stat>:

int
stat(char *n, struct stat *st)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 325:	83 ec 08             	sub    $0x8,%esp
 328:	6a 00                	push   $0x0
 32a:	ff 75 08             	pushl  0x8(%ebp)
 32d:	e8 f0 00 00 00       	call   422 <open>
  if(fd < 0)
 332:	83 c4 10             	add    $0x10,%esp
 335:	85 c0                	test   %eax,%eax
 337:	78 27                	js     360 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 339:	83 ec 08             	sub    $0x8,%esp
 33c:	ff 75 0c             	pushl  0xc(%ebp)
 33f:	89 c3                	mov    %eax,%ebx
 341:	50                   	push   %eax
 342:	e8 f3 00 00 00       	call   43a <fstat>
 347:	89 c6                	mov    %eax,%esi
  close(fd);
 349:	89 1c 24             	mov    %ebx,(%esp)
 34c:	e8 b9 00 00 00       	call   40a <close>
  return r;
 351:	83 c4 10             	add    $0x10,%esp
 354:	89 f0                	mov    %esi,%eax
}
 356:	8d 65 f8             	lea    -0x8(%ebp),%esp
 359:	5b                   	pop    %ebx
 35a:	5e                   	pop    %esi
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    
 35d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 365:	eb ef                	jmp    356 <stat+0x36>
 367:	89 f6                	mov    %esi,%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 377:	0f be 11             	movsbl (%ecx),%edx
 37a:	8d 42 d0             	lea    -0x30(%edx),%eax
 37d:	3c 09                	cmp    $0x9,%al
 37f:	b8 00 00 00 00       	mov    $0x0,%eax
 384:	77 1f                	ja     3a5 <atoi+0x35>
 386:	8d 76 00             	lea    0x0(%esi),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 390:	8d 04 80             	lea    (%eax,%eax,4),%eax
 393:	83 c1 01             	add    $0x1,%ecx
 396:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 39a:	0f be 11             	movsbl (%ecx),%edx
 39d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3a0:	80 fb 09             	cmp    $0x9,%bl
 3a3:	76 eb                	jbe    390 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 3a5:	5b                   	pop    %ebx
 3a6:	5d                   	pop    %ebp
 3a7:	c3                   	ret    
 3a8:	90                   	nop
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	56                   	push   %esi
 3b4:	53                   	push   %ebx
 3b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3be:	85 db                	test   %ebx,%ebx
 3c0:	7e 14                	jle    3d6 <memmove+0x26>
 3c2:	31 d2                	xor    %edx,%edx
 3c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3cf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3d2:	39 da                	cmp    %ebx,%edx
 3d4:	75 f2                	jne    3c8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 3d6:	5b                   	pop    %ebx
 3d7:	5e                   	pop    %esi
 3d8:	5d                   	pop    %ebp
 3d9:	c3                   	ret    

000003da <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3da:	b8 01 00 00 00       	mov    $0x1,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <exit>:
SYSCALL(exit)
 3e2:	b8 02 00 00 00       	mov    $0x2,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <wait>:
SYSCALL(wait)
 3ea:	b8 03 00 00 00       	mov    $0x3,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <pipe>:
SYSCALL(pipe)
 3f2:	b8 04 00 00 00       	mov    $0x4,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <read>:
SYSCALL(read)
 3fa:	b8 05 00 00 00       	mov    $0x5,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <write>:
SYSCALL(write)
 402:	b8 10 00 00 00       	mov    $0x10,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <close>:
SYSCALL(close)
 40a:	b8 15 00 00 00       	mov    $0x15,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <kill>:
SYSCALL(kill)
 412:	b8 06 00 00 00       	mov    $0x6,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <exec>:
SYSCALL(exec)
 41a:	b8 07 00 00 00       	mov    $0x7,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <open>:
SYSCALL(open)
 422:	b8 0f 00 00 00       	mov    $0xf,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <mknod>:
SYSCALL(mknod)
 42a:	b8 11 00 00 00       	mov    $0x11,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <unlink>:
SYSCALL(unlink)
 432:	b8 12 00 00 00       	mov    $0x12,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <fstat>:
SYSCALL(fstat)
 43a:	b8 08 00 00 00       	mov    $0x8,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <link>:
SYSCALL(link)
 442:	b8 13 00 00 00       	mov    $0x13,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <mkdir>:
SYSCALL(mkdir)
 44a:	b8 14 00 00 00       	mov    $0x14,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <chdir>:
SYSCALL(chdir)
 452:	b8 09 00 00 00       	mov    $0x9,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <dup>:
SYSCALL(dup)
 45a:	b8 0a 00 00 00       	mov    $0xa,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <getpid>:
SYSCALL(getpid)
 462:	b8 0b 00 00 00       	mov    $0xb,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <sbrk>:
SYSCALL(sbrk)
 46a:	b8 0c 00 00 00       	mov    $0xc,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <sleep>:
SYSCALL(sleep)
 472:	b8 0d 00 00 00       	mov    $0xd,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <uptime>:
SYSCALL(uptime)
 47a:	b8 0e 00 00 00       	mov    $0xe,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <shmget>:
SYSCALL(shmget)		//mine
 482:	b8 16 00 00 00       	mov    $0x16,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <shmrem>:
SYSCALL(shmrem)		//mine
 48a:	b8 17 00 00 00       	mov    $0x17,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <sem_init>:
SYSCALL(sem_init)	//mine
 492:	b8 18 00 00 00       	mov    $0x18,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <sem_up>:
SYSCALL(sem_up)		//mine
 49a:	b8 19 00 00 00       	mov    $0x19,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <sem_down>:
SYSCALL(sem_down)	//mine
 4a2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <isActive>:
 4aa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    
 4b2:	66 90                	xchg   %ax,%ax
 4b4:	66 90                	xchg   %ax,%ax
 4b6:	66 90                	xchg   %ax,%ax
 4b8:	66 90                	xchg   %ax,%ax
 4ba:	66 90                	xchg   %ax,%ax
 4bc:	66 90                	xchg   %ax,%ax
 4be:	66 90                	xchg   %ax,%ax

000004c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	53                   	push   %ebx
 4c6:	89 c6                	mov    %eax,%esi
 4c8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4ce:	85 db                	test   %ebx,%ebx
 4d0:	74 7e                	je     550 <printint+0x90>
 4d2:	89 d0                	mov    %edx,%eax
 4d4:	c1 e8 1f             	shr    $0x1f,%eax
 4d7:	84 c0                	test   %al,%al
 4d9:	74 75                	je     550 <printint+0x90>
    neg = 1;
    x = -xx;
 4db:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 4dd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 4e4:	f7 d8                	neg    %eax
 4e6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4e9:	31 ff                	xor    %edi,%edi
 4eb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 4ee:	89 ce                	mov    %ecx,%esi
 4f0:	eb 08                	jmp    4fa <printint+0x3a>
 4f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4f8:	89 cf                	mov    %ecx,%edi
 4fa:	31 d2                	xor    %edx,%edx
 4fc:	8d 4f 01             	lea    0x1(%edi),%ecx
 4ff:	f7 f6                	div    %esi
 501:	0f b6 92 b4 08 00 00 	movzbl 0x8b4(%edx),%edx
  }while((x /= base) != 0);
 508:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 50a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 50d:	75 e9                	jne    4f8 <printint+0x38>
  if(neg)
 50f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 512:	8b 75 c0             	mov    -0x40(%ebp),%esi
 515:	85 c0                	test   %eax,%eax
 517:	74 08                	je     521 <printint+0x61>
    buf[i++] = '-';
 519:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 51e:	8d 4f 02             	lea    0x2(%edi),%ecx
 521:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 525:	8d 76 00             	lea    0x0(%esi),%esi
 528:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 52b:	83 ec 04             	sub    $0x4,%esp
 52e:	83 ef 01             	sub    $0x1,%edi
 531:	6a 01                	push   $0x1
 533:	53                   	push   %ebx
 534:	56                   	push   %esi
 535:	88 45 d7             	mov    %al,-0x29(%ebp)
 538:	e8 c5 fe ff ff       	call   402 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 53d:	83 c4 10             	add    $0x10,%esp
 540:	39 df                	cmp    %ebx,%edi
 542:	75 e4                	jne    528 <printint+0x68>
    putc(fd, buf[i]);
}
 544:	8d 65 f4             	lea    -0xc(%ebp),%esp
 547:	5b                   	pop    %ebx
 548:	5e                   	pop    %esi
 549:	5f                   	pop    %edi
 54a:	5d                   	pop    %ebp
 54b:	c3                   	ret    
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 550:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 552:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 559:	eb 8b                	jmp    4e6 <printint+0x26>
 55b:	90                   	nop
 55c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000560 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 566:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 569:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 56c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 56f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 572:	89 45 d0             	mov    %eax,-0x30(%ebp)
 575:	0f b6 1e             	movzbl (%esi),%ebx
 578:	83 c6 01             	add    $0x1,%esi
 57b:	84 db                	test   %bl,%bl
 57d:	0f 84 b0 00 00 00    	je     633 <printf+0xd3>
 583:	31 d2                	xor    %edx,%edx
 585:	eb 39                	jmp    5c0 <printf+0x60>
 587:	89 f6                	mov    %esi,%esi
 589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 590:	83 f8 25             	cmp    $0x25,%eax
 593:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 596:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 59b:	74 18                	je     5b5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 59d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5a0:	83 ec 04             	sub    $0x4,%esp
 5a3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5a6:	6a 01                	push   $0x1
 5a8:	50                   	push   %eax
 5a9:	57                   	push   %edi
 5aa:	e8 53 fe ff ff       	call   402 <write>
 5af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5b2:	83 c4 10             	add    $0x10,%esp
 5b5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5bc:	84 db                	test   %bl,%bl
 5be:	74 73                	je     633 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 5c0:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 5c2:	0f be cb             	movsbl %bl,%ecx
 5c5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5c8:	74 c6                	je     590 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ca:	83 fa 25             	cmp    $0x25,%edx
 5cd:	75 e6                	jne    5b5 <printf+0x55>
      if(c == 'd'){
 5cf:	83 f8 64             	cmp    $0x64,%eax
 5d2:	0f 84 f8 00 00 00    	je     6d0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5d8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5de:	83 f9 70             	cmp    $0x70,%ecx
 5e1:	74 5d                	je     640 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5e3:	83 f8 73             	cmp    $0x73,%eax
 5e6:	0f 84 84 00 00 00    	je     670 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ec:	83 f8 63             	cmp    $0x63,%eax
 5ef:	0f 84 ea 00 00 00    	je     6df <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5f5:	83 f8 25             	cmp    $0x25,%eax
 5f8:	0f 84 c2 00 00 00    	je     6c0 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5fe:	8d 45 e7             	lea    -0x19(%ebp),%eax
 601:	83 ec 04             	sub    $0x4,%esp
 604:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 608:	6a 01                	push   $0x1
 60a:	50                   	push   %eax
 60b:	57                   	push   %edi
 60c:	e8 f1 fd ff ff       	call   402 <write>
 611:	83 c4 0c             	add    $0xc,%esp
 614:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 617:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 61a:	6a 01                	push   $0x1
 61c:	50                   	push   %eax
 61d:	57                   	push   %edi
 61e:	83 c6 01             	add    $0x1,%esi
 621:	e8 dc fd ff ff       	call   402 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 626:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 62a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 62d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 62f:	84 db                	test   %bl,%bl
 631:	75 8d                	jne    5c0 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 633:	8d 65 f4             	lea    -0xc(%ebp),%esp
 636:	5b                   	pop    %ebx
 637:	5e                   	pop    %esi
 638:	5f                   	pop    %edi
 639:	5d                   	pop    %ebp
 63a:	c3                   	ret    
 63b:	90                   	nop
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 640:	83 ec 0c             	sub    $0xc,%esp
 643:	b9 10 00 00 00       	mov    $0x10,%ecx
 648:	6a 00                	push   $0x0
 64a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 64d:	89 f8                	mov    %edi,%eax
 64f:	8b 13                	mov    (%ebx),%edx
 651:	e8 6a fe ff ff       	call   4c0 <printint>
        ap++;
 656:	89 d8                	mov    %ebx,%eax
 658:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 65b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 65d:	83 c0 04             	add    $0x4,%eax
 660:	89 45 d0             	mov    %eax,-0x30(%ebp)
 663:	e9 4d ff ff ff       	jmp    5b5 <printf+0x55>
 668:	90                   	nop
 669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 670:	8b 45 d0             	mov    -0x30(%ebp),%eax
 673:	8b 18                	mov    (%eax),%ebx
        ap++;
 675:	83 c0 04             	add    $0x4,%eax
 678:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 67b:	b8 ad 08 00 00       	mov    $0x8ad,%eax
 680:	85 db                	test   %ebx,%ebx
 682:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 685:	0f b6 03             	movzbl (%ebx),%eax
 688:	84 c0                	test   %al,%al
 68a:	74 23                	je     6af <printf+0x14f>
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 690:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 693:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 696:	83 ec 04             	sub    $0x4,%esp
 699:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 69b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 69e:	50                   	push   %eax
 69f:	57                   	push   %edi
 6a0:	e8 5d fd ff ff       	call   402 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6a5:	0f b6 03             	movzbl (%ebx),%eax
 6a8:	83 c4 10             	add    $0x10,%esp
 6ab:	84 c0                	test   %al,%al
 6ad:	75 e1                	jne    690 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6af:	31 d2                	xor    %edx,%edx
 6b1:	e9 ff fe ff ff       	jmp    5b5 <printf+0x55>
 6b6:	8d 76 00             	lea    0x0(%esi),%esi
 6b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6c0:	83 ec 04             	sub    $0x4,%esp
 6c3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 6c6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6c9:	6a 01                	push   $0x1
 6cb:	e9 4c ff ff ff       	jmp    61c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6d0:	83 ec 0c             	sub    $0xc,%esp
 6d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6d8:	6a 01                	push   $0x1
 6da:	e9 6b ff ff ff       	jmp    64a <printf+0xea>
 6df:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6e2:	83 ec 04             	sub    $0x4,%esp
 6e5:	8b 03                	mov    (%ebx),%eax
 6e7:	6a 01                	push   $0x1
 6e9:	88 45 e4             	mov    %al,-0x1c(%ebp)
 6ec:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6ef:	50                   	push   %eax
 6f0:	57                   	push   %edi
 6f1:	e8 0c fd ff ff       	call   402 <write>
 6f6:	e9 5b ff ff ff       	jmp    656 <printf+0xf6>
 6fb:	66 90                	xchg   %ax,%ax
 6fd:	66 90                	xchg   %ax,%ax
 6ff:	90                   	nop

00000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	a1 58 0b 00 00       	mov    0xb58,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 706:	89 e5                	mov    %esp,%ebp
 708:	57                   	push   %edi
 709:	56                   	push   %esi
 70a:	53                   	push   %ebx
 70b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 710:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 713:	39 c8                	cmp    %ecx,%eax
 715:	73 19                	jae    730 <free+0x30>
 717:	89 f6                	mov    %esi,%esi
 719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 720:	39 d1                	cmp    %edx,%ecx
 722:	72 1c                	jb     740 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	39 d0                	cmp    %edx,%eax
 726:	73 18                	jae    740 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 728:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72e:	72 f0                	jb     720 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	39 d0                	cmp    %edx,%eax
 732:	72 f4                	jb     728 <free+0x28>
 734:	39 d1                	cmp    %edx,%ecx
 736:	73 f0                	jae    728 <free+0x28>
 738:	90                   	nop
 739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 740:	8b 73 fc             	mov    -0x4(%ebx),%esi
 743:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 746:	39 d7                	cmp    %edx,%edi
 748:	74 19                	je     763 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 74a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 74d:	8b 50 04             	mov    0x4(%eax),%edx
 750:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 753:	39 f1                	cmp    %esi,%ecx
 755:	74 23                	je     77a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 757:	89 08                	mov    %ecx,(%eax)
  freep = p;
 759:	a3 58 0b 00 00       	mov    %eax,0xb58
}
 75e:	5b                   	pop    %ebx
 75f:	5e                   	pop    %esi
 760:	5f                   	pop    %edi
 761:	5d                   	pop    %ebp
 762:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 763:	03 72 04             	add    0x4(%edx),%esi
 766:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 769:	8b 10                	mov    (%eax),%edx
 76b:	8b 12                	mov    (%edx),%edx
 76d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 770:	8b 50 04             	mov    0x4(%eax),%edx
 773:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 776:	39 f1                	cmp    %esi,%ecx
 778:	75 dd                	jne    757 <free+0x57>
    p->s.size += bp->s.size;
 77a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 77d:	a3 58 0b 00 00       	mov    %eax,0xb58
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 782:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 785:	8b 53 f8             	mov    -0x8(%ebx),%edx
 788:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 78a:	5b                   	pop    %ebx
 78b:	5e                   	pop    %esi
 78c:	5f                   	pop    %edi
 78d:	5d                   	pop    %ebp
 78e:	c3                   	ret    
 78f:	90                   	nop

00000790 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
 796:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 799:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 79c:	8b 15 58 0b 00 00    	mov    0xb58,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a2:	8d 78 07             	lea    0x7(%eax),%edi
 7a5:	c1 ef 03             	shr    $0x3,%edi
 7a8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7ab:	85 d2                	test   %edx,%edx
 7ad:	0f 84 a3 00 00 00    	je     856 <malloc+0xc6>
 7b3:	8b 02                	mov    (%edx),%eax
 7b5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7b8:	39 cf                	cmp    %ecx,%edi
 7ba:	76 74                	jbe    830 <malloc+0xa0>
 7bc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 7c2:	be 00 10 00 00       	mov    $0x1000,%esi
 7c7:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 7ce:	0f 43 f7             	cmovae %edi,%esi
 7d1:	ba 00 80 00 00       	mov    $0x8000,%edx
 7d6:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 7dc:	0f 46 da             	cmovbe %edx,%ebx
 7df:	eb 10                	jmp    7f1 <malloc+0x61>
 7e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7ea:	8b 48 04             	mov    0x4(%eax),%ecx
 7ed:	39 cf                	cmp    %ecx,%edi
 7ef:	76 3f                	jbe    830 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f1:	39 05 58 0b 00 00    	cmp    %eax,0xb58
 7f7:	89 c2                	mov    %eax,%edx
 7f9:	75 ed                	jne    7e8 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	53                   	push   %ebx
 7ff:	e8 66 fc ff ff       	call   46a <sbrk>
  if(p == (char*)-1)
 804:	83 c4 10             	add    $0x10,%esp
 807:	83 f8 ff             	cmp    $0xffffffff,%eax
 80a:	74 1c                	je     828 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 80c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 80f:	83 ec 0c             	sub    $0xc,%esp
 812:	83 c0 08             	add    $0x8,%eax
 815:	50                   	push   %eax
 816:	e8 e5 fe ff ff       	call   700 <free>
  return freep;
 81b:	8b 15 58 0b 00 00    	mov    0xb58,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 821:	83 c4 10             	add    $0x10,%esp
 824:	85 d2                	test   %edx,%edx
 826:	75 c0                	jne    7e8 <malloc+0x58>
        return 0;
 828:	31 c0                	xor    %eax,%eax
 82a:	eb 1c                	jmp    848 <malloc+0xb8>
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 830:	39 cf                	cmp    %ecx,%edi
 832:	74 1c                	je     850 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 834:	29 f9                	sub    %edi,%ecx
 836:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 839:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 83c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 83f:	89 15 58 0b 00 00    	mov    %edx,0xb58
      return (void*)(p + 1);
 845:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 848:	8d 65 f4             	lea    -0xc(%ebp),%esp
 84b:	5b                   	pop    %ebx
 84c:	5e                   	pop    %esi
 84d:	5f                   	pop    %edi
 84e:	5d                   	pop    %ebp
 84f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 850:	8b 08                	mov    (%eax),%ecx
 852:	89 0a                	mov    %ecx,(%edx)
 854:	eb e9                	jmp    83f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 856:	c7 05 58 0b 00 00 5c 	movl   $0xb5c,0xb58
 85d:	0b 00 00 
 860:	c7 05 5c 0b 00 00 5c 	movl   $0xb5c,0xb5c
 867:	0b 00 00 
    base.s.size = 0;
 86a:	b8 5c 0b 00 00       	mov    $0xb5c,%eax
 86f:	c7 05 60 0b 00 00 00 	movl   $0x0,0xb60
 876:	00 00 00 
 879:	e9 3e ff ff ff       	jmp    7bc <malloc+0x2c>
