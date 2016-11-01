<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lookupsrpurchreqinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/08/2011 --->
<!--- Date in Production: 12/08/2011 --->
<!--- Module: Look Up Purchase Requisitions Linked To Service Requests --->
<!-- Last modified by John R. Pastori on 12/08/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/lookupsrpurchreqinfo.cfm">
<CFSET CONTENT_UPDATED = "December 08, 2011">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>

	<TITLE>Look Up Purchase Requisitions Linked To Service Requests</TITLE>
     <META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

</HEAD>

<CFOUTPUT>

<BODY>

<!--- 
*************************************************************************************
* The following code looks up Service Request and Purchase Requisition information. *
*************************************************************************************
 --->

<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
     SELECT	SRID, SERVICEREQUESTNUMBER
	FROM		SERVICEREQUESTS
     WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#URL.SRNUMBER#" cfsqltype="CF_SQL_VARCHAR">
     ORDER BY	SERVICEREQUESTNUMBER
</CFQUERY>

<CFQUERY name="LookupPurchReqsSR" datasource="#application.type#PURCHASING">
     SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER
     FROM		PURCHREQS PR
     WHERE	PR.SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#URL.SRNUMBER#" cfsqltype="CF_SQL_VARCHAR">
     ORDER BY	PR.SERVICEREQUESTNUMBER
</CFQUERY>

Requisition IDs: &nbsp;&nbsp;&nbsp;&nbsp;#LookupPurchReqsSR.PURCHREQID#<BR>
URL SR NUMBER: #URL.SRNUMBER#<BR>

<CFIF LookupPurchReqsSR.RecordCount GT 0>
	<META http-equiv="Refresh" TARGET="_parent" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE&LOOKUPPURCHREQ=FOUND&PURCHREQID=#LookupPurchReqsSR.PURCHREQID#&POPUP=YES" />
     <CFEXIT>
<CFELSE>
	<META http-equiv="Refresh" TARGET="_parent" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=ADD&SRID=#LookupServiceRequests.SRID#&POPUP=YES" />
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>