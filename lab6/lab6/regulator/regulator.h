/*
 * temp.h
 *
 * This is the device driver for the LM35 temperature sensor.
 *
 * Author:	Mathias Beckius
 *
 * Date:	2014-12-07
 */ 

#ifndef TEMP_H_
#define TEMP_H_

#include <inttypes.h>

void regulator_init(void);
uint8_t getpotentval(void);
uint16_t getpot(void);

#endif /* TEMP_H_ */