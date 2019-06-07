.include "macros2.s"
.data
.text
jal SetHandlerException

la t0,label #trigger para teste 0
xori t0, t0, 0xff
jalr ra, t0, 0

label: 
    addi a0, a0, 5
    ret

.include "SYSTEMv14.s"
