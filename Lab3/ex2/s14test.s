.include "macros2.s"
.data

.text

jal SetHandlerException
lw zero, 0 # trigger para teste

.include "SYSTEMv14.s"
