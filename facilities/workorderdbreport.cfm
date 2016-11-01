<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: workorderdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/27/2008 --->
<!--- Date in Production: 01/27/2008 --->
<!--- Module: Facilities - Work Orders Report --->
<!-- Last modified by John R. Pastori on 01/27/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/workorderdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 27, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Work Orders Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<BODY>

<CFOUTPUT>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Facilities - Work Orders Report</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/workorderreports.cfm?PROCESS=REPORT" method="POST">
			<TD align="LEFT" valign="TOP" colspan="15">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="15"><H2>#ListWorkOrders.RecordCount# Work Order records were selected.<H2></H2></H2></TH>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM">Work Order Number</TH>
			<TH align="center" valign="BOTTOM">Request Date</TH>
			<TH align="center" valign="BOTTOM">Request Type</TH>
			<TH align="center" valign="BOTTOM">Request Status</TH>
			<TH align="center" valign="BOTTOM">Requester Name</TH>
			<TH align="center" valign="BOTTOM">Unit Name</TH>
			<TH align="center" valign="BOTTOM">Room Number</TH>
			<TH align="center" valign="BOTTOM">Account Number</TH>
			<TH align="center" valign="BOTTOM">Alternate Contact Name</TH>
			<TH align="center" valign="BOTTOM">Unit Head Approval Name</TH>
			<TH align="center" valign="BOTTOM">Management Approval Name</TH>
			<TH align="center" valign="BOTTOM">Urgency</TH>
			<TH align="center" valign="BOTTOM">Key Request?</TH>
			<TH align="center" valign="BOTTOM">Move Request?</TH>
			<TH align="center" valign="BOTTOM">TNS Request?</TH>
		</TR>

	<CFLOOP query="ListWorkOrders">

		<TR>
			<TD align="left" valign="TOP"><DIV>#ListWorkOrders.WORKORDERNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListWorkOrders.REQUESTDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkOrders.REQUESTTYPENAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListWorkOrders.REQUESTSTATUSNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkOrders.RCNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkOrders.UNITNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkOrders.ROOMNUMBER#</DIV></TD>
			<TD align="left" valign="TOP" nowrap>
				<DIV>#ListWorkOrders.ACCOUNTNUMBER1##ListWorkOrders.ACCOUNTNUMBER2##ListWorkOrders.ACCOUNTNUMBER3#</DIV>
			</TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkOrders.ALTCNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkOrders.SUPAPRVLNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkOrders.MGMTAPRVLNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListWorkOrders.URGENCY#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkOrders.KEYREQUEST#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkOrders.MOVEREQUEST#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListWorkOrders.TNSREQUEST#</DIV></TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP">Unit Head Approval Date:</TH>
			<TD align="left" valign="MIDDLE"><DIV>#DateFormat(ListWorkOrders.SUPAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
			<TH align="left" valign="TOP">Management Approval Date:</TH>
			<TD align="left" valign="MIDDLE"><DIV>#DateFormat(ListWorkOrders.MGMTAPPROVALDATE, "MM/DD/YYYY")#</DIV></TD>
			<TH align="left" valign="TOP">Desired Start Date:</TH>
			<TD align="left" valign="MIDDLE"><DIV>#DateFormat(ListWorkOrders.STARTDATE, "MM/DD/YYYY")#</DIV></TD>
			<TH align="left" valign="TOP">Desired Completion Date:</TH>
			<TD align="left" valign="MIDDLE"><DIV>#DateFormat(ListWorkOrders.COMPLETIONDATE, "MM/DD/YYYY")#</DIV></TD>
			<TH align="left" valign="MIDDLE">Project Description:</TH>
			<TD align="left" valign="TOP" colspan="4"><DIV>#ListWorkOrders.PROJECTDESCRIPTION#</DIV></TD>
			<TH align="left" valign="MIDDLE">Justification Description:</TH>
			<TD align="left" valign="TOP" colspan="3"><DIV>#ListWorkOrders.JUSTIFICATIONDESCRIPTION#</DIV></TD>
		</TR>
		<TR>
			<TD colspan="15"><HR width="100%" size="5" noshade /></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="15"><H2>#ListWorkOrders.RecordCount# Work Order records were selected.<H2></H2></H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/workorderreports.cfm?PROCESS=REPORT" method="POST">
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