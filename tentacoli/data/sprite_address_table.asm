//;Indica dove "iniziano" i frames.
.align $40
frames_pt_tbl:
.for(var x=0;x<8;x++){
	.byte [[sprites_source&$3fff]/$40]+[x]
}

//;Per linea sono 4 sprites, 6 linee = 24 puntatori
.align $40
current_pt_tbl:
.fill 24,0

.align $4
x_wob_pt:
.var ofs = 40
.for(var x=0;x<4;x++){
.byte [ofs*x]
}

.align $24
frame_sprites:
.fill 24,$0

