;0x28: Thresh_FF = 0x07
;0x29: Time_FF = 250 ms
;0x2E: INT_ENABLE OR 0x04 to set bit D2 high, this enables free fall interrupt (DO THIS LAST)
;0x30: INT_SOURCE BITWISEAND 0x04, IF result=0x04 THEN free fall detected!

symbol pushButton = B.3
symbol powerSwitch = B.4
symbol buttonStillPressed = w4

HI2CSETUP I2CMASTER, 0xA6, i2cfast, i2cbyte

HI2COUT 0x28,(0x07)					;Configure Free Fall Threshhold
HI2COUT 0x29,(0xFA)					;Configure Free Fall Timer
HI2CIN 0x2E,(b0)
b0 = b0 OR 0x04
HI2COUT 0x2E,(b0) 				;enable free fall interrupt
buttonStillPressed = 0x0000
low powerSwitch

main:

b3 = pushButton

If b3 = 1 Then
	high powerSwitch				;POWER ON
	buttonStillPressed = buttonStillPressed + 1	
	If buttonStillPressed > 0x0258 Then		;Check if button has been pressed for 3 seconds
		low powerSwitch				;POWER OFF
		
Else
	buttonStillPressed = 0x0000
	endif
endif

HI2CIN 0x30,(b1) ;read INT_SOURCE register
b1 = b1 AND 0x04
If b1 = 0x04 Then
	high powerSwitch				;POWER ON
endif
pause 5
goto main