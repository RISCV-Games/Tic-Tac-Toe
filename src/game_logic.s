.eqv game_ongoing 2

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
# Returns 1 if O wins, -1 if X wins, 0 if it is a draw and 2 otherwise.
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

	# remover esse ecall de sleep
	li a7, 32
	li a0, 2000
	ecall

	la t0, BOARD 
	sw zero, 0(t0)
	sw zero, 4(t0)
	sb zero, 8(t0)


CHECK_VICTORY_CONDITION_END:
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
