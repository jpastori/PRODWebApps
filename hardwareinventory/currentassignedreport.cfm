<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: currentassignedreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: IDT Hardware Inventory Current Assignment by Bar Code Report --->
<!-- Last modified by John R. Pastori on 07/12/2012 using ColdFusion Studio. -->

<CFIF (FIND('wiki', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "WIKI")>
	<CFSET SESSION.ORIGINSERVER = "WIKI">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSEIF (FIND('#application.type#apps/forms', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "FORMS")>
	<CFSET SESSION.ORIGINSERVER = "FORMS">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSE>
	<CFINCLUDE template = "../programsecuritycheck.cfm">
	<CFSET SESSION.ORIGINSERVER = "">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
</CFIF>

<CFOUTPUT>
	<table width="100%" align="center" border="3">
		<tr align="center">
			<th align="center"><h1>IDT Hardware Inventory Current Assignment by Bar Code Report</h1></th>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<th align="CENTER" colspan="12">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
		</tr>
		<tr>
			<th align="CENTER">Bar Code Number</th>
			<th align="CENTER">State Found Number</th>
			<th align="CENTER">Serial Number</th>
			<th align="CENTER">Division Number</th>
			<th align="CENTER">Equipment Type</th>
			<th align="CENTER">Equipment Description</th>
			<th align="CENTER">Model Name</th>
			<th align="CENTER">Model Number</th>
			<th align="CENTER">Warranty Expiration</th>
			<th align="CENTER">Equipment Location</th>
			<th align="CENTER">Modified-By Name</th>
			<th align="CENTER">Date Checked</th>
		</tr>
	<CFSET CUSTOMERHEADER = "">
	<CFLOOP query="LookupHardware">

		<CFQUERY name="LookupHardwareWarranty" datasource="#application.type#HARDWARE">
			SELECT	HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, WARRANTYEXPIRATIONDATE, WARRANTYCOMMENTS
			FROM		HARDWAREWARRANTY
			WHERE	BARCODENUMBER = <CFQUERYPARAM value="#LookupHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY	BARCODENUMBER
		</CFQUERY>

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, FULLNAME || '-' || INITIALS AS SDINITIALS
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#LookupHardware.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFIF CUSTOMERHEADER NEQ #LookupHardware.FULLNAME#>
			<CFSET CUSTOMERHEADER = #LookupHardware.FULLNAME#>
		<tr>
			<th align="left" nowrap colspan="3"><h2>#LookupHardware.FULLNAME#</h2></th>
		</tr>
		</CFIF>
		<tr>
			<td align="left" valign="TOP" nowrap><div>#LookupHardware.BARCODENUMBER#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.STATEFOUNDNUMBER#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.SERIALNUMBER#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.DIVISIONNUMBER#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.EQUIPMENTTYPE#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.EQUIPMENTDESCRIPTION#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.MODELNAME#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.MODELNUMBER#</div></td>
			<td align="left" valign="TOP"><div>#DateFormat(LookupHardwareWarranty.WARRANTYEXPIRATIONDATE, "MM/DD/YYYY")#</div></td>
			<td align="left" valign="TOP" nowrap><div>#LookupHardware.ROOMNUMBER#</div></td>
			<td align="left" valign="TOP" nowrap><div>#LookupRecordModifier.FULLNAME#</div></td>
			<td align="left" valign="TOP"><div>#DateFormat(LookupHardware.DATECHECKED, "MM/DD/YYYY")#</div></td>
		</tr>
	</CFLOOP>
		<tr>
			<th align="CENTER" colspan="12">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
		</tr>
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td align="left" colspan="12"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>

</CFOUTPUT>