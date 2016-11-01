<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: Application.cfm.--->
<!--- Date: 08/10/2003 --->
<!--- Module: Library Shared Data Oracle Web Application --->
<!-- Last modified by John R. Pastori on 08/10/2003 using ColdFusion Studio: -->

<CFAPPLICATION NAME="LIBRARYWEBAPPS" CLIENTMANAGEMENT="Yes" CLIENTSTORAGE="DEVLIBSHAREDDATA" SESSIONMANAGEMENT="Yes" SETCLIENTCOOKIES="Yes">

<!--- 	By default, the user is not logged in --->

<CFIF NOT IsDefined("application.libshareddata_initialized") OR (IsDefined('URL.ACCESSINGAPPFIRSTTIME') AND URL.ACCESSINGAPPFIRSTTIME EQ "YES" AND Client.ACCESSINGISTEQUIPINVENTORY EQ "NO")>
	<CFSET application.libshareddata_initialized = 0>
<!--- We are now going to include a file that defines some site-wide variables. Notice how we check for application.initialized. globalvariables.cfm will set this value 	to true at the end of the file. This is cool because it means the variables will only be initialized once, which is all we need if you think about it. This is a little performance trick that will make the apps run a bit faster. --->
	<CFINCLUDE TEMPLATE="libshareddata_global_variables.cfm">
	<CFSET Sesson.LibSharedDataSystem = LISTFIND(#Client.ValidatedSystems#, 700)
		<CFOUTPUT><BR>SYSTEM INDEX = #Sesson.LibSharedDataSystem#<BR></CFOUTPUT>
		<CFIF #Sesson.LibSharedDataSystem# GT 0>
			<CFIF ListGetAt(#Client.SecurityLevel#, #Sesson.LibSharedDataSystem#) LT 20>
				<CFSET Client.AdminFlag="No">
				<CFSET Client.DeleteFlag="No"><br><br><br>
			<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Sesson.LibSharedDataSystem#) GTE 20 AND ListGetAt(#Client.SecurityLevel#, #Sesson.LibSharedDataSystem#) LT 30>
				<CFSET Client.AdminFlag="Yes">
				<CFSET Client.DeleteFlag="No">
			<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Sesson.LibSharedDataSystem#) GTE 30>
				<CFSET Client.AdminFlag="Yes">
				<CFSET Client.DeleteFlag="Yes">
				<CFSET Client.SecurityFlag="Yes">
			</CFIF>
		<CFELSE>
			<cfoutput><h4>The user is not Validated for Login to the Library Shared Data Application. &nbsp;&nbsp;Click OK to return to your previous page.</h4></cfoutput>
			<SCRIPT LANGUAGE="JavaScript">
				<!-- 
					alert("The user is not Validated for Login to the Library Shared Data Application.  Click OK to return to your previous page.");
				--> 
			</SCRIPT>
			<META HTTP-EQUIV="Refresh" CONTENT="1; URL=#CGI.HTTP_REFERER#">
		</CFIF>
</CFIF>