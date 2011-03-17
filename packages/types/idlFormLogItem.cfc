<cfcomponent displayname="Form Log Item" hint="Form log item" extends="farcry.core.packages.types.types" output="false">
<!--- @@Copyright: Copyright (c) 2008 IDLmedia AS. All rights reserved. --->
<!--- @@License:
	This file is part of FarCry Form Builder Plugin.

	FarCry Form Builder Plugin is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	FarCry Form Builder Plugin is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with FarCry Form Builder Plugin.  If not, see <http://www.gnu.org/licenses/>.
--->

<!--- @@displayname: --->
<!--- @@description: --->
<!--- @@author: Trond Ulseth (trond@idl.no) --->
	
	<cfproperty name="formLogID" type="uuid" hint="ID of formLog item belongs to" required="no">
	<cfproperty name="title" type="string" hint="Form Item title" required="yes" default="">
	<cfproperty name="value" type="string" hint="Value of the form element" required="no" default="">
	
	<!--- create log item --->

	<cffunction name="createLogItems" access="public" output="false">
		<cfargument name="stObj" required="yes" type="struct">
		<cfargument name="formData" required="yes" type="struct">
		<cfargument name="uploadfile" required="no" type="struct">
		<cfargument name="formLogID" required="yes" type="uuid">

		<cfset var oFormItemService = createObject("component", application.stCoapi.idlFormItem.packagepath)>

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
					<cfif (oFormItem.type is "radiobutton")>
						'#oFormItem.title#',
						<cfif StructKeyExists(formData,oFormItem.name) and (formData[oFormItem.name] eq oFormItem.objectID)>
							'X',
						<cfelse>
							'',
						</cfif>
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