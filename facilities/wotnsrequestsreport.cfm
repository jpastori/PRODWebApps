<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: wotnsrequestsreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/17/2012 --->
<!--- Date in Production: 06/17/2012 --->
<!--- Module: Facilities - Work Requests - TNS Requests Report --->
<!-- Last modified by John R. Pastori on 06/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/wotnsrequestsreport.cfm">
<CFSET CONTENT_UPDATED = "June 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Work Requests - TNS Requests Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<CFOUTPUT>
<CFSET TNSCOUNT = 0>
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Work Requests - TNS Requests Report</H1></TD>
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
	<CFQUERY name="ListTNSRequests" datasource="#application.type#FACILITIES">
		SELECT	TR.TNSREQUESTID, TR.TNSREQUESTWRID, TR.ROOMID, LOC.LOCATIONNAME, TR.JACKNUMBERID, TR.CAMPUSPHONE, TR.DIALINGCAPABILITY, 
				TR.LONGDISTAUTHCODE, TR.NUMBERLISTED, TR.ESTIMATEONLY, WJ.WALLDIRID, WD.WALLDIRNAME || ' - ' || WJ.JACKNUMBER || ' - ' || WJ.PORTLETTER AS JACK
		FROM		TNSREQUESTS TR, LOCATIONS LOC, WALLJACKS WJ, WALLDIRECTION WD
		WHERE	TR.TNSREQUESTWRID = <CFQUERYPARAM value="#ListWorkRequests.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				TR.ROOMID = LOC.LOCATIONID AND
				TR.JACKNUMBERID = WJ.WALLJACKID AND
                    WJ.WALLDIRID = WD.WALLDIRID	
		ORDER BY	TR.TNSREQUESTWRID, TR.ROOMID
	</CFQUERY>
<CFIF #ListTNSRequests.RecordCount# GT 0>
	<TR>
		<TH align="center" valign="TOP">Work Request Number</TH>
		<TH align="center" valign="TOP">Request Date</TH>
		<TH align="center" valign="TOP">Request Type</TH>
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
		<TD align="left" valign="TOP"><DIV>#ListWorkRequests.REQUESTSTATUSNAME#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListWorkRequests.RCNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListWorkRequests.UNITNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListWorkRequests.ROOMNUMBER#</DIV></TD>
<!--- 
		<TD align="left" valign="TOP"><DIV>#DateFormat(ListWorkRequests.SUPAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
 --->
 	</TR>
	
	<TR>
			<TH align="left" valign="MIDDLE">Problem Description:</TH>
			<TD align="left" valign="TOP" colspan="4"><DIV>#ListWorkRequests.PROBLEMDESCRIPTION#</DIV></TD>
			<TH align="left" valign="MIDDLE">Justification Description:</TH>
			<TD align="left" valign="TOP" colspan="3"><DIV>#ListWorkRequests.JUSTIFICATIONDESCRIPTION#</DIV></TD>
		</TR>
	
	<CFLOOP query="ListTNSRequests">

	<TR>
		<TH align="center" valign="BOTTOM" colspan="2">Building/Room</TH>
		<TH align="center" valign="BOTTOM" colspan="2">Jack Number</TH>
		<TH align="center" valign="BOTTOM" colspan="2">Campus Phone Number:</TH>	
		<TH align="center" valign="BOTTOM">Number Listed?:</TH>	
		<TH align="center" valign="BOTTOM">Dialing Capability:</TH>	
		<TH align="center" valign="BOTTOM">Long Distance <BR> Authorization Code?:</TH>
		
	</TR>
	<CFSET TNSCOUNT = TNSCOUNT + 1>
	<TR>
		<TD align="center" valign="TOP" colspan="2"><DIV>#ListTNSRequests.LOCATIONNAME#</DIV></TD>
		<TD align="center" valign="TOP" colspan="2"><DIV>#ListTNSRequests.JACK#</DIV></TD>
		<TD align="center" valign="TOP" colspan="2"><DIV>#ListTNSRequests.CAMPUSPHONE#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListTNSRequests.NUMBERLISTED#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListTNSRequests.DIALINGCAPABILITY#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListTNSRequests.LONGDISTAUTHCODE#</DIV></TD>
	</TR>
	</CFLOOP>
	<TR>
		<TD colspan="9"><HR width="100%" size="5" noshade></TD>
	</TR>
</CFIF>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="9"><H2>#TNSCOUNT# Work Request TNS Request Records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/facilities/workrequestreports.cfm?PROCESS=REPORT" method="POST">
		<TD align="left"><INPUT type="submit" value="Cancel" tabindex="2"></TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="9"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>
</BODY>
</HTML>