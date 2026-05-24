"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestLeTest',
	#superclass : 'PackageManifest',
	#category : 'LeTest-Manifest',
	#package : 'LeTest',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestLeTest class >> ruleStringConcatenationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#LeMinimize #minimize:target: #false)) #'2026-05-24T12:02:22.81548-04:00') )
]
