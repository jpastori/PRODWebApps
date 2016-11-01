<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: tnsworkordersdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/05/2013 --->
<!--- Date in Production: 03/05/2013 --->
<!--- Module: Service Requests - TNS Work Orders Report --->
<!-- Last modified by John R. Pastori on 05/22/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/tnsworkordersdbreport.cfm">
<CFSET CONTENT_UPDATED = "May 22, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Service Requests - TNS Work Orders Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Service Requests - TNS Work Orders Report";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}
	
	function validateLookupFields() {
		if (document.LOOKUP.REPORTCHOICE[1].checked > "0" && document.LOOKUP.WO_STATUS.selectedIndex == "0") {
			alertuser ("You MUST select a Work Order Status value from the Drop Down!");
			document.LOOKUP.WO_STATUS.focus();
			return false;
		}
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET CURSORFIELD = "document.LOOKUP.REPORTCHOICE[0].focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
***********************************************************************************************
* The following code is the Lookup Process for IDT Service Requests - TNS Work Orders Report. *
***********************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>

	<CFQUERY name="LookupSRFiscalYear" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	DISTINCT SR.FISCALYEARID, FY.FISCALYEAR_4DIGIT
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	SR.FISCALYEARID = FY.FISCALYEARID 
		ORDER BY	FY.FISCALYEAR_4DIGIT
	</CFQUERY>
     
     <CFQUERY name="LookupCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	CURRENTFISCALYEAR = 'YES'
          ORDER BY	FISCALYEARID
     </CFQUERY>

	<CFQUERY name="ListTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SRID, TNSWO_ID
		FROM		TNSWORKORDERS
		WHERE	TNSWO_ID > 0 AND
          		NOT WO_TYPE LIKE ('%PHONE%')
		ORDER BY	SRID
	</CFQUERY>

	<CFIF ListTNSWorkOrders.RecordCount EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert ("There are NO TNS Work Orders on file.");
			-->
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
		<CFEXIT>
	</CFIF>

	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, CUST.FULLNAME, 
          		TNSWO.SRID, TNSWO.HW_INVENTORYID, HI.BARCODENUMBER, CUST.FULLNAME || ' - ' || SR.SERVICEREQUESTNUMBER || ' - ' || HI.BARCODENUMBER AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST, TNSWORKORDERS TNSWO, HARDWMGR.HARDWAREINVENTORY HI
		WHERE	(SR.SRID = 0 OR
          		SR.SRID IN (#ValueList(ListTNSWorkOrders.SRID)#)) AND
				(SR.REQUESTERID = CUST.CUSTOMERID AND
				SR.SRID = TNSWO.SRID AND
				TNSWO.HW_INVENTORYID = HI.HARDWAREID) AND
                    (SR.SRCOMPLETED = 'NO' OR
                     SR.SRCOMPLETED = 'YES' OR
                     SR.SRCOMPLETED = ' Completed?')
		ORDER BY	LOOKUPKEY
	</CFQUERY>


	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Lookup - TNS Work Orders Report</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
	<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
           <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/tnsworkordersdbreport.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>SELECT ONE OF THE SEVEN (7) REPORTS BELOW</COM></TD>
		</TR>
          <TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="2" />
               </TD>
		</TR>
          <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="3">
			</TD>
               <TH align="left" valign="TOP" nowrap>
               	<LABEL for="REPORTCHOICE1">REPORT 1: &nbsp;&nbsp;All TNS WO SRs</LABEL>
                    <LABEL for="FISCALYEARID1">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="FISCALYEARID1" id="FISCALYEARID1" size="1" query="LookupSRFiscalYear" value="FISCALYEARID" selected="#LookupCurrentFiscalYear.FISCALYEARID#" display="FISCALYEAR_4DIGIT" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="5">
			</TD>
               <TH align="left" valign="TOP" nowrap>
               	<LABEL for="REPORTCHOICE2">REPORT 2: &nbsp;&nbsp;All TNS WO SRs</LABEL>
                    <LABEL for="WO_STATUS">by Specific TNS WO Status</LABEL>
                    <LABEL for="FISCALYEARID2">for a Specific Fiscal Year</LABEL>
               </TH>
               <TD align="left" valign="TOP">
                         <CFSELECT name="WO_STATUS" id="WO_STATUS" size="1" tabindex="6">
                         	<OPTION value="0">Select a TNS WO Status</OPTION>
                              <OPTION value="PENDING">PENDING</OPTION>
                              <OPTION value="COMPLETE">COMPLETE</OPTION>
                         </CFSELECT>
                    </TD>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="FISCALYEARID2" id="FISCALYEARID2" size="1" query="LookupSRFiscalYear" value="FISCALYEARID" selected="#LookupCurrentFiscalYear.FISCALYEARID#" display="FISCALYEAR_4DIGIT" required="No" tabindex="7"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="8">
			</TD>
			<TH align="left" valign="TOP" nowrap><LABEL for="REPORTCHOICE3">REPORT 3:</LABEL> &nbsp;&nbsp;<LABEL for="SRID">Specific TNS WO SR</LABEL></TH>
			<TD align="LEFT" valign="TOP" colspan="2">
				<CFSELECT name="SRID" id="SRID" size="1" query="LookupServiceRequests" value="SRID" selected ="0" display="LOOKUPKEY" required="No" tabindex="9"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="10">
			</TD>
			<TH align="left" valign="TOP" nowrap><LABEL for="REPORTCHOICE4">REPORT 4:</LABEL> &nbsp;&nbsp;<LABEL for="WO_NUMBER">Specific TNS WO</LABEL></TH>
			<TD align="LEFT" valign="TOP" colspan="2">
				<CFINPUT type="TEXT" name="WO_NUMBER" id="WO_NUMBER" value="" required="No" size="15" maxlength="10" tabindex="11"><BR />
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
          	<TD colspan="2">&nbsp;&nbsp;</TD>
               <TH align="left" valign="BOTTOM"><LABEL for="BEGINDATE">Begin SR Creation Date</LABEL></TH>
               <TH align="left" valign="BOTTOM" nowrap><LABEL for="ENDDATE">End SR Creation Date</LABEL></TH>
          </TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="12">
			</TD>
			<TH align="left" valign="TOP" nowrap><LABEL for="REPORTCHOICE5">REPORT 5: &nbsp;&nbsp;TNS WO SRs By SR Creation Date Range</LABEL></TH>
			<TD align="LEFT" valign="TOP">
                    <CFINPUT type="TEXT" name="BEGINDATE" id="BEGINDATE" value="" required="No" size="15" maxlength="25" tabindex="13">
                    <SCRIPT language="JavaScript">
                         new tcal ({'formname': 'LOOKUP','controlname': 'BEGINDATE'});

                    </SCRIPT><BR>
                    <COM>&nbsp;MM/DD/YYYY</COM>
               </TD>
               <TD align="LEFT" valign="TOP" nowrap>
                    <CFINPUT type="TEXT" name="ENDDATE" id="ENDDATE" value="" required="No" size="15" maxlength="25" tabindex="14">
                    <SCRIPT language="JavaScript">
                         new tcal ({'formname': 'LOOKUP','controlname': 'ENDDATE'});

                    </SCRIPT><BR />
                    <COM>&nbsp;MM/DD/YYYY</COM><BR />
               </TD>
		</TR>
          <TR>
          	<TD colspan="2">&nbsp;&nbsp;</TD>
			<TD align="LEFT" colspan="2">
               	<COM> 
                    	(Both a Begin Date and End Date MUST be entered when selecting records in a date range.)
                    </COM>
               </TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE6" value="6" align="LEFT" required="No" tabindex="15">
			</TD>
			<TH align="left" valign="TOP" nowrap><LABEL for="REPORTCHOICE6">REPORT 6:</LABEL> &nbsp;&nbsp;<LABEL for="WO_TYPE">Specific TNS WO Type</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="WO_TYPE" id="WO_TYPE" size="1" tabindex="16">
					<OPTION value="TNS TYPE">TNS TYPE</OPTION>
					<OPTION value="NEW">NEW</OPTION>
					<OPTION value="MOVE">MOVE</OPTION>
					<OPTION value="REPORT">REPORT</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE7" value="7" align="LEFT" required="No" tabindex="17">
			</TD>
			<TH align="left" valign="TOP" nowrap><LABEL for="REPORTCHOICE7">REPORT 7: &nbsp;&nbsp;Range Of TNS WO Types</LABEL></TH>
			<TD align="LEFT" valign="TOP" colspan="2">
				<CFINPUT type="TEXT" name="WO_TYPESRANGE" id="WO_TYPESRANGE" value="" required="No" size="40" maxlength="50" tabindex="18"><BR />
				<LABEL for="WO_TYPESRANGE">
                    	<COM>
                         	Enter a series of WO Types separated by commas,NO spaces.<BR> 
                    		Allowed values are TNS TYPE,NEW,MOVE,REPORT.
                         </COM>
                    </LABEL>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>SELECT ONE OF THE SORT SEQUENCES BELOW</COM></TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE1" checked value="1" align="LEFT" required="No" tabindex="19">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="SORTCHOICE1">Select Sort SR Number</LABEL></TH>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="SORTCHOICE" id="SORTCHOICE2" value="2" align="LEFT" required="No" tabindex="20">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="SORTCHOICE2">Full User Name and SR Number</LABEL></TH>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
           <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="21" />
               </TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="22" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
************************************************************************
* The following code is the TNS Work Orders Report Generation Process. *
************************************************************************
 --->

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'SR.SERVICEREQUESTNUMBER DESC'>
	<CFSET SORTORDER[2] = 'CUST.FULLNAME, SR.SERVICEREQUESTNUMBER DESC'>
	<CFSET USERHEADER = ''>
	<CFSET RECORDCOUNT = 0>
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.SORTCHOICE#]")>
	<!--- REPORT ORDER = #REPORTORDER#<BR><BR>
	REPORT CHOICE = #FORM.REPORTCHOICE#<BR><BR> --->
	<CFIF #FORM.SORTCHOICE# EQ 1>
		<CFSET REPORTORDER = SORTORDER[1]>
          <!--- SORTCHOICE 1 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
	<CFELSEIF #FORM.SORTCHOICE# EQ 2>
		<CFSET REPORTORDER = SORTORDER[2]>
          <!--- SORTCHOICE 2 REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 1>
    
		<CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
			SELECT	TNSWO.TNSWO_ID, TNSWO.SRID
			FROM		TNSWORKORDERS TNSWO, FACILITIESMGR.WALLJACKS CURRWJ, FACILITIESMGR.WALLJACKS NEWWJ
			WHERE	TNSWO.TNSWO_ID > 0 AND
               		TNSWO.CURRENT_JACKNUMBER = CURRWJ.WALLJACKID AND
					TNSWO.NEW_JACKNUMBER = NEWWJ.WALLJACKID AND
          			NOT TNSWO.WO_TYPE LIKE ('%PHONE%')
			ORDER BY	TNSWO.WO_TYPE
		</CFQUERY>
 
		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME, SR.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME
			FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#) AND
                    	SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID1#" cfsqltype="CF_SQL_NUMERIC"> AND
					SR.REQUESTERID = CUST.CUSTOMERID) AND
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = 'YES' OR
                          SR.SRCOMPLETED = ' Completed?')
			ORDER BY	#REPORTORDER#
		</CFQUERY>

		<CFSET QUERYNAME = "LookupServiceRequests">
          <CFSET REPORTSUBTITLE = "">
	</CFIF>
     
     <CFIF #FORM.REPORTCHOICE# EQ 2>
    
		<CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
			SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_STATUS
			FROM		TNSWORKORDERS TNSWO, FACILITIESMGR.WALLJACKS CURRWJ, FACILITIESMGR.WALLJACKS NEWWJ
			WHERE	TNSWO.TNSWO_ID > 0 AND
               		TNSWO.WO_STATUS = <CFQUERYPARAM value="#FORM.WO_STATUS#" cfsqltype="CF_SQL_VARCHAR"> AND
               		TNSWO.CURRENT_JACKNUMBER = CURRWJ.WALLJACKID AND
					TNSWO.NEW_JACKNUMBER = NEWWJ.WALLJACKID AND
          			NOT TNSWO.WO_TYPE LIKE ('%PHONE%')
			ORDER BY	TNSWO.WO_STATUS
		</CFQUERY>
          
          <CFIF LookupTNSWorkOrders.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("The selected WO Status has no records.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/tnsworkordersdbreport.cfm" />
			<CFEXIT>
		</CFIF>
 
		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME, SR.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME
			FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	((SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#) AND
                    	SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID2#" cfsqltype="CF_SQL_NUMBER"> AND
					SR.REQUESTERID = CUST.CUSTOMERID) AND
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = 'YES' OR
                          SR.SRCOMPLETED = ' Completed?'))
			ORDER BY	#REPORTORDER#
		</CFQUERY>

		<CFSET QUERYNAME = "LookupServiceRequests">
          <CFSET REPORTSUBTITLE = "by Specific TNS WO Status for a Specific Fiscal Year">
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME, TNSWO.SRID, TNSWO.STAFFID,
					SRSA.STAFF_ASSIGNEDID, WGA.STAFFCUSTOMERID, CUST.FULLNAME
			FROM		SERVICEREQUESTS SR, TNSWORKORDERS TNSWO, SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SR.SRID = TNSWO.SRID AND
                         TNSWO.SRID = SRSA.SRID AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
					SR.REQUESTERID = CUST.CUSTOMERID) AND
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = 'YES' OR
                          SR.SRCOMPLETED = ' Completed?')
			ORDER BY	#REPORTORDER#
		</CFQUERY>
          
          <CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
			SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.STAFFID, TNSWO.CURRENT_JACKNUMBER, CURRWJ.JACKNUMBER,
                         CURRWJ.CLOSET || ' - ' || CURRWJ.JACKNUMBER || ' - ' || CURRWJ.PORTLETTER AS CURRENTJACK, TNSWO.NEW_JACKNUMBER, NEWWJ.JACKNUMBER,
                         NEWWJ.CLOSET || ' - ' || NEWWJ.JACKNUMBER || ' - ' || NEWWJ.PORTLETTER AS NEWJACK, TNSWO.HW_INVENTORYID, TNSWO.WORK_DESCRIPTION,
                         TNSWO.JUSTIFICATION_DESCRIPTION, TNSWO.OTHER_DESCRIPTION, TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER, TNSWO.EBA_111, TNSWO.NEW_LOCATION
			FROM		TNSWORKORDERS TNSWO, FACILITIESMGR.WALLJACKS CURRWJ, FACILITIESMGR.WALLJACKS NEWWJ
			WHERE	TNSWO.SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
               		TNSWO.CURRENT_JACKNUMBER = CURRWJ.WALLJACKID AND
					TNSWO.NEW_JACKNUMBER = NEWWJ.WALLJACKID AND
          			NOT TNSWO.WO_TYPE LIKE ('%PHONE%')
			ORDER BY	TNSWO.WO_TYPE
		</CFQUERY>
          
          <CFSET QUERYNAME = "LookupTNSWorkOrders">
          <CFSET REPORTSUBTITLE = "By SR Number">
	</CFIF>
     
     <CFIF #FORM.REPORTCHOICE# EQ 4>

          <CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
			SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.STAFFID, TNSWO.CURRENT_JACKNUMBER, CURRWJ.JACKNUMBER,
                         CURRWJ.CLOSET || ' - ' || CURRWJ.JACKNUMBER || ' - ' || CURRWJ.PORTLETTER AS CURRENTJACK, TNSWO.NEW_JACKNUMBER, NEWWJ.JACKNUMBER,
                         NEWWJ.CLOSET || ' - ' || NEWWJ.JACKNUMBER || ' - ' || NEWWJ.PORTLETTER AS NEWJACK, TNSWO.HW_INVENTORYID, TNSWO.WORK_DESCRIPTION,
                         TNSWO.JUSTIFICATION_DESCRIPTION, TNSWO.OTHER_DESCRIPTION, TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER, TNSWO.EBA_111, TNSWO.NEW_LOCATION
			FROM		TNSWORKORDERS TNSWO, FACILITIESMGR.WALLJACKS CURRWJ, FACILITIESMGR.WALLJACKS NEWWJ
			WHERE	TNSWO.WO_NUMBER = <CFQUERYPARAM value="#FORM.WO_NUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
               		TNSWO.CURRENT_JACKNUMBER = CURRWJ.WALLJACKID AND
					TNSWO.NEW_JACKNUMBER = NEWWJ.WALLJACKID AND
          			NOT TNSWO.WO_TYPE LIKE ('%PHONE%')
			ORDER BY	TNSWO.WO_TYPE
		</CFQUERY>
          
           <CFIF LookupTNSWorkOrders.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("The entered WO Number does NOT exist.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/tnsworkordersdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME, SRSA.STAFF_ASSIGNEDID, WGA.STAFFCUSTOMERID, CUST.FULLNAME
			FROM		SERVICEREQUESTS SR, SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#) AND
               		SR.SRID = SRSA.SRID AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
					SR.REQUESTERID = CUST.CUSTOMERID) AND
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = 'YES' OR
                          SR.SRCOMPLETED = ' Completed?')
			ORDER BY	#REPORTORDER#
		</CFQUERY>
          
         <CFSET QUERYNAME = "LookupServiceRequests">
          <CFSET REPORTSUBTITLE = "By WO Number">
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 5>
		<CFSET DATERANGEREPORT = "YES">
		<CFSET BEGINDATE = #DateFormat(FORM.BEGINDATE, "dd/mmm/yyyy")#>
		<CFSET ENDDATE = #DateFormat(FORM.ENDDATE, "dd/mmm/yyyy")#>
		BEGIN DATE = #BEGINDATE# &nbsp;&nbsp;&nbsp;&nbsp;END DATE = #ENDDATE#<BR /><BR />

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME, TNSWO.SRID, TNSWO.STAFFID, CUST.FULLNAME
			FROM		SERVICEREQUESTS SR, TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SR.SRID = TNSWO.SRID AND
               		SR.CREATIONDATE BETWEEN TO_DATE('#BEGINDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATE#', 'DD-MON-YYYY') AND
					SR.REQUESTERID = CUST.CUSTOMERID) AND
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = 'YES' OR
                          SR.SRCOMPLETED = ' Completed?')
			ORDER BY	#REPORTORDER#
		</CFQUERY>
          
		<CFIF LookupServiceRequests.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("The entered SRs are NOT Associated with a TNS Work Order.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/tnsworkordersdbreport.cfm" />
			<CFEXIT>
		</CFIF>
          
          <CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
			SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.STAFFID, TNSWO.CURRENT_JACKNUMBER, CURRWJ.JACKNUMBER,
                         CURRWJ.CLOSET || ' - ' || CURRWJ.JACKNUMBER || ' - ' || CURRWJ.PORTLETTER AS CURRENTJACK, TNSWO.NEW_JACKNUMBER, NEWWJ.JACKNUMBER,
                         NEWWJ.CLOSET || ' - ' || NEWWJ.JACKNUMBER || ' - ' || NEWWJ.PORTLETTER AS NEWJACK, TNSWO.HW_INVENTORYID, TNSWO.WORK_DESCRIPTION,
                         TNSWO.JUSTIFICATION_DESCRIPTION, TNSWO.OTHER_DESCRIPTION, TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER, TNSWO.EBA_111, TNSWO.NEW_LOCATION
			FROM		TNSWORKORDERS TNSWO, FACILITIESMGR.WALLJACKS CURRWJ, FACILITIESMGR.WALLJACKS NEWWJ
			WHERE	TNSWO.SRID IN (#ValueList(LookupServiceRequests.SRID)#) AND
               		TNSWO.CURRENT_JACKNUMBER = CURRWJ.WALLJACKID AND
					TNSWO.NEW_JACKNUMBER = NEWWJ.WALLJACKID AND
          			NOT TNSWO.WO_TYPE LIKE ('%PHONE%')
			ORDER BY	TNSWO.WO_TYPE
		</CFQUERY>

		<CFSET QUERYNAME = "LookupTNSWorkOrders">
          <CFSET REPORTSUBTITLE = "SR Creation Date Range:  #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 6>

		<CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
			SELECT	TNSWO_ID, SRID, WO_TYPE
			FROM		TNSWORKORDERS
			WHERE	TNSWO_ID > 0 AND
					WO_TYPE = <CFQUERYPARAM value="#FORM.WO_TYPE#" cfsqltype="CF_SQL_VARCHAR"> AND
          			NOT WO_TYPE LIKE ('%PHONE%')
			ORDER BY	SRID
		</CFQUERY>
          
          <CFIF LookupTNSWorkOrders.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("The entered WO Type has no records.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/tnsworkordersdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME, TNSWO.SRID, TNSWO.STAFFID, CUST.FULLNAME
			FROM		SERVICEREQUESTS SR, TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#) AND
					SR.SRID = TNSWO.SRID AND
					SR.REQUESTERID = CUST.CUSTOMERID) AND
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = 'YES' OR
                          SR.SRCOMPLETED = ' Completed?')
			ORDER BY	#REPORTORDER#
		</CFQUERY>
          
		<CFSET QUERYNAME = "LookupServiceRequests">
          <CFSET REPORTSUBTITLE = "">
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 7>
		<CFSET FORM.WO_TYPESRANGE = UCASE(#FORM.WO_TYPESRANGE#)>
		<CFSET FORM.WO_TYPESRANGE = ListQualify(FORM.WO_TYPESRANGE,"'",",","CHAR")>
		WO TYPES RANGE FIELD = #FORM.WO_TYPESRANGE#<BR /><BR />
		<CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	TNSWO_ID, SRID, WO_TYPE
			FROM		TNSWORKORDERS
			WHERE	TNSWO_ID > 0 AND 
					WO_TYPE IN (#PreserveSingleQuotes(FORM.WO_TYPESRANGE)#) AND
          			NOT WO_TYPE LIKE ('%PHONE%')
			ORDER BY	SRID
		</CFQUERY>
		<CFIF LookupTNSWorkOrders.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("The entered WO Type has no records.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/tnsworkordersdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME, TNSWO.SRID, TNSWO.STAFFID, CUST.FULLNAME
			FROM		SERVICEREQUESTS SR, TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#) AND
					SR.SRID = TNSWO.SRID AND
					SR.REQUESTERID = CUST.CUSTOMERID) AND
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = 'YES' OR
                          SR.SRCOMPLETED = ' Completed?')
			ORDER BY	#REPORTORDER#
		</CFQUERY>

		<CFSET QUERYNAME = "LookupServiceRequests">
          <CFSET REPORTSUBTITLE = "">
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center">
				<H1>TNS Work Orders Report</H1>
                    <H2>#REPORTSUBTITLE#</H2><BR><BR>
                    <H4>TNS Contact Phone: &nbsp;&nbsp;&nbsp;&nbsp;4-3396</H4>
               </TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/tnsworkordersdbreport.cfm" method="POST">
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
			<TH align="center">Current <BR> Jack</TH>
			<TH align="center" valign="bottom">New <BR> Jack</TH>
		<CFIF #FORM.SORTCHOICE# EQ 1>
			<TH align="center" valign="bottom">Staff <BR> Assigned</TH>
		</CFIF>
		</TR>
          
	<CFLOOP query="#QUERYNAME#">
     
     	<CFIF #FORM.REPORTCHOICE# EQ 1 OR #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 6 OR #FORM.REPORTCHOICE# EQ 7>

               <CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.STAFFID, TNSWO.CURRENT_JACKNUMBER, CURRWJ.JACKNUMBER,
                              CURRWJ.CLOSET || ' - ' || CURRWJ.JACKNUMBER || ' - ' || CURRWJ.PORTLETTER AS CURRENTJACK, TNSWO.NEW_JACKNUMBER, NEWWJ.JACKNUMBER,
						NEWWJ.CLOSET || ' - ' || NEWWJ.JACKNUMBER || ' - ' || NEWWJ.PORTLETTER AS NEWJACK, TNSWO.HW_INVENTORYID, TNSWO.WORK_DESCRIPTION,
                              TNSWO.JUSTIFICATION_DESCRIPTION, TNSWO.OTHER_DESCRIPTION, TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER, TNSWO.EBA_111, TNSWO.NEW_LOCATION
                    FROM		TNSWORKORDERS TNSWO, FACILITIESMGR.WALLJACKS CURRWJ, FACILITIESMGR.WALLJACKS NEWWJ
                    WHERE	TNSWO.TNSWO_ID > 0 AND
                    		TNSWO.SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                              TNSWO.CURRENT_JACKNUMBER = CURRWJ.WALLJACKID AND
                              TNSWO.NEW_JACKNUMBER = NEWWJ.WALLJACKID AND
          				NOT TNSWO.WO_TYPE LIKE ('%PHONE%')
                    ORDER BY	TNSWO.WO_TYPE
               </CFQUERY>
               
          <CFELSE>
          	
               <CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME, TNSWO.SRID, TNSWO.STAFFID,
					SRSA.STAFF_ASSIGNEDID, WGA.STAFFCUSTOMERID, SR.REQUESTERID, CUST.FULLNAME
			FROM		SERVICEREQUESTS SR, TNSWORKORDERS TNSWO, SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SR.SRID = #LookupTNSWorkOrders.SRID# AND
					SR.SRID = TNSWO.SRID AND
					TNSWO.SRID = SRSA.SRID AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         SR.REQUESTERID = CUST.CUSTOMERID) AND
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = 'YES' OR
                          SR.SRCOMPLETED = ' Completed?')
			ORDER BY	#REPORTORDER#
		</CFQUERY>
               
          </CFIF>

		<CFSET RECORDCOUNT = RECORDCOUNT + 1>
		<CFQUERY name="LookupStaffAssigned" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SRSA.STAFF_ASSIGNEDID, WGA.STAFFCUSTOMERID, CUST.FULLNAME
			FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#LookupTNSWorkOrders.STAFFID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
					WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
			ORDER BY	CUST.FULLNAME
		</CFQUERY>
          
          <CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE">
			SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.SERIALNUMBER, HI.STATEFOUNDNUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE,
					HI.OWNINGORGID, HI.MODELNAMEID, MODELNAMELIST.MODELNAME, HI.MODELNUMBERID, MODELNUMBERLIST.MODELNUMBER,
					HI.CUSTOMERID, CUST.FULLNAME, LOC.ROOMNUMBER, HW.WARRANTYEXPIRATIONDATE AS WARDATE,
					CUST.FULLNAME ||'-' || EQT.EQUIPMENTTYPE || '-' || MODELNAMELIST.MODELNAME || '-' || HI.BARCODENUMBER AS LOOKUPBARCODE
			FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST, MODELNUMBERLIST, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					FACILITIESMGR.LOCATIONS LOC, HARDWAREWARRANTY HW
			WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#LookupTNSWorkOrders.HW_INVENTORYID#" cfsqltype="CF_SQL_NUMERIC"> AND
					HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND
					HI.MODELNAMEID = MODELNAMELIST.MODELNAMEID AND
					HI.MODELNUMBERID = MODELNUMBERLIST.MODELNUMBERID AND
					HI.CUSTOMERID = CUST.CUSTOMERID AND
					CUST.LOCATIONID = LOC.LOCATIONID AND
					HI.BARCODENUMBER = HW.BARCODENUMBER
			ORDER BY	CUST.FULLNAME, EQT.EQUIPMENTTYPE, MODELNAMELIST.MODELNAME
		</CFQUERY>

	
	<CFIF #FORM.SORTCHOICE# EQ 2 AND #USERHEADER# NEQ '#LookupStaffAssigned.FULLNAME#'>
		<TR>
			<TH align="left" nowrap colspan="3">
				<H2>#LookupStaffAssigned.FULLNAME#
				<CFSET USERHEADER = '#LookupStaffAssigned.FULLNAME#'>
			</H2></TH>
		</TR>
	</CFIF>
		<TR>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.SERVICEREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(LookupServiceRequests.CREATIONDATE, "mm/dd/yyyy")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupServiceRequests.FULLNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupTNSWorkOrders.WO_TYPE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupTNSWorkOrders.WO_STATUS#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupTNSWorkOrders.WO_NUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(LookupTNSWorkOrders.WO_DUEDATE, "mm/dd/yyyy")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupTNSWorkOrders.CURRENTJACK#</DIV></TD>
		<CFIF #LookupTNSWorkOrders.NEW_JACKNUMBER# GT 0>
			<TD align="center" valign="TOP"><DIV>#LookupTNSWorkOrders.NEWJACK#</DIV></TD>
		<CFELSE>
			<TD align="center" valign="TOP"><DIV>&nbsp;&nbsp;</DIV></TD>
		</CFIF>
		<CFIF #FORM.SORTCHOICE# EQ 1>
          	
			<TD align="center" valign="TOP"><DIV>#LookupStaffAssigned.FULLNAME#</DIV></TD>
		</CFIF>
		</TR>
		<TR>
			<TD align="left" >&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="LEFT" valign="TOP">Work Description:</TH>
			<TD align="LEFT" valign="TOP" colspan="2">
               	<DIV>&nbsp;&nbsp;#LookupTNSWorkOrders.WORK_DESCRIPTION#</DIV>
               </TD>
			<TH align="LEFT" valign="TOP">Justification Description:</TH>
			<TD align="LEFT" valign="TOP" colspan="2">
               	<DIV>&nbsp;&nbsp;#LookupTNSWorkOrders.JUSTIFICATION_DESCRIPTION#</DIV>
               </TD>
			<TH align="LEFT" valign="TOP">Other Description:</TH>
			<TD align="LEFT" valign="TOP" colspan="3">
               	<DIV>&nbsp;&nbsp;#LookupTNSWorkOrders.OTHER_DESCRIPTION#</DIV>
               </TD>
		</TR>
          <TR>
			<TD align="left" >&nbsp;&nbsp;</TD>
		</TR>
          <TR>
          	 <TH align="left" valign="TOP">Hardware Barcode:</TH>
               <TD align="left" valign="TOP" colspan="2">
                    <DIV>&nbsp;&nbsp;#LookupHardware.BARCODENUMBER#</DIV>
               </TD>
               <TH align="left" valign="TOP">Model Name / Number:</TH>
               <TD align="left" valign="TOP" colspan="2">
                    <DIV>&nbsp;&nbsp;#LookupHardware.MODELNAME# / #LookupHardware.MODELNUMBER#</DIV>
               </TD>
               <TH align="left" valign="TOP">Property ID:</TH>
               <TD align="left" valign="TOP">
                    <DIV>&nbsp;&nbsp;#LookupHardware.STATEFOUNDNUMBER#</DIV>
               </TD>
               <TH align="left" valign="TOP">Serial Number:</TH>
               <TD align="left" valign="TOP">
                    <DIV>&nbsp;&nbsp;#LookupHardware.SERIALNUMBER#</DIV>
               </TD>
          </TR>
          <TR>
			<TD align="left" valign="TOP" colspan="10"><HR></TD>
		</TR>
 </CFLOOP>
		<TR>
			<TH align="CENTER" colspan="10">
               <CFIF RECORDCOUNT GT 0>
				<CFSET RECORDCOUNT = RECORDCOUNT - 1>
               </CFIF>
				<H2>#RECORDCOUNT# TNS Work Order records were selected.
			</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/tnsworkordersdbreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="10">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>