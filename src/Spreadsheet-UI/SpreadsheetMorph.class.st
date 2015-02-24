"
SpreadsheetMorph new openInWindow
"
Class {
	#name : #SpreadsheetMorph,
	#superclass : #Morph,
	#category : #'Spreadsheet-UI-Morphic'
}

{ #category : #opening }
SpreadsheetMorph >> openInWindow [
	"SpreadsheetMorph new openInWindow"
	| window |
	window := SystemWindow labelled: 'Spreadsheet'.
	window addMorph: self fullFrame: ((LayoutFrame fractions: (0@0 corner: 1@1)) topOffset: 30).
	window openInWorldExtent: 400@300
]
