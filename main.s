;-------------------------------------------------------------------------------
; File: main.s
; Author: Oscar Gonzalez
; Device: pic16f84a
; Description: on led
; Compilator: pic-as
;-------------------------------------------------------------------------------
    
;-------------------------------------------------------------------------------
; Libraries included	    
;-------------------------------------------------------------------------------
    
PROCESSOR 16F84A
#include <xc.inc>

;-------------------------------------------------------------------------------
; PIC16F84A Configuration Bit Settings
;-------------------------------------------------------------------------------
    
; CONFIG
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator)
  CONFIG WDTE = ON		; Watchdog Timer (WDT enabled)
  CONFIG PWRTE = OFF		; Power-up Timer Enable bit (Power-up Timer is disabled)
  CONFIG CP = OFF		; Code Protection bit (Code protection disabled)
  
PSECT resetVec, class=CODE, delta=2, abs ; Program sections
resetVec:
    goto  main
    
PSECT code
main:			    ; label, start code for configuration
    bsf   STATUS, 5	    ; select bank 1, set rp0, (bit 6 = 0, bit 5 = 1)
    clrf  TRISB		    ; clear file register, config output 
    bsf   TRISA, 0	    ; set bit 0 (1), config input
    bcf   STATUS, 5	    ; select bank 0, clear rp0, (bit 6 = 0, bit 5 = 0)
    clrf  PORTB		    ; clear register, pin off
loop:			    ; label, infinite code loop
    btfsc PORTA, 2	    ; bit test file register, skip if clear 
    goto configModeA	    ; go to if pin0 is high
    goto configModeB	    ; go to if pin0 is low
    configModeA:	    ; label, function: setting bits
	movlw 01010101B	    ; move configuration bits to file register w
	goto setConfig	    ; go to label
    configModeB:	    ; label, function: setting bits
	movlw 10101010B	    ; move setup bits to file register w
    setConfig:		    ; label, function: setting bits port
	movwf PORTB	    ; move configurtion bits to file register port for on or off led
    goto loop		    ; go to label
    
    END resetVec