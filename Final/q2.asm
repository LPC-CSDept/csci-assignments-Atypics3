## Name: Edwin Huang
## Quiz 5 - Question 2 - Interrupted I/O
## Description:
## -----------
## Take the user character and print it in a console until 'q' is typed.
## Make the interrupt handler (Kernel text program)
##

    .kdata
stackPtr1:          .word 10            # acts as a stack pointer
stackPtr2:          .word 11            # acts as a stack pointer
    .text
    .globl main

main:
    li  $s0, 113            # $s0 = 'q' (133 in ASCII)
    mfc0 $a0, $t4           # read from the status reg.
    ori $a0, 0xff11         # enable all interrupts
    mtc0 $a0, $t4           # write back to the status reg.

    lui $t0, 0xFFFF         # $t0 = 0xFFFF0000
    ori $a0, $zero, 2       # enable keyboard interrupt
    sw  $a0, 0($t0)         # write back to 0xFFFF0000, receiver control data reg.



exit:
    li  $v0, 10
    syscall