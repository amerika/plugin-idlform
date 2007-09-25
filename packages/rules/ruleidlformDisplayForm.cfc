<cfcomponent displayname="Form builder: Display form" extends="farcry.core.packages.rules.rules">

	<!--- type properties --->
	<cfproperty name="formID" ftfieldset="Formdetails" type="uuid" fttype="uuid" hint="Form to display" required="yes" default="" ftlabel="Select form" ftjoin="idlform" bsyncstatus="false" ftseq="1" />
	<cfproperty name="displayMethod" ftfieldset="Formdetails" type="string" hint="Display method to render individual content items." required="true" default="displayRuleStandard" fttype="webskin" fttypename="idlform" ftprefix="displayRule" ftlabel="Display Method" ftseq="2" />
	
	<cffunction name="execute" access="public" output="true">
		<cfargument name="objectID" required="true" type="uuid" default="" />
		<cfargument name="dsn" required="false" type="string" default="#application.dsn#" />
		
		<cfset var stObj = this.getData(arguments.objectID)>
		<cfset var o = CreateObject("component", "farcry.plugins.idlform.packages.types.idlform") />
		<cfset var stForm = o.getData(stObj.formID) />
		
			<cfscript>
				stInvoke = structNew();
				stInvoke.objectID = stObj.formID;
				stInvoke.typename = application.types.idlform.typePath;
				stInvoke.method = stObj.displayMethod;
				arrayAppend(request.aInvocations,stInvoke);
			</cfscript>
		
	</cffunction>

</cfcomponent>