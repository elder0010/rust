frames_wob:
 	  .byte 1,1,1,1,1,1
      .byte 2,2,2,2,2,2
      .byte 2,2,2,2,2,2
      .byte 2,2,2,2,2,2
      .byte 2,2,2,2,2,2
      .byte 2,2,2,2,2,2
      .byte 2,2,1,1,1,1
      .byte 1,1,1,1,1,1
      .byte 1,1,1,1,1,1
      .byte 1,1,1,1,1,1
      .byte 1,1,1,1,1,1
      .byte 1,1,1,1,2,2
      .byte 2,2,2,2,2,2
      .byte 2,2,3,3,3,3
      .byte 3,3,3,3,3,3
      .byte 3,3,3,3,3,3
      .byte 2,2,2,2,2,2
      .byte 1,1,1,1,1,1
      .byte 1,0,0,0,0,0
      .byte 0,0,0,0,0,0
      .byte 0,0,0,0,0,1
      .byte 1,1

x_wob:
	  .byte 1,1,1,2,2,2
      .byte 2,2,2,3,3,3
      .byte 3,3,4,4,4,4
      .byte 4,5,5,5,5,5
      .byte 6,6,6,6,6,6
      .byte 7,7,7,7,7,7
      .byte 7,8,8,8,8,8
      .byte 8,8,8,8,8,8
      .byte 8,8,8,8,8,8
      .byte 8,8,8,8,8,8
      .byte 8,8,8,8,8,8
      .byte 8,8,8,8,8,7
      .byte 7,7,7,7,7,7
      .byte 7,7,7,6,6,6
      .byte 6,6,6,6,6,6
      .byte 6,6,6,6,6,6
      .byte 6,6,6,6,6,6
      .byte 6,6,6,6,6,6
      .byte 6,6,6,6,6,6
      .byte 6,7,7,7,7,7
      .byte 7,7,8,8,8,8
      .byte 8,9,9,9,9,9
      .byte 10,10,10,10,10,11
      .byte 11,11,11,11,11,12
      .byte 12,12,12,12,13,13
      .byte 13,13,13,13,13,13
      .byte 14,14,14,14,14,14
      .byte 14,14,14,14,14,14
      .byte 14,14,14,14,14,14
      .byte 14,13,13,13,13,13
      .byte 13,13,12,12,12,12
      .byte 12,11,11,11,11,10
      .byte 10,10,10,9,9,9
      .byte 9,8,8,8,7,7
      .byte 7,7,6,6,6,5
      .byte 5,5,5,4,4,4
      .byte 3,3,3,3,3,2
      .byte 2,2,2,2,1,1
      .byte 1,1,1,1,1,0
      .byte 0,0,0,0,0,0
      .byte 0,0,0,0,0,0
      .byte 0,0,0,0,0,0
      .byte 1,1,1,1



x_offsets_base:
.var x_start_tentacoli = $64
.var ofs_base = $27
//;1 per tentacolo
.for(var x=0;x<4;x++){
	.byte x_start_tentacoli+[ofs_base*x]
}

wob_pt_x:
.eval ofs_base = $31
//;1 per tentacolo
.for(var x=0;x<4;x++){
	.byte [ofs_base*x]
}


frame_wob_pt_table:
.byte $55,$2,$30,$7f


.align $8
altezze_sprites:
.fill $8,$0

.align $8
valori_d011:
.fill $8, $0



