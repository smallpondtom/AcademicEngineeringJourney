/*
 * AE6705 LAB5 main.c file
 * Author: Tomoki Koike
 * Last Edited: 10/13/2021
 */

#include <driverlib.h>
#include <msp.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEBUG

// Define all volatile variables sent and changed by the ISR
volatile char userInput;
volatile bool endFlag = false;
volatile float res;
volatile bool data_on_off = false;
volatile uint8_t ct = 0;


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


const Timer_A_UpModeConfig timer_config = {
    // Timer A
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_64,
    46875,  // for roll over every 1 second
    TIMER_A_TAIE_INTERRUPT_DISABLE,
    TIMER_A_CCIE_CCR0_INTERRUPT_ENABLE,
    TIMER_A_DO_CLEAR
};


/*
 * Function: UART_isr
 * ------------------
 * ISR for UART data receiving.
 *
 * Arguments: None
 * Returns: None
 */
void UART_isr(){
    // Toggle LED1 for verification
    MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P1, GPIO_PIN0);

    // Receive data from the MCU
    userInput = MAP_UART_receiveData(EUSCI_A0_BASE);

    // Check to see if the entered value is an enter key or not
    if(userInput == '\n' | userInput == '\r'){
        data_on_off = true;
        ct++;

        if(ct >= 2){
            data_on_off = false;
        }

        if(!data_on_off){
            endFlag = true;
        }
    }

    // Clear interrupt
    MAP_UART_clearInterruptFlag(EUSCI_A0_BASE, EUSCI_A_UART_RECEIVE_INTERRUPT);
}


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
 * Function: TA0_0_IRQHandler
 * --------------------------
 * ISR for Timer A printing out the temperature value from ADC onto console
 *
 * Arguments: None
 * Returns: None
 */
void TA0_0_IRQHandler(){
    // Toggle LED2 for verification
    MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P2, GPIO_PIN2);

    if(data_on_off){
        // Obtaining sample from ADC with polling
        while(ADC14_isBusy());
        res = (float)MAP_ADC14_getResult(ADC_MEM0);
        MAP_ADC14_toggleConversionTrigger();


        // Printing results to console
        #ifdef DEBUG
        printf("%f\n", convert2temp(res));
        #endif
    }
    MAP_Timer_A_clearCaptureCompareInterrupt(TIMER_A0_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_0);
}


/**
 * main.c
 */
void main(void){
    // Halt watchdog timer
    MAP_WDT_A_holdTimer();

    // CRITICAL SECTION START >>>>>
    // Disable all interrupts
    MAP_Interrupt_disableMaster();

    // Set LEDs at output pins and set their initial state to off
    // LED1
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P1, GPIO_PIN0);
    // LED2 (RED)
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN2);
    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);

    // Setup the clock
    unsigned int dcoFrequency = 3E+6;
    MAP_CS_setDCOFrequency(dcoFrequency);
    MAP_CS_initClockSignal(CS_SMCLK, CS_DCOCLK_SELECT, CS_CLOCK_DIVIDER_1);
    MAP_Timer_A_configureUpMode(TIMER_A0_BASE, &timer_config);  // configure timer A using struct
    MAP_Interrupt_enableInterrupt(INT_TA0_0);
    MAP_Timer_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);

    // Make P1.2 and P1.3 UART TX/RX
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P1, GPIO_PIN2 | GPIO_PIN3, GPIO_PRIMARY_MODULE_FUNCTION);

    // Initialize UART 0
    MAP_UART_initModule(EUSCI_A0_BASE, &UART0_config);
    MAP_UART_enableModule(EUSCI_A0_BASE);

    // Configuring ADC
    // Set P5.5 (A0) to be ADC functionality
    // We need to set P5SEL0 bit 5 to 1 and P5SEL1 bit 5 to 1 (tertiary functionality in datasheet)
    MAP_ADC14_enableModule();
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P5, GPIO_PIN5, GPIO_TERTIARY_MODULE_FUNCTION);
    MAP_ADC14_setResolution(ADC_10BIT);
    MAP_ADC14_initModule(ADC_CLOCKSOURCE_SMCLK, ADC_PREDIVIDER_1, ADC_DIVIDER_1, 0);
    MAP_ADC14_configureSingleSampleMode(ADC_MEM0, false);
    MAP_ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_AVCC_VREFNEG_VSS, ADC_INPUT_A0, false);
    MAP_ADC14_enableSampleTimer(ADC_MANUAL_ITERATION);
    MAP_ADC14_enableConversion();
    MAP_ADC14_toggleConversionTrigger();

    // Enable UART receive interrupt
    MAP_UART_enableInterrupt(EUSCI_A0_BASE, EUSCI_A_UART_RECEIVE_INTERRUPT);
    MAP_Interrupt_enableInterrupt(INT_EUSCIA0);
    MAP_Interrupt_enableMaster();

    // >>>>> CRITICAL SECTION END

    #ifdef DEBUG
    printf("\nStart...\n");
    #endif

    while(1){
        // When the enter key is hit
        if(endFlag){

            #ifdef DEBUG
            printf("\nEnd data acquisition. \n");
            #endif
            return;
        }
    }
}
