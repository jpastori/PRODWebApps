<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpurchreqaddlegacy.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/27/2011 --->
<!--- Date in Production: 09/27/2011 --->
<!--- Module: Process Add Information to IDT Legacy Purchase Requisitions --->
<!-- Last modified by John R. Pastori on 09/27/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Add Information to IDT Legacy Purchase Requisitions</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPURCHREQ EQ "CANCELADD">
	<CFQUERY name="DeletePurchReqs" datasource="#application.type#PURCHASING">
		DELETE FROM	PURCHREQS
		WHERE 		PURCHREQID = #val(Cookie.PURCHREQID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/index.cfm?logout=No" />
	<CFEXIT>
</CFIF>

<CFSET FORM.VENDORCONTACTID = 0>

<CFIF IsDefined('FORM.QUOTEDATE') AND FORM.QUOTEDATE IS NOT "">
	<CFSET FORM.QUOTEDATE = DateFormat(FORM.QUOTEDATE, 'DD-MMM-YYYY')>
</CFIF>
<CFIF IsDefined('FORM.REVIEWDATE') AND FORM.REVIEWDATE IS NOT "">
	<CFSET FORM.REVIEWDATE = DateFormat(FORM.REVIEWDATE, 'DD-MMM-YYYY')>
</CFIF>
<CFIF IsDefined('FORM.REQFILEDDATE') AND FORM.REQFILEDDATE IS NOT "">
	<CFSET FORM.REQFILEDDATE = DateFormat(FORM.REQFILEDDATE, 'DD-MMM-YYYY')>
</CFIF>

<CFQUERY name="GetPurchReqsSubtotal" datasource="#application.type#PURCHASING">
	SELECT	PR.PURCHREQID, PR.SUBTOTAL
	FROM		PURCHREQS PR
	WHERE	PR.PURCHREQID = <CFQUERYPARAM value="#Cookie.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> 
	ORDER BY	PR.PURCHREQID
</CFQUERY>

<CFSET FORM.TOTAL = #GetPurchReqsSubtotal.SUBTOTAL# + #FORM.SHIPPINGCOST#>

<CFQUERY name="ModifyPurchReqs" datasource="#application.type#PURCHASING">
	UPDATE	PURCHREQS
	SET		SERVICEREQUESTNUMBER = '#FORM.SERVICEREQUESTNUMBER#',
			FISCALYEARID = #val(FORM.FISCALYEARID)#,
			REQUESTERID = #val(FORM.REQUESTERID)#,
			PURCHREQUNITID = #val(FORM.PURCHREQUNITID)#,
			FUNDACCTID = #val(FORM.FUNDACCTID)#,
			PURCHASEJUSTIFICATION = UPPER('#FORM.PURCHASEJUSTIFICATION#'),
			RUSH = '#FORM.RUSH#',
			RUSHJUSTIFICATION = UPPER('#FORM.RUSHJUSTIFICATION#'),
               BUDGETTYPEID = #val(FORM.BUDGETTYPEID)#,
			SHIPPINGCOST = #val(FORM.SHIPPINGCOST)#,
			TOTAL = #val(FORM.TOTAL)#,
			REQNUMBER = UPPER('#FORM.REQNUMBER#'),
			SALESORDERNUMBER = UPPER('#FORM.SALESORDERNUMBER#'),
			PONUMBER = UPPER('#FORM.PONUMBER#'),
			VENDORID = #val(FORM.VENDORID)#,
			VENDORCONTACTID = #val(FORM.VENDORCONTACTID)#,
		<CFIF FORM.QUOTEDATE IS NOT "">
			QUOTEDATE = TO_DATE('#FORM.QUOTEDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
		</CFIF>
			QUOTE = UPPER('#FORM.QUOTE#'),
			SPECSCOMMENTS = UPPER('#FORM.SPECSCOMMENTS#'),
			IDTREVIEWERID = #val(FORM.IDTREVIEWERID)#,
		<CFIF FORM.REVIEWDATE IS NOT "">
			REVIEWDATE = TO_DATE('#FORM.REVIEWDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
		</CFIF>
			RECVCOMMENTS = UPPER('#FORM.RECVCOMMENTS#'),
		<CFIF FORM.REQFILEDDATE IS NOT "">
			REQFILEDDATE = TO_DATE('#FORM.REQFILEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
		</CFIF>
			COMPLETEFLAG = UPPER('#FORM.COMPLETEFLAG#'),
			SWFLAG = UPPER('#FORM.SWFLAG#')
	WHERE	PURCHREQID = #val(Cookie.PURCHREQID)#
</CFQUERY>
<H1>Data ADDED!</H1>
<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqaddlegacy.cfm?PROCESS=ADD" />
</CFOUTPUT>

</BODY>
</HTML>