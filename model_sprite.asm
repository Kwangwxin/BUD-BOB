.include"convenience.asm"
.include"game_settings.asm"


.text

.globl sprite_draw       
#void player_draw(x_coordinate, y_coordinate)   
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to pattern (an array of 25 bytes stored row-by-row)


sprite_draw:   
               enter             
               la      a2, player_sprite                                                                                 
               jal     display_blit_5x5_trans   
               leave                  
