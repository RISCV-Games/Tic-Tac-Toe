.data
AI_INFO_ANTES: .word 0 0 # Ciclos por movimento - Tempo por movimento
AI_INFO: .word 0 0 # Ciclos por movimento - Tempo por movimento

.text
ENEMY_OUTPUT:
  beq s4, zero, ENEMY_OUTPUT_END
  # Save current time
  csrr s10, time
  # la t0, AI_INFO_ANTES
  # sw a1, 4(t0)

  # Save current cycles
  # la t0, AI_INFO_ANTES
  csrr s11, cycle
  # sw t1, 0(t0)

  la t0, DELTATIME
  li t1, 10000
  sw t1, 0(t0)

  # Chosing difficulties
  beq s5, zero, GET_EASY_OUTPUT # easy
  li t0, 1
  beq s5, t0, GET_MEDIUM_OUTPUT # medium
  li t0, 2
  beq s5, t0, GET_HARD_OUTPUT # hard

ENEMY_OUTPUT_RET:

  # calculate time taken by the ai to make a move
  # la t0, AI_INFO
  # la t3, AI_INFO_ANTES
  # lw t1, 4(t3)
  csrr t0, time
  sub s10, t0, s10
  # sw t1, 4(t0)

  # calculate cycles taken by the ai to make a move
  # la t3, AI_INFO_ANTES
  # la t0, AI_INFO
  # lw t2, 0(t3)
  csrr t0, cycle
  sub s11, t0, s11
  # sw t1, 0(t0)

  ret
  
GET_EASY_OUTPUT:
  # Generate random number
  csrr a0, time
  li t0, 9
  remu a0, a0, t0

  la t0, BOARD
  add t0, t0, a0
  lb t1, 0(t0)
  bne t1, zero, GET_EASY_OUTPUT

  li t2, -1
  sb t2, 0(t0)

  xori s4, s4, 1 # Change Turns
  j ENEMY_OUTPUT_RET

GET_MEDIUM_OUTPUT:
  addi sp, sp, -4
  sw ra, 0(sp)

  # currentPlayer = (s4 == 0) ? 1:-1
  li t0, -2
  mul t0, t0, s4 
  addi t0, t0, 1 
  la t1, currentPlayer
  sb t0, 0(t1)

  # t0 = i = 0
  li t0, 0

LOOP1_GET_MEDIUM_OUTPUT:
  li t1, 9
  bge t0, t1, END_LOOP1_GET_MEDIUM_OUTPUT

  # if (BOARD[i] != 0) continue
  la t1, BOARD 
  add t1, t1, t0
  lb t2, 0(t1)
  bnez t2, CONTINUE_LOOP1_GET_MEDIUM_OUTPUT

  # BOARD[i] = currentPlayer
  la t2, currentPlayer
  lb t2, 0(t2)
  sb t2, 0(t1)

  addi sp, sp, -4
  sw t0, 0(sp)

  jal checkEnd 

  lw t0, 0(sp)
  addi sp, sp, 4

  # BOARD[i] = 0
  la t1, BOARD 
  add t1, t1, t0
  sb zero, 0(t1)

  # if (checkEnd() != currentPlayer) continue
  la t1, currentPlayer
  lb t1, 0(t1)
  bne a0, t1, CONTINUE_LOOP1_GET_MEDIUM_OUTPUT

  mv a0, t0 
  jal makeMove 
  jal END_GET_MEDIUM_OUTPUT

CONTINUE_LOOP1_GET_MEDIUM_OUTPUT:
  addi t0, t0, 1
  j LOOP1_GET_MEDIUM_OUTPUT

END_LOOP1_GET_MEDIUM_OUTPUT:
  # t0 = i = 0
  li t0, 0

LOOP2_GET_MEDIUM_OUTPUT:
  li t1, 9
  bge t0, t1, END_LOOP2_GET_MEDIUM_OUTPUT

  # if (BOARD[i] != 0) continue
  la t1, BOARD 
  add t1, t1, t0
  lb t2, 0(t1)
  bnez t2, CONTINUE_LOOP2_GET_MEDIUM_OUTPUT

  # BOARD[i] = -currentPlayer
  la t2, currentPlayer
  lb t2, 0(t2)
  li t3, -1
  mul t2, t2, t3
  sb t2, 0(t1)

  addi sp, sp, -4
  sw t0, 0(sp)

  jal checkEnd 

  lw t0, 0(sp)
  addi sp, sp, 4

  # BOARD[i] = 0
  la t1, BOARD 
  add t1, t1, t0
  sb zero, 0(t1)

  # if (checkEnd() != -currentPlayer) continue
  la t1, currentPlayer
  lb t1, 0(t1)
  li t2, -1
  mul t1, t1, t2
  bne a0, t1, CONTINUE_LOOP2_GET_MEDIUM_OUTPUT

  mv a0, t0 
  jal makeMove 
  jal END_GET_MEDIUM_OUTPUT

CONTINUE_LOOP2_GET_MEDIUM_OUTPUT:
  addi t0, t0, 1
  j LOOP2_GET_MEDIUM_OUTPUT

END_LOOP2_GET_MEDIUM_OUTPUT:
  lw ra, 0(sp)
  addi sp, sp, 4
  j GET_EASY_OUTPUT

END_GET_MEDIUM_OUTPUT:
  lw ra, 0(sp)
  addi sp, sp, 4

  xori s4, s4, 1
  j ENEMY_OUTPUT_RET

GET_HARD_OUTPUT:
  # currentPlayer = (s4 == 0) ? 1:-1
  li t0, -2
  mul t0, t0, s4 
  addi t0, t0, 1 
  la t1, currentPlayer
  sb t0, 0(t1)

  addi sp, sp, -4
  sw ra, 0(sp)

  jal findBestMove

  lw ra, 0(sp)
  addi sp, sp, 4

  la t0, currentPlayer
  lb t0, 0(t0)
  la t1, BOARD 
  add t1, t1, a0
  sb t0, 0(t1)

  xori s4, s4, 1 # Change Turns
  j ENEMY_OUTPUT_RET

FIM_ENEMY_OUTPUT:
	j ENEMY_OUTPUT_RET

ENEMY_OUTPUT_END:
  ret
