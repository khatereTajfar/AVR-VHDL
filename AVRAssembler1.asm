/*
 * AVRAssembler1.asm
 *
 *  Created: 7/28/2019 1:40:17 PM
 *   Author: KhatereTajfar
 */
 .org 0x0000
	jmp 0x0030
 
 .org 0x0030
 
	ldi r16,10
	ldi r17,20
	ldi r20,10
	ldi r21,30
	add r17,r16
 loop:
	cp r20,r16
	nop
	brbc 1,equal
	inc r16
	adc r17,r20
	jmp loop 
 
 .org 0x0045
	equal:
	dec r16
	mov r17,r20
	jmp loop 


