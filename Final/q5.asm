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
    lw      $t0, numOfDigits            # $t0 = (3) digits to be inputted          
    ori     $t1, $zero, 100             # $t1 = counter
    lui     $t2, 0xffff                 # $t2 = upper immediate

    la      $a0, inputMsg               # loading in inputMsg
    li      $v0, 4                     
    syscall                             # displaying inputMsg


gettingInput:
    lw      $t3, 0($t2)                 # loading receiver control register
    andi    $t3, $t3, 0x0001            # flipping all bits except LSB to see
                                        # if the receiver control register is ready or not.

    beq     $t3, $zero, gettingInput    # if $t3 != 0, go to gettingInput
                                        # if not ready, loop through gettingInput until ready
    nop
    lw      $s0, 4($t2)                 # loading receiver data register; reading in data with it


processingInput:




printResult:
    la  $a0, resultMsg              # loading in resultMsg
    li  $v0, 4                      # displaying resultMsg
    syscall

    li  $v0, 10                     # program ends
    syscall