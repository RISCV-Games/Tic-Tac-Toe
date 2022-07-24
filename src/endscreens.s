PLAYER_WIN_SCREEN:
  la a0, telaVitoria 
  jal RENDER_END_SCREEN
PLAYER_LOOSE_SCREEN:
  la a0, telaDerrota 
  jal RENDER_END_SCREEN
PLAYER_DRAW_SCREEN:
  la a0, telaEmpate 
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
  li a0, 10000
  ecall
  
  li a7, 10
  ecall