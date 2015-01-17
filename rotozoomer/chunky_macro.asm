//;-------------------------------------------------------------------------
//; Macro per double buffering
//;-------------------------------------------------------------------------
.macro point_screen_1(){
    lda #>targetHiBuffer1
    sta target_buffer_hi+2 
    lda #<targetHiBuffer1
    sta target_buffer_hi+1    
    lda #>targetLowBuffer1
    sta target_buffer_lo+2    
    lda #<targetLowBuffer1
    sta target_buffer_lo+1    
}


.macro point_screen_2(){
    lda #>targetHiBuffer2
    sta target_buffer_hi+2    
    lda #<targetHiBuffer2
    sta target_buffer_hi+1    
    lda #>targetLowBuffer2
    sta target_buffer_lo+2    
    lda #<targetLowBuffer2
    sta target_buffer_lo+1    
}