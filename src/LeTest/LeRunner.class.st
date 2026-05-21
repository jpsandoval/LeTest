Class {
	#name : 'LeRunner',
	#superclass : 'Object',
	#category : 'LeTest-Runner',
	#package : 'LeTest',
	#tag : 'Runner'
}

{ #category : 'coverage' }
LeRunner >> coverageFor: targetClass using: aTestCaseClass [

	| result collector coverage |
	collector := CoverageCollector new.
	collector methods: targetClass methods , targetClass class methods.
	coverage := collector runOn: [ aTestCaseClass buildSuite run ].
	result := LeCoverageResult new.
	result coverage: coverage percentage.
	result methods: (coverage methods collect: [:m| m methodClass name, '>>',m selector]).
	result nodes: (coverage nodes collect:#printString).
	result notCoveredMethods: (coverage uncoveredMethods collect: [:m| m methodClass name, '>>',m selector]).
	result notCoveredNodes: (coverage uncoveredNodes collect:#printString).
	^ result
]
