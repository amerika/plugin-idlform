<cfsetting enablecfoutputonly="yes">
<!--- @@Copyright: Copyright (c) 2012 IDLmedia AS. All rights reserved. --->
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

<!--- THIS WILL BE INCLUDED AFTER THE FARCRY INIT HAS BEEN RUN BUT ONLY ON APPLICATION INITIALISATION. --->


<!---------------------------------
 IMPORT TAG LIBRARIES
 --------------------------------->
<cfimport taglib="/farcry/core/tags/farcry" prefix="farcry" />
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--------------------------------- 
PUT PRODUCTION OR DEFAULT CODE HERE
 --------------------------------->

<cfif application.fapi.getconfig("idlform", "settings", "uniform") IS "uniform">
	<!--- Her sjekker vi om css og js er inkludert med alias - eller om de er kopiert inn i prosjektet --->
	<cfset application.idlform.bIdlFormAlias = true />
	<cfset application.idlform.bIdlFormCopied = true />

	<!--- Sjekk nr. 1 vil vise om alias er opprettet --->
	<cftry>
		<cfhttp url="#cgi.http_host#/idlform/css/idlform.css" timeout="3" result="testAlias" throwonerror="yes" />
		<cfcatch>
			<cfset application.idlform.bIdlFormAlias = false />
		</cfcatch>
	</cftry>

	<!--- Sjekk nr. 2 vil vise om css og js er kopiert inn i prosjektet --->
	<cftry>
		<cfhttp url="#cgi.http_host#/css/uniform/uniform.aristo.css" timeout="3" result="testCopiedCSS1" throwonerror="yes" />
		<cfhttp url="#cgi.http_host#/js/uniform/jquery.uniform.min.js" timeout="3" result="testCopiedJS" throwonerror="yes" />
		<cfhttp url="#cgi.http_host#/js/js-webshim/dev/polyfiller.js" timeout="3" result="testCopiedJS" throwonerror="yes" />
		<cfhttp url="#cgi.http_host#/css/idlform.css" timeout="3" result="testCopiedCSS2" throwonerror="yes" />
		<cfcatch>
			<cfset application.idlform.bIdlFormCopied = false />
		</cfcatch>
	</cftry>

	<!--- Her registrerer vi css i henhold til resultatet av sjekkene --->
	<cfif application.idlform.bIdlFormAlias>
		<skin:registerCSS id="uniformCSS" baseHREF="/idlform/css/uniform/themes/_base/css/" lfiles="uniform._base.css" />
		<skin:registerCSS id="uniformTheme" baseHREF="/idlform/css/uniform/themes/default/css/" lfiles="uniform.default.css" />
		<skin:registerJS id="uniformJS" baseHREF="/idlform/js/uniform" lfiles="jquery.uniform.min.js" />
		<skin:registerJS id="modernizrJS" baseHREF="/idlform/js/js-webshim/dev/extras" lfiles="modernizr-custom.js" />
		<skin:registerJS id="webshimJS" baseHREF="/idlform/js/js-webshim/dev" lfiles="polyfiller.js" />
		<skin:registerCSS id="idlformCSS" baseHREF="/idlform/css" lfiles="idlform.css" />
	<cfelseif application.idlform.bIdlFormCopied>
		<skin:registerCSS id="uniformCSS" baseHREF="/css/uniform" lfiles="uniform.default.css,uniform.aristo.css" />
		<skin:registerCSS id="uniformTheme" baseHREF="/css/uniform" lfiles="uniform.aristo.css" />
		<skin:registerJS id="uniformJS" baseHREF="/js/uniform" lfiles="jquery.uniform.min.js" />
		<skin:registerJS id="modernizrJS" baseHREF="/js/js-webshim/dev/extras" lfiles="modernizr-custom.js" />
		<skin:registerJS id="webshimJS" baseHREF="/js/js-webshim/dev" lfiles="polyfiller.js" />
		<skin:registerCSS id="idlformCSS" baseHREF="/css" lfiles="idlform.css" />
	</cfif>

	<!--- Om ingen av sjekkene går gjennom så sier vi i fra om dette --->
	<cfif application.fapi.isLoggedIn() AND application.fapi.hasRole('sysadmin') AND (NOT application.idlform.bIdlFormCopied AND NOT application.idlform.bIdlFormAlias)>
		<skin:bubble title="IDLmedia Form Plugin" sticky="true">
			<cfoutput>#application.rb.getResource("idlform.buildform.messages.checkJsCss@text","You need to make an virtual directory in your webserver or copy the js and css into the project for the idlform plugin to work.")#</cfoutput>
			<!--- http://afarkas.github.com/webshim/ --->
		</skin:bubble>
	</cfif>

	<!--- disse må sjekkes om skal bruke alias url eller url til filer i prosjekter --->
</cfif>

<cfsetting enablecfoutputonly="no">