<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: requesttypesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/25/2012 --->
<!--- Date in Production: 07/25/2012 --->
<!--- Module: Web Reports - Request Types Report --->
<!-- Last modified by John R. Pastori on 07/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME="John R. Pastori/cp">
<CFSET AUTHOR_EMAIL="pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI="/#application.type#apps/webreports/requesttypesdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 25 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Web Reports - Request Types Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListRequestTypes" DATASOURCE="#application.type#WEBREPORTS" BLOCKFACTOR="14">
	SELECT	REQUESTTYPEID, REQUESTTYPENAME, REQUESTTYPEFIELDNAME
	FROM		REQUESTTYPES
	WHERE	REQUESTTYPEID > 0
	ORDER BY	REQUESTTYPENAME
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Web Reports - Request Types Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE border="0" align="center">
	<TR>
<cfform action="/#application.type#apps/webreports/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListRequestTypes.RecordCount# Request Type records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Request Type Name</TH>
		<TH ALIGN="left">Request Type Field Name</TH>
	</TR>

<CFLOOP QUERY="ListRequestTypes">
	<TR>
		<TD ALIGN="left">#ListRequestTypes.REQUESTTYPENAME#</TD>
		<TD ALIGN="left">#ListRequestTypes.REQUESTTYPEFIELDNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListRequestTypes.RecordCount# Request Type records were selected.</H2></TH>
	</TR>
     <TR>
          <TD align="left">&nbsp;&nbsp;</TD>
     </TR>
	<TR>
<cfform action="/#application.type#apps/webreports/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD ALIGN="LEFT" COLSPAN="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>