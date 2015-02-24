Class {
	#name : #SpreadsheetRuleCellReferenceTest,
	#superclass : #TestCase,
	#category : #'Spreadsheet-Tests-Core-Rules'
}

{ #category : #tests }
SpreadsheetRuleCellReferenceTest >> testInstanceCreation [

	self assert: (SpreadsheetRuleCellReference fromString: 'A2') notNil
	


]
