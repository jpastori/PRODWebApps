<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: walldirectiondbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/25/2012 --->
<!--- Date in Production: 01/25/2012 --->
<!--- Module: Facilities Wall Direction Database Report --->
<!-- Last modified by John R. Pastori on 01/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/walldirectiondbreport.cfm">
<CFSET CONTENT_UPDATED = "January 25, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities Wall Direction Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<cfquery name="ListWallDirection" DATASOURCE="#application.type#FACILITIES" BLOCKFACTOR="6">
	SELECT	WALLDIRID, WALLDIRNAME
	FROM		WALLDIRECTION
	WHERE	WALLDIRID > 0
	ORDER BY	WALLDIRNAME
</cfquery>

<cfoutput>

<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Wall Direction Report<H1></TD>
	</TR>
</TABLE>
<BR>
<TABLE width="100%" border="0">
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="2">
			<INPUT type="submit" value="Cancel" tabindex="1">&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListWallDirection.RecordCount# Wall Direction records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Wall Direction Name</TH>
          <TH ALIGN="left">Wall Direction Record Keys</TH>
	</TR>

<CFLOOP QUERY="ListWallDirection">
	<TR>
		<TD ALIGN="left">#ListWallDirection.WALLDIRNAME#</TD>
          <TD ALIGN="left">#ListWallDirection.WALLDIRID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListWallDirection.RecordCount# Wall Direction records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="2">
			<INPUT type="submit" value="Cancel" tabindex="2">&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD align="LEFT" COLSPAN="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR><BR>
</cfoutput>
</BODY>
</HTML>