# wew81
# Wenxin Wang

.include "convenience.asm"
.include "game_settings.asm"

#	Defines the number of frames per second: 16ms -> 60fps
.eqv	GAME_TICK_MS		16

.globl  Score
.data
# don't get rid of these, they're used by wait_for_next_frame.
last_frame_time:  .word 0
frame_counter:    .word 0             
Score:            .word 15 # base score is 15( lose all three lives, get 0   )                  
.text
# --------------------------------------------------------------------------------------------------

.globl game
game:
	# set up anything you need to here,
	# and wait for the user to press a key to start.
        jal     draw_welcome
        jal     display_update 
	# Wait for a key input
_game_wait:
	jal	input_get_keys
	beqz	v0, _game_wait

_game_loop:
        # check if it is time to stop game: if player lost all lives, stop; or enemies_num becomes 0
        lw     t0, player_lives
        beq    t0, 0, _game_over
        lw     t1, enemies_num
        beq    t1, 0, _game_over
	# check for input,
	jal     handle_input

	# update everything,
	lw	a0, frame_counter
	jal	player_update
	jal     enemy_update
	jal     projectile_update

	# draw everything
	jal     draw_arena        
	jal     player_draw 
	jal     enemy_draw 
	jal     projectile_draw  
	jal	display_update_and_clear
        
	## This function will block waiting for the next frame!
	jal	wait_for_next_frame
	b	_game_loop

_game_over:
        # show score before terminate the game
        jal     draw_score
        jal     display_update 
	exit



# --------------------------------------------------------------------------------------------------
# call once per main loop to keep the game running at 60FPS.
# if your code is too slow (longer than 16ms per frame), the framerate will drop.
# otherwise, this will account for different lengths of processing per frame.

wait_for_next_frame:
	enter	s0
	lw	s0, last_frame_time
_wait_next_frame_loop:
	# while (sys_time() - last_frame_time) < GAME_TICK_MS {}
	li	v0, 30
	syscall # why does this return a value in a0 instead of v0????????????
	sub	t1, a0, s0
	bltu	t1, GAME_TICK_MS, _wait_next_frame_loop

	# save the time
	sw	a0, last_frame_time

	# frame_counter++
	lw	t0, frame_counter
	inc	t0
	sw	t0, frame_counter
	leave	s0

# --------------------------------------------------------------------------------------------------



















