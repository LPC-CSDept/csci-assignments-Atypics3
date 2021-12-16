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
    .data
    .text
    .globl main

main:
    li      $s0, 113                        # $s0 = 'q' (133 in ASCII)
    mfc0    $a0, $t4                        # read from the status reg.
    ori     $a0, 0xff11                     # enable all interrupts
    mtc0    $a0, $t4                        # write back to the status reg.

    lui     $t0, 0xFFFF                     # $t0 = 0xFFFF0000
    ori     $a0, $zero, 2                   # enable keyboard interrupt
    sw      $a0, 0($t0)                     # write back to 0xFFFF0000, stored in receiver control data reg.


contInput:
    j   contInput                           # stays here for continuous input


    # KERNEL TEXT SECTION   
    # -------------------
	.ktext  0x80000180     		            # kernel code starts here  
    sw      $v0, stackPtr1                  # $v0 = stackPtr1
    sw      $a0, stackPtr2                  # $a0 = stackPtr2

continue:
    mfc0    $k0, $t5                        # move from coprocessor 0, gets the cause register
    srl     $a0, $k0, 2                     # shift left $k0 by 2 to get the exception code field and put the result into $a0
    andi    $a0, $a0, 0x1f                  # get the exception code, $a0 = exception code only
    bne     $a0, $zero, kdone               # exception code 0 = input/output;
                                            # if $a0 (stackPtr2) != 0, go to kdone to process inputs. 
                                            # if $a0 (stackPtr2) = 0, then keep getting inputs

    lui     $v0, 0xFFFF                     # $v0 (stackPtr1) = 0xFFFF0000
    lw      $a0, 4($v0)                     # get the input key; loaded in receiver data reg.
    bne     $a0, $s0, printChars            # branch to printChars if not 'q'. 
                                            # if 'q', continue on below.

    li      $v0, 10                         # program ends
    syscall

printChars:
    li      $v0, 11                         # prints the ASCII char. 
    syscall                                 # corresponding to contents of low-order bytes

kdone:
    lw      $v0, stackPtr1                  # restoring stackPtr1 ($v0)
    lw      $a0, stackPtr2                  # restoring stackPtr2 ($a0)

    mtc0    $zero, $t5                      # clearing cause reg. ($t5)
    mfc0    $k0, $t4                        # setting status reg. ($t4)

    ori     $k0, 0x11                       # enabling interrupts in kernel reg.
    mtc0    $k0, $t4                        # writing back to status reg.

    eret                                    # return back to EPC (Exception Program Counter)
