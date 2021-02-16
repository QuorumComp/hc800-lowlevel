	IFND	MATH_I_INCLUDED_

MATH_I_INCLUDED_ = 1

MInt32:	MACRO	;integer
	DB	(\1)&$FF
	DB	(\1)>>8&$FF
	DB	(\1)>>16&$FF
	DB	(\1)>>24&$FF
	ENDM

	GLOBAL	MathMultiplySigned
	GLOBAL	MathDivideUnsigned
	GLOBAL	MathDivideSigned

	GLOBAL	MathLoadOperand16U
	GLOBAL	MathAdd_32_32
	GLOBAL	MathAdd_32_Operand

	GLOBAL	MathShift_32

	ENDC
