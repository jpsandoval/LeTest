Class {
	#name : 'LeMinimize',
	#superclass : 'Object',
	#category : 'LeTest-Runner',
	#package : 'LeTest',
	#tag : 'Runner'
}

{ #category : 'as yet unclassified' }
LeMinimize >> minimize: testClass target: targetClass [

	| refactor toDelete toMaintain suite coveredNodes analysis mutationResult runner copyTestClass newName testsThatKillMutants |
	newName := 'Minimized' , targetClass name,'Test'.
	refactor := ReDuplicateClassRefactoring copyClass: testClass withName: newName. "refactor execute."
	copyTestClass := Smalltalk classNamed: newName.
	runner := LeRunner new.
	suite := copyTestClass buildSuite.
	coveredNodes := Set new.
	toDelete := OrderedCollection new.
	toMaintain := OrderedCollection new. "--- paso 1: minimizacion por coverage ---"
	suite tests do: [ :test |
			| collector result diff |
			collector := CoverageCollector new.
			collector methods: targetClass methods , targetClass class methods.
			result := collector runOn: [ test run ].
			diff := result nodes difference: coveredNodes.
			diff isEmpty
				ifTrue: [ toDelete add: test ]
				ifFalse: [
						toMaintain add: test.
						coveredNodes addAll: result nodes ] ]. "--- paso 2: mutation score sobre la suite completa ---"
	analysis := MTAnalysis new.
	analysis classesToMutate: { targetClass }.
	analysis testClasses: { copyTestClass }.
	analysis run.
	mutationResult := analysis generalResult. "--- paso 3: rescatar tests que matan mutantes aunque no aporten coverage ---"
	testsThatKillMutants := Set new.
	mutationResult killedMutants , mutationResult terminatedMutants do: [ :mutant |
		mutant result failures , mutant result errors do: [ :testResult | testsThatKillMutants add: testResult selector ] ]. "mover de toDelete a toMaintain si mata algun mutante"
	toDelete copy do: [ :test |
			(testsThatKillMutants includes: test selector) ifTrue: [
					toDelete remove: test.
					toMaintain add: test ] ]. "--- paso 4: borrar tests redundantes de la copia ---"
	toDelete do: [ :test | (copyTestClass includesSelector: test selector) ifTrue: [ copyTestClass removeSelector: test selector ] ].

	^ copyTestClass
]
