.include "m8def.inc"
.include "kernel/macro.asm"


; ���� �������� ��� ��������������� ����������
; ��������� ������������ � ����� ���:
; a b c d e f g DP - ��������
; 7 6 5 4 3 2 1 0  - ���� �����
;
;  a_
; f|g|b
;	-
; e| |c
;   -
;   d 	

.equ Dig0               = 0xFC
.equ Dig1				= 0x60
.equ Dig2				= 0x6D
;.equ Dig3				= 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.equ TS_Idle 			= 0		; 
.equ TS_Task1		 	= 1		; 
.equ TS_Task2 			= 2		; 
.equ TS_Task3	 		= 3		; 
.equ TS_Task4	 		= 4		;
.equ TS_Task5			= 5		;
.equ TS_Task6	 		= 6		; 
.equ TS_Task7	 		= 7		;
.equ TS_Task8 			= 8		;
.equ TS_Task9	 		= 9		;

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
OutComp2Int:	TimeService


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

; ��������� ������
				UOUT DDRB, 0xFF

; ������� ��������
Background:		SetTimerTask TS_Task1, 3000
				SetTimerTask TS_Task3, 1500	
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
Task1:			SBI PORTB, 1
				SetTimerTask TS_Task2, 1000
				RET
Task2:			CBI PORTB, 1
				SetTimerTask TS_Task1, 1000
				RET
Task3:			SBI PORTB, 2
				SetTimerTask TS_Task4, 500
				RET
Task4:			CBI PORTB, 2
				SetTimerTask TS_Task3, 500
				RET
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
