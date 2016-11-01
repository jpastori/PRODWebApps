<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: Application.cfm.--->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/20/2008 --->
<!--- Date in Production: 08/20/2008 --->
<!--- Module: Special Collections Oracle Web Application --->
<!-- Last modified by John R. Pastori on 08/20/2008 using ColdFusion Studio: -->

<CFAPPLICATION name="LIBRARYWEBAPPS" clientmanagement="Yes" clientstorage="PRODLIBSHAREDDATA" sessionmanagement="Yes" setclientcookies="Yes" scriptprotect="all">

<CFINCLUDE template="../SQLInjectionIPBlackListProcess.cfm">

<!--- ****************************************************** --->
<!--- ******** Start Normal Application Processing. ******** --->
<!--- ****************************************************** --->


<!--- 	By default, the user is not logged in --->

<CFIF NOT IsDefined("application.spcoll_initialized") OR (IsDefined('URL.ACCESSINGAPPFIRSTTIME') AND URL.ACCESSINGAPPFIRSTTIME EQ "YES" AND Client.ACCESSINGSPECIALCOLLECTIONS EQ "NO")>
	<CFSET application.spcoll_initialized = 0>
<!--- 
	 We are now going to include a file that defines some site-wide variables. 
	 Notice how we check for application.initialized. globalvariables.cfm will set this value
	 to true at the end of the file. This is cool because it means the variables will only be 
	 initialized once, which is all we need if you think about it. 
	 This is a little performance trick that will make the apps run a bit faster.
 --->
	<CFINCLUDE template="spcoll_global_variables.cfm">
	<CFSET Session.SpecialCollectionsSystem = LISTFIND(#Client.ValidatedSystems#, 800)>
	<!--- <CFOUTPUT><BR>SYSTEM NUMBER = 800<BR></CFOUTPUT> --->
	<CFIF #Session.SpecialCollectionsSystem# GT 0>
		<CFIF ListGetAt(#Client.SecurityLevel#, #Session.SpecialCollectionsSystem#) LTE 20>
			<CFSET Client.ProcessFlag="No">
			<CFSET Client.DeleteFlag="No">
			<CFSET Client.SecurityFlag="No">
			<CFSET Client.MaintFlag="No">
			<CFSET Client.MaintLessFlag="No">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.SpecialCollectionsSystem#) GT 20 AND ListGetAt(#Client.SecurityLevel#, #Session.SpecialCollectionsSystem#) LTE 30>
			<CFSET Client.ProcessFlag = "Yes">
			<CFSET Client.DeleteFlag = "No">
			<CFSET Client.SecurityFlag = "No">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.SpecialCollectionsSystem#) GT 30 AND ListGetAt(#Client.SecurityLevel#, #Session.SpecialCollectionsSystem#) LT 40>
			<CFSET Client.ProcessFlag = "Yes">
			<CFSET Client.DeleteFlag = "Yes">
			<CFSET Client.SecurityFlag = "No">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.SpecialCollectionsSystem#) GTE 40>
			<CFSET Client.ProcessFlag="Yes">
			<CFSET Client.DeleteFlag="Yes">
			<CFSET Client.MaintFlag="Yes">
			<CFSET Client.SecurityFlag="Yes">
		</CFIF>
		<CFIF ListGetAt(#Client.SecurityLevel#, #Session.SpecialCollectionsSystem#) GTE 30 AND ListGetAt(#Client.SecurityLevel#, #Session.SpecialCollectionsSystem#) LTE 35>
			<CFSET Client.MaintFlag="No">
			<CFSET Client.MaintLessFlag="Yes">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.SpecialCollectionsSystem#) GTE 36 AND ListGetAt(#Client.SecurityLevel#, #Session.SpecialCollectionsSystem#) LTE 39>
			<CFSET Client.MaintFlag="Yes">
			<CFSET Client.MaintLessFlag="No">
		</CFIF>
	<CFELSE>
		<CFOUTPUT><H4>The user is not Validated for Login to the Special Collections Application. &nbsp;&nbsp;Click OK to return to your previous page.</H4></CFOUTPUT>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("The user is not Validated for Login to the Special Collections Application.  Click OK to return to your previous page.");
			--> 
		</SCRIPT>
		<CFOUTPUT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES" />
		</CFOUTPUT>
	</CFIF>
</CFIF>

<CFINCLUDE template="../SQLInjectionProtectionCode.cfm">