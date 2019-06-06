.include "macros2.s"
.data
erro0: .string "Error: 0 Instruction address misaligned\nPC:"
erro1: .string "Error: 1 Instruction access fault \nPC:"
erro2: .string "Error: 2 Ilegal Instruction\nPC:"
erro4: .string "Error: 4 Load address misaligned\nPC:"
erro5: .string "Error: 5 Load access fault\nPC:"
erro6: .string "Error: 6 Store address misaligned\nPC:"
erro7: .string "Error: 7 Store access fault\nPC:"
erro8: .string "Error: 8 environment call\nPC:"

.text

M_SetEcall(exceptionHandling)	# Macro de SetEcall - n�o tem ainda na DE1-SoC


jal PLOTFRAME

IdCasos: #identifica os casos possiveis
  csrrw t0, 0, zero # faz a leitura do usecase
  addi t1, zero, 0 #caso 0
  beq t0, t1, CASO0
  
  addi t1, zero, 1 #caso 1
  beq t0, t1, CASO1
  
  addi t1, zero, 2 #caso 2
  beq t0, t1, CASO2
  
  addi t1, zero, 4 #caso 4
  beq t0, t1, CASO4
  
  addi t1, zero, 5 #caso 5
  beq t0, t1, CASO5
  
  addi t1, zero, 6 #caso 6
  beq t0, t1, CASO6
  
  addi t1, zero, 7 #caso 7
  beq t0, t1, CASO7
  
  addi t1, zero, 8 #caso 8
  beq t0, t1, CASO8

CASO0:
  csrrw t1, 65, zero #faz a leitura de uepc em t1
  li a7, 104 #print string
  la a0, erro0
  xor a0, a0, t1 #concatena a string a0 com t1
  li a1, 0
  li a2, 32
  li a3, 0x0038
  li a4, 0
  M_Ecall
  j EXIT #finaliza o programa ao terminar o print
  
CASO1:
CASO2:
CASO4:
CASO5:
CASO6:
CASO7:
CASO8:

PLOTFRAME:
  li t0,0xFF000000  # endereco inicial da Memoria VGA
  li t1,0xFF012C00  # endereco final
  li t2,0xD0D0D0D0  #cor do plano de fundo
PLOT:    
  sw t2, 0(t0) #escreve a cor na memoria
  addi t0, t0, 4 #incrementa 4 ao endereco
  bne t0,t1,PLOT #Se nao for o ultimo endereco entao continua o loop
  ret #caso contrario retorna para o chamador

EXIT:
  li a7, 10
  ecall
    
.include "SYSTEMv13.s"
