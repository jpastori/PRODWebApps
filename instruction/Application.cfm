<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: Application.cfm.--->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/20/2008 --->
<!--- Date in Production: 08/20/2008 --->
<!--- Module: Instruction Oracle Web Application --->
<!-- Last modified by John R. Pastori on 08/20/2008 using ColdFusion Studio: -->

<CFAPPLICATION name="LIBRARYWEBAPPS" clientmanagement="Yes" clientstorage="PRODLIBSHAREDDATA" sessionmanagement="Yes" setclientcookies="Yes" scriptprotect="all">


<CFINCLUDE template="../SQLInjectionIPBlackListProcess.cfm">

<!--- ****************************************************** --->
<!--- ******** Start Normal Application Processing. ******** --->
<!--- ****************************************************** --->


<!--- 	By default, the user is not logged in --->

<CFIF NOT IsDefined("application.instruct_initialized") OR (IsDefined('URL.ACCESSINGAPPFIRSTTIME') AND URL.ACCESSINGAPPFIRSTTIME EQ "YES" AND Client.ACCESSINGINSTRUCTION EQ "NO")>
	<CFSET application.instruct_initialized = 0>
<!--- 
	 We are now going to include a file that defines some site-wide variables. 
	 Notice how we check for application.initialized. globalvariables.cfm will set this value
	 to true at the end of the file. This is cool because it means the variables will only be 
	 initialized once, which is all we need if you think about it. 
	 This is a little performance trick that will make the apps run a bit faster.
 --->
	<CFINCLUDE template="instruct_global_variables.cfm">
	<CFIF FIND('forms', #CGI.HTTP_REFERER#, 1) EQ 0 AND FIND('coiil', #CGI.HTTP_REFERER#, 1) EQ 0>
		<CFSET Session.InstructionSystem = LISTFIND(#Client.ValidatedSystems#, 1000)>
		<!--- <CFOUTPUT><BR>SYSTEM NUMBER = 1000<BR></CFOUTPUT> --->
		<CFIF #Session.InstructionSystem# GT 0>
			<CFIF ListGetAt(#Client.SecurityLevel#, #Session.InstructionSystem#) LTE 20>
				<CFSET Client.ProcessFlag="No">
				<CFSET Client.DeleteFlag="No">
				<CFSET Client.SecurityFlag="No">
				<CFSET Client.MaintFlag="No">
				<CFSET Client.MaintLessFlag="No">
			<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.InstructionSystem#) GT 20 AND ListGetAt(#Client.SecurityLevel#, #Session.InstructionSystem#) LTE 30>
				<CFSET Client.ProcessFlag = "Yes">
				<CFSET Client.DeleteFlag = "No">
				<CFSET Client.SecurityFlag = "No">
			<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.InstructionSystem#) GT 30 AND ListGetAt(#Client.SecurityLevel#, #Session.InstructionSystem#) LT 40>
				<CFSET Client.ProcessFlag = "Yes">
				<CFSET Client.DeleteFlag = "Yes">
				<CFSET Client.SecurityFlag = "No">
			<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.InstructionSystem#) GTE 40>
				<CFSET Client.ProcessFlag="Yes">
				<CFSET Client.DeleteFlag="Yes">
				<CFSET Client.MaintFlag="Yes">
				<CFSET Client.SecurityFlag="Yes">
			</CFIF>
				<CFIF ListGetAt(#Client.SecurityLevel#, #Session.InstructionSystem#) GTE 30 AND ListGetAt(#Client.SecurityLevel#, #Session.InstructionSystem#) LTE 35>
				<CFSET Client.MaintFlag="No">
				<CFSET Client.MaintLessFlag="Yes">
			<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.InstructionSystem#) GTE 36 AND ListGetAt(#Client.SecurityLevel#, #Session.InstructionSystem#) LTE 39>
				<CFSET Client.MaintFlag="Yes">
				<CFSET Client.MaintLessFlag="No">
			</CFIF>
		<CFELSE>
			<CFOUTPUT><H4>The user is not Validated for Login to the Instruction Application. &nbsp;&nbsp;Click OK to return to your previous page.</H4></CFOUTPUT>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("The user is not Validated for Login to the Instruction Application.  Click OK to return to your previous page.");
				--> 
			</SCRIPT>
			<CFOUTPUT>
				<META http-equiv="Refresh" content="0; URL=/#application.type#apps/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES" />
			</CFOUTPUT>
		</CFIF>
	</CFIF>
</CFIF>

<CFINCLUDE template="../SQLInjectionProtectionCode.cfm">