.data
MenuDificuldades_STR_TITULO: .string "Jogo da Velha"
MenuDificuldades_STR_FACIL: .string "1 - Facil"
MenuDificuldades_STR_MEDIO: .string "2 - Medio"
MenuDificuldades_STR_DIFICIL: .string "3 - Dificil"


.text

MenuDificuldades:
    # saving ra
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 0x09090909
    jal DRAW_BACKGROUND

    la a0, MenuDificuldades_STR_TITULO
    li a1, 160
    li a2, 60
    li a3, 0x000009ff
    li a4, 1
    li a7, 104
    ecall

    
    lw ra,0 (sp)
    addi sp, sp, 4
    ret