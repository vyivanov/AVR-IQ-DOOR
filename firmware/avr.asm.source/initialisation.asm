init:           
                CLEAR_SRAM

                // Stack pointer initialization
                LDIO    SPL, LOW(RAMEND)

                // Disable analog comparator
                // Shut down ADC
                SBIO    ACSR, ACD
                SBIO	PRR,  PRADC
                
                // Pin to LED -- output
                // Default -- low
                SBIO    LED_DDR,  LED_LINE
                CBIO    LED_PORT, LED_LINE

                // Pin to MOC3041 -- output
                // Default -- high
                SBIO    MOC_DDR,  MOC_LINE
                SBIO    MOC_PORT, MOC_LINE

                // Pin to sensor -- input without pull-up
                CBIO    sensor_DDR,  sensor_LINE
                CBIO    sensor_PORT, sensor_LINE
                
                // Not Connnected pins -- input with pull-up
                CBIO    NC1_DDR,  NC1_LINE
                SBIO    NC1_PORT, NC1_LINE
                CBIO    NC2_DDR,  NC2_LINE
                SBIO    NC2_PORT, NC2_LINE

                // Enable INT0 IRQ 
                // Enable interrupt from T0 overflow
                SBIO    GIMSK,  INT0
                SBIO    TIMSK0, TOIE0

                // Enable Idle sleep mode 
                // since must recognize edge on INT0 for wake-up
                // (see p.46 of ATtiny13A datasheet)
                SBIO    MCUCR, SE
                CBIO    MCUCR, SM1
                CBIO    MCUCR, SM0

                // Rising edge as starting condition
                // for INT0 IRQ (i.e. opening the door)
                SBIO    MCUCR, ISC01
                SBIO    MCUCR, ISC00 

                SEI
