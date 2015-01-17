// ******
// MACROS
// ******

// Update sprite pointer & y position
.macro   wait44yspr(y)	{
	ldx #[frstborder+$15*y]
	stx $d005
	stx $d007
	stx $d009
	stx $d00b		
	inc charscreen2+$3fa
	inc charscreen2+$3fb
	inc charscreen2+$3fc
	inc charscreen2+$3fd
	tsx
}

// Update sprite pointer
.macro   incsprite()	{		// 38
	inc charscreen2+$3fa
	inc charscreen2+$3fb
	inc charscreen2+$3fc
	inc charscreen2+$3fd	
	pha
	pla
	pha
	pla
}

// Update y sprite position
.macro   ysprite(y)	{		// 44
	ldx #[frstborder+$15*y]
	stx $d005
	stx $d007
	stx $d009
	stx $d00b		
	tsx
	pha
	pla
	pha
	pla
	nop
	nop
	nop
	nop
	nop
}

// Generic 44 + open low border
.macro   wait44open()	{
	ldx #mode24
	stx $d011	
	tsx
	asl dummy-mode38,x
	asl dummy-mode38,x
	asl dummy-mode38,x
	asl dummy-mode38,x
	asl dummy-mode38,x
	asl dummy-mode38,x	
}

// Scroll function
.function scroll(time,direction) {
	.return time*4+direction
}

// Scroll function
.function block(command,data,type) {
	.return [data&15]*4+[type&1]*128+[command&3]
}

// Volume function
.function volume(vol) {
	.return $40|[vol&$3f]
}
