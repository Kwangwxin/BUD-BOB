.include"convenience.asm"
.include"game_settings.asm"
.include "struct_enemy.asm"

.eqv ENEMY_TICK 90
.eqv NUM_ENEMIES 5
.data

speed:            .word 4

last_frame_time:  .word 0
frame:            .word 0
.text

.globl enemy_update


# void enemy_update(current_frame)

enemy_update:
        enter       s0, s1, s2, s3, s6, s7
        push        s4
        
         li         s4, 0
 enemy_loop:
        li          t1, NUM_ENEMIES
        bge         s4, t1, enemy_loop_exit
        move        a0, s4
        jal         enemy_get_element    
        lw          t0, enemy_state(v0)
        beq         t0, 0, do_nothing   # if enemy is dead(not active),  do_nothing
        
        lw          s0, enemy_x(v0)
        lw          s1, enemy_y(v0)
                
        lw          t0, platform_w   # check_boundary
        addi        t0, t0, -4
        bge         s0, t0, shift_direction   
        blt         s0, 0, shift_direction
        
      #check walls
      #check right walls
        move        a1, s1
        move        a2, s0
        la	    a0, board

	# calculate the 5x5 pixels's position 
	
        div        a1, a1, 5  # y coordiante
        
        addi       a2, a2, 5
        div        a2, a2, 5 # x coordiante
        #addi     a2, a2, 1 # x+1 check right pixel
              
        li	   a3, 12 # 12 elements in each row
	jal	   calc_elem_addr
               
	lw	   t0, (v0)   
	
        bne        t0, 0, shift_direction  # if pixel is 0, no wall exits, shift right; otherwise shift direction  
        
      # check left walls
     check_left_wall:
        move       a1, s1
        move       a2, s0
        la	   a0, board

	# calculate the 5x5 pixels's position 
	
        div       a1, a1, 5  # y coordiante       
        div       a2, a2, 5 # x coordiante
           
        li	  a3, 12 # 12 elements in each row
	jal	  calc_elem_addr
               
	lw	  t0, (v0)      
        bne       t0, 0, shift_direction  # if pixel is 0, no wall exits, shift right; otherwise cannot move  
          
    check_collision_player:
        lw          s2, player_x
        lw          s3, player_y      
        # if, Py = Ey, then check if Px < Ex - 4, if so, not collide
        bne        s1, s3, check_x
        addi       t0, s0, -4
        bge        s2, t0, check_2  
        j          check_collision_projectile
       check_2:       
        # if Px > Ex + 4, not collide
        addi       t1, s0, 4
        ble        s2, t1, collision
        j          check_collision_projectile
      check_x:
        # if, Px = Ex, then check if Py  < Ey - 4,if so,  not collide; otherwise, x and y both not in a line
        bne        s0, s2, check_collision_projectile
        addi       t2, s1, -4
        bge        s3, t2, check_another
        j          check_collision_projectile
      check_another:
        # if Py > Ey + 4, not collide
        addi       t3, s1, 4       
        ble        s3, t3, collision
         
        
     check_collision_projectile:
        lw          s6, projectile_x
        lw          s7, projectile_y  
             
      # if, Pry = Ey, then check if Px < Ex - 1, if so, not collide
        bne        s1, s7, shift     
        addi       t0, s0, -1
        bge        s6, t0, check_2p  
        j          shift
       check_2p:       
        # if Prx > Ex + 1, not collide
        addi       t1, s0, 1
        ble        s6, t1, collisionP
        j          shift
     
   collisionP:
         # deactivate enemy_state
         move     a0, s4
         jal      enemy_get_element
         lw       t0, enemy_state(v0)
         li       t0, 0
         sw       t0, enemy_state(v0)
        
         # decrement enemies_num
         lw       t1, enemies_num
         addi     t1, t1, -1
         sw       t1, enemies_num
         
         # increment score
         lw       t1, Score
         addi     t1, t1, 3 # shoot one enemy get 3 points
         sw       t1, Score
         j        do_nothing
    collision:
         # if collide, player lose one life
       
         lw         t4, player_lives
         addi       t4, t4, -1
         sw         t4, player_lives
         # reset player's location to start point
         lw         t2, player_x
         lw         t3, player_y
         li         t2, 0
         li         t3, 0
         sw         t2, player_x
         sw         t3, player_y
         # decrement score
         lw         t1, Score
         addi       t1, t1, -5 #shot by enemy lose 5 points
         sw         t1, Score
         j          shift_direction	
   shift:     
   	
        move        a0, s4
        jal         enemy_get_element
        lw          t1, enemy_speed(v0)

        add         s0, s0, t1  
        sw          s0, enemy_x(v0)        

        j           do_nothing
       
       
   shift_direction:
    
    
        move        a0, s4
        jal         enemy_get_element
        lw          t1, enemy_speed(v0)
        
        mul         t1, t1, -1
        
        add         s0, s0, t1  
        move        a0, s4
        
        sw          s0, enemy_x(v0)
        sw          t1, enemy_speed(v0) 
     
    do_nothing:  
        addi           s4, s4, 1
        j              enemy_loop 
       
  enemy_loop_exit:
           
        jal         pause
        pop    s4
        leave  s0, s1, s2, s3, s6, s7
        
   
   
   pause:
	enter	s0
	lw	s0, last_frame_time
  _wait_next_frame_loop:
	# while (sys_time() - last_frame_time) < GAME_TICK_MS {}
	li	v0, 30
	syscall # why does this return a value in a0 instead of v0????????????
	sub	t1, a0, s0
	bltu	t1, ENEMY_TICK, _wait_next_frame_loop

	# save the time
	sw	a0, last_frame_time

	# frame_counter++
	lw	t0, frame
	inc	t0
	sw	t0, frame
	leave	s0          
                  
    
       
                    
                                              
 ####################################################junk code##################3        

    
  #pause:
          enter
          lw      a0, speed
          li      v0, 32
          syscall  
          leave  