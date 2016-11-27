
;CodeVisionAVR C Compiler V3.28 Evaluation
;(C) Copyright 1998-2016 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x58,0x41,0x4E,0x47,0x4C,0x45,0x20,0x3A
	.DB  0x20,0x25,0x35,0x64,0x0,0x59,0x41,0x4E
	.DB  0x47,0x4C,0x45,0x20,0x3A,0x20,0x25,0x35
	.DB  0x64,0x0,0x25,0x64,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <lcd.h>
;#include <stdio.h>
;#include <math.h>
;
;#asm
.equ __lcd_port = 0x1b
; 0000 0009 #endasm
;
;#define GYRO_LSB 131.0
;#define GYRO_WEIGHT 0.98
;#define ACCEL_WEIGHT 0.02
;#define DELTA_TIME 0.001
;
;typedef struct {
;	int x;
;	int y;
;	int z;
;} Gyro;
;
;typedef struct {
;	int x;
;	int y;
;	int z;
;} Accel;
;
;typedef struct {
;	float x;
;	float y;
;	float z;
;} Angle;
;
;void setUp();
;void I2C_init(void);
;void I2C_write(unsigned char slv_addr,
; 0000 0025 		unsigned char address,
; 0000 0026 		unsigned char byte);
;
;int I2C_read(unsigned char slv_addr, unsigned char regi);
;
;void getRawData(int *rawData);
;void updateAngle(int *rawData, Angle *angle);
;void putch(char data);
;void sendAngle(Angle angle);
;
;void main()
; 0000 0030 {

	.CSEG
_main:
; .FSTART _main
; 0000 0031 	char firstBuf[20];
; 0000 0032 	char secondBuf[20];
; 0000 0033 	int rawData[10];
; 0000 0034 
; 0000 0035 	Angle angle;
; 0000 0036 	angle.x = 0;
	SBIW R28,63
	SBIW R28,9
;	firstBuf -> Y+52
;	secondBuf -> Y+32
;	rawData -> Y+12
;	angle -> Y+0
	LDI  R30,LOW(0)
	RCALL __CLRD1S0
; 0000 0037 	angle.y = 0;
	__CLRD1S 4
; 0000 0038 
; 0000 0039 	setUp();
	RCALL _setUp
; 0000 003A 
; 0000 003B 	while(1)
_0x3:
; 0000 003C 	{
; 0000 003D 		getRawData(rawData);
	MOVW R26,R28
	ADIW R26,12
	RCALL _getRawData
; 0000 003E 
; 0000 003F 		updateAngle(rawData, &angle);
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	RCALL _updateAngle
; 0000 0040 
; 0000 0041 		sprintf(firstBuf, "XANGLE : %5d",(int)angle.x);
	MOVW R30,R28
	ADIW R30,52
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
; 0000 0042 		sprintf(secondBuf, "YANGLE : %5d",(int)angle.y);
	MOVW R30,R28
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,13
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1
; 0000 0043 
; 0000 0044 		lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0045 		lcd_puts(firstBuf);
	MOVW R26,R28
	ADIW R26,52
	RCALL _lcd_puts
; 0000 0046 		lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0047 		lcd_puts(secondBuf);
	MOVW R26,R28
	ADIW R26,32
	RCALL _lcd_puts
; 0000 0048 
; 0000 0049 		sendAngle(angle);
	MOVW R30,R28
	LDI  R26,12
	RCALL __PUTPARL
	RCALL _sendAngle
; 0000 004A 	}
	RJMP _0x3
; 0000 004B }
_0x6:
	RJMP _0x6
; .FEND
;
;void setUp()
; 0000 004E {
_setUp:
; .FSTART _setUp
; 0000 004F 	lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0050 
; 0000 0051 	I2C_init();
	RCALL _I2C_init
; 0000 0052 	I2C_write(0xd0, 0x6B, 0);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R30,LOW(107)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _I2C_write
; 0000 0053 
; 0000 0054 	UCSR0A = 0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0055 	UCSR0B = 0xA8;
	LDI  R30,LOW(168)
	OUT  0xA,R30
; 0000 0056 	UCSR0C = 0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0057 
; 0000 0058 	UBRR0H = 0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0059 	UBRR0L = 103;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 005A }
	RET
; .FEND
;
;void I2C_init(void)
; 0000 005D {
_I2C_init:
; .FSTART _I2C_init
; 0000 005E 	TWBR = 74;
	LDI  R30,LOW(74)
	STS  112,R30
; 0000 005F 	TWSR = 0;
	LDI  R30,LOW(0)
	STS  113,R30
; 0000 0060 	delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0061 }
	RET
; .FEND
;
;void I2C_write(unsigned char slv_addr,
; 0000 0064 		unsigned char address,
; 0000 0065 		unsigned char byte) {
_I2C_write:
; .FSTART _I2C_write
; 0000 0066 
; 0000 0067 	delay_ms(1);
	RCALL __SAVELOCR4
	MOV  R17,R26
	LDD  R16,Y+4
	LDD  R19,Y+5
;	slv_addr -> R19
;	address -> R16
;	byte -> R17
	RCALL SUBOPT_0x3
; 0000 0068 
; 0000 0069 	TWCR = 0xA4; // Start
; 0000 006A 	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x08);
_0x7:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0xA
	RCALL SUBOPT_0x4
	BREQ _0x9
_0xA:
	RJMP _0x7
_0x9:
; 0000 006B 	//Wait for TWINT flag set. This indicates that
; 0000 006C 	//the START condition has been transmitted
; 0000 006D 
; 0000 006E 	//Check value of TWI Status Register. Mask
; 0000 006F 	//prescaler bits. If status different from START
; 0000 0070 	//go to ERROR
; 0000 0071 
; 0000 0072 	TWDR = slv_addr; // Address
	RCALL SUBOPT_0x5
; 0000 0073 	TWCR = 0x84;
; 0000 0074 	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x18);
_0xC:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0xF
	RCALL SUBOPT_0x6
	BREQ _0xE
_0xF:
	RJMP _0xC
_0xE:
; 0000 0075 	// SLA + W transmitted, ACK received
; 0000 0076 
; 0000 0077 	TWDR = address;
	STS  115,R16
; 0000 0078 	TWCR = 0x84;
	LDI  R30,LOW(132)
	STS  116,R30
; 0000 0079 	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x28);
_0x11:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x14
	RCALL SUBOPT_0x7
	BREQ _0x13
_0x14:
	RJMP _0x11
_0x13:
; 0000 007A 	// data transmitted, ACK received
; 0000 007B 
; 0000 007C 	TWDR = byte;
	STS  115,R17
; 0000 007D 	TWCR = 0x84;
	LDI  R30,LOW(132)
	STS  116,R30
; 0000 007E 	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x28);
_0x16:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x19
	RCALL SUBOPT_0x7
	BREQ _0x18
_0x19:
	RJMP _0x16
_0x18:
; 0000 007F 
; 0000 0080 	TWCR = 0x94; // stop
	LDI  R30,LOW(148)
	STS  116,R30
; 0000 0081 }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;int I2C_read(unsigned char slv_addr, unsigned char regi)
; 0000 0084 {
_I2C_read:
; .FSTART _I2C_read
; 0000 0085 	unsigned int result;
; 0000 0086 	delay_ms(1);
	RCALL __SAVELOCR4
	MOV  R19,R26
	LDD  R18,Y+4
;	slv_addr -> R18
;	regi -> R19
;	result -> R16,R17
	RCALL SUBOPT_0x3
; 0000 0087 
; 0000 0088 	TWCR = 0xA4;
; 0000 0089 
; 0000 008A 	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x08);
_0x1B:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x1E
	RCALL SUBOPT_0x4
	BREQ _0x1D
_0x1E:
	RJMP _0x1B
_0x1D:
; 0000 008B 	TWDR = slv_addr;
	STS  115,R18
; 0000 008C 	TWCR = 0x84;
	RCALL SUBOPT_0x8
; 0000 008D 	delay_us(50);
; 0000 008E 
; 0000 008F 	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x18); // MT_SLV_ACK
_0x20:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x23
	RCALL SUBOPT_0x6
	BREQ _0x22
_0x23:
	RJMP _0x20
_0x22:
; 0000 0090 	TWDR = regi;
	RCALL SUBOPT_0x5
; 0000 0091 	TWCR = 0x84;
; 0000 0092 	delay_us(50);
	__DELAY_USW 200
; 0000 0093 
; 0000 0094 	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x28); // MT_DAT_ACK
_0x25:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x28
	RCALL SUBOPT_0x7
	BREQ _0x27
_0x28:
	RJMP _0x25
_0x27:
; 0000 0095 
; 0000 0096 	TWCR = 0xA4; // Restart
	LDI  R30,LOW(164)
	STS  116,R30
; 0000 0097 
; 0000 0098 	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x10); // RESTART
_0x2A:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x2D
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x10)
	BREQ _0x2C
_0x2D:
	RJMP _0x2A
_0x2C:
; 0000 0099 	TWDR = slv_addr+1; // AD+R ??
	MOV  R30,R18
	SUBI R30,-LOW(1)
	STS  115,R30
; 0000 009A 	TWCR = 0x84;
	RCALL SUBOPT_0x8
; 0000 009B 	delay_us(50);
; 0000 009C 
; 0000 009D 	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x40); // MR_SLV_ACK
_0x2F:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x32
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x40)
	BREQ _0x31
_0x32:
	RJMP _0x2F
_0x31:
; 0000 009E 	TWCR = 0x84;
	RCALL SUBOPT_0x8
; 0000 009F 	delay_us(50);
; 0000 00A0 
; 0000 00A1 	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x58); // MR_DAT_NACK
_0x34:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x37
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x58)
	BREQ _0x36
_0x37:
	RJMP _0x34
_0x36:
; 0000 00A2 	result = TWDR;
	LDS  R16,115
	CLR  R17
; 0000 00A3 	TWCR = 0x94; // stop
	LDI  R30,LOW(148)
	STS  116,R30
; 0000 00A4 
; 0000 00A5 	return result;
	MOVW R30,R16
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; 0000 00A6 }
; .FEND
;
;void getRawData(int *rawData)
; 0000 00A9 {
_getRawData:
; .FSTART _getRawData
; 0000 00AA 	//AccelX H & L
; 0000 00AB 	rawData[0] = I2C_read(0xd0, 0x3B);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*rawData -> R16,R17
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(59)
	RCALL _I2C_read
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
; 0000 00AC 	rawData[1] = I2C_read(0xd0, 0x3C);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(60)
	RCALL _I2C_read
	__PUTW1RNS 16,2
; 0000 00AD 
; 0000 00AE 	//AccelY H & L
; 0000 00AF 	rawData[2] = I2C_read(0xd0, 0x3D);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(61)
	RCALL _I2C_read
	__PUTW1RNS 16,4
; 0000 00B0 	rawData[3] = I2C_read(0xd0, 0x3E);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(62)
	RCALL _I2C_read
	__PUTW1RNS 16,6
; 0000 00B1 
; 0000 00B2 	//AccelZ H & L
; 0000 00B3 	rawData[4] = I2C_read(0xd0, 0x3F);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(63)
	RCALL _I2C_read
	__PUTW1RNS 16,8
; 0000 00B4 	rawData[5] = I2C_read(0xd0, 0x40);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(64)
	RCALL _I2C_read
	__PUTW1RNS 16,10
; 0000 00B5 
; 0000 00B6 	//GyroX H & L
; 0000 00B7 	rawData[6] = I2C_read(0xd0, 0x43);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(67)
	RCALL _I2C_read
	__PUTW1RNS 16,12
; 0000 00B8 	rawData[7] = I2C_read(0xd0, 0x44);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(68)
	RCALL _I2C_read
	__PUTW1RNS 16,14
; 0000 00B9 
; 0000 00BA 	//GyroY H & L
; 0000 00BB 	rawData[8] = I2C_read(0xd0, 0x45);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(69)
	RCALL _I2C_read
	__PUTW1RNS 16,16
; 0000 00BC 	rawData[9] = I2C_read(0xd0, 0x46);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(70)
	RCALL _I2C_read
	__PUTW1RNS 16,18
; 0000 00BD 
; 0000 00BE }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void updateAngle(int *rawData, Angle *angle)
; 0000 00C1 {
_updateAngle:
; .FSTART _updateAngle
; 0000 00C2 	Accel accel;
; 0000 00C3 	Gyro gyro;
; 0000 00C4 
; 0000 00C5 	float gyro_x_angle;
; 0000 00C6 	float gyro_y_angle;
; 0000 00C7 	float accel_x_angle;
; 0000 00C8 	float accel_y_angle;
; 0000 00C9 
; 0000 00CA 	accel.x = rawData[0] << 8 | rawData[1];
	SBIW R28,28
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,32
;	*rawData -> R18,R19
;	*angle -> R16,R17
;	accel -> Y+26
;	gyro -> Y+20
;	gyro_x_angle -> Y+16
;	gyro_y_angle -> Y+12
;	accel_x_angle -> Y+8
;	accel_y_angle -> Y+4
	MOVW R26,R18
	RCALL SUBOPT_0x9
	ADIW R26,2
	RCALL SUBOPT_0xA
	STD  Y+26,R30
	STD  Y+26+1,R31
; 0000 00CB 	accel.y = rawData[2] << 8 | rawData[3];
	MOVW R26,R18
	ADIW R26,4
	RCALL SUBOPT_0x9
	ADIW R26,6
	RCALL SUBOPT_0xA
	STD  Y+28,R30
	STD  Y+28+1,R31
; 0000 00CC 	accel.z = rawData[4] << 8 | rawData[5];
	MOVW R26,R18
	ADIW R26,8
	RCALL SUBOPT_0x9
	ADIW R26,10
	RCALL SUBOPT_0xA
	STD  Y+30,R30
	STD  Y+30+1,R31
; 0000 00CD 
; 0000 00CE 	gyro.x = rawData[6] << 8 | rawData[7];
	MOVW R26,R18
	ADIW R26,12
	RCALL SUBOPT_0x9
	ADIW R26,14
	RCALL SUBOPT_0xA
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 00CF 	gyro.y = rawData[8] << 8 | rawData[9];
	MOVW R26,R18
	ADIW R26,16
	RCALL SUBOPT_0x9
	ADIW R26,18
	RCALL SUBOPT_0xA
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0000 00D0 
; 0000 00D1 	gyro_x_angle = gyro.x / GYRO_LSB;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RCALL SUBOPT_0xB
	__PUTD1S 16
; 0000 00D2 	gyro_y_angle = gyro.y / GYRO_LSB;
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	RCALL SUBOPT_0xB
	__PUTD1S 12
; 0000 00D3 
; 0000 00D4 	// radian to degired
; 0000 00D5 	accel_x_angle = atan2((float)accel.x, (float)accel.z) * 180 / PI;
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	RCALL SUBOPT_0xC
	__PUTD1S 8
; 0000 00D6 	accel_y_angle = atan2((float)accel.y, (float)accel.z) * 180 / PI;
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	RCALL SUBOPT_0xC
	__PUTD1S 4
; 0000 00D7 
; 0000 00D8 	angle->x = ( GYRO_WEIGHT * ( angle->x + ( gyro_x_angle * DELTA_TIME) ) +
; 0000 00D9 			( ACCEL_WEIGHT * accel_x_angle ) );
	MOVW R26,R16
	RCALL __GETD1P_INC
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 16
	RCALL SUBOPT_0xD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xE
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xF
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	MOVW R26,R16
	RCALL __PUTDP1
; 0000 00DA 
; 0000 00DB 	angle->y = ( GYRO_WEIGHT * ( angle->y + ( gyro_y_angle * DELTA_TIME) ) +
; 0000 00DC 			( ACCEL_WEIGHT * accel_y_angle ) );
	MOVW R30,R16
	__GETD2Z 4
	PUSH R25
	PUSH R24
	PUSH R27
	PUSH R26
	__GETD2S 12
	RCALL SUBOPT_0xD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xE
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0xF
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	__PUTD1RNS 16,4
; 0000 00DD 
; 0000 00DE }
	RCALL __LOADLOCR4
	ADIW R28,34
	RET
; .FEND
;
;void putch(char data)
; 0000 00E1 {
_putch:
; .FSTART _putch
; 0000 00E2 	while(!(UCSR0A & 0x20));
	ST   -Y,R17
	MOV  R17,R26
;	data -> R17
_0x39:
	SBIS 0xB,5
	RJMP _0x39
; 0000 00E3 	UDR0 = data;
	OUT  0xC,R17
; 0000 00E4 }
	LD   R17,Y+
	RET
; .FEND
;
;void sendAngle(Angle angle)
; 0000 00E7 {
_sendAngle:
; .FSTART _sendAngle
; 0000 00E8 	int i = 0;
; 0000 00E9 	char sendBuff[40];
; 0000 00EA 
; 0000 00EB 	sprintf(sendBuff, "%d", (int)angle.x);
	SBIW R28,40
	ST   -Y,R17
	ST   -Y,R16
;	angle -> Y+42
;	i -> R16,R17
;	sendBuff -> Y+2
	__GETWRN 16,17,0
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,26
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 46
	RCALL SUBOPT_0x1
; 0000 00EC 
; 0000 00ED 	while(sendBuff[i] != '\0')
_0x3C:
	RCALL SUBOPT_0x10
	LD   R30,X
	CPI  R30,0
	BREQ _0x3E
; 0000 00EE 	{
; 0000 00EF 		putch(sendBuff[i]);
	RCALL SUBOPT_0x10
	LD   R26,X
	RCALL _putch
; 0000 00F0 		++i;
	__ADDWRN 16,17,1
; 0000 00F1 	}
	RJMP _0x3C
_0x3E:
; 0000 00F2 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,54
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
; .FSTART __lcd_delay_G100
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0004
; .FEND
__lcd_read_nibble_G100:
; .FSTART __lcd_read_nibble_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G100:
; .FSTART _lcd_read_byte0_G100
	RCALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	RCALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	RCALL __lcd_ready
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	RCALL __lcd_ready
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R5,R7
	BRLO _0x2000004
	__lcd_putchar1:
	INC  R4
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R4
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	INC  R5
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	RCALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0004
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000005
_0x2000007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G100:
; .FSTART __long_delay_G100
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G100:
; .FSTART __lcd_init_write_G100
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0004
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL __long_delay_G100
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(48)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	RCALL __long_delay_G100
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	RCALL __long_delay_G100
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	RCALL __long_delay_G100
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20C0004
_0x200000B:
	RCALL __lcd_ready
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0004:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	RCALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+6
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	MOVW R26,R18
	ADIW R26,4
	RCALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1RNS 18,4
_0x2020012:
	MOVW R26,R18
	ADIW R26,2
	RCALL SUBOPT_0x11
	SBIW R30,1
	ST   Z,R21
_0x2020013:
	MOVW R26,R18
	RCALL __GETW1P
	TST  R31
	BRMI _0x2020014
	RCALL SUBOPT_0x11
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	MOVW R26,R18
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	RCALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0x12
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0x12
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0x13
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x14
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x15
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x15
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0x13
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0x13
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0x12
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x14
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x14
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR6
	MOVW R30,R28
	RCALL __ADDW1R15
	__GETWRZ 20,21,14
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0003
_0x2020072:
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	MOVW R16,R26
	__PUTWSR 20,21,8
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0003:
	RCALL __LOADLOCR6
	ADIW R28,12
	POP  R15
	RET
; .FEND

	.CSEG
_xatan:
; .FSTART _xatan
	RCALL __PUTPARD2
	SBIW R28,4
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
	__GETD2N 0x40CBD065
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x18
	__GETD2N 0x41296D00
	RCALL __ADDF12
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x19
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	RCALL __PUTPARD2
	RCALL SUBOPT_0x1A
	__GETD1N 0x3ED413CD
	RCALL __CMPF12
	BRSH _0x2040020
	RCALL SUBOPT_0x1A
	RCALL _xatan
	RJMP _0x20C0002
_0x2040020:
	RCALL SUBOPT_0x1A
	__GETD1N 0x401A827A
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040021
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
	__GETD2N 0x3FC90FDB
	RCALL __SWAPD12
	RCALL __SUBF12
	RJMP _0x20C0002
_0x2040021:
	RCALL SUBOPT_0x1B
	RCALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1B
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x1C
	__GETD2N 0x3F490FDB
	RCALL __ADDF12
_0x20C0002:
	ADIW R28,4
	RET
; .FEND
_atan2:
; .FSTART _atan2
	RCALL __PUTPARD2
	SBIW R28,4
	RCALL SUBOPT_0x0
	RCALL __CPD10
	BRNE _0x204002D
	RCALL SUBOPT_0x2
	RCALL __CPD10
	BRNE _0x204002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0001
_0x204002E:
	RCALL SUBOPT_0x1D
	RCALL __CPD02
	BRGE _0x204002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0001
_0x204002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0001
_0x204002D:
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1D
	RCALL __DIVF21
	RCALL SUBOPT_0x17
	__GETD2S 4
	RCALL __CPD02
	BRGE _0x2040030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040031
	RCALL SUBOPT_0x1A
	RCALL _yatan
	RJMP _0x20C0001
_0x2040031:
	RCALL SUBOPT_0x1E
	RCALL __ANEGF1
	RJMP _0x20C0001
_0x2040030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040032
	RCALL SUBOPT_0x1E
	__GETD2N 0x40490FDB
	RCALL __SWAPD12
	RCALL __SUBF12
	RJMP _0x20C0001
_0x2040032:
	RCALL SUBOPT_0x1A
	RCALL _yatan
	__GETD2N 0xC0490FDB
	RCALL __ADDF12
_0x20C0001:
	ADIW R28,12
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.DSEG
__base_y_G100:
	.BYTE 0x4
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	RCALL __CFD1
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R30,LOW(164)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	STS  115,R19
	LDI  R30,LOW(132)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x18)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x28)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(132)
	STS  116,R30
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x9:
	LD   R30,X+
	LD   R31,X+
	MOV  R31,R30
	LDI  R30,0
	MOVW R0,R30
	MOVW R26,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	LD   R30,X+
	LD   R31,X+
	OR   R30,R0
	OR   R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	RCALL __CWD1
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43030000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xC:
	RCALL __CWD1
	RCALL __CDF1
	RCALL __PUTPARD1
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	RCALL __CWD1
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _atan2
	__GETD2N 0x43340000
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40490FDB
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	__GETD1N 0x3A83126F
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	RCALL __ADDF12
	__GETD2N 0x3F7AE148
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	__GETD2N 0x3CA3D70A
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R16
	ADC  R27,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x12:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x13:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	__GETD2S 4
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x18:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	RCALL __MULF12
	__GETD2N 0x414A8F4E
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1A:
	RCALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x18
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	RCALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	RJMP _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x18
	RCALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RJMP _yatan

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ADDW1R15:
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__CLRD1S0:
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	MOVW R22,R30
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	MOVW R20,R18
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
