<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: unitcurrentassignedreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Hardware Inventory Unit/Current Assignment Report --->
<!-- Last modified by John R. Pastori on 06/16/2015 using ColdFusion Studio. -->

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

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>IDT Hardware Inventory Unit/Current Assignment Report</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="16">#LookupHardware.RecordCount# hardware records were selected.<BR /><BR /></TH>
		</TR>
		<TR>
			<TH align="CENTER" valign="BOTTOM">Bar Code Number</TH>
			<TH align="CENTER" valign="BOTTOM">State Found Number</TH>
			<TH align="CENTER" valign="BOTTOM">Serial Number</TH>
			<TH align="CENTER" valign="BOTTOM">Division Number</TH>
			<TH align="CENTER" valign="BOTTOM">Equipment Type</TH>
			<TH align="CENTER" valign="BOTTOM">Equipment Description</TH>
			<TH align="CENTER" valign="BOTTOM">Model Name</TH>
			<TH align="CENTER" valign="BOTTOM">Model Number</TH>
			<TH align="CENTER" valign="BOTTOM">Warranty Expiration</TH>
			<TH align="CENTER" valign="BOTTOM">Equipment Location</TH>
			<TH align="CENTER" valign="BOTTOM">Wall Jack</TH>
			<TH align="CENTER" valign="BOTTOM">Current Assignment</TH>
			<TH align="CENTER" valign="BOTTOM">Machine Name</TH>
			<TH align="CENTER" valign="BOTTOM">MAC Address</TH>
			<TH align="CENTER" valign="BOTTOM">Modified-By Name</TH>
			<TH align="CENTER" valign="BOTTOM">Date Checked</TH>
		</TR>
	<CFSET UNITHEADER = "">
	<CFLOOP query="LookupHardware">

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

		<CFIF UNITHEADER NEQ #LookupHardware.UNITNAME#>
			<CFSET UNITHEADER = #LookupHardware.UNITNAME#>
		<TR>
			<TH align="left" nowrap colspan="4"><H2>#LookupHardware.UNITNAME#</H2></TH>
		</TR>
		</CFIF>
		<TR>
			<TD align="left" nowrap><DIV>#LookupHardware.BARCODENUMBER#</DIV></TD>
			<TD align="left"><DIV>#LookupHardware.STATEFOUNDNUMBER#</DIV></TD>
			<TD align="left"><DIV>#LookupHardware.SERIALNUMBER#</DIV></TD>
			<TD align="left"><DIV>#LookupHardware.DIVISIONNUMBER#</DIV></TD>
			<TD align="left"><DIV>#LookupHardware.EQUIPMENTTYPE#</DIV></TD>
			<TD align="left" nowrap><DIV>#LookupHardware.EQUIPMENTDESCRIPTION#</DIV></TD>
			<TD align="left" nowrap><DIV>#LookupHardware.MODELNAME#</DIV></TD>
			<TD align="left" nowrap><DIV>#LookupHardware.MODELNUMBER#</DIV></TD>
			<TD align="left"><DIV>#DateFormat(LookupHardwareWarranty.WARRANTYEXPIRATIONDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="left" nowrap><DIV>#LookupHardware.ROOMNUMBER#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupJackNumbers.CLOSET#-#LookupJackNumbers.JACKNUMBER#-#LookupJackNumbers.PORTLETTER#</DIV></TD>
			<TD align="left" nowrap><DIV>#LookupHardware.FULLNAME#</DIV></TD>
			<TD align="left"><DIV>#LookupHardware.MACHINENAME#</DIV></TD>
			<TD align="left"><DIV>#LookupHardware.MACADDRESS#</DIV></TD>
			<TD align="left" nowrap><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
			<TD align="left"><DIV>#DateFormat(LookupHardware.DATECHECKED, "MM/DD/YYYY")#</DIV></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="16">#LookupHardware.RecordCount# hardware records were selected.<BR /><BR /></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="16"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFOUTPUT>