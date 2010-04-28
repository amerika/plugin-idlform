<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- @@Copyright: Copyright (c) 2010 IDLmedia AS. All rights reserved. --->
<!--- @@displayname: Default list template --->
<!--- @@License: --->

<!--- libs --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- objects --->
<cfset oForm = createObject("component", "#application.stcoapi.idlform.packagepath#") />

<!--- get forms --->
<cfset qForms = oForm.getMultipleByQuery() />

<!--- Render Output
//////////////////////////////////////////////////////////////////////////////////////////////////////// --->

<cfoutput>
	<cfif trim(stObj.title) NEQ ""><h1>#stObj.title#</h1></cfif>
	<cfif trim(stObj.description) NEQ ""><p>#stObj.description#</p></cfif>
</cfoutput>

<!--- Loop List Items --->
<cfloop query="qForms">
	<skin:view objectid="#qForms.objectID#" webskin="#stObj.displayListMethod#" />
</cfloop>

<cfsetting enablecfoutputonly="false" />