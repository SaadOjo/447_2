;label			directive			value			comment
PORTB_READ		EQU		0x400053C0	;Higher bits are inputs
PORTB_WRITE		EQU		0x4000503C	;Lower bits are outputs	

;label			directive			value			comment
				AREA               readKeyRoutine,CODE,READONLY,ALIGN = 2
				THUMB	
				EXPORT	readKey

readKey		    PROC
				PUSH{R0,R1,R2,R4,R6,LR}
; We are going to use port A for the keyboard inputs and outputs
				LDR R0,=PORTB_WRITE					;Load register RO with address of RCGCGPIO Register
				MOV R1,#0x01						;Set pin PA0 to 1, all else zero
				MOV R2,#4							;Number of times this loop should run
				MOV R3,#0							;
				MOV R4,#0							;For determining the row(column) of the key
loop			MVN R6,R1							;Invert the output before storing to the port
				STR R6,[R0]							;
				BL readRow							;
				CBZ R3,cont							;
				B return							;
cont			LSL R1,#1							;
;				LDR R1,[R0]							;
				SUBS R2,#1							;
				BNE loop							;
				MOV R3,#0							; nee
				B ret2								;
return			MOV R3,R4							;
ret2			POP{R0,R1,R2,R4,R6,LR}
				BX LR
				ENDP 
				
				EXPORT	readRow
readRow			PROC
				PUSH{R0,R1,R2,LR}					;
				LDR R0, =PORTB_READ					;
				LDR	R1,[R0]							; R1 contains the data from the register
				MVN R1,R1							;
				MOV R2,#5							; Counter for 4 rows
				LSR R1,#4							;
loop2			ADD R3,#1							;
				ADD R4,#1							;
				SUBS R2,#1							;
				BEQ	contLink						;
				LSRS R1,#1							;
				BCC loop2							; loops if C == 0
				B end1
contLink		MOV R3,#0							;			
end1			POP{R0,R1,R2,LR}					;
				BX LR								;
				ENDP

				ALIGN	
				END
					
					