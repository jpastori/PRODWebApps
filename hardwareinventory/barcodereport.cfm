<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: barcodereport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: Process Information for Inventory and Archive Bar Code Report --->
<!-- Last modified by John R. Pastori on 12/05/2013 using ColdFusion Studio. -->

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
					<h1>Inventory Bar Code Report</h1>
				<CFELSE>
					<h1>Archive Bar Code Report</h1>
				</CFIF>
			</th>
		</tr>
	</table>
	<table align="left" border="0">
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" method="POST">
			<td align="left">
               	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<th align="CENTER" colspan="8"><h2>#LookupHardware.RecordCount# hardware records were selected.</h2></th>
		</tr>

	<CFLOOP query="LookupHardware">

		<CFQUERY name="LookupHardwareAttachedTo" datasource="#application.type#HARDWARE">
			SELECT	HARDWAREATTACHEDTO.ATTACHEDTOID, HARDWAREATTACHEDTO.BARCODENUMBER, HARDWAREATTACHEDTO.ATTACHEDTO,
					HARDWAREINVENTORY.BARCODENUMBER AS ATTACHEDBARCODE
			FROM		HARDWAREATTACHEDTO, HARDWAREINVENTORY
			WHERE	HARDWAREATTACHEDTO.BARCODENUMBER = <CFQUERYPARAM value="#LookupHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
					HARDWAREATTACHEDTO.ATTACHEDTO = HARDWAREINVENTORY.HARDWAREID
		</CFQUERY>

		<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA">
			SELECT	UNITS.UNITID, UNITS.UNITNAME
			FROM		UNITS
			WHERE	UNITS.UNITID = <CFQUERYPARAM value="#LookupHardware.UNITID#" cfsqltype="CF_SQL_NUMERIC">
		</CFQUERY>

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, FULLNAME || '-' || INITIALS AS SDINITIALS
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#LookupHardware.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFQUERY name="LookupCustomerCategories" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.CATEGORYID, CAT.CATEGORYID, CAT.CATEGORYNAME, CUST.FULLNAME
			FROM		CUSTOMERS CUST, CATEGORIES CAT
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#LookupHardware.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CUST.CATEGORYID = CAT.CATEGORYID
			ORDER BY	CUST.FULLNAME
		</CFQUERY>

		<CFQUERY name="LookupOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
			SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
			FROM		ORGCODES
			WHERE	ORGCODEID = <CFQUERYPARAM value="#LookupHardware.OWNINGORGID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ORGCODE
		</CFQUERY>

		<tr>
			<th align="CENTER" valign="BOTTOM">Bar Code Number</th>
			<th align="CENTER" valign="BOTTOM">State Found Number</th>
			<th align="CENTER" valign="BOTTOM">Serial Number</th>
			<th align="CENTER" valign="BOTTOM">Division Number</th>

		<CFIF URL.PROCESS EQ 'REPORT'>
			<th align="CENTER" valign="BOTTOM">IP Address</th>
               <th align="CENTER" valign="BOTTOM">Hardware (MAC) Address</th>
			<th align="CENTER" valign="BOTTOM">Airport/WIFI ID</th>
			<th align="CENTER" valign="BOTTOM">Bluetooth ID</th>
          <CFELSE>
          	<th align="CENTER" valign="BOTTOM" colspan="4">&nbsp;&nbsp;</th>
		</CFIF>
		
		</tr>
		<tr>
			<td align="CENTER" valign="TOP" nowrap><div>#LookupHardware.BARCODENUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.STATEFOUNDNUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.SERIALNUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.DIVISIONNUMBER#</div></td>

		<CFIF URL.PROCESS EQ 'REPORT'>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.IPADDRESS#</div></td>
               <td align="CENTER" valign="TOP"><div>#LookupHardware.MACADDRESS#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.AIRPORTID#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.BLUETOOTHID#</div></td>
          <CFELSE>
          	<td align="CENTER" valign="TOP" colspan="4">&nbsp;&nbsp;</td>
		</CFIF>
  
		</tr>
		<tr>
          	<th align="CENTER" valign="BOTTOM">Equipment Type</th>
			<th align="CENTER" valign="BOTTOM">Equipment Description</th>
			<th align="CENTER" valign="BOTTOM">Model Name</th>
			<th align="CENTER" valign="BOTTOM">Model Number</th>
          <CFIF URL.PROCESS EQ 'REPORT'>
			<th align="CENTER" valign="BOTTOM">Cluster Name</th>
               <th align="CENTER" valign="BOTTOM">Equipment Attached To</th>
          <CFELSE>
          	<th align="CENTER" valign="BOTTOM" colspan="2">Equipment Attached To</th>
		</CFIF>
			<th align="CENTER" valign="BOTTOM">Room Number</th>
			<th align="CENTER" valign="BOTTOM">Assigned Customer</th>
		</tr>
		<tr>
          	<td align="CENTER" valign="TOP"><div>#LookupHardware.EQUIPMENTTYPE#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.EQUIPMENTDESCRIPTION#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.MODELNAME#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.MODELNUMBER#</div></td>
         <CFIF URL.PROCESS EQ 'REPORT'>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.CLUSTERNAME#</div></td>
               <td align="left" valign="TOP">
				<CFLOOP query="LookupHardwareAttachedTo">
					<ul>
						<li><div>#ATTACHEDBARCODE#</div></li>
					</ul>
				</CFLOOP>
			</td>
         <CFELSE>
          	 <td align="left" valign="TOP" colspan="2">
				<CFLOOP query="LookupHardwareAttachedTo">
					<ul>
						<li><div>#ATTACHEDBARCODE#</div></li>
					</ul>
				</CFLOOP>
			</td>
		</CFIF>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.ROOMNUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.FULLNAME#</div></td>
		</tr>
		<tr>
          	<th align="CENTER" valign="BOTTOM">Unit Name</th>
			<th align="CENTER" valign="BOTTOM">Modified By Name</th>
			<th align="CENTER" valign="BOTTOM">Owning Organization Code</th>
			<th align="CENTER" valign="BOTTOM">Date Checked</th>
			<th align="CENTER" valign="BOTTOM">Customer Category</th>
			<th align="CENTER" valign="BOTTOM" colspan="3">Comments</th>
		</tr>
		<tr>
          	<td align="CENTER" valign="TOP"><div>#LookupUnits.UNITNAME#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupRecordModifier.FULLNAME#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupOrgCodes.ORGCODENAME#</div></td>
			<td align="CENTER" valign="TOP"><div>#DateFormat(LookupHardware.DATECHECKED, "MM/DD/YYYY")#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupCustomerCategories.CATEGORYNAME#</div></td>
			<td align="LEFT" valign="TOP" colspan="3"><div>#LookupHardware.COMMENTS#</div></td>
		</tr>
		<tr>
			<td colspan="8"><hr width="100%" size="5" noshade /></td>
		</tr>
	</CFLOOP>
	<br />
		<tr>
			<th align="CENTER" colspan="8"><h2>#LookupHardware.RecordCount# hardware records were selected.</h2></th>
		</tr>
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" method="POST">
			<td align="left">
               	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td align="left" colspan="8"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</CFOUTPUT>