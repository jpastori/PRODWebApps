<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwaremedia.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012--->
<!--- Module: Add/Modify/Delete Information to IDT Software Inventory - Media--->
<!-- Last modified by John R. Pastori 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/softwaremedia.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Software Inventory - Media</TITLE>
	<CFELSEIF #URL.PROCESS# EQ "MODIFYDELETE">
		<TITLE>Modify/Delete Information in IDT Software Inventory - Media</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Loop Information in IDT Software Inventory - Media</TITLE>
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

		if (document.MEDIA.MEDIATYPEID.selectedIndex == "0") {
			alertuser (document.MEDIA.MEDIATYPEID.name +  ",  A Media Type MUST be selected!");
			document.MEDIA.MEDIATYPEID.focus();
			return false;
		}

		if (document.MEDIA.MEDIAQTY.value == "" || document.MEDIA.MEDIAQTY.value == " ") {
			alertuser (document.MEDIA.MEDIAQTY.name +  ",  A Media Quantity MUST be entered!");
			document.MEDIA.MEDIAQTY.focus();
			return false;
		}

		if (document.MEDIA.LOCATIONID.selectedIndex == "0") {
			alertuser (document.MEDIA.LOCATIONID.name +  ",  A Media Location MUST be selected!");
			document.MEDIA.LOCATIONID.focus();
			return false;
		}

		if (document.MEDIA.PARTNUMBER.value == "" || document.MEDIA.PARTNUMBER.value == " ") {
			alertuser (document.MEDIA.PARTNUMBER.name +  ",  A Part Number MUST be entered!");
			document.MEDIA.PARTNUMBER.focus();
			return false;
		}

		if (document.MEDIA.TITLE.value == "" || document.MEDIA.TITLE.value == " ") {
			alertuser (document.MEDIA.TITLE.name +  ",  A Media Title MUST be entered!");
			document.MEDIA.TITLE.focus();
			return false;
		}
	}


		function validateLookupField() {
		if ((document.LOOKUP.MEDIAID1 != null && document.LOOKUP.MEDIAID1.selectedIndex == "0")
		 && (document.LOOKUP.MEDIAID2 != null && document.LOOKUP.MEDIAID2.selectedIndex == "0")) {
			alertuser ("A Media Part Number or Title MUST be selected!");
			document.LOOKUP.MEDIAID1.focus();
			return false;
		}

		if ((document.LOOKUP.MEDIAID1 != null && document.LOOKUP.MEDIAID1.selectedIndex > "0")
		 && (document.LOOKUP.MEDIAID2 != null && document.LOOKUP.MEDIAID2.selectedIndex > "0")) {
			alertuser ("A Media Part Number and Title can NOT both be selected!");
			document.LOOKUP.MEDIAID1.focus();
			return false;
		}

		if (document.LOOKUP.SOFTWINVENTID != null && document.LOOKUP.SOFTWINVENTID.selectedIndex == "0") {
			alertuser ("A Title MUST be selected!");
			document.LOOKUP.SOFTWINVENTID.focus();
			return false;
		}
	}


	function setAddLoop() {
		document.MEDIA.PROCESSSOFTWAREMEDIA.value = "ADDLOOP";
		return true;
	}


	function setNextRecord() {
		document.MEDIA.PROCESSSOFTWAREMEDIA.value = "NEXTRECORD";
		return true;
	}

	function setDelete() {
		document.MEDIA.PROCESSSOFTWAREMEDIA.value = "DELETE";
		return true;
	}


	function setDeleteLoop() {
		document.MEDIA.PROCESSSOFTWAREMEDIA.value = "DELETELOOP";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPTITLE') AND FIND('MODIFY', #URL.PROCESS#, 1) NEQ 0>
	<CFIF #URL.PROCESS# EQ 'MODIFYDELETE'>
		<CFSET CURSORFIELD = "document.LOOKUP.MEDIAID1.focus()">
	<CFELSE>
		<CFSET CURSORFIELD = "document.LOOKUP.SOFTWINVENTID.focus()">
	</CFIF>
<CFELSE>
	<CFSET CURSORFIELD = "document.MEDIA.MEDIATYPEID.focus()">
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

<CFQUERY name="ListMediaType" datasource="#application.type#SOFTWARE" blockfactor="13">
	SELECT	MEDIATYPEID, MEDIATYPENAME
	FROM		MEDIATYPES
	ORDER BY	MEDIATYPENAME
</CFQUERY>

<CFQUERY name="ListStoredLocations" datasource="#application.type#SOFTWARE" blockfactor="10">
	SELECT	STOREDLOCID, STOREDLOCTYPE, STOREDLOCNAME
	FROM		STOREDLOCATIONS
	WHERE	STOREDLOCID = 0 OR
			STOREDLOCTYPE = 'MEDIA'
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
*************************************************************
* The following code is the ADD Process for Software Media. *
*************************************************************
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
			<TD align="center"><H1>Add Information to IDT Software Inventory - Media</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
			SELECT	MAX(MEDIAID) AS MAX_ID
			FROM		MEDIA
		</CFQUERY>
		<CFSET FORM.MEDIAID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFSET FORM.CREATIONDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
		<CFCOOKIE name="MEDIAID" secure="NO" value="#FORM.MEDIAID#">
		<CFQUERY name="AddSoftwareInventoryID" datasource="#application.type#SOFTWARE">
			INSERT INTO	MEDIA (MEDIAID, SOFTWINVENTID, CREATIONDATE)
			VALUES		(#val(Cookie.MEDIAID)#, #val(URL.SOFTWINVENTID)#, TO_DATE('#FORM.CREATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required! </H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">
				Software Inventory Key &nbsp; = &nbsp; #URL.SOFTWINVENTID# &nbsp;&nbsp;
				Media Key &nbsp; = &nbsp; #FORM.MEDIAID#<BR />
				Created: &nbsp;&nbsp;#DateFormat(FORM.CREATIONDATE, "mm/dd/yyyy")#
			</TH>
		</TR>
	</TABLE>
	<BR />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processsoftwaremedia.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSOFTWAREMEDIA" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="MEDIA" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwaremedia.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Title</TH>
			<TH align="left">Version - Platform</TH>
		</TR>
		<TR>
			<TD align="left">#LookupSoftwareInventory.TITLE#</TD>
			<TD align="left">#LookupSoftwareInventory.VERSION# - #LookupSoftwareInventory.PRODUCTPLATFORMNAME#</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="MEDIATYPEID">*Media Type</LABEL></H4></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="MEDIATYPEID" id="MEDIATYPEID" size="1" query="ListMediaType" value="MEDIATYPEID" display="MEDIATYPENAME" selected="0" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="MEDIAQTY">*Media Quantity</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="LOCATIONID">*Media Location</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="MEDIAQTY" id="MEDIAQTY" value="" align="LEFT" required="No" size="18" tabindex="3">
			</TD>
			<TD align="left">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListStoredLocations" value="STOREDLOCID" display="STOREDLOCNAME" selected="0" required="NO" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PARTNUMBER">*Part Number</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="TITLE">*Media Title</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="PARTNUMBER" id="PARTNUMBER" value="" align="LEFT" required="No" size="35" maxlength="50" tabindex="5">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="TITLE" id="TITLE" value="" align="LEFT" required="No" size="100" maxlength="150" tabindex="6">
			</TD>
		</TR>	
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
			<TH align="left">Modified Date (Creation Date)</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="7"></CFSELECT>
			</TD>
			<TD align="left">
				#DateFormat(FORM.CREATIONDATE, "MM/DD/YYYY")#<BR><BR>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.CREATIONDATE#" />
			</TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSSOFTWAREMEDIA" value="ADD" />
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
<CFFORM action="/#application.type#apps/softwareinventory/processsoftwaremedia.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSOFTWAREMEDIA" value="CANCELADD" /><BR /><BR />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="10" /><BR />
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
****************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Software Media. *
****************************************************************************************
 --->

	<CFIF NOT IsDefined("URL.LOOKUPTITLE")>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
			</TR><TR align="center">
			<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
				<TH align="center"><H1>Lookup for Modify/Delete in IDT Software Inventory - Media</H1></TH>
			<CFELSE>
				<TH align="center"><H1>Lookup for Modify/Delete Loop in IDT Software Inventory - Media</H1></TH>
			</CFIF>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>

		<CFIF #URL.PROCESS# EQ "MODIFYDELETE">

			<CFQUERY name="LookupSoftwareMediaPart" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	MEDIAID, SOFTWINVENTID, MEDIATYPEID, CREATIONDATE, MEDIAQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE,
						PARTNUMBER || ' - ' || TITLE || ' - ' || SOFTWINVENTID AS LOOKUPKEY
				FROM		MEDIA
				ORDER BY	LOOKUPKEY
			</CFQUERY>

			<CFQUERY name="LookupSoftwareMediaTitle" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	MEDIAID, SOFTWINVENTID, MEDIATYPEID, CREATIONDATE, MEDIAQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE,
						TITLE || ' - ' || PARTNUMBER || ' - ' || SOFTWINVENTID AS LOOKUPKEY
				FROM		MEDIA
				ORDER BY	LOOKUPKEY
			</CFQUERY>

		<CFELSE>

			<CFQUERY name="LookupSoftwareInventoryRecordKeys" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	UNIQUE SI.SOFTWINVENTID, M.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID,
						PP.PRODUCTPLATFORMNAME, SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, SI.FISCALYEARID, SI.RECVDDATE,
						SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID,
						SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, MANUFWARRVENDORID, SI.MODIFIEDBYID,
						SI.MODIFIEDDATE, SI.SOFTWINVENTID || ' - ' || SI.TITLE AS LOOKUPKEY
				FROM		SOFTWAREINVENTORY SI, MEDIA M, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL,
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=#URL.PROCESS#&LOOKUPTITLE=FOUND" method="POST">
		<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="MEDIAID1">*Select by Part Number - Media Title - SW Key</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%">
					<CFSELECT name="MEDIAID1" id="MEDIAID1" size="1" query="LookupSoftwareMediaPart" value="MEDIAID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="MEDIAID2">*OR Media Title - Part Number - SW Key</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%">
					<CFSELECT name="MEDIAID2" id="MEDIAID2" size="1" query="LookupSoftwareMediaTitle" value="MEDIAID" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
		<CFELSE>
			<TR>
				<TH align="left" valign="TOP"><H4><LABEL for="SOFTWINVENTID">*Select by SW Key - Title</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" valign="TOP">
					<CFSELECT name="SOFTWINVENTID" id="SOFTWINVENTID" size="1" query="LookupSoftwareInventoryRecordKeys" value="SOFTWINVENTID" selected="0" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
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
*****************************************************************************
* The following code is the Modify and Delete Processes for Software Media. *
*****************************************************************************
 --->

		<CFIF #URL.PROCESS# EQ 'MODIFYLOOP'>
			<CFIF NOT IsDefined('URL.LOOP')>
				<CFSET temp = ArraySet(session.SoftwareIDArray, 1, 1, 0)>
				<CFSET session.ArrayCounter = 1>

				<CFQUERY name="LookupSoftwareMediaIDs" datasource="#application.type#SOFTWARE">
					SELECT	MEDIAID, SOFTWINVENTID, MEDIATYPEID, CREATIONDATE, MEDIAQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE
					FROM		MEDIA
					WHERE	SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
					ORDER BY	MEDIATYPEID, TITLE
				</CFQUERY>

				<CFSET MEDIAIDS = #ValueList(LookupSoftwareMediaIDs.MEDIAID)#>
				<CFSET temp = ArraySet(session.SoftwareIDArray, 1, LISTLEN(MEDIAIDS), 0)> 
				<CFSET session.SoftwareIDArray = ListToArray(MEDIAIDS)>
				<CFSET FORM.MEDIAID = session.SoftwareIDArray[session.ArrayCounter]>
				<!--- SOFTWARE MEDIA IDs = #MEDIAIDS# --->
			<CFELSE>
				<CFSET session.ArrayCounter = session.ArrayCounter + 1>
				<CFSET FORM.MEDIAID = session.SoftwareIDArray[session.ArrayCounter]>
			</CFIF>
		<CFELSE>
			<CFIF IsDefined('FORM.MEDIAID1') AND #FORM.MEDIAID1# GT 0>
				<CFSET FORM.MEDIAID = #FORM.MEDIAID1#>
			<CFELSE>
				<CFSET FORM.MEDIAID = #FORM.MEDIAID2#>
			</CFIF>
		</CFIF>

		<CFQUERY name="GetSoftwareMedia" datasource="#application.type#SOFTWARE">
			SELECT	MEDIAID, SOFTWINVENTID, MEDIATYPEID, CREATIONDATE, MEDIAQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE
			FROM		MEDIA
			WHERE	MEDIAID = <CFQUERYPARAM value="#FORM.MEDIAID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	MEDIATYPEID, TITLE
		</CFQUERY>

		<CFQUERY name="GetSoftwareInventory" datasource="#application.type#SOFTWARE">
			SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SI.PRODDESCRIPTION, SI.PURCHREQLINEID, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
					SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
					SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE
			FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP 
			WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareMedia.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
			ORDER BY	TITLE, VERSION, PRODPLATFORMID
		</CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
			<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
				<TH align="center"><H1>Modify/Delete in IDT Software Inventory - Media</H1></TH>
			<CFELSE>
				<TH align="center"><H1>Modify/Delete Loop in IDT Software Inventory - Media</H1></TH>
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
					Media Key &nbsp; = &nbsp; #GetSoftwareMedia.MEDIAID#<BR />
					Created: &nbsp;&nbsp;#DateFormat(GetSoftwareInventory.CREATIONDATE, "mm/dd/yyyy")#
					<CFCOOKIE name="MEDIAID" secure="NO" value="#GetSoftwareMedia.MEDIAID#">
				</TH>
			</TR>
		</TABLE>
		<BR />
		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="MEDIA" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwaremedia.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Title</TH>
			<TH align="left">Version - Platform</TH>
		</TR>
		<TR>
			<TD align="left">#GetSoftwareInventory.TITLE#</TD>
			<TD align="left">#GetSoftwareInventory.VERSION# - #GetSoftwareInventory.PRODUCTPLATFORMNAME#</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="MEDIATYPEID">*Media Type</LABEL></H4></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="MEDIATYPEID" id="MEDIATYPEID" size="1" query="ListMediaType" value="MEDIATYPEID" display="MEDIATYPENAME" selected="#GetSoftwareMedia.MEDIATYPEID#" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="MEDIAQTY">*Media Quantity</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="LOCATIONID">*Media Location</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="MEDIAQTY" id="MEDIAQTY" value="#GetSoftwareMedia.MEDIAQTY#" align="LEFT" required="No" size="18" tabindex="3">
			</TD>
			<TD align="left">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListStoredLocations" value="STOREDLOCID" display="STOREDLOCNAME" selected="#GetSoftwareMedia.LOCATIONID#" required="NO" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PARTNUMBER">*Part Number</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="TITLE">*Media Title</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="PARTNUMBER" id="PARTNUMBER" value="#GetSoftwareMedia.PARTNUMBER#" align="LEFT" required="No" size="35" maxlength="50" tabindex="5">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="TITLE" id="TITLE" value="#GetSoftwareMedia.TITLE#" align="LEFT" required="No" size="100" maxlength="150" tabindex="6">
			</TD>
		</TR>	
			<TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
				<TH align="left">Modified Date</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="7"></CFSELECT>
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
                    	<INPUT type="hidden" name="PROCESSSOFTWAREMEDIA" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="8" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="9" />
                    </TD>
			</TR>
			</CFIF>
		<CFELSE>
			<TR>
               	<TD align="left" width="50%" valign="bottom">
                         <INPUT type="hidden" name="PROCESSSOFTWAREMEDIA" value="MODIFYLOOP" /><BR />
                         <INPUT type="image" src="/images/buttonModifyLoop.jpg" value="MODIFYLOOP" alt="Modify Loop" tabindex="8" />		
                    </TD>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXTRECORD" alt="Next Record" OnClick="return setNextRecord();" tabindex="9" /><BR />
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
                    	<INPUT type="image" src="/images/buttonDeleteLoop.jpg" value="DELETELOOP" alt="Delete Loop" OnClick="return setDeleteLoop();" tabindex="10" />
                    </TD>
			</TR>
			</CFIF>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="11" /><BR />
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