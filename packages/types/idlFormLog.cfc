<cfcomponent displayname="Form log" hint="Form log" extends="farcry.core.packages.types.types" output="false">

	<cfproperty name="formID" type="uuid" hint="the ID of the form being logged" required="yes">
	<cfproperty name="title" type="string" hint="Form title" required="yes" default="">
	<cfproperty name="description" type="longchar" hint="Description / introdoctury text for the form" required="no" default="">
	<cfproperty name="receiver" type="string" hint="E-mail address of the receiver of the form" required="no" default="">
	
	<!--- create log file --->

	<cffunction name="createLog" access="public" output="false">
		
		<cfargument name="stObj" required="yes" type="struct">
		
		<cfset logID = createUUID()>
		
		<cfquery name="createLog" datasource="#application.dsn#">
		INSERT INTO idlFormLog (
			objectID,
			datetimecreated,
			datetimelastupdated,
			formID,
			title,
			description,
			receiver,
			createdby,
			lastupdatedby
		)
		VALUES (
			'#logID#',
			#createODBCDateTime(Now())#,
			#createODBCDateTime(Now())#,
			'#arguments.stObj.objectid#',
			'#arguments.stObj.title#',
			'#arguments.stObj.formheader#',
			'#arguments.stObj.receiver#',
			'',
			''
		)
		</cfquery>
		
		<cfreturn logID>
		
	</cffunction>
	
</cfcomponent>