.include "m8def.inc"

.def OSREG = R17   ; ������� ������� �������
.def Counter = R18 ; �������
.def Temp1 = R19   ; ��������

; RAM ------------------------------

.DSEG

				.equ TaskQueueSize = 11 ; ������ ������� �����
TaskQueue:		.byte TaskQueueSize		; ����������� 11 ���� ��� ����� �������
				.equ TimersPoolSize = 5	; ���������� ��������
TimersPool:		.byte TimersPoolSize*3  ; 15 ���� ��� ��������� ������

; FLASH ----------------------------

.CSEG

; Начало программы 
                .ORG 0x0000
                RJMP Reset

; Таблица прерываний
                .include "vectors.asm"

                .ORG INT_VECTORS_SIZE

; ����������� ����������
OutComp2Int:	TimeCop
				RETI


; Конец таблицы прерываний


; Инициализация стека
Reset:          LDI R16, Low(RAMEND)
                OUT SPL, R16

                LDI R16, High(RAMEND)
                OUT SPH, R16


; ������� RAM � ���������
				.include "clear.asm"

; ����� ���� ������

				UOUT SREG, 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ������������� ��������� � ������� �������


				RCALL ClearTimers
				RCALL ClearTaskQueue

				.equ MainClock = 8000000 ; ���������� ������ ���� �������� �� 8Mhz
				.equ TimerDivider = MainClock/64/1000 ; 1ms

				UOUT TCCR2, 1<<CTC2|4<<CS20 ; ������������� CTC � ������������ 64
				UOUT TCNT2, 0

				LDI OSREG, Low(TimerDivider)
				OUT OCR2, OSREG

				UOUT TIMSK, 1<<OCF2

; Отключаем компаратор
				LDI R17, 1<<ACD
				OUT ACSR, R17

; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ������� ����
; ��������� ����������
MainLoop:		SEI
				WDR ; ������ ������
				RCALL ProcessTaskQueue ; ��������� ������� �����
				RCALL Idle             ; ������� ����
				RJMP MainLoop

; ������ �����

Idle:			RET
Task1:			RET
Task2:			RET
Task3:			RET
Task4:			RET
Task5:			RET
Task6:			RET
Task7:			RET
Task8:			RET
Task9:			RET


; ����
				.include "kernel.asm"

; ������� ���������
TaskProcs:      .dw Idle
				.dw Task1
				.dw Task2
				.dw Task3
				.dw Task4
				.dw Task5
				.dw Task6
				.dw Task7
				.dw Task8
				.dw Task9
		
; EEPROM ---------------------------

.ESEG
