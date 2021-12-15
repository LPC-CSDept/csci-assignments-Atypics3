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
    li  $s0, 113                        # $s0 = 'q' (133 in ASCII)
    mfc0 $a0, $t4                       # read from the status reg.
    ori $a0, 0xff11                     # enable all interrupts
    mtc0 $a0, $t4                       # write back to the status reg.

    lui $t0, 0xFFFF                     # $t0 = 0xFFFF0000
    ori $a0, $zero, 2                   # enable keyboard interrupt
    sw  $a0, 0($t0)                     # write back to 0xFFFF0000, stored in receiver control data reg.


stayHere:
    j   stayHere                        # stay here for continuous input


    # kernel text section
    .ktext  0x80000180                  # kernel code starts here
    sw  $v0, stackPtr1                  # $v0 = stackPtr1
    sw  $a0, stackPtr2                  # $a0 = stackPtr2

continue:
    mfc0    $k0, $t5                    # move from coprocessor 0, gets the cause register
    srl     $a0, $k0, 2                 # shift left $k0 by 2 to get the exception code field and put the result into $a0
    andi    $a0, $a0, 0x1f              # get just the exception code
    bne     $a0, zero, kdone            # exception code 0 = input/output
                                        # if $a0 != 0, go to kdone to process inputs. 
                                        # if $a0 = 0, then keep getting inputs

    lui     $v0, 0xFFFF                 # $v0 = 0xFFFF0000
    lw      $a0, 4($v0)                 # get the input key; loaded in receiver data reg.
    bne     $a0, $s0, printResult       # branch to printResult if not 'q'. 
                                        # if 'q', continue on below.

    li      $v0, 10                     # program ends
    syscall

exit:
    li  $v0, 10
    syscall