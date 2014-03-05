; Установка таймера для выполнения задачи с задержкой
SetTimer:		PUSH ZL
				PUSH ZH

				PUSH Temp1
				PUSH Counter
				
				LDI ZL, Low(TimersPool)
				LDI ZH, High(TimersPool)

				LDI Counter, TimersPoolSize

SetTimerLabel1:	LD Temp1, Z
				CP Temp1, OSREG ; в OSREG у нас предварительно номер задачи
				BREQ SetTimerLabel2

				SUBI ZL, Low(-3)
				SBCI ZH, High(-3)

				DEC Counter

				BREQ SetTimerLabel3
				RJMP SetTimerLabel1

SetTimerLabel2: CLI
				STD Z+1, XL
				STD Z+2, XH
				SEI
				RJMP SetTimerLabel6

SetTimerLabel3: LDI ZL, Low(TimersPool)
				LDI ZH, High(TimersPool)
				LDI Counter, TimersPoolSize

SetTimerLabel4:	LD Temp1, Z
				CPI Temp1, 0xFF
				BREQ SetTimerLabel5

				SUBI ZL, Low(-3)
				SBCI ZH, High(-3)

				DEC Counter

				BREQ SetTimerLabel6

				RJMP SetTimerLabel4

SetTimerLabel5: CLI
				ST Z, OSREG
				STD Z+1, XL
				STD Z+2, XH
				SEI

SetTimerLabel6: POP Counter
				POP Temp1
				POP ZH
				POP ZL
				RET
