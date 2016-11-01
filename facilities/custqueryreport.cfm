<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custqueryreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/13/2012 --->
<!--- Date in Production: 02/13/2012 --->
<!--- Module: Facilities - Customer Query Report --->
<!-- Last modified by John R. Pastori on 02/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/custqueryreport.cfm">
<CFSET CONTENT_UPDATED = "February 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Customer Query Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Service Requests Application!";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}


	function validateLookupFields() {
	
		if (document.LOOKUP.REQUESTERID.selectedIndex == "0" && document.LOOKUP.UNITID.selectedIndex == "0" && document.LOOKUP.SERVICEREQUESTNUMBER.value == '') {
			alertuser ("One of the three Lookup fields MUST be selected!");
			document.LOOKUP.REQUESTERID.focus();
			return false;
		}
		
		if (document.LOOKUP.WORKREQUESTNUMBER.value.length > 0 && document.LOOKUP.WORKREQUESTNUMBER.value.length < 9) {
			alertuser (document.LOOKUP.WORKREQUESTNUMBER.name +  ",  If you include an Work Request Number, it MUST be 9 characters in the format 2 digit fiscal year begin/end and 4 digit sequence number: yy/yy9999.");
			document.LOOKUP.WORKREQUESTNUMBER.focus();
		}

		if ((document.LOOKUP.BEGINDATE.value != "" && document.LOOKUP.ENDDATE.value == "")
		 || (document.LOOKUP.BEGINDATE.value == "" && document.LOOKUP.ENDDATE.value != "")) {
			alertuser ("You must enter a BEGIN DATE and an END DATE!");
			document.LOOKUP.BEGINDATE.focus();
			return false;
		}

	}

//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<CFSET CURSORFIELD = "document.LOOKUP.REQUESTERID.focus()">

<BODY onLoad="#CURSORFIELD#">

<!--- 
***********************************************************************************************
* The following code is the Look Up Process for Facilities - Customer Query Record Selection. *
***********************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPCUST')>


	<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
          SELECT	CUST.CUSTOMERID,CUST.EMAIL, CUST.FAX, CUST.FULLNAME, CUST.UNITID, U.GROUPID, CUST.ACTIVE
          FROM		CUSTOMERS CUST, UNITS U
          WHERE	(CUST.CUSTOMERID = 0 AND
                    CUST.UNITID = U.UNITID) OR	
                    (CUST.CATEGORYID IN (1,5,8,14,15) AND
                    CUST.UNITID = U.UNITID AND
                    U.GROUPID IN (2,3,4,6) AND
                    CUST.ACTIVE = 'YES')	
          ORDER BY	CUST.FULLNAME
     </CFQUERY>

	<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
		SELECT	U.UNITID, U.UNITNAME, G.GROUPNAME
		FROM		UNITS U, GROUPS G
		WHERE	(U.UNITID = 0 OR 
          		U.GROUPID IN (2,3,4,6)) AND
          		(U.GROUPID = G.GROUPID)
		ORDER BY	U.UNITNAME
	</CFQUERY>
     
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Customer Query Lookup</H1></TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>
                    	Select from either the Requester or Unit drop down boxes or type in a Work Request Number to choose report criteria.<BR />
					Optional dates and/or the Completion Flag drop down box refine selections.
				</H2>
               </TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/facilities/custqueryreport.cfm?LOOKUPCUST=FOUND" method="POST">
		<TR>
			<TH align="left"><LABEL for="REQUESTERID">Requester</LABEL></TH>
               <TH align="left"><LABEL for="UNITID">Or Unit</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left" valign="top">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="0" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
          <TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left"><LABEL for="WORKREQUESTNUMBER">Or Work Request Number</LABEL></TH>
               <TH align="left"><LABEL for="WOCOMPLETED">Work Request Completed?</LABEL></TH>
		</TR>
           <TR>
			<TD align="left">
               	<CFINPUT type="Text" name="WORKREQUESTNUMBER" id="WORKREQUESTNUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="4">
               </TD>
               <TD align="left">
				<CFSELECT name="WOCOMPLETED" id="WOCOMPLETED" size="1" tabindex="5">
                    	<OPTION value="Select">Select Status</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP"><LABEL for="BEGINDATE">Enter Begin Request Date</LABEL></TH>
			<TH align="left" valign="TOP"><LABEL for="ENDDATE">Enter End Request Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="BEGINDATE" id="BEGINDATE" value="" required="No" size="15" maxlength="25" tabindex="6">
                    <SCRIPT language="JavaScript">
					new tcal ({'formname': 'LOOKUP','controlname': 'BEGINDATE'});

				</SCRIPT>
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="ENDDATE" id="ENDDATE" value="" required="No" size="15" maxlength="25" tabindex="7">
                    <SCRIPT language="JavaScript">
					new tcal ({'formname': 'LOOKUP','controlname': 'ENDDATE'});

				</SCRIPT><BR />
			</TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="2"><COM> &nbsp;&nbsp;(Both a Begin Date and End Date MUST be entered when selecting records in a date range.)</COM></TD>
		</TR>
		<TR>
			<TD colspan="2"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TD align="LEFT">
				<BR /><INPUT type="submit" value="Go" tabindex="8" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="9" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="11"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
     
     <CFEXIT>

<CFELSE>

<!--- 
************************************************************************************
* The following code is the Facilities - Customer Query Report Generation Process. *
************************************************************************************
 --->

	<CFSET SESSION.DATERANGEREPORT = "NO">
	<CFIF IsDefined('FORM.BEGINDATE') AND #FORM.BEGINDATE# NEQ "">
		<CFSET SESSION.DATERANGEREPORT = "YES">
		<CFSET BEGINDATE = #DateFormat(FORM.BEGINDATE, "dd/mmm/yyyy")#>
		<CFSET ENDDATE = #DateFormat(FORM.ENDDATE, "dd/mmm/yyyy")#>
	</CFIF>
	

	<CFQUERY name="ListWorkRequests" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	WR.WORKREQUESTID, WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.REQUESTSTATUSID,
				RS.REQUESTSTATUSNAME, WR.REQUESTDATE, WR.REQUESTERID, REQCUST.FULLNAME AS RCNAME, WR.UNITID,
                    WR.PROBLEMDESCRIPTION, WR.INITAPPROVALDATE, WR.COMPLETIONDATE, WR.STATUS_COMMENTS
		FROM		WORKREQUESTS WR, REQUESTTYPES RT, REQUESTSTATUS RS, LIBSHAREDDATAMGR.CUSTOMERS REQCUST
		WHERE	WR.WORKREQUESTID > 0 AND

          	<CFIF IsDefined('FORM.REQUESTERID') AND #FORM.REQUESTERID# GT 0>
				WR.REQUESTERID = #val(FORM.REQUESTERID)# AND
			</CFIF>
               <CFIF IsDefined('FORM.UNITID') AND #FORM.UNITID# GT 0>
				WR.UNITID = #val(FORM.UNITID)# AND
			</CFIF>
               <CFIF IsDefined('FORM.WORKREQUESTNUMBER') AND #FORM.WORKREQUESTNUMBER# NEQ ''>
				WR.WORKREQUESTNUMBER = '#FORM.WORKREQUESTNUMBER#' AND
			</CFIF>
               <CFIF #FORM.WOCOMPLETED# GT 0 AND #FORM.WOCOMPLETED# EQ 'YES'>
				WR.COMPLETIONDATE < TO_DATE(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') AND
			</CFIF>
               <CFIF #FORM.WOCOMPLETED# EQ 'NO'>
				WR.COMPLETIONDATE IS NULL
			</CFIF>
			<CFIF #SESSION.DATERANGEREPORT# EQ "YES">
				WR.REQUESTDATE BETWEEN TO_DATE('#BEGINDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATE#', 'DD-MON-YYYY') AND
			</CFIF>
           
				WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
				WR.REQUESTSTATUSID = RS.REQUESTSTATUSID AND
				WR.REQUESTERID = REQCUST.CUSTOMERID
		ORDER BY	RCNAME, WR.WORKREQUESTNUMBER
	</CFQUERY>

	<CFIF #ListWorkRequests.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Your Work Request has not yet been Approved.");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/custqueryreport.cfm" />
			<CFEXIT>
	</CFIF>
     
     <CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
		SELECT	U.UNITID, U.UNITNAME
		FROM		UNITS U
		WHERE	U.UNITID = <CFQUERYPARAM value="#ListWorkRequests.UNITID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	U.UNITNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
               	<H1>Facilities - Customer Query Report</H1>
               <CFIF IsDefined('FORM.REQUESTERID') AND #FORM.REQUESTERID# GT 0>
				<H2>For Requester: &nbsp;&nbsp;#ListWorkRequests.RCNAME#</H2>
			</CFIF>
               <CFIF IsDefined('FORM.UNITID') AND #FORM.UNITID# GT 0>
				<H2>For Unit: &nbsp;&nbsp;#ListUnits.UNITNAME#</H2>
			</CFIF>
               <CFIF IsDefined('FORM.WORKREQUESTNUMBER') AND #FORM.WORKREQUESTNUMBER# NEQ ''>
				<H2>For WO ##: &nbsp;&nbsp;#ListWorkRequests.WORKREQUESTNUMBER#</H2>
			</CFIF>
               <CFIF IsDefined('FORM.BEGINDATE') AND #FORM.BEGINDATE# NEQ "">
               	<BR><H2>Request Begin Date = #DateFormat(FORM.BEGINDATE, "mm/dd/yyyy")# and End Date = #DateFormat(FORM.ENDDATE, "mm/dd/yyyy")#</H2>
               </CFIF>
               </TD>
               
		</TR>
	</TABLE>
<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/custqueryreport.cfm" method="POST">
			<TD align="left"><INPUT type="submit" value="Cancel" tabindex="1" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="7"><H2>#ListWorkRequests.RecordCount# Work Request records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="center" valign="BOTTOM">Problem Date</TH>
			<TH align="center" valign="BOTTOM">Requester</TH>
			<TH align="center" valign="BOTTOM">Work Request Number</TH>
			<TH align="center" valign="BOTTOM">Problem Description</TH>
               <TH align="center" valign="BOTTOM">Initial Approval Date</TH>
			<TH align="center" valign="BOTTOM">Request Status</TH>
			<TH align="center" valign="BOTTOM">Status Comments</TH>
		</TR>
	<CFLOOP query="ListWorkRequests">
	
		<TR>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListWorkRequests.REQUESTDATE, "mm/dd/yyyy")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.RCNAME#</DIV></TD>
 			<TD align="center" valign="TOP"><H3>#ListWorkRequests.WORKREQUESTNUMBER#</H3></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.PROBLEMDESCRIPTION#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#DateFormat(ListWorkRequests.INITAPPROVALDATE, "mm/dd/yyyy")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.REQUESTSTATUSNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.STATUS_COMMENTS#</DIV></TD>
		<TR>
			<TD align="left" valign="TOP" COLSPAN="7"><HR></TD>
		</TR>
	</CFLOOP>
	
		<TR>
			<TH align="CENTER" colspan="7"><H2>#ListWorkRequests.RecordCount# Work Request records were selected.</H2></TH>
		</TR>
	
		<TR>
<CFFORM action="/#application.type#apps/facilities/custqueryreport.cfm" method="POST">
			<TD align="left"><INPUT type="submit" value="Cancel" tabindex="2" /></TD>
	</CFFORM>
	</TR>
		<TR>
			<TD align="left" colspan="7">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>