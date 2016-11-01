<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processvlaninfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/07/2015 --->
<!--- Date in Production: 07/07/2015 --->
<!--- Module: Process Information to Facilities - VLan Info --->
<!-- Last modified by John R. Pastori on 07/07/2015 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - VLan Info</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSVLANINFO EQ "ADD" OR FORM.PROCESSVLANINFO EQ "MODIFY">
	<CFQUERY name="ModifyVLanInfo" datasource="#application.type#FACILITIES">
		UPDATE	VLANINFO
		SET		VLAN_NUMBER = '#FORM.VLAN_NUMBER#',
				VLAN_NAME = UPPER('#FORM.VLAN_NAME#')
		WHERE	VLANID = #val(Cookie.VLANID)#
	</CFQUERY>
	<CFIF FORM.PROCESSVLANINFO EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/vlaninfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/vlaninfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSVLANINFO EQ "DELETE" OR FORM.PROCESSVLANINFO EQ "CANCELADD">
	<CFQUERY name="DeleteVLanInfo" datasource="#application.type#FACILITIES">
		DELETE FROM	VLANINFO 
		WHERE 		VLANID = #val(Cookie.VLANID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSVLANINFO EQ "DELETE">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/vlaninfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>