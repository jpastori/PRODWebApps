<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: orientstatscountrpts.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/29/2012 --->
<!--- Date in Production: 06/29/2012 --->
<!--- Module: Select Instruction - Orientation Statistics Count Reports --->
<!-- Last modified by John R. Pastori on 06/29/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/orientstatscountrpts.cfm">
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
	<TITLE>Select Instruction - Orientation Statistics Count Reports</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Instruction - Orientation Statistics Count Reports";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

//
</SCRIPT>
<!--Script ends here -->

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET CURSORFIELD = "document.LOOKUP.REPORTCHOICE[0].focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFIF NOT IsDefined('URL.PROCESS')>
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
			<TD align="center"><H1>Select Instruction - Orientation Statistics Count Reports</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT" border="0">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		
<CFFORM name="LOOKUP" action="/#application.type#apps/instruction/orientstatscountrpts.cfm?PROCESS=LOOKUP" method="POST">
		
		<TR>
			<TD align="LEFT" valign="TOP" colspan="2"><COM>SELECT ONE OF THE TWELVE REPORTS BELOW</COM></TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="2">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE1">REPORT 1: Student Quantity by Month Report</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="3">
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="ACADEMICYEARID1" id="ACADEMICYEARID1" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentAcademicYear.FISCALYEARID#" tabindex="4"></CFSELECT>
				<LABEL for="REPORTCHOICE2">REPORT 2: Student Quantity by Month Report</LABEL> <LABEL for="ACADEMICYEARID1">for Selected Academic Year</LABEL>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="5">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE3">REPORT 3: Student Quantity by Category & Month Report</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="ACADEMICYEARID2" id="ACADEMICYEARID2" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentAcademicYear.FISCALYEARID#" tabindex="7"></CFSELECT>
				<LABEL for="REPORTCHOICE4">REPORT 4: Student Quantity by Category & Month Report </LABEL><LABEL for="ACADEMICYEARID2">for Selected Academic Year</LABEL>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="8">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE5">REPORT 5: Presentations by Month Report</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE6" value="6" align="LEFT" required="No" tabindex="9">
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="ACADEMICYEARID3" id="ACADEMICYEARID3" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentAcademicYear.FISCALYEARID#" tabindex="10"></CFSELECT>
				<LABEL for="REPORTCHOICE6">REPORT 6: Presentations by Month Report</LABEL> <LABEL for="ACADEMICYEARID3">for Selected Academic Year</LABEL>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE7" value="7" align="LEFT" required="No" tabindex="11">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE7">REPORT 7: Presentations by Category & Month Report</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE8" value="8" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="ACADEMICYEARID4" id="ACADEMICYEARID4" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentAcademicYear.FISCALYEARID#" tabindex="13"></CFSELECT>
				<LABEL for="REPORTCHOICE8">REPORT 8: Presentations by Category & Month Report</LABEL> <LABEL for="ACADEMICYEARID4">for Selected Academic Year</LABEL>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE9" value="9" align="LEFT" required="No" tabindex="14">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE9">REPORT 9: Presentation Length by Month Report</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE10" value="10" align="LEFT" required="No" tabindex="15">
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="ACADEMICYEARID5" id="ACADEMICYEARID5" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentAcademicYear.FISCALYEARID#" tabindex="16"></CFSELECT>
				<LABEL for="REPORTCHOICE10">REPORT 10: Presentation Length by Month Report</LABEL> <LABEL for="ACADEMICYEARID5">for Selected Academic Year</LABEL>
		</TD></TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE11" value="11" align="LEFT" required="No" tabindex="17">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE11">REPORT 11: Presentation Length by Category & Month Report</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE12" value="12" align="LEFT" required="No" tabindex="18">
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="ACADEMICYEARID6" id="ACADEMICYEARID6" query="ListAcademicYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentAcademicYear.FISCALYEARID#" tabindex="19"></CFSELECT>
				<LABEL for="REPORTCHOICE12">REPORT 12: Presentation Length by Category & Month Report</LABEL> <LABEL for="ACADEMICYEARID6">for Selected Academic Year</LABEL>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP"><INPUT type="SUBMIT" value="Select Options" tabindex="20" /></TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="SUBMIT" value="Cancel" tabindex="21" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFEXIT>

<CFELSE>

<!--- 
********************************************************************************************
* The following code is the Instruction - Orientation Statistics Count Generation Process. *
********************************************************************************************
 --->

	<CFSET ACADEMICYEARFLAG = 'N'>

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'OS.MONTHID'>
	<CFSET SORTORDER[2] = 'OS.ACADEMICYEARID, OS.MONTHID'>
	<CFSET SORTORDER[3] = 'C.CATEGORYNAME, OS.MONTHID'>
	<CFSET SORTORDER[4] = 'OS.ACADEMICYEARID, C.CATEGORYNAME, OS.MONTHID'>
	<CFSET SORTORDER[5] = 'OS.MONTHID'>
	<CFSET SORTORDER[6] = 'OS.ACADEMICYEARID, OS.MONTHID'>
	<CFSET SORTORDER[7] = 'C.CATEGORYNAME, OS.MONTHID'>
	<CFSET SORTORDER[8] = 'OS.ACADEMICYEARID, C.CATEGORYNAME, OS.MONTHID'>
	<CFSET SORTORDER[9] = 'OS.MONTHID'>
	<CFSET SORTORDER[10] = 'OS.ACADEMICYEARID, OS.MONTHID'>
	<CFSET SORTORDER[11] = 'C.CATEGORYNAME, OS.MONTHID'>
	<CFSET SORTORDER[12] = 'OS.ACADEMICYEARID, C.CATEGORYNAME, OS.MONTHID'>

	<CFIF #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 6 OR #FORM.REPORTCHOICE# EQ 8 OR #FORM.REPORTCHOICE# EQ 10 OR #FORM.REPORTCHOICE# EQ 12>
		<CFSET ACADEMICYEARID = 0>
		<CFSET COUNTER = #FORM.REPORTCHOICE# / 2>
		<CFSET ACADEMICYEARID = #EVALUATE("FORM.ACADEMICYEARID#COUNTER#")#>
		<CFSET ACADEMICYEARFLAG = 'Y'>
		ACADEMIC YEAR ID = #ACADEMICYEARID#
	</CFIF>
 
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>
	<!--- REPORT ORDER = #REPORTORDER#<BR><BR> --->
	
	<CFQUERY name="ListOrientStats" datasource="#application.type#INSTRUCTION" blockfactor="100">
		SELECT	OS.ORIENTSTATSID, OS.MONTHID, M.MONTHNAME,
			<CFIF #FORM.REPORTCHOICE# GTE 1 AND #FORM.REPORTCHOICE# LTE 4>
				OS.PARTICIPANTQTY,
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 3 OR #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 7 OR #FORM.REPORTCHOICE# EQ 8 OR #FORM.REPORTCHOICE# EQ 11 OR #FORM.REPORTCHOICE# EQ 12>
				OS.CATEGORYID, C.CATEGORYNAME,
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# GTE 9 AND #FORM.REPORTCHOICE# LTE 12>
				OS.PRESENTLENGTHID, PL.PRESENTLENGTHTEXT, PL.PRESENTLENGTH,
			</CFIF>
				OS.ACADEMICYEARID, FY.FISCALYEAR_4DIGIT
		FROM		ORIENTSTATS OS, LIBSHAREDDATAMGR.MONTHS M,
			<CFIF #FORM.REPORTCHOICE# EQ 3 OR #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 7 OR #FORM.REPORTCHOICE# EQ 8 OR #FORM.REPORTCHOICE# EQ 11 OR #FORM.REPORTCHOICE# EQ 12>
				CATEGORY C,
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# GTE 9 AND #FORM.REPORTCHOICE# LTE 12>
				PRESENTLENGTHS PL, 
			</CFIF>
				LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	OS.ORIENTSTATSID > 0 AND
			<CFIF #FORM.REPORTCHOICE# EQ 3 OR #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 7 OR #FORM.REPORTCHOICE# EQ 8 OR #FORM.REPORTCHOICE# EQ 11 OR #FORM.REPORTCHOICE# EQ 12>
				OS.CATEGORYID = C.CATEGORYID AND
			</CFIF>
				OS.MONTHID = M.MONTHID AND
			
			<CFIF #FORM.REPORTCHOICE# GTE 9 AND #FORM.REPORTCHOICE# LTE 12>
				OS.PRESENTLENGTHID = PL.PRESENTLENGTHID AND
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 6 OR #FORM.REPORTCHOICE# EQ 8 OR #FORM.REPORTCHOICE# EQ 10 OR #FORM.REPORTCHOICE# EQ 12>
				OS.ACADEMICYEARID = #val(ACADEMICYEARID)# AND
			</CFIF>
				OS.ACADEMICYEARID = FY.FISCALYEARID
		ORDER BY	#REPORTORDER#
	</CFQUERY>

<!--- 
***************************************************************************************
* The following code displays the Instruction - Orientation Statistics Count Reports. *
***************************************************************************************
 --->
	<CFSET ADDFIELDNAME = "">
	<CFSET ADDFIELDQTY = 1>
	<CFSET CATEGORYNAME = "">
	<CFSET COLUMN1TITLE = "Month">
	<CFSET COLUMN2TITLE = "">
	<CFSET COMPAREMONTHNAME = "#ListOrientStats.MONTHNAME#">
	<CFSET ITEMOSCOUNT = 0>
	<CFSET TOTALOSCOUNT = 0>
	<CFSET MONTHFIELDNAME = "ListOrientStats.MONTHNAME">
	<CFSET MONTHNAME = "">

<CFIF IsDefined('ListOrientStats.CATEGORYNAME')>	
	<CFSET CATEGORYFIELDNAME = "ListOrientStats.CATEGORYNAME">
	<CFSET CATEGORYTOTAL = 0>
	<CFSET COMPARECATEGORYNAME = "#ListOrientStats.CATEGORYNAME#">
</CFIF>

<CFSWITCH expression = #FORM.REPORTCHOICE#>

	<CFCASE value = 1 >
		<CFSET ADDFIELDNAME = "ListOrientStats.PARTICIPANTQTY">
		<CFSET COLUMN2TITLE = "Total Student Quantity">
	</CFCASE>

	<CFCASE value = 2>
		<CFSET ADDFIELDNAME = "ListOrientStats.PARTICIPANTQTY">
		<CFSET COLUMN2TITLE = "Total Participant Quantity">
	</CFCASE>

	<CFCASE value = 3 >
		<CFSET ADDFIELDNAME = "ListOrientStats.PARTICIPANTQTY">
		<CFSET COLUMN2TITLE = "Total Participant Quantity">
	</CFCASE>

	<CFCASE value = 4>
		<CFSET ADDFIELDNAME = "ListOrientStats.PARTICIPANTQTY">
		<CFSET COLUMN2TITLE = "Total Participant Quantity">
	</CFCASE>

	<CFCASE value = 5>
		<CFSET ADDFIELDNAME = "ADDFIELDQTY">
		<CFSET COLUMN2TITLE = "Total Presentations">
	</CFCASE>

	<CFCASE value = 6>
		<CFSET ADDFIELDNAME = "ADDFIELDQTY">
		<CFSET COLUMN2TITLE = "Total Presentations">
	</CFCASE>

	<CFCASE value = 7>
		<CFSET ADDFIELDNAME = "ADDFIELDQTY">
		<CFSET COLUMN2TITLE = "Total Presentations">
	</CFCASE>

	<CFCASE value = 8>
		<CFSET ADDFIELDNAME = "ADDFIELDQTY">
		<CFSET COLUMN2TITLE = "Total Presentations">
	</CFCASE>

	<CFCASE value = 9>
		<CFSET ADDFIELDNAME = "ListOrientStats.PRESENTLENGTH">
		<CFSET COLUMN2TITLE = "Total Presentation Lengths">
	</CFCASE>

	<CFCASE value = 10>
		<CFSET ADDFIELDNAME = "ListOrientStats.PRESENTLENGTH">
		<CFSET COLUMN2TITLE = "Total Presentation Lengths">
	</CFCASE>

	<CFCASE value = 11>
		<CFSET ADDFIELDNAME = "ListOrientStats.PRESENTLENGTH">
		<CFSET COLUMN2TITLE = "Total Presentation Lengths">
	</CFCASE>

	<CFCASE value = 12>
		<CFSET ADDFIELDNAME = "ListOrientStats.PRESENTLENGTH">
		<CFSET COLUMN2TITLE = "Total Presentation Lengths">
	</CFCASE>

	<CFDEFAULTCASE>
		<CFSET ADDFIELDNAME = "ListOrientStats.PARTICIPANTQTY">
		<CFSET COLUMN2TITLE = "Total Participant Quantity">
	</CFDEFAULTCASE>
	
</CFSWITCH>

</CFIF>

<!--- <CFIF IsDefined('ListOrientStats.CATEGORYNAME')>
	CATEGORY FIELD NAME = #Evaluate("#CATEGORYFIELDNAME#")#<BR><BR>
	COMPARE CATEGORY NAME = #COMPARECATEGORYNAME#<BR><BR>
</CFIF>

COLUMN 1 TITLE = #COLUMN1TITLE#<BR><BR>
COLUMN 2 TITLE = #COLUMN2TITLE#<BR><BR>
MONTH FIELD NAME = #Evaluate("#MONTHFIELDNAME#")#<BR><BR>
COMPARE MONTH NAME = #COMPAREMONTHNAME#<BR><BR>  --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center">
				<H1>#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#
	<CFIF ACADEMICYEARFLAG EQ 'Y'>
				<H2>For Academic Year: &nbsp;&nbsp;#ListOrientStats.FISCALYEAR_4DIGIT#
	</CFIF>
			</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="left" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/orientstatscountrpts.cfm" method="POST">
			<TD align="left">
				<INPUT type="submit" value="Cancel" tabindex="1" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="LEFT" valign="TOP">#COLUMN1TITLE#</TH>
			<TH align="LEFT" valign="TOP">#COLUMN2TITLE#</TH>
		</TR>
	<CFIF IsDefined('ListOrientStats.CATEGORYNAME')>
		<TR>
			<TH align="LEFT" valign="TOP">#Evaluate("#CATEGORYFIELDNAME#")#</TH>
		</TR>
	</CFIF>

<CFIF #FORM.REPORTCHOICE# EQ 1 OR #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 5 OR #FORM.REPORTCHOICE# EQ 6 OR #FORM.REPORTCHOICE# EQ 9 OR #FORM.REPORTCHOICE# EQ 10>
	<CFLOOP query="ListOrientStats">
		<CFSET MONTHNAME = #Evaluate("#MONTHFIELDNAME#")#>
		<CFIF #COMPAREMONTHNAME# EQ #MONTHNAME#>
			<!--- COMPARE MONTH NAME = #COMPAREMONTHNAME#<BR><BR> --->
			<CFSET ITEMOSCOUNT = #ITEMOSCOUNT# + #Evaluate("#ADDFIELDNAME#")#>
			<!--- <BR><BR>ADDFIELDNAME 1 = #Evaluate("#ADDFIELDNAME#")#<BR><BR> --->
			<!--- ITEM OS COUNT = #ITEMOSCOUNT#<BR><BR>  --->
		<CFELSE>
		<TR>
			<TD align="LEFT" valign="TOP">
				#COMPAREMONTHNAME#
				<CFSET COMPAREMONTHNAME = #MONTHNAME#>
				<!--- <BR><BR>SET NEW MONTH NAME = #COMPAREMONTHNAME#<BR><BR>  --->
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFSET TOTALOSCOUNT  = #TOTALOSCOUNT# + #ITEMOSCOUNT#>
				<!--- TOTAL OS COUNT = #TOTALOSCOUNT#<BR><BR> --->
				<CFIF #FORM.REPORTCHOICE# LT 9>
					#ITEMOSCOUNT#
				<CFELSE>
					#NUMBERFORMAT(ITEMOSCOUNT, '99.99')#
				</CFIF>
				<CFSET ITEMOSCOUNT = #Evaluate("#ADDFIELDNAME#")#>
				<!--- <BR><BR>ADDFIELDNAME 2 = #Evaluate("#ADDFIELDNAME#")#<BR><BR>
				RESET ITEM OS COUNT = #ITEMOSCOUNT#<BR><BR>  --->
			</TD>
		</TR>
		</CFIF>
	</CFLOOP>
		<TR>
			<TD align="LEFT" valign="TOP">#MONTHNAME#</TD>
			<TD align="LEFT" valign="TOP">
				<CFIF #FORM.REPORTCHOICE# LT 9>
					#ITEMOSCOUNT#
				<CFELSE>
					#NUMBERFORMAT(ITEMOSCOUNT, '99.99')#
				</CFIF>
				<CFSET TOTALOSCOUNT = #TOTALOSCOUNT# + #ITEMOSCOUNT#>
			</TD>
		</TR>
		<TR>
			<TD colspan="2"><HR /></TD>
		</TR>
		<TR>
		<CFIF #FORM.REPORTCHOICE# LT 9>
			<TD align="LEFT" valign="TOP" colspan="2"><STRONG><u>Grand #COLUMN2TITLE# = #TOTALOSCOUNT#</u></STRONG></TD>
		<CFELSE>
			<TD align="LEFT" valign="TOP" colspan="2"><STRONG><u>Grand #COLUMN2TITLE# = #NUMBERFORMAT(TOTALOSCOUNT, '99.99')#</u></STRONG></TD>
		</CFIF>
		</TR>
</CFIF>

<CFIF #FORM.REPORTCHOICE# EQ 3 OR #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 7 OR #FORM.REPORTCHOICE# EQ 8 OR #FORM.REPORTCHOICE# EQ 11 OR #FORM.REPORTCHOICE# EQ 12>
	<CFLOOP query="ListOrientStats">
		<CFSET CATEGORYNAME = #Evaluate("#CATEGORYFIELDNAME#")#>
		<CFSET MONTHNAME = #Evaluate("#MONTHFIELDNAME#")#>
		<CFIF #COMPARECATEGORYNAME# EQ #CATEGORYNAME#>
			<CFIF #COMPAREMONTHNAME# EQ #MONTHNAME#>
				<!--- COMPARE MONTH NAME = #COMPAREMONTHNAME#<BR><BR> --->
				<CFSET ITEMOSCOUNT = #ITEMOSCOUNT# + #Evaluate("#ADDFIELDNAME#")#>
				<!--- <BR><BR>ADDFIELDNAME 1 = #Evaluate("#ADDFIELDNAME#")#<BR><BR>
				ITEM OS COUNT = #ITEMOSCOUNT#<BR><BR>  --->
			<CFELSE>
		<TR>
			<TD align="LEFT" valign="TOP">
				#COMPAREMONTHNAME#
				<CFSET COMPAREMONTHNAME = #MONTHNAME#>
				<!--- <BR><BR>SET NEW MONTH NAME = #COMPAREMONTHNAME#<BR><BR>  --->
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFSET TOTALOSCOUNT  = #TOTALOSCOUNT# + #ITEMOSCOUNT#>
				<CFSET CATEGORYTOTAL = #CATEGORYTOTAL# + #ITEMOSCOUNT#>
				<CFIF #FORM.REPORTCHOICE# LT 9>
					#ITEMOSCOUNT#
				<CFELSE>
					#NUMBERFORMAT(ITEMOSCOUNT, '99.99')#
				</CFIF>
				<!--- TOTAL OS COUNT = #TOTALOSCOUNT#<BR><BR> --->
				<CFSET ITEMOSCOUNT = #Evaluate("#ADDFIELDNAME#")#>
				<!--- <BR><BR>ADDFIELDNAME 2 = #Evaluate("#ADDFIELDNAME#")#<BR><BR>
				RESET ITEM OS COUNT = #ITEMOSCOUNT#<BR><BR>  --->
			</TD>
		</TR>
			</CFIF>
		<CFELSE>
		<TR>
			<TD align="LEFT" valign="TOP">
				#COMPAREMONTHNAME#
				<CFSET COMPAREMONTHNAME = #MONTHNAME#>
				<!--- <BR><BR>SET NEW MONTH NAME = #COMPAREMONTHNAME#<BR><BR> ---> 
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFSET TOTALOSCOUNT  = #TOTALOSCOUNT# + #ITEMOSCOUNT#>
				<CFSET CATEGORYTOTAL = #CATEGORYTOTAL# + #ITEMOSCOUNT#>
				<!--- TOTAL OS COUNT = #TOTALOSCOUNT#<BR><BR> --->
				<CFIF #FORM.REPORTCHOICE# LT 9>
					#ITEMOSCOUNT#
				<CFELSE>
					#NUMBERFORMAT(ITEMOSCOUNT, '99.99')#
				</CFIF>
				<CFSET ITEMOSCOUNT = #Evaluate("#ADDFIELDNAME#")#>
				<!--- <BR><BR>ADDFIELDNAME 2 = #Evaluate("#ADDFIELDNAME#")#<BR><BR>
				RESET ITEM OS COUNT = #ITEMOSCOUNT#<BR><BR> ---> 
			</TD>
		</TR>	
		<TR>
		
			<CFIF #FORM.REPORTCHOICE# LT 9>
			<TH align="LEFT" valign="TOP" colspan="2"><H2>Category #COMPARECATEGORYNAME# = #CATEGORYTOTAL#</H2></TH>
			<CFELSE>
			<TH align="LEFT" valign="TOP" colspan="2"><H2>Category #COMPARECATEGORYNAME# = #NUMBERFORMAT(CATEGORYTOTAL, '99.99')#</H2></TH>
			</CFIF>
		</TR>
		<TR>
			<TH align="LEFT" valign="TOP">
				<CFSET COMPARECATEGORYNAME = #CATEGORYNAME#>
				<CFSET CATEGORYTOTAL = 0>
				#Evaluate("#CATEGORYFIELDNAME#")#
			</TH>
		</TR>
		</CFIF>
	</CFLOOP>
			
		<TR>
			<TD align="LEFT" valign="TOP">#MONTHNAME#</TD>
			<TD align="LEFT" valign="TOP">
				<CFIF #FORM.REPORTCHOICE# LT 9>
					#ITEMOSCOUNT#
				<CFELSE>
					#NUMBERFORMAT(ITEMOSCOUNT, '99.99')#
				</CFIF>
				<CFSET TOTALOSCOUNT = #TOTALOSCOUNT# + #ITEMOSCOUNT#>
				<CFSET CATEGORYTOTAL = #CATEGORYTOTAL# + #ITEMOSCOUNT#>
			</TD>
		</TR>
		<TR>
			<CFIF #FORM.REPORTCHOICE# LT 9>
			<TH align="LEFT" valign="TOP" colspan="2"><H2>Category #COMPARECATEGORYNAME# = #CATEGORYTOTAL#</H2></TH>
			<CFELSE>
			<TH align="LEFT" valign="TOP" colspan="2"><H2>Category #COMPARECATEGORYNAME# = #NUMBERFORMAT(CATEGORYTOTAL, '99.99')#</H2></TH>
			</CFIF>
		</TR>

		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="2"><HR /></TD>
		</TR>

		<TR>
		<CFIF #FORM.REPORTCHOICE# LT 9>
			<TD align="CENTER" valign="TOP" colspan="2"><STRONG><u>Grand #COLUMN2TITLE# = #TOTALOSCOUNT#</u></STRONG></TD>
		<CFELSE>
			<TD align="CENTER" valign="TOP" colspan="2"><STRONG><u>Grand #COLUMN2TITLE# = #NUMBERFORMAT(TOTALOSCOUNT, '99.99')#</u></STRONG></TD>
		</CFIF>
		</TR>
</CFIF>
		<TR>
<CFFORM action="/#application.type#apps/instruction/orientstatscountrpts.cfm" method="POST">
			<TD align="left">
				<INPUT type="submit" value="Cancel" tabindex="2" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

</BODY>
</HTML>
</CFOUTPUT>