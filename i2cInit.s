;Register           EQU     Address
;----------------- -----   ------------
RCGCGPIO		 	EQU 	0x400FE608 ;x
RCGCI2C				EQU		0x400FE620 ;x
	
GPIOA_AFSEL			EQU		0x40004420 ;x
GPIOA_ODR			EQU		0x4000450C ;x
GPIOA_PCTL			EQU     0x4000452C ;x
GPIOA_PUR			EQU     0x40004510 ;x
GPIOA_DEN			EQU     0x4000451C ;x
GPIOA_DIR			EQU     0x40004400 ;x
	
I2C1_MCR 			EQU		0x40021020 ;x 
I2C1_MTPR 			EQU		0x4002100C ;x

		AREA    |.text|, READONLY, CODE, ALIGN=2
        THUMB
		
        EXPORT  init_i2c             	; Make available

init_i2c
 ;Enable and provide a clock to I2C module 0 in Run mode
            LDR     R1, =RCGCI2C
            LDR     R0, [R1]
            ORR     R0, #0x02
            STR     R0, [R1]
			
            NOP
            NOP
            NOP
            
            ; Initialize the clock for Port A.
            LDR     R1, =RCGCGPIO
            LDR     R0, [R1]
            ORR     R0, #0x01
            STR     R0, [R1]
			
            NOP
            NOP
            NOP     
       
         ; Alternate function for PA6-PA7.
            LDR     R1, =GPIOA_AFSEL
            LDR     R0, [R1]
            ORR     R0, #0xC0
            STR     R0, [R1]
            
            ; Enable the I2CSDA pin for open-drain operation
			
            LDR     R1, =GPIOA_ODR	
            MOV     R0, #0x80
            STR     R0, [R1]
            
            ; PA6-PA7=SCL-SDA
            LDR     R1, =GPIOA_PCTL
            LDR     R0, [R1]
            ORR     R0, #0x33000000;
            STR     R0, [R1]
			
			;Enable Digital Functions
            LDR     R1, =GPIOA_DEN
            LDR     R0, [R1]
            ORR     R0, #0xC0;
            STR     R0, [R1]
			
			;Set PUR
            LDR     R1, =GPIOA_PUR
            LDR     R0, [R1]
            ORR     R0, #0xC0;
            STR     R0, [R1]
			
			;Set Output Direction
            LDR     R1, =GPIOA_DIR
            LDR     R0, [R1]
            ORR     R0, #0xC0;
            STR     R0, [R1]
			
			; Initialize the I2C Master
            LDR     R1, =I2C1_MCR 	
            MOV     R0, #0x00000010
            STR     R0, [R1]
			
			; Set the desired SCL clock speed of 100Kbps
            LDR     R1, =I2C1_MTPR 	
            MOV     R0, #0x00000009
            STR     R0, [R1]
			
			BX LR
			
			ALIGN 
			END	