<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processextrnlwoinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012 --->
<!--- Module: Process Information to Facilities - External WO Provided Info --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - External WO Provided Info </TITLE>
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF (FIND('ADD', FORM.PROCESSEXTERNLWOS, 1) NEQ 0 OR FIND('MODIFY', FORM.PROCESSEXTERNLWOS, 1) NEQ 0) AND (FORM.PROCESSEXTERNLWOS NEQ "CANCELADD")>
	<CFSET FORMATDATESENT = #DateFormat(FORM.DATESENT, "dd-mmm-yyyy")#>
	<CFIF IsDefined('FORM.DATESTARTED')>
		<CFSET FORMATDATESTARTED = #DateFormat(FORM.DATESTARTED, "dd-mmm-yyyy")#>
	</CFIF>
	<CFIF IsDefined('FORM.BILLINGDATE')>
		<CFSET FORMATBILLINGDATE = #DateFormat(FORM.BILLINGDATE, "dd-mmm-yyyy")#>
	</CFIF>
	FORMAT DATE SENT = #FORMATDATESENT#&nbsp;&nbsp;&nbsp;&nbsp;FORMAT DATE STARTED = #FORMATDATESTARTED#&nbsp;&nbsp;&nbsp;&nbsp;FORMAT BILLING DATE = #FORMATBILLINGDATE#<BR>

	<CFQUERY name="UpdateExternalWorkOrderInfo" datasource="#application.type#FACILITIES">
		UPDATE	EXTERNLWOINFO
		SET		SHOPSWONUM = '#FORM.SHOPSWONUM#',
				DATESENT = TO_DATE('#FORMATDATESENT#', 'DD-MON-YYYY'),
			<CFIF IsDefined('FORM.DATESTARTED')>
				DATESTARTED = TO_DATE('#FORMATDATESTARTED#', 'DD-MON-YYYY'),
			</CFIF>
			<CFIF IsDefined('FORM.BILLINGDATE')>
				BILLINGDATE = TO_DATE('#FORMATBILLINGDATE#', 'DD-MON-YYYY'),
			</CFIF>
				EXTERNLSHOPID = #val(FORM.EXTERNLSHOPID)#,
				LABORCOST = #val(FORM.LABORCOST)#,
				ITEMCOST = #val(FORM.ITEMCOST)#,
				TAX = #val(FORM.TAX)#,
				TOTCHRGBACK = #val(FORM.TOTCHRGBACK)#,
				SHOPCOMMENTS = '#FORM.SHOPCOMMENTS#'
		WHERE	EXTERNLWOID = #val(Cookie.EXTERNLWOID)#
	</CFQUERY>

	<CFIF FIND('ADD', #FORM.PROCESSEXTERNLWOS#, 1) NEQ 0>
		<H1>External Work Order Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/extrnlwoinfo.cfm?PROCESS=ADD" />
	</CFIF>

	<CFIF FIND('MODIFY', #FORM.PROCESSEXTERNLWOS#, 1) NEQ 0>
		<H1>External Work Order Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/extrnlwoinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>

</CFIF>

<CFIF FORM.PROCESSEXTERNLWOS EQ "DELETE" OR FORM.PROCESSEXTERNLWOS EQ "CANCELADD">

	<CFQUERY name="DeleteExternalWorkOrderInfo" datasource="#application.type#FACILITIES">
		DELETE FROM	EXTERNLWOINFO
		WHERE		EXTERNLWOID = #val(Cookie.EXTERNLWOID)#
	</CFQUERY>
	<H1>External Work Order Data DELETED!</H1>
	<CFIF FORM.PROCESSEXTERNLWOS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/extrnlwoinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>