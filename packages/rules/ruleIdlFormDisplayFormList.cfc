<cfcomponent displayname="Form builder: Display Form List" extends="farcry.core.packages.rules.rules">
<!--- @@Copyright: Copyright (c) 2010 IDLmedia AS. All rights reserved. --->
<!--- @@License: --->

	<!--- type properties --->
	<cfproperty ftSeq="1" ftfieldset="Form List Details"
				name="title" type="string" required="no" default=""
				ftLabel="Title" blabel="true" />

	<cfproperty ftSeq="10" ftfieldset="Form List Details"
				name="description" type="string" required="No" default=""
				ftLabel="Description" fttype="longchar" />
	
	<cfproperty ftSeq="20" ftfieldset="Form List Details"
				name="displayMethod"  type="string" required="true" default="displayFormListStandard"
				ftlabel="Display List Method" fttype="webskin" ftprefix="displayFormList"
				hint="Display method to render the list" />
	
	<cfproperty ftSeq="21" ftfieldset="Form List Details"
				name="displayListMethod" type="string" required="true" default="displayTeaserStandard"
				ftlabel="Display List Item Method" fttype="webskin" fttypename="idlForm" ftprefix="displayTeaser"
				hint="Display method to render the list" />
	
</cfcomponent>