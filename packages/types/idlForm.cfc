<cfcomponent displayname="Form" hint="Component to easy build forms" extends="farcry.core.packages.types.types" output="true" bFriendly="true" fualias="forms">
	
	<!--- // Standard type properties
	----------------------------------------------------------------->
	<cfproperty ftseq="1" ftWizardStep="General" ftFieldset="Form details"
				name="title" type="string" required="yes" default=""
				ftlabel="Form title" ftValidation="required"
				hint="Form title" />

	<cfproperty ftseq="2" ftWizardStep="General" ftFieldset="Form details"
				name="formheader" type="longchar" required="no" default="Please fill in the form below:"
				ftlabel="Introductory text"
				hint="Description / Introductory text for the form" />

	<cfproperty ftseq="3" ftWizardStep="General" ftFieldset="Form details"
				name="sendt" type="longchar" required="no" default="Thank you!"
				ftlabel="Form submited text"
				hint="Text to display when form is submitted" />

	<cfproperty ftseq="4" ftWizardStep="General" ftFieldset="Form details"
				name="submittext" type="string" required="yes" default="Send"
				ftlabel="Text for the submit button"
				hint="Text for the submit button" />

	<cfproperty ftseq="5" ftWizardStep="General" ftFieldset="Form details"
				name="receiver" type="string" required="yes" default=""
				ftlabel="Receiver (email)" ftValidation="required"
				hint="E-mail address of the receiver of the form" />

	<!--- // Form items
	----------------------------------------------------------------->
	<cfproperty ftseq="20" ftWizardStep="Form items" ftFieldset="Form items"
				name="aFormItems" type="array" required="no" default=""
				ftlabel="Selected Form Items" ftjoin="idlFormItem"
				ftAllowAttach="true" ftAllowAdd="true" ftAllowEdit="true" ftRemoveType="detach"
				hint="Holds objects to be displayed at this particular node." />

	<!--- // Advanced type properties (captcha)
	----------------------------------------------------------------->
	<cfproperty ftseq="50" ftWizardStep="Advanced" ftFieldset="Confirmation email"
				name="confirmationFormItemID" type="UUID" required="no" default=""
				ftlabel="E-mail field" ftType="list" ftRenderType="dropdown" ftSelectMultiple="false"
				ftListData="getConfirmationList"
				ftHint="Hint: Only form items with validation type email are listed here." />

	<cfproperty ftseq="100" ftWizardStep="Advanced" ftFieldset="Captcha settings"
				name="useCaptcha" type="boolean" required="no" default="false"
				ftlabel="Enable Captcha?"
				fthelptitle="What is Captcha?"
				fthelpsection="An image containing a numerical or alphabetic code that can normally only be read and interpreted by a human. It is used to verify a form to prevent computers/bots from spamming the form."
				hint="If captcha should be used or not." />

	<cfproperty ftseq="101" ftWizardStep="Advanced" ftFieldset="Captcha settings"
				name="captchaLabel" type="string" required="no" default="Fill in the text from the image bellow"
				ftlabel="Captcha label"
				ftjoin="idlFormItem"
				hint="Text in front of the text recognition field." />

	<cfproperty ftseq="102" ftWizardStep="Advanced" ftFieldset="Captcha settings"
				name="captchaErrorMessage" type="string" required="no" default="You did not match the image text."
				ftlabel="Captcha error message"
				ftjoin="idlFormItem"
				hint="Error to show if text recognition fails." />
	
	<!--- // Deactivated properties (used for backwards compatibility)
	----------------------------------------------------------------->
	<cfproperty ftseq="" ftWizardStep="" ftFieldset=""
				name="displayMethod" type="string" required="yes" default="displayPageStandard"
				ftlabel="Form Template" fttype="webskin" ftprefix="displayPage"
				hint="Display method to render this HTML object with." />

	<!--- // Methods
	----------------------------------------------------------------->
	<cffunction name="submit" access="public" output="false" returntype="struct">
		<cfargument name="objectid" required="yes" type="uuid" />
		<cfargument name="formData" required="yes" type="struct" />
		
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
				<cffile action="upload" filefield="#oFormItem.objectid#" destination="#application.defaultfilepath#" nameconflict="makeunique" />
				<cfset uploadfile[#oFormItem.objectid#] = "#cffile.serverDirectory#\#cffile.serverFile#" />
			</cfif>
		</cfloop>
		
		<!--- log --->
		<cfset formLogID = createObject("component", application.stCoapi.idlFormLog.packagePath).createLog(stObj=stObj) />
		
		<!--- log items --->
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
		<cfargument name="objectid" required="yes" type="uuid">
		<cfargument name="formData" required="yes" type="struct">
		<cfargument name="stObj" required="yes" type="struct">
		<cfargument name="uploadfile" required="yes" type="struct">
		
		<!--- set a default noreply email address, TODO: The plugin should have a config object for this --->
		<cfset var cfMailFrom = "noreply@#cgi.HTTP_HOST#" />
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
					th, td {
						padding: 5px;
					}
					th {
						background-color: ##48618A;
						color: ##FFFFFF;
						font-size: 12px;
					}
					td {
						background-color: ##F1F1F1;	
						font-size: 11px;
					}
					.or {
						color: ##E17000;
					}
					-->
					</style>
					<body>
						<strong>#arguments.stObj.title#</strong><br>
						&nbsp;<br>
						<table cellspacing="1" bgcolor="##CCCCCC">
							<tr>
								<th scope="col">Form item:</th>
								<th scope="col">Submitted information:</th>
							</tr>
							<cfloop from="1" to="#arrayLen(arguments.stObj.aFormItems)#" index="i">
								<cfset oFormItem = application.fapi.getContentObject(objectID=arguments.stObj.aFormItems[i]) />
								<cfif oFormItem.type is "radiobutton">
									<tr><td><strong>#oFormItem.title#:</strong></td><td><cfif StructKeyExists(arguments.formData,oFormItem.name) and (formData[oFormItem.name] eq oFormItem.objectID)>X</cfif></td></tr>
								<cfelseif oFormItem.type is "filefield" and StructKeyExists(arguments.uploadfile,oFormItem.objectid)>
									<cfmailparam file="#arguments.uploadfile[oFormItem.objectid]#">
									<tr><td><strong>#oFormItem.title#:</strong></td><td class="or">#ListLast(arguments.uploadfile[oFormItem.objectid],"\")#</td></tr>
								<cfelse>
									<tr><td><strong>#oFormItem.title#:</strong></td><td><cfif StructKeyExists(arguments.formData,oFormItem.objectid)>#arguments.formData[oFormItem.objectid]#</cfif></td></tr>
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

</cfcomponent>