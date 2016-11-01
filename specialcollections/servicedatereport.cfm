<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: servicedatereport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/16/2008 --->
<!--- Date in Production: 05/16/2008 --->
<!--- Module: Special Collections - Service Date Report --->
<!-- Last modified by John R. Pastori on 05/16/2007 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Special Collections - Service Date Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFSET COMPARESERVICEDATE = "1899-12-31">

<TABLE width="100%" align="LEFT" border="3">
	<TR align="center">
		<TH align="center"><H1>Special Collections - Service Date Report</H1></TH>
	</TR>
</TABLE>
<BR /><BR /><BR />
<TABLE width="100%" align="center" border="0">
	<TR>
<CFFORM action="/#application.type#apps/specialcollections/matrlreqsdupsdbreports.cfm" method="POST">
		<TD align="LEFT" valign="TOP" colspan="12">
			<INPUT type="SUBMIT" value="Cancel" tabindex="1" />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="LEFT" colspan="12"><H2>#LookupMatrlReqsDups.RecordCount# Material Requests & Duplications records were found.</H2></TH>
	</TR>

	<CFLOOP query="LookupMatrlReqsDups">

		<CFQUERY name="LookupCollections" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	COLLECTIONID, COLLECTIONNAME
			FROM		COLLECTIONS
			WHERE	COLLECTIONID = <CFQUERYPARAM value="#LookupMatrlReqsDups.COLLECTIONID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	COLLECTIONNAME
		</CFQUERY>

		<CFQUERY name="LookupAssistants" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	ASSISTANTID, ASSISTANTNAME
			FROM		ASSISTANTS
			WHERE	ASSISTANTID = <CFQUERYPARAM value="#LookupMatrlReqsDups.ASSISTANTNAMEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ASSISTANTNAME
		</CFQUERY>

		<CFQUERY name="LookupSecondAssistants" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	ASSISTANTID, ASSISTANTNAME
			FROM		ASSISTANTS
			WHERE	ASSISTANTID = <CFQUERYPARAM value="#LookupMatrlReqsDups.SECONDASSISTANTNAMEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ASSISTANTNAME
		</CFQUERY>

		<CFQUERY name="LookupServices" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	SERVICEID, SERVICENAME
			FROM		SERVICES
			WHERE	SERVICEID = <CFQUERYPARAM value="#LookupMatrlReqsDups.SERVICEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SERVICENAME
		</CFQUERY>

		<CFQUERY name="LookupActiveApprovers" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="25">
			SELECT	ASSISTANTID, ASSISTANTNAME, ACTIVE
			FROM		ASSISTANTS
			WHERE	ASSISTANTID = <CFQUERYPARAM value="#LookupMatrlReqsDups.APPROVEDBYID#" cfsqltype="CF_SQL_NUMERIC"> AND
					ACTIVE = 'YES' AND
					APPROVAL = 'YES'
			ORDER BY	ASSISTANTNAME
		</CFQUERY>

		<CFQUERY name="LookupPaidTypes" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="10">
			SELECT	PAIDTYPEID, PAIDTYPENAME
			FROM		PAIDTYPES
			WHERE	PAIDTYPEID = <CFQUERYPARAM value="#LookupMatrlReqsDups.PAIDTYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PAIDTYPENAME
		</CFQUERY>

		<CFQUERY name="LookupModifiedBy" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	ASSISTANTID, ASSISTANTNAME
			FROM		ASSISTANTS
			WHERE	ASSISTANTID = <CFQUERYPARAM value="#LookupMatrlReqsDups.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ASSISTANTNAME
		</CFQUERY>

<CFIF #COMPARESERVICEDATE# NEQ #LookupMatrlReqsDups.CHARSERVICEDATE#>
	<TR>
		<TD align="LEFT" colspan="12"><HR size="5" noshade /></TD>
	</TR>
	<TR>
		<TD align="left" valign="top" colspan="2"><H2>Service Date:</H2></TD>
		<TD align="left" valign="top"><H2>#DateFormat(LookupMatrlReqsDups.CHARSERVICEDATE, "MM/DD/YYYY")#</H2></TD>
	</TR>
	<CFSET COMPARESERVICEDATE = #LookupMatrlReqsDups.CHARSERVICEDATE#>
</CFIF>
	<TR>
		<TH align="center" valign="bottom">Researcher Name</TH>
		<TH align="LEFT" valign="bottom">Topic</TH>
		<TH align="center" valign="bottom">Collection Name</TH>
		<TH align="center" valign="bottom">Call Number</TH>
		<TH align="center" valign="bottom">Box Number</TH>
		<TH align="center" valign="bottom">Service Name</TH>
		<TH align="center" valign="bottom">Total Copies Made</TH>
		<TH align="center" valign="bottom">Cost For Service</TH>
		<TH align="center" valign="bottom">Paid Types</TH>
		<TH align="center" valign="bottom">Approved By</TH>
		<TH align="center" valign="bottom">Assistant Name</TH>
		<TH align="center" valign="bottom">Second Assistant Name</TH>
	</TR>
	<TR>
		<TD align="left" valign="top"><DIV>#LookupMatrlReqsDups.FULLNAME#</DIV></TD>
		<TD align="left" valign="top"><DIV>#LookupMatrlReqsDups.TOPIC#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupCollections.COLLECTIONNAME#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupMatrlReqsDups.CALLNUMBER#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupMatrlReqsDups.BOXNUMBER#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupServices.SERVICENAME#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupMatrlReqsDups.TOTALCOPIESMADE#</DIV></TD>
		<TD align="center" valign="top"><DIV>#DollarFormat(LookupMatrlReqsDups.COSTFORSERVICE)#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupPaidTypes.PAIDTYPENAME#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupActiveApprovers.ASSISTANTNAME#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupAssistants.ASSISTANTNAME#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupSecondAssistants.ASSISTANTNAME#</DIV></TD>
	</TR>
	<TR>
		<TH align="left" valign="top">Comments:</TH>
		<TD align="left" valign="top" colspan="7"><DIV>#LookupMatrlReqsDups.COMMENTS#</DIV></TD>
		<TH align="center" valign="top">Modified By:</TH>
		<TD align="left" valign="top"><DIV>#LookupModifiedBy.ASSISTANTNAME#</DIV></TD>
		<TH align="center" valign="top">Date Modified:</TH>
		<TD align="left" valign="top"><DIV>#DateFormat(LookupMatrlReqsDups.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
	</TR>
	<TR>
		<TD align="LEFT" colspan="12"><HR noshade /></TD>
	</TR>
	</CFLOOP>
	<TR>
		<TD align="LEFT" colspan="12"><HR size="5" noshade /></TD>
	</TR>
	<TR>
		<TH align="LEFT" colspan="12"><H2>#LookupMatrlReqsDups.RecordCount# Material Requests & Duplications records were found.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/specialcollections/matrlreqsdupsdbreports.cfm" method="POST">
		<TD align="LEFT" valign="TOP" colspan="12">
			<INPUT type="SUBMIT" value="Cancel" tabindex="2" />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="LEFT" colspan="12">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>