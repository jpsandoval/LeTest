actions
topRelatedClassesFromArguments

	| definedClasses counters |
	relatedClasses ifNotNil: [ ^ relatedClasses ].

	definedClasses := targetClass package definedClasses.
	counters := Dictionary new.

	definedClasses do: [ :cls | counters at: cls put: 0 ].

	targetClass methods do: [ :method |
			| argNames |
			argNames := method ast arguments collect: [ :arg | arg name ].

			method ast nodesDo: [ :node |
					node isMessage ifTrue: [
							| receiverName selector |
							node receiver isVariable ifTrue: [
									receiverName := node receiver name.
									(argNames includes: receiverName) ifTrue: [
											selector := node selector.

											definedClasses do: [ :cls | (cls canUnderstand: selector) ifTrue: [ counters at: cls put: (counters at: cls) + 1 ] ] ] ] ] ] ].

	relatedClasses := (counters associations asSortedCollection: [ :a :b | a value > b value ]) first:
		                  (maxRelatedClasses min: counters size).

	^ relatedClasses collect:#key