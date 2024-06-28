.include "convenience.asm"
.include "game_settings.asm"

.data
your:     .asciiz "Your"
score:     .asciiz "Score:"
speed:     .word 0
decoration:          .byte   
                      COLOR_NONE,COLOR_NONE,COLOR_YELLOW,COLOR_NONE,COLOR_NONE
                      COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW
                      COLOR_NONE,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_NONE
                      COLOR_NONE,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_NONE
                      COLOR_NONE,COLOR_YELLOW,COLOR_NONE,COLOR_YELLOW,COLOR_NONE
.text


.globl draw_score


draw_score:
         enter
               # draw bottom line located at (2, 55)
               li     a0, 2                         
               li     a1, 55
               li     a2, 60
               li     a3, 2
               li     v1, COLOR_BLUE
               jal     display_fill_rect              
               #draw the right vertical boundary
               li     a0, 0                       
               li     a1, 0
               li     a2, 2
               li     a3, 64
               li     v1, COLOR_BLUE
               jal    display_fill_rect 
               #draw the left certucal boundary
               li     a0, 62                       
               li     a1, 0
               li     a2, 2
               li     a3, 64
               li     v1, COLOR_BLUE
               jal    display_fill_rect 
               #draw a horizontal platform
               li     a0, 2
               li     a1, 50
               li     a3, 12
               jal    draw_platform
               
               li         s0, 35
               li         s1, 45
               sw         s0, player_x
               sw         s1, player_y
               jal        player_draw  
           # show score
               
                # draw Your score:
               li        a0, 17
               li        a1, 5
               la        a2, your        
               jal       display_draw_text  
             
               li        a0, 17
               li        a1, 15
               la        a2, score        
               jal       display_draw_text  
               
               li       a0, 16
               li       a1, 25
               addi	a0, a0, 2            
               la       a2, decoration                                                                                 
               jal      display_blit_5x5_trans  
               
               li       a0, 37
               li       a1, 35
               addi	a0, a0, 2            
               la       a2, decoration                                                                                
               jal      display_blit_5x5_trans  

               lw         a2, Score           
               li        a0, 27
               li        a1, 30
               jal       display_draw_int       
      
           
               leave
               
               
               
               
               
