<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processvendorcontactsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/02/2012 --->
<!--- Date in Production: 05/02/2012 --->
<!--- Module: Process Information to Library IDT Purchasing Vendor Contacts Database--->
<!-- Last modified by John R. Pastori on 05/02/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Purchasing - Vendor Contacts</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSVENDORCONTACTS EQ "ADD" OR FORM.PROCESSVENDORCONTACTS EQ "MODIFY">
	<CFQUERY name="UpdateVendorContacts" datasource="#application.type#PURCHASING">
		UPDATE	VENDORCONTACTS
		SET		VENDORID = '#val(FORM.VENDORID)#',
				CONTACTNAME = UPPER('#FORM.CONTACTNAME#'),
				PHONENUMBER = '#FORM.PHONENUMBER#',
				FAXNUMBER = '#FORM.FAXNUMBER#',
				EMAILADDRESS = LOWER('#FORM.EMAILADDRESS#'),
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
                    COMMENTS = UPPER('#FORM.COMMENTS#')
		WHERE	VENDORCONTACTID = #val(Cookie.VENDORCONTACTID)#
	</CFQUERY>
	<CFIF FORM.PROCESSVENDORCONTACTS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSVENDORCONTACTS EQ "DELETE" OR FORM.PROCESSVENDORCONTACTS EQ "CANCELADD">
	<CFQUERY name="DeleteVendorContacts" datasource="#application.type#PURCHASING">
		DELETE FROM	VENDORCONTACTS 
		WHERE 		VENDORCONTACTID = #val(Cookie.VENDORCONTACTID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSVENDORCONTACTS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>