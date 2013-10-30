<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Copyright (c) 2008 IDLmedia AS. All rights reserved. --->
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
<admin:header title="Form log" />

	<!--- <cfif application.fapi.hasRole('sysadmin')>
		<ft:objectadmin 
			typename="idlFormLog"
			permissionset="news"
			title="Form log"
			columnList="title,receiver,dateTimeCreated"
			sortableColumns="title,receiver,dateTimeCreated"
			sqlOrderBy="dateTimeCreated DESC"
			lFilterFields="title,receiver"
			plugin="idlForm"
			module="/idlFormLog.cfm" />
	<cfelse> --->
		<ft:objectadmin 
			typename="idlFormLog"
			permissionset="news"
			title="Form log"
			columnList="title,receiver,dateTimeCreated"
			sortableColumns="title,receiver,dateTimeCreated"
			lFilterFields="title,receiver"
			sqlOrderBy="dateTimeCreated DESC"
			plugin="idlForm"
			module="/idlFormLog.cfm"
			lButtons=""
			bSelectCol="false"
			bEditCol="true"
			bViewCol="false"
			bPreviewCol="true"
			bFlowCol="false" />
	<!--- </cfif> --->

<!--- setup footer --->
<admin:footer />

<cfsetting enablecfoutputonly="false" />