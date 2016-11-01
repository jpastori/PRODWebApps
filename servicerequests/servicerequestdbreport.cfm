<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: servicerequestdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/08/2012 --->
<!--- Date in Production: 08/08/2012 --->
<!--- Module: Service Requests - SR Number Lists Report --->
<!-- Last modified by John R. Pastori on 06/27/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/servicerequestdbreport.cfm">
<CFSET CONTENT_UPDATED = "June 27, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Service Requests - SR Number Lists Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to Service Requests - SR Number Lists Report";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET CURSORFIELD = "document.LOOKUP.REPORTCHOICE[0].focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>

<CFOUTPUT>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*******************************************************************************************
* The following code is the Lookup Process for Service Requests - SR Number Lists Report. *
*******************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>

	<CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<CFQUERY name="LookupCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		WHERE	(CURRENTFISCALYEAR = 'YES')
		ORDER BY	FISCALYEARID
	</CFQUERY>
     
     <CFQUERY name="ListServDeskInitials" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
          SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, ACTIVE
          FROM		CUSTOMERS
          WHERE	INITIALS IS NOT NULL AND
                    ACTIVE = 'YES'
          ORDER BY	FULLNAME
     </CFQUERY>

	<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
		SELECT	GROUPID, GROUPNAME
		FROM		GROUPASSIGNED
		ORDER BY	GROUPNAME
	</CFQUERY>

	<CFQUERY name="ListIDTStaff" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUSTOMERID, LASTNAME, FULLNAME AS STAFF, INITIALS, FULLNAME || '-' || INITIALS AS SDINITIALS, ACTIVE
		FROM		CUSTOMERS
		WHERE	INITIALS IS NOT NULL AND
				ACTIVE = 'YES'
		ORDER BY	STAFF
	</CFQUERY>


	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Select Data for SR Number Lists</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
           <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
<CFFORM name="LOOKUP" action="/#application.type#apps/servicerequests/servicerequestdbreport.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>SELECT ONE OF THE NINE (9) REPORTS BELOW</COM></TD>
		</TR>
          <TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="2" />
               </TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" align="LEFT" required="No" tabindex="3">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE1">REPORT 1: &nbsp;&nbsp;All SRs</LABEL>
                    <LABEL for="FISCALYEARID1">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
               	<CFSELECT name="FISCALYEARID1" id="FISCALYEARID1" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="4"></CFSELECT>
               </TD>
		</TR>
          <TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="5">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE2">REPORT 2: &nbsp;&nbsp;All SRs</LABEL>
                    <LABEL for="FISCALYEARID2">for a Specific Fiscal Year</LABEL> <LABEL for="SERVICEDESKINITIALSID">by Service Desk Initials</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
               	<CFSELECT name="SERVICEDESKINITIALSID" id="SERVICEDESKINITIALSID" query="ListServDeskInitials" value="CUSTOMERID" display="INITIALS" selected="0" tabindex="6"></CFSELECT>
				&nbsp;&nbsp;&nbsp;&nbsp;               	
                    <CFSELECT name="FISCALYEARID2" id="FISCALYEARID2" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="7"></CFSELECT>
               </TD>
               
		</TR>
          <TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="8">
			</TD>
			<TH align="left" valign="TOP">
				<LABEL for="REPORTCHOICE3">REPORT 3: &nbsp;&nbsp;All SRs w/Description</LABEL>
				<LABEL for="CREATIONDATERANGE">
                    		for a range of Creation Dates <BR> 
                    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    		separated by a semicolon;No Spaces<BR>
                    </LABEL>
                    <LABEL for="FISCALYEARID3">
                    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <FONT COLOR="BLUE">or a Specific Fiscal Year</FONT>
                    </LABEL>
			</TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="Text" name="CREATIONDATERANGE" id="CREATIONDATERANGE" value="" required="No" size="50" tabindex="9">
				&nbsp;&nbsp<FONT COLOR="BLUE"> or </FONT>&nbsp;&nbsp;
               	<CFSELECT name="FISCALYEARID3" id="FISCALYEARID3" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="10"></CFSELECT><BR>
                    <COM>&nbsp;Enter Date Format: MM/DD/YYYY;MM/DD/YYYY </COM>
               </TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="11">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE4">REPORT 4: &nbsp;&nbsp;All Groups</LABEL>
                    <LABEL for="FISCALYEARID4">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
               	<CFSELECT name="FISCALYEARID4" id="FISCALYEARID4" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="12"></CFSELECT>
              </TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="13">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="SREPORTCHOICE5">REPORT 5: </LABEL>
                    <LABEL for="GROUPID">Specific Group Assigned</LABEL>
                    <LABEL for="FISCALYEARID5">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="GROUPID" id="GROUPID" size="1" query="ListGroupAssigned" value="GROUPID" selected ="0" display="GROUPNAME" required="No" tabindex="14"></CFSELECT>	
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <CFSELECT name="FISCALYEARID5" id="FISCALYEARID5" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="15"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE6" value="6" align="LEFT" required="No" tabindex="16">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE6">REPORT 6: &nbsp;&nbsp;Range Of Groups</LABEL>
                    <LABEL for="FISCALYEARID6">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="GROUPRANGE" id="GROUPRANGE" value="" required="No" size="40" maxlength="50" tabindex="17">
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <CFSELECT name="FISCALYEARID6" id="FISCALYEARID6" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="18"></CFSELECT><BR />
				<LABEL for="GROUPRANGE"><COM>Enter (1) a partial Group or
				&nbsp;&nbsp;(2) a series of Groups separated by commas,NO spaces.</COM></LABEL>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE7" value="7" align="LEFT" required="No" tabindex="19">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE7">REPORT 7: &nbsp;&nbsp;All Staff</LABEL>
                    <LABEL for="FISCALYEARID7">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
               	<CFSELECT name="FISCALYEARID7" id="FISCALYEARID7" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="20"></CFSELECT>
               </TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE8" value="8" checked align="LEFT" required="No" tabindex="21">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE8">REPORT 8: </LABEL>
                    <LABEL for="STAFFASSIGNEDID">Specific Staff Assigned</LABEL>
                    <LABEL for="FISCALYEARID8">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="STAFFASSIGNEDID" id="STAFFASSIGNEDID" size="1" query="ListIDTStaff" value="CUSTOMERID" selected ="#Client.CUSTOMERID#" display="STAFF" required="No" tabindex="22"></CFSELECT>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <CFSELECT name="FISCALYEARID8" id="FISCALYEARID8" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="23"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE9" value="9" align="LEFT" required="No" tabindex="24">
			</TD>
			<TH align="left" valign="TOP" nowrap>
               	<LABEL for="REPORTCHOICE9">REPORT 9: &nbsp;&nbsp;Individual or Multiple Staff Assigned</LABEL>
                    <LABEL for="FISCALYEARID9">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="STAFFRANGE" id="STAFFRANGE" value="" required="No" size="40" maxlength="50" tabindex="25">
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <CFSELECT name="FISCALYEARID9" id="FISCALYEARID9" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="26"></CFSELECT><BR />
				<LABEL for="STAFFRANGE"><COM>Enter (1) a partial Staff Last Name or
				&nbsp;&nbsp;(2) a series of Staff Last Names separated by commas,NO spaces.</COM></LABEL>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>SELECT ONE OF THE SORT SEQUENCES BELOW WHEN CHOOSING REPORTS 4 THRU 9</COM></TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE1" checked value="1" align="LEFT" required="No" tabindex="27">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="SORTCHOICE1">Full Requester Name and SR##</LABEL></TH>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE2" value="2" align="LEFT" required="No" tabindex="28">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="SORTCHOICE2">Full Requester Name, Priority and SR##</LABEL></TH>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE3" value="3" align="LEFT" required="No" tabindex="29">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="SORTCHOICE3">Group and SR##</LABEL></TH>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE4" value="4" align="LEFT" required="No" tabindex="30">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="SORTCHOICE4">Group, Priority and SR##</LABEL></TH>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE5" value="5" align="LEFT" required="No" tabindex="31">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="SORTCHOICE5">SR##</LABEL></TH>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE6" value="6" align="LEFT" required="No" tabindex="32">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="SORTCHOICE6">Priority and SR##</LABEL></TH>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
           <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="33" />
               </TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="34" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="5"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
************************************************************************************************************
* The following code is the IDT Service Requests - Service Request Number Lists Report Generation Process. *
************************************************************************************************************
 --->
 
	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'SR.SERVICEREQUESTNUMBER DESC'>
     <CFSET SORTORDER[2] = 'SR.SERVICEREQUESTNUMBER DESC'>
     <CFSET SORTORDER[3] = 'SR.SERVICEREQUESTNUMBER DESC'>
	<CFSET SORTORDER[4] = 'IDTGROUP.GROUPNAME'>
	<CFSET SORTORDER[5] = 'IDTGROUP.GROUPNAME'>
	<CFSET SORTORDER[6] = 'IDTGROUP.GROUPNAME'>
	<CFSET SORTORDER[7] = 'STAFFNAME'>
	<CFSET SORTORDER[8] = 'STAFFNAME'>
	<CFSET SORTORDER[9] = 'STAFFNAME'>
	
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>
     <CFSET REPORTTITLE2 = "">
	<!--- REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
     
     <CFIF #REPORTCHOICE# EQ 1>
     	<CFSET REPORTTITLE2 = "All SRs">
          <CFSET FORM.FISCALYEARID = #FORM.FISCALYEARID1#>
     <CFELSEIF #REPORTCHOICE# EQ 2>
     	<CFSET REPORTTITLE2 = "All SRs By Service Desk Initials">
          <CFSET FORM.FISCALYEARID = #FORM.FISCALYEARID2#>
     <CFELSEIF #REPORTCHOICE# EQ 3>
     	<CFIF #FORM.CREATIONDATERANGE# NEQ "">
     		<CFSET REPORTTITLE2 = "All SRs w/Description for Range of Creation Dates between ">
               <CFSET FORM.FISCALYEARID = "">
          <CFELSE>
          	<CFSET REPORTTITLE2 = "All SRs w/Description for a Specific Fiscal Year: ">
          	<CFSET FORM.FISCALYEARID = #FORM.FISCALYEARID3#>
          </CFIF>
	<CFELSEIF #REPORTCHOICE# EQ 4>
		<CFSET REPORTTITLE2 = "All Groups">
          <CFSET FORM.FISCALYEARID = #FORM.FISCALYEARID4#>
	<CFELSEIF #REPORTCHOICE# EQ 5 >
		<CFSET REPORTTITLE2 = "Specific Group Assigned">
          <CFSET FORM.FISCALYEARID = #FORM.FISCALYEARID5#>
	<CFELSEIF #REPORTCHOICE# EQ 6>
		<CFSET REPORTTITLE2 = "Range Of Groups">
          <CFSET FORM.FISCALYEARID = #FORM.FISCALYEARID6#>
	<CFELSEIF #REPORTCHOICE# EQ 7>
		<CFSET REPORTTITLE2 = "All Staff">
          <CFSET FORM.FISCALYEARID = #FORM.FISCALYEARID7#>
	<CFELSEIF #REPORTCHOICE# EQ 8>
     	<CFSET REPORTTITLE2 = "Specific Staff Assigned">
          <CFSET FORM.FISCALYEARID = #FORM.FISCALYEARID8#>
	<CFELSEIF #REPORTCHOICE# EQ 9>
		<CFSET REPORTTITLE2 = "Individual or Multiple Staff Assigned">
          <CFSET FORM.FISCALYEARID = #FORM.FISCALYEARID9#>
     </CFIF>

 	<CFQUERY name="LookupFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
          WHERE	FISCALYEARID = #val(FORM.FISCALYEARID)#
		ORDER BY	FISCALYEARID
	</CFQUERY>
     
     <CFIF #FORM.REPORTCHOICE# EQ 3>

		<CFSET CREATIONDATERANGE = "NO">
		<CFIF FIND(';', #FORM.CREATIONDATERANGE#, 1) NEQ 0>
			<CFSET CREATIONDATERANGE = "YES">
			<CFSET FORM.CREATIONDATERANGE = #REPLACE(FORM.CREATIONDATERANGE, ";", ",")#>
			<CFSET CREATIONDATEARRAY = ListToArray(FORM.CREATIONDATERANGE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(CREATIONDATEARRAY)# >
				CREATION DATE FIELD #COUNTER# = #CREATIONDATEARRAY[COUNTER]#<BR /><BR />
			</CFLOOP>
		</CFIF>
		<CFIF CREATIONDATERANGE EQ "YES">
			<CFSET BEGINCREATIONDATE = DateFormat(#CREATIONDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDCREATIONDATE = DateFormat(#CREATIONDATEARRAY[2]#, 'DD-MMM-YYYY')>
               <CFSET REPORTTITLE2 = #REPORTTITLE2# & DateFormat(#BEGINCREATIONDATE#, 'MMMM DD, YYYY') & " and " & DateFormat(#ENDCREATIONDATE#, 'MMMM DD, YYYY')>
          <CFELSE>
          	<CFSET REPORTTITLE2 = #REPORTTITLE2# & #LookupFiscalYears.FISCALYEAR_4DIGIT#>
		</CFIF>
		CREATION DATE RANGE = #CREATIONDATERANGE#<BR /><BR />

	</CFIF>

	<CFIF #REPORTCHOICE# GTE 4 AND #REPORTCHOICE# LTE 6>
		<CFSET GROUPHEADER = "">
		<CFIF #SORTCHOICE# EQ 1>
			<CFSET REPORTORDER = #REPORTORDER# & ', REQ.FULLNAME, SR.SERVICEREQUESTNUMBER DESC'>
			<!--- SORTCHOICE 1 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
		<CFELSEIF #SORTCHOICE# EQ 2>
			<CFSET REPORTORDER = #REPORTORDER# & ', REQ.FULLNAME, PRIORITY.PRIORITYNAME, SR.SERVICEREQUESTNUMBER DESC'>
			<!--- SORTCHOICE 2 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
		<CFELSEIF #SORTCHOICE# EQ 3 OR #SORTCHOICE# EQ 5>
			<CFSET REPORTORDER = #REPORTORDER# & ', SR.SERVICEREQUESTNUMBER DESC'>
			<!--- SORTCHOICE 3 OR 5 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
		<CFELSEIF #SORTCHOICE# EQ 4 OR #SORTCHOICE# EQ 6>
			<CFSET REPORTORDER = #REPORTORDER# & ', PRIORITY.PRIORITYNAME, SR.SERVICEREQUESTNUMBER DESC'>
			<!--- SORTCHOICE 4 OR 6 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
		</CFIF>
	</CFIF>

	<CFIF #REPORTCHOICE# GTE 7 AND #REPORTCHOICE# LTE 9>
		<CFSET STAFFHEADER = "">
		<CFIF #SORTCHOICE# EQ 1>
			<CFSET REPORTORDER = #REPORTORDER# & ', REQ.FULLNAME, SR.SERVICEREQUESTNUMBER DESC'>
			<!--- SORTCHOICE 1 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
		<CFELSEIF #SORTCHOICE# EQ 2>
			<CFSET REPORTORDER = #REPORTORDER# & ', REQ.FULLNAME, PRIORITY.PRIORITYNAME, SR.SERVICEREQUESTNUMBER DESC'>
			<!--- SORTCHOICE 2 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
		<CFELSEIF #SORTCHOICE# EQ 3 >
			<CFSET REPORTORDER = #REPORTORDER# & ', IDTGROUP.GROUPNAME, SR.SERVICEREQUESTNUMBER DESC'>
			<!--- SORTCHOICE 3 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
		<CFELSEIF #SORTCHOICE# EQ 4>
			<CFSET REPORTORDER = #REPORTORDER# & ', IDTGROUP.GROUPNAME, PRIORITY.PRIORITYNAME, SR.SERVICEREQUESTNUMBER DESC'>
			<!--- SORTCHOICE 4 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
		<CFELSEIF #SORTCHOICE# EQ 5>
			<CFSET REPORTORDER = #REPORTORDER# & ', SR.SERVICEREQUESTNUMBER DESC'>
 			<!--- SORTCHOICE 5 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
		<CFELSEIF #SORTCHOICE# EQ 6>
			<CFSET REPORTORDER = #REPORTORDER# & ', PRIORITY.PRIORITYNAME, SR.SERVICEREQUESTNUMBER DESC'>
			<!--- SORTCHOICE 6 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
          </CFIF>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 6>
		<CFSET GROUPRANGELIST = "NO">
		<CFIF FIND(',', #FORM.GROUPRANGE#, 1) NEQ 0>
			<CFSET GROUPRANGELIST = "YES">
			<CFSET FORM.GROUPRANGE = UCASE(#FORM.GROUPRANGE#)>
			<CFSET FORM.GROUPRANGE = ListQualify(FORM.GROUPRANGE,"'",",","CHAR")>
			<!--- GROUPRANGE FIELD = #FORM.GROUPRANGE#<BR /><BR /> --->
		</CFIF>
		<CFQUERY name="LookupGroupNames" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
			SELECT	GROUPID, GROUPNAME
			FROM		GROUPASSIGNED
		<CFIF GROUPRANGELIST EQ "YES">
			WHERE	GROUPNAME IN (#PreserveSingleQuotes(FORM.GROUPRANGE)#)
		<CFELSE>
			WHERE	GROUPNAME LIKE UPPER('#FORM.GROUPRANGE#%')
		</CFIF>
			ORDER BY	GROUPNAME
		</CFQUERY>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 9>
		<CFSET STAFFRANGELIST = "NO">
		<CFIF FIND(',', #FORM.STAFFRANGE#, 1) NEQ 0>
			<CFSET STAFFRANGELIST = "YES">
			<CFSET FORM.STAFFRANGE = UCASE(#FORM.STAFFRANGE#)>
			<CFSET FORM.STAFFRANGE = ListQualify(FORM.STAFFRANGE,"'",",","CHAR")>
			<!--- STAFFRANGE FIELD = #FORM.STAFFRANGE#<BR /><BR /> --->
		</CFIF>
		<CFQUERY name="LookupStaffNames" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER, CUST.LASTNAME, CUST.FULLNAME
			FROM		WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		<CFIF STAFFRANGELIST EQ "YES">
			WHERE	CUST.LASTNAME IN (#PreserveSingleQuotes(FORM.STAFFRANGE)#) AND
		<CFELSE>
			WHERE	CUST.LASTNAME LIKE UPPER('#FORM.STAFFRANGE#%') AND
		</CFIF>
					WGA.GROUPID = GA.GROUPID AND
					WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
			ORDER BY	CUST.FULLNAME
		</CFQUERY>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# GT 3>
		<CFQUERY name="ListStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.STAFFCUSTOMERID, WGA.GROUPID, WGA.GROUPORDER,
					CUST.FULLNAME AS STAFFNAME, TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATEASSIGNED, SRSA.STAFF_TIME_WORKED,
					SRSA.STAFF_COMMENTS, SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID, SRSA.NEXT_ASSIGNMENT_REASON, SRSA.STAFF_COMPLETEDSR,
					SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMPLETEDCOMMENTSID, SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER,
					TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE, TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME,
					SR.SERVICEDESKINITIALSID, SDINIT.FULLNAME AS INITIALS, SR.REQUESTERID, REQ.FULLNAME AS RNAME, SR.ALTERNATE_CONTACTID,
					ALTCONTACT.FULLNAME AS ANAME, SR.PROBLEM_CATEGORYID, PROBCAT.CATEGORYLETTER || PROBCAT.CATEGORYNAME AS PROBCATEGORY,
					SR.PROBLEM_SUBCATEGORYID, PROBSUBCAT.SUBCATEGORYNAME AS PROBSUBCATEGORY, SR.PRIORITYID, PRIORITY.PRIORITYNAME,
					SR.GROUPASSIGNEDID, IDTGROUP.GROUPID, IDTGROUP.GROUPNAME, REFGROUP.GROUPID, REFGROUP.GROUPNAME AS REFGROUPNAME, SR.SERVICETYPEID,
					SERVICETYPES.SERVICETYPENAME, SR.ACTIONID, ACTIONS.ACTIONNAME, SR.OPERATINGSYSTEMID, OPSYS.OPSYSNAME, SR.OPTIONID,
					OPTIONS.OPTIONNAME, SR.PROBLEM_DESCRIPTION, TO_CHAR(SR.SRCOMPLETEDDATE, 'DD-MON-YYYY') AS SRCOMPLETEDDATE
			FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, LIBSHAREDDATAMGR.CUSTOMERS REQ,
					LIBSHAREDDATAMGR.CUSTOMERS ALTCONTACT, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY,
					GROUPASSIGNED IDTGROUP, GROUPASSIGNED REFGROUP, SERVICETYPES, ACTIONS, OPSYS, OPTIONS
			WHERE	SRSA.SRSTAFF_ASSIGNID > 0 AND
               		
				<CFIF #FORM.REPORTCHOICE# GTE 4 AND #FORM.REPORTCHOICE# LTE 6 >
					SRSA.NEXT_ASSIGNMENT = 'YES' AND
				</CFIF>
				<CFIF #FORM.REPORTCHOICE# EQ 5>
					SRSA.NEXT_ASSIGNMENT_GROUPID = #val(FORM.GROUPID)# AND
				</CFIF>
				<CFIF #FORM.REPORTCHOICE# EQ 6>
					SRSA.NEXT_ASSIGNMENT_GROUPID IN (#ValueList(LookupGroupNames.GROUPID)#) AND
				</CFIF>
				<CFIF #FORM.REPORTCHOICE# EQ 8>
					WGA.STAFFCUSTOMERID = #val(FORM.STAFFASSIGNEDID)# AND
				<CFELSEIF #FORM.REPORTCHOICE# EQ 9>
					SRSA.STAFF_ASSIGNEDID IN (#ValueList(LookupStaffNames.WORKGROUPASSIGNSID)#) AND
				</CFIF>
					SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
					WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
					SRSA.SRID = SR.SRID AND
                         SR.FISCALYEARID = #val(LookupFiscalYears.FISCALYEARID)# AND
					SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
					SR.REQUESTERID = REQ.CUSTOMERID AND
					SR.ALTERNATE_CONTACTID = ALTCONTACT.CUSTOMERID AND
					SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
					SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
					SR.PRIORITYID = PRIORITY.PRIORITYID AND
					SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
					SRSA.NEXT_ASSIGNMENT_GROUPID = REFGROUP.GROUPID AND
					SR.SERVICETYPEID = SERVICETYPES.SERVICETYPEID AND
					SR.ACTIONID = ACTIONS.ACTIONID AND
					SR.OPERATINGSYSTEMID = OPSYS.OPSYSID AND 
					SR.OPTIONID = OPTIONS.OPTIONID
			ORDER BY	#REPORTORDER#
		</CFQUERY>

		<CFIF #FORM.REPORTCHOICE# GTE 4 AND #FORM.REPORTCHOICE# LTE 6 >
			<CFTRANSACTION action="begin">
			<CFQUERY name="DeleteSRGroupReport" datasource="#application.type#SERVICEREQUESTS">
				DELETE FROM	SRGROUPREPORT 
				WHERE		SRGRID > 0
			</CFQUERY>
			<CFTRANSACTION action = "commit"/>
			</CFTRANSACTION>
			<CFLOOP query="ListStaffAssignments">
				<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
					SELECT	MAX(SRGRID) AS MAX_ID
					FROM		SRGROUPREPORT
				</CFQUERY>
				<CFSET FORM.SRGRID =  #val(GetMaxUniqueID.MAX_ID+1)#>

				<CFTRANSACTION action="begin">
				<CFQUERY name="AddSRGroupReport1" datasource="#application.type#SERVICEREQUESTS">
					INSERT INTO	SRGROUPREPORT (SRGRID, FISCALYEARID, SERVICEREQUESTNUMBER, CREATIONDATE, CREATIONTIME,
											SERVICEDESKINITIALSID, REQUESTERID, ALTERNATE_CONTACTID, PROBLEM_CATEGORYID, PROBLEM_SUBCATEGORYID,
											PRIORITYID, GROUPASSIGNEDID, SERVICETYPEID, ACTIONID, OPTIONID, OPERATINGSYSTEMID,
											PROBLEM_DESCRIPTION, SRCOMPLETEDDATE)
					VALUES		(#val(FORM.SRGRID)#, #ListStaffAssignments.FISCALYEARID#, '#ListStaffAssignments.SERVICEREQUESTNUMBER#',
								TO_DATE('#ListStaffAssignments.CREATIONDATE#', 'MM/DD/YYYY'), TO_DATE('#ListStaffAssignments.CREATIONTIME#', 'HH24:MI:SS'),
								#ListStaffAssignments.SERVICEDESKINITIALSID#, #ListStaffAssignments.REQUESTERID#, #ListStaffAssignments.ALTERNATE_CONTACTID#,
								#ListStaffAssignments.PROBLEM_CATEGORYID#, #ListStaffAssignments.PROBLEM_SUBCATEGORYID#, #ListStaffAssignments.PRIORITYID#,
								#ListStaffAssignments.NEXT_ASSIGNMENT_GROUPID#, #ListStaffAssignments.SERVICETYPEID#, #ListStaffAssignments.ACTIONID#,
								#ListStaffAssignments.OPTIONID#, #ListStaffAssignments.OPERATINGSYSTEMID#, '#ListStaffAssignments.PROBLEM_DESCRIPTION#',
								TO_DATE('#ListStaffAssignments.SRCOMPLETEDDATE#', 'DD-MON-YYYY'))
				</CFQUERY>
				<CFTRANSACTION action = "commit"/>
				</CFTRANSACTION>

			</CFLOOP>

			<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
				SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, 
						TO_CHAR(SR.CREATIONDATE, 'DD-MON-YYYY') AS CREATIONDATE, TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME,
						SR.SERVICEDESKINITIALSID, SR.REQUESTERID, SR.ALTERNATE_CONTACTID, SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID,
						SR.PRIORITYID, SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID, SR.OPTIONID, SR.PROBLEM_DESCRIPTION,
						TO_CHAR(SR.SRCOMPLETEDDATE, 'DD-MON-YYYY') AS SRCOMPLETEDDATE
				FROM		SERVICEREQUESTS SR
				WHERE	SR.SRID > 0 AND
                    		SR.FISCALYEARID = #val(LookupFiscalYears.FISCALYEARID)# AND
					<CFIF #FORM.REPORTCHOICE# EQ 5>
						SR.GROUPASSIGNEDID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC">  AND
					</CFIF>
					<CFIF #FORM.REPORTCHOICE# EQ 6>
						SR.GROUPASSIGNEDID IN (#ValueList(LookupGroupNames.GROUPID)#) AND
					</CFIF>
						SR.GROUPASSIGNEDID > 0
				ORDER BY	SR.GROUPASSIGNEDID
			</CFQUERY>

			<CFLOOP query="ListServiceRequests">
				<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
					SELECT	MAX(SRGRID) AS MAX_ID
					FROM		SRGROUPREPORT
				</CFQUERY>
				<CFSET FORM.SRGRID =  #val(GetMaxUniqueID.MAX_ID+1)#>

				<CFTRANSACTION action="begin">
				<CFQUERY name="AddSRGroupReport2" datasource="#application.type#SERVICEREQUESTS">
					INSERT INTO	SRGROUPREPORT (SRGRID, FISCALYEARID, SERVICEREQUESTNUMBER, CREATIONDATE, CREATIONTIME,
								SERVICEDESKINITIALSID, REQUESTERID, ALTERNATE_CONTACTID, PROBLEM_CATEGORYID, PROBLEM_SUBCATEGORYID,
								PRIORITYID, GROUPASSIGNEDID, SERVICETYPEID, ACTIONID, OPTIONID, OPERATINGSYSTEMID, 
								PROBLEM_DESCRIPTION, SRCOMPLETEDDATE)
					VALUES		(#val(FORM.SRGRID)#, #ListServiceRequests.FISCALYEARID#, '#ListServiceRequests.SERVICEREQUESTNUMBER#',
								TO_DATE('#ListServiceRequests.CREATIONDATE#', 'DD-MON-YYYY'), TO_DATE('#ListServiceRequests.CREATIONTIME#', 'HH24:MI:SS'),
								#ListServiceRequests.SERVICEDESKINITIALSID#, #ListServiceRequests.REQUESTERID#, #ListServiceRequests.ALTERNATE_CONTACTID#,
								#ListServiceRequests.PROBLEM_CATEGORYID#, #ListServiceRequests.PROBLEM_SUBCATEGORYID#, #ListServiceRequests.PRIORITYID#,
								#ListServiceRequests.GROUPASSIGNEDID#, #ListServiceRequests.SERVICETYPEID#, #ListServiceRequests.ACTIONID#,
								#ListServiceRequests.OPTIONID#, #ListServiceRequests.OPERATINGSYSTEMID#, '#ListServiceRequests.PROBLEM_DESCRIPTION#',
								TO_DATE('#ListServiceRequests.SRCOMPLETEDDATE#', 'DD-MON-YYYY'))
				</CFQUERY>
				<CFTRANSACTION action = "commit"/>
				</CFTRANSACTION>

			</CFLOOP>
		</CFIF>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
               	<H1>SR Number Lists</H1>
                    <H2>
                    	#REPORTTITLE2# 
                    	<CFIF #FORM.REPORTCHOICE# NEQ 3> 
                    		For Fiscal Year: &nbsp;&nbsp;#LookupFiscalYears.FISCALYEAR_4DIGIT#
                         </CFIF>
                    </H2>
               </TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/servicerequestdbreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
	
	<CFIF #REPORTCHOICE# GTE 7 AND #REPORTCHOICE# LTE 9>
	
		<TR>
			<TH align="CENTER" colspan="14"><H2>#ListStaffAssignments.RecordCount# Service Request records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="center" valign="BOTTOM">SR Number</TH>
			<TH align="center" valign="BOTTOM">Creation Date</TH>
			<TH align="center" valign="BOTTOM">Creation Time</TH>
			<TH align="center" valign="BOTTOM">Priority</TH>
			<TH align="center" valign="BOTTOM">Requester</TH>
			<TH align="center" valign="BOTTOM">Alternate Contact</TH>
			<TH align="center" valign="BOTTOM">Problem Category</TH>
			<TH align="center" valign="BOTTOM">Sub-Category</TH>
			<TH align="center" valign="BOTTOM">Service Type</TH>
			<TH align="center" valign="BOTTOM">Action</TH>
			<TH align="center" valign="BOTTOM">Operating System</TH>
			<TH align="center" valign="BOTTOM">Group Assigned</TH>
			<TH align="center" valign="BOTTOM">SR Completed Date</TH>
			<TH align="center" valign="BOTTOM">Service Desk Initials</TH>
		</TR>
		
	<CFLOOP query="ListStaffAssignments">
	
		<CFIF IsDefined('STAFFHEADER') AND STAFFHEADER NEQ #ListStaffAssignments.STAFFNAME#>
			<CFSET STAFFHEADER= #ListStaffAssignments.STAFFNAME#>
		<TR>
			<TH align="left" nowrap colspan="3"><H2>#ListStaffAssignments.STAFFNAME#</H2></TH>
		</TR>
		</CFIF>
		<TR>
			<TD align="center" valign="TOP"><DIV>#ListStaffAssignments.SERVICEREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListStaffAssignments.CREATIONDATE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListStaffAssignments.CREATIONTIME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListStaffAssignments.PRIORITYNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListStaffAssignments.RNAME#</DIV></TD>
		<CFIF #ListStaffAssignments.ALTERNATE_CONTACTID# GT "0">
			<TD align="center" valign="TOP"><DIV>#ListStaffAssignments.ANAME#</DIV></TD>
		<CFELSE>
			<TD align="left" valign="TOP">&nbsp;</TD>
		</CFIF>
			<TD align="left" valign="TOP"><DIV>#ListStaffAssignments.PROBCATEGORY#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListStaffAssignments.PROBSUBCATEGORY#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListStaffAssignments.SERVICETYPENAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListStaffAssignments.ACTIONNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListStaffAssignments.OPSYSNAME#</DIV></TD>
		<CFIF #ListStaffAssignments.NEXT_ASSIGNMENT# EQ 'NO'>
			<TD align="left" valign="TOP"><DIV>#ListStaffAssignments.GROUPNAME#</DIV></TD>
		<CFELSE>
			<TD align="left" valign="TOP"><DIV>#ListStaffAssignments.REFGROUPNAME#</DIV></TD>
		</CFIF> 
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListStaffAssignments.SRCOMPLETEDDATE, "mm/dd/yyyy")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListStaffAssignments.INITIALS#</DIV></TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="14"><H2>#ListStaffAssignments.RecordCount# Service Request records were selected.</H2></TH>
		</TR>
	
	<CFELSE>
		<CFIF REPORTCHOICE GTE 4 AND REPORTCHOICE LTE 6>
			<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
				SELECT	SR.SRGRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
						TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SR.SERVICEDESKINITIALSID, SDINIT.FULLNAME AS INITIALS,
						REQ.FULLNAME AS RNAME, SR.ALTERNATE_CONTACTID, ALTCONTACT.FULLNAME AS ANAME, SR.PROBLEM_CATEGORYID,
						PROBCAT.CATEGORYLETTER || PROBCAT.CATEGORYNAME AS PROBCATEGORY, SR.PROBLEM_SUBCATEGORYID, 
						PROBSUBCAT.SUBCATEGORYNAME, SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID,
						IDTGROUP.GROUPNAME, SR.SERVICETYPEID, SERVICETYPES.SERVICETYPENAME, SR.ACTIONID, ACTIONS.ACTIONNAME, 
						SR.OPERATINGSYSTEMID, OPSYS.OPSYSNAME, SR.OPTIONID, OPTIONS.OPTIONNAME, TO_CHAR(SR.SRCOMPLETEDDATE, 'DD-MON-YYYY') AS SRCOMPLETEDDATE
				FROM		SRGROUPREPORT SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, LIBSHAREDDATAMGR.CUSTOMERS REQ,
						LIBSHAREDDATAMGR.CUSTOMERS ALTCONTACT, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY,
						GROUPASSIGNED IDTGROUP, SERVICETYPES, ACTIONS, OPSYS, OPTIONS
				WHERE	(SR.SRGRID > 0) AND
                    		(SR.FISCALYEARID = #val(LookupFiscalYears.FISCALYEARID)# AND
						SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
						SR.REQUESTERID = REQ.CUSTOMERID AND
						SR.ALTERNATE_CONTACTID = ALTCONTACT.CUSTOMERID AND
						SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
						SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
						SR.PRIORITYID = PRIORITY.PRIORITYID AND
						SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
						SR.SERVICETYPEID = SERVICETYPES.SERVICETYPEID AND
						SR.ACTIONID = ACTIONS.ACTIONID AND
						SR.OPERATINGSYSTEMID = OPSYS.OPSYSID AND 
						SR.OPTIONID = OPTIONS.OPTIONID)
				ORDER BY	#REPORTORDER#
			</CFQUERY>
		<CFELSE>
			<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
				SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
						TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SR.SERVICEDESKINITIALSID, SDINIT.FULLNAME AS INITIALS,
						REQ.FULLNAME AS RNAME, SR.ALTERNATE_CONTACTID, ALTCONTACT.FULLNAME AS ANAME, SR.PROBLEM_CATEGORYID,
						PROBCAT.CATEGORYLETTER || PROBCAT.CATEGORYNAME AS PROBCATEGORY, SR.PROBLEM_SUBCATEGORYID, 
						PROBSUBCAT.SUBCATEGORYNAME, SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID,
						IDTGROUP.GROUPNAME, SR.SERVICETYPEID, SERVICETYPES.SERVICETYPENAME, SR.ACTIONID, ACTIONS.ACTIONNAME, SR.PROBLEM_DESCRIPTION,
						SR.OPERATINGSYSTEMID, OPSYS.OPSYSNAME, SR.OPTIONID, OPTIONS.OPTIONNAME, TO_CHAR(SR.SRCOMPLETEDDATE, 'DD-MON-YYYY') AS SRCOMPLETEDDATE
				FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, LIBSHAREDDATAMGR.CUSTOMERS REQ,
						LIBSHAREDDATAMGR.CUSTOMERS ALTCONTACT, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY,
						GROUPASSIGNED IDTGROUP, SERVICETYPES, ACTIONS, OPSYS, OPTIONS
				WHERE	(SR.SRID > 0 AND
                    		SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID) AND
                    <CFIF REPORTCHOICE EQ 2>
                    		(SR.SERVICEDESKINITIALSID = <CFQUERYPARAM value="#FORM.SERVICEDESKINITIALSID#" cfsqltype="CF_SQL_NUMERIC">) AND
                    </CFIF>
                    <CFIF REPORTCHOICE EQ 3>
                    	<CFIF CREATIONDATERANGE EQ "YES">
                    		(CREATIONDATE BETWEEN TO_DATE('#BEGINCREATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDCREATIONDATE#', 'DD-MON-YYYY')) AND
                         <CFELSE>
                         	(SR.FISCALYEARID = #val(LookupFiscalYears.FISCALYEARID)#) AND
                         </CFIF>
                    <CFELSE>
                    		(SR.FISCALYEARID = #val(LookupFiscalYears.FISCALYEARID)#) AND
                    </CFIF>
						(SR.REQUESTERID = REQ.CUSTOMERID AND
						SR.ALTERNATE_CONTACTID = ALTCONTACT.CUSTOMERID AND
						SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
						SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
						SR.PRIORITYID = PRIORITY.PRIORITYID AND
						SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
						SR.SERVICETYPEID = SERVICETYPES.SERVICETYPEID AND
						SR.ACTIONID = ACTIONS.ACTIONID AND
						SR.OPERATINGSYSTEMID = OPSYS.OPSYSID AND 
						SR.OPTIONID = OPTIONS.OPTIONID)
				ORDER BY	#REPORTORDER#
			</CFQUERY>
		</CFIF>
		<TR>
			<TH align="CENTER" colspan="14"><H2>#ListServiceRequests.RecordCount# Service Request records were selected.</H2></TH>
		</TR>
          
          <CFIF #FORM.REPORTCHOICE# EQ "3">
          
          <TR>
			<TH align="center" valign="BOTTOM">SR</TH>
			<TH align="center" valign="BOTTOM">Creation Date</TH>
               <TH align="center" valign="BOTTOM">SR Completed Date</TH>
               <TH align="center" valign="BOTTOM">Requester</TH>
			<TH align="center" valign="BOTTOM">Alternate Contact</TH>
			<TH align="center" valign="BOTTOM">Problem Category</TH>
			<TH align="center" valign="BOTTOM">Sub-Category</TH>
               <TH align="center" valign="BOTTOM" colspan="6">Problem Description</TH>
          </TR>
	<CFLOOP query="ListServiceRequests">
		<TR>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.SERVICEREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.CREATIONDATE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListServiceRequests.SRCOMPLETEDDATE, "mm/dd/yyyy")#</DIV></TD>
			<TD align="center" valign="TOP" NOWRAP><DIV>#ListServiceRequests.RNAME#</DIV></TD>
			<CFIF #ListServiceRequests.ALTERNATE_CONTACTID# GT "0">
			<TD align="center" valign="TOP" NOWRAP><DIV>#ListServiceRequests.ANAME#</DIV></TD>
			<CFELSE>
			<TD align="left" valign="TOP">&nbsp;</TD>
			</CFIF>
			<TD align="left" valign="TOP" NOWRAP><DIV>#ListServiceRequests.PROBCATEGORY#</DIV></TD>
			<TD align="left" valign="TOP" NOWRAP><DIV>#ListServiceRequests.SUBCATEGORYNAME#</DIV></TD>
			<TD align="left" valign="TOP" colspan="6"><DIV>#ListServiceRequests.PROBLEM_DESCRIPTION#</DIV></TD>
		</TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
    	</CFLOOP>      
          <CFELSE>
          
		<TR>
			<TH align="center" valign="BOTTOM">SR</TH>
			<TH align="center" valign="BOTTOM">Creation Date</TH>
			<TH align="center" valign="BOTTOM">Creation Time</TH>
			<TH align="center" valign="BOTTOM">Priority</TH>
			<TH align="center" valign="BOTTOM">Requester</TH>
			<TH align="center" valign="BOTTOM">Alternate Contact</TH>
			<TH align="center" valign="BOTTOM">Problem Category</TH>
			<TH align="center" valign="BOTTOM">Sub-Category</TH>
			<TH align="center" valign="BOTTOM">Service Type</TH>
			<TH align="center" valign="BOTTOM">Action</TH>
			<TH align="center" valign="BOTTOM">Operating System</TH>
			<CFIF #FORM.REPORTCHOICE# EQ "1"> 
			<TH align="center" valign="BOTTOM">1st Group Assigned</TH>
			</CFIF>
			<TH align="center" valign="BOTTOM">SR Completed Date</TH>
			<TH align="center" valign="BOTTOM">Service Desk Initials</TH>
		</TR>
	<CFLOOP query="ListServiceRequests">
			<CFIF IsDefined('GROUPHEADER') AND GROUPHEADER NEQ #ListServiceRequests.GROUPNAME#>
				<CFSET GROUPHEADER = #ListServiceRequests.GROUPNAME#>
		<TR>
			<TH align="left" nowrap colspan="3"><H2>#ListServiceRequests.GROUPNAME#</H2></TH>
		</TR>
			</CFIF>
		<TR>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.SERVICEREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.CREATIONDATE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.CREATIONTIME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.PRIORITYNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.RNAME#</DIV></TD>
			<CFIF #ListServiceRequests.ALTERNATE_CONTACTID# GT "0">
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.ANAME#</DIV></TD>
			<CFELSE>
			<TD align="left" valign="TOP">&nbsp;</TD>
			</CFIF>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.PROBCATEGORY#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.SUBCATEGORYNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.SERVICETYPENAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.ACTIONNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.OPSYSNAME#</DIV></TD>
			<CFIF #FORM.REPORTCHOICE# EQ "1">
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.GROUPNAME#</DIV></TD>
			</CFIF>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListServiceRequests.SRCOMPLETEDDATE, "mm/dd/yyyy")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.INITIALS#</DIV></TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
	</CFLOOP>
		</CFIF>
		<TR>
			<TH align="CENTER" colspan="14"><H2>#ListServiceRequests.RecordCount# Service Request records were selected.</H2></TH>
		</TR>
	</CFIF>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/servicerequestdbreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="14">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>