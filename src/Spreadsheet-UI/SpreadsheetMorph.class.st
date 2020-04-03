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
	<script>
	| window |
	window := SystemWindow labelled: 'Spreadsheet'.
	window addMorph: SpreadsheetGridMorph new fullFrame: (LayoutFrame identity topOffset: 30).
	window openInWorld 
]
