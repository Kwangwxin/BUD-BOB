.include "convenience.asm"
.include "game_settings.asm"
.data
frame_counter:    .word 0   
.text

.globl main
main:
	# set up anything you need to here,
	# and wait for the user to press a key to start.
        
        jal     game
	exit
