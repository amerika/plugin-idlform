<cfsetting enablecfoutputonly="yes" />
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
<!--- @@description: This template will attemt to use the cfjq_forms custom tag for form client side validation services.
					 Should the custom tag not be installed on the server the template will run like a normal attributes.placeError form without any validation. --->
<!--- @@author: Trond Ulseth (trond@idl.no) & Jørgen M. Skogås (jorgen@idl.no) --->

<!--- import libs --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- load jquery, js scripts and css --->
<skin:loadJs id="jquery" />
<skin:loadCss id="jquery-ui" />

<cfparam name="attributes.objectID" default="" />	<!--- The objectID of the form --->
<cfparam name="attributes.formInfo" default="" /> 	<!--- The form info text --->
<cfparam name="attributes.sendtText" default="" /> 	<!--- The form sendt text --->
<cfparam name="attributes.submitText" default="" />	<!--- The text in the submitbutton --->
<cfparam name="attributes.aFormItems" default="" />	<!--- The array with formitems objectIDs --->
<cfparam name="attributes.class" default="" />		<!--- form tags class --->
<cfparam name="attributes.id" default="ID#replace(attributes.objectID, '-', '', 'ALL')#" />			<!--- form tags id --->

<!--- For validation: --->
<cfparam name="skipValidation" default="false" />
<cfparam name="errormessage" default="" />
	
<cfset oFormItemService = createObject("component", application.stCoapi.idlFormItem.packagepath) />

<cfif thistag.executionMode eq "Start">

	<!--- check if object exist in site tree --->
	<cfscript>
		oNav = createObject("component",application.types['dmNavigation'].typepath);
		qNav = oNav.getParent(objectid=request.stObj.objectID);
	</cfscript>
	<cfif qNav.recordCount GT 0>
		<cfset linkToID = qNav.parentID />
	<cfelse>
		<cfset linkToID = request.stObj.objectID />
	</cfif>

	<!--- Set form action URL --->
	<cfset formActionURL = #application.fapi.getLink(objectID=linkToID)# />
	
	<cfif trim(attributes.class) is "">
		<cfset attributes.class = "idlform">
	</cfif>

	<cfif application.fapi.isLoggedIn() AND (NOT application.idlform.bIdlFormCopied AND NOT application.idlform.bIdlFormAlias)>
		<skin:bubble title="IDLmedia Form Plugin" sticky="true">
			<cfoutput>#application.rb.getResource("idlform.buildform.messages.checkJsCss@text","You need to make an virtual directory in your webserver or copy the js and css into the project for the idlform plugin to work.")#</cfoutput>
		</skin:bubble>
	<cfelse>
		<skin:loadJs id="uniformJS" />
		<skin:loadCss id="uniformCSS" />
		<skin:loadCss id="uniformTheme" />
		<skin:loadJs id="modernizrJS" />
		<skin:loadJs id="webshimJS" />
		<skin:loadCss id="idlformCSS" />
		<skin:onReady id="idlFormInline">
			<cfoutput>
				$j("form.idlform select, form.idlform input, form.idlform button, form.idlform textarea").uniform2();
				$j("form.idlform input:file").uniform2({fileBtnText: '#application.rb.getResource("idlform.buildform.uniform.fieldinput@label","Choose")#&hellip;'});
				$j("form.idlform input:file").uniform2({fileDefaultText: '#application.rb.getResource("idlform.buildform.uniform.fieldinput@text","No file selected")#&hellip;'});
				$j.webshims.setOptions("waitReady",false);
				<cfif application.idlform.bIdlFormAlias>
					$j.webshims.setOptions("basePath", "/idlform/js/js-webshim/dev/shims/");
				<cfelse>	
					$j.webshims.setOptions("basePath", "/js/js-webshim/dev/shims/");
				</cfif>
				
				//The following to lines can be uncomented to accomodate translations of the webshim validation error messages. But if you set validation messages on the form element in the webtop this should not be necasarry
				// $j.webshims.activeLang('no');
				// $j.webshims.cfg.forms.availabeLangs.push('no');

				$j.webshims.setOptions('forms', {customMessages: true});
				
				$j.webshims.polyfill();

				$j(function(){
					$j('form.idlform')
						.bind('invalid', function(e){
							e.preventDefault();
						})
						.bind('firstinvalid', function(e){
							$j.webshims.validityAlert.showFor(e.target, $j.attr(e.target, 'customValidationMessage'));
							return false;
						})
					;
				});
			</cfoutput>
		</skin:onReady>
	</cfif>

	<!--- server side validation - In the future this should probably be moved to its own validate object --->
	<cfif StructKeyExists(form,"submitidlform")>

			<!--- Loop through the form items --->
			<cfloop from="1" to="#arrayLen(attributes.aFormItems)#" index="i">
				
				<!--- Get info about this item --->
				<cfset stObjFormItem = oFormItemService.getData(objectID=attributes.aFormItems[i])>

				<cfset isValid = true>
				
				<!--- if the form is of type textfield or textarea we do the following validation --->
				<cfif stObjFormItem.type is "textfield" or stObjFormItem.type is "textarea">
					
					<!--- check if it is required --->
					<cfif (stObjFormItem.validateRequired is 1) and (len(trim(form[stObjFormItem.objectID])) is 0)>
						<cfset isValid = false>
					</cfif>
					
					<!--- validate digits --->
					<cfif stObjFormItem.validateType is "digits" or stObjFormItem.validateType is "number">
						<cfif (stObjFormItem.validateRequired is 0 AND len(trim(form[stObjFormItem.objectID])) GT 0)
						   OR (stObjFormItem.validateRequired is 1)>
							<!--- check if it has a minimum value --->
							<cfif (stObjFormItem.validateMinLength gt form[stObjFormItem.objectID] AND stObjFormItem.validateMinLength NEQ 0) AND IsNumeric(form[stObjFormItem.objectID])>
								<cfset isValid = false>
							</cfif>
							<!--- check if it has a maximum value --->
							<cfif (stObjFormItem.validateMaxLength lt form[stObjFormItem.objectID] AND stObjFormItem.validateMaxLength NEQ 0) AND IsNumeric(form[stObjFormItem.objectID])>
								<cfset isValid = false>
							</cfif>
						</cfif>
					<cfelse>
					<!--- validate string lengths --->
						<cfif (stObjFormItem.validateRequired is 0 AND len(trim(form[stObjFormItem.objectID])) GT 0)
						   OR (stObjFormItem.validateRequired is 1)>
							<!--- check if it has a minimum length --->
							<cfif IsNumeric(stObjFormItem.validateMinLength) and stObjFormItem.validateMinLength gt len(trim(form[stObjFormItem.objectID]))>
								<cfset isValid = false>
							</cfif>
							<!--- check if it has a maximum length --->
							<cfif IsNumeric(stObjFormItem.validateMaxLength) and stObjFormItem.validateMaxLength lt len(trim(form[stObjFormItem.objectID])) AND stObjFormItem.validateMaxLength NEQ 0>
								<cfset isValid = false>
							</cfif>
						</cfif>
					</cfif>
					
					<cfswitch expression="#stObjFormItem.validateType#">
						<cfcase value="digits">
							<cfif (not IsValid("integer",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("integer",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="number">
							<cfif (not IsValid("numeric",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("numeric",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="date">
							<cfif (not IsValid("eurodate",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("eurodate",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="creditcard">
							<cfif (not IsValid("creditcard",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("creditcard",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="url">
							<cfif (not IsValid("URL",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("URL",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
						
						<cfcase value="email">
							<cfif (not IsValid("email",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not IsValid("email",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset isValid = false>
							</cfif>
						</cfcase>
					</cfswitch>
				</cfif>
				
				<!--- if the form is of type checkbox or radiobutton we do the following validation --->
				<cfif stObjFormItem.type is "checkbox" or stObjFormItem.type is "radiobutton">
					<!--- No validation here - at least for now --->
				</cfif>
				
				<cfif NOT isValid>
					<!--- add info to the error message --->
					<cfset errorMessage = Insert("<span class='label'>#stObjFormItem.label#:</span> <span class='errortext'>#stObjFormItem.validateErrorMessage#</span><br />", errorMessage, Len(errorMessage))>
				</cfif>
				
			</cfloop>
			
	</cfif>
	
	<!--- check if form is submitted and validation passed --->
	<cfif StructKeyExists(form,"submitidlform") and Len(errormessage) is 0>
		
		<!--- send the content of the submited form by e-mail --->
		
		<cfset stSubmitForm = createObject("component", application.stCoapi.idlForm.packagepath).submit(objectID=#attributes.objectID#,formData=#form#) />
		<cfset session.stSubmitForm = stSubmitForm />
		
		<cfif stSubmitForm.bSuccess is true>
			<cflocation url="#formActionURL#?bFormSaved=true###attributes.id#" addtoken="false" />
		<cfelse>
			<!--- Here we output if something went wrong - the different messages have not been througly tested yet --->
			<cfoutput>
				<p>#application.rb.getResource("idlform.buildform.errorhandling@label","Something went wrong")#:</p>
				<p>
					#application.rb.getResource("idlform.buildform.errorhandling@text","Message")#:<br/>
					#stSubmitForm.message#
				</p>
			</cfoutput>
		</cfif>

	<cfelseif structkeyexists(url, "bFormSaved")>
		
		<!--- Form is saved --->
		<cfsavecontent variable="tagoutput">
			<!--- confirmation: respons to the user  --->
			<cfoutput>
				<div id="#attributes.id#" class="idlConfirmation">
					#attributes.sendtText#
				</div>
			</cfoutput>
		</cfsavecontent>
		
	<cfelse>
		
		<cfoutput>
			<div id="#attributes.id#">
		</cfoutput>
	
		<cfif Len(errormessage) gt 0>
			<cfoutput>
				<div class="idlform_errorMessage">
					#errorMessage#
				</div>
			</cfoutput>
		</cfif>

		<!--- 	set comma delimeted list with input types which should not have a label - 
				hidden should ALWAYS be in this list  --->
		<cfset noLabel = "hidden,statictext">
		
		<cfoutput>
			<cfif trim(attributes.formInfo) NEQ "">
				<div class="idlFormInfo">#attributes.formInfo#</div>
			</cfif>
			
			<form action="#formActionURL####attributes.id#" method="post" enctype="multipart/form-data" name="idlform" class="#attributes.class#">

		</cfoutput>
		
		<cfsavecontent variable="tagoutput">
		<!--- loop over items --->
			<cfloop from="1" to="#arrayLen(attributes.aFormItems)#" index="i">
			
				<!--- get formitem data --->
				<cfset stObjFormItem = oFormItemService.getData(objectID=attributes.aFormItems[i])>
			
				<cfif stObjFormItem.type neq "hidden">
				
					<!--- Add classes --->
					<cfsavecontent variable="fieldsetClasses">
						<cfif trim(stObjFormItem.width) NEQ "" OR trim(stObjFormItem.class) NEQ "">
	
							<cfoutput> class="</cfoutput> <!--- Start class --->
							
								<cfoutput><cfif trim(stObjFormItem.width) EQ "">w100percent<cfelse>#trim(stObjFormItem.width)#</cfif> </cfoutput>
							
								<cfif trim(stObjFormItem.class) NEQ "">
									<cfoutput>#trim(stObjFormItem.class)#</cfoutput>
								</cfif>
							
							<cfoutput>" </cfoutput> <!--- End class --->
						</cfif>
					
					</cfsavecontent>
					
					<cfoutput>#"<fieldset" & fieldsetClasses & ">"#</cfoutput>
				
				</cfif>
			
				<!--- create validation rule --->
				<cfset validationRule = "">
			
				<cfif skipValidation eq false>
			
					<cfif stObjFormItem.validateRequired is true>
						<cfset validationRule = validationRule & 'required="required"'>
					</cfif>
				
					<cfswitch expression="#stObjFormItem.validateType#">
						<cfcase value="url">
							<cfset validationRule = validationRule & ' type="url"'>
						</cfcase>
						<cfcase value="email">
							<cfset validationRule = validationRule & ' type="email"'>
						</cfcase>
						<cfcase value="date">
							<cfset validationRule = validationRule & ' type="date"'>
						</cfcase>
						<!--- 
						<cfcase value="creditcard">
							<cfset validationRule = validationRule & ' pattern="[0-9]{13,16}"'>
						</cfcase>
						<cfcase value="digits">
							<cfset validationRule = validationRule & ' pattern="[0-9]{0,200}"'>
						</cfcase> 
						--->
						<cfcase value="number">
							<cfset validationRule = validationRule & ' type="number"'>
						</cfcase>
					</cfswitch>
				
					<cfif IsNumeric(stObjFormItem.validateMinLength)>
						<cfif (stObjFormItem.validateType is "digits") or (stObjFormItem.validateType is "number")>
							<cfset validationRule = validationRule & ' min="#stObjFormItem.validateMinLength#"'>
						<cfelse>
							<cfif stObjFormItem.validateMinLength NEQ 0 AND stObjFormItem.validateMaxLength NEQ 0>
								<cfset validationRule = validationRule & ' pattern=".{#stObjFormItem.validateMinLength#,}"'>
							</cfif>
						</cfif>
					</cfif>
				
					<cfif IsNumeric(stObjFormItem.validateMaxLength) >
						<cfif (stObjFormItem.validateType is "digits") or (stObjFormItem.validateType is "number")>
							<cfset validationRule = validationRule & ' min="#stObjFormItem.validateMinLength#"'>
						<cfelse>
							<cfif stObjFormItem.validateMinLength NEQ 0 AND stObjFormItem.validateMaxLength NEQ 0>
								<cfset validationRule = validationRule & ' maxlength="#stObjFormItem.validateMaxLength#"'>
							</cfif>
						</cfif>
					</cfif>
				
				</cfif>
			
								
				<!--- display (or not) label --->
				<cfif not ListFind(noLabel,stObjFormItem.type)>
					<cfsavecontent variable="labelMarkup">
						<cfoutput><label for="#stObjFormItem.objectid#" class="#stObjFormItem.type#"></cfoutput>
						<cfif Len(trim(stObjFormItem.title))>
							<cfif stObjFormItem.validateRequired is true>
								<cfoutput>#stObjFormItem.title#&nbsp;<span class="required">*</span></cfoutput>
							<cfelse>
								<cfoutput>#stObjFormItem.title#</cfoutput>
							</cfif>
						</cfif>
						<cfoutput></label></cfoutput>
					</cfsavecontent>
				<cfelse>
					<cfset labelMarkup = "" />
				</cfif>
			
				<cfif stObjFormItem.type NEQ "hidden" AND stObjFormItem.cssID NEQ "">
					<cfset thisCssID = ' id="#stObjFormItem.cssID#"' />
				<cfelse>
					<cfset thisCssID = "" />
				</cfif>
			
				<!--- Set initial value or if the form has been submitet set the initial value to form item value --->
				<cfif StructKeyExists(form, "#stObjFormItem.objectid#")>
					<cfset initValue = form[stObjFormItem.objectid] />
				<cfelse>
					<cfset initValue = stObjFormItem.initValue />
				</cfif>
			
				<cfswitch expression="#stObjFormItem.type#">
					<cfcase value="textfield">
						<cfif Left(stObjFormItem.initValue, "1") is "##" and Right(stObjFormItem.initValue, "1") is "##">
							<cfset initValue = #xmlformat(Evaluate(stObjFormItem.initValue))#>
						</cfif>
						 <cfoutput>
							#labelMarkup#
							<input id="#stObjFormItem.objectid#" name="#stObjFormItem.objectid#" #validationRule# <cfif trim(stObjFormItem.placeholder) gt 0>placeholder="#stObjFormItem.placeholder#"</cfif> <cfif trim(stObjFormItem.validateErrorMessage) gt 0>x-moz-errormessage="#stObjFormItem.validateErrorMessage#"</cfif> type="text" class="text" value="#initValue#" #thisCssID# tabindex="#1000+i#" />
						</cfoutput>
					</cfcase>
					<cfcase value="textarea">
						<cfif Left(stObjFormItem.initValue, "1") is "##" and Right(stObjFormItem.initValue, "1") is "##">
							<cfset initValue = #xmlformat(Evaluate(stObjFormItem.initValue))#>
						</cfif>
						<cfoutput>
							#labelMarkup#
							<textarea id="#stObjFormItem.objectid#" name="#stObjFormItem.objectid#" #validationRule# <cfif trim(stObjFormItem.placeholder) gt 0>placeholder="#stObjFormItem.placeholder#"</cfif> <cfif trim(stObjFormItem.validateErrorMessage) gt 0>x-moz-errormessage="#stObjFormItem.validateErrorMessage#"</cfif> wrap="virtual" class="uniform"#thisCssID# tabindex="#1000+i#">#initValue#</textarea>
						</cfoutput>
					</cfcase>
				
					<cfcase value="checkbox">
						<cfoutput>
							<!--- <input name="#stObjFormItem.name#" type="checkbox" <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#"</cfif> class="checkbox" value="#stObjFormItem.initValue#"#thisCssID# <cfif initValue is 1>checked</cfif> /> --->
							<input id="#stObjFormItem.objectid#" name="#stObjFormItem.objectid#" #validationRule# type="checkbox" 
								<cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#" x-moz-errormessage="#stObjFormItem.validateErrorMessage#"</cfif>
								class="checkbox" value="X"#thisCssID#
								<cfif structKeyExists(form, stObjFormItem.objectid)>
									checked 
								<cfelseif stObjFormItem.initValue is 1>
									checked 
								</cfif>
								tabindex="#1000+i#"
							/>
							#labelMarkup#
						</cfoutput>
					</cfcase>


					<cfcase value="radiobutton">
						<cfoutput>
							<!--- <input name="#stObjFormItem.name#" <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#"</cfif> type="radio" class="radio" value="#stObjFormItem.initValue#"#thisCssID# <cfif initValue is 1>checked</cfif> /> --->
							<input id="#stObjFormItem.objectid#"
								<cfif Trim(stObjFormItem.name) is "">name="#stObjFormItem.objectID#"<cfelse>name="#stObjFormItem.name#"</cfif><!--- TODO: Trond, er denne logikken sjekket? Viktig at den også fungerer slik at det valgt radiobutton huskes på valideringsiden, altså etter submit. --->
								<cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#" x-moz-errormessage="#stObjFormItem.validateErrorMessage#"</cfif> type="radio" class="radio" value="#stObjFormItem.objectID#"#thisCssID#
								<cfif structkeyexists(form, stObjFormItem.name) AND form[stObjFormItem.name] EQ stObjFormItem.objectID>
									checked 
								<cfelseif not structkeyexists(form, stObjFormItem.name)>
									<cfif stObjFormItem.initValue is 1>checked </cfif>
								</cfif>
								tabindex="#1000+i#"
							/>
							#labelMarkup#
						</cfoutput>
					</cfcase>


					<cfcase value="list">
						<cfoutput>
							#labelMarkup#
							<select id="#stObjFormItem.objectid#" <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#" x-moz-errormessage="#stObjFormItem.validateErrorMessage#"</cfif> name="#stObjFormItem.objectid#"#thisCssID# tabindex="#1000+i#">
						</cfoutput>
					
						<cfloop list="#stObjFormItem.initValue#" index="i">
							<cfoutput>
								<option value="#i#"<cfif initValue EQ i> selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					
						<cfoutput>
							</select>
						</cfoutput>
					</cfcase>
					<cfcase value="filefield">
						<cfoutput>
							#labelMarkup#
							<input id="#stObjFormItem.objectid#" #validationRule# <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#" x-moz-errormessage="#stObjFormItem.validateErrorMessage#"</cfif> name="#stObjFormItem.objectid#" type="file" class="file"#thisCssID# tabindex="#1000+i#" />
						</cfoutput>
					</cfcase>
					<cfcase value="statictext">
						<cfoutput>
							#labelMarkup#
							<cfif Len(trim(stObjFormItem.title))><h2>#stObjFormItem.title#</h2></cfif>
							<span class="statictext">#stObjFormItem.initValue#</span>
						</cfoutput>
					</cfcase>
					<cfcase value="hidden">
						<cfoutput>
							#labelMarkup#
							<cfif Left(stObjFormItem.initValue, "1") is "##" and Right(stObjFormItem.initValue, "1") is "##">
								<cfset thisvalue = #xmlformat(Evaluate(stObjFormItem.initValue))#>
							<cfelse>
								<cfset thisvalue = stObjFormItem.initValue>
							</cfif>
							<input type="hidden" name="#stObjFormItem.objectid#" value="#thisvalue#" />
						</cfoutput>
					</cfcase>
				</cfswitch>
			
				<cfif stObjFormItem.type neq "hidden">
					<cfoutput></fieldset></cfoutput>
					<cfif stObjFormItem.linebreak is 1><cfoutput><div class="clear"></div></cfoutput></cfif>
				</cfif>
			</cfloop>
			
			<cfoutput>
				<label for="submitidlform" class="submit">&nbsp;</label>
				<input type="submit" class="submit" value="#attributes.submittext#" name="submitidlform" />
			</form>
				  
			</cfoutput>
			
			<!--- Close attributes.id div --->
			<cfoutput>
				</div>
			</cfoutput>
		</cfsavecontent>
	</cfif>
<cfelse>
	
	<!--- thistag.ExecutionMode is END --->
	<cfset thistag.GeneratedContent=tagoutput>

</cfif>

<cfsetting enablecfoutputonly="yes" />