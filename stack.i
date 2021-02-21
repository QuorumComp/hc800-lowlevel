	IFND	LOWLEVEL_STACK_I_INCLUDED__
LOWLEVEL_STACK_I_INCLUDED__ = 1

	GLOBAL	StackPointer

; ---------------------------------------------------------------------------
; -- Allocate and initialize a stack
; --
MStackInit:	MACRO	;size
		PUSHS
		SECTION	"StackArea",BSS_S
StackArea:	DS	\1
		SECTION	"Pointer",DATA
StackPointer:	DW	StackArea
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
		ld	bc,StackPointer+1
		ld	t,(bc)
		exg	f,t
		sub	bc,1
		ld	t,(bc)
		push	ft
		add	ft,\1
		ld	(bc),t
		add	bc,1
		exg	f,t
		ld	(bc),t
		pop	ft/bc
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
