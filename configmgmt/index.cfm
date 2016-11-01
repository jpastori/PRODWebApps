<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2011 --->
<!--- Date in Production: 06/23/2011 --->
<!--- Module: Library IDT Configuration Management Database Home Page--->
<!-- Last modified by John R. Pastori on 06/23/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/configmgmt/index.cfm">
<CFSET CONTENT_UPDATED = "June 23, 2011">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Configuration Management</TITLE>
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
<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/configmgmt">

<!--- APPLICATION ACCESS VARIABLES --->
<CFSET URL.ACCESSINGAPPFIRSTTIME = "NO">
<CFSET Client.ACCESSINGCONFIGMGMT = "YES">
<CFSET Client.ACCESSINGFACILITIES = "NO">
<CFSET Client.ACCESSINGHARDWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGIDTCHATTER = "NO">
<CFSET Client.ACCESSINGINSTRUCTION = "NO">
<CFSET Client.ACCESSINGLIBQUAL = "NO">
<CFSET Client.ACCESSINGLIBSECURITY = "NO">
<CFSET Client.ACCESSINGLIBSHAREDDATA = "NO">
<CFSET Client.ACCESSINGLIBSTATS = "NO">
<CFSET Client.ACCESSINGPURCHASING = "NO">
<CFSET Client.ACCESSINGSERVICEREQUESTS = "NO">
<CFSET Client.ACCESSINGSOFTWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGSPECIALCOLLECTIONS = "NO">
<CFSET Client.ACCESSINGWEBREPORTS = "NO">

<CFINCLUDE template="/include/coldfusion/header.cfm">

<!--- SET COOKIE VARIABLES --->
<CFCOOKIE name="FUNDACCTID" secure="NO" expires="NOW">
<CFCOOKIE name="LICENSESTATUSID" secure="NO" expires="NOW">
<CFCOOKIE name="ORGCODEID" secure="NO" expires="NOW">
<CFCOOKIE name="PURCHREQID" secure="NO" expires="NOW">
<CFCOOKIE name="PURCHREQLINEID" secure="NO" expires="NOW">
<CFCOOKIE name="PRLSWSERIALNUMID" secure="NO" expires="NOW">
<CFCOOKIE name="STATEID" secure="NO" expires="NOW">
<CFCOOKIE name="VENDORID" secure="NO" expires="NOW">
<CFCOOKIE name="VENDORCONTACTID" secure="NO" expires="NOW">

<TABLE width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD align="center"><H1>IDT Configuration Management Application</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" width="100%" cellspacing="0" cellpadding="4">
	<CFINCLUDE template="../IDTApplicationLinks.cfm">

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">CONFIGURATION MANAGEMENT PROCESSING</TH>
	</CFIF>
		<TH align="LEFT" valign="top">CONFIGURATION MANAGEMENT REPORTS</TH>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			Configuration Mgmt Request - <A href="/#application.type#apps/configmgmt/configmgmtrequests.cfm?PROCESS=ADD"> Add</A> or
			<A href="/#application.type#apps/configmgmt/configmgmtrequests.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR /><BR />
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/configmgmt/configmgmtdbreport.cfm"> Configuration Mgmt Request </A> Report
		</TD>
	</TR>

<!---
	<CFIF #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
	<TR>
		<TH align="LEFT" valign="top">SUPPORT FILE PROCESSING</TH>
		<TH align="LEFT" valign="top">SUPPORT FILE REPORTS</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			<!--Fund Accounts - <A href="/#application.type#apps/configmgmt/fundaccts.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/configmgmt/fundaccts.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR /> -->
		</TD>
		<TD align="LEFT" valign="top">
			<!--<A href="/#application.type#apps/configmgmt/fundacctsdbreport.cfm">Fund Accounts</A><BR /> -->
		</TD>
	</TR>
	</CFIF>
 --->
	<CFINCLUDE template="../LibraryApplicationLinks.cfm">

</TABLE>

<CFINCLUDE template="/include/coldfusion/footer.cfm">
</CFOUTPUT>

</BODY>
</HTML>