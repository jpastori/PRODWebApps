<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hardwareassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/21/2013 --->
<!--- Date in Production: 02/21/2013 --->
<!--- Module: Add/Modify/Delete Information to Service Requests - Hardware Assignments --->
<!-- Last modified by John R. Pastori on 08/08/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL =" pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/hardwareassigns.cfm">
<CFSET CONTENT_UPDATED = "August 08, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF FIND('ADD', #URL.PROCESS#, 1) NEQ 0>
		<TITLE>Add Information to Service Requests - Hardware Assignments</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Service Requests - Hardware Assignments</TITLE>
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

	
	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
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
		if (document.HARDWAREASSIGNMENTS.HWSWID != null && document.HARDWAREASSIGNMENTS.HWSWID.selectedIndex == "0") {
			alertuser ("An HWSW Type MUST be selected!");
			document.HARDWAREASSIGNMENTS.HWSWID.focus();
			return false;
		}
		
		if (document.HARDWAREASSIGNMENTS.HWIMAGE.value == "1" && document.HARDWAREASSIGNMENTS.IMAGEID.selectedIndex == "0") {
			alertuser ("An Image Name MUST be selected!");
			document.HARDWAREASSIGNMENTS.IMAGEID.focus();
			return false;
		}
		
		if (document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.value != "3065000" && document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.value.length != 14 
		 && !(document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.value.match(/^\d{1}\s\d{4}\s\d{5}\s\d{4}/))) {
		 	alertuser ("The entered Installed BarCode must be 14 digits with no spaces!");
			document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.focus();
			return false;
		}
	
		if (document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.value.length == 14) {
			var barcode = document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.value;
			document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}
		
		if ((document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.value != "3065000") && (document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.value.length != 17
		  || !(document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.value.match(/^\d{1}\s\d{4}\s\d{5}\s\d{4}/)))) {
		 	alertuser ("The entered Installed BarCode CAN NOT format properly. It must contain 14 digits with no spaces!");
			document.HARDWAREASSIGNMENTS.INSTALLEDBARCODE.focus();
			return false;
		}
		
		if (document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.value != "3065000" && document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.value.length != 14 
		 && !(document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.value.match(/^\d{1}\s\d{4}\s\d{5}\s\d{4}/))) {
		 	alertuser ("The entered Returned BarCode must be 14 digits with no spaces!");
			document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.focus();
			return false;
		}
		
		if (document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.value.length == 14) {
			var barcode = document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.value;
			document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}
		
		if ((document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.value != "3065000") && (document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.value.length != 17
		  || !(document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.value.match(/^\d{1}\s\d{4}\s\d{5}\s\d{4}/)))) {
		 	alertuser ("The entered Returned BarCode CAN NOT format properly. It must contain 14 digits with no spaces!");
			document.HARDWAREASSIGNMENTS.RETURNEDBARCODE.focus();
			return false;
		}

	}
	
	
	function setAddLoop() {
		document.HARDWAREASSIGNMENTS.PROCESSHARDWAREASSIGN.value = "ADDLOOP";
		return true;
	}

	
	function setModifyLoop() {
		document.HARDWAREASSIGNMENTS.PROCESSHARDWAREASSIGN.value = "MODIFYLOOP";
		return true;
		
	}

		
	function setDelete() {
		document.HARDWAREASSIGNMENTS.PROCESSHARDWAREASSIGN.value = "DELETE";
		return true;
	}


	function setDeleteLoop() {
		document.HARDWAREASSIGNMENTS.PROCESSHARDWAREASSIGN.value = "DELETELOOP";
		return true;
	}

	
	function setDeleteAll() {
		document.HARDWAREASSIGNMENTS.PROCESSHARDWAREASSIGN.value = "DELETEALL";
		return true;
	}

	
	function setPrevRecord() {
		document.CHOOSEREC.RETRIEVERECORD.value = "PREVIOUSRECORD";
		return true;
	}

//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPITEM') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SERVICEREQUESTNUMBER.focus()">
<CFELSEIF FIND('ADD', #URL.PROCESS#, 1) NEQ 0>
	<CFSET CURSORFIELD = "document.HARDWAREASSIGNMENTS.HWSWID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.HARDWAREASSIGNMENTS.IMAGEID.focus()">     
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
****************************************************************
* The following code is for all Hardware Assignment Processes. *
****************************************************************
 --->

<CFQUERY name="ListHWSW" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
	SELECT	HWSW_ID, HWSW_NAME
	FROM		HWSW
	WHERE	HWSW_ID = 0 OR
			SUBSTR(HWSW_NAME,1,2) = 'HW'
	ORDER BY	HWSW_NAME
</CFQUERY>

<CFQUERY name="ListImages" datasource="#application.type#SOFTWARE" blockfactor="16">
	SELECT	IMAGEID, IMAGENAME
	FROM		IMAGES
	ORDER BY	IMAGENAME
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

<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOCATIONID, ROOMNUMBER, LOCATIONNAME
	FROM		LOCATIONS
	ORDER BY	ROOMNUMBER
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
* The following code is the ADD Process for Hardware Assignment Information. *
******************************************************************************
 --->

<CFIF FIND('ADD', #URL.PROCESS#, 1) NEQ 0>

	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
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
     
     <CFQUERY name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
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
			<TD align="center"><H1>Add SR - Hardware Assignments</H1></TD>
		</TR>
	</TABLE>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(SRHARDWASSIGNID) AS MAX_ID
		FROM		SRHARDWASSIGNS 
	</CFQUERY>
	<CFSET FORM.SRHARDWASSIGNID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="SRHARDWASSIGNID" secure="NO" value="#FORM.SRHARDWASSIGNID#">
     <CFSET FORM.HWSWDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
	<CFSET FORM.HWSWTIME = #TimeFormat(NOW(), 'HH:mm:ss')#>
     <CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'dd-mmm-yyyy HH:mm:ss')#>
     
	<CFQUERY name="AddHardwareAssignmentsID" datasource="#application.type#SERVICEREQUESTS">
		INSERT INTO	SRHARDWASSIGNS (SRHARDWASSIGNID, SRID, HWSWDATE, HWSWTIME, SALVAGEFLAG, MODIFIEDBYID, MODIFIEDDATE, CONFIRMFLAG)
		VALUES		(#val(Cookie.SRHARDWASSIGNID)#, #val(URL.SRID)#, TO_DATE('#FORM.HWSWDATE#', 'DD-MON-YYYY'), TO_DATE('#FORM.HWSWTIME#', 'HH24:MI:SS'), 
          			 'NO', #val(LookupModifiedBy.CUSTOMERID)#, TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY HH24:MI:SS'), 'NO')
					 
	</CFQUERY>

	<CFCOOKIE name="SRID" secure="NO" value="#val(URL.SRID)#">

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER"> SR Hardware Assignments Key &nbsp; = &nbsp; #FORM.SRHARDWASSIGNID#</TH>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;<BR /></TD>
		</TR>
	</TABLE>

	<CFIF IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES" AND URL.PROCESS EQ "ADD">
		<CFSET PROGRAMNAME = 'processhardwareassigns.cfm?STAFFLOOP=YES'>
		<CFSET client.STAFFLOOP = 'YES'>
	<CFELSE>
		<CFSET PROGRAMNAME = 'processhardwareassigns.cfm?STAFFLOOP=NO'>
		<CFSET client.STAFFLOOP = 'NO'>
	</CFIF>
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processhardwareassigns.cfm?STAFFLOOP=YES" method="POST">
			<TD align="left" width="50%">
				<INPUT type="hidden" name="PROCESSHARDWAREASSIGN" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    <BR /><BR />
			</TD>
</CFFORM>
		</TR>
	</TABLE>
<CFFORM name="HARDWAREASSIGNMENTS" onsubmit="return formatBarcodeFields();" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
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
			<TH align="left" colspan="2">Bar Code Number, Equipment Type, Division Number, Room Number, Customer Assignment</TH>
		</TR>
		<TR>
          <CFQUERY name="LookupSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
               SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
               FROM		SREQUIPLOOKUP
               WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#LookupServiceRequests.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
          </CFQUERY>
          
          <CFIF LookupSREquipLookup.RecordCount GT 0>
     
               <CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE">
                    SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
                    		HI.OWNINGORGID, HI.CLUSTERNAME, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, LOC.LOCATIONID, LOC.ROOMNUMBER, 
                              HI.MACADDRESS, HI.EQUIPMENTTYPEID, ET.EQUIPTYPEID, ET.EQUIPMENTTYPE, HI.DESCRIPTIONID, HI.MODELNAMEID, 
                              HI.MODELNUMBERID, HI.SPEEDNAMEID, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE, HI.REQUISITIONNUMBER,
                              HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, HI.FISCALYEARID, HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME,
                              HI.COMMENTS, HI.MODIFIEDBYID, HI.DATECHECKED, ET.EQUIPMENTTYPE ||' - ' || HI.BARCODENUMBER AS DISPLAYKEY
                    FROM		HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS CUST, EQUIPMENTTYPE ET 
                    WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#LookupSREquipLookup.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
                              HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
                              HI.CUSTOMERID = CUST.CUSTOMERID AND
                              HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID
                    ORDER BY	BARCODENUMBER
               </CFQUERY>
               
			<TD align="left" colspan="2">
               	#LookupHardware.BARCODENUMBER#, #LookupHardware.EQUIPMENTTYPE#, #LookupHardware.DIVISIONNUMBER#,
                    #LookupHardware.ROOMNUMBER#,  #LookupHardware.FULLNAME#
               </TD>
           <CFELSE>
               <TD align="left" colspan="2">
               	<STRONG>No Equipment was selected for this SR.</STRONG>
               </TD>
          </CFIF>	
		</TR>
		<TR>	
			<TH align="left">HWSW Date</TH>
               <TH align="left">HWSW Time</TH>
		</TR>
		<TR>
			<TD align="left">
				#DateFormat(FORM.HWSWDATE, "mm/dd/yyyy")#
			</TD>
			<TD align="left">
				#TimeFormat(FORM.HWSWTIME, "hh:mm:ss tt")#
			</TD>
          </TR>
          <TR>
			<TH align="left"><H4><LABEL for="HWSWID">*HWSW</LABEL></H4></TH>
			<TH align="left">
               	<INPUT type="hidden" name="HWIMAGE" value="0" />
               	 &nbsp;&nbsp;
               </TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="HWSWID" id="HWSWID" size="1" query="ListHWSW" value="HWSW_ID" selected="0" display="HWSW_NAME" required="no" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">
               	<INPUT type="hidden" name="IMAGEID" value="0" />
                    &nbsp;&nbsp;
               </TD>
		</TR>
          <TR>
			<TD align="left" colspan="2"><HR></TD>
		</TR>
          <TR>
			<TH align="left"><H2>If Inventory Installed, Make Selections Below:</H2></TH>
               <TH align="left"><H2>If Inventory Swapped, Make Selections Below:</H2></TH>
		</TR>
		<TR>
			<TH align="left"><LABEL for="INSTALLEDBARCODE">Installed Inventory</LABEL></TH>
               <TH align="left"><LABEL for="RETURNEDBARCODE">Returning Inventory</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="INSTALLEDBARCODE" id="INSTALLEDBARCODE" value="3065000" align="LEFT" required="No" size="18" maxlength="17" tabindex="4">
			</TD>
               <TD align="left">
				<CFINPUT type="Text" name="RETURNEDBARCODE" id="RETURNEDBARCODE" value="3065000" align="LEFT" required="No" size="18" maxlength="17" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="INSTALLLOCID">Installed Location</LABEL></TH>
               <TH align="left"><LABEL for="RETURNLOCID">Returning Location (I.E. LL-402)</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="INSTALLLOCID" id="INSTALLLOCID" size="1" query="ListRoomNumbers" value="LOCATIONID" selected ="0" display="ROOMNUMBER" required="No" tabindex="6"></CFSELECT>
			</TD>
               <TD align="left">
				<CFSELECT name="RETURNLOCID" id="RETURNLOCID" size="1" query="ListRoomNumbers" value="LOCATIONID" selected ="341" display="ROOMNUMBER" required="No" tabindex="7"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="INSTALLCUSTID">Installed Customer</LABEL></TH>
               <TH align="left"><LABEL for="RETURNCUSTID">Returning Customer (I.E. HARDWARE INVENTORY)</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="INSTALLCUSTID" id="INSTALLCUSTID" size="1" query="ListRequesters" value="CUSTOMERID" selected ="0" display="FULLNAME" required="No" tabindex="8"></CFSELECT>
			</TD>
               <TD align="left">
				<CFSELECT name="RETURNCUSTID" id="RETURNCUSTID" size="1" query="ListRequesters" value="CUSTOMERID" selected ="111" display="FULLNAME" required="No" tabindex="9"></CFSELECT>
			</TD>
		</TR>
          <TR>
			<TD align="left" colspan="2"><HR></TD>
		</TR>
    		<TR>
			<TH align="left"><LABEL for="TECHCOMMENTS">Additional Comments</LABEL></TH>
               <TH align="left"><LABEL for="SALVAGEFLAG">Salvage Bound</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFTEXTAREA name="TECHCOMMENTS" id="TECHCOMMENTS" wrap="VIRTUAL" rows="5" cols="40" tabindex="10"></CFTEXTAREA>
			</TD>
               <TD align="left" valign="TOP">
                    <CFSELECT name="SALVAGEFLAG" id="SALVAGEFLAG" size="1" tabindex="11">
                         <OPTION selected value="NO">NO</OPTION>
                         <OPTION value="YES">YES</OPTION>
                    </CFSELECT>
			</TD>
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
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSHARDWAREASSIGN" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="12" />
			</TD>
			<TD align="left">
                    <INPUT type="image" src="/images/buttonAddLoop.jpg" value="ADDLOOP" alt="Add Loop" onClick="return setAddLoop();" tabindex="13" />
               </TD>
		</TR>
     </TABLE>
</CFFORM>
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processhardwareassigns.cfm?STAFFLOOP=YES" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSHARDWAREASSIGN" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="14" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Hardware Assignment Information. *
*********************************************************************************************************
 --->

	<CFIF (NOT IsDefined('session.SRHARDWASSIGNIDArray') OR NOT IsDefined('URL.LOOKUPITEM')) OR (#URL.STAFFLOOP# EQ "YES" AND IsDefined('session.SRHARDWASSIGNIDArray') AND FIND('staffassign', #CGI.HTTP_REFERER#, 1) NEQ 0)>		
		<CFSET session.SRHARDWASSIGNIDArray=ArrayNew(1)>
		<CFSET temp = ArraySet(session.SRHARDWASSIGNIDArray, 1, 1, 0)>
		<CFSET session.SRHARDWASSIGNIDCounter = 0>
		<CFSET session.ProcessArray = "NO">
          <CFIF (NOT IsDefined('session.STAFFLOOP'))> 
          	<CFSET session.STAFFLOOP = #URL.STAFFLOOP#>
          <CFELSE>
          	<CFSET session.STAFFLOOP = #URL.STAFFLOOP#>
          </CFIF>
	</CFIF>

	<CFIF NOT IsDefined('URL.LOOKUPITEM')>

		<CFQUERY name="LookupHardwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	DISTINCT SRHA.SRID
			FROM		SRHARDWASSIGNS SRHA
               WHERE	CONFIRMFLAG = 'NO'
			ORDER BY	SRHA.SRID
		</CFQUERY>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	DISTINCT SR.SRID, CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
			FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SR.SRID = 0 OR
               		SR.SRID IN (#ValueList(LookupHardwareAssignments.SRID)#)) AND
					(SR.REQUESTERID = CUST.CUSTOMERID) 
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TD align="center"><H1>Modify SR - Hardware Assignments Lookup</H1></TD>
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=#URL.PROCESS#&LOOKUPITEM=FOUND&STAFFLOOP=NO" method="POST">
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
	<CFELSEIF session.SRHARDWASSIGNIDArray[1] EQ 0 AND FIND('MODIFY', #URL.PROCESS#, 1) NEQ 0>

<!--- 
**********************************************************************************************
* The following code is the Modify and Delete Processes for Hardware Assignment Information. *
**********************************************************************************************
 --->
		<CFIF IsDefined('URL.SRID')>
			<CFSET FORM.SRID = #URL.SRID#>
		</CFIF>
          <CFIF IsDefined('URL.SRHARDWASSIGNID')>
          	<CFCOOKIE name="SRHARDWASSIGNID" secure="NO" value="#URL.SRHARDWASSIGNID#">
          <CFELSE>	
			<CFCOOKIE name="SRID" secure="NO" value="#FORM.SRID#">

               <CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
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
          
		<CFQUERY name="LookupHardwareAssignments" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SRHARDWASSIGNID, SRID, HWSWID, HWSWDATE, HWSWTIME, IMAGEID, INSTALLINVENTID, INSTALLLOCID, INSTALLCUSTID, 
					RETURNINVENTID, RETURNLOCID, RETURNCUSTID, SALVAGEFLAG, MACHINENAME, MACADDRESS, IPADDRESS, TECHCOMMENTS, 
					MODIFIEDBYID, MODIFIEDDATE, CONFIRMFLAG, CONFIRMCOMMENTS, COMFIRMEDBYID, CONFIRMEDDATE
			FROM		SRHARDWASSIGNS
			WHERE	(
               	<CFIF IsDefined('URL.SRHARDWASSIGNID')>
                    	SRHARDWASSIGNID = <CFQUERYPARAM value="#Cookie.SRHARDWASSIGNID#" cfsqltype="CF_SQL_NUMERIC">) AND
                    <CFELSE>
               		SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC">) AND
                    </CFIF>
                         CONFIRMFLAG = 'NO'
			ORDER BY	SRHARDWASSIGNID
		</CFQUERY>
		<CFIF #LookupHardwareAssignments.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("A Hardware Assignment Record has NOT yet been created for this SR!");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#val(LookupServiceRequests.SRID)#" />
			<CFEXIT>
		</CFIF>

		<CFIF LookupHardwareAssignments.RecordCount GT 1>
			<CFSET SRHARDWASSIGNIDS = #ValueList(LookupHardwareAssignments.SRHARDWASSIGNID)#>
			<CFSET temp = ArraySet(session.SRHARDWASSIGNIDArray, 1, LISTLEN(SRHARDWASSIGNIDS), 0)>
			<CFSET session.SRHARDWASSIGNIDArray = ListToArray(SRHARDWASSIGNIDS)>
               SRHARDWASSIGNIDS = #SRHARDWASSIGNIDS#<BR><BR>
			<CFSET session.ProcessArray = "YES">
		</CFIF>
	</CFIF>
	<CFIF session.ProcessArray EQ "YES">
     	<CFIF IsDefined('FORM.RETRIEVERECORD') AND #FORM.RETRIEVERECORD# EQ "PREVIOUSRECORD">  	
			<CFSET session.SRHARDWASSIGNIDCounter = #session.SRHARDWASSIGNIDCounter# - 1>
          <CFELSE>
               <CFSET session.SRHARDWASSIGNIDCounter = #session.SRHARDWASSIGNIDCounter# + 1>
          </CFIF>
		<CFIF session.SRHARDWASSIGNIDCounter GT ARRAYLEN(session.SRHARDWASSIGNIDArray)>
          	<H1>All Selected Records Processed!</H1>
               <CFSET session.SRHARDWASSIGNIDCounter = 0>
          	<CFIF session.STAFFLOOP EQ "YES">
				<SCRIPT language="JavaScript">
                         <!-- 
                              alert("All Selected Records Processed!");
                              window.close();
                         -->
                    </SCRIPT>
                    <CFEXIT>
               <CFELSE>
               	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYDELETE&STAFFLOOP=#URL.STAFFLOOP#" />
                    <CFEXIT>
               </CFIF>
		</CFIF>
		<CFSET FORM.SRHARDWASSIGNID = #session.SRHARDWASSIGNIDArray[session.SRHARDWASSIGNIDCounter]#>
	<CFELSE>
    		<CFSET FORM.SRHARDWASSIGNID = #LookupHardwareAssignments.SRHARDWASSIGNID#>
	</CFIF>

	<CFQUERY name="GetHardwareAssignments" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRHARDWASSIGNID, SRID, HWSWID, HWSWDATE, HWSWTIME, IMAGEID, INSTALLINVENTID, INSTALLLOCID, INSTALLCUSTID, 
				RETURNINVENTID, RETURNLOCID, RETURNCUSTID, SALVAGEFLAG, MACHINENAME, MACADDRESS, IPADDRESS, TECHCOMMENTS, 
				MODIFIEDBYID, MODIFIEDDATE, CONFIRMFLAG, CONFIRMCOMMENTS, COMFIRMEDBYID, CONFIRMEDDATE
		FROM		SRHARDWASSIGNS
		WHERE	(SRHARDWASSIGNID > 0 AND
				SRHARDWASSIGNID = <CFQUERYPARAM value="#FORM.SRHARDWASSIGNID#" cfsqltype="CF_SQL_NUMERIC">)  AND
                    (CONFIRMFLAG IS NULL OR
                    CONFIRMFLAG = 'NO')
		ORDER BY	SRHARDWASSIGNID
	</CFQUERY>

	<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER
		FROM		SERVICEREQUESTS SR
		WHERE	SR.SRID = <CFQUERYPARAM value="#GetHardwareAssignments.SRID#" cfsqltype="CF_SQL_VARCHAR"> 
		ORDER BY	SR.SERVICEREQUESTNUMBER
	</CFQUERY>
     
     <CFQUERY name="GetSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, SRSA.NEXT_ASSIGNMENT,
				SRSA.NEXT_ASSIGNMENT_GROUPID, GA.GROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, WGA.STAFFCUSTOMERID, CUST.FULLNAME, 		
                    SRSA.STAFF_DATEASSIGNED, TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATE, SRSA.STAFF_TIME_WORKED
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
		WHERE	HWSW_ID = #val(GetHardwareAssignments.HWSWID)#
		ORDER BY	HWSW_NAME
	</CFQUERY>

	<CFIF #GetHardwareAssignments.INSTALLINVENTID# GT 0>
     
          <CFQUERY name="GetInstalledInvBarcode" datasource="#application.type#HARDWARE">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, LOC.LOCATIONID, LOC.LOCATIONNAME,
               		HI.MACADDRESS, HI.IPADDRESS, HI.EQUIPMENTTYPEID, EQT.EQUIPTYPEID, EQT.EQUIPMENTTYPE, HI.FISCALYEARID,
                         HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, HI.COMMENTS, HI.MODIFIEDBYID, HI.DATECHECKED
			FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					FACILITIESMGR.LOCATIONS LOC
			WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetHardwareAssignments.INSTALLINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND 
					HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND 
					HI.CUSTOMERID = CUST.CUSTOMERID AND
					CUST.LOCATIONID = LOC.LOCATIONID
			ORDER BY	HI.BARCODENUMBER
          </CFQUERY>
          
          <CFSET FORM.INSTALLEDBARCODE = "#GetInstalledInvBarcode.BARCODENUMBER#">
     <CFELSE>
     	<CFSET FORM.INSTALLEDBARCODE = "3065000">
     </CFIF>
     <CFIF #GetHardwareAssignments.RETURNINVENTID# GT 0>
          
          <CFQUERY name="GetReturnedInvBarcode" datasource="#application.type#HARDWARE">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER
               FROM		HARDWAREINVENTORY HI
               WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetHardwareAssignments.RETURNINVENTID#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	BARCODENUMBER
          </CFQUERY>
     
     	<CFSET FORM.RETURNEDBARCODE = "#GetReturnedInvBarcode.BARCODENUMBER#">
     <CFELSE>
     	<CFSET FORM.RETURNEDBARCODE = "3065000">
     </CFIF>
          
     <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES")>
		<CFSET PROGRAMNAME = 'processhardwareassigns.cfm?STAFFLOOP=YES'>
		<CFSET client.STAFFLOOP = 'YES'>
	<CFELSE>
		<CFSET PROGRAMNAME = 'processhardwareassigns.cfm?STAFFLOOP=NO'>
		<CFSET client.STAFFLOOP = 'NO'>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete SR - Hardware Assignments</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">SR Hardware Assignments Key &nbsp; = &nbsp; #GetHardwareAssignments.SRHARDWASSIGNID#</TH>
			<CFCOOKIE name="SRHARDWASSIGNID" secure="NO" value="#GetHardwareAssignments.SRHARDWASSIGNID#">
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
<CFFORM action="/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=#URL.PROCESS#&STAFFLOOP=#URL.STAFFLOOP#" method="POST">
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

<CFFORM name="HARDWAREASSIGNMENTS" onsubmit="return formatBarcodeFields();" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
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
			<TH align="left" colspan="2">Bar Code Number, Equipment Type, Division Number, Room Number, Customer Assignment</TH>
		</TR>
		<TR>
          <CFQUERY name="GetSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
               SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
               FROM		SREQUIPLOOKUP
               WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#GetServiceRequests.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
          </CFQUERY>
     
          <CFIF GetSREquipLookup.RecordCount GT 0>
     
               <CFQUERY name="GetHardware" datasource="#application.type#HARDWARE">
                    SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
                    		HI.OWNINGORGID, HI.CLUSTERNAME, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, LOC.LOCATIONID, LOC.ROOMNUMBER, 
                              HI.MACADDRESS, HI.EQUIPMENTTYPEID, ET.EQUIPTYPEID, ET.EQUIPMENTTYPE, HI.DESCRIPTIONID, HI.MODELNAMEID, 
                              HI.MODELNUMBERID, HI.SPEEDNAMEID, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE, HI.REQUISITIONNUMBER,
                              HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, HI.FISCALYEARID, HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME,
                              HI.COMMENTS, HI.MODIFIEDBYID, HI.DATECHECKED, ET.EQUIPMENTTYPE ||' - ' || HI.BARCODENUMBER AS DISPLAYKEY
                    FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE ET, LIBSHAREDDATAMGR.CUSTOMERS CUST,
                              FACILITIESMGR.LOCATIONS LOC
                    WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#GetSREquipLookup.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
                              HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND 
                              HI.CUSTOMERID = CUST.CUSTOMERID AND
                              CUST.LOCATIONID = LOC.LOCATIONID
                    ORDER BY	HI.BARCODENUMBER
               </CFQUERY>
     
			<TD align="left" colspan="2">
               	#GetHardware.BARCODENUMBER#, #GetHardware.EQUIPMENTTYPE#, #GetHardware.DIVISIONNUMBER#,
                    #GetHardware.ROOMNUMBER#,  #GetHardware.FULLNAME#
               </TD>
          <CFELSE>
               	<TD align="left" colspan="2">
               	<STRONG>No Equipment was selected for this SR.</STRONG>
               </TD>
          </CFIF>	
		</TR>
		<TR>	
			<TH align="left">HWSW Date</TH>
               <TH align="left">HWSW Time</TH>
		</TR>
		<TR>
			<TD align="left">
				#DateFormat(GetHardwareAssignments.HWSWDATE, "mm/dd/yyyy")#
			</TD>
			<TD align="left">
				#TimeFormat(GetHardwareAssignments.HWSWTIME, "hh:mm:ss tt")#
			</TD>
          </TR>
          <TR>
			<TH align="left"><H4><LABEL for="HWSWID">*HWSW</LABEL></H4></TH>
          <CFIF #GetHWSW.HWSW_ID# EQ 1>
			<TH align="left">
               	<INPUT type="hidden" name="HWIMAGE" value="1" />
               	<H4><LABEL for="IMAGEID">*Image</LABEL></H4>
               </TH>
          <CFELSE> 
			<TH align="left">
               	<INPUT type="hidden" name="HWIMAGE" value="0" />
               	<LABEL for="IMAGEID">Image</LABEL>
               </TH>
          </CFIF>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="HWSWID" id="HWSWID" size="1" query="ListHWSW" value="HWSW_ID" selected="#GetHardwareAssignments.HWSWID#" display="HWSW_NAME" required="no" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">
                    <CFSELECT name="IMAGEID" id="IMAGEID" size="1" query="ListImages" value="IMAGEID" selected ="#GetHardwareAssignments.IMAGEID#" display="IMAGENAME" required="No" tabindex="3"></CFSELECT>
               </TD>
		</TR>
          <TR>
			<TD align="left" colspan="2"><HR></TD>
		</TR>
          <TR>
			<TH align="left"><H2>If Inventory Installed, Make Selections Below:</H2></TH>
               <TH align="left"><H2>If Inventory Swapped, Make Selections Below:</H2></TH>
		</TR>
		<TR>
			<TH align="left"><LABEL for="INSTALLEDBARCODE">Installed Inventory</LABEL></TH>
               <TH align="left"><LABEL for="RETURNEDBARCODE">Returning Inventory</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="INSTALLEDBARCODE" id="INSTALLEDBARCODE" value="#FORM.INSTALLEDBARCODE#" align="LEFT" required="No" size="18" maxlength="17" tabindex="4">
			</TD>
               <TD align="left">
				<CFINPUT type="Text" name="RETURNEDBARCODE" id="RETURNEDBARCODE" value="#FORM.RETURNEDBARCODE#" align="LEFT" required="No" size="18" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="INSTALLLOCID">Installed Location</LABEL></TH>
               <TH align="left"><LABEL for="RETURNLOCID">Returning Location (I.E. LL-402)</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="INSTALLLOCID" id="INSTALLLOCID" size="1" query="ListRoomNumbers" value="LOCATIONID" selected ="#GetHardwareAssignments.INSTALLLOCID#" display="ROOMNUMBER" required="No" tabindex="6"></CFSELECT>
			</TD>
               <TD align="left">
				<CFSELECT name="RETURNLOCID" id="RETURNLOCID" size="1" query="ListRoomNumbers" value="LOCATIONID" selected ="#GetHardwareAssignments.RETURNLOCID#" display="ROOMNUMBER" required="No" tabindex="7"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="INSTALLCUSTID">Installed Customer</LABEL></TH>
               <TH align="left"><LABEL for="RETURNCUSTID">Returning Customer (I.E. HARDWARE INVENTORY)</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="INSTALLCUSTID" id="INSTALLCUSTID" size="1" query="ListRequesters" value="CUSTOMERID" selected ="#GetHardwareAssignments.INSTALLCUSTID#" display="FULLNAME" required="No" tabindex="8"></CFSELECT>
			</TD>
               <TD align="left">
				<CFSELECT name="RETURNCUSTID" id="RETURNCUSTID" size="1" query="ListRequesters" value="CUSTOMERID" selected ="#GetHardwareAssignments.RETURNCUSTID#" display="FULLNAME" required="No" tabindex="9"></CFSELECT>
			</TD>
		</TR>
		
		<TR>
			<TH align="left"><LABEL for="TECHCOMMENTS">Additional Comments</LABEL></TH>
			<TH align="left"><LABEL for="SALVAGEFLAG">Salvage Bound</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFTEXTAREA name="TECHCOMMENTS" id="TECHCOMMENTS" wrap="VIRTUAL" rows="5" cols="40" tabindex="10">#GetHardwareAssignments.TECHCOMMENTS#</CFTEXTAREA>
			</TD>
               <TD align="left" valign="TOP">
                    <CFSELECT name="SALVAGEFLAG" id="SALVAGEFLAG" size="1" tabindex="11">
                         <OPTION selected value="#GetHardwareAssignments.SALVAGEFLAG#">#GetHardwareAssignments.SALVAGEFLAG#</OPTION>
					<OPTION value="NO">NO</OPTION>
                         <OPTION value="YES">YES</OPTION>
                    </CFSELECT>
			</TD>
		</TR>
          <TR>
			<TD align="left" colspan="2"><HR></TD>
		</TR>
          
       <CFIF (IsDefined('GetInstalledInvBarcode.EQUIPMENTTYPEID')) AND (#GetInstalledInvBarcode.EQUIPMENTTYPEID#  EQ 1 OR  #GetInstalledInvBarcode.EQUIPMENTTYPEID# EQ 15)>
       
          <TR>
			<TH align="left" colspan="2"><H2>If Installed Inventory = CPU, Enter Network Information Below:</H2></TH>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MACHINENAME">Machine Name</LABEL></TH>
			<TH align="left"><LABEL for="IPADDRESS">IP Address</LABEL></TH>
		</TR>
		<TR>
         	<CFIF ((IsDefined('GetInstalledInvBarcode.MACHINENAME')) AND (#GetHardwareAssignments.MACHINENAME# EQ '' OR #GetHardwareAssignments.MACHINENAME# EQ ' '))>
          	<TD align="left" valign="TOP">
               	<CFINPUT type="Text" name="MACHINENAME" id="MACHINENAME" value="#GetInstalledInvBarcode.MACHINENAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="12">
               </TD>
          <CFELSE>
			<TD align="left" valign="TOP">
               	<CFINPUT type="Text" name="MACHINENAME" id="MACHINENAME" value="#GetHardwareAssignments.MACHINENAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="12">
               </TD>
          </CFIF>
          <CFIF ((IsDefined('GetInstalledInvBarcode.IPADDRESS')) AND (#GetHardwareAssignments.IPADDRESS# EQ '' OR #GetHardwareAssignments.IPADDRESS# EQ ' '))>
			<TD align="left" valign="TOP">
               	<CFINPUT type="Text" name="IPADDRESS" id="IPADDRESS" value="#GetInstalledInvBarcode.IPADDRESS#" align="LEFT" required="No" size="25" maxlength="15" tabindex="13">
               </TD>
          <CFELSE>
			<TD align="left" valign="TOP">
               	<CFINPUT type="Text" name="IPADDRESS" id="IPADDRESS" value="#GetHardwareAssignments.IPADDRESS#" align="LEFT" required="No" size="25" maxlength="15" tabindex="13">
               </TD>
          </CFIF>
		</TR>
    		<TR>
			<TH align="left"><LABEL for="MACADDRESS">MAC Address</LABEL></TH>
               <TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
          <CFIF ((IsDefined('GetInstalledInvBarcode.MACADDRESS')) AND (#GetHardwareAssignments.MACADDRESS# EQ '' OR #GetHardwareAssignments.MACADDRESS# EQ ' '))>
          	<TD align="left" valign="TOP">
               	<CFINPUT type="Text" name="MACADDRESS" id="MACADDRESS" value="#GetInstalledInvBarcode.MACADDRESS#" align="LEFT" required="No" size="25" maxlength="17" tabindex="14"><BR>
                    <COM>(Do NOT Include Colons.)</COM>
               </TD>
          <CFELSE>
			<TD align="left" valign="TOP">
               	<CFINPUT type="Text" name="MACADDRESS" id="MACADDRESS" value="#GetHardwareAssignments.MACADDRESS#" align="LEFT" required="No" size="25" maxlength="17" tabindex="14"><BR>
                    <COM>(Do NOT Include Colons.)</COM>
               </TD>
          </CFIF>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
          
	</CFIF>
               
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
               <TD align="left" valign="TOP">
                    <INPUT type="hidden" name="PROCESSHARDWAREASSIGN" value="MODIFY" />
                    <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="15" />
               </TD>
          	<CFIF session.ProcessArray EQ "YES">
			<TD align="left">
                    <INPUT type="image" src="/images/buttonModifyLoop.jpg" value="MODIFYLOOP" alt="Modify Loop" onClick="return setModifyLoop();" tabindex="16" />
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
                    <INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="17" />
               </TD>
          	<CFIF session.ProcessArray EQ "YES">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonDEL-Loop.jpg" value="DELETELOOP" alt="Delete Loop Hardware Assignment" onClick="return setDeleteLoop();" tabindex="18" /><BR>
                    <INPUT type="image" src="/images/buttonDEL-All.jpg" value="DELETEALL" alt="Delete All Hardware Assignments for SR" onClick="return setDeleteAll();" tabindex="19" />
               </TD>
           	</CFIF>
		</TR>
          </CFIF>
	</TABLE>


</CFFORM>

	<CFIF session.ProcessArray EQ "YES">

<CFFORM name="CHOOSEREC" action="/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=#URL.PROCESS#&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#" method="POST">

	<TABLE align="left" width="100%" border="0">
          <TR>
               <TD align="left" width="33%">
                    <INPUT type="hidden" name="RETRIEVERECORD" value="NEXTRECORD" />
                    <INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXTRECORD" alt="Next Record" tabindex="20" />
               </TD>
           <CFIF #session.SRHARDWASSIGNIDCounter# GT 1>
               <TD align="left" width="33%">
                    <INPUT type="image" src="/images/buttonPreviousRec.jpg" value="PREVIOUSRECORD" alt="Previous Record" onClick="return setPrevRecord();" tabindex="21" />
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
<CFFORM action="/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=#URL.PROCESS#&STAFFLOOP=#URL.STAFFLOOP#" method="POST">
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