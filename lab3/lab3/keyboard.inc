/*
 * keyboard.inc
 * This file contains subroutines for keyboard
 *
 * Author:	
 *
 * Date:	
 */
 map_table: .DB "147*2580369#"
;==============================================================================
; Subroutine
;==============================================================================
read_keyboard:
	LDI R18, 0		; reset counter
scan_key:
	MOV R19, R18	;kopierar innehållet av R18 till R19
	LSL R19			;förflyttar R19 till vänster
	LSL R19
	LSL R19
	LSL R19
	OUT PORTB, R19		; set column and row

	LDI R24, 80 
	RCALL delay_micros		

	SBIC PINE, 6    ;sätter PINE 6 till ingång
	RJMP return_key_val
	INC R18
	CPI R18, 12
	BRNE scan_key
	LDI R18, NO_KEY		; no key was pressed!
return_key_val:
	MOV RVAL, R18		;kopierar innehållet av R18 till RVAL
	RET
;==============================================================================
; Subroutine
;==============================================================================
keyboard_ascii:
	LDI ZH, high(map_table <<1)		;Initialize Z pointer
	LDI ZL, low(map_table <<1)
	ADD ZL, RVAL	;Add index
	LDI RVAL, 0x00
	ADC ZH, RVAL	;Add 0 to catch Carry, if present
	LPM RVAL, Z
	RET