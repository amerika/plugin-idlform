<cfsetting enablecfoutputonly="yes" />
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

<!--- @@displayname: Default webskin--->
<!--- @@description: --->
<!--- @@author: Trond Ulseth (trond@idl.no) --->

<!--- import taglib --->
<cfimport taglib="/farcry/plugins/idlform/tags/webskin/" prefix="skin" />

	<cfoutput>
		<div class="idlform">
			<h2>#stObj.title#</h2>
	</cfoutput>
	<!--- build form --->
	<skin:buildForm objectID="#stObj.objectID#" formInfo="#stObj.formheader#" sendtText="#stObj.sendt#" submitText="#stObj.submitText#" aFormItems="#stObj.aFormItems#"></skin:buildForm>
	<cfoutput>
			<div class="clear"></div>
		</div>
	</cfoutput>

<cfsetting enablecfoutputonly="no" />