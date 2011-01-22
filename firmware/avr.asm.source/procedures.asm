;----------------------------------------------
;                   ISR IRQ0
;----------------------------------------------
;           Switch lamp condition
;           and PSF_DC/PSF_LC flags
;----------------------------------------------

ISR_door_switch:
                IN      SREG_backup, SREG
                MOV     R16_backup, R16
                MOV     R17_backup, R17

                ; What condition of the door?
                MOV     temp, PSF
                ANDI    temp, (1 << PSF_DC)
                BRNE    door_was_open

        ;--------------------------------------------------

door_was_close: ; Set flag PSF_DC (door became open)
                ORI     PSF, (1 << PSF_DC)
                ; Switch IRQ0 on rising edge (closing the door)
                SBIO    MCUCR, ISC00

                ; What condition of the lamp?
                MOV     temp, PSF
                ANDI    temp, (1 << PSF_LC)
                BRNE    lamp_was_light

lamp_was_black: ; Turn on LED
                SBIO    LED_PORT, LED_LINE
                ; Set flag PSF_LC (lamp became light)
                ORI     PSF, (1 << PSF_LC)
                ; Turn on lamp...
                CBIO    MOC_PORT, MOC_LINE
                RJMP    ISR_ds_exit

lamp_was_light: ; Turn off LED
                CBIO    LED_PORT, LED_LINE
                ; Clear flag PSF_LC (lamp became black)
                ANDI    PSF, ~(1 << PSF_LC)
                ; Turn off lamp...
                SBIO    MOC_PORT, MOC_LINE
                RJMP    ISR_ds_exit

        ;--------------------------------------------------

door_was_open:  ; Clear flag PSF_DC (door became close)
                ANDI    PSF, ~(1 << PSF_DC)
                ; Switch IRQ0 on failing edge (opening the door)
                CBIO    MCUCR, ISC00

                ; Check working mode
                MOV     temp, PSF
                ANDI    temp, (1 << PSF_TM)
                BREQ    ISR_ds_exit

D_mode:         ; Clear flag PSF_LC (lamp became black)
                ANDI    PSF, ~(1 << PSF_LC)		
                ; Turn off lamp...
                SBIO    MOC_PORT, MOC_LINE

ISR_ds_exit:    MOV     R17, R17_backup
                MOV     R16, R16_backup
                OUT     SREG, SREG_backup
                RETI

;----------------------------------------------


;-----------------------------------------------------
;                   ISR T0 overflow
;-----------------------------------------------------

ISR_mode_switch:		
                IN      SREG_backup, SREG
                DEC     T0_OF_count
                OUT     SREG, SREG_backup
                RETI

;-----------------------------------------------------
