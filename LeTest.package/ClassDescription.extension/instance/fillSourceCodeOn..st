*LeTest
fillSourceCodeOn: aStream

	aStream nextPutAll: self definitionString; cr.
	
	self methods do:[ :m | 
			aStream nextPutAll: self className; 
						nextPutAll:'>>'; 
						nextPutAll: 
						m sourceCode;cr.
		].