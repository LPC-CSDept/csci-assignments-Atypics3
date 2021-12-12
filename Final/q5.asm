## Name: Edwin Huang
## Quiz 5 - Question 1 - Memory Mapped I/O
## Description:
## -----------
## Take the 3 digits through the MM I/O
## Make the real decimal value for the 3 digit input,
## e.g, if the user types 1,2, and 3, print 123 (decimal) by using the syscall
##

    .data
nums:       .word   3
inputMsg:   .asciiz "Enter 3 digits: \n"
resultMsg:  .asciiz "The result is: \n"
    .text
    .globl main

main:                    
    ori $t1, $zero, 100             # $t1 = counter
    lw  $t0, numOfDigits            # $t0 = (3) digits to be inputted 
    lui $t2, 0xffff                 

    la  $a0, inputMsg               # loading in inputMsg
    li  $v0, 4                     
    syscall                         # displaying inputMsg

gettingInput:



processingInput:




printResult:
    la  $a0, resultMsg              # loading in resultMsg
    li  $v0, 4                      # displaying resultMsg
    syscall

    li  $v0, 10                     # program ends
    syscall