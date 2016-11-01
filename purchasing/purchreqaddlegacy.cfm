<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: purchreqaddlegacy.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012--->
<!--- Module: Add IDT Legacy Purchase Requisitions--->
<!-- Last modified by John R. Pastori on 07/09/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/purchreqaddlegacy.cfm">
<CFSET CONTENT_UPDATED = "July 09, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Add IDT Legacy Purchase Requisitions</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

	<SCRIPT language="JavaScript">
		<!--
			if (window.history.forward(1) != null) {
				window.history.forward(1); 
			}

		//-->
	</SCRIPT>

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Purchasing";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.PURCHASEREQUISITIONS.SERVICEREQUESTNUMBER.value == "" || document.PURCHASEREQUISITIONS.SERVICEREQUESTNUMBER.value == " ") {
			alertuser (document.PURCHASEREQUISITIONS.SERVICEREQUESTNUMBER.name +  ",  You must select a Service Request Number.");
			document.PURCHASEREQUISITIONS.SERVICEREQUESTNUMBER.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.FISCALYEARID.selectedIndex == "0") {
			alertuser (document.PURCHASEREQUISITIONS.FISCALYEARID.name +  ",  You must select a Fiscal Year.");
			document.PURCHASEREQUISITIONS.FISCALYEARID.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.REQUESTERID.selectedIndex == "0") {
			alertuser (document.PURCHASEREQUISITIONS.REQUESTERID.name +  ",  You must select a Requestor Name.");
			document.PURCHASEREQUISITIONS.REQUESTERID.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.PURCHREQUNITID.selectedIndex == "0") {
			alertuser (document.PURCHASEREQUISITIONS.PURCHREQUNITID.name +  ",  You must select a Unit Name.");
			document.PURCHASEREQUISITIONS.PURCHREQUNITID.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION.value == "" || document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION.value == " ") {
			alertuser (document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION.name +  ",  You must enter a Purchase Justification.");
			document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION.value.length > 600) {
			alertuser (document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION.name +  ",  The maximum field length of 600 characters has been exceeded!  Spaces are counted.");
			document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION.focus();
			return false;
		}
		
		if (document.PURCHASEREQUISITIONS.RUSHJUSTIFICATION.value.length > 600) {
			alertuser (document.PURCHASEREQUISITIONS.RUSHJUSTIFICATION.name +  ",  The maximum field length of 600 characters has been exceeded!  Spaces are counted.");
			document.PURCHASEREQUISITIONS.RUSHJUSTIFICATION.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.FUNDACCTID.selectedIndex == "0") {
			alertuser (document.PURCHASEREQUISITIONS.FUNDACCTID.name +  ",  You must select an Fund Account Name.");
			document.PURCHASEREQUISITIONS.FUNDACCTID.focus();
			return false;
		}

/*
		if (document.PURCHASEREQUISITIONS.SUBTOTAL != null && document.PURCHASEREQUISITIONS.SUBTOTAL.value.match(/[$\,]/)) {
			alertuser (document.PURCHASEREQUISITIONS.SUBTOTAL.name +  ",  The SubTotal dollar amount CAN NOT contain a dollar sign or commas!");
			document.PURCHASEREQUISITIONS.SUBTOTAL.focus();
			return false;
		}
*/

		if (document.PURCHASEREQUISITIONS.SHIPPINGCOST != null && document.PURCHASEREQUISITIONS.SHIPPINGCOST.value.match(/[$\,]/)) {
			alertuser (document.PURCHASEREQUISITIONS.SHIPPINGCOST.name +  ",  The Shipping dollar amount CAN NOT contain a dollar sign or commas!");
			document.PURCHASEREQUISITIONS.SHIPPINGCOST.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.TOTAL != null && document.PURCHASEREQUISITIONS.TOTAL.value.match(/[$\,]/)) {
			alertuser (document.PURCHASEREQUISITIONS.TOTAL.name +  ",  The Total dollar amount CAN NOT contain a dollar sign or commas!");
			document.PURCHASEREQUISITIONS.TOTAL.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.BUDGETTYPEID.selectedIndex == "0") {
			alertuser (document.PURCHASEREQUISITIONS.BUDGETTYPEID.name +  ",  You must select a Budget Type.");
			document.PURCHASEREQUISITIONS.BUDGETTYPEID.focus();
			return false;
		}

		if (!document.PURCHASEREQUISITIONS.QUOTEDATE.value == "" && !document.PURCHASEREQUISITIONS.QUOTEDATE.value == " " 
		 && !document.PURCHASEREQUISITIONS.QUOTEDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.PURCHASEREQUISITIONS.QUOTEDATE.name +  ", The desired Quote Date MUST be entered in the format MM/DD/YYYY!");
			document.PURCHASEREQUISITIONS.QUOTEDATE.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.QUOTE.value.length > 50) {
			alertuser (document.PURCHASEREQUISITIONS.QUOTE.name +  ",  The maximum field length of 50 characters has been exceeded!  Spaces are counted.");
			document.PURCHASEREQUISITIONS.QUOTE.focus();
			return false;
		}
		
		if (document.PURCHASEREQUISITIONS.SPECSCOMMENTS.value.length > 600) {
			alertuser (document.PURCHASEREQUISITIONS.SPECSCOMMENTS.name +  ",  The maximum field length of 600 characters has been exceeded!  Spaces are counted.");
			document.PURCHASEREQUISITIONS.SPECSCOMMENTS.focus();
			return false;
		}
		
		if (document.PURCHASEREQUISITIONS.RECVCOMMENTS.value.length > 1000) {
			alertuser (document.PURCHASEREQUISITIONS.RECVCOMMENTS.name +  ",  The maximum field length of 1000 characters has been exceeded!  Spaces are counted.");
			document.PURCHASEREQUISITIONS.RECVCOMMENTS.focus();
			return false;
		}

		if (!document.PURCHASEREQUISITIONS.REVIEWDATE.value == "" && !document.PURCHASEREQUISITIONS.REVIEWDATE.value == " " 
		 && !document.PURCHASEREQUISITIONS.REVIEWDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.PURCHASEREQUISITIONS.REVIEWDATE.name +  ", The desired Review Date MUST be entered in the format MM/DD/YYYY!");
			document.PURCHASEREQUISITIONS.REVIEWDATE.focus();
			return false;
		}

		if (!document.PURCHASEREQUISITIONS.REQFILEDDATE.value == "" && !document.PURCHASEREQUISITIONS.REQFILEDDATE.value == " " 
		 && !document.PURCHASEREQUISITIONS.REQFILEDDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.PURCHASEREQUISITIONS.REQFILEDDATE.name +  ", The desired Filed Date MUST be entered in the format MM/DD/YYYY!");
			document.PURCHASEREQUISITIONS.REQFILEDDATE.focus();
			return false;
		}

	}

//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY onLoad="document.PURCHASEREQUISITIONS.SERVICEREQUESTNUMBER.focus()">

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined("URL.PROCESS")>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<CFIF IsDefined('URL.SRID')>
	<CFSET FORM.SRID = #URL.SRID#>
</CFIF>

<!--- 
*****************************************************************
* The following code is for all Purchase Requisition Processes. *
*****************************************************************
 --->

<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
	SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
			SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID, SR.PROBLEM_CATEGORYID, PC.CATEGORYNAME,
			SR.PROBLEM_SUBCATEGORYID, PSC.SUBCATEGORYNAME, SR.PRIORITYID, SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID,
			SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED,
			SR.SERVICEREQUESTNUMBER || ' - ' || PC.CATEGORYNAME || ' - ' || PSC.SUBCATEGORYNAME AS LOOKUPKEY
	FROM		SERVICEREQUESTS SR, PROBLEMCATEGORIES PC, PROBLEMSUBCATEGORIES PSC, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	(SR.PROBLEM_CATEGORYID = PC.CATEGORYID AND
			SR.PROBLEM_SUBCATEGORYID = PSC.SUBCATEGORYID AND
			SR.REQUESTERID = CUST.CUSTOMERID) AND
			(SRID = 0 OR
			SR.PROBLEM_CATEGORYID = 2)
	ORDER BY	LOOKUPKEY
</CFQUERY>

<CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	ORDER BY	FISCALYEARID
</CFQUERY>

<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, U.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
			CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U, FACILITIESMGR.LOCATIONS LOC
	WHERE	CUST.UNITID = U.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	UNITID, UNITNAME, CAMPUSMAILCODEID, GROUPID, DEPARTMENTID, SUPERVISORID
	FROM		UNITS
	WHERE 	UNITID = 0 OR
			DEPARTMENTID = 8
	ORDER BY	UNITNAME
</CFQUERY>

<CFQUERY name="ListBudgetTypes" datasource="#application.type#PURCHASING" blockfactor="15">
	SELECT	BUDGETTYPEID, BUDGETTYPENAME
	FROM		BUDGETTYPES
	ORDER BY	BUDGETTYPENAME
</CFQUERY>

<CFQUERY name="ListFundAccts" datasource="#application.type#PURCHASING" blockfactor="15">
	SELECT	FUNDACCTID, FUNDACCTNAME
	FROM		FUNDACCTS
	ORDER BY	FUNDACCTNAME
</CFQUERY>

<CFQUERY name="ListPurchaseVendors" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
	FROM		VENDORS
	ORDER BY	VENDORNAME
</CFQUERY>

<CFQUERY name="ListVendorContacts" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	VC.VENDORCONTACTID, V.VENDORNAME, VC.CONTACTNAME, VC.PHONENUMBER, VC.FAXNUMBER, VC.EMAILADDRESS,
			VC.MODIFIEDBYID, VC.MODIFIEDDATE, V.VENDORNAME || ' - ' || VC.CONTACTNAME AS LOOKUPKEY
	FROM		VENDORCONTACTS VC, VENDORS V
	WHERE	VC.VENDORID = V.VENDORID
	ORDER BY	V.VENDORNAME, VC.CONTACTNAME
</CFQUERY>

<CFQUERY name="ListIDTReviewers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, CUST.INITIALS, U.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
			CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U, FACILITIESMGR.LOCATIONS LOC
	WHERE	(CUST.UNITID = U.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES') AND
			((CUST.CUSTOMERID = 0) OR
			(U.GROUPID = 4 AND
			NOT CUST.INITIALS = ' '))
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="GetIDTReviewers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, U.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
			CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U, FACILITIESMGR.LOCATIONS LOC
	WHERE	CUST.CUSTOMERID = #Client.CUSTOMERID# AND
			CUST.UNITID = U.UNITID AND
			U.GROUPID = 4 AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<!--- 
***************************************************************************
* The following code is the ADD Process for Legacy Purchase Requisitions. *
***************************************************************************
 --->
<CFSET client.STAFFLOOP = 'NO'>
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Add IDT Legacy Purchase Requisitions</H1></TD>
	</TR>
</TABLE>

<CFQUERY name="GetMaxUniqueID" datasource="#application.type#PURCHASING">
	SELECT	MAX(PURCHREQID) AS MAX_ID
	FROM		PURCHREQS
</CFQUERY>
<CFSET FORM.PURCHREQID = #val(GetMaxUniqueID.MAX_ID+1)#>
<CFCOOKIE name="PURCHREQID" secure="NO" value="#FORM.PURCHREQID#">
<CFSET FORM.CREATIONDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
<CFQUERY name="AddPurchReqsIDInfo" datasource="#application.type#PURCHASING">
	INSERT INTO	PURCHREQS (PURCHREQID, CREATIONDATE)
	VALUES		(#val(Cookie.PURCHREQID)#, TO_DATE('#FORM.CREATIONDATE#', 'DD-MON-YYYY'))
</CFQUERY>

<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
	</TR>
	<TR>
		<TH align= "CENTER">
			Purchase Requisitions Key &nbsp; = &nbsp; #FORM.PURCHREQID# &nbsp;&nbsp;Created: &nbsp;&nbsp;#DateFormat(FORM.CREATIONDATE, "mm/dd/yyyy")#
		</TH>
	</TR>
</TABLE>
<BR clear="left" />

<TABLE width="100%" align="LEFT" border="0">
	<TR>
<CFFORM action="/#application.type#apps/purchasing/processpurchreqaddlegacy.cfm" method="POST">
		<TD align="LEFT" colspan="2">
          	<INPUT type="hidden" name="PROCESSPURCHREQ" value="CANCELADD" />
			<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
		<TD>&nbsp;&nbsp;</TD>
	</TR>
<CFFORM name="PURCHASEREQUISITIONS" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processpurchreqaddlegacy.cfm" method="POST" ENABLECAB="Yes">
	<TR>
		<TH align="left"><H4><LABEL for="SERVICEREQUESTNUMBER">*SR</LABEL></H4></TH>
		<TH align="left"><H4><LABEL for="FISCALYEARID">*Fiscal Year</LABEL></H4></TH>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="Text" name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" value="" align="LEFT" required="No" size="10" maxlength="10" tabindex="2">
		</TD>
		<TD align="left">
			<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#ListCurrentFiscalYear.FISCALYEARID#" required="No" tabindex="3"></CFSELECT>
		</TD>
	</TR>
	<TR>
		<TH align="left"><H4><LABEL for="REQUESTERID">*Requester</LABEL></H4></TH>
		<TH align="left"><H4><LABEL for="PURCHREQUNITID">*Req Unit</LABEL></H4></TH>
	</TR>
	<TR>
		<TD align="left" nowrap>
			<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="4"></CFSELECT>
		</TD>
		<TD align="left" nowrap>
			<CFSELECT name="PURCHREQUNITID" id="PURCHREQUNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="0" required="No" tabindex="5"></CFSELECT>
		</TD>
	</TR>
	<TR>
		<TH align="left" colspan="2"><H4><LABEL for="PURCHASEJUSTIFICATION">*Purchase Justification</LABEL></H4></TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP" colspan="2">
			<CFTEXTAREA name="PURCHASEJUSTIFICATION" id="PURCHASEJUSTIFICATION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="6"></CFTEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="left"><LABEL for="RUSH">Rush</LABEL></TH>
		<TH align="left"><LABEL for="RUSHJUSTIFICATION">Rush Justification</LABEL></TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP">
			<CFSELECT name="RUSH" id="RUSH" size="1" tabindex="7">
				<OPTION selected value="NO">NO</OPTION>
				<OPTION value="YES">YES</OPTION>
			</CFSELECT>
			</TD>
		<TD align="left" valign="TOP">
			<CFTEXTAREA name="RUSHJUSTIFICATION" id="RUSHJUSTIFICATION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="8"></CFTEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="left"><H4><LABEL for="FUNDACCTID">*Funds</LABEL></H4></TH>
		<TH align="left">SubTotal</TH>
	</TR>
	<TR>
		<TD align="left">
			<CFSELECT name="FUNDACCTID" id="FUNDACCTID" size="1" query="ListFundAccts" value="FUNDACCTID" display="FUNDACCTNAME" selected="0" required="No" tabindex="9"></CFSELECT>
		</TD>
		<TD align="left">
			0.00
		</TD>
	</TR>
	<TR>
		<TH align="left"><LABEL for="SHIPPINGCOST">Shipping</LABEL></TH>
		<TH align="left"><LABEL for="TOTAL">Total Price</LABEL></TH>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="Text" name="SHIPPINGCOST" id="SHIPPINGCOST" value="0.00" align="LEFT" required="No" size="18" maxlength="20" tabindex="11">
		</TD>
		<TD align="left">
			<CFINPUT type="Text" name="TOTAL" id="TOTAL" value="0.00" align="LEFT" required="No" size="18" maxlength="20" tabindex="12">
		</TD>
	</TR>
	<TR>
		
		<TH align="left"><LABEL for="REQNUMBER">Requisition Number</LABEL></TH>
		<TH align="left"><LABEL for="SALESORDERNUMBER">Sales Order Number</LABEL></TH>
	</TR>
	<TR>
		<TD align="left"><CFINPUT type="Text" name="REQNUMBER" id="REQNUMBER" value="" align="LEFT" required="No" size="50" maxlength="100" tabindex="13"></TD>
		<TD align="left"><CFINPUT type="Text" name="SALESORDERNUMBER" id="SALESORDERNUMBER" value="" align="LEFT" required="No" size="50" maxlength="100" tabindex="14"></TD>
	</TR>
	<TR>
          <TH align="left"><H4><LABEL for="BUDGETTYPENAME">*Budget Type Name</LABEL></H4></TH>
          <TH align="left"><LABEL for="PONUMBER">P. O. Number</LABEL></TH>
     </TR>
     <TR>
          <TD align="left">
               <CFSELECT name="BUDGETTYPEID" id="BUDGETTYPEID" size="1" query="ListBudgetTypes" value="BUDGETTYPEID" display="BUDGETTYPENAME" selected="2" required="No" tabindex="15"></CFSELECT>
          </TD>
          <TD align="left"><CFINPUT type="Text" name="PONUMBER" id="PONUMBER" value="" align="LEFT" required="No" size="50" maxlength="100" tabindex="16"></TD>
     </TR>
	<TR>
		<TH align="left"><LABEL for="VENDORID">Suggested Vendor</LABEL></TH>
		<TH align="left">&nbsp;&nbsp;</TH>
	</TR>
	<TR>
		<TD align="left">
			<CFSELECT name="VENDORID" id="VENDORID" size="1" query="ListPurchaseVendors" value="VENDORID" display="VENDORNAME" selected="0" required="No" tabindex="17"></CFSELECT>
		</TD>
		<TD align="left">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TH align="left"><LABEL for="QUOTEDATE">Quote Date</LABEL></TH>
		<TH align="left"><LABEL for="QUOTE">Quote</LABEL></TH>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="Text" name="QUOTEDATE" id="QUOTEDATE" value="" align="LEFT" required="No" size="10" tabindex="18">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'PURCHASEREQUISITIONS','controlname': 'QUOTEDATE'});

			</SCRIPT>
			<BR>
			<COM>MM/DD/YYYYY </COM>
		</TD>
		<TD align="left">
			<CFINPUT type="Text" name="QUOTE" id="QUOTE" value="" align="LEFT" required="No" size="50" tabindex="19">
		</TD>
	</TR>
	<TR>
		<TH align="left" colspan="2"><LABEL for="SPECSCOMMENTS">Specs Comments</LABEL></TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP" colspan="2">
			<CFTEXTAREA name="SPECSCOMMENTS" id="SPECSCOMMENTS" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="20">SEE ATTACHED QUOTE.</CFTEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="left"><LABEL for="IDTREVIEWERID">IDT Reviewer</LABEL></TH>
		<TH align="left">Unit</TH>
	</TR>
	<TR>
		<TD align="left">
			<CFSELECT name="IDTREVIEWERID" id="IDTREVIEWERID" size="1" query="ListIDTReviewers" value="CUSTOMERID" display="FULLNAME" selected="#GetIDTReviewers.CUSTOMERID#" required="No" tabindex="21"></CFSELECT>
		</TD>
		<TD align="left">
			#GetIDTReviewers.UNITNAME#
		</TD>
	</TR>
	<TR>
		<TH align="left" colspan="3"><LABEL for="RECVCOMMENTS">Receiving Comments</LABEL></TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP" colspan="3">
			<CFTEXTAREA name="RECVCOMMENTS" id="RECVCOMMENTS" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="22"></CFTEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="left"><LABEL for="REVIEWDATE">Review Date</LABEL></TH>
		<TH align="left"><LABEL for="REQFILEDDATE">Filed Date</LABEL></TH>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="Text" name="REVIEWDATE" id="REVIEWDATE" value="" align="LEFT" required="No" size="10" tabindex="23">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'PURCHASEREQUISITIONS','controlname': 'REVIEWDATE'});

			</SCRIPT>
			<BR>
			<COM>MM/DD/YYYYY </COM>
		</TD>
		<TD align="left">
			<CFINPUT type="Text" name="REQFILEDDATE" VID="REQFILEDDATE" ALUE="" align="LEFT" required="No" size="10" tabindex="24">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'PURCHASEREQUISITIONS','controlname': 'REQFILEDDATE'});

			</SCRIPT>
			<BR>
			<COM>MM/DD/YYYYY </COM>
		</TD>
	</TR>
	<TR>
		
		<TH align="left"><LABEL for="COMPLETEFLAG">Complete</LABEL></TH>
		<TH align="left"><LABEL for="SWFLAG">SWFlag</LABEL></TH>
	</TR>
	<TR>
		<TD align="left">
			<CFSELECT name="COMPLETEFLAG" id="COMPLETEFLAG" size="1" tabindex="25">
				<OPTION value="CANCEL">CANCEL</OPTION>
				<OPTION selected value="NO">NO</OPTION>
				<OPTION value="YES">YES</OPTION>
			</CFSELECT>
		</TD>
		<TD align="left">
			<CFSELECT name="SWFLAG" id="SWFLAG" size="1" tabindex="26">
				<OPTION selected value="NO">NO</OPTION>
				<OPTION value="YES">YES</OPTION>
			</CFSELECT>
		</TD>
	</TR>
	<TR>
		<TD align="left">
               	<INPUT type="hidden" name="PROCESSPURCHREQ" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="27" />
			</TD>
		<TD align="left">
			<INPUT type="image" src="/images/buttonAddPurchReqLine.jpg" value="Add Purch Req Line" alt="Add Purch Req Line"
			onClick="window.open('/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=ADD&PURCHREQID=#Cookie.PURCHREQID#','Add Purch Req Lines','alwaysRaised=yes,dependent=no,width=1200,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
			tabindex="28" />
		</TD>
	</TR>
</CFFORM>
	<TR>
<CFFORM action="/#application.type#apps/purchasing/processpurchreqaddlegacy.cfm" method="POST">
		<TD align="LEFT">
			<INPUT type="hidden" name="PROCESSPURCHREQ" value="CANCELADD" />
			<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="29" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>