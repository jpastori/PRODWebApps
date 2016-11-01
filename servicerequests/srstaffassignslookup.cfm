<!--- Program: srstaffassignslookup.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/24/2012 --->
<!--- Date in Production: 05/24/2012 --->
<!--- Module: SR Staff Assignments Selection Lookup--->
<!-- Last modified by John R. Pastori on 10/31/2013 using ColdFusion Studio. -->

	<CFOUTPUT>
	<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
				TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SR.REQUESTERID, SR.ALTERNATE_CONTACTID,
				PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY, PROBSUBCAT.SUBCATEGORYNAME,
				SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID, GA.GROUPNAME,
				SR.SERVICEREQUESTNUMBER || ' - ' || GA.GROUPNAME AS SRNUMGROUP, SR.PROBLEM_DESCRIPTION
		FROM		SERVICEREQUESTS SR, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY,
				GROUPASSIGNED GA
		WHERE	SR.GROUPASSIGNEDID = GA.GROUPID AND
				SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
				SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
				SR.PRIORITYID = PRIORITY.PRIORITYID
		ORDER BY	SR.SERVICEREQUESTNUMBER, SRNUMGROUP
	</CFQUERY>

	<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FIRSTNAME, CUST.FULLNAME, CUST.ACTIVE
		FROM		CUSTOMERS CUST
		WHERE	CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="60">
		SELECT	UNITID, UNITNAME, UNITNAME || ' - ' || UNITID AS UNITLOOKUP
		FROM		UNITS
		ORDER BY	UNITNAME
	</CFQUERY>

	<CFQUERY name="ListProblemCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
		SELECT	CATEGORYID, CATEGORYLETTER, CATEGORYNAME, CATEGORYLETTER || ' ' || CATEGORYNAME AS CATEGORY
		FROM		PROBLEMCATEGORIES
		ORDER BY	CATEGORYLETTER
	</CFQUERY>

	<CFQUERY name="ListProblemSubCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	PROBLEMSUBCATEGORIES.SUBCATEGORYID, PROBLEMSUBCATEGORIES.SUBCATEGORYLETTERID, PROBLEMSUBCATEGORIES.SUBCATEGORYNAME,
				PROBLEMCATEGORIES.CATEGORYLETTER || ' ' || PROBLEMSUBCATEGORIES.SUBCATEGORYNAME AS SUBCAT
		FROM		PROBLEMSUBCATEGORIES, PROBLEMCATEGORIES
		WHERE	PROBLEMSUBCATEGORIES.SUBCATEGORYLETTERID = PROBLEMCATEGORIES.CATEGORYID
		ORDER BY	SUBCAT
	</CFQUERY>

	<CFQUERY name="ListPriority" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
		SELECT	PRIORITYID, PRIORITYNAME
		FROM		PRIORITY
		ORDER BY	PRIORITYNAME
	</CFQUERY>

	<CFQUERY name="LookupServDeskInitials" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, FULLNAME || '-' || INITIALS AS SDINITIALS, ACTIVE
		FROM		CUSTOMERS
		WHERE	INITIALS IS NOT NULL AND
				ACTIVE = 'YES'
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupHardwareBarcode" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	DISTINCT HI.BARCODENUMBER
		FROM		HARDWMGR.HARDWAREINVENTORY HI, SREQUIPLOOKUP SRELU
		WHERE	HI.BARCODENUMBER = SRELU.EQUIPMENTBARCODE
		ORDER BY	HI.BARCODENUMBER
	</CFQUERY>
     
     <CFQUERY name="LookupHardwareStateFound" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	DISTINCT HI.STATEFOUNDNUMBER, HI.BARCODENUMBER  
		FROM		HARDWMGR.HARDWAREINVENTORY HI, SREQUIPLOOKUP SRELU
		WHERE	HI.BARCODENUMBER = SRELU.EQUIPMENTBARCODE  AND
          		NOT (HI.STATEFOUNDNUMBER IS NULL)
		ORDER BY	HI.STATEFOUNDNUMBER
	</CFQUERY>

	<CFQUERY name="LookupHardwareDivision" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	DISTINCT HI.DIVISIONNUMBER, HI.BARCODENUMBER
		FROM		HARDWMGR.HARDWAREINVENTORY HI, SREQUIPLOOKUP SRELU
		WHERE	HI.BARCODENUMBER = SRELU.EQUIPMENTBARCODE AND
          		NOT (HI.DIVISIONNUMBER IS NULL)
		ORDER BY	HI.DIVISIONNUMBER
	</CFQUERY>
     
     <CFQUERY name="LookupHWSW" datasource="#application.type#SERVICEREQUESTS" blockfactor="9">
          SELECT	HWSW_ID, HWSW_NAME
          FROM		HWSW
          ORDER BY	HWSW_ID
     </CFQUERY>

	<CFQUERY name="LookupStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	DISTINCT WGA.STAFFCUSTOMERID, CUST.FULLNAME
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
		SELECT	GROUPID, GROUPNAME
		FROM		GROUPASSIGNED
		ORDER BY	GROUPNAME
	</CFQUERY>


	<table width="100%" align="center" border="3">
		<tr align="center">
			<th align="center">
               	<h1> 
               	#session.LookupReportTitle# 
                   </h1>
                </th>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr align="center">
			<th align="center">
				<h2>Select from the drop down boxes or type in full/partial values to choose report criteria. <br />
				Checking an adjacent checkbox will Negate the selection or data entered.
			</h2></th>
		</tr>
	</table>
	<br />
	<table width="100%" align="LEFT">
		<tr>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<td align="LEFT" valign="TOP" colspan="4">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</CFFORM>
		</tr>
	</table>
	
	<fieldset>
	<legend>Service Request</legend>
<CFFORM name="LOOKUP" onsubmit="return #ValidateFields#;" action="/#application.type#apps/servicerequests/#session.ACTIONPGM#" method="POST">
	<table width="100%" align="LEFT">
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESERVICEREQUESTNUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SERVICEREQUESTNUMBER">SR</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESRID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SRID">SR/Group</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESERVICEREQUESTNUMBER" id="NEGATESERVICEREQUESTNUMBER" value="" align="LEFT" required="No" tabindex="2">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" value="#ListCurrentFiscalYear.FISCALYEAR_2DIGIT#" align="LEFT" required="NO" size="9" maxlength="9" tabindex="3">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESRID" id="NEGATESRID" value="" align="LEFT" required="No" tabindex="4">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="SRID" id="SRID" size="1" query="ListServiceRequests" value="SRID" display="SRNUMGROUP" selected="0" required="No" tabindex="5"></CFSELECT>
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
				<label for="REQUESTERID">Requester</label>
			</th>
               <th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEUNITID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="UNITID">Unit Name</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTERID" id="NEGATEREQUESTERID" value="" align="LEFT" required="No" tabindex="6">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="7"></CFSELECT>
			</td>
               <td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" align="LEFT" required="No" tabindex="8">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="LookupUnits" value="UNITID" display="UNITLOOKUP" selected="0" required="No" tabindex="9"></CFSELECT>
			</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEREQUESTERFIRSTNAME">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="REQUESTERFIRSTNAME">Or Requester's First Name</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEREQUESTERLASTNAME">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="REQUESTERLASTNAME">Or Requester's Last Name</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTERFIRSTNAME" id="NEGATEBREQUESTERFIRSTNAME" value="" align="LEFT" required="No" tabindex="10">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="REQUESTERFIRSTNAME" id="REQUESTERFIRSTNAME" value="" align="LEFT" required="No" size="17" tabindex="11">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTERLASTNAME" id="NEGATEREQUESTERLASTNAME" value="" align="LEFT" required="No" tabindex="12">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="REQUESTERLASTNAME" id="REQUESTERLASTNAME" value="" align="LEFT" required="No" size="17" tabindex="13">
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
				<CFINPUT type="CheckBox" name="NEGATECATEGORYID" id="NEGATECATEGORYID" value="" align="LEFT" required="No" tabindex="14">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="ListProblemCategories" value="CATEGORYID" display="CATEGORY" selected="0" required="No" tabindex="15"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESUBCATEGORYID" id="NEGATESUBCATEGORYID" value="" align="LEFT" required="No" tabindex="16">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="SUBCATEGORYID" id="SUBCATEGORYID" size="1" query="ListProblemSubCategories" value="SUBCATEGORYID" display="SUBCAT" selected="0" required="No" tabindex="17"></CFSELECT>
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
				<label for="NEGATEPRIORITYID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="PRIORITYID">Priority</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPROBLEM_DESCRIPTION" id="NEGATEPROBLEM_DESCRIPTION" value="" align="LEFT" required="No" tabindex="18">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" value="" align="LEFT" required="No" size="50" tabindex="19">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPRIORITYID" id="NEGATEPRIORITYID" value="" align="LEFT" required="No" tabindex="20">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="PRIORITYID" id="PRIORITYID" size="1" query="ListPriority" value="PRIORITYID" display="PRIORITYNAME" selected="0" required="No" tabindex="21"></CFSELECT>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
          <tr>
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
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SRCOMPLETED">SR Completed?</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECREATIONDATE" id="NEGATECREATIONDATE" value="" align="LEFT" required="No" tabindex="22">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="CREATIONDATE" id="CREATIONDATE" value="" required="No" size="50" tabindex="23">
			</td>
			<td align="LEFT" width="5%">&nbsp;&nbsp;</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="SRCOMPLETED" id="SRCOMPLETED" size="1" tabindex="24">
                    	<option value="Select">Select Status</option>
					<option value="NO">NO</option>
					<option value="YES">YES</option>
					<option value="VOIDED">VOIDED</option>
				</CFSELECT>
			</td>
		</tr>
	</table>
	</FIELDSET>
	<br />
     <fieldset>
	<legend>Associated Equipment</legend>
	<table width="100%" align="LEFT">
          <tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEBARCODENUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="BARCODENUMBER">Barcode Number</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTATEFOUNDNUMBERBC">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="STATEFOUNDNUMBERBC">State Found Number</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBARCODENUMBER" id="NEGATEBARCODENUMBER" value="" align="LEFT" required="No" tabindex="25">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="BARCODENUMBER" id="BARCODENUMBER" tabindex="26">
					<option value="0">BARCODE NUMBER</option>
					<CFLOOP query="LookupHardwareBarcode">
						<option value='#BARCODENUMBER#'>#BARCODENUMBER#</option>
					</CFLOOP>
				</CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTATEFOUNDNUMBERBC" id="NEGATESTATEFOUNDNUMBERBC" value="" align="LEFT" required="No" tabindex="27">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="STATEFOUNDNUMBERBC" id="STATEFOUNDNUMBERBC" tabindex="28">
					<option value="0">STATE FOUND NUMBER</option>
					<CFLOOP query="LookupHardwareStateFound">
						<option value='#BARCODENUMBER#'>#STATEFOUNDNUMBER#</option>
					</CFLOOP>
				</CFSELECT>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEDIVISIONNUMBERBC">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="DIVISIONNUMBERBC">Select a Division Number</label>
			</th>
         		<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEDIVISIONNUMBER_TEXT">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="DIVISIONNUMBER_TEXT">
                    	Division Number<br /> 
                    	Or Enter (1) a partial or full Division Number or<br /> 
                      	&nbsp;(2) a series of full Division Numbers separated by commas,NO spaces or<br />
                         &nbsp;(<COM>Each value in the series must be single quoted: i.e. 'DIVISION','NUMBER'</COM>)<br />
                         &nbsp;(3) two full Division Numbers separated by a semicolon for range.
                    </label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDIVISIONNUMBERBC"id="NEGATEDIVISIONNUMBERBC" value="" align="LEFT" required="No" tabindex="29">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="DIVISIONNUMBERBC" id="DIVISIONNUMBERBC" tabindex="30">
					<option value="0">DIVISION NUMBER</option>
					<CFLOOP query="LookupHardwareDivision">
						<option value='#BARCODENUMBER#'>#DIVISIONNUMBER#</option>
					</CFLOOP>
				</CFSELECT>
			</td>
               <td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDIVISIONNUMBER_TEXT" id="NEGATEDIVISIONNUMBER_TEXT" value="" align="LEFT" required="No" tabindex="39">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="DIVISIONNUMBER_TEXT" id="DIVISIONNUMBER_TEXT" value="" required="No" size="50" tabindex="40">
			</td>
          <tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
	</table>
     <table width="100%" border="0">
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
     </table>
     </fieldset>
     <br />
     <CFIF (FIND('EXTRA', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>
     <fieldset>
     <legend>Extra</legend>
     <table width="100%" border="0">
     	<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEPONUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="PONUMBER">Purchase Order Number</label>
			</th>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATETNSWONUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="TNSWONUMBER">TNS WO Number</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPONUMBER" id="NEGATEPONUMBER" value="" align="LEFT" required="No" tabindex="33">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="PONUMBER" id="PONUMBER" value="" align="LEFT" required="No" size="50" tabindex="34">
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATETNSWONUMBER" id="NEGATETNSWONUMBER" value="" align="LEFT" required="No" tabindex="35">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="TNSWONUMBER" id="TNSWONUMBER" value="" align="LEFT" required="No" size="50" tabindex="36">
			</td>
		</tr>
     </table>
     <table width="100%" border="0">
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
     </table>
     </fieldset>
     <br />
     </CFIF>
     <fieldset>
     <legend>Group/Staff Assignments</legend>
     <table width="100%" border="0">
		<tr>
			<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTAFFCUSTOMERID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
               	<label for="STAFFCUSTOMERID">Staff Assigned</label>
			</th>
               <th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTAFF_DATEASSIGNED">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="STAFF_DATEASSIGNED">
                         Staff Date Assigned<br />
                         Enter (1) a single Staff Date Assigned or<br>
                         &nbsp;(2) a series of dates separated by commas,NO spaces or<br>
                         &nbsp;(3) two dates separated by a semicolon for range.
                    </label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTAFFCUSTOMERID" id="NEGATESTAFFCUSTOMERID" value="" align="LEFT" required="No" tabindex="37">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="STAFFCUSTOMERID" id="STAFFCUSTOMERID" size="1" query="LookupStaffAssigned" value="STAFFCUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="38"></CFSELECT>
			</td>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTAFF_DATEASSIGNED" id="NEGATESTAFF_DATEASSIGNED" value="" align="LEFT" required="No" tabindex="39">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="STAFF_DATEASSIGNED" id="STAFF_DATEASSIGNED" value="" required="No" size="50" tabindex="40">
			</td>			
		</tr>
		<tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>

		<tr>
          	<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEGROUPASSIGNEDID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="GROUPASSIGNEDID">Group</label>
			</th>

               <th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESDINITIALSID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SDINITIALSID">Service Desk Initials</label>
			</th>
		</tr>
		<tr>
          	<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEGROUPASSIGNEDID" id="NEGATEGROUPASSIGNEDID" value="" align="LEFT" required="No" tabindex="41">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="GROUPASSIGNEDID" id="GROUPASSIGNEDID" size="1" query="ListGroupAssigned" value="GROUPID" display="GROUPNAME" selected="0" required="No" tabindex="42"></CFSELECT>
			</td>

			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESDINITIALSID" id="NEGATESDINITIALSID" value="" align="LEFT" required="No" tabindex="43">
			</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="SDINITIALSID" id="SDINITIALSID" size="1" query="LookupServDeskInitials" value="CUSTOMERID" display="SDINITIALS" selected="0" required="No" tabindex="44"></CFSELECT>
			</td>
		</tr>
          <tr>
			<td colspan="4">&nbsp;&nbsp;</td>
		</tr>
          <tr>
          	<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTAFF_COMMENTS">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="STAFF_COMMENTS">Staff Comments</label>
			</th>
          	<th class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="STAFF_COMPLETEDSR">Staff Completed SR?</label>
			</th>
		</tr>
		<tr>
			<td align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTAFF_COMMENTS" id="NEGATESTAFF_COMMENTS" value="" align="LEFT" required="No" tabindex="45">
			</td>
			<td align="LEFT" width="45%">
				<CFINPUT type="Text" name="STAFF_COMMENTS" id="STAFF_COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="46">
			</td>
			<td align="LEFT" width="5%">&nbsp;&nbsp;</td>
			<td align="LEFT" width="45%">
				<CFSELECT name="STAFF_COMPLETEDSR" id="STAFF_COMPLETEDSR" size="1" tabindex="47">
                    	<option value="Select">Select Status</option>
					<option value="NO">NO</option>
					<option value="YES">YES</option>
					<option value="VOIDED">VOIDED</option>
				</CFSELECT>
			</td>
		</tr>
	</table>
     </fieldset>
     <br />
     <CFIF (FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>
     <fieldset>
     <legend>Sort Order / Sequence Selection</legend>
     <table width="100%" border="0">
     	<tr>
			<td align="LEFT" valign="TOP" colspan="4"><COM>SELECT ONE OF THE SORT ORDERS BELOW. THE THIRD ONE IS THE DEFAULT</COM></td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE1" value="1" align="LEFT" required="No" tabindex="28">
			</td>
			<th align="left" valign="TOP"><label for="SORTCHOICE1">Full Requester Name, Creation Date and SR##</label></th>
			<th align="LEFT" valign="TOP" colspan="2">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE2" value="2" align="LEFT" required="No" tabindex="29">
			</td>
			<th align="left" valign="TOP"><label for="SORTCHOICE2">SR##</label></th>
			<th align="LEFT" valign="TOP" colspan="2">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE3" checked value="3" align="LEFT" required="No" tabindex="27">
			</td>
			<th align="left" valign="TOP"><label for="SORTCHOICE3">SR## and Group Name</label></th>
               <th align="LEFT" valign="TOP" colspan="2">&nbsp;&nbsp;</th>
		</tr>
          <tr>
			<td align="LEFT" valign="TOP" colspan="4">
               	<br /><COM>SELECT AN ASCENDING OR DESCENDING SORT SEQUENCE ON THE FIRST SORT FIELD OF THE CHOICES ABOVE.  ASCENDING IS DEFAULT.</COM>
               </td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTASCDESC" id="SORTASCDESC1" checked value="1" align="LEFT" required="No" tabindex="30">
			</td>
			<th align="left" valign="TOP"><label for="SORTASCDESC1">Ascending Sort on First Field</label></th>
			<th align="LEFT" valign="TOP" colspan="2">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTASCDESC" id="SORTASCDESC2" value="2" align="LEFT" required="No" tabindex="31">
			</td>
			<th align="left" valign="TOP"><label for="SORTASCDESC2">Descending Sort on First Field</label></th>
			<th align="LEFT" valign="TOP" colspan="2">&nbsp;&nbsp;</th>
		</tr>
     </table>
     </fieldset>
     <br />
     </CFIF>
     <fieldset>
     <legend>Record Selection</legend>
     <table width="100%" border="0">	
		<tr>
			<td align="LEFT" colspan="4">
               	<input type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<br /><input type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="48" />
			</td>
		</tr>
		<tr>
			<td align="LEFT" colspan="4">
				<input type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" onclick="return setMatchAll();" tabindex="49" />
			</td>
		</tr>
	</table>
     </fieldset>
</CFFORM>
     <table width="100%" border="0">
		<tr>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<td align="LEFT" valign="TOP" colspan="4">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="50" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</CFFORM>
		</tr>
		<tr>
			<td align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
     </CFOUTPUT>