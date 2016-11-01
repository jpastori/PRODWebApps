<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: sadbreportformat4.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2011 --->
<!--- Date in Production: 08/03/2011 --->
<!--- Module: IDT Software Inventory - Assignments Report --->
<!-- Last modified by John R. Pastori on 08/03/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<CFLOOP query="LookupAssignedBarcode">
	<tr>
		<th align="LEFT" valign="BOTTOM"><u>State Found Number</u></th>
		<th align="center" valign="BOTTOM"><u>Division Number</u></th>
		<th align="center" valign="BOTTOM"><u>Assigned Customer</u></th>
		<th align="center" valign="BOTTOM"><u>Unit</u></th>
		<th align="center" valign="BOTTOM"><u>Loc</u></th>
		<th align="center" valign="BOTTOM"><u>Phone</u></th>
	</tr>

	<tr>
		<td align="LEFT" valign="TOP"><H5><strong>#LookupAssignedBarcode.STATEFOUNDNUMBER#</strong></h5></td>
		<td align="center" valign="TOP"><H5><strong>#LookupAssignedBarcode.DIVISIONNUMBER#</strong></h5></td>
		<td align="center" valign="TOP"><h5><strong>#LookupAssignedBarcode.FULLNAME#</strong></h5></td>
		<td align="center" valign="TOP" nowrap><h5><strong>#LookupAssignedBarcode.UNITNAME#</strong></h5></td>
		<td align="center" valign="TOP"><h5><strong>#LookupAssignedBarcode.ROOMNUMBER#</strong></h5></td>
		<td align="center" valign="TOP"><h5><strong>#LookupAssignedBarcode.CAMPUSPHONE#</strong></h5></td>
	</tr>
	<tr>
		<td align="CENTER" colspan="6"><hr size="5" noshade /></td>
	</tr>	

	<CFQUERY name="LookupSoftwareAssignmentDetail" datasource="#application.type#SOFTWARE">
		SELECT	DISTINCT CUST.CUSTOMERID, CUST.FULLNAME, SI.SOFTWINVENTID, SI.TITLE, SI.VERSION, SI.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME,
				SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME, SA.SERIALNUMBER, HI.EQUIPMENTLOCATIONID, SA.ASSIGNEDHARDWAREID, HI.HARDWAREID, 
				HI.BARCODENUMBER, SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER, SI.FISCALYEARID, FY.FISCALYEARID,
				FY.FISCALYEAR_4DIGIT
		FROM		SOFTWAREASSIGNMENTS SA, LIBSHAREDDATAMGR.CUSTOMERS CUST, HARDWMGR.HARDWAREINVENTORY HI, SOFTWAREINVENTORY SI,
				PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP, LIBSHAREDDATAMGR.FISCALYEARS FY, PURCHASEMGR.PURCHREQLINES PRL,
				PURCHASEMGR.PURCHREQS PR
		WHERE	SA.ASSIGNEDHARDWAREID = <CFQUERYPARAM value="#LookupAssignedBarcode.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.CUSTOMERID = HI.CUSTOMERID AND
				SA.ASSIGNEDHARDWAREID = HI.HARDWAREID  AND
				SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
				SI.CATEGORYID = PC.PRODCATID AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.FISCALYEARID = FY.FISCALYEARID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID
		ORDER BY	CUST.FULLNAME, HI.BARCODENUMBER, SI.TITLE
	</CFQUERY>

	<CFLOOP query="LookupSoftwareAssignmentDetail">
			<CFSET SARECORDCOUNT = #SARECORDCOUNT# + 1>
	<tr>
		<th align="LEFT" valign="BOTTOM" colspan="2">Title - #LookupSoftwareAssignmentDetail.SOFTWINVENTID#</th>
		<th align="center" valign="BOTTOM">Version</th>
		<th align="center" valign="BOTTOM">Category</th>
		<th align="center" valign="BOTTOM">Product Platform</th>
		<th align="center" valign="BOTTOM">Serial Number</th>
	</tr>
	<tr>
		<td align="LEFT" valign="TOP" nowrap colspan="2"><div>#LookupSoftwareAssignmentDetail.TITLE#</div></td>
		<td align="center" valign="TOP" nowrap><div>#LookupSoftwareAssignmentDetail.VERSION#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.PRODCATNAME#</div></td>
		<td align="center" valign="TOP"><div>#LookupSoftwareAssignmentDetail.PRODUCTPLATFORMNAME#</div></td>
		<td align="center" valign="TOP" nowrap><div>#LookupSoftwareAssignmentDetail.SERIALNUMBER#</div></td>
	</tr>
	<tr>
		<td align="CENTER" colspan="6"><hr /></td>
	</tr>
	</CFLOOP>
	<tr>
		<td align="CENTER" colspan="6"><hr size="5" noshade /></td>
	</tr>
</CFLOOP>
</CFOUTPUT>