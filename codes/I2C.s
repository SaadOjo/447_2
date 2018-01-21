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
		
			EXPORT  writeToDac            	; Make available

writeToDac	PROC
			;Use R3 for storing data

			; Set the slave address to 0x60
 idle       LDR     R1, =I2CMSA 	
            MOV     R0, #0x60
            STR     R0, [R1]
			
			;Place data (byte) to be transmitted in the data register 
			;by writing the I2CMDR register with the desired data
			
			LDR R3,[R4],#1			; Post Increment
			LSR R3,#4				;Shift since we are only using 4 bits
			LDR     R1, =I2CMDR	
            STR     R3, [R1]
			
			
read_mcs	LDR     R1, =I2CMCS	
			;Wait until busbusy is cleared
			LDR     R2, [R1]     
			AND     R2, #0b01000000
			CMP     R2, #0
			BNE     read_mcs
			
			;Initiate a single byte transmit of the data from Master to Slave
			LDR     R1, =I2CMCS	
            MOV     R0, #0x00000003
            STR     R0, [R1]
			
			NOP
			NOP
			NOP
			B       read_again

ind_ne      MOV     R0, #0x01
			STR     R0, [R1]
			;check busy bit
read_again  LDR     R1, =I2CMCS	
			LDR     R2, [R1]   
			AND     R2, #0x1
			CMP     R2, #0
			BNE     read_again
			;check error bit  in the I2CMCS register to confirm the transmit was acknowledged
			LDR     R2, [R1]   
			AND     R2, #0x02
			CMP     R2, #0
			BNE     error
			BEQ     continue
			
write_mcs   MOV     R0, #0x04 
            STR     R0, [R1]
			B       idle
			;ARBLST bit=1?
error		LDR     R2, [R1]   
			AND     R2, #0x10
			CMP     R2, #0	
			BNE     write_mcs
			;if error bit is zero
			
continue    LDR R3,[R4],			; Don't need to Post Increment (Already Done Above)
			LSL R3,#4				;Shift since we are only using 4 bits
			LDR     R1, =I2CMDR	
            STR     R3, [R1]
			;check index
			
            BNE   ind_ne 

			LDR     R1, =I2CMCS	
			MOV     R0, #0x00000005
            STR     R0, [R1]	
			
			;check busy bit
read_ag	    LDR     R1, =I2CMCS	
			LDR     R2, [R1]   
			AND     R2, #0x1
			CMP     R2, #0
			BNE     read_ag
			
			;check error bit  in the I2CMCS register to confirm the transmit was acknowledged
			LDR     R2, [R1]   
			AND     R2, #0x02
			CMP     R2, #0
			BNE     idle
			
			;ERROR SERVICE????
			;B		idle

			BX		LR					    ; Return
			
			ENDP	
			ALIGN                           
			END                             

