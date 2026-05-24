Class {
	#name : 'LeTestCommand',
	#superclass : 'ClapPharoApplication',
	#category : 'LeTest-CommandLine',
	#package : 'LeTest',
	#tag : 'CommandLine'
}

{ #category : 'command line' }
LeTestCommand class >> letest [
	"The usual Hello-World example, demonstrating a Clap command with a couple features."

	<script>
	<commandline>
	^ (ClapCommandSpec id: #letest)
		  description: 'LeTest Command Line';
		  commandClass: self;
			addHelp;
		  addPositional: #arguments spec: [ :positional |
			  positional
				  description: 'Arguments for LeTest';
				  multiple: true ];
		  yourself
]

{ #category : 'execution' }
LeTestCommand >> bothCoverageFor: aClassName from: aStFilePath [

	| generatedTest targetClass result manualTest |
		self loadTestClass: aStFilePath.

	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	manualTest := Smalltalk classNamed: aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new coverageFor: targetClass using: {
			          manualTest.
			          generatedTest }.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> bothMutationFor: aClassName from: aStFilePath [

	| generatedTest targetClass result manualTest |
		self loadTestClass: aStFilePath.
	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	manualTest := Smalltalk classNamed: aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new
		          mutationFor: targetClass
		          using: {
				          manualTest.
				          generatedTest }
		          with: self context stdout.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> checkFor: aClassName from: aStFilePath [

	| aTestClass result suite |
	[ aStFilePath asFileReference fileIn ]
		on: Error
		do: [ :e |
				self context stdout
					nextPutAll: 'Compiled Error: ';
					nextPutAll: e printString;cr.
				e resume ].
	aTestClass := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.


	suite := aTestClass suite.
	result := suite run.

	result failures do: [ :failure |
			self context stdout
				nextPutAll: 'Failed: ';
				nextPutAll: failure selector;
				cr ].
	result errors do: [ :failure |
			self context stdout
				nextPutAll: 'Error: ';
				nextPutAll: failure selector;
				cr ]
]

{ #category : 'execution' }
LeTestCommand >> cleanTestSuite: aTestClass [

	| result suite failingSelectors |
	suite := aTestClass suite.
	result := suite run.
	failingSelectors := result failures , result errors collect: [ :failure | failure selector ].
	failingSelectors do: [ :sel | aTestClass removeSelector: sel ].
	^ aTestClass
]

{ #category : 'execution' }
LeTestCommand >> execute [

	| args |
	self prepareImageAndExit.
	args := self context arguments.

	args second = 'check' ifTrue: [ self checkFor: args third from: args fourth ].
	
	args second = 'gp' ifTrue: [ self generatePromptForClass: args third ].
	args second = 'lr' ifTrue: [ self localRunFor: args third ].
	args second = 'gr' ifTrue: [ self gemeratedRunFor: args third from: args fourth ].

	args second = 'lc' ifTrue: [ self localCoverageFor: args third ].
	args second = 'gc' ifTrue: [ self gemeratedCoverageFor: args third from: args fourth ].

	args second = 'lm' ifTrue: [ self localMutationFor: args third ].
	args second = 'gm' ifTrue: [ self gemeratedMutationFor: args third from: args fourth ].

	args second = 'bm' ifTrue: [ self bothMutationFor: args third from: args fourth ].
	args second = 'bc' ifTrue: [ self bothCoverageFor: args third from: args fourth ]
]

{ #category : 'execution' }
LeTestCommand >> gemeratedCoverageFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
	self loadTestClass: aStFilePath.
	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new coverageFor: targetClass using: { generatedTest }.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> gemeratedMutationFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
		self loadTestClass: aStFilePath.

	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new mutationFor: targetClass using: { generatedTest } with: self context stdout.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> gemeratedRunFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
		self loadTestClass: aStFilePath.
	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	targetClass := Smalltalk classNamed: aClassName.

	result := generatedTest buildSuite run.
	result printOn: self context stdout.
	self context stdout cr.
	result errors printOn: self context stdout.
	self context stdout cr
]

{ #category : 'execution' }
LeTestCommand >> generatePromptForClass: aClassName [

	| cls builder |
	cls := Smalltalk classNamed: aClassName.
	builder := LePromptBuilder new.
	builder buildFor: cls.
	builder leResult printJSONOn: self context stdout.
]

{ #category : 'execution' }
LeTestCommand >> loadTestClass: aSTFilePath [

	[ aSTFilePath asFileReference fileIn ]
    on: Error
    do: [:e | e resume ]
]

{ #category : 'execution' }
LeTestCommand >> localCoverageFor: aClassName [

	| generatedTest targetClass result |
	generatedTest := Smalltalk classNamed: aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new coverageFor: targetClass using: {generatedTest}.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> localMutationFor: aClassName [

	| generatedTest targetClass result |
	generatedTest := Smalltalk classNamed: aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new mutationFor: targetClass using: { generatedTest } with: self context stdout.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> localRunFor: aClassName [

	|result generatedTest |
	generatedTest := Smalltalk classNamed: aClassName , 'Test'.

	result := generatedTest buildSuite run.
	result printOn: self context stdout.
	self context stdout cr.
	result errors printOn: self context stdout.
	self context stdout cr.	
]
