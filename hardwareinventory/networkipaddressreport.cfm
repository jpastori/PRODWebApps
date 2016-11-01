<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: networkipaddressreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Process Information to IDT Hardware Inventory Network IP Address Report --->
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
			<th align="center"><h1>IDT Hardware Inventory Network IP Address Report</h1></th>
		</tr>
	</table>
	<table align="left" border="0">
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<td align="left" colspan="13">
               	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<th align="CENTER" colspan="13">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
		</tr>
		<tr>
			<th align="CENTER">IP Address</th>
			<th align="CENTER">Mac Address</th>
               <th align="CENTER">Airport/WIFI ID</th>
			<th align="CENTER">Bluetooth ID</th>
			<th align="CENTER">Machine Name</th>
			<th align="CENTER">Room Number</th>
			<th align="CENTER">Bar Code Number</th>
			<th align="CENTER">State Found Number</th>
			<th align="CENTER">Serial Number</th>
			<th align="CENTER">Division Number</th>
			<th align="CENTER">Equipment Type</th>
			<th align="CENTER">Model Name</th>
			<th align="CENTER">Model Number</th>
		</tr>
	<CFLOOP query="LookupHardware">

		<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA">
			SELECT	UNITS.UNITID, UNITS.UNITNAME
			FROM		UNITS
			WHERE	UNITS.UNITID = <CFQUERYPARAM value="#LookupHardware.UNITID#" cfsqltype="CF_SQL_NUMERIC">
		</CFQUERY>

		<CFQUERY name="LookupJackNumbers" datasource="#application.type#FACILITIES">
			SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, WJ.WALLDIRID, WD.WALLDIRNAME,
					WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.ACTIVE, WJ.HARDWAREID, WJ.CUSTOMERID, CUST.FULLNAME, WJ.COMMENTS
			FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN, WALLDIRECTION WD, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	WJ.HARDWAREID = <CFQUERYPARAM value="#LookupHardware.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
					WJ.LOCATIONID = LOC.LOCATIONID AND
					LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
					WJ.WALLDIRID = WD.WALLDIRID AND
					WJ.CUSTOMERID = CUST.CUSTOMERID
			ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER, WD.WALLDIRNAME
		</CFQUERY>

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, FULLNAME || '-' || INITIALS AS SDINITIALS
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#LookupHardware.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<tr>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.IPADDRESS#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.MACADDRESS#</div></td>
               <td align="CENTER" valign="TOP"><div>#LookupHardware.AIRPORTID#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.BLUETOOTHID#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.MACHINENAME#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.ROOMNUMBER#</div></td>
			<td align="CENTER" valign="TOP" nowrap><div>#LookupHardware.BARCODENUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.STATEFOUNDNUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.SERIALNUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.DIVISIONNUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.EQUIPMENTTYPE#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.MODELNAME#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.MODELNUMBER#</div></td>
		</tr>
		<tr>
          	<th align="left" valign="TOP">Assigned Customer:</th>
               <td align="left" valign="TOP"><div>#LookupHardware.FULLNAME#</div></td>
			<th align="left" valign="TOP">Unit Name:</th>
               <td align="left" valign="TOP"><div>#LookupUnits.UNITNAME#</div></td>
			<th align="left" valign="TOP">Wall Jack:</th>
               <td align="left" valign="TOP"><div>#LookupJackNumbers.CLOSET#-#LookupJackNumbers.JACKNUMBER#-#LookupJackNumbers.PORTLETTER#</div></td>
			<th align="left" valign="TOP">Modified-By Name:</th>
			<td align="left" valign="TOP"><div>#LookupRecordModifier.FULLNAME#</div></td>
			<th align="left" valign="TOP">Date Checked:</th>
			<td align="left" valign="TOP"><div>#DateFormat(LookupHardware.DATECHECKED, "MM/DD/YYYY")#</div></td>
			<th align="left" valign="TOP">Comments:</th>
			<td align="left" valign="TOP" colspan="2"><div>#LookupHardware.COMMENTS#</div></td>
		</tr>
		<tr>
			<td colspan="13"><hr width="100%" size="5" noshade /></td>
		</tr>
	</CFLOOP>
	<br />
		<tr>
			<th align="CENTER" colspan="146">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
		</tr>
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<td align="left" colspan="13">
               	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td align="left" colspan="13"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</CFOUTPUT>