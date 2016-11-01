<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwareassignments.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/16/2012 --->
<!--- Date in Production: 07/16/2012 --->
<!--- Module: Add/Modify/Delete/Loop Information in IDT Software Inventory - Assignments --->
<!-- Last modified by John R. Pastori on 07/16/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/softwareassignments.cfm">
<CFSET CONTENT_UPDATED = "July 16, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF #URL.PROCESS# EQ 'ADD'>
		<TITLE>Single Record Add in IDT Software Inventory - Assignments</TITLE>
	<CFELSEIF #URL.PROCESS# EQ "MODIFYDELETE">
		<TITLE>Single Record Modify/Delete in IDT Software Inventory - Assignments</TITLE>
	<CFELSE>
		<TITLE>Multiple Record Modify/Delete Loop in IDT Software Inventory - Assignments</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Software Inventory";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {

		if (document.ASSIGNMENTS.SERIALNUMBER.value == "" || document.ASSIGNMENTS.SERIALNUMBER.value == " ") {
			alertuser (document.ASSIGNMENTS.SERIALNUMBER.name +  ",  A Serial Number MUST be entered!");
			document.ASSIGNMENTS.SERIALNUMBER.focus();
			return false;
		}
	}


	function validateLookupField1() {
		if ((document.LOOKUP.SOFTWINVENTID1 != null && document.LOOKUP.SOFTWINVENTID1.selectedIndex == "0") 
		 && (document.LOOKUP.SOFTWINVENTID2 != null && document.LOOKUP.SOFTWINVENTID2.selectedIndex == "0")) {
			alertuser ("A Title MUST be selected!");
			document.LOOKUP.SOFTWINVENTID1.focus();
			return false;
		}
	}


	function validateLookupField2() {
		if ((document.LOOKUP.SOFTWASSIGNID1 != null && document.LOOKUP.SOFTWASSIGNID1.selectedIndex == "0")
		 && (document.LOOKUP.SOFTWASSIGNID2 != null && document.LOOKUP.SOFTWASSIGNID2.selectedIndex == "0")) {
			alertuser ("A Title or a Customer MUST be selected!");
			document.LOOKUP.SOFTWASSIGNID1.focus();
			return false;
		}

		if ((document.LOOKUP.SOFTWASSIGNID1 != null && document.LOOKUP.SOFTWASSIGNID1.selectedIndex > "0")
		 && (document.LOOKUP.SOFTWASSIGNID2 != null && document.LOOKUP.SOFTWASSIGNID2.selectedIndex > "0")) {
			alertuser ("A Title and a Customer can NOT both be selected!");
			document.LOOKUP.SOFTWASSIGNID1.focus();
			return false;
		}
	}


	function validateLookupField3() {
		if ((document.LOOKUP.SOFTWINVENTID != null && document.LOOKUP.SOFTWINVENTID.selectedIndex == "0")
		 && (document.LOOKUP.ASSIGNEDHARDWAREID != null && document.LOOKUP.ASSIGNEDHARDWAREID.selectedIndex == "0")) {
			alertuser ("A Title or a Barcode - HW Customer MUST be selected!");
			document.LOOKUP.SOFTWINVENTID.focus();
			return false;
		}

		if ((document.LOOKUP.SOFTWINVENTID != null && document.LOOKUP.SOFTWINVENTID.selectedIndex > "0")
		 && (document.LOOKUP.ASSIGNEDHARDWAREID != null && document.LOOKUP.ASSIGNEDHARDWAREID.selectedIndex > "0")) {
			alertuser ("A Title and a Barcode - HW Customer can NOT both be selected!");
			document.LOOKUP.SOFTWINVENTID.focus();
			return false;
		}
	}


	function setNextRecord() {
		document.ASSIGNMENTS.PROCESSSOFTWAREASSIGNMENTS.value = "NEXTRECORD";
		return true;
	}

	function setDelete() {
		document.ASSIGNMENTS.PROCESSSOFTWAREASSIGNMENTS.value = "DELETE";
		return true;
	}


	function setDeleteLoop() {
		document.ASSIGNMENTS.PROCESSSOFTWAREASSIGNMENTS.value = "DELETELOOP";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPTITLE') AND FIND('MODIFY', #URL.PROCESS#, 1) NEQ 0>
	<CFIF #URL.PROCESS# EQ 'MODIFYDELETE'>
		<CFSET CURSORFIELD = "document.LOOKUP.SOFTWASSIGNID1.focus()">
	<CFELSE>
		<CFSET CURSORFIELD = "document.LOOKUP.SOFTWINVENTID.focus()">
	</CFIF>
<CFELSEIF URL.PROCESS EQ 'ADD' AND NOT IsDefined('URL.SOFTWINVENTID') AND NOT IsDefined('FORM.SOFTWINVENTID1')>
	<CFSET CURSORFIELD = "document.LOOKUP.SOFTWINVENTID1.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.ASSIGNMENTS.IMAGEID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<BR clear="left" />

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, U.UNITNAME, CUST.CAMPUSPHONE,
			LOC.LOCATIONID, LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U, FACILITIESMGR.LOCATIONS LOC
	WHERE	(CUST.UNITID = U.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES') AND
			(U.DEPARTMENTID = 8 OR
			LOC.LOCATIONID = 118 OR
			CUST.CUSTOMERID = 0)
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	HI.HARDWAREID, HI.EQUIPMENTTYPEID,
			HI.BARCODENUMBER || ' - ' || HI.DIVISIONNUMBER || ' - ' || CUST.FULLNAME AS LOOKUPKEY
	FROM		HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	(HI.HARDWAREID = 0 OR 
			HI.EQUIPMENTTYPEID = 1) AND
			HI.CUSTOMERID = CUST.CUSTOMERID
	ORDER BY	LOOKUPKEY
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			SL.SECURITYLEVELNAME, CUST.FULLNAME || ' - ' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 900 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<!--- 
******************************************************************************
* The following code is the Look Up Process for Adding Software Assignments. *
******************************************************************************
 --->
<CFIF #URL.PROCESS# EQ 'ADD'>

	<CFIF IsDefined('URL.PGMCALL') AND #URL.PGMCALL# EQ 'CUSTASSIGN'>
		<!--- PGMCALL EQUAL CUSTASSIGN --->
		<CFSET PROGRAMNAME = 'softwareassignments.cfm?PROCESS=#URL.PROCESS#&PGMCALL=CUSTASSIGN&ASSIGNEDCUSTID=#URL.ASSIGNEDCUSTID#&HARDWAREID=#URL.HARDWAREID#'>
     <CFELSE>
     	<CFSET PROGRAMNAME = 'softwareassignments.cfm?PROCESS=#URL.PROCESS#'>
     </CFIF>

	<CFIF (NOT IsDefined('URL.SOFTWINVENTID') AND NOT IsDefined('FORM.SOFTWINVENTID1') AND NOT IsDefined('FORM.SOFTWINVENTID2'))>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center"><H1>Inventory Lookup for Single Record ADD in IDT Software Inventory - Assignments</H1></TH>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>

		<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
					SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED, SI.UPGRADESTATUSID,
					SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE,
					SI.TITLE || ' - ' || SI.VERSION || ' - ' || SI.SOFTWINVENTID || ' - ' ||  PR.REQNUMBER AS LOOKUPKEY
			FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID  AND
					SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<CFQUERY name="LookupSIRecordKeys" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	UNIQUE SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID,
					PP.PRODUCTPLATFORMNAME, SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, SI.FISCALYEARID, SI.RECVDDATE,
					SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID,
					SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, MANUFWARRVENDORID, SI.MODIFIEDBYID,
					SI.MODIFIEDDATE, SI.SOFTWINVENTID || ' - ' || SI.TITLE AS LOOKUPKEY
			FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL,
					PURCHASEMGR.PURCHREQS PR
			WHERE	SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<BR />
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField1();" action="/#application.type#apps/softwareinventory/#PROGRAMNAME#" method="POST">
			<TR>
				<TH align="LEFT"><H4><LABEL for="SOFTWINVENTID1">*Select by Title - Version - SW Key - Req Number</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT">
					<CFSELECT name="SOFTWINVENTID1" id="SOFTWINVENTID1" size="1" query="LookupSoftwareInventory" value="SOFTWINVENTID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="TOP"><H4><LABEL for="SOFTWINVENTID2">*OR by SW Key - Title</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" valign="TOP">
					<CFSELECT name="SOFTWINVENTID2" id="SOFTWINVENTID2" size="1" query="LookupSIRecordKeys" value="SOFTWINVENTID" selected="0" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
*******************************************************************
* The following code is the ADD Process for Software Assignments. *
*******************************************************************
 --->

		<CFIF IsDefined('URL.PGMCALL')>
          	<CFIF #URL.PGMCALL# EQ 'CUSTASSIGN'>
				<!--- PGMCALL EQUAL CUSTASSIGN --->
				<CFSET PROGRAMNAME = 'processsoftwareassignments.cfm?PGMCALL=CUSTASSIGN'>
			<CFELSEIF #URL.PGMCALL# EQ 'SI'>
				<!--- PGMCALL EQUAL SI --->
				<CFSET PROGRAMNAME = 'processsoftwareassignments.cfm?PGMCALL=SI'>
			<CFELSEIF #URL.PGMCALL# EQ 'SA'>
				<!--- PGMCALL EQUAL SA --->
				<CFSET PROGRAMNAME = 'processsoftwareassignments.cfm?PGMCALL=SA'>
			<CFELSE>
				<!--- PGMCALL IS NOT SET --->
				<CFSET PROGRAMNAME = 'processsoftwareassignments.cfm'>
			</CFIF> 
		<CFELSE>
			<!--- PGMCALL IS NOT SET --->
			<CFSET PROGRAMNAME = 'processsoftwareassignments.cfm'>
		</CFIF>

		<CFIF IsDefined('FORM.SOFTWINVENTID1') AND #FORM.SOFTWINVENTID1# GT 0>
			<CFSET FORM.SOFTWINVENTID = #FORM.SOFTWINVENTID1#>
		<CFELSEIF IsDefined('FORM.SOFTWINVENTID2') AND #FORM.SOFTWINVENTID2# GT 0>
			<CFSET FORM.SOFTWINVENTID = #FORM.SOFTWINVENTID2#>
		</CFIF>

		<CFIF IsDefined('URL.SOFTWINVENTID')>
			<CFSET FORM.SOFTWINVENTID = URL.SOFTWINVENTID>
		</CFIF>
		<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE">
			SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SI.PRODDESCRIPTION, SI.PURCHREQLINEID, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
					SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
					SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE
			FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP 
			WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
			ORDER BY	TITLE, VERSION, PRODPLATFORMID
		</CFQUERY>

		<CFCOOKIE name="SOFTWINVENTID" secure="NO" value="#FORM.SOFTWINVENTID#">

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TD align="center"><H1>Single Record Add Information in IDT Software Inventory - Assignments</H1></TD>
			</TR>
		</TABLE>

		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
			SELECT	MAX(SOFTWASSIGNID) AS MAX_ID
			FROM		SOFTWAREASSIGNMENTS
		</CFQUERY>
		<CFSET FORM.SOFTWASSIGNID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFSET FORM.ASSIGNDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
		<CFSET FORM.CURRASSIGNEDFLAG = 'NO'>
		<CFCOOKIE name="SOFTWASSIGNID" secure="NO" value="#FORM.SOFTWASSIGNID#">
		<CFQUERY name="AddSoftwareInventoryID" datasource="#application.type#SOFTWARE">
			INSERT INTO	SOFTWAREASSIGNMENTS (SOFTWASSIGNID, SOFTWINVENTID, ASSIGNDATE)
			VALUES		(#val(Cookie.SOFTWASSIGNID)#, #val(FORM.SOFTWINVENTID)#, TO_DATE('#FORM.ASSIGNDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
		</CFQUERY>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
			<TR>
				<TH align= "CENTER">
					Software Inventory Key &nbsp; = &nbsp; #FORM.SOFTWINVENTID# &nbsp;&nbsp;
					Assignments Key &nbsp; = &nbsp; #FORM.SOFTWASSIGNID#<BR />
					Assigned: &nbsp;&nbsp;#DateFormat(FORM.ASSIGNDATE, "mm/dd/yyyy")#
				</TH>
			</TR>
		</TABLE>
		<BR />
		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/#PROGRAMNAME#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="CANCELADD" />
					<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="ASSIGNMENTS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left">Title</TH>
				<TH align="left">Version - Platform</TH>
			</TR>
			<TR>
				<TD align="left">#LookupSoftwareInventory.TITLE#</TD>
				<TD align="left">#LookupSoftwareInventory.VERSION# - #LookupSoftwareInventory.PRODUCTPLATFORMNAME#</TD>
			</TR>
			<TR>
                    <TH align="left"><LABEL for="ASSIGNEDCUSTID">Assigned SW Customer</LABEL></TH>
				<TH align="left"><H4><LABEL for="SERIALNUMBER">*Serial Number</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
                    <CFIF IsDefined('URL.ASSIGNEDCUSTID')>
					<CFSELECT name="ASSIGNEDCUSTID" id="ASSIGNEDCUSTID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#URL.ASSIGNEDCUSTID#" required="No" tabindex="4"></CFSELECT>
                    <CFELSE>
                    	<CFSELECT name="ASSIGNEDCUSTID" id="ASSIGNEDCUSTID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="4"></CFSELECT>
                    </CFIF>
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="NO SERIAL ##" align="LEFT" required="No" size="50" maxlength="75" tabindex="3">
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="ASSIGNEDHARDWAREID">CPU Assigned - Division Number - HW Customer</LABEL></TH>
				<TH align="left">&nbsp;&nbsp;</TH>
			</TR>
			<TR>
				<TD align="left">
                     <CFIF IsDefined('URL.HARDWAREID')>
					<CFSELECT name="ASSIGNEDHARDWAREID" id="ASSIGNEDHARDWAREID" size="1" query="ListHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" selected="#URL.HARDWAREID#" tabindex="5"></CFSELECT>
                     <CFELSE>
                         <CFSELECT name="ASSIGNEDHARDWAREID" id="ASSIGNEDHARDWAREID" size="1" query="ListHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" selected="0" tabindex="5"></CFSELECT>
                     </CFIF>
				</TD>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
				<TH align="left">Modified Date</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" required="No" selected="#Client.CUSTOMERID#" tabindex="6"></CFSELECT>
				</TD>
				<TD align="left">
					#DateFormat(FORM.ASSIGNDATE, "MM/DD/YYYY")#<BR /><BR />
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.ASSIGNDATE#" />
				</TD>
			</TR>
			<TR>
               	<TD align="left">
                         <INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="ADD" />
                         <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="7" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/#PROGRAMNAME#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="CANCELADD" />
					<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="8" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>

<CFELSE>

<!--- 
**********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Software Assignments. *
**********************************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOKUPTITLE')>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
			<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
				<TH align="center"><H1>Lookup for Single Record Modify/Delete in IDT Software Inventory - Assignments</H1></TH>
			<CFELSE>
				<TH align="center"><H1>Lookup for Multiple Record Modify/Delete Loop in IDT Software Inventory - Assignments</H1></TH>
			</CFIF>
			</TR>
		</TABLE>
	
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>

		<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
			<CFSET VALIDATEREQUEST = 'return validateLookupField2();'>

			<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	SA.SOFTWASSIGNID, SA.SOFTWINVENTID, SI.TITLE, SI.VERSION, PP.PRODUCTPLATFORMNAME, SA.ASSIGNEDCUSTID, CUST.FULLNAME,
						SA.ASSIGNEDHARDWAREID, HI.HARDWAREID, HI.BARCODENUMBER,
						SI.TITLE || ' - ' || SI.VERSION || ' - ' || SA.SOFTWINVENTID || ' - ' || PP.PRODUCTPLATFORMNAME || ' - ' || CUST.FULLNAME || ' - ' || HI.BARCODENUMBER AS LOOKUPKEY
				FROM		SOFTWAREASSIGNMENTS SA, SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, LIBSHAREDDATAMGR.CUSTOMERS CUST,
						HARDWMGR.HARDWAREINVENTORY HI
				WHERE	SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
						SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
						SA.ASSIGNEDCUSTID = CUST.CUSTOMERID AND
						SA.ASSIGNEDHARDWAREID = HI.HARDWAREID
				ORDER BY	LOOKUPKEY
			</CFQUERY>

			<CFQUERY name="LookupCustomerSoftwareAssignments" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
				SELECT	CUST.FULLNAME, SA.ASSIGNEDCUSTID, SA.SOFTWASSIGNID, SA.SOFTWINVENTID, SI.TITLE, SI.VERSION, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME, 
						CUST.FULLNAME || ' - ' || SI.TITLE || ' - ' || SI.VERSION || ' - ' || SA.SOFTWINVENTID || ' - ' || PP.PRODUCTPLATFORMNAME AS LOOKUPKEY
				FROM		CUSTOMERS CUST, SOFTWMGR.SOFTWAREASSIGNMENTS SA, SOFTWMGR.SOFTWAREINVENTORY SI, SOFTWMGR.PRODUCTPLATFORMS PP
				WHERE	CUST.CUSTOMERID = SA.ASSIGNEDCUSTID AND
						SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
						SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
				ORDER BY	LOOKUPKEY
			</CFQUERY>

		<CFELSE>
			<CFSET VALIDATEREQUEST = 'return validateLookupField3();'>

			<CFQUERY name="LookupSoftwareInventoryRecordKeys" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	UNIQUE SI.SOFTWINVENTID, SA.SOFTWINVENTID, SI.SOFTWINVENTID || ' - ' || SI.TITLE AS LOOKUPKEY
				FROM		SOFTWAREINVENTORY SI, SOFTWAREASSIGNMENTS SA
				WHERE	SI.SOFTWINVENTID = SA.SOFTWINVENTID
				ORDER BY	LOOKUPKEY
			</CFQUERY>

		</CFIF>

		<BR />
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="#VALIDATEREQUEST#" action="/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=#URL.PROCESS#&LOOKUPTITLE=FOUND" method="POST">
		<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="SOFTWASSIGNID1">*Select by Title - Version - SW Key - Platform - Customer - Inventory Barcode</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%">
					<CFSELECT name="SOFTWASSIGNID1" id="SOFTWASSIGNID1" size="1" query="LookupSoftwareAssignments" value="SOFTWASSIGNID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="SOFTWASSIGNID2">*OR by Customer - Title - Version - SW Key - Platform</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%">
					<CFSELECT name="SOFTWASSIGNID2" id="SOFTWASSIGNID2" size="1" query="LookupCustomerSoftwareAssignments" value="SOFTWASSIGNID" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
		<CFELSE>
			<TR>
				<TH align="left" width="30%" valign="TOP"><H4><LABEL for="SOFTWINVENTID">*Select by SW Key - Title</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%" valign="TOP">
					<CFSELECT name="SOFTWINVENTID" id="SOFTWINVENTID" size="1" query="LookupSoftwareInventoryRecordKeys" value="SOFTWINVENTID" selected="0" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" width="30%" valign="TOP"><H4><LABEL for="ASSIGNEDHARDWAREID">*OR by CPU Assigned - Division Number - HW Customer</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%">
					<CFSELECT name="ASSIGNEDHARDWAREID" id="ASSIGNEDHARDWAREID" size="1" query="ListHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" selected="0" tabindex="3"></CFSELECT>
				</TD>
			</TR>
		</CFIF>
			<TR>
				<TD align="LEFT">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="CENTER"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
***********************************************************************************
* The following code is the Modify and Delete Processes for Software Assignments. *
***********************************************************************************
 --->

		<CFIF #URL.PROCESS# EQ 'MODIFYLOOP'>
			<CFIF NOT IsDefined('URL.LOOP')>
				<CFSET temp = ArraySet(session.SoftwareIDArray, 1, 1, 0)>
				<CFSET session.ArrayCounter = 1>

				<CFQUERY name="LookupSoftwareAssignmentIDs" datasource="#application.type#SOFTWARE">
					SELECT	SOFTWASSIGNID, SOFTWINVENTID, ASSIGNDATE, ASSIGNEDHARDWAREID, SERIALNUMBER, ASSIGNEDCUSTID,
							MODIFIEDBYID, MODIFIEDDATE
					FROM		SOFTWAREASSIGNMENTS
				<CFIF IsDefined('FORM.SOFTWINVENTID') AND #FORM.SOFTWINVENTID# GT 0>
					WHERE	SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
				<CFELSE>
					WHERE	ASSIGNEDHARDWAREID = <CFQUERYPARAM value="#FORM.ASSIGNEDHARDWAREID#" cfsqltype="CF_SQL_NUMERIC">
				</CFIF>
					ORDER BY	SOFTWASSIGNID
				</CFQUERY>

				<CFIF IsDefined('FORM.ASSIGNEDHARDWAREID') AND #FORM.ASSIGNEDHARDWAREID# GT 0 AND #LookupSoftwareAssignmentIDs.RecordCount# EQ 0>
					<SCRIPT language="JavaScript">
						<!-- 
							alert("Software Assignments for this Hardware Inventory Record were Not Found");
						--> 
					</SCRIPT>
					<META http-equiv="Refresh" content="0; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYLOOP" />
					<CFEXIT>
				</CFIF>

				<CFSET SOFTWAREASSIGNIDS = ValueList(LookupSoftwareAssignmentIDs.SOFTWASSIGNID)>
				<CFSET temp = ArraySet(session.SoftwareIDArray, 1, LISTLEN(SOFTWAREASSIGNIDS), 0)> 
				<CFSET session.SoftwareIDArray = ListToArray(SOFTWAREASSIGNIDS)>
				<CFSET FORM.SOFTWASSIGNID = session.SoftwareIDArray[session.ArrayCounter]>
				<!--- SOFTWARE ASSIGNMENT IDs = #SOFTWAREASSIGNIDS# --->
			<CFELSE>
				<CFSET session.ArrayCounter = session.ArrayCounter + 1>
				<CFSET FORM.SOFTWASSIGNID = session.SoftwareIDArray[session.ArrayCounter]>
			</CFIF>
		<CFELSE>
			<CFIF IsDefined('FORM.SOFTWASSIGNID1') AND #FORM.SOFTWASSIGNID1# GT 0>
				<CFSET FORM.SOFTWASSIGNID = #FORM.SOFTWASSIGNID1#>
			<CFELSE>
				<CFSET FORM.SOFTWASSIGNID = #FORM.SOFTWASSIGNID2#>
			</CFIF>
		</CFIF>

		<CFQUERY name="GetSoftwareAssignments" datasource="#application.type#SOFTWARE">
			SELECT	SOFTWASSIGNID, SOFTWINVENTID, ASSIGNDATE, ASSIGNEDHARDWAREID, SERIALNUMBER, ASSIGNEDCUSTID,
					MODIFIEDBYID, MODIFIEDDATE
			FROM		SOFTWAREASSIGNMENTS
			WHERE	SOFTWASSIGNID = <CFQUERYPARAM value="#FORM.SOFTWASSIGNID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SOFTWASSIGNID
		</CFQUERY>

		<CFQUERY name="GetSoftwareInventory" datasource="#application.type#SOFTWARE">
			SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SI.PRODDESCRIPTION, SI.PURCHREQLINEID, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
					SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
					SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE
			FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP 
			WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareAssignments.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
			ORDER BY	TITLE, VERSION, PRODPLATFORMID
		</CFQUERY>

		<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE">
			SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.DIVISIONNUMBER,
					HI.EQUIPMENTLOCATIONID, LOC.ROOMNUMBER, HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE
			FROM		HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC, EQUIPMENTTYPE ET
			WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetSoftwareAssignments.ASSIGNEDHARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
					HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
					HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID
			ORDER BY	HI.BARCODENUMBER
		</CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
			<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
				<TH align="center"><H1>Single Record Modify/Delete in IDT Software Inventory - Assignments</H1></TH>
			<CFELSE>
				<TH align="center"><H1>Multiple Record Modify/Delete Loop in IDT Software Inventory - Assignments</H1></TH>
			</CFIF>
			</TR>
		</TABLE>
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
			<TR>
				<TH align= "CENTER">
					Software Inventory Key &nbsp; = &nbsp; #GetSoftwareInventory.SOFTWINVENTID# &nbsp;&nbsp;
					Assignments Key &nbsp; = &nbsp; #GetSoftwareAssignments.SOFTWASSIGNID#<BR />
					Assigned: &nbsp;&nbsp;#DateFormat(GetSoftwareAssignments.ASSIGNDATE, "mm/dd/yyyy")#
					<CFCOOKIE name="SOFTWINVENTID" secure="NO" value="#GetSoftwareInventory.SOFTWINVENTID#">
					<CFCOOKIE name="SOFTWASSIGNID" secure="NO" value="#FORM.SOFTWASSIGNID#">
				</TH>
			</TR>
		</TABLE>
		<BR />
		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="ASSIGNMENTS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwareassignments.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left">Title</TH>
				<TH align="left">Version - Platform</TH>
			</TR>
			<TR>
				<TD align="left">#GetSoftwareInventory.TITLE#</TD>
				<TD align="left">#GetSoftwareInventory.VERSION# - #GetSoftwareInventory.PRODUCTPLATFORMNAME# </TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="ASSIGNEDCUSTID">Assigned SW Customer</LABEL></TH>
				<TH align="left"><H4><LABEL for="SERIALNUMBER">*Serial Number</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="ASSIGNEDCUSTID" id="ASSIGNEDCUSTID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#GetSoftwareAssignments.ASSIGNEDCUSTID#" required="No" tabindex="4"></CFSELECT>
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="#GetSoftwareAssignments.SERIALNUMBER#" align="LEFT" required="No" size="50" maxlength="75" tabindex="3">
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="ASSIGNEDHARDWAREID">CPU Assigned - Division Number - HW Customer</LABEL></TH>
				<TH align="left">State Found Number</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="ASSIGNEDHARDWAREID" id="ASSIGNEDHARDWAREID" size="1" query="ListHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" selected="#GetSoftwareAssignments.ASSIGNEDHARDWAREID#" tabindex="5"></CFSELECT>
				</TD>
				<TD align="left">
					#GetHardware.STATEFOUNDNUMBER#
				</TD>
			</TR>
			<TR>
				<TH align="left">Division Number</TH>
				<TH align="left">Loc</TH>
			</TR>
			<TR>
				<TD align="left">
					#GetHardware.DIVISIONNUMBER#
				</TD>
				<TD align="left">
					#GetHardware.ROOMNUMBER#
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
				<TH align="left">Modified Date</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="6"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#<BR /><BR />
				</TD>
			</TR>
		<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="7" />
				</TD>
			</TR>
			<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="8" />
                    </TD>
			</TR>
			</CFIF>
		<CFELSE>
			<TR>
               	<TD align="left" width="50%" valign="bottom">
                         <INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="MODIFYLOOP" /><BR />
                         <INPUT type="image" src="/images/buttonModifyLoop.jpg" value="MODIFYLOOP" alt="Modify Loop" tabindex="7" />		
                    </TD>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXTRECORD" alt="Next Record" OnClick="return setNextRecord();" tabindex="8" /><BR />
					<COM>(No change including Modified Date Field.)</COM>
				</TD>
			</TR>
			<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="image" src="/images/buttonDeleteLoop.jpg" value="DELETELOOP" alt="Delete Loop" OnClick="return setDeleteLoop();" tabindex="9" />
                    </TD>
			</TR>
			</CFIF>
		</CFIF>
	</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
	<CFFORM action="/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="10" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
	</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>