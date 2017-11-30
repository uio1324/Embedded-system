; GPIO.s
; Runs on LM4F120 and TM4C123
; Implements a NOT gate described in class
; PD3 is an output to LED, Positive logic
; PD0 is an input from switch, Positive logic
; Switch pressed causes LED to go OFF and 
; release causes LED to go ON.
; **** To run this example in Simulator 
; make sure and copy the C0DLL.dll file 
;(in the folder where this [GPIO.s]file is)
; to your Keil ARM/Bin folder; 
;;  Note that running the simulator gives 4 warnings
;;  Click OK and continue

GPIO_PORTD_DATA_R  EQU 0x400073FC
GPIO_PORTD_DIR_R   EQU 0x40007400
GPIO_PORTD_LOCK_R  EQU 0x4C4F434B
GPIO_PORTD_AFSEL_R EQU 0x40007420
GPIO_PORTD_DEN_R   EQU 0x4000751C

SYSCTL_RCGCGPIO_R  EQU 0x400FE108

        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
GPIO_Init
    ; 1) activate clock for Port D
	
	LDR R1, =SYSCTL_RCGCGPIO_R
    LDR R0, [R1]                    ; R0 = [R1]
    ORR R0, R0, #0x08 ; R0 = R0|0x08
    STR R0, [R1]                    ; [R1] = R0
    NOP
	NOP
	NOP
    NOP                             ; allow time to finish activating
	;unlock PD0,PD3
	;LDR R1, =GPIO_PORTD_LOCK_R
    ;LDR R0, [R1]                    ; R0 = [R1]
    ;ORR R0, R0, #0x09 ; R0 = R0|0x08
    ;STR R0, [R1]                    ; [R1] = R0
    ; 3) set direction register
    LDR R1, =GPIO_PORTD_DIR_R       ; R1 = &GPIO_PORTD_DIR_R
    LDR R0, [R1]                    ; R0 = [R1]
    ORR R0, R0, #0x04               ; R0 = R0|0x04 (make PD2 output)
	BIC R0, R0, #0x01				; R0 = R0 & NOT(0x01) (make PD0 input)
    STR R0, [R1]                    ; [R1] = R0
    ; 4) regular port function
    LDR R1, =GPIO_PORTD_AFSEL_R     ; R1 = &GPIO_PORTD_AFSEL_R
    LDR R0, [R1]                    ; R0 = [R1]
    BIC R0, R0, #0x05               ; R0 = R0&~0x05 (disable alt funct on PD2,PD0)
    STR R0, [R1]                    ; [R1] = R0
    ; 5) enable digital port
    LDR R1, =GPIO_PORTD_DEN_R       ; R1 = &GPIO_PORTD_DEN_R
    LDR R0, [R1]                    ; R0 = [R1]
    ORR R0, R0, #0x05               ; R0 = R0|0x09 (enable digital I/O on PD2,PD0)
    STR R0, [R1]                    ; [R1] = R0
   
	
    BX  LR
    
Start
    BL  GPIO_Init
    LDR R0, =GPIO_PORTD_DATA_R      

loop
	LDR R1,[R0]
	AND	R1,#0x01		; Isolate PD0
	EOR	R1,#0x01		; NOT state of PD0 read into R1
	STR R1,[R0]
	nop
	nop
	nop
	nop
	nop
	nop
	LSL R1,#2			; SHIFT left negated state of PD0 read into R1
	STR R1,[R0]			; Write to PortD DATA register to update LED on PD3
    B loop                          ; unconditional branch to 'loop'


    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file