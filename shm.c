#include "types.h"
#include "param.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"
#include "spinlock.h"


// functions from vm.c (walkpgdir , mappages)
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

#define SHMEM_PAGES 32
#define MAX_PROC 16

typedef char* sh_key_t;

typedef struct shm_key{
	char shmem_key[MAX_PROC];
}key; 

typedef struct shmem_pinfo{
	void *shmem_addr;
	int shmem_counter;
}shm_info;


typedef struct shm{
  struct spinlock lock;
  shm_info shp_array[SHMEM_PAGES];
  key shp_key[SHMEM_PAGES];
}shm_table;

shm_table sh_table;


void
shmeminit(void)   //preparation for shared pages structure
{
	int i ;
  initlock(&(sh_table.lock), "SHMEM");
  acquire(&(sh_table.lock));
	for (i=0; i<SHMEM_PAGES; i++)
	{
		sh_table.shp_array[i].shmem_counter = 0;
		sh_table.shp_array[i].shmem_addr = 0;
		memset(sh_table.shp_key[i].shmem_key,0,sizeof(char)*16);
	}
  release(&(sh_table.lock));
}

void *
shmget(sh_key_t key)
{
  acquire(&(sh_table.lock));
  
  int i;
	int first_free_addr = -1;
  //search if key is in key table 
  //and search for empty space in case key does not exist
	for (i=0;i<SHMEM_PAGES;i++) 
	{
		if (*sh_table.shp_key[i].shmem_key == 0 && first_free_addr == -1)
		{
      first_free_addr = i;
			continue;
		}

		if (strncmp(sh_table.shp_key[i].shmem_key, key, sizeof(char)*16) == 0 )
		{
			break;
		}
	}
	
	void * temp;
  int pos;
  //if key exists
	if (i<SHMEM_PAGES)
	{
    int y;
    for (y=0;y<SHMEM_PAGES;y++)
    {
      //ask for same page , same process
      if (strncmp(myproc()->p_key[y].keys, key, sizeof(char)*16) == 0)   
      {
        release(&(sh_table.lock));
        return myproc()->vm_shared_page[y];
      }
    }
    //only 16 procs can have access to shared page
		if (sh_table.shp_array[i].shmem_counter < 16)
		{
      pos = find_pos();
      myproc()->top = (void *)(KERNBASE-PGSIZE*(pos+1));
			if ((mappages(myproc()->pgdir, myproc()->top, PGSIZE, V2P(sh_table.shp_array[i].shmem_addr), PTE_W|PTE_U))<0)
				panic("Failed to map page.\n");
			sh_table.shp_array[i].shmem_counter++;
			temp = myproc()->top;
      myproc()->bitmap[pos] = 1;
      myproc()->phy_shared_page[pos] = sh_table.shp_array[i].shmem_addr;
      myproc()->vm_shared_page[pos] = temp;
      memmove(myproc()->p_key[pos].keys, key, strlen(key)); 
      
      release(&(sh_table.lock));
			return temp;
		}
		else
    {
      release(&(sh_table.lock));
			panic("Max processes.\n");
    }
	}
	else   //if key does not exist
	{
		if (first_free_addr == -1) //check if table is full
    { 
			panic("Full shared pages.\n");
    }
    //allocate page
		if ((sh_table.shp_array[first_free_addr].shmem_addr = kalloc()) == 0)
			panic("Failed to allocate.\n");
    //initialize page to zero
		memset(sh_table.shp_array[first_free_addr].shmem_addr, 0, PGSIZE);
    pos = find_pos();
    myproc()->top = (void *)(KERNBASE-PGSIZE*(pos+1));
    //map the page to procs address space
		if ((mappages(myproc()->pgdir, myproc()->top, PGSIZE, V2P(sh_table.shp_array[first_free_addr].shmem_addr), PTE_W|PTE_U))<0)
			panic("Failed to map page.\n"); 
    //store key 
		memmove(sh_table.shp_key[first_free_addr].shmem_key , key, strlen(key)); 
    memmove(myproc()->p_key[pos].keys, key, strlen(key)); 
		sh_table.shp_array[first_free_addr].shmem_counter++;
		temp = myproc()->top;
    myproc()->bitmap[pos] = 1;
    myproc()->phy_shared_page[pos] = sh_table.shp_array[first_free_addr].shmem_addr;
    myproc()->vm_shared_page[pos] = temp;

    release(&(sh_table.lock));
		return temp;    //return virtual address
	}

	return (void *) 0xffffffff;					//Error
}




int
shmrem(sh_key_t key) //na ftiaxv ti epistrefei opos to theloun
{
  int i;
  acquire(&(sh_table.lock));
  //function called from exit()
  //check every shared page in AS
  //check if counter == 1 then free the page
  //else if counter != 1 unmap the page from address space to avoid deletion
  if (memcmp(key, "-1",sizeof(char)*16) == 0 )
  {
    for (i=0;i<SHMEM_PAGES;i++)
    {
      if (myproc()->bitmap[i] == 1)
      {
        int y;
        for (y= 0;y<SHMEM_PAGES;y++)
        {
          if (myproc()->phy_shared_page[i] == sh_table.shp_array[y].shmem_addr)
          {
            if (sh_table.shp_array[y].shmem_counter == 1)
            {
              kfree(sh_table.shp_array[y].shmem_addr);
              sh_table.shp_array[y].shmem_counter = 0;
              sh_table.shp_array[y].shmem_addr = 0;
              memset(sh_table.shp_key[y].shmem_key,0,sizeof(char)*16);
              myproc()->phy_shared_page[i] = 0;
              //find the address of page in AS and set it to Kernbase
              pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[i] , 0);
              *temp = KERNBASE;
            }
            else if (sh_table.shp_array[y].shmem_counter > 1)
            {
              sh_table.shp_array[y].shmem_counter--;
              myproc()->phy_shared_page[i] = 0;
              pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[i] , 0);
              *temp = KERNBASE;
            }
            else if (sh_table.shp_array[y].shmem_counter < 0)
            {
              release(&(sh_table.lock));
              panic("ERROR negative counter %d\n");
              return -1;
            }
          }
        }
      }
    }
    release(&(sh_table.lock));
    return 1;
  }

  //function called from process 
  //check shared page than key indicates to 
  //do same work as above
  for (i=0;i<SHMEM_PAGES;i++)
  {
    if (strncmp(sh_table.shp_key[i].shmem_key, key, sizeof(char)*16) == 0 )
    {
     
      int y;
      for (y=0;y<SHMEM_PAGES;y++)
      {
        if (strncmp(myproc()->p_key[y].keys, key, sizeof(char)*16) == 0 )
        {
          if (sh_table.shp_array[i].shmem_counter == 1)
          {
            kfree(sh_table.shp_array[i].shmem_addr);
            sh_table.shp_array[i].shmem_counter = 0;
            sh_table.shp_array[i].shmem_addr = 0;
            memset(sh_table.shp_key[i].shmem_key,0,sizeof(char)*16);
            pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[y],0);
            *temp = KERNBASE;
            myproc()->vm_shared_page[y] = 0;
            myproc()->phy_shared_page[y] = 0;

            release(&(sh_table.lock));
            return 0;                   // last process for the shared page , return 0 
          }
          else
          {
            sh_table.shp_array[i].shmem_counter--;
            myproc()->phy_shared_page[y] = 0;
            pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[y],0);
            *temp = KERNBASE;
            myproc()->vm_shared_page[y] = 0;
            memset(myproc()->p_key[y].keys,0,sizeof(char)*16);
            release(&(sh_table.lock));
            return 1;
          }
        }
      }
    }
  }
  release(&(sh_table.lock));
  return -1;
}


int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
  {
    if (myproc()->phy_shared_page[i] == 0)
      return i;
  }
  return -1;
}


//copy shared pages for fork , increase page counter

void
manage_fork(struct proc *p,struct proc *c)
{
  int i,y;
  for (i=0;i<SHMEM_PAGES;i++)
  {
    if (p->bitmap[i] == 1 && p->bitmap[i] != c->bitmap[i])
    {
      //map shared page to child process and update info
      if (mappages(c->pgdir, (void*)(KERNBASE-((i+1)*PGSIZE)), PGSIZE, V2P(p->phy_shared_page[i]), PTE_W|PTE_U)<0)
        panic("Manage Fork\n");
      c->phy_shared_page[i] = p->phy_shared_page[i];
      c->vm_shared_page[i] = p->vm_shared_page[i];
      memmove(c->p_key[i].keys, p->p_key[i].keys, sizeof(char)*16);
      c->bitmap[i] = 1;
      for (y=0;y<SHMEM_PAGES;y++)
      {
        if (sh_table.shp_array[y].shmem_addr == c->phy_shared_page[i])
        {
          //increase page counter
          sh_table.shp_array[y].shmem_counter++;
          break; 
        }
      }
    }
  } 
}