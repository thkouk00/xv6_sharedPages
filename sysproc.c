#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "semaphores.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int 
sys_shmget(void)  //mine
{
  char *key; 
  int temp = argstr(0, &key);
  if (temp <=0 || temp >16)
    return -1;
  return (int)shmget(key);
}

int 
sys_shmrem(void)  //mine
{
  char *key; 
  int temp = argstr(0, &key);
  if (temp <=0 || temp >16)
    return -1;
  return shmrem(key);
}

int
sys_sem_init(void)
{
  sem_t *sem;
  int value;
  if (argptr(0, (char**)&sem, sizeof(sem)) < 0)
    return -1;
  
  if(argint(1, &value) < 0)
    return -1;
  cprintf("sys %x %d\n",(unsigned int) sem,value);
  
  sem->maxval = value;
  sem->value = value;
  sem->lock = 0;
  initlock(&(sem->lk), "sem lock");

  //sem_init(sem,value);
  return 1; //compiler complaining
}

int
sys_sem_up(void)
{
  sem_t *sem;
  if (argptr(0,(char**)&sem, sizeof(sem)) < 0)
    return -1;
  
  if (sem->lock == 1)
  {
    acquire(&(sem->lk));
    sem->value++;
    sem->lock = 0;
    release(&(sem->lk));
    return 1;
  }
  // while(sem->lock == 0)
  //   ;

  //release(&(sem->lk));

  //sem_up(sem);
  return 1; //compiler complaining
}

int
sys_sem_down(void)
{
  sem_t *sem;
  if (argptr(0, (char**)&sem, sizeof(sem)) < 0)
    return -1;
  
  // acquire(&(sem->lk));
  if (sem->lock == 0)
  {
    acquire(&(sem->lk));
    sem->lock = 1;
    sem->value--;
    release(&(sem->lk));
  }
  else
  {
    while(sem->lock == 1)
    {
      ;//cprintf("");
    }  
    // cprintf("WW\n");
    acquire(&(sem->lk));
    sem->lock = 1;
    sem->value--;
    release(&(sem->lk));
  }
  // sem_down(sem);
  return 1; //compiler complaining
}

