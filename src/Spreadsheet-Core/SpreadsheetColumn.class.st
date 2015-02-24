"
A column in a spreadsheet

Instance Variables
	index:		<Object>
	sheet:		<Object>
	width:		<Object>

index
	- xxxxx

sheet
	- xxxxx

width
	- xxxxx

"
Class {
	#name : #SpreadsheetColumn,
	#superclass : #SequenceableCollection,
	#instVars : [
		'sheet',
		'width',
		'index'
	],
	#category : #'Spreadsheet-Core-Model'
}

{ #category : #accessing }
SpreadsheetColumn >> at: anInteger [
	^(sheet rows at: anInteger) at: index
]

{ #category : #accessing }
SpreadsheetColumn >> at: anInteger put: anObject [
	^(sheet rows at: anInteger) at: index put: anObject
]

{ #category : #'initialize-release' }
SpreadsheetColumn >> index: anInteger [
	index := anInteger
]

{ #category : #testing }
SpreadsheetColumn >> isDummy [
	^index = 0
]

{ #category : #'initialize-release' }
SpreadsheetColumn >> sheet: aSpreadsheet [
	sheet := aSpreadsheet.
	index := 0.
	width := 70
]

{ #category : #accessing }
SpreadsheetColumn >> size [
	^sheet rows size
]

{ #category : #accessing }
SpreadsheetColumn >> width [
	^width
]

{ #category : #accessing }
SpreadsheetColumn >> width: anInteger [
	width := anInteger.
	sheet changedColumn: self
]
