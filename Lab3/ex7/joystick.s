
.include "macros2.s"

#endereços do adc
.eqv ADC_CH0_ADDRESS 0xFF200200
.eqv ADC_CH1_ADDRESS 0xFF200204
.eqv ADC_CH2_ADDRESS 0xFF200208
.eqv ADC_CH3_ADDRESS 0xFF20020C
.eqv ADC_CH4_ADDRESS 0xFF200210
.eqv ADC_CH5_ADDRESS 0xFF200214
.eqv ADC_CH6_ADDRESS 0xFF200218
.eqv ADC_CH7_ADDRESS 0xFF20021C


.data

.text

PrintTela:
  li a0,0xFF000000  # endereco inicial da Memoria VGA
  li a1,0xFF012C00  # endereco final
  li a2,0xF0F0F0F0  #cor do plano de fundo
PrintTelaLoop:    
  sw a2, 0(a0) #escreve a cor na memoria
  addi a0, a0, 4 #incrementa 4 ao endereco
  bne a0,a1,PrintTelaLoop #Se nao for o ultimo endereco entao continua o loop
  jal NullPointerPrint
    
PrintSquare: #printa um quadrado do eixo analógico
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

ReadAxis: #leitor de eixos
  li a0, ADC_CH0_ADDRESS #faz a leitura do endereço
  lw a1, 0(a0) #grava o valor em a1
  andi a1, a1, 0x0001 #mascara o bit 0
  bne a1, zero, MovePointerUp #verifica se foi movimentado, caso seja, chama a funçao para movimentar o ponteiro na tela
  li a0, ADC_CH1_ADDRESS
  lw a1, 0(a0)
  andi a1, a1, 0x0001
  bne a1, zero, MovePointerDown
  li a0, ADC_CH2_ADDRESS
  lw a1, 0(a0)
  andi a1, a1, 0x0001 
  bne a1, zero, MovePointerLeft
  li a0, ADC_CH3_ADDRESS
  lw a1, 0(a0)
  andi a1, a1, 0x0001 
  bne a1, zero, MovePointerRight
  jal NullPointerPrint
  j ReadAxis
#funcoes de movimento de ponteiro
MovePointerUp:
  addi a3, a3, 20 #soma +20 da posicao y atual do ponteiro
  jal PrintPointer #printa novamente o ponteiro na tela na sua nova posicao
  ret
  
MovePointerDown:
  addi a3, a3, -20 #subtrai -20 da posicao y atual do ponteiro
  jal PrintPointer
  ret
  
MovePointerLeft:
  addi a2,a2,-20 #subtrai -20 da posicao x atual do ponteiro
  jal PrintPointer
  ret
  
MovePointerRight:
  addi a2,a2,20 #soma +20 da posicao x atual do ponteiro
  jal PrintPointer
  ret
  
NullPointerPrint: #printa o ponteiro nulo
  li a2, 160 #x
  li a3, 120 #y
PrintPointer: #print ponteiro
  li a0, 0xFF000000
  li a1, 0xFFFFFFFF
  li a4, 320
  mul a3,a3,a4
  add a3, a2, a3
  add a0, a3, a0
  sw a1, 0(a0)
  ret
  
.include "SYSTEMv13.s"
