<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: researchercontactreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/16/2008 --->
<!--- Date in Production: 05/16/2008 --->
<!--- Module: Special Collections - Researcher Contact Report --->
<!-- Last modified by John R. Pastori on 05/16/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Special Collections - Researcher Contact Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<TABLE width="100%" align="LEFT" border="3">
	<TR align="center">
		<TH align="center"><H1>Special Collections - Researcher Contact Report</H1></TH>
	</TR>
</TABLE>
<BR /><BR /><BR />
<TABLE width="100%" align="center" border="0">
	<TR>
<CFFORM action="/#application.type#apps/specialcollections/researcherinfodbreports.cfm" method="POST">
		<TD align="LEFT" valign="TOP" colspan="5">
			<INPUT type="SUBMIT" value="Cancel" tabindex="1" />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="LEFT" colspan="5"><H2>#LookupResearcherInfo.RecordCount# Researcher Information records were found.</H2></TH>
	</TR>
	</TR>
		<TD align="LEFT" colspan="5"><HR size="5" noshade /></TD>
	<TR>
	<TR>
		<TH align="center" valign="bottom">Honorific</TH>
		<TH align="left" valign="bottom">Name</TH>
		<TH align="center" valign="bottom">Phone</TH>
		<TH align="center" valign="bottom">FAX</TH>
		<TH align="left" valign="bottom">E-Mail Address</TH>
	</TR>

	<CFLOOP query="LookupResearcherInfo">

	<TR>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.HONORIFIC#</DIV></TD>
		<TD align="left" valign="top"><DIV>#LookupResearcherInfo.FULLNAME#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.PHONE#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.FAX#</DIV></TD>
		<TD align="left" valign="top"><DIV>#LookupResearcherInfo.EMAIL#</DIV></TD>
	</CFLOOP>
	</TR>
		<TD align="LEFT" colspan="5"><HR size="5" noshade /></TD>
	<TR>
	<TR>
		<TH align="LEFT" colspan="5"><H2>#LookupResearcherInfo.RecordCount# Researcher Information records were found.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/specialcollections/researcherinfodbreports.cfm" method="POST">
		<TD align="LEFT" valign="TOP" colspan="5">
			<INPUT type="SUBMIT" value="Cancel" tabindex="2" />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="LEFT" colspan="5">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>