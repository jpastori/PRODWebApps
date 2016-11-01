<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: groupassigneddbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/24/2012 --->
<!--- Date in Production: 05/24/2012 --->
<!--- Module: IDT Service Requests - Group Assigned Report --->
<!-- Last modified by John R. Pastori on 05/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/groupassigneddbreport.cfm">
<CFSET CONTENT_UPDATED = "May 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Group Assigned Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
	SELECT	GROUPID, GROUPNAME
	FROM		GROUPASSIGNED
	WHERE	GROUPID > 0
	ORDER BY	GROUPNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR>
		<TD align="center"><H1>IDT Service Requests - Group Assigned Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0" VALIGN="top" cellpadding="0" cellspacing="0">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="left"><H2>#ListGroupAssigned.RecordCount# Group Assigned records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Groups</TH>
	</TR>

<CFLOOP query="ListGroupAssigned">
	<TR>
		<TD align="left">#ListGroupAssigned.GROUPNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="left"><H2>#ListGroupAssigned.RecordCount# Group Assigned records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD>
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>