SendTask:		PUSH ZL
				PUSH ZH
				PUSH Temp1
				PUSH Counter

				LDI ZL, Low(TaskQueue)
				LDI ZH, High(TaskQueue)

				LDI Counter, TaskQueueSize

SendTaskLabel1:	LD Temp1, Z+
				CPI Temp1, 0xFF
				BREQ SendTaskLabel2

				DEC Counter
				BREQ SendTaskLabel3
				RJMP SendTaskLabel1

SendTaskLabel2:	ST -Z, OSREG
				
SendTaskLabel3: POP Counter
				POP Temp1
				POP ZH
				POP ZL
				RET
