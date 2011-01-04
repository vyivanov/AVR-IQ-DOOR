;--------------------------------------------
;               Initialisation
;--------------------------------------------

init:           CLEAR_SRAM

                ; Turn off analog comparator
                SBIO    ACSR, ACD

                ; Pin to LED -- output
                SBIO    LED_DDR,  LED_LINE
                CBIO    LED_PORT, LED_LINE

                ; Pin to MOC3041 -- output
                SBIO    MOC_DDR,  MOC_LINE
                SBIO    MOC_PORT, MOC_LINE

                ; Pin to sensor -- input without pull-up
                CBIO    sensor_DDR,  sensor_LINE
                CBIO    sensor_PORT, sensor_LINE
                
                ; Not Connnected pins -- input with pull-up
                CBIO    NC1_DDR,  NC1_LINE
                SBIO    NC1_PORT, NC1_LINE
                CBIO    NC2_DDR,  NC2_LINE
                SBIO    NC2_PORT, NC2_LINE

                ; Enable interrupt on failing edge at 
                ; INT0 line (opening the door) and on T0 overflow
                SBIO    GIMSK, INT0
                SBIO    TIMSK, TOIE0

                CBIO    MCUCR, ISC00
                SBIO    MCUCR, ISC01

                ; Enable Idle sleep mode
                ; Wake up from faling edge at INT0 line
                SBIO    MCUCR, SE

                SEI
