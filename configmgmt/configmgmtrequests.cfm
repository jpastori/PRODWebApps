<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: configmgmtrequests.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information in IDT Configuration Management - Requests --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/configmgmt/configmgmtrequests.cfm">
<CFSET CONTENT_UPDATED = "July 24 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information in IDT Configuration Management - Requests</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information in IDT Configuration Management - Requests</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Configuration Management";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {
		if (document.CONFIGMGMTREQUEST.REQUESTDATE.value == "" || document.CONFIGMGMTREQUEST.REQUESTDATE.value == " ") {
			alertuser (document.CONFIGMGMTREQUEST.REQUESTDATE.name +  ", A Request Date MUST be entered!");
			document.CONFIGMGMTREQUEST.REQUESTDATE.focus();
			return false;
		}

		if (!document.CONFIGMGMTREQUEST.REQUESTDATE.value == "" && !document.CONFIGMGMTREQUEST.REQUESTDATE.value == " " 
		 && !document.CONFIGMGMTREQUEST.REQUESTDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.CONFIGMGMTREQUEST.REQUESTDATE.name +  ", The Request Date MUST be entered in the format MM/DD/YYYY!");
			document.CONFIGMGMTREQUEST.REQUESTDATE.focus();
			return false;
		}

		if (document.CONFIGMGMTREQUEST.SYSTEM.value == "" || document.CONFIGMGMTREQUEST.SYSTEM.value == " ") {
			alertuser (document.CONFIGMGMTREQUEST.SYSTEM.name +  ",  A System Name MUST be entered!");
			document.CONFIGMGMTREQUEST.SYSTEM.focus();
			return false;
		}

		if (document.CONFIGMGMTREQUEST.REQUESTERID.selectedIndex == "0") {
			alertuser (document.CONFIGMGMTREQUEST.REQUESTERID.name +  ",  A Requester MUST be selected!");
			document.CONFIGMGMTREQUEST.REQUESTERID.focus();
			return false;
		}

		if (document.CONFIGMGMTREQUEST.CHANGEDESCRIPTION.value == "" || document.CONFIGMGMTREQUEST.CHANGEDESCRIPTION.value == " ") {
			alertuser (document.CONFIGMGMTREQUEST.CHANGEDESCRIPTION.name +  ",  A Change Description MUST be entered!");
			document.CONFIGMGMTREQUEST.CHANGEDESCRIPTION.focus();
			return false;
		}

		if (document.CONFIGMGMTREQUEST.CHANGEJUSTIFICATION.value == "" || document.CONFIGMGMTREQUEST.CHANGEJUSTIFICATION.value == " ") {
			alertuser (document.CONFIGMGMTREQUEST.CHANGEJUSTIFICATION.name +  ",  A Change Justification MUST be entered!");
			document.CONFIGMGMTREQUEST.CHANGEJUSTIFICATION.focus();
			return false;
		}

		if (!document.CONFIGMGMTREQUEST.AUTHORIZATIONDATE.value == "" && !document.CONFIGMGMTREQUEST.AUTHORIZATIONDATE.value == " " 
		 && !document.CONFIGMGMTREQUEST.AUTHORIZATIONDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.CONFIGMGMTREQUEST.AUTHORIZATIONDATE.name +  ", The Authorization Date MUST be entered in the format MM/DD/YYYY!");
			document.CONFIGMGMTREQUEST.AUTHORIZATIONDATE.focus();
			return false;
		}

		if (!document.CONFIGMGMTREQUEST.NOTIFICATIONDATE.value == "" && !document.CONFIGMGMTREQUEST.NOTIFICATIONDATE.value == " " 
		 && !document.CONFIGMGMTREQUEST.NOTIFICATIONDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.CONFIGMGMTREQUEST.NOTIFICATIONDATE.name +  ", The Notification Date MUST be entered in the format MM/DD/YYYY!");
			document.CONFIGMGMTREQUEST.NOTIFICATIONDATE.focus();
			return false;
		}

		if (!document.CONFIGMGMTREQUEST.FOLLOWUPDATE_1ST.value == "" && !document.CONFIGMGMTREQUEST.FOLLOWUPDATE_1ST.value == " " 
		 && !document.CONFIGMGMTREQUEST.FOLLOWUPDATE_1ST.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.CONFIGMGMTREQUEST.FOLLOWUPDATE_1ST.name +  ", The 1st Follow-up Date MUST be entered in the format MM/DD/YYYY!");
			document.CONFIGMGMTREQUEST.FOLLOWUPDATE_1ST.focus();
			return false;
		}

		if (!document.CONFIGMGMTREQUEST.FOLLOWUPDATE_2ND.value == "" && !document.CONFIGMGMTREQUEST.FOLLOWUPDATE_2ND.value == " " 
		 && !document.CONFIGMGMTREQUEST.FOLLOWUPDATE_2ND.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.CONFIGMGMTREQUEST.FOLLOWUPDATE_2ND.name +  ", The 2nd Follow-up Date MUST be entered in the format MM/DD/YYYY!");
			document.CONFIGMGMTREQUEST.FOLLOWUPDATE_2ND.focus();
			return false;
		}

		if (!document.CONFIGMGMTREQUEST.BACKUPDATE.value == "" && !document.CONFIGMGMTREQUEST.BACKUPDATE.value == " " 
		 && !document.CONFIGMGMTREQUEST.BACKUPDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.CONFIGMGMTREQUEST.BACKUPDATE.name +  ", The Backup Date MUST be entered in the format MM/DD/YYYY!");
			document.CONFIGMGMTREQUEST.BACKUPDATE.focus();
			return false;
		}

		if (!document.CONFIGMGMTREQUEST.CHANGEDATE.value == "" && !document.CONFIGMGMTREQUEST.CHANGEDATE.value == " " 
		 && !document.CONFIGMGMTREQUEST.CHANGEDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.CONFIGMGMTREQUEST.CHANGEDATE.name +  ", The Change Date MUST be entered in the format MM/DD/YYYY!");
			document.CONFIGMGMTREQUEST.CHANGEDATE.focus();
			return false;
		}

		if (!document.CONFIGMGMTREQUEST.CHANGETIME.value == "" && !document.CONFIGMGMTREQUEST.CHANGETIME.value == " " 
		 && !document.CONFIGMGMTREQUEST.CHANGETIME.value.match(/^\d{2}\:\d{2}\:\d{2}\s(AM|PM)/)) {
			alertuser (document.CONFIGMGMTREQUEST.CHANGETIME.name +  ", The Change Time MUST be entered in the format HH:MM:SS AM/PM!");
			document.CONFIGMGMTREQUEST.CHANGETIME.focus();
			return false;
		}

		if (!document.CONFIGMGMTREQUEST.AVAILABILITYDATE.value == "" && !document.CONFIGMGMTREQUEST.AVAILABILITYDATE.value == " " 
		 && !document.CONFIGMGMTREQUEST.AVAILABILITYDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.CONFIGMGMTREQUEST.AVAILABILITYDATE.name +  ", The Availability Date MUST be entered in the format MM/DD/YYYY!");
			document.CONFIGMGMTREQUEST.AVAILABILITYDATE.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.LOOKUPCMRID.selectedIndex == "0") {
			alertuser ("A Configuration Management Request MUST be selected!");
			document.LOOKUP.LOOKUPCMRID.focus();
			return false;
		}
	}


	function setDelete() {
		document.CONFIGMGMTREQUEST.PROCESSCMREQUESTS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCMRID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.CMRID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CONFIGMGMTREQUEST.REQUESTDATE.focus()">
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

<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME,
			CUST.CATEGORYID, CUST.UNITID, U.GROUPID, CUST.LOCATIONID, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.CUSTOMERID = 0 AND
			CUST.UNITID = U.UNITID) OR	
			(CUST.UNITID = U.UNITID AND
			U.GROUPID = 4 AND
			CUST.ACTIVE = 'YES')	
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListAuthorizers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.UNITID, U.GROUPID, CUST.CAMPUSPHONE,
			CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.ALLOWEDTOAPPROVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.CUSTOMERID = 0 AND 
			CUST.UNITID = U.UNITID) OR
			(CUST.UNITID = U.UNITID AND
			U.GROUPID = 4 AND
			CUST.ACTIVE = 'YES' AND 
			(CUST.UNITHEAD = 'YES' OR
			CUST.DEPTCHAIR = 'YES') AND
			CUST.ALLOWEDTOAPPROVE = 'YES')
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListNotifiersImplementers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.UNITID, U.GROUPID, CUST.CAMPUSPHONE,
			CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.CUSTOMERID = 0 AND 
			CUST.UNITID = U.UNITID) OR
			(CUST.UNITID = U.UNITID AND
			U.GROUPID = 4 AND
			CUST.ACTIVE = 'YES')
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
			DBS.DBSYSTEMNUMBER = 1300 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<!--- 
********************************************************************************
* The following code is the ADD Process for Configuration Management Requests. *
********************************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#CONFIGMGMT">
		SELECT	MAX(CONFIGMGMTREQUESTID) AS MAX_ID
		FROM		CONFIGMGMTREQUESTS
	</CFQUERY>
	<CFSET FORM.CONFIGMGMTREQUESTID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="CONFIGMGMTREQUESTID" secure="NO" value="#FORM.CONFIGMGMTREQUESTID#">
	<CFQUERY name="GetMaxFYSeqNum" datasource="#application.type#CONFIGMGMT">
		SELECT	FISCALYEARID, SEQUENCENUMBER AS MAX_FYSEQNUM
		FROM		CONFIGMGMTREQUESTS
		WHERE 	CONFIGMGMTREQUESTID = #val(FORM.CONFIGMGMTREQUESTID)# - 1
	</CFQUERY>

	<CFSET FORM.FISCALYEARID = #ListCurrentFiscalYear.FISCALYEARID#>

	<CFIF GetMaxFYSeqNum.FISCALYEARID LT ListCurrentFiscalYear.FISCALYEARID>
		<CFSET FORM.FYSEQNUM = 1>
	<CFELSE>
		<CFSET FORM.FYSEQNUM =  #val(GetMaxFYSeqNum.MAX_FYSEQNUM+1)#>
	</CFIF>
	<CFSET FORM.CHANGENUMBER = #ListCurrentFiscalYear.FISCALYEAR_2DIGIT# & "SYS" & #NumberFormat(FORM.FYSEQNUM,  '0009')#>

	<CFQUERY name="AddConfigMgmtRequestID" datasource="#application.type#CONFIGMGMT">
		INSERT INTO	CONFIGMGMTREQUESTS(CONFIGMGMTREQUESTID, FISCALYEARID, SEQUENCENUMBER, CHANGENUMBER)
		VALUES		(#val(Cookie.CONFIGMGMTREQUESTID)#, #val(FORM.FISCALYEARID)#, #val(FORM.FYSEQNUM)#, '#FORM.CHANGENUMBER#')
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information in IDT Configuration Management - Requests</H1></TD>
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
				Configuration Management Request Key: &nbsp;&nbsp; #FORM.CONFIGMGMTREQUESTID#
			</TH>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/configmgmt/processconfigmgmtrequests.cfm" method="POST">
				<INPUT type="hidden" name="PROCESSCMREQUESTS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="CONFIGMGMTREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/configmgmt/processconfigmgmtrequests.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">CM Change Number</TH>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="REQUESTDATE">*Request Date</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<H2>#FORM.CHANGENUMBER#</H2>
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="REQUESTDATE" id="REQUESTDATE" value="" align="LEFT" required="No" size="10" tabindex="2">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'REQUESTDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="SYSTEM">*System</LABEL></H4></TH>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="REQUESTERID">*Requester</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="SYSTEM" id="SYSTEM" value="" required="No" size="15" maxlength="25" tabindex="3">
			</TD>
			<TD align="left" valign ="TOP">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="CHANGEDESCRIPTION">*Change Description</LABEL></H4></TH>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="CHANGEJUSTIFICATION">*Change Justification</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFTEXTAREA name="CHANGEDESCRIPTION" id="CHANGEDESCRIPTION" wrap="VIRTUAL" rows="5" cols="60" tabindex="5"></CFTEXTAREA><BR />
			</TD>
			<TD align="left" valign ="TOP">
				<CFTEXTAREA name="CHANGEJUSTIFICATION" id="CHANGEJUSTIFICATION" wrap="VIRTUAL" rows="5" cols="60" tabindex="6"></CFTEXTAREA><BR />
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="AUTHORIZERID">Authorizer</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><LABEL for="AUTHORIZATIONDATE">Authorization Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="AUTHORIZERID" id="AUTHORIZERID" size="1" query="ListAuthorizers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="7"></CFSELECT>
			</TD>
			<TD align="left"  valign ="TOP">
				<CFINPUT type="Text" name="AUTHORIZATIONDATE" id="AUTHORIZATIONDATE" value="" align="LEFT" required="No" size="10" tabindex="8">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'AUTHORIZATIONDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="SERVERADMCOMMENTS">Server Adminstrator's Comments</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><LABEL for="CHANGESCHEDULED">Change Scheduled?</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFTEXTAREA name="SERVERADMCOMMENTS" id="SERVERADMCOMMENTS" wrap="VIRTUAL" rows="5" cols="60" tabindex="9"></CFTEXTAREA><BR />
			</TD>
			<TD align="left" valign ="TOP">
				<CFSELECT name="CHANGESCHEDULED" id="CHANGESCHEDULED" size="1" tabindex="10">
					<OPTION value=" Make a Selection"> Make a Selection</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM" colspan="2"><LABEL for="NOTIFICATIONDESCRIPTION_1ST">Notification Description</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFTEXTAREA name="NOTIFICATIONDESCRIPTION" id="NOTIFICATIONDESCRIPTION" wrap="VIRTUAL" rows="5" cols="60" tabindex="11"></CFTEXTAREA><BR />
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="NOTIFIERID">Notifier</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><LABEL for="NOTIFICATIONDATE">Notification Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="NOTIFIERID" id="NOTIFIERID" size="1" query="ListNotifiersImplementers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="12"></CFSELECT>
			</TD>
			<TD align="left"  valign ="TOP">
				<CFINPUT type="Text" name="NOTIFICATIONDATE" id="NOTIFICATIONDATE" value="" align="LEFT" required="No" size="10" tabindex="13">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'NOTIFICATIONDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM" colspan="2"><LABEL for="FOLLOWUPDESCRIPTION_1ST">1st Follow-up Description</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFTEXTAREA name="FOLLOWUPDESCRIPTION_1ST" id="FOLLOWUPDESCRIPTION_1ST" wrap="VIRTUAL" rows="5" cols="60" tabindex="14"></CFTEXTAREA><BR />
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="FOLLOWUPNOTIFIERID_1ST">1st Follow-up Notifier</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><LABEL for="FOLLOWUPDATE_1ST">1st Follow-up Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="FOLLOWUPNOTIFIERID_1ST" id="FOLLOWUPNOTIFIERID_1ST" size="1" query="ListNotifiersImplementers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="15"></CFSELECT>
			</TD>
			<TD align="left"  valign ="TOP">
				<CFINPUT type="Text" name="FOLLOWUPDATE_1ST" id="FOLLOWUPDATE_1ST" value="" align="LEFT" required="No" size="10" tabindex="16">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'FOLLOWUPDATE_1ST'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM" colspan="2"><LABEL for="FOLLOWUPDESCRIPTION_2ND">2nd Follow-up Description</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFTEXTAREA name="FOLLOWUPDESCRIPTION_2ND" id="FOLLOWUPDESCRIPTION_2ND" wrap="VIRTUAL" rows="5" cols="60" tabindex="17"></CFTEXTAREA><BR />
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="FOLLOWUPNOTIFIERID_2ND">2nd Follow-up Notifier</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><LABEL for="FOLLOWUPDATE_2ND">2nd Follow-up Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="FOLLOWUPNOTIFIERID_2ND" id="FOLLOWUPNOTIFIERID_2ND" size="1" query="ListNotifiersImplementers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="18"></CFSELECT>
			</TD>
			<TD align="left"  valign ="TOP">
				<CFINPUT type="Text" name="FOLLOWUPDATE_2ND" id="FOLLOWUPDATE_2ND" value="" align="LEFT" required="No" size="10" tabindex="19">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'FOLLOWUPDATE_2ND'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="BACKUPDATE">Backup Date</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><LABEL for="IMPLEMENTERID">Implementer</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="BACKUPDATE" id="BACKUPDATE" value="" align="LEFT" required="No" size="10" tabindex="20">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'BACKUPDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
			<TD align="left" valign ="TOP">
				<CFSELECT name="IMPLEMENTERID" id="IMPLEMENTERID" size="1" query="ListNotifiersImplementers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="21"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="CHANGEDATE">Change Date</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><LABEL for="CHANGETIME">Change Time</LABEL></TH>
		</TR>
		<TR>
			<TD align="left"  valign ="TOP">
				<CFINPUT type="Text" name="CHANGEDATE" id="CHANGEDATE" value="" align="LEFT" required="No" size="10" tabindex="22">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'CHANGEDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="CHANGETIME" id="CHANGETIME" value="" align="LEFT" required="No" size="10" tabindex="23"><BR>
				<COM>HH:MM:SS AM/PM </COM>
			</TD>
		</TR><TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="IMPLEMENTATIONDESCRIPTION">Implementation Description</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><LABEL for="TESTINGMONITORDESCRIPTION">Testing/Monitor Description</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFTEXTAREA name="IMPLEMENTATIONDESCRIPTION" id="IMPLEMENTATIONDESCRIPTION" wrap="VIRTUAL" rows="5" cols="60" tabindex="24"></CFTEXTAREA><BR />
			</TD>
			<TD align="left" valign ="TOP">
				<CFTEXTAREA name="TESTINGMONITORDESCRIPTION" id="TESTINGMONITORDESCRIPTION" wrap="VIRTUAL" rows="5" cols="60" tabindex="25"></CFTEXTAREA>
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="CHANGESTATUS">Change Status</LABEL></TH>
			<TH align="left" valign ="BOTTOM" colspan="2"><LABEL for="AVAILABILITYDESCRIPTION">Availability Description</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="CHANGESTATUS" id="CHANGESTATUS" size="1" tabindex="26">
					<OPTION value=" Make a Selection"> Make a Selection</OPTION>
					<OPTION value="GOOD">GOOD</OPTION>
					<OPTION value="BAD">BAD</OPTION>
					<OPTION value="ROLLBACK NEEDED">ROLLBACK NEEDED</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" colspan="2">
				<CFTEXTAREA name="AVAILABILITYDESCRIPTION" id="AVAILABILITYDESCRIPTION" wrap="VIRTUAL" rows="5" cols="60" tabindex="27"></CFTEXTAREA><BR />
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="AVAILABILITYNOTIFIERID">Availability Notifier</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><LABEL for="AVAILABILITYDATE">Availability Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="AVAILABILITYNOTIFIERID" id="AVAILABILITYNOTIFIERID" size="1" query="ListNotifiersImplementers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="28"></CFSELECT>
			</TD>
			<TD align="left"  valign ="TOP">
				<CFINPUT type="Text" name="AVAILABILITYDATE" id="AVAILABILITYDATE" value="" align="LEFT" required="No" size="10" tabindex="29">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'AVAILABILITYDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
			<TH align="left">Modified Date</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="30"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<INPUT type="hidden" name="PROCESSCMREQUESTS" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="31" />
               </TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/configmgmt/processconfigmgmtrequests.cfm" method="POST">
				<INPUT type="hidden" name="PROCESSCMREQUESTS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="32" /><BR />
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

<CFELSE>

<!--- 
***********************************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Configuration Management Requests. *
***********************************************************************************************************
 --->

	<CFQUERY name="LookupCMRequests" datasource="#application.type#CONFIGMGMT">
		SELECT	CMR.CONFIGMGMTREQUESTID, CMR.CHANGENUMBER, CMR.SYSTEM, CMR.REQUESTERID, REQCUST.FULLNAME, CMR.REQUESTDATE,
				CMR.CHANGENUMBER || ' - ' || CMR.SYSTEM || ' - ' || REQCUST.FULLNAME || ' - ' || CMR.REQUESTDATE AS KEYFINDER
		FROM		CONFIGMGMTREQUESTS CMR, LIBSHAREDDATAMGR.CUSTOMERS REQCUST
		WHERE	CMR.REQUESTERID = REQCUST.CUSTOMERID
		ORDER BY	KEYFINDER
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPCMRID')>
			<TD align="center"><H1>Modify/Delete Lookup Information in IDT Configuration Management - Requests</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information in IDT Configuration Management - Requests</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>* RED fields marked with asterisks are required!</H4></TH>
		</TR>
	</TABLE>

	<CFIF NOT IsDefined('URL.LOOKUPCMRID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
               <TR>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/configmgmt/configmgmtrequests.cfm?PROCESS=#URL.PROCESS#&LOOKUPCMRID=FOUND" method="POST">
			<TR>
				<TH align="LEFT"><H4>*Select by Change Number - System Name - Customer - Request Date:</H4></TH>
			</TR>
			<TR>
				<TD align="LEFT">
					<CFSELECT name="LOOKUPCMRID" size="1" query="LookupCMRequests" value="CONFIGMGMTREQUESTID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
               <TR>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
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
************************************************************************************************
* The following code is the Modify and Delete Processes for Configuration Management Requests. *
************************************************************************************************
 --->

		<CFQUERY name="GetCMRequests" datasource="#application.type#CONFIGMGMT">
			SELECT	CMR.CONFIGMGMTREQUESTID, CMR.CHANGENUMBER, CMR.SYSTEM , CMR.REQUESTERID, REQCUST.CUSTOMERID, REQCUST.FULLNAME,
					CMR.REQUESTDATE, CMR.CHANGEDESCRIPTION, CMR.CHANGEJUSTIFICATION, CMR.AUTHORIZERID, CMR.AUTHORIZATIONDATE, CMR.SERVERADMCOMMENTS,
					CMR.CHANGESCHEDULED, CMR.NOTIFICATIONDESCRIPTION, CMR.NOTIFIERID, CMR.NOTIFICATIONDATE, CMR.FOLLOWUPDESCRIPTION_1ST,
					CMR.FOLLOWUPNOTIFIERID_1ST, CMR.FOLLOWUPDATE_1ST, CMR.FOLLOWUPDESCRIPTION_2ND, CMR.FOLLOWUPNOTIFIERID_2ND, CMR.FOLLOWUPDATE_2ND,
					CMR.BACKUPDATE, CMR.IMPLEMENTERID, CMR.CHANGEDATE, CMR.CHANGETIME, CMR.IMPLEMENTATIONDESCRIPTION, CMR.TESTINGMONITORDESCRIPTION,
					CMR.CHANGESTATUS, CMR.AVAILABILITYDESCRIPTION, CMR.AVAILABILITYNOTIFIERID, CMR.AVAILABILITYDATE, CMR.MODIFIEDBYID, CMR.MODIFIEDDATE,
					CMR.CHANGENUMBER || ' - ' || CMR.SYSTEM || ' - ' || REQCUST.FULLNAME || ' - ' || CMR.REQUESTDATE AS KEYFINDER
			FROM		CONFIGMGMTREQUESTS CMR, LIBSHAREDDATAMGR.CUSTOMERS REQCUST
			WHERE	CMR.CONFIGMGMTREQUESTID = <CFQUERYPARAM value="#FORM.LOOKUPCMRID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CMR.REQUESTERID = REQCUST.CUSTOMERID
			ORDER BY	KEYFINDER
		</CFQUERY>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center" colspan="2">
					Configuration Management Request Key: &nbsp;&nbsp; #GetCMRequests.CONFIGMGMTREQUESTID#
				</TH>
			</TR>
		</TABLE>

		<TABLE width="100%" border="0">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/configmgmt/configmgmtrequests.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
<CFFORM name="CONFIGMGMTREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/configmgmt/processconfigmgmtrequests.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left">CM Change Number</TH>
				<TH align="left" valign ="BOTTOM"><H4><LABEL for="REQUESTDATE">*Request Date</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFCOOKIE name="CONFIGMGMTREQUESTID" secure="NO" value="#FORM.LOOKUPCMRID#">
					<H2>#GetCMRequests.CHANGENUMBER#</H2>
				</TD>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="REQUESTDATE" id="REQUESTDATE" value="#DateFormat(GetCMRequests.REQUESTDATE, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="2">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'REQUESTDATE'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><H4><LABEL for="SYSTEM">*System</LABEL></H4></TH>
				<TH align="left" valign ="BOTTOM"><H4><LABEL for="REQUESTERID">*Requester</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="SYSTEM" id="SYSTEM" value="#GetCMRequests.SYSTEM#" required="No" size="15" maxlength="25" tabindex="2">
				</TD>
				<TD align="left" valign ="TOP">
					<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="#GetCMRequests.REQUESTERID#" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><H4><LABEL for="CHANGEDESCRIPTION">*Change Description</LABEL></H4></TH>
				<TH align="left" valign ="BOTTOM"><H4><LABEL for="CHANGEJUSTIFICATION">*Change Justification</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFTEXTAREA name="CHANGEDESCRIPTION" id="CHANGEDESCRIPTION" wrap="VIRTUAL" rows="5" cols="60" tabindex="4">#GetCMRequests.CHANGEDESCRIPTION#</CFTEXTAREA><BR />
				</TD>
				<TD align="left" valign ="TOP">
					<CFTEXTAREA name="CHANGEJUSTIFICATION" id="CHANGEJUSTIFICATION" wrap="VIRTUAL" rows="5" cols="60" tabindex="5">#GetCMRequests.CHANGEJUSTIFICATION#</CFTEXTAREA><BR />
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="AUTHORIZERID">Authorizer</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="AUTHORIZATIONDATE">Authorization Date</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="AUTHORIZERID" id="AUTHORIZERID" size="1" query="ListAuthorizers" value="CUSTOMERID" display="FULLNAME" selected="#GetCMRequests.AUTHORIZERID#" required="No" tabindex="6"></CFSELECT>
				</TD>
			<TD align="left"  valign ="TOP">
					<CFINPUT type="Text" name="AUTHORIZATIONDATE" id="AUTHORIZATIONDATE" value="#DateFormat(GetCMRequests.AUTHORIZATIONDATE, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="7">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'AUTHORIZATIONDATE'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="SERVERADMCOMMENTS">Server Adminstrator's Comments</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="CHANGESCHEDULED">Change Scheduled?</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFTEXTAREA name="SERVERADMCOMMENTS" id="SERVERADMCOMMENTS" wrap="VIRTUAL" rows="5" cols="60" tabindex="8">#GetCMRequests.SERVERADMCOMMENTS#</CFTEXTAREA><BR />
				</TD>
				<TD align="left" valign ="TOP">
					<CFSELECT name="CHANGESCHEDULED" id="CHANGESCHEDULED" size="1" tabindex="9">
						<OPTION selected value="#GetCMRequests.CHANGESCHEDULED#">#GetCMRequests.CHANGESCHEDULED#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM" colspan="2"><LABEL for="NOTIFICATIONDESCRIPTION">Notification Description</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFTEXTAREA name="NOTIFICATIONDESCRIPTION" id="NOTIFICATIONDESCRIPTION" wrap="VIRTUAL" rows="5" cols="60" tabindex="10">#GetCMRequests.NOTIFICATIONDESCRIPTION#</CFTEXTAREA><BR />
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="NOTIFIERID">Notifier</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="NOTIFICATIONDATE">Notification Date</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="NOTIFIERID" id="NOTIFIERID" size="1" query="ListNotifiersImplementers" value="CUSTOMERID" display="FULLNAME" selected="#GetCMRequests.NOTIFIERID#" required="No" tabindex="11"></CFSELECT>
				</TD>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="NOTIFICATIONDATE" id="NOTIFICATIONDATE" value="#DateFormat(GetCMRequests.NOTIFICATIONDATE, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="12">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'NOTIFICATIONDATE'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM" colspan="2"><LABEL for="FOLLOWUPDESCRIPTION_1ST">1st Follow-up Description</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFTEXTAREA name="FOLLOWUPDESCRIPTION_1ST" id="FOLLOWUPDESCRIPTION_1ST" wrap="VIRTUAL" rows="5" cols="60" tabindex="13">#GetCMRequests.FOLLOWUPDESCRIPTION_1ST#</CFTEXTAREA><BR />
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="FOLLOWUPNOTIFIERID_1ST">1st Follow-up Notifier</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="FOLLOWUPDATE_1ST">1st Follow-up Date</LABEL></TH>
			</TR>
			<TR>
			<TD align="left" valign ="TOP">
					<CFSELECT name="FOLLOWUPNOTIFIERID_1ST" id="FOLLOWUPNOTIFIERID_1ST" size="1" query="ListNotifiersImplementers" value="CUSTOMERID" display="FULLNAME" selected="#GetCMRequests.FOLLOWUPNOTIFIERID_1ST#" required="No" tabindex="14"></CFSELECT>
				</TD>
				<TD align="left"  valign ="TOP">
					<CFINPUT type="Text" name="FOLLOWUPDATE_1ST" id="FOLLOWUPDATE_1ST" value="#DateFormat(GetCMRequests.FOLLOWUPDATE_1ST, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="15">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'FOLLOWUPDATE_1ST'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM" colspan="2"><LABEL for="FOLLOWUPDESCRIPTION_2ND">2nd Follow-up Description</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFTEXTAREA name="FOLLOWUPDESCRIPTION_2ND" id="FOLLOWUPDESCRIPTION_2ND" wrap="VIRTUAL" rows="5" cols="60" tabindex="13">#GetCMRequests.FOLLOWUPDESCRIPTION_2ND#</CFTEXTAREA><BR />
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="FOLLOWUPNOTIFIERID_2ND">2nd Follow-up Notifier</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="FOLLOWUPDATE_2ND">2nd Follow-up Date</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="FOLLOWUPNOTIFIERID_2ND" id="FOLLOWUPNOTIFIERID_2ND" size="1" query="ListNotifiersImplementers" value="CUSTOMERID" display="FULLNAME" selected="#GetCMRequests.FOLLOWUPNOTIFIERID_2ND#" required="No" tabindex="14"></CFSELECT>
				</TD>
				<TD align="left"  valign ="TOP">
					<CFINPUT type="Text" name="FOLLOWUPDATE_2ND" id="FOLLOWUPDATE_2ND" value="#DateFormat(GetCMRequests.FOLLOWUPDATE_2ND, 'MM/DD/YYYY') #" align="LEFT" required="No" size="10" tabindex="15">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'FOLLOWUPDATE_2ND'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="BACKUPDATE">Backup Date</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="IMPLEMENTERID">Implementer</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="BACKUPDATE" id="BACKUPDATE" value="#DateFormat(GetCMRequests.BACKUPDATE, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="16">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'BACKUPDATE'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
				<TD align="left" valign ="TOP">
					<CFSELECT name="IMPLEMENTERID" id="IMPLEMENTERID" size="1" query="ListNotifiersImplementers" value="CUSTOMERID" display="FULLNAME" selected="#GetCMRequests.IMPLEMENTERID#" required="No" tabindex="17"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="CHANGEDATE">Change Date</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="CHANGETIME">Change Time</LABEL></TH>
			</TR>
			<TR>
				<TD align="left"  valign ="TOP">
					<CFINPUT type="Text" name="CHANGEDATE" id="CHANGEDATE" value="#DateFormat(GetCMRequests.CHANGEDATE, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="18">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'CHANGEDATE'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="CHANGETIME" id="CHANGETIME" value="#TimeFormat(GetCMRequests.CHANGETIME, 'HH:MM:SS TT')#" align="LEFT" required="No" size="10" tabindex="19"><BR>
					<COM>HH:MM:SS AM/PM </COM>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="IMPLEMENTATIONDESCRIPTION">Implementation Description</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="TESTINGMONITORDESCRIPTION">Testing/Monitor Description</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFTEXTAREA name="IMPLEMENTATIONDESCRIPTION" id="IMPLEMENTATIONDESCRIPTION" wrap="VIRTUAL" rows="5" cols="60" tabindex="20">#GetCMRequests.IMPLEMENTATIONDESCRIPTION#</CFTEXTAREA><BR />
				</TD>
				<TD align="left" valign ="TOP">
					<CFTEXTAREA name="TESTINGMONITORDESCRIPTION" id="TESTINGMONITORDESCRIPTION" wrap="VIRTUAL" rows="5" cols="60" tabindex="21">#GetCMRequests.TESTINGMONITORDESCRIPTION#</CFTEXTAREA>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="CHANGESTATUS">Change Status</LABEL></TH>
				<TH align="left" valign ="BOTTOM" colspan="2"><LABEL for="AVAILABILITYDESCRIPTION">Availability Description</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="CHANGESTATUS" id="CHANGESTATUS" size="1" tabindex="22">
						<OPTION selected value="#GetCMRequests.CHANGESTATUS#">#GetCMRequests.CHANGESTATUS#</OPTION>
						<OPTION value=" Select Status"> Select Status</OPTION>
						<OPTION value="GOOD">GOOD</OPTION>
						<OPTION value="BAD">BAD</OPTION>
						<OPTION value="ROLLBACK NEEDED">ROLLBACK NEEDED</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left" colspan="2">
					<CFTEXTAREA name="AVAILABILITYDESCRIPTION" id="AVAILABILITYDESCRIPTION" wrap="VIRTUAL" rows="5" cols="60" tabindex="23">#GetCMRequests.AVAILABILITYDESCRIPTION#</CFTEXTAREA><BR />
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="AVAILABILITYNOTIFIERID">Availability Notifier</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="AVAILABILITYDATE">Availability Date</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="AVAILABILITYNOTIFIERID" id="AVAILABILITYNOTIFIERID" size="1" query="ListNotifiersImplementers" value="CUSTOMERID" display="FULLNAME" selected="#GetCMRequests.AVAILABILITYNOTIFIERID#" required="No" tabindex="24"></CFSELECT>
				</TD>
				<TD align="left"  valign ="TOP">
					<CFINPUT type="Text" name="AVAILABILITYDATE" id="AVAILABILITYDATE" value="#DateFormat(GetCMRequests.AVAILABILITYDATE, 'MM/DD/YYYY')#" align="LEFT" required="No" size="10" tabindex="25">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'CONFIGMGMTREQUEST','controlname': 'AVAILABILITYDATE'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
				<TH align="left">Modified Date</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#GetCMRequests.MODIFIEDBYID#" tabindex="49"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
               <TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSCMREQUESTS" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="26" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="27" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/configmgmt/configmgmtrequests.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="28" /><BR />
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