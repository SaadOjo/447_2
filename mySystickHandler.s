STORE_ADDR 			EQU 	0x20000400;
NO_SAMPLES			EQU		24000;
	
					AREA    |.text|, READONLY, CODE, ALIGN=2
					THUMB
					
					EXTERN  readPot
					EXTERN  InitSysTick
					EXTERN	writeToDac
					EXPORT  mySystickHandler        ; Make available

mySystickHandler	PUSH {LR}
				
					CMP R5,#0			;
					BEQ	reset			;
					BL	writeToDac		;
					SUB R5,#1			;
					
return 				POP {LR}
					BX		LR					    ; Return

reset 				
					LDR R4, =STORE_ADDR	;Initialise pointer at starting address
					MOV	R5, #NO_SAMPLES	;Initialize counters for the number of samples
					BL readPot			;
					BL	InitSysTick 	;
					;Read new playback Rate		
					B return
					
					ALIGN                           ; Aligning the output binary
					END                             ; End of file

