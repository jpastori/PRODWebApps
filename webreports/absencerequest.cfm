<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: absencerequest.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Absence Request Form --->
<!-- Last modified by John R. Pastori on 08/28/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/webreports/absencerequest.cfm">
<cfset CONTENT_UPDATED = "March 28, 2016">

<cfoutput>

<cfif (FIND('lfolkswiki', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "LFOLKSWIKI")>
	<cfset SESSION.ORIGINSERVER = "LFOLKSWIKI">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelseif (FIND('#application.type#apps/forms', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "FORMS")>
	<cfset SESSION.ORIGINSERVER = "FORMS">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelse>
	<cfinclude template = "../programsecuritycheck.cfm">
	<cfset SESSION.ORIGINSERVER = "">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
</cfif>


<html>
<head>
	<cfif IsDefined('URL.PROCESS') AND URL.PROCESS EQ 'ADD'>
		<title>Add Information to Web Reports - Absence Request</title>
	<cfelse>
		<title>Modify/Delete Information to Web Reports - Absence Request</title>
	</cfif>
	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Scripts start here ---->
<script language=JavaScript1.1>
	window.defaultStatus = "Welcome to Web Reports - Absense Request";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}

	function CalcHours1() {
		if (document.ABSENCEREQUESTS.ENDDATE1.value == "" || document.ABSENCEREQUESTS.ENDDATE1.value == document.ABSENCEREQUESTS.BEGINDATE1.value) {
			document.ABSENCEREQUESTS.HOURS1.value = 8;
			return document.ABSENCEREQUESTS.HOURS1.value;
		}
		else {
			enddate = Date.parse(document.ABSENCEREQUESTS.ENDDATE1.value);
			begindate = Date.parse(document.ABSENCEREQUESTS.BEGINDATE1.value);
			difference = enddate - begindate;
			document.ABSENCEREQUESTS.HOURS1.value = Math.floor(difference / (1000 * 60 * 60 *24)) * 8 + 8;
			if (document.ABSENCEREQUESTS.HOURS1.value > 40) {
				alertuser ("A maximum of 40 hours per line is allowed.  Please reset your End Date Field");
				document.ABSENCEREQUESTS.ENDDATE1.focus();
			return false;
			}
			return document.ABSENCEREQUESTS.HOURS1.value;
		}
	}

	function CalcHours2() {
		if (document.ABSENCEREQUESTS.ENDDATE2.value == "" || document.ABSENCEREQUESTS.ENDDATE2.value == document.ABSENCEREQUESTS.BEGINDATE2.value) {
			document.ABSENCEREQUESTS.HOURS2.value = 8;
			return document.ABSENCEREQUESTS.HOURS2.value;
		}
		else {
			enddate = Date.parse(document.ABSENCEREQUESTS.ENDDATE2.value);
			begindate = Date.parse(document.ABSENCEREQUESTS.BEGINDATE2.value);
			difference = enddate - begindate;
			document.ABSENCEREQUESTS.HOURS2.value = Math.floor(difference / (1000 * 60 * 60 *24)) * 8 + 8;
			if (document.ABSENCEREQUESTS.HOURS2.value > 40) {
				alertuser ("A maximum of 40 hours per line is allowed.  Please reset your End Date Field");
				document.ABSENCEREQUESTS.ENDDATE2.focus();
			return false;
			}
			return document.ABSENCEREQUESTS.HOURS2.value;
		}
	}

	function CalcHours3() {
		if (document.ABSENCEREQUESTS.ENDDATE3.value == "" || document.ABSENCEREQUESTS.ENDDATE3.value == document.ABSENCEREQUESTS.BEGINDATE3.value) {
			document.ABSENCEREQUESTS.HOURS3.value = 8;
			return document.ABSENCEREQUESTS.HOURS3.value;
		}
		else {
			enddate = Date.parse(document.ABSENCEREQUESTS.ENDDATE3.value);
			begindate = Date.parse(document.ABSENCEREQUESTS.BEGINDATE3.value);
			difference = enddate - begindate;
			document.ABSENCEREQUESTS.HOURS3.value = Math.floor(difference / (1000 * 60 * 60 *24)) * 8 + 8;
			if (document.ABSENCEREQUESTS.HOURS3.value > 40) {
				alertuser ("A maximum of 40 hours per line is allowed.  Please reset your End Date Field");
				document.ABSENCEREQUESTS.ENDDATE3.focus();
			return false;
			}
			return document.ABSENCEREQUESTS.HOURS3.value;
		}
	}

	function CalcHours4() {
		if (document.ABSENCEREQUESTS.ENDDATE4.value == "" || document.ABSENCEREQUESTS.ENDDATE4.value == document.ABSENCEREQUESTS.BEGINDATE4.value) {
			document.ABSENCEREQUESTS.HOURS4.value = 8;
			return document.ABSENCEREQUESTS.HOURS4.value;
		}
		else {
			enddate = Date.parse(document.ABSENCEREQUESTS.ENDDATE4.value);
			begindate = Date.parse(document.ABSENCEREQUESTS.BEGINDATE4.value);
			difference = enddate - begindate;
			document.ABSENCEREQUESTS.HOURS4.value = Math.floor(difference / (1000 * 60 * 60 *24)) * 8 + 8;
			if (document.ABSENCEREQUESTS.HOURS4.value > 40) {
				alertuser ("A maximum of 40 hours per line is allowed.  Please reset your End Date Field");
				document.ABSENCEREQUESTS.ENDDATE4.focus();
			return false;
			}
			return document.ABSENCEREQUESTS.HOURS4.value;
		}
	}

	function validateText(varName, textData)	{
		if (textData == null  || textData == "") {
			alertuser (varName +  ",  Field can not be BLANK");
			if (varName == "REQUESTEREMAIL") {
				document.ABSENCEREQUESTS.REQUESTEREMAIL.focus();
			}
			if (varName == "CC2") {
				document.ABSENCEREQUESTS.CC2.focus();
			}					
			if (varName == "CC") {
				document.ABSENCEREQUESTS.CC.focus();
			}				
			if (varName == "BEGINDATE1") {
				document.ABSENCEREQUESTS.BEGINDATE1.focus();
			}
			if (varName == "HOURS1") {
				document.ABSENCEREQUESTS.HOURS1.focus();
			}
			return false;	
		}
		else {
			return true;
		} 
	}

	function validateReqInfo() {
		if (document.ABSENCEREQUESTS.REQUESTERID.selectedIndex == "0") {
			alertuser ("A Customer Name MUST be selected!");
			document.ABSENCEREQUESTS.REQUESTERID.focus();
			return false;
		}

		var emailedit = '';
		if (!validateText(document.ABSENCEREQUESTS.REQUESTEREMAIL.name, document.ABSENCEREQUESTS.REQUESTEREMAIL.value)) {
			return false;
		}
		
		emailedit = document.ABSENCEREQUESTS.REQUESTEREMAIL.value; 
		if (emailedit.substr(0,1) == '@') {
			alertuser ("Please insert your E-Mail adress before the AT sign '@' address.");
			document.ABSENCEREQUESTS.REQUESTEREMAIL.focus();
			return false;
		}
		else {
			document.ABSENCEREQUESTS.REQUESTEREMAIL.value = emailedit.toLowerCase();
		}
		
		if (!validateText(document.ABSENCEREQUESTS.BEGINDATE1.name, document.ABSENCEREQUESTS.BEGINDATE1.value)) {
			return false;
		}
		
		if (document.ABSENCEREQUESTS.BEGINDATE1.value == "" || document.ABSENCEREQUESTS.BEGINDATE1.value == " "
		 || !document.ABSENCEREQUESTS.BEGINDATE1.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.ABSENCEREQUESTS.BEGINDATE1.name +  ",  A Date in the format MM/DD/YYYY MUST be entered!");
			document.ABSENCEREQUESTS.BEGINDATE1.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.ENDDATE1.value == "" && !document.ABSENCEREQUESTS.ENDDATE1.value == " "
		 && !document.ABSENCEREQUESTS.ENDDATE1.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.ABSENCEREQUESTS.ENDDATE1.name +  ",  A Date in the format MM/DD/YYYY MUST be entered!");
			document.ABSENCEREQUESTS.ENDDATE1.focus();
			return false;
		}
		if (!document.ABSENCEREQUESTS.BEGINDATE2.value == "" && !document.ABSENCEREQUESTS.BEGINDATE2.value == " "
		 && !document.ABSENCEREQUESTS.BEGINDATE2.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.ABSENCEREQUESTS.BEGINDATE2.name +  ",  A Date in the format MM/DD/YYYY MUST be entered!");
			document.ABSENCEREQUESTS.BEGINDATE2.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.ENDDATE2.value == "" && !document.ABSENCEREQUESTS.ENDDATE2.value == " "
		 && !document.ABSENCEREQUESTS.ENDDATE2.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.ABSENCEREQUESTS.ENDDATE2.name +  ",  A Date in the format MM/DD/YYYY MUST be entered!");
			document.ABSENCEREQUESTS.ENDDATE2.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.BEGINDATE3.value == "" && !document.ABSENCEREQUESTS.BEGINDATE3.value == " "
		 && !document.ABSENCEREQUESTS.BEGINDATE3.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.ABSENCEREQUESTS.BEGINDATE3.name +  ",  A Date in the format MM/DD/YYYY MUST be entered!");
			document.ABSENCEREQUESTS.BEGINDATE3.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.ENDDATE3.value == "" && !document.ABSENCEREQUESTS.ENDDATE3.value == " "
		 && !document.ABSENCEREQUESTS.ENDDATE3.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.ABSENCEREQUESTS.ENDDATE3.name +  ",  A Date in the format MM/DD/YYYY MUST be entered!");
			document.ABSENCEREQUESTS.ENDDATE3.focus();
			return false;
		}
		if (!document.ABSENCEREQUESTS.BEGINDATE4.value == "" && !document.ABSENCEREQUESTS.BEGINDATE4.value == " "
		 && !document.ABSENCEREQUESTS.BEGINDATE4.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.ABSENCEREQUESTS.BEGINDATE4.name +  ",  A Date in the format MM/DD/YYYY MUST be entered!");
			document.ABSENCEREQUESTS.BEGINDATE4.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.ENDDATE4.value == "" && !document.ABSENCEREQUESTS.ENDDATE4.value == " "
		 && !document.ABSENCEREQUESTS.ENDDATE4.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.ABSENCEREQUESTS.ENDDATE4.name +  ",  A Date in the format MM/DD/YYYY MUST be entered!");
			document.ABSENCEREQUESTS.ENDDATE4.focus();
			return false;
		}
		
		if (!validateText(document.ABSENCEREQUESTS.HOURS1.name, document.ABSENCEREQUESTS.HOURS1.value)) {
			return false;
		}
		if (!document.ABSENCEREQUESTS.BEGINTIME1.value == "" && !document.ABSENCEREQUESTS.BEGINTIME1.value == " "
		 && !document.ABSENCEREQUESTS.BEGINTIME1.value.match(/^\d{2}\:\d{2}/)) {
			alertuser (document.ABSENCEREQUESTS.BEGINTIME1.name +  ",  A TIME in the Military Time format HH:MM MUST be entered!");
			document.ABSENCEREQUESTS.BEGINTIME1.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.ENDTIME1.value == "" && !document.ABSENCEREQUESTS.ENDTIME1.value == " "
		 && !document.ABSENCEREQUESTS.ENDTIME1.value.match(/^\d{2}\:\d{2}/)) {
			alertuser (document.ABSENCEREQUESTS.ENDTIME1.name +  ",  A TIME in the Military Time format HH:MM MUST be entered!");
			document.ABSENCEREQUESTS.ENDTIME1.focus();
			return false;
		}
		if (!document.ABSENCEREQUESTS.BEGINTIME2.value == "" && !document.ABSENCEREQUESTS.BEGINTIME2.value == " "
		 && !document.ABSENCEREQUESTS.BEGINTIME2.value.match(/^\d{2}\:\d{2}/)) {
			alertuser (document.ABSENCEREQUESTS.BEGINTIME2.name +  ",  A TIME in the Military Time format HH:MM MUST be entered!");
			document.ABSENCEREQUESTS.BEGINTIME2.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.ENDTIME2.value == "" && !document.ABSENCEREQUESTS.ENDTIME2.value == " "
		 && !document.ABSENCEREQUESTS.ENDTIME2.value.match(/^\d{2}\:\d{2}/)) {
			alertuser (document.ABSENCEREQUESTS.ENDTIME2.name +  ",  A TIME in the Military Time format HH:MM MUST be entered!");
			document.ABSENCEREQUESTS.ENDTIME2.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.BEGINTIME3.value == "" && !document.ABSENCEREQUESTS.BEGINTIME3.value == " "
		 && !document.ABSENCEREQUESTS.BEGINTIME3.value.match(/^\d{2}\:\d{2}/)) {
			alertuser (document.ABSENCEREQUESTS.BEGINTIME3.name +  ",  A TIME in the Military Time format HH:MM MUST be entered!");
			document.ABSENCEREQUESTS.BEGINTIME3.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.ENDTIME3.value == "" && !document.ABSENCEREQUESTS.ENDTIME3.value == " "
		 && !document.ABSENCEREQUESTS.ENDTIME3.value.match(/^\d{2}\:\d{2}/)) {
			alertuser (document.ABSENCEREQUESTS.ENDTIME3.name +  ",  A TIME in the Military Time format HH:MM MUST be entered!");
			document.ABSENCEREQUESTS.ENDTIME3.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.BEGINTIME4.value == "" && !document.ABSENCEREQUESTS.BEGINTIME4.value == " "
		 && !document.ABSENCEREQUESTS.BEGINTIME4.value.match(/^\d{2}\:\d{2}/)) {
			alertuser (document.ABSENCEREQUESTS.BEGINTIME4.name +  ",  A TIME in the Military Time format HH:MM MUST be entered!");
			document.ABSENCEREQUESTS.BEGINTIME4.focus();
			return false;
		}
		
		if (!document.ABSENCEREQUESTS.ENDTIME4.value == "" && !document.ABSENCEREQUESTS.ENDTIME4.value == " "
		 && !document.ABSENCEREQUESTS.ENDTIME4.value.match(/^\d{2}\:\d{2}/)) {
			alertuser (document.ABSENCEREQUESTS.ENDTIME4.name +  ",  A TIME in the Military Time format HH:MM MUST be entered!");
			document.ABSENCEREQUESTS.ENDTIME4.focus();
			return false;
		}
		
		if (document.ABSENCEREQUESTS.DAYS1ID.selectedIndex == "0") {
			alertuser ("A Day of the Week or Range of Days MUST be selected!");
			document.ABSENCEREQUESTS.DAYS1ID.focus();
			return false;
		}

		if ((document.ABSENCEREQUESTS.VACATION.value == null  || document.ABSENCEREQUESTS.VACATION.value == "") 
		 && (document.ABSENCEREQUESTS.PERSONALHOLIDAY.value == null  || document.ABSENCEREQUESTS.PERSONALHOLIDAY.value == "") 
		 && (document.ABSENCEREQUESTS.COMPTIME.value == null  || document.ABSENCEREQUESTS.COMPTIME.value == "") 
		 && (document.ABSENCEREQUESTS.FMLA.value == null  || document.ABSENCEREQUESTS.FMLA.value == "")
		 && (document.ABSENCEREQUESTS.FUNERAL.value == null  || document.ABSENCEREQUESTS.FUNERAL.value == "") 
		 && (document.ABSENCEREQUESTS.OTHER.value == null  || document.ABSENCEREQUESTS.OTHER.value == "") 
		 && (document.ABSENCEREQUESTS.GTO.value == null  || document.ABSENCEREQUESTS.GTO.value == "") 
		 && (document.ABSENCEREQUESTS.JURYDUTY.value == null  || document.ABSENCEREQUESTS.JURYDUTY.value == "") 
		 && (document.ABSENCEREQUESTS.LWOP.value == null  || document.ABSENCEREQUESTS.LWOP.value == "") 
		 && (document.ABSENCEREQUESTS.MATPAT.value == null  || document.ABSENCEREQUESTS.MATPAT.value == "") 
		 && (document.ABSENCEREQUESTS.MILITARY.value == null  || document.ABSENCEREQUESTS.MILITARY.value == "") 
		 && (document.ABSENCEREQUESTS.SICKFAMILY.value == null  || document.ABSENCEREQUESTS.SICKFAMILY.value == "") 
		 && (document.ABSENCEREQUESTS.SICKSELF.value == null  || document.ABSENCEREQUESTS.SICKSELF.value == "") 
		 && (document.ABSENCEREQUESTS.WITNESS.value == null  || document.ABSENCEREQUESTS.WITNESS.value == "")) {
			alertuser ('At least one of the "REQUEST USE OF"  fields must be filled in.');
			document.ABSENCEREQUESTS.VACATION.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.ABSENCEID.selectedIndex == "0") {
			alertuser ("A Requested Absence MUST be selected!");
			document.LOOKUP.ABSENCEID.focus();
			return false;
		}
	}


	function setDelete() {
		document.ABSENCEREQUESTS.PROCESSABSENCEREQUESTS.value = "DELETE";
		return true;
	}


//	
</script>
<script language="JavaScript" src="../calendar_us.js"></script>
<!--Script ends here -->

</head>

<a name="top"></a>

<cfif NOT IsDefined('URL.LOOKUPABSENCEREQUESTS') AND #URL.PROCESS# EQ "MODIFYDELETE">
	<cfset CURSORFIELD = "document.LOOKUP.ABSENCEID.focus()">
<cfelse>
	<cfset CURSORFIELD = "document.ABSENCEREQUESTS.REQUESTERID.focus()">
</cfif>
<body onLoad="#CURSORFIELD#">

<cfif NOT IsDefined('URL.PROCESS')>
	<cfset URL.PROCESS = "ADD">
</cfif>

<!--- 
*********************************************************************************
* The following code is used by ALL Processes in Web Reports - Absence Request. *
*********************************************************************************
 --->

<cfquery name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.FULLNAME || '-' || CUST.EMAIL AS SUPEMAIL, CUST.UNITID, U.GROUPID,
			CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.ALLOWEDTOAPPROVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.CUSTOMERID = 0 AND 
			CUST.UNITID = U.UNITID) OR
			(CUST.UNITID = U.UNITID AND
			U.GROUPID IN (2,3,4,6)) AND 
			(CUST.ACTIVE = 'YES' AND
			NOT CUST.LASTNAME LIKE '/%' AND
			NOT CUST.LASTNAME LIKE 'COMPUTING%' AND
			NOT CUST.LASTNAME LIKE 'INVENTORY%' AND
			NOT CUST.FIRSTNAME LIKE 'AVAIL%' AND
			NOT CUST.FIRSTNAME LIKE 'CHECK%' AND
			NOT CUST.FIRSTNAME LIKE 'INFO%' AND
			NOT CUST.FIRSTNAME LIKE 'IST%' AND
			NOT CUST.FIRSTNAME LIKE 'SCC%' AND
			NOT CUST.FIRSTNAME LIKE 'SHARED%' AND
			NOT CUST.FIRSTNAME LIKE 'TECH%' AND
			NOT CUST.FIRSTNAME LIKE 'WORK%' AND
			NOT CUST.EMAIL = 'none' AND
			NOT CUST.EMAIL LIKE '@%')
	ORDER BY	CUST.FULLNAME
</cfquery>


<cfif #SESSION.ORIGINSERVER# EQ "LFOLKSWIKI">

	<cfquery name="GetCustomer" datasource="#application.type#LIBSHAREDDATA">
          SELECT	CUST.CUSTOMERID, CUST.EMAIL AS REQEMAIL, CUST.FULLNAME, CUST.ACTIVE, CUST.UNITID, U.SUPERVISORID,
                    SUP.EMAIL AS SUPVREMAIL
          FROM		CUSTOMERS CUST, UNITS U, CUSTOMERS SUP
          WHERE	CUST.ACTIVE = 'YES' AND
                    CUST.UNITID = U.UNITID AND
                    U.SUPERVISORID = SUP.CUSTOMERID
          ORDER BY	CUST.FULLNAME
     </cfquery>

<cfelse>

     <cfquery name="GetCustomer" datasource="#application.type#LIBSHAREDDATA">
          SELECT	CUST.CUSTOMERID, CUST.EMAIL AS REQEMAIL, CUST.FULLNAME, CUST.ACTIVE, CUST.UNITID, U.SUPERVISORID,
                    SUP.EMAIL AS SUPVREMAIL
          FROM		CUSTOMERS CUST, UNITS U, CUSTOMERS SUP
          WHERE	CUST.ACTIVE = 'YES' AND
                    CUST.CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    CUST.UNITID = U.UNITID AND
                    U.SUPERVISORID = SUP.CUSTOMERID
          ORDER BY	CUST.FULLNAME
     </cfquery>
     
</cfif>

<cfquery name="ListSupervisors" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, EMAIL, FULLNAME, UNITHEAD, DEPTCHAIR, ACTIVE
	FROM		CUSTOMERS
	WHERE	ACTIVE = 'YES' AND
			(UNITHEAD = 'YES' OR
			DEPTCHAIR = 'YES')
	ORDER BY	EMAIL
</cfquery>

<cfquery name="ListCCEmail" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	DISTINCT EMAIL
	FROM		CUSTOMERS
	WHERE	(CUSTOMERID = 0) OR 
			(ACTIVE = 'YES' AND
			NOT EMAIL = 'none' AND
			NOT EMAIL LIKE '@%')
	ORDER BY	EMAIL
</cfquery>

<cfquery name="ListDaysOfWeek" datasource="#application.type#LIBSHAREDDATA" blockfactor="24">
	SELECT	DAYSOFWEEKID, DAYSOFWEEKNAME
	FROM		DAYSOFWEEK
	ORDER BY	DAYSOFWEEKID
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="left">
			<cfinclude template="/include/coldfusion/formheader.cfm">
		</td>
		<td align="right">
			<big><i>Go to the </i><strong><a href="http://library.sdsu.edu"><font color="RED"> Library's Web Site</font></a></strong></big>
		</td>
	</tr>
</table>

<!--- 
****************************************************************************
* The following code is the ADD Process for Web Reports - Absence Request. *
****************************************************************************
 --->

<cfif URL.PROCESS EQ 'ADD'>
	<cfquery name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
		SELECT	MAX(ABSENCEID) AS MAX_ID
		FROM		ABSENCEREQUESTS
	</cfquery>

	<cfset FORM.ABSENCEID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<cfcookie name="ABSENCEID" secure="NO" value="#FORM.ABSENCEID#">
	<cfset FORM.SUBMITDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>

	<cfquery name="AddAbsenceRequestsID" datasource="#application.type#WEBREPORTS">
		INSERT INTO	ABSENCEREQUESTS (ABSENCEID, SUBMITDATE)
		VALUES		(#val(Cookie.ABSENCEID)#, TO_DATE('#FORM.SUBMITDATE# 12:00:00 AM', 'DD-MON-YYYY HH:MI:SS AM'))
	</cfquery>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<th align="center"><h1>Add Information to Web Reports - Absence Request</h1></th>
		</tr>
	</table>

	<table border="0" align="center" width="100%">
		<tr>
			<th align="center" colspan="2">
				<h4>*Red fields marked with asterisks are required!</h4>
			</th>
		</tr>
		<tr>
			<th align="center" colspan="2">
				Absence Key &nbsp; = &nbsp; #FORM.ABSENCEID#
				&nbsp;&nbsp;&nbsp;&nbsp;Date Submitted: #DateFormat(FORM.SUBMITDATE, "MM/DD/YYYY")#
			</th>
		</tr>
		<tr>
			<td align="LEFT">&nbsp;&nbsp;</td>
			<td align="LEFT">&nbsp;&nbsp;</td>
		</tr>
	</table>
	<table border="0" width="40%">
		<tr>
			<td align="LEFT" valign="top">
<cfform action="/#application.type#apps/webreports/processabsencerequest.cfm" method="POST">
				<input type="hidden" name="PROCESSABSENCEREQUESTS" value="CANCELADD" />
				<input type="image" valign="top" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" />
</cfform>
			</td>
               <td align="left" valign="top">
               	<com><--- Click this button to delete the blank form and return to the Forms Page.</com>
               </td>
		</tr>
          <tr>
               <td align="left">&nbsp;&nbsp;</td>
          </tr>
	</table>

<cfform name="ABSENCEREQUESTS" method="POST" onsubmit="return validateReqInfo();" action="/#application.type#apps/webreports/processabsencerequest.cfm">

	<fieldset>
	<legend>Customer Info</legend>
	<table border="0" width="100%">
		<tr>
			<th align="LEFT"><h4><b><label for="REQUESTERID">*Customer's Name:</label></b></h4>&nbsp;</th>
			<td align="LEFT">
               <cfif #SESSION.ORIGINSERVER# EQ "LFOLKSWIKI">
               	<cfselect name="REQUESTERID" id="REQUESTERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="2"></cfselect>
               <cfelse>
				<cfselect name="REQUESTERID" id="REQUESTERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" required="No" tabindex="2"></cfselect>
               </cfif>
			</td>
		</tr>

		<tr>
			<th align="LEFT"><h4><b><label for="REQUESTEREMAIL">*Email Address:</label></b></h4>&nbsp;</th>
			<td align="LEFT">
               <cfif #SESSION.ORIGINSERVER# EQ "LFOLKSWIKI">
               	<cfinput name="REQUESTEREMAIL" id="REQUESTEREMAIL" value="" size="25" tabindex="3">
               <cfelse>
               	<cfinput name="REQUESTEREMAIL" id="REQUESTEREMAIL" value="#GetCustomer.REQEMAIL#" size="25" tabindex="3">
               </cfif>
               </td>
		</tr>

		<tr>
			<th align="LEFT"><h4><b><label for="SUPERVISOREMAILID">*Supervisor's Email:</label></b></h4>&nbsp;</th>
			<td align="LEFT">
               <cfif #SESSION.ORIGINSERVER# EQ "LFOLKSWIKI">
               	<cfselect name="SUPERVISOREMAILID" id="SUPERVISOREMAILID" query="ListSupervisors" value="CUSTOMERID" display="EMAIL" selected="0" tabindex="4"></cfselect>
               <cfelse>
				<cfselect name="SUPERVISOREMAILID" id="SUPERVISOREMAILID" query="ListSupervisors" value="CUSTOMERID" display="EMAIL" selected="#GetCustomer.SUPERVISORID#" tabindex="4"></cfselect>
               </cfif>
			</td>
		</tr>
		<tr>
			<th align="LEFT"><b><label for="CC2">Carbon Copy:</label></b></th>
			<td align="LEFT">
				<cfselect name="CC2" id="CC2" query="ListCCEmail" value="EMAIL" display="EMAIL" selected="" tabindex="5"></cfselect>
			</td>
		</tr>
          <tr>
			<th align="LEFT"><b><label for="CC2">Additional Carbon Copy:</label></b></th>
			<td align="LEFT">
               <cfif #GetCustomer.UNITID# EQ 39>
				<cfinput name="ADDITIONALCC" id="ADDITIONALCC" value="idtout@library.sdsu.edu" size="100" maxlength="200" tabindex="6">
               <cfelse>
				<cfinput name="ADDITIONALCC" id="ADDITIONALCC" value="" size="100" maxlength="200" tabindex="6">
               </cfif>
			</td>
		</tr>
	</table>

	<cfinput type="checkbox" name="CARBON" id="CARBON" value="YES" checked tabindex="7"><label for="CARBON"><com>A Check will Carbon Copy Requester</com></label><br />
	</fieldset>
	<br />
	<fieldset>
	<legend>Request Detail</legend>
	<table border="0" width="100%">
		<tr>
			<th align="CENTER" valign="BOTTOM">
				<strong><label for="BEGINDATE1">Enter a Single Date or <br />
				a <h4>*Begin Date</h4></LABEL> - <label for="ENDDATE1">End Date Range</label></strong><br />
				<COM><strong>(Date Format must be XX/XX/XXXX)</strong></COM>
			</th>
			<th align="CENTER" valign="BOTTOM">
				<label for="HOURS1"><h4>*## Hours</h4> - Double click box<br />
				<COM><strong>(Maximum 40 Hours per line)</strong></COM></LABEL>
			</th>
			<th align="CENTER" valign="BOTTOM">
				<label for="BEGINTIME1">Enter a Begin Time </label>- <label for="ENDTIME1">End Time Range </label><br />
				<strong>ONLY</strong> if you are using <br /> less than 8 hours of time.<br />
				<COM><strong>(Time Format must be in Military time Hours & Minutes - 0:00-23:59)</strong></COM>
			</th>
			<th align="CENTER" valign="BOTTOM">
				<b><label for="DAYS1"><h4>*Day of Week</h4> <br />
				From - To</LABEL></b> <br />
				<com>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</com>
			</th>
		</tr>

		<tr>
			<td align="CENTER" valign="top">
				<cfinput name="BEGINDATE1" id="BEGINDATE1" size="10" maxlength="15" value="" tabindex="8">
				<script language="JavaScript">
					new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE1'});

				</script>
				&nbsp;&nbsp;

				<cfinput name="ENDDATE1" id="ENDDATE1" size="10" maxlength="15" value="" tabindex="9">
				<script language="JavaScript">
					new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE1'});

				</script>
			</td>
			<td align="CENTER" valign="top"><cfinput name="HOURS1" id="HOURS1" size="2" maxlength="5" value="" onClick="return(CalcHours1());" tabindex="10"></td>
			<td align="CENTER" valign="top">
				<cfinput name="BEGINTIME1" id="BEGINTIME1" size="10" maxlength="15" value="" tabindex="11">&nbsp;&nbsp;
				<cfinput name="ENDTIME1" id="ENDTIME1" size="10" maxlength="15" value="" tabindex="12">
			</td>               
			<td align="LEFT" valign="top">
				<cfselect name="DAYS1ID" id="DAYS1" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="0" required="No" tabindex="13"></cfselect>
			</td>
		</tr>

		<tr>
			<td align="CENTER" valign="top">
				<label for="2nd_BEGINDATE" class="LABEL_hidden">Begin Date 2</label>
				<cfinput name="BEGINDATE2" id="2nd_BEGINDATE" size="10" maxlength="15" value="" tabindex="14">
				<script language="JavaScript">
					new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE2'});

				</script>
				&nbsp;&nbsp;
				<label for="ENDDATE2" class="LABEL_hidden">End Date 2</label>
				<cfinput name="ENDDATE2" id="ENDDATE2" size="10" maxlength="15" value="" tabindex="15">
				<script language="JavaScript">
					new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE2'});

				</script>
			</td>
			<td align="CENTER" valign="top">
				<label for="HOURS2" class="LABEL_hidden">## Hours 2</label>
				<cfinput name="HOURS2" id="HOURS2" size="2" maxlength="5" value="" onClick="return(CalcHours2());" tabindex="16">
			</td>
			<td align="CENTER" valign="top">
				<label for="BEGINTIME2" class="LABEL_hidden">Begin Time 2</label>
				<cfinput name="BEGINTIME2" id="BEGINTIME2" size="10" maxlength="15" value="" tabindex="17">&nbsp;&nbsp;
				<label for="ENDTIME2" class="LABEL_hidden">End Time 2</label>
				<cfinput name="ENDTIME2" id="ENDTIME2" size="10" maxlength="15" value="" tabindex="18">
			</td>
			<td align="LEFT" valign="top">
				<label for="DAYS2" class="LABEL_hidden">Day of Week 2</label>
				<cfselect name="DAYS2ID" id="DAYS2" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="0" required="No" tabindex="19"></cfselect>
			</td>
		</tr>

		<tr>
			<td align="CENTER" valign="top">
				<label for="BEGINDATE3" class="LABEL_hidden">Begin Date 3</label>
				<cfinput name="BEGINDATE3" id="BEGINDATE3" size="10" maxlength="15" value="" tabindex="20">
				<script language="JavaScript">
					new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE3'});

				</script>
				&nbsp;&nbsp;
				<label for="ENDDATE3" class="LABEL_hidden">End Date 3</label>
				<cfinput name="ENDDATE3" id="ENDDATE3" size="10" maxlength="15" value="" tabindex="21">
				<script language="JavaScript">
					new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE3'});

				</script>
			</td>
			<td align="CENTER" valign="top">
				<label for="HOURS3" class="LABEL_hidden">## Hours 3</label>
				<cfinput name="HOURS3" id="HOURS3" size="2" maxlength="5" value="" onClick="return(CalcHours3());" tabindex="22">
			</td>
			<td align="CENTER" valign="top">
				<label for="BEGINTIME3" class="LABEL_hidden">Begin Time 3</label>
				<cfinput name="BEGINTIME3" id="BEGINTIME3" size="10" maxlength="15" value="" tabindex="23">&nbsp;&nbsp;
				<label for="ENDTIME3" class="LABEL_hidden">End Time 1</label>
				<cfinput name="ENDTIME3" id="ENDTIME3" size="10" maxlength="15" value="" tabindex="24">
			</td>
			<td align="LEFT" valign="top">
				<label for="DAYS3" class="LABEL_hidden">Day of Week 3</label>
				<cfselect name="DAYS3ID" id="DAYS3" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="0" required="No" tabindex="25"></cfselect>
			</td>
		</tr>

		<tr>
			<td align="CENTER" valign="top">
				<label for="BEGINDATE4" class="LABEL_hidden">Begin Date 4</label>
				<cfinput name="BEGINDATE4" id="BEGINDATE4" size="10" maxlength="15" value="" tabindex="26">
				<script language="JavaScript">
					new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE4'});

				</script>
				&nbsp;&nbsp;
				<label for="ENDDATE4" class="LABEL_hidden">End Date 4</label>
				<cfinput name="ENDDATE4" id="ENDDATE4" size="10" maxlength="15" value="" tabindex="27">
				<script language="JavaScript">
					new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE4'});

				</script>
			</td>
			<td align="CENTER" valign="top">
				<label for="HOURS4" class="LABEL_hidden">## Hours 4</label>
				<cfinput name="HOURS4" id="HOURS4" size="2" maxlength="5" value="" onClick="return(CalcHours4());" tabindex="28"></td>
			<td align="CENTER" valign="top">
				<label for="BEGINTIME4" class="LABEL_hidden">Begin Time 4</label>
				<cfinput name="BEGINTIME4" id="BEGINTIME4" size="10" maxlength="15" value="" tabindex="29">&nbsp;&nbsp;
				<label for="ENDTIME4" class="LABEL_hidden">End Time 4</label>
				<cfinput name="ENDTIME4" id="ENDTIME4" size="10" maxlength="15" value="" tabindex="30">
			</td>
			<td align="LEFT" valign="top">
				<label for="DAYS4" class="LABEL_hidden">Day of Week 4</label>
				<cfselect name="DAYS4ID" id="DAYS4" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="0" required="No" tabindex="31"></cfselect>
			</td>
		</tr>
	</table>
	</fieldset>
	<br />
	<fieldset>
	<legend>Request Use Of Hours for Absence Type</legend>
	<table border="0" width="100%">
		<tr>
			<td align="LEFT" valign="BOTTOM" colspan="4" >
				<br /><com>Fill in number of hours: - (<h4> *At least one box must be filled in</h4>)</com>
			</td>
		</tr>
		<tr>
			<th align="LEFT"><label for="VACATION">Vacation</label></th>
			<td align="LEFT"><cfinput name="VACATION" id="VACATION" size="5" maxlength="5" value="" tabindex="32"></td>
			<th align="LEFT"><label for="PERSONALHOLIDAY">Personal Holiday</label></th>
			<td align="LEFT"><cfinput name="PERSONALHOLIDAY" id="PERSONALHOLIDAY" size="5" maxlength="5" value="" tabindex="33"></td>
			
		</tr>

		<tr>
			<td align="LEFT">&nbsp;&nbsp;</td>
			<td align="LEFT">&nbsp;&nbsp;</td>
			<td align="LEFT">&nbsp;&nbsp;</td>
			<td align="LEFT">&nbsp;&nbsp;</td>
		</tr>

		<tr>
			<th align="LEFT"><label for="COMPTIME">Compensatory Time Off</label></th>
			<td align="LEFT"><cfinput name="COMPTIME" id="COMPTIME" size="5" maxlength="5" value="" tabindex="34"></td>
			<th align="LEFT"><label for="FMLA">Family Medical Leave Act</label></th>
			<td align="LEFT"><cfinput name="FMLA" id="FMLA" size="5" maxlength="5" value="" tabindex="35"></td>
		</tr>

		<tr>
			<th align="LEFT"><label for="FUNERAL">Funeral Leave*</label></th>
			<td align="LEFT"><cfinput name="FUNERAL" id="FUNERAL" size="5" maxlength="5" value="" tabindex="36"></td>
			<th align="LEFT"><label for="OTHER">Other</label></th>
			<td align="LEFT"><cfinput name="OTHER" id="OTHER" size="5" maxlength="5" value="" tabindex="37"></td>
		</tr>

		<tr>
			<th align="LEFT"><label for="GTO">Holiday Informal Time - GTO</label></th>
			<td align="LEFT"><cfinput name="GTO" id="GTO" size="5" maxlength="5" value="" tabindex="38"></td>
			<th align="LEFT"><label for="JURYDUTY">Jury Duty</label></th>
			<td align="LEFT"><cfinput name="JURYDUTY" id="JURYDUTY" size="5" maxlength="5" value="" tabindex="39"></td>
			
		</tr>

		<tr>
			<th align="LEFT"><h4><label for="LWOP">LWOP</label></h4></th>
			<td align="LEFT"><cfinput name="LWOP" id="LWOP" size="5" maxlength="5" value="" tabindex="40"></td>
			<th align="LEFT"><label for="MATPAT">Maternity/Paternity Leave</label></th>
			<td align="LEFT"><cfinput name="MATPAT" id="MATPAT" size="5" maxlength="5" value="" tabindex="41"></td>
		</tr>

		<tr>
			<th align="LEFT"><label for="MILITARY">Military Leave</label></th>
			<td align="LEFT"><cfinput name="MILITARY" id="MILITARY" size="5" maxlength="5" value="" tabindex="42"></td>
			<th align="LEFT"><label for="SICKFAMILY">Sick Leave Family*</label></th>
			<td align="LEFT"><cfinput name="SICKFAMILY" id="SICKFAMILY" size="5" maxlength="5" value="" tabindex="43"></td>
		</tr>

		<tr>
			<th align="LEFT"><label for="SICKSELF">Sick Leave Self</label></th>
			<td align="LEFT"><cfinput name="SICKSELF" id="SICKSELF" size="5" maxlength="5" value="" tabindex="44"></td>
			<th align="LEFT"><label for="WITNESS">Subpoena Witness</label></th>
			<td align="LEFT"><cfinput name="WITNESS" id="WITNESS" size="5" maxlength="5" value="" tabindex="45"></td>
		</tr>
	</table>
	</fieldset>
	<br />
	<fieldset>
	<legend>Explanations</legend>
	<table border="0" width="100%">
		<tr>
			<td align="LEFT" colspan="4">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th align="LEFT">
				<label for="RELATIONSHIP">*Give Relationship</label>
			</th>
			<th align="LEFT">&nbsp;&nbsp;</th>
			<th align="LEFT">&nbsp;&nbsp;</th>
			<th align="CENTER">
				<label for="REASON">REASON FOR ABSENCE (Sick Leave / <h4>LWOP</h4>):</LABEL>
			</th>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput name="RELATIONSHIP" id="RELATIONSHIP" size="15" maxlength=25 value="" tabindex="46">
			</td>
			<td align="LEFT">&nbsp;&nbsp;</td>
			<td align="LEFT">&nbsp;&nbsp;</td>
			<td align="CENTER">
				<textarea name="REASON" id="REASON" wrap=HARD rows="3" cols="50" tabindex="47"> </textarea>
			</td>
		</tr>
	</table>
	</fieldset>
	<table border="0" width="40%">
		<tr>
			<td align="LEFT">&nbsp;&nbsp;</td>
               <td align="LEFT">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="top">
				<input type="hidden" name="PROCESSABSENCEREQUESTS" value="ADD" />
                    <input type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="48" />
			</td>
               <td align="LEFT" valign="top">
               	<com><--- Clicking this button submits your request to your supervisor via email.</com>
			</td>
		</tr>
          <tr>
			<td align="LEFT" valign="top">
				<input type="image" src="/images/buttonClearForm.jpg" value="Clear Form" alt="Clear Form" onClick="this.form.reset(); return false;" tabindex="49" />
			</td>
               <td align="LEFT">&nbsp;&nbsp;</td>
		</tr>
	</table>
</cfform>
	
	<table border="0" size="100%">
		<tr>
			<td align="LEFT" valign="top">
<cfform action="/#application.type#apps/webreports/processabsencerequest.cfm" method="POST">
				<input type="hidden" name="PROCESSABSENCEREQUESTS" value="CANCELADD" />
				<input type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="50" />
				
</cfform>
			</td>
               <td align="LEFT" valign="top">
               	&nbsp;&nbsp;<com><--- Click this button to delete the blank form and return to the Forms Page.</com>
			</td>
		</tr>
	</table>
	
	
	<p>Supervisors are to forward their recommendation for approval/denial of all requests
	for <b>vacation, personal holiday, CTO, or any other use of accruals requiring
	scheduling</b> to their division head/manager and the employee.
	</p>

	<p><b>All approved requests for LWOP (Leave Without Pay)</b> need to be copied to Library Payroll 
	in order to avoid having a hold placed on your paycheck.  Please direct all questions about this
	form or any payroll issue to Joan Shelby (x41642 or <a href="mailto:jshelby@mail.sdsu.edu">jshelby@mail.sdsu.edu</a>.)
	</p>

	<p>Information regarding vacations and leaves can be found at 
		<a href="http://www.calstate.edu/LaborRel/Contracts_HTML/contracts.shtml">
		Contract Information</a>
	</p>

	<cfinclude template="/include/coldfusion/footer.cfm">

<cfelse>

<!--- 
**********************************************************************************************
* The following code is the Look Up Process for Modifying the Web Reports - Absence Request. *
**********************************************************************************************
 --->

	<cfif NOT IsDefined('URL.LOOKUPABSENCEREQUESTS')>
	
		<cfquery name="LookupAbsenceRequests" datasource="#application.type#WEBREPORTS" blockfactor="100">
			SELECT	A.ABSENCEID, TO_CHAR(A.SUBMITDATE, 'YYYY/MM/DD') AS SUBMITDATE, A.REQUESTERID, CUST.FULLNAME, A.REQUESTEREMAIL,
					A.SUPERVISOREMAILID, A.CC2, A.CARBON, A.BEGINDATE1, A.ENDDATE1, A.BEGINDATE2, A.ENDDATE2, A.BEGINDATE3, A.ENDDATE3,
					A.BEGINDATE4, A.ENDDATE4, A.HOURS1, A.HOURS2, A.HOURS3, A.HOURS4, A.BEGINTIME1, A.ENDTIME1, A.BEGINTIME2, A.ENDTIME2,
					A.BEGINTIME3, A.ENDTIME3, A.BEGINTIME4, A.ENDTIME4, A.DAYS1ID, A.DAYS2ID, A.DAYS3ID, A.DAYS4ID, A.VACATION,
					A.PERSONALHOLIDAY, A.COMPTIME, A.FMLA, A.FUNERAL, A.GTO, A.JURYDUTY, A.LWOP, A.MATPAT, A.MILITARY, A.OTHER, A.SICKFAMILY,
					A.SICKSELF,A.WITNESS, A.RELATIONSHIP, A.REASON, TO_CHAR(A.SUBMITDATE, 'MM/DD/YYYY') || ' - ' || CUST.FULLNAME AS LOOKUPKEY
			FROM		ABSENCEREQUESTS A, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	A.REQUESTERID = CUST.CUSTOMERID
				<CFIF FIND('forms', #Cookie.INDEXDIR#, 1) NEQ 0>
					AND (A.ABSENCEID = 0 OR
					 A.REQUESTERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC">)
				<CFELSE>
					
				</CFIF>
			ORDER BY	SUBMITDATE DESC, CUST.FULLNAME
		</cfquery>

		<table width="100%" align="center" border="3">
			<tr align="LEFT">
				<th align="center"><h1>Lookup Modify/Delete Information to Web Reports - Absence Request</h1></th>
			</tr>
		</table>
		<table width="100%" align="center" border="0">
			<tr>
				<th align="center">
					<h4>*Red fields marked with asterisks are required!</h4>
				</th>
			</tr>
		</table>

		<table width="100%" align="LEFT">
			<tr>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<td align="left">
					<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><br /><br />
				</td>
</cfform>
			</tr>
<cfform name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/absencerequest.cfm?PROCESS=#URL.PROCESS#&LOOKUPABSENCEREQUESTS=FOUND" method="POST">
			<tr>
				<th align="LEFT">
				<cfif FIND('forms', #Cookie.INDEXDIR#, 1) NEQ 0>
					<h4><label for="ABSENCEID">*Submit Date</label>
				<cfelse>
					<h4><label for="ABSENCEID">*Submit Date - Customer</label>
				</cfif>
				</th>
			</tr>
			<tr>
				<td align="LEFT">
				<cfif FIND('forms', #Cookie.INDEXDIR#, 1) NEQ 0>
					<cfselect name="ABSENCEID" id="ABSENCEID" size="1" query="LookupAbsenceRequests" value="ABSENCEID" display="SUBMITDATE" required="No" tabindex="2"></cfselect>
				<cfelse>
					<cfselect name="ABSENCEID" id="ABSENCEID" size="1" query="LookupAbsenceRequests" value="ABSENCEID" display="LOOKUPKEY" required="No" tabindex="2"></cfselect>
				</cfif>
				<COM>Please select a date.</COM>
				</td>
			</tr>
               <tr>
				<td align="left">&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td align="left">
                    	<input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </td>
			</tr>
</cfform>
			<tr>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<td align="left">
					<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><br />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</td>
</cfform>
			</tr>
			<tr>
				<td align="LEFT" colspan="3">
					<cfinclude template="/include/coldfusion/footer.cfm">
				</td>
			</tr>
		</table>

	<cfelse>

<!--- 
********************************************************************************************
* The following code is the Modify and Delete Processes for Web Reports - Absence Request. *
********************************************************************************************
 --->

		<cfquery name="GetAbsenceRequests" datasource="#application.type#WEBREPORTS">
			SELECT	A.ABSENCEID, A.SUBMITDATE, A.REQUESTERID, CUST.FULLNAME AS CUSTNAME, CUST.EMAIL AS REQEMAIL,
               		A.REQUESTEREMAIL, A.SUPERVISOREMAILID, SUPVR.EMAIL AS SUPVREMAIL, A.CC2, A.ADDITIONALCC, A.CARBON, 
                         TO_CHAR(A.BEGINDATE1, 'MM/DD/YYYY') AS BEGINDATE1,
					TO_CHAR(A.ENDDATE1, 'MM/DD/YYYY') AS ENDDATE1, TO_CHAR(A.BEGINDATE2, 'MM/DD/YYYY') AS BEGINDATE2,
					TO_CHAR(A.ENDDATE2, 'MM/DD/YYYY') AS ENDDATE2, TO_CHAR(A.BEGINDATE3, 'MM/DD/YYYY') AS BEGINDATE3,
					TO_CHAR(A.ENDDATE3, 'MM/DD/YYYY') AS ENDDATE3, TO_CHAR(A.BEGINDATE4, 'MM/DD/YYYY') AS BEGINDATE4,
					TO_CHAR(A.ENDDATE4, 'MM/DD/YYYY') AS ENDDATE4, A.HOURS1, A.HOURS2, A.HOURS3, A.HOURS4,
					TO_CHAR(A.BEGINTIME1, 'HH24:MI') AS BEGINTIME1, TO_CHAR(A.ENDTIME1, 'HH24:MI') AS ENDTIME1,
					TO_CHAR(A.BEGINTIME2, 'HH24:MI') AS BEGINTIME2, TO_CHAR(A.ENDTIME2, 'HH24:MI') AS ENDTIME2,
					TO_CHAR(A.BEGINTIME3, 'HH24:MI') AS BEGINTIME3, TO_CHAR(A.ENDTIME3, 'HH24:MI') AS ENDTIME3,
					TO_CHAR(A.BEGINTIME4, 'HH24:MI') AS BEGINTIME4, TO_CHAR(A.ENDTIME4, 'HH24:MI') AS ENDTIME4,
					A.DAYS1ID, A.DAYS2ID, A.DAYS3ID, A.DAYS4ID, A.VACATION, A.PERSONALHOLIDAY, A.COMPTIME, A.FMLA, A.FUNERAL,
					A.GTO, A.JURYDUTY, A.LWOP, A.MATPAT, A.MILITARY, A.OTHER, A.SICKFAMILY, A.SICKSELF,A.WITNESS, A.RELATIONSHIP, A.REASON
			FROM		ABSENCEREQUESTS A, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CUSTOMERS SUPVR
			WHERE	A.ABSENCEID = <CFQUERYPARAM value="#FORM.ABSENCEID#" cfsqltype="CF_SQL_NUMERIC"> AND
					A.REQUESTERID = CUST.CUSTOMERID AND
					A.SUPERVISOREMAILID = SUPVR.CUSTOMERID
			ORDER BY	A.SUBMITDATE
		</cfquery>

		<table width="100%" align="center" border="3">
			<tr>
				<th align="center"><h1>Modify/Delete Information to Web Reports - Absence Request</h1></th>
			</tr>
		</table>

		<table border="0" width="100%">
			<tr>
				<th align="center" colspan="2">
					<h4>*Red fields marked with asterisks are required!</h4>
				</th>
			</tr>
			<tr>
				<th align="center" colspan="2">
					<cfcookie name="ABSENCEID" secure="NO" value="#GetAbsenceRequests.ABSENCEID#">
					Absence Key &nbsp; = &nbsp; #GetAbsenceRequests.ABSENCEID#
					&nbsp;&nbsp;&nbsp;&nbsp;Date Submitted: #DateFormat(GetAbsenceRequests.SUBMITDATE, "MM/DD/YYYY")#
				</th>
			</tr>
			<tr>
<cfform action="/#application.type#apps/webreports/absencerequest.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<td align="left">
					<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</td>
</cfform>
			</tr>
			<tr>
				<td align="LEFT">&nbsp;&nbsp;</td>
				<td align="LEFT">&nbsp;&nbsp;</td>
			</tr>
		</table>

<cfform name="ABSENCEREQUESTS" method="POST" onsubmit="return validateReqInfo();" action="/#application.type#apps/webreports/processabsencerequest.cfm">

		<fieldset>
		<legend>Customer Info</legend>
		<table border="0" width="100%">
			<tr>
				<th align="LEFT"><h4><b>*Customer's Name:</b></h4></th>
				<td align="LEFT">
					<input type="hidden" name="REQUESTERID" value="#GetAbsenceRequests.REQUESTERID#" />
					#GetAbsenceRequests.CUSTNAME#
				</td>
			</tr>

			<tr>
				<th align="LEFT"><h4><b><label for="REQUESTEREMAIL">*Email Address:</label></b></h4></th>
				<td align="LEFT"><cfinput name="REQUESTEREMAIL" id="REQUESTEREMAIL" value="#GetAbsenceRequests.REQUESTEREMAIL#" size="25" tabindex="3"></td>
			</tr>

			<tr>
				<th align="LEFT"><h4><b><label for="SUPERVISOREMAILID">*Supervisor's Email:</label></b></h4></th>
				<td align="LEFT">
					<cfselect name="SUPERVISOREMAILID" id="RSUPERVISOREMAILID" query="ListSupervisors" value="CUSTOMERID" display="EMAIL" selected="#GetAbsenceRequests.SUPERVISOREMAILID#" tabindex="4"></cfselect>
				</td>
			</tr>
			<tr>
				<th align="LEFT"><b><label for="CC2">Carbon Copy:</label></b></th>
				<td align="LEFT">
					<cfselect name="CC2" id="CC2" query="ListCCEmail" value="EMAIL" display="EMAIL" selected="#GetAbsenceRequests.CC2#" tabindex="5"></cfselect>
				</td>
			</tr>
               <tr>
                    <th align="LEFT"><b><label for="CC2">Additional Carbon Copy:</label></b></th>
                    <td align="LEFT">
                         <cfinput name="ADDITIONALCC" id="ADDITIONALCC" value="#GetAbsenceRequests.ADDITIONALCC#" size="100" maxlength="200" tabindex="6">
                    </td>
               </tr>
		</table>
		<cfif #GetAbsenceRequests.CARBON# NEQ "">
			<cfinput type="checkbox" name="CARBON" id="CARBON" value="YES" checked tabindex="7"><com><label for="CARBON">A Check will Carbon Copy Requester</label></com><br />
		<cfelse>
			<cfinput type="checkbox" name="CARBON" id="CARBON" value="" tabindex="7"><com><label for="CARBON">A Check will Carbon Copy Requester</label></com><br />
		</cfif>
		</fieldset>
		<br />
		<fieldset>
		<legend>Request Detail</legend>
		<table border="0" width="100%">
			<tr>
				<th align="CENTER" valign="BOTTOM">
					<strong><label for="BEGINDATE1">Enter a Single Date or <br />
					a <h4>*Begin Date</h4></LABEL> - <label for="ENDDATE1">End Date Range</label></strong><br />
					<COM><strong>(Date Format must be XX/XX/XXXX)</strong></COM>
				</th>
				<th align="CENTER" valign="BOTTOM"><b>
					<label for="HOURS1"><h4>*## Hours</h4> - Double click box<br />
					<COM><strong>(Maximum 40 Hours per line)</strong></COM></LABEL>
				</th>
				<th align="CENTER" valign="BOTTOM"><b>
					<label for="BEGINTIME1">Enter a Begin Time </label>- <label for="ENDTIME1">End Time Range </label><br />
					<strong>ONLY</strong> if you are using <br /> less than 8 hours of time.</b><br />
					<COM><strong>(Time Format must be in Military time Hours & Minutes - 0:00-23:59)</strong></COM>
				</th>
			<th align="CENTER" valign="BOTTOM">
				<b><label for="DAYS1"><h4>*Day of Week</h4> <br />
				From - To</LABEL></b> <br />
				<com>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</com>
			</th>
			</tr>

			<tr>
				<td align="CENTER" valign="top">
					<cfinput name="BEGINDATE1" id="BEGINDATE1" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINDATE1#" tabindex="8">
					<script language="JavaScript">
						new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE1'});

					</script>
					&nbsp;&nbsp;

					<cfinput name="ENDDATE1" id="ENDDATE1" size="10" maxlength="15" value="#GetAbsenceRequests.ENDDATE1#" tabindex="9">
					<script language="JavaScript">
						new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE1'});

					</script>

				</td>
				<td align="CENTER" valign="top">
					<cfinput name="HOURS1" id="HOURS1" size="2" maxlength="5" value="#GetAbsenceRequests.HOURS1#" onClick="return(CalcHours1());" tabindex="10"></td>
				<td align="CENTER" valign="top">
					<cfinput name="BEGINTIME1" id="BEGINTIME1" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINTIME1#" tabindex="11">&nbsp;&nbsp;
					<cfinput name="ENDTIME1" id="ENDTIME1" size="10" maxlength="15" value="#GetAbsenceRequests.ENDTIME1#" tabindex="12">
				</td> 
				<td align="LEFT" valign="top">
					<cfselect name="DAYS1ID" id="DAYS1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="#GetAbsenceRequests.DAYS1ID#" tabindex="13"></cfselect>
				</td>
			</tr>

			<tr>
				<td align="CENTER" valign="top">
					<label for="BEGINDATE2" class="LABEL_hidden">Begin Date 2</label>
					<cfinput name="BEGINDATE2" id="BEGINDATE2" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINDATE2#" tabindex="14">
					<script language="JavaScript">
						new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE2'});

					</script>
					&nbsp;&nbsp;

					<label for="ENDDATE2" class="LABEL_hidden">End Date 2</label>
					<cfinput name="ENDDATE2" id="ENDDATE2" size="10" maxlength="15" value="#GetAbsenceRequests.ENDDATE2#" tabindex="15">
					<script language="JavaScript">
						new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE2'});

					</script>

				</td>
				<td align="CENTER" valign="top">
					<label for="HOURS2" class="LABEL_hidden">## Hours 2</label>
					<cfinput name="HOURS2" id="HOURS2" size="2" maxlength="5" value="#GetAbsenceRequests.HOURS2#" onClick="return(CalcHours2());" tabindex="16">
				</td>
				<td align="CENTER" valign="top">
					<label for="BEGINTIME2" class="LABEL_hidden">Begin Time 2</label>
					<cfinput name="BEGINTIME2" id="BEGINTIME2" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINTIME2#" tabindex="17">&nbsp;&nbsp;
					<label for="ENDTIME2" class="LABEL_hidden">End Time 2</label>
					<cfinput name="ENDTIME2" id="ENDTIME2" size="10" maxlength="15" value="#GetAbsenceRequests.ENDTIME2#" tabindex="18">
				</td>
				<td align="LEFT" valign="top">
					<label for="DAYS2" class="LABEL_hidden">Day of Week 2</label>
					<cfselect name="DAYS2ID" id="DAYS2" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="#GetAbsenceRequests.DAYS2ID#" required="No" tabindex="19"></cfselect>
				</td>
			</tr>

			<tr>
				<td align="CENTER" valign="top">
					<label for="BEGINDATE3" class="LABEL_hidden">Begin Date 3</label>
					<cfinput name="BEGINDATE3" id="BEGINDATE3" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINDATE3#" tabindex="20">
					<script language="JavaScript">
						new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE3'});

					</script>
					&nbsp;&nbsp;

					<label for="ENDDATE3" class="LABEL_hidden">End Date 3</label>
					<cfinput name="ENDDATE3" id="ENDDATE3" size="10" maxlength="15" value="#GetAbsenceRequests.ENDDATE3#" tabindex="21">
					<script language="JavaScript">
						new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE3'});

					</script>

				</td>
				<td align="CENTER" valign="top">
					<label for="HOURS3" class="LABEL_hidden">## Hours 3</label>
					<cfinput name="HOURS3" id="HOURS3" size="2" maxlength="5" value="#GetAbsenceRequests.HOURS3#" onClick="return(CalcHours3());" tabindex="22">
				</td>
				<td align="CENTER" valign="top">
					<label for="BEGINTIME3" class="LABEL_hidden">Begin Time 3</label>
					<cfinput name="BEGINTIME3" id="BEGINTIME3" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINTIME3#" tabindex="23">&nbsp;&nbsp;
					<label for="ENDTIME3" class="LABEL_hidden">End Time 1</label>
					<cfinput name="ENDTIME3" id="ENDTIME3" size="10" maxlength="15" value="#GetAbsenceRequests.ENDTIME3#" tabindex="24">
				</td> 
				<td align="LEFT" valign="top">
					<label for="DAYS3" class="LABEL_hidden">Day of Week 3</label>
					<cfselect name="DAYS3ID" id="DAYS3" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="#GetAbsenceRequests.DAYS3ID#" required="No" tabindex="25"></cfselect>
				</td>
			</tr>

			<tr>
				<td align="CENTER" valign="top">
					<label for="BEGINDATE4" class="LABEL_hidden">Begin Date 4</label>
					<cfinput name="BEGINDATE4" id="BEGINDATE4" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINDATE4#" tabindex="26">
					<script language="JavaScript">
						new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE4'});

					</script>
					&nbsp;&nbsp;

					<label for="ENDDATE4" class="LABEL_hidden">End Date 4</label>
					<cfinput name="ENDDATE4" id="ENDDATE4" size="10" maxlength="15" value="#GetAbsenceRequests.ENDDATE4#" tabindex="27">
					<script language="JavaScript">
						new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE4'});

					</script>

				</td>
				<td align="CENTER" valign="top">
					<label for="HOURS4" class="LABEL_hidden">## Hours 4</label>
					<cfinput name="HOURS4" id="HOURS4" size="2" maxlength="5" value="#GetAbsenceRequests.HOURS4#" onClick="return(CalcHours4());" tabindex="28"></td>
				<td align="CENTER" valign="top">
					<label for="BEGINTIME4" class="LABEL_hidden">Begin Time 4</label>
					<cfinput name="BEGINTIME4" id="BEGINTIME4" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINTIME4#" tabindex="29">&nbsp;&nbsp;
					<label for="ENDTIME4" class="LABEL_hidden">End Time 4</label>
					<cfinput name="ENDTIME4" id="ENDTIME4" size="10" maxlength="15" value="#GetAbsenceRequests.ENDTIME4#" tabindex="30">
				</td>
				<td align="LEFT" valign="top">
					<label for="DAYS4" class="LABEL_hidden">Day of Week 4</label>
					<cfselect name="DAYS4ID" id="DAYS4" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="#GetAbsenceRequests.DAYS4ID#" required="No" tabindex="31"></cfselect>
				</td>
			</tr>
		</table>
		</fieldset>
		<br />
		<fieldset>
		<legend>Request Use Of Hours for Absence Type</legend>
		<table border="0" width="100%">
			<tr>
				<td align="LEFT" valign="BOTTOM" colspan="4" >
					<br /><com>Fill in number of hours: - (<h4> *At least one box must be filled in</h4>)</com>
				</td>
			</tr>
			<tr>
				<th align="LEFT"><label for="VACATION">Vacation</label></th>
				<td align="LEFT"><cfinput name="VACATION" id="VACATION" size="5" maxlength="5" value="#GetAbsenceRequests.VACATION#" tabindex="32"></td>
				<th align="LEFT"><label for="PERSONALHOLIDAY">Personal Holiday</label></th>
				<td align="LEFT"><cfinput name="PERSONALHOLIDAY" id="PERSONALHOLIDAY" size="5" maxlength="5" value="#GetAbsenceRequests.PERSONALHOLIDAY#" tabindex="33"></td>
				
			</tr>

			<tr>
				<td align="LEFT">&nbsp;&nbsp;</td>
				<td align="LEFT">&nbsp;&nbsp;</td>
				<td align="LEFT">&nbsp;&nbsp;</td>
				<td align="LEFT">&nbsp;&nbsp;</td>
			</tr>

			<tr>
				<th align="LEFT"><label for="COMPTIME">Compensatory Time Off</label></th>
				<td align="LEFT"><cfinput name="COMPTIME" id="COMPTIME" size="5" maxlength="5" value="#GetAbsenceRequests.COMPTIME#" tabindex="34"></td>
				<th align="LEFT"><label for="FMLA">Family Medical Leave Act</label></th>
				<td align="LEFT"><cfinput name="FMLA" id="FMLA" size="5" maxlength="5" value="#GetAbsenceRequests.FMLA#" tabindex="35"></td>
			</tr>

			<tr>
				<th align="LEFT"><label for="FUNERAL">Funeral Leave*</label></th>
				<td align="LEFT"><cfinput name="FUNERAL" id="FUNERAL" size="5" maxlength="5" value="#GetAbsenceRequests.FUNERAL#" tabindex="36"></td>
				<th align="LEFT"><label for="OTHER">Other</label></th>
				<td align="LEFT"><cfinput name="OTHER" id="OTHER" size="5" maxlength="5" value="#GetAbsenceRequests.OTHER#" tabindex="37"></td>
			</tr>

			<tr>
				<th align="LEFT"><label for="GTO">Holiday Informal Time - GTO</label></th>
				<td align="LEFT"><cfinput name="GTO" id="GTO" size="5" maxlength="5" value="#GetAbsenceRequests.GTO#" tabindex="38"></td>
				<th align="LEFT"><label for="JURYDUTY">Jury Duty</label></th>
				<td align="LEFT"><cfinput name="JURYDUTY" id="JURYDUTY" size="5" maxlength="5" value="#GetAbsenceRequests.JURYDUTY#" tabindex="39"></td>
			</tr>

			<tr>
				<th align="LEFT"><h4><label for="LWOP">LWOP</label></h4></th>
				<td align="LEFT"><cfinput name="LWOP" id="LWOP" size="5" maxlength="5" value="#GetAbsenceRequests.LWOP#" tabindex="40"></td>
				<th align="LEFT"><label for="MATPAT">Maternity/Paternity Leave</label></th>
				<td align="LEFT"><cfinput name="MATPAT" id="MATPAT" size="5" maxlength="5" value="#GetAbsenceRequests.MATPAT#" tabindex="41"></td>
			</tr>

			<tr>
				<th align="LEFT"><label for="MILITARY">Military Leave</label></th>
				<td align="LEFT"><cfinput name="MILITARY" id="MILITARY" size="5" maxlength="5" value="#GetAbsenceRequests.MILITARY#" tabindex="42"></td>
				<th align="LEFT"><label for="SICKFAMILY">Sick Leave Family*</label></th>
				<td align="LEFT"><cfinput name="SICKFAMILY" id="SICKFAMILY" size="5" maxlength="5" value="#GetAbsenceRequests.SICKFAMILY#" tabindex="43"></td>
			</tr>

			<tr>
				<th align="LEFT"><label for="SICKSELF">Sick Leave Self</label></th>
				<td align="LEFT"><cfinput name="SICKSELF" id="SICKSELF" size="5" maxlength="5" value="#GetAbsenceRequests.SICKSELF#" tabindex="44"></td>
				<th align="LEFT"><label for="WITNESS">Subpoena Witness</label></th>
				<td align="LEFT"><cfinput name="WITNESS" id="WITNESS" size="5" maxlength="5" value="#GetAbsenceRequests.WITNESS#" tabindex="45"></td>
			</tr>
		</table>
		</fieldset>
		<br />
		<fieldset>
		<legend>Explanations</legend>
		<table border="0" width="100%">
			<tr>
				<td align="LEFT" colspan="4">&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<th align="LEFT" colspan="3">
					<label for="REQUESTERID">*Give Relationship:</label>
				</th>
				<th align="CENTER">
					<label for="REQUESTERID">REASON FOR ABSENCE (Sick Leave / <h4>LWOP</h4>):</LABEL>
				</th>
			</tr>
			<tr>
				<td align="LEFT" valign="TOP" colspan="3">
					<cfinput id="REQUESTERID" size="15" maxlength=25 value="#GetAbsenceRequests.RELATIONSHIP#" name="RELATIONSHIP" tabindex="46">
				</td>
				<td align="CENTER">
					<textarea name="REASON" id="REQUESTERID" wrap=HARD rows=3 cols=50 tabindex="47">#GetAbsenceRequests.REASON#</textarea>
				</td>
			</tr>
		</table>
		</fieldset>
		<br />
		<table border="0" width="100%">
          	<tr>
				<td align="left">
                    	<input type="hidden" name="PROCESSABSENCEREQUESTS" value="MODIFY" />
                         <input type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="48" />
                    </td>
			</tr>
		<cfif #Client.DeleteFlag# EQ "Yes">
			<tr>
				<td align="left">&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td align="left">&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td align="left">
                    	<input type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="49" />
                    </td>
			</tr>
		</cfif>
		</table>
</cfform>

		<table border="0" width="100%">
			<tr>
				<td align="left">&nbsp;&nbsp;</td>
			</tr>
			<tr>
<cfform action="/#application.type#apps/webreports/absencerequest.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<td align="left">
					<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="50" /><br />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</td>
</cfform>
			</tr>
		</table>

		<p>Clicking the <b>Modify</b> button will update the database and forward this changed electronic request to your
		supervisor via email.
		</p>

		<p>Supervisors are to forward their recommendation for approval/denial of all requests
		for <b>vacation, personal holiday, CTO, or any other use of accruals requiring
		scheduling</b> to their division head/manager and the employee.
		</p>

		<p><b>All approved requests for LWOP (Leave Without Pay)</b> need
		to be copied to Library Payroll in order to avoid having a hold
		placed on your paycheck.  Please direct all questions about this form or any payroll issue to
		Joan Shelby (x41642 or <a href="mailto:jshelby@mail.sdsu.edu">jshelby@mail.sdsu.edu</a>.)
		</p>

		<p>Information regarding vacations and leaves can be found at 
		<a href="http://www.calstate.edu/LaborRel/Contracts_HTML/contracts.shtml">
		Contract Information</a>
		</p>

		<cfinclude template="/include/coldfusion/footer.cfm">
	</cfif>
</cfif>

</body>
</html>
</cfoutput>
