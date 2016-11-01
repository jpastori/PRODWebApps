<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lookupworkorderinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/24/2009 --->
<!--- Date in Production: 03/24/2009 --->
<!--- Module: Look Up Process for Facilities - Work Order Request Report --->
<!-- Last modified by John R. Pastori on 03/24/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<CFIF NOT IsDefined("URL.LOOKUPWORKORDER")>
	<CFIF URL.PROCESS EQ 'REPORT'>
		<CFSET PROGRAMNAME = 'workorderreports.cfm?LOOKUPWORKORDER=FOUND'>
		<CFSET session.PROCESS = 'REPORT'>
		<CFSET SCREENTITLE = 'Facilities - Work Order Request Reports Lookup '>
	<CFELSE>
		<CFSET PROGRAMNAME = 'workorderapproval.cfm?LOOKUPWORKORDER=FOUND&INITREQ=WO&APPROVAL=MGMT'>
		<CFSET session.PROCESS = 'APPROVAL'>
		<CFSET SCREENTITLE = 'Facilities - Approved Work Order Request Lookup (An Approver MUST be selected)'>	
	</CFIF>

	<CFSET temp = ArraySet(session.WORKORDERIDArray, 1, 1, 0)>
	<CFSET session.ArrayCounter = 0>
	<CFSET session.WORKORDERSSELECTED = 0>

	<CFQUERY name="ListBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
		SELECT	BUILDINGNAMEID, BUILDINGNAME
		FROM		BUILDINGNAMES
		ORDER BY	BUILDINGNAME
	</CFQUERY>

	<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOCATIONID, ROOMNUMBER
		FROM		LOCATIONS
		ORDER BY	ROOMNUMBER
	</CFQUERY>

	<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, GROUPS.GROUPNAME, CUST.CAMPUSPHONE,
				LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS, GROUPS, FACILITIESMGR.LOCATIONS LOC
		WHERE	(CUST.CUSTOMERID = 0 AND 
				CUST.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				CUST.LOCATIONID = LOC.LOCATIONID) OR
				(CUST.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				UNITS.GROUPID IN (2,3,4) AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES')
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
		SELECT	UNITID, UNITNAME, CAMPUSMAILCODEID, GROUPID, DEPARTMENTID
		FROM		UNITS
		WHERE	UNITID = 0 OR
				GROUPID IN (2,3,4)	
		ORDER BY	UNITNAME
	</CFQUERY>

	<CFQUERY name="ListAlternateContacts" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, GROUPS.GROUPNAME, CUST.CAMPUSPHONE,
				LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS, GROUPS, FACILITIESMGR.LOCATIONS LOC
		WHERE(CUST.CUSTOMERID = 0 AND 
				CUST.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				CUST.LOCATIONID = LOC.LOCATIONID) OR
				(CUST.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				UNITS.GROUPID IN (2,3,4) AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES')
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListSupApprover" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.FULLNAME || '-' || CUST.EMAIL AS SUPEMAIL, CUST.UNITID, U.GROUPID,
				CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.ALLOWEDTOAPPROVE
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.CUSTOMERID = 0 AND 
				CUST.UNITID = U.UNITID) OR
				(CUST.UNITID = U.UNITID AND
				U.GROUPID IN (2,3,4) AND 
				CUST.UNITHEAD = 'YES' AND
				CUST.ALLOWEDTOAPPROVE = 'YES')
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListMgmtApprover" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL,  CUST.FULLNAME || '-' || CUST.EMAIL AS MGMTEMAIL, CUST.UNITID, U.GROUPID,
				CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.CUSTOMERID = 0 AND 
				CUST.UNITID = U.UNITID) OR
				(CUST.UNITID = U.UNITID AND
				U.GROUPID IN (2,3,4) AND 
				CUST.DEPTCHAIR = 'YES' AND
				CUST.ALLOWEDTOAPPROVE = 'YES')
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListRequestTypes" datasource="#application.type#FACILITIES" blockfactor="13">
		SELECT	REQUESTTYPEID, REQUESTTYPENAME
		FROM		REQUESTTYPES
		ORDER BY	REQUESTTYPENAME
	</CFQUERY>

	<CFQUERY name="ListRequestStatus" datasource="#application.type#FACILITIES" blockfactor="8">
		SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
		FROM		REQUESTSTATUS
		ORDER BY	REQUESTSTATUSNAME
	</CFQUERY>

	<CFQUERY name="ListKeyTypes" datasource="#application.type#FACILITIES" blockfactor="6">
		SELECT	KEYTYPEID, KEYTYPENAME
		FROM		KEYTYPES
		ORDER BY	KEYTYPENAME
	</CFQUERY>

	<CFQUERY name="ListMoveTypes" datasource="#application.type#FACILITIES" blockfactor="8">
		SELECT	MOVETYPEID, MOVETYPENAME
		FROM		MOVETYPES
		ORDER BY	MOVETYPENAME
	</CFQUERY>


	<table width="100%" align="center" border="3">
		<tr align="center">
			<th align="center"><h1>#SCREENTITLE#</h1></th>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr align="center">
			<th align="center">
				<h2>Select from the drop down boxes or type in partial values to choose report criteria for Facilities WO Requests. <br /> 
				Checking an adjacent checkbox will Negate the selection or data entered.</h2>
			</th>
		</tr>
	</table>
	<br />
	<table width="100%" align="LEFT">
		<tr>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
			<td align="LEFT" valign="TOP" colspan="2">
				<input type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</CFFORM>
		</tr>
<CFFORM name="LOOKUP" action="/#application.type#apps/facilities/#PROGRAMNAME#" method="POST">
		<tr>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEWORKORDERNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WORKORDERNUMBER">Select a WO Request Number.</LABEL>
			</th>
			<th align="LEFT" COLSPAN="2">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEWORKORDERNUMBER" id="NEGATEWORKORDERNUMBER" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="TEXT" name="WORKORDERNUMBER" id="WORKORDERNUMBER" size="15" value="#ListCurrentFiscalYear.FISCALYEAR_2DIGIT#" required="No" tabindex="3">
			</td>
			<td align="left" COLSPAN="2">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTTYPEID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTTYPEID">Select a Request Type.</LABEL>
			</th>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTSTATUSID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTSTATUSID">Select a Request Status.</LABEL>
			</th>
		</tr>
		<tr>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTTYPEID" id="NEGATEREQUESTTYPEID" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="REQUESTTYPEID" id="REQUESTTYPEID" size="1" query="ListRequestTypes" value="REQUESTTYPEID" display="REQUESTTYPENAME" required="No" selected="" tabindex="5"></CFSELECT>
			</td>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTSTATUSID" id="NEGATEREQUESTSTATUSID" value="" align="LEFT" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="REQUESTSTATUSID" id="REQUESTSTATUSID" size="1" query="ListRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" selected="" tabindex="7"></CFSELECT>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTERID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTERID">Select a Requester.</LABEL>
			</th>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEUNITID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="UNITID">Select a Unit.</LABEL>
			</th>
		</tr>
		<tr>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTERID" id="NEGATEREQUESTERID" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="9"></CFSELECT>
			</td>			
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" align="LEFT" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="0" required="No" tabindex="11"></CFSELECT>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBUILDINGNAMEID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BUILDINGNAMEID">Select a Building.</LABEL>
			</th>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEROOMNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="LOCATIONID">
				Select (1) a Room Number or </LABEL><br />
				&nbsp;<LABEL for="ROOMNUMBER">Enter &nbsp;(2) a partial Room Number or <br />
				&nbsp;(3) a series of Room Numbers separated by commas,NO spaces.</LABEL>
			</th>
		</tr>
		<tr>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBUILDINGID" id="NEGATEBUILDINGNAMEID" value="" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="BUILDINGNAMEID" id="BUILDINGNAMEID" size="1" query="ListBuildings" value="BUILDINGNAMEID" display="BUILDINGNAME" selected="0" required="No" tabindex="13"></CFSELECT>
			</td>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEROOMNUMBER" id="NEGATEROOMNUMBER" value="" align="LEFT" required="No" tabindex="14">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="15"></CFSELECT>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBER" value="" required="No" size="20" maxlength="50" tabindex="16">
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEALTERNATECONTACTID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="ALTERNATECONTACTID">Select an Alternate Contact.</LABEL>
			</th>
			<th align="LEFT" colspan="2">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEALTERNATECONTACTID" id="NEGATEALTERNATECONTACTID" value="" align="LEFT" required="No" tabindex="19">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="ALTERNATECONTACTID" id="ALTERNATECONTACTID" size="1" query="ListAlternateContacts" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="20"></CFSELECT>
			</td>
			<td align="LEFT" colspan="2">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEAPPROVEDBYSUPID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="APPROVEDBYSUPID">Select a Unit Head Approver.</LABEL>
			</th>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEAPPROVEDBYMGMTID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="APPROVEDBYMGMTID">Select a Management Approver.</LABEL>
			</th>
		</tr>
		<tr>
		
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAPPROVEDBYSUPID" id="NEGATEAPPROVEDBYSUPID" value="" align="LEFT" required="No" tabindex="23">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="APPROVEDBYSUPID" id="APPROVEDBYSUPID" size="1" query="ListSupApprover" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="24"></CFSELECT>
			</td>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAPPROVEDBYMGMTID" id="NEGATEAPPROVEDBYMGMTID" value="" align="LEFT" required="No" tabindex="23">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="APPROVEDBYMGMTID" id="APPROVEDBYMGMTID" size="1" query="ListMgmtApprover" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="24"></CFSELECT>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTDATE">
				Enter (1) a single Date Requested or <br />
				&nbsp;(2) a series of dates separated by commas,NO spaces or<br />
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</th>
			<th align="LEFT" colspan="2">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTDATE" id="NEGATEREQUESTDATE" value="" align="LEFT" required="No" tabindex="25">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="REQUESTDATE" id="REQUESTDATE" value="" required="No" size="50" tabindex="26">
			</td>
			<td align="LEFT" colspan="2">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESUPAPPROVALDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SUPAPPROVALDATE">
				Enter (1) a single Unit Head Date Approved or <br />
				&nbsp;(2) a series of dates separated by commas,NO spaces or<br />
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</th>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMGMTAPPROVALDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MGMTAPPROVALDATE">
				Enter (1) a single Management Date Approved or <br />
				&nbsp;(2) a series of dates separated by commas,NO spaces or<br />
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</th>
		</tr>
		<tr>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESUPAPPROVALDATE" id="NEGATESUPAPPROVALDATE" value="" align="LEFT" required="No" tabindex="27">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="SUPAPPROVALDATE" id="SUPAPPROVALDATE" value="" required="No" size="50" tabindex="28">
			</td>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMGMTAPPROVALDATE" id="NEGATEMGMTAPPROVALDATE" value="" align="LEFT" required="No" tabindex="27">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MGMTAPPROVALDATE" id="MGMTAPPROVALDATE" value="" required="No" size="50" tabindex="28">
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPROJECTDESCRIPTION">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PROJECTDESCRIPTION">Enter a partial phrase used in the Project Description.</LABEL>
			</th>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEJUSTIFICATIONDESCRIPTION">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="JUSTIFICATIONDESCRIPTION">Enter a partial phrase used in the Justification Description.</LABEL>
			</th>
		</tr>
		<tr>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPROJECTDESCRIPTION" id="NEGATEPROJECTDESCRIPTION" value="" align="LEFT" required="No" tabindex="29">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="PROJECTDESCRIPTION" id="PROJECTDESCRIPTION" value="" align="LEFT" required="No" size="50" tabindex="30">
			</td>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEJUSTIFICATIONDESCRIPTION" id="NEGATEJUSTIFICATIONDESCRIPTION" value="" align="LEFT" required="No" tabindex="31">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="JUSTIFICATIONDESCRIPTION" id="JUSTIFICATIONDESCRIPTION" value="" align="LEFT" required="No" size="50" tabindex="32">
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
	<CFIF session.PROCESS EQ 'REPORT'>
		<tr>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEKEYTYPEID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="KEYTYPEID">Select a Key Type.</LABEL>
			</th>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMOVETYPEID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MOVETYPEID">Select a Move Type.</LABEL>
			</th>
		</tr>
		<tr>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEKEYTYPEID" id="NEGATEKEYTYPEID" value="" align="LEFT" required="No" tabindex="33">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="KEYTYPEID" id="KEYTYPEID" size="1" query="ListKeyTypes" value="KEYTYPEID" display="KEYTYPENAME" required="No" selected="" tabindex="34"></CFSELECT><br />
				<COM>For use with Key Requests Report ONLY! &nbsp;&nbsp;Click "Match All" Button.</COM>
			</td>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMOVETYPEID" id="NEGATEMOVETYPEID" value="" align="LEFT" required="No" tabindex="35">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="MOVETYPEID" id="MOVETYPEID" size="1" query="ListMoveTypes" value="MOVETYPEID" display="MOVETYPENAME" required="No" selected="" tabindex="36"></CFSELECT><br />
				<COM>For use with Move Items Requests Report ONLY! &nbsp;&nbsp;Click "Match All" Button.</COM>
			</td>
		</tr>
		<tr>
			<td colspan="4"><hr align="left" width="100%" size="5" noshade /></td>
		</tr>
		<tr>
			<th colspan="4"><h2>Click the radio button on the report you want to run. &nbsp;&nbsp;Only one report can be run at a time.</h2></th>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th align="LEFT" valign="top" colspan="4">
				CUSTOMER REPORTS
			</th>
		</tr>
		<tr>
			<td align="LEFT" valign="top" colspan="4">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="37"><LABEL for="REPORTCHOICE1">Work Orders Report</LABEL><br />
				<COM>(Click "Match All" Button with no selection for an ALL WORK ORDERS Report.)</COM><br /><br />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="38"><LABEL for="REPORTCHOICE2">Key Requests Report</LABEL><br />
				<COM>(Click "Match All" Button with no selection for an ALL KEY REQUESTS Report.)</COM><br /><br />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="39"><LABEL for="REPORTCHOICE3">Move Requests Report (includes TNS Phone Moves)</LABEL><br />
				<COM>(Click "Match All" Button with no selection for an ALL MOVE REQUESTS Report.)</COM><br /><br />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="39"><LABEL for="REPORTCHOICE4">TNS New/Disconnect Phone Requests Report</LABEL><br />
				<COM>(Click "Match All" Button with no selection for an ALL TNS NEW/DISCONNECT PHONE REQUESTS Report.)</COM><br /><br />
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4"><hr align="left" width="100%" size="5" noshade /></td>
		</tr>
	</CFIF>
		<tr>
			<td align="LEFT" colspan="4"><COM>(Click "Match All" Button with no selection to access ALL Work Order records.)</COM></td>
		</tr>
		<tr>
			<td align="LEFT" colspan="4">
				<br /><input type="submit" name="ProcessLookup" value="Match Any Field Entered" tabindex="41" />
			</td>
		</tr>
		<tr>
			<td align="LEFT" colspan="4">
				<input type="submit" name="ProcessLookup" value="Match All Fields Entered" tabindex="42" />
			</td>
		</tr>
</CFFORM>
		<tr>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
			<td align="LEFT" valign="TOP" colspan="4">
				<input type="SUBMIT" value="Cancel" tabindex="43" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</CFFORM>
		</tr>
		<tr>
			<td align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>

<CFEXIT>
<CFELSEIF (session.PROCESS EQ 'REPORT') OR (session.PROCESS EQ 'APPROVAL' AND session.WORKORDERIDArray[1] EQ 0)>
<!--- 
*******************************************************************
* The following code is the Work Order Report Generation Process. *
*******************************************************************
 --->

	<CFIF #FORM.ROOMNUMBER# NEQ "">
		<CFSET ROOMLIST = "NO">
		<CFIF FIND(',', #FORM.ROOMNUMBER#, 1) NEQ 0>
			<CFSET ROOMLIST = "YES">
			<CFSET FORM.ROOMNUMBER = UCASE(#FORM.ROOMNUMBER#)>
			<CFSET FORM.ROOMNUMBER = ListQualify(FORM.ROOMNUMBER,"'",",","CHAR")>
			ROOMNUMBER FIELD = #FORM.ROOMNUMBER#<br /><br />
		</CFIF>
		<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
		<CFIF ROOMLIST EQ "YES">
			WHERE	ROOMNUMBER IN (#PreserveSingleQuotes(FORM.ROOMNUMBER)#)
		<CFELSE>
			WHERE	ROOMNUMBER LIKE (UPPER('#FORM.ROOMNUMBER#%'))
		</CFIF>
			ORDER BY	ROOMNUMBER
		</CFQUERY>
		<CFIF #LookupRoomNumbers.RecordCount# EQ 0>
			<script language="JavaScript">
				<!-- 
					alert("Records having the selected Room Number were Not Found");
				--> 
			</script>
			<CFIF session.PROCESS EQ 'REPORT'>
				<CFSET PROGRAMNAME = 'workorderreports.cfm?PROCESS=REPORT'>
			<CFELSE>
				<CFSET PROGRAMNAME = 'workorderapproval.cfm?PROCESS=APPROVAL'>
			</CFIF>
			<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/#PROGRAMNAME#" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
			ORDER BY	ROOMNUMBER
		</CFQUERY>
	</CFIF>

	<CFQUERY name="LookupRequestTypes" datasource="#application.type#FACILITIES">
		SELECT	REQUESTTYPEID, REQUESTTYPENAME
		FROM		REQUESTTYPES
		WHERE	REQUESTTYPEID = <CFQUERYPARAM value="#FORM.REQUESTTYPEID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	REQUESTTYPENAME
	</CFQUERY>

	<CFQUERY name="LookupRequestStatus" datasource="#application.type#FACILITIES">
		SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
		FROM		REQUESTSTATUS
		WHERE	REQUESTSTATUSID = <CFQUERYPARAM value="#FORM.REQUESTSTATUSID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	REQUESTSTATUSNAME
	</CFQUERY>

	<CFQUERY name="LookupRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, EMAIL, FULLNAME, UNITHEAD, DEPTCHAIR, FULLNAME || '-' || EMAIL AS SUPEMAIL
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	SUPEMAIL
	</CFQUERY>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA">
		SELECT	UNITS.UNITID, UNITS.UNITNAME, UNITS.CAMPUSMAILCODEID, CUST.CUSTOMERID, CUST.UNITID
		FROM		UNITS, CUSTOMERS CUST
		WHERE	UNITS.UNITID = <CFQUERYPARAM value="#FORM.UNITID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	UNITS.UNITNAME
	</CFQUERY>

	<CFQUERY name="LookupAlternateContacts" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, EMAIL, FULLNAME, UNITHEAD, DEPTCHAIR, FULLNAME || '-' || EMAIL AS SUPEMAIL
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.ALTERNATECONTACTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	SUPEMAIL
	</CFQUERY>

	<CFQUERY name="LookupSupApprovers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, CAMPUSPHONE, FAX, FULLNAME, CATEGORYID, UNITID,
				LOCATIONID, DEPTCHAIR, ALLOWEDTOAPPROVE
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.APPROVEDBYSUPID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupMgmtApprovers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, CAMPUSPHONE, FAX, FULLNAME, CATEGORYID, UNITID,
				LOCATIONID, DEPTCHAIR, ALLOWEDTOAPPROVE
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.APPROVEDBYMGMTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>

<CFIF session.PROCESS EQ 'REPORT'>
	<CFQUERY name="LookupKeyTypes" datasource="#application.type#FACILITIES">
		SELECT	KEYTYPEID, KEYTYPENAME
		FROM		KEYTYPES
		WHERE	KEYTYPEID = <CFQUERYPARAM value="#FORM.KEYTYPEID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	KEYTYPENAME
	</CFQUERY>

	<CFQUERY name="LookupMoveTypes" datasource="#application.type#FACILITIES">
		SELECT	MOVETYPEID, MOVETYPENAME
		FROM		MOVETYPES
		WHERE	MOVETYPEID = <CFQUERYPARAM value="#FORM.MOVETYPEID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	MOVETYPENAME
	</CFQUERY>
</CFIF>
	<CFIF "#FORM.REQUESTDATE#" NEQ ''>
		<CFSET REQUESTDATELIST = "NO">
		<CFSET REQUESTDATERANGE = "NO">
		<CFIF FIND(',', #FORM.REQUESTDATE#, 1) EQ 0 AND FIND(';', #FORM.REQUESTDATE#, 1) EQ 0>
			<CFSET FORM.REQUESTDATE = DateFormat(FORM.REQUESTDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.REQUESTDATE#, 1) NEQ 0>
				<CFSET REQUESTDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.REQUESTDATE#, 1) NEQ 0>
				<CFSET REQUESTDATERANGE = "YES">
				<CFSET FORM.REQUESTDATE = #REPLACE(FORM.REQUESTDATE, ";", ",")#>
			</CFIF>
			<CFSET REQUESTDATEARRAY = ListToArray(FORM.REQUESTDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(REQUESTDATEARRAY)# >
				REQUESTDATE FIELD = #REQUESTDATEARRAY[COUNTER]#<br /><br />
			</CFLOOP>
		</CFIF>
		<CFIF REQUESTDATERANGE EQ "YES">
			<CFSET BEGINREQUESTDATE = DateFormat(#REQUESTDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDREQUESTDATE = DateFormat(#REQUESTDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		REQUESTDATELIST = #REQUESTDATELIST#<br /><br />
		REQUESTDATERANGE = #REQUESTDATERANGE#<br /><br />
	</CFIF>

	<CFIF "#FORM.SUPAPPROVALDATE#" NEQ ''>
		<CFSET SUPAPPROVALDATELIST = "NO">
		<CFSET SUPAPPROVALDATERANGE = "NO">
		<CFIF FIND(',', #FORM.SUPAPPROVALDATE#, 1) EQ 0 AND FIND(';', #FORM.SUPAPPROVALDATE#, 1) EQ 0>
			<CFSET FORM.SUPAPPROVALDATE = DateFormat(FORM.SUPAPPROVALDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.SUPAPPROVALDATE#, 1) NEQ 0>
				<CFSET SUPAPPROVALDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.SUPAPPROVALDATE#, 1) NEQ 0>
				<CFSET SUPAPPROVALDATERANGE = "YES">
				<CFSET FORM.SUPAPPROVALDATE = #REPLACE(FORM.SUPAPPROVALDATE, ";", ",")#>
			</CFIF>
			<CFSET SUPAPPROVALDATEARRAY = ListToArray(FORM.SUPAPPROVALDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(SUPAPPROVALDATEARRAY)# >
				SUPAPPROVALDATE FIELD = #SUPAPPROVALDATEARRAY[COUNTER]#<br /><br />
			</CFLOOP>
		</CFIF>
		<CFIF SUPAPPROVALDATERANGE EQ "YES">
			<CFSET BEGINSUPAPPROVALDATE = DateFormat(#SUPAPPROVALDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDSUPAPPROVALDATE = DateFormat(#SUPAPPROVALDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		SUPAPPROVALDATELIST = #SUPAPPROVALDATELIST#<br /><br />
		SUPAPPROVALDATERANGE = #SUPAPPROVALDATERANGE#<br /><br />
	</CFIF>
	
	<CFIF "#FORM.MGMTAPPROVALDATE#" NEQ ''>
		<CFSET MGMTAPPROVALDATELIST = "NO">
		<CFSET MGMTAPPROVALDATERANGE = "NO">
		<CFIF FIND(',', #FORM.MGMTAPPROVALDATE#, 1) EQ 0 AND FIND(';', #FORM.MGMTAPPROVALDATE#, 1) EQ 0>
			<CFSET FORM.MGMTAPPROVALDATE = DateFormat(FORM.MGMTAPPROVALDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.MGMTAPPROVALDATE#, 1) NEQ 0>
				<CFSET MGMTAPPROVALDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.MGMTAPPROVALDATE#, 1) NEQ 0>
				<CFSET MGMTAPPROVALDATERANGE = "YES">
				<CFSET FORM.MGMTAPPROVALDATE = #REPLACE(FORM.MGMTAPPROVALDATE, ";", ",")#>
			</CFIF>
			<CFSET MGMTAPPROVALDATEARRAY = ListToArray(FORM.MGMTAPPROVALDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(MGMTAPPROVALDATEARRAY)# >
				MGMTAPPROVALDATE FIELD = #MGMTAPPROVALDATEARRAY[COUNTER]#<br /><br />
			</CFLOOP>
		</CFIF>
		<CFIF MGMTAPPROVALDATERANGE EQ "YES">
			<CFSET BEGINMGMTAPPROVALDATE = DateFormat(#MGMTAPPROVALDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDMGMTAPPROVALDATE = DateFormat(#MGMTAPPROVALDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		MGMTAPPROVALDATELIST = #MGMTAPPROVALDATELIST#<br /><br />
		MGMTAPPROVALDATERANGE = #MGMTAPPROVALDATERANGE#<br /><br />
	</CFIF>

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="ListWorkOrders" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	WO.WORKORDERID, WO.FISCALYEARID, WO.WORKORDERNUMBER, WO.REQUESTTYPEID, RT.REQUESTTYPENAME, WO.REQUESTSTATUSID,
				RS.REQUESTSTATUSNAME, WO.REQUESTDATE, WO.REQUESTERID, REQCUST.FULLNAME AS RCNAME, WO.UNITID, UNITS.UNITNAME,
				WO.LOCATIONID, LOC.BUILDINGNAMEID, LOC.ROOMNUMBER, WO.ACCOUNTNUMBER1, WO.ACCOUNTNUMBER2, WO.ACCOUNTNUMBER3,
				WO.ALTERNATECONTACTID, ALTCONT.FULLNAME AS ALTCNAME, WO.PROJECTDESCRIPTION, WO.JUSTIFICATIONDESCRIPTION,
				WO.SUPEMAILID, SUP.FULLNAME AS SUPEMAILNAME, WO.APPROVEDBYSUPID, SUPAPRVL.FULLNAME AS SUPAPRVLNAME, WO.SUPAPPROVALDATE, 
				WO.MGMTEMAILID, MGMT.FULLNAME AS MGMTEMAILNAME, WO.APPROVEDBYMGMTID, MGMTAPRVL.FULLNAME AS MGMTAPRVLNAME, WO.MGMTAPPROVALDATE,
				WO.STARTDATE, WO.COMPLETIONDATE, WO.URGENCY, WO.KEYREQUEST, WO.MOVEREQUEST, WO.TNSREQUEST
		FROM		WORKORDERS WO, LIBSHAREDDATAMGR.FISCALYEARS FY, REQUESTTYPES RT, REQUESTSTATUS RS, LIBSHAREDDATAMGR.CUSTOMERS REQCUST,
				LIBSHAREDDATAMGR.UNITS UNITS, LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS ALTCONT,
				LIBSHAREDDATAMGR.CUSTOMERS SUP, LIBSHAREDDATAMGR.CUSTOMERS SUPAPRVL,
				LIBSHAREDDATAMGR.CUSTOMERS MGMT, LIBSHAREDDATAMGR.CUSTOMERS MGMTAPRVL
		WHERE	(WO.WORKORDERID > 0 AND

		<CFIF session.PROCESS EQ 'REPORT' AND #FORM.REPORTCHOICE# EQ 2>
				WO.KEYREQUEST = 'YES' AND
		</CFIF>

		<CFIF session.PROCESS EQ 'REPORT' AND #FORM.REPORTCHOICE# EQ 3>
				WO.MOVEREQUEST = 'YES' AND
		</CFIF>

				WO.FISCALYEARID = FY.FISCALYEARID AND
				WO.REQUESTTYPEID = RT.REQUESTTYPEID AND
				WO.REQUESTSTATUSID = RS.REQUESTSTATUSID AND
				WO.REQUESTERID = REQCUST.CUSTOMERID AND
				WO.UNITID = UNITS.UNITID AND
				WO.LOCATIONID = LOC.LOCATIONID AND
				WO.ALTERNATECONTACTID = ALTCONT.CUSTOMERID AND
				WO.SUPEMAILID = SUP.CUSTOMERID AND
				WO.APPROVEDBYSUPID = SUPAPRVL.CUSTOMERID AND
				WO.MGMTEMAILID = MGMT.CUSTOMERID AND
				WO.APPROVEDBYMGMTID = MGMTAPRVL.CUSTOMERID) AND (

		<CFIF #FORM.WORKORDERNUMBER# NEQ #ListCurrentFiscalYear.FISCALYEAR_2DIGIT#>
			<CFIF IsDefined('FORM.NEGATEWORKORDERNUMBER')>
				NOT WO.WORKORDERNUMBER = '#FORM.WORKORDERNUMBER#' #LOGICANDOR#
			<CFELSE>
				WO.WORKORDERNUMBER = '#FORM.WORKORDERNUMBER#' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTTYPEID# GT 0>
			<CFIF IsDefined('FORM.NEGATEREQUESTTYPEID')>
				NOT WO.REQUESTTYPEID = #val(FORM.REQUESTTYPEID)# #LOGICANDOR#
			<CFELSE>
				WO.REQUESTTYPEID = #val(FORM.REQUESTTYPEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTSTATUSID# GT 0>
			<CFIF IsDefined('FORM.NEGATEREQUESTSTATUSID')>
				NOT WO.REQUESTSTATUSID = #val(FORM.REQUESTSTATUSID)# #LOGICANDOR#
			<CFELSE>
				WO.REQUESTSTATUSID = #val(FORM.REQUESTSTATUSID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTERID# GT 0>
			<CFIF IsDefined('FORM.NEGATEREQUESTERID')>
				NOT WO.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			<CFELSE>
				WO.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.UNITID# GT 0>
			<CFIF IsDefined('FORM.NEGATEUNITID')>
				NOT WO.UNITID = #val(FORM.UNITID)# #LOGICANDOR#
			<CFELSE>
				WO.UNITID = #val(FORM.UNITID)# #LOGICANDOR#
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
			<CFIF IsDefined('FORM.NEGATEROOMNUMBER')>
				NOT LOC.LOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
			<CFELSE>
				LOC.LOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ROOMNUMBER# NEQ "">
			<CFIF IsDefined('FORM.NEGATEROOMNUMBER')>
				NOT LOC.LOCATIONID IN (#ValueList(LookupRoomNumbers.LOCATIONID)#) #LOGICANDOR#
			<CFELSE>
				LOC.LOCATIONID IN (#ValueList(LookupRoomNumbers.LOCATIONID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTERID# GT 0>
			<CFIF IsDefined('FORM.NEGATEREQUESTERID')>
				NOT WO.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			<CFELSE>
				WO.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ALTERNATECONTACTID# GT 0>
			<CFIF IsDefined('FORM.NEGATEALTERNATECONTACTID')>
				NOT WO.ALTERNATECONTACTID = #val(FORM.ALTERNATECONTACTID)# #LOGICANDOR#
			<CFELSE>
				WO.ALTERNATECONTACTID = #val(FORM.ALTERNATECONTACTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.APPROVEDBYSUPID# GT 0>
			<CFSET session.APPROVER = #FORM.APPROVEDBYSUPID#>
			<CFIF IsDefined('FORM.NEGATEAPPROVEDBYSUPID')>
				NOT WO.APPROVEDBYSUPID = #val(FORM.APPROVEDBYSUPID)# #LOGICANDOR#
			<CFELSE>
				WO.APPROVEDBYSUPID = #val(FORM.APPROVEDBYSUPID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.APPROVEDBYMGMTID# GT 0>
			<CFSET session.APPROVER = #FORM.APPROVEDBYMGMTID#>
			<CFIF IsDefined('FORM.NEGATEAPPROVEDBYMGMTID')>
				NOT WO.APPROVEDBYMGMTID = #val(FORM.APPROVEDBYMGMTID)# #LOGICANDOR#
			<CFELSE>
				WO.APPROVEDBYMGMTID = #val(FORM.APPROVEDBYMGMTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

	<CFIF #FORM.REQUESTDATE# NEQ ''>
		<CFIF IsDefined('FORM.NEGATEREQUESTDATE')>
			<CFIF REQUESTDATELIST EQ "YES">
				<CFLOOP index="Counter" from=1 to=#ArrayLen(REQUESTDATEARRAY)#>
					<CFSET FORMATREQUESTDATE =  DateFormat(#REQUESTDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					NOT WO.REQUESTDATE = TO_DATE('#FORMATREQUESTDATE#', 'DD-MON-YYYY') AND
				</CFLOOP>
				<CFSET FINALTEST = ">">
			<CFELSEIF REQUESTDATERANGE EQ "YES">
				NOT (WO.REQUESTDATE BETWEEN TO_DATE('#BEGINREQUESTDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQUESTDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				NOT WO.REQUESTDATE LIKE TO_DATE('#FORM.REQUESTDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		<CFELSE>
			<CFIF REQUESTDATELIST EQ "YES">
				<CFSET ARRAYCOUNT = (ArrayLen(REQUESTDATEARRAY) - 1)>
				(
				<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
					<CFSET FORMATREQUESTDATE = DateFormat(#REQUESTDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					WO.REQUESTDATE = TO_DATE('#FORMATREQUESTDATE#', 'DD-MON-YYYY') OR
				</CFLOOP>
				<CFSET FORMATREQUESTDATE = DateFormat(#REQUESTDATEARRAY[ArrayLen(REQUESTDATEARRAY)]#, 'DD-MMM-YYYY')>
				WO.REQUESTDATE = TO_DATE('#FORMATREQUESTDATE#', 'DD-MON-YYYY')) OR
				<CFSET FINALTEST = "=">
			<CFELSEIF REQUESTDATERANGE EQ "YES">
				(WO.REQUESTDATE BETWEEN TO_DATE('#BEGINREQUESTDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQUESTDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				WO.REQUESTDATE LIKE TO_DATE('#FORM.REQUESTDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		</CFIF>
	</CFIF>

	<CFIF #FORM.SUPAPPROVALDATE# NEQ ''>
		<CFIF IsDefined('FORM.NEGATESUPAPPROVALDATE')>
			<CFIF SUPAPPROVALDATELIST EQ "YES">
				<CFLOOP index="Counter" from=1 to=#ArrayLen(SUPAPPROVALDATEARRAY)#>
					<CFSET FORMATSUPAPPROVALDATE =  DateFormat(#SUPAPPROVALDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					NOT WO.SUPAPPROVALDATE = TO_DATE('#FORMATSUPAPPROVALDATE#', 'DD-MON-YYYY') AND
				</CFLOOP>
				<CFSET FINALTEST = ">">
			<CFELSEIF SUPAPPROVALDATERANGE EQ "YES">
				NOT (WO.SUPAPPROVALDATE BETWEEN TO_DATE('#BEGINSUPAPPROVALDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDSUPAPPROVALDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				NOT WO.SUPAPPROVALDATE LIKE TO_DATE('#FORM.SUPAPPROVALDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		<CFELSE>
			<CFIF SUPAPPROVALDATELIST EQ "YES">
				<CFSET ARRAYCOUNT = (ArrayLen(SUPAPPROVALDATEARRAY) - 1)>
				(
				<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
					<CFSET FORMATSUPAPPROVALDATE = DateFormat(#SUPAPPROVALDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					WO.SUPAPPROVALDATE = TO_DATE('#FORMATSUPAPPROVALDATE#', 'DD-MON-YYYY') OR
				</CFLOOP>
				<CFSET FORMATSUPAPPROVALDATE = DateFormat(#SUPAPPROVALDATEARRAY[ArrayLen(SUPAPPROVALDATEARRAY)]#, 'DD-MMM-YYYY')>
				WO.SUPAPPROVALDATE = TO_DATE('#FORMATSUPAPPROVALDATE#', 'DD-MON-YYYY')) OR
				<CFSET FINALTEST = "=">
			<CFELSEIF SUPAPPROVALDATERANGE EQ "YES">
				(WO.SUPAPPROVALDATE BETWEEN TO_DATE('#BEGINSUPAPPROVALDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDSUPAPPROVALDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				WO.SUPAPPROVALDATE LIKE TO_DATE('#FORM.SUPAPPROVALDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		</CFIF>
	</CFIF>
	
	<CFIF #FORM.MGMTAPPROVALDATE# NEQ ''>
		<CFIF IsDefined('FORM.NEGATEMGMTAPPROVALDATE')>
			<CFIF MGMTAPPROVALDATELIST EQ "YES">
				<CFLOOP index="Counter" from=1 to=#ArrayLen(MGMTAPPROVALDATEARRAY)#>
					<CFSET FORMATMGMTAPPROVALDATE =  DateFormat(#MGMTAPPROVALDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					NOT WO.MGMTAPPROVALDATE = TO_DATE('#FORMATMGMTAPPROVALDATE#', 'DD-MON-YYYY') AND
				</CFLOOP>
				<CFSET FINALTEST = ">">
			<CFELSEIF MGMTAPPROVALDATERANGE EQ "YES">
				NOT (WO.MGMTAPPROVALDATE BETWEEN TO_DATE('#BEGINMGMTAPPROVALDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMGMTAPPROVALDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				NOT WO.MGMTAPPROVALDATE LIKE TO_DATE('#FORM.MGMTAPPROVALDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		<CFELSE>
			<CFIF MGMTAPPROVALDATELIST EQ "YES">
				<CFSET ARRAYCOUNT = (ArrayLen(MGMTAPPROVALDATEARRAY) - 1)>
				 ( 
				<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
					<CFSET FORMATMGMTAPPROVALDATE = DateFormat(#MGMTAPPROVALDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					WO.MGMTAPPROVALDATE = TO_DATE('#FORMATMGMTAPPROVALDATE#', 'DD-MON-YYYY') OR
				</CFLOOP>
				<CFSET FORMATMGMTAPPROVALDATE = DateFormat(#MGMTAPPROVALDATEARRAY[ArrayLen(MGMTAPPROVALDATEARRAY)]#, 'DD-MMM-YYYY')>
				WO.MGMTAPPROVALDATE = TO_DATE('#FORMATMGMTAPPROVALDATE#', 'DD-MON-YYYY')) OR
				<CFSET FINALTEST = "=">
			<CFELSEIF MGMTAPPROVALDATERANGE EQ "YES">
				(WO.MGMTAPPROVALDATE BETWEEN TO_DATE('#BEGINMGMTAPPROVALDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMGMTAPPROVALDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				WO.MGMTAPPROVALDATE LIKE TO_DATE('#FORM.MGMTAPPROVALDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		</CFIF>
	</CFIF>

		<CFIF #FORM.PROJECTDESCRIPTION# NEQ "">
			<CFIF IsDefined('FORM.NEGATEPROJECTDESCRIPTION')>
				NOT WO.PROJECTDESCRIPTION LIKE UPPER('%#FORM.PROJECTDESCRIPTION#%') #LOGICANDOR#
			<CFELSE>
				WO.PROJECTDESCRIPTION LIKE UPPER('%#FORM.PROJECTDESCRIPTION#%') #LOGICANDOR#

			</CFIF>
		</CFIF>

		<CFIF #FORM.JUSTIFICATIONDESCRIPTION# NEQ "">
			<CFIF IsDefined('FORM.NEGATEJUSTIFICATIONDESCRIPTION')>
				NOT WO.JUSTIFICATIONDESCRIPTION LIKE UPPER('%#FORM.JUSTIFICATIONDESCRIPTION#%') #LOGICANDOR#
			<CFELSE>
				WO.JUSTIFICATIONDESCRIPTION LIKE UPPER('%#FORM.JUSTIFICATIONDESCRIPTION#%') #LOGICANDOR#
			</CFIF>
		</CFIF>
				WO.FISCALYEARID #FINALTEST# '0')
		ORDER BY	WO.WORKORDERNUMBER
	</CFQUERY>

	<CFIF #ListWorkOrders.RecordCount# EQ 0>
		<script language="JavaScript">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			--> 
		</script>
		<CFIF session.PROCESS EQ 'REPORT'>
			<CFSET PROGRAMNAME = 'workorderreports.cfm?PROCESS=REPORT'>
		<CFELSE>
			<CFSET PROGRAMNAME = 'workorderapproval.cfm?PROCESS=APPROVAL'>
		</CFIF>
		<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/#PROGRAMNAME#" />
		<CFEXIT>
	<CFELSEIF session.PROCESS EQ 'APPROVAL'>
			<CFIF #session.APPROVER# EQ 0>
				<CFSET session.APPROVER = #Client.CUSTOMERID#>
			</CFIF>
			<CFQUERY name="LookupMgmtName" datasource="#application.type#LIBSHAREDDATA">
				SELECT	CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, CAMPUSPHONE, FAX, FULLNAME, CATEGORYID, UNITID,
						LOCATIONID, DEPTCHAIR, ALLOWEDTOAPPROVE
				FROM		CUSTOMERS
				WHERE	CUSTOMERID = <CFQUERYPARAM value="#session.APPROVER#" cfsqltype="CF_SQL_NUMERIC">
				ORDER BY	FULLNAME
			</CFQUERY>
			<CFSET session.MGMTNAME = "#LookupMgmtName.FULLNAME#">
			<CFSET temp = ArraySet(session.WORKORDERIDArray, 1, #ListWorkOrders.RecordCount#, 0)> 
			<CFSET session.WORKORDERIDArray = ListToArray(#ValueList(ListWorkOrders.WORKORDERID)#)>
			<CFSET session.ArrayCounter = 1>
			<CFSET session.WORKORDERSSELECTED = #ListWorkOrders.RecordCount#>
			WORKORDER ID's = #ValueList(ListWorkOrders.WORKORDERID)#
	</CFIF>
</CFIF>
</CFOUTPUT>