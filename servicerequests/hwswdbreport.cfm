<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hwswdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/16/2012 --->
<!--- Date in Production: 11/16/2012 --->
<!--- Module: IDT Service Requests - Hardware/Software Report --->
<!-- Last modified by John R. Pastori on 11/16/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/hwswdbreport.cfm">
<CFSET CONTENT_UPDATED = "November 16, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Hardware/Software Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListHWSW" datasource="#application.type#SERVICEREQUESTS" blockfactor="12">
	SELECT	HWSW_ID, HWSW_NAME, HWSW_DESCRIPTION
	FROM		HWSW
	WHERE	HWSW_ID > 0
	ORDER BY	HWSW_NAME
</CFQUERY>

<TABLE width="100%" align="CENTER" border="3">
	<TR>
		<TD align="center"><H1>IDT Service Requests - Hardware/Software Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0" VALIGN="top" cellpadding="0" cellspacing="0">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="LEFT" COLSPAN="2">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br>
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><br><br>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="left" COLSPAN="2"><H2>#ListHWSW.RecordCount# HWSW records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left" width="20%">HWSW NAME</TH>
          <TH align="left" width="80%">HWSW DESCRIPTION</TH>
	</TR>

<CFLOOP query="ListHWSW">
	<TR>
		<TD align="left" width="20%">#ListHWSW.HWSW_NAME#</TD>
          <TD align="left" width="80%">#ListHWSW.HWSW_DESCRIPTION#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="left" COLSPAN="2">
          	<H2>#ListHWSW.RecordCount# HWSW records were selected.</H2>
          </TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="LEFT" COLSPAN="2">
          	<br>
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><br>
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left" COLSPAN="2">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>