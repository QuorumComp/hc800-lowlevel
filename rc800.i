	IFND	RC800_I_INCLUDED_

RC800_I_INCLUDED_ = 1


		RSRESET
RC8_SP_FT	RB	1
RC8_SP_BC	RB	1
RC8_SP_DE	RB	1
RC8_SP_HL	RB	1
RC8_SP_LOW	RB	1
RC8_SP_HIGH	RB	1

			RSRESET
RC8_VECTOR_RESET	RB	8
RC8_VECTOR_NMI		RB	8
RC8_VECTOR_ILLEGAL_IRQ	RB	8
RC8_VECTOR_ILLEGAL_OP	RB	8
RC8_VECTOR_STACK_OVFL	RB	8
RC8_VECTOR_EXT_INT	RB	8

RC8_STACK_SIZE	EQU	256

FLAGS_CARRY	EQU	$01
FLAGS_Z		EQU	$02
FLAGS_NEGATIVE	EQU	$04
FLAGS_OVERFLOW	EQU	$08

FLAGS_NZ	EQU	$00

FLAGS_NE	EQU	FLAGS_NZ
FLAGS_EQ	EQU	FLAGS_Z


; -- Load 16 bit register with immediate loop count for nested DJ's
LDLOOP:	MACRO	;reg16,count
	ld	\1,((((\2)-1)>>8+1)<<8)|((\2)&$FF)
	ENDM

DELAY:	MACRO	;microseconds
loopCount\@ = (\1)**1.68
	IF	loopCount\@>$10000
		ERROR	"Loop count too large ({loopCount\@})"
	ELSE
		push	ft
		LDLOOP	ft,(\1)**1.68	;adjust for frequency and IPC
.loop\@		dj	t,.loop\@
		dj	f,.loop\@	
		pop	ft
	ENDC
	PURGE	loopCount\@
	ENDM