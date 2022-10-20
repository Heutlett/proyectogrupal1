encrypt:
    mov r6, #0 ;Op selector
    mov r7, #120 ; msg start
    mov r8, #80 ; set espace for public key exp

encrypt_loop:
    nop
    nop
    ldr r3, [r7]
    nop
    nop
    nop
    ldr r4, [r8]
    ldr r5, [r8, #4]
    jmp exp
encrypt_store:
    str r1, [r7]
    cmp r7, #132 ; Limit msg mem space
    nop
    nop
    nop
    jeq finish
    add r7, r7, #4
    jmp encrypt_loop

exp:
    mov r1, #1 ; Op result
    mov r2, #0 ; Iter counter
exp_loop:
    nop
    nop
    nop
    cmp r2, r4
    nop
    nop
    nop
    jeq exp_return
    nop
    nop
    nop
    mul r1, r1, r3
    jmp mod
exp_add:
    add r2, r2, #1
    jmp exp_loop
mod:
    nop
    nop
    nop
    cmp r1, r5
    nop
    nop
    nop
    jlt exp_add
    nop
    nop
    nop
    sub r1, r1, r5
    jmp mod
exp_return:
    cmp r6, #0
    nop
    nop
    nop
    jeq encrypt_store

finish:
    end
