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

{ #category : 'coverage' }
LeRunner >> mutationFor: targetClass using: aTestCaseClass [

	| analysis mutationResult result |
	analysis := MTAnalysis new.
	analysis classesToMutate: { targetClass }.
	analysis testClasses: { aTestCaseClass }.

	analysis run.
	mutationResult := analysis generalResult.
	result := LeMutationResult new.
	result mutationScore: mutationResult mutationScore.
	result allMutants: ((mutationResult particularResults collect:#mutant) collect:#printString).
	result aliveMutants: ((mutationResult aliveMutants collect:#mutant) collect:#printString).
	result terminatedMutants: ((mutationResult terminatedMutants collect:#mutant) collect:#printString).
	result killedMutants: ((mutationResult aliveMutants collect:#mutant) collect:#printString).
	^ result
]
