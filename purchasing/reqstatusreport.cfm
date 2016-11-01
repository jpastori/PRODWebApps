<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: reqstatusreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: IDT Purchase Requisitions - Status Report --->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/reqstatusreport.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchase Requisitions - Status Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPURCHREQ')>
	<CFSET CURSORFIELD = "document.LOOKUP.PURCHREQID1.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFSET PROCESSPROGRAM = '/#application.type#apps/purchasing/reqstatusreport.cfm?LOOKUPPURCHREQ=FOUND'>
<CFSET REPORTTITLE = 'IDT Purchase Requisitions - Status Report Lookup'>


<CFIF NOT IsDefined("URL.LOOKUPPURCHREQ")>
	<CFINCLUDE template = "lookuppurchreqs.cfm">
	<CFEXIT>
<CFELSE>

<!--- 
***********************************************************************************************
* The following code is the process for IDT Purchase Requisitions - Status Report generation. *
***********************************************************************************************
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

	<CFQUERY name="ListPurchReqs" datasource="#application.type#PURCHASING">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.CREATIONDATE, PR.FISCALYEARID, PR.REQUESTERID, CUST.FULLNAME, PR.PURCHREQUNITID,
				PR.PURCHASEJUSTIFICATION, PR.RUSH, PR.PURCHASEJUSTIFICATION, PR.RUSH, PR.RUSHJUSTIFICATION, PR.SUBTOTAL, PR.TOTAL, PR.REQNUMBER,
				PR.SALESORDERNUMBER, PR.BUDGETTYPEID, PR.PONUMBER, PR.VENDORID, V.VENDORNAME, PR.VENDORCONTACTID, PR.QUOTEDATE, PR.QUOTE,
				PR.SPECSCOMMENTS, PR.IDTREVIEWERID, PR.REVIEWDATE, PR.RECVCOMMENTS, PR.REQFILEDDATE, PR.COMPLETEFLAG, PR.SWFLAG, PR.COMPLETIONDATE
		FROM		PURCHREQS PR, VENDORS V, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	PR.PURCHREQID = <CFQUERYPARAM value="#FORM.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> AND
				PR.VENDORID = V.VENDORID AND
				PR.REQUESTERID = CUST.CUSTOMERID
		ORDER BY	PR.SERVICEREQUESTNUMBER, PR.REQNUMBER
	</CFQUERY>

	
	<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
				SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID, SR.PROBLEM_CATEGORYID, PC.CATEGORYNAME,
				SR.PROBLEM_SUBCATEGORYID, PSC.SUBCATEGORYNAME, SR.PRIORITYID, SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID,
				SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED,
				SR.SERVICEREQUESTNUMBER || ' - ' || PC.CATEGORYNAME || ' - ' || PSC.SUBCATEGORYNAME AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, PROBLEMCATEGORIES PC, PROBLEMSUBCATEGORIES PSC, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(SR.SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#ListPurchReqs.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				SR.PROBLEM_CATEGORYID = PC.CATEGORYID AND
				SR.PROBLEM_SUBCATEGORYID = PSC.SUBCATEGORYID AND
				SR.REQUESTERID = CUST.CUSTOMERID) AND
				(SRID = 0 OR
				SR.PROBLEM_CATEGORYID = 2)
		ORDER BY	LOOKUPKEY
	</CFQUERY>
     
     <CFQUERY name="LookupBudgetTypes" datasource="#application.type#PURCHASING">
          SELECT	BUDGETTYPEID, BUDGETTYPENAME
          FROM		BUDGETTYPES
          WHERE	BUDGETTYPEID = <CFQUERYPARAM value="#ListPurchReqs.BUDGETTYPEID#" cfsqltype="CF_SQL_NUMERIC">
          ORDER BY	BUDGETTYPENAME
     </CFQUERY>




	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>IDT Purchase Requisitions - Status Report</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" border="0" align="left">
		<TR>
	<CFFORM action="/#application.type#apps/purchasing/reqstatusreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
	</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="7"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" valign="BOTTOM"><STRONG>SR Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Budget Type</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Requisition Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Sales Order Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>P. O. Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Vendor</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Filed Date</STRONG></TH>
		</TR>
		<TR>
			<TD align="CENTER"><DIV>#ListPurchReqs.SERVICEREQUESTNUMBER#</DIV></TD>
			<TD align="CENTER"><DIV>#LookupBudgetTypes.BUDGETTYPENAME#</DIV></TD>
			<TD align="CENTER"><DIV>#ListPurchReqs.REQNUMBER#</DIV></TD>
			<TD align="CENTER"><DIV>#ListPurchReqs.SALESORDERNUMBER#</DIV></TD>
			<TD align="CENTER"><DIV>#ListPurchReqs.PONUMBER#</DIV></TD>
			<TD align="CENTER"><DIV>#ListPurchReqs.VENDORNAME#</DIV></TD>
			<TD align="CENTER"><DIV>#DateFormat(ListPurchReqs.REQFILEDDATE, 'MM/DD/YYYY')#</DIV></TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="BOTTOM" colspan="4"><STRONG>Receiving Comments</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Requester</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Completed</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Completion Date</STRONG></TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><DIV>#ListPurchReqs.RECVCOMMENTS#</DIV></TD>
			<TD align="CENTER"><DIV>#ListPurchReqs.FULLNAME#</DIV></TD>
			<TD align="CENTER"><DIV>#ListPurchReqs.COMPLETEFLAG#</DIV></TD>
			<TD align="CENTER"><DIV>#DateFormat(ListPurchReqs.COMPLETIONDATE, 'MM/DD/YYYY')#</DIV></TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="7"><HR align="left" width="100%" /></TD>
		</TR>
		<TR>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Line Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Line Qty</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM" colspan="2"><STRONG>Line Part Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM" colspan="2"><STRONG>Line Description</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Received Date</STRONG></TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="7"><HR align="left" width="100%" /></TD>
		</TR>
	
	<CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING">
		SELECT	PURCHREQLINEID, PURCHREQID, LINENUMBER, LINEQTY, LINEDESCRIPTION, PARTNUMBER, RECVDDATE, LICENSESTATUSID
		FROM		PURCHREQLINES
		WHERE	PURCHREQID = <CFQUERYPARAM value="#ListPurchReqs.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	PURCHREQID, LINENUMBER
	</CFQUERY>
	
	<CFLOOP query="LookupPurchReqLines">
		<TR>
			<TD align="CENTER"><DIV>&nbsp;#NumberFormat(LookupPurchReqLines.LINENUMBER, '__')#</DIV></TD>
			<TD align="CENTER"><DIV>&nbsp;#NumberFormat(LookupPurchReqLines.LINEQTY, '____')#</DIV></TD>
			<TD align="CENTER" colspan="2" valign="TOP"><DIV>#LookupPurchReqLines.PARTNUMBER#</DIV></TD>
			<TD align="left" colspan="2" nowrap><DIV>#LookupPurchReqLines.LINEDESCRIPTION#</DIV></TD>
			<TD align="CENTER"><DIV>#LookupPurchReqLines.RECVDDATE#</DIV></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TD align="LEFT" colspan="7"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
	<CFFORM action="/#application.type#apps/purchasing/reqstatusreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
	</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="7"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>