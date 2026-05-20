actions
buildPolymorphismRelations

	| definedClasses polymorphismRelations |
	definedClasses := targetClass package definedClasses.
	polymorphismRelations := String streamContents: [ :stream | 		
				
		definedClasses isNotEmpty ifTrue:[
			stream nextPutAll: 'Use the following polymorphic relationships of classes present in the project. Use them for instantiation when necessary. Do not mock classes if an instantiation of a sub-class is applicable.';cr.
			].
		definedClasses do: [ :cls | 
			|abstractMethods relationKind|
			
			(cls respondsTo: #superClass) ifTrue:[
				abstractMethods := cls methods collect:#isAbstract. 
				relationKind := abstractMethods isEmpty ifTrue: [ 'a sub-class of' ] ifFalse:['an abstract sub-class of'].
				stream	 nextPutAll: cls className; nextPutAll: relationKind; nextPutAll: cls superClass className;cr.
			].
		].
	].
	
	
	
	self put: polymorphismRelations at: self polymorphismKeyword.