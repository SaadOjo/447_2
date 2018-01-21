; ADC Registers
RCGCADC 		EQU 0x400FE638 ; ADC clock register
	
; ADC0 base address EQU 0x40038000
ADC0_ACTSS 		EQU 0x40038000 ; Sample sequencer (ADC0 base address)
ADC0_RIS 		EQU 0x40038004 ; Interrupt status
ADC0_IM 		EQU 0x40038008 ; Interrupt select
ADC0_ISC 		EQU 0x40038034 ; Interrupt status and clear
ADC0_EMUX 		EQU 0x40038014 ; Trigger select
ADC0_PSSI 		EQU 0x40038028 ; Initiate sample
ADC0_SSMUX3 	EQU 0x400380A0 ; Input channel select
ADC0_SSCTL3 	EQU 0x400380A4 ; Sample sequence control
ADC0_SSFIFO3	EQU 0x400380A8 ; Channel 3 results
ADC0_PP 		EQU 0x40038FC4 ; Sample rate
ADC0_TTSSEL 	EQU 0x40038FC4 ; Trigger source select
	
; GPIO Registers
RCGCGPIO 		EQU 0x400FE608 ; GPIO clock register
; PORT E base address EQU 0x40024000
PORTE_DEN 		EQU 0x4002451C ; Digital Enable
PORTE_PCTL 		EQU 0x4002452C ; Alternative function configuration
PORTE_AFSEL 	EQU 0x40024420 ; Alternate function select
PORTE_AMSEL 	EQU 0x40024528 ; Enable analog	

; PORT F base address EQU 0x40025000
PORTF_DEN 		EQU 0x4002551C ; Digital Enable
PORTF_AMSEL 	EQU 0x40025528 ; Enable analog
PORTF_GPIODIR 	EQU 0x40025400 ; Direction
	
	
	
	
;label			directive			value			comment
				AREA  InitializeRoutine,CODE,READONLY
				THUMB	
				EXPORT	initialize
				
initialize	PROC
	
				PUSH{LR,R1,R0}

				; Start clocks for features to be used
				LDR R1, =RCGCADC ; Turn on ADC clock
				LDR R0, [R1]
				ORR R0, R0, #0x01 ; set bit 0 to enable ADC0 clock
				STR R0, [R1]
				NOP
				NOP
				NOP ; Let clock stabilize
				LDR R1, =RCGCGPIO ; Turn on GPIO clock
				LDR R0, [R1]
				ORR R0, R0, #0x30 ; set bit 4 and 5 to enable port E and port F clock
				STR R0, [R1]
				NOP
				NOP
				NOP ; Let clock stabilize
				
			    ; Setup GPIO to make PE3 input for ADC0
				; Enable alternate functions
				LDR R1, =PORTE_AFSEL
				LDR R0, [R1]
				ORR R0, R0, #0x08 ; set bit 3 to enable alt functions on PE3
				STR R0, [R1]
				; PCTL does not have to be configured
				; since ADC0 is automatically selected when
				; port pin is set to analog.
				; Disable digital on PE3
				
				LDR R1, =PORTE_DEN
				LDR R0, [R1]
				BIC R0, R0, #0x08 ; clear bit 3 to disable analog on PE3
				STR R0, [R1]
				
				; Enable analog on PE3
				LDR R1, =PORTE_AMSEL
				LDR R0, [R1]
				ORR R0, R0, #0x08 ; set bit 3 to enable analog on PE3
				STR R0, [R1]
				
				;Configure Port PB4 for switch input
				
				LDR R1, =PORTF_DEN
				LDR R0, [R1]
				ORR R0, R0, #0x10 ; set bit 4 to enable analog on PF4
				STR R0, [R1]
				; Enable analog on PE3
				LDR R1, =PORTF_AMSEL
				LDR R0, [R1]
				BIC R0, R0, #0x10 ; clear bit 4 to disable analog on PF4
				STR R0, [R1]
				
				LDR R1, =PORTF_GPIODIR
				LDR R0, [R1]
				BIC R0, R0, #0x10 ; clear bit 4 make input
				STR R0, [R1]
				
				
				
				
				; Disable sequencer while ADC setup
				LDR R1, =ADC0_ACTSS
				LDR R0, [R1]
				BIC R0, R0, #0x08 ; clear bit 3 to disable seq 3
				STR R0, [R1]
				
				; Select PWM generator's PWM module
				LDR R1, =ADC0_TTSSEL
				LDR R0, [R1]
				BIC R0, R0, #0x30 ; select PWM zero for generator zero 
				STR R0, [R1]
				
				; Select trigger source
				LDR R1, =ADC0_EMUX
				LDR R0, [R1]
				BIC R0, R0, #0xF000 ; clear bits 15:12 
				ORR R0, R0, #0x6000 ; Use PWM generator 0 for triggering
				STR R0, [R1]
				
				; Select input channel
				LDR R1, =ADC0_SSMUX3
				LDR R0, [R1]
				BIC R0, R0, #0x000F ; clear bits 3:0 to select AIN0
				STR R0, [R1]
				; Config sample sequence
				LDR R1, =ADC0_SSCTL3
				LDR R0, [R1]
				ORR R0, R0, #0x06 ; set bit 1 (END0) ?EN
				STR R0, [R1]
				; Set sample rate
				LDR R1, =ADC0_PP
				LDR R0, [R1]
				BIC R0, #0x0F     ;	
				ORR R0, R0, #0x01 ; set bits 3:0 to 1 for 125k sps
				STR R0, [R1]
				; Done with setup, enable sequencer
				LDR R1, =ADC0_ACTSS
				LDR R0, [R1]
				ORR R0, R0, #0x08 ; set bit 3 to enable seq 3
				STR R0, [R1] ; sampling enabled but not initiated yet
			
				POP{LR,R1,R0}
				BX LR
				ENDP
					
				ALIGN	
				END