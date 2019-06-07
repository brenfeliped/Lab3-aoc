.include "macros2.s"
.data
.text
jal SetHandlerException

sw zero, 200 # trigger para teste 7

.include "SYSTEMv14.s"
