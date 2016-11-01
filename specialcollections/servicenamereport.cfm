<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: servicenamereport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/16/2008 --->
<!--- Date in Production: 05/16/2008 --->
<!--- Module: Special Collections - Service Name Report --->
<!-- Last modified by John R. Pastori on 05/16/2007 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Special Collections - Service Name Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFSET COMPARESERVICENAME = "">

<TABLE width="100%" align="LEFT" border="3">
	<TR align="center">
		<TH align="center"><H1>Special Collections - Service Name Report</H1></TH>
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

		<CFQUERY name="LookupAssistants" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	ASSISTANTID, ASSISTANTNAME
			FROM		ASSISTANTS
			WHERE	ASSISTANTID = <CFQUERYPARAM value="#LookupMatrlReqsDups.ASSISTANTNAMEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ASSISTANTNAME
		</CFQUERY>

		<CFQUERY name="LookupPaidTypes" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="10">
			SELECT	PAIDTYPEID, PAIDTYPENAME
			FROM		PAIDTYPES
			WHERE	PAIDTYPEID = <CFQUERYPARAM value="#LookupMatrlReqsDups.PAIDTYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PAIDTYPENAME
		</CFQUERY>


<CFIF #COMPARESERVICENAME# NEQ #LookupMatrlReqsDups.SERVICENAME#>
	<TR>
		<TD align="LEFT" colspan="12"><HR size="5" noshade /></TD>
	</TR>
	<TR>
		<TD align="left" valign="top" colspan="2"><H2>Service Name:</H2></TD>
		<TD align="left" valign="top"colspan="6"><H2>#LookupMatrlReqsDups.SERVICENAME#</H2></TD>
	</TR>
	<CFSET COMPARESERVICENAME = #LookupMatrlReqsDups.SERVICENAME#>
</CFIF>
	<TR>
		<TH align="center" valign="bottom">Collection Name</TH>
		<TH align="center" valign="bottom">Call Number</TH>
		<TH align="center" valign="bottom">Box Number</TH>
		<TH align="center" valign="bottom">Total Copies Made</TH>
		<TH align="center" valign="bottom">Cost For Service</TH>
		<TH align="center" valign="bottom">Paid Types</TH>
		<TH align="center" valign="bottom">Service Date</TH>
		<TH align="center" valign="bottom">Assistant Name</TH>
		<TH align="left" valign="bottom" colspan="4">Comments</TH>
	</TR>
	<TR>
		<TD align="center" valign="top"><DIV>#LookupMatrlReqsDups.COLLECTIONNAME#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupMatrlReqsDups.CALLNUMBER#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupMatrlReqsDups.BOXNUMBER#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupMatrlReqsDups.TOTALCOPIESMADE#</DIV></TD>
		<TD align="center" valign="top"><DIV>#DollarFormat(LookupMatrlReqsDups.COSTFORSERVICE)#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupPaidTypes.PAIDTYPENAME#</DIV></TD>
		<TD align="center" valign="top"><DIV>#DateFormat(LookupMatrlReqsDups.SERVICEDATE, "MM/DD/YYYY")#</DIV></TD>
		<TD align="center" valign="top"><DIV>#LookupAssistants.ASSISTANTNAME#</DIV></TD>
		<TD align="left" valign="top" colspan="4"><DIV>#LookupMatrlReqsDups.COMMENTS#</DIV></TD>
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