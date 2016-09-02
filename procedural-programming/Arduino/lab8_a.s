
#include <WProgram.h>


/* define all global symbols here */
.global partA
.global milliseconds

.text
.set noreorder


/*********************************************************************
 * Setup MyFunc
 ********************************************************************/
.ent partA
partA:
        LA    $t1, PORTF    /*Loads address of PORTF*/
        LW    $t2, 0($t1)   /*Loads the word of PORTF*/
        LA    $t3, PORTD    /*Loads the address of PORTD*/
        LW    $t4, 0($t3)   /*Loads the word of PORTD*/

/*PORTD 1 shift*/
        LI    $t7, 0x0F00   /*Loads 0b0000111100000000;*/
        AND   $s1,$t7,$t4   /*Masks PORTD with Register 7*/
        SRL   $s2,$s1, 8    /*Shifts bits 8-11 of PORTD 8 places to the right*/

/*PORTD 2 shift*/
        LI    $t7, 0x00E0   /*Loads 0b0000000011100000*/
        AND   $s3,$t7,$t4   /*Masks PORTD with register 7*/
        SLL   $s4,$s3, 0    /*Shifts bits 5-7 of PORTD 0 places*/

/*PORTD 3*/
        ADD   $s5, $s2, $s4 /*ADDs PORTD 1 with PORTD 2, BUTTONS 2-4 AND SWITCHES 2-4*/

/*PORTF*/
        LI    $t7, 0x0002   /*Loads 0b0000000000000010*/
        AND   $s3,$t7,$t2   /*Masks PORTD with register 7*/
        SLL   $s6,$s3, 3    /*Shifts bit 1 of PORTF 2 places to the left*/

        OR    $t6,$s6,$s5   /*OR PORTD 3 with PORTF*/
        SW    $t6,PORTE     /*Save the new bits in $t6 into PORTE (LEDS)*/

        JR    $ra           /*Return*/
        NOP


END:     .end partA

.data


/*********************************************************************
 * This is your ISR implementation. It is called from the vector table jump.
 ********************************************************************/
Lab5_ISR:



/*********************************************************************
 * This is the actual interrupt handler that gets installed
 * in the interrupt vector table. It jumps to the Lab5
 * interrupt handler function.
 ********************************************************************/
.section .vector_4, code
	j Lab5_ISR
	nop


.data


milliseconds: .word 0
