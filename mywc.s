//----------------------------------------------
// mywc.s
// Author: Michael Tsai
//----------------------------------------------
.equ FALSE, 0
.equ TRUE, 1
.equ EOF, -1
//----------------------------------------------
    .section .rodata
output:
    .string "%7ld %7ld %7ld\n"
//----------------------------------------------
    .section .data
lLineCount:
    .quad 0
lWordCount:
    .quad 0
lCharCount:
    .quad 0
iInWord:
    .word FALSE
//----------------------------------------------
    .section .bss
iChar:
    .skip 4
//-----------------------------------------------
    .section .text
    .global main

/*--------------------------------------------------------------------*/

/* Write to stdout counts of how many lines, words, and characters
   are in stdin. A word is a sequence of non-whitespace characters.
   Whitespace is defined by the isspace() function. Return 0. */
// int main(void)

// Must be a multiple of 16
        .equ    MAIN_STACK_BYTECOUNT, 16

main:

// Prolog
    sub     sp, sp, MAIN_STACK_BYTECOUNT
    str     x30, [sp]

loop1:
        //if ((iChar = getchar()) == EOF) goto endloop1;
        bl getchar
        adr x1, iChar
        str w0, [x1]
        cmp w0, EOF
        beq endloop1

        //lCharCount++; (increment)
        adr x1, lCharCount
        ldr x2, [x1]
        add x2, x2, 1
        str x2, [x1]

        //if (!isspace(iChar)) goto else1;
        adr x1, iChar
        ldr w0, [x1]
        bl isspace
        cmp w0, FALSE
        beq else1

        //if (!iInWord) goto endif1;
        adr x1, iInWord
        ldr w2, [x1]
        cmp w2, FALSE
        beq endif1

        //lWordCount++;
        adr x1, lWordCount
        ldr x2, [x1]
        add x2, x2, 1
        str x2, [x1]

        //iInWord = FALSE;
        adr x1, iInWord
        mov w2, FALSE
        str w2, [x1]

        //goto endif1;
        b endif1
    else1:
        //if (iInWord) goto endif1;
        adr x1, iInWord
        ldr w2, [x1]
        cmp w2, FALSE
        bne endif1

        //iInWord = TRUE;
        adr x0, iInWord
        mov w1, TRUE
        str w1, [x0]

    endif1:

        //if (iChar != '\n') goto endif2;
        adr x0, iChar
        ldr w0, [x0]
        cmp w0, '\n'
        bne endif2

        //lLineCount++;
        adr x1, lLineCount
        ldr x2, [x1]
        add x2, x2, 1
        str x2, [x1]
    endif2:
        //goto loop1;
        b loop1
   endloop1:

        //if (!iInWord) goto endif3;
        adr x1, iInWord
        ldr w2, [x1]
        cmp w2, FALSE
        beq endif3

        //lWordCount++;
        adr x1, lWordCount
        ldr x2, [x1]
        add x2, x2, 1
        str x2, [x1]
    endif3:

        //printf("%7ld %7ld %7ld\n", lLineCount, lWordCount, lCharCount);
        adr x0, output
        adr x1, lLineCount
        ldr x1, [x1]
        adr x2, lWordCount
        ldr x2, [x2]
        adr x3, lCharCount
        ldr x3, [x3]
        bl printf

        //return 0;
        mov w0, 0
        ldr x30, [sp]
        add sp, sp, MAIN_STACK_BYTECOUNT
        ret 

        .size   main, (. - main)






//if (!iInWord) goto endif1;
        adr x1, iInWord
        ldr w2, [x1]
        cmp w2, FALSE
        beq endif3

adr x0, iChar
ldr w0, [x0]

adr x1, '\n'
ldr w1, [x1]

mov w4, lLineCount++

cmp w0, w1 // comparing iChar and '\n'
bge endif2 // jump if above condition is true
add w4, w4, 1 //increment
b endif2 



