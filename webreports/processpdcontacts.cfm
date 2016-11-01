<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpdcontacts.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Public Desk Contacts --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Public Desk Contacts</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPDCONTACTS EQ "ADD" OR FORM.PROCESSPDCONTACTS EQ "MODIFY">
	<CFQUERY name="ModifyPDContacts" datasource="#application.type#WEBREPORTS">
		UPDATE	PDCONTACTS
		SET		CONTACTNAME = '#FORM.CONTACTNAME#',
				DEPARTMENT = '#FORM.DEPARTMENT#',
				PHONE = '#FORM.PHONE#',
				EMAIL = LOWER('#FORM.EMAIL#')
		WHERE	(CONTACTID = #val(Cookie.CONTACTID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPDCONTACTS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/pdcontacts.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/pdcontacts.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPDCONTACTS EQ "DELETE" OR FORM.PROCESSPDCONTACTS EQ "CANCELADD">
	<CFQUERY name="DeletePDContacts" datasource="#application.type#WEBREPORTS">
		DELETE FROM	PDCONTACTS 
		WHERE		CONTACTID = #val(Cookie.CONTACTID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPDCONTACTS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/pdcontacts.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>