//-------------------------------------------------
//                   Clear SRAM
//-------------------------------------------------

.MACRO  CLEAR_SRAM

        // In MCU without SRAM (SRAM_SIZE = 0), 
        // data space consists of Register 
        // File only ==> clear GP Registers only
        
        .IF (SRAM_SIZE > 0)
                CLR     macro_reg_1
                LDI     ZH, high(RAMEND + 1)
                LDI     ZL,  low(RAMEND + 1)
                
                ST      -Z, macro_reg_1
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

//-------------------------------------------------


//---------------------------------------------
//           Load immediate value @1
//              to IO Register @0
//---------------------------------------------

.MACRO  LDIO
        LDI     macro_reg_1, @1
        OUT     @0, macro_reg_1
.ENDMACRO

//---------------------------------------------


//--------------------------------------------------
//           Set bit @1 in IO Register @0
//--------------------------------------------------

.MACRO  SBIO
        .IF (@0 < 0x20)
                SBI     @0, @1
        .ELSE
                IN      macro_reg_2, @0
                LDI     macro_reg_1, (1 << @1)
                OR      macro_reg_1, macro_reg_2
                OUT     @0, macro_reg_1
        .ENDIF
.ENDMACRO

//--------------------------------------------------


//----------------------------------------------------
//           Clear bit @1 in IO Register @0
//----------------------------------------------------

.MACRO  CBIO
        .IF (@0 < 0x20)
                CBI     @0, @1
        .ELSE
                IN      macro_reg_2, @0
                LDI     macro_reg_1, ~(1 << @1)
                AND     macro_reg_1, macro_reg_2
                OUT     @0, macro_reg_1
        .ENDIF
.ENDMACRO

//----------------------------------------------------


//---------------------------------------
//           Stop and clear T0		
//---------------------------------------

.MACRO  STOP_T0
        CBIO    TCCR0B, CS02
        CBIO    TCCR0B, CS00
        LDI     macro_reg_1, 0
        OUT     TCNT0, macro_reg_1
.ENDMACRO

//---------------------------------------


//--------------------------------------------------
//           Start T0 with prescaler 1024
//--------------------------------------------------

.MACRO  START_T0
        LDI     T0_OF_count, T0_OF_number
        SBIO    TCCR0B, CS02
        SBIO    TCCR0B, CS00
.ENDMACRO

//--------------------------------------------------
