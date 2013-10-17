<cfsetting enablecfoutputonly="true" /> 
<!--- @@Copyright: Copyright (c) 2012 IDLmedia AS. All rights reserved. --->
<!--- @@License:
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
--->

<!--- @@displayname: displayBody --->
<!--- @@description: displayBody --->
<!--- @@author: Jørgen M. Skogås on 2012-02-02 --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<skin:loadJS id="jquery" />
<skin:loadCSS id="jquery-ui" />

<skin:htmlHead>
	<cfoutput>
		<style type="text/css" media="screen">
			body {font-size: 0.85em;}
			table {font-size: 1em;background-color:##ededed;}
			th {text-align: left;}
			th, td {border-bottom:dotted 1px ##ccc;}
		</style>
	</cfoutput>
</skin:htmlHead>


<cfquery name="qFormLogItems" datasource="#application.dsn#">
	SELECT *
	FROM idlFormLogItem
	WHERE formLogID = '#stObj.objectID#'
</cfquery>

<cfoutput>
		<table border="0" cellspacing="5" cellpadding="5" class="ui-corner-all">
			<cfloop query="qFormLogItems">
				<tr>
					<th>#qFormLogItems.title#</th>
					<td>
						<cfif isvalid("UUID", qFormLogItems.value)>
							<a href="/#qFormLogItems.value#">#qFormLogItems.value#</a>
						<cfelseif isvalid("URL", qFormLogItems.value)>
							<a href="#qFormLogItems.value#">#qFormLogItems.value#</a>
						<cfelseif isvalid("email", qFormLogItems.value)>
							<a href="mailto:#qFormLogItems.value#">#qFormLogItems.value#</a>
						<cfelseif FileExists(qFormLogItems.value)>
							<a href="/files/#GetFileFromPath(qFormLogItems.value)#" target="_blank">#GetFileFromPath(qFormLogItems.value)#</a>
						<cfelse>
							#qFormLogItems.value#
						</cfif>
					</td>
				</tr>
			</cfloop>
		</table>
</cfoutput>

<cfsetting enablecfoutputonly="false" />