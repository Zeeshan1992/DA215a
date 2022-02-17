;
; lab3.asm
;
; Created: 2017-12-07 12:49:01
; Author : Daniel Lone, Abdullahi Farah
;


; Replace with your application code
 
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
	.INCLUDE "keyboard.inc"
	.INCLUDE "delay.inc"
	.INCLUDE "lcd.inc"
	.INCLUDE "tarning.inc"
	.INCLUDE "stat.data.inc"
	.INCLUDE "stats.inc"
	.INCLUDE "monitor.inc"
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
	CALL init_stat
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
; Main part of program
;==============================================================================
main: 	 

	PRINTSTRING Str_1

	RCALL delay_1_s
	RCALL lcd_clear_display
	RCALL delay_ms
	PRINTSTRING Str_2
loop:
	CALL read_keyboard      ;kallar subrutinen read_keyboard
	LDI R25, 0x04
	CP R25, RVAL
	BREQ two

	CALL read_keyboard
	LDI R25, 0x08
	CP R25, RVAL
	BREQ three

	CALL read_keyboard
	LDI R25, 0x06
	CP R25, RVAL
	BREQ eight

	CALL read_keyboard
	LDI R25, 0x0a
	CP R25, RVAL
	BREQ nine
	
	
	
	RJMP loop

two:
	RCALL lcd_clear_display
	RCALL delay_ms
	PRINTSTRING Str_3
	RCALL roll_dice
	MOV R24, R16
	RCALL store_stat
	RCALL lcd_clear_display
	RCALL delay_ms
	PRINTSTRING Str_4
	MOV R24, R16
	SUBI R24, -48
	RCALL lcd_write_chr
	RCALL delay_1_s
	RJMP CONT

three:
	RCALL showstat
	RJMP CONT

eight:
	RCALL clearstat
	RJMP CONT

nine:
	RCALL monitor
	RJMP CONT
	
CONT:
	RCALL lcd_clear_display
	RCALL delay_ms
	PRINTSTRING Str_2
	RJMP LOOP