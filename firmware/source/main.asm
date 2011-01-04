                ;***********************************************
                ;*                  IQ-Door                    *
                ;*---------------------------------------------*
                ;*      Device:         ATtiny12               *
                ;*      Frequency:      1.2MHz internal RC     *
                ;*      Author:         Ivanov V.U.            *
                ;*---------------------------------------------*
                ;*      Create:         22 August 2010         * 
                ;*      Last edition:   02 September 2010      *
                ;***********************************************

.include "appnotes\tn12def.inc"
.include "macros.inc"

.include "definitions.def"

.include "interrupt_vectors.asm"
.include "initialisation.asm"

;------------------------------------------
;               Main Program
;------------------------------------------

main:           STOP_T0
                ; Switch to T-Mode (PSF_TM = 0)
                ANDI    PSF, ~(1 << PSF_TM)
                ; Idle
                SLEEP

                ; DOOR IS OPEN
                START_T0

wait_loop:      ; Wait closing the door

                ; Is the door open %switch_delay% seconds?
                TST     T0_OF_count
                BRNE    skip_switch_mode

                ; Yes -- switch to D-mode (PSF_TM = 1)
                ORI     PSF, (1 << PSF_TM)
                ; Turn off LED
                CBIO    LED_PORT, LED_LINE
                STOP_T0

skip_switch_mode:	
                ; Check PSF_DC flag (door condition)
                MOV     temp, PSF
                ANDI    temp, (1 << PSF_DC)
                BRNE    wait_loop

                ; DOOR IS CLOSE
                RJMP	main

;----------------------------------

.include "procedures.asm"
