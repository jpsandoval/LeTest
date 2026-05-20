actions
content

	| result |
	result := self class classPromptTemplate copy.

	values keysAndValuesDo: [ :key :value | result := result copyReplaceAll: key with: (value ifNil: [ '' ]) asString ].

	^ result