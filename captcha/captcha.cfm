<cfif not structKeyExists(url, "hash")>
   <cfabort>
</cfif>

<cfset variables.captcha = application.captcha.createCaptchaFromHashReference("stream",url.hash) />
<cfcontent type="image/jpeg" variable="#variables.captcha.stream#" reset="false" />