<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: keyrequestsreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date: 01/27/2008 --->
<!--- Date in Production: 01/27/2008 --->
<!--- Module: Facilities Key Card Requests Report--->
<!-- Last modified by John R. Pastori on 01/27/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/keyrequestsreport.cfm">
<CFSET CONTENT_UPDATED = "January 27, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities Key Card Requests Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<A href="/"><IMG src="/images/bigheader.jpg" width="279" height="63" alt="LFOLKSTEST" align="left" VALIGN="top"></A>
<BR><BR><BR><BR><BR>

<CFINCLUDE template="/include/coldfusion/navbar1.cfm">
<CFQUERY name="ListKeyRequests" datasource="#application.type#FACILITIES" blockfactor="100">
SELECT	
		KR.KEYREQUESTID,
		KR.KEYREQUESTWOID,
		WO.WORKORDERNUMBER,
		KR.KEYTYPEID,
		KT.KEYTYPENAME,
		REQCUST.FULLNAME AS REQUESTOR,
		LOC.ROOMNUMBER,
		KR.KEYNUMBER,
		KR.HOOKNUMBER,
		KR.DOORSACCESSED,
		KR.DAYSACCESSED,
		KR.OTHERDAYS,
		KR.TIMESACCESSED,
		KR.OTHERWEEKDAYTIMESFROM,
		KR.OTHERWEEKDAYTIMESTHRU,
		KR.OTHERWEEKENDTIMESFROM,
		KR.OTHERWEEKENDTIMESTHRU,
		KR.ACCESSENDDATE,
		KR.DISPOSITION,
		KR.NUMBERREPLACED,
		KR.REPLACEDREASON,
		WO.APPROVEDBYSUPID,
		SUPVRCUST.FULLNAME AS SUPVRNAME,
		WO.SUPAPPROVALDATE,
		KR.RECEIVEDBYCUSTOMER,
		KR.RECEIVEDBYDATE,
		WO.APPROVEDBYMGMTID,
		MGMTCUST.FULLNAME AS MGMTNAME,
		WO.MGMTAPPROVALDATE
FROM		KEYREQUESTS KR, WORKORDERS WO, KEYTYPES KT, LIBSHAREDDATAMGR.CUSTOMERS REQCUST,
		LIBSHAREDDATAMGR.CUSTOMERS SUPVRCUST, LIBSHAREDDATAMGR.CUSTOMERS MGMTCUST, LOCATIONS LOC
WHERE	KR.KEYREQUESTID > 0 AND
		KR.KEYREQUESTWOID = WO.WORKORDERID AND
		KR.KEYTYPEID = KT.KEYTYPEID AND
		WO.REQUESTERID = REQCUST.CUSTOMERID AND
		WO.LOCATIONID = LOC.LOCATIONID AND 
		WO.APPROVEDBYSUPID = SUPVRCUST.CUSTOMERID AND
		WO.APPROVEDBYMGMTID = MGMTCUST.CUSTOMERID
ORDER BY	WO.WORKORDERNUMBER
</CFQUERY>

<CFOUTPUT>
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD  align="center"><H1><STRONG>Facilities Key Card Requests Report</STRONG></H1></TD>
	</TR>
</TABLE>
<TABLE border="0">
	<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
		<TD align="left"><INPUT type="submit" value="Cancel" tabindex="1"></TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="12"><H2>#ListKeyRequests.RecordCount# Request Type records were selected.<H2></TH>
	</TR>
<CFLOOP query="ListKeyRequests">
	<TR>
		<TH><DIV align="center">WO Number</DIV></TH>
		<TH><DIV align="center">Key Type</DIV></TH>
		<TH><DIV align="center">Requester Name</DIV></TH>
		<TH><DIV align="center">Room Number</DIV></TH>
		<TH><DIV align="center">Key Number</DIV></TH>
		<TH><DIV align="center">Hook Number</DIV></TH>
		<TH><DIV align="center">Doors Accessed</DIV></TH>
		<TH><DIV align="center">Disposition</DIV></TH>
		<TH><DIV align="center">Number Replaced</DIV></TH>
		<TH><DIV align="center">Replaced Reason</DIV></TH>
		<TH><DIV align="center">Received By Customer</DIV></TH>
		<TH><DIV align="center">Received By Date</DIV></TH>
	</TR>
	<TR>
		<TD><DIV align="center"><STRONG>#WORKORDERNUMBER#</STRONG></DIV></TD>
		<TD><DIV align="center">#KEYTYPENAME#</DIV></TD>
		<TD><DIV align="center">#REQUESTOR#</DIV></TD>
		<TD><DIV align="center">#ROOMNUMBER#</DIV></TD>
		<TD><DIV align="center">#KEYNUMBER#</DIV></TD>
		<TD><DIV align="center">#HOOKNUMBER#</DIV></TD>
		<TD><DIV align="center">#DOORSACCESSED#</DIV></TD>
		<TD><DIV align="center">#DISPOSITION#</DIV></TD>
		<TD><DIV align="center">#NUMBERREPLACED#</DIV></TD>
		<TD><DIV align="center">#REPLACEDREASON#</DIV></TD>
		<TD><DIV align="center">#RECEIVEDBYCUSTOMER#</DIV></TD>
		<TD><DIV align="center">#DateFormat(RECEIVEDBYDATE, "MM/DD/YYYY")#</DIV></TD>
	</TR>
	<TR>
		<TH><DIV align="center">Days Accessed</DIV></TH>
		<TH><DIV align="center">Days Other</DIV></TH>
		<TH><DIV align="center">Times Accessed</DIV></TH>
		<TH><DIV align="center">Other Weekday Times From</DIV></TH>
		<TH><DIV align="center">Other Weekday Times Thru</DIV></TH>
		<TH><DIV align="center">Other WeekEnd Times From</DIV></TH>
		<TH><DIV align="center">Other Weekend Times Thru</DIV></TH>
		<TH><DIV align="center">Access End Date</DIV></TH>
		<TH><DIV align="center">Supervisor</DIV></TH>
		<TH><DIV align="center">Supervisor Approval Date</DIV></TH>
		<TH><DIV align="center">Management Approval</DIV></TH>
		<TH><DIV align="center">Management Approval Date</DIV></TH>
	</TR>
	<TR>
		<TD><DIV align="center">#DAYSACCESSED#</DIV></TD>
		<TD><DIV align="center">#OTHERDAYS#</DIV></TD>
		<TD><DIV align="center">#TIMESACCESSED#</DIV></TD>
		<TD><DIV align="center">#TimeFormat(OTHERWEEKDAYTIMESFROM, "HH:mm:ss")#</DIV></TD>
		<TD><DIV align="center">#TimeFormat(OTHERWEEKDAYTIMESTHRU, "HH:mm:ss")#</DIV></TD>
		<TD><DIV align="center">#TimeFormat(OTHERWEEKENDTIMESFROM, "HH:mm:ss")#</DIV></TD>
		<TD><DIV align="center">#TimeFormat(OTHERWEEKENDTIMESTHRU, "HH:mm:ss")#</DIV></TD>
	<CFIF YEAR(ACCESSENDDATE) EQ '9999'>
		<TD><DIV align="center">INDEFINITE</DIV></TD>
	<CFELSE>
		<TD><DIV align="center">#DateFormat(ACCESSENDDATE, "MM/DD/YYYY")#</DIV></TD>
	</CFIF>
	<CFIF APPROVEDBYSUPID GT 0>
		<TD><DIV align="center">#SUPVRNAME#</DIV></TD>
	<CFELSE>
		<TD><DIV align="left">&nbsp;</DIV></TD>
	</CFIF>
		<TD><DIV align="center">#DateFormat(SUPAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
	<CFIF APPROVEDBYMGMTID GT 0>
		<TD><DIV align="center">#MGMTNAME#</DIV></TD>
	<CFELSE>
		<TD><DIV align="left">&nbsp;</DIV></TD>
	</CFIF>
		<TD><DIV align="center">#DateFormat(MGMTAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
	</TR>
	<TR>
		<TD colspan="12"><HR width="100%"></TD>
	</TR>

</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="12"><H2>#ListKeyRequests.RecordCount# Request Type records were selected.<H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm" method="POST">
			<TD align="center" colspan="12"><INPUT type="submit" value="Cancel" tabindex="1"></TD>
</CFFORM>
	</TR>
</TABLE>
<CFINCLUDE template="/include/coldfusion/footer.cfm">
</CFOUTPUT>
</BODY>
</HTML>