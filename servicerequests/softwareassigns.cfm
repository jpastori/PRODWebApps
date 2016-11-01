<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwareassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/20/2013 --->
<!--- Date in Production: 02/20/2013 --->
<!--- Module: Add/Modify/Delete Information to Service Requests - Software Assignments --->
<!-- Last modified by John R. Pastori on 05/17/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL =" pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/softwareassigns.cfm">
<CFSET CONTENT_UPDATED = "May 17, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF FIND('ADD', #URL.PROCESS#, 1) NEQ 0>
		<TITLE>Add Information to Service Requests - Software Assignments</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Service Requests - Software Assignments</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to Service Requests";
	
	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	
	function validateLookupField() {
		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length == 5 && document.LOOKUP.SRID.selectedIndex == "0") {
			alertuser ("At least one selection field must be entered or selected!");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}

		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length != 5 && document.LOOKUP.SERVICEREQUESTNUMBER.value.length != 9
		 && document.LOOKUP.SRID.selectedIndex == "0") {
			alertuser (document.LOOKUP.SERVICEREQUESTNUMBER.name +  ",  An 9 character SR Number MUST be entered for this lookup!");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}

		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length != 5 && document.LOOKUP.SRID.selectedIndex > "0") {
			alertuser ("BOTH a 9 character SR Number AND a dropdown value can NOT be entered! Choose one or the other.");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}
	}

	
	function formatBarcodeFields() {
		if (document.SOFTWAREASSIGNMENTS.HWSWID != null && document.SOFTWAREASSIGNMENTS.HWSWID.selectedIndex == "0") {
			alertuser ("An HWSW Type MUST be selected!");
			document.SOFTWAREASSIGNMENTS.HWSWID.focus();
			return false;
		}
		
		if (document.SOFTWAREASSIGNMENTS.SWIMAGE.value == "5" && document.SOFTWAREASSIGNMENTS.IMAGEID.selectedIndex == "0") {
			alertuser ("An Image Name MUST be selected!");
			document.SOFTWAREASSIGNMENTS.IMAGEID.focus();
			return false;
		}
		
		if (document.SOFTWAREASSIGNMENTS.ASSIGN_SWID.selectedIndex == "83" && document.SOFTWAREASSIGNMENTS.ASSIGN_OTHERPKGTITLE.value == "") {
			alertuser ("A Software Title MUST be entered in the Other Package Assigned Text Field!");
			document.SOFTWAREASSIGNMENTS.ASSIGN_OTHERPKGTITLE.focus();
			return false;
		}
		
		if ((document.SOFTWAREASSIGNMENTS.ASSIGN_SWID.selectedIndex > "0" || document.SOFTWAREASSIGNMENTS.ASSIGN_OTHERPKGTITLE.value != "") 
		 && (document.SOFTWAREASSIGNMENTS.ASSIGN_VERSION.value == "")) {
			alertuser ("A Software Version MUST entered!");
			document.SOFTWAREASSIGNMENTS.ASSIGN_VERSION.focus();
			return false;
		}
		
		if (document.SOFTWAREASSIGNMENTS.UNASSIGN_SWID.selectedIndex > "0" && document.SOFTWAREASSIGNMENTS.UNASSIGN_VERSION.value == "") {
			alertuser ("A Software Version MUST entered!");
			document.SOFTWAREASSIGNMENTS.UNASSIGN_VERSION.focus();
			return false;
		}
		
		if (document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.value != "3065000" && document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.value.length != 14 
		 && !(document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.value.match(/^\d{1}\s\d{4}\s\d{5}\s\d{4}/))) {
		 	alertuser ("The entered Assigned BarCode must be 14 digits with no spaces!");
			document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.focus();
			return false;
		}

		if (document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.value.length == 14) {
			var barcode = document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.value;
			document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}
		
		if ((document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.value != "3065000") && (document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.value.length != 17
		  || !(document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.value.match(/^\d{1}\s\d{4}\s\d{5}\s\d{4}/)))) {
		 	alertuser ("The entered Assigned BarCode CAN NOT format properly. It must contain 14 digits with no spaces!");
			document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE.focus();
			return false;
		}
		
		if (document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.value != "3065000" && document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.value.length != 14 
		 && !(document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.value.match(/^\d{1}\s\d{4}\s\d{5}\s\d{4}/))) {
		 	alertuser ("The entered Unassigned BarCode must be 14 digits with no spaces!");
			document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.focus();
			return false;
		}
		
		if (document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.value.length == 14) {
			var barcode = document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.value;
			document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}
		
		if ((document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.value != "3065000") && (document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.value.length != 17
		  || !(document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.value.match(/^\d{1}\s\d{4}\s\d{5}\s\d{4}/)))) {
		 	alertuser ("The entered Unassigned BarCode CAN NOT format properly. It must contain 14 digits with no spaces!");
			document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.focus();
			return false;
		}

	}
	
	
	function SetUnAssign() {
		if (document.SOFTWAREASSIGNMENTS.SAMEASSIGNUNASSIGN.checked) {
			var copyBarcode = '';
			var copyCustID = 0;
			copyBarcode = document.SOFTWAREASSIGNMENTS.ASSIGN_BARCODE;
			copyCustID = document.SOFTWAREASSIGNMENTS.ASSIGN_CUSTID;
			document.SOFTWAREASSIGNMENTS.UNASSIGN_BARCODE.value = copyBarcode.value;
			document.SOFTWAREASSIGNMENTS.UNASSIGN_CUSTID.value = copyCustID.value;
			return true;
		}

	}

	
	function setAddLoop() {
		document.SOFTWAREASSIGNMENTS.PROCESSSOFTWAREASSIGN.value = "ADDLOOP";
		return true;
	}

	
	function setModifyLoop() {
		document.SOFTWAREASSIGNMENTS.PROCESSSOFTWAREASSIGN.value = "MODIFYLOOP";
		return true;
		
	}

		
	function setDelete() {
		document.SOFTWAREASSIGNMENTS.PROCESSSOFTWAREASSIGN.value = "DELETE";
		return true;
	}

	function setDeleteLoop() {
		document.SOFTWAREASSIGNMENTS.PROCESSSOFTWAREASSIGN.value = "DELETELOOP";
		return true;
	}


	function setDeleteAll() {
		document.SOFTWAREASSIGNMENTS.PROCESSSOFTWAREASSIGN.value = "DELETEALL";
		return true;
	}

		
	function setPrevRecord() {
		document.CHOOSEREC.RETRIEVERECORD.value = "PREVIOUSRECORD";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPITEM') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SERVICEREQUESTNUMBER.focus()">
<CFELSEIF FIND('ADD', #URL.PROCESS#, 1) NEQ 0>
	<CFSET CURSORFIELD = "document.SOFTWAREASSIGNMENTS.HWSWID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SOFTWAREASSIGNMENTS.IMAGEID.focus()">     
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
****************************************************************
* The following code is for all Software Assignment Processes. *
****************************************************************
 --->

<CFQUERY name="ListHWSW" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
	SELECT	HWSW_ID, HWSW_NAME
	FROM		HWSW
	WHERE	HWSW_ID = 0 OR
			SUBSTR(HWSW_NAME,1,2) = 'SW'
	ORDER BY	HWSW_NAME
</CFQUERY>

<CFQUERY name="ListImages" datasource="#application.type#SOFTWARE" blockfactor="16">
	SELECT	IMAGEID, IMAGENAME
	FROM		IMAGES
	ORDER BY	IMAGENAME
</CFQUERY>

<CFQUERY name="ListSoftwareTitles" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
     SELECT	PSC.SUBCATEGORYID, PSC.SUBCATEGORYLETTERID, PSC.SUBCATEGORYNAME, PC.CATEGORYID
     FROM		PROBLEMSUBCATEGORIES PSC, PROBLEMCATEGORIES PC
     WHERE	PSC.SUBCATEGORYID > 0 AND
     		PSC.SUBCATEGORYLETTERID = PC.CATEGORYID AND 
               PC.CATEGORYID = 8
     ORDER BY	PSC.SUBCATEGORYNAME
</CFQUERY>

<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER, 
			CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
	WHERE	CUST.UNITID = UNITS.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<CFQUERY name="LookupModifiedBy" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, ACTIVE
	FROM		CUSTOMERS
	WHERE	CUSTOMERID = #Client.CUSTOMERID# AND
			INITIALS IS NOT NULL AND
			ACTIVE = 'YES'
	ORDER BY	FULLNAME
</CFQUERY>

<!--- 
******************************************************************************
* The following code is the ADD Process for Software Assignment Information. *
******************************************************************************
 --->

<CFIF FIND('ADD', #URL.PROCESS#, 1) NEQ 0>

	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER,
				SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
				SR.SERVICEDESKINITIALSID, SR.REQUESTERID, SR.ALTERNATE_CONTACTID,
				SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID,
				SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID,
				SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
				SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED
		FROM		SERVICEREQUESTS SR
		WHERE	SR.SRID = <CFQUERYPARAM value="#URL.SRID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	SR.SRID
	</CFQUERY>
     
     <CFQUERY name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, SRSA.NEXT_ASSIGNMENT,
				SRSA.NEXT_ASSIGNMENT_GROUPID, GA.GROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, WGA.STAFFCUSTOMERID, CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED,
				TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATE, SRSA.STAFF_TIME_WORKED,
				SRSA.STAFF_COMMENTS, SRSA.STAFF_COMPLETEDSR, SRSA.STAFF_COMPLETEDDATE, TO_CHAR(SRSA.MODIFIEDDATE, 'MM/DD/YYYY') AS DATE_LAST_MODIFIED
		FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	SRSA.SRSTAFF_ASSIGNID > 0 AND
				SRSA.SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
				SRSA.NEXT_ASSIGNMENT_GROUPID = GA.GROUPID AND
				WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
		ORDER BY	GA.GROUPNAME, CUST.FULLNAME
	</CFQUERY>
     
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add SR - Software Assignments</H1></TD>
		</TR>
	</TABLE>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(SRSOFTWASSIGNID) AS MAX_ID
		FROM		SRSOFTWASSIGNS 
	</CFQUERY>
	<CFSET FORM.SRSOFTWASSIGNID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="SRSOFTWASSIGNID" secure="NO" value="#FORM.SRSOFTWASSIGNID#">
     <CFSET FORM.HWSWDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
	<CFSET FORM.HWSWTIME = #TimeFormat(NOW(), 'HH:mm:ss')#>
     <CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'dd-mmm-yyyy HH:mm:ss')#>
     
	<CFQUERY name="AddSoftwareAssignmentsID" datasource="#application.type#SERVICEREQUESTS">
		INSERT INTO	SRSOFTWASSIGNS (SRSOFTWASSIGNID, SRID, HWSWDATE, HWSWTIME, MODIFIEDBYID, MODIFIEDDATE, CONFIRMFLAG)
		VALUES		(#val(Cookie.SRSOFTWASSIGNID)#, #val(URL.SRID)#, TO_DATE('#FORM.HWSWDATE#', 'DD-MON-YYYY'), TO_DATE('#FORM.HWSWTIME#', 'HH24:MI:SS'), 
          			 #val(LookupModifiedBy.CUSTOMERID)#, TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY HH24:MI:SS'), 'NO')
					 
	</CFQUERY>

	<CFCOOKIE name="SRID" secure="NO" value="#val(URL.SRID)#">

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER"> SR Software Assignments Key &nbsp; = &nbsp; #FORM.SRSOFTWASSIGNID#</TH>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;<BR /></TD>
		</TR>
	</TABLE>

	<CFIF IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES" AND URL.PROCESS EQ "ADD">
		<CFSET PROGRAMNAME = 'processsoftwareassigns.cfm?STAFFLOOP=YES'>
		<CFSET client.STAFFLOOP = 'YES'>
	<CFELSE>
		<CFSET PROGRAMNAME = 'processsoftwareassigns.cfm?STAFFLOOP=NO'>
		<CFSET client.STAFFLOOP = 'NO'>
	</CFIF>
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processsoftwareassigns.cfm?STAFFLOOP=YES" method="POST">
			<TD align="left" width="50%">
				<INPUT type="hidden" name="PROCESSSOFTWAREASSIGN" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    <BR /><BR />
			</TD>
</CFFORM>
		</TR>
	</TABLE>
<CFFORM name="SOFTWAREASSIGNMENTS" onsubmit="return formatBarcodeFields();" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
	<TABLE align="left" width="100%" border="0">
		<TR>
			<TH align="left">SR</TH>
               <TH align="left" valign="BOTTOM">Staff Assigned</TH>
          </TR>
          <TR>
			<TD align="left" valign="TOP">
				#LookupServiceRequests.SERVICEREQUESTNUMBER#
			</TD>
               <TD align="left" valign="top">
               	<CFLOOP query = "LookupSRStaffAssignments">
                    	#LookupSRStaffAssignments.FULLNAME#<BR>
                    </CFLOOP>
               </TD>
          </TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" colspan="2">SR Problem Description</TH>
		</TR>
		<TR>               
			<TD align="left" colspan="2" valign="TOP">
               	#LookupServiceRequests.PROBLEM_DESCRIPTION#
               </TD>
		</TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>	
			<TH align="left">HWSW Date</TH>
               <TH align="left">HWSW Time</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				#DateFormat(FORM.HWSWDATE, "mm/dd/yyyy")#
			</TD>
			<TD align="left" valign="TOP">
				#TimeFormat(FORM.HWSWTIME, "hh:mm:ss tt")#
			</TD>
          </TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left"><H4><LABEL for="HWSWID">*HWSW</LABEL></H4></TH>
			<TH align="left">
               	<INPUT type="hidden" name="SWIMAGE" value="0" />
               	<LABEL for="IMAGEID">Image</LABEL>
               </TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="HWSWID" id="HWSWID" size="1" query="ListHWSW" value="HWSW_ID" selected="0" display="HWSW_NAME" required="no" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
                    <CFSELECT name="IMAGEID" id="IMAGEID" size="1" query="ListImages" value="IMAGEID" selected="0" display="IMAGENAME" required="No" tabindex="3"></CFSELECT>
               </TD>
		</TR>
          <TR>
			<TD align="left" colspan="2"><HR></TD>
		</TR>
          <TR>
			<TH align="left"><H2>If Software Installed, Make Selections Below:</H2></TH>
               <TH align="left"><H2>If Software Removed, Make Selections Below:</H2></TH>
		</TR>
          <TR>
			<TH align="left" valign="TOP"><H4><LABEL for="ASSIGN_SWID">*SW Title Assigned</LABEL></H4></TH>
			<TH align="left" valign="TOP"><LABEL for="UNASSIGN_SWID">SW Title UnAssigned</LABEL></TH>
		</TR>
         <TR>
			<TD align="left" valign="TOP">
				<SELECT name="ASSIGN_SWID" id="ASSIGN_SWID" tabindex="4">
					<OPTION selected value="0"> Image or Select Assigned SW Title</OPTION>
					<CFLOOP query="ListSoftwareTitles">
						<OPTION value="#SUBCATEGORYID#"> #SUBCATEGORYNAME#</OPTION>
					</CFLOOP>
				</SELECT>
			</TD>
			<TD align="left" valign="TOP">
				<SELECT name="UNASSIGN_SWID" id="UNASSIGN_SWID" tabindex="5">
					<OPTION selected value="0"> Image or Select UnAssigned SW Title</OPTION>
					<CFLOOP query="ListSoftwareTitles">
						<OPTION value="#SUBCATEGORYID#"> #SUBCATEGORYNAME#</OPTION>
					</CFLOOP>
				</SELECT>
			</TD>
		</TR>
          <TR>
			<TH align="left"><H4><LABEL for="ASSIGN_OTHERPKGTITLE">*Or SW Title, if Other Package Assigned</LABEL></H4></TH>
               <TH align="left"><LABEL for="UNASSIGN_OTHERPKGTITLE">Or SW Title, if Other Package UnAssigned</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="ASSIGN_OTHERPKGTITLE" id="ASSIGN_OTHERPKGTITLE" value="" align="LEFT" required="No" size="50" maxlength="50" tabindex="6">
			</TD>
               <TD align="left" valign="TOP">
				<CFINPUT type="Text" name="UNASSIGN_OTHERPKGTITLE" id="UNASSIGN_OTHERPKGTITLE" value="" align="LEFT" required="No" size="50" maxlength="50" tabindex="7">
			</TD>
		</TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left"><H4><LABEL for="ASSIGN_VERSION">*Version Assigned</LABEL></H4></TH>
               <TH align="left"><LABEL for="UNASSIGN_VERSION">Version UnAssigned</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="ASSIGN_VERSION" id="ASSIGN_VERSION" value="" align="LEFT" required="No" size="10" maxlength="7" tabindex="8">
			</TD>
               <TD align="left" valign="TOP">
				<CFINPUT type="Text" name="UNASSIGN_VERSION" id="UNASSIGN_VERSION" value="" align="LEFT" required="No" size="10" maxlength="7" tabindex="9">
			</TD>
		</TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM"><LABEL for="ASSIGN_BARCODE">Inventory Assigned</LABEL></TH>
               <TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="ASSIGN_BARCODE" id="ASSIGN_BARCODE" value="3065000" align="LEFT" required="No" size="18" maxlength="17" tabindex="10">
			</TD>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
               <TH align="left"><LABEL for="ASSIGN_CUSTID">Customer Assigned</LABEL></TH>
               <TH align="left" valign="BOTTOM">
               	<LABEL for="SAMEASSIGNUNASSIGN"><FONT COLOR="BLUE"><STRONG>If Inventory and Customer UnAssigned is same as Assigned,</STRONG></FONT></LABEL>
               </TH>
		</TR>
          <TR>
               <TD align="left" valign="TOP">
				<CFSELECT name="ASSIGN_CUSTID" id="ASSIGN_CUSTID" size="1" query="ListRequesters" value="CUSTOMERID" selected ="0" display="FULLNAME" required="No" tabindex="11"></CFSELECT>
			</TD>
               <TH align="left" valign="BOTTOM">
               	<LABEL for="SAMEASSIGNUNASSIGN"><FONT COLOR="BLUE"><STRONG>Click CheckBox and skip same fields below:</STRONG></FONT></LABEL>
               </TH>
		</TR>
          <TR>
          	<TD>&nbsp;&nbsp;</TD>
          	<TD align="LEFT" VALIGN="TOP" valign="TOP"> 
                    <CFINPUT type="Checkbox" name="SAMEASSIGNUNASSIGN" id="SAMEASSIGNUNASSIGN" value="YES" onClick="return SetUnAssign();" tabindex="12">Same Assign/UnAssign<BR>
			</TD>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
          	<TH align="left">&nbsp;&nbsp;</TH>
               <TH align="left"><LABEL for="UNASSIGN_BARCODE">Inventory UnAssigned</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
               <TD align="left" valign="TOP">
				<CFINPUT type="Text" name="UNASSIGN_BARCODE" id="UNASSIGN_BARCODE" value="3065000" align="LEFT" required="No" size="18" maxlength="17" tabindex="13">
			</TD>
          </TR>
          <TR>
              	<TH align="left">&nbsp;&nbsp;</TH>
               <TH align="left"><LABEL for="UNASSIGN_CUSTID">Customer UnAssigned</LABEL></TH>
		</TR>
		<TR>
               <TD align="left">&nbsp;&nbsp;</TD>
               <TD align="left" valign="TOP">
				<CFSELECT name="UNASSIGN_CUSTID" id="UNASSIGN_CUSTID" size="1" query="ListRequesters" value="CUSTOMERID" selected ="0" display="FULLNAME" required="No" tabindex="14"></CFSELECT>
			</TD>
		</TR>
          <TR>
			<TD align="left" colspan="2"><HR></TD>
		</TR>
    		<TR>
			<TH align="left" COLSPAN="2"><LABEL for="TECHCOMMENTS">Additional Comments</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" COLSPAN="2">
				<CFTEXTAREA name="TECHCOMMENTS" id="TECHCOMMENTS" wrap="VIRTUAL" rows="5" cols="40" tabindex="15"></CFTEXTAREA>
			</TD>
		</TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left">Modified By</TH>
               <TH align="left">Modified Date</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
               	#LookupModifiedBy.FULLNAME#
               </TD>
               
               <TD align="left" valign="TOP">
				#DateFormat(NOW(), 'mm/dd/yyyy')#
               </TD>
		</TR>
          <TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
               	<INPUT type="hidden" name="PROCESSSOFTWAREASSIGN" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="16" />
			</TD>
			<TD align="left" valign="TOP">
                    <INPUT type="image" src="/images/buttonAddLoop.jpg" value="ADDLOOP" alt="Add Loop" OnClick="return setAddLoop();" tabindex="17" />
               </TD>
		</TR>
     </TABLE>
</CFFORM>
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processsoftwareassigns.cfm?STAFFLOOP=YES" method="POST">
			<TD align="left" valign="TOP" colspan="2">
				<INPUT type="hidden" name="PROCESSSOFTWAREASSIGN" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="18" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
	<CFEXIT>
<CFELSE>

<!--- 
*********************************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Software Assignment Information. *
*********************************************************************************************************
 --->

	<CFIF (NOT IsDefined('session.SRSOFTWASSIGNIDArray') OR NOT IsDefined('URL.LOOKUPITEM')) OR (#URL.STAFFLOOP# EQ "YES" AND IsDefined('session.SRSOFTWASSIGNIDArray') AND FIND('staffassign', #CGI.HTTP_REFERER#, 1) NEQ 0)>		
		<CFSET session.SRSOFTWASSIGNIDArray=ArrayNew(1)>
		<CFSET temp = ArraySet(session.SRSOFTWASSIGNIDArray, 1, 1, 0)>
		<CFSET session.SRSOFTWASSIGNIDCounter = 0>
		<CFSET session.ProcessArray = "NO">
          <CFSET session.STAFFLOOP = #URL.STAFFLOOP#>
	</CFIF>

	<CFIF NOT IsDefined('URL.LOOKUPITEM')>

		<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	DISTINCT SRHA.SRID
			FROM		SRSOFTWASSIGNS SRHA
               WHERE	CONFIRMFLAG = 'NO'
			ORDER BY	SRHA.SRID
		</CFQUERY>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	DISTINCT SR.SRID, CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
			FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	SR.SRID IN (#ValueList(LookupSoftwareAssignments.SRID)#) AND
					SR.REQUESTERID = CUST.CUSTOMERID 
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TD align="center"><H1>Modify SR - Software Assignments Lookup</H1></TD>
			</TR>
		</TABLE>
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>
		<BR clear="left" />
	
		<TABLE width="100%" align="LEFT" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=#URL.PROCESS#&LOOKUPITEM=FOUND&STAFFLOOP=NO" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="SERVICEREQUESTNUMBER">*SR</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFINPUT type="Text" name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" value="#ListCurrentFiscalYear.FISCALYEAR_2DIGIT#" align="LEFT" required="NO" size="9" maxlength="9" tabindex="2">
				</TD>
			</TR>
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="SRID">*Or Requester/SR</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="SRID" id="SRID" size="1" tabindex="3">
						<CFLOOP query="LookupServiceRequests">
							<OPTION value="#SRID#">#LOOKUPKEY#</OPTION>
						</CFLOOP>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" colspan="2">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
		<CFEXIT>
	<CFELSEIF session.SRSOFTWASSIGNIDArray[1] EQ 0 AND FIND('MODIFY', #URL.PROCESS#, 1) NEQ 0>

<!--- 
**********************************************************************************************
* The following code is the Modify and Delete Processes for Software Assignment Information. *
**********************************************************************************************
 --->
		<CFIF IsDefined('URL.SRID')>
			<CFSET FORM.SRID = #URL.SRID#>
		</CFIF>
          <CFIF IsDefined('URL.SRSOFTWASSIGNID')>
          	<CFCOOKIE name="SRSOFTWASSIGNID" secure="NO" value="#URL.SRSOFTWASSIGNID#">
          <CFELSE>	
			<CFCOOKIE name="SRID" secure="NO" value="#FORM.SRID#">

               <CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                    SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER
                    FROM		SERVICEREQUESTS SR
                    WHERE	SR.SRID > 0 AND
                         <CFIF IsDefined('FORM.SERVICEREQUESTNUMBER') AND Len(FORM.SERVICEREQUESTNUMBER) GT 5>
                              SR.SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#FORM.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
                         <CFELSE>
                              SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC">
                         </CFIF>
                    ORDER BY	SR.SERVICEREQUESTNUMBER
               </CFQUERY>
		</CFIF>
          
		<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SRSOFTWASSIGNID, SRID, CONFIRMFLAG
			FROM		SRSOFTWASSIGNS
			WHERE	(
               	<CFIF IsDefined('URL.SRSOFTWASSIGNID')>
                    	SRSOFTWASSIGNID = <CFQUERYPARAM value="#Cookie.SRSOFTWASSIGNID#" cfsqltype="CF_SQL_NUMERIC">) AND
                    <CFELSE>
               		SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC">) AND
                    </CFIF>
                         CONFIRMFLAG = 'NO'
			ORDER BY	SRID, SRSOFTWASSIGNID
		</CFQUERY>
		<CFIF #LookupSoftwareAssignments.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("A Software Assignment Record has NOT yet been created for this SR!");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#val(LookupServiceRequests.SRID)#" />
			<CFEXIT>
		</CFIF>

		<CFIF LookupSoftwareAssignments.RecordCount GT 1>
			<CFSET SRSOFTWASSIGNIDS = #ValueList(LookupSoftwareAssignments.SRSOFTWASSIGNID)#>
			<CFSET temp = ArraySet(session.SRSOFTWASSIGNIDArray, 1, LISTLEN(SRSOFTWASSIGNIDS), 0)>
			<CFSET session.SRSOFTWASSIGNIDArray = ListToArray(SRSOFTWASSIGNIDS)>
               SRSOFTWASSIGNIDS = #SRSOFTWASSIGNIDS#<BR><BR>
			<CFSET session.ProcessArray = "YES">
		</CFIF>
	</CFIF>
	<CFIF session.ProcessArray EQ "YES">
     	<CFIF IsDefined('FORM.RETRIEVERECORD') AND #FORM.RETRIEVERECORD# EQ "PREVIOUSRECORD">  	
			<CFSET session.SRSOFTWASSIGNIDCounter = #session.SRSOFTWASSIGNIDCounter# - 1>
          <CFELSE>
               <CFSET session.SRSOFTWASSIGNIDCounter = #session.SRSOFTWASSIGNIDCounter# + 1>
          </CFIF>
		<CFIF session.SRSOFTWASSIGNIDCounter GT ARRAYLEN(session.SRSOFTWASSIGNIDArray)>
          	<H1>All Selected Records Processed!</H1>
               <CFSET session.SRSOFTWASSIGNIDCounter = 0>
          	<CFIF session.STAFFLOOP EQ "YES">
				<SCRIPT language="JavaScript">
                         <!-- 
                              alert("All Selected Records Processed!");
                              window.close();
                         -->
                    </SCRIPT>
                    <CFEXIT>
               <CFELSE>
               	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYDELETE&STAFFLOOP=#URL.STAFFLOOP#" />
                    <CFEXIT>
               </CFIF>
		</CFIF>
		<CFSET FORM.SRSOFTWASSIGNID = #session.SRSOFTWASSIGNIDArray[session.SRSOFTWASSIGNIDCounter]#>
	<CFELSE>
		<CFSET FORM.SRSOFTWASSIGNID = #LookupSoftwareAssignments.SRSOFTWASSIGNID#>
	</CFIF>

	<CFQUERY name="GetSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SRSOFTWASSIGNID, SRID, HWSWID, HWSWDATE, HWSWTIME, IMAGEID, ASSIGN_SWID, ASSIGN_OTHERPKGTITLE, ASSIGN_VERSION, 
                    ASSIGN_INVENTID, ASSIGN_CUSTID,  UNASSIGN_SWID, UNASSIGN_OTHERPKGTITLE, UNASSIGN_VERSION, UNASSIGN_INVENTID,
                    UNASSIGN_CUSTID, TECHCOMMENTS, MODIFIEDBYID, MODIFIEDDATE, CONFIRMFLAG, CONFIRMCOMMENTS, COMFIRMEDBYID, CONFIRMEDDATE
		FROM		SRSOFTWASSIGNS
		WHERE	(SRSOFTWASSIGNID > 0 AND
				SRSOFTWASSIGNID = <CFQUERYPARAM value="#FORM.SRSOFTWASSIGNID#" cfsqltype="CF_SQL_NUMERIC">)  AND
                    (CONFIRMFLAG IS NULL OR
                    CONFIRMFLAG = 'NO')
		ORDER BY	SRSOFTWASSIGNID
	</CFQUERY>

	<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.PROBLEM_DESCRIPTION
		FROM		SERVICEREQUESTS SR
		WHERE	SR.SRID = <CFQUERYPARAM value="#GetSoftwareAssignments.SRID#" cfsqltype="CF_SQL_VARCHAR"> 
		ORDER BY	SR.SERVICEREQUESTNUMBER
	</CFQUERY>
     
     <CFQUERY name="GetSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, SRSA.NEXT_ASSIGNMENT,
				SRSA.NEXT_ASSIGNMENT_GROUPID, GA.GROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, WGA.STAFFCUSTOMERID, CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED,
				TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATE, SRSA.STAFF_TIME_WORKED
		FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	SRSA.SRSTAFF_ASSIGNID > 0 AND
				SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
				SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
				SRSA.NEXT_ASSIGNMENT_GROUPID = GA.GROUPID AND
				WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
		ORDER BY	GA.GROUPNAME, CUST.FULLNAME
	</CFQUERY>
		
	<CFQUERY name="GetHWSW" datasource="#application.type#SERVICEREQUESTS">
		SELECT	HWSW_ID, HWSW_NAME
		FROM		HWSW
		WHERE	HWSW_ID = #val(GetSoftwareAssignments.HWSWID)#
		ORDER BY	HWSW_NAME
	</CFQUERY>

	<CFIF #GetSoftwareAssignments.ASSIGN_INVENTID# GT 0>
     
          <CFQUERY name="GetAssignedInvBarcode" datasource="#application.type#HARDWARE" blockfactor="100">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPTYPEID, EQT.EQUIPMENTTYPE, HI.FISCALYEARID,
                         HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME
			FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					FACILITIESMGR.LOCATIONS LOC
			WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetSoftwareAssignments.ASSIGN_INVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND 
					HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND 
					HI.CUSTOMERID = CUST.CUSTOMERID
			ORDER BY	HI.BARCODENUMBER
          </CFQUERY>
          
          <CFSET FORM.ASSIGN_BARCODE = "#GetAssignedInvBarcode.BARCODENUMBER#">
     <CFELSE>
     	<CFSET FORM.ASSIGN_BARCODE = "3065000">
     </CFIF>
     <CFIF #GetSoftwareAssignments.UNASSIGN_INVENTID# GT 0>
          
          <CFQUERY name="GetUnAssignedInvBarcode" datasource="#application.type#HARDWARE">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER
               FROM		HARDWAREINVENTORY HI
               WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetSoftwareAssignments.UNASSIGN_INVENTID#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	BARCODENUMBER
          </CFQUERY>
     
     	<CFSET FORM.UNASSIGN_BARCODE = "#GetUnAssignedInvBarcode.BARCODENUMBER#">
     <CFELSE>
     	<CFSET FORM.UNASSIGN_BARCODE = "3065000">
     </CFIF>
          
     <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES")>
		<CFSET PROGRAMNAME = 'processsoftwareassigns.cfm?STAFFLOOP=YES'>
		<CFSET client.STAFFLOOP = 'YES'>
	<CFELSE>
		<CFSET PROGRAMNAME = 'processsoftwareassigns.cfm?STAFFLOOP=NO'>
		<CFSET client.STAFFLOOP = 'NO'>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete SR - Software Assignments</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">SR Software Assignments Key &nbsp; = &nbsp; #GetSoftwareAssignments.SRSOFTWASSIGNID#</TH>
			<CFCOOKIE name="SRSOFTWASSIGNID" secure="NO" value="#GetSoftwareAssignments.SRSOFTWASSIGNID#">
		</TR>
	</TABLE>

	<TABLE align="left" width="100%" border="0">
		<TR>
          <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") >
          	<TD align="left" colspan="2">
                    <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" /><BR />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>
		<CFELSE>
<CFFORM action="/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=#URL.PROCESS#&STAFFLOOP=#URL.STAFFLOOP#" method="POST">
			<TD align="left" colspan="2">
                    <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>
</CFFORM>
		</CFIF>
		</TR>
          <TR>
			<TD>&nbsp;&nbsp;<BR /><BR /></TD>
		</TR>
    </TABLE>

<CFFORM name="SOFTWAREASSIGNMENTS" onsubmit="return formatBarcodeFields();" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
	<TABLE align="left" width="100%" border="0">
		<TR>
			<TH align="left">SR</TH>
               <TH align="left" valign="BOTTOM">Staff Assigned</TH>
          </TR>
          <TR>
			<TD align="left" valign="TOP">
				#GetServiceRequests.SERVICEREQUESTNUMBER#
			</TD>
               <TD align="left" valign="top">
               	<CFLOOP query = "GetSRStaffAssignments">
                    	#GetSRStaffAssignments.FULLNAME#<BR>
                    </CFLOOP>
               </TD>
          </TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" colspan="2">SR Problem Description</TH>
		</TR>
		<TR>               
			<TD align="left" colspan="2" valign="TOP">
               	#GetServiceRequests.PROBLEM_DESCRIPTION#
               </TD>
		</TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>	
			<TH align="left">HWSW Date</TH>
               <TH align="left">HWSW Time</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				#DateFormat(GetSoftwareAssignments.HWSWDATE, "mm/dd/yyyy")#
			</TD>
			<TD align="left" valign="TOP">
				#TimeFormat(GetSoftwareAssignments.HWSWTIME, "hh:mm:ss tt")#
			</TD>
          </TR>
          <TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left"><H4><LABEL for="HWSWID">*HWSW</LABEL></H4></TH>
		<CFIF #GetHWSW.HWSW_ID# EQ 5>
			<TH align="left">
               	<INPUT type="hidden" name="SWIMAGE" value="5" />
               	<H4><LABEL for="IMAGEID">*Image</LABEL><H4>
               </TH>
          <CFELSE> 
			<TH align="left">
               	<INPUT type="hidden" name="SWIMAGE" value="0" />
               	<LABEL for="IMAGEID">Image</LABEL>
               </TH>
          </CFIF>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="HWSWID" id="HWSWID" size="1" query="ListHWSW" value="HWSW_ID" selected="#GetSoftwareAssignments.HWSWID#" display="HWSW_NAME" required="no" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
                    <CFSELECT name="IMAGEID" id="IMAGEID" size="1" query="ListImages" value="IMAGEID" selected="#GetSoftwareAssignments.IMAGEID#" display="IMAGENAME" required="No" tabindex="3"></CFSELECT>
               </TD>
		</TR>
          <TR>
			<TD align="left" colspan="2"><HR></TD>
		</TR>
          <TR>
			<TH align="left"><H2>If Software Installed, Make Selections Below:</H2></TH>
               <TH align="left"><H2>If Software Removed, Make Selections Below:</H2></TH>
		</TR>
          <TR>
			<TH align="left" valign="TOP"><LABEL for="ASSIGN_SWID">SW Title Assigned</LABEL></TH>
			<TH align="left" valign="TOP"><LABEL for="UNASSIGN_SWID">SW Title UnAssigned</LABEL></TH>
		</TR>

          <CFQUERY name="GetAssignedSoftwareTitles" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	PSC.SUBCATEGORYID, PSC.SUBCATEGORYNAME
               FROM		PROBLEMSUBCATEGORIES PSC
               WHERE	PSC.SUBCATEGORYID = <CFQUERYPARAM value="#GetSoftwareAssignments.ASSIGN_SWID#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	PSC.SUBCATEGORYNAME
          </CFQUERY>
          
          <CFQUERY name="GetUnAssignedSoftwareTitles" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	PSC.SUBCATEGORYID, PSC.SUBCATEGORYNAME
               FROM		PROBLEMSUBCATEGORIES PSC
               WHERE	PSC.SUBCATEGORYID = <CFQUERYPARAM value="#GetSoftwareAssignments.UNASSIGN_SWID#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	PSC.SUBCATEGORYNAME
          </CFQUERY>
          
         <TR>
			<TD align="left" valign="TOP">
				<SELECT name="ASSIGN_SWID" id="ASSIGN_SWID" tabindex="4">
                    <CFIF #GetSoftwareAssignments.ASSIGN_SWID# EQ 0>
					<OPTION selected value="0"> Image or Select Assigned SW Title</OPTION>
                    <CFELSE>
                    	<OPTION value="0"> Image or Select Assigned SW Title</OPTION> 
                         <OPTION selected value="#GetSoftwareAssignments.ASSIGN_SWID#"> #GetAssignedSoftwareTitles.SUBCATEGORYNAME#</OPTION>
                    </CFIF>
					<CFLOOP query="ListSoftwareTitles">
						<OPTION value="#SUBCATEGORYID#"> #SUBCATEGORYNAME#</OPTION>
					</CFLOOP>
				</SELECT>
			</TD>
			<TD align="left" valign="TOP">
				<SELECT name="UNASSIGN_SWID" id="UNASSIGN_SWID" tabindex="5">
                    <CFIF #GetSoftwareAssignments.UNASSIGN_SWID# EQ 0>
					<OPTION selected value="0"> Image or Select Assigned SW Title</OPTION>
                    <CFELSE>
                    	<OPTION value="0"> Image or Select Assigned SW Title</OPTION> 
                         <OPTION selected value="#GetSoftwareAssignments.UNASSIGN_SWID#"> #GetUnAssignedSoftwareTitles.SUBCATEGORYNAME#</OPTION>
                    </CFIF>
					<CFLOOP query="ListSoftwareTitles">
						<OPTION value="#SUBCATEGORYID#"> #SUBCATEGORYNAME#</OPTION>
					</CFLOOP>
				</SELECT>
			</TD>
		</TR>
          <TR>
          <CFIF #GetSoftwareAssignments.ASSIGN_SWID# EQ 83>
			<TH align="left">
               	<H4><LABEL for="ASSIGN_OTHERPKGTITLE">*Or SW Title, if Other Package Assigned</LABEL></H4>
               </TH>
          <CFELSE> 
			<TH align="left">
               	<LABEL for="ASSIGN_OTHERPKGTITLE">Or SW Title, if Other Package Assigned</LABEL>
               </TH>
          </CFIF>
               <TH align="left"><LABEL for="UNASSIGN_OTHERPKGTITLE">Or SW Title, if Other Package UnAssigned</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="ASSIGN_OTHERPKGTITLE" id="ASSIGN_OTHERPKGTITLE" value="#GetSoftwareAssignments.ASSIGN_OTHERPKGTITLE#" align="LEFT" required="No" size="50" maxlength="50" tabindex="6">
			</TD>
               <TD align="left" valign="TOP">
				<CFINPUT type="Text" name="UNASSIGN_OTHERPKGTITLE" id="UNASSIGN_OTHERPKGTITLE" value="#GetSoftwareAssignments.UNASSIGN_OTHERPKGTITLE#" align="LEFT" required="No" size="50" maxlength="50" tabindex="7">
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left"><H4><LABEL for="ASSIGN_VERSION">*Version Assigned</LABEL></H4></TH>
          <CFIF #GetSoftwareAssignments.UNASSIGN_SWID# GT 0>
           	<TH align="left">
               	<H4><LABEL for="UNASSIGN_VERSION">*Version UnAssigned</LABEL></H4>
               </TH>
          <CFELSE>
               <TH align="left">
               	<LABEL for="UNASSIGN_VERSION">Version UnAssigned</LABEL>
               </TH>
          </CFIF>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="ASSIGN_VERSION" id="ASSIGN_VERSION" value="#GetSoftwareAssignments.ASSIGN_VERSION#" align="LEFT" required="No" size="10" maxlength="7" tabindex="8">
			</TD>
               <TD align="left" valign="TOP">
				<CFINPUT type="Text" name="UNASSIGN_VERSION" id="UNASSIGN_VERSION" value="#GetSoftwareAssignments.UNASSIGN_VERSION#" align="LEFT" required="No" size="10" maxlength="7" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM"><LABEL for="ASSIGN_BARCODE">Inventory Assigned</LABEL></TH>
               <TH align="left"><LABEL for="UNASSIGN_BARCODE">Inventory UnAssigned</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="ASSIGN_BARCODE" id="ASSIGN_BARCODE" value="#FORM.ASSIGN_BARCODE#" align="LEFT" required="No" size="18" maxlength="17" tabindex="10">
			</TD>
               <TD align="left" valign="TOP">
				<CFINPUT type="Text" name="UNASSIGN_BARCODE" id="UNASSIGN_BARCODE" value="#FORM.UNASSIGN_BARCODE#" align="LEFT" required="No" size="18" maxlength="17" tabindex="11">
			</TD>
		</TR>
		<TR>
               <TH align="left"><LABEL for="ASSIGN_CUSTID">Customer Assigned</LABEL></TH>
               <TH align="left"><LABEL for="UNASSIGN_CUSTID">Customer UnAssigned</LABEL></TH>
		</TR>
		<TR>
               <TD align="left" valign="TOP">
				<CFSELECT name="ASSIGN_CUSTID" id="ASSIGN_CUSTID" size="1" query="ListRequesters" value="CUSTOMERID" selected ="#GetSoftwareAssignments.ASSIGN_CUSTID#" display="FULLNAME" required="No" tabindex="12"></CFSELECT>
			</TD>
               <TD align="left" valign="TOP">
				<CFSELECT name="UNASSIGN_CUSTID" id="UNASSIGN_CUSTID" size="1" query="ListRequesters" value="CUSTOMERID" selected ="#GetSoftwareAssignments.UNASSIGN_CUSTID#" display="FULLNAME" required="No" tabindex="13"></CFSELECT>
			</TD>
		</TR>
          <TR>
			<TD align="left" colspan="2"><HR></TD>
		</TR>
    		<TR>
			<TH align="left" COLSPAN="2"><LABEL for="TECHCOMMENTS">Additional Comments</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" COLSPAN="2">
				<CFTEXTAREA name="TECHCOMMENTS" id="TECHCOMMENTS" wrap="VIRTUAL" rows="5" cols="40" tabindex="14">#GetSoftwareAssignments.TECHCOMMENTS#</CFTEXTAREA>
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left">Modified By</TH>
               <TH align="left">Modified Date</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
               	<INPUT type="hidden" name="MODIFIEDBYID" value="#LookupModifiedBy.CUSTOMERID#" />
               	#LookupModifiedBy.FULLNAME#
               </TD>
               
               <TD align="left" valign="TOP">
               	<INPUT type="hidden" name="MODIFIEDDATE" value="#DateFormat(NOW(), 'dd-mmm-yyyy')#" />
				#DateFormat(NOW(), 'mm/dd/yyyy')#
               </TD>
		</TR>
          <TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
               <TD align="left" valign="TOP">
                    <INPUT type="hidden" name="PROCESSSOFTWAREASSIGN" value="MODIFY" />
                    <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="15" />
               </TD>
          	<CFIF session.ProcessArray EQ "YES">
			<TD align="left">
                    <INPUT type="image" src="/images/buttonModifyLoop.jpg" value="MODIFYLOOP" alt="Modify Loop" OnClick="return setModifyLoop();" tabindex="16" />
               </TD>
          	</CFIF>
		</TR>

		<CFIF #Client.DeleteFlag# EQ "Yes">
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
               <TD align="left" valign="TOP">
                    <INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="17" />
               </TD>
          	<CFIF session.ProcessArray EQ "YES">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonDEL-Loop.jpg" value="DELETELOOP" alt="Delete Loop Software Assignment" OnClick="return setDeleteLoop();" tabindex="18" /><BR>
                    <INPUT type="image" src="/images/buttonDEL-All.jpg" value="DELETEALL" alt="Delete All Software Assignments for SR" OnClick="return setDeleteAll();" tabindex="19" />
               </TD>
           	</CFIF>
		</TR>
          </CFIF>
	</TABLE>


</CFFORM>

	<CFIF session.ProcessArray EQ "YES">

<CFFORM name="CHOOSEREC" action="/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=#URL.PROCESS#&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#" method="POST">

	<TABLE align="left" width="100%" border="0">
          <TR>
               <TD align="left" width="33%">
                    <INPUT type="hidden" name="RETRIEVERECORD" value="NEXTRECORD" />
                    <INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXTRECORD" alt="Next Record" tabindex="20" />
               </TD>
           <CFIF #session.SRSOFTWASSIGNIDCounter# GT 1>
               <TD align="left" width="33%">
                    <INPUT type="image" src="/images/buttonPreviousRec.jpg" value="PREVIOUSRECORD" alt="Previous Record" OnClick="return setPrevRecord();" tabindex="21" />
               </TD>
          <CFELSE>
               <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          </CFIF>
          </TR>
     </TABLE>

</CFFORM>

	</CFIF>

	<TABLE align="left" width="100%" border="0">
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
          <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ 'YES')>
          	<TD align="left" colspan="2">
                    <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="22" /><BR />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>
		<CFELSE>
<CFFORM action="/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=#URL.PROCESS#&STAFFLOOP=#URL.STAFFLOOP#" method="POST">
			<TD align="left" colspan="2">
                    <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="23" /><BR />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>
</CFFORM>
		</CFIF>
		</TR>
		<TR>
			<TD align="CENTER" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>