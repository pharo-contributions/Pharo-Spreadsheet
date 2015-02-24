"
A parser for the spreadsheet rules

Instance Variables
	cell:		<Object>
	result:		<Object>
	source:		<Object>
	token:		<Object>
	tokenBuffer:		<Object>
	tokenType:		<Object>

cell
	- xxxxx

result
	- xxxxx

source
	- xxxxx

token
	- xxxxx

tokenBuffer
	- xxxxx

tokenType
	- xxxxx

"
Class {
	#name : #SpreadsheetRuleParser,
	#superclass : #Object,
	#instVars : [
		'source',
		'token',
		'tokenType',
		'result',
		'tokenBuffer',
		'cell'
	],
	#classVars : [
		'TokenTypes'
	],
	#category : #'Spreadsheet-Core-Rules'
}

{ #category : #'class initialization' }
SpreadsheetRuleParser class >> initialize [
	"self initialize"
	TokenTypes := Array new: 256 withAll: #undefined.
	self tokenType: #xLetter for: $A to: $Z.
	self tokenType: #xLetter for: $a to: $z.
	self tokenType: #xLetter for: $$.
	self tokenType: #xDigit for: $0 to: $9.
	self tokenType: #xQuote forAll: '''"'.
	self tokenType: #leftParen for: $(.
	self tokenType: #rightParen for: $).
	self tokenType: #addOp forAll: '+-'.
	self tokenType: #mulOp forAll: '*/'.
	
]

{ #category : #'class initialization' }
SpreadsheetRuleParser class >> tokenType: aSymbol for: aCharacter [
	TokenTypes at: aCharacter asInteger+1 put: aSymbol
]

{ #category : #'class initialization' }
SpreadsheetRuleParser class >> tokenType: aSymbol for: firstCharacter to: lastCharacter [
	firstCharacter asInteger to: lastCharacter asInteger do: [:i | TokenTypes at:i+1 put: aSymbol]
]

{ #category : #'class initialization' }
SpreadsheetRuleParser class >> tokenType: aSymbol forAll: aString [
	aString do: [:char | TokenTypes at: char asInteger+1 put: aSymbol]
]

{ #category : #parsing }
SpreadsheetRuleParser >> cellReference [
	tokenType = #cellReference ifFalse: [^false].
	result := SpreadsheetRuleCellReference fromString: token.
	result makeRelativeTo: cell.
	self getToken.
	^true
]

{ #category : #parsing }
SpreadsheetRuleParser >> expression [
	^self sum
]

{ #category : #parsing }
SpreadsheetRuleParser >> factor [
	self primary ifTrue: [^true].
	tokenType = #leftParen ifTrue: [
		self getToken.
		self expression ifFalse: [self error: 'expression expected'].
		tokenType = #rightParen ifFalse: [self error: 'right parenthesis expected'].
		self getToken.
		^true].
	^false
]

{ #category : #parsing }
SpreadsheetRuleParser >> function [
	| func args |
	tokenType = #functionName ifFalse: [^false].
	func := token.
	self getToken.
	tokenType = #leftParenthesis ifFalse: [
		"function without args can be written without parentheses"
		result := SpreadsheetRuleFunction withName: func.
		^true].
	args := OrderedCollection new.
	self getToken.
	tokenType = #rightParenthesis ifTrue: [
		"empty open/close parentheses"
		result := SpreadsheetRuleFunction withName: func.
		^true].
	[self expression ifFalse: [self expected: #expression].
	args add: result.
	tokenType = #comma] whileTrue: [self getToken].
	tokenType = #rightParenthesis ifFalse: [self expected: 'comma or right parenthesis'].
	self getToken.
	result := SpreadsheetRuleFunction withName: func.
	result arguments: args.
	^true
]

{ #category : #scanning }
SpreadsheetRuleParser >> getToken [
	source skipSeparators.
	source atEnd ifTrue: [
		token := nil.
		^tokenType := #eof].
	token := source next.
	tokenType := TokenTypes at: token asInteger + 1.
	tokenType first = $x ifTrue: [self perform: tokenType].
	^tokenType
]

{ #category : #parsing }
SpreadsheetRuleParser >> number [
	tokenType = #number ifTrue: [
		result := SpreadsheetRuleConstant value: token asNumber.
		self getToken.
		^true].
	^false
]

{ #category : #parsing }
SpreadsheetRuleParser >> parse: aString [
	^self parse: aString forCell: (SpreadsheetCell new point: 1@1)
]

{ #category : #parsing }
SpreadsheetRuleParser >> parse: aString forCell: aCell [
	cell := aCell.
	source := aString readStream.
	tokenBuffer := WriteStream on: (String new: 20).
	self getToken.
	self expression ifFalse: [self error: 'expression expected'].
	tokenType = #eof ifFalse: [self error: 'end of input expected'].
	^result
]

{ #category : #parsing }
SpreadsheetRuleParser >> primary [
	self number ifTrue: [^true].
	self cellReference ifTrue: [^true].
	self function ifTrue: [^true].
	^false
]

{ #category : #parsing }
SpreadsheetRuleParser >> sum [
	| args operator function |
	self term ifFalse: [^false].
	tokenType = #addOp ifFalse: [^true].
	args := OrderedCollection with: result.
	operator := token.
	[tokenType = #addOp] whileTrue: [
		token = operator ifFalse: [
			function := SpreadsheetRuleFunction withName: operator asString.
			function arguments: args.
			args := OrderedCollection with: function.
			operator := token].
		self getToken.
		self term ifFalse: [self error: 'term expected'].
		args add: result].
	args size = 1
		ifTrue: [result := args first]
		ifFalse: [
			result := SpreadsheetRuleFunction withName: operator asString.
			result arguments: args].
	^true
]

{ #category : #parsing }
SpreadsheetRuleParser >> term [
	| args operator function |
	self factor ifFalse: [^false].
	tokenType = #mulOp ifFalse: [^true].
	args := OrderedCollection with: result.
	operator := token.
	[tokenType = #mulOp] whileTrue: [
		token = operator ifFalse: [
			function := SpreadsheetRuleFunction withName: operator asString.
			function arguments: args.
			args := OrderedCollection with: function.
			operator := token].
		self getToken.
		self factor ifFalse: [self error: 'factor expected'].
		args add: result].
	args size = 1
		ifTrue: [result := args first]
		ifFalse: [
			result := SpreadsheetRuleFunction withName: operator asString.
			result arguments: args].
	^true
]

{ #category : #scanning }
SpreadsheetRuleParser >> xDigit [
	tokenBuffer reset; nextPut: token.
	[source atEnd not and: [source peek isDigit]] whileTrue: [
		tokenBuffer nextPut: source next].
	(source peekFor: $.) ifTrue: [
		tokenBuffer nextPut: $..
		[source atEnd not and: [source peek isDigit]] whileTrue: [
			tokenBuffer nextPut: source next]].
	token := tokenBuffer contents.
	tokenType := #number
]

{ #category : #scanning }
SpreadsheetRuleParser >> xLetter [
	tokenBuffer reset; nextPut: token.
	[source atEnd not and: [source peek isDigit or: [(TokenTypes at: source peek asInteger+1) = #xLetter]]] whileTrue: [
		tokenBuffer nextPut: source next].
	token := tokenBuffer contents.
	(SpreadsheetRuleFunction isValidFunctionName: token) ifTrue: [
		^tokenType := #functionName].
	(SpreadsheetRuleCellReference isValidReference: token) ifTrue: [
		^tokenType := #cellReference].
	tokenType := #identifier
]
