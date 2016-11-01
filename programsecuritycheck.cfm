<!--- Program: programsecuritycheck.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/06/2006 --->
<!--- Date In Production: 12/06/2006 --->
<!--- Module: Program Security Check --->
<!-- Last modified by John R. Pastori on 9/06/2012 using ColdFusion Studio. -->

<cfoutput>
<CFIF FIND('wiki', #CGI.HTTP_REFERER#, 1) EQ 0 AND FIND('forms', #CGI.HTTP_REFERER#, 1) EQ 0 AND FIND('libcoiil', #CGI.HTTP_HOST#, 1) EQ 0>
	<CFIF NOT IsDefined("Client.LoggedIn") OR NOT Client.LoggedIn EQ "Yes">
		<h1><FONT COLOR="Red">NOT Validated for Login</FONT></h1>
		<CFSET Client.LoggedIn="No">
		<CFSET application.initialized=0>
		<CFSET URL.logout = "Yes">
		<META HTTP-EQUIV="Refresh" CONTENT="0; URL=/#application.type#apps/index.cfm?logout=Yes" />
		<CFABORT>
	</CFIF>
</CFIF>
</cfoutput>