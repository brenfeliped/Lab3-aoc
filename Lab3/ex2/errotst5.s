.include "macros2.s"
.data
.text
jal SetHandlerException

lw zero, 0 # trigger para teste 5

li a7, 10
ecall
.include "SYSTEMv14.s"
