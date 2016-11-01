<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: srreviewreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/11/2013 --->
<!--- Date in Production: 10/11/2013 --->
<!--- Module: Service Request - SR Review Report --->
<!-- Last modified by John R. Pastori on 06/30/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/srreviewreport.cfm">
<cfset CONTENT_UPDATED = "June 30, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<cfif (FIND('joel', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "JOEL")>
	<cfset SESSION.ORIGINSERVER = "JOEL">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelse>
	<cfset SESSION.ORIGINSERVER = "">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
</cfif>

<html> 
<head>
	<title>Service Request - SR Review Report</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Service Requests Application!";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}


	function validateLookupFields() {
		
		if  (document.LOOKUP.SERVICEREQUESTNUMBER.value.length == "5" && document.LOOKUP.REQUESTERID.selectedIndex == "0"
		 &&  document.LOOKUP.UNITID.selectedIndex == "0"			  && document.LOOKUP.ALTCONTACTID.selectedIndex == "0"
		 &&  document.LOOKUP.SRCOMPLETED.value == "Select Status"     && document.LOOKUP.FISCALYEARID.selectedIndex == "0"	
		 &&  document.LOOKUP.CATEGORYID.selectedIndex == "0" 	       && document.LOOKUP.SUBCATEGORYID.selectedIndex == "0"    
		 && (document.LOOKUP.PROBLEM_DESCRIPTION.value == ""          || document.LOOKUP.PROBLEM_DESCRIPTION.value == " ")
		 && (document.LOOKUP.STAFF_COMMENTS.value == ""               || document.LOOKUP.STAFF_COMMENTS.value == " ")	 
		 &&  document.LOOKUP.EQUIPMENTSR.selectedIndex == "0"         && document.LOOKUP.BARCODETEXT.value == "3065000"
		 && (document.LOOKUP.CREATIONDATE.value == ""                 || document.LOOKUP.CREATIONDATE.value == " ")
		 && (document.LOOKUP.SRCOMPLETEDDATE.value == ""              || document.LOOKUP.SRCOMPLETEDDATE.value == " ")
		 &&  document.LOOKUP.PRIORITYID.selectedIndex == "0"          && document.LOOKUP.STAFF_ASSIGNMENT_ORDER.selectedIndex == "0"
		 &&  document.LOOKUP.ALLSRASSIGN.selectedIndex == "0"         && document.LOOKUP.ALLSRWORKGROUP.selectedIndex == "0"
		 &&  document.LOOKUP.STAFF_ASSIGNED.value == "Staff Assigned" &&  document.LOOKUP.STAFF_COMPLETEDSR.value == "Select Status"
		 &&  document.LOOKUP.PRIMARYASSIGN.selectedIndex == "0"       && document.LOOKUP.PRIMARYWORKGROUP.selectedIndex == "0"
		 &&  document.LOOKUP.NEXTASSIGN.selectedIndex == "0"          && document.LOOKUP.NEXTWORKGROUP.selectedIndex == "0") {
			alertuser ("You must enter information in at least one of the twenty-four (24) fields!");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}
			
		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length > 5 && document.LOOKUP.SERVICEREQUESTNUMBER.value.length < 9) {
			alertuser (document.LOOKUP.SERVICEREQUESTNUMBER.name +  ",  If you include an Service Request Number, it MUST be 9 characters in the format 2 digit fiscal year begin/end and 4 digit sequence number: yy/yy9999.");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}
		
		if (document.LOOKUP.EQUIPMENTSR.selectedIndex > "0" && document.LOOKUP.BARCODETEXT.value.length > 7) {
			alertuser ("Only one Equipment Barcode Lookup Field can be used!");
			document.LOOKUP.EQUIPMENTSR.focus();
			return false;
		}
		
		if (document.LOOKUP.BARCODETEXT.value.length == 14) {
			var barcode = document.LOOKUP.BARCODETEXT.value;
			document.LOOKUP.BARCODETEXT.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}
		
		if (document.LOOKUP.STAFF_ASSIGNMENT_ORDER.selectedIndex > "0" && document.LOOKUP.PRIORITYID.selectedIndex == "0") {
			alertuser ("A Prioity MUST be selected if a Code is selected!");
			document.LOOKUP.PRIORITYID.focus();
			return false;
		}
		
	}
	

	function setMatchAny() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match Any Field Entered";
		return true;
	}


//
</script>
<script language="JavaScript" src="../calendar_us.js"></script>
<!--Script ends here -->

</head>

<cfoutput>

<cfset CURSORFIELD = "document.LOOKUP.SERVICEREQUESTNUMBER.focus()">

<body onLoad="#CURSORFIELD#">

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<cfquery name="LookupCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
     SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
     FROM		FISCALYEARS
     WHERE	(CURRENTFISCALYEAR = 'YES')
     ORDER BY	FISCALYEARID
</cfquery>
 
<!--- 
***********************************************************************************************
* The following code is the Look Up Process for Service Request - SR Review Record Selection. *
***********************************************************************************************
 --->

<cfif NOT IsDefined('URL.LOOKUPSR')>


	<cfquery name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
          SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, U.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
				CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS U, FACILITIESMGR.LOCATIONS LOC
          WHERE	(CUST.CUSTOMERID = 0 OR
                    CUST.ACTIVE = 'YES') AND	
                    (CUST.UNITID = U.UNITID AND
				CUST.LOCATIONID = LOC.LOCATIONID)	
          ORDER BY	CUST.FULLNAME
     </cfquery>
     
     <cfquery name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="60">
		SELECT	UNITID, UNITNAME, UNITNAME || ' - ' || UNITID AS UNITLOOKUP
		FROM		UNITS
		ORDER BY	UNITNAME
	</cfquery>
     
     <cfquery name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          ORDER BY	FISCALYEAR_2DIGIT
     </cfquery>

	<cfquery name="ListProblemCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
		SELECT	CATEGORYID, CATEGORYLETTER, CATEGORYNAME, CATEGORYLETTER || ' ' || CATEGORYNAME AS CATEGORY
		FROM		PROBLEMCATEGORIES
		ORDER BY	CATEGORYLETTER
	</cfquery>

	<cfquery name="ListProblemSubCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	PROBLEMSUBCATEGORIES.SUBCATEGORYID, PROBLEMSUBCATEGORIES.SUBCATEGORYLETTERID, PROBLEMSUBCATEGORIES.SUBCATEGORYNAME,
				PROBLEMCATEGORIES.CATEGORYLETTER || ' ' || PROBLEMSUBCATEGORIES.SUBCATEGORYNAME AS SUBCAT
		FROM		PROBLEMSUBCATEGORIES, PROBLEMCATEGORIES
		WHERE	PROBLEMSUBCATEGORIES.SUBCATEGORYLETTERID = PROBLEMCATEGORIES.CATEGORYID
		ORDER BY	SUBCAT
	</cfquery>

     <cfquery name="ListBarcodeSR" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SREQUIPID, EQUIPMENTBARCODE, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE || ' - ' || SERVICEREQUESTNUMBER AS BARCODESR
		FROM		SREQUIPLOOKUP
          WHERE	SREQUIPID > 0 
		ORDER BY	BARCODESR
	</cfquery>
     
     <cfquery name="ListPriority" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
          SELECT	PRIORITYID, PRIORITYNAME
          FROM		PRIORITY
          ORDER BY	PRIORITYNAME
     </cfquery>
     
     <cfquery name="ListAssignees" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	DISTINCT WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(WGA.STAFFCUSTOMERID = CUST.CUSTOMERID) AND
          		(WORKGROUPASSIGNSID = 0 OR
          	<CFIF Client.CUSTOMERID EQ 501 or Client.CUSTOMERID EQ 162>
               	WGA.GROUPID IN (4,5,7,9,11,19) AND
               </CFIF>
          		WGA.ACTIVE = 'YES')
		ORDER BY	CUST.FULLNAME
	</cfquery>
  
     <cfquery name="ListWorkGroups" datasource="#application.type#SERVICEREQUESTS">
          SELECT	GROUPID, GROUPNAME
          FROM		GROUPASSIGNED
          ORDER BY	GROUPNAME
     </cfquery>

     <cfset PROCESSLOOKUP = "">

	<table width="100%" align="center" border="3">
		<tr align="center">
			<th align="center"><h1>Service Request - SR Review Selection Lookup</h1></th>
		</tr>
	</table>

	<table width="100%" align="center" border="0">
		<tr align="center">
			<th align="center">
				<h2>Select from the drop down boxes or type in partial values to choose report criteria. <br /> 
					Checking an adjacent checkbox will Negate the selection or data entered.<br>
                         You must enter information in at least one of the twenty-four (24) fields.
				</h2>
               </th>
		</tr>
	</table>
	<br />
	<table width="100%" align="LEFT">
		<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>
		</tr>
<cfform name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/srreviewreport.cfm?LOOKUPSR=FOUND" method="POST">
		<tr>
          	<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESERVICEREQUESTNUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SERVICEREQUESTNUMBER">SR</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEREQUESTERID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="REQUESTERID">Requester</label>
			</th>
          </tr>
          <tr>
          	<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATESERVICEREQUESTNUMBER" id="NEGATESERVICEREQUESTNUMBER" value="" align="LEFT" required="No" tabindex="2">
			</td>
			<td align="LEFT" width="45%">
				<cfinput type="Text" name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" value="#LookupCurrentFiscalYear.FISCALYEAR_2DIGIT#" align="LEFT" required="NO" size="9" maxlength="9" tabindex="3">
			</td>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATEREQUESTERID" id="NEGATEREQUESTERID" value="" align="LEFT" required="No" tabindex="4">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="5"></cfselect>
			</td>
		</tr>
          <tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
               <th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEUNITID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="UNITID">Unit Name</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEALTCONTACTID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="ALTCONTACTID">Alternate Contact</label>
			</th>
		</tr>
		<tr>
               <td align="LEFT" valign="TOP" width="5%">
				<cfinput type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" align="LEFT" required="No" tabindex="6">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<cfselect name="UNITID" id="UNITID" size="1" query="LookupUnits" value="UNITID" display="UNITLOOKUP" selected="0" required="No" tabindex="7"></cfselect><br>
                    <COM> NOT DISPLAYED IN REPORT </COM>
			</td>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATEALTCONTACTID" id="NEGATEALTCONTACTID" value="" align="LEFT" required="No" tabindex="8">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="ALTCONTACTID" id="ALTCONTACTID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="9"></cfselect><br>
                    <COM> NOT DISPLAYED IN REPORT </COM>
			</td>
		</tr>
          <tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
          <tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESRCOMPLETED">Negate</label><br>
				&nbsp;Value 
			</th>
               <th align="left" valign="BOTTOM" width="45%"><label for="SRCOMPLETED">SR Completed?</label></th>
               <th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEFISCALYEARID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="FISCALYEARID">Fiscal Year</label>
			</th>
		</tr>
          <tr>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATESRCOMPLETED" id="NEGATESRCOMPLETED" value="" align="LEFT" required="No" tabindex="10">
			</td>
               <td align="left" width="45%">
				<cfselect name="SRCOMPLETED" id="SRCOMPLETED" size="1" tabindex="11">
                    	<option value="Select Status">Select Status</option>
					<option value="NO">NO</option>
					<option value="YES">YES</option>
					<option value="VOIDED">VOIDED</option>
				</cfselect>
			</td>
               <td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATEFISCALYEARID" id="NEGATEFISCALYEARID" value="" align="LEFT" required="No" tabindex="12">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="FISCALYEARID" id="FISCALYEARID" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_2DIGIT" selected="0" tabindex="13"></cfselect>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATECATEGORYID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="CATEGORYID">Problem Category</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESUBCATEGORYID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SUBCATEGORYID">Sub-Category</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATECATEGORYID" id="NEGATECATEGORYID" value="" align="LEFT" required="No" tabindex="14">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="CATEGORYID" id="CATEGORYID" size="1" query="ListProblemCategories" value="CATEGORYID" display="CATEGORY" selected="0" required="No" tabindex="15"></cfselect>
			</td>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATESUBCATEGORYID" id="NEGATESUBCATEGORYID" value="" align="LEFT" required="No" tabindex="16">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="SUBCATEGORYID" id="SUBCATEGORYID" size="1" query="ListProblemSubCategories" value="SUBCATEGORYID" display="SUBCAT" selected="0" required="No" tabindex="17"></cfselect>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEPROBLEM_DESCRIPTION">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="PROBLEM_DESCRIPTION">Problem Description</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTAFF_COMMENTS">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="STAFF_COMMENTS">Staff Comments</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATEPROBLEM_DESCRIPTION" id="NEGATEPROBLEM_DESCRIPTION" value="" align="LEFT" required="No" tabindex="14">
			</td>
			<td align="LEFT" width="45%">
				<cfinput type="Text" name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" value="" align="LEFT" required="No" size="50" tabindex="15">
			</td>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATESTAFF_COMMENTS" id="NEGATESTAFF_COMMENTS" value="" align="LEFT" required="No" tabindex="16">
			</td>
			<td align="LEFT" width="45%">
				<cfinput type="Text" name="STAFF_COMMENTS" id="STAFF_COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="17">
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
          	<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEEQUIPMENTSR">Negate</label><br>
				&nbsp;Value 
			</th>
               <th align="left" valign="BOTTOM" width="45%">
               	<label for="EQUIPMENTSR">Select Barcode - SR</label>
               </th>
               <th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEBARCODETEXT">Negate</label><br>
				&nbsp;Value 
			</th>
               <th align="left" valign="BOTTOM" width="45%">
                    Or Enter <label for="BARCODETEXT">Barcode Number</label>
               </th>
		</tr>
          <tr>
              <td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATEEQUIPMENTSR" id="NEGATEEQUIPMENTSR" value="" align="LEFT" required="No" tabindex="18">
			</td>
			<td align="LEFT" width="45%">
               	<cfselect name="EQUIPMENTSR" id="EQUIPMENTSR" tabindex="19">
					<option value="0">BARCODE NUMBER</option>
					<cfloop query="ListBarcodeSR">
						<option value='#SERVICEREQUESTNUMBER#'>#BARCODESR#</option>
					</cfloop>
				</cfselect>
               <td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATEBARCODETEXT" id="NEGATEBARCODETEXT" value="" align="LEFT" required="No" tabindex="20">
			</td>
               <td align="LEFT" width="45%">
				<cfinput type="Text" name="BARCODETEXT" id="BARCODETEXT" value="3065000" align="LEFT" required="No" size="18" tabindex="21">
			</td>
		</tr>
          <tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr
		><tr>
          	<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATECREATIONDATE">Negate</label><br>
				&nbsp;Value 
			</th>
          	<th align="left" valign="BOTTOM" width="45%">
				<label for="CREATIONDATE">
                    Creation Date<br />
				&nbsp;Enter (1) a single Creation Date or<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    (2) a series of dates separated by commas,NO spaces or<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    (3) two dates separated by a semicolon for range.</label>
			</th>
               <th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESRCOMPLETEDDATE">Negate</label><br>
				&nbsp;Value 
			</th>
               <th align="left" valign="BOTTOM" width="45%">
				<label for="SRCOMPLETEDDATE">
                    SR Completed Date<br />
				&nbsp;Enter (1) a single SR Completed Date or<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    (2) a series of dates separated by commas,NO spaces or<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    (3) two dates separated by a semicolon for range.</label>
			</th>
		</tr>
          <tr>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATECREATIONDATE" id="NEGATECREATIONDATE" value="" align="LEFT" required="No" tabindex="22">
			</td>
			<td align="LEFT" width="45%">
				<cfinput type="Text" name="CREATIONDATE" id="CREATIONDATE" value="" required="No" size="50" tabindex="23">
			</td>
               <td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATESRCOMPLETEDDATE" id="NEGATESRCOMPLETEDDATE" value="" align="LEFT" required="No" tabindex="24">
			</td>
			<td align="LEFT" width="45%">
				<cfinput type="Text" name="SRCOMPLETEDDATE" id="SRCOMPLETEDDATE" value="" required="No" size="50" tabindex="25">
			</td>
		</tr>
          <tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
          
          <tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEPRIORITYID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="PRIORITYID">Priority</label>
			</th>
               <th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTAFF_ASSIGNMENT_ORDER">Negate</label><br>
				&nbsp;Value 
			</th>
               <th align="left" valign="BOTTOM" width="45%"><label for="STAFF_ASSIGNMENT_ORDER">Code</label></th>
		</tr>
           <tr>
			<td align="LEFT" width="5%" valign="TOP">
				<cfinput type="CheckBox" name="NEGATEPRIORITYID" id="NEGATEPRIORITYID" value="" align="LEFT" required="No" tabindex="26">
			</td>
			<td align="LEFT" width="45%" valign="TOP">
				<cfselect name="PRIORITYID" id="PRIORITYID" size="1" query="ListPriority" value="PRIORITYID" display="PRIORITYNAME" selected="0" required="No" tabindex="27"></cfselect>
			</td>
               <td align="LEFT" width="5%" valign="TOP">
				<cfinput type="CheckBox" name="NEGATESTAFF_ASSIGNMENT_ORDER" id="NEGATESTAFF_ASSIGNMENT_ORDER" value="" align="LEFT" required="No" tabindex="28">
			</td>
               <td align="left" width="45%" valign="TOP">
                    <cfselect name="STAFF_ASSIGNMENT_ORDER" id="STAFF_ASSIGNMENT_ORDER" size="1" tabindex="29">
                    	<option value="0">Select Code</option>
                         <option value="1">1</option>
                         <option value="2">2</option>
                         <option value="3">3</option>
                         <option value="4">4</option>
                         <option value="5">5</option>
                    </cfselect>
               </td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
          
          <tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEALLSRASSIGN">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
               	<label for="ALLSRASSIGN">All SRs Assignee</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEALLSRWORKGROUP">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="ALLSRWORKGROUP">All SRs Work Group</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATEALLSRASSIGN" id="NEGATEALLSRASSIGN" value="" align="LEFT" required="No" tabindex="30">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="ALLSRASSIGN" id="ALLSRASSIGN" size="1" query="ListAssignees" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="31"></cfselect>
			</td>
               <td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATEALLSRWORKGROUP" id="NEGATEALLSRWORKGROUP" value="" align="LEFT" required="No" tabindex="32">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="ALLSRWORKGROUP" id="ALLSRWORKGROUP" size="1" query="ListWorkGroups" value="GROUPID" display="GROUPNAME" selected="0" required="No" tabindex="33"></cfselect>
			</td>
		</tr>
          <tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
          <tr>
          	<th align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</th>
               <th align="left" valign="BOTTOM" width="45%"><label for="STAFF_ASSIGNED">STAFF ASSIGNED?</label></th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTAFF_COMPLETEDSR">Negate</label><br>
				&nbsp;Value 
			</th>
               <th align="left" valign="BOTTOM" width="45%"><label for="STAFF_COMPLETEDSR">Staff Completed SR?</label></th>
		</tr>
          <tr>
			<td align="LEFT" width="5%">&nbsp;&nbsp;</td>
               <td align="left" width="45%">
				<cfselect name="STAFF_ASSIGNED" id="STAFF_ASSIGNED" size="1" tabindex="33">
                    	<option value="Staff Assigned">Staff Assigned?</option>
					<option value="NO">NO</option>
					<option value="YES">YES</option>
				</cfselect>
			</td>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATESTAFF_COMPLETEDSR" id="NEGATESTAFF_COMPLETEDSR" value="" align="LEFT" required="No" tabindex="34">
			</td>
               <td align="left" width="45%">
				<cfselect name="STAFF_COMPLETEDSR" id="STAFF_COMPLETEDSR" size="1" tabindex="35">
                    	<option value="Select Status">Select Status</option>
					<option value="NO">NO</option>
					<option value="YES">YES</option>
					<option value="VOIDED">VOIDED</option>
				</cfselect>
			</td>
               <td align="left" colspan="2">&nbsp;&nbsp;</td>
		</tr>
          <tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEPRIMARYASSIGN">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
               	<label for="PRIMARYASSIGN">Primary Assignee</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEPRIMARYWORKGROUP">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="PRIMARYWORKGROUP">Primary Work Group</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATEPRIMARYASSIGN" id="NEGATEPRIMARYASSIGN" value="" align="LEFT" required="No" tabindex="36">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="PRIMARYASSIGN" id="PRIMARYASSIGN" size="1" query="ListAssignees" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="37"></cfselect>
			</td>
               <td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATEPRIMARYWORKGROUP" id="NEGATEPRIMARYWORKGROUP" value="" align="LEFT" required="No" tabindex="38">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="PRIMARYWORKGROUP" id="PRIMARYWORKGROUP" size="1" query="ListWorkGroups" value="GROUPID" display="GROUPNAME" selected="0" required="No" tabindex="39"></cfselect>
			</td>
		</tr>
          <tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATENEXTASSIGN">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
               	<label for="NEXTASSIGN">Next Assignee</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATENEXTWORKGROUP">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="NEXTWORKGROUP">Next Work Group</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATENEXTASSIGN" id="NEGATENEXTASSIGN" value="" align="LEFT" required="No" tabindex="40">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="NEXTASSIGN" id="NEXTASSIGN" size="1" query="ListAssignees" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="41"></cfselect>
			</td>
               <td align="LEFT" width="5%">
				<cfinput type="CheckBox" name="NEGATENEXTWORKGROUP" id="NEGATENEXTWORKGROUP" value="" align="LEFT" required="No" tabindex="42">
			</td>
			<td align="LEFT" width="45%">
				<cfselect name="NEXTWORKGROUP" id="NEXTWORKGROUP" size="1" query="ListWorkGroups" value="GROUPID" display="GROUPNAME" selected="0" required="No" tabindex="43"></cfselect>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4"><hr align="left" width="100%" size="5" noshade /></td>
		</tr>
		<tr>
			<th colspan="4"><h2>You must enter information in at least one of the twenty-three (23) fields!</h2></th>
		</tr>
     	<tr>
			<td align="LEFT" colspan="4">
               	
				<input type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" onClick="return setMatchAny();" tabindex="44" />
			</td>
		</tr>
		<tr>
			<td align="LEFT" colspan="4">
               	<input type="hidden" name="PROCESSLOOKUP" value="Match All Fields Entered" />
				<input type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" tabindex="45" />
			</td>
		</tr>
</cfform>
		<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="46" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>
		</tr>
		<tr>
			<td align="LEFT" colspan="4"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
     
     <cfexit>

<cfelse>

<!--- 
************************************************************************************
* The following code is the Service Request - SR Review Report Generation Process. *
************************************************************************************
 --->
 
	<cfset SESSION.GROUPNAME = "">
 	<cfif #LEN(FORM.BARCODETEXT)# GT 7>
     
          <cfquery name="LookupBarcodeSR" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SREQUIPID, EQUIPMENTBARCODE, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE || ' - ' || SERVICEREQUESTNUMBER AS BARCODESR
               FROM		SREQUIPLOOKUP
               WHERE	EQUIPMENTBARCODE = <CFQUERYPARAM value="#FORM.BARCODETEXT#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	BARCODESR
          </cfquery>
		<br>SR Numbers are #QuotedValueList(LookupBarcodeSR.SERVICEREQUESTNUMBER)#<br><br>
	</cfif>

	<cfif "#FORM.CREATIONDATE#" NEQ ''>
		<cfset CREATIONDATELIST = "NO">
		<cfset CREATIONDATERANGE = "NO">
		<cfif FIND(',', #FORM.CREATIONDATE#, 1) EQ 0 AND FIND(';', #FORM.CREATIONDATE#, 1) EQ 0>
			<cfset FORM.CREATIONDATE = DateFormat(FORM.CREATIONDATE, 'mm/dd/yyyy')>
		<cfelse>
			<cfif FIND(',', #FORM.CREATIONDATE#, 1) NEQ 0>
				<cfset CREATIONDATELIST = "YES">
			<cfelseif FIND(';', #FORM.CREATIONDATE#, 1) NEQ 0>
				<cfset CREATIONDATERANGE = "YES">
				<cfset FORM.CREATIONDATE = #REPLACE(FORM.CREATIONDATE, ";", ",")#>
			</cfif>
			<cfset CREATIONDATEARRAY = ListToArray(FORM.CREATIONDATE)>
			<cfloop index="Counter" from=1 to=#ArrayLen(CREATIONDATEARRAY)# >
				<!--- CREATION DATE FIELD = #CREATIONDATEARRAY[COUNTER]#<BR /><BR /> --->
			</cfloop>
		</cfif>
		<cfif CREATIONDATERANGE EQ "YES">
			<cfset BEGINCREATIONDATE = DateFormat(#CREATIONDATEARRAY[1]#, 'mm/dd/yyyy')>
			<cfset ENDCREATIONDATE = DateFormat(#CREATIONDATEARRAY[2]#, 'mm/dd/yyyy')>
		</cfif>
		<!--- CREATION DATE LIST = #CREATIONDATELIST#<BR /><BR /> --->
		<!--- CREATION DATE RANGE = #CREATIONDATERANGE#<BR /><BR /> --->
	</cfif>
     
     <cfif "#FORM.SRCOMPLETEDDATE#" NEQ ''>
		<cfset SRCOMPLETEDDATELIST = "NO">
		<cfset SRCOMPLETEDDATERANGE = "NO">
		<cfif FIND(',', #FORM.SRCOMPLETEDDATE#, 1) EQ 0 AND FIND(';', #FORM.SRCOMPLETEDDATE#, 1) EQ 0>
			<cfset FORM.SRCOMPLETEDDATE = DateFormat(FORM.SRCOMPLETEDDATE, 'mm/dd/yyyy')>
		<cfelse>
			<cfif FIND(',', #FORM.SRCOMPLETEDDATE#, 1) NEQ 0>
				<cfset SRCOMPLETEDDATELIST = "YES">
			<cfelseif FIND(';', #FORM.SRCOMPLETEDDATE#, 1) NEQ 0>
				<cfset SRCOMPLETEDDATERANGE = "YES">
				<cfset FORM.SRCOMPLETEDDATE = #REPLACE(FORM.SRCOMPLETEDDATE, ";", ",")#>
			</cfif>
			<cfset SRCOMPLETEDDATEARRAY = ListToArray(FORM.SRCOMPLETEDDATE)>
			<cfloop index="Counter" from=1 to=#ArrayLen(SRCOMPLETEDDATEARRAY)# >
				<!--- SR COMPLETED DATE FIELD = #SRCOMPLETEDDATEARRAY[COUNTER]#<BR /><BR /> --->
			</cfloop>
		</cfif>
		<cfif SRCOMPLETEDDATERANGE EQ "YES">
			<cfset BEGINSRCOMPLETEDDATE = DateFormat(#SRCOMPLETEDDATEARRAY[1]#, 'mm/dd/yyyy')>
			<cfset ENDSRCOMPLETEDDATE = DateFormat(#SRCOMPLETEDDATEARRAY[2]#, 'mm/dd/yyyy')>
		</cfif>
		<!--- SR COMPLETED DATE LIST = #SRCOMPLETEDDATELIST#<BR /><BR /> --->
		<!--- SR COMPLETED DATE RANGE = #SRCOMPLETEDDATERANGE#<BR /><BR /> --->
	</cfif>
     
     <cfif #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<cfset LOGICANDOR = "OR">
		<cfset FINALTEST = "=">
	<cfelseif #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<cfset LOGICANDOR = "AND">
		<cfset FINALTEST = ">">
	</cfif> 

     <cfif #FORM.STAFF_ASSIGNMENT_ORDER# GT 0 OR #FORM.ALLSRASSIGN# GT 0 OR #FORM.STAFF_COMMENTS# NEQ "" OR #FORM.ALLSRWORKGROUP# GT 0 OR FORM.STAFF_COMPLETEDSR NEQ "Select Status" OR #FORM.PRIMARYASSIGN# GT 0 OR #FORM.NEXTASSIGN# GT 0 OR #FORM.NEXTWORKGROUP# GT 0>
	
          <cfquery name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID AS STAFFSRID, SR.SRID, SR.SERVICEREQUESTNUMBER, SR.PRIORITYID, 
               		SRSA.STAFF_ASSIGNEDID, SR.GROUPASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, SRSA.STAFF_COMMENTS,
                         SRSA.NEXT_ASSIGNMENT_GROUPID, WGA.GROUPID, GA.GROUPNAME,  WGA.STAFFCUSTOMERID, CUST.FULLNAME,
                         SRSA.STAFF_COMPLETEDSR, SRSA.STAFF_ASSIGNMENT_ORDER
               FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	(SRSA.SRSTAFF_ASSIGNID > 0 AND
                         SRSA.SRID = SR.SRID AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         WGA.GROUPID = GA.GROUPID AND
                         WGA.STAFFCUSTOMERID = CUST.CUSTOMERID) AND (
                         
                    <CFIF #FORM.PRIORITYID# GT 0 AND #FORM.STAFF_ASSIGNMENT_ORDER# GT 0>
                         (SR.PRIORITYID = #val(FORM.PRIORITYID)# AND
                         SRSA.STAFF_ASSIGNMENT_ORDER = #val(FORM.STAFF_ASSIGNMENT_ORDER)#) #LOGICANDOR#
                    </CFIF>
                    
                    <CFIF #FORM.ALLSRASSIGN# GT 0>
                         WGA.STAFFCUSTOMERID = #val(FORM.ALLSRASSIGN)# #LOGICANDOR#
                    </CFIF>

				<CFIF #FORM.STAFF_COMMENTS# NEQ "">
                         <CFIF IsDefined('FORM.NEGATESTAFF_COMMENTS')>
                              NOT SRSA.STAFF_COMMENTS LIKE UPPER('%#FORM.STAFF_COMMENTS#%') #LOGICANDOR#
                         <CFELSE>
                              SRSA.STAFF_COMMENTS LIKE UPPER('%#FORM.STAFF_COMMENTS#%') #LOGICANDOR#
                         </CFIF>
                    </CFIF>

                    <CFIF #FORM.ALLSRWORKGROUP# GT 0>
                         (SR.GROUPASSIGNEDID = #val(FORM.ALLSRWORKGROUP)# OR
                         SRSA.NEXT_ASSIGNMENT_GROUPID = #val(FORM.ALLSRWORKGROUP)#) #LOGICANDOR#
                    </CFIF>
                    
                    <CFIF FORM.STAFF_COMPLETEDSR NEQ "Select Status">
                         SRSA.STAFF_COMPLETEDSR = '#FORM.STAFF_COMPLETEDSR#' #LOGICANDOR#
                    </CFIF>
                    
                    <CFIF #FORM.PRIMARYASSIGN# GT 0>
                         (SRSA.NEXT_ASSIGNMENT_GROUPID = 0 AND
                         WGA.STAFFCUSTOMERID = #val(FORM.PRIMARYASSIGN)#) #LOGICANDOR#
                    </CFIF>
     
                    <CFIF #FORM.NEXTASSIGN# GT 0>
                         (SRSA.NEXT_ASSIGNMENT_GROUPID > 0 AND
                         WGA.STAFFCUSTOMERID = #val(FORM.NEXTASSIGN)#) #LOGICANDOR#
                    </CFIF>
     
                    <CFIF #FORM.NEXTWORKGROUP# GT 0>
                         SRSA.NEXT_ASSIGNMENT_GROUPID = #val(FORM.NEXTWORKGROUP)# #LOGICANDOR#
                    </CFIF>
      
                         SRSA.SRID #FINALTEST# 0)
          <CFIF IsDefined('FORM.ALLSRWORKGROUP') AND #FORM.ALLSRWORKGROUP# GT 0>
          	ORDER BY	SERVICEREQUESTNUMBER DESC
          <CFELSE> 
               ORDER BY	SRSA.NEXT_ASSIGNMENT_GROUPID, SERVICEREQUESTNUMBER DESC 
          </CFIF>
          </cfquery>
          
     </cfif>
     
     <cfif IsDefined('LookupSRStaffAssignments.RecordCount')>
		<cfif #LookupSRStaffAssignments.RecordCount# GT 1000>
			<script language="JavaScript">
               	<!-- 
                    	alert("More than 1000 Staff Assignment Records meeting the selected criteria were found.  Please add additional search critera.");
               	--> 
          	</script>
          	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srreviewreport.cfm" />
          	<cfexit>
		<cfelseif #LookupSRStaffAssignments.RecordCount# EQ 0>
          	
      		<script language="JavaScript">
               	<!-- 
                    	alert("Staff Assignment Records meeting your selection criteria were Not Found  Please add additional search critera.");
               	--> 
          	</script>
          	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srreviewreport.cfm" />
          	<cfexit>
		</cfif>
     </cfif>

	<cfquery name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.GROUPASSIGNEDID, IDTGROUP.GROUPNAME, 
				SR.REQUESTERID, REQCUST.FULLNAME AS REQNAME, REQCUST.UNITID, SR.ALTERNATE_CONTACTID, SR.PRIORITYID, P.PRIORITYNAME,
				SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY,
				PROBSUBCAT.SUBCATEGORYNAME, SR.PROBLEM_DESCRIPTION, SR.ASSIGN_PRIORITY, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED,
				SR.PG_STAFFASSIGNEDCOUNT, SR.NG_STAFFASSIGNEDCOUNT
		FROM		SERVICEREQUESTS SR, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, GROUPASSIGNED IDTGROUP,
				LIBSHAREDDATAMGR.CUSTOMERS REQCUST, PRIORITY P
		WHERE	(SR.SRID > 0 AND
				SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
				SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
				SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
				SR.REQUESTERID = REQCUST.CUSTOMERID AND
				SR.PRIORITYID = P.PRIORITYID) AND (

          <CFIF FORM.SERVICEREQUESTNUMBER NEQ "#LookupCurrentFiscalYear.FISCALYEAR_2DIGIT#">
			<CFIF IsDefined('FORM.NEGATESERVICEREQUEST')>
				NOT SR.SERVICEREQUESTNUMBER = '#FORM.SERVICEREQUESTNUMBER#' #LOGICANDOR#
			<CFELSE>
				SR.SERVICEREQUESTNUMBER = '#FORM.SERVICEREQUESTNUMBER#' #LOGICANDOR#
			</CFIF>
		</CFIF>
               
		<CFIF FORM.REQUESTERID GT 0>
               <CFIF IsDefined('FORM.NEGATEREQUESTERID')>
                    NOT SR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
               <CFELSE>
                    SR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
               </CFIF>
		</CFIF>
          
          <CFIF #FORM.UNITID# GT 0>
			<CFIF IsDefined("FORM.NEGATEUNITID")>
				NOT REQCUST.UNITID = #val(FORM.UNITID)# #LOGICANDOR#
			<CFELSE>
				REQCUST.UNITID = #val(FORM.UNITID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
          
          <CFIF FORM.ALTCONTACTID GT 0>
               <CFIF IsDefined('FORM.NEGATEALTCONTACTID')>
                    NOT SR.ALTERNATE_CONTACTID = #val(FORM.ALTCONTACTID)# #LOGICANDOR#
               <CFELSE>
                    SR.ALTERNATE_CONTACTID = #val(FORM.ALTCONTACTID)# #LOGICANDOR#
               </CFIF>
		</CFIF>
          
		<CFIF FORM.SRCOMPLETED NEQ "Select Status">
          	<CFIF IsDefined('FORM.NEGATESRCOMPLETED')>
                    NOT SR.SRCOMPLETED = '#FORM.SRCOMPLETED#' #LOGICANDOR#
               <CFELSE>
                    SR.SRCOMPLETED = '#FORM.SRCOMPLETED#' #LOGICANDOR#
               </CFIF>
          </CFIF>
               
		<CFIF #FORM.FISCALYEARID# GT 0>
               <CFIF IsDefined("FORM.NEGATEFISCALYEARID")>
                    NOT SR.FISCALYEARID = #val(FORM.FISCALYEARID)# #LOGICANDOR#
               <CFELSE>
                    SR.FISCALYEARID = #val(FORM.FISCALYEARID)# #LOGICANDOR#
               </CFIF>
          </CFIF>    

		<CFIF #FORM.CATEGORYID# GT "0">
			<CFIF IsDefined('FORM.NEGATECATEGORYID')>
				NOT SR.PROBLEM_CATEGORYID = #val(FORM.CATEGORYID)# #LOGICANDOR#
			<CFELSE>
				SR.PROBLEM_CATEGORYID = #val(FORM.CATEGORYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SUBCATEGORYID# GT "0">
			<CFIF IsDefined('FORM.NEGATESUBCATEGORYID')>
				NOT SR.PROBLEM_SUBCATEGORYID = #val(FORM.SUBCATEGORYID)# #LOGICANDOR#
			<CFELSE>
				SR.PROBLEM_SUBCATEGORYID = #val(FORM.SUBCATEGORYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.PROBLEM_DESCRIPTION# NEQ "">
			<CFIF IsDefined('FORM.NEGATEPROBLEM_DESCRIPTION')>
				NOT SR.PROBLEM_DESCRIPTION LIKE UPPER('%#FORM.PROBLEM_DESCRIPTION#%') #LOGICANDOR#
			<CFELSE>
				SR.PROBLEM_DESCRIPTION LIKE UPPER('%#FORM.PROBLEM_DESCRIPTION#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

          <CFIF FORM.EQUIPMENTSR GT "0">
               <CFIF IsDefined('FORM.NEGATEEQUIPMENTSR')>
                    NOT SR.SERVICEREQUESTNUMBER = '#FORM.EQUIPMENTSR#' #LOGICANDOR#
               <CFELSE>
                    SR.SERVICEREQUESTNUMBER = '#FORM.EQUIPMENTSR#' #LOGICANDOR#
               </CFIF>
		</CFIF>
       
          <CFIF IsDefined('LookupBarcodeSR.RecordCount') AND #LookupBarcodeSR.RecordCount# GT 0>
               <CFIF IsDefined('FORM.NEGATEBARCODETEXT')>
                    NOT SR.SERVICEREQUESTNUMBER IN (#QuotedValueList(LookupBarcodeSR.SERVICEREQUESTNUMBER)#) #LOGICANDOR#
               <CFELSE>
                    SR.SERVICEREQUESTNUMBER IN (#QuotedValueList(LookupBarcodeSR.SERVICEREQUESTNUMBER)#) #LOGICANDOR#
               </CFIF>
		</CFIF>
               
		<CFIF FORM.CREATIONDATE NEQ "">
               <CFIF IsDefined('FORM.NEGATECREATIONDATE')>
                    <CFIF CREATIONDATELIST EQ "YES">
                         <CFLOOP index="Counter" from=1 to=#ArrayLen(CREATIONDATEARRAY)#>
                              <CFSET FORMATCREATIONDATE =  DateFormat(#CREATIONDATEARRAY[COUNTER]#, 'mm/dd/yyyy')>
                              NOT SR.CREATIONDATE = TO_DATE('#FORMATCREATIONDATE#', 'MM/DD/YYYY') AND
                         </CFLOOP>
                         <CFSET FINALTEST = ">">
                    <CFELSEIF CREATIONDATERANGE EQ "YES">
                         NOT (SR.CREATIONDATE BETWEEN TO_DATE('#BEGINCREATIONDATE#', 'MM/DD/YYYY') AND TO_DATE('#ENDCREATIONDATE#', 'MM/DD/YYYY')) #LOGICANDOR#
                    <CFELSE>
                         NOT SR.CREATIONDATE LIKE TO_DATE('#FORM.CREATIONDATE#', 'MM/DD/YYYY') #LOGICANDOR#
                    </CFIF>
               <CFELSE>
                    <CFIF CREATIONDATELIST EQ "YES">
                         <CFSET ARRAYCOUNT = (ArrayLen(CREATIONDATEARRAY) - 1)>
                         (
                         <CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
                              <CFSET FORMATCREATIONDATE = DateFormat(#CREATIONDATEARRAY[COUNTER]#, 'mm/dd/yyyy')>
                              SR.CREATIONDATE = TO_DATE('#FORMATCREATIONDATE#', 'MM/DD/YYYY') OR
                         </CFLOOP>
                         <CFSET FORMATCREATIONDATE = DateFormat(#CREATIONDATEARRAY[ArrayLen(CREATIONDATEARRAY)]#, 'mm/dd/yyyy')>
                         SR.CREATIONDATE = TO_DATE('#FORMATCREATIONDATE#', 'MM/DD/YYYY')) #LOGICANDOR#
                    <CFELSEIF CREATIONDATERANGE EQ "YES">
                              (SR.CREATIONDATE BETWEEN TO_DATE('#BEGINCREATIONDATE#', 'MM/DD/YYYY') AND TO_DATE('#ENDCREATIONDATE#', 'MM/DD/YYYY')) #LOGICANDOR#
                    <CFELSE>
                         SR.CREATIONDATE LIKE TO_DATE('#FORM.CREATIONDATE#', 'MM/DD/YYYY') #LOGICANDOR#
                    </CFIF>
               </CFIF>
          </CFIF>
         
          <CFIF FORM.SRCOMPLETEDDATE NEQ "">
               <CFIF IsDefined('FORM.NEGATESRCOMPLETEDDATE')>
                    <CFIF SRCOMPLETEDDATELIST EQ "YES">
                         <CFLOOP index="Counter" from=1 to=#ArrayLen(SRCOMPLETEDDATEARRAY)#>
                              <CFSET FORMATSRCOMPLETEDDATE =  DateFormat(#SRCOMPLETEDDATEARRAY[COUNTER]#, 'mm/dd/yyyy')>
                              NOT SR.SRCOMPLETEDDATE = TO_DATE('#FORMATSRCOMPLETEDDATE#', 'MM/DD/YYYY') AND
                         </CFLOOP>
                         <CFSET FINALTEST = ">">
                    <CFELSEIF SRCOMPLETEDDATERANGE EQ "YES">
                         NOT (SR.SRCOMPLETEDDATE BETWEEN TO_DATE('#BEGINSRCOMPLETEDDATE#', 'MM/DD/YYYY') AND TO_DATE('#ENDSRCOMPLETEDDATE#', 'MM/DD/YYYY')) #LOGICANDOR#
                    <CFELSE>
                         NOT SR.SRCOMPLETEDDATE LIKE TO_DATE('#FORM.SRCOMPLETEDDATE#', 'MM/DD/YYYY') #LOGICANDOR#
                    </CFIF>
               <CFELSE>
                    <CFIF SRCOMPLETEDDATELIST EQ "YES">
                         <CFSET ARRAYCOUNT = (ArrayLen(SRCOMPLETEDDATEARRAY) - 1)>
                         (
                         <CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
                              <CFSET FORMATSRCOMPLETEDDATE = DateFormat(#SRCOMPLETEDDATEARRAY[COUNTER]#, 'mm/dd/yyyy')>
                              SR.SRCOMPLETEDDATE = TO_DATE('#FORMATSRCOMPLETEDDATE#', 'MM/DD/YYYY') OR
                         </CFLOOP>
                         <CFSET FORMATSRCOMPLETEDDATE = DateFormat(#SRCOMPLETEDDATEARRAY[ArrayLen(SRCOMPLETEDDATEARRAY)]#, 'mm/dd/yyyy')>
                         SR.SRCOMPLETEDDATE = TO_DATE('#FORMATSRCOMPLETEDDATE#', 'MM/DD/YYYY')) #LOGICANDOR#
                    <CFELSEIF SRCOMPLETEDDATERANGE EQ "YES">
                              (SR.SRCOMPLETEDDATE BETWEEN TO_DATE('#BEGINSRCOMPLETEDDATE#', 'MM/DD/YYYY') AND TO_DATE('#ENDSRCOMPLETEDDATE#', 'MM/DD/YYYY')) #LOGICANDOR#
                    <CFELSE>
                         SR.SRCOMPLETEDDATE LIKE TO_DATE('#FORM.SRCOMPLETEDDATE#', 'MM/DD/YYYY') #LOGICANDOR#
                    </CFIF>
               </CFIF>
          </CFIF>
         
		<CFIF FORM.PRIORITYID GT 0>
               <CFIF IsDefined('FORM.NEGATEPRIORITYID')>
                    NOT SR.PRIORITYID = #val(FORM.PRIORITYID)# #LOGICANDOR#
               <CFELSE>
                    SR.PRIORITYID = #val(FORM.PRIORITYID)# #LOGICANDOR#
               </CFIF>
          </CFIF>
          
          <CFIF FORM.STAFF_ASSIGNMENT_ORDER GT 0>
               <CFIF IsDefined('FORM.NEGATESTAFF_ASSIGNMENT_ORDER')>
                    NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               <CFELSE>
                    SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               </CFIF>
		</CFIF>
          
          <CFIF FORM.ALLSRASSIGN GT 0>
               <CFIF IsDefined('FORM.NEGATEALLSRASSIGN')>
                    NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               <CFELSE>
                    SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF #FORM.STAFF_COMMENTS# NEQ "">
               <CFIF IsDefined('FORM.NEGATESTAFF_COMMENTS')>
                    NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               <CFELSE>
                    SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>
          
          <CFIF FORM.ALLSRWORKGROUP GT 0>
               <CFIF IsDefined('FORM.NEGATEALLSRWORKGROUP')>
                    NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               <CFELSE>
                    SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>
          
		<CFIF FORM.STAFF_ASSIGNED NEQ "Staff Assigned">
          	<CFIF FORM.STAFF_ASSIGNED EQ "NO">
                    (SR.PG_STAFFASSIGNEDCOUNT = 0 AND SR.NG_STAFFASSIGNEDCOUNT = 0) #LOGICANDOR#
               <CFELSE>
                    (SR.PG_STAFFASSIGNEDCOUNT > 0 OR  SR.NG_STAFFASSIGNEDCOUNT > 0) #LOGICANDOR#
               </CFIF>
          </CFIF>

		<CFIF FORM.STAFF_COMPLETEDSR NEQ "Select Status">
          	<CFIF IsDefined('FORM.NEGATESTAFF_COMPLETEDSR')>
                    NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               <CFELSE>
                    SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>
          
          <CFIF FORM.PRIMARYASSIGN GT 0>
               <CFIF IsDefined('FORM.NEGATEPRIMARYASSIGN')>
                    NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               <CFELSE>
                    SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF FORM.PRIMARYWORKGROUP GT 0>
               <CFIF IsDefined('FORM.NEGATEPRIMARYWORKGROUP')>
               	<CFIF #FORM.PRIMARYWORKGROUP# EQ 7 OR #FORM.PRIMARYWORKGROUP# EQ 19>
                    	NOT SR.GROUPASSIGNEDID IN (7,19) #LOGICANDOR#
                    <CFELSE>
                    	NOT SR.GROUPASSIGNEDID = #val(FORM.PRIMARYWORKGROUP)# #LOGICANDOR#
                    </CFIF>
               <CFELSE>
               	<CFIF #FORM.PRIMARYWORKGROUP# EQ 7 OR #FORM.PRIMARYWORKGROUP# EQ 19>
                    	SR.GROUPASSIGNEDID IN (7,19) #LOGICANDOR#
                    <CFELSE>
                    	SR.GROUPASSIGNEDID = #val(FORM.PRIMARYWORKGROUP)# #LOGICANDOR#
                    </CFIF>
               </CFIF>
          </CFIF>
          
           <CFIF FORM.NEXTASSIGN GT 0>
               <CFIF IsDefined('FORM.NEGATENEXTASSIGN')>
                    NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               <CFELSE>
                    SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF FORM.NEXTWORKGROUP GT 0>
               <CFIF IsDefined('FORM.NEGATENEXTWORKGROUP')>
                    NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               <CFELSE>
                    SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>

                    SR.SRID #FINALTEST# 0)
     <CFIF #FORM.ALLSRWORKGROUP# GT 0 OR #FORM.PRIMARYWORKGROUP# GT 0 OR #FORM.NEXTWORKGROUP# GT 0>
     	ORDER BY	SR.PRIORITYID, SR.SERVICEREQUESTNUMBER DESC
     <CFELSE>
		ORDER BY	IDTGROUP.GROUPNAME, SR.PRIORITYID, SR.SERVICEREQUESTNUMBER DESC 
     </CFIF>
	</cfquery>

	<cfif LookupServiceRequests.RecordCount EQ 0>
		<script language="JavaScript">
               <!-- 
                    alert("Service Request Records meeting your selection criteria were Not Found");
               --> 
          </script>
          <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srreviewreport.cfm" />
          <cfexit>
	</cfif>
     	
     
<!--- 
***********************************************************************
* The following code displays the Service Request - SR Review Report. *
***********************************************************************
 --->
 
 	<cfif IsDefined('FORM.ALLSRWORKGROUP') AND #FORM.ALLSRWORKGROUP# GT 0>
 
          <cfquery name="LookupAllSRWorkGroup" datasource="#application.type#SERVICEREQUESTS">
               SELECT	GROUPID, GROUPNAME
               FROM		GROUPASSIGNED
               WHERE	GROUPID = <CFQUERYPARAM value="#FORM.ALLSRWORKGROUP#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	GROUPNAME
          </cfquery>
          
          <cfset SESSION.GROUPNAME = #LookupAllSRWorkGroup.GROUPNAME#>
 
 	<cfelseif IsDefined('FORM.PRIMARYWORKGROUP') AND #FORM.PRIMARYWORKGROUP# GT 0>

          <cfquery name="LookupPrimaryWorkGroup" datasource="#application.type#SERVICEREQUESTS">
               SELECT	GROUPID, GROUPNAME
               FROM		GROUPASSIGNED
               WHERE	GROUPID = <CFQUERYPARAM value="#FORM.PRIMARYWORKGROUP#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	GROUPNAME
          </cfquery>
          
          <cfset SESSION.GROUPNAME = #LookupPrimaryWorkGroup.GROUPNAME#>
     
     <cfelseif IsDefined('FORM.NEXTWORKGROUP') AND #FORM.NEXTWORKGROUP# GT 0>
     
          <cfquery name="LookupNextWorkGroup" datasource="#application.type#SERVICEREQUESTS">
               SELECT	GROUPID, GROUPNAME
               FROM		GROUPASSIGNED
               WHERE	GROUPID = <CFQUERYPARAM value="#FORM.NEXTWORKGROUP#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	GROUPNAME
          </cfquery>
          
          <cfset SESSION.GROUPNAME = #LookupNextWorkGroup.GROUPNAME#>

     <cfelse>
     
     	<cfquery name="LookupSRWorkGroup" datasource="#application.type#SERVICEREQUESTS">
               SELECT	GROUPID, GROUPNAME
               FROM		GROUPASSIGNED
               WHERE	GROUPID = <CFQUERYPARAM value="#LookupServiceRequests.GROUPASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	GROUPNAME
          </cfquery>
          
          <cfset SESSION.GROUPNAME = #LookupSRWorkGroup.GROUPNAME#>
     
     </cfif>
     
 	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center">
               	<h1>Service Request - SR Review Report</h1>
               <cfif IsDefined('FORM.ALLSRWORKGROUP') AND #FORM.ALLSRWORKGROUP# GT 0>
               	<h2>For Workgroup: #LookupALLSRWorkGroup.GROUPNAME#</h2>
               <cfelseif IsDefined('FORM.PRIMARYWORKGROUP') AND #FORM.PRIMARYWORKGROUP# GT 0>
               	<cfif FORM.PRIMARYWORKGROUP EQ 7 OR FORM.PRIMARYWORKGROUP EQ 19>
					<h2>For Workgroups: ES/AA and ES/LIB </h2>
                    <cfelse>
               		<h2>For Workgroup: #LookupPrimaryWorkGroup.GROUPNAME#</h2>
                    </cfif>
               <cfelseif IsDefined('FORM.NEXTWORKGROUP') AND #FORM.NEXTWORKGROUP# GT 0>
               	<h2>For Workgroup: #LookupNextWorkGroup.GROUPNAME#</h2>
               </cfif>
               </td>
		</tr> 
	</table>
<br />
	<table width="100%" align="center" border="0">
		<tr>
<cfform action="/#application.type#apps/servicerequests/srreviewreport.cfm" method="POST">
			<td align="left"><input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br></td>
</cfform>
		</tr>

		<tr>
			<th align="CENTER"><h2>#LookupServiceRequests.RecordCount# Service Request records were selected.</h2></th>
		</tr>
          
          <cfset GROUPNAMECHANGE = "">
          <cfset PRIORITYNAMECHANGE = "">
	</table>
<cfloop query="LookupServiceRequests">
	<table width="100%" align="left" border="0">
	<cfif (GROUPNAMECHANGE NEQ "#LookupServiceRequests.GROUPNAME#" AND GROUPNAMECHANGE NEQ "#SESSION.GROUPNAME#") OR (PRIORITYNAMECHANGE NEQ "#LookupServiceRequests.PRIORITYNAME#")>
     	<tr>
			<td align="left" valign="TOP" colspan="5"><hr></td>
		</tr>
		<tr>
			<th align="LEFT" colspan="5">
               <cfif #FORM.ALLSRWORKGROUP# EQ 0 AND #FORM.PRIMARYWORKGROUP# EQ 0 AND #FORM.NEXTWORKGROUP# EQ 0>
				<h2>Group - #LookupServiceRequests.GROUPNAME#</h2><br>
               	<cfset GROUPNAMECHANGE = "#LookupServiceRequests.GROUPNAME#">
               <cfelse>
               	<cfset GROUPNAMECHANGE = "#SESSION.GROUPNAME#">
			</cfif>
               	<h2>Priority - #LookupServiceRequests.PRIORITYNAME#</h2>
                    <cfset PRIORITYNAMECHANGE = "#LookupServiceRequests.PRIORITYNAME#">
               </th>
		</tr>  
		
     </cfif>
		<tr>     
			<th align="LEFT" valign="BOTTOM" width="20%">SR</th>
			<th align="LEFT" valign="BOTTOM" width="20%">Requester</th>
			<th align="LEFT" valign="BOTTOM" width="20%">BarCode</th>
			<th align="LEFT" valign="BOTTOM" width="20%">Entered</th>
			<th align="LEFT" valign="BOTTOM" width="20%">Completed? - Date</th>
		</tr>
	
		<cfquery name="LookupSREquipBarcode" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
				SELECT	SREL.SREQUIPID, SREL.SERVICEREQUESTNUMBER, SREL.EQUIPMENTBARCODE, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE
				FROM		SREQUIPLOOKUP SREL, HARDWMGR.HARDWAREINVENTORY HI, HARDWMGR.EQUIPMENTTYPE EQT
				WHERE	SREL.SERVICEREQUESTNUMBER = '#LookupServiceRequests.SERVICEREQUESTNUMBER#' AND
						SREL.EQUIPMENTBARCODE = HI.BARCODENUMBER AND
						HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID
		</cfquery>
	
		<tr>
			<td align="LEFT" valign="TOP" width="20%">#LookupServiceRequests.SERVICEREQUESTNUMBER#</td>
               <td align="LEFT" valign="TOP" width="20%">#LookupServiceRequests.REQNAME#</td>
		<cfif LookupSREquipBarcode.RecordCount GT 0>
			<td align="LEFT" valign="TOP" width="20%"><div>#LookupSREquipBarcode.EQUIPMENTBARCODE#</div></td>
		<cfelse>
			<td align="LEFT" valign="TOP" width="20%"><div>&nbsp;&nbsp;</div></td>
		</cfif>
			<td align="LEFT" valign="TOP" width="20%"><div>#DateFormat(LookupServiceRequests.CREATIONDATE, 'MM/DD/YYYY')#</div></td>
			<td align="LEFT" valign="TOP" width="20%">
               	<div>
               		#LookupServiceRequests.SRCOMPLETED#
                    <cfif LookupServiceRequests.SRCOMPLETED EQ "YES">
                    	 - #DateFormat(LookupServiceRequests.SRCOMPLETEDDATE, 'MM/DD/YYYY')#
                    </cfif>
                    </div>
               </td>
		</tr>
	</table>
     <br>
     <table width="100%" align="left" border="0">
          <tr>
			<th align="LEFT" valign="TOP" nowrap width="12%">Problem Description:</th>
			<td align="LEFT" valign="TOP" colspan="4" width="88%"><div>#LookupServiceRequests.PROBLEM_DESCRIPTION#</div></td>
		</tr>
          <tr>
			<th align="LEFT" valign="TOP" nowrap width="12%">Assign-P:</th>
			<td align="LEFT" valign="TOP" width="8%"><div>#LookupServiceRequests.ASSIGN_PRIORITY#</div></td>
		<cfif LookupSREquipBarcode.RecordCount GT 0>
               <th align="LEFT" valign="TOP" nowrap width="20%">Equip Type:</th>
			<td align="LEFT" valign="TOP" width="20%"><div>#LookupSREquipBarcode.EQUIPMENTTYPE#</div></td>
		<cfelse>
			<td align="LEFT" valign="TOP" width="40%"><div>&nbsp;&nbsp;</div></td>
		</cfif>
			<th align="left" valign="TOP" width="20%">Problem Cat/Sub-Cat:</th>
			<td align="left" valign="TOP" width="20%">#LookupServiceRequests.PROBCATEGORY# - #LookupServiceRequests.SUBCATEGORYNAME#</td>
		</tr>
      </table>    
     
     <br>
     <table width="100%" align="left" border="0">
     	
          <cfquery name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID AS STAFFSRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, SRSA.STAFF_TIME_WORKED,
               		WGA.STAFFCUSTOMERID, SRSA.NEXT_ASSIGNMENT_GROUPID, WGA.GROUPID, GA.GROUPNAME,  WGA.STAFFCUSTOMERID, 
                         CUST.FULLNAME, SRSA.STAFF_COMPLETEDSR, SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMMENTS,  SRSA.STAFF_ASSIGNMENT_ORDER
               FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	SRSA.SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         WGA.GROUPID = GA.GROUPID AND
                         WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
               ORDER BY	SRSA.NEXT_ASSIGNMENT_GROUPID
          </cfquery>
              
	<cfloop query="LookupSRStaffAssignments">
     	<tr>
          <cfif LookupSRStaffAssignments.NEXT_ASSIGNMENT_GROUPID EQ 0>   
			<th align="LEFT" valign="BOTTOM" width="20%">Primary</th>
          <cfelse>    
               <th align="LEFT" valign="BOTTOM" width="20%">Next</th>
           </cfif>    
			<th align="LEFT" valign="BOTTOM" width="10%">Workgroup</th>
			<th align="CENTER" valign="BOTTOM" width="10%">Code</th>
			<th align="LEFT" valign="BOTTOM" width="40%">Comments</th>
			<th align="LEFT" valign="BOTTOM" width="20%">Completed? - Date - Time Worked</th>
		</tr>
          <tr>
               <td align="LEFT" valign="TOP" width="20%"><div>#LookupSRStaffAssignments.FULLNAME#</div></td>
          <cfif LookupSRStaffAssignments.NEXT_ASSIGNMENT_GROUPID EQ 0>
               <td align="LEFT" valign="TOP" width="10%"><div>#LookupServiceRequests.GROUPNAME#</div></td>
          <cfelse>
          	<td align="LEFT" valign="TOP" width="10%"><div>#LookupSRStaffAssignments.GROUPNAME#</div></td>
          </cfif> 
               <td align="CENTER" valign="TOP" width="10%"><div>#LookupSRStaffAssignments.STAFF_ASSIGNMENT_ORDER#</div></td>
               <td align="LEFT" valign="TOP" width="40%"><div>#LookupSRStaffAssignments.STAFF_COMMENTS#</div></td>
               <td align="LEFT" valign="TOP" width="20%">
               	<div>
               		#LookupSRStaffAssignments.STAFF_COMPLETEDSR# -
                    <cfif LookupSRStaffAssignments.STAFF_COMPLETEDSR EQ "YES">
                    	#DateFormat(LookupSRStaffAssignments.STAFF_COMPLETEDDATE, 'MM/DD/YYYY')#
                    <cfelse>
                    	N/A
                    </cfif>
                    	- #LookupSRStaffAssignments.STAFF_TIME_WORKED#
                    </div>
               </td>
          </tr>
	</cfloop>         	
		<tr>
			<td align="left" valign="TOP" colspan="5"><hr></td>
		</tr>
     </table>
     <br>
</cfloop>
	<table width="100%" align="center" border="0">
		<tr>
			<td align="left" valign="TOP" colspan="5"><hr></td>
		</tr>
          <tr>
			<th align="CENTER" colspan="5"><h2>#LookupServiceRequests.RecordCount# Service Request records were selected.</h2></th>
		</tr>
	
		<tr>
<cfform action="/#application.type#apps/servicerequests/srreviewreport.cfm" method="POST">
			<td align="left"><input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /></td>
	</cfform>
	</tr>
		<tr>
			<td align="left" colspan="9">
				<cfinclude template="/include/coldfusion/footer.cfm">
			</td>
		</tr>
	</table>
</cfif>

</body>
</cfoutput>
</html>