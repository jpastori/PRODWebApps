<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwaremanuals.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: Add/Modify/Delete/Loop Information to IDT Software Inventory - Manuals--->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/softwaremanuals.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Software Inventory - Manuals</TITLE>
	<CFELSEIF #URL.PROCESS# EQ "MODIFYDELETE">
		<TITLE>Modify/Delete Information in IDT Software Inventory - Manuals</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Loop Information in IDT Software Inventory - Manuals</TITLE>
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

		if (document.MANUALS.MANUALSQTY.value == "" || document.MANUALS.MANUALSQTY.value == " ") {
			alertuser (document.MANUALS.MANUALSQTY.name +  ",  A Manuals Quantity MUST be entered!");
			document.MANUALS.MANUALSQTY.focus();
			return false;
		}

		if (document.MANUALS.LOCATIONID.selectedIndex == "0") {
			alertuser (document.MANUALS.LOCATIONID.name +  ",  A Manuals Location MUST be selected!");
			document.MANUALS.LOCATIONID.focus();
			return false;
		}

		if (document.MANUALS.PARTNUMBER.value == "" || document.MANUALS.PARTNUMBER.value == " ") {
			alertuser (document.MANUALS.PARTNUMBER.name +  ",  A Part Number MUST be entered!");
			document.MANUALS.PARTNUMBER.focus();
			return false;
		}

		if (document.MANUALS.TITLE.value == "" || document.MANUALS.TITLE.value == " ") {
			alertuser (document.MANUALS.TITLE.name +  ",  A Manuals Title MUST be entered!");
			document.MANUALS.TITLE.focus();
			return false;
		}
	}


	function validateLookupField() {
		if ((document.LOOKUP.MANUALSID1 != null && document.LOOKUP.MANUALSID1.selectedIndex == "0")
		 && (document.LOOKUP.MANUALSID2 != null && document.LOOKUP.MANUALSID2.selectedIndex == "0")) {
			alertuser ("A Manual Part Number or Title MUST be selected!");
			document.LOOKUP.MANUALSID1.focus();
			return false;
		}

		if ((document.LOOKUP.MANUALSID1 != null && document.LOOKUP.MANUALSID1.selectedIndex > "0")
		 && (document.LOOKUP.MANUALSID2 != null && document.LOOKUP.MANUALSID2.selectedIndex > "0")) {
			alertuser ("A Manual Part Number and Title can NOT both be selected!");
			document.LOOKUP.MANUALSID1.focus();
			return false;
		}

		if (document.LOOKUP.SOFTWINVENTID != null && document.LOOKUP.SOFTWINVENTID.selectedIndex == "0") {
			alertuser ("A Title MUST be selected!");
			document.LOOKUP.SOFTWINVENTID.focus();
			return false;
		}
	}


	function setAddLoop() {
		document.MANUALS.PROCESSSOFTWAREMANUALS.value = "ADDLOOP";
		return true;
	}


	function setNextRecord() {
		document.MANUALS.PROCESSSOFTWAREMANUALS.value = "NEXTRECORD";
		return true;
	}

	function setDelete() {
		document.MANUALS.PROCESSSOFTWAREMANUALS.value = "DELETE";
		return true;
	}


	function setDeleteLoop() {
		document.MANUALS.PROCESSSOFTWAREMANUALS.value = "DELETELOOP";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPTITLE') AND FIND('MODIFY', #URL.PROCESS#, 1) NEQ 0>
	<CFIF #URL.PROCESS# EQ 'MODIFYDELETE'>
		<CFSET CURSORFIELD = "document.LOOKUP.MANUALSID1.focus()">
	<CFELSE>
		<CFSET CURSORFIELD = "document.LOOKUP.SOFTWINVENTID.focus()">
	</CFIF>
<CFELSE>
	<CFSET CURSORFIELD = "document.MANUALS.MANUALSQTY.focus()">
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

<CFQUERY name="ListStoredLocations" datasource="#application.type#SOFTWARE" blockfactor="5">
	SELECT	STOREDLOCID, STOREDLOCTYPE, STOREDLOCNAME
	FROM		STOREDLOCATIONS
	WHERE	STOREDLOCID = 0 OR
			STOREDLOCTYPE = 'MANOTHER'
	ORDER BY	STOREDLOCNAME
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
***************************************************************
* The following code is the ADD Process for Software Manuals. *
***************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>

	<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE">
		SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SI.PRODDESCRIPTION, SI.PURCHREQLINEID, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
				SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
				SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE
		FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP 
		WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#URL.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
		ORDER BY	TITLE, VERSION, PRODPLATFORMID
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Software Inventory - Manuals</H1></TD>
		</TR>
	</TABLE>

		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
			SELECT	MAX(MANUALSID) AS MAX_ID
			FROM		MANUALS
		</CFQUERY>
		<CFSET FORM.MANUALSID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFSET FORM.CREATIONDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
		<CFCOOKIE name="MANUALSID" secure="NO" value="#FORM.MANUALSID#">
		<CFQUERY name="AddSoftwareInventoryID" datasource="#application.type#SOFTWARE">
			INSERT INTO	MANUALS (MANUALSID, SOFTWINVENTID, CREATIONDATE)
			VALUES		(#val(Cookie.MANUALSID)#, #val(URL.SOFTWINVENTID)#, TO_DATE('#FORM.CREATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
		</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">
				Software Inventory Key &nbsp; = &nbsp; #URL.SOFTWINVENTID# &nbsp;&nbsp;
				Manuals Key &nbsp; = &nbsp; #FORM.MANUALSID#<BR />
				Created: &nbsp;&nbsp;#DateFormat(FORM.CREATIONDATE, "mm/dd/yyyy")#
			</TH>
		</TR>
	</TABLE>
	<BR />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processsoftwaremanuals.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSOFTWAREMANUALS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="MANUALS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwaremanuals.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Title</TH>
			<TH align="left">Version - Platform</TH>
		</TR>
		<TR>
			<TD align="left">#LookupSoftwareInventory.TITLE#</TD>
			<TD align="left">#LookupSoftwareInventory.VERSION# - #LookupSoftwareInventory.PRODUCTPLATFORMNAME#</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="MANUALSQTY">*Manuals Quantity</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="LOCATIONID">*Manuals Location</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="MANUALSQTY" id="MANUALSQTY" value="" align="LEFT" required="No" size="18" tabindex="2">
			</TD>
			<TD align="left">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListStoredLocations" value="STOREDLOCID" display="STOREDLOCNAME" selected="0" required="NO" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PARTNUMBER">*Part Number</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="TITLE">*Manuals Title</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="PARTNUMBER" id="PARTNUMBER" value="" align="LEFT" required="No" size="35" maxlength="50" tabindex="4">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="TITLE" id="TITLE" value="" align="LEFT" required="No" size="100" maxlength="150" tabindex="5">
			</TD>
		</TR>	
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
			<TH align="left">Modified Date (Creation Date)</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="6"></CFSELECT>
			</TD>
			<TD align="left">
				#DateFormat(FORM.CREATIONDATE, "MM/DD/YYYY")#<BR><BR>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.CREATIONDATE#" />
			</TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSSOFTWAREMANUALS" value="ADD" />
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
<CFFORM action="/#application.type#apps/softwareinventory/processsoftwaremanuals.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSOFTWAREMANUALS" value="CANCELADD" /><BR /><BR />
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

<CFELSE>

<!--- 
******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Software Manuals. *
******************************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOKUPTITLE')>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
			<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
				<TH align="center"><H1>Lookup for Modify/Delete in IDT Software Inventory - Manuals</H1></TH>
			<CFELSE>
				<TH align="center"><H1>Lookup for Modify/Delete Loop in IDT Software Inventory - Manuals</H1></TH>
			</CFIF>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>

		<CFIF #URL.PROCESS# EQ "MODIFYDELETE">

			<CFQUERY name="LookupSoftwareManualsPart" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	MANUALSID, SOFTWINVENTID, CREATIONDATE, MANUALSQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE,
						PARTNUMBER || ' - ' || TITLE || ' - ' || SOFTWINVENTID AS LOOKUPKEY
				FROM		MANUALS
				ORDER BY	LOOKUPKEY
			</CFQUERY>

			<CFQUERY name="LookupSoftwareManualsTitle" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	MANUALSID, SOFTWINVENTID, CREATIONDATE, MANUALSQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE,
						TITLE || ' - ' || PARTNUMBER || ' - ' || SOFTWINVENTID AS LOOKUPKEY
				FROM		MANUALS
				ORDER BY	LOOKUPKEY
			</CFQUERY>

		<CFELSE>

			<CFQUERY name="LookupSoftwareInventoryRecordKeys" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	UNIQUE SI.SOFTWINVENTID, M.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID,
						PP.PRODUCTPLATFORMNAME, SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, SI.FISCALYEARID, SI.RECVDDATE,
						SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID,
						SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, MANUFWARRVENDORID, SI.MODIFIEDBYID,
						SI.MODIFIEDDATE, SI.SOFTWINVENTID || ' - ' || SI.TITLE AS LOOKUPKEY
				FROM		SOFTWAREINVENTORY SI, MANUALS M, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL,
						PURCHASEMGR.PURCHREQS PR
				WHERE	SI.SOFTWINVENTID = M.SOFTWINVENTID AND
						SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
						SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
						PRL.PURCHREQID = PR.PURCHREQID
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=#URL.PROCESS#&LOOKUPTITLE=FOUND" method="POST">
		<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="MANUALSID1">*Select by Part Number - Manual Title - SW Key</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%">
					<CFSELECT name="MANUALSID1" id="MANUALSID1" size="1" query="LookupSoftwareManualsPart" value="MANUALSID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="MANUALSID2">*OR Manual Title - Part Number - SW Key</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%">
					<CFSELECT name="MANUALSID2" id="MANUALSID2" size="1" query="LookupSoftwareManualsTitle" value="MANUALSID" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
		<CFELSE>
			<TR>
				<TH align="left" width="30%" valign="TOP"><H4><LABEL for="SOFTWINVENTID">*Select by SW Key - Title</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%" valign="TOP">
					<CFSELECT name="SOFTWINVENTID" id="SOFTWINVENTID" size="1" query="LookupSoftwareInventoryRecordKeys" value="SOFTWINVENTID" selected="0" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
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
*******************************************************************************
* The following code is the Modify and Delete Processes for Software Manuals. *
*******************************************************************************
 --->

		<CFIF #URL.PROCESS# EQ 'MODIFYLOOP'>
			<CFIF NOT IsDefined('URL.LOOP')>
				<CFSET temp = ArraySet(session.SoftwareIDArray, 1, 1, 0)>
				<CFSET session.ArrayCounter = 1>

				<CFQUERY name="LookupSoftwareManualIDs" datasource="#application.type#SOFTWARE">
					SELECT	MANUALSID, SOFTWINVENTID, CREATIONDATE, MANUALSQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE
					FROM		MANUALS
					WHERE	SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
					ORDER BY	TITLE
				</CFQUERY>

				<CFSET MANUALIDS = #ValueList(LookupSoftwareManualIDs.MANUALSID)#>
				<CFSET temp = ArraySet(session.SoftwareIDArray, 1, LISTLEN(MANUALIDS), 0)> 
				<CFSET session.SoftwareIDArray = ListToArray(MANUALIDS)>
				<CFSET FORM.MANUALSID = session.SoftwareIDArray[session.ArrayCounter]>
				<!--- SOFTWARE MANUAL IDs = #MANUALIDS# --->
			<CFELSE>
				<CFSET session.ArrayCounter = session.ArrayCounter + 1>
				<CFSET FORM.MANUALSID = session.SoftwareIDArray[session.ArrayCounter]>
			</CFIF>
		<CFELSE>
			<CFIF IsDefined('FORM.MANUALSID1') AND #FORM.MANUALSID1# GT 0>
				<CFSET FORM.MANUALSID = #FORM.MANUALSID1#>
			<CFELSE>
				<CFSET FORM.MANUALSID = #FORM.MANUALSID2#>
			</CFIF>
		</CFIF>

		<CFQUERY name="GetSoftwareManuals" datasource="#application.type#SOFTWARE">
			SELECT	MANUALSID, SOFTWINVENTID, CREATIONDATE, MANUALSQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE
			FROM		MANUALS
			WHERE	MANUALSID = <CFQUERYPARAM value="#FORM.MANUALSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	TITLE
		</CFQUERY>

		<CFQUERY name="GetSoftwareInventory" datasource="#application.type#SOFTWARE">
			SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SI.PRODDESCRIPTION, SI.PURCHREQLINEID, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
					SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
					SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE
			FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP 
			WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareManuals.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
			ORDER BY	TITLE, VERSION, PRODPLATFORMID
		</CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
			<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
				<TH align="center"><H1>Modify/Delete in IDT Software Inventory - Manuals</H1></TH>
			<CFELSE>
				<TH align="center"><H1>Modify/Delete Loop in IDT Software Inventory - Manuals</H1></TH>
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
					Manuals Key &nbsp; = &nbsp; #GetSoftwareManuals.MANUALSID#<BR />
					Created: &nbsp;&nbsp;#DateFormat(GetSoftwareInventory.CREATIONDATE, "mm/dd/yyyy")#
					<CFCOOKIE name="MANUALSID" secure="NO" value="#GetSoftwareManuals.MANUALSID#">
				</TH>
			</TR>
		</TABLE>
		<BR />
		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="MANUALS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwaremanuals.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Title</TH>
			<TH align="left">Version - Platform</TH>
		</TR>
		<TR>
			<TD align="left">#GetSoftwareInventory.TITLE#</TD>
			<TD align="left">#GetSoftwareInventory.VERSION# - #GetSoftwareInventory.PRODUCTPLATFORMNAME#</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="MANUALSQTY">*Manuals Quantity</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="LOCATIONID">*Manuals Location</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="MANUALSQTY" id="MANUALSQTY" value="#GetSoftwareManuals.MANUALSQTY#" align="LEFT" required="No" size="18" tabindex="2">
			</TD>
			<TD align="left">
				<CFSELECT name="LOCATIONID" size="1" id="LOCATIONID" query="ListStoredLocations" value="STOREDLOCID" display="STOREDLOCNAME" selected="#GetSoftwareManuals.LOCATIONID#" required="NO" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PARTNUMBER">*Part Number</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="TITLE">*Manuals Title</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="PARTNUMBER" id="PARTNUMBER" value="#GetSoftwareManuals.PARTNUMBER#" align="LEFT" required="No" size="35" maxlength="50" tabindex="4">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="TITLE" id="TITLE" value="#GetSoftwareManuals.TITLE#" align="LEFT" required="No" size="100" maxlength="150" tabindex="5">
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
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#<BR><BR>
				</TD>
			</TR>
		<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSSOFTWAREMANUALS" value="MODIFY" />
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
                         <INPUT type="hidden" name="PROCESSSOFTWAREMANUALS" value="MODIFYLOOP" /><BR />
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
<CFFORM action="/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=#URL.PROCESS#" method="POST">
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