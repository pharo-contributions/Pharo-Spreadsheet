"
A constant in a spreadsheet rule (like a number)
"
Class {
	#name : #SpreadsheetRuleConstant,
	#superclass : #SpreadsheetRulePart,
	#instVars : [
		'value'
	],
	#category : #'Spreadsheet-Core-Rules'
}

{ #category : #'instance creation' }
SpreadsheetRuleConstant class >> value: anObject [
	^self new value: anObject
]

{ #category : #accessing }
SpreadsheetRuleConstant >> precedence [
	^5
]

{ #category : #printing }
SpreadsheetRuleConstant >> printOn: aStream for: aCell precedence: precedence [
	value printOn: aStream
]

{ #category : #accessing }
SpreadsheetRuleConstant >> value: anObject [
	value := anObject
]

{ #category : #evaluating }
SpreadsheetRuleConstant >> valueInCell: aCell [
	^value
]
