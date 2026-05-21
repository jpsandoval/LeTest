Class {
	#name : 'LePromptResult',
	#superclass : 'Object',
	#instVars : [
		'values',
		'prompt'
	],
	#category : 'LeTest-Core',
	#package : 'LeTest',
	#tag : 'Core'
}

{ #category : 'accessing' }
LePromptResult >> asJSON [

	^ String streamContents: [ :stream |
			  (NeoJSONWriter on: stream)
				  mapInstVarsFor: self class;
				  nextPut: self ]
]

{ #category : 'accessing' }
LePromptResult >> prompt [

	^ prompt
]

{ #category : 'accessing' }
LePromptResult >> prompt: anObject [

	prompt := anObject
]

{ #category : 'accessing' }
LePromptResult >> values [

	^ values
]

{ #category : 'accessing' }
LePromptResult >> values: anObject [

	values := anObject
]
