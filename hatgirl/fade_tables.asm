
.var blackr2 = List().add( GRAY , GRAY , DARK_GRAY , DARK_GRAY , DARK_GRAY , BLACK , BLACK , BLACK ).lock()
.var whiter2 = List().add( BROWN , RED , DARK_GRAY , GRAY ,  GRAY , LIGHT_GRAY , LIGHT_GRAY , WHITE ).lock()
.var redr2 = List().add( DARK_GRAY , DARK_GRAY , BROWN , BROWN , BROWN , RED , RED , RED ).lock()
.var cyanr2 = List().add( BROWN , DARK_GRAY , BLUE , ORANGE , LIGHT_BLUE , GREEN , CYAN , CYAN ).lock()
.var purpler2 = List().add( BROWN , DARK_GRAY , BLUE , BLUE , RED , RED , PURPLE , PURPLE ).lock()
.var greenr2 = List().add( BROWN , DARK_GRAY , BLUE , DARK_GRAY , PURPLE , GRAY , GREEN , GREEN ).lock()
.var bluer2 = List().add( BLACK , BLACK , BLACK , BROWN , BROWN , BROWN , BLUE , BLUE  ).lock() 
.var yellowr2 = List().add( DARK_GRAY , DARK_GRAY , BROWN , ORANGE , GRAY , GREEN , LIGHT_GRAY , YELLOW ).lock()
.var oranger2 = List().add( DARK_GRAY , DARK_GRAY , BROWN , BROWN ,  DARK_GRAY , RED , ORANGE , ORANGE ).lock()
.var brownr2 = List().add( DARK_GRAY , BLUE , BROWN , BROWN , BROWN , BROWN , BROWN , BROWN ).lock()
.var lightredr2 = List().add( BROWN , BROWN , RED , RED , PURPLE , GRAY , LIGHT_RED , LIGHT_RED ).lock()
.var darkgreyr2 = List().add( BLACK , BLACK ,  BLACK ,  BROWN , DARK_GRAY , DARK_GRAY , DARK_GRAY , DARK_GRAY ).lock() 
.var greyr2 = List().add( BROWN , DARK_GRAY , BROWN , BROWN , DARK_GRAY , DARK_GRAY , GRAY , GRAY ).lock() 
.var lightgreenr2 = List().add( BROWN , BLUE , ORANGE , LIGHT_BLUE , GREEN , LIGHT_GRAY ,  LIGHT_GREEN ,  LIGHT_GREEN ).lock()
.var lightbluer2 = List().add( DARK_GRAY , BROWN , BLUE , DARK_GRAY , PURPLE , LIGHT_BLUE , LIGHT_BLUE , LIGHT_BLUE ).lock()
.var lightgreyr2 = List().add( BROWN , DARK_GRAY , DARK_GRAY , DARK_GRAY , GRAY , GRAY , LIGHT_GRAY , LIGHT_GRAY ).lock()



fade_tables2:
.align 8
.for (var k=1;k<8;k++){
	.byte blackr2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte whiter2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte redr2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte cyanr2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte purpler2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte greenr2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte bluer2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte yellowr2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte oranger2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte brownr2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte lightredr2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte darkgreyr2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte greyr2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte lightgreenr2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte lightbluer2.get(k)
}
.align 8
.for (var k=1;k<8;k++){
	.byte lightgreyr2.get(k)
}


.align $8
sprite_fade_table:
.byte PURPLE,PURPLE,GRAY,GRAY,RED,RED,BROWN,BROWN,DARK_GRAY,DARK_GRAY

.align 40
fade_table_addr_lo:
.for(var x=0;x<16;x++){
	.byte <fade_tables2+[x*8]
}

fade_table_addr_hi:
.for(var x=0;x<16;x++){
	.byte >fade_tables2+[x*8]
}
