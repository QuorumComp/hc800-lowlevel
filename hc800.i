	IFND	HC800_I_INCLUDED_

HC800_I_INCLUDED_ = 1

; --
; -- MEMORY
; --

; The palette bank index
BANK_PALETTE		EQU	$38
PALETTE_SIZEOF		EQU	$200

DRGB	MACRO
.word\@	EQU	((\1)<<10)|((\2)<<5)|(\3)
	DB	.word\@&$FF
	DB	(.word\@>>8)&$FF
	ENDM

; The attribute memory index
BANK_ATTRIBUTE		EQU	$3C
ATTRIBUTES_SIZEOF	EQU	$2000

; Client executable banks
BANK_CLIENT_CODE	EQU	$81
BANK_CLIENT_DATA	EQU	$85

; --
; -- I/O
; --

; Interrupt controller

IO_ICTRL_BASE		EQU	$00

IO_ICTRL_ENABLE		EQU	$00
IO_ICTRL_REQUEST	EQU	$01
IO_ICTRL_HANDLE		EQU	$02

IO_INT_VBLANK		EQU	$01
IO_INT_HBLANK		EQU	$02
IO_INT_SET		EQU	$80


; MMU

IO_MMU_BASE		EQU	$01

IO_MMU_UPDATE_INDEX	EQU	$00
IO_MMU_CONFIGURATION	EQU	$01
IO_MMU_CODE_BANK0	EQU	$02
IO_MMU_CODE_BANK1	EQU	$03
IO_MMU_CODE_BANK2	EQU	$04
IO_MMU_CODE_BANK3	EQU	$05
IO_MMU_DATA_BANK0	EQU	$06
IO_MMU_DATA_BANK1	EQU	$07
IO_MMU_DATA_BANK2	EQU	$08
IO_MMU_DATA_BANK3	EQU	$09
IO_MMU_SYSTEM_CODE	EQU	$0A
IO_MMU_SYSTEM_DATA	EQU	$0B
IO_MMU_ACTIVE_INDEX	EQU	$0C
IO_MMU_CHARGEN		EQU	$0D
IO_MMU_SIZEOF		EQU	$0E

MMU_INDEX_PUSH		EQU	$80
MMU_INDEX_POP		EQU	$40

MMU_CFG_USER_HARVARD	EQU	$01
MMU_CFG_SYS_HARVARD	EQU	$02
MMU_CFG_HARVARD		EQU	(MMU_CFG_USER_HARVARD|MMU_CFG_SYS_HARVARD)

MSetDataBank:	MACRO	;index, bank
		pusha
		ld	b,IO_MMU_BASE
		ld	c,IO_MMU_DATA_BANK0+(\1)
		ld	t,(\2)
		lio	(bc),t
		popa
		ENDM

MIncDataBank:	MACRO	;index
		pusha
		ld	b,IO_MMU_BASE
		ld	c,IO_MMU_DATA_BANK0+(\1)
		lio	t,(bc)
		add	t,1
		lio	(bc),t
		popa
		ENDM


; Math

IO_MATH_BASE		EQU	$02

IO_MATH_STATUS		EQU	$00
IO_MATH_OPERATION	EQU	$01
IO_MATH_X		EQU	$02
IO_MATH_Y		EQU	$03
IO_MATH_Z		EQU	$04

MATH_OP_SIGNED_MUL	EQU	$00
MATH_OP_UNSIGNED_MUL	EQU	$01
MATH_OP_SIGNED_DIV	EQU	$02
MATH_OP_UNSIGNED_DIV	EQU	$03


; Keyboard

IO_KEYBOARD_BASE	EQU	$03

IO_KEYBOARD_DATA	EQU	$00
IO_KEYBOARD_STATUS	EQU	$01

IO_KBD_STAT_READY	EQU	$01


; UART

IO_UART_BASE		EQU	$04

IO_UART_DATA		EQU	$00
IO_UART_STATUS		EQU	$01

IO_UART_STATUS_READ	EQU	$01
IO_UART_STATUS_WRITE	EQU	$02


; Video

IO_VIDEO_BASE		EQU	$05

IO_VIDEO_CONTROL	EQU	$00
IO_VIDEO_VPOSR		EQU	$01

IO_VID_CTRL_P0EN	EQU	$01
IO_VID_CTRL_P1EN	EQU	$02

IO_VID_PLANE0_CONTROL	EQU	$10
IO_VID_PLANE0_HSCROLLL	EQU	$11
IO_VID_PLANE0_HSCROLLH	EQU	$12

IO_VID_PLANE1_CONTROL	EQU	$20
IO_VID_PLANE1_HSCROLLL	EQU	$21
IO_VID_PLANE1_HSCROLLH	EQU	$22

IO_PLANE_CTRL_HIRES	EQU	$02
IO_PLANE_CTRL_TEXT	EQU	$04
IO_PLANE_CTRL_PAL0	EQU	$00
IO_PLANE_CTRL_PAL1	EQU	$10
IO_PLANE_CTRL_PAL2	EQU	$20
IO_PLANE_CTRL_PAL3	EQU	$30
IO_PLANE_CTRL_PALMASK	EQU	$30


; Board id

IO_BOARD_ID_BASE	EQU	$7F
IO_BID_IDENTIFIER	EQU	$F0
IO_BID_DESCRIPTION	EQU	$F1

	ENDC
