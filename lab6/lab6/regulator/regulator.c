/*
 * temp.c
 *
 * This is the device driver for the LM35 temperature sensor.
 *
 * Author:	Mathias Beckius, Daniel Lone
 *
 * Date:	2014-12-07
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "regulator.h"

/*	For storage of ADC value from temperature sensor.
	Initial value is good to use before A/D conversion is configured!	*/
static volatile uint16_t adc = 221;


/*
 * Interrupt Service Routine for the ADC.
 * The ISR will execute when a A/D conversion is complete.
 */
ISR(ADC_vect)
{
	// read ADC value
			unsigned char low,high;
			low = ADCL;
			high = ADCH; 		// UPPGIFT: Läs in ADC-värdet. Börja med att läsa av det "låga" registret, därefter det "höga" registret!
			adc = (high<<8) + low;
}

/*
 * Initialize the ADC and ISR.
 */
void regulator_init(void)
{
	// UPPGIFT: konfigurera ADC-enheten genom ställa in ADMUX och ADCSRA enligt kommentarerna nedanför!
	ADMUX |= (1<<REFS0);		// set reference voltage (internal 5V)
	ADMUX |= 0b00000001;					// select diff.amp 10x on ADC0 & ADC1
								// right adjustment of ADC value
	
	ADCSRA |= (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0) ;				// prescaler 128
	ADCSRA |= 1<<ADATE;		// enable Auto Trigger
	ADCSRA |= 1<<ADIE;		// enable Interrupt
	ADCSRA |= 1<<ADEN;		// enable ADC

	// disable digital input on ADC0 and ADC1
	DIDR0 = 3;
		
	// disable USB controller (to make interrupts possible)
	USBCON = 0;	
	// enable global interrupts
	sei();

	// start initial conversion
	ADCSRA |= (1<<ADSC);	// UPPGIFT: gör så att den initiala A/D-omvandlingen sker
}


uint8_t getpotentval(void)
{
	uint16_t temp = adc; //adc returns interval between 0 - 1023
	temp = (temp - 23) / 10;
	if (temp <= 100 && temp >= 0)
	{
		return temp;
	}
	return 0;
}

uint16_t getpot(void)
{
	return adc;
}



