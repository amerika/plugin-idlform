<cfset filename = "Excel_#DateFormat(now(),'yymmdd')##TimeFormat(now(),'hhmmss')#.xls" />

<cfset lItemNames = "" />

<cfloop list="#session.forExcel.lFormList2#" index="i">
	<cfquery name="colName" dbtype="query">
	SELECT title
	FROM session.forExcel.qFormlogtitles
	WHERE formItemID = '#i#'
	</cfquery>
	<cfset lItemNames = listAppend(lItemNames,colName.title) />
</cfloop>

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


<cfspreadsheet
    action = "write" 
    filename = "#theFile#"
    name = "theSheet"
    overwrite = "true" 
    sheetname = "Excel report" >

<cfoutput>Excel file generated. <a href="/excel/#filename#" target="_blank">Click here to download</a>.</cfoutput>