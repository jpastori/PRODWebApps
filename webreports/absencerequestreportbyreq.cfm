<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: absencerequestreportbyreq.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Process Information to Web Reports - Absence Request Report By Requester --->
<!--- Last modified by John R. Pastori on 06/14/2013 using ColdFusion Studio. --->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/absencerequestreportbyreq.cfm">
<CFSET CONTENT_UPDATED = "June 14, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Absence Request Report By Requester</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JavaScript1.1>
	window.defaultStatus = "Welcome to Web Reports - Absence Request Report By Requester";

	function alertuser(alertMsg) {
		alert(alertMsg);
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
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPABSENCEREQUESTS')>
	<CFSET CURSORFIELD = "document.LOOKUP.ABSENCEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
********************************************************************************************************
* The following code is the Look Up Process for the Web Reports - Absence Request Report By Requester. *
********************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPABSENCEREQUESTS')> 

	<CFQUERY name="LookupAbsenceRequests" datasource="#application.type#WEBREPORTS" blockfactor="100">
		SELECT	A.ABSENCEID, TO_CHAR(A.SUBMITDATE, 'YYYY/MM/DD') AS SUBMITDATE, A.REQUESTERID, CUST.FULLNAME, A.REQUESTEREMAIL,
				A.SUPERVISOREMAILID, A.CC2, A.CARBON, A.BEGINDATE1, A.ENDDATE1, A.BEGINDATE2, A.ENDDATE2, A.BEGINDATE3, A.ENDDATE3,
				A.BEGINDATE4, A.ENDDATE4, A.HOURS1, A.HOURS2, A.HOURS3, A.HOURS4, A.BEGINTIME1, A.ENDTIME1, A.BEGINTIME2, A.ENDTIME2,
				A.BEGINTIME3, A.ENDTIME3, A.BEGINTIME4, A.ENDTIME4, A.DAYS1ID, A.DAYS2ID, A.DAYS3ID, A.DAYS4ID, A.VACATION,
				A.PERSONALHOLIDAY, A.COMPTIME, A.FMLA, A.FUNERAL, A.GTO, A.JURYDUTY, A.LWOP, A.MATPAT, A.MILITARY, A.OTHER, A.SICKFAMILY,
				A.SICKSELF,A.WITNESS, A.RELATIONSHIP, A.REASON
		FROM		ABSENCEREQUESTS A, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(A.REQUESTERID = CUST.CUSTOMERID) AND 
				(A.ABSENCEID = 0 OR
				A.REQUESTERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC">)
		ORDER BY	SUBMITDATE DESC, CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="LEFT">
			<TH align="center"><H1>Lookup Report Information to Web Reports - Absence Request Report By Requester</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="left">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/absencerequestreportbyreq.cfm?LOOKUPABSENCEREQUESTS=FOUND" method="POST">
		<TR>
			<TD align="LEFT" valign="bottom">
				<H4><LABEL for="ABSENCEID">*Submit Date:</LABEL></H4>
			</TD>
          </TR>
		<TR>
			<TD align="LEFT">
				<CFSELECT name="ABSENCEID" id="ABSENCEID" size="1" query="LookupAbsenceRequests" value="ABSENCEID" display="SUBMITDATE" required="No" tabindex="2"></CFSELECT>
               <BR>
			<COM>(Please select a date other than 9999/12/31.)</COM>
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
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="left">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="3">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
******************************************************************************************************************
* The following code is the Report Generation Process for the Web Reports - Absence Request Report By Requester. *
******************************************************************************************************************
 --->

	<CFSET FORM.CC = "">
	<CFQUERY name="LookupAbsenceRequests" datasource="#application.type#WEBREPORTS">
		SELECT	A.ABSENCEID, A.SUBMITDATE, A.REQUESTERID, CUST.FULLNAME, CUST.EMAIL AS REQEMAIL, A.REQUESTEREMAIL, A.SUPERVISOREMAILID,
				SUPVR.EMAIL AS SUPVREMAIL, SUPVR.FULLNAME AS SUPVRNAME, A.CC2, A.CARBON, TO_CHAR(A.BEGINDATE1, 'MM/DD/YYYY') AS BEGINDATE1,
				TO_CHAR(A.ENDDATE1, 'MM/DD/YYYY') AS ENDDATE1, TO_CHAR(A.BEGINDATE2, 'MM/DD/YYYY') AS BEGINDATE2,
				TO_CHAR(A.ENDDATE2, 'MM/DD/YYYY') AS ENDDATE2, TO_CHAR(A.BEGINDATE3, 'MM/DD/YYYY') AS BEGINDATE3,
				TO_CHAR(A.ENDDATE3, 'MM/DD/YYYY') AS ENDDATE3, TO_CHAR(A.BEGINDATE4, 'MM/DD/YYYY') AS BEGINDATE4,
				TO_CHAR(A.ENDDATE4, 'MM/DD/YYYY') AS ENDDATE4, A.HOURS1, A.HOURS2, A.HOURS3, A.HOURS4,
				TO_CHAR(A.BEGINTIME1, 'HH24:MI') AS BEGINTIME1, TO_CHAR(A.ENDTIME1, 'HH24:MI') AS ENDTIME1,
				TO_CHAR(A.BEGINTIME2, 'HH24:MI') AS BEGINTIME2, TO_CHAR(A.ENDTIME2, 'HH24:MI') AS ENDTIME2,
				TO_CHAR(A.BEGINTIME3, 'HH24:MI') AS BEGINTIME3, TO_CHAR(A.ENDTIME3, 'HH24:MI') AS ENDTIME3,
				TO_CHAR(A.BEGINTIME4, 'HH24:MI') AS BEGINTIME4, TO_CHAR(A.ENDTIME4, 'HH24:MI') AS ENDTIME4,
				A.DAYS1ID, A.DAYS2ID, A.DAYS3ID, A.DAYS4ID, A.VACATION, A.PERSONALHOLIDAY, A.COMPTIME, A.FMLA, A.FUNERAL,
				A.GTO, A.JURYDUTY, A.LWOP, A.MATPAT, A.MILITARY, A.OTHER, A.SICKFAMILY, A.SICKSELF,A.WITNESS, A.RELATIONSHIP, A.REASON,
				A.REQUESTSTATUSID, RS.REQUESTSTATUSNAME, A.APPROVEDBYSUPID, A.SUPAPPROVALDATE
		FROM		ABSENCEREQUESTS A, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CUSTOMERS SUPVR, REQUESTSTATUS RS
		WHERE	ABSENCEID = <CFQUERYPARAM value="#FORM.ABSENCEID#" cfsqltype="CF_SQL_NUMERIC"> AND
				A.REQUESTERID = CUST.CUSTOMERID AND
				A.SUPERVISOREMAILID = SUPVR.CUSTOMERID AND
				A.REQUESTSTATUSID = RS.REQUESTSTATUSID
		ORDER BY	A.SUBMITDATE DESC
	</CFQUERY>
	
	<CFIF #LookupAbsenceRequests.SUPERVISOREMAILID# EQ 57>
		<CFIF #LookupAbsenceRequests.CARBON# NEQ "">
			<CFSET FORM.CC = "jshelby@mail.sdsu.edu, #LookupAbsenceRequests.REQEMAIL#">
		<CFELSE>
			<CFSET FORM.CC = "jshelby@mail.sdsu.edu">
		</CFIF>
	<CFELSEIF #LookupAbsenceRequests.CARBON# NEQ "">
		<CFSET FORM.CC = "#LookupAbsenceRequests.REQEMAIL#">
	</CFIF>
     <TABLE width="100%" align="center" border="3">
		<TR align="LEFT">
			<TH align="center"><H1>Absence Request Report By Requester</H1></TH>
		</TR>
	</TABLE>
	<TABLE align="left" border="0"> 
		<TR>
<CFFORM action="/#application.type#apps/webreports/absencerequestreportbyreq.cfm" method="POST">
			<TD align="left">
               	<BR /><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
          	<TD align="left">
                    <BR />
                    <HR />
                    <CFINCLUDE template = "absencerequestreport.cfm">
                    <HR />
                    <BR /><BR />
               </TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/webreports/absencerequestreportbyreq.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="3">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
      
</CFIF>
  
</BODY> 
</CFOUTPUT>
</HTML>