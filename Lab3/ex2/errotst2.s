.include "macros2.s"
.data
.text
jal SetHandlerException

la t1, teste #teste trigger para teste 2
li t2, 0xFFFFFF
sw t2, 0(t1)
teste:

li a7, 10
ecall
.include "SYSTEMv14.s"
