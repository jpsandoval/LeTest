actions
buildFor: aClass

	targetClass := aClass.
	relatedClasses := nil. "cleaning cache"
	self buildCodeUnderTest.
	self buildMethodSignatures.
	self buildPolymorphismRelations.
	self buildSampleTest.
	self buildSampleTest.