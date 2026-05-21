Class {
	#name : 'ClassDataCollector',
	#superclass : 'Object',
	#category : 'LeTest-DataCollector',
	#package : 'LeTest',
	#tag : 'DataCollector'
}

{ #category : 'accessing' }
ClassDataCollector class >> firstFilter [

	| ps |
	ps := #(
'AI'
'AST'
'Announcements'
'Athens'
'Beacon'
'BeautifulComments'
'Calypso'
'Clap'
'ClassAnnotation'
'ClassDefinitionPrinters'
'ClassParser'
'CodeExport'
'CodeImport'
'Collections'
'ColorPicker'
'Colors'
'Commander'
'Commander2'
'Compression'
'Coverage'
'DarkBlueTheme'
'DebugInfo'
'DebugPoints'
'Debugger'
'Debugging'
'Deprecation'
'DrTests'
'EmbeddedFreeType'
'EnlumineurFormatter'
'Epicea'
'Equals'
'FFI'
'FileSystem'
'Files'
'Flashback'
'Fonts'
'FormCanvas'
'Formatter'
'FreeType'
'Fuel'
'FuzzyMatcher'
'General'
'Geometry'
'Graphics'
'Growl'
'Hermes'
'HeuristicCompletion'
'Hiedra'
'Iceberg'
'IconPacks'
'Instrumentation'
'Jobs'
'Kernel'
'Keymapping'
'LeTest'
'LibGit'
'Manifest'
'Math'
'MenuRegistration'
'Metacello'
'Microdown'
'Monticello'
'MonticelloFileServices'
'MonticelloFileTree'
'MonticelloMocks'
'MonticelloRemoteRepositories'
'MonticelloTonel'
'Morphic'
'Multilingual'
'NECompletion'
'Native'
'Network'
'NewTools'
'NewValueHolder'
'NumberParser'
'NumericInterpolator'
'NumericNoise'
'OSWindow'
'Ombu'
'OpalCompiler'
'ParseTreeRewriter'
'PharoBootstrap'
'PharoDocComment'
'PragmaCollector'
'ProfStef'
'RTree'
'Random'
'Refactoring'
'ReferenceFinder'
'ReflectionMirrors'
'Reflectivity'
'Regex'
'ReleaseTests'
'Renraku'
'Ring'
'Roassal'
'RottenTestsFinder'
'Rubric'
'STON'
'SUnit'
'ScriptingExtensions'
'Settings'
'Shift'
'Shout'
'Sindarin'
'Slot'
'SortFunctions'
'Spec2'
'Specific'
'StartupPreferences'
'System'
'SystemCommands'
'TaskIt'
'TestRunner'
'Text'
'ThreadedFFI'
'Tool'
'Tools'
'Traits'
'Transcript'
'UIManager'
'UndefinedClasses'
'UnifiedFFI'
'VariablesLibrary'
'WebBrowser'
'Zinc'
'Zodiac'
'_UnpackagedPackage'
).
	ps do: [ :name | ClassDataCollector new exportMetricsFor: name ]
]

{ #category : 'as yet unclassified' }
ClassDataCollector >> classesFor: aClass [

	^ Smalltalk globals allClasses reject: [ :each |
			  (each inheritsFrom: TestCase) and: [
				  (each name beginsWith: aClass name) and: [ (each name endsWith: 'Test') or: [ each name endsWith: 'Tests' ] ] ] ]
]

{ #category : 'as yet unclassified' }
ClassDataCollector >> exportMetrics [
	
	
]

{ #category : 'as yet unclassified' }
ClassDataCollector >> exportMetricsFor: projectName [

	| projectPackages classes |
	projectPackages := self packagesFor: projectName.
	classes := projectPackages flatCollect: [ :pkg | pkg definedClasses ].
	classes := classes reject: [ :cls | self isTestClass: cls ].
	classes do: [ :cls |
			| famixClass testClasses complexities maxComplexity |
			famixClass := self famixClassFor: cls.
			testClasses := self testClassesFor: cls.
			complexities := famixClass methods collect: #cyclomaticComplexity.
			maxComplexity := complexities ifNotEmpty: [ complexities max ] ifEmpty: [ 0 ].
			(maxComplexity >= 5 and: [ testClasses isNotEmpty ]) ifTrue: [
					Transcript
						nextPutAll: projectName;
						tab;
						nextPutAll: cls name;
						tab;
						nextPutAll: cls methods size asString;
						tab;
						nextPutAll: complexities asString;
						tab;
						nextPutAll: maxComplexity asString;
						tab;
						nextPutAll: (testClasses collect: #name) asString;
						tab;
						nextPutAll: ((testClasses flatCollect: #methods) select: [ :m | m selector beginsWith: 'test' ]) size asString;
						cr ] ]
]

{ #category : 'as yet unclassified' }
ClassDataCollector >> famixClassFor: aClass [

	| model |
	model := FamixStModel new.
	FamixStPharoImporterTask new
		model: model;
		addClass: aClass;
		run.

	^ model allModelClasses first
]

{ #category : 'as yet unclassified' }
ClassDataCollector >> isTestClass: aClass [

	^ (aClass inheritsFrom: TestCase) or: [ (aClass name endsWith: 'Test') or: [ aClass name endsWith: 'Tests' ]]
]

{ #category : 'as yet unclassified' }
ClassDataCollector >> packagesFor: aProjectNameString [

	^ PackageOrganizer default packages select: [:p |
		(p name copyUpTo: $-) = aProjectNameString
	]
]

{ #category : 'as yet unclassified' }
ClassDataCollector >> projectsUnderStudy [

	#( 'AI' 'BeautifulComments' 'Clap' 'Flashback' 'Hiedra' 'Microdown' 'PharoDocComment' 'ProfStef' 'Roassal' 'Sindarin' 'Zodiac' 'Athens' 'Beacon' 'Compression' 'Epicea' 'FuzzyMatcher' 'Keymapping' 'RTree' 'Regex' 'SortFunctions' )
]

{ #category : 'as yet unclassified' }
ClassDataCollector >> testClassesFor: aClass [

	^ Smalltalk globals allClasses
		  select: [ :each | (each inheritsFrom: TestCase) and: [ each name = (aClass name , 'Test') ] ].
]
