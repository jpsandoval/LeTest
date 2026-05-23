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

	| generatedTest targetClass result manualTest|
	aStFilePath asFileReference fileIn.

	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	manualTest := Smalltalk classNamed: aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new coverageFor: targetClass using: { manualTest . generatedTest }.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> bothMutationFor: aClassName from: aStFilePath [

	| generatedTest targetClass result manualTest |
	aStFilePath asFileReference fileIn.

	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	manualTest := Smalltalk classNamed: aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new mutationFor: targetClass using: {
			          manualTest.
			          generatedTest } with: self context stdout.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> execute [

	| args |
	self prepareImageAndExit.
	args := self context arguments.

	args second = 'gp' ifTrue: [ self generatePromptForClass: args third ].
	args second = 'lr' ifTrue: [ self localRunFor: args third ].
	args second = 'gr' ifTrue: [ self gemeratedRunFor: args third from: args fourth ].

	args second = 'lc' ifTrue: [ self localCoverageFor: args third ].
	args second = 'gc' ifTrue: [ self gemeratedCoverageFor: args third from: args fourth ].

	args second = 'lm' ifTrue: [ self localMutationFor: args third ].
	args second = 'gm' ifTrue: [ self gemeratedMutationFor: args third from: args fourth ].

	args second = 'bm' ifTrue: [ self bothMutationFor: args third from: args fourth ].
	args second = 'bc' ifTrue: [ self bothCoverageFor: args third from: args fourth ].
]

{ #category : 'execution' }
LeTestCommand >> gemeratedCoverageFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
	aStFilePath asFileReference fileIn.

	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new coverageFor: targetClass using: {generatedTest}.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> gemeratedMutationFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
	aStFilePath asFileReference fileIn.

	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := LeRunner new mutationFor: targetClass using: { generatedTest } with: self context stdout.

	result printJSONOn: self context stdout
]

{ #category : 'execution' }
LeTestCommand >> gemeratedRunFor: aClassName from: aStFilePath [

	| generatedTest targetClass result |
	aStFilePath asFileReference fileIn.

	generatedTest := Smalltalk classNamed: 'LLMGenerated' , aClassName , 'Test'.
	targetClass := Smalltalk classNamed: aClassName.

	result := generatedTest buildSuite run.
	result printOn: self context stdout.
	self context stdout cr.
	result errors printOn: self context stdout.
	self context stdout cr.	
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
