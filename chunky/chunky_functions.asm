.pc = $4000 "bitmap"
bitmap:
.import source "data/intro_sines.asm"
.pc = * "colori"
.import source "data/colori.asm"

.pc = $6000 "offset_0"
offset_0:


.pc = $6100 "reloc routine"
.import source "reloc.asm"

//.pc = $6400 "offset_1"
offset_1:



//.pc = $6800 "offset_2"
offset_2:


//.pc = $6c00 "offset_3"
offset_3:


.pc = $9000
source_buffer_0:


.pc = $9400
source_buffer_1:    

	
.function getLineAddresses(base,y) {
    .var lineAddress
    .var line
    .if (mod(y,2) == 0) {
        .eval line = base
    } else {
        .eval line = base + $400
    }
    .eval lineAddress = line + [floor([y / 2]) * $28]
    .return lineAddress
}


.var screenHeight = 50

.pc = $8000 "indirizzi source"
sourceLowBuffer1:
.for (var i = 0 ; i < screenHeight;i++) {
    .byte <getLineAddresses($9000,i)
}
sourceHiBuffer1:
.for (var i = 0 ; i < screenHeight;i++) {
    .byte >getLineAddresses($9000,i)
}


.pc = * "indirizzi target"
targetLowBuffer1:
.for (var i = 0 ; i < screenHeight;i++) {
    .byte <getLineAddresses($6000,i)
}
targetHiBuffer1:
.for (var i = 0 ; i < screenHeight;i++) {
    .byte >getLineAddresses($6000,i)
}

targetLowBuffer2:
.for (var i = 0 ; i < screenHeight;i++) {
    .byte <getLineAddresses($6800,i)
}
targetHiBuffer2:
.for (var i = 0 ; i < screenHeight;i++) {
    .byte >getLineAddresses($6800,i)
}

.pc = * "fine indirizzi"

.align $100
.pc = * "wobbling tables"
//;.import source "data/wobble_basic.asm"
//;.import source "data/wobble_polygon.asm"


.align $100
.pc = * "clean buffers"
clean_buffer_0_lo:
.fill $100,$0

clean_buffer_0_hi:
.fill $100,$0

clean_buffer_1_lo:
.fill $100,$0

clean_buffer_1_hi:
.fill $100,$0

y_add_0:
.fill $100,$0

y_add_1:
.fill $100,$0

.align $100
.pc = * "buffer linea"
linea:
.fill $ff,$0

wobble_pt_1:
.byte $0

wobble_pt_2:
.byte $0

max_points:
.byte $0,$0
		
		
