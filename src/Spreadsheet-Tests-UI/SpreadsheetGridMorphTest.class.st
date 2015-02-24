Class {
	#name : #SpreadsheetGridMorphTest,
	#superclass : #TestCase,
	#category : #'Spreadsheet-Tests-UI-Morphic'
}

{ #category : #tests }
SpreadsheetGridMorphTest >> testExternalControl [
	"Check external control of spreadsheet.  Also copy this to Workspace and add openInWindow"
	| sheet |
	sheet := SpreadsheetGridMorph new "openInWindow".
	sheet cellStringAt: 1@1 put: '10'.
	sheet cellStringAt: 1@2 put: '20'.
	sheet cellStringAt: 1@3 put: '=A1+A2'.
	self assert: '30' = (sheet cellStringAt: 1@3)
]
