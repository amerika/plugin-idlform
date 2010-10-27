<cfsetting enablecfoutputonly="yes" />
<!--- @@displayname: Standard --->

<!--- import taglib --->
<cfimport taglib="/farcry/plugins/idlform/tags/webskin/" prefix="skin" />

	<cfoutput>
		<div class="idlform">
			<h2>#stForm.title#</h2>
	</cfoutput>
	<!--- build form --->
	<skin:buildForm objectID="#stObj.objectID#" formInfo="#stObj.formheader#" sendtText="#stObj.sendt#" submitText="#stObj.submitText#" aFormItems="#stObj.aFormItems#"></skin:buildForm>
	<cfoutput>
			<div class="clear"></div>
		</div>
	</cfoutput>

<cfsetting enablecfoutputonly="no" />