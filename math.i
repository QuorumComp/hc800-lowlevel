	IFND	MATH_I_INCLUDED_

MATH_I_INCLUDED_ = 1

MInt32:	MACRO	;integer
	DB	(\1)&$FF
	DB	(\1)>>8&$FF
	DB	(\1)>>16&$FF
	DB	(\1)>>24&$FF
	ENDM

	GLOBAL	MathMultiplySigned_16_16
	GLOBAL	MathDivideUnsigned_32_16
	GLOBAL	MathDivideSigned_32_16
	GLOBAL	MathMultiplyUnsigned_32_16

	GLOBAL	MathLoadOperand16U
	GLOBAL	MathLoadOperand16S
	GLOBAL	MathAdd_32_32
	GLOBAL	MathAdd_32_Operand

	GLOBAL	MathShift_32

	GLOBAL	MathLog2_16

	ENDC
