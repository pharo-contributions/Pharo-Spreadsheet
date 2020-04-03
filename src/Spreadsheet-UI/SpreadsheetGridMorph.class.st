"
SpreadsheetGridMorph new openInWorld
"
Class {
	#name : #SpreadsheetGridMorph,
	#superclass : #Morph,
	#instVars : [
		'spreadsheet',
		'firstVisible',
		'editor',
		'editedCell'
	],
	#category : #'Spreadsheet-UI-Morphic'
}

{ #category : #examples }
SpreadsheetGridMorph class >> example [

	| sheet |
	sheet := self open.
	sheet cellStringAt: 1@1 put: '10'.
	sheet cellStringAt: 1@2 put: '20'.
	sheet cellStringAt: 1@3 put: '=A1+A2'.
	 
]

{ #category : #examples }
SpreadsheetGridMorph class >> exampleDate [

	| sheet |
	sheet := self open.
	sheet cellStringAt: 1@1 put: '=DATE'.

]

{ #category : #examples }
SpreadsheetGridMorph class >> exampleWindow [

	self new openInWindow 
]

{ #category : #'instance creation' }
SpreadsheetGridMorph class >> open [
	<script>
	
	^(self new)
		extent: 300@200;
		openInWorld
]

{ #category : #'event handling' }
SpreadsheetGridMorph >> acceptEditedCellContents: aString [
	| tmp |
	self flag: 'btc20120303 tmp is required to assist tracing for learning the code, since editedCell loses its value when halting execution here.  This seems a bit fragile and may need further review' .
	tmp := editedCell. 
	"self halt."  "Good place to start tracing to learning the code"
	spreadsheet cellStringAt: tmp put: aString
]

{ #category : #accessing }
SpreadsheetGridMorph >> cellStringAt: aPoint [
	^spreadsheet cellStringAt: aPoint.
]

{ #category : #updating }
SpreadsheetGridMorph >> cellStringAt: aPoint put: aString [
	spreadsheet cellStringAt: aPoint put: aString
]

{ #category : #private }
SpreadsheetGridMorph >> deleteEditor [
	editor isNil ifFalse: [
		editor delete.
		editor := editedCell := nil]
]

{ #category : #drawing }
SpreadsheetGridMorph >> drawOn: aCanvas [
	| r rowRange columnRange cellRect |
	aCanvas clipBy: self bounds during: [:canvas |
		r := canvas clipRect translateBy: self position negated.
		rowRange := spreadsheet visibleRowsIn: r.
		columnRange := spreadsheet visibleColumnsIn: r.
		cellRect := self rectangleForCellRange: columnRange first @ rowRange first to: columnRange last @ rowRange last.
		"Transcript cr; print: r.
		Transcript cr; tab; print: rect.
		Transcript cr; tab; print: rowRange; space; print: columnRange.
		Transcript cr; tab; print: canvas origin; endEntry."
		self
			drawOn: canvas at: cellRect origin
			rowRange: rowRange
			columnRange: columnRange
			cellsDo: [:cell :rect |
				canvas clipBy: rect during: [:sc | sc drawString: cell valueString at: rect origin + (2@1)]]]
]

{ #category : #drawing }
SpreadsheetGridMorph >> drawOn: aCanvas at: aPoint rowRange: rowRange columnRange: columnRange cellsDo: aBlock [
	"draw all cells and their contents with borders"
	| h w borderColor y x row column cell |
	h := 1.
	rowRange do: [:i | h := h + (spreadsheet rows at: i) height].
	w := 1.
	columnRange do: [:i | w := w + (spreadsheet columns at: i) width].
	aCanvas fillRectangle: (aPoint extent: w@h) color: Color white.
	borderColor := Color gray.
	y := aPoint y.
	rowRange do: [:r |
		aCanvas fillRectangle: (aPoint x @ y extent: w@1) color: borderColor.
		y := y + (spreadsheet rows at: r) height].
	aCanvas fillRectangle: (aPoint x @ y extent: w@1) color: borderColor.
	x := aPoint x.
	columnRange do: [:c |
		aCanvas fillRectangle: (x @ aPoint y extent: 1@h) color: borderColor.
		x := x + (spreadsheet columns at: c) width].
	aCanvas fillRectangle: (x @ aPoint y extent: 1@h) color: borderColor.
	y := aPoint y + 1.
	rowRange do: [:r |
		row := spreadsheet rows at: r.
		x := aPoint x + 1.
		columnRange do: [:c |
			column := spreadsheet columns at: c.
			cell := row at: c.
			cell isDummy ifFalse: [
				aBlock value: cell value: (x@y extent: (column width-1 @ (row height-1)))].
			x := x + column width].
		y := y + row height]
]

{ #category : #'event handling' }
SpreadsheetGridMorph >> editCell: aPoint evt: anEvent [
	"self halt." "Good place to start tracing to learning the code"
	editor isNil ifFalse: [self acceptEditedCellContents: editor contents asString].
	self deleteEditor.
	editedCell := aPoint.
	editor := SpreadsheetCellTextMorph new.
	editor borderWidth: 2.
	self repositionEditor.
	editor contentsWrapped: (spreadsheet cellRuleOrValueStringAt: aPoint).
	"editor autoFit: true."
	self addMorph: editor.
	anEvent isNil
		ifTrue: [self activeHand newKeyboardFocus: editor]
		ifFalse: [
			anEvent hand newMouseFocus: editor.
			editor mouseDown: anEvent]
]

{ #category : #'event handling' }
SpreadsheetGridMorph >> handlesMouseDown: evt [
	^evt redButtonPressed
]

{ #category : #initialization }
SpreadsheetGridMorph >> initialize [
	super initialize.
	spreadsheet := Spreadsheet new.
	spreadsheet addDependent: self
]

{ #category : #'event handling' }
SpreadsheetGridMorph >> mouseDown: evt [
	| relative rect rowRange columnRange |
	evt redButtonPressed ifTrue: [
		relative := evt position - self position.
		rect := relative extent: 1@1.
		rowRange := spreadsheet visibleRowsIn: rect.
		columnRange := spreadsheet visibleColumnsIn: rect.
		self editCell: columnRange first @ rowRange first evt: evt]
]

{ #category : #'event handling' }
SpreadsheetGridMorph >> moveEditCellNextLine [
	| tmp | 
	self flag: 'btc20120303 tmp is required to assist tracing for learning the code, since editedCell loses its value when halting execution here.  This seems a bit fragile and may need further review' .
	tmp := editedCell.
	"self halt."  "Good place to start tracing to learning the code"
	self editCell: tmp + (0@1) evt: nil
]

{ #category : #opening }
SpreadsheetGridMorph >> openInWindow [
	<script: 'SpreadsheetGridMorph new openInWindow'>
	
	| window scrollPane |
	window := SystemWindow labelled: 'Spreadsheet'.
	scrollPane := ScrollPane new.
	scrollPane scroller offset: 0@0; addMorph: (self extent: 500@500).
	scrollPane alwaysShowHScrollBar: true.
	window addMorph: scrollPane fullFrame: (LayoutFrame identity topOffset: 30).
	window extent: 400@300.
	window openInWorld
]

{ #category : #private }
SpreadsheetGridMorph >> rectangleForCellRange: originPoint to: cornerPoint [
	^((spreadsheet originForCellPoint: originPoint) corner: (spreadsheet cornerForCellPoint: cornerPoint)) translateBy: self position
]

{ #category : #private }
SpreadsheetGridMorph >> repositionEditor [
	editor isNil ifFalse: [
		editor bounds: ((self rectangleForCellRange: editedCell to: editedCell) expandBy: (1@1 corner: 2@2))]
]

{ #category : #updating }
SpreadsheetGridMorph >> update: aSymbol [
	aSymbol = #displayFull ifTrue: [
		self repositionEditor.
		^self changed]
]

{ #category : #updating }
SpreadsheetGridMorph >> update: aSymbol with: anObject [
	aSymbol = #display ifTrue: [
		self repositionEditor.
		^self invalidRect: (self rectangleForCellRange: anObject origin to: anObject corner)]
]
