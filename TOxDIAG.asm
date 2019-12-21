		* TOxDIAG
		* Version 1.0.0, 19/12/2019
		* © 2019 Patrick Lafarguette

		* Thomson TO8
		* Thomson TO8D

		* Basic RAM tests to detect defective RAM IC
		* Stop immediately on error.
		* The border color is set to show the IC to check/replace:
		* IW01 D0 black
		* IW02 D1 red
		* IW03 D2 green
		* IW04 D3 yellow
		* IW05 D4 blue
		* IW06 D5 magenta
		* IW07 D6 cyan
		* IW08 D7 white

		* VRAM
VRAM_BASE	equ $4000
VRAM_SIZE	equ $2000

		* MMIO
		* E7DA-E7DB GATE PALETTE
EF9369_DATA	equ $E7DA
EF9369_INDEX	equ $E7DB
		* E7DC GATE MODE PAGE Display mode register
CF74021_DISPLAY	equ $E7DC
		* E7DD GATE MODE PAGE System register
CF74021_BORDER	equ $E7DD
		* E7E4-E7E7 GATE MODE PAGE Light pen and system register
CF74021_INITN	equ $E7E7

		* Synchronization
		* http://pulkomandy.tk/projects/thomson/browser/Thomson/code/3rdparty/sources2-hcl/FabMonitor/FABMON.ASM#L146
synchro		macro
		lda CF74021_INITN
		bpl *-3
		lda CF74021_INITN
		bmi *-3
		ldb #4*45
		tst ,x
		lda 1,x
		decb
		bne *-5
		endm

		* Delay 1 second (50 frames)
delay		macro
		lda #50
loop$		tfr a,dp
		synchro
		tfr dp,a
		deca
		bne loop$
		endm

		* ROM start
		org $E000

		fcn "TOxDIAG"
		fcn "1.0.0"
		fcn "19/12/2019 18:24"
		fcn "Patrick Lafarguette"

		* Progam entry point
reset		orcc #$50

		* Initialize MO hardware
		lda #$54
		sta $A7E7

		* Initialize display
		lda #$00
		sta CF74021_DISPLAY
		
		* Set border color
		sta CF74021_BORDER

		* Set palette
		ldx #COLORS
		sta EF9369_INDEX
palette		ldb ,X+
		stb EF9369_DATA
		ldb ,X+
		stb EF9369_DATA
		inca
		cmpa #(GRAY+1) 
		bne palette

		* Pixel memory
		lda $E7C3
		ora #$01
		sta $E7C3
		
		* Clear
		ldx #VRAM_BASE
		lda #$00		
loop$		sta ,X+
		cmpx #(VRAM_BASE+VRAM_SIZE)
		bne loop$

		* Color memory
		lda $E7C3
		anda #$FE
		sta $E7C3

		* Clear
		ldx #VRAM_BASE
		lda #$34
loop$		sta ,X+
		cmpx #(VRAM_BASE+VRAM_SIZE)
		bne loop$

		* Cycle palette on border
		* CPU is working
		* ROM is working
		* EF9369 is working
		* CF74021 is working
		lda #BLACK
		sta CF74021_BORDER
		delay
		lda #RED
		sta CF74021_BORDER
		delay
		lda #GREEN
		sta CF74021_BORDER
		delay
		lda #YELLOW
		sta CF74021_BORDER
		delay
		lda #BLUE
		sta CF74021_BORDER
		delay
		lda #MAGENTA
		sta CF74021_BORDER
		delay
		lda #CYAN
		sta CF74021_BORDER
		delay
		lda #WHITE
		sta CF74021_BORDER
		delay
		lda #GRAY
		sta CF74021_BORDER
		delay

                * Pixel memory
		lda $E7C3
		ora #$01
		sta $E7C3

		* VRAM write/read
patern00
		ldx #VRAM_BASE
loop$		lda #$00
		sta ,X
		eora ,X+
		bne error
		cmpx #(VRAM_BASE+VRAM_SIZE)
		bne loop$

paternAA
		ldx #VRAM_BASE
loop$		lda #$AA
		sta ,X
		eora ,X+
		bne error
		cmpx #(VRAM_BASE+VRAM_SIZE)
		bne loop$

patern55
		ldx #VRAM_BASE
loop$		lda #$55
		sta ,X
		eora ,X+
		bne error
		cmpx #(VRAM_BASE+VRAM_SIZE)
		bne loop$

paternFF
		ldx #VRAM_BASE
loop$		lda #$FF
		sta ,X
		eora ,X+
		bne error
		cmpx #(VRAM_BASE+VRAM_SIZE)
		bne loop$

		* Success
		* Display gray border
		lda #GRAY
		sta CF74021_BORDER
loop$		jmp loop$

		* Error
error		lsra
		bcs IW01
		lsra
		bcs IW02
		lsra
		bcs IW03
		lsra
		bcs IW04
		lsra
		bcs IW05
		lsra
		bcs IW06
		lsra
		bcs IW07
		jmp IW08
IW01		lda #BLACK
		jmp finish
IW02		lda #RED
		jmp finish
IW03		lda #GREEN
		jmp finish
IW04		lda #YELLOW
		jmp finish
IW05		lda #BLUE
		jmp finish
IW06		lda #MAGENTA
		jmp finish
IW07		lda #CYAN
		jmp finish
IW08		lda #WHITE
		
finish		sta CF74021_BORDER
loop$		jmp loop$		

COLORS		* 7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
		* g g g g r r r r   - - - m b b b b
		fcb $00,$00 * Black
		fcb $0F,$00 * Red
		fcb $F0,$00 * Green
		fcb $FF,$00 * Yellow
		fcb $00,$0F * Blue
		fcb $0F,$0F * Magenta
		fcb $F0,$0F * Cyan
		fcb $FF,$0F * White 
		fcb $77,$07 * Gray 

BLACK		equ 0
RED		equ 1
GREEN		equ 2
YELLOW		equ 3
BLUE		equ 4
MAGENTA		equ 5
CYAN		equ 6
WHITE		equ 7
GRAY		equ 8


		* Reset vector
		org $FFFE
		fdb reset
		end