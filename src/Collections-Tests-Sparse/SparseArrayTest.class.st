"
SUnit test for sparse array
"
Class {
	#name : #SparseArrayTest,
	#superclass : #TestCase,
	#category : #'Collections-Tests-Sparse-Collections'
}

{ #category : #testing }
SparseArrayTest >> testInitializationWithDefault [

	|arr|
	arr := SparseArray new: 10 withAll: 1.
	self assert: arr defaultValue = 1.
	
	(1 to: 10) do: [:index | 
		self assert: (arr at: index) = 1 ]


]

{ #category : #testing }
SparseArrayTest >> testSize [

	self assert: (SparseArray new:10) size = 10
]
