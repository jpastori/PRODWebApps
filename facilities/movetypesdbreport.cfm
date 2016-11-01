<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: movetypesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/25/2012 --->
<!--- Date in Production: 01/25/2012 --->
<!--- Module: Facilities - Move Types Report --->
<!-- Last modified by John R. Pastori on 01/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/movetypesdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 25, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Move Types Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<cfquery name="ListMoveTypes" DATASOURCE="#application.type#FACILITIES" BLOCKFACTOR="8">
	SELECT	MOVETYPEID, MOVETYPENAME
	FROM		MOVETYPES
	WHERE	MOVETYPEID > 0
	ORDER BY	MOVETYPENAME
</cfquery>
<cfoutput>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Move Types Report</H1></TD>
	</TR>
</TABLE>
<BR>
<TABLE border="0" align="center">
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" colspan="2">
			<INPUT type="submit" value="Cancel" tabindex="1">&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" colspan="2"><H2>#ListMoveTypes.RecordCount# Move Type records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Move Type Name</TH>
          <TH ALIGN="left">Move Type Record Keys</TH>
	</TR>

<CFLOOP QUERY="ListMoveTypes">
	<TR>
		<TD ALIGN="left">#ListMoveTypes.MOVETYPENAME#</TD>
          <TD ALIGN="left">#ListMoveTypes.MOVETYPEID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" colspan="2"><H2>#ListMoveTypes.RecordCount# Move Type records were selected.</H2></TH>
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
		<TD align="LEFT" colspan="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR><BR>
</cfoutput>
</BODY>
</HTML>