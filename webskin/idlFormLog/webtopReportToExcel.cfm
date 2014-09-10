<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Copyright (c) 2014 Amerika Design & Utvikling AS. All rights reserved. --->
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

<!--- @@displayname: webtopReportToExcel.cfm --->
<!--- @@description: There is no description for this template. Please add or remove this message. --->
<!--- @@author: Jørgen M. Skogås (jorgen@amerika.no) on 2014-09-10 --->

<!--- Output: HTML content
////////////////////////////////////////////////////////////////////////////////////////////////////// --->
<cfset lItemNames = "" />
<cfloop list="#session.forExcel.lFormList2#" index="i">
	<cfquery name="colName" dbtype="query">
	SELECT title
	FROM session.forExcel.qFormlogtitles
	WHERE formItemID = '#i#'
	</cfquery>
	<cfset lItemNames = listAppend(lItemNames,colName.title) />
</cfloop>

<!--- Set filename --->
<cfif session.forExcel.qFormLogs.recordCount GT 0>
	<cfset filename = "#session.forExcel.qFormLogs.title#-#DateFormat(now(),'yyyy-mm-dd')#-#TimeFormat(now(),'hh-mm-ss')#.xls" />
<cfelse>
	<cfset filename = "excel-#DateFormat(now(),'yyyy-mm-dd')#-#TimeFormat(now(),'hh-mm-ss')#.xls" />
</cfif>

<cfscript> 
	theDir=ExpandPath('/excel/'); 
	theFile=theDir & filename;

	//Create empty ColdFusion spreadsheet objects. ---> 
	theSheet = SpreadsheetNew("Excel report");
	SpreadsheetAddrow(theSheet, "Date,#lItemNames#");

	format1 = structNew();
	format1.color="dark_blue;";
	format1.italic="true";
	format1.bold="true";
	format1.alignment="left";
	SpreadsheetFormatRow(theSheet,format1,"1");
</cfscript>

<cfloop query="session.forExcel.qFormLogs">
	<cfset lValues = "" />

	<cfquery name="formlogitems" datasource="#application.dsn#">
		SELECT title, value, formItemID
		FROM idlFormLogItem
		WHERE formlogid = '#session.forExcel.qFormLogs.objectid#'
		AND formItemID IN(#ListQualify(session.forExcel.lFormList2,"'")#)
	</cfquery>

	<cfset lValues = listappend(lValues, '#lsDateFormat(session.forExcel.qFormLogs.dateTimeCreated, "dd.mm.yyyy")# #timeformat(session.forExcel.qFormLogs.dateTimeCreated, "HH:MM")#') />

	<cfloop list="#session.forExcel.lFormList2#" index="i">

		<cfquery name="qThisValue" dbtype="query">
		SELECT *
		FROM formlogitems
		WHERE formItemID = '#i#'
		</cfquery>

		<cfif FileExists(qThisValue.value)>
			<cfset lValues = listappend(lValues,GetFileFromPath(qThisValue.value)) />
		<cfelse>
			<cfset lValues = listappend(lValues,"#qThisValue.value#") />
		</cfif>

	</cfloop>

	<cfscript>
		SpreadsheetAddrow(theSheet, lValues);
	</cfscript>
</cfloop>

<cfheader name="Content-Disposition" value="attachment; filename=#filename#">
<cfcontent type="application/msexcel" variable="#spreadSheetReadBinary(theSheet)#" reset="true">

<cfsetting enablecfoutputonly="false" />