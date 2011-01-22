;------------------------------------------------
;                   Clear SRAM
;------------------------------------------------

.MACRO  CLEAR_SRAM
        ; In MCU without SRAM (SRAM_SIZE = 0), data space consists of 
        ; Register File only ==> clear GP Registers only
        
        .IF (SRAM_SIZE > 0)
                CLR     R16
                LDI     ZH, high(RAMEND + 1)
                LDI     ZL,  low(RAMEND + 1)
                
                ST      -Z, R16
                CPI     ZH, 0
                BRNE    PC - 2
                
                CPI     ZL, 32
                BRNE    PC - 4
        .ENDIF

         CLR     ZH
         LDI     ZL, 30

         DEC     ZL
         ST      Z, ZH
         BRNE    PC - 2
.ENDMACRO

;------------------------------------------------


;---------------------------------------------
;           Load immediate value @1
;              to IO Register @0
;---------------------------------------------

.MACRO  LDIO
        LDI     R16, @1
        OUT     @0, R16
.ENDMACRO

;---------------------------------------------


;--------------------------------------------------
;           Set bit @1 in IO Register @0
;--------------------------------------------------

.MACRO  SBIO
        .IF (@0 < 0x20)
                SBI     @0, @1
        .ELSE
                IN      R17, @0
                LDI     R16, (1 << @1)
                OR      R16, R17
                OUT     @0, R16
        .ENDIF
.ENDMACRO

;--------------------------------------------------


;----------------------------------------------------
;           Clear bit @1 in IO Register @0
;----------------------------------------------------

.MACRO  CBIO
        .IF (@0 < 0x20)
                CBI     @0, @1
        .ELSE
                IN      R17, @0
                LDI     R16, ~(1 << @1)
                AND     R16, R17
                OUT     @0, R16
        .ENDIF
.ENDMACRO

;----------------------------------------------------


;---------------------------------------
;           Stop and clear T0		
;---------------------------------------

.MACRO  STOP_T0
        CBIO    TCCR0, CS02
        CBIO    TCCR0, CS00
        LDI     temp, 0
        OUT     TCNT0, temp
.ENDMACRO

;---------------------------------------


;--------------------------------------------------
;           Start T0 with prescaler 1024
;--------------------------------------------------

.MACRO  START_T0
        LDI     T0_OF_count, T0_OF_number
        SBIO    TCCR0, CS02
        SBIO    TCCR0, CS00
.ENDMACRO

;--------------------------------------------------
