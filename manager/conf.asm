// Command List
// ------------
// exec: Jump/Jsr to scene
//		 Give control to the called scene; JMP to [<x,>y] to give back the control to Manager
//		 Manager will take care of adjusting IRQ & stack when it will be given back the control.
//       MAIN: the called routine will execute the main thread
//		 IRQONLY: the main thread will be executed in the manager
// load: Load file
//	     Load "filename" and advance string pointers to the next one
//		 Main thread will be blocked until file has been loaded, no flags involved
//       IORAM: use this flag if you load stuff under $d000-$dfff
//       NOIORAM: use this flag if you don't load stuff under $d000-$dfff (Faster)
// flagload: Load file with flag
//		 Same as "load" but with a special flag to track the flow.
//		 FLAG ($1F) bit: CRxxxxxL
//		 Read:
//				R: 0 a file has not been loaded (yet)
//				   1 a file has been loaded
//				L: 0 not loading
//				   1 File load in progress
//		 Write:
//				C: 1 Acknowledge loaded file allowing the main thread to continue
//       IORAM/NOIORAM behave the same way as in load

// Start
// *****

:exec( $1000 ,IRQONLY)			// IRQ => check screen
:load( "01" ,IORAM)			// "IN" - Load opener/transition

:exec( $2800 ,MAIN)				// Exec intro
:exec( sidplayer ,MAIN)			// Init sid player
:exec( $f940 ,IRQONLY)			// IRQ => transition (rising water)

:flagload( "02", NOIORAM)		// "TXO" - Load tentacoli
:exec( $5000 ,IRQONLY)			// Exec tentacoli

:load( "03",NOIORAM)			// "PLEXER" - Load plexer
:exec( $8400 ,IRQONLY)			// Exec plexer

:load( "04" ,NOIORAM)			// "FAST" - Load post plexer
:exec( $32C0 ,IRQONLY)			// Exec post plexer

:load( "05" ,NOIORAM)			// "SQU" - Load quadretti
:exec( $f000 ,IRQONLY)			// Exec quadretti

:flagload( "06" ,NOIORAM)		// "CUBE" - Load Cubo
:exec( $cc00 ,IRQONLY)			// Exec quadretti

:load( "07" ,NOIORAM)			// "PURPLE" - Load purple transition
:exec( $f400 ,IRQONLY)			// Exec purple transition

:load( "08" ,NOIORAM)			// "LOGO" - Load Petscii Logo
:exec( $f480 ,IRQONLY)			// Exec Petscii Logo

:load( "09" ,NOIORAM)			// "CARP" - Load Shaker
:exec( $3a40 ,IRQONLY)			// Exec Shaker

:load( "10" ,NOIORAM)			// "FRF" - Load Farfalla
:exec( $9d00 ,IRQONLY)			// Exec Farfalla

:load( "11" ,NOIORAM)			// "BTR" - Load Farfalla
:exec( $9d90 ,IRQONLY)			// Exec Farfalla

:load( "12" ,NOIORAM)			// "HAT" - Load Hatgirl (Including FRAME 0)
:exec( $c800 ,IRQONLY)			// Exec Hatgirl

:load( "13" ,NOIORAM)			// "GRA" - Load Hatgirl FRAME 1
:exec( $c865 ,IRQONLY)			// Jump Back To Hatgirl after loading FRAME 1

:load( "14" ,NOIORAM)			// "GRB" - Load Hatgirl FRAME 2
:exec( $c866 ,IRQONLY)			// Jump Back To Hatgirl after loading FRAME 2

:load( "15" ,NOIORAM)			// "SPRHAT" - Load Credits sprites
:exec( $3000 ,IRQONLY)			// Exec Credits sprites

:load( "16" ,NOIORAM)			// "TT" - Load Tetris
:exec( $f000 ,IRQONLY)			// Exec Tetris

:load( "17" ,NOIORAM)			// "TN" - Load Tunnel
:exec( $f030 ,IRQONLY)			// Jump to tetris load tunnel (rts)

:load( "18" ,NOIORAM)		// "TBL" - Load Tunnel blobbed data
:exec( $f033 ,IRQONLY)			// Exec Tunnel (just rts to load intro transition)

:load( "19" ,NOIORAM)			// "ITN" - Load Tunnel intro transition
:exec( $9410 ,IRQONLY)			// Exec Tunnel (for real)

:load( "20" ,NOIORAM)			// "OUN" - Load Tunnel outro transition
:exec( $f000 ,IRQONLY)			// Exec Tunnel outro

:flagload( "21" ,NOIORAM)		// "TW" - Load Twister + chunky stuff
:exec( $b000 ,IRQONLY)			// Exec Twister

:load( "22" ,NOIORAM)			// "RO" - Load Rotozoomer
:flagload( "23" ,NOIORAM)	// "MS" - Load Last SID
:exec( $3500 ,IRQONLY)			// Exec Rotozoomer

:exec( $7EA0 ,IRQONLY)			// Exec Transition

:load( "24" ,NOIORAM)			// "EN" - Load last scene
:exec( $3300 ,IRQONLY)			// Exec Last scene

:exec( waitjump, IRQONLY)		// Self jump
