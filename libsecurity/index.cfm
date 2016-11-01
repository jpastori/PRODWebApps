<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2011 --->
<!--- Date in Production: 06/23/2011 --->
<!--- Module: Library Security Application Home Page--->
<!-- Last modified by John R. Pastori on 06/23/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libsecurity/index.cfm">
<CFSET CONTENT_UPDATED = "June 23, 2011">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>libsecurity Application</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

	<SCRIPT language="JavaScript">
		<!--
			if (window.history.forward(1) != null) {
				window.history.forward(1); 
			}

		//-->
	</SCRIPT>

</HEAD>

<BODY>

<CFOUTPUT>
<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/libsecurity">

<!--- APPLICATION ACCESS VARIABLES --->
<CFSET URL.ACCESSINGAPPFIRSTTIME = "NO">
<CFSET Client.ACCESSINGCONFIGMGMT = "NO">
<CFSET Client.ACCESSINGFACILITIES = "NO">
<CFSET Client.ACCESSINGHARDWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGIDTCHATTER = "NO">
<CFSET Client.ACCESSINGINSTRUCTION = "NO">
<CFSET Client.ACCESSINGLIBQUAL = "NO">
<CFSET Client.ACCESSINGLIBSECURITY = "YES">
<CFSET Client.ACCESSINGLIBSHAREDDATA = "NO">
<CFSET Client.ACCESSINGLIBSTATS = "NO">
<CFSET Client.ACCESSINGPURCHASING = "NO">
<CFSET Client.ACCESSINGSERVICEREQUESTS = "NO">
<CFSET Client.ACCESSINGSOFTWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGSPECIALCOLLECTIONS = "NO">
<CFSET Client.ACCESSINGWEBREPORTS = "NO">

<CFINCLUDE template="/include/coldfusion/header.cfm">

<!--- SET COOKIE VARIABLES --->
<CFCOOKIE name="CUSTAPPACCESSID" secure="NO" expires="NOW">
<CFCOOKIE name="DBSYSTEMID" secure="NO" expires="NOW">
<CFCOOKIE name="SECURITYLEVELID" secure="NO" expires="NOW">

<TABLE width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD align="center" valign="middle"><H1>Library Security Application</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" width="100%" cellspacing="0" cellpadding="4">
	<CFINCLUDE template="../IDTApplicationLinks.cfm">
	
	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">
			SECURITY ACCESS PROCESSING
		</TH>
	</CFIF>
		<TH align="LEFT" valign="top">
			SECURITY ACCESS REPORTS
		</TH>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			Customer Application Access - <A href="/#application.type#apps/libsecurity/customerappaccess.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libsecurity/customerappaccess.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Customer Application Access - <A href="/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=MODIFYLOOP">Modify/Delete Loop</A> or
			<A href="/#application.type#apps/libsecurity/custappaccmultipledel.cfm">Multiple Delete</A><BR /><BR />
			Customer Password - <A href="/#application.type#apps/libsecurity/encryptcustomerpasswords.cfm?CHANGE=SINGLE">Reset </A><BR />
			Global Password - <A href="/#application.type#apps/libsecurity/encryptcustomerpasswords.cfm?CHANGE=ALL">Reset </A><BR /><BR />
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/libsecurity/customerappaccessdbreport.cfm">Customer Application Access</A><BR />
		</TD>
	</TR>

	<TR>
		<TH align="LEFT" valign="top">SUPPORT FILE PROCESSING</TH>
		<TH align="LEFT" valign="top">SUPPORT FILE REPORTS</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			Database Systems Info - <A href="/#application.type#apps/libsecurity/dbsystemsinfo.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libsecurity/dbsystemsinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Security Levels Info - <A href="/#application.type#apps/libsecurity/securitylevelsinfo.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libsecurity/securitylevelsinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR /><BR />
		</TD>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/libsecurity/dbsystemsdbreport.cfm">Database Systems</A><BR />
			<A href="/#application.type#apps/libsecurity/securitylevelsdbreport.cfm">Security Levels</A><BR /><BR />
		</TD>
	</TR>

	<CFINCLUDE template="../LibraryApplicationLinks.cfm">

</TABLE>

<CFINCLUDE template="/include/coldfusion/footer.cfm">
</CFOUTPUT>

</BODY>
</HTML>