<!--- @@Copyright: Copyright (c) 2015 Amerika Design & Utvikling AS. All rights reserved. --->
<!--- @@License:
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
--->

<!--- @@displayname: idlFormReceiver.cfc --->
<!--- @@description: There is no description for this template. Please add or remove this message. --->
<!--- @@author: Jørgen M. Skogås (jorgen@amerika.no) on 2015-01-28 --->

<cfcomponent name="E-mail receivers (idlForm)" displayname="E-mail receivers (idlForm)" extends="farcry.core.packages.types.types">

	<cfproperty ftSeq="1" ftFieldset="Receivers info"
				name="recieverName" type="string" required="true" default="" bLabel="true"
				ftLabel="Receiver name" ftValidation="required" />
				
	<cfproperty ftSeq="1" ftFieldset="Receivers info"
				name="email" type="string" required="true" default=""
				ftLabel="Receiver e-mail" ftValidation="required"
				ftHint="Separate multiple receivers with comma, eg: post@example.com, jorgen@example.com" />

</cfcomponent>