<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processabsencerequest.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/07/2012 --->
<!--- Date in Production: 08/07/2012 --->
<!--- Module: Process Information to Web Reports - Absence Request--->
<!-- Last modified by John R. Pastori on 05/19/2016 using ColdFusion Studio. -->

<cfif (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "LFOLKSWIKI")>
	<cfset SESSION.ORIGINSERVER = "LFOLKSWIKI">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelseif (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "FORMS")>
	<cfset SESSION.ORIGINSERVER = "FORMS">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelse>
	<cfinclude template = "../programsecuritycheck.cfm">
	<cfset SESSION.ORIGINSERVER = "">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
</cfif>

<html>
<head>
	<title>Process Information to Web Reports - Absence Request</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />
</head>

<body>

<cfinclude template="/include/coldfusion/formheader.cfm">

<cfif FORM.PROCESSABSENCEREQUESTS EQ "ADD" OR FORM.PROCESSABSENCEREQUESTS EQ "MODIFY" OR FORM.PROCESSABSENCEREQUESTS EQ "Approve/Cancel/Deny Request"> 

	<cfoutput>

		<cfset FORM.BEGINDATE1 = DateFormat(FORM.BEGINDATE1, 'DD-MMM-YYYY')>
	
		<cfif IsDefined('FORM.ENDDATE1') AND FORM.ENDDATE1 IS NOT "">
			<cfset FORM.ENDDATE1 = DateFormat(FORM.ENDDATE1, 'DD-MMM-YYYY')>
		</cfif>
	
		<cfif IsDefined('FORM.BEGINDATE2') AND FORM.BEGINDATE2 IS NOT "">
			<cfset FORM.BEGINDATE2 = DateFormat(FORM.BEGINDATE2, 'DD-MMM-YYYY')>
		</cfif>
	
		<cfif IsDefined('FORM.ENDDATE2') AND FORM.ENDDATE2 IS NOT "">
			<cfset FORM.ENDDATE2 = DateFormat(FORM.ENDDATE2, 'DD-MMM-YYYY')>
		</cfif>
	
		<cfif IsDefined('FORM.BEGINDATE3') AND FORM.BEGINDATE3 IS NOT "">
			<cfset FORM.BEGINDATE3 = DateFormat(FORM.BEGINDATE3, 'DD-MMM-YYYY')>
		</cfif>
	
		<cfif IsDefined('FORM.ENDDATE3') AND FORM.ENDDATE3 IS NOT "">
			<cfset FORM.ENDDATE3 = DateFormat(FORM.ENDDATE3, 'DD-MMM-YYYY')>
		</cfif>
	
		<cfif IsDefined('FORM.BEGINDATE4') AND FORM.BEGINDATE4 IS NOT "">
			<cfset FORM.BEGINDATE4 = DateFormat(FORM.BEGINDATE4, 'DD-MMM-YYYY')>
		</cfif>
	
		<cfif IsDefined('FORM.ENDDATE4') AND FORM.ENDDATE4 IS NOT "">
			<cfset FORM.ENDDATE4 = DateFormat(FORM.ENDDATE4, 'DD-MMM-YYYY')>
		</cfif>
	
		<cfif IsDefined('FORM.SUPAPPROVALDATE') AND FORM.SUPAPPROVALDATE IS NOT "">
			<cfset FORM.SUPAPPROVALDATE = DateFormat(FORM.SUPAPPROVALDATE, 'DD-MMM-YYYY')>
		</cfif>
	
		<cftransaction action="begin">
		<cfquery name="ModifyAbsenceRequests" datasource="#application.type#WEBREPORTS">
			UPDATE	ABSENCEREQUESTS
			SET		REQUESTERID = #val(FORM.REQUESTERID)#,
					REQUESTEREMAIL = LOWER('#FORM.REQUESTEREMAIL#'),
					SUPERVISOREMAILID = #val(FORM.SUPERVISOREMAILID)#,
				<CFIF #FORM.CC2# NEQ '@mail.sdsu.edu'>
					CC2 = LOWER('#FORM.CC2#'),
				<CFELSE>
					CC2 = '',
				</CFIF>
				<CFIF IsDefined('FORM.CARBON')>
					CARBON = 'YES',
				<CFELSE>
					CARBON = '',
				</CFIF>
					BEGINDATE1 = TO_DATE('#FORM.BEGINDATE1# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
	
				<CFIF IsDefined('FORM.ENDDATE1') AND FORM.ENDDATE1 IS NOT "">
					ENDDATE1 = TO_DATE('#FORM.ENDDATE1# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				<CFELSE>
					ENDDATE1 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.BEGINDATE2') AND FORM.BEGINDATE2 IS NOT "">
					BEGINDATE2 = TO_DATE('#FORM.BEGINDATE2# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				<CFELSE>
					BEGINDATE2 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.ENDDATE2') AND FORM.ENDDATE2 IS NOT "">
					ENDDATE2 = TO_DATE('#FORM.ENDDATE2# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				<CFELSE>
					ENDDATE2 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.BEGINDATE3') AND FORM.BEGINDATE3 IS NOT "">
					BEGINDATE3 = TO_DATE('#FORM.BEGINDATE3# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				<CFELSE>
					BEGINDATE3 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.ENDDATE3') AND FORM.ENDDATE3 IS NOT "">
					ENDDATE3 = TO_DATE('#FORM.ENDDATE3# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				<CFELSE>
					ENDDATE3 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.BEGINDATE4') AND FORM.BEGINDATE4 IS NOT "">
					BEGINDATE4 = TO_DATE('#FORM.BEGINDATE4# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				<CFELSE>
					BEGINDATE4 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.ENDDATE4') AND FORM.ENDDATE4 IS NOT "">
					ENDDATE4 = TO_DATE('#FORM.ENDDATE4# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				<CFELSE>
					ENDDATE4 = null,
				</CFIF>
	
					HOURS1 = #val(FORM.HOURS1)#,
					HOURS2 = #val(FORM.HOURS2)#,
					HOURS3 = #val(FORM.HOURS3)#,
					HOURS4 = #val(FORM.HOURS4)#,
					BEGINTIME1 = TO_DATE('#FORM.BEGINTIME1#', 'HH24:MI:SS'),
	
				<CFIF IsDefined('FORM.ENDTIME1') AND FORM.ENDTIME1 IS NOT "">
					ENDTIME1 = TO_DATE('#FORM.ENDTIME1#', 'HH24:MI:SS'),
				<CFELSE>
					ENDTIME1 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.BEGINTIME2') AND FORM.BEGINTIME2 IS NOT "">
					BEGINTIME2 = TO_DATE('#FORM.BEGINTIME2#', 'HH24:MI:SS'),
				<CFELSE>
					BEGINTIME2 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.ENDTIME2') AND FORM.ENDTIME2 IS NOT "">
					ENDTIME2 = TO_DATE('#FORM.ENDTIME2#', 'HH24:MI:SS'),
				<CFELSE>
					ENDTIME2 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.BEGINTIME3') AND FORM.BEGINTIME3 IS NOT "">
					BEGINTIME3 = TO_DATE('#FORM.BEGINTIME3#', 'HH24:MI:SS'),
				<CFELSE>
					BEGINTIME3 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.ENDTIME3') AND FORM.ENDTIME3 IS NOT "">
					ENDTIME3 = TO_DATE('#FORM.ENDTIME3#', 'HH24:MI:SS'),
				<CFELSE>
					ENDTIME3 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.BEGINTIME4') AND FORM.BEGINTIME4 IS NOT "">
					BEGINTIME4 = TO_DATE('#FORM.BEGINTIME4#', 'HH24:MI:SS'),
				<CFELSE>
					BEGINTIME4 = null,
				</CFIF>
	
				<CFIF IsDefined('FORM.ENDTIME4') AND FORM.ENDTIME4 IS NOT "">
					ENDTIME4 = TO_DATE('#FORM.ENDTIME4#', 'HH24:MI:SS'),
				<CFELSE>
					ENDTIME4 = null,
				</CFIF>
 	
					DAYS1ID = #val(FORM.DAYS1ID)#,
					DAYS2ID = #val(FORM.DAYS2ID)#,
					DAYS3ID = #val(FORM.DAYS3ID)#,
					DAYS4ID = #val(FORM.DAYS4ID)#,
                         
					VACATION = #val(FORM.VACATION)#,
					PERSONALHOLIDAY = #val(FORM.PERSONALHOLIDAY)#,
					COMPTIME = #val(FORM.COMPTIME)#,
					FMLA = #val(FORM.FMLA)#,
					FUNERAL = #val(FORM.FUNERAL)#,
					GTO = #val(FORM.GTO)#,
					JURYDUTY = #val(FORM.JURYDUTY)#,
					LWOP = #val(FORM.LWOP)#,
					MATPAT = #val(FORM.MATPAT)#,
					MILITARY = #val(FORM.MILITARY)#,
					OTHER = #val(FORM.OTHER)#,
					SICKFAMILY = #val(FORM.SICKFAMILY)#,
					SICKSELF = #val(FORM.SICKSELF)#,
					WITNESS = #val(FORM.WITNESS)#,
					RELATIONSHIP = UPPER('#FORM.RELATIONSHIP#'),
					REASON = UPPER('#FORM.REASON#'),
				<CFIF FORM.PROCESSABSENCEREQUESTS EQ "ADD">
					REQUESTSTATUSID = 4,
				</CFIF>
			<CFIF FORM.PROCESSABSENCEREQUESTS EQ "Approve/Cancel/Deny Request">
					REQUESTSTATUSID = #val(FORM.REQUESTSTATUSID)#,
					APPROVEDBYSUPID = #val(FORM.APPROVEDBYSUPID)#,
				<CFIF IsDefined('FORM.SUPAPPROVALDATE')>
					SUPAPPROVALDATE = TO_DATE('#FORM.SUPAPPROVALDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				</CFIF>
			</CFIF>
                    	ADDITIONALCC = LOWER('#FORM.ADDITIONALCC#')                    	
			WHERE	(ABSENCEID = #val(Cookie.ABSENCEID)#)
		</cfquery>
		<cftransaction action = "commit"/>
		</cftransaction>
	
		<cfset FORM.CC = "jshelby@mail.sdsu.edu">

		<cfquery name="LookupAbsenceRequests" datasource="#application.type#WEBREPORTS">
			SELECT	A.ABSENCEID, TO_CHAR(A.SUBMITDATE, 'MM/DD/YYYY') AS SUBMITDATE, A.REQUESTERID, CUST.FULLNAME, CUST.EMAIL AS REQEMAIL, A.REQUESTEREMAIL, A.SUPERVISOREMAILID,
					SUPVR.EMAIL AS SUPVREMAIL, SUPVR.FULLNAME AS SUPVRNAME, A.CC2, A.CARBON, TO_CHAR(A.BEGINDATE1, 'MM/DD/YYYY') AS BEGINDATE1, 
					TO_CHAR(A.ENDDATE1, 'MM/DD/YYYY') AS ENDDATE1, TO_CHAR(A.BEGINDATE2, 'MM/DD/YYYY') AS BEGINDATE2, TO_CHAR(A.ENDDATE2, 'MM/DD/YYYY') AS ENDDATE2,
					TO_CHAR(A.BEGINDATE3, 'MM/DD/YYYY') AS BEGINDATE3, TO_CHAR(A.ENDDATE3, 'MM/DD/YYYY') AS ENDDATE3, TO_CHAR(A.BEGINDATE4, 'MM/DD/YYYY') AS BEGINDATE4, 
					TO_CHAR(A.ENDDATE4, 'MM/DD/YYYY') AS ENDDATE4, A.HOURS1, A.HOURS2, A.HOURS3, A.HOURS4, A.BEGINTIME1, A.ENDTIME1,
					A.BEGINTIME2, A.ENDTIME2, A.BEGINTIME3, A.ENDTIME3, A.BEGINTIME4, A.ENDTIME4, A.DAYS1ID, A.DAYS2ID, A.DAYS3ID, A.DAYS4ID,
					A.VACATION, A.PERSONALHOLIDAY, A.COMPTIME, A.FMLA, A.FUNERAL, A.GTO, A.JURYDUTY, A.LWOP, A.MATPAT, A.MILITARY, A.OTHER,
					A.SICKFAMILY, A.SICKSELF,A.WITNESS, A.RELATIONSHIP, A.REASON, A.REQUESTSTATUSID, RS.REQUESTSTATUSNAME, A.APPROVEDBYSUPID,
					A.SUPAPPROVALDATE, A.ADDITIONALCC
			FROM		ABSENCEREQUESTS A, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CUSTOMERS SUPVR, REQUESTSTATUS RS
			WHERE	ABSENCEID = <CFQUERYPARAM value="#Cookie.ABSENCEID#" cfsqltype="CF_SQL_NUMERIC"> AND
					A.REQUESTERID = CUST.CUSTOMERID AND
					A.SUPERVISOREMAILID = SUPVR.CUSTOMERID AND
					A.REQUESTSTATUSID = RS.REQUESTSTATUSID
			ORDER BY	A.SUBMITDATE
		</cfquery>
		
		<cfif #LookupAbsenceRequests.CARBON# NEQ "">
			<cfset FORM.CC = #FORM.CC# & ", " & #LookupAbsenceRequests.REQEMAIL#>
			<cfif #LookupAbsenceRequests.CC2# NEQ "">
				<cfset FORM.CC = #FORM.CC# & ", " & #LookupAbsenceRequests.CC2#>
			</cfif>
		</cfif>
		<cfif #LookupAbsenceRequests.CC2# NEQ "" AND #LookupAbsenceRequests.CARBON# EQ "">
			<cfset FORM.CC = #FORM.CC# & ", " & #LookupAbsenceRequests.CC2#>
		</cfif>
          <cfif #LookupAbsenceRequests.ADDITIONALCC# NEQ "">
          	<cfset FORM.CC = #FORM.CC# & ", " & #LookupAbsenceRequests.ADDITIONALCC#>
          </cfif>

<!--- 
************************************************************************
* The following code sends out the appropriately data populated email. *
************************************************************************
 ---> 
		<cfset FORM.BCC = "">
		<cfif FORM.PROCESSABSENCEREQUESTS EQ "Approve/Cancel/Deny Request">

			<cfquery name="ListManagers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
				SELECT	CUSTOMERID, EMAIL, FULLNAME, UNITHEAD, DEPTCHAIR, ACTIVE
				FROM		CUSTOMERS
				WHERE	ACTIVE = 'YES' AND
						(UNITHEAD = 'YES' AND
						DEPTCHAIR = 'YES')
				ORDER BY	EMAIL
			</cfquery>

			<cfquery name="LookupCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
				SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.FULLNAME || '-' || CUST.EMAIL AS SUPEMAIL, CUST.UNITID, U.GROUPID,
						G.MANAGEMENTID, CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.ALLOWEDTOAPPROVE
				FROM		CUSTOMERS CUST, UNITS U, GROUPS G
				WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#LookupAbsenceRequests.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC"> AND
						CUST.UNITID = U.UNITID AND
						U.GROUPID IN (2,3,4,6) AND 
						U.GROUPID = G.GROUPID AND
						ACTIVE = 'YES'
					ORDER BY	CUST.FULLNAME
			</cfquery>

			<cfquery name="LookupForwardedManager" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
				SELECT	CUSTOMERID, EMAIL, FULLNAME
				FROM		CUSTOMERS
				WHERE	CUSTOMERID = <CFQUERYPARAM value="#LookupCustomers.MANAGEMENTID#" cfsqltype="CF_SQL_NUMERIC">
				ORDER BY	EMAIL
			</cfquery>

			<cfif #LookupForwardedManager.RecordCount# GT 0>
				<cfset FORM.BCC = #LookupForwardedManager.EMAIL#>
			</cfif>

			<cfset FORM.TO = "#LookupAbsenceRequests.REQEMAIL#">
			<cfset FORM.FROM = "#LookupAbsenceRequests.SUPVREMAIL#">
			<cfset FORM.SUBJECT = "Absence Request For #LookupAbsenceRequests.FULLNAME# has been #LookupAbsenceRequests.REQUESTSTATUSNAME#">
		<cfelse>
			<cfset FORM.TO = "#LookupAbsenceRequests.SUPVREMAIL#">
			<cfset FORM.FROM = "#LookupAbsenceRequests.REQEMAIL#">
			<cfset FORM.SUBJECT = "Subject: ONLINE Library Absence Request For #LookupAbsenceRequests.FULLNAME#">
		</cfif>
	</cfoutput>
	
	<cfmail query = "LookupAbsenceRequests" type="html"
		to="#FORM.TO#"
		from="#FORM.FROM#"
		subject="#FORM.SUBJECT#"
		cc="#FORM.CC#"
		bcc="#FORM.BCC#"
	>
<cfinclude template = "absencerequestreport.cfm">
	</cfmail>

	<cfoutput>

	<cfif FORM.PROCESSABSENCEREQUESTS EQ "ADD">
          <h1>Data ADDED!</h1>
          <cfinclude template = "absencerequestreport.cfm">
          <meta http-equiv="Refresh" content="10; URL=#SESSION.RETURNPGM#" />
          <!--- <meta http-equiv="Refresh" content="5; URL=/#application.type#apps/webreports/absencerequest.cfm?PROCESS=ADD" /> --->
          <cfexit>
     <cfelseif FORM.PROCESSABSENCEREQUESTS EQ "MODIFY">
          <h1>Data MODIFIED!</h1>
          <cfinclude template = "absencerequestreport.cfm">
          <meta http-equiv="Refresh" content="5; URL=/#application.type#apps/webreports/absencerequest.cfm?PROCESS=MODIFYDELETE" />
          <cfexit>
     <cfelse>
          <h1>Absence Request #LookupAbsenceRequests.REQUESTSTATUSNAME#</h1>
          <cfif #session.ArrayCounter# LT #session.ABSENCEREQUESTSSELECTED#>
               <cfset session.ArrayCounter = session.ArrayCounter +1>
               <meta http-equiv="Refresh" content="3; URL=/#application.type#apps/webreports/absencerequestapproval.cfm" />
          <cfelse>
               <cfset session.ArrayCounter = 0>
               <cfset session.ABSENCEREQUESTSSELECTED = 0>
               <cfset session.PROCESS = ''>
               <h1>All Approvals Processed!</h1>
               <meta http-equiv="Refresh" content="3; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
          </cfif>
          <cfexit>
     </cfif>
     </cfoutput>
</cfif>

<cfoutput>
<cfif FORM.PROCESSABSENCEREQUESTS EQ "DELETE" OR FORM.PROCESSABSENCEREQUESTS EQ "CANCELADD">
	<cfquery name="DeleteAbsenceRequests" datasource="#application.type#WEBREPORTS">
		DELETE FROM	ABSENCEREQUESTS 
		WHERE		ABSENCEID = #val(Cookie.ABSENCEID)#
	</cfquery>
	<h1>Data DELETED!</h1>
	<cfif FORM.PROCESSABSENCEREQUESTS EQ "DELETE">
		<meta http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/absencerequest.cfm?PROCESS=MODIFYDELETE" />
	<cfelse>
		<meta http-equiv="Refresh" content="1; URL=#SESSION.RETURNPGM#" />
	</cfif>
</cfif>
</cfoutput>

</body>
</html>