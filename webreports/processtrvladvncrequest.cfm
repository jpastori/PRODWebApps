<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processtrvladvncrequest.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Travel Advance Request--->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Travel Advance Request</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSTRVLADVNCREQUESTS EQ "ADD" OR FORM.PROCESSTRVLADVNCREQUESTS EQ "MODIFY" OR FORM.PROCESSTRVLADVNCREQUESTS EQ "Approve/Cancel/Deny Request">

	<CFOUTPUT>

		<CFSET FORM.TRAVELBEGINDATE = DateFormat(FORM.TRAVELBEGINDATE, 'DD-MMM-YYYY')>
	
		<CFIF IsDefined('FORM.TRAVELENDDATE') AND FORM.TRAVELENDDATE IS NOT "">
			<CFSET FORM.TRAVELENDDATE = DateFormat(FORM.TRAVELENDDATE, 'DD-MMM-YYYY')>
		</CFIF>
	
		<CFIF IsDefined('FORM.CHECKISSUEDATE') AND FORM.CHECKISSUEDATE IS NOT "">
			<CFSET FORM.CHECKISSUEDATE = DateFormat(FORM.CHECKISSUEDATE, 'DD-MMM-YYYY')>
		</CFIF>
		
		<CFIF IsDefined('FORM.SUPAPPROVALDATE') AND FORM.SUPAPPROVALDATE IS NOT "">
			<CFSET FORM.SUPAPPROVALDATE = DateFormat(FORM.SUPAPPROVALDATE, 'DD-MMM-YYYY')>
		</CFIF>
	
		<CFTRANSACTION action="begin">
		<CFQUERY name="ModifyTrvlAdvncRequests" datasource="#application.type#WEBREPORTS">
			UPDATE	TRVLADVNCREQUESTS
			SET		CHECKAMOUNT = #val(FORM.CHECKAMOUNT)#,
				<CFIF FORM.PROCESSTRVLADVNCREQUESTS EQ "MODIFY">
					PAYEEID = #val(FORM.PAYEEID)#,
					FISCALYEARID = #val(FORM.FISCALYEARID)#,
				</CFIF>
					TRAVELBEGINDATE = TO_DATE('#FORM.TRAVELBEGINDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				<CFIF IsDefined('FORM.TRAVELENDDATE') AND FORM.TRAVELENDDATE IS NOT "">
					TRAVELENDDATE = TO_DATE('#FORM.TRAVELENDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				</CFIF>
					DESTINATION = UPPER('#FORM.DESTINATION#'),
				<CFIF IsDefined('FORM.REVFUNDCHECKNUM') AND FORM.REVFUNDCHECKNUM IS NOT "">
					REVFUNDCHECKNUM = '#FORM.REVFUNDCHECKNUM#',
				</CFIF>
				<CFIF IsDefined('FORM.CHECKISSUEDATE') AND FORM.CHECKISSUEDATE IS NOT "">
					CHECKISSUEDATE = TO_DATE('#FORM.CHECKISSUEDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				</CFIF>
				<CFIF FORM.PROCESSTRVLADVNCREQUESTS EQ "ADD">
					REQUESTSTATUSID = 4,
				</CFIF>
			<CFIF FORM.PROCESSTRVLADVNCREQUESTS EQ "Approve/Cancel/Deny Request">
					REQUESTSTATUSID = #val(FORM.REQUESTSTATUSID)#,
					APPROVEDBYSUPID = #val(FORM.APPROVEDBYSUPID)#,
				<CFIF IsDefined('FORM.SUPAPPROVALDATE')>
					SUPAPPROVALDATE = TO_DATE('#FORM.SUPAPPROVALDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				</CFIF>
			</CFIF>
					PAYEEAGREEMENT = '#FORM.PAYEEAGREEMENT#'
			WHERE	(TAREQUESTID = #val(Cookie.TAREQUESTID)#)
		</CFQUERY>
		<CFTRANSACTION action = "commit"/>
		</CFTRANSACTION>
	
		<CFSET FORM.CC = "">
		<CFQUERY name="LookupTrvlAdvncRequests" datasource="#application.type#WEBREPORTS">
			SELECT	TAR.TAREQUESTID, TAR.SUBMITDATE, TAR.PAYEEID, CUST.FULLNAME, CUST.EMAIL AS PAYEEEMAIL, TAR.CHECKAMOUNT,
					TAR.FISCALYEARID, TAR.TRAVELBEGINDATE, TAR.TRAVELENDDATE, TAR.DESTINATION, TAR.REVFUNDCHECKNUM,
					TAR.CHECKISSUEDATE, TAR.REQUESTSTATUSID, TAR.APPROVEDBYSUPID, U.SUPERVISORID, SUPVR.EMAIL AS SUPVREMAIL, 
					SUPVR.FULLNAME AS SUPVRNAME, RS.REQUESTSTATUSNAME, PAYEEAGREEMENT
			FROM		TRVLADVNCREQUESTS TAR, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U, LIBSHAREDDATAMGR.CUSTOMERS SUPVR,
					REQUESTSTATUS RS
			WHERE	TAR.TAREQUESTID = <CFQUERYPARAM value="#Cookie.TAREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					TAR.PAYEEID = CUST.CUSTOMERID AND
					CUST.UNITID = U.UNITID AND
					U.SUPERVISORID = SUPVR.CUSTOMERID
			ORDER BY	CUST.FULLNAME
		</CFQUERY>
		
	<!--- 
		<CFIF FORM.PROCESSTRVLADVNCREQUESTS EQ "Approve/Cancel/Deny Request">
			<CFSET FORM.TO = "#LookupTrvlAdvncRequests.PAYEEEMAIL#">
			<CFSET FORM.FROM = "#LookupTrvlAdvncRequests.SUPVREMAIL#">
			<CFSET FORM.SUBJECT = "Travel Advance Request For #LookupATrvlAdvncRequests.FULLNAME# has been #LookupTrvlAdvncRequests.REQUESTSTATUSNAME#">
		<CFELSE>
			<CFSET FORM.TO = "#LookupTrvlAdvncRequests.SUPVREMAIL#">
			<CFSET FORM.FROM = "#LookupTrvlAdvncRequests.PAYEEEMAIL#">
			<CFSET FORM.SUBJECT = "Subject: ONLINE Library Travel Advance Request For #LookupTrvlAdvncRequests.FULLNAME#">
		</CFIF>
	</CFOUTPUT>
	
	<CFMAIL query = "LookupTrvlAdvncRequests"
		to="#FORM.TO#"
		from="#FORM.FROM#"
		subject="#FORM.SUBJECT#"
	>
		A Travel Advance has been requested by #LookupATrvlAdvncRequests.FULLNAME# 
		that needs your approval at http://lfolkstest.sdsu.edu/#application.type#apps/webreports/trvladvncrequestapproval.cfm?TAREQUESTID=#Cookie.TAREQUESTID#"

	</CFMAIL>

	<CFOUTPUT> 
 --->

		<CFIF FORM.PROCESSTRVLADVNCREQUESTS EQ "ADD">
			<H1>Data ADDED!</H1>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/webreports/trvladvncrequest.cfm?PROCESS=ADD" />
			<CFEXIT>
		<CFELSEIF FORM.PROCESSTRVLADVNCREQUESTS EQ "MODIFY">
			<H1>Data MODIFIED!</H1>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/webreports/trvladvncrequest.cfm?PROCESS=MODIFYDELETE" />
			<CFEXIT>
		<CFELSE>
			<H1>Absence Request #LookupAbsenceRequests.REQUESTSTATUSNAME#!</H1>
			<CFIF #session.ArrayCounter# LT #session.TRVLADVNCREQUESTSSELECTED#>
				<CFSET session.ArrayCounter = session.ArrayCounter +1>
				<META http-equiv="Refresh" content="0; URL=/#application.type#apps/webreports/trvladvncrequestapproval.cfm" />
			<CFELSE>
				<CFSET session.ArrayCounter = 0>
				<CFSET session.TRVLADVNCREQUESTSSELECTED = 0>
				<CFSET session.PROCESS = ''>
				<H1>All Approvals Processed!</H1>
				<META http-equiv="Refresh" content="0; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
			</CFIF>
			<CFEXIT>
		</CFIF>
	</CFOUTPUT>
</CFIF>

<CFOUTPUT>
	<CFIF FORM.PROCESSTRVLADVNCREQUESTS EQ "DELETE" OR FORM.PROCESSTRVLADVNCREQUESTS EQ "CANCELADD">
		<CFQUERY name="DeleteTrvlAdvncRequests" datasource="#application.type#WEBREPORTS">
			DELETE FROM	TRVLADVNCREQUESTS 
			WHERE		TAREQUESTID = #val(Cookie.TAREQUESTID)#
		</CFQUERY>
		<H1>Data DELETED!</H1>
		<CFIF FORM.PROCESSTRVLADVNCREQUESTS EQ "DELETE">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/webreports/trvladvncrequest.cfm?PROCESS=MODIFYDELETE" />
		<CFELSE>
			<META http-equiv="Refresh" content="0; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
		</CFIF>
	</CFIF>
</CFOUTPUT>

</BODY>
</HTML>