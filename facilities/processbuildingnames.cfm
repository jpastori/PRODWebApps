<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processbuildingnames.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/12/2012 --->
<!--- Date in Production: 01/12/2012 --->
<!--- Module: Process Information to Facilities - Building Names --->
<!-- Last modified by John R. Pastori on 01/12/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - Building Names</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSBUILDINGNAMES EQ "ADD" OR FORM.PROCESSBUILDINGNAMES EQ "MODIFY">
	<CFQUERY name="ModifyBuildingNames" datasource="#application.type#FACILITIES">
		UPDATE	BUILDINGNAMES
		SET		BUILDINGNAME = UPPER('#FORM.BUILDINGNAME#'),
				BUILDINGCODE = '#FORM.BUILDINGCODE#',
                    BUILDINGABBREV = UPPER('#FORM.BUILDINGABBREV#')
		WHERE	BUILDINGNAMEID = #val(Cookie.BUILDINGNAMEID)#
	</CFQUERY>
	<CFIF FORM.PROCESSBUILDINGNAMES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/buildingnames.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/buildingnames.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSBUILDINGNAMES EQ "DELETE" OR FORM.PROCESSBUILDINGNAMES EQ "CANCELADD">
	<CFQUERY name="DeleteBuildingNames" datasource="#application.type#FACILITIES">
		DELETE FROM	BUILDINGNAMES 
		WHERE 		BUILDINGNAMEID = #val(Cookie.BUILDINGNAMEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSBUILDINGNAMES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/buildingnames.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>