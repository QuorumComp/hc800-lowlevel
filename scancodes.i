	IFND	SCANCODES_I_INCLUDED_

SCANCODES_I_INCLUDED_ = 1

KEY_HOME	EQU	01
KEY_LEFT	EQU	02
KEY_INSERT	EQU	03
KEY_DELETE	EQU	04
KEY_END		EQU	05
KEY_RIGHT	EQU	06
			;07
KEY_BACKSPACE	EQU	08
KEY_INST_DEL	EQU	KEY_BACKSPACE
KEY_TAB		EQU	09
KEY_RETURN	EQU	10
KEY_PAGE_DOWN	EQU	11
KEY_ARROW_LEFT	EQU	12
KEY_ARROW_UP	EQU	13
KEY_DOWN	EQU	14
KEY_PAGE_UP	EQU	15
KEY_UP		EQU	16
			; 17
KEY_F1		EQU	18
KEY_F2		EQU	19
KEY_F3		EQU	20
KEY_F4		EQU	21
KEY_F5		EQU	22
KEY_F6		EQU	23
KEY_F7		EQU	24
KEY_F8		EQU	25
KEY_F9		EQU	26
KEY_ESCAPE	EQU	27
KEY_F10		EQU	28
KEY_F11		EQU	29
			; 30
KEY_F13		EQU	31

; $20 - $5F correspond to the ASCII table

KEY_CAPS_LOCK	EQU	$61
KEY_LSHIFT	EQU	$62
KEY_RSHIFT	EQU	$63
KEY_SYM_SHIFT	EQU	$64
KEY_LALT	EQU	KEY_SYM_SHIFT
KEY_EXTEND	EQU	$65
KEY_LCTRL	EQU	KEY_EXTEND
KEY_CTRL	EQU	KEY_LCTRL
KEY_GRAPH	EQU	$66
KEY_RALT	EQU	KEY_GRAPH
KEY_ALT		EQU	KEY_RALT
KEY_RCTRL	EQU	$67
KEY_LGUI	EQU	$68
KEY_RGUI	EQU	$69
KEY_EDIT	EQU	$70
KEY_MEGA65	EQU	KEY_EDIT
KEY_TRUE_VIDEO	EQU	$71
KEY_INV_VIDEO	EQU	$72
KEY_RUN_STOP	EQU	$73
KEY_NO_SCROLL	EQU	$74
KEY_HELP	EQU	$75

	ENDC