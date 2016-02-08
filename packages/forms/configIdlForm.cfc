<!--- @@Copyright: Copyright (c) 2015 . All rights reserved. --->
<!--- @@License:
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
--->

<!--- @@displayname: configIdlForm.cfc --->
<!--- @@description: There is no description for this template. Please add or remove this message. --->
<!--- @@author: Jørgen M. Skogås (jorgen@amerika.no) on 2015-11-16 --->

<cfcomponent displayname="Form settings (idlform-plugin)" output="false" extends="farcry.core.packages.forms.forms" hint="Settings for the idlform plugin." key="idlform">

	<!--- Properties
	////////////////////////////////////////////////////////////////////////////////////////////////////// --->
				
	<cfproperty ftSeq="10" ftFieldset="Theme settings (js/css)"
				name="settings" type="string" default="uniform"
				ftLabel="Form theme" ftType="list" ftList="uniform:Uniform (checks project first then the plugin),none:Don't style my forms" ftDefault="uniform"
				ftHint="The idlform plugin will default load the plugins theme (UniForm) - http://pixelmatrix.github.io/uniform/" />
				
	<cfproperty ftSeq="20" ftFieldset="Google reCAPTCHA"
				name="recaptchaSiteKey" type="string" default=""
				ftLabel="Recaptcha Site Key"
				ftHint='Add new reCAPTCHA site here: <a href="https://www.google.com/recaptcha/admin" target="_blank">https://www.google.com/recaptcha/admin</a>' />

	<cfproperty ftSeq="21" ftFieldset="Google reCAPTCHA"
				name="recaptchaSecret" type="string" default=""
				ftLabel="Recaptcha Secret Key" />

	<cfproperty ftSeq="22" ftFieldset="Google reCAPTCHA"
				name="recaptchaError" type="string" default=""
				ftLabel="Recaptcha Error message" />
				
	<cfproperty ftSeq="25" ftFieldset="Google reCAPTCHA"
				name="recaptchaTheme" type="string" default=""
				ftLabel="Recaptcha Theme" ftType="list" ftList="light:Light theme,dark:Dark Theme" />
				
				

</cfcomponent>