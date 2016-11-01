<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: absencerequestapproval.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/25/2012 --->
<!--- Date in Production: 07/25/2012 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Absence Request Approval --->
<!-- Last modified by John R. Pastori on 06/07/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/absencerequestapproval.cfm">
<CFSET CONTENT_UPDATED = "June 07, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Web Reports - Absence Request Approval</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JavaScript1.1>
	window.defaultStatus = "Welcome to Web Reports - Absense Request Approval";

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

	function validateReqDates() {
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
		if (!validateText(document.ABSENCEREQUESTS.HOURS1.name, document.ABSENCEREQUESTS.HOURS1.value)) {
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

//	
</SCRIPT>
<SCRIPT language="JavaScript" src="calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY onLoad="document.ABSENCEREQUESTS.REQUESTERID.focus()">

<CFOUTPUT>
<A name="top"></A>

<CFIF IsDefined('URL.ABSENCEID')>
	<CFSET PROGRAMNAME = 'processabsencerequest.cfm?POPUP=YES'>
<CFELSE>
	<CFSET PROGRAMNAME = 'processabsencerequest.cfm'>
</CFIF>


<!--- 
******************************************************************************************
* The following code is used by ALL Processes in Web Reports - Absence Request Approval. *
******************************************************************************************
 --->

<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.FULLNAME || '-' || CUST.EMAIL AS SUPEMAIL, CUST.UNITID, U.GROUPID,
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

<CFQUERY name="ListSupervisors" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, EMAIL, FULLNAME, UNITHEAD, DEPTCHAIR, ACTIVE
	FROM		CUSTOMERS
	WHERE	ACTIVE = 'YES' AND
			(UNITHEAD = 'YES' OR
			DEPTCHAIR = 'YES')
	ORDER BY	EMAIL
</CFQUERY>

<CFQUERY name="ListDaysOfWeek" datasource="#application.type#LIBSHAREDDATA" blockfactor="24">
	SELECT	DAYSOFWEEKID, DAYSOFWEEKNAME
	FROM		DAYSOFWEEK
	ORDER BY	DAYSOFWEEKID
</CFQUERY>


<CFQUERY name="ListRequestStatus" datasource="#application.type#WEBREPORTS" blockfactor="5">
	SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
	FROM		REQUESTSTATUS
	ORDER BY	REQUESTSTATUSNAME
</CFQUERY>

<CFQUERY name="ListSupApprovals" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.FULLNAME || '-' || CUST.EMAIL AS SUPEMAIL, CUST.UNITID, U.GROUPID,
			CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.ALLOWEDTOAPPROVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.CUSTOMERID = 0 AND 
			CUST.UNITID = U.UNITID) OR
			(CUST.UNITID = U.UNITID AND
			U.GROUPID IN (2,3,4,6) AND 
			CUST.UNITHEAD = 'YES' AND
			CUST.ALLOWEDTOAPPROVE = 'YES')
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListCCEmail" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	DISTINCT EMAIL
	FROM		CUSTOMERS
	WHERE	(CUSTOMERID = 0) OR 
			(ACTIVE = 'YES' AND
			NOT EMAIL = 'none' AND
			NOT EMAIL LIKE '@%')
	ORDER BY	EMAIL
</CFQUERY>

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
	<TR>
		<TD align="left">
			<CFINCLUDE template="/include/coldfusion/formheader.cfm">
		</TD>
		<TD align="right">
			<BIG><I>Go to the </I><STRONG><A href="http://library.sdsu.edu"><FONT color="RED"> Library's Web Site</FONT></A></STRONG></BIG>
		</TD>
	</TR>
</TABLE>


<!--- 
*********************************************************************************************
* The following code is the Generation Process for Web Reports - Absence Requests Approval. *
*********************************************************************************************
 --->

<CFIF NOT IsDefined('URL.ABSENCEID')>
	<CFIF NOT IsDefined ('session.ABSENCEREQUESTIDArray') OR (IsDefined ('session.ABSENCEREQUESTSSELECTED') AND #session.ABSENCEREQUESTSSELECTED# EQ 0)>
		<CFSET session.ArrayCounter = 1>
		<CFQUERY name="LookupAbsenceRequests" datasource="#application.type#WEBREPORTS" blockfactor="100">
			SELECT	A.ABSENCEID, A.SUBMITDATE, A.REQUESTERID, CUST.FULLNAME, CUST.EMAIL AS REQEMAIL, A.REQUESTEREMAIL, A.SUPERVISOREMAILID,
					SUPVR.EMAIL AS SUPVREMAIL, SUPVR.FULLNAME AS SUPVRNAME, A.CC2, A.ADDITIONALCC, A.CARBON, 
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
					A.GTO, A.JURYDUTY, A.LWOP, A.MATPAT, A.MILITARY, A.OTHER, A.SICKFAMILY, A.SICKSELF,A.WITNESS, A.RELATIONSHIP,
					A.REASON, A.REQUESTSTATUSID, A.APPROVEDBYSUPID, A.SUPAPPROVALDATE
			FROM		ABSENCEREQUESTS A, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CUSTOMERS SUPVR
			WHERE	A.ABSENCEID > 0 AND
					A.REQUESTERID = CUST.CUSTOMERID AND
					A.SUPERVISOREMAILID = SUPVR.CUSTOMERID AND
					A.REQUESTSTATUSID = 4
				<CFIF FIND('forms', CGI.HTTP_REFERER, 1) NEQ 0>
					AND A.SUPERVISOREMAILID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC">
				</CFIF>
			ORDER BY	A.SUBMITDATE, CUST.FULLNAME
		</CFQUERY>
	
		<CFIF LookupAbsenceRequests.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records matching your Customer ID were Not Found");
				--> 
			</SCRIPT>
			<CFIF FIND('forms', CGI.HTTP_REFERER, 1) NEQ 0>
				<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
			<CFELSE>
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/index.cfm?logout=No" />
			</CFIF>
			<CFEXIT>
		<CFELSE>
			<CFSET session.ABSENCEREQUESTIDArray = ListToArray(#ValueList(LookupAbsenceRequests.ABSENCEID)#)>
			<CFSET session.ABSENCEREQUESTSSELECTED = #LookupAbsenceRequests.RecordCount#>
		</CFIF>
	</CFIF>
</CFIF>

<CFQUERY name="GetAbsenceRequests" datasource="#application.type#WEBREPORTS">
	SELECT	A.ABSENCEID, A.SUBMITDATE, A.REQUESTERID, CUST.FULLNAME, CUST.EMAIL AS REQEMAIL, A.REQUESTEREMAIL, A.SUPERVISOREMAILID,
			SUPVR.EMAIL AS SUPVREMAIL, SUPVR.FULLNAME AS SUPVRNAME, A.CC2, A.ADDITIONALCC, A.CARBON, 
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
			A.GTO, A.JURYDUTY, A.LWOP, A.MATPAT, A.MILITARY, A.OTHER, A.SICKFAMILY, A.SICKSELF,A.WITNESS, A.RELATIONSHIP,
			A.REASON, A.REQUESTSTATUSID, A.APPROVEDBYSUPID, A.SUPAPPROVALDATE
	FROM		ABSENCEREQUESTS A, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CUSTOMERS SUPVR
	WHERE	A.ABSENCEID > 0 AND
		<CFIF IsDefined('URL.ABSENCEID')>
			A.ABSENCEID = <CFQUERYPARAM value="#URL.ABSENCEID#" cfsqltype="CF_SQL_NUMERIC"> AND
		<CFELSE>
			A.ABSENCEID = <CFQUERYPARAM value="#session.ABSENCEREQUESTIDArray[session.ArrayCounter]#" cfsqltype="CF_SQL_NUMERIC"> AND
		</CFIF>
			A.REQUESTERID = CUST.CUSTOMERID AND
			A.SUPERVISOREMAILID = SUPVR.CUSTOMERID
	ORDER BY	A.SUBMITDATE, CUST.FULLNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TH align="center"><H1>Web Reports - Absence Request Approval</H1></TH>
	</TR>
</TABLE>

<TABLE border="0" width="100%">
	<TR>
		<TH align="center" colspan="4">
			<H4>*Red fields marked with asterisks are required!</H4>
		</TH>
	</TR>
	<TR>
		<TH align="center" colspan="4">
			<CFCOOKIE name="ABSENCEID" secure="NO" value="#GetAbsenceRequests.ABSENCEID#">
			Absence Key &nbsp; = &nbsp; #GetAbsenceRequests.ABSENCEID#
			&nbsp;&nbsp;&nbsp;&nbsp;Date Submitted: #DateFormat(GetAbsenceRequests.SUBMITDATE, "MM/DD/YYYY")#
		</TH>
	</TR>
<CFIF IsDefined('URL.ABSENCEID')>
	<TR>
		<TD align="left">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" />
		</TD>
	</TR>
<CFELSE>
	<TR>
	<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
		<TD align="left">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
	</CFFORM>
	</TR>
</CFIF>
	<TR>
		<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
	</TR>
</TABLE>

<CFFORM name="ABSENCEREQUESTS" method="POST" onsubmit="return validateReqDates();" action="/#application.type#apps/webreports/#PROGRAMNAME#">

<FIELDSET>
<LEGEND>Customer Info</LEGEND>
<TABLE border="0" width="100%">
	<TR>
		<TH align="LEFT"><H4><STRONG><LABEL for="REQUESTERID">*Customer's Name:</LABEL></STRONG></H4></TH>
		<TD align="LEFT">
			&nbsp;<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#GetAbsenceRequests.REQUESTERID#" required="No" tabindex="2"></CFSELECT>
		</TD>
	</TR>
	<TR>
		<TH align="LEFT"><H4><STRONG><LABEL for="REQUESTEREMAIL">*Email Address:</LABEL></STRONG></H4></TH>
		<TD align="LEFT">
			<CFINPUT name="REQUESTEREMAIL" id="REQUESTEREMAIL" value="#GetAbsenceRequests.REQEMAIL#" size="25" tabindex="3">
		</TD>
	</TR>
	<TR>
		<TH align="LEFT"><H4><STRONG><LABEL for="SUPERVISOREMAILID">*Supervisor's Email:</LABEL></STRONG></H4></TH>
		<TD align="LEFT">
			&nbsp;<CFSELECT name="SUPERVISOREMAILID" id="SUPERVISOREMAILID" query="ListSupervisors" value="CUSTOMERID" display="EMAIL" selected="#GetAbsenceRequests.SUPERVISOREMAILID#" tabindex="4"></CFSELECT>
		</TD>
	</TR>
	<TR>
		<TH align="LEFT"><STRONG><LABEL for="CC2">Carbon Copy:</LABEL></STRONG></TH>
		<TD align="LEFT">
			&nbsp;<CFSELECT name="CC2" id="CC2" query="ListCCEmail" value="EMAIL" display="EMAIL" selected="#GetAbsenceRequests.CC2#" tabindex="5"></CFSELECT>
		</TD>
	</TR>
     <TR>
          <TH align="LEFT"><B><LABEL for="CC2">Additional Carbon Copy:</LABEL></B></TH>
          <TD align="LEFT">
               <CFINPUT name="ADDITIONALCC" id="ADDITIONALCC" value="#GetAbsenceRequests.ADDITIONALCC#" size="100" maxlength="200" tabindex="6">
          </TD>
     </TR>
	<TR>
		<TD align="LEFT" valign="top">
		<CFIF #GetAbsenceRequests.CARBON# NEQ "">
			<CFINPUT type="checkbox" name="CARBON" id="CARBON" value="YES" checked tabindex="7">
			<LABEL for="CARBON"><com>A Check will Carbon Copy Requester</com></LABEL><BR /><BR />
		<CFELSE>
			<CFINPUT type="checkbox" name="CARBON" id="CARBON" value="" tabindex="7">
			<LABEL for="CARBON"><com>A Check will Carbon Copy Requester</com></LABEL><BR /><BR />
		</CFIF>
		</TD>
	</TR>
</TABLE>
</FIELDSET>
<BR />
<FIELDSET>
<LEGEND>Request Detail</LEGEND>
<TABLE border="0" width="100%">
	<TR>
		<TH align="CENTER" valign="BOTTOM">
			<STRONG><LABEL for="BEGINDATE1">Enter a Single Date or <BR />
			a <H4>*Begin Date</H4></LABEL> - <LABEL for="ENDDATE1">End Date Range</LABEL></STRONG><BR />
			<COM><STRONG>(Date Format must be XX/XX/XXXX)</STRONG></COM>
		</TH>
			<TH align="CENTER" valign="BOTTOM">
				<LABEL for="HOURS1"><H4>*## Hours</H4> - Double click box<BR />
				<COM><STRONG>(Maximum 40 Hours per line)</STRONG></COM></LABEL>
			</TH>
		<TH align="CENTER" valign="BOTTOM"><STRONG>
			<LABEL for="BEGINTIME1">Enter a Begin Time </LABEL>- <LABEL for="ENDTIME1">End Time Range </LABEL><BR />
			<STRONG>ONLY</STRONG> if you are using <BR /> less than 8 hours of time.</STRONG><BR />
			<COM><STRONG>(Time Format must be in Military time <BR />Hours & Minutes - 0:00-23:59)</STRONG></COM>
		</TH>
			<TH align="CENTER" valign="BOTTOM">
				<STRONG><LABEL for="DAYS1"><H4>*Day of Week</H4> <BR />
				From - To</LABEL></STRONG> <BR />
				<com>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</com>
			</TH>
	</TR>

	<TR>
		<TD align="CENTER" valign="top">
			<CFINPUT name="BEGINDATE1" id="BEGINDATE1" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINDATE1#" tabindex="8">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE1'});

			</SCRIPT>
			&nbsp;&nbsp;

			<CFINPUT name="ENDDATE1" id="ENDDATE1" size="10" maxlength="15" value="#GetAbsenceRequests.ENDDATE1#" tabindex="9">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE1'});

			</SCRIPT>

		</TD>
		<TD align="CENTER" valign="top">
			<CFINPUT name="HOURS1" id="HOURS1" size="3" maxlength="5" value="#GetAbsenceRequests.HOURS1#" onClick="return(CalcHours1());" tabindex="10"></TD>
		<TD align="CENTER" valign="top">
			<CFINPUT name="BEGINTIME1" id="BEGINTIME1" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINTIME1#" tabindex="11">&nbsp;&nbsp;
			<CFINPUT name="ENDTIME1" id="ENDTIME1" size="10" maxlength="15" value="#GetAbsenceRequests.ENDTIME1#" tabindex="12">
		</TD>
		<TD align="LEFT" valign="top">
			<CFSELECT name="DAYS1ID" id="DAYS1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="#GetAbsenceRequests.DAYS1ID#" tabindex="13"></CFSELECT>
		</TD>
	</TR>

	<TR>
		<TD align="CENTER" valign="top">
			<LABEL for="BEGINDATE2" class="LABEL_hidden">Begin Date 2</LABEL>
			<CFINPUT name="BEGINDATE2" id="BEGINDATE2" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINDATE2#" tabindex="14">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE2'});

			</SCRIPT>
			&nbsp;&nbsp;

			<LABEL for="ENDDATE2" class="LABEL_hidden">End Date 2</LABEL>
			<CFINPUT name="ENDDATE2" id="ENDDATE2" size="10" maxlength="15" value="#GetAbsenceRequests.ENDDATE2#" tabindex="15">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE2'});

			</SCRIPT>

		</TD>
		<TD align="CENTER" valign="top">
			<LABEL for="HOURS2" class="LABEL_hidden">## Hours 2</LABEL>
			<CFINPUT name="HOURS2" id="HOURS2" size="3" maxlength="5" value="#GetAbsenceRequests.HOURS2#" onClick="return(CalcHours2());" tabindex="16">
		</TD>
		<TD align="CENTER" valign="top">
			<LABEL for="BEGINTIME2" class="LABEL_hidden">Begin Time 2</LABEL>
			<CFINPUT name="BEGINTIME2" id="BEGINTIME2" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINTIME2#" tabindex="17">&nbsp;&nbsp;
			<LABEL for="ENDTIME2" class="LABEL_hidden">End Time 2</LABEL>
			<CFINPUT name="ENDTIME2" id="ENDTIME2" size="10" maxlength="15" value="#GetAbsenceRequests.ENDTIME2#" tabindex="18">
		</TD>
		<TD align="LEFT" valign="top">
			<LABEL for="DAYS2" class="LABEL_hidden">Day of Week 2</LABEL>
			<CFSELECT name="DAYS2ID" id="DAYS2" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="#GetAbsenceRequests.DAYS2ID#" required="No" tabindex="19"></CFSELECT>
		</TD>
	</TR>

	<TR>
		<TD align="CENTER" valign="top">
			<LABEL for="BEGINDATE3" class="LABEL_hidden">Begin Date 3</LABEL>
			<CFINPUT name="BEGINDATE3" id="BEGINDATE3" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINDATE3#" tabindex="20">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE3'});

			</SCRIPT>
			&nbsp;&nbsp;

			<LABEL for="ENDDATE3" class="LABEL_hidden">End Date 3</LABEL>
			<CFINPUT name="ENDDATE3" id="ENDDATE3" size="10" maxlength="15" value="#GetAbsenceRequests.ENDDATE3#" tabindex="21">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE3'});

			</SCRIPT>

		</TD>
		<TD align="CENTER" valign="top">
			<LABEL for="HOURS3" class="LABEL_hidden">## Hours 3</LABEL>
			<CFINPUT name="HOURS3" id="HOURS3" size="3" maxlength="5" value="#GetAbsenceRequests.HOURS3#" onClick="return(CalcHours3());" tabindex="22">
		</TD>
		<TD align="CENTER" valign="top">
			<LABEL for="BEGINTIME3" class="LABEL_hidden">Begin Time 3</LABEL>
			<CFINPUT name="BEGINTIME3" id="BEGINTIME3" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINTIME3#" tabindex="23">&nbsp;&nbsp;
			<LABEL for="ENDTIME3" class="LABEL_hidden">End Time 1</LABEL>
			<CFINPUT name="ENDTIME3" id="ENDTIME3" size="10" maxlength="15" value="#GetAbsenceRequests.ENDTIME3#" tabindex="24">
		</TD>
		<TD align="LEFT" valign="top">
			<LABEL for="DAYS3" class="LABEL_hidden">Day of Week 3</LABEL>
			<CFSELECT name="DAYS3ID" id="DAYS3" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="#GetAbsenceRequests.DAYS3ID#" required="No" tabindex="25"></CFSELECT>
		</TD>
	</TR>

	<TR>
		<TD align="CENTER" valign="top">
			<LABEL for="BEGINDATE4" class="LABEL_hidden">Begin Date 4</LABEL>
			<CFINPUT name="BEGINDATE4" id="BEGINDATE4" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINDATE4#" tabindex="26">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'BEGINDATE1'});

			</SCRIPT>
			&nbsp;&nbsp;

			<LABEL for="ENDDATE4" class="LABEL_hidden">End Date 4</LABEL>
			<CFINPUT name="ENDDATE4" id="ENDDATE4" size="10" maxlength="15" value="#GetAbsenceRequests.ENDDATE4#" tabindex="27">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'ABSENCEREQUESTS','controlname': 'ENDDATE4'});

			</SCRIPT>

		</TD>
		<TD align="CENTER" valign="top">
			<LABEL for="HOURS4" class="LABEL_hidden">## Hours 4</LABEL>
			<CFINPUT name="HOURS4" id="HOURS4" size="3" maxlength="5" value="#GetAbsenceRequests.HOURS4#" onClick="return(CalcHours4());" tabindex="28">
		</TD>
		<TD align="CENTER" valign="top">
			<LABEL for="BEGINTIME4" class="LABEL_hidden">Begin Time 4</LABEL>
			<CFINPUT name="BEGINTIME4" id="BEGINTIME4" size="10" maxlength="15" value="#GetAbsenceRequests.BEGINTIME4#" tabindex="29">&nbsp;&nbsp;
			<LABEL for="ENDTIME4" class="LABEL_hidden">End Time 4</LABEL>
			<CFINPUT name="ENDTIME4" id="ENDTIME4" size="10" maxlength="15" value="#GetAbsenceRequests.ENDTIME4#" tabindex="30">
		</TD>
		<TD align="LEFT" valign="top">
			<LABEL for="DAYS4" class="LABEL_hidden">Day of Week 4</LABEL>
			<CFSELECT name="DAYS4ID" id="DAYS4" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" selected="#GetAbsenceRequests.DAYS4ID#" required="No" tabindex="31"></CFSELECT>
		</TD>
	</TR>
</TABLE>
</FIELDSET>
<BR />
<FIELDSET>
<LEGEND>Request Use Of Hours for Absence Type</LEGEND>
<TABLE border="0" width="100%">
	<TR>
		<TD align="LEFT" valign="BOTTOM" colspan="4" >
			<BR /><com>Fill in number of hours: - (<H4> *At least one box must be filled in</H4>)</com>
		</TD>
	</TR>
	<TR>
		<TH align="LEFT"><LABEL for="VACATION">Vacation</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="VACATION" id="VACATION" size="3" maxlength="5" value="#GetAbsenceRequests.VACATION#" tabindex="32"></TD>
		<TH align="LEFT"><LABEL for="PERSONALHOLIDAY">Personal Holiday</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="PERSONALHOLIDAY" id="PERSONALHOLIDAY" size="3" maxlength="5" value="#GetAbsenceRequests.PERSONALHOLIDAY#" tabindex="33"></TD>
	</TR>

	<TR>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
	</TR>

	<TR>
		<TH align="LEFT"><LABEL for="COMPTIME">Compensatory Time Off</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="COMPTIME" id="COMPTIME" size="3" maxlength="5" value="#GetAbsenceRequests.COMPTIME#" tabindex="34"></TD>
		<TH align="LEFT"><LABEL for="FMLA">Family Medical Leave Act</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="FMLA" id="FMLA" size="3" maxlength="5" value="#GetAbsenceRequests.FMLA#" tabindex="35"></TD>
	</TR>

	<TR>
		<TH align="LEFT"><LABEL for="FUNERAL">Funeral Leave*</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="FUNERAL" id="FUNERAL" size="3" maxlength="5" value="#GetAbsenceRequests.FUNERAL#" tabindex="36"></TD>
		<TH align="LEFT"><LABEL for="OTHER">Other</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="OTHER" id="OTHER" size="3" maxlength="5" value="#GetAbsenceRequests.OTHER#" tabindex="37"></TD>
	</TR>

	<TR>
		<TH align="LEFT"><LABEL for="GTO">Holiday Informal Time - GTO</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="GTO" id="GTO" size="3" maxlength="5" value="#GetAbsenceRequests.GTO#" tabindex="38"></TD>
		<TH align="LEFT"><LABEL for="JURYDUTY">Jury Duty</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="JURYDUTY" id="JURYDUTY" size="3" maxlength="5" value="#GetAbsenceRequests.JURYDUTY#" tabindex="39"></TD>
	</TR>

	<TR>
		<TH align="LEFT"><H4><LABEL for="LWOP">LWOP</LABEL></H4></TH>
		<TD align="LEFT"><CFINPUT name="LWOP" id="LWOP" size="3" maxlength="5" value="#GetAbsenceRequests.LWOP#" tabindex="40"></TD>
		<TH align="LEFT"><LABEL for="MATPAT">Maternity/Paternity Leave</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="MATPAT" id="MATPAT" size="3" maxlength="5" value="#GetAbsenceRequests.MATPAT#" tabindex="41"></TD>
	</TR>

	<TR>
		<TH align="LEFT"><LABEL for="MILITARY">Military Leave</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="MILITARY" id="MILITARY" size="3" maxlength="5" value="#GetAbsenceRequests.MILITARY#" tabindex="42"></TD>
		<TH align="LEFT"><LABEL for="SICKFAMILY">Sick Leave Family*</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="SICKFAMILY" id="SICKFAMILY" size="3" maxlength="5" value="#GetAbsenceRequests.SICKFAMILY#" tabindex="43"></TD>
	</TR>

	<TR>
		<TH align="LEFT"><LABEL for="SICKSELF">Sick Leave Self</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="SICKSELF" id="SICKSELF" size="3" maxlength="5" value="#GetAbsenceRequests.SICKSELF#" tabindex="44"></TD>
		<TH align="LEFT"><LABEL for="WITNESS">Subpoena Witness</LABEL></TH>
		<TD align="LEFT"><CFINPUT name="WITNESS" id="WITNESS" size="3" maxlength="5" value="#GetAbsenceRequests.WITNESS#" tabindex="45"></TD>
	</TR>
</TABLE>
</FIELDSET>
<BR />
<FIELDSET>
<LEGEND>Explanations</LEGEND>
<TABLE border="0" width="100%">
	<TR>
		<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TH align="LEFT">
			<LABEL for="RELATIONSHIP">*Give Relationship</LABEL>
		</TH>
		<TH align="LEFT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
		<TH align="LEFT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
		<TH align="CENTER">
			<LABEL for="REASON">REASON FOR ABSENCE (Sick Leave / <H4>LWOP</H4>):</LABEL>
		</TH>
	</TR>
	<TR>
		<TD align="LEFT" valign="TOP">
			<CFINPUT name="RELATIONSHIP" id="RELATIONSHIP" size="15" maxlength=25 value="#GetAbsenceRequests.RELATIONSHIP#" tabindex="46">
		</TD>
		<TD align="LEFT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
		<TD align="LEFT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
		<TD align="CENTER">
			<TEXTAREA name="REASON" id="REASON" wrap=HARD rows="3" cols="50" tabindex="47">#GetAbsenceRequests.REASON#</TEXTAREA>
		</TD>
	</TR>
</TABLE>
</FIELDSET>
<BR />
<FIELDSET>
<LEGEND>Approval</LEGEND>
<TABLE border="0" width="100%">
	<TR>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TH align="LEFT"><STRONG><LABEL for="REQUESTSTATUSID">Request Status</LABEL></STRONG></TH>
		<TH align="LEFT"><STRONG><LABEL for="APPROVEDBYSUPID">Approval Supervisor's Name</LABEL></STRONG></TH>
		<TH align="LEFT"><STRONG><LABEL for="SUPAPPROVALDATE">Approval Date</LABEL></STRONG></TH>
	</TR>
	<TR>
		<TD align="LEFT">
		<CFIF #GetAbsenceRequests.REQUESTSTATUSID# EQ 4>
			<CFSELECT name="REQUESTSTATUSID" id="REQUESTSTATUSID" size="1" query="ListRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" selected="1" tabindex="48"></CFSELECT>
		<CFELSE>
			<CFSELECT name="REQUESTSTATUSID" id="REQUESTSTATUSID" size="1" query="ListRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" selected="#GetAbsenceRequests.REQUESTSTATUSID#" tabindex="48"></CFSELECT>
		</CFIF>
		</TD>
		<TD align="LEFT">
	<CFIF #GetAbsenceRequests.APPROVEDBYSUPID# EQ 0>
			<CFSELECT name="APPROVEDBYSUPID" id="APPROVEDBYSUPID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="FULLNAME" selected="#val(Client.CUSTOMERID)#" required="No" tabindex="49"></CFSELECT>
	<CFELSE>
			<CFSELECT name="APPROVEDBYSUPID" id="APPROVEDBYSUPID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="FULLNAME" selected="#GetAbsenceRequests.APPROVEDBYSUPID#" required="No" tabindex="49"></CFSELECT>
	</CFIF>
		</TD>
		<TD align="left" valign ="TOP">
	<CFIF #GetAbsenceRequests.SUPAPPROVALDATE# EQ "">
			<CFINPUT type="Text" name="SUPAPPROVALDATE" id="SUPAPPROVALDATE" value="#DateFormat(NOW(), 'mm/dd/yyyy')#" align="LEFT" required="No" size="10" tabindex="50">
	<CFELSE>
			#DateFormat(GetAbsenceRequests.SUPAPPROVALDATE, 'mm/dd/yyyy')#
	</CFIF>
		</TD>
	</TR>
</TABLE>
<TABLE border="0" width="40%">
     <TR>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
		<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" width="20%">
          	<INPUT type="hidden" name="PROCESSABSENCEREQUESTS" value="Approve/Cancel/Deny Request" />
			<INPUT type="image" src="/images/buttonApproveDeny.jpg" value="Approve/Cancel/Deny Request" alt="Approve/Cancel/Deny Request" tabindex="51" /> 
		</TD>
          <TD align="left" valign="top" colspan="2">
          	&nbsp;&nbsp;<com><--- Loops for multiple records</com>
		</TD>
	</TR>
</TABLE>
</FIELDSET>
</CFFORM>
<TABLE border="0" width="40%">
<CFIF NOT IsDefined('URL.ABSENCEID')>
	<CFFORM action="/#application.type#apps/webreports/processabsencerequest.cfm" method="POST" ENABLECAB="Yes">
	<TR>
		<TD align="left" valign="top" width="20%">
			<INPUT type="hidden" name="PROCESSABSENCEREQUESTS" value="NEXT RECORD" />
          	<INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXT RECORD" alt="Next Record" tabindex="52" />
		</TD>
          <TD align="left" valign="top" >
          	&nbsp;&nbsp;<com><--- No change including Modified Date Field</com>
		</TD>
	</TR>
	</CFFORM>
</CFIF>
<CFIF IsDefined('URL.ABSENCEID')>
	<TR>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TD align="left">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="53" />
		</TD>
          <TD align="LEFT">&nbsp;&nbsp;</TD>
	</TR>
<CFELSE>
	<TR>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
		<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TD align="LEFT" colspan="2">
	<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel"  tabindex="54" /><BR>
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
	</CFFORM>
		</TD>
	</TR>
</CFIF>
</TABLE>
<P>Clicking the <STRONG>Approve/Cancel/Deny Request</STRONG> button will forward this electronic request to your
supervisor and return the approval to the requester via email.
</P>

<P><STRONG>All approved requests for LWOP (Leave Without Pay)</STRONG> need to be copied to Library Payroll
 in order to avoid having a hold placed on your paycheck.  Please direct all questions about this
 form or any payroll issue to Joan Shelby (x41642 or <A href="mailto:jshelby@mail.sdsu.edu">jshelby@mail.sdsu.edu</A>.)
</P>

<P>Information regarding vacations and leaves can be found at 
<A href="http://www.calstate.edu/LaborRel/Contracts_HTML/contracts.shtml">
Contract Information</A>

<CFINCLUDE template="/include/coldfusion/footer.cfm">

</CFOUTPUT>

</BODY>
</HTML>