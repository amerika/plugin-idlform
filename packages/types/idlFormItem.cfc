<cfcomponent extends="farcry.core.packages.types.types" displayname="Form builder item" output="false">

	<!--- type properties --->
	<cfproperty 
		name="title"
		ftfieldset="General"
		type="string"
		hint="Form Item title"
		required="yes"
		default=""
		ftlabel="Label"
		ftseq="1">
		
	<cfproperty
		name="type"
		ftfieldset="General"
		type="string"
		hint="The type of Form Item"
		default="textfield"
		fttype="list"
		ftlist="textfield:Text Field,textarea:Text Area,checkbox:Check Box,radiobutton:Radio Button,list:List,filefield:Attachment,statictext:Static Text,hidden:Hidden Field"
		ftlabel="Input type"
		ftseq="2">
		
	<cfproperty
		name="initValue"
		ftfieldset="General"
		type="string"
		hint="Initial value of the form element"
		required="no"
		default=""
		ftlabel="Initial value"
		ftseq="3">
		
	<cfproperty
		name="name"
		ftfieldset="General"
		type="string"
		hint="name for grouping radiobuttons and check boxes"
		required="true"
		default=""
		ftlabel="Group name"
		ftseq="4">
		
	<cfproperty
		name="linebreak"
		ftfieldset="Layout (advanced)"
		type="boolean"
		hint="If there should be a linebreak after the item or not"
		required="yes"
		default="1"
		ftlabel="Linebreak after?"
		ftseq="5">
		
	<cfproperty
		name="width"
		ftfieldset="Layout (advanced)"
		type="string"
		fttype="list"
		ftlist="w33percent:33% width,w50percent:50% width,w66percent:66% width,:Whole width"
		hint="Width class names for html class attribute"
		required="false"
		default=""
		ftlabel="Class name"
		ftseq="6">
		
	<cfproperty
		name="class"
		ftfieldset="Layout (advanced)"
		type="string"
		hint="class name for html class attribute"
		required="false"
		default=""
		ftlabel="Class name"
		ftseq="7">
		
	<cfproperty
		name="cssID"
		ftfieldset="Layout (advanced)"
		type="string"
		hint="name for html id attribute"
		required="false"
		default=""
		ftlabel="ID name"
		ftseq="8">
	
	<!--- <cffunction name="afterSave" access="public" output="true">
		<cfoutput>
			<script type="text/javascript">
			function refreshParentAndClose() {
				window.opener.location.reload();
				window.close()
			}
			</script>
			<input type="button" value="lukk vindu" onclick="refreshParentAndClose()">
		</cfoutput>
		<cfabort>
	</cffunction> --->
</cfcomponent>