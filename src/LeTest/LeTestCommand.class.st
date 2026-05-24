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

{ #category : 'coverage' }
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

{ #category : 'mutation' }
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
	args := self context arguments. "prompt"
	args second = 'gp' ifTrue: [ self generatePromptForClass: args third ]. "minimize"
	args second = 'mg' ifTrue: [ self minimizeGeneratedTestSuite: args third from: args fourth ].
	args second = 'ml' ifTrue: [ self minimizeLocalTestSuite: args third ]. "check"
	args second = 'gcheck' ifTrue: [ self generatedCheckFor: args third from: args fourth ].
	args second = 'mcheck' ifTrue: [ self minimizedCheckFor: args third from: args fourth ].
	args second = 'lcheck' ifTrue: [ self localCheckFor: args third from: args fourth ]. "run"
	args second = 'lr' ifTrue: [ self localRunFor: args third ].
	args second = 'gr' ifTrue: [ self gemeratedRunFor: args third from: args fourth ].
	args second = 'mr' ifTrue: [ self gemeratedRunFor: args third from: args fourth ].

	args second = 'lc' ifTrue: [ self localCoverageFor: args third ].
	args second = 'gc' ifTrue: [ self generatedCoverageFor: args third from: args fourth ].
	args second = 'mc' ifTrue: [ self minimizedCoverageFor: args third from: args fourth ].


	args second = 'lm' ifTrue: [ self localMutationFor: args third ].
	args second = 'gm' ifTrue: [ self generatedMutationFor: args third from: args fourth ].
	args second = 'mm' ifTrue: [ self minimizedMutationFor: args third from: args fourth ].

	args second = 'bm' ifTrue: [ self bothMutationFor: args third from: args fourth ].
	args second = 'bc' ifTrue: [ self bothCoverageFor: args third from: args fourth ]
]

{ #category : 'running' }
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

{ #category : 'prompt' }
LeTestCommand >> generatePromptForClass: aClassName [

	| cls builder |
	cls := Smalltalk classNamed: aClassName.
	builder := LePromptBuilder new.
	builder buildFor: cls.
	builder leResult printJSONOn: self context stdout.
]

{ #category : 'checking' }
LeTestCommand >> generatedCheckFor: aClassName from: aStFilePath [

	| aTestClass result suite |
	[ aStFilePath asFileReference fileIn ]
		on: Error
		do: [ :e |
				self context stdout
					nextPutAll: 'Compiled Error: ';
					nextPutAll: e printString;
					cr.
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

{ #category : 'coverage' }
LeTestCommand >> generatedCoverageFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
	self loadTestClass: aStFilePath.
	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new coverageFor: targetClass using: { generatedTest }.

	result printJSONOn: self context stdout
]

{ #category : 'mutation' }
LeTestCommand >> generatedMutationFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
	self loadTestClass: aStFilePath.

	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new mutationFor: targetClass using: { generatedTest } with: self context stdout.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> loadTestClass: aSTFilePath [

	[ aSTFilePath asFileReference fileIn ]
    on: Error
    do: [:e | e resume ]
]

{ #category : 'checking' }
LeTestCommand >> localCheckFor: aClassName from: aStFilePath [

	| aTestClass result suite |
	[ aStFilePath asFileReference fileIn ]
		on: Error
		do: [ :e |
				self context stdout
					nextPutAll: 'Compiled Error: ';
					nextPutAll: e printString;
					cr.
				e resume ].
	aTestClass := Smalltalk classNamed: aClassName , 'Test'.


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

{ #category : 'coverage' }
LeTestCommand >> localCoverageFor: aClassName [

	| generatedTest targetClass result |
	generatedTest := Smalltalk classNamed: aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new coverageFor: targetClass using: {generatedTest}.

	result printJSONOn: self context stdout
]

{ #category : 'mutation' }
LeTestCommand >> localMutationFor: aClassName [

	| generatedTest targetClass result |
	generatedTest := Smalltalk classNamed: aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new mutationFor: targetClass using: { generatedTest } with: self context stdout.

	result printJSONOn: self context stdout
]

{ #category : 'running' }
LeTestCommand >> localRunFor: aClassName [

	|result generatedTest |
	generatedTest := Smalltalk classNamed: aClassName , 'Test'.

	result := generatedTest buildSuite run.
	result printOn: self context stdout.
	self context stdout cr.
	result errors printOn: self context stdout.
	self context stdout cr.	
]

{ #category : 'minimize' }
LeTestCommand >> minimizeGeneratedTestSuite: aClassName from: aStFilePath [
	| generatedTest targetClass copyTestClass |
	self loadTestClass: aStFilePath.
	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	targetClass := Smalltalk classNamed: aClassName.
	copyTestClass := LeMinimize new minimize: generatedTest target: targetClass.
	copyTestClass fileOutOn: self context stdout.
]

{ #category : 'minimize' }
LeTestCommand >> minimizeLocalTestSuite: aClassName [

	| generatedTest targetClass copyTestClass |
	generatedTest := Smalltalk classNamed: aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	targetClass := Smalltalk classNamed: aClassName.
	copyTestClass := LeMinimize new minimize: generatedTest target: targetClass.
	copyTestClass fileOutOn: self context stdout
]

{ #category : 'checking' }
LeTestCommand >> minimizedCheckFor: aClassName from: aStFilePath [

	| aTestClass result suite |
	[ aStFilePath asFileReference fileIn ]
		on: Error
		do: [ :e |
				self context stdout
					nextPutAll: 'Compiled Error: ';
					nextPutAll: e printString;
					cr.
				e resume ].
	aTestClass := Smalltalk classNamed: 'Minimized' , aClassName , 'Test'.


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

{ #category : 'coverage' }
LeTestCommand >> minimizedCoverageFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
	self loadTestClass: aStFilePath.
	generatedTest := Smalltalk classNamed: 'Minimized' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new coverageFor: targetClass using: { generatedTest }.

	result printJSONOn: self context stdout
]

{ #category : 'mutation' }
LeTestCommand >> minimizedMutationFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
	self loadTestClass: aStFilePath.

	generatedTest := Smalltalk classNamed: 'Minimized' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new mutationFor: targetClass using: { generatedTest } with: self context stdout.

	result printJSONOn: self context stdout
]

{ #category : 'running' }
LeTestCommand >> minimizedRunFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
	self loadTestClass: aStFilePath.
	generatedTest := Smalltalk classNamed: 'Minimized' , aClassName , 'Test'.
	generatedTest := self cleanTestSuite: generatedTest.
	targetClass := Smalltalk classNamed: aClassName.

	result := generatedTest buildSuite run.
	result printOn: self context stdout.
	self context stdout cr.
	result errors printOn: self context stdout.
	self context stdout cr
]
