; ������� RAM
Clear_RAM:      LDI ZL, Low(SRAM_START)
                LDI ZH, High(SRAM_START)
                CLR R16

Flush:          ST Z+, R16             ; ��������� � ������ (����� + 1) 0
            
                CPI ZH, High(RAMEND+1) ; �������� �����?
                BRNE Flush
                
                CPI ZL, Low(RAMEND+1)
                BRNE Flush

                CLR ZL
                CLR ZH
; ����� ���������
Clr_registers:  LDI ZL, 30
                CLR ZH
                DEC ZL
                ST Z, ZH
                BRNE PC-2
