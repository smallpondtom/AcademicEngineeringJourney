/*
 * AE6705 LAB8 main.c file
 * Author: Tomoki Koike
 * Last Edited: 11/08/2021
 */
#include <assert.h>
#include <driverlib.h>
#include <msp.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define DEBUG
#define HZ 1875
#define VDV_min 2.46
#define VDV_max 5.14
#define PWM_PERIOD 3000


// ENUMS
typedef enum {CW = 0, CCW = 1} DIR;
// Rotation direction
// CW: clockwise
// CCW: counter clockwise


// Global variables
DIR dir = CW;
bool motor_on = false;
float V_var;
float dutyCycle = 0;

// STRUCTURES
const Timer_A_UpModeConfig timer_config = {
    // Timer A configurations
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_64,
    (uint16_t)(46857 / HZ),  // roll over frequency should be faster than PWM (Hz = 1875)
    TIMER_A_TAIE_INTERRUPT_DISABLE,
    TIMER_A_CCIE_CCR0_INTERRUPT_ENABLE,
    TIMER_A_DO_CLEAR
};

const Timer_A_PWMConfig pwmConfig_TA01 = {
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_1,
    PWM_PERIOD,  // 1 ms period (3000)
    TIMER_A_CAPTURECOMPARE_REGISTER_1,
    TIMER_A_OUTPUTMODE_RESET_SET,
    1,  // default of 0 duty cycle
};

const Timer_A_PWMConfig pwmConfig_TA02 = {
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_1,
    PWM_PERIOD,  // 1 ms period (3000)
    TIMER_A_CAPTURECOMPARE_REGISTER_2,
    TIMER_A_OUTPUTMODE_RESET_SET,
    1,  // default of 0 duty cycle
};

/*
 * Function: acquire_data
 * -----------------------
 * Acquire data from the temperature sensor using ADC
 *
 * Arguments: None
 * Returns: <float> Voltage value from voltage divider
 */
float acquire_data(){
    float res;
    // Obtaining sample from ADC with polling
    while(ADC14_isBusy());  // polling to check if ADC is busy
    res = (float)MAP_ADC14_getResult(ADC_MEM0);
    MAP_ADC14_toggleConversionTrigger();
    return res;
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
    unsigned int dcoFreq = 3E+6;                                   // variable for DCO frequency
    MAP_CS_setDCOFrequency(dcoFreq);                               // setting DCO frequency
    MAP_CS_initClockSignal(CS_SMCLK,
                           CS_DCOCLK_SELECT, CS_CLOCK_DIVIDER_1);
    MAP_Timer_A_configureUpMode(TIMER_A0_BASE, &timer_config);     // configure timer A
//    MAP_Interrupt_enableInterrupt(INT_TA0_0);
    MAP_Timer_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);

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
 * Function: setup_ADC
 * ----------------------
 * Configuration of the ADC.
 *
 * Arguments: None
 * Returns: None
 */
void setup_ADC(){
    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ADC -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAP_ADC14_enableModule();
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(
            GPIO_PORT_P6,
            GPIO_PIN1,
            GPIO_TERTIARY_MODULE_FUNCTION);               // set P6.1 (A14) for ADC
    MAP_ADC14_setResolution(ADC_10BIT);                   // setting resolution
    MAP_ADC14_initModule(ADC_CLOCKSOURCE_SMCLK,
                         ADC_PREDIVIDER_1,
                         ADC_DIVIDER_1, 0);
    MAP_ADC14_configureSingleSampleMode(ADC_MEM0, false);
    MAP_ADC14_configureConversionMemory(
            ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
            ADC_INPUT_A14, false);
    MAP_ADC14_enableSampleTimer(ADC_MANUAL_ITERATION);
    MAP_ADC14_enableConversion();
    MAP_ADC14_toggleConversionTrigger();
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
    setup_ADC();

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
void activate_motor(DIR dir){
    float bit_res;
    bit_res = acquire_data(); // 10bit value
    V_var = (float)(bit_res / 1024 * (VDV_max - VDV_min) + VDV_min);
    dutyCycle = (float)(bit_res / 1024);

    #ifdef DEBUG
    printf("10bit output: %f\r\n", bit_res);
    printf("ADC Voltage: %f\r\n", V_var);
    printf("duty cycle: %f\r\n", dutyCycle);
    #endif

    // Safety
    if(dutyCycle > 1){
        dutyCycle = 0.99;
    } else if(dutyCycle < 0){
        dutyCycle = 0;
    }

    if(dir == CW){
        TA0CCR1 = (uint16_t)(PWM_PERIOD * dutyCycle);
        TA0CCR2 = 0;
        if(TA0CCR1 > 3000){
            TA0CCR1 = 0;
        }
    } else if(dir == CCW){
        TA0CCR1 = 0;
        TA0CCR2 = (uint16_t)(PWM_PERIOD * dutyCycle);
        if(TA0CCR2 > 3000){
            TA0CCR2 = 0;
        }
    }
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

    while(1){
        S1_status = MAP_GPIO_getInputPinValue(GPIO_PORT_P1, GPIO_PIN1);  // switch 1
        S2_status = MAP_GPIO_getInputPinValue(GPIO_PORT_P1, GPIO_PIN4);  // switch 2

        // When the switch is pressed the motor is on
        // S1) clockwise rotation
        // S2) counter-clockwise rotation
        cond1 = GPIO_INPUT_PIN_LOW == S1_status;
        cond2 = GPIO_INPUT_PIN_LOW == S2_status;
        assert(!(cond1 && cond2));  // CANNOT HAVE BOTH BE ON!!

        #ifdef DEBUG
        printf("cond1: %d, cond2: %d\r\n", cond1, cond2);
        #endif


        if(cond1){
            // Time delay
            int n = 0;
            while(n<100000){
                n++;
            }
            if(!motor_on){
                MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P1, GPIO_PIN0);  // turn LED1 (red) on
                motor_on = true;
                dir = CW;
            } else{
                MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P1, GPIO_PIN0);  // turn LED1 (red) off
                motor_on = false;
                TA0CCR1 = 0;
                TA0CCR2 = 0;
            }
        } else if(cond2){
            // Time delay
            int n = 0;
            while(n<100000){
                n++;
            }
            if(!motor_on){
                MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);  // turn LED2 (blue) on
                motor_on = true;
                dir = CCW;
            } else{
                MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);  // turn LED2 (blue) off
                motor_on = false;
                TA0CCR1 = 0;
                TA0CCR2 = 0;
            }
        }

        // Activate motor if the conditions are set to true
        if(motor_on)
            activate_motor(dir);

        #ifdef DEBUG
        printf("TA0CCR1: %d, TA0CCR2: %d\r\n", TA0CCR1, TA0CCR2);
        #endif
    }
}
