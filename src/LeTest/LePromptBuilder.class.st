Class {
	#name : 'LePromptBuilder',
	#superclass : 'Object',
	#instVars : [
		'values',
		'targetClass',
		'relatedClasses',
		'maxRelatedClasses'
	],
	#category : 'LeTest-Core',
	#package : 'LeTest',
	#tag : 'Core'
}

{ #category : 'initialization' }
LePromptBuilder class >> classNameKeyword [
   ^ '$NAME'
]

{ #category : 'initialization' }
LePromptBuilder class >> classPromptTemplate [
	^ 'Generate unit tests in Pharo for $NAME to achieve 100% line coverage for this class.\nDont use setUp and tearDown methods.\nMake tests as atomic as possible.\nAll tests should be for SUnit.\nIn case of mocking, use SUnit-MockObjects. But, do not use mocking for all tests.\nName all methods according to the template - [MethodUnderTest][Scenario]Test, and use only English letters.\nThe source code of class under test is as follows:\n$CODE\n$METHODS\n$POLYMORPHISM\n$TEST_SAMPLE'
]

{ #category : 'initialization' }
LePromptBuilder class >> codeUnderTestKeyword [
   ^ '$CODE'
]

{ #category : 'factory' }
LePromptBuilder class >> for: targetClass [

	| instance |
	instance := self new.
	instance buildFor: targetClass.
	^instance.
]

{ #category : 'initialization' }
LePromptBuilder class >> methodDefinitionsKeyword [
   ^ '$METHODS'
]

{ #category : 'initialization' }
LePromptBuilder class >> polymorphismKeyword [

	^ '$POLYMORPHISM'
]

{ #category : 'initialization' }
LePromptBuilder class >> testSampleKeyword [
   ^ '$TEST_SAMPLE'
]

{ #category : 'actions' }
LePromptBuilder >> buildCodeUnderTest [

	| codeUnderTestString |
	codeUnderTestString := String streamContents: [ :stream |
			                       stream cr.
			                       targetClass fillSourceCodeOn: stream.
			                       stream cr.

			                       targetClass allSuperclassesDo: [ :cls |
					                       cls package = targetClass package ifTrue: [
							                       stream
								                       nextPutAll: targetClass className;
								                       nextPutAll: 'extends ';
								                       nextPutAll: cls className;
								                       nextPutAll: '. The source code of ';
								                       nextPutAll: cls className;
								                       nextPutAll: 'is';
								                       cr.

							                       cls fillSourceCodeOn: stream ] ] ].

	self put: codeUnderTestString at: self codeUnderTestKeyword
]

{ #category : 'actions' }
LePromptBuilder >> buildFor: aClass [

	targetClass := aClass.
	relatedClasses := nil. "cleaning cache"
	self buildCodeUnderTest.
	self buildMethodSignatures.
	self buildPolymorphismRelations.
	self buildSampleTest.
	self buildSampleTest.
]

{ #category : 'actions' }
LePromptBuilder >> buildMethodSignatures [

	| relatedClasses signaturesCode|
	relatedClasses := self topRelatedClassesFromArguments.
	signaturesCode := String streamContents: [ :stream |
			relatedClasses isNotEmpty ifTrue:[
				stream nextPutAll:'Here are some information about other methods and classes used by the class under test. Only use them for creating objects, not your own ideas.';cr.
				relatedClasses do:[ :cls|
						stream nextPutAll:'=== methods in'; nextPutAll: cls className;cr.
						cls methods do:[ :m |
						     	stream nextPutAll: cls className; nextPutAll: '>>'; nextPutAll: m ast selectorAndArgumentNames; cr.
						].
					].				
				].
   ].
	self put: signaturesCode at: self methodDefinitionsKeyword.
]

{ #category : 'actions' }
LePromptBuilder >> buildPolymorphismRelations [
	| definedClasses polymorphismRelations |
	definedClasses := targetClass package definedClasses.
	polymorphismRelations := String streamContents: [ :stream |
			                         definedClasses isNotEmpty ifTrue: [
					                         stream
						                         nextPutAll:
							                         'Use the following polymorphic relationships of classes present in the project. Use them for instantiation when necessary. Do not mock classes if an instantiation of a sub-class is applicable.';
						                         cr ].
			                         definedClasses do: [ :cls |
					                         | abstractMethods relationKind |
					                         (cls respondsTo: #superClass) ifTrue: [
							                         abstractMethods := cls methods collect: #isAbstract.
							                         relationKind := abstractMethods isEmpty
								                                         ifTrue: [ 'a sub-class of' ]
								                                         ifFalse: [ 'an abstract sub-class of' ].
							                         stream
								                         nextPutAll: cls className;
								                         nextPutAll: relationKind;
								                         nextPutAll: cls superClass className;
								                         cr ] ] ].



	self put: polymorphismRelations at: self polymorphismKeyword
]

{ #category : 'actions' }
LePromptBuilder >> buildSampleTest [
	| sampleTest |
	sampleTest := String streamContents: [ :stream |
			stream nextPutAll:'testPop

	| aStack res elem |
	elem := ''anElement''.
	aStack := Stack new.
	self assertEmpty: aStack.

	aStack push: ''a''.
	aStack push: elem.
	res := aStack pop.
	self assert: res equals: elem.
	self assert: res identicalTo: elem.

	self assert: aStack size equals: 1.
	aStack pop.
	self assertEmpty: aStack'
			
		].
		
	self put: sampleTest at: self testSampleKeyword.
]

{ #category : 'accessing' }
LePromptBuilder >> classNameKeyword [
	self class classNameKeyword.
]

{ #category : 'accessing' }
LePromptBuilder >> codeUnderTestKeyword [
	^ self class codeUnderTestKeyword
]

{ #category : 'actions' }
LePromptBuilder >> content [

	| result |
	result := self class classPromptTemplate copy.

	values keysAndValuesDo: [ :key :value | result := result copyReplaceAll: key with: (value ifNil: [ '' ]) asString ].

	^ result
]

{ #category : 'initialization' }
LePromptBuilder >> initialize [

	super initialize.
	values := Dictionary new.
	maxRelatedClasses := 100
]

{ #category : 'accessing' }
LePromptBuilder >> methodDefinitionsKeyword [
	^self class methodDefinitionsKeyword
]

{ #category : 'accessing' }
LePromptBuilder >> polymorphismKeyword [

	^ self class polymorphismKeyword 
]

{ #category : 'accessing' }
LePromptBuilder >> put: aValue at: aSymbol [

	values at: aSymbol put: aValue
]

{ #category : 'actions' }
LePromptBuilder >> relatedClasses [
	
	| definedClasses |
	definedClasses := targetClass package definedClasses.
	
	targetClass methods do:[ :m |
		m ast nodesDo:[ :node |
			node isMessage ifTrue: [ 
				 
				
				].
			]. 
		].
	
]

{ #category : 'accessing' }
LePromptBuilder >> targetClassName: aClassName [
	
	self put: aClassName at: self classNameKeyword.
]

{ #category : 'accessing' }
LePromptBuilder >> testSampleKeyword [
	^ self class testSampleKeyword
]

{ #category : 'actions' }
LePromptBuilder >> topRelatedClassesFromArguments [

	| definedClasses counters |
	relatedClasses ifNotNil: [ ^ relatedClasses ].

	definedClasses := targetClass package definedClasses.
	counters := Dictionary new.

	definedClasses do: [ :cls | counters at: cls put: 0 ].

	targetClass methods do: [ :method |
			| argNames |
			argNames := method ast arguments collect: [ :arg | arg name ].

			method ast nodesDo: [ :node |
					node isMessage ifTrue: [
							| receiverName selector |
							node receiver isVariable ifTrue: [
									receiverName := node receiver name.
									(argNames includes: receiverName) ifTrue: [
											selector := node selector.

											definedClasses do: [ :cls | (cls canUnderstand: selector) ifTrue: [ counters at: cls put: (counters at: cls) + 1 ] ] ] ] ] ] ].

	relatedClasses := (counters associations asSortedCollection: [ :a :b | a value > b value ]) first:
		                  (maxRelatedClasses min: counters size).

	^ relatedClasses collect:#key
]

{ #category : 'accessing' }
LePromptBuilder >> values [

	^ values
]

{ #category : 'accessing' }
LePromptBuilder >> values: anObject [

	values := anObject
]
