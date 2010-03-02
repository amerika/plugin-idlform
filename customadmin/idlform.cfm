<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<!--- set up page header --->
<admin:header title="Forms" />

<ft:objectadmin 
	typename="idlForm"
	permissionset="news"
	title="Forms"
	columnList="title,receiver,datetimelastUpdated"
	sortableColumns="title,receiver,datetimelastUpdated"
	lFilterFields="title,receiver"
	plugin="idlform"
	module="/idlForm.cfm" />

<!--- setup footer --->
<admin:footer />