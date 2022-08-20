.eqv game_ongoing 2
.eqv player_win 1
.eqv player_loose -1
.eqv player_draw 0

.data 
# SCORE + 0 = &WINS
# SCORE + 1 = &LOSSES
# SCORE + 2 = &TOTAL
.align 1
SCORE: .byte 0 0 0
.align 2
LINE_AMT: .float 1.0e-2
.align 2
STRING_TEST: .string "------\n"

.text

# ---------------------------------------------------
# Helper function for determining if the game is over.
# Returns 1 if O wins, -1 if X wins, 0 otherwise.
# Return start square at a1 and end square at a2.
# a0 = start
# a1 = inc
checkEndHelper:
	# t0 = &BOARD[start]
	la t0, BOARD 
	add t0, t0, a0
	
	# t1 = &BOARD[start+inc], t2 = &BOARD[start+2*inc]
	add t1, t0, a1 
	add t2, t1, a1
  # a2 = start + 2 *inc = end square
  la t6, BOARD
  sub a2, t2, t6
	
	# t0 = *t0
	lb t0, 0(t0)
	
	# t1 = *t1
	lb t1, 0(t1)
	bne t0, t1, checkEndHelper_false
	
	# t2 = *t2
	lb t2, 0(t2)
	bne t1, t2, checkEndHelper_false
	
	# Return winning player and squares
  mv a1, a0
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

  addi sp, sp, -4
  sw a0, 0(sp)

  # If the game is drawn don't draw a line, draw an old lady instead
  li t0, player_draw
  bne a0, t0, CHECK_VICTORY_CONDITION_ANIMATE_LINE
  
  # give the player some time to realize it why the game is drawn
  li a7, 32
  li a0, 500
  ecall

  la a0, telaVelha
  jal RENDER
  jal SWAP_FRAMES
  li a7, 32
  li a0, 1000
  ecall
  j CHECK_VICTORY_CONDITION_UPDATE_SCORE


CHECK_VICTORY_CONDITION_ANIMATE_LINE:
  # If someone won the game animate the winning line

  mv a0, a1
  mv a1, a2
  jal ANIMATE_LINE

CHECK_VICTORY_CONDITION_UPDATE_SCORE:
  lw a0, 0(sp)
  addi sp, sp, 4

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

# Animate a line from square a0 to a1.
ANIMATE_LINE:
  addi sp, sp, -8
  sw ra, 0(sp)
  fsw fs0, 4(sp)

  # (t0, t1) = (x0, y0)
  # (t2, t3) = (x1, y1)
  li t3, 3
  rem t0, a0, t3
  div t1, a0, t3

  rem t2, a1, t3 
  div t3, a1, t3

  li t4, x_tile_offset
  mul t0, t0, t4 
  mul t2, t2, t4 
  addi t0, t0, x_board_offset
  addi t2, t2, x_board_offset

  li t4, y_tile_offset 
  mul t1, t1, t4 
  mul t3, t3, t4
  addi t1, t1, y_board_offset
  addi t3, t3, y_board_offset
  li t6, 14
  add t0, t0, t6
  add t1, t1, t6
  add t2, t2, t6
  add t3, t3, t6

  li a5, 0
  # fs0 = lerp amt
  la t6, LINE_AMT 
  flw fs0, 0(t6)
ANIMATE_LINE_LOOP:
  addi sp, sp, -16
  sw t0, 0(sp)
  sw t1, 4(sp)
  sw t2, 8(sp)
  sw t3, 12(sp)

  fcvt.s.w ft0, t0
  fcvt.s.w ft1, t1
  fcvt.s.w ft2, t2
  fcvt.s.w ft3, t3

  fsub.s ft4, ft2, ft0 
  fmul.s ft4, ft4, fs0 
  fadd.s ft4, ft4, ft0 
  fcvt.w.s a2, ft4

  fsub.s ft4, ft3, ft1 
  fmul.s ft4, ft4, fs0 
  fadd.s ft4, ft4, ft1
  fcvt.w.s a3, ft4

  # draw line
  mv a0, t0 
  mv a1, t1
  li a4, 0
  li a7, 47 
  ecall 

  la t0, LINE_AMT
  flw ft0, 0(t0)
  fadd.s fs0, fs0, ft0

  li t0, 1
  fcvt.s.w ft0, t0 
  flt.s t0, fs0, ft0 
  beqz t0, ANIMATE_LINE_END

  li a7, 32
  li a0, 10
  ecall

  xori a5, a5, 1

  lw t0, 0(sp)
  lw t1, 4(sp)
  lw t2, 8(sp)
  lw t3, 12(sp)
  addi sp, sp, 16
  j ANIMATE_LINE_LOOP

ANIMATE_LINE_END:
  li a7, 32 
  li a0, 1000
  ecall

  addi sp, sp, 16
  lw ra, 0(sp)
  flw fs0, 4(sp)
  addi sp, sp, 8
  ret
