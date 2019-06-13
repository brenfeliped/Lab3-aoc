
.include "macros2.s"

#endereços do adc
.eqv ADC_CH0_ADDRESS 0xFF200200
.eqv ADC_CH1_ADDRESS 0xFF200204

.text

PrintTela:
  li a0,0xFF000000  # endereco inicial da Memoria VGA
  li a1,0xFF012C00  # endereco final
  li a2,0xF0F0F0F0  #cor do plano de fundo
PrintTelaLoop:    
  sw a2, 0(a0) #escreve a cor na memoria
  addi a0, a0, 4 #incrementa 4 ao endereco
  bne a0,a1,PrintTelaLoop #Se nao for o ultimo endereco entao continua o loop
    
PrintSquare: #printa um quadrado do eixo analógico
  M_SetEcall(exceptionHandling)	# Macro de SetEcall - não tem ainda na DE1-SoC
  li a0, 120
  li a1, 80
  li a2, 200
  li a3, 80
  li a4, 0xFFFF
  li a5, 0
  jal BRESENHAM
  li a0, 120
  li a1, 80
  li a2, 120
  li a3, 160
  li a4, 0xFFFF
  li a5, 0
  jal BRESENHAM
  li a0, 120
  li a1, 160
  li a2, 200
  li a3, 160
  li a4, 0xFFFF
  li a5, 0
  jal BRESENHAM
  li a0, 200
  li a1, 160
  li a2, 200
  li a3, 80
  li a4, 0xFFFF
  li a5, 0
  jal BRESENHAM
  jal NullPointerPrint
  
#ReadAxis_Test: #teste teclado
  #li a7,12
  #ecall
  #li a1, 87 #w
  #beq a1, a0, MovePointerUp
  #li a1, 65 #a
  #beq a1, a0, MovePointerLeft
  #li a1,83 #s
  #beq a1, a0, MovePointerDown
  #li a1,68 #d
  #beq a1, a0, MovePointerRight
  #jal NullPointerPrint
  #j ReadAxis_Test
ReadAxis: #leitor de eixos
  li a0, ADC_CH0_ADDRESS #faz a leitura do endereço para o eixo x
  lw a1, 0(a0) #grava o valor em a1
  andi a1, a1, 0x000 #verifica se o analógico foi movido para esquerda
  bne a1, zero, MovePointerLeft #caso seja move o ponteiro para a esquerda
  andi a1, a1, 0xFFF #verifica se o analógico foi movido para direita 
  bne a1, zero, MovePointerRight #caso seja move o ponteiro para a direita
  
  li a0, ADC_CH1_ADDRESS #faz a leitura do endereço para o eixo y
  lw a1, 0(a0) #grava em a1
  andi a1, a1, 0x000 #verifica se o analógico foi movido para cima
  bne a1, zero, MovePointerUp #caso seja move o ponteiro para cima
  andi a1, a1, 0xFFF #verifica se o analógico foi movido para baixo
  bne a1, zero, MovePointerDown #caso seja move o ponteiro para baixo
  j ReadAxis #fica em um loop infinito para verificar se o analógico ainda está sendo mexido
  
#funcoes de movimento de ponteiro
MovePointerUp: #move o ponteiro para cima
  addi sp, sp, -4 #grava o endereço de retorno na pilha
  sw ra, 8(sp)
  jal ErasePointer #apaga o último ponteiro escrito na VGA
  li a2, 160 #cordenada central
  li a3, 120
  jal EraseCord #apaga o ponteiro central
  addi a3, a3, -20 #subtrai -20 da posicao y base do ponteiro
  jal PrintPointer #printa novamente o ponteiro na tela na sua nova posicao
  lw ra, 8(sp) #carrega ra gravado na pilha
  addi sp, sp, 4 #adiciona +4 ao espaco desalocado
  ret
  
MovePointerDown: #move o ponteiro para baixo
  addi sp, sp, -4
  sw ra, 8(sp)
  jal ErasePointer
  li a2, 160 #cordenada central
  li a3, 120
  jal EraseCord
  addi a3, a3, 20 #soma +20 da posicao y base do ponteiro
  jal PrintPointer
  lw ra, 8(sp)
  addi sp, sp, 4
  ret
  
MovePointerLeft: #move o ponteiro para a esquerda
  addi sp, sp, -4
  sw ra, 8(sp)
  jal ErasePointer
  li a2, 160 #cordenada central
  li a3, 120
  jal EraseCord
  addi a2, a2, -20 #subtrai -20 da posicao x base do ponteiro
  jal PrintPointer
  lw ra, 8(sp)
  addi sp, sp, 4
  ret
  
MovePointerRight: #move o ponteiro para a direita
  addi sp, sp, -4
  sw ra, 8(sp)
  jal ErasePointer
  li a2, 160 #cordenada central
  li a3, 120
  jal EraseCord
  addi a2, a2, 20 #soma +20 da posicao x base do ponteiro
  jal PrintPointer
  lw ra, 8(sp)
  addi sp, sp, 4
  ret
  
NullPointerPrint: #printa o ponteiro central
  li a2, 160 #coordenada central
  li a3, 120
PrintPointer: #print ponteiro
  addi sp, sp, -8 #aloca um espaço na pilha
  sw a2, 0(sp) #grava as coordenadas do ponteiro a ser printado na pilha
  sw a3, 4(sp)
  li a0, 0xFF000000 #endereços de memória da VGA
  li a1, 0xFFFFFFFF
  li a4, 320 # 320
  mul a4,a3,a4 # y*320
  add a4, a2, a4 # y*320+x
  add a0, a4, a0 # y*320+x+endereço inicial da vga = posicao(x,y)
  sw a1, 0(a0) # printa um ponto branco na posicao x,y
  ret #retorna pro chamador
  
ErasePointer: # apaga o último ponteiro printado
  lw a2, 0(sp) #carrega o último ponteiro escrito na VGA
  lw a3, 4(sp)
  addi sp, sp, 8 #desaloca o espaço da pilha
EraseCord: #apaga o ponto de uma cordenada x,y = a2,a3
  li a0, 0xFF000000 #enderço da memória da VGA
  li a1, 0xF0F0F0F0 #cor do ponto
  li a4, 320 # 320
  mul a4,a3,a4 # y*320
  add a4, a2, a4 # y*320+x
  add a0, a4, a0 # y*320+x+endereço inicial da vga = posicao(x,y)
  sw a1, 0(a0) # sobrescreve o ponto branco na posicao x,y com a cor do fundo
  ret #retorna pro chamador
  
.include "SYSTEMv13.s"
