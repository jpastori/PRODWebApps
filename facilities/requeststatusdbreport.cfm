<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: requeststatusdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/25/2012 --->
<!--- Date in Production: 01/25/2012 --->
<!--- Module: Facilities - Request Status Report --->
<!-- Last modified by John R. Pastori on 01/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME="John R. Pastori/cp">
<CFSET AUTHOR_EMAIL="pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI="/#application.type#apps/facilities/requeststatusdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 25, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Request Status Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<cfquery name="ListRequestStatuses" DATASOURCE="#application.type#FACILITIES" BLOCKFACTOR="8">
	SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
	FROM		REQUESTSTATUS
	WHERE	REQUESTSTATUSID > 0
	ORDER BY	REQUESTSTATUSNAME
</cfquery>
<cfoutput>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Request Status Report</H1></TD>
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
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListRequestStatuses.RecordCount# Request Status records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Request Status Name</TH>
          <TH ALIGN="left">Request Status Record Keys</TH>
	</TR>

<CFLOOP QUERY="ListRequestStatuses">
	<TR>
		<TD ALIGN="left">#ListRequestStatuses.REQUESTSTATUSNAME#</TD>
          <TD ALIGN="left">#ListRequestStatuses.REQUESTSTATUSID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListRequestStatuses.RecordCount# Request Status records were selected.</H2></TH>
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