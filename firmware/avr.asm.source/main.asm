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
            *         Last edition:   21 January 2012                 *
            **********************************************************/


.LISTMAC

.include "tn13Adef.inc"

.include "definitions.inc"
.include "macros.inc"

.include "interrupt_vectors.asm"
.include "initialisation.asm"

TEST_AVRASM_VERSION


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
