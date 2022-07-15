.text
ENEMY_INPUT:
  beq s4, zero, FIM_ENEMY_INPUT
  addi sp, sp, -4
  sw ra, 0(sp)
  jal GET_RANDOM_OUTPUT

  lw ra, 0(sp)
  addi sp, sp, 4

  xori s4, s4, 1 # Change Turns
  j FIM_ENEMY_INPUT
  
GET_RANDOM_OUTPUT:
  li a0, 0 # Lower bound 
  li a1, 9 # Upper bound
  li a7, 42 # Get random number from lowwer bound to uppwer bound
  ecall

  la t0, BOARD
  add t0, t0, a0
  lb t1, 0(t0)
  bne t1, zero, GET_RANDOM_OUTPUT

  li t2, -1
  sb t2, 0(t0)
  ret

FIM_ENEMY_INPUT:
  ret
