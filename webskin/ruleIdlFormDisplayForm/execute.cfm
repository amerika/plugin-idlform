<cfsetting enablecfoutputonly="yes" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- @@Copyright: Copyright (c) 2010 IDLmedia AS. All rights reserved. --->
<!--- @@License:

--->
<!--- @@displayname: --->
<!--- @@description: Standard Skjema --->
<!--- @@author: Jørgen M. Skogås on 2010-10-27 --->

<!--- import taglib --->
<cfimport taglib="/farcry/plugins/idlform/tags/webskin/" prefix="skin" />

<!--- Output
///////////////////////////////////////////////////////////////////////////////////////////////// --->
<skin:view objectid="#stObj.formID#" webskin="#stObj.displayMethod#" />

<cfsetting enablecfoutputonly="no" />