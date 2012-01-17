            /**********************************************************
            *                       AVR-IQ-Door                       *
            *---------------------------------------------------------*
            *         Device:         ATtiny13A                       *
            *         Frequency:      (9.6MHz / CKDIV8) =>            *
            *                         => 1.2 MHz internal RC          *
            *         Assembler:      AVRASM2                         *
            *                                                         *
            *         Author:         Vladimir U. Ivanov              *
            *         E-Mail:         person[at]v-u-ivanov[dot]com    *
            *                                                         *
            *         License:        GNU GPLv3                       *
            *---------------------------------------------------------*
            *         Create:         22 August  2010                 * 
            *         Last edition:   17 January 2012                 *
            **********************************************************/


.include "definitions.def"

.include "tn13Adef.inc"
.include "macros.inc"

.include "interrupt_vectors.asm"
.include "initialisation.asm"


//-------------------------------------------------
//                 Main Program
//-------------------------------------------------

main:           
                // Idle mode
                SLEEP

                // DOOR IS OPEN
wait_loop: 
                // Check PSF_DC flag (door condition)
                MOV     main_reg, PSF
                ANDI    main_reg, (1 << PSF_DC)
                BRNE    wait_loop
                
                // DOOR IS CLOSE

                RJMP	main

//-------------------------------------------------


.include "procedures.asm"
