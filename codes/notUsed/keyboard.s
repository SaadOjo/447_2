
;label			directive			value			comment
				AREA  main,CODE,READONLY
				THUMB	
				EXTERN 	portInitialize
				EXTERN 	readKey
				EXTERN 	OutChar
				EXTERN  DELAY100	
				EXPORT	__main
				ENTRY
				
__main		 
start			BL portInitialize				;Initialize the ports for inputs
				MOV R3,#0	;current Val
				MOV R4,#0   ;Old Val
				
readLoop		BL readKey						;Take first Reading 
				MOV R2,R3
				BL DELAY100					
				BL readKey						;Take another reading after sometime
				CMP R2,R3
				BNE readLoop 					;Ignore if readings are not the same
				
				CBZ R3,checkOld					;IF R3 = 0		
return			MOV R4,R3						; Old value = R3 

				B readLoop			
				
				B start
				
checkOld     	CBZ R4, toRet					;If R4 = 0, do nothing
dispChar		MOV R5,R4
				ADD R5,#48						;Convert to ASCII
				BL OutChar
toRet			B	return
				
				ALIGN	
				END
					