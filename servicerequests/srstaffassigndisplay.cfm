<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: srstaffassigndisplay.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/30/2012 --->
<!--- Date in Production: 07/30/2012 --->
<!--- Module: SR Status Report and Display Loop --->
<!-- Last modified by John R. Pastori on 11/07/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/srstaffassigndisplay.cfm">
<CFSET CONTENT_UPDATED = "November 07, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<CFIF NOT IsDefined('Cookie.DISPLAYTYPE') AND IsDefined('URL.DISPLAYTYPE')>
	<CFCOOKIE name="DISPLAYTYPE" secure="NO" value="#URL.DISPLAYTYPE#">
</CFIF>

<HTML>
<HEAD>
	<TITLE>SR Status Report and Display Loop</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Service Requests Application";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateBasicLookupFields() {
		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length == 5  && document.LOOKUP.SRID.selectedIndex == "0" 
		 && document.LOOKUP.REQUESTERID.selectedIndex == "0"        && document.LOOKUP.UNITID.selectedIndex == "0"
		 && (document.LOOKUP.REQUESTERFIRSTNAME.value == ""         || document.LOOKUP.REQUESTERFIRSTNAME.value == " ")
		 && (document.LOOKUP.REQUESTERLASTNAME.value == ""          || document.LOOKUP.REQUESTERLASTNAME.value == " ")         
		 && document.LOOKUP.CATEGORYID.selectedIndex == "0" 	     && document.LOOKUP.SUBCATEGORYID.selectedIndex == "0"    
		 && (document.LOOKUP.PROBLEM_DESCRIPTION.value == ""        || document.LOOKUP.PROBLEM_DESCRIPTION.value == " ")
		 && document.LOOKUP.PRIORITYID.selectedIndex == "0"         
		 && (document.LOOKUP.CREATIONDATE.value == ""               || document.LOOKUP.CREATIONDATE.value == " ")
		 && document.LOOKUP.SRCOMPLETED.value == "Select"			&& document.LOOKUP.BARCODENUMBER.selectedIndex == "0"
		 && document.LOOKUP.STATEFOUNDNUMBERBC.selectedIndex == "0" && ((document.LOOKUP.DIVISIONNUMBERBC.selectedIndex == "0")
		 && (document.LOOKUP.DIVISIONNUMBER_TEXT.value == " "		|| document.LOOKUP.DIVISIONNUMBER_TEXT.value == " "))
		 && document.LOOKUP.STAFFCUSTOMERID.selectedIndex == "0" 
		 && (document.LOOKUP.STAFF_DATEASSIGNED.value == ""         || document.LOOKUP.STAFF_DATEASSIGNED.value == " ")
		 && document.LOOKUP.GROUPASSIGNEDID.selectedIndex == "0"    && document.LOOKUP.SDINITIALSID.selectedIndex == "0"
		 && (document.LOOKUP.STAFF_COMMENTS.value == ""        	|| document.LOOKUP.STAFF_COMMENTS.value == " ")
		 && document.LOOKUP.STAFF_COMPLETEDSR.value == "Select") {
			alertuser ("You must enter information in one of the twenty-two (22) fields!");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}
		
		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length != 5 
		 && document.LOOKUP.SERVICEREQUESTNUMBER.value.length != 9) {
			alertuser ("You must enter a 9 character Service Request Number.");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}

		if ((document.LOOKUP.DIVISIONNUMBERBC.selectedIndex != "0") && (document.LOOKUP.DIVISIONNUMBER_TEXT.value != ""
		 && document.LOOKUP.DIVISIONNUMBER_TEXT.value != " ")) {
			alertuser ("You Can Not both select a Division Number from the dropdown and enter a Division Number in the text field.");
			document.LOOKUP.DIVISIONNUMBERBC.focus();
			return false;
		}
		
	}
	
	
	function validateExtraLookupFields() {
		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length == 5  && document.LOOKUP.SRID.selectedIndex == "0" 
		 && document.LOOKUP.REQUESTERID.selectedIndex == "0"        && document.LOOKUP.UNITID.selectedIndex == "0"
		 && (document.LOOKUP.REQUESTERFIRSTNAME.value == ""         || document.LOOKUP.REQUESTERFIRSTNAME.value == " ")
		 && (document.LOOKUP.REQUESTERLASTNAME.value == ""          || document.LOOKUP.REQUESTERLASTNAME.value == " ")         
		 && document.LOOKUP.CATEGORYID.selectedIndex == "0" 	     && document.LOOKUP.SUBCATEGORYID.selectedIndex == "0"    
		 && (document.LOOKUP.PROBLEM_DESCRIPTION.value == ""        || document.LOOKUP.PROBLEM_DESCRIPTION.value == " ")
		 && document.LOOKUP.PRIORITYID.selectedIndex == "0"         
		 && (document.LOOKUP.CREATIONDATE.value == ""               || document.LOOKUP.CREATIONDATE.value == " ")
		 && document.LOOKUP.SRCOMPLETED.value == "Select"			&& document.LOOKUP.BARCODENUMBER.selectedIndex == "0"
		 && document.LOOKUP.STATEFOUNDNUMBERBC.selectedIndex == "0" && ((document.LOOKUP.DIVISIONNUMBERBC.selectedIndex == "0")
		 && (document.LOOKUP.DIVISIONNUMBER_TEXT.value == " "		|| document.LOOKUP.DIVISIONNUMBER_TEXT.value == " "))
		 && (document.LOOKUP.PONUMBER.value == ""				|| document.LOOKUP.PONUMBER.value == " ")
		 && (document.LOOKUP.TNSWONUMBER.value == ""                || document.LOOKUP.TNSWONUMBER.value == " ") 
		 && document.LOOKUP.STAFFCUSTOMERID.selectedIndex == "0" 
		 && (document.LOOKUP.STAFF_DATEASSIGNED.value == ""         || document.LOOKUP.STAFF_DATEASSIGNED.value == " ")
		 && document.LOOKUP.GROUPASSIGNEDID.selectedIndex == "0"    && document.LOOKUP.SDINITIALSID.selectedIndex == "0"
		 && (document.LOOKUP.STAFF_COMMENTS.value == ""        	|| document.LOOKUP.STAFF_COMMENTS.value == " ")
		 && document.LOOKUP.STAFF_COMPLETEDSR.value == "Select") {
			alertuser ("You must enter information in one of the twenty-five (25) fields!");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}

		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length != 5 
		 && document.LOOKUP.SERVICEREQUESTNUMBER.value.length != 9) {
			alertuser ("You must enter a 9 character Service Request Number.");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}
		
		if ((document.LOOKUP.DIVISIONNUMBERBC.selectedIndex != "0") && (document.LOOKUP.DIVISIONNUMBER_TEXT.value != ""
		 && document.LOOKUP.DIVISIONNUMBER_TEXT.value != " ")) {
			alertuser ("You Can Not both select a Division Number from the dropdown and enter a Division Number in the text field.");
			document.LOOKUP.DIVISIONNUMBERBC.focus();
			return false;
		}
		
	}
	
	
	function validateLookupSRReqFields() {
		if (document.LOOKUPSR.SRID.selectedIndex == "0") {
			alertuser ("You must select a Service Request.");
			document.LOOKUPSR.SRID.focus();
			return false;
		}
	}

	
	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}

	
	function setPrevRecord() {
		document.DISPLAYRECORD.RETRIEVERECORD.value = "PREVIOUS RECORD";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFIF NOT IsDefined('URL.LOOKUPSRID')>
	<CFSET CURSORFIELD = "document.LOOKUP.SERVICEREQUESTNUMBER.focus()">     
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*****************************************************************************
* The following code is used by all Processes for SR Status Data Selection. *
*****************************************************************************
 --->
 
<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<!--- 
***************************************************************************
* The following code is the Look Up Process for SR Status Data Selection. *
***************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPSRID')>

	<CFSET SESSION.FINDHWBARCODESR = "">
	<CFSET SESSION.FINDHWSTATEFOUNDSR = "">
	<CFSET SESSION.FINDHWDIVISIONSR = "">
	<CFSET SESSION.FINDBARCODE = "">
     <CFSET SESSION.FINDBARCODESR = "">

	<CFIF (FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>
		<CFCOOKIE name="STAFFLOOKUPID" secure="NO" expires="NOW">
          <CFSET session.SRIDArray=ArrayNew(1)>
		<CFSET temp = ArraySet(session.SRIDArray, 1, 1, 0)>
		<CFSET session.ArrayCounter = 0>
	</CFIF>

	<CFIF FIND('EXTRA', #Cookie.DISPLAYTYPE#, 1) NEQ 0>
		<CFSET session.LookupReportTitle = "#RIGHT(Cookie.DISPLAYTYPE, 5)# SR Comments #LEFT(Cookie.DISPLAYTYPE, 6)# Lookup">
          <CFSET ValidateFields = "validateExtraLookupFields()">
     <CFELSEIF FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0>
     	<CFSET session.LookupReportTitle = "#LEFT(Cookie.DISPLAYTYPE, 4)# SR Comments Lookup">
          <CFIF FIND('EXTRA', #Cookie.DISPLAYTYPE#, 1) NEQ 0>
          	<CFSET ValidateFields = "validateExtraLookupFields()">
          <CFELSE>
     		<CFSET ValidateFields = "validateBasicLookupFields()">
          </CFIF>
     <CFELSE>
     	<CFSET session.LookupReportTitle = "SR Comments #LEFT(Cookie.DISPLAYTYPE, 6)#  Lookup">
     	<CFSET ValidateFields = "validateBasicLookupFields()">
     </CFIF>
	<CFSET session.ServiceRequestRecCount = 0>
	<CFSET session.ACTIONPGM = "srstaffassigndisplay.cfm?LOOKUPSRID=FOUND">
     <CFSET session.REPORT = "SRDISPLAY">
	<CFINCLUDE template = "srstaffassignslookup.cfm">
     
    	<CFEXIT>

<CFELSEIF ((FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0 AND session.SRIDArray[1] EQ 0) OR (FIND('SINGLE', #Cookie.DISPLAYTYPE#, 1) NEQ 0 AND NOT (IsDefined('FORM.SRSELECTED'))))>

<!--- 
***********************************************************************************
* The following code is the SR Status Report and Display Loop Generation Process. *
***********************************************************************************
 --->

	<CFIF "#FORM.CREATIONDATE#" NEQ ''>
		<CFSET CREATIONDATELIST = "NO">
		<CFSET CREATIONDATERANGE = "NO">
		<CFIF FIND(',', #FORM.CREATIONDATE#, 1) EQ 0 AND FIND(';', #FORM.CREATIONDATE#, 1) EQ 0>
			<CFSET FORM.CREATIONDATE = DateFormat(FORM.CREATIONDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.CREATIONDATE#, 1) NEQ 0>
				<CFSET CREATIONDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.CREATIONDATE#, 1) NEQ 0>
				<CFSET CREATIONDATERANGE = "YES">
				<CFSET FORM.CREATIONDATE = #REPLACE(FORM.CREATIONDATE, ";", ",")#>
			</CFIF>
			<CFSET CREATIONDATEARRAY = ListToArray(FORM.CREATIONDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(CREATIONDATEARRAY)# >
				<!--- CREATION DATE FIELD = #CREATIONDATEARRAY[COUNTER]#<BR /><BR /> --->
			</CFLOOP>
		</CFIF>
		<CFIF CREATIONDATERANGE EQ "YES">
			<CFSET BEGINCREATIONDATE = DateFormat(#CREATIONDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDCREATIONDATE = DateFormat(#CREATIONDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- CREATION DATE LIST = #CREATIONDATELIST#<BR /><BR /> --->
		<!--- CREATION DATE RANGE = #CREATIONDATERANGE#<BR /><BR /> --->
	</CFIF>
     
     <CFIF ((IsDefined('LookupHardwareAssigns.RecordCount') AND #LookupHardwareAssigns.RecordCount# EQ 0) OR (IsDefined('LookupSoftwareAssigns.RecordCount') AND #LookupSoftwareAssigns.RecordCount# EQ 0))>
		<SCRIPT language="JavaScript">
               <!-- 
                    alert("Selected Hardware/Software Assign Flag Not Found");
               --> 
          </SCRIPT>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" />
          <CFEXIT>
     </CFIF>
     
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
                    ORDER BY	BARCODENUMBER
               </CFQUERY>
               
      	<CFELSEIF FIND(';', #FORM.DIVISIONNUMBER_TEXT#, 1) NEQ 0>
          
          	<CFSET FORM.DIVISIONNUMBER_TEXT = #REPLACE(FORM.DIVISIONNUMBER_TEXT, ";", ",")#>

			<CFSET FORM.DIVISIONNUMBER_BEGIN = ListFirst(FORM.DIVISIONNUMBER_TEXT)>
               <CFSET FORM.DIVISIONNUMBER_END = ListLast(FORM.DIVISIONNUMBER_TEXT)>
          
          	<CFQUERY name="LookupHardwareDivisionText" datasource="#application.type#HARDWARE" blockfactor="100">
                    SELECT	BARCODENUMBER, DIVISIONNUMBER
                    FROM		HARDWAREINVENTORY
                    WHERE	(DIVISIONNUMBER >= '#FORM.DIVISIONNUMBER_BEGIN#' AND DIVISIONNUMBER <= '#FORM.DIVISIONNUMBER_END#')
                    ORDER BY	BARCODENUMBER
               </CFQUERY>
               
          <CFELSE>
          
          	<CFQUERY name="LookupHardwareDivisionText" datasource="#application.type#HARDWARE" blockfactor="100">
                    SELECT	BARCODENUMBER, DIVISIONNUMBER
                    FROM		HARDWAREINVENTORY
                    WHERE	DIVISIONNUMBER LIKE '%#FORM.DIVISIONNUMBER_TEXT#%'
                    ORDER BY	BARCODENUMBER
               </CFQUERY>
               
		</CFIF>
          
		<CFSET SESSION.FINDBARCODE = #ValueList(LookupHardwareDivisionText.BARCODENUMBER)#>
          <!--- <BR>SESSION FIND BARCODE 1 = #SESSION.FINDBARCODE# <BR><BR> --->
          <CFSET SESSION.FINDBARCODE = ListChangeDelims(SESSION.FINDBARCODE, "','", ",")>
          <!--- <BR>SESSION FIND BARCODE 2 = #SESSION.FINDBARCODE# <BR><BR> --->
 
          <CFQUERY name="LookupHardwareDivisionTextSR" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	EQUIPMENTBARCODE, SERVICEREQUESTNUMBER
               FROM		SREQUIPLOOKUP 
               WHERE	EQUIPMENTBARCODE IN ('#PreserveSingleQuotes(SESSION.FINDBARCODE)#')
               ORDER BY	SERVICEREQUESTNUMBER
          </CFQUERY>
          
          <CFSET SESSION.FINDBARCODESR = #ValueList(LookupHardwareDivisionTextSR.SERVICEREQUESTNUMBER)#>
          <!--- <BR>SESSION FIND BARCODE SR 1 = #SESSION.FINDBARCODESR# <BR><BR> --->
          <CFSET SESSION.FINDBARCODESR = ListChangeDelims(SESSION.FINDBARCODESR, "','", ",")>
               
     </CFIF>
     
     <CFIF IsDefined('FORM.PONUMBER') AND #FORM.PONUMBER# NEQ "">
          <CFQUERY name="LookupPurchReqPO" datasource="#application.type#PURCHASING">
               SELECT	PURCHREQID, PONUMBER, SERVICEREQUESTNUMBER
               FROM		PURCHREQS
               WHERE	PONUMBER LIKE UPPER('%#FORM.PONUMBER#%')
               ORDER BY	SERVICEREQUESTNUMBER
          </CFQUERY>
          <CFIF #LookupPurchReqPO.RecordCount# EQ 0>
               <SCRIPT language="JavaScript">
                    <!-- 
                         alert("Purchase Order Number Not Found");
                    --> 
               </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" />
               <CFEXIT>
          </CFIF>
     </CFIF>
     
     <CFIF IsDefined('FORM.TNSWONUMBER') AND #FORM.TNSWONUMBER# NEQ "">
          <CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
               SELECT	TNSWO.TNSWOID, TNSWO.SRID, TNSWO.TNSWONUMBER
               FROM		TNSWORKORDERS TNSWO
               WHERE	TNSWO.TNSWONUMBER LIKE '%#FORM.TNSWONUMBER#%'
               ORDER BY	TNSWO.TNSWONUMBER
          </CFQUERY>
          <CFIF #LookupTNSWorkOrders.RecordCount# EQ 0>
               <SCRIPT language="JavaScript">
                    <!-- 
                         alert("TNS Work Order Number Not Found");
                    --> 
               </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" />
               <CFEXIT>
          </CFIF>
     </CFIF>
     
	<CFIF "#FORM.STAFF_DATEASSIGNED#" NEQ ''>
		<CFSET STAFF_DATEASSIGNEDLIST = "NO">
		<CFSET STAFF_DATEASSIGNEDRANGE = "NO">
		<CFIF FIND(',', #FORM.STAFF_DATEASSIGNED#, 1) EQ 0 AND FIND(';', #FORM.STAFF_DATEASSIGNED#, 1) EQ 0>
			<CFSET FORM.STAFF_DATEASSIGNED = DateFormat(FORM.STAFF_DATEASSIGNED, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.STAFF_DATEASSIGNED#, 1) NEQ 0>
				<CFSET STAFF_DATEASSIGNEDLIST = "YES">
			<CFELSEIF FIND(';', #FORM.STAFF_DATEASSIGNED#, 1) NEQ 0>
				<CFSET STAFF_DATEASSIGNEDRANGE = "YES">
				<CFSET FORM.STAFF_DATEASSIGNED = #REPLACE(FORM.STAFF_DATEASSIGNED, ";", ",")#>
			</CFIF>
			<CFSET STAFF_DATEASSIGNEDARRAY = ListToArray(FORM.STAFF_DATEASSIGNED)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(STAFF_DATEASSIGNEDARRAY)# >
				<!--- STAFF_DATE ASSIGNED FIELD = #STAFF_DATEASSIGNEDARRAY[COUNTER]#<BR /><BR /> --->
			</CFLOOP>
		</CFIF>
		<CFIF STAFF_DATEASSIGNEDRANGE EQ "YES">
			<CFSET BEGINSTAFF_DATEASSIGNED = DateFormat(#STAFF_DATEASSIGNEDARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDSTAFF_DATEASSIGNED = DateFormat(#STAFF_DATEASSIGNEDARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- STAFF_DATE ASSIGNED LIST = #STAFF_DATEASSIGNEDLIST#<BR /><BR /> --->
		<!--- STAFF_DATE ASSIGNED RANGE = #STAFF_DATEASSIGNEDRANGE#<BR /><BR /> --->
	</CFIF>

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFIF #FORM.GROUPASSIGNEDID# GT "0" OR #FORM.STAFFCUSTOMERID# GT "0" OR #FORM.STAFF_DATEASSIGNED# NEQ "" OR #FORM.SDINITIALSID# GT "0" OR #FORM.STAFF_COMMENTS# NEQ "" OR #FORM.STAFF_COMPLETEDSR# NEQ "Select">
     
     	<CFQUERY name="LookupStaffSelected" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
			SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID
			FROM		WORKGROUPASSIGNS WGA
			WHERE	WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#FORM.STAFFCUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> 
		</CFQUERY>
     
		<CFQUERY name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID AS STAFFSRID, SR.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID,
					SRSA.NEXT_ASSIGNMENT_GROUPID, WGA.GROUPID, GA.GROUPNAME, WGA.STAFFCUSTOMERID, CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED, 
					TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATE, SRSA.STAFF_COMMENTS, SRSA.STAFF_COMPLETEDSR
			FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SRSA.SRSTAFF_ASSIGNID > 0 AND
					SRSA.SRID = SR.SRID AND
					SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
					WGA.GROUPID = GA.GROUPID AND
					WGA.STAFFCUSTOMERID = CUST.CUSTOMERID) AND (

			<CFIF #FORM.STAFFCUSTOMERID# GT "0">
					SRSA.STAFF_ASSIGNEDID IN (#ValueList(LookupStaffSelected.WORKGROUPASSIGNSID)#) #LOGICANDOR#
			</CFIF>

			<CFIF #FORM.GROUPASSIGNEDID# GT "0">
					SRSA.NEXT_ASSIGNMENT_GROUPID = #val(FORM.GROUPASSIGNEDID)# #LOGICANDOR#
			</CFIF>

			<CFIF #FORM.STAFF_DATEASSIGNED# NEQ ''>
				<CFIF IsDefined("FORM.NEGATESTAFF_DATEASSIGNED")>
					<CFIF STAFF_DATEASSIGNEDLIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(STAFF_DATEASSIGNEDARRAY)#>
							<CFSET FORMATSTAFF_DATEASSIGNED =  DateFormat(#STAFF_DATEASSIGNEDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT SRSA.STAFF_DATEASSIGNED = TO_DATE('#FORMATSTAFF_DATEASSIGNED#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF STAFF_DATEASSIGNEDRANGE EQ "YES">
						NOT (SRSA.STAFF_DATEASSIGNED BETWEEN TO_DATE('#BEGINSTAFF_DATEASSIGNED#', 'DD-MON-YYYY') AND TO_DATE('#ENDSTAFF_DATEASSIGNED#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT SRSA.STAFF_DATEASSIGNED LIKE TO_DATE('#FORM.STAFF_DATEASSIGNED#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF STAFF_DATEASSIGNEDLIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(STAFF_DATEASSIGNEDARRAY) - 1)>
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATSTAFF_DATEASSIGNED = DateFormat(#STAFF_DATEASSIGNEDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							(SRSA.STAFF_DATEASSIGNED = TO_DATE('#FORMATSTAFF_DATEASSIGNED#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATSTAFF_DATEASSIGNED = DateFormat(#STAFF_DATEASSIGNEDARRAY[ArrayLen(STAFF_DATEASSIGNEDARRAY)]#, 'DD-MMM-YYYY')>
						SRSA.STAFF_DATEASSIGNED = TO_DATE('#FORMATSTAFF_DATEASSIGNED#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF STAFF_DATEASSIGNEDRANGE EQ "YES">
						(SRSA.STAFF_DATEASSIGNED BETWEEN TO_DATE('#BEGINSTAFF_DATEASSIGNED#', 'DD-MON-YYYY') AND TO_DATE('#ENDSTAFF_DATEASSIGNED#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						SRSA.STAFF_DATEASSIGNED LIKE TO_DATE('#FORM.STAFF_DATEASSIGNED#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.STAFF_COMMENTS# NEQ "">
				<CFIF IsDefined('FORM.NEGATESTAFF_COMMENTS')>
                         NOT SRSA.STAFF_COMMENTS LIKE UPPER('%#FORM.STAFF_COMMENTS#%') #LOGICANDOR#
                    <CFELSE>
                         SRSA.STAFF_COMMENTS LIKE UPPER('%#FORM.STAFF_COMMENTS#%') #LOGICANDOR#
                    </CFIF>
               </CFIF>

			<CFIF #FORM.STAFF_COMPLETEDSR# NEQ "Select">
                    	SRSA.STAFF_COMPLETEDSR = '#FORM.STAFF_COMPLETEDSR#' #LOGICANDOR#
               </CFIF>
					SRSA.SRID #FINALTEST# 0)
			ORDER BY	SRSA.SRID
		</CFQUERY>

	</CFIF>
     
     <CFIF #FORM.STAFF_COMPLETEDSR# EQ "YES" AND LookupSRStaffAssignments.RecordCount EQ 0>
		<SCRIPT language="JavaScript">
               <!-- 
                    alert("The selected staff person does not have any COMPLETED SRs.");
               --> 
          </SCRIPT>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" />
          <CFEXIT>

     <CFELSEIF #FORM.STAFF_COMPLETEDSR# EQ "VOIDED" AND LookupSRStaffAssignments.RecordCount EQ 0>
		<SCRIPT language="JavaScript">
               <!-- 
                    alert("The selected staff person does not have any VOIDED SRs.");
               --> 
          </SCRIPT>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" />
          <CFEXIT>
          
     </CFIF>

	<CFIF #FORM.STAFFCUSTOMERID# GT "0">
		<CFCOOKIE name="STAFFLOOKUPID" secure="NO" value="#FORM.STAFFCUSTOMERID#">
	</CFIF>
     
     <CFIF (FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0)> 
		<CFSET SORTORDER = ARRAYNEW(1)>
          <CFSET SORTORDER[1] = 'REQCUST.FULLNAME'>
          <CFSET SORTORDER[2] = 'SR.SERVICEREQUESTNUMBER'>
          <CFSET SORTORDER[3] = 'SR.SERVICEREQUESTNUMBER'>
          
          <CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.SORTCHOICE#]")>
          
          <CFSET SORTSEQUENCE = ARRAYNEW(1)>
          <CFSET SORTSEQUENCE[1] = 'ASC'>
          <CFSET SORTSEQUENCE[2] = 'DESC'>
          <CFSET SORTASCDESC = EVALUATE("SORTSEQUENCE[#FORM.SORTASCDESC#]")>
          
          <CFSET SESSION.REPORTTITLE2 = "">
          
          <CFIF #FORM.SORTCHOICE# EQ 1>
               <CFSET SESSION.REPORTTITLE2 = "Sorted by Requester, Creation Date and SR ##">
               <CFSET REPORTORDER = #REPORTORDER# & " #SORTASCDESC#, CREATIONDATE, SR.SERVICEREQUESTNUMBER">
          <CFELSEIF #FORM.SORTCHOICE# EQ 2>
               <CFSET SESSION.REPORTTITLE2 = "Sorted by SR##">
               <CFSET REPORTORDER = #REPORTORDER# & " #SORTASCDESC#">
		<CFELSEIF #FORM.SORTCHOICE# EQ 3>
               <CFSET SESSION.REPORTTITLE2 = "Sorted by SR## and Group Name">
               <CFSET REPORTORDER = #REPORTORDER# & " #SORTASCDESC#, GA.GROUPNAME">
          </CFIF>
          <!--- <BR /><BR />REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
     </CFIF>

	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATEDATE,
				TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SR.SERVICEDESKINITIALSID, SDINIT.INITIALS, SR.REQUESTERID,
				REQCUST.CUSTOMERID, REQCUST.LASTNAME, REQCUST.FIRSTNAME, REQCUST.FULLNAME, REQCUST.UNITID, SR.ALTERNATE_CONTACTID, SR.PROBLEM_CATEGORYID,
				SR.PROBLEM_SUBCATEGORYID, PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY, PROBSUBCAT.SUBCATEGORYNAME,
				SR.PRIORITYID, P.PRIORITYNAME, SR.GROUPASSIGNEDID, GA.GROUPNAME, SR.SRCOMPLETED, REQCUST.FULLNAME || ' - ' || SR.SERVICEREQUESTNUMBER AS DISPLAYSR
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, PROBLEMCATEGORIES PROBCAT,
				PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY P, GROUPASSIGNED GA
		WHERE	(SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
				SR.REQUESTERID = REQCUST.CUSTOMERID AND
				SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
				SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
				SR.PRIORITYID = P.PRIORITYID AND
				SR.GROUPASSIGNEDID = GA.GROUPID) AND (

		<CFIF FORM.SERVICEREQUESTNUMBER NEQ '#ListCurrentFiscalYear.FISCALYEAR_2DIGIT#'>
			<CFIF IsDefined('FORM.NEGATESERVICEREQUEST')>
				NOT SR.SERVICEREQUESTNUMBER = '#FORM.SERVICEREQUESTNUMBER#' #LOGICANDOR#
			<CFELSE>
				SR.SERVICEREQUESTNUMBER = '#FORM.SERVICEREQUESTNUMBER#' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SRID# GT "0">
			<CFIF IsDefined('FORM.NEGATESRID')>
				NOT SR.SRID = #val(FORM.SRID)# #LOGICANDOR#
			<CFELSE>
				SR.SRID = #val(FORM.SRID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTERID# GT 0>
				<CFIF IsDefined('FORM.NEGATEREQUESTERID')>
					NOT SR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
				<CFELSE>
					SR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
				</CFIF>
		<CFELSEIF #FORM.REQUESTERFIRSTNAME# NEQ "">
               <CFIF IsDefined('FORM.NEGATEREQUESTERFIRSTNAME')>
                    NOT REQCUST.FIRSTNAME LIKE UPPER('#FORM.REQUESTERFIRSTNAME#%') #LOGICANDOR#
               <CFELSE>
                    REQCUST.FIRSTNAME LIKE UPPER('#FORM.REQUESTERFIRSTNAME#%') #LOGICANDOR#
               </CFIF>
          <CFELSEIF #FORM.REQUESTERLASTNAME# NEQ "">
               <CFIF IsDefined('FORM.NEGATEREQUESTERLASTNAME')>
                    NOT REQCUST.LASTNAME LIKE UPPER('#FORM.REQUESTERLASTNAME#%') #LOGICANDOR#
               <CFELSE>
                    REQCUST.LASTNAME LIKE UPPER('#FORM.REQUESTERLASTNAME#%') #LOGICANDOR#
               </CFIF>
          </CFIF>

          
          <CFIF #FORM.UNITID# GT 0>
			<CFIF IsDefined("FORM.NEGATEUNITID")>
				NOT REQCUST.UNITID = #val(FORM.UNITID)# #LOGICANDOR#
			<CFELSE>
				REQCUST.UNITID = #val(FORM.UNITID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CATEGORYID# GT "0">
			<CFIF IsDefined('FORM.NEGATECATEGORYID')>
				NOT SR.PROBLEM_CATEGORYID = #val(FORM.CATEGORYID)# #LOGICANDOR#
			<CFELSE>
				SR.PROBLEM_CATEGORYID = #val(FORM.CATEGORYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SUBCATEGORYID# GT "0">
			<CFIF IsDefined('FORM.NEGATESUBCATEGORYID')>
				NOT SR.PROBLEM_SUBCATEGORYID = #val(FORM.SUBCATEGORYID)# #LOGICANDOR#
			<CFELSE>
				SR.PROBLEM_SUBCATEGORYID = #val(FORM.SUBCATEGORYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.PROBLEM_DESCRIPTION# NEQ "">
			<CFIF IsDefined('FORM.NEGATEPROBLEM_DESCRIPTION')>
				NOT SR.PROBLEM_DESCRIPTION LIKE UPPER('%#FORM.PROBLEM_DESCRIPTION#%') #LOGICANDOR#
			<CFELSE>
				SR.PROBLEM_DESCRIPTION LIKE UPPER('%#FORM.PROBLEM_DESCRIPTION#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.PRIORITYID# GT "0">
			<CFIF IsDefined('FORM.NEGATEPRIORITYID')>
				NOT SR.PRIORITYID = #val(FORM.PRIORITYID)# #LOGICANDOR#
			<CFELSE>
				SR.PRIORITYID = #val(FORM.PRIORITYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
          
		<CFIF "#FORM.CREATIONDATE#" NEQ ''>
			<CFIF IsDefined('FORM.NEGATECREATIONDATE')>
				<CFIF CREATIONDATELIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(CREATIONDATEARRAY)#>
						<CFSET FORMATCREATIONDATE =  DateFormat(#CREATIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						NOT SR.CREATIONDATE = TO_DATE('#FORMATCREATIONDATE#', 'DD-MON-YYYY') AND
					</CFLOOP>
					<CFSET FINALTEST = ">">
				<CFELSEIF CREATIONDATERANGE EQ "YES">
					NOT (SR.CREATIONDATE BETWEEN TO_DATE('#BEGINCREATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDCREATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					NOT SR.CREATIONDATE LIKE TO_DATE('#FORM.CREATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			<CFELSE>
				<CFIF CREATIONDATELIST EQ "YES">
					<CFSET ARRAYCOUNT = (ArrayLen(CREATIONDATEARRAY) - 1)>
					(
					<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
						<CFSET FORMATCREATIONDATE = DateFormat(#CREATIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						SR.CREATIONDATE = TO_DATE('#FORMATCREATIONDATE#', 'DD-MON-YYYY') OR
					</CFLOOP>
					<CFSET FORMATCREATIONDATE = DateFormat(#CREATIONDATEARRAY[ArrayLen(CREATIONDATEARRAY)]#, 'DD-MMM-YYYY')>
					SR.CREATIONDATE = TO_DATE('#FORMATCREATIONDATE#', 'DD-MON-YYYY')) OR
					<CFSET FINALTEST = "=">
				<CFELSEIF CREATIONDATERANGE EQ "YES">
						(SR.CREATIONDATE BETWEEN TO_DATE('#BEGINCREATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDCREATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					SR.CREATIONDATE LIKE TO_DATE('#FORM.CREATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>
          
		<CFIF #FORM.SRCOMPLETED# NEQ "Select">
               SR.SRCOMPLETED = '#FORM.SRCOMPLETED#' #LOGICANDOR#
          </CFIF>
          
          <CFIF IsDefined('FORM.PONUMBER') AND #FORM.PONUMBER# NEQ "">
			<CFIF IsDefined('FORM.NEGATEPONUMBER')>
				NOT SR.SERVICEREQUESTNUMBER IN (#QuotedValueList(LookupPurchReqPO.SERVICEREQUESTNUMBER)#) #LOGICANDOR#
			<CFELSE>
				SR.SERVICEREQUESTNUMBER IN (#QuotedValueList(LookupPurchReqPO.SERVICEREQUESTNUMBER)#) #LOGICANDOR#
			</CFIF>
		</CFIF>
          
          <CFIF IsDefined('FORM.TNSWONUMBER') AND #FORM.TNSWONUMBER#  NEQ "">
			<CFIF IsDefined('FORM.NEGATETNSWONUMBER')>
				NOT SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#) #LOGICANDOR#
			<CFELSE>
				SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.STAFFCUSTOMERID# GT "0" AND LookupSRStaffAssignments.RecordCount GT 0>
          	<CFIF IsDefined('FORM.NEGATESTAFFCUSTOMERID')>
               	NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.STAFFSRID)#) #LOGICANDOR#
               <CFELSE>
				SR.SRID IN (#ValueList(LookupSRStaffAssignments.STAFFSRID)#) #LOGICANDOR#
               </CFIF>
		</CFIF>
          
		<CFIF #FORM.GROUPASSIGNEDID# GT "0">
			(
			<CFIF LookupSRStaffAssignments.Recordcount GT 0>
				<CFIF IsDefined('FORM.NEGATEGROUPASSIGNEDID')>
                         NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) OR
                    <CFELSE>
                         SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) OR
                    </CFIF>
			</CFIF>
			<CFIF IsDefined('FORM.NEGATEGROUPASSIGNEDID')>
                    NOT SR.GROUPASSIGNEDID = #val(FORM.GROUPASSIGNEDID)# 
               <CFELSE>
                    SR.GROUPASSIGNEDID = #val(FORM.GROUPASSIGNEDID)#
               </CFIF>
               ) #LOGICANDOR#
		</CFIF>

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

          <CFIF #FORM.SDINITIALSID# GT "0">
			<CFIF IsDefined('FORM.NEGATESDINITIALSID')>
				NOT SR.SERVICEDESKINITIALSID = #val(FORM.SDINITIALSID)# #LOGICANDOR#
			<CFELSE>
				SR.SERVICEDESKINITIALSID = #val(FORM.SDINITIALSID)# #LOGICANDOR#
			</CFIF>
		</CFIF>


		<CFIF #FORM.STAFF_DATEASSIGNED# NEQ '' AND LookupSRStaffAssignments.RecordCount GT 0>
			<CFIF IsDefined('FORM.NEGATESTAFF_DATEASSIGNED')>
				NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
			<CFELSE>
				SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>
          
          <CFIF #FORM.STAFF_COMMENTS# NEQ "">
          	<CFIF LookupSRStaffAssignments.RecordCount GT 0>
				<CFIF IsDefined('FORM.NEGATESTAFF_COMMENTS') AND LookupSRStaffAssignments.RecordCount GT 0>
                         NOT SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
                    <CFELSE>
                         SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
                    </CFIF>
               <CFELSE>
               		SR.SRID = -1  #LOGICANDOR#
               </CFIF>
          </CFIF>

		<CFIF #FORM.STAFF_COMPLETEDSR# NEQ "Select" AND LookupSRStaffAssignments.RecordCount GT 0>
                    SR.SRID IN (#ValueList(LookupSRStaffAssignments.SRID)#) #LOGICANDOR#
          </CFIF>

				SR.SRID #FINALTEST# 0)
                    
     <CFIF (FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>
          ORDER BY	#REPORTORDER#
     <CFELSE>
          ORDER BY	SR.SERVICEREQUESTNUMBER
     </CFIF>
           
	</CFQUERY>

	<CFIF #LookupServiceRequests.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
				<!-- 
					alert("Records meeting your selection criteria were Not Found");
				--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" />
		<CFEXIT>
     <CFELSE>
     	<CFSET SESSION.SRID = #LookupServiceRequests.SRID#>
	</CFIF>
	<CFSET session.ServiceRequestRecCount = #LookupServiceRequests.RecordCount#>
	<CFIF (FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>
		<CFSET SRIDS = #ValueList(LookupServiceRequests.SRID)#>
		<CFSET temp = ArraySet(session.SRIDArray, 1, LISTLEN(SRIDS), 0)>
		<CFSET session.SRIDArray = ListToArray(SRIDS)>
		<!--- SR ID Array = #SRIDS# --->
	</CFIF>
     
     <CFIF FIND('SINGLE', #Cookie.DISPLAYTYPE#, 1) NEQ 0 AND #LookupServiceRequests.RecordCount# GT 1>
     <TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center">
               	<H1> 
               	Select An SR
                   </H1>
                </TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
     	<TR>
<CFFORM action="/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" method="POST">
		<TD align="left">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
     	<TR>
               <TH align="left"><LABEL for="SRSELECTED">Select a Requester and SR</LABEL></TH>
          </TR>
		<TR>
     
<CFFORM name="LOOKUPSR" onsubmit="return validateLookupSRReqFields();" action="/#application.type#apps/servicerequests/srstaffassigndisplay.cfm?LOOKUPSRID=FOUND" method="POST">
               <TD align="LEFT" valign="TOP">
     
                    <CFSELECT name="SRSELECTED" id="SRSELECTED" size="1" required="No" tabindex="2">
                         <OPTION value="0">Requester and SR</OPTION>
                         <CFLOOP query="LookupServiceRequests">
                              <OPTION value="#SRID#">#DISPLAYSR#</OPTION>
                         </CFLOOP>  
                    </CFSELECT>
     
                    <BR>
                    <INPUT type="image" src="/images/buttonSelectReqtrSR.jpg" value="Select Requester/SR" alt="Select Requester/SR" tabindex="3" />
     
               </TD>
</CFFORM>

		</TR>
		 <TR>
               <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
<CFFORM action="/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" method="POST">
			<TD align="left" width="33%">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" />
               </TD>
</CFFORM>
          </TR>
          <TR>
               <TD align="left"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
          </TR>
     </TABLE>
     <CFEXIT>
	</CFIF>

</CFIF>
</CFOUTPUT> 
<!--- 
*************************************************************************************
* The following code is the Display form for the SR Status Report and Display Loop. *
*************************************************************************************
 --->
 
<CFOUTPUT>
<CFIF (FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>
	<CFIF IsDefined('FORM.RETRIEVERECORD') AND #FORM.RETRIEVERECORD# EQ "PREVIOUS RECORD"> 	
         	<CFSET session.ArrayCounter = #session.ArrayCounter# - 1>
	<CFELSE>
		<CFSET session.ArrayCounter = #session.ArrayCounter# + 1>
     </CFIF>
	<CFIF session.ArrayCounter GT ARRAYLEN(session.SRIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" />
		<CFEXIT>
	</CFIF>
	<CFSET FORM.SRID = #session.SRIDArray[session.ArrayCounter]#>
<CFELSEIF IsDefined('FORM.SRSELECTED')>
	<CFSET FORM.SRID = #FORM.SRSELECTED#>
<CFELSE>
	<CFSET FORM.SRID = #SESSION.SRID#>
</CFIF>

<CFQUERY name="DisplayServiceRequests" datasource="#application.type#SERVICEREQUESTS">
	SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
			TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SR.REQUESTERID, SR.REQUESTERID,
			REQCUST.CUSTOMERID, REQCUST.FULLNAME, SR.ALTERNATE_CONTACTID, SR.PROBLEM_DESCRIPTION,
			PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY, PROBSUBCAT.SUBCATEGORYNAME,
			SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID, GA.GROUPNAME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED
	FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY, GROUPASSIGNED GA
	WHERE	SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
     		SR.REQUESTERID = REQCUST.CUSTOMERID AND
			SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
			SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
			SR.PRIORITYID = PRIORITY.PRIORITYID AND
			SR.GROUPASSIGNEDID = GA.GROUPID
</CFQUERY>

<CFQUERY name="DisplayRequesters" datasource="#application.type#LIBSHAREDDATA">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FIRSTNAME, CUST.FULLNAME, CUST.ACTIVE
	FROM		CUSTOMERS CUST
	WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#DisplayServiceRequests.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC"> AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFIF IsDefined('Cookie.STAFFLOOKUPID')>

	<CFQUERY name="LookupStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER,
				GA.GROUPNAME || ' - ' || CUST.FULLNAME AS GROUPCUSTOMER
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
		WHERE	WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#Cookie.STAFFLOOKUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
				WGA.GROUPID = GA.GROUPID
		ORDER BY	GA.GROUPNAME, CUST.FULLNAME
	</CFQUERY>

</CFIF>

<CFQUERY name="DisplaySREquipBarcode" datasource="#application.type#SERVICEREQUESTS">
	SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
	FROM		SREQUIPLOOKUP
	WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#DisplayServiceRequests.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
</CFQUERY>

<CFIF #DisplaySREquipBarcode.RecordCount# GT 0>

	<CFQUERY name="DisplayHardware" datasource="#application.type#HARDWARE">
		SELECT	HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.DIVISIONNUMBER
		FROM		HARDWAREINVENTORY HI
		WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#DisplaySREquipBarcode.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>

</CFIF>


<!--- 
***********************************************************************
* The following code generates the SR Status Report and Display Loop. *
***********************************************************************
--->

<TABLE width="100%" align="center" border="3">
	<TR align="center">
     	<TD align="center">
		<CFIF FIND('EXTRA', #Cookie.DISPLAYTYPE#, 1) NEQ 0>
               <H1>#RIGHT(Cookie.DISPLAYTYPE, 5)# SR Comments #LEFT(Cookie.DISPLAYTYPE, 6)# Report</H1>
          <CFELSEIF FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0>
               <H1>#LEFT(Cookie.DISPLAYTYPE, 4)# SR Comments Report</H1>
          <CFELSE>
               <H1>SR Comments #LEFT(Cookie.DISPLAYTYPE, 6)# Report</H1>
          </CFIF>
          <CFIF FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0>
          	<H1>#SESSION.REPORTTITLE2#</H1>
          </CFIF>
     	</TD>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" method="POST">
		<TD align="left" width="33%">
          	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
          </TD>
</CFFORM>
	</TR>
     <CFIF FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0 AND (IsDefined('Cookie.STAFFLOOKUPID') AND #Cookie.STAFFLOOKUPID# GT "0")>
	<TR>
		<TH colspan="3"><H4>#LookupStaffAssigned.FULLNAME# currently has #ArrayLen(session.SRIDArray)# Service Requests Assigned.</H4></TH>
	</TR>
	</CFIF>
     <TR>
     	<TD align="left" valign="TOP" colspan="3"><IMG src="/images/greenbar.gif" width="100%" height="6" BORDER="0" alt="Green Horizontal Line" /></TD>
	</TR>
</TABLE>

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


<CFFORM name="DISPLAYRECORD" action="/#application.type#apps/servicerequests/srstaffassigndisplay.cfm?LOOKUPSRID=FOUND" method="POST" ENABLECAB="Yes">

<CFIF (FIND('LOOP', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>
<FIELDSET>
<LEGEND>Record Selection</LEGEND>	
<TABLE width="100%" border="0">	
     <TR>
		<TD align="left" width="33%">
          	<INPUT type="hidden" name="RETRIEVERECORD" value="NEXT RECORD" />
          	<INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXT RECORD" alt="Next Record" tabindex="2" />
		</TD>
	 <CFIF #session.ArrayCounter# GT 1>
		<TD align="left" width="33%">
               <INPUT type="image" src="/images/buttonPreviousRec.jpg" value="PREVIOUS RECORD" alt="Previous Record" onClick="return setPrevRecord();" tabindex="3" />
		</TD>
     <CFELSE>
     	<TD align="left" width="33%">&nbsp;&nbsp;</TD>
     </CFIF>
		<TD align="left" width="33%">&nbsp;&nbsp;</TD>
     </TR>
</TABLE>

</FIELDSET>
</CFIF>
<BR />
<FIELDSET>
<LEGEND>Service Request</LEGEND>
<TABLE width="100%" align="LEFT">
	<TR>
		<TH align="left" width="33%"><B>SR</B></TH>
		<TH align="left" width="33%">Creation Date</TH>
		<TH align="left" width="33%">Creation Time</TH>
	</TR>
	<TR>
		<TD align="left" width="33%">#DisplayServiceRequests.SERVICEREQUESTNUMBER#</TD>
		<TD align="left" width="33%">#DateFormat(DisplayServiceRequests.CREATIONDATE, "mm/dd/yyyy")#</TD>
		<TD align="left" width="33%">#TimeFormat(DisplayServiceRequests.CREATIONTIME, "hh:mm:ss tt")#</TD>
	</TR>
	<TR>
		<TH align="left" width="33%">Requester</TH>
		<TH align="left" width="33%">Problem Category</TH>
		<TH align="left" width="33%">Sub-Category</TH>
		
	</TR>
	<TR>
		<TD align="left" width="33%">#DisplayRequesters.FULLNAME#</TD>
		<TD align="left" width="33%">#DisplayServiceRequests.PROBCATEGORY#</TD>
		<TD align="left" width="33%">#DisplayServiceRequests.SUBCATEGORYNAME#</TD>
		
	</TR>
	<TR>
		<TH align="left" width="33%">Problem Description</TH>
		<TH align="left" width="33%">Priority</TH>
		<TH align="left" width="33%">Assignments</TH>
	</TR>
	<TR>
		<TD align="left" width="33%" valign="TOP">
			#DisplayServiceRequests.PROBLEM_DESCRIPTION#
		</TD>
		<TD align="left" width="33%" valign="TOP">
			#DisplayServiceRequests.PRIORITYNAME#
		</TD>
          <TD align="left" width="33%" valign="TOP">
     
               <CFQUERY name="LookupHardwareAssigns" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                    SELECT	SRHA.SRHARDWASSIGNID, SRHA.SRID, SRHA.HWSWID, HSA.HWSW_ID, HSA.HWSW_NAME
                    FROM		SRHARDWASSIGNS SRHA, HWSW HSA
                    WHERE	SRHA.SRID = <CFQUERYPARAM value="#DisplayServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                              SUBSTR(HSA.HWSW_NAME,1,2) = 'HW' AND
                              SRHA.HWSWID = HSA.HWSW_ID
                    ORDER BY	SRHA.HWSWID
               </CFQUERY>
               
               HW: &nbsp;&nbsp;#LookupHardwareAssigns.Recordcount#<BR>
          
               <CFQUERY name="LookupSoftwareAssigns" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                    SELECT	SRSA.SRSOFTWASSIGNID, SRSA.SRID, SRSA.HWSWID, HSA.HWSW_ID, HSA.HWSW_NAME
                    FROM		SRSOFTWASSIGNS SRSA, HWSW HSA
                    WHERE	SRSA.SRID = <CFQUERYPARAM value="#DisplayServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                              SUBSTR(HSA.HWSW_NAME,1,2) = 'SW' AND
                              SRSA.HWSWID = HSA.HWSW_ID 
                    ORDER BY	SRSA.HWSWID
               </CFQUERY>
               
               SW: &nbsp;&nbsp;#LookupSoftwareAssigns.Recordcount#
 
		</TD>
	</TR>
     <TR>
               <TH align="left" width="33%">SR Completed</TH>
               <TH align="left" width="33%">SR Completed Date</TH>
               <TH align="left" width="33%">&nbsp;&nbsp;</TH>
          </TR>
          <TR>
               <TD align="left" width="33%" valign="top"><FONT color="Red"><STRONG>#DisplayServiceRequests.SRCOMPLETED#</STRONG></FONT></TD>
               <TD align="left" width="33%" valign="top">#DateFormat(DisplayServiceRequests.SRCOMPLETEDDATE, "mm/dd/yyyy")#</TD>
               <TD align="left" width="33%" valign="top">&nbsp;&nbsp;</TD>	
          </TR>	
</TABLE>
</FIELDSET>
<BR />
<CFIF IsDefined('DisplayHardware.RecordCount') AND #DisplayHardware.RecordCount# GT 0>
<FIELDSET>
<LEGEND>Associated Equipment</LEGEND>
<TABLE width="100%" align="LEFT">
	<TR>
		<TH align="left" width="33%">Bar Code Number</TH>
		<TH align="left" width="33%">State/Found Number</TH>
		<TH align="left" width="33%">Division Number</TH>
	</TR>
	<TR>
		<TD align="left" width="33%">#DisplayHardware.BARCODENUMBER#</TD>
		<TD align="left" width="33%">#DisplayHardware.STATEFOUNDNUMBER#</TD>
		<TD align="left" width="33%">#DisplayHardware.DIVISIONNUMBER#</TD>
	</TR>
</TABLE>
</FIELDSET>
<BR />
</CFIF>
<CFIF (FIND('EXTRA', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>

	<CFQUERY name="LookupPurchReqPO" datasource="#application.type#PURCHASING">
          SELECT	PURCHREQID, SERVICEREQUESTNUMBER, CREATIONDATE, PONUMBER, REQFILEDDATE, COMPLETIONDATE 
          FROM		PURCHREQS
          WHERE	SERVICEREQUESTNUMBER = '#DisplayServiceRequests.SERVICEREQUESTNUMBER#'
          ORDER BY	PONUMBER
     </CFQUERY>
     
     <CFIF LookupPurchReqPO.RecordCount GT 0>
     
          <CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
               SELECT	PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER, PRL.LINEQTY, PRL.LINEDESCRIPTION
               FROM		PURCHREQLINES PRL
               WHERE	PRL.PURCHREQID = <CFQUERYPARAM value="#LookupPurchReqPO.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> 
               ORDER BY	PRL.LINENUMBER
          </CFQUERY>

     </CFIF>
     
     <CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
          SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.STAFFID, TNSWO.CURRENT_JACKNUMBER, CURRWJ.JACKNUMBER AS CURRJACK,
                    TNSWO.NEW_JACKNUMBER, NEWWJ.JACKNUMBER AS NEWJACK, TNSWO.HW_INVENTORYID, TNSWO.WORK_DESCRIPTION, TNSWO.JUSTIFICATION_DESCRIPTION, 
                    TNSWO.OTHER_DESCRIPTION, TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER, TNSWO.EBA_111, TNSWO.NEW_LOCATION
          FROM		TNSWORKORDERS TNSWO, FACILITIESMGR.WALLJACKS CURRWJ, FACILITIESMGR.WALLJACKS NEWWJ
          WHERE	TNSWO.SRID = <CFQUERYPARAM value="#DisplayServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    TNSWO.CURRENT_JACKNUMBER = CURRWJ.WALLJACKID AND
                    TNSWO.NEW_JACKNUMBER = NEWWJ.WALLJACKID
          ORDER BY	TNSWO.WO_TYPE
     </CFQUERY>	
          
<FIELDSET>
<LEGEND>Extra</LEGEND>
<TABLE width="100%" border="0">
	<TR>
		<TD colspan="3">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TH align="left" width="33%">Parts Quantity</TH>
		<TH align="left" width="33%">Parts Requested</TH>
		<TH align="left" width="33%">Purchase Order Number</TH>
	</TR>
	<TR>
      <CFIF LookupPurchReqPO.RecordCount GT 0>
     	<TD align="left" width="33%" valign="top">
          <CFLOOP query = "LookupPurchReqLines">
			#LookupPurchReqLines.LINEQTY#<BR><BR><BR>
          </CFLOOP>
          </TD>       
		<TD align="left" width="33%" valign="top">
         	<CFLOOP query = "LookupPurchReqLines">
			#LookupPurchReqLines.LINEDESCRIPTION#<BR><BR>
          </CFLOOP>
          </TD>
          <TD align="left" width="33%" valign="top">#LookupPurchReqPO.PONUMBER#</TD>
	<CFELSE>
     	<TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</CFIF>	
	</TR>
	<TR>
		<TH align="left" width="33%">PO Creation Date</TH>
		<TH align="left" width="33%">PO Filed Date</TH>
		<TH align="left" width="33%">PO Completion Date</TH>
	</TR>
	<TR>
     <CFIF LookupPurchReqPO.RecordCount GT 0>
		<TD align="left" width="33%">#DateFormat(LookupPurchReqPO.CREATIONDATE, "mm/dd/yyyy")#</TD>
		<TD align="left" width="33%">#DateFormat(LookupPurchReqPO.REQFILEDDATE, "mm/dd/yyyy")#</TD>
		<TD align="left" width="33%">#DateFormat(LookupPurchReqPO.COMPLETIONDATE, "mm/dd/yyyy")#</TD>
     <CFELSE>
     	<TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</CFIF>	
	</TR>
	<TR>
		<TH align="left" width="33%">TNS Work Order Number</TH>
		<TH align="left" width="33%">TNS Complete Date</TH>
		<TH align="left" width="33%">&nbsp;&nbsp;</TH>
	</TR>
	<TR>
		<TD align="left" width="33%">#LookupTNSWorkOrders.WO_NUMBER#</TD>
		<CFIF LookupTNSWorkOrders.WO_DUEDATE NEQ ''>
		<TD align="left" width="33%">#DateFormat(LookupTNSWorkOrders.WO_DUEDATE, "mm/dd/yyyy")#</TD>
		<CFELSE>
		<TD align="left" width="33%">&nbsp;&nbsp;</TD>
		</CFIF>
		<TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</TR>
</TABLE>
</FIELDSET>
<BR />
</CFIF>
<CFIF NOT (#DisplayServiceRequests.SRCOMPLETED# EQ "VOIDED")>
<FIELDSET>
<LEGEND>Group/Staff Assignments</LEGEND>
     <TABLE width="100%" border="0">   
     <CFIF DisplaySRStaffAssignments.RecordCount GT 0>
          <CFSET DISPLAYGROUPNAME = "">
          <CFLOOP query = "DisplaySRStaffAssignments">
               <CFIF #DisplaySRStaffAssignments.NEXT_ASSIGNMENT# EQ "NO" AND DISPLAYGROUPNAME NEQ #DisplayServiceRequests.GROUPNAME#>
                    <CFSET DISPLAYGROUPNAME = #DisplayServiceRequests.GROUPNAME#>
               <TR>
                    <TH align="left" width="33%">Group Assigned</TH>
                    <TH align="left" width="33%">&nbsp;&nbsp;</TH>
                    <TH align="left" width="33%">&nbsp;&nbsp;</TH>
               </TR>        	
               <TR>
                    <TD align="left" width="33%"><STRONG>#DisplayServiceRequests.GROUPNAME#</STRONG></TD>
                    <TD align="left" width="33%">&nbsp;&nbsp;</TD>
                    <TD align="left" width="33%">&nbsp;&nbsp;</TD>
               </TR>
               <CFELSEIF #DisplaySRStaffAssignments.NEXT_ASSIGNMENT# EQ "YES" AND DISPLAYGROUPNAME NEQ #DisplaySRStaffAssignments.GROUPNAME#>
                    <CFSET DISPLAYGROUPNAME = #DisplaySRStaffAssignments.GROUPNAME#>
                <TR>
                    <TH align="left" width="33%">Group Assigned</TH>
                    <TH align="left" colspan="2">Referral Reason</TH>
               </TR>        	
               <TR>
                    <TD align="left" width="33%"><STRONG>#DisplaySRStaffAssignments.GROUPNAME#</STRONG></TD>
                    <TD align="left" colspan="2">#DisplaySRStaffAssignments.NEXT_ASSIGNMENT_REASON#</TD>
               </TR>
               </CFIF>
                         
               <TR>
                    <TH align="left" width="33%">Staff Assigned</TH>
                    <TH align="left" width="33%">Date Staff Assigned</TH>
                    <TH align="left" width="33%">Date Last Modified</TH>
               </TR>	
               <TR>
                    <TD align="left" width="33%" valign="top">#DisplaySRStaffAssignments.FULLNAME#</TD>
                    <TD align="left" width="33%" valign="top">#DateFormat(DisplaySRStaffAssignments.STAFF_DATEASSIGNED, "mm/dd/yyyy")#</TD>
                    <TD align="left" width="33%" valign="top">#DateFormat(DisplaySRStaffAssignments.DATE_LAST_MODIFIED, "mm/dd/yyyy")#</TD>
               </TR>
               <TR>
                    <TH align="left" width="33%">SR Completed</TH>
                    <TH align="left" width="33%">SR Completed Date</TH>
                    <TH align="left" width="33%">Staff Comments</TH>
               </TR>
               <TR>
                    <TD align="left" width="33%" valign="top">#DisplaySRStaffAssignments.STAFF_COMPLETEDSR#</TD>
                    <TD align="left" width="33%" valign="top">#DateFormat(DisplaySRStaffAssignments.STAFF_COMPLETEDDATE, "mm/dd/yyyy")#</TD>
                    <TD align="left" width="33%">
                    <CFIF #DisplaySRStaffAssignments.STAFF_COMMENTS# NEQ "">
                         #DisplaySRStaffAssignments.STAFF_COMMENTS#
                    <CFELSE>
                         &nbsp;&nbsp;
                    </CFIF>
                    </TD>	
               </TR>	
               <TR>
                    <TD colspan="3">&nbsp;&nbsp;</TD>
               </TR>
     </CFLOOP>
     <CFELSE>
               <TR>
                    <TH align="left" width="33%">Group Assigned</TH>
                    <TH align="left" width="33%">&nbsp;&nbsp;</TH>
                    <TH align="left" width="33%">&nbsp;&nbsp;</TH>
               </TR>	
               <TR>
                    <TD align="left" width="33%" valign="top"><STRONG>#DisplayServiceRequests.GROUPNAME#</STRONG></TD>
                    <TD align="left" width="33%">&nbsp;&nbsp;</TD>
                    <TD align="left" width="33%">&nbsp;&nbsp;</TD>
              </TR>	
               <TR>
                    <TH align="left" width="33%"><B>Staff Assigned</B></TH>
                    <TH align="left" width="33%"><B>Date Staff Assigned</B></TH>
                    <TH align="left" width="33%">Staff Comments</TH>
               </TR>
               <TR>        
                    <TD align="left" width="33%" valign="top"><STRONG>No Primary Staff Have Been Assigned!</STRONG></TD>
                    <TD align="left" width="33%" valign="top">N/A</TD>
                    <TD align="left" width="33%" valign="top">N/A</TD>
               </TR>
               <TR>
                    <TH align="left" width="33%">SR Completed</TH>
                    <TH align="left" width="33%">SR Completed Date</TH>
                     <TH align="left" width="33%">&nbsp;&nbsp;</TH>
              </TR>
               <TR>
                    <TD align="left" width="33%" valign="top">NO</TD>
                    <TD align="left" width="33%" valign="top">N/A</TD>
                    <TD align="left" width="33%">&nbsp;&nbsp;</TD>
              </TR>
              <TR>
                    <TD colspan="3">&nbsp;&nbsp;</TD>
              </TR>
     </CFIF>
	</TABLE>
</FIELDSET>
<BR />
</CFIF>

</CFFORM>
<TABLE width="100%" border="0">
	<TR>
     	<TD align="left" valign="TOP" colspan="3"><IMG src="/images/greenbar.gif" width="100%" height="6" BORDER="0" alt="Green Horizontal Line" /></TD>
	</TR>
</CFLOOP>
	<TR>
		<TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/srstaffassigndisplay.cfm" method="POST">
		<TD align="left" width="33%">
          	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" />
          </TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>

</CFOUTPUT>
</BODY>
</HTML>
