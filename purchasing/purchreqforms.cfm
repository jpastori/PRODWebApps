<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: purchreqforms.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/10/2012 --->
<!--- Date in Production: 05/10/2012 --->
<!--- Module: IDT Purchase Requisitions - Lookup Purchase Requisitions for Reports--->
<!-- Last modified by John R. Pastori on 04/20/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/purchreqforms.cfm">
<CFSET CONTENT_UPDATED = "April 20, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchase Requisitions - Purchase Forms Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPURCHREQ')>
	<CFSET CURSORFIELD = "document.LOOKUP.PURCHREQID1.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFSET PROCESSPROGRAM = '/#application.type#apps/purchasing/purchreqforms.cfm?LOOKUPPURCHREQ=FOUND'>
<CFSET REPORTTITLE = 'IDT Purchase Requisitions - Purchase Forms Report Lookup'>
<CFSET REPORTTYPE = 'FORMS REPORT'>

<CFIF NOT IsDefined('URL.LOOKUPPURCHREQ')>
	<CFINCLUDE template = "lookuppurchreqs.cfm">
	<CFEXIT>
<CFELSE>

<!--- 
*******************************************************************************************************
* The following code is the process for IDT Purchase Requisitions - Purchase Forms Report generation. *
*******************************************************************************************************
 --->

	<CFIF FORM.PURCHREQID1 GT 0>
		<CFSET FORM.PURCHREQID = FORM.PURCHREQID1>
	<CFELSEIF FORM.PURCHREQID2 GT 0>
		<CFSET FORM.PURCHREQID = FORM.PURCHREQID2>
     <CFELSEIF FORM.PURCHREQID3 GT 0>
		<CFSET FORM.PURCHREQID = FORM.PURCHREQID3>
     <CFELSEIF FORM.PURCHREQID4 GT 0>
		<CFSET FORM.PURCHREQID = FORM.PURCHREQID4>
	<CFELSE>
		<CFSET FORM.PURCHREQID = FORM.PURCHREQID5>
	</CFIF>
     
 	<CFIF IsDefined('URL.REPORTCHOICE')>
     	<CFSET FORM.REPORTCHOICE = URL.REPORTCHOICE>
     </CFIF>	
	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'REVRU.UNITNAME~ REVIEWERNAME'>
	<CFSET SORTORDER[2] = 'REVRU.UNITNAME~ REVIEWERNAME'>
	<CFSET SORTORDER[3] = 'PRU.UNITNAME~ CUST.FULLNAME'>
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>

	<CFIF FIND('~', #REPORTORDER#, 1) NEQ 0>
		<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>
	</CFIF>

	
	<CFQUERY name="ListPurchReqs" datasource="#application.type#PURCHASING">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.CREATIONDATE, PR.FISCALYEARID, PR.REQUESTERID, CUST.FULLNAME,
				PR.PURCHREQUNITID, PRU.UNITNAME, PR.FUNDACCTID, FA.FUNDACCTNAME, PR.PURCHASEJUSTIFICATION, PR.RUSH,
				PR.PURCHASEJUSTIFICATION, PR.RUSH, PR.RUSHJUSTIFICATION, PR.SUBTOTAL, PR.SHIPPINGCOST, PR.TOTAL, PR.REQNUMBER,
				PR.SALESORDERNUMBER, PR.BUDGETTYPEID, PR.PONUMBER, PR.VENDORID, PR.VENDORCONTACTID, PR.QUOTEDATE, PR.QUOTE,
				PR.SPECSCOMMENTS, PR.IDTREVIEWERID, REVR.FULLNAME AS REVIEWERNAME, REVRU.UNITNAME AS REVIEWERUNIT, PR.REVIEWDATE,
				PR.RECVCOMMENTS, PR.REQFILEDDATE, PR.COMPLETEFLAG, PR.SWFLAG
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS PRU, LIBSHAREDDATAMGR.CUSTOMERS REVR, LIBSHAREDDATAMGR.UNITS REVRU,
				FUNDACCTS FA
		WHERE	PR.PURCHREQID = <CFQUERYPARAM value="#FORM.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> AND
				PR.REQUESTERID = CUST.CUSTOMERID AND
				PR.PURCHREQUNITID = PRU.UNITID AND
				PR.IDTREVIEWERID = REVR.CUSTOMERID AND
				REVR.UNITID = REVRU.UNITID AND
				PR.FUNDACCTID = FA.FUNDACCTID
		ORDER BY	#REPORTORDER#
	</CFQUERY>
     
     <CFQUERY name="LookupBudgetTypes" datasource="#application.type#PURCHASING">
          SELECT	BUDGETTYPEID, BUDGETTYPENAME
          FROM		BUDGETTYPES
          WHERE	BUDGETTYPEID = <CFQUERYPARAM value="#ListPurchReqs.BUDGETTYPEID#" cfsqltype="CF_SQL_NUMERIC">
          ORDER BY	BUDGETTYPENAME
     </CFQUERY>


	<CFSWITCH expression = #FORM.REPORTCHOICE#>
		<CFCASE value = 1>
			<CFINCLUDE template="purchrequistnrequest.cfm">
		</CFCASE>
		<CFCASE value = 2>
			<CFINCLUDE template="internalpurchreqreport.cfm">
		</CFCASE>
		<CFCASE value = 3>
			<CFINCLUDE template="unithwswpurchasereport.cfm">
		</CFCASE>
		<CFDEFAULTCASE>
			<CFINCLUDE template="purchrequistnrequest.cfm">
		</CFDEFAULTCASE>
	</CFSWITCH>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>