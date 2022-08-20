.data
.align 0
currentPlayer: .byte 0

.text
# ---------------------------------------------------
# Makes a move at movePos according to the current player and updates the current player.
# a0 = movePos
makeMove:
	# t0 = BOARD + a0 = &BOARD[movePos]
	la t0, BOARD 
	add t0, t0, a0
	# BOARD[movePos] = *currentPlayer
	lb t1, currentPlayer 
	sb t1, 0(t0)

	# *currentPlayer *= -1
	li t0, -1
	mul t1, t1, t0
	la t0, currentPlayer
	sb t1, 0(t0)

	ret

# ---------------------------------------------------
# Undos a move at movePos and updates the current player.
# a0 = movePos
undoMove:
	# t0 = BOARD + a0 = &BOARD[movePos]
	la t0, BOARD 
	add t0, t0, a0
	# BOARD[movePos] = 0
	sb zero, 0(t0)

	# *currentPlayer *= -1
	lb t1, currentPlayer 
	li t0, -1
	mul t1, t1, t0
	la t0, currentPlayer
	sb t1, 0(t0)

	ret

# ---------------------------------------------------
# Returns the best move (a0) and the position evaluation (a1) for the current player
findBestMove:
	# save s0, s1 and ra
	addi sp, sp, -20
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)

	# Base case
	call checkEnd 
	li t0, 2
	beq a0, t0, findBestMove_recursive
	lb t0, currentPlayer
	mul a1, a0, t0

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	addi sp, sp, 20
	ret

findBestMove_recursive:
	# s0 = bestMove = -1
	li s0, -1
	# s1 = bestEval = -2
	li s1, -2

	# t0 = i = 0
	li t0, 0
findBestMove_loop:
	# check if reached end
	li t1, 9 
	bge t0, t1, findBestMove_ret

	# t1 = BOARD[i]
	la t1, BOARD 
	add t1, t1, t0 
	lb t1, 0(t1)

	# if BOARD[i] != 0, continue
	bnez t1, findBestMove_loop_continue

	# save local variables
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)

	# make move
	mv a0, t0 
	call makeMove 

	# get current eval
	call findBestMove

	# s2 = move
	mv s2, a0

	# s3 = -eval
	li t0, -1
	mul s3, a1, t0

	# restore move 
	lw a0, 0(sp)
	call undoMove

	# restore variables
	lw t0, 0(sp)
	lw t1, 4(sp)
	addi sp, sp, 8

	# if eval > bestEval then bestMove = move and bestEval = eval, otherwise continue
	ble s3, s1, findBestMove_loop_continue
	mv s1, s3 
	mv s0, t0

	# if eval == 1 return
	li t2, 1
	beq s1, t2, findBestMove_ret

findBestMove_loop_continue:
	addi t0, t0, 1
	j findBestMove_loop

findBestMove_ret:
	# a0 = bestMove
	mv a0, s0
	# a1 = bestEval
	mv a1, s1

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	addi sp, sp, 20
	ret