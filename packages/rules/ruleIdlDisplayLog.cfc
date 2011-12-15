<cfcomponent displayname="Form builder: Form Log" extends="farcry.core.packages.rules.rules">
<!--- @@Copyright: Copyright (c) 2010 IDLmedia AS. All rights reserved. --->
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

<!--- @@displayname: Form builder: Form Log --->
<!--- @@description: Show registrations for the selected form --->
<!--- @@author: Jørgen M. Skogås on 2011-12-14 --->

	<!--- type properties --->
	<cfproperty ftSeq="1"
				name="intro" type="string" default=""
				ftLabel="Intro" ftType="longchar" ftDefault="<h2>Deltakere</h2>"
				ftHint="For at denne regelen skal fungere korrekt må skjemaene som brukes for registrering lagre ##request.stObj.objectID## for den siden de befinner seg på.
						Dette gjøres ved å opprette et hidden-felt (normalt med navnet pageID) og velge at det skal ha verdien ##request.stObj.objectID##. I tillegg anbefaler
						vi å opprette et felt som har tittelen, dette bør legges øverst, og også være skjult, med verdien ##request.stObj.title##, eller ##request.stObj.label##" />

	<cfproperty ftseq="10"
				name="formID" type="UUID" required="no" default=""
				ftlabel="Selected Form" ftjoin="idlForm"
				ftAllowAttach="true" ftAllowAdd="false" ftAllowEdit="false" ftRemoveType="detach" ftAllowCreate="false"
				ftHint="<strong>VIKTIG</strong>: Når korrekt skjema er valgt må du trykke lagre, for deretter å redigere og fullføre dette skjemaet." bSyncStatus="true" />
	
	<cfproperty ftseq="20"
				name="formItemID" type="UUID" required="no" default=""
				ftlabel="PageID Form Item" ftjoin="idlFormItem"
				ftAllowAttach="true" ftAllowAdd="false" ftAllowEdit="false" ftRemoveType="detach" ftAllowCreate="false"
				ftLibraryData="getFormItems" ftLibraryDataTypename="ruleIdlFormParticipants"
				ftHint='Her velges det input elementet som tar vare på ##request.stObj.objectID##, normalt kalles denne pageID.' />
				
	<cfproperty ftSeq="30"
				name="aFormItemIDs" type="array" required="no" default=""
				ftLabel="List fields" ftType="array" ftJoin="idlFormItem"
				ftShowLibraryLink="false" ftAllowAttach="true" ftAllowAdd="false" ftAllowEdit="false" ftRemoveType="detach" ftAllowCreate="false"
				ftLibraryData="getFormItems" ftLibraryDataTypename="ruleIdlFormParticipants"
				ftHint="Her velges de feltene som skal listes opp." />
	
	<cfproperty ftSeq="40"
				name="noRegistrationText" type="longchar" required="false" default=""
				ftLabel="No Results Text" ftDefault="Det eksisterer ingen registreringer." />
	
	<cffunction name="getFormItems" access="public" output="true" returntype="query" hint="Return a query for all images already associated to this object.">
		<cfargument name="primaryID" type="uuid" required="true" hint="ObjectID of the object that we are attaching to" />
		<cfargument name="qFilter" type="query" required="false" default="#queryNew('key')#" hint="If a library verity search has been run, this is the qResultset of that search" />
		
		<cfset var q = queryNew("blah") />
		<cfset stRule = application.fapi.getContentObject(objectID=arguments.primaryID) />

		<!--- 
		Run the entire query and return in to the library. Let the library handle the pagination.
		 --->
		<cfquery datasource="#application.dsn#" name="q">
		SELECT data as objectid, idlFormItem.label, idlFormItem.title
		FROM idlForm_aFormItems
		INNER JOIN 
			 idlFormItem ON idlForm_aFormItems.data = idlFormItem.objectid
		WHERE parentid = '#stRule.formID#'
		<cfif qFilter.RecordCount>
			AND data IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#qFilter.key#" />)
		</cfif>
		ORDER BY seq
		</cfquery>

		<cfreturn q />
	</cffunction>

</cfcomponent>