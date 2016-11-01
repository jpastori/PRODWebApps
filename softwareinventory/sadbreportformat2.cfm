<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: sadbreportformat23.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2011 --->
<!--- Date in Production: 08/03/2011 --->
<!--- Module: IDT Software Inventory - Assignments Report --->
<!-- Last modified by John R. Pastori on 08/03/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFSET TITLECOMPARE = "">
<CFOUTPUT query="LookupSoftwareAssignments">
	<CFIF TITLECOMPARE NEQ #LookupSoftwareAssignments.TITLE#>
		<CFSET TITLECOMPARE = #LookupSoftwareAssignments.TITLE#>
	<TR>
		<TH align="LEFT">Title - #LookupSoftwareAssignments.SOFTWAREID#</TH>
		<TH align="center" valign="BOTTOM">Version</TH>
		<TH align="center" valign="BOTTOM">Category</TH>
		<TH align="center" valign="BOTTOM">Platform</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="TOP" nowrap><DIV>#LookupSoftwareAssignments.TITLE#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#LookupSoftwareAssignments.VERSION#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignments.PRODCATNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignments.PRODUCTPLATFORMNAME#</DIV></TD>
	</TR>
	<TR>
		<TH align="LEFT" valign="BOTTOM"><u>Assigned SW Customer</u></TH>
		<TH align="center" valign="BOTTOM">CPU Assigned</TH>
		<TH align="center" valign="BOTTOM">Division Number</TH>
		<TH align="center" valign="BOTTOM">Serial Number</TH>
	</TR>
	

		<CFQUERY name="LookupSoftwareAssignmentDetail" datasource="#application.type#SOFTWARE">
			SELECT	SA.ASSIGNEDCUSTID, SA.SOFTWINVENTID, CUST.CUSTOMERID, CUST.FULLNAME, SA.ASSIGNEDHARDWAREID,
					HI.HARDWAREID, HI.BARCODENUMBER, HI.DIVISIONNUMBER, SA.SERIALNUMBER
			FROM		SOFTWAREASSIGNMENTS SA, LIBSHAREDDATAMGR.CUSTOMERS CUST, HARDWMGR.HARDWAREINVENTORY HI
			WHERE	SA.SOFTWINVENTID = <CFQUERYPARAM value="#LookupSoftwareAssignments.SOFTWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SA.ASSIGNEDCUSTID IN (#ValueList(LookupUnitCustomers.CUSTOMERID)#) AND
					SA.ASSIGNEDCUSTID = CUST.CUSTOMERID AND
					SA.ASSIGNEDHARDWAREID = HI.HARDWAREID
			ORDER	BY CUST.FULLNAME, HI.BARCODENUMBER
		</CFQUERY>

		<CFLOOP query="LookupSoftwareAssignmentDetail">
			<CFSET SARECORDCOUNT = #SARECORDCOUNT# + 1>
	
	<TR>
		<TD align="LEFT" valign="TOP"><DIV><COM><STRONG>#LookupSoftwareAssignmentDetail.FULLNAME#</STRONG></COM></DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.BARCODENUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.DIVISIONNUMBER#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#LookupSoftwareAssignmentDetail.SERIALNUMBER#</DIV></TD>
	</TR>
		</CFLOOP>
	<TR>
		<TD align="CENTER" colspan="7"><HR size="5" noshade /></TD>
	</TR>
	</CFIF>
</CFOUTPUT>