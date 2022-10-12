.global _start
_start:
	
	MOV		r1,#1
	MOV		r2,#10
	
	// Stall
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	// Stall
	
	ADD		r3,r1,r2
	SUB		r4,r2,r1
	AND		r5,r1,r2
	ORR		r6,r1,r2
	
	// Stall
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	// Stall
	
	STR		r3,[r0,#8]
	STR		r4,[r0,#12]
	STR		r5,[r0,#16]
	STR		r6,[r0,#20]
	
	LDR		r7,[r0,#4]
	
	// Stall
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	// Stall
	
	STR		r7,[r0,#4]
	
	cmp r7, #7
	// Stall
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	// Stall
	beq salto
	
	b fin
	
salto:
	
	cmp r1, #10
	// Stall
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	// Stall
	beq fin
	STR		r1,[r0,#20]
	
	add r1, r1, #1
	// Stall
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	MOV     r0,#0
	// Stall
	
	b salto
	

fin:
	
	cmp r1, #10