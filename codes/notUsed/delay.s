;label			directive			value			comment
				AREA  delayRoutine,CODE,READONLY
				THUMB	
				EXPORT	DELAY100

DELAY100		PUSH{R0}
				LDR R0,=0x74240;
loop			SUBS R0,#1;
				BNE	loop
				
				POP{R0}
				BX LR
				ALIGN	
				END
					