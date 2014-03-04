; ���������� ������� �����
ProcessTaskQueue:		LDI ZL, Low(TaskQueue) ; ����� ����� ������ �������
						LDI ZH, High(TaskQueue)
						
						LD OSREG, Z			   ; ����� ������ ����
						
						CPI OSREG, 0xFF

						BREQ ExitToMainLoop	   ; ����� ���� �����
						
						CLR ZH				   ; 
						LSL OSREG			   ; �������� �� 2 ������ ����� ( OSREG << 1)
						MOV ZL, OSREG		   ; 

						SUBI ZL, Low(-TaskProcs*2)
						SBCI ZH, High(-TaskProcs*2)

						LPM					   ; R0 <- (Z)
						MOV OSREG, R0
						LD R0, Z+              ; ���� ���������� Z
						LPM					   ; R0 <- (Z)
						
						MOV ZL, OSREG          ; ��� �������� ����� �������� � ������
						MOV ZH, R0

						PUSH ZL
						PUSH ZH

						; ����� ������� �������
						LDI Counter, TaskQueueSize - 1
						LDI ZL, Low(TaskQueue)
						LDI ZH, High(TaskQueue)

						CLI                   ; ������ ����������, ����� ����� ������� �������

						
ShiftQueue:             LDD OSREG, Z+1
						ST Z+, OSREG
						DEC Counter
						BRNE ShiftQueue

						LDI OSREG, 0xFF
						ST Z+, OSREG

						SEI

						POP ZH
						POP ZL
						
						IJMP			     ; ������� � ������

ExitToMainLoop:			RET
														
