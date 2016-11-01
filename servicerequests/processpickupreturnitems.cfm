<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpickupreturnitems.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/03/2009 --->
<!--- Date in Production: 02/03/2009 --->
<!--- Module: Process Information to IDT Service Requests - Pick Up/Return Items --->
<!-- Last modified by John R. Pastori on 02/03/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Pick Up/Return Items</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>
<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF IsDefined('FORM.CURRINVENTBARCODE')>
	<CFQUERY name="LookupActionHardware" datasource="#application.type#HARDWARE" dbtype="ORACLE80">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER
		FROM		HARDWAREINVENTORY HI
		WHERE	HI.BARCODENUMBER = '#FORM.CURRINVENTBARCODE#' 
		ORDER BY	BARCODENUMBER
	</CFQUERY>
	<CFSET FORM.CURRINVENTID = #LookupActionHardware.HARDWAREID#>
</CFIF>

<CFIF IsDefined('FORM.ACTIONINVENTBARCODE')>
	<CFQUERY name="LookupCurrHardware" datasource="#application.type#HARDWARE" dbtype="ORACLE80">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER
		FROM		HARDWAREINVENTORY HI
		WHERE	HI.BARCODENUMBER = '#FORM.ACTIONINVENTBARCODE#' 
		ORDER BY	BARCODENUMBER
	</CFQUERY>
	<CFSET FORM.ACTIONINVENTID = #LookupCurrHardware.HARDWAREID#>
</CFIF>

<CFIF ((FIND('CANCEL', #FORM.PROCESSPICKUPRETURN#, 1) EQ 0 OR FIND('DISPLAY', #FORM.PROCESSPICKUPRETURN#, 1) EQ 0))>
	<CFIF IsDefined('FORM.ACTIONDATE')>
		<CFSET FORM.ACTIONDATE = #DateFormat(FORM.ACTIONDATE, 'dd-mmm-yyyy')#>
	</CFIF>
	<CFIF IsDefined('FORM.CONFIRMDATE')>
		<CFSET FORM.CONFIRMDATE = #DateFormat(FORM.CONFIRMDATE, 'dd-mmm-yyyy')#>
	</CFIF>
</CFIF>

<CFIF (IsDefined('FORM.HWSWACTIONID')) AND (FIND('ADD', #FORM.PROCESSPICKUPRETURN#, 1) NEQ 0 OR FIND('MOD', #FORM.PROCESSPICKUPRETURN#, 1) NEQ 0 OR FIND('CONFIRM', #FORM.PROCESSPICKUPRETURN#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSPICKUPRETURN#, 1) EQ 0)>
	<CFQUERY name="ModifyPickupReturnItems" datasource="#application.type#SERVICEREQUESTS" dbtype="ORACLE80">
		UPDATE	PICKUPRETURNITEMS
		SET		HWSWACTIONID = #val(FORM.HWSWACTIONID)#,
			<CFIF IsDefined('FORM.CURRINVENTID')>
				CURRINVENTID = #val(FORM.CURRINVENTID)#,
				CURRCUSTID = #val(FORM.CURRCUSTID)#,
				CURRLOCID = #val(FORM.CURRLOCID)#,
			</CFIF>
				ACTIONDATE = TO_DATE('#FORM.ACTIONDATE#', 'DD-MON-YYYY'),
				ACTIONINVENTID = #val(FORM.ACTIONINVENTID)#,
				ACTIONCUSTID = #val(FORM.ACTIONCUSTID)#,
				ACTIONLOCID = #val(FORM.ACTIONLOCID)#,
				ACTIONCOMM = UPPER('#FORM.ACTIONCOMM#'),
				SALVAGEFLAG = UPPER('#FORM.SALVAGEFLAG#')
			<CFIF IsDefined('FORM.MODIFIEDBYID')>
				,MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#
			</CFIF>
				,STAFFCOMPLTDFLAG = UPPER('#FORM.STAFFCOMPLTDFLAG#')
			<CFIF FIND('CONFIRM', #FORM.PROCESSPICKUPRETURN#, 1) NEQ 0 AND #FORM.CONFIRMACTCOMPLT# EQ 'YES'>
				,CONFIRMACTCOMPLT = UPPER('#FORM.CONFIRMACTCOMPLT#'),
				CONFIRMDATE = TO_DATE('#FORM.CONFIRMDATE#', 'DD-MON-YYYY'),
				CONFIRMINITIALSID = #val(FORM.CONFIRMINITIALSID)#
			</CFIF>
		WHERE	(PKUPRETURNID = #val(Cookie.PKUPRETURNID)#)
	</CFQUERY>
	<CFIF FIND('ADD', #FORM.PROCESSPICKUPRETURN#, 1) NEQ 0>
		<H1>Data ADDED!</H1>
		<CFIF FORM.PROCESSPICKUPRETURN EQ "ADDLOOP">
			<META http-equiv="Refresh" content="1; URL=/servicerequests/pickupreturnitems.cfm?PROCESS=ADD&ADDLOOP=YES&SRID=#Cookie.SRID#&ACTIONID=#val(FORM.HWSWACTIONID)#">
		<CFELSE>
			<META http-equiv="Refresh" content="1; URL=/servicerequests/lookupcontactsprobleminfo.cfm?PROCESS=ADD">
		</CFIF>
	<CFELSEIF FIND('MOD', #FORM.PROCESSPICKUPRETURN#, 1) NEQ 0>
		<H1>Data MODIFIED!</H1>
		<CFIF FORM.PROCESSPICKUPRETURN EQ "MOD-RETURN">
			<META http-equiv="Refresh" content="1; URL=/servicerequests/pickupreturnitems.cfm?PROCESS=MODIFYDELETE">
		<CFELSE>
			<META http-equiv="Refresh" content="1; URL=/servicerequests/pickupreturnitems.cfm?PROCESS=MODIFYDELETE&LOOKUPITEM=FOUND&LOOP=YES&SRID=#Cookie.SRID#">
		</CFIF>
	<CFELSE>
		<H1>Data CONFIRMED!</H1>
		<CFIF FORM.PROCESSPICKUPRETURN EQ "CONFIRM-RETURN">
			<META http-equiv="Refresh" content="1; URL=/servicerequests/pickupreturnitems.cfm?PROCESS=CONFIRM">
			<!--- <META http-equiv="Refresh" content="1; URL=/servicerequests/servicerequestinfo.cfm?PROCESS=MODIFYDELETE"> --->
		<CFELSE>
			<META http-equiv="Refresh" content="1; URL=/servicerequests/pickupreturnitems.cfm?PROCESS=CONFIRM&LOOKUPITEM=FOUND&LOOP=YES&SRID=#Cookie.SRID#">
		</CFIF>
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPICKUPRETURN EQ "CONFIRM-DISPLAY">
	<H1>CONFIRMED Data Displayed!</H1>
	<META http-equiv="Refresh" content="1; URL=/servicerequests/pickupreturnitems.cfm?PROCESS=CONFIRM&LOOKUPITEM=FOUND&LOOP=YES&SRID=#Cookie.SRID#">
	<CFEXIT>
</CFIF>

<CFIF NOT IsDefined('FORM.HWSWACTIONID') AND FORM.PROCESSPICKUPRETURN EQ "CONFIRM-RETURN">)
	<H1>CONFIRMED Data Displayed!</H1>
	<META http-equiv="Refresh" content="1; URL=/servicerequests/pickupreturnitems.cfm?PROCESS=CONFIRM">
	<CFEXIT>
</CFIF>

<CFIF FIND('DEL', #FORM.PROCESSPICKUPRETURN#, 1) NEQ 0 OR FORM.PROCESSPICKUPRETURN EQ "CANCELADD">
	<CFQUERY name="DeletePickupReturnItems" datasource="#application.type#SERVICEREQUESTS" dbtype="ORACLE80">
		DELETE FROM	PICKUPRETURNITEMS
		WHERE		PKUPRETURNID = #val(Cookie.PKUPRETURNID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF IsDefined('URL.STAFFLOOP')>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data Deleted!");
				window.close();
			 -->
		</SCRIPT>
		<CFEXIT>
	</CFIF>
	<CFIF FIND('DEL', #FORM.PROCESSPICKUPRETURN#, 1) NEQ 0>
		<CFIF FORM.PROCESSPICKUPRETURN EQ "DEL-RETURN">
			<META http-equiv="Refresh" content="1; URL=/servicerequests/pickupreturnitems.cfm?PROCESS=MODIFYDELETE">
		<CFELSE>
			<META http-equiv="Refresh" content="1; URL=/servicerequests/pickupreturnitems.cfm?PROCESS=MODIFYDELETE&LOOKUPITEM=FOUND&LOOP=YES&SRID=#Cookie.SRID#">
		</CFIF>
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/servicerequests/index.cfm?logout=No">
	</CFIF>
</CFIF>
</CFOUTPUT>
</BODY>
</HTML>
