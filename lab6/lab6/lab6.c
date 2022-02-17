/*
 * lab5.c
 *
 * Created: 2019-01-13 17:21:02
 *  Author: Daniel Lone , Abdullahi Farah
 */ 
#include <stdio.h>
#include "hmi/hmi.h"
#include "numkey/numkey.h"
#include "regulator/regulator.h"
#include "common.h"
#include "lcd/lcd.h"
#include "delay/delay.h"
#include "motor/motor.h"

typedef enum
{
	motor_off,
	motor_on,
	motor_running
	} state_t;
	
	state_t current_state = motor_off;
	state_t next_state;
	
	uint32_t key;
	char temp_str[17];
	
int main(void)
{
	lcd_init();
	hmi_init();
	regulator_init();
	motor_init();

	lcd_set_cursor_pos(0, 0);
	output_msg("Welcome","",1);
	
	while (1)
	{	
		key = numkey_read();
		switch(current_state){
			case motor_off:
			sprintf(temp_str, "%u%c", getpotentval(), 0x25);
			output_msg("Motor off:", temp_str,0);
			motor_set_speed(0);
			if (key=='2' && getpotentval()==0)
			{
				next_state = motor_on;
			}else{
				next_state = motor_off;
			}
			break;
			
			case motor_on:
			sprintf(temp_str, "%u%c", getpotentval(), 0x25);
			output_msg("Motor on:", temp_str,0);
			motor_set_speed(getpotentval());
			if (getpotentval()>0)
			{
				next_state = motor_running;
			} else if (key == '1')
			{
				next_state = motor_off;
			}else{
				next_state = motor_on;
			}
			break;
			
			case motor_running:
			sprintf(temp_str, "%u%c", getpotentval(), 0x25);
			output_msg("Motor running:", temp_str,0);
			motor_set_speed(getpotentval());
			if (key == '1')
			{
				next_state = motor_off;
			} else{
				next_state = motor_running;
			}
			break;
		}
		current_state = next_state;	
	}
	
	
	
	
}