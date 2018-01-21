;label				directive			value			comment
PF4_READ 				EQU 	 		 0x40025040; 

				AREA  checkButtonSubroutine,CODE,READONLY
				THUMB

				EXPORT	checkButton
	
checkButton 	PROC
	
				PUSH {R0,R1,LR}
											
POLL_AGAIN		LDR R0, =PF4_READ		;Put the address of the PB4
				LDR R1,[R0]				;
				CBNZ R1, return			;
				B	POLL_AGAIN			;
				
return			POP {R0,R1,LR}
				BX LR
				
				ENDP
					
				ALIGN	
				END