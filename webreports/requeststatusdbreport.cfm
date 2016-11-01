<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: requeststatusdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/25/2012 --->
<!--- Date in Production: 07/25/2012 --->
<!--- Module: Web Reports - Request Status Report --->
<!-- Last modified by John R. Pastori on 07/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME="John R. Pastori">
<CFSET AUTHOR_EMAIL="pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI="/#application.type#apps/webreports/requeststatusdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 25 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Web Reports - Request Status Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListRequestStatuses" DATASOURCE="#application.type#WEBREPORTS" BLOCKFACTOR="4">
	SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
	FROM		REQUESTSTATUS
	WHERE	REQUESTSTATUSID > 0
	ORDER BY	REQUESTSTATUSNAME
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Web Reports - Request Status Report</H1></TD>
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
		<TH ALIGN="CENTER"><H2>#ListRequestStatuses.RecordCount# Request Status records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Request Status Name</TH>
	</TR>

<CFLOOP QUERY="ListRequestStatuses">
	<TR>
		<TD ALIGN="left">#ListRequestStatuses.REQUESTSTATUSNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListRequestStatuses.RecordCount# Request Status records were selected.</H2></TH>
	</TR>
	<TR>
     <TR>
          <TD align="left">&nbsp;&nbsp;</TD>
     </TR>
<cfform action="/#application.type#apps/webreports/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
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