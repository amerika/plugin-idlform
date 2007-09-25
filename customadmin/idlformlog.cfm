<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

		<!--- hack until the bActionCol attribute is implemented for objectadmin in the FarCry core --->
		
		<ft:processForm action="view" >
		   <!--- redirect to invoker --->
		  <cfset viewURL = "/farcry/admin/customadmin.cfm?plugin=idlform&module=idlformLogView.cfm&objectid=#form.selectedobjectid#">
		  <cflocation url="#viewURL#" addtoken="false" />
		</ft:processForm>
		
		<ft:processForm action="edit" >
		   <!--- redirect to invoker --->
		  <cfset viewURL = "/farcry/admin/customadmin.cfm?plugin=idlform&module=idlformLogView.cfm&objectid=#form.selectedobjectid#">
		  <cflocation url="#viewURL#" addtoken="false" />
		</ft:processForm>
		
		<ft:processForm action="overview" >
		   <!--- redirect to invoker --->
		  <cfset viewURL = "/farcry/admin/customadmin.cfm?plugin=idlform&module=idlformLogView.cfm&objectid=#form.selectedobjectid#">
		  <cflocation url="#viewURL#" addtoken="false" />
		</ft:processForm>

<!--- set up page header --->
<admin:header title="Form log" />

<ft:objectadmin 
	typename="idlFormLog"
	permissionset="news"
	title="Form log"
	columnList="title,receiver,datetimelastUpdated"
	sortableColumns="title,receiver,datetimelastUpdated"
	lFilterFields="title,receiver"
	plugin="idlForm"
	module="/idlFormLog.cfm"
	lButtons="no"
	bSelectCol="false" />

<!--- setup footer --->
<admin:footer />