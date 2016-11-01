<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processlicensetype.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Software Inventory - License Type --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - License Type</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSLICENSETYPES EQ "ADD" OR FORM.PROCESSLICENSETYPES EQ "MODIFY">
	<CFQUERY name="ModifyLicenseType" datasource="#application.type#SOFTWARE">
		UPDATE	LICENSETYPES
		SET		LICENSETYPENAME = UPPER('#FORM.LICENSETYPENAME#')
		WHERE	(LICENSETYPEID = #val(Cookie.LICENSETYPEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSLICENSETYPES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/licensetype.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/licensetype.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSLICENSETYPES EQ "DELETE" OR FORM.PROCESSLICENSETYPES EQ "CANCELADD">
	<CFQUERY name="DeleteLicenseType" datasource="#application.type#SOFTWARE">
		DELETE FROM	LICENSETYPES 
		WHERE 		LICENSETYPEID = #val(Cookie.LICENSETYPEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSLICENSETYPES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/licensetype.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>