.DEF    macro_reg_1 = R16
.DEF    macro_reg_2 = R17

.DEF    main_reg = R18
.DEF    temp_reg = R19


// Setup T0 for calculating delay between switching modes

.EQU    F_CPU        = 1_200_000                                // Hz
.DEF    T0_OF_count  = R24
.EQU    T0_prescaler = 1024
.EQU    T0_OF_period = 256                                      // since 8bit TCNT0
.EQU    switch_delay = 6                                        // sec [1 - 55]
.EQU    F_T0         = F_CPU / T0_prescaler
.EQU    T0_OF_number = (switch_delay * F_T0) / T0_OF_period


// Pin to MOC3041

.EQU    MOC_DDR  = DDRB
.EQU    MOC_PORT = PORTB
.EQU    MOC_LINE = PB4


// Pin to LED

.EQU    LED_DDR  = DDRB
.EQU    LED_PORT = PORTB
.EQU    LED_LINE = PB3


// Pin to sensor

.EQU    sensor_DDR  = DDRB
.EQU    sensor_PORT = PORTB
.EQU    sensor_LINE = PB1


/*      
------------------------------------------------------------        
        Register R20 -- Program Status Flags (PSF)
------------------------------------------------------------
  (MSB)                                             (LSB)
  [ 0 ] [ 0 ] [ 0 ] [ 0 ] [ 0 ] [PSF_TM] [PSF_LC] [PSF_DC]
------------------------------------------------------------
 DC (Door Condition):  set -- open,   clear -- close
 LC (Lamp Condition):  set -- light,  clear -- black
 TM (Triggering Mode): set -- D-Mode, clear -- T-Mode       */

.DEF	PSF    = R20    // register definition
.EQU	PSF_DC = 0      // bit0 defenition
.EQU	PSF_LC = 1      // bit1 defenition
.EQU	PSF_TM = 2      // bit2 defenition


// Not Connected pins

.EQU    NC1_DDR  = DDRB
.EQU    NC1_PORT = PORTB
.EQU    NC1_LINE = PB2

.EQU    NC2_DDR  = DDRB
.EQU    NC2_PORT = PORTB
.EQU    NC2_LINE = PB0
