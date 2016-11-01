<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processlicensestatus.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Purchasing - License Status --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Purchasing - License Status</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSLICENSESTATUS EQ "ADD" OR FORM.PROCESSLICENSESTATUS EQ "MODIFY">
	<CFQUERY name="ModifyLicenseStatus" datasource="#application.type#PURCHASING">
		UPDATE	LICENSESTATUS
		SET		LICENSESTATUSNAME = UPPER('#FORM.LICENSESTATUSNAME#')
		WHERE	(LICENSESTATUSID = #val(Cookie.LICENSESTATUSID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSLICENSESTATUS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/licensestatus.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/licensestatus.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSLICENSESTATUS EQ "DELETE" OR FORM.PROCESSLICENSESTATUS EQ "CANCELADD">
	<CFQUERY name="DeleteLicenseStatus" datasource="#application.type#PURCHASING">
		DELETE FROM	LICENSESTATUS
		WHERE 		LICENSESTATUSID = #val(Cookie.LICENSESTATUSID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSLICENSESTATUS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/licensestatus.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>