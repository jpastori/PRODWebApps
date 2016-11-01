<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: prioritydbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/24/2012 --->
<!--- Date in Production: 05/24/2012 --->
<!--- Module: IDT Service Requests - Priority  Report --->
<!-- Last modified by John R. Pastori on 05/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/prioritydbreport.cfm">
<CFSET CONTENT_UPDATED = "May 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Priority Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListPriority" datasource="#application.type#SERVICEREQUESTS" blockfactor="3">
	SELECT	PRIORITYID, PRIORITYNAME
	FROM		PRIORITY
	WHERE	PRIORITYID > 0
	ORDER BY	PRIORITYNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR>
		<TD align="center"><H1>IDT Service Requests - Priority Report</H1></TD>
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
		<TH align="left"><H2>#ListPriority.RecordCount# Priority records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Priority</TH>
	</TR>

<CFLOOP query="ListPriority">
	<TR>
		<TD align="left">#ListPriority.PRIORITYNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="left"><H2>#ListPriority.RecordCount# Priority records were selected.</H2></TH>
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