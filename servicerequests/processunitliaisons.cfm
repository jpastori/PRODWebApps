<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processunitliaisons.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/20/2011 --->
<!--- Date in Production: 06/20/2011--->
<!--- Module: Process Information to IDT Service Requests Unit Liaisons --->
<!-- Last modified by John R. Pastori on 06/20/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Unit Liaisons</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSUNITLIAISONS EQ "ADD" OR FORM.PROCESSUNITLIAISONS EQ "MODIFY">
	<CFQUERY name="ModifyUnitLiaisons" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	UNITLIAISON
		SET		UNITID = #val(FORM.UNITID)#,
				ALTERNATE_CONTACTID = #val(FORM.ALTERNATE_CONTACTID)#
		WHERE	(UNITLIAISONID = #val(Cookie.UNITLIAISONID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSUNITLIAISONS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/unitliaisons.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/unitliaisons.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSUNITLIAISONS EQ "DELETE" OR FORM.PROCESSUNITLIAISONS EQ "CANCELADD">
	<CFQUERY name="DeleteUnitLiaisons" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	UNITLIAISON
		WHERE		UNITLIAISONID = #val(Cookie.UNITLIAISONID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSUNITLIAISONS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/unitliaisons.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>