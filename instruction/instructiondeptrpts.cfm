<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: instructiondeptrpts.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/29/2009 --->
<!--- Date in Production: 01/29/2009 --->
<!--- Module: Orientation Statistics Departmental Reports --->
<!-- Last modified by John R. Pastori on 01/29/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/instructiondeptrpts.cfm">
<CFSET CONTENT_UPDATED = "January 29, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>

<HTML>
<HEAD>
	<TITLE>Orientation Statistics Departmental Reports</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Instruction - Orientation Statistics";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {
		if (document.LOOKUP.INSTRUCTOR1ID.selectedIndex == "0"   && document.LOOKUP.INSTRUCTOR2ID.selectedIndex == "0"
		 && document.LOOKUP.INSTRUCTOR3ID.selectedIndex == "0"   && document.LOOKUP.FACULTYCONTACT.value == " "
		 && document.LOOKUP.SDSURELATED.value == ""              && document.LOOKUP.CATEGORYID.selectedIndex == "0"
		 && document.LOOKUP.COURSENUMBER.value == ""             && document.LOOKUP.DEPARTMENTID.selectedIndex == "0"
		 && document.LOOKUP.PARTICIPANTQTY.value == ""           && document.LOOKUP.ROOMID.selectedIndex == "0"
		 && document.LOOKUP.USEDCLICKERS.selectedIndex == "0"    && document.LOOKUP.USEDTABLETPCS.selectedIndex == "0"
		 && document.LOOKUP.PRESENTLENGTHID.selectedIndex == "0" && document.LOOKUP.STATUSID.selectedIndex == "0"
		 && document.LOOKUP.SEMESTERID.selectedIndex == "0"
		 && document.LOOKUP.MONTHID.selectedIndex == "0"         && document.LOOKUP.DAYID.selectedIndex == "0" 
		 && document.LOOKUP.ACADEMICYEARID.selectedIndex == "0"  && document.LOOKUP.STARTTIMEID.selectedIndex == "0") {
			alertuser ("You must enter information in one of the nineteen (19) fields!");
			document.LOOKUP.INSTRUCTOR1ID.focus();
			return false;
		}

	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<!--- 
*************************************************************************************
* The following code is used by all Processes for Orientation Statistics Selection. *
*************************************************************************************
 --->
<CFQUERY name="LookupCurrentAcademicYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTACADEMICYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<!--- 
***********************************************************************************
* The following code is the Look Up Process for Orientation Statistics Selection. *
***********************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPORIENTATION')>
	<CFSET CURSORFIELD = "document.LOOKUP.INSTRUCTOR1ID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFIF NOT IsDefined('URL.LOOKUPORIENTATION')>
	<CFQUERY name="ListInstructors" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FIRSTNAME, CUST.INITIALS, CUST.CATEGORYID, CUST.EMAIL, CUST.CAMPUSPHONE,
				CUST.SECONDCAMPUSPHONE, CUST.CELLPHONE, CUST.FAX, CUST.FULLNAME, CUST.DIALINGCAPABILITY, CUST.LONGDISTAUTHCODE,
				CUST.NUMBERLISTED, CUST.UNITID, U.DEPARTMENTID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE, CUST.CONTACTBY,
				CUST.SECURITYLEVELID, CUST.BIBLIOGRAPHER, CUST.COMMENTS, CUST.AA_COMMENTS, CUST.MODIFIEDBYID, CUST.MODIFIEDDATE, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.UNITID = U.UNITID) AND
				(CUST.CUSTOMERID = 0 OR
				(U.DEPARTMENTID = 8 AND
				CUST.CATEGORYID IN (1,8,14,15) AND
				CUST.ACTIVE ='YES'))
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFQUERY name="ListCategory" datasource="#application.type#INSTRUCTION" blockfactor="9">
		SELECT	CATEGORYID, CATEGORYNAME
		FROM		CATEGORY
		ORDER BY	CATEGORYNAME
	</CFQUERY>

	<CFQUERY name="ListDepartments" datasource="#application.type#INSTRUCTION" blockfactor="100">
		SELECT	DEPARTMENTID, DEPARTMENTNAME
		FROM		DEPARTMENTS
		ORDER BY	DEPARTMENTNAME
	</CFQUERY>

	<CFQUERY name="ListRooms" datasource="#application.type#INSTRUCTION" blockfactor="19">
		SELECT	ROOMID, ROOMNAME
		FROM		ROOMS
		ORDER BY	ROOMNAME
	</CFQUERY>

	<CFQUERY name="ListPresentLengths" datasource="#application.type#INSTRUCTION" blockfactor="37">
		SELECT	PRESENTLENGTHID, PRESENTLENGTHTEXT, PRESENTLENGTH
		FROM		PRESENTLENGTHS
		ORDER BY	PRESENTLENGTHTEXT
	</CFQUERY>

	<CFQUERY name="ListStatus" datasource="#application.type#INSTRUCTION" blockfactor="10">
		SELECT	STATUSID, STATUSNAME
		FROM		STATUS
		ORDER BY	STATUSNAME
	</CFQUERY>

	<CFQUERY name="ListSemesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="4">
		SELECT	SEMESTERID, SEMESTERNAME
		FROM		SEMESTERS
		ORDER BY	SEMESTERID
	</CFQUERY>

	<CFQUERY name="ListMonths" datasource="#application.type#LIBSHAREDDATA" blockfactor="13">
		SELECT	MONTHID, MONTHNAME, MONTHNUMBERASCHAR
		FROM		MONTHS
		ORDER BY	MONTHID
	</CFQUERY>

	<CFQUERY name="ListDays" datasource="#application.type#LIBSHAREDDATA" blockfactor="32">
		SELECT	DAYID, DAYTEXT
		FROM		DAYS
		ORDER BY	DAYID
	</CFQUERY>

	<CFQUERY name="ListAcademicYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
		FROM		FISCALYEARS
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<CFQUERY name="ListStartTime" datasource="#application.type#LIBSHAREDDATA" blockfactor="44">
		SELECT	HOURSID, HOURSTEXT, HOURS
		FROM		HOURS
		ORDER BY	HOURS, HOURSID
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Orientation Statistics Departmental Reports Selection Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR />
				Checking an adjacent checkbox will Negate the selection or data entered.
			</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/instruction/instructiondeptrpts.cfm?LOOKUPORIENTATION=FOUND" method="POST">
		<TR>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEINSTRUCTOR1ID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="INSTRUCTOR1ID">Instructor I</LABEL>
			</TH>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEINSTRUCTOR2ID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="INSTRUCTOR2ID">Instructor II</LABEL>
			</TH>
		</TR>
		<TR>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEINSTRUCTOR1ID" id="NEGATEINSTRUCTOR1ID" value="" align="LEFT" required="No" tabindex="2">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="INSTRUCTOR1ID" id="INSTRUCTOR1ID" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="3"></CFSELECT><BR />
			</TD>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEINSTRUCTOR2ID" id="NEGATEINSTRUCTOR2ID" value="" align="LEFT" required="No" tabindex="4">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="INSTRUCTOR2ID" id="INSTRUCTOR2ID" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="5"></CFSELECT><BR />
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEINSTRUCTOR3ID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="INSTRUCTOR3ID">Instructor III</LABEL>
			</TH>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEFACULTYCONTACT">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="FACULTYCONTACT">Faculty Contact</LABEL>
			</TH>
		</TR>
		<TR>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEINSTRUCTOR3ID" id="NEGATEINSTRUCTOR3ID" value="" align="LEFT" required="No" tabindex="6">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="INSTRUCTOR3ID" id="INSTRUCTOR3ID" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="7"></CFSELECT>
			</TD>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFACULTYCONTACT" id="NEGATEFACULTYCONTACT" value="" align="LEFT" required="No" tabindex="8">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="FACULTYCONTACT" id="FACULTYCONTACT" value="" align="LEFT" required="No" size="30" maxlength="50" tabindex="9">
			</TD>
		</TR>
		
		<TR>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESDSURELATED">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SDSURELATED">SDSU Related</LABEL>
			</TH>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATECATEGORYID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="CATEGORYID">Category</LABEL>
			</TH>
		</TR>
		<TR>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESDSURELATED" id="NEGATESDSURELATED" value="" align="LEFT" required="No" tabindex="10">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="SDSURELATED" id="SDSURELATED" size="1" tabindex="11">
					<OPTION selected value="0">SDSU RELATED</OPTION>
					<OPTION value="SDSU">SDSU</OPTION>
					<OPTION value="NON-SDSU">NON-SDSU</OPTION>
				</CFSELECT>
			</TD>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECATEGORYID" id="NEGATECATEGORYID" value="" align="LEFT" required="No" tabindex="12">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="ListCategory" value="CATEGORYID" display="CATEGORYNAME" required="No" tabindex="13"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATECOURSENUMBER">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="COURSENUMBER">Course Number (Eg. COMM 103)</LABEL>
			</TH>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEDEPARTMENTID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="DEPARTMENTID">Department</LABEL>
			</TH>
		</TR>
		<TR>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOURSENUMBER" id="NEGATECOURSENUMBER" value="" align="LEFT" required="No" tabindex="14">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="COURSENUMBER" id="COURSENUMBER" value="" align="LEFT" required="No" size="30" maxlength="100" tabindex="15">
			</TD>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDEPARTMENTID" id="NEGATEDEPARTMENTID" value="" align="LEFT" required="No" tabindex="16">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="DEPARTMENTID" id="DEPARTMENTID" size="1" query="ListDepartments" value="DEPARTMENTID" display="DEPARTMENTNAME" required="No" tabindex="17"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEPARTICIPANTQTY">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="PARTICIPANTQTY">Number of Participants</LABEL>
			</TH>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEROOMID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="ROOMID">Room</LABEL>
			</TH>
		</TR>
		<TR>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPARTICIPANTQTY" id="NEGATEPARTICIPANTQTY"  value="" align="LEFT" required="No" tabindex="18">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="PARTICIPANTQTY" id="PARTICIPANTQTY" value="" align="LEFT" required="No" size="8" tabindex="19">
			</TD>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEROOMID" id="NEGATEROOMID" value="" align="LEFT" required="No" tabindex="20">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="ROOMID" id="ROOMID" size="1" query="ListRooms" value="ROOMID" display="ROOMNAME" required="No" tabindex="21"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<th align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="USEDCLICKERS">Did You Use Clickers?</LABEL>
			</TH>
			<th align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="USEDTABLETPCS">Did You Use Tablet Computers?</LABEL>
			</TH>
		</TR>
		<TR>
			<td align="LEFT" valign="TOP" width="5%">&nbsp;&nbsp;</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="USEDCLICKERS" id="USEDCLICKERS" size="1" tabindex="22">
					<OPTION value="0">Make Selection</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<td align="LEFT" valign="TOP" width="5%">&nbsp;&nbsp;</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="USEDTABLETPCS" id="USEDTABLETPCS" size="1" tabindex="23">
					<OPTION value="0">Make Selection</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEPRESENTLENGTHID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="PRESENTLENGTHID">Presentation Length</LABEL>
			</TH>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTATUSID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="STATUSID">Status</LABEL>
			</TH>
		</TR>
		<TR>
			
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPRESENTLENGTHID" id="NEGATEPRESENTLENGTHID" value="" align="LEFT" required="No" tabindex="24">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="PRESENTLENGTHID" id="PRESENTLENGTHID" size="1" query="ListPresentLengths" value="PRESENTLENGTHID" display="PRESENTLENGTHTEXT" required="No" tabindex="25"></CFSELECT>
			</TD>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTATUSID" id="NEGATESTATUSID" value="" align="LEFT" required="No" tabindex="26">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="STATUSID" id="STATUSID" size="1" query="ListStatus" value="STATUSID" display="STATUSNAME" required="No" tabindex="27"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESEMESTERID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="SEMESTERID">Semester</LABEL>
			</TH>
			<th align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</th>
			<th align="left" valign="BOTTOM" width="45%">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESEMESTERID" id="NEGATESEMESTERID" value="" align="LEFT" required="No" tabindex="28">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="SEMESTERID" id="SEMESTERID" size="1" query="ListSemesters" value="SEMESTERID" display="SEMESTERNAME" required="No" tabindex="29"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEMONTHID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="MONTHID">Month</LABEL>
			</TH>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEDAYID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="DAYID">Day</LABEL>
			</TH>
		</TR>
		<TR>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMONTHID" id="NEGATEMONTHID" value="" align="LEFT" required="No" tabindex="30">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="MONTHID" id="MONTHID" size="1" query="ListMonths" value="MONTHID" display="MONTHNAME" required="No" tabindex="31"></CFSELECT>
			</TD>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDAYID" id="NEGATEDAYID" value="" align="LEFT" required="No" tabindex="32">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="DAYID" id="DAYID" size="1" query="ListDays" value="DAYID" display="DAYTEXT" required="No" tabindex="33"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATEACADEMICYEARID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="ACADEMICYEARID">Academic Year</LABEL>
			</TH>
			<th align="LEFT" valign="BOTTOM" width="5%">
				<label for="NEGATESTARTTIMEID">Negate</label><br>
				&nbsp;Value 
			</th>
			<th align="left" valign="BOTTOM" width="45%">
				<label for="STARTTIMEID">Start Time</LABEL>
			</TH>
		</TR>
		<TR>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEACADEMICYEARID" id="NEGATEACADEMICYEARID" value="" align="LEFT" required="No" tabindex="34">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="ACADEMICYEARID" id="ACADEMICYEARID" size="1" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentAcademicYear.FISCALYEARID#" tabindex="35"></CFSELECT><BR />
				<COM>Default is that Current Academic Year Records are selected.</COM>
			</TD>
			<td align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTARTTIMEID" id="NEGATESTARTTIMEID" value="" align="LEFT" required="No" tabindex="36">
			</td>
			<td align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="STARTTIMEID" id="STARTTIMEID" size="1" query="ListStartTime" value="HOURSID" display="HOURSTEXT" required="No" tabindex="37"></CFSELECT>
			</TD>
		</TR> 
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
			<TH align="LEFT" valign="top" colspan="4">
				DEPARTMENTAL REPORTS
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="4">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="38"><LABEL for="REPORTCHOICE1">Course Number Report</LABEL>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="4">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="39"><LABEL for="REPORTCHOICE2">Department Report</LABEL>
			</TD>
		</TR><BR />
		<TR>
			<TD align="LEFT" valign="top" colspan="4">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="40"><LABEL for="REPORTCHOICE3">Department Student Count Report</LABEL>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="4">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="41"><LABEL for="REPORTCHOICE4">Faculty Contact Report</LABEL>
			</TD>
		</TR>

		<TR>
			<TD colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<BR /><INPUT type="submit" name="ProcessLookup" value="Match Any Field Entered" tabindex="42" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="submit" name="ProcessLookup" value="Match All Fields Entered" tabindex="43" />
			</TD>
		</TR>
		
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="SUBMIT" value="Cancel" tabindex="44" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

	<CFEXIT>
<CFELSE>

	
<!--- 
*********************************************************************************************
* The following code is the Orientation Statistics Departmental Reports Generation Process. *
*********************************************************************************************
 --->

	
	<CFSET REPORTTITLE = ''>

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'OS.COURSENUMBER'>
	<CFSET SORTORDER[2] = 'DEPT.DEPARTMENTNAME, OS.COURSENUMBER'>
	<CFSET SORTORDER[3] = 'DEPT.DEPARTMENTNAME, OS.COURSENUMBER, FY.FISCALYEAR_4DIGIT, S.STATUSNAME'>
	<CFSET SORTORDER[4] = 'OS.FACULTYCONTACT, OS.COURSENUMBER'>

	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>
	REPORT ORDER = #REPORTORDER#<BR /><BR />

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="LookupOrientStatsInstructorDetail" datasource="#application.type#INSTRUCTION" blockfactor="100">
		SELECT	DISTINCT OS.ORIENTSTATSID, OS.INSTRUCTOR1ID, INSTR1.FULLNAME AS INSTRUCTOR1, OS.INSTRUCTOR2ID, INSTR2.FULLNAME AS INSTRUCTOR2,
				OS.INSTRUCTOR3ID, INSTR3.FULLNAME AS INSTRUCTOR3, OS.FACULTYCONTACT, OS.COURSENUMBER, OS.CATEGORYID, C.CATEGORYNAME,
				OS.DEPARTMENTID, DEPT.DEPARTMENTNAME, OS.SDSURELATED, OS.PARTICIPANTQTY, OS.STATUSID, S.STATUSNAME, OS.ROOMID, R.ROOMNAME,
				OS.COURSENUMBER, OS.MONTHID, M.MONTHNAME, OS.DAYID, D.DAYTEXT, OS.ACADEMICYEARID, FY.FISCALYEAR_4DIGIT, OS.STARTTIMEID,
				H.HOURSTEXT, OS.PRESENTLENGTHID, PL.PRESENTLENGTHTEXT, PL.PRESENTLENGTH, OS.SEMESTERID, OS.USEDCLICKERS, OS.USEDTABLETPCS
		FROM		ORIENTSTATS OS, LIBSHAREDDATAMGR.CUSTOMERS INSTR1, LIBSHAREDDATAMGR.CUSTOMERS INSTR2, LIBSHAREDDATAMGR.CUSTOMERS INSTR3,
				CATEGORY C, DEPARTMENTS DEPT, STATUS S, ROOMS R, LIBSHAREDDATAMGR.MONTHS M, LIBSHAREDDATAMGR.DAYS D, LIBSHAREDDATAMGR.FISCALYEARS FY,
				LIBSHAREDDATAMGR.HOURS H, PRESENTLENGTHS PL
		WHERE	(OS.ORIENTSTATSID > 0 AND
				OS.INSTRUCTOR1ID = INSTR1.CUSTOMERID AND
				OS.INSTRUCTOR2ID = INSTR2.CUSTOMERID AND 
				OS.INSTRUCTOR3ID = INSTR3.CUSTOMERID AND
				OS.CATEGORYID = C.CATEGORYID AND
				OS.DEPARTMENTID = DEPT.DEPARTMENTID AND
				OS.STATUSID = S.STATUSID AND
				OS.ROOMID = R.ROOMID AND
				OS.MONTHID = M.MONTHID AND
				OS.DAYID = D.DAYID AND
				OS.ACADEMICYEARID = FY.FISCALYEARID AND
				OS.STARTTIMEID = H.HOURSID AND
				OS.PRESENTLENGTHID = PL.PRESENTLENGTHID) AND (
		<CFIF #FORM.INSTRUCTOR1ID# GT 0>
			<CFIF IsDefined("FORM.NEGATEINSTRUCTOR1ID")>
				NOT OS.INSTRUCTOR1ID = #val(FORM.INSTRUCTOR1ID)# #LOGICANDOR#
			<CFELSE>
				OS.INSTRUCTOR1ID = #val(FORM.INSTRUCTOR1ID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.INSTRUCTOR2ID# GT 0>
			<CFIF IsDefined("FORM.NEGATEINSTRUCTOR2ID")>
				NOT OS.INSTRUCTOR2ID = #val(FORM.INSTRUCTOR2ID)# #LOGICANDOR#
			<CFELSE>
				OS.INSTRUCTOR2ID = #val(FORM.INSTRUCTOR2ID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.INSTRUCTOR3ID# GT 0>
			<CFIF IsDefined("FORM.NEGATEINSTRUCTOR3ID")>
				NOT OS.INSTRUCTOR3ID = #val(FORM.INSTRUCTOR3ID)# #LOGICANDOR#
			<CFELSE>
				OS.INSTRUCTOR3ID = #val(FORM.INSTRUCTOR3ID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.FACULTYCONTACT# NEQ "">
			<CFIF IsDefined("FORM.NEGATEFACULTYCONTACT")>
				NOT OS.FACULTYCONTACT LIKE UPPER('#FORM.FACULTYCONTACT#%') #LOGICANDOR#
			<CFELSE>
				OS.FACULTYCONTACT LIKE UPPER('#FORM.FACULTYCONTACT#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SDSURELATED# GT 0>
			<CFIF IsDefined("FORM.NEGATESDSURELATED")>
				NOT OS.SDSURELATED = UPPER('#FORM.SDSURELATED#') #LOGICANDOR#
			<CFELSE>
				OS.SDSURELATED = UPPER('#FORM.SDSURELATED#') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CATEGORYID# GT 0>
			<CFIF IsDefined("FORM.NEGATECATEGORYID")>
				NOT OS.CATEGORYID = #val(FORM.CATEGORYID)# #LOGICANDOR#
			<CFELSE>
				OS.CATEGORYID = #val(FORM.CATEGORYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>			  

		<CFIF #FORM.COURSENUMBER# NEQ "">
			<CFIF IsDefined("FORM.NEGATECOURSENUMBER")>
				NOT OS.COURSENUMBER LIKE UPPER('#FORM.COURSENUMBER#%') #LOGICANDOR#
			<CFELSE>
				OS.COURSENUMBER LIKE UPPER('#FORM.COURSENUMBER#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.DEPARTMENTID# GT 0>
			<CFIF IsDefined("FORM.NEGATEDEPARTMENTID")>
				NOT OS.DEPARTMENTID = #val(FORM.DEPARTMENTID)# #LOGICANDOR#
			<CFELSE>
				OS.DEPARTMENTID = #val(FORM.DEPARTMENTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.PARTICIPANTQTY# NEQ "">
			<CFIF IsDefined("FORM.NEGATEPARTICIPANTQTY")>
				NOT OS.PARTICIPANTQTY LIKE UPPER('#FORM.PARTICIPANTQTY#%') #LOGICANDOR#
			<CFELSE>
				OS.PARTICIPANTQTY LIKE UPPER('#FORM.PARTICIPANTQTY#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ROOMID# GT 0>
			<CFIF IsDefined("FORM.NEGATEROOMID")>
				NOT OS.ROOMID = #val(FORM.ROOMID)# #LOGICANDOR#
			<CFELSE>
				OS.ROOMID = #val(FORM.ROOMID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.USEDCLICKERS# NEQ "0">
				OS.USEDCLICKERS = UPPER('#FORM.USEDCLICKERS#') #LOGICANDOR#
		</CFIF>

		<CFIF #FORM.USEDTABLETPCS# NEQ "0">
				OS.USEDTABLETPCS = UPPER('#FORM.USEDTABLETPCS#') #LOGICANDOR#
		</CFIF>

		<CFIF #FORM.PRESENTLENGTHID# GT 0>
			<CFIF IsDefined("FORM.NEGATEPRESENTLENGTHID")>
				NOT OS.PRESENTLENGTHID = #val(FORM.PRESENTLENGTHID)# #LOGICANDOR#
			<CFELSE>
				OS.PRESENTLENGTHID = #val(FORM.PRESENTLENGTHID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.STATUSID# GT 0>
			<CFIF IsDefined("FORM.NEGATESTATUSID")>
				NOT OS.STATUSID = #val(FORM.STATUSID)# #LOGICANDOR#
			<CFELSE>
				OS.STATUSID = #val(FORM.STATUSID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SEMESTERID# GT 0>
			<CFIF IsDefined("FORM.NEGATESEMESTERID")>
				NOT OS.SEMESTERID = #val(FORM.SEMESTERID)# #LOGICANDOR#
			<CFELSE>
				OS.SEMESTERID = #val(FORM.SEMESTERID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.MONTHID# GT 0>
			<CFIF IsDefined("FORM.NEGATEMONTHID")>
				NOT OS.MONTHID = #val(FORM.MONTHID)# #LOGICANDOR#
			<CFELSE>
				OS.MONTHID = #val(FORM.MONTHID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.DAYID# GT 0>
			<CFIF IsDefined("FORM.NEGATEDAYID")>
				NOT OS.DAYID = #val(FORM.DAYID)# #LOGICANDOR#
			<CFELSE>
				OS.DAYID = #val(FORM.DAYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ACADEMICYEARID# GT 0>
			<CFIF IsDefined("FORM.NEGATEACADEMICYEARID")>
				NOT OS.ACADEMICYEARID = #val(FORM.ACADEMICYEARID)# #LOGICANDOR#
			<CFELSE>
				OS.ACADEMICYEARID = #val(FORM.ACADEMICYEARID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.STARTTIMEID# GT 0>
			<CFIF IsDefined("FORM.NEGATESTARTTIMEID")>
				NOT OS.STARTTIMEID = #val(FORM.STARTTIMEID)# #LOGICANDOR#
			<CFELSE>
				OS.STARTTIMEID = #val(FORM.STARTTIMEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

				OS.INSTRUCTOR1ID #FINALTEST# 0)
		ORDER BY	#REPORTORDER#
	</CFQUERY>

	<CFIF #LookupOrientStatsInstructorDetail.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Orientation Statistics Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/instruction/instructiondeptrpts.cfm" />
		<CFEXIT>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 1>
		<CFSET REPORTTITLE = 'REPORT 1: &nbsp;&nbsp;Course Number Report'>
		<CFSET FIELDNAME = 'LookupOrientStatsInstructorDetail.COURSENUMBER'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 2>
		<CFSET REPORTTITLE = 'REPORT 2: &nbsp;&nbsp;Department Report'>
		<CFSET FIELDNAME = 'LookupOrientStatsInstructorDetail.DEPARTMENTNAME'>
	</CFIF>
	
	<CFIF #FORM.REPORTCHOICE# EQ 3>
		<CFSET REPORTTITLE = 'REPORT 3: &nbsp;&nbsp;Department Student Count Report'>
		<CFSET FIELDNAME = 'LookupOrientStatsInstructorDetail.DEPARTMENTNAME'>
	</CFIF>
	
	<CFIF #FORM.REPORTCHOICE# EQ 4>
		<CFSET REPORTTITLE = 'REPORT 4: &nbsp;&nbsp;Faculty Contact Report'>
		<CFSET FIELDNAME = 'LookupOrientStatsInstructorDetail.FACULTYCONTACT'>
	</CFIF>

<!-- 
********************************************************************************
* The following code displays the Orientation Statistics Departmental Reports. *
********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Orientation Statistics Departmental Reports
				<H2>#REPORTTITLE#
			</H2></H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/instructiondeptrpts.cfm" method="POST">
			<TD align="LEFT"><INPUT type="submit" value="Cancel" tabindex="1" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="8"><H4>#LookupOrientStatsInstructorDetail.RecordCount# Orientation Statistics records were selected.</H4></TH>
		</TR>
	</TABLE>

	<CFSET REPORTHEADER = "">

	<TABLE width="100%" align="center" border="0">
	<CFIF #FORM.REPORTCHOICE# EQ 1 OR #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 4>
		<TR>
		<CFIF #FORM.REPORTCHOICE# EQ 1>
			<TH align="left">Faculty Contact</TH>
		<CFELSE>
			<TH align="left">Course Number</TH>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 1 OR #FORM.REPORTCHOICE# EQ 3>
			<TH align="CENTER">Department</TH>
		<CFELSE>
			<TH align="CENTER">Faculty Contact</TH>
		</CFIF>
			<TH align="CENTER">Category</TH>
			<TH align="CENTER">Status</TH>
			<TH align="CENTER" nowrap>Academic <BR> Year</TH>
			<TH align="CENTER" nowrap>
				Instructor I/<BR>
				Instructor II/<BR>
				Instructor III
			</TH>
			<TH align="CENTER" nowrap>Clickers <BR>Used?</TH>
			<TH align="CENTER" nowrap>Tablet<BR> Computers<BR> Used?</TH>
		</TR>
<CFLOOP query = "LookupOrientStatsInstructorDetail">
		<CFSET COMPAREHEADER = #Evaluate("#FIELDNAME#")#>
	<CFIF REPORTHEADER NEQ #COMPAREHEADER#>
		<CFSET REPORTHEADER = #COMPAREHEADER#>
		<TR>
			<TD align="CENTER" colspan="8"><HR /></TD>
		</TR>
		<TR>
			<TH align="left"><H2>#REPORTHEADER#</H2></TH>
		</TR>
	</CFIF>
		<TR>
		<CFIF #FORM.REPORTCHOICE# EQ 1>
			<TD align="left" valign="TOP"><DIV>#LookupOrientStatsInstructorDetail.FACULTYCONTACT#</DIV></TD>
		<CFELSE>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.COURSENUMBER#</DIV></TD>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 1 OR #FORM.REPORTCHOICE# EQ 3>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.DEPARTMENTNAME#</DIV></TD>
		<CFELSE>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.FACULTYCONTACT#</DIV></TD>
		</CFIF>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.CATEGORYNAME#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.STATUSNAME#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.FISCALYEAR_4DIGIT#</DIV></TD>
			<TD align="left" valign="TOP" nowrap>
				 <DIV>I #LookupOrientStatsInstructorDetail.INSTRUCTOR1#
		<CFIF #LookupOrientStatsInstructorDetail.INSTRUCTOR2ID# GT 0>
				/<BR>II #LookupOrientStatsInstructorDetail.INSTRUCTOR2#
		</CFIF>
		<CFIF #LookupOrientStatsInstructorDetail.INSTRUCTOR3ID# GT 0>
				/<BR>III #LookupOrientStatsInstructorDetail.INSTRUCTOR3#</DIV>
		</CFIF>
			</TD>
			<TD align="CENTER" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.USEDCLICKERS#</DIV></TD>
			<TD align="CENTER" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.USEDTABLETPCS#</DIV></TD>
		</TR>
</CFLOOP>
	<CFELSE>
		<CFSET STUDENTCOUNT = 0>
		<CFSET TOTALSTUDENTCOUNT = 0>
		<TR>
			<TH align="left">Course Number</TH>
			<TH align="CENTER">Academic Year</TH>
			<TH align="CENTER">Status</TH>
			<TH align="CENTER">Number of Students</TH>
			<TH align="CENTER">Instructor I</TH>
			<TH align="CENTER">Presentation Length</TH>
		</TR>
<CFLOOP query = "LookupOrientStatsInstructorDetail">
		<CFSET COMPAREHEADER = #Evaluate("#FIELDNAME#")#>
	<CFIF REPORTHEADER NEQ #COMPAREHEADER#>
		<CFSET REPORTHEADER = #COMPAREHEADER#>
		<CFIF STUDENTCOUNT GT 0>
		<TR>
			<TH align="CENTER" colspan="8">DEPARTMENT STUDENT COUNT = #STUDENTCOUNT#</TH>
		</TR>
			<CFSET TOTALSTUDENTCOUNT = #TOTALSTUDENTCOUNT# + #STUDENTCOUNT#>
			<CFSET STUDENTCOUNT = 0>
		</CFIF>
		<TR>
			<TD align="CENTER" colspan="8"><HR /></TD>
		</TR>
		<TR>
			<TH align="left"><H2>#REPORTHEADER#</H2></TH>
		</TR>
	</CFIF>
		<CFSET STUDENTCOUNT = STUDENTCOUNT + #LookupOrientStatsInstructorDetail.PARTICIPANTQTY#>
		<TR>
			<TD align="left" nowrap><DIV>#LookupOrientStatsInstructorDetail.COURSENUMBER#</DIV></TD>
			<TD align="CENTER" nowrap><DIV>#LookupOrientStatsInstructorDetail.FISCALYEAR_4DIGIT#</DIV></TD>
			<TD align="CENTER" nowrap><DIV>#LookupOrientStatsInstructorDetail.STATUSNAME#</DIV></TD>
			<TD align="CENTER" nowrap><DIV>#LookupOrientStatsInstructorDetail.PARTICIPANTQTY#</DIV></TD>
			<TD align="CENTER" nowrap><DIV>#LookupOrientStatsInstructorDetail.INSTRUCTOR1#</DIV></TD>
			<TD align="CENTER" nowrap><DIV>#LookupOrientStatsInstructorDetail.PRESENTLENGTHTEXT#</DIV></TD>
		</TR>
</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="8">DEPARTMENT STUDENT COUNT = #STUDENTCOUNT#</TH>
		</TR>
	</CFIF>
		<TR>
			<TD colspan="8"><HR size="5" noshade /></TD>
		</TR>
	<CFIF #FORM.REPORTCHOICE# EQ 3>
		<TR>
			<CFSET TOTALSTUDENTCOUNT = #TOTALSTUDENTCOUNT# + #STUDENTCOUNT#>
			<TH align="CENTER" colspan="8">TOTAL DEPARTMENT STUDENT COUNT = #TOTALSTUDENTCOUNT#</TH>
		</TR>
	</CFIF>
		<TR>
			<TH align="CENTER" colspan="8"><H4>#LookupOrientStatsInstructorDetail.RecordCount# Orientation Statistics records were selected.</H4></TH>
		</TR>
		<TR>
			<TD colspan="8">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/instruction/instructiondeptrpts.cfm" method="POST">
			<TD align="left"><INPUT type="submit" value="CANCEL" tabindex="2" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="8"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</HTML>
</CFOUTPUT>