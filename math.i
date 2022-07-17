	IFND	MATH_I_INCLUDED_

MATH_I_INCLUDED_ = 1

MInt32:	MACRO	;integer
	DB	(\1)&$FF
	DB	(\1)>>8&$FF
	DB	(\1)>>16&$FF
	DB	(\1)>>24&$FF
	ENDM

MZeroExtend:	MACRO	;register
	push	\1
	ld	\1,0
	ENDM

MSignExtend:	MACRO	;FT
	IF __NARG~=0
		FAIL "MSignExtend does not accept arguments"
	ENDC
	push	ft
	rsa	ft,15
	ENDM


	GLOBAL	MathCopy_32

	GLOBAL	MathMultiplySigned_16x16_p32
	GLOBAL	MathMultiplySigned_32x32_p32
	GLOBAL	MathMultiplyUnsigned_16x16_p32
	GLOBAL	MathMultiplyUnsigned_32x16_p32
	GLOBAL	MathMultiplyUnsigned_32x32_p32
	GLOBAL	MathDivideSigned_32by16_q16_r16
	GLOBAL	MathDivideUnsigned_32by16_q16_r16
	GLOBAL	MathDivideUnsigned_32by32_q32_r32

	GLOBAL	MathAdd_32_32

	GLOBAL	MathShiftLeft_32
	GLOBAL	MathShiftRight_32

	GLOBAL	MathLog2_16

	GLOBAL	MathLoadUWord
	GLOBAL	MathLoadLong
	GLOBAL	MathStoreLong

	GLOBAL	MathDupLong
	GLOBAL	MathCompareLong

	GLOBAL	DecimalLongWidth

	ENDC
