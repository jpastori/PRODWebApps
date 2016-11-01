<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processexternlshops.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/08/2012 --->
<!--- Date in Production: 02/08/2012 --->
<!--- Module: Process Information to Facilities - External Shops --->
<!-- Last modified by John R. Pastori on 02/08/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - External Shops</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSEXTERNLSHOPS EQ "ADD" OR FORM.PROCESSEXTERNLSHOPS EQ "MODIFY">
	<CFQUERY name="ModifyExternalShops" datasource="#application.type#FACILITIES">
		UPDATE	EXTERNLSHOPS
		SET		EXTERNLSHOPNAME = UPPER('#FORM.EXTERNLSHOPNAME#'),
          		CONTACT_NAME = UPPER('#FORM.CONTACT_NAME#'),
                    CONTACT_PHONE = '#FORM.CONTACT_PHONE#',
                    SECOND_PHONE = '#FORM.SECOND_PHONE#'
		WHERE	EXTERNLSHOPID = #val(Cookie.EXTERNLSHOPID)#
	</CFQUERY>
	<CFIF FORM.PROCESSEXTERNLSHOPS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/externlshops.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/externlshops.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSEXTERNLSHOPS EQ "DELETE" OR FORM.PROCESSEXTERNLSHOPS EQ "CANCELADD">
	<CFQUERY name="DeleteExternalShops" datasource="#application.type#FACILITIES">
		DELETE FROM	EXTERNLSHOPS 
		WHERE 		EXTERNLSHOPID = #val(Cookie.EXTERNLSHOPID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSEXTERNLSHOPS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/externlshops.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>