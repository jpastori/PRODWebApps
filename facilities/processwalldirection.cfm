<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processwalldirection.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/19/2010 --->
<!--- Date in Production: 01/19/2010 --->
<!--- Module: Process Information to Facilities - Wall Direction --->
<!-- Last modified by John R. Pastori on 01/19/2010 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - Wall Direction</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSWALLDIRECTION EQ "ADD" OR FORM.PROCESSWALLDIRECTION EQ "MODIFY">
	<CFQUERY name="ModifyWallDirection" datasource="#application.type#FACILITIES">
		UPDATE	WALLDIRECTION
		SET		WALLDIRNAME = UPPER('#FORM.WALLDIRNAME#')
		WHERE	(WALLDIRID = #val(Cookie.WALLDIRID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSWALLDIRECTION EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walldirection.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walldirection.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSWALLDIRECTION EQ "DELETE" OR FORM.PROCESSWALLDIRECTION EQ "CANCELADD">
	<CFQUERY name="DeleteWallDirection" datasource="#application.type#FACILITIES">
		DELETE FROM	WALLDIRECTION 
		WHERE 		WALLDIRID = #val(Cookie.WALLDIRID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSWALLDIRECTION EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walldirection.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>