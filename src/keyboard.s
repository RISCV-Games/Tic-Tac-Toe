INPUT:
  bne s4, zero, INPUT_FIM

	li t1,0xFF200000		      # carrega o endere�o de controle do KDMMIO
 	lw t0,0(t1)			          # Le bit de Controle Teclado
  andi t0,t0,0x0001		      # mascara o bit menos significativo
  beq t0,zero, INPUT_FIM	  # não tem tecla pressionada ent�o volta ao loop
  lw t2,4(t1)			          # le o valor da tecla
  	
  # Go inside options
  li t0 0x31			#1
	beq t2, t0, OP
	li t0 0x32			#2
	beq t2 ,t0, OP
	li t0 0x33			#3
	beq t2 ,t0, OP
	li t0 0x34			#4
	beq t2 ,t0, OP
	li t0 0x35			#5
	beq t2 ,t0, OP
	li t0 0x36			#6
	beq t2 ,t0, OP
	li t0 0x37			#7
	beq t2 ,t0, OP
	li t0 0x38			#8
	beq t2 ,t0, OP
	li t0 0x39			#9
	beq t2 ,t0, OP
	li t0, 0x20			#ENTER
	beq t2, t0, INPUT_FIM
	li t0, 'w'
	beq t2, t0, MENU_CHEAT_WIN
	li t0, 'l'
	beq t2, t0, MENU_CHEAT_LOOSE
	li t0, 'd'
	beq t2, t0, MENU_CHEAT_DRAW
	li t0, 'm'
	beq t2, t0, MENU_INFORMACOES
	j INPUT_FIM

OP:
  addi a0, t2, -0x31

  addi sp, sp, -4
  sw ra, 0(sp)

  jal PLAYER_MOVE

  lw ra, 0(sp)
  addi sp, sp, 4
  j INPUT_FIM

PLAYER_MOVE:
  la t0, BOARD # Default 
  add t1, a0, t0
  li t2, 1

  lb t3, 0(t1)
  bnez t3, INPUT_FIM

  sb t2, 0(t1)

  la t0, DELTATIME
  li t1, 10000
  sw t1, 0(t0)

  xori s4, s4, 1
  ret

INPUT_FIM:
  ret

MENU_CHEAT_WIN:
	la t0, SCORE
	li t1, 4
	sb t1, 0(t0)
	sb t1, 2(t0)
	ret

MENU_CHEAT_LOOSE:
	la t0, SCORE
	li t1, 4
	sb t1, 1(t0)
	sb t1, 2(t0)
	ret

MENU_CHEAT_DRAW:
	la t0, SCORE
	li t1, 19
	sb t1, 2(t0)
	ret