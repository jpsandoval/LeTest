Class {
	#name : 'LeRunner',
	#superclass : 'Object',
	#category : 'LeTest-Runner',
	#package : 'LeTest',
	#tag : 'Runner'
}

{ #category : 'coverage' }
LeRunner >> coverageFor: targetClass using: aTestCaseClass [

	| collector coverage |
	collector := CoverageCollector new.
	collector methods: (targetClass methods, targetClass class methods).
	coverage := collector runOn: [ aTestCaseClass buildSuite run ].
	^ coverage
]
