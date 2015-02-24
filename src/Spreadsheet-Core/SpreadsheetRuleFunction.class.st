"
A function in a spreadsheet rule
"
Class {
	#name : #SpreadsheetRuleFunction,
	#superclass : #SpreadsheetRulePart,
	#instVars : [
		'selector',
		'arguments'
	],
	#classVars : [
		'FunctionNames',
		'Precedences'
	],
	#category : #'Spreadsheet-Core-Rules'
}

{ #category : #'class initialization' }
SpreadsheetRuleFunction class >> initialize [
	"SpreadsheetRuleFunction initialize"
	FunctionNames := Dictionary new.
	Precedences := Dictionary new.
	self initializeFunctions.
	self initializeOperators
]

{ #category : #'class initialization' }
SpreadsheetRuleFunction class >> initializeFunctions [
	"SpreadsheetRuleFunction initializeFunctions"
	| selector |
	#('DATE')
	do: [:string |
		selector := (string asLowercase, ':') asSymbol.
		FunctionNames at: string put: selector.
		FunctionNames at: selector put: string]
]

{ #category : #'class initialization' }
SpreadsheetRuleFunction class >> initializeOperators [
	"SpreadsheetRuleFunction initializeOperators"
	#(
		('+' #plus:)
		('-' #minus:)
		('*' #mul:)
		('/' #div:))
	do: [:pair |
		FunctionNames at: pair first put: pair last.
		FunctionNames at: pair last put: pair first].
	'+-' do: [:each |
		Precedences at: (String with: each) put: 3].
	'*/' do: [:each |
		Precedences at: (String with: each) put: 4].
	
]

{ #category : #testing }
SpreadsheetRuleFunction class >> isValidFunctionName: aString [
	^FunctionNames includesKey: aString asUppercase
]

{ #category : #'instance creation' }
SpreadsheetRuleFunction class >> withName: aString [
	^self new selector: (FunctionNames at: aString asUppercase)
]

{ #category : #accessing }
SpreadsheetRuleFunction >> arguments: aCollection [
	arguments := aCollection
]

{ #category : #accessing }
SpreadsheetRuleFunction >> cellReferences [
	| result |
	result := OrderedCollection new.
	arguments do: [:each | result addAll: each cellReferences].
	^result
]

{ #category : #functions }
SpreadsheetRuleFunction >> date: aCell [
	^Date today
]

{ #category : #functions }
SpreadsheetRuleFunction >> div: operandValues [
	| result |
	result := operandValues first.
	2 to: operandValues size do: [:i | result := result / (operandValues at: i)].
	^result
]

{ #category : #accessing }
SpreadsheetRuleFunction >> initialize [
	arguments := #()
]

{ #category : #functions }
SpreadsheetRuleFunction >> minus: operandValues [
	| result |
	result := operandValues first.
	2 to: operandValues size do: [:i | result := result - (operandValues at: i)].
	^result
]

{ #category : #functions }
SpreadsheetRuleFunction >> mul: operandValues [
	| result |
	result := operandValues first.
	2 to: operandValues size do: [:i | result := result * (operandValues at: i)].
	^result
]

{ #category : #functions }
SpreadsheetRuleFunction >> plus: operandValues [
	| result |
	result := operandValues first.
	2 to: operandValues size do: [:i | result := result + (operandValues at: i)].
	^result
]

{ #category : #accessing }
SpreadsheetRuleFunction >> precedence [
	^Precedences at: (FunctionNames at: selector) ifAbsent: [5]
]

{ #category : #accessing }
SpreadsheetRuleFunction >> prerequisiteCellsFor: aCell [
	| result |
	result := aCell.
	arguments do: [:each | result addAll: (each prerequisiteCellsFor: aCell)].
	^result
]

{ #category : #printing }
SpreadsheetRuleFunction >> printOn: aStream for: aCell precedence: outerPrecedence [
	| name |
	name := FunctionNames at: selector.
	name first isLetter
		ifTrue: [
			aStream nextPutAll: name; nextPut: $(.
			arguments
				do: [:each | each printOn: aStream  for: aCell precedence: 0]
				separatedBy: [aStream nextPutAll: ', '].
			aStream nextPut: $)]
		ifFalse: [
			outerPrecedence > self precedence ifTrue: [aStream nextPut: $(].
			arguments first printOn: aStream for: aCell precedence: self precedence.
			2 to: arguments size do: [:i |
				aStream nextPutAll: name.
				(arguments at: i) printOn: aStream for: aCell precedence: self precedence+1].
			outerPrecedence > self precedence ifTrue: [aStream nextPut: $)]]
]

{ #category : #accessing }
SpreadsheetRuleFunction >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #evaluating }
SpreadsheetRuleFunction >> valueInCell: aCell [
	^[self perform: selector with: (arguments collect: [:each | each valueInCell: aCell])]
		on: Error
		do: [:ex | ex return: #Error]
]
