<cfsetting enablecfoutputonly="yes" />
<!--- @@displayname: Standard Skjema --->

<!--- import taglib --->
<cfimport taglib="/farcry/plugins/idlform/tags/webskin/" prefix="skin" />
	
	<cfoutput><h1 class="idlform">#stObj.title#</h1></cfoutput>
	
	<!--- build form --->
	<skin:buildForm></skin:buildForm>
	
<cfsetting enablecfoutputonly="no" />