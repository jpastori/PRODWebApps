<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: wokeyrequestsreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012 --->
<!--- Module: Facilities - Work Requests - Key/Card Requests Report --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/wokeyrequestsreport.cfm">
<CFSET CONTENT_UPDATED = "February 10, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Work Requests - Key/Card Requests Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<CFOUTPUT>
<CFSET KEYCOUNT = 0>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Facilities - Work Requests - Key/Card Requests Report</H1></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/workrequestreports.cfm?PROCESS=REPORT" method="POST">
			<TD align="left"><INPUT type="submit" value="Cancel" tabindex="1"></TD>
</CFFORM>
		</TR>

<CFLOOP query="ListWorkRequests">
	<CFQUERY name="ListKeyRequestInfo" datasource="#application.type#FACILITIES">
		SELECT	KR.KEYREQUESTID, KR.KEYREQUESTWRID, KR.KEYTYPEID, KT.KEYTYPENAME, KR.KEYNUMBER, KR.HOOKNUMBER, KR.DISPOSITION, KR.DOORSACCESSED,
				KR.DAYSACCESSED, KR.TIMESACCESSED, KR.OTHERDAYS, TO_CHAR(KR.OTHERWEEKDAYTIMESFROM, 'HH24:MI:SS') AS OTHERWEEKDAYTIMESFROM,
				TO_CHAR(KR.OTHERWEEKDAYTIMESTHRU, 'HH24:MI:SS') AS OTHERWEEKDAYTIMESTHRU,
				TO_CHAR(KR.OTHERWEEKENDTIMESFROM, 'HH24:MI:SS') AS OTHERWEEKENDTIMESFROM,
				TO_CHAR(KR.OTHERWEEKENDTIMESTHRU, 'HH24:MI:SS') AS OTHERWEEKENDTIMESTHRU,
				TO_CHAR(KR.ACCESSENDDATE, 'MM/DD/YYYY')AS ACCESSENDDATE, KR.NUMBERREPLACED, KR.REPLACEDREASON, KR.RECEIVEDBYCUSTOMER, KR.RECEIVEDBYDATE
		FROM		KEYREQUESTS KR, KEYTYPES KT
		WHERE	((KR.KEYREQUESTWRID = <CFQUERYPARAM value="#ListWorkRequests.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				KR.KEYTYPEID = KT.KEYTYPEID) AND 
				(
			<CFIF #FORM.KEYTYPEID# GT 0>
			<CFIF IsDefined("FORM.NEGATEKEYTYPEID")>
				NOT KR.KEYTYPEID = #val(FORM.KEYTYPEID)# #LOGICANDOR#
			<CFELSE>
				KR.KEYTYPEID = #val(FORM.KEYTYPEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
				KR.KEYREQUESTWRID #FINALTEST# '0'))
		ORDER BY	KR.KEYREQUESTWRID, KR.KEYREQUESTID
	</CFQUERY>

<CFIF #ListKeyRequestInfo.RecordCount# GT 0>	
		<TR>
			<TH align="left" valign="TOP" colspan="2">Work Request Number</TH>
			<TH align="center" valign="TOP">Request Date</TH>
			<TH align="center" valign="TOP" colspan="3">Request Type</TH>
			<TH align="center" valign="TOP" colspan="2">Request Status</TH>
			<TH align="center" valign="TOP" colspan="2">Requester Name</TH>
			<TH align="center" valign="TOP" colspan="2">Unit Name</TH>
			<TH align="center" valign="TOP">Room Number</TH>
<!--- 
			<TH align="center" valign="TOP" colspan="2">Unit Head <BR> Approval Date</TH>
 --->
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2"><DIV>#ListWorkRequests.WORKREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListWorkRequests.REQUESTDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="center" valign="TOP" colspan="3"><DIV>#ListWorkRequests.REQUESTTYPENAME#</DIV></TD>
			<TD align="left" valign="TOP" colspan="2"><DIV>#ListWorkRequests.REQUESTSTATUSNAME#</DIV></TD>
			<TD align="left" valign="TOP" colspan="2"><DIV>#ListWorkRequests.RCNAME#</DIV></TD>
			<TD align="center" valign="TOP" colspan="2"><DIV>#ListWorkRequests.UNITNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.ROOMNUMBER#</DIV></TD>
<!--- 
			<TD align="center" valign="TOP" colspan="2"><DIV>#DateFormat(ListWorkRequests.SUPAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
 --->
 		</TR>
		<TR>
			<TH align="left" valign="BOTTOM">Key Type</TH>
			<TH align="center" valign="BOTTOM">Key Number</TH>
			<TH align="center" valign="BOTTOM">Key Number Replaced</TH>
			<TH align="center" valign="BOTTOM">Hook Number</TH>
			<TH align="center" valign="BOTTOM">Disposition</TH>
			<TH align="center" valign="BOTTOM">Doors Accessed</TH>
			<TH align="center" valign="BOTTOM">Days Accessed</TH>
			<TH align="center" valign="BOTTOM">Times Accessed</TH>
			<TH align="center" valign="BOTTOM">Replaced Reason</TH>
			<TH align="center" valign="BOTTOM">Other Days</TH>
			<TH align="center" valign="BOTTOM">Other WeekDay Hours From</TH>
			<TH align="center" valign="BOTTOM">Other WeekDay Hours Thru</TH>
			<TH align="center" valign="BOTTOM">Other WeekEnd Hours From</TH>
			<TH align="center" valign="BOTTOM">Other WeekEnd Hours Thru</TH>
			<TH align="center" valign="BOTTOM">Access End Date</TH>
			<TH align="center" valign="BOTTOM">Received By Customer?</TH>
			<TH align="center" valign="BOTTOM">Received By Date</TH>
		</TR>

		<CFLOOP query="ListKeyRequestInfo">
		<CFSET KEYCOUNT = KEYCOUNT + 1>
		<TR>
			<TD align="left" valign="TOP"><DIV>#ListKeyRequestInfo.KEYTYPENAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListKeyRequestInfo.KEYNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListKeyRequestInfo.NUMBERREPLACED#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListKeyRequestInfo.HOOKNUMBER#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListKeyRequestInfo.DISPOSITION#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListKeyRequestInfo.DOORSACCESSED#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListKeyRequestInfo.DAYSACCESSED#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListKeyRequestInfo.TIMESACCESSED#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#ListKeyRequestInfo.REPLACEDREASON#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#ListKeyRequestInfo.OTHERDAYS#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListKeyRequestInfo.OTHERWEEKDAYTIMESFROM#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListKeyRequestInfo.OTHERWEEKDAYTIMESTHRU#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListKeyRequestInfo.OTHERWEEKENDTIMESFROM#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListKeyRequestInfo.OTHERWEEKENDTIMESTHRU#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListKeyRequestInfo.ACCESSENDDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListKeyRequestInfo.RECEIVEDBYCUSTOMER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListKeyRequestInfo.RECEIVEDBYDATE, "MM/DD/YYYY")#</DIV></TD>
		</TR>
		</CFLOOP>
		<TR>
			<TD colspan="18"><HR width="100%" size="5" noshade></TD>
		</TR>
</CFIF>
</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="18"><H2>#KEYCOUNT# Work Request Key/Card Request Records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/workrequestreports.cfm?PROCESS=REPORT" method="POST">
			<TD align="left"><INPUT type="submit" value="Cancel" tabindex="2"></TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="22"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFOUTPUT>
</BODY>
</HTML>