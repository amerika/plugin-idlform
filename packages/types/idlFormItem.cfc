<cfcomponent extends="farcry.core.packages.types.types" displayname="Form builder item" output="false">

	<!--- type properties --->
	<cfproperty name="title" type="string" hint="Form Item title" required="yes" default="" ftLabel="Label" ftseq="1">
	<cfproperty name="type" type="string" hint="The type of Form Item" 	default="textfield" fttype="list" ftlist="textfield:Text Field,textarea:Text Area,checkbox:Check Box,radiobutton:Radio Button,list:List,filefield:Attachment,statictext:Static Text,hidden:Hidden Field" ftLabel="Input type"  ftseq="2">
	<cfproperty name="initValue" type="string" hint="Initial value of the form element" required="no" default="" ftLabel="Initial value" ftseq="3">
	<cfproperty name="linebreak" type="boolean" hint="If there should be a linebreak after the item or not" required="yes" default="1" 	ftLabel="Linebreak after?" ftseq="4">
	<cfproperty name="name" type="string" hint="name for grouping radiobuttons and check boxes" required="true" default="" ftLabel="Group name" ftseq="5">
	
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