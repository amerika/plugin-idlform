<cfsetting enablecfoutputonly="yes" />

<cfparam name="attributes.objectID" default="" />	<!--- The objectID of the form --->
<cfparam name="attributes.formInfo" default="" /> 	<!--- The form info text --->
<cfparam name="attributes.sendtText" default="" /> 	<!--- The form sendt text --->
<cfparam name="attributes.submitText" default="" />	<!--- The text in the submitbutton --->
<cfparam name="attributes.aFormItems" default="" />	<!--- The array with formitems objectIDs --->
<cfparam name="attributes.class" default="" />		<!--- form tags class --->
<cfparam name="attributes.id" default="" />			<!--- form tags id --->

<cfif thistag.executionMode eq "Start">

	<cfif StructKeyExists(form,"submitidlform")>
		<!--- send the content of the submited form by e-mail --->
		<cfinvoke component="farcry.plugins.idlForm.packages.types.idlForm" method="submit">
			<cfinvokeargument name="objectId" value="#attributes.objectId#"/>
			<cfinvokeargument name="formData" value="#form#"/>
		</cfinvoke>
		
		<cfsavecontent variable="tagoutput">
			<!--- confirmation: respons to the user  --->
			<cfoutput>#attributes.sendtText#</cfoutput>
		</cfsavecontent>
		
	<cfelse>
		
		<cfset oFormItemService = createObject("component","farcry.plugins.idlForm.packages.types.idlFormItem")>

		<!--- 	set comma delimeted list with input types which should not have a label - 
				hidden should ALWAYS be in this list  --->
		<cfset noLabel = "hidden,statictext">
		
		<cfoutput>
			<cfif trim(attributes.formInfo) NEQ "">
				<p>#attributes.formInfo#</p>
			</cfif>
			<form action="" method="post" enctype="multipart/form-data" name="idlform"<cfif attributes.class NEQ ""> class="#attributes.class#"<cfelse> class="idlform"</cfif><cfif attributes.id NEQ ""> id="#attributes.id#"</cfif>>
		</cfoutput>
		
		<cfsavecontent variable="tagoutput">
		<!--- loop over items --->
			<cfloop from="1" to="#arrayLen(attributes.aFormItems)#" index="i">
			
			<!--- get formitem data --->
			<cfset oFormItem = oFormItemService.getData(objectID=attributes.aFormItems[i])>
			
			<cfif oFormItem.type neq "hidden">
			
			<!--- Add classes --->
				<cfsavecontent variable="fieldsetClasses">
					<cfif trim(oFormItem.width) NEQ "" OR trim(oFormItem.class) NEQ "">
						<cfoutput> class="</cfoutput> <!--- Start class --->
							
							<cfif trim(oFormItem.width) NEQ "">
								<cfoutput>#trim(oFormItem.width)# </cfoutput>
							</cfif>
							
							<cfif trim(oFormItem.class) NEQ "">
								<cfoutput>#trim(oFormItem.class)#</cfoutput>
							</cfif>
							
							
						<cfoutput>" </cfoutput> <!--- End class --->
					</cfif>
				</cfsavecontent>
				
				<cfoutput>#"<fieldset" & fieldsetClasses & ">"#</cfoutput>
				
			</cfif>
								
					<!--- display (or not) label --->
					<cfif not ListFind(noLabel,oFormItem.type)>

					<cfoutput><label for="#oFormItem.objectid#"></cfoutput>
						
					<cfif Len(trim(oFormItem.title))><cfoutput>#oFormItem.title#:</cfoutput></cfif>
					
					<cfoutput></label></cfoutput>
						
					</cfif>
					<cfswitch expression="#oFormItem.type#">
						<cfcase value="textfield">
							 <cfoutput>
							<input name="#oFormItem.objectid#" type="text" class="text" value="#oFormItem.initValue#" />
							</cfoutput>
						</cfcase>
						<cfcase value="textarea">
							<cfoutput>
							<textarea name="#oFormItem.objectid#" wrap="virtual">#oFormItem.initValue#</textarea>
							</cfoutput>
						</cfcase>
						<cfcase value="checkbox">
							<cfoutput>
							<input name="#oFormItem.objectid#" type="checkbox" class="checkbox" value="#oFormItem.initValue#" <cfif oFormItem.initValue is 1>checked</cfif> />
							</cfoutput>
						</cfcase>
						<cfcase value="radiobutton">
							<cfoutput>
							<input name="#oFormItem.name#" type="radio" class="radio" value="#oFormItem.initValue#" <cfif oFormItem.initValue is 1>checked</cfif> />
							</cfoutput>
						</cfcase>
						<cfcase value="list">
							<cfoutput>
							<select name="#oFormItem.objectid#">
							</cfoutput>
							
							<cfloop list="#oFormItem.initValue#" index="i">
								<cfoutput>
								<option value="#i#">#i#</option>
								</cfoutput>
							</cfloop>
							
							<cfoutput>
							</select>
							</cfoutput>
						</cfcase>
						<cfcase value="filefield">
							<cfoutput>
							<input name="#oFormItem.objectid#" type="file" class="file" />
							</cfoutput>
						</cfcase>
						<cfcase value="statictext">
							<cfoutput>
							<span class="statictext">#oFormItem.initValue#</span>
							</cfoutput>
						</cfcase>
						<cfcase value="hidden">
							<cfoutput>
								<cfif Left(oFormItem.initValue, "1") is "##" and Right(oFormItem.initValue, "1") is "##">
									<cfset thisvalue = #Evaluate(oFormItem.initValue)#>
								<cfelse>
									<cfset thisvalue = oFormItem.initValue>
								</cfif>
								<input type="hidden" name="#oFormItem.objectid#" value="#thisvalue#" />
							</cfoutput>
						</cfcase>
					</cfswitch>
					
					<cfif oFormItem.type neq "hidden">
						<cfoutput></fieldset></cfoutput>
						<cfif oFormItem.linebreak is 1><cfoutput><br /></cfoutput></cfif>
					</cfif>
				
			</cfloop>
			<cfoutput>
				<label for="submitidlform" class="submit">&nbsp;</label>
				<input type="submit" class="submit" name="submitidlform" value="#attributes.submittext#" />
			</form>
			</cfoutput>
		</cfsavecontent>
	</cfif>

<cfelse>
	
	<!--- thistag.ExecutionMode is END --->
	<cfset thistag.GeneratedContent=tagoutput>

</cfif>

<cfsetting enablecfoutputonly="yes" />