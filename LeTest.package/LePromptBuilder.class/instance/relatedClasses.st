actions
relatedClasses
	
	| definedClasses |
	definedClasses := targetClass package definedClasses.
	
	targetClass methods do:[ :m |
		m ast nodesDo:[ :node |
			node isMessage ifTrue: [ 
				 
				
				].
			]. 
		].
	