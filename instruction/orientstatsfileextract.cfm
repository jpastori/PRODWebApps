<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: orientstatsfileextract.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/10/2013 --->
<!--- Date in Production: 05/10/2013 --->
<!--- Module: Instruction - Orientation Statistics Instructor Reports --->
<!-- Last modified by John R. Pastori on 05/10/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/orientstatsfileextract.cfm">
<CFSET CONTENT_UPDATED = "May 10, 2013">

<CFOUTPUT>



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


<BODY>

<!--- 
****************************************************************************************
* The following code is the Instruction - Orientation File Extract Generation Process. *
****************************************************************************************
 --->

<CFSET FY2002_2003_COUNTER = 0 >
<CFSET FY2003_2004_COUNTER = 0 >
<CFSET FY2004_2005_COUNTER = 0 >
<CFSET FY2005_2006_COUNTER = 0 >
<CFSET FY2006_2007_COUNTER = 0 >
<CFSET FY2007_2008_COUNTER = 0 >
<CFSET FY2008_2009_COUNTER = 0 >
<CFSET FY2009_2010_COUNTER = 0 >
<CFSET FY2010_2011_COUNTER = 0 >
<CFSET FY2011_2012_COUNTER = 0 >
<CFSET FY2012_2013_COUNTER = 0 >

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

<CFQUERY name="LookupOrientStatsDetail" datasource="#application.type#INSTRUCTION">
     SELECT	INSTR1.FULLNAME AS INSTRUCTOR1, INSTR2.FULLNAME AS INSTRUCTOR2, OS.FACULTYCONTACT AS FACULTY_CONTACT, OS.COURSENUMBER AS COURSE_NUMBER,
     		OS.PARTICIPANTQTY AS NUMBER_OF_PARTICIPANTS, M.MONTHNAME AS MONTH, D.DAYTEXT AS DAY, OS.ACADEMICYEARID, FY.FISCALYEAR_4DIGIT AS ACADEMIC_YEAR, 
               H.HOURSTEXT AS START_TIME, PL.PRESENTLENGTHTEXT AS PRESENTATION_LENGTH, R.ROOMNAME AS ROOM, S.STATUSNAME AS STATUS, 
               C.CATEGORYNAME AS CATEGORY, DEPT.DEPARTMENTNAME AS DEPARTMENT, OS.USEDCLICKERS AS USED_CLICKERS, OS.USEDTABLETPCS AS USED_TABLET_PCS,
               INSTR3.FULLNAME AS INSTRUCTOR3, OS.SDSURELATED AS SDSU_RELATED, SEM.SEMESTERNAME AS SEMESTER               
     FROM		ORIENTSTATS OS, LIBSHAREDDATAMGR.CUSTOMERS INSTR1, LIBSHAREDDATAMGR.CUSTOMERS INSTR2, LIBSHAREDDATAMGR.MONTHS M, LIBSHAREDDATAMGR.DAYS D,
     		LIBSHAREDDATAMGR.FISCALYEARS FY, LIBSHAREDDATAMGR.HOURS H, PRESENTLENGTHS PL, ROOMS R, STATUS S, CATEGORY C, DEPARTMENTS DEPT,
               LIBSHAREDDATAMGR.CUSTOMERS INSTR3, LIBSHAREDDATAMGR.SEMESTERS SEM
     WHERE	OS.ORIENTSTATSID > 0 AND
               OS.INSTRUCTOR1ID = INSTR1.CUSTOMERID AND
               OS.INSTRUCTOR2ID = INSTR2.CUSTOMERID AND
               OS.MONTHID = M.MONTHID AND
               OS.DAYID = D.DAYID AND
               OS.ACADEMICYEARID = FY.FISCALYEARID AND
          	OS.ACADEMICYEARID IN (18,19,20,21) AND
<!---               OS.ACADEMICYEARID IN (22,23,24,25,26) AND --->
<!---          OS.ACADEMICYEARID IN (27,28) AND --->
               OS.STARTTIMEID = H.HOURSID AND
               OS.PRESENTLENGTHID = PL.PRESENTLENGTHID AND
               OS.ROOMID = R.ROOMID AND
               OS.STATUSID = S.STATUSID AND
               OS.CATEGORYID = C.CATEGORYID AND
               OS.DEPARTMENTID = DEPT.DEPARTMENTID AND
               OS.INSTRUCTOR3ID = INSTR3.CUSTOMERID AND
               OS.SEMESTERID = SEM.SEMESTERID
     ORDER BY	ACADEMIC_YEAR DESC, OS.MONTHID, OS.DAYID 
</CFQUERY>

<cfspreadsheet  
    action="write" 
    filename = "/home/www/lfolkscf/htdocs/#application.type#apps/instruction/exceldata/instructdata_20022006.xls" 
    overwrite = "true" 
    query = "LookupOrientStatsDetail" 
    sheetname = "instructiondata" >
    
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center">
			<H1>Instruction - Orientation Statistics Instructor Report</H1>
          </TD>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
     <TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
		<TD align="left" colspan="19">
			<INPUT type="submit" value="Cancel" tabindex="1" />
		</TD>
</CFFORM>
	</TR>

     <TR>
		<TH align="center"><u>Instructor 1</u></TH>
		<TH align="center"><u>Instructor 2</u></TH>		
          <TH align="center" valign="Bottom"><u>Faculty Contact</u></TH>
		<TH align="center" valign="Bottom"><u>Course Number</u></TH>
		<TH align="center" valign="Bottom"><u>Number of Participants</u></TH>
		<TH align="center" valign="Bottom"><u>Month</u></TH>
		<TH align="center" valign="Bottom"><u>Day</u></TH>
          <TH align="center" valign="Bottom"><u>Academic Year</u></TH>
		<TH align="center" valign="Bottom"><u>Start Time</u></TH>
		<TH align="center" valign="Bottom"><u>Presentation Length</u></TH>
		<TH align="center" valign="Bottom"><u>Room</u></TH>
		<TH align="center" valign="Bottom"><u>Status</u></TH>
          <TH align="center" valign="Bottom"><u>Category</u></TH>
          <TH align="center" valign="Bottom"><u>Department</u></TH>
          <TH align="center" valign="Bottom"><u>Did You Use Clickers?</u></TH>
          <TH align="center" valign="Bottom"><u>Did You Use Tablet Computers?</u></TH>
          <TH align="center"><u>Instructor 3</u></TH>
		<TH align="center" valign="Bottom"><u>SDSU Related</u></TH>
          <TH align="center" valign="Bottom"><u>Semester</u></TH>

	</TR>
<CFLOOP query="LookupOrientStatsDetail">

	<CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 18>
     	<CFSET FY2002_2003_COUNTER = FY2002_2003_COUNTER + 1 >
     </CFIF>
     <CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 19>
     	<CFSET FY2003_2004_COUNTER = FY2003_2004_COUNTER + 1 >
     </CFIF>
     <CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 20>
     	<CFSET FY2004_2005_COUNTER = FY2004_2005_COUNTER + 1 >
     </CFIF>
     <CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 21>
     	<CFSET FY2005_2006_COUNTER = FY2005_2006_COUNTER + 1 >
     </CFIF>
     <CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 22>
     	<CFSET FY2006_2007_COUNTER = FY2006_2007_COUNTER + 1 >
     </CFIF>
     <CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 23>
     	<CFSET FY2007_2008_COUNTER = FY2007_2008_COUNTER + 1 >
     </CFIF>
     <CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 24>
     	<CFSET FY2008_2009_COUNTER = FY2008_2009_COUNTER + 1 >
     </CFIF>
     <CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 25>
     	<CFSET FY2009_2010_COUNTER = FY2009_2010_COUNTER + 1 >
     </CFIF>
	<CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 26>
     	<CFSET FY2010_2011_COUNTER = FY2010_2011_COUNTER + 1 >
     </CFIF>
	<CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 27>
     	<CFSET FY2011_2012_COUNTER = FY2011_2012_COUNTER + 1 >
     </CFIF>
     <CFIF #LookupOrientStatsDetail.ACADEMICYEARID# EQ 28>
     	<CFSET FY2012_2013_COUNTER = FY2012_2013_COUNTER + 1 >
     </CFIF>
     	
	
	<TR>
     	<TD align="center" valign="TOP"><DIV><COM>#LookupOrientStatsDetail.INSTRUCTOR1#</COM></DIV></TD>
		<TD align="center" valign="TOP"><DIV><COM>#LookupOrientStatsDetail.INSTRUCTOR2#</COM></DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#LookupOrientStatsDetail.FACULTY_CONTACT#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsDetail.COURSE_NUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsDetail.NUMBER_OF_PARTICIPANTS#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsDetail.MONTH#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#LookupOrientStatsDetail.DAY#</DIV></TD>
          <TD align="LEFT" valign="TOP"><DIV>#LookupOrientStatsDetail.ACADEMIC_YEAR#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsDetail.START_TIME#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#LookupOrientStatsDetail.PRESENTATION_LENGTH#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsDetail.ROOM#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsDetail.STATUS#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#LookupOrientStatsDetail.CATEGORY#</DIV></TD>
		<TD align="LEFT" valign="TOP"><DIV>#LookupOrientStatsDetail.DEPARTMENT#</DIV></TD>
          <TD align="LEFT" valign="TOP"><DIV>#LookupOrientStatsDetail.USED_CLICKERS#</DIV></TD>
          <TD align="LEFT" valign="TOP"><DIV>#LookupOrientStatsDetail.USED_TABLET_PCS#</DIV></TD>
          <TD align="center" valign="TOP"><DIV><COM>#LookupOrientStatsDetail.INSTRUCTOR3#</COM></DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupOrientStatsDetail.SDSU_RELATED#</DIV></TD>
          <TD align="center" valign="TOP"><DIV>#LookupOrientStatsDetail.SEMESTER#</DIV></TD>
	</TR>
     <TR>
		<TD align="CENTER" colspan="19"><HR /></TD>
	</TR>
</CFLOOP>

	<TR>
     <CFIF FY2002_2003_COUNTER GT 0>
		<TD align="LEFT" COLSPAN="10" NOWRAP> FISCAL YEAR 2002 2003 COUNTER = #FY2002_2003_COUNTER#</TD>
     </CFIF>
     <CFIF FY2003_2004_COUNTER GT 0>
          <TD align="LEFT" COLSPAN="9" NOWRAP> FISCAL YEAR 2003 2004 COUNTER = #FY2003_2004_COUNTER#</TD>
     </CFIF>
     </TR>
     <TR>
     <CFIF FY2004_2005_COUNTER GT 0>
		<TD align="LEFT" COLSPAN="10" NOWRAP> FISCAL YEAR 2004 2005 COUNTER = #FY2004_2005_COUNTER#</TD>
     </CFIF>
     <CFIF FY2005_2006_COUNTER GT 0>
          <TD align="LEFT" COLSPAN="9" NOWRAP> FISCAL YEAR 2005 2006 COUNTER = #FY2005_2006_COUNTER#</TD>
     </CFIF>
     </TR>
     <TR>
     <CFIF FY2006_2007_COUNTER GT 0>
		<TD align="LEFT" COLSPAN="10" NOWRAP> FISCAL YEAR 2006 2007 COUNTER = #FY2006_2007_COUNTER#</TD>
     </CFIF>
     <CFIF FY2007_2008_COUNTER GT 0>
          <TD align="LEFT" COLSPAN="9" NOWRAP> FISCAL YEAR 2007 2008 COUNTER = #FY2007_2008_COUNTER#</TD>
     </CFIF>
     </TR>
     <TR>
     <CFIF FY2008_2009_COUNTER GT 0>
		<TD align="LEFT" COLSPAN="6" NOWRAP> FISCAL YEAR 2008 2009 COUNTER = #FY2008_2009_COUNTER#</TD>
     </CFIF>
     <CFIF FY2009_2010_COUNTER GT 0>
          <TD align="LEFT" COLSPAN="6" NOWRAP> FISCAL YEAR 2009 2010 COUNTER = #FY2009_2010_COUNTER#</TD>
     </CFIF>
     <CFIF FY2010_2011_COUNTER GT 0>
          <TD align="LEFT" COLSPAN="7" NOWRAP> FISCAL YEAR 2010 2011 COUNTER = #FY2010_2011_COUNTER#</TD>
     </CFIF>
     </TR>
     <TR>
     <CFIF FY2011_2012_COUNTER GT 0>
		<TD align="LEFT" COLSPAN="10" NOWRAP> FISCAL YEAR 2011 2012 COUNTER = #FY2011_2012_COUNTER#</TD>
     </CFIF>
     <CFIF FY2012_2013_COUNTER GT 0>
          <TD align="LEFT" COLSPAN="9" NOWRAP> FISCAL YEAR 2012 2013 COUNTER = #FY2012_2013_COUNTER#</TD>
     </CFIF>
	</TR>
	<TR>   	
		<TD align="LEFT" colspan="19"><HR size="5" noshade /></TD>
	</TR>

	<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
		<TD align="left" colspan="19">
			<INPUT type="submit" value="Cancel" tabindex="2" />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="19">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>


</BODY>
</HTML>
</CFOUTPUT>