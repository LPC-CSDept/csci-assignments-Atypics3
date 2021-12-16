# NAME:

Edwin Huang
<br/><br/>

# PROGRAM NAME:

Final Question 2 - Interrupted I/O

<br /> <br />

# DESCRIPTION:

## TABLE OF CONTENTS:

- [Description(here)](#description)
- [Algorithm](#algorithm)
- [Explanation](#explanation)
- [Results](#results)
  <br/><br/>

This is a `.asm` file that will take the user inputted character and continously print it onto the console screen until 'q' is typed and entered <br/>
This is done by using Memory-Mapped I/O & Interrupted I/O. <br/>
Specifically, this will use the stack segment and the kernel text segment in order to achieve the purpose of the problem. <br/>
The registers and settings that are going to be used are as follows:

<br /> <br />

## Temporary Registers (`$t__`):

- `$t0` = the upper immediate.
- `$t4` = holds the value that is read from the status register.
- `$t5` = holds the value that is read from the cause register.

## Saved Registers (`$s__`):

- `$s0` = holds `q` (or 133 in ASCII). This is used to stop the program when the user types in 'q' in the console.

## Other Registers:

- `$a0` = argument register to be used for reading/writing from the cause and status registers. It is also used to get the appropriate code for syscalls.
- `$v0` = holds the value of `stackPtr1` and other variables (such as the upper immediate or to assist in syscalls) in the program.
  <br/><br/>

## Settings:

- Bare Machine `OFF`
- Enable Delayed Branches `OFF`
- Enable Mapped IO `ON`
- Accept Pseudo instructions `ON`
- Enable Delayed Loads `OFF`
- Load Exception Handler `ON`

# ALGORITHM:

<br/>[Back to Top](#description)

- Using C++ and pseudocode, the algorithm for the program goes like this:

```c++
// loading receiver control/data register(s) and other instructions are omitted due to it not needed in C++
main:
int q = 113; // value of 'q' in ASCII
int upperImmed = 65535;     // 0xFFFF in decimal
int value = 0;

do {
    cin >> value;
}
while (value != q)

contInput:
    stays here for cont. input until 'q' is pressed

/** KERNEL TEXT SECTION **/
    int stackPtr1 = 0, stackPtr2 = 0;
continue:
    moves from coprocessor 0
    get exception code field
    get exception code from field
    if (a0 != 0)
        goto kdone
    else
        continue

    stackPtr = upperImmed;
    cin >> value;               // get input key and loaded in receiver data reg.
    if (a0 != s0)
        goto printChars;
    else
        continue;

    exit(0);

printChars:
    print out value

kdone:
    restore stackPtr1 and stackPtr2
    clear cause reg.
    clear status reg.
    enable interrupts in kernel reg.
    write back to status reg.
    return back to EPC
```

<br /> <br />

# EXPLANATION:

<br/>[Back to Top](#description)

### header:

```x86asm
    .kdata
stackPtr1:          .word 10            # acts as a stack pointer
stackPtr2:          .word 11            # acts as a stack pointer
    .data
    .text
    .globl main
```

In the kernel data segment of the header, we see 2 things in it:

- `stackPtr1`, a integer variable that acts as a pointer without needing to be in the stack segment
- `stackPtr2`, a integer variable that acts as a pointer without needing to be in the stack segment
  <br/>
  This is done just in case the interrupt handler mistakenly is triggered because of a bad value of the stack pointer (from the actual stack data segment), if we were to use it.
  <br/>
  The text segment and `globl main` are set by default.
  <br /> <br />

### main:

```x86asm
main:
    li      $s0, 113                        # $s0 = 'q' (133 in ASCII)
    mfc0    $a0, $t4                        # read from the status reg.
    ori     $a0, 0xff11                     # enable all interrupts
    mtc0    $a0, $t4                        # write back to the status reg.

    lui     $t0, 0xFFFF                     # $t0 = 0xFFFF0000
    ori     $a0, $zero, 2                   # enable keyboard interrupt
    sw      $a0, 0($t0)                     # write back to 0xFFFF0000, stored in receiver control data reg.

```

In the `main` routine of the program, we do some things:

- `$s0` = the ASCII value of 'q'.
- `$t0` = the upper immediate
  After the first two instructions, we use `ori $a0, 0xff11` to enable all interrupts. This makes it so that the program can become interrupted due to some error, in which case QTSpim would point it out. <br/>
  For this program, we will be using it to stop continous input. <br/>
  We write back to the status register (`$t4`) and make `$t0` have the value of the upper immediate.
  Then, we enable keyboard interrupt and make the program write back to `0xFFFF0000`, which the inputted value is stored in the receiver control register. <br/>
  <br /> <br />

### gettingInput:

```x86asm
contInput:
    j   contInput                           # stays here for continuous input

```

In the `contInput` subroutine, the program will use this to continuously read in inputs until 'q' is pressed. In which case, the program breaks out of the infinite loop.
<br /> <br />

### Kernel Text Section & continue:

```x86asm
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
                                            # if $a0 (stackPtr2) != 0, go to kdone to finish up.
                                            # if $a0 (stackPtr2) = 0, then keep getting inputs

    lui     $v0, 0xFFFF                     # $v0 (stackPtr1) = 0xFFFF0000
    lw      $a0, 4($v0)                     # get the input key; loaded in receiver data reg.
    bne     $a0, $s0, printChars            # branch to printChars if not 'q'.
                                            # if 'q', continue on below.

    li      $v0, 10                         # program ends
    syscall
```

In this section of the program, we declare the kernel text section and the `continue` subroutine.

- `kernel text section`:

  - We take `stackPtr1` and `stackPtr2` and assign their values to `$v0` and `$a0` respectively.
    <br/>

- `continue:` <br/>
  - We first get the cause register from `$t5` and put it in `$k0`. <br/>
    Then we shift `$k0` left by 2 to get the exception code field and put the result into `$a0`. <br/>
    The exception code is obtained and its value is put into `$a0`. <br/>
    We then branch to `kdone` if $a0 (or stackPtr2) != 0 to process inputs. If `$a0`= 0, then we will keep getting said inputs. <br/> <br/> We set `$v0`(or stackPtr1) to 0xFFFF and get the input key by loading stackPtr1's address into stackPtr2. <br/>
  - We make another branch to `printChars` if $a0 != $s0 (in other words, if stackPtr1 isn't the same as stackPtr2). <br/>
    If not, then continue to the next line. <br/>
    The program ends after since there are no more inputs to be read and all of them are processed already.

<br /> <br />

### printChars:

```x86asm
printChars:
    li      $v0, 11                         # prints the ASCII char.
    syscall                                 # corresponding to contents of low-order bytes

```

In `printChars`, All characters with the exception of `q` will be outputted on the console and will keep on doing so until `q` is inputted.
<br /> <br />

### kdone:

```x86asm
kdone:
    lw      $v0, stackPtr1                  # restoring stackPtr1 ($v0)
    lw      $a0, stackPtr2                  # restoring stackPtr2 ($a0)

    mtc0    $zero, $t5                      # clearing cause reg. ($t5)
    mfc0    $k0, $t4                        # setting status reg. ($t4)

    ori     $k0, 0x11                       # enabling interrupts in kernel reg.
    mtc0    $k0, $t4                       # writing back to status reg.

    eret                                    # return back to EPC (Exception Program Counter)
```

After all reading and processing have been finished, we have to restore stackPtr1 (`$v0`) and stackPtr2 (`a0`). <br/>
We also need to clear the cause register (`$t5`), set the status register (`$t4`), enable all interrupts in the kernel register (`$k0`), and write back to the status register (`k0`). <br/>
Finally, we return back to the Exception Program Counter after the instructions above have been executed.

<br/> <br/>

# RESULTS:

<br/>[Back to Top](#description)

### Test case 1:

![result1](/Final/q2_result1.PNG) <br/> <br/>
In result 1, we inputted `123` and `abc` and got `123` and `abc` back. <br/>
This program functions as we expected it to since the program took in all the inputs that we gave it and it ended after we pressed `q`.
<br/><br/>

### Test case 2:

![result2](/Final/q2_result2.PNG) <br/> <br/>
In result 2, we inputted `hello` and `world` and got `hello` and `world` back. <br/>
This program functions as we expected it to since the program took in all the inputs that we gave it and it ended after we pressed `q`.
<br/><br/>

### Test case 3:

![result3](/Final/q2_result3.PNG) <br/> <br/>
In result 3, we inputted a short message and got the same message back as the output. <br/>
This program functions as we expected it to since the program took in all the inputs that we gave it and it ended after we pressed `q`.
