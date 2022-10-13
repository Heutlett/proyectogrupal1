	NOP
	MOV		r1,#1
	MOV		r2,#10
salto:
	ADD		r3,r1,r2
	; SUB		r4,r2,r1
	; AND		r5,r1,r2
	; OR		r6,r1,r2	
	STR		r3,[r0,#8]
	STR		r4,[r0,#12]
	LDR		r7,[r0,#4]
	CMP r7, #7
	JEQ salto
	JMP fin
cicle:
	cmp r1, #10
	JMP fin
	add r1, r1, #1
	JMP cicle
fin:
	
	cmp r1, #10
	END