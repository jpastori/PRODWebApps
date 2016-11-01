<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwareinventory.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/30/2012 --->
<!--- Date in Production: 07/30/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Software Inventory--->
<!-- Last modified by John R. Pastori on 07/09/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/softwareinventory.cfm">
<CFSET CONTENT_UPDATED = "July 09, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Software Inventory</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Software Inventory</TITLE>
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

		if (document.SOFTWAREINVENTORY.TITLE.value == "" || document.SOFTWAREINVENTORY.TITLE.value == " ") {
			alertuser (document.SOFTWAREINVENTORY.TITLE.name +  ",  A Title MUST be entered!");
			document.SOFTWAREINVENTORY.TITLE.focus();
			return false;
		}

		if (document.SOFTWAREINVENTORY.VERSION.value == "" || document.SOFTWAREINVENTORY.VERSION.value == " ") {
			alertuser (document.SOFTWAREINVENTORY.VERSION.name +  ",  A Software Version MUST be entered!");
			document.SOFTWAREINVENTORY.VERSION.focus();
			return false;
		}

		if (document.SOFTWAREINVENTORY.CATEGORYID.selectedIndex == "0") {
			alertuser (document.SOFTWAREINVENTORY.CATEGORYID.name +  ",  A Category MUST be selected!");
			document.SOFTWAREINVENTORY.CATEGORYID.focus();
			return false;
		}

		if (document.SOFTWAREINVENTORY.PRODPLATFORMID.selectedIndex == "0") {
			alertuser (document.SOFTWAREINVENTORY.PRODPLATFORMID.name +  ",  A Product Platform MUST be selected!");
			document.SOFTWAREINVENTORY.PRODPLATFORMID.focus();
			return false;
		}

		if (document.SOFTWAREINVENTORY.PURCHREQLINEID.selectedIndex == "0") {
			alertuser (document.SOFTWAREINVENTORY.PURCHREQLINEID.name +  ",  A Requisition Number MUST be entered!");
			document.SOFTWAREINVENTORY.PURCHREQLINEID.focus();
			return false;
		}

		if (document.SOFTWAREINVENTORY.PRODSTATUSID.selectedIndex == "0") {
			alertuser (document.SOFTWAREINVENTORY.PRODSTATUSID.name +  ",  A Title Status MUST be selected!");
			document.SOFTWAREINVENTORY.PRODSTATUSID.focus();
			return false;
		}

		if (!document.SOFTWAREINVENTORY.RECVDDATE.value == "" && !document.SOFTWAREINVENTORY.RECVDDATE.value == " " 
		 && !document.SOFTWAREINVENTORY.RECVDDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.SOFTWAREINVENTORY.RECVDDATE.name +  ", The desired Received Date MUST be entered in the format MM/DD/YYYY!");
			document.SOFTWAREINVENTORY.RECVDDATE.focus();
			return false;
		}

		if (document.SOFTWAREINVENTORY.QTYORDERED.value == "" || document.SOFTWAREINVENTORY.QTYORDERED.value == " ") {
			alertuser (document.SOFTWAREINVENTORY.QTYORDERED.name +  ",  A Quantity Ordered MUST be entered!");
			document.SOFTWAREINVENTORY.QTYORDERED.focus();
			return false;
		}

		if (document.SOFTWAREINVENTORY.LICENSETYPEID.selectedIndex == "0") {
			alertuser (document.SOFTWAREINVENTORY.LICENSETYPEID.name +  ",  A License Type MUST be selected!");
			document.SOFTWAREINVENTORY.LICENSETYPEID.focus();
			return false;
		}

		if (document.SOFTWAREINVENTORY.QTYLICENSED.value == "" || document.SOFTWAREINVENTORY.QTYLICENSED.value == " ") {
			alertuser (document.SOFTWAREINVENTORY.QTYLICENSED.name +  ",  A Quantity Licensed MUST be entered!");
			document.SOFTWAREINVENTORY.QTYLICENSED.focus();
			return false;
		}
	}

		function validateLookupFields() {
		if (document.LOOKUP.SOFTWINVENTID1.selectedIndex == "0" && document.LOOKUP.SOFTWINVENTID2.selectedIndex == "0") {
			alertuser ("You must choose from one of the two dropdowns!");
			document.LOOKUP.SOFTWINVENTID1.focus();
			return false;
		}

		if (document.LOOKUP.SOFTWINVENTID1.selectedIndex > "0" && document.LOOKUP.SOFTWINVENTID2.selectedIndex > "0") {
			alertuser ("You must choose ONLY one of the two dropdowns!");
			document.LOOKUP.SOFTWINVENTID1.focus();
			return false;
		}
	}


	function setDelete() {
		document.SOFTWAREINVENTORY.PROCESSSOFTWAREINVENTORY.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPTITLE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SOFTWINVENTID2.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SOFTWAREINVENTORY.TITLE.focus()">
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
 
<CFQUERY name="ListPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER, PRL.LINEDESCRIPTION, PR.PURCHREQID,
			PR.FISCALYEARID, PR.REQNUMBER, PR.PONUMBER, PR.VENDORID, V.VENDORNAME, PR.PURCHREQUNITID,
			PR.REQNUMBER || ' - ' || PR.PONUMBER || ' - ' || PRL.LINENUMBER || ' - ' || SUBSTR(PRL.LINEDESCRIPTION,1,20) AS REQLOOKUP
	FROM		PURCHREQLINES PRL, PURCHREQS PR, VENDORS V
	WHERE	PRL.PURCHREQID = PR.PURCHREQID AND
			PR.VENDORID = V.VENDORID
	ORDER BY	PR.REQNUMBER, PRL.LINENUMBER
</CFQUERY>

<CFQUERY name="ListProductCategories" datasource="#application.type#SOFTWARE" blockfactor="31">
	SELECT	PRODCATID, PRODCATNAME
	FROM		PRODUCTCATEGORIES
	ORDER BY	PRODCATNAME
</CFQUERY>

<CFQUERY name="ListProductPlatforms" datasource="#application.type#SOFTWARE" blockfactor="6">
	SELECT	PRODUCTPLATFORMID, PRODUCTPLATFORMNAME
	FROM		PRODUCTPLATFORMS
	ORDER BY	PRODUCTPLATFORMNAME
</CFQUERY>

<CFQUERY name="ListImages" datasource="#application.type#SOFTWARE" blockfactor="16">
	SELECT	IMAGEID, IMAGENAME
	FROM		IMAGES
	ORDER BY	IMAGENAME
</CFQUERY>

<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<CFQUERY name="ListProductStatuses" datasource="#application.type#SOFTWARE" blockfactor="5">
	SELECT	STATUSID, STATUSTYPE, STATUSNAME
	FROM		STATUSES
	WHERE	STATUSID = 0 OR
			STATUSTYPE = 'PROD'
	ORDER BY	STATUSTYPE, STATUSNAME
</CFQUERY>

<CFQUERY name="ListLicenseType" datasource="#application.type#SOFTWARE" blockfactor="11">
	SELECT	LICENSETYPEID, LICENSETYPENAME
	FROM		LICENSETYPES
	ORDER BY	LICENSETYPENAME
</CFQUERY>

<CFQUERY name="ListUpgradeStatuses" datasource="#application.type#SOFTWARE" blockfactor="6">
	SELECT	STATUSID, STATUSTYPE, STATUSNAME
	FROM		STATUSES
	WHERE	STATUSID = 0 OR
			STATUSTYPE = 'UPGR'
	ORDER BY	STATUSTYPE, STATUSNAME
</CFQUERY>

<CFQUERY name="ListTossStatuses" datasource="#application.type#SOFTWARE" blockfactor="6">
	SELECT	STATUSID, STATUSTYPE, STATUSNAME
	FROM		STATUSES
	WHERE	STATUSID = 0 OR
			STATUSTYPE = 'TOSS'
	ORDER BY	STATUSTYPE, STATUSNAME
</CFQUERY>

<CFQUERY name="ListManufWarrVendors" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
	FROM		VENDORS
	ORDER BY	VENDORNAME
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
****************************************************************
* The following code is the ADD Process for Software Inventory *
****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>

	<CFQUERY name="ListSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SOFTWINVENTID, CREATIONDATE, TITLE, VERSION, CATEGORYID, PRODPLATFORMID, PRODDESCRIPTION, PURCHREQLINEID,
				FISCALYEARID, RECVDDATE, PRODSTATUSID, PHONESUPPORT, WEBSUPPORT, FAXSUPPORT, SUPPORTCOMMENTS, QTYORDERED,
				LICENSETYPEID, QTYLICENSED, UPGRADESTATUSID, TOSSSTATUSID, CDKEY, PRODUCTID, MANUFWARRVENDORID,
				MODIFIEDBYID, MODIFIEDDATE
		FROM		SOFTWAREINVENTORY
		ORDER BY	TITLE
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Software Inventory</H1></TD>
		</TR>
	</TABLE>

		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
			SELECT	MAX(SOFTWINVENTID) AS MAX_ID
			FROM		SOFTWAREINVENTORY
		</CFQUERY>
		<CFSET FORM.SOFTWINVENTID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFSET FORM.CREATIONDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
		<CFCOOKIE name="SOFTWINVENTID" secure="NO" value="#FORM.SOFTWINVENTID#">
		<CFQUERY name="AddSoftwareInventoryID" datasource="#application.type#SOFTWARE">
			INSERT INTO	SOFTWAREINVENTORY (SOFTWINVENTID, CREATIONDATE, FISCALYEARID)
			VALUES		(#val(Cookie.SOFTWINVENTID)#, TO_DATE('#FORM.CREATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'), #val(ListCurrentFiscalYear.FISCALYEARID)#)
		</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">
				Software Inventory Key &nbsp; = &nbsp; #FORM.SOFTWINVENTID# &nbsp;&nbsp;Created: &nbsp;&nbsp;#DateFormat(FORM.CREATIONDATE, "mm/dd/yyyy")#
			</TH>
		</TR>
	</TABLE>
	<BR />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processsoftwareinventory.cfm" method="POST">
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSSOFTWAREINVENTORY" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="SOFTWAREINVENTORY" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwareinventory.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="TITLE">*Title</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="VERSION">*Version</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="TITLE" id="TITLE" value="" align="LEFT" required="No" size="75" maxlength="150" tabindex="2">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="VERSION" id="VERSION" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3">
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="CATEGORYID">*Category</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="PRODPLATFORMID">*Product Platform</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="ListProductCategories" value="PRODCATID" display="PRODCATNAME" selected="0" required="No" tabindex="4"></CFSELECT>
			
			</TD><TD align="left">
				<CFSELECT name="PRODPLATFORMID" id="PRODPLATFORMID" size="1" query="ListProductPlatforms" value="PRODUCTPLATFORMID" display="PRODUCTPLATFORMNAME" selected="0" required="No" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="PRODDESCRIPTION">Product Description</LABEL></TH>
			<TH align="left" nowrap><LABEL for="IMAGEKEYS">Image Keys</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFTEXTAREA name="PRODDESCRIPTION" id="PRODDESCRIPTION" wrap="VIRTUAL" required="No" rows="16" cols="60" tabindex="6"></CFTEXTAREA>
			</TD>
               <TD align="left">
				<CFSELECT name="IMAGEKEYS" id="IMAGEKEYS" size="16" query="ListImages" value="IMAGEID" display="IMAGENAME" required="No" multiple="yes" tabindex="7"></CFSELECT><BR>
                    <COM>(Hold down the shift key when clicking to select a range of IMAGES.  Use control key and left mouse click (PC) or command key when clicking (Mac) to select specific IMAGES.)</COM>
			</TD>
          </TR>
          <TR>
			<TH align="left"><H4><LABEL for="PURCHREQLINEID">*Requisition Number</LABEL></H4></TH>
               <TH align="left"><LABEL for="RECVDDATE">Received Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" >
				<CFSELECT name="PURCHREQLINEID" id="PURCHREQLINEID" size="1" query="ListPurchReqLines" value="PURCHREQLINEID" display="REQLOOKUP" selected="0" required="NO" tabindex="8"></CFSELECT>
			</TD>
               <TD align="left" valign="TOP">
				<CFINPUT type="Text" name="RECVDDATE" id="RECVDDATE" value="" align="LEFT" required="No" size="15" tabindex="9">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'SOFTWAREINVENTORY','controlname': 'RECVDDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP"><H4><LABEL for="PRODSTATUSID">*Title Status</LABEL></H4></TH>
               <TH align="left"><LABEL for="UPGRADESTATUSID">Upgrade Status</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="PRODSTATUSID" id="PRODSTATUSID" size="1" query="ListProductStatuses" value="STATUSID" display="STATUSNAME" required="No" tabindex="10"></CFSELECT>
			</TD>
               <TD align="left" valign="TOP">
				<CFSELECT name="UPGRADESTATUSID" id="UPGRADESTATUSID" size="1" query="ListUpgradeStatuses" value="STATUSID" display="STATUSNAME" selected="13" required="No" tabindex="11"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MANUFWARRVENDORID">Man/Warr Vendor</LABEL></TH>	
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="MANUFWARRVENDORID" id="MANUFWARRVENDORID" size="1" query="ListManufWarrVendors" value="VENDORID" display="VENDORNAME" selected="0" required="No" tabindex="12"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP"><LABEL for="PHONESUPPORT">Warranty Phone Support</LABEL></TH>
			<TH align="left" valign="TOP"><LABEL for="WEBSUPPORT">Warranty Web Support</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="PHONESUPPORT" id="PHONESUPPORT" value="" align="LEFT" required="No" size="30" maxlength="50" tabindex="13">
			</TD>
			<TD align="left" valign="TOP">
               	<CFTEXTAREA name="WEBSUPPORT" id="WEBSUPPORT" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="14"></CFTEXTAREA>
			</TD>
			
		</TR>
		<TR>
			<TH align="left"><LABEL for="SUPPORTCOMMENTS">Support Comments</LABEL></TH>
			<TH align="left" valign="TOP"><LABEL for="FAXSUPPORT">Warranty Fax Support</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFTEXTAREA name="SUPPORTCOMMENTS" id="SUPPORTCOMMENTS" wrap="VIRTUAL" required="No" rows="10" cols="60" tabindex="15"></CFTEXTAREA>
			</TD>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="FAXSUPPORT" id="FAXSUPPORT" value="" align="LEFT" required="No" size="30" maxlength="50" tabindex="16">
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="QTYORDERED">*Quantity Ordered</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="LICENSETYPEID">*License Type</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="QTYORDERED" id="QTYORDERED" value="" align="LEFT" required="No" size="18" tabindex="17">
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="LICENSETYPEID" id="LICENSETYPEID" size="1" query="ListLicenseType" value="LICENSETYPEID" display="LICENSETYPENAME" selected="0" required="No" tabindex="18"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="QTYLICENSED">*Quantity Licensed</LABEL></H4></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="QTYLICENSED" id="QTYLICENSED" value="" align="LEFT" required="No" size="18" tabindex="19">
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="CDKEY">CD Key</LABEL></TH>
			<TH align="left"><LABEL for="PRODUCTID">Product ID</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="CDKEY" id="CDKEY" value="" align="LEFT" required="NO" size="50" maxlength="50" tabindex="20">
			</TD>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="PRODUCTID" id="PRODUCTID" value="" align="LEFT" required="NO" size="50" maxlength="50" tabindex="21">
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
			<TH align="left">Modified Date (Creation Date)</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="22"></CFSELECT>
			</TD>
			<TD align="left">
				#DateFormat(FORM.CREATIONDATE, "MM/DD/YYYY")#<BR /><BR />
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.CREATIONDATE#" />
			</TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSSOFTWAREINVENTORY" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="23" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processsoftwareinventory.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSOFTWAREINVENTORY" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="24" /><BR />
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
********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Software Inventory. *
********************************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOKUPTITLE')>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center"><H1>Lookup for Modify/Delete in IDT Software Inventory</H1></TH>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>

		<CFQUERY name="LookupSoftwareInventoryTitle" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
					SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED, SI.UPGRADESTATUSID,
					SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID,
					SI.MODIFIEDBYID, SI.MODIFIEDDATE, SI.TITLE || ' - ' || SI.SOFTWINVENTID || ' - ' || SI.VERSION || ' - ' || PP.PRODUCTPLATFORMNAME || ' - ' ||  PR.REQNUMBER AS LOOKUPKEY
			FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<CFQUERY name="LookupSIRecordKeys" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT,
					SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID,
					SI.CDKEY, SI.PRODUCTID, MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE,
					SI.SOFTWINVENTID || ' - ' || SI.TITLE AS LOOKUPKEY
			FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SI.SOFTWINVENTID, SI.TITLE
		</CFQUERY>

		<BR />
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/softwareinventory/softwareinventory.cfm?PROCESS=#URL.PROCESS#&LOOKUPTITLE=FOUND" method="POST">
			<TR>
				<TH align="LEFT"><H4><LABEL for="SOFTWINVENTID1">*Select by Title - SW Key - Version - Platform - Req Number</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT">
					<CFSELECT name="SOFTWINVENTID1" id="SOFTWINVENTID1" size="1" query="LookupSoftwareInventoryTitle" value="SOFTWINVENTID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
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
				<TD align="CENTER"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
*********************************************************************************
* The following code is the Modify and Delete Processes for Software Inventory. *
*********************************************************************************
 --->

		<CFIF IsDefined('FORM.SOFTWINVENTID1') AND #FORM.SOFTWINVENTID1# GT 0>
			<CFSET FORM.SOFTWINVENTID = #FORM.SOFTWINVENTID1#>
		<CFELSE>
			<CFSET FORM.SOFTWINVENTID = #FORM.SOFTWINVENTID2#>
		</CFIF>

		<CFQUERY name="GetSoftwareInventory" datasource="#application.type#SOFTWARE">
			SELECT	SOFTWINVENTID, CREATIONDATE, TITLE, VERSION, CATEGORYID, PRODPLATFORMID, PRODDESCRIPTION, PURCHREQLINEID,
					FISCALYEARID, TO_CHAR(RECVDDATE,'MM/DD/YYYY') AS RECVDDATE, PRODSTATUSID, PHONESUPPORT, WEBSUPPORT, FAXSUPPORT,
					SUPPORTCOMMENTS, QTYORDERED,LICENSETYPEID, QTYLICENSED, UPGRADESTATUSID, TOSSSTATUSID, CDKEY, PRODUCTID, 
					MANUFWARRVENDORID, MODIFIEDBYID, MODIFIEDDATE, IMAGEKEYS
			FROM		SOFTWAREINVENTORY
			WHERE	SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	TITLE
		</CFQUERY>

		<CFQUERY name="GetPurchReqLines" datasource="#application.type#PURCHASING">
			SELECT	PURCHREQLINEID, PURCHREQID, LINENUMBER, LINEQTY, LINEDESCRIPTION, PARTNUMBER, RECVDDATE, LICENSESTATUSID
			FROM		PURCHREQLINES
			WHERE	PURCHREQLINEID = <CFQUERYPARAM value="#GetSoftwareInventory.PURCHREQLINEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PURCHREQID, LINENUMBER
		</CFQUERY>

		<CFQUERY name="GetPurchReqs" datasource="#application.type#PURCHASING">
			SELECT	PURCHREQID, FISCALYEARID, REQNUMBER, PONUMBER, VENDORID, PURCHREQUNITID, PURCHASEJUSTIFICATION
			FROM		PURCHREQS
			WHERE	PURCHREQID = <CFQUERYPARAM value="#GetPurchReqLines.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	REQNUMBER, PONUMBER
		</CFQUERY>

		<CFQUERY name="GetLicenseStatus" datasource="#application.type#PURCHASING">
			SELECT	LICENSESTATUSID, LICENSESTATUSNAME
			FROM		LICENSESTATUS
			WHERE	LICENSESTATUSID = <CFQUERYPARAM value="#GetPurchReqLines.LICENSESTATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	LICENSESTATUSNAME
		</CFQUERY>

		<CFQUERY name="GetUnits" datasource="#application.type#LIBSHAREDDATA">
			SELECT	UNITID, UNITNAME, CAMPUSMAILCODEID, GROUPID, DEPARTMENTID, SUPERVISORID
			FROM		UNITS
			WHERE	UNITS.UNITID = <CFQUERYPARAM value="#GetPurchReqs.PURCHREQUNITID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	UNITNAME
		</CFQUERY>

		<CFQUERY name="GetPurchaseVendor" datasource="#application.type#PURCHASING">
			SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
			FROM		VENDORS
			WHERE	VENDORID = <CFQUERYPARAM value="#GetPurchReqs.VENDORID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	VENDORNAME
		</CFQUERY>

		<CFQUERY name="GetSoftwareFiscalYear" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
			SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
			FROM		FISCALYEARS
			ORDER BY	FISCALYEARID
		</CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center"><H1>Modify/Delete in IDT Software Inventory</H1></TH>
			</TR>
		</TABLE>
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
			<TR>
				<TH align= "CENTER">
					Software Inventory Key &nbsp; = &nbsp; #GetSoftwareInventory.SOFTWINVENTID#
					&nbsp;&nbsp;Created: &nbsp;&nbsp;#DateFormat(GetSoftwareInventory.CREATIONDATE, "mm/dd/yyyy")#
				</TH>
			</TR>
		</TABLE>
		<BR />
		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwareinventory.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="SOFTWAREINVENTORY" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwareinventory.cfm" method="POST" ENABLECAB="Yes">
			<CFCOOKIE name="SOFTWINVENTID" secure="NO" value="#GetSoftwareInventory.SOFTWINVENTID#">
			<TR>
				<TH align="left"><H4><LABEL for="TITLE">*Title</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="VERSION">*Version</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="TITLE" id="TITLE" value="#GetSoftwareInventory.TITLE#" align="LEFT" required="No" size="75" maxlength="150" tabindex="2">
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="VERSION" id="VERSION" value="#GetSoftwareInventory.VERSION#" align="LEFT" required="No" size="25" maxlength="50" tabindex="3">
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="CATEGORYID">*Category</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="PRODPLATFORMID">*Product Platform</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="ListProductCategories" value="PRODCATID" display="PRODCATNAME" selected="#GetSoftwareInventory.CATEGORYID#" required="No" tabindex="4"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="PRODPLATFORMID" id="PRODPLATFORMID" size="1" query="ListProductPlatforms" value="PRODUCTPLATFORMID" display="PRODUCTPLATFORMNAME" selected="#GetSoftwareInventory.PRODPLATFORMID#" required="No" tabindex="5"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="PRODDESCRIPTION">Product Description</LABEL></TH>
                    <TH align="left" nowrap><LABEL for="IMAGEKEYS">Image Keys</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFTEXTAREA name="PRODDESCRIPTION" id="PRODDESCRIPTION" wrap="VIRTUAL" required="No" rows="16" cols="60" tabindex="6">#GetSoftwareInventory.PRODDESCRIPTION#</CFTEXTAREA>
				</TD>
                    <TD align="left" valign ="TOP">
					<CFSELECT name="IMAGEKEYS" size="16" multiple="yes" required="No" tabindex="7">
						<CFLOOP query="ListImages">
							<CFIF #LISTFIND(GetSoftwareInventory.IMAGEKEYS, '#ListImages.IMAGEID#')# NEQ 0>
								<OPTION selected value="#ListImages.IMAGEID#">#ListImages.IMAGENAME#</OPTION>
							<CFELSE>
								<OPTION value="#ListImages.IMAGEID#">#ListImages.IMAGENAME#</OPTION>
							</CFIF>
						</CFLOOP>
					</CFSELECT><BR>
                    <COM>(Hold down the shift key when clicking to select a range of IMAGES.  Use control key and left mouse click (PC) or command key when clicking (Mac) to select specific IMAGES.)</COM>
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="PURCHREQLINEID">*Requisition Number</LABEL></H4></TH>
				<TH align="left">Purchase Order Number</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="PURCHREQLINEID" id="PURCHREQLINEID" size="1" query="ListPurchReqLines" value="PURCHREQLINEID" display="REQLOOKUP" selected="#GetSoftwareInventory.PURCHREQLINEID#" required="NO" tabindex="8"></CFSELECT>
				</TD>
				<TD align="left">
					#GetPurchReqs.PONUMBER#
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="FISCALYEARID">Fiscal Year</LABEL></TH>
				<TH align="left"><LABEL for="RECVDDATE">Received Date</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="FISCALYEARID" id="FISCALYEARID" query="GetSoftwareFiscalYear" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#GetSoftwareInventory.FISCALYEARID#" tabindex="9"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="RECVDDATE" id="RECVDDATE" value="#DateFormat(GetSoftwareInventory.RECVDDATE, "MM/DD/YYYY")#" align="LEFT" required="No" size="15" tabindex="10">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'SOFTWAREINVENTORY','controlname': 'RECVDDATE'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="PRODSTATUSID">*Title Status</LABEL></H4></TH>
				<TH align="left"><LABEL for="UPGRADESTATUSID">Upgrade Status</LABEL></TH>
				
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="PRODSTATUSID" id="PRODSTATUSID" size="1" query="ListProductStatuses" value="STATUSID" display="STATUSNAME" selected="#GetSoftwareInventory.PRODSTATUSID#" required="No" tabindex="11"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">
					<CFSELECT name="UPGRADESTATUSID" id="UPGRADESTATUSID" size="1" query="ListUpgradeStatuses" value="STATUSID" display="STATUSNAME" selected="#GetSoftwareInventory.UPGRADESTATUSID#" required="No" tabindex="12"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left">Req. Unit</TH>
				<TH align="left">Purchase Justification</TH>
			</TR>
			<TR>
				<TD align="left">#GetUnits.UNITNAME#</TD>
				<TD align="left" valign="TOP">#GetPurchReqs.PURCHASEJUSTIFICATION#</TD>
			</TR>
			<TR>
				<TH align="left">Purchase Vendor</TH>
				<TH align="left">Purch-License Status</TH>
			</TR>
			<TR>
				<TD align="left">#GetPurchaseVendor.VENDORNAME#</TD>
				<TD align="left">#GetLicenseStatus.LICENSESTATUSNAME#</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="MANUFWARRVENDORID">Man/Warr Vendor</LABEL></TH>	
				<TH align="left">&nbsp;&nbsp;</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="MANUFWARRVENDORID" id="MANUFWARRVENDORID" size="1" query="ListManufWarrVendors" value="VENDORID" display="VENDORNAME" selected="#GetSoftwareInventory.MANUFWARRVENDORID#" required="No" tabindex="13"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign="TOP"><LABEL for="PHONESUPPORT">Warranty Phone Support</LABEL></TH>
				<TH align="left" valign="TOP"><LABEL for="WEBSUPPORT">Warranty Web Support</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="PHONESUPPORT" id="PHONESUPPORT" value="#GetSoftwareInventory.PHONESUPPORT#" align="LEFT" required="No" size="30" maxlength="50" tabindex="14">
				</TD>
				<TD align="left" valign="TOP">
                    	<CFTEXTAREA name="WEBSUPPORT" id="WEBSUPPORT" required="No" rows="5" cols="60" html="no" tabindex="15">#GetSoftwareInventory.WEBSUPPORT#</CFTEXTAREA><BR>
                         The Web Support Field value is: #GetSoftwareInventory.WEBSUPPORT#
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="SUPPORTCOMMENTS">Support Comments</LABEL></TH>
				<TH align="left" valign="TOP"><LABEL for="FAXSUPPORT">Warranty Fax Support</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFTEXTAREA name="SUPPORTCOMMENTS" id="SUPPORTCOMMENTS" wrap="VIRTUAL" required="No" rows="10" cols="60" tabindex="16">#GetSoftwareInventory.SUPPORTCOMMENTS#</CFTEXTAREA>
				</TD>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="FAXSUPPORT" id="FAXSUPPORT" value="#GetSoftwareInventory.FAXSUPPORT#" align="LEFT" required="No" size="30" maxlength="50" tabindex="17">
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="QTYORDERED">*Quantity Ordered</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="LICENSETYPEID">*License Type</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="QTYORDERED" id="QTYORDERED" value="#GetSoftwareInventory.QTYORDERED#" align="LEFT" required="No" size="18" tabindex="18">
				</TD>
				<TD align="left" valign="TOP">
					<CFSELECT name="LICENSETYPEID" id="LICENSETYPEID" size="1" query="ListLicenseType" value="LICENSETYPEID" display="LICENSETYPENAME" required="No" selected="#GetSoftwareInventory.LICENSETYPEID#" tabindex="19"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="QTYLICENSED">*Quantity Licensed</LABEL></H4></TH>
				<TH align="left"><LABEL for="TOSSSTATUSID">Toss Status</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="QTYLICENSED" id="QTYLICENSED" value="#GetSoftwareInventory.QTYLICENSED#" align="LEFT" required="No" size="18" tabindex="20">
				</TD>
				<TD align="left" valign="TOP">
					<CFSELECT name="TOSSSTATUSID" id="TOSSSTATUSID" size="1" query="ListTossStatuses" value="STATUSID" display="STATUSNAME" selected="#GetSoftwareInventory.TOSSSTATUSID#" required="No" tabindex="21"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="CDKEY">CD Key</LABEL></TH>
				<TH align="left"><LABEL for="PRODUCTID">Product ID</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="CDKEY" id="CDKEY" value="#GetSoftwareInventory.CDKEY#" align="LEFT" required="NO" size="50" maxlength="50" tabindex="22">
				</TD>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="PRODUCTID" id="PRODUCTID" value="#GetSoftwareInventory.PRODUCTID#" align="LEFT" required="NO" size="50" maxlength="50" tabindex="23">
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
				<TH align="left">Modified Date</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="24"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#<BR /><BR />
				</TD>
			</TR>
			<TR>
               	<TD align="left" valign="TOP">
                    	<INPUT type="hidden" name="PROCESSSOFTWAREINVENTORY" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="25" />
				</TD>
				<TD align="left" valign="TOP" rowspan="3">
                    	<INPUT type="image" src="/images/buttonADDAssigns.jpg" value="Add Assignments" alt="Add Assignments" 
					 onClick="window.open('/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=ADD&PGMCALL=SI&SOFTWINVENTID=#Cookie.SOFTWINVENTID#','Add Software Assignments','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;"
					 tabindex="26" /><BR />
                         <INPUT type="image" src="/images/buttonADDManuals.jpg" value="Add Manuals" alt="Add Manuals" 
					 onClick="window.open('/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=ADD&SOFTWINVENTID=#Cookie.SOFTWINVENTID#','Add Software Manuals','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;"
					 tabindex="27" /><BR />
                         <INPUT type="image" src="/images/buttonADDMedia.jpg" value="Add Media" alt="Add Media" 
					 onClick="window.open('/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=ADD&SOFTWINVENTID=#Cookie.SOFTWINVENTID#','Add Software Media','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;"
					 tabindex="28" /><BR />
                         <INPUT type="image" src="/images/buttonADDOtherItems.jpg" value="Add Other Items" alt="Add Other Items" 
					 onClick="window.open('/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=ADD&SOFTWINVENTID=#Cookie.SOFTWINVENTID#','Add Software Other Items','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;"
					 tabindex="29" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="30" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwareinventory.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="31" /><BR />
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