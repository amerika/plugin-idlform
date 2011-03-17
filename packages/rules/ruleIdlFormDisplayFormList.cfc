<cfcomponent displayname="Form builder: Display Form List" extends="farcry.core.packages.rules.rules">
<!--- @@Copyright: Copyright (c) 2010 IDLmedia AS. All rights reserved. --->
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
<!--- @@description: --->
<!--- @@author: Jørgen M. Skogås (jorgen@idl.no) --->

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