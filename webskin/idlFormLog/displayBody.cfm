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
<skin:importCSS type="jquery"/>

<cfoutput>
	<div id="formLog"class="ui-widget ui-widget-overlay">
		<h1>#stObj.title#</h1>
		<cfif stObj.description CONTAINS "<">
			#stObj.description#
		<cfelse>
			<p>#stObj.description#</p>
		</cfif>
</cfoutput>

<cfquery name="qFormLogItems" datasource="#application.dsn#">
	SELECT *
	FROM idlFormLogItem
	WHERE formLogID = '#stObj.objectID#'
</cfquery>

<cfoutput>
		<table border="0" cellspacing="5" cellpadding="5" class="ui-corner-all" style="background-color:##ededed;">
			<tr>
				<th>Skjema element</th>
				<th>Brukerdata</th>
			</tr>
			<cfloop query="qFormLogItems">
				<tr>
					<td>#qFormLogItems.title#</td>
					<td>#qFormLogItems.value#</td>
				</tr>
			</cfloop>
		</table>
	</div>
</cfoutput>

<cfsetting enablecfoutputonly="false" />