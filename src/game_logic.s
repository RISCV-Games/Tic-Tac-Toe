.eqv game_ongoing 2
.eqv player_win 1
.eqv player_loose -1
.eqv player_draw 0

.data 
# SCORE + 0 = &WINS
# SCORE + 1 = &LOSSES
# SCORE + 2 = &TOTAL
SCORE: .byte 0 0 0

.text

# ---------------------------------------------------
# Helper function for determining if the game is over.
# Returns 1 if O wins, -1 if X wins, 0 otherwise.
# a0 = start
# a1 = inc
checkEndHelper:
	# t0 = &BOARD[start]
	la t0, BOARD 
	add t0, t0, a0
	
	# t1 = &BOARD[start+inc], t2 = &BOARD[start+2*inc]
	add t1, t0, a1 
	add t2, t1, a1
	
	# t0 = *t0
	lb t0, 0(t0)
	
	# t1 = *t1
	lb t1, 0(t1)
	bne t0, t1, checkEndHelper_false
	
	# t2 = *t2
	lb t2, 0(t2)
	bne t1, t2, checkEndHelper_false
	
	# Return winning player
	mv a0, t0
	ret
	
checkEndHelper_false:
	# Nobody won (in this check).
	mv a0, zero 
	ret

# ---------------------------------------------------
# Returns 0 if the game is drawn.
checkDraw:
	# t0 = i = 0
	li t0, 0
	
checkDraw_loop:
	li t1, 9
	bge t0, t1, checkDraw_drawn
	
	la t1, BOARD 
	add t1, t1, t0
	lb t1, 0(t1) 
	
	beqz t1, checkDraw_notDrawn
	
	addi t0, t0, 1
	j checkDraw_loop
	 
checkDraw_drawn:
	li a0, 0
	ret 
checkDraw_notDrawn:
	li a0, 1
	ret
	

# ---------------------------------------------------
# Returns player_win if O wins, player_loose if X wins, 
# player_draw if it is a draw and game_ongoing otherwise.
checkEnd:
	# Push ra to stack
	addi sp, sp, -4
	sw ra, 0(sp)
	
	
	li a0, 0
	li a1, 1
	call checkEndHelper 
	bnez a0, checkEnd_win
	
	li a0, 3
	li a1, 1
	call checkEndHelper 
	bnez a0, checkEnd_win
	
	li a0, 6
	li a1, 1
	call checkEndHelper 
	bnez a0, checkEnd_win
	
	li a0, 0
	li a1, 3
	call checkEndHelper 
	bnez a0, checkEnd_win
	
	li a0, 1
	li a1, 3
	call checkEndHelper 
	bnez a0, checkEnd_win
	
	li a0, 2
	li a1, 3
	call checkEndHelper 
	bnez a0, checkEnd_win
	
	li a0, 0
	li a1, 4
	call checkEndHelper 
	bnez a0, checkEnd_win
	
	li a0, 6
	li a1, -2
	call checkEndHelper 
	bnez a0, checkEnd_win


	# check draw
	call checkDraw
	bnez a0, checkEnd_notDraw
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
checkEnd_notDraw:
	# If no one has won or drawn, then the game is not over
	li a0, 2
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
checkEnd_win:
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

CHECK_VICTORY_CONDITION:
	addi sp, sp, -4
	sw ra, 0(sp)

	jal checkEnd 
	li t0, game_ongoing
	beq a0, t0, CHECK_VICTORY_CONDITION_END
	
	la t2, SCORE

	# if player won then *(SCORE)++;
	li t0, player_win 
	bne a0, t0, CHECK_VICTORY_CONDITION_NOT_WIN
	lbu t1, 0(t2)
	addi t1, t1, 1
	sb t1, 0(t2)

CHECK_VICTORY_CONDITION_NOT_WIN:
	# if player won then *(SCORE+1)++;	
	li t0, player_loose
	bne a0, t0, CHECK_VICTORY_CONDITION_NOT_LOOSE
	lbu t1, 1(t2)
	addi t1, t1, 1
	sb t1, 1(t2)

CHECK_VICTORY_CONDITION_NOT_LOOSE:
	lbu t0, 2(t2)
	addi t0, t0, 1
	sb t0, 2(t2)

	# if player won 5 matches goto win screen
	lbu t3, 0(t2)
	li t1, 5
	beq t3, t1, PLAYER_WIN_SCREEN

	# if player lost 5 matches goto loose screen
	lbu t4, 1(t2)
	beq t4, t1, PLAYER_LOOSE_SCREEN

	# if 20 games were drawn goto draw screen 
	add t0, t3, t4 
	bne t0, zero, CHECK_VICTORY_CONDITION_NOT_20_DRAWS
	li t0, 20 
	lbu t1, 2(t2)
	beq t1, t0, PLAYER_DRAW_SCREEN

CHECK_VICTORY_CONDITION_NOT_20_DRAWS:
	# otherwise, if 20 games were reached then the player with the most victories wins.
	li t0, 20 
	lbu t1, 2(t2)
	bne t1, t0, CHECK_VICTORY_CONDITION_MATCH_CONTINUES

	lbu t0, 0(t2)
	lbu t1, 1(t2)
	bgt t0, t1, PLAYER_WIN_SCREEN
	bgt t1, t0, PLAYER_LOOSE_SCREEN
	jal PLAYER_DRAW_SCREEN

CHECK_VICTORY_CONDITION_MATCH_CONTINUES:
	# remover esse ecall de sleep
	li a7, 32
	li a0, 2000
	#ecall

  # Reset board
	la t0, BOARD 
	sw zero, 0(t0)
	sw zero, 4(t0)
	sb zero, 8(t0)

	# alternate the starting player
	xori s4, s6, 1
	mv s6, s4


CHECK_VICTORY_CONDITION_END:
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
