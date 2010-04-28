<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- @@Copyright: Copyright (c) 2010 IDLmedia AS. All rights reserved. --->
<!--- @@displayname: Default teaser template --->
<!--- @@License: --->

<!--- libs --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- create form url --->
<skin:buildlink objectid="#stObj.objectID#" r_url="formUrl" />

<cfoutput>
	<h3>#stObj.title#</h3>
	<p>
		#stObj.formHeader#<br />
		<a href="#formUrl#">Fyll ut skjemaet her»</a>
	</p>
</cfoutput>

<cfsetting enablecfoutputonly="false" />