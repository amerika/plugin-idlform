<cfcomponent displayname="Form log" hint="Form log" extends="farcry.core.packages.types.types" output="false">
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

	<cfproperty name="formID" type="uuid" hint="the ID of the form being logged" required="yes">
	<cfproperty name="title" type="string" hint="Form title" required="yes" default="">
	<cfproperty name="description" type="longchar" hint="Description / introdoctury text for the form" required="no" default="">
	<cfproperty name="receiver" type="longchar" hint="E-mail address of the receiver of the form" required="no" default="">
	
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
	
	<cffunction name="delete" access="public" hint="Deletes content item and related entries." returntype="struct" output="false">
		<cfargument name="objectid" required="yes" type="UUID" hint="Object ID of the object being deleted" />
		<cfargument name="user" type="string" required="true" hint="Username for object creator" default="" />
		<cfargument name="auditNote" type="string" required="true" hint="Note for audit trail" default="" />
			
		<cfset var stReturn = StructNew() />
		
		<!--- Delete form log items --->
		<cfquery name="qFormLogItems" datasource="#application.dsn#">
			DELETE FROM idlFormLogItem
			WHERE formLogID = '#arguments.objectID#'
		</cfquery>
		<cfset stReturn = super.delete(argumentcollection=arguments) />
		
		<cfreturn stReturn>
	</cffunction>
	
</cfcomponent>