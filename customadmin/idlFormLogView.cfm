<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />

<cfset stObj = createObject("component","farcry.plugins.idlForm.packages.types.idlFormLog")>
<cfset stObj = stObj.getData(objectID=#url.objectID#)>

<cfquery name="getFormLogItem" datasource="#application.dsn#">
SELECT *
FROM idlFormLogItem
WHERE formLogID = '#stObj.objectid#'
</cfquery>

<!--- set up page header --->
<admin:header title="Skjemalogg: " />

<cfoutput>
<strong>#stObj.title#</strong><br>
&nbsp;<br>
<table cellspacing="1" bgcolor="##CCCCCC">
<tr>
<th scope="col">Form item:</th>
<th scope="col">Sumbited information:</th>
</tr>
<cfloop query="getFormLogItem">
	<tr><td><strong>#getFormLogItem.title#:</strong></td><td>#getFormLogItem.value#</td></tr>
</cfloop>
</table>
</cfoutput>

<!--- setup footer --->
<admin:footer />