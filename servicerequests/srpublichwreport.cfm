<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: srpublichwreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/19/2012 --->
<!--- Date in Production: 11/19/2012 --->
<!--- Module: IDT Service Requests - Public Hardware / SR Report --->
<!-- Last modified by John R. Pastori on 11/19/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/srpublichwreport.cfm">
<CFSET CONTENT_UPDATED = "November 19, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Public Hardware / SR Report</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JAVASCRIPT">
	window.defaultStatus = "Welcome to IDT Service Requests";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {
		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = LOOKUP.BARCODENUMBER.value;
			LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if ((!document.LOOKUP.BARCODENUMBER.value == "3065000" && !document.LOOKUP.BARCODENUMBER.value == "") && !document.LOOKUP.BARCODENUMBER.value.length == 17) {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  A 17 character Bar Code Number MUST be entered! Spaces are counted.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}
		
		if ((document.LOOKUP.DIVISIONNUMBERBC.selectedIndex != "0") && (document.LOOKUP.DIVISIONNUMBER_TEXT.value != ""
		 && document.LOOKUP.DIVISIONNUMBER_TEXT.value != " ")) {
			alertuser ("You Can Not both select a Division Number from the dropdown and enter a Division Number in the text field.");
			document.LOOKUP.DIVISIONNUMBERBC.focus();
			return false;
		}

	}
	
	
	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT> 

<CFIF NOT IsDefined('URL.LOOKUPSR')>
	<CFSET CURSORFIELD = "document.LOOKUP.BARCODENUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*****************************************************************************************************
* The following code is the Look Up Process for IDT Service Requests - Public Hardware / SR Report. *
*****************************************************************************************************
 --->


<CFIF NOT IsDefined('URL.LOOKUPSR')> 

	<CFQUERY name="LookupHardwareBarcode" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	DISTINCT HI.BARCODENUMBER, CUST.FIRSTNAME 
		FROM		HARDWAREINVENTORY HI, SRMGR.SREQUIPLOOKUP SRELU, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	HI.BARCODENUMBER = SRELU.EQUIPMENTBARCODE AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.FIRSTNAME = 'PUBLIC'
		ORDER BY	HI.BARCODENUMBER
	</CFQUERY>
     
     <CFQUERY name="LookupHardwareStateFound" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	DISTINCT HI.STATEFOUNDNUMBER, HI.BARCODENUMBER, CUST.FIRSTNAME  
		FROM		HARDWAREINVENTORY HI, SRMGR.SREQUIPLOOKUP SRELU, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	HI.BARCODENUMBER = SRELU.EQUIPMENTBARCODE  AND
          		NOT (HI.STATEFOUNDNUMBER IS NULL)AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.FIRSTNAME = 'PUBLIC'
		ORDER BY	HI.STATEFOUNDNUMBER
	</CFQUERY>

	<CFQUERY name="LookupHardwareDivision" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	DISTINCT HI.DIVISIONNUMBER, HI.BARCODENUMBER, CUST.FIRSTNAME
		FROM		HARDWAREINVENTORY HI, SRMGR.SREQUIPLOOKUP SRELU, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	HI.BARCODENUMBER = SRELU.EQUIPMENTBARCODE AND
          		NOT (HI.DIVISIONNUMBER IS NULL)AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.FIRSTNAME = 'PUBLIC'
		ORDER BY	HI.DIVISIONNUMBER
	</CFQUERY>
     
     <CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          ORDER BY	FISCALYEARID
     </CFQUERY>

	<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	(CURRENTFISCALYEAR = 'YES')
          ORDER BY	FISCALYEARID
     </CFQUERY>
	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center">
               	<H1> 
               		Public Hardware / SR Lookup
                   </H1>
                </TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>
                    	Select from the drop down boxes or type in full/partial values to choose report criteria. <BR />
					Checking an adjacent checkbox will Negate the selection or data entered.
				</H2>
			</TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				&nbsp;&nbsp;<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				&nbsp;&nbsp;<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
	<BR />
	<FIELDSET>
	<LEGEND>Equipment</LEGEND>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/srpublichwreport.cfm?LOOKUPSR=FOUND" method="POST">
	<TABLE align="LEFT" width="100%">
          <TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBARCODENUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BARCODENUMBER">Barcode Number</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESTATEFOUNDNUMBERBC">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="STATEFOUNDNUMBERBC">State Found Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBARCODENUMBER" id="NEGATEBARCODENUMBER" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="BARCODENUMBER" id="BARCODENUMBER" tabindex="3">
					<OPTION value="0">BARCODE NUMBER</OPTION>
					<CFLOOP query="LookupHardwareBarcode">
						<OPTION value='#BARCODENUMBER#'>#BARCODENUMBER#</OPTION>
					</CFLOOP>
				</CFSELECT><BR>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTATEFOUNDNUMBERBC" id="NEGATESTATEFOUNDNUMBERBC" value="" align="LEFT" required="No" tabindex="5">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="STATEFOUNDNUMBERBC" id="STATEFOUNDNUMBERBC" tabindex="6">
					<OPTION value="0">STATE FOUND NUMBER</OPTION>
					<CFLOOP query="LookupHardwareStateFound">
						<OPTION value='#BARCODENUMBER#'>#STATEFOUNDNUMBER#</OPTION>
					</CFLOOP>
				</CFSELECT><BR>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
               	<COM> NOTE: <BR><BR><BR></COM>
				<LABEL for="NEGATEDIVISIONNUMBERBC">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
               	<COM>If the Barcode Number, State Found Number, <BR>
                    	or Divison Number are not found in the dropdowns, <BR>
                         then no matching SR exists.<BR><BR>
                    </COM>
				<LABEL for="DIVISIONNUMBERBC">Division Number</LABEL>
			</TH>
         		<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDIVISIONNUMBER_TEXT">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DIVISIONNUMBER_TEXT">
                    	Division Number<BR /> 
                    	Or Enter (1) a partial or full Division Number or<BR /> 
                      	&nbsp;<COM>(2) a series of full Division Numbers separated by commas,NO spaces or<BR />
                         &nbsp;(Each value in the series must be single quoted: i.e. 'DIVISION','NUMBER'</COM>)<BR />
                         &nbsp;(3) two full Division Numbers separated by a semicolon for range.
                    </LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDIVISIONNUMBERBC"id="NEGATEDIVISIONNUMBERBC" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="DIVISIONNUMBERBC" id="DIVISIONNUMBERBC" tabindex="9">
					<OPTION value="0">DIVISION NUMBER</OPTION>
					<CFLOOP query="LookupHardwareDivision">
						<OPTION value='#BARCODENUMBER#'>#DIVISIONNUMBER#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
               <TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDIVISIONNUMBER_TEXT" id="NEGATEDIVISIONNUMBER_TEXT" value="" align="LEFT" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="DIVISIONNUMBER_TEXT" id="DIVISIONNUMBER_TEXT" value="" required="No" size="50" tabindex="11">
			</TD>
          </TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>SR</LEGEND>
	<TABLE width="100%" border="0">
          <TR>
          	<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFISCALYEARID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FISCALYEARID">Select a Fiscal Year </LABEL>
			</TH>
          	<TH align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SRCOMPLETED">SR Completed?</LABEL>
			</TH>
          </TR>
		<TR>
               <TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFISCALYEARID"id="NEGATEFISCALYEARID" value="" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" width="45%">
               	<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="ListFiscalYears" value="FISCALYEARID" selected="#ListCurrentFiscalYear.FISCALYEARID#" display="FISCALYEAR_4DIGIT" required="No" tabindex="4"></CFSELECT>
               </TD>
               <TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>				
               <TD align="left" width="33%" valign="top">
                    <CFSELECT name="SRCOMPLETED" id="SRCOMPLETED" size="1" tabindex="13">
                    	<OPTION value="Select an Option"> Select an Option</OPTION>
                         <OPTION value="NO">NO</OPTION>
                         <OPTION value="YES">YES</OPTION>
                         <OPTION value="VOIDED">VOIDED</OPTION>
                    </CFSELECT>
               </TD>
 		</TR> 
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
     <LEGEND>Record Selection</LEGEND>
	<TABLE width="100%" border="0">
		<TR>
			<TH align="CENTER">
				<H2>Clicking on the "Match All" button without selecting any fields <BR> will display all records for the current Fiscal Year.</H2>
			</TH>
 		</TR>
		<TR>
			<TD align="LEFT">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="14" />
			</TD>
 		</TR>
		<TR>
 			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="15" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>
	</FIELDSET>
	<BR />

     <TABLE width="100%" align="LEFT">
    		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP">
				&nbsp;&nbsp;<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="16" /><BR>
				&nbsp;&nbsp;<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
          <TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
     <BR />
     <CFEXIT>

<CFELSE>

<!--- 
****************************************************************************************************
* The following code is the IDT Service Requests - Public Hardware / SR Report Generation Process. *
****************************************************************************************************
 --->

	<CFQUERY name="LookupHardwareBarcodeSR" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	EQUIPMENTBARCODE, SERVICEREQUESTNUMBER
		FROM		SREQUIPLOOKUP 
		WHERE	EQUIPMENTBARCODE = '#FORM.BARCODENUMBER#'
		ORDER BY	SERVICEREQUESTNUMBER
	</CFQUERY>
     
     <CFIF LookupHardwareBarcodeSR.RecordCount GT 0>
     	<CFSET SESSION.FINDHWBARCODESR = #ValueList(LookupHardwareBarcodeSR.SERVICEREQUESTNUMBER)#>
          <CFSET SESSION.FINDHWBARCODESR = ListChangeDelims(SESSION.FINDHWBARCODESR, "','", ",")>
     </CFIF>
     
     <CFQUERY name="LookupHardwareStateFoundSR" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	EQUIPMENTBARCODE, SERVICEREQUESTNUMBER
		FROM		SREQUIPLOOKUP 
		WHERE	EQUIPMENTBARCODE = '#FORM.STATEFOUNDNUMBERBC#'
		ORDER BY	SERVICEREQUESTNUMBER
	</CFQUERY>
     
     <CFIF LookupHardwareStateFoundSR.RecordCount GT 0>
     	<CFSET SESSION.FINDHWSTATEFOUNDSR = #ValueList(LookupHardwareStateFoundSR.SERVICEREQUESTNUMBER)#>
          <CFSET SESSION.FINDHWSTATEFOUNDSR = ListChangeDelims(SESSION.FINDHWSTATEFOUNDSR, "','", ",")>
     </CFIF>
     
     <CFQUERY name="LookupHardwareDivisionSR" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	EQUIPMENTBARCODE, SERVICEREQUESTNUMBER
		FROM		SREQUIPLOOKUP 
		WHERE	EQUIPMENTBARCODE = '#FORM.DIVISIONNUMBERBC#'
		ORDER BY	SERVICEREQUESTNUMBER
	</CFQUERY>
     
     <CFIF LookupHardwareDivisionSR.RecordCount GT 0>
     	<CFSET SESSION.FINDHWDIVISIONSR = #ValueList(LookupHardwareDivisionSR.SERVICEREQUESTNUMBER)#>
          <CFSET SESSION.FINDHWDIVISIONSR = ListChangeDelims(SESSION.FINDHWDIVISIONSR, "','", ",")>
     </CFIF>
     
	<CFIF ((IsDefined('FORM.DIVISIONNUMBER_TEXT')) AND (#FORM.DIVISIONNUMBER_TEXT# NEQ "" AND #FORM.DIVISIONNUMBER_TEXT# NEQ " "))>
     	<CFSET FORM.DIVISIONNUMBER_TEXT = #UCase(FORM.DIVISIONNUMBER_TEXT)#>
     	<CFIF FIND(',', #FORM.DIVISIONNUMBER_TEXT#, 1) NEQ 0>
      
               <CFQUERY name="LookupHardwareDivisionText" datasource="#application.type#HARDWARE" blockfactor="100">
                    SELECT	BARCODENUMBER, DIVISIONNUMBER
                    FROM		HARDWAREINVENTORY
                    WHERE	DIVISIONNUMBER IN (#PreserveSingleQuotes(FORM.DIVISIONNUMBER_TEXT)#)
                    ORDER BY	DIVISIONNUMBER, BARCODENUMBER
               </CFQUERY>
               
      	<CFELSEIF FIND(';', #FORM.DIVISIONNUMBER_TEXT#, 1) NEQ 0>
          
          	<CFSET FORM.DIVISIONNUMBER_TEXT = #REPLACE(FORM.DIVISIONNUMBER_TEXT, ";", ",")#>

			<CFSET FORM.DIVISIONNUMBER_BEGIN = ListFirst(FORM.DIVISIONNUMBER_TEXT)>
               <CFSET FORM.DIVISIONNUMBER_END = ListLast(FORM.DIVISIONNUMBER_TEXT)>
          
          	<CFQUERY name="LookupHardwareDivisionText" datasource="#application.type#HARDWARE" blockfactor="100">
                    SELECT	BARCODENUMBER, DIVISIONNUMBER
                    FROM		HARDWAREINVENTORY
                    WHERE	(DIVISIONNUMBER >= '#FORM.DIVISIONNUMBER_BEGIN#' AND DIVISIONNUMBER <= '#FORM.DIVISIONNUMBER_END#')
                    ORDER BY	DIVISIONNUMBER, BARCODENUMBER
               </CFQUERY>
               
          <CFELSE>
          
          	<CFQUERY name="LookupHardwareDivisionText" datasource="#application.type#HARDWARE" blockfactor="100">
                    SELECT	BARCODENUMBER, DIVISIONNUMBER
                    FROM		HARDWAREINVENTORY
                    WHERE	DIVISIONNUMBER LIKE '%#FORM.DIVISIONNUMBER_TEXT#%'
                    ORDER BY	DIVISIONNUMBER, BARCODENUMBER
               </CFQUERY>
               
		</CFIF>
          
		<CFSET SESSION.FINDBARCODE = #ValueList(LookupHardwareDivisionText.BARCODENUMBER)#>
          <CFSET SESSION.FINDBARCODE = ListChangeDelims(SESSION.FINDBARCODE, "','", ",")>
 
          <CFQUERY name="LookupHardwareDivisionTextSR" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	EQUIPMENTBARCODE, SERVICEREQUESTNUMBER
               FROM		SREQUIPLOOKUP 
               WHERE	EQUIPMENTBARCODE IN ('#PreserveSingleQuotes(SESSION.FINDBARCODE)#')
               ORDER BY	SERVICEREQUESTNUMBER
          </CFQUERY>
          
          <CFSET SESSION.FINDBARCODESR = #ValueList(LookupHardwareDivisionTextSR.SERVICEREQUESTNUMBER)#>
          <CFSET SESSION.FINDBARCODESR = ListChangeDelims(SESSION.FINDBARCODESR, "','", ",")>
               
     </CFIF>
     
     <CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>
	
	<CFQUERY name="DisplayServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATEDATE,
				SR.REQUESTERID, REQCUST.CUSTOMERID, REQCUST.FULLNAME, SR.PROBLEM_DESCRIPTION, SR.SRCOMPLETED, HICUST.FIRSTNAME, HICUST.FULLNAME AS HWCUST
     	FROM		SERVICEREQUESTS SR, PRIORITY P, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, HARDWMGR.HARDWAREINVENTORY HI, SREQUIPLOOKUP SRELU, 
     			LIBSHAREDDATAMGR.CUSTOMERS HICUST
		WHERE	(SR.SRID > 0 AND 
				SR.PRIORITYID = P.PRIORITYID AND
				SR.REQUESTERID = REQCUST.CUSTOMERID AND
                    SR.SERVICEREQUESTNUMBER = SRELU.SERVICEREQUESTNUMBER AND
                    SRELU.EQUIPMENTBARCODE = HI.BARCODENUMBER AND
				HI.CUSTOMERID = HICUST.CUSTOMERID AND
				HICUST.FIRSTNAME = 'PUBLIC') AND (
          
          <CFIF #FORM.BARCODENUMBER# NEQ "0">
			<CFIF IsDefined('FORM.NEGATEBARCODENUMBER')>
				NOT SR.SERVICEREQUESTNUMBER IN ('#PreserveSingleQuotes(SESSION.FINDHWBARCODESR)#') #LOGICANDOR#
			<CFELSE>
				SR.SERVICEREQUESTNUMBER IN ('#PreserveSingleQuotes(SESSION.FINDHWBARCODESR)#') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.STATEFOUNDNUMBERBC# NEQ "0">
			<CFIF IsDefined('FORM.NEGATESTATEFOUNDNUMBERBC')>
				NOT SR.SERVICEREQUESTNUMBER IN ('#PreserveSingleQuotes(SESSION.FINDHWSTATEFOUNDSR)#') #LOGICANDOR#
			<CFELSE>
				SR.SERVICEREQUESTNUMBER IN ('#PreserveSingleQuotes(SESSION.FINDHWSTATEFOUNDSR)#') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.DIVISIONNUMBERBC# NEQ "0">
			<CFIF IsDefined('FORM.NEGATEDIVISIONNUMBERBC')>
				NOT SR.SERVICEREQUESTNUMBER IN ('#PreserveSingleQuotes(SESSION.FINDHWDIVISIONSR)#') #LOGICANDOR#
			<CFELSE>
				SR.SERVICEREQUESTNUMBER IN ('#PreserveSingleQuotes(SESSION.FINDHWDIVISIONSR)#') #LOGICANDOR#
			</CFIF>
		</CFIF>
          
		<CFIF ((IsDefined('FORM.DIVISIONNUMBER_TEXT')) AND (#FORM.DIVISIONNUMBER_TEXT# NEQ "" AND #FORM.DIVISIONNUMBER_TEXT# NEQ " "))>
          	<CFIF IsDefined('FORM.NEGATEDIVISIONNUMBER_TEXT')>
				NOT SR.SERVICEREQUESTNUMBER IN ('#PreserveSingleQuotes(SESSION.FINDBARCODESR)#') #LOGICANDOR#
			<CFELSE>
				SR.SERVICEREQUESTNUMBER IN ('#PreserveSingleQuotes(SESSION.FINDBARCODESR)#') #LOGICANDOR#
			</CFIF>
		</CFIF>
          
          	<CFIF IsDefined('FORM.NEGATEFISCALYEARID')>
               	NOT SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID#" cfsqltype="CF_SQL_VARCHAR"> #LOGICANDOR#
               <CFELSE>
          		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID#" cfsqltype="CF_SQL_VARCHAR"> #LOGICANDOR#
               </CFIF>
               
               <CFIF IsDefined('FORM.SRCOMPLETED') AND NOT #FORM.SRCOMPLETED# EQ "Select an Option">
          		SR.SRCOMPLETED = <CFQUERYPARAM value="#FORM.SRCOMPLETED#" cfsqltype="CF_SQL_VARCHAR"> #LOGICANDOR#
               </CFIF>
                              
                    SR.SRID #FINALTEST# 0)
                    ORDER BY	SR.SERVICEREQUESTNUMBER DESC
	</CFQUERY>

     <TABLE width="100%" align="center" border="3">
          <TR align="center">
               <TD align="center"><H1>Public Hardware / SR Report</H1></TD>
          </TR>
     </TABLE>
     <TABLE width="100%" align="center" border="0">
          <TR>
<CFFORM action="/#application.type#apps/servicerequests/srpublichwreport.cfm" method="POST">
               <TD align="left" width="33%">
                    <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
          </TR>
          <TR>
               <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
			<TH align="CENTER" colspan="5">#DisplayServiceRequests.RecordCount# SR records were selected.<BR /><BR /></TH>
		</TR>
          <TR>
          	<TD align="left" colspan="5"><HR></TD>
          </TR>
     </TABLE>
     <TABLE width="100%" align="LEFT">
<CFLOOP query = "DisplayServiceRequests">

	<CFQUERY name="DisplaySRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, SRSA.NEXT_ASSIGNMENT,
				SRSA.NEXT_ASSIGNMENT_GROUPID, GA.GROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, WGA.STAFFCUSTOMERID, CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED,
				TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATE, SRSA.STAFF_TIME_WORKED,
				SRSA.STAFF_COMMENTS, SRSA.STAFF_COMPLETEDSR, SRSA.STAFF_COMPLETEDDATE, TO_CHAR(SRSA.MODIFIEDDATE, 'MM/DD/YYYY') AS DATE_LAST_MODIFIED
		FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	SRSA.SRSTAFF_ASSIGNID > 0 AND
				SRSA.SRID = <CFQUERYPARAM value="#DisplayServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
				SRSA.NEXT_ASSIGNMENT_GROUPID = GA.GROUPID AND
				WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
		ORDER BY	GA.GROUPNAME, CUST.FULLNAME
	</CFQUERY>
     
     <CFQUERY name="DisplaySREquipBarcode" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
          FROM		SREQUIPLOOKUP
          WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#DisplayServiceRequests.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
     </CFQUERY>

     <CFQUERY name="DisplayHardware" datasource="#application.type#HARDWARE">
		SELECT	HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.DIVISIONNUMBER, LOC.LOCATIONID, LOC.ROOMNUMBER
		FROM		HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC
		WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#DisplaySREquipBarcode.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
          		HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID
		ORDER BY	BARCODENUMBER
	</CFQUERY>

          <TR>
               <TH align="left" valign="BOTTOM"><B>SR</B></TH>
               <TH align="left" valign="BOTTOM">Creation Date</TH>
               <TH align="left" valign="BOTTOM">SR Completed</TH>
               <TH align="left" valign="BOTTOM">Requester</TH>
               <TH align="left" valign="BOTTOM">Staff Assigned</TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP">#DisplayServiceRequests.SERVICEREQUESTNUMBER#</TD>
               <TD align="left" valign="TOP">#DateFormat(DisplayServiceRequests.CREATIONDATE, "mm/dd/yyyy")#</TD>
               <TD align="left" valign="top"><FONT COLOR="Red"><STRONG>#DisplayServiceRequests.SRCOMPLETED#</STRONG></FONT></TD>
               <TD align="left" valign="TOP">#DisplayServiceRequests.FULLNAME#</TD>
               <TD align="left" valign="top">
               	<CFLOOP query = "DisplaySRStaffAssignments">
                    	#DisplaySRStaffAssignments.FULLNAME#<BR>
                    </CFLOOP>
               </TD>
          </TR>
          <TR>
          	<TH align="left" valign="BOTTOM" colspan="5">Problem Description</TH>
          </TR>
          <TR>
          	<TD align="left" valign="TOP" colspan="5">#DisplayServiceRequests.PROBLEM_DESCRIPTION#</TD>
          </TR>
          <TR>
          	<TH align="left" valign="BOTTOM">Current Assignment</TH>
               <TH align="left" valign="BOTTOM">Division Number</TH>
               <TH align="left" valign="BOTTOM">Barcode</TH>
               <TH align="left" valign="BOTTOM">State Found Number</TH>              
               <TH align="left" valign="BOTTOM">Room</TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP">#DisplayServiceRequests.HWCUST#</TD>
               <TD align="left" valign="TOP">#DisplayHardware.DIVISIONNUMBER#</TD>
               <TD align="left" valign="TOP">#DisplayHardware.BARCODENUMBER#</TD>
               <TD align="left" valign="TOP">#DisplayHardware.STATEFOUNDNUMBER#</TD>         
               <TD align="left" valign="TOP">#DisplayHardware.ROOMNUMBER#</TD>         
          </TR>
          <TR>
          	<TD align="left" colspan="5"><HR></TD>
          </TR>
</CFLOOP> 
		<TR>
			<TH align="CENTER" colspan="5">#DisplayServiceRequests.RecordCount# SR records were selected.<BR /><BR /></TH>
		</TR>
          <TR>
               <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/srpublichwreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="5"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>   

</CFIF>

</BODY>
</CFOUTPUT>
</HTML>
