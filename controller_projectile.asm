.include"convenience.asm"
.include"game_settings.asm"
.include "struct_enemy.asm"

.eqv BULLET_TICK 10
.eqv NUM_ENEMIES 5
.data
#speed:            .word 30

last_frame_time:  .word 0
frame:            .word 0
.text

.globl projectile_update


# void projectile_update(current_frame)

projectile_update:
         enter s0, s1, s2, s3, s4
       
        lw          s0, projectile_x
        lw          s1, projectile_y
        # check if the projectile is active, if is 0, no bullet will be shot
        lw          t0, projectile_state  
        beq         t0, 0, no_fire 
        
        lw          t1, direction_mark
        bne         t1, 0, shoot_left
    # shoot right
        addi        s0, s0, 1         
     
        lw          t0, platform_w 
        bge         s0, t0, set_zero  # check if it is not going to leave the boundary, if not check walls
        
    #check walls 

        move       a1, s1
        move       a2, s0
        la	   a0, board

	# calculate the 5x5 pixels's position 	
        div        a1, a1, 5  # y coordiante

        div        a2, a2, 5 # x coordiante
        
              
        li	   a3, 12 # 12 elements in each row
	jal	   calc_elem_addr
               
	lw	   t0, (v0)      
        beq        t0, 1, set_zero  # if it is 0, no wall exits, shoot right; otherwise set to 0
           
        
    # check bullet collision
        li         s4, 0
    projectile_loop:       
        li          t0, NUM_ENEMIES
        bge         s4, t0, projectile_loop_exit
        
    check_collision_projectile:
        move        a0, s4
        jal         enemy_get_element
        lw          s2, enemy_x(v0)
        lw          s3, enemy_y(v0)  
        lw          t0, enemy_state(v0)
        beq         t0, 0, shift_right # if enemy is dead, continue     
      # if, Pry = Ey, then check if Px < Ex - 1, if so, not collide
        bne        s3, s1, shift_right     
        addi       t0, s2, -1
        bge        s0, t0, check_p  
        j          shift_right
       check_p:       
        # if Prx > Ex + 1, not collide
        addi       t1, s2, 1
        ble        s0, t1, set_zero
        j          shift_right
        
       
    shift_right:
        
        jal         pause
        sw          s0, projectile_x
    
        addi        s4, s4, 1            # loop one more tine
        j           projectile_loop


        
   shoot_left:
        addi        s0, s0, -1   
        ble         s0, 0, set_zero      # check if it is not going to leave the boundary, if not check walls
     #check walls 
        move       a1, s1
        move       a2, s0
        la	   a0, board

    # calculate the 5x5 pixels's position 
	
        div      a1, a1, 5  # y coordiante
        div      a2, a2, 5 # x coordiante              
        li	 a3, 12 # 12 elements in each row
	jal	 calc_elem_addr
               
	lw	   t0, (v0)      
        beq        t0, 1, set_zero  # if it is 0, no wall exits, shoot left; otherwise cannot move  
        
        li        s4, 0    
      # check bullet collision
  projectile_loop_left:
        li          t0, NUM_ENEMIES
        bge         s4, t0, projectile_loop_exit
        
     check_collision_projectile2:
        move        a0, s4
        jal         enemy_get_element
        lw          s2, enemy_x(v0)
        lw          s3, enemy_y(v0)  
        lw          t0, enemy_state(v0)
        beq         t0, 0, shift_left # if enemy is dead, continue             
      # if, Pry = Ey, then check if Px < Ex - 1, if so, not collide
        bne        s3, s1, shift_left     
        addi       t0, s2, -1
        bge        s0, t0, check_p2  
        j          shift_left
       check_p2:       
        # if Prx > Ex + 1, not collide
        addi       t1, s2, 1
        ble        s0, t1, set_zero  
       
        
   shift_left:       
        jal         pause  
        sw          s0, projectile_x 
        addi        s4, s4, 1            # loop one more tine
        j           projectile_loop_left
     
                                  
       set_zero:      
        
        lw          t2, projectile_state # deactivate projectile
        li          t2, 0
        sw          t2, projectile_state 
   
projectile_loop_exit:

     no_fire:
        leave  s0, s1, s2,s3
        
   
   
   pause:
	enter	s0
	lw	s0, last_frame_time
_wait_next_frame_loop:
	# while (sys_time() - last_frame_time) < GAME_TICK_MS {}
	li	v0, 30
	syscall # why does this return a value in a0 instead of v0????????????
	sub	t1, a0, s0
	bltu	t1, BULLET_TICK, _wait_next_frame_loop

	# save the time
	sw	a0, last_frame_time

	# frame_counter++
	lw	t0, frame
	inc	t0
	sw	t0, frame
	leave	s0   
	       
##############################################JUNK CODE###############################################        
  # pause:
          enter
          #lw      a0, speed
          li      v0, 32
          syscall  
          leave
          





