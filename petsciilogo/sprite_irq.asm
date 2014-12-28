stabilizer_irq:
          :open_irq()
          jsr mplex_sprite_bar
chrs1:
          lda #$0 //;Cambia in base a chrs_tbl (functions.asm)
          sta $d018
 bgcl1:
          lda #BLUE
          sta $d021

          asl $d019
          lda #<raster_bottom_irq sta $fffe
          lda #>raster_bottom_irq sta $ffff

bt_irq_line:
          lda irq_line_stop
          sta $d012


          :close_irq()
          rti       

fakeplayer:
          rts

raster_bottom_irq:
          :open_irq()

nxt_irq_lo:          
          lda #<irq sta $fffe
nxt_irq_hi:
          lda #>irq sta $ffff

          lda #$f9
          sta $d012

          ldy #2
          :wait()

          asl $d019
          lda chrs_tbl
          sta $d018
bgcl2:
          lda #BLUE
          sta $d021

          ldy #10
          :wait()
  
spronoff_0:     
          lda #0
          sta $d015
         
          lda #$9b
          sta open_brd+1

          :close_irq()
          rti 