<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custnetworkvoiceworeport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/27/2014 --->
<!--- Date in Production: 03/27/2014 --->
<!--- Module: Service Request - Customer Network/Voice Work Order Report --->
<!-- Last modified by John R. Pastori on 03/27/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/custnetworkvoiceworeport.cfm">
<CFSET CONTENT_UPDATED = "March 27, 2014">

<CFOUTPUT>
<CFIF (FIND('wiki', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "WIKI")>
	<CFSET SESSION.ORIGINSERVER = "WIKI">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSEIF (FIND('#application.type#apps/forms', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "FORMS")>
	<CFSET SESSION.ORIGINSERVER = "FORMS">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSEIF (FIND('rohan', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "ROHAN")>
	<CFSET SESSION.ORIGINSERVER = "ROHAN">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSE>
	<CFINCLUDE template = "../programsecuritycheck.cfm">
	<CFSET SESSION.ORIGINSERVER = "">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
</CFIF>

<HTML>
<HEAD>

<CFIF #URL.PROCESS# EQ "NETWORK">
	<TITLE>Customer Network Work Order Report</TITLE>
<CFELSE>
	<TITLE>Customer Voice Work Order Report</TITLE>
</CFIF>
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
	
		if (document.LOOKUP.REQUESTERID.selectedIndex == "0" && document.LOOKUP.ALTERNATE_CONTACTID.selectedIndex == "0"
		 && document.LOOKUP.UNITID.selectedIndex == "0"      && document.LOOKUP.SERVICEREQUESTNUMBER.value == '') {
			alertuser ("One of the FOUR Lookup fields MUST be selected!");
			document.LOOKUP.REQUESTERID.focus();
			return false;
		}
		
		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length > 0 && document.LOOKUP.SERVICEREQUESTNUMBER.value.length < 9) {
			alertuser (document.LOOKUP.SERVICEREQUESTNUMBER.name +  ",  If you include an Service Request Number, it MUST be 9 characters in the format 2 digit fiscal year begin/end and 4 digit sequence number: yy/yy9999.");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
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


<CFSET CURSORFIELD = "document.LOOKUP.REQUESTERID.focus()">

<BODY onLoad="#CURSORFIELD#">

<!--- 
******************************************************************************************************************************
* The following code is the Look Up Process for Service Request - Customer Network/Voice Work Order Report Record Selection. *
******************************************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPCUST')>


	<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
          SELECT	CUST.CUSTOMERID,CUST.EMAIL, CUST.FAX, CUST.FULLNAME, CUST.UNITID, U.GROUPID, CUST.ACTIVE
          FROM		CUSTOMERS CUST, UNITS U
          WHERE	(CUST.CUSTOMERID = 0 OR
                    CUST.ACTIVE = 'YES') AND	
                    (CUST.UNITID = U.UNITID)	
          ORDER BY	CUST.FULLNAME
     </CFQUERY>
          
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
          <CFIF URL.PROCESS EQ "NETWORK">
			<TH align="center"><H1>Customer Network Work Order Report Selection Lookup</H1></TH>
          <CFELSE>
          	<TH align="center"><H1>Customer Voice Work Order Report Selection Lookup</H1></TH>
          </CFIF>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>
                    	Select from either the Requester or type in an SR Number to choose report criteria.<BR />
					Optional dates and/or the Completion Flag drop down box refine selections.
				</H2>
               </TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/custnetworkvoiceworeport.cfm?LOOKUPCUST=FOUND&PROCESS=#URL.PROCESS#" method="POST">
		<TR>
			<TH align="left"><LABEL for="REQUESTERID">Requester</LABEL></TH>
               <TH align="left">&nbsp;&nbsp;</TH>
          </TR>
          <TR>
			<TD align="LEFT">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="2"></CFSELECT>
			</TD>
               <TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left"><LABEL for="SERVICEREQUESTNUMBER">Or SR ##</LABEL></TH>
               <TH align="left"><LABEL for="SRCOMPLETED">SR Completed?</LABEL></TH>
		</TR>
           <TR>
			<TD align="left">
               	<CFINPUT type="Text" name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3">
               </TD>
               <TD align="left">
				<CFSELECT name="SRCOMPLETED" id="SRCOMPLETED" size="1" tabindex="4">
                    	<OPTION value="Select Status">Select Status</OPTION>
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
				<CFINPUT type="TEXT" name="BEGINDATE" id="BEGINDATE" value="" required="No" size="15" maxlength="25" tabindex="5">
                    <SCRIPT language="JavaScript">
					new tcal ({'formname': 'LOOKUP','controlname': 'BEGINDATE'});

				</SCRIPT><BR />
                    <COM>(Date Format: MM/DD/YYYY)</COM>
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="ENDDATE" id="ENDDATE" value="" required="No" size="15" maxlength="25" tabindex="6">
                    <SCRIPT language="JavaScript">
					new tcal ({'formname': 'LOOKUP','controlname': 'ENDDATE'});

				</SCRIPT><BR />
                    <COM>(Date Format: MM/DD/YYYY)</COM>
			</TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="2">
               	<COM> 
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         (Both a Begin Date and End Date MUST be entered when selecting records in a date range.)
                    </COM>
               </TD>
		</TR>
		<TR>
			<TD colspan="2"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TD align="LEFT">
				<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="7" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="8" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
     
     <CFEXIT>

<CFELSE>

<!--- 
************************************************************************************************************
* The following code is the Service Request - Customer Network/Voice Work Order Report Generation Process. *
************************************************************************************************************
 --->

	<CFSET DATERANGEREPORT = "NO">
	<CFIF IsDefined('FORM.BEGINDATE') AND #FORM.BEGINDATE# NEQ "">
		<CFSET DATERANGEREPORT = "YES">
		<CFSET BEGINDATE = #DateFormat(FORM.BEGINDATE, "dd/mmm/yyyy")#>
		<CFSET ENDDATE = #DateFormat(FORM.ENDDATE, "dd/mmm/yyyy")#>
	</CFIF>
	

	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE, SR.REQUESTERID, REQCUST.CUSTOMERID, 
          		REQCUST.FULLNAME AS REQNAME, SR.SRCOMPLETED, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.WO_NUMBER, TNSWO.WO_DUEDATE,
                    TNSWO.STAFFID, TNSWO.WORK_DESCRIPTION
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, TNSWORKORDERS TNSWO
		WHERE	SR.REQUESTERID = REQCUST.CUSTOMERID AND
				SR.SRID = TNSWO.SRID AND
			<CFIF URL.PROCESS EQ "NETWORK">
                    NOT TNSWO.WO_TYPE LIKE ('%PHONE%') AND
               <CFELSE>
                    TNSWO.WO_TYPE LIKE ('%PHONE%') AND
               </CFIF>
          	<CFIF IsDefined('FORM.REQUESTERID') AND #FORM.REQUESTERID# GT 0>
				SR.REQUESTERID = #FORM.REQUESTERID# AND
			</CFIF>
               <CFIF IsDefined('FORM.SERVICEREQUESTNUMBER') AND #FORM.SERVICEREQUESTNUMBER# NEQ ''>
				SR.SERVICEREQUESTNUMBER = '#FORM.SERVICEREQUESTNUMBER#' AND
			</CFIF>
               <CFIF #FORM.SRCOMPLETED# NEQ "Select Status">
				SR.SRCOMPLETED = '#FORM.SRCOMPLETED#' AND
			</CFIF>
			<CFIF #DATERANGEREPORT# EQ "YES">
				SR.CREATIONDATE BETWEEN TO_DATE('#BEGINDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATE#', 'DD-MON-YYYY') AND
			</CFIF>
               	SR.SRID > 0
				
		ORDER BY	SR.SERVICEREQUESTNUMBER DESC
	</CFQUERY>

	<CFIF #LookupServiceRequests.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records meeting your selection criteria were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/custnetworkvoiceworeport.cfm?PROCESS=#URL.PROCESS#" />
			<CFEXIT>
	</CFIF>
     

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
          	<TH align="center">
			<CFIF URL.PROCESS EQ "NETWORK">
                    <H1>Customer Network Work Order Report</H1>
               <CFELSE>
                    <H1>Customer Voice Work Order Report</H1>
               </CFIF>
                    <H4>TNS Contact Phone: &nbsp;&nbsp;&nbsp;&nbsp;4-3396</H4>
               </TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/custnetworkvoiceworeport.cfm?PROCESS=#URL.PROCESS#" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="center" valign="bottom">SR</TH>
			<TH align="center" valign="bottom">Creation <BR> Date</TH>
			<TH align="center" valign="bottom">Requester</TH>
			<TH align="center" valign="bottom">WO <BR> Type</TH>
			<TH align="center" valign="bottom">WO <BR> Status</TH>
			<TH align="center" valign="bottom">WO <BR> Number</TH>
			<TH align="center" valign="bottom">WO <BR> Due Date</TH>
			<TH align="center" valign="bottom">Staff <BR> Assigned</TH>
		</TR>
          
	<CFLOOP query="LookupServiceRequests">
     
		<CFQUERY name="LookupStaffAssigned" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SRSA.STAFF_ASSIGNEDID, WGA.STAFFCUSTOMERID, CUST.FULLNAME
			FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#LookupServiceRequests.STAFFID#" cfsqltype="CF_SQL_NUMBER"> AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
					WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
			ORDER BY	CUST.FULLNAME
		</CFQUERY>
	
		<TR>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.SERVICEREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(LookupServiceRequests.CREATIONDATE, "mm/dd/yyyy")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.REQNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.WO_TYPE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.WO_STATUS#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.WO_NUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(LookupServiceRequests.WO_DUEDATE, "mm/dd/yyyy")#</DIV></TD>        	
			<TD align="center" valign="TOP"><DIV>#LookupStaffAssigned.FULLNAME#</DIV></TD>
		</TR>
		<TR>
			<TD align="left" >&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="LEFT" valign="TOP">Work Description:</TH>
			<TD align="LEFT" valign="TOP" colspan="8">
               	<DIV>&nbsp;&nbsp;#LookupServiceRequests.WORK_DESCRIPTION#</DIV>
               </TD>
		</TR>
          <TR>
			<TD align="left" valign="TOP" colspan="8"><HR></TD>
		</TR>
 </CFLOOP>
		<TR>
			<TH align="CENTER" colspan="8">
               <CFIF URL.PROCESS EQ "NETWORK">
               	<H2>#LookupServiceRequests.RecordCount# Customer Network Work Order records were selected.</H2>
               <CFELSE>
               	<H2>#LookupServiceRequests.RecordCount# Customer Voice Work Order records were selected.</H2>
               </CFIF>
               </TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/custnetworkvoiceworeport.cfm?PROCESS=#URL.PROCESS#" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="8">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</HTML></CFOUTPUT>
