.text
ENEMY_OUTPUT:
  beq s4, zero, FIM_ENEMY_OUTPUT

  # Chosing difficulties
  beq s5, zero, GET_EASY_OUTPUT # easy
  li t0, 1
  beq s5, t0, GET_MEDIUM_OUTPUT # medium <- Adicionar
  li t0, 2
  beq s5, t0, GET_HARD_OUTPUT # hard <- Adicionar

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

  xori s4, s4, 1 # Change Turns
  ret

GET_HARD_OUTPUT:

  xori s4, s4, 1 # Change Turns
  ret

FIM_ENEMY_OUTPUT:
  ret
