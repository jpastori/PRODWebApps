<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processmediatype.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Software Inventory - Media Type --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Media Type</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSMEDIATYPES EQ "ADD" OR FORM.PROCESSMEDIATYPES EQ "MODIFY">
	<CFQUERY name="ModifyMediaType" datasource="#application.type#SOFTWARE">
		UPDATE	MEDIATYPES
		SET		MEDIATYPENAME = UPPER('#FORM.MEDIATYPENAME#')
		WHERE	(MEDIATYPEID = #val(Cookie.MEDIATYPEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSMEDIATYPES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/mediatype.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/mediatype.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSMEDIATYPES EQ "DELETE" OR FORM.PROCESSMEDIATYPES EQ "CANCELADD">
	<CFQUERY name="DeleteMediaType" datasource="#application.type#SOFTWARE">
		DELETE FROM	MEDIATYPES 
		WHERE 		MEDIATYPEID = #val(Cookie.MEDIATYPEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSMEDIATYPES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/mediatype.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>