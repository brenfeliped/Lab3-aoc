.include "macros2.s"
.data
.text
jal SetHandlerException

li t0, 0x00400000 #trigger para teste 1
addi t0, t0, -8
jalr ra, t0, 0

li a7, 10
ecall
.include "SYSTEMv14.s"