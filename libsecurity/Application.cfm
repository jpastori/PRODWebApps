<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: Application.cfm.--->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/20/2008 --->
<!--- Date in Production: 08/20/2008 --->
<!--- Module: Library Security Oracle Web Application --->
<!-- Last modified by John R. Pastori on 08/20/2008 using ColdFusion Studio: -->

<CFAPPLICATION name="LIBRARYWEBAPPS" clientmanagement="Yes" clientstorage="PRODLIBSHAREDDATA" sessionmanagement="Yes" setclientcookies="Yes" scriptprotect="all">

<CFINCLUDE template="../SQLInjectionIPBlackListProcess.cfm">

<!--- ****************************************************** --->
<!--- ******** Start Normal Application Processing. ******** --->
<!--- ****************************************************** --->


<!--- 	By default, the user is not logged in --->

<CFIF NOT IsDefined("application.libsec_initialized") OR (IsDefined('URL.ACCESSINGAPPFIRSTTIME') AND URL.ACCESSINGAPPFIRSTTIME EQ "YES" AND Client.ACCESSINGLIBSECURITY EQ "NO")>
	<CFSET application.libsec_initialized = 0>
<!--- We are now going to include a file that defines some site-wide variables. Notice how we check for application.initialized. globalvariables.cfm will set this value 	to true at the end of the file. This is cool because it means the variables will only be initialized once, which is all we need if you think about it. This is a little performance trick that will make the apps run a bit faster. --->
	<CFINCLUDE template="libsec_global_variables.cfm">
	<CFSET Sesson.LibSecuritySystem = LISTFIND(#Client.ValidatedSystems#, 600)>
	<CFIF #Sesson.LibSecuritySystem# GT 0>
		<CFIF ListGetAt(#Client.SecurityLevel#, #Sesson.LibSecuritySystem#) GTE 40>
			<CFSET Client.ProcessFlag="Yes">
			<CFSET Client.DeleteFlag="Yes">
			<CFSET Client.SecurityFlag="Yes">
		<CFELSE>
			<CFOUTPUT><H4>The user is not Validated for Login to the Library Security Application</H4></CFOUTPUT>
			<CFSET Client.LoggedIn="No">
			<CFSET application.libsec_initialized=0>
			<CFSET application.initialized=0>
			<CFINCLUDE template="../logon_form.cfm">
			<CFABORT>
		</CFIF>
	<CFELSE>
		<CFOUTPUT><H4>The user is not Validated for Login to the Library Security Application. &nbsp;&nbsp;Click OK to return to your previous page.</H4></CFOUTPUT>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("The user is not Validated for Login to the Library Security Application.  Click OK to return to your previous page.");
			--> 
		</SCRIPT>
		<CFOUTPUT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES" />
		</CFOUTPUT>
	</CFIF>
</CFIF>

<CFINCLUDE template="../SQLInjectionProtectionCode.cfm">