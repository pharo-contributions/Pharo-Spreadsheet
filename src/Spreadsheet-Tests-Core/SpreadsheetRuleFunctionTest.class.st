"
SUnit test for SpreadsheetRuleFunction
"
Class {
	#name : #SpreadsheetRuleFunctionTest,
	#superclass : #TestCase,
	#category : #'Spreadsheet-Tests-Core-Rules'
}

{ #category : #tests }
SpreadsheetRuleFunctionTest >> testDATE [

	self assert: (SpreadsheetRuleFunction isValidFunctionName: 'DATE')
]

{ #category : #tests }
SpreadsheetRuleFunctionTest >> testDATEFunction [

	|function|
	function := SpreadsheetRuleFunction withName: 'DATE'.
	self assert: function notNil
]
