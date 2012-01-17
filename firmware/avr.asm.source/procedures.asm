//---------------------------------------------------
//                     ISR IRQ0
//---------------------------------------------------
//             Switch lamp condition
//             and PSF_DC/PSF_LC flags
//---------------------------------------------------

ISR_door_switch:
                IN      temp_reg, SREG
                PUSH    temp_reg

                // What condition of the door?
                MOV     temp_reg, PSF
                ANDI    temp_reg, (1 << PSF_DC)
                BRNE    door_was_open

        //--------------------------------------------------

door_was_close: 
                // Set flag PSF_DC (door became open)
                ORI     PSF, (1 << PSF_DC)
                
                // Set failing edge as condition
                // for INT0 IRQ (i.e. closing the door)
                CBIO    MCUCR, ISC00

                // What condition of the lamp?
                MOV     temp_reg, PSF
                ANDI    temp_reg, (1 << PSF_LC)
                BRNE    lamp_was_light

lamp_was_black: 
                START_T0

                // Turn on LED
                SBIO    LED_PORT, LED_LINE
                // Turn on lamp...
                CBIO    MOC_PORT, MOC_LINE
                // Set flag PSF_LC (lamp became light)
                ORI     PSF, (1 << PSF_LC)
                RJMP    ISR_ds_exit

lamp_was_light: 
                // Turn off LED
                CBIO    LED_PORT, LED_LINE
                // Clear flag PSF_LC (lamp became black)
                ANDI    PSF, ~(1 << PSF_LC)
                // Turn off lamp...
                SBIO    MOC_PORT, MOC_LINE
                RJMP    ISR_ds_exit

        //--------------------------------------------------

door_was_open:  
                STOP_T0

                // Clear flag PSF_DC (door became close)
                ANDI    PSF, ~(1 << PSF_DC)

                // Set rising edge as condition
                // for INT0 IRQ (i.e. opening the door)
                SBIO    MCUCR, ISC00

                // Check working mode
                MOV     temp_reg, PSF
                ANDI    temp_reg, (1 << PSF_TM)
                BREQ    ISR_ds_exit

D_mode:         // Clear flag PSF_LC (lamp became black)
                ANDI    PSF, ~(1 << PSF_LC)		
                // Turn off lamp...
                SBIO    MOC_PORT, MOC_LINE
                // Again switch to T-Mode (PSF_TM = 0)
                ANDI    PSF, ~(1 << PSF_TM)

ISR_ds_exit:    POP     temp_reg
                OUT     SREG, temp_reg
                RETI

//---------------------------------------------------


//-----------------------------------------------------
//                   ISR T0 overflow
//-----------------------------------------------------

ISR_mode_switch:
                IN      temp_reg, SREG		
                PUSH    temp_reg

                DEC     T0_OF_count

                // Is the door open %switch_delay% seconds?
                TST     T0_OF_count
                BRNE    skip_switch_mode

                STOP_T0

                // Yes -- switch to D-mode (PSF_TM = 1)
                ORI     PSF, (1 << PSF_TM)
                // Turn off LED
                CBIO    LED_PORT, LED_LINE
                
skip_switch_mode:
                POP     temp_reg
                OUT     SREG, temp_reg
                RETI

//-----------------------------------------------------
