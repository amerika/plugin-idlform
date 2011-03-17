<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- @@Copyright: Copyright (c) 2010 IDLmedia AS. All rights reserved. --->
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
<!--- @@author: Jørgen M. Skogås on 2010-10-27 --->

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