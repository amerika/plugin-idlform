<cfcomponent displayname="Form" hint="Component to easy build forms" extends="farcry.core.packages.types.types" output="false" bFriendly="true" fualias="forms">
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
<!--- @@author: Jørgen M. Skogås (jorgen@idl.no) --->
	
	<!--- // Standard type properties
	----------------------------------------------------------------->
	<cfproperty ftseq="1" ftWizardStep="General" ftFieldset="Form details"
				name="title" type="string" required="true" default=""
				ftlabel="Formtitle" ftValidation="required" />
				
	<cfproperty ftseq="4" ftWizardStep="General" ftFieldset="Form details"
				name="submittext" type="string" required="true" default="Send"
				ftlabel="Text for the submit button"
				hint="Text for the submit button" />
				
	<cfproperty ftseq="11" ftWizardStep="General" ftFieldset="Sender and receivers"
				name="sender" type="string" required="true" default=""
				ftlabel="Sender (e-mail)" ftValidation="required email" />
				
	<cfproperty ftseq="12" ftWizardStep="General" ftFieldset="Sender and receivers"
				name="aReceiverIDs" type="array" required="false" default=""
				ftlabel="Receivers (e-mail)" ftJoin="idlFormReceiver" ftAllowEdit="true"
				ftValidation="required" />
				
	<cfproperty ftseq="13" ftWizardStep="General" ftFieldset="Sender and receivers (advanced)"
				name="recieverOption" type="string" required="true" default="all"
				ftlabel="Receiver options" ftType="list" ftList="all:All recievers will recieve,list:User select the receiver"
				ftValidation="required" ftHint="If the option «User select the receiver» is choosen, it will display an select in top of the form." />
				
	<cfproperty ftseq="14" ftWizardStep="General" ftFieldset="Sender and receivers (advanced)"
				name="userSelectRecieverLabel" type="string" required="false" default=""
				ftlabel="Reciever label"
				ftHint="Customize the choose reciever label here. Leave it blank to use the default: Select reciever." />
				

	<cfproperty ftseq="20" ftWizardStep="Form text" ftFieldset="Form details"
				name="formheader" type="longchar" required="false" default="Please fill in the form below:"
				ftlabel="Introductory text" ftType="richtext" ftRichtextConfig="getConfig" />

	<cfproperty ftseq="21" ftWizardStep="Form text" ftFieldset="Form details"
				name="sendt" type="longchar" required="false" default="Thank you!"
				ftlabel="Form submited text" ftType="richtext" ftRichtextConfig="getConfig" />
				
	<!--- // Form items
	----------------------------------------------------------------->
	<cfproperty ftseq="30" ftWizardStep="Form items" ftFieldset="Form items"
				name="aFormItems" type="array" required="false" default=""
				ftlabel="Selected Form Items" ftjoin="idlFormItem"
				ftAllowAttach="false" ftAllowSelect="false" ftAllowAdd="true" ftAllowEdit="true" ftRemoveType="detach"
				hint="Holds objects to be displayed at this particular node." />

	<!--- // Advanced type properties
	----------------------------------------------------------------->
	<cfproperty ftseq="50" ftWizardStep="Advanced" ftFieldset="Confirmation email"
				name="confirmationFormItemID" type="UUID" required="false" default=""
				ftlabel="E-mail field" ftType="list" ftRenderType="dropdown" ftSelectMultiple="false"
				ftListData="getConfirmationList"
				ftHint="Hint: Only form items with validation type email are listed here." />
	
	<!--- Hidden
	----------------------------------------------------------------->
	<cfproperty ftseq="" ftWizardStep="" ftFieldset=""
				name="displayMethod" type="string" required="true" default="displayPageStandard"
				ftlabel="Form Template" fttype="webskin" ftprefix="displayPage"
				hint="Display method to render this HTML object with." />
				
	<!--- Deprecated
	----------------------------------------------------------------->
	<cfproperty name="receiver" type="string" required="true" default=""
				ftlabel="Receiver (e-mail)" ftValidation="required"
				ftHint="Separate multiple receivers with comma, eg: post@example.com, jorgen@example.com" />

	<!--- // Methods
	----------------------------------------------------------------->
	<cffunction name="submit" access="public" output="false" returntype="struct">
		<cfargument name="objectid" required="true" type="uuid" hint="idlForm objectID" />
		<cfargument name="formData" required="true" type="struct" />
		
		<!--- getData for object --->
		<cfset var stObj = this.getData(arguments.objectid) />
		<!--- create the form item object --->
		<cfset var oFormItemService = createObject("component",application.stCoapi.idlFormItem.packagepath) />
		<!--- create structure to hold submited files --->
		<cfset var uploadfile = StructNew() />
		<!--- create structute to hold the return status --->
		<cfset var stStatus = structnew() />
		<cfset stStatus.bSuccess = true />
		<cfset stStatus.message = "" />
		
		<!--- upload all submited files and add them to the uploadfile structure  --->
		<cfloop from="1" to="#arrayLen(stObj.aFormItems)#" index="i">
			<cfset oFormItem = oFormItemService.getData(objectID=stObj.aFormItems[i]) />
			
			<cfif oFormItem.type is "filefield" and Len(formData[oFormItem.objectid])>
				<cffile action="upload" filefield="#oFormItem.objectid#" destination="#application.path.defaultfilepath#" nameconflict="makeunique" />
				<cfset uploadfile[#oFormItem.objectid#] = "#cffile.serverDirectory#\#cffile.serverFile#" />
			</cfif>
		</cfloop>
		
		<!--- Get receivers --->
		<cfif stObj.recieverOption IS "all" AND structKeyExists(stObj, "aReceiverIDs") AND arrayLen(stObj.aReceiverIDs) GT 0>
			<cfset stObj.receiver = "" />
			<cfloop index="i" to="#arrayLen(stObj.aReceiverIDs)#" from="1">
				<cfset stObj.receiver = listAppend(stObj.receiver, application.fapi.getContentObject(objectID=stObj.aReceiverIDs[i]).email, ",") />
			</cfloop>
		</cfif>
		
		<!--- Get selected receiver if exists --->
		<cfset formNameReceiver = 'recievers#replace(arguments.objectid, "-", "", "ALL")#' />
		<cfif structKeyExists(arguments.formData, '#formNameReceiver#')>
			<cfset stObj.receiver = application.fapi.getContentObject(objectid=arguments.formData['#formNameReceiver#']).email />
		</cfif>
		
		<!--- Log form --->
		<cfset formLogID = createObject("component", application.stCoapi.idlFormLog.packagePath).createLog(stObj=stObj) />
		
		<!--- Log form items --->
		<cfset saveLogItems = createObject("component", application.stCoapi.idlFormLogItem.packagePath).createLogItems(stObj=stObj,formData=arguments.formData,uploadfile=#uploadfile#,formLogID=#formLogID#) />
		
		<!--- invoke method to send an email with the submited data --->
		<cftry>
			<cfset stSendMailStatus = sendMail(objectID=arguments.objectId,formData=arguments.formData,stObj=stObj,uploadfile=uploadfile) />
			<cfset stStatus.bSuccess = stSendMailStatus.bSuccess />
			<cfset stStatus.message = stSendMailStatus.message />
			<cfcatch>
				<cfset stStatus.bSuccess = false />
				<cfset stStatus.message = "E-mail can't be sent." />
				<cfset stStatus.details = cfcatch.message />
			</cfcatch>
		</cftry>
		
		<cfreturn stStatus />
	</cffunction>
	
	<cffunction name="sendMail" access="private" output="false" returntype="struct">
		<cfargument name="objectid" required="true" type="uuid" hint="idlForm objectID">
		<cfargument name="formData" required="true" type="struct">
		<cfargument name="stObj" required="true" type="struct">
		<cfargument name="uploadfile" required="true" type="struct">
		
		<!--- set the sender email address --->
		<cfset var cfMailFrom = arguments.stObj.sender />
		
		<cfif trim(cfMailFrom) EQ "">
			<cfset var cfMailFrom = "noreply@#cgi.HTTP_HOST#" />
		</cfif>
		
		<!--- create a struct to hold the status message --->
		<cfset var stStatus = structNew() />
		<cfset stStatus.bSuccess = true />
		<cfset stStatus.message = "" />
		
		<!--- if e-mail validation fails, fallback to noreply@idl.no --->
		<cfif not isvalid("email", cfMailFrom)>
			<cfset cfMailFrom = "noreply@idl.no" />
		</cfif>
		
		<!--- Check if the form has a confirmationFormItemID and if the user has filled it out
		///////////////////////////////////////////////////////////////////////////////// --->
		<cfif isValid("UUID", arguments.stObj.confirmationFormItemID)>
			<cfset userConfirmationEmail = arguments.formData[arguments.stObj.confirmationFormItemID] />
		<cfelse>
			<cfset userConfirmationEmail = "" />
		</cfif>
		
		<cfif len(arguments.stObj.receiver) OR len(userConfirmationEmail)>
			
			<cfset lMailAdr = "#arguments.stObj.receiver#,#userConfirmationEmail#"  />
			
			<cfloop index="indexMailLoop" list="#lMailAdr#" delimiters=",">
				
				<!--- Default mail attributes --->
				<cfset stMailAttributes = {
					To		= indexMailLoop,
					From 	= cfMailFrom,
					Subject = arguments.stObj.title,
					Type 	= "html"
				} />
				
				<cfif indexMailLoop EQ arguments.stObj.receiver AND userConfirmationEmail NEQ "">
					<cfset stExtras = structNew() />
					<cfset stExtras.Replyto = userConfirmationEmail />
					<cfset StructAppend(stMailAttributes, stExtras) />
				</cfif>
			
				<!--- Compose mail
				/////////////////////////////////////////////////////////////////////////////////////// --->
				<cfmail attributeCollection="#stMailAttributes#">
					<style type="text/css">
					<!--
					body {
						font: 12px Arial, Helvetica, sans-serif;
					}
					table {font-size: 1em;background-color:##ededed;}
					th {text-align: left;}
					th, td {border-bottom:dotted 1px ##ccc;}
					.or {
						color: ##E17000;
					}
					-->
					</style>
					<body>
						<strong>#arguments.stObj.title#</strong><br>
						&nbsp;<br>
						<table cellspacing="1" bgcolor="##ededed">
							<tr>
								<th scope="col" style="border-bottom:dotted 1px ##ccc;">Form item:</th>
								<th scope="col" style="border-bottom:dotted 1px ##ccc;">Submitted information:</th>
							</tr>
							<cfloop from="1" to="#arrayLen(arguments.stObj.aFormItems)#" index="i">
								<cfset oFormItem = application.fapi.getContentObject(objectID=arguments.stObj.aFormItems[i]) />
								<cfif oFormItem.type is "radiobutton">
									<tr><td style="border-bottom:dotted 1px ##ccc;"><strong>#oFormItem.title#:</strong></td><td style="border-bottom:dotted 1px ##ccc;"><cfif StructKeyExists(arguments.formData,oFormItem.name) and (formData[oFormItem.name] eq oFormItem.objectID)>X</cfif></td></tr>
								<cfelseif oFormItem.type is "filefield" and StructKeyExists(arguments.uploadfile,oFormItem.objectid)>
									<cfmailparam file="#arguments.uploadfile[oFormItem.objectid]#">
									<tr><td style="border-bottom:dotted 1px ##ccc;"><strong>#oFormItem.title#:</strong></td><td class="or" style="border-bottom:dotted 1px ##ccc;"><a href="http<cfif cgi.https is "on">s</cfif>://#cgi.HTTP_HOST#/files/#ListLast(arguments.uploadfile[oFormItem.objectid],"\")#" target="_blank">#ListLast(arguments.uploadfile[oFormItem.objectid],"\")#</a></td></tr>
								<cfelse>
									<tr><td style="border-bottom:dotted 1px ##ccc;"><strong>#oFormItem.title#:</strong></td><td style="border-bottom:dotted 1px ##ccc;"><cfif StructKeyExists(arguments.formData,oFormItem.objectid)>#arguments.formData[oFormItem.objectid]#</cfif></td></tr>
								</cfif>
							</cfloop>
						</table>
					</body>
				</cfmail>
			</cfloop>
		</cfif>
		
		<cfreturn stStatus />
	</cffunction>
	
	<cffunction name="getConfirmationList" access="public" returntype="string" output="false" description="Creates a list with email field IDs and names">
		<cfargument name="objectID" type="UUID" required="true" />
		
		<cfset var retList = ":--- Please select ---," />
		<cfset var stWizardEditObject = getData(arguments.objectID) />
		
		<cfif arrayLen(stWizardEditObject.aFormItems) GT 0>
			<cfloop index="i" to="#arrayLen(stWizardEditObject.aFormItems)#" from="1">
				<cfset stTempObj = application.fapi.getContentObject(stWizardEditObject.aFormItems[i]) />
				<!--- Check if field are validating as email --->
				<cfif stTempObj.validateType IS "email">
					<cfset retList = retList & stTempObj.objectID & ":" & stTempObj.label & "," />
				</cfif>
			</cfloop>
		<cfelse>
			<cfset retList = ":--- Can't select ---," />
		</cfif>
		
		<cfreturn retList />
	</cffunction>
	
	<cffunction name="getConfig" access="public" output="false" returntype="string" hint="This will return the configuration that will be used by the richtext field">
		<cfset var configJS = "" />
		
		<cfsavecontent variable="configJS">
			<cfoutput>			
				plugins : "link_farcry,insertdatetime,contextmenu,paste,directionality,visualchars,nonbreaking,charmap",
				menubar : false,
				toolbar : "undo redo | cut copy paste pastetext | formatselect | bold italic | bullist numlist | link",
				valid_elements: "strong/b,em/i,a[href|target],br,p,h2,h3,ul,ol,li",
				block_formats: "Paragraph=p;Header 2=h2;Header 3=h3",
				content_css : "/css/format.css",
				remove_linebreaks : false,
				forced_root_block : 'p',
				relative_urls : false,
				entity_encoding : 'raw'
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn configJS />
	</cffunction>

</cfcomponent>