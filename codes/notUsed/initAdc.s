;label				directive			value			comment
RCGCADC			 		EQU 		0x400FE638
ADC0_ACTSS 				EQU 		0x40038000
ADC0_SSCTL3 			EQU 		0x400380A4
ADC0_SSMUX3 			EQU 		0x400380A0	
ADC0_EMUX	 			EQU 		0x40038014
ADC0_PP	 				EQU 		0x40038FC4		;0x1 (125KSPS)


;label			directive			value			comment
				AREA  adcInitializeRoutine,CODE,READONLY
				THUMB	
				EXPORT	initAdc
					
initAdc			PROC
	
				PUSH{LR,R1,R0}

				LDR R1 , =RCGCADC				;ORRING MIGHT NOT WORK AS INTENDED
				LDR R0 , [R1]
				ORR R0 , R0 , #0x01				;Initialize ADC 0
				STR R0 , [R1]
				
				NOP
				NOP
				NOP ; let GPIO clock stabilize
				
				LDR R1 , =ADC0_ACTSS ; disable SS3
				LDR R0 , [R1]
				BIC R0 , #0x08			; disable SS3
				STR R0 , [R1]
				
				LDR R1 , =ADC0_EMUX 	; set for software trigger
				LDR R0 , [R1]
				BIC R0 , #0xF000	    ; select SS3
				STR R0 , [R1]
				
				LDR R1 , =ADC0_SSMUX3 	; select input pins
				LDR R0 , [R1]
				BIC R0 , #0x000F     	; select PE3 AN0?
				STR R0 , [R1]
				
				LDR R1 , =ADC0_SSCTL3 	; set control register
				LDR R0 , [R1]
				ORR R0 , #0x6	        ; IE & END set
				STR R0 , [R1]
				
				LDR R1 , =ADC0_PP 		; set sampling rate
				LDR R0 , [R1]							
				BIC R0 , #0x0F			; BIC First?						
				ORR R0 , #0x01	        ; select 125KSPS 
				STR R0 , [R1]
				
				LDR R1 , =ADC0_ACTSS    ; enable SS
				LDR R0 , [R1]
				ORR R0 , #0x08	    	; SS3
				STR R0 , [R1]
				
				POP{LR,R1,R0}
				BX LR
				
				ENDP
				
				ALIGN	
				END