# Global Variables
#   s0: front buffer
#   s1: back buffer
#   s2: End of back buffer
#   s3: current frame address
#   s4: turn (0 - Player, 1 - ENEMY)
#   s5: dificulty
#	  s6: starting player (0 - Player, 1 - ENEMY)

.include "MACROSv21.s"

.text
# Initialization
INIT:
  # Reset board
	la t0, BOARD 
	sw zero, 0(t0)
	sw zero, 4(t0)
	sb zero, 8(t0)

  # Reset placar
  la t0, SCORE
  sh zero, 0(t0)
  sb zero, 2(t0)

  jal INIT_VIDEO

  li s4, 0
  mv s6, s4

MENUS:
  # Dificulty menu 
  la a0, MenuDificuldades # Menu Data
  jal DRAW_MENU
  mv s5, a0 # Putting dificulty in s5

  # Symbol menu
  # la a0, menu2
  la a0, MenuSimbolos # Menu Data
  jal DRAW_MENU
  beq a0, zero, CHOOSE_SYMBOL1
  j CHOOSE_SYMBOL2

CHOOSE_SYMBOL1:
  la t0, SYMBOL1_ANIMATION
  la t1, SYMBOL2_ANIMATION
  la t2, PLAYER_SYMBOL
  la t3, ENEMY_SYMBOL

  sw t0, 0(t2)
  sw t1, 0(t3)
  j GAME_LOOP
  

CHOOSE_SYMBOL2:
  la t0, SYMBOL1_ANIMATION
  la t1, SYMBOL2_ANIMATION
  la t2, PLAYER_SYMBOL
  la t3, ENEMY_SYMBOL

  sw t0, 0(t3)
  sw t1, 0(t2)
  j GAME_LOOP

GAME_LOOP:
  jal RENDER_GAME
  jal CHECK_VICTORY_CONDITION
  jal ENEMY_OUTPUT
  jal INPUT
  j GAME_LOOP

# Imports
.include "video.s"
.include "render_game.s"
.include "keyboard.s"
.include "enemy.s"
.include "menu.s"
.include "ai.s"
.include "game_logic.s"
.include "endscreens.s"
.include "./menus/draw_menus.s"
.include "SYSTEMv21.s"

# Data includes
.data
.align 2
.include "../data/Board.data"
.include "../data/MenuGanhou.data"
.include "../data/MenuPerdeu.data"
.include "../data/MenuEmpatou.data"
.include "../data/telaVelha.data"

# Animations
.data
.include "../data/xAnimation/x0.data"
.include "../data/xAnimation/x1.data"
.include "../data/xAnimation/x2.data"
.include "../data/xAnimation/x3.data"
.include "../data/xAnimation/x4.data"
.include "../data/xAnimation/x5.data"
.include "../data/oAnimation/o0.data"
.include "../data/oAnimation/o1.data"
.include "../data/oAnimation/o2.data"
.include "../data/oAnimation/o3.data"
.include "../data/oAnimation/o4.data"
.include "../data/oAnimation/o5.data"
