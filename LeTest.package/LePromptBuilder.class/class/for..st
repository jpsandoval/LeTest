factory
for: targetClass

	| instance |
	instance := self new.
	instance buildFor: targetClass.
	^instance.