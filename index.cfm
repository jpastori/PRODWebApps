<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/05/2012 --->
<!--- Date In Production: 07/05/2012 --->
<!--- Module: LOVE Library Oracle Intranet System Home Page--->
<!-- Last modified by John R. Pastori on 06/30/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/index.cfm">
<cfset CONTENT_UPDATED = "June 30, 2016">

<cfoutput>
<html>
<head>
<cfif IsDefined('NUMDAYS') AND #NUMDAYS# GT 365>
	<script language="JavaScript">
		<!-- 
			alert("Your password has expired!  It has been more than 365 days since you changed it.");
		--> 
	</script>
	<cfset FORM.CHANGEPASSWORD = 'YES'>
</cfif>
<cfif IsDefined('FORM.CHANGEPASSWORD')>

	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/libsecurity/passwordchange.cfm?CUSTOMER=#FORM.CUSTOMERID#" />
	<cfexit>

</cfif>

<cfif IsDefined('URL.logout') AND #URL.logout# EQ "Yes">
	<cfset Client.LoggedIn="No">
	<cfinclude template="logon_form.cfm">
	<cfabort>
</cfif>


	<title>Library's LFOLKS Intranet System</title>
	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="Fri, 01 Jan 1999 00:00:01 GMT" />
	<!--- Global CSS --->
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

</head>

<body>
<cfcookie name="INDEXDIR" secure="NO" value="/#application.type#apps/">

<!--- APPLICATION ACCESS VARIABLES --->
<cfset URL.ACCESSINGAPPFIRSTTIME = "YES">
<cfset Client.ACCESSINGCONFIGMGMT = "NO">
<cfset Client.ACCESSINGFACILITIES = "NO">
<cfset Client.ACCESSINGHARDWAREINVENTORY = "NO">
<cfset Client.ACCESSINGIDTCHATTER = "NO">
<cfset Client.ACCESSINGINSTRUCTION = "NO">
<cfset Client.ACCESSINGLIBQUAL = "NO">
<cfset Client.ACCESSINGLIBSECURITY = "NO">
<cfset Client.ACCESSINGLIBSHAREDDATA = "NO">
<cfset Client.ACCESSINGLIBSTATS = "NO">
<cfset Client.ACCESSINGPURCHASING = "NO">
<cfset Client.ACCESSINGSERVICEREQUESTS = "NO">
<cfset Client.ACCESSINGSOFTWAREINVENTORY = "NO">
<cfset Client.ACCESSINGSPECIALCOLLECTIONS = "NO">
<cfset Client.ACCESSINGWEBREPORTS = "NO">

<cfset SESSION.ORIGINSERVER = "">
<cfset SESSION.RETURNPGM = "">

<table width="100%" cellspacing="0" cellpadding="0" border="0">
	<tr align="LEFT">
		<td align="Left" >
			<cfinclude template="/include/coldfusion/header.cfm">
		</td>
		<td align="LEFT">
			You are logged in as #Client.Name#.<br />
			<b><a href="index.cfm?logout=Yes">Log Out</a></b>
		</td>
	</tr>
</table>

<table width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td align="center" valign="TOP"><h1>Applications, Forms and Resources</h1></td>
	</tr>
</table>

<cfset SYSTEMACCESSFLAG = "">
<cfquery name="ListIDTDatabaseSystems" datasource="#application.type#LIBSECURITY" blockfactor="12">
     SELECT	DBSYSTEMID, DBSYSTEMNUMBER, DBSYSTEMNAME, DBSYSTEMDIRECTORY, DBSYSTEMGROUP
     FROM		DBSYSTEMS
     WHERE	DBSYSTEMID > 0 AND
               DBSYSTEMGROUP = 'IDT'
     ORDER BY	DBSYSTEMNAME
</cfquery>

<cfquery name="ListLIBDatabaseSystems" datasource="#application.type#LIBSECURITY" blockfactor="12">
     SELECT	DBSYSTEMID, DBSYSTEMNUMBER, DBSYSTEMNAME, DBSYSTEMDIRECTORY, DBSYSTEMGROUP
     FROM		DBSYSTEMS
     WHERE	DBSYSTEMID > 0 AND
               DBSYSTEMGROUP = 'LIB'
     ORDER BY	DBSYSTEMNAME
</cfquery>

<br>

<cfif Client.CUSTOMERID EQ 501 or Client.CUSTOMERID EQ 162>
<table width="100%" cellspacing="0" cellpadding="0" border="0">
	<tr>
		<td align="Left" valign="top" >
			<h2><em>Personal Application Pages</em></h2>
          </td>
	</tr>
     <tr>
		<td align="Left" valign="top" >
			<a href="/#application.type#apps/servicerequests/joelssrindex.cfm"><strong><font color="##0FCFE7">Joel's Personal Service Request Application Page</font></strong></a><br>
          </td>
	</tr>
</table>
</cfif>

<br><br>

<table width="100%" cellspacing="0" cellpadding="0" border="0">
<cfif Client.SecurityLevel GT 10>
	<tr>
		<td align="Left" valign="top" >
			<h2><em>IDT Applications</em></h2>
			<br><br>
          	<cfloop query="ListIDTDatabaseSystems">
               
                    <cfset SYSTEMACCESSFLAG = "Client.ACCESSING" & #UCase(ListIDTDatabaseSystems.DBSYSTEMDIRECTORY)#>
                    <cfif LISTFIND(#Client.ValidatedSystems#, #ListIDTDatabaseSystems.DBSYSTEMNUMBER#) GT 0 >
                         <a href="/#application.type#apps/#ListIDTDatabaseSystems.DBSYSTEMDIRECTORY#/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES">#ListIDTDatabaseSystems.DBSYSTEMNAME#</a><br>
                    </cfif>
                    
               </cfloop>
		<cfif #Client.SecurityFlag# EQ "Yes">
			<a href="/#application.type#apps/libsecurity/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES">Library Web Apps Security</a><br />
		</cfif>
		</td>
		<td align="Left" valign="top" >
			<h2><em>Library Applications</em></h2>
			<br><br>
			<cfloop query="ListLIBDatabaseSystems">
               
                    <cfset SYSTEMACCESSFLAG = "Client.ACCESSING" & #UCase(ListLIBDatabaseSystems.DBSYSTEMDIRECTORY)#>
                    <cfif LISTFIND(#Client.ValidatedSystems#, #ListLIBDatabaseSystems.DBSYSTEMNUMBER#) GT 0 AND #EVALUATE(SYSTEMACCESSFLAG)# EQ "NO">
                         <a href="/#application.type#apps/#ListLIBDatabaseSystems.DBSYSTEMDIRECTORY#/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES">#ListLIBDatabaseSystems.DBSYSTEMNAME#</a><br>
                    </cfif>
                    
               </cfloop>
		</td>
	</tr>
	<tr>
		<td colspan="2"><hr /></td>
	</tr>
</cfif>
	<cfquery name="LookupIDTStaff" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, U.UNITID, U.GROUPID
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.UNITID = U.UNITID AND
				U.GROUPID = 4
		ORDER BY	FULLNAME
	</cfquery>
	<tr>
		<td valign="top">
			<big><strong><a href="/#application.type#apps/idtcustomer/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=NO"><h3>IDT Customer Resources</h3></a></strong></big><br />
			<a href="/#application.type#apps/idtcustomer/index.cfm##How"> How to.. Steps</a>,
			<a href="/#application.type#apps/idtcustomer/index.cfm##Tips"> Tips</a>,
			<a href="/#application.type#apps/idtcustomer/index.cfm##Tools"> Tools</a>, 
			<a href="/#application.type#apps/idtcustomer/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=NO"> More...</a><br><br>
		<cfif #LookupIDTStaff.RecordCount# GT 0>
			<big><strong><a href="/#application.type#apps/idtops/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=NO"><h3>INFOSYS Operations Manual</h3></a></strong></big><br />
			<a href="/#application.type#apps/idtops/indexcs.cfm"> Copy</a>,
			<a href="/#application.type#apps/idtops/indexmc.cfm"> MC</a>,
			<a href="/#application.type#apps/idtops/indexpac.cfm"> PAC</a>,
			<a href="/#application.type#apps/idtops/indexsans.cfm"> SANS/ACS</a>, 
			<a href="/#application.type#apps/idtops/indexscc.cfm"> SCC</a>,
			<a href="/#application.type#apps/idtops/indexti.cfm"> TI</a>
		</cfif>
		<br><br>
		</td>
		<td valign="top">
			<big><strong><a href="/#application.type#apps/forms/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=NO"><h3>Forms</h3></a></strong></big>
			<br />
			<a href="/#application.type#apps/webreports/absencerequest.cfm?PROCESS=ADD"> Absence Request Add</a>,
			<a href="http://bfa.sdsu.edu/ap/forms.htm##travelforms">Travel Request</a>, 
			<a href="/#application.type#apps/forms/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=NO">More...</a>
		</td>
 	</tr>
</table>

<cfinclude template="/include/coldfusion/footer.cfm">

</body>
</html>
</cfoutput>