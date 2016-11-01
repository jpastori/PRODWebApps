<!--- Program: SQLInjectionIPBlackListProcess.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/19/2012 --->
<!--- Date in Production: 09/19/2012 --->
<!--- Module: Application ColdFusion SQL Injection IP BlackList Process --->
<!-- Last modified by John R. Pastori on 12/18/2014 using ColdFusion Studio. -->
<!-- Added Carol Phillips' Home IP address to be bypassed for injection checking. - 10/02/2014 - JRP -->
<!-- Added 130.191.26 subnet to be bypassed for injection checking. - 12/18/2014 - JRP -->


<!--- ******************************************************** --->
<!--- ******** Protect against SQL Injection Attacks. ******** --->
<!--- ******************************************************** --->

<!--- ****************************************************** --->
<!--- Stop processing if the current IP is in the blacklist.
	  IP automatically gets put in the blacklist when it 
	  attempts a SQL injection attack. It does not execute 
	  this code if the file that is being executed is called
	  ipBlackListUnlock.cfm (needed to remove IPs out of the 
	  blacklist [in case you lock yourself out]) --->
<!--- ****************************************************** --->
<CFIF ISDEFINED("APPLICATION.ipBlackList") AND CGI.PATH_INFO NEQ "/ipBlackListUnlock.cfm" AND LEFT(CGI.REMOTE_ADDR, 10) NEQ '130.191.17' AND LEFT(CGI.REMOTE_ADDR, 10) NEQ '130.191.26' AND LEFT(CGI.REMOTE_ADDR, 11) NEQ '130.191.104' AND LEFT(CGI.REMOTE_ADDR, 11) NEQ '130.191.106' AND CGI.REMOTE_ADDR NEQ '146.244.137.189' AND CGI.REMOTE_ADDR NEQ '98.176.2.148'>
	<CFLOOP from="1" to="#arrayLen(APPLICATION.ipBlackList)#" index="currPosition">
		<CFIF APPLICATION.IPBLACKLIST[CURRPOSITION].ARRAYIP EQ CGI.REMOTE_ADDR>
			<CFABORT>
		</CFIF>
	</CFLOOP>
</CFIF>

<!--- *********************************************************** --->
<!--- Call CFC function to validate if there is any SQL Injection --->
<!--- *********************************************************** --->

<CFIF LEFT(CGI.REMOTE_ADDR, 10) NEQ '130.191.17' AND LEFT(CGI.REMOTE_ADDR, 10) NEQ '130.191.26' AND LEFT(CGI.REMOTE_ADDR, 11) NEQ '130.191.104' AND LEFT(CGI.REMOTE_ADDR, 11) NEQ '130.191.106' AND CGI.REMOTE_ADDR NEQ '146.244.137.189' AND CGI.REMOTE_ADDR NEQ '98.176.2.148'>
	<CFINVOKE component="components.SQLInjection" method="SQL_injection" returnvariable="messageError" FORM="#FORM#" URL="#URL#" IPADDRESS="#CGI.REMOTE_ADDR#"/>
</CFIF>

<!--- ****************************************************** --->
<!--- If the CFC returned an error message, place the hacker's 
	  IP Address in the blacklist, display the error message
	  and abort the processing of the page  --->
<!--- ****************************************************** --->
<CFIF ISDEFINED("messageError") AND MESSAGEERROR NEQ "" AND LEFT(CGI.REMOTE_ADDR, 10) NEQ '130.191.17' AND LEFT(CGI.REMOTE_ADDR, 10) NEQ '130.191.26'>
	<!--- Create a new application array to allocate ip's where injection came from --->
	<CFPARAM name="APPLICATION.ipBlackList" type="array" default="#ArrayNew( 1 )#"/>
	<CFSET VARIABLES.COUNTER = INCREMENTVALUE(ARRAYLEN(APPLICATION.IPBLACKLIST))>
	<CFSET APPLICATION.IPBLACKLIST[VARIABLES.COUNTER] = STRUCTNEW()>
	<CFSET APPLICATION.IPBLACKLIST[VARIABLES.COUNTER].ARRAYIP = CGI.REMOTE_ADDR>
	<CFSET APPLICATION.IPBLACKLIST[VARIABLES.COUNTER].ARRAYTIME = NOW()>
	<!--- Display the error message --->
	<HTML>
	<HEAD>
		<TITLE>There was a problem with the page request.</TITLE>
	</HEAD>	
	<BODY>	
	<CFOUTPUT>#VARIABLES.messageError#</CFOUTPUT>
	</BODY>
	</HTML>
	<!--- Abort page processing --->
	<CFABORT>
</CFIF>