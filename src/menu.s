.text
# a0: menu image
DRAW_MENU:
  # Drawing MENU
  addi sp, sp, -4
  sw ra, 0(sp)

  li a1, 0
  li a2, 0
  jal RENDER
  jal SWAP_FRAMES

  lw ra, 0(sp)
  addi sp, sp, 4

  # Creating block input Loop
MENU_INPUT_LOOP:
	li t1,0xFF200000		      # carrega o endere�o de controle do KDMMIO
 	lw t0,0(t1)			          # Le bit de Controle Teclado
  andi t0,t0,0x0001		      # mascara o bit menos significativo
  beq t0,zero, MENU_INPUT_LOOP	  # não tem tecla pressionada ent�o volta ao loop
  lw t2,4(t1)			          # le o valor da tecla
  	
  # Go inside options
  li t0, 0x31			#1
	beq t2, t0, MENU_OP
	li t0, 0x32			#2
	beq t2 ,t0, MENU_OP
	li t0, 0x33			#3
	beq t2 ,t0, MENU_OP
	li t0, 0x34			#4
	beq t2 ,t0, MENU_OP
	li t0, 0x35			#5
	beq t2 ,t0, MENU_OP
	li t0, 0x36			#6
	beq t2 ,t0, MENU_OP
	li t0, 0x37			#7
	beq t2 ,t0, MENU_OP
	li t0, 0x38			#8
	beq t2 ,t0, MENU_OP
	li t0, 0x39			#9
	beq t2 ,t0, MENU_OP
	li t0, 'q'			  #Q
	beq t2 ,t0, MENU_SAIR
  j MENU_INPUT_LOOP

MENU_SAIR:
  li a7, 10
  ecall

MENU_OP:
  addi a0, t2, -0x31
  ret
