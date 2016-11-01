<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: purchasewarrantyreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Inventory and Archive Purchase Warranty Report --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

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
			<th align="center">
				<CFIF URL.PROCESS EQ 'REPORT'>
					<h1>Inventory Purchase Warranty Report</h1>
				<CFELSE>
					<h1>Archive Purchase Warranty Report</h1>
				</CFIF>
			</th>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<th align="CENTER" colspan="10">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
		</tr>
		<tr>
			<th align="left">Req. Number</th>
			<th align="left">P.O. Number</th>
			<th align="left">Fiscal Year</th>
			<th align="left">Date Received</th>
			<th align="left">Bar Code Number</th>
			<th align="left">State Found Number</th>
			<th align="left">Serial Number</th>
			<th align="left">Equipment Type</th>
			<th align="left">Assigned Customer</th>
			<th align="left">Equipment Location</th>
		</tr>

	<CFLOOP query="LookupHardware">

		<CFQUERY name="LookupVendorContacts" datasource="#application.type#PURCHASING">
			SELECT	VENDORCONTACTID, VENDORID, CONTACTNAME, PHONENUMBER, FAXNUMBER, EMAILADDRESS
			FROM		VENDORCONTACTS
			WHERE	VENDORCONTACTS.VENDORID = <CFQUERYPARAM value="#LookupHardware.WARRANTYVENDORID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CONTACTNAME
		</CFQUERY>

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

		<tr>
			<td align="left" valign="TOP" nowrap><div>#LookupHardware.REQUISITIONNUMBER#</div></td>
			<td align="left" valign="TOP" nowrap><div>#LookupHardware.PURCHASEORDERNUMBER#</div></td>
			<td align="left" valign="TOP" nowrap><div>#LookupHardware.FISCALYEAR_4DIGIT#</div></td>
			<td align="left" valign="TOP" nowrap><div>#DateFormat(LookupHardware.DATERECEIVED, "MM/DD/YYYY")#</div></td>
			<td align="left" valign="TOP" nowrap><div>#LookupHardware.BARCODENUMBER#</div></td>
			<td align="left" valign="TOP" ><div>#LookupHardware.STATEFOUNDNUMBER#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.SERIALNUMBER#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.EQUIPMENTTYPE#</div></td>
			<td align="left" valign="TOP"><div>#LookupHardware.FULLNAME#</div></td>
			<td align="left" valign="TOP" nowrap><div>#LookupHardware.ROOMNUMBER#</div></td>
		</tr>
		<tr>
			<th align="left" valign="TOP">Manufacturer<br />Vendor<br />Name:</th>
			<td align="left" valign="TOP"><div>#LookupHardware.VENDORNAME#</div></td>
			<th align="left" valign="TOP">Warranty<br />Vendor<br />Name:</th>
			<td align="left" valign="TOP"><div>#LookupHardware.WARRVENDNAME#</div></td>
			<th align="left" valign="TOP">Warranty Contact Name/Phone:</th>
			<td align="left" valign="TOP" nowrap>
			<CFLOOP query="LookupVendorContacts">
				<ul>
					<li><div>#CONTACTNAME#<br />#PHONENUMBER#</div></li>
				</ul>
			</CFLOOP>
			</td>
			<th align="left" valign="TOP">Warranty Expiration Date:</th>
			<td align="left" valign="TOP"><div>#DateFormat(LookupHardwareWarranty.WARRANTYEXPIRATIONDATE, "MM/DD/YYYY")#</div></td>
			<th align="left" valign="TOP">Warranty Restrictions:</th>
			<td align="left" valign="TOP"><div>#LookupHardwareWarranty.WARRANTYRESTRICTIONS#</div></td>
		</tr>
		<tr>
			<th align="left" valign="TOP">Modified By Name:</th>
			<td align="left" valign="TOP"><div>#LookupRecordModifier.FULLNAME#</div></td>
			<th align="left" valign="TOP">Date<br />Checked:</th>
			<td align="left" valign="TOP"><div>#DateFormat(LookupHardware.DATECHECKED, "MM/DD/YYYY")#</div></td>
			<th align="left" valign="TOP">Express Service:</th>
			<td align="left" valign="TOP"><div>#LookupHardware.DELLEXPRESSSERVICE#</div></td>
			<th align="left" valign="TOP">Warranty Comments:</th>
			<td align="left" valign="MIDDLE" colspan="3"><div>#LookupHardwareWarranty.WARRANTYCOMMENTS#</div></td>
		</tr>
		<tr>
			<td colspan="10"><hr width="100%" size="5" noshade /></td>
		</tr>
	</CFLOOP>
		<tr>
			<th align="CENTER" colspan="10">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
		</tr>
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td align="left" colspan="10"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</CFOUTPUT>