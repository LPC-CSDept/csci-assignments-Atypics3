 ## Name: Edwin Huang
 ## Problem 1
 ## DESCRIPTION
 ## ------------
 ## This program takes in a integer input from the user (in fahrenheit)
 ## and converts it into celcius using the formula below:
 ## celcius = (fahrenheit - 32.0) x 5 / 9
 
 
    .data
val1:       .float 32.0
val2:       .float 5.0
val3:       .float 9.0
prompt:     .asciiz "Enter the temperature in Fahrenheit: "
resultMsg:  .asciiz "The result in Celcius is: "

    .text
    .globl main

main:
    la  $a0, prompt             # loading the data in prompt into $a0
    li  $v0, 4                  # loading 4 into $v0 (code for print string)
    syscall                     # printing message (same as cout << prompt;)

    li  $v0, 5                  # loading 5 into $v0 (code for reading integer values)
    syscall                     # reading integer value (same as cin >> promptInput;)

    mtc1    $v0, $f0            # puts int (in $v0) into FP reg ($f0)
    cvt.s.w $f0, $f0            # converts int (in $f0) into a floating point value and puts it in $f0

    l.s     $f1, val1           # loads val1 with the value of 32.0 into $f1
    l.s     $f2, val2           # loads val2 with the value of 5.0 into $f2
    l.s     $f3, val3           # loads val3 with the value of 9.0 into $f3


                                # $f0 = sum
                                # $f1 = val1 (or 32.0)
                                # $f2 = val2 (or 5.0)
                                # $f3 = val3 (or 9.0)
                                # performing operations to turn fahrenheit value into celcius:
    sub.s   $f0, $f0, $f1       # sum = fahrenheit - 32.0;
    mul.s   $f0, $f0, $f2       # sum = fahrenheit * 5
    nop
    div.s   $f0, $f0, $f3       # sum = fahrenheit / 9;
    nop

    li      $v0, 4              # loading 4 into $v0 (code for print string)
    la      $a0, resultMsg      # loading the data in resultMsg into $a0
    syscall                     # printing message (same as cout << resultMsg;)

    li      $v0, 2              # loads 2 into $v0 (code for printing float)
    mov.s   $f12, $f0           # moves floating point value in $f0 into $f12
    syscall                     # prints sum, which is a floating point value

    li      $v0, 10             # loading 10 into $v0 (code for exiting program)
    syscall                     # ends program