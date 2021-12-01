 ## Name: Edwin Huang
 ## Problem 3
 ## DESCRIPTION
 ## ------------
 ## This program calculates the approximate value of n when
 ## used as an application of derivatives (in other words, when used in Newton's Method):
 ## x' = (x + (n/x)) / 2

	.data
promptN:	.asciiz "Enter n: "
resultMsg: 	.asciiz "The result is: "

	.text
	.globl main

main:
	la	$a0, promptN		            	# loading promptN into $a0
	li	$v0, 4					# loading code for printing string
	syscall						# printing promptN

	li	$v0, 5			                # loading code for reading in a int
	syscall						# reading in a int (n) into $v0
	mtc1	$v0, $f0		            	# copies the int (n) in $v0 and puts it into $f0
	cvt.s.w	$f0, $f0		            	# converting the int (n) into a float

	li.s	$f1, 1.0		            	# loading in a constant 1.0 into $f1
	li.s	$f2, 2.0		            	# loading in a constant 2.0 into $f2
	li.s	$f3, 1.0		            	# loading a value of x for first approximation into $f3
	li.s	$f10, 1.0e-5		        	# loading a value for accuracy up to 10^5 into $f10

## This loop does the calculations that Newton's method requires,
## namely, division and addition. 
##
loop:
							# values:
							# $f0 = n (the value that is inputted)
							# $f1 = 1.0 (constant)
							# $f2 = 2.0 (constant)
							# $f3 = 1.0 (used for first approx. and later stores approx.)
							# $f4 = x
							# $f8 = x'
							# $f10 = 1.0 x 10^-5 (constant)
							# $f12 = (final) result

    	mov.s   $f4,$f0					# moves $f0 (n) into $f4             	    
							# x' = n
   	div.s   $f4,$f4,$f3         	    		# divides $f4 (n) by $f3(1.0) and puts the result into $f4
							# x' = n/x
	nop

    	add.s   $f4,$f3,$f4      				# adds $f3 (x) into $f4 (n/x) and puts the result into $f4   	    
							# x' = x + n/x
	
   	div.s   $f3,$f4,$f2         	    		# divides $f4 (x + n/x) by $f2 (2.0) and puts the result into $f3
							# x  = (1/2)(x + n/x)
	nop

    	mul.s   $f8,$f3,$f3         	    		# multiplies $f3 and $f3 together and puts result into $f8
							# $f8 = x^2
	nop

   	 div.s   $f8,$f0,$f8         	    		# divides $f0 (n) with $f8 (x^2) and puts the result into $f8
							# n/x^2
   	 nop

    	sub.s   $f8,$f8,$f1         	    		# subtracts $f8 (n/x^2) with $f1 (1.0) and puts result in $f8
							# n/x^2 - 1.0

   	 abs.s   $f8,$f8             	    		# absolute value of $f8 and puts the result in $f8
							# |n/x^2 - 1.0|
    	nop

    	c.lt.s  $f8,$f10            	    		# is $f8 (|x^2 - n|) less than $f10 (1.0 x 10^-5)?
    	nop

    	bc1t    done                	   		 # if so, branch to done
    	nop

    	j       loop               	        	# if $f8 is larger than $f10, 
							# then jump back to the top of loop and do the calculations again
    	nop

done:
	li      $v0, 4					# loading code for printing out string
    	la      $a0, resultMsg      			# loads resultMsg into $a0
    	syscall                     			# prints out resultMsg
		
							# print the result:
        mov.s   $f12,$f3            			# moves $f3 into $f12
        li      $v0,2					# loading code for printing out floats
        syscall						# prints out result
                
        jr      $ra                 			# return to OS
	nop
	

	li	$v0, 10			           	# loading 10 into $v0 (code for exiting program)
	syscall						# ends program
