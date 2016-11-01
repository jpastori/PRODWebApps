<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: workgroupassignsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/24/2012 --->
<!--- Date in Production: 05/24/2012 --->
<!--- Module: IDT Service Requests - Workgroup Assignment Report --->
<!-- Last modified by John R. Pastori on 10/08/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/workgroupassignsdbreport.cfm">
<CFSET CONTENT_UPDATED = "October 08, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Workgroup Assignment Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFSET RECORDCOUNT = 0>

<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
	SELECT	GROUPID, GROUPNAME
	FROM		GROUPASSIGNED
	WHERE	GROUPID > 0
	ORDER BY	GROUPNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR>
		<TD align="center"><H1>IDT Service Requests - Workgroup Assignment Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0" VALIGN="top" cellpadding="0" cellspacing="0">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="4">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="left" width="25%">Group</TH>
		<TH align="left" width="25%">Staff</TH>
		<TH align="left" width="25%">Group Order</TH>
          <TH align="center" width="25%">Staff Active?</TH>
	</TR>

<CFLOOP query="ListGroupAssigned">

	<CFQUERY name="ListStaffInGroups" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, WGA.GROUPORDER, WGA.ACTIVE
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WGA.GROUPID = #ListGroupAssigned.GROUPID# AND
				WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFSET RECORDCOUNT = RECORDCOUNT + ListStaffInGroups.RecordCount>
	<TR>
		<TH align="left" valign="top" width="25%"><STRONG>#ListGroupAssigned.GROUPNAME#</STRONG></TH>
		<TD align="LEFT" width="25%">&nbsp;&nbsp;</TD>
		<TD align="LEFT" width="25%">&nbsp;&nbsp;</TD>
          <TD align="LEFT" width="25%">&nbsp;&nbsp;</TD>
	</TR>
	<CFLOOP query="ListStaffInGroups">
	<TR>
		<TD align="LEFT" width="25%">&nbsp;&nbsp;</TD>
		<TD align="left" width="25%">
			#ListStaffInGroups.FULLNAME#<BR>
		</TD>
		<TD align="left" width="25%" nowrap>
			#MID(ListStaffInGroups.GROUPORDER, 3, 17)#<BR>
		</TD>
          <TD align="center" width="25%" nowrap>
			#ListStaffInGroups.ACTIVE#<BR>
		</TD>
	</TR>
	</CFLOOP>
	<TR>
		<TD align="LEFT" colspan="4"><HR></TD>
	</TR>
</CFLOOP>
	<TR>
		<TD align="LEFT" colspan="4"><HR size="5" noshade></TD>
	</TR>
	<TR>
		<TH align="CENTER" colspan="4"><H2>#RECORDCOUNT# Workgroup Assignment records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="4">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="3">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>