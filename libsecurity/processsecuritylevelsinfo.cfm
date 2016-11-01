<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsecuritylevelsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Security - Security Levels --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Security - Security Levels</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSECURITYLEVELS EQ "ADD" OR FORM.PROCESSSECURITYLEVELS EQ "MODIFY">
	<CFQUERY name="ModifySecurityLevels" datasource="#application.type#LIBSECURITY">
		UPDATE	SECURITYLEVELS
		SET		SECURITYLEVELNUMBER = UPPER('#FORM.SECURITYLEVELNUMBER#'),
				SECURITYLEVELNAME = UPPER('#FORM.SECURITYLEVELNAME#')
		WHERE	(SECURITYLEVELID = #val(Cookie.SECURITYLEVELID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSSECURITYLEVELS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/securitylevelsinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/securitylevelsinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSECURITYLEVELS EQ "DELETE" OR FORM.PROCESSSECURITYLEVELS EQ "CANCELADD">
	<CFQUERY name="DeleteSecurityLevels" datasource="#application.type#LIBSECURITY">
		DELETE FROM	SECURITYLEVELS
		WHERE		SECURITYLEVELID = #val(Cookie.SECURITYLEVELID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSECURITYLEVELS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/securitylevelsinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>