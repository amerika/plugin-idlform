<!---
 * CF_JQTAB - COLD FUSION CTAG FOR TABS JQUERY PLUGIN
 * @requires jQuery v1.1.1 and CFMX7+
 *
 * http://www.andreafm.com
 *
 * Copyright (c) 2007 Andrea Campolonghi (andreacfm.com)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * Check the jquery.tabs.pack.js file for Plug-in license and permissions
 * Version:1.0
---->
<cfsetting enablecfoutputonly="true">
	<cfif thisTag.executionMode is "start"><!---on start mode say to page.cfm which tag is wrapping it--->
		<cfset request.parentTag = "cf_cfjq_tab"/>
	</cfif>
<cfif thisTag.executionMode is "end">

<cfparam name="attributes.id" type="string" default="jqtab">
<cfparam name="attributes.selected" type="numeric" default="1">
<cfparam name="attributes.jqFolder" type="string" default="">
<cfparam name="attributes.skin" type="string" default="custom"><!---choose:custom,light,dark---->
<cfparam name="attributes.fxSlide" type="boolean" default="false"><!---Slide Effects ( can be combined with fade)--->
<cfparam name="attributes.fxFade" type="boolean" default="false"><!---Fade Effects ( can be combined with Slide)--->
<cfparam name="attributes.fxSpeed" type="string" default="fast"><!---speed of fading (slow, norma,fast ) or integer(milliseconds)--->
<cfparam name="attributes.fxAutoHeight" type="boolean" default="false"><!---Auto Height --->
<cfparam name="attributes.fxAjax" type="boolean" default="false"><!---Ajax calls default to false --->

	<!---if no exists pages struct just exit---->
	<cfif not structKeyExists(thisTag, "pages") or not arrayLen(thisTag.pages)>
		<cfexit method="exitTag">
	</cfif>
	<!---load jquery only once//work also with other cfjq custom tags---->
	<cfif not structKeyExists(request, "cfjq")>	
		<cfset request.cfjq =1>
		<cfhtmlhead text='<script type="text/javascript" src="#attributes.jqFolder#/jquery.latest.js"></script>'>
	</cfif>
	<!---load js and css only once per page call---->
	<cfif not structKeyExists(request, "cfjq_tab")>	
		<cfset request.cfjq_tab = 1>
		<cfhtmlhead text='<script type="text/javascript" src="#attributes.jqFolder#/ui.tabs.js"></script>'>
	</cfif>
	<!---load js and css only once per page call---->
	<cfif not structKeyExists(request, "cfjq_tab_css_#attributes.skin#")>
		<cfset skin = "cfjq_tab_css_#attributes.skin#">
		<cfset request[#skin#] = 1>
		<cfhtmlhead text='<link rel="stylesheet" href="#attributes.jqFolder#/jquery.#attributes.skin#.tabs.css" type="text/css" media="projection, screen" >
		<cfif attributes.skin eq "custom">
		<!--[if lte IE 7]>
		<link rel="stylesheet" href="#attributes.jqFolder#/jquery.tabs-ie.css" type="text/css" media="projection, screen"/>
		<![endif]--></cfif>'>
	</cfif>

	<!---create unique id for all the tabs in the page. Is considering that a tab panel has no more than 10 tabs ---->
	<cfif not structKeyExists(request, "cfjq_tabId")>
		<cfset request.idprogress = 1>
		<cfset request.cfjq_tabId =#attributes.id# & #request.idprogress#>
	<cfelse>
	 	<cfset request.idprogress = request.idprogress + 10>
		<cfset request.cfjq_tabId =#attributes.id# & #request.idprogress#>
	</cfif>

	<cfoutput>
		<cfset isAjax = false>
		<cfif attributes.fxAjax><cfset isAjax = true></cfif><!---set a variable to check if the tag is working in ajax mode---->
		<cfif attributes.skin eq "custom"><div><cfelse><div class="#attributes.skin#"></cfif>
            <ul id="#request.cfjq_tabId#">
				<cfset identify = request.idprogress+1><!---set a progress to ensure more tabs will work on the same page---->
				<cfloop index="x" from="1" to="#arrayLen(thisTag.pages)#"><!---loop array from page.cfm---->
					<!---if is Ajax Mode any page ctag must specify an url---->
					<cfif isAjax and not len(thisTag.pages[x].fxAjaxUrl)><cfoutput>Specify an url for tab number #x#</cfoutput><cfexit method="exittag"></cfif>
                	<li><cfif isAjax><a href="#thisTag.pages[x].fxAjaxUrl#"><cfelse><a href="##fragment-#identify#"></cfif><span>#thisTag.pages[x].title#</span></a></li>
				<cfset identify = identify +1 >
				</cfloop>
            </ul>
			<cfif not isAjax><!----normal flow process if is not an Ajax mode tab--->
				<cfset identify = request.idprogress+1>
				<cfloop index="x" from="1" to="#arrayLen(thisTag.pages)#">
					<cfset fragment = #request.idprogress#+1>
							<div id="fragment-#identify#">
								#thisTag.pages[x].content#
							</div>
					<cfset identify = identify +1 >
				</cfloop>
			</cfif>		
		</div>
		<script type="text/javascript"><!--- initialize the jQuery Oject --->
            $(function() {
            	$('###request.cfjq_tabId#').tabs(#attributes.selected#,{fxSlide: #attributes.fxSlide#,fxFade: #attributes.fxFade#, fxSpeed :'#attributes.fxSpeed#',fxAutoHeight: #attributes.fxAutoHeight#,remote: #attributes.fxAjax#});
				});					
		</script>				
	</cfoutput>	

</cfif>


<cfsetting enablecfoutputonly="false">

