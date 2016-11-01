<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: womoveitemrequestsreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012--->
<!--- Module: Facilities - Work Orders - MoveItems Requests Report --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/womoveitemrequestsreport.cfm">
<CFSET CONTENT_UPDATED = "February 10, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Work Orders - Move Item Requests Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<CFOUTPUT>
<CFSET session.TNSREQUEST = ''>
<CFSET MOVECOUNT = 0>
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Work Orders - Move Item Requests Report</H1></TD>
	</TR>
</TABLE>
<BR>
<TABLE width="100%" align="LEFT" border="0">
	<TR>
<CFFORM action="/#application.type#apps/facilities/workrequestreports.cfm?PROCESS=REPORT" method="POST">
		<TD align="left"><INPUT type="submit" value="Cancel" tabindex="1"></TD>
</CFFORM>
	</TR>
	
<CFLOOP query="ListWorkRequests">
	<CFQUERY name="ListMoveItemsRequests" datasource="#application.type#FACILITIES">
		SELECT	MR.MOVEREQUESTID, MR.MOVEREQUESTWRID, MR.MOVETYPEID, MT.MOVETYPENAME, MR.ADDITIONALMOVEDESCRIPTION, MR.ITEMNAME, MR.ITEMDESCRIPTION,
				MR.STATENUMBER, MR.PICKUPDATE, MR.DELIVERYDATE, MR.NUMBEROFBOXES, MR.NUMBEROFCHAIRS, MR.NUMBEROFTABLES, MR.ESTIMATEONLY,
				MR.FROMROOMID, FROMBN.BUILDINGNAME AS FROMBUILDING, FROMLOC.ROOMNUMBER AS FROMROOM, MR.FROMJACKNUMBERID, 
				FROMWJ.WALLDIRECTION || ' - ' || FROMWJ.JACKNUMBER || ' - ' || FROMWJ.PORTNUMBER AS FROMJACK,
				MR.TOROOMID, TOBN.BUILDINGNAME AS TOBUILDING, TOLOC.ROOMNUMBER AS TOROOM, MR.TOJACKNUMBERID, 
				TOWJ.WALLDIRECTION || ' - ' || TOWJ.JACKNUMBER || ' - ' || TOWJ.PORTNUMBER AS TOJACK
		FROM		MOVEITEMS MI, MOVETYPES MT, LOCATIONS FROMLOC, BUILDINGNAMES FROMBN, WALLJACKS FROMWJ, LOCATIONS TOLOC, BUILDINGNAMES TOBN, WALLJACKS TOWJ
		WHERE	(MR.MOVEREQUESTWRID = <CFQUERYPARAM value="#ListWorkRequests.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				MR.MOVETYPEID = MT.MOVETYPEID AND
				MR.FROMROOMID = FROMLOC.LOCATIONID AND
				FROMLOC.BUILDINGNAMEID = FROMBN.BUILDINGNAMEID AND
				MR.FROMJACKNUMBERID = FROMWJ.WALLJACKID AND
				MR.TOROOMID = TOLOC.LOCATIONID AND
				TOLOC.BUILDINGNAMEID = TOBN.BUILDINGNAMEID AND
				MR.TOJACKNUMBERID = TOWJ.WALLJACKID) AND
				(
		<CFIF #FORM.MOVETYPEID# GT 0>
			<CFIF IsDefined("FORM.NEGATEMOVETYPEID")>
				NOT MR.MOVETYPEID = #val(FORM.MOVETYPEID)# #LOGICANDOR#
			<CFELSE>
				MR.MOVETYPEID = #val(FORM.MOVETYPEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

				MR.MOVEREQUESTWRID #FINALTEST# '0')
		ORDER BY	MR.MOVEREQUESTWRID, MR.MOVEREQUESTID
	</CFQUERY>
 
<CFIF #ListMoveItemsRequests.RecordCount# GT 0>
	<TR>
		<TH align="center" valign="TOP" colspan="2">Work Order Number</TH>
		<TH align="center" valign="TOP">Request Date</TH>
		<TH align="center" valign="TOP" colspan="3">Request Type</TH>
		<TH align="center" valign="TOP" colspan="2">Request Status</TH>
		<TH align="center" valign="TOP" colspan="2">Requester Name</TH>
		<TH align="center" valign="TOP" colspan="2">Unit Name</TH>
		<TH align="center" valign="TOP">Room Number</TH>
<!--- 
		<TH align="left" valign="TOP" colspan="2">Unit Head <BR> Approval Date</TH>
		<TH align="left" valign="TOP" colspan="2">Management Approval Date</TH>
 --->
	</TR>
	<TR>
		<TD align="center" valign="TOP" colspan="2"><DIV>#ListWorkRequests.WORKORDERNUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DateFormat(ListWorkRequests.REQUESTDATE, "MM/DD/YYYY")#</DIV></TD>
		<TD align="center" valign="TOP" colspan="3"><DIV>#ListWorkRequests.REQUESTTYPENAME#</DIV></TD>
		<TD align="left" valign="TOP" colspan="2"><DIV>#ListWorkRequests.REQUESTSTATUSNAME#</DIV></TD>
		<TD align="left" valign="TOP" colspan="2"><DIV>#ListWorkRequests.RCNAME#</DIV></TD>
		<TD align="center" valign="TOP" colspan="2"><DIV>#ListWorkRequests.UNITNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListWorkRequests.ROOMNUMBER#</DIV></TD>
<!--- 
		<TD align="left" valign="TOP" colspan="2"><DIV>#DateFormat(ListWorkRequests.SUPAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
		<TD align="left" valign="TOP" colspan="2"><DIV>#DateFormat(ListWorkRequests.MGMTAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
 --->
	</TR>

	<CFIF FIND('TNS', #ListWorkRequests.REQUESTTYPENAME#, 1) NEQ 0>

		<CFQUERY name="LookupCustomers" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.UNITID, CUST.LOCATIONID, CUST.CAMPUSPHONE, CUST.NUMBERLISTED, CUST.SECONDCAMPUSPHONE, 
					CUST.DIALINGCAPABILITY, CUST.FAX, CUST.LONGDISTAUTHCODE
			FROM		CUSTOMERS CUST
			WHERE	CUST.CUSTOMERID = #val(ListWorkRequests.REQUESTERID)#
			ORDER BY	CUST.CUSTOMERID
		</CFQUERY>

	<TR>
		<TH align="left" valign="TOP" colspan="2">Campus Phone Number:</TH>
		<TD align="left" valign="TOP"><DIV>#LookupCustomers.CAMPUSPHONE#</DIV></TD>
		<TH align="left" valign="TOP">Number Listed?:</TH>
		<TD align="left" valign="TOP"><DIV>#LookupCustomers.NUMBERLISTED#</DIV></TD>
		<TH align="left" valign="TOP" colspan="2">2nd Campus Phone Number:</TH>
		<TD align="left" valign="TOP"><DIV>#LookupCustomers.SECONDCAMPUSPHONE#</DIV></TD>
		<TH align="left" valign="TOP">Dialing Capability:</TH>
		<TD align="left" valign="TOP" colspan="2"><DIV>#LookupCustomers.DIALINGCAPABILITY#</DIV></TD>
		<TH align="left" valign="TOP">Fax Number:</TH>
		<TD align="left" valign="TOP"><DIV>#LookupCustomers.FAX#</DIV></TD>
		<TH align="left" valign="TOP" colspan="2">Long Distance Authorization Code?:</TH>
		<TD align="left" valign="TOP"><DIV>#LookupCustomers.LONGDISTAUTHCODE#</DIV></TD>
	</TR>
	</CFIF>

	


	<CFLOOP query="ListMoveItemsRequests">
	<CFSET MOVECOUNT = MOVECOUNT + 1>

	<TR>
		<TH align="left" valign="BOTTOM" colspan="3">Move Type</TH>
		<TH align="left" valign="BOTTOM">Item Name</TH>
	<CFIF FIND('TNS', #ListWorkRequests.REQUESTTYPENAME#, 1) NEQ 0>
		<CFSET session.TNSREQUEST = 'YES'>
		<TH align="left" valign="BOTTOM" colspan="2">From Building/Room</TH>
		<TH align="left" valign="BOTTOM" colspan="3">From Jack Number</TH>
		<TH align="left" valign="BOTTOM" colspan="2">To Building/Room</TH>
		<TH align="left" valign="BOTTOM" colspan="3">To Jack Number</TH>
	<CFELSE>
		<CFSET session.TNSREQUEST = 'NO'>
		<TH align="center" valign="BOTTOM" colspan="2">Pickup Room Number</TH>
		<TH align="center" valign="BOTTOM" colspan="2">Destination Room Number</TH>
		<TH align="center" valign="BOTTOM">Pickup Date</TH>
		<TH align="center" valign="BOTTOM">Delivery Date</TH>
		<TH align="center" valign="BOTTOM">Number Of Boxes</TH>
		<TH align="center" valign="BOTTOM">Number Of Chairs</TH>
		<TH align="center" valign="BOTTOM">Number Of Tables</TH>
	</CFIF>
		<TH align="center" valign="BOTTOM">State Number</TH>
		<TH align="center" valign="BOTTOM">Estimate Only?</TH>
	</TR>

	
	<TR>
		<TD align="left" valign="TOP" colspan="3"><DIV>#ListMoveItemsRequests.MOVETYPENAME#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListMoveItemsRequests.ITEMNAME#</DIV></TD>
	<CFIF session.TNSREQUEST EQ 'YES'>
		<TD align="left" valign="TOP" colspan="2">
			<DIV>#ListMoveItemsRequests.FROMBUILDING#/#ListMoveItemsRequests.FROMROOM#</DIV>
		</TD>
		<TD align="left" valign="TOP" colspan="3"><DIV>#ListMoveItemsRequests.FROMJACK#</DIV></TD>
		<TD align="left" valign="TOP" colspan="2">
			<DIV>#ListMoveItemsRequests.TOBUILDING#/#ListMoveItemsRequests.TOROOM#</DIV>
		</TD>
		<TD align="left" valign="TOP" colspan="3"><DIV>#ListMoveItemsRequests.TOJACK#</DIV></TD>
	<CFELSE>
		<TD align="center" valign="TOP" colspan="2"><DIV>#ListMoveItemsRequests.FROMROOM#</DIV></TD>
		<TD align="center" valign="TOP" colspan="2"><DIV>#ListMoveItemsRequests.TOROOM#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DateFormat(ListMoveItemsRequests.PICKUPDATE, "MM/DD/YYYY")#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#DateFormat(ListMoveItemsRequests.DELIVERYDATE, "MM/DD/YYYY")#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#ListMoveItemsRequests.NUMBEROFBOXES#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListMoveItemsRequests.NUMBEROFCHAIRS#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#ListMoveItemsRequests.NUMBEROFTABLES#</DIV></TD>
	</CFIF>
		<TD align="center" valign="TOP"><DIV>#ListMoveItemsRequests.STATENUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListMoveItemsRequests.ESTIMATEONLY#</DIV></TD>
	</TR>
	<TR>
		<TH align="left" valign="MIDDLE">Additional Move Description:</TH>
		<TD align="left" valign="TOP" colspan="8"><DIV>#ListMoveItemsRequests.ADDITIONALMOVEDESCRIPTION#</DIV></TD>
		<TH align="left" valign="MIDDLE">Item Description:</TH>
		<TD align="left" valign="TOP" colspan="8"><DIV>#ListMoveItemsRequests.ITEMDESCRIPTION#</DIV></TD>
	</TR>
	</CFLOOP>
	<TR>
		<TD colspan="18"><HR width="100%" size="5" noshade></TD>
	</TR>
</CFIF>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="18"><H2>#MOVECOUNT# Work Order Move Records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/facilities/workrequestreports.cfm?PROCESS=REPORT" method="POST">
		<TD align="left"><INPUT type="submit" value="Cancel" tabindex="2"></TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="22"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>
</BODY>
</HTML>