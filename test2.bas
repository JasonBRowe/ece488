;0x28: Thresh_FF = 0x07
;0x29: Time_FF = 250 ms
;0x2E: INT_ENABLE OR 0x04 to set bit D2 high, this enables free fall interrupt (DO THIS LAST)
;0x30: INT_SOURCE BITWISEAND 0x04, IF result=0x04 THEN free fall detected!

;symbol pushButton = C.3
symbol powerSwitch = C.4
symbol buttonStillPressed = w4

HI2CSETUP I2CMASTER, 0xA6, i2cfast, i2cbyte

HI2COUT 0x28,(0x07)					;Configure Free Fall Threshhold
HI2COUT 0x29,(0xFA)					;Configure Free Fall Timer
HI2CIN 0x2E,(b0)
b0 = b0 OR 0x04
HI2COUT 0x2E,(b0) 				;enable free fall interrupt
buttonStillPressed = 0x0000
low powerSwitch
input C.2
input C.1
b10 = 0;
b9 = 0;
main:

let b1 = pins & %00001000 
if b1 = %00001000 then
	if b10 = 0 then 
		high C.4
		pause 10
		b10 = 1
	end if
	b9 = b9 + 1
	if b9 > 100 then
		low C.4
		b10 = 0
	end if
else 
	if b10 != 1 then
		low C.4
		pause 3000
	end if
	b9 = 0;
end if

pause 10
goto main