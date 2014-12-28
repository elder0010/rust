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

// List of all steps performed by Manager
// --------------------------------------
commandlist:
.byte $20	// IRQ => check screen
.byte $40	// Load opener/transition
.byte $80	// Exec intro
.byte $80	// Init sid player
.byte $20	// IRQ => transition (rising water)
.byte $40	// Load tentacoli
.byte $20	// Exec tentacoli
.byte $40	// Load tentacoli added stuff 
.byte $80	// Exec tentacoli added stuff

// Jump table
// ----------
// Address of every routine that needs to be called

.align $0002
jumptable:
:addr($1000)		// -> Screen check
:addr($2800)		// -> Opener 
:addr(sidplayer)	// -> Install SID player
:addr($f940)		// -> Transition 1
:addr($5000)		// -> Tentacoli
:addr($a000)		// -> Tentacoli added stuff
:addr(waitjump)		// -> Jmp *

// Load Table
// ----------
// 0 terminated file names
loadtable:
.text "INTRO"
.byte $00
.text "TENEXO"
.byte $00
.text "TENADD"
.byte $00

