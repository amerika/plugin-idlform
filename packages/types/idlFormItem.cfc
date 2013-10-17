<cfcomponent extends="farcry.core.packages.types.types" displayname="Form Builder Item" output="false">
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
<!--- @@author: Trond Ulseth (trond@idl.no) --->

	<!--- type properties --->
	<cfproperty ftSeq="1" ftFieldset="General"
				name="title" type="string" required="true" default=""
				ftLabel="Label"
				hint="Form Item title" />
		
	<cfproperty ftSeq="2" ftFieldset="General"
				name="type" type="string" default="textfield"
				ftLabel="Input type" ftType="list"
				ftlist="textfield:Text Field,textarea:Text Area,checkbox:Check Box,radiobutton:Radio Button,list:List,filefield:Attachment,statictext:Static Text,hidden:Hidden Field"
				hint="The type of Form Item" />
		
	<cfproperty ftSeq="3" ftFieldset="General"
				name="placeholder" type="string" required="false" default=""
				ftLabel="Placeholder"
				ftHint="A prefilled hint in textfields, but that is not registered as a value" />

	<cfproperty ftSeq="4" ftFieldset="General"
				name="initValue" type="string" required="false" default=""
				ftLabel="Initial value"
				ftHint="Oposed to placeholder, this value can be posted. Check boxes and radio buttons can have an initial value of 1 if you want them to be preselected" />
		
	<cfproperty ftSeq="5" ftFieldset="General"
				name="name" type="string" required="false" default=""
				ftLabel="Group name"
				ftHint="Name for grouping radiobuttons and check boxes" />

	<cfproperty ftSeq="10" ftFieldset="Validation"
				name="validateRequired" type="boolean" required="false" default="false"
				ftLabel="Required" />
		
	<cfproperty ftSeq="11" ftFieldset="Validation"
				name="validateType" type="string" required="false" default="none"
				ftLabel="Type" ftType="list"
				ftlist="none:None,email:E-mail,url:Web address,date:Date,number:Number"
				ftHint="You can choose to validate the input against these types" />
				<!--- REMOVED FROM LIST: creditcard:Credit Card,digits:Digits --->
		
	<cfproperty ftSeq="12" ftFieldset="Validation"
				name="validateMinLength" type="string" ftType="integer" required="false" default=""
				ftLabel="Minimum length" ftDefault=""
				hint="Minimum length of field"
				ftHint="Set to 0 if you don't want to validate minimum lenght." />
		
	<cfproperty ftSeq="13" ftFieldset="Validation"
				name="validateMaxLength" type="string" required="false" default=""
				ftLabel="Maximum length" ftType="integer" ftDefault=""
				hint="Maximum length of field"
				ftHint="Set to 0 if you don't want to validate maximum lenght." />
		
	<cfproperty ftSeq="14" ftFieldset="Validation"
				name="validateErrorMessage" type="string" required="false" default=""
				ftLabel="Error Message"
				ftHint="Message to show if validation fails" />
		
	<cfproperty ftSeq="20" ftFieldset="Layout (advanced)"
				name="linebreak" type="boolean" required="true" default="1"
				ftLabel="Linebreak after?" ftDefault="1"
				ftHint="If there should be a linebreak after the item or not" />
		
	<cfproperty ftSeq="21" ftFieldset="Layout (advanced)"
				name="width" type="string" required="false" default=""
				ftLabel="Layout width" ftType="list"
				ftlist="w100percent:Whole width,w33percent:33% width,w50percent:50% width,w66percent:66% width"
				ftHint="Used to set width of input" />
		
	

	<!--- Depreciated --->

	<cfproperty 
				name="class" type="string" required="false" default=""
				ftLabel="Class name"
				hint="class name for html class attribute" />
		
	<cfproperty 
				name="cssID" type="string" required="false" default=""
				ftLabel="ID name"
				hint="name for html id attribute" />

</cfcomponent>