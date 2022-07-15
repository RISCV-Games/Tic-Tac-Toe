.eqv board_size 9
.eqv x_board_offset 40
.eqv y_board_offset 32

.eqv x_tile_offset 104
.eqv y_tile_offset 76

.data
BOARD: .byte 1, 1, 1, -1, 0, -1, 1, 1, 1
PLAYER_SYMBOL: .word 0
ENEMY_SYMBOL: .word 0

.text
RENDER_GAME:
  # Saving return address in the stack
  addi sp, sp, -4
  sw ra, 0(sp)
  # Rendering Back Ground
  la a0, tabuleiroTeste
  li a1, 0
  li a2, 0
  jal RENDER

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
  jal RENDER
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
  jal RENDER
  j END_RENDER_SYMBOL

END_RENDER_SYMBOL:
  # Getting back the return adress
  lw ra, 0(sp)
  addi sp, sp, 4
  ret

