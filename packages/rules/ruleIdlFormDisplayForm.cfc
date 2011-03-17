<cfcomponent displayname="Form builder: Display form" extends="farcry.core.packages.rules.rules">
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
	<cfproperty name="formID" ftfieldset="Formdetails" type="uuid" fttype="uuid" hint="Form to display" required="yes" default="" ftlabel="Select form" ftjoin="idlform" bsyncstatus="false" ftseq="1" />
	<cfproperty name="displayMethod" ftfieldset="Formdetails" type="string" hint="Display method to render individual content items." required="true" default="displayRuleStandard" fttype="webskin" fttypename="idlform" ftprefix="displayRule" ftlabel="Display Method" ftseq="2" />

</cfcomponent>