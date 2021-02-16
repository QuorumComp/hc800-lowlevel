		INCLUDE	"hc800.i"
		INCLUDE	"math.i"

; ---------------------------------------------------------------------------
; -- Multiply two integers
; --
; -- Inputs:
; --   ft - integer #1
; --   de - integer #2
; --
; -- Outputs:
; --   de:ft - 32 bit result
; --
		SECTION	"MathMultiplySigned",CODE
MathMultiplySigned:
		push	bc

		ld	b,IO_MATH_BASE
		ld	c,IO_MATH_X

		exg	f,t
		lio	(bc),t
		exg	f,t
		lio	(bc),t

		add	c,1

		ld	t,d
		lio	(bc),t
		ld	t,e
		lio	(bc),t

		ld	c,IO_MATH_OPERATION
		ld	t,MATH_OP_SIGNED_MUL
		lio	(bc),t

		nop
		ld	c,IO_MATH_Z

		lio	t,(bc)
		ld	e,t
		lio	t,(bc)
		ld	d,t

		lio	t,(bc)
		exg	f,t
		lio	t,(bc)
		exg	f,t

		pop	bc
		j	(hl)


DIVIDE:		MACRO
		push	bc

		ld	b,IO_MATH_BASE
		ld	c,IO_MATH_Y

		exg	f,t
		lio	(bc),t
		exg	f,t
		lio	(bc),t

		add	c,1

		ld	t,d
		lio	(bc),t
		ld	t,e
		lio	(bc),t

		pop	de

		ld	t,d
		lio	(bc),t
		ld	t,e
		lio	(bc),t

		ld	c,IO_MATH_OPERATION
		ld	t,\1
		lio	(bc),t

		nop
		ld	c,IO_MATH_Y

		lio	t,(bc)
		ld	e,t
		lio	t,(bc)
		ld	d,t

		sub	c,1

		lio	t,(bc)
		exg	f,t
		lio	t,(bc)
		exg	f,t

		pop	bc
		j	(hl)
		ENDM


; ---------------------------------------------------------------------------
; -- Divide two integers
; --
; -- Inputs:
; --   ft   - divisor
; --   de*2 - dividend (2*16 bit, high word on top)
; --
; -- Outputs:
; --   ft - quotient
; --   de - remainder
; --
		SECTION	"MathDivideUnsigned",CODE
MathDivideUnsigned:
		DIVIDE	MATH_OP_UNSIGNED_DIV


; ---------------------------------------------------------------------------
; -- Divide two integers
; --
; -- Inputs:
; --   ft   - divisor
; --   de*2 - dividend (2*16 bit, high word on top)
; --
; -- Outputs:
; --   ft - quotient
; --   de - remainder
; --
		SECTION	"MathDivideSigned",CODE
MathDivideSigned:
		DIVIDE	MATH_OP_SIGNED_DIV


; ---------------------------------------------------------------------------
; -- Add temp to 32 bit integer
; --
; -- Inputs:
; --   bc - pointer to integer #1, and result
; --
		SECTION	"MathAdd_32_Operand",CODE
MathAdd_32_Operand:
		pusha

		ld	de,temp
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
; -- Load 16 bit unsigned integer into temp storage
; --
; -- Inputs:
; --   ft - integer
; --
		SECTION	"MathLoadOperand16U",CODE
MathLoadOperand16U:
		pusha

		ld	bc,temp
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
; -- Shift 32 integer to the left
; --
; -- Inputs:
; --    t - shift amount
; --   bc - pointer to integer #1, and result
; --
		SECTION	"MathShift_32",CODE
MathShift_32:
		push	ft-de

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

		pop	ft-de
		j	(hl)


		SECTION	"MathVars",BSS
temp:		DS	4