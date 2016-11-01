<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: extrnlwoinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012 --->
<!--- Module: Add/Modify/Delete Information in Facilities - External WO Provided Info --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/extrnlwoinfo.cfm">
<CFSET CONTENT_UPDATED = "February 10, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information in Facilities - External WO Provided Info</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information in Facilities - External WO Provided Info</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Facilities";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}



	function validateWOAddLookupField() {
		if (document.LOOKUP1.WORKREQUESTID.selectedIndex == "0") {
			alertuser ("A Work Request MUST be selected!");
			document.LOOKUP1.WORKREQUESTID.focus();
			return false;
		}
	}

	function validateReqFields() {
		if (document.EXTERNALWOINFO.SHOPSWONUM.value == "" || document.EXTERNALWOINFO.SHOPSWONUM.value == " ") {
			alertuser (document.EXTERNALWOINFO.SHOPSWONUM.name +  ",  An External Work Request Number MUST be entered!");
			document.EXTERNALWOINFO.SHOPSWONUM.focus();
			return false;
		}

		if (document.EXTERNALWOINFO.DATESENT.value == "" || document.EXTERNALWOINFO.DATESENT.value == " "
		 || !document.EXTERNALWOINFO.DATESENT.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.EXTERNALWOINFO.DATESENT.name +  ",  A Date Sent MUST be entered in the format MM/DD/YYYY!");
			document.EXTERNALWOINFO.DATESENT.focus();
			return false;
		}

		if (!document.EXTERNALWOINFO.DATESTARTED.value == "" && !document.EXTERNALWOINFO.DATESTARTED.value == " "
		 && !document.EXTERNALWOINFO.DATESTARTED.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.EXTERNALWOINFO.DATESTARTED.name +  ",  A Date Started MUST be entered in the format MM/DD/YYYY!");
			document.EXTERNALWOINFO.DATESTARTED.focus();
			return false;
		}

		if (!document.EXTERNALWOINFO.BILLINGDATE.value == "" && !document.EXTERNALWOINFO.BILLINGDATE.value == " "
		 && !document.EXTERNALWOINFO.BILLINGDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.EXTERNALWOINFO.BILLINGDATE.name +  ",  A Billing Date MUST be entered in the format MM/DD/YYYY!");
			document.EXTERNALWOINFO.BILLINGDATE.focus();
			return false;
		}

		if (document.EXTERNALWOINFO.LABORCOST != null && !document.EXTERNALWOINFO.LABORCOST.value.match(/^\d{1,}\.\d{2}/)) {
			alertuser (document.EXTERNALWOINFO.LABORCOST.name +  ",  The Labor Cost dollar amount must be in format 99999.99!");
			document.EXTERNALWOINFO.LABORCOST.focus();
			return false;
		}

		if (document.EXTERNALWOINFO.LABORCOST != null && document.EXTERNALWOINFO.LABORCOST.value.match(/[$\,]/)) {
			alertuser (document.EXTERNALWOINFO.LABORCOST.name +  ",  The Labor Cost dollar amount CAN NOT contain a dollar sign or commas!");
			document.EXTERNALWOINFO.LABORCOST.focus();
			return false;
		}

		if (document.EXTERNALWOINFO.ITEMCOST != null && !document.EXTERNALWOINFO.ITEMCOST.value.match(/^\d{1,}\.\d{2}/)) {
			alertuser (document.EXTERNALWOINFO.ITEMCOST.name +  ",  The Item Cost dollar amount must be in format 99999.99!");
			document.EXTERNALWOINFO.ITEMCOST.focus();
			return false;
		}

		if (document.EXTERNALWOINFO.ITEMCOST != null && document.EXTERNALWOINFO.ITEMCOST.value.match(/[$\,]/)) {
			alertuser (document.EXTERNALWOINFO.ITEMCOST.name +  ",  The Labor Cost dollar amount CAN NOT contain a dollar sign or commas!");
			document.EXTERNALWOINFO.ITEMCOST.focus();
			return false;
		}

		if (document.EXTERNALWOINFO.TAX != null && !document.EXTERNALWOINFO.TAX.value.match(/^\d{1,}\.\d{2}/)) {
			alertuser (document.EXTERNALWOINFO.TAX.name +  ",  The Tax dollar amount must be in format 99999.99!");
			document.EXTERNALWOINFO.TAX.focus();
			return false;
		}

		if (document.EXTERNALWOINFO.TAX != null && document.EXTERNALWOINFO.TAX.value.match(/[$\,]/)) {
			alertuser (document.EXTERNALWOINFO.TAX.name +  ",  The Tax dollar amount CAN NOT contain a dollar sign or commas!");
			document.EXTERNALWOINFO.TAX.focus();
			return false;
		}

		if (document.EXTERNALWOINFO.TOTCHRGBACK != null && !document.EXTERNALWOINFO.TOTCHRGBACK.value.match(/^\d{1,}\.\d{2}/)) {
			alertuser (document.EXTERNALWOINFO.TOTCHRGBACK.name +  ",  The Total Charge Back dollar amount must be in format 99999.99!");
			document.EXTERNALWOINFO.TOTCHRGBACK.focus();
			return false;
		}

		if (document.EXTERNALWOINFO.TOTCHRGBACK != null && document.EXTERNALWOINFO.TOTCHRGBACK.value.match(/[$\,]/)) {
			alertuser (document.EXTERNALWOINFO.TOTCHRGBACK.name +  ",  The Total Charge Back dollar amount CAN NOT contain a dollar sign or commas!");
			document.EXTERNALWOINFO.TOTCHRGBACK.focus();
			return false;
		}
	}

	function validateWOModifyLookupField() {
		function validateLookupField() {
		if (document.LOOKUP2.SHOPSWONUM1.selectedIndex == "0" && document.LOOKUP2.SHOPSWONUM2.selectedIndex == "0" && document.LOOKUP2.SHOPSWONUM3.value == "") {
			alertuser ("Either an Shop WO Number MUST be selected or a Shop WO Number must be entered!");
			document.LOOKUP2.SHOPSWONUM1.focus();
			return false;
		}
		if ((document.LOOKUP2.SHOPSWONUM1.selectedIndex > "0" || document.LOOKUP2.SHOPSWONUM2.selectedIndex > "0") && document.LOOKUP2.SHOPSWONUM3.value != "") {
			alertuser ("Either an Shop WO Number MUST be selected or a Shop WO Number must be entered!  You cannot choose both.");
			document.LOOKUP2.SHOPSWONUM1.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPEXTERNLWOID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP2.EXTERNLWOID.focus()">
<CFELSEIF NOT IsDefined('URL.LOOKUPWORKREQUESTID') AND URL.PROCESS EQ "ADD">
	<CFSET CURSORFIELD = "document.LOOKUP1.WORKREQUESTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.EXTERNALWOINFO.EXTERNLWONUM.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<CFQUERY name="ListExternalShops" datasource="#application.type#FACILITIES" blockfactor="16">
	SELECT	EXTERNLSHOPID, EXTERNLSHOPNAME
	FROM		EXTERNLSHOPS
	ORDER BY	EXTERNLSHOPNAME
</CFQUERY>

<CFQUERY name="ListWorkRequests" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	WR.WORKREQUESTID, WR.WORKREQUESTNUMBER, CUST.CUSTOMERID, CUST.FULLNAME, RT.REQUESTTYPENAME,
			CUST.FULLNAME || ' - ' || RT.REQUESTTYPENAME || ' - ' || WR.WORKREQUESTNUMBER AS LOOKUPKEY
	FROM		WORKREQUESTS WR, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTTYPES RT
	WHERE	WR.REQUESTERID = CUST.CUSTOMERID AND
			WR.REQUESTTYPEID = RT.REQUESTTYPEID
	ORDER BY	LOOKUPKEY
</CFQUERY>

<!--- 
***********************************************************************************
* The following code is the Look Up Process for Adding External WO Provided Info. *
***********************************************************************************
 --->
<CFIF URL.PROCESS EQ "ADD">

	<CFIF NOT IsDefined('FORM.WORKREQUESTID')>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center"><H1>ADD External WO Provided Info Lookup </H1></TH>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>

		<BR />
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
				<TD align="left">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP1" onsubmit="return validateWOAddLookupField();" action="/#application.type#apps/facilities/extrnlwoinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPWORKREQUESTID=FOUND" method="POST">
			<TR>
				<TH align="LEFT"><H4>*Select by Customer - Request Type - Work Request Number</H4></TH>
			</TR>
			<TR>
				<TD align="LEFT">
					<CFSELECT name="WORKREQUESTID" size="1" query="ListWorkRequests" value="WORKREQUESTID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
				<TD align="left">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
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
************************************************************************
* The following code is the ADD Process for External WO Provided Info. *
************************************************************************
 --->


	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(EXTERNLWOID) AS MAX_ID
		FROM		EXTERNLWOINFO
	</CFQUERY>
	<CFSET FORM.EXTERNLWOID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="EXTERNLWOID" secure="NO" value="#FORM.EXTERNLWOID#">

	<CFQUERY name="AddExternalWOProvidedID" datasource="#application.type#FACILITIES">
		INSERT INTO	EXTERNLWOINFO(EXTERNLWOID, WORKREQUESTID)
		VALUES		(#val(Cookie.EXTERNLWOID)#, #val(FORM.WORKREQUESTID)#)
	</CFQUERY>

	<CFQUERY name="LookupWorkRequests" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	WR.WORKREQUESTID, WR.WORKREQUESTNUMBER, CUST.CUSTOMERID, CUST.FULLNAME, RT.REQUESTTYPENAME,
				CUST.FULLNAME || ' - ' || RT.REQUESTTYPENAME || ' - ' || WR.WORKREQUESTNUMBER AS LOOKUPKEY
		FROM		WORKREQUESTS WR, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTTYPES RT
		WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#FORM.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WR.REQUESTERID = CUST.CUSTOMERID AND
				WR.REQUESTTYPEID = RT.REQUESTTYPEID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Add External WO Provided Info in Facilities</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="Left" border="0">
		<TR>
			<TH align="center" colspan="2">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center" colspan="2">
				External WO Key: &nbsp;&nbsp; #Cookie.EXTERNLWOID#
			</TH>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/processextrnlwoinfo.cfm" method="POST">
				<INPUT type="submit" name="ProcessExternlWOs" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD align="left"><H2>Work Request Number:&nbsp;&nbsp;#LookupWorkRequests.WORKREQUESTNUMBER#</H2></TD>
			<TD align="left"><H2>&nbsp;&nbsp;</H2></TD>
		</TR>
<CFFORM name="EXTERNALWOINFO" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processextrnlwoinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" valign ="BOTTOM"><H4>*Shops WO Number</H4></TH>
			<TH align="left" valign ="BOTTOM"><H4>*Date Sent</H4></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="SHOPSWONUM" value="" align="LEFT" required="No" size="20" tabindex="2">
			</TD>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="DATESENT" value="" align="LEFT" required="No" size="10" maxlength="10" tabindex="3"><BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM">Date Started</TH>
			<TH align="left" valign ="BOTTOM">Billing Date</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="DATESTARTED" value="" align="LEFT" required="No" size="10" maxlength="10" tabindex="4"><BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="BILLINGDATE" value="" align="LEFT" required="No" size="10" maxlength="10" tabindex="5"><BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM">External Shop Name</TH>
			<TH align="left" valign ="BOTTOM">External Shop Comments</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="EXTERNLSHOPID" size="1" query="ListExternalShops" value="EXTERNLSHOPID" display="EXTERNLSHOPNAME" selected="0" required="No" tabindex="6"></CFSELECT>
			</TD>
			<TD align="left" valign ="TOP">
				<TEXTAREA name="SHOPCOMMENTS" wrap="VIRTUAL" rows="5" cols="60" tabindex="7"> </TEXTAREA>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM">Labor Cost</TH>
			<TH align="left" valign ="BOTTOM">Item Cost</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="LABORCOST" value="0.00" align="LEFT" required="No" size="10" tabindex="8">
			</TD>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="ITEMCOST" value="0.00" align="LEFT" required="No" size="10" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM">Tax</TH>
			<TH align="left" valign ="BOTTOM">Total Charge Back To Library</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="TAX" value="0.00" align="LEFT" required="No" size="10" tabindex="10">
			</TD>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="TOTCHRGBACK" value="0.00" align="LEFT" required="No" size="10" tabindex="11">
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessExternlWOs" value="ADD" tabindex="12" /></TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/processextrnlwoinfo.cfm" method="POST">
				<INPUT type="submit" name="ProcessExternlWOs" value="CANCELADD" tabindex="13" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
			</TD>
		</TR>
		
		<TR>
			<TD colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
	</CFIF>
	<CFEXIT>

<CFELSE>
<!--- 
***************************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting External WO Provided Info. *
***************************************************************************************************
 --->

	<CFQUERY name="LookupCurrYrExtrnlWOProvdInfo" datasource="#application.type#FACILITIES">
		SELECT	EWOI.EXTERNLWOID, EWOI.WORKREQUESTID, WR.WORKREQUESTID, WR.FISCALYEARID, FY.FISCALYEAR_2DIGIT,
          		EWOI.SHOPSWONUM, TO_CHAR(EWOI.DATESENT, 'MM/DD/YYYY') AS DATESENT, 
                    EWOI.SHOPSWONUM || ' - ' || WR.WORKREQUESTNUMBER || ' - ' || FY.FISCALYEAR_2DIGIT AS LOOKUPKEY
		FROM		EXTERNLWOINFO EWOI, WORKREQUESTS WR, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	(EWOI.WORKREQUESTID = WR.WORKREQUESTID AND
          		 WR.FISCALYEARID = FY.FISCALYEARID) AND 
                    ((WR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) OR
                    (EWOI.EXTERNLWOID = 0))
		ORDER BY	LOOKUPKEY
	</CFQUERY>
     
     <CFQUERY name="LookupPrevYrExtrnlWOProvdInfo" datasource="#application.type#FACILITIES">
		SELECT	EWOI.EXTERNLWOID, EWOI.WORKREQUESTID, WR.WORKREQUESTID, WR.REQUESTERID, WR.FISCALYEARID, FY.FISCALYEAR_2DIGIT,
          		EWOI.SHOPSWONUM, TO_CHAR(EWOI.DATESENT, 'MM/DD/YYYY') AS DATESENT,
				EWOI.SHOPSWONUM || ' - ' || WR.WORKREQUESTNUMBER || ' - ' || FY.FISCALYEAR_2DIGIT AS LOOKUPKEY
		FROM		EXTERNLWOINFO EWOI, WORKREQUESTS WR, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	(EWOI.WORKREQUESTID = WR.WORKREQUESTID AND
          		 WR.FISCALYEARID = FY.FISCALYEARID) AND 
                    ((WR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) OR
                    (EWOI.EXTERNLWOID  = 0))
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPEXTERNLWOID')>
			<TD align="center"><H1>Modify/Delete External WO Provided Info Lookup</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete External WO Provided Info in Facilities</H1></TD>
		</CFIF>
		</TR>
		</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>* RED fields marked with asterisks are required!</H4></TH>
		</TR>
	</TABLE>

	<CFIF NOT IsDefined('URL.LOOKUPEXTERNLWOID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP2" onsubmit="return validateWOModifyLookupField();" action="/#application.type#apps/facilities/extrnlwoinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPEXTERNLWOID=FOUND" method="POST">
          	<TR>
				<TH align="LEFT" width="40%"><LABEL for="SHOPSWONUM1">Select by Shops WO Number - Work Request Number For Current Fiscal Year & CFY+1:</LABEL></TH>
				<TD align="LEFT" width="60%">
					<CFSELECT name="SHOPSWONUM1" id="SHOPSWONUM1" size="1" query="LookupCurrYrExtrnlWOProvdInfo" value="SHOPSWONUM" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="LEFT" width="40%"><LABEL for="SHOPSWONUM2">Or Select by Shops WO Number - Work Request Number For Previous Fiscal Years:</LABEL></TH>
				<TD align="LEFT" width="60%">
					<CFSELECT name="SHOPSWONUM2" id="SHOPSWONUM2" size="1" query="LookupPrevYrExtrnlWOProvdInfo" value="SHOPSWONUM" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
               <TR>
				<TH align="LEFT" width="40%"><LABEL for="SHOPSWONUM3">Or Shops WO Number:</LABEL></TH>
				<TD align="LEFT" width="60%">
					<CFINPUT type="Text" name="SHOPSWONUM3" value="" align="LEFT" required="No" size="20" tabindex="4">
				</TD>
			</TR>
               <TR>
				<TD align="LEFT">
					<INPUT type="submit" value="GO" tabindex="5" /><BR />
				</TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="6" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
***************************************************************************************
* The following code is the Modify and Delete Processes for External WO Provided Info.*
***************************************************************************************
 --->

		 <CFIF FORM.SHOPSWONUM1 GT 0>
			<CFSET FORM.SHOPSWONUM = FORM.SHOPSWONUM1>
          <CFELSEIF FORM.SHOPSWONUM2 GT 0>
               <CFSET FORM.SHOPSWONUM = FORM.SHOPSWONUM2>
          <CFELSE>
          	<CFSET FORM.SHOPSWONUM = FORM.SHOPSWONUM3>
          </CFIF>

		<CFQUERY name="GetExternalWOProvidedInfo" datasource="#application.type#FACILITIES">
			SELECT	EWOI.EXTERNLWOID, EWOI.WORKREQUESTID, WR.WORKREQUESTID, WR.WORKREQUESTNUMBER, EWOI.SHOPSWONUM, 
					TO_CHAR(EWOI.DATESENT, 'MM/DD/YYYY') AS DATESENT, TO_CHAR(EWOI.DATESTARTED, 'MM/DD/YYYY') AS DATESTARTED,
					TO_CHAR(EWOI.BILLINGDATE, 'MM/DD/YYYY') AS BILLINGDATE, EWOI.EXTERNLSHOPID, EWOI.SHOPCOMMENTS,
					EWOI.LABORCOST, EWOI.ITEMCOST, EWOI.TAX, EWOI.TOTCHRGBACK,
					EWOI.SHOPSWONUM || ' - ' || WR.WORKREQUESTNUMBER AS LOOKUPKEY
			FROM		EXTERNLWOINFO EWOI, WORKREQUESTS WR
			WHERE	EWOI.SHOPSWONUM = <CFQUERYPARAM value="#FORM.SHOPSWONUM#" cfsqltype="CF_SQL_VARCHAR"> AND
					EWOI.WORKREQUESTID = WR.WORKREQUESTID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center" colspan="2">
					External WO Key: &nbsp;&nbsp; #GetExternalWOProvidedInfo.EXTERNLWOID#
				</TH>
			</TR>
		</TABLE>

		<TABLE width="100%" border="0">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/extrnlwoinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessExternlWOs" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left"><H2>Work Request Number:&nbsp;&nbsp;#GetExternalWOProvidedInfo.WORKREQUESTNUMBER#</H2></TD>
				<TD align="left"><H2>&nbsp;&nbsp;</H2></TD>
			</TR>
<CFFORM name="EXTERNALWOINFO" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processextrnlwoinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="EXTERNLWOID" secure="NO" value="#GetExternalWOProvidedInfo.EXTERNLWOID#">
				<TH align="left" valign ="BOTTOM"><H4>*Shops WO Number</H4></TH>
				<TH align="left" valign ="BOTTOM"><H4>*Date Sent</H4></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="SHOPSWONUM" value="#GetExternalWOProvidedInfo.SHOPSWONUM#" align="LEFT" required="No" size="20" tabindex="2">
				</TD>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="DATESENT" value="#GetExternalWOProvidedInfo.DATESENT#" align="LEFT" required="No" size="10" maxlength="10" tabindex="3"><BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM">Date Started</TH>
				<TH align="left" valign ="BOTTOM">Billing Date</TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="DATESTARTED" value="#GetExternalWOProvidedInfo.DATESTARTED#" align="LEFT" required="No" size="10" maxlength="10" tabindex="4"><BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="BILLINGDATE" value="#GetExternalWOProvidedInfo.BILLINGDATE#" align="LEFT" required="No" size="10" maxlength="10" tabindex="5"><BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM">External Shop Name</TH>
				<TH align="left" valign ="BOTTOM">External Shop Comments</TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="EXTERNLSHOPID" size="1" query="ListExternalShops" value="EXTERNLSHOPID" display="EXTERNLSHOPNAME" selected="#GetExternalWOProvidedInfo.EXTERNLSHOPID#" required="No" tabindex="6"></CFSELECT>
				</TD>
				<TD align="left" valign ="TOP">
					<TEXTAREA name="SHOPCOMMENTS" wrap="VIRTUAL" rows="5" cols="60" tabindex="7"> </TEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM">Labor Cost</TH>
				<TH align="left" valign ="BOTTOM">Item Cost</TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="LABORCOST" value="#LTrim(NumberFormat(GetExternalWOProvidedInfo.LABORCOST, '____.__'))#" align="LEFT" required="No" size="10" tabindex="8">
				</TD>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="ITEMCOST" value="#LTrim(NumberFormat(GetExternalWOProvidedInfo.ITEMCOST, '____.__'))#" align="LEFT" required="No" size="10" tabindex="9">
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM">Tax</TH>
				<TH align="left" valign ="BOTTOM">Total Charge Back To Library</TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="TAX" value="#LTrim(NumberFormat(GetExternalWOProvidedInfo.TAX, '____.__'))#" align="LEFT" required="No" size="10" tabindex="10">
				</TD>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="TOTCHRGBACK" value="#LTrim(NumberFormat(GetExternalWOProvidedInfo.TOTCHRGBACK, '____.__'))#" align="LEFT" required="No" size="10" tabindex="11">
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessExternlWOs" value="MODIFY" tabindex="12" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
				</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessExternlWOs" value="DELETE" tabindex="13" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/extrnlwoinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessExternlWOs" value="Cancel" tabindex="14" /><BR />
						<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>