<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2011 --->
<!--- Date in Production: 06/23/2011 --->
<!--- Module: LibQual Home Page--->
<!-- Last modified by John R. Pastori on 06/23/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/index.cfm">
<CFSET CONTENT_UPDATED = "June 23, 2011">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>LibQual Application</TITLE>
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
<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/libqual">

<!--- SET APPLICATION ACCESS VARIABLES --->
<CFSET URL.ACCESSINGAPPFIRSTTIME = "NO">
<CFSET Client.ACCESSINGCONFIGMGMT = "NO">
<CFSET Client.ACCESSINGFACILITIES = "NO">
<CFSET Client.ACCESSINGHARDWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGIDTCHATTER = "NO">
<CFSET Client.ACCESSINGINSTRUCTION = "NO">
<CFSET Client.ACCESSINGLIBQUAL = "YES">
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
<CFCOOKIE name="ABSENCEID" secure="NO" expires="NOW">
<CFCOOKIE name="BIBLIODISCIPLINEID" secure="NO" expires="NOW">
<CFCOOKIE name="CHECKEDINITID" secure="NO" expires="NOW">
<CFCOOKIE name="COMMENTID" secure="NO" expires="NOW">
<CFCOOKIE name="DBSITEID" secure="NO" expires="NOW">
<CFCOOKIE name="DISCIPLINEID" secure="NO" expires="NOW">
<CFCOOKIE name="GROUPVISITID" secure="NO" expires="NOW">
<CFCOOKIE name="LQGROUPID" secure="NO" expires="NOW">
<CFCOOKIE name="LQSUBGROUPID" secure="NO" expires="NOW">
<CFCOOKIE name="POSITIONID" secure="NO" expires="NOW">
<CFCOOKIE name="REQUESTSTATUSID" secure="NO" expires="NOW">
<CFCOOKIE name="REQUESTTYPEID" secure="NO" expires="NOW">
<CFCOOKIE name="SUBJECTCATID" secure="NO" expires="NOW">
<CFCOOKIE name="TAREQUESTID" secure="NO" expires="NOW">
<CFCOOKIE name="YEARMONTHID" secure="NO" expires="NOW">

<TABLE width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD align="center"><H1>LibQual Application</H1></TD>
	</TR>
</TABLE>

<TABLE border="0" width="100%" cellspacing="0" cellpadding="4">
	<CFINCLUDE template="../LibraryApplicationLinks.cfm">

	<TR>
	<CFIF #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
		<TH align="LEFT" valign="top">LIBQUAL PROCESSING</TH>
	</CFIF>
		<TH align="LEFT" valign="top">LIBQUAL REPORTS</TH>
	</TR>

	<TR>
	<CFIF #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			LIBQUAL Comments Criteria - <A href="/#application.type#apps/libqual/lqcommcriteria.cfm"> Modify</A><BR />
			LIBQUAL Comments Criteria Check - <A href="/#application.type#apps/libqual/lqcommcriteriacheck.cfm">Selection Update</A><BR />
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/libqual/lqcommentsdbreport.cfm"> LIBQUAL Comments Report </A><BR />
			<A href="/#application.type#apps/libqual/lqrptslookup.cfm?TYPE=CRITERIA"> LIBQUAL Comments Specific Criteria Reports </A><BR />
			<A href="/#application.type#apps/libqual/lqrptslookup.cfm?TYPE=COUNT"> LIBQUAL Comments Count Reports </A><BR />
		</TD>
	</TR>

	<CFIF (#Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes")>
	<TR>
		<TH align="LEFT" valign="top">
			SUPPORT FILE PROCESSING
		</TH>
		<TH align="LEFT" valign="top">
			SUPPORT FILE REPORTS
		</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			Checked Initials - <A href="/#application.type#apps/libqual/checkedinitials.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libqual/checkedinitials.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Disciplines Info - <A href="/#application.type#apps/webreports/disciplinesinfo.cfm?PROCESS=ADD">Add</A> or
			<A href="/#application.type#apps/webreports/disciplinesinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			LibQual Groups - <A href="/#application.type#apps/libqual/lqgroups.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libqual/lqgroups.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			LibQual SubGroups - <A href="/#application.type#apps/libqual/lqsubgroups.cfm?PROCESS=ADD">Add</A> or
			<A href="/#application.type#apps/libqual/lqsubgroups.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Positions - <A href="/#application.type#apps/libqual/positions.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libqual/positions.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
		</TD>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/libqual/checkedinitialsdbreport.cfm">Checked Initials</A><BR />
			<A href="/#application.type#apps/webreports/disciplinesdbreport.cfm">Disciplines</A><BR />
			<A href="/#application.type#apps/libqual/lqgroupsdbreport.cfm">LibQual Groups</A><BR />
			<A href="/#application.type#apps/libqual/lqsubgroupsdbreport.cfm">LibQual SubGroups</A><BR />
			<A href="/#application.type#apps/libqual/positionsdbreport.cfm">Positions</A><BR />
		</TD>
	</TR>
	</CFIF>

	<CFINCLUDE template="../IDTApplicationLinks.cfm">

</TABLE>

<CFINCLUDE template="/include/coldfusion/footer.cfm">
</CFOUTPUT>

</BODY>
</HTML>