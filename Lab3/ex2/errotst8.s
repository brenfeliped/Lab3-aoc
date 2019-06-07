.include "macros2.s"
.data
.text
jal SetHandlerException

li a7, 0 #trigger para teste 8
ecall

.include "SYSTEMv14.s"
