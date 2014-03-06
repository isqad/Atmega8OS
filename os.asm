.include "m8def.inc"
.include "kernel/macro.asm"


; Коды символов для семисегментного индикатора
; индикатор подключается к порту так:
; a b c d e f g DP - сегменты
; 7 6 5 4 3 2 1 0  - биты порта
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

.def OSREG = R17   ; Рабочий регистр системы
.def Counter = R18 ; Счетчик
.def Temp1 = R19   ; Мусорник

; RAM ------------------------------

.DSEG

				.equ TaskQueueSize = 11 ; Размер очереди задач
TaskQueue:		.byte TaskQueueSize		; Резервируем 11 байт для нашей очереди
				.equ TimersPoolSize = 5	; Количество таймеров
TimersPool:		.byte TimersPoolSize*3  ; 15 байт для таймерной службы

; FLASH ----------------------------

.CSEG

; РќР°С‡Р°Р»Рѕ РїСЂРѕРіСЂР°РјРјС‹ 
                .ORG 0x0000
                RJMP Reset

; РўР°Р±Р»РёС†Р° РїСЂРµСЂС‹РІР°РЅРёР№
                .include "vectors.asm"

                .ORG INT_VECTORS_SIZE

; Обработчики прерываний
OutComp2Int:	TimeService


; РљРѕРЅРµС† С‚Р°Р±Р»РёС†С‹ РїСЂРµСЂС‹РІР°РЅРёР№


; РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ СЃС‚РµРєР°
Reset:          LDI R16, Low(RAMEND)
                OUT SPL, R16

                LDI R16, High(RAMEND)
                OUT SPH, R16


; Очистка RAM и регистров
				.include "clear.asm"

; Сброс всех флагов

				UOUT SREG, 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Инициализация переферии и таймера системы


				RCALL ClearTimers
				RCALL ClearTaskQueue

				.equ MainClock = 8000000 ; Контроллер должен быть настроен на 8Mhz
				.equ TimerDivider = MainClock/64/1000 ; 1ms

				UOUT TCCR2, 1<<CTC2|4<<CS20 ; Устанавливаем CTC и предделитель 64
				UOUT TCNT2, 0

				LDI OSREG, Low(TimerDivider)
				OUT OCR2, OSREG

				UOUT TIMSK, 1<<OCF2

; РћС‚РєР»СЋС‡Р°РµРј РєРѕРјРїР°СЂР°С‚РѕСЂ
				LDI R17, 1<<ACD
				OUT ACSR, R17

; Настройка портов
				UOUT DDRB, 0xFF

; Фоновые действия
Background:		SetTimerTask TS_Task1, 3000
				SetTimerTask TS_Task3, 1500	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Главный цикл
; Резрешаем прерывания
MainLoop:		SEI
				WDR ; Гладим собаку
				RCALL ProcessTaskQueue ; Обработка очереди задач
				RCALL Idle             ; Простой ядра
				RJMP MainLoop

; Секция Задач

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


; Ядро
				.include "kernel.asm"

; Таблица переходов
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
