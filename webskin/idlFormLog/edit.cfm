<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Copyright (c) 2013 IDLmedia AS. All rights reserved. --->
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
<!--- @@author: Jørgen M. Skogås (jorgen@amerika.no) --->

<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<!--- set up page header --->
<admin:header title="Form log item" />
	
	<cfquery name="qLogItems" datasource="#application.dsn#">
		SELECT *
		FROM idlFormLogItem
		WHERE formLogID = '#url.objectID#'
	</cfquery>

	<cfloop query="qLogItems">
		<!--- qLogItems are not save with FarCry API, so we need to add them to refObjects so we can edit them with FarCry --->
		<!--- Only add the object to refObjects if not exists already --->
		<cfquery name="q" datasource="#application.dsn#">
			IF NOT EXISTS (SELECT * FROM refObjects WHERE objectID = '#qLogItems.objectID#')
				BEGIN
					-- INSERT HERE
					INSERT INTO refObjects (objectID, typename)
					VALUES ('#qLogItems.objectID#', 'idlFormLogItem')
				END
		</cfquery>
	</cfloop>

	<ft:objectadmin 
		typename="idlFormLogItem"
		permissionset="news"
		title="Form log elements"
		columnList="title,value,datetimelastUpdated"
		sortableColumns="title,value,datetimelastUpdated"
		sqlWhere="formLogID = '#url.objectID#' AND DATALENGTH(title) > 0 AND title != 'pageID'"
		sqlorderby="title ASC"
		lButtons=""
		bSelectCol="false"
		bEditCol="true"
		bViewCol="false"
		bPreviewCol="false"
		bFlowCol="false" />

<!--- setup footer --->
<admin:footer />

<cfsetting enablecfoutputonly="false" />