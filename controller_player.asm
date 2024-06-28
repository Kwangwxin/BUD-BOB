.include"convenience.asm"
.include"game_settings.asm"

.eqv    MAX_JUMP 15

.globl  direction_mark
.data

jump_counter:     .word 0
direction_mark:   .word 0 # 0 means right, 1 means left


.text

.globl player_update


# void player_update(current_frame)

player_update:
        enter s0, s1, s2, s3, s4, s5
 
        lw          s0, player_x
        lw          s1, player_y
        jal         gravity 
     
  check_right: 
        lw          t1, right_pressed
        bne         t1, 1, check_left
        # mark direction as right, set it 0
        lw          t2, direction_mark
        li          t2, 0
        sw          t2, direction_mark
        
    #check walls
        move       a1, s1
        move       a2, s0
        la	   a0, board

	# calculate the 5x5 pixels's position 
	
        div      a1, a1, 5  # y coordiante
        
        addi     a2, a2, 5
        div      a2, a2, 5 # x coordiante
        #addi     a2, a2, 1 # x+1 check right pixel
              
        li	 a3, 12 # 12 elements in each row
	jal	 calc_elem_addr
               
	lw	   s2, (v0)      
        beq        s2, 1, check_left  # if pixel is 1, cannot move then check left, otherwise check the bottom corner
        
      #check bottom if it hits the walls
        move       a1, s1
        move       a2, s0
        la	   a0, board

	# calculate the 5x5 pixels's position 
	addi      a1, a1, 4
        div       a1, a1, 5  # y coordiante
        
        addi      a2, a2, 5
        div       a2, a2, 5 # x coordiante
        #addi     a2, a2, 1 # x+1 check right pixel
              
        li	  a3, 12 # 12 elements in each row
	jal	  calc_elem_addr
               
	lw	   s3, (v0)      
        bne        s3, 1, shift_right  # if pixel is 0, no wall exits, shift right; otherwise cannot move  
        
	j          check_left
            
       shift_right:  
        addi        s0, s0, 1  
        # check if it is not going to leave the boundary  
        lw          t0, platform_w  
        addi        t0, t0, -4
        bgt         s0, t0, check_left 
        sw          s0, player_x   
             
   check_left:
        lw          t1, left_pressed
        bne         t1, 1, check_jump 
        # mark direction as left, set it 1
        lw          t2, direction_mark
        li          t2, 1
        sw          t2, direction_mark    
        addi        s0, s0, -1
     #check walls
        move       a1, s1
        move       a2, s0
        la	   a0, board

	# calculate the 5x5 pixels's position 
	
        div      a1, a1, 5  # y coordiante
       # addi     a2, a2, -2
        div      a2, a2, 5 # x coordiante
        
              
        li	 a3, 12 # 12 elements in each row
	jal	 calc_elem_addr
        
	lw	   s3, (v0)      
        beq        s3, 1, check_jump  # if pixel is 1, there's wall exits, it cannot move so check jump; otherwise check the bottom 
        
      #check bottom if it hits the walls
        move       a1, s1
        move       a2, s0
        la	   a0, board

	# calculate the 5x5 pixels's position 
	addi      a1, a1, 4
        div       a1, a1, 5  # y coordiante
       # addi     a2, a2, -2
        div       a2, a2, 5 # x coordiante
        
              
        li	  a3, 12 # 12 elements in each row
	jal	  calc_elem_addr
        
	lw	   s4, (v0)      
        bne        s4, 1, shift_left  # if pixel is 0, no wall exits, shift left; otherwise cannot move
	j          check_jump
         
      shift_left:
        blt         s0, 0, check_jump          # check if it is not going to leave the boundary
               
        sw          s0, player_x

    check_jump:
        lw          t1, up_pressed
        bne         t1, 1, check_bullet
     #check walls for left top 
        move        a1, s1
        move        a2, s0
        la	    a0, board

	# calculate the 5x5 pixels's position 
	addi        a1, a1, -1 # y-1, check the if there's a wall when jump 1
        div         a1, a1, 5  # y coordiante

       # addi     a2, a2, -2
        div         a2, a2, 5 # x coordiante
              
        li	    a3, 12 # 12 elements in each row
	jal	    calc_elem_addr
        
	lw	    s3, (v0)      
        beq         s3, 1, no_jump  # if pixel is 1, cannot move, otherwise, check walls for right top        
        
      #check walls for right top 
        move        a1, s1
        move        a2, s0
        la	    a0, board

	# calculate the 5x5 pixels's position 
	addi        a1, a1, -1 # y-1, check the if there's a wall when jump 1
        div         a1, a1, 5  # y coordiante

        addi        a2, a2, 4
        div         a2, a2, 5 # x coordiante
              
        li	    a3, 12 # 12 elements in each row
	jal	    calc_elem_addr
        
	lw	    s4, (v0)      
        bne         s4, 1, jump  # if pixel is 0, no wall exits, jump; otherwise cannot move
      
	j          check_bullet   
     
       
     jump:  
        beq         s1, 0,check_bullet          # check if it is not going to leave the boundary
       # sub         s1, s1, 5       
       # sw          s1, player_y
        #jal         do_nothing
        jal         check_ground
        lw          t0, jump_counter
        
        beq         t0, 0, no_jump
        sub         s1, s1, 1            
        sw          s1, player_y


        lw          t0, jump_counter
        addi        t0, t0, -1  
        sw          t0, jump_counter 
   no_jump:
     
     check_bullet:
        lw          t1, action_pressed
        bne         t1, 1, do_nothing # if B pressed, activate projectile, set its' location before player
        # load direction 
        li          t0, 1
        sw          t0, projectile_state 
        lw          t2, direction_mark
        bne         t2, 0, bullet_left # if direction_mark is 0, then fire to right; 1, fire to left
        
        lw          t4, projectile_x
        lw          t5, projectile_y
        move        t4, s0
        addi        t4, t4, 5    # bullet at(x + 5, y)
        move        t5, s1
        
        
        sw          t4, projectile_x
        sw          t5, projectile_y
        j           do_nothing
       bullet_left:
        
        lw          t4, projectile_x
        lw          t5, projectile_y
        move        t4, s0
        addi        t4, t4, -1    # bullet at(x - 1, y )
        move        t5, s1
        
        
        sw          t4, projectile_x
        sw          t5, projectile_y          
           

    do_nothing:
        
        
        leave       s0, s1, s2, s3, s4, s5
        
         
        
    gravity:
        enter     s0, s1, s3, s4
       
      #  lw          t0, platform_w  
       # addi        t0, t0, -15 
        #bge         s1, t0,stop  # check if it is not going to leave the boundary 
     #check walls for the left bottom
        move       a1, s1
        move       a2, s0
        la	   a0, board
# calculate the 5x5 pixels's position 
	addi     a1, a1, 5
        div      a1, a1, 5  # y coordiante
 
        div      a2, a2, 5 # x coordiante
        
              
        li	 a3, 12 # 12 elements in each row
	jal	 calc_elem_addr
        
	lw	   s3, (v0)      
        beq        s3, 1, stop  # if pixel is 1, cannot move, otherwise no wall exits, check right bottom
    #check walls for the right bottom
         move       a1, s1
         move       a2, s0
         la	    a0, board

    # calculate the 5x5 pixels's position 
	addi     a1, a1, 5
        div      a1, a1, 5  # y coordiante
      
        addi     a2, a2, 4  # x+5, right side of the sprite
        div      a2, a2, 5 # x coordiante
        
              
        li	  a3, 12 # 12 elements in each row
	jal	  calc_elem_addr
        
	lw	   s4, (v0)      
        bne        s4, 1, fall # if pixel is 0, no walls exists, otherwise cannot move, fall down
	j          stop 
     
        

       fall:
        addi        s1, s1, 1     # fall down: (x, y+1)
        sw          s1, player_y  

     stop:
        leave      s0, s1, s3, s4      
        
     check_ground:
         enter       s0, s1, s3, s4
         
         lw          s0, player_x
         lw          s1, player_y
         
       #check walls for left bottom
        move       a1, s1
        move       a2, s0
        la	   a0, board

	# calculate the 5x5 pixels's position 
	addi     a1, a1, 5
        div      a1, a1, 5  # y coordiante

        div      a2, a2, 5 # x coordiante
        
              
        li	 a3, 12 # 12 elements in each row
	jal	 calc_elem_addr

	lw	   s3, (v0)      
        beq        s3, 1, on_the_ground  # if pixel is 1, it is on the ground, set jump_counter, otherwise, check walls for the right bottom
  #check walls for the right bottom
         move       a1, s1
         move       a2, s0
         la	    a0, board

  # calculate the 5x5 pixels's position 
	addi       a1, a1, 5
        div        a1, a1, 5  # y coordiante
      
        addi       a2, a2, 4  # x+4, right side of the sprite
        div        a2, a2, 5 # x coordiante
        
              
        li	   a3, 12 # 12 elements in each row
	jal	   calc_elem_addr
        
	lw	   s4, (v0)      
        bne        s4, 1, no_ground # if pixel is 0, no ground for jump, otherwise it is on the ground for jump
              
	j          on_the_ground
      
      on_the_ground:
         lw          t1, jump_counter
         li          t1, MAX_JUMP
         sw          t1, jump_counter
      no_ground:   
         leave       s0, s1, s3, s4
         

     
