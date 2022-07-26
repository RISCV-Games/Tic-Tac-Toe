.text
ENEMY_OUTPUT:
  beq s4, zero, FIM_ENEMY_OUTPUT

  la t0, DELTATIME
  li t1, 10000
  sw t1, 0(t0)

  # Chosing difficulties
  beq s5, zero, GET_EASY_OUTPUT # easy
  li t0, 1
  beq s5, t0, GET_MEDIUM_OUTPUT # medium
  li t0, 2
  beq s5, t0, GET_HARD_OUTPUT # hard

  # Never Reaches
  j FIM_ENEMY_OUTPUT
  
GET_EASY_OUTPUT:
  li a0, 0 # Lower bound 
  li a1, 9 # Upper bound
  li a7, 42 # Get random number from lowwer bound to uppwer bound
  ecall

  la t0, BOARD
  add t0, t0, a0
  lb t1, 0(t0)
  bne t1, zero, GET_EASY_OUTPUT

  li t2, -1
  sb t2, 0(t0)

  xori s4, s4, 1 # Change Turns
  ret

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
  jal GET_EASY_OUTPUT
  lw ra, 0(sp)
  addi sp, sp, 4
  ret

END_GET_MEDIUM_OUTPUT:
  lw ra, 0(sp)
  addi sp, sp, 4

  xori s4, s4, 1
  ret

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
  ret

FIM_ENEMY_OUTPUT:
  ret
