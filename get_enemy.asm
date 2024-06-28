.include "convenience.asm"
.include "game_settings.asm"


.data
	
	array_of_enemies:	.word 17, 45, 1, 1, 
	                              20,  5, 1, 1, 
	                              20, 35, 1, 1, 
	                              45, 45, 1, -1 
	                              28, 35, 1, -1# Total size = 5enemies * 4words: x, y, enemy_state(1, is active; 0 is dead), direction(enemy_speed)
                              
.text

# This function needs to be visible outside of this file
.globl enemy_get_element
# address pixel_get_element(index)
enemy_get_element:
	la	t0, array_of_enemies# First we load the address of the beginning of the array
				
	mul	t1, a0, 16	# Then we multiply the index by 12
				#	(the size of a enemy struct) to calculate the offset
	add	v0, t0, t1	# Finally add the offset to the address of the beginning of the array
	# Now v0 contains the address of the element i of the array
	jr	ra
