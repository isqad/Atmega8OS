; Обработчик очереди задач
ProcessTaskQueue:		LDI ZL, Low(TaskQueue) ; Берем адрес начала очереди
						LDI ZH, High(TaskQueue)
						
						LD OSREG, Z			   ; Берем первый байт
						
						CPI OSREG, 0xFF

						BREQ ExitToMainLoop	   ; Выход если равно
						
						CLR ZH				   ; 
						LSL OSREG			   ; Умножаем на 2 взятое число ( OSREG << 1)
						MOV ZL, OSREG		   ; 

						SUBI ZL, Low(-TaskProcs*2)
						SBCI ZH, High(-TaskProcs*2)

						LPM					   ; R0 <- (Z)
						MOV OSREG, R0
						LD R0, Z+              ; Ради инкремента Z
						LPM					   ; R0 <- (Z)
						
						MOV ZL, OSREG          ; Так получили адрес перехода к задаче
						MOV ZH, R0

						PUSH ZL
						PUSH ZH

						; Далее двигаем очередь
						LDI Counter, TaskQueueSize - 1
						LDI ZL, Low(TaskQueue)
						LDI ZH, High(TaskQueue)

						CLI                   ; Запрет прерывания, иначе может сорвать очередь

						
ShiftQueue:             LDD OSREG, Z+1
						ST Z+, OSREG
						DEC Counter
						BRNE ShiftQueue

						LDI OSREG, 0xFF
						ST Z+, OSREG

						SEI

						POP ZH
						POP ZL
						
						IJMP			     ; Переход в задачу

ExitToMainLoop:			RET
														
