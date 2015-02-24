"
SUnit test for SpreadsheetCell

"
Class {
	#name : #SpreadsheetCellTest,
	#superclass : #TestCase,
	#category : #'Spreadsheet-Tests-Core-Model'
}

{ #category : #tests }
SpreadsheetCellTest >> testPrintAsColumnRefOn [
	| stream |
	stream := WriteStream on: String new.
	1 printAsColumnRefOn: stream.
	self assert: ( stream contents = 'A' ).
	
	stream := WriteStream on: String new.
	26 printAsColumnRefOn: stream.
	self assert: ( stream contents = 'Z' ).
	
	stream := WriteStream on: String new.
	27 printAsColumnRefOn: stream.
	self assert: ( stream contents = 'AA' ).
	
	stream := WriteStream on: String new.
	52 printAsColumnRefOn: stream.
	self assert: ( stream contents = 'AZ' ).
	
	stream := WriteStream on: String new.
	53 printAsColumnRefOn: stream.
	self assert: ( stream contents = 'BA' ).
]
