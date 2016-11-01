<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: computertypesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/20/2006 --->
<!--- Date in Production: 11/20/2006 --->
<!--- Module: Facilities Computer Types Database Report --->
<!-- Last modified by John R. Pastori on 11/20/2006 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/computertypesdbreport.cfm">
<CFSET CONTENT_UPDATED = "November 20, 2006">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities Computer Types Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<cfquery name="ListComputerTypes" DATASOURCE="#application.type#FACILITIES" BLOCKFACTOR="6">
	SELECT	COMPUTERTYPEID, COMPUTERTYPENAME
	FROM		COMPUTERTYPES
	WHERE	COMPUTERTYPEID > 0
	ORDER BY	COMPUTERTYPENAME
</cfquery>

<cfoutput>

<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Computer Types Report</TD>
	</TR>
</TABLE>
<BR>
<TABLE width="100%" border="0">
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="1">&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListComputerTypes.RecordCount# Computer Type records were selected.<H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Computer Type Name</TH>
	</TR>

<CFLOOP QUERY="ListComputerTypes">
	<TR>
		<TD ALIGN="left">#ListComputerTypes.COMPUTERTYPENAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListComputerTypes.RecordCount# Computer Type records were selected.<H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="2">&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD>
<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR><BR>
</cfoutput>
</BODY>
</HTML>