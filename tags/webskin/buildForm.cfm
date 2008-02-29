<!--- 

This template will attemt to use the cfjq_forms custom tag for form client side validation services.
Should the custom tag not be installed on the server the template will run like a normal attributes.placeError form without any validation.

The cfjq_forms custom tag can also be used to easily add ajax behaviour to form submition at a later time.
--->

<cfsetting enablecfoutputonly="yes" />

<cfparam name="attributes.objectID" default="" />	<!--- The objectID of the form --->
<cfparam name="attributes.formInfo" default="" /> 	<!--- The form info text --->
<cfparam name="attributes.sendtText" default="" /> 	<!--- The form sendt text --->
<cfparam name="attributes.submitText" default="" />	<!--- The text in the submitbutton --->
<cfparam name="attributes.aFormItems" default="" />	<!--- The array with formitems objectIDs --->
<cfparam name="attributes.class" default="" />		<!--- form tags class --->
<cfparam name="attributes.id" default="" />			<!--- form tags id --->

<!--- For validation: --->
<cfparam name="attributes.form_class" default="cfjq_form1"/> <!--- !!! validation will only work on 1 form per page right now --->
<cfparam name="attributes.placeError" default="inline"/>	<!----if "box" validation error message will be placed in a box over the form--->
<cfparam name="attributes.ajax" default="false" />		<!--- If we want to use Ajax submitions at a later time!!! --->
<cfparam name="skipValidation" default="false">

<cfparam name="errormessage" default="">

<cfif thistag.executionMode eq "Start">


<cfif trim(attributes.class) is "">
	<cfset attributes.class = "idlform">
</cfif>

<!--- include idlform.css stylesheet - if attributes.class is idlform --->
<cfif attributes.class is "idlform">
	<cfhtmlhead text='<link rel="stylesheet" type="text/css" href="/css/idlform.css" media="all" />'>
</cfif>

	<cfif StructKeyExists(form,"submitidlform")>
		
		<!--- server side validation - In the future this should probably be moved to its own validate object --->
			
			<cfset oFormItemService = createObject("component","farcry.plugins.idlForm.packages.types.idlFormItem")>
		
			<!--- Loop through the form items --->
			<cfloop from="1" to="#arrayLen(attributes.aFormItems)#" index="i">
				
				<!--- Get info about this item --->
				<cfset oFormItem = oFormItemService.getData(objectID=attributes.aFormItems[i])>

				<cfset isValid = true>
				
				<!--- if the form is of type textfield or textarea we do the following validation --->
				<cfif oFormItem.type is "textfield" or oFormItem.type is "textarea">
					
					<!--- check if it is required --->
					<cfif (oFormItem.validateRequired is 1) and (len(trim(form[oFormItem.objectID])) is 0)>
						<cfset isValid = false>
					</cfif>
					
					<cfif oFormItem.validateType is "digits" or oFormItem.validateType is "number">
					
						<cfif IsNumeric(form[oFormItem.objectID])>
						
							<!--- check if it has a minimum value --->
							<cfif IsNumeric(oFormItem.validateMinLength) and oFormItem.validateMinValue gt form[oFormItem.objectID]>
								<cfset isValid = false>
							</cfif>
							
							<!--- check if it has a maximum value --->
							<cfif IsNumeric(oFormItem.validateMaxLength) and oFormItem.validateMaxValue lt form[oFormItem.objectID]>
								<cfset isValid = false>
							</cfif>
						
						</cfif>
					
					<cfelse>
						
						<!--- check if it has a minimum length --->
						<cfif IsNumeric(oFormItem.validateMinLength) and oFormItem.validateMinLength gt len(trim(form[oFormItem.objectID]))>
							<cfset isValid = false>
						</cfif>
						
						<!--- check if it has a maximum length --->
						<cfif IsNumeric(oFormItem.validateMaxLength) and oFormItem.validateMaxLength lt len(trim(form[oFormItem.objectID]))>
							<cfset isValid = false>
						</cfif>
						
					</cfif>
					
					<cfswitch expression="oFormItem.validateType">
						
						<cfcase value="digits">
							<cfif not IsValid(integer,form[oFormItem.objectID])>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="number">
							<cfif not IsValid(numeric,form[oFormItem.objectID])>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="date">
							<cfif not IsValid(eurodate,form[oFormItem.objectID])>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="creditcard">
							<cfif not IsValid(creditcard,form[oFormItem.objectID])>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="url">
							<cfif not IsValid(URL,form[oFormItem.objectID])>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="email">
							<cfif not IsValid(email,form[oFormItem.objectID])>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
					</cfswitch>

				</cfif>
				
				<!--- if the form is of type checkbox or radiobutton we do the following validation --->
				<cfif oFormItem.type is "checkbox" or oFormItem.type is "radiobutton">
					
				<!--- TODO: add validation here --->
				
				</cfif>
				
				<cfif isValid is false>
					<!--- add info to the error message --->
					<cfset errorMessage = Insert("<span class='label'>#oFormItem.label#:</span> <span class='errortext'>#oFormItem.validateErrorMessage#</span><br />", errorMessage, Len(errorMessage))>
				</cfif>
				
			</cfloop>
			
	</cfif>
		
	
	<!--- check if form is submitted and validation passed --->
	<cfif StructKeyExists(form,"submitidlform") and Len(errormessage) is 0>
		
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
	
		<cfif Len(errormessage) gt 0>
			<cfoutput>
				<div class="idlform_errorMessage">
					#errorMessage#
				</div>
			</cfoutput>
		</cfif>
		
		<cfset oFormItemService = createObject("component","farcry.plugins.idlForm.packages.types.idlFormItem")>

		<!--- 	set comma delimeted list with input types which should not have a label - 
				hidden should ALWAYS be in this list  --->
		<cfset noLabel = "hidden,statictext">
		
		<cfoutput>
			<cfif trim(attributes.formInfo) NEQ "">
				<p>#attributes.formInfo#</p>
			</cfif>
			
			<cftry>
				<cf_cfJq_forms action="" enctype="multipart/form-data" method="post" jqFolder="jquery/cfjq"  css_class="#attributes.class#" id="#attributes.id#">
			<cfcatch type="any">
				<form action="" method="post" enctype="multipart/form-data" name="idlform" class="#attributes.class#"<cfif attributes.id NEQ ""> id="#attributes.id#"</cfif>>
				<cfset skipValidation = "true">
			</cfcatch>
			</cftry>
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
			
			<!--- create validation rule --->
			<cfset validationRule = "">
			
			<cfif skipValidation eq false>
			
				<cfif oFormItem.validateRequired is true>
					<cfset validationRule = ListAppend(validationRule,"required:true")>
				</cfif>
				
				<cfswitch expression="#oFormItem.validateType#">
					<cfcase value="url">
						<cfset validationRule = ListAppend(validationRule,"url:true")>
					</cfcase>
					<cfcase value="email">
						<cfset validationRule = ListAppend(validationRule,"email:true")>
					</cfcase>
					<cfcase value="date">
						<cfset validationRule = ListAppend(validationRule,"dateDE:true")>
					</cfcase>
					<cfcase value="creditcard">
						<cfset validationRule = ListAppend(validationRule,"creditcard:true")>
					</cfcase>
					<cfcase value="digits">
						<cfset validationRule = ListAppend(validationRule,"digits:true")>
					</cfcase>
					<cfcase value="number">
						<cfset validationRule = ListAppend(validationRule,"numberDE:true")>
					</cfcase>
				</cfswitch>
				
				<cfif IsNumeric(oFormItem.validateMinLength)>
					<cfif (oFormItem.validateType is "digits") or (oFormItem.validateType is "number")>
						<cfset validationRule = ListAppend(validationRule,"minValue:#oFormItem.validateMinLength#")>
					<cfelse>
						<cfset validationRule = ListAppend(validationRule,"minLength:#oFormItem.validateMinLength#")>
					</cfif>
				</cfif>
				
				<cfif IsNumeric(oFormItem.validateMaxLength)>
					<cfif (oFormItem.validateType is "digits") or (oFormItem.validateType is "number")>
						<cfset validationRule = ListAppend(validationRule,"maxValue:#oFormItem.validateMaxLength#")>
					<cfelse>	
						<cfset validationRule = ListAppend(validationRule,"maxLength:#oFormItem.validateMaxLength#")>
					</cfif>
				</cfif>
				
			</cfif>
			
								
			<!--- display (or not) label --->
			<cfif not ListFind(noLabel,oFormItem.type)>

				<cfoutput><label for="#oFormItem.objectid#"></cfoutput>
				<cfif Len(trim(oFormItem.title))><cfoutput>#oFormItem.title#:</cfoutput></cfif>
				
				<cfoutput></label></cfoutput>
						
			</cfif>
			
			<cfif oFormItem.type NEQ "hidden" AND oFormItem.cssID NEQ "">
				<cfset thisCssID = ' id="#oFormItem.cssID#"' />
			<cfelse>
				<cfset thisCssID = "" />
			</cfif>
			
			<cfswitch expression="#oFormItem.type#">
				<cfcase value="textfield">
					 <cfoutput>
					<input name="#oFormItem.objectid#" <cfif trim(oFormItem.validateErrorMessage) gt 0>title="#oFormItem.validateErrorMessage#"</cfif> type="text" class="<cfif ListLen(validationRule) gt 0>{#validationRule#}</cfif> text" value="#oFormItem.initValue#"#thisCssID# />
					</cfoutput>
				</cfcase>
				<cfcase value="textarea">
					<cfoutput>
					<textarea name="#oFormItem.objectid#" <cfif trim(oFormItem.validateErrorMessage) gt 0>title="#oFormItem.validateErrorMessage#"</cfif> wrap="virtual"#thisCssID#>#oFormItem.initValue#</textarea>
					</cfoutput>
				</cfcase>
				<cfcase value="checkbox">
					<cfoutput>
					<input name="#oFormItem.name#" type="checkbox" <cfif trim(oFormItem.validateErrorMessage) gt 0>title="#oFormItem.validateErrorMessage#"</cfif> class="checkbox" value="#oFormItem.initValue#"#thisCssID# <cfif oFormItem.initValue is 1>checked</cfif> />
					</cfoutput>
				</cfcase>
				<cfcase value="radiobutton">
					<cfoutput>
					<input name="#oFormItem.name#" <cfif trim(oFormItem.validateErrorMessage) gt 0>title="#oFormItem.validateErrorMessage#"</cfif> type="radio" class="radio" value="#oFormItem.initValue#"#thisCssID# <cfif oFormItem.initValue is 1>checked</cfif> />
					</cfoutput>
				</cfcase>
				<cfcase value="list">
					<cfoutput>
					<select <cfif trim(oFormItem.validateErrorMessage) gt 0>title="#oFormItem.validateErrorMessage#"</cfif> name="#oFormItem.objectid#"#thisCssID#>
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
					<input <cfif trim(oFormItem.validateErrorMessage) gt 0>title="#oFormItem.validateErrorMessage#"</cfif> name="#oFormItem.objectid#" type="file" class="file"#thisCssID# />
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
			<!--- 	
					We use a </form> tag instead of closing the <cf_cfJq_forms> tag due to error due to the FarCry 
					cfoutput placements.
					
					Therefor we must also include some other necasary code (the script bloc bellow).
			  --->
				  <cfif skipValidation eq false>
				  <script type="text/javascript"> 
					<cfif attributes.ajax>
						$(document).ready(function() { 
			    			var options = {
			    				target:'#attributes.target#',
								beforeSubmit: function(){
									$('#attributes.target#').empty();
									<cfif attributes.loadType eq "text">
										$('<span class="attributes.loading_class">#attributes.loadMsg#</span>').appendTo($('#attributes.target#'));
									<cfelseif attributes.loadType eq "img">	
										$('<img class="attributes.loading_class" src="#attributes.loadMsg#"/>').appendTo($('#attributes.target#'));
									</cfif>	
								   }
								};  
			    			$(".#attributes.form_class#").validate({
								<cfif attributes.placeError eq "box">
								errorContainer: $(".messageBox#request.cfjq_form_progress#"),
			  					errorLabelContainer: $(".messageBox#request.cfjq_form_progress# ul"),
			  					wrapper: "li",
								</cfif>
			  					submitHandler: function(form) {
			  						$(form).ajaxSubmit(options);
			  						}
							});
						}); 
						<cfelse>
							$(document).ready(function(){
								<cfif attributes.placeError neq "box">
									$(".#attributes.form_class#").validate()
								<cfelse>
									$(".#attributes.form_class#").validate({
										errorContainer: $(".messageBox#request.cfjq_form_progress#"),
			  							errorLabelContainer: $(".messageBox#request.cfjq_form_progress# ul"),
			  							wrapper: "li"
										});
								</cfif>
							});
					</cfif>
				</script>
				</cfif>
			</cfoutput>
			
		</cfsavecontent>
	</cfif>

<cfelse>
	
	<!--- thistag.ExecutionMode is END --->
	<cfset thistag.GeneratedContent=tagoutput>

</cfif>

<cfsetting enablecfoutputonly="yes" />