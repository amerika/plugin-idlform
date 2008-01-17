<cfcomponent displayname="Form" hint="Component to easy build forms" extends="farcry.core.packages.types.types" output="false" buseintree="true">
	
	<!--- type properties --->
	<cfproperty name="title" type="string" hint="Form title" required="yes" default="" ftlabel="Form title" ftseq="1">
	<cfproperty name="formheader" type="longchar" hint="Description / introdoctury text for the form" required="no" default="Please fill in the form below:" ftlabel="Introdoctury text" ftseq="2">
	<cfproperty name="sendt" type="longchar" hint="Text to display when form is submitted" required="no" default="Thank you!" ftlabel="Form submited text"  ftseq="3">
	<cfproperty name="receiver" type="string" hint="E-mail address of the receiver of the form" required="yes" default="" ftlabel="Receiver (email)" ftseq="5">
	<cfproperty name="submittext" type="string" hint="Text for the submit button" required="yes" default="Send" ftlabel="Text for the submit button" ftseq="4">
	<cfproperty name="displayMethod" type="string" hint="Display method to render this HTML object with." required="yes" default="display" ftlabel="Page template" fttype="webskin" ftprefix="displayPage" ftseq="6">
	<cfproperty name="aFormItems" type="array" hint="Holds objects to be displayed at this particular node." required="no" default="" 	ftlabel="Form Items" ftjoin="idlFormItem" ftseq="7">

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
				<cfif (oFormItem.type is "radiobutton") or (oFormItem.type is "checkbox")>
					<tr><td><strong>#oFormItem.title#:</strong></td><td><cfif StructKeyExists(arguments.formData,oFormItem.name)>#arguments.formData[oFormItem.name]#</cfif></td></tr>
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