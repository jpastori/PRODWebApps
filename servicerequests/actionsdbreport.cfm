<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: actionsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012 --->
<!--- Module: IDT Service Requests - Actions Report --->
<!-- Last modified by John R. Pastori on 09/23/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/actionsdbreport.cfm">
<CFSET CONTENT_UPDATED = "September 23, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Actions Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListActions" datasource="#application.type#SERVICEREQUESTS" blockfactor="17">
	SELECT	ACTIONID, ACTIONNAME
	FROM		ACTIONS
	WHERE	ACTIONID > 0
	ORDER BY	ACTIONNAME
</CFQUERY>

<TABLE width="100%" align="CENTER" border="3">
	<TR>
		<TD align="center"><H1>IDT Service Requests - Actions Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0" VALIGN="top" cellpadding="0" cellspacing="0">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="left" colspan="2">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br>
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="left" colspan="2"><H2>#ListActions.RecordCount# Action records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Actions</TH>
          <TH align="left">Actions Key</TH>
	</TR>

<CFLOOP query="ListActions">
	<TR>
		<TD align="left">#ListActions.ACTIONNAME#</TD>
          <TD align="left">#ListActions.ACTIONID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="left" colspan="2"><H2>#ListActions.RecordCount# Action records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="left" colspan="2">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><br>
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left" colspan="2">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>