actions
buildMethodSignatures

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