<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwareassignsconfirm.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/08/2013 --->
<!--- Date in Production: 02/08/2013 --->
<!--- Module: Add/Modify/Delete Information to Service Requests - Software Assignments --->
<!-- Last modified by John R. Pastori on 02/08/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL =" pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/softwareassignsconfirm.cfm">
<CFSET CONTENT_UPDATED = "February 08, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Confirm Information to Service Requests - Software Assignments</TITLE>
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
		document.SOFTWAREASSIGNMENTS.PROCESSSOFTWAREASSIGN.value = "CONFIRMLOOP";
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
	<CFSET CURSORFIELD = "document.SOFTWAREASSIGNMENTS.CONFIRMFLAG.focus()">     
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "CONFIRM">
</CFIF>

<!--- 
****************************************************************
* The following code is for all Software Assignment Processes. *
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
* The following code is the Look Up Process for Confirming Software Assignment Information. *
*********************************************************************************************
 --->

<CFIF (NOT IsDefined('session.SRSOFTWASSIGNIDArray') OR NOT IsDefined('URL.LOOKUPITEM'))>		
	<CFSET session.SRSOFTWASSIGNIDArray=ArrayNew(1)>
	<CFSET temp = ArraySet(session.SRSOFTWASSIGNIDArray, 1, 1, 0)>
	<CFSET session.SRSOFTWASSIGNIDCounter = 0>
	<CFSET session.ProcessArray = "NO">
</CFIF>

<CFIF NOT IsDefined('URL.LOOKUPITEM')>

	<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	DISTINCT SRID
		FROM		SRSOFTWASSIGNS
          WHERE	(CONFIRMFLAG IS NULL OR
               	CONFIRMFLAG = 'NO')
		ORDER BY	SRID
	</CFQUERY>
     
     <CFIF #LookupSoftwareAssignments.RecordCount# EQ 0>
          <SCRIPT language="JavaScript">
               <!-- 
                    alert("There are no Software Assignment records to be confirmed!");
               --> 
          </SCRIPT>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
          <CFEXIT>
     </CFIF>

	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	DISTINCT SR.SRID, CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	SR.SRID IN (#ValueList(LookupSoftwareAssignments.SRID)#) AND
				SR.REQUESTERID = CUST.CUSTOMERID 
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Confirm SR - Software Assignments Lookup</H1></TD>
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/softwareassignsconfirm.cfm?PROCESS=#URL.PROCESS#&LOOKUPITEM=FOUND" method="POST">
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

<CFELSEIF session.SRSOFTWASSIGNIDArray[1] EQ 0 AND #URL.PROCESS# EQ "CONFIRM">

<!--- 
**********************************************************************************
* The following code is the Confirm Process for Software Assignment Information. *
**********************************************************************************
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
                         SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMBER">
                    </CFIF>
               ORDER BY	SR.SERVICEREQUESTNUMBER
          </CFQUERY>
     </CFIF>
     
     <CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SRSOFTWASSIGNID, SRID, CONFIRMFLAG
          FROM		SRSOFTWASSIGNS
          WHERE	(
               <CFIF IsDefined('URL.SRSOFTWASSIGNID')>
                    SRSOFTWASSIGNID = <CFQUERYPARAM value="#Cookie.SRSOFTWASSIGNID#" cfsqltype="CF_SQL_NUMBER">) AND
               <CFELSE>
                    SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER">) AND
               </CFIF>
                    CONFIRMFLAG = 'NO'
          ORDER BY	SRSOFTWASSIGNID
     </CFQUERY>
     <CFIF #LookupSoftwareAssignments.RecordCount# EQ 0>
          <SCRIPT language="JavaScript">
               <!-- 
                    alert("A Software Assignment Record has NOT yet been created for this SR or All Software Assignments for this SR have been Confirmed!");
               --> 
          </SCRIPT>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
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
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsconfirm.cfm?PROCESS=CONFIRM" />
          <CFEXIT>
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
               SRSOFTWASSIGNID = <CFQUERYPARAM value="#FORM.SRSOFTWASSIGNID#" cfsqltype="CF_SQL_NUMBER">)  AND
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

<CFQUERY name="GetImages" datasource="#application.type#SOFTWARE" blockfactor="16">
	SELECT	IMAGEID, IMAGENAME
	FROM		IMAGES
     WHERE	IMAGEID = #val(GetSoftwareAssignments.IMAGEID)#
	ORDER BY	IMAGENAME
</CFQUERY>

<CFIF #GetSoftwareAssignments.ASSIGN_INVENTID# GT 0>

     <CFQUERY name="GetAssignedInvBarcode" datasource="#application.type#HARDWARE" blockfactor="100">
          SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPTYPEID, EQT.EQUIPMENTTYPE, HI.FISCALYEARID,
                    HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME
          FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, LIBSHAREDDATAMGR.CUSTOMERS CUST,
                    FACILITIESMGR.LOCATIONS LOC
          WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetSoftwareAssignments.ASSIGN_INVENTID#" cfsqltype="CF_SQL_NUMBER"> AND 
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
          WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetSoftwareAssignments.UNASSIGN_INVENTID#" cfsqltype="CF_SQL_NUMBER">
          ORDER BY	BARCODENUMBER
     </CFQUERY>

     <CFSET FORM.UNASSIGN_BARCODE = "#GetUnAssignedInvBarcode.BARCODENUMBER#">
<CFELSE>
     <CFSET FORM.UNASSIGN_BARCODE = "3065000">
</CFIF>

<CFQUERY name="GetAssignedInvCust" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER, 
			CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
	WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetSoftwareAssignments.ASSIGN_CUSTID#" cfsqltype="CF_SQL_NUMBER"> AND
     		CUST.UNITID = UNITS.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="GetUnAssignedInvCust" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER, 
			CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
	WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetSoftwareAssignments.UNASSIGN_CUSTID#" cfsqltype="CF_SQL_NUMBER"> AND
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
          <TD align="center"><H1>Confirm SR - Software Assignments</H1></TD>
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
<CFFORM action="/#application.type#apps/servicerequests/softwareassignsconfirm.cfm?PROCESS=#URL.PROCESS#" method="POST">
          <TD align="left" colspan="2">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
               <COM>(Please DO NOT use the Browser's Back Button.)</COM>
          </TD>
</CFFORM>
     </TR>
     <TR>
          <TD>&nbsp;&nbsp;<BR /><BR /></TD>
     </TR>

<CFFORM name="SOFTWAREASSIGNMENTS" action="/#application.type#apps/servicerequests/processsoftwareassigns.cfm" method="POST" ENABLECAB="Yes">
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
          <TH align="left"><H2>If Software Installed, Make Selections Below:</H2></TH>
          <TH align="left"><H2>If Software Removed, Make Selections Below:</H2></TH>
     </TR>
     <TR>
          <TH align="left" valign="TOP">SW Title Assigned</TH>
          <TH align="left" valign="TOP">SW Title UnAssigned</TH>
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
               #GetAssignedSoftwareTitles.SUBCATEGORYNAME#
          </TD>
          <TD align="left" valign="TOP">
               #GetUnAssignedSoftwareTitles.SUBCATEGORYNAME#
          </TD>
     </TR>
     <TR>
          <TH align="left">
               Or SW Title, if Other Package Assigned
          </TH>
          <TH align="left">
          	Or SW Title, if Other Package UnAssigned
          </TH>
     </TR>
     <TR>
          <TD align="left" valign="TOP">
               #GetSoftwareAssignments.ASSIGN_OTHERPKGTITLE#
          </TD>
          <TD align="left" valign="TOP">
               #GetSoftwareAssignments.UNASSIGN_OTHERPKGTITLE#
          </TD>
     </TR>
     <TR>
          <TD>&nbsp;&nbsp;</TD>
     </TR>
     <TR>
          <TH align="left">Version Assigned</TH>
          <TH align="left">Version UnAssigned</TH>
     </TR>
     <TR>
          <TD align="left" valign="TOP">
               #GetSoftwareAssignments.ASSIGN_VERSION#
          </TD>
          <TD align="left" valign="TOP">
               #GetSoftwareAssignments.UNASSIGN_VERSION#
          </TD>
     </TR>
	<TR>
          <TD>&nbsp;&nbsp;</TD>
     </TR>     
     <TR>
          <TH align="left" valign="BOTTOM">Inventory Assigned</TH>
          <TH align="left">Inventory UnAssigned</TH>
     </TR>
     <TR>
          <TD align="left" valign="TOP">
               #FORM.ASSIGN_BARCODE#
          </TD>
          <TD align="left" valign="TOP">
               #FORM.UNASSIGN_BARCODE#
          </TD>
     </TR>
     <TR>
          <TH align="left">Customer Assigned</TH>
          <TH align="left">Customer UnAssigned</TH>
     </TR>
     <TR>          
          <TD align="left" valign="TOP">
               #GetAssignedInvCust.FULLNAME#
          </TD>
          <TD align="left" valign="TOP">
               #GetUnAssignedInvCust.FULLNAME#
          </TD>
     </TR>
     <TR>
          <TD align="left" colspan="2"><HR></TD>
     </TR>
     <TR>
          <TH align="left" COLSPAN="2">Additional Comments</TH>
     </TR>
     <TR>
          <TD align="left" valign="TOP" COLSPAN="2">
               #GetSoftwareAssignments.TECHCOMMENTS#
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
     <CFIF #GetSoftwareAssignments.CONFIRMFLAG# EQ "" OR #GetSoftwareAssignments.CONFIRMFLAG# EQ "NO">
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
     	 <TD align="left">#GetSoftwareAssignments.CONFIRMFLAG#</TD>
           <TD align="left">#GetSoftwareAssignments.CONFIRMCOMMENTS#</TD>
     </CFIF>
     </TR>
     <TR>
          <TH align="left">Confirmed By</TH>
          <TH align="left" valign="BOTTOM"><LABEL for="CONFIRMEDDATE">Confirmed Date</LABEL></TH>
     </TR>
     <TR>
     <CFIF #GetSoftwareAssignments.CONFIRMFLAG# EQ "" OR #GetSoftwareAssignments.CONFIRMFLAG# EQ "NO">
          <TD align="left" valign="TOP">
			<INPUT type="hidden" name="COMFIRMEDBYID" value="#GetModifiedBy.CUSTOMERID#" />
			#GetModifiedBy.FULLNAME#
		</TD>
          <TD align="left">
               <CFSET FORM.CONFIRMEDDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
               <CFINPUT type="Text" name="CONFIRMEDDATE" id="CONFIRMEDDATE" value="#DateFormat(FORM.CONFIRMEDDATE, "mm/dd/yyyy")#" align="LEFT" required="No" size="15" tabindex="4">
               <SCRIPT language="JavaScript">
                    new tcal ({'formname': 'SOFTWAREASSIGNMENTS','controlname': 'CONFIRMEDDATE'});

               </SCRIPT>
          </TD>
     <CFELSE>
          <TD align="left">#LookupModifiedBy.FULLNAME#</TD>
          <TD align="left">#DateFormat(GetSoftwareAssignments.CONFIRMEDDATE, "mm/dd/yyyy")#</TD>
     </CFIF>
     </TR>
     <TR>
          <TD align="left">&nbsp;&nbsp;</TD>
     </TR>
     <TR>
          <TD align="left" valign="TOP">
               <INPUT type="hidden" name="PROCESSSOFTWAREASSIGN" value="CONFIRM" />
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

<CFFORM name="CHOOSEREC" action="/#application.type#apps/servicerequests/softwareassignsconfirm.cfm?PROCESS=#URL.PROCESS#&LOOKUPITEM=FOUND" method="POST">


     <TR>
          <TD align="left">
               <INPUT type="hidden" name="RETRIEVERECORD" value="NEXTRECORD" />
               <INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXTRECORD" alt="Next Record" tabindex="7" />
          </TD>
      <CFIF #session.SRSOFTWASSIGNIDCounter# GT 1>
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
<CFFORM action="/#application.type#apps/servicerequests/softwareassignsconfirm.cfm?PROCESS=#URL.PROCESS#" method="POST">
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