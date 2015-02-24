"
A cell reference in a spreadsheet  

Instance Variables
	columnBase:		<Object>
	columnIndex:		<Object>
	rowBase:		<Object>
	rowIndex:		<Object>

columnBase
	- xxxxx

columnIndex
	- xxxxx

rowBase
	- xxxxx

rowIndex
	- xxxxx

"
Class {
	#name : #SpreadsheetRuleCellReference,
	#superclass : #SpreadsheetRulePart,
	#instVars : [
		'rowIndex',
		'columnIndex',
		'rowBase',
		'columnBase'
	],
	#category : #'Spreadsheet-Core-Rules'
}

{ #category : #'instance creation' }
SpreadsheetRuleCellReference class >> fromString: aString [
	| str columnAbsolute column rowAbsolute row |
	str := aString asUppercase readStream.
	columnAbsolute := str peekFor: $$.
	column := 0.
	(str peek notNil and: [str peek isLetter]) ifFalse: [^nil].
	[str atEnd not and: [str peek >= $A and: [str peek <= $Z]]] whileTrue: [
		column := column * 26 + (str next asInteger - $A asInteger)].
	column := column+1.
	(column between: 1 and: 256) ifFalse: [^nil].
	rowAbsolute := str peekFor: $$.
	row := 0.
	[str atEnd not and: [str peek >= $0 and: [str peek <= $9]]] whileTrue: [
		row := row * 10 + (str next asInteger - $0 asInteger)].
	(row between: 1 and: 65536) ifFalse: [^nil].
	^self new row: row relative: rowAbsolute not column: column relative: columnAbsolute not
]

{ #category : #'instance creation' }
SpreadsheetRuleCellReference class >> isValidReference: aString [
	^(self fromString: aString) notNil
]

{ #category : #accessing }
SpreadsheetRuleCellReference >> cellReferences [
	^Array with: self
]

{ #category : #'initialize-release' }
SpreadsheetRuleCellReference >> makeRelativeTo: aCell [
	rowBase isNil ifFalse: [rowBase := aCell rowIndex].
	columnBase isNil ifFalse: [columnBase := aCell columnIndex].
]

{ #category : #accessing }
SpreadsheetRuleCellReference >> precedence [
	^5
]

{ #category : #accessing }
SpreadsheetRuleCellReference >> prerequisiteCellsFor: aCell [
	^Array with: (self referenceInCell: aCell)
]

{ #category : #printing }
SpreadsheetRuleCellReference >> printOn: aStream for: aCell precedence: ignored [
	| t c r |
	c := columnIndex.
	r := rowIndex.
	columnBase isNil
		ifTrue: [aStream nextPut: $$]
		ifFalse: [aCell notNil ifTrue: [c := c - columnBase + aCell columnIndex]].
	t := c -1 // 26.
	t > 0 ifTrue: [aStream nextPut: (Character value: $A asInteger -1 + t)].
	aStream nextPut: (Character value: $A asInteger + (c -1 \\ 26)).
	rowBase isNil
		ifTrue: [aStream nextPut: $$]
		ifFalse:  [aCell notNil ifTrue: [r := r - rowBase + aCell rowIndex]]..
	aStream print: r.
]

{ #category : #evaluating }
SpreadsheetRuleCellReference >> referenceInCell: aCell [
	| refPoint |
	refPoint := (columnBase isNil ifTrue: [columnIndex] ifFalse: [aCell columnIndex - columnBase + columnIndex])
				@ (rowBase isNil ifTrue: [rowIndex] ifFalse: [aCell rowIndex - rowBase + rowIndex]).
	^aCell sheet realCellAt: refPoint
]

{ #category : #'initialize-release' }
SpreadsheetRuleCellReference >> row: row relative: rowRelativeBool column: column relative: columnRelativeBool [
	rowIndex := row.
	rowBase := rowRelativeBool ifTrue: [1].
	columnIndex := column.
	columnBase := columnRelativeBool ifTrue: [1]
]

{ #category : #evaluating }
SpreadsheetRuleCellReference >> valueInCell: aCell [
	^(self referenceInCell: aCell) value
	
]
