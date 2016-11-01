<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: vlaninfodbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/08/2015 --->
<!--- Date in Production: 07/08/2015 --->
<!--- Module: Facilities VLan Info Database Report --->
<!-- Last modified by John R. Pastori on 07/08/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/vlaninfodbreport.cfm">
<CFSET CONTENT_UPDATED = "July 08, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities VLan Info Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<BODY>

<CFQUERY name="ListVLanInfo" datasource="#application.type#FACILITIES" blockfactor="15">
	SELECT	VLANID, VLAN_NUMBER, VLAN_NAME
	FROM		VLANINFO
	WHERE	VLANID > 0
	ORDER BY	VLANID
</CFQUERY>

<CFOUTPUT>
<TABLE width="100%" border="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - VLan Info Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="3">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="3"><H2>#ListVLanInfo.RecordCount# VLan Info records were selected.<H2></H2></H2></TH>
	</TR>
	<TR>
		<TH align="left">VLan Number</TH>
		<TH align="left">VLan Name</TH>
		<TH align="left">VLan Info Record Keys</TH>
	</TR>

<CFLOOP query="ListVLanInfo">
	<TR>
		<TD align="left">#ListVLanInfo.VLAN_NUMBER#</TD>
		<TD align="left">#ListVLanInfo.VLAN_NAME#</TD>
		<TD align="left">#ListVLanInfo.VLANID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="3"><H2>#ListVLanInfo.RecordCount# VLan Info records were selected.<H2></H2></H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="3">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left" colspan="3">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR /><BR />
</CFOUTPUT>
</BODY>
</HTML>