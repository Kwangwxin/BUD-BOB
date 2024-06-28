.include"convenience.asm"
.include"game_settings.asm"


.text

.globl projectile_draw       
#sets the LED at (x,y) to color
#	a0 is x,
#	a1 is y,
#	a2 is the color (use one of the constants above)
# returns:   none
projectile_draw:   
               enter 
               lw      t0, projectile_state 
               bne     t0, 1, not_active
               lw      a0, projectile_x
               lw      a1, projectile_y  
               addi    a1, a1, 2     # make bullet locate at the center of player's side     
               li      a2, COLOR_RED
               jal     display_set_pixel
             not_active:
              
               leave
####################junk code#######################33

#projectile_draw:   
               enter 
               lw      t0, projectile_state 
               bne     t0, 1, not_active
               lw      a0, projectile_x
               lw      a1, projectile_y            
               #la      a2, projectile_shape                                                                                 
               jal     display_blit_5x5_trans   
               
             #  not_active: 
                 
               leave    
