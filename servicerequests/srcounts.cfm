<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: srcounts.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/20/2012 --->
<!--- Date in Production: 11/20/2012 --->
<!--- Module: IDT Service Requests - SR Statistic Counts --->
<!-- Last modified by John R. Pastori on 10/03/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/srcounts.cfm">
<cfset CONTENT_UPDATED = "October 03, 2016">
<cfinclude template = "../programsecuritycheck.cfm">


<html>
<head>
	<title>IDT Service Requests - SR Statistic Counts</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Service Requests";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}


	function validateLookupFields() {
		if ((document.LOOKUP1.REPORTCHOICE[1].checked == "1" || document.LOOKUP1.REPORTCHOICE[3].checked == "1"
		 || document.LOOKUP1.REPORTCHOICE[5].checked == "1"  || document.LOOKUP1.REPORTCHOICE[7].checked == "1")
		 && (document.LOOKUP1.BEGINDATE1.value == ""         || document.LOOKUP1.ENDDATE1.value == "")) {
			alertuser ("You must enter a BEGIN DATE and an END DATE if you chose REPORTS 2, 4, 6 or 8!");
			document.LOOKUP1.BEGINDATE1.focus();
			return false;
		}
		
		if ((document.LOOKUP2.REPORTCHOICE[1].checked == "1" || document.LOOKUP2.REPORTCHOICE[3].checked == "1"
		 || document.LOOKUP2.REPORTCHOICE[5].checked == "1"  || document.LOOKUP2.REPORTCHOICE[7].checked == "1"
		 || document.LOOKUP2.REPORTCHOICE[9].checked == "1")
		 && (document.LOOKUP2.BEGINDATE2.value == ""         || document.LOOKUP2.ENDDATE2.value == "")) {
			alertuser ("You must enter a BEGIN DATE and an END DATE if you chose REPORTS 10, 12, 14, 16 or 18!");
			document.LOOKUP2.BEGINDATE2.focus();
			return false;
		}
	}

//
</script>
<script language="JavaScript" src="../calendar_us.js"></script>
<!--Script ends here -->

</head>

<cfoutput>
<cfif NOT IsDefined('URL.PROCESS')>
	<cfset CURSORFIELD = "document.LOOKUP1.REPORTCHOICE[0].focus()">
<cfelse>
	<cfset CURSORFIELD = "">
</cfif>
<body onLoad="#CURSORFIELD#">

<!--- 
********************************************************************************************
* The following code is the Lookup Process for IDT Service Requests - SR Statistic Counts. *
********************************************************************************************
 --->

<cfif NOT IsDefined('URL.PROCESS')>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Select SR Statistic Counts</h1></td>
		</tr>
	</table>

<!--- 
******************************************************************************************
* The following code is the table creating the selections for the first 8 reports (1-8). *
******************************************************************************************
 --->
	<table width="100%" align="LEFT" border="0">
		<tr>
			<td align="LEFT" valign="TOP">&nbsp;&nbsp;</td>
<cfform action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<td align="LEFT" valign="TOP" colspan="2">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</tr>
           <tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
	</table>
          
     <fieldset>
     <legend>Primary Reports</legend>
<cfform name="LOOKUP1" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/srcounts.cfm?PROCESS=LOOKUP" method="POST">
	<table width="100%" align="LEFT" border="0">
		<tr>
			<td align="LEFT" valign="TOP" colspan="2"><COM>SELECT ONE OF THE EIGHT (8) REPORTS BELOW</COM></td>
		</tr>
		<tr>
			<td valign="TOP">&nbsp;&nbsp;</td>
			<td align="LEFT" valign="TOP"><input type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="2" /></td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="3">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE1">REPORT 1: All SRs 1st Group Count Report</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="4">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE2">REPORT 2: SRs 1st Group Count Report By Creation Date Range</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="5">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE3">REPORT 3: All SRs Problem Category Count Report</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="6">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE4">REPORT 4: SRs Problem Category Count Report By Creation Date Range</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="7">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE5">REPORT 5: All SR Requester's Category Count Report</label></th>
			<td align="LEFT" valign="TOP">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE6" value="6" align="LEFT" required="No" tabindex="8">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE6">REPORT 6: SR Requester's Category Count Report By Creation Date Range</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE7" value="7" align="LEFT" required="No" tabindex="9">
			</td>
			<th align="left" valign="TOP" nowrap><label for="REPORTCHOICE7">REPORT 7: All SRs Unit/Group Count Report</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE8" value="8" align="LEFT" required="No" tabindex="10">
			</td>
			<th align="left" valign="TOP" nowrap><label for="REPORTCHOICE8">REPORT 8: SRs Unit/Group Count Report By Creation Date Range</label></th>
			
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="LEFT" valign="TOP">
				<table width="100%" align="LEFT" border="0">
					<tr>
						<th align="left" valign="TOP"><label for="BEGINDATE1">Begin Creation Date (if you chose REPORTS 2, 4, 6 or 8)</label></th>
						<th align="left" valign="TOP"><label for="ENDDATE1">End Creation Date (if you chose REPORTS 2, 4, 6 or 8)</label></th>
					</tr>
					<tr>
						<td align="LEFT" valign="TOP">
							<cfinput type="TEXT" name="BEGINDATE1" id="BEGINDATE1" value="" required="No" size="15" maxlength="25" tabindex="11">
                                   <script language="JavaScript">
								new tcal ({'formname': 'LOOKUP1','controlname': 'BEGINDATE1'});

							</script>
						</td>
						<td align="LEFT" valign="TOP">
							<cfinput type="TEXT" name="ENDDATE1" id="ENDDATE1" value="" required="No" size="15" maxlength="25" tabindex="12">
                                   <script language="JavaScript">
								new tcal ({'formname': 'LOOKUP1','controlname': 'ENDDATE1'});

							</script><br />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td valign="TOP">&nbsp;&nbsp;</td>
			<td align="LEFT" valign="TOP"><input type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="13" /></td>
               <td valign="TOP">&nbsp;&nbsp;</td>
		</tr>
	</table>
</cfform>
	</fieldset>
	<br />
     <table width="100%" align="LEFT" border="0">
		<tr>
			<td align="LEFT" valign="TOP">&nbsp;&nbsp;</td>
<cfform action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<td align="LEFT" valign="TOP" colspan="2">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="14" /><br>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</tr>
          <tr>
			<td align="LEFT" colspan="3">&nbsp;&nbsp;</td>
		</tr>
          <tr>
			<td align="LEFT" colspan="3"><hr align="left" width="100%" size="5" noshade /></td>
		</tr>
          <tr>
			<td align="LEFT" colspan="3">&nbsp;&nbsp;</td>
		</tr>
	</table>
     
     <br><br><br><br>
  
<!--- 
********************************************************************************************
* The following code is the table creating the selections for the second 8 reports (9-16). *
********************************************************************************************
 ---> 
    
     <table width="100%" align="LEFT" border="0">
		<tr>
			<td align="LEFT" valign="TOP">&nbsp;&nbsp;</td>
<cfform action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<td align="LEFT" valign="TOP" colspan="3">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="15" /><br>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</tr>
          <tr>
			<td align="LEFT" colspan="3">&nbsp;&nbsp;</td>
		</tr>
	</table>
	<fieldset>
	<legend>Secondary Reports</legend>
<cfform name="LOOKUP2" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/srcounts.cfm?PROCESS=LOOKUP" method="POST">
	<table width="100%" align="LEFT">
		<tr>
			<td align="LEFT" valign="TOP" colspan="2"><COM>SELECT ONE OF THE TEN (10) REPORTS BELOW</COM></td>
		</tr>
		<tr>
			<td valign="TOP">&nbsp;&nbsp;</td>
			<td align="LEFT" valign="TOP"><input type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="16" /></td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE9" value="9" align="LEFT" required="No" tabindex="17">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE9">REPORT 9: All SRs Sub-Category Count Report</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE10" value="10" align="LEFT" required="No" tabindex="18">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE10">REPORT 10: SRs Sub-Category Count Report By Creation Date Range</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE11" value="11" align="LEFT" required="No" tabindex="19">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE11">REPORT 11: All SRs Service Type Count Report</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE12" value="12" align="LEFT" required="No" tabindex="20">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE12">REPORT 12: SRs Service Type Count Report By Creation Date Range</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE13" value="13" align="LEFT" required="No" tabindex="21">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE13">REPORT 13: All SR Actions Count Report</label></th>
			<td align="LEFT" valign="TOP">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE14" value="14" align="LEFT" required="No" tabindex="22">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE14">REPORT 14: SR Actions Count Report By Creation Date Range</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE15" value="15" align="LEFT" required="No" tabindex="23">
			</td>
			<th align="left" valign="TOP" nowrap><label for="REPORTCHOICE15">REPORT 15: All SRs Operating System Count Report</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE16" value="16" align="LEFT" required="No" tabindex="24">
			</td>
			<th align="left" valign="TOP" nowrap><label for="REPORTCHOICE16">REPORT 16: SRs Operating System Count Report By Creation Date Range</label></th>
			
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
          <tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE17" value="17" align="LEFT" required="No" tabindex="25">
			</td>
			<th align="left" valign="TOP" nowrap><label for="REPORTCHOICE17">REPORT 17: All SRs Service Desk Initials Count Report</label></th>
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE18" value="18" align="LEFT" required="No" tabindex="26">
			</td>
			<th align="left" valign="TOP" nowrap><label for="REPORTCHOICE18">REPORT 18: SRs Service Desk Initials Count Report By Creation Date Range</label></th>
			
			<td>&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="LEFT" valign="TOP">
				<table width="100%" align="LEFT" border="0">
					<tr>
						<th align="left" valign="TOP"><label for="BEGINDATE2">Begin Creation Date (if you chose REPORTS 10, 12, 14, 16 or 18)</label></th>

						<th align="left" valign="TOP"><label for="ENDDATE2">End Creation Date (if you chose REPORTS 10, 12, 14, 16 or 18)</label></th>
					</tr>
					<tr>
						<td align="LEFT" valign="TOP">
							<cfinput type="TEXT" name="BEGINDATE2" id="BEGINDATE2" value="" required="No" size="15" maxlength="25" tabindex="27">
                                   <script language="JavaScript">
								new tcal ({'formname': 'LOOKUP2','controlname': 'BEGINDATE2'});

							</script>
						</td>
						<td align="LEFT" valign="TOP">
							<cfinput type="TEXT" name="ENDDATE2" id="ENDDATE2" value="" required="No" size="15" maxlength="25" tabindex="28">
                                   <script language="JavaScript">
								new tcal ({'formname': 'LOOKUP2','controlname': 'ENDDATE2'});

							</script><br />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td valign="TOP">&nbsp;&nbsp;</td>
			<td align="LEFT" valign="TOP"><input type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="29" /></td>
               <td valign="TOP">&nbsp;&nbsp;</td>
		</tr>
	</table>
</cfform>
	</fieldset>
	<br /><br />
     <table width="100%" align="LEFT">
		<tr>
			<td align="LEFT" valign="TOP">&nbsp;&nbsp;</td>
<cfform action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<td align="LEFT" valign="TOP">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="30" /><br>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
               <td align="LEFT" valign="TOP">&nbsp;&nbsp;</td>
</cfform>
		</tr>
          <tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="left" valign="TOP" colspan="3">
				<cfinclude template="/include/coldfusion/footer.cfm">
			</td>
		</tr>
	</table>

<cfelse>

<!--- 
********************************************************************************************
* The following code is the IDT Service Requests - SR Statistic Counts Generation Process. *
********************************************************************************************
 --->

	<cfset SORTORDER = ARRAYNEW(1)>
	<cfset SORTORDER[1] = 'IDTGROUP.GROUPNAME, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[2] = 'IDTGROUP.GROUPNAME, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[3] = 'PROBCATEGORY, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[4] = 'PROBCATEGORY, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[5] = 'CAT.CATEGORYNAME, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[6] = 'CAT.CATEGORYNAME, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[7] = 'UNITS.UNITNAME, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[8] = 'UNITS.UNITNAME, SR.SERVICEREQUESTNUMBER'>
     <cfset SORTORDER[9] = 'PROBSUBCATEGORY, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[10] = 'PROBSUBCATEGORY, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[11] = 'ST.SERVICETYPENAME, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[12] = 'ST.SERVICETYPENAME, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[13] = 'ACT.ACTIONNAME, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[14] = 'ACT.ACTIONNAME, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[15] = 'OS.OPSYSNAME, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[16] = 'OS.OPSYSNAME, SR.SERVICEREQUESTNUMBER'>
     <cfset SORTORDER[17] = 'SDINIT.INITIALS, SR.SERVICEREQUESTNUMBER'>
	<cfset SORTORDER[18] = 'SDINIT.INITIALS, SR.SERVICEREQUESTNUMBER'>
	
	<cfset REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>
	<!--- REPORT ORDER = #REPORTORDER#<BR /><BR /> --->

	<cfset DATERANGEREPORT = "NO">
	<cfif #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 6 OR #FORM.REPORTCHOICE# EQ 8>
		<cfset DATERANGEREPORT = "YES">
		<cfset BEGINDATE = #DateFormat(FORM.BEGINDATE1, "dd/mmm/yyyy")#>
		<cfset ENDDATE = #DateFormat(FORM.ENDDATE1, "dd/mmm/yyyy")#>
		<!--- BEGIN DATE = #BEGINDATE1# &nbsp;&nbsp;&nbsp;&nbsp;END DATE = #ENDDATE1#<BR /><BR /> --->
	</cfif>
     
     <cfif #FORM.REPORTCHOICE# EQ 10 OR #FORM.REPORTCHOICE# EQ 12 OR #FORM.REPORTCHOICE# EQ 14 OR #FORM.REPORTCHOICE# EQ 16 OR #FORM.REPORTCHOICE# EQ 18>
		<cfset DATERANGEREPORT = "YES">
		<cfset BEGINDATE = #DateFormat(FORM.BEGINDATE2, "dd/mmm/yyyy")#>
		<cfset ENDDATE = #DateFormat(FORM.ENDDATE2, "dd/mmm/yyyy")#>
		<!--- BEGIN DATE = #BEGINDATE2# &nbsp;&nbsp;&nbsp;&nbsp;END DATE = #ENDDATE2#<BR /><BR /> --->
	</cfif>


	<cfquery name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE,
			<CFIF #FORM.REPORTCHOICE# EQ 1 OR #FORM.REPORTCHOICE# EQ 2>
				SR.GROUPASSIGNEDID, IDTGROUP.GROUPNAME,
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 3 OR #FORM.REPORTCHOICE# EQ 4>
				SR.PROBLEM_CATEGORYID, PC.CATEGORYLETTER || PC.CATEGORYNAME AS PROBCATEGORY,
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 5 OR #FORM.REPORTCHOICE# EQ 6>
				REQ.FULLNAME AS RNAME, REQ.CATEGORYID AS REQCATID, CAT.CATEGORYID AS CATID, CAT.CATEGORYNAME,
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 7 OR #FORM.REPORTCHOICE# EQ 8>
				REQ.UNITID AS RUNIT, UNITS.UNITID AS UUNIT, UNITS.UNITNAME, UNITS.DEPARTMENTID, DEPTS.DEPARTMENTID AS DEPTID, DEPTS.DEPARTMENTNAME,
				UNITS.UNITNAME || '  -  ' || DEPTS.DEPARTMENTNAME AS UNITDEPT,
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 9 OR #FORM.REPORTCHOICE# EQ 10>
				SR.PROBLEM_SUBCATEGORYID, PC.CATEGORYNAME, PC.CATEGORYNAME || '  -  ' || PSC.SUBCATEGORYNAME AS PROBSUBCATEGORY,
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 11 OR #FORM.REPORTCHOICE# EQ 12>
				SR.SERVICETYPEID, ST.SERVICETYPENAME,
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 13 OR #FORM.REPORTCHOICE# EQ 14>
				SR.ACTIONID, ACT.ACTIONNAME,
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 15 OR #FORM.REPORTCHOICE# EQ 16>
				SR.OPERATINGSYSTEMID, OS.OPSYSNAME,
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 17 OR #FORM.REPORTCHOICE# EQ 18>
				SR.SERVICEDESKINITIALSID, SDINIT.INITIALS, SDINIT.FULLNAME,
			</CFIF>
				SR.FISCALYEARID, FY.FISCALYEARID, SR.SRCOMPLETED
		FROM		SERVICEREQUESTS SR,
			<CFIF #FORM.REPORTCHOICE# EQ 1 OR #FORM.REPORTCHOICE# EQ 2>
				GROUPASSIGNED IDTGROUP,
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 3 OR #FORM.REPORTCHOICE# EQ 4>
				PROBLEMCATEGORIES PC, 
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 5 OR #FORM.REPORTCHOICE# EQ 6>
				LIBSHAREDDATAMGR.CUSTOMERS REQ, LIBSHAREDDATAMGR.CATEGORIES CAT, 
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 7 OR #FORM.REPORTCHOICE# EQ 8>	
				LIBSHAREDDATAMGR.CUSTOMERS REQ, LIBSHAREDDATAMGR.UNITS UNITS, LIBSHAREDDATAMGR.DEPARTMENTS DEPTS,
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 9 OR #FORM.REPORTCHOICE# EQ 10>
				PROBLEMSUBCATEGORIES PSC, PROBLEMCATEGORIES PC,
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 11 OR #FORM.REPORTCHOICE# EQ 12>
				SERVICETYPES ST,
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 13 OR #FORM.REPORTCHOICE# EQ 14>
				ACTIONS ACT,
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 15 OR #FORM.REPORTCHOICE# EQ 16>
				OPSYS OS,
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 17 OR #FORM.REPORTCHOICE# EQ 18>
				LIBSHAREDDATAMGR.CUSTOMERS SDINIT,
			</CFIF>
				LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	SR.SRID > 0 AND
			<CFIF #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 6 OR #FORM.REPORTCHOICE# EQ 8>
				SR.CREATIONDATE BETWEEN TO_DATE('#BEGINDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATE#', 'DD-MON-YYYY') AND
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 10 OR #FORM.REPORTCHOICE# EQ 12 OR #FORM.REPORTCHOICE# EQ 14 OR #FORM.REPORTCHOICE# EQ 16 OR #FORM.REPORTCHOICE# EQ 18>
				SR.CREATIONDATE BETWEEN TO_DATE('#BEGINDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATE#', 'DD-MON-YYYY') AND
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 1 OR #FORM.REPORTCHOICE# EQ 2>
				SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 3 OR #FORM.REPORTCHOICE# EQ 4>
				SR.PROBLEM_CATEGORYID = PC.CATEGORYID AND
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 5 OR #FORM.REPORTCHOICE# EQ 6>
				SR.REQUESTERID = REQ.CUSTOMERID AND
				REQ.CATEGORYID = CAT.CATEGORYID AND
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 7 OR #FORM.REPORTCHOICE# EQ 8>
				SR.REQUESTERID = REQ.CUSTOMERID AND
				REQ.UNITID = UNITS.UNITID AND
				UNITS.DEPARTMENTID = DEPTS.DEPARTMENTID AND
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 9 OR #FORM.REPORTCHOICE# EQ 10>
				SR.PROBLEM_SUBCATEGORYID = PSC.SUBCATEGORYID AND
				PSC.SUBCATEGORYLETTERID = PC.CATEGORYID AND
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 11 OR #FORM.REPORTCHOICE# EQ 12>
				SR.SERVICETYPEID = ST.SERVICETYPEID AND
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 13 OR #FORM.REPORTCHOICE# EQ 14>
				SR.ACTIONID = ACT.ACTIONID AND
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 15 OR #FORM.REPORTCHOICE# EQ 16>
				SR.OPERATINGSYSTEMID = OS.OPSYSID AND
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 17 OR #FORM.REPORTCHOICE# EQ 18>
				SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
			</CFIF>
               	NOT SR.SRCOMPLETED = 'VOIDED' AND
				SR.FISCALYEARID = FY.FISCALYEARID
		ORDER BY	#REPORTORDER#
	</cfquery>

<!--- 
*******************************************************************************
* The following code displays the IDT Service Requests - SR Statistic Counts. *
*******************************************************************************
 --->

     <cfset CATNAME = "">
	<cfset COLUMN1TITLE = "">
	<cfset COLUMN2TITLE = "">
     <cfset COMPAREITEMNAME = "">
     <cfset COMPAREITEMNAME2 = "">
	<cfset FIELDNAME = "">
	<cfset ITEMNAME = "">
     <cfset ITEMNAME2 = "">
	<cfset ITEMSRCOUNT = 0>
     <cfset PROBCATNAME = "">
	<cfset REPORTTITLE = "">
	<cfset TOTALSRCOUNT = 0>

	<cfswitch expression = #FORM.REPORTCHOICE#>
	
		<cfcase value = 1>
			<cfset COLUMN1TITLE = "1st Group Assigned">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#">
			<cfset FIELDNAME = "ListServiceRequests.GROUPNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.GROUPNAME#>
		</cfcase>
	
		<cfcase value = 2>
			<cfset COLUMN1TITLE = "1st Group Assigned">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
			<cfset FIELDNAME = "ListServiceRequests.GROUPNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.GROUPNAME#>
		</cfcase>
	
		<cfcase value = 3>
			<cfset COLUMN1TITLE = "Problem Category">
			<cfset COLUMN2TITLE = " SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#">
			<cfset FIELDNAME = "ListServiceRequests.PROBCATEGORY">
			<cfset COMPAREITEMNAME = #ListServiceRequests.PROBCATEGORY#>
		</cfcase>
	
		<cfcase value = 4>
			<cfset COLUMN1TITLE = "Problem Category">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
			<cfset FIELDNAME = "ListServiceRequests.PROBCATEGORY">
			<cfset COMPAREITEMNAME = #ListServiceRequests.PROBCATEGORY#>
		</cfcase>
	
		<cfcase value = 5>
			<cfset COLUMN1TITLE = "Requester Category">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#">
			<cfset FIELDNAME = "ListServiceRequests.CATEGORYNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.CATEGORYNAME#>
		</cfcase>
	
		<cfcase value = 6>
			<cfset COLUMN1TITLE = "Requester Category">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
			<cfset FIELDNAME = "ListServiceRequests.CATEGORYNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.CATEGORYNAME#>
		</cfcase>
	
		<cfcase value = 7>
			<cfset COLUMN1TITLE = "Requester Unit/Group">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#">
			<cfset FIELDNAME = "ListServiceRequests.UNITDEPT">
			<cfset COMPAREITEMNAME = #ListServiceRequests.UNITDEPT#>
		</cfcase>
	
		<cfcase value = 8>
			<cfset COLUMN1TITLE = "Requester Unit/Group">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
			<cfset FIELDNAME = "ListServiceRequests.UNITDEPT">
			<cfset COMPAREITEMNAME = #ListServiceRequests.UNITDEPT#>
		</cfcase>
	
		<cfcase value = 9>
			<cfset COLUMN1TITLE = "Sub-Category">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#">
			<cfset FIELDNAME = "ListServiceRequests.PROBSUBCATEGORY">
			<cfset COMPAREITEMNAME = #ListServiceRequests.PROBSUBCATEGORY#>
               <cfset PROBCATNAME = "ListServiceRequests.CATEGORYNAME">
               <cfset COMPARECATNAME = #ListServiceRequests.CATEGORYNAME#>
		</cfcase>
	
		<cfcase value = 10>
			<cfset COLUMN1TITLE = "Sub-Category">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
			<cfset FIELDNAME = "ListServiceRequests.PROBSUBCATEGORY">
			<cfset COMPAREITEMNAME = #ListServiceRequests.PROBSUBCATEGORY#>
               <cfset PROBCATNAME = "ListServiceRequests.CATEGORYNAME">
			<cfset COMPARECATNAME = #ListServiceRequests.CATEGORYNAME#>
		</cfcase>
	
		<cfcase value = 11>
			<cfset COLUMN1TITLE = "Service Type">
			<cfset COLUMN2TITLE = " SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#">
			<cfset FIELDNAME = "ListServiceRequests.SERVICETYPENAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.SERVICETYPENAME#>
		</cfcase>
	
		<cfcase value = 12>
			<cfset COLUMN1TITLE = "Service Type">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
			<cfset FIELDNAME = "ListServiceRequests.SERVICETYPENAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.SERVICETYPENAME#>
		</cfcase>
	
		<cfcase value = 13>
			<cfset COLUMN1TITLE = "Actions">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#">
			<cfset FIELDNAME = "ListServiceRequests.ACTIONNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.ACTIONNAME#>
		</cfcase>
	
		<cfcase value = 14>
			<cfset COLUMN1TITLE = "Actions">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
			<cfset FIELDNAME = "ListServiceRequests.ACTIONNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.ACTIONNAME#>
		</cfcase>
	
		<cfcase value = 15>
			<cfset COLUMN1TITLE = "Operating System">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#">
			<cfset FIELDNAME = "ListServiceRequests.OPSYSNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.OPSYSNAME#>
		</cfcase>
	
		<cfcase value = 16>
			<cfset COLUMN1TITLE = "Operating System">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
			<cfset FIELDNAME = "ListServiceRequests.OPSYSNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.OPSYSNAME#>
		</cfcase>
          
          <cfcase value = 17>
			<cfset COLUMN1TITLE = "Service Desk Initials / Name">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#">
			<cfset FIELDNAME = "ListServiceRequests.INITIALS">
               <cfset FIELDNAME2 = "ListServiceRequests.FULLNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.INITIALS#>
               <cfset COMPAREITEMNAME2 = #ListServiceRequests.FULLNAME#>
		</cfcase>
          
          <cfcase value = 18>
			<cfset COLUMN1TITLE = "Service Desk Initials / Name">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
			<cfset FIELDNAME = "ListServiceRequests.INITIALS">
               <cfset FIELDNAME2 = "ListServiceRequests.FULLNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.INITIALS#>
               <cfset COMPAREITEMNAME2 = #ListServiceRequests.FULLNAME#>
		</cfcase>
	
     	<cfdefaultcase>
			<cfset COLUMN1TITLE = "1st Group Assigned">
			<cfset COLUMN2TITLE = "SR Statistic Counts">
			<cfset REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")#">
			<cfset FIELDNAME = "ListServiceRequests.GROUPNAME">
			<cfset COMPAREITEMNAME = #ListServiceRequests.GROUPNAME#>
		</cfdefaultcase>
		
	</cfswitch>

<!--- REPORT TITLE = #REPORTTITLE#<BR><BR>
COLUMN 1 TITLE = #COLUMN1TITLE#<BR><BR>
COLUMN 2 TITLE = #COLUMN2TITLE#<BR><BR>
FIELD NAME = #Evaluate("#FIELDNAME#")#<BR><BR>
COMPARE ITEM NAME = #COMPAREITEMNAME#<BR><BR> --->

	<table width="100%" align="center" border="3">
		<tr align="center">
			<th align="center"><h1>#REPORTTITLE#</h1></th>
		</tr>
	</table>
	<table width="100%" align="left" border="0">
		<tr>
<cfform action="/#application.type#apps/servicerequests/srcounts.cfm" method="POST">
			<td align="left"><input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /></td>
</cfform>
		</tr>
		<tr>
			<th align="LEFT" valign="TOP" width="30%">#COLUMN1TITLE#</th>
			<th align="LEFT" valign="TOP" width="70%">#COLUMN2TITLE#</th>
		</tr>
	<cfloop query="ListServiceRequests">
		<cfset ITEMNAME = #Evaluate("#FIELDNAME#")#>
          <cfif #FORM.REPORTCHOICE# EQ 9 OR #FORM.REPORTCHOICE# EQ 10>
			<cfset CATNAME = #Evaluate("#PROBCATNAME#")#>
          </cfif>
          <cfif #FORM.REPORTCHOICE# EQ 17 OR #FORM.REPORTCHOICE# EQ 18>
			<cfset ITEMNAME2 = #Evaluate("#FIELDNAME2#")#>
          </cfif>
		<cfif #COMPAREITEMNAME# EQ #ITEMNAME#>
			<!--- COMPARE ITEM NAME = #COMPAREITEMNAME#<BR><BR> --->
			<cfset ITEMSRCOUNT = #ITEMSRCOUNT# + 1>
			<!--- ITEM SR COUNT = #ITEMSRCOUNT#<BR><BR> --->
		<cfelse>
		<tr>
			<td align="LEFT" valign="TOP" width="30%">
				<cfset TOTALSRCOUNT  = #TOTALSRCOUNT# + #ITEMSRCOUNT#>
			<!--- <BR><BR>TOTAL SR COUNT = #TOTALSRCOUNT# --->
			<cfif #FORM.REPORTCHOICE# EQ 17 OR #FORM.REPORTCHOICE# EQ 18>
                    #COMPAREITEMNAME# - #COMPAREITEMNAME2#
               </TD>
                    <cfset COMPAREITEMNAME2 = #ITEMNAME2#>
               <cfelse>
                    #COMPAREITEMNAME#
               </cfif>
                    <cfset COMPAREITEMNAME = #ITEMNAME#>
		<!---	SET NEW ITEM NAME = #COMPAREITEMNAME#<BR><BR> --->
			</TD>
			<td align="LEFT" valign="TOP" width="70%">
				#NUMBERFORMAT(ITEMSRCOUNT, '___,___')#
				<cfset ITEMSRCOUNT = 1>
		<!---	RESET ITEM SR COUNT = #ITEMSRCOUNT#<BR><BR> --->
			</td>
		</tr>
          	<cfif #FORM.REPORTCHOICE# EQ 9 OR #FORM.REPORTCHOICE# EQ 10> 
               	<cfif NOT (#COMPARECATNAME# EQ #CATNAME#)>
          <tr>
			<td colspan="2">
               	&nbsp;&nbsp;
                    	<cfset COMPARECATNAME = #CATNAME#>
               </td>
		</tr>
          		</cfif>
			</cfif>
		</cfif>
	</cfloop>
		<tr>
          <cfif #FORM.REPORTCHOICE# EQ 17 OR #FORM.REPORTCHOICE# EQ 18>
			<td align="LEFT" valign="TOP" width="30%">
               	#ITEMNAME# - #ITEMNAME2#
               </td>
		<cfelse>
			<td align="LEFT" valign="TOP" width="30%">#ITEMNAME#</td>
          </cfif>
			<td align="LEFT" valign="TOP" width="70%">
				#NUMBERFORMAT(ITEMSRCOUNT, '___,___')#
				<cfset TOTALSRCOUNT = #TOTALSRCOUNT# + #ITEMSRCOUNT#>
			</td>
		</tr>
		<tr>
			<th align="LEFT" valign="TOP" colspan="2"><h2>Total #COLUMN2TITLE# = #TOTALSRCOUNT#</h2></th>
		</tr>
		<tr>
<cfform action="/#application.type#apps/servicerequests/srcounts.cfm" method="POST">
			<td align="left"><input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /></td>
</cfform>
		</tr>
		<tr>
			<td align="left" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</cfif>

</body>
</cfoutput>
</html>