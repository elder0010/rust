.pc = * "Outro irq top"
.var scene_wait = $9d9c
.var scene_finished = $9d9f

outro_irq_top:
	:open_irq()

	lda #ORANGE
	sta $d020
	sta $d021

	asl $d019

.pc = * "nx irq line"
nx_irq_line:
	lda #$92
	sta $d012
	lda #$0b
	sta $d011

	lda #<outro_irq_bottom sta $fffe
	lda #>outro_irq_bottom sta $ffff
	:close_irq()
	rti

outro_irq_bottom:
	:open_irq()
	asl $d019
!:
	lda $d012
	cmp $d012
	bne !-

	ldy #17
	:wait()

	lda #BROWN
	sta $d020
	sta $d021

	lda #<outro_irq_msx sta $fffe
	lda #>outro_irq_msx sta $ffff

	dec nx_irq_line+1

	lda nx_irq_line+1
	bne !+
	lda #<final_irq sta $fffe
	lda #>final_irq sta $ffff
!:
	
	lda #$f9
	sta $d012

	//;lda #$b //;Mantengo lo schermo spento
	//;sta $d011

	:close_irq()
	rti

outro_irq_msx:
	:open_irq()
	asl $d019
	
	lda #$0
	sta $d012

	lda #<outro_irq_top sta $fffe
	lda #>outro_irq_top sta $ffff
	:set_addr(scene_finished,scene_wait)
	
	jsr $1003

	:close_irq()
	rti

final_irq:
	:open_irq()
	asl $d019

	:set_addr(scene_finished,scene_wait)
	
	
	//lda #<scene_finished
	//sta scene_wait+1
	jsr $1003
	

	:close_irq()
	rti