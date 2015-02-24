"
A range in a sparse array
"
Class {
	#name : #SparseArrayRange,
	#superclass : #Object,
	#instVars : [
		'firstIndex',
		'lastIndex',
		'values'
	],
	#category : #'Collections-Sparse-Utilities'
}

{ #category : #accessing }
SparseArrayRange >> at: index [
	^values at: index-firstIndex+1
]

{ #category : #accessing }
SparseArrayRange >> at: index put: anObject [
	index+1 = firstIndex ifTrue: [
		firstIndex := index.
		values := values copyWithFirst: anObject.
		^anObject].
	index-1 = lastIndex ifTrue: [
		lastIndex := index.
		values := values copyWith: anObject.
		^anObject].
	^values at: index-firstIndex+1 put: anObject
]

{ #category : #coalescing }
SparseArrayRange >> coalesce: aRange [
	"Merge the two ranges if there is no remaining space between them. Return true if merge happened."
	lastIndex +1 = aRange firstIndex ifFalse: [^false].
	values := values, aRange values.
	lastIndex := aRange lastIndex.
	^true
]

{ #category : #accessing }
SparseArrayRange >> firstIndex [
	^firstIndex
]

{ #category : #testing }
SparseArrayRange >> hasAdjacentIndex: index [
	^index + 1 = firstIndex or: [index - 1 = lastIndex]
]

{ #category : #testing }
SparseArrayRange >> hasIndex: anInteger [
	^anInteger between: firstIndex and: lastIndex
]

{ #category : #testing }
SparseArrayRange >> includesIndex: anInteger [
	^anInteger between: firstIndex and: lastIndex
]

{ #category : #'initialize-release' }
SparseArrayRange >> index: index value: anObject [
	firstIndex := lastIndex := index.
	values := Array with: anObject
]

{ #category : #accessing }
SparseArrayRange >> lastIndex [
	^lastIndex
]

{ #category : #copying }
SparseArrayRange >> postCopy [
	super postCopy.
	values := values copy
]

{ #category : #printing }
SparseArrayRange >> printOn: aStream [
	super printOn: aStream.
	aStream space; print: firstIndex; nextPutAll: '..'; print: lastIndex
]

{ #category : #accessing }
SparseArrayRange >> values [
	^values
]
