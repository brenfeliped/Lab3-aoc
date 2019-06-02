.data

.text
testcsrrs:
	la t0,handler
 	csrrs zero, 5, t0 # set utvec (5) to the handlers address
	csrrsi zero, 0, 1 # set interrupt enable bit in ustatus (0)
 	lw zero, 0        # trigger trap for Load access fault
 	j testcsrrw

testcsrrw:
 	la t0,handler
 	csrrw zero, 5, t0 # set utvec (5) to the handlers address
 	csrrsi zero, 0, 1 # set interrupt enable bit in ustatus (0)
 	lw zero, 0        # trigger trap for Load access fault
 	j testcsrrc

testcsrrc:
	la t0,handler
 	csrrc zero, 5, t0 # set utvec (5) to the handlers address
 	csrrci zero, 0, 1 # set interrupt enable bit in ustatus (0)
 	j testebreak

testebreak:
	ebreak
	j testecall

testecall:
	li a0,1
	li a7,1
	ecall
	j fim

handler: # Just ignore it by moving epc (65) to the next instruction
	csrrw t0, 65, zero
	addi t0, t0, 4
	csrrw zero, 65, t0
	uret

fim:
    li a7, 10
    ecall