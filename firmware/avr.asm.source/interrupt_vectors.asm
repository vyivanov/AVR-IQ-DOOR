.CSEG

.ORG 0x0000

            RJMP    init                // Hardware Reset
            RJMP    ISR_door_switch     // INT0 Change
            RETI                        // PCINT Change
            RJMP    ISR_mode_switch     // Timer/Counter0 Overflow
            RETI                        // EEPROM Ready
            RETI                        // Analog Comparator
            RETI                        // Timer/Counter0 Compare Match A
            RETI                        // Timer/Counter0 Compare Match B
            RETI                        // Watchdog Time-out
            RETI                        // ADC Conversion Complete
