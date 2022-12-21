/*
 * AE6705 LAB6 main.c file
 * Author: Tomoki Koike
 * Last Edited: 10/23/2021
 */
#include <assert.h>
#include <driverlib.h>
#include <msp.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define FLASH_ADDR 0x1FE000  // Macro for flash address
#define DEBUG
#define DATASIZE 30          // measurement data size


// STRUCTURES
const eUSCI_UART_ConfigV1 UART0_config = {
    // Baud rate of 57600
    EUSCI_A_UART_CLOCKSOURCE_SMCLK,                 // clock source
    3,                                              // clock prescalar
    4,                                              // first mod reg
    2,                                              // second mod reg
    EUSCI_A_UART_NO_PARITY,                         // parity settings
    EUSCI_A_UART_LSB_FIRST,                         // control dir of TX and RX
    EUSCI_A_UART_ONE_STOP_BIT,                      // number of stop bits
    EUSCI_A_UART_MODE,                              // uart mode
    EUSCI_A_UART_OVERSAMPLING_BAUDRATE_GENERATION,  // oversampling on
    EUSCI_A_UART_8_BIT_LEN
};

const Timer_A_UpModeConfig timer_config = {
    // Timer A configurations
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_64,
    46875,  // roll over every 1 second
    TIMER_A_TAIE_INTERRUPT_DISABLE,
    TIMER_A_CCIE_CCR0_INTERRUPT_ENABLE,
    TIMER_A_DO_CLEAR
};


// ENUMS
enum MODE {SB = 0, DA = 1, DO = 2};
// SB: standby
// DA: data acquisition
// DO: data output


// Volatile global variables
volatile enum MODE mode = SB;                     // mode
volatile float data_array[DATASIZE];              // array to store 30 float measurements
volatile uint8_t array_idx = 0;                   // index iterating over data array

/*
 * Function: convert2temp
 * ----------------------
 * Converts the ADC result (10-bit) to the temperature (F)
 *
 * Arguments:
 *  <float> result: Result from ADC type-casted as a float
 * Returns:
 *  <float> Temperature value in (F)
 *
*/
static float convert2temp(float result){
    return (float)150 * result / 1023;
}


/*
 * Function: acquire_data
 * -----------------------
 * Acquire data from the temperature sensor using ADC
 *
 * Arguments: None
 * Returns: <float> Temperature value in (F)
 */
float acquire_data(){
    float res;
    // Obtaining sample from ADC with polling
    while(ADC14_isBusy());  // polling to check if ADC is busy
    res = (float)MAP_ADC14_getResult(ADC_MEM0);
    MAP_ADC14_toggleConversionTrigger();
    return convert2temp(res);
}


/*
 * Function: read_from_flash
 * --------------------------
 * Read data array from flash memory
 *
 * Arguments: *array <float> Array passed by reference
 * Returns: None
 */
//void read_from_flash(float *array){
//    // Read from the flash memory
//    array = (float*) FLASH_ADDR;
//}


/*
 * Function: output_data
 * ----------------------
 * Output flash data to PuTTY
 *
 * Arguments: None
 * Returns: None
 */
void output_data(){
    assert(mode == DO);

    // Read data from flash memory
    float *darray = (float*) FLASH_ADDR;

    int i, j;
    char data_string[10];
    // Transmit data with UART
    for(i = 0; i < DATASIZE; i++){
        // Toggle LED1 (red) while data output
        MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P1, GPIO_PIN0);

        // Convert float to char array
        sprintf(data_string, "%.1f", darray[i]);

        #ifdef DEBUG
        printf("%s \r\n", data_string);
        #endif

        // Transmit
        for(j = 0; data_string[j] != '\0'; j++){
            // Polling to see that data transmission is ready
            while((EUSCI_A_UART_TRANSMIT_INTERRUPT_FLAG & 0x02) == 0){};
            // Transmit data each char at a time
            MAP_UART_transmitData(EUSCI_A0_BASE, data_string[j]);
        }
        // Break the line and start on new line
        while((EUSCI_A_UART_TRANSMIT_INTERRUPT_FLAG & 0x02) == 0){};
        MAP_UART_transmitData(EUSCI_A0_BASE, '\r');
        while((EUSCI_A_UART_TRANSMIT_INTERRUPT_FLAG & 0x02) == 0){};
        MAP_UART_transmitData(EUSCI_A0_BASE, '\n');
    }

    // Turn off LED1 (red) off
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P1, GPIO_PIN0);

    // Change mode to standby
    mode = SB;

    // If the mode is in standby keep the LED2 (blue) on
    if(mode == SB) MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);
}


/*
 * Function: write2flash
 * -----------------------
 * Write data to flash memory
 *
 * Arguments: None
 * Returns: None
 */
void write2flash(){
    bool flag;
    // Disable protection on the the flash memory to use
    MAP_FlashCtl_A_unprotectMemory(FLASH_ADDR, FLASH_ADDR);

    // Try to erase sector
    flag = MAP_FlashCtl_A_eraseSector(FLASH_ADDR);
    assert(flag);

    // Try to program memory
    flag = MAP_FlashCtl_A_programMemory(data_array, (void*) FLASH_ADDR, DATASIZE*4);
    assert(flag);

    // Set the sector back to protect
    MAP_FlashCtl_A_protectMemory(FLASH_ADDR, FLASH_ADDR);
}


/*
 * Function: TA0_0_IRQHandler
 * --------------------------
 * ISR for Timer A. Handles the data acquisition when switch 1 is pressed
 *
 * Arguments: None
 * Returns: None
 */
void TA0_0_IRQHandler(){
    if(mode == DA){  // data acquisition mode on when switch 1 is low
        assert(mode == DA);
        // Toggle LED2 (green) while data acquisition
        MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P2, GPIO_PIN1);
        if(array_idx < DATASIZE){
            // Data acquisition
            data_array[array_idx] = acquire_data();

            #ifdef DEBUG
            printf("%f\r\n", data_array[array_idx]);
            #endif

            array_idx++;  // increment index counter of data array
        } else{
            // Write the data array to flash
            write2flash();
            // Switch back to standby mode after 30 measurements
            mode = SB;
            // Turn off LED2 (green) off
            MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN1);
        }
    }

    // If the mode is in standby keep the LED2 (blue) on
    if(mode == SB) MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);

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

    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- LEDs -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);     // set LED1 as output pin
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P1, GPIO_PIN0);  // set initial state to off
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN1);     // set LED2 (green) as output pin
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN1);  // set initial state to off
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

    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- UART -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(
            GPIO_PORT_P1,
            GPIO_PIN2 | GPIO_PIN3,
            GPIO_PRIMARY_MODULE_FUNCTION);              // Make P1.2 and P1.3 UART TX/RX
    MAP_UART_initModule(EUSCI_A0_BASE, &UART0_config);  // initialize UART 0
    MAP_UART_enableModule(EUSCI_A0_BASE);
    MAP_UART_enableInterrupt(
            EUSCI_A0_BASE,
            EUSCI_A_UART_RECEIVE_INTERRUPT);            // enable UART receive interrupt
    MAP_Interrupt_enableInterrupt(INT_EUSCIA0);

    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ADC -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    MAP_ADC14_enableModule();
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(
            GPIO_PORT_P5,
            GPIO_PIN5,
            GPIO_TERTIARY_MODULE_FUNCTION);               // set P5.5 (A0) for ADC
    MAP_ADC14_setResolution(ADC_10BIT);                   // setting resolution
    MAP_ADC14_initModule(ADC_CLOCKSOURCE_SMCLK,
                         ADC_PREDIVIDER_1,
                         ADC_DIVIDER_1, 0);
    MAP_ADC14_configureSingleSampleMode(ADC_MEM0, false);
    MAP_ADC14_configureConversionMemory(
            ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS,
            ADC_INPUT_A0, false);
    MAP_ADC14_enableSampleTimer(ADC_MANUAL_ITERATION);
    MAP_ADC14_enableConversion();
    MAP_ADC14_toggleConversionTrigger();

    MAP_Interrupt_enableMaster();  // enable all interrupts

    // <<<<<<<<<<<<<<<<<<<<<<<<<<< END CRITICAL SECTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
}


/**
 * main.c
 */
void main(void){
    MAP_WDT_A_holdTimer();  // halt watch-dog timer
    critical_section_config();  // configuring the critical section

    // If the mode is in standby keep the LED2 (blue) on
    if(mode == 0) MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);

    uint8_t S1_status, S2_status;    // variables for switch status

    while(1){
        S1_status = MAP_GPIO_getInputPinValue(GPIO_PORT_P1, GPIO_PIN1);  // switch 1
        S2_status = MAP_GPIO_getInputPinValue(GPIO_PORT_P1, GPIO_PIN4);  // switch 2

        // When the switch is pressed and when both triggers are turned off
        // turn the trigger on for the corresponding switch: data acquisition or output
        if(GPIO_INPUT_PIN_LOW == S1_status && mode == SB){
            MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);  // turn LED2 (blue) off
            mode = DA;
        }
        if(GPIO_INPUT_PIN_LOW == S2_status && mode == SB){
            MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);  // turn LED2 (blue) off
            // Read all data at once from the flash when the mode is DO
            mode = DO;
            // Output data
            output_data();
        }

    }
}




