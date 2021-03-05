	IFND	LOWLEVEL_STACK_I_INCLUDED__
LOWLEVEL_STACK_I_INCLUDED__ = 1

	GLOBAL	StackPointer

; ---------------------------------------------------------------------------
; -- Allocate and initialize a stack
; --
MStackInit:	MACRO	;size
		pusha
		ld	ft,StackArea
		ld	bc,StackPointer
		ld	(ft),c
		add	ft,1
		ld	(ft),b
		popa
		PUSHS
		SECTION	"StackArea",BSS_S
StackArea:	DS	\1
StackPointer::	DS	2
		POPS
		ENDM

; ---------------------------------------------------------------------------
; -- Allocate a number of bytes from the stack
; --
; -- Returns:
; --   ft - new memory
; --
MStackAlloc:	MACRO	;size
		push	bc
		ld	ft,StackPointer
		ld	c,(ft)
		add	ft,1
		ld	b,(ft)
		push	bc
		add	bc,\1
		ld	(ft),b
		sub	ft,1
		ld	(ft),c
		ld	ft,bc
		pop	bc
		ENDM

; ---------------------------------------------------------------------------
; -- Deallocate a number of bytes from the stack
; --
MStackFree:	MACRO	;size
		pusha
		ld	ft,StackPointer
		ld	c,(ft)
		add	ft,1
		ld	b,(ft)
		sub	bc,\1
		ld	(ft),b
		sub	ft,1
		ld	(ft),c
		popa
		ENDM

	ENDC
