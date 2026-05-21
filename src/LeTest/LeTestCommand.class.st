Class {
	#name : 'LeTestCommand',
	#superclass : 'CommandLineHandler',
	#category : 'LeTest-CommandLine',
	#package : 'LeTest',
	#tag : 'CommandLine'
}

{ #category : 'accessing' }
LeTestCommand class >> commandName [
	^'LeTest'
]

{ #category : 'accessing' }
LeTestCommand class >> description [
	 ^ 'LLM Test Generation and Evaluation Command'
]

{ #category : 'activation' }
LeTestCommand >> activate [
    | args |
    args := self commandLine arguments.

    self stdout nextPutAll: 'Hello ', args first; lf.

    Smalltalk snapshot: false andQuit: true
]
