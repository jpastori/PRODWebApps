<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: requesttypesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/25/2012 --->
<!--- Date in Production: 01/25/2012 --->
<!--- Module: Facilities - Request Types Report --->
<!-- Last modified by John R. Pastori on 01/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME="John R. Pastori/cp">
<CFSET AUTHOR_EMAIL="pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI="/#application.type#apps/facilities/requesttypesdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 25, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Request Types Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<cfquery name="ListRequestTypes" DATASOURCE="#application.type#FACILITIES" BLOCKFACTOR="13">
	SELECT	REQUESTTYPEID, REQUESTTYPENAME
	FROM		REQUESTTYPES
	WHERE	REQUESTTYPEID > 0
	ORDER BY	REQUESTTYPENAME
</cfquery>
<cfoutput>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Request Types Report</H1></TD>
	</TR>
</TABLE>
<BR>
<TABLE border="0" align="center">
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" VALIGN="TOP" COLSPAN="2">
			<INPUT type="SUBMIT" value="Cancel" tabindex="1">&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListRequestTypes.RecordCount# Request Type records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Request Type Name</TH>
          <TH ALIGN="left">Request Type Record Keys</TH>
	</TR>

<CFLOOP QUERY="ListRequestTypes">
	<TR>
		<TD ALIGN="left">#ListRequestTypes.REQUESTTYPENAME#</TD>
          <TD ALIGN="left">#ListRequestTypes.REQUESTTYPEID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListRequestTypes.RecordCount# Request Type records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" VALIGN="TOP" COLSPAN="2">
			<INPUT type="SUBMIT" value="Cancel" tabindex="2">&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD align="LEFT" VALIGN="TOP" COLSPAN="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR><BR>
</cfoutput>
</BODY>
</HTML>