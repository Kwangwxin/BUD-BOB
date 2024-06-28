.include"convenience.asm"
.include"game_settings.asm"
.include "struct_enemy.asm"

.eqv NUM_ENEMIES 5
.text

.globl enemy_draw       
#void enemy_draw(x_coordinate, y_coordinate)   
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to pattern (an array of 25 bytes stored row-by-row)


enemy_draw:   
            
enter   s0, s1, s2, s3
               
               li      s3, 0
         get_loop:
               li      t0, NUM_ENEMIES               
               bge     s3, t0, get_loop_exit
               move    a0, s3
               jal     enemy_get_element
               lw      s0, enemy_x(v0) 	# x coordinate
               lw      s1, enemy_y(v0) 	# y coordinate
               lw      s2, enemy_state(v0)  #state, dead or not 
               beq     s2, 0, is_dead
               move    a0, s0
               addi    a0, a0, 2
               move    a1, s1            
               la      a2, enemy_sprite                                                                                 
               jal     display_blit_5x5_trans 
           is_dead:  
             
               addi    s3, s3, 1
               j       get_loop   
               
          get_loop_exit:
                     
               leave   s0, s1, s2, s3                                                                                                                                                                                                                                                                                                                                           
############################################junk code###########################3

               
                   
                       
                           
                               
     enter   s0, s1
             
               lw      s0, enemy_x 	# x coordinate
               lw      s1, enemy_y 	# y coordinate
               
               lw      t0, enemy_state
               beq     t0, 0, dont_draw
               move    a0, s0
               addi    a0, a0, 2
               move    a1, s1            
               la      a2, enemy_sprite                                                                                 
               jal     display_blit_5x5_trans 
           
            dont_draw:        
               leave   s0, s1                                    