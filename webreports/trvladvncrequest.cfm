<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: trvladvncrequest.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/30/2012 --->
<!--- Date in Production: 07/30/2012 --->
<!--- Module: Web Reports - Travel Advance Request. --->
<!-- Last modified by John R. Pastori on 07/30/2012 using ColdFusion Studio. -->


<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/trvladvncrequest.cfm">
<CFSET CONTENT_UPDATED = "July 30, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Travel Advance Request</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Travel Advance Request</TITLE>
	</CFIF>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

	<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Web Reports - Travel Advance Request";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {

		if (document.TRAVELADVANCEREQUEST.CHECKAMOUNT.value == ""  || document.TRAVELADVANCEREQUEST.CHECKAMOUNT.value == " ") {
			alertuser (document.TRAVELADVANCEREQUEST.CHECKAMOUNT.name +  ", The Desired Check Amount MUST be entered!");
			document.TRAVELADVANCEREQUEST.CHECKAMOUNT.focus();
			return false;
		}

		if (document.TRAVELADVANCEREQUEST.CHECKAMOUNT.value.match(/[$\,]/)) {
			alertuser (document.TRAVELADVANCEREQUEST.CHECKAMOUNT.name +  ",  The check dollar amount CAN NOT contain a dollar sign or commas!");
			document.TRAVELADVANCEREQUEST.CHECKAMOUNT.focus();
			return false;
		}

		if (document.TRAVELADVANCEREQUEST.TRAVELBEGINDATE.value == "" || document.TRAVELADVANCEREQUEST.TRAVELBEGINDATE.value == " "
		 || !document.TRAVELADVANCEREQUEST.TRAVELBEGINDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.TRAVELADVANCEREQUEST.TRAVELBEGINDATE.name +  ",  A Travel Begin Date in the format MM/DD/YYYY MUST be entered!");
			document.TRAVELADVANCEREQUEST.TRAVELBEGINDATE.focus();
			return false;
		}

		if (document.TRAVELADVANCEREQUEST.TRAVELENDDATE != null && !document.TRAVELADVANCEREQUEST.TRAVELENDDATE.value == "" 
		 && !document.TRAVELADVANCEREQUEST.TRAVELENDDATE.value == " " && !document.TRAVELADVANCEREQUEST.TRAVELENDDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.TRAVELADVANCEREQUEST.TRAVELENDDATE.name +  ",  A Travel End Date in the format MM/DD/YYYY MUST be entered!");
			document.TRAVELADVANCEREQUEST.TRAVELENDDATE.focus();
			return false;
		}

		if (document.TRAVELADVANCEREQUEST.DESTINATION.value == null || document.TRAVELADVANCEREQUEST.DESTINATION.value == "") {
			alertuser (document.TRAVELADVANCEREQUEST.DESTINATION.name +  ", A Destination Description MUST be entered!");
			document.TRAVELADVANCEREQUEST.DESTINATION.focus();
			return false;
		}
	}


		function validateLookupField() {
		if (document.LOOKUP.TAREQUESTID.selectedIndex == "0") {
			alertuser ("A Requested Travel Advance MUST be selected!");
			document.LOOKUP.TAREQUESTID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPAYEE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.TAREQUESTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.TRAVELADVANCEREQUEST.CHECKAMOUNT.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
****************************************************************************************
* The following code is used by ALL Processes in Web Reports - Travel Advance Request. *
****************************************************************************************
 --->

<CFQUERY name="ListPayees" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.UNITID, U.GROUPID,
			CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.ALLOWEDTOAPPROVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.CUSTOMERID = 0 AND 
			CUST.UNITID = U.UNITID) OR
			(CUST.UNITID = U.UNITID AND
			U.GROUPID IN (2,3,4,6)) AND 
			(ACTIVE = 'YES' AND
			NOT LASTNAME LIKE '/%' AND
			NOT LASTNAME LIKE 'COMPUTING%' AND
			NOT LASTNAME LIKE 'INVENTORY%' AND
			NOT FIRSTNAME LIKE 'AVAIL%' AND
			NOT FIRSTNAME LIKE 'CHECK%' AND
			NOT FIRSTNAME LIKE 'INFO%' AND
			NOT FIRSTNAME LIKE 'IST%' AND
			NOT FIRSTNAME LIKE 'SCC%' AND
			NOT FIRSTNAME LIKE 'SHARED%' AND
			NOT FIRSTNAME LIKE 'TECH%' AND
			NOT FIRSTNAME LIKE 'WORK%' AND
			NOT EMAIL = 'none' AND
			NOT EMAIL LIKE '@%')
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="LookupPayee" datasource="#application.type#LIBSHAREDDATA">
	SELECT	CUSTOMERID, LASTNAME, FIRSTNAME, INITIALS, CATEGORYID, EMAIL, CAMPUSPHONE, SECONDCAMPUSPHONE, CELLPHONE, FAX, FULLNAME, 
			DIALINGCAPABILITY, LONGDISTAUTHCODE, NUMBERLISTED, UNITID, LOCATIONID, UNITHEAD, DEPTCHAIR, ALLOWEDTOAPPROVE, CONTACTBY, SECURITYLEVELID, 
			PASSWORD, BIBLIOGRAPHER, COMMENTS, AA_COMMENTS, MODIFIEDBYID, MODIFIEDDATE, ACTIVE
	FROM		CUSTOMERS
	WHERE	CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	LASTNAME
</CFQUERY>

<CFQUERY name="LookupPayeeUnit" datasource="#application.type#LIBSHAREDDATA">
	SELECT	UNITS.UNITID, UNITS.UNITNAME, CAMPUSMAILCODES.CAMPUSMAILCODE, GROUPS.GROUPNAME, 
			DEPARTMENTS.DEPARTMENTNAME, UNITS.UNITNAME || ' - ' || GROUPS.GROUPNAME AS UNITGROUP
	FROM		UNITS, CAMPUSMAILCODES, GROUPS, DEPARTMENTS
	WHERE	UNITS.UNITID = <CFQUERYPARAM value="#LookupPayee.UNITID#" cfsqltype="CF_SQL_NUMERIC"> AND
			UNITS.CAMPUSMAILCODEID = CAMPUSMAILCODES.CAMPUSMAILCODEID AND
			UNITS.GROUPID = GROUPS.GROUPID AND
			UNITS.DEPARTMENTID = DEPARTMENTS.DEPARTMENTID
	ORDER BY	UNITS.UNITNAME
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

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
	<TR>
		<TD align="left">
			<CFINCLUDE template="/include/coldfusion/formheader.cfm">
		</TD>
	</TR>
</TABLE>

<CFINCLUDE template="/include/coldfusion/navbar1.cfm">

<!--- <div style='border:none;border-bottom:solid windowtext 1.5pt;padding:0in 0in 0in 0in'>
	<span style='font-family:"Times New Roman";font-size:24.0pt;'><STRONG>SDSU</STRONG></span>
</div>
<span style='font-family:"Times New Roman";font-size:12.0pt;'>
	<STRONG>SAN DIEGO</STRONG>
	<STRONG>STATE</STRONG>
	<STRONG>UNIVERSITY</STRONG></span>
</span> --->

<TABLE width="100%" align="center" border="3">
	<TR>
		<TH align="center">
			<STRONG><H1>Web Reports - Travel Advance Request</H1></STRONG>
		</TH>
	</TR>
</TABLE>

<!--- 
***********************************************************************************
* The following code is the ADD Process for Web Reports - Travel Advance Request. *
***********************************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
		SELECT	MAX(TAREQUESTID) AS MAX_ID
		FROM		TRVLADVNCREQUESTS
	</CFQUERY>

	<CFSET FORM.TAREQUESTID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="TAREQUESTID" secure="NO" value="#FORM.TAREQUESTID#">
	<CFSET FORM.SUBMITDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>

	<CFQUERY name="AddTrvlAdvncRequestID" datasource="#application.type#WEBREPORTS">
		INSERT INTO	TRVLADVNCREQUESTS (TAREQUESTID, SUBMITDATE, PAYEEID, FISCALYEARID)
		VALUES		(#val(Cookie.TAREQUESTID)#, TO_DATE('#FORM.SUBMITDATE# 12:00:00 AM', 'DD-MON-YYYY HH:MI:SS AM'), #val(Client.CUSTOMERID)#, #val(ListCurrentFiscalYear.FISCALYEARID)#)
	</CFQUERY>

	<TABLE align="LEFT" width="100%" border="0">
		<TR>
			<TH align="center" colspan="2">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center" colspan="2">
				Absence Key &nbsp; = &nbsp; #FORM.TAREQUESTID#&nbsp;&nbsp;&nbsp;&nbsp;
				Fiscal Year = #ListCurrentFiscalYear.FISCALYEAR_4DIGIT#
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/webreports/processtrvladvncrequest.cfm" method="POST">
				<INPUT type="submit" name="ProcessTrvlAdvncRequests" value="CANCELADD" tabindex="1" />
				&nbsp;&nbsp;<--- Click this button to delete the blank form and return to the Forms Page.
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="TRAVELADVANCEREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processtrvladvncrequest.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TD align="LEFT">
				<STRONG>To: Accounts Payable</STRONG><BR /><BR /><BR />
			</TD>
			<TD align="LEFT">
				<STRONG>Date: </STRONG>&nbsp;&nbsp;<u>#DateFormat(FORM.SUBMITDATE, "MM/DD/YYYY")#</u><BR /><BR /><BR />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<FONT color="Red">*</FONT><STRONG><LABEL for="CHECKAMOUNT">Please issue a travel advance check in the amount of:</LABEL></STRONG>&nbsp;&nbsp;
				<CFINPUT type="Text" name="CHECKAMOUNT" id="CHECKAMOUNT" value="" align="left" required="No" size="25" tabindex="2"><BR /><BR />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT">
				<INPUT type="hidden" name="PAYEEID" value="#Client.CUSTOMERID#" />
				<STRONG>Payee:</STRONG>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<u>#LookupPayee.LASTNAME#</u>
			</TD>
			<TD align="LEFT">
				<u>#LookupPayee.FIRSTNAME#</u>
			</TD>
		</TR>
		<TR>
			<TH align="LEFT">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<STRONG>Last</STRONG><BR /><BR />
			</TH>
			<TH align="LEFT">
				<STRONG>First/Middle Initial</STRONG><BR /><BR />
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<STRONG>Department:</STRONG>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<u>#LookupPayeeUnit.UNITNAME# - #LookupPayeeUnit.DEPARTMENTNAME#</u><BR /><BR />
			</TD>
			<TD align="LEFT" valign="TOP">
				<STRONG>Campus Phone:</STRONG>
				<u>#LookupPayee.CAMPUSPHONE#</u><BR /><BR />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" nowrap>
				<FONT color="Red">*</FONT><STRONG>Dates of Travel:</STRONG>&nbsp;&nbsp;
				<LABEL for="TRAVELBEGINDATE" class="LABEL_hidden">Travel Dates From</LABEL>
				<CFINPUT type="Text" name="TRAVELBEGINDATE" id="TRAVELBEGINDATE" value="" align="left" required="No" size="25" tabindex="3">&nbsp;&nbsp;TO&nbsp;&nbsp;
				<LABEL for="TRAVELENDDATE" class="LABEL_hidden">Travel Dates To</LABEL>
				<CFINPUT type="Text" name="TRAVELENDDATE" id="TRAVELENDDATE" value="" align="left" required="No" size="25" tabindex="4"><BR />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<COM>(FORMAT: &nbsp;&nbsp;MM/DD/YYYY
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				MM/DD/YYYY)</COM> <BR />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;
				<COM>(At least one date MUST be entered!)</COM><BR /><BR />
			</TD>
			<TD align="LEFT" valign="TOP" nowrap>
				<FONT color="Red">*</FONT><STRONG><LABEL for="DESTINATION">Destination:</LABEL></STRONG>&nbsp;&nbsp;&nbsp;&nbsp;
				<CFINPUT type="Text" name="DESTINATION" id="DESTINATION" value="" align="LEFT" required="No" size="50" tabindex="5"><BR /><BR />
			</TD>
		</TR>
		<TR>
			<TD colspan="2">
				I hereby certify that the above travel advance is
				necessary to defray my anticipated reimbursable expense while traveling on
				business for San Diego State University away from my designated
				headquarters. &nbsp;&nbsp;I understand and agree that this amount may be deducted from any and all funds payable by the
				University to me, including any salary warrant(s) issued to me by the State
				Controller, in the event it is not reimbursed by a Travel Expense Claim within
				90 days of issuance, or upon separation from this agency.<BR /><BR />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<STRONG><LABEL for="PAYEEAGREEMENT">Payee Agreement:</LABEL></STRONG>&nbsp;&nbsp;
				<CFSELECT name="PAYEEAGREEMENT" id="PAYEEAGREEMENT" size="1" tabindex="6">
					<OPTION selected value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">
				&nbsp;&nbsp;
			</TD>
		</TR>
		<TR>
			<TD colspan="2">
				<DIV style='border-top:double windowtext 2.25pt;border-left:none;border-bottom: double windowtext 2.25pt;border-right:none;padding:0in 0in 0in 0in'></DIV>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">
				<EM><STRONG>*Advances for less than $150.00 will not be made.</STRONG></EM>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessTrvlAdvncRequests" value="ADD" tabindex="7" />
				&nbsp;&nbsp;<--- Click this button to submit your request.<BR />
				<INPUT type="reset" value="Clear Form" tabindex="8" />
			</TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT">
<CFFORM action="/#application.type#apps/webreports/processtrvladvncrequest.cfm" method="POST">
				<INPUT type="submit" name="ProcessTrvlAdvncRequests" value="CANCELADD" tabindex="9" />
				&nbsp;&nbsp;<--- Click this button to delete the blank form and return to the Forms Page.
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
****************************************************************************************
* The following code is the Look Up Process to Modify/Delete a Travel Advance Request. *
****************************************************************************************
 --->
	<CFIF NOT IsDefined('URL.LOOKUPPAYEE')>

		<CFQUERY name="LookupTrvlAdvncRequest" datasource="#application.type#WEBREPORTS" blockfactor="100">
			SELECT	TAR.TAREQUESTID, TAR.SUBMITDATE, TAR.PAYEEID, CUST.FULLNAME, TAR.CHECKAMOUNT, TAR.FISCALYEARID, TAR.TRAVELBEGINDATE,
					TAR.TRAVELENDDATE, TAR.DESTINATION, TAR.REVFUNDCHECKNUM, TAR.CHECKISSUEDATE, TAR.REQUESTSTATUSID, TAR.APPROVEDBYSUPID,
					TAR.SUPAPPROVALDATE, CUST.FULLNAME || ' - ' || TAR.DESTINATION || ' - ' || TO_CHAR(TAR.SUBMITDATE, 'MM/DD/YYYY') AS LOOKUPKEY
			FROM		TRVLADVNCREQUESTS TAR, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	TAR.PAYEEID = CUST.CUSTOMERID
			ORDER BY	LOOKUPKEY
		</CFQUERY>
	
		<TABLE width="100%" align="LEFT">
			<TR>
				<TH align="center" colspan="2">
					<H4>*Red fields marked with asterisks are required!</H4>
				</TH>
			</TR>
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/trvladvncrequest.cfm?PROCESS=#URL.PROCESS#&LOOKUPPAYEE=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="TAREQUESTID">*Customer Name/Destination/Submit Date:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="TAREQUESTID" id="TAREQUESTID" size="1" query="LookupTrvlAdvncRequest" value="TAREQUESTID" display="LOOKUPKEY" selected="#Client.CUSTOMERID#" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
***************************************************************************************************
* The following code is the Modify and Delete Processes for Web Reports - Travel Advance Request. *
***************************************************************************************************
 --->

		<CFQUERY name="GetTrvlAdvncRequest" datasource="#application.type#WEBREPORTS">
			SELECT	TAREQUESTID, SUBMITDATE, PAYEEID, CHECKAMOUNT, FISCALYEARID, TO_CHAR(TRAVELBEGINDATE, 'MM/DD/YYYY') AS TRAVELBEGINDATE,
					TO_CHAR(TRAVELENDDATE, 'MM/DD/YYYY') AS TRAVELENDDATE, DESTINATION, REVFUNDCHECKNUM, CHECKISSUEDATE, REQUESTSTATUSID,
					APPROVEDBYSUPID, SUPAPPROVALDATE, PAYEEAGREEMENT
			FROM		TRVLADVNCREQUESTS
			WHERE	TAREQUESTID = <CFQUERYPARAM value="#FORM.TAREQUESTID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PAYEEID
		</CFQUERY>
	
		<CFQUERY name="GetPayees" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FIRSTNAME, INITIALS, CATEGORYID, EMAIL, CAMPUSPHONE, SECONDCAMPUSPHONE, CELLPHONE, FAX, FULLNAME,
					DIALINGCAPABILITY, LONGDISTAUTHCODE, NUMBERLISTED, UNITID, LOCATIONID, UNITHEAD, DEPTCHAIR, ALLOWEDTOAPPROVE, CONTACTBY, SECURITYLEVELID, 
					PASSWORD, BIBLIOGRAPHER, COMMENTS, AA_COMMENTS, MODIFIEDBYID, MODIFIEDDATE, ACTIVE
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#GetTrvlAdvncRequest.PAYEEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>
	
		<CFQUERY name="GetPayeeUnits" datasource="#application.type#LIBSHAREDDATA">
			SELECT	UNITS.UNITID, UNITS.UNITNAME, CAMPUSMAILCODES.CAMPUSMAILCODE, GROUPS.GROUPNAME, 
					DEPARTMENTS.DEPARTMENTNAME, UNITS.UNITNAME || ' - ' || GROUPS.GROUPNAME AS UNITGROUP
			FROM		UNITS, CAMPUSMAILCODES, GROUPS, DEPARTMENTS
			WHERE	UNITS.UNITID = <CFQUERYPARAM value="#GetPayees.UNITID#" cfsqltype="CF_SQL_NUMERIC"> AND
					UNITS.CAMPUSMAILCODEID = CAMPUSMAILCODES.CAMPUSMAILCODEID AND
					UNITS.GROUPID = GROUPS.GROUPID AND
					UNITS.DEPARTMENTID = DEPARTMENTS.DEPARTMENTID
			ORDER BY	UNITS.UNITNAME
		</CFQUERY>
	
		<TABLE align="LEFT" width="100%" border="0">
			<TR>
				<TH align="center" colspan="2">
					<H4>*Red fields marked with asterisks are required!</H4>
				</TH>
			</TR>
			<TR>
				<TH align="center" colspan="2">
					Absence Key &nbsp; = &nbsp; #GetTrvlAdvncRequest.TAREQUESTID#&nbsp;&nbsp;&nbsp;&nbsp;
					Fiscal Year = #ListCurrentFiscalYear.FISCALYEAR_4DIGIT#
					<CFCOOKIE name="TAREQUESTID" secure="NO" value="#GetTrvlAdvncRequest.TAREQUESTID#">
				</TH>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/webreports/trvladvncrequest.cfm?PROCESS=#URL.PROCESS#" method="POST">
					<INPUT type="submit" name="ProcessTrvlAdvncRequests" value="CANCEL" tabindex="1" />
					&nbsp;&nbsp;<--- Click this button to delete the blank form and return to the Forms Page.
</CFFORM>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
<CFFORM name="TRAVELADVANCEREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processtrvladvncrequest.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TD align="LEFT">
					<STRONG>To: Accounts Payable</STRONG><BR /><BR /><BR />
				</TD>
				<TD align="LEFT">
					<STRONG><LABEL for="FISCALYEARID">Fiscal Year/Date:</LABEL></STRONG> &nbsp;&nbsp;
					<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#GetTrvlAdvncRequest.FISCALYEARID#" required="No" tabindex="2"></CFSELECT>
					&nbsp;&nbsp;<u>#DateFormat(GetTrvlAdvncRequest.SUBMITDATE, "MM/DD/YYYY")#</u><BR /><BR /><BR />
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">
					<FONT color="Red">*</FONT><STRONG><LABEL for="CHECKAMOUNT">Please issue a travel advance check in the amount of:</LABEL></STRONG>&nbsp;&nbsp;
					<CFINPUT type="Text" name="CHECKAMOUNT" id="CHECKAMOUNT" value="#NumberFormat(GetTrvlAdvncRequest.CHECKAMOUNT, '________.__')#" align="left" required="No" size="25" tabindex="3">
				</TD>
			</TR>
				<TD align="LEFT">
					<STRONG><LABEL for="PAYEEID">Payee:</LABEL></STRONG>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<CFSELECT name="PAYEEID" id="PAYEEID" size="1" query="ListPayees" value="CUSTOMERID" display="FULLNAME" selected="#GetTrvlAdvncRequest.PAYEEID#" required="No" tabindex="4"></CFSELECT>
				</TD>
			<TR>
				<TD align="LEFT" valign="TOP">
					<STRONG>Department:</STRONG>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<u>#GetPayeeUnits.UNITNAME# - #GetPayeeUnits.DEPARTMENTNAME#</u><BR /><BR />
				</TD>
				<TD align="LEFT" valign="TOP">
					<STRONG>Campus Phone:</STRONG>
					<u>#GetPayees.CAMPUSPHONE#</u><BR /><BR />
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" valign="TOP" nowrap>
					<FONT color="Red">*</FONT><STRONG>Dates of Travel:</STRONG>&nbsp;&nbsp;
					<LABEL for="TRAVELBEGINDATE" class="LABEL_hidden">Travel Dates From</LABEL>
					<CFINPUT type="Text" name="TRAVELBEGINDATE" id="TRAVELBEGINDATE" value="#GetTrvlAdvncRequest.TRAVELBEGINDATE#" align="left" required="No" size="25" tabindex="5">&nbsp;&nbsp;TO&nbsp;&nbsp;
					<LABEL for="TRAVELENDDATE" class="LABEL_hidden">Travel Dates To</LABEL>
					<CFINPUT type="Text" name="TRAVELENDDATE" id="TRAVELENDDATE" value="#GetTrvlAdvncRequest.TRAVELENDDATE#" align="left" required="No" size="25" tabindex="6"><BR />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<COM>(FORMAT: &nbsp;&nbsp;MM/DD/YYYY
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					MM/DD/YYYY)</COM> <BR />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;
					<COM>(At least one date MUST be entered!)</COM><BR /><BR />
				</TD>
				<TD align="LEFT" valign="TOP" nowrap>
					<FONT color="Red">*</FONT><LABEL for="DESTINATION">Destination:</LABEL>&nbsp;&nbsp;&nbsp;&nbsp;
				<CFINPUT type="Text" name="DESTINATION" id="DESTINATION" value="#GetTrvlAdvncRequest.DESTINATION#" align="LEFT" required="No" size="50" tabindex="7"><BR /><BR /><BR />
				</TD>
			</TR>
			<TR>
				<TD colspan="2">
					I hereby certify that the above travel advance is
					necessary to defray my anticipated reimbursable expense while traveling on
					business for San Diego State University away from my designated
					headquarters. &nbsp;&nbsp;I understand and agree that this amount may be deducted from any and all funds payable by the
					University to me, including any salary warrant(s) issued to me by the State
					Controller, in the event it is not reimbursed by a Travel Expense Claim within
					90 days of issuance, or upon separation from this agency.<BR /><BR />
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">
					<STRONG><LABEL for="PAYEEAGREEMENT">Payee Agreement:</LABEL></STRONG>&nbsp;&nbsp;
					<CFSELECT name="PAYEEAGREEMENT" id="PAYEEAGREEMENT" size="1" tabindex="8">
						<OPTION selected value="#GetTrvlAdvncRequest.PAYEEAGREEMENT#">#GetTrvlAdvncRequest.PAYEEAGREEMENT#</OPTION>
						<OPTION value="YES">YES</OPTION>
						<OPTION value="NO">NO</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD colspan="2">
					&nbsp;&nbsp;
				</TD>
			</TR>
			<TR>
				<TD colspan="2">
					<DIV style='border-top:double windowtext 2.25pt;border-left:none;border-bottom: double windowtext 2.25pt;border-right:none;padding:0in 0in 0in 0in'></DIV>
				</TD>
			</TR>
			<TR>
				<TD colspan="2">
					&nbsp;&nbsp;
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">
					<STRONG>For Library Accounting Use Only:</STRONG><BR /><BR />
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">
					<STRONG><LABEL for="REVFUNDCHECKNUM">Revolving Fund Check:</LABEL></STRONG>&nbsp;&nbsp;
					<CFINPUT type="Text" name="REVFUNDCHECKNUM" id="REVFUNDCHECKNUM" value="#GetTrvlAdvncRequest.REVFUNDCHECKNUM#" align="left" required="No" size="25" tabindex="9">
				</TD>
				<TD align="LEFT">
					<STRONG><LABEL for="CHECKISSUEDATE">Date Issued:</LABEL></STRONG>&nbsp;&nbsp;
					<CFINPUT type="Text" name="CHECKISSUEDATE" id="CHECKISSUEDATE" value="#DateFormat(GetTrvlAdvncRequest.CHECKISSUEDATE, "MM/DD/YYYY")#" align="left" required="No" size="25" tabindex="10">
				</TD>
			</TR>
			<TR>
				<TD colspan="2">
					&nbsp;&nbsp;
				</TD>
			</TR>
			<TR>
				<TD colspan="2">
					<DIV style='border-top:double windowtext 2.25pt;border-left:none;border-bottom: double windowtext 2.25pt;border-right:none;padding:0in 0in 0in 0in'></DIV>
				</TD>
			</TR>
			
			<TR>
				<TD colspan="2">
					<EM><STRONG>*Advances for less than $150.00 will not be made.</STRONG></EM>
				</TD>
			</TR>
			<TR>
				<TD colspan="2">
					&nbsp;&nbsp;
				</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessTrvlAdvncRequests" value="MODIFY" tabindex="11" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
				<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
			<TD align="LEFT"><INPUT type="submit" name="ProcessTrvlAdvncRequests" value="DELETE" tabindex="12" /></TD>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/webreports/trvladvncrequest.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessTrvlAdvncRequests" value="Cancel" tabindex="13" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>