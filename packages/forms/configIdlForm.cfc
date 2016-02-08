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
				
	<cfproperty ftSeq="26" ftFieldset="Google reCAPTCHA"
				name="recaptchaLanguage" type="string" default="en"
				ftLabel="Recaptcha Language" ftDefault="en" ftType="list" ftList="ar:Arabic,af:Afrikaans,am:Amharic,hy:Armenian,az:Azerbaijani,eu:Basque,bn:Bengali,bg:Bulgarian,ca:Catalan,zh-HK:Chinese (Hong Kong),zh-CN:Chinese (Simplified),zh-TW:Chinese (Traditional),hr:Croatian,cs:Czech,da:Danish,nl:Dutch,en-GB:English (UK),en:English (US),et:Estonian,fil:Filipino,fi:Finnish,fr:French,fr-CA:French (Canadian),gl:Galician,ka:Georgian,de:German,de-AT:German (Austria),de-CH:German (Switzerland),el:Greek,gu:Gujarati,iw:Hebrew,hi:Hindi,hu:Hungarain,is:Icelandic,id:Indonesian,it:Italian,ja:Japanese,kn:Kannada,ko:Korean,lo:Laothian,lv:Latvian,lt:Lithuanian,ms:Malay,ml:Malayalam,mr:Marathi,mn:Mongolian,no:Norwegian,fa:Persian,pl:Polish,pt:Portuguese,pt-BR:Portuguese (Brazil),pt-PT:Portuguese (Portugal),ro:Romanian,ru:Russian,sr:Serbian,si:Sinhalese,sk:Slovak,sl:Slovenian,es:Spanish,es-419:Spanish (Latin America),sw:Swahili,sv:Swedish,ta:Tamil,te:Telugu,th:Thai,tr:Turkish,uk:Ukrainian,ur:Urdu,vi:Vietnamese,zu:Zulu" />
	
	<cfproperty ftSeq="26" ftFieldset="Google reCAPTCHA"
				name="recaptchaTheme" type="string" default=""
				ftLabel="Recaptcha Theme" ftType="list" ftList="light:Light theme,dark:Dark Theme" />
				
				

</cfcomponent>