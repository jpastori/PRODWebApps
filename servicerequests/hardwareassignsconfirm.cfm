<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hardwareassignsconfirm.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/08/2013 --->
<!--- Date in Production: 02/08/2013 --->
<!--- Module: Add/Modify/Delete Information to Service Requests - Hardware Assignments --->
<!-- Last modified by John R. Pastori on 10/29/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL =" pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/hardwareassignsconfirm.cfm">
<CFSET CONTENT_UPDATED = "October 29, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Confirm Information to Service Requests - Hardware Assignments</TITLE>
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

	
	
	
	function setConfirmLoop() {
		document.HARDWAREASSIGNMENTS.PROCESSHARDWAREASSIGN.value = "CONFIRMLOOP";
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
<CFIF NOT IsDefined('URL.LOOKUPITEM')>
	<CFSET CURSORFIELD = "document.LOOKUP.SERVICEREQUESTNUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.HARDWAREASSIGNMENTS.CONFIRMFLAG.focus()">     
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "CONFIRM">
</CFIF>

<!--- 
****************************************************************
* The following code is for all Hardware Assignment Processes. *
****************************************************************
 --->

<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<!--- 
*********************************************************************************************
* The following code is the Look Up Process for Confirming Hardware Assignment Information. *
*********************************************************************************************
 --->

<CFIF (NOT IsDefined('session.SRHARDWASSIGNIDArray') OR NOT IsDefined('URL.LOOKUPITEM'))>		
	<CFSET session.SRHARDWASSIGNIDArray=ArrayNew(1)>
	<CFSET temp = ArraySet(session.SRHARDWASSIGNIDArray, 1, 1, 0)>
	<CFSET session.SRHARDWASSIGNIDCounter = 0>
	<CFSET session.ProcessArray = "NO">
</CFIF>

<CFIF NOT IsDefined('URL.LOOKUPITEM')>

	<CFQUERY name="LookupHardwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	DISTINCT SRID
		FROM		SRHARDWASSIGNS
          WHERE	(CONFIRMFLAG IS NULL OR
               	CONFIRMFLAG = 'NO') 
		ORDER BY	SRID
	</CFQUERY>
     
     <CFIF #LookupHardwareAssignments.RecordCount# EQ 0>
          <SCRIPT language="JavaScript">
               <!-- 
                    alert("There are no Hardware Assignment records to be confirmed!");
               --> 
          </SCRIPT>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
          <CFEXIT>
     </CFIF>

	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	DISTINCT SR.SRID, CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	SR.SRID IN (#ValueList(LookupHardwareAssignments.SRID)#) AND
				SR.REQUESTERID = CUST.CUSTOMERID 
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Confirm SR - Hardware Assignments Lookup</H1></TD>
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/hardwareassignsconfirm.cfm?PROCESS=#URL.PROCESS#&LOOKUPITEM=FOUND" method="POST">
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

<CFELSEIF session.SRHARDWASSIGNIDArray[1] EQ 0 AND #URL.PROCESS# EQ "CONFIRM">

<!--- 
**********************************************************************************
* The following code is the Confirm Process for Hardware Assignment Information. *
**********************************************************************************
 --->
	<CFIF IsDefined('URL.SRID')>
          <CFSET FORM.SRID = #URL.SRID#>
     </CFIF>
     <CFCOOKIE name="SRID" secure="NO" value="#FORM.SRID#">

     <CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER
          FROM		SERVICEREQUESTS SR
          WHERE	SR.SRID > 0 AND
               <CFIF IsDefined('FORM.SERVICEREQUESTNUMBER') AND Len(FORM.SERVICEREQUESTNUMBER) GT 5>
                    SR.SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#FORM.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
               <CFELSE>
                    SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMBER">
               </CFIF>
          ORDER BY	SR.SERVICEREQUESTNUMBER
     </CFQUERY>

     <CFQUERY name="LookupHardwareAssignments" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SRHARDWASSIGNID, SRID
          FROM		SRHARDWASSIGNS
          WHERE	SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
               	(CONFIRMFLAG IS NULL OR
               	CONFIRMFLAG = 'NO') 
          ORDER BY	SRHARDWASSIGNID
     </CFQUERY>
     <CFIF #LookupHardwareAssignments.RecordCount# EQ 0>
          <SCRIPT language="JavaScript">
               <!-- 
                    alert("A Hardware Assignment Record has NOT yet been created for this SR or All Hardware Assignments for this SR have been Confirmed!");
               --> 
          </SCRIPT>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
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
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassignsconfirm.cfm?PROCESS=CONFIRM" />
          <CFEXIT>
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
			SRHARDWASSIGNID = <CFQUERYPARAM value="#FORM.SRHARDWASSIGNID#" cfsqltype="CF_SQL_NUMBER">)  AND
               (CONFIRMFLAG IS NULL OR
               CONFIRMFLAG = 'NO') 
	ORDER BY	SRHARDWASSIGNID
</CFQUERY>

<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
	SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER
	FROM		SERVICEREQUESTS SR
	WHERE	SR.SRID = <CFQUERYPARAM value="#GetHardwareAssignments.SRID#" cfsqltype="CF_SQL_NUMBER"> 
	ORDER BY	SR.SERVICEREQUESTNUMBER
</CFQUERY>

<CFQUERY name="GetSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
	SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, SRSA.NEXT_ASSIGNMENT,
			SRSA.NEXT_ASSIGNMENT_GROUPID, GA.GROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, WGA.STAFFCUSTOMERID, CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED,
			TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATE, SRSA.STAFF_TIME_WORKED
	FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	SRSA.SRSTAFF_ASSIGNID > 0 AND
			SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
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

<CFQUERY name="GetImages" datasource="#application.type#SOFTWARE" blockfactor="16">
	SELECT	IMAGEID, IMAGENAME
	FROM		IMAGES
     WHERE	IMAGEID = #val(GetHardwareAssignments.IMAGEID)#
	ORDER BY	IMAGENAME
</CFQUERY>

<CFIF #GetHardwareAssignments.INSTALLINVENTID# GT 0>

	<CFQUERY name="GetInstalledInvBarcode" datasource="#application.type#HARDWARE">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID
		FROM		HARDWAREINVENTORY HI
		WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetHardwareAssignments.INSTALLINVENTID#" cfsqltype="CF_SQL_NUMBER"> 
		ORDER BY	HI.BARCODENUMBER
	</CFQUERY>
	
	<CFSET FORM.INSTALLEDBARCODE = "#GetInstalledInvBarcode.BARCODENUMBER#">
<CFELSE>
	<CFSET FORM.INSTALLEDBARCODE = "3065000">
</CFIF>

<CFQUERY name="GetInstalledInvRoomNumber" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOCATIONID, ROOMNUMBER, LOCATIONNAME
	FROM		LOCATIONS
     WHERE	LOCATIONID = <CFQUERYPARAM value="#GetHardwareAssignments.INSTALLLOCID#" cfsqltype="CF_SQL_VARCHAR">
	ORDER BY	ROOMNUMBER
</CFQUERY>

<CFQUERY name="GetInstalledInvCust" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER, 
			CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
	WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetHardwareAssignments.INSTALLCUSTID#" cfsqltype="CF_SQL_NUMBER"> AND
     		CUST.UNITID = UNITS.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFIF #GetHardwareAssignments.RETURNINVENTID# GT 0>
	
	<CFQUERY name="GetReturnedInvBarcode" datasource="#application.type#HARDWARE">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID
		FROM		HARDWAREINVENTORY HI
		WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetHardwareAssignments.RETURNINVENTID#" cfsqltype="CF_SQL_NUMBER">
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFSET FORM.RETURNEDBARCODE = "#GetReturnedInvBarcode.BARCODENUMBER#">
<CFELSE>
	<CFSET FORM.RETURNEDBARCODE = "3065000">
</CFIF>

<CFQUERY name="GetReturnedInvRoomNumber" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOCATIONID, ROOMNUMBER, LOCATIONNAME
	FROM		LOCATIONS
     WHERE	LOCATIONID = <CFQUERYPARAM value="#GetHardwareAssignments.RETURNLOCID#" cfsqltype="CF_SQL_VARCHAR">
	ORDER BY	ROOMNUMBER
</CFQUERY>

<CFQUERY name="GetReturnedInvCust" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER, 
			CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
	WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetHardwareAssignments.RETURNCUSTID#" cfsqltype="CF_SQL_NUMBER"> AND
     		CUST.UNITID = UNITS.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="GetModifiedBy" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, ACTIVE
	FROM		CUSTOMERS
	WHERE	CUSTOMERID = #Client.CUSTOMERID# AND
			INITIALS IS NOT NULL AND
			ACTIVE = 'YES'
	ORDER BY	FULLNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Confirm SR - Hardware Assignments</H1></TD>
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
<CFFORM action="/#application.type#apps/servicerequests/hardwareassignsconfirm.cfm?PROCESS=#URL.PROCESS#" method="POST">
		<TD align="left" colspan="2">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD>&nbsp;&nbsp;<BR /><BR /></TD>
	</TR>

<CFFORM name="HARDWAREASSIGNMENTS" action="/#application.type#apps/servicerequests/processhardwareassigns.cfm" method="POST" ENABLECAB="Yes">
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
                    FROM		HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS CUST, EQUIPMENTTYPE ET 
                    WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#GetSREquipLookup.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
                              HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
                              HI.CUSTOMERID = CUST.CUSTOMERID AND
                              HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID
                    ORDER BY	BARCODENUMBER
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
		<TD align="left" width="33%">
			#DateFormat(GetHardwareAssignments.HWSWDATE, "mm/dd/yyyy")#
		</TD>
		<TD align="left" width="33%">
			#TimeFormat(GetHardwareAssignments.HWSWTIME, "hh:mm:ss tt")#
		</TD>
	</TR>
	<TR>
		<TH align="left">HWSW</TH>
		<TH align="left">Image</TH>
	</TR>
	<TR>
		<TD align="left">
			#GetHWSW.HWSW_NAME#
		</TD>
		<TD align="left">
			#GetImages.IMAGENAME#
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
		<TH align="left">Installed Inventory</TH>
		<TH align="left">Returning Inventory</TH>
	</TR>
	<TR>
		<TD align="left">
			#FORM.INSTALLEDBARCODE#
		</TD>
		<TD align="left">
			#FORM.RETURNEDBARCODE#
		</TD>
	</TR>
	<TR>
		<TH align="left">Installed Location</TH>
		<TH align="left">Returning Location (I.E. LL-402)</TH>
	</TR>
	<TR>
		<TD align="left">
			#GetInstalledInvRoomNumber.ROOMNUMBER#
		</TD>
		<TD align="left">
			#GetReturnedInvRoomNumber.ROOMNUMBER#
		</TD>
	</TR>
	<TR>
		<TH align="left">Installed Customer</TH>
		<TH align="left">Returning Customer (I.E. HARDWARE INVENTORY)</TH>
	</TR>
	<TR>
		<TD align="left">
			#GetInstalledInvCust.FULLNAME#
		</TD>
		<TD align="left">
			#GetReturnedInvCust.FULLNAME#
		</TD>
	</TR>
	</TR>
	<TR>
		<TH align="left">&nbsp;&nbsp;</TH>
		<TH align="left"><LABEL for="SALVAGEFLAG">Salvage Bound</LABEL></TH>
	</TR>
	<TR>
		<TH align="left">&nbsp;&nbsp;</TH>
		<TD align="left">
			#GetHardwareAssignments.SALVAGEFLAG#
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
		<TD align="left" valign="TOP">
          	#GetHardwareAssignments.MACHINENAME#
          </TD>
		<TD align="left" valign="TOP">
          	#GetHardwareAssignments.IPADDRESS#
          </TD>
	</TR>
	<TR>
		<TH align="left">MAC Address</TH>
		<TH align="left">Additional Comments</TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP">
			#GetHardwareAssignments.MACADDRESS#
		</TD>
		<TD align="left" valign="TOP">
			#GetHardwareAssignments.TECHCOMMENTS#
		</TD>
	</TR>
     
<CFELSE>

	<TR>
		<TH align="left" valign="bottom" colspan="2">Additional Comments</TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP" colspan="2">
			#GetHardwareAssignments.TECHCOMMENTS#
		</TD>
	</TR>

</CFIF>

	<TR>
		<TH align="left">Modified By</TH>
		<TH align="left">Modified Date</TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP">
			<INPUT type="hidden" name="MODIFIEDBYID" value="#GetModifiedBy.CUSTOMERID#" />
			#GetModifiedBy.FULLNAME#
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
			<TD align="left" colspan="2"><HR></TD>
		</TR>
	<TR>
          <TH align="left" nowrap><LABEL for="CONFIRMFLAG">Confirm Complete?</LABEL></TH>
          <TH align="left"><LABEL for="CONFIRMCOMMENTS">Confirm Comments</LABEL></TH>
     </TR>
     <TR>
     <CFIF #GetHardwareAssignments.CONFIRMFLAG# EQ "" OR #GetHardwareAssignments.CONFIRMFLAG# EQ "NO">
          <TD align="left" valign="TOP">
               <CFSELECT name="CONFIRMFLAG" id="CONFIRMFLAG" size="1" tabindex="2">
                    <OPTION value="NO">NO</OPTION>
                    <OPTION value="YES">YES</OPTION>
               </CFSELECT>
          </TD>
          <TD align="left" valign="TOP">
               <CFTEXTAREA name="CONFIRMCOMMENTS" id="CONFIRMCOMMENTS" wrap="VIRTUAL" rows="5" cols="40" tabindex="3"></CFTEXTAREA>
          </TD>
     <CFELSE>
     	 <TD align="left">#GetHardwareAssignments.CONFIRMFLAG#</TD>
           <TD align="left">#GetHardwareAssignments.CONFIRMCOMMENTS#</TD>
     </CFIF>
     </TR>
     <TR>
          <TH align="left">Confirmed By</TH>
          <TH align="left" valign="BOTTOM"><LABEL for="CONFIRMEDDATE">Confirmed Date</LABEL></TH>
     </TR>
     <TR>
     <CFIF #GetHardwareAssignments.CONFIRMFLAG# EQ "" OR #GetHardwareAssignments.CONFIRMFLAG# EQ "NO">
          <TD align="left" valign="TOP">
			<INPUT type="hidden" name="COMFIRMEDBYID" value="#GetModifiedBy.CUSTOMERID#" />
			#GetModifiedBy.FULLNAME#
		</TD>
          <TD align="left">
               <CFSET FORM.CONFIRMEDDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
               <CFINPUT type="Text" name="CONFIRMEDDATE" id="CONFIRMEDDATE" value="#DateFormat(FORM.CONFIRMEDDATE, "mm/dd/yyyy")#" align="LEFT" required="No" size="15" tabindex="4">
               <SCRIPT language="JavaScript">
                    new tcal ({'formname': 'HARDWAREASSIGNMENTS','controlname': 'CONFIRMEDDATE'});

               </SCRIPT>
          </TD>
     <CFELSE>
          <TD align="left">#GetModifiedBy.FULLNAME#</TD>
          <TD align="left">#DateFormat(GetHardwareAssignments.CONFIRMEDDATE, "mm/dd/yyyy")#</TD>
     </CFIF>
     </TR>
     <TR>
          <TD align="left">&nbsp;&nbsp;</TD>
     </TR>
     <TR>
          <TD align="left" valign="TOP">
               <INPUT type="hidden" name="PROCESSHARDWAREASSIGN" value="CONFIRM" />
               <INPUT type="image" src="/images/buttonConfirm.jpg" value="CONFIRM" alt="Confirm" tabindex="5" />
          </TD>
          <CFIF session.ProcessArray EQ "YES">
          <TD align="left" >
               <INPUT type="image" src="/images/buttonConfirmLoop.jpg" value="CONFIRMLOOP" alt="Confirm Loop" OnClick="return setConfirmLoop();" tabindex="6" />
          </TD>
          </CFIF>
     </TR>
     <TR>
          <TD align="left">&nbsp;&nbsp;</TD>
     </TR>

</CFFORM>

<CFIF session.ProcessArray EQ "YES">

<CFFORM name="CHOOSEREC" action="/#application.type#apps/servicerequests/hardwareassignsconfirm.cfm?PROCESS=#URL.PROCESS#&LOOKUPITEM=FOUND" method="POST">

     <TR>
          <TD align="left">
               <INPUT type="hidden" name="RETRIEVERECORD" value="NEXTRECORD" />
               <INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXTRECORD" alt="Next Record" tabindex="7" />
          </TD>
      <CFIF #session.SRHARDWASSIGNIDCounter# GT 1>
          <TD align="left">
               <INPUT type="image" src="/images/buttonPreviousRec.jpg" value="PREVIOUSRECORD" alt="Previous Record" OnClick="return setPrevRecord();" tabindex="8" />
          </TD>
     <CFELSE>
          <TD align="left">&nbsp;&nbsp;</TD>
     </CFIF>
     </TR>

</CFFORM>

</CFIF>

     <TR>
          <TD align="left">&nbsp;&nbsp;</TD>
     </TR>
     <TR>
<CFFORM action="/#application.type#apps/servicerequests/hardwareassignsconfirm.cfm?PROCESS=#URL.PROCESS#" method="POST">
          <TD align="left" colspan="2">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="10" /><BR />
               <COM>(Please DO NOT use the Browser's Back Button.)</COM>
          </TD>
</CFFORM>
     </TR>
     <TR>
          <TD align="CENTER" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
     </TR>
</TABLE>

</BODY>
</CFOUTPUT>
</HTML>