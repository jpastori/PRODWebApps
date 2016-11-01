<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcustomerappaccess.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/06/2008 --->
<!--- Date in Production: 03/06/2008 --->
<!--- Module: Process Information to Library Security - Customer Application Access --->
<!-- Last modified by John R. Pastori on 03/06/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Security - Customer Application Access</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSCUSTAPPACCESS EQ "ADD">
	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, FULLNAME, INITIALS, SECURITYLEVELID, PASSWORD, SEEDKEY
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFLOOP from="1" to="#ListLen(FORM.DBSYSTEMID)#" index="Counter">
		<CFIF Counter EQ 1>
			<CFQUERY name="ModifyAddedCustomerAppAccess" datasource="#application.type#LIBSECURITY">
				UPDATE	CUSTOMERAPPACCESS
				SET		CUSTOMERID = #val(FORM.CUSTOMERID)#,
						PASSWORD = '#ListCustomers.PASSWORD#',
						DBSYSTEMID = #val(ListGetAt(FORM.DBSYSTEMID, Counter))#,
						SECURITYLEVELID = #val(FORM.SECURITYLEVELID)#,
						MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
						MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
				WHERE	(CUSTOMERAPPACCESS.CUSTAPPACCESSID = #val(Cookie.CUSTAPPACCESSID)#)
			</CFQUERY>
		<CFELSEIF Counter GT 1>
			<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSECURITY">
				SELECT	MAX(CUSTAPPACCESSID) AS MAX_ID
				FROM		CUSTOMERAPPACCESS
			</CFQUERY>
			<CFSET FORM.CUSTAPPACCESSID = #val(GetMaxUniqueID.MAX_ID+1)#>
			<CFQUERY name="AddCustomerAppAccess" datasource="#application.type#LIBSECURITY">
				INSERT INTO	CUSTOMERAPPACCESS (CUSTAPPACCESSID, CUSTOMERID, PASSWORD, DBSYSTEMID, SECURITYLEVELID, MODIFIEDBYID, MODIFIEDDATE)
				VALUES		(#val(FORM.CUSTAPPACCESSID)#, #val(FORM.CUSTOMERID)#, '#ListCustomers.PASSWORD#',
							 #val(ListGetAt(FORM.DBSYSTEMID, Counter))#, #val(FORM.SECURITYLEVELID)#, #val(FORM.MODIFIEDBYID)#, 
							 TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
			</CFQUERY>
		</CFIF>
	</CFLOOP>
	<H1>Data ADDED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/customerappaccess.cfm?PROCESS=ADD" />
</CFIF>

<CFIF FORM.PROCESSCUSTAPPACCESS EQ "MODIFY" OR FORM.PROCESSCUSTAPPACCESS EQ "MODIFYLOOP">

	<CFQUERY name="ModifyCustomerAppAccess" datasource="#application.type#LIBSECURITY">
		UPDATE	CUSTOMERAPPACCESS
		SET		SECURITYLEVELID = #val(FORM.SECURITYLEVELID)#,
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	(CUSTAPPACCESSID = #val(Cookie.CUSTAPPACCESSID)#)
	</CFQUERY>

	<H1>Data MODIFIED!</H1>
	<CFIF FORM.PROCESSCUSTAPPACCESS EQ "MODIFY">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/customerappaccess.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCUSTAPPACCESS EQ "MODIFYLOOP">
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.CustomerAccessIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=MODIFYLOOP&LOOKUPCUSTOMER=FOUND&LOOP=YES" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCUSTAPPACCESS EQ "NEXTRECORD">
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.CustomerAccessIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=MODIFYLOOP&LOOKUPCUSTOMER=FOUND&LOOP=YES" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCUSTAPPACCESS EQ "DELETELOOP">
	<CFQUERY name="DeleteCustomerAppAccess" datasource="#application.type#LIBSECURITY">
		DELETE FROM	CUSTOMERAPPACCESS 
		WHERE		CUSTAPPACCESSID = #val(Cookie.CUSTAPPACCESSID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.CustomerAccessIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=MODIFYLOOP&LOOKUPCUSTOMER=FOUND&LOOP=YES" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCUSTAPPACCESS EQ "CONFIRM DELETE">
	<CFQUERY name="DeleteCustomerAppAccess" datasource="#application.type#LIBSECURITY">
		DELETE FROM	CUSTOMERAPPACCESS 
		WHERE		CUSTOMERID = #val(FORM.DELCUSTOMERID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/custappaccmultipledel.cfm" />
</CFIF>

<CFIF FORM.PROCESSCUSTAPPACCESS EQ "DELETE" OR FORM.PROCESSCUSTAPPACCESS EQ "CANCELADD">
	<CFQUERY name="DeleteCustomerAppAccess" datasource="#application.type#LIBSECURITY">
		DELETE FROM	CUSTOMERAPPACCESS 
		WHERE		CUSTAPPACCESSID = #val(Cookie.CUSTAPPACCESSID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSCUSTAPPACCESS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/customerappaccess.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>