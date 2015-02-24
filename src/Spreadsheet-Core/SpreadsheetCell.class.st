"
A cell in a spreadsheet

Instance Variables
	columnIndex:		<Object>
	rowIndex:		<Object>
	rule:		<Object>
	sheet:		<Object>
	value:		<Object>
	wave:		<Object>

columnIndex
	- xxxxx

rowIndex
	- xxxxx

rule
	- xxxxx

sheet
	- xxxxx

value
	- xxxxx

wave
	- xxxxx

"
Class {
	#name : #SpreadsheetCell,
	#superclass : #Model,
	#instVars : [
		'sheet',
		'value',
		'rule',
		'rowIndex',
		'columnIndex',
		'wave'
	],
	#category : #'Spreadsheet-Core-Model'
}

{ #category : #dependents }
SpreadsheetCell >> addDependent: aDependent [
	self isDummy ifFalse: [super addDependent: aDependent]
]

{ #category : #rules }
SpreadsheetCell >> attachToPrerequisites [
	self prerequisiteCells asSet do: [:each | each addDependent: self]
]

{ #category : #accessing }
SpreadsheetCell >> column [
	^sheet columns at: columnIndex
]

{ #category : #accessing }
SpreadsheetCell >> columnIndex [
	^columnIndex
]

{ #category : #accessing }
SpreadsheetCell >> computeWave [
	| max |
	max := 0.
	self prerequisiteCells do: [:each |
		each wave isNil ifTrue: [^false].
		max := max max: each wave].
	self prerequisiteCells do: [:each | each addDependent: self].
	wave := max + 1.
	^true
]

{ #category : #rules }
SpreadsheetCell >> detachFromPrerequisites [
	self prerequisiteCells do: [:each | each removeDependent: self]
]

{ #category : #testing }
SpreadsheetCell >> hasPrerequisites [
	^rule notNil and: [rule cellReferences notEmpty]
]

{ #category : #testing }
SpreadsheetCell >> isDummy [
	"Return true if this cell should never have a value, rule or dependents"
	^rowIndex = 0
]

{ #category : #accessing }
SpreadsheetCell >> point [
	^columnIndex @ rowIndex
]

{ #category : #accessing }
SpreadsheetCell >> point: aPoint [
	columnIndex := aPoint x.
	rowIndex := aPoint y
]

{ #category : #accessing }
SpreadsheetCell >> prerequisiteCells [
	rule isNil ifTrue: [^#()].
	^rule cellReferences collect: [:each | each referenceInCell: self]
]

{ #category : #printing }
SpreadsheetCell >> printOn: aStream [
	aStream nextPut: $[.
	columnIndex printAsColumnRefOn: aStream.
	rowIndex printOn: aStream.
	aStream space.
	value printOn: aStream.
	rule isNil ifFalse: [
		aStream space; nextPut: $=.
		rule printOn: aStream for: self precedence: 0].
	aStream nextPut: $]
]

{ #category : #recomputing }
SpreadsheetCell >> recomputeValue [
	self value: (rule valueInCell: self)
]

{ #category : #accessing }
SpreadsheetCell >> row [
	^sheet rows at: rowIndex
]

{ #category : #accessing }
SpreadsheetCell >> rowIndex [
	^rowIndex
]

{ #category : #accessing }
SpreadsheetCell >> rule [
	^rule
]

{ #category : #accessing }
SpreadsheetCell >> rule: aRuleOrNil [
	rule = aRuleOrNil ifTrue: [^self].
	self detachFromPrerequisites.
	rule := aRuleOrNil.
	sheet defineCalculationOrder.
	rule = nil ifFalse: [sheet markForRecalculation: self]
]

{ #category : #accessing }
SpreadsheetCell >> ruleString [
	| str |
	^rule isNil ifTrue: [''] ifFalse: [
		str := WriteStream on: String new.
		rule printOn: str for: self precedence: 0.
		str contents]
]

{ #category : #accessing }
SpreadsheetCell >> ruleString: aString [
	self rule: (SpreadsheetRuleParser new parse: aString forCell: self)
]

{ #category : #accessing }
SpreadsheetCell >> sheet [
	^sheet
]

{ #category : #'initialize-release' }
SpreadsheetCell >> sheet: aSpreadsheet [
	sheet := aSpreadsheet.
	rowIndex := columnIndex := 0
]

{ #category : #updating }
SpreadsheetCell >> update: aSymbol [
	aSymbol = #value ifTrue: [sheet markForRecalculation: self]
]

{ #category : #accessing }
SpreadsheetCell >> value [
	^value
]

{ #category : #accessing }
SpreadsheetCell >> value: anObject [
	(value class = anObject class and: [value = anObject])
		ifFalse: [
			value := anObject.
			self changed: #value.
			sheet changedCell: self]
]

{ #category : #accessing }
SpreadsheetCell >> valueString [
	value isNil ifTrue: [^''].
	value isString ifTrue: [^value].
	^value printString
]

{ #category : #accessing }
SpreadsheetCell >> valueString: aString [
	"first simple version. Later on this should be handled by the cell's format"
	(aString notEmpty and: [aString first = $=]) ifTrue: [
		^self ruleString: (aString copyFrom: 2 to: aString size)].
	self rule: nil.
	aString isEmpty ifTrue: [
		^self value: nil].
	aString first isDigit ifTrue: [
		^self value: aString asNumber].
	self value: aString
]

{ #category : #accessing }
SpreadsheetCell >> wave [
	^wave
]

{ #category : #accessing }
SpreadsheetCell >> wave: anInteger [
	wave := anInteger
]
