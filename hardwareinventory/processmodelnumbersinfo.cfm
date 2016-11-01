<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processmodelnumbersinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory Model Numbers --->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Hardware Inventory - Model Numbers</TITLE>
	 <LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSMODELNUMBERS EQ "ADD" OR FORM.PROCESSMODELNUMBERS EQ "MODIFY">
	<CFQUERY name="ModifyModelNumbers" datasource="#application.type#HARDWARE">
		UPDATE	MODELNUMBERLIST
		SET		MODELNUMBER = UPPER('#FORM.MODELNUMBER#'),
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	MODELNUMBERID = #val(Cookie.MODELNUMBERID)#
	</CFQUERY>
	<CFIF FORM.PROCESSMODELNUMBERS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/modelnumbersinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/modelnumbersinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSMODELNUMBERS EQ "DELETE" OR FORM.PROCESSMODELNUMBERS EQ "CANCELADD">
	<CFQUERY name="DeleteModelNumbers" datasource="#application.type#HARDWARE">
		DELETE FROM	MODELNUMBERLIST
		WHERE 		MODELNUMBERID = #val(Cookie.MODELNUMBERID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSMODELNUMBERS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/modelnumbersinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>