Class {
	#name : 'LeCoverageResult',
	#superclass : 'LeResult',
	#instVars : [
		'coverage',
		'methods',
		'notCoveredMethods',
		'nodes',
		'notCoveredNodes'
	],
	#category : 'LeTest-Runner',
	#package : 'LeTest',
	#tag : 'Runner'
}

{ #category : 'accessing' }
LeCoverageResult >> asJSON [

	^ String streamContents: [ :stream |
			  self printJSONOn: stream ]
]

{ #category : 'accessing' }
LeCoverageResult >> coverage [

	^ coverage
]

{ #category : 'accessing' }
LeCoverageResult >> coverage: anObject [

	coverage := anObject
]

{ #category : 'accessing' }
LeCoverageResult >> methods [

	^ methods
]

{ #category : 'accessing' }
LeCoverageResult >> methods: anObject [

	methods := anObject
]

{ #category : 'accessing' }
LeCoverageResult >> nodes [

	^ nodes
]

{ #category : 'accessing' }
LeCoverageResult >> nodes: anObject [

	nodes := anObject
]

{ #category : 'accessing' }
LeCoverageResult >> notCoveredMethods [

	^ notCoveredMethods
]

{ #category : 'accessing' }
LeCoverageResult >> notCoveredMethods: anObject [

	notCoveredMethods := anObject
]

{ #category : 'accessing' }
LeCoverageResult >> notCoveredNodes [

	^ notCoveredNodes
]

{ #category : 'accessing' }
LeCoverageResult >> notCoveredNodes: anObject [

	notCoveredNodes := anObject
]

{ #category : 'accessing' }
LeCoverageResult >> printJSONOn: aStream [

			  (NeoJSONWriter on: aStream)
				  mapInstVarsFor: self class;
				  nextPut: self 
]
