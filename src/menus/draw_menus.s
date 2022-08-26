.data
MenuDificuldades_STR_TITULO:  .string "Jogo da Velha"
MenuDificuldades_STR_FACIL:   .string "1 - Facil"
MenuDificuldades_STR_MEDIO:   .string "2 - Medio"
MenuDificuldades_STR_DIFICIL: .string "3 - Dificil"


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

    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret