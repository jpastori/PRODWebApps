<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: sadbreportformat23.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2011 --->
<!--- Date in Production: 08/03/2011 --->
<!--- Module: IDT Software Inventory - Assignments Report --->
<!-- Last modified by John R. Pastori on 08/03/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT query="LookupSoftwareAssignments">
	<tr>
		<th align="LEFT" valign="BOTTOM"><u>Unit</u></th>
		<th align="center" valign="BOTTOM"><u>Phone</u></th>
	</tr>

	<tr>
		<td align="LEFT" valign="TOP" nowrap><div><COM><strong>#LookupSoftwareAssignments.UNITNAME#</strong></COM></div></td>
		<td align="center" valign="TOP"><div><COM>#LookupSoftwareAssignments.CAMPUSPHONE#</COM></div></td>
	</tr>

	<CFQUERY name="LookupSoftwareAssignmentDetail" datasource="#application.type#SOFTWARE">
		SELECT	CUST.CUSTOMERID, SI.SOFTWINVENTID, SI.TITLE, SI.VERSION, SI.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME, SI.PRODPLATFORMID,
				PP.PRODUCTPLATFORMNAME, SA.SERIALNUMBER, HI.EQUIPMENTLOCATIONID, LOC.LOCATIONID, LOC.ROOMNUMBER, SA.ASSIGNEDHARDWAREID,
				HI.HARDWAREID, HI.BARCODENUMBER, SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER, SI.FISCALYEARID,
				FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT, HI.DIVISIONNUMBER, HI.STATEFOUNDNUMBER
		FROM		LIBSHAREDDATAMGR.CUSTOMERS CUST, HARDWMGR.HARDWAREINVENTORY HI, SOFTWAREASSIGNMENTS SA, SOFTWAREINVENTORY SI,
				PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.FISCALYEARS FY,
				PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
		WHERE	CUST.CUSTOMERID > 0 AND
				CUST.CUSTOMERID = <CFQUERYPARAM value="#LookupSoftwareAssignments.ASSIGNEDCUSTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.CUSTOMERID = HI.CUSTOMERID AND
				HI.HARDWAREID = SA.ASSIGNEDHARDWAREID AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
				SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
				SI.CATEGORYID = PC.PRODCATID AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.FISCALYEARID = FY.FISCALYEARID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID
		ORDER BY	SI.TITLE, HI.BARCODENUMBER
	</CFQUERY>

	<CFLOOP query="LookupSoftwareAssignmentDetail">
		<CFSET SARECORDCOUNT = #SARECORDCOUNT# + 1>
	<tr>
		<th align="LEFT">Title - #LookupSoftwareAssignmentDetail.SOFTWINVENTID#</th>
		<th align="center" valign="BOTTOM">Version</th>
		<th align="center" valign="BOTTOM">Category</th>
		<th align="center" valign="BOTTOM">Platform</th>
		<th align="center" valign="BOTTOM">Loc</th>
		<th align="center" valign="BOTTOM">Serial Number</th>
	</tr>
	<tr>
		<td align="LEFT" valign="TOP" nowrap><div>#LookupSoftwareAssignmentDetail.TITLE#</div></td>
		<td align="center" valign="TOP" nowrap><div>#LookupSoftwareAssignmentDetail.VERSION#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.PRODCATNAME#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.PRODUCTPLATFORMNAME#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.ROOMNUMBER#</div></td>
		<td align="center" valign="TOP" nowrap><div>#LookupSoftwareAssignmentDetail.SERIALNUMBER#</div></td>
	</tr>
	<tr>
		<th align="LEFT" valign="BOTTOM">Requisition Number</th>
		<th align="center" valign="BOTTOM">Purchase Order Number</th>
		<th align="center" valign="BOTTOM">Fiscal Year</th>
		<th align="center" valign="BOTTOM">State Found Number</th>
		<th align="center" valign="BOTTOM">CPU Assigned</th>
		<th align="center" valign="BOTTOM">Division Number</th>
	</tr>
	<tr>
		<td align="LEFT" valign="TOP"><div>#LookupSoftwareAssignmentDetail.REQNUMBER#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.PONUMBER#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.FISCALYEAR_4DIGIT#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.STATEFOUNDNUMBER#</div></td>
		<td align="center" valign="TOP" nowrap><div>#LookupSoftwareAssignmentDetail.BARCODENUMBER#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.DIVISIONNUMBER#</div></td>
	</tr>
	<tr>
		<td align="CENTER" colspan="6"><hr /></td>
	</tr>
	</CFLOOP>
	<tr>
		<td align="CENTER" colspan="6"><hr size="5" noshade /></td>
	</tr>
</CFOUTPUT>