## Name: Edwin Huang
## Quiz 5 - Question 1 - Memory Mapped I/O
## Description:
## -----------
## Take the 3 digits through the MM I/O
## Make the real decimal value for the 3 digit input,
## e.g, if the user types 1,2, and 3, print 123 (decimal) by using the syscall
##

    .data
    .text
    .globl main

main:


    li  $v0, 10
    syscall