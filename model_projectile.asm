.include "convenience.asm"
.include "game_settings.asm"



.globl projectile_x
.globl projectile_y
#.globl projectile_shape   

.globl projectile_state 

.data
   
#projectile_shape:       .byte   
                     # COLOR_NONE,COLOR_NONE,COLOR_NONE,COLOR_NONE,COLOR_NONE
                     # COLOR_NONE,COLOR_NONE,COLOR_NONE,COLOR_NONE,COLOR_NONE
                     # COLOR_NONE,COLOR_NONE,COLOR_RED ,COLOR_NONE,COLOR_NONE
                     # COLOR_NONE,COLOR_NONE,COLOR_NONE,COLOR_NONE,COLOR_NONE
                     # COLOR_NONE,COLOR_NONE,COLOR_NONE,COLOR_NONE,COLOR_NONE 

projectile_x:             .word 0
projectile_y:             .word 0

projectile_state :        .word 1 # when projectile_state is 1, means it is active； 0, it is not active



