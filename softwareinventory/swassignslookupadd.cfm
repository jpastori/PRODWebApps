<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: swassignslookupadd.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: Lookup Multiple Record Add in IDT Software Inventory - Assignments --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/swassignslookupadd.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Lookup Multiple Record Add in IDT Software Inventory - Assignments</TITLE>
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


	function validateLookupField() {
		if (document.LOOKUP.SOFTWASSIGNID.selectedIndex == "0") {
			alertuser ("A Title MUST be selected!");
			document.LOOKUP.SOFTWASSIGNID.focus();
			return false;
		}
	}


	function setAddLoop() {
		document.ASSIGNMENTS.PROCESSSOFTWAREASSIGNMENTS.value = "ADDLOOP";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.SOFTWASSIGNID') AND NOT IsDefined('FORM.SOFTWASSIGNID')>
	<CFSET CURSORFIELD = "document.LOOKUP.SOFTWASSIGNID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.ASSIGNMENTS.ASSIGNEDHARDWAREID.focus()">
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

<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.DIVISIONNUMBER,
			HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE, HI.EQUIPMENTLOCATIONID, LOC.ROOMNUMBER, 
			HI.CUSTOMERID, CUST.FULLNAME, HI.BARCODENUMBER || ' - ' || HI.DIVISIONNUMBER || ' - ' || CUST.FULLNAME AS LOOKUPKEY
	FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE ET, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	(HI.HARDWAREID = 0 OR 
			HI.EQUIPMENTTYPEID = 1) AND
			HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
			HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
			HI.CUSTOMERID = CUST.CUSTOMERID
	ORDER BY	LOOKUPKEY
</CFQUERY>

<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, U.UNITNAME, CUST.CAMPUSPHONE,
			LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U, FACILITIESMGR.LOCATIONS LOC
	WHERE	(CUST.UNITID = U.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES') AND
			(U.DEPARTMENTID = 8 OR
			CUST.CUSTOMERID = 0)
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
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

<CFIF (NOT IsDefined('URL.SOFTWASSIGNID') AND NOT IsDefined('FORM.SOFTWASSIGNID'))>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Lookup for Multiple Record ADD in IDT Software Inventory - Assignments</H1></TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	</TABLE>

		<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SA.SOFTWASSIGNID, SA.SOFTWINVENTID, SI.TITLE, SI.VERSION, SI.PRODPLATFORMID, SI.PURCHREQLINEID,
					SA.ASSIGNDATE, SA.ASSIGNEDHARDWAREID, SA.SERIALNUMBER, SA.ASSIGNEDCUSTID, SA.MODIFIEDBYID, SA.MODIFIEDDATE,
					SA.SOFTWINVENTID || ' - ' || SI.TITLE || ' - ' || SI.VERSION || ' - ' || SA.SOFTWASSIGNID AS LOOKUPKEY
			FROM		SOFTWAREASSIGNMENTS SA, SOFTWAREINVENTORY SI
			WHERE	SA.SOFTWINVENTID = SI.SOFTWINVENTID 
			ORDER BY	SA.SOFTWINVENTID, SA.SOFTWASSIGNID
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/swassignslookupadd.cfm?PROCESS=#URL.PROCESS#" method="POST">
		<TR>
			<TH align="LEFT"><H4><LABEL for="SOFTWASSIGNID">*Select by SW Key - Title - Version - Assign Key</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<CFSELECT name="SOFTWASSIGNID" id="SOFTWASSIGNID" size="1" query="LookupSoftwareAssignments" value="SOFTWASSIGNID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="left">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
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

	<CFIF IsDefined('URL.SOFTWASSIGNID')>
		<CFSET FORM.SOFTWASSIGNID = URL.SOFTWASSIGNID>
	</CFIF>
	<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SOFTWARE">
		SELECT	SA.SOFTWASSIGNID, SA.SOFTWINVENTID, SI.TITLE, SI.VERSION, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME, SA.ASSIGNDATE,
				SA.ASSIGNEDHARDWAREID, SA.SERIALNUMBER, SA.ASSIGNEDCUSTID, SA.MODIFIEDBYID, SA.MODIFIEDDATE
		FROM		SOFTWAREASSIGNMENTS SA, SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP
		WHERE	SA.SOFTWASSIGNID = <CFQUERYPARAM value="#FORM.SOFTWASSIGNID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
		ORDER BY	SA.SOFTWINVENTID, SA.SOFTWASSIGNID
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Multiple Record Add in IDT Software Inventory - Assignments</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
		SELECT	MAX(SOFTWASSIGNID) AS MAX_ID
		FROM		SOFTWAREASSIGNMENTS
	</CFQUERY>
	<CFSET FORM.NEWSOFTWASSIGNID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFSET FORM.ASSIGNDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
	<CFCOOKIE name="SOFTWASSIGNID" secure="NO" value="#FORM.NEWSOFTWASSIGNID#">
	<CFQUERY name="AddSoftwareInventoryID" datasource="#application.type#SOFTWARE">
		INSERT INTO	SOFTWAREASSIGNMENTS (SOFTWASSIGNID, SOFTWINVENTID, ASSIGNDATE)
		VALUES		(#val(Cookie.SOFTWASSIGNID)#, #val(LookupSoftwareAssignments.SOFTWINVENTID)#, TO_DATE('#FORM.ASSIGNDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">
				Software Inventory Key &nbsp; = &nbsp; #LookupSoftwareAssignments.SOFTWINVENTID# &nbsp;&nbsp;
				Assignments Key &nbsp; = &nbsp; #Cookie.SOFTWASSIGNID#<BR />
				Assigned: &nbsp;&nbsp;#DateFormat(FORM.ASSIGNDATE, "mm/dd/yyyy")#
			</TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processsoftwareassignments.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="ASSIGNMENTS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwareassignments.cfm?PGMCALL=LOOKUPSA" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Title</TH>
			<TH align="left">Version - Platform</TH>
		</TR>
		<TR>
			<TD align="left">#LookupSoftwareAssignments.TITLE#</TD>
			<TD align="left">#LookupSoftwareAssignments.VERSION# - #LookupSoftwareAssignments.PRODUCTPLATFORMNAME#</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="ASSIGNEDCUSTID">Assigned SW Customer</LABEL></TH>
			<TH align="left"><H4><LABEL for="SERIALNUMBER">*Serial Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="ASSIGNEDCUSTID" id="ASSIGNEDCUSTID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#LookupSoftwareAssignments.ASSIGNEDCUSTID#" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="#LookupSoftwareAssignments.SERIALNUMBER#" align="LEFT" required="No" size="50" tabindex="3">
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="ASSIGNEDHARDWAREID">CPU Assigned - Division Number - HW Customer</LABEL></TH>
			<TH align="center" valign="BOTTOM">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="ASSIGNEDHARDWAREID" id="ASSIGNEDHARDWAREID" size="1" query="ListHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" selected="#LookupSoftwareAssignments.ASSIGNEDHARDWAREID#" tabindex="4"></CFSELECT>
			</TD>
			<TD align="center" valign="TOP"><DIV>&nbsp;&nbsp;</DIV></TD>
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
		<TR>
          	<TD align="left">
                    <INPUT type="image" src="/images/buttonAddLoop.jpg" value="ADDLOOP" alt="Add Loop" OnClick="return setAddLoop();" tabindex="8" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processsoftwareassignments.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="9" /><BR />
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

</BODY>
</CFOUTPUT>
</HTML>