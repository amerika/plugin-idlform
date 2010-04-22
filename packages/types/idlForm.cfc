<cfcomponent displayname="Form" hint="Component to easy build forms" extends="farcry.core.packages.types.types" output="false" bFriendly="true" fualias="forms">
	
	<!--- // Standard type properties                                 
	----------------------------------------------------------------->
	<cfproperty name="title"
				ftlabel="Form title"
				ftWizardStep="General"
				ftFieldset="Form details"
				ftValidation="required"
				type="string"
				hint="Form title"
				required="yes"
				default=""
				ftseq="1">

	<cfproperty name="formheader"
				ftlabel="Introdoctury text"
				ftWizardStep="General"
				ftFieldset="Form details"
				type="longchar"
				hint="Description / introdoctury text for the form"
				required="no"
				default="Please fill in the form below:"
				ftseq="2">
				
	<cfproperty name="sendt"
				ftlabel="Form submited text"
				ftWizardStep="General"
				ftFieldset="Form details"
				type="longchar"
				hint="Text to display when form is submitted"
				required="no"
				default="Thank you!"
				ftseq="3">
				
	<cfproperty name="receiver"
				ftlabel="Receiver (email)"
				ftWizardStep="General"
				ftFieldset="Form details"
				ftValidation="required"
				type="string"
				hint="E-mail address of the receiver of the form"
				required="yes"
				default=""
				ftseq="5">
				
	<cfproperty name="submittext"
				ftlabel="Text for the submit button"
				ftWizardStep="General"
				ftFieldset="Form details"
				type="string"
				hint="Text for the submit button"
				required="yes"
				default="Send"
				ftseq="4">
				
	<cfproperty name="displayMethod"
				ftlabel="Form Template"
				ftWizardStep="General"
				ftFieldset="Form details"
				type="string"
				hint="Display method to render this HTML object with."
				required="yes"
				default="display"
				fttype="webskin"
				ftprefix="displayPage"
				ftseq="6" />
				
	<cfproperty name="aFormItems"
				ftlabel="Selected Form Items"
				ftWizardStep="General"
				ftFieldset="Form items"
				type="array"
				hint="Holds objects to be displayed at this particular node."
				required="no" default=""
				ftjoin="idlFormItem"
				ftseq="20"
				ftAllowAttach="true" ftAllowAdd="true" ftAllowEdit="true" ftRemoveType="detach" />
				

	<!--- // Advanced type properties (captcha)                       
	----------------------------------------------------------------->
	
	<cfproperty name="useCaptcha"
				ftlabel="Enable Captcha?"
				ftWizardStep="Advanced"
				ftFieldset="Captcha settings"
				fthelptitle="What is Captcha?"
				fthelpsection="An image containing a numerical or alphabetic code that can normally only be read and interpreted by a human. It is used to verify a form to prevent computers/bots from spamming the form."
				type="boolean"
				hint="If captcha should be used or not."
				required="no"
				default="false"
				ftseq="100">
				
	<cfproperty name="captchaLabel"
				ftlabel="Captcha label"
				ftWizardStep="Advanced"
				ftFieldset="Captcha settings"
				type="string"
				hint="Text in front of the text recognition field."
				required="no"
				default="Fill in the text from the image bellow"
				ftjoin="idlFormItem"
				ftseq="101">
				
	<cfproperty name="captchaErrorMessage"
				ftlabel="Captcha error message"
				ftWizardStep="Advanced"
				ftFieldset="Captcha settings"
				type="string"
				hint="Error to show if text recognition fails."
				required="no"
				default="You did not match the image text."
				ftjoin="idlFormItem"
				ftseq="102">


	<cffunction name="submit" access="public" output="false" returntype="void">	
		<cfargument name="objectid" required="yes" type="uuid">
		<cfargument name="formData" required="yes" type="struct">
		
		<!--- getData for object --->
		<cfset var stObj = this.getData(arguments.objectid)>
		
		<!--- create structure to hold submited files --->
		<cfset var uploadfile = StructNew()>
		
		<!--- upload all submited files and add them to the uploadfile structure  --->
		<cfloop from="1" to="#arrayLen(stObj.aFormItems)#" index="i">
			<cfset oFormItemService = createObject("component","farcry.plugins.idlForm.packages.types.idlFormItem")>
			<cfset oFormItem = oFormItemService.getData(objectID=stObj.aFormItems[i])>
		<cfif oFormItem.type is "filefield" and Len(formData[oFormItem.objectid])>
			<cffile action="upload" filefield="#oFormItem.objectid#" destination="#application.defaultfilepath#" nameconflict="makeunique">
			<cfset uploadfile[#oFormItem.objectid#] = "#cffile.serverDirectory#\#cffile.serverFile#">
		</cfif>
		</cfloop>
		
		<!--- invoke method to send an email with the submited data --->
		<cfinvoke method="sendMail">
			<cfinvokeargument name="objectId" value="#arguments.objectId#"/>
			<cfinvokeargument name="formData" value="#arguments.formData#"/>
			<cfinvokeargument name="stObj" value="#stObj#">
			<cfinvokeargument name="uploadfile" value="#uploadfile#">
		</cfinvoke>
		
		<!--- log --->
		<cfinvoke component="farcry.plugins.idlForm.packages.types.idlFormLog" method="createLog" returnvariable="formLogID">
			<cfinvokeargument name="stObj" value="#stObj#">
		</cfinvoke>
		
		<!--- log items --->
		<cfinvoke component="farcry.plugins.idlForm.packages.types.idlFormLogItem" method="createLogItems">
			<cfinvokeargument name="stObj" value="#stObj#">
			<cfinvokeargument name="formData" value="#arguments.formData#"/>
			<cfinvokeargument name="uploadfile" value="#uploadfile#">
			<cfinvokeargument name="formLogID" value="#formLogID#">
		</cfinvoke>
		
	</cffunction>
	
	<cffunction name="sendMail" access="private" output="false" returntype="void">
		<cfargument name="objectid" required="yes" type="uuid">
		<cfargument name="formData" required="yes" type="struct">
		<cfargument name="stObj" required="yes" type="struct">
		<cfargument name="uploadfile" required="yes" type="struct">
		
		<cfset oFormItemService = createObject("component","farcry.plugins.idlForm.packages.types.idlFormItem")>
		
		<cfif Len(arguments.stObj.receiver)>
		<cfmail to="#arguments.stObj.receiver#" from="contactform@#cgi.HTTP_HOST#" subject="#arguments.stObj.title#" type="html">
			
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
			<th scope="col">Sumbited information:</th>
			</tr>
			<cfloop from="1" to="#arrayLen(arguments.stObj.aFormItems)#" index="i">
				
				<cfset oFormItem = oFormItemService.getData(objectID=arguments.stObj.aFormItems[i])>
				
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
		</cfif>
	</cffunction>

</cfcomponent>