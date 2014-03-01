.include "m8def.inc"

; RAM ------------------------------

.DSEG

; FLASH ----------------------------

.CSEG

; ������ ��������� 
                .ORG 0x0000
                RJMP Reset

; ������� ����������
                .include "vectors.asm"

                .ORG INT_VECTORS_SIZE
; ����� ������� ����������


; ������������� �����
Reset:          LDI R16, Low(RAMEND)
                OUT SPL, R16

                LDI R16, High(RAMEND)
                OUT SPH, R16

; ������� RAM � ���������
				.include "clear.asm"

; ��������� ����������
				LDI R17, 1<<ACD
				OUT ACSR, R17
				CLR R17
; ��������� ����������
				SEI
; ������� ����
MainLoop:		RJMP MainLoop
; EEPROM ---------------------------

.ESEG
