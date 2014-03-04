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
