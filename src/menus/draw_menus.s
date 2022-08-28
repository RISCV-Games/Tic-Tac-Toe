.data
MenuDificuldades_STR_TITULO:  .string "Jogo da Velha"
MenuDificuldades_STR_FACIL:   .string "1 - Facil"
MenuDificuldades_STR_MEDIO:   .string "2 - Medio"
MenuDificuldades_STR_DIFICIL: .string "3 - Dificil"
MenuDificuldades_STR_SAIR: .string "Aperte Q para sair"
MenuSimbolos_STR_ESCOLHA: .string "Escolha um simbolo para jogar:"
MenuSimbolos_STR_X: .string "1 - X"
MenuSimbolos_STR_O: .string "2 - O"
MenuGanhou_STR_PRINCIPAL: .string "PARABENS, VOCE GANHOU"
MenuGanhou_STR_CONTINUAR: .string "1 - Continuar"
MenuGanhou_STR_SAIR: .string "2 - Sair"
MenuPerdeu_STR_PRINCIPAL: .string "VOCE PERDEU"
MenuEmpatou_STR_PRINCIPAL: .string "DEU VELHA!"
MENU_INFORMACOES_STR_FREQ: .string "Frequencia:"
MENU_INFORMACOES_STR_CICLOS: .string "Ciclos:" 
MENU_INFORMACOES_STR_INS: .string "Instrucoes:"
MENU_INFORMACOES_STR_TMP_MEDIDO: .string "Tempo Medido:"
MENU_INFORMACOES_STR_CPI: .string "CPI Media:"
MENU_INFORMACOES_STR_TMP_CALC: .string "Tempo Calculado:"
MENU_INFORMACOES_STR_CONTINUAR: .string "Aperte 1 para continuar o jogo"
.eqv FREQ 3571428
.eqv

.text

MenuDificuldades:
    # saving ra
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 0x09090909
    jal DRAW_BACKGROUND

	# Draw strings at the back frame
    la a0, MenuDificuldades_STR_TITULO
    li a1, 100
    li a2, 20
    li a3, 0x000009ff
    lw a4, 0(s3)
	xori a4, a4, 1
    li a7, 104
    ecall

	la a0, MenuDificuldades_STR_FACIL
	li a1, 120
	li a2, 80
	ecall

	la a0, MenuDificuldades_STR_MEDIO
	li a1, 120
	li a2, 100
	ecall

	la a0, MenuDificuldades_STR_DIFICIL
	li a1, 120
	li a2, 120
	ecall

	la a0, MenuDificuldades_STR_SAIR
	li a1, 175
	li a2, 220
	ecall

    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

MenuSimbolos:
    # saving ra
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 0x09090909
    jal DRAW_BACKGROUND

	# Draw strings at the back frame
    la a0, MenuSimbolos_STR_ESCOLHA
    li a1, 40
    li a2, 20
    li a3, 0x000009ff
    lw a4, 0(s3)
	xori a4, a4, 1
    li a7, 104
    ecall

	la a0, MenuSimbolos_STR_X
	li a1, 140
	li a2, 100
	ecall

	la a0, MenuSimbolos_STR_O
	li a1, 140
	li a2, 120
	ecall

	la a0, MenuDificuldades_STR_SAIR
	li a1, 175
	li a2, 220
	ecall

    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

MenuGanhou:
    # saving ra
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 0x09090909
    jal DRAW_BACKGROUND

	# Draw strings at the back frame
    la a0, MenuGanhou_STR_PRINCIPAL
    li a1, 80
    li a2, 20
    li a3, 0x000009ff
    lw a4, 0(s3)
	xori a4, a4, 1
    li a7, 104
    ecall

	la a0, MenuGanhou_STR_CONTINUAR
	li a1, 110
	li a2, 100
	ecall

	la a0, MenuGanhou_STR_SAIR
	li a1, 110
	li a2, 120
	ecall

    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

MenuPerdeu:
    # saving ra
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 0x09090909
    jal DRAW_BACKGROUND

	# Draw strings at the back frame
    la a0, MenuPerdeu_STR_PRINCIPAL
    li a1, 120
    li a2, 20
    li a3, 0x000009ff
    lw a4, 0(s3)
	xori a4, a4, 1
    li a7, 104
    ecall

	la a0, MenuGanhou_STR_CONTINUAR
	li a1, 110
	li a2, 100
	ecall

	la a0, MenuGanhou_STR_SAIR
	li a1, 110
	li a2, 120
	ecall

    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

MenuEmpatou:
    # saving ra
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 0x09090909
    jal DRAW_BACKGROUND

	# Draw strings at the back frame
    la a0, MenuEmpatou_STR_PRINCIPAL
    li a1, 120
    li a2, 20
    li a3, 0x000009ff
    lw a4, 0(s3)
	xori a4, a4, 1
    li a7, 104
    ecall

	la a0, MenuGanhou_STR_CONTINUAR
	li a1, 110
	li a2, 100
	ecall

	la a0, MenuGanhou_STR_SAIR
	li a1, 110
	li a2, 120
	ecall

    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
	
MENU_INFORMACOES:
    # saving ra
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 0
    jal DRAW_BACKGROUND

	# Draw strings at the back frame
    la a0, MENU_INFORMACOES_STR_FREQ
    li a1, 0
    li a2, 5
    li a3, 0x38
    lw a4, 0(s3)
	xori a4, a4, 1
    li a7, 104
    ecall

	# Print freq
	li a7, 101
	li a0, FREQ
	li a1, 180
	li a2, 5
	ecall

	la a0, MENU_INFORMACOES_STR_CICLOS
	li a1, 3
	li a2, 25
	li a7, 104
	ecall

	# Print cycles
	li a7, 101
	mv a0, s11
	li a1, 180
	li a2, 25
	ecall

	la a0, MENU_INFORMACOES_STR_INS
	li a1, 3
	li a2, 45
	li a7, 104
	ecall

	# Print instructions
	li a7, 101
	mv a0, s11
	li a1, 180
	li a2, 45
	ecall

	la a0, MENU_INFORMACOES_STR_TMP_MEDIDO
	li a1, 3
	li a2, 65
	li a7, 104
	ecall

	# Print time
	li a7, 101
	mv a0, s10
	li a1, 180
	li a2, 65
	ecall

	la a0, MENU_INFORMACOES_STR_CPI
	li a1, 3
	li a2, 85
	li a7, 104
	ecall

	# Print cpi
	li a7, 101
	li a0, 1
	li a1, 180
	li a2, 85
	ecall

	la a0, MENU_INFORMACOES_STR_TMP_CALC
	li a1, 3
	li a2, 105
	li a7, 104
	ecall

	# a0 = tempo calculado
	li a0, FREQ
	li t0, 1000
	mul t0, s11, t0
	divu a0, t0, a0

	# Print tempo calculado
	li a7, 101
	li a1, 180
	li a2, 105
	ecall

	la a0, MENU_INFORMACOES_STR_CONTINUAR
	li a1, 3
	li a2, 200
	li a7, 104
	ecall

	jal SWAP_FRAMES

MENU_INFORMACOES_INPUT_LOOP:
  li t1,0xFF200000		      # carrega o endere�o de controle do KDMMIO
  lw t0,0(t1)			          # Le bit de Controle Teclado
  andi t0,t0,0x0001		      # mascara o bit menos significativo
  beq t0,zero, MENU_INFORMACOES_INPUT_LOOP	  # não tem tecla pressionada ent�o volta ao loop
  lw t2,4(t1)			          # le o valor da tecla
  	
  # Go inside options
  	li t0, '1'
	beq t2, t0, MENU_INFORMACOES_OP
  	j MENU_INFORMACOES_INPUT_LOOP


MENU_INFORMACOES_OP:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret