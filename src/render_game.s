.eqv board_size 9
.eqv x_board_offset 105
.eqv y_board_offset 25

.eqv x_tile_offset 80
.eqv y_tile_offset 80

.data
.align 2
BOARD: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0
PLAYER_SYMBOL: .word 0
ENEMY_SYMBOL: .word 0
SYMBOL1_ANIMATION: .word 6, 1, ax4, ax5, ax0, ax1, ax2, ax3
SYMBOL2_ANIMATION: .word 6, 1, o0, o1, o2, o3, o4, o5

DELTATIME: .word 0

.text
RENDER_GAME:
  # Saving return address in the stack

  csrr a0, time

  la t0, DELTATIME
  lw t1, 0(t0)
  sub t2, a0, t1
  li t3, 60
  bgeu t2, t3, RENDER_GAME_NEXT
  ret

RENDER_GAME_NEXT:
  sw a0, 0(t0)

  addi sp, sp, -4
  sw ra, 0(sp)
  # Rendering Back Ground
  la a0, Board
  li a1, 0
  li a2, 0
  jal RENDER

  # Rendering placar
  addi sp, sp, -32
  sw s0, 0(sp)
  sw s1, 4(sp)
  sw s2, 8(sp)
  sw s3, 12(sp)
  sw s4, 16(sp)
  sw s5, 20(sp)
  sw s6, 24(sp)
  sw s7, 28(sp)

  li a3, 0x09B6 # Color
  li a7, 101
  lw a4, 0(s3) # Frame
  xori a4, a4, 1

  # Pritando vitorias
  li a1, 45 # X
  li a2, 74 # Y
  la a0, SCORE
  lbu a0, 0(a0)
  ecall

  # Printando velhas
  li a1, 45 # X
  li a2, 90 # Y

  la a0, SCORE
  lbu t1, 0(a0) # Número de vitorias
  lbu t2, 1(a0) # Número de derrotas
  lbu a0, 2(a0) # Número total
  add t1, t1, t2 # Derrotas + vitorias
  sub a0, a0, t1
  ecall

  # Printando derrotas
  li a1, 45 # X
  li a2, 107 # Y
  la a0, SCORE
  lbu a0, 1(a0)
  ecall

  lw s0, 0(sp)
  lw s1, 4(sp)
  lw s2, 8(sp)
  lw s3, 12(sp)
  lw s4, 16(sp)
  lw s5, 20(sp)
  lw s6, 24(sp)
  lw s7, 28(sp)
  addi sp, sp, 32


  # Looping trough Board
  li t0, 0 # Iterador
  li t1, board_size 
  la t2, BOARD # base board adress

RENDER_GAME_LOOP:
  bge t0, t1, END_RENDER_GAME_LOOP
  add t3, t2, t0 # Getting adrees + iterator
  lb a0, 0(t3) # Getting value from board
  mv a1, t0 # Moving iterator to a1

  # saving Ts in stack so we can continue the loop
  addi sp, sp, -16
  sw t0, 0(sp)
  sw t1, 4(sp)
  sw t2, 8(sp)
  sw t3, 12(sp)
  # calling render symbol
  jal RENDER_SYMBOL
  # getting the values back
  lw t0, 0(sp)
  lw t1, 4(sp)
  lw t2, 8(sp)
  lw t3, 12(sp)
  addi sp, sp, 16

  # Incremmenting iterator
  addi t0, t0, 1
  j RENDER_GAME_LOOP

END_RENDER_GAME_LOOP:
  j FINISH_GAME_RENDER 
  
# Finish Render
FINISH_GAME_RENDER:
  # Swapping frames
  jal SWAP_FRAMES
  # Getting return address
  lw ra, 0(sp)
  addi sp, sp, 4
  ret

#####################
# a0: symbol value
# a1: symbol position
RENDER_SYMBOL:
  # Saving return adress in the stack
  addi sp, sp, -4
  sw ra, 0(sp)

  # Matching values to Symbol
  beq a0, zero, END_RENDER_SYMBOL
  li t0, 1
  beq a0, t0, RENDER_SYMBOL_PLAYER
  li t0, -1
  beq a0, t0, RENDER_SYMBOL_ENEMY

  j END_RENDER_SYMBOL

RENDER_SYMBOL_PLAYER:
  li t0, 3
  rem t1, a1, t0 # t1 = x
  div t2, a1, t0 # t2 = y
  # posição y final = (y * y_tile_offset) + y_board_offset
  # posição x final = (x * x_tile_offset) + x_board_offset

  li t3, x_tile_offset
  li t4, y_tile_offset

  mul t5, t3, t1
  mul t6, t4, t2

  la a0, PLAYER_SYMBOL
  lw a0, 0(a0)
  addi a1, t5, x_board_offset
  addi a2, t6, y_board_offset
  jal DRAW_ANIMATION
  j END_RENDER_SYMBOL

RENDER_SYMBOL_ENEMY:
  li t0, 3
  rem t1, a1, t0 # t1 = x
  div t2, a1, t0 # t2 = y
  # posição y final = (y * y_tile_offset) + y_board_offset
  # posição x final = (x * x_tile_offset) + x_board_offset

  li t3, x_tile_offset
  li t4, y_tile_offset

  mul t5, t3, t1
  mul t6, t4, t2

  la a0, ENEMY_SYMBOL
  lw a0, 0(a0)
  addi a1, t5, x_board_offset
  addi a2, t6, y_board_offset
  jal DRAW_ANIMATION
  j END_RENDER_SYMBOL

END_RENDER_SYMBOL:
  # Getting back the return adress
  lw ra, 0(sp)
  addi sp, sp, 4
  ret


# a0 = label for animation
DRAW_ANIMATION:
  lw t0, 0(a0)   #Tamanho da animatição
  lw t1, 4(a0)  #Posicao atual da animacao
  ble t1, t0, DRAW_ANIMATION_PROX # Conferindo para ver se a animação acabou
  li t1, 1
  sw t1, 4(a0)

# Desenhando a sprite
DRAW_ANIMATION_PROX:  
  addi t2, t1, 1
  sw t2, 4(a0) 
  slli t1, t1, 2
  addi t1, t1, 4
  add a0, a0, t1
  lw a0, 0(a0)
  j RENDER
