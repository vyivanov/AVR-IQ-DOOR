    .CSEG

    .ORG 0x000

    RJMP    init
    RJMP    ISR_door_switch     ; IRQ0 handler
    RETI
    RJMP    ISR_mode_switch     ; Timer0 overflow handler
    RETI
    RETI
