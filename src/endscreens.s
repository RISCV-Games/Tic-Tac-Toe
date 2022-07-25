PLAYER_WIN_SCREEN:
  la a0, MenuGanhou
  jal RENDER_END_SCREEN
PLAYER_LOOSE_SCREEN:
  la a0, MenuPerdeu 
  jal RENDER_END_SCREEN
PLAYER_DRAW_SCREEN:
  la a0, MenuEmpatou 
  jal RENDER_END_SCREEN

# a0 = endscreen address
RENDER_END_SCREEN:
  # Drawing win screen
  addi sp, sp, -4
  sw ra, 0(sp)

  li a1, 0
  li a2, 0
  jal RENDER
  jal SWAP_FRAMES

  lw ra, 0(sp)
  addi sp, sp, 4

  li a7, 32
  li a0, 5000
  ecall

  la t0, SCORE 
  sb zero, 0(t0)
  sb zero, 1(t0)
  sb zero, 2(t0)

  # Reset board
	la t0, BOARD 
	sw zero, 0(t0)
	sw zero, 4(t0)
	sb zero, 8(t0)

  jal INIT
  
  li a7, 10
  ecall
