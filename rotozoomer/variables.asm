.const SIZEX=48		// 48
.const SIZEY=46		// 46
.const XOFFSET=8	// 8
.const YOFFSET=2	// 4


// Tabelle dei quadrati
.const square1_lo=	$7800		// Computed rt
.const square1_hi=	$7A00		// Computed rt
.const square2_lo=	$7C00		// Computed rt
.const square2_hi=	$7E00		// Computed rt


//;---CHUNKY VARIABLES--------------
.var RasterRow = $1d //; May not be a line with sprites or a badline

.var _rx = $40
.var _ry = $41

.var oldCIA = $4a

// Chunky test
// ***********

.const	stopchunky	=	$38	// 1 byte
.const	flippage	=	$31	// 1 byte
.const	stopstatus	=	$39	// 1 byte

// Temp incx
// *********
.const	tmpxuhi2	=	$3d
.const	tmpxulo		=	$3e
.const	tmpxuhi		=	$3f

// Frame counters
.const	fcl			=	$43
.const	fch			=	$44

//; Calcolo square table
.const	clo			=	$45
.const	cmi			=	$46
.const	chi			=	$47
.const	lo			=	$48
.const	mi			=	$49
.const	hi			=	$4a
.const	oddlo		=	$4b
.const	oddmi		=	$4c
.const	oddhi		=	$4d

//; Miscellanea
.const	zoom		=	$4e
.const	flipdata	=	$4f

//; Variabili di incremento (16 bit)
.const	incxulo	=	$50
.const	incxuhi	=	$51
.const	incxvlo	=	$52
.const	incxvhi	=	$53
.const	incyulo	=	$54
.const	incyuhi	=	$55
.const	incyvlo	=	$56
.const	incyvhi	=	$57

//; Contatore righe
.const	rowcounter	=	$5e

// Temporaneo per le moltiplicazioni
.const	T1			=	$5f

// Vettori traslati (16 bit)
.const	ulo		=	$60
.const	uhi		=	$61
.const	vlo		=	$62
.const	vhi		=	$63
.const	yulo	=	$64
.const	yuhi	=	$65
.const	yvlo	=	$66
.const	yvhi	=	$67

// Angoli
.const	angle1	=	$68
.const	angle2	=	$69
.const	angle3	=	$6a
.const	zoompos	=	$6b
.const	movepos	=	$6c

// Contatori
.const	counter2=	$6d
.const	counter3=	$6e
.const	endpart	=	$6f
.const	nextscenecounter	=	$70

// Savers

.const	bgcol	=	$71	//  Bg colors

//; Puntatori vari (2 byte)
.const	left	=	$72
.const	right	=	$74
.const	ptr		=	$76
.const	divval	=	$78
.const	cmpval	=	$79
