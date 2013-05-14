
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 07 34 10 80       	mov    $0x80103407,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 e8 8c 10 	movl   $0x80108ce8,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 08 55 00 00       	call   80105556 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 b0 eb 10 80 a4 	movl   $0x8010eba4,0x8010ebb0
80100055:	eb 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 b4 eb 10 80 a4 	movl   $0x8010eba4,0x8010ebb4
8010005f:	eb 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 b4 eb 10 80    	mov    0x8010ebb4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c a4 eb 10 80 	movl   $0x8010eba4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 b4 eb 10 80       	mov    %eax,0x8010ebb4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000bd:	e8 b5 54 00 00       	call   80105577 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 d0 54 00 00       	call   801055d9 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 6d 51 00 00       	call   80105291 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 b0 eb 10 80       	mov    0x8010ebb0,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017c:	e8 58 54 00 00       	call   801055d9 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 a4 eb 10 80 	cmpl   $0x8010eba4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 ef 8c 10 80 	movl   $0x80108cef,(%esp)
8010019f:	e8 99 03 00 00       	call   8010053d <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 dc 25 00 00       	call   801027b4 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 00 8d 10 80 	movl   $0x80108d00,(%esp)
801001f6:	e8 42 03 00 00       	call   8010053d <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 9f 25 00 00       	call   801027b4 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 07 8d 10 80 	movl   $0x80108d07,(%esp)
80100230:	e8 08 03 00 00       	call   8010053d <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 36 53 00 00       	call   80105577 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 b4 eb 10 80    	mov    0x8010ebb4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c a4 eb 10 80 	movl   $0x8010eba4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 b4 eb 10 80       	mov    0x8010ebb4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 b4 eb 10 80       	mov    %eax,0x8010ebb4

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 cb 50 00 00       	call   8010536d <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 2b 53 00 00       	call   801055d9 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801002c2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801002ca:	ec                   	in     (%dx),%al
801002cb:	89 c3                	mov    %eax,%ebx
801002cd:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002d0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801002d4:	83 c4 14             	add    $0x14,%esp
801002d7:	5b                   	pop    %ebx
801002d8:	5d                   	pop    %ebp
801002d9:	c3                   	ret    

801002da <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002da:	55                   	push   %ebp
801002db:	89 e5                	mov    %esp,%ebp
801002dd:	83 ec 08             	sub    $0x8,%esp
801002e0:	8b 55 08             	mov    0x8(%ebp),%edx
801002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801002e6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002ea:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002ed:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002f1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002f5:	ee                   	out    %al,(%dx)
}
801002f6:	c9                   	leave  
801002f7:	c3                   	ret    

801002f8 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f8:	55                   	push   %ebp
801002f9:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002fb:	fa                   	cli    
}
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    

801002fe <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fe:	55                   	push   %ebp
801002ff:	89 e5                	mov    %esp,%ebp
80100301:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100308:	74 19                	je     80100323 <printint+0x25>
8010030a:	8b 45 08             	mov    0x8(%ebp),%eax
8010030d:	c1 e8 1f             	shr    $0x1f,%eax
80100310:	89 45 10             	mov    %eax,0x10(%ebp)
80100313:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100317:	74 0a                	je     80100323 <printint+0x25>
    x = -xx;
80100319:	8b 45 08             	mov    0x8(%ebp),%eax
8010031c:	f7 d8                	neg    %eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100321:	eb 06                	jmp    80100329 <printint+0x2b>
  else
    x = xx;
80100323:	8b 45 08             	mov    0x8(%ebp),%eax
80100326:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100329:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100330:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100333:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100336:	ba 00 00 00 00       	mov    $0x0,%edx
8010033b:	f7 f1                	div    %ecx
8010033d:	89 d0                	mov    %edx,%eax
8010033f:	0f b6 90 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%edx
80100346:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100349:	03 45 f4             	add    -0xc(%ebp),%eax
8010034c:	88 10                	mov    %dl,(%eax)
8010034e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
80100352:	8b 55 0c             	mov    0xc(%ebp),%edx
80100355:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035b:	ba 00 00 00 00       	mov    $0x0,%edx
80100360:	f7 75 d4             	divl   -0x2c(%ebp)
80100363:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100366:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010036a:	75 c4                	jne    80100330 <printint+0x32>

  if(sign)
8010036c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100370:	74 23                	je     80100395 <printint+0x97>
    buf[i++] = '-';
80100372:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100375:	03 45 f4             	add    -0xc(%ebp),%eax
80100378:	c6 00 2d             	movb   $0x2d,(%eax)
8010037b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
8010037f:	eb 14                	jmp    80100395 <printint+0x97>
    consputc(buf[i]);
80100381:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100384:	03 45 f4             	add    -0xc(%ebp),%eax
80100387:	0f b6 00             	movzbl (%eax),%eax
8010038a:	0f be c0             	movsbl %al,%eax
8010038d:	89 04 24             	mov    %eax,(%esp)
80100390:	e8 bb 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100395:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010039d:	79 e2                	jns    80100381 <printint+0x83>
    consputc(buf[i]);
}
8010039f:	c9                   	leave  
801003a0:	c3                   	ret    

801003a1 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a1:	55                   	push   %ebp
801003a2:	89 e5                	mov    %esp,%ebp
801003a4:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a7:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b3:	74 0c                	je     801003c1 <cprintf+0x20>
    acquire(&cons.lock);
801003b5:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801003bc:	e8 b6 51 00 00       	call   80105577 <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 0e 8d 10 80 	movl   $0x80108d0e,(%esp)
801003cf:	e8 69 01 00 00       	call   8010053d <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d4:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e1:	e9 20 01 00 00       	jmp    80100506 <cprintf+0x165>
    if(c != '%'){
801003e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003ea:	74 10                	je     801003fc <cprintf+0x5b>
      consputc(c);
801003ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ef:	89 04 24             	mov    %eax,(%esp)
801003f2:	e8 59 03 00 00       	call   80100750 <consputc>
      continue;
801003f7:	e9 06 01 00 00       	jmp    80100502 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
801003fc:	8b 55 08             	mov    0x8(%ebp),%edx
801003ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100406:	01 d0                	add    %edx,%eax
80100408:	0f b6 00             	movzbl (%eax),%eax
8010040b:	0f be c0             	movsbl %al,%eax
8010040e:	25 ff 00 00 00       	and    $0xff,%eax
80100413:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100416:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010041a:	0f 84 08 01 00 00    	je     80100528 <cprintf+0x187>
      break;
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4d                	je     80100475 <cprintf+0xd4>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0x9f>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13b>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xae>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x149>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 53                	je     80100498 <cprintf+0xf7>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2b                	je     80100475 <cprintf+0xd4>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x149>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8b 00                	mov    (%eax),%eax
80100454:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100458:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045f:	00 
80100460:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100467:	00 
80100468:	89 04 24             	mov    %eax,(%esp)
8010046b:	e8 8e fe ff ff       	call   801002fe <printint>
      break;
80100470:	e9 8d 00 00 00       	jmp    80100502 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100475:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100478:	8b 00                	mov    (%eax),%eax
8010047a:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100485:	00 
80100486:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048d:	00 
8010048e:	89 04 24             	mov    %eax,(%esp)
80100491:	e8 68 fe ff ff       	call   801002fe <printint>
      break;
80100496:	eb 6a                	jmp    80100502 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
80100498:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049b:	8b 00                	mov    (%eax),%eax
8010049d:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004a4:	0f 94 c0             	sete   %al
801004a7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004ab:	84 c0                	test   %al,%al
801004ad:	74 20                	je     801004cf <cprintf+0x12e>
        s = "(null)";
801004af:	c7 45 ec 17 8d 10 80 	movl   $0x80108d17,-0x14(%ebp)
      for(; *s; s++)
801004b6:	eb 17                	jmp    801004cf <cprintf+0x12e>
        consputc(*s);
801004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004bb:	0f b6 00             	movzbl (%eax),%eax
801004be:	0f be c0             	movsbl %al,%eax
801004c1:	89 04 24             	mov    %eax,(%esp)
801004c4:	e8 87 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004cd:	eb 01                	jmp    801004d0 <cprintf+0x12f>
801004cf:	90                   	nop
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 de                	jne    801004b8 <cprintf+0x117>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x161>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 c0 fe ff ff    	jne    801003e6 <cprintf+0x45>
80100526:	eb 01                	jmp    80100529 <cprintf+0x188>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100528:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100529:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052d:	74 0c                	je     8010053b <cprintf+0x19a>
    release(&cons.lock);
8010052f:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100536:	e8 9e 50 00 00       	call   801055d9 <release>
}
8010053b:	c9                   	leave  
8010053c:	c3                   	ret    

8010053d <panic>:

void
panic(char *s)
{
8010053d:	55                   	push   %ebp
8010053e:	89 e5                	mov    %esp,%ebp
80100540:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100543:	e8 b0 fd ff ff       	call   801002f8 <cli>
  cons.locking = 0;
80100548:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
8010054f:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100552:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100558:	0f b6 00             	movzbl (%eax),%eax
8010055b:	0f b6 c0             	movzbl %al,%eax
8010055e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100562:	c7 04 24 1e 8d 10 80 	movl   $0x80108d1e,(%esp)
80100569:	e8 33 fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
8010056e:	8b 45 08             	mov    0x8(%ebp),%eax
80100571:	89 04 24             	mov    %eax,(%esp)
80100574:	e8 28 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100579:	c7 04 24 2d 8d 10 80 	movl   $0x80108d2d,(%esp)
80100580:	e8 1c fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
80100585:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100588:	89 44 24 04          	mov    %eax,0x4(%esp)
8010058c:	8d 45 08             	lea    0x8(%ebp),%eax
8010058f:	89 04 24             	mov    %eax,(%esp)
80100592:	e8 91 50 00 00       	call   80105628 <getcallerpcs>
  for(i=0; i<10; i++)
80100597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059e:	eb 1b                	jmp    801005bb <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005ab:	c7 04 24 2f 8d 10 80 	movl   $0x80108d2f,(%esp)
801005b2:	e8 ea fd ff ff       	call   801003a1 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005bb:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bf:	7e df                	jle    801005a0 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005c1:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005c8:	00 00 00 
  for(;;)
    ;
801005cb:	eb fe                	jmp    801005cb <panic+0x8e>

801005cd <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005cd:	55                   	push   %ebp
801005ce:	89 e5                	mov    %esp,%ebp
801005d0:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d3:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005da:	00 
801005db:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005e2:	e8 f3 fc ff ff       	call   801002da <outb>
  pos = inb(CRTPORT+1) << 8;
801005e7:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005ee:	e8 bd fc ff ff       	call   801002b0 <inb>
801005f3:	0f b6 c0             	movzbl %al,%eax
801005f6:	c1 e0 08             	shl    $0x8,%eax
801005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005fc:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100603:	00 
80100604:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010060b:	e8 ca fc ff ff       	call   801002da <outb>
  pos |= inb(CRTPORT+1);
80100610:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100617:	e8 94 fc ff ff       	call   801002b0 <inb>
8010061c:	0f b6 c0             	movzbl %al,%eax
8010061f:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100622:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100626:	75 30                	jne    80100658 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100628:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010062b:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100630:	89 c8                	mov    %ecx,%eax
80100632:	f7 ea                	imul   %edx
80100634:	c1 fa 05             	sar    $0x5,%edx
80100637:	89 c8                	mov    %ecx,%eax
80100639:	c1 f8 1f             	sar    $0x1f,%eax
8010063c:	29 c2                	sub    %eax,%edx
8010063e:	89 d0                	mov    %edx,%eax
80100640:	c1 e0 02             	shl    $0x2,%eax
80100643:	01 d0                	add    %edx,%eax
80100645:	c1 e0 04             	shl    $0x4,%eax
80100648:	89 ca                	mov    %ecx,%edx
8010064a:	29 c2                	sub    %eax,%edx
8010064c:	b8 50 00 00 00       	mov    $0x50,%eax
80100651:	29 d0                	sub    %edx,%eax
80100653:	01 45 f4             	add    %eax,-0xc(%ebp)
80100656:	eb 32                	jmp    8010068a <cgaputc+0xbd>
  else if(c == BACKSPACE){
80100658:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065f:	75 0c                	jne    8010066d <cgaputc+0xa0>
    if(pos > 0) --pos;
80100661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100665:	7e 23                	jle    8010068a <cgaputc+0xbd>
80100667:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010066b:	eb 1d                	jmp    8010068a <cgaputc+0xbd>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066d:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100672:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100675:	01 d2                	add    %edx,%edx
80100677:	01 c2                	add    %eax,%edx
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	66 25 ff 00          	and    $0xff,%ax
80100680:	80 cc 07             	or     $0x7,%ah
80100683:	66 89 02             	mov    %ax,(%edx)
80100686:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x119>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 e2 51 00 00       	call   80105899 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	01 c0                	add    %eax,%eax
801006c5:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 ca                	add    %ecx,%edx
801006d2:	89 44 24 08          	mov    %eax,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 14 24             	mov    %edx,(%esp)
801006e1:	e8 e0 50 00 00       	call   801057c6 <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 e0 fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 c7 fb ff ff       	call   801002da <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 b3 fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 9d fb ff ff       	call   801002da <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 94 fb ff ff       	call   801002f8 <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 d2 6b 00 00       	call   8010734d <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 c6 6b 00 00       	call   8010734d <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 ba 6b 00 00       	call   8010734d <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 ad 6b 00 00       	call   8010734d <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 22 fe ff ff       	call   801005cd <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
801007ba:	e8 b8 4d 00 00       	call   80105577 <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 41 01 00 00       	jmp    80100905 <consoleintr+0x158>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 68                	je     8010083e <consoleintr+0x91>
801007d6:	e9 94 00 00 00       	jmp    8010086f <consoleintr+0xc2>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 59                	je     8010083e <consoleintr+0x91>
801007e5:	e9 85 00 00 00       	jmp    8010086f <consoleintr+0xc2>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 24 4c 00 00       	call   80105413 <procdump>
      break;
801007ef:	e9 11 01 00 00       	jmp    80100905 <consoleintr+0x158>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
80100816:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	0f 84 db 00 00 00    	je     801008fe <consoleintr+0x151>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100823:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
80100828:	83 e8 01             	sub    $0x1,%eax
8010082b:	83 e0 7f             	and    $0x7f,%eax
8010082e:	0f b6 80 f4 ed 10 80 	movzbl -0x7fef120c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100835:	3c 0a                	cmp    $0xa,%al
80100837:	75 bb                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100839:	e9 c0 00 00 00       	jmp    801008fe <consoleintr+0x151>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083e:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
80100844:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
80100849:	39 c2                	cmp    %eax,%edx
8010084b:	0f 84 b0 00 00 00    	je     80100901 <consoleintr+0x154>
        input.e--;
80100851:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
80100856:	83 e8 01             	sub    $0x1,%eax
80100859:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
        consputc(BACKSPACE);
8010085e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100865:	e8 e6 fe ff ff       	call   80100750 <consputc>
      }
      break;
8010086a:	e9 92 00 00 00       	jmp    80100901 <consoleintr+0x154>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100873:	0f 84 8b 00 00 00    	je     80100904 <consoleintr+0x157>
80100879:	8b 15 7c ee 10 80    	mov    0x8010ee7c,%edx
8010087f:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
80100884:	89 d1                	mov    %edx,%ecx
80100886:	29 c1                	sub    %eax,%ecx
80100888:	89 c8                	mov    %ecx,%eax
8010088a:	83 f8 7f             	cmp    $0x7f,%eax
8010088d:	77 75                	ja     80100904 <consoleintr+0x157>
        c = (c == '\r') ? '\n' : c;
8010088f:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
80100893:	74 05                	je     8010089a <consoleintr+0xed>
80100895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100898:	eb 05                	jmp    8010089f <consoleintr+0xf2>
8010089a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008a2:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008a7:	89 c1                	mov    %eax,%ecx
801008a9:	83 e1 7f             	and    $0x7f,%ecx
801008ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008af:	88 91 f4 ed 10 80    	mov    %dl,-0x7fef120c(%ecx)
801008b5:	83 c0 01             	add    $0x1,%eax
801008b8:	a3 7c ee 10 80       	mov    %eax,0x8010ee7c
        consputc(c);
801008bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008c0:	89 04 24             	mov    %eax,(%esp)
801008c3:	e8 88 fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c8:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008cc:	74 18                	je     801008e6 <consoleintr+0x139>
801008ce:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008d2:	74 12                	je     801008e6 <consoleintr+0x139>
801008d4:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008d9:	8b 15 74 ee 10 80    	mov    0x8010ee74,%edx
801008df:	83 ea 80             	sub    $0xffffff80,%edx
801008e2:	39 d0                	cmp    %edx,%eax
801008e4:	75 1e                	jne    80100904 <consoleintr+0x157>
          input.w = input.e;
801008e6:	a1 7c ee 10 80       	mov    0x8010ee7c,%eax
801008eb:	a3 78 ee 10 80       	mov    %eax,0x8010ee78
          wakeup(&input.r);
801008f0:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
801008f7:	e8 71 4a 00 00       	call   8010536d <wakeup>
        }
      }
      break;
801008fc:	eb 06                	jmp    80100904 <consoleintr+0x157>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008fe:	90                   	nop
801008ff:	eb 04                	jmp    80100905 <consoleintr+0x158>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100901:	90                   	nop
80100902:	eb 01                	jmp    80100905 <consoleintr+0x158>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
80100904:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100905:	8b 45 08             	mov    0x8(%ebp),%eax
80100908:	ff d0                	call   *%eax
8010090a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010090d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100911:	0f 89 ad fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100917:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
8010091e:	e8 b6 4c 00 00       	call   801055d9 <release>
}
80100923:	c9                   	leave  
80100924:	c3                   	ret    

80100925 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100925:	55                   	push   %ebp
80100926:	89 e5                	mov    %esp,%ebp
80100928:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
8010092b:	8b 45 08             	mov    0x8(%ebp),%eax
8010092e:	89 04 24             	mov    %eax,(%esp)
80100931:	e8 80 10 00 00       	call   801019b6 <iunlock>
  target = n;
80100936:	8b 45 10             	mov    0x10(%ebp),%eax
80100939:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
8010093c:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100943:	e8 2f 4c 00 00       	call   80105577 <acquire>
  while(n > 0){
80100948:	e9 a8 00 00 00       	jmp    801009f5 <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
8010094d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100953:	8b 40 24             	mov    0x24(%eax),%eax
80100956:	85 c0                	test   %eax,%eax
80100958:	74 21                	je     8010097b <consoleread+0x56>
        release(&input.lock);
8010095a:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100961:	e8 73 4c 00 00       	call   801055d9 <release>
        ilock(ip);
80100966:	8b 45 08             	mov    0x8(%ebp),%eax
80100969:	89 04 24             	mov    %eax,(%esp)
8010096c:	e8 f7 0e 00 00       	call   80101868 <ilock>
        return -1;
80100971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100976:	e9 a9 00 00 00       	jmp    80100a24 <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
8010097b:	c7 44 24 04 c0 ed 10 	movl   $0x8010edc0,0x4(%esp)
80100982:	80 
80100983:	c7 04 24 74 ee 10 80 	movl   $0x8010ee74,(%esp)
8010098a:	e8 02 49 00 00       	call   80105291 <sleep>
8010098f:	eb 01                	jmp    80100992 <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100991:	90                   	nop
80100992:	8b 15 74 ee 10 80    	mov    0x8010ee74,%edx
80100998:	a1 78 ee 10 80       	mov    0x8010ee78,%eax
8010099d:	39 c2                	cmp    %eax,%edx
8010099f:	74 ac                	je     8010094d <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009a1:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
801009a6:	89 c2                	mov    %eax,%edx
801009a8:	83 e2 7f             	and    $0x7f,%edx
801009ab:	0f b6 92 f4 ed 10 80 	movzbl -0x7fef120c(%edx),%edx
801009b2:	0f be d2             	movsbl %dl,%edx
801009b5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801009b8:	83 c0 01             	add    $0x1,%eax
801009bb:	a3 74 ee 10 80       	mov    %eax,0x8010ee74
    if(c == C('D')){  // EOF
801009c0:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009c4:	75 17                	jne    801009dd <consoleread+0xb8>
      if(n < target){
801009c6:	8b 45 10             	mov    0x10(%ebp),%eax
801009c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009cc:	73 2f                	jae    801009fd <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009ce:	a1 74 ee 10 80       	mov    0x8010ee74,%eax
801009d3:	83 e8 01             	sub    $0x1,%eax
801009d6:	a3 74 ee 10 80       	mov    %eax,0x8010ee74
      }
      break;
801009db:	eb 20                	jmp    801009fd <consoleread+0xd8>
    }
    *dst++ = c;
801009dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009e0:	89 c2                	mov    %eax,%edx
801009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801009e5:	88 10                	mov    %dl,(%eax)
801009e7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
801009eb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009ef:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009f3:	74 0b                	je     80100a00 <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f9:	7f 96                	jg     80100991 <consoleread+0x6c>
801009fb:	eb 04                	jmp    80100a01 <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
801009fd:	90                   	nop
801009fe:	eb 01                	jmp    80100a01 <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a00:	90                   	nop
  }
  release(&input.lock);
80100a01:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100a08:	e8 cc 4b 00 00       	call   801055d9 <release>
  ilock(ip);
80100a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80100a10:	89 04 24             	mov    %eax,(%esp)
80100a13:	e8 50 0e 00 00       	call   80101868 <ilock>

  return target - n;
80100a18:	8b 45 10             	mov    0x10(%ebp),%eax
80100a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a1e:	89 d1                	mov    %edx,%ecx
80100a20:	29 c1                	sub    %eax,%ecx
80100a22:	89 c8                	mov    %ecx,%eax
}
80100a24:	c9                   	leave  
80100a25:	c3                   	ret    

80100a26 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a26:	55                   	push   %ebp
80100a27:	89 e5                	mov    %esp,%ebp
80100a29:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a2c:	8b 45 08             	mov    0x8(%ebp),%eax
80100a2f:	89 04 24             	mov    %eax,(%esp)
80100a32:	e8 7f 0f 00 00       	call   801019b6 <iunlock>
  acquire(&cons.lock);
80100a37:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a3e:	e8 34 4b 00 00       	call   80105577 <acquire>
  for(i = 0; i < n; i++)
80100a43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a4a:	eb 1d                	jmp    80100a69 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a4f:	03 45 0c             	add    0xc(%ebp),%eax
80100a52:	0f b6 00             	movzbl (%eax),%eax
80100a55:	0f be c0             	movsbl %al,%eax
80100a58:	25 ff 00 00 00       	and    $0xff,%eax
80100a5d:	89 04 24             	mov    %eax,(%esp)
80100a60:	e8 eb fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a6c:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a6f:	7c db                	jl     80100a4c <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a71:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a78:	e8 5c 4b 00 00       	call   801055d9 <release>
  ilock(ip);
80100a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80100a80:	89 04 24             	mov    %eax,(%esp)
80100a83:	e8 e0 0d 00 00       	call   80101868 <ilock>

  return n;
80100a88:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a8b:	c9                   	leave  
80100a8c:	c3                   	ret    

80100a8d <consoleinit>:

void
consoleinit(void)
{
80100a8d:	55                   	push   %ebp
80100a8e:	89 e5                	mov    %esp,%ebp
80100a90:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a93:	c7 44 24 04 33 8d 10 	movl   $0x80108d33,0x4(%esp)
80100a9a:	80 
80100a9b:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100aa2:	e8 af 4a 00 00       	call   80105556 <initlock>
  initlock(&input.lock, "input");
80100aa7:	c7 44 24 04 3b 8d 10 	movl   $0x80108d3b,0x4(%esp)
80100aae:	80 
80100aaf:	c7 04 24 c0 ed 10 80 	movl   $0x8010edc0,(%esp)
80100ab6:	e8 9b 4a 00 00       	call   80105556 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100abb:	c7 05 4c f8 10 80 26 	movl   $0x80100a26,0x8010f84c
80100ac2:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ac5:	c7 05 48 f8 10 80 25 	movl   $0x80100925,0x8010f848
80100acc:	09 10 80 
  cons.locking = 1;
80100acf:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100ad6:	00 00 00 

  picenable(IRQ_KBD);
80100ad9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae0:	e8 dc 2f 00 00       	call   80103ac1 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ae5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100aec:	00 
80100aed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100af4:	e8 7d 1e 00 00       	call   80102976 <ioapicenable>
}
80100af9:	c9                   	leave  
80100afa:	c3                   	ret    
	...

80100afc <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100afc:	55                   	push   %ebp
80100afd:	89 e5                	mov    %esp,%ebp
80100aff:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b05:	8b 45 08             	mov    0x8(%ebp),%eax
80100b08:	89 04 24             	mov    %eax,(%esp)
80100b0b:	e8 fa 18 00 00       	call   8010240a <namei>
80100b10:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b13:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b17:	75 0a                	jne    80100b23 <exec+0x27>
    return -1;
80100b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1e:	e9 da 03 00 00       	jmp    80100efd <exec+0x401>
  ilock(ip);
80100b23:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 3a 0d 00 00       	call   80101868 <ilock>
  pgdir = 0;
80100b2e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b35:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b3c:	00 
80100b3d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b44:	00 
80100b45:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b52:	89 04 24             	mov    %eax,(%esp)
80100b55:	e8 04 12 00 00       	call   80101d5e <readi>
80100b5a:	83 f8 33             	cmp    $0x33,%eax
80100b5d:	0f 86 54 03 00 00    	jbe    80100eb7 <exec+0x3bb>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b63:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b69:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6e:	0f 85 46 03 00 00    	jne    80100eba <exec+0x3be>
    goto bad;

  if((pgdir = setupkvm(kalloc)) == 0)
80100b74:	c7 04 24 ff 2a 10 80 	movl   $0x80102aff,(%esp)
80100b7b:	e8 11 79 00 00       	call   80108491 <setupkvm>
80100b80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b83:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b87:	0f 84 30 03 00 00    	je     80100ebd <exec+0x3c1>
    goto bad;

  // Load program into memory.
  sz = 0;
80100b8d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b94:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b9b:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100ba1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ba4:	e9 c5 00 00 00       	jmp    80100c6e <exec+0x172>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bac:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bb3:	00 
80100bb4:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bb8:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bc2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 91 11 00 00       	call   80101d5e <readi>
80100bcd:	83 f8 20             	cmp    $0x20,%eax
80100bd0:	0f 85 ea 02 00 00    	jne    80100ec0 <exec+0x3c4>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bd6:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bdc:	83 f8 01             	cmp    $0x1,%eax
80100bdf:	75 7f                	jne    80100c60 <exec+0x164>
      continue;
    if(ph.memsz < ph.filesz)
80100be1:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100be7:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bed:	39 c2                	cmp    %eax,%edx
80100bef:	0f 82 ce 02 00 00    	jb     80100ec3 <exec+0x3c7>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf5:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bfb:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c01:	01 d0                	add    %edx,%eax
80100c03:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c11:	89 04 24             	mov    %eax,(%esp)
80100c14:	e8 4a 7c 00 00       	call   80108863 <allocuvm>
80100c19:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c20:	0f 84 a0 02 00 00    	je     80100ec6 <exec+0x3ca>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c26:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c2c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c32:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c38:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c3c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c40:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c43:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c47:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c4e:	89 04 24             	mov    %eax,(%esp)
80100c51:	e8 1e 7b 00 00       	call   80108774 <loaduvm>
80100c56:	85 c0                	test   %eax,%eax
80100c58:	0f 88 6b 02 00 00    	js     80100ec9 <exec+0x3cd>
80100c5e:	eb 01                	jmp    80100c61 <exec+0x165>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c60:	90                   	nop
  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c61:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c65:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c68:	83 c0 20             	add    $0x20,%eax
80100c6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c6e:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c75:	0f b7 c0             	movzwl %ax,%eax
80100c78:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c7b:	0f 8f 28 ff ff ff    	jg     80100ba9 <exec+0xad>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c81:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c84:	89 04 24             	mov    %eax,(%esp)
80100c87:	e8 60 0e 00 00       	call   80101aec <iunlockput>
  ip = 0;
80100c8c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c93:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c96:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ca6:	05 00 20 00 00       	add    $0x2000,%eax
80100cab:	89 44 24 08          	mov    %eax,0x8(%esp)
80100caf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cb9:	89 04 24             	mov    %eax,(%esp)
80100cbc:	e8 a2 7b 00 00       	call   80108863 <allocuvm>
80100cc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cc8:	0f 84 fe 01 00 00    	je     80100ecc <exec+0x3d0>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cce:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd1:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cdd:	89 04 24             	mov    %eax,(%esp)
80100ce0:	e8 a2 7d 00 00       	call   80108a87 <clearpteu>
  sp = sz;
80100ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce8:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ceb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cf2:	e9 81 00 00 00       	jmp    80100d78 <exec+0x27c>
    if(argc >= MAXARG)
80100cf7:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100cfb:	0f 87 ce 01 00 00    	ja     80100ecf <exec+0x3d3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d04:	c1 e0 02             	shl    $0x2,%eax
80100d07:	03 45 0c             	add    0xc(%ebp),%eax
80100d0a:	8b 00                	mov    (%eax),%eax
80100d0c:	89 04 24             	mov    %eax,(%esp)
80100d0f:	e8 30 4d 00 00       	call   80105a44 <strlen>
80100d14:	f7 d0                	not    %eax
80100d16:	03 45 dc             	add    -0x24(%ebp),%eax
80100d19:	83 e0 fc             	and    $0xfffffffc,%eax
80100d1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d22:	c1 e0 02             	shl    $0x2,%eax
80100d25:	03 45 0c             	add    0xc(%ebp),%eax
80100d28:	8b 00                	mov    (%eax),%eax
80100d2a:	89 04 24             	mov    %eax,(%esp)
80100d2d:	e8 12 4d 00 00       	call   80105a44 <strlen>
80100d32:	83 c0 01             	add    $0x1,%eax
80100d35:	89 c2                	mov    %eax,%edx
80100d37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d3a:	c1 e0 02             	shl    $0x2,%eax
80100d3d:	03 45 0c             	add    0xc(%ebp),%eax
80100d40:	8b 00                	mov    (%eax),%eax
80100d42:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d46:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d54:	89 04 24             	mov    %eax,(%esp)
80100d57:	e8 df 7e 00 00       	call   80108c3b <copyout>
80100d5c:	85 c0                	test   %eax,%eax
80100d5e:	0f 88 6e 01 00 00    	js     80100ed2 <exec+0x3d6>
      goto bad;
    ustack[3+argc] = sp;
80100d64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d67:	8d 50 03             	lea    0x3(%eax),%edx
80100d6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d6d:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d74:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7b:	c1 e0 02             	shl    $0x2,%eax
80100d7e:	03 45 0c             	add    0xc(%ebp),%eax
80100d81:	8b 00                	mov    (%eax),%eax
80100d83:	85 c0                	test   %eax,%eax
80100d85:	0f 85 6c ff ff ff    	jne    80100cf7 <exec+0x1fb>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8e:	83 c0 03             	add    $0x3,%eax
80100d91:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100d98:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100d9c:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100da3:	ff ff ff 
  ustack[1] = argc;
80100da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da9:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db2:	83 c0 01             	add    $0x1,%eax
80100db5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dbf:	29 d0                	sub    %edx,%eax
80100dc1:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dca:	83 c0 04             	add    $0x4,%eax
80100dcd:	c1 e0 02             	shl    $0x2,%eax
80100dd0:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd6:	83 c0 04             	add    $0x4,%eax
80100dd9:	c1 e0 02             	shl    $0x2,%eax
80100ddc:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100de0:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100de6:	89 44 24 08          	mov    %eax,0x8(%esp)
80100dea:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ded:	89 44 24 04          	mov    %eax,0x4(%esp)
80100df1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100df4:	89 04 24             	mov    %eax,(%esp)
80100df7:	e8 3f 7e 00 00       	call   80108c3b <copyout>
80100dfc:	85 c0                	test   %eax,%eax
80100dfe:	0f 88 d1 00 00 00    	js     80100ed5 <exec+0x3d9>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e04:	8b 45 08             	mov    0x8(%ebp),%eax
80100e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e10:	eb 17                	jmp    80100e29 <exec+0x32d>
    if(*s == '/')
80100e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e15:	0f b6 00             	movzbl (%eax),%eax
80100e18:	3c 2f                	cmp    $0x2f,%al
80100e1a:	75 09                	jne    80100e25 <exec+0x329>
      last = s+1;
80100e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e1f:	83 c0 01             	add    $0x1,%eax
80100e22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e25:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e2c:	0f b6 00             	movzbl (%eax),%eax
80100e2f:	84 c0                	test   %al,%al
80100e31:	75 df                	jne    80100e12 <exec+0x316>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e39:	8d 50 70             	lea    0x70(%eax),%edx
80100e3c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e43:	00 
80100e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e47:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e4b:	89 14 24             	mov    %edx,(%esp)
80100e4e:	e8 a3 4b 00 00       	call   801059f6 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e59:	8b 40 04             	mov    0x4(%eax),%eax
80100e5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e68:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e71:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e74:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7c:	8b 40 18             	mov    0x18(%eax),%eax
80100e7f:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100e85:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100e88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8e:	8b 40 18             	mov    0x18(%eax),%eax
80100e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100e94:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100e97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9d:	89 04 24             	mov    %eax,(%esp)
80100ea0:	e8 dd 76 00 00       	call   80108582 <switchuvm>
  freevm(oldpgdir);
80100ea5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ea8:	89 04 24             	mov    %eax,(%esp)
80100eab:	e8 49 7b 00 00       	call   801089f9 <freevm>
  return 0;
80100eb0:	b8 00 00 00 00       	mov    $0x0,%eax
80100eb5:	eb 46                	jmp    80100efd <exec+0x401>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100eb7:	90                   	nop
80100eb8:	eb 1c                	jmp    80100ed6 <exec+0x3da>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100eba:	90                   	nop
80100ebb:	eb 19                	jmp    80100ed6 <exec+0x3da>

  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;
80100ebd:	90                   	nop
80100ebe:	eb 16                	jmp    80100ed6 <exec+0x3da>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ec0:	90                   	nop
80100ec1:	eb 13                	jmp    80100ed6 <exec+0x3da>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ec3:	90                   	nop
80100ec4:	eb 10                	jmp    80100ed6 <exec+0x3da>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ec6:	90                   	nop
80100ec7:	eb 0d                	jmp    80100ed6 <exec+0x3da>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100ec9:	90                   	nop
80100eca:	eb 0a                	jmp    80100ed6 <exec+0x3da>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100ecc:	90                   	nop
80100ecd:	eb 07                	jmp    80100ed6 <exec+0x3da>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ecf:	90                   	nop
80100ed0:	eb 04                	jmp    80100ed6 <exec+0x3da>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100ed2:	90                   	nop
80100ed3:	eb 01                	jmp    80100ed6 <exec+0x3da>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100ed5:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100ed6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100eda:	74 0b                	je     80100ee7 <exec+0x3eb>
    freevm(pgdir);
80100edc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100edf:	89 04 24             	mov    %eax,(%esp)
80100ee2:	e8 12 7b 00 00       	call   801089f9 <freevm>
  if(ip)
80100ee7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100eeb:	74 0b                	je     80100ef8 <exec+0x3fc>
    iunlockput(ip);
80100eed:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ef0:	89 04 24             	mov    %eax,(%esp)
80100ef3:	e8 f4 0b 00 00       	call   80101aec <iunlockput>
  return -1;
80100ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100efd:	c9                   	leave  
80100efe:	c3                   	ret    
	...

80100f00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f06:	c7 44 24 04 41 8d 10 	movl   $0x80108d41,0x4(%esp)
80100f0d:	80 
80100f0e:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f15:	e8 3c 46 00 00       	call   80105556 <initlock>
}
80100f1a:	c9                   	leave  
80100f1b:	c3                   	ret    

80100f1c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f1c:	55                   	push   %ebp
80100f1d:	89 e5                	mov    %esp,%ebp
80100f1f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f22:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f29:	e8 49 46 00 00       	call   80105577 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f2e:	c7 45 f4 d4 ee 10 80 	movl   $0x8010eed4,-0xc(%ebp)
80100f35:	eb 29                	jmp    80100f60 <filealloc+0x44>
    if(f->ref == 0){
80100f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f3a:	8b 40 04             	mov    0x4(%eax),%eax
80100f3d:	85 c0                	test   %eax,%eax
80100f3f:	75 1b                	jne    80100f5c <filealloc+0x40>
      f->ref = 1;
80100f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f44:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f4b:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f52:	e8 82 46 00 00       	call   801055d9 <release>
      return f;
80100f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f5a:	eb 1e                	jmp    80100f7a <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f5c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f60:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
80100f67:	72 ce                	jb     80100f37 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f69:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f70:	e8 64 46 00 00       	call   801055d9 <release>
  return 0;
80100f75:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f7a:	c9                   	leave  
80100f7b:	c3                   	ret    

80100f7c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f7c:	55                   	push   %ebp
80100f7d:	89 e5                	mov    %esp,%ebp
80100f7f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f82:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f89:	e8 e9 45 00 00       	call   80105577 <acquire>
  if(f->ref < 1)
80100f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80100f91:	8b 40 04             	mov    0x4(%eax),%eax
80100f94:	85 c0                	test   %eax,%eax
80100f96:	7f 0c                	jg     80100fa4 <filedup+0x28>
    panic("filedup");
80100f98:	c7 04 24 48 8d 10 80 	movl   $0x80108d48,(%esp)
80100f9f:	e8 99 f5 ff ff       	call   8010053d <panic>
  f->ref++;
80100fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa7:	8b 40 04             	mov    0x4(%eax),%eax
80100faa:	8d 50 01             	lea    0x1(%eax),%edx
80100fad:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb0:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fb3:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100fba:	e8 1a 46 00 00       	call   801055d9 <release>
  return f;
80100fbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fc2:	c9                   	leave  
80100fc3:	c3                   	ret    

80100fc4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fc4:	55                   	push   %ebp
80100fc5:	89 e5                	mov    %esp,%ebp
80100fc7:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fca:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100fd1:	e8 a1 45 00 00       	call   80105577 <acquire>
  if(f->ref < 1)
80100fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd9:	8b 40 04             	mov    0x4(%eax),%eax
80100fdc:	85 c0                	test   %eax,%eax
80100fde:	7f 0c                	jg     80100fec <fileclose+0x28>
    panic("fileclose");
80100fe0:	c7 04 24 50 8d 10 80 	movl   $0x80108d50,(%esp)
80100fe7:	e8 51 f5 ff ff       	call   8010053d <panic>
  if(--f->ref > 0){
80100fec:	8b 45 08             	mov    0x8(%ebp),%eax
80100fef:	8b 40 04             	mov    0x4(%eax),%eax
80100ff2:	8d 50 ff             	lea    -0x1(%eax),%edx
80100ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff8:	89 50 04             	mov    %edx,0x4(%eax)
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	85 c0                	test   %eax,%eax
80101003:	7e 11                	jle    80101016 <fileclose+0x52>
    release(&ftable.lock);
80101005:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
8010100c:	e8 c8 45 00 00       	call   801055d9 <release>
    return;
80101011:	e9 82 00 00 00       	jmp    80101098 <fileclose+0xd4>
  }
  ff = *f;
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	8b 10                	mov    (%eax),%edx
8010101b:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010101e:	8b 50 04             	mov    0x4(%eax),%edx
80101021:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101024:	8b 50 08             	mov    0x8(%eax),%edx
80101027:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010102a:	8b 50 0c             	mov    0xc(%eax),%edx
8010102d:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101030:	8b 50 10             	mov    0x10(%eax),%edx
80101033:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101036:	8b 40 14             	mov    0x14(%eax),%eax
80101039:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010103c:	8b 45 08             	mov    0x8(%ebp),%eax
8010103f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101046:	8b 45 08             	mov    0x8(%ebp),%eax
80101049:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010104f:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80101056:	e8 7e 45 00 00       	call   801055d9 <release>
  
  if(ff.type == FD_PIPE)
8010105b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010105e:	83 f8 01             	cmp    $0x1,%eax
80101061:	75 18                	jne    8010107b <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101063:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101067:	0f be d0             	movsbl %al,%edx
8010106a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010106d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101071:	89 04 24             	mov    %eax,(%esp)
80101074:	e8 02 2d 00 00       	call   80103d7b <pipeclose>
80101079:	eb 1d                	jmp    80101098 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
8010107b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010107e:	83 f8 02             	cmp    $0x2,%eax
80101081:	75 15                	jne    80101098 <fileclose+0xd4>
    begin_trans();
80101083:	e8 95 21 00 00       	call   8010321d <begin_trans>
    iput(ff.ip);
80101088:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010108b:	89 04 24             	mov    %eax,(%esp)
8010108e:	e8 88 09 00 00       	call   80101a1b <iput>
    commit_trans();
80101093:	e8 ce 21 00 00       	call   80103266 <commit_trans>
  }
}
80101098:	c9                   	leave  
80101099:	c3                   	ret    

8010109a <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010109a:	55                   	push   %ebp
8010109b:	89 e5                	mov    %esp,%ebp
8010109d:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010a0:	8b 45 08             	mov    0x8(%ebp),%eax
801010a3:	8b 00                	mov    (%eax),%eax
801010a5:	83 f8 02             	cmp    $0x2,%eax
801010a8:	75 38                	jne    801010e2 <filestat+0x48>
    ilock(f->ip);
801010aa:	8b 45 08             	mov    0x8(%ebp),%eax
801010ad:	8b 40 10             	mov    0x10(%eax),%eax
801010b0:	89 04 24             	mov    %eax,(%esp)
801010b3:	e8 b0 07 00 00       	call   80101868 <ilock>
    stati(f->ip, st);
801010b8:	8b 45 08             	mov    0x8(%ebp),%eax
801010bb:	8b 40 10             	mov    0x10(%eax),%eax
801010be:	8b 55 0c             	mov    0xc(%ebp),%edx
801010c1:	89 54 24 04          	mov    %edx,0x4(%esp)
801010c5:	89 04 24             	mov    %eax,(%esp)
801010c8:	e8 4c 0c 00 00       	call   80101d19 <stati>
    iunlock(f->ip);
801010cd:	8b 45 08             	mov    0x8(%ebp),%eax
801010d0:	8b 40 10             	mov    0x10(%eax),%eax
801010d3:	89 04 24             	mov    %eax,(%esp)
801010d6:	e8 db 08 00 00       	call   801019b6 <iunlock>
    return 0;
801010db:	b8 00 00 00 00       	mov    $0x0,%eax
801010e0:	eb 05                	jmp    801010e7 <filestat+0x4d>
  }
  return -1;
801010e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010e7:	c9                   	leave  
801010e8:	c3                   	ret    

801010e9 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010e9:	55                   	push   %ebp
801010ea:	89 e5                	mov    %esp,%ebp
801010ec:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010ef:	8b 45 08             	mov    0x8(%ebp),%eax
801010f2:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801010f6:	84 c0                	test   %al,%al
801010f8:	75 0a                	jne    80101104 <fileread+0x1b>
    return -1;
801010fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010ff:	e9 9f 00 00 00       	jmp    801011a3 <fileread+0xba>
  if(f->type == FD_PIPE)
80101104:	8b 45 08             	mov    0x8(%ebp),%eax
80101107:	8b 00                	mov    (%eax),%eax
80101109:	83 f8 01             	cmp    $0x1,%eax
8010110c:	75 1e                	jne    8010112c <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010110e:	8b 45 08             	mov    0x8(%ebp),%eax
80101111:	8b 40 0c             	mov    0xc(%eax),%eax
80101114:	8b 55 10             	mov    0x10(%ebp),%edx
80101117:	89 54 24 08          	mov    %edx,0x8(%esp)
8010111b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010111e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101122:	89 04 24             	mov    %eax,(%esp)
80101125:	e8 d3 2d 00 00       	call   80103efd <piperead>
8010112a:	eb 77                	jmp    801011a3 <fileread+0xba>
  if(f->type == FD_INODE){
8010112c:	8b 45 08             	mov    0x8(%ebp),%eax
8010112f:	8b 00                	mov    (%eax),%eax
80101131:	83 f8 02             	cmp    $0x2,%eax
80101134:	75 61                	jne    80101197 <fileread+0xae>
    ilock(f->ip);
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	8b 40 10             	mov    0x10(%eax),%eax
8010113c:	89 04 24             	mov    %eax,(%esp)
8010113f:	e8 24 07 00 00       	call   80101868 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101144:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101147:	8b 45 08             	mov    0x8(%ebp),%eax
8010114a:	8b 50 14             	mov    0x14(%eax),%edx
8010114d:	8b 45 08             	mov    0x8(%ebp),%eax
80101150:	8b 40 10             	mov    0x10(%eax),%eax
80101153:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101157:	89 54 24 08          	mov    %edx,0x8(%esp)
8010115b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010115e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101162:	89 04 24             	mov    %eax,(%esp)
80101165:	e8 f4 0b 00 00       	call   80101d5e <readi>
8010116a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010116d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101171:	7e 11                	jle    80101184 <fileread+0x9b>
      f->off += r;
80101173:	8b 45 08             	mov    0x8(%ebp),%eax
80101176:	8b 50 14             	mov    0x14(%eax),%edx
80101179:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010117c:	01 c2                	add    %eax,%edx
8010117e:	8b 45 08             	mov    0x8(%ebp),%eax
80101181:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101184:	8b 45 08             	mov    0x8(%ebp),%eax
80101187:	8b 40 10             	mov    0x10(%eax),%eax
8010118a:	89 04 24             	mov    %eax,(%esp)
8010118d:	e8 24 08 00 00       	call   801019b6 <iunlock>
    return r;
80101192:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101195:	eb 0c                	jmp    801011a3 <fileread+0xba>
  }
  panic("fileread");
80101197:	c7 04 24 5a 8d 10 80 	movl   $0x80108d5a,(%esp)
8010119e:	e8 9a f3 ff ff       	call   8010053d <panic>
}
801011a3:	c9                   	leave  
801011a4:	c3                   	ret    

801011a5 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011a5:	55                   	push   %ebp
801011a6:	89 e5                	mov    %esp,%ebp
801011a8:	53                   	push   %ebx
801011a9:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011ac:	8b 45 08             	mov    0x8(%ebp),%eax
801011af:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011b3:	84 c0                	test   %al,%al
801011b5:	75 0a                	jne    801011c1 <filewrite+0x1c>
    return -1;
801011b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011bc:	e9 23 01 00 00       	jmp    801012e4 <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011c1:	8b 45 08             	mov    0x8(%ebp),%eax
801011c4:	8b 00                	mov    (%eax),%eax
801011c6:	83 f8 01             	cmp    $0x1,%eax
801011c9:	75 21                	jne    801011ec <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011cb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ce:	8b 40 0c             	mov    0xc(%eax),%eax
801011d1:	8b 55 10             	mov    0x10(%ebp),%edx
801011d4:	89 54 24 08          	mov    %edx,0x8(%esp)
801011d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801011db:	89 54 24 04          	mov    %edx,0x4(%esp)
801011df:	89 04 24             	mov    %eax,(%esp)
801011e2:	e8 26 2c 00 00       	call   80103e0d <pipewrite>
801011e7:	e9 f8 00 00 00       	jmp    801012e4 <filewrite+0x13f>
  if(f->type == FD_INODE){
801011ec:	8b 45 08             	mov    0x8(%ebp),%eax
801011ef:	8b 00                	mov    (%eax),%eax
801011f1:	83 f8 02             	cmp    $0x2,%eax
801011f4:	0f 85 de 00 00 00    	jne    801012d8 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801011fa:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101201:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101208:	e9 a8 00 00 00       	jmp    801012b5 <filewrite+0x110>
      int n1 = n - i;
8010120d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101210:	8b 55 10             	mov    0x10(%ebp),%edx
80101213:	89 d1                	mov    %edx,%ecx
80101215:	29 c1                	sub    %eax,%ecx
80101217:	89 c8                	mov    %ecx,%eax
80101219:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010121c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010121f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101222:	7e 06                	jle    8010122a <filewrite+0x85>
        n1 = max;
80101224:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101227:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
8010122a:	e8 ee 1f 00 00       	call   8010321d <begin_trans>
      ilock(f->ip);
8010122f:	8b 45 08             	mov    0x8(%ebp),%eax
80101232:	8b 40 10             	mov    0x10(%eax),%eax
80101235:	89 04 24             	mov    %eax,(%esp)
80101238:	e8 2b 06 00 00       	call   80101868 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010123d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80101240:	8b 45 08             	mov    0x8(%ebp),%eax
80101243:	8b 48 14             	mov    0x14(%eax),%ecx
80101246:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101249:	89 c2                	mov    %eax,%edx
8010124b:	03 55 0c             	add    0xc(%ebp),%edx
8010124e:	8b 45 08             	mov    0x8(%ebp),%eax
80101251:	8b 40 10             	mov    0x10(%eax),%eax
80101254:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80101258:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010125c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101260:	89 04 24             	mov    %eax,(%esp)
80101263:	e8 61 0c 00 00       	call   80101ec9 <writei>
80101268:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010126b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010126f:	7e 11                	jle    80101282 <filewrite+0xdd>
        f->off += r;
80101271:	8b 45 08             	mov    0x8(%ebp),%eax
80101274:	8b 50 14             	mov    0x14(%eax),%edx
80101277:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010127a:	01 c2                	add    %eax,%edx
8010127c:	8b 45 08             	mov    0x8(%ebp),%eax
8010127f:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101282:	8b 45 08             	mov    0x8(%ebp),%eax
80101285:	8b 40 10             	mov    0x10(%eax),%eax
80101288:	89 04 24             	mov    %eax,(%esp)
8010128b:	e8 26 07 00 00       	call   801019b6 <iunlock>
      commit_trans();
80101290:	e8 d1 1f 00 00       	call   80103266 <commit_trans>

      if(r < 0)
80101295:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101299:	78 28                	js     801012c3 <filewrite+0x11e>
        break;
      if(r != n1)
8010129b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010129e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012a1:	74 0c                	je     801012af <filewrite+0x10a>
        panic("short filewrite");
801012a3:	c7 04 24 63 8d 10 80 	movl   $0x80108d63,(%esp)
801012aa:	e8 8e f2 ff ff       	call   8010053d <panic>
      i += r;
801012af:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012b2:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b8:	3b 45 10             	cmp    0x10(%ebp),%eax
801012bb:	0f 8c 4c ff ff ff    	jl     8010120d <filewrite+0x68>
801012c1:	eb 01                	jmp    801012c4 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
801012c3:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c7:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ca:	75 05                	jne    801012d1 <filewrite+0x12c>
801012cc:	8b 45 10             	mov    0x10(%ebp),%eax
801012cf:	eb 05                	jmp    801012d6 <filewrite+0x131>
801012d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012d6:	eb 0c                	jmp    801012e4 <filewrite+0x13f>
  }
  panic("filewrite");
801012d8:	c7 04 24 73 8d 10 80 	movl   $0x80108d73,(%esp)
801012df:	e8 59 f2 ff ff       	call   8010053d <panic>
}
801012e4:	83 c4 24             	add    $0x24,%esp
801012e7:	5b                   	pop    %ebx
801012e8:	5d                   	pop    %ebp
801012e9:	c3                   	ret    
	...

801012ec <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012ec:	55                   	push   %ebp
801012ed:	89 e5                	mov    %esp,%ebp
801012ef:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012f2:	8b 45 08             	mov    0x8(%ebp),%eax
801012f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801012fc:	00 
801012fd:	89 04 24             	mov    %eax,(%esp)
80101300:	e8 a1 ee ff ff       	call   801001a6 <bread>
80101305:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010130b:	83 c0 18             	add    $0x18,%eax
8010130e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101315:	00 
80101316:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010131d:	89 04 24             	mov    %eax,(%esp)
80101320:	e8 74 45 00 00       	call   80105899 <memmove>
  brelse(bp);
80101325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101328:	89 04 24             	mov    %eax,(%esp)
8010132b:	e8 e7 ee ff ff       	call   80100217 <brelse>
}
80101330:	c9                   	leave  
80101331:	c3                   	ret    

80101332 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101332:	55                   	push   %ebp
80101333:	89 e5                	mov    %esp,%ebp
80101335:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101338:	8b 55 0c             	mov    0xc(%ebp),%edx
8010133b:	8b 45 08             	mov    0x8(%ebp),%eax
8010133e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101342:	89 04 24             	mov    %eax,(%esp)
80101345:	e8 5c ee ff ff       	call   801001a6 <bread>
8010134a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010134d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101350:	83 c0 18             	add    $0x18,%eax
80101353:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010135a:	00 
8010135b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101362:	00 
80101363:	89 04 24             	mov    %eax,(%esp)
80101366:	e8 5b 44 00 00       	call   801057c6 <memset>
  log_write(bp);
8010136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136e:	89 04 24             	mov    %eax,(%esp)
80101371:	e8 48 1f 00 00       	call   801032be <log_write>
  brelse(bp);
80101376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101379:	89 04 24             	mov    %eax,(%esp)
8010137c:	e8 96 ee ff ff       	call   80100217 <brelse>
}
80101381:	c9                   	leave  
80101382:	c3                   	ret    

80101383 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101383:	55                   	push   %ebp
80101384:	89 e5                	mov    %esp,%ebp
80101386:	53                   	push   %ebx
80101387:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
8010138a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101391:	8b 45 08             	mov    0x8(%ebp),%eax
80101394:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101397:	89 54 24 04          	mov    %edx,0x4(%esp)
8010139b:	89 04 24             	mov    %eax,(%esp)
8010139e:	e8 49 ff ff ff       	call   801012ec <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013aa:	e9 11 01 00 00       	jmp    801014c0 <balloc+0x13d>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b2:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013b8:	85 c0                	test   %eax,%eax
801013ba:	0f 48 c2             	cmovs  %edx,%eax
801013bd:	c1 f8 0c             	sar    $0xc,%eax
801013c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013c3:	c1 ea 03             	shr    $0x3,%edx
801013c6:	01 d0                	add    %edx,%eax
801013c8:	83 c0 03             	add    $0x3,%eax
801013cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801013cf:	8b 45 08             	mov    0x8(%ebp),%eax
801013d2:	89 04 24             	mov    %eax,(%esp)
801013d5:	e8 cc ed ff ff       	call   801001a6 <bread>
801013da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013e4:	e9 a7 00 00 00       	jmp    80101490 <balloc+0x10d>
      m = 1 << (bi % 8);
801013e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013ec:	89 c2                	mov    %eax,%edx
801013ee:	c1 fa 1f             	sar    $0x1f,%edx
801013f1:	c1 ea 1d             	shr    $0x1d,%edx
801013f4:	01 d0                	add    %edx,%eax
801013f6:	83 e0 07             	and    $0x7,%eax
801013f9:	29 d0                	sub    %edx,%eax
801013fb:	ba 01 00 00 00       	mov    $0x1,%edx
80101400:	89 d3                	mov    %edx,%ebx
80101402:	89 c1                	mov    %eax,%ecx
80101404:	d3 e3                	shl    %cl,%ebx
80101406:	89 d8                	mov    %ebx,%eax
80101408:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010140b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010140e:	8d 50 07             	lea    0x7(%eax),%edx
80101411:	85 c0                	test   %eax,%eax
80101413:	0f 48 c2             	cmovs  %edx,%eax
80101416:	c1 f8 03             	sar    $0x3,%eax
80101419:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010141c:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101421:	0f b6 c0             	movzbl %al,%eax
80101424:	23 45 e8             	and    -0x18(%ebp),%eax
80101427:	85 c0                	test   %eax,%eax
80101429:	75 61                	jne    8010148c <balloc+0x109>
        bp->data[bi/8] |= m;  // Mark block in use.
8010142b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142e:	8d 50 07             	lea    0x7(%eax),%edx
80101431:	85 c0                	test   %eax,%eax
80101433:	0f 48 c2             	cmovs  %edx,%eax
80101436:	c1 f8 03             	sar    $0x3,%eax
80101439:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101441:	89 d1                	mov    %edx,%ecx
80101443:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101446:	09 ca                	or     %ecx,%edx
80101448:	89 d1                	mov    %edx,%ecx
8010144a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010144d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101451:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101454:	89 04 24             	mov    %eax,(%esp)
80101457:	e8 62 1e 00 00       	call   801032be <log_write>
        brelse(bp);
8010145c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010145f:	89 04 24             	mov    %eax,(%esp)
80101462:	e8 b0 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101467:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010146d:	01 c2                	add    %eax,%edx
8010146f:	8b 45 08             	mov    0x8(%ebp),%eax
80101472:	89 54 24 04          	mov    %edx,0x4(%esp)
80101476:	89 04 24             	mov    %eax,(%esp)
80101479:	e8 b4 fe ff ff       	call   80101332 <bzero>
        return b + bi;
8010147e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101481:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101484:	01 d0                	add    %edx,%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
80101486:	83 c4 34             	add    $0x34,%esp
80101489:	5b                   	pop    %ebx
8010148a:	5d                   	pop    %ebp
8010148b:	c3                   	ret    

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010148c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101490:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101497:	7f 15                	jg     801014ae <balloc+0x12b>
80101499:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010149c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010149f:	01 d0                	add    %edx,%eax
801014a1:	89 c2                	mov    %eax,%edx
801014a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014a6:	39 c2                	cmp    %eax,%edx
801014a8:	0f 82 3b ff ff ff    	jb     801013e9 <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b1:	89 04 24             	mov    %eax,(%esp)
801014b4:	e8 5e ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014b9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014c6:	39 c2                	cmp    %eax,%edx
801014c8:	0f 82 e1 fe ff ff    	jb     801013af <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014ce:	c7 04 24 7d 8d 10 80 	movl   $0x80108d7d,(%esp)
801014d5:	e8 63 f0 ff ff       	call   8010053d <panic>

801014da <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014da:	55                   	push   %ebp
801014db:	89 e5                	mov    %esp,%ebp
801014dd:	53                   	push   %ebx
801014de:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014e1:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801014e8:	8b 45 08             	mov    0x8(%ebp),%eax
801014eb:	89 04 24             	mov    %eax,(%esp)
801014ee:	e8 f9 fd ff ff       	call   801012ec <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801014f6:	89 c2                	mov    %eax,%edx
801014f8:	c1 ea 0c             	shr    $0xc,%edx
801014fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014fe:	c1 e8 03             	shr    $0x3,%eax
80101501:	01 d0                	add    %edx,%eax
80101503:	8d 50 03             	lea    0x3(%eax),%edx
80101506:	8b 45 08             	mov    0x8(%ebp),%eax
80101509:	89 54 24 04          	mov    %edx,0x4(%esp)
8010150d:	89 04 24             	mov    %eax,(%esp)
80101510:	e8 91 ec ff ff       	call   801001a6 <bread>
80101515:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101518:	8b 45 0c             	mov    0xc(%ebp),%eax
8010151b:	25 ff 0f 00 00       	and    $0xfff,%eax
80101520:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101523:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101526:	89 c2                	mov    %eax,%edx
80101528:	c1 fa 1f             	sar    $0x1f,%edx
8010152b:	c1 ea 1d             	shr    $0x1d,%edx
8010152e:	01 d0                	add    %edx,%eax
80101530:	83 e0 07             	and    $0x7,%eax
80101533:	29 d0                	sub    %edx,%eax
80101535:	ba 01 00 00 00       	mov    $0x1,%edx
8010153a:	89 d3                	mov    %edx,%ebx
8010153c:	89 c1                	mov    %eax,%ecx
8010153e:	d3 e3                	shl    %cl,%ebx
80101540:	89 d8                	mov    %ebx,%eax
80101542:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101545:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101548:	8d 50 07             	lea    0x7(%eax),%edx
8010154b:	85 c0                	test   %eax,%eax
8010154d:	0f 48 c2             	cmovs  %edx,%eax
80101550:	c1 f8 03             	sar    $0x3,%eax
80101553:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101556:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010155b:	0f b6 c0             	movzbl %al,%eax
8010155e:	23 45 ec             	and    -0x14(%ebp),%eax
80101561:	85 c0                	test   %eax,%eax
80101563:	75 0c                	jne    80101571 <bfree+0x97>
    panic("freeing free block");
80101565:	c7 04 24 93 8d 10 80 	movl   $0x80108d93,(%esp)
8010156c:	e8 cc ef ff ff       	call   8010053d <panic>
  bp->data[bi/8] &= ~m;
80101571:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101574:	8d 50 07             	lea    0x7(%eax),%edx
80101577:	85 c0                	test   %eax,%eax
80101579:	0f 48 c2             	cmovs  %edx,%eax
8010157c:	c1 f8 03             	sar    $0x3,%eax
8010157f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101582:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101587:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010158a:	f7 d1                	not    %ecx
8010158c:	21 ca                	and    %ecx,%edx
8010158e:	89 d1                	mov    %edx,%ecx
80101590:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101593:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010159a:	89 04 24             	mov    %eax,(%esp)
8010159d:	e8 1c 1d 00 00       	call   801032be <log_write>
  brelse(bp);
801015a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a5:	89 04 24             	mov    %eax,(%esp)
801015a8:	e8 6a ec ff ff       	call   80100217 <brelse>
}
801015ad:	83 c4 34             	add    $0x34,%esp
801015b0:	5b                   	pop    %ebx
801015b1:	5d                   	pop    %ebp
801015b2:	c3                   	ret    

801015b3 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015b3:	55                   	push   %ebp
801015b4:	89 e5                	mov    %esp,%ebp
801015b6:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015b9:	c7 44 24 04 a6 8d 10 	movl   $0x80108da6,0x4(%esp)
801015c0:	80 
801015c1:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801015c8:	e8 89 3f 00 00       	call   80105556 <initlock>
}
801015cd:	c9                   	leave  
801015ce:	c3                   	ret    

801015cf <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015cf:	55                   	push   %ebp
801015d0:	89 e5                	mov    %esp,%ebp
801015d2:	83 ec 48             	sub    $0x48,%esp
801015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801015d8:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015dc:	8b 45 08             	mov    0x8(%ebp),%eax
801015df:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801015e6:	89 04 24             	mov    %eax,(%esp)
801015e9:	e8 fe fc ff ff       	call   801012ec <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015f5:	e9 98 00 00 00       	jmp    80101692 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fd:	c1 e8 03             	shr    $0x3,%eax
80101600:	83 c0 02             	add    $0x2,%eax
80101603:	89 44 24 04          	mov    %eax,0x4(%esp)
80101607:	8b 45 08             	mov    0x8(%ebp),%eax
8010160a:	89 04 24             	mov    %eax,(%esp)
8010160d:	e8 94 eb ff ff       	call   801001a6 <bread>
80101612:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101615:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101618:	8d 50 18             	lea    0x18(%eax),%edx
8010161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010161e:	83 e0 07             	and    $0x7,%eax
80101621:	c1 e0 06             	shl    $0x6,%eax
80101624:	01 d0                	add    %edx,%eax
80101626:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101629:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010162c:	0f b7 00             	movzwl (%eax),%eax
8010162f:	66 85 c0             	test   %ax,%ax
80101632:	75 4f                	jne    80101683 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101634:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010163b:	00 
8010163c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101643:	00 
80101644:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101647:	89 04 24             	mov    %eax,(%esp)
8010164a:	e8 77 41 00 00       	call   801057c6 <memset>
      dip->type = type;
8010164f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101652:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101656:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101659:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165c:	89 04 24             	mov    %eax,(%esp)
8010165f:	e8 5a 1c 00 00       	call   801032be <log_write>
      brelse(bp);
80101664:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101667:	89 04 24             	mov    %eax,(%esp)
8010166a:	e8 a8 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
8010166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101672:	89 44 24 04          	mov    %eax,0x4(%esp)
80101676:	8b 45 08             	mov    0x8(%ebp),%eax
80101679:	89 04 24             	mov    %eax,(%esp)
8010167c:	e8 e3 00 00 00       	call   80101764 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101681:	c9                   	leave  
80101682:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101683:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101686:	89 04 24             	mov    %eax,(%esp)
80101689:	e8 89 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
8010168e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101692:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101698:	39 c2                	cmp    %eax,%edx
8010169a:	0f 82 5a ff ff ff    	jb     801015fa <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016a0:	c7 04 24 ad 8d 10 80 	movl   $0x80108dad,(%esp)
801016a7:	e8 91 ee ff ff       	call   8010053d <panic>

801016ac <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016ac:	55                   	push   %ebp
801016ad:	89 e5                	mov    %esp,%ebp
801016af:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016b2:	8b 45 08             	mov    0x8(%ebp),%eax
801016b5:	8b 40 04             	mov    0x4(%eax),%eax
801016b8:	c1 e8 03             	shr    $0x3,%eax
801016bb:	8d 50 02             	lea    0x2(%eax),%edx
801016be:	8b 45 08             	mov    0x8(%ebp),%eax
801016c1:	8b 00                	mov    (%eax),%eax
801016c3:	89 54 24 04          	mov    %edx,0x4(%esp)
801016c7:	89 04 24             	mov    %eax,(%esp)
801016ca:	e8 d7 ea ff ff       	call   801001a6 <bread>
801016cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d5:	8d 50 18             	lea    0x18(%eax),%edx
801016d8:	8b 45 08             	mov    0x8(%ebp),%eax
801016db:	8b 40 04             	mov    0x4(%eax),%eax
801016de:	83 e0 07             	and    $0x7,%eax
801016e1:	c1 e0 06             	shl    $0x6,%eax
801016e4:	01 d0                	add    %edx,%eax
801016e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016e9:	8b 45 08             	mov    0x8(%ebp),%eax
801016ec:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f3:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f6:	8b 45 08             	mov    0x8(%ebp),%eax
801016f9:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101700:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101704:	8b 45 08             	mov    0x8(%ebp),%eax
80101707:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010170e:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101712:	8b 45 08             	mov    0x8(%ebp),%eax
80101715:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101719:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101720:	8b 45 08             	mov    0x8(%ebp),%eax
80101723:	8b 50 18             	mov    0x18(%eax),%edx
80101726:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101729:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172c:	8b 45 08             	mov    0x8(%ebp),%eax
8010172f:	8d 50 1c             	lea    0x1c(%eax),%edx
80101732:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101735:	83 c0 0c             	add    $0xc,%eax
80101738:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010173f:	00 
80101740:	89 54 24 04          	mov    %edx,0x4(%esp)
80101744:	89 04 24             	mov    %eax,(%esp)
80101747:	e8 4d 41 00 00       	call   80105899 <memmove>
  log_write(bp);
8010174c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010174f:	89 04 24             	mov    %eax,(%esp)
80101752:	e8 67 1b 00 00       	call   801032be <log_write>
  brelse(bp);
80101757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175a:	89 04 24             	mov    %eax,(%esp)
8010175d:	e8 b5 ea ff ff       	call   80100217 <brelse>
}
80101762:	c9                   	leave  
80101763:	c3                   	ret    

80101764 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010176a:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101771:	e8 01 3e 00 00       	call   80105577 <acquire>

  // Is the inode already cached?
  empty = 0;
80101776:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010177d:	c7 45 f4 d4 f8 10 80 	movl   $0x8010f8d4,-0xc(%ebp)
80101784:	eb 59                	jmp    801017df <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101789:	8b 40 08             	mov    0x8(%eax),%eax
8010178c:	85 c0                	test   %eax,%eax
8010178e:	7e 35                	jle    801017c5 <iget+0x61>
80101790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101793:	8b 00                	mov    (%eax),%eax
80101795:	3b 45 08             	cmp    0x8(%ebp),%eax
80101798:	75 2b                	jne    801017c5 <iget+0x61>
8010179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179d:	8b 40 04             	mov    0x4(%eax),%eax
801017a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017a3:	75 20                	jne    801017c5 <iget+0x61>
      ip->ref++;
801017a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a8:	8b 40 08             	mov    0x8(%eax),%eax
801017ab:	8d 50 01             	lea    0x1(%eax),%edx
801017ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b1:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017b4:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801017bb:	e8 19 3e 00 00       	call   801055d9 <release>
      return ip;
801017c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c3:	eb 6f                	jmp    80101834 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017c9:	75 10                	jne    801017db <iget+0x77>
801017cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ce:	8b 40 08             	mov    0x8(%eax),%eax
801017d1:	85 c0                	test   %eax,%eax
801017d3:	75 06                	jne    801017db <iget+0x77>
      empty = ip;
801017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d8:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017db:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017df:	81 7d f4 74 08 11 80 	cmpl   $0x80110874,-0xc(%ebp)
801017e6:	72 9e                	jb     80101786 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ec:	75 0c                	jne    801017fa <iget+0x96>
    panic("iget: no inodes");
801017ee:	c7 04 24 bf 8d 10 80 	movl   $0x80108dbf,(%esp)
801017f5:	e8 43 ed ff ff       	call   8010053d <panic>

  ip = empty;
801017fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101803:	8b 55 08             	mov    0x8(%ebp),%edx
80101806:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010180e:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101814:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101825:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010182c:	e8 a8 3d 00 00       	call   801055d9 <release>

  return ip;
80101831:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101834:	c9                   	leave  
80101835:	c3                   	ret    

80101836 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101836:	55                   	push   %ebp
80101837:	89 e5                	mov    %esp,%ebp
80101839:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010183c:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101843:	e8 2f 3d 00 00       	call   80105577 <acquire>
  ip->ref++;
80101848:	8b 45 08             	mov    0x8(%ebp),%eax
8010184b:	8b 40 08             	mov    0x8(%eax),%eax
8010184e:	8d 50 01             	lea    0x1(%eax),%edx
80101851:	8b 45 08             	mov    0x8(%ebp),%eax
80101854:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101857:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010185e:	e8 76 3d 00 00       	call   801055d9 <release>
  return ip;
80101863:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101866:	c9                   	leave  
80101867:	c3                   	ret    

80101868 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101868:	55                   	push   %ebp
80101869:	89 e5                	mov    %esp,%ebp
8010186b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010186e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101872:	74 0a                	je     8010187e <ilock+0x16>
80101874:	8b 45 08             	mov    0x8(%ebp),%eax
80101877:	8b 40 08             	mov    0x8(%eax),%eax
8010187a:	85 c0                	test   %eax,%eax
8010187c:	7f 0c                	jg     8010188a <ilock+0x22>
    panic("ilock");
8010187e:	c7 04 24 cf 8d 10 80 	movl   $0x80108dcf,(%esp)
80101885:	e8 b3 ec ff ff       	call   8010053d <panic>

  acquire(&icache.lock);
8010188a:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101891:	e8 e1 3c 00 00       	call   80105577 <acquire>
  while(ip->flags & I_BUSY)
80101896:	eb 13                	jmp    801018ab <ilock+0x43>
    sleep(ip, &icache.lock);
80101898:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
8010189f:	80 
801018a0:	8b 45 08             	mov    0x8(%ebp),%eax
801018a3:	89 04 24             	mov    %eax,(%esp)
801018a6:	e8 e6 39 00 00       	call   80105291 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018ab:	8b 45 08             	mov    0x8(%ebp),%eax
801018ae:	8b 40 0c             	mov    0xc(%eax),%eax
801018b1:	83 e0 01             	and    $0x1,%eax
801018b4:	84 c0                	test   %al,%al
801018b6:	75 e0                	jne    80101898 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018b8:	8b 45 08             	mov    0x8(%ebp),%eax
801018bb:	8b 40 0c             	mov    0xc(%eax),%eax
801018be:	89 c2                	mov    %eax,%edx
801018c0:	83 ca 01             	or     $0x1,%edx
801018c3:	8b 45 08             	mov    0x8(%ebp),%eax
801018c6:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018c9:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801018d0:	e8 04 3d 00 00       	call   801055d9 <release>

  if(!(ip->flags & I_VALID)){
801018d5:	8b 45 08             	mov    0x8(%ebp),%eax
801018d8:	8b 40 0c             	mov    0xc(%eax),%eax
801018db:	83 e0 02             	and    $0x2,%eax
801018de:	85 c0                	test   %eax,%eax
801018e0:	0f 85 ce 00 00 00    	jne    801019b4 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018e6:	8b 45 08             	mov    0x8(%ebp),%eax
801018e9:	8b 40 04             	mov    0x4(%eax),%eax
801018ec:	c1 e8 03             	shr    $0x3,%eax
801018ef:	8d 50 02             	lea    0x2(%eax),%edx
801018f2:	8b 45 08             	mov    0x8(%ebp),%eax
801018f5:	8b 00                	mov    (%eax),%eax
801018f7:	89 54 24 04          	mov    %edx,0x4(%esp)
801018fb:	89 04 24             	mov    %eax,(%esp)
801018fe:	e8 a3 e8 ff ff       	call   801001a6 <bread>
80101903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101909:	8d 50 18             	lea    0x18(%eax),%edx
8010190c:	8b 45 08             	mov    0x8(%ebp),%eax
8010190f:	8b 40 04             	mov    0x4(%eax),%eax
80101912:	83 e0 07             	and    $0x7,%eax
80101915:	c1 e0 06             	shl    $0x6,%eax
80101918:	01 d0                	add    %edx,%eax
8010191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
8010191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101920:	0f b7 10             	movzwl (%eax),%edx
80101923:	8b 45 08             	mov    0x8(%ebp),%eax
80101926:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010192a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010192d:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101931:	8b 45 08             	mov    0x8(%ebp),%eax
80101934:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101938:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193b:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010193f:	8b 45 08             	mov    0x8(%ebp),%eax
80101942:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101946:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101949:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010194d:	8b 45 08             	mov    0x8(%ebp),%eax
80101950:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101954:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101957:	8b 50 08             	mov    0x8(%eax),%edx
8010195a:	8b 45 08             	mov    0x8(%ebp),%eax
8010195d:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101963:	8d 50 0c             	lea    0xc(%eax),%edx
80101966:	8b 45 08             	mov    0x8(%ebp),%eax
80101969:	83 c0 1c             	add    $0x1c,%eax
8010196c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101973:	00 
80101974:	89 54 24 04          	mov    %edx,0x4(%esp)
80101978:	89 04 24             	mov    %eax,(%esp)
8010197b:	e8 19 3f 00 00       	call   80105899 <memmove>
    brelse(bp);
80101980:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101983:	89 04 24             	mov    %eax,(%esp)
80101986:	e8 8c e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
8010198b:	8b 45 08             	mov    0x8(%ebp),%eax
8010198e:	8b 40 0c             	mov    0xc(%eax),%eax
80101991:	89 c2                	mov    %eax,%edx
80101993:	83 ca 02             	or     $0x2,%edx
80101996:	8b 45 08             	mov    0x8(%ebp),%eax
80101999:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
8010199c:	8b 45 08             	mov    0x8(%ebp),%eax
8010199f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019a3:	66 85 c0             	test   %ax,%ax
801019a6:	75 0c                	jne    801019b4 <ilock+0x14c>
      panic("ilock: no type");
801019a8:	c7 04 24 d5 8d 10 80 	movl   $0x80108dd5,(%esp)
801019af:	e8 89 eb ff ff       	call   8010053d <panic>
  }
}
801019b4:	c9                   	leave  
801019b5:	c3                   	ret    

801019b6 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019b6:	55                   	push   %ebp
801019b7:	89 e5                	mov    %esp,%ebp
801019b9:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019c0:	74 17                	je     801019d9 <iunlock+0x23>
801019c2:	8b 45 08             	mov    0x8(%ebp),%eax
801019c5:	8b 40 0c             	mov    0xc(%eax),%eax
801019c8:	83 e0 01             	and    $0x1,%eax
801019cb:	85 c0                	test   %eax,%eax
801019cd:	74 0a                	je     801019d9 <iunlock+0x23>
801019cf:	8b 45 08             	mov    0x8(%ebp),%eax
801019d2:	8b 40 08             	mov    0x8(%eax),%eax
801019d5:	85 c0                	test   %eax,%eax
801019d7:	7f 0c                	jg     801019e5 <iunlock+0x2f>
    panic("iunlock");
801019d9:	c7 04 24 e4 8d 10 80 	movl   $0x80108de4,(%esp)
801019e0:	e8 58 eb ff ff       	call   8010053d <panic>

  acquire(&icache.lock);
801019e5:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801019ec:	e8 86 3b 00 00       	call   80105577 <acquire>
  ip->flags &= ~I_BUSY;
801019f1:	8b 45 08             	mov    0x8(%ebp),%eax
801019f4:	8b 40 0c             	mov    0xc(%eax),%eax
801019f7:	89 c2                	mov    %eax,%edx
801019f9:	83 e2 fe             	and    $0xfffffffe,%edx
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
801019ff:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a02:	8b 45 08             	mov    0x8(%ebp),%eax
80101a05:	89 04 24             	mov    %eax,(%esp)
80101a08:	e8 60 39 00 00       	call   8010536d <wakeup>
  release(&icache.lock);
80101a0d:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a14:	e8 c0 3b 00 00       	call   801055d9 <release>
}
80101a19:	c9                   	leave  
80101a1a:	c3                   	ret    

80101a1b <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a1b:	55                   	push   %ebp
80101a1c:	89 e5                	mov    %esp,%ebp
80101a1e:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a21:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a28:	e8 4a 3b 00 00       	call   80105577 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	8b 40 08             	mov    0x8(%eax),%eax
80101a33:	83 f8 01             	cmp    $0x1,%eax
80101a36:	0f 85 93 00 00 00    	jne    80101acf <iput+0xb4>
80101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a42:	83 e0 02             	and    $0x2,%eax
80101a45:	85 c0                	test   %eax,%eax
80101a47:	0f 84 82 00 00 00    	je     80101acf <iput+0xb4>
80101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a50:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a54:	66 85 c0             	test   %ax,%ax
80101a57:	75 76                	jne    80101acf <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 40 0c             	mov    0xc(%eax),%eax
80101a5f:	83 e0 01             	and    $0x1,%eax
80101a62:	84 c0                	test   %al,%al
80101a64:	74 0c                	je     80101a72 <iput+0x57>
      panic("iput busy");
80101a66:	c7 04 24 ec 8d 10 80 	movl   $0x80108dec,(%esp)
80101a6d:	e8 cb ea ff ff       	call   8010053d <panic>
    ip->flags |= I_BUSY;
80101a72:	8b 45 08             	mov    0x8(%ebp),%eax
80101a75:	8b 40 0c             	mov    0xc(%eax),%eax
80101a78:	89 c2                	mov    %eax,%edx
80101a7a:	83 ca 01             	or     $0x1,%edx
80101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a80:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a83:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a8a:	e8 4a 3b 00 00       	call   801055d9 <release>
    itrunc(ip);
80101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a92:	89 04 24             	mov    %eax,(%esp)
80101a95:	e8 72 01 00 00       	call   80101c0c <itrunc>
    ip->type = 0;
80101a9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9d:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	89 04 24             	mov    %eax,(%esp)
80101aa9:	e8 fe fb ff ff       	call   801016ac <iupdate>
    acquire(&icache.lock);
80101aae:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101ab5:	e8 bd 3a 00 00       	call   80105577 <acquire>
    ip->flags = 0;
80101aba:	8b 45 08             	mov    0x8(%ebp),%eax
80101abd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac7:	89 04 24             	mov    %eax,(%esp)
80101aca:	e8 9e 38 00 00       	call   8010536d <wakeup>
  }
  ip->ref--;
80101acf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad2:	8b 40 08             	mov    0x8(%eax),%eax
80101ad5:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80101adb:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ade:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101ae5:	e8 ef 3a 00 00       	call   801055d9 <release>
}
80101aea:	c9                   	leave  
80101aeb:	c3                   	ret    

80101aec <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101aec:	55                   	push   %ebp
80101aed:	89 e5                	mov    %esp,%ebp
80101aef:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101af2:	8b 45 08             	mov    0x8(%ebp),%eax
80101af5:	89 04 24             	mov    %eax,(%esp)
80101af8:	e8 b9 fe ff ff       	call   801019b6 <iunlock>
  iput(ip);
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	89 04 24             	mov    %eax,(%esp)
80101b03:	e8 13 ff ff ff       	call   80101a1b <iput>
}
80101b08:	c9                   	leave  
80101b09:	c3                   	ret    

80101b0a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b0a:	55                   	push   %ebp
80101b0b:	89 e5                	mov    %esp,%ebp
80101b0d:	53                   	push   %ebx
80101b0e:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b11:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b15:	77 3e                	ja     80101b55 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b17:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b1d:	83 c2 04             	add    $0x4,%edx
80101b20:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b2b:	75 20                	jne    80101b4d <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b30:	8b 00                	mov    (%eax),%eax
80101b32:	89 04 24             	mov    %eax,(%esp)
80101b35:	e8 49 f8 ff ff       	call   80101383 <balloc>
80101b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b40:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b43:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b49:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b50:	e9 b1 00 00 00       	jmp    80101c06 <bmap+0xfc>
  }
  bn -= NDIRECT;
80101b55:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b59:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b5d:	0f 87 97 00 00 00    	ja     80101bfa <bmap+0xf0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b63:	8b 45 08             	mov    0x8(%ebp),%eax
80101b66:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b70:	75 19                	jne    80101b8b <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b72:	8b 45 08             	mov    0x8(%ebp),%eax
80101b75:	8b 00                	mov    (%eax),%eax
80101b77:	89 04 24             	mov    %eax,(%esp)
80101b7a:	e8 04 f8 ff ff       	call   80101383 <balloc>
80101b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b82:	8b 45 08             	mov    0x8(%ebp),%eax
80101b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b88:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	8b 00                	mov    (%eax),%eax
80101b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b93:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b97:	89 04 24             	mov    %eax,(%esp)
80101b9a:	e8 07 e6 ff ff       	call   801001a6 <bread>
80101b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ba5:	83 c0 18             	add    $0x18,%eax
80101ba8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bab:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bae:	c1 e0 02             	shl    $0x2,%eax
80101bb1:	03 45 ec             	add    -0x14(%ebp),%eax
80101bb4:	8b 00                	mov    (%eax),%eax
80101bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bbd:	75 2b                	jne    80101bea <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
80101bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bc2:	c1 e0 02             	shl    $0x2,%eax
80101bc5:	89 c3                	mov    %eax,%ebx
80101bc7:	03 5d ec             	add    -0x14(%ebp),%ebx
80101bca:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcd:	8b 00                	mov    (%eax),%eax
80101bcf:	89 04 24             	mov    %eax,(%esp)
80101bd2:	e8 ac f7 ff ff       	call   80101383 <balloc>
80101bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bdd:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101be2:	89 04 24             	mov    %eax,(%esp)
80101be5:	e8 d4 16 00 00       	call   801032be <log_write>
    }
    brelse(bp);
80101bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bed:	89 04 24             	mov    %eax,(%esp)
80101bf0:	e8 22 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bf8:	eb 0c                	jmp    80101c06 <bmap+0xfc>
  }

  panic("bmap: out of range");
80101bfa:	c7 04 24 f6 8d 10 80 	movl   $0x80108df6,(%esp)
80101c01:	e8 37 e9 ff ff       	call   8010053d <panic>
}
80101c06:	83 c4 24             	add    $0x24,%esp
80101c09:	5b                   	pop    %ebx
80101c0a:	5d                   	pop    %ebp
80101c0b:	c3                   	ret    

80101c0c <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c0c:	55                   	push   %ebp
80101c0d:	89 e5                	mov    %esp,%ebp
80101c0f:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c19:	eb 44                	jmp    80101c5f <itrunc+0x53>
    if(ip->addrs[i]){
80101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c21:	83 c2 04             	add    $0x4,%edx
80101c24:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c28:	85 c0                	test   %eax,%eax
80101c2a:	74 2f                	je     80101c5b <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c32:	83 c2 04             	add    $0x4,%edx
80101c35:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c39:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3c:	8b 00                	mov    (%eax),%eax
80101c3e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c42:	89 04 24             	mov    %eax,(%esp)
80101c45:	e8 90 f8 ff ff       	call   801014da <bfree>
      ip->addrs[i] = 0;
80101c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c50:	83 c2 04             	add    $0x4,%edx
80101c53:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c5a:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c5b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c5f:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c63:	7e b6                	jle    80101c1b <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c65:	8b 45 08             	mov    0x8(%ebp),%eax
80101c68:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c6b:	85 c0                	test   %eax,%eax
80101c6d:	0f 84 8f 00 00 00    	je     80101d02 <itrunc+0xf6>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c73:	8b 45 08             	mov    0x8(%ebp),%eax
80101c76:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c79:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7c:	8b 00                	mov    (%eax),%eax
80101c7e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c82:	89 04 24             	mov    %eax,(%esp)
80101c85:	e8 1c e5 ff ff       	call   801001a6 <bread>
80101c8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c90:	83 c0 18             	add    $0x18,%eax
80101c93:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101c9d:	eb 2f                	jmp    80101cce <itrunc+0xc2>
      if(a[j])
80101c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca2:	c1 e0 02             	shl    $0x2,%eax
80101ca5:	03 45 e8             	add    -0x18(%ebp),%eax
80101ca8:	8b 00                	mov    (%eax),%eax
80101caa:	85 c0                	test   %eax,%eax
80101cac:	74 1c                	je     80101cca <itrunc+0xbe>
        bfree(ip->dev, a[j]);
80101cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cb1:	c1 e0 02             	shl    $0x2,%eax
80101cb4:	03 45 e8             	add    -0x18(%ebp),%eax
80101cb7:	8b 10                	mov    (%eax),%edx
80101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbc:	8b 00                	mov    (%eax),%eax
80101cbe:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cc2:	89 04 24             	mov    %eax,(%esp)
80101cc5:	e8 10 f8 ff ff       	call   801014da <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101cca:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd1:	83 f8 7f             	cmp    $0x7f,%eax
80101cd4:	76 c9                	jbe    80101c9f <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cd9:	89 04 24             	mov    %eax,(%esp)
80101cdc:	e8 36 e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ce1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce4:	8b 50 4c             	mov    0x4c(%eax),%edx
80101ce7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cea:	8b 00                	mov    (%eax),%eax
80101cec:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cf0:	89 04 24             	mov    %eax,(%esp)
80101cf3:	e8 e2 f7 ff ff       	call   801014da <bfree>
    ip->addrs[NDIRECT] = 0;
80101cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfb:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d02:	8b 45 08             	mov    0x8(%ebp),%eax
80101d05:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0f:	89 04 24             	mov    %eax,(%esp)
80101d12:	e8 95 f9 ff ff       	call   801016ac <iupdate>
}
80101d17:	c9                   	leave  
80101d18:	c3                   	ret    

80101d19 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d19:	55                   	push   %ebp
80101d1a:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1f:	8b 00                	mov    (%eax),%eax
80101d21:	89 c2                	mov    %eax,%edx
80101d23:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d26:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 50 04             	mov    0x4(%eax),%edx
80101d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d32:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d35:	8b 45 08             	mov    0x8(%ebp),%eax
80101d38:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3f:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d42:	8b 45 08             	mov    0x8(%ebp),%eax
80101d45:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d4c:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d50:	8b 45 08             	mov    0x8(%ebp),%eax
80101d53:	8b 50 18             	mov    0x18(%eax),%edx
80101d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d59:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d5c:	5d                   	pop    %ebp
80101d5d:	c3                   	ret    

80101d5e <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d5e:	55                   	push   %ebp
80101d5f:	89 e5                	mov    %esp,%ebp
80101d61:	53                   	push   %ebx
80101d62:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d65:	8b 45 08             	mov    0x8(%ebp),%eax
80101d68:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d6c:	66 83 f8 03          	cmp    $0x3,%ax
80101d70:	75 60                	jne    80101dd2 <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d72:	8b 45 08             	mov    0x8(%ebp),%eax
80101d75:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d79:	66 85 c0             	test   %ax,%ax
80101d7c:	78 20                	js     80101d9e <readi+0x40>
80101d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d81:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d85:	66 83 f8 09          	cmp    $0x9,%ax
80101d89:	7f 13                	jg     80101d9e <readi+0x40>
80101d8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d92:	98                   	cwtl   
80101d93:	8b 04 c5 40 f8 10 80 	mov    -0x7fef07c0(,%eax,8),%eax
80101d9a:	85 c0                	test   %eax,%eax
80101d9c:	75 0a                	jne    80101da8 <readi+0x4a>
      return -1;
80101d9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101da3:	e9 1b 01 00 00       	jmp    80101ec3 <readi+0x165>
    return devsw[ip->major].read(ip, dst, n);
80101da8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dab:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101daf:	98                   	cwtl   
80101db0:	8b 14 c5 40 f8 10 80 	mov    -0x7fef07c0(,%eax,8),%edx
80101db7:	8b 45 14             	mov    0x14(%ebp),%eax
80101dba:	89 44 24 08          	mov    %eax,0x8(%esp)
80101dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101dc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc8:	89 04 24             	mov    %eax,(%esp)
80101dcb:	ff d2                	call   *%edx
80101dcd:	e9 f1 00 00 00       	jmp    80101ec3 <readi+0x165>
  }

  if(off > ip->size || off + n < off)
80101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd5:	8b 40 18             	mov    0x18(%eax),%eax
80101dd8:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ddb:	72 0d                	jb     80101dea <readi+0x8c>
80101ddd:	8b 45 14             	mov    0x14(%ebp),%eax
80101de0:	8b 55 10             	mov    0x10(%ebp),%edx
80101de3:	01 d0                	add    %edx,%eax
80101de5:	3b 45 10             	cmp    0x10(%ebp),%eax
80101de8:	73 0a                	jae    80101df4 <readi+0x96>
    return -1;
80101dea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101def:	e9 cf 00 00 00       	jmp    80101ec3 <readi+0x165>
  if(off + n > ip->size)
80101df4:	8b 45 14             	mov    0x14(%ebp),%eax
80101df7:	8b 55 10             	mov    0x10(%ebp),%edx
80101dfa:	01 c2                	add    %eax,%edx
80101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dff:	8b 40 18             	mov    0x18(%eax),%eax
80101e02:	39 c2                	cmp    %eax,%edx
80101e04:	76 0c                	jbe    80101e12 <readi+0xb4>
    n = ip->size - off;
80101e06:	8b 45 08             	mov    0x8(%ebp),%eax
80101e09:	8b 40 18             	mov    0x18(%eax),%eax
80101e0c:	2b 45 10             	sub    0x10(%ebp),%eax
80101e0f:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e19:	e9 96 00 00 00       	jmp    80101eb4 <readi+0x156>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e1e:	8b 45 10             	mov    0x10(%ebp),%eax
80101e21:	c1 e8 09             	shr    $0x9,%eax
80101e24:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e28:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2b:	89 04 24             	mov    %eax,(%esp)
80101e2e:	e8 d7 fc ff ff       	call   80101b0a <bmap>
80101e33:	8b 55 08             	mov    0x8(%ebp),%edx
80101e36:	8b 12                	mov    (%edx),%edx
80101e38:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3c:	89 14 24             	mov    %edx,(%esp)
80101e3f:	e8 62 e3 ff ff       	call   801001a6 <bread>
80101e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e47:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4a:	89 c2                	mov    %eax,%edx
80101e4c:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101e52:	b8 00 02 00 00       	mov    $0x200,%eax
80101e57:	89 c1                	mov    %eax,%ecx
80101e59:	29 d1                	sub    %edx,%ecx
80101e5b:	89 ca                	mov    %ecx,%edx
80101e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e60:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e63:	89 cb                	mov    %ecx,%ebx
80101e65:	29 c3                	sub    %eax,%ebx
80101e67:	89 d8                	mov    %ebx,%eax
80101e69:	39 c2                	cmp    %eax,%edx
80101e6b:	0f 46 c2             	cmovbe %edx,%eax
80101e6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e74:	8d 50 18             	lea    0x18(%eax),%edx
80101e77:	8b 45 10             	mov    0x10(%ebp),%eax
80101e7a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e7f:	01 c2                	add    %eax,%edx
80101e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e84:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e88:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e8f:	89 04 24             	mov    %eax,(%esp)
80101e92:	e8 02 3a 00 00       	call   80105899 <memmove>
    brelse(bp);
80101e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e9a:	89 04 24             	mov    %eax,(%esp)
80101e9d:	e8 75 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ea5:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eab:	01 45 10             	add    %eax,0x10(%ebp)
80101eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eb1:	01 45 0c             	add    %eax,0xc(%ebp)
80101eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eb7:	3b 45 14             	cmp    0x14(%ebp),%eax
80101eba:	0f 82 5e ff ff ff    	jb     80101e1e <readi+0xc0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ec0:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101ec3:	83 c4 24             	add    $0x24,%esp
80101ec6:	5b                   	pop    %ebx
80101ec7:	5d                   	pop    %ebp
80101ec8:	c3                   	ret    

80101ec9 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ec9:	55                   	push   %ebp
80101eca:	89 e5                	mov    %esp,%ebp
80101ecc:	53                   	push   %ebx
80101ecd:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ed7:	66 83 f8 03          	cmp    $0x3,%ax
80101edb:	75 60                	jne    80101f3d <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101edd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ee4:	66 85 c0             	test   %ax,%ax
80101ee7:	78 20                	js     80101f09 <writei+0x40>
80101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eec:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef0:	66 83 f8 09          	cmp    $0x9,%ax
80101ef4:	7f 13                	jg     80101f09 <writei+0x40>
80101ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101efd:	98                   	cwtl   
80101efe:	8b 04 c5 44 f8 10 80 	mov    -0x7fef07bc(,%eax,8),%eax
80101f05:	85 c0                	test   %eax,%eax
80101f07:	75 0a                	jne    80101f13 <writei+0x4a>
      return -1;
80101f09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f0e:	e9 46 01 00 00       	jmp    80102059 <writei+0x190>
    return devsw[ip->major].write(ip, src, n);
80101f13:	8b 45 08             	mov    0x8(%ebp),%eax
80101f16:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f1a:	98                   	cwtl   
80101f1b:	8b 14 c5 44 f8 10 80 	mov    -0x7fef07bc(,%eax,8),%edx
80101f22:	8b 45 14             	mov    0x14(%ebp),%eax
80101f25:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f29:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f30:	8b 45 08             	mov    0x8(%ebp),%eax
80101f33:	89 04 24             	mov    %eax,(%esp)
80101f36:	ff d2                	call   *%edx
80101f38:	e9 1c 01 00 00       	jmp    80102059 <writei+0x190>
  }

  if(off > ip->size || off + n < off)
80101f3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f40:	8b 40 18             	mov    0x18(%eax),%eax
80101f43:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f46:	72 0d                	jb     80101f55 <writei+0x8c>
80101f48:	8b 45 14             	mov    0x14(%ebp),%eax
80101f4b:	8b 55 10             	mov    0x10(%ebp),%edx
80101f4e:	01 d0                	add    %edx,%eax
80101f50:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f53:	73 0a                	jae    80101f5f <writei+0x96>
    return -1;
80101f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f5a:	e9 fa 00 00 00       	jmp    80102059 <writei+0x190>
  if(off + n > MAXFILE*BSIZE)
80101f5f:	8b 45 14             	mov    0x14(%ebp),%eax
80101f62:	8b 55 10             	mov    0x10(%ebp),%edx
80101f65:	01 d0                	add    %edx,%eax
80101f67:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f6c:	76 0a                	jbe    80101f78 <writei+0xaf>
    return -1;
80101f6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f73:	e9 e1 00 00 00       	jmp    80102059 <writei+0x190>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f7f:	e9 a1 00 00 00       	jmp    80102025 <writei+0x15c>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f84:	8b 45 10             	mov    0x10(%ebp),%eax
80101f87:	c1 e8 09             	shr    $0x9,%eax
80101f8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f91:	89 04 24             	mov    %eax,(%esp)
80101f94:	e8 71 fb ff ff       	call   80101b0a <bmap>
80101f99:	8b 55 08             	mov    0x8(%ebp),%edx
80101f9c:	8b 12                	mov    (%edx),%edx
80101f9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fa2:	89 14 24             	mov    %edx,(%esp)
80101fa5:	e8 fc e1 ff ff       	call   801001a6 <bread>
80101faa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fad:	8b 45 10             	mov    0x10(%ebp),%eax
80101fb0:	89 c2                	mov    %eax,%edx
80101fb2:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101fb8:	b8 00 02 00 00       	mov    $0x200,%eax
80101fbd:	89 c1                	mov    %eax,%ecx
80101fbf:	29 d1                	sub    %edx,%ecx
80101fc1:	89 ca                	mov    %ecx,%edx
80101fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fc6:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fc9:	89 cb                	mov    %ecx,%ebx
80101fcb:	29 c3                	sub    %eax,%ebx
80101fcd:	89 d8                	mov    %ebx,%eax
80101fcf:	39 c2                	cmp    %eax,%edx
80101fd1:	0f 46 c2             	cmovbe %edx,%eax
80101fd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fda:	8d 50 18             	lea    0x18(%eax),%edx
80101fdd:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe0:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fe5:	01 c2                	add    %eax,%edx
80101fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fea:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fee:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ff5:	89 14 24             	mov    %edx,(%esp)
80101ff8:	e8 9c 38 00 00       	call   80105899 <memmove>
    log_write(bp);
80101ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102000:	89 04 24             	mov    %eax,(%esp)
80102003:	e8 b6 12 00 00       	call   801032be <log_write>
    brelse(bp);
80102008:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010200b:	89 04 24             	mov    %eax,(%esp)
8010200e:	e8 04 e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102013:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102016:	01 45 f4             	add    %eax,-0xc(%ebp)
80102019:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010201c:	01 45 10             	add    %eax,0x10(%ebp)
8010201f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102022:	01 45 0c             	add    %eax,0xc(%ebp)
80102025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102028:	3b 45 14             	cmp    0x14(%ebp),%eax
8010202b:	0f 82 53 ff ff ff    	jb     80101f84 <writei+0xbb>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102031:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102035:	74 1f                	je     80102056 <writei+0x18d>
80102037:	8b 45 08             	mov    0x8(%ebp),%eax
8010203a:	8b 40 18             	mov    0x18(%eax),%eax
8010203d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102040:	73 14                	jae    80102056 <writei+0x18d>
    ip->size = off;
80102042:	8b 45 08             	mov    0x8(%ebp),%eax
80102045:	8b 55 10             	mov    0x10(%ebp),%edx
80102048:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010204b:	8b 45 08             	mov    0x8(%ebp),%eax
8010204e:	89 04 24             	mov    %eax,(%esp)
80102051:	e8 56 f6 ff ff       	call   801016ac <iupdate>
  }
  return n;
80102056:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102059:	83 c4 24             	add    $0x24,%esp
8010205c:	5b                   	pop    %ebx
8010205d:	5d                   	pop    %ebp
8010205e:	c3                   	ret    

8010205f <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010205f:	55                   	push   %ebp
80102060:	89 e5                	mov    %esp,%ebp
80102062:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102065:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010206c:	00 
8010206d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102070:	89 44 24 04          	mov    %eax,0x4(%esp)
80102074:	8b 45 08             	mov    0x8(%ebp),%eax
80102077:	89 04 24             	mov    %eax,(%esp)
8010207a:	e8 be 38 00 00       	call   8010593d <strncmp>
}
8010207f:	c9                   	leave  
80102080:	c3                   	ret    

80102081 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102081:	55                   	push   %ebp
80102082:	89 e5                	mov    %esp,%ebp
80102084:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102087:	8b 45 08             	mov    0x8(%ebp),%eax
8010208a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010208e:	66 83 f8 01          	cmp    $0x1,%ax
80102092:	74 0c                	je     801020a0 <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102094:	c7 04 24 09 8e 10 80 	movl   $0x80108e09,(%esp)
8010209b:	e8 9d e4 ff ff       	call   8010053d <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020a7:	e9 87 00 00 00       	jmp    80102133 <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ac:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020b3:	00 
801020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020b7:	89 44 24 08          	mov    %eax,0x8(%esp)
801020bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020be:	89 44 24 04          	mov    %eax,0x4(%esp)
801020c2:	8b 45 08             	mov    0x8(%ebp),%eax
801020c5:	89 04 24             	mov    %eax,(%esp)
801020c8:	e8 91 fc ff ff       	call   80101d5e <readi>
801020cd:	83 f8 10             	cmp    $0x10,%eax
801020d0:	74 0c                	je     801020de <dirlookup+0x5d>
      panic("dirlink read");
801020d2:	c7 04 24 1b 8e 10 80 	movl   $0x80108e1b,(%esp)
801020d9:	e8 5f e4 ff ff       	call   8010053d <panic>
    if(de.inum == 0)
801020de:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020e2:	66 85 c0             	test   %ax,%ax
801020e5:	74 47                	je     8010212e <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
801020e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020ea:	83 c0 02             	add    $0x2,%eax
801020ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801020f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801020f4:	89 04 24             	mov    %eax,(%esp)
801020f7:	e8 63 ff ff ff       	call   8010205f <namecmp>
801020fc:	85 c0                	test   %eax,%eax
801020fe:	75 2f                	jne    8010212f <dirlookup+0xae>
      // entry matches path element
      if(poff)
80102100:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102104:	74 08                	je     8010210e <dirlookup+0x8d>
        *poff = off;
80102106:	8b 45 10             	mov    0x10(%ebp),%eax
80102109:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010210c:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010210e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102112:	0f b7 c0             	movzwl %ax,%eax
80102115:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102118:	8b 45 08             	mov    0x8(%ebp),%eax
8010211b:	8b 00                	mov    (%eax),%eax
8010211d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102120:	89 54 24 04          	mov    %edx,0x4(%esp)
80102124:	89 04 24             	mov    %eax,(%esp)
80102127:	e8 38 f6 ff ff       	call   80101764 <iget>
8010212c:	eb 19                	jmp    80102147 <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010212e:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010212f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102133:	8b 45 08             	mov    0x8(%ebp),%eax
80102136:	8b 40 18             	mov    0x18(%eax),%eax
80102139:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010213c:	0f 87 6a ff ff ff    	ja     801020ac <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102142:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102147:	c9                   	leave  
80102148:	c3                   	ret    

80102149 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102149:	55                   	push   %ebp
8010214a:	89 e5                	mov    %esp,%ebp
8010214c:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010214f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102156:	00 
80102157:	8b 45 0c             	mov    0xc(%ebp),%eax
8010215a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010215e:	8b 45 08             	mov    0x8(%ebp),%eax
80102161:	89 04 24             	mov    %eax,(%esp)
80102164:	e8 18 ff ff ff       	call   80102081 <dirlookup>
80102169:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010216c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102170:	74 15                	je     80102187 <dirlink+0x3e>
    iput(ip);
80102172:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102175:	89 04 24             	mov    %eax,(%esp)
80102178:	e8 9e f8 ff ff       	call   80101a1b <iput>
    return -1;
8010217d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102182:	e9 b8 00 00 00       	jmp    8010223f <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102187:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010218e:	eb 44                	jmp    801021d4 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102193:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010219a:	00 
8010219b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010219f:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801021a6:	8b 45 08             	mov    0x8(%ebp),%eax
801021a9:	89 04 24             	mov    %eax,(%esp)
801021ac:	e8 ad fb ff ff       	call   80101d5e <readi>
801021b1:	83 f8 10             	cmp    $0x10,%eax
801021b4:	74 0c                	je     801021c2 <dirlink+0x79>
      panic("dirlink read");
801021b6:	c7 04 24 1b 8e 10 80 	movl   $0x80108e1b,(%esp)
801021bd:	e8 7b e3 ff ff       	call   8010053d <panic>
    if(de.inum == 0)
801021c2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021c6:	66 85 c0             	test   %ax,%ax
801021c9:	74 18                	je     801021e3 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ce:	83 c0 10             	add    $0x10,%eax
801021d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021d7:	8b 45 08             	mov    0x8(%ebp),%eax
801021da:	8b 40 18             	mov    0x18(%eax),%eax
801021dd:	39 c2                	cmp    %eax,%edx
801021df:	72 af                	jb     80102190 <dirlink+0x47>
801021e1:	eb 01                	jmp    801021e4 <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801021e3:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801021e4:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021eb:	00 
801021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801021ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801021f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021f6:	83 c0 02             	add    $0x2,%eax
801021f9:	89 04 24             	mov    %eax,(%esp)
801021fc:	e8 94 37 00 00       	call   80105995 <strncpy>
  de.inum = inum;
80102201:	8b 45 10             	mov    0x10(%ebp),%eax
80102204:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010220b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102212:	00 
80102213:	89 44 24 08          	mov    %eax,0x8(%esp)
80102217:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010221a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010221e:	8b 45 08             	mov    0x8(%ebp),%eax
80102221:	89 04 24             	mov    %eax,(%esp)
80102224:	e8 a0 fc ff ff       	call   80101ec9 <writei>
80102229:	83 f8 10             	cmp    $0x10,%eax
8010222c:	74 0c                	je     8010223a <dirlink+0xf1>
    panic("dirlink");
8010222e:	c7 04 24 28 8e 10 80 	movl   $0x80108e28,(%esp)
80102235:	e8 03 e3 ff ff       	call   8010053d <panic>
  
  return 0;
8010223a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    

80102241 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102241:	55                   	push   %ebp
80102242:	89 e5                	mov    %esp,%ebp
80102244:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102247:	eb 04                	jmp    8010224d <skipelem+0xc>
    path++;
80102249:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010224d:	8b 45 08             	mov    0x8(%ebp),%eax
80102250:	0f b6 00             	movzbl (%eax),%eax
80102253:	3c 2f                	cmp    $0x2f,%al
80102255:	74 f2                	je     80102249 <skipelem+0x8>
    path++;
  if(*path == 0)
80102257:	8b 45 08             	mov    0x8(%ebp),%eax
8010225a:	0f b6 00             	movzbl (%eax),%eax
8010225d:	84 c0                	test   %al,%al
8010225f:	75 0a                	jne    8010226b <skipelem+0x2a>
    return 0;
80102261:	b8 00 00 00 00       	mov    $0x0,%eax
80102266:	e9 86 00 00 00       	jmp    801022f1 <skipelem+0xb0>
  s = path;
8010226b:	8b 45 08             	mov    0x8(%ebp),%eax
8010226e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102271:	eb 04                	jmp    80102277 <skipelem+0x36>
    path++;
80102273:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102277:	8b 45 08             	mov    0x8(%ebp),%eax
8010227a:	0f b6 00             	movzbl (%eax),%eax
8010227d:	3c 2f                	cmp    $0x2f,%al
8010227f:	74 0a                	je     8010228b <skipelem+0x4a>
80102281:	8b 45 08             	mov    0x8(%ebp),%eax
80102284:	0f b6 00             	movzbl (%eax),%eax
80102287:	84 c0                	test   %al,%al
80102289:	75 e8                	jne    80102273 <skipelem+0x32>
    path++;
  len = path - s;
8010228b:	8b 55 08             	mov    0x8(%ebp),%edx
8010228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102291:	89 d1                	mov    %edx,%ecx
80102293:	29 c1                	sub    %eax,%ecx
80102295:	89 c8                	mov    %ecx,%eax
80102297:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010229a:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010229e:	7e 1c                	jle    801022bc <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
801022a0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022a7:	00 
801022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801022af:	8b 45 0c             	mov    0xc(%ebp),%eax
801022b2:	89 04 24             	mov    %eax,(%esp)
801022b5:	e8 df 35 00 00       	call   80105899 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022ba:	eb 28                	jmp    801022e4 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022bf:	89 44 24 08          	mov    %eax,0x8(%esp)
801022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801022cd:	89 04 24             	mov    %eax,(%esp)
801022d0:	e8 c4 35 00 00       	call   80105899 <memmove>
    name[len] = 0;
801022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022d8:	03 45 0c             	add    0xc(%ebp),%eax
801022db:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022de:	eb 04                	jmp    801022e4 <skipelem+0xa3>
    path++;
801022e0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022e4:	8b 45 08             	mov    0x8(%ebp),%eax
801022e7:	0f b6 00             	movzbl (%eax),%eax
801022ea:	3c 2f                	cmp    $0x2f,%al
801022ec:	74 f2                	je     801022e0 <skipelem+0x9f>
    path++;
  return path;
801022ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022f1:	c9                   	leave  
801022f2:	c3                   	ret    

801022f3 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022f3:	55                   	push   %ebp
801022f4:	89 e5                	mov    %esp,%ebp
801022f6:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
801022fc:	0f b6 00             	movzbl (%eax),%eax
801022ff:	3c 2f                	cmp    $0x2f,%al
80102301:	75 1c                	jne    8010231f <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102303:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010230a:	00 
8010230b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102312:	e8 4d f4 ff ff       	call   80101764 <iget>
80102317:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010231a:	e9 af 00 00 00       	jmp    801023ce <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010231f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102325:	8b 40 6c             	mov    0x6c(%eax),%eax
80102328:	89 04 24             	mov    %eax,(%esp)
8010232b:	e8 06 f5 ff ff       	call   80101836 <idup>
80102330:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102333:	e9 96 00 00 00       	jmp    801023ce <namex+0xdb>
    ilock(ip);
80102338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233b:	89 04 24             	mov    %eax,(%esp)
8010233e:	e8 25 f5 ff ff       	call   80101868 <ilock>
    if(ip->type != T_DIR){
80102343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102346:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010234a:	66 83 f8 01          	cmp    $0x1,%ax
8010234e:	74 15                	je     80102365 <namex+0x72>
      iunlockput(ip);
80102350:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102353:	89 04 24             	mov    %eax,(%esp)
80102356:	e8 91 f7 ff ff       	call   80101aec <iunlockput>
      return 0;
8010235b:	b8 00 00 00 00       	mov    $0x0,%eax
80102360:	e9 a3 00 00 00       	jmp    80102408 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102365:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102369:	74 1d                	je     80102388 <namex+0x95>
8010236b:	8b 45 08             	mov    0x8(%ebp),%eax
8010236e:	0f b6 00             	movzbl (%eax),%eax
80102371:	84 c0                	test   %al,%al
80102373:	75 13                	jne    80102388 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102378:	89 04 24             	mov    %eax,(%esp)
8010237b:	e8 36 f6 ff ff       	call   801019b6 <iunlock>
      return ip;
80102380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102383:	e9 80 00 00 00       	jmp    80102408 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102388:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010238f:	00 
80102390:	8b 45 10             	mov    0x10(%ebp),%eax
80102393:	89 44 24 04          	mov    %eax,0x4(%esp)
80102397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010239a:	89 04 24             	mov    %eax,(%esp)
8010239d:	e8 df fc ff ff       	call   80102081 <dirlookup>
801023a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023a9:	75 12                	jne    801023bd <namex+0xca>
      iunlockput(ip);
801023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ae:	89 04 24             	mov    %eax,(%esp)
801023b1:	e8 36 f7 ff ff       	call   80101aec <iunlockput>
      return 0;
801023b6:	b8 00 00 00 00       	mov    $0x0,%eax
801023bb:	eb 4b                	jmp    80102408 <namex+0x115>
    }
    iunlockput(ip);
801023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c0:	89 04 24             	mov    %eax,(%esp)
801023c3:	e8 24 f7 ff ff       	call   80101aec <iunlockput>
    ip = next;
801023c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023ce:	8b 45 10             	mov    0x10(%ebp),%eax
801023d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801023d5:	8b 45 08             	mov    0x8(%ebp),%eax
801023d8:	89 04 24             	mov    %eax,(%esp)
801023db:	e8 61 fe ff ff       	call   80102241 <skipelem>
801023e0:	89 45 08             	mov    %eax,0x8(%ebp)
801023e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023e7:	0f 85 4b ff ff ff    	jne    80102338 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023f1:	74 12                	je     80102405 <namex+0x112>
    iput(ip);
801023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f6:	89 04 24             	mov    %eax,(%esp)
801023f9:	e8 1d f6 ff ff       	call   80101a1b <iput>
    return 0;
801023fe:	b8 00 00 00 00       	mov    $0x0,%eax
80102403:	eb 03                	jmp    80102408 <namex+0x115>
  }
  return ip;
80102405:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102408:	c9                   	leave  
80102409:	c3                   	ret    

8010240a <namei>:

struct inode*
namei(char *path)
{
8010240a:	55                   	push   %ebp
8010240b:	89 e5                	mov    %esp,%ebp
8010240d:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102410:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102413:	89 44 24 08          	mov    %eax,0x8(%esp)
80102417:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010241e:	00 
8010241f:	8b 45 08             	mov    0x8(%ebp),%eax
80102422:	89 04 24             	mov    %eax,(%esp)
80102425:	e8 c9 fe ff ff       	call   801022f3 <namex>
}
8010242a:	c9                   	leave  
8010242b:	c3                   	ret    

8010242c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010242c:	55                   	push   %ebp
8010242d:	89 e5                	mov    %esp,%ebp
8010242f:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102432:	8b 45 0c             	mov    0xc(%ebp),%eax
80102435:	89 44 24 08          	mov    %eax,0x8(%esp)
80102439:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102440:	00 
80102441:	8b 45 08             	mov    0x8(%ebp),%eax
80102444:	89 04 24             	mov    %eax,(%esp)
80102447:	e8 a7 fe ff ff       	call   801022f3 <namex>
}
8010244c:	c9                   	leave  
8010244d:	c3                   	ret    
	...

80102450 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	53                   	push   %ebx
80102454:	83 ec 14             	sub    $0x14,%esp
80102457:	8b 45 08             	mov    0x8(%ebp),%eax
8010245a:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010245e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80102462:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102466:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
8010246a:	ec                   	in     (%dx),%al
8010246b:	89 c3                	mov    %eax,%ebx
8010246d:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102470:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80102474:	83 c4 14             	add    $0x14,%esp
80102477:	5b                   	pop    %ebx
80102478:	5d                   	pop    %ebp
80102479:	c3                   	ret    

8010247a <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010247a:	55                   	push   %ebp
8010247b:	89 e5                	mov    %esp,%ebp
8010247d:	57                   	push   %edi
8010247e:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010247f:	8b 55 08             	mov    0x8(%ebp),%edx
80102482:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102485:	8b 45 10             	mov    0x10(%ebp),%eax
80102488:	89 cb                	mov    %ecx,%ebx
8010248a:	89 df                	mov    %ebx,%edi
8010248c:	89 c1                	mov    %eax,%ecx
8010248e:	fc                   	cld    
8010248f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102491:	89 c8                	mov    %ecx,%eax
80102493:	89 fb                	mov    %edi,%ebx
80102495:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102498:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010249b:	5b                   	pop    %ebx
8010249c:	5f                   	pop    %edi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    

8010249f <outb>:

static inline void
outb(ushort port, uchar data)
{
8010249f:	55                   	push   %ebp
801024a0:	89 e5                	mov    %esp,%ebp
801024a2:	83 ec 08             	sub    $0x8,%esp
801024a5:	8b 55 08             	mov    0x8(%ebp),%edx
801024a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801024ab:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024af:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024b2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024b6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024ba:	ee                   	out    %al,(%dx)
}
801024bb:	c9                   	leave  
801024bc:	c3                   	ret    

801024bd <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024bd:	55                   	push   %ebp
801024be:	89 e5                	mov    %esp,%ebp
801024c0:	56                   	push   %esi
801024c1:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024c2:	8b 55 08             	mov    0x8(%ebp),%edx
801024c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024c8:	8b 45 10             	mov    0x10(%ebp),%eax
801024cb:	89 cb                	mov    %ecx,%ebx
801024cd:	89 de                	mov    %ebx,%esi
801024cf:	89 c1                	mov    %eax,%ecx
801024d1:	fc                   	cld    
801024d2:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024d4:	89 c8                	mov    %ecx,%eax
801024d6:	89 f3                	mov    %esi,%ebx
801024d8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024db:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024de:	5b                   	pop    %ebx
801024df:	5e                   	pop    %esi
801024e0:	5d                   	pop    %ebp
801024e1:	c3                   	ret    

801024e2 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024e2:	55                   	push   %ebp
801024e3:	89 e5                	mov    %esp,%ebp
801024e5:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024e8:	90                   	nop
801024e9:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024f0:	e8 5b ff ff ff       	call   80102450 <inb>
801024f5:	0f b6 c0             	movzbl %al,%eax
801024f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024fe:	25 c0 00 00 00       	and    $0xc0,%eax
80102503:	83 f8 40             	cmp    $0x40,%eax
80102506:	75 e1                	jne    801024e9 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010250c:	74 11                	je     8010251f <idewait+0x3d>
8010250e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102511:	83 e0 21             	and    $0x21,%eax
80102514:	85 c0                	test   %eax,%eax
80102516:	74 07                	je     8010251f <idewait+0x3d>
    return -1;
80102518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010251d:	eb 05                	jmp    80102524 <idewait+0x42>
  return 0;
8010251f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102524:	c9                   	leave  
80102525:	c3                   	ret    

80102526 <ideinit>:

void
ideinit(void)
{
80102526:	55                   	push   %ebp
80102527:	89 e5                	mov    %esp,%ebp
80102529:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010252c:	c7 44 24 04 30 8e 10 	movl   $0x80108e30,0x4(%esp)
80102533:	80 
80102534:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010253b:	e8 16 30 00 00       	call   80105556 <initlock>
  picenable(IRQ_IDE);
80102540:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102547:	e8 75 15 00 00       	call   80103ac1 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010254c:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80102551:	83 e8 01             	sub    $0x1,%eax
80102554:	89 44 24 04          	mov    %eax,0x4(%esp)
80102558:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010255f:	e8 12 04 00 00       	call   80102976 <ioapicenable>
  idewait(0);
80102564:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010256b:	e8 72 ff ff ff       	call   801024e2 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102570:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102577:	00 
80102578:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010257f:	e8 1b ff ff ff       	call   8010249f <outb>
  for(i=0; i<1000; i++){
80102584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010258b:	eb 20                	jmp    801025ad <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010258d:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102594:	e8 b7 fe ff ff       	call   80102450 <inb>
80102599:	84 c0                	test   %al,%al
8010259b:	74 0c                	je     801025a9 <ideinit+0x83>
      havedisk1 = 1;
8010259d:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801025a4:	00 00 00 
      break;
801025a7:	eb 0d                	jmp    801025b6 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025ad:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025b4:	7e d7                	jle    8010258d <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025b6:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025bd:	00 
801025be:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025c5:	e8 d5 fe ff ff       	call   8010249f <outb>
}
801025ca:	c9                   	leave  
801025cb:	c3                   	ret    

801025cc <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025cc:	55                   	push   %ebp
801025cd:	89 e5                	mov    %esp,%ebp
801025cf:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025d6:	75 0c                	jne    801025e4 <idestart+0x18>
    panic("idestart");
801025d8:	c7 04 24 34 8e 10 80 	movl   $0x80108e34,(%esp)
801025df:	e8 59 df ff ff       	call   8010053d <panic>

  idewait(0);
801025e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025eb:	e8 f2 fe ff ff       	call   801024e2 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025f7:	00 
801025f8:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025ff:	e8 9b fe ff ff       	call   8010249f <outb>
  outb(0x1f2, 1);  // number of sectors
80102604:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010260b:	00 
8010260c:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102613:	e8 87 fe ff ff       	call   8010249f <outb>
  outb(0x1f3, b->sector & 0xff);
80102618:	8b 45 08             	mov    0x8(%ebp),%eax
8010261b:	8b 40 08             	mov    0x8(%eax),%eax
8010261e:	0f b6 c0             	movzbl %al,%eax
80102621:	89 44 24 04          	mov    %eax,0x4(%esp)
80102625:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010262c:	e8 6e fe ff ff       	call   8010249f <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102631:	8b 45 08             	mov    0x8(%ebp),%eax
80102634:	8b 40 08             	mov    0x8(%eax),%eax
80102637:	c1 e8 08             	shr    $0x8,%eax
8010263a:	0f b6 c0             	movzbl %al,%eax
8010263d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102641:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102648:	e8 52 fe ff ff       	call   8010249f <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010264d:	8b 45 08             	mov    0x8(%ebp),%eax
80102650:	8b 40 08             	mov    0x8(%eax),%eax
80102653:	c1 e8 10             	shr    $0x10,%eax
80102656:	0f b6 c0             	movzbl %al,%eax
80102659:	89 44 24 04          	mov    %eax,0x4(%esp)
8010265d:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102664:	e8 36 fe ff ff       	call   8010249f <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
8010266c:	8b 40 04             	mov    0x4(%eax),%eax
8010266f:	83 e0 01             	and    $0x1,%eax
80102672:	89 c2                	mov    %eax,%edx
80102674:	c1 e2 04             	shl    $0x4,%edx
80102677:	8b 45 08             	mov    0x8(%ebp),%eax
8010267a:	8b 40 08             	mov    0x8(%eax),%eax
8010267d:	c1 e8 18             	shr    $0x18,%eax
80102680:	83 e0 0f             	and    $0xf,%eax
80102683:	09 d0                	or     %edx,%eax
80102685:	83 c8 e0             	or     $0xffffffe0,%eax
80102688:	0f b6 c0             	movzbl %al,%eax
8010268b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010268f:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102696:	e8 04 fe ff ff       	call   8010249f <outb>
  if(b->flags & B_DIRTY){
8010269b:	8b 45 08             	mov    0x8(%ebp),%eax
8010269e:	8b 00                	mov    (%eax),%eax
801026a0:	83 e0 04             	and    $0x4,%eax
801026a3:	85 c0                	test   %eax,%eax
801026a5:	74 34                	je     801026db <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026a7:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026ae:	00 
801026af:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026b6:	e8 e4 fd ff ff       	call   8010249f <outb>
    outsl(0x1f0, b->data, 512/4);
801026bb:	8b 45 08             	mov    0x8(%ebp),%eax
801026be:	83 c0 18             	add    $0x18,%eax
801026c1:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026c8:	00 
801026c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801026cd:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026d4:	e8 e4 fd ff ff       	call   801024bd <outsl>
801026d9:	eb 14                	jmp    801026ef <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026db:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026e2:	00 
801026e3:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026ea:	e8 b0 fd ff ff       	call   8010249f <outb>
  }
}
801026ef:	c9                   	leave  
801026f0:	c3                   	ret    

801026f1 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026f1:	55                   	push   %ebp
801026f2:	89 e5                	mov    %esp,%ebp
801026f4:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026f7:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801026fe:	e8 74 2e 00 00       	call   80105577 <acquire>
  if((b = idequeue) == 0){
80102703:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102708:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010270b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010270f:	75 11                	jne    80102722 <ideintr+0x31>
    release(&idelock);
80102711:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102718:	e8 bc 2e 00 00       	call   801055d9 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010271d:	e9 90 00 00 00       	jmp    801027b2 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102725:	8b 40 14             	mov    0x14(%eax),%eax
80102728:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102730:	8b 00                	mov    (%eax),%eax
80102732:	83 e0 04             	and    $0x4,%eax
80102735:	85 c0                	test   %eax,%eax
80102737:	75 2e                	jne    80102767 <ideintr+0x76>
80102739:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102740:	e8 9d fd ff ff       	call   801024e2 <idewait>
80102745:	85 c0                	test   %eax,%eax
80102747:	78 1e                	js     80102767 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274c:	83 c0 18             	add    $0x18,%eax
8010274f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102756:	00 
80102757:	89 44 24 04          	mov    %eax,0x4(%esp)
8010275b:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102762:	e8 13 fd ff ff       	call   8010247a <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276a:	8b 00                	mov    (%eax),%eax
8010276c:	89 c2                	mov    %eax,%edx
8010276e:	83 ca 02             	or     $0x2,%edx
80102771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102774:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102779:	8b 00                	mov    (%eax),%eax
8010277b:	89 c2                	mov    %eax,%edx
8010277d:	83 e2 fb             	and    $0xfffffffb,%edx
80102780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102783:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102788:	89 04 24             	mov    %eax,(%esp)
8010278b:	e8 dd 2b 00 00       	call   8010536d <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102790:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102795:	85 c0                	test   %eax,%eax
80102797:	74 0d                	je     801027a6 <ideintr+0xb5>
    idestart(idequeue);
80102799:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010279e:	89 04 24             	mov    %eax,(%esp)
801027a1:	e8 26 fe ff ff       	call   801025cc <idestart>

  release(&idelock);
801027a6:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027ad:	e8 27 2e 00 00       	call   801055d9 <release>
}
801027b2:	c9                   	leave  
801027b3:	c3                   	ret    

801027b4 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027b4:	55                   	push   %ebp
801027b5:	89 e5                	mov    %esp,%ebp
801027b7:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027ba:	8b 45 08             	mov    0x8(%ebp),%eax
801027bd:	8b 00                	mov    (%eax),%eax
801027bf:	83 e0 01             	and    $0x1,%eax
801027c2:	85 c0                	test   %eax,%eax
801027c4:	75 0c                	jne    801027d2 <iderw+0x1e>
    panic("iderw: buf not busy");
801027c6:	c7 04 24 3d 8e 10 80 	movl   $0x80108e3d,(%esp)
801027cd:	e8 6b dd ff ff       	call   8010053d <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027d2:	8b 45 08             	mov    0x8(%ebp),%eax
801027d5:	8b 00                	mov    (%eax),%eax
801027d7:	83 e0 06             	and    $0x6,%eax
801027da:	83 f8 02             	cmp    $0x2,%eax
801027dd:	75 0c                	jne    801027eb <iderw+0x37>
    panic("iderw: nothing to do");
801027df:	c7 04 24 51 8e 10 80 	movl   $0x80108e51,(%esp)
801027e6:	e8 52 dd ff ff       	call   8010053d <panic>
  if(b->dev != 0 && !havedisk1)
801027eb:	8b 45 08             	mov    0x8(%ebp),%eax
801027ee:	8b 40 04             	mov    0x4(%eax),%eax
801027f1:	85 c0                	test   %eax,%eax
801027f3:	74 15                	je     8010280a <iderw+0x56>
801027f5:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801027fa:	85 c0                	test   %eax,%eax
801027fc:	75 0c                	jne    8010280a <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027fe:	c7 04 24 66 8e 10 80 	movl   $0x80108e66,(%esp)
80102805:	e8 33 dd ff ff       	call   8010053d <panic>

  acquire(&idelock);  //DOC: acquire-lock
8010280a:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102811:	e8 61 2d 00 00       	call   80105577 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102816:	8b 45 08             	mov    0x8(%ebp),%eax
80102819:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC: insert-queue
80102820:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102827:	eb 0b                	jmp    80102834 <iderw+0x80>
80102829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282c:	8b 00                	mov    (%eax),%eax
8010282e:	83 c0 14             	add    $0x14,%eax
80102831:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102837:	8b 00                	mov    (%eax),%eax
80102839:	85 c0                	test   %eax,%eax
8010283b:	75 ec                	jne    80102829 <iderw+0x75>
    ;
  *pp = b;
8010283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102840:	8b 55 08             	mov    0x8(%ebp),%edx
80102843:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102845:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010284a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010284d:	75 22                	jne    80102871 <iderw+0xbd>
    idestart(b);
8010284f:	8b 45 08             	mov    0x8(%ebp),%eax
80102852:	89 04 24             	mov    %eax,(%esp)
80102855:	e8 72 fd ff ff       	call   801025cc <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010285a:	eb 15                	jmp    80102871 <iderw+0xbd>
    sleep(b, &idelock);
8010285c:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
80102863:	80 
80102864:	8b 45 08             	mov    0x8(%ebp),%eax
80102867:	89 04 24             	mov    %eax,(%esp)
8010286a:	e8 22 2a 00 00       	call   80105291 <sleep>
8010286f:	eb 01                	jmp    80102872 <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102871:	90                   	nop
80102872:	8b 45 08             	mov    0x8(%ebp),%eax
80102875:	8b 00                	mov    (%eax),%eax
80102877:	83 e0 06             	and    $0x6,%eax
8010287a:	83 f8 02             	cmp    $0x2,%eax
8010287d:	75 dd                	jne    8010285c <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
8010287f:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102886:	e8 4e 2d 00 00       	call   801055d9 <release>
}
8010288b:	c9                   	leave  
8010288c:	c3                   	ret    
8010288d:	00 00                	add    %al,(%eax)
	...

80102890 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102893:	a1 74 08 11 80       	mov    0x80110874,%eax
80102898:	8b 55 08             	mov    0x8(%ebp),%edx
8010289b:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010289d:	a1 74 08 11 80       	mov    0x80110874,%eax
801028a2:	8b 40 10             	mov    0x10(%eax),%eax
}
801028a5:	5d                   	pop    %ebp
801028a6:	c3                   	ret    

801028a7 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028a7:	55                   	push   %ebp
801028a8:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028aa:	a1 74 08 11 80       	mov    0x80110874,%eax
801028af:	8b 55 08             	mov    0x8(%ebp),%edx
801028b2:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028b4:	a1 74 08 11 80       	mov    0x80110874,%eax
801028b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801028bc:	89 50 10             	mov    %edx,0x10(%eax)
}
801028bf:	5d                   	pop    %ebp
801028c0:	c3                   	ret    

801028c1 <ioapicinit>:

void
ioapicinit(void)
{
801028c1:	55                   	push   %ebp
801028c2:	89 e5                	mov    %esp,%ebp
801028c4:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028c7:	a1 44 09 11 80       	mov    0x80110944,%eax
801028cc:	85 c0                	test   %eax,%eax
801028ce:	0f 84 9f 00 00 00    	je     80102973 <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801028d4:	c7 05 74 08 11 80 00 	movl   $0xfec00000,0x80110874
801028db:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028e5:	e8 a6 ff ff ff       	call   80102890 <ioapicread>
801028ea:	c1 e8 10             	shr    $0x10,%eax
801028ed:	25 ff 00 00 00       	and    $0xff,%eax
801028f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028fc:	e8 8f ff ff ff       	call   80102890 <ioapicread>
80102901:	c1 e8 18             	shr    $0x18,%eax
80102904:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102907:	0f b6 05 40 09 11 80 	movzbl 0x80110940,%eax
8010290e:	0f b6 c0             	movzbl %al,%eax
80102911:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102914:	74 0c                	je     80102922 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102916:	c7 04 24 84 8e 10 80 	movl   $0x80108e84,(%esp)
8010291d:	e8 7f da ff ff       	call   801003a1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102929:	eb 3e                	jmp    80102969 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010292e:	83 c0 20             	add    $0x20,%eax
80102931:	0d 00 00 01 00       	or     $0x10000,%eax
80102936:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102939:	83 c2 08             	add    $0x8,%edx
8010293c:	01 d2                	add    %edx,%edx
8010293e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102942:	89 14 24             	mov    %edx,(%esp)
80102945:	e8 5d ff ff ff       	call   801028a7 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294d:	83 c0 08             	add    $0x8,%eax
80102950:	01 c0                	add    %eax,%eax
80102952:	83 c0 01             	add    $0x1,%eax
80102955:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010295c:	00 
8010295d:	89 04 24             	mov    %eax,(%esp)
80102960:	e8 42 ff ff ff       	call   801028a7 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102965:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010296f:	7e ba                	jle    8010292b <ioapicinit+0x6a>
80102971:	eb 01                	jmp    80102974 <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102973:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102974:	c9                   	leave  
80102975:	c3                   	ret    

80102976 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102976:	55                   	push   %ebp
80102977:	89 e5                	mov    %esp,%ebp
80102979:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
8010297c:	a1 44 09 11 80       	mov    0x80110944,%eax
80102981:	85 c0                	test   %eax,%eax
80102983:	74 39                	je     801029be <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102985:	8b 45 08             	mov    0x8(%ebp),%eax
80102988:	83 c0 20             	add    $0x20,%eax
8010298b:	8b 55 08             	mov    0x8(%ebp),%edx
8010298e:	83 c2 08             	add    $0x8,%edx
80102991:	01 d2                	add    %edx,%edx
80102993:	89 44 24 04          	mov    %eax,0x4(%esp)
80102997:	89 14 24             	mov    %edx,(%esp)
8010299a:	e8 08 ff ff ff       	call   801028a7 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010299f:	8b 45 0c             	mov    0xc(%ebp),%eax
801029a2:	c1 e0 18             	shl    $0x18,%eax
801029a5:	8b 55 08             	mov    0x8(%ebp),%edx
801029a8:	83 c2 08             	add    $0x8,%edx
801029ab:	01 d2                	add    %edx,%edx
801029ad:	83 c2 01             	add    $0x1,%edx
801029b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b4:	89 14 24             	mov    %edx,(%esp)
801029b7:	e8 eb fe ff ff       	call   801028a7 <ioapicwrite>
801029bc:	eb 01                	jmp    801029bf <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
801029be:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801029bf:	c9                   	leave  
801029c0:	c3                   	ret    
801029c1:	00 00                	add    %al,(%eax)
	...

801029c4 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029c4:	55                   	push   %ebp
801029c5:	89 e5                	mov    %esp,%ebp
801029c7:	8b 45 08             	mov    0x8(%ebp),%eax
801029ca:	05 00 00 00 80       	add    $0x80000000,%eax
801029cf:	5d                   	pop    %ebp
801029d0:	c3                   	ret    

801029d1 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029d1:	55                   	push   %ebp
801029d2:	89 e5                	mov    %esp,%ebp
801029d4:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029d7:	c7 44 24 04 b6 8e 10 	movl   $0x80108eb6,0x4(%esp)
801029de:	80 
801029df:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
801029e6:	e8 6b 2b 00 00       	call   80105556 <initlock>
  kmem.use_lock = 0;
801029eb:	c7 05 b4 08 11 80 00 	movl   $0x0,0x801108b4
801029f2:	00 00 00 
  freerange(vstart, vend);
801029f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801029f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801029fc:	8b 45 08             	mov    0x8(%ebp),%eax
801029ff:	89 04 24             	mov    %eax,(%esp)
80102a02:	e8 26 00 00 00       	call   80102a2d <freerange>
}
80102a07:	c9                   	leave  
80102a08:	c3                   	ret    

80102a09 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a09:	55                   	push   %ebp
80102a0a:	89 e5                	mov    %esp,%ebp
80102a0c:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a12:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a16:	8b 45 08             	mov    0x8(%ebp),%eax
80102a19:	89 04 24             	mov    %eax,(%esp)
80102a1c:	e8 0c 00 00 00       	call   80102a2d <freerange>
  kmem.use_lock = 1;
80102a21:	c7 05 b4 08 11 80 01 	movl   $0x1,0x801108b4
80102a28:	00 00 00 
}
80102a2b:	c9                   	leave  
80102a2c:	c3                   	ret    

80102a2d <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a2d:	55                   	push   %ebp
80102a2e:	89 e5                	mov    %esp,%ebp
80102a30:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a33:	8b 45 08             	mov    0x8(%ebp),%eax
80102a36:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a43:	eb 12                	jmp    80102a57 <freerange+0x2a>
    kfree(p);
80102a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a48:	89 04 24             	mov    %eax,(%esp)
80102a4b:	e8 16 00 00 00       	call   80102a66 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a50:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a5a:	05 00 10 00 00       	add    $0x1000,%eax
80102a5f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a62:	76 e1                	jbe    80102a45 <freerange+0x18>
    kfree(p);
}
80102a64:	c9                   	leave  
80102a65:	c3                   	ret    

80102a66 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a66:	55                   	push   %ebp
80102a67:	89 e5                	mov    %esp,%ebp
80102a69:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a6f:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a74:	85 c0                	test   %eax,%eax
80102a76:	75 1b                	jne    80102a93 <kfree+0x2d>
80102a78:	81 7d 08 7c 63 11 80 	cmpl   $0x8011637c,0x8(%ebp)
80102a7f:	72 12                	jb     80102a93 <kfree+0x2d>
80102a81:	8b 45 08             	mov    0x8(%ebp),%eax
80102a84:	89 04 24             	mov    %eax,(%esp)
80102a87:	e8 38 ff ff ff       	call   801029c4 <v2p>
80102a8c:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a91:	76 0c                	jbe    80102a9f <kfree+0x39>
    panic("kfree");
80102a93:	c7 04 24 bb 8e 10 80 	movl   $0x80108ebb,(%esp)
80102a9a:	e8 9e da ff ff       	call   8010053d <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a9f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102aa6:	00 
80102aa7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102aae:	00 
80102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab2:	89 04 24             	mov    %eax,(%esp)
80102ab5:	e8 0c 2d 00 00       	call   801057c6 <memset>

  if(kmem.use_lock)
80102aba:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102abf:	85 c0                	test   %eax,%eax
80102ac1:	74 0c                	je     80102acf <kfree+0x69>
    acquire(&kmem.lock);
80102ac3:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102aca:	e8 a8 2a 00 00       	call   80105577 <acquire>
  r = (struct run*)v;
80102acf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ad5:	8b 15 b8 08 11 80    	mov    0x801108b8,%edx
80102adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ade:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae3:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102ae8:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102aed:	85 c0                	test   %eax,%eax
80102aef:	74 0c                	je     80102afd <kfree+0x97>
    release(&kmem.lock);
80102af1:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102af8:	e8 dc 2a 00 00       	call   801055d9 <release>
}
80102afd:	c9                   	leave  
80102afe:	c3                   	ret    

80102aff <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102aff:	55                   	push   %ebp
80102b00:	89 e5                	mov    %esp,%ebp
80102b02:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b05:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102b0a:	85 c0                	test   %eax,%eax
80102b0c:	74 0c                	je     80102b1a <kalloc+0x1b>
    acquire(&kmem.lock);
80102b0e:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b15:	e8 5d 2a 00 00       	call   80105577 <acquire>
  r = kmem.freelist;
80102b1a:	a1 b8 08 11 80       	mov    0x801108b8,%eax
80102b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b26:	74 0a                	je     80102b32 <kalloc+0x33>
    kmem.freelist = r->next;
80102b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2b:	8b 00                	mov    (%eax),%eax
80102b2d:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102b32:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102b37:	85 c0                	test   %eax,%eax
80102b39:	74 0c                	je     80102b47 <kalloc+0x48>
    release(&kmem.lock);
80102b3b:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b42:	e8 92 2a 00 00       	call   801055d9 <release>
  return (char*)r;
80102b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b4a:	c9                   	leave  
80102b4b:	c3                   	ret    

80102b4c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b4c:	55                   	push   %ebp
80102b4d:	89 e5                	mov    %esp,%ebp
80102b4f:	53                   	push   %ebx
80102b50:	83 ec 14             	sub    $0x14,%esp
80102b53:	8b 45 08             	mov    0x8(%ebp),%eax
80102b56:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80102b5e:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102b62:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80102b66:	ec                   	in     (%dx),%al
80102b67:	89 c3                	mov    %eax,%ebx
80102b69:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102b6c:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80102b70:	83 c4 14             	add    $0x14,%esp
80102b73:	5b                   	pop    %ebx
80102b74:	5d                   	pop    %ebp
80102b75:	c3                   	ret    

80102b76 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b76:	55                   	push   %ebp
80102b77:	89 e5                	mov    %esp,%ebp
80102b79:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b7c:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b83:	e8 c4 ff ff ff       	call   80102b4c <inb>
80102b88:	0f b6 c0             	movzbl %al,%eax
80102b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b91:	83 e0 01             	and    $0x1,%eax
80102b94:	85 c0                	test   %eax,%eax
80102b96:	75 0a                	jne    80102ba2 <kbdgetc+0x2c>
    return -1;
80102b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b9d:	e9 23 01 00 00       	jmp    80102cc5 <kbdgetc+0x14f>
  data = inb(KBDATAP);
80102ba2:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102ba9:	e8 9e ff ff ff       	call   80102b4c <inb>
80102bae:	0f b6 c0             	movzbl %al,%eax
80102bb1:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102bb4:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102bbb:	75 17                	jne    80102bd4 <kbdgetc+0x5e>
    shift |= E0ESC;
80102bbd:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bc2:	83 c8 40             	or     $0x40,%eax
80102bc5:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102bca:	b8 00 00 00 00       	mov    $0x0,%eax
80102bcf:	e9 f1 00 00 00       	jmp    80102cc5 <kbdgetc+0x14f>
  } else if(data & 0x80){
80102bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bd7:	25 80 00 00 00       	and    $0x80,%eax
80102bdc:	85 c0                	test   %eax,%eax
80102bde:	74 45                	je     80102c25 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102be0:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102be5:	83 e0 40             	and    $0x40,%eax
80102be8:	85 c0                	test   %eax,%eax
80102bea:	75 08                	jne    80102bf4 <kbdgetc+0x7e>
80102bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bef:	83 e0 7f             	and    $0x7f,%eax
80102bf2:	eb 03                	jmp    80102bf7 <kbdgetc+0x81>
80102bf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bfd:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c02:	0f b6 00             	movzbl (%eax),%eax
80102c05:	83 c8 40             	or     $0x40,%eax
80102c08:	0f b6 c0             	movzbl %al,%eax
80102c0b:	f7 d0                	not    %eax
80102c0d:	89 c2                	mov    %eax,%edx
80102c0f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c14:	21 d0                	and    %edx,%eax
80102c16:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c1b:	b8 00 00 00 00       	mov    $0x0,%eax
80102c20:	e9 a0 00 00 00       	jmp    80102cc5 <kbdgetc+0x14f>
  } else if(shift & E0ESC){
80102c25:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c2a:	83 e0 40             	and    $0x40,%eax
80102c2d:	85 c0                	test   %eax,%eax
80102c2f:	74 14                	je     80102c45 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c31:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c38:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c3d:	83 e0 bf             	and    $0xffffffbf,%eax
80102c40:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c48:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c4d:	0f b6 00             	movzbl (%eax),%eax
80102c50:	0f b6 d0             	movzbl %al,%edx
80102c53:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c58:	09 d0                	or     %edx,%eax
80102c5a:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c62:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102c67:	0f b6 00             	movzbl (%eax),%eax
80102c6a:	0f b6 d0             	movzbl %al,%edx
80102c6d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c72:	31 d0                	xor    %edx,%eax
80102c74:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c79:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c7e:	83 e0 03             	and    $0x3,%eax
80102c81:	8b 04 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%eax
80102c88:	03 45 fc             	add    -0x4(%ebp),%eax
80102c8b:	0f b6 00             	movzbl (%eax),%eax
80102c8e:	0f b6 c0             	movzbl %al,%eax
80102c91:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c94:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c99:	83 e0 08             	and    $0x8,%eax
80102c9c:	85 c0                	test   %eax,%eax
80102c9e:	74 22                	je     80102cc2 <kbdgetc+0x14c>
    if('a' <= c && c <= 'z')
80102ca0:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102ca4:	76 0c                	jbe    80102cb2 <kbdgetc+0x13c>
80102ca6:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102caa:	77 06                	ja     80102cb2 <kbdgetc+0x13c>
      c += 'A' - 'a';
80102cac:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102cb0:	eb 10                	jmp    80102cc2 <kbdgetc+0x14c>
    else if('A' <= c && c <= 'Z')
80102cb2:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102cb6:	76 0a                	jbe    80102cc2 <kbdgetc+0x14c>
80102cb8:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102cbc:	77 04                	ja     80102cc2 <kbdgetc+0x14c>
      c += 'a' - 'A';
80102cbe:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102cc5:	c9                   	leave  
80102cc6:	c3                   	ret    

80102cc7 <kbdintr>:

void
kbdintr(void)
{
80102cc7:	55                   	push   %ebp
80102cc8:	89 e5                	mov    %esp,%ebp
80102cca:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102ccd:	c7 04 24 76 2b 10 80 	movl   $0x80102b76,(%esp)
80102cd4:	e8 d4 da ff ff       	call   801007ad <consoleintr>
}
80102cd9:	c9                   	leave  
80102cda:	c3                   	ret    
	...

80102cdc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102cdc:	55                   	push   %ebp
80102cdd:	89 e5                	mov    %esp,%ebp
80102cdf:	83 ec 08             	sub    $0x8,%esp
80102ce2:	8b 55 08             	mov    0x8(%ebp),%edx
80102ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ce8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102cec:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cef:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cf3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cf7:	ee                   	out    %al,(%dx)
}
80102cf8:	c9                   	leave  
80102cf9:	c3                   	ret    

80102cfa <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cfa:	55                   	push   %ebp
80102cfb:	89 e5                	mov    %esp,%ebp
80102cfd:	53                   	push   %ebx
80102cfe:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d01:	9c                   	pushf  
80102d02:	5b                   	pop    %ebx
80102d03:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102d06:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d09:	83 c4 10             	add    $0x10,%esp
80102d0c:	5b                   	pop    %ebx
80102d0d:	5d                   	pop    %ebp
80102d0e:	c3                   	ret    

80102d0f <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d0f:	55                   	push   %ebp
80102d10:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d12:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102d17:	8b 55 08             	mov    0x8(%ebp),%edx
80102d1a:	c1 e2 02             	shl    $0x2,%edx
80102d1d:	01 c2                	add    %eax,%edx
80102d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d22:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d24:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102d29:	83 c0 20             	add    $0x20,%eax
80102d2c:	8b 00                	mov    (%eax),%eax
}
80102d2e:	5d                   	pop    %ebp
80102d2f:	c3                   	ret    

80102d30 <lapicinit>:
//PAGEBREAK!

void
lapicinit(int c)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d36:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102d3b:	85 c0                	test   %eax,%eax
80102d3d:	0f 84 47 01 00 00    	je     80102e8a <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d43:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d4a:	00 
80102d4b:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d52:	e8 b8 ff ff ff       	call   80102d0f <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d57:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d5e:	00 
80102d5f:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d66:	e8 a4 ff ff ff       	call   80102d0f <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d6b:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d72:	00 
80102d73:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d7a:	e8 90 ff ff ff       	call   80102d0f <lapicw>
  lapicw(TICR, 10000000); 
80102d7f:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d86:	00 
80102d87:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d8e:	e8 7c ff ff ff       	call   80102d0f <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d93:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d9a:	00 
80102d9b:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102da2:	e8 68 ff ff ff       	call   80102d0f <lapicw>
  lapicw(LINT1, MASKED);
80102da7:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dae:	00 
80102daf:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102db6:	e8 54 ff ff ff       	call   80102d0f <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102dbb:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102dc0:	83 c0 30             	add    $0x30,%eax
80102dc3:	8b 00                	mov    (%eax),%eax
80102dc5:	c1 e8 10             	shr    $0x10,%eax
80102dc8:	25 ff 00 00 00       	and    $0xff,%eax
80102dcd:	83 f8 03             	cmp    $0x3,%eax
80102dd0:	76 14                	jbe    80102de6 <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102dd2:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dd9:	00 
80102dda:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102de1:	e8 29 ff ff ff       	call   80102d0f <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102de6:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102ded:	00 
80102dee:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102df5:	e8 15 ff ff ff       	call   80102d0f <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102dfa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e01:	00 
80102e02:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e09:	e8 01 ff ff ff       	call   80102d0f <lapicw>
  lapicw(ESR, 0);
80102e0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e15:	00 
80102e16:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e1d:	e8 ed fe ff ff       	call   80102d0f <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e29:	00 
80102e2a:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e31:	e8 d9 fe ff ff       	call   80102d0f <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e3d:	00 
80102e3e:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e45:	e8 c5 fe ff ff       	call   80102d0f <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e4a:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e51:	00 
80102e52:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e59:	e8 b1 fe ff ff       	call   80102d0f <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e5e:	90                   	nop
80102e5f:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102e64:	05 00 03 00 00       	add    $0x300,%eax
80102e69:	8b 00                	mov    (%eax),%eax
80102e6b:	25 00 10 00 00       	and    $0x1000,%eax
80102e70:	85 c0                	test   %eax,%eax
80102e72:	75 eb                	jne    80102e5f <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e74:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e7b:	00 
80102e7c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e83:	e8 87 fe ff ff       	call   80102d0f <lapicw>
80102e88:	eb 01                	jmp    80102e8b <lapicinit+0x15b>

void
lapicinit(int c)
{
  if(!lapic) 
    return;
80102e8a:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102e8b:	c9                   	leave  
80102e8c:	c3                   	ret    

80102e8d <cpunum>:

int
cpunum(void)
{
80102e8d:	55                   	push   %ebp
80102e8e:	89 e5                	mov    %esp,%ebp
80102e90:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e93:	e8 62 fe ff ff       	call   80102cfa <readeflags>
80102e98:	25 00 02 00 00       	and    $0x200,%eax
80102e9d:	85 c0                	test   %eax,%eax
80102e9f:	74 29                	je     80102eca <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80102ea1:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102ea6:	85 c0                	test   %eax,%eax
80102ea8:	0f 94 c2             	sete   %dl
80102eab:	83 c0 01             	add    $0x1,%eax
80102eae:	a3 60 c6 10 80       	mov    %eax,0x8010c660
80102eb3:	84 d2                	test   %dl,%dl
80102eb5:	74 13                	je     80102eca <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80102eb7:	8b 45 04             	mov    0x4(%ebp),%eax
80102eba:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ebe:	c7 04 24 c4 8e 10 80 	movl   $0x80108ec4,(%esp)
80102ec5:	e8 d7 d4 ff ff       	call   801003a1 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102eca:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102ecf:	85 c0                	test   %eax,%eax
80102ed1:	74 0f                	je     80102ee2 <cpunum+0x55>
    return lapic[ID]>>24;
80102ed3:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102ed8:	83 c0 20             	add    $0x20,%eax
80102edb:	8b 00                	mov    (%eax),%eax
80102edd:	c1 e8 18             	shr    $0x18,%eax
80102ee0:	eb 05                	jmp    80102ee7 <cpunum+0x5a>
  return 0;
80102ee2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ee7:	c9                   	leave  
80102ee8:	c3                   	ret    

80102ee9 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ee9:	55                   	push   %ebp
80102eea:	89 e5                	mov    %esp,%ebp
80102eec:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102eef:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102ef4:	85 c0                	test   %eax,%eax
80102ef6:	74 14                	je     80102f0c <lapiceoi+0x23>
    lapicw(EOI, 0);
80102ef8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eff:	00 
80102f00:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f07:	e8 03 fe ff ff       	call   80102d0f <lapicw>
}
80102f0c:	c9                   	leave  
80102f0d:	c3                   	ret    

80102f0e <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f0e:	55                   	push   %ebp
80102f0f:	89 e5                	mov    %esp,%ebp
}
80102f11:	5d                   	pop    %ebp
80102f12:	c3                   	ret    

80102f13 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f13:	55                   	push   %ebp
80102f14:	89 e5                	mov    %esp,%ebp
80102f16:	83 ec 1c             	sub    $0x1c,%esp
80102f19:	8b 45 08             	mov    0x8(%ebp),%eax
80102f1c:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f1f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f26:	00 
80102f27:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f2e:	e8 a9 fd ff ff       	call   80102cdc <outb>
  outb(IO_RTC+1, 0x0A);
80102f33:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f3a:	00 
80102f3b:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f42:	e8 95 fd ff ff       	call   80102cdc <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f47:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f51:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f56:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f59:	8d 50 02             	lea    0x2(%eax),%edx
80102f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f5f:	c1 e8 04             	shr    $0x4,%eax
80102f62:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f65:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f69:	c1 e0 18             	shl    $0x18,%eax
80102f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f70:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f77:	e8 93 fd ff ff       	call   80102d0f <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f7c:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f83:	00 
80102f84:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f8b:	e8 7f fd ff ff       	call   80102d0f <lapicw>
  microdelay(200);
80102f90:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f97:	e8 72 ff ff ff       	call   80102f0e <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f9c:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102fa3:	00 
80102fa4:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fab:	e8 5f fd ff ff       	call   80102d0f <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fb0:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fb7:	e8 52 ff ff ff       	call   80102f0e <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102fc3:	eb 40                	jmp    80103005 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fc5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fc9:	c1 e0 18             	shl    $0x18,%eax
80102fcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fd0:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fd7:	e8 33 fd ff ff       	call   80102d0f <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fdf:	c1 e8 0c             	shr    $0xc,%eax
80102fe2:	80 cc 06             	or     $0x6,%ah
80102fe5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fe9:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ff0:	e8 1a fd ff ff       	call   80102d0f <lapicw>
    microdelay(200);
80102ff5:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102ffc:	e8 0d ff ff ff       	call   80102f0e <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103001:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103005:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103009:	7e ba                	jle    80102fc5 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010300b:	c9                   	leave  
8010300c:	c3                   	ret    
8010300d:	00 00                	add    %al,(%eax)
	...

80103010 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103016:	c7 44 24 04 f0 8e 10 	movl   $0x80108ef0,0x4(%esp)
8010301d:	80 
8010301e:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103025:	e8 2c 25 00 00       	call   80105556 <initlock>
  readsb(ROOTDEV, &sb);
8010302a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010302d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103031:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103038:	e8 af e2 ff ff       	call   801012ec <readsb>
  log.start = sb.size - sb.nlog;
8010303d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103040:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103043:	89 d1                	mov    %edx,%ecx
80103045:	29 c1                	sub    %eax,%ecx
80103047:	89 c8                	mov    %ecx,%eax
80103049:	a3 f4 08 11 80       	mov    %eax,0x801108f4
  log.size = sb.nlog;
8010304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103051:	a3 f8 08 11 80       	mov    %eax,0x801108f8
  log.dev = ROOTDEV;
80103056:	c7 05 00 09 11 80 01 	movl   $0x1,0x80110900
8010305d:	00 00 00 
  recover_from_log();
80103060:	e8 97 01 00 00       	call   801031fc <recover_from_log>
}
80103065:	c9                   	leave  
80103066:	c3                   	ret    

80103067 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103067:	55                   	push   %ebp
80103068:	89 e5                	mov    %esp,%ebp
8010306a:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010306d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103074:	e9 89 00 00 00       	jmp    80103102 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103079:	a1 f4 08 11 80       	mov    0x801108f4,%eax
8010307e:	03 45 f4             	add    -0xc(%ebp),%eax
80103081:	83 c0 01             	add    $0x1,%eax
80103084:	89 c2                	mov    %eax,%edx
80103086:	a1 00 09 11 80       	mov    0x80110900,%eax
8010308b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010308f:	89 04 24             	mov    %eax,(%esp)
80103092:	e8 0f d1 ff ff       	call   801001a6 <bread>
80103097:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010309d:	83 c0 10             	add    $0x10,%eax
801030a0:	8b 04 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%eax
801030a7:	89 c2                	mov    %eax,%edx
801030a9:	a1 00 09 11 80       	mov    0x80110900,%eax
801030ae:	89 54 24 04          	mov    %edx,0x4(%esp)
801030b2:	89 04 24             	mov    %eax,(%esp)
801030b5:	e8 ec d0 ff ff       	call   801001a6 <bread>
801030ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030c0:	8d 50 18             	lea    0x18(%eax),%edx
801030c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030c6:	83 c0 18             	add    $0x18,%eax
801030c9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801030d0:	00 
801030d1:	89 54 24 04          	mov    %edx,0x4(%esp)
801030d5:	89 04 24             	mov    %eax,(%esp)
801030d8:	e8 bc 27 00 00       	call   80105899 <memmove>
    bwrite(dbuf);  // write dst to disk
801030dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030e0:	89 04 24             	mov    %eax,(%esp)
801030e3:	e8 f5 d0 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801030e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030eb:	89 04 24             	mov    %eax,(%esp)
801030ee:	e8 24 d1 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801030f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030f6:	89 04 24             	mov    %eax,(%esp)
801030f9:	e8 19 d1 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103102:	a1 04 09 11 80       	mov    0x80110904,%eax
80103107:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010310a:	0f 8f 69 ff ff ff    	jg     80103079 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103110:	c9                   	leave  
80103111:	c3                   	ret    

80103112 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103112:	55                   	push   %ebp
80103113:	89 e5                	mov    %esp,%ebp
80103115:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103118:	a1 f4 08 11 80       	mov    0x801108f4,%eax
8010311d:	89 c2                	mov    %eax,%edx
8010311f:	a1 00 09 11 80       	mov    0x80110900,%eax
80103124:	89 54 24 04          	mov    %edx,0x4(%esp)
80103128:	89 04 24             	mov    %eax,(%esp)
8010312b:	e8 76 d0 ff ff       	call   801001a6 <bread>
80103130:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103133:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103136:	83 c0 18             	add    $0x18,%eax
80103139:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010313c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010313f:	8b 00                	mov    (%eax),%eax
80103141:	a3 04 09 11 80       	mov    %eax,0x80110904
  for (i = 0; i < log.lh.n; i++) {
80103146:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010314d:	eb 1b                	jmp    8010316a <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010314f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103152:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103155:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103159:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010315c:	83 c2 10             	add    $0x10,%edx
8010315f:	89 04 95 c8 08 11 80 	mov    %eax,-0x7feef738(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103166:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010316a:	a1 04 09 11 80       	mov    0x80110904,%eax
8010316f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103172:	7f db                	jg     8010314f <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103174:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103177:	89 04 24             	mov    %eax,(%esp)
8010317a:	e8 98 d0 ff ff       	call   80100217 <brelse>
}
8010317f:	c9                   	leave  
80103180:	c3                   	ret    

80103181 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103181:	55                   	push   %ebp
80103182:	89 e5                	mov    %esp,%ebp
80103184:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103187:	a1 f4 08 11 80       	mov    0x801108f4,%eax
8010318c:	89 c2                	mov    %eax,%edx
8010318e:	a1 00 09 11 80       	mov    0x80110900,%eax
80103193:	89 54 24 04          	mov    %edx,0x4(%esp)
80103197:	89 04 24             	mov    %eax,(%esp)
8010319a:	e8 07 d0 ff ff       	call   801001a6 <bread>
8010319f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a5:	83 c0 18             	add    $0x18,%eax
801031a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801031ab:	8b 15 04 09 11 80    	mov    0x80110904,%edx
801031b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031b4:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801031b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031bd:	eb 1b                	jmp    801031da <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031c2:	83 c0 10             	add    $0x10,%eax
801031c5:	8b 0c 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%ecx
801031cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031d2:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031da:	a1 04 09 11 80       	mov    0x80110904,%eax
801031df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031e2:	7f db                	jg     801031bf <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031e7:	89 04 24             	mov    %eax,(%esp)
801031ea:	e8 ee cf ff ff       	call   801001dd <bwrite>
  brelse(buf);
801031ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031f2:	89 04 24             	mov    %eax,(%esp)
801031f5:	e8 1d d0 ff ff       	call   80100217 <brelse>
}
801031fa:	c9                   	leave  
801031fb:	c3                   	ret    

801031fc <recover_from_log>:

static void
recover_from_log(void)
{
801031fc:	55                   	push   %ebp
801031fd:	89 e5                	mov    %esp,%ebp
801031ff:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103202:	e8 0b ff ff ff       	call   80103112 <read_head>
  install_trans(); // if committed, copy from log to disk
80103207:	e8 5b fe ff ff       	call   80103067 <install_trans>
  log.lh.n = 0;
8010320c:	c7 05 04 09 11 80 00 	movl   $0x0,0x80110904
80103213:	00 00 00 
  write_head(); // clear the log
80103216:	e8 66 ff ff ff       	call   80103181 <write_head>
}
8010321b:	c9                   	leave  
8010321c:	c3                   	ret    

8010321d <begin_trans>:

void
begin_trans(void)
{
8010321d:	55                   	push   %ebp
8010321e:	89 e5                	mov    %esp,%ebp
80103220:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103223:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010322a:	e8 48 23 00 00       	call   80105577 <acquire>
  while (log.busy) {
8010322f:	eb 14                	jmp    80103245 <begin_trans+0x28>
    sleep(&log, &log.lock);
80103231:	c7 44 24 04 c0 08 11 	movl   $0x801108c0,0x4(%esp)
80103238:	80 
80103239:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103240:	e8 4c 20 00 00       	call   80105291 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103245:	a1 fc 08 11 80       	mov    0x801108fc,%eax
8010324a:	85 c0                	test   %eax,%eax
8010324c:	75 e3                	jne    80103231 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010324e:	c7 05 fc 08 11 80 01 	movl   $0x1,0x801108fc
80103255:	00 00 00 
  release(&log.lock);
80103258:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010325f:	e8 75 23 00 00       	call   801055d9 <release>
}
80103264:	c9                   	leave  
80103265:	c3                   	ret    

80103266 <commit_trans>:

void
commit_trans(void)
{
80103266:	55                   	push   %ebp
80103267:	89 e5                	mov    %esp,%ebp
80103269:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
8010326c:	a1 04 09 11 80       	mov    0x80110904,%eax
80103271:	85 c0                	test   %eax,%eax
80103273:	7e 19                	jle    8010328e <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103275:	e8 07 ff ff ff       	call   80103181 <write_head>
    install_trans(); // Now install writes to home locations
8010327a:	e8 e8 fd ff ff       	call   80103067 <install_trans>
    log.lh.n = 0; 
8010327f:	c7 05 04 09 11 80 00 	movl   $0x0,0x80110904
80103286:	00 00 00 
    write_head();    // Erase the transaction from the log
80103289:	e8 f3 fe ff ff       	call   80103181 <write_head>
  }
  
  acquire(&log.lock);
8010328e:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103295:	e8 dd 22 00 00       	call   80105577 <acquire>
  log.busy = 0;
8010329a:	c7 05 fc 08 11 80 00 	movl   $0x0,0x801108fc
801032a1:	00 00 00 
  wakeup(&log);
801032a4:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801032ab:	e8 bd 20 00 00       	call   8010536d <wakeup>
  release(&log.lock);
801032b0:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801032b7:	e8 1d 23 00 00       	call   801055d9 <release>
}
801032bc:	c9                   	leave  
801032bd:	c3                   	ret    

801032be <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032be:	55                   	push   %ebp
801032bf:	89 e5                	mov    %esp,%ebp
801032c1:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032c4:	a1 04 09 11 80       	mov    0x80110904,%eax
801032c9:	83 f8 09             	cmp    $0x9,%eax
801032cc:	7f 12                	jg     801032e0 <log_write+0x22>
801032ce:	a1 04 09 11 80       	mov    0x80110904,%eax
801032d3:	8b 15 f8 08 11 80    	mov    0x801108f8,%edx
801032d9:	83 ea 01             	sub    $0x1,%edx
801032dc:	39 d0                	cmp    %edx,%eax
801032de:	7c 0c                	jl     801032ec <log_write+0x2e>
    panic("too big a transaction");
801032e0:	c7 04 24 f4 8e 10 80 	movl   $0x80108ef4,(%esp)
801032e7:	e8 51 d2 ff ff       	call   8010053d <panic>
  if (!log.busy)
801032ec:	a1 fc 08 11 80       	mov    0x801108fc,%eax
801032f1:	85 c0                	test   %eax,%eax
801032f3:	75 0c                	jne    80103301 <log_write+0x43>
    panic("write outside of trans");
801032f5:	c7 04 24 0a 8f 10 80 	movl   $0x80108f0a,(%esp)
801032fc:	e8 3c d2 ff ff       	call   8010053d <panic>

  for (i = 0; i < log.lh.n; i++) {
80103301:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103308:	eb 1d                	jmp    80103327 <log_write+0x69>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
8010330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010330d:	83 c0 10             	add    $0x10,%eax
80103310:	8b 04 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%eax
80103317:	89 c2                	mov    %eax,%edx
80103319:	8b 45 08             	mov    0x8(%ebp),%eax
8010331c:	8b 40 08             	mov    0x8(%eax),%eax
8010331f:	39 c2                	cmp    %eax,%edx
80103321:	74 10                	je     80103333 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103323:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103327:	a1 04 09 11 80       	mov    0x80110904,%eax
8010332c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010332f:	7f d9                	jg     8010330a <log_write+0x4c>
80103331:	eb 01                	jmp    80103334 <log_write+0x76>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
80103333:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103334:	8b 45 08             	mov    0x8(%ebp),%eax
80103337:	8b 40 08             	mov    0x8(%eax),%eax
8010333a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010333d:	83 c2 10             	add    $0x10,%edx
80103340:	89 04 95 c8 08 11 80 	mov    %eax,-0x7feef738(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103347:	a1 f4 08 11 80       	mov    0x801108f4,%eax
8010334c:	03 45 f4             	add    -0xc(%ebp),%eax
8010334f:	83 c0 01             	add    $0x1,%eax
80103352:	89 c2                	mov    %eax,%edx
80103354:	8b 45 08             	mov    0x8(%ebp),%eax
80103357:	8b 40 04             	mov    0x4(%eax),%eax
8010335a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010335e:	89 04 24             	mov    %eax,(%esp)
80103361:	e8 40 ce ff ff       	call   801001a6 <bread>
80103366:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103369:	8b 45 08             	mov    0x8(%ebp),%eax
8010336c:	8d 50 18             	lea    0x18(%eax),%edx
8010336f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103372:	83 c0 18             	add    $0x18,%eax
80103375:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010337c:	00 
8010337d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103381:	89 04 24             	mov    %eax,(%esp)
80103384:	e8 10 25 00 00       	call   80105899 <memmove>
  bwrite(lbuf);
80103389:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010338c:	89 04 24             	mov    %eax,(%esp)
8010338f:	e8 49 ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103394:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103397:	89 04 24             	mov    %eax,(%esp)
8010339a:	e8 78 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
8010339f:	a1 04 09 11 80       	mov    0x80110904,%eax
801033a4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033a7:	75 0d                	jne    801033b6 <log_write+0xf8>
    log.lh.n++;
801033a9:	a1 04 09 11 80       	mov    0x80110904,%eax
801033ae:	83 c0 01             	add    $0x1,%eax
801033b1:	a3 04 09 11 80       	mov    %eax,0x80110904
  b->flags |= B_DIRTY; // XXX prevent eviction
801033b6:	8b 45 08             	mov    0x8(%ebp),%eax
801033b9:	8b 00                	mov    (%eax),%eax
801033bb:	89 c2                	mov    %eax,%edx
801033bd:	83 ca 04             	or     $0x4,%edx
801033c0:	8b 45 08             	mov    0x8(%ebp),%eax
801033c3:	89 10                	mov    %edx,(%eax)
}
801033c5:	c9                   	leave  
801033c6:	c3                   	ret    
	...

801033c8 <v2p>:
801033c8:	55                   	push   %ebp
801033c9:	89 e5                	mov    %esp,%ebp
801033cb:	8b 45 08             	mov    0x8(%ebp),%eax
801033ce:	05 00 00 00 80       	add    $0x80000000,%eax
801033d3:	5d                   	pop    %ebp
801033d4:	c3                   	ret    

801033d5 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801033d5:	55                   	push   %ebp
801033d6:	89 e5                	mov    %esp,%ebp
801033d8:	8b 45 08             	mov    0x8(%ebp),%eax
801033db:	05 00 00 00 80       	add    $0x80000000,%eax
801033e0:	5d                   	pop    %ebp
801033e1:	c3                   	ret    

801033e2 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801033e2:	55                   	push   %ebp
801033e3:	89 e5                	mov    %esp,%ebp
801033e5:	53                   	push   %ebx
801033e6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
801033e9:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
801033ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033f2:	89 c3                	mov    %eax,%ebx
801033f4:	89 d8                	mov    %ebx,%eax
801033f6:	f0 87 02             	lock xchg %eax,(%edx)
801033f9:	89 c3                	mov    %eax,%ebx
801033fb:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801033fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103401:	83 c4 10             	add    $0x10,%esp
80103404:	5b                   	pop    %ebx
80103405:	5d                   	pop    %ebp
80103406:	c3                   	ret    

80103407 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103407:	55                   	push   %ebp
80103408:	89 e5                	mov    %esp,%ebp
8010340a:	83 e4 f0             	and    $0xfffffff0,%esp
8010340d:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103410:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103417:	80 
80103418:	c7 04 24 7c 63 11 80 	movl   $0x8011637c,(%esp)
8010341f:	e8 ad f5 ff ff       	call   801029d1 <kinit1>
  kvmalloc();      // kernel page table
80103424:	e8 25 51 00 00       	call   8010854e <kvmalloc>
  mpinit();        // collect info about this machine
80103429:	e8 63 04 00 00       	call   80103891 <mpinit>
  lapicinit(mpbcpu());
8010342e:	e8 2e 02 00 00       	call   80103661 <mpbcpu>
80103433:	89 04 24             	mov    %eax,(%esp)
80103436:	e8 f5 f8 ff ff       	call   80102d30 <lapicinit>
  seginit();       // set up segments
8010343b:	e8 b1 4a 00 00       	call   80107ef1 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103440:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103446:	0f b6 00             	movzbl (%eax),%eax
80103449:	0f b6 c0             	movzbl %al,%eax
8010344c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103450:	c7 04 24 21 8f 10 80 	movl   $0x80108f21,(%esp)
80103457:	e8 45 cf ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
8010345c:	e8 95 06 00 00       	call   80103af6 <picinit>
  ioapicinit();    // another interrupt controller
80103461:	e8 5b f4 ff ff       	call   801028c1 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103466:	e8 22 d6 ff ff       	call   80100a8d <consoleinit>
  uartinit();      // serial port
8010346b:	e8 cc 3d 00 00       	call   8010723c <uartinit>
  pinit();         // process table
80103470:	e8 96 0b 00 00       	call   8010400b <pinit>
  tvinit();        // trap vectors
80103475:	e8 65 39 00 00       	call   80106ddf <tvinit>
  binit();         // buffer cache
8010347a:	e8 b5 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010347f:	e8 7c da ff ff       	call   80100f00 <fileinit>
  iinit();         // inode cache
80103484:	e8 2a e1 ff ff       	call   801015b3 <iinit>
  ideinit();       // disk
80103489:	e8 98 f0 ff ff       	call   80102526 <ideinit>
  if(!ismp)
8010348e:	a1 44 09 11 80       	mov    0x80110944,%eax
80103493:	85 c0                	test   %eax,%eax
80103495:	75 05                	jne    8010349c <main+0x95>
    timerinit();   // uniprocessor timer
80103497:	e8 86 38 00 00       	call   80106d22 <timerinit>
  startothers();   // start other processors
8010349c:	e8 87 00 00 00       	call   80103528 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034a1:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801034a8:	8e 
801034a9:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801034b0:	e8 54 f5 ff ff       	call   80102a09 <kinit2>
  userinit();      // first user process
801034b5:	e8 ba 0c 00 00       	call   80104174 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801034ba:	e8 22 00 00 00       	call   801034e1 <mpmain>

801034bf <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801034bf:	55                   	push   %ebp
801034c0:	89 e5                	mov    %esp,%ebp
801034c2:	83 ec 18             	sub    $0x18,%esp
  switchkvm(); 
801034c5:	e8 9b 50 00 00       	call   80108565 <switchkvm>
  seginit();
801034ca:	e8 22 4a 00 00       	call   80107ef1 <seginit>
  lapicinit(cpunum());
801034cf:	e8 b9 f9 ff ff       	call   80102e8d <cpunum>
801034d4:	89 04 24             	mov    %eax,(%esp)
801034d7:	e8 54 f8 ff ff       	call   80102d30 <lapicinit>
  mpmain();
801034dc:	e8 00 00 00 00       	call   801034e1 <mpmain>

801034e1 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034e1:	55                   	push   %ebp
801034e2:	89 e5                	mov    %esp,%ebp
801034e4:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801034e7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034ed:	0f b6 00             	movzbl (%eax),%eax
801034f0:	0f b6 c0             	movzbl %al,%eax
801034f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801034f7:	c7 04 24 38 8f 10 80 	movl   $0x80108f38,(%esp)
801034fe:	e8 9e ce ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
80103503:	e8 4b 3a 00 00       	call   80106f53 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103508:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010350e:	05 a8 00 00 00       	add    $0xa8,%eax
80103513:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010351a:	00 
8010351b:	89 04 24             	mov    %eax,(%esp)
8010351e:	e8 bf fe ff ff       	call   801033e2 <xchg>
  scheduler();     // start running processes
80103523:	e8 bd 1b 00 00       	call   801050e5 <scheduler>

80103528 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103528:	55                   	push   %ebp
80103529:	89 e5                	mov    %esp,%ebp
8010352b:	53                   	push   %ebx
8010352c:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010352f:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103536:	e8 9a fe ff ff       	call   801033d5 <p2v>
8010353b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010353e:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103543:	89 44 24 08          	mov    %eax,0x8(%esp)
80103547:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
8010354e:	80 
8010354f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103552:	89 04 24             	mov    %eax,(%esp)
80103555:	e8 3f 23 00 00       	call   80105899 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010355a:	c7 45 f4 60 09 11 80 	movl   $0x80110960,-0xc(%ebp)
80103561:	e9 86 00 00 00       	jmp    801035ec <startothers+0xc4>
    if(c == cpus+cpunum())  // We've started already.
80103566:	e8 22 f9 ff ff       	call   80102e8d <cpunum>
8010356b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103571:	05 60 09 11 80       	add    $0x80110960,%eax
80103576:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103579:	74 69                	je     801035e4 <startothers+0xbc>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010357b:	e8 7f f5 ff ff       	call   80102aff <kalloc>
80103580:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103583:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103586:	83 e8 04             	sub    $0x4,%eax
80103589:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010358c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103592:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103594:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103597:	83 e8 08             	sub    $0x8,%eax
8010359a:	c7 00 bf 34 10 80    	movl   $0x801034bf,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801035a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035a3:	8d 58 f4             	lea    -0xc(%eax),%ebx
801035a6:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
801035ad:	e8 16 fe ff ff       	call   801033c8 <v2p>
801035b2:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801035b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035b7:	89 04 24             	mov    %eax,(%esp)
801035ba:	e8 09 fe ff ff       	call   801033c8 <v2p>
801035bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035c2:	0f b6 12             	movzbl (%edx),%edx
801035c5:	0f b6 d2             	movzbl %dl,%edx
801035c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801035cc:	89 14 24             	mov    %edx,(%esp)
801035cf:	e8 3f f9 ff ff       	call   80102f13 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035d4:	90                   	nop
801035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035d8:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801035de:	85 c0                	test   %eax,%eax
801035e0:	74 f3                	je     801035d5 <startothers+0xad>
801035e2:	eb 01                	jmp    801035e5 <startothers+0xbd>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801035e4:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035e5:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801035ec:	a1 40 0f 11 80       	mov    0x80110f40,%eax
801035f1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035f7:	05 60 09 11 80       	add    $0x80110960,%eax
801035fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035ff:	0f 87 61 ff ff ff    	ja     80103566 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103605:	83 c4 24             	add    $0x24,%esp
80103608:	5b                   	pop    %ebx
80103609:	5d                   	pop    %ebp
8010360a:	c3                   	ret    
	...

8010360c <p2v>:
8010360c:	55                   	push   %ebp
8010360d:	89 e5                	mov    %esp,%ebp
8010360f:	8b 45 08             	mov    0x8(%ebp),%eax
80103612:	05 00 00 00 80       	add    $0x80000000,%eax
80103617:	5d                   	pop    %ebp
80103618:	c3                   	ret    

80103619 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103619:	55                   	push   %ebp
8010361a:	89 e5                	mov    %esp,%ebp
8010361c:	53                   	push   %ebx
8010361d:	83 ec 14             	sub    $0x14,%esp
80103620:	8b 45 08             	mov    0x8(%ebp),%eax
80103623:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103627:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
8010362b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
8010362f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80103633:	ec                   	in     (%dx),%al
80103634:	89 c3                	mov    %eax,%ebx
80103636:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80103639:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
8010363d:	83 c4 14             	add    $0x14,%esp
80103640:	5b                   	pop    %ebx
80103641:	5d                   	pop    %ebp
80103642:	c3                   	ret    

80103643 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103643:	55                   	push   %ebp
80103644:	89 e5                	mov    %esp,%ebp
80103646:	83 ec 08             	sub    $0x8,%esp
80103649:	8b 55 08             	mov    0x8(%ebp),%edx
8010364c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010364f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103653:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103656:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010365a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010365e:	ee                   	out    %al,(%dx)
}
8010365f:	c9                   	leave  
80103660:	c3                   	ret    

80103661 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103661:	55                   	push   %ebp
80103662:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103664:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103669:	89 c2                	mov    %eax,%edx
8010366b:	b8 60 09 11 80       	mov    $0x80110960,%eax
80103670:	89 d1                	mov    %edx,%ecx
80103672:	29 c1                	sub    %eax,%ecx
80103674:	89 c8                	mov    %ecx,%eax
80103676:	c1 f8 02             	sar    $0x2,%eax
80103679:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    

80103681 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103681:	55                   	push   %ebp
80103682:	89 e5                	mov    %esp,%ebp
80103684:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103687:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010368e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103695:	eb 13                	jmp    801036aa <sum+0x29>
    sum += addr[i];
80103697:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010369a:	03 45 08             	add    0x8(%ebp),%eax
8010369d:	0f b6 00             	movzbl (%eax),%eax
801036a0:	0f b6 c0             	movzbl %al,%eax
801036a3:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801036a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801036aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801036ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
801036b0:	7c e5                	jl     80103697 <sum+0x16>
    sum += addr[i];
  return sum;
801036b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801036b5:	c9                   	leave  
801036b6:	c3                   	ret    

801036b7 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036b7:	55                   	push   %ebp
801036b8:	89 e5                	mov    %esp,%ebp
801036ba:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801036bd:	8b 45 08             	mov    0x8(%ebp),%eax
801036c0:	89 04 24             	mov    %eax,(%esp)
801036c3:	e8 44 ff ff ff       	call   8010360c <p2v>
801036c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801036cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801036ce:	03 45 f0             	add    -0x10(%ebp),%eax
801036d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801036d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801036da:	eb 3f                	jmp    8010371b <mpsearch1+0x64>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036dc:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036e3:	00 
801036e4:	c7 44 24 04 4c 8f 10 	movl   $0x80108f4c,0x4(%esp)
801036eb:	80 
801036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ef:	89 04 24             	mov    %eax,(%esp)
801036f2:	e8 46 21 00 00       	call   8010583d <memcmp>
801036f7:	85 c0                	test   %eax,%eax
801036f9:	75 1c                	jne    80103717 <mpsearch1+0x60>
801036fb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103702:	00 
80103703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103706:	89 04 24             	mov    %eax,(%esp)
80103709:	e8 73 ff ff ff       	call   80103681 <sum>
8010370e:	84 c0                	test   %al,%al
80103710:	75 05                	jne    80103717 <mpsearch1+0x60>
      return (struct mp*)p;
80103712:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103715:	eb 11                	jmp    80103728 <mpsearch1+0x71>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103717:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010371e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103721:	72 b9                	jb     801036dc <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103723:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103728:	c9                   	leave  
80103729:	c3                   	ret    

8010372a <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
8010372a:	55                   	push   %ebp
8010372b:	89 e5                	mov    %esp,%ebp
8010372d:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103730:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373a:	83 c0 0f             	add    $0xf,%eax
8010373d:	0f b6 00             	movzbl (%eax),%eax
80103740:	0f b6 c0             	movzbl %al,%eax
80103743:	89 c2                	mov    %eax,%edx
80103745:	c1 e2 08             	shl    $0x8,%edx
80103748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010374b:	83 c0 0e             	add    $0xe,%eax
8010374e:	0f b6 00             	movzbl (%eax),%eax
80103751:	0f b6 c0             	movzbl %al,%eax
80103754:	09 d0                	or     %edx,%eax
80103756:	c1 e0 04             	shl    $0x4,%eax
80103759:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010375c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103760:	74 21                	je     80103783 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103762:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103769:	00 
8010376a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010376d:	89 04 24             	mov    %eax,(%esp)
80103770:	e8 42 ff ff ff       	call   801036b7 <mpsearch1>
80103775:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103778:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010377c:	74 50                	je     801037ce <mpsearch+0xa4>
      return mp;
8010377e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103781:	eb 5f                	jmp    801037e2 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103786:	83 c0 14             	add    $0x14,%eax
80103789:	0f b6 00             	movzbl (%eax),%eax
8010378c:	0f b6 c0             	movzbl %al,%eax
8010378f:	89 c2                	mov    %eax,%edx
80103791:	c1 e2 08             	shl    $0x8,%edx
80103794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103797:	83 c0 13             	add    $0x13,%eax
8010379a:	0f b6 00             	movzbl (%eax),%eax
8010379d:	0f b6 c0             	movzbl %al,%eax
801037a0:	09 d0                	or     %edx,%eax
801037a2:	c1 e0 0a             	shl    $0xa,%eax
801037a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
801037a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ab:	2d 00 04 00 00       	sub    $0x400,%eax
801037b0:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037b7:	00 
801037b8:	89 04 24             	mov    %eax,(%esp)
801037bb:	e8 f7 fe ff ff       	call   801036b7 <mpsearch1>
801037c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801037c7:	74 05                	je     801037ce <mpsearch+0xa4>
      return mp;
801037c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037cc:	eb 14                	jmp    801037e2 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
801037ce:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801037d5:	00 
801037d6:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
801037dd:	e8 d5 fe ff ff       	call   801036b7 <mpsearch1>
}
801037e2:	c9                   	leave  
801037e3:	c3                   	ret    

801037e4 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037e4:	55                   	push   %ebp
801037e5:	89 e5                	mov    %esp,%ebp
801037e7:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037ea:	e8 3b ff ff ff       	call   8010372a <mpsearch>
801037ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037f6:	74 0a                	je     80103802 <mpconfig+0x1e>
801037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037fb:	8b 40 04             	mov    0x4(%eax),%eax
801037fe:	85 c0                	test   %eax,%eax
80103800:	75 0a                	jne    8010380c <mpconfig+0x28>
    return 0;
80103802:	b8 00 00 00 00       	mov    $0x0,%eax
80103807:	e9 83 00 00 00       	jmp    8010388f <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
8010380c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010380f:	8b 40 04             	mov    0x4(%eax),%eax
80103812:	89 04 24             	mov    %eax,(%esp)
80103815:	e8 f2 fd ff ff       	call   8010360c <p2v>
8010381a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010381d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103824:	00 
80103825:	c7 44 24 04 51 8f 10 	movl   $0x80108f51,0x4(%esp)
8010382c:	80 
8010382d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103830:	89 04 24             	mov    %eax,(%esp)
80103833:	e8 05 20 00 00       	call   8010583d <memcmp>
80103838:	85 c0                	test   %eax,%eax
8010383a:	74 07                	je     80103843 <mpconfig+0x5f>
    return 0;
8010383c:	b8 00 00 00 00       	mov    $0x0,%eax
80103841:	eb 4c                	jmp    8010388f <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103846:	0f b6 40 06          	movzbl 0x6(%eax),%eax
8010384a:	3c 01                	cmp    $0x1,%al
8010384c:	74 12                	je     80103860 <mpconfig+0x7c>
8010384e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103851:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103855:	3c 04                	cmp    $0x4,%al
80103857:	74 07                	je     80103860 <mpconfig+0x7c>
    return 0;
80103859:	b8 00 00 00 00       	mov    $0x0,%eax
8010385e:	eb 2f                	jmp    8010388f <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103860:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103863:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103867:	0f b7 c0             	movzwl %ax,%eax
8010386a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010386e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103871:	89 04 24             	mov    %eax,(%esp)
80103874:	e8 08 fe ff ff       	call   80103681 <sum>
80103879:	84 c0                	test   %al,%al
8010387b:	74 07                	je     80103884 <mpconfig+0xa0>
    return 0;
8010387d:	b8 00 00 00 00       	mov    $0x0,%eax
80103882:	eb 0b                	jmp    8010388f <mpconfig+0xab>
  *pmp = mp;
80103884:	8b 45 08             	mov    0x8(%ebp),%eax
80103887:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010388a:	89 10                	mov    %edx,(%eax)
  return conf;
8010388c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010388f:	c9                   	leave  
80103890:	c3                   	ret    

80103891 <mpinit>:

void
mpinit(void)
{
80103891:	55                   	push   %ebp
80103892:	89 e5                	mov    %esp,%ebp
80103894:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103897:	c7 05 64 c6 10 80 60 	movl   $0x80110960,0x8010c664
8010389e:	09 11 80 
  if((conf = mpconfig(&mp)) == 0)
801038a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801038a4:	89 04 24             	mov    %eax,(%esp)
801038a7:	e8 38 ff ff ff       	call   801037e4 <mpconfig>
801038ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
801038af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801038b3:	0f 84 9c 01 00 00    	je     80103a55 <mpinit+0x1c4>
    return;
  ismp = 1;
801038b9:	c7 05 44 09 11 80 01 	movl   $0x1,0x80110944
801038c0:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c6:	8b 40 24             	mov    0x24(%eax),%eax
801038c9:	a3 bc 08 11 80       	mov    %eax,0x801108bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d1:	83 c0 2c             	add    $0x2c,%eax
801038d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801038d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038da:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801038de:	0f b7 c0             	movzwl %ax,%eax
801038e1:	03 45 f0             	add    -0x10(%ebp),%eax
801038e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038e7:	e9 f4 00 00 00       	jmp    801039e0 <mpinit+0x14f>
    switch(*p){
801038ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038ef:	0f b6 00             	movzbl (%eax),%eax
801038f2:	0f b6 c0             	movzbl %al,%eax
801038f5:	83 f8 04             	cmp    $0x4,%eax
801038f8:	0f 87 bf 00 00 00    	ja     801039bd <mpinit+0x12c>
801038fe:	8b 04 85 94 8f 10 80 	mov    -0x7fef706c(,%eax,4),%eax
80103905:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010390a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
8010390d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103910:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103914:	0f b6 d0             	movzbl %al,%edx
80103917:	a1 40 0f 11 80       	mov    0x80110f40,%eax
8010391c:	39 c2                	cmp    %eax,%edx
8010391e:	74 2d                	je     8010394d <mpinit+0xbc>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103920:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103923:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103927:	0f b6 d0             	movzbl %al,%edx
8010392a:	a1 40 0f 11 80       	mov    0x80110f40,%eax
8010392f:	89 54 24 08          	mov    %edx,0x8(%esp)
80103933:	89 44 24 04          	mov    %eax,0x4(%esp)
80103937:	c7 04 24 56 8f 10 80 	movl   $0x80108f56,(%esp)
8010393e:	e8 5e ca ff ff       	call   801003a1 <cprintf>
        ismp = 0;
80103943:	c7 05 44 09 11 80 00 	movl   $0x0,0x80110944
8010394a:	00 00 00 
      }
      if(proc->flags & MPBOOT)
8010394d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103950:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103954:	0f b6 c0             	movzbl %al,%eax
80103957:	83 e0 02             	and    $0x2,%eax
8010395a:	85 c0                	test   %eax,%eax
8010395c:	74 15                	je     80103973 <mpinit+0xe2>
        bcpu = &cpus[ncpu];
8010395e:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103963:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103969:	05 60 09 11 80       	add    $0x80110960,%eax
8010396e:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103973:	8b 15 40 0f 11 80    	mov    0x80110f40,%edx
80103979:	a1 40 0f 11 80       	mov    0x80110f40,%eax
8010397e:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103984:	81 c2 60 09 11 80    	add    $0x80110960,%edx
8010398a:	88 02                	mov    %al,(%edx)
      ncpu++;
8010398c:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103991:	83 c0 01             	add    $0x1,%eax
80103994:	a3 40 0f 11 80       	mov    %eax,0x80110f40
      p += sizeof(struct mpproc);
80103999:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010399d:	eb 41                	jmp    801039e0 <mpinit+0x14f>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
801039a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039a8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039ac:	a2 40 09 11 80       	mov    %al,0x80110940
      p += sizeof(struct mpioapic);
801039b1:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039b5:	eb 29                	jmp    801039e0 <mpinit+0x14f>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039b7:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039bb:	eb 23                	jmp    801039e0 <mpinit+0x14f>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
801039bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c0:	0f b6 00             	movzbl (%eax),%eax
801039c3:	0f b6 c0             	movzbl %al,%eax
801039c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801039ca:	c7 04 24 74 8f 10 80 	movl   $0x80108f74,(%esp)
801039d1:	e8 cb c9 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
801039d6:	c7 05 44 09 11 80 00 	movl   $0x0,0x80110944
801039dd:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039e6:	0f 82 00 ff ff ff    	jb     801038ec <mpinit+0x5b>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039ec:	a1 44 09 11 80       	mov    0x80110944,%eax
801039f1:	85 c0                	test   %eax,%eax
801039f3:	75 1d                	jne    80103a12 <mpinit+0x181>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039f5:	c7 05 40 0f 11 80 01 	movl   $0x1,0x80110f40
801039fc:	00 00 00 
    lapic = 0;
801039ff:	c7 05 bc 08 11 80 00 	movl   $0x0,0x801108bc
80103a06:	00 00 00 
    ioapicid = 0;
80103a09:	c6 05 40 09 11 80 00 	movb   $0x0,0x80110940
    return;
80103a10:	eb 44                	jmp    80103a56 <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103a12:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a15:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103a19:	84 c0                	test   %al,%al
80103a1b:	74 39                	je     80103a56 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103a1d:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103a24:	00 
80103a25:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103a2c:	e8 12 fc ff ff       	call   80103643 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a31:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a38:	e8 dc fb ff ff       	call   80103619 <inb>
80103a3d:	83 c8 01             	or     $0x1,%eax
80103a40:	0f b6 c0             	movzbl %al,%eax
80103a43:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a47:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a4e:	e8 f0 fb ff ff       	call   80103643 <outb>
80103a53:	eb 01                	jmp    80103a56 <mpinit+0x1c5>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103a55:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103a56:	c9                   	leave  
80103a57:	c3                   	ret    

80103a58 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a58:	55                   	push   %ebp
80103a59:	89 e5                	mov    %esp,%ebp
80103a5b:	83 ec 08             	sub    $0x8,%esp
80103a5e:	8b 55 08             	mov    0x8(%ebp),%edx
80103a61:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a64:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a68:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a6b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a6f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a73:	ee                   	out    %al,(%dx)
}
80103a74:	c9                   	leave  
80103a75:	c3                   	ret    

80103a76 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a76:	55                   	push   %ebp
80103a77:	89 e5                	mov    %esp,%ebp
80103a79:	83 ec 0c             	sub    $0xc,%esp
80103a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103a7f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a83:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a87:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103a8d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a91:	0f b6 c0             	movzbl %al,%eax
80103a94:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a98:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a9f:	e8 b4 ff ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103aa4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103aa8:	66 c1 e8 08          	shr    $0x8,%ax
80103aac:	0f b6 c0             	movzbl %al,%eax
80103aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ab3:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103aba:	e8 99 ff ff ff       	call   80103a58 <outb>
}
80103abf:	c9                   	leave  
80103ac0:	c3                   	ret    

80103ac1 <picenable>:

void
picenable(int irq)
{
80103ac1:	55                   	push   %ebp
80103ac2:	89 e5                	mov    %esp,%ebp
80103ac4:	53                   	push   %ebx
80103ac5:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80103acb:	ba 01 00 00 00       	mov    $0x1,%edx
80103ad0:	89 d3                	mov    %edx,%ebx
80103ad2:	89 c1                	mov    %eax,%ecx
80103ad4:	d3 e3                	shl    %cl,%ebx
80103ad6:	89 d8                	mov    %ebx,%eax
80103ad8:	89 c2                	mov    %eax,%edx
80103ada:	f7 d2                	not    %edx
80103adc:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103ae3:	21 d0                	and    %edx,%eax
80103ae5:	0f b7 c0             	movzwl %ax,%eax
80103ae8:	89 04 24             	mov    %eax,(%esp)
80103aeb:	e8 86 ff ff ff       	call   80103a76 <picsetmask>
}
80103af0:	83 c4 04             	add    $0x4,%esp
80103af3:	5b                   	pop    %ebx
80103af4:	5d                   	pop    %ebp
80103af5:	c3                   	ret    

80103af6 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103af6:	55                   	push   %ebp
80103af7:	89 e5                	mov    %esp,%ebp
80103af9:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103afc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b03:	00 
80103b04:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b0b:	e8 48 ff ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, 0xFF);
80103b10:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b17:	00 
80103b18:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b1f:	e8 34 ff ff ff       	call   80103a58 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b24:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b2b:	00 
80103b2c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b33:	e8 20 ff ff ff       	call   80103a58 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b38:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b3f:	00 
80103b40:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b47:	e8 0c ff ff ff       	call   80103a58 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b4c:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b53:	00 
80103b54:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b5b:	e8 f8 fe ff ff       	call   80103a58 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b60:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b67:	00 
80103b68:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b6f:	e8 e4 fe ff ff       	call   80103a58 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b74:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b7b:	00 
80103b7c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b83:	e8 d0 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b88:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b8f:	00 
80103b90:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b97:	e8 bc fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b9c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103ba3:	00 
80103ba4:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bab:	e8 a8 fe ff ff       	call   80103a58 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103bb0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103bb7:	00 
80103bb8:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bbf:	e8 94 fe ff ff       	call   80103a58 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103bc4:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bcb:	00 
80103bcc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bd3:	e8 80 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103bd8:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bdf:	00 
80103be0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103be7:	e8 6c fe ff ff       	call   80103a58 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103bec:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bf3:	00 
80103bf4:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bfb:	e8 58 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103c00:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c07:	00 
80103c08:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c0f:	e8 44 fe ff ff       	call   80103a58 <outb>

  if(irqmask != 0xFFFF)
80103c14:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103c1b:	66 83 f8 ff          	cmp    $0xffff,%ax
80103c1f:	74 12                	je     80103c33 <picinit+0x13d>
    picsetmask(irqmask);
80103c21:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103c28:	0f b7 c0             	movzwl %ax,%eax
80103c2b:	89 04 24             	mov    %eax,(%esp)
80103c2e:	e8 43 fe ff ff       	call   80103a76 <picsetmask>
}
80103c33:	c9                   	leave  
80103c34:	c3                   	ret    
80103c35:	00 00                	add    %al,(%eax)
	...

80103c38 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c38:	55                   	push   %ebp
80103c39:	89 e5                	mov    %esp,%ebp
80103c3b:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103c3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c45:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c51:	8b 10                	mov    (%eax),%edx
80103c53:	8b 45 08             	mov    0x8(%ebp),%eax
80103c56:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c58:	e8 bf d2 ff ff       	call   80100f1c <filealloc>
80103c5d:	8b 55 08             	mov    0x8(%ebp),%edx
80103c60:	89 02                	mov    %eax,(%edx)
80103c62:	8b 45 08             	mov    0x8(%ebp),%eax
80103c65:	8b 00                	mov    (%eax),%eax
80103c67:	85 c0                	test   %eax,%eax
80103c69:	0f 84 c8 00 00 00    	je     80103d37 <pipealloc+0xff>
80103c6f:	e8 a8 d2 ff ff       	call   80100f1c <filealloc>
80103c74:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c77:	89 02                	mov    %eax,(%edx)
80103c79:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c7c:	8b 00                	mov    (%eax),%eax
80103c7e:	85 c0                	test   %eax,%eax
80103c80:	0f 84 b1 00 00 00    	je     80103d37 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c86:	e8 74 ee ff ff       	call   80102aff <kalloc>
80103c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c92:	0f 84 9e 00 00 00    	je     80103d36 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ca2:	00 00 00 
  p->writeopen = 1;
80103ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca8:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103caf:	00 00 00 
  p->nwrite = 0;
80103cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb5:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cbc:	00 00 00 
  p->nread = 0;
80103cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103cc9:	00 00 00 
  initlock(&p->lock, "pipe");
80103ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ccf:	c7 44 24 04 a8 8f 10 	movl   $0x80108fa8,0x4(%esp)
80103cd6:	80 
80103cd7:	89 04 24             	mov    %eax,(%esp)
80103cda:	e8 77 18 00 00       	call   80105556 <initlock>
  (*f0)->type = FD_PIPE;
80103cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80103ce2:	8b 00                	mov    (%eax),%eax
80103ce4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cea:	8b 45 08             	mov    0x8(%ebp),%eax
80103ced:	8b 00                	mov    (%eax),%eax
80103cef:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103cf3:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf6:	8b 00                	mov    (%eax),%eax
80103cf8:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80103cff:	8b 00                	mov    (%eax),%eax
80103d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d04:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d07:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d0a:	8b 00                	mov    (%eax),%eax
80103d0c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d12:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d15:	8b 00                	mov    (%eax),%eax
80103d17:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d1e:	8b 00                	mov    (%eax),%eax
80103d20:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d24:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d27:	8b 00                	mov    (%eax),%eax
80103d29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d2c:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d2f:	b8 00 00 00 00       	mov    $0x0,%eax
80103d34:	eb 43                	jmp    80103d79 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103d36:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d3b:	74 0b                	je     80103d48 <pipealloc+0x110>
    kfree((char*)p);
80103d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d40:	89 04 24             	mov    %eax,(%esp)
80103d43:	e8 1e ed ff ff       	call   80102a66 <kfree>
  if(*f0)
80103d48:	8b 45 08             	mov    0x8(%ebp),%eax
80103d4b:	8b 00                	mov    (%eax),%eax
80103d4d:	85 c0                	test   %eax,%eax
80103d4f:	74 0d                	je     80103d5e <pipealloc+0x126>
    fileclose(*f0);
80103d51:	8b 45 08             	mov    0x8(%ebp),%eax
80103d54:	8b 00                	mov    (%eax),%eax
80103d56:	89 04 24             	mov    %eax,(%esp)
80103d59:	e8 66 d2 ff ff       	call   80100fc4 <fileclose>
  if(*f1)
80103d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d61:	8b 00                	mov    (%eax),%eax
80103d63:	85 c0                	test   %eax,%eax
80103d65:	74 0d                	je     80103d74 <pipealloc+0x13c>
    fileclose(*f1);
80103d67:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d6a:	8b 00                	mov    (%eax),%eax
80103d6c:	89 04 24             	mov    %eax,(%esp)
80103d6f:	e8 50 d2 ff ff       	call   80100fc4 <fileclose>
  return -1;
80103d74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d79:	c9                   	leave  
80103d7a:	c3                   	ret    

80103d7b <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d7b:	55                   	push   %ebp
80103d7c:	89 e5                	mov    %esp,%ebp
80103d7e:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d81:	8b 45 08             	mov    0x8(%ebp),%eax
80103d84:	89 04 24             	mov    %eax,(%esp)
80103d87:	e8 eb 17 00 00       	call   80105577 <acquire>
  if(writable){
80103d8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d90:	74 1f                	je     80103db1 <pipeclose+0x36>
    p->writeopen = 0;
80103d92:	8b 45 08             	mov    0x8(%ebp),%eax
80103d95:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d9c:	00 00 00 
    wakeup(&p->nread);
80103d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103da2:	05 34 02 00 00       	add    $0x234,%eax
80103da7:	89 04 24             	mov    %eax,(%esp)
80103daa:	e8 be 15 00 00       	call   8010536d <wakeup>
80103daf:	eb 1d                	jmp    80103dce <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103db1:	8b 45 08             	mov    0x8(%ebp),%eax
80103db4:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103dbb:	00 00 00 
    wakeup(&p->nwrite);
80103dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc1:	05 38 02 00 00       	add    $0x238,%eax
80103dc6:	89 04 24             	mov    %eax,(%esp)
80103dc9:	e8 9f 15 00 00       	call   8010536d <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dce:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd1:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dd7:	85 c0                	test   %eax,%eax
80103dd9:	75 25                	jne    80103e00 <pipeclose+0x85>
80103ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dde:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103de4:	85 c0                	test   %eax,%eax
80103de6:	75 18                	jne    80103e00 <pipeclose+0x85>
    release(&p->lock);
80103de8:	8b 45 08             	mov    0x8(%ebp),%eax
80103deb:	89 04 24             	mov    %eax,(%esp)
80103dee:	e8 e6 17 00 00       	call   801055d9 <release>
    kfree((char*)p);
80103df3:	8b 45 08             	mov    0x8(%ebp),%eax
80103df6:	89 04 24             	mov    %eax,(%esp)
80103df9:	e8 68 ec ff ff       	call   80102a66 <kfree>
80103dfe:	eb 0b                	jmp    80103e0b <pipeclose+0x90>
  } else
    release(&p->lock);
80103e00:	8b 45 08             	mov    0x8(%ebp),%eax
80103e03:	89 04 24             	mov    %eax,(%esp)
80103e06:	e8 ce 17 00 00       	call   801055d9 <release>
}
80103e0b:	c9                   	leave  
80103e0c:	c3                   	ret    

80103e0d <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e0d:	55                   	push   %ebp
80103e0e:	89 e5                	mov    %esp,%ebp
80103e10:	53                   	push   %ebx
80103e11:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103e14:	8b 45 08             	mov    0x8(%ebp),%eax
80103e17:	89 04 24             	mov    %eax,(%esp)
80103e1a:	e8 58 17 00 00       	call   80105577 <acquire>
  for(i = 0; i < n; i++){
80103e1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e26:	e9 a6 00 00 00       	jmp    80103ed1 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e34:	85 c0                	test   %eax,%eax
80103e36:	74 0d                	je     80103e45 <pipewrite+0x38>
80103e38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e3e:	8b 40 24             	mov    0x24(%eax),%eax
80103e41:	85 c0                	test   %eax,%eax
80103e43:	74 15                	je     80103e5a <pipewrite+0x4d>
        release(&p->lock);
80103e45:	8b 45 08             	mov    0x8(%ebp),%eax
80103e48:	89 04 24             	mov    %eax,(%esp)
80103e4b:	e8 89 17 00 00       	call   801055d9 <release>
        return -1;
80103e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e55:	e9 9d 00 00 00       	jmp    80103ef7 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e5a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e5d:	05 34 02 00 00       	add    $0x234,%eax
80103e62:	89 04 24             	mov    %eax,(%esp)
80103e65:	e8 03 15 00 00       	call   8010536d <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6d:	8b 55 08             	mov    0x8(%ebp),%edx
80103e70:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e76:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e7a:	89 14 24             	mov    %edx,(%esp)
80103e7d:	e8 0f 14 00 00       	call   80105291 <sleep>
80103e82:	eb 01                	jmp    80103e85 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e84:	90                   	nop
80103e85:	8b 45 08             	mov    0x8(%ebp),%eax
80103e88:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e8e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e91:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e97:	05 00 02 00 00       	add    $0x200,%eax
80103e9c:	39 c2                	cmp    %eax,%edx
80103e9e:	74 8b                	je     80103e2b <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ea9:	89 c3                	mov    %eax,%ebx
80103eab:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103eb4:	03 55 0c             	add    0xc(%ebp),%edx
80103eb7:	0f b6 0a             	movzbl (%edx),%ecx
80103eba:	8b 55 08             	mov    0x8(%ebp),%edx
80103ebd:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103ec1:	8d 50 01             	lea    0x1(%eax),%edx
80103ec4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec7:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103ecd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed4:	3b 45 10             	cmp    0x10(%ebp),%eax
80103ed7:	7c ab                	jl     80103e84 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80103edc:	05 34 02 00 00       	add    $0x234,%eax
80103ee1:	89 04 24             	mov    %eax,(%esp)
80103ee4:	e8 84 14 00 00       	call   8010536d <wakeup>
  release(&p->lock);
80103ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80103eec:	89 04 24             	mov    %eax,(%esp)
80103eef:	e8 e5 16 00 00       	call   801055d9 <release>
  return n;
80103ef4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103ef7:	83 c4 24             	add    $0x24,%esp
80103efa:	5b                   	pop    %ebx
80103efb:	5d                   	pop    %ebp
80103efc:	c3                   	ret    

80103efd <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103efd:	55                   	push   %ebp
80103efe:	89 e5                	mov    %esp,%ebp
80103f00:	53                   	push   %ebx
80103f01:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103f04:	8b 45 08             	mov    0x8(%ebp),%eax
80103f07:	89 04 24             	mov    %eax,(%esp)
80103f0a:	e8 68 16 00 00       	call   80105577 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f0f:	eb 3a                	jmp    80103f4b <piperead+0x4e>
    if(proc->killed){
80103f11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f17:	8b 40 24             	mov    0x24(%eax),%eax
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	74 15                	je     80103f33 <piperead+0x36>
      release(&p->lock);
80103f1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f21:	89 04 24             	mov    %eax,(%esp)
80103f24:	e8 b0 16 00 00       	call   801055d9 <release>
      return -1;
80103f29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f2e:	e9 b6 00 00 00       	jmp    80103fe9 <piperead+0xec>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f33:	8b 45 08             	mov    0x8(%ebp),%eax
80103f36:	8b 55 08             	mov    0x8(%ebp),%edx
80103f39:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f43:	89 14 24             	mov    %edx,(%esp)
80103f46:	e8 46 13 00 00       	call   80105291 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f4b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f54:	8b 45 08             	mov    0x8(%ebp),%eax
80103f57:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f5d:	39 c2                	cmp    %eax,%edx
80103f5f:	75 0d                	jne    80103f6e <piperead+0x71>
80103f61:	8b 45 08             	mov    0x8(%ebp),%eax
80103f64:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f6a:	85 c0                	test   %eax,%eax
80103f6c:	75 a3                	jne    80103f11 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f75:	eb 49                	jmp    80103fc0 <piperead+0xc3>
    if(p->nread == p->nwrite)
80103f77:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f80:	8b 45 08             	mov    0x8(%ebp),%eax
80103f83:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f89:	39 c2                	cmp    %eax,%edx
80103f8b:	74 3d                	je     80103fca <piperead+0xcd>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f90:	89 c2                	mov    %eax,%edx
80103f92:	03 55 0c             	add    0xc(%ebp),%edx
80103f95:	8b 45 08             	mov    0x8(%ebp),%eax
80103f98:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f9e:	89 c3                	mov    %eax,%ebx
80103fa0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103fa6:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103fa9:	0f b6 4c 19 34       	movzbl 0x34(%ecx,%ebx,1),%ecx
80103fae:	88 0a                	mov    %cl,(%edx)
80103fb0:	8d 50 01             	lea    0x1(%eax),%edx
80103fb3:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb6:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fbc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fc3:	3b 45 10             	cmp    0x10(%ebp),%eax
80103fc6:	7c af                	jl     80103f77 <piperead+0x7a>
80103fc8:	eb 01                	jmp    80103fcb <piperead+0xce>
    if(p->nread == p->nwrite)
      break;
80103fca:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fce:	05 38 02 00 00       	add    $0x238,%eax
80103fd3:	89 04 24             	mov    %eax,(%esp)
80103fd6:	e8 92 13 00 00       	call   8010536d <wakeup>
  release(&p->lock);
80103fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fde:	89 04 24             	mov    %eax,(%esp)
80103fe1:	e8 f3 15 00 00       	call   801055d9 <release>
  return i;
80103fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103fe9:	83 c4 24             	add    $0x24,%esp
80103fec:	5b                   	pop    %ebx
80103fed:	5d                   	pop    %ebp
80103fee:	c3                   	ret    
	...

80103ff0 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ff7:	9c                   	pushf  
80103ff8:	5b                   	pop    %ebx
80103ff9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80103ffc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103fff:	83 c4 10             	add    $0x10,%esp
80104002:	5b                   	pop    %ebx
80104003:	5d                   	pop    %ebp
80104004:	c3                   	ret    

80104005 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104005:	55                   	push   %ebp
80104006:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104008:	fb                   	sti    
}
80104009:	5d                   	pop    %ebp
8010400a:	c3                   	ret    

8010400b <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010400b:	55                   	push   %ebp
8010400c:	89 e5                	mov    %esp,%ebp
8010400e:	83 ec 18             	sub    $0x18,%esp
 
  initlock(&ptable.lock, "ptable");
80104011:	c7 44 24 04 b0 8f 10 	movl   $0x80108fb0,0x4(%esp)
80104018:	80 
80104019:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104020:	e8 31 15 00 00       	call   80105556 <initlock>
  initlock(&sem_table.lock, "sem_table"); // initial sem_table lock
80104025:	c7 44 24 04 b7 8f 10 	movl   $0x80108fb7,0x4(%esp)
8010402c:	80 
8010402d:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104034:	e8 1d 15 00 00       	call   80105556 <initlock>
  //int i;
  //for(i = 0; i<NUM_OF_SEMAPHORES ; i++){	// initialize every semaphore lock in sem_table
    //  initlock(&sem_table.binary_semaphore[i].lock,"semaphore");
  //}
}
80104039:	c9                   	leave  
8010403a:	c3                   	ret    

8010403b <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010403b:	55                   	push   %ebp
8010403c:	89 e5                	mov    %esp,%ebp
8010403e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104041:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104048:	e8 2a 15 00 00       	call   80105577 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010404d:	c7 45 f4 d4 33 11 80 	movl   $0x801133d4,-0xc(%ebp)
80104054:	eb 11                	jmp    80104067 <allocproc+0x2c>
    if(p->state == UNUSED)
80104056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104059:	8b 40 0c             	mov    0xc(%eax),%eax
8010405c:	85 c0                	test   %eax,%eax
8010405e:	74 26                	je     80104086 <allocproc+0x4b>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104060:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104067:	81 7d f4 d4 5a 11 80 	cmpl   $0x80115ad4,-0xc(%ebp)
8010406e:	72 e6                	jb     80104056 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104070:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104077:	e8 5d 15 00 00       	call   801055d9 <release>
  return 0;
8010407c:	b8 00 00 00 00       	mov    $0x0,%eax
80104081:	e9 ec 00 00 00       	jmp    80104172 <allocproc+0x137>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104086:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010408a:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104091:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104096:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104099:	89 42 10             	mov    %eax,0x10(%edx)
8010409c:	83 c0 01             	add    $0x1,%eax
8010409f:	a3 04 c0 10 80       	mov    %eax,0x8010c004
  release(&ptable.lock);
801040a4:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
801040ab:	e8 29 15 00 00       	call   801055d9 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801040b0:	e8 4a ea ff ff       	call   80102aff <kalloc>
801040b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040b8:	89 42 08             	mov    %eax,0x8(%edx)
801040bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040be:	8b 40 08             	mov    0x8(%eax),%eax
801040c1:	85 c0                	test   %eax,%eax
801040c3:	75 14                	jne    801040d9 <allocproc+0x9e>
    p->state = UNUSED;
801040c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801040cf:	b8 00 00 00 00       	mov    $0x0,%eax
801040d4:	e9 99 00 00 00       	jmp    80104172 <allocproc+0x137>
  }
  sp = p->kstack + KSTACKSIZE;
801040d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040dc:	8b 40 08             	mov    0x8(%eax),%eax
801040df:	05 00 10 00 00       	add    $0x1000,%eax
801040e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801040e7:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801040eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040f1:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801040f4:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801040f8:	ba 94 6d 10 80       	mov    $0x80106d94,%edx
801040fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104100:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104102:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104109:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010410c:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010410f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104112:	8b 40 1c             	mov    0x1c(%eax),%eax
80104115:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010411c:	00 
8010411d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104124:	00 
80104125:	89 04 24             	mov    %eax,(%esp)
80104128:	e8 99 16 00 00       	call   801057c6 <memset>
  p->context->eip = (uint)forkret;
8010412d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104130:	8b 40 1c             	mov    0x1c(%eax),%eax
80104133:	ba 65 52 10 80       	mov    $0x80105265,%edx
80104138:	89 50 10             	mov    %edx,0x10(%eax)
  p->is_thread = 0;
8010413b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104145:	00 00 00 
  p->thread_joined = -1;
80104148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010414b:	c7 80 84 00 00 00 ff 	movl   $0xffffffff,0x84(%eax)
80104152:	ff ff ff 
  p->num_of_thread_child =1;
80104155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104158:	c7 80 98 00 00 00 01 	movl   $0x1,0x98(%eax)
8010415f:	00 00 00 
  p->wait_for_sem = -1;
80104162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104165:	c7 80 8c 00 00 00 ff 	movl   $0xffffffff,0x8c(%eax)
8010416c:	ff ff ff 
  return p;
8010416f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104172:	c9                   	leave  
80104173:	c3                   	ret    

80104174 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104174:	55                   	push   %ebp
80104175:	89 e5                	mov    %esp,%ebp
80104177:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
8010417a:	e8 bc fe ff ff       	call   8010403b <allocproc>
8010417f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104185:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm(kalloc)) == 0)
8010418a:	c7 04 24 ff 2a 10 80 	movl   $0x80102aff,(%esp)
80104191:	e8 fb 42 00 00       	call   80108491 <setupkvm>
80104196:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104199:	89 42 04             	mov    %eax,0x4(%edx)
8010419c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419f:	8b 40 04             	mov    0x4(%eax),%eax
801041a2:	85 c0                	test   %eax,%eax
801041a4:	75 0c                	jne    801041b2 <userinit+0x3e>
    panic("userinit: out of memory?");
801041a6:	c7 04 24 c1 8f 10 80 	movl   $0x80108fc1,(%esp)
801041ad:	e8 8b c3 ff ff       	call   8010053d <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801041b2:	ba 2c 00 00 00       	mov    $0x2c,%edx
801041b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ba:	8b 40 04             	mov    0x4(%eax),%eax
801041bd:	89 54 24 08          	mov    %edx,0x8(%esp)
801041c1:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
801041c8:	80 
801041c9:	89 04 24             	mov    %eax,(%esp)
801041cc:	e8 18 45 00 00       	call   801086e9 <inituvm>
  p->sz = PGSIZE;
801041d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d4:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801041da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041dd:	8b 40 18             	mov    0x18(%eax),%eax
801041e0:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801041e7:	00 
801041e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801041ef:	00 
801041f0:	89 04 24             	mov    %eax,(%esp)
801041f3:	e8 ce 15 00 00       	call   801057c6 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041fb:	8b 40 18             	mov    0x18(%eax),%eax
801041fe:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104207:	8b 40 18             	mov    0x18(%eax),%eax
8010420a:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104213:	8b 40 18             	mov    0x18(%eax),%eax
80104216:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104219:	8b 52 18             	mov    0x18(%edx),%edx
8010421c:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104220:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104224:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104227:	8b 40 18             	mov    0x18(%eax),%eax
8010422a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010422d:	8b 52 18             	mov    0x18(%edx),%edx
80104230:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104234:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010423b:	8b 40 18             	mov    0x18(%eax),%eax
8010423e:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104245:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104248:	8b 40 18             	mov    0x18(%eax),%eax
8010424b:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104255:	8b 40 18             	mov    0x18(%eax),%eax
80104258:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010425f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104262:	83 c0 70             	add    $0x70,%eax
80104265:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010426c:	00 
8010426d:	c7 44 24 04 da 8f 10 	movl   $0x80108fda,0x4(%esp)
80104274:	80 
80104275:	89 04 24             	mov    %eax,(%esp)
80104278:	e8 79 17 00 00       	call   801059f6 <safestrcpy>
  p->cwd = namei("/");
8010427d:	c7 04 24 e3 8f 10 80 	movl   $0x80108fe3,(%esp)
80104284:	e8 81 e1 ff ff       	call   8010240a <namei>
80104289:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010428c:	89 42 6c             	mov    %eax,0x6c(%edx)

  p->state = RUNNABLE;
8010428f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104292:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104299:	c9                   	leave  
8010429a:	c3                   	ret    

8010429b <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010429b:	55                   	push   %ebp
8010429c:	89 e5                	mov    %esp,%ebp
8010429e:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
801042a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042a7:	8b 00                	mov    (%eax),%eax
801042a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801042ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801042b0:	7e 34                	jle    801042e6 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801042b2:	8b 45 08             	mov    0x8(%ebp),%eax
801042b5:	89 c2                	mov    %eax,%edx
801042b7:	03 55 f4             	add    -0xc(%ebp),%edx
801042ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042c0:	8b 40 04             	mov    0x4(%eax),%eax
801042c3:	89 54 24 08          	mov    %edx,0x8(%esp)
801042c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801042ce:	89 04 24             	mov    %eax,(%esp)
801042d1:	e8 8d 45 00 00       	call   80108863 <allocuvm>
801042d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042dd:	75 41                	jne    80104320 <growproc+0x85>
      return -1;
801042df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042e4:	eb 58                	jmp    8010433e <growproc+0xa3>
  } else if(n < 0){
801042e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801042ea:	79 34                	jns    80104320 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801042ec:	8b 45 08             	mov    0x8(%ebp),%eax
801042ef:	89 c2                	mov    %eax,%edx
801042f1:	03 55 f4             	add    -0xc(%ebp),%edx
801042f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042fa:	8b 40 04             	mov    0x4(%eax),%eax
801042fd:	89 54 24 08          	mov    %edx,0x8(%esp)
80104301:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104304:	89 54 24 04          	mov    %edx,0x4(%esp)
80104308:	89 04 24             	mov    %eax,(%esp)
8010430b:	e8 2d 46 00 00       	call   8010893d <deallocuvm>
80104310:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104313:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104317:	75 07                	jne    80104320 <growproc+0x85>
      return -1;
80104319:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010431e:	eb 1e                	jmp    8010433e <growproc+0xa3>
  }
  proc->sz = sz;
80104320:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104326:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104329:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010432b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104331:	89 04 24             	mov    %eax,(%esp)
80104334:	e8 49 42 00 00       	call   80108582 <switchuvm>
  return 0;
80104339:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010433e:	c9                   	leave  
8010433f:	c3                   	ret    

80104340 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104349:	e8 ed fc ff ff       	call   8010403b <allocproc>
8010434e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104351:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104355:	75 0a                	jne    80104361 <fork+0x21>
    return -1;
80104357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010435c:	e9 54 01 00 00       	jmp    801044b5 <fork+0x175>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104361:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104367:	8b 10                	mov    (%eax),%edx
80104369:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010436f:	8b 40 04             	mov    0x4(%eax),%eax
80104372:	89 54 24 04          	mov    %edx,0x4(%esp)
80104376:	89 04 24             	mov    %eax,(%esp)
80104379:	e8 4f 47 00 00       	call   80108acd <copyuvm>
8010437e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104381:	89 42 04             	mov    %eax,0x4(%edx)
80104384:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104387:	8b 40 04             	mov    0x4(%eax),%eax
8010438a:	85 c0                	test   %eax,%eax
8010438c:	75 2c                	jne    801043ba <fork+0x7a>
    kfree(np->kstack);
8010438e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104391:	8b 40 08             	mov    0x8(%eax),%eax
80104394:	89 04 24             	mov    %eax,(%esp)
80104397:	e8 ca e6 ff ff       	call   80102a66 <kfree>
    np->kstack = 0;
8010439c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010439f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801043a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043a9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801043b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043b5:	e9 fb 00 00 00       	jmp    801044b5 <fork+0x175>
  }
  np->sz = proc->sz;
801043ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c0:	8b 10                	mov    (%eax),%edx
801043c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043c5:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801043c7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801043ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043d1:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801043d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043d7:	8b 50 18             	mov    0x18(%eax),%edx
801043da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043e0:	8b 40 18             	mov    0x18(%eax),%eax
801043e3:	89 c3                	mov    %eax,%ebx
801043e5:	b8 13 00 00 00       	mov    $0x13,%eax
801043ea:	89 d7                	mov    %edx,%edi
801043ec:	89 de                	mov    %ebx,%esi
801043ee:	89 c1                	mov    %eax,%ecx
801043f0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801043f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043f5:	8b 40 18             	mov    0x18(%eax),%eax
801043f8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801043ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104406:	eb 3d                	jmp    80104445 <fork+0x105>
    if(proc->ofile[i])
80104408:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010440e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104411:	83 c2 08             	add    $0x8,%edx
80104414:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104418:	85 c0                	test   %eax,%eax
8010441a:	74 25                	je     80104441 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
8010441c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104422:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104425:	83 c2 08             	add    $0x8,%edx
80104428:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010442c:	89 04 24             	mov    %eax,(%esp)
8010442f:	e8 48 cb ff ff       	call   80100f7c <filedup>
80104434:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104437:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010443a:	83 c1 08             	add    $0x8,%ecx
8010443d:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104441:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104445:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104449:	7e bd                	jle    80104408 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010444b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104451:	8b 40 6c             	mov    0x6c(%eax),%eax
80104454:	89 04 24             	mov    %eax,(%esp)
80104457:	e8 da d3 ff ff       	call   80101836 <idup>
8010445c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010445f:	89 42 6c             	mov    %eax,0x6c(%edx)
  np->tid = 0;
80104462:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104465:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010446c:	00 00 00 
  np->thread_joined =0;
8010446f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104472:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104479:	00 00 00 
  pid = np->pid;
8010447c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010447f:	8b 40 10             	mov    0x10(%eax),%eax
80104482:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104485:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104488:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010448f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104495:	8d 50 70             	lea    0x70(%eax),%edx
80104498:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010449b:	83 c0 70             	add    $0x70,%eax
8010449e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801044a5:	00 
801044a6:	89 54 24 04          	mov    %edx,0x4(%esp)
801044aa:	89 04 24             	mov    %eax,(%esp)
801044ad:	e8 44 15 00 00       	call   801059f6 <safestrcpy>
  return pid;
801044b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801044b5:	83 c4 2c             	add    $0x2c,%esp
801044b8:	5b                   	pop    %ebx
801044b9:	5e                   	pop    %esi
801044ba:	5f                   	pop    %edi
801044bb:	5d                   	pop    %ebp
801044bc:	c3                   	ret    

801044bd <thread_create>:

int
thread_create(void*(*start_func)(), void* stack, uint stack_size)
{
801044bd:	55                   	push   %ebp
801044be:	89 e5                	mov    %esp,%ebp
801044c0:	57                   	push   %edi
801044c1:	56                   	push   %esi
801044c2:	53                   	push   %ebx
801044c3:	83 ec 2c             	sub    $0x2c,%esp
  int tid,i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)//tid was update in thread_allocproc
801044c6:	e8 70 fb ff ff       	call   8010403b <allocproc>
801044cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801044ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801044d2:	75 0a                	jne    801044de <thread_create+0x21>
    return -1;
801044d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044d9:	e9 93 01 00 00       	jmp    80104671 <thread_create+0x1b4>

  np->pid = proc->pid;//copy brother id
801044de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044e4:	8b 50 10             	mov    0x10(%eax),%edx
801044e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044ea:	89 50 10             	mov    %edx,0x10(%eax)
  // Copy process state from p.
  np->pgdir = proc->pgdir;
801044ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044f3:	8b 50 04             	mov    0x4(%eax),%edx
801044f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044f9:	89 50 04             	mov    %edx,0x4(%eax)
  np->sz = proc->sz;
801044fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104502:	8b 10                	mov    (%eax),%edx
80104504:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104507:	89 10                	mov    %edx,(%eax)
  if(proc->is_thread){//if the thread create thread then both have the same father
80104509:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010450f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104515:	85 c0                	test   %eax,%eax
80104517:	74 11                	je     8010452a <thread_create+0x6d>
    np->parent = proc->parent;
80104519:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010451f:	8b 50 14             	mov    0x14(%eax),%edx
80104522:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104525:	89 50 14             	mov    %edx,0x14(%eax)
80104528:	eb 0d                	jmp    80104537 <thread_create+0x7a>
  }
  else{//if procces create thread then it is his father
    np->parent = proc;
8010452a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104531:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104534:	89 50 14             	mov    %edx,0x14(%eax)
  }
  acquire(&ptable.lock);
80104537:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
8010453e:	e8 34 10 00 00       	call   80105577 <acquire>
  np->parent->num_of_thread_child++;
80104543:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104546:	8b 40 14             	mov    0x14(%eax),%eax
80104549:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010454f:	83 c2 01             	add    $0x1,%edx
80104552:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  np->tid =nexttid++;
80104558:	a1 08 c0 10 80       	mov    0x8010c008,%eax
8010455d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104560:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
80104566:	83 c0 01             	add    $0x1,%eax
80104569:	a3 08 c0 10 80       	mov    %eax,0x8010c008
  release(&ptable.lock);
8010456e:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104575:	e8 5f 10 00 00       	call   801055d9 <release>
  np->is_thread = 1;
8010457a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010457d:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
80104584:	00 00 00 
  np->thread_joined = 0;
80104587:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010458a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104591:	00 00 00 
  //np->tid = ++(np->parent->tid);
 
  *np->tf = *proc->tf;
80104594:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104597:	8b 50 18             	mov    0x18(%eax),%edx
8010459a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045a0:	8b 40 18             	mov    0x18(%eax),%eax
801045a3:	89 c3                	mov    %eax,%ebx
801045a5:	b8 13 00 00 00       	mov    $0x13,%eax
801045aa:	89 d7                	mov    %edx,%edi
801045ac:	89 de                	mov    %ebx,%esi
801045ae:	89 c1                	mov    %eax,%ecx
801045b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801045b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045b5:	8b 40 18             	mov    0x18(%eax),%eax
801045b8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  np->tf->esp = (uint)stack+stack_size;
801045bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045c2:	8b 40 18             	mov    0x18(%eax),%eax
801045c5:	8b 55 0c             	mov    0xc(%ebp),%edx
801045c8:	03 55 10             	add    0x10(%ebp),%edx
801045cb:	89 50 44             	mov    %edx,0x44(%eax)
  np->tf->eip = (uint)start_func;
801045ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045d1:	8b 40 18             	mov    0x18(%eax),%eax
801045d4:	8b 55 08             	mov    0x8(%ebp),%edx
801045d7:	89 50 38             	mov    %edx,0x38(%eax)
  //np->ofile = (struct file *)proc->ofile;
  for(i = 0; i < NOFILE; i++){
801045da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801045e1:	eb 3d                	jmp    80104620 <thread_create+0x163>
    if(proc->ofile[i]){
801045e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045ec:	83 c2 08             	add    $0x8,%edx
801045ef:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045f3:	85 c0                	test   %eax,%eax
801045f5:	74 25                	je     8010461c <thread_create+0x15f>
      np->ofile[i] = filedup(proc->ofile[i]);
801045f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104600:	83 c2 08             	add    $0x8,%edx
80104603:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104607:	89 04 24             	mov    %eax,(%esp)
8010460a:	e8 6d c9 ff ff       	call   80100f7c <filedup>
8010460f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104612:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104615:	83 c1 08             	add    $0x8,%ecx
80104618:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
  np->tf->esp = (uint)stack+stack_size;
  np->tf->eip = (uint)start_func;
  //np->ofile = (struct file *)proc->ofile;
  for(i = 0; i < NOFILE; i++){
8010461c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104620:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104624:	7e bd                	jle    801045e3 <thread_create+0x126>
    if(proc->ofile[i]){
      np->ofile[i] = filedup(proc->ofile[i]);
    }
  }
  
  np->cwd = proc->cwd;
80104626:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010462c:	8b 50 6c             	mov    0x6c(%eax),%edx
8010462f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104632:	89 50 6c             	mov    %edx,0x6c(%eax)
  tid = np->tid;
80104635:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104638:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010463e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104641:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104644:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010464b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104651:	8d 50 70             	lea    0x70(%eax),%edx
80104654:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104657:	83 c0 70             	add    $0x70,%eax
8010465a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104661:	00 
80104662:	89 54 24 04          	mov    %edx,0x4(%esp)
80104666:	89 04 24             	mov    %eax,(%esp)
80104669:	e8 88 13 00 00       	call   801059f6 <safestrcpy>
  return tid;
8010466e:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104671:	83 c4 2c             	add    $0x2c,%esp
80104674:	5b                   	pop    %ebx
80104675:	5e                   	pop    %esi
80104676:	5f                   	pop    %edi
80104677:	5d                   	pop    %ebp
80104678:	c3                   	ret    

80104679 <thread_getId>:

int thread_getId(){
80104679:	55                   	push   %ebp
8010467a:	89 e5                	mov    %esp,%ebp
8010467c:	83 ec 18             	sub    $0x18,%esp
  if(proc && proc->is_thread){
8010467f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104685:	85 c0                	test   %eax,%eax
80104687:	74 1e                	je     801046a7 <thread_getId+0x2e>
80104689:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010468f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104695:	85 c0                	test   %eax,%eax
80104697:	74 0e                	je     801046a7 <thread_getId+0x2e>
    return proc->tid;
80104699:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010469f:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801046a5:	eb 1e                	jmp    801046c5 <thread_getId+0x4c>
  }
  else{
    cprintf("proccees %d asked for theard_id\n",proc->pid); 
801046a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ad:	8b 40 10             	mov    0x10(%eax),%eax
801046b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801046b4:	c7 04 24 e8 8f 10 80 	movl   $0x80108fe8,(%esp)
801046bb:	e8 e1 bc ff ff       	call   801003a1 <cprintf>
    return -1;
801046c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  
}
801046c5:	c9                   	leave  
801046c6:	c3                   	ret    

801046c7 <thread_getProcId>:

int thread_getProcId(){
801046c7:	55                   	push   %ebp
801046c8:	89 e5                	mov    %esp,%ebp
801046ca:	83 ec 18             	sub    $0x18,%esp
  if(proc){
801046cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d3:	85 c0                	test   %eax,%eax
801046d5:	74 0b                	je     801046e2 <thread_getProcId+0x1b>
    return proc->pid;  
801046d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046dd:	8b 40 10             	mov    0x10(%eax),%eax
801046e0:	eb 11                	jmp    801046f3 <thread_getProcId+0x2c>
  }
  else{
      cprintf("proccees 0 tried to do thread_getProcId\n"); 
801046e2:	c7 04 24 0c 90 10 80 	movl   $0x8010900c,(%esp)
801046e9:	e8 b3 bc ff ff       	call   801003a1 <cprintf>
    return -1;
801046ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
801046f3:	c9                   	leave  
801046f4:	c3                   	ret    

801046f5 <thread_join>:

int thread_join(int thread_id, void** ret_val){ 
801046f5:	55                   	push   %ebp
801046f6:	89 e5                	mov    %esp,%ebp
801046f8:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int found = 0;
801046fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&ptable.lock);
80104702:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104709:	e8 69 0e 00 00       	call   80105577 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010470e:	c7 45 f4 d4 33 11 80 	movl   $0x801133d4,-0xc(%ebp)
80104715:	e9 e8 00 00 00       	jmp    80104802 <thread_join+0x10d>
      if(p != proc && p->pid == proc->pid && p->is_thread && p->tid == thread_id){ //this is the thread we were looking for
8010471a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104720:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104723:	0f 84 d2 00 00 00    	je     801047fb <thread_join+0x106>
80104729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010472c:	8b 50 10             	mov    0x10(%eax),%edx
8010472f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104735:	8b 40 10             	mov    0x10(%eax),%eax
80104738:	39 c2                	cmp    %eax,%edx
8010473a:	0f 85 bb 00 00 00    	jne    801047fb <thread_join+0x106>
80104740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104743:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104749:	85 c0                	test   %eax,%eax
8010474b:	0f 84 aa 00 00 00    	je     801047fb <thread_join+0x106>
80104751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104754:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010475a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010475d:	0f 85 98 00 00 00    	jne    801047fb <thread_join+0x106>
	if(p->thread_joined){
80104763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104766:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010476c:	85 c0                	test   %eax,%eax
8010476e:	74 49                	je     801047b9 <thread_join+0xc4>
	  cprintf("Thread %d was called thread_join from Process %d but real parent was %d\n",p->tid,proc->pid,p->parent->pid); 
80104770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104773:	8b 40 14             	mov    0x14(%eax),%eax
80104776:	8b 48 10             	mov    0x10(%eax),%ecx
80104779:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010477f:	8b 50 10             	mov    0x10(%eax),%edx
80104782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104785:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010478b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010478f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104793:	89 44 24 04          	mov    %eax,0x4(%esp)
80104797:	c7 04 24 38 90 10 80 	movl   $0x80109038,(%esp)
8010479e:	e8 fe bb ff ff       	call   801003a1 <cprintf>
	  release(&ptable.lock);
801047a3:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
801047aa:	e8 2a 0e 00 00       	call   801055d9 <release>
	  return -2;
801047af:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801047b4:	e9 c0 00 00 00       	jmp    80104879 <thread_join+0x184>
	 }	
	
	if(p->state == ZOMBIE){//everything is cool
801047b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047bc:	8b 40 0c             	mov    0xc(%eax),%eax
801047bf:	83 f8 05             	cmp    $0x5,%eax
801047c2:	75 21                	jne    801047e5 <thread_join+0xf0>
	  //*ret_val =  (void*)p->tf->eax;
	  ret_val =  &(p->ret_val);
801047c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c7:	05 90 00 00 00       	add    $0x90,%eax
801047cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  release(&ptable.lock);
801047cf:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
801047d6:	e8 fe 0d 00 00       	call   801055d9 <release>
	  return 0;
801047db:	b8 00 00 00 00       	mov    $0x0,%eax
801047e0:	e9 94 00 00 00       	jmp    80104879 <thread_join+0x184>
	}
	found = 1;
801047e5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	p->thread_joined = 1;
801047ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ef:	c7 80 84 00 00 00 01 	movl   $0x1,0x84(%eax)
801047f6:	00 00 00 
	break;
801047f9:	eb 14                	jmp    8010480f <thread_join+0x11a>

int thread_join(int thread_id, void** ret_val){ 
  struct proc *p;
  int found = 0;
  acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047fb:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104802:	81 7d f4 d4 5a 11 80 	cmpl   $0x80115ad4,-0xc(%ebp)
80104809:	0f 82 0b ff ff ff    	jb     8010471a <thread_join+0x25>
	found = 1;
	p->thread_joined = 1;
	break;
      }
    }
    if(!found){
8010480f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104813:	75 39                	jne    8010484e <thread_join+0x159>
	cprintf("Thread %d from Process %d was not able to joined\n",p->tid,p->parent->pid); 
80104815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104818:	8b 40 14             	mov    0x14(%eax),%eax
8010481b:	8b 50 10             	mov    0x10(%eax),%edx
8010481e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104821:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104827:	89 54 24 08          	mov    %edx,0x8(%esp)
8010482b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010482f:	c7 04 24 84 90 10 80 	movl   $0x80109084,(%esp)
80104836:	e8 66 bb ff ff       	call   801003a1 <cprintf>
	release(&ptable.lock);
8010483b:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104842:	e8 92 0d 00 00       	call   801055d9 <release>
	return -1;
80104847:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010484c:	eb 2b                	jmp    80104879 <thread_join+0x184>
    }else{
	//current process wait for thread to terminate
	sleep(p,&ptable.lock);
8010484e:	c7 44 24 04 a0 33 11 	movl   $0x801133a0,0x4(%esp)
80104855:	80 
80104856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104859:	89 04 24             	mov    %eax,(%esp)
8010485c:	e8 30 0a 00 00       	call   80105291 <sleep>
	release(&ptable.lock);
80104861:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104868:	e8 6c 0d 00 00       	call   801055d9 <release>
	found = 0;
8010486d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    }
  return 0;
80104874:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104879:	c9                   	leave  
8010487a:	c3                   	ret    

8010487b <thread_exit>:


void 
thread_exit(void * ret_val){
8010487b:	55                   	push   %ebp
8010487c:	89 e5                	mov    %esp,%ebp
8010487e:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104881:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104888:	e8 ea 0c 00 00       	call   80105577 <acquire>
  
  if(proc->is_thread){//not the main procces
8010488d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104893:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104899:	85 c0                	test   %eax,%eax
8010489b:	0f 84 a2 00 00 00    	je     80104943 <thread_exit+0xc8>
    if(proc->parent->num_of_thread_child==1){//the main thread already thread_exit and also all other thread
801048a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a7:	8b 40 14             	mov    0x14(%eax),%eax
801048aa:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801048b0:	83 f8 01             	cmp    $0x1,%eax
801048b3:	75 29                	jne    801048de <thread_exit+0x63>
      proc->parent->num_of_thread_child--;
801048b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048bb:	8b 40 14             	mov    0x14(%eax),%eax
801048be:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
801048c4:	83 ea 01             	sub    $0x1,%edx
801048c7:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
      release(&ptable.lock);
801048cd:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
801048d4:	e8 00 0d 00 00       	call   801055d9 <release>
      exit();
801048d9:	e8 fe 03 00 00       	call   80104cdc <exit>
    }
  //this is not the last thread by any mean
    proc->ret_val = ret_val;			// not main thread and not the last one
801048de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e4:	8b 55 08             	mov    0x8(%ebp),%edx
801048e7:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    proc->parent->num_of_thread_child--;
801048ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f3:	8b 40 14             	mov    0x14(%eax),%eax
801048f6:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
801048fc:	83 ea 01             	sub    $0x1,%edx
801048ff:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    proc->state = ZOMBIE;
80104905:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010490b:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    if(proc->thread_joined)
80104912:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104918:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010491e:	85 c0                	test   %eax,%eax
80104920:	74 0e                	je     80104930 <thread_exit+0xb5>
      wakeup1(proc);
80104922:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104928:	89 04 24             	mov    %eax,(%esp)
8010492b:	e8 fc 09 00 00       	call   8010532c <wakeup1>
    sched();
80104930:	e8 4c 08 00 00       	call   80105181 <sched>
    release(&ptable.lock);
80104935:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
8010493c:	e8 98 0c 00 00       	call   801055d9 <release>
80104941:	eb 6c                	jmp    801049af <thread_exit+0x134>
  }
    
  else if (proc->num_of_thread_child == 1){//this is the main thread and it is the last thread
80104943:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104949:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010494f:	83 f8 01             	cmp    $0x1,%eax
80104952:	75 28                	jne    8010497c <thread_exit+0x101>
    proc->num_of_thread_child--;
80104954:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495a:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80104960:	83 ea 01             	sub    $0x1,%edx
80104963:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    release(&ptable.lock);
80104969:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104970:	e8 64 0c 00 00       	call   801055d9 <release>
    exit();
80104975:	e8 62 03 00 00       	call   80104cdc <exit>
8010497a:	eb 33                	jmp    801049af <thread_exit+0x134>
  }
  else{//this is the main thread but other thread are alive
    proc->num_of_thread_child--;
8010497c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104982:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80104988:	83 ea 01             	sub    $0x1,%edx
8010498b:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    proc->state = ZOMBIE;
80104991:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104997:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
8010499e:	e8 de 07 00 00       	call   80105181 <sched>
    release(&ptable.lock);
801049a3:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
801049aa:	e8 2a 0c 00 00       	call   801055d9 <release>
  }
}
801049af:	c9                   	leave  
801049b0:	c3                   	ret    

801049b1 <binary_semaphore_create>:

int 
binary_semaphore_create(int initial_value){//#####################################################################################
801049b1:	55                   	push   %ebp
801049b2:	89 e5                	mov    %esp,%ebp
801049b4:	83 ec 28             	sub    $0x28,%esp
  struct binary_semaphore* sem;
  int i=0;
801049b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  acquire(&sem_table.lock);
801049be:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
801049c5:	e8 ad 0b 00 00       	call   80105577 <acquire>
 for(i=0;i<NUM_OF_SEMAPHORES;i++){
801049ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801049d1:	eb 77                	jmp    80104a4a <binary_semaphore_create+0x99>
    sem = &sem_table.binary_semaphore[i];
801049d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049d6:	89 d0                	mov    %edx,%eax
801049d8:	c1 e0 02             	shl    $0x2,%eax
801049db:	01 d0                	add    %edx,%eax
801049dd:	c1 e0 02             	shl    $0x2,%eax
801049e0:	05 98 0f 11 80       	add    $0x80110f98,%eax
801049e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(sem->initialize){//if the semaphore is taken
801049e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049eb:	8b 40 04             	mov    0x4(%eax),%eax
801049ee:	85 c0                	test   %eax,%eax
801049f0:	74 06                	je     801049f8 <binary_semaphore_create+0x47>
int 
binary_semaphore_create(int initial_value){//#####################################################################################
  struct binary_semaphore* sem;
  int i=0;
  acquire(&sem_table.lock);
 for(i=0;i<NUM_OF_SEMAPHORES;i++){
801049f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801049f6:	eb 52                	jmp    80104a4a <binary_semaphore_create+0x99>
    sem = &sem_table.binary_semaphore[i];
    if(sem->initialize){//if the semaphore is taken
      continue;
    }
    sem->initialize = 1;
801049f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049fb:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
    initlock(&sem_table.sem_locks[i],"binary_semaphore");
80104a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a05:	6b c0 34             	imul   $0x34,%eax,%eax
80104a08:	05 98 19 11 80       	add    $0x80111998,%eax
80104a0d:	c7 44 24 04 b6 90 10 	movl   $0x801090b6,0x4(%esp)
80104a14:	80 
80104a15:	89 04 24             	mov    %eax,(%esp)
80104a18:	e8 39 0b 00 00       	call   80105556 <initlock>
    sem->value = initial_value;
80104a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a20:	8b 55 08             	mov    0x8(%ebp),%edx
80104a23:	89 10                	mov    %edx,(%eax)
    sem->first_in_queue = 0;
80104a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a28:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    sem->last_in_queue = 0;
80104a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a32:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    release(&sem_table.lock);
80104a39:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104a40:	e8 94 0b 00 00       	call   801055d9 <release>
    return i;
80104a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a48:	eb 23                	jmp    80104a6d <binary_semaphore_create+0xbc>
int 
binary_semaphore_create(int initial_value){//#####################################################################################
  struct binary_semaphore* sem;
  int i=0;
  acquire(&sem_table.lock);
 for(i=0;i<NUM_OF_SEMAPHORES;i++){
80104a4a:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80104a4e:	7e 83                	jle    801049d3 <binary_semaphore_create+0x22>
    sem->first_in_queue = 0;
    sem->last_in_queue = 0;
    release(&sem_table.lock);
    return i;
  }
  cprintf("we had problem at binary_semaphore_create\n"); 
80104a50:	c7 04 24 c8 90 10 80 	movl   $0x801090c8,(%esp)
80104a57:	e8 45 b9 ff ff       	call   801003a1 <cprintf>
  release(&sem_table.lock);
80104a5c:	c7 04 24 60 0f 11 80 	movl   $0x80110f60,(%esp)
80104a63:	e8 71 0b 00 00       	call   801055d9 <release>
  return -1;
80104a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a6d:	c9                   	leave  
80104a6e:	c3                   	ret    

80104a6f <binary_semaphore_down>:
 * this thread wants the semaphore
 * if its 0 then the thread does to sleep
 * else take it
 */
int 
binary_semaphore_down(int binary_semaphore_ID){
80104a6f:	55                   	push   %ebp
80104a70:	89 e5                	mov    %esp,%ebp
80104a72:	83 ec 28             	sub    $0x28,%esp
   //cprintf("place1: %d\n",proc->sem_queue_pos); 
   acquire(&sem_table.sem_locks[binary_semaphore_ID]);
80104a75:	8b 45 08             	mov    0x8(%ebp),%eax
80104a78:	6b c0 34             	imul   $0x34,%eax,%eax
80104a7b:	05 98 19 11 80       	add    $0x80111998,%eax
80104a80:	89 04 24             	mov    %eax,(%esp)
80104a83:	e8 ef 0a 00 00       	call   80105577 <acquire>
  struct binary_semaphore* sem = &sem_table.binary_semaphore[binary_semaphore_ID] ;
80104a88:	8b 55 08             	mov    0x8(%ebp),%edx
80104a8b:	89 d0                	mov    %edx,%eax
80104a8d:	c1 e0 02             	shl    $0x2,%eax
80104a90:	01 d0                	add    %edx,%eax
80104a92:	c1 e0 02             	shl    $0x2,%eax
80104a95:	05 98 0f 11 80       	add    $0x80110f98,%eax
80104a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //acquire(&sem_table.lock);
  
  
  //give the new thread a place in queue
  if(sem->waiting){
80104a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa0:	8b 40 08             	mov    0x8(%eax),%eax
80104aa3:	85 c0                	test   %eax,%eax
80104aa5:	74 21                	je     80104ac8 <binary_semaphore_down+0x59>
    proc->sem_queue_pos = ++(sem->waiting);
80104aa7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ab0:	8b 52 08             	mov    0x8(%edx),%edx
80104ab3:	8d 4a 01             	lea    0x1(%edx),%ecx
80104ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ab9:	89 4a 08             	mov    %ecx,0x8(%edx)
80104abc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104abf:	8b 52 08             	mov    0x8(%edx),%edx
80104ac2:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  }
  
  for(;;){
    //cprintf("place: %d\n",proc->sem_queue_pos); 
    if(sem->initialize){
80104ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104acb:	8b 40 04             	mov    0x4(%eax),%eax
80104ace:	85 c0                	test   %eax,%eax
80104ad0:	0f 84 ae 00 00 00    	je     80104b84 <binary_semaphore_down+0x115>
      if(sem->value && !proc->sem_queue_pos){//the sem is not locked && the thread is the next one
80104ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad9:	8b 00                	mov    (%eax),%eax
80104adb:	85 c0                	test   %eax,%eax
80104add:	74 46                	je     80104b25 <binary_semaphore_down+0xb6>
80104adf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae5:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104aeb:	85 c0                	test   %eax,%eax
80104aed:	75 36                	jne    80104b25 <binary_semaphore_down+0xb6>
	sem->value = 0;//sem is locked
80104aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	proc->wait_for_sem = -1;//done waiting 
80104af8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104afe:	c7 80 8c 00 00 00 ff 	movl   $0xffffffff,0x8c(%eax)
80104b05:	ff ff ff 
	release(&sem_table.sem_locks[binary_semaphore_ID]);
80104b08:	8b 45 08             	mov    0x8(%ebp),%eax
80104b0b:	6b c0 34             	imul   $0x34,%eax,%eax
80104b0e:	05 98 19 11 80       	add    $0x80111998,%eax
80104b13:	89 04 24             	mov    %eax,(%esp)
80104b16:	e8 be 0a 00 00       	call   801055d9 <release>
	return 0;
80104b1b:	b8 00 00 00 00       	mov    $0x0,%eax
80104b20:	e9 83 00 00 00       	jmp    80104ba8 <binary_semaphore_down+0x139>
      }
      else{//the sem is locked or this is this the first time for this thread
	  if(!proc->sem_queue_pos){
80104b25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b2b:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104b31:	85 c0                	test   %eax,%eax
80104b33:	75 21                	jne    80104b56 <binary_semaphore_down+0xe7>
	    proc->sem_queue_pos = ++(sem->waiting);
80104b35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b3e:	8b 52 08             	mov    0x8(%edx),%edx
80104b41:	8d 4a 01             	lea    0x1(%edx),%ecx
80104b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b47:	89 4a 08             	mov    %ecx,0x8(%edx)
80104b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b4d:	8b 52 08             	mov    0x8(%edx),%edx
80104b50:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
	  }
	  proc->wait_for_sem = binary_semaphore_ID;
80104b56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5c:	8b 55 08             	mov    0x8(%ebp),%edx
80104b5f:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
	  sleep(sem,&sem_table.sem_locks[binary_semaphore_ID]);
80104b65:	8b 45 08             	mov    0x8(%ebp),%eax
80104b68:	6b c0 34             	imul   $0x34,%eax,%eax
80104b6b:	05 98 19 11 80       	add    $0x80111998,%eax
80104b70:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b77:	89 04 24             	mov    %eax,(%esp)
80104b7a:	e8 12 07 00 00       	call   80105291 <sleep>
    else{
      cprintf("we had problem at binary_semaphore_down: the semaphore wasnt initialize\n"); 
      release(&sem_table.sem_locks[binary_semaphore_ID]);
      return -1;
    }
  }
80104b7f:	e9 44 ff ff ff       	jmp    80104ac8 <binary_semaphore_down+0x59>
	  proc->wait_for_sem = binary_semaphore_ID;
	  sleep(sem,&sem_table.sem_locks[binary_semaphore_ID]);
      }
    }
    else{
      cprintf("we had problem at binary_semaphore_down: the semaphore wasnt initialize\n"); 
80104b84:	c7 04 24 f4 90 10 80 	movl   $0x801090f4,(%esp)
80104b8b:	e8 11 b8 ff ff       	call   801003a1 <cprintf>
      release(&sem_table.sem_locks[binary_semaphore_ID]);
80104b90:	8b 45 08             	mov    0x8(%ebp),%eax
80104b93:	6b c0 34             	imul   $0x34,%eax,%eax
80104b96:	05 98 19 11 80       	add    $0x80111998,%eax
80104b9b:	89 04 24             	mov    %eax,(%esp)
80104b9e:	e8 36 0a 00 00       	call   801055d9 <release>
      return -1;
80104ba3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
  }
}
80104ba8:	c9                   	leave  
80104ba9:	c3                   	ret    

80104baa <binary_semaphore_up>:
 * if somebody else want it, we wake them up by its queue place
 */


int
binary_semaphore_up(int binary_semaphore_ID){
80104baa:	55                   	push   %ebp
80104bab:	89 e5                	mov    %esp,%ebp
80104bad:	83 ec 28             	sub    $0x28,%esp
  //cprintf("place2: %d\n",proc->sem_queue_pos); 
  acquire(&sem_table.sem_locks[binary_semaphore_ID]);
80104bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80104bb3:	6b c0 34             	imul   $0x34,%eax,%eax
80104bb6:	05 98 19 11 80       	add    $0x80111998,%eax
80104bbb:	89 04 24             	mov    %eax,(%esp)
80104bbe:	e8 b4 09 00 00       	call   80105577 <acquire>
  struct binary_semaphore* sem = &sem_table.binary_semaphore[binary_semaphore_ID];
80104bc3:	8b 55 08             	mov    0x8(%ebp),%edx
80104bc6:	89 d0                	mov    %edx,%eax
80104bc8:	c1 e0 02             	shl    $0x2,%eax
80104bcb:	01 d0                	add    %edx,%eax
80104bcd:	c1 e0 02             	shl    $0x2,%eax
80104bd0:	05 98 0f 11 80       	add    $0x80110f98,%eax
80104bd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(sem->initialize){   
80104bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bdb:	8b 40 04             	mov    0x4(%eax),%eax
80104bde:	85 c0                	test   %eax,%eax
80104be0:	0f 84 d0 00 00 00    	je     80104cb6 <binary_semaphore_up+0x10c>
    struct proc *p;
    struct proc* next = 0;
80104be6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    //looking for whom to wakeup who are sleeping and next
    acquire(&ptable.lock);
80104bed:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104bf4:	e8 7e 09 00 00       	call   80105577 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bf9:	c7 45 f4 d4 33 11 80 	movl   $0x801133d4,-0xc(%ebp)
80104c00:	eb 48                	jmp    80104c4a <binary_semaphore_up+0xa0>
      //cprintf("place: %d\n",proc->sem_queue_pos); 
      if(p != proc && p->wait_for_sem == binary_semaphore_ID){
80104c02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c08:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104c0b:	74 36                	je     80104c43 <binary_semaphore_up+0x99>
80104c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c10:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80104c16:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c19:	75 28                	jne    80104c43 <binary_semaphore_up+0x99>
	  p->sem_queue_pos--;
80104c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c1e:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104c24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c2a:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
	  if(p->sem_queue_pos == 0)
80104c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c33:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104c39:	85 c0                	test   %eax,%eax
80104c3b:	75 06                	jne    80104c43 <binary_semaphore_up+0x99>
	    next = p;
80104c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(sem->initialize){   
    struct proc *p;
    struct proc* next = 0;
    //looking for whom to wakeup who are sleeping and next
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c43:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104c4a:	81 7d f4 d4 5a 11 80 	cmpl   $0x80115ad4,-0xc(%ebp)
80104c51:	72 af                	jb     80104c02 <binary_semaphore_up+0x58>
	    next = p;
      }
    }
    
     
    if(sem->waiting>0){
80104c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c56:	8b 40 08             	mov    0x8(%eax),%eax
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	7e 0f                	jle    80104c6c <binary_semaphore_up+0xc2>
	sem->waiting--;
80104c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c60:	8b 40 08             	mov    0x8(%eax),%eax
80104c63:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c69:	89 50 08             	mov    %edx,0x8(%eax)
    }
    sem->value = 1;//sem is available
80104c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c6f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    
    //wake up the next thread
    if(next && next->state == SLEEPING)
80104c75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c79:	74 15                	je     80104c90 <binary_semaphore_up+0xe6>
80104c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c7e:	8b 40 0c             	mov    0xc(%eax),%eax
80104c81:	83 f8 02             	cmp    $0x2,%eax
80104c84:	75 0a                	jne    80104c90 <binary_semaphore_up+0xe6>
      next->state = RUNNABLE;
80104c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c89:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    
    release(&ptable.lock);
80104c90:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104c97:	e8 3d 09 00 00       	call   801055d9 <release>
    release(&sem_table.sem_locks[binary_semaphore_ID]);//realsing the sem
80104c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9f:	6b c0 34             	imul   $0x34,%eax,%eax
80104ca2:	05 98 19 11 80       	add    $0x80111998,%eax
80104ca7:	89 04 24             	mov    %eax,(%esp)
80104caa:	e8 2a 09 00 00       	call   801055d9 <release>
    
    
    //wakeup1(sem);
    return 0;
80104caf:	b8 00 00 00 00       	mov    $0x0,%eax
80104cb4:	eb 24                	jmp    80104cda <binary_semaphore_up+0x130>
  }
  else{
    release(&sem_table.sem_locks[binary_semaphore_ID]);//realsing the sem
80104cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80104cb9:	6b c0 34             	imul   $0x34,%eax,%eax
80104cbc:	05 98 19 11 80       	add    $0x80111998,%eax
80104cc1:	89 04 24             	mov    %eax,(%esp)
80104cc4:	e8 10 09 00 00       	call   801055d9 <release>
    cprintf("we had problem at binary_semaphore_up: the semaphore wasn't initialize\n"); 
80104cc9:	c7 04 24 40 91 10 80 	movl   $0x80109140,(%esp)
80104cd0:	e8 cc b6 ff ff       	call   801003a1 <cprintf>
    return -1;
80104cd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80104cda:	c9                   	leave  
80104cdb:	c3                   	ret    

80104cdc <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104cdc:	55                   	push   %ebp
80104cdd:	89 e5                	mov    %esp,%ebp
80104cdf:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104ce2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ce9:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104cee:	39 c2                	cmp    %eax,%edx
80104cf0:	75 0c                	jne    80104cfe <exit+0x22>
    panic("init exiting");
80104cf2:	c7 04 24 88 91 10 80 	movl   $0x80109188,(%esp)
80104cf9:	e8 3f b8 ff ff       	call   8010053d <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104cfe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104d05:	eb 44                	jmp    80104d4b <exit+0x6f>
    if(proc->ofile[fd]){
80104d07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d10:	83 c2 08             	add    $0x8,%edx
80104d13:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104d17:	85 c0                	test   %eax,%eax
80104d19:	74 2c                	je     80104d47 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104d1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d21:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d24:	83 c2 08             	add    $0x8,%edx
80104d27:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104d2b:	89 04 24             	mov    %eax,(%esp)
80104d2e:	e8 91 c2 ff ff       	call   80100fc4 <fileclose>
      proc->ofile[fd] = 0;
80104d33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d39:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d3c:	83 c2 08             	add    $0x8,%edx
80104d3f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104d46:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104d47:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104d4b:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104d4f:	7e b6                	jle    80104d07 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104d51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d57:	8b 40 6c             	mov    0x6c(%eax),%eax
80104d5a:	89 04 24             	mov    %eax,(%esp)
80104d5d:	e8 b9 cc ff ff       	call   80101a1b <iput>
  proc->cwd = 0;
80104d62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d68:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)

  acquire(&ptable.lock);
80104d6f:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104d76:	e8 fc 07 00 00       	call   80105577 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104d7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d81:	8b 40 14             	mov    0x14(%eax),%eax
80104d84:	89 04 24             	mov    %eax,(%esp)
80104d87:	e8 a0 05 00 00       	call   8010532c <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d8c:	c7 45 f4 d4 33 11 80 	movl   $0x801133d4,-0xc(%ebp)
80104d93:	e9 07 01 00 00       	jmp    80104e9f <exit+0x1c3>
    if(p->pid == proc->pid && p->state != ZOMBIE){ //undead thread
80104d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9b:	8b 50 10             	mov    0x10(%eax),%edx
80104d9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da4:	8b 40 10             	mov    0x10(%eax),%eax
80104da7:	39 c2                	cmp    %eax,%edx
80104da9:	0f 85 a4 00 00 00    	jne    80104e53 <exit+0x177>
80104daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db2:	8b 40 0c             	mov    0xc(%eax),%eax
80104db5:	83 f8 05             	cmp    $0x5,%eax
80104db8:	0f 84 95 00 00 00    	je     80104e53 <exit+0x177>
    p->state = ZOMBIE;
80104dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc1:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    
    if(p->is_thread){//it is a thread
80104dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dcb:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104dd1:	85 c0                	test   %eax,%eax
80104dd3:	74 4c                	je     80104e21 <exit+0x145>
	  if(p->parent->num_of_thread_child){
80104dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd8:	8b 40 14             	mov    0x14(%eax),%eax
80104ddb:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104de1:	85 c0                	test   %eax,%eax
80104de3:	74 15                	je     80104dfa <exit+0x11e>
	    p->parent->num_of_thread_child--;
80104de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de8:	8b 40 14             	mov    0x14(%eax),%eax
80104deb:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80104df1:	83 ea 01             	sub    $0x1,%edx
80104df4:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
	  }
	  if(!p->parent->num_of_thread_child){
80104dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dfd:	8b 40 14             	mov    0x14(%eax),%eax
80104e00:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104e06:	85 c0                	test   %eax,%eax
80104e08:	0f 85 89 00 00 00    	jne    80104e97 <exit+0x1bb>
	    wakeup1(p->parent->parent);
80104e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e11:	8b 40 14             	mov    0x14(%eax),%eax
80104e14:	8b 40 14             	mov    0x14(%eax),%eax
80104e17:	89 04 24             	mov    %eax,(%esp)
80104e1a:	e8 0d 05 00 00       	call   8010532c <wakeup1>
  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == proc->pid && p->state != ZOMBIE){ //undead thread
    p->state = ZOMBIE;
    
    if(p->is_thread){//it is a thread
80104e1f:	eb 76                	jmp    80104e97 <exit+0x1bb>
	  if(!p->parent->num_of_thread_child){
	    wakeup1(p->parent->parent);
	  }
	}
    else{
     p->num_of_thread_child--;
80104e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e24:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104e2a:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e30:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
     if(!p->num_of_thread_child){
80104e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e39:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104e3f:	85 c0                	test   %eax,%eax
80104e41:	75 54                	jne    80104e97 <exit+0x1bb>
	 wakeup1(p->parent); 
80104e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e46:	8b 40 14             	mov    0x14(%eax),%eax
80104e49:	89 04 24             	mov    %eax,(%esp)
80104e4c:	e8 db 04 00 00       	call   8010532c <wakeup1>
  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == proc->pid && p->state != ZOMBIE){ //undead thread
    p->state = ZOMBIE;
    
    if(p->is_thread){//it is a thread
80104e51:	eb 44                	jmp    80104e97 <exit+0x1bb>
     if(!p->num_of_thread_child){
	 wakeup1(p->parent); 
      }
      }
    }
    else if(p->parent == proc && p->is_thread !=1){// a proccess child
80104e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e56:	8b 50 14             	mov    0x14(%eax),%edx
80104e59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e5f:	39 c2                	cmp    %eax,%edx
80104e61:	75 35                	jne    80104e98 <exit+0x1bc>
80104e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e66:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104e6c:	83 f8 01             	cmp    $0x1,%eax
80104e6f:	74 27                	je     80104e98 <exit+0x1bc>
      p->parent = initproc;
80104e71:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e7a:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE){
80104e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e80:	8b 40 0c             	mov    0xc(%eax),%eax
80104e83:	83 f8 05             	cmp    $0x5,%eax
80104e86:	75 10                	jne    80104e98 <exit+0x1bc>
        wakeup1(initproc);
80104e88:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104e8d:	89 04 24             	mov    %eax,(%esp)
80104e90:	e8 97 04 00 00       	call   8010532c <wakeup1>
80104e95:	eb 01                	jmp    80104e98 <exit+0x1bc>
  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == proc->pid && p->state != ZOMBIE){ //undead thread
    p->state = ZOMBIE;
    
    if(p->is_thread){//it is a thread
80104e97:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e98:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104e9f:	81 7d f4 d4 5a 11 80 	cmpl   $0x80115ad4,-0xc(%ebp)
80104ea6:	0f 82 ec fe ff ff    	jb     80104d98 <exit+0xbc>
      }
    }
  }
  
  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104eac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eb2:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104eb9:	e8 c3 02 00 00       	call   80105181 <sched>
  panic("zombie exit");
80104ebe:	c7 04 24 95 91 10 80 	movl   $0x80109195,(%esp)
80104ec5:	e8 73 b6 ff ff       	call   8010053d <panic>

80104eca <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104eca:	55                   	push   %ebp
80104ecb:	89 e5                	mov    %esp,%ebp
80104ecd:	83 ec 38             	sub    $0x38,%esp
  struct proc *p;
  int havekids, pid;
  int found_p = 0, first_p = 0;
80104ed0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80104ed7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  acquire(&ptable.lock);
80104ede:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104ee5:	e8 8d 06 00 00       	call   80105577 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104eea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ef1:	c7 45 f4 d4 33 11 80 	movl   $0x801133d4,-0xc(%ebp)
80104ef8:	eb 4f                	jmp    80104f49 <wait+0x7f>
      if(p->parent != proc)
80104efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104efd:	8b 50 14             	mov    0x14(%eax),%edx
80104f00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f06:	39 c2                	cmp    %eax,%edx
80104f08:	75 37                	jne    80104f41 <wait+0x77>
        continue;
      havekids = 1;
80104f0a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE && !p->is_thread && p->num_of_thread_child == 0){
80104f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f14:	8b 40 0c             	mov    0xc(%eax),%eax
80104f17:	83 f8 05             	cmp    $0x5,%eax
80104f1a:	75 26                	jne    80104f42 <wait+0x78>
80104f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f1f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104f25:	85 c0                	test   %eax,%eax
80104f27:	75 19                	jne    80104f42 <wait+0x78>
80104f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2c:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104f32:	85 c0                	test   %eax,%eax
80104f34:	75 0c                	jne    80104f42 <wait+0x78>
        found_p = p->pid;
80104f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f39:	8b 40 10             	mov    0x10(%eax),%eax
80104f3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	break;
80104f3f:	eb 11                	jmp    80104f52 <wait+0x88>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104f41:	90                   	nop
  int found_p = 0, first_p = 0;
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f42:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104f49:	81 7d f4 d4 5a 11 80 	cmpl   $0x80115ad4,-0xc(%ebp)
80104f50:	72 a8                	jb     80104efa <wait+0x30>
      if(p->state == ZOMBIE && !p->is_thread && p->num_of_thread_child == 0){
        found_p = p->pid;
	break;
      }
    }
    if(found_p){ // we found it a zombie procces with zombi kids (adams family)
80104f52:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80104f56:	0f 84 8f 00 00 00    	je     80104feb <wait+0x121>
      
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f5c:	c7 45 f4 d4 33 11 80 	movl   $0x801133d4,-0xc(%ebp)
80104f63:	eb 79                	jmp    80104fde <wait+0x114>
	if(p->pid != found_p){
80104f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f68:	8b 40 10             	mov    0x10(%eax),%eax
80104f6b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80104f6e:	75 66                	jne    80104fd6 <wait+0x10c>
	  continue;
	}

	if(!first_p)
80104f70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80104f74:	75 15                	jne    80104f8b <wait+0xc1>
	{
	 freevm(p->pgdir);
80104f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f79:	8b 40 04             	mov    0x4(%eax),%eax
80104f7c:	89 04 24             	mov    %eax,(%esp)
80104f7f:	e8 75 3a 00 00       	call   801089f9 <freevm>
	 first_p = 1;
80104f84:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	}
	pid = p->pid;
80104f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f8e:	8b 40 10             	mov    0x10(%eax),%eax
80104f91:	89 45 ec             	mov    %eax,-0x14(%ebp)
	kfree(p->kstack);
80104f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f97:	8b 40 08             	mov    0x8(%eax),%eax
80104f9a:	89 04 24             	mov    %eax,(%esp)
80104f9d:	e8 c4 da ff ff       	call   80102a66 <kfree>
	p->kstack = 0;
80104fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	p->state = UNUSED;
80104fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104faf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	p->pid = 0;
80104fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb9:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
	p->parent = 0;
80104fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	p->killed = 0;
80104fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fcd:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
80104fd4:	eb 01                	jmp    80104fd7 <wait+0x10d>
    }
    if(found_p){ // we found it a zombie procces with zombi kids (adams family)
      
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if(p->pid != found_p){
	  continue;
80104fd6:	90                   	nop
	break;
      }
    }
    if(found_p){ // we found it a zombie procces with zombi kids (adams family)
      
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fd7:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104fde:	81 7d f4 d4 5a 11 80 	cmpl   $0x80115ad4,-0xc(%ebp)
80104fe5:	0f 82 7a ff ff ff    	jb     80104f65 <wait+0x9b>
	p->pid = 0;
	p->parent = 0;
	p->killed = 0;
      }
    }
    if(found_p){
80104feb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80104fef:	74 11                	je     80105002 <wait+0x138>
      release(&ptable.lock);
80104ff1:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80104ff8:	e8 dc 05 00 00       	call   801055d9 <release>
      return pid;
80104ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105000:	eb 41                	jmp    80105043 <wait+0x179>
    }
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80105002:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105006:	74 0d                	je     80105015 <wait+0x14b>
80105008:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010500e:	8b 40 24             	mov    0x24(%eax),%eax
80105011:	85 c0                	test   %eax,%eax
80105013:	74 13                	je     80105028 <wait+0x15e>
      release(&ptable.lock);
80105015:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
8010501c:	e8 b8 05 00 00       	call   801055d9 <release>
      return -1;
80105021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105026:	eb 1b                	jmp    80105043 <wait+0x179>
    }
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80105028:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010502e:	c7 44 24 04 a0 33 11 	movl   $0x801133a0,0x4(%esp)
80105035:	80 
80105036:	89 04 24             	mov    %eax,(%esp)
80105039:	e8 53 02 00 00       	call   80105291 <sleep>
  }
8010503e:	e9 a7 fe ff ff       	jmp    80104eea <wait+0x20>
}
80105043:	c9                   	leave  
80105044:	c3                   	ret    

80105045 <register_handler>:

void
register_handler(sighandler_t sighandler)
{
80105045:	55                   	push   %ebp
80105046:	89 e5                	mov    %esp,%ebp
80105048:	83 ec 28             	sub    $0x28,%esp
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
8010504b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105051:	8b 40 18             	mov    0x18(%eax),%eax
80105054:	8b 40 44             	mov    0x44(%eax),%eax
80105057:	89 c2                	mov    %eax,%edx
80105059:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010505f:	8b 40 04             	mov    0x4(%eax),%eax
80105062:	89 54 24 04          	mov    %edx,0x4(%esp)
80105066:	89 04 24             	mov    %eax,(%esp)
80105069:	e8 70 3b 00 00       	call   80108bde <uva2ka>
8010506e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((proc->tf->esp & 0xFFF) == 0)
80105071:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105077:	8b 40 18             	mov    0x18(%eax),%eax
8010507a:	8b 40 44             	mov    0x44(%eax),%eax
8010507d:	25 ff 0f 00 00       	and    $0xfff,%eax
80105082:	85 c0                	test   %eax,%eax
80105084:	75 0c                	jne    80105092 <register_handler+0x4d>
    panic("esp_offset == 0");
80105086:	c7 04 24 a1 91 10 80 	movl   $0x801091a1,(%esp)
8010508d:	e8 ab b4 ff ff       	call   8010053d <panic>

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
80105092:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105098:	8b 40 18             	mov    0x18(%eax),%eax
8010509b:	8b 40 44             	mov    0x44(%eax),%eax
8010509e:	83 e8 04             	sub    $0x4,%eax
801050a1:	25 ff 0f 00 00       	and    $0xfff,%eax
801050a6:	03 45 f4             	add    -0xc(%ebp),%eax
          = proc->tf->eip;
801050a9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050b0:	8b 52 18             	mov    0x18(%edx),%edx
801050b3:	8b 52 38             	mov    0x38(%edx),%edx
801050b6:	89 10                	mov    %edx,(%eax)
  proc->tf->esp -= 4;
801050b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050be:	8b 40 18             	mov    0x18(%eax),%eax
801050c1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050c8:	8b 52 18             	mov    0x18(%edx),%edx
801050cb:	8b 52 44             	mov    0x44(%edx),%edx
801050ce:	83 ea 04             	sub    $0x4,%edx
801050d1:	89 50 44             	mov    %edx,0x44(%eax)

    /* update eip */
  proc->tf->eip = (uint)sighandler;
801050d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050da:	8b 40 18             	mov    0x18(%eax),%eax
801050dd:	8b 55 08             	mov    0x8(%ebp),%edx
801050e0:	89 50 38             	mov    %edx,0x38(%eax)
}
801050e3:	c9                   	leave  
801050e4:	c3                   	ret    

801050e5 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801050e5:	55                   	push   %ebp
801050e6:	89 e5                	mov    %esp,%ebp
801050e8:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801050eb:	e8 15 ef ff ff       	call   80104005 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801050f0:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
801050f7:	e8 7b 04 00 00       	call   80105577 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050fc:	c7 45 f4 d4 33 11 80 	movl   $0x801133d4,-0xc(%ebp)
80105103:	eb 62                	jmp    80105167 <scheduler+0x82>
      if(p->state != RUNNABLE)
80105105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105108:	8b 40 0c             	mov    0xc(%eax),%eax
8010510b:	83 f8 03             	cmp    $0x3,%eax
8010510e:	75 4f                	jne    8010515f <scheduler+0x7a>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80105110:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105113:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80105119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010511c:	89 04 24             	mov    %eax,(%esp)
8010511f:	e8 5e 34 00 00       	call   80108582 <switchuvm>
      p->state = RUNNING;
80105124:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105127:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      
      swtch(&cpu->scheduler, proc->context);
8010512e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105134:	8b 40 1c             	mov    0x1c(%eax),%eax
80105137:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010513e:	83 c2 04             	add    $0x4,%edx
80105141:	89 44 24 04          	mov    %eax,0x4(%esp)
80105145:	89 14 24             	mov    %edx,(%esp)
80105148:	e8 1f 09 00 00       	call   80105a6c <swtch>
      switchkvm();
8010514d:	e8 13 34 00 00       	call   80108565 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80105152:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80105159:	00 00 00 00 
8010515d:	eb 01                	jmp    80105160 <scheduler+0x7b>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
8010515f:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105160:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80105167:	81 7d f4 d4 5a 11 80 	cmpl   $0x80115ad4,-0xc(%ebp)
8010516e:	72 95                	jb     80105105 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80105170:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80105177:	e8 5d 04 00 00       	call   801055d9 <release>

  }
8010517c:	e9 6a ff ff ff       	jmp    801050eb <scheduler+0x6>

80105181 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80105181:	55                   	push   %ebp
80105182:	89 e5                	mov    %esp,%ebp
80105184:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80105187:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
8010518e:	e8 02 05 00 00       	call   80105695 <holding>
80105193:	85 c0                	test   %eax,%eax
80105195:	75 0c                	jne    801051a3 <sched+0x22>
    panic("sched ptable.lock");
80105197:	c7 04 24 b1 91 10 80 	movl   $0x801091b1,(%esp)
8010519e:	e8 9a b3 ff ff       	call   8010053d <panic>
  if(cpu->ncli != 1)
801051a3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051a9:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801051af:	83 f8 01             	cmp    $0x1,%eax
801051b2:	74 0c                	je     801051c0 <sched+0x3f>
    panic("sched locks");
801051b4:	c7 04 24 c3 91 10 80 	movl   $0x801091c3,(%esp)
801051bb:	e8 7d b3 ff ff       	call   8010053d <panic>
  if(proc->state == RUNNING)
801051c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051c6:	8b 40 0c             	mov    0xc(%eax),%eax
801051c9:	83 f8 04             	cmp    $0x4,%eax
801051cc:	75 0c                	jne    801051da <sched+0x59>
    panic("sched running");
801051ce:	c7 04 24 cf 91 10 80 	movl   $0x801091cf,(%esp)
801051d5:	e8 63 b3 ff ff       	call   8010053d <panic>
  if(readeflags()&FL_IF)
801051da:	e8 11 ee ff ff       	call   80103ff0 <readeflags>
801051df:	25 00 02 00 00       	and    $0x200,%eax
801051e4:	85 c0                	test   %eax,%eax
801051e6:	74 0c                	je     801051f4 <sched+0x73>
    panic("sched interruptible");
801051e8:	c7 04 24 dd 91 10 80 	movl   $0x801091dd,(%esp)
801051ef:	e8 49 b3 ff ff       	call   8010053d <panic>
  intena = cpu->intena;
801051f4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051fa:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80105203:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105209:	8b 40 04             	mov    0x4(%eax),%eax
8010520c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105213:	83 c2 1c             	add    $0x1c,%edx
80105216:	89 44 24 04          	mov    %eax,0x4(%esp)
8010521a:	89 14 24             	mov    %edx,(%esp)
8010521d:	e8 4a 08 00 00       	call   80105a6c <swtch>
  cpu->intena = intena;
80105222:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105228:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010522b:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105231:	c9                   	leave  
80105232:	c3                   	ret    

80105233 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105233:	55                   	push   %ebp
80105234:	89 e5                	mov    %esp,%ebp
80105236:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105239:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80105240:	e8 32 03 00 00       	call   80105577 <acquire>
  proc->state = RUNNABLE;
80105245:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010524b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  //cprintf("YIELD pid %d\n",proc->pid);
  sched();
80105252:	e8 2a ff ff ff       	call   80105181 <sched>
  release(&ptable.lock);
80105257:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
8010525e:	e8 76 03 00 00       	call   801055d9 <release>
}
80105263:	c9                   	leave  
80105264:	c3                   	ret    

80105265 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105265:	55                   	push   %ebp
80105266:	89 e5                	mov    %esp,%ebp
80105268:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010526b:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80105272:	e8 62 03 00 00       	call   801055d9 <release>

  if (first) {
80105277:	a1 24 c0 10 80       	mov    0x8010c024,%eax
8010527c:	85 c0                	test   %eax,%eax
8010527e:	74 0f                	je     8010528f <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105280:	c7 05 24 c0 10 80 00 	movl   $0x0,0x8010c024
80105287:	00 00 00 
    initlog();
8010528a:	e8 81 dd ff ff       	call   80103010 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
8010528f:	c9                   	leave  
80105290:	c3                   	ret    

80105291 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80105291:	55                   	push   %ebp
80105292:	89 e5                	mov    %esp,%ebp
80105294:	83 ec 18             	sub    $0x18,%esp

  if(proc == 0)
80105297:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010529d:	85 c0                	test   %eax,%eax
8010529f:	75 0c                	jne    801052ad <sleep+0x1c>
    panic("sleep");
801052a1:	c7 04 24 f1 91 10 80 	movl   $0x801091f1,(%esp)
801052a8:	e8 90 b2 ff ff       	call   8010053d <panic>

  if(lk == 0)
801052ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801052b1:	75 0c                	jne    801052bf <sleep+0x2e>
    panic("sleep without lk");
801052b3:	c7 04 24 f7 91 10 80 	movl   $0x801091f7,(%esp)
801052ba:	e8 7e b2 ff ff       	call   8010053d <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801052bf:	81 7d 0c a0 33 11 80 	cmpl   $0x801133a0,0xc(%ebp)
801052c6:	74 17                	je     801052df <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
801052c8:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
801052cf:	e8 a3 02 00 00       	call   80105577 <acquire>
    release(lk);
801052d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801052d7:	89 04 24             	mov    %eax,(%esp)
801052da:	e8 fa 02 00 00       	call   801055d9 <release>
  }
  // Go to sleep.
  proc->chan = chan;
801052df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052e5:	8b 55 08             	mov    0x8(%ebp),%edx
801052e8:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801052eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052f1:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  //cprintf("SLEEP pid %d\n",proc->pid);
  sched();
801052f8:	e8 84 fe ff ff       	call   80105181 <sched>
  // Tidy up.
  proc->chan = 0;
801052fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105303:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010530a:	81 7d 0c a0 33 11 80 	cmpl   $0x801133a0,0xc(%ebp)
80105311:	74 17                	je     8010532a <sleep+0x99>
    release(&ptable.lock);
80105313:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
8010531a:	e8 ba 02 00 00       	call   801055d9 <release>
    acquire(lk);
8010531f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105322:	89 04 24             	mov    %eax,(%esp)
80105325:	e8 4d 02 00 00       	call   80105577 <acquire>
  }
}
8010532a:	c9                   	leave  
8010532b:	c3                   	ret    

8010532c <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010532c:	55                   	push   %ebp
8010532d:	89 e5                	mov    %esp,%ebp
8010532f:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105332:	c7 45 fc d4 33 11 80 	movl   $0x801133d4,-0x4(%ebp)
80105339:	eb 27                	jmp    80105362 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
8010533b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010533e:	8b 40 0c             	mov    0xc(%eax),%eax
80105341:	83 f8 02             	cmp    $0x2,%eax
80105344:	75 15                	jne    8010535b <wakeup1+0x2f>
80105346:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105349:	8b 40 20             	mov    0x20(%eax),%eax
8010534c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010534f:	75 0a                	jne    8010535b <wakeup1+0x2f>
      p->state = RUNNABLE;
80105351:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105354:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010535b:	81 45 fc 9c 00 00 00 	addl   $0x9c,-0x4(%ebp)
80105362:	81 7d fc d4 5a 11 80 	cmpl   $0x80115ad4,-0x4(%ebp)
80105369:	72 d0                	jb     8010533b <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
8010536b:	c9                   	leave  
8010536c:	c3                   	ret    

8010536d <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010536d:	55                   	push   %ebp
8010536e:	89 e5                	mov    %esp,%ebp
80105370:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105373:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
8010537a:	e8 f8 01 00 00       	call   80105577 <acquire>
  wakeup1(chan);
8010537f:	8b 45 08             	mov    0x8(%ebp),%eax
80105382:	89 04 24             	mov    %eax,(%esp)
80105385:	e8 a2 ff ff ff       	call   8010532c <wakeup1>
  release(&ptable.lock);
8010538a:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80105391:	e8 43 02 00 00       	call   801055d9 <release>
}
80105396:	c9                   	leave  
80105397:	c3                   	ret    

80105398 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105398:	55                   	push   %ebp
80105399:	89 e5                	mov    %esp,%ebp
8010539b:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010539e:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
801053a5:	e8 cd 01 00 00       	call   80105577 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053aa:	c7 45 f4 d4 33 11 80 	movl   $0x801133d4,-0xc(%ebp)
801053b1:	eb 44                	jmp    801053f7 <kill+0x5f>
    if(p->pid == pid){
801053b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b6:	8b 40 10             	mov    0x10(%eax),%eax
801053b9:	3b 45 08             	cmp    0x8(%ebp),%eax
801053bc:	75 32                	jne    801053f0 <kill+0x58>
      p->killed = 1;
801053be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801053c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053cb:	8b 40 0c             	mov    0xc(%eax),%eax
801053ce:	83 f8 02             	cmp    $0x2,%eax
801053d1:	75 0a                	jne    801053dd <kill+0x45>
        p->state = RUNNABLE;
801053d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801053dd:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
801053e4:	e8 f0 01 00 00       	call   801055d9 <release>
      return 0;
801053e9:	b8 00 00 00 00       	mov    $0x0,%eax
801053ee:	eb 21                	jmp    80105411 <kill+0x79>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053f0:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
801053f7:	81 7d f4 d4 5a 11 80 	cmpl   $0x80115ad4,-0xc(%ebp)
801053fe:	72 b3                	jb     801053b3 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105400:	c7 04 24 a0 33 11 80 	movl   $0x801133a0,(%esp)
80105407:	e8 cd 01 00 00       	call   801055d9 <release>
  return -1;
8010540c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105411:	c9                   	leave  
80105412:	c3                   	ret    

80105413 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105413:	55                   	push   %ebp
80105414:	89 e5                	mov    %esp,%ebp
80105416:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105419:	c7 45 f0 d4 33 11 80 	movl   $0x801133d4,-0x10(%ebp)
80105420:	e9 db 00 00 00       	jmp    80105500 <procdump+0xed>
    if(p->state == UNUSED)
80105425:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105428:	8b 40 0c             	mov    0xc(%eax),%eax
8010542b:	85 c0                	test   %eax,%eax
8010542d:	0f 84 c5 00 00 00    	je     801054f8 <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105433:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105436:	8b 40 0c             	mov    0xc(%eax),%eax
80105439:	83 f8 05             	cmp    $0x5,%eax
8010543c:	77 23                	ja     80105461 <procdump+0x4e>
8010543e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105441:	8b 40 0c             	mov    0xc(%eax),%eax
80105444:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010544b:	85 c0                	test   %eax,%eax
8010544d:	74 12                	je     80105461 <procdump+0x4e>
      state = states[p->state];
8010544f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105452:	8b 40 0c             	mov    0xc(%eax),%eax
80105455:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
8010545c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010545f:	eb 07                	jmp    80105468 <procdump+0x55>
    else
      state = "???";
80105461:	c7 45 ec 08 92 10 80 	movl   $0x80109208,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010546b:	8d 50 70             	lea    0x70(%eax),%edx
8010546e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105471:	8b 40 10             	mov    0x10(%eax),%eax
80105474:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105478:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010547b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010547f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105483:	c7 04 24 0c 92 10 80 	movl   $0x8010920c,(%esp)
8010548a:	e8 12 af ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
8010548f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105492:	8b 40 0c             	mov    0xc(%eax),%eax
80105495:	83 f8 02             	cmp    $0x2,%eax
80105498:	75 50                	jne    801054ea <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010549a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010549d:	8b 40 1c             	mov    0x1c(%eax),%eax
801054a0:	8b 40 0c             	mov    0xc(%eax),%eax
801054a3:	83 c0 08             	add    $0x8,%eax
801054a6:	8d 55 c4             	lea    -0x3c(%ebp),%edx
801054a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801054ad:	89 04 24             	mov    %eax,(%esp)
801054b0:	e8 73 01 00 00       	call   80105628 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801054b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801054bc:	eb 1b                	jmp    801054d9 <procdump+0xc6>
        cprintf(" %p", pc[i]);
801054be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c1:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801054c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801054c9:	c7 04 24 15 92 10 80 	movl   $0x80109215,(%esp)
801054d0:	e8 cc ae ff ff       	call   801003a1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801054d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801054d9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801054dd:	7f 0b                	jg     801054ea <procdump+0xd7>
801054df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e2:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801054e6:	85 c0                	test   %eax,%eax
801054e8:	75 d4                	jne    801054be <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801054ea:	c7 04 24 19 92 10 80 	movl   $0x80109219,(%esp)
801054f1:	e8 ab ae ff ff       	call   801003a1 <cprintf>
801054f6:	eb 01                	jmp    801054f9 <procdump+0xe6>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801054f8:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801054f9:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105500:	81 7d f0 d4 5a 11 80 	cmpl   $0x80115ad4,-0x10(%ebp)
80105507:	0f 82 18 ff ff ff    	jb     80105425 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
8010550d:	c9                   	leave  
8010550e:	c3                   	ret    
	...

80105510 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	53                   	push   %ebx
80105514:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105517:	9c                   	pushf  
80105518:	5b                   	pop    %ebx
80105519:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
8010551c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010551f:	83 c4 10             	add    $0x10,%esp
80105522:	5b                   	pop    %ebx
80105523:	5d                   	pop    %ebp
80105524:	c3                   	ret    

80105525 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105525:	55                   	push   %ebp
80105526:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105528:	fa                   	cli    
}
80105529:	5d                   	pop    %ebp
8010552a:	c3                   	ret    

8010552b <sti>:

static inline void
sti(void)
{
8010552b:	55                   	push   %ebp
8010552c:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010552e:	fb                   	sti    
}
8010552f:	5d                   	pop    %ebp
80105530:	c3                   	ret    

80105531 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105531:	55                   	push   %ebp
80105532:	89 e5                	mov    %esp,%ebp
80105534:	53                   	push   %ebx
80105535:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80105538:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010553b:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
8010553e:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105541:	89 c3                	mov    %eax,%ebx
80105543:	89 d8                	mov    %ebx,%eax
80105545:	f0 87 02             	lock xchg %eax,(%edx)
80105548:	89 c3                	mov    %eax,%ebx
8010554a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010554d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80105550:	83 c4 10             	add    $0x10,%esp
80105553:	5b                   	pop    %ebx
80105554:	5d                   	pop    %ebp
80105555:	c3                   	ret    

80105556 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105556:	55                   	push   %ebp
80105557:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105559:	8b 45 08             	mov    0x8(%ebp),%eax
8010555c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010555f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105562:	8b 45 08             	mov    0x8(%ebp),%eax
80105565:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010556b:	8b 45 08             	mov    0x8(%ebp),%eax
8010556e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105575:	5d                   	pop    %ebp
80105576:	c3                   	ret    

80105577 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105577:	55                   	push   %ebp
80105578:	89 e5                	mov    %esp,%ebp
8010557a:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010557d:	e8 3d 01 00 00       	call   801056bf <pushcli>
  if(holding(lk))
80105582:	8b 45 08             	mov    0x8(%ebp),%eax
80105585:	89 04 24             	mov    %eax,(%esp)
80105588:	e8 08 01 00 00       	call   80105695 <holding>
8010558d:	85 c0                	test   %eax,%eax
8010558f:	74 0c                	je     8010559d <acquire+0x26>
    panic("acquire");
80105591:	c7 04 24 45 92 10 80 	movl   $0x80109245,(%esp)
80105598:	e8 a0 af ff ff       	call   8010053d <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010559d:	90                   	nop
8010559e:	8b 45 08             	mov    0x8(%ebp),%eax
801055a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801055a8:	00 
801055a9:	89 04 24             	mov    %eax,(%esp)
801055ac:	e8 80 ff ff ff       	call   80105531 <xchg>
801055b1:	85 c0                	test   %eax,%eax
801055b3:	75 e9                	jne    8010559e <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801055b5:	8b 45 08             	mov    0x8(%ebp),%eax
801055b8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801055bf:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801055c2:	8b 45 08             	mov    0x8(%ebp),%eax
801055c5:	83 c0 0c             	add    $0xc,%eax
801055c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801055cc:	8d 45 08             	lea    0x8(%ebp),%eax
801055cf:	89 04 24             	mov    %eax,(%esp)
801055d2:	e8 51 00 00 00       	call   80105628 <getcallerpcs>
}
801055d7:	c9                   	leave  
801055d8:	c3                   	ret    

801055d9 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801055d9:	55                   	push   %ebp
801055da:	89 e5                	mov    %esp,%ebp
801055dc:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801055df:	8b 45 08             	mov    0x8(%ebp),%eax
801055e2:	89 04 24             	mov    %eax,(%esp)
801055e5:	e8 ab 00 00 00       	call   80105695 <holding>
801055ea:	85 c0                	test   %eax,%eax
801055ec:	75 0c                	jne    801055fa <release+0x21>
    panic("release");
801055ee:	c7 04 24 4d 92 10 80 	movl   $0x8010924d,(%esp)
801055f5:	e8 43 af ff ff       	call   8010053d <panic>

  lk->pcs[0] = 0;
801055fa:	8b 45 08             	mov    0x8(%ebp),%eax
801055fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105604:	8b 45 08             	mov    0x8(%ebp),%eax
80105607:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010560e:	8b 45 08             	mov    0x8(%ebp),%eax
80105611:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105618:	00 
80105619:	89 04 24             	mov    %eax,(%esp)
8010561c:	e8 10 ff ff ff       	call   80105531 <xchg>

  popcli();
80105621:	e8 e1 00 00 00       	call   80105707 <popcli>
}
80105626:	c9                   	leave  
80105627:	c3                   	ret    

80105628 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105628:	55                   	push   %ebp
80105629:	89 e5                	mov    %esp,%ebp
8010562b:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010562e:	8b 45 08             	mov    0x8(%ebp),%eax
80105631:	83 e8 08             	sub    $0x8,%eax
80105634:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105637:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010563e:	eb 32                	jmp    80105672 <getcallerpcs+0x4a>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105640:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105644:	74 47                	je     8010568d <getcallerpcs+0x65>
80105646:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010564d:	76 3e                	jbe    8010568d <getcallerpcs+0x65>
8010564f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105653:	74 38                	je     8010568d <getcallerpcs+0x65>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105655:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105658:	c1 e0 02             	shl    $0x2,%eax
8010565b:	03 45 0c             	add    0xc(%ebp),%eax
8010565e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105661:	8b 52 04             	mov    0x4(%edx),%edx
80105664:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
80105666:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105669:	8b 00                	mov    (%eax),%eax
8010566b:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010566e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105672:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105676:	7e c8                	jle    80105640 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105678:	eb 13                	jmp    8010568d <getcallerpcs+0x65>
    pcs[i] = 0;
8010567a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010567d:	c1 e0 02             	shl    $0x2,%eax
80105680:	03 45 0c             	add    0xc(%ebp),%eax
80105683:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105689:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010568d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105691:	7e e7                	jle    8010567a <getcallerpcs+0x52>
    pcs[i] = 0;
}
80105693:	c9                   	leave  
80105694:	c3                   	ret    

80105695 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105695:	55                   	push   %ebp
80105696:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105698:	8b 45 08             	mov    0x8(%ebp),%eax
8010569b:	8b 00                	mov    (%eax),%eax
8010569d:	85 c0                	test   %eax,%eax
8010569f:	74 17                	je     801056b8 <holding+0x23>
801056a1:	8b 45 08             	mov    0x8(%ebp),%eax
801056a4:	8b 50 08             	mov    0x8(%eax),%edx
801056a7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056ad:	39 c2                	cmp    %eax,%edx
801056af:	75 07                	jne    801056b8 <holding+0x23>
801056b1:	b8 01 00 00 00       	mov    $0x1,%eax
801056b6:	eb 05                	jmp    801056bd <holding+0x28>
801056b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056bd:	5d                   	pop    %ebp
801056be:	c3                   	ret    

801056bf <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801056bf:	55                   	push   %ebp
801056c0:	89 e5                	mov    %esp,%ebp
801056c2:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801056c5:	e8 46 fe ff ff       	call   80105510 <readeflags>
801056ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801056cd:	e8 53 fe ff ff       	call   80105525 <cli>
  if(cpu->ncli++ == 0)
801056d2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056d8:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801056de:	85 d2                	test   %edx,%edx
801056e0:	0f 94 c1             	sete   %cl
801056e3:	83 c2 01             	add    $0x1,%edx
801056e6:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801056ec:	84 c9                	test   %cl,%cl
801056ee:	74 15                	je     80105705 <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
801056f0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056f9:	81 e2 00 02 00 00    	and    $0x200,%edx
801056ff:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105705:	c9                   	leave  
80105706:	c3                   	ret    

80105707 <popcli>:

void
popcli(void)
{
80105707:	55                   	push   %ebp
80105708:	89 e5                	mov    %esp,%ebp
8010570a:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010570d:	e8 fe fd ff ff       	call   80105510 <readeflags>
80105712:	25 00 02 00 00       	and    $0x200,%eax
80105717:	85 c0                	test   %eax,%eax
80105719:	74 0c                	je     80105727 <popcli+0x20>
    panic("popcli - interruptible");
8010571b:	c7 04 24 55 92 10 80 	movl   $0x80109255,(%esp)
80105722:	e8 16 ae ff ff       	call   8010053d <panic>
  if(--cpu->ncli < 0)
80105727:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010572d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105733:	83 ea 01             	sub    $0x1,%edx
80105736:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010573c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105742:	85 c0                	test   %eax,%eax
80105744:	79 0c                	jns    80105752 <popcli+0x4b>
    panic("popcli");
80105746:	c7 04 24 6c 92 10 80 	movl   $0x8010926c,(%esp)
8010574d:	e8 eb ad ff ff       	call   8010053d <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105752:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105758:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010575e:	85 c0                	test   %eax,%eax
80105760:	75 15                	jne    80105777 <popcli+0x70>
80105762:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105768:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010576e:	85 c0                	test   %eax,%eax
80105770:	74 05                	je     80105777 <popcli+0x70>
    sti();
80105772:	e8 b4 fd ff ff       	call   8010552b <sti>
}
80105777:	c9                   	leave  
80105778:	c3                   	ret    
80105779:	00 00                	add    %al,(%eax)
	...

8010577c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010577c:	55                   	push   %ebp
8010577d:	89 e5                	mov    %esp,%ebp
8010577f:	57                   	push   %edi
80105780:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105781:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105784:	8b 55 10             	mov    0x10(%ebp),%edx
80105787:	8b 45 0c             	mov    0xc(%ebp),%eax
8010578a:	89 cb                	mov    %ecx,%ebx
8010578c:	89 df                	mov    %ebx,%edi
8010578e:	89 d1                	mov    %edx,%ecx
80105790:	fc                   	cld    
80105791:	f3 aa                	rep stos %al,%es:(%edi)
80105793:	89 ca                	mov    %ecx,%edx
80105795:	89 fb                	mov    %edi,%ebx
80105797:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010579a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010579d:	5b                   	pop    %ebx
8010579e:	5f                   	pop    %edi
8010579f:	5d                   	pop    %ebp
801057a0:	c3                   	ret    

801057a1 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801057a1:	55                   	push   %ebp
801057a2:	89 e5                	mov    %esp,%ebp
801057a4:	57                   	push   %edi
801057a5:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801057a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057a9:	8b 55 10             	mov    0x10(%ebp),%edx
801057ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801057af:	89 cb                	mov    %ecx,%ebx
801057b1:	89 df                	mov    %ebx,%edi
801057b3:	89 d1                	mov    %edx,%ecx
801057b5:	fc                   	cld    
801057b6:	f3 ab                	rep stos %eax,%es:(%edi)
801057b8:	89 ca                	mov    %ecx,%edx
801057ba:	89 fb                	mov    %edi,%ebx
801057bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057bf:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801057c2:	5b                   	pop    %ebx
801057c3:	5f                   	pop    %edi
801057c4:	5d                   	pop    %ebp
801057c5:	c3                   	ret    

801057c6 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801057c6:	55                   	push   %ebp
801057c7:	89 e5                	mov    %esp,%ebp
801057c9:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801057cc:	8b 45 08             	mov    0x8(%ebp),%eax
801057cf:	83 e0 03             	and    $0x3,%eax
801057d2:	85 c0                	test   %eax,%eax
801057d4:	75 49                	jne    8010581f <memset+0x59>
801057d6:	8b 45 10             	mov    0x10(%ebp),%eax
801057d9:	83 e0 03             	and    $0x3,%eax
801057dc:	85 c0                	test   %eax,%eax
801057de:	75 3f                	jne    8010581f <memset+0x59>
    c &= 0xFF;
801057e0:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801057e7:	8b 45 10             	mov    0x10(%ebp),%eax
801057ea:	c1 e8 02             	shr    $0x2,%eax
801057ed:	89 c2                	mov    %eax,%edx
801057ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801057f2:	89 c1                	mov    %eax,%ecx
801057f4:	c1 e1 18             	shl    $0x18,%ecx
801057f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801057fa:	c1 e0 10             	shl    $0x10,%eax
801057fd:	09 c1                	or     %eax,%ecx
801057ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105802:	c1 e0 08             	shl    $0x8,%eax
80105805:	09 c8                	or     %ecx,%eax
80105807:	0b 45 0c             	or     0xc(%ebp),%eax
8010580a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010580e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105812:	8b 45 08             	mov    0x8(%ebp),%eax
80105815:	89 04 24             	mov    %eax,(%esp)
80105818:	e8 84 ff ff ff       	call   801057a1 <stosl>
8010581d:	eb 19                	jmp    80105838 <memset+0x72>
  } else
    stosb(dst, c, n);
8010581f:	8b 45 10             	mov    0x10(%ebp),%eax
80105822:	89 44 24 08          	mov    %eax,0x8(%esp)
80105826:	8b 45 0c             	mov    0xc(%ebp),%eax
80105829:	89 44 24 04          	mov    %eax,0x4(%esp)
8010582d:	8b 45 08             	mov    0x8(%ebp),%eax
80105830:	89 04 24             	mov    %eax,(%esp)
80105833:	e8 44 ff ff ff       	call   8010577c <stosb>
  return dst;
80105838:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010583b:	c9                   	leave  
8010583c:	c3                   	ret    

8010583d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010583d:	55                   	push   %ebp
8010583e:	89 e5                	mov    %esp,%ebp
80105840:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105843:	8b 45 08             	mov    0x8(%ebp),%eax
80105846:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105849:	8b 45 0c             	mov    0xc(%ebp),%eax
8010584c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010584f:	eb 32                	jmp    80105883 <memcmp+0x46>
    if(*s1 != *s2)
80105851:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105854:	0f b6 10             	movzbl (%eax),%edx
80105857:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010585a:	0f b6 00             	movzbl (%eax),%eax
8010585d:	38 c2                	cmp    %al,%dl
8010585f:	74 1a                	je     8010587b <memcmp+0x3e>
      return *s1 - *s2;
80105861:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105864:	0f b6 00             	movzbl (%eax),%eax
80105867:	0f b6 d0             	movzbl %al,%edx
8010586a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010586d:	0f b6 00             	movzbl (%eax),%eax
80105870:	0f b6 c0             	movzbl %al,%eax
80105873:	89 d1                	mov    %edx,%ecx
80105875:	29 c1                	sub    %eax,%ecx
80105877:	89 c8                	mov    %ecx,%eax
80105879:	eb 1c                	jmp    80105897 <memcmp+0x5a>
    s1++, s2++;
8010587b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010587f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105883:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105887:	0f 95 c0             	setne  %al
8010588a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010588e:	84 c0                	test   %al,%al
80105890:	75 bf                	jne    80105851 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105892:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105897:	c9                   	leave  
80105898:	c3                   	ret    

80105899 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105899:	55                   	push   %ebp
8010589a:	89 e5                	mov    %esp,%ebp
8010589c:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010589f:	8b 45 0c             	mov    0xc(%ebp),%eax
801058a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801058a5:	8b 45 08             	mov    0x8(%ebp),%eax
801058a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801058ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058b1:	73 54                	jae    80105907 <memmove+0x6e>
801058b3:	8b 45 10             	mov    0x10(%ebp),%eax
801058b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058b9:	01 d0                	add    %edx,%eax
801058bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058be:	76 47                	jbe    80105907 <memmove+0x6e>
    s += n;
801058c0:	8b 45 10             	mov    0x10(%ebp),%eax
801058c3:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801058c6:	8b 45 10             	mov    0x10(%ebp),%eax
801058c9:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801058cc:	eb 13                	jmp    801058e1 <memmove+0x48>
      *--d = *--s;
801058ce:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801058d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801058d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d9:	0f b6 10             	movzbl (%eax),%edx
801058dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058df:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801058e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058e5:	0f 95 c0             	setne  %al
801058e8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801058ec:	84 c0                	test   %al,%al
801058ee:	75 de                	jne    801058ce <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801058f0:	eb 25                	jmp    80105917 <memmove+0x7e>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801058f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058f5:	0f b6 10             	movzbl (%eax),%edx
801058f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058fb:	88 10                	mov    %dl,(%eax)
801058fd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105901:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105905:	eb 01                	jmp    80105908 <memmove+0x6f>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105907:	90                   	nop
80105908:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010590c:	0f 95 c0             	setne  %al
8010590f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105913:	84 c0                	test   %al,%al
80105915:	75 db                	jne    801058f2 <memmove+0x59>
      *d++ = *s++;

  return dst;
80105917:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010591a:	c9                   	leave  
8010591b:	c3                   	ret    

8010591c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010591c:	55                   	push   %ebp
8010591d:	89 e5                	mov    %esp,%ebp
8010591f:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105922:	8b 45 10             	mov    0x10(%ebp),%eax
80105925:	89 44 24 08          	mov    %eax,0x8(%esp)
80105929:	8b 45 0c             	mov    0xc(%ebp),%eax
8010592c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105930:	8b 45 08             	mov    0x8(%ebp),%eax
80105933:	89 04 24             	mov    %eax,(%esp)
80105936:	e8 5e ff ff ff       	call   80105899 <memmove>
}
8010593b:	c9                   	leave  
8010593c:	c3                   	ret    

8010593d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010593d:	55                   	push   %ebp
8010593e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105940:	eb 0c                	jmp    8010594e <strncmp+0x11>
    n--, p++, q++;
80105942:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105946:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010594a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010594e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105952:	74 1a                	je     8010596e <strncmp+0x31>
80105954:	8b 45 08             	mov    0x8(%ebp),%eax
80105957:	0f b6 00             	movzbl (%eax),%eax
8010595a:	84 c0                	test   %al,%al
8010595c:	74 10                	je     8010596e <strncmp+0x31>
8010595e:	8b 45 08             	mov    0x8(%ebp),%eax
80105961:	0f b6 10             	movzbl (%eax),%edx
80105964:	8b 45 0c             	mov    0xc(%ebp),%eax
80105967:	0f b6 00             	movzbl (%eax),%eax
8010596a:	38 c2                	cmp    %al,%dl
8010596c:	74 d4                	je     80105942 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010596e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105972:	75 07                	jne    8010597b <strncmp+0x3e>
    return 0;
80105974:	b8 00 00 00 00       	mov    $0x0,%eax
80105979:	eb 18                	jmp    80105993 <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
8010597b:	8b 45 08             	mov    0x8(%ebp),%eax
8010597e:	0f b6 00             	movzbl (%eax),%eax
80105981:	0f b6 d0             	movzbl %al,%edx
80105984:	8b 45 0c             	mov    0xc(%ebp),%eax
80105987:	0f b6 00             	movzbl (%eax),%eax
8010598a:	0f b6 c0             	movzbl %al,%eax
8010598d:	89 d1                	mov    %edx,%ecx
8010598f:	29 c1                	sub    %eax,%ecx
80105991:	89 c8                	mov    %ecx,%eax
}
80105993:	5d                   	pop    %ebp
80105994:	c3                   	ret    

80105995 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105995:	55                   	push   %ebp
80105996:	89 e5                	mov    %esp,%ebp
80105998:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010599b:	8b 45 08             	mov    0x8(%ebp),%eax
8010599e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801059a1:	90                   	nop
801059a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059a6:	0f 9f c0             	setg   %al
801059a9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801059ad:	84 c0                	test   %al,%al
801059af:	74 30                	je     801059e1 <strncpy+0x4c>
801059b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801059b4:	0f b6 10             	movzbl (%eax),%edx
801059b7:	8b 45 08             	mov    0x8(%ebp),%eax
801059ba:	88 10                	mov    %dl,(%eax)
801059bc:	8b 45 08             	mov    0x8(%ebp),%eax
801059bf:	0f b6 00             	movzbl (%eax),%eax
801059c2:	84 c0                	test   %al,%al
801059c4:	0f 95 c0             	setne  %al
801059c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801059cb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801059cf:	84 c0                	test   %al,%al
801059d1:	75 cf                	jne    801059a2 <strncpy+0xd>
    ;
  while(n-- > 0)
801059d3:	eb 0c                	jmp    801059e1 <strncpy+0x4c>
    *s++ = 0;
801059d5:	8b 45 08             	mov    0x8(%ebp),%eax
801059d8:	c6 00 00             	movb   $0x0,(%eax)
801059db:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801059df:	eb 01                	jmp    801059e2 <strncpy+0x4d>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801059e1:	90                   	nop
801059e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059e6:	0f 9f c0             	setg   %al
801059e9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801059ed:	84 c0                	test   %al,%al
801059ef:	75 e4                	jne    801059d5 <strncpy+0x40>
    *s++ = 0;
  return os;
801059f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059f4:	c9                   	leave  
801059f5:	c3                   	ret    

801059f6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801059f6:	55                   	push   %ebp
801059f7:	89 e5                	mov    %esp,%ebp
801059f9:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801059fc:	8b 45 08             	mov    0x8(%ebp),%eax
801059ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105a02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a06:	7f 05                	jg     80105a0d <safestrcpy+0x17>
    return os;
80105a08:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a0b:	eb 35                	jmp    80105a42 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80105a0d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105a11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a15:	7e 22                	jle    80105a39 <safestrcpy+0x43>
80105a17:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a1a:	0f b6 10             	movzbl (%eax),%edx
80105a1d:	8b 45 08             	mov    0x8(%ebp),%eax
80105a20:	88 10                	mov    %dl,(%eax)
80105a22:	8b 45 08             	mov    0x8(%ebp),%eax
80105a25:	0f b6 00             	movzbl (%eax),%eax
80105a28:	84 c0                	test   %al,%al
80105a2a:	0f 95 c0             	setne  %al
80105a2d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105a31:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105a35:	84 c0                	test   %al,%al
80105a37:	75 d4                	jne    80105a0d <safestrcpy+0x17>
    ;
  *s = 0;
80105a39:	8b 45 08             	mov    0x8(%ebp),%eax
80105a3c:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a42:	c9                   	leave  
80105a43:	c3                   	ret    

80105a44 <strlen>:

int
strlen(const char *s)
{
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105a4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a51:	eb 04                	jmp    80105a57 <strlen+0x13>
80105a53:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a5a:	03 45 08             	add    0x8(%ebp),%eax
80105a5d:	0f b6 00             	movzbl (%eax),%eax
80105a60:	84 c0                	test   %al,%al
80105a62:	75 ef                	jne    80105a53 <strlen+0xf>
    ;
  return n;
80105a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a67:	c9                   	leave  
80105a68:	c3                   	ret    
80105a69:	00 00                	add    %al,(%eax)
	...

80105a6c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105a6c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105a70:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105a74:	55                   	push   %ebp
  pushl %ebx
80105a75:	53                   	push   %ebx
  pushl %esi
80105a76:	56                   	push   %esi
  pushl %edi
80105a77:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105a78:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105a7a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105a7c:	5f                   	pop    %edi
  popl %esi
80105a7d:	5e                   	pop    %esi
  popl %ebx
80105a7e:	5b                   	pop    %ebx
  popl %ebp
80105a7f:	5d                   	pop    %ebp
  ret
80105a80:	c3                   	ret    
80105a81:	00 00                	add    %al,(%eax)
	...

80105a84 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
80105a84:	55                   	push   %ebp
80105a85:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
80105a87:	8b 45 08             	mov    0x8(%ebp),%eax
80105a8a:	8b 00                	mov    (%eax),%eax
80105a8c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105a8f:	76 0f                	jbe    80105aa0 <fetchint+0x1c>
80105a91:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a94:	8d 50 04             	lea    0x4(%eax),%edx
80105a97:	8b 45 08             	mov    0x8(%ebp),%eax
80105a9a:	8b 00                	mov    (%eax),%eax
80105a9c:	39 c2                	cmp    %eax,%edx
80105a9e:	76 07                	jbe    80105aa7 <fetchint+0x23>
    return -1;
80105aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa5:	eb 0f                	jmp    80105ab6 <fetchint+0x32>
  *ip = *(int*)(addr);
80105aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aaa:	8b 10                	mov    (%eax),%edx
80105aac:	8b 45 10             	mov    0x10(%ebp),%eax
80105aaf:	89 10                	mov    %edx,(%eax)
  return 0;
80105ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ab6:	5d                   	pop    %ebp
80105ab7:	c3                   	ret    

80105ab8 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
80105ab8:	55                   	push   %ebp
80105ab9:	89 e5                	mov    %esp,%ebp
80105abb:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= p->sz)
80105abe:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac1:	8b 00                	mov    (%eax),%eax
80105ac3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105ac6:	77 07                	ja     80105acf <fetchstr+0x17>
    return -1;
80105ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105acd:	eb 45                	jmp    80105b14 <fetchstr+0x5c>
  *pp = (char*)addr;
80105acf:	8b 55 0c             	mov    0xc(%ebp),%edx
80105ad2:	8b 45 10             	mov    0x10(%ebp),%eax
80105ad5:	89 10                	mov    %edx,(%eax)
  ep = (char*)p->sz;
80105ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80105ada:	8b 00                	mov    (%eax),%eax
80105adc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105adf:	8b 45 10             	mov    0x10(%ebp),%eax
80105ae2:	8b 00                	mov    (%eax),%eax
80105ae4:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105ae7:	eb 1e                	jmp    80105b07 <fetchstr+0x4f>
    if(*s == 0)
80105ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aec:	0f b6 00             	movzbl (%eax),%eax
80105aef:	84 c0                	test   %al,%al
80105af1:	75 10                	jne    80105b03 <fetchstr+0x4b>
      return s - *pp;
80105af3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105af6:	8b 45 10             	mov    0x10(%ebp),%eax
80105af9:	8b 00                	mov    (%eax),%eax
80105afb:	89 d1                	mov    %edx,%ecx
80105afd:	29 c1                	sub    %eax,%ecx
80105aff:	89 c8                	mov    %ecx,%eax
80105b01:	eb 11                	jmp    80105b14 <fetchstr+0x5c>

  if(addr >= p->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)p->sz;
  for(s = *pp; s < ep; s++)
80105b03:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b07:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b0a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105b0d:	72 da                	jb     80105ae9 <fetchstr+0x31>
    if(*s == 0)
      return s - *pp;
  return -1;
80105b0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b14:	c9                   	leave  
80105b15:	c3                   	ret    

80105b16 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b16:	55                   	push   %ebp
80105b17:	89 e5                	mov    %esp,%ebp
80105b19:	83 ec 0c             	sub    $0xc,%esp
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
80105b1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b22:	8b 40 18             	mov    0x18(%eax),%eax
80105b25:	8b 50 44             	mov    0x44(%eax),%edx
80105b28:	8b 45 08             	mov    0x8(%ebp),%eax
80105b2b:	c1 e0 02             	shl    $0x2,%eax
80105b2e:	01 d0                	add    %edx,%eax
80105b30:	8d 48 04             	lea    0x4(%eax),%ecx
80105b33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b39:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b3c:	89 54 24 08          	mov    %edx,0x8(%esp)
80105b40:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80105b44:	89 04 24             	mov    %eax,(%esp)
80105b47:	e8 38 ff ff ff       	call   80105a84 <fetchint>
}
80105b4c:	c9                   	leave  
80105b4d:	c3                   	ret    

80105b4e <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b4e:	55                   	push   %ebp
80105b4f:	89 e5                	mov    %esp,%ebp
80105b51:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105b54:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b57:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80105b5e:	89 04 24             	mov    %eax,(%esp)
80105b61:	e8 b0 ff ff ff       	call   80105b16 <argint>
80105b66:	85 c0                	test   %eax,%eax
80105b68:	79 07                	jns    80105b71 <argptr+0x23>
    return -1;
80105b6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6f:	eb 3d                	jmp    80105bae <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105b71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b74:	89 c2                	mov    %eax,%edx
80105b76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b7c:	8b 00                	mov    (%eax),%eax
80105b7e:	39 c2                	cmp    %eax,%edx
80105b80:	73 16                	jae    80105b98 <argptr+0x4a>
80105b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b85:	89 c2                	mov    %eax,%edx
80105b87:	8b 45 10             	mov    0x10(%ebp),%eax
80105b8a:	01 c2                	add    %eax,%edx
80105b8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b92:	8b 00                	mov    (%eax),%eax
80105b94:	39 c2                	cmp    %eax,%edx
80105b96:	76 07                	jbe    80105b9f <argptr+0x51>
    return -1;
80105b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9d:	eb 0f                	jmp    80105bae <argptr+0x60>
  *pp = (char*)i;
80105b9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ba2:	89 c2                	mov    %eax,%edx
80105ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ba7:	89 10                	mov    %edx,(%eax)
  return 0;
80105ba9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bae:	c9                   	leave  
80105baf:	c3                   	ret    

80105bb0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105bb6:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105bb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bbd:	8b 45 08             	mov    0x8(%ebp),%eax
80105bc0:	89 04 24             	mov    %eax,(%esp)
80105bc3:	e8 4e ff ff ff       	call   80105b16 <argint>
80105bc8:	85 c0                	test   %eax,%eax
80105bca:	79 07                	jns    80105bd3 <argstr+0x23>
    return -1;
80105bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd1:	eb 1e                	jmp    80105bf1 <argstr+0x41>
  return fetchstr(proc, addr, pp);
80105bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bd6:	89 c2                	mov    %eax,%edx
80105bd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105be1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105be5:	89 54 24 04          	mov    %edx,0x4(%esp)
80105be9:	89 04 24             	mov    %eax,(%esp)
80105bec:	e8 c7 fe ff ff       	call   80105ab8 <fetchstr>
}
80105bf1:	c9                   	leave  
80105bf2:	c3                   	ret    

80105bf3 <syscall>:
[SYS_binary_semaphore_up] sys_binary_semaphore_up,
};

void
syscall(void)
{
80105bf3:	55                   	push   %ebp
80105bf4:	89 e5                	mov    %esp,%ebp
80105bf6:	53                   	push   %ebx
80105bf7:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105bfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c00:	8b 40 18             	mov    0x18(%eax),%eax
80105c03:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num >= 0 && num < SYS_open && syscalls[num]) {
80105c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c0d:	78 2e                	js     80105c3d <syscall+0x4a>
80105c0f:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105c13:	7f 28                	jg     80105c3d <syscall+0x4a>
80105c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c18:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c1f:	85 c0                	test   %eax,%eax
80105c21:	74 1a                	je     80105c3d <syscall+0x4a>
    proc->tf->eax = syscalls[num]();
80105c23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c29:	8b 58 18             	mov    0x18(%eax),%ebx
80105c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c2f:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c36:	ff d0                	call   *%eax
80105c38:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105c3b:	eb 73                	jmp    80105cb0 <syscall+0xbd>
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
80105c3d:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105c41:	7e 30                	jle    80105c73 <syscall+0x80>
80105c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c46:	83 f8 1d             	cmp    $0x1d,%eax
80105c49:	77 28                	ja     80105c73 <syscall+0x80>
80105c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4e:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c55:	85 c0                	test   %eax,%eax
80105c57:	74 1a                	je     80105c73 <syscall+0x80>
    proc->tf->eax = syscalls[num]();
80105c59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c5f:	8b 58 18             	mov    0x18(%eax),%ebx
80105c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c65:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c6c:	ff d0                	call   *%eax
80105c6e:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105c71:	eb 3d                	jmp    80105cb0 <syscall+0xbd>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105c73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c79:	8d 48 70             	lea    0x70(%eax),%ecx
80105c7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(num >= 0 && num < SYS_open && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105c82:	8b 40 10             	mov    0x10(%eax),%eax
80105c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c88:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105c8c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105c90:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c94:	c7 04 24 73 92 10 80 	movl   $0x80109273,(%esp)
80105c9b:	e8 01 a7 ff ff       	call   801003a1 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105ca0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ca6:	8b 40 18             	mov    0x18(%eax),%eax
80105ca9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105cb0:	83 c4 24             	add    $0x24,%esp
80105cb3:	5b                   	pop    %ebx
80105cb4:	5d                   	pop    %ebp
80105cb5:	c3                   	ret    
	...

80105cb8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105cb8:	55                   	push   %ebp
80105cb9:	89 e5                	mov    %esp,%ebp
80105cbb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105cbe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cc5:	8b 45 08             	mov    0x8(%ebp),%eax
80105cc8:	89 04 24             	mov    %eax,(%esp)
80105ccb:	e8 46 fe ff ff       	call   80105b16 <argint>
80105cd0:	85 c0                	test   %eax,%eax
80105cd2:	79 07                	jns    80105cdb <argfd+0x23>
    return -1;
80105cd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd9:	eb 50                	jmp    80105d2b <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cde:	85 c0                	test   %eax,%eax
80105ce0:	78 21                	js     80105d03 <argfd+0x4b>
80105ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce5:	83 f8 0f             	cmp    $0xf,%eax
80105ce8:	7f 19                	jg     80105d03 <argfd+0x4b>
80105cea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cf0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105cf3:	83 c2 08             	add    $0x8,%edx
80105cf6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d01:	75 07                	jne    80105d0a <argfd+0x52>
    return -1;
80105d03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d08:	eb 21                	jmp    80105d2b <argfd+0x73>
  if(pfd)
80105d0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105d0e:	74 08                	je     80105d18 <argfd+0x60>
    *pfd = fd;
80105d10:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d13:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d16:	89 10                	mov    %edx,(%eax)
  if(pf)
80105d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105d1c:	74 08                	je     80105d26 <argfd+0x6e>
    *pf = f;
80105d1e:	8b 45 10             	mov    0x10(%ebp),%eax
80105d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d24:	89 10                	mov    %edx,(%eax)
  return 0;
80105d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d2b:	c9                   	leave  
80105d2c:	c3                   	ret    

80105d2d <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105d2d:	55                   	push   %ebp
80105d2e:	89 e5                	mov    %esp,%ebp
80105d30:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105d33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105d3a:	eb 30                	jmp    80105d6c <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105d3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d42:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d45:	83 c2 08             	add    $0x8,%edx
80105d48:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d4c:	85 c0                	test   %eax,%eax
80105d4e:	75 18                	jne    80105d68 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105d50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d56:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d59:	8d 4a 08             	lea    0x8(%edx),%ecx
80105d5c:	8b 55 08             	mov    0x8(%ebp),%edx
80105d5f:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105d63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d66:	eb 0f                	jmp    80105d77 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105d68:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105d6c:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105d70:	7e ca                	jle    80105d3c <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105d72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d77:	c9                   	leave  
80105d78:	c3                   	ret    

80105d79 <sys_dup>:

int
sys_dup(void)
{
80105d79:	55                   	push   %ebp
80105d7a:	89 e5                	mov    %esp,%ebp
80105d7c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105d7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d82:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d8d:	00 
80105d8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d95:	e8 1e ff ff ff       	call   80105cb8 <argfd>
80105d9a:	85 c0                	test   %eax,%eax
80105d9c:	79 07                	jns    80105da5 <sys_dup+0x2c>
    return -1;
80105d9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da3:	eb 29                	jmp    80105dce <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da8:	89 04 24             	mov    %eax,(%esp)
80105dab:	e8 7d ff ff ff       	call   80105d2d <fdalloc>
80105db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105db7:	79 07                	jns    80105dc0 <sys_dup+0x47>
    return -1;
80105db9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dbe:	eb 0e                	jmp    80105dce <sys_dup+0x55>
  filedup(f);
80105dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc3:	89 04 24             	mov    %eax,(%esp)
80105dc6:	e8 b1 b1 ff ff       	call   80100f7c <filedup>
  return fd;
80105dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105dce:	c9                   	leave  
80105dcf:	c3                   	ret    

80105dd0 <sys_read>:

int
sys_read(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105dd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dd9:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ddd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105de4:	00 
80105de5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105dec:	e8 c7 fe ff ff       	call   80105cb8 <argfd>
80105df1:	85 c0                	test   %eax,%eax
80105df3:	78 35                	js     80105e2a <sys_read+0x5a>
80105df5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105df8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dfc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e03:	e8 0e fd ff ff       	call   80105b16 <argint>
80105e08:	85 c0                	test   %eax,%eax
80105e0a:	78 1e                	js     80105e2a <sys_read+0x5a>
80105e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e13:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e16:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e21:	e8 28 fd ff ff       	call   80105b4e <argptr>
80105e26:	85 c0                	test   %eax,%eax
80105e28:	79 07                	jns    80105e31 <sys_read+0x61>
    return -1;
80105e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2f:	eb 19                	jmp    80105e4a <sys_read+0x7a>
  return fileread(f, p, n);
80105e31:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e34:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e3a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105e3e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e42:	89 04 24             	mov    %eax,(%esp)
80105e45:	e8 9f b2 ff ff       	call   801010e9 <fileread>
}
80105e4a:	c9                   	leave  
80105e4b:	c3                   	ret    

80105e4c <sys_write>:

int
sys_write(void)
{
80105e4c:	55                   	push   %ebp
80105e4d:	89 e5                	mov    %esp,%ebp
80105e4f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e55:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e60:	00 
80105e61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e68:	e8 4b fe ff ff       	call   80105cb8 <argfd>
80105e6d:	85 c0                	test   %eax,%eax
80105e6f:	78 35                	js     80105ea6 <sys_write+0x5a>
80105e71:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e74:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e78:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e7f:	e8 92 fc ff ff       	call   80105b16 <argint>
80105e84:	85 c0                	test   %eax,%eax
80105e86:	78 1e                	js     80105ea6 <sys_write+0x5a>
80105e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e8b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e8f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e92:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e9d:	e8 ac fc ff ff       	call   80105b4e <argptr>
80105ea2:	85 c0                	test   %eax,%eax
80105ea4:	79 07                	jns    80105ead <sys_write+0x61>
    return -1;
80105ea6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eab:	eb 19                	jmp    80105ec6 <sys_write+0x7a>
  return filewrite(f, p, n);
80105ead:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105eb0:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105eba:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ebe:	89 04 24             	mov    %eax,(%esp)
80105ec1:	e8 df b2 ff ff       	call   801011a5 <filewrite>
}
80105ec6:	c9                   	leave  
80105ec7:	c3                   	ret    

80105ec8 <sys_close>:

int
sys_close(void)
{
80105ec8:	55                   	push   %ebp
80105ec9:	89 e5                	mov    %esp,%ebp
80105ecb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105ece:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ed1:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105edc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ee3:	e8 d0 fd ff ff       	call   80105cb8 <argfd>
80105ee8:	85 c0                	test   %eax,%eax
80105eea:	79 07                	jns    80105ef3 <sys_close+0x2b>
    return -1;
80105eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef1:	eb 24                	jmp    80105f17 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105ef3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105efc:	83 c2 08             	add    $0x8,%edx
80105eff:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105f06:	00 
  fileclose(f);
80105f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0a:	89 04 24             	mov    %eax,(%esp)
80105f0d:	e8 b2 b0 ff ff       	call   80100fc4 <fileclose>
  return 0;
80105f12:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f17:	c9                   	leave  
80105f18:	c3                   	ret    

80105f19 <sys_fstat>:

int
sys_fstat(void)
{
80105f19:	55                   	push   %ebp
80105f1a:	89 e5                	mov    %esp,%ebp
80105f1c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105f1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f22:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f26:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f2d:	00 
80105f2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f35:	e8 7e fd ff ff       	call   80105cb8 <argfd>
80105f3a:	85 c0                	test   %eax,%eax
80105f3c:	78 1f                	js     80105f5d <sys_fstat+0x44>
80105f3e:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105f45:	00 
80105f46:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f49:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f54:	e8 f5 fb ff ff       	call   80105b4e <argptr>
80105f59:	85 c0                	test   %eax,%eax
80105f5b:	79 07                	jns    80105f64 <sys_fstat+0x4b>
    return -1;
80105f5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f62:	eb 12                	jmp    80105f76 <sys_fstat+0x5d>
  return filestat(f, st);
80105f64:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f6a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f6e:	89 04 24             	mov    %eax,(%esp)
80105f71:	e8 24 b1 ff ff       	call   8010109a <filestat>
}
80105f76:	c9                   	leave  
80105f77:	c3                   	ret    

80105f78 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105f78:	55                   	push   %ebp
80105f79:	89 e5                	mov    %esp,%ebp
80105f7b:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105f7e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f81:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f8c:	e8 1f fc ff ff       	call   80105bb0 <argstr>
80105f91:	85 c0                	test   %eax,%eax
80105f93:	78 17                	js     80105fac <sys_link+0x34>
80105f95:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105f98:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105fa3:	e8 08 fc ff ff       	call   80105bb0 <argstr>
80105fa8:	85 c0                	test   %eax,%eax
80105faa:	79 0a                	jns    80105fb6 <sys_link+0x3e>
    return -1;
80105fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb1:	e9 3c 01 00 00       	jmp    801060f2 <sys_link+0x17a>
  if((ip = namei(old)) == 0)
80105fb6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105fb9:	89 04 24             	mov    %eax,(%esp)
80105fbc:	e8 49 c4 ff ff       	call   8010240a <namei>
80105fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fc8:	75 0a                	jne    80105fd4 <sys_link+0x5c>
    return -1;
80105fca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fcf:	e9 1e 01 00 00       	jmp    801060f2 <sys_link+0x17a>

  begin_trans();
80105fd4:	e8 44 d2 ff ff       	call   8010321d <begin_trans>

  ilock(ip);
80105fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fdc:	89 04 24             	mov    %eax,(%esp)
80105fdf:	e8 84 b8 ff ff       	call   80101868 <ilock>
  if(ip->type == T_DIR){
80105fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105feb:	66 83 f8 01          	cmp    $0x1,%ax
80105fef:	75 1a                	jne    8010600b <sys_link+0x93>
    iunlockput(ip);
80105ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff4:	89 04 24             	mov    %eax,(%esp)
80105ff7:	e8 f0 ba ff ff       	call   80101aec <iunlockput>
    commit_trans();
80105ffc:	e8 65 d2 ff ff       	call   80103266 <commit_trans>
    return -1;
80106001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106006:	e9 e7 00 00 00       	jmp    801060f2 <sys_link+0x17a>
  }

  ip->nlink++;
8010600b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010600e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106012:	8d 50 01             	lea    0x1(%eax),%edx
80106015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106018:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010601c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010601f:	89 04 24             	mov    %eax,(%esp)
80106022:	e8 85 b6 ff ff       	call   801016ac <iupdate>
  iunlock(ip);
80106027:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010602a:	89 04 24             	mov    %eax,(%esp)
8010602d:	e8 84 b9 ff ff       	call   801019b6 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80106032:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106035:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106038:	89 54 24 04          	mov    %edx,0x4(%esp)
8010603c:	89 04 24             	mov    %eax,(%esp)
8010603f:	e8 e8 c3 ff ff       	call   8010242c <nameiparent>
80106044:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106047:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010604b:	74 68                	je     801060b5 <sys_link+0x13d>
    goto bad;
  ilock(dp);
8010604d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106050:	89 04 24             	mov    %eax,(%esp)
80106053:	e8 10 b8 ff ff       	call   80101868 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106058:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010605b:	8b 10                	mov    (%eax),%edx
8010605d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106060:	8b 00                	mov    (%eax),%eax
80106062:	39 c2                	cmp    %eax,%edx
80106064:	75 20                	jne    80106086 <sys_link+0x10e>
80106066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106069:	8b 40 04             	mov    0x4(%eax),%eax
8010606c:	89 44 24 08          	mov    %eax,0x8(%esp)
80106070:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106073:	89 44 24 04          	mov    %eax,0x4(%esp)
80106077:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010607a:	89 04 24             	mov    %eax,(%esp)
8010607d:	e8 c7 c0 ff ff       	call   80102149 <dirlink>
80106082:	85 c0                	test   %eax,%eax
80106084:	79 0d                	jns    80106093 <sys_link+0x11b>
    iunlockput(dp);
80106086:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106089:	89 04 24             	mov    %eax,(%esp)
8010608c:	e8 5b ba ff ff       	call   80101aec <iunlockput>
    goto bad;
80106091:	eb 23                	jmp    801060b6 <sys_link+0x13e>
  }
  iunlockput(dp);
80106093:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106096:	89 04 24             	mov    %eax,(%esp)
80106099:	e8 4e ba ff ff       	call   80101aec <iunlockput>
  iput(ip);
8010609e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a1:	89 04 24             	mov    %eax,(%esp)
801060a4:	e8 72 b9 ff ff       	call   80101a1b <iput>

  commit_trans();
801060a9:	e8 b8 d1 ff ff       	call   80103266 <commit_trans>

  return 0;
801060ae:	b8 00 00 00 00       	mov    $0x0,%eax
801060b3:	eb 3d                	jmp    801060f2 <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801060b5:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
801060b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b9:	89 04 24             	mov    %eax,(%esp)
801060bc:	e8 a7 b7 ff ff       	call   80101868 <ilock>
  ip->nlink--;
801060c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060c8:	8d 50 ff             	lea    -0x1(%eax),%edx
801060cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ce:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801060d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d5:	89 04 24             	mov    %eax,(%esp)
801060d8:	e8 cf b5 ff ff       	call   801016ac <iupdate>
  iunlockput(ip);
801060dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e0:	89 04 24             	mov    %eax,(%esp)
801060e3:	e8 04 ba ff ff       	call   80101aec <iunlockput>
  commit_trans();
801060e8:	e8 79 d1 ff ff       	call   80103266 <commit_trans>
  return -1;
801060ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060f2:	c9                   	leave  
801060f3:	c3                   	ret    

801060f4 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801060fa:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106101:	eb 4b                	jmp    8010614e <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106106:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010610d:	00 
8010610e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106112:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106115:	89 44 24 04          	mov    %eax,0x4(%esp)
80106119:	8b 45 08             	mov    0x8(%ebp),%eax
8010611c:	89 04 24             	mov    %eax,(%esp)
8010611f:	e8 3a bc ff ff       	call   80101d5e <readi>
80106124:	83 f8 10             	cmp    $0x10,%eax
80106127:	74 0c                	je     80106135 <isdirempty+0x41>
      panic("isdirempty: readi");
80106129:	c7 04 24 8f 92 10 80 	movl   $0x8010928f,(%esp)
80106130:	e8 08 a4 ff ff       	call   8010053d <panic>
    if(de.inum != 0)
80106135:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106139:	66 85 c0             	test   %ax,%ax
8010613c:	74 07                	je     80106145 <isdirempty+0x51>
      return 0;
8010613e:	b8 00 00 00 00       	mov    $0x0,%eax
80106143:	eb 1b                	jmp    80106160 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106148:	83 c0 10             	add    $0x10,%eax
8010614b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010614e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106151:	8b 45 08             	mov    0x8(%ebp),%eax
80106154:	8b 40 18             	mov    0x18(%eax),%eax
80106157:	39 c2                	cmp    %eax,%edx
80106159:	72 a8                	jb     80106103 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010615b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106160:	c9                   	leave  
80106161:	c3                   	ret    

80106162 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106162:	55                   	push   %ebp
80106163:	89 e5                	mov    %esp,%ebp
80106165:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106168:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010616b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010616f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106176:	e8 35 fa ff ff       	call   80105bb0 <argstr>
8010617b:	85 c0                	test   %eax,%eax
8010617d:	79 0a                	jns    80106189 <sys_unlink+0x27>
    return -1;
8010617f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106184:	e9 aa 01 00 00       	jmp    80106333 <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80106189:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010618c:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010618f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106193:	89 04 24             	mov    %eax,(%esp)
80106196:	e8 91 c2 ff ff       	call   8010242c <nameiparent>
8010619b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010619e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061a2:	75 0a                	jne    801061ae <sys_unlink+0x4c>
    return -1;
801061a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061a9:	e9 85 01 00 00       	jmp    80106333 <sys_unlink+0x1d1>

  begin_trans();
801061ae:	e8 6a d0 ff ff       	call   8010321d <begin_trans>

  ilock(dp);
801061b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b6:	89 04 24             	mov    %eax,(%esp)
801061b9:	e8 aa b6 ff ff       	call   80101868 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801061be:	c7 44 24 04 a1 92 10 	movl   $0x801092a1,0x4(%esp)
801061c5:	80 
801061c6:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801061c9:	89 04 24             	mov    %eax,(%esp)
801061cc:	e8 8e be ff ff       	call   8010205f <namecmp>
801061d1:	85 c0                	test   %eax,%eax
801061d3:	0f 84 45 01 00 00    	je     8010631e <sys_unlink+0x1bc>
801061d9:	c7 44 24 04 a3 92 10 	movl   $0x801092a3,0x4(%esp)
801061e0:	80 
801061e1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801061e4:	89 04 24             	mov    %eax,(%esp)
801061e7:	e8 73 be ff ff       	call   8010205f <namecmp>
801061ec:	85 c0                	test   %eax,%eax
801061ee:	0f 84 2a 01 00 00    	je     8010631e <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801061f4:	8d 45 c8             	lea    -0x38(%ebp),%eax
801061f7:	89 44 24 08          	mov    %eax,0x8(%esp)
801061fb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801061fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106205:	89 04 24             	mov    %eax,(%esp)
80106208:	e8 74 be ff ff       	call   80102081 <dirlookup>
8010620d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106210:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106214:	0f 84 03 01 00 00    	je     8010631d <sys_unlink+0x1bb>
    goto bad;
  ilock(ip);
8010621a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010621d:	89 04 24             	mov    %eax,(%esp)
80106220:	e8 43 b6 ff ff       	call   80101868 <ilock>

  if(ip->nlink < 1)
80106225:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106228:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010622c:	66 85 c0             	test   %ax,%ax
8010622f:	7f 0c                	jg     8010623d <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
80106231:	c7 04 24 a6 92 10 80 	movl   $0x801092a6,(%esp)
80106238:	e8 00 a3 ff ff       	call   8010053d <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010623d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106240:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106244:	66 83 f8 01          	cmp    $0x1,%ax
80106248:	75 1f                	jne    80106269 <sys_unlink+0x107>
8010624a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010624d:	89 04 24             	mov    %eax,(%esp)
80106250:	e8 9f fe ff ff       	call   801060f4 <isdirempty>
80106255:	85 c0                	test   %eax,%eax
80106257:	75 10                	jne    80106269 <sys_unlink+0x107>
    iunlockput(ip);
80106259:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625c:	89 04 24             	mov    %eax,(%esp)
8010625f:	e8 88 b8 ff ff       	call   80101aec <iunlockput>
    goto bad;
80106264:	e9 b5 00 00 00       	jmp    8010631e <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80106269:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80106270:	00 
80106271:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106278:	00 
80106279:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010627c:	89 04 24             	mov    %eax,(%esp)
8010627f:	e8 42 f5 ff ff       	call   801057c6 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106284:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106287:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010628e:	00 
8010628f:	89 44 24 08          	mov    %eax,0x8(%esp)
80106293:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106296:	89 44 24 04          	mov    %eax,0x4(%esp)
8010629a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010629d:	89 04 24             	mov    %eax,(%esp)
801062a0:	e8 24 bc ff ff       	call   80101ec9 <writei>
801062a5:	83 f8 10             	cmp    $0x10,%eax
801062a8:	74 0c                	je     801062b6 <sys_unlink+0x154>
    panic("unlink: writei");
801062aa:	c7 04 24 b8 92 10 80 	movl   $0x801092b8,(%esp)
801062b1:	e8 87 a2 ff ff       	call   8010053d <panic>
  if(ip->type == T_DIR){
801062b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062b9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062bd:	66 83 f8 01          	cmp    $0x1,%ax
801062c1:	75 1c                	jne    801062df <sys_unlink+0x17d>
    dp->nlink--;
801062c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801062ca:	8d 50 ff             	lea    -0x1(%eax),%edx
801062cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d0:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801062d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d7:	89 04 24             	mov    %eax,(%esp)
801062da:	e8 cd b3 ff ff       	call   801016ac <iupdate>
  }
  iunlockput(dp);
801062df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e2:	89 04 24             	mov    %eax,(%esp)
801062e5:	e8 02 b8 ff ff       	call   80101aec <iunlockput>

  ip->nlink--;
801062ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ed:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801062f1:	8d 50 ff             	lea    -0x1(%eax),%edx
801062f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f7:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801062fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062fe:	89 04 24             	mov    %eax,(%esp)
80106301:	e8 a6 b3 ff ff       	call   801016ac <iupdate>
  iunlockput(ip);
80106306:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106309:	89 04 24             	mov    %eax,(%esp)
8010630c:	e8 db b7 ff ff       	call   80101aec <iunlockput>

  commit_trans();
80106311:	e8 50 cf ff ff       	call   80103266 <commit_trans>

  return 0;
80106316:	b8 00 00 00 00       	mov    $0x0,%eax
8010631b:	eb 16                	jmp    80106333 <sys_unlink+0x1d1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
8010631d:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
8010631e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106321:	89 04 24             	mov    %eax,(%esp)
80106324:	e8 c3 b7 ff ff       	call   80101aec <iunlockput>
  commit_trans();
80106329:	e8 38 cf ff ff       	call   80103266 <commit_trans>
  return -1;
8010632e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106333:	c9                   	leave  
80106334:	c3                   	ret    

80106335 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106335:	55                   	push   %ebp
80106336:	89 e5                	mov    %esp,%ebp
80106338:	83 ec 48             	sub    $0x48,%esp
8010633b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010633e:	8b 55 10             	mov    0x10(%ebp),%edx
80106341:	8b 45 14             	mov    0x14(%ebp),%eax
80106344:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106348:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010634c:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106350:	8d 45 de             	lea    -0x22(%ebp),%eax
80106353:	89 44 24 04          	mov    %eax,0x4(%esp)
80106357:	8b 45 08             	mov    0x8(%ebp),%eax
8010635a:	89 04 24             	mov    %eax,(%esp)
8010635d:	e8 ca c0 ff ff       	call   8010242c <nameiparent>
80106362:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106369:	75 0a                	jne    80106375 <create+0x40>
    return 0;
8010636b:	b8 00 00 00 00       	mov    $0x0,%eax
80106370:	e9 7e 01 00 00       	jmp    801064f3 <create+0x1be>
  ilock(dp);
80106375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106378:	89 04 24             	mov    %eax,(%esp)
8010637b:	e8 e8 b4 ff ff       	call   80101868 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80106380:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106383:	89 44 24 08          	mov    %eax,0x8(%esp)
80106387:	8d 45 de             	lea    -0x22(%ebp),%eax
8010638a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010638e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106391:	89 04 24             	mov    %eax,(%esp)
80106394:	e8 e8 bc ff ff       	call   80102081 <dirlookup>
80106399:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010639c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063a0:	74 47                	je     801063e9 <create+0xb4>
    iunlockput(dp);
801063a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a5:	89 04 24             	mov    %eax,(%esp)
801063a8:	e8 3f b7 ff ff       	call   80101aec <iunlockput>
    ilock(ip);
801063ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b0:	89 04 24             	mov    %eax,(%esp)
801063b3:	e8 b0 b4 ff ff       	call   80101868 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801063b8:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801063bd:	75 15                	jne    801063d4 <create+0x9f>
801063bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063c6:	66 83 f8 02          	cmp    $0x2,%ax
801063ca:	75 08                	jne    801063d4 <create+0x9f>
      return ip;
801063cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063cf:	e9 1f 01 00 00       	jmp    801064f3 <create+0x1be>
    iunlockput(ip);
801063d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d7:	89 04 24             	mov    %eax,(%esp)
801063da:	e8 0d b7 ff ff       	call   80101aec <iunlockput>
    return 0;
801063df:	b8 00 00 00 00       	mov    $0x0,%eax
801063e4:	e9 0a 01 00 00       	jmp    801064f3 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801063e9:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801063ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f0:	8b 00                	mov    (%eax),%eax
801063f2:	89 54 24 04          	mov    %edx,0x4(%esp)
801063f6:	89 04 24             	mov    %eax,(%esp)
801063f9:	e8 d1 b1 ff ff       	call   801015cf <ialloc>
801063fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106401:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106405:	75 0c                	jne    80106413 <create+0xde>
    panic("create: ialloc");
80106407:	c7 04 24 c7 92 10 80 	movl   $0x801092c7,(%esp)
8010640e:	e8 2a a1 ff ff       	call   8010053d <panic>

  ilock(ip);
80106413:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106416:	89 04 24             	mov    %eax,(%esp)
80106419:	e8 4a b4 ff ff       	call   80101868 <ilock>
  ip->major = major;
8010641e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106421:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106425:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010642c:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106430:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106434:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106437:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010643d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106440:	89 04 24             	mov    %eax,(%esp)
80106443:	e8 64 b2 ff ff       	call   801016ac <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106448:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010644d:	75 6a                	jne    801064b9 <create+0x184>
    dp->nlink++;  // for ".."
8010644f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106452:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106456:	8d 50 01             	lea    0x1(%eax),%edx
80106459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010645c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106460:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106463:	89 04 24             	mov    %eax,(%esp)
80106466:	e8 41 b2 ff ff       	call   801016ac <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010646b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010646e:	8b 40 04             	mov    0x4(%eax),%eax
80106471:	89 44 24 08          	mov    %eax,0x8(%esp)
80106475:	c7 44 24 04 a1 92 10 	movl   $0x801092a1,0x4(%esp)
8010647c:	80 
8010647d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106480:	89 04 24             	mov    %eax,(%esp)
80106483:	e8 c1 bc ff ff       	call   80102149 <dirlink>
80106488:	85 c0                	test   %eax,%eax
8010648a:	78 21                	js     801064ad <create+0x178>
8010648c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010648f:	8b 40 04             	mov    0x4(%eax),%eax
80106492:	89 44 24 08          	mov    %eax,0x8(%esp)
80106496:	c7 44 24 04 a3 92 10 	movl   $0x801092a3,0x4(%esp)
8010649d:	80 
8010649e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064a1:	89 04 24             	mov    %eax,(%esp)
801064a4:	e8 a0 bc ff ff       	call   80102149 <dirlink>
801064a9:	85 c0                	test   %eax,%eax
801064ab:	79 0c                	jns    801064b9 <create+0x184>
      panic("create dots");
801064ad:	c7 04 24 d6 92 10 80 	movl   $0x801092d6,(%esp)
801064b4:	e8 84 a0 ff ff       	call   8010053d <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801064b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064bc:	8b 40 04             	mov    0x4(%eax),%eax
801064bf:	89 44 24 08          	mov    %eax,0x8(%esp)
801064c3:	8d 45 de             	lea    -0x22(%ebp),%eax
801064c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801064ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064cd:	89 04 24             	mov    %eax,(%esp)
801064d0:	e8 74 bc ff ff       	call   80102149 <dirlink>
801064d5:	85 c0                	test   %eax,%eax
801064d7:	79 0c                	jns    801064e5 <create+0x1b0>
    panic("create: dirlink");
801064d9:	c7 04 24 e2 92 10 80 	movl   $0x801092e2,(%esp)
801064e0:	e8 58 a0 ff ff       	call   8010053d <panic>

  iunlockput(dp);
801064e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e8:	89 04 24             	mov    %eax,(%esp)
801064eb:	e8 fc b5 ff ff       	call   80101aec <iunlockput>

  return ip;
801064f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801064f3:	c9                   	leave  
801064f4:	c3                   	ret    

801064f5 <sys_open>:

int
sys_open(void)
{
801064f5:	55                   	push   %ebp
801064f6:	89 e5                	mov    %esp,%ebp
801064f8:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801064fb:	8d 45 e8             	lea    -0x18(%ebp),%eax
801064fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106502:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106509:	e8 a2 f6 ff ff       	call   80105bb0 <argstr>
8010650e:	85 c0                	test   %eax,%eax
80106510:	78 17                	js     80106529 <sys_open+0x34>
80106512:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106515:	89 44 24 04          	mov    %eax,0x4(%esp)
80106519:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106520:	e8 f1 f5 ff ff       	call   80105b16 <argint>
80106525:	85 c0                	test   %eax,%eax
80106527:	79 0a                	jns    80106533 <sys_open+0x3e>
    return -1;
80106529:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010652e:	e9 46 01 00 00       	jmp    80106679 <sys_open+0x184>
  if(omode & O_CREATE){
80106533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106536:	25 00 02 00 00       	and    $0x200,%eax
8010653b:	85 c0                	test   %eax,%eax
8010653d:	74 40                	je     8010657f <sys_open+0x8a>
    begin_trans();
8010653f:	e8 d9 cc ff ff       	call   8010321d <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80106544:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106547:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010654e:	00 
8010654f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106556:	00 
80106557:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010655e:	00 
8010655f:	89 04 24             	mov    %eax,(%esp)
80106562:	e8 ce fd ff ff       	call   80106335 <create>
80106567:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
8010656a:	e8 f7 cc ff ff       	call   80103266 <commit_trans>
    if(ip == 0)
8010656f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106573:	75 5c                	jne    801065d1 <sys_open+0xdc>
      return -1;
80106575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010657a:	e9 fa 00 00 00       	jmp    80106679 <sys_open+0x184>
  } else {
    if((ip = namei(path)) == 0)
8010657f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106582:	89 04 24             	mov    %eax,(%esp)
80106585:	e8 80 be ff ff       	call   8010240a <namei>
8010658a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010658d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106591:	75 0a                	jne    8010659d <sys_open+0xa8>
      return -1;
80106593:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106598:	e9 dc 00 00 00       	jmp    80106679 <sys_open+0x184>
    ilock(ip);
8010659d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a0:	89 04 24             	mov    %eax,(%esp)
801065a3:	e8 c0 b2 ff ff       	call   80101868 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801065a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ab:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801065af:	66 83 f8 01          	cmp    $0x1,%ax
801065b3:	75 1c                	jne    801065d1 <sys_open+0xdc>
801065b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065b8:	85 c0                	test   %eax,%eax
801065ba:	74 15                	je     801065d1 <sys_open+0xdc>
      iunlockput(ip);
801065bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065bf:	89 04 24             	mov    %eax,(%esp)
801065c2:	e8 25 b5 ff ff       	call   80101aec <iunlockput>
      return -1;
801065c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065cc:	e9 a8 00 00 00       	jmp    80106679 <sys_open+0x184>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801065d1:	e8 46 a9 ff ff       	call   80100f1c <filealloc>
801065d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801065d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801065dd:	74 14                	je     801065f3 <sys_open+0xfe>
801065df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065e2:	89 04 24             	mov    %eax,(%esp)
801065e5:	e8 43 f7 ff ff       	call   80105d2d <fdalloc>
801065ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
801065ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801065f1:	79 23                	jns    80106616 <sys_open+0x121>
    if(f)
801065f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801065f7:	74 0b                	je     80106604 <sys_open+0x10f>
      fileclose(f);
801065f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065fc:	89 04 24             	mov    %eax,(%esp)
801065ff:	e8 c0 a9 ff ff       	call   80100fc4 <fileclose>
    iunlockput(ip);
80106604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106607:	89 04 24             	mov    %eax,(%esp)
8010660a:	e8 dd b4 ff ff       	call   80101aec <iunlockput>
    return -1;
8010660f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106614:	eb 63                	jmp    80106679 <sys_open+0x184>
  }
  iunlock(ip);
80106616:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106619:	89 04 24             	mov    %eax,(%esp)
8010661c:	e8 95 b3 ff ff       	call   801019b6 <iunlock>

  f->type = FD_INODE;
80106621:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106624:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010662a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010662d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106630:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106633:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106636:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010663d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106640:	83 e0 01             	and    $0x1,%eax
80106643:	85 c0                	test   %eax,%eax
80106645:	0f 94 c2             	sete   %dl
80106648:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010664b:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010664e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106651:	83 e0 01             	and    $0x1,%eax
80106654:	84 c0                	test   %al,%al
80106656:	75 0a                	jne    80106662 <sys_open+0x16d>
80106658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010665b:	83 e0 02             	and    $0x2,%eax
8010665e:	85 c0                	test   %eax,%eax
80106660:	74 07                	je     80106669 <sys_open+0x174>
80106662:	b8 01 00 00 00       	mov    $0x1,%eax
80106667:	eb 05                	jmp    8010666e <sys_open+0x179>
80106669:	b8 00 00 00 00       	mov    $0x0,%eax
8010666e:	89 c2                	mov    %eax,%edx
80106670:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106673:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106676:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106679:	c9                   	leave  
8010667a:	c3                   	ret    

8010667b <sys_mkdir>:

int
sys_mkdir(void)
{
8010667b:	55                   	push   %ebp
8010667c:	89 e5                	mov    %esp,%ebp
8010667e:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80106681:	e8 97 cb ff ff       	call   8010321d <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106686:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106689:	89 44 24 04          	mov    %eax,0x4(%esp)
8010668d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106694:	e8 17 f5 ff ff       	call   80105bb0 <argstr>
80106699:	85 c0                	test   %eax,%eax
8010669b:	78 2c                	js     801066c9 <sys_mkdir+0x4e>
8010669d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066a0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801066a7:	00 
801066a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801066af:	00 
801066b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801066b7:	00 
801066b8:	89 04 24             	mov    %eax,(%esp)
801066bb:	e8 75 fc ff ff       	call   80106335 <create>
801066c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066c7:	75 0c                	jne    801066d5 <sys_mkdir+0x5a>
    commit_trans();
801066c9:	e8 98 cb ff ff       	call   80103266 <commit_trans>
    return -1;
801066ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066d3:	eb 15                	jmp    801066ea <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801066d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d8:	89 04 24             	mov    %eax,(%esp)
801066db:	e8 0c b4 ff ff       	call   80101aec <iunlockput>
  commit_trans();
801066e0:	e8 81 cb ff ff       	call   80103266 <commit_trans>
  return 0;
801066e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066ea:	c9                   	leave  
801066eb:	c3                   	ret    

801066ec <sys_mknod>:

int
sys_mknod(void)
{
801066ec:	55                   	push   %ebp
801066ed:	89 e5                	mov    %esp,%ebp
801066ef:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
801066f2:	e8 26 cb ff ff       	call   8010321d <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
801066f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801066fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801066fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106705:	e8 a6 f4 ff ff       	call   80105bb0 <argstr>
8010670a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010670d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106711:	78 5e                	js     80106771 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106713:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106716:	89 44 24 04          	mov    %eax,0x4(%esp)
8010671a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106721:	e8 f0 f3 ff ff       	call   80105b16 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80106726:	85 c0                	test   %eax,%eax
80106728:	78 47                	js     80106771 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010672a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010672d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106731:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106738:	e8 d9 f3 ff ff       	call   80105b16 <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010673d:	85 c0                	test   %eax,%eax
8010673f:	78 30                	js     80106771 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106744:	0f bf c8             	movswl %ax,%ecx
80106747:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010674a:	0f bf d0             	movswl %ax,%edx
8010674d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106750:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106754:	89 54 24 08          	mov    %edx,0x8(%esp)
80106758:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010675f:	00 
80106760:	89 04 24             	mov    %eax,(%esp)
80106763:	e8 cd fb ff ff       	call   80106335 <create>
80106768:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010676b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010676f:	75 0c                	jne    8010677d <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80106771:	e8 f0 ca ff ff       	call   80103266 <commit_trans>
    return -1;
80106776:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010677b:	eb 15                	jmp    80106792 <sys_mknod+0xa6>
  }
  iunlockput(ip);
8010677d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106780:	89 04 24             	mov    %eax,(%esp)
80106783:	e8 64 b3 ff ff       	call   80101aec <iunlockput>
  commit_trans();
80106788:	e8 d9 ca ff ff       	call   80103266 <commit_trans>
  return 0;
8010678d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106792:	c9                   	leave  
80106793:	c3                   	ret    

80106794 <sys_chdir>:

int
sys_chdir(void)
{
80106794:	55                   	push   %ebp
80106795:	89 e5                	mov    %esp,%ebp
80106797:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
8010679a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010679d:	89 44 24 04          	mov    %eax,0x4(%esp)
801067a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067a8:	e8 03 f4 ff ff       	call   80105bb0 <argstr>
801067ad:	85 c0                	test   %eax,%eax
801067af:	78 14                	js     801067c5 <sys_chdir+0x31>
801067b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067b4:	89 04 24             	mov    %eax,(%esp)
801067b7:	e8 4e bc ff ff       	call   8010240a <namei>
801067bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067c3:	75 07                	jne    801067cc <sys_chdir+0x38>
    return -1;
801067c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067ca:	eb 57                	jmp    80106823 <sys_chdir+0x8f>
  ilock(ip);
801067cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067cf:	89 04 24             	mov    %eax,(%esp)
801067d2:	e8 91 b0 ff ff       	call   80101868 <ilock>
  if(ip->type != T_DIR){
801067d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067da:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801067de:	66 83 f8 01          	cmp    $0x1,%ax
801067e2:	74 12                	je     801067f6 <sys_chdir+0x62>
    iunlockput(ip);
801067e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067e7:	89 04 24             	mov    %eax,(%esp)
801067ea:	e8 fd b2 ff ff       	call   80101aec <iunlockput>
    return -1;
801067ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067f4:	eb 2d                	jmp    80106823 <sys_chdir+0x8f>
  }
  iunlock(ip);
801067f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067f9:	89 04 24             	mov    %eax,(%esp)
801067fc:	e8 b5 b1 ff ff       	call   801019b6 <iunlock>
  iput(proc->cwd);
80106801:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106807:	8b 40 6c             	mov    0x6c(%eax),%eax
8010680a:	89 04 24             	mov    %eax,(%esp)
8010680d:	e8 09 b2 ff ff       	call   80101a1b <iput>
  proc->cwd = ip;
80106812:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106818:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010681b:	89 50 6c             	mov    %edx,0x6c(%eax)
  return 0;
8010681e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106823:	c9                   	leave  
80106824:	c3                   	ret    

80106825 <sys_exec>:

int
sys_exec(void)
{
80106825:	55                   	push   %ebp
80106826:	89 e5                	mov    %esp,%ebp
80106828:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010682e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106831:	89 44 24 04          	mov    %eax,0x4(%esp)
80106835:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010683c:	e8 6f f3 ff ff       	call   80105bb0 <argstr>
80106841:	85 c0                	test   %eax,%eax
80106843:	78 1a                	js     8010685f <sys_exec+0x3a>
80106845:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010684b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010684f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106856:	e8 bb f2 ff ff       	call   80105b16 <argint>
8010685b:	85 c0                	test   %eax,%eax
8010685d:	79 0a                	jns    80106869 <sys_exec+0x44>
    return -1;
8010685f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106864:	e9 e2 00 00 00       	jmp    8010694b <sys_exec+0x126>
  }
  memset(argv, 0, sizeof(argv));
80106869:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106870:	00 
80106871:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106878:	00 
80106879:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010687f:	89 04 24             	mov    %eax,(%esp)
80106882:	e8 3f ef ff ff       	call   801057c6 <memset>
  for(i=0;; i++){
80106887:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010688e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106891:	83 f8 1f             	cmp    $0x1f,%eax
80106894:	76 0a                	jbe    801068a0 <sys_exec+0x7b>
      return -1;
80106896:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010689b:	e9 ab 00 00 00       	jmp    8010694b <sys_exec+0x126>
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
801068a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a3:	c1 e0 02             	shl    $0x2,%eax
801068a6:	89 c2                	mov    %eax,%edx
801068a8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801068ae:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801068b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068b7:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
801068bd:	89 54 24 08          	mov    %edx,0x8(%esp)
801068c1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801068c5:	89 04 24             	mov    %eax,(%esp)
801068c8:	e8 b7 f1 ff ff       	call   80105a84 <fetchint>
801068cd:	85 c0                	test   %eax,%eax
801068cf:	79 07                	jns    801068d8 <sys_exec+0xb3>
      return -1;
801068d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d6:	eb 73                	jmp    8010694b <sys_exec+0x126>
    if(uarg == 0){
801068d8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801068de:	85 c0                	test   %eax,%eax
801068e0:	75 26                	jne    80106908 <sys_exec+0xe3>
      argv[i] = 0;
801068e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068e5:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801068ec:	00 00 00 00 
      break;
801068f0:	90                   	nop
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801068f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068f4:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801068fa:	89 54 24 04          	mov    %edx,0x4(%esp)
801068fe:	89 04 24             	mov    %eax,(%esp)
80106901:	e8 f6 a1 ff ff       	call   80100afc <exec>
80106906:	eb 43                	jmp    8010694b <sys_exec+0x126>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
80106908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010690b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106912:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106918:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
8010691b:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80106921:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106927:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010692b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010692f:	89 04 24             	mov    %eax,(%esp)
80106932:	e8 81 f1 ff ff       	call   80105ab8 <fetchstr>
80106937:	85 c0                	test   %eax,%eax
80106939:	79 07                	jns    80106942 <sys_exec+0x11d>
      return -1;
8010693b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106940:	eb 09                	jmp    8010694b <sys_exec+0x126>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106942:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
80106946:	e9 43 ff ff ff       	jmp    8010688e <sys_exec+0x69>
  return exec(path, argv);
}
8010694b:	c9                   	leave  
8010694c:	c3                   	ret    

8010694d <sys_pipe>:

int
sys_pipe(void)
{
8010694d:	55                   	push   %ebp
8010694e:	89 e5                	mov    %esp,%ebp
80106950:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106953:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010695a:	00 
8010695b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010695e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106962:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106969:	e8 e0 f1 ff ff       	call   80105b4e <argptr>
8010696e:	85 c0                	test   %eax,%eax
80106970:	79 0a                	jns    8010697c <sys_pipe+0x2f>
    return -1;
80106972:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106977:	e9 9b 00 00 00       	jmp    80106a17 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
8010697c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010697f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106983:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106986:	89 04 24             	mov    %eax,(%esp)
80106989:	e8 aa d2 ff ff       	call   80103c38 <pipealloc>
8010698e:	85 c0                	test   %eax,%eax
80106990:	79 07                	jns    80106999 <sys_pipe+0x4c>
    return -1;
80106992:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106997:	eb 7e                	jmp    80106a17 <sys_pipe+0xca>
  fd0 = -1;
80106999:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801069a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801069a3:	89 04 24             	mov    %eax,(%esp)
801069a6:	e8 82 f3 ff ff       	call   80105d2d <fdalloc>
801069ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069b2:	78 14                	js     801069c8 <sys_pipe+0x7b>
801069b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069b7:	89 04 24             	mov    %eax,(%esp)
801069ba:	e8 6e f3 ff ff       	call   80105d2d <fdalloc>
801069bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801069c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801069c6:	79 37                	jns    801069ff <sys_pipe+0xb2>
    if(fd0 >= 0)
801069c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069cc:	78 14                	js     801069e2 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801069ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069d7:	83 c2 08             	add    $0x8,%edx
801069da:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801069e1:	00 
    fileclose(rf);
801069e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801069e5:	89 04 24             	mov    %eax,(%esp)
801069e8:	e8 d7 a5 ff ff       	call   80100fc4 <fileclose>
    fileclose(wf);
801069ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069f0:	89 04 24             	mov    %eax,(%esp)
801069f3:	e8 cc a5 ff ff       	call   80100fc4 <fileclose>
    return -1;
801069f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069fd:	eb 18                	jmp    80106a17 <sys_pipe+0xca>
  }
  fd[0] = fd0;
801069ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a05:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a0a:	8d 50 04             	lea    0x4(%eax),%edx
80106a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a10:	89 02                	mov    %eax,(%edx)
  return 0;
80106a12:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a17:	c9                   	leave  
80106a18:	c3                   	ret    
80106a19:	00 00                	add    %al,(%eax)
	...

80106a1c <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106a1c:	55                   	push   %ebp
80106a1d:	89 e5                	mov    %esp,%ebp
80106a1f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106a22:	e8 19 d9 ff ff       	call   80104340 <fork>
}
80106a27:	c9                   	leave  
80106a28:	c3                   	ret    

80106a29 <sys_exit>:

int
sys_exit(void)
{
80106a29:	55                   	push   %ebp
80106a2a:	89 e5                	mov    %esp,%ebp
80106a2c:	83 ec 08             	sub    $0x8,%esp
  exit();
80106a2f:	e8 a8 e2 ff ff       	call   80104cdc <exit>
  return 0;  // not reached
80106a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a39:	c9                   	leave  
80106a3a:	c3                   	ret    

80106a3b <sys_wait>:

int
sys_wait(void)
{
80106a3b:	55                   	push   %ebp
80106a3c:	89 e5                	mov    %esp,%ebp
80106a3e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106a41:	e8 84 e4 ff ff       	call   80104eca <wait>
}
80106a46:	c9                   	leave  
80106a47:	c3                   	ret    

80106a48 <sys_kill>:

int
sys_kill(void)
{
80106a48:	55                   	push   %ebp
80106a49:	89 e5                	mov    %esp,%ebp
80106a4b:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106a4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a51:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a5c:	e8 b5 f0 ff ff       	call   80105b16 <argint>
80106a61:	85 c0                	test   %eax,%eax
80106a63:	79 07                	jns    80106a6c <sys_kill+0x24>
    return -1;
80106a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a6a:	eb 0b                	jmp    80106a77 <sys_kill+0x2f>
  return kill(pid);
80106a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a6f:	89 04 24             	mov    %eax,(%esp)
80106a72:	e8 21 e9 ff ff       	call   80105398 <kill>
}
80106a77:	c9                   	leave  
80106a78:	c3                   	ret    

80106a79 <sys_getpid>:

int
sys_getpid(void)
{
80106a79:	55                   	push   %ebp
80106a7a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106a7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a82:	8b 40 10             	mov    0x10(%eax),%eax
}
80106a85:	5d                   	pop    %ebp
80106a86:	c3                   	ret    

80106a87 <sys_sbrk>:

int
sys_sbrk(void)
{
80106a87:	55                   	push   %ebp
80106a88:	89 e5                	mov    %esp,%ebp
80106a8a:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106a8d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a90:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a9b:	e8 76 f0 ff ff       	call   80105b16 <argint>
80106aa0:	85 c0                	test   %eax,%eax
80106aa2:	79 07                	jns    80106aab <sys_sbrk+0x24>
    return -1;
80106aa4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aa9:	eb 24                	jmp    80106acf <sys_sbrk+0x48>
  addr = proc->sz;
80106aab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ab1:	8b 00                	mov    (%eax),%eax
80106ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ab9:	89 04 24             	mov    %eax,(%esp)
80106abc:	e8 da d7 ff ff       	call   8010429b <growproc>
80106ac1:	85 c0                	test   %eax,%eax
80106ac3:	79 07                	jns    80106acc <sys_sbrk+0x45>
    return -1;
80106ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aca:	eb 03                	jmp    80106acf <sys_sbrk+0x48>
  return addr;
80106acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106acf:	c9                   	leave  
80106ad0:	c3                   	ret    

80106ad1 <sys_sleep>:

int
sys_sleep(void)
{
80106ad1:	55                   	push   %ebp
80106ad2:	89 e5                	mov    %esp,%ebp
80106ad4:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106ad7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ada:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ade:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ae5:	e8 2c f0 ff ff       	call   80105b16 <argint>
80106aea:	85 c0                	test   %eax,%eax
80106aec:	79 07                	jns    80106af5 <sys_sleep+0x24>
    return -1;
80106aee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106af3:	eb 6c                	jmp    80106b61 <sys_sleep+0x90>
  acquire(&tickslock);
80106af5:	c7 04 24 e0 5a 11 80 	movl   $0x80115ae0,(%esp)
80106afc:	e8 76 ea ff ff       	call   80105577 <acquire>
  ticks0 = ticks;
80106b01:	a1 20 63 11 80       	mov    0x80116320,%eax
80106b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106b09:	eb 34                	jmp    80106b3f <sys_sleep+0x6e>
    if(proc->killed){
80106b0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b11:	8b 40 24             	mov    0x24(%eax),%eax
80106b14:	85 c0                	test   %eax,%eax
80106b16:	74 13                	je     80106b2b <sys_sleep+0x5a>
      release(&tickslock);
80106b18:	c7 04 24 e0 5a 11 80 	movl   $0x80115ae0,(%esp)
80106b1f:	e8 b5 ea ff ff       	call   801055d9 <release>
      return -1;
80106b24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b29:	eb 36                	jmp    80106b61 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106b2b:	c7 44 24 04 e0 5a 11 	movl   $0x80115ae0,0x4(%esp)
80106b32:	80 
80106b33:	c7 04 24 20 63 11 80 	movl   $0x80116320,(%esp)
80106b3a:	e8 52 e7 ff ff       	call   80105291 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106b3f:	a1 20 63 11 80       	mov    0x80116320,%eax
80106b44:	89 c2                	mov    %eax,%edx
80106b46:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b4c:	39 c2                	cmp    %eax,%edx
80106b4e:	72 bb                	jb     80106b0b <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106b50:	c7 04 24 e0 5a 11 80 	movl   $0x80115ae0,(%esp)
80106b57:	e8 7d ea ff ff       	call   801055d9 <release>
  return 0;
80106b5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b61:	c9                   	leave  
80106b62:	c3                   	ret    

80106b63 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106b63:	55                   	push   %ebp
80106b64:	89 e5                	mov    %esp,%ebp
80106b66:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106b69:	c7 04 24 e0 5a 11 80 	movl   $0x80115ae0,(%esp)
80106b70:	e8 02 ea ff ff       	call   80105577 <acquire>
  xticks = ticks;
80106b75:	a1 20 63 11 80       	mov    0x80116320,%eax
80106b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106b7d:	c7 04 24 e0 5a 11 80 	movl   $0x80115ae0,(%esp)
80106b84:	e8 50 ea ff ff       	call   801055d9 <release>
  return xticks;
80106b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106b8c:	c9                   	leave  
80106b8d:	c3                   	ret    

80106b8e <sys_thread_create>:

int
sys_thread_create(void)
{
80106b8e:	55                   	push   %ebp
80106b8f:	89 e5                	mov    %esp,%ebp
80106b91:	83 ec 28             	sub    $0x28,%esp
  char* start_func;
  char* stack;
  int stack_size;
  argptr(0,&start_func,sizeof(start_func));
80106b94:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106b9b:	00 
80106b9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ba3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106baa:	e8 9f ef ff ff       	call   80105b4e <argptr>
  argptr(1,&stack,sizeof(stack));
80106baf:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106bb6:	00 
80106bb7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bba:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bbe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106bc5:	e8 84 ef ff ff       	call   80105b4e <argptr>
  argint(2,&stack_size);
80106bca:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bd1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106bd8:	e8 39 ef ff ff       	call   80105b16 <argint>
  return thread_create((void*(*)())start_func,(void*)stack,(uint)stack_size);
80106bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106be0:	89 c1                	mov    %eax,%ecx
80106be2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106be8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106bec:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bf0:	89 04 24             	mov    %eax,(%esp)
80106bf3:	e8 c5 d8 ff ff       	call   801044bd <thread_create>
}
80106bf8:	c9                   	leave  
80106bf9:	c3                   	ret    

80106bfa <sys_thread_getId>:

int
sys_thread_getId(void)
{
80106bfa:	55                   	push   %ebp
80106bfb:	89 e5                	mov    %esp,%ebp
80106bfd:	83 ec 08             	sub    $0x8,%esp
    return thread_getId();
80106c00:	e8 74 da ff ff       	call   80104679 <thread_getId>
}
80106c05:	c9                   	leave  
80106c06:	c3                   	ret    

80106c07 <sys_thread_getProcId>:

int
sys_thread_getProcId(void)
{
80106c07:	55                   	push   %ebp
80106c08:	89 e5                	mov    %esp,%ebp
80106c0a:	83 ec 08             	sub    $0x8,%esp
    return thread_getProcId();
80106c0d:	e8 b5 da ff ff       	call   801046c7 <thread_getProcId>
}
80106c12:	c9                   	leave  
80106c13:	c3                   	ret    

80106c14 <sys_thread_join>:

int
sys_thread_join(void)
{
80106c14:	55                   	push   %ebp
80106c15:	89 e5                	mov    %esp,%ebp
80106c17:	83 ec 28             	sub    $0x28,%esp
  int thread_id;  
  char* ret_val;
  argint(0,&thread_id);
80106c1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c28:	e8 e9 ee ff ff       	call   80105b16 <argint>
  argptr(1,&ret_val,sizeof(ret_val));
80106c2d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106c34:	00 
80106c35:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c38:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106c43:	e8 06 ef ff ff       	call   80105b4e <argptr>
  return thread_join(thread_id,(void**)&ret_val);
80106c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c4b:	8d 55 f0             	lea    -0x10(%ebp),%edx
80106c4e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106c52:	89 04 24             	mov    %eax,(%esp)
80106c55:	e8 9b da ff ff       	call   801046f5 <thread_join>
}
80106c5a:	c9                   	leave  
80106c5b:	c3                   	ret    

80106c5c <sys_thread_exit>:

int
sys_thread_exit(void)
{
80106c5c:	55                   	push   %ebp
80106c5d:	89 e5                	mov    %esp,%ebp
80106c5f:	83 ec 28             	sub    $0x28,%esp
    char* ret_val;
    argptr(0,&ret_val,sizeof(ret_val));
80106c62:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106c69:	00 
80106c6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c78:	e8 d1 ee ff ff       	call   80105b4e <argptr>
    thread_exit((void*)ret_val);
80106c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c80:	89 04 24             	mov    %eax,(%esp)
80106c83:	e8 f3 db ff ff       	call   8010487b <thread_exit>
    return 0; // not reached
80106c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c8d:	c9                   	leave  
80106c8e:	c3                   	ret    

80106c8f <sys_binary_semaphore_create>:

int 
sys_binary_semaphore_create(void){
80106c8f:	55                   	push   %ebp
80106c90:	89 e5                	mov    %esp,%ebp
80106c92:	83 ec 28             	sub    $0x28,%esp
  int initial_value;
  argint(0,&initial_value);
80106c95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c98:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c9c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ca3:	e8 6e ee ff ff       	call   80105b16 <argint>
  return binary_semaphore_create(initial_value);
80106ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cab:	89 04 24             	mov    %eax,(%esp)
80106cae:	e8 fe dc ff ff       	call   801049b1 <binary_semaphore_create>
}
80106cb3:	c9                   	leave  
80106cb4:	c3                   	ret    

80106cb5 <sys_binary_semaphore_down>:

int 
sys_binary_semaphore_down(void){
80106cb5:	55                   	push   %ebp
80106cb6:	89 e5                	mov    %esp,%ebp
80106cb8:	83 ec 28             	sub    $0x28,%esp
   int binary_semaphore_ID;
  argint(0,&binary_semaphore_ID);
80106cbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106cc9:	e8 48 ee ff ff       	call   80105b16 <argint>
  return binary_semaphore_down(binary_semaphore_ID);
80106cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd1:	89 04 24             	mov    %eax,(%esp)
80106cd4:	e8 96 dd ff ff       	call   80104a6f <binary_semaphore_down>
}
80106cd9:	c9                   	leave  
80106cda:	c3                   	ret    

80106cdb <sys_binary_semaphore_up>:
int 
sys_binary_semaphore_up(void){
80106cdb:	55                   	push   %ebp
80106cdc:	89 e5                	mov    %esp,%ebp
80106cde:	83 ec 28             	sub    $0x28,%esp
   int binary_semaphore_ID;
  argint(0,&binary_semaphore_ID);
80106ce1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ce8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106cef:	e8 22 ee ff ff       	call   80105b16 <argint>
  return binary_semaphore_up(binary_semaphore_ID);
80106cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cf7:	89 04 24             	mov    %eax,(%esp)
80106cfa:	e8 ab de ff ff       	call   80104baa <binary_semaphore_up>
}
80106cff:	c9                   	leave  
80106d00:	c3                   	ret    
80106d01:	00 00                	add    %al,(%eax)
	...

80106d04 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106d04:	55                   	push   %ebp
80106d05:	89 e5                	mov    %esp,%ebp
80106d07:	83 ec 08             	sub    $0x8,%esp
80106d0a:	8b 55 08             	mov    0x8(%ebp),%edx
80106d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d10:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106d14:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d17:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106d1b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106d1f:	ee                   	out    %al,(%dx)
}
80106d20:	c9                   	leave  
80106d21:	c3                   	ret    

80106d22 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106d22:	55                   	push   %ebp
80106d23:	89 e5                	mov    %esp,%ebp
80106d25:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106d28:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106d2f:	00 
80106d30:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106d37:	e8 c8 ff ff ff       	call   80106d04 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106d3c:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106d43:	00 
80106d44:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106d4b:	e8 b4 ff ff ff       	call   80106d04 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106d50:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106d57:	00 
80106d58:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106d5f:	e8 a0 ff ff ff       	call   80106d04 <outb>
  picenable(IRQ_TIMER);
80106d64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d6b:	e8 51 cd ff ff       	call   80103ac1 <picenable>
}
80106d70:	c9                   	leave  
80106d71:	c3                   	ret    
	...

80106d74 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106d74:	1e                   	push   %ds
  pushl %es
80106d75:	06                   	push   %es
  pushl %fs
80106d76:	0f a0                	push   %fs
  pushl %gs
80106d78:	0f a8                	push   %gs
  pushal
80106d7a:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106d7b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106d7f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106d81:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106d83:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106d87:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106d89:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106d8b:	54                   	push   %esp
  call trap
80106d8c:	e8 de 01 00 00       	call   80106f6f <trap>
  addl $4, %esp
80106d91:	83 c4 04             	add    $0x4,%esp

80106d94 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106d94:	61                   	popa   
  popl %gs
80106d95:	0f a9                	pop    %gs
  popl %fs
80106d97:	0f a1                	pop    %fs
  popl %es
80106d99:	07                   	pop    %es
  popl %ds
80106d9a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106d9b:	83 c4 08             	add    $0x8,%esp
  iret
80106d9e:	cf                   	iret   
	...

80106da0 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106da6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106da9:	83 e8 01             	sub    $0x1,%eax
80106dac:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106db0:	8b 45 08             	mov    0x8(%ebp),%eax
80106db3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106db7:	8b 45 08             	mov    0x8(%ebp),%eax
80106dba:	c1 e8 10             	shr    $0x10,%eax
80106dbd:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106dc1:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106dc4:	0f 01 18             	lidtl  (%eax)
}
80106dc7:	c9                   	leave  
80106dc8:	c3                   	ret    

80106dc9 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106dc9:	55                   	push   %ebp
80106dca:	89 e5                	mov    %esp,%ebp
80106dcc:	53                   	push   %ebx
80106dcd:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106dd0:	0f 20 d3             	mov    %cr2,%ebx
80106dd3:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106dd9:	83 c4 10             	add    $0x10,%esp
80106ddc:	5b                   	pop    %ebx
80106ddd:	5d                   	pop    %ebp
80106dde:	c3                   	ret    

80106ddf <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106ddf:	55                   	push   %ebp
80106de0:	89 e5                	mov    %esp,%ebp
80106de2:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106de5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106dec:	e9 c3 00 00 00       	jmp    80106eb4 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df4:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80106dfb:	89 c2                	mov    %eax,%edx
80106dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e00:	66 89 14 c5 20 5b 11 	mov    %dx,-0x7feea4e0(,%eax,8)
80106e07:	80 
80106e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e0b:	66 c7 04 c5 22 5b 11 	movw   $0x8,-0x7feea4de(,%eax,8)
80106e12:	80 08 00 
80106e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e18:	0f b6 14 c5 24 5b 11 	movzbl -0x7feea4dc(,%eax,8),%edx
80106e1f:	80 
80106e20:	83 e2 e0             	and    $0xffffffe0,%edx
80106e23:	88 14 c5 24 5b 11 80 	mov    %dl,-0x7feea4dc(,%eax,8)
80106e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e2d:	0f b6 14 c5 24 5b 11 	movzbl -0x7feea4dc(,%eax,8),%edx
80106e34:	80 
80106e35:	83 e2 1f             	and    $0x1f,%edx
80106e38:	88 14 c5 24 5b 11 80 	mov    %dl,-0x7feea4dc(,%eax,8)
80106e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e42:	0f b6 14 c5 25 5b 11 	movzbl -0x7feea4db(,%eax,8),%edx
80106e49:	80 
80106e4a:	83 e2 f0             	and    $0xfffffff0,%edx
80106e4d:	83 ca 0e             	or     $0xe,%edx
80106e50:	88 14 c5 25 5b 11 80 	mov    %dl,-0x7feea4db(,%eax,8)
80106e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e5a:	0f b6 14 c5 25 5b 11 	movzbl -0x7feea4db(,%eax,8),%edx
80106e61:	80 
80106e62:	83 e2 ef             	and    $0xffffffef,%edx
80106e65:	88 14 c5 25 5b 11 80 	mov    %dl,-0x7feea4db(,%eax,8)
80106e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e6f:	0f b6 14 c5 25 5b 11 	movzbl -0x7feea4db(,%eax,8),%edx
80106e76:	80 
80106e77:	83 e2 9f             	and    $0xffffff9f,%edx
80106e7a:	88 14 c5 25 5b 11 80 	mov    %dl,-0x7feea4db(,%eax,8)
80106e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e84:	0f b6 14 c5 25 5b 11 	movzbl -0x7feea4db(,%eax,8),%edx
80106e8b:	80 
80106e8c:	83 ca 80             	or     $0xffffff80,%edx
80106e8f:	88 14 c5 25 5b 11 80 	mov    %dl,-0x7feea4db(,%eax,8)
80106e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e99:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80106ea0:	c1 e8 10             	shr    $0x10,%eax
80106ea3:	89 c2                	mov    %eax,%edx
80106ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ea8:	66 89 14 c5 26 5b 11 	mov    %dx,-0x7feea4da(,%eax,8)
80106eaf:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106eb0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106eb4:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106ebb:	0f 8e 30 ff ff ff    	jle    80106df1 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106ec1:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80106ec6:	66 a3 20 5d 11 80    	mov    %ax,0x80115d20
80106ecc:	66 c7 05 22 5d 11 80 	movw   $0x8,0x80115d22
80106ed3:	08 00 
80106ed5:	0f b6 05 24 5d 11 80 	movzbl 0x80115d24,%eax
80106edc:	83 e0 e0             	and    $0xffffffe0,%eax
80106edf:	a2 24 5d 11 80       	mov    %al,0x80115d24
80106ee4:	0f b6 05 24 5d 11 80 	movzbl 0x80115d24,%eax
80106eeb:	83 e0 1f             	and    $0x1f,%eax
80106eee:	a2 24 5d 11 80       	mov    %al,0x80115d24
80106ef3:	0f b6 05 25 5d 11 80 	movzbl 0x80115d25,%eax
80106efa:	83 c8 0f             	or     $0xf,%eax
80106efd:	a2 25 5d 11 80       	mov    %al,0x80115d25
80106f02:	0f b6 05 25 5d 11 80 	movzbl 0x80115d25,%eax
80106f09:	83 e0 ef             	and    $0xffffffef,%eax
80106f0c:	a2 25 5d 11 80       	mov    %al,0x80115d25
80106f11:	0f b6 05 25 5d 11 80 	movzbl 0x80115d25,%eax
80106f18:	83 c8 60             	or     $0x60,%eax
80106f1b:	a2 25 5d 11 80       	mov    %al,0x80115d25
80106f20:	0f b6 05 25 5d 11 80 	movzbl 0x80115d25,%eax
80106f27:	83 c8 80             	or     $0xffffff80,%eax
80106f2a:	a2 25 5d 11 80       	mov    %al,0x80115d25
80106f2f:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
80106f34:	c1 e8 10             	shr    $0x10,%eax
80106f37:	66 a3 26 5d 11 80    	mov    %ax,0x80115d26
  
  initlock(&tickslock, "time");
80106f3d:	c7 44 24 04 f4 92 10 	movl   $0x801092f4,0x4(%esp)
80106f44:	80 
80106f45:	c7 04 24 e0 5a 11 80 	movl   $0x80115ae0,(%esp)
80106f4c:	e8 05 e6 ff ff       	call   80105556 <initlock>
}
80106f51:	c9                   	leave  
80106f52:	c3                   	ret    

80106f53 <idtinit>:

void
idtinit(void)
{
80106f53:	55                   	push   %ebp
80106f54:	89 e5                	mov    %esp,%ebp
80106f56:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106f59:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106f60:	00 
80106f61:	c7 04 24 20 5b 11 80 	movl   $0x80115b20,(%esp)
80106f68:	e8 33 fe ff ff       	call   80106da0 <lidt>
}
80106f6d:	c9                   	leave  
80106f6e:	c3                   	ret    

80106f6f <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106f6f:	55                   	push   %ebp
80106f70:	89 e5                	mov    %esp,%ebp
80106f72:	57                   	push   %edi
80106f73:	56                   	push   %esi
80106f74:	53                   	push   %ebx
80106f75:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106f78:	8b 45 08             	mov    0x8(%ebp),%eax
80106f7b:	8b 40 30             	mov    0x30(%eax),%eax
80106f7e:	83 f8 40             	cmp    $0x40,%eax
80106f81:	75 3e                	jne    80106fc1 <trap+0x52>
    if(proc->killed)
80106f83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f89:	8b 40 24             	mov    0x24(%eax),%eax
80106f8c:	85 c0                	test   %eax,%eax
80106f8e:	74 05                	je     80106f95 <trap+0x26>
      exit();
80106f90:	e8 47 dd ff ff       	call   80104cdc <exit>
    proc->tf = tf;
80106f95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f9b:	8b 55 08             	mov    0x8(%ebp),%edx
80106f9e:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106fa1:	e8 4d ec ff ff       	call   80105bf3 <syscall>
    if(proc->killed)
80106fa6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fac:	8b 40 24             	mov    0x24(%eax),%eax
80106faf:	85 c0                	test   %eax,%eax
80106fb1:	0f 84 34 02 00 00    	je     801071eb <trap+0x27c>
      exit();
80106fb7:	e8 20 dd ff ff       	call   80104cdc <exit>
    return;
80106fbc:	e9 2a 02 00 00       	jmp    801071eb <trap+0x27c>
  }

  switch(tf->trapno){
80106fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc4:	8b 40 30             	mov    0x30(%eax),%eax
80106fc7:	83 e8 20             	sub    $0x20,%eax
80106fca:	83 f8 1f             	cmp    $0x1f,%eax
80106fcd:	0f 87 bc 00 00 00    	ja     8010708f <trap+0x120>
80106fd3:	8b 04 85 9c 93 10 80 	mov    -0x7fef6c64(,%eax,4),%eax
80106fda:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106fdc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106fe2:	0f b6 00             	movzbl (%eax),%eax
80106fe5:	84 c0                	test   %al,%al
80106fe7:	75 31                	jne    8010701a <trap+0xab>
      acquire(&tickslock);
80106fe9:	c7 04 24 e0 5a 11 80 	movl   $0x80115ae0,(%esp)
80106ff0:	e8 82 e5 ff ff       	call   80105577 <acquire>
      ticks++;
80106ff5:	a1 20 63 11 80       	mov    0x80116320,%eax
80106ffa:	83 c0 01             	add    $0x1,%eax
80106ffd:	a3 20 63 11 80       	mov    %eax,0x80116320
      wakeup(&ticks);
80107002:	c7 04 24 20 63 11 80 	movl   $0x80116320,(%esp)
80107009:	e8 5f e3 ff ff       	call   8010536d <wakeup>
      release(&tickslock);
8010700e:	c7 04 24 e0 5a 11 80 	movl   $0x80115ae0,(%esp)
80107015:	e8 bf e5 ff ff       	call   801055d9 <release>
    }
    lapiceoi();
8010701a:	e8 ca be ff ff       	call   80102ee9 <lapiceoi>
    break;
8010701f:	e9 41 01 00 00       	jmp    80107165 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107024:	e8 c8 b6 ff ff       	call   801026f1 <ideintr>
    lapiceoi();
80107029:	e8 bb be ff ff       	call   80102ee9 <lapiceoi>
    break;
8010702e:	e9 32 01 00 00       	jmp    80107165 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107033:	e8 8f bc ff ff       	call   80102cc7 <kbdintr>
    lapiceoi();
80107038:	e8 ac be ff ff       	call   80102ee9 <lapiceoi>
    break;
8010703d:	e9 23 01 00 00       	jmp    80107165 <trap+0x1f6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107042:	e8 a9 03 00 00       	call   801073f0 <uartintr>
    lapiceoi();
80107047:	e8 9d be ff ff       	call   80102ee9 <lapiceoi>
    break;
8010704c:	e9 14 01 00 00       	jmp    80107165 <trap+0x1f6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
80107051:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107054:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107057:	8b 45 08             	mov    0x8(%ebp),%eax
8010705a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010705e:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107061:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107067:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010706a:	0f b6 c0             	movzbl %al,%eax
8010706d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107071:	89 54 24 08          	mov    %edx,0x8(%esp)
80107075:	89 44 24 04          	mov    %eax,0x4(%esp)
80107079:	c7 04 24 fc 92 10 80 	movl   $0x801092fc,(%esp)
80107080:	e8 1c 93 ff ff       	call   801003a1 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107085:	e8 5f be ff ff       	call   80102ee9 <lapiceoi>
    break;
8010708a:	e9 d6 00 00 00       	jmp    80107165 <trap+0x1f6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010708f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107095:	85 c0                	test   %eax,%eax
80107097:	74 11                	je     801070aa <trap+0x13b>
80107099:	8b 45 08             	mov    0x8(%ebp),%eax
8010709c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801070a0:	0f b7 c0             	movzwl %ax,%eax
801070a3:	83 e0 03             	and    $0x3,%eax
801070a6:	85 c0                	test   %eax,%eax
801070a8:	75 46                	jne    801070f0 <trap+0x181>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801070aa:	e8 1a fd ff ff       	call   80106dc9 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
801070af:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801070b2:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801070b5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801070bc:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801070bf:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801070c2:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801070c5:	8b 52 30             	mov    0x30(%edx),%edx
801070c8:	89 44 24 10          	mov    %eax,0x10(%esp)
801070cc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801070d0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801070d4:	89 54 24 04          	mov    %edx,0x4(%esp)
801070d8:	c7 04 24 20 93 10 80 	movl   $0x80109320,(%esp)
801070df:	e8 bd 92 ff ff       	call   801003a1 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801070e4:	c7 04 24 52 93 10 80 	movl   $0x80109352,(%esp)
801070eb:	e8 4d 94 ff ff       	call   8010053d <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070f0:	e8 d4 fc ff ff       	call   80106dc9 <rcr2>
801070f5:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070f7:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070fa:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801070fd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107103:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107106:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107109:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010710c:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010710f:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107112:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107115:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010711b:	83 c0 70             	add    $0x70,%eax
8010711e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107121:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107127:	8b 40 10             	mov    0x10(%eax),%eax
8010712a:	89 54 24 1c          	mov    %edx,0x1c(%esp)
8010712e:	89 7c 24 18          	mov    %edi,0x18(%esp)
80107132:	89 74 24 14          	mov    %esi,0x14(%esp)
80107136:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010713a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010713e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107141:	89 54 24 08          	mov    %edx,0x8(%esp)
80107145:	89 44 24 04          	mov    %eax,0x4(%esp)
80107149:	c7 04 24 58 93 10 80 	movl   $0x80109358,(%esp)
80107150:	e8 4c 92 ff ff       	call   801003a1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107155:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010715b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107162:	eb 01                	jmp    80107165 <trap+0x1f6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107164:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107165:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010716b:	85 c0                	test   %eax,%eax
8010716d:	74 24                	je     80107193 <trap+0x224>
8010716f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107175:	8b 40 24             	mov    0x24(%eax),%eax
80107178:	85 c0                	test   %eax,%eax
8010717a:	74 17                	je     80107193 <trap+0x224>
8010717c:	8b 45 08             	mov    0x8(%ebp),%eax
8010717f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107183:	0f b7 c0             	movzwl %ax,%eax
80107186:	83 e0 03             	and    $0x3,%eax
80107189:	83 f8 03             	cmp    $0x3,%eax
8010718c:	75 05                	jne    80107193 <trap+0x224>
    exit();
8010718e:	e8 49 db ff ff       	call   80104cdc <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80107193:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107199:	85 c0                	test   %eax,%eax
8010719b:	74 1e                	je     801071bb <trap+0x24c>
8010719d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071a3:	8b 40 0c             	mov    0xc(%eax),%eax
801071a6:	83 f8 04             	cmp    $0x4,%eax
801071a9:	75 10                	jne    801071bb <trap+0x24c>
801071ab:	8b 45 08             	mov    0x8(%ebp),%eax
801071ae:	8b 40 30             	mov    0x30(%eax),%eax
801071b1:	83 f8 20             	cmp    $0x20,%eax
801071b4:	75 05                	jne    801071bb <trap+0x24c>
    yield();
801071b6:	e8 78 e0 ff ff       	call   80105233 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801071bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071c1:	85 c0                	test   %eax,%eax
801071c3:	74 27                	je     801071ec <trap+0x27d>
801071c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071cb:	8b 40 24             	mov    0x24(%eax),%eax
801071ce:	85 c0                	test   %eax,%eax
801071d0:	74 1a                	je     801071ec <trap+0x27d>
801071d2:	8b 45 08             	mov    0x8(%ebp),%eax
801071d5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801071d9:	0f b7 c0             	movzwl %ax,%eax
801071dc:	83 e0 03             	and    $0x3,%eax
801071df:	83 f8 03             	cmp    $0x3,%eax
801071e2:	75 08                	jne    801071ec <trap+0x27d>
    exit();
801071e4:	e8 f3 da ff ff       	call   80104cdc <exit>
801071e9:	eb 01                	jmp    801071ec <trap+0x27d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801071eb:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801071ec:	83 c4 3c             	add    $0x3c,%esp
801071ef:	5b                   	pop    %ebx
801071f0:	5e                   	pop    %esi
801071f1:	5f                   	pop    %edi
801071f2:	5d                   	pop    %ebp
801071f3:	c3                   	ret    

801071f4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801071f4:	55                   	push   %ebp
801071f5:	89 e5                	mov    %esp,%ebp
801071f7:	53                   	push   %ebx
801071f8:	83 ec 14             	sub    $0x14,%esp
801071fb:	8b 45 08             	mov    0x8(%ebp),%eax
801071fe:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107202:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80107206:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
8010720a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
8010720e:	ec                   	in     (%dx),%al
8010720f:	89 c3                	mov    %eax,%ebx
80107211:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80107214:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80107218:	83 c4 14             	add    $0x14,%esp
8010721b:	5b                   	pop    %ebx
8010721c:	5d                   	pop    %ebp
8010721d:	c3                   	ret    

8010721e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010721e:	55                   	push   %ebp
8010721f:	89 e5                	mov    %esp,%ebp
80107221:	83 ec 08             	sub    $0x8,%esp
80107224:	8b 55 08             	mov    0x8(%ebp),%edx
80107227:	8b 45 0c             	mov    0xc(%ebp),%eax
8010722a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010722e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107231:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107235:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107239:	ee                   	out    %al,(%dx)
}
8010723a:	c9                   	leave  
8010723b:	c3                   	ret    

8010723c <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010723c:	55                   	push   %ebp
8010723d:	89 e5                	mov    %esp,%ebp
8010723f:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107242:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107249:	00 
8010724a:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107251:	e8 c8 ff ff ff       	call   8010721e <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107256:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
8010725d:	00 
8010725e:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107265:	e8 b4 ff ff ff       	call   8010721e <outb>
  outb(COM1+0, 115200/9600);
8010726a:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80107271:	00 
80107272:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107279:	e8 a0 ff ff ff       	call   8010721e <outb>
  outb(COM1+1, 0);
8010727e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107285:	00 
80107286:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010728d:	e8 8c ff ff ff       	call   8010721e <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107292:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80107299:	00 
8010729a:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801072a1:	e8 78 ff ff ff       	call   8010721e <outb>
  outb(COM1+4, 0);
801072a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801072ad:	00 
801072ae:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801072b5:	e8 64 ff ff ff       	call   8010721e <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801072ba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801072c1:	00 
801072c2:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801072c9:	e8 50 ff ff ff       	call   8010721e <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801072ce:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801072d5:	e8 1a ff ff ff       	call   801071f4 <inb>
801072da:	3c ff                	cmp    $0xff,%al
801072dc:	74 6c                	je     8010734a <uartinit+0x10e>
    return;
  uart = 1;
801072de:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
801072e5:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801072e8:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801072ef:	e8 00 ff ff ff       	call   801071f4 <inb>
  inb(COM1+0);
801072f4:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801072fb:	e8 f4 fe ff ff       	call   801071f4 <inb>
  picenable(IRQ_COM1);
80107300:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107307:	e8 b5 c7 ff ff       	call   80103ac1 <picenable>
  ioapicenable(IRQ_COM1, 0);
8010730c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107313:	00 
80107314:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010731b:	e8 56 b6 ff ff       	call   80102976 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107320:	c7 45 f4 1c 94 10 80 	movl   $0x8010941c,-0xc(%ebp)
80107327:	eb 15                	jmp    8010733e <uartinit+0x102>
    uartputc(*p);
80107329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010732c:	0f b6 00             	movzbl (%eax),%eax
8010732f:	0f be c0             	movsbl %al,%eax
80107332:	89 04 24             	mov    %eax,(%esp)
80107335:	e8 13 00 00 00       	call   8010734d <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010733a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010733e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107341:	0f b6 00             	movzbl (%eax),%eax
80107344:	84 c0                	test   %al,%al
80107346:	75 e1                	jne    80107329 <uartinit+0xed>
80107348:	eb 01                	jmp    8010734b <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010734a:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010734b:	c9                   	leave  
8010734c:	c3                   	ret    

8010734d <uartputc>:

void
uartputc(int c)
{
8010734d:	55                   	push   %ebp
8010734e:	89 e5                	mov    %esp,%ebp
80107350:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80107353:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107358:	85 c0                	test   %eax,%eax
8010735a:	74 4d                	je     801073a9 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010735c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107363:	eb 10                	jmp    80107375 <uartputc+0x28>
    microdelay(10);
80107365:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010736c:	e8 9d bb ff ff       	call   80102f0e <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107371:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107375:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107379:	7f 16                	jg     80107391 <uartputc+0x44>
8010737b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107382:	e8 6d fe ff ff       	call   801071f4 <inb>
80107387:	0f b6 c0             	movzbl %al,%eax
8010738a:	83 e0 20             	and    $0x20,%eax
8010738d:	85 c0                	test   %eax,%eax
8010738f:	74 d4                	je     80107365 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107391:	8b 45 08             	mov    0x8(%ebp),%eax
80107394:	0f b6 c0             	movzbl %al,%eax
80107397:	89 44 24 04          	mov    %eax,0x4(%esp)
8010739b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801073a2:	e8 77 fe ff ff       	call   8010721e <outb>
801073a7:	eb 01                	jmp    801073aa <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801073a9:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801073aa:	c9                   	leave  
801073ab:	c3                   	ret    

801073ac <uartgetc>:

static int
uartgetc(void)
{
801073ac:	55                   	push   %ebp
801073ad:	89 e5                	mov    %esp,%ebp
801073af:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801073b2:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801073b7:	85 c0                	test   %eax,%eax
801073b9:	75 07                	jne    801073c2 <uartgetc+0x16>
    return -1;
801073bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073c0:	eb 2c                	jmp    801073ee <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801073c2:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801073c9:	e8 26 fe ff ff       	call   801071f4 <inb>
801073ce:	0f b6 c0             	movzbl %al,%eax
801073d1:	83 e0 01             	and    $0x1,%eax
801073d4:	85 c0                	test   %eax,%eax
801073d6:	75 07                	jne    801073df <uartgetc+0x33>
    return -1;
801073d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073dd:	eb 0f                	jmp    801073ee <uartgetc+0x42>
  return inb(COM1+0);
801073df:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801073e6:	e8 09 fe ff ff       	call   801071f4 <inb>
801073eb:	0f b6 c0             	movzbl %al,%eax
}
801073ee:	c9                   	leave  
801073ef:	c3                   	ret    

801073f0 <uartintr>:

void
uartintr(void)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801073f6:	c7 04 24 ac 73 10 80 	movl   $0x801073ac,(%esp)
801073fd:	e8 ab 93 ff ff       	call   801007ad <consoleintr>
}
80107402:	c9                   	leave  
80107403:	c3                   	ret    

80107404 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107404:	6a 00                	push   $0x0
  pushl $0
80107406:	6a 00                	push   $0x0
  jmp alltraps
80107408:	e9 67 f9 ff ff       	jmp    80106d74 <alltraps>

8010740d <vector1>:
.globl vector1
vector1:
  pushl $0
8010740d:	6a 00                	push   $0x0
  pushl $1
8010740f:	6a 01                	push   $0x1
  jmp alltraps
80107411:	e9 5e f9 ff ff       	jmp    80106d74 <alltraps>

80107416 <vector2>:
.globl vector2
vector2:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $2
80107418:	6a 02                	push   $0x2
  jmp alltraps
8010741a:	e9 55 f9 ff ff       	jmp    80106d74 <alltraps>

8010741f <vector3>:
.globl vector3
vector3:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $3
80107421:	6a 03                	push   $0x3
  jmp alltraps
80107423:	e9 4c f9 ff ff       	jmp    80106d74 <alltraps>

80107428 <vector4>:
.globl vector4
vector4:
  pushl $0
80107428:	6a 00                	push   $0x0
  pushl $4
8010742a:	6a 04                	push   $0x4
  jmp alltraps
8010742c:	e9 43 f9 ff ff       	jmp    80106d74 <alltraps>

80107431 <vector5>:
.globl vector5
vector5:
  pushl $0
80107431:	6a 00                	push   $0x0
  pushl $5
80107433:	6a 05                	push   $0x5
  jmp alltraps
80107435:	e9 3a f9 ff ff       	jmp    80106d74 <alltraps>

8010743a <vector6>:
.globl vector6
vector6:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $6
8010743c:	6a 06                	push   $0x6
  jmp alltraps
8010743e:	e9 31 f9 ff ff       	jmp    80106d74 <alltraps>

80107443 <vector7>:
.globl vector7
vector7:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $7
80107445:	6a 07                	push   $0x7
  jmp alltraps
80107447:	e9 28 f9 ff ff       	jmp    80106d74 <alltraps>

8010744c <vector8>:
.globl vector8
vector8:
  pushl $8
8010744c:	6a 08                	push   $0x8
  jmp alltraps
8010744e:	e9 21 f9 ff ff       	jmp    80106d74 <alltraps>

80107453 <vector9>:
.globl vector9
vector9:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $9
80107455:	6a 09                	push   $0x9
  jmp alltraps
80107457:	e9 18 f9 ff ff       	jmp    80106d74 <alltraps>

8010745c <vector10>:
.globl vector10
vector10:
  pushl $10
8010745c:	6a 0a                	push   $0xa
  jmp alltraps
8010745e:	e9 11 f9 ff ff       	jmp    80106d74 <alltraps>

80107463 <vector11>:
.globl vector11
vector11:
  pushl $11
80107463:	6a 0b                	push   $0xb
  jmp alltraps
80107465:	e9 0a f9 ff ff       	jmp    80106d74 <alltraps>

8010746a <vector12>:
.globl vector12
vector12:
  pushl $12
8010746a:	6a 0c                	push   $0xc
  jmp alltraps
8010746c:	e9 03 f9 ff ff       	jmp    80106d74 <alltraps>

80107471 <vector13>:
.globl vector13
vector13:
  pushl $13
80107471:	6a 0d                	push   $0xd
  jmp alltraps
80107473:	e9 fc f8 ff ff       	jmp    80106d74 <alltraps>

80107478 <vector14>:
.globl vector14
vector14:
  pushl $14
80107478:	6a 0e                	push   $0xe
  jmp alltraps
8010747a:	e9 f5 f8 ff ff       	jmp    80106d74 <alltraps>

8010747f <vector15>:
.globl vector15
vector15:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $15
80107481:	6a 0f                	push   $0xf
  jmp alltraps
80107483:	e9 ec f8 ff ff       	jmp    80106d74 <alltraps>

80107488 <vector16>:
.globl vector16
vector16:
  pushl $0
80107488:	6a 00                	push   $0x0
  pushl $16
8010748a:	6a 10                	push   $0x10
  jmp alltraps
8010748c:	e9 e3 f8 ff ff       	jmp    80106d74 <alltraps>

80107491 <vector17>:
.globl vector17
vector17:
  pushl $17
80107491:	6a 11                	push   $0x11
  jmp alltraps
80107493:	e9 dc f8 ff ff       	jmp    80106d74 <alltraps>

80107498 <vector18>:
.globl vector18
vector18:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $18
8010749a:	6a 12                	push   $0x12
  jmp alltraps
8010749c:	e9 d3 f8 ff ff       	jmp    80106d74 <alltraps>

801074a1 <vector19>:
.globl vector19
vector19:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $19
801074a3:	6a 13                	push   $0x13
  jmp alltraps
801074a5:	e9 ca f8 ff ff       	jmp    80106d74 <alltraps>

801074aa <vector20>:
.globl vector20
vector20:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $20
801074ac:	6a 14                	push   $0x14
  jmp alltraps
801074ae:	e9 c1 f8 ff ff       	jmp    80106d74 <alltraps>

801074b3 <vector21>:
.globl vector21
vector21:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $21
801074b5:	6a 15                	push   $0x15
  jmp alltraps
801074b7:	e9 b8 f8 ff ff       	jmp    80106d74 <alltraps>

801074bc <vector22>:
.globl vector22
vector22:
  pushl $0
801074bc:	6a 00                	push   $0x0
  pushl $22
801074be:	6a 16                	push   $0x16
  jmp alltraps
801074c0:	e9 af f8 ff ff       	jmp    80106d74 <alltraps>

801074c5 <vector23>:
.globl vector23
vector23:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $23
801074c7:	6a 17                	push   $0x17
  jmp alltraps
801074c9:	e9 a6 f8 ff ff       	jmp    80106d74 <alltraps>

801074ce <vector24>:
.globl vector24
vector24:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $24
801074d0:	6a 18                	push   $0x18
  jmp alltraps
801074d2:	e9 9d f8 ff ff       	jmp    80106d74 <alltraps>

801074d7 <vector25>:
.globl vector25
vector25:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $25
801074d9:	6a 19                	push   $0x19
  jmp alltraps
801074db:	e9 94 f8 ff ff       	jmp    80106d74 <alltraps>

801074e0 <vector26>:
.globl vector26
vector26:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $26
801074e2:	6a 1a                	push   $0x1a
  jmp alltraps
801074e4:	e9 8b f8 ff ff       	jmp    80106d74 <alltraps>

801074e9 <vector27>:
.globl vector27
vector27:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $27
801074eb:	6a 1b                	push   $0x1b
  jmp alltraps
801074ed:	e9 82 f8 ff ff       	jmp    80106d74 <alltraps>

801074f2 <vector28>:
.globl vector28
vector28:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $28
801074f4:	6a 1c                	push   $0x1c
  jmp alltraps
801074f6:	e9 79 f8 ff ff       	jmp    80106d74 <alltraps>

801074fb <vector29>:
.globl vector29
vector29:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $29
801074fd:	6a 1d                	push   $0x1d
  jmp alltraps
801074ff:	e9 70 f8 ff ff       	jmp    80106d74 <alltraps>

80107504 <vector30>:
.globl vector30
vector30:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $30
80107506:	6a 1e                	push   $0x1e
  jmp alltraps
80107508:	e9 67 f8 ff ff       	jmp    80106d74 <alltraps>

8010750d <vector31>:
.globl vector31
vector31:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $31
8010750f:	6a 1f                	push   $0x1f
  jmp alltraps
80107511:	e9 5e f8 ff ff       	jmp    80106d74 <alltraps>

80107516 <vector32>:
.globl vector32
vector32:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $32
80107518:	6a 20                	push   $0x20
  jmp alltraps
8010751a:	e9 55 f8 ff ff       	jmp    80106d74 <alltraps>

8010751f <vector33>:
.globl vector33
vector33:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $33
80107521:	6a 21                	push   $0x21
  jmp alltraps
80107523:	e9 4c f8 ff ff       	jmp    80106d74 <alltraps>

80107528 <vector34>:
.globl vector34
vector34:
  pushl $0
80107528:	6a 00                	push   $0x0
  pushl $34
8010752a:	6a 22                	push   $0x22
  jmp alltraps
8010752c:	e9 43 f8 ff ff       	jmp    80106d74 <alltraps>

80107531 <vector35>:
.globl vector35
vector35:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $35
80107533:	6a 23                	push   $0x23
  jmp alltraps
80107535:	e9 3a f8 ff ff       	jmp    80106d74 <alltraps>

8010753a <vector36>:
.globl vector36
vector36:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $36
8010753c:	6a 24                	push   $0x24
  jmp alltraps
8010753e:	e9 31 f8 ff ff       	jmp    80106d74 <alltraps>

80107543 <vector37>:
.globl vector37
vector37:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $37
80107545:	6a 25                	push   $0x25
  jmp alltraps
80107547:	e9 28 f8 ff ff       	jmp    80106d74 <alltraps>

8010754c <vector38>:
.globl vector38
vector38:
  pushl $0
8010754c:	6a 00                	push   $0x0
  pushl $38
8010754e:	6a 26                	push   $0x26
  jmp alltraps
80107550:	e9 1f f8 ff ff       	jmp    80106d74 <alltraps>

80107555 <vector39>:
.globl vector39
vector39:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $39
80107557:	6a 27                	push   $0x27
  jmp alltraps
80107559:	e9 16 f8 ff ff       	jmp    80106d74 <alltraps>

8010755e <vector40>:
.globl vector40
vector40:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $40
80107560:	6a 28                	push   $0x28
  jmp alltraps
80107562:	e9 0d f8 ff ff       	jmp    80106d74 <alltraps>

80107567 <vector41>:
.globl vector41
vector41:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $41
80107569:	6a 29                	push   $0x29
  jmp alltraps
8010756b:	e9 04 f8 ff ff       	jmp    80106d74 <alltraps>

80107570 <vector42>:
.globl vector42
vector42:
  pushl $0
80107570:	6a 00                	push   $0x0
  pushl $42
80107572:	6a 2a                	push   $0x2a
  jmp alltraps
80107574:	e9 fb f7 ff ff       	jmp    80106d74 <alltraps>

80107579 <vector43>:
.globl vector43
vector43:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $43
8010757b:	6a 2b                	push   $0x2b
  jmp alltraps
8010757d:	e9 f2 f7 ff ff       	jmp    80106d74 <alltraps>

80107582 <vector44>:
.globl vector44
vector44:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $44
80107584:	6a 2c                	push   $0x2c
  jmp alltraps
80107586:	e9 e9 f7 ff ff       	jmp    80106d74 <alltraps>

8010758b <vector45>:
.globl vector45
vector45:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $45
8010758d:	6a 2d                	push   $0x2d
  jmp alltraps
8010758f:	e9 e0 f7 ff ff       	jmp    80106d74 <alltraps>

80107594 <vector46>:
.globl vector46
vector46:
  pushl $0
80107594:	6a 00                	push   $0x0
  pushl $46
80107596:	6a 2e                	push   $0x2e
  jmp alltraps
80107598:	e9 d7 f7 ff ff       	jmp    80106d74 <alltraps>

8010759d <vector47>:
.globl vector47
vector47:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $47
8010759f:	6a 2f                	push   $0x2f
  jmp alltraps
801075a1:	e9 ce f7 ff ff       	jmp    80106d74 <alltraps>

801075a6 <vector48>:
.globl vector48
vector48:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $48
801075a8:	6a 30                	push   $0x30
  jmp alltraps
801075aa:	e9 c5 f7 ff ff       	jmp    80106d74 <alltraps>

801075af <vector49>:
.globl vector49
vector49:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $49
801075b1:	6a 31                	push   $0x31
  jmp alltraps
801075b3:	e9 bc f7 ff ff       	jmp    80106d74 <alltraps>

801075b8 <vector50>:
.globl vector50
vector50:
  pushl $0
801075b8:	6a 00                	push   $0x0
  pushl $50
801075ba:	6a 32                	push   $0x32
  jmp alltraps
801075bc:	e9 b3 f7 ff ff       	jmp    80106d74 <alltraps>

801075c1 <vector51>:
.globl vector51
vector51:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $51
801075c3:	6a 33                	push   $0x33
  jmp alltraps
801075c5:	e9 aa f7 ff ff       	jmp    80106d74 <alltraps>

801075ca <vector52>:
.globl vector52
vector52:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $52
801075cc:	6a 34                	push   $0x34
  jmp alltraps
801075ce:	e9 a1 f7 ff ff       	jmp    80106d74 <alltraps>

801075d3 <vector53>:
.globl vector53
vector53:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $53
801075d5:	6a 35                	push   $0x35
  jmp alltraps
801075d7:	e9 98 f7 ff ff       	jmp    80106d74 <alltraps>

801075dc <vector54>:
.globl vector54
vector54:
  pushl $0
801075dc:	6a 00                	push   $0x0
  pushl $54
801075de:	6a 36                	push   $0x36
  jmp alltraps
801075e0:	e9 8f f7 ff ff       	jmp    80106d74 <alltraps>

801075e5 <vector55>:
.globl vector55
vector55:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $55
801075e7:	6a 37                	push   $0x37
  jmp alltraps
801075e9:	e9 86 f7 ff ff       	jmp    80106d74 <alltraps>

801075ee <vector56>:
.globl vector56
vector56:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $56
801075f0:	6a 38                	push   $0x38
  jmp alltraps
801075f2:	e9 7d f7 ff ff       	jmp    80106d74 <alltraps>

801075f7 <vector57>:
.globl vector57
vector57:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $57
801075f9:	6a 39                	push   $0x39
  jmp alltraps
801075fb:	e9 74 f7 ff ff       	jmp    80106d74 <alltraps>

80107600 <vector58>:
.globl vector58
vector58:
  pushl $0
80107600:	6a 00                	push   $0x0
  pushl $58
80107602:	6a 3a                	push   $0x3a
  jmp alltraps
80107604:	e9 6b f7 ff ff       	jmp    80106d74 <alltraps>

80107609 <vector59>:
.globl vector59
vector59:
  pushl $0
80107609:	6a 00                	push   $0x0
  pushl $59
8010760b:	6a 3b                	push   $0x3b
  jmp alltraps
8010760d:	e9 62 f7 ff ff       	jmp    80106d74 <alltraps>

80107612 <vector60>:
.globl vector60
vector60:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $60
80107614:	6a 3c                	push   $0x3c
  jmp alltraps
80107616:	e9 59 f7 ff ff       	jmp    80106d74 <alltraps>

8010761b <vector61>:
.globl vector61
vector61:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $61
8010761d:	6a 3d                	push   $0x3d
  jmp alltraps
8010761f:	e9 50 f7 ff ff       	jmp    80106d74 <alltraps>

80107624 <vector62>:
.globl vector62
vector62:
  pushl $0
80107624:	6a 00                	push   $0x0
  pushl $62
80107626:	6a 3e                	push   $0x3e
  jmp alltraps
80107628:	e9 47 f7 ff ff       	jmp    80106d74 <alltraps>

8010762d <vector63>:
.globl vector63
vector63:
  pushl $0
8010762d:	6a 00                	push   $0x0
  pushl $63
8010762f:	6a 3f                	push   $0x3f
  jmp alltraps
80107631:	e9 3e f7 ff ff       	jmp    80106d74 <alltraps>

80107636 <vector64>:
.globl vector64
vector64:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $64
80107638:	6a 40                	push   $0x40
  jmp alltraps
8010763a:	e9 35 f7 ff ff       	jmp    80106d74 <alltraps>

8010763f <vector65>:
.globl vector65
vector65:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $65
80107641:	6a 41                	push   $0x41
  jmp alltraps
80107643:	e9 2c f7 ff ff       	jmp    80106d74 <alltraps>

80107648 <vector66>:
.globl vector66
vector66:
  pushl $0
80107648:	6a 00                	push   $0x0
  pushl $66
8010764a:	6a 42                	push   $0x42
  jmp alltraps
8010764c:	e9 23 f7 ff ff       	jmp    80106d74 <alltraps>

80107651 <vector67>:
.globl vector67
vector67:
  pushl $0
80107651:	6a 00                	push   $0x0
  pushl $67
80107653:	6a 43                	push   $0x43
  jmp alltraps
80107655:	e9 1a f7 ff ff       	jmp    80106d74 <alltraps>

8010765a <vector68>:
.globl vector68
vector68:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $68
8010765c:	6a 44                	push   $0x44
  jmp alltraps
8010765e:	e9 11 f7 ff ff       	jmp    80106d74 <alltraps>

80107663 <vector69>:
.globl vector69
vector69:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $69
80107665:	6a 45                	push   $0x45
  jmp alltraps
80107667:	e9 08 f7 ff ff       	jmp    80106d74 <alltraps>

8010766c <vector70>:
.globl vector70
vector70:
  pushl $0
8010766c:	6a 00                	push   $0x0
  pushl $70
8010766e:	6a 46                	push   $0x46
  jmp alltraps
80107670:	e9 ff f6 ff ff       	jmp    80106d74 <alltraps>

80107675 <vector71>:
.globl vector71
vector71:
  pushl $0
80107675:	6a 00                	push   $0x0
  pushl $71
80107677:	6a 47                	push   $0x47
  jmp alltraps
80107679:	e9 f6 f6 ff ff       	jmp    80106d74 <alltraps>

8010767e <vector72>:
.globl vector72
vector72:
  pushl $0
8010767e:	6a 00                	push   $0x0
  pushl $72
80107680:	6a 48                	push   $0x48
  jmp alltraps
80107682:	e9 ed f6 ff ff       	jmp    80106d74 <alltraps>

80107687 <vector73>:
.globl vector73
vector73:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $73
80107689:	6a 49                	push   $0x49
  jmp alltraps
8010768b:	e9 e4 f6 ff ff       	jmp    80106d74 <alltraps>

80107690 <vector74>:
.globl vector74
vector74:
  pushl $0
80107690:	6a 00                	push   $0x0
  pushl $74
80107692:	6a 4a                	push   $0x4a
  jmp alltraps
80107694:	e9 db f6 ff ff       	jmp    80106d74 <alltraps>

80107699 <vector75>:
.globl vector75
vector75:
  pushl $0
80107699:	6a 00                	push   $0x0
  pushl $75
8010769b:	6a 4b                	push   $0x4b
  jmp alltraps
8010769d:	e9 d2 f6 ff ff       	jmp    80106d74 <alltraps>

801076a2 <vector76>:
.globl vector76
vector76:
  pushl $0
801076a2:	6a 00                	push   $0x0
  pushl $76
801076a4:	6a 4c                	push   $0x4c
  jmp alltraps
801076a6:	e9 c9 f6 ff ff       	jmp    80106d74 <alltraps>

801076ab <vector77>:
.globl vector77
vector77:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $77
801076ad:	6a 4d                	push   $0x4d
  jmp alltraps
801076af:	e9 c0 f6 ff ff       	jmp    80106d74 <alltraps>

801076b4 <vector78>:
.globl vector78
vector78:
  pushl $0
801076b4:	6a 00                	push   $0x0
  pushl $78
801076b6:	6a 4e                	push   $0x4e
  jmp alltraps
801076b8:	e9 b7 f6 ff ff       	jmp    80106d74 <alltraps>

801076bd <vector79>:
.globl vector79
vector79:
  pushl $0
801076bd:	6a 00                	push   $0x0
  pushl $79
801076bf:	6a 4f                	push   $0x4f
  jmp alltraps
801076c1:	e9 ae f6 ff ff       	jmp    80106d74 <alltraps>

801076c6 <vector80>:
.globl vector80
vector80:
  pushl $0
801076c6:	6a 00                	push   $0x0
  pushl $80
801076c8:	6a 50                	push   $0x50
  jmp alltraps
801076ca:	e9 a5 f6 ff ff       	jmp    80106d74 <alltraps>

801076cf <vector81>:
.globl vector81
vector81:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $81
801076d1:	6a 51                	push   $0x51
  jmp alltraps
801076d3:	e9 9c f6 ff ff       	jmp    80106d74 <alltraps>

801076d8 <vector82>:
.globl vector82
vector82:
  pushl $0
801076d8:	6a 00                	push   $0x0
  pushl $82
801076da:	6a 52                	push   $0x52
  jmp alltraps
801076dc:	e9 93 f6 ff ff       	jmp    80106d74 <alltraps>

801076e1 <vector83>:
.globl vector83
vector83:
  pushl $0
801076e1:	6a 00                	push   $0x0
  pushl $83
801076e3:	6a 53                	push   $0x53
  jmp alltraps
801076e5:	e9 8a f6 ff ff       	jmp    80106d74 <alltraps>

801076ea <vector84>:
.globl vector84
vector84:
  pushl $0
801076ea:	6a 00                	push   $0x0
  pushl $84
801076ec:	6a 54                	push   $0x54
  jmp alltraps
801076ee:	e9 81 f6 ff ff       	jmp    80106d74 <alltraps>

801076f3 <vector85>:
.globl vector85
vector85:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $85
801076f5:	6a 55                	push   $0x55
  jmp alltraps
801076f7:	e9 78 f6 ff ff       	jmp    80106d74 <alltraps>

801076fc <vector86>:
.globl vector86
vector86:
  pushl $0
801076fc:	6a 00                	push   $0x0
  pushl $86
801076fe:	6a 56                	push   $0x56
  jmp alltraps
80107700:	e9 6f f6 ff ff       	jmp    80106d74 <alltraps>

80107705 <vector87>:
.globl vector87
vector87:
  pushl $0
80107705:	6a 00                	push   $0x0
  pushl $87
80107707:	6a 57                	push   $0x57
  jmp alltraps
80107709:	e9 66 f6 ff ff       	jmp    80106d74 <alltraps>

8010770e <vector88>:
.globl vector88
vector88:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $88
80107710:	6a 58                	push   $0x58
  jmp alltraps
80107712:	e9 5d f6 ff ff       	jmp    80106d74 <alltraps>

80107717 <vector89>:
.globl vector89
vector89:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $89
80107719:	6a 59                	push   $0x59
  jmp alltraps
8010771b:	e9 54 f6 ff ff       	jmp    80106d74 <alltraps>

80107720 <vector90>:
.globl vector90
vector90:
  pushl $0
80107720:	6a 00                	push   $0x0
  pushl $90
80107722:	6a 5a                	push   $0x5a
  jmp alltraps
80107724:	e9 4b f6 ff ff       	jmp    80106d74 <alltraps>

80107729 <vector91>:
.globl vector91
vector91:
  pushl $0
80107729:	6a 00                	push   $0x0
  pushl $91
8010772b:	6a 5b                	push   $0x5b
  jmp alltraps
8010772d:	e9 42 f6 ff ff       	jmp    80106d74 <alltraps>

80107732 <vector92>:
.globl vector92
vector92:
  pushl $0
80107732:	6a 00                	push   $0x0
  pushl $92
80107734:	6a 5c                	push   $0x5c
  jmp alltraps
80107736:	e9 39 f6 ff ff       	jmp    80106d74 <alltraps>

8010773b <vector93>:
.globl vector93
vector93:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $93
8010773d:	6a 5d                	push   $0x5d
  jmp alltraps
8010773f:	e9 30 f6 ff ff       	jmp    80106d74 <alltraps>

80107744 <vector94>:
.globl vector94
vector94:
  pushl $0
80107744:	6a 00                	push   $0x0
  pushl $94
80107746:	6a 5e                	push   $0x5e
  jmp alltraps
80107748:	e9 27 f6 ff ff       	jmp    80106d74 <alltraps>

8010774d <vector95>:
.globl vector95
vector95:
  pushl $0
8010774d:	6a 00                	push   $0x0
  pushl $95
8010774f:	6a 5f                	push   $0x5f
  jmp alltraps
80107751:	e9 1e f6 ff ff       	jmp    80106d74 <alltraps>

80107756 <vector96>:
.globl vector96
vector96:
  pushl $0
80107756:	6a 00                	push   $0x0
  pushl $96
80107758:	6a 60                	push   $0x60
  jmp alltraps
8010775a:	e9 15 f6 ff ff       	jmp    80106d74 <alltraps>

8010775f <vector97>:
.globl vector97
vector97:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $97
80107761:	6a 61                	push   $0x61
  jmp alltraps
80107763:	e9 0c f6 ff ff       	jmp    80106d74 <alltraps>

80107768 <vector98>:
.globl vector98
vector98:
  pushl $0
80107768:	6a 00                	push   $0x0
  pushl $98
8010776a:	6a 62                	push   $0x62
  jmp alltraps
8010776c:	e9 03 f6 ff ff       	jmp    80106d74 <alltraps>

80107771 <vector99>:
.globl vector99
vector99:
  pushl $0
80107771:	6a 00                	push   $0x0
  pushl $99
80107773:	6a 63                	push   $0x63
  jmp alltraps
80107775:	e9 fa f5 ff ff       	jmp    80106d74 <alltraps>

8010777a <vector100>:
.globl vector100
vector100:
  pushl $0
8010777a:	6a 00                	push   $0x0
  pushl $100
8010777c:	6a 64                	push   $0x64
  jmp alltraps
8010777e:	e9 f1 f5 ff ff       	jmp    80106d74 <alltraps>

80107783 <vector101>:
.globl vector101
vector101:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $101
80107785:	6a 65                	push   $0x65
  jmp alltraps
80107787:	e9 e8 f5 ff ff       	jmp    80106d74 <alltraps>

8010778c <vector102>:
.globl vector102
vector102:
  pushl $0
8010778c:	6a 00                	push   $0x0
  pushl $102
8010778e:	6a 66                	push   $0x66
  jmp alltraps
80107790:	e9 df f5 ff ff       	jmp    80106d74 <alltraps>

80107795 <vector103>:
.globl vector103
vector103:
  pushl $0
80107795:	6a 00                	push   $0x0
  pushl $103
80107797:	6a 67                	push   $0x67
  jmp alltraps
80107799:	e9 d6 f5 ff ff       	jmp    80106d74 <alltraps>

8010779e <vector104>:
.globl vector104
vector104:
  pushl $0
8010779e:	6a 00                	push   $0x0
  pushl $104
801077a0:	6a 68                	push   $0x68
  jmp alltraps
801077a2:	e9 cd f5 ff ff       	jmp    80106d74 <alltraps>

801077a7 <vector105>:
.globl vector105
vector105:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $105
801077a9:	6a 69                	push   $0x69
  jmp alltraps
801077ab:	e9 c4 f5 ff ff       	jmp    80106d74 <alltraps>

801077b0 <vector106>:
.globl vector106
vector106:
  pushl $0
801077b0:	6a 00                	push   $0x0
  pushl $106
801077b2:	6a 6a                	push   $0x6a
  jmp alltraps
801077b4:	e9 bb f5 ff ff       	jmp    80106d74 <alltraps>

801077b9 <vector107>:
.globl vector107
vector107:
  pushl $0
801077b9:	6a 00                	push   $0x0
  pushl $107
801077bb:	6a 6b                	push   $0x6b
  jmp alltraps
801077bd:	e9 b2 f5 ff ff       	jmp    80106d74 <alltraps>

801077c2 <vector108>:
.globl vector108
vector108:
  pushl $0
801077c2:	6a 00                	push   $0x0
  pushl $108
801077c4:	6a 6c                	push   $0x6c
  jmp alltraps
801077c6:	e9 a9 f5 ff ff       	jmp    80106d74 <alltraps>

801077cb <vector109>:
.globl vector109
vector109:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $109
801077cd:	6a 6d                	push   $0x6d
  jmp alltraps
801077cf:	e9 a0 f5 ff ff       	jmp    80106d74 <alltraps>

801077d4 <vector110>:
.globl vector110
vector110:
  pushl $0
801077d4:	6a 00                	push   $0x0
  pushl $110
801077d6:	6a 6e                	push   $0x6e
  jmp alltraps
801077d8:	e9 97 f5 ff ff       	jmp    80106d74 <alltraps>

801077dd <vector111>:
.globl vector111
vector111:
  pushl $0
801077dd:	6a 00                	push   $0x0
  pushl $111
801077df:	6a 6f                	push   $0x6f
  jmp alltraps
801077e1:	e9 8e f5 ff ff       	jmp    80106d74 <alltraps>

801077e6 <vector112>:
.globl vector112
vector112:
  pushl $0
801077e6:	6a 00                	push   $0x0
  pushl $112
801077e8:	6a 70                	push   $0x70
  jmp alltraps
801077ea:	e9 85 f5 ff ff       	jmp    80106d74 <alltraps>

801077ef <vector113>:
.globl vector113
vector113:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $113
801077f1:	6a 71                	push   $0x71
  jmp alltraps
801077f3:	e9 7c f5 ff ff       	jmp    80106d74 <alltraps>

801077f8 <vector114>:
.globl vector114
vector114:
  pushl $0
801077f8:	6a 00                	push   $0x0
  pushl $114
801077fa:	6a 72                	push   $0x72
  jmp alltraps
801077fc:	e9 73 f5 ff ff       	jmp    80106d74 <alltraps>

80107801 <vector115>:
.globl vector115
vector115:
  pushl $0
80107801:	6a 00                	push   $0x0
  pushl $115
80107803:	6a 73                	push   $0x73
  jmp alltraps
80107805:	e9 6a f5 ff ff       	jmp    80106d74 <alltraps>

8010780a <vector116>:
.globl vector116
vector116:
  pushl $0
8010780a:	6a 00                	push   $0x0
  pushl $116
8010780c:	6a 74                	push   $0x74
  jmp alltraps
8010780e:	e9 61 f5 ff ff       	jmp    80106d74 <alltraps>

80107813 <vector117>:
.globl vector117
vector117:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $117
80107815:	6a 75                	push   $0x75
  jmp alltraps
80107817:	e9 58 f5 ff ff       	jmp    80106d74 <alltraps>

8010781c <vector118>:
.globl vector118
vector118:
  pushl $0
8010781c:	6a 00                	push   $0x0
  pushl $118
8010781e:	6a 76                	push   $0x76
  jmp alltraps
80107820:	e9 4f f5 ff ff       	jmp    80106d74 <alltraps>

80107825 <vector119>:
.globl vector119
vector119:
  pushl $0
80107825:	6a 00                	push   $0x0
  pushl $119
80107827:	6a 77                	push   $0x77
  jmp alltraps
80107829:	e9 46 f5 ff ff       	jmp    80106d74 <alltraps>

8010782e <vector120>:
.globl vector120
vector120:
  pushl $0
8010782e:	6a 00                	push   $0x0
  pushl $120
80107830:	6a 78                	push   $0x78
  jmp alltraps
80107832:	e9 3d f5 ff ff       	jmp    80106d74 <alltraps>

80107837 <vector121>:
.globl vector121
vector121:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $121
80107839:	6a 79                	push   $0x79
  jmp alltraps
8010783b:	e9 34 f5 ff ff       	jmp    80106d74 <alltraps>

80107840 <vector122>:
.globl vector122
vector122:
  pushl $0
80107840:	6a 00                	push   $0x0
  pushl $122
80107842:	6a 7a                	push   $0x7a
  jmp alltraps
80107844:	e9 2b f5 ff ff       	jmp    80106d74 <alltraps>

80107849 <vector123>:
.globl vector123
vector123:
  pushl $0
80107849:	6a 00                	push   $0x0
  pushl $123
8010784b:	6a 7b                	push   $0x7b
  jmp alltraps
8010784d:	e9 22 f5 ff ff       	jmp    80106d74 <alltraps>

80107852 <vector124>:
.globl vector124
vector124:
  pushl $0
80107852:	6a 00                	push   $0x0
  pushl $124
80107854:	6a 7c                	push   $0x7c
  jmp alltraps
80107856:	e9 19 f5 ff ff       	jmp    80106d74 <alltraps>

8010785b <vector125>:
.globl vector125
vector125:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $125
8010785d:	6a 7d                	push   $0x7d
  jmp alltraps
8010785f:	e9 10 f5 ff ff       	jmp    80106d74 <alltraps>

80107864 <vector126>:
.globl vector126
vector126:
  pushl $0
80107864:	6a 00                	push   $0x0
  pushl $126
80107866:	6a 7e                	push   $0x7e
  jmp alltraps
80107868:	e9 07 f5 ff ff       	jmp    80106d74 <alltraps>

8010786d <vector127>:
.globl vector127
vector127:
  pushl $0
8010786d:	6a 00                	push   $0x0
  pushl $127
8010786f:	6a 7f                	push   $0x7f
  jmp alltraps
80107871:	e9 fe f4 ff ff       	jmp    80106d74 <alltraps>

80107876 <vector128>:
.globl vector128
vector128:
  pushl $0
80107876:	6a 00                	push   $0x0
  pushl $128
80107878:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010787d:	e9 f2 f4 ff ff       	jmp    80106d74 <alltraps>

80107882 <vector129>:
.globl vector129
vector129:
  pushl $0
80107882:	6a 00                	push   $0x0
  pushl $129
80107884:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107889:	e9 e6 f4 ff ff       	jmp    80106d74 <alltraps>

8010788e <vector130>:
.globl vector130
vector130:
  pushl $0
8010788e:	6a 00                	push   $0x0
  pushl $130
80107890:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107895:	e9 da f4 ff ff       	jmp    80106d74 <alltraps>

8010789a <vector131>:
.globl vector131
vector131:
  pushl $0
8010789a:	6a 00                	push   $0x0
  pushl $131
8010789c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801078a1:	e9 ce f4 ff ff       	jmp    80106d74 <alltraps>

801078a6 <vector132>:
.globl vector132
vector132:
  pushl $0
801078a6:	6a 00                	push   $0x0
  pushl $132
801078a8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801078ad:	e9 c2 f4 ff ff       	jmp    80106d74 <alltraps>

801078b2 <vector133>:
.globl vector133
vector133:
  pushl $0
801078b2:	6a 00                	push   $0x0
  pushl $133
801078b4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801078b9:	e9 b6 f4 ff ff       	jmp    80106d74 <alltraps>

801078be <vector134>:
.globl vector134
vector134:
  pushl $0
801078be:	6a 00                	push   $0x0
  pushl $134
801078c0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801078c5:	e9 aa f4 ff ff       	jmp    80106d74 <alltraps>

801078ca <vector135>:
.globl vector135
vector135:
  pushl $0
801078ca:	6a 00                	push   $0x0
  pushl $135
801078cc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801078d1:	e9 9e f4 ff ff       	jmp    80106d74 <alltraps>

801078d6 <vector136>:
.globl vector136
vector136:
  pushl $0
801078d6:	6a 00                	push   $0x0
  pushl $136
801078d8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801078dd:	e9 92 f4 ff ff       	jmp    80106d74 <alltraps>

801078e2 <vector137>:
.globl vector137
vector137:
  pushl $0
801078e2:	6a 00                	push   $0x0
  pushl $137
801078e4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801078e9:	e9 86 f4 ff ff       	jmp    80106d74 <alltraps>

801078ee <vector138>:
.globl vector138
vector138:
  pushl $0
801078ee:	6a 00                	push   $0x0
  pushl $138
801078f0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801078f5:	e9 7a f4 ff ff       	jmp    80106d74 <alltraps>

801078fa <vector139>:
.globl vector139
vector139:
  pushl $0
801078fa:	6a 00                	push   $0x0
  pushl $139
801078fc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107901:	e9 6e f4 ff ff       	jmp    80106d74 <alltraps>

80107906 <vector140>:
.globl vector140
vector140:
  pushl $0
80107906:	6a 00                	push   $0x0
  pushl $140
80107908:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010790d:	e9 62 f4 ff ff       	jmp    80106d74 <alltraps>

80107912 <vector141>:
.globl vector141
vector141:
  pushl $0
80107912:	6a 00                	push   $0x0
  pushl $141
80107914:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107919:	e9 56 f4 ff ff       	jmp    80106d74 <alltraps>

8010791e <vector142>:
.globl vector142
vector142:
  pushl $0
8010791e:	6a 00                	push   $0x0
  pushl $142
80107920:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107925:	e9 4a f4 ff ff       	jmp    80106d74 <alltraps>

8010792a <vector143>:
.globl vector143
vector143:
  pushl $0
8010792a:	6a 00                	push   $0x0
  pushl $143
8010792c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107931:	e9 3e f4 ff ff       	jmp    80106d74 <alltraps>

80107936 <vector144>:
.globl vector144
vector144:
  pushl $0
80107936:	6a 00                	push   $0x0
  pushl $144
80107938:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010793d:	e9 32 f4 ff ff       	jmp    80106d74 <alltraps>

80107942 <vector145>:
.globl vector145
vector145:
  pushl $0
80107942:	6a 00                	push   $0x0
  pushl $145
80107944:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107949:	e9 26 f4 ff ff       	jmp    80106d74 <alltraps>

8010794e <vector146>:
.globl vector146
vector146:
  pushl $0
8010794e:	6a 00                	push   $0x0
  pushl $146
80107950:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107955:	e9 1a f4 ff ff       	jmp    80106d74 <alltraps>

8010795a <vector147>:
.globl vector147
vector147:
  pushl $0
8010795a:	6a 00                	push   $0x0
  pushl $147
8010795c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107961:	e9 0e f4 ff ff       	jmp    80106d74 <alltraps>

80107966 <vector148>:
.globl vector148
vector148:
  pushl $0
80107966:	6a 00                	push   $0x0
  pushl $148
80107968:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010796d:	e9 02 f4 ff ff       	jmp    80106d74 <alltraps>

80107972 <vector149>:
.globl vector149
vector149:
  pushl $0
80107972:	6a 00                	push   $0x0
  pushl $149
80107974:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107979:	e9 f6 f3 ff ff       	jmp    80106d74 <alltraps>

8010797e <vector150>:
.globl vector150
vector150:
  pushl $0
8010797e:	6a 00                	push   $0x0
  pushl $150
80107980:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107985:	e9 ea f3 ff ff       	jmp    80106d74 <alltraps>

8010798a <vector151>:
.globl vector151
vector151:
  pushl $0
8010798a:	6a 00                	push   $0x0
  pushl $151
8010798c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107991:	e9 de f3 ff ff       	jmp    80106d74 <alltraps>

80107996 <vector152>:
.globl vector152
vector152:
  pushl $0
80107996:	6a 00                	push   $0x0
  pushl $152
80107998:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010799d:	e9 d2 f3 ff ff       	jmp    80106d74 <alltraps>

801079a2 <vector153>:
.globl vector153
vector153:
  pushl $0
801079a2:	6a 00                	push   $0x0
  pushl $153
801079a4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801079a9:	e9 c6 f3 ff ff       	jmp    80106d74 <alltraps>

801079ae <vector154>:
.globl vector154
vector154:
  pushl $0
801079ae:	6a 00                	push   $0x0
  pushl $154
801079b0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801079b5:	e9 ba f3 ff ff       	jmp    80106d74 <alltraps>

801079ba <vector155>:
.globl vector155
vector155:
  pushl $0
801079ba:	6a 00                	push   $0x0
  pushl $155
801079bc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801079c1:	e9 ae f3 ff ff       	jmp    80106d74 <alltraps>

801079c6 <vector156>:
.globl vector156
vector156:
  pushl $0
801079c6:	6a 00                	push   $0x0
  pushl $156
801079c8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801079cd:	e9 a2 f3 ff ff       	jmp    80106d74 <alltraps>

801079d2 <vector157>:
.globl vector157
vector157:
  pushl $0
801079d2:	6a 00                	push   $0x0
  pushl $157
801079d4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801079d9:	e9 96 f3 ff ff       	jmp    80106d74 <alltraps>

801079de <vector158>:
.globl vector158
vector158:
  pushl $0
801079de:	6a 00                	push   $0x0
  pushl $158
801079e0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801079e5:	e9 8a f3 ff ff       	jmp    80106d74 <alltraps>

801079ea <vector159>:
.globl vector159
vector159:
  pushl $0
801079ea:	6a 00                	push   $0x0
  pushl $159
801079ec:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801079f1:	e9 7e f3 ff ff       	jmp    80106d74 <alltraps>

801079f6 <vector160>:
.globl vector160
vector160:
  pushl $0
801079f6:	6a 00                	push   $0x0
  pushl $160
801079f8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801079fd:	e9 72 f3 ff ff       	jmp    80106d74 <alltraps>

80107a02 <vector161>:
.globl vector161
vector161:
  pushl $0
80107a02:	6a 00                	push   $0x0
  pushl $161
80107a04:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107a09:	e9 66 f3 ff ff       	jmp    80106d74 <alltraps>

80107a0e <vector162>:
.globl vector162
vector162:
  pushl $0
80107a0e:	6a 00                	push   $0x0
  pushl $162
80107a10:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107a15:	e9 5a f3 ff ff       	jmp    80106d74 <alltraps>

80107a1a <vector163>:
.globl vector163
vector163:
  pushl $0
80107a1a:	6a 00                	push   $0x0
  pushl $163
80107a1c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107a21:	e9 4e f3 ff ff       	jmp    80106d74 <alltraps>

80107a26 <vector164>:
.globl vector164
vector164:
  pushl $0
80107a26:	6a 00                	push   $0x0
  pushl $164
80107a28:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107a2d:	e9 42 f3 ff ff       	jmp    80106d74 <alltraps>

80107a32 <vector165>:
.globl vector165
vector165:
  pushl $0
80107a32:	6a 00                	push   $0x0
  pushl $165
80107a34:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107a39:	e9 36 f3 ff ff       	jmp    80106d74 <alltraps>

80107a3e <vector166>:
.globl vector166
vector166:
  pushl $0
80107a3e:	6a 00                	push   $0x0
  pushl $166
80107a40:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107a45:	e9 2a f3 ff ff       	jmp    80106d74 <alltraps>

80107a4a <vector167>:
.globl vector167
vector167:
  pushl $0
80107a4a:	6a 00                	push   $0x0
  pushl $167
80107a4c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107a51:	e9 1e f3 ff ff       	jmp    80106d74 <alltraps>

80107a56 <vector168>:
.globl vector168
vector168:
  pushl $0
80107a56:	6a 00                	push   $0x0
  pushl $168
80107a58:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107a5d:	e9 12 f3 ff ff       	jmp    80106d74 <alltraps>

80107a62 <vector169>:
.globl vector169
vector169:
  pushl $0
80107a62:	6a 00                	push   $0x0
  pushl $169
80107a64:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107a69:	e9 06 f3 ff ff       	jmp    80106d74 <alltraps>

80107a6e <vector170>:
.globl vector170
vector170:
  pushl $0
80107a6e:	6a 00                	push   $0x0
  pushl $170
80107a70:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107a75:	e9 fa f2 ff ff       	jmp    80106d74 <alltraps>

80107a7a <vector171>:
.globl vector171
vector171:
  pushl $0
80107a7a:	6a 00                	push   $0x0
  pushl $171
80107a7c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107a81:	e9 ee f2 ff ff       	jmp    80106d74 <alltraps>

80107a86 <vector172>:
.globl vector172
vector172:
  pushl $0
80107a86:	6a 00                	push   $0x0
  pushl $172
80107a88:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107a8d:	e9 e2 f2 ff ff       	jmp    80106d74 <alltraps>

80107a92 <vector173>:
.globl vector173
vector173:
  pushl $0
80107a92:	6a 00                	push   $0x0
  pushl $173
80107a94:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107a99:	e9 d6 f2 ff ff       	jmp    80106d74 <alltraps>

80107a9e <vector174>:
.globl vector174
vector174:
  pushl $0
80107a9e:	6a 00                	push   $0x0
  pushl $174
80107aa0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107aa5:	e9 ca f2 ff ff       	jmp    80106d74 <alltraps>

80107aaa <vector175>:
.globl vector175
vector175:
  pushl $0
80107aaa:	6a 00                	push   $0x0
  pushl $175
80107aac:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107ab1:	e9 be f2 ff ff       	jmp    80106d74 <alltraps>

80107ab6 <vector176>:
.globl vector176
vector176:
  pushl $0
80107ab6:	6a 00                	push   $0x0
  pushl $176
80107ab8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107abd:	e9 b2 f2 ff ff       	jmp    80106d74 <alltraps>

80107ac2 <vector177>:
.globl vector177
vector177:
  pushl $0
80107ac2:	6a 00                	push   $0x0
  pushl $177
80107ac4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107ac9:	e9 a6 f2 ff ff       	jmp    80106d74 <alltraps>

80107ace <vector178>:
.globl vector178
vector178:
  pushl $0
80107ace:	6a 00                	push   $0x0
  pushl $178
80107ad0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107ad5:	e9 9a f2 ff ff       	jmp    80106d74 <alltraps>

80107ada <vector179>:
.globl vector179
vector179:
  pushl $0
80107ada:	6a 00                	push   $0x0
  pushl $179
80107adc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107ae1:	e9 8e f2 ff ff       	jmp    80106d74 <alltraps>

80107ae6 <vector180>:
.globl vector180
vector180:
  pushl $0
80107ae6:	6a 00                	push   $0x0
  pushl $180
80107ae8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107aed:	e9 82 f2 ff ff       	jmp    80106d74 <alltraps>

80107af2 <vector181>:
.globl vector181
vector181:
  pushl $0
80107af2:	6a 00                	push   $0x0
  pushl $181
80107af4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107af9:	e9 76 f2 ff ff       	jmp    80106d74 <alltraps>

80107afe <vector182>:
.globl vector182
vector182:
  pushl $0
80107afe:	6a 00                	push   $0x0
  pushl $182
80107b00:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107b05:	e9 6a f2 ff ff       	jmp    80106d74 <alltraps>

80107b0a <vector183>:
.globl vector183
vector183:
  pushl $0
80107b0a:	6a 00                	push   $0x0
  pushl $183
80107b0c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107b11:	e9 5e f2 ff ff       	jmp    80106d74 <alltraps>

80107b16 <vector184>:
.globl vector184
vector184:
  pushl $0
80107b16:	6a 00                	push   $0x0
  pushl $184
80107b18:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107b1d:	e9 52 f2 ff ff       	jmp    80106d74 <alltraps>

80107b22 <vector185>:
.globl vector185
vector185:
  pushl $0
80107b22:	6a 00                	push   $0x0
  pushl $185
80107b24:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107b29:	e9 46 f2 ff ff       	jmp    80106d74 <alltraps>

80107b2e <vector186>:
.globl vector186
vector186:
  pushl $0
80107b2e:	6a 00                	push   $0x0
  pushl $186
80107b30:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107b35:	e9 3a f2 ff ff       	jmp    80106d74 <alltraps>

80107b3a <vector187>:
.globl vector187
vector187:
  pushl $0
80107b3a:	6a 00                	push   $0x0
  pushl $187
80107b3c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107b41:	e9 2e f2 ff ff       	jmp    80106d74 <alltraps>

80107b46 <vector188>:
.globl vector188
vector188:
  pushl $0
80107b46:	6a 00                	push   $0x0
  pushl $188
80107b48:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107b4d:	e9 22 f2 ff ff       	jmp    80106d74 <alltraps>

80107b52 <vector189>:
.globl vector189
vector189:
  pushl $0
80107b52:	6a 00                	push   $0x0
  pushl $189
80107b54:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107b59:	e9 16 f2 ff ff       	jmp    80106d74 <alltraps>

80107b5e <vector190>:
.globl vector190
vector190:
  pushl $0
80107b5e:	6a 00                	push   $0x0
  pushl $190
80107b60:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107b65:	e9 0a f2 ff ff       	jmp    80106d74 <alltraps>

80107b6a <vector191>:
.globl vector191
vector191:
  pushl $0
80107b6a:	6a 00                	push   $0x0
  pushl $191
80107b6c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107b71:	e9 fe f1 ff ff       	jmp    80106d74 <alltraps>

80107b76 <vector192>:
.globl vector192
vector192:
  pushl $0
80107b76:	6a 00                	push   $0x0
  pushl $192
80107b78:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107b7d:	e9 f2 f1 ff ff       	jmp    80106d74 <alltraps>

80107b82 <vector193>:
.globl vector193
vector193:
  pushl $0
80107b82:	6a 00                	push   $0x0
  pushl $193
80107b84:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107b89:	e9 e6 f1 ff ff       	jmp    80106d74 <alltraps>

80107b8e <vector194>:
.globl vector194
vector194:
  pushl $0
80107b8e:	6a 00                	push   $0x0
  pushl $194
80107b90:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107b95:	e9 da f1 ff ff       	jmp    80106d74 <alltraps>

80107b9a <vector195>:
.globl vector195
vector195:
  pushl $0
80107b9a:	6a 00                	push   $0x0
  pushl $195
80107b9c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107ba1:	e9 ce f1 ff ff       	jmp    80106d74 <alltraps>

80107ba6 <vector196>:
.globl vector196
vector196:
  pushl $0
80107ba6:	6a 00                	push   $0x0
  pushl $196
80107ba8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107bad:	e9 c2 f1 ff ff       	jmp    80106d74 <alltraps>

80107bb2 <vector197>:
.globl vector197
vector197:
  pushl $0
80107bb2:	6a 00                	push   $0x0
  pushl $197
80107bb4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107bb9:	e9 b6 f1 ff ff       	jmp    80106d74 <alltraps>

80107bbe <vector198>:
.globl vector198
vector198:
  pushl $0
80107bbe:	6a 00                	push   $0x0
  pushl $198
80107bc0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107bc5:	e9 aa f1 ff ff       	jmp    80106d74 <alltraps>

80107bca <vector199>:
.globl vector199
vector199:
  pushl $0
80107bca:	6a 00                	push   $0x0
  pushl $199
80107bcc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107bd1:	e9 9e f1 ff ff       	jmp    80106d74 <alltraps>

80107bd6 <vector200>:
.globl vector200
vector200:
  pushl $0
80107bd6:	6a 00                	push   $0x0
  pushl $200
80107bd8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107bdd:	e9 92 f1 ff ff       	jmp    80106d74 <alltraps>

80107be2 <vector201>:
.globl vector201
vector201:
  pushl $0
80107be2:	6a 00                	push   $0x0
  pushl $201
80107be4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107be9:	e9 86 f1 ff ff       	jmp    80106d74 <alltraps>

80107bee <vector202>:
.globl vector202
vector202:
  pushl $0
80107bee:	6a 00                	push   $0x0
  pushl $202
80107bf0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107bf5:	e9 7a f1 ff ff       	jmp    80106d74 <alltraps>

80107bfa <vector203>:
.globl vector203
vector203:
  pushl $0
80107bfa:	6a 00                	push   $0x0
  pushl $203
80107bfc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107c01:	e9 6e f1 ff ff       	jmp    80106d74 <alltraps>

80107c06 <vector204>:
.globl vector204
vector204:
  pushl $0
80107c06:	6a 00                	push   $0x0
  pushl $204
80107c08:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107c0d:	e9 62 f1 ff ff       	jmp    80106d74 <alltraps>

80107c12 <vector205>:
.globl vector205
vector205:
  pushl $0
80107c12:	6a 00                	push   $0x0
  pushl $205
80107c14:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107c19:	e9 56 f1 ff ff       	jmp    80106d74 <alltraps>

80107c1e <vector206>:
.globl vector206
vector206:
  pushl $0
80107c1e:	6a 00                	push   $0x0
  pushl $206
80107c20:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107c25:	e9 4a f1 ff ff       	jmp    80106d74 <alltraps>

80107c2a <vector207>:
.globl vector207
vector207:
  pushl $0
80107c2a:	6a 00                	push   $0x0
  pushl $207
80107c2c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107c31:	e9 3e f1 ff ff       	jmp    80106d74 <alltraps>

80107c36 <vector208>:
.globl vector208
vector208:
  pushl $0
80107c36:	6a 00                	push   $0x0
  pushl $208
80107c38:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107c3d:	e9 32 f1 ff ff       	jmp    80106d74 <alltraps>

80107c42 <vector209>:
.globl vector209
vector209:
  pushl $0
80107c42:	6a 00                	push   $0x0
  pushl $209
80107c44:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107c49:	e9 26 f1 ff ff       	jmp    80106d74 <alltraps>

80107c4e <vector210>:
.globl vector210
vector210:
  pushl $0
80107c4e:	6a 00                	push   $0x0
  pushl $210
80107c50:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107c55:	e9 1a f1 ff ff       	jmp    80106d74 <alltraps>

80107c5a <vector211>:
.globl vector211
vector211:
  pushl $0
80107c5a:	6a 00                	push   $0x0
  pushl $211
80107c5c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107c61:	e9 0e f1 ff ff       	jmp    80106d74 <alltraps>

80107c66 <vector212>:
.globl vector212
vector212:
  pushl $0
80107c66:	6a 00                	push   $0x0
  pushl $212
80107c68:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107c6d:	e9 02 f1 ff ff       	jmp    80106d74 <alltraps>

80107c72 <vector213>:
.globl vector213
vector213:
  pushl $0
80107c72:	6a 00                	push   $0x0
  pushl $213
80107c74:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107c79:	e9 f6 f0 ff ff       	jmp    80106d74 <alltraps>

80107c7e <vector214>:
.globl vector214
vector214:
  pushl $0
80107c7e:	6a 00                	push   $0x0
  pushl $214
80107c80:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107c85:	e9 ea f0 ff ff       	jmp    80106d74 <alltraps>

80107c8a <vector215>:
.globl vector215
vector215:
  pushl $0
80107c8a:	6a 00                	push   $0x0
  pushl $215
80107c8c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107c91:	e9 de f0 ff ff       	jmp    80106d74 <alltraps>

80107c96 <vector216>:
.globl vector216
vector216:
  pushl $0
80107c96:	6a 00                	push   $0x0
  pushl $216
80107c98:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107c9d:	e9 d2 f0 ff ff       	jmp    80106d74 <alltraps>

80107ca2 <vector217>:
.globl vector217
vector217:
  pushl $0
80107ca2:	6a 00                	push   $0x0
  pushl $217
80107ca4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107ca9:	e9 c6 f0 ff ff       	jmp    80106d74 <alltraps>

80107cae <vector218>:
.globl vector218
vector218:
  pushl $0
80107cae:	6a 00                	push   $0x0
  pushl $218
80107cb0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107cb5:	e9 ba f0 ff ff       	jmp    80106d74 <alltraps>

80107cba <vector219>:
.globl vector219
vector219:
  pushl $0
80107cba:	6a 00                	push   $0x0
  pushl $219
80107cbc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107cc1:	e9 ae f0 ff ff       	jmp    80106d74 <alltraps>

80107cc6 <vector220>:
.globl vector220
vector220:
  pushl $0
80107cc6:	6a 00                	push   $0x0
  pushl $220
80107cc8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107ccd:	e9 a2 f0 ff ff       	jmp    80106d74 <alltraps>

80107cd2 <vector221>:
.globl vector221
vector221:
  pushl $0
80107cd2:	6a 00                	push   $0x0
  pushl $221
80107cd4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107cd9:	e9 96 f0 ff ff       	jmp    80106d74 <alltraps>

80107cde <vector222>:
.globl vector222
vector222:
  pushl $0
80107cde:	6a 00                	push   $0x0
  pushl $222
80107ce0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107ce5:	e9 8a f0 ff ff       	jmp    80106d74 <alltraps>

80107cea <vector223>:
.globl vector223
vector223:
  pushl $0
80107cea:	6a 00                	push   $0x0
  pushl $223
80107cec:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107cf1:	e9 7e f0 ff ff       	jmp    80106d74 <alltraps>

80107cf6 <vector224>:
.globl vector224
vector224:
  pushl $0
80107cf6:	6a 00                	push   $0x0
  pushl $224
80107cf8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107cfd:	e9 72 f0 ff ff       	jmp    80106d74 <alltraps>

80107d02 <vector225>:
.globl vector225
vector225:
  pushl $0
80107d02:	6a 00                	push   $0x0
  pushl $225
80107d04:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107d09:	e9 66 f0 ff ff       	jmp    80106d74 <alltraps>

80107d0e <vector226>:
.globl vector226
vector226:
  pushl $0
80107d0e:	6a 00                	push   $0x0
  pushl $226
80107d10:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107d15:	e9 5a f0 ff ff       	jmp    80106d74 <alltraps>

80107d1a <vector227>:
.globl vector227
vector227:
  pushl $0
80107d1a:	6a 00                	push   $0x0
  pushl $227
80107d1c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107d21:	e9 4e f0 ff ff       	jmp    80106d74 <alltraps>

80107d26 <vector228>:
.globl vector228
vector228:
  pushl $0
80107d26:	6a 00                	push   $0x0
  pushl $228
80107d28:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107d2d:	e9 42 f0 ff ff       	jmp    80106d74 <alltraps>

80107d32 <vector229>:
.globl vector229
vector229:
  pushl $0
80107d32:	6a 00                	push   $0x0
  pushl $229
80107d34:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107d39:	e9 36 f0 ff ff       	jmp    80106d74 <alltraps>

80107d3e <vector230>:
.globl vector230
vector230:
  pushl $0
80107d3e:	6a 00                	push   $0x0
  pushl $230
80107d40:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107d45:	e9 2a f0 ff ff       	jmp    80106d74 <alltraps>

80107d4a <vector231>:
.globl vector231
vector231:
  pushl $0
80107d4a:	6a 00                	push   $0x0
  pushl $231
80107d4c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107d51:	e9 1e f0 ff ff       	jmp    80106d74 <alltraps>

80107d56 <vector232>:
.globl vector232
vector232:
  pushl $0
80107d56:	6a 00                	push   $0x0
  pushl $232
80107d58:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107d5d:	e9 12 f0 ff ff       	jmp    80106d74 <alltraps>

80107d62 <vector233>:
.globl vector233
vector233:
  pushl $0
80107d62:	6a 00                	push   $0x0
  pushl $233
80107d64:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107d69:	e9 06 f0 ff ff       	jmp    80106d74 <alltraps>

80107d6e <vector234>:
.globl vector234
vector234:
  pushl $0
80107d6e:	6a 00                	push   $0x0
  pushl $234
80107d70:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107d75:	e9 fa ef ff ff       	jmp    80106d74 <alltraps>

80107d7a <vector235>:
.globl vector235
vector235:
  pushl $0
80107d7a:	6a 00                	push   $0x0
  pushl $235
80107d7c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107d81:	e9 ee ef ff ff       	jmp    80106d74 <alltraps>

80107d86 <vector236>:
.globl vector236
vector236:
  pushl $0
80107d86:	6a 00                	push   $0x0
  pushl $236
80107d88:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107d8d:	e9 e2 ef ff ff       	jmp    80106d74 <alltraps>

80107d92 <vector237>:
.globl vector237
vector237:
  pushl $0
80107d92:	6a 00                	push   $0x0
  pushl $237
80107d94:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107d99:	e9 d6 ef ff ff       	jmp    80106d74 <alltraps>

80107d9e <vector238>:
.globl vector238
vector238:
  pushl $0
80107d9e:	6a 00                	push   $0x0
  pushl $238
80107da0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107da5:	e9 ca ef ff ff       	jmp    80106d74 <alltraps>

80107daa <vector239>:
.globl vector239
vector239:
  pushl $0
80107daa:	6a 00                	push   $0x0
  pushl $239
80107dac:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107db1:	e9 be ef ff ff       	jmp    80106d74 <alltraps>

80107db6 <vector240>:
.globl vector240
vector240:
  pushl $0
80107db6:	6a 00                	push   $0x0
  pushl $240
80107db8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107dbd:	e9 b2 ef ff ff       	jmp    80106d74 <alltraps>

80107dc2 <vector241>:
.globl vector241
vector241:
  pushl $0
80107dc2:	6a 00                	push   $0x0
  pushl $241
80107dc4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107dc9:	e9 a6 ef ff ff       	jmp    80106d74 <alltraps>

80107dce <vector242>:
.globl vector242
vector242:
  pushl $0
80107dce:	6a 00                	push   $0x0
  pushl $242
80107dd0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107dd5:	e9 9a ef ff ff       	jmp    80106d74 <alltraps>

80107dda <vector243>:
.globl vector243
vector243:
  pushl $0
80107dda:	6a 00                	push   $0x0
  pushl $243
80107ddc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107de1:	e9 8e ef ff ff       	jmp    80106d74 <alltraps>

80107de6 <vector244>:
.globl vector244
vector244:
  pushl $0
80107de6:	6a 00                	push   $0x0
  pushl $244
80107de8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107ded:	e9 82 ef ff ff       	jmp    80106d74 <alltraps>

80107df2 <vector245>:
.globl vector245
vector245:
  pushl $0
80107df2:	6a 00                	push   $0x0
  pushl $245
80107df4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107df9:	e9 76 ef ff ff       	jmp    80106d74 <alltraps>

80107dfe <vector246>:
.globl vector246
vector246:
  pushl $0
80107dfe:	6a 00                	push   $0x0
  pushl $246
80107e00:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107e05:	e9 6a ef ff ff       	jmp    80106d74 <alltraps>

80107e0a <vector247>:
.globl vector247
vector247:
  pushl $0
80107e0a:	6a 00                	push   $0x0
  pushl $247
80107e0c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107e11:	e9 5e ef ff ff       	jmp    80106d74 <alltraps>

80107e16 <vector248>:
.globl vector248
vector248:
  pushl $0
80107e16:	6a 00                	push   $0x0
  pushl $248
80107e18:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107e1d:	e9 52 ef ff ff       	jmp    80106d74 <alltraps>

80107e22 <vector249>:
.globl vector249
vector249:
  pushl $0
80107e22:	6a 00                	push   $0x0
  pushl $249
80107e24:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107e29:	e9 46 ef ff ff       	jmp    80106d74 <alltraps>

80107e2e <vector250>:
.globl vector250
vector250:
  pushl $0
80107e2e:	6a 00                	push   $0x0
  pushl $250
80107e30:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107e35:	e9 3a ef ff ff       	jmp    80106d74 <alltraps>

80107e3a <vector251>:
.globl vector251
vector251:
  pushl $0
80107e3a:	6a 00                	push   $0x0
  pushl $251
80107e3c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107e41:	e9 2e ef ff ff       	jmp    80106d74 <alltraps>

80107e46 <vector252>:
.globl vector252
vector252:
  pushl $0
80107e46:	6a 00                	push   $0x0
  pushl $252
80107e48:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107e4d:	e9 22 ef ff ff       	jmp    80106d74 <alltraps>

80107e52 <vector253>:
.globl vector253
vector253:
  pushl $0
80107e52:	6a 00                	push   $0x0
  pushl $253
80107e54:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107e59:	e9 16 ef ff ff       	jmp    80106d74 <alltraps>

80107e5e <vector254>:
.globl vector254
vector254:
  pushl $0
80107e5e:	6a 00                	push   $0x0
  pushl $254
80107e60:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107e65:	e9 0a ef ff ff       	jmp    80106d74 <alltraps>

80107e6a <vector255>:
.globl vector255
vector255:
  pushl $0
80107e6a:	6a 00                	push   $0x0
  pushl $255
80107e6c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107e71:	e9 fe ee ff ff       	jmp    80106d74 <alltraps>
	...

80107e78 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107e78:	55                   	push   %ebp
80107e79:	89 e5                	mov    %esp,%ebp
80107e7b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e81:	83 e8 01             	sub    $0x1,%eax
80107e84:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107e88:	8b 45 08             	mov    0x8(%ebp),%eax
80107e8b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107e8f:	8b 45 08             	mov    0x8(%ebp),%eax
80107e92:	c1 e8 10             	shr    $0x10,%eax
80107e95:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107e99:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107e9c:	0f 01 10             	lgdtl  (%eax)
}
80107e9f:	c9                   	leave  
80107ea0:	c3                   	ret    

80107ea1 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107ea1:	55                   	push   %ebp
80107ea2:	89 e5                	mov    %esp,%ebp
80107ea4:	83 ec 04             	sub    $0x4,%esp
80107ea7:	8b 45 08             	mov    0x8(%ebp),%eax
80107eaa:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107eae:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107eb2:	0f 00 d8             	ltr    %ax
}
80107eb5:	c9                   	leave  
80107eb6:	c3                   	ret    

80107eb7 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107eb7:	55                   	push   %ebp
80107eb8:	89 e5                	mov    %esp,%ebp
80107eba:	83 ec 04             	sub    $0x4,%esp
80107ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80107ec0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107ec4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107ec8:	8e e8                	mov    %eax,%gs
}
80107eca:	c9                   	leave  
80107ecb:	c3                   	ret    

80107ecc <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107ecc:	55                   	push   %ebp
80107ecd:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed2:	0f 22 d8             	mov    %eax,%cr3
}
80107ed5:	5d                   	pop    %ebp
80107ed6:	c3                   	ret    

80107ed7 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107ed7:	55                   	push   %ebp
80107ed8:	89 e5                	mov    %esp,%ebp
80107eda:	8b 45 08             	mov    0x8(%ebp),%eax
80107edd:	05 00 00 00 80       	add    $0x80000000,%eax
80107ee2:	5d                   	pop    %ebp
80107ee3:	c3                   	ret    

80107ee4 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107ee4:	55                   	push   %ebp
80107ee5:	89 e5                	mov    %esp,%ebp
80107ee7:	8b 45 08             	mov    0x8(%ebp),%eax
80107eea:	05 00 00 00 80       	add    $0x80000000,%eax
80107eef:	5d                   	pop    %ebp
80107ef0:	c3                   	ret    

80107ef1 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107ef1:	55                   	push   %ebp
80107ef2:	89 e5                	mov    %esp,%ebp
80107ef4:	53                   	push   %ebx
80107ef5:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107ef8:	e8 90 af ff ff       	call   80102e8d <cpunum>
80107efd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107f03:	05 60 09 11 80       	add    $0x80110960,%eax
80107f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0e:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f17:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f20:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f27:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f2b:	83 e2 f0             	and    $0xfffffff0,%edx
80107f2e:	83 ca 0a             	or     $0xa,%edx
80107f31:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f37:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f3b:	83 ca 10             	or     $0x10,%edx
80107f3e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f44:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f48:	83 e2 9f             	and    $0xffffff9f,%edx
80107f4b:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f51:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f55:	83 ca 80             	or     $0xffffff80,%edx
80107f58:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f62:	83 ca 0f             	or     $0xf,%edx
80107f65:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f6f:	83 e2 ef             	and    $0xffffffef,%edx
80107f72:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f78:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f7c:	83 e2 df             	and    $0xffffffdf,%edx
80107f7f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f85:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f89:	83 ca 40             	or     $0x40,%edx
80107f8c:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f92:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f96:	83 ca 80             	or     $0xffffff80,%edx
80107f99:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9f:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa6:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107fad:	ff ff 
80107faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb2:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107fb9:	00 00 
80107fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbe:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107fcf:	83 e2 f0             	and    $0xfffffff0,%edx
80107fd2:	83 ca 02             	or     $0x2,%edx
80107fd5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fde:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107fe5:	83 ca 10             	or     $0x10,%edx
80107fe8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ff8:	83 e2 9f             	and    $0xffffff9f,%edx
80107ffb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108004:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010800b:	83 ca 80             	or     $0xffffff80,%edx
8010800e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108017:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010801e:	83 ca 0f             	or     $0xf,%edx
80108021:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108027:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108031:	83 e2 ef             	and    $0xffffffef,%edx
80108034:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010803a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108044:	83 e2 df             	and    $0xffffffdf,%edx
80108047:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010804d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108050:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108057:	83 ca 40             	or     $0x40,%edx
8010805a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108060:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108063:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010806a:	83 ca 80             	or     $0xffffff80,%edx
8010806d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108073:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108076:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010807d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108080:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108087:	ff ff 
80108089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808c:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108093:	00 00 
80108095:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108098:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010809f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801080a9:	83 e2 f0             	and    $0xfffffff0,%edx
801080ac:	83 ca 0a             	or     $0xa,%edx
801080af:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801080bf:	83 ca 10             	or     $0x10,%edx
801080c2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cb:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801080d2:	83 ca 60             	or     $0x60,%edx
801080d5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080de:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801080e5:	83 ca 80             	or     $0xffffff80,%edx
801080e8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801080f8:	83 ca 0f             	or     $0xf,%edx
801080fb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108104:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010810b:	83 e2 ef             	and    $0xffffffef,%edx
8010810e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108117:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010811e:	83 e2 df             	and    $0xffffffdf,%edx
80108121:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108131:	83 ca 40             	or     $0x40,%edx
80108134:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010813a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108144:	83 ca 80             	or     $0xffffff80,%edx
80108147:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010814d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108150:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815a:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108161:	ff ff 
80108163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108166:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010816d:	00 00 
8010816f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108172:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108179:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108183:	83 e2 f0             	and    $0xfffffff0,%edx
80108186:	83 ca 02             	or     $0x2,%edx
80108189:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010818f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108192:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108199:	83 ca 10             	or     $0x10,%edx
8010819c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081ac:	83 ca 60             	or     $0x60,%edx
801081af:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081bf:	83 ca 80             	or     $0xffffff80,%edx
801081c2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801081d2:	83 ca 0f             	or     $0xf,%edx
801081d5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801081db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081de:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801081e5:	83 e2 ef             	and    $0xffffffef,%edx
801081e8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801081ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801081f8:	83 e2 df             	and    $0xffffffdf,%edx
801081fb:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108201:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108204:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010820b:	83 ca 40             	or     $0x40,%edx
8010820e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108217:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010821e:	83 ca 80             	or     $0xffffff80,%edx
80108221:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108231:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108234:	05 b4 00 00 00       	add    $0xb4,%eax
80108239:	89 c3                	mov    %eax,%ebx
8010823b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823e:	05 b4 00 00 00       	add    $0xb4,%eax
80108243:	c1 e8 10             	shr    $0x10,%eax
80108246:	89 c1                	mov    %eax,%ecx
80108248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010824b:	05 b4 00 00 00       	add    $0xb4,%eax
80108250:	c1 e8 18             	shr    $0x18,%eax
80108253:	89 c2                	mov    %eax,%edx
80108255:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108258:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010825f:	00 00 
80108261:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108264:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010826b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826e:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80108274:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108277:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010827e:	83 e1 f0             	and    $0xfffffff0,%ecx
80108281:	83 c9 02             	or     $0x2,%ecx
80108284:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010828a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828d:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108294:	83 c9 10             	or     $0x10,%ecx
80108297:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010829d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a0:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801082a7:	83 e1 9f             	and    $0xffffff9f,%ecx
801082aa:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b3:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801082ba:	83 c9 80             	or     $0xffffff80,%ecx
801082bd:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c6:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801082cd:	83 e1 f0             	and    $0xfffffff0,%ecx
801082d0:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801082d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d9:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801082e0:	83 e1 ef             	and    $0xffffffef,%ecx
801082e3:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801082e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ec:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801082f3:	83 e1 df             	and    $0xffffffdf,%ecx
801082f6:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801082fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ff:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108306:	83 c9 40             	or     $0x40,%ecx
80108309:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010830f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108312:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108319:	83 c9 80             	or     $0xffffff80,%ecx
8010831c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108325:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010832b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832e:	83 c0 70             	add    $0x70,%eax
80108331:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80108338:	00 
80108339:	89 04 24             	mov    %eax,(%esp)
8010833c:	e8 37 fb ff ff       	call   80107e78 <lgdt>
  loadgs(SEG_KCPU << 3);
80108341:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80108348:	e8 6a fb ff ff       	call   80107eb7 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
8010834d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108350:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108356:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010835d:	00 00 00 00 
}
80108361:	83 c4 24             	add    $0x24,%esp
80108364:	5b                   	pop    %ebx
80108365:	5d                   	pop    %ebp
80108366:	c3                   	ret    

80108367 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108367:	55                   	push   %ebp
80108368:	89 e5                	mov    %esp,%ebp
8010836a:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010836d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108370:	c1 e8 16             	shr    $0x16,%eax
80108373:	c1 e0 02             	shl    $0x2,%eax
80108376:	03 45 08             	add    0x8(%ebp),%eax
80108379:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010837c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010837f:	8b 00                	mov    (%eax),%eax
80108381:	83 e0 01             	and    $0x1,%eax
80108384:	84 c0                	test   %al,%al
80108386:	74 17                	je     8010839f <walkpgdir+0x38>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108388:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010838b:	8b 00                	mov    (%eax),%eax
8010838d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108392:	89 04 24             	mov    %eax,(%esp)
80108395:	e8 4a fb ff ff       	call   80107ee4 <p2v>
8010839a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010839d:	eb 4b                	jmp    801083ea <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010839f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801083a3:	74 0e                	je     801083b3 <walkpgdir+0x4c>
801083a5:	e8 55 a7 ff ff       	call   80102aff <kalloc>
801083aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801083b1:	75 07                	jne    801083ba <walkpgdir+0x53>
      return 0;
801083b3:	b8 00 00 00 00       	mov    $0x0,%eax
801083b8:	eb 41                	jmp    801083fb <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801083ba:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083c1:	00 
801083c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801083c9:	00 
801083ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083cd:	89 04 24             	mov    %eax,(%esp)
801083d0:	e8 f1 d3 ff ff       	call   801057c6 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801083d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d8:	89 04 24             	mov    %eax,(%esp)
801083db:	e8 f7 fa ff ff       	call   80107ed7 <v2p>
801083e0:	89 c2                	mov    %eax,%edx
801083e2:	83 ca 07             	or     $0x7,%edx
801083e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083e8:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801083ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801083ed:	c1 e8 0c             	shr    $0xc,%eax
801083f0:	25 ff 03 00 00       	and    $0x3ff,%eax
801083f5:	c1 e0 02             	shl    $0x2,%eax
801083f8:	03 45 f4             	add    -0xc(%ebp),%eax
}
801083fb:	c9                   	leave  
801083fc:	c3                   	ret    

801083fd <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801083fd:	55                   	push   %ebp
801083fe:	89 e5                	mov    %esp,%ebp
80108400:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108403:	8b 45 0c             	mov    0xc(%ebp),%eax
80108406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010840b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010840e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108411:	03 45 10             	add    0x10(%ebp),%eax
80108414:	83 e8 01             	sub    $0x1,%eax
80108417:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010841c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010841f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80108426:	00 
80108427:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010842a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010842e:	8b 45 08             	mov    0x8(%ebp),%eax
80108431:	89 04 24             	mov    %eax,(%esp)
80108434:	e8 2e ff ff ff       	call   80108367 <walkpgdir>
80108439:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010843c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108440:	75 07                	jne    80108449 <mappages+0x4c>
      return -1;
80108442:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108447:	eb 46                	jmp    8010848f <mappages+0x92>
    if(*pte & PTE_P)
80108449:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010844c:	8b 00                	mov    (%eax),%eax
8010844e:	83 e0 01             	and    $0x1,%eax
80108451:	84 c0                	test   %al,%al
80108453:	74 0c                	je     80108461 <mappages+0x64>
      panic("remap");
80108455:	c7 04 24 24 94 10 80 	movl   $0x80109424,(%esp)
8010845c:	e8 dc 80 ff ff       	call   8010053d <panic>
    *pte = pa | perm | PTE_P;
80108461:	8b 45 18             	mov    0x18(%ebp),%eax
80108464:	0b 45 14             	or     0x14(%ebp),%eax
80108467:	89 c2                	mov    %eax,%edx
80108469:	83 ca 01             	or     $0x1,%edx
8010846c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010846f:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108474:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108477:	74 10                	je     80108489 <mappages+0x8c>
      break;
    a += PGSIZE;
80108479:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108480:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108487:	eb 96                	jmp    8010841f <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108489:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010848a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010848f:	c9                   	leave  
80108490:	c3                   	ret    

80108491 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm()
{
80108491:	55                   	push   %ebp
80108492:	89 e5                	mov    %esp,%ebp
80108494:	53                   	push   %ebx
80108495:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108498:	e8 62 a6 ff ff       	call   80102aff <kalloc>
8010849d:	89 45 f0             	mov    %eax,-0x10(%ebp)
801084a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084a4:	75 0a                	jne    801084b0 <setupkvm+0x1f>
    return 0;
801084a6:	b8 00 00 00 00       	mov    $0x0,%eax
801084ab:	e9 98 00 00 00       	jmp    80108548 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
801084b0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801084b7:	00 
801084b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801084bf:	00 
801084c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084c3:	89 04 24             	mov    %eax,(%esp)
801084c6:	e8 fb d2 ff ff       	call   801057c6 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801084cb:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801084d2:	e8 0d fa ff ff       	call   80107ee4 <p2v>
801084d7:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801084dc:	76 0c                	jbe    801084ea <setupkvm+0x59>
    panic("PHYSTOP too high");
801084de:	c7 04 24 2a 94 10 80 	movl   $0x8010942a,(%esp)
801084e5:	e8 53 80 ff ff       	call   8010053d <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801084ea:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801084f1:	eb 49                	jmp    8010853c <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
801084f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801084f6:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801084f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801084fc:	8b 50 04             	mov    0x4(%eax),%edx
801084ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108502:	8b 58 08             	mov    0x8(%eax),%ebx
80108505:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108508:	8b 40 04             	mov    0x4(%eax),%eax
8010850b:	29 c3                	sub    %eax,%ebx
8010850d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108510:	8b 00                	mov    (%eax),%eax
80108512:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108516:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010851a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010851e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108522:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108525:	89 04 24             	mov    %eax,(%esp)
80108528:	e8 d0 fe ff ff       	call   801083fd <mappages>
8010852d:	85 c0                	test   %eax,%eax
8010852f:	79 07                	jns    80108538 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108531:	b8 00 00 00 00       	mov    $0x0,%eax
80108536:	eb 10                	jmp    80108548 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108538:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010853c:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108543:	72 ae                	jb     801084f3 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108545:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108548:	83 c4 34             	add    $0x34,%esp
8010854b:	5b                   	pop    %ebx
8010854c:	5d                   	pop    %ebp
8010854d:	c3                   	ret    

8010854e <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010854e:	55                   	push   %ebp
8010854f:	89 e5                	mov    %esp,%ebp
80108551:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108554:	e8 38 ff ff ff       	call   80108491 <setupkvm>
80108559:	a3 78 63 11 80       	mov    %eax,0x80116378
  switchkvm();
8010855e:	e8 02 00 00 00       	call   80108565 <switchkvm>
}
80108563:	c9                   	leave  
80108564:	c3                   	ret    

80108565 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108565:	55                   	push   %ebp
80108566:	89 e5                	mov    %esp,%ebp
80108568:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010856b:	a1 78 63 11 80       	mov    0x80116378,%eax
80108570:	89 04 24             	mov    %eax,(%esp)
80108573:	e8 5f f9 ff ff       	call   80107ed7 <v2p>
80108578:	89 04 24             	mov    %eax,(%esp)
8010857b:	e8 4c f9 ff ff       	call   80107ecc <lcr3>
}
80108580:	c9                   	leave  
80108581:	c3                   	ret    

80108582 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108582:	55                   	push   %ebp
80108583:	89 e5                	mov    %esp,%ebp
80108585:	53                   	push   %ebx
80108586:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108589:	e8 31 d1 ff ff       	call   801056bf <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010858e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108594:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010859b:	83 c2 08             	add    $0x8,%edx
8010859e:	89 d3                	mov    %edx,%ebx
801085a0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085a7:	83 c2 08             	add    $0x8,%edx
801085aa:	c1 ea 10             	shr    $0x10,%edx
801085ad:	89 d1                	mov    %edx,%ecx
801085af:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085b6:	83 c2 08             	add    $0x8,%edx
801085b9:	c1 ea 18             	shr    $0x18,%edx
801085bc:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801085c3:	67 00 
801085c5:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801085cc:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801085d2:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801085d9:	83 e1 f0             	and    $0xfffffff0,%ecx
801085dc:	83 c9 09             	or     $0x9,%ecx
801085df:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801085e5:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801085ec:	83 c9 10             	or     $0x10,%ecx
801085ef:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801085f5:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801085fc:	83 e1 9f             	and    $0xffffff9f,%ecx
801085ff:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108605:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010860c:	83 c9 80             	or     $0xffffff80,%ecx
8010860f:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108615:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010861c:	83 e1 f0             	and    $0xfffffff0,%ecx
8010861f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108625:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010862c:	83 e1 ef             	and    $0xffffffef,%ecx
8010862f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108635:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010863c:	83 e1 df             	and    $0xffffffdf,%ecx
8010863f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108645:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010864c:	83 c9 40             	or     $0x40,%ecx
8010864f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108655:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010865c:	83 e1 7f             	and    $0x7f,%ecx
8010865f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108665:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010866b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108671:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108678:	83 e2 ef             	and    $0xffffffef,%edx
8010867b:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108681:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108687:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010868d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108693:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010869a:	8b 52 08             	mov    0x8(%edx),%edx
8010869d:	81 c2 00 10 00 00    	add    $0x1000,%edx
801086a3:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801086a6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801086ad:	e8 ef f7 ff ff       	call   80107ea1 <ltr>
  if(p->pgdir == 0)
801086b2:	8b 45 08             	mov    0x8(%ebp),%eax
801086b5:	8b 40 04             	mov    0x4(%eax),%eax
801086b8:	85 c0                	test   %eax,%eax
801086ba:	75 0c                	jne    801086c8 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
801086bc:	c7 04 24 3b 94 10 80 	movl   $0x8010943b,(%esp)
801086c3:	e8 75 7e ff ff       	call   8010053d <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801086c8:	8b 45 08             	mov    0x8(%ebp),%eax
801086cb:	8b 40 04             	mov    0x4(%eax),%eax
801086ce:	89 04 24             	mov    %eax,(%esp)
801086d1:	e8 01 f8 ff ff       	call   80107ed7 <v2p>
801086d6:	89 04 24             	mov    %eax,(%esp)
801086d9:	e8 ee f7 ff ff       	call   80107ecc <lcr3>
  popcli();
801086de:	e8 24 d0 ff ff       	call   80105707 <popcli>
}
801086e3:	83 c4 14             	add    $0x14,%esp
801086e6:	5b                   	pop    %ebx
801086e7:	5d                   	pop    %ebp
801086e8:	c3                   	ret    

801086e9 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801086e9:	55                   	push   %ebp
801086ea:	89 e5                	mov    %esp,%ebp
801086ec:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801086ef:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801086f6:	76 0c                	jbe    80108704 <inituvm+0x1b>
    panic("inituvm: more than a page");
801086f8:	c7 04 24 4f 94 10 80 	movl   $0x8010944f,(%esp)
801086ff:	e8 39 7e ff ff       	call   8010053d <panic>
  mem = kalloc();
80108704:	e8 f6 a3 ff ff       	call   80102aff <kalloc>
80108709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010870c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108713:	00 
80108714:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010871b:	00 
8010871c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010871f:	89 04 24             	mov    %eax,(%esp)
80108722:	e8 9f d0 ff ff       	call   801057c6 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010872a:	89 04 24             	mov    %eax,(%esp)
8010872d:	e8 a5 f7 ff ff       	call   80107ed7 <v2p>
80108732:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108739:	00 
8010873a:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010873e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108745:	00 
80108746:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010874d:	00 
8010874e:	8b 45 08             	mov    0x8(%ebp),%eax
80108751:	89 04 24             	mov    %eax,(%esp)
80108754:	e8 a4 fc ff ff       	call   801083fd <mappages>
  memmove(mem, init, sz);
80108759:	8b 45 10             	mov    0x10(%ebp),%eax
8010875c:	89 44 24 08          	mov    %eax,0x8(%esp)
80108760:	8b 45 0c             	mov    0xc(%ebp),%eax
80108763:	89 44 24 04          	mov    %eax,0x4(%esp)
80108767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010876a:	89 04 24             	mov    %eax,(%esp)
8010876d:	e8 27 d1 ff ff       	call   80105899 <memmove>
}
80108772:	c9                   	leave  
80108773:	c3                   	ret    

80108774 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108774:	55                   	push   %ebp
80108775:	89 e5                	mov    %esp,%ebp
80108777:	53                   	push   %ebx
80108778:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010877b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010877e:	25 ff 0f 00 00       	and    $0xfff,%eax
80108783:	85 c0                	test   %eax,%eax
80108785:	74 0c                	je     80108793 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108787:	c7 04 24 6c 94 10 80 	movl   $0x8010946c,(%esp)
8010878e:	e8 aa 7d ff ff       	call   8010053d <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108793:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010879a:	e9 ad 00 00 00       	jmp    8010884c <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010879f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801087a5:	01 d0                	add    %edx,%eax
801087a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087ae:	00 
801087af:	89 44 24 04          	mov    %eax,0x4(%esp)
801087b3:	8b 45 08             	mov    0x8(%ebp),%eax
801087b6:	89 04 24             	mov    %eax,(%esp)
801087b9:	e8 a9 fb ff ff       	call   80108367 <walkpgdir>
801087be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801087c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087c5:	75 0c                	jne    801087d3 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
801087c7:	c7 04 24 8f 94 10 80 	movl   $0x8010948f,(%esp)
801087ce:	e8 6a 7d ff ff       	call   8010053d <panic>
    pa = PTE_ADDR(*pte);
801087d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087d6:	8b 00                	mov    (%eax),%eax
801087d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801087e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e3:	8b 55 18             	mov    0x18(%ebp),%edx
801087e6:	89 d1                	mov    %edx,%ecx
801087e8:	29 c1                	sub    %eax,%ecx
801087ea:	89 c8                	mov    %ecx,%eax
801087ec:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801087f1:	77 11                	ja     80108804 <loaduvm+0x90>
      n = sz - i;
801087f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087f6:	8b 55 18             	mov    0x18(%ebp),%edx
801087f9:	89 d1                	mov    %edx,%ecx
801087fb:	29 c1                	sub    %eax,%ecx
801087fd:	89 c8                	mov    %ecx,%eax
801087ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108802:	eb 07                	jmp    8010880b <loaduvm+0x97>
    else
      n = PGSIZE;
80108804:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010880b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010880e:	8b 55 14             	mov    0x14(%ebp),%edx
80108811:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108814:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108817:	89 04 24             	mov    %eax,(%esp)
8010881a:	e8 c5 f6 ff ff       	call   80107ee4 <p2v>
8010881f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108822:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108826:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010882a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010882e:	8b 45 10             	mov    0x10(%ebp),%eax
80108831:	89 04 24             	mov    %eax,(%esp)
80108834:	e8 25 95 ff ff       	call   80101d5e <readi>
80108839:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010883c:	74 07                	je     80108845 <loaduvm+0xd1>
      return -1;
8010883e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108843:	eb 18                	jmp    8010885d <loaduvm+0xe9>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108845:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010884c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010884f:	3b 45 18             	cmp    0x18(%ebp),%eax
80108852:	0f 82 47 ff ff ff    	jb     8010879f <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108858:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010885d:	83 c4 24             	add    $0x24,%esp
80108860:	5b                   	pop    %ebx
80108861:	5d                   	pop    %ebp
80108862:	c3                   	ret    

80108863 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108863:	55                   	push   %ebp
80108864:	89 e5                	mov    %esp,%ebp
80108866:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108869:	8b 45 10             	mov    0x10(%ebp),%eax
8010886c:	85 c0                	test   %eax,%eax
8010886e:	79 0a                	jns    8010887a <allocuvm+0x17>
    return 0;
80108870:	b8 00 00 00 00       	mov    $0x0,%eax
80108875:	e9 c1 00 00 00       	jmp    8010893b <allocuvm+0xd8>
  if(newsz < oldsz)
8010887a:	8b 45 10             	mov    0x10(%ebp),%eax
8010887d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108880:	73 08                	jae    8010888a <allocuvm+0x27>
    return oldsz;
80108882:	8b 45 0c             	mov    0xc(%ebp),%eax
80108885:	e9 b1 00 00 00       	jmp    8010893b <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
8010888a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010888d:	05 ff 0f 00 00       	add    $0xfff,%eax
80108892:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108897:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010889a:	e9 8d 00 00 00       	jmp    8010892c <allocuvm+0xc9>
    mem = kalloc();
8010889f:	e8 5b a2 ff ff       	call   80102aff <kalloc>
801088a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801088a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801088ab:	75 2c                	jne    801088d9 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801088ad:	c7 04 24 ad 94 10 80 	movl   $0x801094ad,(%esp)
801088b4:	e8 e8 7a ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801088b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801088bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801088c0:	8b 45 10             	mov    0x10(%ebp),%eax
801088c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801088c7:	8b 45 08             	mov    0x8(%ebp),%eax
801088ca:	89 04 24             	mov    %eax,(%esp)
801088cd:	e8 6b 00 00 00       	call   8010893d <deallocuvm>
      return 0;
801088d2:	b8 00 00 00 00       	mov    $0x0,%eax
801088d7:	eb 62                	jmp    8010893b <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801088d9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801088e0:	00 
801088e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801088e8:	00 
801088e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088ec:	89 04 24             	mov    %eax,(%esp)
801088ef:	e8 d2 ce ff ff       	call   801057c6 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801088f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088f7:	89 04 24             	mov    %eax,(%esp)
801088fa:	e8 d8 f5 ff ff       	call   80107ed7 <v2p>
801088ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108902:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108909:	00 
8010890a:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010890e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108915:	00 
80108916:	89 54 24 04          	mov    %edx,0x4(%esp)
8010891a:	8b 45 08             	mov    0x8(%ebp),%eax
8010891d:	89 04 24             	mov    %eax,(%esp)
80108920:	e8 d8 fa ff ff       	call   801083fd <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108925:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010892c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010892f:	3b 45 10             	cmp    0x10(%ebp),%eax
80108932:	0f 82 67 ff ff ff    	jb     8010889f <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108938:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010893b:	c9                   	leave  
8010893c:	c3                   	ret    

8010893d <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010893d:	55                   	push   %ebp
8010893e:	89 e5                	mov    %esp,%ebp
80108940:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108943:	8b 45 10             	mov    0x10(%ebp),%eax
80108946:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108949:	72 08                	jb     80108953 <deallocuvm+0x16>
    return oldsz;
8010894b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010894e:	e9 a4 00 00 00       	jmp    801089f7 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108953:	8b 45 10             	mov    0x10(%ebp),%eax
80108956:	05 ff 0f 00 00       	add    $0xfff,%eax
8010895b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108960:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108963:	e9 80 00 00 00       	jmp    801089e8 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108968:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010896b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108972:	00 
80108973:	89 44 24 04          	mov    %eax,0x4(%esp)
80108977:	8b 45 08             	mov    0x8(%ebp),%eax
8010897a:	89 04 24             	mov    %eax,(%esp)
8010897d:	e8 e5 f9 ff ff       	call   80108367 <walkpgdir>
80108982:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108985:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108989:	75 09                	jne    80108994 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
8010898b:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108992:	eb 4d                	jmp    801089e1 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108994:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108997:	8b 00                	mov    (%eax),%eax
80108999:	83 e0 01             	and    $0x1,%eax
8010899c:	84 c0                	test   %al,%al
8010899e:	74 41                	je     801089e1 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801089a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089a3:	8b 00                	mov    (%eax),%eax
801089a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801089ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801089b1:	75 0c                	jne    801089bf <deallocuvm+0x82>
        panic("kfree");
801089b3:	c7 04 24 c5 94 10 80 	movl   $0x801094c5,(%esp)
801089ba:	e8 7e 7b ff ff       	call   8010053d <panic>
      char *v = p2v(pa);
801089bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089c2:	89 04 24             	mov    %eax,(%esp)
801089c5:	e8 1a f5 ff ff       	call   80107ee4 <p2v>
801089ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801089cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089d0:	89 04 24             	mov    %eax,(%esp)
801089d3:	e8 8e a0 ff ff       	call   80102a66 <kfree>
      *pte = 0;
801089d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801089e1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089ee:	0f 82 74 ff ff ff    	jb     80108968 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801089f4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089f7:	c9                   	leave  
801089f8:	c3                   	ret    

801089f9 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801089f9:	55                   	push   %ebp
801089fa:	89 e5                	mov    %esp,%ebp
801089fc:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
801089ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108a03:	75 0c                	jne    80108a11 <freevm+0x18>
    panic("freevm: no pgdir");
80108a05:	c7 04 24 cb 94 10 80 	movl   $0x801094cb,(%esp)
80108a0c:	e8 2c 7b ff ff       	call   8010053d <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108a11:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a18:	00 
80108a19:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108a20:	80 
80108a21:	8b 45 08             	mov    0x8(%ebp),%eax
80108a24:	89 04 24             	mov    %eax,(%esp)
80108a27:	e8 11 ff ff ff       	call   8010893d <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108a2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a33:	eb 3c                	jmp    80108a71 <freevm+0x78>
    if(pgdir[i] & PTE_P){
80108a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a38:	c1 e0 02             	shl    $0x2,%eax
80108a3b:	03 45 08             	add    0x8(%ebp),%eax
80108a3e:	8b 00                	mov    (%eax),%eax
80108a40:	83 e0 01             	and    $0x1,%eax
80108a43:	84 c0                	test   %al,%al
80108a45:	74 26                	je     80108a6d <freevm+0x74>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a4a:	c1 e0 02             	shl    $0x2,%eax
80108a4d:	03 45 08             	add    0x8(%ebp),%eax
80108a50:	8b 00                	mov    (%eax),%eax
80108a52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a57:	89 04 24             	mov    %eax,(%esp)
80108a5a:	e8 85 f4 ff ff       	call   80107ee4 <p2v>
80108a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a65:	89 04 24             	mov    %eax,(%esp)
80108a68:	e8 f9 9f ff ff       	call   80102a66 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108a6d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108a71:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108a78:	76 bb                	jbe    80108a35 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108a7a:	8b 45 08             	mov    0x8(%ebp),%eax
80108a7d:	89 04 24             	mov    %eax,(%esp)
80108a80:	e8 e1 9f ff ff       	call   80102a66 <kfree>
}
80108a85:	c9                   	leave  
80108a86:	c3                   	ret    

80108a87 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108a87:	55                   	push   %ebp
80108a88:	89 e5                	mov    %esp,%ebp
80108a8a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a8d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a94:	00 
80108a95:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a98:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80108a9f:	89 04 24             	mov    %eax,(%esp)
80108aa2:	e8 c0 f8 ff ff       	call   80108367 <walkpgdir>
80108aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108aae:	75 0c                	jne    80108abc <clearpteu+0x35>
    panic("clearpteu");
80108ab0:	c7 04 24 dc 94 10 80 	movl   $0x801094dc,(%esp)
80108ab7:	e8 81 7a ff ff       	call   8010053d <panic>
  *pte &= ~PTE_U;
80108abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abf:	8b 00                	mov    (%eax),%eax
80108ac1:	89 c2                	mov    %eax,%edx
80108ac3:	83 e2 fb             	and    $0xfffffffb,%edx
80108ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac9:	89 10                	mov    %edx,(%eax)
}
80108acb:	c9                   	leave  
80108acc:	c3                   	ret    

80108acd <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108acd:	55                   	push   %ebp
80108ace:	89 e5                	mov    %esp,%ebp
80108ad0:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
80108ad3:	e8 b9 f9 ff ff       	call   80108491 <setupkvm>
80108ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108adb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108adf:	75 0a                	jne    80108aeb <copyuvm+0x1e>
    return 0;
80108ae1:	b8 00 00 00 00       	mov    $0x0,%eax
80108ae6:	e9 f1 00 00 00       	jmp    80108bdc <copyuvm+0x10f>
  for(i = 0; i < sz; i += PGSIZE){
80108aeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108af2:	e9 c0 00 00 00       	jmp    80108bb7 <copyuvm+0xea>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108afa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b01:	00 
80108b02:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b06:	8b 45 08             	mov    0x8(%ebp),%eax
80108b09:	89 04 24             	mov    %eax,(%esp)
80108b0c:	e8 56 f8 ff ff       	call   80108367 <walkpgdir>
80108b11:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108b14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b18:	75 0c                	jne    80108b26 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80108b1a:	c7 04 24 e6 94 10 80 	movl   $0x801094e6,(%esp)
80108b21:	e8 17 7a ff ff       	call   8010053d <panic>
    if(!(*pte & PTE_P))
80108b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b29:	8b 00                	mov    (%eax),%eax
80108b2b:	83 e0 01             	and    $0x1,%eax
80108b2e:	85 c0                	test   %eax,%eax
80108b30:	75 0c                	jne    80108b3e <copyuvm+0x71>
      panic("copyuvm: page not present");
80108b32:	c7 04 24 00 95 10 80 	movl   $0x80109500,(%esp)
80108b39:	e8 ff 79 ff ff       	call   8010053d <panic>
    pa = PTE_ADDR(*pte);
80108b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b41:	8b 00                	mov    (%eax),%eax
80108b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b48:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
80108b4b:	e8 af 9f ff ff       	call   80102aff <kalloc>
80108b50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108b53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108b57:	74 6f                	je     80108bc8 <copyuvm+0xfb>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b5c:	89 04 24             	mov    %eax,(%esp)
80108b5f:	e8 80 f3 ff ff       	call   80107ee4 <p2v>
80108b64:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108b6b:	00 
80108b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108b73:	89 04 24             	mov    %eax,(%esp)
80108b76:	e8 1e cd ff ff       	call   80105899 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
80108b7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108b7e:	89 04 24             	mov    %eax,(%esp)
80108b81:	e8 51 f3 ff ff       	call   80107ed7 <v2p>
80108b86:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108b89:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108b90:	00 
80108b91:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108b95:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108b9c:	00 
80108b9d:	89 54 24 04          	mov    %edx,0x4(%esp)
80108ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ba4:	89 04 24             	mov    %eax,(%esp)
80108ba7:	e8 51 f8 ff ff       	call   801083fd <mappages>
80108bac:	85 c0                	test   %eax,%eax
80108bae:	78 1b                	js     80108bcb <copyuvm+0xfe>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108bb0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bba:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108bbd:	0f 82 34 ff ff ff    	jb     80108af7 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
  }
  return d;
80108bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bc6:	eb 14                	jmp    80108bdc <copyuvm+0x10f>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108bc8:	90                   	nop
80108bc9:	eb 01                	jmp    80108bcc <copyuvm+0xff>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
80108bcb:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bcf:	89 04 24             	mov    %eax,(%esp)
80108bd2:	e8 22 fe ff ff       	call   801089f9 <freevm>
  return 0;
80108bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108bdc:	c9                   	leave  
80108bdd:	c3                   	ret    

80108bde <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108bde:	55                   	push   %ebp
80108bdf:	89 e5                	mov    %esp,%ebp
80108be1:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108be4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108beb:	00 
80108bec:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bef:	89 44 24 04          	mov    %eax,0x4(%esp)
80108bf3:	8b 45 08             	mov    0x8(%ebp),%eax
80108bf6:	89 04 24             	mov    %eax,(%esp)
80108bf9:	e8 69 f7 ff ff       	call   80108367 <walkpgdir>
80108bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c04:	8b 00                	mov    (%eax),%eax
80108c06:	83 e0 01             	and    $0x1,%eax
80108c09:	85 c0                	test   %eax,%eax
80108c0b:	75 07                	jne    80108c14 <uva2ka+0x36>
    return 0;
80108c0d:	b8 00 00 00 00       	mov    $0x0,%eax
80108c12:	eb 25                	jmp    80108c39 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c17:	8b 00                	mov    (%eax),%eax
80108c19:	83 e0 04             	and    $0x4,%eax
80108c1c:	85 c0                	test   %eax,%eax
80108c1e:	75 07                	jne    80108c27 <uva2ka+0x49>
    return 0;
80108c20:	b8 00 00 00 00       	mov    $0x0,%eax
80108c25:	eb 12                	jmp    80108c39 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c2a:	8b 00                	mov    (%eax),%eax
80108c2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c31:	89 04 24             	mov    %eax,(%esp)
80108c34:	e8 ab f2 ff ff       	call   80107ee4 <p2v>
}
80108c39:	c9                   	leave  
80108c3a:	c3                   	ret    

80108c3b <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108c3b:	55                   	push   %ebp
80108c3c:	89 e5                	mov    %esp,%ebp
80108c3e:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108c41:	8b 45 10             	mov    0x10(%ebp),%eax
80108c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108c47:	e9 8b 00 00 00       	jmp    80108cd7 <copyout+0x9c>
    va0 = (uint)PGROUNDDOWN(va);
80108c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c54:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c5e:	8b 45 08             	mov    0x8(%ebp),%eax
80108c61:	89 04 24             	mov    %eax,(%esp)
80108c64:	e8 75 ff ff ff       	call   80108bde <uva2ka>
80108c69:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108c6c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108c70:	75 07                	jne    80108c79 <copyout+0x3e>
      return -1;
80108c72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108c77:	eb 6d                	jmp    80108ce6 <copyout+0xab>
    n = PGSIZE - (va - va0);
80108c79:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108c7f:	89 d1                	mov    %edx,%ecx
80108c81:	29 c1                	sub    %eax,%ecx
80108c83:	89 c8                	mov    %ecx,%eax
80108c85:	05 00 10 00 00       	add    $0x1000,%eax
80108c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c90:	3b 45 14             	cmp    0x14(%ebp),%eax
80108c93:	76 06                	jbe    80108c9b <copyout+0x60>
      n = len;
80108c95:	8b 45 14             	mov    0x14(%ebp),%eax
80108c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108c9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c9e:	8b 55 0c             	mov    0xc(%ebp),%edx
80108ca1:	89 d1                	mov    %edx,%ecx
80108ca3:	29 c1                	sub    %eax,%ecx
80108ca5:	89 c8                	mov    %ecx,%eax
80108ca7:	03 45 e8             	add    -0x18(%ebp),%eax
80108caa:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108cad:	89 54 24 08          	mov    %edx,0x8(%esp)
80108cb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108cb4:	89 54 24 04          	mov    %edx,0x4(%esp)
80108cb8:	89 04 24             	mov    %eax,(%esp)
80108cbb:	e8 d9 cb ff ff       	call   80105899 <memmove>
    len -= n;
80108cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cc3:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cc9:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ccf:	05 00 10 00 00       	add    $0x1000,%eax
80108cd4:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108cd7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108cdb:	0f 85 6b ff ff ff    	jne    80108c4c <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108ce6:	c9                   	leave  
80108ce7:	c3                   	ret    
