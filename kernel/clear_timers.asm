; Подготовка системного таймера
ClearTimers:		PUSH ZL
					PUSH ZH

					LDI ZL, Low(TimersPool)
					LDI ZH, High(TimersPool)

					LDI Counter, TimersPoolSize

					LDI OSREG, 0xFF
					LDI Temp1, 0x00
					
ClrTimersCycle:		ST Z+, OSREG
					ST Z+, Temp1
					ST Z+, Temp1
					
					DEC Counter
					BRNE ClrTimersCycle
					
					POP ZH
					POP ZL
					RET 
