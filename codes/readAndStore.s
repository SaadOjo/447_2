;label				directive			value			comment
ADC0_PSSI 				EQU 		0x40038028
ADC0_FIFO3 				EQU 		0x400380A8
ADC0_RIS 				EQU 		0x40038004
ADC0_ISC 				EQU 		0x4003800C	
				
				AREA  readAndStoreSubroutine,CODE,READONLY
				THUMB

				EXPORT	readAndStore
	
readAndStore		PROC
	
				PUSH {R0,LR}
				
				;Activated by PWM instead
				;LDR R0, =ADC0_PSSI;		; Trigger the ADC SS3 
				;MOV R1, #0x8			;
				;STR R1,[R0]				;
											
POLL_AGAIN		LDR R0, =ADC0_RIS		;BUSY WAIT
				LDR R1, [R0]
				BIC R1, #0x7	 		; Ignore everything but SS3
				CMP R1,#0		 		; Check for int
				BEQ	POLL_AGAIN			; Read Again
					
				LDR R0, =ADC0_ISC;		; Clear the INT flag
				MOV R1, #0x8			;
				STR R1,[R0]				;

				LDR R0, =ADC0_FIFO3;	; Read the FIF0
				LDR R1, [R0]			;
				
				LSR R1,#4				;Get rid of the 4 LSB
				STRB R1,[R4],#1			;Store byte and Post increment
				SUB  R5,#1				;Decrement Counter
				
				POP {R0,LR}
				BX LR
				
				ENDP
					
				ALIGN	
				END