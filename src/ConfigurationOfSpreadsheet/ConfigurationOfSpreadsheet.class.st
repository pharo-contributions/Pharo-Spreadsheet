"
A configuration for spreadsheet 

Instance Variables
	project:		<Object>

project
	- xxxxx

"
Class {
	#name : #ConfigurationOfSpreadsheet,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfSpreadsheet
}

{ #category : #'development support' }
ConfigurationOfSpreadsheet class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfSpreadsheet class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #private }
ConfigurationOfSpreadsheet class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfSpreadsheet class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfSpreadsheet class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfSpreadsheet class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfSpreadsheet class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfSpreadsheet class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfSpreadsheet class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfSpreadsheet class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfSpreadsheet >> baseline01: spec [
	<version: '0.1-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/TorstenBergmann/Spreadsheet/main/'.
		spec 
			package: #'Collections-Sparse';
			package: #'Spreadsheet-Core' with: [
				spec requires: #(#'Collections-Sparse' ). ];
			package: #'Spreadsheet-UI' with: [
				spec requires: #(#'Spreadsheet-Core' ). ];
			package: #'Collections-Tests-Sparse' with: [
				spec requires: #(#'Collections-Sparse' ). ];
			package: #'Spreadsheet-Tests-Core' with: [
				spec requires: #(#'Spreadsheet-Core' ). ];
			package: #'Spreadsheet-Tests-UI' with: [
				spec requires: #(#'Spreadsheet-UI' ). ].
		spec 
			group: 'Sparse' with: #(#'Collections-Sparse' );
			group: 'Core' with: #(#'Spreadsheet-Core' );
			group: 'UI' with: #(#'Spreadsheet-UI' );
			group: 'Tests' with: #(#'Collections-Tests-Sparse' #'Spreadsheet-Tests-Core' #'Spreadsheet-Tests-UI' );
			group: 'default' with: #('Sparse' 'Core' 'UI' 'Tests' ). ].

]

{ #category : #baselines }
ConfigurationOfSpreadsheet >> baseline02: spec [
	<version: '0.2-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/TorstenBergmann/Spreadsheet/main/'.
		spec 
			package: #'Collections-Sparse';
			package: #'Spreadsheet-Core' with: [
				spec requires: #(#'Collections-Sparse' ). ];
			package: #'Spreadsheet-UI' with: [
				spec requires: #(#'Spreadsheet-Core' ). ];
			package: #'Collections-Tests-Sparse' with: [
				spec requires: #(#'Collections-Sparse' ). ];
			package: #'Spreadsheet-Tests-Core' with: [
				spec requires: #(#'Spreadsheet-Core' ). ];
			package: #'Spreadsheet-Tests-UI' with: [
				spec requires: #(#'Spreadsheet-UI' ). ].
		spec 
			group: 'Sparse' with: #(#'Collections-Sparse' );
			group: 'Core' with: #(#'Spreadsheet-Core' );
			group: 'UI' with: #(#'Spreadsheet-UI' );
			group: 'Tests' with: #(#'Collections-Tests-Sparse' #'Spreadsheet-Tests-Core' #'Spreadsheet-Tests-UI' );
			group: 'default' with: #('Sparse' 'Core' 'UI' 'Tests' ). ].

]

{ #category : #accessing }
ConfigurationOfSpreadsheet >> customProjectAttributes [
	 "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes"

	^ #().
]

{ #category : #'symbolic versions' }
ConfigurationOfSpreadsheet >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '0.2-baseline'.

]

{ #category : #accessing }
ConfigurationOfSpreadsheet >> project [

	^ project ifNil: [ 
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		project := MetacelloMCProject new projectAttributes: self customProjectAttributes. 
		(Smalltalk at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfSpreadsheet >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '1.0'.

]

{ #category : #versions }
ConfigurationOfSpreadsheet >> version10: spec [
	<version: '1.0' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 1.0'.
		spec author: 'TorstenBergmann'.
		spec timestamp: '2/24/2015 01:15'.
		spec 
			package: #'Collections-Sparse' with: 'Collections-Sparse-TorstenBergmann.1';
			package: #'Spreadsheet-Core' with: 'Spreadsheet-Core-TorstenBergmann.1';
			package: #'Spreadsheet-UI' with: 'Spreadsheet-UI-TorstenBergmann.1';
			package: #'Collections-Tests-Sparse' with: 'Collections-Tests-Sparse-TorstenBergmann.1';
			package: #'Spreadsheet-Tests-Core' with: 'Spreadsheet-Tests-Core-TorstenBergmann.1';
			package: #'Spreadsheet-Tests-UI' with: 'Spreadsheet-Tests-UI-TorstenBergmann.1'. ].

]
