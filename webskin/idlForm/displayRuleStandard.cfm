<cfsetting enablecfoutputonly="yes" />
<!--- @@displayname: Standard --->

<!--- import taglib --->
<cfimport taglib="/farcry/plugins/idlform/tags/webskin/" prefix="skin" />

	<cfoutput><h1 class="idlform">#stObj.title#</h1></cfoutput>

	<!--- build form --->
	<skin:buildForm objectID="#stObj.objectID#" sendtText="#stObj.sendt#" submitText="#stObj.submitText#" aFormItems="#stObj.aFormItems#"></skin:buildForm>

<cfsetting enablecfoutputonly="no" />