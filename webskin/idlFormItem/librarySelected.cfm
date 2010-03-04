<cfsetting enablecfoutputonly="yes" />
<!--- @@displayname: something smart --->

<!--- import taglibs --->
<cfimport taglib="/farcry/core/tags/webskin/" prefix="skin" />

<!--- add css to html head --->
	<skin:htmlHead id="idlform">
	<cfoutput>
	<style type="text/css">
	.idlformwidth
		{
		width: 60px;
		height: 15px;
		border: solid 1px ##999;
		display: block;
		float: left;
		margin-right: 10px;
		}
	.idlelementwidth
		{
		float: left;
		background-color: ##006600;
		display: block;
		}
	</style>

	</cfoutput>
	</skin:htmlHead>

	<cfoutput>
	<span class="idlformwidth">
		<cfif #stObj.width# EQ "w33percent">
			<span class="idlelementwidth" style="width: 20px;">&nbsp;</span>
		<cfelseif #stObj.width# EQ "w50percent">
			<span class="idlelementwidth" style="width: 30px;">&nbsp;</span>
		<cfelseif #stObj.width# EQ "w66percent">
			<span class="idlelementwidth" style="width: 40px;">&nbsp;</span>
		<cfelse>
			<span class="idlelementwidth" style="width: 60px;">&nbsp;</span>
		</cfif>
	</span>
	#stObj.title#<cfif stObj.linebreak> (&crarr;)</cfif>
	</cfoutput>

<cfsetting enablecfoutputonly="no" />