.include "convenience.asm"
.include "game_settings.asm"

.eqv NUM_ENEMIES 5

.globl enemy_sprite   
.globl enemies_num

.data
   
enemy_sprite:       .byte   
                      COLOR_NONE,COLOR_NONE,COLOR_WHITE,COLOR_NONE,COLOR_NONE
                      COLOR_WHITE,COLOR_WHITE,COLOR_MAGENTA,COLOR_WHITE,COLOR_WHITE
                      COLOR_NONE,COLOR_MAGENTA,COLOR_MAGENTA,COLOR_MAGENTA,COLOR_NONE
                      COLOR_NONE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_NONE
                      COLOR_NONE,COLOR_WHITE,COLOR_NONE,COLOR_WHITE,COLOR_NONE 

enemies_num:         .word NUM_ENEMIES

