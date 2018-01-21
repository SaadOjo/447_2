RCC 			EQU 0x400FE060; Run mode clock configuration register 

RCGC0 			EQU 0x400FE100 ; 
RCGCGPIO 		EQU 0x400FE608 ; GPIO clock register	
PORTB_AFSEL		EQU 0x40005420 ;
PORTB_DEN		EQU	0x4000551C ;
PORTB_AMSEL		EQU	0x40005528 ;
PORTB_PCTL		EQU	0x4000552C ;
	
PWM0_0CTL		EQU	0x40028040 ;
PWM0_0GENA		EQU	0x40028060 ;
PWM0_0LOAD		EQU	0x40028050 ;	
PWM0_0CMPA		EQU	0x40028058 ;
PWM0_0INTEN		EQU	0x40028044 ;
PWM0_ENABLE		EQU	0x40028008 ;
	

;label			directive			value			comment
				AREA  pwmInitializeRoutine,CODE,READONLY
				THUMB	
				EXPORT	pwmInit
				
pwmInit      	PROC
	
				PUSH{LR,R1,R0}
				
				LDR R0,=RCGC0		;Enable PWM Clock	
				LDR R1,[R0]			;
				ORR	R1,#0x00100000	;
				STR R1,[R0]			;
				
				NOP					;Wait for the clock to stabalise
				NOP
				NOP

				LDR R0,=RCGCGPIO	;Turn on the clock for PORT B	
				LDR R1,[R0]			;
				ORR	R1,#0x02		;
				STR R1,[R0]			;
				
				NOP					;Wait for the clock to stabalise
				NOP
				NOP
				
				; Enable alternate functions
				LDR R0, =PORTB_AFSEL
				LDR R1, [R0]
				ORR R1, #0x40 ; set bit 6 to enable alt functions on PE3
				STR R1, [R0]
				
				; Enable alternate functions
				LDR R0, =PORTB_PCTL
				LDR R1, [R0]
				BIC R1, #0x0F000000 ; clear the bits corresponding to PB6
				ORR R1, #0x04000000 ; select the pin for M0PWM0
				STR R1, [R0]
				
				LDR R0, =PORTB_DEN
				LDR R1, [R0]
				ORR R1, #0x40 ; clear bit 6 to enable digital on PB6
				STR R1, [R0]
				
				; Enable analog on PE3
				LDR R0, =PORTB_AMSEL
				LDR R1, [R0]
				BIC R1, #0x40 ; set bit 6 to disable analog on PB6
				STR R1, [R0]
				
				;PWM Configurations
				
				LDR R0, =RCC	;Congiguring PWM clock source
				LDR R1, [R0]
				ORR R1, #0x100000 ; Set USEPWMDIV bit
				BIC R1, #0xE0000  ; set PWMDIV to (000)
				STR R1, [R0]

				LDR R0, =PWM0_0CTL	;Diable PWM0*
				MOV R1,  #0x0 	; 
				STR R1, [R0]

				LDR R0, =PWM0_0GENA	;
				MOV R1,  #0x0000008C ; 
				STR R1, [R0]
				
				LDR R0, =PWM0_0LOAD	;
				;MOV R1,  #1250; 
				MOV R1,  #2500; 
				STR R1, [R0]
				
				LDR R0, =PWM0_0CMPA	;
				MOV R1,  #1200; 
				STR R1, [R0]
				
				LDR R0, =PWM0_0INTEN	;
				LDR R1, [R0]
				ORR R1, #0x100 ; set PWM to trigger the ADC on counter = 0
				STR R1, [R0]
				
				
				LDR R0, =PWM0_0CTL	;Enable PWM0*
				MOV R1,  #0x1 	; 
				STR R1, [R0]
				
				LDR R0, =PWM0_ENABLE	;Enable Ootput
				MOV R1,  #0x3 	; 
				STR R1, [R0]
				
			
				POP{LR,R1,R0}
				BX LR
				ENDP
					
				ALIGN	
				END