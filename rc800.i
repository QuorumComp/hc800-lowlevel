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
FLAGS_ZERO	EQU	$02
FLAGS_NEGATIVE	EQU	$04
FLAGS_OVERFLOW	EQU	$08

FLAGS_Z		EQU	FLAGS_ZERO
FLAGS_NZ	EQU	$00

FLAGS_NE	EQU	FLAGS_NZ
FLAGS_EQ	EQU	FLAGS_Z


; -- Load 16 bit register with immediate loop count for nested DJ's
MLDLoop:	MACRO	;reg16,count
	ld	\1,((((\2)-1)>>8+1)<<8)|((\2)&$FF)
	ENDM

MDelay:	MACRO	;microseconds
loopCount\@ = (\1)**1.68 ;adjust for frequency and IPC
	IF	loopCount\@>$10000
		ERROR	"Loop count too large ({loopCount\@})"
	ELSE
		push	ft
		MLDLoop	ft,loopCount\@
.loop\@		dj	t,.loop\@
		dj	f,.loop\@	
		pop	ft
	ENDC
	PURGE	loopCount\@
	ENDM


MMove32:	MACRO
	; -- MMove32 r1,r2
	; -- Pop r2:r2' and push to r1:r1'
	IF	__NARG==2
		swap	\2
		push	\1
		ld	\1,\2
		push	\1
		pop	\2
		ld	\1,\2
		pop	\2
	ELSE
		FAIL	"Two operands needed"
	ENDC
	ENDM

MPop32:	MACRO
	; -- MPop32 (r),ft  note: r must not be FT
	; -- Pop long word from FT stack into memory
	; --
	; -- MPop32 (ft),r  note: r must not be FT
	; -- Pop long word from r stack into memory

	; -- MPop32 (r),ft  note: r must not be FT
	IF __NARG==2&&"\2".lower=="ft"&&("\1".lower=="(bc)"||"\1".lower=="(de)"||"\1".lower=="(hl)")
dst__\@ EQUS "\1".slice(1,2)
		ld	\1,t
		add	dst__\@,1
		exg	f,t
		ld	\1,t
		add	dst__\@,1
		pop	ft
		ld	\1,t
		add	dst__\@,1
		exg	f,t
		ld	\1,t
		sub	dst__\@,3
		pop	ft
		MEXIT
	ENDC

	; -- MPop32 (ft),r  note: r must not be FT
	IF __NARG==2&&"\1".lower=="(ft)"&&("\2".lower=="bc"||"\2".lower=="de"||"\2".lower=="hl")
hi__\@	EQUS "\2".slice(0,1)
lo__\@	EQUS "\2".slice(1,1)
		add	ft,3
		ld	(ft),hi__\@
		sub	ft,1
		ld	(ft),lo__\@
		sub	ft,1
		pop	\2
		ld	(ft),hi__\@
		sub	ft,1
		ld	(ft),lo__\@
		pop	\2
		MEXIT
	ENDC

	FAIL "Invalid arguments for MPop32"

	ENDM

MLoad32:	MACRO
	; -- MLoad32 ft,(r)  note: r must not be FT
	; -- Load little endian long word onto FT stack (overwriting current FT top, FT stack grows by one word)
	; --
	; -- MLoad32 r,(ft)  note: r must not be FT
	; -- Load little endian long word onto R stack (overwriting current R top, R stack grows by one word)
	; --
	; -- MLoad32 r,n32
	; -- Push 32 bit value onto r stack

	; MLoad32 r16,(r16)
	IF __NARG==2 && ("\2".lower=="(bc)"||"\2".lower=="(de)"||"\2".lower=="(hl)") && ("\1".lower=="bc"||"\1".lower=="de"||"\1".lower=="hl")
src__\@		EQUS	"\2".slice(1,2)
		IF	|src__\@|=="\1"
			FAIL "Invalid operands"
		ENDC
		exg	ft,src__\@
		MLoad32	\1,(ft)
		exg	ft,src__\@
		PURGE	src__\@
		MEXIT
	ENDC

	; MLoad32 r16,(ft)
	IF __NARG==2 && "\2".lower=="(ft)" && ("\1".lower=="bc"||"\1".lower=="de"||"\1".lower=="hl")
hi__\@	EQUS "\1".slice(0,1)
lo__\@	EQUS "\1".slice(1,1)
		ld	lo__\@,(ft)
		add	ft,1
		ld	hi__\@,(ft)
		push	\1
		add	ft,1

		ld	lo__\@,(ft)
		add	ft,1
		ld	hi__\@,(ft)
		sub	ft,1
		MEXIT
	ENDC

	; MLoad32 ft,(r16)
	IF __NARG==2 && "\1".lower=="ft" && ("\2".lower=="(bc)"||"\2".lower=="(de)"||"\2".lower=="(hl)")
src__\@ EQUS "\2".slice(1,2)
		add	src__\@,1
		ld	t,\2
		exg	f,t
		sub	src__\@,1
		ld	t,\2
		push	ft

		add	src__\@,3
		ld	t,\2
		exg	f,t
		sub	src__\@,1
		ld	t,\2

		sub	src__\@,2
		PURGE	src__\@
		MEXIT
	ENDC

	;MLoad32 r16,n32
	IF __NARG==2&&("\1".lower=="ft"||"\1".lower=="bc"||"\1".lower=="de"||"\1".lower=="hl")
		ld	\1,(\2)&$FFFF
		push	\1
		IF (((\2)>>16)&$FFFF)~=((\2)&$FFFF)
			ld	\1,((\2)>>16)&$FFFF
		ENDC
		MEXIT
	ENDC

	FAIL "Invalid arguments for MLoad32"

	ENDM

MPush32:	MACRO
	; -- MPush32 r
	; -- Duplicate r:r'
	; --
	; -- MPush32 r1,r2   note: must not be same register
	; -- Push r2:r2' onto r1 stack
	; -- 
	; -- MPush32 r1,(r2) 
	; -- Push little endian long word onto R1 stack
	; --
	; -- MPush32 r,(ft)  note: r must not be FT
	; -- Push little endian long word onto r stack
	; --
	; -- MPush32 r,n32
	; -- Push 32 bit value onto r stack

	; MPush32 r16
	IF __NARG==1&&("\1".lower=="ft"||"\1".lower=="bc"||"\1".lower=="de"||"\1".lower=="hl")
		IF "\1"=="ft"
tmp__\@ EQUS "bc"
		ELSE
tmp__\@ EQUS "ft"
		ENDC

		push	tmp__\@

		swap	\1		;h,l
		ld	tmp__\@,\1
		swap	\1		;l,h
		push	\1		;l,l,h
		push	\1		;l,l,l,h
		ld	\1,tmp__\@	;h,l,l,h
		swap	\1		;l,h,l,h

		pop	tmp__\@
		PURGE	tmp__\@
		MEXIT
	ENDC

	; MPush32 r16,r16
	IF __NARG==2&&("\2".lower=="ft"||"\2".lower=="bc"||"\2".lower=="de"||"\2".lower=="hl")
		IF "\1".lower=="\2".lower
			FAIL "Cannot push to the same register"
		ENDC
		push	\1
		swap	\2
		ld	\1,\2
		push	\1
		swap	\2
		ld	\1,\2
		MEXIT
	ENDC

	; MPush32 r16,(ft)
	IF __NARG==2 && ("\2".lower=="(ft)"||"\2".lower=="(bc)"||"\2".lower=="(de)"||"\2".lower=="(hl)") && ("\1".lower=="ft"||"\1".lower=="bc"||"\1".lower=="de"||"\1".lower=="hl")
		push	\1
		MLoad32	\1,\2
		MEXIT
	ENDC

	;MPush32 r16,n32
	IF __NARG==2 && ("\1".lower=="ft"||"\1".lower=="bc"||"\1".lower=="de"||"\1".lower=="hl")
		push	\1
		MLoad32 \1,\2
		MEXIT
	ENDC

	FAIL "Invalid arguments for MPush32"

	ENDM
