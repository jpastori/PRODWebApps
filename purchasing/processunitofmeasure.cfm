<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processunitofmeasure.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Purchasing - Unit Of Measure --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Purchasing - Unit Of Measure</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSUNITOFMEASURE EQ "ADD" OR FORM.PROCESSUNITOFMEASURE EQ "MODIFY">
	<CFQUERY name="ModifyUnitOfMeasure" datasource="#application.type#PURCHASING">
		UPDATE	UNITOFMEASURE
		SET		MEASURENAME = UPPER('#FORM.MEASURENAME#')
		WHERE	(UNITOFMEASUREID = #val(Cookie.UNITOFMEASUREID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSUNITOFMEASURE EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/unitofmeasure.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/unitofmeasure.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSUNITOFMEASURE EQ "DELETE" OR FORM.PROCESSUNITOFMEASURE EQ "CANCELADD">
	<CFQUERY name="DeleteUnitOfMeasure" datasource="#application.type#PURCHASING">
		DELETE FROM	UNITOFMEASURE
		WHERE 		UNITOFMEASUREID = #val(Cookie.UNITOFMEASUREID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSUNITOFMEASURE EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/unitofmeasure.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>