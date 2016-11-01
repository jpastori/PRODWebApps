<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lookupworkrequestinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/13/2012 --->
<!--- Date in Production: 02/13/2012 --->
<!--- Module: Look Up Process for Facilities - Work Request Reports --->
<!-- Last modified by John R. Pastori on 02/13/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<CFIF NOT IsDefined("URL.LOOKUPWORKREQUEST")>
	<CFIF URL.PROCESS EQ 'REPORT'>
		<CFSET PROGRAMNAME = 'workrequestreports.cfm?LOOKUPWORKREQUEST=FOUND'>
		<CFSET session.PROCESS = 'REPORT'>
		<CFSET SCREENTITLE = 'Facilities - Work Request Reports Lookup '>
	<CFELSE>
		<CFSET PROGRAMNAME = 'workrequestapproval.cfm?LOOKUPWORKREQUEST=FOUND&INITREQ=WO&APPROVAL=MGMT'>
		<CFSET session.PROCESS = 'APPROVAL'>
		<CFSET SCREENTITLE = 'Facilities - Approved Work Request Lookup (An Approver MUST be selected)'>	
	</CFIF>

	<CFSET temp = ArraySet(session.WORKREQUESTIDArray, 1, 1, 0)>
	<CFSET session.ArrayCounter = 0>
	<CFSET session.WORKREQUESTSSELECTED = 0>

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
     
<!--- 
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
 --->
 
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
				<h2>Select from the drop down boxes or type in partial values to choose report criteria for Facilities Work Requests. <br /> 
				Checking an adjacent checkbox will Negate the selection or data entered.</h2>
			</th>
		</tr>
	</table>
	<br />
	<table width="100%" align="LEFT">
		<tr>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
			<td align="LEFT" valign="TOP" colspan="2">
				<input type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</CFFORM>
		</tr>
<CFFORM name="LOOKUP" action="/#application.type#apps/facilities/#PROGRAMNAME#" method="POST">
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEWORKREQUESTNUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="WORKREQUESTNUMBER">Select a Work Request Number.</label>
			</th>
			<th align="LEFT" colspan="2">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEWORKREQUESTNUMBER" id="NEGATEWORKREQUESTNUMBER" value="" align="LEFT" required="No" tabindex="2">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="TEXT" name="WORKREQUESTNUMBER" id="WORKREQUESTNUMBER" size="15" value="#ListCurrentFiscalYear.FISCALYEAR_2DIGIT#" required="No" tabindex="3">
			</td>
			<td align="left" colspan="2">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEREQUESTTYPEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="REQUESTTYPEID">Select a Request Type.</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEREQUESTSTATUSID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="REQUESTSTATUSID">Select a Request Status.</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTTYPEID" id="NEGATEREQUESTTYPEID" value="" align="LEFT" required="No" tabindex="4">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="REQUESTTYPEID" id="REQUESTTYPEID" size="1" query="ListRequestTypes" value="REQUESTTYPEID" display="REQUESTTYPENAME" required="No" selected="" tabindex="5"></CFSELECT>
			</td>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTSTATUSID" id="NEGATEREQUESTSTATUSID" value="" align="LEFT" required="No" tabindex="6">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="REQUESTSTATUSID" id="REQUESTSTATUSID" size="1" query="ListRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" selected="" tabindex="7"></CFSELECT>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEREQUESTERID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="REQUESTERID">Select a Requester.</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEUNITID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="UNITID">Select a Unit.</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTERID" id="NEGATEREQUESTERID" value="" align="LEFT" required="No" tabindex="8">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="9"></CFSELECT>
			</td>			
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" align="LEFT" required="No" tabindex="10">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="0" required="No" tabindex="11"></CFSELECT>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEBUILDINGNAMEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="BUILDINGNAMEID">Select a Building.</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEROOMNUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="LOCATIONID">
				Select (1) a Room Number or </label><br />
				&nbsp;<label for="ROOMNUMBER">Enter &nbsp;(2) a partial Room Number or <br />
				&nbsp;(3) a series of Room Numbers separated by commas,NO spaces.</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBUILDINGID" id="NEGATEBUILDINGNAMEID" value="" align="LEFT" required="No" tabindex="12">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="BUILDINGNAMEID" id="BUILDINGNAMEID" size="1" query="ListBuildings" value="BUILDINGNAMEID" display="BUILDINGNAME" selected="0" required="No" tabindex="13"></CFSELECT>
			</td>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEROOMNUMBER" id="NEGATEROOMNUMBER" value="" align="LEFT" required="No" tabindex="14">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="15"></CFSELECT>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBER" value="" required="No" size="20" maxlength="50" tabindex="16">
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEALTERNATECONTACTID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="ALTERNATECONTACTID">Select an Alternate Contact.</label>
			</th>
			<th align="LEFT" width="5%">&nbsp;&nbsp;</th>
               <th align="left" valign="BOTTOM" width="45%">
                   	<LABEL for="URGENCY">Select an Urgency.</LABEL>
               </th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEALTERNATECONTACTID" id="NEGATEALTERNATECONTACTID" value="" align="LEFT" required="No" tabindex="16">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="ALTERNATECONTACTID" id="ALTERNATECONTACTID" size="1" query="ListAlternateContacts" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="17"></CFSELECT>
			</td>
               <td align="LEFT" valign="TOP" width="5%">&nbsp;&nbsp;</td>
			<TD align="left" valign="TOP" width="45%">
                         <CFSELECT name="URGENCY" id="URGENCY" size="1" tabindex="18">
                              <OPTION value="Select an Urgency">Select an Urgency</OPTION>
                              <OPTION value="Power Out/No Lights">Power Out/No Lights</OPTION>
                              <OPTION value="Public Service Affected">Public Service Affected</OPTION>
                         </CFSELECT>
               </TD>
		</tr>
          <tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
<!--- 
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEAPPROVEDBYSUPID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="APPROVEDBYSUPID">Select a Unit Head Approver.</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEAPPROVEDBYMGMTID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="APPROVEDBYMGMTID">Select a Management Approver.</label>
			</th>
		</tr>
		<tr>
		
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAPPROVEDBYSUPID" id="NEGATEAPPROVEDBYSUPID" value="" align="LEFT" required="No" tabindex="23">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="APPROVEDBYSUPID" id="APPROVEDBYSUPID" size="1" query="ListSupApprover" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="24"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAPPROVEDBYMGMTID" id="NEGATEAPPROVEDBYMGMTID" value="" align="LEFT" required="No" tabindex="23">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="APPROVEDBYMGMTID" id="APPROVEDBYMGMTID" size="1" query="ListMgmtApprover" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="24"></CFSELECT>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
 --->
 		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEREQUESTDATE">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="REQUESTDATE">
				Enter (1) a single Date Requested or <br />
				&nbsp;(2) a series of dates separated by commas,NO spaces or<br />
				&nbsp;(3) two dates separated by a semicolon for range.</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEINITAPPROVALDATE">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="INITAPPROVALDATE">
				Enter (1) a single Initial Approval Date or <br />
				&nbsp;(2) a series of dates separated by commas,NO spaces or<br />
				&nbsp;(3) two dates separated by a semicolon for range.</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTDATE" id="NEGATEREQUESTDATE" value="" align="LEFT" required="No" tabindex="19">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="REQUESTDATE" id="REQUESTDATE" value="" required="No" size="50" tabindex="20">
			</td>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEINITAPPROVALDATE" id="NEGATEINITAPPROVALDATE" value="" align="LEFT" required="No" tabindex="19">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="INITAPPROVALDATE" id="INITAPPROVALDATE" value="" required="No" size="50" tabindex="20">
			</td>
		</tr>
<!--- 
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESUPAPPROVALDATE">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SUPAPPROVALDATE">
				Enter (1) a single Unit Head Date Approved or <br />
				&nbsp;(2) a series of dates separated by commas,NO spaces or<br />
				&nbsp;(3) two dates separated by a semicolon for range.</label>
			</th>
			<th align="LEFT" colspan="2">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESUPAPPROVALDATE" id="NEGATESUPAPPROVALDATE" value="" align="LEFT" required="No" tabindex="27">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="SUPAPPROVALDATE" id="SUPAPPROVALDATE" value="" required="No" size="50" tabindex="28">
			</td>
			<td align="LEFT" colspan="2">&nbsp;&nbsp;</td>
		</tr>
 --->
 		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
 		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEPROBLEMDESCRIPTION">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="PROBLEMDESCRIPTION">Enter a partial phrase used in the Problem Description.</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEJUSTIFICATIONDESCRIPTION">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="JUSTIFICATIONDESCRIPTION">Enter a partial phrase used in the Justification Description.</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPROBLEMDESCRIPTION" id="NEGATEPROBLEMDESCRIPTION" value="" align="LEFT" required="No" tabindex="21">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="PROBLEMDESCRIPTION" id="PROBLEMDESCRIPTION" value="" align="LEFT" required="No" size="50" tabindex="22">
			</td>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEJUSTIFICATIONDESCRIPTION" id="NEGATEJUSTIFICATIONDESCRIPTION" value="" align="LEFT" required="No" tabindex="23">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="JUSTIFICATIONDESCRIPTION" id="JUSTIFICATIONDESCRIPTION" value="" align="LEFT" required="No" size="50" tabindex="24">
			</td>
		</tr>
 		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
          <tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTATUS_COMMENTS">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="STATUS_COMMENTS">Enter a partial phrase used in the Status Comments.</label>
			</th>
			<th align="LEFT" colspan="2">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTATUS_COMMENTS" id="NEGATESTATUS_COMMENTS" value="" align="LEFT" required="No" tabindex="25">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="STATUS_COMMENTS" id="STATUS_COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="26">
			</td>
			<td align="LEFT" colspan="2">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
	<CFIF session.PROCESS EQ 'REPORT'>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEKEYTYPEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="KEYTYPEID">Select a Key Type.</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEMOVETYPEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="MOVETYPEID">Select a Move Type.</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEKEYTYPEID" id="NEGATEKEYTYPEID" value="" align="LEFT" required="No" tabindex="27">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="KEYTYPEID" id="KEYTYPEID" size="1" query="ListKeyTypes" value="KEYTYPEID" display="KEYTYPENAME" required="No" selected="" tabindex="28"></CFSELECT><br />
				<COM>For use with Key Requests Report ONLY! &nbsp;&nbsp;Click "Match All" Button.</COM>
			</td>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMOVETYPEID" id="NEGATEMOVETYPEID" value="" align="LEFT" required="No" tabindex="29">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="MOVETYPEID" id="MOVETYPEID" size="1" query="ListMoveTypes" value="MOVETYPEID" display="MOVETYPENAME" required="No" selected="" tabindex="30"></CFSELECT><br />
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
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="31"><label for="REPORTCHOICE1">Work Requests Report</label><br />
				<COM>(Click "Match All" Button with no selection for an ALL WORK REQUESTS Report.)</COM><br /><br />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="32"><label for="REPORTCHOICE2">Key Requests Report</label><br />
				<COM>(Click "Match All" Button with no selection for an ALL KEY REQUESTS Report.)</COM><br /><br />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="33"><label for="REPORTCHOICE3">Move Requests Report (includes TNS Phone Moves)</label><br />
				<COM>(Click "Match All" Button with no selection for an ALL MOVE REQUESTS Report.)</COM><br /><br />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="34"><label for="REPORTCHOICE4">TNS New/Disconnect Phone Requests Report</label><br />
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
			<td align="LEFT" colspan="4"><COM>(Click "Match All" Button with no selection to access ALL Work Request records.)</COM></td>
		</tr>
		<tr>
			<td align="LEFT" colspan="4">
				<br /><input type="submit" name="ProcessLookup" value="Match Any Field Entered" tabindex="35" />
			</td>
		</tr>
		<tr>
			<td align="LEFT" colspan="4">
				<input type="submit" name="ProcessLookup" value="Match All Fields Entered" tabindex="36" />
			</td>
		</tr>
</CFFORM>
		<tr>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
			<td align="LEFT" valign="TOP" colspan="4">
				<input type="SUBMIT" value="Cancel" tabindex="37" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</CFFORM>
		</tr>
		<tr>
			<td align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>

<CFEXIT>
<CFELSEIF (session.PROCESS EQ 'REPORT') OR (session.PROCESS EQ 'APPROVAL' AND session.WORKREQUESTIDArray[1] EQ 0)>
<!--- 
*********************************************************************
* The following code is the Work Request Report Generation Process. *
*********************************************************************
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
				<CFSET PROGRAMNAME = 'workrequestreports.cfm?PROCESS=REPORT'>
			<CFELSE>
				<CFSET PROGRAMNAME = 'workrequestapproval.cfm?PROCESS=APPROVAL'>
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
<!--- 
	<CFQUERY name="LookupSupApprovers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, CAMPUSPHONE, FAX, FULLNAME, CATEGORYID, UNITID,
				LOCATIONID, DEPTCHAIR, ALLOWEDTOAPPROVE
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.APPROVEDBYSUPID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>
 --->

<!--- 
	<CFQUERY name="LookupMgmtApprovers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, CAMPUSPHONE, FAX, FULLNAME, CATEGORYID, UNITID,
				LOCATIONID, DEPTCHAIR, ALLOWEDTOAPPROVE
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.APPROVEDBYMGMTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY> 
--->

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

	<CFIF #FORM.REQUESTDATE# NEQ ''>
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
				REQUEST DATE FIELD = #REQUESTDATEARRAY[COUNTER]#<br /><br />
			</CFLOOP>
		</CFIF>
		<CFIF REQUESTDATERANGE EQ "YES">
			<CFSET BEGINREQUESTDATE = DateFormat(#REQUESTDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDREQUESTDATE = DateFormat(#REQUESTDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		REQUESTDATELIST = #REQUESTDATELIST#<br /><br />
		REQUESTDATERANGE = #REQUESTDATERANGE#<br /><br />
	</CFIF>

     <CFIF #FORM.INITAPPROVALDATE# NEQ ''>
		<CFSET INITAPPROVALDATELIST = "NO">
		<CFSET INITAPPROVALDATERANGE = "NO">
		<CFIF FIND(',', #FORM.INITAPPROVALDATE#, 1) EQ 0 AND FIND(';', #FORM.INITAPPROVALDATE#, 1) EQ 0>
			<CFSET FORM.INITAPPROVALDATE = DateFormat(FORM.INITAPPROVALDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.INITAPPROVALDATE#, 1) NEQ 0>
				<CFSET INITAPPROVALDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.INITAPPROVALDATE#, 1) NEQ 0>
				<CFSET INITAPPROVALDATERANGE = "YES">
				<CFSET FORM.INITAPPROVALDATE = #REPLACE(FORM.INITAPPROVALDATE, ";", ",")#>
			</CFIF>
			<CFSET INITAPPROVALDATEARRAY = ListToArray(FORM.INITAPPROVALDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(INITAPPROVALDATEARRAY)# >
				INIT APPROVAL DATE FIELD = #INITAPPROVALDATEARRAY[COUNTER]#<br /><br />
			</CFLOOP>
		</CFIF>
		<CFIF INITAPPROVALDATERANGE EQ "YES">
			<CFSET BEGININITAPPROVALDATE = DateFormat(#INITAPPROVALDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDINITAPPROVALDATE = DateFormat(#INITAPPROVALDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		INITAPPROVALDATELIST = #INITAPPROVALDATELIST#<br /><br />
		INITAPPROVALDATERANGE = #INITAPPROVALDATERANGE#<br /><br />
	</CFIF>
<!--- 
	<CFIF #FORM.SUPAPPROVALDATE# NEQ ''>
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
 --->	
	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="ListWorkRequests" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	WR.WORKREQUESTID, WR.FISCALYEARID, WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.REQUESTSTATUSID,
				RS.REQUESTSTATUSNAME, WR.REQUESTDATE, WR.INITAPPROVALDATE, WR.REQUESTERID, REQCUST.FULLNAME AS RCNAME, WR.UNITID, 
                    UNITS.UNITNAME, WR.LOCATIONID, LOC.BUILDINGNAMEID, LOC.ROOMNUMBER, WR.ACCOUNTNUMBER1, WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3,
                    WR.ALTERNATECONTACTID, ALTCONT.FULLNAME AS ALTCNAME, WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION, WR.SUPEMAILID, 
                    SUP.FULLNAME AS SUPEMAILNAME, WR.APPROVEDBYSUPID, SUPAPRVL.FULLNAME AS SUPAPRVLNAME, 
<!--- 
				WR.SUPAPPROVALDATE, WR.MGMTEMAILID, MGMT.FULLNAME AS MGMTEMAILNAME, WR.APPROVEDBYMGMTID, MGMTAPRVL.FULLNAME AS MGMTAPRVLNAME, 
--->
				WR.STARTDATE, WR.COMPLETIONDATE, WR.URGENCY, WR.KEYREQUEST, WR.MOVEREQUEST, WR.TNSREQUEST, WR.STATUS_COMMENTS
		FROM		WORKREQUESTS WR, LIBSHAREDDATAMGR.FISCALYEARS FY, REQUESTTYPES RT, REQUESTSTATUS RS, LIBSHAREDDATAMGR.CUSTOMERS REQCUST,
				LIBSHAREDDATAMGR.UNITS UNITS, LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS ALTCONT, LIBSHAREDDATAMGR.CUSTOMERS SUP, 
				LIBSHAREDDATAMGR.CUSTOMERS SUPAPRVL 
<!--- 
				, LIBSHAREDDATAMGR.CUSTOMERS MGMT, LIBSHAREDDATAMGR.CUSTOMERS MGMTAPRVL
 --->
		WHERE	((WR.WORKREQUESTID > 0 AND
				WR.FISCALYEARID = FY.FISCALYEARID AND
				WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
				WR.REQUESTSTATUSID = RS.REQUESTSTATUSID AND
				WR.REQUESTERID = REQCUST.CUSTOMERID AND
				WR.UNITID = UNITS.UNITID AND
				WR.LOCATIONID = LOC.LOCATIONID AND
				WR.ALTERNATECONTACTID = ALTCONT.CUSTOMERID AND
				WR.SUPEMAILID = SUP.CUSTOMERID AND
          <CFIF session.PROCESS EQ 'REPORT' AND #FORM.REPORTCHOICE# EQ 2>
				WR.KEYREQUEST = 'YES' AND
		</CFIF>

		<CFIF session.PROCESS EQ 'REPORT' AND #FORM.REPORTCHOICE# EQ 3>
				WR.MOVEREQUEST = 'YES' AND
		</CFIF>
				WR.APPROVEDBYSUPID = SUPAPRVL.CUSTOMERID) AND (
<!---			WR.MGMTEMAILID = MGMT.CUSTOMERID AND
				WR.APPROVEDBYMGMTID = MGMTAPRVL.CUSTOMERID  AND  ---> 
                    

		<CFIF #FORM.WORKREQUESTNUMBER# NEQ #ListCurrentFiscalYear.FISCALYEAR_2DIGIT#>
			<CFIF IsDefined('FORM.NEGATEWORKREQUESTNUMBER')>
				NOT WR.WORKREQUESTNUMBER = '#FORM.WORKREQUESTNUMBER#' #LOGICANDOR#
			<CFELSE>
				WR.WORKREQUESTNUMBER = '#FORM.WORKREQUESTNUMBER#' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTTYPEID# GT 0>
			<CFIF IsDefined('FORM.NEGATEREQUESTTYPEID')>
				NOT WR.REQUESTTYPEID = #val(FORM.REQUESTTYPEID)# #LOGICANDOR#
			<CFELSE>
				WR.REQUESTTYPEID = #val(FORM.REQUESTTYPEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTSTATUSID# GT 0>
			<CFIF IsDefined('FORM.NEGATEREQUESTSTATUSID')>
				NOT WR.REQUESTSTATUSID = #val(FORM.REQUESTSTATUSID)# #LOGICANDOR#
			<CFELSE>
				WR.REQUESTSTATUSID = #val(FORM.REQUESTSTATUSID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTERID# GT 0>
			<CFIF IsDefined('FORM.NEGATEREQUESTERID')>
				NOT WR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			<CFELSE>
				WR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.UNITID# GT 0>
			<CFIF IsDefined('FORM.NEGATEUNITID')>
				NOT WR.UNITID = #val(FORM.UNITID)# #LOGICANDOR#
			<CFELSE>
				WR.UNITID = #val(FORM.UNITID)# #LOGICANDOR#
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
				NOT WR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			<CFELSE>
				WR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ALTERNATECONTACTID# GT 0>
			<CFIF IsDefined('FORM.NEGATEALTERNATECONTACTID')>
				NOT WR.ALTERNATECONTACTID = #val(FORM.ALTERNATECONTACTID)# #LOGICANDOR#
			<CFELSE>
				WR.ALTERNATECONTACTID = #val(FORM.ALTERNATECONTACTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

			<CFIF #FORM.URGENCY# NEQ "Select an Urgency">
                    WR.URGENCY = '#FORM.URGENCY#' #LOGICANDOR#
               </CFIF>

<!--- 
		<CFIF #FORM.APPROVEDBYSUPID# GT 0>
			<CFSET session.APPROVER = #FORM.APPROVEDBYSUPID#>
			<CFIF IsDefined('FORM.NEGATEAPPROVEDBYSUPID')>
				NOT WR.APPROVEDBYSUPID = #val(FORM.APPROVEDBYSUPID)# #LOGICANDOR#
			<CFELSE>
				WR.APPROVEDBYSUPID = #val(FORM.APPROVEDBYSUPID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.APPROVEDBYMGMTID# GT 0>
			<CFSET session.APPROVER = #FORM.APPROVEDBYMGMTID#>
			<CFIF IsDefined('FORM.NEGATEAPPROVEDBYMGMTID')>
				NOT WR.APPROVEDBYMGMTID = #val(FORM.APPROVEDBYMGMTID)# #LOGICANDOR#
			<CFELSE>
				WR.APPROVEDBYMGMTID = #val(FORM.APPROVEDBYMGMTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
 --->
	<CFIF #FORM.REQUESTDATE# NEQ ''>
		<CFIF IsDefined('FORM.NEGATEREQUESTDATE')>
			<CFIF REQUESTDATELIST EQ "YES">
				<CFLOOP index="Counter" from=1 to=#ArrayLen(REQUESTDATEARRAY)#>
					<CFSET FORMATREQUESTDATE =  DateFormat(#REQUESTDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					NOT WR.REQUESTDATE = TO_DATE('#FORMATREQUESTDATE#', 'DD-MON-YYYY') AND
				</CFLOOP>
                    <CFSET FINALTEST = ">">
			<CFELSEIF REQUESTDATERANGE EQ "YES">
				NOT (WR.REQUESTDATE BETWEEN TO_DATE('#BEGINREQUESTDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQUESTDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				NOT WR.REQUESTDATE LIKE TO_DATE('#FORM.REQUESTDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		<CFELSE>
			<CFIF REQUESTDATELIST EQ "YES">
				<CFSET ARRAYCOUNT = (ArrayLen(REQUESTDATEARRAY) - 1)>
				(
				<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
					<CFSET FORMATREQUESTDATE = DateFormat(#REQUESTDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					WR.REQUESTDATE = TO_DATE('#FORMATREQUESTDATE#', 'DD-MON-YYYY') OR
				</CFLOOP>
				<CFSET FORMATREQUESTDATE = DateFormat(#REQUESTDATEARRAY[ArrayLen(REQUESTDATEARRAY)]#, 'DD-MMM-YYYY')>
				WR.REQUESTDATE = TO_DATE('#FORMATREQUESTDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSEIF REQUESTDATERANGE EQ "YES">
				(WR.REQUESTDATE BETWEEN TO_DATE('#BEGINREQUESTDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQUESTDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				WR.REQUESTDATE LIKE TO_DATE('#FORM.REQUESTDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		</CFIF>
	</CFIF>
 
     <CFIF #FORM.INITAPPROVALDATE# NEQ ''>
		<CFIF IsDefined('FORM.NEGATEINITAPPROVALDATE')>
               <CFIF INITAPPROVALDATELIST EQ "YES">
                    <CFLOOP index="Counter" from=1 to=#ArrayLen(INITAPPROVALDATEARRAY)#>
                         <CFSET FORMATINITAPPROVALDATE =  DateFormat(#INITAPPROVALDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
                         NOT WR.INITAPPROVALDATE = TO_DATE('#FORMATINITAPPROVALDATE#', 'DD-MON-YYYY') AND
                    </CFLOOP>
                    <CFSET FINALTEST = ">">
               <CFELSEIF INITAPPROVALDATERANGE EQ "YES">
                    NOT (WR.INITAPPROVALDATE BETWEEN TO_DATE('#BEGININITAPPROVALDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDINITAPPROVALDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
               <CFELSE>
                    NOT WR.INITAPPROVALDATE LIKE TO_DATE('#FORM.INITAPPROVALDATE#', 'DD-MON-YYYY') #LOGICANDOR#
               </CFIF>
          <CFELSE>
               <CFIF INITAPPROVALDATELIST EQ "YES">
                    <CFSET ARRAYCOUNT = (ArrayLen(INITAPPROVALDATEARRAY) - 1)>
                    (
                    <CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
                         <CFSET FORMATINITAPPROVALDATE = DateFormat(#INITAPPROVALDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
                         WR.INITAPPROVALDATE = TO_DATE('#FORMATINITAPPROVALDATE#', 'DD-MON-YYYY') OR
                    </CFLOOP>
                    <CFSET FORMATINITAPPROVALDATE = DateFormat(#INITAPPROVALDATEARRAY[ArrayLen(INITAPPROVALDATEARRAY)]#, 'DD-MMM-YYYY')>
                    WR.INITAPPROVALDATE = TO_DATE('#FORMATINITAPPROVALDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
               <CFELSEIF INITAPPROVALDATERANGE EQ "YES">
                         (WR.INITAPPROVALDATE BETWEEN TO_DATE('#BEGININITAPPROVALDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDINITAPPROVALDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
               <CFELSE>
                    WR.INITAPPROVALDATE LIKE TO_DATE('#FORM.INITAPPROVALDATE#', 'DD-MON-YYYY') #LOGICANDOR#
               </CFIF>
          </CFIF>
     </CFIF>
 
<!--- 
	<CFIF #FORM.SUPAPPROVALDATE# NEQ ''>
		<CFIF IsDefined('FORM.NEGATESUPAPPROVALDATE')>
			<CFIF SUPAPPROVALDATELIST EQ "YES">
				<CFLOOP index="Counter" from=1 to=#ArrayLen(SUPAPPROVALDATEARRAY)#>
					<CFSET FORMATSUPAPPROVALDATE =  DateFormat(#SUPAPPROVALDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					NOT WR.SUPAPPROVALDATE = TO_DATE('#FORMATSUPAPPROVALDATE#', 'DD-MON-YYYY') AND
				</CFLOOP>
				<CFSET FINALTEST = ">">
			<CFELSEIF SUPAPPROVALDATERANGE EQ "YES">
				NOT (WR.SUPAPPROVALDATE BETWEEN TO_DATE('#BEGINSUPAPPROVALDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDSUPAPPROVALDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				NOT WR.SUPAPPROVALDATE LIKE TO_DATE('#FORM.SUPAPPROVALDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		<CFELSE>
			<CFIF SUPAPPROVALDATELIST EQ "YES">
				<CFSET ARRAYCOUNT = (ArrayLen(SUPAPPROVALDATEARRAY) - 1)>
				(
				<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
					<CFSET FORMATSUPAPPROVALDATE = DateFormat(#SUPAPPROVALDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					WR.SUPAPPROVALDATE = TO_DATE('#FORMATSUPAPPROVALDATE#', 'DD-MON-YYYY') OR
				</CFLOOP>
				<CFSET FORMATSUPAPPROVALDATE = DateFormat(#SUPAPPROVALDATEARRAY[ArrayLen(SUPAPPROVALDATEARRAY)]#, 'DD-MMM-YYYY')>
				WR.SUPAPPROVALDATE = TO_DATE('#FORMATSUPAPPROVALDATE#', 'DD-MON-YYYY')) #LOGICANDOR#

			<CFELSEIF SUPAPPROVALDATERANGE EQ "YES">
				(WR.SUPAPPROVALDATE BETWEEN TO_DATE('#BEGINSUPAPPROVALDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDSUPAPPROVALDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
			<CFELSE>
				WR.SUPAPPROVALDATE LIKE TO_DATE('#FORM.SUPAPPROVALDATE#', 'DD-MON-YYYY') #LOGICANDOR#
			</CFIF>
		</CFIF>
	</CFIF>
 --->	
		<CFIF #FORM.PROBLEMDESCRIPTION# NEQ "">
			<CFIF IsDefined('FORM.NEGATEPROBLEMDESCRIPTION')>
				NOT WR.PROBLEMDESCRIPTION LIKE UPPER('%#FORM.PROBLEMDESCRIPTION#%') #LOGICANDOR#
			<CFELSE>
				WR.PROBLEMDESCRIPTION LIKE UPPER('%#FORM.PROBLEMDESCRIPTION#%') #LOGICANDOR#

			</CFIF>
		</CFIF>

		<CFIF #FORM.JUSTIFICATIONDESCRIPTION# NEQ "">
			<CFIF IsDefined('FORM.NEGATEJUSTIFICATIONDESCRIPTION')>
				NOT WR.JUSTIFICATIONDESCRIPTION LIKE UPPER('%#FORM.JUSTIFICATIONDESCRIPTION#%') #LOGICANDOR#
			<CFELSE>
				WR.JUSTIFICATIONDESCRIPTION LIKE UPPER('%#FORM.JUSTIFICATIONDESCRIPTION#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

          <CFIF #FORM.STATUS_COMMENTS# NEQ "">
			<CFIF IsDefined('FORM.NEGATESTATUS_COMMENTS')>
				NOT WR.STATUS_COMMENTS LIKE UPPER('%#FORM.STATUS_COMMENTS#%') #LOGICANDOR#
			<CFELSE>
				WR.STATUS_COMMENTS LIKE UPPER('%#FORM.STATUS_COMMENTS#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

				(WR.FISCALYEARID #FINALTEST# 0)))
		ORDER BY	WR.WORKREQUESTNUMBER
	</CFQUERY>

	<CFIF #ListWorkRequests.RecordCount# EQ 0>
		<script language="JavaScript">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			--> 
		</script>
		<CFIF session.PROCESS EQ 'REPORT'>
			<CFSET PROGRAMNAME = 'workrequestreports.cfm?PROCESS=REPORT'>
		<CFELSE>
			<CFSET PROGRAMNAME = 'workrequestapproval.cfm?PROCESS=APPROVAL'>
		</CFIF>
		<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/#PROGRAMNAME#" />
		<CFEXIT>
	<CFELSEIF session.PROCESS EQ 'APPROVAL'>
			<CFIF #session.APPROVER# EQ 0>
				<CFSET session.APPROVER = #Client.CUSTOMERID#>
			</CFIF>

			<CFQUERY name="LookupApproverName" datasource="#application.type#LIBSHAREDDATA">
				SELECT	CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, CAMPUSPHONE, FAX, FULLNAME, CATEGORYID, UNITID,
						LOCATIONID, DEPTCHAIR, ALLOWEDTOAPPROVE
				FROM		CUSTOMERS
				WHERE	CUSTOMERID = <CFQUERYPARAM value="#session.APPROVER#" cfsqltype="CF_SQL_NUMERIC">
				ORDER BY	FULLNAME
			</CFQUERY>
			<CFSET session.Approver = "#LookupApproverName.FULLNAME#">

 			<CFSET temp = ArraySet(session.WORKREQUESTIDArray, 1, #ListWorkRequests.RecordCount#, 0)> 
			<CFSET session.WORKREQUESTIDArray = ListToArray(#ValueList(ListWorkRequests.WORKREQUESTID)#)>
			<CFSET session.ArrayCounter = 1>
			<CFSET session.WORKREQUESTSSELECTED = #ListWorkRequests.RecordCount#>
			WORK REQUEST ID's = #ValueList(ListWorkRequests.WORKREQUESTID)#
	</CFIF>
</CFIF>
</CFOUTPUT>