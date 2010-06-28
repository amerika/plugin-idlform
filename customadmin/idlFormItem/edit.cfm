<cfsetting enablecfoutputonly="yes">
<cfimport taglib="/farcry/core/tags/formtools/" prefix="ft" >

<cfset oFormItem = createObject("component", application.stCoapi.idlFormItem.packagepath) />

<cfset stObj = oFormItem.getData(objectID=url.objectID) />

<cfoutput><h2>Edit formfield</h2></cfoutput>
<ft:form>
  <ft:object stObject="#stObj#" lFields="title,type" format="edit" />
</ft:form>

<cfsetting enablecfoutputonly="no">