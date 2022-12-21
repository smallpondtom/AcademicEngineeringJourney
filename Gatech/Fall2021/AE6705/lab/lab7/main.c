/*
 * AE6705 LAB7 main.c file
 * Author: Tomoki Koike
 * Last Edited: 10/23/2021
 */
#include <assert.h>
#include <driverlib.h>
#include <msp.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define DEBUG
#define HZ 20 // operation Hertz

// ENUMS
enum DIR {CW = 0, CCW = 1};
// Rotation direction
// CW: clockwise
// CCW: counter clockwise


// Global variables
enum DIR dir = CW;
bool motor_on = false;
uint16_t energize_routine[4] = {
    GPIO_PIN4,
    GPIO_PIN5,
    GPIO_PIN6,
    GPIO_PIN7
};  // ordered in the CCW direction

// Volatile global variables
volatile int i = 0, j = 0;

// STRUCTURES
const Timer_A_UpModeConfig timer_config = {
    // Timer A configurations
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_64,
    (uint16_t)(46875 / HZ),  // roll over frequency
    TIMER_A_TAIE_INTERRUPT_DISABLE,
    TIMER_A_CCIE_CCR0_INTERRUPT_ENABLE,
    TIMER_A_DO_CLEAR
};


/*
 * Function: TA0_0_IRQHandler
 * --------------------------
 * ISR for Timer A. Turns the stepper motor.
 *
 * Arguments: None
 * Returns: None
 */
void TA0_0_IRQHandler(){
    if(motor_on){
        j = dir == CCW ? i : (4 - i) % 4;
            MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, energize_routine[j]);
            MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2,
                                       energize_routine[(j+1)%4] |
                                       energize_routine[(j+2)%4] |
                                       energize_routine[(j+3)%4]);
        i = (i + 1) % 4;
    }

    // Clear interrupt flag (VERY IMPORTANT)
    MAP_Timer_A_clearCaptureCompareInterrupt(TIMER_A0_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_0);
}


/*
 * Function: critical_section_config
 * ----------------------------------
 * Configures the critical section for the MSP432
 *
 * Arguments: None
 * Returns: None
 */
void critical_section_config(){
    // <<<<<<<<<<<<<<<<<<<<<<<<< START CRITICAL SECTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    MAP_Interrupt_disableMaster();  // disable all interrupts

    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- GPIO -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN4);     // P2.4
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN4);
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN5);     // P2.5
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN5);
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN6);     // P2.6
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN6);
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN7);     // P2.7
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN7);

    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- LEDs -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);     // set LED1 as output pin
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P1, GPIO_PIN0);  // set initial state to off
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN2);     // set LED2 (blue) as output pin
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);  // set initial state to off

    // Set switch 1 (S1) as input button (connected to P1.1)
    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P1, GPIO_PIN1);
    // Set switch 2 (S2) as input button (connected to P1.4)
    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P1, GPIO_PIN4);

    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- CLOCK -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    unsigned int dcoFreq = 3E+6;                                   // variable for DCO frequency
    MAP_CS_setDCOFrequency(dcoFreq);                               // setting DCO frequency
    MAP_CS_initClockSignal(CS_SMCLK,
                           CS_DCOCLK_SELECT, CS_CLOCK_DIVIDER_1);
    MAP_Timer_A_configureUpMode(TIMER_A0_BASE, &timer_config);     // configure timer A
    MAP_Interrupt_enableInterrupt(INT_TA0_0);
    MAP_Timer_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);

    MAP_Interrupt_enableMaster();  // enable all interrupts

    // <<<<<<<<<<<<<<<<<<<<<<<<<<< END CRITICAL SECTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
}


/**
 * main.c
 */
void main(void){
    MAP_WDT_A_holdTimer();  // halt watch-dog timer
    critical_section_config();  // configuring the critical section

    uint8_t S1_status, S2_status;    // variables for switch status

    while(1){
        S1_status = MAP_GPIO_getInputPinValue(GPIO_PORT_P1, GPIO_PIN1);  // switch 1
        S2_status = MAP_GPIO_getInputPinValue(GPIO_PORT_P1, GPIO_PIN4);  // switch 2

        // When the switch is pressed the motor is on
        // S1) clockwise rotation
        // S2) counter-clockwise rotation
        if(GPIO_INPUT_PIN_LOW == S1_status){
            MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P1, GPIO_PIN0);  // turn LED1 (red) on
            motor_on = true;
            dir = CW;
        } else if(GPIO_INPUT_PIN_LOW == S2_status){
            MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);  // turn LED2 (blue) on
            motor_on = true;
            dir = CCW;
        } else {
            MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P1, GPIO_PIN0);  // turn LED1 (red) off
            MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);  // turn LED2 (blue) off
            motor_on = false;
        }

    }
}

