.include "m8def.inc"

; RAM ------------------------------

.DSEG

; FLASH ----------------------------

.CSEG

; Начало программы 
                .ORG 0x0000
                RJMP Reset

; Таблица прерываний
                .include "vectors.asm"

                .ORG INT_VECTORS_SIZE
; Конец таблицы прерываний


; Инициализация стека
Reset:          LDI R16, Low(RAMEND)
                OUT SPL, R16

                LDI R16, High(RAMEND)
                OUT SPH, R16

; Очистка RAM и регистров
				.include "clear.asm"

; Отключаем компаратор
				LDI R17, 1<<ACD
				OUT ACSR, R17
				CLR R17
; Резрешаем прерывания
				SEI
; Главный цикл
MainLoop:		RJMP MainLoop
; EEPROM ---------------------------

.ESEG
