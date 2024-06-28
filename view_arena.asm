.include "convenience.asm"
.include "game_settings.asm"

.globl    platform_w
.globl    platform_h
.globl    platform
.globl    board
.data
board:     .word  # 12x11 board (w 12, h 11), each is 5x5 pixels
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
           0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0
           0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0
           0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
           0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
           0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0
           0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0
           0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0
           0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
           1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1  
           
           
           
platform:     .byte   COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN
                      COLOR_YELLOW,COLOR_ORANGE,COLOR_ORANGE,COLOR_YELLOW,COLOR_ORANGE
                      COLOR_ORANGE,COLOR_YELLOW,COLOR_ORANGE,COLOR_YELLOW,COLOR_ORANGE
                      COLOR_YELLOW,COLOR_ORANGE,COLOR_ORANGE,COLOR_YELLOW,COLOR_YELLOW
                      COLOR_YELLOW,COLOR_ORANGE,COLOR_YELLOW,COLOR_ORANGE,COLOR_ORANGE     

platform_w:       .word 59
platform_h:       .word 46

.text

.globl  calc_row_addr
calc_row_addr:
# C.1 goes here
	push	ra
	# Row address is the base address + index * sizeof(row) = a0 + a1*(sizeof(word)*n_elements in row) = a0 + a1*(4*a2)
	mul	t0, a2, 4
	mul	t0, t0, a1
	add	v0, a0, t0
	pop	ra
	jr	ra

# This function calculates the address of the element (i, j) in a matrix of words
# Inputs:
#	 a0: The base address of the matrix
#	 a1: The index (i) of the row
#	 a2: The index (j) of the column
#	 a3: The number of elements in a row
# Outputs:
#	 v0: The address of the element
.globl  calc_elem_addr
calc_elem_addr:
# C.2 goes here
	push	ra
	# Row address is the base address + index * sizeof(row) = a0 + a1*(sizeof(word)*n_elements in row) = a0 + a1*(4*a3)
	mul	t0, a3, 4
	mul	t0, t0, a1
	add	v0, a0, t0
	# Element address is the row address + index * sizeof(element) = row address + a2*4
	mul	t0, a2, 4
	add	v0, v0, t0
	pop	ra
	jr	ra


.globl draw_arena
               
               
draw_arena: 
               enter      s0, s1, s2                                          
 # draw bottom line located at (2, 55)
               li     a0, 2                         
               li     a1, 55
               li     a2, 60
               li     a3, 2
               li     v1, COLOR_BLUE
               jal    display_fill_rect              

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
        
               
          #draw all platform   
  draw_platforms:  
               li	s0, 0 # y coordiante
     row_loop:
	       bge	s0, 11, row_loop_end
	# Iterate all columns in a for loop
	# for(s1=0; s1<5; s1++)
	       li	s1, 0 # x coordiante
     col_loop:
	        bge	s1, 12, col_loop_end
	# Do stuff
	# Get address of element i,j of matrix 1
	       la	a0, board
	       move	a1, s0
	       move	a2, s1
	       li	a3, 12 # 12 elements in each row
	       jal	calc_elem_addr
	# Load element from board from memory
	       lw	s2, (v0)
	      
	      
   # check if the elemnet is 1, if so, draw platform
	       bne      s2, 1, no_draw
#	a0(contains x) = top-left 
#	a1(contains y) = top-left 
#       a3 contains length 
#	a2 = pointer to pattern (an array of 25 bytes stored row-by-row)      
#       display_blit_5x5();
               li       t3, 5          
	
               move     a0, s1
               mul      a0, a0, t3
               addi     a0, a0, 2

               move     a1, s0
               mul      a1, a1, t3
               la       a2, platform
               jal      display_blit_5x5   
          no_draw:       
               addi	s1, s1, 1
	       j	col_loop
      col_loop_end:		
	# The for loop iterating all columns ends here!!
          
	        addi	s0, s0, 1
	        j	row_loop
      row_loop_end:
	# The for loop iterating all rows ends here!!
         
               jal    draw_life
               
          # show life information
          
                  
               leave  s0, s1, s2

# draw life information
draw_life:
             enter     s5
             li        s5, 0   # for(int s5 = 0; s5 < num_life; s5++)
draw_life_loop:
             lw        t1, player_lives
             bge       s5, t1, draw_life_loop_exit   # {
             li        a0, 42                              # sprite_draw()
             li        t0, 6
             mul       t0, t0, s5
             add       a0, a0, t0
             li        a1, 58
             jal       sprite_draw                         # x += 6
             addi      s5, s5, 1
             j         draw_life_loop                      #}
draw_life_loop_exit:
             leave     s5

 
