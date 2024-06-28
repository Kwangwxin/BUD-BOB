.include"convenience.asm"
.include"game_settings.asm"


.text

.globl player_draw       
#void player_draw(x_coordinate, y_coordinate)   
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to pattern (an array of 25 bytes stored row-by-row)


player_draw:   
               enter 
               lw      a0, player_x
               lw      a1, player_y
               addi	a0, a0, 2            
               la      a2, player_sprite                                                                                 
               jal     display_blit_5x5_trans   
               #jal     display_update 
               leave                                                                                                                                                                                                                                                                                                                                                  
