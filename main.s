STORE_ADDR 		EQU 	0x20000400;
NO_SAMPLES		EQU		24000;

;LABEL			DIRECTIVES		VALUE
				AREA main,CODE,READONLY,ALIGN=2
				EXTERN	pwmInit
				EXTERN	initialize
				EXTERN	clockChange	
				EXTERN	readAndStore
				EXTERN	checkButton	
				EXTERN	init_i2c
				EXTERN	writeToDac	
				IMPORT  InitSysTick 	
				EXPORT	__main
				ENTRY				
__main			
				LDR R4, =STORE_ADDR	;Initialise pointer at starting address
				MOV	R5, #NO_SAMPLES	;Initialize counters for the number of samples
				
				BL	clockChange 	;Not sure if it works as intended
				BL	pwmInit
				BL	initialize
				
				;BL checkButton		;BUSY WAIT
				
loop1			CMP	R5,#0;
				BEQ playback;
				BL  readAndStore
				B	loop1
				
playback		LDR R4,	=STORE_ADDR ;Reset the pointer address
				MOV R5, #NO_SAMPLES ;Set the counter for writing the data
				
				BL	init_i2c		;
				BL	InitSysTick 	;
				
				;Should go to subroutine

				
DONE			B	DONE
				ALIGN
				END		
