## Name: Edwin Huang
## Quiz 5 - Question 2 - Interrupted I/O
## Description:
## -----------
## Take the user character and print it in a console until 'q' is typed.
## Make the interrupt handler (Kernel text program)
##

    .data
    .text
    .globl main

main:


    li  $v0, 10
    syscall