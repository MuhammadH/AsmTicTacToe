TITLE test3.asm
; Program description: pllays tic tac toe with a few options for game modes
; Author: Muhammad Hussain
; Creation date: 12/7/19

INCLUDE Irvine32.inc







COMMENT @

issues and bugs:

There's a problem where call Delay doesn't work. It's commented out at the moment, but if you
search ctrl+f for "delay" you can see where it is. The program just works life it's not there. 

Also, waitmsg prompts need quite a few presses to actually get through sometimes. 

@









ClearRegs proto
DisplayMenu proto,
	menOff:dword
DisplayGvG proto,
	gvgOff:dword
ClearBoard proto,
	boardOff:dword
FirstMoveRand proto,
	fmOff:dword
PlayerMove proto, 
	offStr:dword,
	pieceVal:byte, 
	boardOff:dword
CheckIfEmpty proto,
	boardOff:dword, 
	empOff:dword,
	rowIn:dword,
	colIn:dword
PutPieceIn proto,
	boardOff:dword, 
	rowIn:dword,
	colIn:dword, 
	pieceVal:byte
AnnounceFirstMove proto
DrawTTTBoard proto, 
	boardOff:dword, 
	pieceVal:byte
FlipActivePiece proto,
	apOff:dword
ResetColor proto
ComputerMove proto, 
	offStr:dword,
	pieceVal:byte,
	boardOff:dword
writeSpace proto
CheckGameOver proto,
	boardOff:dword,
	goOff:dword, 
	winVal:byte
CheckForDraw proto,
	boardOff:dword,
	retOff:dword
PrintWinner proto,
	winOff:dword
PrintStats proto,
	lpvcgp:byte,
	lpvpgp:byte, 
	lcvcgp:byte, 
	lp1win:byte, 
	lp2win:byte, 
	lc1win:byte, 
	lc2win:byte, 
	ldraws:byte 

.data

	menuOption byte 0
	;gvgOption byte 2d

	TTTArray byte 21h, 21h, 21h
	rowSize = ($ - TTTArray)
				byte 21h, 21h, 21h
				byte 21h, 21h, 21h

	;pwrArray byte 21h, 21h, 21h
	;rowSize2 = ($ - TTTArray)
;				byte 21h, 21h, 21h
;				byte 21h, 21h, 21h

	firstMoveDec byte 0

	nobodys1 byte "nobody", 0

	pstring1 byte "player 1", 0
	pstring2 byte "player 2", 0

	cstring1 byte "COMPUTER 1", 0
	cstring2 byte "COMPUTER 2", 0

	currentPiece byte 1d

	goCondition byte 0d

	drawCondition byte 0d


	pvcgp byte 0
	pvpgp byte 0
	cvcgp byte 0
	p1win byte 0
	p2win byte 0
	c1win byte 0
	c2win byte 0
	draws byte 0

.data?

.code
main proc

; Menu
MenuL: 
	
	mov currentPiece, 1d
	mov goCondition, 0d
	mov drawCondition, 0d

	;INVOKE ResetColor
	call clrscr

	; clear registers 
	;INVOKE ClearRegs
	call randomize
	
	; clear the 2d array for TTT
	INVOKE ClearBoard, offset TTTArray
	;INVOKE ClearBoard, offset pwrArray

	; decide who does first 
	INVOKE FirstMoveRand, offset firstMoveDec

	; set current piece to X
	mov currentPiece, 1d

	INVOKE DisplayMenu, offset menuOption
	;cmp menuOption, 3
	;ja statsl
	;INVOKE DisplayGvG, offset gvgOption






PvCl:
	cmp menuOption, 1
	jne PvPl

	call clrscr

	; draw board 
	INVOKE DrawTTTBoard, offset TTTArray, currentPiece

	; tell players move order was selected at random
	INVOKE AnnounceFirstMove 

	cmp firstMoveDec, 0
	jne firstMove2

firstMove1:
	;call clearregs
	; player move 
	INVOKE playerMove, offset pstring1, currentPiece, offset TTTArray
	;call clearregs

	; flip active piece 
	INVOKE FlipActivePiece, offset currentPiece

	; draw board
	call clrscr
	INVOKE DrawTTTBoard, offset TTTArray, currentPiece

	; run gvg ;;;;;;;;;;;;;;;;;;;;;


	; check game over
	mov al, 1d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet0
	mov al, 2d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet0
	; also check draw 
	INVOKE CheckForDraw, offset TTTArray, offset drawCondition
	cmp drawCondition, 0
	jne DrawDet0

firstMove2:
	;call clearregs
	; computer move 
	INVOKE ComputerMove, offset cstring1, currentPiece, offset TTTArray

	;call clearregs

	call waitmsg

	; flip active piece 
	INVOKE FlipActivePiece, offset currentPiece

	; draw board 
	call clrscr
	INVOKE DrawTTTBoard, offset TTTArray, currentPiece

	; run gvg ;;;;;;;;;;;;;;;;;;;;;


	; check game over 
	mov al, 1d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet0
	mov al, 2d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet0
	; also check draw 
	INVOKE CheckForDraw, offset TTTArray, offset drawCondition
	cmp drawCondition, 0
	jne DrawDet0


	jmp firstMove1
winDet0:
	
	mov eax, 0
	add al, firstMoveDec
	add al, goCondition

	cmp al, 2
	je WinTree0

WinTree1: ; player 1 win

	INVOKE PrintWinner, offset pstring1
	inc pvcgp
	inc p1win
	call waitmsg

	jmp MenuL
WinTree0: ; comp 1 win

	INVOKE PrintWinner, offset cstring1
	inc pvcgp
	inc c1win
	call waitmsg

	jmp MenuL
DrawDet0: ; draw
	INVOKE PrintWinner, offset nobodys1
	inc draws
	call waitmsg

	jmp MenuL
PvCle:
	jmp MenuL












PvPl:
	cmp menuOption, 2
	jne CvCl


	call clrscr

	; draw board 
	INVOKE DrawTTTBoard, offset TTTArray, currentPiece

	; tell players move order was selected at random
	INVOKE AnnounceFirstMove 

	cmp firstMoveDec, 0
	jne firstMove4

firstMove3:
	; player 1 move
	;call clearregs
	; player move 
	INVOKE playerMove, offset pstring1, currentPiece, offset TTTArray
	;call clearregs

	; flip active piece 
	INVOKE FlipActivePiece, offset currentPiece

	; draw board
	call clrscr
	INVOKE DrawTTTBoard, offset TTTArray, currentPiece

	; check game over
	mov al, 1d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet1
	mov al, 2d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet1
	; also check draw 
	INVOKE CheckForDraw, offset TTTArray, offset drawCondition
	cmp drawCondition, 0
	jne DrawDet1

firstMove4:
	; player 2 move
	;call clearregs
	; player move 
	INVOKE playerMove, offset pstring2, currentPiece, offset TTTArray
	;call clearregs

	; flip active piece 
	INVOKE FlipActivePiece, offset currentPiece

	; draw board
	call clrscr
	INVOKE DrawTTTBoard, offset TTTArray, currentPiece

	; check game over
	mov al, 1d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet1
	mov al, 2d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet1
	; also check draw 
	INVOKE CheckForDraw, offset TTTArray, offset drawCondition
	cmp drawCondition, 0
	jne DrawDet1

	jmp firstMove3

winDet1:
	
	mov eax, 0
	add al, firstMoveDec
	add al, goCondition

	cmp al, 2
	je WinTree3
WinTree4: ; player 1 win

	INVOKE PrintWinner, offset pstring1
	inc pvpgp
	inc p1win
	call waitmsg

	jmp MenuL
WinTree3: ; player 2 win

	INVOKE PrintWinner, offset pstring2
	inc pvpgp
	inc p2win
	call waitmsg

	jmp MenuL
DrawDet1: ; draw
	INVOKE PrintWinner, offset nobodys1
	inc draws
	call waitmsg

	jmp MenuL

PvPle:
	jmp MenuL









CvCl:
	cmp menuOption, 3
	jne statsl



	call clrscr

	; draw board 
	INVOKE DrawTTTBoard, offset TTTArray, currentPiece

	; tell players move order was selected at random
	INVOKE AnnounceFirstMove 

	cmp firstMoveDec, 0
	jne firstMove6

firstMove5:
	; computer 1 move
	;call clearregs
	; computer move 
	INVOKE ComputerMove, offset cstring1, currentPiece, offset TTTArray

	;call clearregs

	; flip active piece 
	INVOKE FlipActivePiece, offset currentPiece


	call waitmsg
	;mov eax, 0
	;mov eax, 1000d
	;call Delay


	; draw board 
	call clrscr
	INVOKE DrawTTTBoard, offset TTTArray, currentPiece


	; check game over
	mov al, 1d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet3
	mov al, 2d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet3
	; also check draw 
	INVOKE CheckForDraw, offset TTTArray, offset drawCondition
	cmp drawCondition, 0
	jne DrawDet3



firstMove6:
	; computer 2 move
	;call clearregs
	; computer move 
	INVOKE ComputerMove, offset cstring2, currentPiece, offset TTTArray

	;call clearregs

	; flip active piece 
	INVOKE FlipActivePiece, offset currentPiece

	call waitmsg
	;mov eax, 0
	;mov eax, 1000d
	;call Delay


	; draw board 
	call clrscr
	INVOKE DrawTTTBoard, offset TTTArray, currentPiece

	
	; check game over
	mov al, 1d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet3
	mov al, 2d
	INVOKE CheckGameOver, offset TTTArray, offset goCondition, al
	cmp goCondition, 0
	jne winDet3
	; also check draw 
	INVOKE CheckForDraw, offset TTTArray, offset drawCondition
	cmp drawCondition, 0
	jne DrawDet3

	jmp firstMove5

winDet3:
	
	mov eax, 0
	add al, firstMoveDec
	add al, goCondition

	cmp al, 2
	je WinTree7
WinTree8: ; comp 1 win

	INVOKE PrintWinner, offset cstring1
	inc cvcgp
	inc c1win
	call waitmsg

	jmp MenuL
WinTree7: ; comp 2 win

	INVOKE PrintWinner, offset cstring2
	inc cvcgp
	inc c2win
	call waitmsg

	jmp MenuL
DrawDet3: ; draw
	INVOKE PrintWinner, offset nobodys1
	inc draws
	call waitmsg

	jmp MenuL

CvCle:
	jmp MenuL








statsl:
	cmp menuOption, 4
	jne exitl
	
	; print all the stats
	INVOKE printStats, pvcgp, pvpgp, cvcgp, p1win, p2win, c1win, c2win, draws 
	call waitmsg

	jmp MenuL
exitl:

	; print stats and exit
	INVOKE printStats, pvcgp, pvpgp, cvcgp, p1win, p2win, c1win, c2win, draws 

exit
main endp






COMMENT @
Print who won! Hooray!
recieves:
a string for the winner
returns:
nothing
requires:
edx registers
@
PrintWinner proc,
	winOff:dword
.data
	PWprom1 byte " has won!",0 

.code
	mov edx, winOff ; print the input string
	call writestring
	mov edx, offset PWprom1 ; print "has won!"
	call writestring
	call crlf

	ret 4
PrintWinner endp


COMMENT @
print stats
recieves:
just a ton of statistics
returns:
nothing
requires:
edx registers
@
PrintStats proc,
	lpvcgp:byte,
	lpvpgp:byte, 
	lcvcgp:byte, 
	lp1win:byte, 
	lp2win:byte, 
	lc1win:byte, 
	lc2win:byte, 
	ldraws:byte 
.data
	Pstats0 byte "Here are some stats:", 0
	Pstats1 byte "Player vs Computer games played: ", 0
	Pstats2 byte "Player vs Player games played: ", 0
	Pstats3 byte "Computer vs Computer games played: ", 0
	Pstats4 byte "Player 1 wins: ", 0
	Pstats5 byte "Player 2 wins: ", 0
	Pstats6 byte "Computer 1 wins: ", 0
	Pstats7 byte "Computer 2 wins: ", 0
	Pstats8 byte "Draws: ", 0

.code
	mov eax, 0 ; clear eax
	
	mov edx, offset Pstats0
	call writestring
	call crlf
	
	mov edx, offset Pstats1
	call writestring
	mov al, lpvcgp
	call writedec
	call crlf

	mov edx, offset Pstats2
	call writestring
	mov al, lpvpgp
	call writedec
	call crlf

	mov edx, offset Pstats3
	call writestring
	mov al, lcvcgp
	call writedec
	call crlf

	mov edx, offset Pstats4
	call writestring
	mov al, lp1win
	call writedec
	call crlf

	mov edx, offset Pstats5
	call writestring
	mov al, lp2win
	call writedec
	call crlf

	mov edx, offset Pstats6
	call writestring
	mov al, lc1win
	call writedec
	call crlf

	mov edx, offset Pstats7
	call writestring
	mov al, lc2win
	call writedec
	call crlf

	mov edx, offset Pstats8
	call writestring
	mov al, ldraws
	call writedec
	call crlf

	ret 8
PrintStats endp















COMMENT @
check if the game is over in a draw
recieves:
board offset
the offset for game draw condition
returns:
the draw condition
requires:
eax, ebx, ecx, edx registers
@
CheckForDraw proc,
	boardOff:dword,
	retOff:dword
.data
	
	CFDrow dword 0
	CFDcol dword 0

.code
	
	; if every space is full but nobody has won, then it's a draw

	mov CFDrow, 0
	mov CFDcol, 0

CFDol1:
	mov CFDcol, 0
	mov ecx, 3
CFDil1:	
		mov ebx, boardOff ; get a space
		mov eax, CFDrow
		add eax, CFDrow
		add eax, CFDrow
		add ebx, eax

		mov edx, CFDcol

		mov al, byte ptr [ebx + edx] ; get 0,1, or 2 from spot

		cmp al,0 ; check this space for 0
		; if any spot is zero, then this is not a tie
		je NotNull

		inc CFDcol

		loop CFDil1 ; inner loop

	inc CFDrow ; move to the next row

	cmp CFDrow, 3d
	je CFDel1

jmp CFDol1 ; outer loop
	
CFDel1: ; not a draw yet
	
	mov ebx, retOff
	mov byte ptr [ebx], 1d

	ret 8

NotNull: ; it's a draw!

	mov ebx, retOff
	mov byte ptr [ebx], 0d

	ret 8
CheckForDraw endp



COMMENT @
check if the game is over
recieves:
board offset
the offset for game over condition
winVal is the value we're checking for - X or O
returns:
the game over condition
requires:
eax, ebx, ecx, edx, esi registers
@
CheckGameOver proc,
	boardOff:dword,
	goOff:dword, 
	winVal:byte
.data

	CGOcounter dword 0

	CGOrow dword 0
	CGOcol dword 0

.code

	; clear values
	mov CGOcounter, 0
	mov CGOrow, 0
	mov CGOcol, 0
	
	; check rows

CGOloop0:
	
	mov ecx, 3 ; loop 3 times - check every row
	mov CGOcol, 0
	mov CGOcounter, 0
	CGOloop1:

		mov ebx, boardOff ; move to correct row and col
		add ebx, CGOrow
		add ebx, CGOrow
		add ebx, CGOrow
		mov esi, CGOcol
		mov al, [ebx + esi] ; save current value in al

		mov bl, winVal ; if this spot matches piece we're looking for (X or O)
		cmp al, winVal ; then increment counter by 1
		jne notAWinner
		inc CGOcounter
	notAWinner:
		inc CGOcol

		loop CGOloop1

	inc CGOrow

	cmp CGOcounter, 3 ; check if this row is a winner
	jne CGOnext1

	; set win here
	; put result in goCondition
	mov ebx, goOff
	mov al, winVal
	mov byte ptr [ebx], al
	ret 9

CGOnext1:

	cmp CGOrow, 3 ; if all rows checked, move on
	je CGOesc1

	loop CGOloop0

CGOesc1:
	
	; check cols

	mov CGOcounter, 0 ; now we'll check columns
	mov CGOrow, 0
	mov CGOcol, 0

CGOloop3:
	
	mov ecx, 3
	mov CGOrow, 0
	mov CGOcounter, 0
	CGOloop4:

		mov ebx, boardOff ; move to the right place
		add ebx, CGOrow
		add ebx, CGOrow
		add ebx, CGOrow
		mov esi, CGOcol
		mov al, [ebx + esi]

		cmp al, winVal ; if this piece matches (X or O), increment
		jne notAWinner1
		inc CGOcounter
	notAWinner1:
		inc CGOrow ; increment row

		loop CGOloop4

	inc CGOcol

	cmp CGOcounter, 3
	jne CGOnext2

	; set win here
	; put result in goCondition
	mov ebx, goOff
	mov al, winVal
	mov byte ptr [ebx], al
	ret 9

CGOnext2:

	cmp CGOcol, 3 ; if at column "3", excape loop
	je CGOesc2

	loop CGOloop3 ; outer loop

CGOesc2:

	; check diag1

	mov CGOcounter, 0 ; clear vaue
	mov CGOrow, 0
	mov CGOcol, 0

	mov ecx, 3d

	; start on the top left and check diagonal

CGOdLoop1:
	
		mov ebx, boardOff
		add ebx, CGOrow
		add ebx, CGOrow
		add ebx, CGOrow
		mov esi, CGOcol
		mov al, [ebx + esi] ; get the piece

		cmp al, winVal
		jne notAWinner4
		inc CGOcounter ; inc counter if match

	notAWinner4:
		inc CGOcol ; next row and column
		inc CGOrow
	loop CGOdLoop1
		
	cmp CGOcounter, 3
	jne CGOnext4

	; set win here
	; put result in goCondition
	mov ebx, goOff
	mov al, winVal
	mov byte ptr [ebx], al
	ret 9

CGOnext4:

	; check diag2

	mov CGOcounter, 0
	mov CGOrow, 0 ; start on top right
	mov CGOcol, 2

	mov ecx, 3d

CGOdLoop2:
	
		mov ebx, boardOff
		add ebx, CGOrow
		add ebx, CGOrow
		add ebx, CGOrow
		mov esi, CGOcol
		mov al, [ebx + esi]

		cmp al, winVal
		jne notAWinner5
		inc CGOcounter

	notAWinner5:
		dec CGOcol ; move to the left column
		inc CGOrow ; move to the below row
	loop CGOdLoop2
		
	cmp CGOcounter, 3
	jne CGOnext6

	; set lack of win here
	mov ebx, goOff
	mov al, winVal
	mov byte ptr [ebx], al
	ret 9

CGOnext6:
	
	mov ebx, goOff
	mov byte ptr [ebx], 0d

	ret 9
CheckGameOver endp


ComputerMove proc, 
	offStr:dword,
	pieceVal:byte,
	boardOff:dword
.data

	CMp1 byte " will now take their turn.", 0

	CMPguess1 dword 0
	CMPguess2 dword 0

	CMPemptyCheck byte 0

.code
	mov CMPemptyCheck, 0d ; clear empty check

	mov edx, offStr ; print whose turn it is
	call writestring
	mov edx, offset CMp1
	call writestring
	call crlf

	mov CMPguess1, 1d ; for checking middle
	mov CMPguess2, 1d

	; check middle
	INVOKE CheckIfEmpty, boardOff, offset CMPemptyCheck, CMPguess1, CMPguess2
	cmp CMPemptyCheck, 0
	jne CompPickLoop

	; put the piece into the middle if empty
	INVOKE PutPieceIn, boardOff, CMPguess1, CMPguess2, pieceVal

	ret 9

CompPickLoop:

	mov eax, 0 ; pick a random row
	mov eax, 3
	call RandomRange
	mov CMPguess1, eax

	mov eax, 0 ; pick a random column
	mov eax, 3
	call RandomRange
	mov CMPguess2, eax

	; check if this spot is available, if not, try again
	INVOKE CheckIfEmpty, boardOff, offset CMPemptyCheck, CMPguess1, CMPguess2
	cmp CMPemptyCheck, 0
	jne CompPickLoop

	; put the piece in if spot is open
	INVOKE PutPieceIn, boardOff, CMPguess1, CMPguess2, pieceVal

	ret 9
ComputerMove endp


COMMENT @
Draws the ttt board
recieves:
board offset
the current piece val (1 or 2 - X or O)
returns:
nothing
requires:
eax, ebx, ecx, edx registers
@
DrawTTTBoard proc, 
	boardOff:dword, 
	pieceVal:byte
.data
	
	drow dword 0
	dcol dword 0

	blackTextOnRed = black + (red * 16)
	blackTextOnYel = black + (yellow * 16)

.code
	mov eax, 0

	mov drow, 0 ; clear row
	mov dcol, 0 ; clear col

ol2:

	mov dcol, 0
	mov ecx, 3 ; inner loop 3 times
il2:	
	mov eax, 20h ; write a space
	call writechar

	mov ebx, boardOff ; move to the right row
	mov eax, drow
	add eax, drow
	add eax, drow
	add ebx, eax

	mov edx, dcol ; move to the right col

	mov eax, 0
	mov al, byte ptr [ebx + edx] ; move the value into al

	; here, we'll draw based on data in 2d array
	cmp al, 0
	jne Not0

	mov al, 2Dh
	call writechar
	jmp DoneWrite

Not0: ; draw an X
	cmp al, 1
	jne Not1
	mov eax, blackTextOnRed
	call SetTextColor
	mov eax, 0
	mov al, 58h
	call writechar
	jmp DoneWrite

Not1: ; draw a O
	mov eax, blackTextOnYel
	call SetTextColor
	mov eax, 0
	mov al, 4Fh
	call writechar

DoneWrite:
	INVOKE ResetColor ; make the colors normal

	INVOKE writeSpace

	inc dcol ; move to the next col

	loop il2 

	inc drow ; outer loop

	call crlf

	cmp drow, 3d
	je el2

jmp ol2

el2:

	ret 5
DrawTTTBoard endp



COMMENT @
makes some space in the loop above
recieves:
none
returns:
none
requires:
eax register
@
writeSpace proc
.data
.code
	mov eax, 20h
	call writechar ; write space
	mov eax, 7Ch
	call writechar ; write line
	ret
writeSpace endp



COMMENT @
reset to normal colors
recieves:
none
returns:
none
requires:
none
@
ResetColor proc
.data
	WhiteTextOnBla = white + (black * 16)
.code
	mov eax, WhiteTextOnBla ; make the colors normal
	call SetTextColor
	ret
ResetColor endp








COMMENT @
flips active piece - X to O or vice versa
recieves:
offset for the active piece
returns:
value active piece
requires:
edx, ebx, eax registers
@
FlipActivePiece proc,
	apOff:dword
.data
.code
	mov ebx, apOff ; get the current active piece
	mov al, byte ptr [ebx]

	cmp al, 1
	je FlipAdd

FlipSub:
	dec al ; flip 2 to 1
	mov byte ptr [ebx], al

	ret 4

FlipAdd:
	inc al ; flip 1 to 2
	mov byte ptr [ebx], al

	ret 4
FlipActivePiece endp





COMMENT @
put a piece into the ttt board
recieves:
boardOffset
row
col
whether this is an X or an O
returns:
value in whether this is an X or an O
requires:
edx, ebx, eax registers
@
PlayerMove proc, 
	offStr:dword,
	pieceVal:byte,
	boardOff:dword
.data
	p1 byte " will now take their turn.", 0

	p2 byte "Please input a row (0,1, or 2): ", 0
	p3 byte "Please input a column (0,1, or 2): ", 0

	inputRow dword 0d
	inputCol dword 0d

	emptyCheck byte 0d

.code
	mov edx, offStr ; print whose turn it is 
	call writestring
	mov edx, offset p1 
	call writestring
	call crlf

playerRetry:
	mov edx, offset p2 ; print the prompt
	call writestring
	call crlf

	mov eax, 0 
	call readdec ; get input

	cmp eax, 2 ; make sure it's 0-2
	ja playerRetry

	mov inputRow, eax

	mov edx, offset p3 ; print the prompt
	call writestring
	call crlf

	mov eax, 0 
	call readdec ; get input

	cmp eax, 2 ; make sure it's 0-2
	ja playerRetry

	mov inputCol, eax

	; check if the space is empty, if not, retry
	INVOKE CheckIfEmpty, boardOff, offset emptyCheck, inputRow, inputCol
	cmp emptyCheck, 0
	jne playerRetry

	; put the piece in 
	INVOKE PutPieceIn, boardOff, inputRow, inputCol, pieceVal

	ret 9
PlayerMove endp




COMMENT @
put a piece into the ttt board
recieves:
boardOffset
row
col
whether this is an X or an O
returns:
value in whether this is an X or an O
requires:
edx, ebx, eax registers
@
PutPieceIn proc,
	boardOff:dword, 
	rowIn:dword,
	colIn:dword, 
	pieceVal:byte
.data
.code
	
	mov ebx, boardOff ; get over to the given row
	mov eax, rowIn
	add eax, rowIn
	add eax, rowIn
	add ebx, eax

	mov edx, colIn ; get over to the given col

	mov al, pieceVal ; save piece into al
	mov byte ptr [ebx + edx], al ; move the piece into the board

	ret 13
PutPieceIn endp




COMMENT @
check if a specific spot on the ttt board is empty
recieves:
boardOffset
offset for storage for true or false - if empty for not
row
col
returns:
a value in storage offset
requires:
edx, ebx, eax registers
@
CheckIfEmpty proc,
	boardOff:dword, 
	empOff:dword,
	rowIn:dword,
	colIn:dword
.data
.code

	mov ebx, boardOff
	mov eax, rowIn ; move to the right row
	add eax, rowIn
	add eax, rowIn
	add ebx, eax

	mov edx, colIn ; move to the right column

	mov ecx, empOff

	mov al, byte ptr [ebx + edx] ; move the value in TTT array into some storage value
	mov byte ptr [ecx], al ; save number from TTT array in storage

	ret 16
CheckIfEmpty endp






COMMENT @
decides who goes first p1c1 or p2c2
recieves:
offset for the first move value
returns:
value in the first move value
requires:
all registers
@
FirstMoveRand proc,
	fmOff:dword
.data
.code
	mov eax, 0

	mov al, 0
	mov al, 2
	call RandomRange ; get a value 1 or 2

	mov ebx, fmOff ; 
	mov byte ptr [ebx], al ; save input

	ret 4
FirstMoveRand endp

AnnounceFirstMove proc
.data
	AFMp1 byte "The first move was decided randomly", 0 ; this is just a msg letting users know
	AFMp2 byte "The first move will be: ", 0            ; the first move is random
.code
	mov edx, offset AFMp1
	call writestring
	call crlf

	mov edx, offset AFMp2
	call writestring
	call crlf

	ret
AnnounceFirstMove endp






COMMENT @
set TTT board to all zeros
recieves:
board offset
returns:
nothing
requires:
all registers
@
; clear board
ClearBoard proc,
	boardOff:dword
.data
	row dword 0 ; start at row 0
	col dword 0

.code
	
	mov row, 0
	mov col, 0

ol1:
	mov col, 0 ; start at col 0 each outer loop
	mov ecx, 3
il1:	
	mov ebx, boardOff ; get the offset for the current cell in 2D array
	mov eax, row
	add eax, row
	add eax, row
	add ebx, eax

	mov edx, col

	mov byte ptr [ebx + edx], 0h ; move zero into this cell

	inc col ; move to the next column

	loop il1

	inc row

	cmp row, 3d ; if we're at row "3", exit
	je el1

jmp ol1
	
el1:
	

	ret 4
ClearBoard endp

COMMENT @
Clears registers
Recieves:
nothing
Returns:
nothing
requires:
nothing
@
ClearRegs proc
.data
.code
	mov eax, 0d
	mov ebx, 0d
	mov ecx, 0d
	mov edx, 0d
	mov esi, 0d
	ret
ClearRegs endp


COMMENT @
Displays menu
recieves:
offset for menu option holder in main
returns:
user input using given offset
requires:
edx, ebx, eax registers
@
; display menu
DisplayMenu proc,
	menOff:dword ; this value stores the return value
.data
	menu1 byte "Hi here are some options: ", 0Ah, 0Dh, 
				"1: PvC.", 0Ah, 0Dh, 
				"2: PvP", 0Ah, 0Dh, 
				"3: CvC", 0Ah, 0Dh, 
				"4: Stats", 0Ah, 0Dh, 
				"5: Exit", 0Ah, 0Dh, 
				"Plz enter 1 to 5: ", 0
	
.code
	mov edx, offset menu1 ; show menu ; show prompt
	call writestring
	call crlf

	call readdec ; get input

	mov ebx, menOff ; save input
	mov byte ptr [ebx], al


	ret 4
DisplayMenu endp

COMMENT @
Displays second menu
recieves:
offset for menu option holder in main
returns:
user input using given offset
requires:
edx, ebx, eax registers
@
; display menu
DisplayGvG proc,
	gvgOff:dword
.data
	menu2 byte "Play Griffons vs Gargoyles mode?", 0Ah, 0Dh, 
				"In this mode, every X is a Griffon and every O is a Gargoyle.", 0Ah, 0Dh, 
				"After every round, they all fight each other and ~half of them get knocked off the board.", 0Ah, 0Dh, 
				"Griffons fight nearby gargs and vice versa. If they win, that griffon or garg gets stronger.", 0Ah, 0Dh, 
				"1: Yes.", 0Ah, 0Dh, 
				"2: No", 0Ah, 0Dh, 
				"Plz enter 1 to 2: ", 0
	
.code
	mov edx, offset menu2 ; show menu
	call writestring
	call crlf

	call readdec ; get input

	mov ebx, gvgOff ; save input
	mov byte ptr [ebx], al


	ret 4
DisplayGvG endp


end main