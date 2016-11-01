<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: purchreqinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: Add, Modify and Delete IDT Purchase Requisitions--->
<!-- Last modified by John R. Pastori on 05/17/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/purchreqinfo.cfm">
<CFSET CONTENT_UPDATED = "May 17, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>

	<CFIF NOT IsDefined('URL.PROCESS')>
		<CFSET URL.PROCESS = "ADD">
	</CFIF>

	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add IDT Purchase Requisitions</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete IDT Purchase Requisitions</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JAVASCRIPT">
	window.defaultStatus = "Welcome to IDT Purchasing";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}
	
	
	function closewindow() {
		window.close();
	}

	function validateReqFields() {
		if (document.PURCHASEREQUISITIONS.SERVICEREQUESTNUMBER.selectedIndex == "0" || document.PURCHASEREQUISITIONS.SERVICEREQUESTNUMBER.value == "" 
		 || document.PURCHASEREQUISITIONS.SERVICEREQUESTNUMBER.value == " ") {
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
		
		if (document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION != null && document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION.length > 600) {
			alertuser (document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION.name +  ",  The maximum field length of 600 characters has been exceeded!  Spaces are counted.");
			document.PURCHASEREQUISITIONS.PURCHASEJUSTIFICATION.focus();
			return false;
		}
		
		if (document.PURCHASEREQUISITIONS.RUSHJUSTIFICATION != null && document.PURCHASEREQUISITIONS.RUSHJUSTIFICATION.length > 600) {
			alertuser (document.PURCHASEREQUISITIONS.RUSHJUSTIFICATION.name +  ",  The maximum field length of 600 characters has been exceeded!  Spaces are counted.");
			document.PURCHASEREQUISITIONS.RUSHJUSTIFICATION.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.FUNDACCTID.selectedIndex == "0") {
			alertuser (document.PURCHASEREQUISITIONS.FUNDACCTID.name +  ",  You must select an Fund Account Name.");
			document.PURCHASEREQUISITIONS.FUNDACCTID.focus();
			return false;
		}

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

		if (document.PURCHASEREQUISITIONS.QUOTEDATE != null && !document.PURCHASEREQUISITIONS.QUOTEDATE.value == "" && !document.PURCHASEREQUISITIONS.QUOTEDATE.value == " " 
		 && !document.PURCHASEREQUISITIONS.QUOTEDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.PURCHASEREQUISITIONS.QUOTEDATE.name +  ", The desired Quote Date MUST be entered in the format MM/DD/YYYY!");
			document.PURCHASEREQUISITIONS.QUOTEDATE.focus();
			return false;
		}
		
		if (document.PURCHASEREQUISITIONS.QUOTE != null && document.PURCHASEREQUISITIONS.QUOTE.value.length > 50) {
			alertuser (document.PURCHASEREQUISITIONS.QUOTE.name +  ",  The maximum field length of 50 characters has been exceeded!  Spaces are counted.");
			document.PURCHASEREQUISITIONS.QUOTE.focus();
			return false;
		}
		
		if (document.PURCHASEREQUISITIONS.SPECSCOMMENTS != null && document.PURCHASEREQUISITIONS.SPECSCOMMENTS.value.length > 600) {
			alertuser (document.PURCHASEREQUISITIONS.SPECSCOMMENTS.name +  ",  The maximum field length of 600 characters has been exceeded!  Spaces are counted.");
			document.PURCHASEREQUISITIONS.SPECSCOMMENTS.focus();
			return false;
		}
		
		if (document.PURCHASEREQUISITIONS.RECVCOMMENTS != null && document.PURCHASEREQUISITIONS.RECVCOMMENTS.value.length > 1000) {
			alertuser (document.PURCHASEREQUISITIONS.RECVCOMMENTS.name +  ",  The maximum field length of 1000 characters has been exceeded!  Spaces are counted.");
			document.PURCHASEREQUISITIONS.RECVCOMMENTS.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.REVIEWDATE != null && !document.PURCHASEREQUISITIONS.REVIEWDATE.value == "" && !document.PURCHASEREQUISITIONS.REVIEWDATE.value == " " 
		 && !document.PURCHASEREQUISITIONS.REVIEWDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.PURCHASEREQUISITIONS.REVIEWDATE.name +  ", The desired Review Date MUST be entered in the format MM/DD/YYYY!");
			document.PURCHASEREQUISITIONS.REVIEWDATE.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.REQFILEDDATE != null && !document.PURCHASEREQUISITIONS.REQFILEDDATE.value == "" && !document.PURCHASEREQUISITIONS.REQFILEDDATE.value == " " 
		 && !document.PURCHASEREQUISITIONS.REQFILEDDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.PURCHASEREQUISITIONS.REQFILEDDATE.name +  ", The desired Filed Date MUST be entered in the format MM/DD/YYYY!");
			document.PURCHASEREQUISITIONS.REQFILEDDATE.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONS.COMPLETIONDATE != null && !document.PURCHASEREQUISITIONS.COMPLETIONDATE.value == "" && !document.PURCHASEREQUISITIONS.COMPLETIONDATE.value == " " 
		 && !document.PURCHASEREQUISITIONS.COMPLETIONDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.PURCHASEREQUISITIONS.COMPLETIONDATE.name +  ", The desired Completion Date MUST be entered in the format MM/DD/YYYY!");
			document.PURCHASEREQUISITIONS.COMPLETIONDATE.focus();
			return false;
		}

	}


	function validateLookupField() {
		if (document.LOOKUP.PURCHREQID1.selectedIndex == "0" && document.LOOKUP.PURCHREQID2.selectedIndex == "0" && document.LOOKUP.PONUMBER.value == "") {
			alertuser ("Either an SR MUST be selected or a Purchase Order Number must be entered!");
			document.LOOKUP.PURCHREQID1.focus();
			return false;
		}
		if ((document.LOOKUP.PURCHREQID1.selectedIndex > "0" || document.LOOKUP.PURCHREQID2.selectedIndex > "0") && document.LOOKUP.PONUMBER.value != "") {
			alertuser ("Either an SR MUST be selected or a Purchase Order Number must be entered!  You cannot choose both.");
			document.LOOKUP.PURCHREQID1.focus();
			return false;
		}
	}

	
	function setAddModify() {
		document.PURCHASEREQUISITIONS.PROCESSPURCHREQ.value = "ADD/MODIFY";
		return true;
	}
			
	
	function setModToPrint() {
		document.PURCHASEREQUISITIONS.PROCESSPURCHREQ.value = "MODIFY TO PRINT";
		return true;
	}
			
	
	function setDelete() {
		document.PURCHASEREQUISITIONS.PROCESSPURCHREQ.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<CFIF NOT IsDefined('URL.LOOKUPPURCHREQ') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.PURCHREQID1.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.PURCHASEREQUISITIONS.SERVICEREQUESTNUMBER.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

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
			SR.SERVICEREQUESTNUMBER || ' - ' || CUST.FULLNAME || ' - ' || PSC.SUBCATEGORYNAME AS LOOKUPKEY
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
			CUST.EMAIL, CUST.ACTIVE, U.DEPARTMENTID
	FROM		CUSTOMERS CUST, UNITS U, FACILITIESMGR.LOCATIONS LOC
	WHERE	(CUST.UNITID = U.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID) AND
			(CUST.CUSTOMERID = 0 OR
			U.DEPARTMENTID = 8)
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	UNITID, UNITNAME, CAMPUSMAILCODEID, GROUPID, DEPARTMENTID, SUPERVISORID, ACTIVEUNIT
	FROM		UNITS
	WHERE 	(UNITID = 0) OR
			(DEPARTMENTID = 8 AND
			ACTIVEUNIT = 'YES')
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

<!--- 
********************************************************************
* The following code is the ADD Process for Purchase Requisitions. *
********************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>

	<CFIF IsDefined('URL.SRID')>
		<CFSET FORM.SRID = #URL.SRID#>
		<CFSET PROCESSPGMADD = 'processpurchreqinfo.cfm?POPUP=YES'>

		<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
					SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID, SR.PROBLEM_CATEGORYID, PC.CATEGORYNAME,
					SR.PROBLEM_SUBCATEGORYID, PSC.SUBCATEGORYNAME, SR.PRIORITYID, SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, 	
                         SR.OPERATINGSYSTEMID, SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, 
                         SR.SRCOMPLETED, SR.SERVICEREQUESTNUMBER || ' - ' || CUST.FULLNAME || ' - ' || PSC.SUBCATEGORYNAME AS LOOKUPKEY
               FROM		SERVICEREQUESTS SR, PROBLEMCATEGORIES PC, PROBLEMSUBCATEGORIES PSC, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	(SR.PROBLEM_CATEGORYID = PC.CATEGORYID AND
                         SR.PROBLEM_SUBCATEGORYID = PSC.SUBCATEGORYID AND
                         SR.REQUESTERID = CUST.CUSTOMERID) AND
                         (SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC">)
               ORDER BY	LOOKUPKEY
          </CFQUERY>
		
		<CFQUERY name="GetFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
			SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
			FROM		FISCALYEARS
			WHERE	FISCALYEARID = <CFQUERYPARAM value="#GetServiceRequests.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FISCALYEARID
		</CFQUERY>

          <CFQUERY name="GetRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
               SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, U.UNITID, U.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
                         CUST.EMAIL, CUST.ACTIVE, U.DEPARTMENTID
               FROM		CUSTOMERS CUST, UNITS U, FACILITIESMGR.LOCATIONS LOC
               WHERE	(CUST.UNITID = U.UNITID AND
                         CUST.LOCATIONID = LOC.LOCATIONID) AND
                         (CUST.CUSTOMERID = <CFQUERYPARAM value="#GetServiceRequests.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC">)
               ORDER BY	CUST.FULLNAME
          </CFQUERY>

	<CFELSE>
		<CFSET PROCESSPGMADD = 'processpurchreqinfo.cfm'>
	</CFIF>

	<CFSET client.STAFFLOOP = 'NO'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add IDT Purchase Requisitions</H1></TD>
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
<CFFORM action="/#application.type#apps/purchasing/#PROCESSPGMADD#" method="POST">
			<TD align="LEFT" colspan="2">
               	<INPUT type="hidden" name="PROCESSPURCHREQ" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="PURCHASEREQUISITIONS" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/#PROCESSPGMADD#" method="POST" ENABLECAB="Yes">
		<TR>
		<CFIF IsDefined('FORM.SRID')>
			<TH align="left">SR - Requester - Problem Sub-Category</TH>
			<TH align="left">Fiscal Year</TH>
		<CFELSE>
			<TH align="left"><H4><LABEL for="SERVICEREQUESTNUMBER">*SR - Requester - Problem Sub-Category</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="FISCALYEARID">*Fiscal Year</LABEL></H4></TH>
		</CFIF>
		</TR>
		<TR>
			<TD align="left" VALIGN="TOP">
			<CFIF IsDefined('FORM.SRID')>
				<INPUT type="hidden" name="SERVICEREQUESTNUMBER" value="#GetServiceRequests.SERVICEREQUESTNUMBER#" />
				#GetServiceRequests.LOOKUPKEY#
			<CFELSE>
				<CFSELECT name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" size="1" query="ListServiceRequests" value="SERVICEREQUESTNUMBER" display="LOOKUPKEY" selected="0" required="No" tabindex="2"></CFSELECT>
			</CFIF>
			</TD>
			<TD align="left" VALIGN="TOP">
			<CFIF IsDefined('FORM.SRID')>
				<INPUT type="hidden" name="FISCALYEARID" value="#GetFiscalYears.FISCALYEARID#" />
				#GetFiscalYears.FISCALYEAR_4DIGIT#
			<CFELSE>
				<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#ListCurrentFiscalYear.FISCALYEARID#" required="No" tabindex="3"></CFSELECT>
			</CFIF>
			</TD>
		</TR>
		<TR>
		<CFIF IsDefined('FORM.SRID')>
			<TH align="left">Requester</TH>
			<TH align="left">Req Unit</TH>
		<CFELSE>
			<TH align="left"><H4><LABEL for="REQUESTERID">*Requester</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="PURCHREQUNITID">*Req Unit</LABEL></H4></TH>
		</CFIF>
		</TR>
		<TR>
			<TD align="left" nowrap VALIGN="TOP">
               <CFIF IsDefined('FORM.SRID')>
				<INPUT type="hidden" name="REQUESTERID" value="#GetRequesters.CUSTOMERID#" />
               	#GetRequesters.FULLNAME#
               <CFELSE>
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="4"></CFSELECT>
               </CFIF>
			</TD>
			<TD align="left" nowrap VALIGN="TOP">
                <CFIF IsDefined('FORM.SRID')>
			 	<INPUT type="hidden" name="PURCHREQUNITID" value="#GetRequesters.UNITID#" />
               	#GetRequesters.UNITNAME#
               <CFELSE>
				<CFSELECT name="PURCHREQUNITID" id="PURCHREQUNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="0" required="No" tabindex="5"></CFSELECT>
               </CFIF>
			</TD>
		</TR>
		<TR>
			<TH align="left" colspan="2"><H4><LABEL for="PURCHASEJUSTIFICATION">*Purchase Justification</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">
               <CFIF IsDefined('FORM.SRID')>
               	<CFSET SESSION.PURCHJUSTFIND1 = REFind("JUSTIFICATION:", GetServiceRequests.PROBLEM_DESCRIPTION, 1, "True")>
				<CFSET SESSION.PURCHJUSTFIND2 = REFind("RUSH", GetServiceRequests.PROBLEM_DESCRIPTION, 1, "True")>
				<CFSET SESSION.PURCHJUSTTEXTLEN = ((#SESSION.PURCHJUSTFIND2.pos[1]#) - (#SESSION.PURCHJUSTFIND1.pos[1]# + 14))>

<!--- 
				Just1 Position = #SESSION.PURCHJUSTFIND1.pos[1]# &nbsp;&nbsp;&nbsp;&nbsp;Just1 Length = #SESSION.PURCHJUSTFIND1.len[1]#<BR>
				Just2 Position = #SESSION.PURCHJUSTFIND2.pos[1]# &nbsp;&nbsp;&nbsp;&nbsp;Just2 Length = #SESSION.PURCHJUSTFIND2.len[1]#<BR>
				Just Text length = #SESSION.PURCHJUSTTEXTLEN#<BR>
 --->
 
				<CFIF SESSION.PURCHJUSTFIND1.len[1] GT 0>
                    	<CFSET SESSION.PURCHJUSTTEXT = MID(GetServiceRequests.PROBLEM_DESCRIPTION, SESSION.PURCHJUSTFIND1.pos[1] + 14, SESSION.PURCHJUSTTEXTLEN)>
               		<CFTEXTAREA name="PURCHASEJUSTIFICATION" id="PURCHASEJUSTIFICATION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="6">#SESSION.PURCHJUSTTEXT#</CFTEXTAREA>
               	<CFELSE>
					<CFTEXTAREA name="PURCHASEJUSTIFICATION" id="PURCHASEJUSTIFICATION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="6"></CFTEXTAREA>
				</CFIF>
               <CFELSE>
               	<CFTEXTAREA name="PURCHASEJUSTIFICATION" id="PURCHASEJUSTIFICATION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="6"></CFTEXTAREA>
               </CFIF>
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
			<CFIF IsDefined('FORM.SRID')>
				<CFSET SESSION.PURCHRUSHFIND1 = REFind("JUST:", GetServiceRequests.PROBLEM_DESCRIPTION, 1, "TRUE")>
				<CFSET SESSION.PURCHRUSHFIND2 = REFind("DISTRIBUTION", GetServiceRequests.PROBLEM_DESCRIPTION, 1, "TRUE")>
				<CFSET SESSION.PURCHRUSHTEXTLEN = ((#SESSION.PURCHRUSHFIND2.pos[1]#) - (#SESSION.PURCHRUSHFIND1.pos[1]# +5))>
<!--- 
				Rush1 Position = #SESSION.PURCHRUSHFIND1.pos[1]# &nbsp;&nbsp;&nbsp;&nbsp;Rush1 Length = #SESSION.PURCHRUSHFIND1.len[1]#<BR>
				Rush2 Position = #SESSION.PURCHRUSHFIND2.pos[1]# &nbsp;&nbsp;&nbsp;&nbsp;Rush2 Length = #SESSION.PURCHRUSHFIND2.len[1]#<BR>
				Rush Text length = #SESSION.PURCHRUSHTEXTLEN#<BR>
 --->
 				<CFIF SESSION.PURCHRUSHFIND1.len[1] GT 0>
					<CFSET SESSION.PURCHRUSHTEXT = MID(GetServiceRequests.PROBLEM_DESCRIPTION, SESSION.PURCHRUSHFIND1.pos[1] + 5, SESSION.PURCHRUSHTEXTLEN)>
					<CFTEXTAREA name="RUSHJUSTIFICATION" id="RUSHJUSTIFICATION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="8">#SESSION.PURCHRUSHTEXT#</CFTEXTAREA>
				<CFELSE>
					<CFTEXTAREA name="RUSHJUSTIFICATION" id="RUSHJUSTIFICATION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="8"> </CFTEXTAREA>
				</CFIF>
               <CFELSE>
               	<CFTEXTAREA name="PURCHASEJUSTIFICATION" id="PURCHASEJUSTIFICATION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="8"></CFTEXTAREA>
			</CFIF>
			</TD>
		</TR>
          <TR>
               <TH align="left" valign="BOTTOM"><LABEL for="SPECSCOMMENTS">Specs Comments</LABEL></TH>
               <TH align="left" valign="BOTTOM"><LABEL for="RECVCOMMENTS">Receiving Comments</LABEL></TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP">
                    <CFTEXTAREA name="SPECSCOMMENTS" id="SPECSCOMMENTS" rows="6" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="9">SEE ATTACHED QUOTE.</CFTEXTAREA>
               </TD>
               <TD align="left" valign="TOP">
               <CFIF IsDefined('FORM.SRID')>
				<CFSET SESSION.PURCHDISTFIND3 = REFind("DISTRIBUTION", GetServiceRequests.PROBLEM_DESCRIPTION, 1, "TRUE")>
				<CFSET SESSION.PURCHDISTTEXTLEN = ((#LEN(GetServiceRequests.PROBLEM_DESCRIPTION)#) - (#SESSION.PURCHDISTFIND3.pos[1]# - 1))>
              		<CFIF SESSION.PURCHDISTFIND3.len[1] GT 0>
                    	<CFSET SESSION.PURCHDISTTEXT = MID(GetServiceRequests.PROBLEM_DESCRIPTION, SESSION.PURCHDISTFIND3.pos[1], SESSION.PURCHDISTTEXTLEN)>
					<CFTEXTAREA name="RECVCOMMENTS" id="RECVCOMMENTS" rows="6" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="10">#SESSION.PURCHDISTTEXT#</CFTEXTAREA>
                    <CFELSE>
                    	<CFTEXTAREA name="RECVCOMMENTS" id="RECVCOMMENTS" rows="6" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="10"></CFTEXTAREA>
                    </CFIF>
<!---                     
                    Dist Position = #SESSION.PURCHDISTFIND3.pos[1]# &nbsp;&nbsp;&nbsp;&nbsp;Dist Length = #SESSION.PURCHDISTFIND3.len[1]#<BR>
				Dist Text length = #SESSION.PURCHDISTTEXTLEN#<BR>
                    Dist Text = #SESSION.PURCHDISTTEXT#<BR>
 --->                    
               <CFELSE>
               	<CFTEXTAREA name="RECVCOMMENTS" id="RECVCOMMENTS" rows="6" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="10"></CFTEXTAREA>
			</CFIF>        
               </TD>
          </TR>
		<TR>
			<TH align="left"><LABEL for="VENDORID">Suggested Vendor</LABEL></TH>
			<TH align="left"><H4><LABEL for="FUNDACCTID">*Funds</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="VENDORID" id="VENDORID" size="1" query="ListPurchaseVendors" value="VENDORID" display="VENDORNAME" selected="0" required="No" tabindex="11"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="FUNDACCTID" id="FUNDACCTID" size="1" query="ListFundAccts" value="FUNDACCTID" display="FUNDACCTNAME" selected="0" required="No" tabindex="12"></CFSELECT>
			</TD>
		</TR>
          <TR>
               <TH align="left"><H4><LABEL for="BUDGETTYPEID">*Budget Type Name</LABEL></H4></TH>
               <TH align="left">&nbsp;&nbsp;</TH>
          </TR>
          <TR>
               <TD align="left">
                    <CFSELECT name="BUDGETTYPEID" id="BUDGETTYPEID" size="1" query="ListBudgetTypes" value="BUDGETTYPEID" display="BUDGETTYPENAME" selected="2" required="No" tabindex="13"></CFSELECT>
               </TD>
               <TD align="left">&nbsp;&nbsp;</TD>
         </TR>
          <TR>
		<TR>
			<TD align="LEFT">
               	<INPUT type="hidden" name="PROCESSPURCHREQ" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="14" />
               </TD>
               <TD align="LEFT">
               	<INPUT type="image" src="/images/buttonAddModify.jpg" value="ADD/MODIFY" alt="ADD/MODIFY" OnClick="return setAddModify();" tabindex="15" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/#PROCESSPGMADD#" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="hidden" name="PROCESSPURCHREQ" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="16" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
**********************************************************************************
* The following code is the Look Up Process for Modifying Purchase Requisitions. *
**********************************************************************************
 --->

	<CFIF IsDefined('URL.LEGACY')>
	
		<CFQUERY name="LookupPurchReqsCurrFY" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.CREATIONDATE, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, PR.REQUESTERID,
					CUST.FULLNAME, PR.PURCHREQUNITID, PR.FUNDACCTID, PR.PURCHASEJUSTIFICATION, PR.RUSH, PR.RUSHJUSTIFICATION, PR.SUBTOTAL,
					PR.TOTAL, PR.REQNUMBER, PR.SALESORDERNUMBER, PR.BUDGETTYPEID, PR.PONUMBER, PR.VENDORID, PR.VENDORCONTACTID, PR.QUOTEDATE,
					PR.QUOTE, PR.SPECSCOMMENTS, PR.IDTREVIEWERID, PR.REVIEWDATE, PR.RECVCOMMENTS, PR.REQFILEDDATE, PR.COMPLETEFLAG, PR.SWFLAG,
					PR.COMPLETIONDATE, PR.SERVICEREQUESTNUMBER || ' - ' || FY.FISCALYEAR_2DIGIT || ' - ' || PR.REQNUMBER AS LOOKUPKEY
			FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.FISCALYEARS FY
			WHERE	(PR.REQUESTERID = CUST.CUSTOMERID AND
					PR.FISCALYEARID = FY.FISCALYEARID) AND
                         (PR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC"> OR
                         PR.PURCHREQID = 0)
			ORDER BY	LOOKUPKEY DESC
		</CFQUERY>
          
          <CFQUERY name="LookupPurchReqsPrevFYs" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.CREATIONDATE, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, PR.REQUESTERID,
					CUST.FULLNAME, PR.PURCHREQUNITID, PR.FUNDACCTID, PR.PURCHASEJUSTIFICATION, PR.RUSH, PR.RUSHJUSTIFICATION, PR.SUBTOTAL,
					PR.TOTAL, PR.REQNUMBER, PR.SALESORDERNUMBER, PR.BUDGETTYPEID, PR.PONUMBER, PR.VENDORID, PR.VENDORCONTACTID, PR.QUOTEDATE,
					PR.QUOTE, PR.SPECSCOMMENTS, PR.IDTREVIEWERID, PR.REVIEWDATE, PR.RECVCOMMENTS, PR.REQFILEDDATE, PR.COMPLETEFLAG, PR.SWFLAG,
					PR.COMPLETIONDATE, PR.SERVICEREQUESTNUMBER || ' - ' || FY.FISCALYEAR_2DIGIT || ' - ' || PR.REQNUMBER AS LOOKUPKEY
			FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.FISCALYEARS FY
			WHERE	(PR.REQUESTERID = CUST.CUSTOMERID AND
					PR.FISCALYEARID = FY.FISCALYEARID) AND
                         (PR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC"> OR
                         PR.PURCHREQID = 0)
			ORDER BY	LOOKUPKEY DESC
		</CFQUERY>

		<CFSET DISPLAYPGMACTION = '/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPPURCHREQ=FOUND&LEGACY=YES'>
		<CFSET PROCESSPGMMODDEL = '/#application.type#apps/purchasing/processpurchreqinfo.cfm?LEGACY=YES'>
		<CFSET RETURNLOOKUPPGMACTION = '/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=#URL.PROCESS#&LEGACY=YES'>

	<CFELSE>

		<CFQUERY name="LookupPurchReqsCurrFY" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, SR.SERVICEREQUESTNUMBER, PC.CATEGORYNAME, PSC.SUBCATEGORYNAME,
					PR.CREATIONDATE, PR.FISCALYEARID, PR.REQUESTERID, CUST.FULLNAME, PR.PURCHREQUNITID, PR.FUNDACCTID,
					PR.PURCHASEJUSTIFICATION, PR.RUSH, PR.RUSHJUSTIFICATION, PR.SUBTOTAL, PR.TOTAL, PR.REQNUMBER, PR.SALESORDERNUMBER,
					PR.BUDGETTYPEID, PR.PONUMBER, PR.VENDORID, PR.VENDORCONTACTID, PR.QUOTEDATE, PR.QUOTE, PR.SPECSCOMMENTS,
					PR.IDTREVIEWERID, PR.REVIEWDATE, PR.RECVCOMMENTS, PR.REQFILEDDATE, PR.COMPLETEFLAG, PR.SWFLAG, PR.COMPLETIONDATE,
					SR.SERVICEREQUESTNUMBER || ' - ' || CUST.FULLNAME || ' - ' || PSC.SUBCATEGORYNAME AS LOOKUPKEY
			FROM		PURCHREQS PR, SRMGR.SERVICEREQUESTS SR, SRMGR.PROBLEMCATEGORIES PC, SRMGR.PROBLEMSUBCATEGORIES PSC, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(PR.SERVICEREQUESTNUMBER LIKE SR.SERVICEREQUESTNUMBER AND
					SR.PROBLEM_CATEGORYID = PC.CATEGORYID AND
					SR.PROBLEM_SUBCATEGORYID = PSC.SUBCATEGORYID AND
					PR.REQUESTERID = CUST.CUSTOMERID) AND
                         (PR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         SR.PROBLEM_CATEGORYID = 2)
			ORDER BY	LOOKUPKEY DESC
		</CFQUERY>
          
          <CFQUERY name="LookupPurchReqsPrevFYs" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, SR.SERVICEREQUESTNUMBER, PC.CATEGORYNAME, PSC.SUBCATEGORYNAME,
					PR.CREATIONDATE, PR.FISCALYEARID, PR.REQUESTERID, CUST.FULLNAME, PR.PURCHREQUNITID, PR.FUNDACCTID,
					PR.PURCHASEJUSTIFICATION, PR.RUSH, PR.RUSHJUSTIFICATION, PR.SUBTOTAL, PR.TOTAL, PR.REQNUMBER, PR.SALESORDERNUMBER,
					PR.BUDGETTYPEID, PR.PONUMBER, PR.VENDORID, PR.VENDORCONTACTID, PR.QUOTEDATE, PR.QUOTE, PR.SPECSCOMMENTS,
					PR.IDTREVIEWERID, PR.REVIEWDATE, PR.RECVCOMMENTS, PR.REQFILEDDATE, PR.COMPLETEFLAG, PR.SWFLAG, PR.COMPLETIONDATE,
					SR.SERVICEREQUESTNUMBER || ' - ' || CUST.FULLNAME || ' - ' || PSC.SUBCATEGORYNAME AS LOOKUPKEY
			FROM		PURCHREQS PR, SRMGR.SERVICEREQUESTS SR, SRMGR.PROBLEMCATEGORIES PC, SRMGR.PROBLEMSUBCATEGORIES PSC, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(PR.SERVICEREQUESTNUMBER = SR.SERVICEREQUESTNUMBER AND
					SR.PROBLEM_CATEGORYID = PC.CATEGORYID AND
					SR.PROBLEM_SUBCATEGORYID = PSC.SUBCATEGORYID AND
					PR.REQUESTERID = CUST.CUSTOMERID) AND
                         (PR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         SR.PROBLEM_CATEGORYID = 2)
			ORDER BY	LOOKUPKEY DESC
		</CFQUERY>

		<CFSET DISPLAYPGMACTION = '/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPPURCHREQ=FOUND'>
		<CFSET PROCESSPGMMODDEL = '/#application.type#apps/purchasing/processpurchreqinfo.cfm'>
		<CFSET RETURNLOOKUPPGMACTION = '/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=#URL.PROCESS#'>

	</CFIF>

	<CFIF NOT IsDefined('URL.LOOKUPPURCHREQ')>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
			<CFIF IsDefined('URL.LEGACY')>
				<TD align="center"><H1>Modify/Delete IDT Legacy Purchase Requisitions Lookup</H1></TD>
			<CFELSE>
				<TD align="center"><H1>Modify/Delete Existing IDT Purchase Requisitions Lookup</H1></TD>
			</CFIF>
			</TR>
		</TABLE>
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>Either a dropdown item must be selected  or a Purchase Order Number must be entered in the text field.</H4></TH>
			</TR>
		</TABLE>
		<BR clear="left" />
	
		<TABLE width="100%" align="LEFT" border="0">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="#DISPLAYPGMACTION#" method="POST">
			<TR>
			<CFIF IsDefined('URL.LEGACY')>
				<TH width="30%" align="left" nowrap><LABEL for="PURCHREQID1">Select by SR - Fiscal Year - Req Number For Current Fiscal Year & CFY+1:</LABEL></TH>
                    <TD width="70%" align="LEFT">
					<CFSELECT name="PURCHREQID1" id="PURCHREQID1" size="1" query="LookupPurchReqsCurrFY" value="PURCHREQID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			<CFELSE>
				<TH width="30%" align="left" nowrap><LABEL for="PURCHREQID1">Select by SR - Requestor - Problem Sub-Category For Current Fiscal Year & CFY+1:</LABEL></TH>
				<TD width="70%" align="LEFT">
					<CFSELECT name="PURCHREQID1" id="PURCHREQID1" size="1" required="No" tabindex="2">
                         	<OPTION value="0">SR - Requestor - Problem Sub-Category</OPTION>
                              <CFLOOP query="LookupPurchReqsCurrFY">
                              	<OPTION value="#PURCHREQID#">#LOOKUPKEY#</OPTION>
                              </CFLOOP>  
                         </CFSELECT>
				</TD>
               </CFIF>
			</TR>
               <TR>
			<CFIF IsDefined('URL.LEGACY')>
				<TH width="30%" align="left" nowrap><LABEL for="PURCHREQID2">OR Select by SR - Fiscal Year - Req Number For Previous Fiscal Years:</LABEL></TH>
                    <TD width="70%" align="LEFT">
					<CFSELECT name="PURCHREQID2" id="PURCHREQID2" size="1" query="LookupPurchReqsPrevFYs" value="PURCHREQID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			<CFELSE>
				<TH width="30%" align="left" nowrap><LABEL for="PURCHREQID2">OR Select by SR - Requestor - Problem Sub-Category For Previous Fiscal Years:</LABEL></TH>
				<TD width="70%" align="LEFT">
                    	<CFSELECT name="PURCHREQID2" id="PURCHREQID2" size="1" required="No" tabindex="2">
                         	<OPTION value="0">SR - Requestor - Problem Sub-Category</OPTION>
                              <CFLOOP query="LookupPurchReqsPrevFYs">
                              	<OPTION value="#PURCHREQID#">#LOOKUPKEY#</OPTION>
                              </CFLOOP>  
                         </CFSELECT>
				</TD>
			</CFIF>
			</TR>
			<TR>
				<TH width="30%" align="left" nowrap><LABEL for="PONUMBER">OR Purchase Order Number:</LABEL></TH>
				<TD width="70%" align="LEFT"><CFINPUT type="Text" name="PONUMBER" id="PONUMBER" value="" align="LEFT" required="No" size="50" maxlength="100" tabindex="3"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
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

	<CFELSE>

<!--- 
******************************************************************************
* The following code is the Modify/Delete Process for Purchase Requisitions. *
******************************************************************************
 --->
 
		<CFIF IsDefined('FORM.PONUMBER') AND #FORM.PONUMBER# NEQ "">
			<CFQUERY name="LookupPurchReqPO" datasource="#application.type#PURCHASING">
				SELECT	PURCHREQID, PONUMBER
				FROM		PURCHREQS
				WHERE	PONUMBER = UPPER('#FORM.PONUMBER#')
				ORDER BY	PONUMBER
			</CFQUERY>
			<CFIF #LookupPurchReqPO.RecordCount# EQ 0>
				<SCRIPT language="JavaScript">
					<!-- 
						alert("Purchase Order Number Not Found");
					--> 
				</SCRIPT>
                    <CFIF IsDefined('URL.LEGACY')>
                         <META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE&LEGACY=YES" />
                    <CFELSE>
					<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE" />
                    </CFIF>
				<CFEXIT>
			</CFIF>
               
               <CFIF #LookupPurchReqPO.RecordCount# GT 1>
               	<CFIF IsDefined('URL.LEGACY')>
                    	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/lookupmoddelporeq.cfm?PROCESS=LOOKUP&LKUPPONUM=#FORM.PONUMBER#&LEGACY=YES" />
                    <CFELSE>
               	 	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/lookupmoddelporeq.cfm?PROCESS=LOOKUP&LKUPPONUM=#FORM.PONUMBER#" />
                    </CFIF>
                    <CFEXIT>
               <CFELSE>
               	<CFSET FORM.PURCHREQID = #LookupPurchReqPO.PURCHREQID#>
               </CFIF>
         
		<CFELSEIF IsDefined('FORM.PURCHREQID1') AND IsDefined('FORM.PURCHREQID2') AND #FORM.PONUMBER# EQ "">
			<CFIF FORM.PURCHREQID1 GT 0>
                    <CFSET FORM.PURCHREQID = #FORM.PURCHREQID1#>
               <CFELSE>
                    <CFSET FORM.PURCHREQID = #FORM.PURCHREQID2#>
               </CFIF>
          </CFIF>

		<CFSET RETURNWINDOWCLOSE = ''>
		<CFIF IsDefined('URL.PURCHREQID')>
			<CFSET FORM.PURCHREQID = #URL.PURCHREQID#>
               <CFIF IsDefined('URL.POPUP')>
               	<CFSET PROCESSPGMMODDEL = '/#application.type#apps/purchasing/processpurchreqinfo.cfm?POPUP=YES'>
                    <CFSET RETURNWINDOWCLOSE = 'window.close();'>
               </CFIF>
		</CFIF>
                    
		<CFCOOKIE name="PURCHREQID" secure="NO" value="#FORM.PURCHREQID#">
		<CFSET #SESSION.PurchReqID# = #Cookie.PURCHREQID#>
<!--- Calculate line totals if they exist and store them in the parent record. --->
		<CFINCLUDE template="/#application.type#apps/purchasing/calcpurchreqsubtotal.cfm">

		<CFIF IsDefined('URL.LEGACY')>

			<CFQUERY name="GetPurchReqs" datasource="#application.type#PURCHASING">
				SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.CREATIONDATE, PR.FISCALYEARID, PR.REQUESTERID, CUST.FULLNAME, PR.PURCHREQUNITID,
						PR.FUNDACCTID, PR.PURCHASEJUSTIFICATION, PR.RUSH, PR.RUSHJUSTIFICATION, PR.SUBTOTAL, PR.SHIPPINGCOST, PR.TOTAL, PR.REQNUMBER,
						PR.SALESORDERNUMBER, PR.BUDGETTYPEID, PR.PONUMBER, PR.VENDORID, PR.VENDORCONTACTID, PR.QUOTEDATE, PR.QUOTE, PR.SPECSCOMMENTS,
						PR.IDTREVIEWERID, PR.REVIEWDATE, PR.RECVCOMMENTS, PR.REQFILEDDATE, PR.COMPLETEFLAG, PR.SWFLAG, PR.COMPLETIONDATE,
						PR.CANCELLATION, PR.SERVICEREQUESTNUMBER || ' - ' || CUST.FULLNAME AS LOOKUPKEY
				FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST
				WHERE	PR.PURCHREQID = <CFQUERYPARAM value="#Cookie.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> AND
						PR.REQUESTERID = CUST.CUSTOMERID
				ORDER BY	LOOKUPKEY
			</CFQUERY>

		<CFELSE>

			<CFQUERY name="GetPurchReqs" datasource="#application.type#PURCHASING">
				SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, SR.SERVICEREQUESTNUMBER, PR.CREATIONDATE, PR.FISCALYEARID, PR.REQUESTERID,
						CUST.FULLNAME, PR.PURCHREQUNITID, PR.FUNDACCTID, PR.PURCHASEJUSTIFICATION, PR.RUSH, PR.RUSHJUSTIFICATION, 
						PR.SUBTOTAL, PR.SHIPPINGCOST, PR.TOTAL, PR.REQNUMBER, PR.SALESORDERNUMBER, PR.BUDGETTYPEID, PR.PONUMBER, PR.VENDORID,
						PR.VENDORCONTACTID, PR.QUOTEDATE, PR.QUOTE, PR.SPECSCOMMENTS, PR.IDTREVIEWERID, PR.REVIEWDATE, PR.RECVCOMMENTS, PR.REQFILEDDATE,
						PR.COMPLETEFLAG, PR.SWFLAG, PR.COMPLETIONDATE, PR.CANCELLATION, SR.SERVICEREQUESTNUMBER || ' - ' || CUST.FULLNAME AS LOOKUPKEY
				FROM		PURCHREQS PR, SRMGR.SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
				WHERE	PR.PURCHREQID = <CFQUERYPARAM value="#Cookie.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> AND
						PR.SERVICEREQUESTNUMBER = SR.SERVICEREQUESTNUMBER AND
						PR.REQUESTERID = CUST.CUSTOMERID
				ORDER BY	LOOKUPKEY
			</CFQUERY>
               
               <CFIF #GetPurchReqs.RecordCount# EQ 0>
				<SCRIPT language="JavaScript">
                         <!-- 
                              alert("Requisition Number/Service Request Number Not Found");
                         --> 
                    </SCRIPT>
                    <META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE" />
                    <CFEXIT>
               </CFIF>

		</CFIF>

		<CFQUERY name="GetBudgetTypes" datasource="#application.type#PURCHASING">
			SELECT	BUDGETTYPEID, BUDGETTYPENAME
			FROM		BUDGETTYPES
			WHERE	BUDGETTYPEID = <CFQUERYPARAM value="#GetPurchReqs.BUDGETTYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	BUDGETTYPENAME
		</CFQUERY>

		<CFQUERY name="GetPurchaseVendors" datasource="#application.type#PURCHASING">
			SELECT	V.VENDORID, V.VENDORNAME, V.ADDRESSLINE1, V.ADDRESSLINE2, V.CITY, V.STATEID, V.ZIPCODE, V.WEBSITE, V.COMMENTS
			FROM		VENDORS V
			WHERE 	V.VENDORID = <CFQUERYPARAM value="#GetPurchReqs.VENDORID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	V.VENDORNAME
		</CFQUERY>

		<CFQUERY name="GetVendorContacts" datasource="#application.type#PURCHASING">
			SELECT	VC.VENDORCONTACTID, VC.VENDORID, VC.CONTACTNAME, VC.PHONENUMBER, VC.FAXNUMBER, VC.EMAILADDRESS, VC.COMMENTS
			FROM		VENDORCONTACTS VC
			WHERE	VC.VENDORCONTACTID = 0 OR
					VC.VENDORID = <CFQUERYPARAM value="#GetPurchaseVendors.VENDORID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	VC.CONTACTNAME
		</CFQUERY>

		<CFQUERY name="GetState" datasource="#application.type#LIBSHAREDDATA">
			SELECT	STATEID, STATECODE, STATENAME, STATECODE || ' - ' || STATENAME AS STATECODENAME
			FROM		STATES
			WHERE	STATEID = <CFQUERYPARAM value="#GetPurchaseVendors.STATEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATECODE
		</CFQUERY>

		<CFQUERY name="GetIDTReviewers" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, U.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
					CUST.EMAIL, CUST.ACTIVE
			FROM		CUSTOMERS CUST, UNITS U, FACILITIESMGR.LOCATIONS LOC
		<CFIF #GetPurchReqs.IDTREVIEWERID# EQ 0>
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
		<CFELSE>
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetPurchReqs.IDTREVIEWERID#" cfsqltype="CF_SQL_NUMERIC"> AND
		</CFIF>
					CUST.UNITID = U.UNITID AND
					U.GROUPID = 4 AND
					CUST.LOCATIONID = LOC.LOCATIONID AND
					CUST.ACTIVE = 'YES'
			ORDER BY	CUST.FULLNAME
		</CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
			<CFIF IsDefined('URL.LEGACY')>
				<TD align="center"><H1>Modify/Delete IDT Legacy Purchase Requisitions</H1></TD>
			<CFELSE>
				<TD align="center"><H1>Modify/Delete Existing IDT Purchase Requisitions</H1></TD>
			</CFIF>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
			<TR>
				<TH align= "CENTER">
					Purchase Requisitions Key &nbsp; = &nbsp; #GetPurchReqs.PURCHREQID# &nbsp;&nbsp;Created: &nbsp;&nbsp;#DateFormat(GetPurchReqs.CREATIONDATE, "mm/dd/yyyy")#
				</TH>
			</TR>
		</TABLE>
	
		<TABLE width="100%" align="left" border="0">
			<TR>

<CFFORM onsubmit="#RETURNWINDOWCLOSE#" action="#RETURNLOOKUPPGMACTION#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
<CFFORM name="PURCHASEREQUISITIONS" onsubmit="return validateReqFields();" action="#PROCESSPGMMODDEL#" method="POST" ENABLECAB="Yes">
			<TR>
			<CFIF IsDefined('URL.LEGACY')>
				<TH align="left" valign="BOTTOM">SR</TH>
			<CFELSE>
				<TH align="left" valign="BOTTOM">SR - Requester</TH>
			</CFIF>
				<TH align="left" valign="BOTTOM"> <H4><LABEL for="FISCALYEARID">*Fiscal Year</LABEL></H4> </TH>
			</TR>
			<TR>
				<TD align="left">
				<CFIF IsDefined('URL.LEGACY')>
					#GetPurchReqs.SERVICEREQUESTNUMBER#
				<CFELSE>
					#GetPurchReqs.LOOKUPKEY#
				</CFIF>
				</TD>
				<TD align="left">
					<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#GetPurchReqs.FISCALYEARID#" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="BOTTOM"> <H4><LABEL for="REQUESTERID">*Requester</LABEL></H4> </TH>
				<TH align="left" valign="BOTTOM"> <H4><LABEL for="PURCHREQUNITID">*Req Unit</LABEL></H4> </TH>
			</TR>
			<TR>
				<TD align="left" nowrap>
					<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="#GetPurchReqs.REQUESTERID#" required="No" tabindex="3"></CFSELECT>
				</TD>
				<TD align="left" nowrap>
					<CFSELECT name="PURCHREQUNITID" id="PURCHREQUNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="#GetPurchReqs.PURCHREQUNITID#" required="No" tabindex="4"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" colspan="2"> <H4><LABEL for="PURCHASEJUSTIFICATION">*Purchase Justification</LABEL></H4> </TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP" colspan="2">
					<CFTEXTAREA name="PURCHASEJUSTIFICATION" id="PURCHASEJUSTIFICATION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="5">#GetPurchReqs.PURCHASEJUSTIFICATION#</CFTEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="RUSH">Rush</LABEL></TH>
				<TH align="left"><LABEL for="RUSHJUSTIFICATION">Rush Justification</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="RUSH" id="RUSH" size="1" tabindex="6">
						<OPTION selected value="#GetPurchReqs.RUSH#">#GetPurchReqs.RUSH#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
					</TD>
				<TD align="left" valign="TOP">
					<CFTEXTAREA name="RUSHJUSTIFICATION" id="RUSHJUSTIFICATION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="7">#GetPurchReqs.RUSHJUSTIFICATION#</CFTEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="BOTTOM"> <H4><LABEL for="FUNDACCTID">*Funds</LABEL></H4> </TH>
				<TH align="left">SubTotal</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="FUNDACCTID" id="FUNDACCTID" size="1" query="ListFundAccts" value="FUNDACCTID" display="FUNDACCTNAME" selected="#GetPurchReqs.FUNDACCTID#" required="No" tabindex="8"></CFSELECT>
				</TD>
				<TD align="left">
					<INPUT type="hidden" name="SUBTOTAL" value="#GetPurchReqs.SUBTOTAL#" />
					#NumberFormat(GetPurchReqs.SUBTOTAL, '________.__')#
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="SHIPPINGCOST">Shipping</LABEL></TH>
				<TH align="left"><LABEL for="TOTAL">Total Price</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="SHIPPINGCOST" id="SHIPPINGCOST" value="#NumberFormat(GetPurchReqs.SHIPPINGCOST, '________.__')#" align="LEFT" required="No" size="18" maxlength="20" tabindex="9">
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="TOTAL" id="TOTAL" value="#NumberFormat(GetPurchReqs.TOTAL, '________.__')#" align="LEFT" required="No" size="18" maxlength="20" tabindex="10">
				</TD>
			</TR>
			<TR>
				
				<TH align="left"><LABEL for="REQNUMBER">Requisition Number</LABEL></TH>
				<TH align="left"><LABEL for="SALESORDERNUMBER">Sales Order Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="REQNUMBER" id="REQNUMBER" value="#GetPurchReqs.REQNUMBER#" align="LEFT" required="No" size="50" maxlength="100" tabindex="11"></TD>
				<TD align="left"><CFINPUT type="Text" name="SALESORDERNUMBER" id="SALESORDERNUMBER" value="#GetPurchReqs.SALESORDERNUMBER#" align="LEFT" required="No" size="50" maxlength="100" tabindex="12"></TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="BUDGETTYPEID">*Budget Type Name</LABEL></H4></TH>
				<TH align="left"><LABEL for="PONUMBER">P. O. Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
                    	<CFSELECT name="BUDGETTYPEID" id="BUDGETTYPEID" size="1" query="ListBudgetTypes" value="BUDGETTYPEID" display="BUDGETTYPENAME" selected="#GetBudgetTypes.BUDGETTYPEID#" required="No" tabindex="13"></CFSELECT>
                    </TD>
				<TD align="left"><CFINPUT type="Text" name="PONUMBER" id="PONUMBER" value="#GetPurchReqs.PONUMBER#" align="LEFT" required="No" size="50" maxlength="100" tabindex="14"></TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="VENDORID">Suggested Vendor</LABEL></TH>
				<TH align="left"><LABEL for="VENDORCONTACTID">Contact Name</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="VENDORID" id="VENDORID" size="1" query="ListPurchaseVendors" value="VENDORID" display="VENDORNAME" selected="#GetPurchReqs.VENDORID#" required="No" tabindex="15"></CFSELECT>
				</TD>
				<TD align="left">
				<CFIF #GetPurchReqs.VENDORCONTACTID# EQ 0>
					<CFSELECT name="VENDORCONTACTID" id="VENDORCONTACTID" size="1" query="GetVendorContacts" value="VENDORCONTACTID" display="CONTACTNAME" selected="0" required="No" tabindex="16"></CFSELECT>
				<CFELSE>
					<CFSELECT name="VENDORCONTACTID" id="VENDORCONTACTID" size="1" query="GetVendorContacts" value="VENDORCONTACTID" display="CONTACTNAME" selected="#GetPurchReqs.VENDORCONTACTID#" required="No" tabindex="16"></CFSELECT>
				</CFIF>
				</TD>
			</TR>
	
			<CFQUERY name="GetVendorContactInfo" datasource="#application.type#PURCHASING">
				SELECT	VC.VENDORCONTACTID, VC.VENDORID, VC.CONTACTNAME, VC.PHONENUMBER, VC.FAXNUMBER, VC.EMAILADDRESS, VC.COMMENTS
				FROM		VENDORCONTACTS VC
				WHERE	VC.VENDORCONTACTID = <CFQUERYPARAM value="#GetPurchReqs.VENDORCONTACTID#" cfsqltype="CF_SQL_NUMERIC">
				ORDER BY	VC.CONTACTNAME
			</CFQUERY>
	
			<TR>
				<TD align="left">#GetPurchaseVendors.ADDRESSLINE1#</TD>
				<TD align="left">#GetVendorContactInfo.PHONENUMBER#</TD>
			</TR>
			<TR>
				<TD align="left">#GetPurchaseVendors.ADDRESSLINE2#</TD>
				<TD align="left">#GetVendorContactInfo.FAXNUMBER#</TD>
			</TR>
			<TR>
				<TD align="left">#GetPurchaseVendors.CITY# &nbsp;&nbsp;&nbsp;&nbsp; #GetState.STATECODENAME#</TD>
				<TD align="left" valign="top">#GetVendorContactInfo.EMAILADDRESS#</TD>
			</TR>
			<TR>
				<TD align="left">#GetPurchaseVendors.ZIPCODE#</TD>
				<TD align="left">#GetPurchaseVendors.WEBSITE#</TD>
			</TR>
                <TR>
				<TH align="left" colspan="2">Vendor Comments</TH>
			</TR>
			<TR>
				<TD align="left" colspan="2">#GetPurchaseVendors.COMMENTS#</TD>
			</TR>
              <TR>
				<TH align="left" colspan="2">Contact Comments</TH>
			</TR>
			<TR>
				<TD align="left" colspan="2">#GetVendorContactInfo.COMMENTS#</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="QUOTEDATE">Quote Date</LABEL></TH>
				<TH align="left"><LABEL for="QUOTE">Quote</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="QUOTEDATE" id="QUOTEDATE" value="#DateFormat(GetPurchReqs.QUOTEDATE, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="17">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'PURCHASEREQUISITIONS','controlname': 'QUOTEDATE'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="QUOTE" id="QUOTE" value="#GetPurchReqs.QUOTE#" align="LEFT" required="No" size="50" tabindex="18">
				</TD>
			</TR>
			<TR>
				<TH align="left" colspan="2"><LABEL for="SPECSCOMMENTS">Specs Comments</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP" colspan="2">
					<CFTEXTAREA name="SPECSCOMMENTS" id="SPECSCOMMENTS" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="19">#GetPurchReqs.SPECSCOMMENTS#</CFTEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="IDTREVIEWERID">IDT Reviewer</LABEL></TH>
				<TH align="left">Unit</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="IDTREVIEWERID" id="IDTREVIEWERID" size="1" query="ListIDTReviewers" value="CUSTOMERID" display="FULLNAME" selected="#GetIDTReviewers.CUSTOMERID#" required="No" tabindex="20"></CFSELECT>
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
					<CFTEXTAREA name="RECVCOMMENTS" id="RECVCOMMENTS" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="21">#GetPurchReqs.RECVCOMMENTS#</CFTEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="REVIEWDATE">Review Date</LABEL></TH>
				<TH align="left"><LABEL for="REQFILEDDATE">Filed Date</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="REVIEWDATE" id="REVIEWDATE" value="#DateFormat(GetPurchReqs.REVIEWDATE, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="22">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'PURCHASEREQUISITIONS','controlname': 'REVIEWDATE'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="REQFILEDDATE" id="REQFILEDDATE" value="#DateFormat(GetPurchReqs.REQFILEDDATE, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="23">
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
					<CFSELECT name="COMPLETEFLAG" id="COMPLETEFLAG" size="1" tabindex="24">
						<OPTION selected value="#GetPurchReqs.COMPLETEFLAG#">#GetPurchReqs.COMPLETEFLAG#</OPTION>
						<OPTION value="CANCEL">CANCEL</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="SWFLAG" id="SWFLAG" size="1" tabindex="25">
						<OPTION selected value="#GetPurchReqs.SWFLAG#">#GetPurchReqs.SWFLAG#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="COMPLETIONDATE">Completion Date</LABEL></TH>
				<TH align="left">Cancellation?</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="COMPLETIONDATE" id="COMPLETIONDATE" value="#DateFormat(GetPurchReqs.COMPLETIONDATE, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="26">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'PURCHASEREQUISITIONS','controlname': 'COMPLETIONDATE'});

			</SCRIPT>
			<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
				<TD align="left">
					<CFSELECT name="CANCELLATION" id="CANCELLATION" size="1" tabindex="27">
						<OPTION selected value="#GetPurchReqs.CANCELLATION#">#GetPurchReqs.CANCELLATION#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPURCHREQ" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="28" />
                    </TD>
				<TD align="left">
					<INPUT type="image" src="/images/buttonAddPurchReqLine.jpg" value="Add Purch Req Line" alt="Add Purch Req Line"
					onClick="window.open('/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=ADD&PURCHREQID=#Cookie.PURCHREQID#','Add Purch Req Lines','alwaysRaised=yes,dependent=no,width=1000,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
					tabindex="29" />
				</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonModifyToPrint.jpg" value="MODIFY TO PRINT" alt="MODIFY TO PRINT" OnClick="return setModToPrint();" tabindex="30" />
                    </TD>
				<TD align="left">
					<INPUT type="image" src="/images/buttonModPurchReqLine.jpg" value="Modify Purch Req Line" alt="Modify Purch Req Line"
					onClick="window.open('/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=MODIFYLOOP&PURCHREQID=#Cookie.PURCHREQID#&LOOKUPPURCHREQLINE=FOUND&POPUP=YES','Modify Purch Req Lines','alwaysRaised=yes,dependent=no,width=1000,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
					tabindex="31" />
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonRecvPurchReqLines.jpg" value="Receive Purch Req Lines" alt="Receive Purch Req Lines"
					onClick="window.open('/#application.type#apps/purchasing/receivepurchreqlines.cfm?PURCHREQID=#Cookie.PURCHREQID#','Receive Purch Req Lines','alwaysRaised=yes,dependent=no,width=1000,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
					tabindex="32" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="33" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM onsubmit="#RETURNWINDOWCLOSE#" action="#RETURNLOOKUPPGMACTION#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="34" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
				<TD>&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>