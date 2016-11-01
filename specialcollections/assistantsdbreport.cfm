<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: assistantsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/10/2008 --->
<!--- Date in Production: 07/10/2008 --->
<!--- Module: Special Collections - Assistants Report --->
<!-- Last modified by John R. Pastori on 07/10/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/assistantsdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 10, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Special Collections - Assistants Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListAssistants" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="50">
	SELECT	ASSISTANTID, ASSISTANTNAME, ACTIVE, APPROVAL
	FROM		ASSISTANTS
	WHERE	ASSISTANTID > 0
	ORDER BY	ASSISTANTNAME
</CFQUERY>

<TABLE width="100%" border="3">
	<TR align="center">
		<TD align="center"><H1>Special Collections - Assistants Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="3">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="3"><H2>#ListAssistants.RecordCount# Assistants records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Assistant Name</TH>
		<TH align="CENTER">Active?</TH>
		<TH align="CENTER">Approval?</TH>
	</TR>

<CFLOOP query="ListAssistants">
	<TR>
		<TD align="left">#ListAssistants.ASSISTANTNAME#</TD>
		<TD align="CENTER">#ListAssistants.ACTIVE#</TD>
		<TD align="CENTER">#ListAssistants.APPROVAL#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="3"><H2>#ListAssistants.RecordCount# Assistants records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="3">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left" colspan="3">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>