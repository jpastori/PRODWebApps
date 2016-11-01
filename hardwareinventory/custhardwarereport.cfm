<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custhardwarereport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: IDT Hardware Inventory Customer Hardware by Received Date Report --->
<!-- Last modified by John R. Pastori on 09/18/2012 using ColdFusion Studio. -->

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
			<th align="center"><h1>IDT Hardware Inventory Customer Hardware by Received Date Report</h1></th>
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
			<th align="CENTER" colspan="7">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
		</tr>
		<tr>
			<th align="left">Customer/Barcode</th>
               <th align="left">Division Number</th>
               <th align="left">Date Received</th>
			<th align="left">Warranty Expiration Date</th>
               <th align="left">Equipment Type</th>
			<th align="left">Model Name</th>
			<th align="left">Model Number</th>
			
		</tr>
	<CFSET CUSTOMERHEADER = "">
	<CFLOOP query="LookupHardware">

		<CFQUERY name="LookupHardwareWarranty" datasource="#application.type#HARDWARE">
			SELECT	HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, WARRANTYEXPIRATIONDATE, WARRANTYCOMMENTS
			FROM		HARDWAREWARRANTY
			WHERE	BARCODENUMBER = <CFQUERYPARAM value="#LookupHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY	BARCODENUMBER
		</CFQUERY>

		<CFIF CUSTOMERHEADER NEQ #LookupHardware.FULLNAME#>
			<CFSET CUSTOMERHEADER = #LookupHardware.FULLNAME#>
		<tr>
			<th align="left" nowrap colspan="7"><h5>#LookupHardware.FULLNAME#</h5></th>
		</tr>
		</CFIF>
		<tr>
			<td align="left" valign="TOP"><div>#LookupHardware.BARCODENUMBER#</div></td>
               <td align="left" valign="TOP"><div>#LookupHardware.DIVISIONNUMBER#</div></td>
               <td align="left" valign="TOP"><div>#DateFormat(LookupHardware.DATERECEIVED, "MM/DD/YYYY")#</div></td>
			<td align="left" valign="TOP"><div>#DateFormat(LookupHardwareWarranty.WARRANTYEXPIRATIONDATE, "MM/DD/YYYY")#</div></td>
               <td align="left" valign="TOP"><div>#LookupHardware.EQUIPMENTTYPE#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.MODELNAME#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.MODELNUMBER#</div></td>
		</tr>
	</CFLOOP>
		<tr>
			<th align="CENTER" colspan="7">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
		</tr>
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td align="left" colspan="7"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>

</CFOUTPUT>