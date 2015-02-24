Class {
	#name : #SpreadsheetRuleConstantTest,
	#superclass : #TestCase,
	#category : #'Spreadsheet-Tests-Core-Rules'
}

{ #category : #tests }
SpreadsheetRuleConstantTest >> testInstanceCreation [

	self assert: (SpreadsheetRuleConstant value: 42) notNil
]
