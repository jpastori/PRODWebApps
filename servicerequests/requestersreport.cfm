<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: requestersreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/04/2009 --->
<!--- Date in Production: 02/04/2009 --->
<!--- Module: IDT Service Requests - Unit/Group Service Request Report --->
<!-- Last modified by John R. Pastori on 02/04/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/requestersreport.cfm">
<CFSET CONTENT_UPDATED = "February 04, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">


<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Unit/Group Service Request Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Service Requests Application!";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {
		function validateLookupFields() {
		if (document.LOOKUP.UNITID.selectedIndex == "0") {
			alertuser ("You must Select a Unit!");
			document.LOOKUP.UNITID.focus();
			return false;
		}

		if ((document.LOOKUP.BEGINDATE.value != ""       && document.LOOKUP.ENDDATE.value == "")
		 || (document.LOOKUP.BEGINDATE.value == ""       && document.LOOKUP.ENDDATE.value != "")) {
			alertuser ("You must enter a BEGIN DATE and an END DATE!");
			document.LOOKUP.BEGINDATE.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPUNIT')>
	<CFSET CURSORFIELD = "document.LOOKUP.REQUESTERID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
**********************************************************************************************************
* The following code is the Lookup Process for IDT Service Requests - Unit/Group Service Request Report. *
**********************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPUNIT')>

	<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FIRSTNAME, CUST.FULLNAME, CUST.ACTIVE
		FROM		CUSTOMERS CUST
		WHERE	CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>IDT Service Requests - Unit/Group Service Request Report Selection Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH  align="center"><H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
			Checking an adjacent checkbox will Negate the selection or data entered.</H2></TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT"><INPUT type="submit" value="Cancel" tabindex="1" /></TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/requestersreport.cfm?LOOKUPUNIT=FOUND" method="POST">
		<TR>
			<TH align="left"><LABEL for="REQUESTERID">Unit/Group Name</LABEL></TH>
			<TH align="left"><LABEL for="SRCOMPLETED">Completed SR?</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="7"></CFSELECT>
			</TD>
			<TD align="left" valign="top">
				<CFSELECT name="SRCOMPLETED" id="SRCOMPLETED" size="1" tabindex="2">
					<OPTION selected value="0">Select A Status</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
					<OPTION value="VOIDED">VOIDED</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP"><LABEL for="BEGINDATE">Enter Begin Creation Date.</LABEL></TH>
			<TH align="left" valign="TOP"><LABEL for="ENDDATE">Enter End Creation Date.</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="BEGINDATE" id="BEGINDATE" value="" required="No" size="15" maxlength="25" tabindex="3">
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="ENDDATE" id="ENDDATE" value="" required="No" size="15" maxlength="25" tabindex="4"><BR />
			</TD>
		</TR>
		<TR>
			<TD colspan="2"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TD align="LEFT">
				<BR /><INPUT type="submit" name="ProcessLookup" value="Select Options" tabindex="5" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT"><INPUT type="submit" value="Cancel" tabindex="6" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="11"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
***********************************************************************************
* The following code is the Unit/Group Service Request Report Generation Process. *
***********************************************************************************
 --->

	<CFQUERY name="LookupRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FULLNAME, UNITS.UNITID, UNITS.UNITNAME, GROUPS.GROUPID, GROUPS.GROUPNAME, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS, GROUPS
		WHERE	CUST.CUSTOMERID = #FORM.CUSTOMERID# AND
				CUST.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				CUST.ACTIVE ='YES'
		ORDER BY	FULLNAME
	</CFQUERY>
	
	<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
				TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SDINIT.FULLNAME, SR.REQUESTERID, REQCUST.CUSTOMERID, REQCUST.FULLNAME AS REQNAME,
				REQCUST.UNITID, PROBCAT.CATEGORYLETTER, PROBCAT.CATEGORYNAME, SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID,
				PROBCAT.CATEGORYLETTER || PROBCAT.CATEGORYNAME AS PROBCATEGORY, SR.PROBLEM_SUBCATEGORYID, PROBSUBCAT.SUBCATEGORYNAME,
				SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID, IDTGROUP.GROUPNAME, SR.PROBLEM_DESCRIPTION, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY,
				GROUPASSIGNED IDTGROUP, LIBSHAREDDATAMGR.CUSTOMERS REQCUST
		WHERE	SR.REQUESTERID IN (#ValueList(LookupRequesters.CUSTOMERID)#) AND
				SR.REQUESTERID = REQCUST.CUSTOMERID AND
				SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
				SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
				SR.REQUESTERID = REQCUST.CUSTOMERID AND
				SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
				SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
				SR.PRIORITYID = PRIORITY.PRIORITYID
		ORDER BY	SR.SERVICEREQUESTNUMBER
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>IDT Service Requests - Unit/Group Service Request Report</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/requestersrreport.cfm" method="POST">
			<TD align="left"><INPUT type="submit" value="Cancel" tabindex="1" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="14"><H2>#ListServiceRequests.RecordCount# Service Request  records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="center">Unit/Group</TH>
			<TH align="center">Service Request Number</TH>
			<TH align="center">Creation Date</TH>
			<TH align="center">Priority</TH>
			<TH align="center">Problem Category</TH>
			<TH align="center">Problem Sub-Category</TH>
			<TH align="center">Problem Description</TH>
			<TH align="center">BarCode Number</TH>
			<TH align="center">1st-Group Assigned</TH>
			<TH align="center">Completed SR?</TH>
			<TH align="center">SR Completed Date</TH>
		</TR>
		<TR>
			<TH align="left" nowrap colspan="3"><H2>#ListServiceRequests.REQNAME#</H2></TH>
		</TR>
	<CFLOOP query="ListServiceRequests">
		<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	UNITS.UNITID, UNITS.UNITNAME, GROUPS.GROUPNAME, UNITS.UNITNAME || ' - ' || GROUPS.GROUPNAME AS UNITGROUP
			FROM		UNITS, GROUPS
			WHERE	UNITS.UNITID = #ListServiceRequests.UNITID# AND
					UNITS.GROUPID = GROUPS.GROUPID
			ORDER BY	UNITS.UNITNAME
		</CFQUERY>
	
		<TR>
			<TD align="center" valign="TOP"><DIV>#LookupUnits.UNITGROUP#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.SERVICEREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.CREATIONDATE#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.PRIORITYNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.PROBCATEGORY#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.SUBCATEGORYNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.PROBLEM_DESCRIPTION#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.CREATIONTIME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.GROUPNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.SRCOMPLETED#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListServiceRequests.SRCOMPLETEDDATE, "mm/dd/yyyy")#</DIV></TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
	</CFLOOP>
	
		<TR>
			<TH align="CENTER" colspan="11"><H2>#ListServiceRequests.RecordCount# Service Request records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/requestersreport.cfm" method="POST">
			<TD align="left"><INPUT type="submit" value="Cancel" tabindex="2" /></TD>
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
</CFOUTPUT>
</HTML>