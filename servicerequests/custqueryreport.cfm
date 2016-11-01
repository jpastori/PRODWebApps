<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custqueryreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/08/2012 --->
<!--- Date in Production: 08/08/2012 --->
<!--- Module: Service Request - Customer Query Report --->
<!-- Last modified by John R. Pastori on 02/13/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/custqueryreport.cfm">
<CFSET CONTENT_UPDATED = "February 13, 2015">

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
	<TITLE>Service Request - Customer Query Report</TITLE>
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

<CFOUTPUT>

<CFSET CURSORFIELD = "document.LOOKUP.REQUESTERID.focus()">

<BODY onLoad="#CURSORFIELD#">

<!--- 
****************************************************************************************************
* The following code is the Look Up Process for Service Request - Customer Query Record Selection. *
****************************************************************************************************
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
     
     <CFQUERY name="ListUnitLiaisons" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
          SELECT	UL.UNITLIAISONID, UL.UNITID, U.UNITID, U.UNITNAME, UL.ALTERNATE_CONTACTID, CUST.CUSTOMERID, CUST.FULLNAME,
                    U.UNITNAME || ' - ' || CUST.FULLNAME AS KEYFINDER
          FROM		UNITLIAISON UL, LIBSHAREDDATAMGR.UNITS U, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	UL.UNITID = U.UNITID AND
                    UL.ALTERNATE_CONTACTID = CUST.CUSTOMERID
          ORDER BY	U.UNITNAME, CUST.FULLNAME
     </CFQUERY>

	<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
		SELECT	U.UNITID, U.UNITNAME, G.GROUPNAME
		FROM		UNITS U, GROUPS G
		WHERE	(U.UNITID = 0 OR
          		U.ACTIVEUNIT = 'YES') AND
          		(U.GROUPID = G.GROUPID)
		ORDER BY	U.UNITNAME
	</CFQUERY>
     
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Service Request - Customer Query Selection Lookup</H1></TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>
                    	Select from either the Requester or Unit drop down boxes or type in an SR Number to choose report criteria.<BR />
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/custqueryreport.cfm?LOOKUPCUST=FOUND" method="POST">
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
               <TH align="left" valign="BOTTOM">
               	<LABEL for="ALTERNATE_CONTACTID">Or Unit Liaison</LABEL>
               </TH>
               <TH align="left"><LABEL for="UNITID">Or Unit</LABEL></TH>
		</TR>
          <TR>
               <TD align="left">
                    <CFSELECT name="ALTERNATE_CONTACTID" id="ALTERNATE_CONTACTID" size="1" query="ListUnitLiaisons" value="ALTERNATE_CONTACTID" display="KEYFINDER" required="No" tabindex="3"></CFSELECT>
               </TD>
			<TD align="left" valign="top">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="0" required="No" tabindex="4"></CFSELECT>
			</TD>
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
               	<CFINPUT type="Text" name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="5">
               </TD>
               <TD align="left">
				<CFSELECT name="SRCOMPLETED" id="SRCOMPLETED" size="1" tabindex="6">
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
				<CFINPUT type="TEXT" name="BEGINDATE" id="BEGINDATE" value="" required="No" size="15" maxlength="25" tabindex="7">
                    <SCRIPT language="JavaScript">
					new tcal ({'formname': 'LOOKUP','controlname': 'BEGINDATE'});

				</SCRIPT><BR />
                    <COM>(Date Format: MM/DD/YYYY)</COM>
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="ENDDATE" id="ENDDATE" value="" required="No" size="15" maxlength="25" tabindex="8">
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
				<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="9" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="10" /><BR>
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
*****************************************************************************************
* The following code is the Service Request - Customer Query Report Generation Process. *
*****************************************************************************************
 --->

	<CFSET DATERANGEREPORT = "NO">
	<CFIF IsDefined('FORM.BEGINDATE') AND #FORM.BEGINDATE# NEQ "">
		<CFSET DATERANGEREPORT = "YES">
		<CFSET BEGINDATE = #DateFormat(FORM.BEGINDATE, "dd/mmm/yyyy")#>
		<CFSET ENDDATE = #DateFormat(FORM.ENDDATE, "dd/mmm/yyyy")#>
	</CFIF>
	

	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE, 
				TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SDINIT.FULLNAME, SR.REQUESTERID, REQCUST.FULLNAME AS REQNAME, REQCUST.UNITID, 
                    SR.ALTERNATE_CONTACTID, ALTCUST.FULLNAME AS ALTCONTNAME, SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID, IDTGROUP.GROUPNAME,
                    SR.PROBLEM_DESCRIPTION, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, PRIORITY, GROUPASSIGNED IDTGROUP, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, 
          		LIBSHAREDDATAMGR.CUSTOMERS ALTCUST
		WHERE	SR.SRID > 0 AND
          	<CFIF IsDefined('FORM.REQUESTERID') AND #FORM.REQUESTERID# GT 0>
				SR.REQUESTERID = #FORM.REQUESTERID# AND
			</CFIF>
               <CFIF IsDefined('FORM.ALTERNATE_CONTACTID') AND #FORM.ALTERNATE_CONTACTID# GT 0>
				SR.ALTERNATE_CONTACTID = #FORM.ALTERNATE_CONTACTID# AND
			</CFIF>
               	SR.ALTERNATE_CONTACTID = ALTCUST.CUSTOMERID AND
               <CFIF IsDefined('FORM.UNITID') AND #FORM.UNITID# GT 0>
				REQCUST.UNITID = #FORM.UNITID# AND
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
				SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
				SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
				SR.REQUESTERID = REQCUST.CUSTOMERID AND
				SR.PRIORITYID = PRIORITY.PRIORITYID
		ORDER BY	SR.SERVICEREQUESTNUMBER DESC
	</CFQUERY>

	<CFIF #LookupServiceRequests.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records meeting your selection criteria were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/custqueryreport.cfm" />
			<CFEXIT>
	</CFIF>
     
     <CFQUERY name="LookupUnitTitleName" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
		SELECT	U.UNITID, U.UNITNAME
		FROM		UNITS U
		WHERE	U.UNITID = <CFQUERYPARAM value="#LookupServiceRequests.UNITID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	U.UNITNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
               	<H1>Service Request - Customer Query Report</H1>
               <CFIF IsDefined('FORM.REQUESTERID') AND #FORM.REQUESTERID# GT 0>
				<H2>For Requester: &nbsp;&nbsp;#LookupServiceRequests.REQNAME#</H2>
			</CFIF>
               <CFIF IsDefined('FORM.ALTERNATE_CONTACTID') AND #FORM.ALTERNATE_CONTACTID# GT 0>
				<H2>Unit Liaison: &nbsp;&nbsp;#LookupServiceRequests.ALTCONTNAME#</H2>
			</CFIF>
               <CFIF IsDefined('FORM.UNITID') AND #FORM.UNITID# GT 0>
				<H2>For Unit: &nbsp;&nbsp;#LookupUnitTitleName.UNITNAME#</H2>
			</CFIF>
               <CFIF IsDefined('FORM.SERVICEREQUESTNUMBER') AND #FORM.SERVICEREQUESTNUMBER# NEQ ''>
				<H2>For SR ##: &nbsp;&nbsp;#LookupServiceRequests.SERVICEREQUESTNUMBER#</H2>
			</CFIF>
               <CFIF IsDefined('FORM.BEGINDATE') AND #FORM.BEGINDATE# NEQ "">
               	<BR><H2>Creation Begin Date = #DateFormat(FORM.BEGINDATE, "mm/dd/yyyy")# and End Date = #DateFormat(FORM.ENDDATE, "mm/dd/yyyy")#</H2>
               </CFIF>
               </TD>
               
		</TR>
	</TABLE>
<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/custqueryreport.cfm" method="POST">
			<TD align="left"><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR></TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="9"><H2>#LookupServiceRequests.RecordCount# Service Request records were selected.</H2></TH>
		</TR>
		<TR>
          
		<CFIF IsDefined('FORM.REQUESTERID') AND #FORM.REQUESTERID# EQ 0>
			<TH align="center" valign="BOTTOM">Requester</TH>
          </CFIF>
          <CFIF IsDefined('FORM.REQUESTERID') AND #FORM.UNITID# EQ 0>
          	<TH align="center" valign="BOTTOM">Unit</TH>
          </CFIF>
          <CFIF IsDefined('FORM.ALTERNATE_CONTACTID') AND #FORM.ALTERNATE_CONTACTID# EQ 0>
          	<TH align="left" valign="BOTTOM">Unit Liaison</TH>
          </CFIF>
			<TH align="center" valign="BOTTOM">SR</TH>
			<TH align="center" valign="BOTTOM">Creation Date</TH>
			<TH align="center" valign="BOTTOM">Priority</TH>
			<TH align="center" valign="BOTTOM">BarCode Number</TH>
			<TH align="center" valign="BOTTOM">Primary Group Assigned</TH>
			<TH align="center" valign="BOTTOM">Completed SR?</TH>
			<TH align="center" valign="BOTTOM">SR Completed Date</TH>
		</TR>
	<CFLOOP query="LookupServiceRequests">
	
		<CFQUERY name="LookupSREquipBarcode" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
				SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
				FROM		SREQUIPLOOKUP
				WHERE	SERVICEREQUESTNUMBER = '#LookupServiceRequests.SERVICEREQUESTNUMBER#'
		</CFQUERY>
	
		<TR>
          <CFIF IsDefined('FORM.REQUESTERID') AND #FORM.REQUESTERID# EQ 0>	
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.REQNAME#</DIV></TD>
          </CFIF>
          <CFIF IsDefined('FORM.REQUESTERID') AND #FORM.UNITID# EQ 0>
			<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
                    SELECT	U.UNITID, U.UNITNAME
                    FROM		UNITS U
                    WHERE	U.UNITID = <CFQUERYPARAM value="#LookupServiceRequests.UNITID#" cfsqltype="CF_SQL_NUMERIC">
                    ORDER BY	U.UNITNAME
               </CFQUERY>

          	<TD align="center" valign="TOP"><DIV>#LookupUnits.UNITNAME#</DIV></TD>
          </CFIF>
          <CFIF IsDefined('FORM.ALTERNATE_CONTACTID') AND #FORM.ALTERNATE_CONTACTID# EQ 0>
          	<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.ALTCONTNAME#</DIV></TD>
          </CFIF>
			<TD align="center" valign="TOP"><H3>#LookupServiceRequests.SERVICEREQUESTNUMBER#</H3></TD>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.CREATIONDATE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.PRIORITYNAME#</DIV></TD>
		<CFIF LookupSREquipBarcode.RecordCount GT 0>
			<TD align="center" valign="TOP"><DIV>#LookupSREquipBarcode.EQUIPMENTBARCODE#</DIV></TD>
		<CFELSE>
			<TD align="center" valign="TOP"><DIV>&nbsp;&nbsp;</DIV></TD>
		</CFIF>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.GROUPNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.SRCOMPLETED#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(LookupServiceRequests.SRCOMPLETEDDATE, "mm/dd/yyyy")#</DIV></TD>
		</TR>
          <TR>
			<TH align="center" valign="TOP">Problem Description:</TH>
			<TD align="left" valign="TOP" colspan="7"><DIV>#LookupServiceRequests.PROBLEM_DESCRIPTION#</DIV></TD>
		</TR>	
		<TR>
			<TD align="left" valign="TOP" colspan="9"><HR></TD>
		</TR>
	</CFLOOP>
	
		<TR>
			<TH align="CENTER" colspan="9"><H2>#LookupServiceRequests.RecordCount# Service Request records were selected.</H2></TH>
		</TR>
	
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/custqueryreport.cfm" method="POST">
			<TD align="left"><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /></TD>
	</CFFORM>
	</TR>
		<TR>
			<TD align="left" colspan="9">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>