<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpasswordchange.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Security - Password Change --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Security - Password Change</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFSET FORM.OLDPASSWORD = ENCRYPT(#FORM.OLDPASSWORD#, #URL.SEEDKEY#)>

<CFQUERY name="LookupCustomer" datasource="#application.type#LIBSHAREDDATA">
	SELECT	CUSTOMERID, FULLNAME, PASSWORD, ACTIVE
	FROM		CUSTOMERS
	WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
			PASSWORD = <CFQUERYPARAM value="#FORM.OLDPASSWORD#" cfsqltype="CF_SQL_VARCHAR">
	ORDER BY	FULLNAME
</CFQUERY>

<CFIF #LookupCustomer.RecordCount# EQ 0>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("Customer Record Not Found because Old Password is not correctly entered! Try again.");
		--> 
	</SCRIPT>
	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/libsecurity/passwordchange.cfm?CUSTOMER=#FORM.CUSTOMERID#" />
	<CFEXIT>
</CFIF>

<CFQUERY name="LookupAccessSecurityRecords" datasource="#application.type#LIBSECURITY">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID, DBS.DBSYSTEMID,
			DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID,
			SL.SECURITYLEVELNUMBER, SL.SECURITYLEVELNAME, CAA.MODIFIEDBYID, CAA.MODIFIEDDATE
	FROM		CUSTOMERAPPACCESS CAA, DBSYSTEMS DBS, SECURITYLEVELS SL, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	CAA.CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
			CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID
	ORDER BY	CUST.FULLNAME, DBS.DBSYSTEMNUMBER
</CFQUERY>

<CFSET FORM.SEEDKEY = NOW()>
<CFSET FORM.SEEDKEY = ListChangeDelims(FORM.SEEDKEY, "$", "'")>
<CFSET FORM.NEWPASSWORD = ENCRYPT(#FORM.NEWPASSWORD#, #FORM.SEEDKEY#)>

<CFLOOP query="LookupAccessSecurityRecords">
	<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>

	<CFQUERY name="ModifyAddedCustomerAppAccess" datasource="#application.type#LIBSECURITY">
		UPDATE	CUSTOMERAPPACCESS
		SET		PASSWORD = '#FORM.NEWPASSWORD#',
				MODIFIEDBYID = #val(Client.CUSTOMERID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	(CUSTAPPACCESSID = #val(LookupAccessSecurityRecords.CUSTAPPACCESSID)#)
	</CFQUERY>

</CFLOOP>

<CFQUERY name="ModifyCustomerPassword" datasource="#application.type#LIBSHAREDDATA">
	UPDATE	CUSTOMERS
	SET		PASSWORD = '#FORM.NEWPASSWORD#',
			SEEDKEY = '#FORM.SEEDKEY#'
	WHERE	(CUSTOMERID = #val(FORM.CUSTOMERID)#)
</CFQUERY>

<H1>PASSWORD SUCCESSFULLY UPDATED!</H1>
<META http-equiv="Refresh" content="0; URL=/#application.type#apps/index.cfm?logout=Yes" />
</CFOUTPUT>

</BODY>
</HTML>