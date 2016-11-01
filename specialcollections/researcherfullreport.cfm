<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: researcherfullreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/16/2008 --->
<!--- Date in Production: 05/16/2008 --->
<!--- Module: Special Collections - Researcher Full Report --->
<!-- Last modified by John R. Pastori on 05/16/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Special Collections - Researcher Full Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<TABLE width="100%" align="LEFT" border="3">
	<TR align="center">
		<TH align="center"><H1>Special Collections - Researcher Full Report</H1></TH>
	</TR>
</TABLE>
<BR /><BR /><BR />
<TABLE width="100%" align="center" border="0">
	<TR>
<CFFORM action="/#application.type#apps/specialcollections/researcherinfodbreports.cfm" method="POST">
		<TD align="LEFT" valign="TOP" colspan="11">
			<INPUT type="SUBMIT" value="Cancel" tabindex="1" />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="LEFT" colspan="11"><H2>#LookupResearcherInfo.RecordCount# Researcher Information records were found.</H2></TH>
	</TR>

	<CFLOOP query="LookupResearcherInfo">

	<TR>
		<TH align="left" valign="bottom">Honorific</TH>
		<TH align="center" valign="bottom">Name</TH>
		<TH align="center" valign="bottom">Address</TH>
		<TH align="center" valign="bottom">City</TH>
		<TH align="center" valign="bottom">State/Province</TH>
		<TH align="center" valign="bottom">Zip/Postal Code</TH>
		<TH align="center" valign="bottom">Phone</TH>
		<TH align="center" valign="bottom">FAX</TH>
		<TH align="center" valign="bottom">E-Mail Address</TH>
		<TH align="center" valign="bottom">Institution</TH>
		<TH align="center" valign="bottom">Department/Major</TH>
	</TR>

		<CFQUERY name="LookupStateCode" datasource="#application.type#LIBSHAREDDATA">
			SELECT	STATEID, STATECODE || ' - ' || STATENAME AS STATECODENAME
			FROM		STATES
			WHERE	STATEID = <CFQUERYPARAM value="#LookupResearcherInfo.STATEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATECODE
		</CFQUERY>

		<CFQUERY name="LookupIDTypes" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	IDTYPEID, IDTYPENAME
			FROM		IDTYPES
			WHERE	IDTYPEID = <CFQUERYPARAM value="#LookupResearcherInfo.IDTYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	IDTYPENAME
		</CFQUERY>

		<CFQUERY name="LookupStatus" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	STATUSID, STATUSNAME
			FROM		STATUS
			WHERE	STATUSID = <CFQUERYPARAM value="#LookupResearcherInfo.STATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATUSNAME
		</CFQUERY>

		<CFQUERY name="LookupAssistants" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	ASSISTANTID, ASSISTANTNAME
			FROM		ASSISTANTS
			WHERE	ASSISTANTID = <CFQUERYPARAM value="#LookupResearcherInfo.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ASSISTANTNAME
		</CFQUERY>

	<TR>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.HONORIFIC#</DIV></TD>
		<TD align="left" valign="top"><DIV>#LookupResearcherInfo.FULLNAME#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.ADDRESS#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.CITY#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupStateCode.STATECODENAME#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.ZIPCODE#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.PHONE#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.FAX#</DIV></TD>
		<TD align="left" valign="top"><DIV>#LookupResearcherInfo.EMAIL#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.INSTITUTION#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupResearcherInfo.DEPTMAJOR#</DIV></TD>
		
	</TR>
	<TR>
		<TH align="left">ID Type</TH>
		<TH align="left">ID Number</TH>
		<TH align="left">Status</TH>
		<TH align="left" colspan="5">Initial Topic</TH>
		<TH align="left">Registration Date</TH>
		<TH align="left">Modified By</TH>
		<TH align="left">Modified Date</TH>
	</TR>

	<TR>
		<TD align="left"><DIV>#LookupIDTypes.IDTYPENAME#</DIV></TD>
		<TD align="left"><DIV>#LookupResearcherInfo.IDNUMBER#</DIV></TD>
		<TD align="left"><DIV>#LookupStatus.STATUSNAME#</DIV></TD>
		<TD align="left" colspan="5"><DIV>#LookupResearcherInfo.INITIALTOPIC#</DIV></TD>
		<TD align="left"><DIV>#LookupResearcherInfo.CHARREGDATE#</DIV></TD>
		<TD align="left"><DIV>#LookupAssistants.ASSISTANTNAME#</DIV></TD>
		<TD align="left"><DIV>#LookupResearcherInfo.MODDATE#</DIV></TD>
	</TR>
	
		<TD align="LEFT" colspan="11"><HR noshade /></TD>
	<TR>
	</CFLOOP>
	<TR>
		<TH align="LEFT" colspan="11"><H2>#LookupResearcherInfo.RecordCount# Researcher Information records were found.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/specialcollections/researcherinfodbreports.cfm" method="POST">
		<TD align="LEFT" valign="TOP" colspan="11">
			<INPUT type="SUBMIT" value="Cancel" tabindex="2" />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="LEFT" colspan="11">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>