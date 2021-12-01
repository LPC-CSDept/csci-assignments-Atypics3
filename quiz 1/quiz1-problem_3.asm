## problem 3
## calculate Newton's method
## x' = (x + (n/x)) / 2

	.data
promptN:	.asciiz "Enter n: "
resultMsg: 	.asciiz "The result is: "
	.text
	.globl main

main:
	la	$a0, promptN		            # printing prompt
	li	$v0, 4
	syscall

	li	$v0, 5			                # read int
	syscall
	mtc1	$v0, $f0		            # $f0 = n
	cvt.s.w	$f0, $f0		            # converting n to a float

	li.s	$f1, 1.0		            # constant 1.0
	li.s	$f2, 2.0		            # constant 2.0
	li.s	$f3, 1.0		            # value of x for first approximation
	li.s	$f10, 1.0e-5		        # for accuracy up to 10^5

loop:
    mov.s   $f4,$f0             	    # x' = n
    div.s   $f4,$f4,$f3         	    # x' = n/x
	nop

    add.s   $f4,$f3,$f4         	    # x' = x + n/x
	
    div.s   $f3,$f4,$f2         	    # x    = (1/2)(x + n/x)
	nop

    mul.s   $f8,$f3,$f3         	    # x^2
	nop

    div.s   $f8,$f0,$f8         	    # n/x^2
	nop

    sub.s   $f8,$f8,$f1         	    # n/x^2 - 1.0

    abs.s   $f8,$f8             	    # |n/x^2 - 1.0|
	nop

    c.lt.s  $f8,$f10            	    # is |x^2 - n| less than small?
    nop

    bc1t    done                	    # if so, branch to done
    nop

    j       loop               	        # proceeds to the next approx. if not
    nop

done:
		li      $v0, 4
    	la      $a0, resultMsg      	# prints resultMsg
    	syscall                     	# same as cout << resultMsg;
		
        mov.s   $f12,$f3            	# print the result
        li      $v0,2
        syscall
                
        jr      $ra                 	# return to OS
	    nop
	

	li	$v0, 10			           		# ends program
	syscall