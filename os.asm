.include "m8def.inc"

; RAM ------------------------------

.DSEG

; FLASH ----------------------------

.CSEG

; Начало программы 
                .ORG 0x0000
                RJMP Reset

; Таблица прерываний
                .ORG INT0addr ; External Interrupt Request 0
                RETI
                .ORG INT1addr ; External Interrupt Request 1
                RETI
                .ORG OC2addr  ; Timer/Counter2 Compare Match
                RETI
                .ORG OVF2addr ; Timer/Counter2 Overflow
                RETI
                .ORG ICP1addr ; Timer/Counter1 Capture Event
                RETI
                .ORG OC1Aaddr ; Timer/Counter1 Compare Match A
                RETI
                .ORG OC1Baddr ; Timer/Counter1 Compare Match B
                RETI
                .ORG OVF1addr ; Timer/Counter1 Overflow
                RETI
                .ORG OVF0addr ; Timer/Counter0 Overflow
                RETI
                .ORG SPIaddr  ; Serial Transfer Complete
                RETI
                .ORG URXCaddr ; USART, Rx Complete
                RETI
                .ORG UDREaddr ; USART Data Register Empty
                RETI
                .ORG UTXCaddr ; USART, Tx Complete
                RETI
                .ORG ADCCaddr ; ADC Conversion Complete
                RETI
                .ORG ERDYaddr ; EEPROM Ready
                RETI
                .ORG ACIaddr  ; Analog Comparator
                RETI
                .ORG TWIaddr  ; 2-wire Serial Interface
                RETI
                .ORG SPMRaddr ; Store Program Memory Ready
                RETI
                .ORG INT_VECTORS_SIZE
; Конец таблицы прерываний


; Инициализация стека
Reset:          LDI R16, Low(RAMEND)
                OUT SPL, R16

                LDI R16, High(RAMEND)
                OUT SPH, R16

; Очистка RAM
Clear_RAM:      LDI ZL, Low(SRAM_START)
                LDI ZH, High(SRAM_START)
                CLR R16

Flush:          ST Z+, R16             ; Сохраняем в ячейке (адрес + 1) 0
            
                CPI ZH, High(RAMEND+1) ; Достигли конца?
                BRNE Flush
                
                CPI ZL, Low(RAMEND+1)
                BRNE Flush

                CLR ZL
                CLR ZH
; Сброс регистров
Clr_registers:  LDI ZL, 30
                CLR ZH
                DEC ZL
                ST Z, ZH
                BRNE PC-2
; EEPROM ---------------------------

.ESEG
