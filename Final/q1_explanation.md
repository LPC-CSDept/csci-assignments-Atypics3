# NAME:

Edwin Huang
<br/><br/>

# PROGRAM NAME:

Final Question 1 - Memory Mapped I/O

<br /> <br />

# DESCRIPTION:

## TABLE OF CONTENTS:

- [Description(here)](#description)
- [Algorithm](#algorithm)
- [Explanation](#explanation)
- [Results](#results)
  <br/><br/>

This is a `.asm` file that will take three digits from the user and output the same three digits back. <br/>
This is done by using memory mapped I/O. <br/>
Specifically, this will use the .data segment and the stack segment in order to achieve the purpose of the problem. <br/>
The registers and settings that are going to be used are as follows:

<br /> <br />

## Temporary Registers (`$t__`):

- `$t0` = digits to be inputted (3 by default since we're inputting only 3 digits).
- `$t1` = counter for counting digits (set to 100 by default due to 3 digits being inputted).
- `$t2` = the upper immediate of 0xFFFF that will be used in the program.
- `$t3` = a temporary register.

## Saved Registers (`$s__`):

- `$s0` = used to hold the data for the receiver register and is also used in the algorithm to move the inputted value into the correct place
- `$s1` = used to add the value in $s0 to get the total.

## Other Registers:

- `$a0` = argument register to be used for syscall and holds the final result.
- `$v0` = expression evaluation register to be used for syscall.
  <br/><br/>

## Settings:

- Bare Machine `OFF`
- Enable Delayed Branches `OFF`
- Enable Mapped IO `ON`
- Accept Pseudo instructions `ON`
- Enable Delayed Loads `OFF`
- Load Exception Handler `OFF`

# ALGORITHM: <br/>[Back to Top](#description)

- Using C++, the algorithm for the program goes like this:

```c++
// loading receiver control/data register(s) are omitted due to it not needed in C++
 int t0 = 3; (digits to be inputted)

int t1 = 100; (counter)

int t2 = 65535; (upper immediate)

string inputMsg = "Enter 3 digits: \n";

cout << inputMsg;

cin >> t0;
int t3 = 1; //0x0001
t3 = t3
do {

}
while (t3 != 0)

then go to next subroutine

int s0 = t2;
s0 = s0 - 48;
t0--;

s0 = s0 \* t1;

int s1 = s1 + s0;

t1 = t1 / 10;

while (t0 != zero)
then go to next subroutine

cout << resultMsg;
cout << s1;

exit(0);
```

<br /> <br />

# EXPLANATION: <br/>[Back to Top](#description)

### header:

```x86asm
    .data
numOfDigits:       .word   3
inputMsg:   	   .asciiz "Enter 3 digits: \n"
resultMsg:  	   .asciiz "The result is: \n"
    .text
    .globl main
```

In the data segment of the header, we see 3 things in it:

- numOfDigits, a integer variable which holds the number of digits
- inputMsg, a string variable which outputs the input message
- resultMsg, a string variable which outputs the result message
  The text segment and `globl main` are set by default.
  <br /> <br />

### main:

```x86asm
main:
    lw      $t0, numOfDigits            # $t0 = (3) digits to be inputted
    ori     $t1, $zero, 100             # $t1 = counter
    lui     $t2, 0xffff                 # $t2 = upper immediate

    la      $a0, inputMsg               # loading in inputMsg
    li      $v0, 4
    syscall                             # displaying inputMsg

```

In the `main` routine of the program, we set some values to some registers:

- $t0 = the digits to be inputted (3, in this case).
- $t1 = the counter, set to 100.
- $t2 = the upper immediate.
  Then, we load in inputMsg and output it into the console.
  <br /> <br />

### gettingInput:

```x86asm
gettingInput:
    lw      $t3, 0($t2)                 # loading receiver control register
    andi    $t3, $t3, 0x0001            # flipping all bits except LSB to see
                                        # if the receiver control register is ready or not.

    beq     $t3, $zero, gettingInput    # if $t3 != 0, go to gettingInput
                                        # if not ready, loop through gettingInput until ready
    nop
    lw      $s0, 4($t2)                 # loading receiver data register; reading in data with it

```

In the `gettingInput` subroutine, we first load in the receiver control register(RCR) in order to receive input from the user. <br/>
Then we flip all the bits in $t3 except the LSB if the RCR is ready or not. <br/>
If it is ready, then go to the `processingInput` subroutine. If not, loop through `gettingInput` until it is.
<br /> <br />

### processingInput

```x86asm
processingInput:
    sub     $s0, $s0, 48                # getting digit in decimal
    sub     $t0, $t0, 1                 # decrementing counter

    mul     $s0, $s0, $t1               # moving value into correct place
    nop
    add     $s1, $s1, $s0               # adding current input into total
    div     $t1, $t1, 10

    # example if user inputs 123:
    # $t0 = 3 --> ($s0 = 0 0 3 * 100) ---> $s0 = _ _ 3, (0 + 0 + 3)
    # $t0 = 2 --> ($s0 = 0 2 0 * 100) ---> $s0 = _ 2 3, (0 + 20 + 3)
    # $t0 = 1 --> ($s0 = 1 0 0 * 100) ---> $s0 = 1 2 3, (100 + 20 + 3)

    nop

    beq     $t0, $zero, printResult     # when $t0 == 0 (if ready), go to printResult
    nop

    b       gettingInput                # if $t1 != 0 (if not ready), go back to gettingInput
```

The `processingInput` subroutine is where all the calculations are: <br/>

- We can see that `$s0` is decreased by 48 in order to get the digit in decimal form.
- `$t0` (the counter) is then decremented by 1.
- `s0` is then multiplied by `$t1` (the amount of digits inputted) to move the digit into its correct place.
- `$s1` is added by `$s0` and itself in order to add the current digit (`$s0`) into the total.
- `$t1` is then divided by 10 to shift its place right by 1 to get the next value place (which in this case, can only be the second or first place value). <br/>
  A visualization of this process is given in the code block above. <br/>
- A loop is then implemented which says that:
  - if `$t0 == 0`, then go to printResult.
  - if `$t0 != 0`, then branch to `gettingInput`. <br/>In other words, keep branching back to `gettingInput` again until there are no more digits to process.

<br /> <br />

### printResult

```x86asm
printResult:
    la      $a0, resultMsg              # loading in resultMsg
    li      $v0, 4                      # displaying resultMsg
    syscall

    li      $v0, 1                      # displaying inputted value
    move    $a0, $s1                    # moving value in $s1 into $a0
    syscall

    li      $v0, 10                     # program ends
    syscall

```

Finally, `printResult` prints out whatever `resultMsg` has and gets the value that we processed in `processingInput`. <br/>
This is done by using `move $a0, $s1`, which moves the value in `$s1` into `$a0`. It is then called using `syscall`. <br/> <br/>
By the end of this, we should always expect to get the value that we inputted earlier, assuming that three digits are inputted. <br/>
After we get the result that we expect, the program is then called to end.
<br /> <br />

# RESULTS: <br/>[Back to Top](#description)

### Test case 1:

![result1](/Final/q1_result1.PNG) <br/> <br/>
In result 1, we inputted `123` and got `123` back. <br/>
This functions as we expected it to.
<br/><br/>

### Test case 2:

![result2](/Final/q1_result2.PNG) <br/> <br/>
In result 1, we inputted `981` and got `981` back. <br/>
This functions as we expected it to.
<br/><br/>

### Test case 3:

![result3](/Final/q1_result3.PNG) <br/> <br/>
In result 1, we inputted `333` and got `333` back. <br/>
This functions as we expected it to.
