<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: Application.cfm.--->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/15/2011 --->
<!--- Date in Production: 07/15/2011 --->
<!--- Module: IDT Purchasing Oracle Web Application --->
<!-- Last modified by John R. Pastori on 07/15/2011 using ColdFusion Studio: -->

<CFAPPLICATION name="LIBRARYWEBAPPS" clientmanagement="Yes" clientstorage="PRODLIBSHAREDDATA" sessionmanagement="Yes" setclientcookies="Yes" scriptprotect="all">

<CFINCLUDE template="../SQLInjectionIPBlackListProcess.cfm">

<!--- ****************************************************** --->
<!--- ******** Start Normal Application Processing. ******** --->
<!--- ****************************************************** --->


<!--- 	By default, the user is not logged in --->

<CFIF NOT IsDefined("application.idtpurch_initialized") OR (IsDefined('URL.ACCESSINGAPPFIRSTTIME') AND URL.ACCESSINGAPPFIRSTTIME EQ "YES" AND Client.ACCESSINGPURCHASING EQ "NO")>
	<CFSET application.idtpurch_initialized = 0>
<!--- We are now going to include a file that defines some site-wide variables. Notice how we check for application.initialized. globalvariables.cfm will set this value 	to true at the end of the file. This is cool because it means the variables will only be initialized once, which is all we need if you think about it. This is a little performance trick that will make the apps run a bit faster. --->
	<CFINCLUDE template="idtpurch_global_variables.cfm">
	<CFSET Session.IDTPurchasingSystem = LISTFIND(#Client.ValidatedSystems#, 400)>
	<!--- <CFOUTPUT><BR>SYSTEM NUMBER = 400<BR></CFOUTPUT> --->
	<CFIF #Session.IDTPurchasingSystem# GT 0>
		<CFIF ListGetAt(#Client.SecurityLevel#, #Session.IDTPurchasingSystem#) LTE 20>
			<CFSET Client.ProcessFlag="No">
			<CFSET Client.DeleteFlag="No">
			<CFSET Client.SecurityFlag="No">
			<CFSET Client.MaintFlag="No">
			<CFSET Client.MaintLessFlag="No">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.IDTPurchasingSystem#) GT 20 AND ListGetAt(#Client.SecurityLevel#, #Session.IDTPurchasingSystem#) LTE 30>
			<CFSET Client.ProcessFlag = "Yes">
			<CFSET Client.DeleteFlag = "No">
			<CFSET Client.SecurityFlag = "No">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.IDTPurchasingSystem#) GT 30 AND ListGetAt(#Client.SecurityLevel#, #Session.IDTPurchasingSystem#) LT 40>
			<CFSET Client.ProcessFlag = "Yes">
			<CFSET Client.DeleteFlag = "Yes">
			<CFSET Client.SecurityFlag = "No">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.IDTPurchasingSystem#) GTE 40>
			<CFSET Client.ProcessFlag="Yes">
			<CFSET Client.DeleteFlag="Yes">
			<CFSET Client.SecurityFlag="Yes">
		</CFIF>
		<CFIF ListGetAt(#Client.SecurityLevel#, #Session.IDTPurchasingSystem#) GTE 30 AND ListGetAt(#Client.SecurityLevel#, #Session.IDTPurchasingSystem#) LTE 35>
			<CFSET Client.MaintFlag="No">
			<CFSET Client.MaintLessFlag="Yes">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.IDTPurchasingSystem#) GTE 36 AND ListGetAt(#Client.SecurityLevel#, #Session.IDTPurchasingSystem#) LTE 39>
			<CFSET Client.MaintFlag="Yes">
			<CFSET Client.MaintLessFlag="No">
		</CFIF>
	<CFELSE>
		<CFOUTPUT><h4>The user is not Validated for Login to the IDT Purchasing Application. &nbsp;&nbsp;Click OK to return to your previous page.</h4></CFOUTPUT>
		<script language="JavaScript">
			<!-- 
				alert("The user is not Validated for Login to the IDT Purchasing Application.  Click OK to return to your previous page.");
			--> 
		</script>
		<CFOUTPUT>
			<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES" />
		</CFOUTPUT>
	</CFIF>
</CFIF>

<CFINCLUDE template="../SQLInjectionProtectionCode.cfm">