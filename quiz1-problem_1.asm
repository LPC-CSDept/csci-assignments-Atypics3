 ## problem 1
 ## Make an assembly program for converting single-precision
 ## temperatures from fahrenheit to celcius
 ## celcius = (Fahrenheit - 32.0) x 5.0 / 9.0
 
 
    .data
val1:       .float 32.0
val2:       .float 5.0
val3:       .float 9.0
prompt:     .asciiz "Enter the temperature in Fahrenheit: "
resultMsg:  .asciiz "The result in Celcius is: "
    .text
    .globl main

main:
    la  $a0, prompt             # printing prompt
    li  $v0, 4                  # same as cout << prompt;
    syscall

    li  $v0, 5                  # reading input
    syscall                     # same as cin >> promptInput;

    mtc1    $v0, $f0            # puts int (in $v0) into FP reg ($f0)
    cvt.s.w $f0, $f0            # converts int (in $f0) into a float value

    l.s     $f1, val1           # loads val1 into $f1
    l.s     $f2, val2           # loads val2 into $f2
    l.s     $f3, val3           # loads val3 into $f3

                                # performing operations to turn 
                                # fahrenheit value into celcius
    sub.s   $f0, $f0, $f1       # result = result - val1;
    mul.s   $f0, $f0, $f2       # result = result * val2;
    nop
    div.s   $f0, $f0, $f3       # result = result / val3;
    nop

    li      $v0, 4
    la      $a0, resultMsg      # prints resultMsg
    syscall                     # same as cout << resultMsg;

    li      $v0, 2              # prints result (which is a float)
    mov.s   $f12, $f0           # moves value in $f0 into $f12
    syscall

    li      $v0, 10             # program ends
    syscall