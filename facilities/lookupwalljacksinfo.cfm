<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lookupwalljacksinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/30/2012 --->
<!--- Date in Production: 07/30/2012 --->
<!--- Module: Lookup Information for Facilities Wall Jack Multiple Record Modify/Delete, Modify Loop & DB Report Programs --->
<!-- Last modified by John R. Pastori on 07/09/2015 using ColdFusion Studio. -->

<!--- 
**************************************************************************
* The following code generates the Wall Jack Information Look Up Screen. *
**************************************************************************
 --->

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPWALLJACK')>

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
	
	<CFQUERY name="LookupWallDirection" datasource="#application.type#FACILITIES" blockfactor="10">
		SELECT	WALLDIRID, WALLDIRNAME
		FROM		WALLDIRECTION
		ORDER BY	WALLDIRNAME
	</CFQUERY>

	<CFQUERY name="ListVLanInfo" datasource="#application.type#FACILITIES" blockfactor="9">
		SELECT	VLANID, VLAN_NUMBER, VLAN_NAME, VLAN_NUMBER || ' - ' || VLAN_NAME AS VLANKEY
		FROM		VLANINFO
		ORDER BY	VLANID
	</CFQUERY>

	<CFQUERY name="LookupCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, GROUPS.GROUPNAME, CUST.CAMPUSPHONE,
				LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS, GROUPS, FACILITIESMGR.LOCATIONS LOC
		WHERE	CUST.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupHardwareBarCode" datasource="#application.type#FACILITIES">
		SELECT	WJ.WALLJACKID, WJ.HARDWAREID, HI.HARDWAREID, HI.BARCODENUMBER, HI.IPADDRESS, CUST.CUSTOMERID, CUST.FULLNAME, 
          		HI.BARCODENUMBER || ' - ' || CUST.FULLNAME AS KEYFINDER
		FROM		WALLJACKS WJ, HARDWMGR.HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(WJ.WALLJACKID = 0 OR
          		WJ.HARDWAREID > 0) AND
          		(WJ.HARDWAREID = HI.HARDWAREID AND
          		HI.CUSTOMERID = CUST.CUSTOMERID)
		ORDER BY	HI.BARCODENUMBER, CUST.CUSTOMERID
	</CFQUERY>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 100 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 20
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>#SCREENTITLE# </H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center"><H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
			Checking an adjacent checkbox will Negate the selection or data entered.</H2></TH>
		</TR>
		<TR>
<CFFORM action="#Cookie.INDEXDIR#" method="POST">
			<TD align="LEFT">
				<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/facilities/#PROCESSPROGRAM#" method="POST">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBUILDING">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BUILDINGNAMEID">Building</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEROOMNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="LOCATIONID">
				(1) Select a Room Number</LABEL> or <LABEL for="ROOMNUMBER"> (2) Enter a Room Number or <BR />
				&nbsp;(3) Enter a series of Room Numbers separated by commas,NO spaces.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBUILDING" id="NEGATEBUILDING" value="" align="LEFT" required="No" tabindex="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="BUILDINGNAMEID" id="BUILDINGNAMEID" size="1" query="LookupBuildings" value="BUILDINGNAMEID" display="BUILDINGNAME" selected="0" required="No" tabindex="3"></CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEROOMNUMBER" id="NEGATEROOMNUMBER" value="" align="LEFT" required="No" tabindex="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="LookupRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="5"></CFSELECT>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBER" value="" required="No" size="20" maxlength="50" tabindex="6">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEWALLDIRECTION">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WALLDIRID">Wall Direction</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECLOSET">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CLOSET">Closet</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEWALLDIRECTION" id="NEGATEWALLDIRECTION" value="" align="LEFT" required="No" tabindex="7">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="WALLDIRID" id="WALLDIRID" size="1" query="LookupWallDirection" value="WALLDIRID" display="WALLDIRNAME" selected="0" required="No" tabindex="8"></CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECLOSET" id="NEGATECLOSET" value="" align="LEFT" required="No" tabindex="9">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CLOSET" id="CLOSET" value="" align="LEFT" required="No" size="16" tabindex="10">
			</TD>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEJACKNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="JACKNUMBER">Jack Number</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPORTLETTER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PORTLETTER">Port Letter</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEJACKNUMBER" id="NEGATEJACKNUMBER" value="" align="LEFT" required="No" tabindex="11">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="JACKNUMBER" id="JACKNUMBER" value="0" align="LEFT" required="No" size="16" tabindex="12">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPORTLETTER" id="NEGATEPORTLETTER" value="" align="LEFT" required="No" tabindex="13">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="PORTLETTER" id="PORTLETTER" size="1" required="No" tabindex="14">
					<OPTION value="0">PORT LETTER</OPTION>
					<OPTION value="A">A</OPTION>
					<OPTION value="B">B</OPTION>
					<OPTION value="C">C</OPTION>
					<OPTION value="D">D</OPTION>
					<OPTION value="E">E</OPTION>
					<OPTION value="F">F</OPTION>
                         <OPTION value="WL">WIRELESS</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEACTIVE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="ACTIVE">Active?</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEINSERTTYPE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="INSERTTYPE">Insert Type</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEACTIVE" id="NEGATEACTIVE" value="" align="LEFT" required="No" tabindex="15">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="16">
					<OPTION selected value="Select">Select</OPTION>
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEINSERTTYPE" id="NEGATEINSERTTYPE" value="" align="LEFT" required="No" tabindex="17">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="left">
				<CFSELECT name="INSERTTYPE" id="INSERTTYPE" size="1" tabindex="18">
					<OPTION value="Select Insert Type">Select Insert Type</OPTION>
					<OPTION value="DATA">DATA</OPTION>
					<OPTION value="ONE CARD">ONE CARD</OPTION>
					<OPTION value="PHONE">PHONE</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEVLANID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="VLANID">VLAN</LABEL>
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
				<CFINPUT type="CheckBox" name="NEGATEVLANID" id="NEGATEVLANID" value="" align="LEFT" required="No" tabindex="19">
			</TD>
			<TD align="left">
				<CFSELECT name="VLANID" id="VLANID" size="1" query="ListVLanInfo" value="VLANID" display="VLANKEY" required="No" tabindex="20"></CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERID" id="NEGATECUSTOMERID" value="" align="LEFT" required="No" tabindex="21">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="LookupCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="22"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERFIRSTNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERFIRSTNAME">Or Customer's First Name</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERLASTNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERLASTNAME">Or Customer's Last Name</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERFIRSTNAME" id="NEGATECUSTOMERFIRSTNAME" value="" align="LEFT" required="No" tabindex="23">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CUSTOMERFIRSTNAME" id="CUSTOMERFIRSTNAME" value="" align="LEFT" required="No" size="17" tabindex="24">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERLASTNAME" id="NEGATECUSTOMERLASTNAME" value="" align="LEFT" required="No" tabindex="25">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CUSTOMERLASTNAME" id="CUSTOMERLASTNAME" value="" align="LEFT" required="No" size="17" tabindex="26">
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECOMMENTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="COMMENTS">Wall Jack Comments</LABEL>
			</TH>
		<CFIF URL.PROCESS EQ "REPORT">
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEHARDWAREID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="HARDWAREID">BARCODE</LABEL>
			</TH>
		<CFELSE>
			<TH align="left" colspan="2">&nbsp;&nbsp;</TH>
		</CFIF>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOMMENTS" id="NEGATECOMMENTS" value="" align="LEFT" required="No" tabindex="27">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="COMMENTS" id="COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="28">
			</TD>
		<CFIF URL.PROCESS EQ "REPORT">
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEHARDWAREID" id="NEGATEHARDWAREID" value="" align="LEFT" required="No" tabindex="29">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="HARDWAREID" id="HARDWAREID" size="1" query="LookupHardwareBarCode" value="HARDWAREID" display="KEYFINDER" selected="0" required="No" tabindex="30"></CFSELECT>
			</TD>
		<CFELSE>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</CFIF>
		</TR>

		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDBYID">Modified-By</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDDATE">
				(1) a single Date Modified or (2) a series of dates separated<BR />
				&nbsp;by commas,NO spaces or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="31">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="32">
					<OPTION value="0">MODIFIED-BY</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="33">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="34">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
	<CFIF IsDefined('URL.PROCESS') AND URL.PROCESS EQ "REPORT">
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
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="35"><LABEL for="REPORTCHOICE1">Walljack Report By Room, Closet, Jack and Port</LABEL>
			</TD>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="36"><LABEL for="REPORTCHOICE2">Walljack Report By Closet, Jack, Port and Room</LABEL>
			</TD>
		</TR>
	<CFELSE>
		<INPUT type="hidden" name="REPORTCHOICE" value="1" />
	</CFIF>
		<TR>
			<TD colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		
		</TR>
		<TR>
			<TH colspan="4"><H2>Clicking the "Match All" Button with no selections equals ALL records for the requested report.</H2></TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<BR /><INPUT type="submit" name="ProcessLookup" value="Match Any Field Entered" tabindex="37" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="submit" name="ProcessLookup" value="Match All Fields Entered" tabindex="38" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="#Cookie.INDEXDIR#" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="submit" value="Cancel" tabindex="39" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
	<CFEXIT>

<CFELSEIF (IsDefined('URL.PROCESS')) AND  ((URL.PROCESS EQ "MULTMODDEL") OR (URL.PROCESS EQ "MODIFYLOOP" AND session.WallJackIDArray[1] EQ 0) OR (URL.PROCESS EQ "REPORT"))>

<!--- 
******************************************************************************************************
* The following code processes the customer selected criteria and passes it to the including program.*
******************************************************************************************************
 --->

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'LOC.ROOMNUMBER~ WJ.CLOSET~ WJ.JACKNUMBER~ WJ.PORTLETTER'>
	<CFSET SORTORDER[2] = 'WJ.CLOSET~ WJ.JACKNUMBER~ WJ.PORTLETTER~ LOC.ROOMNUMBER'>
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>
	<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>

	<CFIF #FORM.ROOMNUMBER# NEQ "">
		<CFSET ROOMLIST = "NO">
		<CFIF FIND(',', #FORM.ROOMNUMBER#, 1) NEQ 0>
			<CFSET ROOMLIST = "YES">
			<CFSET FORM.ROOMNUMBER = UCASE(#FORM.ROOMNUMBER#)>
			<CFSET FORM.ROOMNUMBER = ListQualify(FORM.ROOMNUMBER,"'",",","CHAR")>
			<!--- ROOMNUMBER FIELD = #FORM.ROOMNUMBER#<BR><BR> --->
		</CFIF>
		<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	LOC.LOCATIONID, BN.BUILDINGNAME, LOC.ROOMNUMBER, BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
			FROM		LOCATIONS LOC, BUILDINGNAMES BN
			WHERE	LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
		<CFIF ROOMLIST EQ "YES">
					ROOMNUMBER IN (#PreserveSingleQuotes(FORM.ROOMNUMBER)#)
		<CFELSE>
					ROOMNUMBER LIKE (UPPER('#FORM.ROOMNUMBER#%'))
		</CFIF>
			ORDER BY	ROOMNUMBER
		</CFQUERY>
		<CFIF #LookupRoomNumbers.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Room Number were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/walljacksdbreport.cfm" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	LOC.LOCATIONID, BN.BUILDINGNAME, LOC.ROOMNUMBER, BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
			FROM		LOCATIONS LOC, BUILDINGNAMES BN
			WHERE	LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID
			ORDER BY	LOC.ROOMNUMBER
		</CFQUERY>
	</CFIF>
	
	<CFQUERY name="LookupWallDirection" datasource="#application.type#FACILITIES" blockfactor="10">
		SELECT	WALLDIRID, WALLDIRNAME
		FROM		WALLDIRECTION
		ORDER BY	WALLDIRNAME
	</CFQUERY>

	<CFQUERY name="LookupCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUSTOMERID, LASTNAME, FULLNAME, ACTIVE
		FROM		CUSTOMERS
		WHERE	ACTIVE = 'YES'
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 100 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 20
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
		<CFSET MODIFIEDDATELIST = "NO">
		<CFSET MODIFIEDDATERANGE = "NO">
		<CFIF FIND(',', #FORM.MODIFIEDDATE#, 1) EQ 0 AND FIND(';', #FORM.MODIFIEDDATE#, 1) EQ 0>
			<CFSET FORM.MODIFIEDDATE = DateFormat(FORM.MODIFIEDDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.MODIFIEDDATE#, 1) NEQ 0>
				<CFSET MODIFIEDDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.MODIFIEDDATE#, 1) NEQ 0>
				<CFSET MODIFIEDDATERANGE = "YES">
				<CFSET FORM.MODIFIEDDATE = #REPLACE(FORM.MODIFIEDDATE, ";", ",")#>
			</CFIF>
			<CFSET MODIFIEDDATEARRAY = ListToArray(FORM.MODIFIEDDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)# >
				MODIFIEDDATE FIELD = #MODIFIEDDATEARRAY[COUNTER]#<BR /><BR />
			</CFLOOP>
		</CFIF>
		<CFIF MODIFIEDDATERANGE EQ "YES">
			<CFSET BEGINMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		MODIFIEDDATELIST = #MODIFIEDDATELIST#<BR /><BR />
		MODIFIEDDATERANGE = #MODIFIEDDATERANGE#<BR /><BR />
	</CFIF>

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="GetJackNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	WJ.WALLJACKID, WJ.LOCATIONID, WJ.WALLDIRID, WD.WALLDIRNAME, WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.ACTIVE,
				WJ.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WJ.INSERTTYPE, WJ.VLANID, WJ.HARDWAREID, HI.BARCODENUMBER,
				HI.IPADDRESS, CUST.FIRSTNAME, CUST.LASTNAME, WJ.COMMENTS, WJ.MODIFIEDBYID, WJ.MODIFIEDDATE, 
				LOC.LOCATIONID, LOC.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER
		FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN, WALLDIRECTION WD, HARDWMGR.HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	((WJ.WALLJACKID > 0 AND
				WJ.LOCATIONID = LOC.LOCATIONID  AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
				WJ.WALLDIRID = WD.WALLDIRID AND
				WJ.HARDWAREID = HI.HARDWAREID AND
				WJ.CUSTOMERID = CUST.CUSTOMERID) AND (
		<CFIF #FORM.BUILDINGNAMEID# GT 0>
			<CFIF IsDefined('FORM.NEGATEBUILDING')>
				NOT (LOC.BUILDINGNAMEID = #val(FORM.BUILDINGNAMEID)#) #LOGICANDOR#
			<CFELSE>
				LOC.BUILDINGNAMEID = #val(FORM.BUILDINGNAMEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.LOCATIONID# GT 0>
			<CFIF IsDefined('FORM.NEGATEROOMNUMBER')>
				NOT WJ.LOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
			<CFELSE>
				WJ.LOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ROOMNUMBER# NEQ "">
			<CFIF IsDefined('FORM.NEGATEROOMNUMBER')>
				NOT WJ.LOCATIONID IN (#ValueList(LookupRoomNumbers.LOCATIONID)#) #LOGICANDOR#
			<CFELSE>
				WJ.LOCATIONID IN (#ValueList(LookupRoomNumbers.LOCATIONID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.WALLDIRID# GT 0>
			<CFIF IsDefined('FORM.NEGATEWALLDIRECTION')>
				NOT WJ.WALLDIRID = #val(FORM.WALLDIRID)# #LOGICANDOR#
			<CFELSE>
				WJ.WALLDIRID = #val(FORM.WALLDIRID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CLOSET# NEQ "">
			<CFIF IsDefined('FORM.NEGATECLOSET')>
				NOT WJ.CLOSET LIKE '%#FORM.CLOSET#%' #LOGICANDOR#
			<CFELSE>
				WJ.CLOSET LIKE '%#FORM.CLOSET#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.JACKNUMBER# GT '0'>
			<CFIF IsDefined('FORM.NEGATEJACKNUMBER')>
				NOT WJ.JACKNUMBER = #FORM.JACKNUMBER# #LOGICANDOR#
			<CFELSE>
				WJ.JACKNUMBER = #FORM.JACKNUMBER# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.PORTLETTER# GT '0'>
			<CFIF IsDefined('FORM.NEGATEPORTLETTER')>
				NOT WJ.PORTLETTER = '#FORM.PORTLETTER#' #LOGICANDOR#
			<CFELSE>
				WJ.PORTLETTER = '#FORM.PORTLETTER#' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ACTIVE# NEQ "Select">
			<CFIF IsDefined('FORM.NEGATEACTIVE')>
				NOT WJ.ACTIVE = '#FORM.ACTIVE#' #LOGICANDOR#
			<CFELSE>
				WJ.ACTIVE = '#FORM.ACTIVE#' #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.INSERTTYPE# NEQ "Select Insert Type">
			<CFIF IsDefined('FORM.NEGATEINSERTTYPE')>
				NOT WJ.INSERTTYPE = UPPER('#FORM.INSERTTYPE#') #LOGICANDOR#
			<CFELSE>
				WJ.INSERTTYPE = UPPER('#FORM.INSERTTYPE#') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.VLANID# GT 0>
			<CFIF IsDefined('FORM.NEGATEVLANID')>
				NOT WJ.VLANID = #val(FORM.VLANID)# #LOGICANDOR#
			<CFELSE>
				WJ.VLANID = #val(FORM.VLANID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CUSTOMERID# GT 0>
			<CFIF IsDefined('FORM.NEGATECUSTOMERID')>
				NOT WJ.CUSTOMERID = #val(FORM.CUSTOMERID)# #LOGICANDOR#
			<CFELSE>
				WJ.CUSTOMERID = #val(FORM.CUSTOMERID)# #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.CUSTOMERFIRSTNAME# NEQ "">
			<CFIF IsDefined('FORM.NEGATECUSTOMERFIRSTNAME')>
				NOT CUST.FIRSTNAME LIKE UPPER('#FORM.CUSTOMERFIRSTNAME#%') #LOGICANDOR#
			<CFELSE>
				CUST.FIRSTNAME LIKE UPPER('#FORM.CUSTOMERFIRSTNAME#%') #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.CUSTOMERLASTNAME# NEQ "">
			<CFIF IsDefined('FORM.NEGATECUSTOMERLASTNAME')>
				NOT CUST.LASTNAME LIKE UPPER('#FORM.CUSTOMERLASTNAME#%') #LOGICANDOR#
			<CFELSE>
				CUST.LASTNAME LIKE UPPER('#FORM.CUSTOMERLASTNAME#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.COMMENTS# NEQ "">
			<CFIF IsDefined('FORM.NEGATECOMMENTS')>
				NOT WJ.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
			<CFELSE>
				WJ.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #URL.PROCESS# EQ "REPORT">
			<CFIF #FORM.HARDWAREID# GT 0>
				<CFIF IsDefined('FORM.NEGATEHARDWAREID')>
					NOT WJ.HARDWAREID = #val(FORM.HARDWAREID)# #LOGICANDOR#
				<CFELSE>
					WJ.HARDWAREID = #val(FORM.HARDWAREID)# #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>

		<CFIF #FORM.MODIFIEDBYID# GT 0>
			<CFIF IsDefined('FORM.NEGATEMODIFIEDBYID')>
				NOT WJ.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
			<CFELSE>
				WJ.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
			<CFIF IsDefined('FORM.NEGATEMODIFIEDDATE')>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
						<CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						NOT WJ.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') AND
					</CFLOOP>
					<CFSET FINALTEST = ">">
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
					NOT (WJ.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					NOT WJ.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			<CFELSE>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
					(
					<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
						<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						WJ.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
					</CFLOOP>
					<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
					WJ.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) OR
					<CFSET FINALTEST = "=">
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
						(WJ.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					WJ.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>
				WJ.MODIFIEDBYID #FINALTEST# 0))
		ORDER BY	#REPORTORDER#
	</CFQUERY>

	<CFIF #GetJackNumbers.RecordCount# EQ 0>
		<SCRIPT language="JavaScript1.1">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			//
			--> 
			
		</SCRIPT>
          <CFSET URL.WALLJACKIDS = 0>
          <CFSET URL.LOOKUPWALLJACK = "NO">
          <CFIF IsDefined('URL.PROCESS')>
			<CFIF URL.PROCESS EQ "MULTMODDEL">
                    <CFSET PROCESSPROGRAM = "walljacksmultiplemoddel.cfm?PROCESS=MULTMODDEL">
               <CFELSEIF URL.PROCESS EQ "MODIFYLOOP">
                    <CFSET PROCESSPROGRAM = "walljackmultiplemodloop.cfm?PROCESS=MODIFYLOOP">
               <CFELSE>
                    <CFSET PROCESSPROGRAM = "walljacksdbreport.cfm?PROCESS=REPORT">
               </CFIF>
          </CFIF>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/#PROCESSPROGRAM#" />
		<CFEXIT> 
	<CFELSEIF (IsDefined('URL.PROCESS')) AND  (URL.PROCESS EQ "MULTMODDEL" OR URL.PROCESS EQ "MODIFYLOOP")>
		<CFSET URL.WALLJACKIDS = #ValueList(GetJackNumbers.WALLJACKID)#>
		WALLJACK IDS = #URL.WALLJACKIDS#
		<SCRIPT language="JavaScript">
		<!--
			window.open("/#application.type#apps/facilities/walljacksmultlookupreport.cfm?WALLJACKIDS=#URL.WALLJACKIDS#","Print_WallJack_IDs", "alwaysRaised=yes,width=1000,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
		// -->
		</SCRIPT>
	<CFELSE>
		<CFIF #FORM.REPORTCHOICE# EQ 1>
			<CFSET REPORTTITLE = 'REPORT 1:&nbsp;&nbsp;&nbsp;&nbsp;By Room, Closet, Jack and Port'>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 2>
			<CFSET REPORTTITLE = 'REPORT 2:&nbsp;&nbsp;&nbsp;&nbsp;By Closet, Jack, Port and Room'>
		</CFIF>
	</CFIF>
     <CFIF IsDefined('URL.PROCESS') AND URL.PROCESS EQ 'MODIFYLOOP'>
     	<CFSET temp = ArraySet(session.WallJackIDArray, 1, LISTLEN(URL.WALLJACKIDS), 0)> 
		<CFSET session.WallJackIDArray = ListToArray(URL.WALLJACKIDS)>
     </CFIF>
</CFIF>
</CFOUTPUT>