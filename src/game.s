# Global Variables
#   s0: front buffer
#   s1: back buffer
#   s2: End of back buffer
#   s3: current frame address
#   s4: turn (0 - Player, 1 - ENEMY)
#   s5: dificulty

.text
# Initialization
INIT:
  jal INIT_VIDEO

  li s4, 0

MENUS:
  # Dificulty menu 
  la a0, menu2teste # Menu Data
  jal DRAW_MENU
  mv s5, a0 # Putting dificulty in s5

  # Symbol menu
  # la a0, menu2
  la a0, menu1teste # Menu Data
  jal DRAW_MENU
  beq a0, zero, CHOOSE_SYMBOL1
  j CHOOSE_SYMBOL2

CHOOSE_SYMBOL1:
  la t0, heroStop1
  la t1, malina1
  la t2, PLAYER_SYMBOL
  la t3, ENEMY_SYMBOL

  sw t0, 0(t2)
  sw t1, 0(t3)
  j GAME_LOOP
  

CHOOSE_SYMBOL2:
  la t0, heroStop1
  la t1, malina1
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

# Data includes
.data
.include "../data/tabuleiroTeste.data"
.include "../data/heroStop1.data"
.include "../data/malina1.data"
.include "../data/menu1teste.data"
.include "../data/menu2teste.data"
