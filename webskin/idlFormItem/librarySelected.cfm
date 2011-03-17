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

<!--- @@displayname: --->
<!--- @@description: --->
<!--- @@author: Jørgen M. Skogås (jorgen@idl.no) --->

<!--- import taglibs --->
<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

<!--- add css to html head --->
	<skin:htmlHead id="idlform">
	<cfoutput>
	<style type="text/css">
	.idlformwidth
		{
		width: 60px;
		height: 15px;
		border: solid 1px ##999;
		display: block;
		float: left;
		margin-right: 10px;
		}
	.idlelementwidth
		{
		float: left;
		background-color: ##006600;
		display: block;
		}
	</style>

	</cfoutput>
	</skin:htmlHead>

	<cfoutput>
	<span class="idlformwidth">
		<cfif #stObj.width# EQ "w33percent">
			<span class="idlelementwidth" style="width: 20px;">&nbsp;</span>
		<cfelseif #stObj.width# EQ "w50percent">
			<span class="idlelementwidth" style="width: 30px;">&nbsp;</span>
		<cfelseif #stObj.width# EQ "w66percent">
			<span class="idlelementwidth" style="width: 40px;">&nbsp;</span>
		<cfelse>
			<span class="idlelementwidth" style="width: 60px;">&nbsp;</span>
		</cfif>
	</span>
	#stObj.title#<cfif stObj.linebreak> (&crarr;)</cfif>
	</cfoutput>

<cfsetting enablecfoutputonly="no" />