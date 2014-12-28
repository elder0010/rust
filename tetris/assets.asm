.var MAKE_SYMFILE=0 //;0 per buildare nella farfalla
.var tetris_asset_dest = $f500

.if(MAKE_SYMFILE==1){
	.pc = $f500
}

//;.import source "variables.asm" //;SCOMMENTARE SE MAKE_SYMFILE = 1

.var reloc_start = *

.align $100 
.pc = * "sequenza pezzi"
.import source "data/sequenza_pezzi.asm"

.align $100
.pc = * "x offsets partenze"
.import source "data/start_offsets.asm"

.pc = * "tetris - skull chars"
skull_chars_src:
.import binary "data/skull/chars.raw"


.if(MAKE_SYMFILE==0){
.pc = * "tetris - reloc routine"
reloc_tetris_assets:

		ldx #0
!:
.for(var t=0;t<10;t++){
		lda reloc_start+[t*$100],x //;tetris_asset_source è il punto in cui 
		sta tetris_asset_dest+[t*$100],x	  //;vengono caricati gli assets quindi *
}
		dex
		bne !-
		rts
}


