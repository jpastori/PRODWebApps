<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: optionsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/24/2012 --->
<!--- Date in Production: 05/24/2012 --->
<!--- Module: IDT Service Requests - Options Report --->
<!-- Last modified by John R. Pastori on 05/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/optionsdbreport.cfm">
<CFSET CONTENT_UPDATED = "May 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Options Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListOptions" datasource="#application.type#SERVICEREQUESTS" blockfactor="2">
	SELECT	OPTIONID, OPTIONNAME
	FROM		OPTIONS
	WHERE	OPTIONID > 0
	ORDER BY	OPTIONNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR>
		<TD align="center"><H1>IDT Service Requests - Options Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0" VALIGN="top" cellpadding="0" cellspacing="0">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="left"><H2>#ListOptions.RecordCount# Option records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Options</TH>
	</TR>

<CFLOOP query="ListOptions">
	<TR>
		<TD align="left">#ListOptions.OPTIONNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="left"><H2>#ListOptions.RecordCount# Option records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD>
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>