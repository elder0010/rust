.var irq_ll = $31

stabilizer_irq:
          :open_irq()
          jsr stabilizer

          asl $d019

          ldy #9
          :wait()

        
          ldy #40
          :wait()

      
          :close_irq()
          rti       

stabilizer:
          ldx #irq_ll+1
lp1:
          cpx $d012
          bne lp1
          jsr cycles
          bit $ea
          nop
          cpx $d012
          beq skip1
          nop
          nop
skip1:    jsr cycles
          bit $ea
          nop
          cpx $d012
          beq skip2
          bit $ea
skip2:    jsr cycles
          nop
          nop
          nop
          cpx $d012
          bne onecycle
onecycle: rts

cycles:
         ldy #$05
lp2:     dey
         bne lp2
         inx
         bit $24
         
         rts