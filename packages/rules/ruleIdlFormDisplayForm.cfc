<cfcomponent displayname="Form builder: Display form" extends="farcry.core.packages.rules.rules">

	<!--- type properties --->
	<cfproperty name="formID" ftfieldset="Formdetails" type="uuid" fttype="uuid" hint="Form to display" required="yes" default="" ftlabel="Select form" ftjoin="idlform" bsyncstatus="false" ftseq="1" />
	<cfproperty name="displayMethod" ftfieldset="Formdetails" type="string" hint="Display method to render individual content items." required="true" default="displayRuleStandard" fttype="webskin" fttypename="idlform" ftprefix="displayRule" ftlabel="Display Method" ftseq="2" />

</cfcomponent>