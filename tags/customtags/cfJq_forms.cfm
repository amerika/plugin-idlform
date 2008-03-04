<!---
 * CFJQ_FORMS - COLD FUSION CTAG FORMS
 * 
 * @requires jQuery v1.2.1 and CFMX7+
 *
 * http://www.andreafm.com
 *
 * Copyright (c) 2007 Andrea Campolonghi (andreacfm.com)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * Check the jquery.validate.js, jquery.forms.js, jquery.metadata.js file for Plug-in license and permissions
 * Version:2.0
---->
<cfif thisTag.executionMode eq "start">
<cfparam name="attributes.form_class" type="string" default="cfjq_form"/>
<cfparam name="attributes.action" type="string" default=""/>
<cfparam name="attributes.method" type="string" default="get"/>
<cfparam name="attributes.css_class" type="string" default=""/>
<cfparam name="attributes.id" type="string" default=""/>
<cfparam name="attributes.enctype" type="string" default="">
<cfparam name="attributes.target" type="string" default=".cfjq_form_target"/>
<cfparam name="attributes.ajax" type="boolean" default="false"/>
<cfparam name="attributes.placeError" type="string" default="inline"/><!----if "box" validation error message will be placed in a box over the form--->
<cfparam name="attributes.jqFolder" type="string" default="">
<cfparam name="attributes.loadType" type="string" default="text">
<cfparam name="attributes.loadMsg" type="string" default="Loading...">
<cfparam name="attributes.loading_class" type="string" default="cfjq_loading">


<cfoutput>
	<!---load jquery only once//work also with other cfjq custom tags---->
	<cfif not structKeyExists(request, "cfjq")>	
		<cfhtmlhead text='<script type="text/javascript" src="#attributes.jqFolder#/jquery.latest.js"></script>'>
		<cfset request.cfjq =1>
	</cfif>
	<!---load jquery forms plug in only once if required---->
	<cfif not structKeyExists(request, "cfjq_form")>
		<cfif attributes.ajax eq "true">
			<cfhtmlhead text='<script type="text/javascript" src="#attributes.jqFolder#/jquery.form.js"></script>'>
			<cfset request.cfjq_form =1>
		</cfif>	
	</cfif>
	<!---load jquery validate plug in only once---->
	<cfif not structKeyExists(request, "cfjq_validate")>	
		<cfhtmlhead text='<script type="text/javascript" src="#attributes.jqFolder#/jquery.validate.js"></script>'>
		<cfset request.cfjq_validate =1>
	</cfif>
	<!---load jquery metadata plug in only once---->
	<cfif not structKeyExists(request, "cfjq_metadata")>	
		<cfhtmlhead text='<script type="text/javascript" src="#attributes.jqFolder#/jquery.metadata.js"></script>'>
		<cfset request.cfjq_metadata =1>
	</cfif>

	<!---set unique form class---->
	<cfif not structKeyExists(request, "cfjq_form_progress")>	
		<cfset request.cfjq_form_progress =1>
		<cfelse>
		<cfset request.cfjq_form_progress = #request.cfjq_form_progress# + 1>
	</cfif>
	<cfset attributes.form_class = #attributes.form_class# & #request.cfjq_form_progress#>


	<cfif attributes.placeError eq "box">
		<div class="messageBox#request.cfjq_form_progress#"><ul></ul></div>
	</cfif>	
				<form  action="#attributes.action#" <cfif len(attributes.id)>id="#attributes.id#"</cfif> class="#attributes.form_class# #attributes.css_class#" name="#attributes.form_class#"  method="#attributes.method#" <cfif len(attributes.enctype)>enctype="#attributes.enctype#"</cfif>>
	</cfoutput>

<cfelse>

	<cfoutput>
		</form>

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
		 
	</cfoutput>
</cfif>
