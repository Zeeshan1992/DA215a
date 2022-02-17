/*
 * motor.c
 *
 * Created: 2019-09-16 12:17:55
 *  Author: Daniel Lone, abdullahi Farah
 */ 

#include <avr/io.h>
#include <inttypes.h>
#include "motor.h"
#include "../common.h"


/*
	Use the timers found on the AtMega32U4
*/
uint16_t motorspeed;

void motor_init(void){
	DDRC |= (1 << PORTC6);  // set PC6 (digital pin 5) as output
	TCCR3A |= (1<<COM3A1);  // Set OC3A (PC6) to be cleared on Compare Match 
	                        //(Channel A)	
	TCCR3A |= (1<<WGM32)|(1<<WGM30);  // Waveform Generation Mode 5, Fast PWM (8-bit)
//	TCCR3B |= 0;
	
	TCCR3B |= (1<<CS31)|(1<<CS30);          // Timer Clock, 16/64 MHz = 1/4 MHz
}

void motor_set_speed(uint8_t speed){
	 motorspeed = speed * 255;

	motorspeed = motorspeed / 100;
	OCR3A = motorspeed;
}

uint16_t getSpeed()
{
	return motorspeed;
}
