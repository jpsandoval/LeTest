actions
buildSampleTest
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