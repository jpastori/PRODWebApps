<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwareotheritems.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Software Inventory - Other Items--->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/softwareotheritems.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Software Inventory - Other Items</TITLE>
	<CFELSEIF #URL.PROCESS# EQ "MODIFYDELETE">
		<TITLE>Modify/Delete Information in IDT Software Inventory - Other Items</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Loop Information in IDT Software Inventory - Other Items</TITLE>
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

		if (document.OTHERITEMS.OTHERITEMSQTY.value == "" || document.OTHERITEMS.OTHERITEMSQTY.value == " ") {
			alertuser (document.OTHERITEMS.OTHERITEMSQTY.name +  ",  An Other Items Quantity MUST be entered!");
			document.OTHERITEMS.OTHERITEMSQTY.focus();
			return false;
		}

		if (document.OTHERITEMS.LOCATIONID.selectedIndex == "0") {
			alertuser (document.OTHERITEMS.LOCATIONID.name +  ",  An Other Items Location MUST be selected!");
			document.OTHERITEMS.LOCATIONID.focus();
			return false;
		}

		if (document.OTHERITEMS.OTHERITEMSQTY.value == "" || document.OTHERITEMS.OTHERITEMSQTY.value == " ") {
			alertuser (document.OTHERITEMS.OTHERITEMSQTY.name +  ",  A Other Items Quantity MUST be entered!");
			document.OTHERITEMS.OTHERITEMSQTY.focus();
			return false;
		}

		if (document.OTHERITEMS.PARTNUMBER.value == "" || document.OTHERITEMS.PARTNUMBER.value == " ") {
			alertuser (document.OTHERITEMS.PARTNUMBER.name +  ",  A Part Number MUST be entered!");
			document.OTHERITEMS.PARTNUMBER.focus();
			return false;
		}

		if (document.OTHERITEMS.TITLE.value == "" || document.OTHERITEMS.TITLE.value == " ") {
			alertuser (document.OTHERITEMS.TITLE.name +  ",  An Other Items Title MUST be entered!");
			document.OTHERITEMS.TITLE.focus();
			return false;
		}
	}


		function validateLookupField() {
		if ((document.LOOKUP.OTHERITEMSID1 != null && document.LOOKUP.OTHERITEMSID1.selectedIndex == "0") 
		 && (document.LOOKUP.OTHERITEMSID2 != null && document.LOOKUP.OTHERITEMSID2.selectedIndex == "0")) {
			alertuser ("A Other Items Part Number or Title MUST be selected!");
			document.LOOKUP.OTHERITEMSID1.focus();
			return false;
		}

		if ((document.LOOKUP.OTHERITEMSID1 != null && document.LOOKUP.OTHERITEMSID1.selectedIndex > "0")
		 && (document.LOOKUP.OTHERITEMSID2 != null && document.LOOKUP.OTHERITEMSID2.selectedIndex > "0")) {
			alertuser ("A Other Items Part Number and Title can NOT both be selected!");
			document.LOOKUP.OTHERITEMSID1.focus();
			return false;
		}

		if (document.LOOKUP.SOFTWINVENTID != null && document.LOOKUP.SOFTWINVENTID.selectedIndex == "0") {
			alertuser ("A Title MUST be selected!");
			document.LOOKUP.SOFTWINVENTID.focus();
			return false;
		}
	}


	function setAddLoop() {
		document.OTHERITEMS.PROCESSSOFTWAREOTHERITEMS.value = "ADDLOOP";
		return true;
	}


	function setNextRecord() {
		document.OTHERITEMS.PROCESSSOFTWAREOTHERITEMS.value = "NEXTRECORD";
		return true;
	}

	function setDelete() {
		document.OTHERITEMS.PROCESSSOFTWAREOTHERITEMS.value = "DELETE";
		return true;
	}


	function setDeleteLoop() {
		document.OTHERITEMS.PROCESSSOFTWAREOTHERITEMS.value = "DELETELOOP";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPTITLE') AND FIND('MODIFY', #URL.PROCESS#, 1) NEQ 0>
	<CFIF #URL.PROCESS# EQ 'MODIFYDELETE'>
		<CFSET CURSORFIELD = "document.LOOKUP.OTHERITEMSID1.focus()">
	<CFELSE>
		<CFSET CURSORFIELD = "document.LOOKUP.SOFTWINVENTID.focus()">
	</CFIF>
<CFELSE>
	<CFSET CURSORFIELD = "document.OTHERITEMS.OTHERITEMSQTY.focus()">
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
******************************************************************
* The following code is the ADD Process for Software OtherItems. *
******************************************************************
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
			<TD align="center"><H1>Add Information to IDT Software Inventory - Other Items</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
		SELECT	MAX(OTHERITEMSID) AS MAX_ID
		FROM		OTHERITEMS
	</CFQUERY>
	<CFSET FORM.OTHERITEMSID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFSET FORM.CREATIONDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
	<CFCOOKIE name="OTHERITEMSID" secure="NO" value="#FORM.OTHERITEMSID#">
	<CFQUERY name="AddSoftwareInventoryID" datasource="#application.type#SOFTWARE">
		INSERT INTO	OTHERITEMS (OTHERITEMSID, SOFTWINVENTID, CREATIONDATE)
		VALUES		(#val(Cookie.OTHERITEMSID)#, #val(URL.SOFTWINVENTID)#, TO_DATE('#FORM.CREATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">
				Software Inventory Key &nbsp; = &nbsp; #URL.SOFTWINVENTID# &nbsp;&nbsp;
				OtherItems Key &nbsp; = &nbsp; #FORM.OTHERITEMSID#<BR />
				Created: &nbsp;&nbsp;#DateFormat(FORM.CREATIONDATE, "mm/dd/yyyy")#
			</TH>
		</TR>
	</TABLE>
	<BR />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processsoftwareotheritems.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSOFTWAREOTHERITEMS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="OTHERITEMS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwareotheritems.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Title</TH>
			<TH align="left">Version - Platform</TH>
		</TR>
		<TR>
			<TD align="left">#LookupSoftwareInventory.TITLE#</TD>
			<TD align="left">#LookupSoftwareInventory.VERSION# - #LookupSoftwareInventory.PRODUCTPLATFORMNAME#</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="OTHERITEMSQTY">*OtherItems Quantity</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="LOCATIONID">*OtherItems Location</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="OTHERITEMSQTY" id="OTHERITEMSQTY" value="" align="LEFT" required="No" size="18" tabindex="2">
			</TD>
			<TD align="left">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListStoredLocations" value="STOREDLOCID" display="STOREDLOCNAME" selected="0" required="NO" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PARTNUMBER">*Part Number</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="TITLE">*OtherItems Title</LABEL></H4></TH>
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
               	<INPUT type="hidden" name="PROCESSSOFTWAREOTHERITEMS" value="ADD" />
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
<CFFORM action="/#application.type#apps/softwareinventory/processsoftwareotheritems.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSOFTWAREOTHERITEMS" value="CANCELADD" /><BR /><BR />
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
*********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Software OtherItems. *
*********************************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOKUPTITLE')>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
			<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
				<TH align="center"><H1>Lookup for Modify/Delete in IDT Software Inventory - Other Items</H1></TH>
			<CFELSE>
				<TH align="center"><H1>Lookup for Modify/Delete Loop in IDT Software Inventory - Other Items</H1></TH>
			</CFIF>
			</TR>
		</TABLE>
	
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>

		<CFIF #URL.PROCESS# EQ "MODIFYDELETE">

			<CFQUERY name="LookupSoftwareOtherItemsPart" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	OTHERITEMSID, SOFTWINVENTID, CREATIONDATE, OTHERITEMSQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE,
						PARTNUMBER || ' - ' || TITLE || ' - ' || SOFTWINVENTID AS LOOKUPKEY
				FROM		OTHERITEMS
				ORDER BY	LOOKUPKEY
			</CFQUERY>

			<CFQUERY name="LookupSoftwareOtherItemsTitle" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	OTHERITEMSID, SOFTWINVENTID, CREATIONDATE, OTHERITEMSQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE,
						TITLE || ' - ' || PARTNUMBER || ' - ' || SOFTWINVENTID AS LOOKUPKEY
				FROM		OTHERITEMS
				ORDER BY	LOOKUPKEY
			</CFQUERY>

		<CFELSE>

			<CFQUERY name="LookupSoftwareInventoryRecordKeys" datasource="#application.type#SOFTWARE" blockfactor="100">
				SELECT	UNIQUE SI.SOFTWINVENTID, OI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID,
						PP.PRODUCTPLATFORMNAME, SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, SI.FISCALYEARID, SI.RECVDDATE,
						SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID,
						SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, MANUFWARRVENDORID, SI.MODIFIEDBYID,
						SI.MODIFIEDDATE, SI.SOFTWINVENTID || ' - ' || SI.TITLE AS LOOKUPKEY
				FROM		SOFTWAREINVENTORY SI, OTHERITEMS OI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL,
						PURCHASEMGR.PURCHREQS PR
				WHERE	SI.SOFTWINVENTID = OI.SOFTWINVENTID AND
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=#URL.PROCESS#&LOOKUPTITLE=FOUND" method="POST">
		<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="OTHERITEMSID1">*Select by Part Number - Other Items Title - SW Key</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%">
					<CFSELECT name="OTHERITEMSID1" id="OTHERITEMSID1" size="1" query="LookupSoftwareOtherItemsPart" value="OTHERITEMSID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="OTHERITEMSID2">*OR Other Items Title - Part Number - SW Key</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT" width="70%">
					<CFSELECT name="OTHERITEMSID2" id="OTHERITEMSID2" size="1" query="LookupSoftwareOtherItemsTitle" value="OTHERITEMSID" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
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
**********************************************************************************
* The following code is the Modify and Delete Processes for Software OtherItems. *
**********************************************************************************
 --->

		<CFIF #URL.PROCESS# EQ 'MODIFYLOOP'>
			<CFIF NOT IsDefined('URL.LOOP')>
				<CFSET temp = ArraySet(session.SoftwareIDArray, 1, 1, 0)>
				<CFSET session.ArrayCounter = 1>

				<CFQUERY name="LookupSoftwareOtherItemIDs" datasource="#application.type#SOFTWARE">
					SELECT	OTHERITEMSID, SOFTWINVENTID, CREATIONDATE, OTHERITEMSQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE
					FROM		OTHERITEMS
					WHERE	SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
					ORDER BY	TITLE
				</CFQUERY>

				<CFSET OTHERITEMIDS = #ValueList(LookupSoftwareOtherItemIDs.OTHERITEMSID)#>
				<CFSET temp = ArraySet(session.SoftwareIDArray, 1, LISTLEN(OTHERITEMIDS), 0)> 
				<CFSET session.SoftwareIDArray = ListToArray(OTHERITEMIDS)>
				<CFSET FORM.OTHERITEMSID = session.SoftwareIDArray[session.ArrayCounter]>
				<!--- SOFTWARE OTHER ITEM IDs = #OTHERITEMIDS# --->
			<CFELSE>
				<CFSET session.ArrayCounter = session.ArrayCounter + 1>
				<CFSET FORM.OTHERITEMSID = session.SoftwareIDArray[session.ArrayCounter]>
			</CFIF>
		<CFELSE>
			<CFIF IsDefined('FORM.OTHERITEMSID1') AND #FORM.OTHERITEMSID1# GT 0>
				<CFSET FORM.OTHERITEMSID = #FORM.OTHERITEMSID1#>
			<CFELSE>
				<CFSET FORM.OTHERITEMSID = #FORM.OTHERITEMSID2#>
			</CFIF>
		</CFIF>

		<CFQUERY name="GetSoftwareOtherItems" datasource="#application.type#SOFTWARE">
			SELECT	OTHERITEMSID, SOFTWINVENTID, CREATIONDATE, OTHERITEMSQTY, LOCATIONID, PARTNUMBER, TITLE, MODIFIEDBYID, MODIFIEDDATE
			FROM		OTHERITEMS
			WHERE	OTHERITEMSID = <CFQUERYPARAM value="#FORM.OTHERITEMSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	TITLE
		</CFQUERY>

		<CFQUERY name="GetSoftwareInventory" datasource="#application.type#SOFTWARE">
			SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SI.PRODDESCRIPTION, SI.PURCHREQLINEID, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
					SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
					SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE
			FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP 
			WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareOtherItems.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
			ORDER BY	TITLE, VERSION, PRODPLATFORMID
		</CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
			<CFIF #URL.PROCESS# EQ "MODIFYDELETE">
				<TH align="center"><H1>Modify/Delete in IDT Software Inventory - Other Items</H1></TH>
			<CFELSE>
				<TH align="center"><H1>Modify/Delete Loop in IDT Software Inventory - Other Items</H1></TH>
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
					OtherItems Key &nbsp; = &nbsp; #GetSoftwareOtherItems.OTHERITEMSID#<BR />
					Created: &nbsp;&nbsp;#DateFormat(GetSoftwareInventory.CREATIONDATE, "mm/dd/yyyy")#
					<CFCOOKIE name="OTHERITEMSID" secure="NO" value="#GetSoftwareOtherItems.OTHERITEMSID#">
				</TH>
			</TR>
		</TABLE>
		<BR />
		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="OTHERITEMS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwareotheritems.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Title</TH>
			<TH align="left">Version - Platform</TH>
		</TR>
		<TR>
			<TD align="left">#GetSoftwareInventory.TITLE#</TD>
			<TD align="left">#GetSoftwareInventory.VERSION# - #GetSoftwareInventory.PRODUCTPLATFORMNAME#</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="OTHERITEMSQTY">*OtherItems Quantity</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="LOCATIONID">*OtherItems Location</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="OTHERITEMSQTY" id="OTHERITEMSQTY" value="#GetSoftwareOtherItems.OTHERITEMSQTY#" align="LEFT" required="No" size="18" tabindex="2">
			</TD>
			<TD align="left">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListStoredLocations" value="STOREDLOCID" display="STOREDLOCNAME" selected="#GetSoftwareOtherItems.LOCATIONID#" required="NO" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PARTNUMBER">*Part Number</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="TITLE">*OtherItems Title</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="PARTNUMBER" id="PARTNUMBER" value="#GetSoftwareOtherItems.PARTNUMBER#" align="LEFT" required="No" size="35" maxlength="50" tabindex="4">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="TITLE" id="TITLE" value="#GetSoftwareOtherItems.TITLE#" align="LEFT" required="No" size="100" maxlength="150" tabindex="5">
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
                    	<INPUT type="hidden" name="PROCESSSOFTWAREOTHERITEMS" value="MODIFY" />
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
                         <INPUT type="hidden" name="PROCESSSOFTWAREOTHERITEMS" value="MODIFYLOOP" /><BR />
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
<CFFORM action="/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=#URL.PROCESS#" method="POST">
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