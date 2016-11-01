<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcustomerinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Shared Data - Customer Info --->
<!-- Last modified by John R. Pastori on 06/24/2016 using ColdFusion Studio. -->

<cfinclude template = "../programsecuritycheck.cfm">
<html>
<head>
	<title>Process Information to Shared Data - Customer Info</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />
</head>

<body>

<cfoutput>

<cfinclude template="/include/coldfusion/formheader.cfm">

<cfif FORM.PROCESSCUSTOMER EQ "ADD" OR FORM.PROCESSCUSTOMER EQ "MODIFY">

	<cfquery name="ModifyCustomer" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	CUSTOMERS
		SET		FIRSTNAME = UPPER('#FORM.FIRSTNAME#'),
				LASTNAME = UPPER('#FORM.LASTNAME#'),
				INITIALS = UPPER('#FORM.INITIALS#'),
				CATEGORYID = #val(FORM.CATEGORYID)#,
				EMAIL = LOWER('#FORM.EMAILADDRESS#'),
				CAMPUSPHONE = '#FORM.CAMPUSPHONE#',
				SECONDCAMPUSPHONE = '#FORM.SECONDCAMPUSPHONE#',
				CELLPHONE = '#FORM.CELLPHONE#',
				FAX = '#FORM.FAXNUMBER#',
				FULLNAME = UPPER('#FORM.FIRSTNAME#' || ' ' || '#FORM.LASTNAME#'),
				DIALINGCAPABILITY = UPPER('#FORM.DIALINGCAPABILITY#'),
				LONGDISTAUTHCODE = UPPER('#FORM.LONGDISTAUTHCODE#'),
				PHONEBOOKLISTING = UPPER('#FORM.PHONEBOOKLISTING#'),
				VOICEMAIL = UPPER('#FORM.VOICEMAIL#'),
				ANALOGLINE = UPPER('#FORM.ANALOGLINE#'),
				UNITID = #val(FORM.UNITID)#,
				LOCATIONID = #val(FORM.LOCATIONID)#,
				UNITHEAD = UPPER('#FORM.UNITHEAD#'),
				DEPTCHAIR = UPPER('#FORM.DEPTCHAIR#'),
				ALLOWEDTOAPPROVE = UPPER('#ALLOWEDTOAPPROVE#'),
				CUSTOMERS.CONTACTBY = UPPER('#FORM.CONTACTBY#'),
                    SECURITYLEVELID = #val(FORM.SECURITYLEVELID)#,
				BIBLIOGRAPHER = UPPER('#FORM.BIBLIOGRAPHER#'),
				COMMENTS = UPPER('#FORM.COMMENTS#'),
				AA_COMMENTS = UPPER('#FORM.AA_COMMENTS#'),
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				ACTIVE = UPPER('#FORM.ACTIVE#'),
				REDID = #val(FORM.REDID)#,
                    ACCOUNTS = UPPER('#FORM.ACCOUNTS#'),
                    DATACENTERACCESS = '#FORM.DATACENTERACCESS#'
		WHERE	(CUSTOMERID = #val(Cookie.CUSTID)#)
	</cfquery>

	<cfif #Client.SecurityFlag# EQ "Yes" AND IsDefined('FORM.PASSWORD') AND #FORM.PASSWORD# NEQ ''>
		<cfset FORM.SEEDKEY = NOW()>
		<cfset FORM.SEEDKEY = ListChangeDelims(FORM.SEEDKEY, "$", "'")>
		<cfset FORM.PASSWORD = ENCRYPT(#FORM.PASSWORD#, #FORM.SEEDKEY#)>

		<cfquery name="ModifyCustomerPassword" datasource="#application.type#LIBSHAREDDATA">
			UPDATE	CUSTOMERS
			SET		PASSWORD = '#FORM.PASSWORD#',
					SEEDKEY = '#FORM.SEEDKEY#'
			WHERE	(CUSTOMERID = #val(Cookie.CUSTID)#)
		</cfquery>

		<cfquery name="ModifyCustomerAppAccessPasswords" datasource="#application.type#LIBSECURITY">
			UPDATE	CUSTOMERAPPACCESS
			SET		PASSWORD = '#FORM.PASSWORD#'
			WHERE	CUSTOMERID = #val(Cookie.CUSTID)#
		</cfquery>

	</cfif>

	<cfif FORM.PROCESSCUSTOMER EQ "ADD">
		<h1>Data ADDED!</h1>
		<meta http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/customerinfo.cfm?PROCESS=ADD" />
	<cfelse>
		<h1>Data MODIFIED!</h1>
		<meta http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/customerinfo.cfm?PROCESS=MODIFYDELETE" />
	</cfif>
</cfif>

<cfif FORM.PROCESSCUSTOMER EQ "DELETE" OR FORM.PROCESSCUSTOMER EQ "CANCELADD">
	<cfquery name="DeleteCustomer" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	CUSTOMERS 
		WHERE		CUSTOMERID = #val(Cookie.CUSTID)#
	</cfquery>
	<h1>Data DELETED!</h1>
	<cfif FORM.PROCESSCUSTOMER EQ "DELETE">
		<meta http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/customerinfo.cfm?PROCESS=MODIFYDELETE" />
	<cfelse>
		<meta http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</cfif>
</cfif>
</cfoutput>

</body>
</html>