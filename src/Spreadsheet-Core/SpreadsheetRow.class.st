"
A row in a spreadsheet

Instance Variables
	cells:		<Object>
	height:		<Object>
	index:		<Object>
	sheet:		<Object>

cells
	- xxxxx

height
	- xxxxx

index
	- xxxxx

sheet
	- xxxxx

"
Class {
	#name : #SpreadsheetRow,
	#superclass : #SequenceableCollection,
	#instVars : [
		'sheet',
		'cells',
		'height',
		'index'
	],
	#category : #'Spreadsheet-Core-Model'
}

{ #category : #accessing }
SpreadsheetRow >> at: index [
	^cells at: index
]

{ #category : #accessing }
SpreadsheetRow >> at: index put: anObject [
	^cells at: index put: anObject
]

{ #category : #accessing }
SpreadsheetRow >> cells [
	^cells
]

{ #category : #accessing }
SpreadsheetRow >> height [
	^height
]

{ #category : #accessing }
SpreadsheetRow >> height: anInteger [
	height := anInteger.
	sheet changedRow: self
]

{ #category : #accessing }
SpreadsheetRow >> index [
	^index
]

{ #category : #accessing }
SpreadsheetRow >> index: anInteger [
	index := anInteger
]

{ #category : #testing }
SpreadsheetRow >> isDummy [
	^index = 0
]

{ #category : #copying }
SpreadsheetRow >> postCopy [
	super postCopy.
	cells := cells copy
]

{ #category : #'initialize-release' }
SpreadsheetRow >> sheet: aSpreadsheet [
	sheet := aSpreadsheet.
	index := 0.
	height := 14.
	cells := SparseArray new: aSpreadsheet columns size withAll: (SpreadsheetCell new sheet: aSpreadsheet)
]

{ #category : #accessing }
SpreadsheetRow >> size [
	^cells size
]
