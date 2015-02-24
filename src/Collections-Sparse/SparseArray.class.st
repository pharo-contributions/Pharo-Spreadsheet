"
A sparse array is an array in which most of the elements have the same value.

Instance Variables
	defaultValue:		<Object>
	ranges:		<Object>
	size:		<Object>

defaultValue
	- xxxxx

ranges
	- xxxxx

size
	- xxxxx

"
Class {
	#name : #SparseArray,
	#superclass : #SequenceableCollection,
	#instVars : [
		'ranges',
		'size',
		'defaultValue'
	],
	#category : #'Collections-Sparse-Sequencable'
}

{ #category : #'instance creation' }
SparseArray class >> new: size [
	^self basicNew initSize: size
]

{ #category : #'instance creation' }
SparseArray class >> new: size withAll: anObject [
	^(self new: size) defaultValue: anObject; yourself
]

{ #category : #accessing }
SparseArray >> at: index [
	ranges do: [:each | (each includesIndex: index) ifTrue: [^ each at: index]].
	^defaultValue
]

{ #category : #accessing }
SparseArray >> at: index put: value [
	| i |
	ranges do: [:each |
		(each includesIndex: index) ifTrue: [^ each at: index put: value]].
	ranges do: [:each |
		(each hasAdjacentIndex: index) ifTrue: [
			each at: index put: value.
			self coalesceRanges.
			^value]].
	i := ranges findFirst: [:each | each firstIndex > index].
	i = 0 ifTrue: [i := ranges size+1].
	ranges := (Array new: ranges size+1)
		replaceFrom: 1 to: i-1 with: ranges startingAt: 1;
		at: i put: (SparseArrayRange new index: index value: value);
		replaceFrom: i+1 to: ranges size+1 with: ranges startingAt: i;
		yourself.
	^value
]

{ #category : #'private - utilities' }
SparseArray >> coalesceRanges [
	"This is called when two ranges might be adjacent and could be coalesced. Only one such pair can exist at any time"
	| first next |
	first := ranges first.
	2 to: ranges size do: [:i |
		next := ranges at: i.
		(first coalesce: next) ifTrue: [
			ranges := ranges copyWithout: next.
			^self]]
]

{ #category : #'private - accessing' }
SparseArray >> defaultValue [
	^defaultValue
]

{ #category : #'private - accessing' }
SparseArray >> defaultValue: anObject [
	defaultValue := anObject
]

{ #category : #'initialize-release' }
SparseArray >> initSize: anInteger [
	size := anInteger.
	ranges := Array new
]

{ #category : #enumerating }
SparseArray >> nonEmptyElementsDo: aBlock [
	ranges do: [:each |
		each values do: aBlock]
]

{ #category : #copying }
SparseArray >> postCopy [
	super postCopy.
	ranges := ranges collect: [:each | each copy]
]

{ #category : #accessing }
SparseArray >> size [
	^size
]
