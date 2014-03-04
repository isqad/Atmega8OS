; Подготовка очереди задач
ClearTaskQueue:			PUSH ZL
						PUSH ZH

						LDI ZL, Low(TaskQueue)
						LDI ZH, High(TaskQueue)

						LDI OSREG, 0xFF
						LDI Counter, TaskQueueSize

ClrTaskQueueCycle:		ST Z+, OSREG
						DEC Counter
						BRNE ClrTaskQueueCycle

						POP ZH
						POP ZL
						RET
