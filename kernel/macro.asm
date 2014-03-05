; Основные макросы ядра

; Непосредственная загрузка числа в порт
.MACRO UOUT
	LDI R16, @1
	OUT @0, R16
.ENDMACRO


; Патруль времени
; Обработка прерывания от таймера
; Макрос отвечает за за таймерную службу системы
.MACRO TimeService
			PUSH OSREG
			IN OSREG, SREG
			PUSH OSREG ; Сохраняем флаги

			PUSH ZL
			PUSH ZH

			PUSH Counter

			LDI ZL, Low(TimersPool)
			LDI ZH, High(TimersPool)

			LDI Counter, TimersPoolSize
TSLabel1:	LD OSREG, Z
			CPI OSREG, 0xFF ; NOP = 0xFF
			BREQ TSLabel3 

			CLT ; флаг T используется для информации об окончании счета
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
.ENDMACRO

; Запуск задачи с задержкой
.MACRO SetTimerTask
	LDI OSREG, @0 ; номер задачи
	LDI XL, Low(@1) ; задержка в мс
	LDI XH, High(@1)

	RCALL SetTimer
.ENDMACRO

; Запуск задачи без задержки в порядке общей очереди
.MACRO SetTask
	LDI OSREG, @0 ; номер задачи
	RCALL SendTask
.ENDMACRO
