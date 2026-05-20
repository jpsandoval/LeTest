actions
buildCodeUnderTest

	| codeUnderTestString |
	codeUnderTestString := String streamContents: [ :stream |
			                       stream cr.
			                       targetClass fillSourceCodeOn: stream.
			                       stream cr.

			                       targetClass allSuperclassesDo: [ :cls |
					                       cls package = targetClass package ifTrue: [
							                       stream
								                       nextPutAll: targetClass className;
								                       nextPutAll: 'extends ';
								                       nextPutAll: cls className;
								                       nextPutAll: '. The source code of ';
								                       nextPutAll: cls className;
								                       nextPutAll: 'is';
								                       cr.

							                       cls fillSourceCodeOn: stream ] ] ].

	self put: codeUnderTestString at: self codeUnderTestKeyword