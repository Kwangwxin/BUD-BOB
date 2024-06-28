.include "convenience.asm"
.include "game_settings.asm"

.data
bub:     .asciiz "BUB"
And:     .asciiz "AND"
bob:     .asciiz "BOB"
press:     .asciiz "PRESS B"
.text



.globl draw_welcome
.globl draw_platform
draw_welcome:
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
               # draw BUB
               li        a0, 22
               li        a1, 5
               la        a2, bub        
               jal       display_draw_text  
               # draw AND
               li        a0, 22
               li        a1, 12
               la        a2, And        
               jal       display_draw_text  
               # draw BOB
               li        a0, 22
               li        a1, 19
               la        a2, bob        
               jal       display_draw_text  
               # draw PRESS B
               li        a0, 12
               li        a1, 36
               la        a2, press        
               jal       display_draw_text  
               leave
               
               
# draw  platform(x, y, length)
# for(int s0 = 0; s0 < 12; s0++){    
#       a0(contains x) = top-left 
#	a1(contains y) = top-left
#       a3 contains length 
#	a2 = pointer to pattern (an array of 25 bytes stored row-by-row)      
#    display_blit_5x5();
# }

draw_platform:
               enter     s0, s1, s2, s3, s4
               move      s0, a0
               move      s1, a1
               move      s2, a2
               move      s3, a3
               li        s4, 0
draw_platform_loop:
               bge       s4, s3, draw_platform_loop_exit 
               move      a0, s0    
               li        t0, 5        
               mul       t0, t0, s4
               add       a0, a0, t0
               move      a1, s1
               la        a2, platform
               jal       display_blit_5x5  
               addi      s4, s4, 1    
               j         draw_platform_loop
draw_platform_loop_exit:
               
               leave     s0, s1, s2, s3, s4

#	a2 = pointer to string to print
     
