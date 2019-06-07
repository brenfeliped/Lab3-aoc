.include "macros2.s"
.data
exarr: .space 300
.text
jal SetHandlerException

li t0, 0xfff
la t3, exarr
lw t0, 1(t3) # trigger para teste 4

li a7, 10
ecall
.include "SYSTEMv14.s"
