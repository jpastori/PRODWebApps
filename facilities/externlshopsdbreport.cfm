<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: externlshopsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/08/2012 --->
<!--- Date in Production: 02/08/2012 --->
<!--- Module: Facilities - External Shops Report --->
<!-- Last modified by John R. Pastori on 02/08/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME="John R. Pastori/cp">
<CFSET AUTHOR_EMAIL="pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI="/#application.type#apps/facilities/externlshopsdbreport.cfm">
<CFSET CONTENT_UPDATED = "February 08, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - External Shops Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<BODY>

<CFQUERY name="ListExternalShops" datasource="#application.type#FACILITIES" blockfactor="13">
	SELECT	EXTERNLSHOPID, EXTERNLSHOPNAME, CONTACT_NAME, CONTACT_PHONE, SECOND_PHONE
	FROM		EXTERNLSHOPS
	WHERE	EXTERNLSHOPID > 0
	ORDER BY	EXTERNLSHOPNAME
</CFQUERY>
<CFOUTPUT>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - External Shops Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE border="0" align="center">
	<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="4">
			<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="5"><H2>#ListExternalShops.RecordCount# External Shop records were selected.<H2></H2></H2></TH>
	</TR>
	<TR>
		<TH align="left">External Shop Name</TH>
          <TH align="left">Contact Name</TH>
          <TH align="left">Contact Phone</TH>
          <TH align="left">Second Phone</TH>
          <TH align="left">External Shop Record Keys</TH>
	</TR>

<CFLOOP query="ListExternalShops">
	<TR>
		<TD align="left">#ListExternalShops.EXTERNLSHOPNAME#</TD>
          <TD align="left">#ListExternalShops.CONTACT_NAME#</TD>
          <TD align="left">#ListExternalShops.CONTACT_PHONE#</TD>
          <TD align="left">#ListExternalShops.SECOND_PHONE#</TD>
          <TD align="left">#ListExternalShops.EXTERNLSHOPID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="5"><H2>#ListExternalShops.RecordCount# External Shop records were selected.<H2></H2></H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="5">
			<INPUT type="SUBMIT" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="LEFT" valign="TOP" colspan="5">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR /><BR />
</CFOUTPUT>
</BODY>
</HTML>