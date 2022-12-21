#include "driverlib.h"
#include "stdio.h"
#include "lab3.h"

/**
 * Turn LED1 on or off
 * Args:
 *  sPort (uint8_t): switch port
 *  sPin (uint16_t): switch pin
 *  LEDPort (uint8_t): LED port
 *  LEDPin (uint16_t): LED pin
 */
void turnOnOffLED1(uint8_t sPort, uint16_t sPin, uint8_t LEDPort, uint16_t LEDPin){
    uint8_t inputVal = MAP_GPIO_getInputPinValue(sPort, sPin);
    if(GPIO_INPUT_PIN_LOW == inputVal){
        MAP_GPIO_setOutputHighOnPin(LEDPort, LEDPin);
    } else if(GPIO_INPUT_PIN_HIGH == inputVal){
        MAP_GPIO_setOutputLowOnPin(LEDPort, LEDPin);
    }
}

/**
 * main.c
 */
void main(void)
{
    // Halt watchdog timer
    MAP_WDT_A_holdTimer();

    // Set LEDs at output pins and set their initial state to off
    // LED1
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P1, GPIO_PIN0);
    // LED2 (RED)
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN0);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN0);
    // LED2 (GREEN)
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN1);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN1);
    // LED2 (BLUE)
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN2);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);

    // Set switch 1 (S1) as input button (connected to P1.1)
    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P1, GPIO_PIN1);

    // Set switch 2 (S2) as input button (connected to P1.4)
    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P1, GPIO_PIN4);

    // Declare some parameters
    uint8_t rgb = 0, hold = 0;
    uint8_t led2switch;

    // Infinite loop
    while(1){
        // LED1
        turnOnOffLED1(GPIO_PORT_P1, GPIO_PIN1, GPIO_PORT_P1, GPIO_PIN0);

        // LED2
        led2switch = MAP_GPIO_getInputPinValue(GPIO_PORT_P1, GPIO_PIN4);

        if(GPIO_INPUT_PIN_LOW == led2switch){
            delay();
            // When switch2 is pressed
            if(rgb == 0){
                // Turn red on
                MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN0);
                hold = 1;
            } else if(rgb == 1){
                // Turn green on
                MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN1);
                hold = 2;
            } else if(rgb == 2){
                // Turn blue on
                MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);
                hold = 0;
            }
        } else if(GPIO_INPUT_PIN_HIGH == led2switch){
            delay();
            // When switch2 is released
            MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN0);
            MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN1);
            MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);
            rgb = hold;
        }
        // For debugging
        #ifdef DEBUG
        printf("%u \n", rgb);
        #endif
    }
}
