	MOV     r0,#0
	MOV     r1,#2
	MOV     r2,#3
	NOP
	NOP
	NOP
	ADD     r3,r1,r2
	SUB     r4,r2,r1
	AND     r5,r1,r2
	OR      r6,r1,r2
	MOD    	r8,r1,r2
	NOP
	NOP
	NOP
	STR		r3,[r0,#8]
	STR		r4,[r0,#12]
	STR		r5,[r0,#16]
	STR		r6,[r0,#20]
	STR		r8,[r0,#24]
	LDR		r7,[r0,#4]
	NOP
	NOP
	NOP
	STR		r7,[r0,#4]
	cmp		r7, #7
	NOP
	NOP
	NOP
	jeq		salto
	jmp		fin
salto:
	cmp		r1, #10
	NOP
	NOP
	NOP
	jeq		fin
	STR		r1,[r0,#28]
	ADD		r1, r1, #1
	NOP
	NOP
	NOP
	JMP		salto
fin:
	com

	mov r1,#0
	NOP
	NOP
	NOP

loop:

	cmp		r1, #8
	NOP
	NOP
	NOP
	jeq		fin2
	LDR		r2,[r0]
	ADD		r1, r1, #1
	ADD		r0, r0, #4
	NOP
	NOP
	NOP
	JMP		loop

fin2:

	cmp		r1, #8
	NOP
	NOP
	NOP
	END
