// Command List
// ------------
// 1xxxxxxx: Jump to scene
//			 Full control to the called scene; JMP to [<x,>y] to give back the control to Manager
//			 Manager will take care of adjusting IRQ & stack when it will be given back the control.
// x1xxxxxx: Load file
//			 Load current "filename" and advance string pointers to the next one
//			 Main thread will be blocked until file has been loaded, no flags involved
// xx1xxxxx: Jsr to scene (for IRQ)
//			 Scene should save [<x,>y] (to be used inside IRQ handler for quitting the scene), install its own IRQ
//		 	 handler and jump back to Manager with an RTS. IRQ handler MUST call [<x,>y] when they've done their job.
//			 As in JUMP case, Manager will take care of fixing IRQ & stack
// xxx1xxxx: Load file with flag
//			 Same as "LOAD" but with a special flag to track the flow.
//			 FLAG ($1F) bit: CRxxxxxL
//			 Read:
//					R: 0 a file has not been loaded (yet)
//					   1 a file has been loaded
//					L: 0 not loading
//					   1 File load in progress
//			 Write:
//					C: 1 Acknowledge loaded file allowing the main thread to continue

// Initialize service list
// ***********************
.var cmdlist=List()
.var jmplist=List()
.var fnmlist=List()

// Command macro
// *************
.macro exec(addr,type) {
	.eval jmplist.add(<addr,>addr)
	.eval cmdlist.add([[type&1]*$60]+$20)
}

.macro load(name,ioflag) {
	.eval fnmlist.add(name)	
	.eval cmdlist.add($40|[ioflag&1])
}

.macro flagload(name,ioflag) {
	.eval fnmlist.add(name)	
	.eval cmdlist.add($10|[ioflag&1])
}

// Preset consts
// *************
.const	IORAM	=	0
.const	NOIORAM	=	1
.const	IRQONLY	=	0
.const	MAIN	=	1

// Load configuration
// ******************
.import source "conf.asm"


// List of all steps performed by Manager
// --------------------------------------
commandlist:
.for(var i=0;i<cmdlist.size();i++)
	.byte cmdlist.get(i)
	
// Jump table
// ----------
// Address of every routine that needs to be called

.align $0002
.pc = * "jumptable"
jumptable:
.for(var i=0;i<jmplist.size();i++)
	.byte jmplist.get(i)


// Load Table
// ----------
// 0 terminated file names
.pc = * "loadtable"
loadtable:
.for(var i=0;i<fnmlist.size();i++)
{
	.text fnmlist.get(i)
	.byte 0
}