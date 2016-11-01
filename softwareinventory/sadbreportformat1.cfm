<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: sadbreportformat1.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2011 --->
<!--- Date in Production: 08/03/2011 --->
<!--- Module: IDT Software Inventory - Assignments Report --->
<!-- Last modified by John R. Pastori on 08/10/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT query="LookupSoftwareInventory">
	<tr>
		<th align="center" valign="BOTTOM"><u>Version - Qty Lic</u></th>
		<th align="center" valign="BOTTOM"><u>Category</u></th>
		<th align="center" valign="BOTTOM"><u>Platform</u></th>
		<th align="center" valign="BOTTOM"><u>Fiscal Year</u></th>
		<th align="center" valign="BOTTOM"><u>Requisition Number</u></th>
		<th align="center" valign="BOTTOM"><u>Purchase Order Number</u></th>
	</tr>
	<tr>
		<td align="center" valign="TOP"><H5><strong>#LookupSoftwareInventory.VERSION# - #LookupSoftwareInventory.QTYLICENSED#</strong></h5></td>
		<td align="center" valign="TOP"><h5><strong>#LookupSoftwareInventory.PRODCATNAME#</strong></h5></td>
		<td align="center" valign="TOP"><h5><strong>#LookupSoftwareInventory.PRODUCTPLATFORMNAME#</strong></h5></td>
		<td align="center" valign="TOP"><h5><strong>#LookupSoftwareInventory.FISCALYEAR_4DIGIT#</strong></h5></td>
		<td align="center" valign="TOP"><h5><strong>#LookupSoftwareInventory.REQNUMBER#</strong></h5></td>
		<td align="center" valign="TOP"><h5><strong>#LookupSoftwareInventory.PONUMBER#</strong></h5></td>
	</tr>
	<tr>
		<td align="CENTER" colspan="6"><hr size="5" noshade /></td>
	</tr>
	<tr>
     	<th align="center" valign="BOTTOM">&nbsp;&nbsp;</th>
		<th align="center" valign="BOTTOM">Assigned SW Customer</th>
		<th align="center" valign="BOTTOM">Unit</th>
		<th align="center" valign="BOTTOM">Phone</th>
		<th align="center" valign="BOTTOM">Serial Number</th>
          <th align="center" valign="BOTTOM">&nbsp;&nbsp;</th>
	</tr>

	<CFQUERY name="LookupSoftwareAssignmentDetail" datasource="#application.type#SOFTWARE">
		SELECT	SI.TITLE, SI.VERSION, SI.FISCALYEARID, SA.SERIALNUMBER, HI.EQUIPMENTLOCATIONID, LOC.LOCATIONID,
				LOC.ROOMNUMBER, SA.ASSIGNEDHARDWAREID, HI.HARDWAREID, HI.BARCODENUMBER, SA.ASSIGNEDCUSTID, SWCUST.FULLNAME AS SWNAME,
				U.UNITNAME, SWCUST.CAMPUSPHONE, HWCUST.CUSTOMERID, HWCUST.FULLNAME AS HWNAME, HI.DIVISIONNUMBER, HI.STATEFOUNDNUMBER
		FROM		SOFTWAREASSIGNMENTS SA, SOFTWAREINVENTORY SI, HARDWMGR.HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC,
				LIBSHAREDDATAMGR.CUSTOMERS SWCUST, LIBSHAREDDATAMGR.UNITS U, LIBSHAREDDATAMGR.CUSTOMERS HWCUST
		WHERE	SA.SOFTWINVENTID = <CFQUERYPARAM value="#LookupSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
				SA.ASSIGNEDCUSTID = SWCUST.CUSTOMERID AND
				SWCUST.UNITID = U.UNITID AND
				SA.ASSIGNEDHARDWAREID = HI.HARDWAREID AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
				HI.CUSTOMERID = HWCUST.CUSTOMERID
		ORDER BY	SI.TITLE, SWCUST.FULLNAME, HI.BARCODENUMBER
	</CFQUERY>

	<CFLOOP query="LookupSoftwareAssignmentDetail">
		<CFSET SARECORDCOUNT = #SARECORDCOUNT# + 1>
	
	<tr>
     	<td align="center" valign="BOTTOM">&nbsp;&nbsp;</td>
		<td align="center" valign="TOP" nowrap><div><COM><strong>#LookupSoftwareAssignmentDetail.SWNAME#</strong></COM></div></td>
		<td align="center" valign="TOP" nowrap><div><COM>#LookupSoftwareAssignmentDetail.UNITNAME#</COM></div></td>
		<td align="center" valign="TOP"><div><COM>#LookupSoftwareAssignmentDetail.CAMPUSPHONE#</COM></div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.SERIALNUMBER#</div></td>
          <td align="center" valign="BOTTOM">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="center" valign="BOTTOM">&nbsp;&nbsp;</th>
		<th align="center" valign="BOTTOM">State Found Number</th>
		<th align="center" valign="BOTTOM">CPU Assigned /<br />HW Customer</th>
		<th align="center" valign="BOTTOM">Division Number</th>
		<th align="center" valign="BOTTOM">Loc</th>
          <th align="center" valign="BOTTOM">&nbsp;&nbsp;</th>
	</tr>
	<tr>
		<td align="center" valign="TOP"><div>&nbsp;&nbsp;</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.STATEFOUNDNUMBER#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.BARCODENUMBER# /<br />#LookupSoftwareAssignmentDetail.HWNAME#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.DIVISIONNUMBER#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.ROOMNUMBER#</div></td>
          <td align="center" valign="BOTTOM">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td align="CENTER" colspan="6"><hr /></td>
	</tr>
	</CFLOOP>
	<tr>
		<td align="CENTER" colspan="6"><hr size="5" noshade /></td>
	</tr>
</CFOUTPUT>