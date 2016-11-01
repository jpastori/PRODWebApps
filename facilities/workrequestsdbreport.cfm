<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: workrequestdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/14/2012 --->
<!--- Date in Production: 02/14/2012 --->
<!--- Module: Facilities - Work Requests Report --->
<!-- Last modified by John R. Pastori on 02/14/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/workrequestdbreport.cfm">
<CFSET CONTENT_UPDATED = "February 14, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Work Requests Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<BODY>

<CFOUTPUT>

	<TABLE width="100%" align="center" Border="3">
		<TR align="center">
			<TD align="center"><H1>Facilities - Work Requests Report</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT" Border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/workrequestreports.cfm?PROCESS=REPORT" method="POST">
			<TD align="LEFT" valign="TOP" colspan="15">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="15"><H2>#ListWorkRequests.RecordCount# Work Request records were selected.<H2></H2></H2></TH>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM">Work Request Number</TH>
			<TH align="center" valign="BOTTOM">Request Date</TH>
			<TH align="center" valign="BOTTOM">Request Type</TH>
			<TH align="center" valign="BOTTOM">Request Status</TH>
			<TH align="center" valign="BOTTOM">Requester Name</TH>
			<TH align="center" valign="BOTTOM">Unit Name</TH>
			<TH align="center" valign="BOTTOM">Room Number</TH>
			<TH align="center" valign="BOTTOM">Account Number</TH>
			<TH align="center" valign="BOTTOM">Alternate Contact Name</TH>
			<TH align="center" valign="BOTTOM">Unit Head Approval Name</TH>
<!---  
			<TH align="center" valign="BOTTOM">Management Approval Name</TH>
 ---> 
			<TH align="center" valign="BOTTOM">Urgency</TH>
			<TH align="center" valign="BOTTOM">Key Request?</TH>
			<TH align="center" valign="BOTTOM">Move Request?</TH>
			<TH align="center" valign="BOTTOM">TNS Request?</TH>
		</TR>

	<CFLOOP query="ListWorkRequests">

		<TR>
			<TD align="left" valign="TOP"><DIV>#ListWorkRequests.WORKREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListWorkRequests.REQUESTDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.REQUESTTYPENAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListWorkRequests.REQUESTSTATUSNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.RCNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.UNITNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.ROOMNUMBER#</DIV></TD>
			<TD align="left" valign="TOP" nowrap>
				<DIV>#ListWorkRequests.ACCOUNTNUMBER1##ListWorkRequests.ACCOUNTNUMBER2##ListWorkRequests.ACCOUNTNUMBER3#</DIV>
			</TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.ALTCNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.SUPAPRVLNAME#</DIV></TD>
<!--- 
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.MGMTAPRVLNAME#</DIV></TD>
 --->
			<TD align="left" valign="TOP"><DIV>#ListWorkRequests.URGENCY#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.KEYREQUEST#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.MOVEREQUEST#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkRequests.TNSREQUEST#</DIV></TD>
		</TR>
		<TR>
<!--- 
			<TH align="left" valign="TOP">Unit Head Approval Date:</TH>
			<TD align="left" valign="MIDDLE"><DIV>#DateFormat(ListWorkRequests.SUPAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
 --->
 			<TH align="left" valign="TOP">Initial Approval Date:</TH>
			<TD align="left" valign="MIDDLE"><DIV>#DateFormat(ListWorkRequests.INITAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
               <TH align="left" valign="TOP">Desired Start Date:</TH>
			<TD align="left" valign="MIDDLE"><DIV>#DateFormat(ListWorkRequests.STARTDATE, "MM/DD/YYYY")#</DIV></TD>
			<TH align="left" valign="TOP">Desired Completion Date:</TH>
			<TD align="left" valign="MIDDLE"><DIV>#DateFormat(ListWorkRequests.COMPLETIONDATE, "MM/DD/YYYY")#</DIV></TD>
			<TH align="left" valign="MIDDLE">Problem Description:</TH>
			<TD align="left" valign="TOP" colspan="2"><DIV>#ListWorkRequests.PROBLEMDESCRIPTION#</DIV></TD>
			<TH align="left" valign="MIDDLE">Justification Description:</TH>
			<TD align="left" valign="TOP"><DIV>#ListWorkRequests.JUSTIFICATIONDESCRIPTION#</DIV></TD>
               <TH align="left" valign="MIDDLE">Status Comments:</TH>
			<TD align="left" valign="TOP" colspan="2"><DIV>#ListWorkRequests.STATUS_COMMENTS#</DIV></TD>
		</TR>
		<TR>
			<TD colspan="15"><HR width="100%" size="5" noshade /></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="15"><H2>#ListWorkRequests.RecordCount# Work Request records were selected.<H2></H2></H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/workrequestreports.cfm?PROCESS=REPORT" method="POST">
			<TD align="LEFT" valign="TOP" colspan="15">
				<INPUT type="SUBMIT" value="Cancel" tabindex="2" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="15"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFOUTPUT>
</BODY>
</HTML>