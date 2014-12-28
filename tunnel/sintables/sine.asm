.var  seno_x_min = List()
.eval seno_x_min.add(82,83,83,84,85,85,86,87,88,89,91,92,93,95,96,98)
.eval seno_x_min.add(99,101,103,104,106,108,110,112,114,116,118,120,122,124,126,128)
.eval seno_x_min.add(130,132,135,137,139,141,143,145,147,148,150,152,154,156,157,159)
.eval seno_x_min.add(160,162,163,165,166,167,168,169,170,171,172,173,174,174,175,175)
.eval x_min = seno_x_min.get(0)

.align $40
.pc = * "sprite_x_min_lo"
sprite_x_min_lo:
.for(var t=0;t<64;t++)
{
	.byte [seno_x_min.get(t)-x_min]
}

sprite_x_min_lo_hi:
.for(var t=0;t<64;t++)
{
	.byte 0
}


.var seno_x_max = List()
.eval seno_x_max.add(272,271,271,271,271,270,270,269,268,267,266,265,264,262,261,259)
.eval seno_x_max.add(258,256,255,253,251,249,247,245,243,241,238,236,234,232,229,227)
.eval seno_x_max.add(225,222,220,218,216,213,211,209,207,204,202,200,198,196,194,192)
.eval seno_x_max.add(191,189,187,186,184,183,182,181,179,179,178,177,176,176,175,175)


.align $40
.pc = * "sprite x max"
sprite_x_max_lo:
.for (var n=0; n < seno_x_max.size() ; n++) {
	.byte [seno_x_max.get(n)-x_min]
}
sprite_x_max_hi:
.for (var n=0; n < seno_x_max.size() ; n++) {
	.byte seno_x_max.get(n)>>8
}



//;L'estremo opposto si ha a 272 ($12 con $d010 acceso)
//;Mi calcolo tutte le moltiplicazioni
.var speed = 0
shift_values:
.byte 0,0,0,1,1,3,4,5,7,9,11,14,16,19,22,25
.byte 29,32,36,40,44,48,52,57,61,65,70,75,79,84,89,94
.byte 99,103,108,113,117,122,127,131,135,140,144,148,152,156,159,163
.byte 166,169,172,174,177,179,181,183,185,186,187,188,189,189,189,189


.align $40
.pc = * "shift table"
shift_table:
.fill $100,0

sprite_d010_enabler:
.byte %00000001
.byte %00000010
.byte %00000100
.byte %00001000
.byte %00010000
.byte %00100000
.byte %01000000
.byte %10000000


sprite_to_shrink:
.byte $0

.align $8
sprite_table_pointer:
.byte 0,8*1,8*2,8*3,8*4,8*5,8*6,8*7



.align $100
speed_wobble:
.byte 0,0,0,0,0,1,1,1,2,3,3,4,5,6,7,8
.byte 9,11,12,13,14,16,17,19,20,22,23,25,26,28,30,31
.byte 33,34,36,38,39,41,42,44,45,47,48,49,51,52,53,54
.byte 56,57,58,58,59,60,61,61,62,62,63,63,63,63,63,63

.align $8
.pc = * " color fader"
COLOR_FADER:	
.byte plasma_1_col,plasma_1_col,plasma_1_col,plasma_1_col,plasma_1_col

fade_plasma_col:
.byte plasma_2_col,plasma_2_col,plasma_2_col,plasma_2_col
		

.align 21
plasma_fd_out_tbl:
.byte GRAY,GRAY,GRAY
.byte GRAY,GRAY,GRAY
.byte GREEN,GREEN,GREEN
.byte GREEN,GREEN,GREEN
.byte LIGHT_GREEN,LIGHT_GREEN,LIGHT_GREEN
.byte LIGHT_GREEN,LIGHT_GREEN,LIGHT_GREEN
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte LIGHT_GRAY,LIGHT_GRAY,LIGHT_GRAY
.byte YELLOW,YELLOW,YELLOW
.byte YELLOW,YELLOW,YELLOW
.byte CYAN,CYAN,CYAN
.byte CYAN,CYAN,CYAN
.byte LIGHT_BLUE, LIGHT_BLUE, LIGHT_BLUE
.byte LIGHT_BLUE, LIGHT_BLUE, LIGHT_BLUE
.byte LIGHT_BLUE, LIGHT_BLUE, LIGHT_BLUE
