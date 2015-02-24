Extension { #name : #Integer }

{ #category : #'*Spreadsheet-Core' }
Integer >> printAsColumnRefOn: aStream [
	| modulo |
	(self < 1) ifTrue: [ ^self ].
	modulo := (self - 1) \\ 26.
	((self - modulo) // 26) printAsColumnRefOn: aStream.
	aStream nextPut: (($A to: $Z) at: (modulo + 1)).
	
	"SpreadSheetTest new testPrintAsColumnRefOn"

	
]
