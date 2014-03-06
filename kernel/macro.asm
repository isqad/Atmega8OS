; �������� ������� ����

; ���������������� �������� ����� � ����
.MACRO UOUT
	LDI R16, @1
	OUT @0, R16
.ENDM


; ������� �������
; ��������� ���������� �� �������
; ������ �������� �� �� ��������� ������ �������
.MACRO TimeService
			PUSH OSREG
			IN OSREG, SREG
			PUSH OSREG ; ��������� �����

			PUSH ZL
			PUSH ZH

			PUSH Counter

			LDI ZL, Low(TimersPool)
			LDI ZH, High(TimersPool)

			LDI Counter, TimersPoolSize
TSLabel1:	LD OSREG, Z
			CPI OSREG, 0xFF ; NOP = 0xFF
			BREQ TSLabel3 

			CLT ; ���� T ������������ ��� ���������� �� ��������� �����
			LDD OSREG, Z+1
			SUBI OSREG, Low(1)
			STD Z+1, OSREG

			BREQ TSLabel2
			
			SET

TSLabel2:	LDD OSREG, Z+2
			SBCI OSREG, High(1)
			STD Z+2, OSREG
			BRNE TSLabel3
			BRTS TSLabel3

			LD OSREG, Z
			RCALL SendTask

			LDI OSREG, 0xFF
			ST Z, OSREG

TSLabel3:   SUBI ZL, Low(-3)
			SBCI ZH, High(-3)
			DEC Counter
			BRNE TSLabel1

			POP Counter
			POP ZH
			POP ZL

			POP OSREG
			OUT SREG, OSREG
			POP OSREG
			RETI
.ENDM

; ������ ������ � ���������
.MACRO SetTimerTask
	LDI OSREG, @0 ; ����� ������
	LDI XL, Low(@1) ; �������� � ��
	LDI XH, High(@1)

	RCALL SetTimer
.ENDM

; ������ ������ ��� �������� � ������� ����� �������
.MACRO SetTask
	LDI OSREG, @0 ; ����� ������
	RCALL SendTask
.ENDM
