<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: orientstatsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/29/2012 --->
<!--- Date in Production: 06/29/2012 --->
<!--- Module: Instruction - Orientation Statistics Instructor Reports --->
<!-- Last modified by John R. Pastori on 06/29/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/orientstatsdbreport.cfm">
<CFSET CONTENT_UPDATED = "June 29, 2012">

<CFOUTPUT>

<CFIF (FIND('wiki', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "WIKI")>
	<CFSET SESSION.ORIGINSERVER = "WIKI">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSEIF (FIND('#application.type#apps/forms', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "forms")>
	<CFSET SESSION.ORIGINSERVER = "FORMS">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSE>
	<CFINCLUDE template = "../programsecuritycheck.cfm">
	<CFSET SESSION.ORIGINSERVER = "">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
</CFIF>

<HTML>
<HEAD>
	<TITLE>Instruction - Orientation Statistics Instructor Reports</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to Instruction - Orientation Statistics Instructor Reports";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

//
</SCRIPT>
<!--Script ends here -->
</HEAD>

<CFIF NOT IsDefined("URL.PROCESS")>
	<CFSET CURSORFIELD = "document.LOOKUP.REPORTCHOICE[0].focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFIF NOT IsDefined("URL.PROCESS")>

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

	<CFQUERY name="ListAcademicYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
		FROM		FISCALYEARS
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<CFQUERY name="LookupCurrentAcademicYear" datasource="#application.type#LIBSHAREDDATA">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
		FROM		FISCALYEARS
		WHERE	(CURRENTACADEMICYEAR = 'YES')
		ORDER BY	FISCALYEARID
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Select Data for Instruction - Orientation Statistics Instructor Reports</H1>
			</TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" action="/#application.type#apps/instruction/orientstatsdbreport.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>SELECT ONE OF THE THREE REPORTS BELOW</COM></TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="2">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE1">REPORT 1: &nbsp;&nbsp;All Orientation Statistics</LABEL></TH>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="3">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE2">REPORT 2: &nbsp;&nbsp;Orientation Statistics</LABEL> - <LABEL for="INSTRUCTORID1">Select a Specific Instructor</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CFSELECT name="INSTRUCTORID1" id="INSTRUCTORID1" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="5">
			</TD>
			<TH align="left" valign="TOP">
				<LABEL for="REPORTCHOICE3">REPORT 3: &nbsp;&nbsp;Orientation Statistics For A Specific Instructor in a Range of Academic Years</LABEL><BR />
				<FONT color="BLUE">(<LABEL for="INSTRUCTORID2">Select an Instructor</LABEL> and a BEGIN and END Academic Year Range.)</FONT>
			</TH>
			<TD align="LEFT" valign="TOP">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CFSELECT name="INSTRUCTORID2" id="INSTRUCTORID2" size="1" query="ListInstructors" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="6"></CFSELECT><BR />
				<LABEL for="ACADEMICYEARID1">Begin Academic Year</LABEL>&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="ACADEMICYEARID2">End Academic Year</LABEL><BR />
				&nbsp;&nbsp;&nbsp;&nbsp;<CFSELECT name="ACADEMICYEARID1" id="ACADEMICYEARID1" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentAcademicYear.FISCALYEARID#" tabindex="7"></CFSELECT>&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;<CFSELECT name="ACADEMICYEARID2" id="ACADEMICYEARID2" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentAcademicYear.FISCALYEARID#" tabindex="8"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP"><INPUT type="SUBMIT" value="Select Options" tabindex="9" /></TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="SUBMIT" value="Cancel" tabindex="10" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

	<CFEXIT>
<CFELSE>

<!--- 
*******************************************************************************************************
* The following code is the Instruction - Orientation Statistics Instructor Report Generation Process. *
*******************************************************************************************************
 --->

	<CFSET OSLRECORDCOUNT = 0>
	<CFSET PRESENTLENGTHSUM = 0>
	<CFSET REPORTTITLE = ''>
	<CFSET PARTICIPANTQTYSUM = 0>

	<CFIF #FORM.REPORTCHOICE# EQ 1>
	
		<CFSET REPORTTITLE = 'REPORT 1: &nbsp;&nbsp;All Orientation Statistics'>
		<CFQUERY name="LookupOrientStatsInstructor" datasource="#application.type#INSTRUCTION" blockfactor="100">
			SELECT	OS.ORIENTSTATSID, OS.INSTRUCTOR1ID, INSTR1.FULLNAME AS INSTRUCTOR1, OS.INSTRUCTOR2ID, INSTR2.FULLNAME AS INSTRUCTOR2, 
					OS.INSTRUCTOR3ID, INSTR3.FULLNAME AS INSTRUCTOR3
			FROM		ORIENTSTATS OS, LIBSHAREDDATAMGR.CUSTOMERS INSTR1, LIBSHAREDDATAMGR.CUSTOMERS INSTR2, LIBSHAREDDATAMGR.CUSTOMERS INSTR3
			WHERE	OS.ORIENTSTATSID > 0 AND
					OS.INSTRUCTOR1ID = INSTR1.CUSTOMERID AND
					OS.INSTRUCTOR2ID = INSTR2.CUSTOMERID AND 
					OS.INSTRUCTOR3ID = INSTR3.CUSTOMERID
			ORDER BY	INSTRUCTOR1
			</CFQUERY>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 2>
		
		<CFQUERY name="ListInstructors" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUSTOMERID, LASTNAME, FIRSTNAME, INITIALS, CATEGORYID, EMAIL, CAMPUSPHONE, SECONDCAMPUSPHONE, CELLPHONE, FAX,
					FULLNAME, DIALINGCAPABILITY, LONGDISTAUTHCODE, NUMBERLISTED, UNITID, LOCATIONID, UNITHEAD, DEPTCHAIR, ALLOWEDTOAPPROVE,
					CONTACTBY, SECURITYLEVELID, PASSWORD, BIBLIOGRAPHER, COMMENTS, AA_COMMENTS, MODIFIEDBYID, MODIFIEDDATE, ACTIVE, REDID
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.INSTRUCTORID1#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>
		<CFSET REPORTTITLE = 'REPORT 2: &nbsp;&nbsp;Orientation Statistics For A Specific Instructor: &nbsp;&nbsp;&nbsp;&nbsp;#ListInstructors.FULLNAME#'>

		<CFQUERY name="LookupOrientStatsInstructor" datasource="#application.type#INSTRUCTION">
			SELECT	OS.ORIENTSTATSID, OS.INSTRUCTOR1ID, INSTR1.FULLNAME AS INSTRUCTOR1, OS.INSTRUCTOR2ID, INSTR2.FULLNAME AS INSTRUCTOR2, 
					OS.INSTRUCTOR3ID, INSTR3.FULLNAME AS INSTRUCTOR3, OS.ACADEMICYEARID
			FROM		ORIENTSTATS OS, LIBSHAREDDATAMGR.CUSTOMERS INSTR1, LIBSHAREDDATAMGR.CUSTOMERS INSTR2, LIBSHAREDDATAMGR.CUSTOMERS INSTR3
			WHERE	OS.ORIENTSTATSID > 0 AND
					(OS.INSTRUCTOR1ID = <CFQUERYPARAM value="#FORM.INSTRUCTORID1#" cfsqltype="CF_SQL_NUMERIC"> OR 
					OS.INSTRUCTOR2ID = <CFQUERYPARAM value="#FORM.INSTRUCTORID1#" cfsqltype="CF_SQL_NUMERIC"> OR 
					OS.INSTRUCTOR3ID = <CFQUERYPARAM value="#FORM.INSTRUCTORID1#" cfsqltype="CF_SQL_NUMERIC">) AND
					OS.INSTRUCTOR1ID = INSTR1.CUSTOMERID AND
					OS.INSTRUCTOR2ID = INSTR2.CUSTOMERID AND 
					OS.INSTRUCTOR3ID = INSTR3.CUSTOMERID		
			ORDER BY	OS.ACADEMICYEARID, OS.MONTHID, OS.DAYID
		</CFQUERY>
	</CFIF>
	
	<CFIF #FORM.REPORTCHOICE# EQ 3>
		
		<CFQUERY name="ListInstructors" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FIRSTNAME, INITIALS, CATEGORYID, EMAIL, CAMPUSPHONE, SECONDCAMPUSPHONE, CELLPHONE, FAX,
					FULLNAME, DIALINGCAPABILITY, LONGDISTAUTHCODE, NUMBERLISTED, UNITID, LOCATIONID, UNITHEAD, DEPTCHAIR, ALLOWEDTOAPPROVE,
					CONTACTBY, SECURITYLEVELID, PASSWORD, BIBLIOGRAPHER, COMMENTS, AA_COMMENTS, MODIFIEDBYID, MODIFIEDDATE, ACTIVE, REDID
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.INSTRUCTORID2#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFQUERY name="BeginAcademicYear" datasource="#application.type#LIBSHAREDDATA">
			SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
			FROM		FISCALYEARS
			WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.ACADEMICYEARID1#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FISCALYEARID
		</CFQUERY>

		<CFQUERY name="EndAcademicYear" datasource="#application.type#LIBSHAREDDATA">
			SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
			FROM		FISCALYEARS
			WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.ACADEMICYEARID2#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FISCALYEARID
		</CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 3: &nbsp;&nbsp;Orientation Statistics For A Specific Instructor: &nbsp;&nbsp;&nbsp;&nbsp;#ListInstructors.FULLNAME#<BR>
						  And Range of Academic Years: #BeginAcademicYear.FISCALYEAR_4DIGIT# THRU #EndAcademicYear.FISCALYEAR_4DIGIT#'>
		<CFSET ACADEMICYEAR = 0>
		<CFSET AYOSLRECORDCOUNT = 0>
		<CFSET AYPRESENTLENGTHSUM = 0>
		<CFSET AYPARTICIPANTQTYSUM = 0>

		<CFQUERY name="LookupOrientStatsInstructor" datasource="#application.type#INSTRUCTION">
			SELECT	OS.ORIENTSTATSID, OS.INSTRUCTOR1ID, INSTR1.FULLNAME AS INSTRUCTOR1, OS.INSTRUCTOR2ID, INSTR2.FULLNAME AS INSTRUCTOR2, 
					OS.INSTRUCTOR3ID, INSTR3.FULLNAME AS INSTRUCTOR3, OS.ACADEMICYEARID, OS.MONTHID, OS.DAYID
			FROM		ORIENTSTATS OS, LIBSHAREDDATAMGR.CUSTOMERS INSTR1, LIBSHAREDDATAMGR.CUSTOMERS INSTR2, LIBSHAREDDATAMGR.CUSTOMERS INSTR3
			WHERE	(OS.ORIENTSTATSID > 0 AND
					(OS.INSTRUCTOR1ID = <CFQUERYPARAM value="#FORM.INSTRUCTORID2#" cfsqltype="CF_SQL_NUMERIC"> OR 
					OS.INSTRUCTOR2ID = <CFQUERYPARAM value="#FORM.INSTRUCTORID2#" cfsqltype="CF_SQL_NUMERIC"> OR 
					OS.INSTRUCTOR3ID = <CFQUERYPARAM value="#FORM.INSTRUCTORID2#" cfsqltype="CF_SQL_NUMERIC">) AND
					OS.INSTRUCTOR1ID = INSTR1.CUSTOMERID AND
					OS.INSTRUCTOR2ID = INSTR2.CUSTOMERID AND 
					OS.INSTRUCTOR3ID = INSTR3.CUSTOMERID AND
					(OS.ACADEMICYEARID BETWEEN #val(BeginAcademicYear.FISCALYEARID)# AND #val(EndAcademicYear.FISCALYEARID)#))
			ORDER BY	OS.ACADEMICYEARID, OS.MONTHID, OS.DAYID
		</CFQUERY>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center">
			<H1>Instruction - Orientation Statistics Instructor Report
			<H2>#REPORTTITLE#
		</H2></H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE  width="100%" align="center" border="0">
	<TR>
<CFFORM action="/#application.type#apps/instruction/orientstatsdbreport.cfm" method="POST">
		<TD align="left">
			<INPUT type="submit" value="Cancel" tabindex="1" />
		</TD>
</CFFORM>
	</TR>
	
	<CFLOOP query="LookupOrientStatsInstructor">

<CFIF #FORM.REPORTCHOICE# EQ 1>
	<TR>
		<TH align="center"><u>Instructor 1</u></TH>
		<TH align="center"><u>Instructor 2</u></TH>
		<TH align="center"><u>Instructor 3</u></TH>
	</TR>

	<TR>
		<TD align="center" valign="TOP"><DIV><COM>#LookupOrientStatsInstructor.INSTRUCTOR1#</COM></DIV></TD>
	<CFIF #LookupOrientStatsInstructor.INSTRUCTOR2ID# GT 0>
		<TD align="center" valign="TOP"><DIV><COM>#LookupOrientStatsInstructor.INSTRUCTOR2#</COM></DIV></TD>
	<CFELSE>
		<TD align="center" valign="TOP"><DIV><COM>NONE</COM></DIV></TD>
	</CFIF>
	<CFIF #LookupOrientStatsInstructor.INSTRUCTOR2ID# GT 0>
		<TD align="center" valign="TOP"><DIV><COM>#LookupOrientStatsInstructor.INSTRUCTOR3#</COM></DIV></TD>
	<CFELSE>
		<TD align="center" valign="TOP"><DIV><COM>NONE</COM></DIV></TD>
	</CFIF>
	</TR>
</CFIF>
		<CFQUERY name="LookupOrientStatsInstructorDetail" datasource="#application.type#INSTRUCTION">
			SELECT	DISTINCT OS.ORIENTSTATSID, OS.INSTRUCTOR1ID, INSTR1.FULLNAME AS INSTRUCTOR1, OS.INSTRUCTOR2ID, INSTR2.FULLNAME AS INSTRUCTOR2, 
					OS.INSTRUCTOR3ID, INSTR3.FULLNAME AS INSTRUCTOR3, OS.FACULTYCONTACT, OS.COURSENUMBER, OS.CATEGORYID, C.CATEGORYNAME,
					OS.DEPARTMENTID, DEPT.DEPARTMENTNAME, OS.SDSURELATED, OS.PARTICIPANTQTY, OS.STATUSID, S.STATUSNAME, OS.ROOMID, R.ROOMNAME,
					OS.COURSENUMBER, OS.MONTHID, M.MONTHNAME, OS.DAYID, D.DAYTEXT, OS.ACADEMICYEARID, FY.FISCALYEAR_4DIGIT, OS.STARTTIMEID,
					H.HOURSTEXT, OS.PRESENTLENGTHID, PL.PRESENTLENGTHTEXT, PL.PRESENTLENGTH 
			FROM		ORIENTSTATS OS, LIBSHAREDDATAMGR.CUSTOMERS INSTR1, LIBSHAREDDATAMGR.CUSTOMERS INSTR2, LIBSHAREDDATAMGR.CUSTOMERS INSTR3,
					CATEGORY C, DEPARTMENTS DEPT, STATUS S, ROOMS R, LIBSHAREDDATAMGR.MONTHS M, LIBSHAREDDATAMGR.DAYS D, LIBSHAREDDATAMGR.FISCALYEARS FY,
					LIBSHAREDDATAMGR.HOURS H, PRESENTLENGTHS PL
			WHERE	OS.ORIENTSTATSID > 0 AND
					OS.ORIENTSTATSID = <CFQUERYPARAM value="#LookupOrientStatsInstructor.ORIENTSTATSID#" cfsqltype="CF_SQL_NUMERIC"> AND
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
					OS.PRESENTLENGTHID = PL.PRESENTLENGTHID
			ORDER BY	INSTRUCTOR1, FY.FISCALYEAR_4DIGIT
		</CFQUERY>

		<CFLOOP query="LookupOrientStatsInstructorDetail">
			<CFSET OSLRECORDCOUNT = #OSLRECORDCOUNT# + 1>
			<CFSET PRESENTLENGTHSUM = #PRESENTLENGTHSUM# + #LookupOrientStatsInstructorDetail.PRESENTLENGTH#>
			<CFSET PARTICIPANTQTYSUM = #PARTICIPANTQTYSUM# + #LookupOrientStatsInstructorDetail.PARTICIPANTQTY#>
			<CFIF #FORM.REPORTCHOICE# EQ 3>
				<CFIF #ACADEMICYEAR# GT 0>
					<CFIF #ACADEMICYEAR# NEQ #LookupOrientStatsInstructorDetail.ACADEMICYEARID#>
						<CFQUERY name="LookupAcademicYear" datasource="#application.type#LIBSHAREDDATA">
							SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
							FROM		FISCALYEARS
							WHERE	FISCALYEARID = <CFQUERYPARAM value="#ACADEMICYEAR#" cfsqltype="CF_SQL_NUMERIC">
							ORDER BY	FISCALYEARID
						</CFQUERY>
	<TR>
		<TH align="CENTER" colspan="11">
			<H2> For Academic Year #LookupAcademicYear.FISCALYEAR_4DIGIT#, #AYOSLRECORDCOUNT# Orientation Statistics Instructor records were selected.<BR />
			Total Academic Year #LookupAcademicYear.FISCALYEAR_4DIGIT# Presentation Length = #NUMBERFORMAT(AYPRESENTLENGTHSUM, '99.99')#<BR />
			Total Academic Year #LookupAcademicYear.FISCALYEAR_4DIGIT# Participant Quantity = #AYPARTICIPANTQTYSUM# 
		</H2></TH>
	</TR>
	<TR>
		<TD align="CENTER" colspan="11"><HR size="5" noshade /></TD>
	</TR>
						<CFSET ACADEMICYEAR = #LookupOrientStatsInstructorDetail.ACADEMICYEARID#>
						<CFSET AYOSLRECORDCOUNT = 1>
						<CFSET AYPRESENTLENGTHSUM = #LookupOrientStatsInstructorDetail.PRESENTLENGTH#>
						<CFSET AYPARTICIPANTQTYSUM = #LookupOrientStatsInstructorDetail.PARTICIPANTQTY#>
					<CFELSE>
						<CFSET AYOSLRECORDCOUNT = #AYOSLRECORDCOUNT# + 1>	
						<CFSET AYPRESENTLENGTHSUM = #AYPRESENTLENGTHSUM# + #LookupOrientStatsInstructorDetail.PRESENTLENGTH#>
						<CFSET AYPARTICIPANTQTYSUM = #AYPARTICIPANTQTYSUM# + #LookupOrientStatsInstructorDetail.PARTICIPANTQTY#>
					</CFIF>
				<CFELSE>
					<CFSET ACADEMICYEAR = #LookupOrientStatsInstructorDetail.ACADEMICYEARID#>
					<CFSET AYOSLRECORDCOUNT = 1>	
					<CFSET AYPRESENTLENGTHSUM = #LookupOrientStatsInstructorDetail.PRESENTLENGTH#>
					<CFSET AYPARTICIPANTQTYSUM = #LookupOrientStatsInstructorDetail.PARTICIPANTQTY#>
				</CFIF>
			</CFIF>				
	<TR>
		<TH align="center" valign="Bottom">Faculty Contact</TH>
		<TH align="center" valign="Bottom">Category</TH>
		<TH align="center" valign="Bottom">Course Number</TH>
		<TH align="center" valign="Bottom">Month</TH>
		<TH align="center" valign="Bottom">Day</TH>
		<TH align="center" valign="Bottom">Start Time</TH>
		<TH align="center" valign="Bottom">Room</TH>
		<TH align="center" valign="Bottom">Number of Participants</TH>
		<TH align="center" valign="Bottom">Presentation Length</TH>
		<TH align="center" valign="Bottom">SDSU Related</TH>
		<TH align="center" valign="Bottom">Status</TH>
	</TR>
	<TR>
		<TD align="center" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.FACULTYCONTACT#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.CATEGORYNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsInstructorDetail.COURSENUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsInstructorDetail.MONTHNAME#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.DAYTEXT#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsInstructorDetail.HOURSTEXT#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsInstructorDetail.ROOMNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsInstructorDetail.PARTICIPANTQTY#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#LookupOrientStatsInstructorDetail.PRESENTLENGTHTEXT#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsInstructorDetail.SDSURELATED#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsInstructorDetail.STATUSNAME#</DIV></TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="TOP" colspan="3"><DIV>#LookupOrientStatsInstructorDetail.DEPARTMENTNAME#</DIV></TD>
		<TD align="LEFT" valign="TOP" colspan="3"><DIV>#LookupOrientStatsInstructorDetail.FISCALYEAR_4DIGIT#</DIV></TD>
	</TR>
		</CFLOOP>
	<TR>
		<TD align="CENTER" colspan="11"><HR /></TD>
	</TR>
	</CFLOOP>
	
	<CFIF #FORM.REPORTCHOICE# EQ 3>
		<CFQUERY name="LookupAcademicYear" datasource="#application.type#LIBSHAREDDATA">
			SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
			FROM		FISCALYEARS
			WHERE	FISCALYEARID = <CFQUERYPARAM value="#ACADEMICYEAR#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FISCALYEARID
		</CFQUERY>
	<TR>
		<TH align="CENTER" colspan="11">
			<H2> For Academic Year #LookupAcademicYear.FISCALYEAR_4DIGIT#, #AYOSLRECORDCOUNT# Orientation Statistics Instructor records were selected.<BR />
			Total Academic Year #LookupAcademicYear.FISCALYEAR_4DIGIT# Presentation Length = #NUMBERFORMAT(AYPRESENTLENGTHSUM, '99.99')#<BR />
			Total Academic Year #LookupAcademicYear.FISCALYEAR_4DIGIT# Participant Quantity = #AYPARTICIPANTQTYSUM# 
		</H2></TH>
	</TR>
	</CFIF>
	<TR>
		<TD align="CENTER" colspan="11"><HR size="5" noshade /></TD>
	</TR>
	<TR>
		<TD align="CENTER" colspan="11">
			<STRONG>#OSLRECORDCOUNT# Orientation Statistics Instructor records were selected.<BR />
			Total Presentation Length = #NUMBERFORMAT(PRESENTLENGTHSUM, '99.99')#<BR />
			Total Participant Quantity = #PARTICIPANTQTYSUM#</STRONG> 
		</TD>
	</TR>
		
	<TR>
<CFFORM action="/#application.type#apps/instruction/orientstatsdbreport.cfm" method="POST">
		<TD align="left">
			<INPUT type="submit" value="Cancel" tabindex="2" />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="11">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>

</CFIF>

</BODY>
</HTML>
</CFOUTPUT>