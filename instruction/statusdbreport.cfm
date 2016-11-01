<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: statusdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/08/2007 --->
<!--- Date in Production: 10/08/2007 --->
<!--- Module: Instruction - Status Report --->
<!-- Last modified by John R. Pastori on 10/08/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/statusdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 05, 2007">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction - Status Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFQUERY name="ListStatuses" datasource="#application.type#INSTRUCTION" blockfactor="9">
	SELECT	STATUSID, STATUSNAME
	FROM		STATUS
	WHERE	STATUSID > 0
	ORDER BY	STATUSNAME
</CFQUERY>

<CFOUTPUT>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Instruction - Status Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE border="0" align="center">
	<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
		<TD align="left">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="2"><H2>#ListStatuses.RecordCount# Status records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Status Name</TH>
	</TR>

<CFLOOP query="ListStatuses">
	<TR>
		<TD align="left">#ListStatuses.STATUSNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="2"><H2>#ListStatuses.RecordCount# Status records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
		<TD align="left">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="2">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>