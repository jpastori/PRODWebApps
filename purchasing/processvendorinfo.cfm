<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processvendorinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to Library IDT PurchasingVendors Database--->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Purchasing - Vendors</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF (FIND('ADD', #FORM.PROCESSVENDORS#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSVENDORS#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSVENDORS#, 1) EQ 0)>
	<CFQUERY name="ModifyVendors" datasource="#application.type#PURCHASING">
		UPDATE	VENDORS
		SET		VENDORS.VENDORNAME = UPPER('#FORM.VENDORNAME#'),
				VENDORS.ADDRESSLINE1 = UPPER('#FORM.ADDRESSLINE1#'),
				VENDORS.ADDRESSLINE2 = UPPER('#FORM.ADDRESSLINE2#'),
				VENDORS.CITY = UPPER('#FORM.CITY#'),
				VENDORS.STATEID = #val(FORM.STATEID)#,
				VENDORS.ZIPCODE = UPPER('#FORM.ZIPCODE#'),
				VENDORS.COUNTRY = UPPER('#FORM.COUNTRY#'),
				VENDORS.WEBSITE = LOWER('#FORM.WEBSITE#'),
				VENDORS.PRODUCTS = UPPER('#FORM.PRODUCTS#'),
				VENDORS.COMMENTS = UPPER('#FORM.COMMENTS#'),
				VENDORS.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				VENDORS.MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	(VENDORS.VENDORID = #val(Cookie.VENDORID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSVENDORS EQ "ADD" OR FORM.PROCESSVENDORS EQ "ADD CONTACT" >
		<H1>Data ADDED!</H1>
		<CFIF FORM.PROCESSVENDORS EQ "ADD CONTACT">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=ADD" />
		<CFELSE>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/vendorinfo.cfm?PROCESS=ADD" />
		</CFIF>
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSVENDORS EQ "MODIFY" OR FORM.PROCESSVENDORS EQ "MODIFY CONTACT">
	<H1>Data MODIFIED!</H1>
	<CFIF FORM.PROCESSVENDORS EQ "MODIFY CONTACT">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/vendorinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSVENDORS EQ "DELETE" OR FORM.PROCESSVENDORS EQ "CANCELADD">
	<CFIF FORM.PROCESSVENDORS EQ "DELETE">
		<CFQUERY name="DeleteVendorContacts" datasource="#application.type#PURCHASING">
			DELETE FROM	VENDORCONTACTS 
			WHERE		VENDORID = #val(Cookie.VENDORID)#
		</CFQUERY>
	</CFIF>
	<CFQUERY name="DeleteVendors" datasource="#application.type#PURCHASING">
		DELETE FROM	VENDORS 
		WHERE		VENDORID = #val(Cookie.VENDORID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSVENDORS EQ "DELETE">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/vendorinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="0; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>