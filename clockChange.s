RCC 			EQU 0x400FE060; Run mode clock configuration register 
RIS 			EQU 0x400FE050; Run mode clock configuration register 	
	


;label			directive			value			comment
				AREA  clockChangeRoutine,CODE,READONLY
				THUMB	
				EXPORT	clockChange
				
clockChange    	PROC
	
				PUSH{LR,R1,R0}

				LDR R1, =RCC ; 
				LDR R0, [R1]
				ORR R0, R0, #0x0800 ; set bypass bit
				BIC R0, #0x400000   ; clear usesys bit
				STR R0, [R1]
				
				LDR R1, =RCC ; 
				LDR R0, [R1]
				BIC R0, R0, #0x7F0 ; set bypass bit
				ORR R0, #0x610     ; set xtal, set clock source 
				BIC	R0, #0x2000    ; clear pwdwn
				STR R0, [R1]
				
				LDR R1, =RCC       ; 
				LDR R0, [R1]
				BIC R0, R0, #0xF800000 ; sys div = 0 (divratio = 1)
				ORR R0, #0x400000     ; set usesys bit 
				STR R0, [R1]
				
				LDR R1, =RIS ;  ;POLL PLLRIS
pollAgain		LDR R0, [R1]
				AND R0, R0, #0x40 ; isolate PLLLRIS
				CMP R0,#0		   ; check if PLL has locked
				BEQ pollAgain
				
				LDR R1, =RCC ; clear bypass to enable PLL
				LDR R0, [R1]
				BIC R0, R0, #0x0800 ; clear bypass bit
				STR R0, [R1]

			
				POP{LR,R1,R0}
				BX LR
				ENDP
					
				ALIGN	
				END