"
A text morph for cells in a spreadsheet.

Instance Variables
	cell:		<Object>
	commitBlock:		<Object>

cell
	- xxxxx

commitBlock
	- xxxxx

"
Class {
	#name : #SpreadsheetCellTextMorph,
	#superclass : #TextMorph,
	#instVars : [
		'cell',
		'commitBlock'
	],
	#category : #'Spreadsheet-UI-Utilities'
}

{ #category : #editing }
SpreadsheetCellTextMorph >> acceptContents [
	super acceptContents.
	owner acceptEditedCellContents: text asString
]

{ #category : #editing }
SpreadsheetCellTextMorph >> acceptOnCR [
	^true
]

{ #category : #drawing }
SpreadsheetCellTextMorph >> drawNullTextOn: aCanvas [
	aCanvas fillRectangle: self bounds fillStyle: self fillStyle borderStyle: self borderStyle.

]

{ #category : #private }
SpreadsheetCellTextMorph >> fit [
	"Adjust my bounds to fit the text.  Should be a no-op if autoFit is not specified.
	Required after the text changes,
	or if wrapFlag is true and the user attempts to change the extent."

	| newExtent para cBounds lastOfLines heightOfLast |
	self isAutoFit 
		ifTrue: 
			[newExtent := (self paragraph extent max: 9 @ textStyle lineGrid) + (0 @ 1).
			newExtent := newExtent + (2 * borderWidth).
			margins 
				ifNotNil: [newExtent := ((0 @ 0 extent: newExtent) expandBy: margins) extent].
			newExtent ~= bounds extent 
				ifTrue: 
					[(container isNil and: [successor isNil]) 
						ifTrue: 
							[para := paragraph.	"Save para (layoutChanged smashes it)"
							super extent: newExtent.
							paragraph := para]].
			container notNil & successor isNil 
				ifTrue: 
					[cBounds := container bounds truncated.
					"23 sept 2000 - try to allow vertical growth"
					lastOfLines := self paragraph lines last.
					heightOfLast := lastOfLines bottom - lastOfLines top.
					(lastOfLines last < text size 
						and: [lastOfLines bottom + heightOfLast >= self bottom]) 
							ifTrue: 
								[container releaseCachedState.
								cBounds := cBounds origin corner: cBounds corner + (0 @ heightOfLast)].
					self privateBounds: cBounds]].

	"These statements should be pushed back into senders"
	self paragraph positionWhenComposed: self position.
	successor ifNotNil: [successor predecessorChanged].
	self changed	"Too conservative: only paragraph composition
					should cause invalidation."
]

{ #category : #initialization }
SpreadsheetCellTextMorph >> initialize [
	super initialize.
	self autoFit: false.
	self borderWidth: 2; borderColor: Color black.
	self backgroundColor: Color white.
	textStyle := textStyle copy
				firstIndent: 2;
				restIndent: 2;
				lineGrid: 13;
				leading: 1
]

{ #category : #editing }
SpreadsheetCellTextMorph >> keyStroke: evt [
	| char |
	char := evt keyCharacter.
	char = Character cr ifTrue: [
		self acceptContents.
		^owner moveEditCellNextLine].
	char = Character tab ifTrue: [
		self acceptContents.
		^owner moveEditCellTab: evt shiftPressed not].
	^super keyStroke: evt
]

{ #category : #'event handling' }
SpreadsheetCellTextMorph >> keyboardFocusChange: aBoolean [
	aBoolean ifTrue: [^super keyboardFocusChange: aBoolean].
	owner deleteEditor
]

{ #category : #geometry }
SpreadsheetCellTextMorph >> minimumExtent [
	| minExt |
	textStyle ifNil: [^ 9@16].
	borderWidth ifNil: [^ 9@16].
	minExt := (9@textStyle lineGrid) + (borderWidth*2).
	margins ifNil: [^ minExt].
	^ ((0@0 extent: minExt) expandBy: margins) extent
]
