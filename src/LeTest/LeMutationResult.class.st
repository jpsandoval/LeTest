Class {
	#name : 'LeMutationResult',
	#superclass : 'LeResult',
	#instVars : [
		'mutationScore',
		'allMutants',
		'aliveMutants',
		'terminatedMutants',
		'killedMutants'
	],
	#category : 'LeTest-Runner',
	#package : 'LeTest',
	#tag : 'Runner'
}

{ #category : 'accessing' }
LeMutationResult >> aliveMutants [

	^ aliveMutants
]

{ #category : 'accessing' }
LeMutationResult >> aliveMutants: anObject [

	aliveMutants := anObject
]

{ #category : 'accessing' }
LeMutationResult >> allMutants [

	^ allMutants
]

{ #category : 'accessing' }
LeMutationResult >> allMutants: anObject [

	allMutants := anObject
]

{ #category : 'converting' }
LeMutationResult >> asJSON [

	^ String streamContents: [ :stream | self printJSONOn: stream].
]

{ #category : 'accessing' }
LeMutationResult >> killedMutants [

	^ killedMutants
]

{ #category : 'accessing' }
LeMutationResult >> killedMutants: anObject [

	killedMutants := anObject
]

{ #category : 'accessing' }
LeMutationResult >> mutationScore [

	^ mutationScore
]

{ #category : 'accessing' }
LeMutationResult >> mutationScore: anObject [

	mutationScore := anObject
]

{ #category : 'converting' }
LeMutationResult >> printJSONOn: aStream [
	^ 
			  (NeoJSONWriter on: aStream)
				  mapInstVarsFor: self class;
				  nextPut: self
]

{ #category : 'accessing' }
LeMutationResult >> terminatedMutants [

	^ terminatedMutants
]

{ #category : 'accessing' }
LeMutationResult >> terminatedMutants: anObject [

	terminatedMutants := anObject
]
