<cfcomponent displayname="Form log" hint="Form log" extends="farcry.core.packages.types.types" output="false">

	<cfproperty name="formID" type="uuid" hint="the ID of the form being logged" required="yes">
	<cfproperty name="title" type="string" hint="Form title" required="yes" default="">
	<cfproperty name="description" type="longchar" hint="Description / introdoctury text for the form" required="no" default="">
	<cfproperty name="receiver" type="string" hint="E-mail address of the receiver of the form" required="no" default="">
	
	<!--- create log file --->

	<cffunction name="createLog" access="public" output="false">
		<cfargument name="stObj" required="yes" type="struct" />
		
		<cfset var stProp = structNew() />
		
		<!--- Add data --->
		<cfset stProp.objectID = createUUID() />
		<cfset stProp.datetimecreated = createODBCDateTime(Now()) />
		<cfset stProp.datetimelastupdated = createODBCDateTime(Now()) />
		<cfset stProp.formID = arguments.stObj.objectid />
		<cfset stProp.title = arguments.stObj.title />
		<cfset stProp.description = arguments.stObj.formheader />
		<cfset stProp.receiver = arguments.stObj.receiver />
		<cfset stProp.createdby = 'idlForm' />
		<cfset stProp.lastupdatedby = 'idlForm' />
		
		<cfset stSave = setData(stProperties=stProp) />
		
		<cfreturn stProp.objectID>
	</cffunction>
	
</cfcomponent>