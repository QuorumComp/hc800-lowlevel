		INCLUDE	"hc800.i"
		INCLUDE	"math.i"
		INCLUDE	"rc800.i"

; ---------------------------------------------------------------------------
; -- Multiply two integers
; --
; -- Inputs:
; --   bc - pointer to multiplicand and result
; --   ft - multiplier
; --
		SECTION	"MathMultiplyUnsigned_32x16_p32",CODE
MathMultiplyUnsigned_32x16_p32:
		pusha

		ld	d,IO_MATH_BASE

		; load multiplier into X

		ld	e,IO_MATH_X
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t

		; load lo word of multiplicand into Y

		ld	e,IO_MATH_Y
		add	bc,1
		ld	t,(bc)
		lio	(de),t
		sub	bc,1
		ld	t,(bc)
		lio	(de),t
		add	bc,3

		; multiply

		ld	e,IO_MATH_OPERATION
		ld	t,MATH_OP_UNSIGNED_MUL
		lio	(de),t

		; load result into operand

		ld	e,IO_MATH_Z
		ld	hl,operand
		REPT	3
		lio	t,(de)
		ld	(hl),t
		add	hl,1
		ENDR
		lio	t,(de)
		ld	(hl),t

		; load hi word of multiplicand

		ld	e,IO_MATH_Y
		ld	t,(bc)
		lio	(de),t
		sub	bc,1
		ld	t,(bc)
		lio	(de),t
		sub	bc,2

		; multiply

		ld	e,IO_MATH_OPERATION
		ld	t,MATH_OP_UNSIGNED_MUL
		lio	(de),t

		; load result into pointer

		ld	e,IO_MATH_Z

		ld	t,0
		ld	(bc),t
		add	bc,1
		ld	(bc),t
		add	bc,1

		lio	t,(de)
		ld	(bc),t
		add	bc,1
		lio	t,(de)
		ld	(bc),t
		sub	bc,3

		; add results
		jal	MathAdd_32_Operand

		popa
		j	(hl)


; ---------------------------------------------------------------------------
; -- Multiply two integers
; --
; -- Inputs:
; --   ft - integer #1
; --   bc - integer #2
; --
; -- Outputs:
; --   bc:ft - 32 bit result
; --
		SECTION	"MathMultiplySigned_16x16_p32",CODE
MathMultiplySigned_16x16_p32:
		push	de

		ld	d,IO_MATH_BASE
		ld	e,IO_MATH_X

		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t

		ld	e,IO_MATH_Y

		ld	t,b
		lio	(de),t
		ld	t,c
		lio	(de),t

		ld	e,IO_MATH_OPERATION
		ld	t,MATH_OP_SIGNED_MUL
		lio	(de),t

		nop
		ld	e,IO_MATH_Z

		lio	t,(de)
		ld	c,t
		lio	t,(de)
		ld	b,t

		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t

		pop	de
		j	(hl)


DIVIDE:		MACRO
		push	de

		ld	d,IO_MATH_BASE
		ld	e,IO_MATH_Y

		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t

		ld	e,IO_MATH_Z

		ld	t,b
		lio	(de),t
		ld	t,c
		lio	(de),t

		pop	bc

		ld	t,b
		lio	(de),t
		ld	t,c
		lio	(de),t

		ld	e,IO_MATH_OPERATION
		ld	t,\1
		lio	(de),t

		nop
		ld	e,IO_MATH_Y

		lio	t,(de)
		ld	c,t
		lio	t,(de)
		ld	b,t

		ld	e,IO_MATH_X

		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t

		pop	de
		j	(hl)
		ENDM


; ---------------------------------------------------------------------------
; -- Divide two integers
; --
; -- Inputs:
; --   ft   - divisor
; --   bc*2 - dividend (2*16 bit, high word on top)
; --
; -- Outputs:
; --   ft - quotient
; --   bc - remainder
; --
		SECTION	"MathDivideUnsigned_32_16",CODE
MathDivideUnsigned_32_16:
		DIVIDE	MATH_OP_UNSIGNED_DIV


; ---------------------------------------------------------------------------
; -- Divide two integers
; --
; -- Inputs:
; --   ft   - divisor
; --   bc*2 - dividend (2*16 bit, high word on top)
; --
; -- Outputs:
; --   ft - quotient
; --   bc - remainder
; --
		SECTION	"MathDivideSigned_32by16_q16_r16",CODE
MathDivideSigned_32by16_q16_r16:
		DIVIDE	MATH_OP_SIGNED_DIV


; ---------------------------------------------------------------------------
; -- Copy 32 bit integer
; --
; -- Inputs:
; --   bc - pointer to result
; --   de - pointer to source
; --
		SECTION	"MathCopy_32",CODE
MathCopy_32:
		pusha

		ld	f,4
.loop		ld	t,(de)
		ld	(bc),t
		add	de,1
		add	bc,1
		dj	f,.loop

		popa
		j	(hl)

; ---------------------------------------------------------------------------
; -- Add operand to 32 bit integer
; --
; -- Inputs:
; --   bc - pointer to integer #1, and result
; --
		SECTION	"MathAdd_32_Operand",CODE
MathAdd_32_Operand:
		pusha

		ld	de,operand
		jal	MathAdd_32_32

		popa
		j	(hl)

; ---------------------------------------------------------------------------
; -- Add two 32 bit integers
; --
; -- Inputs:
; --   bc - pointer to integer #1, and result
; --   de - pointer to integer #2
; --
		SECTION	"MathAdd_32_32",CODE
MathAdd_32_32:
		pusha

		ld	l,4
		ld	f,0
.loop		push	hl

		ld	t,(bc)
		ld	l,t
		ld	h,0
		add/c	hl,1
		ld	t,(de)
		ld	f,0
		add	ft,hl
		ld	(bc),t
		add	bc,1
		add	de,1

		pop	hl
		dj	l,.loop

		popa
		j	(hl)


; ---------------------------------------------------------------------------
; -- Load 16 bit unsigned integer into operand storage
; --
; -- Inputs:
; --   ft - integer
; --
		SECTION	"MathLoadOperand16U",CODE
MathLoadOperand16U:
		pusha

		ld	bc,operand
		ld	(bc),t
		add	bc,1
		exg	f,t
		ld	(bc),t
		add	bc,1
		ld	t,0
		ld	(bc),t
		add	bc,1
		ld	(bc),t

		popa
		j	(hl)


; ---------------------------------------------------------------------------
; -- Load 16 bit signed integer into operand storage
; --
; -- Inputs:
; --   ft - integer
; --
		SECTION	"MathLoadOperand16S",CODE
MathLoadOperand16S:
		pusha

		ld	bc,operand
		ld	(bc),t
		add	bc,1
		exg	f,t
		ld	(bc),t
		add	bc,1
		ext
		exg	f,t
		ld	(bc),t
		add	bc,1
		ld	(bc),t

		popa
		j	(hl)


; ---------------------------------------------------------------------------
; -- Shift 32 integer to the left
; --
; -- Inputs:
; --    t - shift amount
; --   bc - pointer to integer #1, and result
; --
		SECTION	"MathShiftLeft_32",CODE
MathShiftLeft_32:
		pusha

		and	t,31
		ld	e,t

		add	bc,3

.shift_byte	cmp	e,8
		j/ltu	.shift_partial

		sub	bc,1
		ld	f,3
.shift_b_loop	ld	t,(bc)
		add	bc,1
		ld	(bc),t
		sub	bc,2
		dj	f,.shift_b_loop
		add	bc,1
		ld	t,0
		ld	(bc),t
		add	bc,3

		sub	e,8
		j	.shift_byte

.shift_partial	ld	d,3
.shift_p_loop	ld	t,(bc)
		exg	f,t
		sub	bc,1
		ld	t,(bc)
		ls	ft,e
		exg	f,t
		add	bc,1
		ld	(bc),t
		sub	bc,1
		dj	d,.shift_p_loop

		ld	t,(bc)
		ls	ft,e
		ld	(bc),t

		popa
		j	(hl)


; ---------------------------------------------------------------------------
; -- Shift 32 integer to the right
; --
; -- Inputs:
; --   ft:ft' - integer
; --        b - shift amount
; --
; -- Outputs:
; --   ft:ft' - integer
		SECTION	"MathShiftRight_32",CODE
MathShiftRight_32:
		push	ft-de

		cmp	b,16	; shift more than 16 positions?
		j/geu	.simple

		ld	t,16
		sub	t,b
		ld	c,t	; c = amount to left shift to get the part that is shifted into other word

		pop	ft
		ld	de,ft
		ls	ft,c
		exg	de,ft	; de = part that spills into lower word
		rs	ft,b

		swap	ft
		rs	ft,b
		or	t,e
		exg	f,t
		or	t,d
		exg	f,t

		swap	ft
		pop	bc/de
		j	(hl)


.simple		pop	ft
		rs	ft,b
		swap	ft
		ld	ft,0

		pop	bc/de
		j	(hl)		


; ---------------------------------------------------------------------------
; -- Log2 of FT (find first one)
; --
; -- Inputs:
; --   ft - integer
; --
; -- Outputs:
; --    t - log2 of FT (0 to 15)
; --    f - "ne" condition if FT == 0
; --
		SECTION	"MathLog2_16",CODE
MathLog2_16:
		push	bc/de

		ld	bc,ft

		ld	d,15
.loop		ld	t,b
		and	t,$80
		cmp	t,$80
		j/eq	.done
		ld	ft,bc
		ls	ft,1
		ld	bc,ft
		dj	d,.loop

		ld	f,FLAGS_NE

.done		ld	t,d
		pop	bc/de
		j	(hl)


; --
; -- Push little endian 32 bit value unto FT stack
; --
; -- Inputs:
; --   bc - pointer to value
; --
; -- Outputs:
; --   ft:ft' - value
; --
		SECTION	"MathLoadLong",CODE
MathLoadLong:
		push	bc/de

		push	ft

		ld	t,(bc)
		add	bc,1
		exg	f,t
		ld	t,(bc)
		add	bc,1
		exg	f,t

		push	ft
		ld	t,(bc)
		add	bc,1
		exg	f,t
		ld	t,(bc)
		exg	f,t

		swap	ft
		pop	bc/de
		j	(hl)


; --
; -- Duplicate (or "push") the top 32 bit value in FT:FT'
; --
; -- Inputs:
; --   ft:ft' - value to duplicate
; --
; -- Outputs:
; --   ft:ft':ft'':ft''' - value
; --
		SECTION	"MathDupLong",CODE
MathDupLong:
		push	bc

		swap	ft	;h,l
		ld	bc,ft
		swap	ft	;l,h
		push	ft	;l,l,h
		push	ft	;l,l,l,h
		ld	ft,bc	;h,l,l,h
		swap	ft	;l,h,l,h

		pop	bc
		j	(hl)


; --
; -- Compare 32 bit values
; --
; -- Inputs:
; --   ft:ft' - comparand
; --   bc:bc' - comparer
; --
; -- Outputs:
; --   ft:ft' consumed
; --   f - result
; --
		SECTION	"MathCompareLong",CODE
MathCompareLong:
		cmp	ft,bc
		j/eq	.lo

		swap	ft
		pop	ft
		swap	ft
		pop	ft
		j	(hl)

.lo		swap	bc
		pop	ft
		cmp	ft,bc
		swap	bc
		swap	ft
		pop	ft
		j	(hl)


		SECTION	"MathVars",BSS
operand:	DS	4
operand2:	DS	4
