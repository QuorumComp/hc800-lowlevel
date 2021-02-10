		INCLUDE	"uart.i"
		INCLUDE	"hc800.i"
		INCLUDE	"nexys3.i"
		INCLUDE	"rc800.i"

		GLOBAL	VideoIsVBlankEdge


; --
; -- Read byte asynchronously from UART
; --
; -- Outputs:
; --    f - "eq" condition if data available
; --    t - byte read
; --
		SECTION	"UartByteIn",CODE
UartByteIn:
		push	hl

		jal	UartCanRead
		j/ne	.done

		ld	h,IO_UART_BASE
		ld	l,IO_UART_DATA
		lio	t,(hl)

.done		pop	hl
		j	(hl)


; --
; -- Read byte synchronously from UART
; --
; -- Outputs:
; --    f - "eq" condition if byte read, "ne" if timeout
; --    t - byte read
; --
		SECTION	"UartByteInSync",CODE
UartByteInSync:
		push	bc/hl

		ld	b,TIMEOUT_FRAMES
.wait_frame	jal	UartByteIn
		j/eq	.done

		jal	VideoIsVBlankEdge
		sub/eq	b,1
		cmp	b,0
		j/nz	.wait_frame

		ld	f,FLAGS_NE

.done		pop	bc/hl
		j	(hl)


; --
; -- Determine if data is available to read
; --
; -- Outputs:
; --    f - "eq" condition if data is available
; --
		SECTION	"UartCanRead",CODE
UartCanRead:
		push	hl

		ld	h,IO_UART_BASE
		ld	l,IO_UART_STATUS
		lio	t,(hl)
		not	t
		and	t,IO_UART_STATUS_READ
		cmp	t,0

		pop	hl
		j	(hl)


; --
; -- Read unsigned word from UART
; --
; -- Outputs:
; --    f - "eq" condition if word read
; --   bc - word
; --
		SECTION	"UartWordInSync",CODE
UartWordInSync:
		push	hl

		jal	UartByteInSync
		j/ne	.done
		ld	c,t

		jal	UartByteInSync
		ld	b,t

.done		pop	hl
		j	(hl)


; --
; -- Write unsigned word to UART
; --
; -- Inputs:
; --   ft - word
; --
		SECTION	"UartWordOutSync",CODE
UartWordOutSync:
		pusha

		jal	UartByteOutSync
		ld	t,f
		jal	UartByteOutSync

		popa
		j	(hl)


; --
; -- Write byte to UART
; --
; -- Inputs:
; --    t - Byte to write
; --
		SECTION	"UartByteOutSync",CODE
UartByteOutSync:
		pusha	

		jal	UartWaitWrite

		ld	b,IO_UART_BASE
		ld	c,IO_UART_DATA
		lio	(bc),t

		popa
		j	(hl)

; --
; -- Send memory
; --
; -- Inputs:
; --   bc - memory
; --   de - length
; --
		SECTION	"UartMemoryOutSync",CODE
UartMemoryOutSync:
		pusha

		tst	de
		j/eq	.exit

		sub	de,1
		add	d,1
		add	e,1

.write_memory	ld	t,(bc)
		jal	UartByteOutSync
		add	bc,1
		dj	e,.write_memory
		dj	d,.write_memory

.exit		popa
		j	(hl)

; --
; -- Receive memory
; --
; -- Inputs:
; --   bc - memory
; --   de - length
; --
; -- Outputs:
; --    t - error code
; --    f - "eq" condition if read
; --
		SECTION	"UartMemoryInSync",CODE
UartMemoryInSync:
		push	bc-hl

		tst	de
		j/z	.empty

		sub	de,1
		add	d,1
		add	e,1

.read_memory	jal	UartByteInSync
		j/ne	.exit
		ld	(bc),t
		add	bc,1
		dj	e,.read_memory
		dj	d,.read_memory

.empty		ld	f,FLAGS_EQ

.exit		pop	bc-hl
		j	(hl)


; --
; -- Wait for UART write
; --
		SECTION	"UartWaitWrite",CODE
UartWaitWrite:
		pusha

		ld	b,IO_UART_BASE
		ld	c,IO_UART_STATUS
.wait		lio	t,(bc)
		and	t,IO_UART_STATUS_WRITE
		cmp	t,0
		j/eq	.wait

		popa
		j	(hl)
		