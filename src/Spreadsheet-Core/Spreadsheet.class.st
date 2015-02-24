"
A spreadsheet with rows and columns

Instance Variables
	cachedColumnIndex:		<Object>
	cachedColumnLeft:		<Object>
	cachedRowIndex:		<Object>
	cachedRowTop:		<Object>
	columns:		<Object>
	rows:		<Object>
	waves:		<Object>

cachedColumnIndex
	- xxxxx

cachedColumnLeft
	- xxxxx

cachedRowIndex
	- xxxxx

cachedRowTop
	- xxxxx

columns
	- xxxxx

rows
	- xxxxx

waves
	- xxxxx

"
Class {
	#name : #Spreadsheet,
	#superclass : #Model,
	#instVars : [
		'rows',
		'columns',
		'cachedRowIndex',
		'cachedRowTop',
		'cachedColumnIndex',
		'cachedColumnLeft',
		'waves'
	],
	#category : #'Spreadsheet-Core-Model'
}

{ #category : #calculating }
Spreadsheet >> calculate [
	| lastW w |
	lastW := -1.
	[waves isEmpty] whileFalse: [
		w := waves keys asSortedCollection first.
		w <= lastW ifTrue: [self error: 'dependency circle'].
		lastW := w.
		(waves removeKey: w) do: [:cell | cell recomputeValue]]
]

{ #category : #accessing }
Spreadsheet >> cellAt: aPoint [
	^(rows at: aPoint y) at: aPoint x
]

{ #category : #accessing }
Spreadsheet >> cellRuleOrValueStringAt: aPoint [
	| cell |
	cell := (self cellAt: aPoint).
	^cell rule isNil
		ifTrue: [cell valueString]
		ifFalse: ['=', cell ruleString]
]

{ #category : #accessing }
Spreadsheet >> cellStringAt: aPoint [
	^(self cellAt: aPoint) valueString
]

{ #category : #accessing }
Spreadsheet >> cellStringAt: aPoint put: aString [
	(self realCellAt: aPoint) valueString: aString.
	self calculate
]

{ #category : #enumerating }
Spreadsheet >> cellsDo: aBlock [
	rows nonEmptyElementsDo: [:row | row cells nonEmptyElementsDo: aBlock]
]

{ #category : #changing }
Spreadsheet >> changedCell: aCell [
	self changed: #display with: (aCell point corner: aCell point)
]

{ #category : #changing }
Spreadsheet >> changedColumn: aColumn [
	cachedColumnIndex := cachedColumnLeft := nil.
	self changed: #displayFull
]

{ #category : #changing }
Spreadsheet >> changedRow: aColumn [
	cachedRowIndex := cachedRowTop := nil.
	self changed: #displayFull
]

{ #category : #'accessing-geometry' }
Spreadsheet >> columnLeftAt: index [
	index = cachedColumnIndex ifTrue: [^cachedColumnLeft].
	(cachedColumnIndex = nil or: [cachedColumnIndex > (index*2)]) ifTrue: [
		"search from beginning"
		cachedColumnLeft := 0.
		1 to: index-1 do: [:i | cachedColumnLeft := cachedColumnLeft + (columns at: i) width].
		cachedColumnIndex := index.
		^cachedColumnLeft].
	[cachedColumnIndex > index] whileTrue: [
		cachedColumnIndex := cachedColumnIndex-1.
		cachedColumnLeft := cachedColumnLeft - (columns at: cachedColumnIndex) width].
	[cachedColumnIndex < index] whileTrue: [
		cachedColumnLeft := cachedColumnLeft + (columns at: cachedColumnIndex) width.
		cachedColumnIndex := cachedColumnIndex+1].
	^cachedColumnLeft
]

{ #category : #'accessing-geometry' }
Spreadsheet >> columnRightAt: index [
	^self columnLeftAt: index+1
]

{ #category : #accessing }
Spreadsheet >> columns [
	^columns
]

{ #category : #'accessing-geometry' }
Spreadsheet >> cornerForCellPoint: aPoint [
	^(self columnRightAt: aPoint x) @ (self rowBottomAt: aPoint y)
]

{ #category : #calculating }
Spreadsheet >> defineCalculationOrder [
	| todo nextTodo |
	todo := OrderedCollection new.
	self cellsDo: [:cell |
		cell hasPrerequisites
			ifTrue: [
				cell detachFromPrerequisites.
				todo add: cell]
			ifFalse: [cell wave: 0]].
	[todo isEmpty] whileFalse: [
		nextTodo := OrderedCollection new.
		todo do: [:cell |
			cell computeWave ifFalse: [nextTodo add: cell]].
		nextTodo size = todo size ifTrue: ["break circular dependeny" self halt].
		todo := nextTodo]
]

{ #category : #'initialize-release' }
Spreadsheet >> initialize [
	columns := SparseArray new: 256 withAll: (SpreadsheetColumn new sheet: self; width: 70).
	rows := SparseArray new: 16384 withAll: (SpreadsheetRow new sheet: self; height: 15).
	waves := Dictionary new
]

{ #category : #calculating }
Spreadsheet >> markForRecalculation: aCell [
	waves isNil ifTrue: [waves := Dictionary new].
	(waves at: aCell wave ifAbsentPut: [Set new]) add: aCell
]

{ #category : #'accessing-geometry' }
Spreadsheet >> originForCellPoint: aPoint [
	^(self columnLeftAt: aPoint x) @ (self rowTopAt: aPoint y)
]

{ #category : #accessing }
Spreadsheet >> realCellAt: aPoint [
	| cell r c |
	cell := (r := rows at: aPoint y) at: aPoint x.
	cell isDummy ifTrue: [
		cell := cell copy point: aPoint.
		r isDummy ifTrue: [
			rows at: aPoint y put: (r := r copy)].
		r at: aPoint x put: cell.
		c := columns at: aPoint x.
		c isDummy ifTrue: [
			columns at: aPoint x put: (c copy index: aPoint x)]].
	^cell
]

{ #category : #calculating }
Spreadsheet >> recalculate [
	waves := Dictionary new.
	self cellsDo: [:each |
		each rule isNil ifFalse: [self markForRecalculation: each]].
	self calculate
]

{ #category : #accessing }
Spreadsheet >> rowAt: index [
	| row |
	row := rows at: index.
	row isDummy ifTrue: [row := row copy index: index].
	^row
]

{ #category : #'accessing-geometry' }
Spreadsheet >> rowBottomAt: index [
	^self rowTopAt: index+1
]

{ #category : #'accessing-geometry' }
Spreadsheet >> rowTopAt: index [
	index = cachedRowIndex ifTrue: [^cachedRowTop].
	(cachedRowIndex = nil or: [cachedRowIndex > (index*2)]) ifTrue: [
		"search from beginning"
		cachedRowTop := 0.
		1 to: index-1 do: [:i | cachedRowTop := cachedRowTop + (rows at: i) height].
		cachedRowIndex := index.
		^cachedRowTop].
	[cachedRowIndex > index] whileTrue: [
		cachedRowIndex := cachedRowIndex-1.
		cachedRowTop := cachedRowTop - (rows at: cachedRowIndex) height].
	[cachedRowIndex < index] whileTrue: [
		cachedRowTop := cachedRowTop + (rows at: cachedRowIndex) height.
		cachedRowIndex := cachedRowIndex+1].
	^cachedRowTop
]

{ #category : #accessing }
Spreadsheet >> rows [
	^rows
]

{ #category : #accessing }
Spreadsheet >> valueAt: aPoint [
	^(self cellAt: aPoint) value
]

{ #category : #accessing }
Spreadsheet >> valueAt: aPoint put: anObject [
	| cell |
	cell := self realCellAt: aPoint.
	cell value: anObject
]

{ #category : #'accessing-geometry' }
Spreadsheet >> visibleColumnsIn: aRectangle [
	| x first last |
	x := 0.
	first := (1 to: columns size)
			detect: [:i |
				x := x + (columns at: i) width.
				x > aRectangle left]
			ifNone: [0].
	first = 0 ifTrue: [^1 to: 0].
	x > aRectangle right ifTrue: [^first to: first].
	last := (first+1 to: columns size)
			detect: [:i |
				x := x + (columns at: i) width.
				x > aRectangle right]
			ifNone: [columns size].
	^first to: last
]

{ #category : #'accessing-geometry' }
Spreadsheet >> visibleRowsIn: aRectangle [
	| y first last |
	y := 0.
	first := (1 to: rows size)
			detect: [:i |
				y := y + (rows at: i) height.
				y > aRectangle top]
			ifNone: [0].
	first = 0 ifTrue: [^1 to: 0].
	y > aRectangle bottom ifTrue: [^first to: first].
	last := (first+1 to: rows size)
			detect: [:i |
				y := y + (rows at: i) height.
				y > aRectangle bottom]
			ifNone: [rows size].
	^first to: last
]
