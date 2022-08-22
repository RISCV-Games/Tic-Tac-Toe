.text
#################################################
#	a0 = endereco da imagem			#
#	a1 = x					#
#	a2 = y					#
#################################################
#	t0 = endereco do bitmap display		#
#	t1 = endereco da imagem			#
#	t2 = contador de linha			#
# 	t3 = contador de coluna			#
#	t4 = largura				#
#	t5 = altura				#
#################################################

RENDER:
	li t0, 0xfffffffc
	and a1, a1, t0
	and a2, a2, t0
	mv t0, s1
	add t0,t0,a1			# adiciona x ao t0
	
	li t1,320			# t1 = 320
	mul t1,t1,a2			# t1 = 320 * y
	add t0,t0,t1			# adiciona t1 ao t0
	
	addi t1,a0,8			# t1 = a0 + 8
	
	mv t2,zero			# zera t2
	mv t3,zero			# zera t3
		
	lw t4,0(a0)			# carrega a largura em t4
	lw t5,4(a0)			# carrega a altura em t5
	
P_LINHA:
	lw t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
	sw t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
		
	addi t0,t0,4			# incrementa endereco do bitmap
	addi t1,t1,4			# incrementa endereco da imagem
		
	addi t3,t3,4			# incrementa contador de coluna
	blt t3,t4,P_LINHA		# se contador da coluna < largura, continue imprimindo

	addi t0,t0,320			# t0 += 320
	sub t0,t0,t4			# t0 -= largura da imagem
	# ^ isso serve pra "pular" de linha no bitmap display
		
	mv t3,zero			# zera t3 (contador de coluna)
	addi t2,t2,1			# incrementa contador de linha
	bgt t5,t2,P_LINHA		# se altura > contador de linha, continue imprimindo
		
	ret				# retorna
												
REV_RENDER:
	mv t0, s1
	add t0,t0,a1			# adiciona x ao t0
	
	li t1,320			# t1 = 320
	mul t1,t1,a2			# t1 = 320 * y
	add t0,t0,t1			# adiciona t1 ao t0
	
	addi t1,a0,8			# t1 = a0 + 8
	
	mv t2,zero			# zera t2
	mv t3,zero			# zera t3
		
	lw t4,0(a0)			# carrega a largura em t4
	lw t5,4(a0)			# carrega a altura em t5
	
  addi t6, t4, -1
  add t0, t0, t6

REV_P_LINHA:
	lb t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
	sb t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
		
	addi t0,t0,-1			# incrementa endereco do bitmap
	addi t1,t1,1			# incrementa endereco da imagem
		
	addi t3,t3,1			# incrementa contador de coluna
	blt t3,t4,REV_P_LINHA		# se contador da coluna < largura, continue imprimindo

	addi t0,t0,320			# t0 += 320
	add t0,t0,t4			# t0 -= largura da imagem
	# ^ isso serve pra "pular" de linha no bitmap display
		
	mv t3,zero			# zera t3 (contador de coluna)
	addi t2,t2,1			# incrementa contador de linha
	bgt t5,t2,REV_P_LINHA		# se altura > contador de linha, continue imprimindo
		
	ret				# retorna

# Initializate the video function

INIT_VIDEO:
	# On init, register names correlate to frame numbers,
	# but that won't always be the case.
	li s0,0xFF000000 # Front buffer: for display ONLY
	li s1,0xFF100000 # Back buffer: paint here!
	mv t1,ra
	jal REFRESH_BACK_BUFFER_END # s2 = back buffer end address
	mv ra,t1
	li s3,0xFF200604 # s3 = current frame number (0 or 1)
	
	# Force start on frame 0
	li t0,0
	sw t0,0(s3)
	ret

REFRESH_BACK_BUFFER_END:
	li t0,0x12C00 # Hardcoded number of pixels
	mv s2,s1
	add s2,s2,t0
	ret

# Change frames
SWAP_FRAMES:
	# Swap current frame
	lw t0,(s3)
	xori t0,t0,1
	sw t0,(s3)
	
	mv t1,ra # REFRESH_BACK_BUFFER_END uses t0, so we store our ra in t1
	# Swap back and front buffers
	mv t0,s1
	mv s1,s0
	mv s0,t0
	
	jal REFRESH_BACK_BUFFER_END
	mv ra,t1
	ret
