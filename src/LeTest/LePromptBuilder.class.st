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

	^ 'Generate unit tests in Pharo for $NAME to achieve 100% line coverage for this class.
Do not use setUp and tearDown methods.
Make tests as atomic as possible.
All tests should be for SUnit.
In case of mocking, use SUnit-MockObjects. But, do not use mocking for all tests.
Name all methods according to the template - test[MethodUnderTest][Scenario], and use only English letters.
The source code of class under test is as follows:
$CODE
$METHODS
$POLYMORPHISM
The test class must be named LLMGenerated$NAMETest.
The output must be a valid Pharo chunk file (.st) ready to be loaded with fileIn.
Below is an example of the expected output format:
$TEST_SAMPLE'
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
LePromptBuilder >> buildClassName [

	self put: (targetClass name) at: self classNameKeyword
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
								                       nextPutAll: 'The superclass ';
								                       nextPutAll: cls name;
								                       nextPutAll: ' has the following source code:';
								                       cr.
							                       cls fillSourceCodeOn: stream.
							                       stream cr ] ] ].
	self put: codeUnderTestString at: self codeUnderTestKeyword
]

{ #category : 'actions' }
LePromptBuilder >> buildFor: aClass [

	targetClass := aClass.
	relatedClasses := nil. "cleaning cache"
	self buildClassName.
	self buildCodeUnderTest.
	self buildMethodSignatures.
	self buildPolymorphismRelations.
	self buildSampleTest
]

{ #category : 'actions' }
LePromptBuilder >> buildMethodSignatures [

	| relatedClasses signaturesCode |
	relatedClasses := self topRelatedClassesFromArguments.
	signaturesCode := String streamContents: [ :stream |
			                  relatedClasses isNotEmpty ifTrue: [
					                  stream
						                  nextPutAll:
							                  'Here are some information about other methods and classes used by the class under test. Only use them for creating objects, not your own ideas.';
						                  cr.
					                  relatedClasses do: [ :cls |
							                  | classMethods instanceMethods |
							                  classMethods := cls classSide methods.
							                  instanceMethods := cls methods.
							                  (classMethods isEmpty and: [ instanceMethods isEmpty ]) ifFalse: [
									                  classMethods isEmpty ifFalse: [
											                  stream
												                  nextPutAll: '=== methods in ';
												                  nextPutAll: cls name;
												                  nextPutAll: ' class';
												                  cr.
											                  classMethods do: [ :m |
													                  stream
														                  nextPutAll: cls name , ' class>>';
														                  nextPutAll: m ast selectorAndArgumentNames;
														                  cr ] ].
									                  instanceMethods isEmpty ifFalse: [
											                  stream
												                  nextPutAll: '=== methods in ';
												                  nextPutAll: cls name;
												                  cr.
											                  instanceMethods do: [ :m |
													                  stream
														                  nextPutAll: cls name , '>>';
														                  nextPutAll: m ast selectorAndArgumentNames;
														                  cr ] ] ] ] ] ].
	self put: signaturesCode at: self methodDefinitionsKeyword
]

{ #category : 'actions' }
LePromptBuilder >> buildPolymorphismRelations [

	| definedClasses polymorphismRelations |
	definedClasses := targetClass package definedClasses select: [ :cls |
		                  cls isMeta not and: [ cls superclass notNil and: [ cls superclass ~= Object ] ] ].

	polymorphismRelations := String streamContents: [ :stream |
			                         definedClasses isNotEmpty ifTrue: [
					                         stream
						                         nextPutAll:
							                         'Use the following polymorphic relationships of classes present in the project. Use them for instantiation when necessary. Do not mock classes if an instantiation of a sub-class is applicable.';
						                         cr.
					                         definedClasses do: [ :cls |
							                         | abstractMethods relationKind |
							                         abstractMethods := cls methods select: [ :m | m isAbstract ].
							                         relationKind := abstractMethods isEmpty
								                                         ifTrue: [ ' is a sub-class of ' ]
								                                         ifFalse: [ ' is an abstract sub-class of ' ].
							                         stream
								                         nextPutAll: cls name;
								                         nextPutAll: relationKind;
								                         nextPutAll: cls superclass name;
								                         cr ] ] ].
					
	self put: polymorphismRelations at: self polymorphismKeyword
]

{ #category : 'actions' }
LePromptBuilder >> buildSampleTest [

	| sampleTest |
	sampleTest := String streamContents: [ :stream |
			              stream nextPutAll: self testSampleTemplate ].

	self put: sampleTest at: self testSampleKeyword
]

{ #category : 'accessing' }
LePromptBuilder >> classNameKeyword [

	^self class classNameKeyword
]

{ #category : 'accessing' }
LePromptBuilder >> codeUnderTestKeyword [
	^ self class codeUnderTestKeyword
]

{ #category : 'actions' }
LePromptBuilder >> content [

	| result |
	result := self class classPromptTemplate copy.
	
	values keysAndValuesDo: [ :key :value |
			result := result copyReplaceAll: key with: (value ifNil: [ '' ]) asString
			 ].
	^ result
]

{ #category : 'initialization' }
LePromptBuilder >> initialize [

	super initialize.
	values := Dictionary new.
	maxRelatedClasses := 100
]

{ #category : 'actions' }
LePromptBuilder >> leResult [	
	|result|
	result := LePromptResult new.
	result values: values.
	result prompt: self content.
	^ result.
]

{ #category : 'accessing' }
LePromptBuilder >> maxRelatedClasses [

	^ maxRelatedClasses
]

{ #category : 'accessing' }
LePromptBuilder >> maxRelatedClasses: anObject [

	maxRelatedClasses := anObject
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
LePromptBuilder >> testSampleTemplate [

	^ '"VERSION:1.0"!
TestCase subclass: #LLMGeneratedStackTest
	instanceVariableNames: ''''
	classVariableNames: ''''
	package: ''Collections-Stack-Tests-Base''!
!StackTest methodsFor: ''tests''!
testPush
	| aStack |
	aStack := Stack new.
	aStack push: ''a''.
	self assert: aStack size equals: 1.
	aStack push: ''b''.
	self assert: aStack size equals: 2! !
!StackTest methodsFor: ''tests''!
testPop
	| aStack |
	aStack := Stack new.
	aStack push: ''a''.
	aStack push: ''b''.
	self assert: aStack pop equals: ''b''.
	self assert: aStack size equals: 1! !
!StackTest methodsFor: ''tests''!
testEmptyError
	| aStack |
	aStack := Stack new.
	self should: [ aStack top ] raise: Error.
	self should: [ aStack pop ] raise: Error! !
!StackTest methodsFor: ''tests''!
testTop
	| aStack |
	aStack := Stack new.
	aStack push: ''a''.
	aStack push: ''b''.
	self assert: aStack top equals: ''b''.
	self assert: aStack size equals: 2! !'
]

{ #category : 'actions' }
LePromptBuilder >> topRelatedClassesFromArguments [

	| definedClasses counters |
	relatedClasses ifNotNil: [ ^ relatedClasses ]. "Solo clases reales, sin metaclasses ni clases de test"
	definedClasses := targetClass package definedClasses select: [ :cls | cls isMeta not and: [ (cls inheritsFrom: TestCase) not ] ].

	counters := Dictionary new.
	definedClasses do: [ :cls | counters at: cls put: 0 ].

	targetClass methods do: [ :method |
			| argNames |
			"Incluir args Y temporaries"
			argNames := method ast arguments , method ast temporaries collect: [ :arg | arg name ].
			method ast nodesDo: [ :node |
					node isMessage ifTrue: [
							node receiver isVariable ifTrue: [
									| receiverName |
									receiverName := node receiver name.
									(argNames includes: receiverName) ifTrue: [
											| selector |
											selector := node selector.
											definedClasses do: [ :cls |
													((cls canUnderstand: selector) or: [ cls classSide canUnderstand: selector ]) ifTrue: [
														counters at: cls put: (counters at: cls) + 1 ] ] ] ] ] ] ].

	relatedClasses := (counters associations asSortedCollection: [ :a :b | a value > b value ]) first:
		                  (maxRelatedClasses min: counters size).
	^ relatedClasses collect: #key
]

{ #category : 'accessing' }
LePromptBuilder >> values [

	^ values
]

{ #category : 'accessing' }
LePromptBuilder >> values: anObject [

	values := anObject
]
