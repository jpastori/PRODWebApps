<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: srunitcustreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/08/2012 --->
<!--- Date in Production: 08/08/2012 --->
<!--- Module: Service Request - Unit Liaison Query Report --->
<!-- Last modified by John R. Pastori on 02/13/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/srunitcustreport.cfm">
<CFSET CONTENT_UPDATED = "February 13, 2015">

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
	<TITLE>Service Request - Unit Liaison Query Report</TITLE>
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
		if (document.LOOKUP.ALTERNATE_CONTACTID.selectedIndex == "0" && document.LOOKUP.SERVICEREQUESTNUMBER.value.length == "5"
		 && document.LOOKUP.HARDWAREID.selectedIndex == "0"          && document.LOOKUP.BARCODENUMBER.value.length == "7"
		 && document.LOOKUP.DIVISIONNUMBER.value.length == "0"       && document.LOOKUP.ROOMNUMBER.value.length == "0"
		 && document.LOOKUP.SRCOMPLETE.selectedIndex == "0") {
		 	alertuser ("At least one field must be selected or filled in.");
			document.LOOKUP.ALTERNATE_CONTACTID.focus();
			return false;
		}
		
		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = LOOKUP.BARCODENUMBER.value;
			LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if (document.LOOKUP.HARDWAREID.selectedIndex > "0" && document.LOOKUP.BARCODENUMBER.value != "3065000") {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  BOTH a dropdown value AND a 17 character Bar Code Number can NOT be entered! Choose one or the other.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
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
<CFIF NOT IsDefined('URL.LOOKUPUNITCUST')>
	<CFSET CURSORFIELD = "document.LOOKUP.ALTERNATE_CONTACTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
***************************************************************************************************************
* The following code is the Look Up Process for Service Request - Unit Liaison Query Report record Selection. *
***************************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPUNITCUST')>

	<CFQUERY name="ListUnitLiaisons" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
          SELECT	UL.UNITLIAISONID, UL.UNITID, U.UNITID, U.UNITNAME, UL.ALTERNATE_CONTACTID, CUST.CUSTOMERID, CUST.FULLNAME,
                    U.UNITNAME || ' - ' || CUST.FULLNAME AS KEYFINDER
          FROM		UNITLIAISON UL, LIBSHAREDDATAMGR.UNITS U, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	UL.UNITID = U.UNITID AND
                    UL.ALTERNATE_CONTACTID = CUST.CUSTOMERID
          ORDER BY	U.UNITNAME, CUST.FULLNAME
     </CFQUERY>
     
     <CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	(CURRENTFISCALYEAR = 'YES')
          ORDER BY	FISCALYEARID
     </CFQUERY>
     
     <CFQUERY name="ListPublicHardwareNames" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.CATEGORYID, CUST.ACTIVE
		FROM		CUSTOMERS CUST
		WHERE	CUST.CATEGORYID = 6 AND
          		CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</CFQUERY>
     
     <CFQUERY name="LookupPublicHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTTYPEID, HI.CUSTOMERID,
				CUST.FULLNAME || ' - ' || ET.EQUIPMENTTYPE ||' - ' || HI.DIVISIONNUMBER AS LOOKUPKEY
		FROM		HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST, EQUIPMENTTYPE ET
		WHERE	(HI.HARDWAREID = 0 OR
          		HI.CUSTOMERID IN  (#ValueList(ListPublicHardwareNames.CUSTOMERID)#)) AND
          		(HI.CUSTOMERID = CUST.CUSTOMERID AND
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID)
		ORDER BY	LOOKUPKEY
	</CFQUERY>

     <TABLE width="100%" align="center" border="3">
          <TR align="center">
               <TH align="center"><H1>Service Request - Unit Liaison Query Selection Lookup</H1></TH>
          </TR>
     </TABLE>
	
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>Select from the drop down boxes or type in date values to choose report criteria.<BR />
                    	Hardware criteria will only find SRs with the chosen hardware.<BR />
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/srunitcustreport.cfm?LOOKUPUNITCUST=FOUND" method="POST">
		<TR>
			<TH align="left" valign="BOTTOM">
               	<LABEL for="ALTERNATE_CONTACTID">Unit Liaison</LABEL>
               </TH>
			<TH align="left" valign="BOTTOM">
				<LABEL for="SERVICEREQUESTNUMBER">Or SR Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="left">
                    <CFSELECT name="ALTERNATE_CONTACTID" id="ALTERNATE_CONTACTID" size="1" query="ListUnitLiaisons" value="ALTERNATE_CONTACTID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
               </TD>
			<TD align="LEFT">
				<CFINPUT type="Text" name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" value="#ListCurrentFiscalYear.FISCALYEAR_2DIGIT#" align="LEFT" required="NO" size="9" maxlength="9" tabindex="3"><BR>
                    <COM>(Starts with Fiscal Year i.e 12/13)</COM>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="LEFT"><LABEL for="HARDWAREID">Public Hardware</LABEL></TH>
               <TH align="LEFT"><LABEL for="BARCODENUMBER">Or Bar Code Number</LABEL></TH>
		</TR>
         <TR>
			<TD align="LEFT">
				<CFSELECT name="HARDWAREID" id="HARDWAREID" size="1" query="LookupPublicHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" tabindex="4"></CFSELECT>
			</TD>
               <TD align="LEFT">
				<CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="3065000" align="LEFT" required="No" size="18" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
         <TR>
			<TH align="left" valign="BOTTOM">
               	<LABEL for="DIVISIONNUMBER">Division Number</LABEL>
			</TH>
               <TH align="left" valign="BOTTOM">
				<LABEL for="ROOMNUMBER">Room Number of Hardware</LABEL>
			</TH>
		</TR>
          <TR>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="" align="LEFT" required="No" size="50" tabindex="6"><BR>
                    <COM>(Type the hardware's labeled name.)</COM>
			</TD>
               <TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBER" value="" required="No" size="20" maxlength="50" tabindex="7"><BR>
                    <COM>(i.e LA-1101W.)</COM>
			</TD>
		
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>          
			<TH align="left"><LABEL for="SRCOMPLETED">SR Complete?</LABEL></TH>
               <TH align="left">&nbsp;&nbsp;</TH>
		</TR>
 		<TR>
			<TD align="left" valign="top">
				<CFSELECT name="SRCOMPLETED" id="SRCOMPLETED" size="1" tabindex="8">
					<OPTION selected value="Select Status">Select Status</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
               <TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP">
               	<LABEL for="BEGINDATE">Enter Begin Creation Date</LABEL>
               </TH>
			<TH align="left" valign="TOP">
               	<LABEL for="ENDDATE">Enter End Creation Date</LABEL>
               </TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="BEGINDATE" id="BEGINDATE" value="" required="No" size="15" maxlength="25" tabindex="9">
                    <SCRIPT language="JavaScript">
					new tcal ({'formname': 'LOOKUP','controlname': 'BEGINDATE'});

				</SCRIPT><BR>
                    <COM>(Date Format: MM/DD/YYYY)</COM>
			</TD>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="ENDDATE" id="ENDDATE" value="" required="No" size="15" maxlength="25" tabindex="10">
                    <SCRIPT language="JavaScript">
					new tcal ({'formname': 'LOOKUP','controlname': 'ENDDATE'});

				</SCRIPT><BR>
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
				<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="11" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="#SESSION.RETURNPGM#" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="12" /><BR>
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
*********************************************************************************************
* The following code is the Service Request - Unit Liaison Query Report Generation Process. *
*********************************************************************************************
 --->  
     
     <CFQUERY name="LookupPublicHardware" datasource="#application.type#HARDWARE" blockfactor="100">
          SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTLOCATIONID, LOC.ROOMNUMBER, PUBCUST.FIRSTNAME, PUBCUST.ACTIVE
          FROM		HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS PUBCUST
          WHERE	
               <CFIF FORM.HARDWAREID GT 0>
                    HI.HARDWAREID =  <CFQUERYPARAM value="#FORM.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
               </CFIF>
               <CFIF #FORM.BARCODENUMBER# NEQ '3065000'>
                    HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
               </CFIF>
               <CFIF #FORM.DIVISIONNUMBER# NEQ ''>
                    HI.DIVISIONNUMBER LIKE '%#FORM.DIVISIONNUMBER#%' AND
               </CFIF>
                    HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
                    HI.CUSTOMERID = PUBCUST.CUSTOMERID AND
               <CFIF #FORM.ROOMNUMBER# NEQ ''>
                    LOC.ROOMNUMBER LIKE '%#FORM.ROOMNUMBER#%' AND
                    PUBCUST.FIRSTNAME = 'PUBLIC' AND
                    PUBCUST.ACTIVE = 'YES' AND
               </CFIF>
                    HI.HARDWAREID > 0
          ORDER BY	HI.BARCODENUMBER, HI.DIVISIONNUMBER
     </CFQUERY>
     
     <CFQUERY name="LookupSREquipBarcodes" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
          FROM		SREQUIPLOOKUP
          WHERE	EQUIPMENTBARCODE IN  ('#LookupPublicHardware.BARCODENUMBER#')
     </CFQUERY>
     
     <CFIF #FORM.ALTERNATE_CONTACTID# EQ 0 AND  #LEN(FORM.SERVICEREQUESTNUMBER)# EQ 5 AND LookupSREquipBarcodes.RecordCount EQ 0>
     	<SCRIPT language="JavaScript">
				<!-- 
					alert("Records meeting your selection criteria were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srunitcustreport.cfm" />
			<CFEXIT>
	</CFIF>
     
	<CFSET DATERANGEREPORT = "NO">
	<CFIF #FORM.BEGINDATE# NEQ "">
		<CFSET DATERANGEREPORT = "YES">
		<CFSET BEGINDATE = #DateFormat(FORM.BEGINDATE, "dd/mmm/yyyy")#>
		<CFSET ENDDATE = #DateFormat(FORM.ENDDATE, "dd/mmm/yyyy")#>
		BEGIN DATE = #BEGINDATE# &nbsp;&nbsp;&nbsp;&nbsp;END DATE = #ENDDATE#<BR /><BR />
	</CFIF>


	<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE, 
				SR.REQUESTERID, REQCUST.FULLNAME AS REQNAME, SR.ALTERNATE_CONTACTID, ALTCUST.UNITID, U.UNITNAME, 
                    SR.PRIORITYID, P.PRIORITYNAME, SR.GROUPASSIGNEDID, IDTGROUP.GROUPNAME, SR.PROBLEM_DESCRIPTION, 
                    SR.SRCOMPLETEDDATE, SR.SRCOMPLETED 
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, LIBSHAREDDATAMGR.CUSTOMERS ALTCUST, 
          		LIBSHAREDDATAMGR.UNITS U, PRIORITY P, GROUPASSIGNED IDTGROUP        		
		WHERE	SR.SRID > 0 AND
          		SR.REQUESTERID = REQCUST.CUSTOMERID AND
          	<CFIF #FORM.ALTERNATE_CONTACTID# GT 0>
				SR.ALTERNATE_CONTACTID = <CFQUERYPARAM value="#FORM.ALTERNATE_CONTACTID#" cfsqltype="CF_SQL_NUMERIC"> AND
               </CFIF>
               	SR.ALTERNATE_CONTACTID = ALTCUST.CUSTOMERID AND
                    ALTCUST.UNITID = U.UNITID AND
               <CFIF #LEN(FORM.SERVICEREQUESTNUMBER)# GT 5>
               	SR.SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#FORM.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
               </CFIF>
               <CFIF #LookupSREquipBarcodes.RecordCount# GT 0>
               	SR.SERVICEREQUESTNUMBER IN ('#LookupSREquipBarcodes.SERVICEREQUESTNUMBER#') AND
               </CFIF>
			<CFIF #DATERANGEREPORT# EQ "YES">
				SR.CREATIONDATE BETWEEN TO_DATE('#BEGINDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATE#', 'DD-MON-YYYY') AND
			</CFIF>
				SR.PRIORITYID = P.PRIORITYID AND
			<CFIF FORM.SRCOMPLETED NEQ "Select Status">
				SR.SRCOMPLETED = '#FORM.SRCOMPLETED#' AND
			</CFIF>
				SR.GROUPASSIGNEDID = IDTGROUP.GROUPID
		ORDER BY	SR.SERVICEREQUESTNUMBER DESC
	</CFQUERY>

	<CFIF #ListServiceRequests.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records meeting your selection criteria were Not Found");
				--> 
			</SCRIPT>
			<!--- <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srunitcustreport.cfm" /> --->
			<CFEXIT>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
          <TR align="center">
               <TH align="center"><H1>Service Request - Unit Liaison Query Report</H1></TH>
          </TR>
          <TR align="center">
			<TD align="center"><H2>For Unit: #ListServiceRequests.UNITNAME#</H2></TD>
		</TR>
     <CFIF DATERANGEREPORT EQ "YES">
		<CFSET REPORTDATETITLE = "From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# ">
          <TR align="center">
			<TD align="center"> #REPORTDATETITLE#</TD>
		</TR>
     </CFIF>
     </TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/srunitcustreport.cfm" method="POST">
			<TD align="left"><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="8"><H2>#ListServiceRequests.RecordCount# Service Request records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="center">Requester</TH>
			<TH align="center">SR</TH>
			<TH align="center">Creation Date</TH>
			<TH align="center">Priority</TH>
			<TH align="center">BarCode Number</TH>
			<TH align="center">Primary Group Assigned</TH>
			<TH align="center">Completed SR?</TH>
			<TH align="center">SR Completed Date</TH>
		</TR>
     	<TR>
			<TD align="left"  colspan="8"><HR></TD>
		</TR>
		
	<CFLOOP query="ListServiceRequests">	
	
		<CFQUERY name="ListSREquipBarcode" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
				SELECT	SREL.SREQUIPID, SREL.SERVICEREQUESTNUMBER, SREL.EQUIPMENTBARCODE, HI.BARCODENUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTLOCATIONID, LOC.ROOMNUMBER
				FROM		SREQUIPLOOKUP SREL, HARDWMGR.HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC
				WHERE	SREL.SERVICEREQUESTNUMBER = '#ListServiceRequests.SERVICEREQUESTNUMBER#' AND
                    		SREL.EQUIPMENTBARCODE = HI.BARCODENUMBER AND
                              HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID
                    ORDER BY	SREL.SERVICEREQUESTNUMBER, SREL.EQUIPMENTBARCODE
		</CFQUERY>
	
		<TR>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.REQNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.SERVICEREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.CREATIONDATE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.PRIORITYNAME#</DIV></TD>
		<CFIF ListSREquipBarcode.RecordCount GT 0>
			<TD align="center" valign="TOP"><DIV>#ListSREquipBarcode.EQUIPMENTBARCODE#</DIV></TD>
		<CFELSE>
			<TD align="center" valign="TOP"><DIV>&nbsp;&nbsp;</DIV></TD>
		</CFIF>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.GROUPNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.SRCOMPLETED#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListServiceRequests.SRCOMPLETEDDATE, "mm/dd/yyyy")#</DIV></TD>
		</TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
          <TR>
          	<TH align="center">Problem Description:</TH>
               <TD align="left" valign="TOP" colspan="7"><DIV>#ListServiceRequests.PROBLEM_DESCRIPTION#</DIV></TD>
		</TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
          <TR>
          	<TH align="center">Division Number: </TH>
               <TD align="left" valign="TOP" colspan="3"><DIV>#ListSREquipBarcode.DIVISIONNUMBER#</DIV></TD>
               <TH align="center">Room Number: </TH>
               <TD align="left" valign="TOP" colspan="3"><DIV>#ListSREquipBarcode.ROOMNUMBER#</DIV></TD>
		</TR>
		<TR>
			<TD align="left"  colspan="8"><HR></TD>
		</TR>
	</CFLOOP>
	
		<TR>
			<TH align="CENTER" colspan="8"><H2>#ListServiceRequests.RecordCount# Service Request records were selected.</H2></TH>
		</TR>
	
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/srunitcustreport.cfm" method="POST">
			<TD align="left"><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /></TD>
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
</CFOUTPUT>
</HTML>