<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: statusdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/14/2007 --->
<!--- Date in Production: 01/14/2007 --->
<!--- Module: Special Collections - Status Report --->
<!-- Last modified by John R. Pastori on 01/14/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/statusdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 14, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Special Collections - Status Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListStatus" DATASOURCE="#application.type#SPECIALCOLLECTIONS" BLOCKFACTOR="9">
	SELECT	STATUSID, STATUSNAME
	FROM		STATUS
	WHERE	STATUSID > 0
	ORDER BY	STATUSNAME
</cfquery>

<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Special Collections - Status Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0">
	<TR>
<cfform action="/#application.type#apps/specialcollections/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListStatus.RecordCount# Status records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Status Name</TH>
	</TR>

<CFLOOP QUERY="ListStatus">
	<TR>
		<TD ALIGN="left">#ListStatus.STATUSNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListStatus.RecordCount# Status records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/specialcollections/index.cfm?logout=No" METHOD="POST">
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