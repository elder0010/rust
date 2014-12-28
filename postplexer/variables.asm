////;--------------------------------------
////;------WOBBLER VARIABLES 
////;--------------------------------------
.var music = LoadSid("psycho.sid")

.const frame_lo = $98
.const frame_hi = $99

.var SCREEN_1 = $0400

.var sprite_pt_01 = SCREEN_1+$03f8
.var sprite_pt_02 = SCREEN_1+$03f9
.var sprite_pt_03 = SCREEN_1+$03fa
.var sprite_pt_04 = SCREEN_1+$03fb
.var sprite_pt_05 = SCREEN_1+$03fc
.var sprite_pt_06 = SCREEN_1+$03fd
.var sprite_pt_07 = SCREEN_1+$03fe
.var sprite_pt_09 = SCREEN_1+$03ff



.var left_wobble_pt = $f2
.var right_wobble_pt = $f1
.var bottom_wobble_pt = ZP3

.var char_base = $4000


//;-----------plexer variables
.var MAXSPR          = 52	    //;Maximum number of sprites
.var STEP	= 4

.var numsprites      = ZP7     //;Number of sprites that the main program wants
                                //;to pass to the sprite sorter
.var sprupdateflag   = ZP8      //;Main program must write a nonzero value here
                                //;when it wants new sprites to be displayed
.var sortedsprites   = ZP9     //;Number of sorted sprites for the raster
                               //;interrupt
							   
.var sortorder       = ZP12+1           //;Order-table for sorting. Needs as many bytes
.var sortorderlast   = ZP12+MAXSPR           //;as there are sprites.


.var current_sprite_cnt = $e8
.var global_sprite_cnt = $e9
