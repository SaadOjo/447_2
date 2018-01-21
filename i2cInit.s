;Register           EQU     Address
;----------------- -----   ------------
RCGCGPIO		 	EQU 	0x400FE608
RCGCI2C				EQU		0x400FE620
GPIOAFSEL			EQU		0x40005420
GPIOODR				EQU		0x4000550C
GPIOPCTL			EQU     0x4000552C
I2CMCR 				EQU		0x40020220
I2CMTPR 			EQU		0x4002000C
I2CMSA				EQU		0x40020000
I2CMDR 				EQU		0x40020008
I2CMCS 				EQU		0x40020004

		AREA    |.text|, READONLY, CODE, ALIGN=2
        THUMB
		
        EXPORT  init_i2c             	; Make available

init_i2c
 ;Enable and provide a clock to I2C module 0 in Run mode
            LDR     R1, =RCGCI2C
            LDR     R0, [R1]
            ORR     R0, #1
            STR     R0, [R1]
            NOP
            NOP
            NOP
            
            ; Initialize the clock for Port B.
            LDR     R1, =RCGCGPIO
            LDR     R0, [R1]
            ORR     R0, #0x02
            STR     R0, [R1]
            NOP
            NOP
            NOP     
       
         ; Alternate function for PB2-PB3.
            LDR     R1, =GPIOAFSEL
            LDR     R0, [R1]
            ORR     R0, #0x0C
            STR     R0, [R1]
            
            ; Enable the I2CSDA pin for open-drain operation
			
            LDR     R1, =GPIOODR	
            MOV     R0, #0x08
            STR     R0, [R1]
            
            ; PB2-PB3=SCL-SDA
            LDR     R1, =GPIOPCTL
            LDR     R0, [R1]
            ORR     R0, #6912 ;ohhh???
            STR     R0, [R1]
			
			; Initialize the I2C Master
            LDR     R1, =I2CMCR 	
            MOV     R0, #0x00000010
            STR     R0, [R1]
			
			; Set the desired SCL clock speed of 100Kbps
            LDR     R1, =I2CMTPR 	
            MOV     R0, #0x00000009
            STR     R0, [R1]
			
			BX LR
			
			ALIGN 
			END	