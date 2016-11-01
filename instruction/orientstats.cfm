<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: orientstats.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/29/2012 --->
<!--- Date in Production: 06/29/2012 --->
<!--- Module: Add/Modify/Delete Information to Instruction - Orientation Statistics --->
<!-- Last modified by John R. Pastori on 06/29/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/orientstats.cfm">
<CFSET CONTENT_UPDATED = "June 29, 2012">

<CFOUTPUT>

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

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Instruction - Orientation Statistics</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Instruction - Orientation Statistics</TITLE>
	</CFIF>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Instruction - Orientation Statistics";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {

		if (document.ORIENTATIONSTATS.INSTRUCTOR1ID.selectedIndex == "0") {
			alertuser (document.ORIENTATIONSTATS.INSTRUCTOR1ID.name +  ",  A Instructor MUST be selected!");
			document.ORIENTATIONSTATS.INSTRUCTOR1ID.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.CATEGORYID.selectedIndex == "0") {
			alertuser (document.ORIENTATIONSTATS.CATEGORYID.name +  ",  A Category MUST be selected!");
			document.ORIENTATIONSTATS.CATEGORYID.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.COURSENUMBER.value == "" || document.ORIENTATIONSTATS.COURSENUMBER.value == " ") {
			alertuser (document.ORIENTATIONSTATS.COURSENUMBER.name +  ",  A Course Name and Number MUST be entered!");
			document.ORIENTATIONSTATS.COURSENUMBER.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.STATUSID.selectedIndex == "0") {
			alertuser (document.ORIENTATIONSTATS.STATUSID.name +  ",  A Student Status MUST be selected!");
			document.ORIENTATIONSTATS.STATUSID.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.DEPARTMENTID.selectedIndex == "0") {
			alertuser (document.ORIENTATIONSTATS.DEPARTMENTID.name +  ",  A Department MUST be selected!");
			document.ORIENTATIONSTATS.DEPARTMENTID.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.PARTICIPANTQTY.value == "" || document.ORIENTATIONSTATS.PARTICIPANTQTY.value == " "
		 || document.ORIENTATIONSTATS.PARTICIPANTQTY.value == "0") {
			alertuser (document.ORIENTATIONSTATS.PARTICIPANTQTY.name +  ",  A Student Quantity MUST be entered!");
			document.ORIENTATIONSTATS.PARTICIPANTQTY.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.ROOMID.selectedIndex == "0") {
			alertuser (document.ORIENTATIONSTATS.ROOMID.name +  ",  A Room MUST be selected!");
			document.ORIENTATIONSTATS.ROOMID.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.PRESENTLENGTHID.selectedIndex == "0") {
			alertuser (document.ORIENTATIONSTATS.PRESENTLENGTHID.name +  ",  A Presentation Length MUST be selected!");
			document.ORIENTATIONSTATS.PRESENTLENGTHID.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.MONTHID.selectedIndex == "0") {
			alertuser (document.ORIENTATIONSTATS.MONTHID.name +  ",  A Month Name MUST be selected!");
			document.ORIENTATIONSTATS.MONTHID.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.DAYID.selectedIndex == "0") {
			alertuser (document.ORIENTATIONSTATS.DAYID.name +  ",  A Day MUST be selected!");
			document.ORIENTATIONSTATS.DAYID.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.SEMESTERID.selectedIndex == "0") {
			alertuser (document.ORIENTATIONSTATS.SEMESTERID.name +  ",  A Semester Name MUST be selected!");
			document.ORIENTATIONSTATS.SEMESTERID.focus();
			return false;
		}

		if (document.ORIENTATIONSTATS.STARTTIMEID.selectedIndex == "0") {
			alertuser (document.ORIENTATIONSTATS.STARTTIMEID.name +  ",  A Start Time MUST be selected!");
			document.ORIENTATIONSTATS.STARTTIMEID.focus();
			return false;
		}

	}

	function validateLookupFields() {

		if (document.LOOKUP.ORIENTSTATSID.selectedIndex == "0") {
			alertuser (document.LOOKUP.ORIENTSTATSID.name +  ",  A Orientation Record MUST be selected!");
			document.LOOKUP.ORIENTSTATSID.focus();
			return false;
		}

	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFIF NOT IsDefined('URL.LOOKUPOS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.ORIENTSTATSID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.ORIENTATIONSTATS.INSTRUCTOR1ID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">


<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<BR clear="left" />

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListInstructors" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.UNITID, U.UNITID, U.DEPARTMENTID, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.UNITID = U.UNITID) AND
			((CUST.CUSTOMERID = 0) OR
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

<CFQUERY name="ListStatus" datasource="#application.type#INSTRUCTION" blockfactor="10">
	SELECT	STATUSID, STATUSNAME
	FROM		STATUS
	ORDER BY	STATUSNAME
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

<!--- 
***********************************************************************************
* The following code is the ADD Process for Instruction - Orientation Statistics. *
***********************************************************************************
 --->
<CFIF URL.PROCESS EQ 'ADD'>

	<CFQUERY name="LookupCurrentAcademicYear" datasource="#application.type#LIBSHAREDDATA">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
		FROM		FISCALYEARS
		WHERE	(CURRENTACADEMICYEAR = 'YES')
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Instruction - Orientation Statistics</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#INSTRUCTION">
		SELECT	MAX(ORIENTSTATSID) AS MAX_ID
		FROM		ORIENTSTATS
	</CFQUERY>
	<CFSET FORM.ORIENTSTATSID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="ORIENTSTATSID" secure="NO" value="#FORM.ORIENTSTATSID#">
	<CFQUERY name="AddOrientStatsID" datasource="#application.type#INSTRUCTION">
		INSERT INTO	ORIENTSTATS (ORIENTSTATSID)
		VALUES		(#val(Cookie.ORIENTSTATSID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">
				Orientation Statistics Key &nbsp; = &nbsp; #FORM.ORIENTSTATSID# 
			</TH>
		</TR>
	</TABLE>
	<BR />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/processorientstats.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessOrientStats" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="ORIENTATIONSTATS" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processorientstats.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" valign="BOTTOM"><H4><LABEL for="INSTRUCTOR1ID">*Instructor I</LABEL>/<LABEL for="INSTRUCTORNAME">Instructor Name</LABEL></H4></TH>
			<TH align="left" valign="BOTTOM"><LABEL for="INSTRUCTOR2ID">Instructor II</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="INSTRUCTOR1ID" id="INSTRUCTOR1ID" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="2"></CFSELECT><BR />
				<CFINPUT type="Text" name="INSTRUCTORNAME" id="INSTRUCTORNAME" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3">
			</TD>
			<TD align="left">
				<CFSELECT name="INSTRUCTOR2ID" id="INSTRUCTOR2ID" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="INSTRUCTOR3ID">Instructor III</LABEL></TH>
			<TH align="left"><LABEL for="FACULTYCONTACT">Faculty Contact</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="INSTRUCTOR3ID" id="INSTRUCTOR3ID" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="5"></CFSELECT>
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="FACULTYCONTACT" id="FACULTYCONTACT" value="" align="LEFT" required="No" size="30" maxlength="50" tabindex="6">
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="SDSURELATED">*SDSU Related</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="CATEGORYID">*Category</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="SDSURELATED" id="SDSURELATED" size="1" tabindex="7">
					<OPTION selected value="SDSU">SDSU</OPTION>
					<OPTION value="NON-SDSU">NON-SDSU</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="ListCategory" value="CATEGORYID" display="CATEGORYNAME" required="No" tabindex="8"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="COURSENUMBER">*Course Number (Eg. COM 103)</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="STATUSID">*Status</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="COURSENUMBER" id="COURSENUMBER" value="" align="LEFT" required="No" size="50" maxlength="75" tabindex="9">
			</TD>
			<TD>
				<CFSELECT name="STATUSID" id="STATUSID" size="1" query="ListStatus" value="STATUSID" display="STATUSNAME" required="No" tabindex="10"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" colspan="2"><H4><LABEL for="DEPARTMENTID">*Department</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">
				<CFSELECT name="DEPARTMENTID" id="DEPARTMENTID" size="1" query="ListDepartments" value="DEPARTMENTID" display="DEPARTMENTNAME" required="No" tabindex="11"></CFSELECT>
			</TD>
			
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PARTICIPANTQTY">*Number of Participants</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="ROOMID">*Room</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="PARTICIPANTQTY" id="PARTICIPANTQTY" value="" align="LEFT" required="No" size="8" tabindex="12">
			</TD>
			<TD align="left">
				<CFSELECT name="ROOMID" id="ROOMID" size="1" query="ListRooms" value="ROOMID" display="ROOMNAME" required="No" tabindex="13"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="USEDCLICKERS">Did You Use Clickers?</LABEL></TH>
			<TH align="left"><LABEL for="USEDTABLETPCS">Did You Use Tablet Computers?</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="USEDCLICKERS" id="USEDCLICKERS" size="1" tabindex="14">
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="USEDTABLETPCS" id="USEDTABLETPCS" size="1" tabindex="15">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP"><H4><LABEL for="PRESENTLENGTHID">*Presentation Length</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="SEMESTERID">*Semester</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="PRESENTLENGTHID" id="PRESENTLENGTHID" size="1" query="ListPresentLengths" value="PRESENTLENGTHID" display="PRESENTLENGTHTEXT" required="No" tabindex="16"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SEMESTERID" id="SEMESTERID" size="1" query="ListSemesters" value="SEMESTERID" display="SEMESTERNAME" selected="0" required="No" tabindex="17"></CFSELECT><BR />
					<COM>Note: &nbsp;&nbsp;&nbsp;&nbsp;Summer is the first semester of the academic year.</COM>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="MONTHID">*Month</LABEL></H4></TH>	
			<TH align="left"><H4><LABEL for="DAYID">*Day</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="MONTHID" id="MONTHID" size="1" query="ListMonths" value="MONTHID" display="MONTHNAME" required="No" tabindex="18"></CFSELECT>
			</TD>
			<TD>
				<CFSELECT name="DAYID" id="DAYID" size="1" query="ListDays" value="DAYID" display="DAYTEXT" required="No" tabindex="19"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="ACADEMICYEARID">*Academic Year</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="STARTTIMEID">*Start Time</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="ACADEMICYEARID" id="ACADEMICYEARID" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentAcademicYear.FISCALYEARID#" tabindex="20"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="STARTTIMEID" id="STARTTIMEID" size="1" query="ListStartTime" value="HOURSID" display="HOURSTEXT" required="No" tabindex="21"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessOrientStats" value="ADD" tabindex="22" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/instruction/processorientstats.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessOrientStats" value="CANCELADD" tabindex="23" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
**************************************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Instruction - Orientation Statistics. *
**************************************************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOKUPOS')>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center"><H1>Lookup for Modify/Delete in Instruction - Orientation Statistics</H1></TH>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>

		<CFQUERY name="LookupOrientStats" datasource="#application.type#INSTRUCTION" blockfactor="100">
			SELECT	OS.ORIENTSTATSID, OS.INSTRUCTOR1ID, INSTR1.FULLNAME, OS.INSTRUCTOR2ID, OS.INSTRUCTOR3ID,
					OS.FACULTYCONTACT, OS.COURSENUMBER, OS.CATEGORYID, OS.DEPARTMENTID, OS.SDSURELATED,
					OS.PARTICIPANTQTY, OS.STATUSID, OS.ROOMID, OS.MONTHID, M.MONTHNAME, OS.DAYID, D.DAYTEXT,
					OS.ACADEMICYEARID, FY.FISCALYEAR_4DIGIT, OS.STARTTIMEID, H.HOURSTEXT, OS.PRESENTLENGTHID, OS.SEMESTERID, SEM.SEMESTERNAME,
					OS.COURSENUMBER || ' - ' || OS.FACULTYCONTACT || ' - ' || INSTR1.FULLNAME || ' - ' || FY.FISCALYEAR_4DIGIT
									|| ' - ' || M.MONTHNAME || ' - ' || D.DAYTEXT || ' - ' || H.HOURSTEXT AS LOOKUPKEY
			FROM		ORIENTSTATS OS, LIBSHAREDDATAMGR.CUSTOMERS INSTR1, LIBSHAREDDATAMGR.FISCALYEARS FY, LIBSHAREDDATAMGR.MONTHS M,
					LIBSHAREDDATAMGR.DAYS D, LIBSHAREDDATAMGR.HOURS H, LIBSHAREDDATAMGR.SEMESTERS SEM
			WHERE	OS.INSTRUCTOR1ID = INSTR1.CUSTOMERID AND
					OS.ACADEMICYEARID = FY.FISCALYEARID AND
					OS.MONTHID = M.MONTHID AND
					OS.DAYID = D.DAYID AND
					OS.STARTTIMEID = H.HOURSID AND
					OS.SEMESTERID = SEM.SEMESTERID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<BR />
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/instruction/orientstats.cfm?PROCESS=#URL.PROCESS#&LOOKUPOS=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="ORIENTSTATSID">*Course Number - Faculty Contact - Instructor - Fiscal Year - Month - Day - Hours</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" width="70%">
					<CFSELECT name="ORIENTSTATSID" id="ORIENTSTATSID" size="1" query="LookupOrientStats" value="ORIENTSTATSID" display="LOOKUPKEY" required="NO" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
***************************************************************************************************
* The following code is the Modify and Delete Processes for Instruction - Orientation Statistics. *
***************************************************************************************************
 --->

		<CFQUERY name="GetOrientStats" datasource="#application.type#INSTRUCTION">
			SELECT	ORIENTSTATSID, INSTRUCTOR1ID, INSTRUCTOR2ID, INSTRUCTOR3ID, FACULTYCONTACT,  COURSENUMBER, CATEGORYID, DEPARTMENTID, SDSURELATED,
					PARTICIPANTQTY, STATUSID, ROOMID, MONTHID, DAYID, ACADEMICYEARID, STARTTIMEID, PRESENTLENGTHID, INSTRUCTORNAME, SEMESTERID,
					USEDCLICKERS, USEDTABLETPCS
			FROM		ORIENTSTATS
			WHERE	ORIENTSTATSID = <CFQUERYPARAM value="#FORM.ORIENTSTATSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	COURSENUMBER
		</CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center"><H1>Modify/Delete in Instruction - Orientation Statistics</H1></TH>
			</TR>
		</TABLE>
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
			<TR>
				<TH align= "CENTER">
					Orientation Statistics Key &nbsp; = &nbsp; #FORM.ORIENTSTATSID# 
				</TH>
			</TR>
		</TABLE>
		<BR />
		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/orientstats.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessOrientStats" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="ORIENTATIONSTATS" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processorientstats.cfm" method="POST" ENABLECAB="Yes">
			<CFCOOKIE name="ORIENTSTATSID" secure="NO" value="#GetOrientStats.ORIENTSTATSID#">
			<TR>
				<TH align="left" valign="BOTTOM"><H4><LABEL for="INSTRUCTOR1ID">*Instructor I</LABEL>/<LABEL for="INSTRUCTORNAME">Instructor Name</LABEL></H4></TH>
				<TH align="left" valign="BOTTOM"><LABEL for="INSTRUCTOR2ID">Instructor II</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="INSTRUCTOR1ID" id="INSTRUCTOR1ID" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" selected="#GetOrientStats.INSTRUCTOR1ID#" required="No" tabindex="2"></CFSELECT><BR />
					<CFINPUT type="Text" name="INSTRUCTORNAME" id="INSTRUCTORNAME" value="#GetOrientStats.INSTRUCTORNAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="3">
				</TD>
				<TD align="left">
					<CFSELECT name="INSTRUCTOR2ID" id="INSTRUCTOR2ID" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" selected="#GetOrientStats.INSTRUCTOR2ID#" required="No" tabindex="4"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="INSTRUCTOR3ID-">Instructor III</LABEL></TH>
				<TH align="left"><LABEL for="FACULTYCONTACT">Faculty Contact</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="INSTRUCTOR3ID" id="INSTRUCTOR3ID" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" selected="#GetOrientStats.INSTRUCTOR3ID#" required="No" tabindex="5"></CFSELECT>
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="FACULTYCONTACT" id="FACULTYCONTACT" value="#GetOrientStats.FACULTYCONTACT#" align="LEFT" required="No" size="30" maxlength="50" tabindex="6">
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="SDSURELATED">*SDSU Related</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="CATEGORYID">*Category</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="SDSURELATED" id="SDSURELATED" size="1" tabindex="7">
						<OPTION selected value="#GetOrientStats.SDSURELATED#">#GetOrientStats.SDSURELATED#</OPTION>
						<OPTION value="SDSU">SDSU</OPTION>
						<OPTION value="NON-SDSU">NON-SDSU</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="ListCategory" value="CATEGORYID" display="CATEGORYNAME" selected="#GetOrientStats.CATEGORYID#" required="No" tabindex="8"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="COURSENUMBER">*Course Number (Eg. COM 103)</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="STATUSID">*Status</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="COURSENUMBER" id="COURSENUMBER" value="#GetOrientStats.COURSENUMBER#" align="LEFT" required="No" size="50" maxlength="75" tabindex="9">
				</TD>
				<TD>
					<CFSELECT name="STATUSID" id="STATUSID" size="1" query="ListStatus" value="STATUSID" display="STATUSNAME" selected="#GetOrientStats.STATUSID#" required="No" tabindex="10"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" colspan="2"><H4><LABEL for="DEPARTMENTID">*Department</LABEL></H4></TH>
				
			</TR>
			<TR>
				<TD align="left" valign="TOP" colspan="2">
					<CFSELECT name="DEPARTMENTID" id="DEPARTMENTID" size="1" query="ListDepartments" value="DEPARTMENTID" display="DEPARTMENTNAME" selected="#GetOrientStats.DEPARTMENTID#" required="No" tabindex="11"></CFSELECT>
				</TD>
				
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="PARTICIPANTQTY">*Number of Participants</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="ROOMID">*Room</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="PARTICIPANTQTY" id="PARTICIPANTQTY" value="#GetOrientStats.PARTICIPANTQTY#" align="LEFT" required="No" size="8" tabindex="12">
				</TD>
				<TD align="left">
					<CFSELECT name="ROOMID" id="ROOMID" size="1" query="ListRooms" value="ROOMID" display="ROOMNAME" selected="#GetOrientStats.ROOMID#" required="No" tabindex="13"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="USEDCLICKERS">Did You Use Clickers?</LABEL></TH>
				<TH align="left"><LABEL for="USEDTABLETPCS">Did You Use Tablet Computers?</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="USEDCLICKERS" id="USEDCLICKERS" size="1" tabindex="14">
						<OPTION selected value="#GetOrientStats.USEDCLICKERS#">#GetOrientStats.USEDCLICKERS#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left" nowrap>
					<CFSELECT name="USEDTABLETPCS" id="USEDTABLETPCS" size="1" tabindex="15">
						<OPTION selected value="#GetOrientStats.USEDTABLETPCS#">#GetOrientStats.USEDTABLETPCS#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="TOP"><H4><LABEL for="PRESENTLENGTHID">*Presentation Length</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="SEMESTERID">*Semester</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="PRESENTLENGTHID" id="PRESENTLENGTHID" size="1" query="ListPresentLengths" value="PRESENTLENGTHID" display="PRESENTLENGTHTEXT" selected="#GetOrientStats.PRESENTLENGTHID#" required="No" tabindex="16"></CFSELECT>
				</TD>
				<TD align="LEFT" valign="TOP">
					<CFSELECT name="SEMESTERID" id="SEMESTERID" size="1" query="ListSemesters" value="SEMESTERID" display="SEMESTERNAME" selected="#GetOrientStats.SEMESTERID#" required="No" tabindex="17"></CFSELECT><BR />
					<COM>Note: &nbsp;&nbsp;&nbsp;&nbsp;Summer is the first semester of the academic year.</COM>
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="MONTHID">*Month</LABEL></H4></TH>	
				<TH align="left"><H4><LABEL for="DAYID">*Day</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="MONTHID" id="MONTHID" size="1" query="ListMonths" value="MONTHID" display="MONTHNAME" selected="#GetOrientStats.MONTHID#" required="No" tabindex="18"></CFSELECT>
				</TD>
				<TD>
					<CFSELECT name="DAYID" id="DAYID" size="1" query="ListDays" value="DAYID" display="DAYTEXT" selected="#GetOrientStats.DAYID#" required="No" tabindex="19"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="ACADEMICYEARID">*Academic Year</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="STARTTIMEID">*Start Time</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="ACADEMICYEARID" id="ACADEMICYEARID" size="1" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#GetOrientStats.ACADEMICYEARID#" tabindex="20"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">
					<CFSELECT name="STARTTIMEID" id="STARTTIMEID" size="1" query="ListStartTime" value="HOURSID" display="HOURSTEXT" selected="#GetOrientStats.STARTTIMEID#" required="No" tabindex="21"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessOrientStats" value="MODIFY" tabindex="22" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessOrientStats" value="DELETE" tabindex="23" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/instruction/orientstats.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessOrientStats" value="Cancel" tabindex="24" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</HTML>
</CFOUTPUT>