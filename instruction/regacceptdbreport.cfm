<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: regacceptdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/05/2007 --->
<!--- Date in Production: 01/05/2007 --->
<!--- Module: Instruction - Registration  Acceptance Type Report --->
<!-- Last modified by John R. Pastori on 01/05/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/regacceptdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 05, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction - Registration Acceptance Type Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfquery name="ListRegAcceptType" DATASOURCE="#application.type#INSTRUCTION" BLOCKFACTOR="4">
	SELECT	REGACCEPTID, REGACCEPTTYPE
	FROM		REGACCEPT
	WHERE	REGACCEPTID > 0
	ORDER BY	REGACCEPTTYPE
</cfquery>

<cfoutput>
<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Instruction - Registration Acceptance Type Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0">
	<TR>
<cfform action="/#application.type#apps/instruction/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListRegAcceptType.RecordCount# Registration Acceptance Type records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Registration Acceptance Type</TH>
	</TR>

<CFLOOP QUERY="ListRegAcceptType">
	<TR>
		<TD ALIGN="left">#ListRegAcceptType.REGACCEPTTYPE#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListRegAcceptType.RecordCount# Marketing records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/instruction/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD ALIGN="left">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>