<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: statusesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/16/2012 --->
<!--- Date in Production: 07/16/2012 --->
<!--- Module: IDT Software Inventory - Status Report --->
<!-- Last modified by John R. Pastori on 07/16/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/statusesdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 16, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Inventory - Status Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFQUERY name="ListStatuses" datasource="#application.type#SOFTWARE" blockfactor="14">
	SELECT	STATUSID, STATUSTYPE, STATUSNAME
	FROM		STATUSES
	WHERE	STATUSID > 0
	ORDER BY	STATUSTYPE, STATUSNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>IDT Software Inventory - Status Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE border="0" align="center">
	<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="2"><H2>#ListStatuses.RecordCount# Status records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Status Type</TH>
		<TH align="left">Status Name</TH>
	</TR>

<CFLOOP query="ListStatuses">
	<TR>
		<TD align="left">#ListStatuses.STATUSTYPE#</TD>
		<TD align="left">#ListStatuses.STATUSNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="2"><H2>#ListStatuses.RecordCount# Status records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
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