.align $40
.import c64 "sprites\reverse\1\01.prg"
.align $40
.import c64 "sprites\reverse\1\02.prg"
.align $40
.import c64 "sprites\reverse\1\03.prg"
.align $40
.import c64 "sprites\reverse\1\04.prg"
.align $40
.import c64 "sprites\reverse\1\05.prg"
.align $40
.import c64 "sprites\reverse\1\06.prg"
.align $40
.import c64 "sprites\reverse\1\07.prg"

.align $40
.import c64 "sprites\reverse\2\01.prg"
.align $40
.import c64 "sprites\reverse\2\02.prg"
.align $40
.import c64 "sprites\reverse\2\03.prg"
.align $40
.import c64 "sprites\reverse\2\04.prg"
.align $40
.import c64 "sprites\reverse\2\05.prg"
.align $40
.import c64 "sprites\reverse\2\06.prg"
.align $40
.import c64 "sprites\reverse\2\07.prg"

.align $40
.import c64 "sprites\reverse\3\01.prg"
.align $40
.import c64 "sprites\reverse\3\02.prg"
.align $40
.import c64 "sprites\reverse\3\03.prg"
.align $40
.import c64 "sprites\reverse\3\04.prg"
.align $40
.import c64 "sprites\reverse\3\05.prg"
.align $40
.import c64 "sprites\reverse\3\06.prg"
.align $40
.import c64 "sprites\reverse\3\07.prg"

.align $40
.import c64 "sprites\reverse\4\01.prg"
.align $40
.import c64 "sprites\reverse\4\02.prg"
.align $40
.import c64 "sprites\reverse\4\03.prg"
.align $40
.import c64 "sprites\reverse\4\04.prg"
.align $40
.import c64 "sprites\reverse\4\05.prg"
.align $40
.import c64 "sprites\reverse\4\06.prg"
.align $40
.import c64 "sprites\reverse\4\07.prg"



.align $100 
.pc = * "sprites_table"
puntatori_reverse:
.byte [sprites_reverse/$40]
.byte [sprites_reverse/$40]+[7]*1
.byte [sprites_reverse/$40]+[7]*2
.byte [sprites_reverse/$40]+[7]*3
.byte [sprites_reverse/$40]+[7]*4
.byte [sprites_reverse/$40]+[7]*5
.byte [sprites_reverse/$40]+[7]*6

.pc = * "sprites y"
.var reverse_base = $b7 //; $b8
sprites_y_reverse:
.byte reverse_base,reverse_base+21,reverse_base+21*2,reverse_base+21*3
.byte reverse_base+21*4,reverse_base+21*5,reverse_base+21*6


