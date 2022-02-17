/*
 * lab1.asm
 *
 * This is a very simple demo program made for the course DA215A at
 * Malmö University. The purpose of this program is:
 *	-	To test if a program can be transferred to the ATmega32U4
 *		microcontroller.
 *	-	To provide a base for further programming in "Laboration 1".
 *
 * After a successful transfer of the program, while the program is
 * running, the embedded LED on the Arduino board should be turned on.
 * The LED is connected to the D13 pin (PORTC, bit 7).
 *
 * Author:	Mathias Beckius
 *
 * Date:	2014-11-05
 */

;==============================================================================
; Definitions of registers, etc. ("constants")
;==============================================================================
	.EQU RESET		= 0x0000 ;Point to the start of the memory
	.EQU PM_START	= 0x0056 ;Memory range 0000-0055 is reserved for IRQ-vector tables
	.DEF TEMP       = R16
	.DEF RVAL       = R24
	.DEF NO_KEY     = 0x0F

;==============================================================================
; Start of program
;==============================================================================
	.CSEG
	.ORG RESET
	RJMP init

	.ORG PM_START
;==============================================================================
; Basic initializations of stack pointer, I/O pins, etc.
;==============================================================================
init:
	; Set stack pointer to point at the end of RAM.
	LDI R16, LOW(RAMEND)
	OUT SPL, R16
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	; Initialize pins
	CALL init_pins
	; Jump to main part of program
	RJMP main

;==============================================================================
; Initialize I/O pins
;==============================================================================
init_pins:
	LDI TEMP, 0xF0 ;Load Register 16 directly
	OUT DDRB, TEMP ;RB0–RB3: ingångar, RB4–RB7: utgångar
	OUT DDRF, Temp ;Set DDRF to in
	RET


;==============================================================================
;Subroutine
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
	NOP			; a minimum of 2 NOP's is necessary!
	NOP			;paus
	NOP			
	NOP			
	NOP			
	NOP			
	NOP			
	NOP			;paus
	NOP			
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP	
	NOP
	NOP	
	NOP			; a minimum of 2 NOP's is necessary!
	NOP			;paus
	NOP			
	NOP			
	NOP			
	NOP			
	NOP			
	NOP			;paus
	NOP			
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP	
	NOP
	NOP		;paus

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
; Main part of program
;==============================================================================
main:
	RCALL read_keyboard  ;kallar subrutinen 
	OUT PORTF, RVAL
	NOP
	NOP