<cfcomponent hint="Form log item" extends="farcry.core.packages.types.types" output="false">
	
	<cfproperty name="formLogID" type="uuid" hint="ID of formLog item belongs to" required="no">
	<cfproperty name="title" type="string" hint="Form Item title" required="yes" default="">
	<cfproperty name="value" type="string" hint="Value of the form element" required="no" default="">
	
	<!--- create log item --->

	<cffunction name="createLogItems" access="public" output="false">
		<cfargument name="stObj" required="yes" type="struct">
		<cfargument name="formData" required="yes" type="struct">
		<cfargument name="uploadfile" required="no" type="struct">
		<cfargument name="formLogID" required="yes" type="uuid">
		
		<cfset oFormItemService = createObject("component","farcry.plugins.idlForm.packages.types.idlFormItem")>

		<cfloop from="1" to="#arrayLen(arguments.stObj.aFormItems)#" index="i">
			
			<cfset oFormItem = oFormItemService.getData(objectID=arguments.stObj.aFormItems[i])>
			
			<cfquery name="insertFormLogItem" datasource="#application.dsn#">
				INSERT INTO idlFormLogItem (
					objectID,
					datetimecreated,
					datetimelastupdated,
					formLogID,
					title,
					value,
					createdby,
					lastupdatedby
				)
				VALUES (
					'#createUUID()#',
					#createODBCDate(Now())#,
					#createODBCDate(Now())#,
					'#arguments.formLogID#',
					<cfif oFormItem.type is "radiobutton">
						'#oFormItem.title#',
						'#formData[oFormItem.name]#',
					<cfelseif oFormItem.type is "filefield">
						'#oFormItem.title#',
						<cfif StructKeyExists(uploadfile,oFormItem.objectid)>
						'#uploadfile[oFormItem.objectid]#',
						<cfelse>
						'No file uploaded',
						</cfif>
					<cfelse>
						'#oFormItem.title#',
						<cfif StructKeyExists(formData,oFormItem.objectid)>
						'#formData[oFormItem.objectid]#',
						<cfelse>
						'',
						</cfif>
					</cfif>
					'',
					''
				)
			</cfquery>
				
		</cfloop>
			
	</cffunction>

</cfcomponent>