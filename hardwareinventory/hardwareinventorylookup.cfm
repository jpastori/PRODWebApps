<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hardwareinventorylookup.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Hardware Inventory Record Lookup --->
<!-- Last modified by John R. Pastori on 04/08/2015 using ColdFusion Studio. -->

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

<CFSET TABLENAME = 'HARDWAREINVENTORY'>
<CFIF URL.PROCESS EQ 'REPORT'>
	<CFSET PROGRAMNAME = 'hardwareinventorydbreports.cfm'>
	<CFSET PROCESS = 'REPORT'>
	<CFSET SCREENTITLE = 'Departmental & Unit/Customer Report Selection Lookup'>
<CFELSEIF URL.PROCESS EQ 'ARCHIVE'>
	<CFSET PROGRAMNAME = 'inventoryarchivedbreports.cfm'>
	<CFSET PROCESS = 'ARCHIVE'>
	<CFSET SCREENTITLE = 'Archive Reports Selection Lookup'>
	<CFSET TABLENAME = 'INVENTORYARCHIVE'>
<CFELSE>
	<CFSET PROGRAMNAME = 'inventorymultiplemodloop.cfm'>
	<CFSET PROCESS = 'MODIFYLOOP'>
	<CFSET SCREENTITLE = 'Multiple Record Modify Loop Lookup in IDT Hardware Inventory'>
</CFIF>

<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>

	<CFQUERY name="LookupBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
		SELECT	BUILDINGNAMEID, BUILDINGNAME
		FROM		BUILDINGNAMES
		ORDER BY	BUILDINGNAME
	</CFQUERY>

	<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOCATIONID, ROOMNUMBER
		FROM		LOCATIONS
		ORDER BY	ROOMNUMBER
	</CFQUERY>

	<CFQUERY name="LookupSpeedNames" datasource="#application.type#HARDWARE" blockfactor="86">
		SELECT	SPEEDNAMEID, SPEEDNAME
		FROM		SPEEDNAMELIST
		ORDER BY	SPEEDNAME
	</CFQUERY>

	<CFQUERY name="LookupSizeNames" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	SIZENAMEID, SIZENAME
		FROM		SIZENAMELIST
		ORDER BY	SIZENAME
	</CFQUERY>

	<CFQUERY name="LookupInterfaces" datasource="#application.type#HARDWARE" blockfactor="92">
		SELECT	INTERFACENAMEID, INTERFACENAME
		FROM		INTERFACENAMELIST
		ORDER BY	INTERFACENAME
	</CFQUERY>

	<CFQUERY name="LookupPeripherals" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	PERIPHERALNAMEID, PERIPHERALNAME
		FROM		PERIPHERALNAMELIST
		ORDER BY	PERIPHERALNAME
	</CFQUERY>
     
     <CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          ORDER BY	FISCALYEARID
     </CFQUERY>

     <CFQUERY name="ListOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
		SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
		FROM		ORGCODES
		ORDER BY	ORGCODE
	</CFQUERY>

	<CFQUERY name="LookupCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, U.UNITNAME, U.DEPARTMENTID, G.GROUPNAME, CUST.CAMPUSPHONE,
				LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS U, GROUPS G, FACILITIESMGR.LOCATIONS LOC
		WHERE	(CUST.UNITID = U.UNITID AND
				U.GROUPID = G.GROUPID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES') AND
				(CUST.CUSTOMERID = 0 OR
				U.DEPARTMENTID = 8)
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
		SELECT	UNITID, UNITNAME, UNITNAME || ' - ' || UNITID AS UNITLOOKUP
		FROM		UNITS
		ORDER BY	UNITNAME
	</CFQUERY>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 300 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 30
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>#SCREENTITLE#</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
					Checking an adjacent checkbox will Negate the selection or data entered.
				</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
     <BR /><BR />
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#&LOOKUPBARCODE=FOUND" method="POST">
     <FIELDSET>
	<LEGEND>Equipment</LEGEND>
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBARCODENUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BARCODENUMBER">Bar Code Number </LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESTATEFOUNDNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="STATEFOUNDNUMBER">Enter (1) a State Found Number or (2) a series of State Found Numbers </LABEL><BR />
				&nbsp;separated by commas,NO spaces.
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBARCODENUMBER" id="NEGATEBARCODENUMBER" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="3065000" align="LEFT" required="No" size="18" tabindex="3">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTATEFOUNDNUMBER" id="NEGATESTATEFOUNDNUMBER" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="50" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESERIALNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%"><LABEL for="SERIALNUMBER">Serial Number</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDIVISIONNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%"><LABEL for="DIVISIONNUMBER">Division Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESERIALNUMBER" id="NEGATESERIALNUMBER" value="" align="LEFT" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="" align="LEFT" required="No" size="50" tabindex="7">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDIVISIONNUMBER" id="NEGATEDIVISIONNUMBER" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="" align="LEFT" required="No" size="50" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEEQUIPMENTTYPE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="EQUIPMENTTYPE">
				Enter (1) an Equipment Type or (2) a series of Equipment Types<BR />
				&nbsp;separated by commas,NO spaces.</LABEL>
			</TH>
               <TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDESCRIPTION">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DESCRIPTION">
				Enter (1) a Description or (2) a series of Descriptions <BR />
				&nbsp;separated by commas,NO spaces.</LABEL>
			</TH>
          </TR>
		<TR>	
			<TD align="LEFT">
				<CFINPUT type="CheckBox" name="NEGATEEQUIPMENTTYPE" id="NEGATEEQUIPMENTTYPE" value="" align="LEFT" required="No" tabindex="10">
			</TD>
		<CFIF IsDefined('URL.EQUIPMENTTYPE')>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="EQUIPMENTTYPE" id="EQUIPMENTTYPE" value="#URL.EQUIPMENTTYPE#" align="LEFT" required="No" size="50" tabindex="11">
			</TD>
		<CFELSE>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="EQUIPMENTTYPE" id="EQUIPMENTTYPE" value="" align="LEFT" required="No" size="50" tabindex="11">
			</TD>
		</CFIF>
               <TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDESCRIPTION" id="NEGATEDESCRIPTION" value="" align="LEFT" required="No" tabindex="12">
			</TD>
		<CFIF IsDefined('URL.DESCRIPTION')>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="DESCRIPTION" id="DESCRIPTION" value="#URL.DESCRIPTION#" align="LEFT" required="No" size="50" tabindex="13">
			</TD>
		<CFELSE>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="DESCRIPTION" id="DESCRIPTION" value="" align="LEFT" required="No" size="50" tabindex="13">
			</TD>
		</CFIF>
          </TR>
          <TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODELNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODELNAME"> Enter (1) a Model or (2) a series of Models<BR />
				&nbsp;separated by commas,NO spaces.</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODELNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODELNUMBER">Enter (1) a Model Number or (2) a series of Model Numbers<BR />
				&nbsp;separated by commas,NO spaces.</LABEL>
			</TH>
		</TR>
		<TR>
	
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODELNAME" id="NEGATEMODELNAME" value="" align="LEFT" required="No" tabindex="14">
			</TD>
		<CFIF IsDefined('URL.MODELNAME')>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODELNAME" id="MODELNAME" value="#URL.MODELNAME#" align="LEFT" required="No" size="50" tabindex="15">
			</TD>
		<CFELSE>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODELNAME" id="MODELNAME" value="" align="LEFT" required="No" size="50" tabindex="15">
			</TD>
		</CFIF>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODELNUMBER" id="NEGATEMODELNUMBER" value="" align="LEFT" required="No" tabindex="16">
			</TD>
		<CFIF IsDefined('URL.MODELNUMBER')>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODELNUMBER" id="MODELNUMBER" value="#URL.MODELNUMBER#" align="LEFT" required="No" size="50" tabindex="17">
			</TD>
		<CFELSE>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODELNUMBER" id="MODELNUMBER" value="" align="LEFT" required="No" size="50" tabindex="17">
			</TD>
		</CFIF>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESPEEDNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SPEEDNAMEID">Speed</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" width="45%">
				<LABEL for="SIZENAMEID">Size</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESPEEDNAME" id="NEGATESPEEDNAMEID" value="" align="LEFT" required="No" tabindex="18">
			</TD>
			<TD align="LEFT" width="45%">
				&nbsp;<CFSELECT name="SPEEDNAMEID" id="SPEEDNAMEID" size="1" query="LookupSpeedNames" value="SPEEDNAMEID" display="SPEEDNAME" required="No" tabindex="19"></CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
			<TD align="LEFT" width="45%">
				&nbsp;<CFSELECT name="SIZENAMEID" id="SIZENAMEID" size="1" query="LookupSizeNames" value="SIZENAMEID" display="SIZENAME" required="No" tabindex="20"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" width="45%">
				<LABEL for="INTERFACENAMEID">Interfaces</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" width="45%">
				<LABEL for="PERIPHERALNAMEID">Peripherals</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" width="45%">
				&nbsp;<CFSELECT name="INTERFACENAMEID" id="INTERFACENAMEID" size="1" query="LookupInterfaces" value="INTERFACENAMEID" display="INTERFACENAME" required="No" tabindex="21"></CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" width="45%">
				&nbsp;<CFSELECT name="PERIPHERALNAMEID" id="PERIPHERALNAMEID" size="1" query="LookupPeripherals" value="PERIPHERALNAMEID" display="PERIPHERALNAME" required="No" tabindex="22"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBUILDING">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%"><LABEL for="BUILDINGNAMEID">Building</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEROOMNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="LOCATIONID">(1) Select a Room Number or </LABEL>
				<LABEL for="ROOMNUMBER">(2) enter a Room Number <BR />
				&nbsp;or (3) enter a series of Room Numbers separated by commas,NO spaces.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBUILDING" id="NEGATEBUILDING" value="" align="LEFT" required="No" tabindex="23">
			</TD>
			<TD align="LEFT" width="45%">
				&nbsp;<CFSELECT name="BUILDINGNAMEID" id="BUILDINGNAMEID" size="1" query="LookupBuildings" value="BUILDINGNAMEID" display="BUILDINGNAME" selected="0" required="No" tabindex="24"></CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEROOMNUMBER" id="NEGATEROOMNUMBER" value="" align="LEFT" required="No" tabindex="25">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="LookupRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="26"></CFSELECT>	
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBER" value="" required="No" size="20" maxlength="50" tabindex="27">
			</TD>
		</TR>
	<CFIF NOT URL.PROCESS EQ 'ARCHIVE'>
          <TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECLUSTERNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CLUSTERNAME">Enter (1) a Cluster or (2) a series of Clusters <BR />
				&nbsp;separated by commas,NO spaces.</LABEL>
			</TH>
               <TH align="LEFT" colspan="2">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECLUSTERNAME" id="NEGATECLUSTERNAME" value="" align="LEFT" required="No" tabindex="28">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CLUSTERNAME" id="CLUSTERNAME" value="" align="LEFT" required="No" size="50" tabindex="29">
			</TD>
               <TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	</CFIF>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Network</LEGEND>
	<TABLE width="100%" border="0">
     	<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMACHINENAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MACHINENAME">Machine Name</LABEL>
			</TH>
			<TH align="left" valign="BOTTOM" width="45%" colspan="2">&nbsp;&nbsp;</TH>
		</TR>
          <TR>	
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMACHINENAME" id="NEGATEMACHINENAME" value="" align="LEFT" required="No" tabindex="30">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MACHINENAME" id="MACHINENAME" value="" align="LEFT" required="No" size="18" tabindex="31">
			</TD>
			<TD align="left" valign="BOTTOM" width="45%" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMACADDRESS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MACADDRESS">MAC Address</LABEL>
			</TH>
		<CFIF NOT (URL.PROCESS EQ 'ARCHIVE')>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEIPADDRESS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="IPADDRESS">IP Address</LABEL>
			</TH>
		<CFELSE>
			<TH align="left" valign="BOTTOM" width="45%" colspan="2">&nbsp;&nbsp;</TH>
		</CFIF>
		</TR>
		<TR>	
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMACADDRESS" id="NEGATEMACADDRESS" value="" align="LEFT" required="No" tabindex="30">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MACADDRESS" id="MACADDRESS" value="" align="LEFT" required="No" size="18" tabindex="31">
			</TD>
		<CFIF NOT (URL.PROCESS EQ 'ARCHIVE')>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEIPADDRESS" id="NEGATEIPADDRESS" value="" align="LEFT" required="No" tabindex="32">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="IPADDRESS" id="IPADDRESS" value="" align="LEFT" required="No" size="18" tabindex="33">
			</TD>
		<CFELSE>
			<TD align="left" valign="BOTTOM" width="45%" colspan="2">&nbsp;&nbsp;</TD>
		</CFIF>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEAIRPORTID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="AIRPORTID">Airport/WIFI ID</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBLUETOOTHID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BLUETOOTHID">Bluetooth ID</LABEL>
			</TH>
		</TR>
          <TR>	
          	<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAIRPORTID" id="NEGATEAIRPORTID" value="" align="LEFT" required="No" tabindex="34">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="AIRPORTID" id="AIRPORTID" value="" align="LEFT" required="No" size="18" tabindex="35">
			</TD>
               <TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBLUETOOTHID" id="NEGATEBLUETOOTHID" value="" align="LEFT" required="No" tabindex="36">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="BLUETOOTHID" id="BLUETOOTHID" value="" align="LEFT" required="No" size="18" tabindex="37">
			</TD>
          </TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Purchasing and Warranty</LEGEND>
	<TABLE width="100%" border="0">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUISITIONNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUISITIONNUMBER">Req. Number</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPURCHASEORDERNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PURCHASEORDERNUMBER">P.O. Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUISITIONNUMBER" id="NEGATEREQUISITIONNUMBER" value="" align="LEFT" required="No" tabindex="38">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="REQUISITIONNUMBER" id="REQUISITIONNUMBER" value="" align="LEFT" required="No" size="50" tabindex="39">
				
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPURCHASEORDERNUMBER" id="NEGATEPURCHASEORDERNUMBER" value="" align="LEFT" required="No" tabindex="40">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="PURCHASEORDERNUMBER" id="PURCHASEORDERNUMBER" value="" required="No" size="50" tabindex="41">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
          	<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFISCALYEARID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FISCALYEARID">Fiscal Year</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEOWNINGORGID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="OWNINGORGID">Owning Org. Code</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFISCALYEARID" id="NEGATEFISCALYEARID" value="" align="LEFT" required="No" tabindex="42">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="FISCALYEARID" id="FISCALYEARID" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="0" tabindex="43"></CFSELECT>
			</TD>
 			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEOWNINGORGID" id="NEGATEOWNINGORGID" value="" align="LEFT" required="No" tabindex="44">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="OWNINGORGID" id="OWNINGORGID" size="1" query="ListOrgCodes" value="ORGCODEID" display="ORGCODENAME" required="No" tabindex="45"></CFSELECT>
			</TD>              
          </TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDATERECEIVED">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DATERECEIVED">Enter (1) a single Date Received or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEWARRANTYEXPIRATIONDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYEXPIRATIONDATE">Enter (1) a single Warranty Expiration Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDATERECEIVED" id="NEGATEDATERECEIVED" value="" align="LEFT" required="No" tabindex="46">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="DATERECEIVED" id="DATERECEIVED" value="" required="No" size="50" tabindex="47">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEWARRANTYEXPIRATIONDATE" id="NEGATEWARRANTYEXPIRATIONDATE" value="" align="LEFT" required="No" tabindex="48">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="WARRANTYEXPIRATIONDATE" id="WARRANTYEXPIRATIONDATE" value="" required="No" size="50" tabindex="49">
			</TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEWARRANTYVENDORNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYVENDORNAME">Warr. Vendor</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEWARRANTYRESTRICTIONS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYRESTRICTIONS">Warr. Restrictions</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEWARRANTYVENDORNAME" id="NEGATEWARRANTYVENDORNAME" value="" align="LEFT" required="No" tabindex="50">
			</TD>
		<CFIF IsDefined('URL.WARRANTYVENDORNAME')>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="WARRANTYVENDORNAME" id="WARRANTYVENDORNAME" value="#URL.WARRANTYVENDORNAME#" align="LEFT" required="No" size="50" tabindex="51">
			</TD>
		<CFELSE>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="WARRANTYVENDORNAME" id="WARRANTYVENDORNAME" value="" align="LEFT" required="No" size="50" tabindex="51">
			</TD>
		</CFIF>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEWARRANTYRESTRICTIONS" id="NEGATEWARRANTYRESTRICTIONS" value="" align="LEFT" required="No" tabindex="52">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="WARRANTYRESTRICTIONS" id="WARRANTYRESTRICTIONS" value="" align="LEFT" required="No" size="50" tabindex="53">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEWARRANTYCOMMENTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYCOMMENTS">Warr. Comments</LABEL>
			</TH>
               <TH align="LEFT" colspan="2">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEWARRANTYCOMMENTS" id="NEGATEWARRANTYCOMMENTS" value="" align="LEFT" required="No" tabindex="54">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="WARRANTYCOMMENTS" id="WARRANTYCOMMENTS" value="" align="LEFT" required="No" size="50" tabindex="55">
			</TD>
               <TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Customer and Modifier</LEGEND>
	<TABLE width="100%" border="0">
     	<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERCATEGORY">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERCATEGORY">Enter (1) a single Customer Category or (2) a series of Customer Categories<BR />
				&nbsp;separated by commas,NO spaces.</LABEL>
			</TH>
               <TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERID">Customer</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERCATEGORY" id="NEGATECUSTOMERCATEGORY" value="" align="LEFT" required="No" tabindex="56">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CUSTOMERCATEGORY" id="CUSTOMERCATEGORY" value="" required="No" size="50" tabindex="57">
			</TD>
               <TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERID" id="NEGATECUSTOMERID" value="" align="LEFT" required="No" tabindex="58">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="LookupCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="59"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERFIRSTNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERFIRSTNAME">Or Enter a Customer's First Name</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERLASTNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERLASTNAME">Or Enter a Customer's Last Name</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERFIRSTNAME" id="NEGATECUSTOMERFIRSTNAME" value="" align="LEFT" required="No" tabindex="60">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CUSTOMERFIRSTNAME" id="CUSTOMERFIRSTNAME" value="" align="LEFT" required="No" size="17" tabindex="61">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERLASTNAME" id="NEGATECUSTOMERLASTNAME" value="" align="LEFT" required="No" tabindex="62">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CUSTOMERLASTNAME" id="CUSTOMERLASTNAME" value="" align="LEFT" required="No" size="17" tabindex="63">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEUNITID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="UNITID">(1) Select a Unit Name </LABEL><LABEL for="UNITNUMBER">or (2) enter a series of Unit Numbers <BR />
				&nbsp;separated by commas,NO spaces.</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECOMMENTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="COMMENTS">Comments</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" align="LEFT" required="No" tabindex="64">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="LookupUnits" value="UNITID" display="UNITLOOKUP" selected="0" required="No" tabindex="65"></CFSELECT>
				<CFINPUT type="Text" name="UNITNUMBER" id="UNITNUMBER" value="" required="No" size="20" maxlength="30" tabindex="66">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOMMENTS" id="NEGATECOMMENTS" value="" align="LEFT" required="No" tabindex="67">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="COMMENTS" id="COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="68">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDBYID">Modified By</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDATECHECKED">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DATECHECKED">Enter (1) a single Date Checked or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="69">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="70">
					<OPTION value="0">MODIFIED-BY</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDATECHECKED" id="NEGATEDATECHECKED" value="" align="LEFT" required="No" tabindex="71">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="DATECHECKED" id="DATECHECKED" value="" required="No" size="50" tabindex="72">
			</TD>
		</TR>
     </TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
     <CFIF URL.PROCESS EQ 'REPORT' OR URL.PROCESS EQ "ARCHIVE">
		<LEGEND>Report Selection</LEGEND>
     <CFELSE>
     	<LEGEND>Record Selection</LEGEND>
     </CFIF>
	<TABLE width="100%" border="0">
	<CFIF URL.PROCESS EQ "REPORT" OR URL.PROCESS EQ "ARCHIVE">
		<TR>
			<TD colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH colspan="4"><H2>Click the radio button on the report you want to run. &nbsp;&nbsp;Only one report can be run at a time.</H2></TH>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="top" colspan="2">
				DEPARTMENTAL REPORTS
			</TH>
		<CFIF URL.PROCESS EQ "REPORT">
			<TH align="LEFT" valign="top" colspan="2">
				UNIT/CUSTOMER REPORTS
			</TH>
		</CFIF>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
			<CFIF URL.PROCESS EQ "ARCHIVE">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="73"><LABEL for="REPORTCHOICE1">Archive Bar Code Report</LABEL>
			<CFELSE>
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="73"><LABEL for="REPORTCHOICE1">Full Bar Code Report</LABEL>
			</CFIF>
			</TD>
		<CFIF URL.PROCESS EQ "REPORT">
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE9" value="9" align="LEFT" required="No" tabindex="81"><LABEL for="REPORTCHOICE9">Unit By Current Assign</LABEL>
			</TD>
		</CFIF>
		</TR>
		<CFIF URL.PROCESS EQ "REPORT">
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="74"><LABEL for="REPORTCHOICE2">Operational Count By Type/Desc</LABEL>
			</TD>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE10" value="10" align="LEFT" required="No" tabindex="82"><LABEL for="REPORTCHOICE10">Current Assign By Bar Code</LABEL>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="75"><LABEL for="REPORTCHOICE3">Non-Operational Count By Type/Desc</LABEL>
			</TD>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE11" value="11" align="LEFT" required="No" tabindex="83"><LABEL for="REPORTCHOICE11">Current Assign By Division Number</LABEL>
			</TD>
		</TR>
		</CFIF>
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
			<CFIF URL.PROCESS EQ "ARCHIVE">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="76"><LABEL for="REPORTCHOICE4">Archive Purchase Warranty Report (By Req. & P.O. Numbers)</LABEL>
			<CFELSE>
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="76"><LABEL for="REPORTCHOICE4">Purchase Warranty Report (By Req. & P.O. Numbers)</LABEL>
			</CFIF>
			</TD>
               <CFIF URL.PROCESS EQ "REPORT">
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE12" value="12" align="LEFT" required="No" tabindex="84"><LABEL for="REPORTCHOICE12">State Found ## Current Assign</LABEL>
			</TD>
               </CFIF>
		</TR>
		<CFIF URL.PROCESS EQ "REPORT">
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="77"><LABEL for="REPORTCHOICE5">Network List By IP Address</LABEL><BR />
                    <COM>(A partial IP address or a full MAC Address MUST be entered in either the "IP Address or MAC Address" text box above.)</COM>
			</TD>
			<CFIF URL.PROCESS EQ "REPORT">
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE13" value="13" align="LEFT" required="No" tabindex="85"><LABEL for="REPORTCHOICE13">Customer Hardware by Received Date</LABEL>
			</TD>
               </CFIF>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"></TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE6" value="6" align="LEFT" required="No" tabindex="78"><LABEL for="REPORTCHOICE6">Survey By State_Found/Barcode</LABEL><BR />
                    <COM>(At least one room MUST be entered in the Room Number Text Box for this to run.)</COM>
			</TD>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE14" value="14" align="LEFT" required="No" tabindex="86"><LABEL for="REPORTCHOICE14">Public Use - Printers By Barcode</LABEL><BR />
                    <COM>(Uses encoded criteria, just select report and click the Match All Fields button.)</COM>
			</TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4"></TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE7" value="7" align="LEFT" required="No" tabindex="79"><LABEL for="REPORTCHOICE7">Inventory Speed/Sizes Report</LABEL>
			</TD>
               <TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE15" value="15" align="LEFT" required="No" tabindex="87"><LABEL for="REPORTCHOICE15">Public Use - All By Current Assign/Type/Loc</LABEL><BR />
                    <COM>(Uses encoded criteria, just select report and click the Match All Fields button.)</COM> 
			</TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4"></TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE8" value="8" align="LEFT" required="No" tabindex="80"><LABEL for="REPORTCHOICE8">Inventory Interfaces/Peripherals Report</LABEL>
			</TD>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE16" value="16" align="LEFT" required="No" tabindex="88"><LABEL for="REPORTCHOICE16">Public Use - Selected Current Assign By Type/Loc</LABEL><BR />
				<COM>(Select any Customer from the dropdown with Public as the First Name.)</COM>
			</TD>
		</TR>
		</CFIF>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH colspan="4"><H2>Clicking the "Match All" Button with no selections equals ALL records for the requested report.</H2></TH>
		</TR>
	</CFIF>
     	<TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="89">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" onClick="return setMatchAll();" tabindex="90" />
			</TD>
		</TR>
	</TABLE>
	</FIELDSET>
</CFFORM>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="91" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFEXIT>
<CFELSEIF (URL.PROCESS EQ 'REPORT') OR (URL.PROCESS EQ 'ARCHIVE') OR (URL.PROCESS EQ 'MODIFYLOOP' AND session.HardwareIDArray[1] EQ 0)>

<!--- 
***************************************************************************
* The following code is the Hardware Inventory Report Generation Process. *
***************************************************************************
 --->

	<CFSET session.ENDPGM = "NO">
	<CFIF URL.PROCESS EQ 'REPORT' OR URL.PROCESS EQ 'ARCHIVE'>
		<CFSET SORTORDER = ARRAYNEW(1)>
		<CFSET SORTORDER[1]  = 'HI.BARCODENUMBER'>
		<CFSET SORTORDER[2]  = 'ET.EQUIPMENTTYPE~ ED.EQUIPMENTDESCRIPTION'>
		<CFSET SORTORDER[3]  = 'ET.EQUIPMENTTYPE~ ED.EQUIPMENTDESCRIPTION'>
		<CFSET SORTORDER[4]  = 'HI.REQUISITIONNUMBER~ HI.PURCHASEORDERNUMBER~ HI.FISCALYEARID'>
		<CFSET SORTORDER[5]  = 'HI.IPADDRESS'>
		<CFSET SORTORDER[6]  = 'LOC.ROOMNUMBER~ HI.STATEFOUNDNUMBER~ HI.BARCODENUMBER'>
		<CFSET SORTORDER[7]  = 'HI.BARCODENUMBER'>
		<CFSET SORTORDER[8]  = 'HI.BARCODENUMBER'>
		<CFSET SORTORDER[9]  = 'UNITS.UNITNAME~ CUST.FULLNAME~ HI.DIVISIONNUMBER~ HI.BARCODENUMBER'>
		<CFSET SORTORDER[10] = 'CUST.FULLNAME~ HI.BARCODENUMBER'>
		<CFSET SORTORDER[11] = 'CUST.FULLNAME~ HI.DIVISIONNUMBER~ HI.BARCODENUMBER'>
		<CFSET SORTORDER[12] = 'LOC.ROOMNUMBER~ HI.STATEFOUNDNUMBER'>
		<CFSET SORTORDER[13] = 'CUST.FULLNAME~ HI.DATERECEIVED'>
		<CFSET SORTORDER[14] = 'ET.EQUIPMENTTYPE~ ED.EQUIPMENTDESCRIPTION~ MNL.MODELNAME'>
		<CFSET SORTORDER[15] = 'CUST.FULLNAME~ ET.EQUIPMENTTYPE~ LOC.ROOMNUMBER~ HI.BARCODENUMBER'>
		<CFSET SORTORDER[16] = 'CUST.FULLNAME~ ET.EQUIPMENTTYPE~ LOC.ROOMNUMBER~ HI.BARCODENUMBER'>

		<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>

		<CFIF FIND('~', #REPORTORDER#, 1) NEQ 0>
			<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>
		<!--- REPORT ORDER = #REPORTORDER#<BR><BR>
		<CFELSE>
			REPORT ORDER = #REPORTORDER# --->
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 2>
			<CFSET FORM.NEGATECUSTOMERLASTNAME = "YES">
			<CFSET FORM.CUSTOMERLASTNAME = "INVENTORY">
			<CFSET FORM.ProcessLookup = 'Match All Fields Entered'>
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 3>
			<CFSET FORM.CUSTOMERLASTNAME = "INVENTORY">
			<CFSET FORM.ProcessLookup = 'Match All Fields Entered'>
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 6>
			<CFSET FORM.ProcessLookup = 'Match All Fields Entered'>
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 14>
			<CFSET FORM.EQUIPMENTTYPE = "PRINTER">
			<CFSET FORM.CUSTOMERFIRSTNAME = "PAID">
			<CFSET FORM.ProcessLookup = 'Match All Fields Entered'>
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 15>
			<CFSET FORM.CUSTOMERCATEGORY = "PATRON">
			<CFSET FORM.ProcessLookup = 'Match All Fields Entered'>
               <CFSET FORM.ReportType = 'All'>
		</CFIF>
          
          <CFIF #FORM.REPORTCHOICE# EQ 16>
			<CFSET FORM.CUSTOMERFIRSTNAME = "PUBLIC">
			<CFSET FORM.ProcessLookup = 'Match All Fields Entered'>
               <CFSET FORM.ReportType = 'Specific Customer'>
		</CFIF>
          
	<CFELSE>
		<CFSET REPORTORDER = 'HI.BARCODENUMBER'>
	</CFIF>
     
     <CFIF #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>
   
	<CFIF #FORM.STATEFOUNDNUMBER# NEQ "">
		<CFSET STATEFOUNDNUMLIST = "NO">
		<CFIF FIND(',', #FORM.STATEFOUNDNUMBER#, 1) NEQ 0>
			<CFSET STATEFOUNDNUMLIST = "YES">
			<CFSET FORM.STATEFOUNDNUMBER = UCASE(#FORM.STATEFOUNDNUMBER#)>
			<CFSET FORM.STATEFOUNDNUMBER = ListQualify(FORM.STATEFOUNDNUMBER,"'",",","CHAR")>
			<!--- STATEFOUNDNUMBER FIELD = #FORM.STATEFOUNDNUMBER#<BR><BR> --->
		</CFIF>
	</CFIF>

	<CFIF #FORM.ROOMNUMBER# NEQ "">
		<CFSET ROOMLIST = "NO">
		<CFIF FIND(',', #FORM.ROOMNUMBER#, 1) NEQ 0>
			<CFSET ROOMLIST = "YES">
			<CFSET FORM.ROOMNUMBER = UCASE(#FORM.ROOMNUMBER#)>
			<CFSET FORM.ROOMNUMBER = ListQualify(FORM.ROOMNUMBER,"'",",","CHAR")>
			<!--- ROOMNUMBER FIELD = #FORM.ROOMNUMBER#<BR><BR> --->
		</CFIF>
		<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
		<CFIF ROOMLIST EQ "YES">
			WHERE	ROOMNUMBER IN (#PreserveSingleQuotes(FORM.ROOMNUMBER)#)
		<CFELSE>
			WHERE	ROOMNUMBER LIKE (UPPER('#FORM.ROOMNUMBER#%'))
		</CFIF>
			ORDER BY	ROOMNUMBER
		</CFQUERY>
		<CFIF #ListRoomNumbers.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Room Number were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
			ORDER BY	ROOMNUMBER
		</CFQUERY>
	</CFIF>

	<CFIF #FORM.EQUIPMENTTYPE# NEQ "">
		<CFSET TYPELIST = "NO">
		<CFIF FIND(',', #FORM.EQUIPMENTTYPE#, 1) NEQ 0>
			<CFSET TYPELIST = "YES">
			<CFSET FORM.EQUIPMENTTYPE = UCASE(#FORM.EQUIPMENTTYPE#)>
			<CFSET FORM.EQUIPMENTTYPE = ListQualify(FORM.EQUIPMENTTYPE,"'",",","CHAR")>
			<!--- EQUIPMENTTYPE FIELD = #FORM.EQUIPMENTTYPE#<BR><BR> --->
		</CFIF>
		<CFQUERY name="ListEquipmentTypes" datasource="#application.type#HARDWARE" blockfactor="13">
			SELECT	EQUIPTYPEID, EQUIPMENTTYPE
			FROM		EQUIPMENTTYPE
		<CFIF TYPELIST EQ "YES">
			WHERE	EQUIPMENTTYPE IN (#PreserveSingleQuotes(FORM.EQUIPMENTTYPE)#)
		<CFELSE>
			WHERE	EQUIPMENTTYPE LIKE (UPPER('%#FORM.EQUIPMENTTYPE#%'))
		</CFIF>
			ORDER BY	EQUIPMENTTYPE
		</CFQUERY>
		<CFIF #ListEquipmentTypes.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected EQUIPMENT TYPE were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#&EQUIPMENTTYPE=#FORM.EQUIPMENTTYPE#" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<CFQUERY name="ListEquipmentTypes" datasource="#application.type#HARDWARE" blockfactor="13">
			SELECT	EQUIPTYPEID, EQUIPMENTTYPE
			FROM		EQUIPMENTTYPE
			ORDER BY	EQUIPMENTTYPE
		</CFQUERY>
	</CFIF>

	<CFIF #FORM.DESCRIPTION# NEQ "">
		<CFSET DESCRLIST = "NO">
		<CFIF FIND(',', #FORM.DESCRIPTION#, 1) NEQ 0>
			<CFSET DESCRLIST = "YES">
			<CFSET FORM.DESCRIPTION = UCASE(#FORM.DESCRIPTION#)>
			<CFSET FORM.DESCRIPTION = ListQualify(FORM.DESCRIPTION,"'",",","CHAR")>
			<!--- DESCRIPTION FIELD = #FORM.DESCRIPTION#<BR><BR> --->
		</CFIF>
		<CFQUERY name="ListEquipmentDescriptions" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	EQUIPDESCRID, EQUIPMENTDESCRIPTION
			FROM		EQUIPMENTDESCRIPTION
		<CFIF DESCRLIST EQ "YES">
			WHERE	EQUIPMENTDESCRIPTION IN (#PreserveSingleQuotes(FORM.DESCRIPTION)#)
		<CFELSE>
			WHERE	EQUIPMENTDESCRIPTION LIKE (UPPER('%#FORM.DESCRIPTION#%'))
		</CFIF>
			ORDER BY	EQUIPMENTDESCRIPTION
		</CFQUERY>
		<CFIF #ListEquipmentDescriptions.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Description were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#&DESCRIPTION=#FORM.DESCRIPTION#" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<CFQUERY name="ListEquipmentDescriptions" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	EQUIPDESCRID, EQUIPMENTDESCRIPTION
			FROM		EQUIPMENTDESCRIPTION
			ORDER BY	EQUIPMENTDESCRIPTION
		</CFQUERY>
	</CFIF>

	<CFIF NOT URL.PROCESS EQ 'ARCHIVE' AND #FORM.CLUSTERNAME# NEQ "">
		<CFSET CLUSTERNAMELIST = "NO">
		<CFIF FIND(',', #FORM.CLUSTERNAME#, 1) NEQ 0>
			<CFSET CLUSTERNAMELIST = "YES">
			<CFSET FORM.CLUSTERNAME = UCASE(#FORM.CLUSTERNAME#)>
			<CFSET FORM.CLUSTERNAME = ListQualify(FORM.CLUSTERNAME,"'",",","CHAR")>
			<!--- CLUSTER NAME FIELD = #FORM.CLUSTERNAME#<BR><BR> --->
		</CFIF>
	</CFIF>

	<CFIF #FORM.MODELNAME# NEQ "">
		<CFSET MODELNAMELIST = "NO">
		<CFIF FIND(',', #FORM.MODELNAME#, 1) NEQ 0>
			<CFSET MODELNAMELIST = "YES">
			<CFSET FORM.MODELNAME = UCASE(#FORM.MODELNAME#)>
			<CFSET FORM.MODELNAME = ListQualify(FORM.MODELNAME,"'",",","CHAR")>
			<!--- MODELNAME FIELD = #FORM.MODELNAME#<BR><BR> --->
		</CFIF>
		<CFQUERY name="ListModelNames" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	MODELNAMEID, MODELNAME
			FROM		MODELNAMELIST
		<CFIF MODELNAMELIST EQ "YES">
			WHERE	MODELNAME IN (#PreserveSingleQuotes(FORM.MODELNAME)#)
		<CFELSE>
			WHERE	MODELNAME LIKE UPPER('%#FORM.MODELNAME#%')
		</CFIF>
			ORDER BY	MODELNAME
		</CFQUERY>
		<CFIF #ListModelNames.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Model Name were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#&MODELNAME=#FORM.MODELNAME#" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<CFQUERY name="ListModelNames" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	MODELNAMEID, MODELNAME
			FROM		MODELNAMELIST
			ORDER BY	MODELNAME
		</CFQUERY>
	</CFIF>

	<CFIF #FORM.MODELNUMBER# NEQ "">
		<CFSET MODELNUMBERLIST = "NO">
		<CFIF FIND(',', #FORM.MODELNUMBER#, 1) NEQ 0>
			<CFSET MODELNUMBERLIST = "YES">
			<CFSET FORM.MODELNUMBER = UCASE(#FORM.MODELNUMBER#)>
			<CFSET FORM.MODELNUMBER = ListQualify(FORM.MODELNUMBER,"'",",","CHAR")>
			<!--- MODELNUMBER FIELD = #FORM.MODELNUMBER#<BR><BR> --->
		</CFIF>
		<CFQUERY name="ListModelNumbers" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	MODELNUMBERID, MODELNUMBER
			FROM		MODELNUMBERLIST
		<CFIF MODELNUMBERLIST EQ "YES">
			WHERE	MODELNUMBER IN (#PreserveSingleQuotes(FORM.MODELNUMBER)#)
		<CFELSE>
			WHERE	MODELNUMBER LIKE UPPER('%#FORM.MODELNUMBER#%')
		</CFIF>
			ORDER BY	MODELNUMBER
		</CFQUERY>
		<CFIF #ListModelNumbers.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Model Number were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#&MODELNUMBER=#FORM.MODELNUMBER#" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<CFQUERY name="ListModelNumbers" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	MODELNUMBERID, MODELNUMBER
			FROM		MODELNUMBERLIST
			ORDER BY	MODELNUMBER
		</CFQUERY>
	</CFIF>

	<CFIF FORM.SIZENAMEID GT 0>
     
     	<CFQUERY name="LookupHardwareSizeEquipType" datasource="#application.type#HARDWARE" blockfactor="100">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID
               FROM		#TABLENAME# HI
               WHERE	
			<CFIF #FORM.EQUIPMENTTYPE# NEQ "">
                    <CFIF IsDefined("FORM.NEGATEEQUIPMENTTYPE")>
                         NOT HI.EQUIPMENTTYPEID IN (#ValueList(ListEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
                    <CFELSE>
                         HI.EQUIPMENTTYPEID IN (#ValueList(ListEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
                    </CFIF>
               </CFIF>
               		 HI.HARDWAREID #FINALTEST# 0
               ORDER BY	HI.EQUIPMENTTYPEID, HI.BARCODENUMBER         
          </CFQUERY>
          
          <CFIF LookupHardwareSizeEquipType.RecordCount GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your Hardware Sizes criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
          
          <CFSET  FORM.HardwareBarcode1 = ValueList(LookupHardwareSizeEquipType.BARCODENUMBER)>
          <CFSET  FORM.HardwareBarcode1 = ListQualify(FORM.HardwareBarcode1,"'",",","CHAR")>
          <!--- HARDWARE EQUIPTYPE BARCODE FOR SIZE NUMBERS ARE: #PreserveSingleQuotes(FORM.HardwareBarcode1)# --->
          
		<CFQUERY name="LookupHardwareSizes" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	HARDWARESIZESID, BARCODENUMBER, HARDWARESIZENAMEID
			FROM		HARDWARESIZES
			WHERE	HARDWARESIZESID > 0 AND
               		BARCODENUMBER IN (#PreserveSingleQuotes(FORM.HardwareBarcode1)#) AND
                         HARDWARESIZENAMEID = #FORM.SIZENAMEID# 
			ORDER BY	BARCODENUMBER
		</CFQUERY>

		<CFIF LookupHardwareSizes.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Hardware Sizes were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		<CFELSEIF LookupHardwareSizes.RecordCount GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your Hardware Sizes criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
	</CFIF>

	<CFIF #FORM.INTERFACENAMEID# GT 0>
         	     
     	<CFQUERY name="LookupHardwareInterfEquipType" datasource="#application.type#HARDWARE" blockfactor="100">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID
               FROM		#TABLENAME# HI
               WHERE	
			<CFIF #FORM.EQUIPMENTTYPE# NEQ "">
                    <CFIF IsDefined("FORM.NEGATEEQUIPMENTTYPE")>
                         NOT HI.EQUIPMENTTYPEID IN (#ValueList(ListEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
                    <CFELSE>
                         HI.EQUIPMENTTYPEID IN (#ValueList(ListEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
                    </CFIF>
               </CFIF>
               		 HI.HARDWAREID #FINALTEST# 0
               ORDER BY	HI.EQUIPMENTTYPEID, HI.BARCODENUMBER         
          </CFQUERY>
          
          <CFIF LookupHardwareInterfEquipType.RecordCount GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your Installed Interfaces criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
          
          <CFSET  FORM.HardwareBarcode2 = ValueList(LookupHardwareInterfEquipType.BARCODENUMBER)>
          <CFSET  FORM.HardwareBarcode2 = ListQualify(FORM.HardwareBarcode2,"'",",","CHAR")>
          <!--- HARDWARE EQUIPTYPE BARCODE NUMBERS FOR INTERFACE ARE: #PreserveSingleQuotes(FORM.HardwareBarcode2)# --->
          
		<CFQUERY name="LookupPCInstalledInterfaces" datasource="#application.type#HARDWARE">
			SELECT	INTERFACEID, BARCODENUMBER, INTERFACENAMEID
			FROM		PCINSTALLEDINTERFACES
			WHERE	INTERFACENAMEID > 0 AND
               		BARCODENUMBER IN (#PreserveSingleQuotes(FORM.HardwareBarcode2)#) AND
                         INTERFACENAMEID = #FORM.INTERFACENAMEID#
			ORDER BY	BARCODENUMBER
		</CFQUERY>

		<CFIF #LookupPCInstalledInterfaces.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected PC Installed Interfaces were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		<CFELSEIF LookupPCInstalledInterfaces.RecordCount GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your PC Installed Interfaces criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
	</CFIF>

	<CFIF #FORM.PERIPHERALNAMEID# GT 0>

     	<CFQUERY name="LookupHardwarePeriphEquipType" datasource="#application.type#HARDWARE" blockfactor="100">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID
               FROM		#TABLENAME# HI
               WHERE	
			<CFIF #FORM.EQUIPMENTTYPE# NEQ "">
                    <CFIF IsDefined("FORM.NEGATEEQUIPMENTTYPE")>
                         NOT HI.EQUIPMENTTYPEID IN (#ValueList(ListEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
                    <CFELSE>
                         HI.EQUIPMENTTYPEID IN (#ValueList(ListEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
                    </CFIF>
               </CFIF>
               		 HI.HARDWAREID #FINALTEST# 0
               ORDER BY	HI.EQUIPMENTTYPEID, HI.BARCODENUMBER         
          </CFQUERY>
          
          <CFIF LookupHardwarePeriphEquipType.RecordCount GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your Installed Peripherals criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
          
          <CFSET  FORM.HardwareBarcode3 = ValueList(LookupHardwarePeriphEquipType.BARCODENUMBER)>
          <CFSET  FORM.HardwareBarcode3 = ListQualify(FORM.HardwareBarcode3,"'",",","CHAR")>
          <!--- HARDWARE EQUIPTYPE BARCODE NUMBERS FOR INTERFACE ARE: #PreserveSingleQuotes(FORM.HardwareBarcode3)# --->
          
		<CFQUERY name="LookupPCInstalledPeripherals" datasource="#application.type#HARDWARE">
			SELECT	PERIPHERALID, BARCODENUMBER, PERIPHERALNAMEID
			FROM		PCINSTALLEDPERIPHERALS
			WHERE	PERIPHERALNAMEID > 0 AND
               		BARCODENUMBER IN (#PreserveSingleQuotes(FORM.HardwareBarcode3)#)AND
                         PERIPHERALNAMEID = #FORM.PERIPHERALNAMEID#
			ORDER BY	BARCODENUMBER
		</CFQUERY>

		<CFIF #LookupPCInstalledPeripherals.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected PC Installed Peripherals were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		<CFELSEIF LookupPCInstalledPeripherals.RecordCount GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your PC Installed Peripherals criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
	</CFIF>
     
 	 <CFIF "#FORM.DATERECEIVED#" NEQ ''>
		<CFSET DATERECEIVEDLIST = "NO">
		<CFSET DATERECEIVEDRANGE = "NO">
		<CFIF FIND(',', #FORM.DATERECEIVED#, 1) EQ 0 AND FIND(';', #FORM.DATERECEIVED#, 1) EQ 0>
			<CFSET FORM.DATERECEIVED = DateFormat(FORM.DATERECEIVED, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.DATERECEIVED#, 1) NEQ 0>
				<CFSET DATERECEIVEDLIST = "YES">
			<CFELSEIF FIND(';', #FORM.DATERECEIVED#, 1) NEQ 0>
				<CFSET DATERECEIVEDRANGE = "YES">
				<CFSET FORM.DATERECEIVED = #REPLACE(FORM.DATERECEIVED, ";", ",")#>
			</CFIF>
			<CFSET DATERECEIVEDARRAY = ListToArray(FORM.DATERECEIVED)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(DATERECEIVEDARRAY)# >
				DATERECEIVED FIELD = #DATERECEIVEDARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF DATERECEIVEDRANGE EQ "YES">
			<CFSET BEGINDATERECEIVED = DateFormat(#DATERECEIVEDARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDDATERECEIVED = DateFormat(#DATERECEIVEDARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
<!--- 	DATERECEIVEDLIST = #DATERECEIVEDLIST#<BR><BR>
		DATERECEIVEDRANGE = #DATERECEIVEDRANGE#<BR><BR> --->
	</CFIF>
     
     <CFIF #FORM.CUSTOMERCATEGORY# NEQ "">
		<CFSET CUSTOMERCATEGORYLIST = "NO">
		<CFIF FIND(',', #FORM.CUSTOMERCATEGORY#, 1) NEQ 0>
			<CFSET CUSTOMERCATEGORYLIST = "YES">
			<CFSET FORM.CUSTOMERCATEGORY = UCASE(#FORM.CUSTOMERCATEGORY#)>
			<CFSET FORM.CUSTOMERCATEGORY = ListQualify(FORM.CUSTOMERCATEGORY,"'",",","CHAR")>
		</CFIF>
		<CFQUERY name="ListCustomerCategory" datasource="#application.type#LIBSHAREDDATA" blockfactor="15">
			SELECT	CATEGORYID, CATEGORYNAME
			FROM		CATEGORIES
		<CFIF #CUSTOMERCATEGORYLIST# EQ "YES">
			WHERE	CATEGORYNAME IN (#PreserveSingleQuotes(FORM.CUSTOMERCATEGORY)#)
		<CFELSE>
			WHERE	CATEGORYNAME LIKE (UPPER('#FORM.CUSTOMERCATEGORY#%'))
		</CFIF>
			ORDER BY	CATEGORYNAME
		</CFQUERY>
		<CFIF #ListCustomerCategory.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Entered Customer Categories were NOT found.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
		<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUSTOMERID, CATEGORYID
			FROM		CUSTOMERS
			WHERE	CATEGORYID IN (#ValueList(ListCustomerCategory.CATEGORYID)#)
			ORDER BY	FULLNAME
		</CFQUERY>
		<CFIF #ListCustomers.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Customers were NOT found in the selected Customer Categories.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
	</CFIF>
     
 	<CFIF "#FORM.WARRANTYEXPIRATIONDATE#" NEQ ''>
		<CFSET WARRANTYEXPIRATIONDATELIST = "NO">
		<CFSET WARRANTYEXPIRATIONDATERANGE = "NO">
		<CFIF FIND(',', #FORM.WARRANTYEXPIRATIONDATE#, 1) EQ 0 AND FIND(';', #FORM.WARRANTYEXPIRATIONDATE#, 1) EQ 0>
			<CFSET FORM.WARRANTYEXPIRATIONDATE = DateFormat(FORM.WARRANTYEXPIRATIONDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.WARRANTYEXPIRATIONDATE#, 1) NEQ 0>
				<CFSET WARRANTYEXPIRATIONDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.WARRANTYEXPIRATIONDATE#, 1) NEQ 0>
				<CFSET WARRANTYEXPIRATIONDATERANGE = "YES">
				<CFSET FORM.WARRANTYEXPIRATIONDATE = #REPLACE(FORM.WARRANTYEXPIRATIONDATE, ";", ",")#>
			</CFIF>
			<CFSET WARRANTYEXPIRATIONDATEARRAY = ListToArray(FORM.WARRANTYEXPIRATIONDATE)>
<!---		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(WARRANTYEXPIRATIONDATEARRAY)# >
				WARRANTYEXPIRATIONDATE FIELD = #WARRANTYEXPIRATIONDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF WARRANTYEXPIRATIONDATERANGE EQ "YES">
			<CFSET BEGINWARRANTYEXPIRATIONDATE = DateFormat(#WARRANTYEXPIRATIONDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDWARRANTYEXPIRATIONDATE = DateFormat(#WARRANTYEXPIRATIONDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
<!--- 	WARRANTYEXPIRATIONDATELIST = #WARRANTYEXPIRATIONDATELIST#<BR><BR>
		WARRANTYEXPIRATIONDATERANGE = #WARRANTYEXPIRATIONDATERANGE#<BR><BR> --->

          <CFQUERY name="ListWarrantyExpireDates" datasource="#application.type#HARDWARE" blockfactor="100">
               SELECT	HW.HARDWAREWARRANTYID, HW.BARCODENUMBER AS WARRBARCODE, HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID, HW.WARRANTYRESTRICTIONS,
                         HW.WARRANTYEXPIRATIONDATE, HW.WARRANTYCOMMENTS
               FROM		HARDWAREWARRANTY HW, HARDWAREINVENTORY HI
               WHERE	(HW.BARCODENUMBER = HI.BARCODENUMBER) AND (
               
               <CFIF #FORM.EQUIPMENTTYPE# NEQ "">
				<CFIF IsDefined("FORM.NEGATEEQUIPMENTTYPE")>
					NOT HI.EQUIPMENTTYPEID IN (#ValueList(ListEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
				<CFELSE>
					HI.EQUIPMENTTYPEID IN (#ValueList(ListEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.CUSTOMERCATEGORY# NEQ "">
				<CFIF IsDefined("FORM.NEGATECUSTOMERCATEGORY")>
					NOT HI.CUSTOMERID IN (#ValueList(ListCustomers.CUSTOMERID)#) #LOGICANDOR#
				<CFELSE>
					HI.CUSTOMERID IN (#ValueList(ListCustomers.CUSTOMERID)#) #LOGICANDOR#
				</CFIF>
               </CFIF>

		<CFIF IsDefined("FORM.NEGATEWARRANTYEXPIRATIONDATE")>
			<CFIF WARRANTYEXPIRATIONDATELIST EQ "YES">
				<CFLOOP index="Counter" from=1 to=#ArrayLen(WARRANTYEXPIRATIONDATEARRAY)#>
					<CFSET FORMATWARRANTYEXPIRATIONDATE =  DateFormat(#WARRANTYEXPIRATIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					NOT HW.WARRANTYEXPIRATIONDATE = TO_DATE('#FORMATWARRANTYEXPIRATIONDATE#', 'DD-MON-YYYY') AND
				</CFLOOP>
				<CFSET FINALTEST = ">">
			<CFELSEIF WARRANTYEXPIRATIONDATERANGE EQ "YES">
				NOT (HW.WARRANTYEXPIRATIONDATE BETWEEN TO_DATE('#BEGINWARRANTYEXPIRATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDWARRANTYEXPIRATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				NOT HW.WARRANTYEXPIRATIONDATE LIKE TO_DATE('#FORM.WARRANTYEXPIRATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		<CFELSE>
			<CFIF WARRANTYEXPIRATIONDATELIST EQ "YES">
				<CFSET ARRAYCOUNT = (ArrayLen(WARRANTYEXPIRATIONDATEARRAY) - 1)>
				(
				<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
					<CFSET FORMATWARRANTYEXPIRATIONDATE = DateFormat(#WARRANTYEXPIRATIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					HW.WARRANTYEXPIRATIONDATE = TO_DATE('#FORMATWARRANTYEXPIRATIONDATE#', 'DD-MON-YYYY') OR
				</CFLOOP>
				<CFSET FORMATWARRANTYEXPIRATIONDATE = DateFormat(#WARRANTYEXPIRATIONDATEARRAY[ArrayLen(WARRANTYEXPIRATIONDATEARRAY)]#, 'DD-MMM-YYYY')>
				HW.WARRANTYEXPIRATIONDATE = TO_DATE('#FORMATWARRANTYEXPIRATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSEIF WARRANTYEXPIRATIONDATERANGE EQ "YES">
					(HW.WARRANTYEXPIRATIONDATE BETWEEN TO_DATE('#BEGINWARRANTYEXPIRATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDWARRANTYEXPIRATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				HW.WARRANTYEXPIRATIONDATE LIKE TO_DATE('#FORM.WARRANTYEXPIRATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		</CFIF>
                    HI.HARDWAREID #FINALTEST# 0)
               ORDER BY	HW.BARCODENUMBER
		</CFQUERY>
 
		<CFIF #ListWarrantyExpireDates.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Warranty Expiration Date were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">

			<CFEXIT>
		<CFELSEIF #ListWarrantyExpireDates.RecordCount# GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your Warranty Expiration Date criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
	</CFIF>
     
	<CFQUERY name="ListWarrantyRestrictions" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HW.HARDWAREWARRANTYID, HW.BARCODENUMBER, HI.HARDWAREID, HI.BARCODENUMBER, HW.WARRANTYRESTRICTIONS,
				HW.WARRANTYEXPIRATIONDATE, HW.WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY HW, HARDWAREINVENTORY HI
		WHERE	HW.BARCODENUMBER = HI.BARCODENUMBER
	<CFIF #FORM.WARRANTYRESTRICTIONS# NEQ "">
				AND HW.WARRANTYRESTRICTIONS LIKE UPPER('%#FORM.WARRANTYRESTRICTIONS#%')
	</CFIF>
		ORDER BY	HW.BARCODENUMBER
	</CFQUERY>
	<CFIF #FORM.WARRANTYRESTRICTIONS# NEQ ""> 
		<CFIF #ListWarrantyRestrictions.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Warranty Restrictions were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		<CFELSEIF #ListWarrantyRestrictions.RecordCount# GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your Warranty Restrictions criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
	</CFIF>

	<CFQUERY name="ListWarrantyVendors" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
	<CFIF #FORM.WARRANTYVENDORNAME# NEQ "">
		WHERE	VENDORNAME LIKE  UPPER('#FORM.WARRANTYVENDORNAME#%')
	</CFIF>
		ORDER BY	VENDORNAME
	</CFQUERY>
	<CFIF #FORM.WARRANTYVENDORNAME# NEQ "" AND #ListWarrantyVendors.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records having the selected Warranty Vendor Name were Not Found");
			--> 
		</SCRIPT>
		<CFSET session.ENDPGM = "YES">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#&WARRANTYVENDORNAME=#FORM.WARRANTYVENDORNAME#" />
		<CFEXIT>
	</CFIF>

	<CFQUERY name="ListWarrantyComments" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HW.HARDWAREWARRANTYID, HW.BARCODENUMBER, HI.HARDWAREID, HI.BARCODENUMBER, HW.WARRANTYRESTRICTIONS,
				HW.WARRANTYEXPIRATIONDATE, HW.WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY HW, HARDWAREINVENTORY HI
		WHERE	HW.BARCODENUMBER = HI.BARCODENUMBER
	<CFIF #FORM.WARRANTYCOMMENTS# NEQ "">
				AND HW.WARRANTYCOMMENTS LIKE '%#FORM.WARRANTYCOMMENTS#%'
	</CFIF>	
		ORDER BY	HW.BARCODENUMBER
	</CFQUERY>
	<CFIF #FORM.WARRANTYCOMMENTS# NEQ "">
		<CFIF #ListWarrantyComments.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Warranty Comments were Not Found");
				 --> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		<CFELSEIF #ListWarrantyComments.RecordCount# GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your Warranty Comments criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
	</CFIF>

	<CFIF #FORM.UNITID# GT 0 OR NOT #FORM.UNITNUMBER# EQ ''>

		<CFQUERY name="ListCustUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUST.CUSTOMERID, CUST.UNITID, U.UNITID, U.UNITNAME
			FROM		CUSTOMERS CUST, UNITS U
		<CFIF #FORM.UNITID# GT 0>
			WHERE	CUST.UNITID = <CFQUERYPARAM value="#FORM.UNITID#" cfsqltype="CF_SQL_NUMERIC"> AND
		<CFELSE>
			WHERE	CUST.UNITID IN (#FORM.UNITNUMBER#) AND
		</CFIF>
					CUST.UNITID = U.UNITID
			ORDER BY	U.UNITNAME
		</CFQUERY>

	</CFIF>

	<CFIF "#FORM.DATECHECKED#" NEQ ''>
		<CFSET DATECHECKEDLIST = "NO">
		<CFSET DATECHECKEDRANGE = "NO">
		<CFIF FIND(',', #FORM.DATECHECKED#, 1) EQ 0 AND FIND(';', #FORM.DATECHECKED#, 1) EQ 0>
			<CFSET FORM.DATECHECKED = DateFormat(FORM.DATECHECKED, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.DATECHECKED#, 1) NEQ 0>
				<CFSET DATECHECKEDLIST = "YES">
			<CFELSEIF FIND(';', #FORM.DATECHECKED#, 1) NEQ 0>
				<CFSET DATECHECKEDRANGE = "YES">
				<CFSET FORM.DATECHECKED = #REPLACE(FORM.DATECHECKED, ";", ",")#>
			</CFIF>
			<CFSET DATECHECKEDARRAY = ListToArray(FORM.DATECHECKED)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(DATECHECKEDARRAY)# >
				DATECHECKED FIELD = #DATECHECKEDARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF DATECHECKEDRANGE EQ "YES">
			<CFSET BEGINDATECHECKED = DateFormat(#DATECHECKEDARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDDATECHECKED = DateFormat(#DATECHECKEDARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
<!---		DATECHECKEDLIST = #DATECHECKEDLIST#<BR><BR>
			DATECHECKEDRANGE = #DATECHECKEDRANGE#<BR><BR> --->
	</CFIF>
     
	<CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
				HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, LOC.ROOMNUMBER, LOC.BUILDINGNAMEID, LOC.LOCATIONNAME, HI.MACHINENAME, HI.MACADDRESS,
				HI.AIRPORTID, HI.BLUETOOTHID, HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE, HI.DESCRIPTIONID, ED.EQUIPMENTDESCRIPTION,
				HI.MODELNAMEID, MNL.MODELNAME, HI.MODELNUMBERID, MUL.MODELNUMBER, HI.SPEEDNAMEID, SNL.SPEEDNAME, HI.MANUFACTURERID,
				VEND.VENDORNAME, HI.DELLEXPRESSSERVICE, HI.WARRANTYVENDORID, WARRVEND.VENDORNAME AS WARRVENDNAME, HI.REQUISITIONNUMBER,
				HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, HI.FISCALYEARID, FY.FISCALYEAR_4DIGIT, HI.CUSTOMERID, CUST.CUSTOMERID,
				CUST.LASTNAME, CUST.FIRSTNAME, CUST.FULLNAME, CUST.UNITID, UNITS.UNITNAME, HI.COMMENTS, HI.OWNINGORGID, HI.MODIFIEDBYID, 
                    HI.DATECHECKED
               <CFIF NOT URL.PROCESS EQ 'ARCHIVE'>
               	, HI.CLUSTERNAME
			</CFIF>	
			<CFIF URL.PROCESS EQ 'REPORT'>
				, HI.IPADDRESS
			</CFIF>
		FROM		#TABLENAME# HI, FACILITIESMGR.LOCATIONS LOC, EQUIPMENTTYPE ET, EQUIPMENTDESCRIPTION ED, MODELNAMELIST MNL,
				MODELNUMBERLIST MUL, SPEEDNAMELIST SNL, PURCHASEMGR.VENDORS VEND, PURCHASEMGR.VENDORS WARRVEND,
				LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS UNITS, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	((HI.HARDWAREID > 0 AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
				HI.DESCRIPTIONID = ED.EQUIPDESCRID AND
				HI.MODELNAMEID = MNL.MODELNAMEID AND
				HI.MODELNUMBERID = MUL.MODELNUMBERID AND
				HI.SPEEDNAMEID = SNL.SPEEDNAMEID AND
				HI.MANUFACTURERID = VEND.VENDORID AND
				HI.WARRANTYVENDORID = WARRVEND.VENDORID AND
				HI.FISCALYEARID = FY.FISCALYEARID AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.UNITID = UNITS.UNITID) AND (
			<CFIF #FORM.BARCODENUMBER# NEQ "3065000" AND #FORM.BARCODENUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEBARCODENUMBER")>
					NOT HI.BARCODENUMBER LIKE '#FORM.BARCODENUMBER#%' #LOGICANDOR#
				<CFELSE>
					HI.BARCODENUMBER LIKE '#FORM.BARCODENUMBER#%' #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.STATEFOUNDNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATESTATEFOUNDNUMBER")>
					<CFIF STATEFOUNDNUMLIST EQ "YES">
						NOT HI.STATEFOUNDNUMBER IN (#PreserveSingleQuotes(FORM.STATEFOUNDNUMBER)#) #LOGICANDOR#
					<CFELSE>
						NOT HI.STATEFOUNDNUMBER LIKE UPPER('#FORM.STATEFOUNDNUMBER#%') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF STATEFOUNDNUMLIST EQ "YES">
						HI.STATEFOUNDNUMBER IN (#PreserveSingleQuotes(FORM.STATEFOUNDNUMBER)#) #LOGICANDOR#
					<CFELSE>
						HI.STATEFOUNDNUMBER LIKE UPPER('#FORM.STATEFOUNDNUMBER#%') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.SERIALNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATESERIALNUMBER")>
					NOT HI.SERIALNUMBER LIKE UPPER('#FORM.SERIALNUMBER#%') #LOGICANDOR#
				<CFELSE>
					HI.SERIALNUMBER LIKE UPPER('#FORM.SERIALNUMBER#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.DIVISIONNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEDIVISIONNUMBER")>
					NOT HI.DIVISIONNUMBER LIKE UPPER('%#FORM.DIVISIONNUMBER#%') #LOGICANDOR#
				<CFELSE>
					HI.DIVISIONNUMBER LIKE UPPER('%#FORM.DIVISIONNUMBER#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.BUILDINGNAMEID# GT 0>
				<CFIF IsDefined("FORM.NEGATEBUILDING")>
					NOT (LOC.BUILDINGNAMEID = #val(FORM.BUILDINGNAMEID)#) #LOGICANDOR#
				<CFELSE>
					LOC.BUILDINGNAMEID = #val(FORM.BUILDINGNAMEID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.LOCATIONID# GT 0>
				<CFIF IsDefined("FORM.NEGATEROOMNUMBER")>
					NOT HI.EQUIPMENTLOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
				<CFELSE>
					HI.EQUIPMENTLOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.ROOMNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEROOMNUMBER")>
					NOT HI.EQUIPMENTLOCATIONID IN (#ValueList(ListRoomNumbers.LOCATIONID)#) #LOGICANDOR#
				<CFELSE>
					HI.EQUIPMENTLOCATIONID IN (#ValueList(ListRoomNumbers.LOCATIONID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.MACHINENAME# NEQ "">
				<CFIF IsDefined("FORM.NEGATEMACHINENAME")>
					NOT HI.MACHINENAME LIKE UPPER('%#FORM.MACHINENAME#%') #LOGICANDOR#
				<CFELSE>
					HI.MACHINENAME LIKE UPPER('%#FORM.MACHINENAME#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.MACADDRESS# NEQ "">
				<CFIF IsDefined("FORM.NEGATEMACADDRESS")>
					NOT (HI.MACADDRESS = '#FORM.MACADDRESS#') #LOGICANDOR#
				<CFELSE>
					HI.MACADDRESS = '#FORM.MACADDRESS#' #LOGICANDOR#
				</CFIF>
			</CFIF>

           <CFIF NOT (URL.PROCESS EQ 'ARCHIVE')>    
               <CFIF #FORM.AIRPORTID# NEQ "">
				<CFIF IsDefined("FORM.NEGATEAIRPORTID")>
					NOT (HI.AIRPORTID LIKE '%#FORM.AIRPORTID#%') #LOGICANDOR#
				<CFELSE>
					HI.AIRPORTID LIKE '%#FORM.AIRPORTID#%' #LOGICANDOR#
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.BLUETOOTHID# NEQ "">
				<CFIF IsDefined("FORM.NEGATEBLUETOOTHID")>
					NOT (HI.BLUETOOTHID LIKE '%#FORM.BLUETOOTHID#%') #LOGICANDOR#
				<CFELSE>
					HI.BLUETOOTHID LIKE '%#FORM.BLUETOOTHID#%' #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>

			<CFIF #FORM.EQUIPMENTTYPE# NEQ "">
				<CFIF IsDefined("FORM.NEGATEEQUIPMENTTYPE")>
					NOT HI.EQUIPMENTTYPEID IN (#ValueList(ListEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
				<CFELSE>
					HI.EQUIPMENTTYPEID IN (#ValueList(ListEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.FISCALYEARID# GT 0>
				<CFIF IsDefined("FORM.NEGATEFISCALYEARID")>
					NOT HI.FISCALYEARID = #val(FORM.FISCALYEARID)# #LOGICANDOR#
				<CFELSE>
					HI.FISCALYEARID = #val(FORM.FISCALYEARID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.DESCRIPTION# NEQ "">
				<CFIF IsDefined("FORM.NEGATEDESCRIPTION")>
					NOT HI.DESCRIPTIONID IN (#ValueList(ListEquipmentDescriptions.EQUIPDESCRID)#) #LOGICANDOR#
				<CFELSE>
					HI.DESCRIPTIONID IN (#ValueList(ListEquipmentDescriptions.EQUIPDESCRID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF NOT URL.PROCESS EQ 'ARCHIVE' AND #FORM.CLUSTERNAME# NEQ "">
				<CFIF IsDefined("FORM.NEGATECLUSTERNAME")>
					<CFIF CLUSTERNAMELIST EQ "YES">
						NOT HI.CLUSTERNAME IN (#PreserveSingleQuotes(FORM.CLUSTERNAME)#) #LOGICANDOR#
					<CFELSE>
						NOT HI.CLUSTERNAME LIKE UPPER('%#FORM.CLUSTERNAME#%') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF CLUSTERNAMELIST EQ "YES">
						HI.CLUSTERNAME IN (#PreserveSingleQuotes(FORM.CLUSTERNAME)#) #LOGICANDOR#
					<CFELSE>
						HI.CLUSTERNAME LIKE UPPER('%#FORM.CLUSTERNAME#%') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

    			<CFIF #FORM.MODELNAME# NEQ "">
				<CFIF IsDefined("FORM.NEGATEMODELNAME")>
					NOT HI.MODELNAMEID IN (#ValueList(ListModelNames.MODELNAMEID)#) #LOGICANDOR#
				<CFELSE>
					HI.MODELNAMEID IN (#ValueList(ListModelNames.MODELNAMEID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.MODELNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEMODELNUMBER")>
					NOT HI.MODELNUMBERID IN (#ValueList(ListModelNumbers.MODELNUMBERID)#) #LOGICANDOR#
				<CFELSE>
					HI.MODELNUMBERID IN (#ValueList(ListModelNumbers.MODELNUMBERID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.SPEEDNAMEID# GT 0>
				<CFIF IsDefined("FORM.NEGATESPEEDNAME")>
					NOT (HI.SPEEDNAMEID = #val(FORM.SPEEDNAMEID)#) #LOGICANDOR#
				<CFELSE>
					HI.SPEEDNAMEID = #val(FORM.SPEEDNAMEID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.SIZENAMEID# GT 0>
				HI.BARCODENUMBER IN (#QuotedValueList(LookupHardwareSizes.BARCODENUMBER)#) #LOGICANDOR#
			</CFIF>

			<CFIF #FORM.INTERFACENAMEID# GT 0>
				HI.BARCODENUMBER IN (#QuotedValueList(LookupPCInstalledInterfaces.BARCODENUMBER)#) #LOGICANDOR#
			</CFIF>

			<CFIF #FORM.PERIPHERALNAMEID# GT 0>
				HI.BARCODENUMBER IN (#QuotedValueList(LookupPCInstalledPeripherals.BARCODENUMBER)#) #LOGICANDOR#
			</CFIF>

			<CFIF #FORM.REQUISITIONNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEREQUISITIONNUMBER")>
					NOT HI.REQUISITIONNUMBER LIKE UPPER('#FORM.REQUISITIONNUMBER#%') #LOGICANDOR#
				<CFELSE>
					HI.REQUISITIONNUMBER LIKE UPPER('#FORM.REQUISITIONNUMBER#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.PURCHASEORDERNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEPURCHASEORDERNUMBER")>
					NOT HI.PURCHASEORDERNUMBER LIKE UPPER('#FORM.PURCHASEORDERNUMBER#%') #LOGICANDOR#
				<CFELSE>
					HI.PURCHASEORDERNUMBER LIKE UPPER('#FORM.PURCHASEORDERNUMBER#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.DATERECEIVED#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEDATERECEIVED")>
					<CFIF DATERECEIVEDLIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(DATERECEIVEDARRAY)#>
							<CFSET FORMATDATERECEIVED =  DateFormat(#DATERECEIVEDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT HI.DATERECEIVED = TO_DATE('#FORMATDATERECEIVED#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF DATERECEIVEDRANGE EQ "YES">
						NOT (HI.DATERECEIVED BETWEEN TO_DATE('#BEGINDATERECEIVED#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATERECEIVED#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT HI.DATERECEIVED LIKE TO_DATE('#FORM.DATERECEIVED#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF DATERECEIVEDLIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(DATERECEIVEDARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATDATERECEIVED = DateFormat(#DATERECEIVEDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							HI.DATERECEIVED = TO_DATE('#FORMATDATERECEIVED#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATDATERECEIVED = DateFormat(#DATERECEIVEDARRAY[ArrayLen(DATERECEIVEDARRAY)]#, 'DD-MMM-YYYY')>
						HI.DATERECEIVED = TO_DATE('#FORMATDATERECEIVED#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSEIF DATERECEIVEDRANGE EQ "YES">
							(HI.DATERECEIVED BETWEEN TO_DATE('#BEGINDATERECEIVED#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATERECEIVED#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						HI.DATERECEIVED LIKE TO_DATE('#FORM.DATERECEIVED#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.WARRANTYEXPIRATIONDATE# NEQ "">
					HI.BARCODENUMBER IN (#QuotedValueList(ListWarrantyExpireDates.WARRBARCODE)#) #LOGICANDOR#
			</CFIF>

    			<CFIF #FORM.WARRANTYRESTRICTIONS# NEQ "">
				<CFIF IsDefined("FORM.NEGATEWARRANTYRESTRICTIONS")>
					NOT HI.HARDWAREID IN (#ValueList(ListWarrantyRestrictions.HARDWAREID)#) #LOGICANDOR#
				<CFELSE>
					HI.HARDWAREID IN (#ValueList(ListWarrantyRestrictions.HARDWAREID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.WARRANTYVENDORNAME# NEQ "">
				<CFIF IsDefined("FORM.NEGATEWARRANTYVENDORNAME")>
					NOT HI.WARRANTYVENDORID IN (#ValueList(ListWarrantyVendors.VENDORID)#) #LOGICANDOR#
				<CFELSE>
					HI.WARRANTYVENDORID IN (#ValueList(ListWarrantyVendors.VENDORID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.WARRANTYCOMMENTS# NEQ "">
				<CFIF IsDefined("FORM.NEGATEWARRANTYCOMMENTS")>
					NOT HI.HARDWAREID IN (#ValueList(ListWarrantyComments.HARDWAREID)#) #LOGICANDOR#
				<CFELSE>
					HI.HARDWAREID IN (#ValueList(ListWarrantyComments.HARDWAREID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.COMMENTS# NEQ "">
				<CFIF IsDefined("FORM.NEGATECOMMENTS")>
					NOT HI.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
				<CFELSE>
					HI.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.CUSTOMERCATEGORY# NEQ "">
				<CFIF IsDefined("FORM.NEGATECUSTOMERCATEGORY")>
					NOT HI.CUSTOMERID IN (#ValueList(ListCustomers.CUSTOMERID)#) #LOGICANDOR#
				<CFELSE>
					HI.CUSTOMERID IN (#ValueList(ListCustomers.CUSTOMERID)#) #LOGICANDOR#
				</CFIF>
               </CFIF>
               
			<CFIF #FORM.CUSTOMERID# GT 0>
				<CFIF IsDefined("FORM.NEGATECUSTOMERID")>
					NOT HI.CUSTOMERID = #val(FORM.CUSTOMERID)# #LOGICANDOR#
				<CFELSE>
					HI.CUSTOMERID = #val(FORM.CUSTOMERID)# #LOGICANDOR#
				</CFIF>
			<CFELSEIF #FORM.CUSTOMERFIRSTNAME# NEQ "">
				<CFIF IsDefined("FORM.NEGATECUSTOMERFIRSTNAME")>
					NOT CUST.FIRSTNAME LIKE UPPER('#FORM.CUSTOMERFIRSTNAME#%') #LOGICANDOR#
				<CFELSE>
					CUST.FIRSTNAME LIKE UPPER('#FORM.CUSTOMERFIRSTNAME#%') #LOGICANDOR#
				</CFIF>
			<CFELSEIF #FORM.CUSTOMERLASTNAME# NEQ "">
				<CFIF IsDefined("FORM.NEGATECUSTOMERLASTNAME")>
					NOT CUST.LASTNAME LIKE UPPER('#FORM.CUSTOMERLASTNAME#%') #LOGICANDOR#
				<CFELSE>
					CUST.LASTNAME LIKE UPPER('#FORM.CUSTOMERLASTNAME#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.UNITID# GT 0 OR NOT #FORM.UNITNUMBER# EQ ''>
				<CFIF IsDefined("FORM.NEGATEUNITID")>
					NOT HI.CUSTOMERID IN (#ValueList(ListCustUnits.CUSTOMERID)#) #LOGICANDOR#
				<CFELSE>
					HI.CUSTOMERID IN (#ValueList(ListCustUnits.CUSTOMERID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.OWNINGORGID# GT 0>
				<CFIF IsDefined("FORM.NEGATEOWNINGORGID")>
					NOT HI.OWNINGORGID = #val(FORM.OWNINGORGID)# #LOGICANDOR#
				<CFELSE>
					HI.OWNINGORGID = #val(FORM.OWNINGORGID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.MODIFIEDBYID# GT 0>
				<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
					NOT HI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				<CFELSE>
					HI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.DATECHECKED#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEDATECHECKED")>
					<CFIF DATECHECKEDLIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(DATECHECKEDARRAY)#>
							<CFSET FORMATDATECHECKED =  DateFormat(#DATECHECKEDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT HI.DATECHECKED = TO_DATE('#FORMATDATECHECKED#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF DATECHECKEDRANGE EQ "YES">
						NOT (HI.DATECHECKED BETWEEN TO_DATE('#BEGINDATECHECKED#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATECHECKED#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT HI.DATECHECKED LIKE TO_DATE('#FORM.DATECHECKED#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF DATECHECKEDLIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(DATECHECKEDARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATDATECHECKED = DateFormat(#DATECHECKEDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							HI.DATECHECKED = TO_DATE('#FORMATDATECHECKED#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATDATECHECKED = DateFormat(#DATECHECKEDARRAY[ArrayLen(DATECHECKEDARRAY)]#, 'DD-MMM-YYYY')>
						HI.DATECHECKED = TO_DATE('#FORMATDATECHECKED#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSEIF DATECHECKEDRANGE EQ "YES">
							(HI.DATECHECKED BETWEEN TO_DATE('#BEGINDATECHECKED#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATECHECKED#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						HI.DATECHECKED LIKE TO_DATE('#FORM.DATECHECKED#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>
			
			<CFIF URL.PROCESS EQ 'REPORT' AND #FORM.IPADDRESS# NEQ "">
				<CFIF IsDefined("FORM.NEGATEIPADDRESS")>
					NOT HI.IPADDRESS LIKE UPPER('%#FORM.IPADDRESS#%') #LOGICANDOR#
				<CFELSE>
					HI.IPADDRESS LIKE UPPER('%#FORM.IPADDRESS#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

				HI.MODIFIEDBYID #FINALTEST# 0))
		ORDER BY	#REPORTORDER#
	</CFQUERY>

	<CFIF #LookupHardware.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Hardware Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<CFSET session.ENDPGM = "YES">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#PROCESS#" />
		<CFEXIT>
	<CFELSEIF URL.PROCESS EQ 'MODIFYLOOP'AND #LookupHardware.RecordCount# GT 0>
		<CFSET URL.HARDWAREIDS = #ValueList(LookupHardware.HARDWAREID)#>
		<!--- HARDWARE IDS = #URL.HARDWAREIDS# --->
          <CFIF #LookupHardware.RecordCount# LT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					window.open("/#application.type#apps/hardwareinventory/inventmultiplelookupreport.cfm?PROCESS=MODIFYLOOP&HARDWAREIDS=#URL.HARDWAREIDS#","Print_HardWare_IDs", "alwaysRaised=yes,dependent=no,width=1000,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
				 -->
			</SCRIPT>
          <CFELSE>
          	<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 1000 Records meeting the selected criteria were found.  The created URL is too long for the server to run the report.");
				--> 
			</SCRIPT>
          </CFIF>	
		<CFSET temp = ArraySet(session.HardwareIDArray, 1, LISTLEN(URL.HARDWAREIDS), 0)> 
		<CFSET session.HardwareIDArray = ListToArray(URL.HARDWAREIDS)>
	</CFIF>
</CFIF>
</CFOUTPUT>