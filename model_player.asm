.include "convenience.asm"
.include "game_settings.asm"

.eqv NUM_LIFE 3

.globl player_x
.globl player_y
.globl player_sprite   
.globl player_lives

.data

player_sprite:       .byte   
                      COLOR_NONE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_NONE
                      COLOR_NONE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_NONE
                      COLOR_WHITE,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_WHITE
                      COLOR_NONE,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_NONE
                      COLOR_NONE,COLOR_WHITE,COLOR_NONE,COLOR_WHITE,COLOR_NONE        

player_x:             .word 0
player_y:             .word 0
player_lives:         .word NUM_LIFE

       




