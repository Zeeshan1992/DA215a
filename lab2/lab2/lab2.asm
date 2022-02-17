/*
 * lab2.asm
 * Authors: Abdullahi Farah Hussein	
 *			Daniel Lone
 * Date:	2017-11-28
 */ 
 
;==============================================================================
; Definitions of registers, etc. ("constants")
;==============================================================================
	.EQU RESET		= 0x0000
	.EQU PM_START	= 0x0056
	.DEF TEMP		= R16        ;definerar TEMP som R16
	.DEF RVAL       = R24		 ;definerar RVAL som R24	
	.EQU NO_KEY     = 0x0F		 ;tillsätter värdet 0x0F till NO_KEY


;==============================================================================
; Start of program
;==============================================================================
	.CSEG
	.ORG RESET		
	RJMP init
	.ORG PM_START
	.INCLUDE "delay.inc"
	.INCLUDE "lcd.inc"
;==============================================================================
; Basic initializations of stack pointer, I/O pins, etc.
;==============================================================================
init:
	; Set stack pointer to point at the end of RAM.
	LDI TEMP, LOW(RAMEND)
	OUT SPL, TEMP
	LDI TEMP, HIGH(RAMEND)
	OUT SPH, TEMP
	; Initialize pins
	CALL init_pins				;anropar subrutin: init_pins
	CALL lcd_init
	; Jump to main part of program
	RJMP main

;==============================================================================
; Initialize I/O pins
;==============================================================================
init_pins:	
	LDI TEMP, 0xF0        ;sätter TEMP med 0b11110000 
	OUT DDRB, TEMP		  ;RB0–RB3: ingångar, RB4–RB7: utgångar
	OUT DDRF, TEMP		  ;RF0-RF7 blir ingångar
	CBI DDRE, 6           ;bit PE6 = 0
	SBI DDRD, 6
	SBI DDRD, 7

	RET					  ;återvänder till address där subrutin anropades
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

	LDI R24, 'K'
	RCALL lcd_write_chr
	LDI R24, 'E'
	RCALL lcd_write_chr
	LDI R24, 'Y'
	RCALL lcd_write_chr

	LDI R24, 0xC0 
	RCALL lcd_write_instr

	
loop:
	CALL read_keyboard      ;kallar subrutinen read_keyboard
	
	CP R25, RVAL
	BREQ loop
	MOV R25, RVAL
	CPI  RVAL, NO_KEY
	BREQ loop
	
	ORI RVAL, 48
	RCALL lcd_write_chr
	LDI R24, 500
	RCALL delay_ms	
	
	
	RJMP loop
	