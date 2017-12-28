
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 2e 10 80       	mov    $0x80102e60,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 60 79 10 80       	push   $0x80107960
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 f5 41 00 00       	call   80104250 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 79 10 80       	push   $0x80107967
80100097:	50                   	push   %eax
80100098:	e8 a3 40 00 00       	call   80104140 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 67 42 00 00       	call   80104350 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 09 43 00 00       	call   80104470 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 40 00 00       	call   80104180 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 1f 00 00       	call   801020f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 6e 79 10 80       	push   $0x8010796e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 6d 40 00 00       	call   80104220 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 27 1f 00 00       	jmp    801020f0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 79 10 80       	push   $0x8010797f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 2c 40 00 00       	call   80104220 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 3f 00 00       	call   801041e0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 40 41 00 00       	call   80104350 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 0f 42 00 00       	jmp    80104470 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 79 10 80       	push   $0x80107986
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 cb 14 00 00       	call   80101750 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 bf 40 00 00       	call   80104350 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002a6:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 a0 0f 11 80       	push   $0x80110fa0
801002bd:	e8 0e 3b 00 00       	call   80103dd0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 29 35 00 00       	call   80103800 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 85 41 00 00       	call   80104470 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 7d 13 00 00       	call   80101670 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 25 41 00 00       	call   80104470 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 1d 13 00 00       	call   80101670 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 62 23 00 00       	call   801026f0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 8d 79 10 80       	push   $0x8010798d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 56 84 10 80 	movl   $0x80108456,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 b3 3e 00 00       	call   80104270 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 a1 79 10 80       	push   $0x801079a1
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 91 57 00 00       	call   80105bb0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 d8 56 00 00       	call   80105bb0 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 cc 56 00 00       	call   80105bb0 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 c0 56 00 00       	call   80105bb0 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 57 40 00 00       	call   80104570 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 92 3f 00 00       	call   801044c0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 a5 79 10 80       	push   $0x801079a5
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 d0 79 10 80 	movzbl -0x7fef8630(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 3c 11 00 00       	call   80101750 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 30 3d 00 00       	call   80104350 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 24 3e 00 00       	call   80104470 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 10 00 00       	call   80101670 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 5e 3d 00 00       	call   80104470 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 b8 79 10 80       	mov    $0x801079b8,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 83 3b 00 00       	call   80104350 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 bf 79 10 80       	push   $0x801079bf
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 48 3b 00 00       	call   80104350 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100836:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 03 3c 00 00       	call   80104470 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801008f1:	68 a0 0f 11 80       	push   $0x80110fa0
801008f6:	e8 95 36 00 00       	call   80103f90 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010090d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100934:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 04 37 00 00       	jmp    80104080 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 c8 79 10 80       	push   $0x801079c8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 9b 38 00 00       	call   80104250 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 c2 18 00 00       	call   801022a0 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 ff 2d 00 00       	call   80103800 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 44 21 00 00       	call   80102b50 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 a9 14 00 00       	call   80101ec0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 43 0c 00 00       	call   80101670 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 12 0f 00 00       	call   80101950 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 b1 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a4f:	e8 6c 21 00 00       	call   80102bc0 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 c7 62 00 00       	call   80106d40 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 83 0e 00 00       	call   80101950 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 87 60 00 00       	call   80106b90 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 91 5f 00 00       	call   80106ad0 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 62 61 00 00       	call   80106cc0 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 91 0d 00 00       	call   80101900 <iunlockput>
  end_op();
80100b6f:	e8 4c 20 00 00       	call   80102bc0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 f6 5f 00 00       	call   80106b90 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 0f 61 00 00       	call   80106cc0 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 fd 1f 00 00       	call   80102bc0 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 e1 79 10 80       	push   $0x801079e1
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 ea 61 00 00       	call   80106de0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 ce 3a 00 00       	call   80104700 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 bb 3a 00 00       	call   80104700 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 ea 62 00 00       	call   80106f40 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 80 62 00 00       	call   80106f40 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 bb 39 00 00       	call   801046c0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 0f 5c 00 00       	call   80106940 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 87 5f 00 00       	call   80106cc0 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 ed 79 10 80       	push   $0x801079ed
80100d5b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d60:	e8 eb 34 00 00       	call   80104250 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 c0 0f 11 80       	push   $0x80110fc0
80100d81:	e8 ca 35 00 00       	call   80104350 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 c0 0f 11 80       	push   $0x80110fc0
80100db1:	e8 ba 36 00 00       	call   80104470 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 c0 0f 11 80       	push   $0x80110fc0
80100dc8:	e8 a3 36 00 00       	call   80104470 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 c0 0f 11 80       	push   $0x80110fc0
80100def:	e8 5c 35 00 00       	call   80104350 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 c0 0f 11 80       	push   $0x80110fc0
80100e0c:	e8 5f 36 00 00       	call   80104470 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 f4 79 10 80       	push   $0x801079f4
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 0a 35 00 00       	call   80104350 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 ff 35 00 00       	jmp    80104470 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 d3 35 00 00       	call   80104470 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 3a 24 00 00       	call   80103300 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 7b 1c 00 00       	call   80102b50 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 c0 08 00 00       	call   801017a0 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 d1 1c 00 00       	jmp    80102bc0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 fc 79 10 80       	push   $0x801079fc
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 56 07 00 00       	call   80101670 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 f9 09 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 20 08 00 00       	call   80101750 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 f1 06 00 00       	call   80101670 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 c4 09 00 00       	call   80101950 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 ad 07 00 00       	call   80101750 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 de 24 00 00       	jmp    801034a0 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 06 7a 10 80       	push   $0x80107a06
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 17 07 00 00       	call   80101750 <iunlock>
      end_op();
80101039:	e8 82 1b 00 00       	call   80102bc0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 e5 1a 00 00       	call   80102b50 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 fa 05 00 00       	call   80101670 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 c8 09 00 00       	call   80101a50 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 b3 06 00 00       	call   80101750 <iunlock>
      end_op();
8010109d:	e8 1e 1b 00 00       	call   80102bc0 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 bf 22 00 00       	jmp    801033a0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 0f 7a 10 80       	push   $0x80107a0f
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 15 7a 10 80       	push   $0x80107a15
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101109:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010110f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101112:	85 c9                	test   %ecx,%ecx
80101114:	0f 84 85 00 00 00    	je     8010119f <balloc+0x9f>
8010111a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101121:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	89 f0                	mov    %esi,%eax
80101129:	c1 f8 0c             	sar    $0xc,%eax
8010112c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101132:	50                   	push   %eax
80101133:	ff 75 d8             	pushl  -0x28(%ebp)
80101136:	e8 95 ef ff ff       	call   801000d0 <bread>
8010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010113e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101143:	83 c4 10             	add    $0x10,%esp
80101146:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101149:	31 c0                	xor    %eax,%eax
8010114b:	eb 2d                	jmp    8010117a <balloc+0x7a>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101150:	89 c1                	mov    %eax,%ecx
80101152:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115f:	89 c1                	mov    %eax,%ecx
80101161:	c1 f9 03             	sar    $0x3,%ecx
80101164:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101169:	85 d7                	test   %edx,%edi
8010116b:	74 43                	je     801011b0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116d:	83 c0 01             	add    $0x1,%eax
80101170:	83 c6 01             	add    $0x1,%esi
80101173:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101178:	74 05                	je     8010117f <balloc+0x7f>
8010117a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010117d:	72 d1                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 75 e4             	pushl  -0x1c(%ebp)
80101185:	e8 56 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101197:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010119d:	77 82                	ja     80101121 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	68 1f 7a 10 80       	push   $0x80107a1f
801011a7:	e8 c4 f1 ff ff       	call   80100370 <panic>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b0:	09 fa                	or     %edi,%edx
801011b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011b5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011bc:	57                   	push   %edi
801011bd:	e8 6e 1b 00 00       	call   80102d30 <log_write>
        brelse(bp);
801011c2:	89 3c 24             	mov    %edi,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	56                   	push   %esi
801011cd:	ff 75 d8             	pushl  -0x28(%ebp)
801011d0:	e8 fb ee ff ff       	call   801000d0 <bread>
801011d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011da:	83 c4 0c             	add    $0xc,%esp
801011dd:	68 00 02 00 00       	push   $0x200
801011e2:	6a 00                	push   $0x0
801011e4:	50                   	push   %eax
801011e5:	e8 d6 32 00 00       	call   801044c0 <memset>
  log_write(bp);
801011ea:	89 1c 24             	mov    %ebx,(%esp)
801011ed:	e8 3e 1b 00 00       	call   80102d30 <log_write>
  brelse(bp);
801011f2:	89 1c 24             	mov    %ebx,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret    
80101204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010120a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101218:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 28             	sub    $0x28,%esp
80101222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101225:	68 e0 19 11 80       	push   $0x801119e0
8010122a:	e8 21 31 00 00       	call   80104350 <acquire>
8010122f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101235:	eb 1b                	jmp    80101252 <iget+0x42>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101240:	85 f6                	test   %esi,%esi
80101242:	74 44                	je     80101288 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010124a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101250:	74 4e                	je     801012a0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101252:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101255:	85 c9                	test   %ecx,%ecx
80101257:	7e e7                	jle    80101240 <iget+0x30>
80101259:	39 3b                	cmp    %edi,(%ebx)
8010125b:	75 e3                	jne    80101240 <iget+0x30>
8010125d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101260:	75 de                	jne    80101240 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101262:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101265:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101268:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126a:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010126f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101272:	e8 f9 31 00 00       	call   80104470 <release>
      return ip;
80101277:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101299:	75 b7                	jne    80101252 <iget+0x42>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 2d                	je     801012d1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 e0 19 11 80       	push   $0x801119e0
801012bf:	e8 ac 31 00 00       	call   80104470 <release>

  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 35 7a 10 80       	push   $0x80107a35
801012d9:	e8 92 f0 ff ff       	call   80100370 <panic>
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c6                	mov    %eax,%esi
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 76                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010130b:	83 fb 7f             	cmp    $0x7f,%ebx
8010130e:	0f 87 83 00 00 00    	ja     80101397 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101314:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	74 6a                	je     80101388 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131e:	83 ec 08             	sub    $0x8,%esp
80101321:	50                   	push   %eax
80101322:	ff 36                	pushl  (%esi)
80101324:	e8 a7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101329:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010132d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101330:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101332:	8b 1a                	mov    (%edx),%ebx
80101334:	85 db                	test   %ebx,%ebx
80101336:	75 1d                	jne    80101355 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010133d:	e8 be fd ff ff       	call   80101100 <balloc>
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101348:	89 c3                	mov    %eax,%ebx
8010134a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 de 19 00 00       	call   80102d30 <log_write>
80101352:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	57                   	push   %edi
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>
8010135e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101364:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 06                	mov    (%esi),%eax
80101372:	e8 89 fd ff ff       	call   80101100 <balloc>
80101377:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101388:	8b 06                	mov    (%esi),%eax
8010138a:	e8 71 fd ff ff       	call   80101100 <balloc>
8010138f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101395:	eb 87                	jmp    8010131e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101397:	83 ec 0c             	sub    $0xc,%esp
8010139a:	68 45 7a 10 80       	push   $0x80107a45
8010139f:	e8 cc ef ff ff       	call   80100370 <panic>
801013a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013b0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b8:	83 ec 08             	sub    $0x8,%esp
801013bb:	6a 01                	push   $0x1
801013bd:	ff 75 08             	pushl  0x8(%ebp)
801013c0:	e8 0b ed ff ff       	call   801000d0 <bread>
801013c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ca:	83 c4 0c             	add    $0xc,%esp
801013cd:	6a 1c                	push   $0x1c
801013cf:	50                   	push   %eax
801013d0:	56                   	push   %esi
801013d1:	e8 9a 31 00 00       	call   80104570 <memmove>
  brelse(bp);
801013d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e2:	e9 f9 ed ff ff       	jmp    801001e0 <brelse>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
801013f7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	68 c0 19 11 80       	push   $0x801119c0
80101401:	50                   	push   %eax
80101402:	e8 a9 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101407:	58                   	pop    %eax
80101408:	5a                   	pop    %edx
80101409:	89 da                	mov    %ebx,%edx
8010140b:	c1 ea 0c             	shr    $0xc,%edx
8010140e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101414:	52                   	push   %edx
80101415:	56                   	push   %esi
80101416:	e8 b5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101423:	ba 01 00 00 00       	mov    $0x1,%edx
80101428:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142b:	c1 fb 03             	sar    $0x3,%ebx
8010142e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101431:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101433:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101438:	85 d1                	test   %edx,%ecx
8010143a:	74 27                	je     80101463 <bfree+0x73>
8010143c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010143e:	f7 d2                	not    %edx
80101440:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101442:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101445:	21 d0                	and    %edx,%eax
80101447:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010144b:	56                   	push   %esi
8010144c:	e8 df 18 00 00       	call   80102d30 <log_write>
  brelse(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 87 ed ff ff       	call   801001e0 <brelse>
}
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5d                   	pop    %ebp
80101462:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101463:	83 ec 0c             	sub    $0xc,%esp
80101466:	68 58 7a 10 80       	push   $0x80107a58
8010146b:	e8 00 ef ff ff       	call   80100370 <panic>

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101479:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	68 6b 7a 10 80       	push   $0x80107a6b
80101481:	68 e0 19 11 80       	push   $0x801119e0
80101486:	e8 c5 2d 00 00       	call   80104250 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 72 7a 10 80       	push   $0x80107a72
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 9c 2c 00 00       	call   80104140 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a4:	83 c4 10             	add    $0x10,%esp
801014a7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014ad:	75 e1                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	68 c0 19 11 80       	push   $0x801119c0
801014b7:	ff 75 08             	pushl  0x8(%ebp)
801014ba:	e8 f1 fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014bf:	ff 35 d8 19 11 80    	pushl  0x801119d8
801014c5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801014cb:	ff 35 d0 19 11 80    	pushl  0x801119d0
801014d1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801014d7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801014dd:	ff 35 c4 19 11 80    	pushl  0x801119c4
801014e3:	ff 35 c0 19 11 80    	pushl  0x801119c0
801014e9:	68 d8 7a 10 80       	push   $0x80107ad8
801014ee:	e8 6d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014f3:	83 c4 30             	add    $0x30,%esp
801014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f9:	c9                   	leave  
801014fa:	c3                   	ret    
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	8b 75 08             	mov    0x8(%ebp),%esi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 91 00 00 00    	jbe    801015b0 <ialloc+0xb0>
8010151f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101524:	eb 21                	jmp    80101547 <ialloc+0x47>
80101526:	8d 76 00             	lea    0x0(%esi),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101530:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101536:	57                   	push   %edi
80101537:	e8 a4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 c4 10             	add    $0x10,%esp
8010153f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101545:	76 69                	jbe    801015b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101547:	89 d8                	mov    %ebx,%eax
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	c1 e8 03             	shr    $0x3,%eax
8010154f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101555:	50                   	push   %eax
80101556:	56                   	push   %esi
80101557:	e8 74 eb ff ff       	call   801000d0 <bread>
8010155c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010155e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101560:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101563:	83 e0 07             	and    $0x7,%eax
80101566:	c1 e0 06             	shl    $0x6,%eax
80101569:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010156d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101571:	75 bd                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101573:	83 ec 04             	sub    $0x4,%esp
80101576:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101579:	6a 40                	push   $0x40
8010157b:	6a 00                	push   $0x0
8010157d:	51                   	push   %ecx
8010157e:	e8 3d 2f 00 00       	call   801044c0 <memset>
      dip->type = type;
80101583:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101587:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010158a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010158d:	89 3c 24             	mov    %edi,(%esp)
80101590:	e8 9b 17 00 00       	call   80102d30 <log_write>
      brelse(bp);
80101595:	89 3c 24             	mov    %edi,(%esp)
80101598:	e8 43 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010159d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015a3:	89 da                	mov    %ebx,%edx
801015a5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a7:	5b                   	pop    %ebx
801015a8:	5e                   	pop    %esi
801015a9:	5f                   	pop    %edi
801015aa:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ab:	e9 60 fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015b0:	83 ec 0c             	sub    $0xc,%esp
801015b3:	68 78 7a 10 80       	push   $0x80107a78
801015b8:	e8 b3 ed ff ff       	call   80100370 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ce:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d1:	c1 e8 03             	shr    $0x3,%eax
801015d4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015da:	50                   	push   %eax
801015db:	ff 73 a4             	pushl  -0x5c(%ebx)
801015de:	e8 ed ea ff ff       	call   801000d0 <bread>
801015e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ec:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ef:	83 e0 07             	and    $0x7,%eax
801015f2:	c1 e0 06             	shl    $0x6,%eax
801015f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101600:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101603:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101607:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010160b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010160f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101613:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101617:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010161a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161d:	6a 34                	push   $0x34
8010161f:	53                   	push   %ebx
80101620:	50                   	push   %eax
80101621:	e8 4a 2f 00 00       	call   80104570 <memmove>
  log_write(bp);
80101626:	89 34 24             	mov    %esi,(%esp)
80101629:	e8 02 17 00 00       	call   80102d30 <log_write>
  brelse(bp);
8010162e:	89 75 08             	mov    %esi,0x8(%ebp)
80101631:	83 c4 10             	add    $0x10,%esp
}
80101634:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010163a:	e9 a1 eb ff ff       	jmp    801001e0 <brelse>
8010163f:	90                   	nop

80101640 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	83 ec 10             	sub    $0x10,%esp
80101647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010164a:	68 e0 19 11 80       	push   $0x801119e0
8010164f:	e8 fc 2c 00 00       	call   80104350 <acquire>
  ip->ref++;
80101654:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101658:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010165f:	e8 0c 2e 00 00       	call   80104470 <release>
  return ip;
}
80101664:	89 d8                	mov    %ebx,%eax
80101666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101669:	c9                   	leave  
8010166a:	c3                   	ret    
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101678:	85 db                	test   %ebx,%ebx
8010167a:	0f 84 b7 00 00 00    	je     80101737 <ilock+0xc7>
80101680:	8b 53 08             	mov    0x8(%ebx),%edx
80101683:	85 d2                	test   %edx,%edx
80101685:	0f 8e ac 00 00 00    	jle    80101737 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010168b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010168e:	83 ec 0c             	sub    $0xc,%esp
80101691:	50                   	push   %eax
80101692:	e8 e9 2a 00 00       	call   80104180 <acquiresleep>

  if(ip->valid == 0){
80101697:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010169a:	83 c4 10             	add    $0x10,%esp
8010169d:	85 c0                	test   %eax,%eax
8010169f:	74 0f                	je     801016b0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a4:	5b                   	pop    %ebx
801016a5:	5e                   	pop    %esi
801016a6:	5d                   	pop    %ebp
801016a7:	c3                   	ret    
801016a8:	90                   	nop
801016a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b0:	8b 43 04             	mov    0x4(%ebx),%eax
801016b3:	83 ec 08             	sub    $0x8,%esp
801016b6:	c1 e8 03             	shr    $0x3,%eax
801016b9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016bf:	50                   	push   %eax
801016c0:	ff 33                	pushl  (%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
801016c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016d9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	50                   	push   %eax
80101704:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101707:	50                   	push   %eax
80101708:	e8 63 2e 00 00       	call   80104570 <memmove>
    brelse(bp);
8010170d:	89 34 24             	mov    %esi,(%esp)
80101710:	e8 cb ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101715:	83 c4 10             	add    $0x10,%esp
80101718:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010171d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101724:	0f 85 77 ff ff ff    	jne    801016a1 <ilock+0x31>
      panic("ilock: no type");
8010172a:	83 ec 0c             	sub    $0xc,%esp
8010172d:	68 90 7a 10 80       	push   $0x80107a90
80101732:	e8 39 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 8a 7a 10 80       	push   $0x80107a8a
8010173f:	e8 2c ec ff ff       	call   80100370 <panic>
80101744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010174a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101750 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	74 28                	je     80101784 <iunlock+0x34>
8010175c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010175f:	83 ec 0c             	sub    $0xc,%esp
80101762:	56                   	push   %esi
80101763:	e8 b8 2a 00 00       	call   80104220 <holdingsleep>
80101768:	83 c4 10             	add    $0x10,%esp
8010176b:	85 c0                	test   %eax,%eax
8010176d:	74 15                	je     80101784 <iunlock+0x34>
8010176f:	8b 43 08             	mov    0x8(%ebx),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	7e 0e                	jle    80101784 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101776:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101779:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177c:	5b                   	pop    %ebx
8010177d:	5e                   	pop    %esi
8010177e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010177f:	e9 5c 2a 00 00       	jmp    801041e0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 9f 7a 10 80       	push   $0x80107a9f
8010178c:	e8 df eb ff ff       	call   80100370 <panic>
80101791:	eb 0d                	jmp    801017a0 <iput>
80101793:	90                   	nop
80101794:	90                   	nop
80101795:	90                   	nop
80101796:	90                   	nop
80101797:	90                   	nop
80101798:	90                   	nop
80101799:	90                   	nop
8010179a:	90                   	nop
8010179b:	90                   	nop
8010179c:	90                   	nop
8010179d:	90                   	nop
8010179e:	90                   	nop
8010179f:	90                   	nop

801017a0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 28             	sub    $0x28,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ac:	8d 7e 0c             	lea    0xc(%esi),%edi
801017af:	57                   	push   %edi
801017b0:	e8 cb 29 00 00       	call   80104180 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017b5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 d2                	test   %edx,%edx
801017bd:	74 07                	je     801017c6 <iput+0x26>
801017bf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017c4:	74 32                	je     801017f8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017c6:	83 ec 0c             	sub    $0xc,%esp
801017c9:	57                   	push   %edi
801017ca:	e8 11 2a 00 00       	call   801041e0 <releasesleep>

  acquire(&icache.lock);
801017cf:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801017d6:	e8 75 2b 00 00       	call   80104350 <acquire>
  ip->ref--;
801017db:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801017e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ec:	5b                   	pop    %ebx
801017ed:	5e                   	pop    %esi
801017ee:	5f                   	pop    %edi
801017ef:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017f0:	e9 7b 2c 00 00       	jmp    80104470 <release>
801017f5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 e0 19 11 80       	push   $0x801119e0
80101800:	e8 4b 2b 00 00       	call   80104350 <acquire>
    int r = ip->ref;
80101805:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101808:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010180f:	e8 5c 2c 00 00       	call   80104470 <release>
    if(r == 1){
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	83 fb 01             	cmp    $0x1,%ebx
8010181a:	75 aa                	jne    801017c6 <iput+0x26>
8010181c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101822:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101825:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101828:	89 cf                	mov    %ecx,%edi
8010182a:	eb 0b                	jmp    80101837 <iput+0x97>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101830:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101833:	39 fb                	cmp    %edi,%ebx
80101835:	74 19                	je     80101850 <iput+0xb0>
    if(ip->addrs[i]){
80101837:	8b 13                	mov    (%ebx),%edx
80101839:	85 d2                	test   %edx,%edx
8010183b:	74 f3                	je     80101830 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010183d:	8b 06                	mov    (%esi),%eax
8010183f:	e8 ac fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101844:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010184a:	eb e4                	jmp    80101830 <iput+0x90>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101850:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101856:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101859:	85 c0                	test   %eax,%eax
8010185b:	75 33                	jne    80101890 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010185d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101860:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101867:	56                   	push   %esi
80101868:	e8 53 fd ff ff       	call   801015c0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010186d:	31 c0                	xor    %eax,%eax
8010186f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101873:	89 34 24             	mov    %esi,(%esp)
80101876:	e8 45 fd ff ff       	call   801015c0 <iupdate>
      ip->valid = 0;
8010187b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101882:	83 c4 10             	add    $0x10,%esp
80101885:	e9 3c ff ff ff       	jmp    801017c6 <iput+0x26>
8010188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	83 ec 08             	sub    $0x8,%esp
80101893:	50                   	push   %eax
80101894:	ff 36                	pushl  (%esi)
80101896:	e8 35 e8 ff ff       	call   801000d0 <bread>
8010189b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018a1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018a7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	89 cf                	mov    %ecx,%edi
801018af:	eb 0e                	jmp    801018bf <iput+0x11f>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018bb:	39 fb                	cmp    %edi,%ebx
801018bd:	74 0f                	je     801018ce <iput+0x12e>
      if(a[j])
801018bf:	8b 13                	mov    (%ebx),%edx
801018c1:	85 d2                	test   %edx,%edx
801018c3:	74 f3                	je     801018b8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018c5:	8b 06                	mov    (%esi),%eax
801018c7:	e8 24 fb ff ff       	call   801013f0 <bfree>
801018cc:	eb ea                	jmp    801018b8 <iput+0x118>
    }
    brelse(bp);
801018ce:	83 ec 0c             	sub    $0xc,%esp
801018d1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018d7:	e8 04 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018dc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e2:	8b 06                	mov    (%esi),%eax
801018e4:	e8 07 fb ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018e9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f0:	00 00 00 
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	e9 62 ff ff ff       	jmp    8010185d <iput+0xbd>
801018fb:	90                   	nop
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 10             	sub    $0x10,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	53                   	push   %ebx
8010190b:	e8 40 fe ff ff       	call   80101750 <iunlock>
  iput(ip);
80101910:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101913:	83 c4 10             	add    $0x10,%esp
}
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010191a:	e9 81 fe ff ff       	jmp    801017a0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 1c             	sub    $0x1c,%esp
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101962:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101967:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010196a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010196d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101970:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101973:	0f 84 a7 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101979:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010197c:	8b 40 58             	mov    0x58(%eax),%eax
8010197f:	39 f0                	cmp    %esi,%eax
80101981:	0f 82 c1 00 00 00    	jb     80101a48 <readi+0xf8>
80101987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010198a:	89 fa                	mov    %edi,%edx
8010198c:	01 f2                	add    %esi,%edx
8010198e:	0f 82 b4 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101994:	89 c1                	mov    %eax,%ecx
80101996:	29 f1                	sub    %esi,%ecx
80101998:	39 d0                	cmp    %edx,%eax
8010199a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199d:	31 ff                	xor    %edi,%edi
8010199f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a4:	74 6d                	je     80101a13 <readi+0xc3>
801019a6:	8d 76 00             	lea    0x0(%esi),%esi
801019a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019b3:	89 f2                	mov    %esi,%edx
801019b5:	c1 ea 09             	shr    $0x9,%edx
801019b8:	89 d8                	mov    %ebx,%eax
801019ba:	e8 21 f9 ff ff       	call   801012e0 <bmap>
801019bf:	83 ec 08             	sub    $0x8,%esp
801019c2:	50                   	push   %eax
801019c3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019c5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ca:	e8 01 e7 ff ff       	call   801000d0 <bread>
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019d4:	89 f1                	mov    %esi,%ecx
801019d6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019dc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019e2:	29 cb                	sub    %ecx,%ebx
801019e4:	29 f8                	sub    %edi,%eax
801019e6:	39 c3                	cmp    %eax,%ebx
801019e8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019eb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019ef:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f0:	01 df                	add    %ebx,%edi
801019f2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019f4:	50                   	push   %eax
801019f5:	ff 75 e0             	pushl  -0x20(%ebp)
801019f8:	e8 73 2b 00 00       	call   80104570 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	83 c4 10             	add    $0x10,%esp
80101a0e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a11:	77 9d                	ja     801019b0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a19:	5b                   	pop    %ebx
80101a1a:	5e                   	pop    %esi
80101a1b:	5f                   	pop    %edi
80101a1c:	5d                   	pop    %ebp
80101a1d:	c3                   	ret    
80101a1e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a35:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3b:	5b                   	pop    %ebx
80101a3c:	5e                   	pop    %esi
80101a3d:	5f                   	pop    %edi
80101a3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a3f:	ff e0                	jmp    *%eax
80101a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c7                	jmp    80101a16 <readi+0xc6>
80101a4f:	90                   	nop

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 1c             	sub    $0x1c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a70:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 eb 00 00 00    	jb     80101b70 <writei+0x120>
80101a85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a88:	89 f8                	mov    %edi,%eax
80101a8a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a8c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a91:	0f 87 d9 00 00 00    	ja     80101b70 <writei+0x120>
80101a97:	39 c6                	cmp    %eax,%esi
80101a99:	0f 87 d1 00 00 00    	ja     80101b70 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9f:	85 ff                	test   %edi,%edi
80101aa1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa8:	74 78                	je     80101b22 <writei+0xd2>
80101aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ab3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aba:	c1 ea 09             	shr    $0x9,%edx
80101abd:	89 f8                	mov    %edi,%eax
80101abf:	e8 1c f8 ff ff       	call   801012e0 <bmap>
80101ac4:	83 ec 08             	sub    $0x8,%esp
80101ac7:	50                   	push   %eax
80101ac8:	ff 37                	pushl  (%edi)
80101aca:	e8 01 e6 ff ff       	call   801000d0 <bread>
80101acf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ad4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ad7:	89 f1                	mov    %esi,%ecx
80101ad9:	83 c4 0c             	add    $0xc,%esp
80101adc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ae2:	29 cb                	sub    %ecx,%ebx
80101ae4:	39 c3                	cmp    %eax,%ebx
80101ae6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101aed:	53                   	push   %ebx
80101aee:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	50                   	push   %eax
80101af4:	e8 77 2a 00 00       	call   80104570 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 2f 12 00 00       	call   80102d30 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b0f:	83 c4 10             	add    $0x10,%esp
80101b12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b15:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b18:	77 96                	ja     80101ab0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b20:	77 36                	ja     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 36                	ja     80101b70 <writei+0x120>
80101b3a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 2b                	je     80101b70 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b5b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b61:	50                   	push   %eax
80101b62:	e8 59 fa ff ff       	call   801015c0 <iupdate>
80101b67:	83 c4 10             	add    $0x10,%esp
80101b6a:	eb b6                	jmp    80101b22 <writei+0xd2>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b75:	eb ae                	jmp    80101b25 <writei+0xd5>
80101b77:	89 f6                	mov    %esi,%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	6a 0e                	push   $0xe
80101b88:	ff 75 0c             	pushl  0xc(%ebp)
80101b8b:	ff 75 08             	pushl  0x8(%ebp)
80101b8e:	e8 5d 2a 00 00       	call   801045f0 <strncmp>
}
80101b93:	c9                   	leave  
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 80 00 00 00    	jne    80101c37 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 5b                	jmp    80101c20 <dirlookup+0x80>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 50                	jbe    80101c20 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	6a 10                	push   $0x10
80101bd2:	57                   	push   %edi
80101bd3:	56                   	push   %esi
80101bd4:	53                   	push   %ebx
80101bd5:	e8 76 fd ff ff       	call   80101950 <readi>
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	83 f8 10             	cmp    $0x10,%eax
80101be0:	75 48                	jne    80101c2a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101be2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101be7:	74 df                	je     80101bc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101be9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bec:	83 ec 04             	sub    $0x4,%esp
80101bef:	6a 0e                	push   $0xe
80101bf1:	50                   	push   %eax
80101bf2:	ff 75 0c             	pushl  0xc(%ebp)
80101bf5:	e8 f6 29 00 00       	call   801045f0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	85 c0                	test   %eax,%eax
80101bff:	75 c7                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c01:	8b 45 10             	mov    0x10(%ebp),%eax
80101c04:	85 c0                	test   %eax,%eax
80101c06:	74 05                	je     80101c0d <dirlookup+0x6d>
        *poff = off;
80101c08:	8b 45 10             	mov    0x10(%ebp),%eax
80101c0b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c0d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c11:	8b 03                	mov    (%ebx),%eax
80101c13:	e8 f8 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
80101c1f:	c3                   	ret    
80101c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c23:	31 c0                	xor    %eax,%eax
}
80101c25:	5b                   	pop    %ebx
80101c26:	5e                   	pop    %esi
80101c27:	5f                   	pop    %edi
80101c28:	5d                   	pop    %ebp
80101c29:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c2a:	83 ec 0c             	sub    $0xc,%esp
80101c2d:	68 b9 7a 10 80       	push   $0x80107ab9
80101c32:	e8 39 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	68 a7 7a 10 80       	push   $0x80107aa7
80101c3f:	e8 2c e7 ff ff       	call   80100370 <panic>
80101c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	89 cf                	mov    %ecx,%edi
80101c58:	89 c3                	mov    %eax,%ebx
80101c5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c5d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c63:	0f 84 53 01 00 00    	je     80101dbc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c69:	e8 92 1b 00 00       	call   80103800 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c6e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c71:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c74:	68 e0 19 11 80       	push   $0x801119e0
80101c79:	e8 d2 26 00 00       	call   80104350 <acquire>
  ip->ref++;
80101c7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c82:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101c89:	e8 e2 27 00 00       	call   80104470 <release>
80101c8e:	83 c4 10             	add    $0x10,%esp
80101c91:	eb 08                	jmp    80101c9b <namex+0x4b>
80101c93:	90                   	nop
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c98:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c9b:	0f b6 03             	movzbl (%ebx),%eax
80101c9e:	3c 2f                	cmp    $0x2f,%al
80101ca0:	74 f6                	je     80101c98 <namex+0x48>
    path++;
  if(*path == 0)
80101ca2:	84 c0                	test   %al,%al
80101ca4:	0f 84 e3 00 00 00    	je     80101d8d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101caa:	0f b6 03             	movzbl (%ebx),%eax
80101cad:	89 da                	mov    %ebx,%edx
80101caf:	84 c0                	test   %al,%al
80101cb1:	0f 84 ac 00 00 00    	je     80101d63 <namex+0x113>
80101cb7:	3c 2f                	cmp    $0x2f,%al
80101cb9:	75 09                	jne    80101cc4 <namex+0x74>
80101cbb:	e9 a3 00 00 00       	jmp    80101d63 <namex+0x113>
80101cc0:	84 c0                	test   %al,%al
80101cc2:	74 0a                	je     80101cce <namex+0x7e>
    path++;
80101cc4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cc7:	0f b6 02             	movzbl (%edx),%eax
80101cca:	3c 2f                	cmp    $0x2f,%al
80101ccc:	75 f2                	jne    80101cc0 <namex+0x70>
80101cce:	89 d1                	mov    %edx,%ecx
80101cd0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cd2:	83 f9 0d             	cmp    $0xd,%ecx
80101cd5:	0f 8e 8d 00 00 00    	jle    80101d68 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cdb:	83 ec 04             	sub    $0x4,%esp
80101cde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ce1:	6a 0e                	push   $0xe
80101ce3:	53                   	push   %ebx
80101ce4:	57                   	push   %edi
80101ce5:	e8 86 28 00 00       	call   80104570 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101ced:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cf0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cf5:	75 11                	jne    80101d08 <namex+0xb8>
80101cf7:	89 f6                	mov    %esi,%esi
80101cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d00:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d06:	74 f8                	je     80101d00 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
80101d0b:	56                   	push   %esi
80101d0c:	e8 5f f9 ff ff       	call   80101670 <ilock>
    if(ip->type != T_DIR){
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d19:	0f 85 7f 00 00 00    	jne    80101d9e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d22:	85 d2                	test   %edx,%edx
80101d24:	74 09                	je     80101d2f <namex+0xdf>
80101d26:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d29:	0f 84 a3 00 00 00    	je     80101dd2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d2f:	83 ec 04             	sub    $0x4,%esp
80101d32:	6a 00                	push   $0x0
80101d34:	57                   	push   %edi
80101d35:	56                   	push   %esi
80101d36:	e8 65 fe ff ff       	call   80101ba0 <dirlookup>
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	85 c0                	test   %eax,%eax
80101d40:	74 5c                	je     80101d9e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d42:	83 ec 0c             	sub    $0xc,%esp
80101d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d48:	56                   	push   %esi
80101d49:	e8 02 fa ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d4e:	89 34 24             	mov    %esi,(%esp)
80101d51:	e8 4a fa ff ff       	call   801017a0 <iput>
80101d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d59:	83 c4 10             	add    $0x10,%esp
80101d5c:	89 c6                	mov    %eax,%esi
80101d5e:	e9 38 ff ff ff       	jmp    80101c9b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d63:	31 c9                	xor    %ecx,%ecx
80101d65:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d68:	83 ec 04             	sub    $0x4,%esp
80101d6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d71:	51                   	push   %ecx
80101d72:	53                   	push   %ebx
80101d73:	57                   	push   %edi
80101d74:	e8 f7 27 00 00       	call   80104570 <memmove>
    name[len] = 0;
80101d79:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d7f:	83 c4 10             	add    $0x10,%esp
80101d82:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d86:	89 d3                	mov    %edx,%ebx
80101d88:	e9 65 ff ff ff       	jmp    80101cf2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d90:	85 c0                	test   %eax,%eax
80101d92:	75 54                	jne    80101de8 <namex+0x198>
80101d94:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d99:	5b                   	pop    %ebx
80101d9a:	5e                   	pop    %esi
80101d9b:	5f                   	pop    %edi
80101d9c:	5d                   	pop    %ebp
80101d9d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d9e:	83 ec 0c             	sub    $0xc,%esp
80101da1:	56                   	push   %esi
80101da2:	e8 a9 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101da7:	89 34 24             	mov    %esi,(%esp)
80101daa:	e8 f1 f9 ff ff       	call   801017a0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101daf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101db5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db7:	5b                   	pop    %ebx
80101db8:	5e                   	pop    %esi
80101db9:	5f                   	pop    %edi
80101dba:	5d                   	pop    %ebp
80101dbb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dbc:	ba 01 00 00 00       	mov    $0x1,%edx
80101dc1:	b8 01 00 00 00       	mov    $0x1,%eax
80101dc6:	e8 45 f4 ff ff       	call   80101210 <iget>
80101dcb:	89 c6                	mov    %eax,%esi
80101dcd:	e9 c9 fe ff ff       	jmp    80101c9b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dd2:	83 ec 0c             	sub    $0xc,%esp
80101dd5:	56                   	push   %esi
80101dd6:	e8 75 f9 ff ff       	call   80101750 <iunlock>
      return ip;
80101ddb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101de1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de3:	5b                   	pop    %ebx
80101de4:	5e                   	pop    %esi
80101de5:	5f                   	pop    %edi
80101de6:	5d                   	pop    %ebp
80101de7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	56                   	push   %esi
80101dec:	e8 af f9 ff ff       	call   801017a0 <iput>
    return 0;
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	31 c0                	xor    %eax,%eax
80101df6:	eb 9e                	jmp    80101d96 <namex+0x146>
80101df8:	90                   	nop
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 20             	sub    $0x20,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	6a 00                	push   $0x0
80101e0e:	ff 75 0c             	pushl  0xc(%ebp)
80101e11:	53                   	push   %ebx
80101e12:	e8 89 fd ff ff       	call   80101ba0 <dirlookup>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	85 c0                	test   %eax,%eax
80101e1c:	75 67                	jne    80101e85 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e24:	85 ff                	test   %edi,%edi
80101e26:	74 29                	je     80101e51 <dirlink+0x51>
80101e28:	31 ff                	xor    %edi,%edi
80101e2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2d:	eb 09                	jmp    80101e38 <dirlink+0x38>
80101e2f:	90                   	nop
80101e30:	83 c7 10             	add    $0x10,%edi
80101e33:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e36:	76 19                	jbe    80101e51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 0e fb ff ff       	call   80101950 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 4e                	jne    80101e98 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	75 df                	jne    80101e30 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e54:	83 ec 04             	sub    $0x4,%esp
80101e57:	6a 0e                	push   $0xe
80101e59:	ff 75 0c             	pushl  0xc(%ebp)
80101e5c:	50                   	push   %eax
80101e5d:	e8 fe 27 00 00       	call   80104660 <strncpy>
  de.inum = inum;
80101e62:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e65:	6a 10                	push   $0x10
80101e67:	57                   	push   %edi
80101e68:	56                   	push   %esi
80101e69:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6e:	e8 dd fb ff ff       	call   80101a50 <writei>
80101e73:	83 c4 20             	add    $0x20,%esp
80101e76:	83 f8 10             	cmp    $0x10,%eax
80101e79:	75 2a                	jne    80101ea5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e7b:	31 c0                	xor    %eax,%eax
}
80101e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e80:	5b                   	pop    %ebx
80101e81:	5e                   	pop    %esi
80101e82:	5f                   	pop    %edi
80101e83:	5d                   	pop    %ebp
80101e84:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	50                   	push   %eax
80101e89:	e8 12 f9 ff ff       	call   801017a0 <iput>
    return -1;
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e96:	eb e5                	jmp    80101e7d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e98:	83 ec 0c             	sub    $0xc,%esp
80101e9b:	68 c8 7a 10 80       	push   $0x80107ac8
80101ea0:	e8 cb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 c6 80 10 80       	push   $0x801080c6
80101ead:	e8 be e4 ff ff       	call   80100370 <panic>
80101eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ec0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ece:	e8 7d fd ff ff       	call   80101c50 <namex>
}
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ee0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ee1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ee6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eee:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101eef:	e9 5c fd ff ff       	jmp    80101c50 <namex>
80101ef4:	66 90                	xchg   %ax,%ax
80101ef6:	66 90                	xchg   %ax,%ax
80101ef8:	66 90                	xchg   %ax,%ax
80101efa:	66 90                	xchg   %ax,%ax
80101efc:	66 90                	xchg   %ax,%ax
80101efe:	66 90                	xchg   %ax,%ax

80101f00 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f00:	55                   	push   %ebp
  if(b == 0)
80101f01:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	56                   	push   %esi
80101f06:	53                   	push   %ebx
  if(b == 0)
80101f07:	0f 84 ad 00 00 00    	je     80101fba <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f0d:	8b 58 08             	mov    0x8(%eax),%ebx
80101f10:	89 c1                	mov    %eax,%ecx
80101f12:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f18:	0f 87 8f 00 00 00    	ja     80101fad <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f1e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f23:	90                   	nop
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f28:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f29:	83 e0 c0             	and    $0xffffffc0,%eax
80101f2c:	3c 40                	cmp    $0x40,%al
80101f2e:	75 f8                	jne    80101f28 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f30:	31 f6                	xor    %esi,%esi
80101f32:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f37:	89 f0                	mov    %esi,%eax
80101f39:	ee                   	out    %al,(%dx)
80101f3a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f3f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f44:	ee                   	out    %al,(%dx)
80101f45:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f4a:	89 d8                	mov    %ebx,%eax
80101f4c:	ee                   	out    %al,(%dx)
80101f4d:	89 d8                	mov    %ebx,%eax
80101f4f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f54:	c1 f8 08             	sar    $0x8,%eax
80101f57:	ee                   	out    %al,(%dx)
80101f58:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f5d:	89 f0                	mov    %esi,%eax
80101f5f:	ee                   	out    %al,(%dx)
80101f60:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f64:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f69:	83 e0 01             	and    $0x1,%eax
80101f6c:	c1 e0 04             	shl    $0x4,%eax
80101f6f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f72:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f73:	f6 01 04             	testb  $0x4,(%ecx)
80101f76:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f7b:	75 13                	jne    80101f90 <idestart+0x90>
80101f7d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f82:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f86:	5b                   	pop    %ebx
80101f87:	5e                   	pop    %esi
80101f88:	5d                   	pop    %ebp
80101f89:	c3                   	ret    
80101f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f90:	b8 30 00 00 00       	mov    $0x30,%eax
80101f95:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f96:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f9b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f9e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fa3:	fc                   	cld    
80101fa4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fa9:	5b                   	pop    %ebx
80101faa:	5e                   	pop    %esi
80101fab:	5d                   	pop    %ebp
80101fac:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fad:	83 ec 0c             	sub    $0xc,%esp
80101fb0:	68 34 7b 10 80       	push   $0x80107b34
80101fb5:	e8 b6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	68 2b 7b 10 80       	push   $0x80107b2b
80101fc2:	e8 a9 e3 ff ff       	call   80100370 <panic>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fd6:	68 46 7b 10 80       	push   $0x80107b46
80101fdb:	68 80 b5 10 80       	push   $0x8010b580
80101fe0:	e8 6b 22 00 00       	call   80104250 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fe5:	58                   	pop    %eax
80101fe6:	a1 00 3d 11 80       	mov    0x80113d00,%eax
80101feb:	5a                   	pop    %edx
80101fec:	83 e8 01             	sub    $0x1,%eax
80101fef:	50                   	push   %eax
80101ff0:	6a 0e                	push   $0xe
80101ff2:	e8 a9 02 00 00       	call   801022a0 <ioapicenable>
80101ff7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ffa:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fff:	90                   	nop
80102000:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102001:	83 e0 c0             	and    $0xffffffc0,%eax
80102004:	3c 40                	cmp    $0x40,%al
80102006:	75 f8                	jne    80102000 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102008:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010200d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102012:	ee                   	out    %al,(%dx)
80102013:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102018:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010201d:	eb 06                	jmp    80102025 <ideinit+0x55>
8010201f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102020:	83 e9 01             	sub    $0x1,%ecx
80102023:	74 0f                	je     80102034 <ideinit+0x64>
80102025:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102026:	84 c0                	test   %al,%al
80102028:	74 f6                	je     80102020 <ideinit+0x50>
      havedisk1 = 1;
8010202a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102031:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102034:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102039:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010203e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010203f:	c9                   	leave  
80102040:	c3                   	ret    
80102041:	eb 0d                	jmp    80102050 <ideintr>
80102043:	90                   	nop
80102044:	90                   	nop
80102045:	90                   	nop
80102046:	90                   	nop
80102047:	90                   	nop
80102048:	90                   	nop
80102049:	90                   	nop
8010204a:	90                   	nop
8010204b:	90                   	nop
8010204c:	90                   	nop
8010204d:	90                   	nop
8010204e:	90                   	nop
8010204f:	90                   	nop

80102050 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102059:	68 80 b5 10 80       	push   $0x8010b580
8010205e:	e8 ed 22 00 00       	call   80104350 <acquire>

  if((b = idequeue) == 0){
80102063:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102069:	83 c4 10             	add    $0x10,%esp
8010206c:	85 db                	test   %ebx,%ebx
8010206e:	74 34                	je     801020a4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102070:	8b 43 58             	mov    0x58(%ebx),%eax
80102073:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102078:	8b 33                	mov    (%ebx),%esi
8010207a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102080:	74 3e                	je     801020c0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102082:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102085:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102088:	83 ce 02             	or     $0x2,%esi
8010208b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010208d:	53                   	push   %ebx
8010208e:	e8 fd 1e 00 00       	call   80103f90 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102093:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102098:	83 c4 10             	add    $0x10,%esp
8010209b:	85 c0                	test   %eax,%eax
8010209d:	74 05                	je     801020a4 <ideintr+0x54>
    idestart(idequeue);
8010209f:	e8 5c fe ff ff       	call   80101f00 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	68 80 b5 10 80       	push   $0x8010b580
801020ac:	e8 bf 23 00 00       	call   80104470 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b4:	5b                   	pop    %ebx
801020b5:	5e                   	pop    %esi
801020b6:	5f                   	pop    %edi
801020b7:	5d                   	pop    %ebp
801020b8:	c3                   	ret    
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c5:	8d 76 00             	lea    0x0(%esi),%esi
801020c8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c9:	89 c1                	mov    %eax,%ecx
801020cb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ce:	80 f9 40             	cmp    $0x40,%cl
801020d1:	75 f5                	jne    801020c8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020d3:	a8 21                	test   $0x21,%al
801020d5:	75 ab                	jne    80102082 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020d7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020da:	b9 80 00 00 00       	mov    $0x80,%ecx
801020df:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020e4:	fc                   	cld    
801020e5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e7:	8b 33                	mov    (%ebx),%esi
801020e9:	eb 97                	jmp    80102082 <ideintr+0x32>
801020eb:	90                   	nop
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	53                   	push   %ebx
801020f4:	83 ec 10             	sub    $0x10,%esp
801020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801020fd:	50                   	push   %eax
801020fe:	e8 1d 21 00 00       	call   80104220 <holdingsleep>
80102103:	83 c4 10             	add    $0x10,%esp
80102106:	85 c0                	test   %eax,%eax
80102108:	0f 84 ad 00 00 00    	je     801021bb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010210e:	8b 03                	mov    (%ebx),%eax
80102110:	83 e0 06             	and    $0x6,%eax
80102113:	83 f8 02             	cmp    $0x2,%eax
80102116:	0f 84 b9 00 00 00    	je     801021d5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010211c:	8b 53 04             	mov    0x4(%ebx),%edx
8010211f:	85 d2                	test   %edx,%edx
80102121:	74 0d                	je     80102130 <iderw+0x40>
80102123:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102128:	85 c0                	test   %eax,%eax
8010212a:	0f 84 98 00 00 00    	je     801021c8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	68 80 b5 10 80       	push   $0x8010b580
80102138:	e8 13 22 00 00       	call   80104350 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102143:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102146:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214d:	85 d2                	test   %edx,%edx
8010214f:	75 09                	jne    8010215a <iderw+0x6a>
80102151:	eb 58                	jmp    801021ab <iderw+0xbb>
80102153:	90                   	nop
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102158:	89 c2                	mov    %eax,%edx
8010215a:	8b 42 58             	mov    0x58(%edx),%eax
8010215d:	85 c0                	test   %eax,%eax
8010215f:	75 f7                	jne    80102158 <iderw+0x68>
80102161:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102164:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102166:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010216c:	74 44                	je     801021b2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	74 23                	je     8010219b <iderw+0xab>
80102178:	90                   	nop
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102180:	83 ec 08             	sub    $0x8,%esp
80102183:	68 80 b5 10 80       	push   $0x8010b580
80102188:	53                   	push   %ebx
80102189:	e8 42 1c 00 00       	call   80103dd0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 c4 10             	add    $0x10,%esp
80102193:	83 e0 06             	and    $0x6,%eax
80102196:	83 f8 02             	cmp    $0x2,%eax
80102199:	75 e5                	jne    80102180 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010219b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021a5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021a6:	e9 c5 22 00 00       	jmp    80104470 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021b0:	eb b2                	jmp    80102164 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021b2:	89 d8                	mov    %ebx,%eax
801021b4:	e8 47 fd ff ff       	call   80101f00 <idestart>
801021b9:	eb b3                	jmp    8010216e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021bb:	83 ec 0c             	sub    $0xc,%esp
801021be:	68 4a 7b 10 80       	push   $0x80107b4a
801021c3:	e8 a8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 75 7b 10 80       	push   $0x80107b75
801021d0:	e8 9b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 60 7b 10 80       	push   $0x80107b60
801021dd:	e8 8e e1 ff ff       	call   80100370 <panic>
801021e2:	66 90                	xchg   %ax,%ax
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021f1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801021f8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fb:	89 e5                	mov    %esp,%ebp
801021fd:	56                   	push   %esi
801021fe:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102206:	00 00 00 
  return ioapic->data;
80102209:	8b 15 34 36 11 80    	mov    0x80113634,%edx
8010220f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102212:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102218:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010221e:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102225:	89 f0                	mov    %esi,%eax
80102227:	c1 e8 10             	shr    $0x10,%eax
8010222a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010222d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102230:	c1 e8 18             	shr    $0x18,%eax
80102233:	39 d0                	cmp    %edx,%eax
80102235:	74 16                	je     8010224d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 94 7b 10 80       	push   $0x80107b94
8010223f:	e8 1c e4 ff ff       	call   80100660 <cprintf>
80102244:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010224a:	83 c4 10             	add    $0x10,%esp
8010224d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102250:	ba 10 00 00 00       	mov    $0x10,%edx
80102255:	b8 20 00 00 00       	mov    $0x20,%eax
8010225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102260:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102262:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102268:	89 c3                	mov    %eax,%ebx
8010226a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102270:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102273:	89 59 10             	mov    %ebx,0x10(%ecx)
80102276:	8d 5a 01             	lea    0x1(%edx),%ebx
80102279:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102280:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102286:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228d:	75 d1                	jne    80102260 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010228f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102292:	5b                   	pop    %ebx
80102293:	5e                   	pop    %esi
80102294:	5d                   	pop    %ebp
80102295:	c3                   	ret    
80102296:	8d 76 00             	lea    0x0(%esi),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022a0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ac:	8d 50 20             	lea    0x20(%eax),%edx
801022af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022be:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022c6:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022cb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022ce:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022d1:	5d                   	pop    %ebp
801022d2:	c3                   	ret    
801022d3:	66 90                	xchg   %ax,%ax
801022d5:	66 90                	xchg   %ax,%ax
801022d7:	66 90                	xchg   %ax,%ax
801022d9:	66 90                	xchg   %ax,%ax
801022db:	66 90                	xchg   %ax,%ax
801022dd:	66 90                	xchg   %ax,%ax
801022df:	90                   	nop

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 04             	sub    $0x4,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 70                	jne    80102362 <kfree+0x82>
801022f2:	81 fb f8 30 12 80    	cmp    $0x801230f8,%ebx
801022f8:	72 68                	jb     80102362 <kfree+0x82>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 5b                	ja     80102362 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	83 ec 04             	sub    $0x4,%esp
8010230a:	68 00 10 00 00       	push   $0x1000
8010230f:	6a 01                	push   $0x1
80102311:	53                   	push   %ebx
80102312:	e8 a9 21 00 00       	call   801044c0 <memset>

  if(kmem.use_lock)
80102317:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	85 d2                	test   %edx,%edx
80102322:	75 2c                	jne    80102350 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102324:	a1 78 36 11 80       	mov    0x80113678,%eax
80102329:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010232b:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102330:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102336:	85 c0                	test   %eax,%eax
80102338:	75 06                	jne    80102340 <kfree+0x60>
    release(&kmem.lock);
}
8010233a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233d:	c9                   	leave  
8010233e:	c3                   	ret    
8010233f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102340:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010234a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010234b:	e9 20 21 00 00       	jmp    80104470 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	68 40 36 11 80       	push   $0x80113640
80102358:	e8 f3 1f 00 00       	call   80104350 <acquire>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	eb c2                	jmp    80102324 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102362:	83 ec 0c             	sub    $0xc,%esp
80102365:	68 c6 7b 10 80       	push   $0x80107bc6
8010236a:	e8 01 e0 ff ff       	call   80100370 <panic>
8010236f:	90                   	nop

80102370 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	56                   	push   %esi
80102374:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102375:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102378:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010237b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102381:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102387:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010238d:	39 de                	cmp    %ebx,%esi
8010238f:	72 23                	jb     801023b4 <freerange+0x44>
80102391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102398:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010239e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023a7:	50                   	push   %eax
801023a8:	e8 33 ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	39 f3                	cmp    %esi,%ebx
801023b2:	76 e4                	jbe    80102398 <freerange+0x28>
    kfree(p);
}
801023b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023b7:	5b                   	pop    %ebx
801023b8:	5e                   	pop    %esi
801023b9:	5d                   	pop    %ebp
801023ba:	c3                   	ret    
801023bb:	90                   	nop
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023c0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023c8:	83 ec 08             	sub    $0x8,%esp
801023cb:	68 cc 7b 10 80       	push   $0x80107bcc
801023d0:	68 40 36 11 80       	push   $0x80113640
801023d5:	e8 76 1e 00 00       	call   80104250 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023e0:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801023e7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fc:	39 de                	cmp    %ebx,%esi
801023fe:	72 1c                	jb     8010241c <kinit1+0x5c>
    kfree(p);
80102400:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102406:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102409:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010240f:	50                   	push   %eax
80102410:	e8 cb fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102415:	83 c4 10             	add    $0x10,%esp
80102418:	39 de                	cmp    %ebx,%esi
8010241a:	73 e4                	jae    80102400 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010241c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010241f:	5b                   	pop    %ebx
80102420:	5e                   	pop    %esi
80102421:	5d                   	pop    %ebp
80102422:	c3                   	ret    
80102423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102438:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010243b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102441:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102447:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244d:	39 de                	cmp    %ebx,%esi
8010244f:	72 23                	jb     80102474 <kinit2+0x44>
80102451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102458:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010245e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102461:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102467:	50                   	push   %eax
80102468:	e8 73 fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 e4                	jae    80102458 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102474:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010247b:	00 00 00 
}
8010247e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102481:	5b                   	pop    %ebx
80102482:	5e                   	pop    %esi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    
80102485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 74 36 11 80       	mov    0x80113674,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 1c                	je     801024c6 <kalloc+0x36>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 10                	je     801024c6 <kalloc+0x36>
    release(&kmem.lock);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	68 40 36 11 80       	push   $0x80113640
801024be:	e8 ad 1f 00 00       	call   80104470 <release>
801024c3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024c6:	89 d8                	mov    %ebx,%eax
801024c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024cb:	c9                   	leave  
801024cc:	c3                   	ret    
801024cd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	68 40 36 11 80       	push   $0x80113640
801024d8:	e8 73 1e 00 00       	call   80104350 <acquire>
  r = kmem.freelist;
801024dd:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
801024e3:	83 c4 10             	add    $0x10,%esp
801024e6:	a1 74 36 11 80       	mov    0x80113674,%eax
801024eb:	85 db                	test   %ebx,%ebx
801024ed:	75 bb                	jne    801024aa <kalloc+0x1a>
801024ef:	eb c1                	jmp    801024b2 <kalloc+0x22>
801024f1:	66 90                	xchg   %ax,%ax
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102500:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102501:	ba 64 00 00 00       	mov    $0x64,%edx
80102506:	89 e5                	mov    %esp,%ebp
80102508:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102509:	a8 01                	test   $0x1,%al
8010250b:	0f 84 af 00 00 00    	je     801025c0 <kbdgetc+0xc0>
80102511:	ba 60 00 00 00       	mov    $0x60,%edx
80102516:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102517:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010251a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102520:	74 7e                	je     801025a0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102522:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102524:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010252a:	79 24                	jns    80102550 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010252c:	f6 c1 40             	test   $0x40,%cl
8010252f:	75 05                	jne    80102536 <kbdgetc+0x36>
80102531:	89 c2                	mov    %eax,%edx
80102533:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102536:	0f b6 82 00 7d 10 80 	movzbl -0x7fef8300(%edx),%eax
8010253d:	83 c8 40             	or     $0x40,%eax
80102540:	0f b6 c0             	movzbl %al,%eax
80102543:	f7 d0                	not    %eax
80102545:	21 c8                	and    %ecx,%eax
80102547:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010254c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010254e:	5d                   	pop    %ebp
8010254f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102550:	f6 c1 40             	test   $0x40,%cl
80102553:	74 09                	je     8010255e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102555:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102558:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010255b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010255e:	0f b6 82 00 7d 10 80 	movzbl -0x7fef8300(%edx),%eax
80102565:	09 c1                	or     %eax,%ecx
80102567:	0f b6 82 00 7c 10 80 	movzbl -0x7fef8400(%edx),%eax
8010256e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102570:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102572:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102578:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010257b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010257e:	8b 04 85 e0 7b 10 80 	mov    -0x7fef8420(,%eax,4),%eax
80102585:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102589:	74 c3                	je     8010254e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010258b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010258e:	83 fa 19             	cmp    $0x19,%edx
80102591:	77 1d                	ja     801025b0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102593:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102596:	5d                   	pop    %ebp
80102597:	c3                   	ret    
80102598:	90                   	nop
80102599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801025a0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025a2:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	90                   	nop
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025b0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025b3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025b6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025b7:	83 f9 19             	cmp    $0x19,%ecx
801025ba:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025c5:	5d                   	pop    %ebp
801025c6:	c3                   	ret    
801025c7:	89 f6                	mov    %esi,%esi
801025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025d0 <kbdintr>:

void
kbdintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025d6:	68 00 25 10 80       	push   $0x80102500
801025db:	e8 10 e2 ff ff       	call   801007f0 <consoleintr>
}
801025e0:	83 c4 10             	add    $0x10,%esp
801025e3:	c9                   	leave  
801025e4:	c3                   	ret    
801025e5:	66 90                	xchg   %ax,%ax
801025e7:	66 90                	xchg   %ax,%ax
801025e9:	66 90                	xchg   %ax,%ax
801025eb:	66 90                	xchg   %ax,%ax
801025ed:	66 90                	xchg   %ax,%ax
801025ef:	90                   	nop

801025f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025f0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025f5:	55                   	push   %ebp
801025f6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025f8:	85 c0                	test   %eax,%eax
801025fa:	0f 84 c8 00 00 00    	je     801026c8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102600:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102607:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010260a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010260d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102614:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102617:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010261a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102621:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102624:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102627:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010262e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102631:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102634:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010263b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010263e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102641:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102648:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010264b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010264e:	8b 50 30             	mov    0x30(%eax),%edx
80102651:	c1 ea 10             	shr    $0x10,%edx
80102654:	80 fa 03             	cmp    $0x3,%dl
80102657:	77 77                	ja     801026d0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102659:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102660:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102663:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102666:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010266d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102670:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102673:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010267a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102680:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102687:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
801026a7:	89 f6                	mov    %esi,%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026b6:	80 e6 10             	and    $0x10,%dh
801026b9:	75 f5                	jne    801026b0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026c8:	5d                   	pop    %ebp
801026c9:	c3                   	ret    
801026ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
801026dd:	e9 77 ff ff ff       	jmp    80102659 <lapicinit+0x69>
801026e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026f0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026f0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026f5:	55                   	push   %ebp
801026f6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026f8:	85 c0                	test   %eax,%eax
801026fa:	74 0c                	je     80102708 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026fc:	8b 40 20             	mov    0x20(%eax),%eax
}
801026ff:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102700:	c1 e8 18             	shr    $0x18,%eax
}
80102703:	c3                   	ret    
80102704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102708:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010270a:	5d                   	pop    %ebp
8010270b:	c3                   	ret    
8010270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102710 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102710:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102715:	55                   	push   %ebp
80102716:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102718:	85 c0                	test   %eax,%eax
8010271a:	74 0d                	je     80102729 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102723:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102726:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102729:	5d                   	pop    %ebp
8010272a:	c3                   	ret    
8010272b:	90                   	nop
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102730 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
}
80102733:	5d                   	pop    %ebp
80102734:	c3                   	ret    
80102735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102740:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102741:	ba 70 00 00 00       	mov    $0x70,%edx
80102746:	b8 0f 00 00 00       	mov    $0xf,%eax
8010274b:	89 e5                	mov    %esp,%ebp
8010274d:	53                   	push   %ebx
8010274e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102751:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102754:	ee                   	out    %al,(%dx)
80102755:	ba 71 00 00 00       	mov    $0x71,%edx
8010275a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010275f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102760:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102762:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102765:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010276b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010276d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102770:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102773:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102775:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102778:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102783:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102789:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102793:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102799:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ac:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027b5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027be:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027ca:	5b                   	pop    %ebx
801027cb:	5d                   	pop    %ebp
801027cc:	c3                   	ret    
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801027d0:	55                   	push   %ebp
801027d1:	ba 70 00 00 00       	mov    $0x70,%edx
801027d6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027db:	89 e5                	mov    %esp,%ebp
801027dd:	57                   	push   %edi
801027de:	56                   	push   %esi
801027df:	53                   	push   %ebx
801027e0:	83 ec 4c             	sub    $0x4c,%esp
801027e3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e4:	ba 71 00 00 00       	mov    $0x71,%edx
801027e9:	ec                   	in     (%dx),%al
801027ea:	83 e0 04             	and    $0x4,%eax
801027ed:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f0:	31 db                	xor    %ebx,%ebx
801027f2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027f5:	bf 70 00 00 00       	mov    $0x70,%edi
801027fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102800:	89 d8                	mov    %ebx,%eax
80102802:	89 fa                	mov    %edi,%edx
80102804:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102805:	b9 71 00 00 00       	mov    $0x71,%ecx
8010280a:	89 ca                	mov    %ecx,%edx
8010280c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010280d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102810:	89 fa                	mov    %edi,%edx
80102812:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102815:	b8 02 00 00 00       	mov    $0x2,%eax
8010281a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281b:	89 ca                	mov    %ecx,%edx
8010281d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010281e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102821:	89 fa                	mov    %edi,%edx
80102823:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102826:	b8 04 00 00 00       	mov    $0x4,%eax
8010282b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282c:	89 ca                	mov    %ecx,%edx
8010282e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010282f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102832:	89 fa                	mov    %edi,%edx
80102834:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102837:	b8 07 00 00 00       	mov    $0x7,%eax
8010283c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	89 ca                	mov    %ecx,%edx
8010283f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102840:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102843:	89 fa                	mov    %edi,%edx
80102845:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102848:	b8 08 00 00 00       	mov    $0x8,%eax
8010284d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284e:	89 ca                	mov    %ecx,%edx
80102850:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102851:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102854:	89 fa                	mov    %edi,%edx
80102856:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102859:	b8 09 00 00 00       	mov    $0x9,%eax
8010285e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285f:	89 ca                	mov    %ecx,%edx
80102861:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102862:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102865:	89 fa                	mov    %edi,%edx
80102867:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010286a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010286f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102870:	89 ca                	mov    %ecx,%edx
80102872:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102873:	84 c0                	test   %al,%al
80102875:	78 89                	js     80102800 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102877:	89 d8                	mov    %ebx,%eax
80102879:	89 fa                	mov    %edi,%edx
8010287b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010287f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102882:	89 fa                	mov    %edi,%edx
80102884:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102887:	b8 02 00 00 00       	mov    $0x2,%eax
8010288c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288d:	89 ca                	mov    %ecx,%edx
8010288f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102890:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102893:	89 fa                	mov    %edi,%edx
80102895:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102898:	b8 04 00 00 00       	mov    $0x4,%eax
8010289d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289e:	89 ca                	mov    %ecx,%edx
801028a0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801028a1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a4:	89 fa                	mov    %edi,%edx
801028a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028a9:	b8 07 00 00 00       	mov    $0x7,%eax
801028ae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028af:	89 ca                	mov    %ecx,%edx
801028b1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028b2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b5:	89 fa                	mov    %edi,%edx
801028b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028ba:	b8 08 00 00 00       	mov    $0x8,%eax
801028bf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c0:	89 ca                	mov    %ecx,%edx
801028c2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028c3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c6:	89 fa                	mov    %edi,%edx
801028c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028cb:	b8 09 00 00 00       	mov    $0x9,%eax
801028d0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d1:	89 ca                	mov    %ecx,%edx
801028d3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028d4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028d7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028dd:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028e0:	6a 18                	push   $0x18
801028e2:	56                   	push   %esi
801028e3:	50                   	push   %eax
801028e4:	e8 27 1c 00 00       	call   80104510 <memcmp>
801028e9:	83 c4 10             	add    $0x10,%esp
801028ec:	85 c0                	test   %eax,%eax
801028ee:	0f 85 0c ff ff ff    	jne    80102800 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028f4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028f8:	75 78                	jne    80102972 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028fa:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028fd:	89 c2                	mov    %eax,%edx
801028ff:	83 e0 0f             	and    $0xf,%eax
80102902:	c1 ea 04             	shr    $0x4,%edx
80102905:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102908:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010290e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102911:	89 c2                	mov    %eax,%edx
80102913:	83 e0 0f             	and    $0xf,%eax
80102916:	c1 ea 04             	shr    $0x4,%edx
80102919:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102922:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102925:	89 c2                	mov    %eax,%edx
80102927:	83 e0 0f             	and    $0xf,%eax
8010292a:	c1 ea 04             	shr    $0x4,%edx
8010292d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102930:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102933:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102936:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102939:	89 c2                	mov    %eax,%edx
8010293b:	83 e0 0f             	and    $0xf,%eax
8010293e:	c1 ea 04             	shr    $0x4,%edx
80102941:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102944:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102947:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010294a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010294d:	89 c2                	mov    %eax,%edx
8010294f:	83 e0 0f             	and    $0xf,%eax
80102952:	c1 ea 04             	shr    $0x4,%edx
80102955:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102958:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010295e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102961:	89 c2                	mov    %eax,%edx
80102963:	83 e0 0f             	and    $0xf,%eax
80102966:	c1 ea 04             	shr    $0x4,%edx
80102969:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102972:	8b 75 08             	mov    0x8(%ebp),%esi
80102975:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102978:	89 06                	mov    %eax,(%esi)
8010297a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010297d:	89 46 04             	mov    %eax,0x4(%esi)
80102980:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102983:	89 46 08             	mov    %eax,0x8(%esi)
80102986:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102989:	89 46 0c             	mov    %eax,0xc(%esi)
8010298c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010298f:	89 46 10             	mov    %eax,0x10(%esi)
80102992:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102995:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102998:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010299f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029a2:	5b                   	pop    %ebx
801029a3:	5e                   	pop    %esi
801029a4:	5f                   	pop    %edi
801029a5:	5d                   	pop    %ebp
801029a6:	c3                   	ret    
801029a7:	66 90                	xchg   %ax,%ax
801029a9:	66 90                	xchg   %ax,%ax
801029ab:	66 90                	xchg   %ax,%ax
801029ad:	66 90                	xchg   %ax,%ax
801029af:	90                   	nop

801029b0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029b0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
801029b6:	85 c9                	test   %ecx,%ecx
801029b8:	0f 8e 85 00 00 00    	jle    80102a43 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029be:	55                   	push   %ebp
801029bf:	89 e5                	mov    %esp,%ebp
801029c1:	57                   	push   %edi
801029c2:	56                   	push   %esi
801029c3:	53                   	push   %ebx
801029c4:	31 db                	xor    %ebx,%ebx
801029c6:	83 ec 0c             	sub    $0xc,%esp
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029d0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801029d5:	83 ec 08             	sub    $0x8,%esp
801029d8:	01 d8                	add    %ebx,%eax
801029da:	83 c0 01             	add    $0x1,%eax
801029dd:	50                   	push   %eax
801029de:	ff 35 c4 36 11 80    	pushl  0x801136c4
801029e4:	e8 e7 d6 ff ff       	call   801000d0 <bread>
801029e9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029eb:	58                   	pop    %eax
801029ec:	5a                   	pop    %edx
801029ed:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
801029f4:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029fa:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029fd:	e8 ce d6 ff ff       	call   801000d0 <bread>
80102a02:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a04:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a07:	83 c4 0c             	add    $0xc,%esp
80102a0a:	68 00 02 00 00       	push   $0x200
80102a0f:	50                   	push   %eax
80102a10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a13:	50                   	push   %eax
80102a14:	e8 57 1b 00 00       	call   80104570 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a19:	89 34 24             	mov    %esi,(%esp)
80102a1c:	e8 7f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a21:	89 3c 24             	mov    %edi,(%esp)
80102a24:	e8 b7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a29:	89 34 24             	mov    %esi,(%esp)
80102a2c:	e8 af d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a31:	83 c4 10             	add    $0x10,%esp
80102a34:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102a3a:	7f 94                	jg     801029d0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a3f:	5b                   	pop    %ebx
80102a40:	5e                   	pop    %esi
80102a41:	5f                   	pop    %edi
80102a42:	5d                   	pop    %ebp
80102a43:	f3 c3                	repz ret 
80102a45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	53                   	push   %ebx
80102a54:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a57:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102a5d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102a63:	e8 68 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a68:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a6e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a71:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a73:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a75:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a78:	7e 1f                	jle    80102a99 <write_head+0x49>
80102a7a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a81:	31 d2                	xor    %edx,%edx
80102a83:	90                   	nop
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a88:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102a8e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a92:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a95:	39 c2                	cmp    %eax,%edx
80102a97:	75 ef                	jne    80102a88 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a99:	83 ec 0c             	sub    $0xc,%esp
80102a9c:	53                   	push   %ebx
80102a9d:	e8 fe d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aa2:	89 1c 24             	mov    %ebx,(%esp)
80102aa5:	e8 36 d7 ff ff       	call   801001e0 <brelse>
}
80102aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aad:	c9                   	leave  
80102aae:	c3                   	ret    
80102aaf:	90                   	nop

80102ab0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	53                   	push   %ebx
80102ab4:	83 ec 2c             	sub    $0x2c,%esp
80102ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aba:	68 00 7e 10 80       	push   $0x80107e00
80102abf:	68 80 36 11 80       	push   $0x80113680
80102ac4:	e8 87 17 00 00       	call   80104250 <initlock>
  readsb(dev, &sb);
80102ac9:	58                   	pop    %eax
80102aca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102acd:	5a                   	pop    %edx
80102ace:	50                   	push   %eax
80102acf:	53                   	push   %ebx
80102ad0:	e8 db e8 ff ff       	call   801013b0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ad5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102adb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102adc:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ae2:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ae8:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aed:	5a                   	pop    %edx
80102aee:	50                   	push   %eax
80102aef:	53                   	push   %ebx
80102af0:	e8 db d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102af5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102af8:	83 c4 10             	add    $0x10,%esp
80102afb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102afd:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102b03:	7e 1c                	jle    80102b21 <initlog+0x71>
80102b05:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b0c:	31 d2                	xor    %edx,%edx
80102b0e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b10:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b14:	83 c2 04             	add    $0x4,%edx
80102b17:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b1d:	39 da                	cmp    %ebx,%edx
80102b1f:	75 ef                	jne    80102b10 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b21:	83 ec 0c             	sub    $0xc,%esp
80102b24:	50                   	push   %eax
80102b25:	e8 b6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b2a:	e8 81 fe ff ff       	call   801029b0 <install_trans>
  log.lh.n = 0;
80102b2f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102b36:	00 00 00 
  write_head(); // clear the log
80102b39:	e8 12 ff ff ff       	call   80102a50 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b41:	c9                   	leave  
80102b42:	c3                   	ret    
80102b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b56:	68 80 36 11 80       	push   $0x80113680
80102b5b:	e8 f0 17 00 00       	call   80104350 <acquire>
80102b60:	83 c4 10             	add    $0x10,%esp
80102b63:	eb 18                	jmp    80102b7d <begin_op+0x2d>
80102b65:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b68:	83 ec 08             	sub    $0x8,%esp
80102b6b:	68 80 36 11 80       	push   $0x80113680
80102b70:	68 80 36 11 80       	push   $0x80113680
80102b75:	e8 56 12 00 00       	call   80103dd0 <sleep>
80102b7a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b7d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102b82:	85 c0                	test   %eax,%eax
80102b84:	75 e2                	jne    80102b68 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b86:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102b8b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102b91:	83 c0 01             	add    $0x1,%eax
80102b94:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b97:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b9a:	83 fa 1e             	cmp    $0x1e,%edx
80102b9d:	7f c9                	jg     80102b68 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b9f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102ba2:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102ba7:	68 80 36 11 80       	push   $0x80113680
80102bac:	e8 bf 18 00 00       	call   80104470 <release>
      break;
    }
  }
}
80102bb1:	83 c4 10             	add    $0x10,%esp
80102bb4:	c9                   	leave  
80102bb5:	c3                   	ret    
80102bb6:	8d 76 00             	lea    0x0(%esi),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	57                   	push   %edi
80102bc4:	56                   	push   %esi
80102bc5:	53                   	push   %ebx
80102bc6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bc9:	68 80 36 11 80       	push   $0x80113680
80102bce:	e8 7d 17 00 00       	call   80104350 <acquire>
  log.outstanding -= 1;
80102bd3:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102bd8:	8b 1d c0 36 11 80    	mov    0x801136c0,%ebx
80102bde:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102be1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102be4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102be6:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102beb:	0f 85 23 01 00 00    	jne    80102d14 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102bf1:	85 c0                	test   %eax,%eax
80102bf3:	0f 85 f7 00 00 00    	jne    80102cf0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bf9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bfc:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102c03:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c06:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c08:	68 80 36 11 80       	push   $0x80113680
80102c0d:	e8 5e 18 00 00       	call   80104470 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c12:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102c18:	83 c4 10             	add    $0x10,%esp
80102c1b:	85 c9                	test   %ecx,%ecx
80102c1d:	0f 8e 8a 00 00 00    	jle    80102cad <end_op+0xed>
80102c23:	90                   	nop
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c28:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c2d:	83 ec 08             	sub    $0x8,%esp
80102c30:	01 d8                	add    %ebx,%eax
80102c32:	83 c0 01             	add    $0x1,%eax
80102c35:	50                   	push   %eax
80102c36:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c3c:	e8 8f d4 ff ff       	call   801000d0 <bread>
80102c41:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c43:	58                   	pop    %eax
80102c44:	5a                   	pop    %edx
80102c45:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102c4c:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c52:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c55:	e8 76 d4 ff ff       	call   801000d0 <bread>
80102c5a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c5c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c5f:	83 c4 0c             	add    $0xc,%esp
80102c62:	68 00 02 00 00       	push   $0x200
80102c67:	50                   	push   %eax
80102c68:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c6b:	50                   	push   %eax
80102c6c:	e8 ff 18 00 00       	call   80104570 <memmove>
    bwrite(to);  // write the log
80102c71:	89 34 24             	mov    %esi,(%esp)
80102c74:	e8 27 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c79:	89 3c 24             	mov    %edi,(%esp)
80102c7c:	e8 5f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 57 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c89:	83 c4 10             	add    $0x10,%esp
80102c8c:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102c92:	7c 94                	jl     80102c28 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c94:	e8 b7 fd ff ff       	call   80102a50 <write_head>
    install_trans(); // Now install writes to home locations
80102c99:	e8 12 fd ff ff       	call   801029b0 <install_trans>
    log.lh.n = 0;
80102c9e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ca5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ca8:	e8 a3 fd ff ff       	call   80102a50 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cad:	83 ec 0c             	sub    $0xc,%esp
80102cb0:	68 80 36 11 80       	push   $0x80113680
80102cb5:	e8 96 16 00 00       	call   80104350 <acquire>
    log.committing = 0;
    wakeup(&log);
80102cba:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cc1:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102cc8:	00 00 00 
    wakeup(&log);
80102ccb:	e8 c0 12 00 00       	call   80103f90 <wakeup>
    release(&log.lock);
80102cd0:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102cd7:	e8 94 17 00 00       	call   80104470 <release>
80102cdc:	83 c4 10             	add    $0x10,%esp
  }
}
80102cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce2:	5b                   	pop    %ebx
80102ce3:	5e                   	pop    %esi
80102ce4:	5f                   	pop    %edi
80102ce5:	5d                   	pop    %ebp
80102ce6:	c3                   	ret    
80102ce7:	89 f6                	mov    %esi,%esi
80102ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102cf0:	83 ec 0c             	sub    $0xc,%esp
80102cf3:	68 80 36 11 80       	push   $0x80113680
80102cf8:	e8 93 12 00 00       	call   80103f90 <wakeup>
  }
  release(&log.lock);
80102cfd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d04:	e8 67 17 00 00       	call   80104470 <release>
80102d09:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d0f:	5b                   	pop    %ebx
80102d10:	5e                   	pop    %esi
80102d11:	5f                   	pop    %edi
80102d12:	5d                   	pop    %ebp
80102d13:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d14:	83 ec 0c             	sub    $0xc,%esp
80102d17:	68 04 7e 10 80       	push   $0x80107e04
80102d1c:	e8 4f d6 ff ff       	call   80100370 <panic>
80102d21:	eb 0d                	jmp    80102d30 <log_write>
80102d23:	90                   	nop
80102d24:	90                   	nop
80102d25:	90                   	nop
80102d26:	90                   	nop
80102d27:	90                   	nop
80102d28:	90                   	nop
80102d29:	90                   	nop
80102d2a:	90                   	nop
80102d2b:	90                   	nop
80102d2c:	90                   	nop
80102d2d:	90                   	nop
80102d2e:	90                   	nop
80102d2f:	90                   	nop

80102d30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d37:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d40:	83 fa 1d             	cmp    $0x1d,%edx
80102d43:	0f 8f 97 00 00 00    	jg     80102de0 <log_write+0xb0>
80102d49:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102d4e:	83 e8 01             	sub    $0x1,%eax
80102d51:	39 c2                	cmp    %eax,%edx
80102d53:	0f 8d 87 00 00 00    	jge    80102de0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d59:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d5e:	85 c0                	test   %eax,%eax
80102d60:	0f 8e 87 00 00 00    	jle    80102ded <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	68 80 36 11 80       	push   $0x80113680
80102d6e:	e8 dd 15 00 00       	call   80104350 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d73:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d79:	83 c4 10             	add    $0x10,%esp
80102d7c:	83 fa 00             	cmp    $0x0,%edx
80102d7f:	7e 50                	jle    80102dd1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d81:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d84:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d86:	3b 0d cc 36 11 80    	cmp    0x801136cc,%ecx
80102d8c:	75 0b                	jne    80102d99 <log_write+0x69>
80102d8e:	eb 38                	jmp    80102dc8 <log_write+0x98>
80102d90:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102d97:	74 2f                	je     80102dc8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d99:	83 c0 01             	add    $0x1,%eax
80102d9c:	39 d0                	cmp    %edx,%eax
80102d9e:	75 f0                	jne    80102d90 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102da0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102da7:	83 c2 01             	add    $0x1,%edx
80102daa:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102db0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102db3:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dbd:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dbe:	e9 ad 16 00 00       	jmp    80104470 <release>
80102dc3:	90                   	nop
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dc8:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
80102dcf:	eb df                	jmp    80102db0 <log_write+0x80>
80102dd1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dd4:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102dd9:	75 d5                	jne    80102db0 <log_write+0x80>
80102ddb:	eb ca                	jmp    80102da7 <log_write+0x77>
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102de0:	83 ec 0c             	sub    $0xc,%esp
80102de3:	68 13 7e 10 80       	push   $0x80107e13
80102de8:	e8 83 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ded:	83 ec 0c             	sub    $0xc,%esp
80102df0:	68 29 7e 10 80       	push   $0x80107e29
80102df5:	e8 76 d5 ff ff       	call   80100370 <panic>
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e07:	e8 d4 09 00 00       	call   801037e0 <cpuid>
80102e0c:	89 c3                	mov    %eax,%ebx
80102e0e:	e8 cd 09 00 00       	call   801037e0 <cpuid>
80102e13:	83 ec 04             	sub    $0x4,%esp
80102e16:	53                   	push   %ebx
80102e17:	50                   	push   %eax
80102e18:	68 44 7e 10 80       	push   $0x80107e44
80102e1d:	e8 3e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e22:	e8 d9 29 00 00       	call   80105800 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e27:	e8 34 09 00 00       	call   80103760 <mycpu>
80102e2c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e2e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e33:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e3a:	e8 81 0c 00 00       	call   80103ac0 <scheduler>
80102e3f:	90                   	nop

80102e40 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e46:	e8 d5 3a 00 00       	call   80106920 <switchkvm>
  seginit();
80102e4b:	e8 d0 39 00 00       	call   80106820 <seginit>
  lapicinit();
80102e50:	e8 9b f7 ff ff       	call   801025f0 <lapicinit>
  mpmain();
80102e55:	e8 a6 ff ff ff       	call   80102e00 <mpmain>
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e60:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e64:	83 e4 f0             	and    $0xfffffff0,%esp
80102e67:	ff 71 fc             	pushl  -0x4(%ecx)
80102e6a:	55                   	push   %ebp
80102e6b:	89 e5                	mov    %esp,%ebp
80102e6d:	53                   	push   %ebx
80102e6e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e6f:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e74:	83 ec 08             	sub    $0x8,%esp
80102e77:	68 00 00 40 80       	push   $0x80400000
80102e7c:	68 f8 30 12 80       	push   $0x801230f8
80102e81:	e8 3a f5 ff ff       	call   801023c0 <kinit1>
  kvmalloc();      // kernel page table
80102e86:	e8 35 3f 00 00       	call   80106dc0 <kvmalloc>
  mpinit();        // detect other processors
80102e8b:	e8 80 01 00 00       	call   80103010 <mpinit>
  lapicinit();     // interrupt controller
80102e90:	e8 5b f7 ff ff       	call   801025f0 <lapicinit>
  seginit();       // segment descriptors
80102e95:	e8 86 39 00 00       	call   80106820 <seginit>
  picinit();       // disable pic
80102e9a:	e8 41 03 00 00       	call   801031e0 <picinit>
  ioapicinit();    // another interrupt controller
80102e9f:	e8 4c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ea4:	e8 f7 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102ea9:	e8 42 2c 00 00       	call   80105af0 <uartinit>
  pinit();         // process table
80102eae:	e8 8d 08 00 00       	call   80103740 <pinit>
  tvinit();        // trap vectors
80102eb3:	e8 a8 28 00 00       	call   80105760 <tvinit>
  binit();         // buffer cache
80102eb8:	e8 83 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ebd:	e8 8e de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102ec2:	e8 09 f1 ff ff       	call   80101fd0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ec7:	83 c4 0c             	add    $0xc,%esp
80102eca:	68 8a 00 00 00       	push   $0x8a
80102ecf:	68 8c b4 10 80       	push   $0x8010b48c
80102ed4:	68 00 70 00 80       	push   $0x80007000
80102ed9:	e8 92 16 00 00       	call   80104570 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ede:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102ee5:	00 00 00 
80102ee8:	83 c4 10             	add    $0x10,%esp
80102eeb:	05 80 37 11 80       	add    $0x80113780,%eax
80102ef0:	39 d8                	cmp    %ebx,%eax
80102ef2:	76 6f                	jbe    80102f63 <main+0x103>
80102ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ef8:	e8 63 08 00 00       	call   80103760 <mycpu>
80102efd:	39 d8                	cmp    %ebx,%eax
80102eff:	74 49                	je     80102f4a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f01:	e8 8a f5 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f06:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102f0b:	c7 05 f8 6f 00 80 40 	movl   $0x80102e40,0x80006ff8
80102f12:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f15:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f1c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f1f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f24:	0f b6 03             	movzbl (%ebx),%eax
80102f27:	83 ec 08             	sub    $0x8,%esp
80102f2a:	68 00 70 00 00       	push   $0x7000
80102f2f:	50                   	push   %eax
80102f30:	e8 0b f8 ff ff       	call   80102740 <lapicstartap>
80102f35:	83 c4 10             	add    $0x10,%esp
80102f38:	90                   	nop
80102f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f40:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	74 f6                	je     80102f40 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f4a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102f51:	00 00 00 
80102f54:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f5a:	05 80 37 11 80       	add    $0x80113780,%eax
80102f5f:	39 c3                	cmp    %eax,%ebx
80102f61:	72 95                	jb     80102ef8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f63:	83 ec 08             	sub    $0x8,%esp
80102f66:	68 00 00 00 8e       	push   $0x8e000000
80102f6b:	68 00 00 40 80       	push   $0x80400000
80102f70:	e8 bb f4 ff ff       	call   80102430 <kinit2>
  userinit();      // first user process
80102f75:	e8 b6 08 00 00       	call   80103830 <userinit>
  shmeminit();		//initialize shmem
80102f7a:	e8 61 40 00 00       	call   80106fe0 <shmeminit>
  mpmain();        // finish this processor's setup
80102f7f:	e8 7c fe ff ff       	call   80102e00 <mpmain>
80102f84:	66 90                	xchg   %ax,%ax
80102f86:	66 90                	xchg   %ax,%ax
80102f88:	66 90                	xchg   %ax,%ax
80102f8a:	66 90                	xchg   %ax,%ax
80102f8c:	66 90                	xchg   %ax,%ax
80102f8e:	66 90                	xchg   %ax,%ax

80102f90 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f95:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f9b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f9c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f9f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fa2:	39 de                	cmp    %ebx,%esi
80102fa4:	73 48                	jae    80102fee <mpsearch1+0x5e>
80102fa6:	8d 76 00             	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fb0:	83 ec 04             	sub    $0x4,%esp
80102fb3:	8d 7e 10             	lea    0x10(%esi),%edi
80102fb6:	6a 04                	push   $0x4
80102fb8:	68 58 7e 10 80       	push   $0x80107e58
80102fbd:	56                   	push   %esi
80102fbe:	e8 4d 15 00 00       	call   80104510 <memcmp>
80102fc3:	83 c4 10             	add    $0x10,%esp
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	75 1e                	jne    80102fe8 <mpsearch1+0x58>
80102fca:	8d 7e 10             	lea    0x10(%esi),%edi
80102fcd:	89 f2                	mov    %esi,%edx
80102fcf:	31 c9                	xor    %ecx,%ecx
80102fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fd8:	0f b6 02             	movzbl (%edx),%eax
80102fdb:	83 c2 01             	add    $0x1,%edx
80102fde:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fe0:	39 fa                	cmp    %edi,%edx
80102fe2:	75 f4                	jne    80102fd8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe4:	84 c9                	test   %cl,%cl
80102fe6:	74 10                	je     80102ff8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fe8:	39 fb                	cmp    %edi,%ebx
80102fea:	89 fe                	mov    %edi,%esi
80102fec:	77 c2                	ja     80102fb0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102ff1:	31 c0                	xor    %eax,%eax
}
80102ff3:	5b                   	pop    %ebx
80102ff4:	5e                   	pop    %esi
80102ff5:	5f                   	pop    %edi
80102ff6:	5d                   	pop    %ebp
80102ff7:	c3                   	ret    
80102ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ffb:	89 f0                	mov    %esi,%eax
80102ffd:	5b                   	pop    %ebx
80102ffe:	5e                   	pop    %esi
80102fff:	5f                   	pop    %edi
80103000:	5d                   	pop    %ebp
80103001:	c3                   	ret    
80103002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103010 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	57                   	push   %edi
80103014:	56                   	push   %esi
80103015:	53                   	push   %ebx
80103016:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103019:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103020:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103027:	c1 e0 08             	shl    $0x8,%eax
8010302a:	09 d0                	or     %edx,%eax
8010302c:	c1 e0 04             	shl    $0x4,%eax
8010302f:	85 c0                	test   %eax,%eax
80103031:	75 1b                	jne    8010304e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103033:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010303a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103041:	c1 e0 08             	shl    $0x8,%eax
80103044:	09 d0                	or     %edx,%eax
80103046:	c1 e0 0a             	shl    $0xa,%eax
80103049:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010304e:	ba 00 04 00 00       	mov    $0x400,%edx
80103053:	e8 38 ff ff ff       	call   80102f90 <mpsearch1>
80103058:	85 c0                	test   %eax,%eax
8010305a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010305d:	0f 84 37 01 00 00    	je     8010319a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103063:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103066:	8b 58 04             	mov    0x4(%eax),%ebx
80103069:	85 db                	test   %ebx,%ebx
8010306b:	0f 84 43 01 00 00    	je     801031b4 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103071:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103077:	83 ec 04             	sub    $0x4,%esp
8010307a:	6a 04                	push   $0x4
8010307c:	68 5d 7e 10 80       	push   $0x80107e5d
80103081:	56                   	push   %esi
80103082:	e8 89 14 00 00       	call   80104510 <memcmp>
80103087:	83 c4 10             	add    $0x10,%esp
8010308a:	85 c0                	test   %eax,%eax
8010308c:	0f 85 22 01 00 00    	jne    801031b4 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103092:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103099:	3c 01                	cmp    $0x1,%al
8010309b:	74 08                	je     801030a5 <mpinit+0x95>
8010309d:	3c 04                	cmp    $0x4,%al
8010309f:	0f 85 0f 01 00 00    	jne    801031b4 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030a5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030ac:	85 ff                	test   %edi,%edi
801030ae:	74 21                	je     801030d1 <mpinit+0xc1>
801030b0:	31 d2                	xor    %edx,%edx
801030b2:	31 c0                	xor    %eax,%eax
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030b8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801030bf:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030c0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030c3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030c5:	39 c7                	cmp    %eax,%edi
801030c7:	75 ef                	jne    801030b8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030c9:	84 d2                	test   %dl,%dl
801030cb:	0f 85 e3 00 00 00    	jne    801031b4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030d1:	85 f6                	test   %esi,%esi
801030d3:	0f 84 db 00 00 00    	je     801031b4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030d9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030df:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030e4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030eb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030f1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030f6:	01 d6                	add    %edx,%esi
801030f8:	90                   	nop
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	39 c6                	cmp    %eax,%esi
80103102:	76 23                	jbe    80103127 <mpinit+0x117>
80103104:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103107:	80 fa 04             	cmp    $0x4,%dl
8010310a:	0f 87 c0 00 00 00    	ja     801031d0 <mpinit+0x1c0>
80103110:	ff 24 95 9c 7e 10 80 	jmp    *-0x7fef8164(,%edx,4)
80103117:	89 f6                	mov    %esi,%esi
80103119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103120:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103123:	39 c6                	cmp    %eax,%esi
80103125:	77 dd                	ja     80103104 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103127:	85 db                	test   %ebx,%ebx
80103129:	0f 84 92 00 00 00    	je     801031c1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010312f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103132:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103136:	74 15                	je     8010314d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103138:	ba 22 00 00 00       	mov    $0x22,%edx
8010313d:	b8 70 00 00 00       	mov    $0x70,%eax
80103142:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103143:	ba 23 00 00 00       	mov    $0x23,%edx
80103148:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103149:	83 c8 01             	or     $0x1,%eax
8010314c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010314d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103150:	5b                   	pop    %ebx
80103151:	5e                   	pop    %esi
80103152:	5f                   	pop    %edi
80103153:	5d                   	pop    %ebp
80103154:	c3                   	ret    
80103155:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103158:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
8010315e:	83 f9 07             	cmp    $0x7,%ecx
80103161:	7f 19                	jg     8010317c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103163:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103167:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010316d:	83 c1 01             	add    $0x1,%ecx
80103170:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103176:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010317c:	83 c0 14             	add    $0x14,%eax
      continue;
8010317f:	e9 7c ff ff ff       	jmp    80103100 <mpinit+0xf0>
80103184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103188:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010318c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010318f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
80103195:	e9 66 ff ff ff       	jmp    80103100 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010319a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010319f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031a4:	e8 e7 fd ff ff       	call   80102f90 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031a9:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ae:	0f 85 af fe ff ff    	jne    80103063 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801031b4:	83 ec 0c             	sub    $0xc,%esp
801031b7:	68 62 7e 10 80       	push   $0x80107e62
801031bc:	e8 af d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031c1:	83 ec 0c             	sub    $0xc,%esp
801031c4:	68 7c 7e 10 80       	push   $0x80107e7c
801031c9:	e8 a2 d1 ff ff       	call   80100370 <panic>
801031ce:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031d0:	31 db                	xor    %ebx,%ebx
801031d2:	e9 30 ff ff ff       	jmp    80103107 <mpinit+0xf7>
801031d7:	66 90                	xchg   %ax,%ax
801031d9:	66 90                	xchg   %ax,%ax
801031db:	66 90                	xchg   %ax,%ax
801031dd:	66 90                	xchg   %ax,%ax
801031df:	90                   	nop

801031e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	ba 21 00 00 00       	mov    $0x21,%edx
801031e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031eb:	89 e5                	mov    %esp,%ebp
801031ed:	ee                   	out    %al,(%dx)
801031ee:	ba a1 00 00 00       	mov    $0xa1,%edx
801031f3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031f4:	5d                   	pop    %ebp
801031f5:	c3                   	ret    
801031f6:	66 90                	xchg   %ax,%ax
801031f8:	66 90                	xchg   %ax,%ax
801031fa:	66 90                	xchg   %ax,%ax
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	57                   	push   %edi
80103204:	56                   	push   %esi
80103205:	53                   	push   %ebx
80103206:	83 ec 0c             	sub    $0xc,%esp
80103209:	8b 75 08             	mov    0x8(%ebp),%esi
8010320c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010320f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103215:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010321b:	e8 50 db ff ff       	call   80100d70 <filealloc>
80103220:	85 c0                	test   %eax,%eax
80103222:	89 06                	mov    %eax,(%esi)
80103224:	0f 84 a8 00 00 00    	je     801032d2 <pipealloc+0xd2>
8010322a:	e8 41 db ff ff       	call   80100d70 <filealloc>
8010322f:	85 c0                	test   %eax,%eax
80103231:	89 03                	mov    %eax,(%ebx)
80103233:	0f 84 87 00 00 00    	je     801032c0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103239:	e8 52 f2 ff ff       	call   80102490 <kalloc>
8010323e:	85 c0                	test   %eax,%eax
80103240:	89 c7                	mov    %eax,%edi
80103242:	0f 84 b0 00 00 00    	je     801032f8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103248:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010324b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103252:	00 00 00 
  p->writeopen = 1;
80103255:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010325c:	00 00 00 
  p->nwrite = 0;
8010325f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103266:	00 00 00 
  p->nread = 0;
80103269:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103270:	00 00 00 
  initlock(&p->lock, "pipe");
80103273:	68 b0 7e 10 80       	push   $0x80107eb0
80103278:	50                   	push   %eax
80103279:	e8 d2 0f 00 00       	call   80104250 <initlock>
  (*f0)->type = FD_PIPE;
8010327e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103280:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103283:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103289:	8b 06                	mov    (%esi),%eax
8010328b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010328f:	8b 06                	mov    (%esi),%eax
80103291:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103295:	8b 06                	mov    (%esi),%eax
80103297:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010329a:	8b 03                	mov    (%ebx),%eax
8010329c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801032a2:	8b 03                	mov    (%ebx),%eax
801032a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801032a8:	8b 03                	mov    (%ebx),%eax
801032aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801032ae:	8b 03                	mov    (%ebx),%eax
801032b0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801032b6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032b8:	5b                   	pop    %ebx
801032b9:	5e                   	pop    %esi
801032ba:	5f                   	pop    %edi
801032bb:	5d                   	pop    %ebp
801032bc:	c3                   	ret    
801032bd:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032c0:	8b 06                	mov    (%esi),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 1e                	je     801032e4 <pipealloc+0xe4>
    fileclose(*f0);
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 61 db ff ff       	call   80100e30 <fileclose>
801032cf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032d2:	8b 03                	mov    (%ebx),%eax
801032d4:	85 c0                	test   %eax,%eax
801032d6:	74 0c                	je     801032e4 <pipealloc+0xe4>
    fileclose(*f1);
801032d8:	83 ec 0c             	sub    $0xc,%esp
801032db:	50                   	push   %eax
801032dc:	e8 4f db ff ff       	call   80100e30 <fileclose>
801032e1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032ec:	5b                   	pop    %ebx
801032ed:	5e                   	pop    %esi
801032ee:	5f                   	pop    %edi
801032ef:	5d                   	pop    %ebp
801032f0:	c3                   	ret    
801032f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032f8:	8b 06                	mov    (%esi),%eax
801032fa:	85 c0                	test   %eax,%eax
801032fc:	75 c8                	jne    801032c6 <pipealloc+0xc6>
801032fe:	eb d2                	jmp    801032d2 <pipealloc+0xd2>

80103300 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	56                   	push   %esi
80103304:	53                   	push   %ebx
80103305:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103308:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010330b:	83 ec 0c             	sub    $0xc,%esp
8010330e:	53                   	push   %ebx
8010330f:	e8 3c 10 00 00       	call   80104350 <acquire>
  if(writable){
80103314:	83 c4 10             	add    $0x10,%esp
80103317:	85 f6                	test   %esi,%esi
80103319:	74 45                	je     80103360 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010331b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103321:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103324:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010332b:	00 00 00 
    wakeup(&p->nread);
8010332e:	50                   	push   %eax
8010332f:	e8 5c 0c 00 00       	call   80103f90 <wakeup>
80103334:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103337:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010333d:	85 d2                	test   %edx,%edx
8010333f:	75 0a                	jne    8010334b <pipeclose+0x4b>
80103341:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103347:	85 c0                	test   %eax,%eax
80103349:	74 35                	je     80103380 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010334b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010334e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103351:	5b                   	pop    %ebx
80103352:	5e                   	pop    %esi
80103353:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103354:	e9 17 11 00 00       	jmp    80104470 <release>
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103360:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103366:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103369:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103370:	00 00 00 
    wakeup(&p->nwrite);
80103373:	50                   	push   %eax
80103374:	e8 17 0c 00 00       	call   80103f90 <wakeup>
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	eb b9                	jmp    80103337 <pipeclose+0x37>
8010337e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103380:	83 ec 0c             	sub    $0xc,%esp
80103383:	53                   	push   %ebx
80103384:	e8 e7 10 00 00       	call   80104470 <release>
    kfree((char*)p);
80103389:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010338c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010338f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103392:	5b                   	pop    %ebx
80103393:	5e                   	pop    %esi
80103394:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103395:	e9 46 ef ff ff       	jmp    801022e0 <kfree>
8010339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033a0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
801033a5:	53                   	push   %ebx
801033a6:	83 ec 28             	sub    $0x28,%esp
801033a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033ac:	53                   	push   %ebx
801033ad:	e8 9e 0f 00 00       	call   80104350 <acquire>
  for(i = 0; i < n; i++){
801033b2:	8b 45 10             	mov    0x10(%ebp),%eax
801033b5:	83 c4 10             	add    $0x10,%esp
801033b8:	85 c0                	test   %eax,%eax
801033ba:	0f 8e b9 00 00 00    	jle    80103479 <pipewrite+0xd9>
801033c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033c3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033cf:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033d5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033d8:	03 4d 10             	add    0x10(%ebp),%ecx
801033db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033de:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033e4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033ea:	39 d0                	cmp    %edx,%eax
801033ec:	74 38                	je     80103426 <pipewrite+0x86>
801033ee:	eb 59                	jmp    80103449 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033f0:	e8 0b 04 00 00       	call   80103800 <myproc>
801033f5:	8b 48 24             	mov    0x24(%eax),%ecx
801033f8:	85 c9                	test   %ecx,%ecx
801033fa:	75 34                	jne    80103430 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033fc:	83 ec 0c             	sub    $0xc,%esp
801033ff:	57                   	push   %edi
80103400:	e8 8b 0b 00 00       	call   80103f90 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103405:	58                   	pop    %eax
80103406:	5a                   	pop    %edx
80103407:	53                   	push   %ebx
80103408:	56                   	push   %esi
80103409:	e8 c2 09 00 00       	call   80103dd0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010340e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103414:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010341a:	83 c4 10             	add    $0x10,%esp
8010341d:	05 00 02 00 00       	add    $0x200,%eax
80103422:	39 c2                	cmp    %eax,%edx
80103424:	75 2a                	jne    80103450 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103426:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010342c:	85 c0                	test   %eax,%eax
8010342e:	75 c0                	jne    801033f0 <pipewrite+0x50>
        release(&p->lock);
80103430:	83 ec 0c             	sub    $0xc,%esp
80103433:	53                   	push   %ebx
80103434:	e8 37 10 00 00       	call   80104470 <release>
        return -1;
80103439:	83 c4 10             	add    $0x10,%esp
8010343c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103441:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103444:	5b                   	pop    %ebx
80103445:	5e                   	pop    %esi
80103446:	5f                   	pop    %edi
80103447:	5d                   	pop    %ebp
80103448:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103449:	89 c2                	mov    %eax,%edx
8010344b:	90                   	nop
8010344c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103450:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103453:	8d 42 01             	lea    0x1(%edx),%eax
80103456:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010345a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103460:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103466:	0f b6 09             	movzbl (%ecx),%ecx
80103469:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010346d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103470:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103473:	0f 85 65 ff ff ff    	jne    801033de <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103479:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010347f:	83 ec 0c             	sub    $0xc,%esp
80103482:	50                   	push   %eax
80103483:	e8 08 0b 00 00       	call   80103f90 <wakeup>
  release(&p->lock);
80103488:	89 1c 24             	mov    %ebx,(%esp)
8010348b:	e8 e0 0f 00 00       	call   80104470 <release>
  return n;
80103490:	83 c4 10             	add    $0x10,%esp
80103493:	8b 45 10             	mov    0x10(%ebp),%eax
80103496:	eb a9                	jmp    80103441 <pipewrite+0xa1>
80103498:	90                   	nop
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034a0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 18             	sub    $0x18,%esp
801034a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801034af:	53                   	push   %ebx
801034b0:	e8 9b 0e 00 00       	call   80104350 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034b5:	83 c4 10             	add    $0x10,%esp
801034b8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034be:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801034c4:	75 6a                	jne    80103530 <piperead+0x90>
801034c6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801034cc:	85 f6                	test   %esi,%esi
801034ce:	0f 84 cc 00 00 00    	je     801035a0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034d4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034da:	eb 2d                	jmp    80103509 <piperead+0x69>
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e0:	83 ec 08             	sub    $0x8,%esp
801034e3:	53                   	push   %ebx
801034e4:	56                   	push   %esi
801034e5:	e8 e6 08 00 00       	call   80103dd0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034ea:	83 c4 10             	add    $0x10,%esp
801034ed:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034f3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034f9:	75 35                	jne    80103530 <piperead+0x90>
801034fb:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103501:	85 d2                	test   %edx,%edx
80103503:	0f 84 97 00 00 00    	je     801035a0 <piperead+0x100>
    if(myproc()->killed){
80103509:	e8 f2 02 00 00       	call   80103800 <myproc>
8010350e:	8b 48 24             	mov    0x24(%eax),%ecx
80103511:	85 c9                	test   %ecx,%ecx
80103513:	74 cb                	je     801034e0 <piperead+0x40>
      release(&p->lock);
80103515:	83 ec 0c             	sub    $0xc,%esp
80103518:	53                   	push   %ebx
80103519:	e8 52 0f 00 00       	call   80104470 <release>
      return -1;
8010351e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103521:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103524:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103529:	5b                   	pop    %ebx
8010352a:	5e                   	pop    %esi
8010352b:	5f                   	pop    %edi
8010352c:	5d                   	pop    %ebp
8010352d:	c3                   	ret    
8010352e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103530:	8b 45 10             	mov    0x10(%ebp),%eax
80103533:	85 c0                	test   %eax,%eax
80103535:	7e 69                	jle    801035a0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103537:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010353d:	31 c9                	xor    %ecx,%ecx
8010353f:	eb 15                	jmp    80103556 <piperead+0xb6>
80103541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103548:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010354e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103554:	74 5a                	je     801035b0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103556:	8d 70 01             	lea    0x1(%eax),%esi
80103559:	25 ff 01 00 00       	and    $0x1ff,%eax
8010355e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103564:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103569:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010356c:	83 c1 01             	add    $0x1,%ecx
8010356f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103572:	75 d4                	jne    80103548 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103574:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010357a:	83 ec 0c             	sub    $0xc,%esp
8010357d:	50                   	push   %eax
8010357e:	e8 0d 0a 00 00       	call   80103f90 <wakeup>
  release(&p->lock);
80103583:	89 1c 24             	mov    %ebx,(%esp)
80103586:	e8 e5 0e 00 00       	call   80104470 <release>
  return i;
8010358b:	8b 45 10             	mov    0x10(%ebp),%eax
8010358e:	83 c4 10             	add    $0x10,%esp
}
80103591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103594:	5b                   	pop    %ebx
80103595:	5e                   	pop    %esi
80103596:	5f                   	pop    %edi
80103597:	5d                   	pop    %ebp
80103598:	c3                   	ret    
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035a0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801035a7:	eb cb                	jmp    80103574 <piperead+0xd4>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035b0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801035b3:	eb bf                	jmp    80103574 <piperead+0xd4>
801035b5:	66 90                	xchg   %ax,%ax
801035b7:	66 90                	xchg   %ax,%ax
801035b9:	66 90                	xchg   %ax,%ax
801035bb:	66 90                	xchg   %ax,%ax
801035bd:	66 90                	xchg   %ax,%ax
801035bf:	90                   	nop

801035c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
801035c5:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035c6:	bf 54 3d 11 80       	mov    $0x80113d54,%edi
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035cb:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801035ce:	68 20 3d 11 80       	push   $0x80113d20
801035d3:	e8 78 0d 00 00       	call   80104350 <acquire>
801035d8:	83 c4 10             	add    $0x10,%esp
801035db:	eb 15                	jmp    801035f2 <allocproc+0x32>
801035dd:	8d 76 00             	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035e0:	81 c7 a0 03 00 00    	add    $0x3a0,%edi
801035e6:	81 ff 54 25 12 80    	cmp    $0x80122554,%edi
801035ec:	0f 84 d6 00 00 00    	je     801036c8 <allocproc+0x108>
    if(p->state == UNUSED)
801035f2:	8b 47 0c             	mov    0xc(%edi),%eax
801035f5:	85 c0                	test   %eax,%eax
801035f7:	75 e7                	jne    801035e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035f9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801035fe:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103601:	c7 47 0c 01 00 00 00 	movl   $0x1,0xc(%edi)
  p->pid = nextpid++;

  release(&ptable.lock);
80103608:	68 20 3d 11 80       	push   $0x80113d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
8010360d:	8d 48 01             	lea    0x1(%eax),%ecx
80103610:	89 47 10             	mov    %eax,0x10(%edi)
80103613:	89 0d 04 b0 10 80    	mov    %ecx,0x8010b004

  release(&ptable.lock);
80103619:	e8 52 0e 00 00       	call   80104470 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010361e:	e8 6d ee ff ff       	call   80102490 <kalloc>
80103623:	83 c4 10             	add    $0x10,%esp
80103626:	85 c0                	test   %eax,%eax
80103628:	89 47 08             	mov    %eax,0x8(%edi)
8010362b:	0f 84 b1 00 00 00    	je     801036e2 <allocproc+0x122>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103631:	8d 88 b4 0f 00 00    	lea    0xfb4(%eax),%ecx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103637:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010363a:	05 9c 0f 00 00       	add    $0xf9c,%eax
8010363f:	8d b7 80 00 00 00    	lea    0x80(%edi),%esi
80103645:	8d 9f 80 03 00 00    	lea    0x380(%edi),%ebx
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010364b:	89 4f 18             	mov    %ecx,0x18(%edi)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
8010364e:	c7 40 14 4f 57 10 80 	movl   $0x8010574f,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103655:	6a 14                	push   $0x14
80103657:	6a 00                	push   $0x0
80103659:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010365a:	89 47 1c             	mov    %eax,0x1c(%edi)
  memset(p->context, 0, sizeof *p->context);
8010365d:	e8 5e 0e 00 00       	call   801044c0 <memset>
  p->context->eip = (uint)forkret;
80103662:	8b 47 1c             	mov    0x1c(%edi),%eax
80103665:	8d 8f 80 01 00 00    	lea    0x180(%edi),%ecx
8010366b:	83 c4 10             	add    $0x10,%esp
8010366e:	c7 40 10 f0 36 10 80 	movl   $0x801036f0,0x10(%eax)
80103675:	8d 87 a0 03 00 00    	lea    0x3a0(%edi),%eax
8010367b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010367e:	66 90                	xchg   %ax,%ax
  for (i=0;i<SHMEM_PAGES;i++)
  {
    p->phy_shared_page[i] = 0;
    p->vm_shared_page[i] = 0;
    p->bitmap[i] = 0;
    memset(p->p_key[i].keys,0,sizeof(sh_key_t)*16);
80103680:	83 ec 04             	sub    $0x4,%esp
  p->context->eip = (uint)forkret;

  int i;
  for (i=0;i<SHMEM_PAGES;i++)
  {
    p->phy_shared_page[i] = 0;
80103683:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    p->vm_shared_page[i] = 0;
80103689:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
80103690:	00 00 00 
    p->bitmap[i] = 0;
80103693:	c6 03 00             	movb   $0x0,(%ebx)
    memset(p->p_key[i].keys,0,sizeof(sh_key_t)*16);
80103696:	6a 10                	push   $0x10
80103698:	83 c6 04             	add    $0x4,%esi
8010369b:	6a 00                	push   $0x0
8010369d:	51                   	push   %ecx
8010369e:	83 c3 01             	add    $0x1,%ebx
801036a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801036a4:	e8 17 0e 00 00       	call   801044c0 <memset>
801036a9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  int i;
  for (i=0;i<SHMEM_PAGES;i++)
801036ac:	83 c4 10             	add    $0x10,%esp
801036af:	83 c1 10             	add    $0x10,%ecx
801036b2:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
801036b5:	75 c9                	jne    80103680 <allocproc+0xc0>
801036b7:	89 f8                	mov    %edi,%eax
    memset(p->p_key[i].keys,0,sizeof(sh_key_t)*16);
  }
  //p->top = (void *)(KERNBASE - PGSIZE); 

  return p;
}
801036b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036bc:	5b                   	pop    %ebx
801036bd:	5e                   	pop    %esi
801036be:	5f                   	pop    %edi
801036bf:	5d                   	pop    %ebp
801036c0:	c3                   	ret    
801036c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	68 20 3d 11 80       	push   $0x80113d20
801036d0:	e8 9b 0d 00 00       	call   80104470 <release>
  return 0;
801036d5:	83 c4 10             	add    $0x10,%esp
    memset(p->p_key[i].keys,0,sizeof(sh_key_t)*16);
  }
  //p->top = (void *)(KERNBASE - PGSIZE); 

  return p;
}
801036d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
801036db:	31 c0                	xor    %eax,%eax
    memset(p->p_key[i].keys,0,sizeof(sh_key_t)*16);
  }
  //p->top = (void *)(KERNBASE - PGSIZE); 

  return p;
}
801036dd:	5b                   	pop    %ebx
801036de:	5e                   	pop    %esi
801036df:	5f                   	pop    %edi
801036e0:	5d                   	pop    %ebp
801036e1:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801036e2:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return 0;
801036e9:	eb ce                	jmp    801036b9 <allocproc+0xf9>
801036eb:	90                   	nop
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801036f6:	68 20 3d 11 80       	push   $0x80113d20
801036fb:	e8 70 0d 00 00       	call   80104470 <release>

  if (first) {
80103700:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	85 c0                	test   %eax,%eax
8010370a:	75 04                	jne    80103710 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010370c:	c9                   	leave  
8010370d:	c3                   	ret    
8010370e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103710:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103713:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010371a:	00 00 00 
    iinit(ROOTDEV);
8010371d:	6a 01                	push   $0x1
8010371f:	e8 4c dd ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103724:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010372b:	e8 80 f3 ff ff       	call   80102ab0 <initlog>
80103730:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103733:	c9                   	leave  
80103734:	c3                   	ret    
80103735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103746:	68 b5 7e 10 80       	push   $0x80107eb5
8010374b:	68 20 3d 11 80       	push   $0x80113d20
80103750:	e8 fb 0a 00 00       	call   80104250 <initlock>
}
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	c9                   	leave  
80103759:	c3                   	ret    
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103760 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103765:	9c                   	pushf  
80103766:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103767:	f6 c4 02             	test   $0x2,%ah
8010376a:	75 5b                	jne    801037c7 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010376c:	e8 7f ef ff ff       	call   801026f0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103771:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103777:	85 f6                	test   %esi,%esi
80103779:	7e 3f                	jle    801037ba <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010377b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103782:	39 d0                	cmp    %edx,%eax
80103784:	74 30                	je     801037b6 <mycpu+0x56>
80103786:	b9 30 38 11 80       	mov    $0x80113830,%ecx
8010378b:	31 d2                	xor    %edx,%edx
8010378d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103790:	83 c2 01             	add    $0x1,%edx
80103793:	39 f2                	cmp    %esi,%edx
80103795:	74 23                	je     801037ba <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103797:	0f b6 19             	movzbl (%ecx),%ebx
8010379a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037a0:	39 d8                	cmp    %ebx,%eax
801037a2:	75 ec                	jne    80103790 <mycpu+0x30>
      return &cpus[i];
801037a4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
801037aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037ad:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
801037ae:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
801037b3:	5e                   	pop    %esi
801037b4:	5d                   	pop    %ebp
801037b5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801037b6:	31 d2                	xor    %edx,%edx
801037b8:	eb ea                	jmp    801037a4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801037ba:	83 ec 0c             	sub    $0xc,%esp
801037bd:	68 bc 7e 10 80       	push   $0x80107ebc
801037c2:	e8 a9 cb ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801037c7:	83 ec 0c             	sub    $0xc,%esp
801037ca:	68 9c 7f 10 80       	push   $0x80107f9c
801037cf:	e8 9c cb ff ff       	call   80100370 <panic>
801037d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037e0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037e6:	e8 75 ff ff ff       	call   80103760 <mycpu>
801037eb:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
801037f0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801037f1:	c1 f8 04             	sar    $0x4,%eax
801037f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037fa:	c3                   	ret    
801037fb:	90                   	nop
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103800 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
80103804:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103807:	e8 04 0b 00 00       	call   80104310 <pushcli>
  c = mycpu();
8010380c:	e8 4f ff ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103811:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103817:	e8 e4 0b 00 00       	call   80104400 <popcli>
  return p;
}
8010381c:	83 c4 04             	add    $0x4,%esp
8010381f:	89 d8                	mov    %ebx,%eax
80103821:	5b                   	pop    %ebx
80103822:	5d                   	pop    %ebp
80103823:	c3                   	ret    
80103824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010382a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103830 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	53                   	push   %ebx
80103834:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103837:	e8 84 fd ff ff       	call   801035c0 <allocproc>
8010383c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010383e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103843:	e8 f8 34 00 00       	call   80106d40 <setupkvm>
80103848:	85 c0                	test   %eax,%eax
8010384a:	89 43 04             	mov    %eax,0x4(%ebx)
8010384d:	0f 84 bd 00 00 00    	je     80103910 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103853:	83 ec 04             	sub    $0x4,%esp
80103856:	68 2c 00 00 00       	push   $0x2c
8010385b:	68 60 b4 10 80       	push   $0x8010b460
80103860:	50                   	push   %eax
80103861:	e8 ea 31 00 00       	call   80106a50 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103866:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103869:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010386f:	6a 4c                	push   $0x4c
80103871:	6a 00                	push   $0x0
80103873:	ff 73 18             	pushl  0x18(%ebx)
80103876:	e8 45 0c 00 00       	call   801044c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010387b:	8b 43 18             	mov    0x18(%ebx),%eax
8010387e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103883:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103888:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010388b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010388f:	8b 43 18             	mov    0x18(%ebx),%eax
80103892:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103896:	8b 43 18             	mov    0x18(%ebx),%eax
80103899:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010389d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038a1:	8b 43 18             	mov    0x18(%ebx),%eax
801038a4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038a8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038ac:	8b 43 18             	mov    0x18(%ebx),%eax
801038af:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801038b6:	8b 43 18             	mov    0x18(%ebx),%eax
801038b9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038c0:	8b 43 18             	mov    0x18(%ebx),%eax
801038c3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801038ca:	8d 43 6c             	lea    0x6c(%ebx),%eax
801038cd:	6a 10                	push   $0x10
801038cf:	68 e5 7e 10 80       	push   $0x80107ee5
801038d4:	50                   	push   %eax
801038d5:	e8 e6 0d 00 00       	call   801046c0 <safestrcpy>
  p->cwd = namei("/");
801038da:	c7 04 24 ee 7e 10 80 	movl   $0x80107eee,(%esp)
801038e1:	e8 da e5 ff ff       	call   80101ec0 <namei>
801038e6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801038e9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801038f0:	e8 5b 0a 00 00       	call   80104350 <acquire>

  p->state = RUNNABLE;
801038f5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801038fc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103903:	e8 68 0b 00 00       	call   80104470 <release>
}
80103908:	83 c4 10             	add    $0x10,%esp
8010390b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010390e:	c9                   	leave  
8010390f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103910:	83 ec 0c             	sub    $0xc,%esp
80103913:	68 cc 7e 10 80       	push   $0x80107ecc
80103918:	e8 53 ca ff ff       	call   80100370 <panic>
8010391d:	8d 76 00             	lea    0x0(%esi),%esi

80103920 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
80103925:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103928:	e8 e3 09 00 00       	call   80104310 <pushcli>
  c = mycpu();
8010392d:	e8 2e fe ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103932:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103938:	e8 c3 0a 00 00       	call   80104400 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010393d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103940:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103942:	7e 34                	jle    80103978 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103944:	83 ec 04             	sub    $0x4,%esp
80103947:	01 c6                	add    %eax,%esi
80103949:	56                   	push   %esi
8010394a:	50                   	push   %eax
8010394b:	ff 73 04             	pushl  0x4(%ebx)
8010394e:	e8 3d 32 00 00       	call   80106b90 <allocuvm>
80103953:	83 c4 10             	add    $0x10,%esp
80103956:	85 c0                	test   %eax,%eax
80103958:	74 36                	je     80103990 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
8010395a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
8010395d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010395f:	53                   	push   %ebx
80103960:	e8 db 2f 00 00       	call   80106940 <switchuvm>
  return 0;
80103965:	83 c4 10             	add    $0x10,%esp
80103968:	31 c0                	xor    %eax,%eax
}
8010396a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010396d:	5b                   	pop    %ebx
8010396e:	5e                   	pop    %esi
8010396f:	5d                   	pop    %ebp
80103970:	c3                   	ret    
80103971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103978:	74 e0                	je     8010395a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010397a:	83 ec 04             	sub    $0x4,%esp
8010397d:	01 c6                	add    %eax,%esi
8010397f:	56                   	push   %esi
80103980:	50                   	push   %eax
80103981:	ff 73 04             	pushl  0x4(%ebx)
80103984:	e8 07 33 00 00       	call   80106c90 <deallocuvm>
80103989:	83 c4 10             	add    $0x10,%esp
8010398c:	85 c0                	test   %eax,%eax
8010398e:	75 ca                	jne    8010395a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103995:	eb d3                	jmp    8010396a <growproc+0x4a>
80103997:	89 f6                	mov    %esi,%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039a0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	57                   	push   %edi
801039a4:	56                   	push   %esi
801039a5:	53                   	push   %ebx
801039a6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801039a9:	e8 62 09 00 00       	call   80104310 <pushcli>
  c = mycpu();
801039ae:	e8 ad fd ff ff       	call   80103760 <mycpu>
  p = c->proc;
801039b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039b9:	e8 42 0a 00 00       	call   80104400 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
801039be:	e8 fd fb ff ff       	call   801035c0 <allocproc>
801039c3:	85 c0                	test   %eax,%eax
801039c5:	89 c7                	mov    %eax,%edi
801039c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039ca:	0f 84 b5 00 00 00    	je     80103a85 <fork+0xe5>
    return -1;
  }
  
  // Copy process state from proc. 
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039d0:	83 ec 08             	sub    $0x8,%esp
801039d3:	ff 33                	pushl  (%ebx)
801039d5:	ff 73 04             	pushl  0x4(%ebx)
801039d8:	e8 33 34 00 00       	call   80106e10 <copyuvm>
801039dd:	83 c4 10             	add    $0x10,%esp
801039e0:	85 c0                	test   %eax,%eax
801039e2:	89 47 04             	mov    %eax,0x4(%edi)
801039e5:	0f 84 a1 00 00 00    	je     80103a8c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801039eb:	8b 03                	mov    (%ebx),%eax
801039ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801039f0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801039f2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801039f5:	89 c8                	mov    %ecx,%eax
801039f7:	8b 79 18             	mov    0x18(%ecx),%edi
801039fa:	8b 73 18             	mov    0x18(%ebx),%esi
801039fd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a04:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a06:	8b 40 18             	mov    0x18(%eax),%eax
80103a09:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103a10:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a14:	85 c0                	test   %eax,%eax
80103a16:	74 13                	je     80103a2b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a18:	83 ec 0c             	sub    $0xc,%esp
80103a1b:	50                   	push   %eax
80103a1c:	e8 bf d3 ff ff       	call   80100de0 <filedup>
80103a21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a24:	83 c4 10             	add    $0x10,%esp
80103a27:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a2b:	83 c6 01             	add    $0x1,%esi
80103a2e:	83 fe 10             	cmp    $0x10,%esi
80103a31:	75 dd                	jne    80103a10 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a33:	83 ec 0c             	sub    $0xc,%esp
80103a36:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a39:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a3c:	e8 ff db ff ff       	call   80101640 <idup>
80103a41:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a44:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a47:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a4a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	53                   	push   %ebx
80103a50:	50                   	push   %eax
80103a51:	e8 6a 0c 00 00       	call   801046c0 <safestrcpy>

  pid = np->pid;
80103a56:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103a59:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a60:	e8 eb 08 00 00       	call   80104350 <acquire>

  np->state = RUNNABLE;
80103a65:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103a6c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a73:	e8 f8 09 00 00       	call   80104470 <release>

  return pid;
80103a78:	83 c4 10             	add    $0x10,%esp
80103a7b:	89 d8                	mov    %ebx,%eax
}
80103a7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a80:	5b                   	pop    %ebx
80103a81:	5e                   	pop    %esi
80103a82:	5f                   	pop    %edi
80103a83:	5d                   	pop    %ebp
80103a84:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a8a:	eb f1                	jmp    80103a7d <fork+0xdd>
  }
  
  // Copy process state from proc. 
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103a8c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a8f:	83 ec 0c             	sub    $0xc,%esp
80103a92:	ff 77 08             	pushl  0x8(%edi)
80103a95:	e8 46 e8 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
80103a9a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103aa1:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103aa8:	83 c4 10             	add    $0x10,%esp
80103aab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ab0:	eb cb                	jmp    80103a7d <fork+0xdd>
80103ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	57                   	push   %edi
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103ac9:	e8 92 fc ff ff       	call   80103760 <mycpu>
80103ace:	8d 78 04             	lea    0x4(%eax),%edi
80103ad1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ad3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ada:	00 00 00 
80103add:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ae0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ae1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ae9:	68 20 3d 11 80       	push   $0x80113d20
80103aee:	e8 5d 08 00 00       	call   80104350 <acquire>
80103af3:	83 c4 10             	add    $0x10,%esp
80103af6:	eb 16                	jmp    80103b0e <scheduler+0x4e>
80103af8:	90                   	nop
80103af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b00:	81 c3 a0 03 00 00    	add    $0x3a0,%ebx
80103b06:	81 fb 54 25 12 80    	cmp    $0x80122554,%ebx
80103b0c:	74 52                	je     80103b60 <scheduler+0xa0>
      if(p->state != RUNNABLE)
80103b0e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b12:	75 ec                	jne    80103b00 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103b14:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103b17:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b1d:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b1e:	81 c3 a0 03 00 00    	add    $0x3a0,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103b24:	e8 17 2e 00 00       	call   80106940 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103b29:	58                   	pop    %eax
80103b2a:	5a                   	pop    %edx
80103b2b:	ff b3 7c fc ff ff    	pushl  -0x384(%ebx)
80103b31:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b32:	c7 83 6c fc ff ff 04 	movl   $0x4,-0x394(%ebx)
80103b39:	00 00 00 

      swtch(&(c->scheduler), p->context);
80103b3c:	e8 da 0b 00 00       	call   8010471b <swtch>
      switchkvm();
80103b41:	e8 da 2d 00 00       	call   80106920 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103b46:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b49:	81 fb 54 25 12 80    	cmp    $0x80122554,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103b4f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b56:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b59:	75 b3                	jne    80103b0e <scheduler+0x4e>
80103b5b:	90                   	nop
80103b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103b60:	83 ec 0c             	sub    $0xc,%esp
80103b63:	68 20 3d 11 80       	push   $0x80113d20
80103b68:	e8 03 09 00 00       	call   80104470 <release>

  }
80103b6d:	83 c4 10             	add    $0x10,%esp
80103b70:	e9 6b ff ff ff       	jmp    80103ae0 <scheduler+0x20>
80103b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b80 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	56                   	push   %esi
80103b84:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b85:	e8 86 07 00 00       	call   80104310 <pushcli>
  c = mycpu();
80103b8a:	e8 d1 fb ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103b8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b95:	e8 66 08 00 00       	call   80104400 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103b9a:	83 ec 0c             	sub    $0xc,%esp
80103b9d:	68 20 3d 11 80       	push   $0x80113d20
80103ba2:	e8 29 07 00 00       	call   801042d0 <holding>
80103ba7:	83 c4 10             	add    $0x10,%esp
80103baa:	85 c0                	test   %eax,%eax
80103bac:	74 4f                	je     80103bfd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103bae:	e8 ad fb ff ff       	call   80103760 <mycpu>
80103bb3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103bba:	75 68                	jne    80103c24 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103bbc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103bc0:	74 55                	je     80103c17 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bc2:	9c                   	pushf  
80103bc3:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103bc4:	f6 c4 02             	test   $0x2,%ah
80103bc7:	75 41                	jne    80103c0a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103bc9:	e8 92 fb ff ff       	call   80103760 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103bce:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103bd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103bd7:	e8 84 fb ff ff       	call   80103760 <mycpu>
80103bdc:	83 ec 08             	sub    $0x8,%esp
80103bdf:	ff 70 04             	pushl  0x4(%eax)
80103be2:	53                   	push   %ebx
80103be3:	e8 33 0b 00 00       	call   8010471b <swtch>
  mycpu()->intena = intena;
80103be8:	e8 73 fb ff ff       	call   80103760 <mycpu>
}
80103bed:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103bf0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103bf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf9:	5b                   	pop    %ebx
80103bfa:	5e                   	pop    %esi
80103bfb:	5d                   	pop    %ebp
80103bfc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103bfd:	83 ec 0c             	sub    $0xc,%esp
80103c00:	68 f0 7e 10 80       	push   $0x80107ef0
80103c05:	e8 66 c7 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103c0a:	83 ec 0c             	sub    $0xc,%esp
80103c0d:	68 1c 7f 10 80       	push   $0x80107f1c
80103c12:	e8 59 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103c17:	83 ec 0c             	sub    $0xc,%esp
80103c1a:	68 0e 7f 10 80       	push   $0x80107f0e
80103c1f:	e8 4c c7 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103c24:	83 ec 0c             	sub    $0xc,%esp
80103c27:	68 02 7f 10 80       	push   $0x80107f02
80103c2c:	e8 3f c7 ff ff       	call   80100370 <panic>
80103c31:	eb 0d                	jmp    80103c40 <exit>
80103c33:	90                   	nop
80103c34:	90                   	nop
80103c35:	90                   	nop
80103c36:	90                   	nop
80103c37:	90                   	nop
80103c38:	90                   	nop
80103c39:	90                   	nop
80103c3a:	90                   	nop
80103c3b:	90                   	nop
80103c3c:	90                   	nop
80103c3d:	90                   	nop
80103c3e:	90                   	nop
80103c3f:	90                   	nop

80103c40 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c49:	e8 c2 06 00 00       	call   80104310 <pushcli>
  c = mycpu();
80103c4e:	e8 0d fb ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103c53:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c59:	e8 a2 07 00 00       	call   80104400 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103c5e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103c64:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c67:	8d 7e 68             	lea    0x68(%esi),%edi
80103c6a:	0f 84 01 01 00 00    	je     80103d71 <exit+0x131>
  
  // shmrem("-1");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103c70:	8b 03                	mov    (%ebx),%eax
80103c72:	85 c0                	test   %eax,%eax
80103c74:	74 12                	je     80103c88 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c76:	83 ec 0c             	sub    $0xc,%esp
80103c79:	50                   	push   %eax
80103c7a:	e8 b1 d1 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103c7f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c85:	83 c4 10             	add    $0x10,%esp
80103c88:	83 c3 04             	add    $0x4,%ebx
    panic("init exiting");
  
  // shmrem("-1");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103c8b:	39 df                	cmp    %ebx,%edi
80103c8d:	75 e1                	jne    80103c70 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }
  
  shmrem("-1");
80103c8f:	83 ec 0c             	sub    $0xc,%esp
80103c92:	68 3d 7f 10 80       	push   $0x80107f3d
80103c97:	e8 e4 37 00 00       	call   80107480 <shmrem>

  begin_op();
80103c9c:	e8 af ee ff ff       	call   80102b50 <begin_op>
  iput(curproc->cwd);
80103ca1:	58                   	pop    %eax
80103ca2:	ff 76 68             	pushl  0x68(%esi)
80103ca5:	e8 f6 da ff ff       	call   801017a0 <iput>
  end_op();
80103caa:	e8 11 ef ff ff       	call   80102bc0 <end_op>
  curproc->cwd = 0;
80103caf:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103cb6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cbd:	e8 8e 06 00 00       	call   80104350 <acquire>
  
  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103cc2:	8b 56 14             	mov    0x14(%esi),%edx
80103cc5:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cc8:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ccd:	eb 0d                	jmp    80103cdc <exit+0x9c>
80103ccf:	90                   	nop
80103cd0:	05 a0 03 00 00       	add    $0x3a0,%eax
80103cd5:	3d 54 25 12 80       	cmp    $0x80122554,%eax
80103cda:	74 1e                	je     80103cfa <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103cdc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ce0:	75 ee                	jne    80103cd0 <exit+0x90>
80103ce2:	3b 50 20             	cmp    0x20(%eax),%edx
80103ce5:	75 e9                	jne    80103cd0 <exit+0x90>
      p->state = RUNNABLE;
80103ce7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cee:	05 a0 03 00 00       	add    $0x3a0,%eax
80103cf3:	3d 54 25 12 80       	cmp    $0x80122554,%eax
80103cf8:	75 e2                	jne    80103cdc <exit+0x9c>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103cfa:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80103d00:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103d05:	eb 17                	jmp    80103d1e <exit+0xde>
80103d07:	89 f6                	mov    %esi,%esi
80103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  
  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d10:	81 c2 a0 03 00 00    	add    $0x3a0,%edx
80103d16:	81 fa 54 25 12 80    	cmp    $0x80122554,%edx
80103d1c:	74 3a                	je     80103d58 <exit+0x118>
    if(p->parent == curproc){
80103d1e:	39 72 14             	cmp    %esi,0x14(%edx)
80103d21:	75 ed                	jne    80103d10 <exit+0xd0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103d23:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103d27:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d2a:	75 e4                	jne    80103d10 <exit+0xd0>
80103d2c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103d31:	eb 11                	jmp    80103d44 <exit+0x104>
80103d33:	90                   	nop
80103d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d38:	05 a0 03 00 00       	add    $0x3a0,%eax
80103d3d:	3d 54 25 12 80       	cmp    $0x80122554,%eax
80103d42:	74 cc                	je     80103d10 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103d44:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d48:	75 ee                	jne    80103d38 <exit+0xf8>
80103d4a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d4d:	75 e9                	jne    80103d38 <exit+0xf8>
      p->state = RUNNABLE;
80103d4f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d56:	eb e0                	jmp    80103d38 <exit+0xf8>
        wakeup1(initproc);
    }
  }
  
  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103d58:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d5f:	e8 1c fe ff ff       	call   80103b80 <sched>
  panic("zombie exit");
80103d64:	83 ec 0c             	sub    $0xc,%esp
80103d67:	68 40 7f 10 80       	push   $0x80107f40
80103d6c:	e8 ff c5 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103d71:	83 ec 0c             	sub    $0xc,%esp
80103d74:	68 30 7f 10 80       	push   $0x80107f30
80103d79:	e8 f2 c5 ff ff       	call   80100370 <panic>
80103d7e:	66 90                	xchg   %ax,%ax

80103d80 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	53                   	push   %ebx
80103d84:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d87:	68 20 3d 11 80       	push   $0x80113d20
80103d8c:	e8 bf 05 00 00       	call   80104350 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d91:	e8 7a 05 00 00       	call   80104310 <pushcli>
  c = mycpu();
80103d96:	e8 c5 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103d9b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103da1:	e8 5a 06 00 00       	call   80104400 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103da6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103dad:	e8 ce fd ff ff       	call   80103b80 <sched>
  release(&ptable.lock);
80103db2:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103db9:	e8 b2 06 00 00       	call   80104470 <release>
}
80103dbe:	83 c4 10             	add    $0x10,%esp
80103dc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dc4:	c9                   	leave  
80103dc5:	c3                   	ret    
80103dc6:	8d 76 00             	lea    0x0(%esi),%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dd0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 0c             	sub    $0xc,%esp
80103dd9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ddc:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ddf:	e8 2c 05 00 00       	call   80104310 <pushcli>
  c = mycpu();
80103de4:	e8 77 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103de9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103def:	e8 0c 06 00 00       	call   80104400 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103df4:	85 db                	test   %ebx,%ebx
80103df6:	0f 84 87 00 00 00    	je     80103e83 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103dfc:	85 f6                	test   %esi,%esi
80103dfe:	74 76                	je     80103e76 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e00:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80103e06:	74 50                	je     80103e58 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e08:	83 ec 0c             	sub    $0xc,%esp
80103e0b:	68 20 3d 11 80       	push   $0x80113d20
80103e10:	e8 3b 05 00 00       	call   80104350 <acquire>
    release(lk);
80103e15:	89 34 24             	mov    %esi,(%esp)
80103e18:	e8 53 06 00 00       	call   80104470 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103e1d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e20:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e27:	e8 54 fd ff ff       	call   80103b80 <sched>

  // Tidy up.
  p->chan = 0;
80103e2c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e33:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e3a:	e8 31 06 00 00       	call   80104470 <release>
    acquire(lk);
80103e3f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e42:	83 c4 10             	add    $0x10,%esp
  }
}
80103e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e48:	5b                   	pop    %ebx
80103e49:	5e                   	pop    %esi
80103e4a:	5f                   	pop    %edi
80103e4b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e4c:	e9 ff 04 00 00       	jmp    80104350 <acquire>
80103e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103e58:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e5b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e62:	e8 19 fd ff ff       	call   80103b80 <sched>

  // Tidy up.
  p->chan = 0;
80103e67:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e71:	5b                   	pop    %ebx
80103e72:	5e                   	pop    %esi
80103e73:	5f                   	pop    %edi
80103e74:	5d                   	pop    %ebp
80103e75:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	68 52 7f 10 80       	push   $0x80107f52
80103e7e:	e8 ed c4 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103e83:	83 ec 0c             	sub    $0xc,%esp
80103e86:	68 4c 7f 10 80       	push   $0x80107f4c
80103e8b:	e8 e0 c4 ff ff       	call   80100370 <panic>

80103e90 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	56                   	push   %esi
80103e94:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e95:	e8 76 04 00 00       	call   80104310 <pushcli>
  c = mycpu();
80103e9a:	e8 c1 f8 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103e9f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ea5:	e8 56 05 00 00       	call   80104400 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 20 3d 11 80       	push   $0x80113d20
80103eb2:	e8 99 04 00 00       	call   80104350 <acquire>
80103eb7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103eba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ebc:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103ec1:	eb 13                	jmp    80103ed6 <wait+0x46>
80103ec3:	90                   	nop
80103ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ec8:	81 c3 a0 03 00 00    	add    $0x3a0,%ebx
80103ece:	81 fb 54 25 12 80    	cmp    $0x80122554,%ebx
80103ed4:	74 22                	je     80103ef8 <wait+0x68>
      if(p->parent != curproc)
80103ed6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ed9:	75 ed                	jne    80103ec8 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103edb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103edf:	74 35                	je     80103f16 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee1:	81 c3 a0 03 00 00    	add    $0x3a0,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103ee7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eec:	81 fb 54 25 12 80    	cmp    $0x80122554,%ebx
80103ef2:	75 e2                	jne    80103ed6 <wait+0x46>
80103ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103ef8:	85 c0                	test   %eax,%eax
80103efa:	74 70                	je     80103f6c <wait+0xdc>
80103efc:	8b 46 24             	mov    0x24(%esi),%eax
80103eff:	85 c0                	test   %eax,%eax
80103f01:	75 69                	jne    80103f6c <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f03:	83 ec 08             	sub    $0x8,%esp
80103f06:	68 20 3d 11 80       	push   $0x80113d20
80103f0b:	56                   	push   %esi
80103f0c:	e8 bf fe ff ff       	call   80103dd0 <sleep>
  }
80103f11:	83 c4 10             	add    $0x10,%esp
80103f14:	eb a4                	jmp    80103eba <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f16:	83 ec 0c             	sub    $0xc,%esp
80103f19:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f1c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f1f:	e8 bc e3 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f24:	5a                   	pop    %edx
80103f25:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f28:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f2f:	e8 8c 2d 00 00       	call   80106cc0 <freevm>
        p->pid = 0;
80103f34:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f3b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f42:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f46:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f4d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f54:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f5b:	e8 10 05 00 00       	call   80104470 <release>
        return pid;
80103f60:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f63:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f66:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f68:	5b                   	pop    %ebx
80103f69:	5e                   	pop    %esi
80103f6a:	5d                   	pop    %ebp
80103f6b:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103f6c:	83 ec 0c             	sub    $0xc,%esp
80103f6f:	68 20 3d 11 80       	push   $0x80113d20
80103f74:	e8 f7 04 00 00       	call   80104470 <release>
      return -1;
80103f79:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f84:	5b                   	pop    %ebx
80103f85:	5e                   	pop    %esi
80103f86:	5d                   	pop    %ebp
80103f87:	c3                   	ret    
80103f88:	90                   	nop
80103f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f90 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	53                   	push   %ebx
80103f94:	83 ec 10             	sub    $0x10,%esp
80103f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f9a:	68 20 3d 11 80       	push   $0x80113d20
80103f9f:	e8 ac 03 00 00       	call   80104350 <acquire>
80103fa4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103fac:	eb 0e                	jmp    80103fbc <wakeup+0x2c>
80103fae:	66 90                	xchg   %ax,%ax
80103fb0:	05 a0 03 00 00       	add    $0x3a0,%eax
80103fb5:	3d 54 25 12 80       	cmp    $0x80122554,%eax
80103fba:	74 1e                	je     80103fda <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103fbc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fc0:	75 ee                	jne    80103fb0 <wakeup+0x20>
80103fc2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fc5:	75 e9                	jne    80103fb0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fc7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fce:	05 a0 03 00 00       	add    $0x3a0,%eax
80103fd3:	3d 54 25 12 80       	cmp    $0x80122554,%eax
80103fd8:	75 e2                	jne    80103fbc <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fda:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80103fe1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fe4:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fe5:	e9 86 04 00 00       	jmp    80104470 <release>
80103fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ff0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
80103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103ffa:	68 20 3d 11 80       	push   $0x80113d20
80103fff:	e8 4c 03 00 00       	call   80104350 <acquire>
80104004:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104007:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010400c:	eb 0e                	jmp    8010401c <kill+0x2c>
8010400e:	66 90                	xchg   %ax,%ax
80104010:	05 a0 03 00 00       	add    $0x3a0,%eax
80104015:	3d 54 25 12 80       	cmp    $0x80122554,%eax
8010401a:	74 3c                	je     80104058 <kill+0x68>
    if(p->pid == pid){
8010401c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010401f:	75 ef                	jne    80104010 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104021:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104025:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010402c:	74 1a                	je     80104048 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010402e:	83 ec 0c             	sub    $0xc,%esp
80104031:	68 20 3d 11 80       	push   $0x80113d20
80104036:	e8 35 04 00 00       	call   80104470 <release>
      return 0;
8010403b:	83 c4 10             	add    $0x10,%esp
8010403e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104040:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104043:	c9                   	leave  
80104044:	c3                   	ret    
80104045:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104048:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010404f:	eb dd                	jmp    8010402e <kill+0x3e>
80104051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104058:	83 ec 0c             	sub    $0xc,%esp
8010405b:	68 20 3d 11 80       	push   $0x80113d20
80104060:	e8 0b 04 00 00       	call   80104470 <release>
  return -1;
80104065:	83 c4 10             	add    $0x10,%esp
80104068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010406d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104070:	c9                   	leave  
80104071:	c3                   	ret    
80104072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104080 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104089:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010408e:	83 ec 3c             	sub    $0x3c,%esp
80104091:	eb 27                	jmp    801040ba <procdump+0x3a>
80104093:	90                   	nop
80104094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104098:	83 ec 0c             	sub    $0xc,%esp
8010409b:	68 56 84 10 80       	push   $0x80108456
801040a0:	e8 bb c5 ff ff       	call   80100660 <cprintf>
801040a5:	83 c4 10             	add    $0x10,%esp
801040a8:	81 c3 a0 03 00 00    	add    $0x3a0,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ae:	81 fb c0 25 12 80    	cmp    $0x801225c0,%ebx
801040b4:	0f 84 7e 00 00 00    	je     80104138 <procdump+0xb8>
    if(p->state == UNUSED)
801040ba:	8b 43 a0             	mov    -0x60(%ebx),%eax
801040bd:	85 c0                	test   %eax,%eax
801040bf:	74 e7                	je     801040a8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040c1:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801040c4:	ba 63 7f 10 80       	mov    $0x80107f63,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040c9:	77 11                	ja     801040dc <procdump+0x5c>
801040cb:	8b 14 85 c4 7f 10 80 	mov    -0x7fef803c(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801040d2:	b8 63 7f 10 80       	mov    $0x80107f63,%eax
801040d7:	85 d2                	test   %edx,%edx
801040d9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040dc:	53                   	push   %ebx
801040dd:	52                   	push   %edx
801040de:	ff 73 a4             	pushl  -0x5c(%ebx)
801040e1:	68 67 7f 10 80       	push   $0x80107f67
801040e6:	e8 75 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801040eb:	83 c4 10             	add    $0x10,%esp
801040ee:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801040f2:	75 a4                	jne    80104098 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801040f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040f7:	83 ec 08             	sub    $0x8,%esp
801040fa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040fd:	50                   	push   %eax
801040fe:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104101:	8b 40 0c             	mov    0xc(%eax),%eax
80104104:	83 c0 08             	add    $0x8,%eax
80104107:	50                   	push   %eax
80104108:	e8 63 01 00 00       	call   80104270 <getcallerpcs>
8010410d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104110:	8b 17                	mov    (%edi),%edx
80104112:	85 d2                	test   %edx,%edx
80104114:	74 82                	je     80104098 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104116:	83 ec 08             	sub    $0x8,%esp
80104119:	83 c7 04             	add    $0x4,%edi
8010411c:	52                   	push   %edx
8010411d:	68 a1 79 10 80       	push   $0x801079a1
80104122:	e8 39 c5 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104127:	83 c4 10             	add    $0x10,%esp
8010412a:	39 f7                	cmp    %esi,%edi
8010412c:	75 e2                	jne    80104110 <procdump+0x90>
8010412e:	e9 65 ff ff ff       	jmp    80104098 <procdump+0x18>
80104133:	90                   	nop
80104134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104138:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010413b:	5b                   	pop    %ebx
8010413c:	5e                   	pop    %esi
8010413d:	5f                   	pop    %edi
8010413e:	5d                   	pop    %ebp
8010413f:	c3                   	ret    

80104140 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 0c             	sub    $0xc,%esp
80104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010414a:	68 dc 7f 10 80       	push   $0x80107fdc
8010414f:	8d 43 04             	lea    0x4(%ebx),%eax
80104152:	50                   	push   %eax
80104153:	e8 f8 00 00 00       	call   80104250 <initlock>
  lk->name = name;
80104158:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010415b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104161:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104164:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010416b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010416e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104171:	c9                   	leave  
80104172:	c3                   	ret    
80104173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104180 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	56                   	push   %esi
80104184:	53                   	push   %ebx
80104185:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104188:	83 ec 0c             	sub    $0xc,%esp
8010418b:	8d 73 04             	lea    0x4(%ebx),%esi
8010418e:	56                   	push   %esi
8010418f:	e8 bc 01 00 00       	call   80104350 <acquire>
  while (lk->locked) {
80104194:	8b 13                	mov    (%ebx),%edx
80104196:	83 c4 10             	add    $0x10,%esp
80104199:	85 d2                	test   %edx,%edx
8010419b:	74 16                	je     801041b3 <acquiresleep+0x33>
8010419d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801041a0:	83 ec 08             	sub    $0x8,%esp
801041a3:	56                   	push   %esi
801041a4:	53                   	push   %ebx
801041a5:	e8 26 fc ff ff       	call   80103dd0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801041aa:	8b 03                	mov    (%ebx),%eax
801041ac:	83 c4 10             	add    $0x10,%esp
801041af:	85 c0                	test   %eax,%eax
801041b1:	75 ed                	jne    801041a0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801041b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801041b9:	e8 42 f6 ff ff       	call   80103800 <myproc>
801041be:	8b 40 10             	mov    0x10(%eax),%eax
801041c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801041c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041ca:	5b                   	pop    %ebx
801041cb:	5e                   	pop    %esi
801041cc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801041cd:	e9 9e 02 00 00       	jmp    80104470 <release>
801041d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
801041e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041e8:	83 ec 0c             	sub    $0xc,%esp
801041eb:	8d 73 04             	lea    0x4(%ebx),%esi
801041ee:	56                   	push   %esi
801041ef:	e8 5c 01 00 00       	call   80104350 <acquire>
  lk->locked = 0;
801041f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801041fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104201:	89 1c 24             	mov    %ebx,(%esp)
80104204:	e8 87 fd ff ff       	call   80103f90 <wakeup>
  release(&lk->lk);
80104209:	89 75 08             	mov    %esi,0x8(%ebp)
8010420c:	83 c4 10             	add    $0x10,%esp
}
8010420f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104212:	5b                   	pop    %ebx
80104213:	5e                   	pop    %esi
80104214:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104215:	e9 56 02 00 00       	jmp    80104470 <release>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010422e:	53                   	push   %ebx
8010422f:	e8 1c 01 00 00       	call   80104350 <acquire>
  r = lk->locked;
80104234:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104236:	89 1c 24             	mov    %ebx,(%esp)
80104239:	e8 32 02 00 00       	call   80104470 <release>
  return r;
}
8010423e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104241:	89 f0                	mov    %esi,%eax
80104243:	5b                   	pop    %ebx
80104244:	5e                   	pop    %esi
80104245:	5d                   	pop    %ebp
80104246:	c3                   	ret    
80104247:	66 90                	xchg   %ax,%ax
80104249:	66 90                	xchg   %ax,%ax
8010424b:	66 90                	xchg   %ax,%ax
8010424d:	66 90                	xchg   %ax,%ax
8010424f:	90                   	nop

80104250 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104256:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010425f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104262:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104269:	5d                   	pop    %ebp
8010426a:	c3                   	ret    
8010426b:	90                   	nop
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104270 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104274:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104277:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010427a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010427d:	31 c0                	xor    %eax,%eax
8010427f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104280:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104286:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010428c:	77 1a                	ja     801042a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010428e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104291:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104294:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104297:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104299:	83 f8 0a             	cmp    $0xa,%eax
8010429c:	75 e2                	jne    80104280 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010429e:	5b                   	pop    %ebx
8010429f:	5d                   	pop    %ebp
801042a0:	c3                   	ret    
801042a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801042a8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042af:	83 c0 01             	add    $0x1,%eax
801042b2:	83 f8 0a             	cmp    $0xa,%eax
801042b5:	74 e7                	je     8010429e <getcallerpcs+0x2e>
    pcs[i] = 0;
801042b7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042be:	83 c0 01             	add    $0x1,%eax
801042c1:	83 f8 0a             	cmp    $0xa,%eax
801042c4:	75 e2                	jne    801042a8 <getcallerpcs+0x38>
801042c6:	eb d6                	jmp    8010429e <getcallerpcs+0x2e>
801042c8:	90                   	nop
801042c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042d0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 04             	sub    $0x4,%esp
801042d7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801042da:	8b 02                	mov    (%edx),%eax
801042dc:	85 c0                	test   %eax,%eax
801042de:	75 10                	jne    801042f0 <holding+0x20>
}
801042e0:	83 c4 04             	add    $0x4,%esp
801042e3:	31 c0                	xor    %eax,%eax
801042e5:	5b                   	pop    %ebx
801042e6:	5d                   	pop    %ebp
801042e7:	c3                   	ret    
801042e8:	90                   	nop
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801042f0:	8b 5a 08             	mov    0x8(%edx),%ebx
801042f3:	e8 68 f4 ff ff       	call   80103760 <mycpu>
801042f8:	39 c3                	cmp    %eax,%ebx
801042fa:	0f 94 c0             	sete   %al
}
801042fd:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104300:	0f b6 c0             	movzbl %al,%eax
}
80104303:	5b                   	pop    %ebx
80104304:	5d                   	pop    %ebp
80104305:	c3                   	ret    
80104306:	8d 76 00             	lea    0x0(%esi),%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104310 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 04             	sub    $0x4,%esp
80104317:	9c                   	pushf  
80104318:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104319:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010431a:	e8 41 f4 ff ff       	call   80103760 <mycpu>
8010431f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104325:	85 c0                	test   %eax,%eax
80104327:	75 11                	jne    8010433a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104329:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010432f:	e8 2c f4 ff ff       	call   80103760 <mycpu>
80104334:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010433a:	e8 21 f4 ff ff       	call   80103760 <mycpu>
8010433f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104346:	83 c4 04             	add    $0x4,%esp
80104349:	5b                   	pop    %ebx
8010434a:	5d                   	pop    %ebp
8010434b:	c3                   	ret    
8010434c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104350 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104355:	e8 b6 ff ff ff       	call   80104310 <pushcli>
  if(holding(lk))
8010435a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010435d:	8b 03                	mov    (%ebx),%eax
8010435f:	85 c0                	test   %eax,%eax
80104361:	75 7d                	jne    801043e0 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104363:	ba 01 00 00 00       	mov    $0x1,%edx
80104368:	eb 09                	jmp    80104373 <acquire+0x23>
8010436a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104370:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104373:	89 d0                	mov    %edx,%eax
80104375:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104378:	85 c0                	test   %eax,%eax
8010437a:	75 f4                	jne    80104370 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010437c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104381:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104384:	e8 d7 f3 ff ff       	call   80103760 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104389:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010438b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010438e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104391:	31 c0                	xor    %eax,%eax
80104393:	90                   	nop
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104398:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010439e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043a4:	77 1a                	ja     801043c0 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043a6:	8b 5a 04             	mov    0x4(%edx),%ebx
801043a9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043ac:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801043af:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043b1:	83 f8 0a             	cmp    $0xa,%eax
801043b4:	75 e2                	jne    80104398 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801043b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043b9:	5b                   	pop    %ebx
801043ba:	5e                   	pop    %esi
801043bb:	5d                   	pop    %ebp
801043bc:	c3                   	ret    
801043bd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801043c0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043c7:	83 c0 01             	add    $0x1,%eax
801043ca:	83 f8 0a             	cmp    $0xa,%eax
801043cd:	74 e7                	je     801043b6 <acquire+0x66>
    pcs[i] = 0;
801043cf:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043d6:	83 c0 01             	add    $0x1,%eax
801043d9:	83 f8 0a             	cmp    $0xa,%eax
801043dc:	75 e2                	jne    801043c0 <acquire+0x70>
801043de:	eb d6                	jmp    801043b6 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801043e0:	8b 73 08             	mov    0x8(%ebx),%esi
801043e3:	e8 78 f3 ff ff       	call   80103760 <mycpu>
801043e8:	39 c6                	cmp    %eax,%esi
801043ea:	0f 85 73 ff ff ff    	jne    80104363 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 e7 7f 10 80       	push   $0x80107fe7
801043f8:	e8 73 bf ff ff       	call   80100370 <panic>
801043fd:	8d 76 00             	lea    0x0(%esi),%esi

80104400 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104406:	9c                   	pushf  
80104407:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104408:	f6 c4 02             	test   $0x2,%ah
8010440b:	75 52                	jne    8010445f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010440d:	e8 4e f3 ff ff       	call   80103760 <mycpu>
80104412:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104418:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010441b:	85 d2                	test   %edx,%edx
8010441d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104423:	78 2d                	js     80104452 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104425:	e8 36 f3 ff ff       	call   80103760 <mycpu>
8010442a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104430:	85 d2                	test   %edx,%edx
80104432:	74 0c                	je     80104440 <popcli+0x40>
    sti();
}
80104434:	c9                   	leave  
80104435:	c3                   	ret    
80104436:	8d 76 00             	lea    0x0(%esi),%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104440:	e8 1b f3 ff ff       	call   80103760 <mycpu>
80104445:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010444b:	85 c0                	test   %eax,%eax
8010444d:	74 e5                	je     80104434 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010444f:	fb                   	sti    
    sti();
}
80104450:	c9                   	leave  
80104451:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104452:	83 ec 0c             	sub    $0xc,%esp
80104455:	68 06 80 10 80       	push   $0x80108006
8010445a:	e8 11 bf ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010445f:	83 ec 0c             	sub    $0xc,%esp
80104462:	68 ef 7f 10 80       	push   $0x80107fef
80104467:	e8 04 bf ff ff       	call   80100370 <panic>
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104470 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
80104475:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104478:	8b 03                	mov    (%ebx),%eax
8010447a:	85 c0                	test   %eax,%eax
8010447c:	75 12                	jne    80104490 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010447e:	83 ec 0c             	sub    $0xc,%esp
80104481:	68 0d 80 10 80       	push   $0x8010800d
80104486:	e8 e5 be ff ff       	call   80100370 <panic>
8010448b:	90                   	nop
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104490:	8b 73 08             	mov    0x8(%ebx),%esi
80104493:	e8 c8 f2 ff ff       	call   80103760 <mycpu>
80104498:	39 c6                	cmp    %eax,%esi
8010449a:	75 e2                	jne    8010447e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
8010449c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801044a3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801044aa:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801044af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801044b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b8:	5b                   	pop    %ebx
801044b9:	5e                   	pop    %esi
801044ba:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801044bb:	e9 40 ff ff ff       	jmp    80104400 <popcli>

801044c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	53                   	push   %ebx
801044c5:	8b 55 08             	mov    0x8(%ebp),%edx
801044c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801044cb:	f6 c2 03             	test   $0x3,%dl
801044ce:	75 05                	jne    801044d5 <memset+0x15>
801044d0:	f6 c1 03             	test   $0x3,%cl
801044d3:	74 13                	je     801044e8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801044d5:	89 d7                	mov    %edx,%edi
801044d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044da:	fc                   	cld    
801044db:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044dd:	5b                   	pop    %ebx
801044de:	89 d0                	mov    %edx,%eax
801044e0:	5f                   	pop    %edi
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret    
801044e3:	90                   	nop
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801044e8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801044ec:	c1 e9 02             	shr    $0x2,%ecx
801044ef:	89 fb                	mov    %edi,%ebx
801044f1:	89 f8                	mov    %edi,%eax
801044f3:	c1 e3 18             	shl    $0x18,%ebx
801044f6:	c1 e0 10             	shl    $0x10,%eax
801044f9:	09 d8                	or     %ebx,%eax
801044fb:	09 f8                	or     %edi,%eax
801044fd:	c1 e7 08             	shl    $0x8,%edi
80104500:	09 f8                	or     %edi,%eax
80104502:	89 d7                	mov    %edx,%edi
80104504:	fc                   	cld    
80104505:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104507:	5b                   	pop    %ebx
80104508:	89 d0                	mov    %edx,%eax
8010450a:	5f                   	pop    %edi
8010450b:	5d                   	pop    %ebp
8010450c:	c3                   	ret    
8010450d:	8d 76 00             	lea    0x0(%esi),%esi

80104510 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	56                   	push   %esi
80104515:	8b 45 10             	mov    0x10(%ebp),%eax
80104518:	53                   	push   %ebx
80104519:	8b 75 0c             	mov    0xc(%ebp),%esi
8010451c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010451f:	85 c0                	test   %eax,%eax
80104521:	74 29                	je     8010454c <memcmp+0x3c>
    if(*s1 != *s2)
80104523:	0f b6 13             	movzbl (%ebx),%edx
80104526:	0f b6 0e             	movzbl (%esi),%ecx
80104529:	38 d1                	cmp    %dl,%cl
8010452b:	75 2b                	jne    80104558 <memcmp+0x48>
8010452d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104530:	31 c0                	xor    %eax,%eax
80104532:	eb 14                	jmp    80104548 <memcmp+0x38>
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104538:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010453d:	83 c0 01             	add    $0x1,%eax
80104540:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104544:	38 ca                	cmp    %cl,%dl
80104546:	75 10                	jne    80104558 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104548:	39 f8                	cmp    %edi,%eax
8010454a:	75 ec                	jne    80104538 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010454c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010454d:	31 c0                	xor    %eax,%eax
}
8010454f:	5e                   	pop    %esi
80104550:	5f                   	pop    %edi
80104551:	5d                   	pop    %ebp
80104552:	c3                   	ret    
80104553:	90                   	nop
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104558:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010455b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010455c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010455e:	5e                   	pop    %esi
8010455f:	5f                   	pop    %edi
80104560:	5d                   	pop    %ebp
80104561:	c3                   	ret    
80104562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 45 08             	mov    0x8(%ebp),%eax
80104578:	8b 75 0c             	mov    0xc(%ebp),%esi
8010457b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010457e:	39 c6                	cmp    %eax,%esi
80104580:	73 2e                	jae    801045b0 <memmove+0x40>
80104582:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104585:	39 c8                	cmp    %ecx,%eax
80104587:	73 27                	jae    801045b0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104589:	85 db                	test   %ebx,%ebx
8010458b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010458e:	74 17                	je     801045a7 <memmove+0x37>
      *--d = *--s;
80104590:	29 d9                	sub    %ebx,%ecx
80104592:	89 cb                	mov    %ecx,%ebx
80104594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104598:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010459c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010459f:	83 ea 01             	sub    $0x1,%edx
801045a2:	83 fa ff             	cmp    $0xffffffff,%edx
801045a5:	75 f1                	jne    80104598 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801045a7:	5b                   	pop    %ebx
801045a8:	5e                   	pop    %esi
801045a9:	5d                   	pop    %ebp
801045aa:	c3                   	ret    
801045ab:	90                   	nop
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045b0:	31 d2                	xor    %edx,%edx
801045b2:	85 db                	test   %ebx,%ebx
801045b4:	74 f1                	je     801045a7 <memmove+0x37>
801045b6:	8d 76 00             	lea    0x0(%esi),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801045c0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801045c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045c7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045ca:	39 d3                	cmp    %edx,%ebx
801045cc:	75 f2                	jne    801045c0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801045ce:	5b                   	pop    %ebx
801045cf:	5e                   	pop    %esi
801045d0:	5d                   	pop    %ebp
801045d1:	c3                   	ret    
801045d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801045e3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801045e4:	eb 8a                	jmp    80104570 <memmove>
801045e6:	8d 76 00             	lea    0x0(%esi),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045f0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	57                   	push   %edi
801045f4:	56                   	push   %esi
801045f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045f8:	53                   	push   %ebx
801045f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801045fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801045ff:	85 c9                	test   %ecx,%ecx
80104601:	74 37                	je     8010463a <strncmp+0x4a>
80104603:	0f b6 17             	movzbl (%edi),%edx
80104606:	0f b6 1e             	movzbl (%esi),%ebx
80104609:	84 d2                	test   %dl,%dl
8010460b:	74 3f                	je     8010464c <strncmp+0x5c>
8010460d:	38 d3                	cmp    %dl,%bl
8010460f:	75 3b                	jne    8010464c <strncmp+0x5c>
80104611:	8d 47 01             	lea    0x1(%edi),%eax
80104614:	01 cf                	add    %ecx,%edi
80104616:	eb 1b                	jmp    80104633 <strncmp+0x43>
80104618:	90                   	nop
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104620:	0f b6 10             	movzbl (%eax),%edx
80104623:	84 d2                	test   %dl,%dl
80104625:	74 21                	je     80104648 <strncmp+0x58>
80104627:	0f b6 19             	movzbl (%ecx),%ebx
8010462a:	83 c0 01             	add    $0x1,%eax
8010462d:	89 ce                	mov    %ecx,%esi
8010462f:	38 da                	cmp    %bl,%dl
80104631:	75 19                	jne    8010464c <strncmp+0x5c>
80104633:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104635:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104638:	75 e6                	jne    80104620 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010463a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010463b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010463d:	5e                   	pop    %esi
8010463e:	5f                   	pop    %edi
8010463f:	5d                   	pop    %ebp
80104640:	c3                   	ret    
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104648:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010464c:	0f b6 c2             	movzbl %dl,%eax
8010464f:	29 d8                	sub    %ebx,%eax
}
80104651:	5b                   	pop    %ebx
80104652:	5e                   	pop    %esi
80104653:	5f                   	pop    %edi
80104654:	5d                   	pop    %ebp
80104655:	c3                   	ret    
80104656:	8d 76 00             	lea    0x0(%esi),%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104660 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	8b 45 08             	mov    0x8(%ebp),%eax
80104668:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010466b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010466e:	89 c2                	mov    %eax,%edx
80104670:	eb 19                	jmp    8010468b <strncpy+0x2b>
80104672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104678:	83 c3 01             	add    $0x1,%ebx
8010467b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010467f:	83 c2 01             	add    $0x1,%edx
80104682:	84 c9                	test   %cl,%cl
80104684:	88 4a ff             	mov    %cl,-0x1(%edx)
80104687:	74 09                	je     80104692 <strncpy+0x32>
80104689:	89 f1                	mov    %esi,%ecx
8010468b:	85 c9                	test   %ecx,%ecx
8010468d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104690:	7f e6                	jg     80104678 <strncpy+0x18>
    ;
  while(n-- > 0)
80104692:	31 c9                	xor    %ecx,%ecx
80104694:	85 f6                	test   %esi,%esi
80104696:	7e 17                	jle    801046af <strncpy+0x4f>
80104698:	90                   	nop
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801046a0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801046a4:	89 f3                	mov    %esi,%ebx
801046a6:	83 c1 01             	add    $0x1,%ecx
801046a9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801046ab:	85 db                	test   %ebx,%ebx
801046ad:	7f f1                	jg     801046a0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801046af:	5b                   	pop    %ebx
801046b0:	5e                   	pop    %esi
801046b1:	5d                   	pop    %ebp
801046b2:	c3                   	ret    
801046b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046c8:	8b 45 08             	mov    0x8(%ebp),%eax
801046cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801046ce:	85 c9                	test   %ecx,%ecx
801046d0:	7e 26                	jle    801046f8 <safestrcpy+0x38>
801046d2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046d6:	89 c1                	mov    %eax,%ecx
801046d8:	eb 17                	jmp    801046f1 <safestrcpy+0x31>
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046e0:	83 c2 01             	add    $0x1,%edx
801046e3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046e7:	83 c1 01             	add    $0x1,%ecx
801046ea:	84 db                	test   %bl,%bl
801046ec:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046ef:	74 04                	je     801046f5 <safestrcpy+0x35>
801046f1:	39 f2                	cmp    %esi,%edx
801046f3:	75 eb                	jne    801046e0 <safestrcpy+0x20>
    ;
  *s = 0;
801046f5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801046f8:	5b                   	pop    %ebx
801046f9:	5e                   	pop    %esi
801046fa:	5d                   	pop    %ebp
801046fb:	c3                   	ret    
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104700 <strlen>:

int
strlen(const char *s)
{
80104700:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104701:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104703:	89 e5                	mov    %esp,%ebp
80104705:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104708:	80 3a 00             	cmpb   $0x0,(%edx)
8010470b:	74 0c                	je     80104719 <strlen+0x19>
8010470d:	8d 76 00             	lea    0x0(%esi),%esi
80104710:	83 c0 01             	add    $0x1,%eax
80104713:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104717:	75 f7                	jne    80104710 <strlen+0x10>
    ;
  return n;
}
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    

8010471b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010471b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010471f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104723:	55                   	push   %ebp
  pushl %ebx
80104724:	53                   	push   %ebx
  pushl %esi
80104725:	56                   	push   %esi
  pushl %edi
80104726:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104727:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104729:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010472b:	5f                   	pop    %edi
  popl %esi
8010472c:	5e                   	pop    %esi
  popl %ebx
8010472d:	5b                   	pop    %ebx
  popl %ebp
8010472e:	5d                   	pop    %ebp
  ret
8010472f:	c3                   	ret    

80104730 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 04             	sub    $0x4,%esp
80104737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010473a:	e8 c1 f0 ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010473f:	8b 00                	mov    (%eax),%eax
80104741:	39 d8                	cmp    %ebx,%eax
80104743:	76 1b                	jbe    80104760 <fetchint+0x30>
80104745:	8d 53 04             	lea    0x4(%ebx),%edx
80104748:	39 d0                	cmp    %edx,%eax
8010474a:	72 14                	jb     80104760 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010474c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010474f:	8b 13                	mov    (%ebx),%edx
80104751:	89 10                	mov    %edx,(%eax)
  return 0;
80104753:	31 c0                	xor    %eax,%eax
}
80104755:	83 c4 04             	add    $0x4,%esp
80104758:	5b                   	pop    %ebx
80104759:	5d                   	pop    %ebp
8010475a:	c3                   	ret    
8010475b:	90                   	nop
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104765:	eb ee                	jmp    80104755 <fetchint+0x25>
80104767:	89 f6                	mov    %esi,%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 04             	sub    $0x4,%esp
80104777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010477a:	e8 81 f0 ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz)
8010477f:	39 18                	cmp    %ebx,(%eax)
80104781:	76 29                	jbe    801047ac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104783:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104786:	89 da                	mov    %ebx,%edx
80104788:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010478a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010478c:	39 c3                	cmp    %eax,%ebx
8010478e:	73 1c                	jae    801047ac <fetchstr+0x3c>
    if(*s == 0)
80104790:	80 3b 00             	cmpb   $0x0,(%ebx)
80104793:	75 10                	jne    801047a5 <fetchstr+0x35>
80104795:	eb 29                	jmp    801047c0 <fetchstr+0x50>
80104797:	89 f6                	mov    %esi,%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801047a0:	80 3a 00             	cmpb   $0x0,(%edx)
801047a3:	74 1b                	je     801047c0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801047a5:	83 c2 01             	add    $0x1,%edx
801047a8:	39 d0                	cmp    %edx,%eax
801047aa:	77 f4                	ja     801047a0 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801047ac:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
801047af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801047b4:	5b                   	pop    %ebx
801047b5:	5d                   	pop    %ebp
801047b6:	c3                   	ret    
801047b7:	89 f6                	mov    %esi,%esi
801047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801047c0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801047c3:	89 d0                	mov    %edx,%eax
801047c5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801047c7:	5b                   	pop    %ebx
801047c8:	5d                   	pop    %ebp
801047c9:	c3                   	ret    
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047d5:	e8 26 f0 ff ff       	call   80103800 <myproc>
801047da:	8b 40 18             	mov    0x18(%eax),%eax
801047dd:	8b 55 08             	mov    0x8(%ebp),%edx
801047e0:	8b 40 44             	mov    0x44(%eax),%eax
801047e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
801047e6:	e8 15 f0 ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047eb:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047ed:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047f0:	39 c6                	cmp    %eax,%esi
801047f2:	73 1c                	jae    80104810 <argint+0x40>
801047f4:	8d 53 08             	lea    0x8(%ebx),%edx
801047f7:	39 d0                	cmp    %edx,%eax
801047f9:	72 15                	jb     80104810 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
801047fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801047fe:	8b 53 04             	mov    0x4(%ebx),%edx
80104801:	89 10                	mov    %edx,(%eax)
  return 0;
80104803:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104805:	5b                   	pop    %ebx
80104806:	5e                   	pop    %esi
80104807:	5d                   	pop    %ebp
80104808:	c3                   	ret    
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104815:	eb ee                	jmp    80104805 <argint+0x35>
80104817:	89 f6                	mov    %esi,%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	83 ec 10             	sub    $0x10,%esp
80104828:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010482b:	e8 d0 ef ff ff       	call   80103800 <myproc>
80104830:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104832:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104835:	83 ec 08             	sub    $0x8,%esp
80104838:	50                   	push   %eax
80104839:	ff 75 08             	pushl  0x8(%ebp)
8010483c:	e8 8f ff ff ff       	call   801047d0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104841:	c1 e8 1f             	shr    $0x1f,%eax
80104844:	83 c4 10             	add    $0x10,%esp
80104847:	84 c0                	test   %al,%al
80104849:	75 2d                	jne    80104878 <argptr+0x58>
8010484b:	89 d8                	mov    %ebx,%eax
8010484d:	c1 e8 1f             	shr    $0x1f,%eax
80104850:	84 c0                	test   %al,%al
80104852:	75 24                	jne    80104878 <argptr+0x58>
80104854:	8b 16                	mov    (%esi),%edx
80104856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104859:	39 c2                	cmp    %eax,%edx
8010485b:	76 1b                	jbe    80104878 <argptr+0x58>
8010485d:	01 c3                	add    %eax,%ebx
8010485f:	39 da                	cmp    %ebx,%edx
80104861:	72 15                	jb     80104878 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104863:	8b 55 0c             	mov    0xc(%ebp),%edx
80104866:	89 02                	mov    %eax,(%edx)
  return 0;
80104868:	31 c0                	xor    %eax,%eax
}
8010486a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010486d:	5b                   	pop    %ebx
8010486e:	5e                   	pop    %esi
8010486f:	5d                   	pop    %ebp
80104870:	c3                   	ret    
80104871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104878:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010487d:	eb eb                	jmp    8010486a <argptr+0x4a>
8010487f:	90                   	nop

80104880 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104886:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104889:	50                   	push   %eax
8010488a:	ff 75 08             	pushl  0x8(%ebp)
8010488d:	e8 3e ff ff ff       	call   801047d0 <argint>
80104892:	83 c4 10             	add    $0x10,%esp
80104895:	85 c0                	test   %eax,%eax
80104897:	78 17                	js     801048b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104899:	83 ec 08             	sub    $0x8,%esp
8010489c:	ff 75 0c             	pushl  0xc(%ebp)
8010489f:	ff 75 f4             	pushl  -0xc(%ebp)
801048a2:	e8 c9 fe ff ff       	call   80104770 <fetchstr>
801048a7:	83 c4 10             	add    $0x10,%esp
}
801048aa:	c9                   	leave  
801048ab:	c3                   	ret    
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801048b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801048b5:	c9                   	leave  
801048b6:	c3                   	ret    
801048b7:	89 f6                	mov    %esi,%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048c0 <syscall>:
[SYS_shmrem]   sys_shmrem,
};

void
syscall(void)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801048c5:	e8 36 ef ff ff       	call   80103800 <myproc>

  num = curproc->tf->eax;
801048ca:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801048cd:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801048cf:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801048d2:	8d 50 ff             	lea    -0x1(%eax),%edx
801048d5:	83 fa 16             	cmp    $0x16,%edx
801048d8:	77 1e                	ja     801048f8 <syscall+0x38>
801048da:	8b 14 85 40 80 10 80 	mov    -0x7fef7fc0(,%eax,4),%edx
801048e1:	85 d2                	test   %edx,%edx
801048e3:	74 13                	je     801048f8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801048e5:	ff d2                	call   *%edx
801048e7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801048ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ed:	5b                   	pop    %ebx
801048ee:	5e                   	pop    %esi
801048ef:	5d                   	pop    %ebp
801048f0:	c3                   	ret    
801048f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048f8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801048f9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048fc:	50                   	push   %eax
801048fd:	ff 73 10             	pushl  0x10(%ebx)
80104900:	68 15 80 10 80       	push   $0x80108015
80104905:	e8 56 bd ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010490a:	8b 43 18             	mov    0x18(%ebx),%eax
8010490d:	83 c4 10             	add    $0x10,%esp
80104910:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104917:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010491a:	5b                   	pop    %ebx
8010491b:	5e                   	pop    %esi
8010491c:	5d                   	pop    %ebp
8010491d:	c3                   	ret    
8010491e:	66 90                	xchg   %ax,%ax

80104920 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	56                   	push   %esi
80104925:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104926:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104929:	83 ec 44             	sub    $0x44,%esp
8010492c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010492f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104932:	56                   	push   %esi
80104933:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104934:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104937:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010493a:	e8 a1 d5 ff ff       	call   80101ee0 <nameiparent>
8010493f:	83 c4 10             	add    $0x10,%esp
80104942:	85 c0                	test   %eax,%eax
80104944:	0f 84 f6 00 00 00    	je     80104a40 <create+0x120>
    return 0;
  ilock(dp);
8010494a:	83 ec 0c             	sub    $0xc,%esp
8010494d:	89 c7                	mov    %eax,%edi
8010494f:	50                   	push   %eax
80104950:	e8 1b cd ff ff       	call   80101670 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104955:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104958:	83 c4 0c             	add    $0xc,%esp
8010495b:	50                   	push   %eax
8010495c:	56                   	push   %esi
8010495d:	57                   	push   %edi
8010495e:	e8 3d d2 ff ff       	call   80101ba0 <dirlookup>
80104963:	83 c4 10             	add    $0x10,%esp
80104966:	85 c0                	test   %eax,%eax
80104968:	89 c3                	mov    %eax,%ebx
8010496a:	74 54                	je     801049c0 <create+0xa0>
    iunlockput(dp);
8010496c:	83 ec 0c             	sub    $0xc,%esp
8010496f:	57                   	push   %edi
80104970:	e8 8b cf ff ff       	call   80101900 <iunlockput>
    ilock(ip);
80104975:	89 1c 24             	mov    %ebx,(%esp)
80104978:	e8 f3 cc ff ff       	call   80101670 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104985:	75 19                	jne    801049a0 <create+0x80>
80104987:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010498c:	89 d8                	mov    %ebx,%eax
8010498e:	75 10                	jne    801049a0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104993:	5b                   	pop    %ebx
80104994:	5e                   	pop    %esi
80104995:	5f                   	pop    %edi
80104996:	5d                   	pop    %ebp
80104997:	c3                   	ret    
80104998:	90                   	nop
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801049a0:	83 ec 0c             	sub    $0xc,%esp
801049a3:	53                   	push   %ebx
801049a4:	e8 57 cf ff ff       	call   80101900 <iunlockput>
    return 0;
801049a9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801049af:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049b1:	5b                   	pop    %ebx
801049b2:	5e                   	pop    %esi
801049b3:	5f                   	pop    %edi
801049b4:	5d                   	pop    %ebp
801049b5:	c3                   	ret    
801049b6:	8d 76 00             	lea    0x0(%esi),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801049c0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801049c4:	83 ec 08             	sub    $0x8,%esp
801049c7:	50                   	push   %eax
801049c8:	ff 37                	pushl  (%edi)
801049ca:	e8 31 cb ff ff       	call   80101500 <ialloc>
801049cf:	83 c4 10             	add    $0x10,%esp
801049d2:	85 c0                	test   %eax,%eax
801049d4:	89 c3                	mov    %eax,%ebx
801049d6:	0f 84 cc 00 00 00    	je     80104aa8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
801049dc:	83 ec 0c             	sub    $0xc,%esp
801049df:	50                   	push   %eax
801049e0:	e8 8b cc ff ff       	call   80101670 <ilock>
  ip->major = major;
801049e5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049e9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801049ed:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049f1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801049f5:	b8 01 00 00 00       	mov    $0x1,%eax
801049fa:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801049fe:	89 1c 24             	mov    %ebx,(%esp)
80104a01:	e8 ba cb ff ff       	call   801015c0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104a06:	83 c4 10             	add    $0x10,%esp
80104a09:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104a0e:	74 40                	je     80104a50 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104a10:	83 ec 04             	sub    $0x4,%esp
80104a13:	ff 73 04             	pushl  0x4(%ebx)
80104a16:	56                   	push   %esi
80104a17:	57                   	push   %edi
80104a18:	e8 e3 d3 ff ff       	call   80101e00 <dirlink>
80104a1d:	83 c4 10             	add    $0x10,%esp
80104a20:	85 c0                	test   %eax,%eax
80104a22:	78 77                	js     80104a9b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104a24:	83 ec 0c             	sub    $0xc,%esp
80104a27:	57                   	push   %edi
80104a28:	e8 d3 ce ff ff       	call   80101900 <iunlockput>

  return ip;
80104a2d:	83 c4 10             	add    $0x10,%esp
}
80104a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104a33:	89 d8                	mov    %ebx,%eax
}
80104a35:	5b                   	pop    %ebx
80104a36:	5e                   	pop    %esi
80104a37:	5f                   	pop    %edi
80104a38:	5d                   	pop    %ebp
80104a39:	c3                   	ret    
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104a40:	31 c0                	xor    %eax,%eax
80104a42:	e9 49 ff ff ff       	jmp    80104990 <create+0x70>
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a50:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104a55:	83 ec 0c             	sub    $0xc,%esp
80104a58:	57                   	push   %edi
80104a59:	e8 62 cb ff ff       	call   801015c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a5e:	83 c4 0c             	add    $0xc,%esp
80104a61:	ff 73 04             	pushl  0x4(%ebx)
80104a64:	68 bc 80 10 80       	push   $0x801080bc
80104a69:	53                   	push   %ebx
80104a6a:	e8 91 d3 ff ff       	call   80101e00 <dirlink>
80104a6f:	83 c4 10             	add    $0x10,%esp
80104a72:	85 c0                	test   %eax,%eax
80104a74:	78 18                	js     80104a8e <create+0x16e>
80104a76:	83 ec 04             	sub    $0x4,%esp
80104a79:	ff 77 04             	pushl  0x4(%edi)
80104a7c:	68 bb 80 10 80       	push   $0x801080bb
80104a81:	53                   	push   %ebx
80104a82:	e8 79 d3 ff ff       	call   80101e00 <dirlink>
80104a87:	83 c4 10             	add    $0x10,%esp
80104a8a:	85 c0                	test   %eax,%eax
80104a8c:	79 82                	jns    80104a10 <create+0xf0>
      panic("create dots");
80104a8e:	83 ec 0c             	sub    $0xc,%esp
80104a91:	68 af 80 10 80       	push   $0x801080af
80104a96:	e8 d5 b8 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104a9b:	83 ec 0c             	sub    $0xc,%esp
80104a9e:	68 be 80 10 80       	push   $0x801080be
80104aa3:	e8 c8 b8 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	68 a0 80 10 80       	push   $0x801080a0
80104ab0:	e8 bb b8 ff ff       	call   80100370 <panic>
80104ab5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104ac7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104aca:	89 d3                	mov    %edx,%ebx
80104acc:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104acf:	50                   	push   %eax
80104ad0:	6a 00                	push   $0x0
80104ad2:	e8 f9 fc ff ff       	call   801047d0 <argint>
80104ad7:	83 c4 10             	add    $0x10,%esp
80104ada:	85 c0                	test   %eax,%eax
80104adc:	78 32                	js     80104b10 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ae2:	77 2c                	ja     80104b10 <argfd.constprop.0+0x50>
80104ae4:	e8 17 ed ff ff       	call   80103800 <myproc>
80104ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104af0:	85 c0                	test   %eax,%eax
80104af2:	74 1c                	je     80104b10 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104af4:	85 f6                	test   %esi,%esi
80104af6:	74 02                	je     80104afa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104af8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104afa:	85 db                	test   %ebx,%ebx
80104afc:	74 22                	je     80104b20 <argfd.constprop.0+0x60>
    *pf = f;
80104afe:	89 03                	mov    %eax,(%ebx)
  return 0;
80104b00:	31 c0                	xor    %eax,%eax
}
80104b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b05:	5b                   	pop    %ebx
80104b06:	5e                   	pop    %esi
80104b07:	5d                   	pop    %ebp
80104b08:	c3                   	ret    
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b10:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104b18:	5b                   	pop    %ebx
80104b19:	5e                   	pop    %esi
80104b1a:	5d                   	pop    %ebp
80104b1b:	c3                   	ret    
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104b20:	31 c0                	xor    %eax,%eax
80104b22:	eb de                	jmp    80104b02 <argfd.constprop.0+0x42>
80104b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b30 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104b30:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b31:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	56                   	push   %esi
80104b36:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b37:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104b3a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b3d:	e8 7e ff ff ff       	call   80104ac0 <argfd.constprop.0>
80104b42:	85 c0                	test   %eax,%eax
80104b44:	78 1a                	js     80104b60 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104b46:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104b48:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104b4b:	e8 b0 ec ff ff       	call   80103800 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104b50:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104b54:	85 d2                	test   %edx,%edx
80104b56:	74 18                	je     80104b70 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104b58:	83 c3 01             	add    $0x1,%ebx
80104b5b:	83 fb 10             	cmp    $0x10,%ebx
80104b5e:	75 f0                	jne    80104b50 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b60:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b68:	5b                   	pop    %ebx
80104b69:	5e                   	pop    %esi
80104b6a:	5d                   	pop    %ebp
80104b6b:	c3                   	ret    
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104b70:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b74:	83 ec 0c             	sub    $0xc,%esp
80104b77:	ff 75 f4             	pushl  -0xc(%ebp)
80104b7a:	e8 61 c2 ff ff       	call   80100de0 <filedup>
  return fd;
80104b7f:	83 c4 10             	add    $0x10,%esp
}
80104b82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104b85:	89 d8                	mov    %ebx,%eax
}
80104b87:	5b                   	pop    %ebx
80104b88:	5e                   	pop    %esi
80104b89:	5d                   	pop    %ebp
80104b8a:	c3                   	ret    
80104b8b:	90                   	nop
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b90 <sys_read>:

int
sys_read(void)
{
80104b90:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b91:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104b93:	89 e5                	mov    %esp,%ebp
80104b95:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b98:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b9b:	e8 20 ff ff ff       	call   80104ac0 <argfd.constprop.0>
80104ba0:	85 c0                	test   %eax,%eax
80104ba2:	78 4c                	js     80104bf0 <sys_read+0x60>
80104ba4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ba7:	83 ec 08             	sub    $0x8,%esp
80104baa:	50                   	push   %eax
80104bab:	6a 02                	push   $0x2
80104bad:	e8 1e fc ff ff       	call   801047d0 <argint>
80104bb2:	83 c4 10             	add    $0x10,%esp
80104bb5:	85 c0                	test   %eax,%eax
80104bb7:	78 37                	js     80104bf0 <sys_read+0x60>
80104bb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bbc:	83 ec 04             	sub    $0x4,%esp
80104bbf:	ff 75 f0             	pushl  -0x10(%ebp)
80104bc2:	50                   	push   %eax
80104bc3:	6a 01                	push   $0x1
80104bc5:	e8 56 fc ff ff       	call   80104820 <argptr>
80104bca:	83 c4 10             	add    $0x10,%esp
80104bcd:	85 c0                	test   %eax,%eax
80104bcf:	78 1f                	js     80104bf0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104bd1:	83 ec 04             	sub    $0x4,%esp
80104bd4:	ff 75 f0             	pushl  -0x10(%ebp)
80104bd7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bda:	ff 75 ec             	pushl  -0x14(%ebp)
80104bdd:	e8 6e c3 ff ff       	call   80100f50 <fileread>
80104be2:	83 c4 10             	add    $0x10,%esp
}
80104be5:	c9                   	leave  
80104be6:	c3                   	ret    
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104bf5:	c9                   	leave  
80104bf6:	c3                   	ret    
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <sys_write>:

int
sys_write(void)
{
80104c00:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c01:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104c03:	89 e5                	mov    %esp,%ebp
80104c05:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c08:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c0b:	e8 b0 fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104c10:	85 c0                	test   %eax,%eax
80104c12:	78 4c                	js     80104c60 <sys_write+0x60>
80104c14:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c17:	83 ec 08             	sub    $0x8,%esp
80104c1a:	50                   	push   %eax
80104c1b:	6a 02                	push   $0x2
80104c1d:	e8 ae fb ff ff       	call   801047d0 <argint>
80104c22:	83 c4 10             	add    $0x10,%esp
80104c25:	85 c0                	test   %eax,%eax
80104c27:	78 37                	js     80104c60 <sys_write+0x60>
80104c29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c2c:	83 ec 04             	sub    $0x4,%esp
80104c2f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c32:	50                   	push   %eax
80104c33:	6a 01                	push   $0x1
80104c35:	e8 e6 fb ff ff       	call   80104820 <argptr>
80104c3a:	83 c4 10             	add    $0x10,%esp
80104c3d:	85 c0                	test   %eax,%eax
80104c3f:	78 1f                	js     80104c60 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104c41:	83 ec 04             	sub    $0x4,%esp
80104c44:	ff 75 f0             	pushl  -0x10(%ebp)
80104c47:	ff 75 f4             	pushl  -0xc(%ebp)
80104c4a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c4d:	e8 8e c3 ff ff       	call   80100fe0 <filewrite>
80104c52:	83 c4 10             	add    $0x10,%esp
}
80104c55:	c9                   	leave  
80104c56:	c3                   	ret    
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c65:	c9                   	leave  
80104c66:	c3                   	ret    
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <sys_close>:

int
sys_close(void)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c76:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c79:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c7c:	e8 3f fe ff ff       	call   80104ac0 <argfd.constprop.0>
80104c81:	85 c0                	test   %eax,%eax
80104c83:	78 2b                	js     80104cb0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104c85:	e8 76 eb ff ff       	call   80103800 <myproc>
80104c8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104c8d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104c90:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c97:	00 
  fileclose(f);
80104c98:	ff 75 f4             	pushl  -0xc(%ebp)
80104c9b:	e8 90 c1 ff ff       	call   80100e30 <fileclose>
  return 0;
80104ca0:	83 c4 10             	add    $0x10,%esp
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	c9                   	leave  
80104ca6:	c3                   	ret    
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104cb5:	c9                   	leave  
80104cb6:	c3                   	ret    
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <sys_fstat>:

int
sys_fstat(void)
{
80104cc0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cc1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104cc3:	89 e5                	mov    %esp,%ebp
80104cc5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cc8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104ccb:	e8 f0 fd ff ff       	call   80104ac0 <argfd.constprop.0>
80104cd0:	85 c0                	test   %eax,%eax
80104cd2:	78 2c                	js     80104d00 <sys_fstat+0x40>
80104cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cd7:	83 ec 04             	sub    $0x4,%esp
80104cda:	6a 14                	push   $0x14
80104cdc:	50                   	push   %eax
80104cdd:	6a 01                	push   $0x1
80104cdf:	e8 3c fb ff ff       	call   80104820 <argptr>
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	78 15                	js     80104d00 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104ceb:	83 ec 08             	sub    $0x8,%esp
80104cee:	ff 75 f4             	pushl  -0xc(%ebp)
80104cf1:	ff 75 f0             	pushl  -0x10(%ebp)
80104cf4:	e8 07 c2 ff ff       	call   80100f00 <filestat>
80104cf9:	83 c4 10             	add    $0x10,%esp
}
80104cfc:	c9                   	leave  
80104cfd:	c3                   	ret    
80104cfe:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104d05:	c9                   	leave  
80104d06:	c3                   	ret    
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
80104d15:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d16:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d19:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d1c:	50                   	push   %eax
80104d1d:	6a 00                	push   $0x0
80104d1f:	e8 5c fb ff ff       	call   80104880 <argstr>
80104d24:	83 c4 10             	add    $0x10,%esp
80104d27:	85 c0                	test   %eax,%eax
80104d29:	0f 88 fb 00 00 00    	js     80104e2a <sys_link+0x11a>
80104d2f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d32:	83 ec 08             	sub    $0x8,%esp
80104d35:	50                   	push   %eax
80104d36:	6a 01                	push   $0x1
80104d38:	e8 43 fb ff ff       	call   80104880 <argstr>
80104d3d:	83 c4 10             	add    $0x10,%esp
80104d40:	85 c0                	test   %eax,%eax
80104d42:	0f 88 e2 00 00 00    	js     80104e2a <sys_link+0x11a>
    return -1;

  begin_op();
80104d48:	e8 03 de ff ff       	call   80102b50 <begin_op>
  if((ip = namei(old)) == 0){
80104d4d:	83 ec 0c             	sub    $0xc,%esp
80104d50:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d53:	e8 68 d1 ff ff       	call   80101ec0 <namei>
80104d58:	83 c4 10             	add    $0x10,%esp
80104d5b:	85 c0                	test   %eax,%eax
80104d5d:	89 c3                	mov    %eax,%ebx
80104d5f:	0f 84 f3 00 00 00    	je     80104e58 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104d65:	83 ec 0c             	sub    $0xc,%esp
80104d68:	50                   	push   %eax
80104d69:	e8 02 c9 ff ff       	call   80101670 <ilock>
  if(ip->type == T_DIR){
80104d6e:	83 c4 10             	add    $0x10,%esp
80104d71:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d76:	0f 84 c4 00 00 00    	je     80104e40 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d7c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d81:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d84:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d87:	53                   	push   %ebx
80104d88:	e8 33 c8 ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
80104d8d:	89 1c 24             	mov    %ebx,(%esp)
80104d90:	e8 bb c9 ff ff       	call   80101750 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104d95:	58                   	pop    %eax
80104d96:	5a                   	pop    %edx
80104d97:	57                   	push   %edi
80104d98:	ff 75 d0             	pushl  -0x30(%ebp)
80104d9b:	e8 40 d1 ff ff       	call   80101ee0 <nameiparent>
80104da0:	83 c4 10             	add    $0x10,%esp
80104da3:	85 c0                	test   %eax,%eax
80104da5:	89 c6                	mov    %eax,%esi
80104da7:	74 5b                	je     80104e04 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104da9:	83 ec 0c             	sub    $0xc,%esp
80104dac:	50                   	push   %eax
80104dad:	e8 be c8 ff ff       	call   80101670 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104db2:	83 c4 10             	add    $0x10,%esp
80104db5:	8b 03                	mov    (%ebx),%eax
80104db7:	39 06                	cmp    %eax,(%esi)
80104db9:	75 3d                	jne    80104df8 <sys_link+0xe8>
80104dbb:	83 ec 04             	sub    $0x4,%esp
80104dbe:	ff 73 04             	pushl  0x4(%ebx)
80104dc1:	57                   	push   %edi
80104dc2:	56                   	push   %esi
80104dc3:	e8 38 d0 ff ff       	call   80101e00 <dirlink>
80104dc8:	83 c4 10             	add    $0x10,%esp
80104dcb:	85 c0                	test   %eax,%eax
80104dcd:	78 29                	js     80104df8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104dcf:	83 ec 0c             	sub    $0xc,%esp
80104dd2:	56                   	push   %esi
80104dd3:	e8 28 cb ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104dd8:	89 1c 24             	mov    %ebx,(%esp)
80104ddb:	e8 c0 c9 ff ff       	call   801017a0 <iput>

  end_op();
80104de0:	e8 db dd ff ff       	call   80102bc0 <end_op>

  return 0;
80104de5:	83 c4 10             	add    $0x10,%esp
80104de8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ded:	5b                   	pop    %ebx
80104dee:	5e                   	pop    %esi
80104def:	5f                   	pop    %edi
80104df0:	5d                   	pop    %ebp
80104df1:	c3                   	ret    
80104df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104df8:	83 ec 0c             	sub    $0xc,%esp
80104dfb:	56                   	push   %esi
80104dfc:	e8 ff ca ff ff       	call   80101900 <iunlockput>
    goto bad;
80104e01:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104e04:	83 ec 0c             	sub    $0xc,%esp
80104e07:	53                   	push   %ebx
80104e08:	e8 63 c8 ff ff       	call   80101670 <ilock>
  ip->nlink--;
80104e0d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e12:	89 1c 24             	mov    %ebx,(%esp)
80104e15:	e8 a6 c7 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104e1a:	89 1c 24             	mov    %ebx,(%esp)
80104e1d:	e8 de ca ff ff       	call   80101900 <iunlockput>
  end_op();
80104e22:	e8 99 dd ff ff       	call   80102bc0 <end_op>
  return -1;
80104e27:	83 c4 10             	add    $0x10,%esp
}
80104e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104e2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e32:	5b                   	pop    %ebx
80104e33:	5e                   	pop    %esi
80104e34:	5f                   	pop    %edi
80104e35:	5d                   	pop    %ebp
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	53                   	push   %ebx
80104e44:	e8 b7 ca ff ff       	call   80101900 <iunlockput>
    end_op();
80104e49:	e8 72 dd ff ff       	call   80102bc0 <end_op>
    return -1;
80104e4e:	83 c4 10             	add    $0x10,%esp
80104e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e56:	eb 92                	jmp    80104dea <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104e58:	e8 63 dd ff ff       	call   80102bc0 <end_op>
    return -1;
80104e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e62:	eb 86                	jmp    80104dea <sys_link+0xda>
80104e64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e70 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	56                   	push   %esi
80104e75:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e76:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e79:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e7c:	50                   	push   %eax
80104e7d:	6a 00                	push   $0x0
80104e7f:	e8 fc f9 ff ff       	call   80104880 <argstr>
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	85 c0                	test   %eax,%eax
80104e89:	0f 88 82 01 00 00    	js     80105011 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104e8f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104e92:	e8 b9 dc ff ff       	call   80102b50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e97:	83 ec 08             	sub    $0x8,%esp
80104e9a:	53                   	push   %ebx
80104e9b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e9e:	e8 3d d0 ff ff       	call   80101ee0 <nameiparent>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104eab:	0f 84 6a 01 00 00    	je     8010501b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104eb1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104eb4:	83 ec 0c             	sub    $0xc,%esp
80104eb7:	56                   	push   %esi
80104eb8:	e8 b3 c7 ff ff       	call   80101670 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ebd:	58                   	pop    %eax
80104ebe:	5a                   	pop    %edx
80104ebf:	68 bc 80 10 80       	push   $0x801080bc
80104ec4:	53                   	push   %ebx
80104ec5:	e8 b6 cc ff ff       	call   80101b80 <namecmp>
80104eca:	83 c4 10             	add    $0x10,%esp
80104ecd:	85 c0                	test   %eax,%eax
80104ecf:	0f 84 fc 00 00 00    	je     80104fd1 <sys_unlink+0x161>
80104ed5:	83 ec 08             	sub    $0x8,%esp
80104ed8:	68 bb 80 10 80       	push   $0x801080bb
80104edd:	53                   	push   %ebx
80104ede:	e8 9d cc ff ff       	call   80101b80 <namecmp>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	0f 84 e3 00 00 00    	je     80104fd1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104eee:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ef1:	83 ec 04             	sub    $0x4,%esp
80104ef4:	50                   	push   %eax
80104ef5:	53                   	push   %ebx
80104ef6:	56                   	push   %esi
80104ef7:	e8 a4 cc ff ff       	call   80101ba0 <dirlookup>
80104efc:	83 c4 10             	add    $0x10,%esp
80104eff:	85 c0                	test   %eax,%eax
80104f01:	89 c3                	mov    %eax,%ebx
80104f03:	0f 84 c8 00 00 00    	je     80104fd1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	50                   	push   %eax
80104f0d:	e8 5e c7 ff ff       	call   80101670 <ilock>

  if(ip->nlink < 1)
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f1a:	0f 8e 24 01 00 00    	jle    80105044 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f20:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f25:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104f28:	74 66                	je     80104f90 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104f2a:	83 ec 04             	sub    $0x4,%esp
80104f2d:	6a 10                	push   $0x10
80104f2f:	6a 00                	push   $0x0
80104f31:	56                   	push   %esi
80104f32:	e8 89 f5 ff ff       	call   801044c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f37:	6a 10                	push   $0x10
80104f39:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f3c:	56                   	push   %esi
80104f3d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f40:	e8 0b cb ff ff       	call   80101a50 <writei>
80104f45:	83 c4 20             	add    $0x20,%esp
80104f48:	83 f8 10             	cmp    $0x10,%eax
80104f4b:	0f 85 e6 00 00 00    	jne    80105037 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104f51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f56:	0f 84 9c 00 00 00    	je     80104ff8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104f5c:	83 ec 0c             	sub    $0xc,%esp
80104f5f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f62:	e8 99 c9 ff ff       	call   80101900 <iunlockput>

  ip->nlink--;
80104f67:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f6c:	89 1c 24             	mov    %ebx,(%esp)
80104f6f:	e8 4c c6 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104f74:	89 1c 24             	mov    %ebx,(%esp)
80104f77:	e8 84 c9 ff ff       	call   80101900 <iunlockput>

  end_op();
80104f7c:	e8 3f dc ff ff       	call   80102bc0 <end_op>

  return 0;
80104f81:	83 c4 10             	add    $0x10,%esp
80104f84:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f89:	5b                   	pop    %ebx
80104f8a:	5e                   	pop    %esi
80104f8b:	5f                   	pop    %edi
80104f8c:	5d                   	pop    %ebp
80104f8d:	c3                   	ret    
80104f8e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f90:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f94:	76 94                	jbe    80104f2a <sys_unlink+0xba>
80104f96:	bf 20 00 00 00       	mov    $0x20,%edi
80104f9b:	eb 0f                	jmp    80104fac <sys_unlink+0x13c>
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
80104fa0:	83 c7 10             	add    $0x10,%edi
80104fa3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104fa6:	0f 83 7e ff ff ff    	jae    80104f2a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fac:	6a 10                	push   $0x10
80104fae:	57                   	push   %edi
80104faf:	56                   	push   %esi
80104fb0:	53                   	push   %ebx
80104fb1:	e8 9a c9 ff ff       	call   80101950 <readi>
80104fb6:	83 c4 10             	add    $0x10,%esp
80104fb9:	83 f8 10             	cmp    $0x10,%eax
80104fbc:	75 6c                	jne    8010502a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104fbe:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104fc3:	74 db                	je     80104fa0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104fc5:	83 ec 0c             	sub    $0xc,%esp
80104fc8:	53                   	push   %ebx
80104fc9:	e8 32 c9 ff ff       	call   80101900 <iunlockput>
    goto bad;
80104fce:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104fd1:	83 ec 0c             	sub    $0xc,%esp
80104fd4:	ff 75 b4             	pushl  -0x4c(%ebp)
80104fd7:	e8 24 c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104fdc:	e8 df db ff ff       	call   80102bc0 <end_op>
  return -1;
80104fe1:	83 c4 10             	add    $0x10,%esp
}
80104fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fec:	5b                   	pop    %ebx
80104fed:	5e                   	pop    %esi
80104fee:	5f                   	pop    %edi
80104fef:	5d                   	pop    %ebp
80104ff0:	c3                   	ret    
80104ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104ff8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104ffb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104ffe:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105003:	50                   	push   %eax
80105004:	e8 b7 c5 ff ff       	call   801015c0 <iupdate>
80105009:	83 c4 10             	add    $0x10,%esp
8010500c:	e9 4b ff ff ff       	jmp    80104f5c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105016:	e9 6b ff ff ff       	jmp    80104f86 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010501b:	e8 a0 db ff ff       	call   80102bc0 <end_op>
    return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105025:	e9 5c ff ff ff       	jmp    80104f86 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010502a:	83 ec 0c             	sub    $0xc,%esp
8010502d:	68 e0 80 10 80       	push   $0x801080e0
80105032:	e8 39 b3 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105037:	83 ec 0c             	sub    $0xc,%esp
8010503a:	68 f2 80 10 80       	push   $0x801080f2
8010503f:	e8 2c b3 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	68 ce 80 10 80       	push   $0x801080ce
8010504c:	e8 1f b3 ff ff       	call   80100370 <panic>
80105051:	eb 0d                	jmp    80105060 <sys_open>
80105053:	90                   	nop
80105054:	90                   	nop
80105055:	90                   	nop
80105056:	90                   	nop
80105057:	90                   	nop
80105058:	90                   	nop
80105059:	90                   	nop
8010505a:	90                   	nop
8010505b:	90                   	nop
8010505c:	90                   	nop
8010505d:	90                   	nop
8010505e:	90                   	nop
8010505f:	90                   	nop

80105060 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105066:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105069:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010506c:	50                   	push   %eax
8010506d:	6a 00                	push   $0x0
8010506f:	e8 0c f8 ff ff       	call   80104880 <argstr>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	0f 88 9e 00 00 00    	js     8010511d <sys_open+0xbd>
8010507f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105082:	83 ec 08             	sub    $0x8,%esp
80105085:	50                   	push   %eax
80105086:	6a 01                	push   $0x1
80105088:	e8 43 f7 ff ff       	call   801047d0 <argint>
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	85 c0                	test   %eax,%eax
80105092:	0f 88 85 00 00 00    	js     8010511d <sys_open+0xbd>
    return -1;

  begin_op();
80105098:	e8 b3 da ff ff       	call   80102b50 <begin_op>

  if(omode & O_CREATE){
8010509d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801050a1:	0f 85 89 00 00 00    	jne    80105130 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801050a7:	83 ec 0c             	sub    $0xc,%esp
801050aa:	ff 75 e0             	pushl  -0x20(%ebp)
801050ad:	e8 0e ce ff ff       	call   80101ec0 <namei>
801050b2:	83 c4 10             	add    $0x10,%esp
801050b5:	85 c0                	test   %eax,%eax
801050b7:	89 c6                	mov    %eax,%esi
801050b9:	0f 84 8e 00 00 00    	je     8010514d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801050bf:	83 ec 0c             	sub    $0xc,%esp
801050c2:	50                   	push   %eax
801050c3:	e8 a8 c5 ff ff       	call   80101670 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801050c8:	83 c4 10             	add    $0x10,%esp
801050cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801050d0:	0f 84 d2 00 00 00    	je     801051a8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801050d6:	e8 95 bc ff ff       	call   80100d70 <filealloc>
801050db:	85 c0                	test   %eax,%eax
801050dd:	89 c7                	mov    %eax,%edi
801050df:	74 2b                	je     8010510c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801050e1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801050e3:	e8 18 e7 ff ff       	call   80103800 <myproc>
801050e8:	90                   	nop
801050e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801050f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050f4:	85 d2                	test   %edx,%edx
801050f6:	74 68                	je     80105160 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801050f8:	83 c3 01             	add    $0x1,%ebx
801050fb:	83 fb 10             	cmp    $0x10,%ebx
801050fe:	75 f0                	jne    801050f0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105100:	83 ec 0c             	sub    $0xc,%esp
80105103:	57                   	push   %edi
80105104:	e8 27 bd ff ff       	call   80100e30 <fileclose>
80105109:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	56                   	push   %esi
80105110:	e8 eb c7 ff ff       	call   80101900 <iunlockput>
    end_op();
80105115:	e8 a6 da ff ff       	call   80102bc0 <end_op>
    return -1;
8010511a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010511d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105125:	5b                   	pop    %ebx
80105126:	5e                   	pop    %esi
80105127:	5f                   	pop    %edi
80105128:	5d                   	pop    %ebp
80105129:	c3                   	ret    
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105136:	31 c9                	xor    %ecx,%ecx
80105138:	6a 00                	push   $0x0
8010513a:	ba 02 00 00 00       	mov    $0x2,%edx
8010513f:	e8 dc f7 ff ff       	call   80104920 <create>
    if(ip == 0){
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105149:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010514b:	75 89                	jne    801050d6 <sys_open+0x76>
      end_op();
8010514d:	e8 6e da ff ff       	call   80102bc0 <end_op>
      return -1;
80105152:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105157:	eb 43                	jmp    8010519c <sys_open+0x13c>
80105159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105160:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105163:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105167:	56                   	push   %esi
80105168:	e8 e3 c5 ff ff       	call   80101750 <iunlock>
  end_op();
8010516d:	e8 4e da ff ff       	call   80102bc0 <end_op>

  f->type = FD_INODE;
80105172:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105178:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010517b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010517e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105181:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105188:	89 d0                	mov    %edx,%eax
8010518a:	83 e0 01             	and    $0x1,%eax
8010518d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105190:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105193:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105196:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010519a:	89 d8                	mov    %ebx,%eax
}
8010519c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010519f:	5b                   	pop    %ebx
801051a0:	5e                   	pop    %esi
801051a1:	5f                   	pop    %edi
801051a2:	5d                   	pop    %ebp
801051a3:	c3                   	ret    
801051a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801051a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801051ab:	85 c9                	test   %ecx,%ecx
801051ad:	0f 84 23 ff ff ff    	je     801050d6 <sys_open+0x76>
801051b3:	e9 54 ff ff ff       	jmp    8010510c <sys_open+0xac>
801051b8:	90                   	nop
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051c0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801051c6:	e8 85 d9 ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801051cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ce:	83 ec 08             	sub    $0x8,%esp
801051d1:	50                   	push   %eax
801051d2:	6a 00                	push   $0x0
801051d4:	e8 a7 f6 ff ff       	call   80104880 <argstr>
801051d9:	83 c4 10             	add    $0x10,%esp
801051dc:	85 c0                	test   %eax,%eax
801051de:	78 30                	js     80105210 <sys_mkdir+0x50>
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e6:	31 c9                	xor    %ecx,%ecx
801051e8:	6a 00                	push   $0x0
801051ea:	ba 01 00 00 00       	mov    $0x1,%edx
801051ef:	e8 2c f7 ff ff       	call   80104920 <create>
801051f4:	83 c4 10             	add    $0x10,%esp
801051f7:	85 c0                	test   %eax,%eax
801051f9:	74 15                	je     80105210 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051fb:	83 ec 0c             	sub    $0xc,%esp
801051fe:	50                   	push   %eax
801051ff:	e8 fc c6 ff ff       	call   80101900 <iunlockput>
  end_op();
80105204:	e8 b7 d9 ff ff       	call   80102bc0 <end_op>
  return 0;
80105209:	83 c4 10             	add    $0x10,%esp
8010520c:	31 c0                	xor    %eax,%eax
}
8010520e:	c9                   	leave  
8010520f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105210:	e8 ab d9 ff ff       	call   80102bc0 <end_op>
    return -1;
80105215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010521a:	c9                   	leave  
8010521b:	c3                   	ret    
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105220 <sys_mknod>:

int
sys_mknod(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105226:	e8 25 d9 ff ff       	call   80102b50 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010522b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010522e:	83 ec 08             	sub    $0x8,%esp
80105231:	50                   	push   %eax
80105232:	6a 00                	push   $0x0
80105234:	e8 47 f6 ff ff       	call   80104880 <argstr>
80105239:	83 c4 10             	add    $0x10,%esp
8010523c:	85 c0                	test   %eax,%eax
8010523e:	78 60                	js     801052a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105240:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105243:	83 ec 08             	sub    $0x8,%esp
80105246:	50                   	push   %eax
80105247:	6a 01                	push   $0x1
80105249:	e8 82 f5 ff ff       	call   801047d0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010524e:	83 c4 10             	add    $0x10,%esp
80105251:	85 c0                	test   %eax,%eax
80105253:	78 4b                	js     801052a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105255:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105258:	83 ec 08             	sub    $0x8,%esp
8010525b:	50                   	push   %eax
8010525c:	6a 02                	push   $0x2
8010525e:	e8 6d f5 ff ff       	call   801047d0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105263:	83 c4 10             	add    $0x10,%esp
80105266:	85 c0                	test   %eax,%eax
80105268:	78 36                	js     801052a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010526a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010526e:	83 ec 0c             	sub    $0xc,%esp
80105271:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105275:	ba 03 00 00 00       	mov    $0x3,%edx
8010527a:	50                   	push   %eax
8010527b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010527e:	e8 9d f6 ff ff       	call   80104920 <create>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	74 16                	je     801052a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010528a:	83 ec 0c             	sub    $0xc,%esp
8010528d:	50                   	push   %eax
8010528e:	e8 6d c6 ff ff       	call   80101900 <iunlockput>
  end_op();
80105293:	e8 28 d9 ff ff       	call   80102bc0 <end_op>
  return 0;
80105298:	83 c4 10             	add    $0x10,%esp
8010529b:	31 c0                	xor    %eax,%eax
}
8010529d:	c9                   	leave  
8010529e:	c3                   	ret    
8010529f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801052a0:	e8 1b d9 ff ff       	call   80102bc0 <end_op>
    return -1;
801052a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801052aa:	c9                   	leave  
801052ab:	c3                   	ret    
801052ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052b0 <sys_chdir>:

int
sys_chdir(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	56                   	push   %esi
801052b4:	53                   	push   %ebx
801052b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801052b8:	e8 43 e5 ff ff       	call   80103800 <myproc>
801052bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801052bf:	e8 8c d8 ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801052c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c7:	83 ec 08             	sub    $0x8,%esp
801052ca:	50                   	push   %eax
801052cb:	6a 00                	push   $0x0
801052cd:	e8 ae f5 ff ff       	call   80104880 <argstr>
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	85 c0                	test   %eax,%eax
801052d7:	78 77                	js     80105350 <sys_chdir+0xa0>
801052d9:	83 ec 0c             	sub    $0xc,%esp
801052dc:	ff 75 f4             	pushl  -0xc(%ebp)
801052df:	e8 dc cb ff ff       	call   80101ec0 <namei>
801052e4:	83 c4 10             	add    $0x10,%esp
801052e7:	85 c0                	test   %eax,%eax
801052e9:	89 c3                	mov    %eax,%ebx
801052eb:	74 63                	je     80105350 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801052ed:	83 ec 0c             	sub    $0xc,%esp
801052f0:	50                   	push   %eax
801052f1:	e8 7a c3 ff ff       	call   80101670 <ilock>
  if(ip->type != T_DIR){
801052f6:	83 c4 10             	add    $0x10,%esp
801052f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052fe:	75 30                	jne    80105330 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	53                   	push   %ebx
80105304:	e8 47 c4 ff ff       	call   80101750 <iunlock>
  iput(curproc->cwd);
80105309:	58                   	pop    %eax
8010530a:	ff 76 68             	pushl  0x68(%esi)
8010530d:	e8 8e c4 ff ff       	call   801017a0 <iput>
  end_op();
80105312:	e8 a9 d8 ff ff       	call   80102bc0 <end_op>
  curproc->cwd = ip;
80105317:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	31 c0                	xor    %eax,%eax
}
8010531f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105322:	5b                   	pop    %ebx
80105323:	5e                   	pop    %esi
80105324:	5d                   	pop    %ebp
80105325:	c3                   	ret    
80105326:	8d 76 00             	lea    0x0(%esi),%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	53                   	push   %ebx
80105334:	e8 c7 c5 ff ff       	call   80101900 <iunlockput>
    end_op();
80105339:	e8 82 d8 ff ff       	call   80102bc0 <end_op>
    return -1;
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105346:	eb d7                	jmp    8010531f <sys_chdir+0x6f>
80105348:	90                   	nop
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105350:	e8 6b d8 ff ff       	call   80102bc0 <end_op>
    return -1;
80105355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535a:	eb c3                	jmp    8010531f <sys_chdir+0x6f>
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105366:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010536c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105372:	50                   	push   %eax
80105373:	6a 00                	push   $0x0
80105375:	e8 06 f5 ff ff       	call   80104880 <argstr>
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	85 c0                	test   %eax,%eax
8010537f:	78 7f                	js     80105400 <sys_exec+0xa0>
80105381:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105387:	83 ec 08             	sub    $0x8,%esp
8010538a:	50                   	push   %eax
8010538b:	6a 01                	push   $0x1
8010538d:	e8 3e f4 ff ff       	call   801047d0 <argint>
80105392:	83 c4 10             	add    $0x10,%esp
80105395:	85 c0                	test   %eax,%eax
80105397:	78 67                	js     80105400 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105399:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010539f:	83 ec 04             	sub    $0x4,%esp
801053a2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801053a8:	68 80 00 00 00       	push   $0x80
801053ad:	6a 00                	push   $0x0
801053af:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053b5:	50                   	push   %eax
801053b6:	31 db                	xor    %ebx,%ebx
801053b8:	e8 03 f1 ff ff       	call   801044c0 <memset>
801053bd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053c0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053c6:	83 ec 08             	sub    $0x8,%esp
801053c9:	57                   	push   %edi
801053ca:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801053cd:	50                   	push   %eax
801053ce:	e8 5d f3 ff ff       	call   80104730 <fetchint>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	85 c0                	test   %eax,%eax
801053d8:	78 26                	js     80105400 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801053da:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801053e0:	85 c0                	test   %eax,%eax
801053e2:	74 2c                	je     80105410 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801053e4:	83 ec 08             	sub    $0x8,%esp
801053e7:	56                   	push   %esi
801053e8:	50                   	push   %eax
801053e9:	e8 82 f3 ff ff       	call   80104770 <fetchstr>
801053ee:	83 c4 10             	add    $0x10,%esp
801053f1:	85 c0                	test   %eax,%eax
801053f3:	78 0b                	js     80105400 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801053f5:	83 c3 01             	add    $0x1,%ebx
801053f8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801053fb:	83 fb 20             	cmp    $0x20,%ebx
801053fe:	75 c0                	jne    801053c0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105408:	5b                   	pop    %ebx
80105409:	5e                   	pop    %esi
8010540a:	5f                   	pop    %edi
8010540b:	5d                   	pop    %ebp
8010540c:	c3                   	ret    
8010540d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105410:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105416:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105419:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105420:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105424:	50                   	push   %eax
80105425:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010542b:	e8 c0 b5 ff ff       	call   801009f0 <exec>
80105430:	83 c4 10             	add    $0x10,%esp
}
80105433:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105436:	5b                   	pop    %ebx
80105437:	5e                   	pop    %esi
80105438:	5f                   	pop    %edi
80105439:	5d                   	pop    %ebp
8010543a:	c3                   	ret    
8010543b:	90                   	nop
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_pipe>:

int
sys_pipe(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
80105445:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105446:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105449:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010544c:	6a 08                	push   $0x8
8010544e:	50                   	push   %eax
8010544f:	6a 00                	push   $0x0
80105451:	e8 ca f3 ff ff       	call   80104820 <argptr>
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	85 c0                	test   %eax,%eax
8010545b:	78 4a                	js     801054a7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010545d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105460:	83 ec 08             	sub    $0x8,%esp
80105463:	50                   	push   %eax
80105464:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105467:	50                   	push   %eax
80105468:	e8 93 dd ff ff       	call   80103200 <pipealloc>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	78 33                	js     801054a7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105474:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105476:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105479:	e8 82 e3 ff ff       	call   80103800 <myproc>
8010547e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105480:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105484:	85 f6                	test   %esi,%esi
80105486:	74 30                	je     801054b8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105488:	83 c3 01             	add    $0x1,%ebx
8010548b:	83 fb 10             	cmp    $0x10,%ebx
8010548e:	75 f0                	jne    80105480 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	ff 75 e0             	pushl  -0x20(%ebp)
80105496:	e8 95 b9 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
8010549b:	58                   	pop    %eax
8010549c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010549f:	e8 8c b9 ff ff       	call   80100e30 <fileclose>
    return -1;
801054a4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801054a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801054aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801054af:	5b                   	pop    %ebx
801054b0:	5e                   	pop    %esi
801054b1:	5f                   	pop    %edi
801054b2:	5d                   	pop    %ebp
801054b3:	c3                   	ret    
801054b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801054b8:	8d 73 08             	lea    0x8(%ebx),%esi
801054bb:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801054c2:	e8 39 e3 ff ff       	call   80103800 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801054c7:	31 d2                	xor    %edx,%edx
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801054d0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801054d4:	85 c9                	test   %ecx,%ecx
801054d6:	74 18                	je     801054f0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801054d8:	83 c2 01             	add    $0x1,%edx
801054db:	83 fa 10             	cmp    $0x10,%edx
801054de:	75 f0                	jne    801054d0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801054e0:	e8 1b e3 ff ff       	call   80103800 <myproc>
801054e5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801054ec:	00 
801054ed:	eb a1                	jmp    80105490 <sys_pipe+0x50>
801054ef:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801054f0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801054f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054f7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801054f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054fc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801054ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105502:	31 c0                	xor    %eax,%eax
}
80105504:	5b                   	pop    %ebx
80105505:	5e                   	pop    %esi
80105506:	5f                   	pop    %edi
80105507:	5d                   	pop    %ebp
80105508:	c3                   	ret    
80105509:	66 90                	xchg   %ax,%ax
8010550b:	66 90                	xchg   %ax,%ax
8010550d:	66 90                	xchg   %ax,%ax
8010550f:	90                   	nop

80105510 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105513:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105514:	e9 87 e4 ff ff       	jmp    801039a0 <fork>
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_exit>:
}

int
sys_exit(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 08             	sub    $0x8,%esp
  //shmrem("-1");
  exit();
80105526:	e8 15 e7 ff ff       	call   80103c40 <exit>
  return 0;  // not reached
}
8010552b:	31 c0                	xor    %eax,%eax
8010552d:	c9                   	leave  
8010552e:	c3                   	ret    
8010552f:	90                   	nop

80105530 <sys_wait>:

int
sys_wait(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105533:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105534:	e9 57 e9 ff ff       	jmp    80103e90 <wait>
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_kill>:
}

int
sys_kill(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105546:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105549:	50                   	push   %eax
8010554a:	6a 00                	push   $0x0
8010554c:	e8 7f f2 ff ff       	call   801047d0 <argint>
80105551:	83 c4 10             	add    $0x10,%esp
80105554:	85 c0                	test   %eax,%eax
80105556:	78 18                	js     80105570 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	ff 75 f4             	pushl  -0xc(%ebp)
8010555e:	e8 8d ea ff ff       	call   80103ff0 <kill>
80105563:	83 c4 10             	add    $0x10,%esp
}
80105566:	c9                   	leave  
80105567:	c3                   	ret    
80105568:	90                   	nop
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105575:	c9                   	leave  
80105576:	c3                   	ret    
80105577:	89 f6                	mov    %esi,%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105580 <sys_getpid>:

int
sys_getpid(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105586:	e8 75 e2 ff ff       	call   80103800 <myproc>
8010558b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010558e:	c9                   	leave  
8010558f:	c3                   	ret    

80105590 <sys_sbrk>:

int
sys_sbrk(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105597:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010559a:	50                   	push   %eax
8010559b:	6a 00                	push   $0x0
8010559d:	e8 2e f2 ff ff       	call   801047d0 <argint>
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	85 c0                	test   %eax,%eax
801055a7:	78 27                	js     801055d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801055a9:	e8 52 e2 ff ff       	call   80103800 <myproc>
  if(growproc(n) < 0)
801055ae:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801055b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801055b3:	ff 75 f4             	pushl  -0xc(%ebp)
801055b6:	e8 65 e3 ff ff       	call   80103920 <growproc>
801055bb:	83 c4 10             	add    $0x10,%esp
801055be:	85 c0                	test   %eax,%eax
801055c0:	78 0e                	js     801055d0 <sys_sbrk+0x40>
    return -1;
  return addr;
801055c2:	89 d8                	mov    %ebx,%eax
}
801055c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055c7:	c9                   	leave  
801055c8:	c3                   	ret    
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801055d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d5:	eb ed                	jmp    801055c4 <sys_sbrk+0x34>
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801055e7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055ea:	50                   	push   %eax
801055eb:	6a 00                	push   $0x0
801055ed:	e8 de f1 ff ff       	call   801047d0 <argint>
801055f2:	83 c4 10             	add    $0x10,%esp
801055f5:	85 c0                	test   %eax,%eax
801055f7:	0f 88 8a 00 00 00    	js     80105687 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801055fd:	83 ec 0c             	sub    $0xc,%esp
80105600:	68 60 25 12 80       	push   $0x80122560
80105605:	e8 46 ed ff ff       	call   80104350 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010560a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010560d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105610:	8b 1d a0 2d 12 80    	mov    0x80122da0,%ebx
  while(ticks - ticks0 < n){
80105616:	85 d2                	test   %edx,%edx
80105618:	75 27                	jne    80105641 <sys_sleep+0x61>
8010561a:	eb 54                	jmp    80105670 <sys_sleep+0x90>
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105620:	83 ec 08             	sub    $0x8,%esp
80105623:	68 60 25 12 80       	push   $0x80122560
80105628:	68 a0 2d 12 80       	push   $0x80122da0
8010562d:	e8 9e e7 ff ff       	call   80103dd0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105632:	a1 a0 2d 12 80       	mov    0x80122da0,%eax
80105637:	83 c4 10             	add    $0x10,%esp
8010563a:	29 d8                	sub    %ebx,%eax
8010563c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010563f:	73 2f                	jae    80105670 <sys_sleep+0x90>
    if(myproc()->killed){
80105641:	e8 ba e1 ff ff       	call   80103800 <myproc>
80105646:	8b 40 24             	mov    0x24(%eax),%eax
80105649:	85 c0                	test   %eax,%eax
8010564b:	74 d3                	je     80105620 <sys_sleep+0x40>
      release(&tickslock);
8010564d:	83 ec 0c             	sub    $0xc,%esp
80105650:	68 60 25 12 80       	push   $0x80122560
80105655:	e8 16 ee ff ff       	call   80104470 <release>
      return -1;
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105665:	c9                   	leave  
80105666:	c3                   	ret    
80105667:	89 f6                	mov    %esi,%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	68 60 25 12 80       	push   $0x80122560
80105678:	e8 f3 ed ff ff       	call   80104470 <release>
  return 0;
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	31 c0                	xor    %eax,%eax
}
80105682:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105685:	c9                   	leave  
80105686:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568c:	eb d4                	jmp    80105662 <sys_sleep+0x82>
8010568e:	66 90                	xchg   %ax,%ax

80105690 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	53                   	push   %ebx
80105694:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105697:	68 60 25 12 80       	push   $0x80122560
8010569c:	e8 af ec ff ff       	call   80104350 <acquire>
  xticks = ticks;
801056a1:	8b 1d a0 2d 12 80    	mov    0x80122da0,%ebx
  release(&tickslock);
801056a7:	c7 04 24 60 25 12 80 	movl   $0x80122560,(%esp)
801056ae:	e8 bd ed ff ff       	call   80104470 <release>
  return xticks;
}
801056b3:	89 d8                	mov    %ebx,%eax
801056b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056b8:	c9                   	leave  
801056b9:	c3                   	ret    
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056c0 <sys_shmget>:

int 
sys_shmget(void)  //mine
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 20             	sub    $0x20,%esp
  char *key; 
  int temp = argstr(0, &key);
801056c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c9:	50                   	push   %eax
801056ca:	6a 00                	push   $0x0
801056cc:	e8 af f1 ff ff       	call   80104880 <argstr>
  if (temp <=0 || temp >16)
801056d1:	83 e8 01             	sub    $0x1,%eax
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	83 f8 0f             	cmp    $0xf,%eax
801056da:	77 14                	ja     801056f0 <sys_shmget+0x30>
    return -1;
  return (int)shmget(key);
801056dc:	83 ec 0c             	sub    $0xc,%esp
801056df:	ff 75 f4             	pushl  -0xc(%ebp)
801056e2:	e8 79 19 00 00       	call   80107060 <shmget>
801056e7:	83 c4 10             	add    $0x10,%esp
}
801056ea:	c9                   	leave  
801056eb:	c3                   	ret    
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_shmget(void)  //mine
{
  char *key; 
  int temp = argstr(0, &key);
  if (temp <=0 || temp >16)
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return (int)shmget(key);
}
801056f5:	c9                   	leave  
801056f6:	c3                   	ret    
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <sys_shmrem>:

int 
sys_shmrem(void)  //mine
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 20             	sub    $0x20,%esp
  char *key; 
  int temp = argstr(0, &key);
80105706:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105709:	50                   	push   %eax
8010570a:	6a 00                	push   $0x0
8010570c:	e8 6f f1 ff ff       	call   80104880 <argstr>
  if (temp <=0 || temp >16)
80105711:	83 e8 01             	sub    $0x1,%eax
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	83 f8 0f             	cmp    $0xf,%eax
8010571a:	77 14                	ja     80105730 <sys_shmrem+0x30>
    return -1;
  return shmrem(key);
8010571c:	83 ec 0c             	sub    $0xc,%esp
8010571f:	ff 75 f4             	pushl  -0xc(%ebp)
80105722:	e8 59 1d 00 00       	call   80107480 <shmrem>
80105727:	83 c4 10             	add    $0x10,%esp
}
8010572a:	c9                   	leave  
8010572b:	c3                   	ret    
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_shmrem(void)  //mine
{
  char *key; 
  int temp = argstr(0, &key);
  if (temp <=0 || temp >16)
    return -1;
80105730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return shmrem(key);
}
80105735:	c9                   	leave  
80105736:	c3                   	ret    

80105737 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105737:	1e                   	push   %ds
  pushl %es
80105738:	06                   	push   %es
  pushl %fs
80105739:	0f a0                	push   %fs
  pushl %gs
8010573b:	0f a8                	push   %gs
  pushal
8010573d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010573e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105742:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105744:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105746:	54                   	push   %esp
  call trap
80105747:	e8 e4 00 00 00       	call   80105830 <trap>
  addl $4, %esp
8010574c:	83 c4 04             	add    $0x4,%esp

8010574f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010574f:	61                   	popa   
  popl %gs
80105750:	0f a9                	pop    %gs
  popl %fs
80105752:	0f a1                	pop    %fs
  popl %es
80105754:	07                   	pop    %es
  popl %ds
80105755:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105756:	83 c4 08             	add    $0x8,%esp
  iret
80105759:	cf                   	iret   
8010575a:	66 90                	xchg   %ax,%ax
8010575c:	66 90                	xchg   %ax,%ax
8010575e:	66 90                	xchg   %ax,%ax

80105760 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105760:	31 c0                	xor    %eax,%eax
80105762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105768:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
8010576f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105774:	c6 04 c5 a4 25 12 80 	movb   $0x0,-0x7fedda5c(,%eax,8)
8010577b:	00 
8010577c:	66 89 0c c5 a2 25 12 	mov    %cx,-0x7fedda5e(,%eax,8)
80105783:	80 
80105784:	c6 04 c5 a5 25 12 80 	movb   $0x8e,-0x7fedda5b(,%eax,8)
8010578b:	8e 
8010578c:	66 89 14 c5 a0 25 12 	mov    %dx,-0x7fedda60(,%eax,8)
80105793:	80 
80105794:	c1 ea 10             	shr    $0x10,%edx
80105797:	66 89 14 c5 a6 25 12 	mov    %dx,-0x7fedda5a(,%eax,8)
8010579e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010579f:	83 c0 01             	add    $0x1,%eax
801057a2:	3d 00 01 00 00       	cmp    $0x100,%eax
801057a7:	75 bf                	jne    80105768 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801057a9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057aa:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801057af:	89 e5                	mov    %esp,%ebp
801057b1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057b4:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801057b9:	68 01 81 10 80       	push   $0x80108101
801057be:	68 60 25 12 80       	push   $0x80122560
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057c3:	66 89 15 a2 27 12 80 	mov    %dx,0x801227a2
801057ca:	c6 05 a4 27 12 80 00 	movb   $0x0,0x801227a4
801057d1:	66 a3 a0 27 12 80    	mov    %ax,0x801227a0
801057d7:	c1 e8 10             	shr    $0x10,%eax
801057da:	c6 05 a5 27 12 80 ef 	movb   $0xef,0x801227a5
801057e1:	66 a3 a6 27 12 80    	mov    %ax,0x801227a6

  initlock(&tickslock, "time");
801057e7:	e8 64 ea ff ff       	call   80104250 <initlock>
}
801057ec:	83 c4 10             	add    $0x10,%esp
801057ef:	c9                   	leave  
801057f0:	c3                   	ret    
801057f1:	eb 0d                	jmp    80105800 <idtinit>
801057f3:	90                   	nop
801057f4:	90                   	nop
801057f5:	90                   	nop
801057f6:	90                   	nop
801057f7:	90                   	nop
801057f8:	90                   	nop
801057f9:	90                   	nop
801057fa:	90                   	nop
801057fb:	90                   	nop
801057fc:	90                   	nop
801057fd:	90                   	nop
801057fe:	90                   	nop
801057ff:	90                   	nop

80105800 <idtinit>:

void
idtinit(void)
{
80105800:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105801:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105806:	89 e5                	mov    %esp,%ebp
80105808:	83 ec 10             	sub    $0x10,%esp
8010580b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010580f:	b8 a0 25 12 80       	mov    $0x801225a0,%eax
80105814:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105818:	c1 e8 10             	shr    $0x10,%eax
8010581b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010581f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105822:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105825:	c9                   	leave  
80105826:	c3                   	ret    
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105830 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	57                   	push   %edi
80105834:	56                   	push   %esi
80105835:	53                   	push   %ebx
80105836:	83 ec 1c             	sub    $0x1c,%esp
80105839:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010583c:	8b 47 30             	mov    0x30(%edi),%eax
8010583f:	83 f8 40             	cmp    $0x40,%eax
80105842:	0f 84 88 01 00 00    	je     801059d0 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105848:	83 e8 20             	sub    $0x20,%eax
8010584b:	83 f8 1f             	cmp    $0x1f,%eax
8010584e:	77 10                	ja     80105860 <trap+0x30>
80105850:	ff 24 85 a8 81 10 80 	jmp    *-0x7fef7e58(,%eax,4)
80105857:	89 f6                	mov    %esi,%esi
80105859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105860:	e8 9b df ff ff       	call   80103800 <myproc>
80105865:	85 c0                	test   %eax,%eax
80105867:	0f 84 d7 01 00 00    	je     80105a44 <trap+0x214>
8010586d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105871:	0f 84 cd 01 00 00    	je     80105a44 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105877:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010587a:	8b 57 38             	mov    0x38(%edi),%edx
8010587d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105880:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105883:	e8 58 df ff ff       	call   801037e0 <cpuid>
80105888:	8b 77 34             	mov    0x34(%edi),%esi
8010588b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010588e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105891:	e8 6a df ff ff       	call   80103800 <myproc>
80105896:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105899:	e8 62 df ff ff       	call   80103800 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010589e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801058a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801058a4:	51                   	push   %ecx
801058a5:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801058a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058a9:	ff 75 e4             	pushl  -0x1c(%ebp)
801058ac:	56                   	push   %esi
801058ad:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801058ae:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058b1:	52                   	push   %edx
801058b2:	ff 70 10             	pushl  0x10(%eax)
801058b5:	68 64 81 10 80       	push   $0x80108164
801058ba:	e8 a1 ad ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801058bf:	83 c4 20             	add    $0x20,%esp
801058c2:	e8 39 df ff ff       	call   80103800 <myproc>
801058c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801058ce:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058d0:	e8 2b df ff ff       	call   80103800 <myproc>
801058d5:	85 c0                	test   %eax,%eax
801058d7:	74 0c                	je     801058e5 <trap+0xb5>
801058d9:	e8 22 df ff ff       	call   80103800 <myproc>
801058de:	8b 50 24             	mov    0x24(%eax),%edx
801058e1:	85 d2                	test   %edx,%edx
801058e3:	75 4b                	jne    80105930 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058e5:	e8 16 df ff ff       	call   80103800 <myproc>
801058ea:	85 c0                	test   %eax,%eax
801058ec:	74 0b                	je     801058f9 <trap+0xc9>
801058ee:	e8 0d df ff ff       	call   80103800 <myproc>
801058f3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801058f7:	74 4f                	je     80105948 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058f9:	e8 02 df ff ff       	call   80103800 <myproc>
801058fe:	85 c0                	test   %eax,%eax
80105900:	74 1d                	je     8010591f <trap+0xef>
80105902:	e8 f9 de ff ff       	call   80103800 <myproc>
80105907:	8b 40 24             	mov    0x24(%eax),%eax
8010590a:	85 c0                	test   %eax,%eax
8010590c:	74 11                	je     8010591f <trap+0xef>
8010590e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105912:	83 e0 03             	and    $0x3,%eax
80105915:	66 83 f8 03          	cmp    $0x3,%ax
80105919:	0f 84 da 00 00 00    	je     801059f9 <trap+0x1c9>
    exit();
}
8010591f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105922:	5b                   	pop    %ebx
80105923:	5e                   	pop    %esi
80105924:	5f                   	pop    %edi
80105925:	5d                   	pop    %ebp
80105926:	c3                   	ret    
80105927:	89 f6                	mov    %esi,%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105930:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105934:	83 e0 03             	and    $0x3,%eax
80105937:	66 83 f8 03          	cmp    $0x3,%ax
8010593b:	75 a8                	jne    801058e5 <trap+0xb5>
    exit();
8010593d:	e8 fe e2 ff ff       	call   80103c40 <exit>
80105942:	eb a1                	jmp    801058e5 <trap+0xb5>
80105944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105948:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010594c:	75 ab                	jne    801058f9 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010594e:	e8 2d e4 ff ff       	call   80103d80 <yield>
80105953:	eb a4                	jmp    801058f9 <trap+0xc9>
80105955:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105958:	e8 83 de ff ff       	call   801037e0 <cpuid>
8010595d:	85 c0                	test   %eax,%eax
8010595f:	0f 84 ab 00 00 00    	je     80105a10 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105965:	e8 a6 cd ff ff       	call   80102710 <lapiceoi>
    break;
8010596a:	e9 61 ff ff ff       	jmp    801058d0 <trap+0xa0>
8010596f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105970:	e8 5b cc ff ff       	call   801025d0 <kbdintr>
    lapiceoi();
80105975:	e8 96 cd ff ff       	call   80102710 <lapiceoi>
    break;
8010597a:	e9 51 ff ff ff       	jmp    801058d0 <trap+0xa0>
8010597f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105980:	e8 5b 02 00 00       	call   80105be0 <uartintr>
    lapiceoi();
80105985:	e8 86 cd ff ff       	call   80102710 <lapiceoi>
    break;
8010598a:	e9 41 ff ff ff       	jmp    801058d0 <trap+0xa0>
8010598f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105990:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105994:	8b 77 38             	mov    0x38(%edi),%esi
80105997:	e8 44 de ff ff       	call   801037e0 <cpuid>
8010599c:	56                   	push   %esi
8010599d:	53                   	push   %ebx
8010599e:	50                   	push   %eax
8010599f:	68 0c 81 10 80       	push   $0x8010810c
801059a4:	e8 b7 ac ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801059a9:	e8 62 cd ff ff       	call   80102710 <lapiceoi>
    break;
801059ae:	83 c4 10             	add    $0x10,%esp
801059b1:	e9 1a ff ff ff       	jmp    801058d0 <trap+0xa0>
801059b6:	8d 76 00             	lea    0x0(%esi),%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801059c0:	e8 8b c6 ff ff       	call   80102050 <ideintr>
801059c5:	eb 9e                	jmp    80105965 <trap+0x135>
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801059d0:	e8 2b de ff ff       	call   80103800 <myproc>
801059d5:	8b 58 24             	mov    0x24(%eax),%ebx
801059d8:	85 db                	test   %ebx,%ebx
801059da:	75 2c                	jne    80105a08 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
801059dc:	e8 1f de ff ff       	call   80103800 <myproc>
801059e1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801059e4:	e8 d7 ee ff ff       	call   801048c0 <syscall>
    if(myproc()->killed)
801059e9:	e8 12 de ff ff       	call   80103800 <myproc>
801059ee:	8b 48 24             	mov    0x24(%eax),%ecx
801059f1:	85 c9                	test   %ecx,%ecx
801059f3:	0f 84 26 ff ff ff    	je     8010591f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801059f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059fc:	5b                   	pop    %ebx
801059fd:	5e                   	pop    %esi
801059fe:	5f                   	pop    %edi
801059ff:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105a00:	e9 3b e2 ff ff       	jmp    80103c40 <exit>
80105a05:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105a08:	e8 33 e2 ff ff       	call   80103c40 <exit>
80105a0d:	eb cd                	jmp    801059dc <trap+0x1ac>
80105a0f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	68 60 25 12 80       	push   $0x80122560
80105a18:	e8 33 e9 ff ff       	call   80104350 <acquire>
      ticks++;
      wakeup(&ticks);
80105a1d:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105a24:	83 05 a0 2d 12 80 01 	addl   $0x1,0x80122da0
      wakeup(&ticks);
80105a2b:	e8 60 e5 ff ff       	call   80103f90 <wakeup>
      release(&tickslock);
80105a30:	c7 04 24 60 25 12 80 	movl   $0x80122560,(%esp)
80105a37:	e8 34 ea ff ff       	call   80104470 <release>
80105a3c:	83 c4 10             	add    $0x10,%esp
80105a3f:	e9 21 ff ff ff       	jmp    80105965 <trap+0x135>
80105a44:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a47:	8b 5f 38             	mov    0x38(%edi),%ebx
80105a4a:	e8 91 dd ff ff       	call   801037e0 <cpuid>
80105a4f:	83 ec 0c             	sub    $0xc,%esp
80105a52:	56                   	push   %esi
80105a53:	53                   	push   %ebx
80105a54:	50                   	push   %eax
80105a55:	ff 77 30             	pushl  0x30(%edi)
80105a58:	68 30 81 10 80       	push   $0x80108130
80105a5d:	e8 fe ab ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105a62:	83 c4 14             	add    $0x14,%esp
80105a65:	68 06 81 10 80       	push   $0x80108106
80105a6a:	e8 01 a9 ff ff       	call   80100370 <panic>
80105a6f:	90                   	nop

80105a70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a70:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105a75:	55                   	push   %ebp
80105a76:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a78:	85 c0                	test   %eax,%eax
80105a7a:	74 1c                	je     80105a98 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a7c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a81:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a82:	a8 01                	test   $0x1,%al
80105a84:	74 12                	je     80105a98 <uartgetc+0x28>
80105a86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a8b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a8c:	0f b6 c0             	movzbl %al,%eax
}
80105a8f:	5d                   	pop    %ebp
80105a90:	c3                   	ret    
80105a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a9d:	5d                   	pop    %ebp
80105a9e:	c3                   	ret    
80105a9f:	90                   	nop

80105aa0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	53                   	push   %ebx
80105aa6:	89 c7                	mov    %eax,%edi
80105aa8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105aad:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ab2:	83 ec 0c             	sub    $0xc,%esp
80105ab5:	eb 1b                	jmp    80105ad2 <uartputc.part.0+0x32>
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	6a 0a                	push   $0xa
80105ac5:	e8 66 cc ff ff       	call   80102730 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105aca:	83 c4 10             	add    $0x10,%esp
80105acd:	83 eb 01             	sub    $0x1,%ebx
80105ad0:	74 07                	je     80105ad9 <uartputc.part.0+0x39>
80105ad2:	89 f2                	mov    %esi,%edx
80105ad4:	ec                   	in     (%dx),%al
80105ad5:	a8 20                	test   $0x20,%al
80105ad7:	74 e7                	je     80105ac0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ad9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ade:	89 f8                	mov    %edi,%eax
80105ae0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ae4:	5b                   	pop    %ebx
80105ae5:	5e                   	pop    %esi
80105ae6:	5f                   	pop    %edi
80105ae7:	5d                   	pop    %ebp
80105ae8:	c3                   	ret    
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105af0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105af0:	55                   	push   %ebp
80105af1:	31 c9                	xor    %ecx,%ecx
80105af3:	89 c8                	mov    %ecx,%eax
80105af5:	89 e5                	mov    %esp,%ebp
80105af7:	57                   	push   %edi
80105af8:	56                   	push   %esi
80105af9:	53                   	push   %ebx
80105afa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105aff:	89 da                	mov    %ebx,%edx
80105b01:	83 ec 0c             	sub    $0xc,%esp
80105b04:	ee                   	out    %al,(%dx)
80105b05:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b0a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b0f:	89 fa                	mov    %edi,%edx
80105b11:	ee                   	out    %al,(%dx)
80105b12:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b17:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b1c:	ee                   	out    %al,(%dx)
80105b1d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b22:	89 c8                	mov    %ecx,%eax
80105b24:	89 f2                	mov    %esi,%edx
80105b26:	ee                   	out    %al,(%dx)
80105b27:	b8 03 00 00 00       	mov    $0x3,%eax
80105b2c:	89 fa                	mov    %edi,%edx
80105b2e:	ee                   	out    %al,(%dx)
80105b2f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b34:	89 c8                	mov    %ecx,%eax
80105b36:	ee                   	out    %al,(%dx)
80105b37:	b8 01 00 00 00       	mov    $0x1,%eax
80105b3c:	89 f2                	mov    %esi,%edx
80105b3e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b3f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b44:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105b45:	3c ff                	cmp    $0xff,%al
80105b47:	74 5a                	je     80105ba3 <uartinit+0xb3>
    return;
  uart = 1;
80105b49:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105b50:	00 00 00 
80105b53:	89 da                	mov    %ebx,%edx
80105b55:	ec                   	in     (%dx),%al
80105b56:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b5b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105b5c:	83 ec 08             	sub    $0x8,%esp
80105b5f:	bb 28 82 10 80       	mov    $0x80108228,%ebx
80105b64:	6a 00                	push   $0x0
80105b66:	6a 04                	push   $0x4
80105b68:	e8 33 c7 ff ff       	call   801022a0 <ioapicenable>
80105b6d:	83 c4 10             	add    $0x10,%esp
80105b70:	b8 78 00 00 00       	mov    $0x78,%eax
80105b75:	eb 13                	jmp    80105b8a <uartinit+0x9a>
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b80:	83 c3 01             	add    $0x1,%ebx
80105b83:	0f be 03             	movsbl (%ebx),%eax
80105b86:	84 c0                	test   %al,%al
80105b88:	74 19                	je     80105ba3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b8a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80105b90:	85 d2                	test   %edx,%edx
80105b92:	74 ec                	je     80105b80 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b94:	83 c3 01             	add    $0x1,%ebx
80105b97:	e8 04 ff ff ff       	call   80105aa0 <uartputc.part.0>
80105b9c:	0f be 03             	movsbl (%ebx),%eax
80105b9f:	84 c0                	test   %al,%al
80105ba1:	75 e7                	jne    80105b8a <uartinit+0x9a>
    uartputc(*p);
}
80105ba3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba6:	5b                   	pop    %ebx
80105ba7:	5e                   	pop    %esi
80105ba8:	5f                   	pop    %edi
80105ba9:	5d                   	pop    %ebp
80105baa:	c3                   	ret    
80105bab:	90                   	nop
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105bb0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105bb6:	55                   	push   %ebp
80105bb7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105bb9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105bbe:	74 10                	je     80105bd0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105bc0:	5d                   	pop    %ebp
80105bc1:	e9 da fe ff ff       	jmp    80105aa0 <uartputc.part.0>
80105bc6:	8d 76 00             	lea    0x0(%esi),%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105bd0:	5d                   	pop    %ebp
80105bd1:	c3                   	ret    
80105bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105be0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105be6:	68 70 5a 10 80       	push   $0x80105a70
80105beb:	e8 00 ac ff ff       	call   801007f0 <consoleintr>
}
80105bf0:	83 c4 10             	add    $0x10,%esp
80105bf3:	c9                   	leave  
80105bf4:	c3                   	ret    

80105bf5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105bf5:	6a 00                	push   $0x0
  pushl $0
80105bf7:	6a 00                	push   $0x0
  jmp alltraps
80105bf9:	e9 39 fb ff ff       	jmp    80105737 <alltraps>

80105bfe <vector1>:
.globl vector1
vector1:
  pushl $0
80105bfe:	6a 00                	push   $0x0
  pushl $1
80105c00:	6a 01                	push   $0x1
  jmp alltraps
80105c02:	e9 30 fb ff ff       	jmp    80105737 <alltraps>

80105c07 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c07:	6a 00                	push   $0x0
  pushl $2
80105c09:	6a 02                	push   $0x2
  jmp alltraps
80105c0b:	e9 27 fb ff ff       	jmp    80105737 <alltraps>

80105c10 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c10:	6a 00                	push   $0x0
  pushl $3
80105c12:	6a 03                	push   $0x3
  jmp alltraps
80105c14:	e9 1e fb ff ff       	jmp    80105737 <alltraps>

80105c19 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c19:	6a 00                	push   $0x0
  pushl $4
80105c1b:	6a 04                	push   $0x4
  jmp alltraps
80105c1d:	e9 15 fb ff ff       	jmp    80105737 <alltraps>

80105c22 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c22:	6a 00                	push   $0x0
  pushl $5
80105c24:	6a 05                	push   $0x5
  jmp alltraps
80105c26:	e9 0c fb ff ff       	jmp    80105737 <alltraps>

80105c2b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c2b:	6a 00                	push   $0x0
  pushl $6
80105c2d:	6a 06                	push   $0x6
  jmp alltraps
80105c2f:	e9 03 fb ff ff       	jmp    80105737 <alltraps>

80105c34 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c34:	6a 00                	push   $0x0
  pushl $7
80105c36:	6a 07                	push   $0x7
  jmp alltraps
80105c38:	e9 fa fa ff ff       	jmp    80105737 <alltraps>

80105c3d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c3d:	6a 08                	push   $0x8
  jmp alltraps
80105c3f:	e9 f3 fa ff ff       	jmp    80105737 <alltraps>

80105c44 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c44:	6a 00                	push   $0x0
  pushl $9
80105c46:	6a 09                	push   $0x9
  jmp alltraps
80105c48:	e9 ea fa ff ff       	jmp    80105737 <alltraps>

80105c4d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c4d:	6a 0a                	push   $0xa
  jmp alltraps
80105c4f:	e9 e3 fa ff ff       	jmp    80105737 <alltraps>

80105c54 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c54:	6a 0b                	push   $0xb
  jmp alltraps
80105c56:	e9 dc fa ff ff       	jmp    80105737 <alltraps>

80105c5b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c5b:	6a 0c                	push   $0xc
  jmp alltraps
80105c5d:	e9 d5 fa ff ff       	jmp    80105737 <alltraps>

80105c62 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c62:	6a 0d                	push   $0xd
  jmp alltraps
80105c64:	e9 ce fa ff ff       	jmp    80105737 <alltraps>

80105c69 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c69:	6a 0e                	push   $0xe
  jmp alltraps
80105c6b:	e9 c7 fa ff ff       	jmp    80105737 <alltraps>

80105c70 <vector15>:
.globl vector15
vector15:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $15
80105c72:	6a 0f                	push   $0xf
  jmp alltraps
80105c74:	e9 be fa ff ff       	jmp    80105737 <alltraps>

80105c79 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $16
80105c7b:	6a 10                	push   $0x10
  jmp alltraps
80105c7d:	e9 b5 fa ff ff       	jmp    80105737 <alltraps>

80105c82 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c82:	6a 11                	push   $0x11
  jmp alltraps
80105c84:	e9 ae fa ff ff       	jmp    80105737 <alltraps>

80105c89 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $18
80105c8b:	6a 12                	push   $0x12
  jmp alltraps
80105c8d:	e9 a5 fa ff ff       	jmp    80105737 <alltraps>

80105c92 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c92:	6a 00                	push   $0x0
  pushl $19
80105c94:	6a 13                	push   $0x13
  jmp alltraps
80105c96:	e9 9c fa ff ff       	jmp    80105737 <alltraps>

80105c9b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $20
80105c9d:	6a 14                	push   $0x14
  jmp alltraps
80105c9f:	e9 93 fa ff ff       	jmp    80105737 <alltraps>

80105ca4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ca4:	6a 00                	push   $0x0
  pushl $21
80105ca6:	6a 15                	push   $0x15
  jmp alltraps
80105ca8:	e9 8a fa ff ff       	jmp    80105737 <alltraps>

80105cad <vector22>:
.globl vector22
vector22:
  pushl $0
80105cad:	6a 00                	push   $0x0
  pushl $22
80105caf:	6a 16                	push   $0x16
  jmp alltraps
80105cb1:	e9 81 fa ff ff       	jmp    80105737 <alltraps>

80105cb6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105cb6:	6a 00                	push   $0x0
  pushl $23
80105cb8:	6a 17                	push   $0x17
  jmp alltraps
80105cba:	e9 78 fa ff ff       	jmp    80105737 <alltraps>

80105cbf <vector24>:
.globl vector24
vector24:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $24
80105cc1:	6a 18                	push   $0x18
  jmp alltraps
80105cc3:	e9 6f fa ff ff       	jmp    80105737 <alltraps>

80105cc8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105cc8:	6a 00                	push   $0x0
  pushl $25
80105cca:	6a 19                	push   $0x19
  jmp alltraps
80105ccc:	e9 66 fa ff ff       	jmp    80105737 <alltraps>

80105cd1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105cd1:	6a 00                	push   $0x0
  pushl $26
80105cd3:	6a 1a                	push   $0x1a
  jmp alltraps
80105cd5:	e9 5d fa ff ff       	jmp    80105737 <alltraps>

80105cda <vector27>:
.globl vector27
vector27:
  pushl $0
80105cda:	6a 00                	push   $0x0
  pushl $27
80105cdc:	6a 1b                	push   $0x1b
  jmp alltraps
80105cde:	e9 54 fa ff ff       	jmp    80105737 <alltraps>

80105ce3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $28
80105ce5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ce7:	e9 4b fa ff ff       	jmp    80105737 <alltraps>

80105cec <vector29>:
.globl vector29
vector29:
  pushl $0
80105cec:	6a 00                	push   $0x0
  pushl $29
80105cee:	6a 1d                	push   $0x1d
  jmp alltraps
80105cf0:	e9 42 fa ff ff       	jmp    80105737 <alltraps>

80105cf5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105cf5:	6a 00                	push   $0x0
  pushl $30
80105cf7:	6a 1e                	push   $0x1e
  jmp alltraps
80105cf9:	e9 39 fa ff ff       	jmp    80105737 <alltraps>

80105cfe <vector31>:
.globl vector31
vector31:
  pushl $0
80105cfe:	6a 00                	push   $0x0
  pushl $31
80105d00:	6a 1f                	push   $0x1f
  jmp alltraps
80105d02:	e9 30 fa ff ff       	jmp    80105737 <alltraps>

80105d07 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $32
80105d09:	6a 20                	push   $0x20
  jmp alltraps
80105d0b:	e9 27 fa ff ff       	jmp    80105737 <alltraps>

80105d10 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d10:	6a 00                	push   $0x0
  pushl $33
80105d12:	6a 21                	push   $0x21
  jmp alltraps
80105d14:	e9 1e fa ff ff       	jmp    80105737 <alltraps>

80105d19 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d19:	6a 00                	push   $0x0
  pushl $34
80105d1b:	6a 22                	push   $0x22
  jmp alltraps
80105d1d:	e9 15 fa ff ff       	jmp    80105737 <alltraps>

80105d22 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d22:	6a 00                	push   $0x0
  pushl $35
80105d24:	6a 23                	push   $0x23
  jmp alltraps
80105d26:	e9 0c fa ff ff       	jmp    80105737 <alltraps>

80105d2b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $36
80105d2d:	6a 24                	push   $0x24
  jmp alltraps
80105d2f:	e9 03 fa ff ff       	jmp    80105737 <alltraps>

80105d34 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d34:	6a 00                	push   $0x0
  pushl $37
80105d36:	6a 25                	push   $0x25
  jmp alltraps
80105d38:	e9 fa f9 ff ff       	jmp    80105737 <alltraps>

80105d3d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d3d:	6a 00                	push   $0x0
  pushl $38
80105d3f:	6a 26                	push   $0x26
  jmp alltraps
80105d41:	e9 f1 f9 ff ff       	jmp    80105737 <alltraps>

80105d46 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d46:	6a 00                	push   $0x0
  pushl $39
80105d48:	6a 27                	push   $0x27
  jmp alltraps
80105d4a:	e9 e8 f9 ff ff       	jmp    80105737 <alltraps>

80105d4f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d4f:	6a 00                	push   $0x0
  pushl $40
80105d51:	6a 28                	push   $0x28
  jmp alltraps
80105d53:	e9 df f9 ff ff       	jmp    80105737 <alltraps>

80105d58 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d58:	6a 00                	push   $0x0
  pushl $41
80105d5a:	6a 29                	push   $0x29
  jmp alltraps
80105d5c:	e9 d6 f9 ff ff       	jmp    80105737 <alltraps>

80105d61 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d61:	6a 00                	push   $0x0
  pushl $42
80105d63:	6a 2a                	push   $0x2a
  jmp alltraps
80105d65:	e9 cd f9 ff ff       	jmp    80105737 <alltraps>

80105d6a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d6a:	6a 00                	push   $0x0
  pushl $43
80105d6c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d6e:	e9 c4 f9 ff ff       	jmp    80105737 <alltraps>

80105d73 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $44
80105d75:	6a 2c                	push   $0x2c
  jmp alltraps
80105d77:	e9 bb f9 ff ff       	jmp    80105737 <alltraps>

80105d7c <vector45>:
.globl vector45
vector45:
  pushl $0
80105d7c:	6a 00                	push   $0x0
  pushl $45
80105d7e:	6a 2d                	push   $0x2d
  jmp alltraps
80105d80:	e9 b2 f9 ff ff       	jmp    80105737 <alltraps>

80105d85 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d85:	6a 00                	push   $0x0
  pushl $46
80105d87:	6a 2e                	push   $0x2e
  jmp alltraps
80105d89:	e9 a9 f9 ff ff       	jmp    80105737 <alltraps>

80105d8e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $47
80105d90:	6a 2f                	push   $0x2f
  jmp alltraps
80105d92:	e9 a0 f9 ff ff       	jmp    80105737 <alltraps>

80105d97 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $48
80105d99:	6a 30                	push   $0x30
  jmp alltraps
80105d9b:	e9 97 f9 ff ff       	jmp    80105737 <alltraps>

80105da0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105da0:	6a 00                	push   $0x0
  pushl $49
80105da2:	6a 31                	push   $0x31
  jmp alltraps
80105da4:	e9 8e f9 ff ff       	jmp    80105737 <alltraps>

80105da9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105da9:	6a 00                	push   $0x0
  pushl $50
80105dab:	6a 32                	push   $0x32
  jmp alltraps
80105dad:	e9 85 f9 ff ff       	jmp    80105737 <alltraps>

80105db2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $51
80105db4:	6a 33                	push   $0x33
  jmp alltraps
80105db6:	e9 7c f9 ff ff       	jmp    80105737 <alltraps>

80105dbb <vector52>:
.globl vector52
vector52:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $52
80105dbd:	6a 34                	push   $0x34
  jmp alltraps
80105dbf:	e9 73 f9 ff ff       	jmp    80105737 <alltraps>

80105dc4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $53
80105dc6:	6a 35                	push   $0x35
  jmp alltraps
80105dc8:	e9 6a f9 ff ff       	jmp    80105737 <alltraps>

80105dcd <vector54>:
.globl vector54
vector54:
  pushl $0
80105dcd:	6a 00                	push   $0x0
  pushl $54
80105dcf:	6a 36                	push   $0x36
  jmp alltraps
80105dd1:	e9 61 f9 ff ff       	jmp    80105737 <alltraps>

80105dd6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $55
80105dd8:	6a 37                	push   $0x37
  jmp alltraps
80105dda:	e9 58 f9 ff ff       	jmp    80105737 <alltraps>

80105ddf <vector56>:
.globl vector56
vector56:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $56
80105de1:	6a 38                	push   $0x38
  jmp alltraps
80105de3:	e9 4f f9 ff ff       	jmp    80105737 <alltraps>

80105de8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105de8:	6a 00                	push   $0x0
  pushl $57
80105dea:	6a 39                	push   $0x39
  jmp alltraps
80105dec:	e9 46 f9 ff ff       	jmp    80105737 <alltraps>

80105df1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105df1:	6a 00                	push   $0x0
  pushl $58
80105df3:	6a 3a                	push   $0x3a
  jmp alltraps
80105df5:	e9 3d f9 ff ff       	jmp    80105737 <alltraps>

80105dfa <vector59>:
.globl vector59
vector59:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $59
80105dfc:	6a 3b                	push   $0x3b
  jmp alltraps
80105dfe:	e9 34 f9 ff ff       	jmp    80105737 <alltraps>

80105e03 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $60
80105e05:	6a 3c                	push   $0x3c
  jmp alltraps
80105e07:	e9 2b f9 ff ff       	jmp    80105737 <alltraps>

80105e0c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e0c:	6a 00                	push   $0x0
  pushl $61
80105e0e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e10:	e9 22 f9 ff ff       	jmp    80105737 <alltraps>

80105e15 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e15:	6a 00                	push   $0x0
  pushl $62
80105e17:	6a 3e                	push   $0x3e
  jmp alltraps
80105e19:	e9 19 f9 ff ff       	jmp    80105737 <alltraps>

80105e1e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $63
80105e20:	6a 3f                	push   $0x3f
  jmp alltraps
80105e22:	e9 10 f9 ff ff       	jmp    80105737 <alltraps>

80105e27 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $64
80105e29:	6a 40                	push   $0x40
  jmp alltraps
80105e2b:	e9 07 f9 ff ff       	jmp    80105737 <alltraps>

80105e30 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $65
80105e32:	6a 41                	push   $0x41
  jmp alltraps
80105e34:	e9 fe f8 ff ff       	jmp    80105737 <alltraps>

80105e39 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $66
80105e3b:	6a 42                	push   $0x42
  jmp alltraps
80105e3d:	e9 f5 f8 ff ff       	jmp    80105737 <alltraps>

80105e42 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $67
80105e44:	6a 43                	push   $0x43
  jmp alltraps
80105e46:	e9 ec f8 ff ff       	jmp    80105737 <alltraps>

80105e4b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $68
80105e4d:	6a 44                	push   $0x44
  jmp alltraps
80105e4f:	e9 e3 f8 ff ff       	jmp    80105737 <alltraps>

80105e54 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $69
80105e56:	6a 45                	push   $0x45
  jmp alltraps
80105e58:	e9 da f8 ff ff       	jmp    80105737 <alltraps>

80105e5d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $70
80105e5f:	6a 46                	push   $0x46
  jmp alltraps
80105e61:	e9 d1 f8 ff ff       	jmp    80105737 <alltraps>

80105e66 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $71
80105e68:	6a 47                	push   $0x47
  jmp alltraps
80105e6a:	e9 c8 f8 ff ff       	jmp    80105737 <alltraps>

80105e6f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $72
80105e71:	6a 48                	push   $0x48
  jmp alltraps
80105e73:	e9 bf f8 ff ff       	jmp    80105737 <alltraps>

80105e78 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $73
80105e7a:	6a 49                	push   $0x49
  jmp alltraps
80105e7c:	e9 b6 f8 ff ff       	jmp    80105737 <alltraps>

80105e81 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $74
80105e83:	6a 4a                	push   $0x4a
  jmp alltraps
80105e85:	e9 ad f8 ff ff       	jmp    80105737 <alltraps>

80105e8a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $75
80105e8c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e8e:	e9 a4 f8 ff ff       	jmp    80105737 <alltraps>

80105e93 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $76
80105e95:	6a 4c                	push   $0x4c
  jmp alltraps
80105e97:	e9 9b f8 ff ff       	jmp    80105737 <alltraps>

80105e9c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $77
80105e9e:	6a 4d                	push   $0x4d
  jmp alltraps
80105ea0:	e9 92 f8 ff ff       	jmp    80105737 <alltraps>

80105ea5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $78
80105ea7:	6a 4e                	push   $0x4e
  jmp alltraps
80105ea9:	e9 89 f8 ff ff       	jmp    80105737 <alltraps>

80105eae <vector79>:
.globl vector79
vector79:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $79
80105eb0:	6a 4f                	push   $0x4f
  jmp alltraps
80105eb2:	e9 80 f8 ff ff       	jmp    80105737 <alltraps>

80105eb7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $80
80105eb9:	6a 50                	push   $0x50
  jmp alltraps
80105ebb:	e9 77 f8 ff ff       	jmp    80105737 <alltraps>

80105ec0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $81
80105ec2:	6a 51                	push   $0x51
  jmp alltraps
80105ec4:	e9 6e f8 ff ff       	jmp    80105737 <alltraps>

80105ec9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $82
80105ecb:	6a 52                	push   $0x52
  jmp alltraps
80105ecd:	e9 65 f8 ff ff       	jmp    80105737 <alltraps>

80105ed2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $83
80105ed4:	6a 53                	push   $0x53
  jmp alltraps
80105ed6:	e9 5c f8 ff ff       	jmp    80105737 <alltraps>

80105edb <vector84>:
.globl vector84
vector84:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $84
80105edd:	6a 54                	push   $0x54
  jmp alltraps
80105edf:	e9 53 f8 ff ff       	jmp    80105737 <alltraps>

80105ee4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $85
80105ee6:	6a 55                	push   $0x55
  jmp alltraps
80105ee8:	e9 4a f8 ff ff       	jmp    80105737 <alltraps>

80105eed <vector86>:
.globl vector86
vector86:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $86
80105eef:	6a 56                	push   $0x56
  jmp alltraps
80105ef1:	e9 41 f8 ff ff       	jmp    80105737 <alltraps>

80105ef6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $87
80105ef8:	6a 57                	push   $0x57
  jmp alltraps
80105efa:	e9 38 f8 ff ff       	jmp    80105737 <alltraps>

80105eff <vector88>:
.globl vector88
vector88:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $88
80105f01:	6a 58                	push   $0x58
  jmp alltraps
80105f03:	e9 2f f8 ff ff       	jmp    80105737 <alltraps>

80105f08 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $89
80105f0a:	6a 59                	push   $0x59
  jmp alltraps
80105f0c:	e9 26 f8 ff ff       	jmp    80105737 <alltraps>

80105f11 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $90
80105f13:	6a 5a                	push   $0x5a
  jmp alltraps
80105f15:	e9 1d f8 ff ff       	jmp    80105737 <alltraps>

80105f1a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $91
80105f1c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f1e:	e9 14 f8 ff ff       	jmp    80105737 <alltraps>

80105f23 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $92
80105f25:	6a 5c                	push   $0x5c
  jmp alltraps
80105f27:	e9 0b f8 ff ff       	jmp    80105737 <alltraps>

80105f2c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $93
80105f2e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f30:	e9 02 f8 ff ff       	jmp    80105737 <alltraps>

80105f35 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $94
80105f37:	6a 5e                	push   $0x5e
  jmp alltraps
80105f39:	e9 f9 f7 ff ff       	jmp    80105737 <alltraps>

80105f3e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $95
80105f40:	6a 5f                	push   $0x5f
  jmp alltraps
80105f42:	e9 f0 f7 ff ff       	jmp    80105737 <alltraps>

80105f47 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $96
80105f49:	6a 60                	push   $0x60
  jmp alltraps
80105f4b:	e9 e7 f7 ff ff       	jmp    80105737 <alltraps>

80105f50 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $97
80105f52:	6a 61                	push   $0x61
  jmp alltraps
80105f54:	e9 de f7 ff ff       	jmp    80105737 <alltraps>

80105f59 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $98
80105f5b:	6a 62                	push   $0x62
  jmp alltraps
80105f5d:	e9 d5 f7 ff ff       	jmp    80105737 <alltraps>

80105f62 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $99
80105f64:	6a 63                	push   $0x63
  jmp alltraps
80105f66:	e9 cc f7 ff ff       	jmp    80105737 <alltraps>

80105f6b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $100
80105f6d:	6a 64                	push   $0x64
  jmp alltraps
80105f6f:	e9 c3 f7 ff ff       	jmp    80105737 <alltraps>

80105f74 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $101
80105f76:	6a 65                	push   $0x65
  jmp alltraps
80105f78:	e9 ba f7 ff ff       	jmp    80105737 <alltraps>

80105f7d <vector102>:
.globl vector102
vector102:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $102
80105f7f:	6a 66                	push   $0x66
  jmp alltraps
80105f81:	e9 b1 f7 ff ff       	jmp    80105737 <alltraps>

80105f86 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $103
80105f88:	6a 67                	push   $0x67
  jmp alltraps
80105f8a:	e9 a8 f7 ff ff       	jmp    80105737 <alltraps>

80105f8f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $104
80105f91:	6a 68                	push   $0x68
  jmp alltraps
80105f93:	e9 9f f7 ff ff       	jmp    80105737 <alltraps>

80105f98 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $105
80105f9a:	6a 69                	push   $0x69
  jmp alltraps
80105f9c:	e9 96 f7 ff ff       	jmp    80105737 <alltraps>

80105fa1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $106
80105fa3:	6a 6a                	push   $0x6a
  jmp alltraps
80105fa5:	e9 8d f7 ff ff       	jmp    80105737 <alltraps>

80105faa <vector107>:
.globl vector107
vector107:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $107
80105fac:	6a 6b                	push   $0x6b
  jmp alltraps
80105fae:	e9 84 f7 ff ff       	jmp    80105737 <alltraps>

80105fb3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $108
80105fb5:	6a 6c                	push   $0x6c
  jmp alltraps
80105fb7:	e9 7b f7 ff ff       	jmp    80105737 <alltraps>

80105fbc <vector109>:
.globl vector109
vector109:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $109
80105fbe:	6a 6d                	push   $0x6d
  jmp alltraps
80105fc0:	e9 72 f7 ff ff       	jmp    80105737 <alltraps>

80105fc5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $110
80105fc7:	6a 6e                	push   $0x6e
  jmp alltraps
80105fc9:	e9 69 f7 ff ff       	jmp    80105737 <alltraps>

80105fce <vector111>:
.globl vector111
vector111:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $111
80105fd0:	6a 6f                	push   $0x6f
  jmp alltraps
80105fd2:	e9 60 f7 ff ff       	jmp    80105737 <alltraps>

80105fd7 <vector112>:
.globl vector112
vector112:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $112
80105fd9:	6a 70                	push   $0x70
  jmp alltraps
80105fdb:	e9 57 f7 ff ff       	jmp    80105737 <alltraps>

80105fe0 <vector113>:
.globl vector113
vector113:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $113
80105fe2:	6a 71                	push   $0x71
  jmp alltraps
80105fe4:	e9 4e f7 ff ff       	jmp    80105737 <alltraps>

80105fe9 <vector114>:
.globl vector114
vector114:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $114
80105feb:	6a 72                	push   $0x72
  jmp alltraps
80105fed:	e9 45 f7 ff ff       	jmp    80105737 <alltraps>

80105ff2 <vector115>:
.globl vector115
vector115:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $115
80105ff4:	6a 73                	push   $0x73
  jmp alltraps
80105ff6:	e9 3c f7 ff ff       	jmp    80105737 <alltraps>

80105ffb <vector116>:
.globl vector116
vector116:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $116
80105ffd:	6a 74                	push   $0x74
  jmp alltraps
80105fff:	e9 33 f7 ff ff       	jmp    80105737 <alltraps>

80106004 <vector117>:
.globl vector117
vector117:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $117
80106006:	6a 75                	push   $0x75
  jmp alltraps
80106008:	e9 2a f7 ff ff       	jmp    80105737 <alltraps>

8010600d <vector118>:
.globl vector118
vector118:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $118
8010600f:	6a 76                	push   $0x76
  jmp alltraps
80106011:	e9 21 f7 ff ff       	jmp    80105737 <alltraps>

80106016 <vector119>:
.globl vector119
vector119:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $119
80106018:	6a 77                	push   $0x77
  jmp alltraps
8010601a:	e9 18 f7 ff ff       	jmp    80105737 <alltraps>

8010601f <vector120>:
.globl vector120
vector120:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $120
80106021:	6a 78                	push   $0x78
  jmp alltraps
80106023:	e9 0f f7 ff ff       	jmp    80105737 <alltraps>

80106028 <vector121>:
.globl vector121
vector121:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $121
8010602a:	6a 79                	push   $0x79
  jmp alltraps
8010602c:	e9 06 f7 ff ff       	jmp    80105737 <alltraps>

80106031 <vector122>:
.globl vector122
vector122:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $122
80106033:	6a 7a                	push   $0x7a
  jmp alltraps
80106035:	e9 fd f6 ff ff       	jmp    80105737 <alltraps>

8010603a <vector123>:
.globl vector123
vector123:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $123
8010603c:	6a 7b                	push   $0x7b
  jmp alltraps
8010603e:	e9 f4 f6 ff ff       	jmp    80105737 <alltraps>

80106043 <vector124>:
.globl vector124
vector124:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $124
80106045:	6a 7c                	push   $0x7c
  jmp alltraps
80106047:	e9 eb f6 ff ff       	jmp    80105737 <alltraps>

8010604c <vector125>:
.globl vector125
vector125:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $125
8010604e:	6a 7d                	push   $0x7d
  jmp alltraps
80106050:	e9 e2 f6 ff ff       	jmp    80105737 <alltraps>

80106055 <vector126>:
.globl vector126
vector126:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $126
80106057:	6a 7e                	push   $0x7e
  jmp alltraps
80106059:	e9 d9 f6 ff ff       	jmp    80105737 <alltraps>

8010605e <vector127>:
.globl vector127
vector127:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $127
80106060:	6a 7f                	push   $0x7f
  jmp alltraps
80106062:	e9 d0 f6 ff ff       	jmp    80105737 <alltraps>

80106067 <vector128>:
.globl vector128
vector128:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $128
80106069:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010606e:	e9 c4 f6 ff ff       	jmp    80105737 <alltraps>

80106073 <vector129>:
.globl vector129
vector129:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $129
80106075:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010607a:	e9 b8 f6 ff ff       	jmp    80105737 <alltraps>

8010607f <vector130>:
.globl vector130
vector130:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $130
80106081:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106086:	e9 ac f6 ff ff       	jmp    80105737 <alltraps>

8010608b <vector131>:
.globl vector131
vector131:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $131
8010608d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106092:	e9 a0 f6 ff ff       	jmp    80105737 <alltraps>

80106097 <vector132>:
.globl vector132
vector132:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $132
80106099:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010609e:	e9 94 f6 ff ff       	jmp    80105737 <alltraps>

801060a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $133
801060a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060aa:	e9 88 f6 ff ff       	jmp    80105737 <alltraps>

801060af <vector134>:
.globl vector134
vector134:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $134
801060b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060b6:	e9 7c f6 ff ff       	jmp    80105737 <alltraps>

801060bb <vector135>:
.globl vector135
vector135:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $135
801060bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801060c2:	e9 70 f6 ff ff       	jmp    80105737 <alltraps>

801060c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $136
801060c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801060ce:	e9 64 f6 ff ff       	jmp    80105737 <alltraps>

801060d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $137
801060d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801060da:	e9 58 f6 ff ff       	jmp    80105737 <alltraps>

801060df <vector138>:
.globl vector138
vector138:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $138
801060e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801060e6:	e9 4c f6 ff ff       	jmp    80105737 <alltraps>

801060eb <vector139>:
.globl vector139
vector139:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $139
801060ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801060f2:	e9 40 f6 ff ff       	jmp    80105737 <alltraps>

801060f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $140
801060f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801060fe:	e9 34 f6 ff ff       	jmp    80105737 <alltraps>

80106103 <vector141>:
.globl vector141
vector141:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $141
80106105:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010610a:	e9 28 f6 ff ff       	jmp    80105737 <alltraps>

8010610f <vector142>:
.globl vector142
vector142:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $142
80106111:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106116:	e9 1c f6 ff ff       	jmp    80105737 <alltraps>

8010611b <vector143>:
.globl vector143
vector143:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $143
8010611d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106122:	e9 10 f6 ff ff       	jmp    80105737 <alltraps>

80106127 <vector144>:
.globl vector144
vector144:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $144
80106129:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010612e:	e9 04 f6 ff ff       	jmp    80105737 <alltraps>

80106133 <vector145>:
.globl vector145
vector145:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $145
80106135:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010613a:	e9 f8 f5 ff ff       	jmp    80105737 <alltraps>

8010613f <vector146>:
.globl vector146
vector146:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $146
80106141:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106146:	e9 ec f5 ff ff       	jmp    80105737 <alltraps>

8010614b <vector147>:
.globl vector147
vector147:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $147
8010614d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106152:	e9 e0 f5 ff ff       	jmp    80105737 <alltraps>

80106157 <vector148>:
.globl vector148
vector148:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $148
80106159:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010615e:	e9 d4 f5 ff ff       	jmp    80105737 <alltraps>

80106163 <vector149>:
.globl vector149
vector149:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $149
80106165:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010616a:	e9 c8 f5 ff ff       	jmp    80105737 <alltraps>

8010616f <vector150>:
.globl vector150
vector150:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $150
80106171:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106176:	e9 bc f5 ff ff       	jmp    80105737 <alltraps>

8010617b <vector151>:
.globl vector151
vector151:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $151
8010617d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106182:	e9 b0 f5 ff ff       	jmp    80105737 <alltraps>

80106187 <vector152>:
.globl vector152
vector152:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $152
80106189:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010618e:	e9 a4 f5 ff ff       	jmp    80105737 <alltraps>

80106193 <vector153>:
.globl vector153
vector153:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $153
80106195:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010619a:	e9 98 f5 ff ff       	jmp    80105737 <alltraps>

8010619f <vector154>:
.globl vector154
vector154:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $154
801061a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061a6:	e9 8c f5 ff ff       	jmp    80105737 <alltraps>

801061ab <vector155>:
.globl vector155
vector155:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $155
801061ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061b2:	e9 80 f5 ff ff       	jmp    80105737 <alltraps>

801061b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $156
801061b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061be:	e9 74 f5 ff ff       	jmp    80105737 <alltraps>

801061c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $157
801061c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801061ca:	e9 68 f5 ff ff       	jmp    80105737 <alltraps>

801061cf <vector158>:
.globl vector158
vector158:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $158
801061d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801061d6:	e9 5c f5 ff ff       	jmp    80105737 <alltraps>

801061db <vector159>:
.globl vector159
vector159:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $159
801061dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801061e2:	e9 50 f5 ff ff       	jmp    80105737 <alltraps>

801061e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $160
801061e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801061ee:	e9 44 f5 ff ff       	jmp    80105737 <alltraps>

801061f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $161
801061f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801061fa:	e9 38 f5 ff ff       	jmp    80105737 <alltraps>

801061ff <vector162>:
.globl vector162
vector162:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $162
80106201:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106206:	e9 2c f5 ff ff       	jmp    80105737 <alltraps>

8010620b <vector163>:
.globl vector163
vector163:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $163
8010620d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106212:	e9 20 f5 ff ff       	jmp    80105737 <alltraps>

80106217 <vector164>:
.globl vector164
vector164:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $164
80106219:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010621e:	e9 14 f5 ff ff       	jmp    80105737 <alltraps>

80106223 <vector165>:
.globl vector165
vector165:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $165
80106225:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010622a:	e9 08 f5 ff ff       	jmp    80105737 <alltraps>

8010622f <vector166>:
.globl vector166
vector166:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $166
80106231:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106236:	e9 fc f4 ff ff       	jmp    80105737 <alltraps>

8010623b <vector167>:
.globl vector167
vector167:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $167
8010623d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106242:	e9 f0 f4 ff ff       	jmp    80105737 <alltraps>

80106247 <vector168>:
.globl vector168
vector168:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $168
80106249:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010624e:	e9 e4 f4 ff ff       	jmp    80105737 <alltraps>

80106253 <vector169>:
.globl vector169
vector169:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $169
80106255:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010625a:	e9 d8 f4 ff ff       	jmp    80105737 <alltraps>

8010625f <vector170>:
.globl vector170
vector170:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $170
80106261:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106266:	e9 cc f4 ff ff       	jmp    80105737 <alltraps>

8010626b <vector171>:
.globl vector171
vector171:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $171
8010626d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106272:	e9 c0 f4 ff ff       	jmp    80105737 <alltraps>

80106277 <vector172>:
.globl vector172
vector172:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $172
80106279:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010627e:	e9 b4 f4 ff ff       	jmp    80105737 <alltraps>

80106283 <vector173>:
.globl vector173
vector173:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $173
80106285:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010628a:	e9 a8 f4 ff ff       	jmp    80105737 <alltraps>

8010628f <vector174>:
.globl vector174
vector174:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $174
80106291:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106296:	e9 9c f4 ff ff       	jmp    80105737 <alltraps>

8010629b <vector175>:
.globl vector175
vector175:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $175
8010629d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062a2:	e9 90 f4 ff ff       	jmp    80105737 <alltraps>

801062a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $176
801062a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062ae:	e9 84 f4 ff ff       	jmp    80105737 <alltraps>

801062b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $177
801062b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062ba:	e9 78 f4 ff ff       	jmp    80105737 <alltraps>

801062bf <vector178>:
.globl vector178
vector178:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $178
801062c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801062c6:	e9 6c f4 ff ff       	jmp    80105737 <alltraps>

801062cb <vector179>:
.globl vector179
vector179:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $179
801062cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801062d2:	e9 60 f4 ff ff       	jmp    80105737 <alltraps>

801062d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $180
801062d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801062de:	e9 54 f4 ff ff       	jmp    80105737 <alltraps>

801062e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $181
801062e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801062ea:	e9 48 f4 ff ff       	jmp    80105737 <alltraps>

801062ef <vector182>:
.globl vector182
vector182:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $182
801062f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801062f6:	e9 3c f4 ff ff       	jmp    80105737 <alltraps>

801062fb <vector183>:
.globl vector183
vector183:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $183
801062fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106302:	e9 30 f4 ff ff       	jmp    80105737 <alltraps>

80106307 <vector184>:
.globl vector184
vector184:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $184
80106309:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010630e:	e9 24 f4 ff ff       	jmp    80105737 <alltraps>

80106313 <vector185>:
.globl vector185
vector185:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $185
80106315:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010631a:	e9 18 f4 ff ff       	jmp    80105737 <alltraps>

8010631f <vector186>:
.globl vector186
vector186:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $186
80106321:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106326:	e9 0c f4 ff ff       	jmp    80105737 <alltraps>

8010632b <vector187>:
.globl vector187
vector187:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $187
8010632d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106332:	e9 00 f4 ff ff       	jmp    80105737 <alltraps>

80106337 <vector188>:
.globl vector188
vector188:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $188
80106339:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010633e:	e9 f4 f3 ff ff       	jmp    80105737 <alltraps>

80106343 <vector189>:
.globl vector189
vector189:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $189
80106345:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010634a:	e9 e8 f3 ff ff       	jmp    80105737 <alltraps>

8010634f <vector190>:
.globl vector190
vector190:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $190
80106351:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106356:	e9 dc f3 ff ff       	jmp    80105737 <alltraps>

8010635b <vector191>:
.globl vector191
vector191:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $191
8010635d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106362:	e9 d0 f3 ff ff       	jmp    80105737 <alltraps>

80106367 <vector192>:
.globl vector192
vector192:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $192
80106369:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010636e:	e9 c4 f3 ff ff       	jmp    80105737 <alltraps>

80106373 <vector193>:
.globl vector193
vector193:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $193
80106375:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010637a:	e9 b8 f3 ff ff       	jmp    80105737 <alltraps>

8010637f <vector194>:
.globl vector194
vector194:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $194
80106381:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106386:	e9 ac f3 ff ff       	jmp    80105737 <alltraps>

8010638b <vector195>:
.globl vector195
vector195:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $195
8010638d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106392:	e9 a0 f3 ff ff       	jmp    80105737 <alltraps>

80106397 <vector196>:
.globl vector196
vector196:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $196
80106399:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010639e:	e9 94 f3 ff ff       	jmp    80105737 <alltraps>

801063a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $197
801063a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063aa:	e9 88 f3 ff ff       	jmp    80105737 <alltraps>

801063af <vector198>:
.globl vector198
vector198:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $198
801063b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063b6:	e9 7c f3 ff ff       	jmp    80105737 <alltraps>

801063bb <vector199>:
.globl vector199
vector199:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $199
801063bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801063c2:	e9 70 f3 ff ff       	jmp    80105737 <alltraps>

801063c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $200
801063c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801063ce:	e9 64 f3 ff ff       	jmp    80105737 <alltraps>

801063d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $201
801063d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801063da:	e9 58 f3 ff ff       	jmp    80105737 <alltraps>

801063df <vector202>:
.globl vector202
vector202:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $202
801063e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801063e6:	e9 4c f3 ff ff       	jmp    80105737 <alltraps>

801063eb <vector203>:
.globl vector203
vector203:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $203
801063ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801063f2:	e9 40 f3 ff ff       	jmp    80105737 <alltraps>

801063f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $204
801063f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801063fe:	e9 34 f3 ff ff       	jmp    80105737 <alltraps>

80106403 <vector205>:
.globl vector205
vector205:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $205
80106405:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010640a:	e9 28 f3 ff ff       	jmp    80105737 <alltraps>

8010640f <vector206>:
.globl vector206
vector206:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $206
80106411:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106416:	e9 1c f3 ff ff       	jmp    80105737 <alltraps>

8010641b <vector207>:
.globl vector207
vector207:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $207
8010641d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106422:	e9 10 f3 ff ff       	jmp    80105737 <alltraps>

80106427 <vector208>:
.globl vector208
vector208:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $208
80106429:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010642e:	e9 04 f3 ff ff       	jmp    80105737 <alltraps>

80106433 <vector209>:
.globl vector209
vector209:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $209
80106435:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010643a:	e9 f8 f2 ff ff       	jmp    80105737 <alltraps>

8010643f <vector210>:
.globl vector210
vector210:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $210
80106441:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106446:	e9 ec f2 ff ff       	jmp    80105737 <alltraps>

8010644b <vector211>:
.globl vector211
vector211:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $211
8010644d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106452:	e9 e0 f2 ff ff       	jmp    80105737 <alltraps>

80106457 <vector212>:
.globl vector212
vector212:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $212
80106459:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010645e:	e9 d4 f2 ff ff       	jmp    80105737 <alltraps>

80106463 <vector213>:
.globl vector213
vector213:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $213
80106465:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010646a:	e9 c8 f2 ff ff       	jmp    80105737 <alltraps>

8010646f <vector214>:
.globl vector214
vector214:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $214
80106471:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106476:	e9 bc f2 ff ff       	jmp    80105737 <alltraps>

8010647b <vector215>:
.globl vector215
vector215:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $215
8010647d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106482:	e9 b0 f2 ff ff       	jmp    80105737 <alltraps>

80106487 <vector216>:
.globl vector216
vector216:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $216
80106489:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010648e:	e9 a4 f2 ff ff       	jmp    80105737 <alltraps>

80106493 <vector217>:
.globl vector217
vector217:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $217
80106495:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010649a:	e9 98 f2 ff ff       	jmp    80105737 <alltraps>

8010649f <vector218>:
.globl vector218
vector218:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $218
801064a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064a6:	e9 8c f2 ff ff       	jmp    80105737 <alltraps>

801064ab <vector219>:
.globl vector219
vector219:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $219
801064ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064b2:	e9 80 f2 ff ff       	jmp    80105737 <alltraps>

801064b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $220
801064b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064be:	e9 74 f2 ff ff       	jmp    80105737 <alltraps>

801064c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $221
801064c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801064ca:	e9 68 f2 ff ff       	jmp    80105737 <alltraps>

801064cf <vector222>:
.globl vector222
vector222:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $222
801064d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801064d6:	e9 5c f2 ff ff       	jmp    80105737 <alltraps>

801064db <vector223>:
.globl vector223
vector223:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $223
801064dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801064e2:	e9 50 f2 ff ff       	jmp    80105737 <alltraps>

801064e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $224
801064e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801064ee:	e9 44 f2 ff ff       	jmp    80105737 <alltraps>

801064f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $225
801064f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801064fa:	e9 38 f2 ff ff       	jmp    80105737 <alltraps>

801064ff <vector226>:
.globl vector226
vector226:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $226
80106501:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106506:	e9 2c f2 ff ff       	jmp    80105737 <alltraps>

8010650b <vector227>:
.globl vector227
vector227:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $227
8010650d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106512:	e9 20 f2 ff ff       	jmp    80105737 <alltraps>

80106517 <vector228>:
.globl vector228
vector228:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $228
80106519:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010651e:	e9 14 f2 ff ff       	jmp    80105737 <alltraps>

80106523 <vector229>:
.globl vector229
vector229:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $229
80106525:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010652a:	e9 08 f2 ff ff       	jmp    80105737 <alltraps>

8010652f <vector230>:
.globl vector230
vector230:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $230
80106531:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106536:	e9 fc f1 ff ff       	jmp    80105737 <alltraps>

8010653b <vector231>:
.globl vector231
vector231:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $231
8010653d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106542:	e9 f0 f1 ff ff       	jmp    80105737 <alltraps>

80106547 <vector232>:
.globl vector232
vector232:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $232
80106549:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010654e:	e9 e4 f1 ff ff       	jmp    80105737 <alltraps>

80106553 <vector233>:
.globl vector233
vector233:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $233
80106555:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010655a:	e9 d8 f1 ff ff       	jmp    80105737 <alltraps>

8010655f <vector234>:
.globl vector234
vector234:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $234
80106561:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106566:	e9 cc f1 ff ff       	jmp    80105737 <alltraps>

8010656b <vector235>:
.globl vector235
vector235:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $235
8010656d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106572:	e9 c0 f1 ff ff       	jmp    80105737 <alltraps>

80106577 <vector236>:
.globl vector236
vector236:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $236
80106579:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010657e:	e9 b4 f1 ff ff       	jmp    80105737 <alltraps>

80106583 <vector237>:
.globl vector237
vector237:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $237
80106585:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010658a:	e9 a8 f1 ff ff       	jmp    80105737 <alltraps>

8010658f <vector238>:
.globl vector238
vector238:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $238
80106591:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106596:	e9 9c f1 ff ff       	jmp    80105737 <alltraps>

8010659b <vector239>:
.globl vector239
vector239:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $239
8010659d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065a2:	e9 90 f1 ff ff       	jmp    80105737 <alltraps>

801065a7 <vector240>:
.globl vector240
vector240:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $240
801065a9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065ae:	e9 84 f1 ff ff       	jmp    80105737 <alltraps>

801065b3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $241
801065b5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065ba:	e9 78 f1 ff ff       	jmp    80105737 <alltraps>

801065bf <vector242>:
.globl vector242
vector242:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $242
801065c1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801065c6:	e9 6c f1 ff ff       	jmp    80105737 <alltraps>

801065cb <vector243>:
.globl vector243
vector243:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $243
801065cd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801065d2:	e9 60 f1 ff ff       	jmp    80105737 <alltraps>

801065d7 <vector244>:
.globl vector244
vector244:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $244
801065d9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801065de:	e9 54 f1 ff ff       	jmp    80105737 <alltraps>

801065e3 <vector245>:
.globl vector245
vector245:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $245
801065e5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801065ea:	e9 48 f1 ff ff       	jmp    80105737 <alltraps>

801065ef <vector246>:
.globl vector246
vector246:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $246
801065f1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801065f6:	e9 3c f1 ff ff       	jmp    80105737 <alltraps>

801065fb <vector247>:
.globl vector247
vector247:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $247
801065fd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106602:	e9 30 f1 ff ff       	jmp    80105737 <alltraps>

80106607 <vector248>:
.globl vector248
vector248:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $248
80106609:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010660e:	e9 24 f1 ff ff       	jmp    80105737 <alltraps>

80106613 <vector249>:
.globl vector249
vector249:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $249
80106615:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010661a:	e9 18 f1 ff ff       	jmp    80105737 <alltraps>

8010661f <vector250>:
.globl vector250
vector250:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $250
80106621:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106626:	e9 0c f1 ff ff       	jmp    80105737 <alltraps>

8010662b <vector251>:
.globl vector251
vector251:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $251
8010662d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106632:	e9 00 f1 ff ff       	jmp    80105737 <alltraps>

80106637 <vector252>:
.globl vector252
vector252:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $252
80106639:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010663e:	e9 f4 f0 ff ff       	jmp    80105737 <alltraps>

80106643 <vector253>:
.globl vector253
vector253:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $253
80106645:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010664a:	e9 e8 f0 ff ff       	jmp    80105737 <alltraps>

8010664f <vector254>:
.globl vector254
vector254:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $254
80106651:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106656:	e9 dc f0 ff ff       	jmp    80105737 <alltraps>

8010665b <vector255>:
.globl vector255
vector255:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $255
8010665d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106662:	e9 d0 f0 ff ff       	jmp    80105737 <alltraps>
80106667:	66 90                	xchg   %ax,%ax
80106669:	66 90                	xchg   %ax,%ax
8010666b:	66 90                	xchg   %ax,%ax
8010666d:	66 90                	xchg   %ax,%ax
8010666f:	90                   	nop

80106670 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	56                   	push   %esi
80106675:	53                   	push   %ebx
80106676:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106678:	c1 ea 16             	shr    $0x16,%edx
8010667b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010667e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106681:	8b 07                	mov    (%edi),%eax
80106683:	a8 01                	test   $0x1,%al
80106685:	74 29                	je     801066b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106687:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010668c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106692:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106695:	c1 eb 0a             	shr    $0xa,%ebx
80106698:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010669e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
801066a1:	5b                   	pop    %ebx
801066a2:	5e                   	pop    %esi
801066a3:	5f                   	pop    %edi
801066a4:	5d                   	pop    %ebp
801066a5:	c3                   	ret    
801066a6:	8d 76 00             	lea    0x0(%esi),%esi
801066a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801066b0:	85 c9                	test   %ecx,%ecx
801066b2:	74 2c                	je     801066e0 <walkpgdir+0x70>
801066b4:	e8 d7 bd ff ff       	call   80102490 <kalloc>
801066b9:	85 c0                	test   %eax,%eax
801066bb:	89 c6                	mov    %eax,%esi
801066bd:	74 21                	je     801066e0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801066bf:	83 ec 04             	sub    $0x4,%esp
801066c2:	68 00 10 00 00       	push   $0x1000
801066c7:	6a 00                	push   $0x0
801066c9:	50                   	push   %eax
801066ca:	e8 f1 dd ff ff       	call   801044c0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801066cf:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801066d5:	83 c4 10             	add    $0x10,%esp
801066d8:	83 c8 07             	or     $0x7,%eax
801066db:	89 07                	mov    %eax,(%edi)
801066dd:	eb b3                	jmp    80106692 <walkpgdir+0x22>
801066df:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
801066e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801066e3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801066e5:	5b                   	pop    %ebx
801066e6:	5e                   	pop    %esi
801066e7:	5f                   	pop    %edi
801066e8:	5d                   	pop    %ebp
801066e9:	c3                   	ret    
801066ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066f0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	57                   	push   %edi
801066f4:	56                   	push   %esi
801066f5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801066f6:	89 d3                	mov    %edx,%ebx
801066f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066fe:	83 ec 1c             	sub    $0x1c,%esp
80106701:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106704:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106708:	8b 7d 08             	mov    0x8(%ebp),%edi
8010670b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106710:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106713:	8b 45 0c             	mov    0xc(%ebp),%eax
80106716:	29 df                	sub    %ebx,%edi
80106718:	83 c8 01             	or     $0x1,%eax
8010671b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010671e:	eb 15                	jmp    80106735 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106720:	f6 00 01             	testb  $0x1,(%eax)
80106723:	75 45                	jne    8010676a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106725:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106728:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010672b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010672d:	74 31                	je     80106760 <mappages+0x70>
      break;
    a += PGSIZE;
8010672f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106738:	b9 01 00 00 00       	mov    $0x1,%ecx
8010673d:	89 da                	mov    %ebx,%edx
8010673f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106742:	e8 29 ff ff ff       	call   80106670 <walkpgdir>
80106747:	85 c0                	test   %eax,%eax
80106749:	75 d5                	jne    80106720 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010674b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010674e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106753:	5b                   	pop    %ebx
80106754:	5e                   	pop    %esi
80106755:	5f                   	pop    %edi
80106756:	5d                   	pop    %ebp
80106757:	c3                   	ret    
80106758:	90                   	nop
80106759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106760:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106763:	31 c0                	xor    %eax,%eax
}
80106765:	5b                   	pop    %ebx
80106766:	5e                   	pop    %esi
80106767:	5f                   	pop    %edi
80106768:	5d                   	pop    %ebp
80106769:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010676a:	83 ec 0c             	sub    $0xc,%esp
8010676d:	68 30 82 10 80       	push   $0x80108230
80106772:	e8 f9 9b ff ff       	call   80100370 <panic>
80106777:	89 f6                	mov    %esi,%esi
80106779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106780 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	57                   	push   %edi
80106784:	56                   	push   %esi
80106785:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106786:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010678c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010678e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106794:	83 ec 1c             	sub    $0x1c,%esp
80106797:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010679a:	39 d3                	cmp    %edx,%ebx
8010679c:	73 66                	jae    80106804 <deallocuvm.part.0+0x84>
8010679e:	89 d6                	mov    %edx,%esi
801067a0:	eb 3d                	jmp    801067df <deallocuvm.part.0+0x5f>
801067a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801067a8:	8b 10                	mov    (%eax),%edx
801067aa:	f6 c2 01             	test   $0x1,%dl
801067ad:	74 26                	je     801067d5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801067af:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801067b5:	74 58                	je     8010680f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801067b7:	83 ec 0c             	sub    $0xc,%esp
801067ba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801067c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067c3:	52                   	push   %edx
801067c4:	e8 17 bb ff ff       	call   801022e0 <kfree>
      *pte = 0;
801067c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067cc:	83 c4 10             	add    $0x10,%esp
801067cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067d5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067db:	39 f3                	cmp    %esi,%ebx
801067dd:	73 25                	jae    80106804 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067df:	31 c9                	xor    %ecx,%ecx
801067e1:	89 da                	mov    %ebx,%edx
801067e3:	89 f8                	mov    %edi,%eax
801067e5:	e8 86 fe ff ff       	call   80106670 <walkpgdir>
    if(!pte)
801067ea:	85 c0                	test   %eax,%eax
801067ec:	75 ba                	jne    801067a8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801067ee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801067f4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106800:	39 f3                	cmp    %esi,%ebx
80106802:	72 db                	jb     801067df <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106804:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106807:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010680a:	5b                   	pop    %ebx
8010680b:	5e                   	pop    %esi
8010680c:	5f                   	pop    %edi
8010680d:	5d                   	pop    %ebp
8010680e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010680f:	83 ec 0c             	sub    $0xc,%esp
80106812:	68 c6 7b 10 80       	push   $0x80107bc6
80106817:	e8 54 9b ff ff       	call   80100370 <panic>
8010681c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106820 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106826:	e8 b5 cf ff ff       	call   801037e0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010682b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106831:	31 c9                	xor    %ecx,%ecx
80106833:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106838:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
8010683f:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106846:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010684b:	31 c9                	xor    %ecx,%ecx
8010684d:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106854:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106859:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106860:	31 c9                	xor    %ecx,%ecx
80106862:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80106869:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106870:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106875:	31 c9                	xor    %ecx,%ecx
80106877:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010687e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106885:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010688a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80106891:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80106898:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010689f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
801068a6:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
801068ad:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
801068b4:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068bb:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
801068c2:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
801068c9:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
801068d0:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068d7:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
801068de:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
801068e5:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
801068ec:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
801068f3:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801068fa:	05 f0 37 11 80       	add    $0x801137f0,%eax
801068ff:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106903:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106907:	c1 e8 10             	shr    $0x10,%eax
8010690a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010690e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106911:	0f 01 10             	lgdtl  (%eax)
}
80106914:	c9                   	leave  
80106915:	c3                   	ret    
80106916:	8d 76 00             	lea    0x0(%esi),%esi
80106919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106920 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106920:	a1 f4 30 12 80       	mov    0x801230f4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106925:	55                   	push   %ebp
80106926:	89 e5                	mov    %esp,%ebp
80106928:	05 00 00 00 80       	add    $0x80000000,%eax
8010692d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106930:	5d                   	pop    %ebp
80106931:	c3                   	ret    
80106932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106940 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	53                   	push   %ebx
80106946:	83 ec 1c             	sub    $0x1c,%esp
80106949:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010694c:	85 f6                	test   %esi,%esi
8010694e:	0f 84 cd 00 00 00    	je     80106a21 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106954:	8b 46 08             	mov    0x8(%esi),%eax
80106957:	85 c0                	test   %eax,%eax
80106959:	0f 84 dc 00 00 00    	je     80106a3b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010695f:	8b 7e 04             	mov    0x4(%esi),%edi
80106962:	85 ff                	test   %edi,%edi
80106964:	0f 84 c4 00 00 00    	je     80106a2e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010696a:	e8 a1 d9 ff ff       	call   80104310 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010696f:	e8 ec cd ff ff       	call   80103760 <mycpu>
80106974:	89 c3                	mov    %eax,%ebx
80106976:	e8 e5 cd ff ff       	call   80103760 <mycpu>
8010697b:	89 c7                	mov    %eax,%edi
8010697d:	e8 de cd ff ff       	call   80103760 <mycpu>
80106982:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106985:	83 c7 08             	add    $0x8,%edi
80106988:	e8 d3 cd ff ff       	call   80103760 <mycpu>
8010698d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106990:	83 c0 08             	add    $0x8,%eax
80106993:	ba 67 00 00 00       	mov    $0x67,%edx
80106998:	c1 e8 18             	shr    $0x18,%eax
8010699b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801069a2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801069a9:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801069b0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801069b7:	83 c1 08             	add    $0x8,%ecx
801069ba:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801069c0:	c1 e9 10             	shr    $0x10,%ecx
801069c3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069c9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801069ce:	e8 8d cd ff ff       	call   80103760 <mycpu>
801069d3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801069da:	e8 81 cd ff ff       	call   80103760 <mycpu>
801069df:	b9 10 00 00 00       	mov    $0x10,%ecx
801069e4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801069e8:	e8 73 cd ff ff       	call   80103760 <mycpu>
801069ed:	8b 56 08             	mov    0x8(%esi),%edx
801069f0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801069f6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069f9:	e8 62 cd ff ff       	call   80103760 <mycpu>
801069fe:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106a02:	b8 28 00 00 00       	mov    $0x28,%eax
80106a07:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a0a:	8b 46 04             	mov    0x4(%esi),%eax
80106a0d:	05 00 00 00 80       	add    $0x80000000,%eax
80106a12:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106a15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a18:	5b                   	pop    %ebx
80106a19:	5e                   	pop    %esi
80106a1a:	5f                   	pop    %edi
80106a1b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106a1c:	e9 df d9 ff ff       	jmp    80104400 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106a21:	83 ec 0c             	sub    $0xc,%esp
80106a24:	68 36 82 10 80       	push   $0x80108236
80106a29:	e8 42 99 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106a2e:	83 ec 0c             	sub    $0xc,%esp
80106a31:	68 61 82 10 80       	push   $0x80108261
80106a36:	e8 35 99 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106a3b:	83 ec 0c             	sub    $0xc,%esp
80106a3e:	68 4c 82 10 80       	push   $0x8010824c
80106a43:	e8 28 99 ff ff       	call   80100370 <panic>
80106a48:	90                   	nop
80106a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a50 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	83 ec 1c             	sub    $0x1c,%esp
80106a59:	8b 75 10             	mov    0x10(%ebp),%esi
80106a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106a62:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106a68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106a6b:	77 49                	ja     80106ab6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106a6d:	e8 1e ba ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
80106a72:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106a75:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a77:	68 00 10 00 00       	push   $0x1000
80106a7c:	6a 00                	push   $0x0
80106a7e:	50                   	push   %eax
80106a7f:	e8 3c da ff ff       	call   801044c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a84:	58                   	pop    %eax
80106a85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a8b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a90:	5a                   	pop    %edx
80106a91:	6a 06                	push   $0x6
80106a93:	50                   	push   %eax
80106a94:	31 d2                	xor    %edx,%edx
80106a96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a99:	e8 52 fc ff ff       	call   801066f0 <mappages>
  memmove(mem, init, sz);
80106a9e:	89 75 10             	mov    %esi,0x10(%ebp)
80106aa1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106aa4:	83 c4 10             	add    $0x10,%esp
80106aa7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106aad:	5b                   	pop    %ebx
80106aae:	5e                   	pop    %esi
80106aaf:	5f                   	pop    %edi
80106ab0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106ab1:	e9 ba da ff ff       	jmp    80104570 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106ab6:	83 ec 0c             	sub    $0xc,%esp
80106ab9:	68 75 82 10 80       	push   $0x80108275
80106abe:	e8 ad 98 ff ff       	call   80100370 <panic>
80106ac3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ad0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
80106ad6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106ad9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ae0:	0f 85 91 00 00 00    	jne    80106b77 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106ae6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ae9:	31 db                	xor    %ebx,%ebx
80106aeb:	85 f6                	test   %esi,%esi
80106aed:	75 1a                	jne    80106b09 <loaduvm+0x39>
80106aef:	eb 6f                	jmp    80106b60 <loaduvm+0x90>
80106af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106af8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106afe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106b04:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106b07:	76 57                	jbe    80106b60 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b09:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b0f:	31 c9                	xor    %ecx,%ecx
80106b11:	01 da                	add    %ebx,%edx
80106b13:	e8 58 fb ff ff       	call   80106670 <walkpgdir>
80106b18:	85 c0                	test   %eax,%eax
80106b1a:	74 4e                	je     80106b6a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b1c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b1e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106b21:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b2b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b31:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b34:	01 d9                	add    %ebx,%ecx
80106b36:	05 00 00 00 80       	add    $0x80000000,%eax
80106b3b:	57                   	push   %edi
80106b3c:	51                   	push   %ecx
80106b3d:	50                   	push   %eax
80106b3e:	ff 75 10             	pushl  0x10(%ebp)
80106b41:	e8 0a ae ff ff       	call   80101950 <readi>
80106b46:	83 c4 10             	add    $0x10,%esp
80106b49:	39 c7                	cmp    %eax,%edi
80106b4b:	74 ab                	je     80106af8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106b4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106b55:	5b                   	pop    %ebx
80106b56:	5e                   	pop    %esi
80106b57:	5f                   	pop    %edi
80106b58:	5d                   	pop    %ebp
80106b59:	c3                   	ret    
80106b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106b63:	31 c0                	xor    %eax,%eax
}
80106b65:	5b                   	pop    %ebx
80106b66:	5e                   	pop    %esi
80106b67:	5f                   	pop    %edi
80106b68:	5d                   	pop    %ebp
80106b69:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106b6a:	83 ec 0c             	sub    $0xc,%esp
80106b6d:	68 8f 82 10 80       	push   $0x8010828f
80106b72:	e8 f9 97 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106b77:	83 ec 0c             	sub    $0xc,%esp
80106b7a:	68 90 84 10 80       	push   $0x80108490
80106b7f:	e8 ec 97 ff ff       	call   80100370 <panic>
80106b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b90 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
80106b96:	83 ec 0c             	sub    $0xc,%esp
80106b99:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106b9c:	85 ff                	test   %edi,%edi
80106b9e:	0f 88 ca 00 00 00    	js     80106c6e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106ba4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106baa:	0f 82 82 00 00 00    	jb     80106c32 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106bb0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106bb6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106bbc:	39 df                	cmp    %ebx,%edi
80106bbe:	77 43                	ja     80106c03 <allocuvm+0x73>
80106bc0:	e9 bb 00 00 00       	jmp    80106c80 <allocuvm+0xf0>
80106bc5:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106bc8:	83 ec 04             	sub    $0x4,%esp
80106bcb:	68 00 10 00 00       	push   $0x1000
80106bd0:	6a 00                	push   $0x0
80106bd2:	50                   	push   %eax
80106bd3:	e8 e8 d8 ff ff       	call   801044c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106bd8:	58                   	pop    %eax
80106bd9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106bdf:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106be4:	5a                   	pop    %edx
80106be5:	6a 06                	push   $0x6
80106be7:	50                   	push   %eax
80106be8:	89 da                	mov    %ebx,%edx
80106bea:	8b 45 08             	mov    0x8(%ebp),%eax
80106bed:	e8 fe fa ff ff       	call   801066f0 <mappages>
80106bf2:	83 c4 10             	add    $0x10,%esp
80106bf5:	85 c0                	test   %eax,%eax
80106bf7:	78 47                	js     80106c40 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106bf9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bff:	39 df                	cmp    %ebx,%edi
80106c01:	76 7d                	jbe    80106c80 <allocuvm+0xf0>
    mem = kalloc();
80106c03:	e8 88 b8 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
80106c08:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106c0a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c0c:	75 ba                	jne    80106bc8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106c0e:	83 ec 0c             	sub    $0xc,%esp
80106c11:	68 ad 82 10 80       	push   $0x801082ad
80106c16:	e8 45 9a ff ff       	call   80100660 <cprintf>
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c1b:	83 c4 10             	add    $0x10,%esp
80106c1e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c21:	76 4b                	jbe    80106c6e <allocuvm+0xde>
80106c23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c26:	8b 45 08             	mov    0x8(%ebp),%eax
80106c29:	89 fa                	mov    %edi,%edx
80106c2b:	e8 50 fb ff ff       	call   80106780 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106c30:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c35:	5b                   	pop    %ebx
80106c36:	5e                   	pop    %esi
80106c37:	5f                   	pop    %edi
80106c38:	5d                   	pop    %ebp
80106c39:	c3                   	ret    
80106c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106c40:	83 ec 0c             	sub    $0xc,%esp
80106c43:	68 c5 82 10 80       	push   $0x801082c5
80106c48:	e8 13 9a ff ff       	call   80100660 <cprintf>
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c4d:	83 c4 10             	add    $0x10,%esp
80106c50:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c53:	76 0d                	jbe    80106c62 <allocuvm+0xd2>
80106c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c58:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5b:	89 fa                	mov    %edi,%edx
80106c5d:	e8 1e fb ff ff       	call   80106780 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106c62:	83 ec 0c             	sub    $0xc,%esp
80106c65:	56                   	push   %esi
80106c66:	e8 75 b6 ff ff       	call   801022e0 <kfree>
      return 0;
80106c6b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106c71:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106c73:	5b                   	pop    %ebx
80106c74:	5e                   	pop    %esi
80106c75:	5f                   	pop    %edi
80106c76:	5d                   	pop    %ebp
80106c77:	c3                   	ret    
80106c78:	90                   	nop
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c83:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c85:	5b                   	pop    %ebx
80106c86:	5e                   	pop    %esi
80106c87:	5f                   	pop    %edi
80106c88:	5d                   	pop    %ebp
80106c89:	c3                   	ret    
80106c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c90 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c96:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c99:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c9c:	39 d1                	cmp    %edx,%ecx
80106c9e:	73 10                	jae    80106cb0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ca0:	5d                   	pop    %ebp
80106ca1:	e9 da fa ff ff       	jmp    80106780 <deallocuvm.part.0>
80106ca6:	8d 76 00             	lea    0x0(%esi),%esi
80106ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106cb0:	89 d0                	mov    %edx,%eax
80106cb2:	5d                   	pop    %ebp
80106cb3:	c3                   	ret    
80106cb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106cc0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	83 ec 0c             	sub    $0xc,%esp
80106cc9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ccc:	85 f6                	test   %esi,%esi
80106cce:	74 59                	je     80106d29 <freevm+0x69>
80106cd0:	31 c9                	xor    %ecx,%ecx
80106cd2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106cd7:	89 f0                	mov    %esi,%eax
80106cd9:	e8 a2 fa ff ff       	call   80106780 <deallocuvm.part.0>
80106cde:	89 f3                	mov    %esi,%ebx
80106ce0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ce6:	eb 0f                	jmp    80106cf7 <freevm+0x37>
80106ce8:	90                   	nop
80106ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cf0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106cf3:	39 fb                	cmp    %edi,%ebx
80106cf5:	74 23                	je     80106d1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106cf7:	8b 03                	mov    (%ebx),%eax
80106cf9:	a8 01                	test   $0x1,%al
80106cfb:	74 f3                	je     80106cf0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106cfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d02:	83 ec 0c             	sub    $0xc,%esp
80106d05:	83 c3 04             	add    $0x4,%ebx
80106d08:	05 00 00 00 80       	add    $0x80000000,%eax
80106d0d:	50                   	push   %eax
80106d0e:	e8 cd b5 ff ff       	call   801022e0 <kfree>
80106d13:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d16:	39 fb                	cmp    %edi,%ebx
80106d18:	75 dd                	jne    80106cf7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d20:	5b                   	pop    %ebx
80106d21:	5e                   	pop    %esi
80106d22:	5f                   	pop    %edi
80106d23:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d24:	e9 b7 b5 ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106d29:	83 ec 0c             	sub    $0xc,%esp
80106d2c:	68 e1 82 10 80       	push   $0x801082e1
80106d31:	e8 3a 96 ff ff       	call   80100370 <panic>
80106d36:	8d 76 00             	lea    0x0(%esi),%esi
80106d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d40 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	56                   	push   %esi
80106d44:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106d45:	e8 46 b7 ff ff       	call   80102490 <kalloc>
80106d4a:	85 c0                	test   %eax,%eax
80106d4c:	74 6a                	je     80106db8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106d4e:	83 ec 04             	sub    $0x4,%esp
80106d51:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d53:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106d58:	68 00 10 00 00       	push   $0x1000
80106d5d:	6a 00                	push   $0x0
80106d5f:	50                   	push   %eax
80106d60:	e8 5b d7 ff ff       	call   801044c0 <memset>
80106d65:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d68:	8b 43 04             	mov    0x4(%ebx),%eax
80106d6b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d6e:	83 ec 08             	sub    $0x8,%esp
80106d71:	8b 13                	mov    (%ebx),%edx
80106d73:	ff 73 0c             	pushl  0xc(%ebx)
80106d76:	50                   	push   %eax
80106d77:	29 c1                	sub    %eax,%ecx
80106d79:	89 f0                	mov    %esi,%eax
80106d7b:	e8 70 f9 ff ff       	call   801066f0 <mappages>
80106d80:	83 c4 10             	add    $0x10,%esp
80106d83:	85 c0                	test   %eax,%eax
80106d85:	78 19                	js     80106da0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d87:	83 c3 10             	add    $0x10,%ebx
80106d8a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80106d90:	75 d6                	jne    80106d68 <setupkvm+0x28>
80106d92:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106d94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d97:	5b                   	pop    %ebx
80106d98:	5e                   	pop    %esi
80106d99:	5d                   	pop    %ebp
80106d9a:	c3                   	ret    
80106d9b:	90                   	nop
80106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106da0:	83 ec 0c             	sub    $0xc,%esp
80106da3:	56                   	push   %esi
80106da4:	e8 17 ff ff ff       	call   80106cc0 <freevm>
      return 0;
80106da9:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106dac:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106daf:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106db1:	5b                   	pop    %ebx
80106db2:	5e                   	pop    %esi
80106db3:	5d                   	pop    %ebp
80106db4:	c3                   	ret    
80106db5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106db8:	31 c0                	xor    %eax,%eax
80106dba:	eb d8                	jmp    80106d94 <setupkvm+0x54>
80106dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106dc0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106dc6:	e8 75 ff ff ff       	call   80106d40 <setupkvm>
80106dcb:	a3 f4 30 12 80       	mov    %eax,0x801230f4
80106dd0:	05 00 00 00 80       	add    $0x80000000,%eax
80106dd5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106dd8:	c9                   	leave  
80106dd9:	c3                   	ret    
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106de0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106de0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106de1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106de3:	89 e5                	mov    %esp,%ebp
80106de5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106de8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106deb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dee:	e8 7d f8 ff ff       	call   80106670 <walkpgdir>
  if(pte == 0)
80106df3:	85 c0                	test   %eax,%eax
80106df5:	74 05                	je     80106dfc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106df7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dfa:	c9                   	leave  
80106dfb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106dfc:	83 ec 0c             	sub    $0xc,%esp
80106dff:	68 f2 82 10 80       	push   $0x801082f2
80106e04:	e8 67 95 ff ff       	call   80100370 <panic>
80106e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e19:	e8 22 ff ff ff       	call   80106d40 <setupkvm>
80106e1e:	85 c0                	test   %eax,%eax
80106e20:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e23:	0f 84 b2 00 00 00    	je     80106edb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e2c:	85 c9                	test   %ecx,%ecx
80106e2e:	0f 84 9c 00 00 00    	je     80106ed0 <copyuvm+0xc0>
80106e34:	31 f6                	xor    %esi,%esi
80106e36:	eb 4a                	jmp    80106e82 <copyuvm+0x72>
80106e38:	90                   	nop
80106e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e40:	83 ec 04             	sub    $0x4,%esp
80106e43:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e49:	68 00 10 00 00       	push   $0x1000
80106e4e:	57                   	push   %edi
80106e4f:	50                   	push   %eax
80106e50:	e8 1b d7 ff ff       	call   80104570 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e55:	58                   	pop    %eax
80106e56:	5a                   	pop    %edx
80106e57:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e60:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e63:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e68:	52                   	push   %edx
80106e69:	89 f2                	mov    %esi,%edx
80106e6b:	e8 80 f8 ff ff       	call   801066f0 <mappages>
80106e70:	83 c4 10             	add    $0x10,%esp
80106e73:	85 c0                	test   %eax,%eax
80106e75:	78 3e                	js     80106eb5 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e77:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e7d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106e80:	76 4e                	jbe    80106ed0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e82:	8b 45 08             	mov    0x8(%ebp),%eax
80106e85:	31 c9                	xor    %ecx,%ecx
80106e87:	89 f2                	mov    %esi,%edx
80106e89:	e8 e2 f7 ff ff       	call   80106670 <walkpgdir>
80106e8e:	85 c0                	test   %eax,%eax
80106e90:	74 5a                	je     80106eec <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106e92:	8b 18                	mov    (%eax),%ebx
80106e94:	f6 c3 01             	test   $0x1,%bl
80106e97:	74 46                	je     80106edf <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e99:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106e9b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106ea1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106ea4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106eaa:	e8 e1 b5 ff ff       	call   80102490 <kalloc>
80106eaf:	85 c0                	test   %eax,%eax
80106eb1:	89 c3                	mov    %eax,%ebx
80106eb3:	75 8b                	jne    80106e40 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106eb5:	83 ec 0c             	sub    $0xc,%esp
80106eb8:	ff 75 e0             	pushl  -0x20(%ebp)
80106ebb:	e8 00 fe ff ff       	call   80106cc0 <freevm>
  return 0;
80106ec0:	83 c4 10             	add    $0x10,%esp
80106ec3:	31 c0                	xor    %eax,%eax
}
80106ec5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ec8:	5b                   	pop    %ebx
80106ec9:	5e                   	pop    %esi
80106eca:	5f                   	pop    %edi
80106ecb:	5d                   	pop    %ebp
80106ecc:	c3                   	ret    
80106ecd:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ed6:	5b                   	pop    %ebx
80106ed7:	5e                   	pop    %esi
80106ed8:	5f                   	pop    %edi
80106ed9:	5d                   	pop    %ebp
80106eda:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106edb:	31 c0                	xor    %eax,%eax
80106edd:	eb e6                	jmp    80106ec5 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106edf:	83 ec 0c             	sub    $0xc,%esp
80106ee2:	68 16 83 10 80       	push   $0x80108316
80106ee7:	e8 84 94 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106eec:	83 ec 0c             	sub    $0xc,%esp
80106eef:	68 fc 82 10 80       	push   $0x801082fc
80106ef4:	e8 77 94 ff ff       	call   80100370 <panic>
80106ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f00 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f00:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f01:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f03:	89 e5                	mov    %esp,%ebp
80106f05:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f08:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f0e:	e8 5d f7 ff ff       	call   80106670 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f13:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106f15:	89 c2                	mov    %eax,%edx
80106f17:	83 e2 05             	and    $0x5,%edx
80106f1a:	83 fa 05             	cmp    $0x5,%edx
80106f1d:	75 11                	jne    80106f30 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106f24:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f25:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106f2a:	c3                   	ret    
80106f2b:	90                   	nop
80106f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106f30:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f32:	c9                   	leave  
80106f33:	c3                   	ret    
80106f34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f40 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	57                   	push   %edi
80106f44:	56                   	push   %esi
80106f45:	53                   	push   %ebx
80106f46:	83 ec 1c             	sub    $0x1c,%esp
80106f49:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f52:	85 db                	test   %ebx,%ebx
80106f54:	75 40                	jne    80106f96 <copyout+0x56>
80106f56:	eb 70                	jmp    80106fc8 <copyout+0x88>
80106f58:	90                   	nop
80106f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f63:	89 f1                	mov    %esi,%ecx
80106f65:	29 d1                	sub    %edx,%ecx
80106f67:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106f6d:	39 d9                	cmp    %ebx,%ecx
80106f6f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f72:	29 f2                	sub    %esi,%edx
80106f74:	83 ec 04             	sub    $0x4,%esp
80106f77:	01 d0                	add    %edx,%eax
80106f79:	51                   	push   %ecx
80106f7a:	57                   	push   %edi
80106f7b:	50                   	push   %eax
80106f7c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f7f:	e8 ec d5 ff ff       	call   80104570 <memmove>
    len -= n;
    buf += n;
80106f84:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f87:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106f8a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106f90:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f92:	29 cb                	sub    %ecx,%ebx
80106f94:	74 32                	je     80106fc8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106f96:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f98:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106f9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f9e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fa4:	56                   	push   %esi
80106fa5:	ff 75 08             	pushl  0x8(%ebp)
80106fa8:	e8 53 ff ff ff       	call   80106f00 <uva2ka>
    if(pa0 == 0)
80106fad:	83 c4 10             	add    $0x10,%esp
80106fb0:	85 c0                	test   %eax,%eax
80106fb2:	75 ac                	jne    80106f60 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106fb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106fbc:	5b                   	pop    %ebx
80106fbd:	5e                   	pop    %esi
80106fbe:	5f                   	pop    %edi
80106fbf:	5d                   	pop    %ebp
80106fc0:	c3                   	ret    
80106fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106fcb:	31 c0                	xor    %eax,%eax
}
80106fcd:	5b                   	pop    %ebx
80106fce:	5e                   	pop    %esi
80106fcf:	5f                   	pop    %edi
80106fd0:	5d                   	pop    %ebp
80106fd1:	c3                   	ret    
80106fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fe0 <shmeminit>:
shm_table sh_table;


void
shmeminit(void)
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	56                   	push   %esi
80106fe4:	53                   	push   %ebx
80106fe5:	be f8 2d 12 80       	mov    $0x80122df8,%esi
80106fea:	bb f4 2e 12 80       	mov    $0x80122ef4,%ebx
	int i ;
  initlock(&(sh_table.lock), "SHMEM");
80106fef:	83 ec 08             	sub    $0x8,%esp
80106ff2:	68 30 83 10 80       	push   $0x80108330
80106ff7:	68 c0 2d 12 80       	push   $0x80122dc0
80106ffc:	e8 4f d2 ff ff       	call   80104250 <initlock>
  acquire(&(sh_table.lock));
80107001:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
80107008:	e8 43 d3 ff ff       	call   80104350 <acquire>
8010700d:	83 c4 10             	add    $0x10,%esp
	for (i=0; i<SHMEM_PAGES; i++)
	{
		sh_table.shp_array[i].shmem_counter = 0;
		sh_table.shp_array[i].shmem_addr = 0;
		memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
80107010:	83 ec 04             	sub    $0x4,%esp
	int i ;
  initlock(&(sh_table.lock), "SHMEM");
  acquire(&(sh_table.lock));
	for (i=0; i<SHMEM_PAGES; i++)
	{
		sh_table.shp_array[i].shmem_counter = 0;
80107013:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		sh_table.shp_array[i].shmem_addr = 0;
80107019:	c7 46 fc 00 00 00 00 	movl   $0x0,-0x4(%esi)
		memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
80107020:	6a 10                	push   $0x10
80107022:	6a 00                	push   $0x0
80107024:	83 c6 08             	add    $0x8,%esi
80107027:	53                   	push   %ebx
80107028:	83 c3 10             	add    $0x10,%ebx
8010702b:	e8 90 d4 ff ff       	call   801044c0 <memset>
shmeminit(void)
{
	int i ;
  initlock(&(sh_table.lock), "SHMEM");
  acquire(&(sh_table.lock));
	for (i=0; i<SHMEM_PAGES; i++)
80107030:	83 c4 10             	add    $0x10,%esp
80107033:	81 fb f4 30 12 80    	cmp    $0x801230f4,%ebx
80107039:	75 d5                	jne    80107010 <shmeminit+0x30>
	{
		sh_table.shp_array[i].shmem_counter = 0;
		sh_table.shp_array[i].shmem_addr = 0;
		memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
	}
  release(&(sh_table.lock));
8010703b:	83 ec 0c             	sub    $0xc,%esp
8010703e:	68 c0 2d 12 80       	push   $0x80122dc0
80107043:	e8 28 d4 ff ff       	call   80104470 <release>
}
80107048:	83 c4 10             	add    $0x10,%esp
8010704b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010704e:	5b                   	pop    %ebx
8010704f:	5e                   	pop    %esi
80107050:	5d                   	pop    %ebp
80107051:	c3                   	ret    
80107052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107060 <shmget>:

void *
shmget(sh_key_t *key)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
80107066:	bf f4 2e 12 80       	mov    $0x80122ef4,%edi
  cprintf("SHMGET\n");
  acquire(&(sh_table.lock));
  
  int i;
	int first_free_addr = -1;
	for (i=0;i<SHMEM_PAGES;i++)
8010706b:	31 f6                	xor    %esi,%esi
  release(&(sh_table.lock));
}

void *
shmget(sh_key_t *key)
{
8010706d:	83 ec 38             	sub    $0x38,%esp
80107070:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("SHMGET\n");
80107073:	68 36 83 10 80       	push   $0x80108336
80107078:	e8 e3 95 ff ff       	call   80100660 <cprintf>
  acquire(&(sh_table.lock));
8010707d:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
80107084:	e8 c7 d2 ff ff       	call   80104350 <acquire>
80107089:	83 c4 10             	add    $0x10,%esp
  
  int i;
	int first_free_addr = -1;
8010708c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80107093:	eb 25                	jmp    801070ba <shmget+0x5a>
80107095:	8d 76 00             	lea    0x0(%esi),%esi
      first_free_addr = i;
      cprintf("FFF %d\n",first_free_addr);
			continue;
		}

		if (strncmp(sh_table.shp_key[i].shmem_key, key, sizeof(sh_key_t)*16) == 0 )
80107098:	83 ec 04             	sub    $0x4,%esp
8010709b:	6a 10                	push   $0x10
8010709d:	53                   	push   %ebx
8010709e:	57                   	push   %edi
8010709f:	e8 4c d5 ff ff       	call   801045f0 <strncmp>
801070a4:	83 c4 10             	add    $0x10,%esp
801070a7:	85 c0                	test   %eax,%eax
801070a9:	0f 84 f9 01 00 00    	je     801072a8 <shmget+0x248>
  cprintf("SHMGET\n");
  acquire(&(sh_table.lock));
  
  int i;
	int first_free_addr = -1;
	for (i=0;i<SHMEM_PAGES;i++)
801070af:	83 c6 01             	add    $0x1,%esi
801070b2:	83 c7 10             	add    $0x10,%edi
801070b5:	83 fe 20             	cmp    $0x20,%esi
801070b8:	74 2e                	je     801070e8 <shmget+0x88>
	{
		if (*sh_table.shp_key[i].shmem_key == 0 && first_free_addr == -1)
801070ba:	80 3f 00             	cmpb   $0x0,(%edi)
801070bd:	75 d9                	jne    80107098 <shmget+0x38>
801070bf:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
801070c3:	75 d3                	jne    80107098 <shmget+0x38>
		{
      first_free_addr = i;
      cprintf("FFF %d\n",first_free_addr);
801070c5:	83 ec 08             	sub    $0x8,%esp
801070c8:	83 c7 10             	add    $0x10,%edi
801070cb:	56                   	push   %esi
801070cc:	68 3e 83 10 80       	push   $0x8010833e
801070d1:	e8 8a 95 ff ff       	call   80100660 <cprintf>
			continue;
801070d6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  cprintf("SHMGET\n");
  acquire(&(sh_table.lock));
  
  int i;
	int first_free_addr = -1;
	for (i=0;i<SHMEM_PAGES;i++)
801070d9:	83 c6 01             	add    $0x1,%esi
	{
		if (*sh_table.shp_key[i].shmem_key == 0 && first_free_addr == -1)
		{
      first_free_addr = i;
      cprintf("FFF %d\n",first_free_addr);
			continue;
801070dc:	83 c4 10             	add    $0x10,%esp
  cprintf("SHMGET\n");
  acquire(&(sh_table.lock));
  
  int i;
	int first_free_addr = -1;
	for (i=0;i<SHMEM_PAGES;i++)
801070df:	83 fe 20             	cmp    $0x20,%esi
801070e2:	75 d6                	jne    801070ba <shmget+0x5a>
801070e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			panic("Max processes.\n");
    }
	}
	else
	{
		if (first_free_addr == -1)
801070e8:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
801070ec:	0f 84 4e 03 00 00    	je     80107440 <shmget+0x3e0>
			panic("Full shared pages.\n");
		if ((sh_table.shp_array[first_free_addr].shmem_addr = kalloc()) == 0)
801070f2:	e8 99 b3 ff ff       	call   80102490 <kalloc>
801070f7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070fa:	85 c0                	test   %eax,%eax
801070fc:	8d 71 06             	lea    0x6(%ecx),%esi
801070ff:	89 04 f5 c4 2d 12 80 	mov    %eax,-0x7fedd23c(,%esi,8)
80107106:	0f 84 41 03 00 00    	je     8010744d <shmget+0x3ed>
			panic("Failed to allocate.\n");
    cprintf("KALLOC %x\n",sh_table.shp_array[first_free_addr].shmem_addr);
8010710c:	83 ec 08             	sub    $0x8,%esp

int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
8010710f:	31 ff                	xor    %edi,%edi
	{
		if (first_free_addr == -1)
			panic("Full shared pages.\n");
		if ((sh_table.shp_array[first_free_addr].shmem_addr = kalloc()) == 0)
			panic("Failed to allocate.\n");
    cprintf("KALLOC %x\n",sh_table.shp_array[first_free_addr].shmem_addr);
80107111:	50                   	push   %eax
80107112:	68 c3 83 10 80       	push   $0x801083c3
80107117:	e8 44 95 ff ff       	call   80100660 <cprintf>
		memset(sh_table.shp_array[first_free_addr].shmem_addr, 0, PGSIZE);
8010711c:	83 c4 0c             	add    $0xc,%esp
8010711f:	68 00 10 00 00       	push   $0x1000
80107124:	6a 00                	push   $0x0
80107126:	ff 34 f5 c4 2d 12 80 	pushl  -0x7fedd23c(,%esi,8)
8010712d:	e8 8e d3 ff ff       	call   801044c0 <memset>
80107132:	83 c4 10             	add    $0x10,%esp
80107135:	eb 15                	jmp    8010714c <shmget+0xec>
80107137:	89 f6                	mov    %esi,%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
80107140:	83 c7 01             	add    $0x1,%edi
80107143:	83 ff 20             	cmp    $0x20,%edi
80107146:	0f 84 bc 02 00 00    	je     80107408 <shmget+0x3a8>
  {
    if (myproc()->phy_shared_page[i] == 0)
8010714c:	e8 af c6 ff ff       	call   80103800 <myproc>
80107151:	8b 84 b8 80 00 00 00 	mov    0x80(%eax,%edi,4),%eax
80107158:	85 c0                	test   %eax,%eax
8010715a:	75 e4                	jne    80107140 <shmget+0xe0>
8010715c:	8d 47 01             	lea    0x1(%edi),%eax
8010715f:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107164:	89 7d e0             	mov    %edi,-0x20(%ebp)
80107167:	c1 e0 0c             	shl    $0xc,%eax
8010716a:	29 c2                	sub    %eax,%edx
8010716c:	89 55 dc             	mov    %edx,-0x24(%ebp)
		if ((sh_table.shp_array[first_free_addr].shmem_addr = kalloc()) == 0)
			panic("Failed to allocate.\n");
    cprintf("KALLOC %x\n",sh_table.shp_array[first_free_addr].shmem_addr);
		memset(sh_table.shp_array[first_free_addr].shmem_addr, 0, PGSIZE);
    pos = find_pos();
    myproc()->top = (void *)(KERNBASE-PGSIZE*(pos+1));
8010716f:	e8 8c c6 ff ff       	call   80103800 <myproc>
80107174:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107177:	89 50 7c             	mov    %edx,0x7c(%eax)
    cprintf("POS %d and %x\n",pos,(unsigned int) myproc()->top);
8010717a:	e8 81 c6 ff ff       	call   80103800 <myproc>
8010717f:	83 ec 04             	sub    $0x4,%esp
80107182:	ff 70 7c             	pushl  0x7c(%eax)
80107185:	ff 75 e0             	pushl  -0x20(%ebp)
80107188:	68 ce 83 10 80       	push   $0x801083ce
8010718d:	e8 ce 94 ff ff       	call   80100660 <cprintf>
		if ((mappages(myproc()->pgdir, myproc()->top, PGSIZE, V2P(sh_table.shp_array[first_free_addr].shmem_addr), PTE_W|PTE_U))<0)
80107192:	8b 04 f5 c4 2d 12 80 	mov    -0x7fedd23c(,%esi,8),%eax
80107199:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
8010719f:	e8 5c c6 ff ff       	call   80103800 <myproc>
801071a4:	8b 50 7c             	mov    0x7c(%eax),%edx
801071a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
801071aa:	e8 51 c6 ff ff       	call   80103800 <myproc>
801071af:	5a                   	pop    %edx
801071b0:	59                   	pop    %ecx
801071b1:	8b 40 04             	mov    0x4(%eax),%eax
801071b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
801071b7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071bc:	6a 06                	push   $0x6
801071be:	57                   	push   %edi
801071bf:	e8 2c f5 ff ff       	call   801066f0 <mappages>
801071c4:	83 c4 10             	add    $0x10,%esp
801071c7:	85 c0                	test   %eax,%eax
801071c9:	0f 88 64 02 00 00    	js     80107433 <shmget+0x3d3>
801071cf:	31 ff                	xor    %edi,%edi
801071d1:	eb 0d                	jmp    801071e0 <shmget+0x180>
801071d3:	90                   	nop
801071d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			panic("Failed to map page.\n"); 

    int y;
    for (y=0;y<SHMEM_PAGES;y++)
801071d8:	83 c7 01             	add    $0x1,%edi
801071db:	83 ff 20             	cmp    $0x20,%edi
801071de:	74 10                	je     801071f0 <shmget+0x190>
    {
      if (myproc()->vm_shared_page[y] == 0)
801071e0:	e8 1b c6 ff ff       	call   80103800 <myproc>
801071e5:	8b 84 b8 00 01 00 00 	mov    0x100(%eax,%edi,4),%eax
801071ec:	85 c0                	test   %eax,%eax
801071ee:	75 e8                	jne    801071d8 <shmget+0x178>
        break;
    }
		memmove(sh_table.shp_key[first_free_addr].shmem_key , key, strlen(key)); 
801071f0:	83 ec 0c             	sub    $0xc,%esp
    memmove(myproc()->p_key[y].keys, key, strlen(key)); 
801071f3:	83 c7 18             	add    $0x18,%edi
    for (y=0;y<SHMEM_PAGES;y++)
    {
      if (myproc()->vm_shared_page[y] == 0)
        break;
    }
		memmove(sh_table.shp_key[first_free_addr].shmem_key , key, strlen(key)); 
801071f6:	53                   	push   %ebx
    memmove(myproc()->p_key[y].keys, key, strlen(key)); 
801071f7:	c1 e7 04             	shl    $0x4,%edi
    for (y=0;y<SHMEM_PAGES;y++)
    {
      if (myproc()->vm_shared_page[y] == 0)
        break;
    }
		memmove(sh_table.shp_key[first_free_addr].shmem_key , key, strlen(key)); 
801071fa:	e8 01 d5 ff ff       	call   80104700 <strlen>
801071ff:	83 c4 0c             	add    $0xc,%esp
80107202:	50                   	push   %eax
80107203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107206:	53                   	push   %ebx
80107207:	c1 e0 04             	shl    $0x4,%eax
8010720a:	05 f4 2e 12 80       	add    $0x80122ef4,%eax
8010720f:	50                   	push   %eax
80107210:	e8 5b d3 ff ff       	call   80104570 <memmove>
    memmove(myproc()->p_key[y].keys, key, strlen(key)); 
80107215:	89 1c 24             	mov    %ebx,(%esp)
80107218:	e8 e3 d4 ff ff       	call   80104700 <strlen>
8010721d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107220:	e8 db c5 ff ff       	call   80103800 <myproc>
80107225:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107228:	83 c4 0c             	add    $0xc,%esp
8010722b:	01 f8                	add    %edi,%eax
8010722d:	52                   	push   %edx
8010722e:	53                   	push   %ebx
8010722f:	50                   	push   %eax
80107230:	e8 3b d3 ff ff       	call   80104570 <memmove>
		sh_table.shp_array[first_free_addr].shmem_counter++;
80107235:	8b 04 f5 c8 2d 12 80 	mov    -0x7fedd238(,%esi,8),%eax
    cprintf("COUNTER %d\n",sh_table.shp_array[first_free_addr].shmem_counter);
8010723c:	5a                   	pop    %edx
8010723d:	59                   	pop    %ecx
      if (myproc()->vm_shared_page[y] == 0)
        break;
    }
		memmove(sh_table.shp_key[first_free_addr].shmem_key , key, strlen(key)); 
    memmove(myproc()->p_key[y].keys, key, strlen(key)); 
		sh_table.shp_array[first_free_addr].shmem_counter++;
8010723e:	83 c0 01             	add    $0x1,%eax
    cprintf("COUNTER %d\n",sh_table.shp_array[first_free_addr].shmem_counter);
80107241:	50                   	push   %eax
80107242:	68 dd 83 10 80       	push   $0x801083dd
      if (myproc()->vm_shared_page[y] == 0)
        break;
    }
		memmove(sh_table.shp_key[first_free_addr].shmem_key , key, strlen(key)); 
    memmove(myproc()->p_key[y].keys, key, strlen(key)); 
		sh_table.shp_array[first_free_addr].shmem_counter++;
80107247:	89 04 f5 c8 2d 12 80 	mov    %eax,-0x7fedd238(,%esi,8)
    cprintf("COUNTER %d\n",sh_table.shp_array[first_free_addr].shmem_counter);
8010724e:	e8 0d 94 ff ff       	call   80100660 <cprintf>
		temp = myproc()->top;
80107253:	e8 a8 c5 ff ff       	call   80103800 <myproc>
80107258:	8b 58 7c             	mov    0x7c(%eax),%ebx
    myproc()->bitmap[pos] = 1;
8010725b:	e8 a0 c5 ff ff       	call   80103800 <myproc>
80107260:	8b 7d e0             	mov    -0x20(%ebp),%edi
80107263:	c6 84 38 80 03 00 00 	movb   $0x1,0x380(%eax,%edi,1)
8010726a:	01 
    myproc()->phy_shared_page[pos] = sh_table.shp_array[first_free_addr].shmem_addr;
8010726b:	e8 90 c5 ff ff       	call   80103800 <myproc>
80107270:	8b 14 f5 c4 2d 12 80 	mov    -0x7fedd23c(,%esi,8),%edx
80107277:	89 94 b8 80 00 00 00 	mov    %edx,0x80(%eax,%edi,4)
    myproc()->vm_shared_page[pos] = temp;
8010727e:	e8 7d c5 ff ff       	call   80103800 <myproc>
80107283:	89 9c b8 00 01 00 00 	mov    %ebx,0x100(%eax,%edi,4)

    release(&(sh_table.lock));
8010728a:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
80107291:	e8 da d1 ff ff       	call   80104470 <release>
		return temp;
80107296:	83 c4 10             	add    $0x10,%esp
	}

	return (void *) 0xffffffff;					//Error
}
80107299:	8d 65 f4             	lea    -0xc(%ebp),%esp
    myproc()->bitmap[pos] = 1;
    myproc()->phy_shared_page[pos] = sh_table.shp_array[first_free_addr].shmem_addr;
    myproc()->vm_shared_page[pos] = temp;

    release(&(sh_table.lock));
		return temp;
8010729c:	89 d8                	mov    %ebx,%eax
	}

	return (void *) 0xffffffff;					//Error
}
8010729e:	5b                   	pop    %ebx
8010729f:	5e                   	pop    %esi
801072a0:	5f                   	pop    %edi
801072a1:	5d                   	pop    %ebp
801072a2:	c3                   	ret    
801072a3:	90                   	nop
801072a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			continue;
		}

		if (strncmp(sh_table.shp_key[i].shmem_key, key, sizeof(sh_key_t)*16) == 0 )
		{
      char * temp = sh_table.shp_array[i].shmem_addr;
801072a8:	8d 46 06             	lea    0x6(%esi),%eax
801072ab:	89 c7                	mov    %eax,%edi
801072ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072b0:	8b 04 c5 c4 2d 12 80 	mov    -0x7fedd23c(,%eax,8),%eax
			cprintf("HERE i =%d and %x , %d\n",i,(unsigned int)sh_table.shp_array[i].shmem_addr,*temp);
801072b7:	0f be 10             	movsbl (%eax),%edx
801072ba:	52                   	push   %edx
801072bb:	50                   	push   %eax
801072bc:	56                   	push   %esi
801072bd:	68 46 83 10 80       	push   $0x80108346
801072c2:	e8 99 93 ff ff       	call   80100660 <cprintf>
	
	void * temp;
  int pos;
	if (i<SHMEM_PAGES)
	{
		if (sh_table.shp_array[i].shmem_counter < 16)
801072c7:	83 c4 10             	add    $0x10,%esp
801072ca:	83 3c fd c8 2d 12 80 	cmpl   $0xf,-0x7fedd238(,%edi,8)
801072d1:	0f 
801072d2:	0f 8f 82 01 00 00    	jg     8010745a <shmget+0x3fa>
801072d8:	31 ff                	xor    %edi,%edi
801072da:	eb 10                	jmp    801072ec <shmget+0x28c>
801072dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
801072e0:	83 c7 01             	add    $0x1,%edi
801072e3:	83 ff 20             	cmp    $0x20,%edi
801072e6:	0f 84 34 01 00 00    	je     80107420 <shmget+0x3c0>
  {
    if (myproc()->phy_shared_page[i] == 0)
801072ec:	e8 0f c5 ff ff       	call   80103800 <myproc>
801072f1:	8b 84 b8 80 00 00 00 	mov    0x80(%eax,%edi,4),%eax
801072f8:	85 c0                	test   %eax,%eax
801072fa:	75 e4                	jne    801072e0 <shmget+0x280>
801072fc:	8d 47 01             	lea    0x1(%edi),%eax
801072ff:	b9 00 00 00 80       	mov    $0x80000000,%ecx
80107304:	89 7d dc             	mov    %edi,-0x24(%ebp)
80107307:	c1 e0 0c             	shl    $0xc,%eax
8010730a:	29 c1                	sub    %eax,%ecx
8010730c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	if (i<SHMEM_PAGES)
	{
		if (sh_table.shp_array[i].shmem_counter < 16)
		{
      pos = find_pos();
      myproc()->top = (void *)(KERNBASE-PGSIZE*(pos+1));
8010730f:	e8 ec c4 ff ff       	call   80103800 <myproc>
80107314:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80107317:	89 48 7c             	mov    %ecx,0x7c(%eax)
			if ((mappages(myproc()->pgdir, myproc()->top, PGSIZE, V2P(sh_table.shp_array[i].shmem_addr), PTE_W|PTE_U))<0)
8010731a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010731d:	8b 04 c5 c4 2d 12 80 	mov    -0x7fedd23c(,%eax,8),%eax
80107324:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010732a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010732d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80107330:	e8 cb c4 ff ff       	call   80103800 <myproc>
80107335:	8b 50 7c             	mov    0x7c(%eax),%edx
80107338:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010733b:	e8 c0 c4 ff ff       	call   80103800 <myproc>
80107340:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80107343:	83 ec 08             	sub    $0x8,%esp
80107346:	8b 40 04             	mov    0x4(%eax),%eax
80107349:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010734c:	6a 06                	push   $0x6
8010734e:	51                   	push   %ecx
8010734f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107354:	e8 97 f3 ff ff       	call   801066f0 <mappages>
80107359:	83 c4 10             	add    $0x10,%esp
8010735c:	85 c0                	test   %eax,%eax
8010735e:	0f 88 cf 00 00 00    	js     80107433 <shmget+0x3d3>
				panic("Failed to map page.\n");
			sh_table.shp_array[i].shmem_counter++;
80107364:	8b 7d e0             	mov    -0x20(%ebp),%edi
			cprintf("counter %d and pos %d\n",sh_table.shp_array[i].shmem_counter,i);
80107367:	83 ec 04             	sub    $0x4,%esp
8010736a:	56                   	push   %esi
		{
      pos = find_pos();
      myproc()->top = (void *)(KERNBASE-PGSIZE*(pos+1));
			if ((mappages(myproc()->pgdir, myproc()->top, PGSIZE, V2P(sh_table.shp_array[i].shmem_addr), PTE_W|PTE_U))<0)
				panic("Failed to map page.\n");
			sh_table.shp_array[i].shmem_counter++;
8010736b:	8b 04 fd c8 2d 12 80 	mov    -0x7fedd238(,%edi,8),%eax
80107372:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107375:	83 c0 01             	add    $0x1,%eax
			cprintf("counter %d and pos %d\n",sh_table.shp_array[i].shmem_counter,i);
80107378:	50                   	push   %eax
80107379:	68 73 83 10 80       	push   $0x80108373
		{
      pos = find_pos();
      myproc()->top = (void *)(KERNBASE-PGSIZE*(pos+1));
			if ((mappages(myproc()->pgdir, myproc()->top, PGSIZE, V2P(sh_table.shp_array[i].shmem_addr), PTE_W|PTE_U))<0)
				panic("Failed to map page.\n");
			sh_table.shp_array[i].shmem_counter++;
8010737e:	89 04 fd c8 2d 12 80 	mov    %eax,-0x7fedd238(,%edi,8)
			cprintf("counter %d and pos %d\n",sh_table.shp_array[i].shmem_counter,i);
80107385:	e8 d6 92 ff ff       	call   80100660 <cprintf>
			temp = myproc()->top;
8010738a:	e8 71 c4 ff ff       	call   80103800 <myproc>
8010738f:	8b 70 7c             	mov    0x7c(%eax),%esi
      myproc()->bitmap[pos] = 1;
80107392:	e8 69 c4 ff ff       	call   80103800 <myproc>
80107397:	8b 4d dc             	mov    -0x24(%ebp),%ecx
8010739a:	c6 84 08 80 03 00 00 	movb   $0x1,0x380(%eax,%ecx,1)
801073a1:	01 
      myproc()->phy_shared_page[pos] = sh_table.shp_array[i].shmem_addr;
801073a2:	e8 59 c4 ff ff       	call   80103800 <myproc>
801073a7:	8b 14 fd c4 2d 12 80 	mov    -0x7fedd23c(,%edi,8),%edx
801073ae:	8b 7d dc             	mov    -0x24(%ebp),%edi
801073b1:	89 94 b8 80 00 00 00 	mov    %edx,0x80(%eax,%edi,4)
      myproc()->vm_shared_page[pos] = temp;
801073b8:	e8 43 c4 ff ff       	call   80103800 <myproc>
801073bd:	89 b4 b8 00 01 00 00 	mov    %esi,0x100(%eax,%edi,4)
      memmove(myproc()->p_key[first_free_addr].keys, key, strlen(key)); 
801073c4:	89 1c 24             	mov    %ebx,(%esp)
801073c7:	e8 34 d3 ff ff       	call   80104700 <strlen>
801073cc:	89 c7                	mov    %eax,%edi
801073ce:	e8 2d c4 ff ff       	call   80103800 <myproc>
801073d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801073d6:	83 c4 0c             	add    $0xc,%esp
801073d9:	57                   	push   %edi
801073da:	53                   	push   %ebx
801073db:	83 c2 18             	add    $0x18,%edx
801073de:	c1 e2 04             	shl    $0x4,%edx
801073e1:	01 d0                	add    %edx,%eax
801073e3:	50                   	push   %eax
801073e4:	e8 87 d1 ff ff       	call   80104570 <memmove>
      
      release(&(sh_table.lock));
801073e9:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
801073f0:	e8 7b d0 ff ff       	call   80104470 <release>
			return temp;
801073f5:	83 c4 10             	add    $0x10,%esp
    release(&(sh_table.lock));
		return temp;
	}

	return (void *) 0xffffffff;					//Error
}
801073f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      myproc()->phy_shared_page[pos] = sh_table.shp_array[i].shmem_addr;
      myproc()->vm_shared_page[pos] = temp;
      memmove(myproc()->p_key[first_free_addr].keys, key, strlen(key)); 
      
      release(&(sh_table.lock));
			return temp;
801073fb:	89 f0                	mov    %esi,%eax
    release(&(sh_table.lock));
		return temp;
	}

	return (void *) 0xffffffff;					//Error
}
801073fd:	5b                   	pop    %ebx
801073fe:	5e                   	pop    %esi
801073ff:	5f                   	pop    %edi
80107400:	5d                   	pop    %ebp
80107401:	c3                   	ret    
80107402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
80107408:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
  {
    if (myproc()->phy_shared_page[i] == 0)
      return i;
  }
  return -1;
8010740f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
80107416:	e9 54 fd ff ff       	jmp    8010716f <shmget+0x10f>
8010741b:	90                   	nop
8010741c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
80107420:	c7 45 d8 00 00 00 80 	movl   $0x80000000,-0x28(%ebp)
  {
    if (myproc()->phy_shared_page[i] == 0)
      return i;
  }
  return -1;
80107427:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
8010742e:	e9 dc fe ff ff       	jmp    8010730f <shmget+0x2af>
		if (sh_table.shp_array[i].shmem_counter < 16)
		{
      pos = find_pos();
      myproc()->top = (void *)(KERNBASE-PGSIZE*(pos+1));
			if ((mappages(myproc()->pgdir, myproc()->top, PGSIZE, V2P(sh_table.shp_array[i].shmem_addr), PTE_W|PTE_U))<0)
				panic("Failed to map page.\n");
80107433:	83 ec 0c             	sub    $0xc,%esp
80107436:	68 5e 83 10 80       	push   $0x8010835e
8010743b:	e8 30 8f ff ff       	call   80100370 <panic>
    }
	}
	else
	{
		if (first_free_addr == -1)
			panic("Full shared pages.\n");
80107440:	83 ec 0c             	sub    $0xc,%esp
80107443:	68 9a 83 10 80       	push   $0x8010839a
80107448:	e8 23 8f ff ff       	call   80100370 <panic>
		if ((sh_table.shp_array[first_free_addr].shmem_addr = kalloc()) == 0)
			panic("Failed to allocate.\n");
8010744d:	83 ec 0c             	sub    $0xc,%esp
80107450:	68 ae 83 10 80       	push   $0x801083ae
80107455:	e8 16 8f ff ff       	call   80100370 <panic>
      release(&(sh_table.lock));
			return temp;
		}
		else
    {
      release(&(sh_table.lock));
8010745a:	83 ec 0c             	sub    $0xc,%esp
8010745d:	68 c0 2d 12 80       	push   $0x80122dc0
80107462:	e8 09 d0 ff ff       	call   80104470 <release>
			panic("Max processes.\n");
80107467:	c7 04 24 8a 83 10 80 	movl   $0x8010838a,(%esp)
8010746e:	e8 fd 8e ff ff       	call   80100370 <panic>
80107473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107480 <shmrem>:



int
shmrem(sh_key_t *key)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 28             	sub    $0x28,%esp
80107489:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  acquire(&(sh_table.lock));
8010748c:	68 c0 2d 12 80       	push   $0x80122dc0
80107491:	e8 ba ce ff ff       	call   80104350 <acquire>
  
  if (memcmp(key, "-1",sizeof(sh_key_t)*16) == 0 )
80107496:	83 c4 0c             	add    $0xc,%esp
80107499:	6a 10                	push   $0x10
8010749b:	68 3d 7f 10 80       	push   $0x80107f3d
801074a0:	57                   	push   %edi
801074a1:	e8 6a d0 ff ff       	call   80104510 <memcmp>
801074a6:	83 c4 10             	add    $0x10,%esp
801074a9:	85 c0                	test   %eax,%eax
801074ab:	0f 85 d2 01 00 00    	jne    80107683 <shmrem+0x203>
801074b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801074b8:	eb 16                	jmp    801074d0 <shmrem+0x50>
801074ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    for (i=0;i<SHMEM_PAGES;i++)
801074c0:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
801074c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074c7:	83 f8 20             	cmp    $0x20,%eax
801074ca:	0f 84 12 03 00 00    	je     801077e2 <shmrem+0x362>
    {
      if (myproc()->bitmap[i] == 1)
801074d0:	e8 2b c3 ff ff       	call   80103800 <myproc>
801074d5:	8b 7d e0             	mov    -0x20(%ebp),%edi
801074d8:	80 bc 38 80 03 00 00 	cmpb   $0x1,0x380(%eax,%edi,1)
801074df:	01 
801074e0:	75 de                	jne    801074c0 <shmrem+0x40>
      {
        cprintf("phy:%x vm:%x\n",(unsigned int) myproc()->phy_shared_page[i],(unsigned int) myproc()->vm_shared_page[i]);
801074e2:	e8 19 c3 ff ff       	call   80103800 <myproc>
801074e7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801074ea:	8d 7e 40             	lea    0x40(%esi),%edi
801074ed:	8b 1c b8             	mov    (%eax,%edi,4),%ebx
801074f0:	89 7d dc             	mov    %edi,-0x24(%ebp)
801074f3:	8d 7e 20             	lea    0x20(%esi),%edi
801074f6:	e8 05 c3 ff ff       	call   80103800 <myproc>
801074fb:	83 ec 04             	sub    $0x4,%esp
801074fe:	89 7d e4             	mov    %edi,-0x1c(%ebp)
        int y;
        for (y= 0;y<SHMEM_PAGES;y++)
80107501:	31 f6                	xor    %esi,%esi
  {
    for (i=0;i<SHMEM_PAGES;i++)
    {
      if (myproc()->bitmap[i] == 1)
      {
        cprintf("phy:%x vm:%x\n",(unsigned int) myproc()->phy_shared_page[i],(unsigned int) myproc()->vm_shared_page[i]);
80107503:	53                   	push   %ebx
80107504:	ff 34 b8             	pushl  (%eax,%edi,4)
80107507:	bb f4 2d 12 80       	mov    $0x80122df4,%ebx
8010750c:	68 e9 83 10 80       	push   $0x801083e9
80107511:	bf f4 2e 12 80       	mov    $0x80122ef4,%edi
80107516:	e8 45 91 ff ff       	call   80100660 <cprintf>
8010751b:	83 c4 10             	add    $0x10,%esp
8010751e:	eb 0e                	jmp    8010752e <shmrem+0xae>
        int y;
        for (y= 0;y<SHMEM_PAGES;y++)
80107520:	83 c6 01             	add    $0x1,%esi
80107523:	83 c3 08             	add    $0x8,%ebx
80107526:	83 c7 10             	add    $0x10,%edi
80107529:	83 fe 20             	cmp    $0x20,%esi
8010752c:	74 92                	je     801074c0 <shmrem+0x40>
        {
          if (myproc()->phy_shared_page[i] == sh_table.shp_array[y].shmem_addr)
8010752e:	e8 cd c2 ff ff       	call   80103800 <myproc>
80107533:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107536:	8b 04 88             	mov    (%eax,%ecx,4),%eax
80107539:	3b 03                	cmp    (%ebx),%eax
8010753b:	75 e3                	jne    80107520 <shmrem+0xa0>
          {
            if (sh_table.shp_array[y].shmem_counter == 1)
8010753d:	8b 53 04             	mov    0x4(%ebx),%edx
80107540:	83 fa 01             	cmp    $0x1,%edx
80107543:	0f 84 97 00 00 00    	je     801075e0 <shmrem+0x160>
              // memset(temp, 0,PGSIZE);
              *temp = KERNBASE;
              cprintf("IN HERE\n");
              cprintf("PHY:%x VM:%x\n",(unsigned int) myproc()->phy_shared_page[i],(unsigned int) myproc()->vm_shared_page[i]);
            }
            else if (sh_table.shp_array[y].shmem_counter > 1)
80107549:	7e 6d                	jle    801075b8 <shmrem+0x138>
            {
              sh_table.shp_array[y].shmem_counter--;
              cprintf("edw %d\n",sh_table.shp_array[y].shmem_counter);
8010754b:	83 ec 08             	sub    $0x8,%esp
              cprintf("IN HERE\n");
              cprintf("PHY:%x VM:%x\n",(unsigned int) myproc()->phy_shared_page[i],(unsigned int) myproc()->vm_shared_page[i]);
            }
            else if (sh_table.shp_array[y].shmem_counter > 1)
            {
              sh_table.shp_array[y].shmem_counter--;
8010754e:	83 ea 01             	sub    $0x1,%edx
80107551:	89 53 04             	mov    %edx,0x4(%ebx)
              cprintf("edw %d\n",sh_table.shp_array[y].shmem_counter);
80107554:	52                   	push   %edx
80107555:	68 29 84 10 80       	push   $0x80108429
8010755a:	e8 01 91 ff ff       	call   80100660 <cprintf>
              cprintf("%x\n",(unsigned int)myproc()->vm_shared_page[i]);
8010755f:	e8 9c c2 ff ff       	call   80103800 <myproc>
80107564:	5a                   	pop    %edx
80107565:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107568:	59                   	pop    %ecx
80107569:	ff 34 90             	pushl  (%eax,%edx,4)
8010756c:	68 ca 83 10 80       	push   $0x801083ca
80107571:	e8 ea 90 ff ff       	call   80100660 <cprintf>
              myproc()->phy_shared_page[i] = 0;
80107576:	e8 85 c2 ff ff       	call   80103800 <myproc>
8010757b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010757e:	c7 04 88 00 00 00 00 	movl   $0x0,(%eax,%ecx,4)
              pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[i] , 0);
80107585:	e8 76 c2 ff ff       	call   80103800 <myproc>
8010758a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010758d:	8b 14 90             	mov    (%eax,%edx,4),%edx
80107590:	89 55 d8             	mov    %edx,-0x28(%ebp)
80107593:	e8 68 c2 ff ff       	call   80103800 <myproc>
80107598:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010759b:	8b 40 04             	mov    0x4(%eax),%eax
8010759e:	31 c9                	xor    %ecx,%ecx
801075a0:	e8 cb f0 ff ff       	call   80106670 <walkpgdir>
801075a5:	83 c4 10             	add    $0x10,%esp
              //memset(temp, 0,PGSIZE);               //right
              *temp = KERNBASE;
801075a8:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
801075ae:	e9 6d ff ff ff       	jmp    80107520 <shmrem+0xa0>
801075b3:	90                   	nop
801075b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            }
            else if (sh_table.shp_array[y].shmem_counter < 0)
801075b8:	85 d2                	test   %edx,%edx
801075ba:	0f 84 60 ff ff ff    	je     80107520 <shmrem+0xa0>
            {
              release(&(sh_table.lock));
801075c0:	83 ec 0c             	sub    $0xc,%esp
801075c3:	68 c0 2d 12 80       	push   $0x80122dc0
801075c8:	e8 a3 ce ff ff       	call   80104470 <release>
              panic("ERROR negative counter %d\n");
801075cd:	c7 04 24 31 84 10 80 	movl   $0x80108431,(%esp)
801075d4:	e8 97 8d ff ff       	call   80100370 <panic>
801075d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        {
          if (myproc()->phy_shared_page[i] == sh_table.shp_array[y].shmem_addr)
          {
            if (sh_table.shp_array[y].shmem_counter == 1)
            {
              cprintf("counter:%d addr %x pos %d\n",sh_table.shp_array[y].shmem_counter,sh_table.shp_array[y].shmem_addr,y);
801075e0:	56                   	push   %esi
801075e1:	50                   	push   %eax
801075e2:	6a 01                	push   $0x1
801075e4:	68 f7 83 10 80       	push   $0x801083f7
801075e9:	e8 72 90 ff ff       	call   80100660 <cprintf>
              kfree(sh_table.shp_array[y].shmem_addr);
801075ee:	58                   	pop    %eax
801075ef:	ff 33                	pushl  (%ebx)
801075f1:	e8 ea ac ff ff       	call   801022e0 <kfree>
              sh_table.shp_array[y].shmem_counter = 0;
              sh_table.shp_array[y].shmem_addr = 0;
              memset(sh_table.shp_key[y].shmem_key,0,sizeof(sh_key_t)*16);
801075f6:	83 c4 0c             	add    $0xc,%esp
          {
            if (sh_table.shp_array[y].shmem_counter == 1)
            {
              cprintf("counter:%d addr %x pos %d\n",sh_table.shp_array[y].shmem_counter,sh_table.shp_array[y].shmem_addr,y);
              kfree(sh_table.shp_array[y].shmem_addr);
              sh_table.shp_array[y].shmem_counter = 0;
801075f9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
              sh_table.shp_array[y].shmem_addr = 0;
80107600:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
              memset(sh_table.shp_key[y].shmem_key,0,sizeof(sh_key_t)*16);
80107606:	6a 10                	push   $0x10
80107608:	6a 00                	push   $0x0
8010760a:	57                   	push   %edi
8010760b:	e8 b0 ce ff ff       	call   801044c0 <memset>
              myproc()->phy_shared_page[i] = 0;
80107610:	e8 eb c1 ff ff       	call   80103800 <myproc>
80107615:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107618:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
              pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[i] , 0);
8010761f:	e8 dc c1 ff ff       	call   80103800 <myproc>
80107624:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80107627:	8b 14 88             	mov    (%eax,%ecx,4),%edx
8010762a:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010762d:	e8 ce c1 ff ff       	call   80103800 <myproc>
80107632:	8b 55 d8             	mov    -0x28(%ebp),%edx
80107635:	8b 40 04             	mov    0x4(%eax),%eax
80107638:	31 c9                	xor    %ecx,%ecx
8010763a:	e8 31 f0 ff ff       	call   80106670 <walkpgdir>
              // memset(temp, 0,PGSIZE);
              *temp = KERNBASE;
8010763f:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
              cprintf("IN HERE\n");
80107645:	c7 04 24 12 84 10 80 	movl   $0x80108412,(%esp)
8010764c:	e8 0f 90 ff ff       	call   80100660 <cprintf>
              cprintf("PHY:%x VM:%x\n",(unsigned int) myproc()->phy_shared_page[i],(unsigned int) myproc()->vm_shared_page[i]);
80107651:	e8 aa c1 ff ff       	call   80103800 <myproc>
80107656:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80107659:	8b 14 88             	mov    (%eax,%ecx,4),%edx
8010765c:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010765f:	e8 9c c1 ff ff       	call   80103800 <myproc>
80107664:	8b 55 d8             	mov    -0x28(%ebp),%edx
80107667:	83 c4 0c             	add    $0xc,%esp
8010766a:	52                   	push   %edx
8010766b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010766e:	ff 34 90             	pushl  (%eax,%edx,4)
80107671:	68 1b 84 10 80       	push   $0x8010841b
80107676:	e8 e5 8f ff ff       	call   80100660 <cprintf>
8010767b:	83 c4 10             	add    $0x10,%esp
8010767e:	e9 9d fe ff ff       	jmp    80107520 <shmrem+0xa0>
80107683:	be f4 2e 12 80       	mov    $0x80122ef4,%esi
shmrem(sh_key_t *key)
{
  int i;
  acquire(&(sh_table.lock));
  
  if (memcmp(key, "-1",sizeof(sh_key_t)*16) == 0 )
80107688:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)



  for (i=0;i<SHMEM_PAGES;i++)
  {
    if (memcmp(sh_table.shp_key[i].shmem_key, key, sizeof(sh_key_t)*16) == 0 )
8010768f:	83 ec 04             	sub    $0x4,%esp
80107692:	6a 10                	push   $0x10
80107694:	57                   	push   %edi
80107695:	56                   	push   %esi
80107696:	e8 75 ce ff ff       	call   80104510 <memcmp>
8010769b:	83 c4 10             	add    $0x10,%esp
8010769e:	85 c0                	test   %eax,%eax
801076a0:	0f 85 12 01 00 00    	jne    801077b8 <shmrem+0x338>
801076a6:	31 db                	xor    %ebx,%ebx
801076a8:	eb 12                	jmp    801076bc <shmrem+0x23c>
801076aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    {
      int y;
      for (y=0;y<SHMEM_PAGES;y++)
801076b0:	83 c3 01             	add    $0x1,%ebx
801076b3:	83 fb 20             	cmp    $0x20,%ebx
801076b6:	0f 84 fc 00 00 00    	je     801077b8 <shmrem+0x338>
      {
        if (memcmp(myproc()->p_key[y].keys, key, sizeof(sh_key_t)*16) == 0 )
801076bc:	e8 3f c1 ff ff       	call   80103800 <myproc>
801076c1:	8d 53 18             	lea    0x18(%ebx),%edx
801076c4:	83 ec 04             	sub    $0x4,%esp
801076c7:	6a 10                	push   $0x10
801076c9:	57                   	push   %edi
801076ca:	c1 e2 04             	shl    $0x4,%edx
801076cd:	01 d0                	add    %edx,%eax
801076cf:	50                   	push   %eax
801076d0:	e8 3b ce ff ff       	call   80104510 <memcmp>
801076d5:	83 c4 10             	add    $0x10,%esp
801076d8:	85 c0                	test   %eax,%eax
801076da:	75 d4                	jne    801076b0 <shmrem+0x230>
        {
          cprintf("MPIKA\n");
801076dc:	83 ec 0c             	sub    $0xc,%esp
801076df:	89 75 e0             	mov    %esi,-0x20(%ebp)
801076e2:	89 c6                	mov    %eax,%esi
801076e4:	68 4c 84 10 80       	push   $0x8010844c
801076e9:	e8 72 8f ff ff       	call   80100660 <cprintf>
          if (sh_table.shp_array[i].shmem_counter == 1)
801076ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076f1:	83 c4 10             	add    $0x10,%esp
801076f4:	8d 78 06             	lea    0x6(%eax),%edi
801076f7:	8b 04 fd c8 2d 12 80 	mov    -0x7fedd238(,%edi,8),%eax
801076fe:	83 f8 01             	cmp    $0x1,%eax
80107701:	0f 84 fa 00 00 00    	je     80107801 <shmrem+0x381>
            return 0;
          }
          else
          {
            sh_table.shp_array[i].shmem_counter--;
            myproc()->phy_shared_page[y] = 0;
80107707:	8d 73 20             	lea    0x20(%ebx),%esi
            release(&(sh_table.lock));
            return 0;
          }
          else
          {
            sh_table.shp_array[i].shmem_counter--;
8010770a:	83 e8 01             	sub    $0x1,%eax
8010770d:	89 04 fd c8 2d 12 80 	mov    %eax,-0x7fedd238(,%edi,8)
            myproc()->phy_shared_page[y] = 0;
80107714:	e8 e7 c0 ff ff       	call   80103800 <myproc>
80107719:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
            cprintf("AS %x %x\n",(unsigned int) sh_table.shp_array[i].shmem_addr,myproc()->phy_shared_page[y]);
80107720:	e8 db c0 ff ff       	call   80103800 <myproc>
80107725:	83 ec 04             	sub    $0x4,%esp
80107728:	ff 34 b0             	pushl  (%eax,%esi,4)
8010772b:	ff 34 fd c4 2d 12 80 	pushl  -0x7fedd23c(,%edi,8)
80107732:	68 65 84 10 80       	push   $0x80108465
            myproc()->phy_shared_page[i] = 0;
            pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[i],0);
            *temp = KERNBASE;
            
            release(&(sh_table.lock));
            return 1;
80107737:	be 01 00 00 00       	mov    $0x1,%esi
          }
          else
          {
            sh_table.shp_array[i].shmem_counter--;
            myproc()->phy_shared_page[y] = 0;
            cprintf("AS %x %x\n",(unsigned int) sh_table.shp_array[i].shmem_addr,myproc()->phy_shared_page[y]);
8010773c:	e8 1f 8f ff ff       	call   80100660 <cprintf>
            myproc()->vm_shared_page[y] = 0;
80107741:	e8 ba c0 ff ff       	call   80103800 <myproc>
80107746:	c7 84 98 00 01 00 00 	movl   $0x0,0x100(%eax,%ebx,4)
8010774d:	00 00 00 00 
            cprintf("EDW counter %d\n",sh_table.shp_array[i].shmem_counter);
80107751:	58                   	pop    %eax
80107752:	5a                   	pop    %edx
80107753:	ff 34 fd c8 2d 12 80 	pushl  -0x7fedd238(,%edi,8)
8010775a:	68 6f 84 10 80       	push   $0x8010846f
8010775f:	e8 fc 8e ff ff       	call   80100660 <cprintf>
            myproc()->phy_shared_page[i] = 0;
80107764:	e8 97 c0 ff ff       	call   80103800 <myproc>
80107769:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010776c:	c7 84 b8 80 00 00 00 	movl   $0x0,0x80(%eax,%edi,4)
80107773:	00 00 00 00 
            pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[i],0);
80107777:	e8 84 c0 ff ff       	call   80103800 <myproc>
8010777c:	8b 9c b8 00 01 00 00 	mov    0x100(%eax,%edi,4),%ebx
80107783:	e8 78 c0 ff ff       	call   80103800 <myproc>
80107788:	8b 40 04             	mov    0x4(%eax),%eax
8010778b:	31 c9                	xor    %ecx,%ecx
8010778d:	89 da                	mov    %ebx,%edx
8010778f:	e8 dc ee ff ff       	call   80106670 <walkpgdir>
            *temp = KERNBASE;
80107794:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
            
            release(&(sh_table.lock));
8010779a:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
801077a1:	e8 ca cc ff ff       	call   80104470 <release>
            return 1;
801077a6:	83 c4 10             	add    $0x10,%esp
      }
    }
  }
  release(&(sh_table.lock));
  return -1;
}
801077a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ac:	89 f0                	mov    %esi,%eax
801077ae:	5b                   	pop    %ebx
801077af:	5e                   	pop    %esi
801077b0:	5f                   	pop    %edi
801077b1:	5d                   	pop    %ebp
801077b2:	c3                   	ret    
801077b3:	90                   	nop
801077b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 1;
  }



  for (i=0;i<SHMEM_PAGES;i++)
801077b8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801077bc:	83 c6 10             	add    $0x10,%esi
801077bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077c2:	83 f8 20             	cmp    $0x20,%eax
801077c5:	0f 85 c4 fe ff ff    	jne    8010768f <shmrem+0x20f>
          }
        }
      }
    }
  }
  release(&(sh_table.lock));
801077cb:	83 ec 0c             	sub    $0xc,%esp
  return -1;
801077ce:	be ff ff ff ff       	mov    $0xffffffff,%esi
          }
        }
      }
    }
  }
  release(&(sh_table.lock));
801077d3:	68 c0 2d 12 80       	push   $0x80122dc0
801077d8:	e8 93 cc ff ff       	call   80104470 <release>
  return -1;
801077dd:	83 c4 10             	add    $0x10,%esp
801077e0:	eb 15                	jmp    801077f7 <shmrem+0x377>
            }
          }
        }
      }
    }
    release(&(sh_table.lock));
801077e2:	83 ec 0c             	sub    $0xc,%esp
    return 1;
801077e5:	be 01 00 00 00       	mov    $0x1,%esi
            }
          }
        }
      }
    }
    release(&(sh_table.lock));
801077ea:	68 c0 2d 12 80       	push   $0x80122dc0
801077ef:	e8 7c cc ff ff       	call   80104470 <release>
    return 1;
801077f4:	83 c4 10             	add    $0x10,%esp
      }
    }
  }
  release(&(sh_table.lock));
  return -1;
}
801077f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077fa:	89 f0                	mov    %esi,%eax
801077fc:	5b                   	pop    %ebx
801077fd:	5e                   	pop    %esi
801077fe:	5f                   	pop    %edi
801077ff:	5d                   	pop    %ebp
80107800:	c3                   	ret    
        if (memcmp(myproc()->p_key[y].keys, key, sizeof(sh_key_t)*16) == 0 )
        {
          cprintf("MPIKA\n");
          if (sh_table.shp_array[i].shmem_counter == 1)
          {
            kfree(sh_table.shp_array[i].shmem_addr);
80107801:	83 ec 0c             	sub    $0xc,%esp
80107804:	ff 34 fd c4 2d 12 80 	pushl  -0x7fedd23c(,%edi,8)
8010780b:	e8 d0 aa ff ff       	call   801022e0 <kfree>
            sh_table.shp_array[i].shmem_counter = 0;
            sh_table.shp_array[i].shmem_addr = 0;
            memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
80107810:	83 c4 0c             	add    $0xc,%esp
        {
          cprintf("MPIKA\n");
          if (sh_table.shp_array[i].shmem_counter == 1)
          {
            kfree(sh_table.shp_array[i].shmem_addr);
            sh_table.shp_array[i].shmem_counter = 0;
80107813:	c7 04 fd c8 2d 12 80 	movl   $0x0,-0x7fedd238(,%edi,8)
8010781a:	00 00 00 00 
            sh_table.shp_array[i].shmem_addr = 0;
8010781e:	c7 04 fd c4 2d 12 80 	movl   $0x0,-0x7fedd23c(,%edi,8)
80107825:	00 00 00 00 
            memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
80107829:	6a 10                	push   $0x10
8010782b:	6a 00                	push   $0x0
8010782d:	ff 75 e0             	pushl  -0x20(%ebp)
80107830:	e8 8b cc ff ff       	call   801044c0 <memset>
            //myproc()->phy_shared_page[i] = 0;
            pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[i],0);
80107835:	e8 c6 bf ff ff       	call   80103800 <myproc>
8010783a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010783d:	8b 9c 90 00 01 00 00 	mov    0x100(%eax,%edx,4),%ebx
80107844:	e8 b7 bf ff ff       	call   80103800 <myproc>
80107849:	8b 40 04             	mov    0x4(%eax),%eax
8010784c:	31 c9                	xor    %ecx,%ecx
8010784e:	89 da                	mov    %ebx,%edx
80107850:	e8 1b ee ff ff       	call   80106670 <walkpgdir>
            *temp = KERNBASE;
80107855:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)

            cprintf("%x \n",(unsigned int) sh_table.shp_array[i].shmem_addr);
8010785b:	59                   	pop    %ecx
8010785c:	5b                   	pop    %ebx
8010785d:	ff 34 fd c4 2d 12 80 	pushl  -0x7fedd23c(,%edi,8)
80107864:	68 53 84 10 80       	push   $0x80108453
80107869:	e8 f2 8d ff ff       	call   80100660 <cprintf>

            cprintf("KFREE EKANA\n");
8010786e:	c7 04 24 58 84 10 80 	movl   $0x80108458,(%esp)
80107875:	e8 e6 8d ff ff       	call   80100660 <cprintf>
            
            release(&(sh_table.lock));
8010787a:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
80107881:	e8 ea cb ff ff       	call   80104470 <release>
            return 0;
80107886:	83 c4 10             	add    $0x10,%esp
      }
    }
  }
  release(&(sh_table.lock));
  return -1;
}
80107889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010788c:	89 f0                	mov    %esi,%eax
8010788e:	5b                   	pop    %ebx
8010788f:	5e                   	pop    %esi
80107890:	5f                   	pop    %edi
80107891:	5d                   	pop    %ebp
80107892:	c3                   	ret    
80107893:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078a0 <find_pos>:


int 
find_pos()
{
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	53                   	push   %ebx
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
801078a4:	31 db                	xor    %ebx,%ebx
}


int 
find_pos()
{
801078a6:	83 ec 04             	sub    $0x4,%esp
801078a9:	eb 0d                	jmp    801078b8 <find_pos+0x18>
801078ab:	90                   	nop
801078ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
801078b0:	83 c3 01             	add    $0x1,%ebx
801078b3:	83 fb 20             	cmp    $0x20,%ebx
801078b6:	74 18                	je     801078d0 <find_pos+0x30>
  {
    if (myproc()->phy_shared_page[i] == 0)
801078b8:	e8 43 bf ff ff       	call   80103800 <myproc>
801078bd:	8b 84 98 80 00 00 00 	mov    0x80(%eax,%ebx,4),%eax
801078c4:	85 c0                	test   %eax,%eax
801078c6:	75 e8                	jne    801078b0 <find_pos+0x10>
      return i;
  }
  return -1;
}
801078c8:	83 c4 04             	add    $0x4,%esp
801078cb:	89 d8                	mov    %ebx,%eax
801078cd:	5b                   	pop    %ebx
801078ce:	5d                   	pop    %ebp
801078cf:	c3                   	ret    
801078d0:	83 c4 04             	add    $0x4,%esp
  for (i=0;i<SHMEM_PAGES;i++)
  {
    if (myproc()->phy_shared_page[i] == 0)
      return i;
  }
  return -1;
801078d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078d8:	5b                   	pop    %ebx
801078d9:	5d                   	pop    %ebp
801078da:	c3                   	ret    
801078db:	90                   	nop
801078dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078e0 <manage_fork>:

void
manage_fork(struct proc *p,int index)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
801078e6:	bb f8 2d 12 80       	mov    $0x80122df8,%ebx
801078eb:	83 ec 0c             	sub    $0xc,%esp
801078ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801078f1:	8d 70 20             	lea    0x20(%eax),%esi
801078f4:	eb 15                	jmp    8010790b <manage_fork+0x2b>
801078f6:	8d 76 00             	lea    0x0(%esi),%esi
801078f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107900:	83 c3 08             	add    $0x8,%ebx
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
80107903:	81 fb f8 2e 12 80    	cmp    $0x80122ef8,%ebx
80107909:	74 31                	je     8010793c <manage_fork+0x5c>
  {
    if (sh_table.shp_array[i].shmem_addr == myproc()->phy_shared_page[index])
8010790b:	8b 7b fc             	mov    -0x4(%ebx),%edi
8010790e:	e8 ed be ff ff       	call   80103800 <myproc>
80107913:	3b 3c b0             	cmp    (%eax,%esi,4),%edi
80107916:	75 e8                	jne    80107900 <manage_fork+0x20>
    {
      sh_table.shp_array[i].shmem_counter++;
80107918:	8b 03                	mov    (%ebx),%eax
      //pte_t *temp = walkpgdir(myproc()->pgdir, myproc()->vm_shared_page[index], 0);
      cprintf("MANAGE FORK %d\n",sh_table.shp_array[i].shmem_counter);
8010791a:	83 ec 08             	sub    $0x8,%esp
8010791d:	83 c3 08             	add    $0x8,%ebx
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
  {
    if (sh_table.shp_array[i].shmem_addr == myproc()->phy_shared_page[index])
    {
      sh_table.shp_array[i].shmem_counter++;
80107920:	83 c0 01             	add    $0x1,%eax
      //pte_t *temp = walkpgdir(myproc()->pgdir, myproc()->vm_shared_page[index], 0);
      cprintf("MANAGE FORK %d\n",sh_table.shp_array[i].shmem_counter);
80107923:	50                   	push   %eax
80107924:	68 7f 84 10 80       	push   $0x8010847f
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
  {
    if (sh_table.shp_array[i].shmem_addr == myproc()->phy_shared_page[index])
    {
      sh_table.shp_array[i].shmem_counter++;
80107929:	89 43 f8             	mov    %eax,-0x8(%ebx)
      //pte_t *temp = walkpgdir(myproc()->pgdir, myproc()->vm_shared_page[index], 0);
      cprintf("MANAGE FORK %d\n",sh_table.shp_array[i].shmem_counter);
8010792c:	e8 2f 8d ff ff       	call   80100660 <cprintf>
80107931:	83 c4 10             	add    $0x10,%esp

void
manage_fork(struct proc *p,int index)
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
80107934:	81 fb f8 2e 12 80    	cmp    $0x80122ef8,%ebx
8010793a:	75 cf                	jne    8010790b <manage_fork+0x2b>
      sh_table.shp_array[i].shmem_counter++;
      //pte_t *temp = walkpgdir(myproc()->pgdir, myproc()->vm_shared_page[index], 0);
      cprintf("MANAGE FORK %d\n",sh_table.shp_array[i].shmem_counter);
    }
  }
}
8010793c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010793f:	5b                   	pop    %ebx
80107940:	5e                   	pop    %esi
80107941:	5f                   	pop    %edi
80107942:	5d                   	pop    %ebp
80107943:	c3                   	ret    
