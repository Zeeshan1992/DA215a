.DSEG  ; The following applies to the RAM: 
.ORG  0x100	
Str: .BYTE 7	
.CSEG 



store_stat: ;<skriv kod för rutinen>
	LDI XH, HIGH(Str)
	LDI XL, LOW(Str)
	ADD XL, R24
	LD R25, X
	INC R25
	ST X, R25
	LDS R25, Str
	INC R25
	STS Str, R25
	RET
get_stat: ;<skriv kod för rutinen>
	LDI XH, HIGH(Str)
	LDI XL, LOW(Str)
	ADD XL, R24
	LD R24, X
	RET
clear_stat: ;<skriv kod för rutinen> 
	LDI R25, 0
	STS Str, R25
	STS Str+1, R25
	STS Str+2, R25
	STS Str+3, R25
	STS Str+4, R25
	STS Str+5, R25
	STS Str+6, R25
	RET 