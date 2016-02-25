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
<cfset stForm = application.fapi.getContentObject(objectID=attributes.objectID) />
<cfset bSelectReciever = false />
<cfset recieverFormID = "" />
<cfif structKeyExists(stForm, "aReceiverIDs") AND arrayLen(stForm.aReceiverIDs) GT 1 AND stForm.recieverOption IS "list">
	<cfset bSelectReciever = true />
	<cfset recieverFormID = "recievers" & replace(stForm.objectID, "-", "", "ALL") />
</cfif>


<cfif thistag.executionMode eq "Start">
	
	<!--- Generate FU for form action--->
	<cftry>
		<!--- check if object exist in site tree --->
		<cfscript>
			oNav = createObject("component",application.types['dmNavigation'].typepath);
			qNav = oNav.getParent(objectID=request.stObj.objectID);
		</cfscript>
		<cfif qNav.recordCount GT 0>
			<cfset linkToID = qNav.parentID />
		<cfelse>
			<cfset linkToID = request.stObj.objectID />
		</cfif>
		<!--- Set form action URL --->
		<cfset formActionURL = application.fapi.getLink(objectID=linkToID) />
		<cfcatch>
			<!--- if we catch an error, try with the furl in url scope --->
			<cfif structKeyExists(url, "furl") AND trim(url.furl) NEQ "">
				<cfset formActionURL = url.furl />
			<cfelseif structKeyExists(url, "objectID") AND isValid("UUID", url.objectID)>
				<cfset formActionURL = application.fapi.getLink(objectID=url.objectID) />
			</cfif>
		</cfcatch>
	</cftry>
	
	<cfif trim(attributes.class) is "">
		<cfset attributes.class = "idlform">
	</cfif>

	<cfif application.fapi.getconfig("idlform", "settings", "uniform") IS "uniform" AND (application.idlform.bIdlFormAlias IS true OR application.idlform.bIdlFormCopied IS true)>
		<skin:loadJs id="jquery" />
		<skin:loadJs id="uniformJS" />
		<skin:loadCss id="uniformCSS" />
		<skin:loadCss id="uniformTheme" />
		<skin:loadJs id="modernizrJS" />
		<skin:loadJs id="webshimJS" />
		<skin:loadCss id="idlformCSS" />
		<skin:onReady id="idlFormInline">
			<cfoutput>
				$j("form.idlform select, form.idlform input, form.idlform button, form.idlform textarea").uniform();
				$j("form.idlform input:file").uniform({fileBtnText: '#application.rb.getResource("idlform.buildform.uniform.fieldinput@label","Choose")#&hellip;'});
				$j("form.idlform input:file").uniform({fileDefaultText: '#application.rb.getResource("idlform.buildform.uniform.fieldinput@text","No file selected")#&hellip;'});
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
				$j("form.idlform").submit(function(evt) {
					var $btn = $j('form.idlform input:submit'),
						$wrapper = $btn.parent(),
						$uniformWrapper = $wrapper.parents('.button'),
						btnMarkup = getOuterHTML($btn[0]),
						defaultText = $btn.val(),
						newText = defaultText,
						animInterval,
						nFrame = 0;
						
					if($uniformWrapper.hasClass('disabled') === true) {
						evt.preventDefault();
					} else {
						$uniformWrapper.addClass('disabled');
						setTimeout(function () {
							$btn.prop('disabled', true);
						}, 50);
			
						setTimeout(function () {
							$uniformWrapper.removeClass('disabled');
							$wrapper.text(defaultText).append(btnMarkup);
							$btn.prop('disabled', false);
							clearInterval(animInterval);
						}, 3000);
			
						animInterval = setInterval(function () {
							newText = newText + '.';
						
							nFrame++;
						
							if (nFrame > 3) {
								newText = defaultText;
								nFrame = 0;
							}
							$wrapper.text(newText).append(btnMarkup);
							$btn.data('nFrame', nFrame);
						}, 250);
					}
					function getOuterHTML(el) {
						var wrapper = '';
						if(el) {
							var inner = el.innerHTML;
							var wrapper = '<' + el.tagName;

							for(var i = 0; i < el.attributes.length; i++) {
								wrapper += ' ' + el.attributes[i].nodeName + '="';
								wrapper += el.attributes[i].nodeValue + '"';
							}
							wrapper += '>' + inner + '</' + el.tagName + '>';
						}
						return wrapper;
					}
				});
			</cfoutput>
		</skin:onReady>
	</cfif>

	<!--- server side validation - In the future this should probably be moved to its own validate object --->
	<cfif StructKeyExists(form,"submitidlform") AND structKeyExists(form, "formObjectID") AND form.formObjectID EQ attributes.objectID>
		<!--- Loop through the form items --->
		<cfloop from="1" to="#arrayLen(attributes.aFormItems)#" index="i">
			<cftry>
				<!--- Get info about this item --->
				<cfset stObjFormItem = oFormItemService.getData(objectID=attributes.aFormItems[i]) />
				<cfset bFormDataValid = true />
			
				<!--- if the form is of type textfield or textarea we do the following validation --->
				<cfif stObjFormItem.type is "textfield" or stObjFormItem.type is "textarea">
					<!--- check if it is required --->
					<cfif (stObjFormItem.validateRequired is 1) and (len(trim(form[stObjFormItem.objectID])) is 0)>
						<cfset bFormDataValid = false />
					</cfif>
				
					<!--- validate digits --->
					<cfif stObjFormItem.validateType is "digits" or stObjFormItem.validateType is "number">
						<cfif (stObjFormItem.validateRequired is 0 AND len(trim(form[stObjFormItem.objectID])) GT 0)
						   OR (stObjFormItem.validateRequired is 1)>
							<!--- check if it has a minimum value --->
							<cfif (stObjFormItem.validateMinLength gt form[stObjFormItem.objectID] AND stObjFormItem.validateMinLength NEQ 0) AND IsNumeric(form[stObjFormItem.objectID])>
								<cfset bFormDataValid = false />
							</cfif>
							<!--- check if it has a maximum value --->
							<cfif (stObjFormItem.validateMaxLength lt form[stObjFormItem.objectID] AND stObjFormItem.validateMaxLength NEQ 0) AND IsNumeric(form[stObjFormItem.objectID])>
								<cfset bFormDataValid = false />
							</cfif>
						</cfif>
					<cfelse>
						<!--- validate string lengths --->
						<cfif (stObjFormItem.validateRequired is 0 AND len(trim(form[stObjFormItem.objectID])) GT 0)
						   OR (stObjFormItem.validateRequired is 1)>
							<!--- check if it has a minimum length --->
							<cfif IsNumeric(stObjFormItem.validateMinLength) and stObjFormItem.validateMinLength gt len(trim(form[stObjFormItem.objectID]))>
								<cfset bFormDataValid = false />
							</cfif>
							<!--- check if it has a maximum length --->
							<cfif IsNumeric(stObjFormItem.validateMaxLength) and stObjFormItem.validateMaxLength lt len(trim(form[stObjFormItem.objectID])) AND stObjFormItem.validateMaxLength NEQ 0>
								<cfset bFormDataValid = false />
							</cfif>
						</cfif>
					</cfif>
				
					<cfswitch expression="#stObjFormItem.validateType#">
						<cfcase value="digits">
							<cfif (not isValid("integer",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not isValid("integer",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset bFormDataValid = false />
							</cfif>
						</cfcase>
						<cfcase value="number">
							<cfif (not isValid("numeric",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not isValid("numeric",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset bFormDataValid = false />
							</cfif>
						</cfcase>
						<cfcase value="date">
							<cfif (not isValid("eurodate",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not isValid("eurodate",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset bFormDataValid = false />
							</cfif>
						</cfcase>
						<cfcase value="creditcard">
							<cfif (not isValid("creditcard",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not isValid("creditcard",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset bFormDataValid = false />
							</cfif>
						</cfcase>
						<cfcase value="url">
							<cfif (not isValid("URL",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not isValid("URL",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset bFormDataValid = false />
							</cfif>
						</cfcase>
						<cfcase value="email">
							<cfif (not isValid("email",form[stObjFormItem.objectID]) AND stObjFormItem.validateRequired is 1) OR (not isValid("email",form[stObjFormItem.objectID]) AND len(trim(form[stObjFormItem.objectID])) GT 0)>
								<cfset bFormDataValid = false />
							</cfif>
						</cfcase>
					</cfswitch>
				</cfif>
			
				<!--- if the form is of type checkbox or radiobutton we do the following validation --->
				<cfif stObjFormItem.type is "checkbox" or stObjFormItem.type is "radiobutton">
					<!--- No validation here - at least for now --->
				</cfif>
			
				<cfif NOT bFormDataValid>
					<!--- add info to the error message --->
					<cfset errorMessage = Insert("<span class='label'>#stObjFormItem.label#:</span> <span class='errortext'>#stObjFormItem.validateErrorMessage#</span><br />", errorMessage, Len(errorMessage)) />
				</cfif>
			
				<cfcatch>
					<cfif stObjFormItem.validateRequired IS 1>
						<cfset errorMessage = Insert("<span class='label'>#stObjFormItem.label#:</span> <span class='errortext'>#stObjFormItem.validateErrorMessage#</span><br />", errorMessage, Len(errorMessage)) />
					</cfif>
				</cfcatch>
			</cftry>
		</cfloop>

		<cfif application.fapi.getconfig("idlform", "recaptchaSiteKey", "") NEQ "">
			<cfhttp url="https://www.google.com/recaptcha/api/siteverify" method="post" result="recaptchaResponse">
				<cfhttpparam type="formfield" name="response" value="#form['G-RECAPTCHA-RESPONSE']#" />
				<cfhttpparam type="formfield" name="secret" value="#trim(application.fapi.getconfig("idlform", "recaptchaSecret"))#" />
			</cfhttp>
			<cfset validationSuccess = DeserializeJSON(recaptchaResponse.fileContent).success />
			<cfif validationSuccess IS false>
				<cfset bFormDataValid = false />
				<cfset errorMessage = Insert("<span class='label'>reCAPTCHA</span> <span class='errortext'>#application.fapi.getconfig("idlform", "recaptchaError")#</span><br />", errorMessage, Len(errorMessage)) />
			</cfif>
		</cfif>
		
	</cfif>
	
	<!--- check if form is submitted and validation passed --->
	<cfif StructKeyExists(form,"submitidlform") AND structKeyExists(form, "formObjectID") AND form.formObjectID EQ attributes.objectID AND Len(errormessage) is 0>
		
		<!--- send the content of the submited form by e-mail --->
		<cfset stSubmitForm = createObject("component", application.stCoapi.idlForm.packagepath).submit(objectID=#attributes.objectID#,formData=#form#) />
		<cfset session.stSubmitForm = stSubmitForm />
		
		<cfif stSubmitForm.bSuccess is true>
			<cflocation url="#formActionURL#?bFormSaved=true&formObjectID=#attributes.objectID####attributes.id#" addtoken="false" />
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

	<cfelseif structkeyexists(url, "bFormSaved") AND structKeyExists(url, "formObjectID") AND url.formObjectID EQ attributes.objectID>
		
		<!--- Form is saved --->
		<cfsavecontent variable="tagoutput">
			<!--- confirmation: respons to the user  --->
			<cfoutput>
				<div class="idlConfirmation idl-form-wrapper">
					#attributes.sendtText#
				</div>
			</cfoutput>
		</cfsavecontent>
		
	<cfelse>
		
		<cfoutput>
			<div class="idlform-form-wrapper">
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
			<!--- output recievers --->
			<cfif trim(stForm.userSelectRecieverLabel) NEQ "">
				<cfset userSelectRecieverLabelText = stForm.userSelectRecieverLabel />
			<cfelse>
				<cfset userSelectRecieverLabelText = application.rb.getResource("idlform.buildform.messages.userSelectRecieverLabelText@text","Select reciever") />
			</cfif>
			
			<cfif bSelectReciever>
				<cfoutput>
					<fieldset class="fieldset-textfield w100percent">
						<label for="#recieverFormID#" class="textfield">#userSelectRecieverLabelText#</label>
						<select id="#recieverFormID#" name="#recieverFormID#">
							</cfoutput>
						
							<cfloop index="i" to="#arrayLen(stForm.aReceiverIDs)#" from="1">
								<cfset stTmpReceiver = application.fapi.getContentObject(objectID=stForm.aReceiverIDs[i]) />
								<cfif trim(stTmpReceiver.email) NEQ "">
									<cfoutput><option value="#stTmpReceiver.objectID#">#stTmpReceiver.label#</option></cfoutput>
								</cfif>
							</cfloop>
						
							<cfoutput>
						</select>
						<div class="clear"></div>
					</fieldset>
				</cfoutput>
			</cfif>
			
			
			<!--- loop over items --->
			<cfloop from="1" to="#arrayLen(attributes.aFormItems)#" index="i">
			
				<!--- get formitem data --->
				<cfset stObjFormItem = oFormItemService.getData(objectID=attributes.aFormItems[i])>
			
				<cfif stObjFormItem.type neq "hidden">
					<!--- Add classes --->
					<cfset fieldsetClasses = "" />
					<cfset fieldsetClasses = listAppend(fieldsetClasses, "fieldset-" & stObjFormItem.type, " ") />
					<cfif trim(stObjFormItem.width) EQ "">
						<cfset fieldsetClasses = listAppend(fieldsetClasses, "w100percent", " ") />
					<cfelse>
						<cfset fieldsetClasses = listAppend(fieldsetClasses, trim(stObjFormItem.width), " ") />
					</cfif>
					<cfif trim(stObjFormItem.class) NEQ "">
						<cfset fieldsetClasses = listAppend(fieldsetClasses, trim(stObjFormItem.class), " ") />
					</cfif>
					
					<cfoutput><fieldset class="#fieldsetClasses#"></cfoutput>
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
					
					<cfset minLength = "" />
					<cfset maxLength = "" />
					<cfif IsNumeric(stObjFormItem.validateMinLength)>
						<cfif (stObjFormItem.validateType is "digits") or (stObjFormItem.validateType is "number")>
							<cfset validationRule = validationRule & ' min="#stObjFormItem.validateMinLength#"'>
						<cfelse>
							<cfif stObjFormItem.validateMinLength NEQ 0>
								<cfset minLength = stObjFormItem.validateMinLength />
							</cfif>
						</cfif>
					</cfif>
				
					<cfif IsNumeric(stObjFormItem.validateMaxLength)>
						<cfif (stObjFormItem.validateType is "digits") or (stObjFormItem.validateType is "number")>
							<cfset validationRule = validationRule & ' max="#stObjFormItem.validateMaxLength#"'>
						<cfelse>
							<cfif stObjFormItem.validateMaxLength NEQ 0>
								<cfset maxLength = stObjFormItem.validateMaxLength />
								<!--- <cfset validationRule = validationRule & ' maxlength="#stObjFormItem.validateMaxLength#"'> --->
							</cfif>
						</cfif>
					</cfif>
					
					<cfif (stObjFormItem.validateType NEQ "digits") AND (stObjFormItem.validateType NEQ "number") AND (IsNumeric(minLength) OR IsNumeric(maxLength))>
						<cfif stObjFormItem.type IS "textarea">
							<cfset validationRule = validationRule & ' cols="#minLength#" maxlength="#maxLength#"'>
						<cfelse>
							<cfif minLength IS "">
								<cfset minLength = 0 />
							</cfif>
							<cfset validationRule = validationRule & ' pattern=".{#minLength#,#maxLength#}"'>
						</cfif>
					</cfif>
					
				</cfif>
				
				<cfset validationMessageAttributes = "" />
				<cfif trim(stObjFormItem.validateErrorMessage) gt 0>
					<cfset validationMessageAttributes = 'title="#stObjFormItem.validateErrorMessage#" x-moz-errormessage="#stObjFormItem.validateErrorMessage#"' />
				</cfif>
			
								
				<!--- display (or not) label --->
				<cfif not ListFind(noLabel,stObjFormItem.type)>
					<cfsavecontent variable="labelMarkup">
						<cfoutput><label for="#stObjFormItem.objectID#" class="#stObjFormItem.type#"></cfoutput>
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
				<cfif structKeyExists(form, stObjFormItem.objectID)>
					<cfset thisvalue = form[stObjFormItem.objectID] />
				<cfelseif left(stObjFormItem.initValue, "1") is "##" and right(stObjFormItem.initValue, "1") is "##">
					<cfset thisvalue = xmlformat(Evaluate(stObjFormItem.initValue)) />
				<cfelse>
					<cfset thisvalue = stObjFormItem.initValue />
				</cfif>
			
				<cfswitch expression="#stObjFormItem.type#">
					<cfcase value="textfield">
						 <cfoutput>
							#labelMarkup#
							<input id="#stObjFormItem.objectID#" name="#stObjFormItem.objectID#" #validationRule# <cfif trim(stObjFormItem.placeholder) gt 0>placeholder="#stObjFormItem.placeholder#"</cfif> #validationMessageAttributes# type="text" class="text" value="#thisvalue#"#thisCssID# tabindex="#1000+i#" />
						</cfoutput>
					</cfcase>
					<cfcase value="textarea">
						<cfoutput>
							#labelMarkup#
							<textarea id="#stObjFormItem.objectID#" name="#stObjFormItem.objectID#" #validationRule# <cfif trim(stObjFormItem.placeholder) gt 0>placeholder="#stObjFormItem.placeholder#"</cfif> #validationMessageAttributes# wrap="virtual" class="uniform"#thisCssID# tabindex="#1000+i#">#thisvalue#</textarea>
						</cfoutput>
					</cfcase>
				
					<cfcase value="checkbox">
						<cfoutput>
							<input id="#stObjFormItem.objectID#" name="#stObjFormItem.objectID#" #validationRule# type="checkbox" 
								#validationMessageAttributes#
								class="checkbox" value="X"#thisCssID#
								<cfif structKeyExists(form, stObjFormItem.objectID)>
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
							<input id="#stObjFormItem.objectID#"
								<cfif Trim(stObjFormItem.name) is "">name="#stObjFormItem.objectID#"<cfelse>name="#stObjFormItem.name#"</cfif>
								#validationMessageAttributes#
								type="radio" class="radio" value="#stObjFormItem.objectID#"#thisCssID#
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
							<select id="#stObjFormItem.objectID#" #validationRule# <cfif trim(stObjFormItem.validateErrorMessage) gt 0>title="#stObjFormItem.validateErrorMessage#" x-moz-errormessage="#stObjFormItem.validateErrorMessage#"</cfif> name="#stObjFormItem.objectID#"#thisCssID# tabindex="#1000+i#">
						</cfoutput>
						
						<cfif stObjFormItem.validateRequired is true>
							<cfoutput>
								<option value=""></option>
							</cfoutput>
						</cfif>
						
						<cfloop list="#stObjFormItem.initValue#" index="i">
							<cfoutput>
								<option value="#i#"<cfif thisvalue EQ i> selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					
						<cfoutput>
							</select>
						</cfoutput>
					</cfcase>
					<cfcase value="filefield">
						<cfoutput>
							#labelMarkup#
							<input id="#stObjFormItem.objectID#" #validationRule# #validationMessageAttributes# name="#stObjFormItem.objectID#" type="file" class="file"#thisCssID# tabindex="#1000+i#" />
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
							<!--- Hidden fields should never be changed by form scope --->
							<cfif Left(stObjFormItem.initValue, "1") is "##" and Right(stObjFormItem.initValue, "1") is "##">
								<cfset thisvalue = #xmlformat(Evaluate(stObjFormItem.initValue))#>
							<cfelse>
								<cfset thisvalue = stObjFormItem.initValue>
							</cfif>
							<input type="hidden" name="#stObjFormItem.objectID#" value="#thisvalue#" />
						</cfoutput>
					</cfcase>
				</cfswitch>
			
				<cfif stObjFormItem.type neq "hidden">
					<cfoutput></fieldset></cfoutput>
					<cfif stObjFormItem.linebreak is 1><cfoutput><div class="clear"></div></cfoutput></cfif>
				</cfif>
			</cfloop>

			<!--- recaptcha --->
			<cfif application.fapi.getconfig("idlform", "recaptchaSiteKey", "") NEQ "">
				<cfoutput>
					<script src="https://www.google.com/recaptcha/api.js?hl=#application.fapi.getconfig('idlform', 'recaptchaLanguage', '')#" async defer></script>
					<div class="g-recaptcha" data-sitekey="#trim(application.fapi.getconfig("idlform", "recaptchaSiteKey"))#" data-theme="#application.fapi.getconfig("idlform", "recaptchaTheme", "light")#"  ></div>
				</cfoutput>
			</cfif>
			
			<cfoutput>
				<input type="hidden" name="formObjectID" value="#attributes.objectID#" />
				<label for="submitidlform" class="submit">&nbsp;</label>
				<input type="submit" class="submit" value="#attributes.submittext#" name="submitidlform" />
			</form>
				  
			</cfoutput>
			
			<!--- Close .idlform-form-wrapper --->
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