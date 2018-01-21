;LABEL		DIRECTIVE	VALUE		COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
				
VoltageMsg			    DCB     	"The Voltage is: "
						DCB     	0x04
						
Voltage					DCB     	" V"
						DCB			0x0D
						DCB     	0x04
						
;***************************************************************

BUFFER_ADDR		EQU		0x20000000;
	
;label			directive			value			comment
				AREA  outVoltRoutine,CODE,READONLY
				THUMB	
				EXTERN OutStr	
				EXTERN CONVRT_HEX_TO_VOLT	
				EXPORT	outVolt

outVolt			PUSH{LR,R5}
				
				LDR	R5,=VoltageMsg;
				BL	OutStr;
				
				LDR R5, =BUFFER_ADDR
				BL CONVRT_HEX_TO_VOLT
				BL	OutStr
				
				LDR	R5,=Voltage;
				BL	OutStr;
				
				POP{LR,R5}
				
				BX LR
				ALIGN	
				END
					