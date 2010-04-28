<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- @@Copyright: Copyright (c) 2010 IDLmedia AS. All rights reserved. --->
<!--- @@License: --->

<!--- libs --->
<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- Render Output
//////////////////////////////////////////////////////////////////////////////////////////////////////// --->
<skin:view stObject="#stObj#" webskin="#stObj.displayMethod#" />

<cfsetting enablecfoutputonly="false" />