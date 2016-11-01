<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsoftwareinventory.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/23/2011 --->
<!--- Date in Production: 11/23/2011 --->
<!--- Module: Process Information to IDT Software Inventory--->
<!-- Last modified by John R. Pastori on 11/23/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSOFTWAREINVENTORY NEQ "CANCELADD">
	<CFIF FORM.RECVDDATE IS NOT "">
		<CFSET FORM.RECVDDATE = DateFormat(FORM.RECVDDATE, 'DD-MMM-YYYY')>
	</CFIF>
</CFIF>

<CFIF (FIND('ADD', #FORM.PROCESSSOFTWAREINVENTORY#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSSOFTWAREINVENTORY#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSSOFTWAREINVENTORY#, 1) EQ 0)>
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifySoftwareInventory" datasource="#application.type#SOFTWARE">
		UPDATE	SOFTWAREINVENTORY
		SET		TITLE = UPPER('#FORM.TITLE#'),
				VERSION = UPPER('#FORM.VERSION#'),
				CATEGORYID = #val(FORM.CATEGORYID)#,
				PRODPLATFORMID = #val(FORM.PRODPLATFORMID)#,
				PRODDESCRIPTION = UPPER('#FORM.PRODDESCRIPTION#'),
				PURCHREQLINEID = #val(FORM.PURCHREQLINEID)#,
			<CFIF IsDefined('FORM.FISCALYEARID')>
				FISCALYEARID = #val(FORM.FISCALYEARID)#,
			</CFIF>
			<CFIF #FORM.RECVDDATE# NEQ "">
				RECVDDATE = TO_DATE('#FORM.RECVDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
			</CFIF>
				PRODSTATUSID = #val(FORM.PRODSTATUSID)#,
				PHONESUPPORT = UPPER('#FORM.PHONESUPPORT#'),
				WEBSUPPORT = LOWER('#FORM.WEBSUPPORT#'),
				FAXSUPPORT = UPPER('#FORM.FAXSUPPORT#'),
				SUPPORTCOMMENTS = UPPER('#FORM.SUPPORTCOMMENTS#'),
				QTYORDERED = #val(FORM.QTYORDERED)#,
				LICENSETYPEID = #val(FORM.LICENSETYPEID)#,
				QTYLICENSED = #val(FORM.QTYLICENSED)#,
				UPGRADESTATUSID = #val(FORM.UPGRADESTATUSID)#,
			<CFIF IsDefined('FORM.TOSSSTATUSID')>
				TOSSSTATUSID = #val(FORM.TOSSSTATUSID)#,
			</CFIF>
				CDKEY = UPPER('#FORM.CDKEY#'),
				PRODUCTID = UPPER('#FORM.PRODUCTID#'),
				MANUFWARRVENDORID = #val(FORM.MANUFWARRVENDORID)#,
               <CFIF IsDefined('FORM.IMAGEKEYS')>
                    IMAGEKEYS = '#FORM.IMAGEKEYS#',
               </CFIF>
   				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')

		WHERE	SOFTWINVENTID = #val(Cookie.SOFTWINVENTID)#
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREINVENTORY EQ "ADD">
	<H1>Data ADDED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareinventory.cfm?PROCESS=ADD" />
</CFIF>

<CFIF FORM.PROCESSSOFTWAREINVENTORY EQ "MODIFY">
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareinventory.cfm?PROCESS=MODIFYDELETE" />
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSSOFTWAREINVENTORY#, 1) NEQ 0 OR FORM.PROCESSSOFTWAREINVENTORY EQ "CANCELADD">
	<CFIF FORM.PROCESSSOFTWAREINVENTORY EQ "DELETE" OR FORM.PROCESSSOFTWAREINVENTORY EQ "CANCELADD">

		<CFQUERY name="DeleteSoftwareAssignments" datasource="#application.type#SOFTWARE">
			DELETE FROM	SOFTWAREASSIGNMENTS
			WHERE 		SOFTWINVENTID = #val(Cookie.SOFTWINVENTID)#
		</CFQUERY>

		<CFQUERY name="DeleteSoftwareManuals" datasource="#application.type#SOFTWARE">
			DELETE FROM	MANUALS
			WHERE 		SOFTWINVENTID = #val(Cookie.SOFTWINVENTID)#
		</CFQUERY>

		<CFQUERY name="DeleteSoftwareMedia" datasource="#application.type#SOFTWARE">
			DELETE FROM	MEDIA
			WHERE 		SOFTWINVENTID = #val(Cookie.SOFTWINVENTID)#
		</CFQUERY>

		<CFQUERY name="DeleteSoftwareOtherItems" datasource="#application.type#SOFTWARE">
			DELETE FROM	OTHERITEMS
			WHERE 		SOFTWINVENTID = #val(Cookie.SOFTWINVENTID)#
		</CFQUERY>

		<CFQUERY name="DeleteSoftwareInventory" datasource="#application.type#SOFTWARE">
			DELETE FROM	SOFTWAREINVENTORY
			WHERE 		SOFTWINVENTID = #val(Cookie.SOFTWINVENTID)#
		</CFQUERY>

	</CFIF>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSOFTWAREINVENTORY EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareinventory.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>