
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
8010004c:	68 80 7a 10 80       	push   $0x80107a80
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 05 42 00 00       	call   80104260 <initlock>

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
80100092:	68 87 7a 10 80       	push   $0x80107a87
80100097:	50                   	push   %eax
80100098:	e8 b3 40 00 00       	call   80104150 <initsleeplock>
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
801000e4:	e8 77 42 00 00       	call   80104360 <acquire>

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
80100162:	e8 19 43 00 00       	call   80104480 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 40 00 00       	call   80104190 <acquiresleep>
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
80100193:	68 8e 7a 10 80       	push   $0x80107a8e
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
801001ae:	e8 7d 40 00 00       	call   80104230 <holdingsleep>
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
801001cc:	68 9f 7a 10 80       	push   $0x80107a9f
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
801001ef:	e8 3c 40 00 00       	call   80104230 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 3f 00 00       	call   801041f0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 50 41 00 00       	call   80104360 <acquire>
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
8010025c:	e9 1f 42 00 00       	jmp    80104480 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 7a 10 80       	push   $0x80107aa6
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
8010028c:	e8 cf 40 00 00       	call   80104360 <acquire>
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
801002bd:	e8 1e 3b 00 00       	call   80103de0 <sleep>

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
801002e6:	e8 95 41 00 00       	call   80104480 <release>
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
80100346:	e8 35 41 00 00       	call   80104480 <release>
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
80100392:	68 ad 7a 10 80       	push   $0x80107aad
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 0b 84 10 80 	movl   $0x8010840b,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 c3 3e 00 00       	call   80104280 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 c1 7a 10 80       	push   $0x80107ac1
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
8010041a:	e8 81 58 00 00       	call   80105ca0 <uartputc>
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
801004d3:	e8 c8 57 00 00       	call   80105ca0 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 bc 57 00 00       	call   80105ca0 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 b0 57 00 00       	call   80105ca0 <uartputc>
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
80100514:	e8 67 40 00 00       	call   80104580 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 a2 3f 00 00       	call   801044d0 <memset>
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
80100540:	68 c5 7a 10 80       	push   $0x80107ac5
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
801005b1:	0f b6 92 f0 7a 10 80 	movzbl -0x7fef8510(%edx),%edx
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
8010061b:	e8 40 3d 00 00       	call   80104360 <acquire>
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
80100647:	e8 34 3e 00 00       	call   80104480 <release>
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
8010070d:	e8 6e 3d 00 00       	call   80104480 <release>
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
80100788:	b8 d8 7a 10 80       	mov    $0x80107ad8,%eax
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
801007c8:	e8 93 3b 00 00       	call   80104360 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 df 7a 10 80       	push   $0x80107adf
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
80100803:	e8 58 3b 00 00       	call   80104360 <acquire>
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
80100868:	e8 13 3c 00 00       	call   80104480 <release>
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
801008f6:	e8 a5 36 00 00       	call   80103fa0 <wakeup>
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
80100977:	e9 14 37 00 00       	jmp    80104090 <procdump>
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
801009a6:	68 e8 7a 10 80       	push   $0x80107ae8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 ab 38 00 00       	call   80104260 <initlock>

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
80100a74:	e8 b7 63 00 00       	call   80106e30 <setupkvm>
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
80100b04:	e8 77 61 00 00       	call   80106c80 <allocuvm>
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
80100b3a:	e8 81 60 00 00       	call   80106bc0 <loaduvm>
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
80100b59:	e8 52 62 00 00       	call   80106db0 <freevm>
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
80100b95:	e8 e6 60 00 00       	call   80106c80 <allocuvm>
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
80100bac:	e8 ff 61 00 00       	call   80106db0 <freevm>
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
80100bc6:	68 01 7b 10 80       	push   $0x80107b01
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
80100bf1:	e8 da 62 00 00       	call   80106ed0 <clearpteu>
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
80100c2d:	e8 de 3a 00 00       	call   80104710 <strlen>
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
80100c40:	e8 cb 3a 00 00       	call   80104710 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 da 63 00 00       	call   80107030 <copyout>
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
80100cbb:	e8 70 63 00 00       	call   80107030 <copyout>
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
80100d00:	e8 cb 39 00 00       	call   801046d0 <safestrcpy>

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
80100d2c:	e8 ff 5c 00 00       	call   80106a30 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 77 60 00 00       	call   80106db0 <freevm>
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
80100d56:	68 0d 7b 10 80       	push   $0x80107b0d
80100d5b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d60:	e8 fb 34 00 00       	call   80104260 <initlock>
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
80100d81:	e8 da 35 00 00       	call   80104360 <acquire>
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
80100db1:	e8 ca 36 00 00       	call   80104480 <release>
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
80100dc8:	e8 b3 36 00 00       	call   80104480 <release>
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
80100def:	e8 6c 35 00 00       	call   80104360 <acquire>
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
80100e0c:	e8 6f 36 00 00       	call   80104480 <release>
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
80100e1b:	68 14 7b 10 80       	push   $0x80107b14
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
80100e41:	e8 1a 35 00 00       	call   80104360 <acquire>
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
80100e6c:	e9 0f 36 00 00       	jmp    80104480 <release>
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
80100e98:	e8 e3 35 00 00       	call   80104480 <release>

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
80100ef2:	68 1c 7b 10 80       	push   $0x80107b1c
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
80100fd2:	68 26 7b 10 80       	push   $0x80107b26
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
801010e4:	68 2f 7b 10 80       	push   $0x80107b2f
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 35 7b 10 80       	push   $0x80107b35
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
801011a2:	68 3f 7b 10 80       	push   $0x80107b3f
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
801011e5:	e8 e6 32 00 00       	call   801044d0 <memset>
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
8010122a:	e8 31 31 00 00       	call   80104360 <acquire>
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
80101272:	e8 09 32 00 00       	call   80104480 <release>
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
801012bf:	e8 bc 31 00 00       	call   80104480 <release>

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
801012d4:	68 55 7b 10 80       	push   $0x80107b55
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
8010139a:	68 65 7b 10 80       	push   $0x80107b65
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
801013d1:	e8 aa 31 00 00       	call   80104580 <memmove>
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
80101466:	68 78 7b 10 80       	push   $0x80107b78
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
8010147c:	68 8b 7b 10 80       	push   $0x80107b8b
80101481:	68 e0 19 11 80       	push   $0x801119e0
80101486:	e8 d5 2d 00 00       	call   80104260 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 92 7b 10 80       	push   $0x80107b92
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 ac 2c 00 00       	call   80104150 <initsleeplock>
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
801014e9:	68 f8 7b 10 80       	push   $0x80107bf8
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
8010157e:	e8 4d 2f 00 00       	call   801044d0 <memset>
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
801015b3:	68 98 7b 10 80       	push   $0x80107b98
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
80101621:	e8 5a 2f 00 00       	call   80104580 <memmove>
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
8010164f:	e8 0c 2d 00 00       	call   80104360 <acquire>
  ip->ref++;
80101654:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101658:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010165f:	e8 1c 2e 00 00       	call   80104480 <release>
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
80101692:	e8 f9 2a 00 00       	call   80104190 <acquiresleep>

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
80101708:	e8 73 2e 00 00       	call   80104580 <memmove>
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
8010172d:	68 b0 7b 10 80       	push   $0x80107bb0
80101732:	e8 39 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 aa 7b 10 80       	push   $0x80107baa
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
80101763:	e8 c8 2a 00 00       	call   80104230 <holdingsleep>
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
8010177f:	e9 6c 2a 00 00       	jmp    801041f0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 bf 7b 10 80       	push   $0x80107bbf
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
801017b0:	e8 db 29 00 00       	call   80104190 <acquiresleep>
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
801017ca:	e8 21 2a 00 00       	call   801041f0 <releasesleep>

  acquire(&icache.lock);
801017cf:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801017d6:	e8 85 2b 00 00       	call   80104360 <acquire>
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
801017f0:	e9 8b 2c 00 00       	jmp    80104480 <release>
801017f5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 e0 19 11 80       	push   $0x801119e0
80101800:	e8 5b 2b 00 00       	call   80104360 <acquire>
    int r = ip->ref;
80101805:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101808:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010180f:	e8 6c 2c 00 00       	call   80104480 <release>
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
801019f8:	e8 83 2b 00 00       	call   80104580 <memmove>
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
80101af4:	e8 87 2a 00 00       	call   80104580 <memmove>
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
80101b8e:	e8 6d 2a 00 00       	call   80104600 <strncmp>
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
80101bf5:	e8 06 2a 00 00       	call   80104600 <strncmp>
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
80101c2d:	68 d9 7b 10 80       	push   $0x80107bd9
80101c32:	e8 39 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	68 c7 7b 10 80       	push   $0x80107bc7
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
80101c79:	e8 e2 26 00 00       	call   80104360 <acquire>
  ip->ref++;
80101c7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c82:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101c89:	e8 f2 27 00 00       	call   80104480 <release>
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
80101ce5:	e8 96 28 00 00       	call   80104580 <memmove>
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
80101d74:	e8 07 28 00 00       	call   80104580 <memmove>
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
80101e5d:	e8 0e 28 00 00       	call   80104670 <strncpy>
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
80101e9b:	68 e8 7b 10 80       	push   $0x80107be8
80101ea0:	e8 cb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 f2 81 10 80       	push   $0x801081f2
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
80101fb0:	68 54 7c 10 80       	push   $0x80107c54
80101fb5:	e8 b6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	68 4b 7c 10 80       	push   $0x80107c4b
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
80101fd6:	68 66 7c 10 80       	push   $0x80107c66
80101fdb:	68 80 b5 10 80       	push   $0x8010b580
80101fe0:	e8 7b 22 00 00       	call   80104260 <initlock>
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
8010205e:	e8 fd 22 00 00       	call   80104360 <acquire>

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
8010208e:	e8 0d 1f 00 00       	call   80103fa0 <wakeup>

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
801020ac:	e8 cf 23 00 00       	call   80104480 <release>
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
801020fe:	e8 2d 21 00 00       	call   80104230 <holdingsleep>
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
80102138:	e8 23 22 00 00       	call   80104360 <acquire>

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
80102189:	e8 52 1c 00 00       	call   80103de0 <sleep>
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
801021a6:	e9 d5 22 00 00       	jmp    80104480 <release>

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
801021be:	68 6a 7c 10 80       	push   $0x80107c6a
801021c3:	e8 a8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 95 7c 10 80       	push   $0x80107c95
801021d0:	e8 9b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 80 7c 10 80       	push   $0x80107c80
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
8010223a:	68 b4 7c 10 80       	push   $0x80107cb4
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
80102312:	e8 b9 21 00 00       	call   801044d0 <memset>

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
8010234b:	e9 30 21 00 00       	jmp    80104480 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	68 40 36 11 80       	push   $0x80113640
80102358:	e8 03 20 00 00       	call   80104360 <acquire>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	eb c2                	jmp    80102324 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102362:	83 ec 0c             	sub    $0xc,%esp
80102365:	68 e6 7c 10 80       	push   $0x80107ce6
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
801023cb:	68 ec 7c 10 80       	push   $0x80107cec
801023d0:	68 40 36 11 80       	push   $0x80113640
801023d5:	e8 86 1e 00 00       	call   80104260 <initlock>

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
801024be:	e8 bd 1f 00 00       	call   80104480 <release>
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
801024d8:	e8 83 1e 00 00       	call   80104360 <acquire>
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
80102536:	0f b6 82 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%eax
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
8010255e:	0f b6 82 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%eax
80102565:	09 c1                	or     %eax,%ecx
80102567:	0f b6 82 20 7d 10 80 	movzbl -0x7fef82e0(%edx),%eax
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
8010257e:	8b 04 85 00 7d 10 80 	mov    -0x7fef8300(,%eax,4),%eax
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
801028e4:	e8 37 1c 00 00       	call   80104520 <memcmp>
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
80102a14:	e8 67 1b 00 00       	call   80104580 <memmove>
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
80102aba:	68 20 7f 10 80       	push   $0x80107f20
80102abf:	68 80 36 11 80       	push   $0x80113680
80102ac4:	e8 97 17 00 00       	call   80104260 <initlock>
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
80102b5b:	e8 00 18 00 00       	call   80104360 <acquire>
80102b60:	83 c4 10             	add    $0x10,%esp
80102b63:	eb 18                	jmp    80102b7d <begin_op+0x2d>
80102b65:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b68:	83 ec 08             	sub    $0x8,%esp
80102b6b:	68 80 36 11 80       	push   $0x80113680
80102b70:	68 80 36 11 80       	push   $0x80113680
80102b75:	e8 66 12 00 00       	call   80103de0 <sleep>
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
80102bac:	e8 cf 18 00 00       	call   80104480 <release>
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
80102bce:	e8 8d 17 00 00       	call   80104360 <acquire>
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
80102c0d:	e8 6e 18 00 00       	call   80104480 <release>
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
80102c6c:	e8 0f 19 00 00       	call   80104580 <memmove>
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
80102cb5:	e8 a6 16 00 00       	call   80104360 <acquire>
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
80102ccb:	e8 d0 12 00 00       	call   80103fa0 <wakeup>
    release(&log.lock);
80102cd0:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102cd7:	e8 a4 17 00 00       	call   80104480 <release>
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
80102cf8:	e8 a3 12 00 00       	call   80103fa0 <wakeup>
  }
  release(&log.lock);
80102cfd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d04:	e8 77 17 00 00       	call   80104480 <release>
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
80102d17:	68 24 7f 10 80       	push   $0x80107f24
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
80102d6e:	e8 ed 15 00 00       	call   80104360 <acquire>
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
80102dbe:	e9 bd 16 00 00       	jmp    80104480 <release>
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
80102de3:	68 33 7f 10 80       	push   $0x80107f33
80102de8:	e8 83 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ded:	83 ec 0c             	sub    $0xc,%esp
80102df0:	68 49 7f 10 80       	push   $0x80107f49
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
80102e18:	68 64 7f 10 80       	push   $0x80107f64
80102e1d:	e8 3e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e22:	e8 c9 2a 00 00       	call   801058f0 <idtinit>
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
80102e3a:	e8 91 0c 00 00       	call   80103ad0 <scheduler>
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
80102e46:	e8 c5 3b 00 00       	call   80106a10 <switchkvm>
  seginit();
80102e4b:	e8 c0 3a 00 00       	call   80106910 <seginit>
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
80102e86:	e8 25 40 00 00       	call   80106eb0 <kvmalloc>
  mpinit();        // detect other processors
80102e8b:	e8 80 01 00 00       	call   80103010 <mpinit>
  lapicinit();     // interrupt controller
80102e90:	e8 5b f7 ff ff       	call   801025f0 <lapicinit>
  seginit();       // segment descriptors
80102e95:	e8 76 3a 00 00       	call   80106910 <seginit>
  picinit();       // disable pic
80102e9a:	e8 41 03 00 00       	call   801031e0 <picinit>
  ioapicinit();    // another interrupt controller
80102e9f:	e8 4c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ea4:	e8 f7 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102ea9:	e8 32 2d 00 00       	call   80105be0 <uartinit>
  pinit();         // process table
80102eae:	e8 8d 08 00 00       	call   80103740 <pinit>
  tvinit();        // trap vectors
80102eb3:	e8 98 29 00 00       	call   80105850 <tvinit>
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
80102ed9:	e8 a2 16 00 00       	call   80104580 <memmove>

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
80102f7a:	e8 51 41 00 00       	call   801070d0 <shmeminit>
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
80102fb8:	68 78 7f 10 80       	push   $0x80107f78
80102fbd:	56                   	push   %esi
80102fbe:	e8 5d 15 00 00       	call   80104520 <memcmp>
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
8010307c:	68 7d 7f 10 80       	push   $0x80107f7d
80103081:	56                   	push   %esi
80103082:	e8 99 14 00 00       	call   80104520 <memcmp>
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
80103110:	ff 24 95 bc 7f 10 80 	jmp    *-0x7fef8044(,%edx,4)
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
801031b7:	68 82 7f 10 80       	push   $0x80107f82
801031bc:	e8 af d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031c1:	83 ec 0c             	sub    $0xc,%esp
801031c4:	68 9c 7f 10 80       	push   $0x80107f9c
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
80103273:	68 d0 7f 10 80       	push   $0x80107fd0
80103278:	50                   	push   %eax
80103279:	e8 e2 0f 00 00       	call   80104260 <initlock>
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
8010330f:	e8 4c 10 00 00       	call   80104360 <acquire>
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
8010332f:	e8 6c 0c 00 00       	call   80103fa0 <wakeup>
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
80103354:	e9 27 11 00 00       	jmp    80104480 <release>
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
80103374:	e8 27 0c 00 00       	call   80103fa0 <wakeup>
80103379:	83 c4 10             	add    $0x10,%esp
8010337c:	eb b9                	jmp    80103337 <pipeclose+0x37>
8010337e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103380:	83 ec 0c             	sub    $0xc,%esp
80103383:	53                   	push   %ebx
80103384:	e8 f7 10 00 00       	call   80104480 <release>
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
801033ad:	e8 ae 0f 00 00       	call   80104360 <acquire>
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
80103400:	e8 9b 0b 00 00       	call   80103fa0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103405:	58                   	pop    %eax
80103406:	5a                   	pop    %edx
80103407:	53                   	push   %ebx
80103408:	56                   	push   %esi
80103409:	e8 d2 09 00 00       	call   80103de0 <sleep>
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
80103434:	e8 47 10 00 00       	call   80104480 <release>
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
80103483:	e8 18 0b 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
80103488:	89 1c 24             	mov    %ebx,(%esp)
8010348b:	e8 f0 0f 00 00       	call   80104480 <release>
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
801034b0:	e8 ab 0e 00 00       	call   80104360 <acquire>
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
801034e5:	e8 f6 08 00 00       	call   80103de0 <sleep>
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
80103519:	e8 62 0f 00 00       	call   80104480 <release>
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
8010357e:	e8 1d 0a 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
80103583:	89 1c 24             	mov    %ebx,(%esp)
80103586:	e8 f5 0e 00 00       	call   80104480 <release>
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
801035d3:	e8 88 0d 00 00       	call   80104360 <acquire>
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
80103619:	e8 62 0e 00 00       	call   80104480 <release>

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
8010364e:	c7 40 14 3f 58 10 80 	movl   $0x8010583f,0x14(%eax)

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
8010365d:	e8 6e 0e 00 00       	call   801044d0 <memset>
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
801036a4:	e8 27 0e 00 00       	call   801044d0 <memset>
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
801036d0:	e8 ab 0d 00 00       	call   80104480 <release>
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
801036fb:	e8 80 0d 00 00       	call   80104480 <release>

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
80103746:	68 d5 7f 10 80       	push   $0x80107fd5
8010374b:	68 20 3d 11 80       	push   $0x80113d20
80103750:	e8 0b 0b 00 00       	call   80104260 <initlock>
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
801037bd:	68 dc 7f 10 80       	push   $0x80107fdc
801037c2:	e8 a9 cb ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801037c7:	83 ec 0c             	sub    $0xc,%esp
801037ca:	68 bc 80 10 80       	push   $0x801080bc
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
80103807:	e8 14 0b 00 00       	call   80104320 <pushcli>
  c = mycpu();
8010380c:	e8 4f ff ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103811:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103817:	e8 f4 0b 00 00       	call   80104410 <popcli>
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
80103843:	e8 e8 35 00 00       	call   80106e30 <setupkvm>
80103848:	85 c0                	test   %eax,%eax
8010384a:	89 43 04             	mov    %eax,0x4(%ebx)
8010384d:	0f 84 bd 00 00 00    	je     80103910 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103853:	83 ec 04             	sub    $0x4,%esp
80103856:	68 2c 00 00 00       	push   $0x2c
8010385b:	68 60 b4 10 80       	push   $0x8010b460
80103860:	50                   	push   %eax
80103861:	e8 da 32 00 00       	call   80106b40 <inituvm>
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
80103876:	e8 55 0c 00 00       	call   801044d0 <memset>
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
801038cf:	68 05 80 10 80       	push   $0x80108005
801038d4:	50                   	push   %eax
801038d5:	e8 f6 0d 00 00       	call   801046d0 <safestrcpy>
  p->cwd = namei("/");
801038da:	c7 04 24 0e 80 10 80 	movl   $0x8010800e,(%esp)
801038e1:	e8 da e5 ff ff       	call   80101ec0 <namei>
801038e6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801038e9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801038f0:	e8 6b 0a 00 00       	call   80104360 <acquire>

  p->state = RUNNABLE;
801038f5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801038fc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103903:	e8 78 0b 00 00       	call   80104480 <release>
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
80103913:	68 ec 7f 10 80       	push   $0x80107fec
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
80103928:	e8 f3 09 00 00       	call   80104320 <pushcli>
  c = mycpu();
8010392d:	e8 2e fe ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103932:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103938:	e8 d3 0a 00 00       	call   80104410 <popcli>
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
8010394e:	e8 2d 33 00 00       	call   80106c80 <allocuvm>
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
80103960:	e8 cb 30 00 00       	call   80106a30 <switchuvm>
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
80103984:	e8 f7 33 00 00       	call   80106d80 <deallocuvm>
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
801039a9:	e8 72 09 00 00       	call   80104320 <pushcli>
  c = mycpu();
801039ae:	e8 ad fd ff ff       	call   80103760 <mycpu>
  p = c->proc;
801039b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039b9:	e8 52 0a 00 00       	call   80104410 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
801039be:	e8 fd fb ff ff       	call   801035c0 <allocproc>
801039c3:	85 c0                	test   %eax,%eax
801039c5:	89 c7                	mov    %eax,%edi
801039c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039ca:	0f 84 c5 00 00 00    	je     80103a95 <fork+0xf5>
    return -1;
  }
  
  // Copy process state from proc. 
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039d0:	83 ec 08             	sub    $0x8,%esp
801039d3:	ff 33                	pushl  (%ebx)
801039d5:	ff 73 04             	pushl  0x4(%ebx)
801039d8:	e8 23 35 00 00       	call   80106f00 <copyuvm>
801039dd:	83 c4 10             	add    $0x10,%esp
801039e0:	85 c0                	test   %eax,%eax
801039e2:	89 47 04             	mov    %eax,0x4(%edi)
801039e5:	0f 84 b1 00 00 00    	je     80103a9c <fork+0xfc>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801039eb:	8b 03                	mov    (%ebx),%eax
801039ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  np->parent = curproc;
  *np->tf = *curproc->tf;

  manage_fork(curproc, np);       //get shared pages in new processes address space 
801039f0:	83 ec 08             	sub    $0x8,%esp
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801039f3:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801039f5:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801039f8:	89 c8                	mov    %ecx,%eax
801039fa:	8b 79 18             	mov    0x18(%ecx),%edi
801039fd:	8b 73 18             	mov    0x18(%ebx),%esi
80103a00:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a05:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  manage_fork(curproc, np);       //get shared pages in new processes address space 
80103a07:	50                   	push   %eax
80103a08:	53                   	push   %ebx
80103a09:	89 c7                	mov    %eax,%edi

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a0b:	31 f6                	xor    %esi,%esi
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  manage_fork(curproc, np);       //get shared pages in new processes address space 
80103a0d:	e8 5e 3e 00 00       	call   80107870 <manage_fork>

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a12:	8b 47 18             	mov    0x18(%edi),%eax
80103a15:	83 c4 10             	add    $0x10,%esp
80103a18:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a1f:	90                   	nop

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103a20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a24:	85 c0                	test   %eax,%eax
80103a26:	74 13                	je     80103a3b <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a28:	83 ec 0c             	sub    $0xc,%esp
80103a2b:	50                   	push   %eax
80103a2c:	e8 af d3 ff ff       	call   80100de0 <filedup>
80103a31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a34:	83 c4 10             	add    $0x10,%esp
80103a37:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  manage_fork(curproc, np);       //get shared pages in new processes address space 

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a3b:	83 c6 01             	add    $0x1,%esi
80103a3e:	83 fe 10             	cmp    $0x10,%esi
80103a41:	75 dd                	jne    80103a20 <fork+0x80>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a43:	83 ec 0c             	sub    $0xc,%esp
80103a46:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a49:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a4c:	e8 ef db ff ff       	call   80101640 <idup>
80103a51:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a54:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a57:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a5a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a5d:	6a 10                	push   $0x10
80103a5f:	53                   	push   %ebx
80103a60:	50                   	push   %eax
80103a61:	e8 6a 0c 00 00       	call   801046d0 <safestrcpy>

  pid = np->pid;
80103a66:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103a69:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a70:	e8 eb 08 00 00       	call   80104360 <acquire>

  np->state = RUNNABLE;
80103a75:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103a7c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a83:	e8 f8 09 00 00       	call   80104480 <release>

  return pid;
80103a88:	83 c4 10             	add    $0x10,%esp
80103a8b:	89 d8                	mov    %ebx,%eax
}
80103a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a90:	5b                   	pop    %ebx
80103a91:	5e                   	pop    %esi
80103a92:	5f                   	pop    %edi
80103a93:	5d                   	pop    %ebp
80103a94:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a9a:	eb f1                	jmp    80103a8d <fork+0xed>
  }
  
  // Copy process state from proc. 
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103a9c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a9f:	83 ec 0c             	sub    $0xc,%esp
80103aa2:	ff 77 08             	pushl  0x8(%edi)
80103aa5:	e8 36 e8 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
80103aaa:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103ab1:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103ab8:	83 c4 10             	add    $0x10,%esp
80103abb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ac0:	eb cb                	jmp    80103a8d <fork+0xed>
80103ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ad0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	57                   	push   %edi
80103ad4:	56                   	push   %esi
80103ad5:	53                   	push   %ebx
80103ad6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103ad9:	e8 82 fc ff ff       	call   80103760 <mycpu>
80103ade:	8d 78 04             	lea    0x4(%eax),%edi
80103ae1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ae3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103aea:	00 00 00 
80103aed:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103af0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103af1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103af4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103af9:	68 20 3d 11 80       	push   $0x80113d20
80103afe:	e8 5d 08 00 00       	call   80104360 <acquire>
80103b03:	83 c4 10             	add    $0x10,%esp
80103b06:	eb 16                	jmp    80103b1e <scheduler+0x4e>
80103b08:	90                   	nop
80103b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b10:	81 c3 a0 03 00 00    	add    $0x3a0,%ebx
80103b16:	81 fb 54 25 12 80    	cmp    $0x80122554,%ebx
80103b1c:	74 52                	je     80103b70 <scheduler+0xa0>
      if(p->state != RUNNABLE)
80103b1e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b22:	75 ec                	jne    80103b10 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103b24:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103b27:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b2d:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b2e:	81 c3 a0 03 00 00    	add    $0x3a0,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103b34:	e8 f7 2e 00 00       	call   80106a30 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103b39:	58                   	pop    %eax
80103b3a:	5a                   	pop    %edx
80103b3b:	ff b3 7c fc ff ff    	pushl  -0x384(%ebx)
80103b41:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b42:	c7 83 6c fc ff ff 04 	movl   $0x4,-0x394(%ebx)
80103b49:	00 00 00 

      swtch(&(c->scheduler), p->context);
80103b4c:	e8 da 0b 00 00       	call   8010472b <swtch>
      switchkvm();
80103b51:	e8 ba 2e 00 00       	call   80106a10 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103b56:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b59:	81 fb 54 25 12 80    	cmp    $0x80122554,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103b5f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b66:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b69:	75 b3                	jne    80103b1e <scheduler+0x4e>
80103b6b:	90                   	nop
80103b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103b70:	83 ec 0c             	sub    $0xc,%esp
80103b73:	68 20 3d 11 80       	push   $0x80113d20
80103b78:	e8 03 09 00 00       	call   80104480 <release>

  }
80103b7d:	83 c4 10             	add    $0x10,%esp
80103b80:	e9 6b ff ff ff       	jmp    80103af0 <scheduler+0x20>
80103b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b90 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	56                   	push   %esi
80103b94:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b95:	e8 86 07 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103b9a:	e8 c1 fb ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103b9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ba5:	e8 66 08 00 00       	call   80104410 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103baa:	83 ec 0c             	sub    $0xc,%esp
80103bad:	68 20 3d 11 80       	push   $0x80113d20
80103bb2:	e8 29 07 00 00       	call   801042e0 <holding>
80103bb7:	83 c4 10             	add    $0x10,%esp
80103bba:	85 c0                	test   %eax,%eax
80103bbc:	74 4f                	je     80103c0d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103bbe:	e8 9d fb ff ff       	call   80103760 <mycpu>
80103bc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103bca:	75 68                	jne    80103c34 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103bcc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103bd0:	74 55                	je     80103c27 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bd2:	9c                   	pushf  
80103bd3:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103bd4:	f6 c4 02             	test   $0x2,%ah
80103bd7:	75 41                	jne    80103c1a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103bd9:	e8 82 fb ff ff       	call   80103760 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103bde:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103be1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103be7:	e8 74 fb ff ff       	call   80103760 <mycpu>
80103bec:	83 ec 08             	sub    $0x8,%esp
80103bef:	ff 70 04             	pushl  0x4(%eax)
80103bf2:	53                   	push   %ebx
80103bf3:	e8 33 0b 00 00       	call   8010472b <swtch>
  mycpu()->intena = intena;
80103bf8:	e8 63 fb ff ff       	call   80103760 <mycpu>
}
80103bfd:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103c00:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c09:	5b                   	pop    %ebx
80103c0a:	5e                   	pop    %esi
80103c0b:	5d                   	pop    %ebp
80103c0c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103c0d:	83 ec 0c             	sub    $0xc,%esp
80103c10:	68 10 80 10 80       	push   $0x80108010
80103c15:	e8 56 c7 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103c1a:	83 ec 0c             	sub    $0xc,%esp
80103c1d:	68 3c 80 10 80       	push   $0x8010803c
80103c22:	e8 49 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103c27:	83 ec 0c             	sub    $0xc,%esp
80103c2a:	68 2e 80 10 80       	push   $0x8010802e
80103c2f:	e8 3c c7 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103c34:	83 ec 0c             	sub    $0xc,%esp
80103c37:	68 22 80 10 80       	push   $0x80108022
80103c3c:	e8 2f c7 ff ff       	call   80100370 <panic>
80103c41:	eb 0d                	jmp    80103c50 <exit>
80103c43:	90                   	nop
80103c44:	90                   	nop
80103c45:	90                   	nop
80103c46:	90                   	nop
80103c47:	90                   	nop
80103c48:	90                   	nop
80103c49:	90                   	nop
80103c4a:	90                   	nop
80103c4b:	90                   	nop
80103c4c:	90                   	nop
80103c4d:	90                   	nop
80103c4e:	90                   	nop
80103c4f:	90                   	nop

80103c50 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c59:	e8 c2 06 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103c5e:	e8 fd fa ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103c63:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c69:	e8 a2 07 00 00       	call   80104410 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103c6e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103c74:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c77:	8d 7e 68             	lea    0x68(%esi),%edi
80103c7a:	0f 84 01 01 00 00    	je     80103d81 <exit+0x131>
  
  // shmrem("-1");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103c80:	8b 03                	mov    (%ebx),%eax
80103c82:	85 c0                	test   %eax,%eax
80103c84:	74 12                	je     80103c98 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c86:	83 ec 0c             	sub    $0xc,%esp
80103c89:	50                   	push   %eax
80103c8a:	e8 a1 d1 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103c8f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c95:	83 c4 10             	add    $0x10,%esp
80103c98:	83 c3 04             	add    $0x4,%ebx
    panic("init exiting");
  
  // shmrem("-1");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103c9b:	39 df                	cmp    %ebx,%edi
80103c9d:	75 e1                	jne    80103c80 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }
  
  shmrem("-1");
80103c9f:	83 ec 0c             	sub    $0xc,%esp
80103ca2:	68 5d 80 10 80       	push   $0x8010805d
80103ca7:	e8 44 38 00 00       	call   801074f0 <shmrem>

  begin_op();
80103cac:	e8 9f ee ff ff       	call   80102b50 <begin_op>
  iput(curproc->cwd);
80103cb1:	58                   	pop    %eax
80103cb2:	ff 76 68             	pushl  0x68(%esi)
80103cb5:	e8 e6 da ff ff       	call   801017a0 <iput>
  end_op();
80103cba:	e8 01 ef ff ff       	call   80102bc0 <end_op>
  curproc->cwd = 0;
80103cbf:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103cc6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ccd:	e8 8e 06 00 00       	call   80104360 <acquire>
  
  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103cd2:	8b 56 14             	mov    0x14(%esi),%edx
80103cd5:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cd8:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103cdd:	eb 0d                	jmp    80103cec <exit+0x9c>
80103cdf:	90                   	nop
80103ce0:	05 a0 03 00 00       	add    $0x3a0,%eax
80103ce5:	3d 54 25 12 80       	cmp    $0x80122554,%eax
80103cea:	74 1e                	je     80103d0a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103cec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cf0:	75 ee                	jne    80103ce0 <exit+0x90>
80103cf2:	3b 50 20             	cmp    0x20(%eax),%edx
80103cf5:	75 e9                	jne    80103ce0 <exit+0x90>
      p->state = RUNNABLE;
80103cf7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cfe:	05 a0 03 00 00       	add    $0x3a0,%eax
80103d03:	3d 54 25 12 80       	cmp    $0x80122554,%eax
80103d08:	75 e2                	jne    80103cec <exit+0x9c>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103d0a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80103d10:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103d15:	eb 17                	jmp    80103d2e <exit+0xde>
80103d17:	89 f6                	mov    %esi,%esi
80103d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  
  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d20:	81 c2 a0 03 00 00    	add    $0x3a0,%edx
80103d26:	81 fa 54 25 12 80    	cmp    $0x80122554,%edx
80103d2c:	74 3a                	je     80103d68 <exit+0x118>
    if(p->parent == curproc){
80103d2e:	39 72 14             	cmp    %esi,0x14(%edx)
80103d31:	75 ed                	jne    80103d20 <exit+0xd0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103d33:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103d37:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d3a:	75 e4                	jne    80103d20 <exit+0xd0>
80103d3c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103d41:	eb 11                	jmp    80103d54 <exit+0x104>
80103d43:	90                   	nop
80103d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d48:	05 a0 03 00 00       	add    $0x3a0,%eax
80103d4d:	3d 54 25 12 80       	cmp    $0x80122554,%eax
80103d52:	74 cc                	je     80103d20 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103d54:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d58:	75 ee                	jne    80103d48 <exit+0xf8>
80103d5a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d5d:	75 e9                	jne    80103d48 <exit+0xf8>
      p->state = RUNNABLE;
80103d5f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d66:	eb e0                	jmp    80103d48 <exit+0xf8>
        wakeup1(initproc);
    }
  }
  
  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103d68:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d6f:	e8 1c fe ff ff       	call   80103b90 <sched>
  panic("zombie exit");
80103d74:	83 ec 0c             	sub    $0xc,%esp
80103d77:	68 60 80 10 80       	push   $0x80108060
80103d7c:	e8 ef c5 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103d81:	83 ec 0c             	sub    $0xc,%esp
80103d84:	68 50 80 10 80       	push   $0x80108050
80103d89:	e8 e2 c5 ff ff       	call   80100370 <panic>
80103d8e:	66 90                	xchg   %ax,%ax

80103d90 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	53                   	push   %ebx
80103d94:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d97:	68 20 3d 11 80       	push   $0x80113d20
80103d9c:	e8 bf 05 00 00       	call   80104360 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103da1:	e8 7a 05 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103da6:	e8 b5 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103dab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db1:	e8 5a 06 00 00       	call   80104410 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103db6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103dbd:	e8 ce fd ff ff       	call   80103b90 <sched>
  release(&ptable.lock);
80103dc2:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103dc9:	e8 b2 06 00 00       	call   80104480 <release>
}
80103dce:	83 c4 10             	add    $0x10,%esp
80103dd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dd4:	c9                   	leave  
80103dd5:	c3                   	ret    
80103dd6:	8d 76 00             	lea    0x0(%esi),%esi
80103dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103de0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 0c             	sub    $0xc,%esp
80103de9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103dec:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103def:	e8 2c 05 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103df4:	e8 67 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103df9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dff:	e8 0c 06 00 00       	call   80104410 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103e04:	85 db                	test   %ebx,%ebx
80103e06:	0f 84 87 00 00 00    	je     80103e93 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103e0c:	85 f6                	test   %esi,%esi
80103e0e:	74 76                	je     80103e86 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e10:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80103e16:	74 50                	je     80103e68 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e18:	83 ec 0c             	sub    $0xc,%esp
80103e1b:	68 20 3d 11 80       	push   $0x80113d20
80103e20:	e8 3b 05 00 00       	call   80104360 <acquire>
    release(lk);
80103e25:	89 34 24             	mov    %esi,(%esp)
80103e28:	e8 53 06 00 00       	call   80104480 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103e2d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e30:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e37:	e8 54 fd ff ff       	call   80103b90 <sched>

  // Tidy up.
  p->chan = 0;
80103e3c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e43:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e4a:	e8 31 06 00 00       	call   80104480 <release>
    acquire(lk);
80103e4f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e52:	83 c4 10             	add    $0x10,%esp
  }
}
80103e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e58:	5b                   	pop    %ebx
80103e59:	5e                   	pop    %esi
80103e5a:	5f                   	pop    %edi
80103e5b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e5c:	e9 ff 04 00 00       	jmp    80104360 <acquire>
80103e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103e68:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e6b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e72:	e8 19 fd ff ff       	call   80103b90 <sched>

  // Tidy up.
  p->chan = 0;
80103e77:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e81:	5b                   	pop    %ebx
80103e82:	5e                   	pop    %esi
80103e83:	5f                   	pop    %edi
80103e84:	5d                   	pop    %ebp
80103e85:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	68 72 80 10 80       	push   $0x80108072
80103e8e:	e8 dd c4 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103e93:	83 ec 0c             	sub    $0xc,%esp
80103e96:	68 6c 80 10 80       	push   $0x8010806c
80103e9b:	e8 d0 c4 ff ff       	call   80100370 <panic>

80103ea0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	56                   	push   %esi
80103ea4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ea5:	e8 76 04 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103eaa:	e8 b1 f8 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103eaf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103eb5:	e8 56 05 00 00       	call   80104410 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	68 20 3d 11 80       	push   $0x80113d20
80103ec2:	e8 99 04 00 00       	call   80104360 <acquire>
80103ec7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103eca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ecc:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103ed1:	eb 13                	jmp    80103ee6 <wait+0x46>
80103ed3:	90                   	nop
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed8:	81 c3 a0 03 00 00    	add    $0x3a0,%ebx
80103ede:	81 fb 54 25 12 80    	cmp    $0x80122554,%ebx
80103ee4:	74 22                	je     80103f08 <wait+0x68>
      if(p->parent != curproc)
80103ee6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ee9:	75 ed                	jne    80103ed8 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103eeb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eef:	74 35                	je     80103f26 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef1:	81 c3 a0 03 00 00    	add    $0x3a0,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103ef7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efc:	81 fb 54 25 12 80    	cmp    $0x80122554,%ebx
80103f02:	75 e2                	jne    80103ee6 <wait+0x46>
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103f08:	85 c0                	test   %eax,%eax
80103f0a:	74 70                	je     80103f7c <wait+0xdc>
80103f0c:	8b 46 24             	mov    0x24(%esi),%eax
80103f0f:	85 c0                	test   %eax,%eax
80103f11:	75 69                	jne    80103f7c <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f13:	83 ec 08             	sub    $0x8,%esp
80103f16:	68 20 3d 11 80       	push   $0x80113d20
80103f1b:	56                   	push   %esi
80103f1c:	e8 bf fe ff ff       	call   80103de0 <sleep>
  }
80103f21:	83 c4 10             	add    $0x10,%esp
80103f24:	eb a4                	jmp    80103eca <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f2c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f2f:	e8 ac e3 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f34:	5a                   	pop    %edx
80103f35:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f38:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f3f:	e8 6c 2e 00 00       	call   80106db0 <freevm>
        p->pid = 0;
80103f44:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f4b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f52:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f56:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f5d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f64:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f6b:	e8 10 05 00 00       	call   80104480 <release>
        return pid;
80103f70:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f76:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f78:	5b                   	pop    %ebx
80103f79:	5e                   	pop    %esi
80103f7a:	5d                   	pop    %ebp
80103f7b:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103f7c:	83 ec 0c             	sub    $0xc,%esp
80103f7f:	68 20 3d 11 80       	push   $0x80113d20
80103f84:	e8 f7 04 00 00       	call   80104480 <release>
      return -1;
80103f89:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f94:	5b                   	pop    %ebx
80103f95:	5e                   	pop    %esi
80103f96:	5d                   	pop    %ebp
80103f97:	c3                   	ret    
80103f98:	90                   	nop
80103f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fa0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 10             	sub    $0x10,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103faa:	68 20 3d 11 80       	push   $0x80113d20
80103faf:	e8 ac 03 00 00       	call   80104360 <acquire>
80103fb4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103fbc:	eb 0e                	jmp    80103fcc <wakeup+0x2c>
80103fbe:	66 90                	xchg   %ax,%ax
80103fc0:	05 a0 03 00 00       	add    $0x3a0,%eax
80103fc5:	3d 54 25 12 80       	cmp    $0x80122554,%eax
80103fca:	74 1e                	je     80103fea <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103fcc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fd0:	75 ee                	jne    80103fc0 <wakeup+0x20>
80103fd2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fd5:	75 e9                	jne    80103fc0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fde:	05 a0 03 00 00       	add    $0x3a0,%eax
80103fe3:	3d 54 25 12 80       	cmp    $0x80122554,%eax
80103fe8:	75 e2                	jne    80103fcc <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fea:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80103ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff4:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ff5:	e9 86 04 00 00       	jmp    80104480 <release>
80103ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104000 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
80104007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010400a:	68 20 3d 11 80       	push   $0x80113d20
8010400f:	e8 4c 03 00 00       	call   80104360 <acquire>
80104014:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104017:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010401c:	eb 0e                	jmp    8010402c <kill+0x2c>
8010401e:	66 90                	xchg   %ax,%ax
80104020:	05 a0 03 00 00       	add    $0x3a0,%eax
80104025:	3d 54 25 12 80       	cmp    $0x80122554,%eax
8010402a:	74 3c                	je     80104068 <kill+0x68>
    if(p->pid == pid){
8010402c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010402f:	75 ef                	jne    80104020 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104031:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104035:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010403c:	74 1a                	je     80104058 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010403e:	83 ec 0c             	sub    $0xc,%esp
80104041:	68 20 3d 11 80       	push   $0x80113d20
80104046:	e8 35 04 00 00       	call   80104480 <release>
      return 0;
8010404b:	83 c4 10             	add    $0x10,%esp
8010404e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104053:	c9                   	leave  
80104054:	c3                   	ret    
80104055:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104058:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010405f:	eb dd                	jmp    8010403e <kill+0x3e>
80104061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	68 20 3d 11 80       	push   $0x80113d20
80104070:	e8 0b 04 00 00       	call   80104480 <release>
  return -1;
80104075:	83 c4 10             	add    $0x10,%esp
80104078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010407d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104080:	c9                   	leave  
80104081:	c3                   	ret    
80104082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104099:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010409e:	83 ec 3c             	sub    $0x3c,%esp
801040a1:	eb 27                	jmp    801040ca <procdump+0x3a>
801040a3:	90                   	nop
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	68 0b 84 10 80       	push   $0x8010840b
801040b0:	e8 ab c5 ff ff       	call   80100660 <cprintf>
801040b5:	83 c4 10             	add    $0x10,%esp
801040b8:	81 c3 a0 03 00 00    	add    $0x3a0,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040be:	81 fb c0 25 12 80    	cmp    $0x801225c0,%ebx
801040c4:	0f 84 7e 00 00 00    	je     80104148 <procdump+0xb8>
    if(p->state == UNUSED)
801040ca:	8b 43 a0             	mov    -0x60(%ebx),%eax
801040cd:	85 c0                	test   %eax,%eax
801040cf:	74 e7                	je     801040b8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040d1:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801040d4:	ba 83 80 10 80       	mov    $0x80108083,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040d9:	77 11                	ja     801040ec <procdump+0x5c>
801040db:	8b 14 85 e4 80 10 80 	mov    -0x7fef7f1c(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801040e2:	b8 83 80 10 80       	mov    $0x80108083,%eax
801040e7:	85 d2                	test   %edx,%edx
801040e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040ec:	53                   	push   %ebx
801040ed:	52                   	push   %edx
801040ee:	ff 73 a4             	pushl  -0x5c(%ebx)
801040f1:	68 87 80 10 80       	push   $0x80108087
801040f6:	e8 65 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801040fb:	83 c4 10             	add    $0x10,%esp
801040fe:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104102:	75 a4                	jne    801040a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104104:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104107:	83 ec 08             	sub    $0x8,%esp
8010410a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010410d:	50                   	push   %eax
8010410e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104111:	8b 40 0c             	mov    0xc(%eax),%eax
80104114:	83 c0 08             	add    $0x8,%eax
80104117:	50                   	push   %eax
80104118:	e8 63 01 00 00       	call   80104280 <getcallerpcs>
8010411d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104120:	8b 17                	mov    (%edi),%edx
80104122:	85 d2                	test   %edx,%edx
80104124:	74 82                	je     801040a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104126:	83 ec 08             	sub    $0x8,%esp
80104129:	83 c7 04             	add    $0x4,%edi
8010412c:	52                   	push   %edx
8010412d:	68 c1 7a 10 80       	push   $0x80107ac1
80104132:	e8 29 c5 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104137:	83 c4 10             	add    $0x10,%esp
8010413a:	39 f7                	cmp    %esi,%edi
8010413c:	75 e2                	jne    80104120 <procdump+0x90>
8010413e:	e9 65 ff ff ff       	jmp    801040a8 <procdump+0x18>
80104143:	90                   	nop
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010414b:	5b                   	pop    %ebx
8010414c:	5e                   	pop    %esi
8010414d:	5f                   	pop    %edi
8010414e:	5d                   	pop    %ebp
8010414f:	c3                   	ret    

80104150 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010415a:	68 fc 80 10 80       	push   $0x801080fc
8010415f:	8d 43 04             	lea    0x4(%ebx),%eax
80104162:	50                   	push   %eax
80104163:	e8 f8 00 00 00       	call   80104260 <initlock>
  lk->name = name;
80104168:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010416b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104171:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104174:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010417b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010417e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104181:	c9                   	leave  
80104182:	c3                   	ret    
80104183:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104190 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
80104195:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	8d 73 04             	lea    0x4(%ebx),%esi
8010419e:	56                   	push   %esi
8010419f:	e8 bc 01 00 00       	call   80104360 <acquire>
  while (lk->locked) {
801041a4:	8b 13                	mov    (%ebx),%edx
801041a6:	83 c4 10             	add    $0x10,%esp
801041a9:	85 d2                	test   %edx,%edx
801041ab:	74 16                	je     801041c3 <acquiresleep+0x33>
801041ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801041b0:	83 ec 08             	sub    $0x8,%esp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
801041b5:	e8 26 fc ff ff       	call   80103de0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801041ba:	8b 03                	mov    (%ebx),%eax
801041bc:	83 c4 10             	add    $0x10,%esp
801041bf:	85 c0                	test   %eax,%eax
801041c1:	75 ed                	jne    801041b0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801041c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801041c9:	e8 32 f6 ff ff       	call   80103800 <myproc>
801041ce:	8b 40 10             	mov    0x10(%eax),%eax
801041d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801041d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041da:	5b                   	pop    %ebx
801041db:	5e                   	pop    %esi
801041dc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801041dd:	e9 9e 02 00 00       	jmp    80104480 <release>
801041e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041f0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	56                   	push   %esi
801041f4:	53                   	push   %ebx
801041f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	8d 73 04             	lea    0x4(%ebx),%esi
801041fe:	56                   	push   %esi
801041ff:	e8 5c 01 00 00       	call   80104360 <acquire>
  lk->locked = 0;
80104204:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010420a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104211:	89 1c 24             	mov    %ebx,(%esp)
80104214:	e8 87 fd ff ff       	call   80103fa0 <wakeup>
  release(&lk->lk);
80104219:	89 75 08             	mov    %esi,0x8(%ebp)
8010421c:	83 c4 10             	add    $0x10,%esp
}
8010421f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104222:	5b                   	pop    %ebx
80104223:	5e                   	pop    %esi
80104224:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104225:	e9 56 02 00 00       	jmp    80104480 <release>
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104230 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	56                   	push   %esi
80104234:	53                   	push   %ebx
80104235:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104238:	83 ec 0c             	sub    $0xc,%esp
8010423b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010423e:	53                   	push   %ebx
8010423f:	e8 1c 01 00 00       	call   80104360 <acquire>
  r = lk->locked;
80104244:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104246:	89 1c 24             	mov    %ebx,(%esp)
80104249:	e8 32 02 00 00       	call   80104480 <release>
  return r;
}
8010424e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104251:	89 f0                	mov    %esi,%eax
80104253:	5b                   	pop    %ebx
80104254:	5e                   	pop    %esi
80104255:	5d                   	pop    %ebp
80104256:	c3                   	ret    
80104257:	66 90                	xchg   %ax,%ax
80104259:	66 90                	xchg   %ax,%ax
8010425b:	66 90                	xchg   %ax,%ax
8010425d:	66 90                	xchg   %ax,%ax
8010425f:	90                   	nop

80104260 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104266:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010426f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104272:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104279:	5d                   	pop    %ebp
8010427a:	c3                   	ret    
8010427b:	90                   	nop
8010427c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104280 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104284:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104287:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010428a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010428d:	31 c0                	xor    %eax,%eax
8010428f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104290:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104296:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010429c:	77 1a                	ja     801042b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010429e:	8b 5a 04             	mov    0x4(%edx),%ebx
801042a1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042a4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801042a7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042a9:	83 f8 0a             	cmp    $0xa,%eax
801042ac:	75 e2                	jne    80104290 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801042ae:	5b                   	pop    %ebx
801042af:	5d                   	pop    %ebp
801042b0:	c3                   	ret    
801042b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801042b8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042bf:	83 c0 01             	add    $0x1,%eax
801042c2:	83 f8 0a             	cmp    $0xa,%eax
801042c5:	74 e7                	je     801042ae <getcallerpcs+0x2e>
    pcs[i] = 0;
801042c7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042ce:	83 c0 01             	add    $0x1,%eax
801042d1:	83 f8 0a             	cmp    $0xa,%eax
801042d4:	75 e2                	jne    801042b8 <getcallerpcs+0x38>
801042d6:	eb d6                	jmp    801042ae <getcallerpcs+0x2e>
801042d8:	90                   	nop
801042d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042e0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 04             	sub    $0x4,%esp
801042e7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801042ea:	8b 02                	mov    (%edx),%eax
801042ec:	85 c0                	test   %eax,%eax
801042ee:	75 10                	jne    80104300 <holding+0x20>
}
801042f0:	83 c4 04             	add    $0x4,%esp
801042f3:	31 c0                	xor    %eax,%eax
801042f5:	5b                   	pop    %ebx
801042f6:	5d                   	pop    %ebp
801042f7:	c3                   	ret    
801042f8:	90                   	nop
801042f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104300:	8b 5a 08             	mov    0x8(%edx),%ebx
80104303:	e8 58 f4 ff ff       	call   80103760 <mycpu>
80104308:	39 c3                	cmp    %eax,%ebx
8010430a:	0f 94 c0             	sete   %al
}
8010430d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104310:	0f b6 c0             	movzbl %al,%eax
}
80104313:	5b                   	pop    %ebx
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret    
80104316:	8d 76 00             	lea    0x0(%esi),%esi
80104319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104320 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 04             	sub    $0x4,%esp
80104327:	9c                   	pushf  
80104328:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104329:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010432a:	e8 31 f4 ff ff       	call   80103760 <mycpu>
8010432f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104335:	85 c0                	test   %eax,%eax
80104337:	75 11                	jne    8010434a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104339:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010433f:	e8 1c f4 ff ff       	call   80103760 <mycpu>
80104344:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010434a:	e8 11 f4 ff ff       	call   80103760 <mycpu>
8010434f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104356:	83 c4 04             	add    $0x4,%esp
80104359:	5b                   	pop    %ebx
8010435a:	5d                   	pop    %ebp
8010435b:	c3                   	ret    
8010435c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104360 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	56                   	push   %esi
80104364:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104365:	e8 b6 ff ff ff       	call   80104320 <pushcli>
  if(holding(lk))
8010436a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010436d:	8b 03                	mov    (%ebx),%eax
8010436f:	85 c0                	test   %eax,%eax
80104371:	75 7d                	jne    801043f0 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104373:	ba 01 00 00 00       	mov    $0x1,%edx
80104378:	eb 09                	jmp    80104383 <acquire+0x23>
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104380:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104383:	89 d0                	mov    %edx,%eax
80104385:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104388:	85 c0                	test   %eax,%eax
8010438a:	75 f4                	jne    80104380 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010438c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104391:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104394:	e8 c7 f3 ff ff       	call   80103760 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104399:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010439b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010439e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043a1:	31 c0                	xor    %eax,%eax
801043a3:	90                   	nop
801043a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043a8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801043ae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043b4:	77 1a                	ja     801043d0 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043b6:	8b 5a 04             	mov    0x4(%edx),%ebx
801043b9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043bc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801043bf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043c1:	83 f8 0a             	cmp    $0xa,%eax
801043c4:	75 e2                	jne    801043a8 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801043c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c9:	5b                   	pop    %ebx
801043ca:	5e                   	pop    %esi
801043cb:	5d                   	pop    %ebp
801043cc:	c3                   	ret    
801043cd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801043d0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043d7:	83 c0 01             	add    $0x1,%eax
801043da:	83 f8 0a             	cmp    $0xa,%eax
801043dd:	74 e7                	je     801043c6 <acquire+0x66>
    pcs[i] = 0;
801043df:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043e6:	83 c0 01             	add    $0x1,%eax
801043e9:	83 f8 0a             	cmp    $0xa,%eax
801043ec:	75 e2                	jne    801043d0 <acquire+0x70>
801043ee:	eb d6                	jmp    801043c6 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801043f0:	8b 73 08             	mov    0x8(%ebx),%esi
801043f3:	e8 68 f3 ff ff       	call   80103760 <mycpu>
801043f8:	39 c6                	cmp    %eax,%esi
801043fa:	0f 85 73 ff ff ff    	jne    80104373 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104400:	83 ec 0c             	sub    $0xc,%esp
80104403:	68 07 81 10 80       	push   $0x80108107
80104408:	e8 63 bf ff ff       	call   80100370 <panic>
8010440d:	8d 76 00             	lea    0x0(%esi),%esi

80104410 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104416:	9c                   	pushf  
80104417:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104418:	f6 c4 02             	test   $0x2,%ah
8010441b:	75 52                	jne    8010446f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010441d:	e8 3e f3 ff ff       	call   80103760 <mycpu>
80104422:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104428:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010442b:	85 d2                	test   %edx,%edx
8010442d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104433:	78 2d                	js     80104462 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104435:	e8 26 f3 ff ff       	call   80103760 <mycpu>
8010443a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104440:	85 d2                	test   %edx,%edx
80104442:	74 0c                	je     80104450 <popcli+0x40>
    sti();
}
80104444:	c9                   	leave  
80104445:	c3                   	ret    
80104446:	8d 76 00             	lea    0x0(%esi),%esi
80104449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104450:	e8 0b f3 ff ff       	call   80103760 <mycpu>
80104455:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010445b:	85 c0                	test   %eax,%eax
8010445d:	74 e5                	je     80104444 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010445f:	fb                   	sti    
    sti();
}
80104460:	c9                   	leave  
80104461:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104462:	83 ec 0c             	sub    $0xc,%esp
80104465:	68 26 81 10 80       	push   $0x80108126
8010446a:	e8 01 bf ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010446f:	83 ec 0c             	sub    $0xc,%esp
80104472:	68 0f 81 10 80       	push   $0x8010810f
80104477:	e8 f4 be ff ff       	call   80100370 <panic>
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104488:	8b 03                	mov    (%ebx),%eax
8010448a:	85 c0                	test   %eax,%eax
8010448c:	75 12                	jne    801044a0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010448e:	83 ec 0c             	sub    $0xc,%esp
80104491:	68 2d 81 10 80       	push   $0x8010812d
80104496:	e8 d5 be ff ff       	call   80100370 <panic>
8010449b:	90                   	nop
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801044a0:	8b 73 08             	mov    0x8(%ebx),%esi
801044a3:	e8 b8 f2 ff ff       	call   80103760 <mycpu>
801044a8:	39 c6                	cmp    %eax,%esi
801044aa:	75 e2                	jne    8010448e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
801044ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801044b3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801044ba:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801044bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801044c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044c8:	5b                   	pop    %ebx
801044c9:	5e                   	pop    %esi
801044ca:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801044cb:	e9 40 ff ff ff       	jmp    80104410 <popcli>

801044d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	57                   	push   %edi
801044d4:	53                   	push   %ebx
801044d5:	8b 55 08             	mov    0x8(%ebp),%edx
801044d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801044db:	f6 c2 03             	test   $0x3,%dl
801044de:	75 05                	jne    801044e5 <memset+0x15>
801044e0:	f6 c1 03             	test   $0x3,%cl
801044e3:	74 13                	je     801044f8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801044e5:	89 d7                	mov    %edx,%edi
801044e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ea:	fc                   	cld    
801044eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044ed:	5b                   	pop    %ebx
801044ee:	89 d0                	mov    %edx,%eax
801044f0:	5f                   	pop    %edi
801044f1:	5d                   	pop    %ebp
801044f2:	c3                   	ret    
801044f3:	90                   	nop
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801044f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801044fc:	c1 e9 02             	shr    $0x2,%ecx
801044ff:	89 fb                	mov    %edi,%ebx
80104501:	89 f8                	mov    %edi,%eax
80104503:	c1 e3 18             	shl    $0x18,%ebx
80104506:	c1 e0 10             	shl    $0x10,%eax
80104509:	09 d8                	or     %ebx,%eax
8010450b:	09 f8                	or     %edi,%eax
8010450d:	c1 e7 08             	shl    $0x8,%edi
80104510:	09 f8                	or     %edi,%eax
80104512:	89 d7                	mov    %edx,%edi
80104514:	fc                   	cld    
80104515:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104517:	5b                   	pop    %ebx
80104518:	89 d0                	mov    %edx,%eax
8010451a:	5f                   	pop    %edi
8010451b:	5d                   	pop    %ebp
8010451c:	c3                   	ret    
8010451d:	8d 76 00             	lea    0x0(%esi),%esi

80104520 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	8b 45 10             	mov    0x10(%ebp),%eax
80104528:	53                   	push   %ebx
80104529:	8b 75 0c             	mov    0xc(%ebp),%esi
8010452c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010452f:	85 c0                	test   %eax,%eax
80104531:	74 29                	je     8010455c <memcmp+0x3c>
    if(*s1 != *s2)
80104533:	0f b6 13             	movzbl (%ebx),%edx
80104536:	0f b6 0e             	movzbl (%esi),%ecx
80104539:	38 d1                	cmp    %dl,%cl
8010453b:	75 2b                	jne    80104568 <memcmp+0x48>
8010453d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104540:	31 c0                	xor    %eax,%eax
80104542:	eb 14                	jmp    80104558 <memcmp+0x38>
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104548:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010454d:	83 c0 01             	add    $0x1,%eax
80104550:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104554:	38 ca                	cmp    %cl,%dl
80104556:	75 10                	jne    80104568 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104558:	39 f8                	cmp    %edi,%eax
8010455a:	75 ec                	jne    80104548 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010455c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010455d:	31 c0                	xor    %eax,%eax
}
8010455f:	5e                   	pop    %esi
80104560:	5f                   	pop    %edi
80104561:	5d                   	pop    %ebp
80104562:	c3                   	ret    
80104563:	90                   	nop
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104568:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010456b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010456c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010456e:	5e                   	pop    %esi
8010456f:	5f                   	pop    %edi
80104570:	5d                   	pop    %ebp
80104571:	c3                   	ret    
80104572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104580 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	8b 45 08             	mov    0x8(%ebp),%eax
80104588:	8b 75 0c             	mov    0xc(%ebp),%esi
8010458b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010458e:	39 c6                	cmp    %eax,%esi
80104590:	73 2e                	jae    801045c0 <memmove+0x40>
80104592:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104595:	39 c8                	cmp    %ecx,%eax
80104597:	73 27                	jae    801045c0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104599:	85 db                	test   %ebx,%ebx
8010459b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010459e:	74 17                	je     801045b7 <memmove+0x37>
      *--d = *--s;
801045a0:	29 d9                	sub    %ebx,%ecx
801045a2:	89 cb                	mov    %ecx,%ebx
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045a8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801045ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801045af:	83 ea 01             	sub    $0x1,%edx
801045b2:	83 fa ff             	cmp    $0xffffffff,%edx
801045b5:	75 f1                	jne    801045a8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801045b7:	5b                   	pop    %ebx
801045b8:	5e                   	pop    %esi
801045b9:	5d                   	pop    %ebp
801045ba:	c3                   	ret    
801045bb:	90                   	nop
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045c0:	31 d2                	xor    %edx,%edx
801045c2:	85 db                	test   %ebx,%ebx
801045c4:	74 f1                	je     801045b7 <memmove+0x37>
801045c6:	8d 76 00             	lea    0x0(%esi),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801045d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801045d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045d7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045da:	39 d3                	cmp    %edx,%ebx
801045dc:	75 f2                	jne    801045d0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801045de:	5b                   	pop    %ebx
801045df:	5e                   	pop    %esi
801045e0:	5d                   	pop    %ebp
801045e1:	c3                   	ret    
801045e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801045f3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801045f4:	eb 8a                	jmp    80104580 <memmove>
801045f6:	8d 76 00             	lea    0x0(%esi),%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104600 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	56                   	push   %esi
80104605:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104608:	53                   	push   %ebx
80104609:	8b 7d 08             	mov    0x8(%ebp),%edi
8010460c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010460f:	85 c9                	test   %ecx,%ecx
80104611:	74 37                	je     8010464a <strncmp+0x4a>
80104613:	0f b6 17             	movzbl (%edi),%edx
80104616:	0f b6 1e             	movzbl (%esi),%ebx
80104619:	84 d2                	test   %dl,%dl
8010461b:	74 3f                	je     8010465c <strncmp+0x5c>
8010461d:	38 d3                	cmp    %dl,%bl
8010461f:	75 3b                	jne    8010465c <strncmp+0x5c>
80104621:	8d 47 01             	lea    0x1(%edi),%eax
80104624:	01 cf                	add    %ecx,%edi
80104626:	eb 1b                	jmp    80104643 <strncmp+0x43>
80104628:	90                   	nop
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104630:	0f b6 10             	movzbl (%eax),%edx
80104633:	84 d2                	test   %dl,%dl
80104635:	74 21                	je     80104658 <strncmp+0x58>
80104637:	0f b6 19             	movzbl (%ecx),%ebx
8010463a:	83 c0 01             	add    $0x1,%eax
8010463d:	89 ce                	mov    %ecx,%esi
8010463f:	38 da                	cmp    %bl,%dl
80104641:	75 19                	jne    8010465c <strncmp+0x5c>
80104643:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104645:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104648:	75 e6                	jne    80104630 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010464a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010464b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010464d:	5e                   	pop    %esi
8010464e:	5f                   	pop    %edi
8010464f:	5d                   	pop    %ebp
80104650:	c3                   	ret    
80104651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104658:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010465c:	0f b6 c2             	movzbl %dl,%eax
8010465f:	29 d8                	sub    %ebx,%eax
}
80104661:	5b                   	pop    %ebx
80104662:	5e                   	pop    %esi
80104663:	5f                   	pop    %edi
80104664:	5d                   	pop    %ebp
80104665:	c3                   	ret    
80104666:	8d 76 00             	lea    0x0(%esi),%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104670 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 45 08             	mov    0x8(%ebp),%eax
80104678:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010467b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010467e:	89 c2                	mov    %eax,%edx
80104680:	eb 19                	jmp    8010469b <strncpy+0x2b>
80104682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104688:	83 c3 01             	add    $0x1,%ebx
8010468b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010468f:	83 c2 01             	add    $0x1,%edx
80104692:	84 c9                	test   %cl,%cl
80104694:	88 4a ff             	mov    %cl,-0x1(%edx)
80104697:	74 09                	je     801046a2 <strncpy+0x32>
80104699:	89 f1                	mov    %esi,%ecx
8010469b:	85 c9                	test   %ecx,%ecx
8010469d:	8d 71 ff             	lea    -0x1(%ecx),%esi
801046a0:	7f e6                	jg     80104688 <strncpy+0x18>
    ;
  while(n-- > 0)
801046a2:	31 c9                	xor    %ecx,%ecx
801046a4:	85 f6                	test   %esi,%esi
801046a6:	7e 17                	jle    801046bf <strncpy+0x4f>
801046a8:	90                   	nop
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801046b0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801046b4:	89 f3                	mov    %esi,%ebx
801046b6:	83 c1 01             	add    $0x1,%ecx
801046b9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801046bb:	85 db                	test   %ebx,%ebx
801046bd:	7f f1                	jg     801046b0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801046bf:	5b                   	pop    %ebx
801046c0:	5e                   	pop    %esi
801046c1:	5d                   	pop    %ebp
801046c2:	c3                   	ret    
801046c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046d8:	8b 45 08             	mov    0x8(%ebp),%eax
801046db:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801046de:	85 c9                	test   %ecx,%ecx
801046e0:	7e 26                	jle    80104708 <safestrcpy+0x38>
801046e2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046e6:	89 c1                	mov    %eax,%ecx
801046e8:	eb 17                	jmp    80104701 <safestrcpy+0x31>
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046f0:	83 c2 01             	add    $0x1,%edx
801046f3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046f7:	83 c1 01             	add    $0x1,%ecx
801046fa:	84 db                	test   %bl,%bl
801046fc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046ff:	74 04                	je     80104705 <safestrcpy+0x35>
80104701:	39 f2                	cmp    %esi,%edx
80104703:	75 eb                	jne    801046f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104705:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104708:	5b                   	pop    %ebx
80104709:	5e                   	pop    %esi
8010470a:	5d                   	pop    %ebp
8010470b:	c3                   	ret    
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104710 <strlen>:

int
strlen(const char *s)
{
80104710:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104711:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104713:	89 e5                	mov    %esp,%ebp
80104715:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104718:	80 3a 00             	cmpb   $0x0,(%edx)
8010471b:	74 0c                	je     80104729 <strlen+0x19>
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
80104720:	83 c0 01             	add    $0x1,%eax
80104723:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104727:	75 f7                	jne    80104720 <strlen+0x10>
    ;
  return n;
}
80104729:	5d                   	pop    %ebp
8010472a:	c3                   	ret    

8010472b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010472b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010472f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104733:	55                   	push   %ebp
  pushl %ebx
80104734:	53                   	push   %ebx
  pushl %esi
80104735:	56                   	push   %esi
  pushl %edi
80104736:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104737:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104739:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010473b:	5f                   	pop    %edi
  popl %esi
8010473c:	5e                   	pop    %esi
  popl %ebx
8010473d:	5b                   	pop    %ebx
  popl %ebp
8010473e:	5d                   	pop    %ebp
  ret
8010473f:	c3                   	ret    

80104740 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	53                   	push   %ebx
80104744:	83 ec 04             	sub    $0x4,%esp
80104747:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010474a:	e8 b1 f0 ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010474f:	8b 00                	mov    (%eax),%eax
80104751:	39 d8                	cmp    %ebx,%eax
80104753:	76 1b                	jbe    80104770 <fetchint+0x30>
80104755:	8d 53 04             	lea    0x4(%ebx),%edx
80104758:	39 d0                	cmp    %edx,%eax
8010475a:	72 14                	jb     80104770 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010475c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010475f:	8b 13                	mov    (%ebx),%edx
80104761:	89 10                	mov    %edx,(%eax)
  return 0;
80104763:	31 c0                	xor    %eax,%eax
}
80104765:	83 c4 04             	add    $0x4,%esp
80104768:	5b                   	pop    %ebx
80104769:	5d                   	pop    %ebp
8010476a:	c3                   	ret    
8010476b:	90                   	nop
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104775:	eb ee                	jmp    80104765 <fetchint+0x25>
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 04             	sub    $0x4,%esp
80104787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010478a:	e8 71 f0 ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz)
8010478f:	39 18                	cmp    %ebx,(%eax)
80104791:	76 29                	jbe    801047bc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104793:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104796:	89 da                	mov    %ebx,%edx
80104798:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010479a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010479c:	39 c3                	cmp    %eax,%ebx
8010479e:	73 1c                	jae    801047bc <fetchstr+0x3c>
    if(*s == 0)
801047a0:	80 3b 00             	cmpb   $0x0,(%ebx)
801047a3:	75 10                	jne    801047b5 <fetchstr+0x35>
801047a5:	eb 29                	jmp    801047d0 <fetchstr+0x50>
801047a7:	89 f6                	mov    %esi,%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801047b0:	80 3a 00             	cmpb   $0x0,(%edx)
801047b3:	74 1b                	je     801047d0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801047b5:	83 c2 01             	add    $0x1,%edx
801047b8:	39 d0                	cmp    %edx,%eax
801047ba:	77 f4                	ja     801047b0 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801047bc:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
801047bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801047c4:	5b                   	pop    %ebx
801047c5:	5d                   	pop    %ebp
801047c6:	c3                   	ret    
801047c7:	89 f6                	mov    %esi,%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801047d0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801047d3:	89 d0                	mov    %edx,%eax
801047d5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801047d7:	5b                   	pop    %ebx
801047d8:	5d                   	pop    %ebp
801047d9:	c3                   	ret    
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047e5:	e8 16 f0 ff ff       	call   80103800 <myproc>
801047ea:	8b 40 18             	mov    0x18(%eax),%eax
801047ed:	8b 55 08             	mov    0x8(%ebp),%edx
801047f0:	8b 40 44             	mov    0x44(%eax),%eax
801047f3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
801047f6:	e8 05 f0 ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047fb:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047fd:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104800:	39 c6                	cmp    %eax,%esi
80104802:	73 1c                	jae    80104820 <argint+0x40>
80104804:	8d 53 08             	lea    0x8(%ebx),%edx
80104807:	39 d0                	cmp    %edx,%eax
80104809:	72 15                	jb     80104820 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
8010480b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010480e:	8b 53 04             	mov    0x4(%ebx),%edx
80104811:	89 10                	mov    %edx,(%eax)
  return 0;
80104813:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104815:	5b                   	pop    %ebx
80104816:	5e                   	pop    %esi
80104817:	5d                   	pop    %ebp
80104818:	c3                   	ret    
80104819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104825:	eb ee                	jmp    80104815 <argint+0x35>
80104827:	89 f6                	mov    %esi,%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	83 ec 10             	sub    $0x10,%esp
80104838:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010483b:	e8 c0 ef ff ff       	call   80103800 <myproc>
80104840:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104842:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104845:	83 ec 08             	sub    $0x8,%esp
80104848:	50                   	push   %eax
80104849:	ff 75 08             	pushl  0x8(%ebp)
8010484c:	e8 8f ff ff ff       	call   801047e0 <argint>
80104851:	83 c4 10             	add    $0x10,%esp
80104854:	85 c0                	test   %eax,%eax
80104856:	78 28                	js     80104880 <argptr+0x50>
    return -1;

  if ((uint)i < KERNBASE && (uint)i >= KERNBASE - PGSIZE*32)
80104858:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485b:	3d ff ff fd 7f       	cmp    $0x7ffdffff,%eax
80104860:	7f 10                	jg     80104872 <argptr+0x42>
  {
    *pp = (char*)i;
    return 0;
  }

  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104862:	85 db                	test   %ebx,%ebx
80104864:	78 1a                	js     80104880 <argptr+0x50>
80104866:	8b 16                	mov    (%esi),%edx
80104868:	39 c2                	cmp    %eax,%edx
8010486a:	76 14                	jbe    80104880 <argptr+0x50>
8010486c:	01 c3                	add    %eax,%ebx
8010486e:	39 da                	cmp    %ebx,%edx
80104870:	72 0e                	jb     80104880 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104872:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104875:	89 01                	mov    %eax,(%ecx)
  return 0;
80104877:	31 c0                	xor    %eax,%eax
}
80104879:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010487c:	5b                   	pop    %ebx
8010487d:	5e                   	pop    %esi
8010487e:	5d                   	pop    %ebp
8010487f:	c3                   	ret    
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
80104880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104885:	eb f2                	jmp    80104879 <argptr+0x49>
80104887:	89 f6                	mov    %esi,%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104896:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104899:	50                   	push   %eax
8010489a:	ff 75 08             	pushl  0x8(%ebp)
8010489d:	e8 3e ff ff ff       	call   801047e0 <argint>
801048a2:	83 c4 10             	add    $0x10,%esp
801048a5:	85 c0                	test   %eax,%eax
801048a7:	78 17                	js     801048c0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801048a9:	83 ec 08             	sub    $0x8,%esp
801048ac:	ff 75 0c             	pushl  0xc(%ebp)
801048af:	ff 75 f4             	pushl  -0xc(%ebp)
801048b2:	e8 c9 fe ff ff       	call   80104780 <fetchstr>
801048b7:	83 c4 10             	add    $0x10,%esp
}
801048ba:	c9                   	leave  
801048bb:	c3                   	ret    
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801048c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801048c5:	c9                   	leave  
801048c6:	c3                   	ret    
801048c7:	89 f6                	mov    %esi,%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048d0 <syscall>:
[SYS_sem_down]   sys_sem_down,
};

void
syscall(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801048d5:	e8 26 ef ff ff       	call   80103800 <myproc>

  num = curproc->tf->eax;
801048da:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801048dd:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801048df:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801048e2:	8d 50 ff             	lea    -0x1(%eax),%edx
801048e5:	83 fa 19             	cmp    $0x19,%edx
801048e8:	77 1e                	ja     80104908 <syscall+0x38>
801048ea:	8b 14 85 60 81 10 80 	mov    -0x7fef7ea0(,%eax,4),%edx
801048f1:	85 d2                	test   %edx,%edx
801048f3:	74 13                	je     80104908 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801048f5:	ff d2                	call   *%edx
801048f7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801048fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048fd:	5b                   	pop    %ebx
801048fe:	5e                   	pop    %esi
801048ff:	5d                   	pop    %ebp
80104900:	c3                   	ret    
80104901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104908:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104909:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010490c:	50                   	push   %eax
8010490d:	ff 73 10             	pushl  0x10(%ebx)
80104910:	68 35 81 10 80       	push   $0x80108135
80104915:	e8 46 bd ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010491a:	8b 43 18             	mov    0x18(%ebx),%eax
8010491d:	83 c4 10             	add    $0x10,%esp
80104920:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104927:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010492a:	5b                   	pop    %ebx
8010492b:	5e                   	pop    %esi
8010492c:	5d                   	pop    %ebp
8010492d:	c3                   	ret    
8010492e:	66 90                	xchg   %ax,%ax

80104930 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	57                   	push   %edi
80104934:	56                   	push   %esi
80104935:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104936:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104939:	83 ec 44             	sub    $0x44,%esp
8010493c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010493f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104942:	56                   	push   %esi
80104943:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104944:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104947:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010494a:	e8 91 d5 ff ff       	call   80101ee0 <nameiparent>
8010494f:	83 c4 10             	add    $0x10,%esp
80104952:	85 c0                	test   %eax,%eax
80104954:	0f 84 f6 00 00 00    	je     80104a50 <create+0x120>
    return 0;
  ilock(dp);
8010495a:	83 ec 0c             	sub    $0xc,%esp
8010495d:	89 c7                	mov    %eax,%edi
8010495f:	50                   	push   %eax
80104960:	e8 0b cd ff ff       	call   80101670 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104965:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104968:	83 c4 0c             	add    $0xc,%esp
8010496b:	50                   	push   %eax
8010496c:	56                   	push   %esi
8010496d:	57                   	push   %edi
8010496e:	e8 2d d2 ff ff       	call   80101ba0 <dirlookup>
80104973:	83 c4 10             	add    $0x10,%esp
80104976:	85 c0                	test   %eax,%eax
80104978:	89 c3                	mov    %eax,%ebx
8010497a:	74 54                	je     801049d0 <create+0xa0>
    iunlockput(dp);
8010497c:	83 ec 0c             	sub    $0xc,%esp
8010497f:	57                   	push   %edi
80104980:	e8 7b cf ff ff       	call   80101900 <iunlockput>
    ilock(ip);
80104985:	89 1c 24             	mov    %ebx,(%esp)
80104988:	e8 e3 cc ff ff       	call   80101670 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010498d:	83 c4 10             	add    $0x10,%esp
80104990:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104995:	75 19                	jne    801049b0 <create+0x80>
80104997:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010499c:	89 d8                	mov    %ebx,%eax
8010499e:	75 10                	jne    801049b0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049a3:	5b                   	pop    %ebx
801049a4:	5e                   	pop    %esi
801049a5:	5f                   	pop    %edi
801049a6:	5d                   	pop    %ebp
801049a7:	c3                   	ret    
801049a8:	90                   	nop
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801049b0:	83 ec 0c             	sub    $0xc,%esp
801049b3:	53                   	push   %ebx
801049b4:	e8 47 cf ff ff       	call   80101900 <iunlockput>
    return 0;
801049b9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801049bf:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049c1:	5b                   	pop    %ebx
801049c2:	5e                   	pop    %esi
801049c3:	5f                   	pop    %edi
801049c4:	5d                   	pop    %ebp
801049c5:	c3                   	ret    
801049c6:	8d 76 00             	lea    0x0(%esi),%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801049d0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801049d4:	83 ec 08             	sub    $0x8,%esp
801049d7:	50                   	push   %eax
801049d8:	ff 37                	pushl  (%edi)
801049da:	e8 21 cb ff ff       	call   80101500 <ialloc>
801049df:	83 c4 10             	add    $0x10,%esp
801049e2:	85 c0                	test   %eax,%eax
801049e4:	89 c3                	mov    %eax,%ebx
801049e6:	0f 84 cc 00 00 00    	je     80104ab8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
801049ec:	83 ec 0c             	sub    $0xc,%esp
801049ef:	50                   	push   %eax
801049f0:	e8 7b cc ff ff       	call   80101670 <ilock>
  ip->major = major;
801049f5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049f9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801049fd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104a01:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104a05:	b8 01 00 00 00       	mov    $0x1,%eax
80104a0a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104a0e:	89 1c 24             	mov    %ebx,(%esp)
80104a11:	e8 aa cb ff ff       	call   801015c0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104a16:	83 c4 10             	add    $0x10,%esp
80104a19:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104a1e:	74 40                	je     80104a60 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104a20:	83 ec 04             	sub    $0x4,%esp
80104a23:	ff 73 04             	pushl  0x4(%ebx)
80104a26:	56                   	push   %esi
80104a27:	57                   	push   %edi
80104a28:	e8 d3 d3 ff ff       	call   80101e00 <dirlink>
80104a2d:	83 c4 10             	add    $0x10,%esp
80104a30:	85 c0                	test   %eax,%eax
80104a32:	78 77                	js     80104aab <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104a34:	83 ec 0c             	sub    $0xc,%esp
80104a37:	57                   	push   %edi
80104a38:	e8 c3 ce ff ff       	call   80101900 <iunlockput>

  return ip;
80104a3d:	83 c4 10             	add    $0x10,%esp
}
80104a40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104a43:	89 d8                	mov    %ebx,%eax
}
80104a45:	5b                   	pop    %ebx
80104a46:	5e                   	pop    %esi
80104a47:	5f                   	pop    %edi
80104a48:	5d                   	pop    %ebp
80104a49:	c3                   	ret    
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104a50:	31 c0                	xor    %eax,%eax
80104a52:	e9 49 ff ff ff       	jmp    801049a0 <create+0x70>
80104a57:	89 f6                	mov    %esi,%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a60:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104a65:	83 ec 0c             	sub    $0xc,%esp
80104a68:	57                   	push   %edi
80104a69:	e8 52 cb ff ff       	call   801015c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a6e:	83 c4 0c             	add    $0xc,%esp
80104a71:	ff 73 04             	pushl  0x4(%ebx)
80104a74:	68 e8 81 10 80       	push   $0x801081e8
80104a79:	53                   	push   %ebx
80104a7a:	e8 81 d3 ff ff       	call   80101e00 <dirlink>
80104a7f:	83 c4 10             	add    $0x10,%esp
80104a82:	85 c0                	test   %eax,%eax
80104a84:	78 18                	js     80104a9e <create+0x16e>
80104a86:	83 ec 04             	sub    $0x4,%esp
80104a89:	ff 77 04             	pushl  0x4(%edi)
80104a8c:	68 e7 81 10 80       	push   $0x801081e7
80104a91:	53                   	push   %ebx
80104a92:	e8 69 d3 ff ff       	call   80101e00 <dirlink>
80104a97:	83 c4 10             	add    $0x10,%esp
80104a9a:	85 c0                	test   %eax,%eax
80104a9c:	79 82                	jns    80104a20 <create+0xf0>
      panic("create dots");
80104a9e:	83 ec 0c             	sub    $0xc,%esp
80104aa1:	68 db 81 10 80       	push   $0x801081db
80104aa6:	e8 c5 b8 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104aab:	83 ec 0c             	sub    $0xc,%esp
80104aae:	68 ea 81 10 80       	push   $0x801081ea
80104ab3:	e8 b8 b8 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104ab8:	83 ec 0c             	sub    $0xc,%esp
80104abb:	68 cc 81 10 80       	push   $0x801081cc
80104ac0:	e8 ab b8 ff ff       	call   80100370 <panic>
80104ac5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104ad7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ada:	89 d3                	mov    %edx,%ebx
80104adc:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104adf:	50                   	push   %eax
80104ae0:	6a 00                	push   $0x0
80104ae2:	e8 f9 fc ff ff       	call   801047e0 <argint>
80104ae7:	83 c4 10             	add    $0x10,%esp
80104aea:	85 c0                	test   %eax,%eax
80104aec:	78 32                	js     80104b20 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104aee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104af2:	77 2c                	ja     80104b20 <argfd.constprop.0+0x50>
80104af4:	e8 07 ed ff ff       	call   80103800 <myproc>
80104af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104afc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104b00:	85 c0                	test   %eax,%eax
80104b02:	74 1c                	je     80104b20 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104b04:	85 f6                	test   %esi,%esi
80104b06:	74 02                	je     80104b0a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104b08:	89 16                	mov    %edx,(%esi)
  if(pf)
80104b0a:	85 db                	test   %ebx,%ebx
80104b0c:	74 22                	je     80104b30 <argfd.constprop.0+0x60>
    *pf = f;
80104b0e:	89 03                	mov    %eax,(%ebx)
  return 0;
80104b10:	31 c0                	xor    %eax,%eax
}
80104b12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b15:	5b                   	pop    %ebx
80104b16:	5e                   	pop    %esi
80104b17:	5d                   	pop    %ebp
80104b18:	c3                   	ret    
80104b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b20:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104b28:	5b                   	pop    %ebx
80104b29:	5e                   	pop    %esi
80104b2a:	5d                   	pop    %ebp
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104b30:	31 c0                	xor    %eax,%eax
80104b32:	eb de                	jmp    80104b12 <argfd.constprop.0+0x42>
80104b34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b40 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104b40:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b41:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104b43:	89 e5                	mov    %esp,%ebp
80104b45:	56                   	push   %esi
80104b46:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b47:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104b4a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b4d:	e8 7e ff ff ff       	call   80104ad0 <argfd.constprop.0>
80104b52:	85 c0                	test   %eax,%eax
80104b54:	78 1a                	js     80104b70 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104b56:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104b58:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104b5b:	e8 a0 ec ff ff       	call   80103800 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104b60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104b64:	85 d2                	test   %edx,%edx
80104b66:	74 18                	je     80104b80 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104b68:	83 c3 01             	add    $0x1,%ebx
80104b6b:	83 fb 10             	cmp    $0x10,%ebx
80104b6e:	75 f0                	jne    80104b60 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b70:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b78:	5b                   	pop    %ebx
80104b79:	5e                   	pop    %esi
80104b7a:	5d                   	pop    %ebp
80104b7b:	c3                   	ret    
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104b80:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b84:	83 ec 0c             	sub    $0xc,%esp
80104b87:	ff 75 f4             	pushl  -0xc(%ebp)
80104b8a:	e8 51 c2 ff ff       	call   80100de0 <filedup>
  return fd;
80104b8f:	83 c4 10             	add    $0x10,%esp
}
80104b92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104b95:	89 d8                	mov    %ebx,%eax
}
80104b97:	5b                   	pop    %ebx
80104b98:	5e                   	pop    %esi
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    
80104b9b:	90                   	nop
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ba0 <sys_read>:

int
sys_read(void)
{
80104ba0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ba1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104ba3:	89 e5                	mov    %esp,%ebp
80104ba5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ba8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bab:	e8 20 ff ff ff       	call   80104ad0 <argfd.constprop.0>
80104bb0:	85 c0                	test   %eax,%eax
80104bb2:	78 4c                	js     80104c00 <sys_read+0x60>
80104bb4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bb7:	83 ec 08             	sub    $0x8,%esp
80104bba:	50                   	push   %eax
80104bbb:	6a 02                	push   $0x2
80104bbd:	e8 1e fc ff ff       	call   801047e0 <argint>
80104bc2:	83 c4 10             	add    $0x10,%esp
80104bc5:	85 c0                	test   %eax,%eax
80104bc7:	78 37                	js     80104c00 <sys_read+0x60>
80104bc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bcc:	83 ec 04             	sub    $0x4,%esp
80104bcf:	ff 75 f0             	pushl  -0x10(%ebp)
80104bd2:	50                   	push   %eax
80104bd3:	6a 01                	push   $0x1
80104bd5:	e8 56 fc ff ff       	call   80104830 <argptr>
80104bda:	83 c4 10             	add    $0x10,%esp
80104bdd:	85 c0                	test   %eax,%eax
80104bdf:	78 1f                	js     80104c00 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104be1:	83 ec 04             	sub    $0x4,%esp
80104be4:	ff 75 f0             	pushl  -0x10(%ebp)
80104be7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bea:	ff 75 ec             	pushl  -0x14(%ebp)
80104bed:	e8 5e c3 ff ff       	call   80100f50 <fileread>
80104bf2:	83 c4 10             	add    $0x10,%esp
}
80104bf5:	c9                   	leave  
80104bf6:	c3                   	ret    
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104c05:	c9                   	leave  
80104c06:	c3                   	ret    
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <sys_write>:

int
sys_write(void)
{
80104c10:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c11:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104c13:	89 e5                	mov    %esp,%ebp
80104c15:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c1b:	e8 b0 fe ff ff       	call   80104ad0 <argfd.constprop.0>
80104c20:	85 c0                	test   %eax,%eax
80104c22:	78 4c                	js     80104c70 <sys_write+0x60>
80104c24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c27:	83 ec 08             	sub    $0x8,%esp
80104c2a:	50                   	push   %eax
80104c2b:	6a 02                	push   $0x2
80104c2d:	e8 ae fb ff ff       	call   801047e0 <argint>
80104c32:	83 c4 10             	add    $0x10,%esp
80104c35:	85 c0                	test   %eax,%eax
80104c37:	78 37                	js     80104c70 <sys_write+0x60>
80104c39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c3c:	83 ec 04             	sub    $0x4,%esp
80104c3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c42:	50                   	push   %eax
80104c43:	6a 01                	push   $0x1
80104c45:	e8 e6 fb ff ff       	call   80104830 <argptr>
80104c4a:	83 c4 10             	add    $0x10,%esp
80104c4d:	85 c0                	test   %eax,%eax
80104c4f:	78 1f                	js     80104c70 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104c51:	83 ec 04             	sub    $0x4,%esp
80104c54:	ff 75 f0             	pushl  -0x10(%ebp)
80104c57:	ff 75 f4             	pushl  -0xc(%ebp)
80104c5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c5d:	e8 7e c3 ff ff       	call   80100fe0 <filewrite>
80104c62:	83 c4 10             	add    $0x10,%esp
}
80104c65:	c9                   	leave  
80104c66:	c3                   	ret    
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c75:	c9                   	leave  
80104c76:	c3                   	ret    
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <sys_close>:

int
sys_close(void)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c86:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c8c:	e8 3f fe ff ff       	call   80104ad0 <argfd.constprop.0>
80104c91:	85 c0                	test   %eax,%eax
80104c93:	78 2b                	js     80104cc0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104c95:	e8 66 eb ff ff       	call   80103800 <myproc>
80104c9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104c9d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104ca0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ca7:	00 
  fileclose(f);
80104ca8:	ff 75 f4             	pushl  -0xc(%ebp)
80104cab:	e8 80 c1 ff ff       	call   80100e30 <fileclose>
  return 0;
80104cb0:	83 c4 10             	add    $0x10,%esp
80104cb3:	31 c0                	xor    %eax,%eax
}
80104cb5:	c9                   	leave  
80104cb6:	c3                   	ret    
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <sys_fstat>:

int
sys_fstat(void)
{
80104cd0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cd1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cd8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104cdb:	e8 f0 fd ff ff       	call   80104ad0 <argfd.constprop.0>
80104ce0:	85 c0                	test   %eax,%eax
80104ce2:	78 2c                	js     80104d10 <sys_fstat+0x40>
80104ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ce7:	83 ec 04             	sub    $0x4,%esp
80104cea:	6a 14                	push   $0x14
80104cec:	50                   	push   %eax
80104ced:	6a 01                	push   $0x1
80104cef:	e8 3c fb ff ff       	call   80104830 <argptr>
80104cf4:	83 c4 10             	add    $0x10,%esp
80104cf7:	85 c0                	test   %eax,%eax
80104cf9:	78 15                	js     80104d10 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104cfb:	83 ec 08             	sub    $0x8,%esp
80104cfe:	ff 75 f4             	pushl  -0xc(%ebp)
80104d01:	ff 75 f0             	pushl  -0x10(%ebp)
80104d04:	e8 f7 c1 ff ff       	call   80100f00 <filestat>
80104d09:	83 c4 10             	add    $0x10,%esp
}
80104d0c:	c9                   	leave  
80104d0d:	c3                   	ret    
80104d0e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104d15:	c9                   	leave  
80104d16:	c3                   	ret    
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	56                   	push   %esi
80104d25:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d26:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d29:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d2c:	50                   	push   %eax
80104d2d:	6a 00                	push   $0x0
80104d2f:	e8 5c fb ff ff       	call   80104890 <argstr>
80104d34:	83 c4 10             	add    $0x10,%esp
80104d37:	85 c0                	test   %eax,%eax
80104d39:	0f 88 fb 00 00 00    	js     80104e3a <sys_link+0x11a>
80104d3f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d42:	83 ec 08             	sub    $0x8,%esp
80104d45:	50                   	push   %eax
80104d46:	6a 01                	push   $0x1
80104d48:	e8 43 fb ff ff       	call   80104890 <argstr>
80104d4d:	83 c4 10             	add    $0x10,%esp
80104d50:	85 c0                	test   %eax,%eax
80104d52:	0f 88 e2 00 00 00    	js     80104e3a <sys_link+0x11a>
    return -1;

  begin_op();
80104d58:	e8 f3 dd ff ff       	call   80102b50 <begin_op>
  if((ip = namei(old)) == 0){
80104d5d:	83 ec 0c             	sub    $0xc,%esp
80104d60:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d63:	e8 58 d1 ff ff       	call   80101ec0 <namei>
80104d68:	83 c4 10             	add    $0x10,%esp
80104d6b:	85 c0                	test   %eax,%eax
80104d6d:	89 c3                	mov    %eax,%ebx
80104d6f:	0f 84 f3 00 00 00    	je     80104e68 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104d75:	83 ec 0c             	sub    $0xc,%esp
80104d78:	50                   	push   %eax
80104d79:	e8 f2 c8 ff ff       	call   80101670 <ilock>
  if(ip->type == T_DIR){
80104d7e:	83 c4 10             	add    $0x10,%esp
80104d81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d86:	0f 84 c4 00 00 00    	je     80104e50 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d8c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d91:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d94:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d97:	53                   	push   %ebx
80104d98:	e8 23 c8 ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
80104d9d:	89 1c 24             	mov    %ebx,(%esp)
80104da0:	e8 ab c9 ff ff       	call   80101750 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104da5:	58                   	pop    %eax
80104da6:	5a                   	pop    %edx
80104da7:	57                   	push   %edi
80104da8:	ff 75 d0             	pushl  -0x30(%ebp)
80104dab:	e8 30 d1 ff ff       	call   80101ee0 <nameiparent>
80104db0:	83 c4 10             	add    $0x10,%esp
80104db3:	85 c0                	test   %eax,%eax
80104db5:	89 c6                	mov    %eax,%esi
80104db7:	74 5b                	je     80104e14 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104db9:	83 ec 0c             	sub    $0xc,%esp
80104dbc:	50                   	push   %eax
80104dbd:	e8 ae c8 ff ff       	call   80101670 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104dc2:	83 c4 10             	add    $0x10,%esp
80104dc5:	8b 03                	mov    (%ebx),%eax
80104dc7:	39 06                	cmp    %eax,(%esi)
80104dc9:	75 3d                	jne    80104e08 <sys_link+0xe8>
80104dcb:	83 ec 04             	sub    $0x4,%esp
80104dce:	ff 73 04             	pushl  0x4(%ebx)
80104dd1:	57                   	push   %edi
80104dd2:	56                   	push   %esi
80104dd3:	e8 28 d0 ff ff       	call   80101e00 <dirlink>
80104dd8:	83 c4 10             	add    $0x10,%esp
80104ddb:	85 c0                	test   %eax,%eax
80104ddd:	78 29                	js     80104e08 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104ddf:	83 ec 0c             	sub    $0xc,%esp
80104de2:	56                   	push   %esi
80104de3:	e8 18 cb ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104de8:	89 1c 24             	mov    %ebx,(%esp)
80104deb:	e8 b0 c9 ff ff       	call   801017a0 <iput>

  end_op();
80104df0:	e8 cb dd ff ff       	call   80102bc0 <end_op>

  return 0;
80104df5:	83 c4 10             	add    $0x10,%esp
80104df8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dfd:	5b                   	pop    %ebx
80104dfe:	5e                   	pop    %esi
80104dff:	5f                   	pop    %edi
80104e00:	5d                   	pop    %ebp
80104e01:	c3                   	ret    
80104e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104e08:	83 ec 0c             	sub    $0xc,%esp
80104e0b:	56                   	push   %esi
80104e0c:	e8 ef ca ff ff       	call   80101900 <iunlockput>
    goto bad;
80104e11:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104e14:	83 ec 0c             	sub    $0xc,%esp
80104e17:	53                   	push   %ebx
80104e18:	e8 53 c8 ff ff       	call   80101670 <ilock>
  ip->nlink--;
80104e1d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e22:	89 1c 24             	mov    %ebx,(%esp)
80104e25:	e8 96 c7 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104e2a:	89 1c 24             	mov    %ebx,(%esp)
80104e2d:	e8 ce ca ff ff       	call   80101900 <iunlockput>
  end_op();
80104e32:	e8 89 dd ff ff       	call   80102bc0 <end_op>
  return -1;
80104e37:	83 c4 10             	add    $0x10,%esp
}
80104e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104e3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e42:	5b                   	pop    %ebx
80104e43:	5e                   	pop    %esi
80104e44:	5f                   	pop    %edi
80104e45:	5d                   	pop    %ebp
80104e46:	c3                   	ret    
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104e50:	83 ec 0c             	sub    $0xc,%esp
80104e53:	53                   	push   %ebx
80104e54:	e8 a7 ca ff ff       	call   80101900 <iunlockput>
    end_op();
80104e59:	e8 62 dd ff ff       	call   80102bc0 <end_op>
    return -1;
80104e5e:	83 c4 10             	add    $0x10,%esp
80104e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e66:	eb 92                	jmp    80104dfa <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104e68:	e8 53 dd ff ff       	call   80102bc0 <end_op>
    return -1;
80104e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e72:	eb 86                	jmp    80104dfa <sys_link+0xda>
80104e74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e80 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e86:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e89:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e8c:	50                   	push   %eax
80104e8d:	6a 00                	push   $0x0
80104e8f:	e8 fc f9 ff ff       	call   80104890 <argstr>
80104e94:	83 c4 10             	add    $0x10,%esp
80104e97:	85 c0                	test   %eax,%eax
80104e99:	0f 88 82 01 00 00    	js     80105021 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104e9f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104ea2:	e8 a9 dc ff ff       	call   80102b50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ea7:	83 ec 08             	sub    $0x8,%esp
80104eaa:	53                   	push   %ebx
80104eab:	ff 75 c0             	pushl  -0x40(%ebp)
80104eae:	e8 2d d0 ff ff       	call   80101ee0 <nameiparent>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104ebb:	0f 84 6a 01 00 00    	je     8010502b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104ec1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	56                   	push   %esi
80104ec8:	e8 a3 c7 ff ff       	call   80101670 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ecd:	58                   	pop    %eax
80104ece:	5a                   	pop    %edx
80104ecf:	68 e8 81 10 80       	push   $0x801081e8
80104ed4:	53                   	push   %ebx
80104ed5:	e8 a6 cc ff ff       	call   80101b80 <namecmp>
80104eda:	83 c4 10             	add    $0x10,%esp
80104edd:	85 c0                	test   %eax,%eax
80104edf:	0f 84 fc 00 00 00    	je     80104fe1 <sys_unlink+0x161>
80104ee5:	83 ec 08             	sub    $0x8,%esp
80104ee8:	68 e7 81 10 80       	push   $0x801081e7
80104eed:	53                   	push   %ebx
80104eee:	e8 8d cc ff ff       	call   80101b80 <namecmp>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	0f 84 e3 00 00 00    	je     80104fe1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104efe:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f01:	83 ec 04             	sub    $0x4,%esp
80104f04:	50                   	push   %eax
80104f05:	53                   	push   %ebx
80104f06:	56                   	push   %esi
80104f07:	e8 94 cc ff ff       	call   80101ba0 <dirlookup>
80104f0c:	83 c4 10             	add    $0x10,%esp
80104f0f:	85 c0                	test   %eax,%eax
80104f11:	89 c3                	mov    %eax,%ebx
80104f13:	0f 84 c8 00 00 00    	je     80104fe1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104f19:	83 ec 0c             	sub    $0xc,%esp
80104f1c:	50                   	push   %eax
80104f1d:	e8 4e c7 ff ff       	call   80101670 <ilock>

  if(ip->nlink < 1)
80104f22:	83 c4 10             	add    $0x10,%esp
80104f25:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f2a:	0f 8e 24 01 00 00    	jle    80105054 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f30:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f35:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104f38:	74 66                	je     80104fa0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104f3a:	83 ec 04             	sub    $0x4,%esp
80104f3d:	6a 10                	push   $0x10
80104f3f:	6a 00                	push   $0x0
80104f41:	56                   	push   %esi
80104f42:	e8 89 f5 ff ff       	call   801044d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f47:	6a 10                	push   $0x10
80104f49:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f4c:	56                   	push   %esi
80104f4d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f50:	e8 fb ca ff ff       	call   80101a50 <writei>
80104f55:	83 c4 20             	add    $0x20,%esp
80104f58:	83 f8 10             	cmp    $0x10,%eax
80104f5b:	0f 85 e6 00 00 00    	jne    80105047 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104f61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f66:	0f 84 9c 00 00 00    	je     80105008 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104f6c:	83 ec 0c             	sub    $0xc,%esp
80104f6f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f72:	e8 89 c9 ff ff       	call   80101900 <iunlockput>

  ip->nlink--;
80104f77:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f7c:	89 1c 24             	mov    %ebx,(%esp)
80104f7f:	e8 3c c6 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104f84:	89 1c 24             	mov    %ebx,(%esp)
80104f87:	e8 74 c9 ff ff       	call   80101900 <iunlockput>

  end_op();
80104f8c:	e8 2f dc ff ff       	call   80102bc0 <end_op>

  return 0;
80104f91:	83 c4 10             	add    $0x10,%esp
80104f94:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f99:	5b                   	pop    %ebx
80104f9a:	5e                   	pop    %esi
80104f9b:	5f                   	pop    %edi
80104f9c:	5d                   	pop    %ebp
80104f9d:	c3                   	ret    
80104f9e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104fa0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104fa4:	76 94                	jbe    80104f3a <sys_unlink+0xba>
80104fa6:	bf 20 00 00 00       	mov    $0x20,%edi
80104fab:	eb 0f                	jmp    80104fbc <sys_unlink+0x13c>
80104fad:	8d 76 00             	lea    0x0(%esi),%esi
80104fb0:	83 c7 10             	add    $0x10,%edi
80104fb3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104fb6:	0f 83 7e ff ff ff    	jae    80104f3a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fbc:	6a 10                	push   $0x10
80104fbe:	57                   	push   %edi
80104fbf:	56                   	push   %esi
80104fc0:	53                   	push   %ebx
80104fc1:	e8 8a c9 ff ff       	call   80101950 <readi>
80104fc6:	83 c4 10             	add    $0x10,%esp
80104fc9:	83 f8 10             	cmp    $0x10,%eax
80104fcc:	75 6c                	jne    8010503a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104fce:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104fd3:	74 db                	je     80104fb0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104fd5:	83 ec 0c             	sub    $0xc,%esp
80104fd8:	53                   	push   %ebx
80104fd9:	e8 22 c9 ff ff       	call   80101900 <iunlockput>
    goto bad;
80104fde:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104fe1:	83 ec 0c             	sub    $0xc,%esp
80104fe4:	ff 75 b4             	pushl  -0x4c(%ebp)
80104fe7:	e8 14 c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104fec:	e8 cf db ff ff       	call   80102bc0 <end_op>
  return -1;
80104ff1:	83 c4 10             	add    $0x10,%esp
}
80104ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104ff7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ffc:	5b                   	pop    %ebx
80104ffd:	5e                   	pop    %esi
80104ffe:	5f                   	pop    %edi
80104fff:	5d                   	pop    %ebp
80105000:	c3                   	ret    
80105001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105008:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010500b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010500e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105013:	50                   	push   %eax
80105014:	e8 a7 c5 ff ff       	call   801015c0 <iupdate>
80105019:	83 c4 10             	add    $0x10,%esp
8010501c:	e9 4b ff ff ff       	jmp    80104f6c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105026:	e9 6b ff ff ff       	jmp    80104f96 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010502b:	e8 90 db ff ff       	call   80102bc0 <end_op>
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105035:	e9 5c ff ff ff       	jmp    80104f96 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010503a:	83 ec 0c             	sub    $0xc,%esp
8010503d:	68 0c 82 10 80       	push   $0x8010820c
80105042:	e8 29 b3 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105047:	83 ec 0c             	sub    $0xc,%esp
8010504a:	68 1e 82 10 80       	push   $0x8010821e
8010504f:	e8 1c b3 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105054:	83 ec 0c             	sub    $0xc,%esp
80105057:	68 fa 81 10 80       	push   $0x801081fa
8010505c:	e8 0f b3 ff ff       	call   80100370 <panic>
80105061:	eb 0d                	jmp    80105070 <sys_open>
80105063:	90                   	nop
80105064:	90                   	nop
80105065:	90                   	nop
80105066:	90                   	nop
80105067:	90                   	nop
80105068:	90                   	nop
80105069:	90                   	nop
8010506a:	90                   	nop
8010506b:	90                   	nop
8010506c:	90                   	nop
8010506d:	90                   	nop
8010506e:	90                   	nop
8010506f:	90                   	nop

80105070 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105076:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105079:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010507c:	50                   	push   %eax
8010507d:	6a 00                	push   $0x0
8010507f:	e8 0c f8 ff ff       	call   80104890 <argstr>
80105084:	83 c4 10             	add    $0x10,%esp
80105087:	85 c0                	test   %eax,%eax
80105089:	0f 88 9e 00 00 00    	js     8010512d <sys_open+0xbd>
8010508f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105092:	83 ec 08             	sub    $0x8,%esp
80105095:	50                   	push   %eax
80105096:	6a 01                	push   $0x1
80105098:	e8 43 f7 ff ff       	call   801047e0 <argint>
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	85 c0                	test   %eax,%eax
801050a2:	0f 88 85 00 00 00    	js     8010512d <sys_open+0xbd>
    return -1;

  begin_op();
801050a8:	e8 a3 da ff ff       	call   80102b50 <begin_op>

  if(omode & O_CREATE){
801050ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801050b1:	0f 85 89 00 00 00    	jne    80105140 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801050b7:	83 ec 0c             	sub    $0xc,%esp
801050ba:	ff 75 e0             	pushl  -0x20(%ebp)
801050bd:	e8 fe cd ff ff       	call   80101ec0 <namei>
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	85 c0                	test   %eax,%eax
801050c7:	89 c6                	mov    %eax,%esi
801050c9:	0f 84 8e 00 00 00    	je     8010515d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801050cf:	83 ec 0c             	sub    $0xc,%esp
801050d2:	50                   	push   %eax
801050d3:	e8 98 c5 ff ff       	call   80101670 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801050d8:	83 c4 10             	add    $0x10,%esp
801050db:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801050e0:	0f 84 d2 00 00 00    	je     801051b8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801050e6:	e8 85 bc ff ff       	call   80100d70 <filealloc>
801050eb:	85 c0                	test   %eax,%eax
801050ed:	89 c7                	mov    %eax,%edi
801050ef:	74 2b                	je     8010511c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801050f1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801050f3:	e8 08 e7 ff ff       	call   80103800 <myproc>
801050f8:	90                   	nop
801050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105100:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105104:	85 d2                	test   %edx,%edx
80105106:	74 68                	je     80105170 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105108:	83 c3 01             	add    $0x1,%ebx
8010510b:	83 fb 10             	cmp    $0x10,%ebx
8010510e:	75 f0                	jne    80105100 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105110:	83 ec 0c             	sub    $0xc,%esp
80105113:	57                   	push   %edi
80105114:	e8 17 bd ff ff       	call   80100e30 <fileclose>
80105119:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010511c:	83 ec 0c             	sub    $0xc,%esp
8010511f:	56                   	push   %esi
80105120:	e8 db c7 ff ff       	call   80101900 <iunlockput>
    end_op();
80105125:	e8 96 da ff ff       	call   80102bc0 <end_op>
    return -1;
8010512a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010512d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105135:	5b                   	pop    %ebx
80105136:	5e                   	pop    %esi
80105137:	5f                   	pop    %edi
80105138:	5d                   	pop    %ebp
80105139:	c3                   	ret    
8010513a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105140:	83 ec 0c             	sub    $0xc,%esp
80105143:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105146:	31 c9                	xor    %ecx,%ecx
80105148:	6a 00                	push   $0x0
8010514a:	ba 02 00 00 00       	mov    $0x2,%edx
8010514f:	e8 dc f7 ff ff       	call   80104930 <create>
    if(ip == 0){
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105159:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010515b:	75 89                	jne    801050e6 <sys_open+0x76>
      end_op();
8010515d:	e8 5e da ff ff       	call   80102bc0 <end_op>
      return -1;
80105162:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105167:	eb 43                	jmp    801051ac <sys_open+0x13c>
80105169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105170:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105173:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105177:	56                   	push   %esi
80105178:	e8 d3 c5 ff ff       	call   80101750 <iunlock>
  end_op();
8010517d:	e8 3e da ff ff       	call   80102bc0 <end_op>

  f->type = FD_INODE;
80105182:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105188:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010518b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010518e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105191:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105198:	89 d0                	mov    %edx,%eax
8010519a:	83 e0 01             	and    $0x1,%eax
8010519d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051a0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051a3:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051a6:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
801051aa:	89 d8                	mov    %ebx,%eax
}
801051ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051af:	5b                   	pop    %ebx
801051b0:	5e                   	pop    %esi
801051b1:	5f                   	pop    %edi
801051b2:	5d                   	pop    %ebp
801051b3:	c3                   	ret    
801051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801051b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801051bb:	85 c9                	test   %ecx,%ecx
801051bd:	0f 84 23 ff ff ff    	je     801050e6 <sys_open+0x76>
801051c3:	e9 54 ff ff ff       	jmp    8010511c <sys_open+0xac>
801051c8:	90                   	nop
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051d0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801051d6:	e8 75 d9 ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801051db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051de:	83 ec 08             	sub    $0x8,%esp
801051e1:	50                   	push   %eax
801051e2:	6a 00                	push   $0x0
801051e4:	e8 a7 f6 ff ff       	call   80104890 <argstr>
801051e9:	83 c4 10             	add    $0x10,%esp
801051ec:	85 c0                	test   %eax,%eax
801051ee:	78 30                	js     80105220 <sys_mkdir+0x50>
801051f0:	83 ec 0c             	sub    $0xc,%esp
801051f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f6:	31 c9                	xor    %ecx,%ecx
801051f8:	6a 00                	push   $0x0
801051fa:	ba 01 00 00 00       	mov    $0x1,%edx
801051ff:	e8 2c f7 ff ff       	call   80104930 <create>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
80105209:	74 15                	je     80105220 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010520b:	83 ec 0c             	sub    $0xc,%esp
8010520e:	50                   	push   %eax
8010520f:	e8 ec c6 ff ff       	call   80101900 <iunlockput>
  end_op();
80105214:	e8 a7 d9 ff ff       	call   80102bc0 <end_op>
  return 0;
80105219:	83 c4 10             	add    $0x10,%esp
8010521c:	31 c0                	xor    %eax,%eax
}
8010521e:	c9                   	leave  
8010521f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105220:	e8 9b d9 ff ff       	call   80102bc0 <end_op>
    return -1;
80105225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010522a:	c9                   	leave  
8010522b:	c3                   	ret    
8010522c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105230 <sys_mknod>:

int
sys_mknod(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105236:	e8 15 d9 ff ff       	call   80102b50 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010523b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010523e:	83 ec 08             	sub    $0x8,%esp
80105241:	50                   	push   %eax
80105242:	6a 00                	push   $0x0
80105244:	e8 47 f6 ff ff       	call   80104890 <argstr>
80105249:	83 c4 10             	add    $0x10,%esp
8010524c:	85 c0                	test   %eax,%eax
8010524e:	78 60                	js     801052b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105250:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105253:	83 ec 08             	sub    $0x8,%esp
80105256:	50                   	push   %eax
80105257:	6a 01                	push   $0x1
80105259:	e8 82 f5 ff ff       	call   801047e0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	85 c0                	test   %eax,%eax
80105263:	78 4b                	js     801052b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105265:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105268:	83 ec 08             	sub    $0x8,%esp
8010526b:	50                   	push   %eax
8010526c:	6a 02                	push   $0x2
8010526e:	e8 6d f5 ff ff       	call   801047e0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	78 36                	js     801052b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010527a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010527e:	83 ec 0c             	sub    $0xc,%esp
80105281:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105285:	ba 03 00 00 00       	mov    $0x3,%edx
8010528a:	50                   	push   %eax
8010528b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010528e:	e8 9d f6 ff ff       	call   80104930 <create>
80105293:	83 c4 10             	add    $0x10,%esp
80105296:	85 c0                	test   %eax,%eax
80105298:	74 16                	je     801052b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010529a:	83 ec 0c             	sub    $0xc,%esp
8010529d:	50                   	push   %eax
8010529e:	e8 5d c6 ff ff       	call   80101900 <iunlockput>
  end_op();
801052a3:	e8 18 d9 ff ff       	call   80102bc0 <end_op>
  return 0;
801052a8:	83 c4 10             	add    $0x10,%esp
801052ab:	31 c0                	xor    %eax,%eax
}
801052ad:	c9                   	leave  
801052ae:	c3                   	ret    
801052af:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801052b0:	e8 0b d9 ff ff       	call   80102bc0 <end_op>
    return -1;
801052b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801052ba:	c9                   	leave  
801052bb:	c3                   	ret    
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_chdir>:

int
sys_chdir(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	53                   	push   %ebx
801052c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801052c8:	e8 33 e5 ff ff       	call   80103800 <myproc>
801052cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801052cf:	e8 7c d8 ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801052d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052d7:	83 ec 08             	sub    $0x8,%esp
801052da:	50                   	push   %eax
801052db:	6a 00                	push   $0x0
801052dd:	e8 ae f5 ff ff       	call   80104890 <argstr>
801052e2:	83 c4 10             	add    $0x10,%esp
801052e5:	85 c0                	test   %eax,%eax
801052e7:	78 77                	js     80105360 <sys_chdir+0xa0>
801052e9:	83 ec 0c             	sub    $0xc,%esp
801052ec:	ff 75 f4             	pushl  -0xc(%ebp)
801052ef:	e8 cc cb ff ff       	call   80101ec0 <namei>
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
801052f9:	89 c3                	mov    %eax,%ebx
801052fb:	74 63                	je     80105360 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801052fd:	83 ec 0c             	sub    $0xc,%esp
80105300:	50                   	push   %eax
80105301:	e8 6a c3 ff ff       	call   80101670 <ilock>
  if(ip->type != T_DIR){
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010530e:	75 30                	jne    80105340 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105310:	83 ec 0c             	sub    $0xc,%esp
80105313:	53                   	push   %ebx
80105314:	e8 37 c4 ff ff       	call   80101750 <iunlock>
  iput(curproc->cwd);
80105319:	58                   	pop    %eax
8010531a:	ff 76 68             	pushl  0x68(%esi)
8010531d:	e8 7e c4 ff ff       	call   801017a0 <iput>
  end_op();
80105322:	e8 99 d8 ff ff       	call   80102bc0 <end_op>
  curproc->cwd = ip;
80105327:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010532a:	83 c4 10             	add    $0x10,%esp
8010532d:	31 c0                	xor    %eax,%eax
}
8010532f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105332:	5b                   	pop    %ebx
80105333:	5e                   	pop    %esi
80105334:	5d                   	pop    %ebp
80105335:	c3                   	ret    
80105336:	8d 76 00             	lea    0x0(%esi),%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	53                   	push   %ebx
80105344:	e8 b7 c5 ff ff       	call   80101900 <iunlockput>
    end_op();
80105349:	e8 72 d8 ff ff       	call   80102bc0 <end_op>
    return -1;
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105356:	eb d7                	jmp    8010532f <sys_chdir+0x6f>
80105358:	90                   	nop
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105360:	e8 5b d8 ff ff       	call   80102bc0 <end_op>
    return -1;
80105365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536a:	eb c3                	jmp    8010532f <sys_chdir+0x6f>
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	56                   	push   %esi
80105375:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105376:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010537c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105382:	50                   	push   %eax
80105383:	6a 00                	push   $0x0
80105385:	e8 06 f5 ff ff       	call   80104890 <argstr>
8010538a:	83 c4 10             	add    $0x10,%esp
8010538d:	85 c0                	test   %eax,%eax
8010538f:	78 7f                	js     80105410 <sys_exec+0xa0>
80105391:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105397:	83 ec 08             	sub    $0x8,%esp
8010539a:	50                   	push   %eax
8010539b:	6a 01                	push   $0x1
8010539d:	e8 3e f4 ff ff       	call   801047e0 <argint>
801053a2:	83 c4 10             	add    $0x10,%esp
801053a5:	85 c0                	test   %eax,%eax
801053a7:	78 67                	js     80105410 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053a9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053af:	83 ec 04             	sub    $0x4,%esp
801053b2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801053b8:	68 80 00 00 00       	push   $0x80
801053bd:	6a 00                	push   $0x0
801053bf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053c5:	50                   	push   %eax
801053c6:	31 db                	xor    %ebx,%ebx
801053c8:	e8 03 f1 ff ff       	call   801044d0 <memset>
801053cd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053d0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053d6:	83 ec 08             	sub    $0x8,%esp
801053d9:	57                   	push   %edi
801053da:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801053dd:	50                   	push   %eax
801053de:	e8 5d f3 ff ff       	call   80104740 <fetchint>
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	78 26                	js     80105410 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801053ea:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801053f0:	85 c0                	test   %eax,%eax
801053f2:	74 2c                	je     80105420 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801053f4:	83 ec 08             	sub    $0x8,%esp
801053f7:	56                   	push   %esi
801053f8:	50                   	push   %eax
801053f9:	e8 82 f3 ff ff       	call   80104780 <fetchstr>
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	85 c0                	test   %eax,%eax
80105403:	78 0b                	js     80105410 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105405:	83 c3 01             	add    $0x1,%ebx
80105408:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010540b:	83 fb 20             	cmp    $0x20,%ebx
8010540e:	75 c0                	jne    801053d0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105410:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105418:	5b                   	pop    %ebx
80105419:	5e                   	pop    %esi
8010541a:	5f                   	pop    %edi
8010541b:	5d                   	pop    %ebp
8010541c:	c3                   	ret    
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105420:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105426:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105429:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105430:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105434:	50                   	push   %eax
80105435:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010543b:	e8 b0 b5 ff ff       	call   801009f0 <exec>
80105440:	83 c4 10             	add    $0x10,%esp
}
80105443:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105446:	5b                   	pop    %ebx
80105447:	5e                   	pop    %esi
80105448:	5f                   	pop    %edi
80105449:	5d                   	pop    %ebp
8010544a:	c3                   	ret    
8010544b:	90                   	nop
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105450 <sys_pipe>:

int
sys_pipe(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105456:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105459:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010545c:	6a 08                	push   $0x8
8010545e:	50                   	push   %eax
8010545f:	6a 00                	push   $0x0
80105461:	e8 ca f3 ff ff       	call   80104830 <argptr>
80105466:	83 c4 10             	add    $0x10,%esp
80105469:	85 c0                	test   %eax,%eax
8010546b:	78 4a                	js     801054b7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010546d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105470:	83 ec 08             	sub    $0x8,%esp
80105473:	50                   	push   %eax
80105474:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105477:	50                   	push   %eax
80105478:	e8 83 dd ff ff       	call   80103200 <pipealloc>
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	85 c0                	test   %eax,%eax
80105482:	78 33                	js     801054b7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105484:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105486:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105489:	e8 72 e3 ff ff       	call   80103800 <myproc>
8010548e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105490:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105494:	85 f6                	test   %esi,%esi
80105496:	74 30                	je     801054c8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105498:	83 c3 01             	add    $0x1,%ebx
8010549b:	83 fb 10             	cmp    $0x10,%ebx
8010549e:	75 f0                	jne    80105490 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	ff 75 e0             	pushl  -0x20(%ebp)
801054a6:	e8 85 b9 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
801054ab:	58                   	pop    %eax
801054ac:	ff 75 e4             	pushl  -0x1c(%ebp)
801054af:	e8 7c b9 ff ff       	call   80100e30 <fileclose>
    return -1;
801054b4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801054b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801054ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801054bf:	5b                   	pop    %ebx
801054c0:	5e                   	pop    %esi
801054c1:	5f                   	pop    %edi
801054c2:	5d                   	pop    %ebp
801054c3:	c3                   	ret    
801054c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801054c8:	8d 73 08             	lea    0x8(%ebx),%esi
801054cb:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801054d2:	e8 29 e3 ff ff       	call   80103800 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801054d7:	31 d2                	xor    %edx,%edx
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801054e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801054e4:	85 c9                	test   %ecx,%ecx
801054e6:	74 18                	je     80105500 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801054e8:	83 c2 01             	add    $0x1,%edx
801054eb:	83 fa 10             	cmp    $0x10,%edx
801054ee:	75 f0                	jne    801054e0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801054f0:	e8 0b e3 ff ff       	call   80103800 <myproc>
801054f5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801054fc:	00 
801054fd:	eb a1                	jmp    801054a0 <sys_pipe+0x50>
801054ff:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105500:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105504:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105507:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105509:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010550c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010550f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105512:	31 c0                	xor    %eax,%eax
}
80105514:	5b                   	pop    %ebx
80105515:	5e                   	pop    %esi
80105516:	5f                   	pop    %edi
80105517:	5d                   	pop    %ebp
80105518:	c3                   	ret    
80105519:	66 90                	xchg   %ax,%ax
8010551b:	66 90                	xchg   %ax,%ax
8010551d:	66 90                	xchg   %ax,%ax
8010551f:	90                   	nop

80105520 <sys_fork>:
#include "proc.h"
#include "semaphores.h"

int
sys_fork(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105523:	5d                   	pop    %ebp
#include "semaphores.h"

int
sys_fork(void)
{
  return fork();
80105524:	e9 77 e4 ff ff       	jmp    801039a0 <fork>
80105529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_exit>:
}

int
sys_exit(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	83 ec 08             	sub    $0x8,%esp
  exit();
80105536:	e8 15 e7 ff ff       	call   80103c50 <exit>
  return 0;  // not reached
}
8010553b:	31 c0                	xor    %eax,%eax
8010553d:	c9                   	leave  
8010553e:	c3                   	ret    
8010553f:	90                   	nop

80105540 <sys_wait>:

int
sys_wait(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105543:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105544:	e9 57 e9 ff ff       	jmp    80103ea0 <wait>
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105550 <sys_kill>:
}

int
sys_kill(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105556:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105559:	50                   	push   %eax
8010555a:	6a 00                	push   $0x0
8010555c:	e8 7f f2 ff ff       	call   801047e0 <argint>
80105561:	83 c4 10             	add    $0x10,%esp
80105564:	85 c0                	test   %eax,%eax
80105566:	78 18                	js     80105580 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105568:	83 ec 0c             	sub    $0xc,%esp
8010556b:	ff 75 f4             	pushl  -0xc(%ebp)
8010556e:	e8 8d ea ff ff       	call   80104000 <kill>
80105573:	83 c4 10             	add    $0x10,%esp
}
80105576:	c9                   	leave  
80105577:	c3                   	ret    
80105578:	90                   	nop
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105585:	c9                   	leave  
80105586:	c3                   	ret    
80105587:	89 f6                	mov    %esi,%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105590 <sys_getpid>:

int
sys_getpid(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105596:	e8 65 e2 ff ff       	call   80103800 <myproc>
8010559b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010559e:	c9                   	leave  
8010559f:	c3                   	ret    

801055a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801055a7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055aa:	50                   	push   %eax
801055ab:	6a 00                	push   $0x0
801055ad:	e8 2e f2 ff ff       	call   801047e0 <argint>
801055b2:	83 c4 10             	add    $0x10,%esp
801055b5:	85 c0                	test   %eax,%eax
801055b7:	78 27                	js     801055e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801055b9:	e8 42 e2 ff ff       	call   80103800 <myproc>
  if(growproc(n) < 0)
801055be:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801055c1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801055c3:	ff 75 f4             	pushl  -0xc(%ebp)
801055c6:	e8 55 e3 ff ff       	call   80103920 <growproc>
801055cb:	83 c4 10             	add    $0x10,%esp
801055ce:	85 c0                	test   %eax,%eax
801055d0:	78 0e                	js     801055e0 <sys_sbrk+0x40>
    return -1;
  return addr;
801055d2:	89 d8                	mov    %ebx,%eax
}
801055d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055d7:	c9                   	leave  
801055d8:	c3                   	ret    
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801055e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e5:	eb ed                	jmp    801055d4 <sys_sbrk+0x34>
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801055f7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055fa:	50                   	push   %eax
801055fb:	6a 00                	push   $0x0
801055fd:	e8 de f1 ff ff       	call   801047e0 <argint>
80105602:	83 c4 10             	add    $0x10,%esp
80105605:	85 c0                	test   %eax,%eax
80105607:	0f 88 8a 00 00 00    	js     80105697 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010560d:	83 ec 0c             	sub    $0xc,%esp
80105610:	68 60 25 12 80       	push   $0x80122560
80105615:	e8 46 ed ff ff       	call   80104360 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010561a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010561d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105620:	8b 1d a0 2d 12 80    	mov    0x80122da0,%ebx
  while(ticks - ticks0 < n){
80105626:	85 d2                	test   %edx,%edx
80105628:	75 27                	jne    80105651 <sys_sleep+0x61>
8010562a:	eb 54                	jmp    80105680 <sys_sleep+0x90>
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105630:	83 ec 08             	sub    $0x8,%esp
80105633:	68 60 25 12 80       	push   $0x80122560
80105638:	68 a0 2d 12 80       	push   $0x80122da0
8010563d:	e8 9e e7 ff ff       	call   80103de0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105642:	a1 a0 2d 12 80       	mov    0x80122da0,%eax
80105647:	83 c4 10             	add    $0x10,%esp
8010564a:	29 d8                	sub    %ebx,%eax
8010564c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010564f:	73 2f                	jae    80105680 <sys_sleep+0x90>
    if(myproc()->killed){
80105651:	e8 aa e1 ff ff       	call   80103800 <myproc>
80105656:	8b 40 24             	mov    0x24(%eax),%eax
80105659:	85 c0                	test   %eax,%eax
8010565b:	74 d3                	je     80105630 <sys_sleep+0x40>
      release(&tickslock);
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	68 60 25 12 80       	push   $0x80122560
80105665:	e8 16 ee ff ff       	call   80104480 <release>
      return -1;
8010566a:	83 c4 10             	add    $0x10,%esp
8010566d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105672:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105675:	c9                   	leave  
80105676:	c3                   	ret    
80105677:	89 f6                	mov    %esi,%esi
80105679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	68 60 25 12 80       	push   $0x80122560
80105688:	e8 f3 ed ff ff       	call   80104480 <release>
  return 0;
8010568d:	83 c4 10             	add    $0x10,%esp
80105690:	31 c0                	xor    %eax,%eax
}
80105692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105695:	c9                   	leave  
80105696:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569c:	eb d4                	jmp    80105672 <sys_sleep+0x82>
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	53                   	push   %ebx
801056a4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801056a7:	68 60 25 12 80       	push   $0x80122560
801056ac:	e8 af ec ff ff       	call   80104360 <acquire>
  xticks = ticks;
801056b1:	8b 1d a0 2d 12 80    	mov    0x80122da0,%ebx
  release(&tickslock);
801056b7:	c7 04 24 60 25 12 80 	movl   $0x80122560,(%esp)
801056be:	e8 bd ed ff ff       	call   80104480 <release>
  return xticks;
}
801056c3:	89 d8                	mov    %ebx,%eax
801056c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056c8:	c9                   	leave  
801056c9:	c3                   	ret    
801056ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056d0 <sys_shmget>:

int 
sys_shmget(void)  //mine
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 20             	sub    $0x20,%esp
  char *key; 
  int temp = argstr(0, &key);
801056d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d9:	50                   	push   %eax
801056da:	6a 00                	push   $0x0
801056dc:	e8 af f1 ff ff       	call   80104890 <argstr>
  if (temp <=0 || temp >16)
801056e1:	83 e8 01             	sub    $0x1,%eax
801056e4:	83 c4 10             	add    $0x10,%esp
801056e7:	83 f8 0f             	cmp    $0xf,%eax
801056ea:	77 14                	ja     80105700 <sys_shmget+0x30>
    return -1;
  return (int)shmget(key);
801056ec:	83 ec 0c             	sub    $0xc,%esp
801056ef:	ff 75 f4             	pushl  -0xc(%ebp)
801056f2:	e8 59 1a 00 00       	call   80107150 <shmget>
801056f7:	83 c4 10             	add    $0x10,%esp
}
801056fa:	c9                   	leave  
801056fb:	c3                   	ret    
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_shmget(void)  //mine
{
  char *key; 
  int temp = argstr(0, &key);
  if (temp <=0 || temp >16)
    return -1;
80105700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return (int)shmget(key);
}
80105705:	c9                   	leave  
80105706:	c3                   	ret    
80105707:	89 f6                	mov    %esi,%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105710 <sys_shmrem>:

int 
sys_shmrem(void)  //mine
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 20             	sub    $0x20,%esp
  char *key; 
  int temp = argstr(0, &key);
80105716:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105719:	50                   	push   %eax
8010571a:	6a 00                	push   $0x0
8010571c:	e8 6f f1 ff ff       	call   80104890 <argstr>
  if (temp <=0 || temp >16)
80105721:	83 e8 01             	sub    $0x1,%eax
80105724:	83 c4 10             	add    $0x10,%esp
80105727:	83 f8 0f             	cmp    $0xf,%eax
8010572a:	77 14                	ja     80105740 <sys_shmrem+0x30>
    return -1;
  return shmrem(key);
8010572c:	83 ec 0c             	sub    $0xc,%esp
8010572f:	ff 75 f4             	pushl  -0xc(%ebp)
80105732:	e8 b9 1d 00 00       	call   801074f0 <shmrem>
80105737:	83 c4 10             	add    $0x10,%esp
}
8010573a:	c9                   	leave  
8010573b:	c3                   	ret    
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_shmrem(void)  //mine
{
  char *key; 
  int temp = argstr(0, &key);
  if (temp <=0 || temp >16)
    return -1;
80105740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return shmrem(key);
}
80105745:	c9                   	leave  
80105746:	c3                   	ret    
80105747:	89 f6                	mov    %esi,%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105750 <sys_sem_init>:

int
sys_sem_init(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 1c             	sub    $0x1c,%esp
  sem_t *sem;
  int value;
  if (argptr(0, (char**)&sem, sizeof(sem)) < 0)
80105756:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105759:	6a 04                	push   $0x4
8010575b:	50                   	push   %eax
8010575c:	6a 00                	push   $0x0
8010575e:	e8 cd f0 ff ff       	call   80104830 <argptr>
80105763:	83 c4 10             	add    $0x10,%esp
80105766:	85 c0                	test   %eax,%eax
80105768:	78 36                	js     801057a0 <sys_sem_init+0x50>
    return -1;
  
  if(argint(1, &value) < 0)
8010576a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010576d:	83 ec 08             	sub    $0x8,%esp
80105770:	50                   	push   %eax
80105771:	6a 01                	push   $0x1
80105773:	e8 68 f0 ff ff       	call   801047e0 <argint>
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	85 c0                	test   %eax,%eax
8010577d:	78 21                	js     801057a0 <sys_sem_init+0x50>
    return -1;
  
  sem_init(sem,value);
8010577f:	83 ec 08             	sub    $0x8,%esp
80105782:	ff 75 f4             	pushl  -0xc(%ebp)
80105785:	ff 75 f0             	pushl  -0x10(%ebp)
80105788:	e8 f3 21 00 00       	call   80107980 <sem_init>
  return 1; //compiler complaining
8010578d:	83 c4 10             	add    $0x10,%esp
80105790:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105795:	c9                   	leave  
80105796:	c3                   	ret    
80105797:	89 f6                	mov    %esi,%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
sys_sem_init(void)
{
  sem_t *sem;
  int value;
  if (argptr(0, (char**)&sem, sizeof(sem)) < 0)
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(argint(1, &value) < 0)
    return -1;
  
  sem_init(sem,value);
  return 1; //compiler complaining
}
801057a5:	c9                   	leave  
801057a6:	c3                   	ret    
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057b0 <sys_sem_up>:

int
sys_sem_up(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 1c             	sub    $0x1c,%esp
  sem_t *sem;
  if (argptr(0,(char**)&sem, sizeof(sem)) < 0)
801057b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057b9:	6a 04                	push   $0x4
801057bb:	50                   	push   %eax
801057bc:	6a 00                	push   $0x0
801057be:	e8 6d f0 ff ff       	call   80104830 <argptr>
801057c3:	83 c4 10             	add    $0x10,%esp
801057c6:	85 c0                	test   %eax,%eax
801057c8:	78 16                	js     801057e0 <sys_sem_up+0x30>
    return -1;
  
  sem_up(sem);
801057ca:	83 ec 0c             	sub    $0xc,%esp
801057cd:	ff 75 f4             	pushl  -0xc(%ebp)
801057d0:	e8 db 21 00 00       	call   801079b0 <sem_up>
  return 1; //compiler complaining
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	b8 01 00 00 00       	mov    $0x1,%eax
}
801057dd:	c9                   	leave  
801057de:	c3                   	ret    
801057df:	90                   	nop
int
sys_sem_up(void)
{
  sem_t *sem;
  if (argptr(0,(char**)&sem, sizeof(sem)) < 0)
    return -1;
801057e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  
  sem_up(sem);
  return 1; //compiler complaining
}
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_sem_down>:

int
sys_sem_down(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 1c             	sub    $0x1c,%esp
  sem_t *sem;
  if (argptr(0, (char**)&sem, sizeof(sem)) < 0)
801057f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f9:	6a 04                	push   $0x4
801057fb:	50                   	push   %eax
801057fc:	6a 00                	push   $0x0
801057fe:	e8 2d f0 ff ff       	call   80104830 <argptr>
80105803:	83 c4 10             	add    $0x10,%esp
80105806:	85 c0                	test   %eax,%eax
80105808:	78 16                	js     80105820 <sys_sem_down+0x30>
    return -1;
  
  sem_down(sem);
8010580a:	83 ec 0c             	sub    $0xc,%esp
8010580d:	ff 75 f4             	pushl  -0xc(%ebp)
80105810:	e8 eb 21 00 00       	call   80107a00 <sem_down>
  return 1; //compiler complaining
80105815:	83 c4 10             	add    $0x10,%esp
80105818:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010581d:	c9                   	leave  
8010581e:	c3                   	ret    
8010581f:	90                   	nop
int
sys_sem_down(void)
{
  sem_t *sem;
  if (argptr(0, (char**)&sem, sizeof(sem)) < 0)
    return -1;
80105820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  
  sem_down(sem);
  return 1; //compiler complaining
}
80105825:	c9                   	leave  
80105826:	c3                   	ret    

80105827 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105827:	1e                   	push   %ds
  pushl %es
80105828:	06                   	push   %es
  pushl %fs
80105829:	0f a0                	push   %fs
  pushl %gs
8010582b:	0f a8                	push   %gs
  pushal
8010582d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010582e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105832:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105834:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105836:	54                   	push   %esp
  call trap
80105837:	e8 e4 00 00 00       	call   80105920 <trap>
  addl $4, %esp
8010583c:	83 c4 04             	add    $0x4,%esp

8010583f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010583f:	61                   	popa   
  popl %gs
80105840:	0f a9                	pop    %gs
  popl %fs
80105842:	0f a1                	pop    %fs
  popl %es
80105844:	07                   	pop    %es
  popl %ds
80105845:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105846:	83 c4 08             	add    $0x8,%esp
  iret
80105849:	cf                   	iret   
8010584a:	66 90                	xchg   %ax,%ax
8010584c:	66 90                	xchg   %ax,%ax
8010584e:	66 90                	xchg   %ax,%ax

80105850 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105850:	31 c0                	xor    %eax,%eax
80105852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105858:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
8010585f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105864:	c6 04 c5 a4 25 12 80 	movb   $0x0,-0x7fedda5c(,%eax,8)
8010586b:	00 
8010586c:	66 89 0c c5 a2 25 12 	mov    %cx,-0x7fedda5e(,%eax,8)
80105873:	80 
80105874:	c6 04 c5 a5 25 12 80 	movb   $0x8e,-0x7fedda5b(,%eax,8)
8010587b:	8e 
8010587c:	66 89 14 c5 a0 25 12 	mov    %dx,-0x7fedda60(,%eax,8)
80105883:	80 
80105884:	c1 ea 10             	shr    $0x10,%edx
80105887:	66 89 14 c5 a6 25 12 	mov    %dx,-0x7fedda5a(,%eax,8)
8010588e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010588f:	83 c0 01             	add    $0x1,%eax
80105892:	3d 00 01 00 00       	cmp    $0x100,%eax
80105897:	75 bf                	jne    80105858 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105899:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010589a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010589f:	89 e5                	mov    %esp,%ebp
801058a1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058a4:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801058a9:	68 2d 82 10 80       	push   $0x8010822d
801058ae:	68 60 25 12 80       	push   $0x80122560
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058b3:	66 89 15 a2 27 12 80 	mov    %dx,0x801227a2
801058ba:	c6 05 a4 27 12 80 00 	movb   $0x0,0x801227a4
801058c1:	66 a3 a0 27 12 80    	mov    %ax,0x801227a0
801058c7:	c1 e8 10             	shr    $0x10,%eax
801058ca:	c6 05 a5 27 12 80 ef 	movb   $0xef,0x801227a5
801058d1:	66 a3 a6 27 12 80    	mov    %ax,0x801227a6

  initlock(&tickslock, "time");
801058d7:	e8 84 e9 ff ff       	call   80104260 <initlock>
}
801058dc:	83 c4 10             	add    $0x10,%esp
801058df:	c9                   	leave  
801058e0:	c3                   	ret    
801058e1:	eb 0d                	jmp    801058f0 <idtinit>
801058e3:	90                   	nop
801058e4:	90                   	nop
801058e5:	90                   	nop
801058e6:	90                   	nop
801058e7:	90                   	nop
801058e8:	90                   	nop
801058e9:	90                   	nop
801058ea:	90                   	nop
801058eb:	90                   	nop
801058ec:	90                   	nop
801058ed:	90                   	nop
801058ee:	90                   	nop
801058ef:	90                   	nop

801058f0 <idtinit>:

void
idtinit(void)
{
801058f0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801058f1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801058f6:	89 e5                	mov    %esp,%ebp
801058f8:	83 ec 10             	sub    $0x10,%esp
801058fb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801058ff:	b8 a0 25 12 80       	mov    $0x801225a0,%eax
80105904:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105908:	c1 e8 10             	shr    $0x10,%eax
8010590b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010590f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105912:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105915:	c9                   	leave  
80105916:	c3                   	ret    
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	57                   	push   %edi
80105924:	56                   	push   %esi
80105925:	53                   	push   %ebx
80105926:	83 ec 1c             	sub    $0x1c,%esp
80105929:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010592c:	8b 47 30             	mov    0x30(%edi),%eax
8010592f:	83 f8 40             	cmp    $0x40,%eax
80105932:	0f 84 88 01 00 00    	je     80105ac0 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105938:	83 e8 20             	sub    $0x20,%eax
8010593b:	83 f8 1f             	cmp    $0x1f,%eax
8010593e:	77 10                	ja     80105950 <trap+0x30>
80105940:	ff 24 85 d4 82 10 80 	jmp    *-0x7fef7d2c(,%eax,4)
80105947:	89 f6                	mov    %esi,%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105950:	e8 ab de ff ff       	call   80103800 <myproc>
80105955:	85 c0                	test   %eax,%eax
80105957:	0f 84 d7 01 00 00    	je     80105b34 <trap+0x214>
8010595d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105961:	0f 84 cd 01 00 00    	je     80105b34 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105967:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010596a:	8b 57 38             	mov    0x38(%edi),%edx
8010596d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105970:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105973:	e8 68 de ff ff       	call   801037e0 <cpuid>
80105978:	8b 77 34             	mov    0x34(%edi),%esi
8010597b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010597e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105981:	e8 7a de ff ff       	call   80103800 <myproc>
80105986:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105989:	e8 72 de ff ff       	call   80103800 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010598e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105991:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105994:	51                   	push   %ecx
80105995:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105996:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105999:	ff 75 e4             	pushl  -0x1c(%ebp)
8010599c:	56                   	push   %esi
8010599d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010599e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059a1:	52                   	push   %edx
801059a2:	ff 70 10             	pushl  0x10(%eax)
801059a5:	68 90 82 10 80       	push   $0x80108290
801059aa:	e8 b1 ac ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801059af:	83 c4 20             	add    $0x20,%esp
801059b2:	e8 49 de ff ff       	call   80103800 <myproc>
801059b7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801059be:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059c0:	e8 3b de ff ff       	call   80103800 <myproc>
801059c5:	85 c0                	test   %eax,%eax
801059c7:	74 0c                	je     801059d5 <trap+0xb5>
801059c9:	e8 32 de ff ff       	call   80103800 <myproc>
801059ce:	8b 50 24             	mov    0x24(%eax),%edx
801059d1:	85 d2                	test   %edx,%edx
801059d3:	75 4b                	jne    80105a20 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059d5:	e8 26 de ff ff       	call   80103800 <myproc>
801059da:	85 c0                	test   %eax,%eax
801059dc:	74 0b                	je     801059e9 <trap+0xc9>
801059de:	e8 1d de ff ff       	call   80103800 <myproc>
801059e3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059e7:	74 4f                	je     80105a38 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059e9:	e8 12 de ff ff       	call   80103800 <myproc>
801059ee:	85 c0                	test   %eax,%eax
801059f0:	74 1d                	je     80105a0f <trap+0xef>
801059f2:	e8 09 de ff ff       	call   80103800 <myproc>
801059f7:	8b 40 24             	mov    0x24(%eax),%eax
801059fa:	85 c0                	test   %eax,%eax
801059fc:	74 11                	je     80105a0f <trap+0xef>
801059fe:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105a02:	83 e0 03             	and    $0x3,%eax
80105a05:	66 83 f8 03          	cmp    $0x3,%ax
80105a09:	0f 84 da 00 00 00    	je     80105ae9 <trap+0x1c9>
    exit();
}
80105a0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a12:	5b                   	pop    %ebx
80105a13:	5e                   	pop    %esi
80105a14:	5f                   	pop    %edi
80105a15:	5d                   	pop    %ebp
80105a16:	c3                   	ret    
80105a17:	89 f6                	mov    %esi,%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a20:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105a24:	83 e0 03             	and    $0x3,%eax
80105a27:	66 83 f8 03          	cmp    $0x3,%ax
80105a2b:	75 a8                	jne    801059d5 <trap+0xb5>
    exit();
80105a2d:	e8 1e e2 ff ff       	call   80103c50 <exit>
80105a32:	eb a1                	jmp    801059d5 <trap+0xb5>
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a38:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105a3c:	75 ab                	jne    801059e9 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105a3e:	e8 4d e3 ff ff       	call   80103d90 <yield>
80105a43:	eb a4                	jmp    801059e9 <trap+0xc9>
80105a45:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105a48:	e8 93 dd ff ff       	call   801037e0 <cpuid>
80105a4d:	85 c0                	test   %eax,%eax
80105a4f:	0f 84 ab 00 00 00    	je     80105b00 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105a55:	e8 b6 cc ff ff       	call   80102710 <lapiceoi>
    break;
80105a5a:	e9 61 ff ff ff       	jmp    801059c0 <trap+0xa0>
80105a5f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105a60:	e8 6b cb ff ff       	call   801025d0 <kbdintr>
    lapiceoi();
80105a65:	e8 a6 cc ff ff       	call   80102710 <lapiceoi>
    break;
80105a6a:	e9 51 ff ff ff       	jmp    801059c0 <trap+0xa0>
80105a6f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105a70:	e8 5b 02 00 00       	call   80105cd0 <uartintr>
    lapiceoi();
80105a75:	e8 96 cc ff ff       	call   80102710 <lapiceoi>
    break;
80105a7a:	e9 41 ff ff ff       	jmp    801059c0 <trap+0xa0>
80105a7f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a80:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105a84:	8b 77 38             	mov    0x38(%edi),%esi
80105a87:	e8 54 dd ff ff       	call   801037e0 <cpuid>
80105a8c:	56                   	push   %esi
80105a8d:	53                   	push   %ebx
80105a8e:	50                   	push   %eax
80105a8f:	68 38 82 10 80       	push   $0x80108238
80105a94:	e8 c7 ab ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105a99:	e8 72 cc ff ff       	call   80102710 <lapiceoi>
    break;
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	e9 1a ff ff ff       	jmp    801059c0 <trap+0xa0>
80105aa6:	8d 76 00             	lea    0x0(%esi),%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ab0:	e8 9b c5 ff ff       	call   80102050 <ideintr>
80105ab5:	eb 9e                	jmp    80105a55 <trap+0x135>
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105ac0:	e8 3b dd ff ff       	call   80103800 <myproc>
80105ac5:	8b 58 24             	mov    0x24(%eax),%ebx
80105ac8:	85 db                	test   %ebx,%ebx
80105aca:	75 2c                	jne    80105af8 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
80105acc:	e8 2f dd ff ff       	call   80103800 <myproc>
80105ad1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105ad4:	e8 f7 ed ff ff       	call   801048d0 <syscall>
    if(myproc()->killed)
80105ad9:	e8 22 dd ff ff       	call   80103800 <myproc>
80105ade:	8b 48 24             	mov    0x24(%eax),%ecx
80105ae1:	85 c9                	test   %ecx,%ecx
80105ae3:	0f 84 26 ff ff ff    	je     80105a0f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105ae9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aec:	5b                   	pop    %ebx
80105aed:	5e                   	pop    %esi
80105aee:	5f                   	pop    %edi
80105aef:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105af0:	e9 5b e1 ff ff       	jmp    80103c50 <exit>
80105af5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105af8:	e8 53 e1 ff ff       	call   80103c50 <exit>
80105afd:	eb cd                	jmp    80105acc <trap+0x1ac>
80105aff:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	68 60 25 12 80       	push   $0x80122560
80105b08:	e8 53 e8 ff ff       	call   80104360 <acquire>
      ticks++;
      wakeup(&ticks);
80105b0d:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105b14:	83 05 a0 2d 12 80 01 	addl   $0x1,0x80122da0
      wakeup(&ticks);
80105b1b:	e8 80 e4 ff ff       	call   80103fa0 <wakeup>
      release(&tickslock);
80105b20:	c7 04 24 60 25 12 80 	movl   $0x80122560,(%esp)
80105b27:	e8 54 e9 ff ff       	call   80104480 <release>
80105b2c:	83 c4 10             	add    $0x10,%esp
80105b2f:	e9 21 ff ff ff       	jmp    80105a55 <trap+0x135>
80105b34:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b37:	8b 5f 38             	mov    0x38(%edi),%ebx
80105b3a:	e8 a1 dc ff ff       	call   801037e0 <cpuid>
80105b3f:	83 ec 0c             	sub    $0xc,%esp
80105b42:	56                   	push   %esi
80105b43:	53                   	push   %ebx
80105b44:	50                   	push   %eax
80105b45:	ff 77 30             	pushl  0x30(%edi)
80105b48:	68 5c 82 10 80       	push   $0x8010825c
80105b4d:	e8 0e ab ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105b52:	83 c4 14             	add    $0x14,%esp
80105b55:	68 32 82 10 80       	push   $0x80108232
80105b5a:	e8 11 a8 ff ff       	call   80100370 <panic>
80105b5f:	90                   	nop

80105b60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b60:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105b65:	55                   	push   %ebp
80105b66:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b68:	85 c0                	test   %eax,%eax
80105b6a:	74 1c                	je     80105b88 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b6c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b71:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105b72:	a8 01                	test   $0x1,%al
80105b74:	74 12                	je     80105b88 <uartgetc+0x28>
80105b76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b7b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105b7c:	0f b6 c0             	movzbl %al,%eax
}
80105b7f:	5d                   	pop    %ebp
80105b80:	c3                   	ret    
80105b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105b8d:	5d                   	pop    %ebp
80105b8e:	c3                   	ret    
80105b8f:	90                   	nop

80105b90 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	57                   	push   %edi
80105b94:	56                   	push   %esi
80105b95:	53                   	push   %ebx
80105b96:	89 c7                	mov    %eax,%edi
80105b98:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ba2:	83 ec 0c             	sub    $0xc,%esp
80105ba5:	eb 1b                	jmp    80105bc2 <uartputc.part.0+0x32>
80105ba7:	89 f6                	mov    %esi,%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	6a 0a                	push   $0xa
80105bb5:	e8 76 cb ff ff       	call   80102730 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105bba:	83 c4 10             	add    $0x10,%esp
80105bbd:	83 eb 01             	sub    $0x1,%ebx
80105bc0:	74 07                	je     80105bc9 <uartputc.part.0+0x39>
80105bc2:	89 f2                	mov    %esi,%edx
80105bc4:	ec                   	in     (%dx),%al
80105bc5:	a8 20                	test   $0x20,%al
80105bc7:	74 e7                	je     80105bb0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105bc9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bce:	89 f8                	mov    %edi,%eax
80105bd0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105bd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bd4:	5b                   	pop    %ebx
80105bd5:	5e                   	pop    %esi
80105bd6:	5f                   	pop    %edi
80105bd7:	5d                   	pop    %ebp
80105bd8:	c3                   	ret    
80105bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105be0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105be0:	55                   	push   %ebp
80105be1:	31 c9                	xor    %ecx,%ecx
80105be3:	89 c8                	mov    %ecx,%eax
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	57                   	push   %edi
80105be8:	56                   	push   %esi
80105be9:	53                   	push   %ebx
80105bea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105bef:	89 da                	mov    %ebx,%edx
80105bf1:	83 ec 0c             	sub    $0xc,%esp
80105bf4:	ee                   	out    %al,(%dx)
80105bf5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105bfa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105bff:	89 fa                	mov    %edi,%edx
80105c01:	ee                   	out    %al,(%dx)
80105c02:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c0c:	ee                   	out    %al,(%dx)
80105c0d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105c12:	89 c8                	mov    %ecx,%eax
80105c14:	89 f2                	mov    %esi,%edx
80105c16:	ee                   	out    %al,(%dx)
80105c17:	b8 03 00 00 00       	mov    $0x3,%eax
80105c1c:	89 fa                	mov    %edi,%edx
80105c1e:	ee                   	out    %al,(%dx)
80105c1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105c24:	89 c8                	mov    %ecx,%eax
80105c26:	ee                   	out    %al,(%dx)
80105c27:	b8 01 00 00 00       	mov    $0x1,%eax
80105c2c:	89 f2                	mov    %esi,%edx
80105c2e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c34:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105c35:	3c ff                	cmp    $0xff,%al
80105c37:	74 5a                	je     80105c93 <uartinit+0xb3>
    return;
  uart = 1;
80105c39:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105c40:	00 00 00 
80105c43:	89 da                	mov    %ebx,%edx
80105c45:	ec                   	in     (%dx),%al
80105c46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c4b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105c4c:	83 ec 08             	sub    $0x8,%esp
80105c4f:	bb 54 83 10 80       	mov    $0x80108354,%ebx
80105c54:	6a 00                	push   $0x0
80105c56:	6a 04                	push   $0x4
80105c58:	e8 43 c6 ff ff       	call   801022a0 <ioapicenable>
80105c5d:	83 c4 10             	add    $0x10,%esp
80105c60:	b8 78 00 00 00       	mov    $0x78,%eax
80105c65:	eb 13                	jmp    80105c7a <uartinit+0x9a>
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c70:	83 c3 01             	add    $0x1,%ebx
80105c73:	0f be 03             	movsbl (%ebx),%eax
80105c76:	84 c0                	test   %al,%al
80105c78:	74 19                	je     80105c93 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105c7a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80105c80:	85 d2                	test   %edx,%edx
80105c82:	74 ec                	je     80105c70 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c84:	83 c3 01             	add    $0x1,%ebx
80105c87:	e8 04 ff ff ff       	call   80105b90 <uartputc.part.0>
80105c8c:	0f be 03             	movsbl (%ebx),%eax
80105c8f:	84 c0                	test   %al,%al
80105c91:	75 e7                	jne    80105c7a <uartinit+0x9a>
    uartputc(*p);
}
80105c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c96:	5b                   	pop    %ebx
80105c97:	5e                   	pop    %esi
80105c98:	5f                   	pop    %edi
80105c99:	5d                   	pop    %ebp
80105c9a:	c3                   	ret    
80105c9b:	90                   	nop
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ca0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105ca0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105ca6:	55                   	push   %ebp
80105ca7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105ca9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105cab:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105cae:	74 10                	je     80105cc0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105cb0:	5d                   	pop    %ebp
80105cb1:	e9 da fe ff ff       	jmp    80105b90 <uartputc.part.0>
80105cb6:	8d 76 00             	lea    0x0(%esi),%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105cc0:	5d                   	pop    %ebp
80105cc1:	c3                   	ret    
80105cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cd0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105cd6:	68 60 5b 10 80       	push   $0x80105b60
80105cdb:	e8 10 ab ff ff       	call   801007f0 <consoleintr>
}
80105ce0:	83 c4 10             	add    $0x10,%esp
80105ce3:	c9                   	leave  
80105ce4:	c3                   	ret    

80105ce5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ce5:	6a 00                	push   $0x0
  pushl $0
80105ce7:	6a 00                	push   $0x0
  jmp alltraps
80105ce9:	e9 39 fb ff ff       	jmp    80105827 <alltraps>

80105cee <vector1>:
.globl vector1
vector1:
  pushl $0
80105cee:	6a 00                	push   $0x0
  pushl $1
80105cf0:	6a 01                	push   $0x1
  jmp alltraps
80105cf2:	e9 30 fb ff ff       	jmp    80105827 <alltraps>

80105cf7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105cf7:	6a 00                	push   $0x0
  pushl $2
80105cf9:	6a 02                	push   $0x2
  jmp alltraps
80105cfb:	e9 27 fb ff ff       	jmp    80105827 <alltraps>

80105d00 <vector3>:
.globl vector3
vector3:
  pushl $0
80105d00:	6a 00                	push   $0x0
  pushl $3
80105d02:	6a 03                	push   $0x3
  jmp alltraps
80105d04:	e9 1e fb ff ff       	jmp    80105827 <alltraps>

80105d09 <vector4>:
.globl vector4
vector4:
  pushl $0
80105d09:	6a 00                	push   $0x0
  pushl $4
80105d0b:	6a 04                	push   $0x4
  jmp alltraps
80105d0d:	e9 15 fb ff ff       	jmp    80105827 <alltraps>

80105d12 <vector5>:
.globl vector5
vector5:
  pushl $0
80105d12:	6a 00                	push   $0x0
  pushl $5
80105d14:	6a 05                	push   $0x5
  jmp alltraps
80105d16:	e9 0c fb ff ff       	jmp    80105827 <alltraps>

80105d1b <vector6>:
.globl vector6
vector6:
  pushl $0
80105d1b:	6a 00                	push   $0x0
  pushl $6
80105d1d:	6a 06                	push   $0x6
  jmp alltraps
80105d1f:	e9 03 fb ff ff       	jmp    80105827 <alltraps>

80105d24 <vector7>:
.globl vector7
vector7:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $7
80105d26:	6a 07                	push   $0x7
  jmp alltraps
80105d28:	e9 fa fa ff ff       	jmp    80105827 <alltraps>

80105d2d <vector8>:
.globl vector8
vector8:
  pushl $8
80105d2d:	6a 08                	push   $0x8
  jmp alltraps
80105d2f:	e9 f3 fa ff ff       	jmp    80105827 <alltraps>

80105d34 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d34:	6a 00                	push   $0x0
  pushl $9
80105d36:	6a 09                	push   $0x9
  jmp alltraps
80105d38:	e9 ea fa ff ff       	jmp    80105827 <alltraps>

80105d3d <vector10>:
.globl vector10
vector10:
  pushl $10
80105d3d:	6a 0a                	push   $0xa
  jmp alltraps
80105d3f:	e9 e3 fa ff ff       	jmp    80105827 <alltraps>

80105d44 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d44:	6a 0b                	push   $0xb
  jmp alltraps
80105d46:	e9 dc fa ff ff       	jmp    80105827 <alltraps>

80105d4b <vector12>:
.globl vector12
vector12:
  pushl $12
80105d4b:	6a 0c                	push   $0xc
  jmp alltraps
80105d4d:	e9 d5 fa ff ff       	jmp    80105827 <alltraps>

80105d52 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d52:	6a 0d                	push   $0xd
  jmp alltraps
80105d54:	e9 ce fa ff ff       	jmp    80105827 <alltraps>

80105d59 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d59:	6a 0e                	push   $0xe
  jmp alltraps
80105d5b:	e9 c7 fa ff ff       	jmp    80105827 <alltraps>

80105d60 <vector15>:
.globl vector15
vector15:
  pushl $0
80105d60:	6a 00                	push   $0x0
  pushl $15
80105d62:	6a 0f                	push   $0xf
  jmp alltraps
80105d64:	e9 be fa ff ff       	jmp    80105827 <alltraps>

80105d69 <vector16>:
.globl vector16
vector16:
  pushl $0
80105d69:	6a 00                	push   $0x0
  pushl $16
80105d6b:	6a 10                	push   $0x10
  jmp alltraps
80105d6d:	e9 b5 fa ff ff       	jmp    80105827 <alltraps>

80105d72 <vector17>:
.globl vector17
vector17:
  pushl $17
80105d72:	6a 11                	push   $0x11
  jmp alltraps
80105d74:	e9 ae fa ff ff       	jmp    80105827 <alltraps>

80105d79 <vector18>:
.globl vector18
vector18:
  pushl $0
80105d79:	6a 00                	push   $0x0
  pushl $18
80105d7b:	6a 12                	push   $0x12
  jmp alltraps
80105d7d:	e9 a5 fa ff ff       	jmp    80105827 <alltraps>

80105d82 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $19
80105d84:	6a 13                	push   $0x13
  jmp alltraps
80105d86:	e9 9c fa ff ff       	jmp    80105827 <alltraps>

80105d8b <vector20>:
.globl vector20
vector20:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $20
80105d8d:	6a 14                	push   $0x14
  jmp alltraps
80105d8f:	e9 93 fa ff ff       	jmp    80105827 <alltraps>

80105d94 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $21
80105d96:	6a 15                	push   $0x15
  jmp alltraps
80105d98:	e9 8a fa ff ff       	jmp    80105827 <alltraps>

80105d9d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d9d:	6a 00                	push   $0x0
  pushl $22
80105d9f:	6a 16                	push   $0x16
  jmp alltraps
80105da1:	e9 81 fa ff ff       	jmp    80105827 <alltraps>

80105da6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $23
80105da8:	6a 17                	push   $0x17
  jmp alltraps
80105daa:	e9 78 fa ff ff       	jmp    80105827 <alltraps>

80105daf <vector24>:
.globl vector24
vector24:
  pushl $0
80105daf:	6a 00                	push   $0x0
  pushl $24
80105db1:	6a 18                	push   $0x18
  jmp alltraps
80105db3:	e9 6f fa ff ff       	jmp    80105827 <alltraps>

80105db8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105db8:	6a 00                	push   $0x0
  pushl $25
80105dba:	6a 19                	push   $0x19
  jmp alltraps
80105dbc:	e9 66 fa ff ff       	jmp    80105827 <alltraps>

80105dc1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105dc1:	6a 00                	push   $0x0
  pushl $26
80105dc3:	6a 1a                	push   $0x1a
  jmp alltraps
80105dc5:	e9 5d fa ff ff       	jmp    80105827 <alltraps>

80105dca <vector27>:
.globl vector27
vector27:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $27
80105dcc:	6a 1b                	push   $0x1b
  jmp alltraps
80105dce:	e9 54 fa ff ff       	jmp    80105827 <alltraps>

80105dd3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $28
80105dd5:	6a 1c                	push   $0x1c
  jmp alltraps
80105dd7:	e9 4b fa ff ff       	jmp    80105827 <alltraps>

80105ddc <vector29>:
.globl vector29
vector29:
  pushl $0
80105ddc:	6a 00                	push   $0x0
  pushl $29
80105dde:	6a 1d                	push   $0x1d
  jmp alltraps
80105de0:	e9 42 fa ff ff       	jmp    80105827 <alltraps>

80105de5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105de5:	6a 00                	push   $0x0
  pushl $30
80105de7:	6a 1e                	push   $0x1e
  jmp alltraps
80105de9:	e9 39 fa ff ff       	jmp    80105827 <alltraps>

80105dee <vector31>:
.globl vector31
vector31:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $31
80105df0:	6a 1f                	push   $0x1f
  jmp alltraps
80105df2:	e9 30 fa ff ff       	jmp    80105827 <alltraps>

80105df7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $32
80105df9:	6a 20                	push   $0x20
  jmp alltraps
80105dfb:	e9 27 fa ff ff       	jmp    80105827 <alltraps>

80105e00 <vector33>:
.globl vector33
vector33:
  pushl $0
80105e00:	6a 00                	push   $0x0
  pushl $33
80105e02:	6a 21                	push   $0x21
  jmp alltraps
80105e04:	e9 1e fa ff ff       	jmp    80105827 <alltraps>

80105e09 <vector34>:
.globl vector34
vector34:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $34
80105e0b:	6a 22                	push   $0x22
  jmp alltraps
80105e0d:	e9 15 fa ff ff       	jmp    80105827 <alltraps>

80105e12 <vector35>:
.globl vector35
vector35:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $35
80105e14:	6a 23                	push   $0x23
  jmp alltraps
80105e16:	e9 0c fa ff ff       	jmp    80105827 <alltraps>

80105e1b <vector36>:
.globl vector36
vector36:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $36
80105e1d:	6a 24                	push   $0x24
  jmp alltraps
80105e1f:	e9 03 fa ff ff       	jmp    80105827 <alltraps>

80105e24 <vector37>:
.globl vector37
vector37:
  pushl $0
80105e24:	6a 00                	push   $0x0
  pushl $37
80105e26:	6a 25                	push   $0x25
  jmp alltraps
80105e28:	e9 fa f9 ff ff       	jmp    80105827 <alltraps>

80105e2d <vector38>:
.globl vector38
vector38:
  pushl $0
80105e2d:	6a 00                	push   $0x0
  pushl $38
80105e2f:	6a 26                	push   $0x26
  jmp alltraps
80105e31:	e9 f1 f9 ff ff       	jmp    80105827 <alltraps>

80105e36 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $39
80105e38:	6a 27                	push   $0x27
  jmp alltraps
80105e3a:	e9 e8 f9 ff ff       	jmp    80105827 <alltraps>

80105e3f <vector40>:
.globl vector40
vector40:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $40
80105e41:	6a 28                	push   $0x28
  jmp alltraps
80105e43:	e9 df f9 ff ff       	jmp    80105827 <alltraps>

80105e48 <vector41>:
.globl vector41
vector41:
  pushl $0
80105e48:	6a 00                	push   $0x0
  pushl $41
80105e4a:	6a 29                	push   $0x29
  jmp alltraps
80105e4c:	e9 d6 f9 ff ff       	jmp    80105827 <alltraps>

80105e51 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e51:	6a 00                	push   $0x0
  pushl $42
80105e53:	6a 2a                	push   $0x2a
  jmp alltraps
80105e55:	e9 cd f9 ff ff       	jmp    80105827 <alltraps>

80105e5a <vector43>:
.globl vector43
vector43:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $43
80105e5c:	6a 2b                	push   $0x2b
  jmp alltraps
80105e5e:	e9 c4 f9 ff ff       	jmp    80105827 <alltraps>

80105e63 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $44
80105e65:	6a 2c                	push   $0x2c
  jmp alltraps
80105e67:	e9 bb f9 ff ff       	jmp    80105827 <alltraps>

80105e6c <vector45>:
.globl vector45
vector45:
  pushl $0
80105e6c:	6a 00                	push   $0x0
  pushl $45
80105e6e:	6a 2d                	push   $0x2d
  jmp alltraps
80105e70:	e9 b2 f9 ff ff       	jmp    80105827 <alltraps>

80105e75 <vector46>:
.globl vector46
vector46:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $46
80105e77:	6a 2e                	push   $0x2e
  jmp alltraps
80105e79:	e9 a9 f9 ff ff       	jmp    80105827 <alltraps>

80105e7e <vector47>:
.globl vector47
vector47:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $47
80105e80:	6a 2f                	push   $0x2f
  jmp alltraps
80105e82:	e9 a0 f9 ff ff       	jmp    80105827 <alltraps>

80105e87 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $48
80105e89:	6a 30                	push   $0x30
  jmp alltraps
80105e8b:	e9 97 f9 ff ff       	jmp    80105827 <alltraps>

80105e90 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $49
80105e92:	6a 31                	push   $0x31
  jmp alltraps
80105e94:	e9 8e f9 ff ff       	jmp    80105827 <alltraps>

80105e99 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $50
80105e9b:	6a 32                	push   $0x32
  jmp alltraps
80105e9d:	e9 85 f9 ff ff       	jmp    80105827 <alltraps>

80105ea2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $51
80105ea4:	6a 33                	push   $0x33
  jmp alltraps
80105ea6:	e9 7c f9 ff ff       	jmp    80105827 <alltraps>

80105eab <vector52>:
.globl vector52
vector52:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $52
80105ead:	6a 34                	push   $0x34
  jmp alltraps
80105eaf:	e9 73 f9 ff ff       	jmp    80105827 <alltraps>

80105eb4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $53
80105eb6:	6a 35                	push   $0x35
  jmp alltraps
80105eb8:	e9 6a f9 ff ff       	jmp    80105827 <alltraps>

80105ebd <vector54>:
.globl vector54
vector54:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $54
80105ebf:	6a 36                	push   $0x36
  jmp alltraps
80105ec1:	e9 61 f9 ff ff       	jmp    80105827 <alltraps>

80105ec6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $55
80105ec8:	6a 37                	push   $0x37
  jmp alltraps
80105eca:	e9 58 f9 ff ff       	jmp    80105827 <alltraps>

80105ecf <vector56>:
.globl vector56
vector56:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $56
80105ed1:	6a 38                	push   $0x38
  jmp alltraps
80105ed3:	e9 4f f9 ff ff       	jmp    80105827 <alltraps>

80105ed8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $57
80105eda:	6a 39                	push   $0x39
  jmp alltraps
80105edc:	e9 46 f9 ff ff       	jmp    80105827 <alltraps>

80105ee1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105ee1:	6a 00                	push   $0x0
  pushl $58
80105ee3:	6a 3a                	push   $0x3a
  jmp alltraps
80105ee5:	e9 3d f9 ff ff       	jmp    80105827 <alltraps>

80105eea <vector59>:
.globl vector59
vector59:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $59
80105eec:	6a 3b                	push   $0x3b
  jmp alltraps
80105eee:	e9 34 f9 ff ff       	jmp    80105827 <alltraps>

80105ef3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $60
80105ef5:	6a 3c                	push   $0x3c
  jmp alltraps
80105ef7:	e9 2b f9 ff ff       	jmp    80105827 <alltraps>

80105efc <vector61>:
.globl vector61
vector61:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $61
80105efe:	6a 3d                	push   $0x3d
  jmp alltraps
80105f00:	e9 22 f9 ff ff       	jmp    80105827 <alltraps>

80105f05 <vector62>:
.globl vector62
vector62:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $62
80105f07:	6a 3e                	push   $0x3e
  jmp alltraps
80105f09:	e9 19 f9 ff ff       	jmp    80105827 <alltraps>

80105f0e <vector63>:
.globl vector63
vector63:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $63
80105f10:	6a 3f                	push   $0x3f
  jmp alltraps
80105f12:	e9 10 f9 ff ff       	jmp    80105827 <alltraps>

80105f17 <vector64>:
.globl vector64
vector64:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $64
80105f19:	6a 40                	push   $0x40
  jmp alltraps
80105f1b:	e9 07 f9 ff ff       	jmp    80105827 <alltraps>

80105f20 <vector65>:
.globl vector65
vector65:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $65
80105f22:	6a 41                	push   $0x41
  jmp alltraps
80105f24:	e9 fe f8 ff ff       	jmp    80105827 <alltraps>

80105f29 <vector66>:
.globl vector66
vector66:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $66
80105f2b:	6a 42                	push   $0x42
  jmp alltraps
80105f2d:	e9 f5 f8 ff ff       	jmp    80105827 <alltraps>

80105f32 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $67
80105f34:	6a 43                	push   $0x43
  jmp alltraps
80105f36:	e9 ec f8 ff ff       	jmp    80105827 <alltraps>

80105f3b <vector68>:
.globl vector68
vector68:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $68
80105f3d:	6a 44                	push   $0x44
  jmp alltraps
80105f3f:	e9 e3 f8 ff ff       	jmp    80105827 <alltraps>

80105f44 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $69
80105f46:	6a 45                	push   $0x45
  jmp alltraps
80105f48:	e9 da f8 ff ff       	jmp    80105827 <alltraps>

80105f4d <vector70>:
.globl vector70
vector70:
  pushl $0
80105f4d:	6a 00                	push   $0x0
  pushl $70
80105f4f:	6a 46                	push   $0x46
  jmp alltraps
80105f51:	e9 d1 f8 ff ff       	jmp    80105827 <alltraps>

80105f56 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $71
80105f58:	6a 47                	push   $0x47
  jmp alltraps
80105f5a:	e9 c8 f8 ff ff       	jmp    80105827 <alltraps>

80105f5f <vector72>:
.globl vector72
vector72:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $72
80105f61:	6a 48                	push   $0x48
  jmp alltraps
80105f63:	e9 bf f8 ff ff       	jmp    80105827 <alltraps>

80105f68 <vector73>:
.globl vector73
vector73:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $73
80105f6a:	6a 49                	push   $0x49
  jmp alltraps
80105f6c:	e9 b6 f8 ff ff       	jmp    80105827 <alltraps>

80105f71 <vector74>:
.globl vector74
vector74:
  pushl $0
80105f71:	6a 00                	push   $0x0
  pushl $74
80105f73:	6a 4a                	push   $0x4a
  jmp alltraps
80105f75:	e9 ad f8 ff ff       	jmp    80105827 <alltraps>

80105f7a <vector75>:
.globl vector75
vector75:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $75
80105f7c:	6a 4b                	push   $0x4b
  jmp alltraps
80105f7e:	e9 a4 f8 ff ff       	jmp    80105827 <alltraps>

80105f83 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $76
80105f85:	6a 4c                	push   $0x4c
  jmp alltraps
80105f87:	e9 9b f8 ff ff       	jmp    80105827 <alltraps>

80105f8c <vector77>:
.globl vector77
vector77:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $77
80105f8e:	6a 4d                	push   $0x4d
  jmp alltraps
80105f90:	e9 92 f8 ff ff       	jmp    80105827 <alltraps>

80105f95 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $78
80105f97:	6a 4e                	push   $0x4e
  jmp alltraps
80105f99:	e9 89 f8 ff ff       	jmp    80105827 <alltraps>

80105f9e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $79
80105fa0:	6a 4f                	push   $0x4f
  jmp alltraps
80105fa2:	e9 80 f8 ff ff       	jmp    80105827 <alltraps>

80105fa7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $80
80105fa9:	6a 50                	push   $0x50
  jmp alltraps
80105fab:	e9 77 f8 ff ff       	jmp    80105827 <alltraps>

80105fb0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $81
80105fb2:	6a 51                	push   $0x51
  jmp alltraps
80105fb4:	e9 6e f8 ff ff       	jmp    80105827 <alltraps>

80105fb9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $82
80105fbb:	6a 52                	push   $0x52
  jmp alltraps
80105fbd:	e9 65 f8 ff ff       	jmp    80105827 <alltraps>

80105fc2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $83
80105fc4:	6a 53                	push   $0x53
  jmp alltraps
80105fc6:	e9 5c f8 ff ff       	jmp    80105827 <alltraps>

80105fcb <vector84>:
.globl vector84
vector84:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $84
80105fcd:	6a 54                	push   $0x54
  jmp alltraps
80105fcf:	e9 53 f8 ff ff       	jmp    80105827 <alltraps>

80105fd4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $85
80105fd6:	6a 55                	push   $0x55
  jmp alltraps
80105fd8:	e9 4a f8 ff ff       	jmp    80105827 <alltraps>

80105fdd <vector86>:
.globl vector86
vector86:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $86
80105fdf:	6a 56                	push   $0x56
  jmp alltraps
80105fe1:	e9 41 f8 ff ff       	jmp    80105827 <alltraps>

80105fe6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $87
80105fe8:	6a 57                	push   $0x57
  jmp alltraps
80105fea:	e9 38 f8 ff ff       	jmp    80105827 <alltraps>

80105fef <vector88>:
.globl vector88
vector88:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $88
80105ff1:	6a 58                	push   $0x58
  jmp alltraps
80105ff3:	e9 2f f8 ff ff       	jmp    80105827 <alltraps>

80105ff8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $89
80105ffa:	6a 59                	push   $0x59
  jmp alltraps
80105ffc:	e9 26 f8 ff ff       	jmp    80105827 <alltraps>

80106001 <vector90>:
.globl vector90
vector90:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $90
80106003:	6a 5a                	push   $0x5a
  jmp alltraps
80106005:	e9 1d f8 ff ff       	jmp    80105827 <alltraps>

8010600a <vector91>:
.globl vector91
vector91:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $91
8010600c:	6a 5b                	push   $0x5b
  jmp alltraps
8010600e:	e9 14 f8 ff ff       	jmp    80105827 <alltraps>

80106013 <vector92>:
.globl vector92
vector92:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $92
80106015:	6a 5c                	push   $0x5c
  jmp alltraps
80106017:	e9 0b f8 ff ff       	jmp    80105827 <alltraps>

8010601c <vector93>:
.globl vector93
vector93:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $93
8010601e:	6a 5d                	push   $0x5d
  jmp alltraps
80106020:	e9 02 f8 ff ff       	jmp    80105827 <alltraps>

80106025 <vector94>:
.globl vector94
vector94:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $94
80106027:	6a 5e                	push   $0x5e
  jmp alltraps
80106029:	e9 f9 f7 ff ff       	jmp    80105827 <alltraps>

8010602e <vector95>:
.globl vector95
vector95:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $95
80106030:	6a 5f                	push   $0x5f
  jmp alltraps
80106032:	e9 f0 f7 ff ff       	jmp    80105827 <alltraps>

80106037 <vector96>:
.globl vector96
vector96:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $96
80106039:	6a 60                	push   $0x60
  jmp alltraps
8010603b:	e9 e7 f7 ff ff       	jmp    80105827 <alltraps>

80106040 <vector97>:
.globl vector97
vector97:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $97
80106042:	6a 61                	push   $0x61
  jmp alltraps
80106044:	e9 de f7 ff ff       	jmp    80105827 <alltraps>

80106049 <vector98>:
.globl vector98
vector98:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $98
8010604b:	6a 62                	push   $0x62
  jmp alltraps
8010604d:	e9 d5 f7 ff ff       	jmp    80105827 <alltraps>

80106052 <vector99>:
.globl vector99
vector99:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $99
80106054:	6a 63                	push   $0x63
  jmp alltraps
80106056:	e9 cc f7 ff ff       	jmp    80105827 <alltraps>

8010605b <vector100>:
.globl vector100
vector100:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $100
8010605d:	6a 64                	push   $0x64
  jmp alltraps
8010605f:	e9 c3 f7 ff ff       	jmp    80105827 <alltraps>

80106064 <vector101>:
.globl vector101
vector101:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $101
80106066:	6a 65                	push   $0x65
  jmp alltraps
80106068:	e9 ba f7 ff ff       	jmp    80105827 <alltraps>

8010606d <vector102>:
.globl vector102
vector102:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $102
8010606f:	6a 66                	push   $0x66
  jmp alltraps
80106071:	e9 b1 f7 ff ff       	jmp    80105827 <alltraps>

80106076 <vector103>:
.globl vector103
vector103:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $103
80106078:	6a 67                	push   $0x67
  jmp alltraps
8010607a:	e9 a8 f7 ff ff       	jmp    80105827 <alltraps>

8010607f <vector104>:
.globl vector104
vector104:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $104
80106081:	6a 68                	push   $0x68
  jmp alltraps
80106083:	e9 9f f7 ff ff       	jmp    80105827 <alltraps>

80106088 <vector105>:
.globl vector105
vector105:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $105
8010608a:	6a 69                	push   $0x69
  jmp alltraps
8010608c:	e9 96 f7 ff ff       	jmp    80105827 <alltraps>

80106091 <vector106>:
.globl vector106
vector106:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $106
80106093:	6a 6a                	push   $0x6a
  jmp alltraps
80106095:	e9 8d f7 ff ff       	jmp    80105827 <alltraps>

8010609a <vector107>:
.globl vector107
vector107:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $107
8010609c:	6a 6b                	push   $0x6b
  jmp alltraps
8010609e:	e9 84 f7 ff ff       	jmp    80105827 <alltraps>

801060a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $108
801060a5:	6a 6c                	push   $0x6c
  jmp alltraps
801060a7:	e9 7b f7 ff ff       	jmp    80105827 <alltraps>

801060ac <vector109>:
.globl vector109
vector109:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $109
801060ae:	6a 6d                	push   $0x6d
  jmp alltraps
801060b0:	e9 72 f7 ff ff       	jmp    80105827 <alltraps>

801060b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $110
801060b7:	6a 6e                	push   $0x6e
  jmp alltraps
801060b9:	e9 69 f7 ff ff       	jmp    80105827 <alltraps>

801060be <vector111>:
.globl vector111
vector111:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $111
801060c0:	6a 6f                	push   $0x6f
  jmp alltraps
801060c2:	e9 60 f7 ff ff       	jmp    80105827 <alltraps>

801060c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $112
801060c9:	6a 70                	push   $0x70
  jmp alltraps
801060cb:	e9 57 f7 ff ff       	jmp    80105827 <alltraps>

801060d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $113
801060d2:	6a 71                	push   $0x71
  jmp alltraps
801060d4:	e9 4e f7 ff ff       	jmp    80105827 <alltraps>

801060d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $114
801060db:	6a 72                	push   $0x72
  jmp alltraps
801060dd:	e9 45 f7 ff ff       	jmp    80105827 <alltraps>

801060e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $115
801060e4:	6a 73                	push   $0x73
  jmp alltraps
801060e6:	e9 3c f7 ff ff       	jmp    80105827 <alltraps>

801060eb <vector116>:
.globl vector116
vector116:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $116
801060ed:	6a 74                	push   $0x74
  jmp alltraps
801060ef:	e9 33 f7 ff ff       	jmp    80105827 <alltraps>

801060f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $117
801060f6:	6a 75                	push   $0x75
  jmp alltraps
801060f8:	e9 2a f7 ff ff       	jmp    80105827 <alltraps>

801060fd <vector118>:
.globl vector118
vector118:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $118
801060ff:	6a 76                	push   $0x76
  jmp alltraps
80106101:	e9 21 f7 ff ff       	jmp    80105827 <alltraps>

80106106 <vector119>:
.globl vector119
vector119:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $119
80106108:	6a 77                	push   $0x77
  jmp alltraps
8010610a:	e9 18 f7 ff ff       	jmp    80105827 <alltraps>

8010610f <vector120>:
.globl vector120
vector120:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $120
80106111:	6a 78                	push   $0x78
  jmp alltraps
80106113:	e9 0f f7 ff ff       	jmp    80105827 <alltraps>

80106118 <vector121>:
.globl vector121
vector121:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $121
8010611a:	6a 79                	push   $0x79
  jmp alltraps
8010611c:	e9 06 f7 ff ff       	jmp    80105827 <alltraps>

80106121 <vector122>:
.globl vector122
vector122:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $122
80106123:	6a 7a                	push   $0x7a
  jmp alltraps
80106125:	e9 fd f6 ff ff       	jmp    80105827 <alltraps>

8010612a <vector123>:
.globl vector123
vector123:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $123
8010612c:	6a 7b                	push   $0x7b
  jmp alltraps
8010612e:	e9 f4 f6 ff ff       	jmp    80105827 <alltraps>

80106133 <vector124>:
.globl vector124
vector124:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $124
80106135:	6a 7c                	push   $0x7c
  jmp alltraps
80106137:	e9 eb f6 ff ff       	jmp    80105827 <alltraps>

8010613c <vector125>:
.globl vector125
vector125:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $125
8010613e:	6a 7d                	push   $0x7d
  jmp alltraps
80106140:	e9 e2 f6 ff ff       	jmp    80105827 <alltraps>

80106145 <vector126>:
.globl vector126
vector126:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $126
80106147:	6a 7e                	push   $0x7e
  jmp alltraps
80106149:	e9 d9 f6 ff ff       	jmp    80105827 <alltraps>

8010614e <vector127>:
.globl vector127
vector127:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $127
80106150:	6a 7f                	push   $0x7f
  jmp alltraps
80106152:	e9 d0 f6 ff ff       	jmp    80105827 <alltraps>

80106157 <vector128>:
.globl vector128
vector128:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $128
80106159:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010615e:	e9 c4 f6 ff ff       	jmp    80105827 <alltraps>

80106163 <vector129>:
.globl vector129
vector129:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $129
80106165:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010616a:	e9 b8 f6 ff ff       	jmp    80105827 <alltraps>

8010616f <vector130>:
.globl vector130
vector130:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $130
80106171:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106176:	e9 ac f6 ff ff       	jmp    80105827 <alltraps>

8010617b <vector131>:
.globl vector131
vector131:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $131
8010617d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106182:	e9 a0 f6 ff ff       	jmp    80105827 <alltraps>

80106187 <vector132>:
.globl vector132
vector132:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $132
80106189:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010618e:	e9 94 f6 ff ff       	jmp    80105827 <alltraps>

80106193 <vector133>:
.globl vector133
vector133:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $133
80106195:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010619a:	e9 88 f6 ff ff       	jmp    80105827 <alltraps>

8010619f <vector134>:
.globl vector134
vector134:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $134
801061a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801061a6:	e9 7c f6 ff ff       	jmp    80105827 <alltraps>

801061ab <vector135>:
.globl vector135
vector135:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $135
801061ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801061b2:	e9 70 f6 ff ff       	jmp    80105827 <alltraps>

801061b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $136
801061b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801061be:	e9 64 f6 ff ff       	jmp    80105827 <alltraps>

801061c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $137
801061c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801061ca:	e9 58 f6 ff ff       	jmp    80105827 <alltraps>

801061cf <vector138>:
.globl vector138
vector138:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $138
801061d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801061d6:	e9 4c f6 ff ff       	jmp    80105827 <alltraps>

801061db <vector139>:
.globl vector139
vector139:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $139
801061dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801061e2:	e9 40 f6 ff ff       	jmp    80105827 <alltraps>

801061e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $140
801061e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801061ee:	e9 34 f6 ff ff       	jmp    80105827 <alltraps>

801061f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $141
801061f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801061fa:	e9 28 f6 ff ff       	jmp    80105827 <alltraps>

801061ff <vector142>:
.globl vector142
vector142:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $142
80106201:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106206:	e9 1c f6 ff ff       	jmp    80105827 <alltraps>

8010620b <vector143>:
.globl vector143
vector143:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $143
8010620d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106212:	e9 10 f6 ff ff       	jmp    80105827 <alltraps>

80106217 <vector144>:
.globl vector144
vector144:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $144
80106219:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010621e:	e9 04 f6 ff ff       	jmp    80105827 <alltraps>

80106223 <vector145>:
.globl vector145
vector145:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $145
80106225:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010622a:	e9 f8 f5 ff ff       	jmp    80105827 <alltraps>

8010622f <vector146>:
.globl vector146
vector146:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $146
80106231:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106236:	e9 ec f5 ff ff       	jmp    80105827 <alltraps>

8010623b <vector147>:
.globl vector147
vector147:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $147
8010623d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106242:	e9 e0 f5 ff ff       	jmp    80105827 <alltraps>

80106247 <vector148>:
.globl vector148
vector148:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $148
80106249:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010624e:	e9 d4 f5 ff ff       	jmp    80105827 <alltraps>

80106253 <vector149>:
.globl vector149
vector149:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $149
80106255:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010625a:	e9 c8 f5 ff ff       	jmp    80105827 <alltraps>

8010625f <vector150>:
.globl vector150
vector150:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $150
80106261:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106266:	e9 bc f5 ff ff       	jmp    80105827 <alltraps>

8010626b <vector151>:
.globl vector151
vector151:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $151
8010626d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106272:	e9 b0 f5 ff ff       	jmp    80105827 <alltraps>

80106277 <vector152>:
.globl vector152
vector152:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $152
80106279:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010627e:	e9 a4 f5 ff ff       	jmp    80105827 <alltraps>

80106283 <vector153>:
.globl vector153
vector153:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $153
80106285:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010628a:	e9 98 f5 ff ff       	jmp    80105827 <alltraps>

8010628f <vector154>:
.globl vector154
vector154:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $154
80106291:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106296:	e9 8c f5 ff ff       	jmp    80105827 <alltraps>

8010629b <vector155>:
.globl vector155
vector155:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $155
8010629d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801062a2:	e9 80 f5 ff ff       	jmp    80105827 <alltraps>

801062a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $156
801062a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801062ae:	e9 74 f5 ff ff       	jmp    80105827 <alltraps>

801062b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $157
801062b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801062ba:	e9 68 f5 ff ff       	jmp    80105827 <alltraps>

801062bf <vector158>:
.globl vector158
vector158:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $158
801062c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801062c6:	e9 5c f5 ff ff       	jmp    80105827 <alltraps>

801062cb <vector159>:
.globl vector159
vector159:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $159
801062cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801062d2:	e9 50 f5 ff ff       	jmp    80105827 <alltraps>

801062d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $160
801062d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801062de:	e9 44 f5 ff ff       	jmp    80105827 <alltraps>

801062e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $161
801062e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801062ea:	e9 38 f5 ff ff       	jmp    80105827 <alltraps>

801062ef <vector162>:
.globl vector162
vector162:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $162
801062f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801062f6:	e9 2c f5 ff ff       	jmp    80105827 <alltraps>

801062fb <vector163>:
.globl vector163
vector163:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $163
801062fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106302:	e9 20 f5 ff ff       	jmp    80105827 <alltraps>

80106307 <vector164>:
.globl vector164
vector164:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $164
80106309:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010630e:	e9 14 f5 ff ff       	jmp    80105827 <alltraps>

80106313 <vector165>:
.globl vector165
vector165:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $165
80106315:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010631a:	e9 08 f5 ff ff       	jmp    80105827 <alltraps>

8010631f <vector166>:
.globl vector166
vector166:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $166
80106321:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106326:	e9 fc f4 ff ff       	jmp    80105827 <alltraps>

8010632b <vector167>:
.globl vector167
vector167:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $167
8010632d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106332:	e9 f0 f4 ff ff       	jmp    80105827 <alltraps>

80106337 <vector168>:
.globl vector168
vector168:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $168
80106339:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010633e:	e9 e4 f4 ff ff       	jmp    80105827 <alltraps>

80106343 <vector169>:
.globl vector169
vector169:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $169
80106345:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010634a:	e9 d8 f4 ff ff       	jmp    80105827 <alltraps>

8010634f <vector170>:
.globl vector170
vector170:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $170
80106351:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106356:	e9 cc f4 ff ff       	jmp    80105827 <alltraps>

8010635b <vector171>:
.globl vector171
vector171:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $171
8010635d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106362:	e9 c0 f4 ff ff       	jmp    80105827 <alltraps>

80106367 <vector172>:
.globl vector172
vector172:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $172
80106369:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010636e:	e9 b4 f4 ff ff       	jmp    80105827 <alltraps>

80106373 <vector173>:
.globl vector173
vector173:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $173
80106375:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010637a:	e9 a8 f4 ff ff       	jmp    80105827 <alltraps>

8010637f <vector174>:
.globl vector174
vector174:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $174
80106381:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106386:	e9 9c f4 ff ff       	jmp    80105827 <alltraps>

8010638b <vector175>:
.globl vector175
vector175:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $175
8010638d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106392:	e9 90 f4 ff ff       	jmp    80105827 <alltraps>

80106397 <vector176>:
.globl vector176
vector176:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $176
80106399:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010639e:	e9 84 f4 ff ff       	jmp    80105827 <alltraps>

801063a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $177
801063a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801063aa:	e9 78 f4 ff ff       	jmp    80105827 <alltraps>

801063af <vector178>:
.globl vector178
vector178:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $178
801063b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801063b6:	e9 6c f4 ff ff       	jmp    80105827 <alltraps>

801063bb <vector179>:
.globl vector179
vector179:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $179
801063bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801063c2:	e9 60 f4 ff ff       	jmp    80105827 <alltraps>

801063c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $180
801063c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801063ce:	e9 54 f4 ff ff       	jmp    80105827 <alltraps>

801063d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $181
801063d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801063da:	e9 48 f4 ff ff       	jmp    80105827 <alltraps>

801063df <vector182>:
.globl vector182
vector182:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $182
801063e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801063e6:	e9 3c f4 ff ff       	jmp    80105827 <alltraps>

801063eb <vector183>:
.globl vector183
vector183:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $183
801063ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801063f2:	e9 30 f4 ff ff       	jmp    80105827 <alltraps>

801063f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $184
801063f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801063fe:	e9 24 f4 ff ff       	jmp    80105827 <alltraps>

80106403 <vector185>:
.globl vector185
vector185:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $185
80106405:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010640a:	e9 18 f4 ff ff       	jmp    80105827 <alltraps>

8010640f <vector186>:
.globl vector186
vector186:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $186
80106411:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106416:	e9 0c f4 ff ff       	jmp    80105827 <alltraps>

8010641b <vector187>:
.globl vector187
vector187:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $187
8010641d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106422:	e9 00 f4 ff ff       	jmp    80105827 <alltraps>

80106427 <vector188>:
.globl vector188
vector188:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $188
80106429:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010642e:	e9 f4 f3 ff ff       	jmp    80105827 <alltraps>

80106433 <vector189>:
.globl vector189
vector189:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $189
80106435:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010643a:	e9 e8 f3 ff ff       	jmp    80105827 <alltraps>

8010643f <vector190>:
.globl vector190
vector190:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $190
80106441:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106446:	e9 dc f3 ff ff       	jmp    80105827 <alltraps>

8010644b <vector191>:
.globl vector191
vector191:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $191
8010644d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106452:	e9 d0 f3 ff ff       	jmp    80105827 <alltraps>

80106457 <vector192>:
.globl vector192
vector192:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $192
80106459:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010645e:	e9 c4 f3 ff ff       	jmp    80105827 <alltraps>

80106463 <vector193>:
.globl vector193
vector193:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $193
80106465:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010646a:	e9 b8 f3 ff ff       	jmp    80105827 <alltraps>

8010646f <vector194>:
.globl vector194
vector194:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $194
80106471:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106476:	e9 ac f3 ff ff       	jmp    80105827 <alltraps>

8010647b <vector195>:
.globl vector195
vector195:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $195
8010647d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106482:	e9 a0 f3 ff ff       	jmp    80105827 <alltraps>

80106487 <vector196>:
.globl vector196
vector196:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $196
80106489:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010648e:	e9 94 f3 ff ff       	jmp    80105827 <alltraps>

80106493 <vector197>:
.globl vector197
vector197:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $197
80106495:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010649a:	e9 88 f3 ff ff       	jmp    80105827 <alltraps>

8010649f <vector198>:
.globl vector198
vector198:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $198
801064a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801064a6:	e9 7c f3 ff ff       	jmp    80105827 <alltraps>

801064ab <vector199>:
.globl vector199
vector199:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $199
801064ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801064b2:	e9 70 f3 ff ff       	jmp    80105827 <alltraps>

801064b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $200
801064b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801064be:	e9 64 f3 ff ff       	jmp    80105827 <alltraps>

801064c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $201
801064c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801064ca:	e9 58 f3 ff ff       	jmp    80105827 <alltraps>

801064cf <vector202>:
.globl vector202
vector202:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $202
801064d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801064d6:	e9 4c f3 ff ff       	jmp    80105827 <alltraps>

801064db <vector203>:
.globl vector203
vector203:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $203
801064dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801064e2:	e9 40 f3 ff ff       	jmp    80105827 <alltraps>

801064e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $204
801064e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801064ee:	e9 34 f3 ff ff       	jmp    80105827 <alltraps>

801064f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $205
801064f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801064fa:	e9 28 f3 ff ff       	jmp    80105827 <alltraps>

801064ff <vector206>:
.globl vector206
vector206:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $206
80106501:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106506:	e9 1c f3 ff ff       	jmp    80105827 <alltraps>

8010650b <vector207>:
.globl vector207
vector207:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $207
8010650d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106512:	e9 10 f3 ff ff       	jmp    80105827 <alltraps>

80106517 <vector208>:
.globl vector208
vector208:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $208
80106519:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010651e:	e9 04 f3 ff ff       	jmp    80105827 <alltraps>

80106523 <vector209>:
.globl vector209
vector209:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $209
80106525:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010652a:	e9 f8 f2 ff ff       	jmp    80105827 <alltraps>

8010652f <vector210>:
.globl vector210
vector210:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $210
80106531:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106536:	e9 ec f2 ff ff       	jmp    80105827 <alltraps>

8010653b <vector211>:
.globl vector211
vector211:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $211
8010653d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106542:	e9 e0 f2 ff ff       	jmp    80105827 <alltraps>

80106547 <vector212>:
.globl vector212
vector212:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $212
80106549:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010654e:	e9 d4 f2 ff ff       	jmp    80105827 <alltraps>

80106553 <vector213>:
.globl vector213
vector213:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $213
80106555:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010655a:	e9 c8 f2 ff ff       	jmp    80105827 <alltraps>

8010655f <vector214>:
.globl vector214
vector214:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $214
80106561:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106566:	e9 bc f2 ff ff       	jmp    80105827 <alltraps>

8010656b <vector215>:
.globl vector215
vector215:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $215
8010656d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106572:	e9 b0 f2 ff ff       	jmp    80105827 <alltraps>

80106577 <vector216>:
.globl vector216
vector216:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $216
80106579:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010657e:	e9 a4 f2 ff ff       	jmp    80105827 <alltraps>

80106583 <vector217>:
.globl vector217
vector217:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $217
80106585:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010658a:	e9 98 f2 ff ff       	jmp    80105827 <alltraps>

8010658f <vector218>:
.globl vector218
vector218:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $218
80106591:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106596:	e9 8c f2 ff ff       	jmp    80105827 <alltraps>

8010659b <vector219>:
.globl vector219
vector219:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $219
8010659d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801065a2:	e9 80 f2 ff ff       	jmp    80105827 <alltraps>

801065a7 <vector220>:
.globl vector220
vector220:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $220
801065a9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801065ae:	e9 74 f2 ff ff       	jmp    80105827 <alltraps>

801065b3 <vector221>:
.globl vector221
vector221:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $221
801065b5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801065ba:	e9 68 f2 ff ff       	jmp    80105827 <alltraps>

801065bf <vector222>:
.globl vector222
vector222:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $222
801065c1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801065c6:	e9 5c f2 ff ff       	jmp    80105827 <alltraps>

801065cb <vector223>:
.globl vector223
vector223:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $223
801065cd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801065d2:	e9 50 f2 ff ff       	jmp    80105827 <alltraps>

801065d7 <vector224>:
.globl vector224
vector224:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $224
801065d9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801065de:	e9 44 f2 ff ff       	jmp    80105827 <alltraps>

801065e3 <vector225>:
.globl vector225
vector225:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $225
801065e5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801065ea:	e9 38 f2 ff ff       	jmp    80105827 <alltraps>

801065ef <vector226>:
.globl vector226
vector226:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $226
801065f1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801065f6:	e9 2c f2 ff ff       	jmp    80105827 <alltraps>

801065fb <vector227>:
.globl vector227
vector227:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $227
801065fd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106602:	e9 20 f2 ff ff       	jmp    80105827 <alltraps>

80106607 <vector228>:
.globl vector228
vector228:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $228
80106609:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010660e:	e9 14 f2 ff ff       	jmp    80105827 <alltraps>

80106613 <vector229>:
.globl vector229
vector229:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $229
80106615:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010661a:	e9 08 f2 ff ff       	jmp    80105827 <alltraps>

8010661f <vector230>:
.globl vector230
vector230:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $230
80106621:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106626:	e9 fc f1 ff ff       	jmp    80105827 <alltraps>

8010662b <vector231>:
.globl vector231
vector231:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $231
8010662d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106632:	e9 f0 f1 ff ff       	jmp    80105827 <alltraps>

80106637 <vector232>:
.globl vector232
vector232:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $232
80106639:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010663e:	e9 e4 f1 ff ff       	jmp    80105827 <alltraps>

80106643 <vector233>:
.globl vector233
vector233:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $233
80106645:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010664a:	e9 d8 f1 ff ff       	jmp    80105827 <alltraps>

8010664f <vector234>:
.globl vector234
vector234:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $234
80106651:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106656:	e9 cc f1 ff ff       	jmp    80105827 <alltraps>

8010665b <vector235>:
.globl vector235
vector235:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $235
8010665d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106662:	e9 c0 f1 ff ff       	jmp    80105827 <alltraps>

80106667 <vector236>:
.globl vector236
vector236:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $236
80106669:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010666e:	e9 b4 f1 ff ff       	jmp    80105827 <alltraps>

80106673 <vector237>:
.globl vector237
vector237:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $237
80106675:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010667a:	e9 a8 f1 ff ff       	jmp    80105827 <alltraps>

8010667f <vector238>:
.globl vector238
vector238:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $238
80106681:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106686:	e9 9c f1 ff ff       	jmp    80105827 <alltraps>

8010668b <vector239>:
.globl vector239
vector239:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $239
8010668d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106692:	e9 90 f1 ff ff       	jmp    80105827 <alltraps>

80106697 <vector240>:
.globl vector240
vector240:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $240
80106699:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010669e:	e9 84 f1 ff ff       	jmp    80105827 <alltraps>

801066a3 <vector241>:
.globl vector241
vector241:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $241
801066a5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801066aa:	e9 78 f1 ff ff       	jmp    80105827 <alltraps>

801066af <vector242>:
.globl vector242
vector242:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $242
801066b1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801066b6:	e9 6c f1 ff ff       	jmp    80105827 <alltraps>

801066bb <vector243>:
.globl vector243
vector243:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $243
801066bd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801066c2:	e9 60 f1 ff ff       	jmp    80105827 <alltraps>

801066c7 <vector244>:
.globl vector244
vector244:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $244
801066c9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801066ce:	e9 54 f1 ff ff       	jmp    80105827 <alltraps>

801066d3 <vector245>:
.globl vector245
vector245:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $245
801066d5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801066da:	e9 48 f1 ff ff       	jmp    80105827 <alltraps>

801066df <vector246>:
.globl vector246
vector246:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $246
801066e1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801066e6:	e9 3c f1 ff ff       	jmp    80105827 <alltraps>

801066eb <vector247>:
.globl vector247
vector247:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $247
801066ed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801066f2:	e9 30 f1 ff ff       	jmp    80105827 <alltraps>

801066f7 <vector248>:
.globl vector248
vector248:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $248
801066f9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801066fe:	e9 24 f1 ff ff       	jmp    80105827 <alltraps>

80106703 <vector249>:
.globl vector249
vector249:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $249
80106705:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010670a:	e9 18 f1 ff ff       	jmp    80105827 <alltraps>

8010670f <vector250>:
.globl vector250
vector250:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $250
80106711:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106716:	e9 0c f1 ff ff       	jmp    80105827 <alltraps>

8010671b <vector251>:
.globl vector251
vector251:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $251
8010671d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106722:	e9 00 f1 ff ff       	jmp    80105827 <alltraps>

80106727 <vector252>:
.globl vector252
vector252:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $252
80106729:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010672e:	e9 f4 f0 ff ff       	jmp    80105827 <alltraps>

80106733 <vector253>:
.globl vector253
vector253:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $253
80106735:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010673a:	e9 e8 f0 ff ff       	jmp    80105827 <alltraps>

8010673f <vector254>:
.globl vector254
vector254:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $254
80106741:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106746:	e9 dc f0 ff ff       	jmp    80105827 <alltraps>

8010674b <vector255>:
.globl vector255
vector255:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $255
8010674d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106752:	e9 d0 f0 ff ff       	jmp    80105827 <alltraps>
80106757:	66 90                	xchg   %ax,%ax
80106759:	66 90                	xchg   %ax,%ax
8010675b:	66 90                	xchg   %ax,%ax
8010675d:	66 90                	xchg   %ax,%ax
8010675f:	90                   	nop

80106760 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	57                   	push   %edi
80106764:	56                   	push   %esi
80106765:	53                   	push   %ebx
80106766:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106768:	c1 ea 16             	shr    $0x16,%edx
8010676b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010676e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106771:	8b 07                	mov    (%edi),%eax
80106773:	a8 01                	test   $0x1,%al
80106775:	74 29                	je     801067a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106777:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010677c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106782:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106785:	c1 eb 0a             	shr    $0xa,%ebx
80106788:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010678e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106791:	5b                   	pop    %ebx
80106792:	5e                   	pop    %esi
80106793:	5f                   	pop    %edi
80106794:	5d                   	pop    %ebp
80106795:	c3                   	ret    
80106796:	8d 76 00             	lea    0x0(%esi),%esi
80106799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801067a0:	85 c9                	test   %ecx,%ecx
801067a2:	74 2c                	je     801067d0 <walkpgdir+0x70>
801067a4:	e8 e7 bc ff ff       	call   80102490 <kalloc>
801067a9:	85 c0                	test   %eax,%eax
801067ab:	89 c6                	mov    %eax,%esi
801067ad:	74 21                	je     801067d0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801067af:	83 ec 04             	sub    $0x4,%esp
801067b2:	68 00 10 00 00       	push   $0x1000
801067b7:	6a 00                	push   $0x0
801067b9:	50                   	push   %eax
801067ba:	e8 11 dd ff ff       	call   801044d0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801067bf:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801067c5:	83 c4 10             	add    $0x10,%esp
801067c8:	83 c8 07             	or     $0x7,%eax
801067cb:	89 07                	mov    %eax,(%edi)
801067cd:	eb b3                	jmp    80106782 <walkpgdir+0x22>
801067cf:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
801067d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801067d3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801067d5:	5b                   	pop    %ebx
801067d6:	5e                   	pop    %esi
801067d7:	5f                   	pop    %edi
801067d8:	5d                   	pop    %ebp
801067d9:	c3                   	ret    
801067da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	57                   	push   %edi
801067e4:	56                   	push   %esi
801067e5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801067e6:	89 d3                	mov    %edx,%ebx
801067e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067ee:	83 ec 1c             	sub    $0x1c,%esp
801067f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067f4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801067f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801067fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106800:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106803:	8b 45 0c             	mov    0xc(%ebp),%eax
80106806:	29 df                	sub    %ebx,%edi
80106808:	83 c8 01             	or     $0x1,%eax
8010680b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010680e:	eb 15                	jmp    80106825 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106810:	f6 00 01             	testb  $0x1,(%eax)
80106813:	75 45                	jne    8010685a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106815:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106818:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010681b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010681d:	74 31                	je     80106850 <mappages+0x70>
      break;
    a += PGSIZE;
8010681f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106828:	b9 01 00 00 00       	mov    $0x1,%ecx
8010682d:	89 da                	mov    %ebx,%edx
8010682f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106832:	e8 29 ff ff ff       	call   80106760 <walkpgdir>
80106837:	85 c0                	test   %eax,%eax
80106839:	75 d5                	jne    80106810 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010683b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010683e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106843:	5b                   	pop    %ebx
80106844:	5e                   	pop    %esi
80106845:	5f                   	pop    %edi
80106846:	5d                   	pop    %ebp
80106847:	c3                   	ret    
80106848:	90                   	nop
80106849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106850:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106853:	31 c0                	xor    %eax,%eax
}
80106855:	5b                   	pop    %ebx
80106856:	5e                   	pop    %esi
80106857:	5f                   	pop    %edi
80106858:	5d                   	pop    %ebp
80106859:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010685a:	83 ec 0c             	sub    $0xc,%esp
8010685d:	68 5c 83 10 80       	push   $0x8010835c
80106862:	e8 09 9b ff ff       	call   80100370 <panic>
80106867:	89 f6                	mov    %esi,%esi
80106869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106870 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	57                   	push   %edi
80106874:	56                   	push   %esi
80106875:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106876:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010687c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010687e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106884:	83 ec 1c             	sub    $0x1c,%esp
80106887:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010688a:	39 d3                	cmp    %edx,%ebx
8010688c:	73 66                	jae    801068f4 <deallocuvm.part.0+0x84>
8010688e:	89 d6                	mov    %edx,%esi
80106890:	eb 3d                	jmp    801068cf <deallocuvm.part.0+0x5f>
80106892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106898:	8b 10                	mov    (%eax),%edx
8010689a:	f6 c2 01             	test   $0x1,%dl
8010689d:	74 26                	je     801068c5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010689f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801068a5:	74 58                	je     801068ff <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801068a7:	83 ec 0c             	sub    $0xc,%esp
801068aa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801068b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068b3:	52                   	push   %edx
801068b4:	e8 27 ba ff ff       	call   801022e0 <kfree>
      *pte = 0;
801068b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068bc:	83 c4 10             	add    $0x10,%esp
801068bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068cb:	39 f3                	cmp    %esi,%ebx
801068cd:	73 25                	jae    801068f4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801068cf:	31 c9                	xor    %ecx,%ecx
801068d1:	89 da                	mov    %ebx,%edx
801068d3:	89 f8                	mov    %edi,%eax
801068d5:	e8 86 fe ff ff       	call   80106760 <walkpgdir>
    if(!pte)
801068da:	85 c0                	test   %eax,%eax
801068dc:	75 ba                	jne    80106898 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068de:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801068e4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068f0:	39 f3                	cmp    %esi,%ebx
801068f2:	72 db                	jb     801068cf <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801068f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068fa:	5b                   	pop    %ebx
801068fb:	5e                   	pop    %esi
801068fc:	5f                   	pop    %edi
801068fd:	5d                   	pop    %ebp
801068fe:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801068ff:	83 ec 0c             	sub    $0xc,%esp
80106902:	68 e6 7c 10 80       	push   $0x80107ce6
80106907:	e8 64 9a ff ff       	call   80100370 <panic>
8010690c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106910 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106916:	e8 c5 ce ff ff       	call   801037e0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010691b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106921:	31 c9                	xor    %ecx,%ecx
80106923:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106928:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
8010692f:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106936:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010693b:	31 c9                	xor    %ecx,%ecx
8010693d:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106944:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106949:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106950:	31 c9                	xor    %ecx,%ecx
80106952:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80106959:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106960:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106965:	31 c9                	xor    %ecx,%ecx
80106967:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010696e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106975:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010697a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80106981:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80106988:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010698f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
80106996:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
8010699d:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
801069a4:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069ab:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
801069b2:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
801069b9:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
801069c0:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069c7:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
801069ce:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
801069d5:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
801069dc:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
801069e3:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801069ea:	05 f0 37 11 80       	add    $0x801137f0,%eax
801069ef:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801069f3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801069f7:	c1 e8 10             	shr    $0x10,%eax
801069fa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801069fe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a01:	0f 01 10             	lgdtl  (%eax)
}
80106a04:	c9                   	leave  
80106a05:	c3                   	ret    
80106a06:	8d 76 00             	lea    0x0(%esi),%esi
80106a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a10 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a10:	a1 f4 30 12 80       	mov    0x801230f4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106a15:	55                   	push   %ebp
80106a16:	89 e5                	mov    %esp,%ebp
80106a18:	05 00 00 00 80       	add    $0x80000000,%eax
80106a1d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106a20:	5d                   	pop    %ebp
80106a21:	c3                   	ret    
80106a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a30 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	57                   	push   %edi
80106a34:	56                   	push   %esi
80106a35:	53                   	push   %ebx
80106a36:	83 ec 1c             	sub    $0x1c,%esp
80106a39:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a3c:	85 f6                	test   %esi,%esi
80106a3e:	0f 84 cd 00 00 00    	je     80106b11 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106a44:	8b 46 08             	mov    0x8(%esi),%eax
80106a47:	85 c0                	test   %eax,%eax
80106a49:	0f 84 dc 00 00 00    	je     80106b2b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106a4f:	8b 7e 04             	mov    0x4(%esi),%edi
80106a52:	85 ff                	test   %edi,%edi
80106a54:	0f 84 c4 00 00 00    	je     80106b1e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80106a5a:	e8 c1 d8 ff ff       	call   80104320 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a5f:	e8 fc cc ff ff       	call   80103760 <mycpu>
80106a64:	89 c3                	mov    %eax,%ebx
80106a66:	e8 f5 cc ff ff       	call   80103760 <mycpu>
80106a6b:	89 c7                	mov    %eax,%edi
80106a6d:	e8 ee cc ff ff       	call   80103760 <mycpu>
80106a72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a75:	83 c7 08             	add    $0x8,%edi
80106a78:	e8 e3 cc ff ff       	call   80103760 <mycpu>
80106a7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a80:	83 c0 08             	add    $0x8,%eax
80106a83:	ba 67 00 00 00       	mov    $0x67,%edx
80106a88:	c1 e8 18             	shr    $0x18,%eax
80106a8b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106a92:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106a99:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106aa0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106aa7:	83 c1 08             	add    $0x8,%ecx
80106aaa:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106ab0:	c1 e9 10             	shr    $0x10,%ecx
80106ab3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ab9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106abe:	e8 9d cc ff ff       	call   80103760 <mycpu>
80106ac3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106aca:	e8 91 cc ff ff       	call   80103760 <mycpu>
80106acf:	b9 10 00 00 00       	mov    $0x10,%ecx
80106ad4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ad8:	e8 83 cc ff ff       	call   80103760 <mycpu>
80106add:	8b 56 08             	mov    0x8(%esi),%edx
80106ae0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106ae6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ae9:	e8 72 cc ff ff       	call   80103760 <mycpu>
80106aee:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106af2:	b8 28 00 00 00       	mov    $0x28,%eax
80106af7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106afa:	8b 46 04             	mov    0x4(%esi),%eax
80106afd:	05 00 00 00 80       	add    $0x80000000,%eax
80106b02:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b08:	5b                   	pop    %ebx
80106b09:	5e                   	pop    %esi
80106b0a:	5f                   	pop    %edi
80106b0b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106b0c:	e9 ff d8 ff ff       	jmp    80104410 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106b11:	83 ec 0c             	sub    $0xc,%esp
80106b14:	68 62 83 10 80       	push   $0x80108362
80106b19:	e8 52 98 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106b1e:	83 ec 0c             	sub    $0xc,%esp
80106b21:	68 8d 83 10 80       	push   $0x8010838d
80106b26:	e8 45 98 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106b2b:	83 ec 0c             	sub    $0xc,%esp
80106b2e:	68 78 83 10 80       	push   $0x80108378
80106b33:	e8 38 98 ff ff       	call   80100370 <panic>
80106b38:	90                   	nop
80106b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b40 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	53                   	push   %ebx
80106b46:	83 ec 1c             	sub    $0x1c,%esp
80106b49:	8b 75 10             	mov    0x10(%ebp),%esi
80106b4c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b4f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106b52:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106b58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106b5b:	77 49                	ja     80106ba6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106b5d:	e8 2e b9 ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
80106b62:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106b65:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b67:	68 00 10 00 00       	push   $0x1000
80106b6c:	6a 00                	push   $0x0
80106b6e:	50                   	push   %eax
80106b6f:	e8 5c d9 ff ff       	call   801044d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b74:	58                   	pop    %eax
80106b75:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b7b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b80:	5a                   	pop    %edx
80106b81:	6a 06                	push   $0x6
80106b83:	50                   	push   %eax
80106b84:	31 d2                	xor    %edx,%edx
80106b86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b89:	e8 52 fc ff ff       	call   801067e0 <mappages>
  memmove(mem, init, sz);
80106b8e:	89 75 10             	mov    %esi,0x10(%ebp)
80106b91:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b94:	83 c4 10             	add    $0x10,%esp
80106b97:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b9d:	5b                   	pop    %ebx
80106b9e:	5e                   	pop    %esi
80106b9f:	5f                   	pop    %edi
80106ba0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106ba1:	e9 da d9 ff ff       	jmp    80104580 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106ba6:	83 ec 0c             	sub    $0xc,%esp
80106ba9:	68 a1 83 10 80       	push   $0x801083a1
80106bae:	e8 bd 97 ff ff       	call   80100370 <panic>
80106bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bc0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	53                   	push   %ebx
80106bc6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106bc9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106bd0:	0f 85 91 00 00 00    	jne    80106c67 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106bd6:	8b 75 18             	mov    0x18(%ebp),%esi
80106bd9:	31 db                	xor    %ebx,%ebx
80106bdb:	85 f6                	test   %esi,%esi
80106bdd:	75 1a                	jne    80106bf9 <loaduvm+0x39>
80106bdf:	eb 6f                	jmp    80106c50 <loaduvm+0x90>
80106be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106be8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106bf4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106bf7:	76 57                	jbe    80106c50 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80106bff:	31 c9                	xor    %ecx,%ecx
80106c01:	01 da                	add    %ebx,%edx
80106c03:	e8 58 fb ff ff       	call   80106760 <walkpgdir>
80106c08:	85 c0                	test   %eax,%eax
80106c0a:	74 4e                	je     80106c5a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106c0c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106c11:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106c16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106c1b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c21:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c24:	01 d9                	add    %ebx,%ecx
80106c26:	05 00 00 00 80       	add    $0x80000000,%eax
80106c2b:	57                   	push   %edi
80106c2c:	51                   	push   %ecx
80106c2d:	50                   	push   %eax
80106c2e:	ff 75 10             	pushl  0x10(%ebp)
80106c31:	e8 1a ad ff ff       	call   80101950 <readi>
80106c36:	83 c4 10             	add    $0x10,%esp
80106c39:	39 c7                	cmp    %eax,%edi
80106c3b:	74 ab                	je     80106be8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106c45:	5b                   	pop    %ebx
80106c46:	5e                   	pop    %esi
80106c47:	5f                   	pop    %edi
80106c48:	5d                   	pop    %ebp
80106c49:	c3                   	ret    
80106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106c53:	31 c0                	xor    %eax,%eax
}
80106c55:	5b                   	pop    %ebx
80106c56:	5e                   	pop    %esi
80106c57:	5f                   	pop    %edi
80106c58:	5d                   	pop    %ebp
80106c59:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106c5a:	83 ec 0c             	sub    $0xc,%esp
80106c5d:	68 bb 83 10 80       	push   $0x801083bb
80106c62:	e8 09 97 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106c67:	83 ec 0c             	sub    $0xc,%esp
80106c6a:	68 d8 84 10 80       	push   $0x801084d8
80106c6f:	e8 fc 96 ff ff       	call   80100370 <panic>
80106c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c80 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 0c             	sub    $0xc,%esp
80106c89:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106c8c:	85 ff                	test   %edi,%edi
80106c8e:	0f 88 ca 00 00 00    	js     80106d5e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106c94:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106c9a:	0f 82 82 00 00 00    	jb     80106d22 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106ca0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106ca6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106cac:	39 df                	cmp    %ebx,%edi
80106cae:	77 43                	ja     80106cf3 <allocuvm+0x73>
80106cb0:	e9 bb 00 00 00       	jmp    80106d70 <allocuvm+0xf0>
80106cb5:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106cb8:	83 ec 04             	sub    $0x4,%esp
80106cbb:	68 00 10 00 00       	push   $0x1000
80106cc0:	6a 00                	push   $0x0
80106cc2:	50                   	push   %eax
80106cc3:	e8 08 d8 ff ff       	call   801044d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106cc8:	58                   	pop    %eax
80106cc9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ccf:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cd4:	5a                   	pop    %edx
80106cd5:	6a 06                	push   $0x6
80106cd7:	50                   	push   %eax
80106cd8:	89 da                	mov    %ebx,%edx
80106cda:	8b 45 08             	mov    0x8(%ebp),%eax
80106cdd:	e8 fe fa ff ff       	call   801067e0 <mappages>
80106ce2:	83 c4 10             	add    $0x10,%esp
80106ce5:	85 c0                	test   %eax,%eax
80106ce7:	78 47                	js     80106d30 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106ce9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cef:	39 df                	cmp    %ebx,%edi
80106cf1:	76 7d                	jbe    80106d70 <allocuvm+0xf0>
    mem = kalloc();
80106cf3:	e8 98 b7 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
80106cf8:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106cfa:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106cfc:	75 ba                	jne    80106cb8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106cfe:	83 ec 0c             	sub    $0xc,%esp
80106d01:	68 d9 83 10 80       	push   $0x801083d9
80106d06:	e8 55 99 ff ff       	call   80100660 <cprintf>
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d0b:	83 c4 10             	add    $0x10,%esp
80106d0e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d11:	76 4b                	jbe    80106d5e <allocuvm+0xde>
80106d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d16:	8b 45 08             	mov    0x8(%ebp),%eax
80106d19:	89 fa                	mov    %edi,%edx
80106d1b:	e8 50 fb ff ff       	call   80106870 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106d20:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d25:	5b                   	pop    %ebx
80106d26:	5e                   	pop    %esi
80106d27:	5f                   	pop    %edi
80106d28:	5d                   	pop    %ebp
80106d29:	c3                   	ret    
80106d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106d30:	83 ec 0c             	sub    $0xc,%esp
80106d33:	68 f1 83 10 80       	push   $0x801083f1
80106d38:	e8 23 99 ff ff       	call   80100660 <cprintf>
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d3d:	83 c4 10             	add    $0x10,%esp
80106d40:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d43:	76 0d                	jbe    80106d52 <allocuvm+0xd2>
80106d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d48:	8b 45 08             	mov    0x8(%ebp),%eax
80106d4b:	89 fa                	mov    %edi,%edx
80106d4d:	e8 1e fb ff ff       	call   80106870 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106d52:	83 ec 0c             	sub    $0xc,%esp
80106d55:	56                   	push   %esi
80106d56:	e8 85 b5 ff ff       	call   801022e0 <kfree>
      return 0;
80106d5b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106d61:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106d63:	5b                   	pop    %ebx
80106d64:	5e                   	pop    %esi
80106d65:	5f                   	pop    %edi
80106d66:	5d                   	pop    %ebp
80106d67:	c3                   	ret    
80106d68:	90                   	nop
80106d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106d73:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106d75:	5b                   	pop    %ebx
80106d76:	5e                   	pop    %esi
80106d77:	5f                   	pop    %edi
80106d78:	5d                   	pop    %ebp
80106d79:	c3                   	ret    
80106d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d80 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
 deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d86:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d89:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d8c:	39 d1                	cmp    %edx,%ecx
80106d8e:	73 10                	jae    80106da0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d90:	5d                   	pop    %ebp
80106d91:	e9 da fa ff ff       	jmp    80106870 <deallocuvm.part.0>
80106d96:	8d 76 00             	lea    0x0(%esi),%esi
80106d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106da0:	89 d0                	mov    %edx,%eax
80106da2:	5d                   	pop    %ebp
80106da3:	c3                   	ret    
80106da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106db0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	57                   	push   %edi
80106db4:	56                   	push   %esi
80106db5:	53                   	push   %ebx
80106db6:	83 ec 0c             	sub    $0xc,%esp
80106db9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106dbc:	85 f6                	test   %esi,%esi
80106dbe:	74 59                	je     80106e19 <freevm+0x69>
80106dc0:	31 c9                	xor    %ecx,%ecx
80106dc2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106dc7:	89 f0                	mov    %esi,%eax
80106dc9:	e8 a2 fa ff ff       	call   80106870 <deallocuvm.part.0>
80106dce:	89 f3                	mov    %esi,%ebx
80106dd0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106dd6:	eb 0f                	jmp    80106de7 <freevm+0x37>
80106dd8:	90                   	nop
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106de3:	39 fb                	cmp    %edi,%ebx
80106de5:	74 23                	je     80106e0a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106de7:	8b 03                	mov    (%ebx),%eax
80106de9:	a8 01                	test   $0x1,%al
80106deb:	74 f3                	je     80106de0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106ded:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106df2:	83 ec 0c             	sub    $0xc,%esp
80106df5:	83 c3 04             	add    $0x4,%ebx
80106df8:	05 00 00 00 80       	add    $0x80000000,%eax
80106dfd:	50                   	push   %eax
80106dfe:	e8 dd b4 ff ff       	call   801022e0 <kfree>
80106e03:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e06:	39 fb                	cmp    %edi,%ebx
80106e08:	75 dd                	jne    80106de7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106e0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e10:	5b                   	pop    %ebx
80106e11:	5e                   	pop    %esi
80106e12:	5f                   	pop    %edi
80106e13:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106e14:	e9 c7 b4 ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106e19:	83 ec 0c             	sub    $0xc,%esp
80106e1c:	68 0d 84 10 80       	push   $0x8010840d
80106e21:	e8 4a 95 ff ff       	call   80100370 <panic>
80106e26:	8d 76 00             	lea    0x0(%esi),%esi
80106e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e30 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	56                   	push   %esi
80106e34:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106e35:	e8 56 b6 ff ff       	call   80102490 <kalloc>
80106e3a:	85 c0                	test   %eax,%eax
80106e3c:	74 6a                	je     80106ea8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106e3e:	83 ec 04             	sub    $0x4,%esp
80106e41:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e43:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106e48:	68 00 10 00 00       	push   $0x1000
80106e4d:	6a 00                	push   $0x0
80106e4f:	50                   	push   %eax
80106e50:	e8 7b d6 ff ff       	call   801044d0 <memset>
80106e55:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106e58:	8b 43 04             	mov    0x4(%ebx),%eax
80106e5b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106e5e:	83 ec 08             	sub    $0x8,%esp
80106e61:	8b 13                	mov    (%ebx),%edx
80106e63:	ff 73 0c             	pushl  0xc(%ebx)
80106e66:	50                   	push   %eax
80106e67:	29 c1                	sub    %eax,%ecx
80106e69:	89 f0                	mov    %esi,%eax
80106e6b:	e8 70 f9 ff ff       	call   801067e0 <mappages>
80106e70:	83 c4 10             	add    $0x10,%esp
80106e73:	85 c0                	test   %eax,%eax
80106e75:	78 19                	js     80106e90 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e77:	83 c3 10             	add    $0x10,%ebx
80106e7a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80106e80:	75 d6                	jne    80106e58 <setupkvm+0x28>
80106e82:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106e84:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e87:	5b                   	pop    %ebx
80106e88:	5e                   	pop    %esi
80106e89:	5d                   	pop    %ebp
80106e8a:	c3                   	ret    
80106e8b:	90                   	nop
80106e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106e90:	83 ec 0c             	sub    $0xc,%esp
80106e93:	56                   	push   %esi
80106e94:	e8 17 ff ff ff       	call   80106db0 <freevm>
      return 0;
80106e99:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106e9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106e9f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106ea1:	5b                   	pop    %ebx
80106ea2:	5e                   	pop    %esi
80106ea3:	5d                   	pop    %ebp
80106ea4:	c3                   	ret    
80106ea5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106ea8:	31 c0                	xor    %eax,%eax
80106eaa:	eb d8                	jmp    80106e84 <setupkvm+0x54>
80106eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106eb0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106eb6:	e8 75 ff ff ff       	call   80106e30 <setupkvm>
80106ebb:	a3 f4 30 12 80       	mov    %eax,0x801230f4
80106ec0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ec5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106ec8:	c9                   	leave  
80106ec9:	c3                   	ret    
80106eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ed0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ed0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ed1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ed3:	89 e5                	mov    %esp,%ebp
80106ed5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106edb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ede:	e8 7d f8 ff ff       	call   80106760 <walkpgdir>
  if(pte == 0)
80106ee3:	85 c0                	test   %eax,%eax
80106ee5:	74 05                	je     80106eec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ee7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106eea:	c9                   	leave  
80106eeb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106eec:	83 ec 0c             	sub    $0xc,%esp
80106eef:	68 1e 84 10 80       	push   $0x8010841e
80106ef4:	e8 77 94 ff ff       	call   80100370 <panic>
80106ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f09:	e8 22 ff ff ff       	call   80106e30 <setupkvm>
80106f0e:	85 c0                	test   %eax,%eax
80106f10:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f13:	0f 84 b2 00 00 00    	je     80106fcb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f1c:	85 c9                	test   %ecx,%ecx
80106f1e:	0f 84 9c 00 00 00    	je     80106fc0 <copyuvm+0xc0>
80106f24:	31 f6                	xor    %esi,%esi
80106f26:	eb 4a                	jmp    80106f72 <copyuvm+0x72>
80106f28:	90                   	nop
80106f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f30:	83 ec 04             	sub    $0x4,%esp
80106f33:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106f39:	68 00 10 00 00       	push   $0x1000
80106f3e:	57                   	push   %edi
80106f3f:	50                   	push   %eax
80106f40:	e8 3b d6 ff ff       	call   80104580 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106f45:	58                   	pop    %eax
80106f46:	5a                   	pop    %edx
80106f47:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106f4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f50:	ff 75 e4             	pushl  -0x1c(%ebp)
80106f53:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f58:	52                   	push   %edx
80106f59:	89 f2                	mov    %esi,%edx
80106f5b:	e8 80 f8 ff ff       	call   801067e0 <mappages>
80106f60:	83 c4 10             	add    $0x10,%esp
80106f63:	85 c0                	test   %eax,%eax
80106f65:	78 3e                	js     80106fa5 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f67:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f6d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106f70:	76 4e                	jbe    80106fc0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f72:	8b 45 08             	mov    0x8(%ebp),%eax
80106f75:	31 c9                	xor    %ecx,%ecx
80106f77:	89 f2                	mov    %esi,%edx
80106f79:	e8 e2 f7 ff ff       	call   80106760 <walkpgdir>
80106f7e:	85 c0                	test   %eax,%eax
80106f80:	74 5a                	je     80106fdc <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106f82:	8b 18                	mov    (%eax),%ebx
80106f84:	f6 c3 01             	test   $0x1,%bl
80106f87:	74 46                	je     80106fcf <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106f89:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106f8b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106f91:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106f94:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106f9a:	e8 f1 b4 ff ff       	call   80102490 <kalloc>
80106f9f:	85 c0                	test   %eax,%eax
80106fa1:	89 c3                	mov    %eax,%ebx
80106fa3:	75 8b                	jne    80106f30 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106fa5:	83 ec 0c             	sub    $0xc,%esp
80106fa8:	ff 75 e0             	pushl  -0x20(%ebp)
80106fab:	e8 00 fe ff ff       	call   80106db0 <freevm>
  return 0;
80106fb0:	83 c4 10             	add    $0x10,%esp
80106fb3:	31 c0                	xor    %eax,%eax
}
80106fb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb8:	5b                   	pop    %ebx
80106fb9:	5e                   	pop    %esi
80106fba:	5f                   	pop    %edi
80106fbb:	5d                   	pop    %ebp
80106fbc:	c3                   	ret    
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fc6:	5b                   	pop    %ebx
80106fc7:	5e                   	pop    %esi
80106fc8:	5f                   	pop    %edi
80106fc9:	5d                   	pop    %ebp
80106fca:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106fcb:	31 c0                	xor    %eax,%eax
80106fcd:	eb e6                	jmp    80106fb5 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106fcf:	83 ec 0c             	sub    $0xc,%esp
80106fd2:	68 42 84 10 80       	push   $0x80108442
80106fd7:	e8 94 93 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106fdc:	83 ec 0c             	sub    $0xc,%esp
80106fdf:	68 28 84 10 80       	push   $0x80108428
80106fe4:	e8 87 93 ff ff       	call   80100370 <panic>
80106fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ff0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ff1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ff3:	89 e5                	mov    %esp,%ebp
80106ff5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ffe:	e8 5d f7 ff ff       	call   80106760 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107003:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107005:	89 c2                	mov    %eax,%edx
80107007:	83 e2 05             	and    $0x5,%edx
8010700a:	83 fa 05             	cmp    $0x5,%edx
8010700d:	75 11                	jne    80107020 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010700f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107014:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107015:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010701a:	c3                   	ret    
8010701b:	90                   	nop
8010701c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107020:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107022:	c9                   	leave  
80107023:	c3                   	ret    
80107024:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010702a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107030 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 1c             	sub    $0x1c,%esp
80107039:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010703c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010703f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107042:	85 db                	test   %ebx,%ebx
80107044:	75 40                	jne    80107086 <copyout+0x56>
80107046:	eb 70                	jmp    801070b8 <copyout+0x88>
80107048:	90                   	nop
80107049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107050:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107053:	89 f1                	mov    %esi,%ecx
80107055:	29 d1                	sub    %edx,%ecx
80107057:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010705d:	39 d9                	cmp    %ebx,%ecx
8010705f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107062:	29 f2                	sub    %esi,%edx
80107064:	83 ec 04             	sub    $0x4,%esp
80107067:	01 d0                	add    %edx,%eax
80107069:	51                   	push   %ecx
8010706a:	57                   	push   %edi
8010706b:	50                   	push   %eax
8010706c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010706f:	e8 0c d5 ff ff       	call   80104580 <memmove>
    len -= n;
    buf += n;
80107074:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107077:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010707a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107080:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107082:	29 cb                	sub    %ecx,%ebx
80107084:	74 32                	je     801070b8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107086:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107088:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010708b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010708e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107094:	56                   	push   %esi
80107095:	ff 75 08             	pushl  0x8(%ebp)
80107098:	e8 53 ff ff ff       	call   80106ff0 <uva2ka>
    if(pa0 == 0)
8010709d:	83 c4 10             	add    $0x10,%esp
801070a0:	85 c0                	test   %eax,%eax
801070a2:	75 ac                	jne    80107050 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801070a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801070a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801070ac:	5b                   	pop    %ebx
801070ad:	5e                   	pop    %esi
801070ae:	5f                   	pop    %edi
801070af:	5d                   	pop    %ebp
801070b0:	c3                   	ret    
801070b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801070bb:	31 c0                	xor    %eax,%eax
}
801070bd:	5b                   	pop    %ebx
801070be:	5e                   	pop    %esi
801070bf:	5f                   	pop    %edi
801070c0:	5d                   	pop    %ebp
801070c1:	c3                   	ret    
801070c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070d0 <shmeminit>:
shm_table sh_table;


void
shmeminit(void)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	56                   	push   %esi
801070d4:	53                   	push   %ebx
801070d5:	be f8 2d 12 80       	mov    $0x80122df8,%esi
801070da:	bb f4 2e 12 80       	mov    $0x80122ef4,%ebx
	int i ;
  initlock(&(sh_table.lock), "SHMEM");
801070df:	83 ec 08             	sub    $0x8,%esp
801070e2:	68 5c 84 10 80       	push   $0x8010845c
801070e7:	68 c0 2d 12 80       	push   $0x80122dc0
801070ec:	e8 6f d1 ff ff       	call   80104260 <initlock>
  acquire(&(sh_table.lock));
801070f1:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
801070f8:	e8 63 d2 ff ff       	call   80104360 <acquire>
801070fd:	83 c4 10             	add    $0x10,%esp
	for (i=0; i<SHMEM_PAGES; i++)
	{
		sh_table.shp_array[i].shmem_counter = 0;
		sh_table.shp_array[i].shmem_addr = 0;
		memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
80107100:	83 ec 04             	sub    $0x4,%esp
	int i ;
  initlock(&(sh_table.lock), "SHMEM");
  acquire(&(sh_table.lock));
	for (i=0; i<SHMEM_PAGES; i++)
	{
		sh_table.shp_array[i].shmem_counter = 0;
80107103:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		sh_table.shp_array[i].shmem_addr = 0;
80107109:	c7 46 fc 00 00 00 00 	movl   $0x0,-0x4(%esi)
		memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
80107110:	6a 10                	push   $0x10
80107112:	6a 00                	push   $0x0
80107114:	83 c6 08             	add    $0x8,%esi
80107117:	53                   	push   %ebx
80107118:	83 c3 10             	add    $0x10,%ebx
8010711b:	e8 b0 d3 ff ff       	call   801044d0 <memset>
shmeminit(void)
{
	int i ;
  initlock(&(sh_table.lock), "SHMEM");
  acquire(&(sh_table.lock));
	for (i=0; i<SHMEM_PAGES; i++)
80107120:	83 c4 10             	add    $0x10,%esp
80107123:	81 fb f4 30 12 80    	cmp    $0x801230f4,%ebx
80107129:	75 d5                	jne    80107100 <shmeminit+0x30>
	{
		sh_table.shp_array[i].shmem_counter = 0;
		sh_table.shp_array[i].shmem_addr = 0;
		memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
	}
  release(&(sh_table.lock));
8010712b:	83 ec 0c             	sub    $0xc,%esp
8010712e:	68 c0 2d 12 80       	push   $0x80122dc0
80107133:	e8 48 d3 ff ff       	call   80104480 <release>
}
80107138:	83 c4 10             	add    $0x10,%esp
8010713b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010713e:	5b                   	pop    %ebx
8010713f:	5e                   	pop    %esi
80107140:	5d                   	pop    %ebp
80107141:	c3                   	ret    
80107142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107150 <shmget>:

//na ftiaxw to orisma simfwna me auta poy theloun me typedef
void *
shmget(sh_key_t *key)
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	57                   	push   %edi
80107154:	56                   	push   %esi
80107155:	53                   	push   %ebx
80107156:	bf f4 2e 12 80       	mov    $0x80122ef4,%edi
  acquire(&(sh_table.lock));
  
  int i;
	int first_free_addr = -1;
	for (i=0;i<SHMEM_PAGES;i++)
8010715b:	31 db                	xor    %ebx,%ebx
}

//na ftiaxw to orisma simfwna me auta poy theloun me typedef
void *
shmget(sh_key_t *key)
{
8010715d:	83 ec 28             	sub    $0x28,%esp
80107160:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&(sh_table.lock));
80107163:	68 c0 2d 12 80       	push   $0x80122dc0
80107168:	e8 f3 d1 ff ff       	call   80104360 <acquire>
8010716d:	83 c4 10             	add    $0x10,%esp
  
  int i;
	int first_free_addr = -1;
80107170:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80107177:	eb 29                	jmp    801071a2 <shmget+0x52>
80107179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		{
      first_free_addr = i;
			continue;
		}

		if (strncmp(sh_table.shp_key[i].shmem_key, key, sizeof(sh_key_t)*16) == 0 )
80107180:	83 ec 04             	sub    $0x4,%esp
80107183:	6a 10                	push   $0x10
80107185:	56                   	push   %esi
80107186:	57                   	push   %edi
80107187:	e8 74 d4 ff ff       	call   80104600 <strncmp>
8010718c:	83 c4 10             	add    $0x10,%esp
8010718f:	85 c0                	test   %eax,%eax
80107191:	0f 84 81 01 00 00    	je     80107318 <shmget+0x1c8>
{
  acquire(&(sh_table.lock));
  
  int i;
	int first_free_addr = -1;
	for (i=0;i<SHMEM_PAGES;i++)
80107197:	83 c3 01             	add    $0x1,%ebx
8010719a:	83 c7 10             	add    $0x10,%edi
8010719d:	83 fb 20             	cmp    $0x20,%ebx
801071a0:	74 19                	je     801071bb <shmget+0x6b>
	{
		if (*sh_table.shp_key[i].shmem_key == 0 && first_free_addr == -1)
801071a2:	80 3f 00             	cmpb   $0x0,(%edi)
801071a5:	75 d9                	jne    80107180 <shmget+0x30>
801071a7:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
801071ab:	75 d3                	jne    80107180 <shmget+0x30>
801071ad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
{
  acquire(&(sh_table.lock));
  
  int i;
	int first_free_addr = -1;
	for (i=0;i<SHMEM_PAGES;i++)
801071b0:	83 c3 01             	add    $0x1,%ebx
801071b3:	83 c7 10             	add    $0x10,%edi
801071b6:	83 fb 20             	cmp    $0x20,%ebx
801071b9:	75 e7                	jne    801071a2 <shmget+0x52>
			panic("Max processes.\n");
    }
	}
	else
	{
		if (first_free_addr == -1)
801071bb:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
801071bf:	0f 84 ff 02 00 00    	je     801074c4 <shmget+0x374>
			panic("Full shared pages.\n");
		if ((sh_table.shp_array[first_free_addr].shmem_addr = kalloc()) == 0)
801071c5:	e8 c6 b2 ff ff       	call   80102490 <kalloc>
801071ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071cd:	83 c1 06             	add    $0x6,%ecx
801071d0:	85 c0                	test   %eax,%eax
801071d2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801071d5:	89 04 cd c4 2d 12 80 	mov    %eax,-0x7fedd23c(,%ecx,8)
801071dc:	0f 84 fc 02 00 00    	je     801074de <shmget+0x38e>
			panic("Failed to allocate.\n");
		memset(sh_table.shp_array[first_free_addr].shmem_addr, 0, PGSIZE);
801071e2:	83 ec 04             	sub    $0x4,%esp

int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
801071e5:	31 db                	xor    %ebx,%ebx
	{
		if (first_free_addr == -1)
			panic("Full shared pages.\n");
		if ((sh_table.shp_array[first_free_addr].shmem_addr = kalloc()) == 0)
			panic("Failed to allocate.\n");
		memset(sh_table.shp_array[first_free_addr].shmem_addr, 0, PGSIZE);
801071e7:	68 00 10 00 00       	push   $0x1000
801071ec:	6a 00                	push   $0x0
801071ee:	50                   	push   %eax
801071ef:	e8 dc d2 ff ff       	call   801044d0 <memset>
801071f4:	83 c4 10             	add    $0x10,%esp
801071f7:	eb 13                	jmp    8010720c <shmget+0xbc>
801071f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
80107200:	83 c3 01             	add    $0x1,%ebx
80107203:	83 fb 20             	cmp    $0x20,%ebx
80107206:	0f 84 64 01 00 00    	je     80107370 <shmget+0x220>
  {
    if (myproc()->phy_shared_page[i] == 0)
8010720c:	e8 ef c5 ff ff       	call   80103800 <myproc>
80107211:	8b 84 98 80 00 00 00 	mov    0x80(%eax,%ebx,4),%eax
80107218:	85 c0                	test   %eax,%eax
8010721a:	75 e4                	jne    80107200 <shmget+0xb0>
8010721c:	8d 43 01             	lea    0x1(%ebx),%eax
8010721f:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107224:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80107227:	c1 e0 0c             	shl    $0xc,%eax
8010722a:	29 c2                	sub    %eax,%edx
8010722c:	89 d7                	mov    %edx,%edi
			panic("Full shared pages.\n");
		if ((sh_table.shp_array[first_free_addr].shmem_addr = kalloc()) == 0)
			panic("Failed to allocate.\n");
		memset(sh_table.shp_array[first_free_addr].shmem_addr, 0, PGSIZE);
    pos = find_pos();
    myproc()->top = (void *)(KERNBASE-PGSIZE*(pos+1));
8010722e:	e8 cd c5 ff ff       	call   80103800 <myproc>
80107233:	89 78 7c             	mov    %edi,0x7c(%eax)
		if ((mappages(myproc()->pgdir, myproc()->top, PGSIZE, V2P(sh_table.shp_array[first_free_addr].shmem_addr), PTE_W|PTE_U))<0)
80107236:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107239:	8b 0c c5 c4 2d 12 80 	mov    -0x7fedd23c(,%eax,8),%ecx
80107240:	8d 99 00 00 00 80    	lea    -0x80000000(%ecx),%ebx
80107246:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80107249:	e8 b2 c5 ff ff       	call   80103800 <myproc>
8010724e:	8b 78 7c             	mov    0x7c(%eax),%edi
80107251:	e8 aa c5 ff ff       	call   80103800 <myproc>
80107256:	83 ec 08             	sub    $0x8,%esp
80107259:	8b 40 04             	mov    0x4(%eax),%eax
8010725c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107261:	6a 06                	push   $0x6
80107263:	53                   	push   %ebx
80107264:	89 fa                	mov    %edi,%edx
80107266:	e8 75 f5 ff ff       	call   801067e0 <mappages>
8010726b:	83 c4 10             	add    $0x10,%esp
8010726e:	85 c0                	test   %eax,%eax
80107270:	0f 88 5b 02 00 00    	js     801074d1 <shmget+0x381>
			panic("Failed to map page.\n"); 

		memmove(sh_table.shp_key[first_free_addr].shmem_key , key, strlen(key)); 
80107276:	83 ec 0c             	sub    $0xc,%esp
80107279:	56                   	push   %esi
8010727a:	e8 91 d4 ff ff       	call   80104710 <strlen>
8010727f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107282:	83 c4 0c             	add    $0xc,%esp
80107285:	50                   	push   %eax
80107286:	56                   	push   %esi
80107287:	c1 e1 04             	shl    $0x4,%ecx
8010728a:	89 cf                	mov    %ecx,%edi
8010728c:	81 c7 f4 2e 12 80    	add    $0x80122ef4,%edi
80107292:	57                   	push   %edi
80107293:	e8 e8 d2 ff ff       	call   80104580 <memmove>
    memmove(myproc()->p_key[pos].keys, key, strlen(key)); 
80107298:	89 34 24             	mov    %esi,(%esp)
8010729b:	e8 70 d4 ff ff       	call   80104710 <strlen>
801072a0:	89 c3                	mov    %eax,%ebx
801072a2:	e8 59 c5 ff ff       	call   80103800 <myproc>
801072a7:	83 c4 0c             	add    $0xc,%esp
801072aa:	53                   	push   %ebx
801072ab:	56                   	push   %esi
801072ac:	8b 75 dc             	mov    -0x24(%ebp),%esi
801072af:	8d 56 18             	lea    0x18(%esi),%edx
801072b2:	c1 e2 04             	shl    $0x4,%edx
801072b5:	01 d0                	add    %edx,%eax
801072b7:	50                   	push   %eax
801072b8:	e8 c3 d2 ff ff       	call   80104580 <memmove>
		sh_table.shp_array[first_free_addr].shmem_counter++;
801072bd:	8b 7d e0             	mov    -0x20(%ebp),%edi
801072c0:	83 04 fd c8 2d 12 80 	addl   $0x1,-0x7fedd238(,%edi,8)
801072c7:	01 
		temp = myproc()->top;
801072c8:	e8 33 c5 ff ff       	call   80103800 <myproc>
801072cd:	8b 58 7c             	mov    0x7c(%eax),%ebx
    myproc()->bitmap[pos] = 1;
801072d0:	e8 2b c5 ff ff       	call   80103800 <myproc>
801072d5:	c6 84 30 80 03 00 00 	movb   $0x1,0x380(%eax,%esi,1)
801072dc:	01 
    myproc()->phy_shared_page[pos] = sh_table.shp_array[first_free_addr].shmem_addr;
801072dd:	e8 1e c5 ff ff       	call   80103800 <myproc>
801072e2:	8b 14 fd c4 2d 12 80 	mov    -0x7fedd23c(,%edi,8),%edx
801072e9:	89 94 b0 80 00 00 00 	mov    %edx,0x80(%eax,%esi,4)
    myproc()->vm_shared_page[pos] = temp;
801072f0:	e8 0b c5 ff ff       	call   80103800 <myproc>
801072f5:	89 9c b0 00 01 00 00 	mov    %ebx,0x100(%eax,%esi,4)

    release(&(sh_table.lock));
801072fc:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
80107303:	e8 78 d1 ff ff       	call   80104480 <release>
		return temp;
80107308:	83 c4 10             	add    $0x10,%esp
	}

	return (void *) 0xffffffff;					//Error
}
8010730b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    myproc()->bitmap[pos] = 1;
    myproc()->phy_shared_page[pos] = sh_table.shp_array[first_free_addr].shmem_addr;
    myproc()->vm_shared_page[pos] = temp;

    release(&(sh_table.lock));
		return temp;
8010730e:	89 d8                	mov    %ebx,%eax
	}

	return (void *) 0xffffffff;					//Error
}
80107310:	5b                   	pop    %ebx
80107311:	5e                   	pop    %esi
80107312:	5f                   	pop    %edi
80107313:	5d                   	pop    %ebp
80107314:	c3                   	ret    
80107315:	8d 76 00             	lea    0x0(%esi),%esi
80107318:	31 ff                	xor    %edi,%edi
8010731a:	eb 0c                	jmp    80107328 <shmget+0x1d8>
8010731c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	void * temp;
  int pos;
	if (i<SHMEM_PAGES)
	{
    int y;
    for (y=0;y<SHMEM_PAGES;y++)
80107320:	83 c7 01             	add    $0x1,%edi
80107323:	83 ff 20             	cmp    $0x20,%edi
80107326:	74 60                	je     80107388 <shmget+0x238>
    {
      if (strncmp(myproc()->p_key[y].keys, key, sizeof(sh_key_t)*16) == 0)    //ask for same page , same process
80107328:	e8 d3 c4 ff ff       	call   80103800 <myproc>
8010732d:	8d 57 18             	lea    0x18(%edi),%edx
80107330:	83 ec 04             	sub    $0x4,%esp
80107333:	6a 10                	push   $0x10
80107335:	56                   	push   %esi
80107336:	c1 e2 04             	shl    $0x4,%edx
80107339:	01 d0                	add    %edx,%eax
8010733b:	50                   	push   %eax
8010733c:	e8 bf d2 ff ff       	call   80104600 <strncmp>
80107341:	83 c4 10             	add    $0x10,%esp
80107344:	85 c0                	test   %eax,%eax
80107346:	75 d8                	jne    80107320 <shmget+0x1d0>
      {
        release(&(sh_table.lock));
80107348:	83 ec 0c             	sub    $0xc,%esp
8010734b:	68 c0 2d 12 80       	push   $0x80122dc0
80107350:	e8 2b d1 ff ff       	call   80104480 <release>
        return myproc()->vm_shared_page[y];
80107355:	e8 a6 c4 ff ff       	call   80103800 <myproc>
8010735a:	83 c4 10             	add    $0x10,%esp
8010735d:	8b 84 b8 00 01 00 00 	mov    0x100(%eax,%edi,4),%eax
    release(&(sh_table.lock));
		return temp;
	}

	return (void *) 0xffffffff;					//Error
}
80107364:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107367:	5b                   	pop    %ebx
80107368:	5e                   	pop    %esi
80107369:	5f                   	pop    %edi
8010736a:	5d                   	pop    %ebp
8010736b:	c3                   	ret    
8010736c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
80107370:	bf 00 00 00 80       	mov    $0x80000000,%edi
  {
    if (myproc()->phy_shared_page[i] == 0)
      return i;
  }
  return -1;
80107375:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
8010737c:	e9 ad fe ff ff       	jmp    8010722e <shmget+0xde>
80107381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        release(&(sh_table.lock));
        return myproc()->vm_shared_page[y];
        //panic("Request for same page in process.\n");
      }
    }
		if (sh_table.shp_array[i].shmem_counter < 16)
80107388:	83 c3 06             	add    $0x6,%ebx
8010738b:	83 3c dd c8 2d 12 80 	cmpl   $0xf,-0x7fedd238(,%ebx,8)
80107392:	0f 
80107393:	0f 8f 12 01 00 00    	jg     801074ab <shmget+0x35b>
80107399:	31 ff                	xor    %edi,%edi
8010739b:	eb 0f                	jmp    801073ac <shmget+0x25c>
8010739d:	8d 76 00             	lea    0x0(%esi),%esi

int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
801073a0:	83 c7 01             	add    $0x1,%edi
801073a3:	83 ff 20             	cmp    $0x20,%edi
801073a6:	0f 84 ee 00 00 00    	je     8010749a <shmget+0x34a>
  {
    if (myproc()->phy_shared_page[i] == 0)
801073ac:	e8 4f c4 ff ff       	call   80103800 <myproc>
801073b1:	8b 94 b8 80 00 00 00 	mov    0x80(%eax,%edi,4),%edx
801073b8:	85 d2                	test   %edx,%edx
801073ba:	75 e4                	jne    801073a0 <shmget+0x250>
801073bc:	8d 47 01             	lea    0x1(%edi),%eax
801073bf:	ba 00 00 00 80       	mov    $0x80000000,%edx
801073c4:	c1 e0 0c             	shl    $0xc,%eax
801073c7:	29 c2                	sub    %eax,%edx
801073c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      }
    }
		if (sh_table.shp_array[i].shmem_counter < 16)
		{
      pos = find_pos();
      myproc()->top = (void *)(KERNBASE-PGSIZE*(pos+1));
801073cc:	e8 2f c4 ff ff       	call   80103800 <myproc>
801073d1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801073d4:	89 48 7c             	mov    %ecx,0x7c(%eax)
			if ((mappages(myproc()->pgdir, myproc()->top, PGSIZE, V2P(sh_table.shp_array[i].shmem_addr), PTE_W|PTE_U))<0)
801073d7:	8b 04 dd c4 2d 12 80 	mov    -0x7fedd23c(,%ebx,8),%eax
801073de:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801073e4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801073e7:	e8 14 c4 ff ff       	call   80103800 <myproc>
801073ec:	8b 50 7c             	mov    0x7c(%eax),%edx
801073ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801073f2:	e8 09 c4 ff ff       	call   80103800 <myproc>
801073f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801073fa:	83 ec 08             	sub    $0x8,%esp
801073fd:	8b 40 04             	mov    0x4(%eax),%eax
80107400:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107403:	6a 06                	push   $0x6
80107405:	51                   	push   %ecx
80107406:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010740b:	e8 d0 f3 ff ff       	call   801067e0 <mappages>
80107410:	83 c4 10             	add    $0x10,%esp
80107413:	85 c0                	test   %eax,%eax
80107415:	0f 88 b6 00 00 00    	js     801074d1 <shmget+0x381>
				panic("Failed to map page.\n");
			sh_table.shp_array[i].shmem_counter++;
8010741b:	83 04 dd c8 2d 12 80 	addl   $0x1,-0x7fedd238(,%ebx,8)
80107422:	01 
			temp = myproc()->top;
80107423:	e8 d8 c3 ff ff       	call   80103800 <myproc>
80107428:	8b 40 7c             	mov    0x7c(%eax),%eax
8010742b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      myproc()->bitmap[pos] = 1;
8010742e:	e8 cd c3 ff ff       	call   80103800 <myproc>
80107433:	c6 84 38 80 03 00 00 	movb   $0x1,0x380(%eax,%edi,1)
8010743a:	01 
      myproc()->phy_shared_page[pos] = sh_table.shp_array[i].shmem_addr;
8010743b:	e8 c0 c3 ff ff       	call   80103800 <myproc>
80107440:	8b 14 dd c4 2d 12 80 	mov    -0x7fedd23c(,%ebx,8),%edx
80107447:	89 94 b8 80 00 00 00 	mov    %edx,0x80(%eax,%edi,4)
      myproc()->vm_shared_page[pos] = temp;
8010744e:	e8 ad c3 ff ff       	call   80103800 <myproc>
80107453:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      memmove(myproc()->p_key[pos].keys, key, strlen(key)); 
80107456:	83 ec 0c             	sub    $0xc,%esp
				panic("Failed to map page.\n");
			sh_table.shp_array[i].shmem_counter++;
			temp = myproc()->top;
      myproc()->bitmap[pos] = 1;
      myproc()->phy_shared_page[pos] = sh_table.shp_array[i].shmem_addr;
      myproc()->vm_shared_page[pos] = temp;
80107459:	89 8c b8 00 01 00 00 	mov    %ecx,0x100(%eax,%edi,4)
      memmove(myproc()->p_key[pos].keys, key, strlen(key)); 
80107460:	56                   	push   %esi
80107461:	83 c7 18             	add    $0x18,%edi
80107464:	c1 e7 04             	shl    $0x4,%edi
80107467:	e8 a4 d2 ff ff       	call   80104710 <strlen>
8010746c:	89 c3                	mov    %eax,%ebx
8010746e:	e8 8d c3 ff ff       	call   80103800 <myproc>
80107473:	83 c4 0c             	add    $0xc,%esp
80107476:	01 f8                	add    %edi,%eax
80107478:	53                   	push   %ebx
80107479:	56                   	push   %esi
8010747a:	50                   	push   %eax
8010747b:	e8 00 d1 ff ff       	call   80104580 <memmove>
      
      release(&(sh_table.lock));
80107480:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
80107487:	e8 f4 cf ff ff       	call   80104480 <release>
			return temp;
8010748c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010748f:	83 c4 10             	add    $0x10,%esp
    release(&(sh_table.lock));
		return temp;
	}

	return (void *) 0xffffffff;					//Error
}
80107492:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107495:	5b                   	pop    %ebx
80107496:	5e                   	pop    %esi
80107497:	5f                   	pop    %edi
80107498:	5d                   	pop    %ebp
80107499:	c3                   	ret    

int 
find_pos()
{
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
8010749a:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  {
    if (myproc()->phy_shared_page[i] == 0)
      return i;
  }
  return -1;
801074a1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801074a6:	e9 21 ff ff ff       	jmp    801073cc <shmget+0x27c>
      release(&(sh_table.lock));
			return temp;
		}
		else
    {
      release(&(sh_table.lock));
801074ab:	83 ec 0c             	sub    $0xc,%esp
801074ae:	68 c0 2d 12 80       	push   $0x80122dc0
801074b3:	e8 c8 cf ff ff       	call   80104480 <release>
			panic("Max processes.\n");
801074b8:	c7 04 24 77 84 10 80 	movl   $0x80108477,(%esp)
801074bf:	e8 ac 8e ff ff       	call   80100370 <panic>
    }
	}
	else
	{
		if (first_free_addr == -1)
			panic("Full shared pages.\n");
801074c4:	83 ec 0c             	sub    $0xc,%esp
801074c7:	68 87 84 10 80       	push   $0x80108487
801074cc:	e8 9f 8e ff ff       	call   80100370 <panic>
		if (sh_table.shp_array[i].shmem_counter < 16)
		{
      pos = find_pos();
      myproc()->top = (void *)(KERNBASE-PGSIZE*(pos+1));
			if ((mappages(myproc()->pgdir, myproc()->top, PGSIZE, V2P(sh_table.shp_array[i].shmem_addr), PTE_W|PTE_U))<0)
				panic("Failed to map page.\n");
801074d1:	83 ec 0c             	sub    $0xc,%esp
801074d4:	68 62 84 10 80       	push   $0x80108462
801074d9:	e8 92 8e ff ff       	call   80100370 <panic>
	else
	{
		if (first_free_addr == -1)
			panic("Full shared pages.\n");
		if ((sh_table.shp_array[first_free_addr].shmem_addr = kalloc()) == 0)
			panic("Failed to allocate.\n");
801074de:	83 ec 0c             	sub    $0xc,%esp
801074e1:	68 9b 84 10 80       	push   $0x8010849b
801074e6:	e8 85 8e ff ff       	call   80100370 <panic>
801074eb:	90                   	nop
801074ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074f0 <shmrem>:



int
shmrem(sh_key_t *key)
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
801074f6:	83 ec 28             	sub    $0x28,%esp
  int i;
  acquire(&(sh_table.lock));
801074f9:	68 c0 2d 12 80       	push   $0x80122dc0
801074fe:	e8 5d ce ff ff       	call   80104360 <acquire>
  
  if (memcmp(key, "-1",sizeof(sh_key_t)*16) == 0 )
80107503:	83 c4 0c             	add    $0xc,%esp
80107506:	6a 10                	push   $0x10
80107508:	68 5d 80 10 80       	push   $0x8010805d
8010750d:	ff 75 08             	pushl  0x8(%ebp)
80107510:	e8 0b d0 ff ff       	call   80104520 <memcmp>
80107515:	83 c4 10             	add    $0x10,%esp
80107518:	85 c0                	test   %eax,%eax
8010751a:	0f 85 31 01 00 00    	jne    80107651 <shmrem+0x161>
80107520:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107527:	eb 17                	jmp    80107540 <shmrem+0x50>
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    for (i=0;i<SHMEM_PAGES;i++)
80107530:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80107534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107537:	83 f8 20             	cmp    $0x20,%eax
8010753a:	0f 84 30 02 00 00    	je     80107770 <shmrem+0x280>
    {
      if (myproc()->bitmap[i] == 1)
80107540:	e8 bb c2 ff ff       	call   80103800 <myproc>
80107545:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107548:	80 bc 08 80 03 00 00 	cmpb   $0x1,0x380(%eax,%ecx,1)
8010754f:	01 
80107550:	75 de                	jne    80107530 <shmrem+0x40>
80107552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107555:	bb f8 2d 12 80       	mov    $0x80122df8,%ebx
8010755a:	be f4 2e 12 80       	mov    $0x80122ef4,%esi
8010755f:	8d 78 20             	lea    0x20(%eax),%edi
80107562:	eb 13                	jmp    80107577 <shmrem+0x87>
80107564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107568:	83 c3 08             	add    $0x8,%ebx
      {
        int y;
        for (y= 0;y<SHMEM_PAGES;y++)
8010756b:	b8 f8 2e 12 80       	mov    $0x80122ef8,%eax
80107570:	83 c6 10             	add    $0x10,%esi
80107573:	39 d8                	cmp    %ebx,%eax
80107575:	74 b9                	je     80107530 <shmrem+0x40>
        {
          if (myproc()->phy_shared_page[i] == sh_table.shp_array[y].shmem_addr)
80107577:	e8 84 c2 ff ff       	call   80103800 <myproc>
8010757c:	8b 04 b8             	mov    (%eax,%edi,4),%eax
8010757f:	3b 43 fc             	cmp    -0x4(%ebx),%eax
80107582:	75 e4                	jne    80107568 <shmrem+0x78>
          {
            if (sh_table.shp_array[y].shmem_counter == 1)
80107584:	8b 13                	mov    (%ebx),%edx
80107586:	83 fa 01             	cmp    $0x1,%edx
80107589:	74 65                	je     801075f0 <shmrem+0x100>
              memset(sh_table.shp_key[y].shmem_key,0,sizeof(sh_key_t)*16);
              myproc()->phy_shared_page[i] = 0;
              pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[i] , 0);
              *temp = KERNBASE;
            }
            else if (sh_table.shp_array[y].shmem_counter > 1)
8010758b:	7e 43                	jle    801075d0 <shmrem+0xe0>
            {
              sh_table.shp_array[y].shmem_counter--;
8010758d:	83 ea 01             	sub    $0x1,%edx
80107590:	89 13                	mov    %edx,(%ebx)
              myproc()->phy_shared_page[i] = 0;
80107592:	e8 69 c2 ff ff       	call   80103800 <myproc>
80107597:	c7 04 b8 00 00 00 00 	movl   $0x0,(%eax,%edi,4)
              pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[i] , 0);
8010759e:	e8 5d c2 ff ff       	call   80103800 <myproc>
801075a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801075a6:	8b 94 88 00 01 00 00 	mov    0x100(%eax,%ecx,4),%edx
801075ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
801075b0:	e8 4b c2 ff ff       	call   80103800 <myproc>
801075b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801075b8:	8b 40 04             	mov    0x4(%eax),%eax
801075bb:	31 c9                	xor    %ecx,%ecx
801075bd:	e8 9e f1 ff ff       	call   80106760 <walkpgdir>
              *temp = KERNBASE;
801075c2:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
801075c8:	eb 9e                	jmp    80107568 <shmrem+0x78>
801075ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            }
            else if (sh_table.shp_array[y].shmem_counter < 0)
801075d0:	85 d2                	test   %edx,%edx
801075d2:	74 94                	je     80107568 <shmrem+0x78>
            {
              release(&(sh_table.lock));
801075d4:	83 ec 0c             	sub    $0xc,%esp
801075d7:	68 c0 2d 12 80       	push   $0x80122dc0
801075dc:	e8 9f ce ff ff       	call   80104480 <release>
              panic("ERROR negative counter %d\n");
801075e1:	c7 04 24 b0 84 10 80 	movl   $0x801084b0,(%esp)
801075e8:	e8 83 8d ff ff       	call   80100370 <panic>
801075ed:	8d 76 00             	lea    0x0(%esi),%esi
        {
          if (myproc()->phy_shared_page[i] == sh_table.shp_array[y].shmem_addr)
          {
            if (sh_table.shp_array[y].shmem_counter == 1)
            {
              kfree(sh_table.shp_array[y].shmem_addr);
801075f0:	83 ec 0c             	sub    $0xc,%esp
801075f3:	50                   	push   %eax
801075f4:	e8 e7 ac ff ff       	call   801022e0 <kfree>
              sh_table.shp_array[y].shmem_counter = 0;
              sh_table.shp_array[y].shmem_addr = 0;
              memset(sh_table.shp_key[y].shmem_key,0,sizeof(sh_key_t)*16);
801075f9:	83 c4 0c             	add    $0xc,%esp
          if (myproc()->phy_shared_page[i] == sh_table.shp_array[y].shmem_addr)
          {
            if (sh_table.shp_array[y].shmem_counter == 1)
            {
              kfree(sh_table.shp_array[y].shmem_addr);
              sh_table.shp_array[y].shmem_counter = 0;
801075fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
              sh_table.shp_array[y].shmem_addr = 0;
80107602:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
              memset(sh_table.shp_key[y].shmem_key,0,sizeof(sh_key_t)*16);
80107609:	6a 10                	push   $0x10
8010760b:	6a 00                	push   $0x0
8010760d:	56                   	push   %esi
8010760e:	e8 bd ce ff ff       	call   801044d0 <memset>
              myproc()->phy_shared_page[i] = 0;
80107613:	e8 e8 c1 ff ff       	call   80103800 <myproc>
80107618:	c7 04 b8 00 00 00 00 	movl   $0x0,(%eax,%edi,4)
              pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[i] , 0);
8010761f:	e8 dc c1 ff ff       	call   80103800 <myproc>
80107624:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107627:	8b 94 88 00 01 00 00 	mov    0x100(%eax,%ecx,4),%edx
8010762e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107631:	e8 ca c1 ff ff       	call   80103800 <myproc>
80107636:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107639:	8b 40 04             	mov    0x4(%eax),%eax
8010763c:	31 c9                	xor    %ecx,%ecx
8010763e:	e8 1d f1 ff ff       	call   80106760 <walkpgdir>
80107643:	83 c4 10             	add    $0x10,%esp
              *temp = KERNBASE;
80107646:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
8010764c:	e9 17 ff ff ff       	jmp    80107568 <shmrem+0x78>
shmrem(sh_key_t *key)
{
  int i;
  acquire(&(sh_table.lock));
  
  if (memcmp(key, "-1",sizeof(sh_key_t)*16) == 0 )
80107651:	8b 7d 08             	mov    0x8(%ebp),%edi
80107654:	c7 45 e0 f4 2e 12 80 	movl   $0x80122ef4,-0x20(%ebp)
8010765b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  }


  for (i=0;i<SHMEM_PAGES;i++)
  {
    if (strncmp(sh_table.shp_key[i].shmem_key, key, sizeof(sh_key_t)*16) == 0 )
80107662:	83 ec 04             	sub    $0x4,%esp
80107665:	6a 10                	push   $0x10
80107667:	57                   	push   %edi
80107668:	ff 75 e0             	pushl  -0x20(%ebp)
8010766b:	e8 90 cf ff ff       	call   80104600 <strncmp>
80107670:	83 c4 10             	add    $0x10,%esp
80107673:	85 c0                	test   %eax,%eax
80107675:	0f 85 c3 00 00 00    	jne    8010773e <shmrem+0x24e>
8010767b:	31 db                	xor    %ebx,%ebx
8010767d:	eb 0d                	jmp    8010768c <shmrem+0x19c>
8010767f:	90                   	nop
    {
     
      int y;
      for (y=0;y<SHMEM_PAGES;y++)
80107680:	83 c3 01             	add    $0x1,%ebx
80107683:	83 fb 20             	cmp    $0x20,%ebx
80107686:	0f 84 b2 00 00 00    	je     8010773e <shmrem+0x24e>
      {
        if (strncmp(myproc()->p_key[y].keys, key, sizeof(sh_key_t)*16) == 0 )
8010768c:	8d 73 18             	lea    0x18(%ebx),%esi
8010768f:	e8 6c c1 ff ff       	call   80103800 <myproc>
80107694:	c1 e6 04             	shl    $0x4,%esi
80107697:	83 ec 04             	sub    $0x4,%esp
8010769a:	01 f0                	add    %esi,%eax
8010769c:	6a 10                	push   $0x10
8010769e:	57                   	push   %edi
8010769f:	50                   	push   %eax
801076a0:	e8 5b cf ff ff       	call   80104600 <strncmp>
801076a5:	83 c4 10             	add    $0x10,%esp
801076a8:	85 c0                	test   %eax,%eax
801076aa:	75 d4                	jne    80107680 <shmrem+0x190>
801076ac:	89 c7                	mov    %eax,%edi
        {
          if (sh_table.shp_array[i].shmem_counter == 1)
801076ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076b1:	83 c0 06             	add    $0x6,%eax
801076b4:	8b 14 c5 c8 2d 12 80 	mov    -0x7fedd238(,%eax,8),%edx
801076bb:	83 fa 01             	cmp    $0x1,%edx
801076be:	0f 84 cb 00 00 00    	je     8010778f <shmrem+0x29f>
            release(&(sh_table.lock));
            return 0;
          }
          else
          {
            sh_table.shp_array[i].shmem_counter--;
801076c4:	83 ea 01             	sub    $0x1,%edx
801076c7:	89 14 c5 c8 2d 12 80 	mov    %edx,-0x7fedd238(,%eax,8)
            myproc()->phy_shared_page[y] = 0;
801076ce:	e8 2d c1 ff ff       	call   80103800 <myproc>
801076d3:	c7 84 98 80 00 00 00 	movl   $0x0,0x80(%eax,%ebx,4)
801076da:	00 00 00 00 
            pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[y],0);
801076de:	83 c3 40             	add    $0x40,%ebx
801076e1:	e8 1a c1 ff ff       	call   80103800 <myproc>
801076e6:	8b 3c 98             	mov    (%eax,%ebx,4),%edi
801076e9:	e8 12 c1 ff ff       	call   80103800 <myproc>
801076ee:	8b 40 04             	mov    0x4(%eax),%eax
801076f1:	31 c9                	xor    %ecx,%ecx
801076f3:	89 fa                	mov    %edi,%edx
            *temp = KERNBASE;
            myproc()->vm_shared_page[y] = 0;
            memset(myproc()->p_key[y].keys,0,sizeof(sh_key_t)*16);
            release(&(sh_table.lock));
            return 1;
801076f5:	bf 01 00 00 00       	mov    $0x1,%edi
          }
          else
          {
            sh_table.shp_array[i].shmem_counter--;
            myproc()->phy_shared_page[y] = 0;
            pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[y],0);
801076fa:	e8 61 f0 ff ff       	call   80106760 <walkpgdir>
            *temp = KERNBASE;
801076ff:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
            myproc()->vm_shared_page[y] = 0;
80107705:	e8 f6 c0 ff ff       	call   80103800 <myproc>
8010770a:	c7 04 98 00 00 00 00 	movl   $0x0,(%eax,%ebx,4)
            memset(myproc()->p_key[y].keys,0,sizeof(sh_key_t)*16);
80107711:	e8 ea c0 ff ff       	call   80103800 <myproc>
80107716:	83 ec 04             	sub    $0x4,%esp
80107719:	01 c6                	add    %eax,%esi
8010771b:	6a 10                	push   $0x10
8010771d:	6a 00                	push   $0x0
8010771f:	56                   	push   %esi
80107720:	e8 ab cd ff ff       	call   801044d0 <memset>
            release(&(sh_table.lock));
80107725:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
8010772c:	e8 4f cd ff ff       	call   80104480 <release>
            return 1;
80107731:	83 c4 10             	add    $0x10,%esp
      }
    }
  }
  release(&(sh_table.lock));
  return -1;
}
80107734:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107737:	89 f8                	mov    %edi,%eax
80107739:	5b                   	pop    %ebx
8010773a:	5e                   	pop    %esi
8010773b:	5f                   	pop    %edi
8010773c:	5d                   	pop    %ebp
8010773d:	c3                   	ret    
    release(&(sh_table.lock));
    return 1;
  }


  for (i=0;i<SHMEM_PAGES;i++)
8010773e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80107742:	83 45 e0 10          	addl   $0x10,-0x20(%ebp)
80107746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107749:	83 f8 20             	cmp    $0x20,%eax
8010774c:	0f 85 10 ff ff ff    	jne    80107662 <shmrem+0x172>
          }
        }
      }
    }
  }
  release(&(sh_table.lock));
80107752:	83 ec 0c             	sub    $0xc,%esp
  return -1;
80107755:	bf ff ff ff ff       	mov    $0xffffffff,%edi
          }
        }
      }
    }
  }
  release(&(sh_table.lock));
8010775a:	68 c0 2d 12 80       	push   $0x80122dc0
8010775f:	e8 1c cd ff ff       	call   80104480 <release>
  return -1;
80107764:	83 c4 10             	add    $0x10,%esp
80107767:	eb 1c                	jmp    80107785 <shmrem+0x295>
80107769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            }
          }
        }
      }
    }
    release(&(sh_table.lock));
80107770:	83 ec 0c             	sub    $0xc,%esp
    return 1;
80107773:	bf 01 00 00 00       	mov    $0x1,%edi
            }
          }
        }
      }
    }
    release(&(sh_table.lock));
80107778:	68 c0 2d 12 80       	push   $0x80122dc0
8010777d:	e8 fe cc ff ff       	call   80104480 <release>
    return 1;
80107782:	83 c4 10             	add    $0x10,%esp
      }
    }
  }
  release(&(sh_table.lock));
  return -1;
}
80107785:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107788:	89 f8                	mov    %edi,%eax
8010778a:	5b                   	pop    %ebx
8010778b:	5e                   	pop    %esi
8010778c:	5f                   	pop    %edi
8010778d:	5d                   	pop    %ebp
8010778e:	c3                   	ret    
      {
        if (strncmp(myproc()->p_key[y].keys, key, sizeof(sh_key_t)*16) == 0 )
        {
          if (sh_table.shp_array[i].shmem_counter == 1)
          {
            kfree(sh_table.shp_array[i].shmem_addr);
8010778f:	83 ec 0c             	sub    $0xc,%esp
80107792:	ff 34 c5 c4 2d 12 80 	pushl  -0x7fedd23c(,%eax,8)
80107799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            sh_table.shp_array[i].shmem_counter = 0;
            sh_table.shp_array[i].shmem_addr = 0;
            memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
            pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[y],0);
8010779c:	8d 73 40             	lea    0x40(%ebx),%esi
      {
        if (strncmp(myproc()->p_key[y].keys, key, sizeof(sh_key_t)*16) == 0 )
        {
          if (sh_table.shp_array[i].shmem_counter == 1)
          {
            kfree(sh_table.shp_array[i].shmem_addr);
8010779f:	e8 3c ab ff ff       	call   801022e0 <kfree>
            sh_table.shp_array[i].shmem_counter = 0;
            sh_table.shp_array[i].shmem_addr = 0;
            memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
801077a4:	83 c4 0c             	add    $0xc,%esp
        if (strncmp(myproc()->p_key[y].keys, key, sizeof(sh_key_t)*16) == 0 )
        {
          if (sh_table.shp_array[i].shmem_counter == 1)
          {
            kfree(sh_table.shp_array[i].shmem_addr);
            sh_table.shp_array[i].shmem_counter = 0;
801077a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
            sh_table.shp_array[i].shmem_addr = 0;
            memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
801077aa:	6a 10                	push   $0x10
801077ac:	6a 00                	push   $0x0
801077ae:	ff 75 e0             	pushl  -0x20(%ebp)
        if (strncmp(myproc()->p_key[y].keys, key, sizeof(sh_key_t)*16) == 0 )
        {
          if (sh_table.shp_array[i].shmem_counter == 1)
          {
            kfree(sh_table.shp_array[i].shmem_addr);
            sh_table.shp_array[i].shmem_counter = 0;
801077b1:	c7 04 c5 c8 2d 12 80 	movl   $0x0,-0x7fedd238(,%eax,8)
801077b8:	00 00 00 00 
            sh_table.shp_array[i].shmem_addr = 0;
801077bc:	c7 04 c5 c4 2d 12 80 	movl   $0x0,-0x7fedd23c(,%eax,8)
801077c3:	00 00 00 00 
            memset(sh_table.shp_key[i].shmem_key,0,sizeof(sh_key_t)*16);
801077c7:	e8 04 cd ff ff       	call   801044d0 <memset>
            pte_t *temp=walkpgdir(myproc()->pgdir,myproc()->vm_shared_page[y],0);
801077cc:	e8 2f c0 ff ff       	call   80103800 <myproc>
801077d1:	8b 14 b0             	mov    (%eax,%esi,4),%edx
801077d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801077d7:	e8 24 c0 ff ff       	call   80103800 <myproc>
801077dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801077df:	8b 40 04             	mov    0x4(%eax),%eax
801077e2:	31 c9                	xor    %ecx,%ecx
801077e4:	e8 77 ef ff ff       	call   80106760 <walkpgdir>
            *temp = KERNBASE;
801077e9:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
            myproc()->vm_shared_page[y] = 0;
801077ef:	e8 0c c0 ff ff       	call   80103800 <myproc>
801077f4:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
            myproc()->phy_shared_page[y] = 0;
801077fb:	e8 00 c0 ff ff       	call   80103800 <myproc>
80107800:	c7 84 98 80 00 00 00 	movl   $0x0,0x80(%eax,%ebx,4)
80107807:	00 00 00 00 

            release(&(sh_table.lock));
8010780b:	c7 04 24 c0 2d 12 80 	movl   $0x80122dc0,(%esp)
80107812:	e8 69 cc ff ff       	call   80104480 <release>
            return 0;
80107817:	83 c4 10             	add    $0x10,%esp
      }
    }
  }
  release(&(sh_table.lock));
  return -1;
}
8010781a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010781d:	89 f8                	mov    %edi,%eax
8010781f:	5b                   	pop    %ebx
80107820:	5e                   	pop    %esi
80107821:	5f                   	pop    %edi
80107822:	5d                   	pop    %ebp
80107823:	c3                   	ret    
80107824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010782a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107830 <find_pos>:


int 
find_pos()
{
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	53                   	push   %ebx
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
80107834:	31 db                	xor    %ebx,%ebx
}


int 
find_pos()
{
80107836:	83 ec 04             	sub    $0x4,%esp
80107839:	eb 0d                	jmp    80107848 <find_pos+0x18>
8010783b:	90                   	nop
8010783c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  for (i=0;i<SHMEM_PAGES;i++)
80107840:	83 c3 01             	add    $0x1,%ebx
80107843:	83 fb 20             	cmp    $0x20,%ebx
80107846:	74 18                	je     80107860 <find_pos+0x30>
  {
    if (myproc()->phy_shared_page[i] == 0)
80107848:	e8 b3 bf ff ff       	call   80103800 <myproc>
8010784d:	8b 84 98 80 00 00 00 	mov    0x80(%eax,%ebx,4),%eax
80107854:	85 c0                	test   %eax,%eax
80107856:	75 e8                	jne    80107840 <find_pos+0x10>
      return i;
  }
  return -1;
}
80107858:	83 c4 04             	add    $0x4,%esp
8010785b:	89 d8                	mov    %ebx,%eax
8010785d:	5b                   	pop    %ebx
8010785e:	5d                   	pop    %ebp
8010785f:	c3                   	ret    
80107860:	83 c4 04             	add    $0x4,%esp
  for (i=0;i<SHMEM_PAGES;i++)
  {
    if (myproc()->phy_shared_page[i] == 0)
      return i;
  }
  return -1;
80107863:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107868:	5b                   	pop    %ebx
80107869:	5d                   	pop    %ebp
8010786a:	c3                   	ret    
8010786b:	90                   	nop
8010786c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107870 <manage_fork>:

void
manage_fork(struct proc *p,struct proc *c)
{
80107870:	55                   	push   %ebp
80107871:	89 e5                	mov    %esp,%ebp
80107873:	57                   	push   %edi
80107874:	56                   	push   %esi
80107875:	53                   	push   %ebx
80107876:	be 01 00 00 00       	mov    $0x1,%esi
8010787b:	83 ec 1c             	sub    $0x1c,%esp
8010787e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107881:	8d 98 80 00 00 00    	lea    0x80(%eax),%ebx
80107887:	8b 45 08             	mov    0x8(%ebp),%eax
8010788a:	8d b8 80 00 00 00    	lea    0x80(%eax),%edi
80107890:	8b 45 0c             	mov    0xc(%ebp),%eax
80107893:	05 80 01 00 00       	add    $0x180,%eax
80107898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010789b:	8b 45 08             	mov    0x8(%ebp),%eax
8010789e:	05 80 01 00 00       	add    $0x180,%eax
801078a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801078a6:	eb 22                	jmp    801078ca <manage_fork+0x5a>
801078a8:	90                   	nop
801078a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078b0:	83 c6 01             	add    $0x1,%esi
801078b3:	83 c3 04             	add    $0x4,%ebx
801078b6:	83 c7 04             	add    $0x4,%edi
801078b9:	83 45 e4 10          	addl   $0x10,-0x1c(%ebp)
801078bd:	83 45 e0 10          	addl   $0x10,-0x20(%ebp)
  int i ;
  for (i=0;i<SHMEM_PAGES;i++)
801078c1:	83 fe 21             	cmp    $0x21,%esi
801078c4:	0f 84 a0 00 00 00    	je     8010796a <manage_fork+0xfa>
  {
    if (p->bitmap[i] == 1 && p->bitmap[i] != c->bitmap[i])
801078ca:	8b 45 08             	mov    0x8(%ebp),%eax
801078cd:	80 bc 30 7f 03 00 00 	cmpb   $0x1,0x37f(%eax,%esi,1)
801078d4:	01 
801078d5:	75 d9                	jne    801078b0 <manage_fork+0x40>
801078d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801078da:	80 bc 30 7f 03 00 00 	cmpb   $0x1,0x37f(%eax,%esi,1)
801078e1:	01 
801078e2:	74 cc                	je     801078b0 <manage_fork+0x40>
    {
      if (mappages(c->pgdir, (void*)(KERNBASE-((i+1)*PGSIZE)), PGSIZE, V2P(p->phy_shared_page[i]), PTE_W|PTE_U)<0)
801078e4:	83 ec 08             	sub    $0x8,%esp
801078e7:	8b 40 04             	mov    0x4(%eax),%eax
801078ea:	89 f2                	mov    %esi,%edx
801078ec:	6a 06                	push   $0x6
801078ee:	8b 0f                	mov    (%edi),%ecx
801078f0:	f7 da                	neg    %edx
801078f2:	c1 e2 0c             	shl    $0xc,%edx
801078f5:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801078fb:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80107901:	51                   	push   %ecx
80107902:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107907:	e8 d4 ee ff ff       	call   801067e0 <mappages>
8010790c:	83 c4 10             	add    $0x10,%esp
8010790f:	85 c0                	test   %eax,%eax
80107911:	78 5f                	js     80107972 <manage_fork+0x102>
        panic("Manage Fork\n");
      c->phy_shared_page[i] = p->phy_shared_page[i];
80107913:	8b 07                	mov    (%edi),%eax
      c->vm_shared_page[i] = p->vm_shared_page[i];
      memmove(c->p_key[i].keys, p->p_key[i].keys, sizeof(sh_key_t)*16);
80107915:	83 ec 04             	sub    $0x4,%esp
  {
    if (p->bitmap[i] == 1 && p->bitmap[i] != c->bitmap[i])
    {
      if (mappages(c->pgdir, (void*)(KERNBASE-((i+1)*PGSIZE)), PGSIZE, V2P(p->phy_shared_page[i]), PTE_W|PTE_U)<0)
        panic("Manage Fork\n");
      c->phy_shared_page[i] = p->phy_shared_page[i];
80107918:	89 03                	mov    %eax,(%ebx)
      c->vm_shared_page[i] = p->vm_shared_page[i];
8010791a:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80107920:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
      memmove(c->p_key[i].keys, p->p_key[i].keys, sizeof(sh_key_t)*16);
80107926:	6a 10                	push   $0x10
80107928:	ff 75 e0             	pushl  -0x20(%ebp)
8010792b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010792e:	e8 4d cc ff ff       	call   80104580 <memmove>
      c->bitmap[i] = 1;
80107933:	8b 45 0c             	mov    0xc(%ebp),%eax
80107936:	83 c4 10             	add    $0x10,%esp
80107939:	c6 84 30 7f 03 00 00 	movb   $0x1,0x37f(%eax,%esi,1)
80107940:	01 
80107941:	b8 f8 2d 12 80       	mov    $0x80122df8,%eax
80107946:	eb 16                	jmp    8010795e <manage_fork+0xee>
80107948:	90                   	nop
80107949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107950:	83 c0 08             	add    $0x8,%eax
      int y;
      for (y=0;y<SHMEM_PAGES;y++)
80107953:	3d f8 2e 12 80       	cmp    $0x80122ef8,%eax
80107958:	0f 84 52 ff ff ff    	je     801078b0 <manage_fork+0x40>
      {
        if (sh_table.shp_array[y].shmem_addr == c->phy_shared_page[i])
8010795e:	8b 0b                	mov    (%ebx),%ecx
80107960:	39 48 fc             	cmp    %ecx,-0x4(%eax)
80107963:	75 eb                	jne    80107950 <manage_fork+0xe0>
          sh_table.shp_array[y].shmem_counter++;
80107965:	83 00 01             	addl   $0x1,(%eax)
80107968:	eb e6                	jmp    80107950 <manage_fork+0xe0>

  } 



}
8010796a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010796d:	5b                   	pop    %ebx
8010796e:	5e                   	pop    %esi
8010796f:	5f                   	pop    %edi
80107970:	5d                   	pop    %ebp
80107971:	c3                   	ret    
  for (i=0;i<SHMEM_PAGES;i++)
  {
    if (p->bitmap[i] == 1 && p->bitmap[i] != c->bitmap[i])
    {
      if (mappages(c->pgdir, (void*)(KERNBASE-((i+1)*PGSIZE)), PGSIZE, V2P(p->phy_shared_page[i]), PTE_W|PTE_U)<0)
        panic("Manage Fork\n");
80107972:	83 ec 0c             	sub    $0xc,%esp
80107975:	68 cb 84 10 80       	push   $0x801084cb
8010797a:	e8 f1 89 ff ff       	call   80100370 <panic>
8010797f:	90                   	nop

80107980 <sem_init>:
// 	int value;				// value to set semaphore to
// }sem_t;

void
sem_init(sem_t *sem,int value)
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	8b 45 08             	mov    0x8(%ebp),%eax
80107986:	8b 55 0c             	mov    0xc(%ebp),%edx
	sem->maxval = value;
  	sem->value = value;
  	sem->locked = 0;
80107989:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
// }sem_t;

void
sem_init(sem_t *sem,int value)
{
	sem->maxval = value;
80107990:	89 50 38             	mov    %edx,0x38(%eax)
  	sem->value = value;
80107993:	89 50 34             	mov    %edx,0x34(%eax)
  	sem->locked = 0;
  	initlock(&(sem->lk), "sem lock");
80107996:	c7 45 0c fc 84 10 80 	movl   $0x801084fc,0xc(%ebp)
}
8010799d:	5d                   	pop    %ebp
sem_init(sem_t *sem,int value)
{
	sem->maxval = value;
  	sem->value = value;
  	sem->locked = 0;
  	initlock(&(sem->lk), "sem lock");
8010799e:	e9 bd c8 ff ff       	jmp    80104260 <initlock>
801079a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079b0 <sem_up>:
}

void
sem_up(sem_t *sem)
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	53                   	push   %ebx
801079b4:	83 ec 04             	sub    $0x4,%esp
801079b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//cprintf("acquire\n");
	//acquire(&(sem->lk));
	if (sem->locked == 1)
801079ba:	83 7b 3c 01          	cmpl   $0x1,0x3c(%ebx)
801079be:	74 08                	je     801079c8 <sem_up+0x18>
		sem->locked = 0;
		wakeup(sem);
		release(&(sem->lk));
	}
	//release(&(sem->lk));
}
801079c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801079c3:	c9                   	leave  
801079c4:	c3                   	ret    
801079c5:	8d 76 00             	lea    0x0(%esi),%esi
{
	//cprintf("acquire\n");
	//acquire(&(sem->lk));
	if (sem->locked == 1)
	{	
		acquire(&(sem->lk));
801079c8:	83 ec 0c             	sub    $0xc,%esp
801079cb:	53                   	push   %ebx
801079cc:	e8 8f c9 ff ff       	call   80104360 <acquire>
		sem->value++;
801079d1:	83 43 34 01          	addl   $0x1,0x34(%ebx)
		sem->locked = 0;
801079d5:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
		wakeup(sem);
801079dc:	89 1c 24             	mov    %ebx,(%esp)
801079df:	e8 bc c5 ff ff       	call   80103fa0 <wakeup>
		release(&(sem->lk));
801079e4:	89 5d 08             	mov    %ebx,0x8(%ebp)
801079e7:	83 c4 10             	add    $0x10,%esp
	}
	//release(&(sem->lk));
}
801079ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801079ed:	c9                   	leave  
	{	
		acquire(&(sem->lk));
		sem->value++;
		sem->locked = 0;
		wakeup(sem);
		release(&(sem->lk));
801079ee:	e9 8d ca ff ff       	jmp    80104480 <release>
801079f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a00 <sem_down>:
	//release(&(sem->lk));
}

void 
sem_down(sem_t *sem)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	53                   	push   %ebx
80107a04:	83 ec 04             	sub    $0x4,%esp
80107a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//acquire(&(sem->lk));
	if (sem->locked == 0)
80107a0a:	8b 4b 3c             	mov    0x3c(%ebx),%ecx
80107a0d:	85 c9                	test   %ecx,%ecx
80107a0f:	74 3f                	je     80107a50 <sem_down+0x50>
		sem->value--;
		release(&(sem->lk));
	}
	else
	{
		acquire(&(sem->lk));
80107a11:	83 ec 0c             	sub    $0xc,%esp
80107a14:	53                   	push   %ebx
80107a15:	e8 46 c9 ff ff       	call   80104360 <acquire>
		//cprintf("EDV\n");
		while(sem->locked)
80107a1a:	8b 53 3c             	mov    0x3c(%ebx),%edx
80107a1d:	83 c4 10             	add    $0x10,%esp
80107a20:	85 d2                	test   %edx,%edx
80107a22:	74 18                	je     80107a3c <sem_down+0x3c>
80107a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		{
    		//cprintf("HERE\n");
    		sleep(sem, &(sem->lk));
80107a28:	83 ec 08             	sub    $0x8,%esp
80107a2b:	53                   	push   %ebx
80107a2c:	53                   	push   %ebx
80107a2d:	e8 ae c3 ff ff       	call   80103de0 <sleep>
	}
	else
	{
		acquire(&(sem->lk));
		//cprintf("EDV\n");
		while(sem->locked)
80107a32:	8b 43 3c             	mov    0x3c(%ebx),%eax
80107a35:	83 c4 10             	add    $0x10,%esp
80107a38:	85 c0                	test   %eax,%eax
80107a3a:	75 ec                	jne    80107a28 <sem_down+0x28>
		{
    		//cprintf("HERE\n");
    		sleep(sem, &(sem->lk));
		}
		sem->value--;
80107a3c:	83 6b 34 01          	subl   $0x1,0x34(%ebx)
		release(&(sem->lk));
80107a40:	89 5d 08             	mov    %ebx,0x8(%ebp)
	}
}
80107a43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107a46:	c9                   	leave  
		{
    		//cprintf("HERE\n");
    		sleep(sem, &(sem->lk));
		}
		sem->value--;
		release(&(sem->lk));
80107a47:	e9 34 ca ff ff       	jmp    80104480 <release>
80107a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sem_down(sem_t *sem)
{
	//acquire(&(sem->lk));
	if (sem->locked == 0)
	{
		acquire(&(sem->lk));
80107a50:	83 ec 0c             	sub    $0xc,%esp
80107a53:	53                   	push   %ebx
80107a54:	e8 07 c9 ff ff       	call   80104360 <acquire>
		//if (sem->value -1 == 0)
	  	sem->locked = 1;
		sem->value--;
80107a59:	83 6b 34 01          	subl   $0x1,0x34(%ebx)
	//acquire(&(sem->lk));
	if (sem->locked == 0)
	{
		acquire(&(sem->lk));
		//if (sem->value -1 == 0)
	  	sem->locked = 1;
80107a5d:	c7 43 3c 01 00 00 00 	movl   $0x1,0x3c(%ebx)
		sem->value--;
		release(&(sem->lk));
80107a64:	83 c4 10             	add    $0x10,%esp
80107a67:	89 5d 08             	mov    %ebx,0x8(%ebp)
    		sleep(sem, &(sem->lk));
		}
		sem->value--;
		release(&(sem->lk));
	}
}
80107a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107a6d:	c9                   	leave  
	{
		acquire(&(sem->lk));
		//if (sem->value -1 == 0)
	  	sem->locked = 1;
		sem->value--;
		release(&(sem->lk));
80107a6e:	e9 0d ca ff ff       	jmp    80104480 <release>
