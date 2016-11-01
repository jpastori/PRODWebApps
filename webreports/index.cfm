<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/30/2012 --->
<!--- Date in Production: 07/30/2012 --->
<!--- Module: Web Reports Home Page--->
<!-- Last modified by John R. Pastori on 03/06/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/index.cfm">
<CFSET CONTENT_UPDATED = "March 06 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, UNITHEAD, DEPTCHAIR, ALLOWEDTOAPPROVE
	FROM		CUSTOMERS
	WHERE	CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	CUSTOMERS.FULLNAME
</CFQUERY>

<HTML>
<HEAD>
	<TITLE>Web Reports Application</TITLE>
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
<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/webreports">

<!--- SET APPLICATION ACCESS VARIABLES --->
<CFSET URL.ACCESSINGAPPFIRSTTIME = "NO">
<CFSET Client.ACCESSINGCONFIGMGMT = "NO">
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
<CFSET Client.ACCESSINGWEBREPORTS = "YES">

<!--- SET SESSION VARIABLES --->
<CFSET temp = ArraySet(session.ABSENCEREQUESTIDArray, 1, 1, 0)>
<CFSET session.ArrayCounter = 0>
<CFSET session.ABSENCEREQUESTSSELECTED = 0>
<CFSET session.PROCESS = ''>

<CFINCLUDE template="/include/coldfusion/header.cfm">

<!--- SET COOKIE VARIABLES --->
<CFCOOKIE name="ABSENCEID" secure="NO" expires="NOW">
<CFCOOKIE name="BIBLIODISCIPLINEID" secure="NO" expires="NOW">
<CFCOOKIE name="CHECKEDINITID" secure="NO" expires="NOW">
<CFCOOKIE name="COMMENTID" secure="NO" expires="NOW">
<CFCOOKIE name="CONTACTID" secure="NO" expires="NOW">
<CFCOOKIE name="CONTACTTIMEID" secure="NO" expires="NOW">
<CFCOOKIE name="DISCIPLINEID" secure="NO" expires="NOW">
<CFCOOKIE name="GROUPVISITID" secure="NO" expires="NOW">
<CFCOOKIE name="LQGROUPID" secure="NO" expires="NOW">
<CFCOOKIE name="LQSUBGROUPID" secure="NO" expires="NOW">
<CFCOOKIE name="POSITIONID" secure="NO" expires="NOW">
<CFCOOKIE name="PUBLICDESKID" secure="NO" expires="NOW">
<CFCOOKIE name="REQUESTSTATUSID" secure="NO" expires="NOW">
<CFCOOKIE name="REQUESTTYPEID" secure="NO" expires="NOW">
<CFCOOKIE name="SUBJECTCATID" secure="NO" expires="NOW">
<CFCOOKIE name="SUBTOPICID" secure="NO" expires="NOW">
<CFCOOKIE name="TAREQUESTID" secure="NO" expires="NOW">
<CFCOOKIE name="TOPICID" secure="NO" expires="NOW">

<TABLE width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD align="center"><H1>Web Reports Application</H1></TD>
	</TR>
</TABLE>

<TABLE border="0" width="100%" cellspacing="0" cellpadding="4">
	<CFINCLUDE template="../LibraryApplicationLinks.cfm">

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">
			LIBRARY FORMS PROCESSING
		</TH>
	</CFIF>
		<TH align="LEFT" valign="top">
			LIBRARY FORMS REPORTS
		</TH>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			Absence Request - <A href="/#application.type#apps/webreports/absencerequest.cfm?PROCESS=ADD">Add</A> or
			<A href="/#application.type#apps/webreports/absencerequest.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
          <CFIF (ListCustomers.UNITHEAD EQ 'YES' OR ListCustomers.DEPTCHAIR EQ 'YES') AND ListCustomers.ALLOWEDTOAPPROVE EQ 'YES'>
			<CFSET session.ABSENCEREQUESTSSELECTED = 0>
			Absence Request - <A href="/#application.type#apps/webreports/absencerequestapproval.cfm">Approval</A><BR /><BR />
          </CFIF>
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/webreports/absencerequestreportbyreq.cfm">Absence Request Report By Requester</A><BR />
		<CFIF (ListCustomers.UNITHEAD EQ 'YES' OR ListCustomers.DEPTCHAIR EQ 'YES' OR #Client.SecurityFlag# EQ "Yes")>
			Selected <A href="/#application.type#apps/webreports/selectedabsencereqdbrpt.cfm"> Absence Request Report</A><BR />
		</CFIF>
		</TD>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">PUBLIC DESK PROCESSING</TH>
	</CFIF>
		<TH align="LEFT" valign="top">PUBLIC DESK REPORTS</TH>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			Public Desk - <A href="/#application.type#apps/webreports/publicdesk.cfm?PROCESS=ADD"> Add</A> or
			<A href="/#application.type#apps/webreports/publicdesk.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR /><BR /><BR />
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/webreports/publicdeskdbreport.cfm?REPORT=PUBD"> Public Desk Report</A><BR />
		<CFIF #Client.ProcessFlag# EQ "Yes">
			<A href="/#application.type#apps/webreports/publicdeskdbreport.cfm?REPORT=CIRCD"> Circ Desk Report</A><BR />
		</CFIF>
		<CFIF (#Client.MaintFlag# EQ "Yes")>
			<A href="/#application.type#apps/webreports/publicdeskdbreport.cfm?REPORT=IDTD"> InfoSys Service Desk/IDT Report</A><BR />
			<A href="/#application.type#apps/webreports/publicdeskdbreport.cfm?REPORT=MGMT"> Management Contact Report</A><BR />
		</CFIF>
		<CFIF (#Client.SecurityFlag# EQ "Yes")>
			<A href="/#application.type#apps/webreports/publicdeskfullreport.cfm"> Public Desk Full Report</A><BR />
		</CFIF>
		</TD>
	</TR>

	<CFIF (#Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes")>
	<TR>
		<TH align="LEFT" valign="top">
			WEB REPORTS SUPPORT FILE PROCESSING
		</TH>
		<TH align="LEFT" valign="top">
			WEB REPORTS SUPPORT FILE REPORTS
		</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			Public Desk Contacts - <A href="/#application.type#apps/webreports/pdcontacts.cfm?PROCESS=ADD"> Add</A> or
			<A href="/#application.type#apps/webreports/pdcontacts.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Public Desk Contact Times - <A href="/#application.type#apps/webreports/pdcontacttime.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/webreports/pdcontacttime.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Public Desk SubTopics - <A href="/#application.type#apps/webreports/pdsubtopic.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/webreports/pdsubtopic.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Public Desk Topics - <A href="/#application.type#apps/webreports/pdtopic.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/webreports/pdtopic.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR /><BR />
			
			Request Status For Absense - <A href="/#application.type#apps/webreports/requeststatus.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/webreports/requeststatus.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Request Types For Absense - <A href="/#application.type#apps/webreports/requesttypes.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/webreports/requesttypes.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />

		</TD>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/webreports/pdcontactsdbreport.cfm"> Public Desk Contacts</A><BR />
			<A href="/#application.type#apps/webreports/pdcontacttimedbreport.cfm">Public Desk Contact Times</A><BR />
			<A href="/#application.type#apps/webreports/pdsubtopicdbreport.cfm">Public Desk SubTopics</A><BR />
			<A href="/#application.type#apps/webreports/pdtopicdbreport.cfm">Public Desk Topics</A><BR /><BR />

			<A href="/#application.type#apps/webreports/requeststatusdbreport.cfm">Request Status</A> For Absense<BR />
			<A href="/#application.type#apps/webreports/requesttypesdbreport.cfm">Request Types</A> For Absense<BR />
		</TD>
	</TR>
	</CFIF>

	<CFINCLUDE template="../IDTApplicationLinks.cfm">

</TABLE>

<CFINCLUDE template="/include/coldfusion/footer.cfm">
</CFOUTPUT>

</BODY>
</HTML>