"
https://github.com/pharo-contributions/Pharo-Spreadsheet
"
Class {
	#name : #BaselineOfSpreadsheet,
	#superclass : #BaselineOf,
	#category : #BaselineOfSpreadsheet
}

{ #category : #baseline }
BaselineOfSpreadsheet >> baseline: spec [ 
	<baseline>
	
	spec for: #'common' do: [ 	
		spec 
			package: 'Collections-Sparse';
			package: 'Collections-Tests-Sparse' with: [ spec requires: #('Collections-Sparse') ];
			
			package: 'Spreadsheet-Core' with: [ spec requires: #('Collections-Sparse') ];
			package: 'Spreadsheet-UI' with: [ spec requires: #('Spreadsheet-Core') ];			
			package: 'Spreadsheet-Tests-Core' with: [ spec requires: #('Spreadsheet-Core') ];
			package: 'Spreadsheet-Tests-UI' with: [ spec requires: #('Spreadsheet-UI') ].
			
		spec 
			group: 'Core' with: #('Collections-Sparse' 'Spreadsheet-Core');
			group: 'UI' with: #('Spreadsheet-UI');
			group: 'Tests' with: #('Collections-Tests-Sparse' 'Spreadsheet-Tests-Core' 'Spreadsheet-Tests-UI');
			group: 'all' with: #('Core' 'UI' 'Tests');
			group: 'default' with: #('all').
	]

]
