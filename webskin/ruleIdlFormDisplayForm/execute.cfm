<cfsetting enablecfoutputonly="yes" />
<!--- @@displayname: Standard Skjema --->

<!--- import taglib --->
<cfimport taglib="/farcry/plugins/idlform/tags/webskin/" prefix="skin" />

<!--- get form data --->	
<cfset oForm = createobject("component", "#application.stcoapi.idlform.packagepath#") />
<cfset stForm = oForm.getData(stObj.formid) />

	<!--- build form --->
	<cfoutput>
		<div class="idlform">
			<h2>#stForm.title#</h2>
	</cfoutput>
	<skin:buildForm objectID="#stForm.objectID#" formInfo="#stForm.formheader#" sendtText="#stForm.sendt#" submitText="#stForm.submitText#" aFormItems="#stForm.aFormItems#"></skin:buildForm>
	<cfoutput>
			<div class="clear"></div>
		</div>
	</cfoutput>
<cfsetting enablecfoutputonly="no" />