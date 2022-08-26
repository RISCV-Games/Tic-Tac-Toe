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

	la a0, MENU_INFORMACOES_STR_CICLOS
	li a1, 0
	li a2, 25
	ecall

	la a0, MENU_INFORMACOES_STR_INS
	li a1, 0
	li a2, 45
	ecall

	la a0, MENU_INFORMACOES_STR_TMP_MEDIDO
	li a1, 0
	li a2, 65
	ecall

	la a0, MENU_INFORMACOES_STR_CPI
	li a1, 0
	li a2, 85
	ecall

	la a0, MENU_INFORMACOES_STR_TMP_CALC
	li a1, 0
	li a2, 105
	ecall

	la a0, MENU_INFORMACOES_STR_CONTINUAR
	li a1, 0
	li a2, 200
	ecall

	la a0, MenuDificuldades_STR_SAIR
	li a1, 0
	li a2, 220
	ecall


    lw ra, 0(sp)
    addi sp, sp, 4
    ret