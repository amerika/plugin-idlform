<cfoutput>
<cfif StructKeyExists(form,"submitidlform")>
		<!--- send the content of the submited form by e-mail --->
		<cfinvoke component="farcry.plugins.idlForm.packages.types.idlForm" method="submit">
			<cfinvokeargument name="objectId" value="#stobj.objectId#"/>
			<cfinvokeargument name="formData" value="#form#"/>
		</cfinvoke>
	#stObj.sendt#
<cfelse>
<h1 class="idlform">#stObj.title#</h1>
	<!--- set comma delimeted list with input types which should not have a label  --->
	<cfset noLabel = "hidden,statictext">
	<div class="description">#stObj.formheader#</div>
		<form action="" method="post" enctype="multipart/form-data" name="editform" class="idlform">
		<fieldset>
		<!--- loop over items --->
			<cfloop from="1" to="#arrayLen(stObj.aFormItems)#" index="i">
				<cfset oFormItemService = createObject("component","farcry.plugins.idlForm.packages.types.idlFormItem")>
				<cfset oFormItem = oFormItemService.getData(objectID=stObj.aFormItems[i])>
								
				<div class="formline">
					<!--- display (or not) label --->
					<cfif not ListFind(noLabel,oFormItem.type)>
						<label for="#oFormItem.objectid#">
						<cfif Len(trim(oFormItem.title))>#oFormItem.title#:</cfif>
						</label>
					</cfif>
		
					<cfswitch expression="#oFormItem.type#">
						<cfcase value="textfield">
							 <input name="#oFormItem.objectid#" type="text" value="#oFormItem.initValue#">
						</cfcase>
						<cfcase value="textarea">
							<textarea name="#oFormItem.objectid#" wrap="virtual">#oFormItem.initValue#</textarea>
						</cfcase>
						<cfcase value="checkbox">
							<input name="#oFormItem.objectid#" type="checkbox" value="#oFormItem.initValue#" <cfif oFormItem.initValue is 1>checked</cfif> />
						</cfcase>
						<cfcase value="radiobutton">
							<input name="#oFormItem.name#" type="radio" value="#oFormItem.initValue#" <cfif oFormItem.initValue is 1>checked</cfif> />
						</cfcase>
						<cfcase value="list">
							<select name="#oFormItem.objectid#">
							<cfloop list="#oFormItem.initValue#" index="i">
							<option value="#i#">#i#</option>
							</cfloop>
							</select>
						</cfcase>
						<cfcase value="filefield">
							<input name="#oFormItem.objectid#" type="file" />
						</cfcase>
						<cfcase value="statictext">
						<span class="statictext">#oFormItem.initValue#</span>
						</cfcase>
					</cfswitch>
				</div>
		
				<cfif oFormItem.linebreak is 1><br /></cfif>
				
			</cfloop>
			<div class="formline">
			<label for="submitidlform">&nbsp;</label>
			<input type="submit" name="submitidlform" value="#stObj.submittext#" />
			</div>
		</fieldset>
		</form>
	</div>
</cfif>
</cfoutput>