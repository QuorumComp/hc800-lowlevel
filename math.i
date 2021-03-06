	IFND	MATH_I_INCLUDED_

MATH_I_INCLUDED_ = 1

MInt32:	MACRO	;integer
	DB	(\1)&$FF
	DB	(\1)>>8&$FF
	DB	(\1)>>16&$FF
	DB	(\1)>>24&$FF
	ENDM

	GLOBAL	MathCopy_32

	GLOBAL	MathMultiplySigned_16x16_p32
	GLOBAL	MathMultiplyUnsigned_32x16_p32
	GLOBAL	MathDivideUnsigned_32_16
	GLOBAL	MathDivideSigned_32by16_q16_r16

	GLOBAL	MathLoadOperand16U
	GLOBAL	MathLoadOperand16S
	GLOBAL	MathAdd_32_32
	GLOBAL	MathAdd_32_Operand

	GLOBAL	MathShiftLeft_32
	GLOBAL	MathShiftRight_32

	GLOBAL	MathLog2_16

	GLOBAL	MathLoadLong

	GLOBAL	MathDupLong
	GLOBAL	MathCompareLong

	ENDC
