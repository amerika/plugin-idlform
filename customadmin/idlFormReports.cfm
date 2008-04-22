<cfsetting enablecfoutputonly="yes">

<cfparam name="form.form" default="">

<cfquery name="forms" datasource="#application.dsn#">
SELECT *
FROM idlForm
</cfquery>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>IDLform report</title>
	
	<style type="text/css">
	.table1 {
		background-color: ##E7EDF1;
		border-collapse: collapse;
		}
	
	.table1 th,
	.table1 td {
		border: solid 1px ##000000;
		font-family: "Trebuchet MS", Verdana, Arial, sans-serif;
		font-size: 12px;
		padding: 5px;
		text-align: left;
		}
	
	th {
		background-color: ##C9D7E2;
		}
	</style>

</head>

<body>
	<form method="post">
	
		<select name="form">
			<option value=""> - - - Chose form to generate report from - - - </option>
			<cfloop query="forms">
				<option value="#forms.objectid#" <cfif form.form eq forms.objectid>selected="true"</cfif>>#forms.title#</option>
			</cfloop>
		</select>
		
		<input type="submit" value="Generate report">
	
	</form>
</cfoutput>

<cfif Len(form.form)>

	<cfquery name="formlogs" datasource="#application.dsn#">
	SELECT *
	FROM idlFormLog
	WHERE formid = '#form.form#'
	</cfquery>
	
	<cfquery name="formlogtitles" datasource="#application.dsn#">
	SELECT title
	FROM idlFormLogItem
	WHERE formlogid IN (
		SELECT objectid
		FROM idlFormLog
		WHERE formid = '#form.form#'
		)
	GROUP BY title
	</cfquery>
	
	<cfoutput>
		<table class="table1">
			<tr>
				<cfloop query="formlogtitles">
					<th>#formlogtitles.title#</th>
				</cfloop>
			</tr>
			
			<cfloop query="formlogs">
				
				<cfquery name="formlogitems" datasource="#application.dsn#">
				SELECT title, value
				FROM idlFormLogItem
				WHERE formlogid = '#formlogs.objectid#'
				</cfquery>
				
				<tr>
					<cfloop query="formlogtitles">
						<td>
							<cfset thistitle = formlogtitles.title>
							<cfloop query="formlogitems">
								<cfif formlogitems.title eq thistitle>
									#formlogitems.value#
								</cfif>
							</cfloop>
						</td>
					</cfloop>
			
				</tr>
			
			</cfloop>
			
		</table>
	</cfoutput>
	
</cfif>

</body>
</html>
<cfsetting enablecfoutputonly="no">