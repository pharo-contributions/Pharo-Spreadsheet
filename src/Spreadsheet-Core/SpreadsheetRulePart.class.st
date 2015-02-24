"
A part of a spreadsheet rule
"
Class {
	#name : #SpreadsheetRulePart,
	#superclass : #Object,
	#category : #'Spreadsheet-Core-Rules'
}

{ #category : #accessing }
SpreadsheetRulePart >> cellReferences [
	"subclasses with direct or indirect cell references should return these"
	^#()
	
]

{ #category : #accessing }
SpreadsheetRulePart >> prerequisiteCellsFor: aCell [
	"subclasses with direct or indirect cell references should return these"
	^#()
	
]

{ #category : #printing }
SpreadsheetRulePart >> printOn: aStream [
	aStream nextPut: ${.
	self printOn: aStream for: nil precedence: 0.
	aStream nextPut: $}
]

{ #category : #printing }
SpreadsheetRulePart >> printOn: aStream for: aCell [
	aStream nextPut: ${.
	self printOn: aStream for: aCell precedence: 0.
	aStream nextPut: $}
]

{ #category : #printing }
SpreadsheetRulePart >> printOn: aStream for: aCell precedence: precedence [
	self subclassResponsibility
]

{ #category : #evaluating }
SpreadsheetRulePart >> valueInCell: aCell [
	self subclassResponsibility
]
