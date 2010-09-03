<cfcomponent extends="farcry.core.packages.types.types" displayname="Form Builder Item" output="false">

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
				name="initValue" type="string" required="false" default=""
				ftLabel="Initial value"
				hint="Initial value of the form element" />
		
	<cfproperty ftSeq="4" ftFieldset="General"
				name="name" type="string" required="false" default=""
				ftLabel="Group name"
				hint="name for grouping radiobuttons and check boxes" />
		
	<cfproperty ftSeq="5" ftFieldset="Layout (advanced)"
				name="linebreak" type="boolean" required="true" default="1"
				ftLabel="Linebreak after?" ftDefault="1"
				hint="If there should be a linebreak after the item or not" />
		
	<cfproperty ftSeq="6" ftFieldset="Layout (advanced)"
				name="width" type="string" required="false" default=""
				ftLabel="Class name" ftType="list"
				ftlist="w33percent:33% width,w50percent:50% width,w66percent:66% width,w100percent:Whole width"
				hint="Width class names for html class attribute" />
		
	<cfproperty ftSeq="7" ftFieldset="Layout (advanced)"
				name="class" type="string" required="false" default=""
				ftLabel="Class name"
				hint="class name for html class attribute" />
		
	<cfproperty ftSeq="8" ftFieldset="Layout (advanced)"
				name="cssID" type="string" required="false" default=""
				ftLabel="ID name"
				hint="name for html id attribute" />
		
	<cfproperty ftSeq="9" ftFieldset="Validation"
				name="validateRequired" type="boolean" required="false" default="false"
				ftLabel="Required"
				hint="if the form field is required" />
		
	<cfproperty ftSeq="10" ftFieldset="Validation"
				name="validateType" type="string" required="false" default="none"
				ftLabel="Type" ftType="list"
				ftlist="none:None,email:E-mail,url:Web address,date:Date,creditcard:Credit Card,digits:Digits,number:Number"
				hint="what type chould it be" />
		
	<cfproperty ftSeq="11" ftFieldset="Validation"
				name="validateMinLength" type="string" ftType="integer" required="false" default=""
				ftLabel="Minimum length" ftDefault=""
				hint="Minimum length of field"
				ftHint="Set to 0 if you don't want to validate minimum lenght." />
		
	<cfproperty ftSeq="12" ftFieldset="Validation"
				name="validateMaxLength" type="string" required="false" default=""
				ftLabel="Maximum length" ftType="integer" ftDefault=""
				hint="Maximum length of field"
				ftHint="Set to 0 if you don't want to validate maximum lenght." />
		
	<cfproperty ftSeq="13" ftFieldset="Validation"
				name="validateErrorMessage" type="string" required="false" default=""
				ftLabel="Error Message"
				hint="Message to show if validation fails" />

</cfcomponent>