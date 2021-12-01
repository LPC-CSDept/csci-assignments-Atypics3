 ## Name: Edwin Huang
 ## Problem 2
 ## DESCRIPTION
 ## ------------
 ## This program takes in 4 inputs (x, a, b, c) and uses them to 
 ## calculate the polynomial equation ax^2 + bx + c.
 ## This is done using floating point values.

	.data
promptX: 	.asciiz "Enter x: "
promptA:	.asciiz "Enter a: "
promptB:	.asciiz	"Enter b: "
promptC:	.asciiz "Enter c: "
resultMsg:  .asciiz "The result is: "

    .text
    .globl main

main:   				    	# reading in input for x:
    	la      $a0,promptX          	    	# loading promptX into $a0
    	li      $v0,4               	    	# loading code for printing out string
   	 syscall				# printing promptX (same as cout << promptX;)

    	li      $v0,5               	   	# loading code for reading integers values
	syscall					# reading in a integer value into $v0
	mtc1	$v0, $f0		        # puts int (in $v0) into Floating Point register ($f0)
	cvt.s.w	$f0, $f0                    	# converts $f0 (a int) into a float of the same value and store into $f0
	nop	

	la      $a0,promptA          	    	# loading promptA into $a0
    	li      $v0,4               	    	# loading code for printing out string
    	syscall					# prints promptA

	li	$v0, 5				# loads code for reading ints into $v0
	syscall					# reads in a int value and puts it into $v0
	mtc1	$v0, $f1		        # copies 32 bits (int) from $v0 into $f1
	cvt.s.w $f1, $f1			# converts $f1 into a float and puts it into $f1
	nop

	la      $a0,promptB          	    	# loads promptB into $a0
    	li      $v0,4               	    	# loading code for printing out string
    	syscall					# prints promptB

	li	$v0, 5				# loads code for reading ints into $v0
	syscall					# reads in a int value and puts it into $v0
	mtc1	$v0, $f2		        # copies 32 bits (int) from $v0 into $f2
	cvt.s.w $f2, $f2			# converts $f2 into a float and puts it into $f2
	nop

	la      $a0,promptC          	    	# loads promptC into $a0
    	li      $v0,4               		# loading code for printing out string
	syscall					# prints promptC

	li	$v0, 5			        # loads code for reading ints into $v0
	syscall					# reads in a int value and puts it into $v0
	mtc1	$v0, $f3			# copies 32 bits (int) from $v0 into $f3
	cvt.s.w $f3, $f3			# converts $f3 into a float and puts it into $f3
	nop



                                        	# evaluate the quadratic
					        # $f0 = x
					        # $f1 = a
					        # $f2 = b^2
					        # $f3 = c
					        # $f11 = sum
						# $f12 = (final) result

    	mul.s    $f11,$f1,$f0        	   	# multiplies x and a and puts it into $f11,
						# sum = (a)(x)
	nop

    	add.s    $f11,$f11, $f2         	# adds the sum (ax) and b^2 together and puts it into $f11
						# sum = ax + b

	mul.s    $f11,$f11, $f0             	# multplies the sum (ax+b) and x together and puts it into $f11
						# sum = (ax+b)x = ax^2 + bx
	nop

    	add.s    $f11,$f11,$f3         	    	# adds the sum (ax^2+bx) and c together and puts it into $f11
						# sum = ax^2 + bx + c
        
	li      $v0, 4				# loading code for printing out string
    	la      $a0, resultMsg      		# loads resultMsg into $a0
    	syscall                     		# prints out resultMsg
	
                                       		# print the result:
    	mov.s    $f12,$f11            	   	# moves the value in $f11 and puts it into $f12
    	li       $v0,2               		# loading code for printing out floats
    	syscall					# prints out result

    	li      $v0,10              	    	# loading 10 into $v0 (code for exiting program)
    	syscall     				# ends program
