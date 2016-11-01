<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: securitylevelsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/13/2007 --->
<!--- Date in Production: 01/13/2007 --->
<!--- Module:  Library Security - Security Levels Report --->
<!-- Last modified by John R. Pastori on 01/13/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libsecurity/securitylevelsdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 13, 2007">

<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Library Security - Security Levels Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>
<cfquery name="ListSecurityLevels" DATASOURCE="#application.type#LIBSECURITY" BLOCKFACTOR="7">
	SELECT	SECURITYLEVELID, SECURITYLEVELNUMBER, SECURITYLEVELNAME
	FROM		SECURITYLEVELS
	WHERE	SECURITYLEVELID > 0
	ORDER BY	SECURITYLEVELNAME
</cfquery>

<TABLE width="100%" align="left" BORDER="3">
	<TR>
		<TD align="center"><H1>Library Security - Security Levels Report</H1></TD>
	</TR>
</TABLE>
<BR /><BR /><BR /><BR />
<TABLE width="100%" border="0" align="left" VALIGN="top" CELLPADDING="0" CELLSPACING="0">
	<TR>
<cfform action="/#application.type#apps/libsecurity/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" VALIGN="TOP" COLSPAN="2">
			<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="left" COLSPAN="2"><H2>#ListSecurityLevels.RecordCount# Security Level records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="center">Security Level Number</TH>
		<TH ALIGN="left">Security Level</TH>
	</TR>

<CFLOOP QUERY="ListSecurityLevels">
	<TR>
		<TD ALIGN="center">#ListSecurityLevels.SECURITYLEVELNUMBER#</TD>
		<TD ALIGN="left">#ListSecurityLevels.SECURITYLEVELNAME#</TD>
	</TR>
	<TR>
		<TD>&nbsp;&nbsp;</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="left" COLSPAN="2"><H2>#ListSecurityLevels.RecordCount# Security Level records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/libsecurity/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" VALIGN="TOP" COLSPAN="2">
			<INPUT type="SUBMIT" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD COLSPAN="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>