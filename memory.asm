		INCLUDE	"memory.i"


; --
; -- Fill memory with little endian word
; --
; -- Input:
; --   ft - value
; --   bc - destination
; --   de - words to set
; --
		SECTION	"SetMemoryWords",CODE
SetMemoryWords:
		pusha

		tst	de
		j/z	.done

		sub	de,1
		add	d,1
		add	e,1

		pop	ft
		push	ft
		
		exg	bc,ft

.loop		ld	(ft),c
		add	ft,1
		ld	(ft),b
		add	ft,1
		dj	e,.loop
		dj	d,.loop
		
.done		popa
		j	(hl)


; --
; -- Fill memory with byte value
; --
; -- Input:
; --   bc - destination
; --   de - bytes to set
; --    t - value
; --
		SECTION	"SetMemory",CODE
SetMemory:
		pusha

		tst	de
		j/z	.done

		sub	de,1
		add	d,1
		add	e,1

.loop		ld	(bc),t
		add	bc,1
		dj	e,.loop
		dj	d,.loop
		
.done		popa
		j	(hl)

; --
; -- Copy bytes from code memory to data memory
; --
; -- Inputs:
; --   ft - bytes to copy. if 0, copy 256 bytes
; --   bc - destination
; --   de - source
; --
		SECTION	"CopyCode",CODE
CopyCode:
		pusha

		ld	hl,ft
		sub	hl,1
		add	h,1
		add	l,1

.next		lco	t,(de)
		add	de,1
		ld	(bc),t
		add	bc,1
		dj	l,.next
		dj	h,.next

		popa
		j	(hl)
