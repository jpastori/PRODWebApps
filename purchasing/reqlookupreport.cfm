<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: reqlookupreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/30/2012 --->
<!--- Date in Production: 07/30/2012 --->
<!--- Module: IDT Purchasing - Requisition Lookup Report --->
<!-- Last modified by John R. Pastori on 05/05/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/reqlookupreport.cfm">
<CFSET CONTENT_UPDATED = "May 05, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchasing - Requisition Lookup Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Purchasing";
	

	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {
	
		if ((document.LOOKUP.SERVICEREQUESTNUMBER.value != "Select SR") && (document.LOOKUP.SRNUMTEXT.value.length != 5)) {
			alertuser ("You CAN NOT both select a Service Request Number from the Drop Down and enter a Service Request Number in the text box!");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}
		
		if (document.LOOKUP.SRNUMTEXT.value.length != 5 && document.LOOKUP.SRNUMTEXT.value.length != 9) {
			alertuser ("You must enter a 9 character Service Request Number.");
			document.LOOKUP.SRNUMTEXT.focus();
			return false;
		}
		
		if ((document.LOOKUP.FISCALYEARID.selectedIndex > "0") && (document.LOOKUP.FISCALYEARTEXT != null
		 && !document.LOOKUP.FISCALYEARTEXT.value == " ")) {
			alertuser ("You CAN NOT both select a Fiscal Year from the Drop Down and enter a Fiscal Year in the text box!");
			document.LOOKUP.FISCALYEARID.focus();
			return false;
		}
		
		if ((document.LOOKUP.REQUESTERID.selectedIndex > "0") && (document.LOOKUP.REQUESTERNAMETEXT != null
		 && !document.LOOKUP.REQUESTERNAMETEXT.value == " ")) {
			alertuser ("You CAN NOT both select a Requester from the Drop Down and enter a Requester in the text box!");
			document.LOOKUP.REQUESTERID.focus();
			return false;
		}
		
		if ((document.LOOKUP.UNITID.selectedIndex > "0") && (document.LOOKUP.UNITNAMETEXT != null
		 && !document.LOOKUP.UNITNAMETEXT.value == " ")) {
			alertuser ("You CAN NOT both select a Requester Unit from the Drop Down and enter a Requester Unit in the text box!");
			document.LOOKUP.UNITID.focus();
			return false;
		}
		
		if ((document.LOOKUP.REQNUMBER.value != " REQ NUMBER") && (document.LOOKUP.REQNUMBERTEXT != null
		 && !document.LOOKUP.REQNUMBERTEXT.value == " ")) {
			alertuser ("You CAN NOT both select a Requisition Number from the Drop Down and enter a Requisition Number in the text box!");
			document.LOOKUP.REQNUMBER.focus();
			return false;
		}
		
		if ((document.LOOKUP.PONUMBER.value != " PO NUMBER") && (document.LOOKUP.PONUMBERTEXT != null
		 && !document.LOOKUP.PONUMBERTEXT.value == " ")) {
			alertuser ("You CAN NOT both select a P. O. Number from the Drop Down and enter a P. O. Number in the text box!");
			document.LOOKUP.PONUMBER.focus();
			return false;
		}
		
		if ((document.LOOKUP.VENDORID.selectedIndex > "0") && (document.LOOKUP.VENDORNAMETEXT != null
		 && !document.LOOKUP.VENDORNAMETEXT.value == " ")) {
			alertuser ("You CAN NOT both select a Vendor from the Drop Down and enter a Vendor in the text box!");
			document.LOOKUP.VENDORID.focus();
			return false;
		}
		
		if ((document.LOOKUP.VENDORCONTACTID.selectedIndex > "0") && (document.LOOKUP.VENDORCONTACTNAMETEXT != null
		 && !document.LOOKUP.VENDORCONTACTNAMETEXT.value == " ")) {
			alertuser ("You CAN NOT both select a Vendor Contact from the Drop Down and enter a Vendor Contact in the text box!");
			document.LOOKUP.VENDORCONTACTID.focus();
			return false;
		}
		
		if ((document.LOOKUP.IDTREVIEWERID.selectedIndex > "0") && (document.LOOKUP.IDTREVIEWERNAMETEXT != null
		 && !document.LOOKUP.IDTREVIEWERNAMETEXT.value == " ")) {
			alertuser ("You CAN NOT both select a IDT Reviewer from the Drop Down and enter a IDT Reviewer in the text box!");
			document.LOOKUP.IDTREVIEWERID.focus();
			return false;
		}
		
	}
	
	
	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPURCHREQ')>
	<CFSET CURSORFIELD = "document.LOOKUP.SERVICEREQUESTNUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*********************************************************************************************
* The following code is the Look Up Process for IDT Purchasing - Requisition Lookup Report. *
*********************************************************************************************
 --->

<CFIF NOT IsDefined("URL.LOOKUPPURCHREQ")>

	<CFQUERY name="ListPurchReqSRs" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	DISTINCT SERVICEREQUESTNUMBER
		FROM		PURCHREQS
		ORDER BY	SERVICEREQUESTNUMBER DESC
	</CFQUERY>
     
     <CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	(CURRENTFISCALYEAR = 'YES')
          ORDER BY	FISCALYEARID
     </CFQUERY>
	
	<CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
		FROM		FISCALYEARS
		ORDER BY	FISCALYEARID
	</CFQUERY>
	
	<CFQUERY name="ListRequesterCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUSTOMERID, FULLNAME
		FROM		CUSTOMERS
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFQUERY name="ListReqUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	UNITID, UNITNAME
		FROM		UNITS
		ORDER BY	UNITNAME
	</CFQUERY>
	
	<CFQUERY name="ListPurchReqNum" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	REQNUMBER
		FROM		PURCHREQS
		ORDER BY	REQNUMBER
	</CFQUERY>
	
	<CFQUERY name="ListPurchReqPOs" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PONUMBER
		FROM		PURCHREQS
		WHERE	NOT (PONUMBER IS NULL)
		ORDER BY	PONUMBER
	</CFQUERY>

	<CFQUERY name="ListVendors" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	VENDORID, VENDORNAME
		FROM		VENDORS
		ORDER BY	VENDORNAME
	</CFQUERY>

	<CFQUERY name="ListVendorContacts" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	VC.VENDORCONTACTID, V.VENDORNAME, VC.CONTACTNAME, V.VENDORNAME || ' - ' || VC.CONTACTNAME AS KEYFINDER
		FROM		VENDORCONTACTS VC, VENDORS V
		WHERE	VC.VENDORID = V.VENDORID
		ORDER BY	V.VENDORNAME, VC.CONTACTNAME
	</CFQUERY>
	
	<CFQUERY name="ListIDTReviewerCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUSTOMERID, FULLNAME, UNITID, ACTIVE
		FROM		CUSTOMERS
		WHERE	UNITID IN (38, 62, 66) AND
				ACTIVE = 'YES'
		ORDER BY	FULLNAME
	</CFQUERY>

	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>IDT Purchasing - Requisition Lookup Report</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH  align="center">
				<H2>Select from the dropdown fields or type in values to choose report criteria. <BR />
				Checking an adjacent checkbox will Negate the selection or data entered.</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	<BR />
     <FIELDSET>
	<LEGEND>SR and Requisition</LEGEND>
<CFFORM name="LOOKUP" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/reqlookupreport.cfm?LOOKUPPURCHREQ=FOUND" method="POST">
	<TABLE width="100%" align="LEFT" >
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESERVICEREQUESTNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SERVICEREQUESTNUMBER">(1) Select an SR Number</LABEL> or <BR />
				<LABEL for="SRNUMTEXT">(2) Type a full or partial SR Number</LABEL>-
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFISCALYEARID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FISCALYEARID">(1) Select a Fiscal Year</LABEL> or <BR />
				<LABEL for="FISCALYEARTEXT">(2) Type a full or partial Fiscal Year</LABEL>-
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESERVICEREQUESTNUMBER" id="NEGATESRNUMSERVICEREQUESTNUMBER" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" size="1" query="ListPurchReqSRs" value="SERVICEREQUESTNUMBER" selected="0" display="SERVICEREQUESTNUMBER" required="No" tabindex="3"></CFSELECT><BR />
				<CFINPUT type="Text" name="SRNUMTEXT" id="SRNUMTEXT" value="#ListCurrentFiscalYear.FISCALYEAR_2DIGIT#" required="No" size="25" maxlength="50" tabindex="4">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFISCALYEARID" id="NEGATEFISCALYEARID" value="" align="LEFT" required="No" tabindex="5">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="ListFiscalYears" value="FISCALYEARID" selected="0" display="FISCALYEAR_4DIGIT" required="No" tabindex="6"></CFSELECT><BR />
				<CFINPUT type="Text" name="FISCALYEARTEXT" id="FISCALYEARTEXT" value="" required="No" size="25" maxlength="50" tabindex="7">
			</TD>
		</TR>
          <TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQNUMBER">(1) Select a Requisition Number</LABEL> or <BR />
				<LABEL for="REQNUMBERTEXT">(2) Type a full or partial Requisition Number.</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPONUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PONUMBER">(1) Select a P. O. Number</LABEL> or <BR />
				<LABEL for="PONUMBERTEXT">(2) Type a full or partial P. O. Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQNUMBER" id="NEGATEREQNUMBER" value="" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="REQNUMBER" id="REQNUMBER" size="1" query="ListPurchReqNum" value="REQNUMBER" selected="0" display="REQNUMBER" required="No" tabindex="9"></CFSELECT><BR />
				<CFINPUT type="Text" name="REQNUMBERTEXT" id="REQNUMBERTEXT" value="" required="No" size="25" maxlength="50" tabindex="10">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPONUMBER" id="NEGATEPONUMBER" value="" required="No" tabindex="11">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="PONUMBER" id="PONUMBER" size="1" query="ListPurchReqPOs" value="PONUMBER" selected="0" display="PONUMBER" required="No" tabindex="12"></CFSELECT><BR />
				<CFINPUT type="Text" name="PONUMBERTEXT" id="PONUMBERTEXT" value="" required="No" size="25" maxlength="50" tabindex="13">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPURCHJUST">Negate </LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
					<LABEL for="PURCHASEJUSTIFICATION">Purchase Justification - Type a word or phrase.</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATERUSHJUST">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="RUSHJUSTIFICATION">Rush Justification - Type a word or phrase.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPURCHJUST" id="NEGATEPURCHJUST" value="" required="No" tabindex="14">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="PURCHASEJUSTIFICATION" id="PURCHASEJUSTIFICATION" value=""  required="No" size="25" maxlength="50" tabindex="15">
			</TD>
			<TD align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATERUSHJUST" id="NEGATERUSHJUST" value=""  required="No" tabindex="16">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="RUSHJUSTIFICATION" id="RUSHJUSTIFICATION" value="" required="No" size="50" tabindex="17">
			</TD>
		</TR>
          <TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESPECSCOMM">Negate </LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
					<LABEL for="SPECSCOMMENTS">Specs Comments - Type a word or phrase.</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATERECVGCOMM">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="RUSHJUSTIFICATION">Receiving Comments - Type a word or phrase.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESPECSCOMM" id="NEGATESPECSCOMM" value="" required="No" tabindex="18">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="SPECSCOMMENTS" id="SPECSCOMMENTS" value="" required="No" size="25" maxlength="50" tabindex="19">
			</TD>
			<TD align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATERECVGCOMM" id="NEGATERECVGCOMM" value="" required="No" tabindex="20">
			</TD> 
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="RECVCOMMENTS" id="RECVCOMMENTS" value="" required="No" size="50" tabindex="21">
			</TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Customer and Vendor</LEGEND>
	<TABLE width="100%" border="0">
    		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTERID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTERID">(1) Select a Requester's Name</LABEL> or <BR />
				<LABEL for="REQUESTERNAMETEXT">(2) Type a full or partial Requester's  Name</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEUNITID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="UNITID">(1) Select a Unit Name</LABEL> or <BR /> 
				<LABEL for="UNITNAMETEXT">(2) Type a full or partial Unit Name</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTERID" id="NEGATEREQUESTERID" value="" required="No" tabindex="22">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesterCustomers" value="CUSTOMERID" selected="0" display="FULLNAME" required="No" tabindex="23"></CFSELECT><BR />
				<CFINPUT type="Text" name="REQUESTERNAMETEXT" id="REQUESTERNAMETEXT" value="" required="No" size="25" maxlength="50" tabindex="24">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" required="No" tabindex="25">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="ListReqUnits" value="UNITID" selected="0" display="UNITNAME" required="No" tabindex="26"></CFSELECT><BR />
				<CFINPUT type="Text" name="UNITNAMETEXT" id="UNITNAMETEXT" value="" required="No" size="25" maxlength="50" tabindex="27">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEIDTREVIEWERID">Negate</LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="IDTREVIEWERID">(1) Select an IDT Reviewer</LABEL> or <BR /> 
				<LABEL for="IDTREVIEWERNAMETEXT">(2) Type a full or partial IDT Reviewer Name</LABEL>
			</TH>
			<TH align="left" valign="BOTTOM" width="50%" colspan="2">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEIDTREVIEWERID" id="NEGATEIDTREVIEWERID" value="" required="No" tabindex="28">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="IDTREVIEWERID" id="IDTREVIEWERID" tabindex="29">
					<OPTION value="0">IDT REVIEWER</OPTION>
					<CFLOOP query="ListIDTReviewerCustomers">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
				<BR />
				<CFINPUT type="Text" name="IDTREVIEWERNAMETEXT" id="IDTREVIEWERNAMETEXT" value="" required="No" size="25" maxlength="50" tabindex="30">
			</TD>
			<TD align="LEFT" width="50%" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEVENDORID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="VENDORID">(1) Select a Vendor Name</LABEL> or <BR />
				<LABEL for="VENDORNAMETEXT">(2) Type a full or partial Vendor Name</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEVENDORCONTACTID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="VENDORCONTACTID">(1) Select a Vendor Contact Name</LABEL> or <BR /> 
				<LABEL for="VENDORCONTACTNAMETEXT">(2) Type a full or partial Vendor Contact Name</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEVENDORID" id="NEGATEVENDORID" value="" required="No" tabindex="31">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="VENDORID" id="VENDORID" size="1" query="ListVendors" value="VENDORID" selected="0" display="VENDORNAME" required="No" tabindex="32"></CFSELECT><BR />
				<CFINPUT type="Text" name="VENDORNAMETEXT" id="VENDORNAMETEXT" value="" required="No" size="25" maxlength="50" tabindex="33">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEVENDORCONTACTID" id="NEGATEVENDORCONTACTID" value=""  required="No" tabindex="34">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="VENDORCONTACTID" id="VENDORCONTACTID" size="1" query="ListVendorContacts" value="VENDORCONTACTID" selected="0" display="KEYFINDER" required="No" tabindex="35"></CFSELECT><BR />
				<CFINPUT type="Text" name="VENDORCONTACTNAMETEXT" id="VENDORCONTACTNAMETEXT" value="" required="No" size="25" maxlength="50" tabindex="36">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH colspan="4"><HR align="left" width="100%" size="5" noshade /></TH>
		</TR>
     </TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
     <LEGEND>Record Selection</LEGEND>
     <TABLE width="100%" border="0">
		<TR>
			<TH align="LEFT" colspan="4"><H2>Clicking the "Match All" Button with no selection equals ALL records for the requested report.</H2></TH>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="37" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" onClick="return setMatchAll();" tabindex="38" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>
     </FIELDSET>
	<BR />
	<TABLE width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="39" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
********************************************************************************************
* The following code is the IDT Purchasing - Requisition Lookup Report Generation Process. *
********************************************************************************************
 --->

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="LookupPurchReqs" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.FISCALYEARID, FY.FISCALYEAR_4DIGIT, PR.REQUESTERID, CUST.FULLNAME, 
				CUST.FULLNAME AS REQUESTERNAME, PR.PURCHREQUNITID, U.UNITNAME, PR.REQNUMBER, PR.PONUMBER, PR.PURCHASEJUSTIFICATION,
				PR.RUSHJUSTIFICATION, PR.VENDORID, V.VENDORNAME, PR.VENDORCONTACTID, VC.CONTACTNAME, PR.SPECSCOMMENTS, PR.RECVCOMMENTS,
				PR.IDTREVIEWERID, REVWR.FULLNAME, TO_CHAR(PR.COMPLETIONDATE, 'MM/DD/YYYY') AS COMPLETIONDATE
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.FISCALYEARS FY, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U, 
				VENDORS V, VENDORCONTACTS VC, LIBSHAREDDATAMGR.CUSTOMERS REVWR
		WHERE	(PR.PURCHREQID > 0 AND
				PR.FISCALYEARID = FY.FISCALYEARID AND
				PR.REQUESTERID = CUST.CUSTOMERID AND
				PR.PURCHREQUNITID = U.UNITID AND
				PR.VENDORID = V.VENDORID AND
				PR.VENDORCONTACTID = VC.VENDORCONTACTID AND
				PR.IDTREVIEWERID = REVWR.CUSTOMERID) AND (

		<CFIF #FORM.SERVICEREQUESTNUMBER# EQ "Select SR" AND #FORM.SRNUMTEXT# NEQ ''>
			<CFIF IsDefined('FORM.NEGATESERVICEREQUESTNUMBER')>
				NOT (PR.SERVICEREQUESTNUMBER LIKE '%#FORM.SRNUMTEXT#%') #LOGICANDOR#
			<CFELSE>
				PR.SERVICEREQUESTNUMBER LIKE '%#FORM.SRNUMTEXT#%' #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.SERVICEREQUESTNUMBER# NEQ "Select SR">
			<CFIF IsDefined('FORM.NEGATESERVICEREQUESTNUMBER')>
				NOT (PR.SERVICEREQUESTNUMBER = '#FORM.SERVICEREQUESTNUMBER#') #LOGICANDOR#
			<CFELSE>
				PR.SERVICEREQUESTNUMBER = '#FORM.SERVICEREQUESTNUMBER#' #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.FISCALYEARID# EQ 0 AND #FORM.FISCALYEARTEXT# NEQ ''>
			<CFIF IsDefined('FORM.NEGATEFISCALYEARID')>
				NOT (FY.FISCALYEAR_4DIGIT LIKE '%#FORM.FISCALYEARTEXT#%') #LOGICANDOR#
			<CFELSE>
				FY.FISCALYEAR_4DIGIT LIKE '%#FORM.FISCALYEARTEXT#%' #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.FISCALYEARID# GT 0>
			<CFIF IsDefined('FORM.NEGATEFISCALYEARID')>
				NOT (PR.FISCALYEARID = #val(FORM.FISCALYEARID)#) #LOGICANDOR#
			<CFELSE>
				PR.FISCALYEARID = #val(FORM.FISCALYEARID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTERID# EQ 0 AND #FORM.REQUESTERNAMETEXT# NEQ ''>
			<CFIF IsDefined('FORM.NEGATEREQUESTERID')>
				NOT (CUST.FULLNAME LIKE UPPER('%#FORM.REQUESTERNAMETEXT#%')) #LOGICANDOR#
			<CFELSE>
				CUST.FULLNAME LIKE UPPER('%#FORM.REQUESTERNAMETEXT#%') #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.REQUESTERID# GT 0>
			<CFIF IsDefined('FORM.NEGATEREQUESTERID')>
				NOT (PR.REQUESTERID = #val(FORM.REQUESTERID)#) #LOGICANDOR#
			<CFELSE>
				PR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.UNITID# EQ 0 AND #FORM.UNITNAMETEXT# NEQ ''>
			<CFIF IsDefined('FORM.NEGATEUNITID')>
				NOT (U.UNITNAME LIKE UPPER('%#FORM.UNITNAMETEXT#%')) #LOGICANDOR#
			<CFELSE>
				U.UNITNAME LIKE UPPER('%#FORM.UNITNAMETEXT#%') #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.UNITID# GT 0>
			<CFIF IsDefined('FORM.NEGATEUNITID')>
				NOT (PR.PURCHREQUNITID = #val(FORM.UNITID)#) #LOGICANDOR#
			<CFELSE>
				PR.PURCHREQUNITID = #val(FORM.UNITID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.REQNUMBER# EQ " REQ NUMBER" AND #FORM.REQNUMBERTEXT# NEQ ''>
			<CFIF IsDefined('FORM.NEGATEREQNUMBER')>
				NOT (PR.REQNUMBER LIKE UPPER('%#FORM.REQNUMBERTEXT#%')) #LOGICANDOR#
			<CFELSE>
				PR.REQNUMBER LIKE UPPER('%#FORM.REQNUMBERTEXT#%') #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.REQNUMBER# NEQ " REQ NUMBER">
			<CFIF IsDefined('FORM.NEGATEREQNUMBER')>
				NOT (PR.REQNUMBER = '#FORM.REQNUMBER#') #LOGICANDOR#
			<CFELSE>
				PR.REQNUMBER = '#FORM.REQNUMBER#' #LOGICANDOR#
			</CFIF>
		</CFIF>
		
			
		<CFIF #FORM.PONUMBER# EQ " PO NUMBER" AND #FORM.PONUMBERTEXT# NEQ ''>
			<CFIF IsDefined('FORM.NEGATEPONUMBER')>
				NOT (PR.PONUMBER LIKE UPPER('%#FORM.PONUMBERTEXT#%')) #LOGICANDOR#
			<CFELSE>
				PR.PONUMBER LIKE UPPER('%#FORM.PONUMBERTEXT#%') #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.PONUMBER# NEQ " PO NUMBER">
			<CFIF IsDefined('FORM.NEGATEPONUMBER')>
				NOT (PR.PONUMBER = '#FORM.PONUMBER#') #LOGICANDOR#
			<CFELSE>
				PR.PONUMBER = '#FORM.PONUMBER#' #LOGICANDOR#
			</CFIF>
		</CFIF>
		

		<CFIF #FORM.PURCHASEJUSTIFICATION# NEQ "">
			<CFIF IsDefined("FORM.NEGATEPURCHJUST")>
				NOT (PR.PURCHASEJUSTIFICATION LIKE UPPER('%#FORM.PURCHASEJUSTIFICATION#%')) #LOGICANDOR#
			<CFELSE>
				PR.PURCHASEJUSTIFICATION LIKE UPPER('%#FORM.PURCHASEJUSTIFICATION#%') #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.RUSHJUSTIFICATION# NEQ "">
			<CFIF IsDefined("FORM.NEGATERUSHJUST")>
				NOT (PR.RUSHJUSTIFICATION LIKE UPPER('%#FORM.RUSHJUSTIFICATION#%')) #LOGICANDOR#
			<CFELSE>
				PR.RUSHJUSTIFICATION LIKE UPPER('%#FORM.RUSHJUSTIFICATION#%') #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.VENDORID# EQ 0 AND #FORM.VENDORNAMETEXT# NEQ ''>
			<CFIF IsDefined('FORM.NEGATEVENDORID')>
				NOT (V.VENDORNAME LIKE UPPER('%#FORM.VENDORNAMETEXT#%')) #LOGICANDOR#
			<CFELSE>
				V.VENDORNAME LIKE UPPER('%#FORM.VENDORNAMETEXT#%') #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.VENDORID# GT 0>
			<CFIF IsDefined('FORM.NEGATEVENDORID')>
				NOT (PR.VENDORID = #val(FORM.VENDORID)#) #LOGICANDOR#
			<CFELSE>
				PR.VENDORID = #val(FORM.VENDORID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.VENDORCONTACTID# EQ 0 AND #FORM.VENDORCONTACTNAMETEXT# NEQ ''>
			<CFIF IsDefined('FORM.NEGATEVENDORCONTACTID')>
				NOT (VC.CONTACTNAME LIKE UPPER('%#FORM.VENDORCONTACTNAMETEXT#%')) #LOGICANDOR#
			<CFELSE>
				VC.CONTACTNAME LIKE UPPER('%#FORM.VENDORCONTACTNAMETEXT#%') #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.VENDORCONTACTID# GT 0>
			<CFIF IsDefined('FORM.NEGATEVENDORCONTACTID')>
				NOT (PR.VENDORCONTACTID = #val(FORM.VENDORCONTACTID)#) #LOGICANDOR#
			<CFELSE>
				PR.VENDORCONTACTID = #val(FORM.VENDORCONTACTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.SPECSCOMMENTS# NEQ "">
			<CFIF IsDefined("FORM.NEGATESPECSCOMM")>
				NOT (PR.SPECSCOMMENTS LIKE UPPER('%#FORM.SPECSCOMMENTS#%')) #LOGICANDOR#
			<CFELSE>
				PR.SPECSCOMMENTS LIKE UPPER('%#FORM.SPECSCOMMENTS#%') #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.RECVCOMMENTS# NEQ "">
			<CFIF IsDefined("FORM.NEGATERECVGCOMM")>
				NOT (PR.RECVCOMMENTS LIKE UPPER('%#FORM.RECVCOMMENTS#%')) #LOGICANDOR#
			<CFELSE>
				PR.RECVCOMMENTS LIKE UPPER('%#FORM.RECVCOMMENTS#%') #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.IDTREVIEWERID# EQ 0 AND #FORM.IDTREVIEWERNAMETEXT# NEQ ''>
			<CFIF IsDefined('FORM.NEGATEIDTREVIEWERID')>
				NOT (REVWR.FULLNAME LIKE UPPER('%#FORM.IDTREVIEWERNAMETEXT#%')) #LOGICANDOR#
			<CFELSE>
				REVWR.FULLNAME LIKE UPPER('%#FORM.IDTREVIEWERNAMETEXT#%') #LOGICANDOR#
			</CFIF>
		<CFELSEIF #FORM.IDTREVIEWERID# GT 0>
			<CFIF IsDefined('FORM.NEGATEIDTREVIEWERID')>
				NOT (PR.IDTREVIEWERID = #val(FORM.IDTREVIEWERID)#) #LOGICANDOR#
			<CFELSE>
				PR.IDTREVIEWERID = #val(FORM.IDTREVIEWERID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

				PR.IDTREVIEWERID #FINALTEST# 0)
		ORDER BY	FY.FISCALYEAR_4DIGIT, PR.SERVICEREQUESTNUMBER, PR.REQNUMBER
	</CFQUERY>

	<CFIF #LookupPurchReqs.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/reqlookupreport.cfm" />
		<CFEXIT>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>IDT Purchasing - Requisition Report</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/reqlookupreport.cfm" method="POST">
			<TD align="left" colspan="4">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="4"><H2>#LookupPurchReqs.RecordCount# Requisition records were selected.</H2></TH>
		</TR>
		<CFSET #COMPAREFY# = "">
	<CFLOOP query="LookupPurchReqs">
		<CFIF #COMPAREFY# NEQ #LookupPurchReqs.FISCALYEAR_4DIGIT#>
			<CFSET #COMPAREFY# = "#LookupPurchReqs.FISCALYEAR_4DIGIT#">
		<TR>
			<TD align="LEFT" colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="left">Fiscal Year: #LookupPurchReqs.FISCALYEAR_4DIGIT#</TH>
		</TR>
		</CFIF>
		<TR>
			<TH align="center">SR ##</TH>
			<TH align="center">Requisition Number</TH>
			<TH align="center">P. O. Number</TH>
			<TH align="center">Completion Date</TH>
		</TR>
		<TR>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.SERVICEREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.REQNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.PONUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.COMPLETIONDATE#</DIV></TD>
			
		</TR>
		<TR>
			<TH align="center">Vendor</TH>
			<TH align="center">Contact</TH>
			<TH align="center">Requester</TH>
			<TH align="center">Requester Unit</TH>
		</TR>
		<TR>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.VENDORNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.CONTACTNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.REQUESTERNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.UNITNAME#</DIV></TD>
		</TR>
		<TR>
			<TH align="center">Specs Comments</TH>
			<TH align="center">Purchase Justification</TH>
			<TH align="center">Rush Justification</TH>
			<TH align="center">Receiving Comments</TH>
		</TR>
		<TR>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.SPECSCOMMENTS#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.PURCHASEJUSTIFICATION#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.RUSHJUSTIFICATION#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqs.RECVCOMMENTS#</DIV></TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><HR> </TD>
		</TR> 
	</CFLOOP>
		<TR>
			<TD align="LEFT" colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="4"><H2>#LookupPurchReqs.RecordCount# Requisition records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/reqlookupreport.cfm" method="POST">
			<TD align="left" colspan="4">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="4">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>