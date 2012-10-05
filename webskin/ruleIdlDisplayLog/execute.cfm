<!--- get unique formlogids that has correct pageid --->
<cfquery name="qFindFormLogIDs" datasource="#application.dsn#">
	SELECT *
	FROM idlFormLogItem
	WHERE CAST(value AS nvarchar(35)) = '#request.stObj.objectID#' -- We only need 35 characters because we are searching for UUIDs.
</cfquery>

<cfif qFindFormLogIDs.recordCount GT 0>
	<!--- get form item that contains the pageid --->
	<cfquery name="qFormLogs" datasource="#application.dsn#" maxRows="100">
		SELECT *
		FROM idlFormLog
		WHERE objectID IN(#quotedvaluelist(qFindFormLogIDs.formLogID)#)
		ORDER BY dateTimeCreated DESC
	</cfquery>

	<!--- get field data --->
	<cfquery name="qFieldsToShow" datasource="#application.dsn#">
		SELECT objectID, label
		FROM idlFormItem
		WHERE objectID IN(
				<cfqueryparam value="#arraytolist(stObj.aFormItemIDs)#" cfsqltype="cf_sql_varchar" list="true"/>
			  )
		ORDER BY CASE objectID
			<cfloop index="i" from="1" to="#arrayLen(stObj.aFormItemIDs)#">
				WHEN '#stObj.aFormItemIDs[i]#' THEN #i#
			</cfloop>
		END
	</cfquery>

	<cfoutput>
		<cfif trim(stObj.intro) NEQ "">#stObj.intro#</cfif>
	</cfoutput>
	<cfif qFormLogs.recordCount GT 0>
		<cfoutput>
			<table>
				<tr>
					<td><strong>Dato</strong></td>
					<cfloop query="qFieldsToShow">
						<td><strong>#qFieldsToShow.label#</strong></td>
					</cfloop>
				</tr>
		</cfoutput>

		<cfloop query="qFormLogs">
			<cfquery name="qFormLogItems" datasource="#application.dsn#">
				SELECT title, value, dateTimeCreated
				FROM idlFormLogItem
				WHERE formLogID = '#qFormLogs.objectID#'
					<cfif qFieldsToShow.recordCount GT 0>
						AND (
						<cfloop query="qFieldsToShow">
							formItemID='#qFieldsToShow.objectID#' OR 
						</cfloop>
						1=2)
					</cfif>
				ORDER BY CASE formItemID
					<cfloop query="qFieldsToShow">
						WHEN '#qFieldsToShow.objectID#' THEN #qFieldsToShow.currentRow#
					</cfloop>
					ELSE #qFieldsToShow.recordCount + 1#
				END
			</cfquery>
		
			<cfoutput>
				<tr>
					<td>#lsDateFormat(qFormLogItems.dateTimeCreated, "dd. mmmm")#</td>
			</cfoutput>
		
			<cfloop query="qFormLogItems">
				<cfoutput>
					<td>#qFormLogItems.value#</td>
				</cfoutput>
			</cfloop>

			<cfoutput>
				</tr>
			</cfoutput>
		
		</cfloop>
	
		<cfoutput>
			</table><br />
		</cfoutput>
	
	<cfelse>
		<cfoutput>
			<cfif trim(stObj.intro) NEQ "">#stObj.intro#</cfif>
			<p>#stObj.noRegistrationText#</p>
		</cfoutput>
	</cfif>
<cfelse>
	<cfoutput>
		<cfif trim(stObj.intro) NEQ "">#stObj.intro#</cfif>
		<p>#stObj.noRegistrationText#</p>
	</cfoutput>
</cfif>
