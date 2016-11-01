<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: Application.cfm.--->
<!--- Date Written: 10/25/2012 --->
<!--- Date in Production: 10/25/2012 --->
<!--- Module: LOVE Library Oracle Web Applications --->
<!-- Last modified by John R. Pastori on 01/08/2015 using ColdFusion Studio: -->

<CFAPPLICATION name="LIBRARYWEBAPPS" clientmanagement="Yes" clientstorage="PRODLIBSHAREDDATA" sessionmanagement="Yes" setclientcookies="Yes" scriptprotect="all">

<CFINCLUDE template="SQLInjectionIPBlackListProcess.cfm">

<!--- ******** Start Normal Application Processing. ******** --->
<!--- ****************************************************** --->

<CFSET ADDITIONALINFO=Server.OS.AdditionalInformation>
<!--- <CFOUTPUT>ADDITIONALINFO = #ADDITIONALINFO#<br></CFOUTPUT> --->

<!--- 	By default, the user is not logged in --->
<CFPARAM name="Client.LoggedIn" default="No">
<CFIF NOT IsDefined("application.initialized") OR Client.LoggedIn EQ "No">
	<!--- <cfoutput>SET APPLICATION.INITIALIZED TO ZERO<br></cfoutput> --->
	<CFSET application.initialized = 0>
</CFIF>

<!--- 	We are now going to include a file that defines some site-wide variables. Notice how we check for application.initialized. globalvariables.cfm will set this value to true at the end of the file. This is cool because it means the variables will only be initialized once, which is all we need if you think about it. This is a little performance trick that will make the apps run a bit faster. --->
<CFIF application.initialized EQ 0 OR (IsDefined("URL.logout") AND #URL.logout# EQ "Yes")>
	<!--- <cfoutput>SET GLOBAL VARIABLES<br></cfoutput> --->
	<CFINCLUDE template="global_variables.cfm">
</CFIF>

<!--- Are we logging into the application? --->
<CFIF IsDefined("Form.LoggingOn") AND #Form.LoggingOn# EQ 1>
	<!--- <cfoutput>CHECK FOR VALID USER<br></cfoutput> --->
	<!--- Check to see if valid --->
	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, FULLNAME, PASSWORD, ACTIVE, SEEDKEY
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				PASSWORD IS NOT NULL AND
				ACTIVE = 'YES'
		ORDER BY	FULLNAME
	</CFQUERY>

 	<CFIF FIND('$', #ListCustomers.SEEDKEY#, 1) NEQ 0>
		<CFSET FORM.SEEDKEY = ListChangeDelims(ListCustomers.SEEDKEY, "'", "$")>
		<CFSET NUMDAYS = DATEDIFF("d", #FORM.SEEDKEY#, NOW())>
	<CFELSE>
		<CFSET NUMDAYS = 366>
	</CFIF>
	<!--- <CFOUTPUT>NUMBER OF DAYS = #NUMDAYS#</CFOUTPUT> --->

	<CFSET FORM.PASSWORD = ENCRYPT(#FORM.PASSWORD#, #ListCustomers.SEEDKEY#)> 

	<CFQUERY name="CheckUser" datasource="#application.type#LIBSECURITY">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, 
				CAA.DBSYSTEMID, DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME,
				CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER, SL.SECURITYLEVELNAME
		FROM		CUSTOMERAPPACCESS CAA, DBSYSTEMS DBS, SECURITYLEVELS SL, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	CAA.CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.PASSWORD = '#FORM.PASSWORD#' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID
		ORDER BY	CUST.FULLNAME, DBS.DBSYSTEMNUMBER
	</CFQUERY>

	<!--- Every query contains an element called "recordcount" which tells us how many rows are returned.  Iin this case we are checking to see if a user matched the validation query above. 	 	if the recordcount is 0 (no match in the database), the cfif statement 	below will be false, and the user will not be logged in.  Any number other than 0 is seen as true. 	 --->
	<CFIF CheckUser.RecordCount NEQ 0>
		<!--- <cfoutput>USER RECORD FOUND<br></cfoutput> --->
		<CFSET Client.LoggedIn = "Yes">
		<CFSET Client.CUSTOMERID = #CheckUser.CUSTOMERID#>
		<CFSET Client.ValidatedSystems = #ValueList(CheckUser.DBSYSTEMNUMBER)#>
		<CFSET Client.SecurityLevel = #ValueList(CheckUser.SECURITYLEVELNUMBER)#>
		<CFSET Client.Name = #CheckUser.FULLNAME#>
		<!--- <cfoutput><br><br>VALDATED SYSTEMS = #Client.ValidatedSystems#<br>
		      &nbsp;&nbsp;SECURTY LEVEL = #Client.SecurityLevel#<br></cfoutput> --->
	<CFELSE>
		<CFOUTPUT>
			User not found. Try again.
		</CFOUTPUT>
		<CFSET Client.LoggedIn = "No">
		<CFSET application.initialized = 0>
		<CFINCLUDE template = "logon_form.cfm">
		<CFABORT>
	</CFIF>
	<!--- 	Include the login form if the user is not logged in.  --->
<CFELSE>
	<CFIF #Client.LoggedIn# EQ "No">
		<!--- <cfoutput>FIRST LOGIN ATTEMPT - MESSAGE-1<br></cfoutput> --->
		<CFSET URL.logout = "Yes">
		<CFSET application.initialized = 0>
		<CFSET Form.LoggingOn = 0>
		<CFINCLUDE template = "logon_form.cfm"> 
		<CFABORT>
	</CFIF>
</CFIF>
<CFIF IsDefined("Client.ValidatedSystems")>
	<CFSET Session.LoginSystem = LISTFIND(#Client.ValidatedSystems#, 50)>
	<CFIF Client.LoggedIn EQ "Yes" AND #Session.LoginSystem# GT 0>
		<!--- <cfoutput>VALIDATING SYSTEM ACCESS<br></cfoutput> --->
		<CFIF ListGetAt(#Client.SecurityLevel#, #Session.LoginSystem#) LTE 20>
			<CFSET Client.ProcessFlag = "No">
			<CFSET Client.DeleteFlag = "No">
               <CFSET Client.MaintFlag = "No">
			<CFSET Client.SecurityFlag = "No">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.LoginSystem#) GT 20 AND ListGetAt(#Client.SecurityLevel#, #Session.LoginSystem#) LT 36>
			<CFSET Client.ProcessFlag = "Yes">
			<CFSET Client.DeleteFlag = "No">
               <CFSET Client.MaintFlag = "No">
			<CFSET Client.SecurityFlag = "No">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.LoginSystem#) GTE 36 AND ListGetAt(#Client.SecurityLevel#, #Session.LoginSystem#) LT 40>
			<CFSET Client.ProcessFlag = "Yes">
			<CFSET Client.DeleteFlag = "Yes">
			<CFSET Client.MaintFlag = "Yes">
			<CFSET Client.SecurityFlag = "No">
		<CFELSEIF ListGetAt(#Client.SecurityLevel#, #Session.LoginSystem#) GTE 40>
			<CFSET Client.ProcessFlag = "Yes">
			<CFSET Client.DeleteFlag = "Yes">
               <CFSET Client.MaintFlag = "Yes">
			<CFSET Client.SecurityFlag = "Yes">
		</CFIF>
	<CFELSE>
		<CFOUTPUT><H4>The user is not Validated for Login to this System</H4></CFOUTPUT>
		<CFSET Client.LoggedIn = "No">
		<CFSET application.initialized = 0>
		<CFINCLUDE template = "logon_form.cfm">
		<CFABORT>
	</CFIF>
<CFELSE>
	<!--- <cfoutput>FIRST LOGIN ATTEMPT - MESSAGE-2<br></cfoutput> --->
	<CFSET URL.logout = "Yes">
	<CFSET Client.LoggedIn = "No">
	<CFSET application.initialized = 0>
	<CFINCLUDE template = "logon_form.cfm">
	<CFABORT>
</CFIF>

<CFINCLUDE template="SQLInjectionProtectionCode.cfm">