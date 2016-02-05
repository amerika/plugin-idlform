<cfcomponent displayname="Global skjema konfigurasjon" extends="farcry.core.packages.types.types" bFriendly="false" bUseInTree="false">

	<cfproperty ftSeq="1" ftWizardStep="Recaptcha" ftFieldset="Recaptcha"
				name="recaptchaID" type="string" default=""
				ftLabel="Recaptcha Site Key" />

	<cfproperty ftSeq="2" ftWizardStep="Recaptcha" ftFieldset="Recaptcha"
				name="recaptchaSecret" type="string" default=""
				ftLabel="Recaptcha Secret Key" />

	<cfproperty ftSeq="3" ftWizardStep="Recaptcha" ftFieldset="Recaptcha"
				name="recaptchaError" type="string" default=""
				ftLabel="Recaptcha Error message" />

	<cfproperty name="titleProp" type="string" required="true" default="Global skjema" bLabel="true" hint="This property is only used to set the label" />

	<cffunction name="updateGlobalFormConfigKeys" access="public" output="false" returntype="struct">
		<cfset var stStatus = structNew() />
		<cfset stStatus.bSuccess = true />
		<cfset stStatus.message = "" />
		
		<cftry>
			<cfquery name="qTmp" datasource="#application.dsn#">
				SELECT *
				FROM idlformGlobalconfig
			</cfquery>
			<cfif qTmp.recordCount GT 0>
				<cfset application.stGlobalFormConfig = application.fapi.getContentObject(qTmp.objectID) />
			</cfif>
			<cfcatch>
				<cfset stStatus.bSuccess = false />
				<cfset stStatus.message = cfcatch.message />
			</cfcatch>
		</cftry>
		
		<cfreturn stStatus />
	</cffunction>

</cfcomponent>