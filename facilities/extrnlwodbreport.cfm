<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: extrnlwodbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012 --->
<!--- Module: Facilities - External WO Provided Info Report --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/extrnlwodbreport.cfm">
<CFSET CONTENT_UPDATED = "February 10, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - External WO Provided Info Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<BODY>

<CFOUTPUT>

<CFSET LINEITEMCOUNT = 0>
<CFSET FYCHANGE = "">

<CFQUERY name="ListExternalWorkRequestInfo" datasource="#application.type#FACILITIES">
	SELECT	EWOI.EXTERNLWOID, WR.FISCALYEARID, FY.FISCALYEAR_4DIGIT, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.WORKREQUESTID, WR.WORKREQUESTNUMBER,
			TO_CHAR(WR.REQUESTDATE, 'MM/DD/YYYY') AS REQUESTDATE, WR.REQUESTERID, REQCUST.LASTNAME, REQCUST.FIRSTNAME, REQCUST.CAMPUSPHONE, WR.UNITID, UNITS.UNITNAME,
			WR.LOCATIONID, LOC.ROOMNUMBER, WR.PROBLEMDESCRIPTION, WR.REQUESTSTATUSID, RS.REQUESTSTATUSNAME, WR.KEYREQUEST, WR.MOVEREQUEST, WR.TNSREQUEST,
			EWOI.SHOPSWONUM, TO_CHAR(EWOI.DATESENT, 'MM/DD/YYYY') AS DATESENT, EWOI.SHOPCOMMENTS, EWOI.EXTERNLSHOPID, ES.EXTERNLSHOPNAME,
			TO_CHAR(EWOI.DATESTARTED, 'MM/DD/YYYY') AS DATESTARTED, EWOI.LABORCOST, EWOI.ITEMCOST, EWOI.TAX, EWOI.TOTCHRGBACK,
			TO_CHAR(EWOI.BILLINGDATE, 'MM/DD/YYYY') AS BILLINGDATE, FY.FISCALYEAR_4DIGIT || ' - ' || WR.WORKREQUESTNUMBER || ' - ' || EWOI.SHOPSWONUM || ' - ' || DATESENT AS LOOKUPKEY
	FROM		EXTERNLWOINFO EWOI, WORKREQUESTS WR, EXTERNLSHOPS ES, LIBSHAREDDATAMGR.FISCALYEARS FY, REQUESTTYPES RT, REQUESTSTATUS RS,
			LIBSHAREDDATAMGR.CUSTOMERS REQCUST, LIBSHAREDDATAMGR.UNITS UNITS, LOCATIONS LOC
	WHERE	EWOI.EXTERNLWOID > 0 AND 
			EWOI.WORKREQUESTID = WR.WORKREQUESTID AND
			EWOI.EXTERNLSHOPID = ES.EXTERNLSHOPID AND
			WR.FISCALYEARID = FY.FISCALYEARID AND
			WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
			WR.REQUESTSTATUSID = RS.REQUESTSTATUSID AND
			WR.REQUESTERID = REQCUST.CUSTOMERID AND
			WR.UNITID = UNITS.UNITID AND
			WR.LOCATIONID = LOC.LOCATIONID
	ORDER BY	LOOKUPKEY
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - External WO Provided Info Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" align="LEFT" border="0">
	<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
		<TD align="LEFT" valign="TOP" colspan="8">
			<INPUT type="SUBMIT" value="Cancel" tabindex="1" />
		</TD>
</CFFORM>
	</TR>
</TABLE>
<BR /><BR />
<TABLE width="100%" align="LEFT" border="1">
	<TR>
		<TH align="CENTER" colspan="8"><H2>#ListExternalWorkRequestInfo.RecordCount# External Work Request records were selected.</H2></TH>
	</TR>

<CFLOOP query="ListExternalWorkRequestInfo">

	<CFIF #FYCHANGE# NEQ #ListExternalWorkRequestInfo.FISCALYEAR_4DIGIT#>
		<CFSET FYCHANGE = #ListExternalWorkRequestInfo.FISCALYEAR_4DIGIT#>
	<TR>
		<TD colspan="8"><HR width="100%" size="5" noshade /></TD>
	</TR>
	<TR>
		<TH align="CENTER" colspan="4"><H3>FY #ListExternalWorkRequestInfo.FISCALYEAR_4DIGIT#</H3></TH>
		<TH align="CENTER" colspan="3"><H3>Requester or Contact Information</H3></TH>
		<TH align="CENTER"><H3>Location of Work</H3></TH>
	</TR>
	<CFELSE>
	<TR>
		<TD colspan="8"><HR size="2" noshade></TD>
	</TR>
	</CFIF>

	<CFSET LINEITEMCOUNT = #LINEITEMCOUNT# + 1>
	<TR>
		<TH align="center" valign="BOTTOM">Line Item</TH>
		<TH align="center" valign="BOTTOM">Request Type</TH>
		<TH align="center" valign="BOTTOM">Work Request <BR />Request Number</TH>
		<TH align="center" valign="BOTTOM">Request Date</TH>
		<TH align="center" valign="BOTTOM" nowrap="nowrap">Requester <BR />Name</TH>
		<TH align="center" valign="BOTTOM">Phone</TH>
		<TH align="center" valign="BOTTOM">Lib Unit or <BR />NL+ Area</TH>
		<TH align="center" valign="BOTTOM">Building-Room</TH>
	</TR>
	<TR>
		<TD align="center" valign="TOP"><DIV>#LINEITEMCOUNT#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.REQUESTTYPENAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.WORKREQUESTNUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DateFormat(ListExternalWorkRequestInfo.REQUESTDATE, "MM/DD/YYYY")#</DIV></TD>
		<TD align="center" valign="TOP">
			<DIV>#ListExternalWorkRequestInfo.LASTNAME#, <BR />#ListExternalWorkRequestInfo.FIRSTNAME#</DIV>
		</TD>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.CAMPUSPHONE#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.UNITNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.ROOMNUMBER#</DIV></TD>
	</TR>
	<TR>
		<TH align="center" valign="BOTTOM" colspan="2">Problem <BR /> Description</TH>
		<TH align="center" valign="BOTTOM">Request Status</TH>
		<TH align="center" valign="BOTTOM">Key Request?</TH>
		<TH align="center" valign="BOTTOM">Move Request?</TH>
		<TH align="center" valign="BOTTOM" nowrap="nowrap">TNS Request?</TH>
		<TH align="center" valign="BOTTOM" colspan="2">Shop <BR /> Comments</TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP" colspan="2"><DIV>#ListExternalWorkRequestInfo.PROBLEMDESCRIPTION#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.REQUESTSTATUSNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.KEYREQUEST#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.MOVEREQUEST#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.TNSREQUEST#</DIV></TD>
		<TD align="left" valign="TOP" colspan="2"><DIV>#ListExternalWorkRequestInfo.SHOPCOMMENTS#</DIV></TD>
	</TR>
	<TR>
		<TH align="center" valign ="BOTTOM">External Shops</TH>
		<TH align="center" valign="BOTTOM">Shops WO Number</TH>
		<TH align="center" valign="BOTTOM">Date Sent</TH>
		<TH align="center" valign ="BOTTOM">Date Started</TH>
		<TH align="center" valign ="BOTTOM">Labor Cost</TH>
		<TH align="center" valign ="BOTTOM">Item Cost <BR />w/ Tax</TH>
		<TH align="center" valign ="BOTTOM" nowrap="nowrap">Total Charge Back <BR />To Library</TH>
		<TH align="center" valign ="BOTTOM">Billing Date</TH>
	</TR>
	<TR>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.EXTERNLSHOPNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListExternalWorkRequestInfo.SHOPSWONUM#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DateFormat(ListExternalWorkRequestInfo.DATESENT, "MM/DD/YYYY")#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DateFormat(ListExternalWorkRequestInfo.DATESTARTED, "MM/DD/YYYY")#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DollarFormat(ListExternalWorkRequestInfo.LABORCOST)#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DollarFormat(ListExternalWorkRequestInfo.ITEMCOST + ListExternalWorkRequestInfo.TAX)#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DollarFormat(ListExternalWorkRequestInfo.TOTCHRGBACK)#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DateFormat(ListExternalWorkRequestInfo.BILLINGDATE, "MM/DD/YYYY")#</DIV></TD>
	</TR>

</CFLOOP>
	<TR>
		<TD colspan="8"><HR width="100%" size="5" noshade /></TD>
	</TR>
	<TR>
		<TH align="CENTER" colspan="8"><H2>#ListExternalWorkRequestInfo.RecordCount# External Work Request records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
		<TD align="LEFT" valign="TOP" colspan="8">
			<INPUT type="SUBMIT" value="Cancel" tabindex="2" />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="8"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>

</CFOUTPUT>
</BODY>
</HTML>