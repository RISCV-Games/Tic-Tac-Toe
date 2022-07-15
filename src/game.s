# Global Variables
#   s0: front buffer
#   s1: back buffer
#   s2: End of back buffer
#   s3: current frame address

.text
# Initialization
INIT:
  jal INIT_VIDEO
  li s7, 1 # Do not render inverted

MAIN:
  la a0, tabuleiroTeste
  li a1, 0
  li a2, 0
  jal RENDER
  jal SWAP_FRAMES
  j MAIN


# Imports
.include "video.s"
# .include "keyboard.s"

# Data includes
.data
.include "../data/tabuleiroTeste.data"
