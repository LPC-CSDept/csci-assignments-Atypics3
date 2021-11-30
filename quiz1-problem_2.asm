## problem 2
## calculate ax^2 + bx + c

	.data
promptX: 	.asciiz "Enter x: "
promptA:	.asciiz "Enter a: "
promptB:	.asciiz	"Enter b: "
promptC:	.asciiz "Enter c: "
resultMsg:  .asciiz "The result is: "
blank:  	.asciiz " "
newl:   	.asciiz "\n"

    .text
    .globl main

main:   				                # read input
    la      $a0,promptX          	    # prompt user for x
    li      $v0,4               	    # print string
    syscall

    li      $v0,5               	    # read float
	syscall
	mtc1	$v0, $f0		            # puts int into FP reg
	cvt.s.w	$f0, $f0                    # turns int into float
	nop	

	la      $a0,promptA          	    # prompt user for a
    li      $v0,4               	    # print string
    syscall

	li	$v0, 5	
	syscall	
	mtc1	$v0, $f1		            # $f1 <-- a
	cvt.s.w $f1, $f1
	nop

	la      $a0,promptB          	    # prompt user for b
    li      $v0,4               	    # print string
    syscall

	li	$v0, 5
	syscall
	mtc1	$v0, $f2		            # $f2 <-- b
	cvt.s.w $f2, $f2
	nop

	la      $a0,promptC          	    # prompt user for c
    li      $v0,4               	# print string
	syscall

	li	$v0, 5			                # $f3 <-- c
	syscall
	mtc1	$v0, $f3
	cvt.s.w $f3, $f3
	nop



                                        # evaluate the quadratic
					                    # $f0 = x
					                    # $f1 = a
					                    # $f2 = b^2
					                    # $f3 = c
					                    # $f11 = sum

    mul.s    $f11,$f1,$f0        	    # sum = ax
	nop

    add.s    $f11,$f11, $f2         	# sum = ax + b

    mul.s    $f11,$f11, $f0             # sum = (ax+b)x = ax^2 + bx
	nop

    add.s    $f11,$f11,$f3         	    # sum = ax^2 + bx + c
        
	li      $v0, 4
    la      $a0, resultMsg      		# prints resultMsg
    syscall                     		# same as cout << resultMsg;
	
                                        # print the result
    mov.s    $f12,$f11            	    # $f12 = result
    li       $v0,2               	
    syscall

    la      $a0,newl            	    # new line
    li      $v0,4               	    # print string
    syscall

    li      $v0,10              	    # exits program
    syscall     