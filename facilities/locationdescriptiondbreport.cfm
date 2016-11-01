<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: locationdescriptiondbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/25/2012 --->
<!--- Date in Production: 01/25/2012 --->
<!--- Module: Facilities Location Description Database Report --->
<!-- Last modified by John R. Pastori on 01/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/locationdescriptiondbreport.cfm">
<CFSET CONTENT_UPDATED = "January 25, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities Location Description Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<cfquery name="ListLocationDescription" DATASOURCE="#application.type#FACILITIES" BLOCKFACTOR="56">
	SELECT	LOCATIONDESCRIPTIONID, LOCATIONDESCRIPTION
	FROM		LOCATIONDESCRIPTION
	WHERE	LOCATIONDESCRIPTIONID > 0
	ORDER BY	LOCATIONDESCRIPTION
</cfquery>

<cfoutput>
<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Location Description Report</H1></TD>
	</TR>
</TABLE>
<BR>
<TABLE width="100%" border="0">
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" colspan="2">
			<INPUT type="submit" value="Cancel" tabindex="1">&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" colspan="2"><H2>#ListLocationDescription.RecordCount# Location Description records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Location Description</TH>
          <TH ALIGN="left">Location Description Record Keys</TH>
	</TR>

<CFLOOP QUERY="ListLocationDescription">
	<TR>
		<TD ALIGN="left">#ListLocationDescription.LOCATIONDESCRIPTION#</TD>
          <TD ALIGN="left">#ListLocationDescription.LOCATIONDESCRIPTIONID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" colspan="2"><H2>#ListLocationDescription.RecordCount# Location Description records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" colspan="2">
			<INPUT type="submit" value="Cancel" tabindex="2">&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD ALIGN="left" colspan="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR><BR>
</cfoutput>
</BODY>
</HTML>