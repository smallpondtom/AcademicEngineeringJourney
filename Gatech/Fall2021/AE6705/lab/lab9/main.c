/*
 * AE6705 LAB9 main.c file
 * Author: Tomoki Koike
 * Last Edited: 11/16/2021
 */
#include <assert.h>
#include <driverlib.h>
#include <msp.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define DEBUG
#define PWM_PERIOD 3000
#define TIMER_PERIOD 15000
#define DATALIMIT 5000
#define Fdco 3E+6


// ENUMS
typedef enum {CW = 0, CCW = 1} DIR;
// Rotation direction
// CW: clockwise
// CCW: counter clockwise


// Global variables
DIR dir = CW;
float dutyCycle = 0;

// Global Volatile variables
volatile uint16_t fallingEdge = 0;
volatile int dataStorage[DATALIMIT];
volatile int idx = 0;
volatile bool dataFlag = false;
volatile bool motor_on = false;


// STRUCTURES
const Timer_A_UpModeConfig timer_config = {
    // Timer A configurations
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_1,
    (uint16_t)(TIMER_PERIOD),
    TIMER_A_TAIE_INTERRUPT_DISABLE,
    TIMER_A_CCIE_CCR0_INTERRUPT_DISABLE,
    TIMER_A_DO_CLEAR
};

const Timer_A_PWMConfig pwmConfig_TA01 = {
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_1,
    PWM_PERIOD,  // 1 ms period (3000)
    TIMER_A_CAPTURECOMPARE_REGISTER_1,
    TIMER_A_OUTPUTMODE_RESET_SET,
    0,  // default of 0 duty cycle
};

const Timer_A_PWMConfig pwmConfig_TA02 = {
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_1,
    PWM_PERIOD,  // 1 ms period (3000)
    TIMER_A_CAPTURECOMPARE_REGISTER_2,
    TIMER_A_OUTPUTMODE_RESET_SET,
    0,  // default of 0 duty cycle
};

const Timer_A_CaptureModeConfig captureConfig = {
    TIMER_A_CAPTURECOMPARE_REGISTER_1,
    TIMER_A_CAPTUREMODE_FALLING_EDGE,
    TIMER_A_CAPTURE_INPUTSELECT_CCIxA,
    TIMER_A_CAPTURE_SYNCHRONOUS,
    TIMER_A_CAPTURECOMPARE_INTERRUPT_ENABLE,
    TIMER_A_OUTPUTMODE_OUTBITVALUE
};



void TA2_N_IRQHandler(){
    MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P2, GPIO_PIN2);
    // Clear interrupt flag (VERY IMPORTANT)
    MAP_Timer_A_clearCaptureCompareInterrupt(TIMER_A2_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_1);

    // Obtain count
    fallingEdge = Timer_A_getCaptureCompareCount(TIMER_A2_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_1);

    // Store data in array
    dataStorage[idx] = (int)fallingEdge;
    dataFlag = true;

    idx++;

    if(idx > 300){
        motor_on = !motor_on;
        TA0CCR1 = 0;
        TA0CCR2 = 0;
    }
}


/*
 * Function: setup_GPIO
 * ----------------------
 * Configuration of the GPIO.
 *
 * Arguments: None
 * Returns: None
 */
void setup_GPIO(){
    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- LEDs -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);     // set LED1 as output pin
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P1, GPIO_PIN0);  // set initial state to off
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN2);     // set LED2 (blue) as output pin
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);  // set initial state to off

    // Set switch 1 (S1) as input button (connected to P1.1)
    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P1, GPIO_PIN1);
    // Set switch 2 (S2) as input button (connected to P1.4)
    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P1, GPIO_PIN4);
}


/*
 * Function: setup_timer
 * ----------------------
 * Configuration of the timer.
 *
 * Arguments: None
 * Returns: None
 */
void setup_timer(){
    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- CLOCK -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    unsigned int dcoFreq = Fdco;                                   // variable for DCO frequency
    MAP_CS_setDCOFrequency(dcoFreq);                               // setting DCO frequency
    MAP_CS_initClockSignal(CS_SMCLK,
                           CS_DCOCLK_SELECT, CS_CLOCK_DIVIDER_1);

    // TIMER 0 and TIMER 2 (! Both should be configured correctly)
    // One for PWM and one for capture mode
    MAP_Timer_A_configureUpMode(TIMER_A0_BASE, &timer_config);     // configure timer A0
    MAP_Timer_A_configureUpMode(TIMER_A2_BASE, &timer_config);     // configure timer A2

    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(
            GPIO_PORT_P5,
            GPIO_PIN6,
            GPIO_PRIMARY_MODULE_FUNCTION
    ); // enable the GPIO PIN as Timer A2.1

    MAP_Timer_A_initCapture(TIMER_A2_BASE, &captureConfig);     // configure timer A2 Capture mode
    MAP_Timer_A_enableCaptureCompareInterrupt(TIMER_A2_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_1);
    MAP_Interrupt_enableInterrupt(INT_TA2_N);

    MAP_Timer_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);
    MAP_Timer_A_startCounter(TIMER_A2_BASE, TIMER_A_UP_MODE);

    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- PWM -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAP_GPIO_setAsPeripheralModuleFunctionOutputPin(
            GPIO_PORT_P2,
            GPIO_PIN4,
            GPIO_PRIMARY_MODULE_FUNCTION
    ); // enable the GPIO PIN as PWM generator
    MAP_GPIO_setAsPeripheralModuleFunctionOutputPin(
            GPIO_PORT_P2,
            GPIO_PIN5,
            GPIO_PRIMARY_MODULE_FUNCTION
    ); // enable the GPIO PIN as PWM generator
    MAP_Timer_A_generatePWM(TIMER_A0_BASE, &pwmConfig_TA01);
    MAP_Timer_A_generatePWM(TIMER_A0_BASE, &pwmConfig_TA02);
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

    setup_GPIO();
    setup_timer();

    MAP_Interrupt_enableMaster();  // enable all interrupts

    // <<<<<<<<<<<<<<<<<<<<<<<<<<< END CRITICAL SECTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
}

/*
 * Function: activate_motor
 * --------------------------
 * Rotate the motor with a updated rate of duty cycle of the PWM signal
 *
 * Arguments:
 *     <DIR> dir: clock wise or counter clockwise rotation direction
 * Returns: None
 */
void activate_motor(){
    // Safety
    if(dutyCycle > 1){
        dutyCycle = 0.99;
    } else if(dutyCycle < 0){
        dutyCycle = 0;
    }

    // Clockwise rotation
    TA0CCR1 = (uint16_t)(PWM_PERIOD * dutyCycle);
    TA0CCR2 = 0;
    if(TA0CCR1 > 3000){
        TA0CCR1 = 0;
    }
    if(idx > 300)
        motor_on = !motor_on;
}


float count2rpm(uint16_t val1, uint16_t val2){
    float rpm, period;
    val2 = (val2 < val1) ? (val2 + TIMER_PERIOD) : val2;
    period = (val2 - val1) * 3.3333e-7;
    rpm = (float)(60 / (360 * period));
    return rpm;
}


/**
 * main.c
 */
void main(void){
    MAP_WDT_A_holdTimer();  // halt watch-dog timer
    critical_section_config();  // configuring the critical section

    TA0CCR1 = 0;
    TA0CCR2 = 0;

    uint8_t S1_status, S2_status;    // variables for switch status
    bool cond1, cond2;
    int i;

    while(1){
        S1_status = MAP_GPIO_getInputPinValue(GPIO_PORT_P1, GPIO_PIN1);  // switch 1
        S2_status = MAP_GPIO_getInputPinValue(GPIO_PORT_P1, GPIO_PIN4);  // switch 2

        // When the switch is pressed the motor is on
        // S1) clockwise rotation
        // S2) counter-clockwise rotation
        cond1 = GPIO_INPUT_PIN_LOW == S1_status;
        cond2 = GPIO_INPUT_PIN_LOW == S2_status;
        assert(!(cond1 && cond2));  // CANNOT HAVE BOTH BE ON!!

        if(cond1){
            // Time delay
            int n = 0;
            while(n<50000){
                n++;
            }
            MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P1, GPIO_PIN0);
            dutyCycle += 0.20;
            if(dutyCycle > 1.0)
                dutyCycle = 0;

            #ifdef DEBUG
            printf("dutyCycle: %f\r\n", dutyCycle);
            #endif

        }

        if(cond2){
            // Time delay
            int n = 0;
            while(n<50000){
                n++;
            }
            motor_on = !motor_on;
        }

        // Activate motor if the conditions are set to true
        if(motor_on){
            activate_motor();
        } else{
            TA0CCR1 = 0;
            TA0CCR2 = 0;
        }

        // Print out results onto the console
        int zero_counter = 0;
        if(!motor_on && dataFlag){
            printf("\r\nRPM values for %f percent duty cycle...\r\n", dutyCycle);
            for(i = 0; i < idx; i++){
                if(dataStorage[i] != 0){
                    printf("RPM[%d]: %f\r\n", i, count2rpm(dataStorage[i], dataStorage[i+1]));
                    dataStorage[i] = 0;  // reset data array
                } else{
                    zero_counter++;
                }

                if(zero_counter == 10)
                    break;
            }
            idx = 0;
            dataFlag = false;
        }
    }
}
