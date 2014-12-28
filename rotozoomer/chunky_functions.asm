.pc = $4000 "bitmap"
bitmap:


.pc = $6000 "offset_0"
offset_0:



.pc = $6400 "offset_1"
offset_1:



.pc = $6800 "offset_2"
offset_2:


.pc = $6c00 "offset_3"
offset_3:


.pc = $9000 "source image on low nibble"
source_buffer_0_lo:
    .var colorMap = Hashtable()

    .eval colorMap.put("0",BLACK)
    .eval colorMap.put("ffffff",WHITE)
    .eval colorMap.put("894036",RED)
    .eval colorMap.put("7abfc7",CYAN)
    .eval colorMap.put("8a46ae",PURPLE)
    .eval colorMap.put("69a941",GREEN)
    .eval colorMap.put("3e31a2",BLUE)
    .eval colorMap.put("d0dc71",YELLOW)
    .eval colorMap.put("905f25",ORANGE)
    .eval colorMap.put("5c4700",BROWN)
    .eval colorMap.put("bb776d",LIGHT_RED)
    .eval colorMap.put("555555",DARK_GRAY)
    .eval colorMap.put("808080",GRAY)
    .eval colorMap.put("acea88",LIGHT_GREEN)
    .eval colorMap.put("7c70da",LIGHT_BLUE)
    .eval colorMap.put("ababab",LIGHT_GRAY)
  //;  .var image = LoadPicture("megaman.gif")
    .var image = LoadPicture("mega_freccia.gif")

.var i =0
.var flag =0
.var temp = 0
//;Bit alti
 .for (var y=0; y < 16 ;  y++) {
    .for (var x=0; x < 16 ; x++) {
        .var color = image.getPixel(x,y)			
		.if(colorMap.containsKey(toHexString(color)) ){
			.byte colorMap.get(toHexString(color)) 	
    	}
    }
}

.pc = $9100 "source image on high nibble"
source_buffer_0_hi:
.eval i =0
.eval flag =0
.eval temp = 0
//;Bit alti
 .for (var y=0; y < 16 ;  y++) {
    .for (var x=0; x < 16 ; x++) {
        .var color = image.getPixel(x,y)			
		.if(colorMap.containsKey(toHexString(color)) ){
			.byte colorMap.get(toHexString(color))*16 	
    	}
    }
}




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

.pc = $a000 "indirizzi source"
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



		
//;-------------------------------------------------------------------------
//; Macro per double buffering
//;-------------------------------------------------------------------------
.macro point_screen_1(){
 //   :set_addr(targetHiBuffer1,target_buffer_hi)
  //  :set_addr(targetLowBuffer1,target_buffer_lo)

    lda #>targetHiBuffer1
    sta target_buffer_hi+2
    sta nxt_line_bf_hi+2

    lda #<targetHiBuffer1
    sta target_buffer_hi+1
    sta nxt_line_bf_hi+1

    lda #>targetLowBuffer1
    sta target_buffer_lo+2
    sta nxt_line_bf_lo+2

    lda #<targetLowBuffer1
    sta target_buffer_lo+1
    sta nxt_line_bf_lo+1
}


.macro point_screen_2(){
    lda #>targetHiBuffer2
    sta target_buffer_hi+2
    sta nxt_line_bf_hi+2

    lda #<targetHiBuffer2
    sta target_buffer_hi+1
    sta nxt_line_bf_hi+1

    lda #>targetLowBuffer2
    sta target_buffer_lo+2
    sta nxt_line_bf_lo+2

    lda #<targetLowBuffer2
    sta target_buffer_lo+1
    sta nxt_line_bf_lo+1
}