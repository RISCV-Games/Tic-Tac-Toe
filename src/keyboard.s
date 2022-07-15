INPUT:
	li t1,0xFF200000		  # carrega o endere�o de controle do KDMMIO
 	lw t0,0(t1)			      # Le bit de Controle Teclado
  andi t0,t0,0x0001		  # mascara o bit menos significativo
  beq t0,zero, INPUT	  # não tem tecla pressionada ent�o volta ao loop
  lw t2,4(t1)			      # le o valor da tecla
  	
  # Go inside options
  li t0 0x31			#1
	beq t2, t0, OP1  
	li t0 0x32			#2
	beq t2 ,t0, OP2
	li t0, 0x20			#ENTER
	beq t2, t0, ESCOLHE
	j INPUT
