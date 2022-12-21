/*
 * AE6705 LAB10 main.c file
 * Author: Tomoki Koike
 * Last Edited: 11/27/2021
 */
#include <assert.h>
#include <driverlib.h>
#include <msp.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define DEBUG
#define PWM_PERIOD 3000
#define TIMER_PERIOD 15000  // <- for 100 Hz we just need to change this value to 30000
#define Fdco 3E+6
#define UMAX 1              // maximum input/duty cycle
#define UMIN 0              // minimum input/duty cycle
#define TIME_STEP 0.01      // 100 Hz control frequency
#define DATALIMIT 10000     // data limit for data array


// Global variables
//float Kp = -0.00122960025714389;       // proportional gain
//float Ki = 0.0382450209614726;         // integral gain
//float Kd = 0.000132060829813156;       // derivative gain
//float N = 9.31086272048467;
float Kp = 0.00572311362145534;
float Ki = 0.120364997080663;
float Kd = -0.000158546538651373;
float N = 36.097373491324220;
int omega_d = 60;                     // desired motor velocity
bool HPF = false;


// Global Volatile variables
volatile uint16_t lastFallingEdge = 0;
volatile uint16_t fallingEdge = 0;
volatile bool motor_on = false;
volatile int ct = 0;                  // counter to output motor velocity at 1 Hz
volatile float dutyCycle = 0.0;
volatile float error = 0.0;
volatile float last_error = 0.0;
volatile float int_error = 0.0;
volatile float error_dot = 0.0;
volatile float last_dterm = 0.0;
volatile float dterm = 0.0;
volatile float iterm = 0.0;
volatile float temp_int_error = 0.0;
volatile float omega = 0.0;           // current motor velocity
volatile float u = 0.0;               // control output
volatile float dataArray[DATALIMIT] = {0};  // data array
volatile int idx = 0;
volatile bool dataflag = false;


// STRUCTURES
const Timer_A_UpModeConfig timer_config = {
    // Timer A0 and A2.1 configurations
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_1,
    TIMER_PERIOD,
    TIMER_A_TAIE_INTERRUPT_DISABLE,
    TIMER_A_CCIE_CCR0_INTERRUPT_DISABLE,
    TIMER_A_DO_CLEAR
};

const Timer_A_UpModeConfig timer_config_control = {
    // Timer A1.0 configurations
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_1,
    30000,  // 100 Hz for controller
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

const eUSCI_UART_Config UART0_config = {
    // Baud 57600
    EUSCI_A_UART_CLOCKSOURCE_SMCLK,  // clock source
    3,  // clock prescalar
    4,  // first mod reg
    2,  // second mod reg
    EUSCI_A_UART_NO_PARITY,  // parity
    EUSCI_A_UART_LSB_FIRST,  // msbor lsb first
    EUSCI_A_UART_ONE_STOP_BIT, // number of stop bits
    EUSCI_A_UART_MODE,  // uart mode
    EUSCI_A_UART_OVERSAMPLING_BAUDRATE_GENERATION,  // over sampling
};


/*
 * Function: signum
 * -----------------
 * Compute the signum from value.
 *
 * Arguments:
 *   [float] x: Value to evaluate.
 * Returns:
 *   [int] -1, 0, or 1.
 */
int signum(float x){
    int y = (x > 0) ? 1 : ((x < 0) ? -1 : 0);
    return y;
}


/*
 * Function: derivative_filter
 * ----------------------------
 * Compute output from derivative filter/high pass filter for
 * derivative control.
 *
 * Arguments:
 *   [float] de1: previous error_dot value
 *   [float] de2: current error_dot value
 *   [float] pre_out: previous output value from the filter
 * Returns:
 *   [float] filtered output value
 */
float derivative_filter(float de1, float de2, float pre_out){
    float alpha = (1/N) / ((1/N) + TIME_STEP);
    float yout = alpha * pre_out + alpha * (de2 - de1)*Kd*N;
    return yout;
}


/*
 * Function: PID_control
 * ----------------------
 * Compute the control output from motor velocity error with PID controller
 *
 * Arguments:
 *   [float] omega: Output motor velocity from plant.
 * Returns:
 *   [float] PID control output/duty cycle.
 */
float PID_control(float omega){
    // Compute error between desired and actual motor velocity
    error = omega_d - omega;

    // Compute derivative error
    // 1) derivative filter (HPF)
    // 2) first order finite differencing
    if(HPF){
        dterm = derivative_filter(last_error, error, last_dterm);
        last_dterm = dterm;  // update last error_dot
    } else{
        error_dot = (error - last_error) / TIME_STEP;
        dterm = Kd * error_dot;
    }
    last_error = error;  // Update last error

    // Compute temporary integral error
//    temp_int_error = int_error + TIME_STEP * error;
//    iterm = Ki * temp_int_error;

    iterm += Ki * TIME_STEP * error;

    // Compute the candidate PID control
    u = Kp * error + iterm + dterm;

    // Clamping anti-windup:
    // if control is saturated and error is the same sign as integrated
    // error, leave the integrated error unchanged.
//    if(((u > UMAX) || (u < UMIN)) && (signum(error) == signum(temp_int_error)))
//        int_error = int_error;
//    else
//        int_error = temp_int_error;
//
//    // Saturation b/w 0 ~ 100% duty cycle
//    u = (u > UMAX) ? UMAX : ((u < UMIN) ? UMIN : u);

    if(u > UMAX){
        iterm -= u - UMAX;
        u = UMAX;
    } else if(u < UMIN){
        iterm += UMIN - u;
        u = UMIN;
    }

    return u;
}


/*
 * Function: count2rpm
 * --------------------
 * Convert falling edge count to physical RPM value
 *
 * Arguments:
 *   [uint16_t] val1: Starting falling edge count.
 *   [uint16_t] val2: Ending falling edge count.
 * Returns:
 *   [float] Physical RPM value.
 */
float count2rpm(uint16_t val1, uint16_t val2){
    float rpm, period;
    val2 = (val2 < val1) ? (val2 + TIMER_PERIOD) : val2;
    period = (val2 - val1) * 3.3333e-7;
    rpm = (float)(60 / (360 * period));
    return rpm;
}


/*
 * Function: tx_data
 * ----------------------
 * Output motor velocity data to PuTTY
 *
 * Arguments: None
 * Returns: None
 */
void tx_data(float dataValue){
    int j;
    char data_string[10];
    // Transmit data with UART

    // Convert float to char array
    sprintf(data_string, "%.4f", dataValue);

    // Transmit
    for(j = 0; data_string[j] != '\0'; j++){
        // Polling to see that data transmission is ready
        while((UCA0IFG & 0x02) == 0){};
        // Transmit data each char at a time
        MAP_UART_transmitData(EUSCI_A0_BASE, data_string[j]);
    }
    // Break the line and start on new line
    while((UCA0IFG & 0x02) == 0){};
    MAP_UART_transmitData(EUSCI_A0_BASE, '\r');
    while((UCA0IFG & 0x02) == 0){};
    MAP_UART_transmitData(EUSCI_A0_BASE, '\n');
}


/*
 * Function: control_motor
 * --------------------------
 * Rotate the motor with a updated rate of duty cycle of the PWM signal
 *
 * Arguments: None
 * Returns: None
 */
void control_motor(){
    // Clockwise rotation
    TA0CCR1 = (uint16_t)(PWM_PERIOD * dutyCycle);
}


/*
 * Function <ISR>: TA1_0_IRQHandler
 * --------------------------
 * ISR for Timer A1.0. Update the dutyCycle with PID controller, and
 * output motor velocity onto console at 1 Hz.
 *
 * Arguments: None
 * Returns: None
 */
void TA1_0_IRQHandler(){
    if(motor_on){
        dutyCycle = PID_control(omega);
        if(ct >= 100){
            printf("%f\r\n", omega);  // print out motor velocity onto console at 1 Hz
            ct = 0;
        }
        ct++;
    } else{
        ct = 0;
    }

    // Clear interrupt flag (VERY IMPORTANT)
    MAP_Timer_A_clearCaptureCompareInterrupt(TIMER_A1_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_0);
}


/*
 * Function <ISR>: TA2_N_IRQHandler
 * ---------------------------------
 * ISR of Timer A2.1 to detect falling edge of motor encoder signal.
 *
 * Arguments: None
 * Returns: None
 */
void TA2_N_IRQHandler(){
    // Obtain count
    fallingEdge = Timer_A_getCaptureCompareCount(TIMER_A2_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_1);

    // Convert to RPM
    omega = count2rpm(lastFallingEdge, fallingEdge);

    // Store value into array
    dataArray[idx] = omega;
    idx++;

    lastFallingEdge = fallingEdge;

    // Clear interrupt flag (VERY IMPORTANT)
    MAP_Timer_A_clearCaptureCompareInterrupt(TIMER_A2_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_1);
}


/*
 * Function: final_data_output
 * ----------------------------
 * Output the final data points (RPM) collected at 100 Hz
 * to PuTTY.
 *
 * Arguments: None
 * Returns: None
 */
void final_data_output(){
    int i;
    // Loop through data array and output on PuTTY
    printf("\r\n");
    for(i = 0; i < idx; i++){
        // tx_data(dataArray[i]);
        printf("%f\r\n", dataArray[i]);
        dataArray[i] = 0;  // reset data array at index i
    }
    idx = 0;
    dataflag = false;
}


/*
 * Function: setup_GPIO
 * ----------------------
 * Configure of the GPIO.
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
 * Configure clock and Timer A0.1, A0.1, A1.0, and A2.1
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
    MAP_Timer_A_configureUpMode(TIMER_A0_BASE, &timer_config);          // configure timer A0
    MAP_Timer_A_configureUpMode(TIMER_A1_BASE, &timer_config_control);  // configure timer A1
    MAP_Timer_A_configureUpMode(TIMER_A2_BASE, &timer_config);          // configure timer A2

    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(
            GPIO_PORT_P5,
            GPIO_PIN6,
            GPIO_PRIMARY_MODULE_FUNCTION
    ); // enable the GPIO PIN as Timer A2.1

    MAP_Timer_A_initCapture(TIMER_A2_BASE, &captureConfig);     // configure timer A2 Capture mode
    MAP_Timer_A_enableCaptureCompareInterrupt(TIMER_A2_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_1);
    MAP_Interrupt_enableInterrupt(INT_TA2_N);

    MAP_GPIO_setAsPeripheralModuleFunctionOutputPin(
            GPIO_PORT_P8,
            GPIO_PIN0,
            GPIO_SECONDARY_MODULE_FUNCTION
    ); // enable the GPIO PIN8.0 as Timer A1.0

    MAP_Interrupt_enableInterrupt(INT_TA1_0);  // configure timer A1.0 interrupt for control

    MAP_Timer_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);
    MAP_Timer_A_startCounter(TIMER_A1_BASE, TIMER_A_UP_MODE);
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
 * Function: setup_UART
 * ---------------------
 * Configure UART.
 *
 * Arguments: None
 * Returns: None
 */
void setup_UART(){
    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- UART -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(
            GPIO_PORT_P1,
            GPIO_PIN3,
            GPIO_PRIMARY_MODULE_FUNCTION);              // Make P1.3 UART TX
    MAP_UART_initModule(EUSCI_A0_BASE, &UART0_config);  // initialize UART 0
    MAP_UART_enableModule(EUSCI_A0_BASE);
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
    MAP_Interrupt_disableMaster();  // disable all interrupts
    setup_GPIO();
    setup_timer();
    setup_UART();
    MAP_Interrupt_enableMaster();  // enable all interrupts
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

        // When switch S1 is pressed the motor is on
        cond1 = GPIO_INPUT_PIN_LOW == S1_status;
        // When switch S2 is pressed the motor is turned off
        cond2 = GPIO_INPUT_PIN_LOW == S2_status;
        assert(!(cond1 && cond2));  // CANNOT HAVE BOTH BE ON!!

        if(cond1){
            // Time delay
            int n = 0;
            while(n<50000){
                n++;
            }
            MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P1, GPIO_PIN0);
            motor_on = true;
            dataflag = true;
        }
        if(cond2){
            // Time delay
            int n = 0;
            while(n<500){
                n++;
            }
            motor_on = false;
            TA0CCR1 = 0;
        }

        if(motor_on) control_motor();  // control motor with duty cycle and PID controller
        else if(dataflag) final_data_output();  // output collected data for performance analysis
    }
}
