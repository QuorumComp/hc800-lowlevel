		INCLUDE	"hc800.i"
		INCLUDE	"math.i"
		INCLUDE	"rc800.i"



; ---------------------------------------------------------------------------
; -- Multiply two integers
; --
; -- Inputs:
; --   ft:ft' - multiplicand (consumed)
; --   bc     - multiplier
; --
; -- Outputs:
; --   ft:ft' - result
; --
		SECTION	"MathMultiplyUnsigned_32x16_p32",CODE
MathMultiplyUnsigned_32x16_p32:
		push	bc-hl

		ld	bc,0
		jal	MathMultiplyUnsigned_32x32_p32

		pop	bc-hl
		j	(hl)


; ---------------------------------------------------------------------------
; -- Multiply two integers
; --
; -- Inputs:
; --   ft:ft' - multiplicand (consumed)
; --   bc:bc' - multiplier
; --
; -- Outputs:
; --   ft:ft' - result
; --
		SECTION	"MathMultiplySigned_32x32_p32",CODE
MathMultiplySigned_32x32_p32:
		push	de-hl

		ld	d,IO_MATH_BASE

		; load multiplicand into X
		ld	e,IO_MATH_X
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t
		pop	ft
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t

		; load multiplier into Y
		ld	e,IO_MATH_Y
		ld	t,b
		lio	(de),t
		ld	t,c
		lio	(de),t
		swap	bc
		ld	t,b
		lio	(de),t
		ld	t,c
		lio	(de),t
		swap	bc

		; multiply
		ld	e,IO_MATH_OPERATION
		ld	t,MATH_OP_SIGNED_MUL
		lio	(de),t

		nop
		nop
		nop

		; load Z into ft:ft'
		ld	e,IO_MATH_Z
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t
		push	ft
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t

		pop	de-hl
		j	(hl)


; ---------------------------------------------------------------------------
; -- Multiply two integers
; --
; -- Inputs:
; --   ft:ft' - multiplicand (consumed)
; --   bc:bc' - multiplier
; --
; -- Outputs:
; --   ft:ft' - result
; --
		SECTION	"MathMultiplyUnsigned_32x32_p32",CODE
MathMultiplyUnsigned_32x32_p32:
		push	de-hl

		ld	d,IO_MATH_BASE

		; load multiplicand into X
		ld	e,IO_MATH_X
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t
		pop	ft
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t

		; load multiplier into Y
		ld	e,IO_MATH_Y
		ld	t,b
		lio	(de),t
		ld	t,c
		lio	(de),t
		swap	bc
		ld	t,b
		lio	(de),t
		ld	t,c
		lio	(de),t
		swap	bc

		; multiply
		ld	e,IO_MATH_OPERATION
		ld	t,MATH_OP_UNSIGNED_MUL
		lio	(de),t

		nop
		nop
		nop

		; load Z into ft:ft'
		ld	e,IO_MATH_Z
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t
		push	ft
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t

		pop	de-hl
		j	(hl)


; ---------------------------------------------------------------------------
; -- Multiply two integers
; --
; -- Inputs:
; --   ft - integer #1
; --   bc - integer #2
; --
; -- Outputs:
; --   ft:ft' - 32 bit result (one word pushed)
; --
		SECTION	"MathMultiplySigned_16x16_p32",CODE
MathMultiplySigned_16x16_p32:
		pusha

		rsa	ft,15
		push	ft
		ld	ft,bc
		rsa	ft,15
		ld	bc,ft
		pop	ft
		jal	MathMultiplySigned_32x32_p32

		pop	bc-hl
		j	(hl)




; ---------------------------------------------------------------------------
; -- Multiply two integers
; --
; -- Inputs:
; --   ft - integer #1
; --   bc - integer #2
; --
; -- Outputs:
; --   ft:ft' - 32 bit result (one word pushed)
; --
		SECTION	"MathMultiplyUnsigned_16x16_p32",CODE
MathMultiplyUnsigned_16x16_p32:
		pusha

		ld	ft,0
		ld	bc,0
		jal	MathMultiplyUnsigned_32x32_p32

		pop	bc-hl
		j	(hl)


; ---------------------------------------------------------------------------
; -- Divide two integers
; --
; -- Inputs:
; --   ft:ft' - dividend
; --   bc     - divisor
; --
; -- Outputs:
; --   ft  - remainder
; --   ft' - quotient
; --
		SECTION	"MathDivideUnsigned_32by16_q16_r16",CODE
MathDivideUnsigned_32by16_q16_r16:
		push	bc-hl

		ld	d,IO_MATH_BASE

		; load Z with dividend

		ld	e,IO_MATH_Z
		push	ft
		ld	t,0
		lio	(de),t
		lio	(de),t
		lio	(de),t
		lio	(de),t
		pop	ft
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t
		pop	ft
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t

		; load Y with divisor

		ld	e,IO_MATH_Y
		ld	t,0
		lio	(de),t
		lio	(de),t
		ld	ft,bc
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t

		; start operation

		ld	e,IO_MATH_OPERATION
		ld	t,MATH_OP_UNSIGNED_DIV
		lio	(de),t

		nop
		nop
		nop

		; get quotient

		ld	e,IO_MATH_X
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t
		push	ft

		; get remainder

		ld	e,IO_MATH_Y
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t

		pop	bc-hl
		j	(hl)


; ---------------------------------------------------------------------------
; -- Divide two integers
; --
; -- Inputs:
; --   ft:ft' - dividend (consumed)
; --   bc:bc' - divisor
; --
; -- Outputs:
; --   ft:ft'     - remainder
; --   ft'':ft''' - quotient
; --
		SECTION	"MathDivideUnsigned_32by32_q32_r32",CODE
MathDivideUnsigned_32by32_q32_r32:
		push	de

		ld	d,IO_MATH_BASE

		; load Z with dividend

		ld	e,IO_MATH_Z
		push	ft
		ld	t,0
		lio	(de),t
		lio	(de),t
		lio	(de),t
		lio	(de),t
		pop	ft
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t
		pop	ft
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t

		; load Y with divisor

		ld	e,IO_MATH_Y
		ld	ft,bc
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t
		swap	bc
		ld	ft,bc
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t
		swap	bc

		; start operation

		ld	e,IO_MATH_OPERATION
		ld	t,MATH_OP_UNSIGNED_DIV
		lio	(de),t

		nop
		nop
		nop

		; get quotient

		ld	e,IO_MATH_X
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t
		push	ft
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t
		push	ft

		; get remainder

		ld	e,IO_MATH_Y
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t
		push	ft
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t

		pop	de
		j	(hl)


; ---------------------------------------------------------------------------
; -- Divide two integers
; --
; -- Inputs:
; --   ft:ft' - dividend
; --   bc     - divisor
; --
; -- Outputs:
; --   ft  - remainder
; --   ft' - quotient
; --
		SECTION	"MathDivideSigned_32by16_q16_r16",CODE
MathDivideSigned_32by16_q16_r16:
		push	bc-hl

		ld	d,IO_MATH_BASE

		; load Z with dividend

		ld	e,IO_MATH_Z
		push	ft
		rsa	ft,15	; sign extend
		lio	(de),t
		lio	(de),t
		lio	(de),t
		lio	(de),t
		pop	ft
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t
		pop	ft
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t

		; load Y with divisor

		ld	e,IO_MATH_Y
		ld	ft,bc
		rsa	ft,15	; sign extend
		lio	(de),t
		lio	(de),t
		ld	ft,bc
		exg	f,t
		lio	(de),t
		exg	f,t
		lio	(de),t

		; start operation

		ld	e,IO_MATH_OPERATION
		ld	t,MATH_OP_SIGNED_DIV
		lio	(de),t

		nop
		nop
		nop

		; get quotient

		ld	e,IO_MATH_X
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t
		push	ft

		; get remainder

		ld	e,IO_MATH_Y
		lio	t,(de)
		exg	f,t
		lio	t,(de)
		exg	f,t

		pop	bc-hl
		j	(hl)

; ---------------------------------------------------------------------------
; -- Add two 32 bit integers
; --
; -- Inputs:
; --   ft:ft' - integer #1 (consumed)
; --   bc:bc' - integer #2
; --
; -- Outputs:
; --   ft:ft' - integer
; --
		SECTION	"MathAdd_32_32",CODE
MathAdd_32_32:
		push	de-hl

		ld	l,2
		ld	d,0
.expand		exg	f,t

		ld	e,t
		push	de

		ld	t,b
		ld	e,t
		push	de

		exg	f,t
		ld	e,t
		push	de

		ld	t,c
		ld	e,t
		push	de
		
		pop	ft
		swap	bc

		dj	l,.expand

		push	ft	; save user's content

		; de stack contains four zero extended bytes pairs, low pair on top
		ld	l,4
		ld	ft,0
.add_bytes	pop	de
		add	ft,de
		pop	de
		add	ft,de
		push	ft
		rs	ft,8	; carry for next add
		dj	l,.add_bytes

		; ft stack contains four words where f should be ignored and t is a byte of the result
		; high byte on top

		pop	ft
		ld	d,t
		pop	ft
		ld	e,t
		push	de	; high word of result in DE

		pop	ft
		ld	d,t
		pop	ft
		ld	e,t
		ld	ft,de
		push	ft	; low word of result

		pop	de
		ld	ft,de	; high word of result in FT

		; ft:ft' = result

		pop	de-hl
		j	(hl)


; ---------------------------------------------------------------------------
; -- Shift 32 integer to the left
; --
; -- Inputs:
; --   ft:ft' - integer (consumed)
; --        b - shift amount
; --
; -- Outputs:
; --   ft:ft' - integer
; --
		SECTION	"MathShiftLeft_32",CODE
MathShiftLeft_32:
		push	ft-de

		cmp	b,0	; Don't shift?
		j/ne	.not_zero

		pop	ft-de
		j	(hl)

.not_zero	cmp	b,16	; shift more than 16 positions?
		j/geu	.simple

		ld	t,16
		sub	t,b
		ld	c,t	; c = amount to right shift to get the part that is shifted into high word

		pop	ft

		swap	ft
		ld	de,ft
		rs	ft,c
		exg	de,ft	; de = part that spills into high word
		ls	ft,b
		swap	ft

		ls	ft,b
		or	t,e
		exg	f,t
		or	t,d
		exg	f,t

		pop	bc/de
		j	(hl)


.simple		pop	ft
		ld	ft,0
		swap	ft
		ls	ft,b

		pop	bc/de
		j	(hl)		


; ---------------------------------------------------------------------------
; -- Shift 32 integer to the right
; --
; -- Inputs:
; --   ft:ft' - integer (consumed)
; --        b - shift amount
; --
; -- Outputs:
; --   ft:ft' - integer
; --
		SECTION	"MathShiftRight_32",CODE
MathShiftRight_32:
		push	ft-de

		cmp	b,0	; Don't shift?
		j/ne	.not_zero
		
		pop	ft-de
		j	(hl)

.not_zero	cmp	b,16	; shift more than 16 positions?
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
		j	.exit

.done		ld	f,FLAGS_EQ
.exit		ld	t,d
		pop	bc/de
		j	(hl)


; ---------------------------------------------------------------------------
; -- Store value in FT:FT' as little endian 32 bit value
; --
; -- Inputs:
; --   ft:ft' - integer (consumed)
; --   bc - pointer to value
; --
		SECTION	"MathStoreLong",CODE
MathStoreLong:
		add	bc,2
		ld	(bc),t

		exg	f,t
		add	bc,1
		ld	(bc),t

		pop	ft

		sub	bc,3
		ld	(bc),t

		add	bc,1
		exg	f,t
		ld	(bc),t

		sub	bc,1

		j	(hl)


; ---------------------------------------------------------------------------
; -- Push zero extended little endian 16 bit value onto FT stack
; --
; -- Inputs:
; --   bc - pointer to value
; --
; -- Outputs:
; --   ft:ft' - value
; --
		SECTION	"MathLoadUWord",CODE
MathLoadUWord:
		push	ft
		add	bc,1
		ld	t,(bc)
		exg	f,t
		sub	bc,1
		ld	t,(bc)
		MZeroExtend ft
		j	(hl)

; ---------------------------------------------------------------------------
; -- Push little endian 32 bit value onto FT stack
; --
; -- Inputs:
; --   bc - pointer to value
; --
; -- Outputs:
; --   ft:ft' - value
; --
		SECTION	"MathLoadLong",CODE
MathLoadLong:
		MLoad32	ft,(bc)
		j	(hl)


; ---------------------------------------------------------------------------
; -- Duplicate (or "push") the top 32 bit value in FT:FT'
; --
; -- Inputs:
; --   ft:ft' - value to duplicate
; --
; -- Outputs:
; --   ft:ft' - value
; --   ft'':ft''' - value
; --
		SECTION	"MathDupLong",CODE
MathDupLong:
		MPush32	ft
		j	(hl)


; ---------------------------------------------------------------------------
; -- Compare 32 bit values
; --
; -- Inputs:
; --   ft:ft' - comparand (consumed)
; --   bc:bc' - comparer
; --
; -- Outputs:
; --   f - result
; --
		SECTION	"MathCompareLong",CODE
MathCompareLong:
		cmp	ft,bc
		j/eq	.lo

		swap	ft
		pop	ft
		j	(hl)

.lo		swap	bc
		pop	ft
		cmp	ft,bc

		; adjust flags so signed result is equal to unsigned result
		; - clear overflow flag
		; - if carry is set, set negative flag
		ld	t,f
		and	t,FLAGS_CARRY|FLAGS_ZERO
		or/c	t,FLAGS_NEGATIVE
		ld	f,t

		swap	bc
		swap	ft
		pop	ft
		j	(hl)


