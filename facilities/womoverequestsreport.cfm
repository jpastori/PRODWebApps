<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: womoverequestsreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012 --->
<!--- Module: Facilities - Work Requests - Move Requests Report --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/womoverequestsreport.cfm">
<CFSET CONTENT_UPDATED = "February 08, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Work Requests - Move Requests Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<CFOUTPUT>
<CFSET session.TNSREQUEST = ''>
<CFSET MOVECOUNT = 0>
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Work Requests - Move Requests Report</H1></TD>
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
	<CFQUERY name="ListMoveRequests" datasource="#application.type#FACILITIES">
		SELECT	MR.MOVEREQUESTID, MR.MOVEREQUESTWRID, MR.MOVETYPEID, MT.MOVETYPENAME, MR.ITEMDESCRIPTION, MR.STATENUMBER,
				MR.PICKUPDATE, MR.DELIVERYDATE, MR.NUMBEROFBOXES, MR.NUMBEROFCHAIRS, MR.NUMBEROFTABLES, MR.ESTIMATEONLY,
				MR.FROMROOMID, FROMBN.BUILDINGNAME AS FROMBUILDING, FROMLOC.ROOMNUMBER AS FROMROOM, MR.FROMJACKNUMBERID,
				FROMWD.WALLDIRNAME || ' - ' || FROMWJ.JACKNUMBER || ' - ' || FROMWJ.PORTNUMBER AS FROMJACK,
				MR.TOROOMID, TOBN.BUILDINGNAME AS TOBUILDING, TOLOC.ROOMNUMBER AS TOROOM, MR.TOJACKNUMBERID,
				TOWD.WALLDIRNAME || ' - ' || TOWJ.JACKNUMBER || ' - ' || TOWJ.PORTNUMBER AS TOJACK
		FROM		MOVEREQUESTS MR, MOVETYPES MT, LOCATIONS FROMLOC, BUILDINGNAMES FROMBN, WALLJACKS FROMWJ, WALLDIRECTION FROMWD,
          		LOCATIONS TOLOC, BUILDINGNAMES TOBN, WALLJACKS TOWJ, WALLDIRECTION TOWD
		WHERE	(MR.MOVEREQUESTWRID = <CFQUERYPARAM value="#ListWorkRequests.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				MR.MOVETYPEID = MT.MOVETYPEID AND
				MR.FROMROOMID = FROMLOC.LOCATIONID AND
				FROMLOC.BUILDINGNAMEID = FROMBN.BUILDINGNAMEID AND
				MR.FROMJACKNUMBERID = FROMWJ.WALLJACKID AND
                    FROMWJ.WALLDIRID = FROMWD.WALLDIRID AND
				MR.TOROOMID = TOLOC.LOCATIONID AND
				TOLOC.BUILDINGNAMEID = TOBN.BUILDINGNAMEID AND
				MR.TOJACKNUMBERID = TOWJ.WALLJACKID AND
                    TOWJ.WALLDIRID = TOWD.WALLDIRID) AND
				(
		<CFIF #FORM.MOVETYPEID# GT 0>
			<CFIF IsDefined("FORM.NEGATEMOVETYPEID")>
				NOT MR.MOVETYPEID = <CFQUERYPARAM value="#FORM.MOVETYPEID#" cfsqltype="CF_SQL_NUMERIC"> #LOGICANDOR#
			<CFELSE>
				MR.MOVETYPEID = <CFQUERYPARAM value="#FORM.MOVETYPEID#" cfsqltype="CF_SQL_NUMERIC"> #LOGICANDOR#
			</CFIF>
		</CFIF>

				MR.MOVEREQUESTWRID #FINALTEST# '0')
		ORDER BY	MR.MOVEREQUESTWRID, MR.MOVEREQUESTID
	</CFQUERY>
<CFIF #ListMoveRequests.RecordCount# GT 0>
	<TR>
		<TH align="center" valign="TOP"> Work Request Number</TH>
		<TH align="center" valign="TOP">Request Date</TH>
		<TH align="center" valign="TOP" colspan="2">Request Type</TH>
		<TH align="center" valign="TOP">Request Status</TH>
		<TH align="center" valign="TOP">Requester Name</TH>
		<TH align="center" valign="TOP">Unit Name</TH>
		<TH align="center" valign="TOP">Room Number</TH>
<!--- 
		<TH align="left" valign="TOP">Unit Head <BR> Approval Date</TH>
 --->
	</TR>
	<TR>
		<TD align="center" valign="TOP"><DIV>#ListWorkRequests.WORKREQUESTNUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DateFormat(ListWorkRequests.REQUESTDATE, "MM/DD/YYYY")#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListWorkRequests.REQUESTTYPENAME#</DIV></TD>
		<TD align="left" valign="TOP" colspan="2"><DIV>#ListWorkRequests.REQUESTSTATUSNAME#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListWorkRequests.RCNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListWorkRequests.UNITNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListWorkRequests.ROOMNUMBER#</DIV></TD>
<!--- 
		<TD align="left" valign="TOP"><DIV>#DateFormat(ListWorkRequests.SUPAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
 --->
 	</TR>

	<CFLOOP query="ListMoveRequests">
	<CFSET MOVECOUNT = MOVECOUNT + 1>

	<TR>
		<TH align="left" valign="BOTTOM">Move Type</TH>
	<CFIF FIND('TNS', #ListWorkRequests.REQUESTTYPENAME#, 1) NEQ 0>
		<CFSET session.TNSREQUEST = 'YES'>
		<TH align="left" valign="BOTTOM">From Building/Room</TH>
		<TH align="left" valign="BOTTOM">From Jack Number</TH>
		<TH align="left" valign="BOTTOM">To Building/Room</TH>
		<TH align="left" valign="BOTTOM">To Jack Number</TH>
	<CFELSE>
		<CFSET session.TNSREQUEST = 'NO'>
		<TH align="center" valign="BOTTOM">Pickup Room Number</TH>
		<TH align="center" valign="BOTTOM">Destination Room Number</TH>
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
		<TD align="left" valign="TOP"><DIV>#ListMoveRequests.MOVETYPENAME#</DIV></TD>
	<CFIF session.TNSREQUEST EQ 'YES'>
		<TD align="left" valign="TOP">
			<DIV>#ListMoveRequests.FROMBUILDING#/#ListMoveRequests.FROMROOM#</DIV>
		</TD>
		<TD align="left" valign="TOP"><DIV>#ListMoveRequests.FROMJACK#</DIV></TD>
		<TD align="left" valign="TOP">
			<DIV>#ListMoveRequests.TOBUILDING#/#ListMoveRequests.TOROOM#</DIV>
		</TD>
		<TD align="left" valign="TOP"><DIV>#ListMoveRequests.TOJACK#</DIV></TD>
	<CFELSE>
		<TD align="center" valign="TOP"><DIV>#ListMoveRequests.FROMROOM#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListMoveRequests.TOROOM#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DateFormat(ListMoveRequests.PICKUPDATE, "MM/DD/YYYY")#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#DateFormat(ListMoveRequests.DELIVERYDATE, "MM/DD/YYYY")#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#ListMoveRequests.NUMBEROFBOXES#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListMoveRequests.NUMBEROFCHAIRS#</DIV></TD>
		<TD align="center" valign="TOP" nowrap><DIV>#ListMoveRequests.NUMBEROFTABLES#</DIV></TD>
	</CFIF>
		<TD align="center" valign="TOP"><DIV>#ListMoveRequests.STATENUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListMoveRequests.ESTIMATEONLY#</DIV></TD>
	</TR>
	<TR>
		<TH align="left" valign="MIDDLE">Item Description:</TH>
		<TD align="left" valign="TOP" colspan="10"><DIV>#ListMoveRequests.ITEMDESCRIPTION#</DIV></TD>
	</TR>
	</CFLOOP>
	<TR>
		<TD colspan="10"><HR width="100%" size="5" noshade></TD>
	</TR>
</CFIF>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="10"><H2>#MOVECOUNT# Work Request Move Request Records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/facilities/workrequestreports.cfm?PROCESS=REPORT" method="POST">
		<TD align="left"><INPUT type="submit" value="Cancel" tabindex="2"></TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="10"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>
</BODY>
</HTML>