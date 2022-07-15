# Global Variables
#   s0: front buffer
#   s1: back buffer
#   s2: End of back buffer
#   s3: current frame address

.text
# Initialization
INIT:
  jal INIT_VIDEO

  la t0, heroStop1
  la t1, malina1
  la t2, PLAYER_SYMBOL
  la t3, ENEMY_SYMBOL

  sw t0, 0(t2)
  sw t1, 0(t3)

MAIN:
  jal RENDER_GAME
  jal HANDLE
  j MAIN


# Imports
.include "video.s"
.include "render_game.s"
# .include "keyboard.s"

# Data includes
.data
.include "../data/tabuleiroTeste.data"
.include "../data/heroStop1.data"
.include "../data/malina1.data"
