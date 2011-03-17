<cfsetting enablecfoutputonly="true" />
<!--- @@Copyright: Copyright (c) 2008 IDLmedia AS. All rights reserved. --->
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

<cfimport taglib="/farcry/core/tags/formtools/" prefix="ft" >

<cfset oFormItem = createObject("component", application.stCoapi.idlFormItem.packagepath) />

<cfset stObj = oFormItem.getData(objectID=url.objectID) />

<cfoutput><h2>Edit formfield</h2></cfoutput>
<ft:form>
  <ft:object stObject="#stObj#" lFields="title,type" format="edit" />
</ft:form>

<cfsetting enablecfoutputonly="false">