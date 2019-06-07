.include "macros2.s"
.data
#exarr: .space 300
.text
jal SetHandlerException

#la t1, teste trigger para teste 2
#li t2, 0xFFFFFF
#sw t2, 0(t1)
#teste:

#li a7, 0 trigger para teste 8
#ecall

#li t0, 0x00400000 trigger para teste 1
#addi t0, t0, -8
#jalr ra, t0, 0

#la t0,label trigger para teste 0
#xori t0, t0, 0xff
#jalr ra, t0, 0

#label: 
#    addi a0, a0, 5
#    ret


#li t0, 0xfff
#la t3, exarr
#sw t0, 1(t3) # trigger para teste 6
#lw t0, 1(t3) # trigger para teste 4
#lw zero, 0 # trigger para teste 5
#sw zero, 200 # trigger para teste 7


li a7, 10
ecall
.include "SYSTEMv14.s"
