<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processlocationdescription.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/31/2008 --->
<!--- Date in Production: 01/31/2008 --->
<!--- Module: Process Information to Facilities - Location Description --->
<!-- Last modified by John R. Pastori on 01/31/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - Location Description</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSLOCATIONDESCRIPTION EQ "ADD" OR FORM.PROCESSLOCATIONDESCRIPTION EQ "MODIFY">
	<CFQUERY name="ModifyLocationDescription" datasource="#application.type#FACILITIES">
		UPDATE	LOCATIONDESCRIPTION
		SET		LOCATIONDESCRIPTION = UPPER('#FORM.LOCATIONDESCRIPTION#')
		WHERE	(LOCATIONDESCRIPTIONID = #val(Cookie.LOCATIONDESCRIPTIONID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSlocationdescription EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/locationdescription.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/locationdescription.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSLOCATIONDESCRIPTION EQ "DELETE" OR FORM.PROCESSLOCATIONDESCRIPTION EQ "CANCELADD">
	<CFQUERY name="DeleteLocationDescription" datasource="#application.type#FACILITIES">
		DELETE FROM	LOCATIONDESCRIPTION 
		WHERE 		LOCATIONDESCRIPTIONID = #val(Cookie.LOCATIONDESCRIPTIONID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSLOCATIONDESCRIPTION EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/locationdescription.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>