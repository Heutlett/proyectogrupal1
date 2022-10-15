.global _start
_start:
    b decrypt

encrypt:
    mov r7, #50
    mov r8, #0
encrypt_loop:
    cmp r7, #100
    beq end
    ldr r3, [r7]
    mov r7, #40
    ldr r4, [r7]
    ldr r5, [r7, #1]
    b eexp
encrypt_store:
    mov r7, #50
    add r7, r7, r8
    str r1, [r7]
    add r8, r8, #1
    b encrypt_loop

decrypt:
    mov r7, #150
    mov r8, #0
decrypt_loop:
    cmp r7, #150
    beq end
    ldr r3, [r7]
    mov r7, #42
    ldr r4, [r7]
    ldr r5, [r7, #1]
    b dexp
decrypt_store:
    mov r7, #150
    add r7, r7, r8
    str r1, [r7]
    add r8, r8, #1
    b decrypt_loop

eexp:
    mov r1, #1
    mov r2, #0
eexp_loop:
    cmp r2, r4
    beq encrypt_store
    mul r6, r1, r3
    mov r1, r6
    b emod
eexp_add:
    add r2, #1
    b eexp_loop
emod:
    cmp r1, r5
    blt eexp_add
    sub r1, r1, r5
    b emod

dexp:
    mov r1, #1
    mov r2, #0
dexp_loop:
    cmp r2, r4
    beq decrypt_store
    mul r6, r1, r3
    mov r1, r6
    b dmod
dexp_add:
    add r2, #1
    b dexp_loop
dmod:
    cmp r1, r5
    blt dexp_add
    sub r1, r1, r5
    b dmod

end:
    b end
