;Register           EQU     Address
;----------------- -----   ------------
I2C1_MCR 				EQU		0x40021020
I2C1_MTPR 				EQU		0x4002100C
I2C1_MSA				EQU		0x40021000
I2C1_MDR 				EQU		0x40021008
I2C1_MCS 				EQU		0x40021004

			AREA    |.text|, READONLY, CODE, ALIGN=2
			THUMB
		
			EXPORT  writeToDac            	; Make available

writeToDac	PROC
	
			PUSH {LR}
			;Use R3 for storing data

			; Set the slave address to 0x62
idle        LDR     R1, =I2C1_MSA 	
            MOV     R0, #0xC4; 
            STR     R0, [R1]
			
			;Place data (byte) to be transmitted in the data register 
			;by writing the I2CMDR register with the desired data
			
			LDRB 	R3,[R4]
			LSR 	R3, #4				;Shift since we are only using 4 bits
			LDR     R1, =I2C1_MDR	
            STR     R3, [R1]
			
			
			;Initiate a single byte transmit of the data from Master to Slave
			LDR     R1, =I2C1_MCS ;
            MOV     R0, #0x03
            STR     R0, [R1]

			;check busy bit
read_again  LDR     R1, =I2C1_MCS
			LDR     R2, [R1]   
			AND     R2, #0x01
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
			;B       idle
			;ARBLST bit=1?
			
error		LDR     R2, [R1]   
			AND     R2, #0x10
			CMP     R2, #0	
			BNE     write_mcs
			;if error bit is zero
			
continue    LDRB 	R3,[R4],#1			; Post Increment 			
			LSL 	R3,#4				;Shift since we are only using 4 bits
			LDR     R1, =I2C1_MDR	
            STR     R3, [R1]
			;check index

			LDR     R1, =I2C1_MCS	
			MOV     R0, #0x01
            STR     R0, [R1]	
			
			;check busy bit
read_ag	    LDR     R1, =I2C1_MCS	
			LDR     R2, [R1]   
			AND     R2, #0x1
			CMP     R2, #0
			BNE     read_ag
			
			
			;check error bit  in the I2CMCS register to confirm the transmit was acknowledged
			LDR     R2, [R1]   
			AND     R2, #0x02
			CMP     R2, #0
			;BNE     idle
			
			;EOT? 
			
			LDR     R1, =I2C1_MCS	
			MOV     R0, #0x00
            STR     R0, [R1]
			
			LDR     R1, =I2C1_MCS	
			MOV     R0, #0x04
            STR     R0, [R1]			
		
			POP 	{LR}
			BX		LR	; Return
			
			ENDP	
			ALIGN                           
			END                             

