<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hwarchiveswassignlkuprpt.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Hardware Inventory - Software Assigned to Archived Hardware Lookup Report --->
<!-- Last modified by John R. Pastori on 08/12/2013 using ColdFusion Studio. -->

<CFOUTPUT>
<CFIF ListLen(URL.SOFTWASSIGNIDS) GT 1000>
	<H1>More than 1000 records were selected and this is not allowed by ORACLE. Close this screen, Click Cancel on the 
		Modify screen and re-enter your selection criteria."
	<SCRIPT language="JavaScript">
		<!-- 
		alert("More than 1000 records were selected and this is not allowed by ORACLE. Close this screen, Click Cancel on the Modify screen and re-enter your selection criteria.");
		--> 
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/hwarchiveswassignlkuprpt.cfm">
<CFSET CONTENT_UPDATED = "August 12, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory - Software Assigned to Archived Hardware Lookup Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY>

<CFQUERY name="LookupSoftwareAssignmentDetail" datasource="#application.type#SOFTWARE" blockfactor="100">
	SELECT	SA.SOFTWASSIGNID, SI.TITLE, SI.VERSION, SI.SOFTWINVENTID, SI.PRODPLATFORMID, SA.ASSIGNEDCUSTID, SWCUST.FULLNAME AS SWNAME,
			HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTLOCATIONID, LOC.ROOMNUMBER
	FROM		SOFTWAREASSIGNMENTS SA, SOFTWAREINVENTORY SI, LIBSHAREDDATAMGR.CUSTOMERS SWCUST, HARDWMGR.HARDWAREINVENTORY HI,
			FACILITIESMGR.LOCATIONS LOC
	WHERE	SA.SOFTWASSIGNID IN (#URL.SOFTWASSIGNIDS#) AND
			SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
			SA.ASSIGNEDCUSTID = SWCUST.CUSTOMERID AND
			SA.ASSIGNEDHARDWAREID = HI.HARDWAREID AND
			HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID
	ORDER BY	SI.TITLE, SI.VERSION, SI.SOFTWINVENTID, SI.PRODPLATFORMID, SWNAME, HI.BARCODENUMBER
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center">
			<H1>IDT Hardware Inventory - Software Assigned to Archived Hardware Lookup Report</H1>
          </TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" align="center" border="0">
	<TR>
          <TD align="LEFT" colspan="6">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" />
          </TD>
     </TR>
	<TR>
		<TH align="CENTER" colspan="6"><H2>#LookupSoftwareAssignmentDetail.RecordCount# software assignment records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="LEFT" valign="BOTTOM">Software Inventory Title</TH>
		<TH align="center" valign="BOTTOM">Version</TH>
		<TH align="LEFT" valign="BOTTOM">SW Key</TH>
		<TH align="center" valign="BOTTOM">Software Customer</TH>
		<TH align="center" valign="BOTTOM">CPU Assigned</TH>
		<TH align="center" valign="BOTTOM">Room Stored</TH>
	</TR>

<CFLOOP query="LookupSoftwareAssignmentDetail">

	<TR>
		<TD align="LEFT" valign="TOP"><STRONG>#LookupSoftwareAssignmentDetail.TITLE#</STRONG></TD>
		<TD align="center" valign="TOP"><STRONG>#LookupSoftwareAssignmentDetail.VERSION#</STRONG></TD>
		<TD align="LEFT" valign="TOP"><STRONG>#LookupSoftwareAssignmentDetail.SOFTWINVENTID#</STRONG></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.SWNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.BARCODENUMBER# </DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.ROOMNUMBER# </DIV></TD>
	</TR>

</CFLOOP>

	<TR>
		<TD align="CENTER" colspan="6"><HR size="5" noshade /></TD>
	</TR>
	<TR>
		<TH align="CENTER" colspan="6"><H2>#LookupSoftwareAssignmentDetail.RecordCount# software assignment records were selected.</H2></TH>
	</TR>
     <TR>
          <TD align="left" colspan="6">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="2" />
          </TD>
     </TR>
	<TR>
		<TD colspan="6">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>

</BODY>
</HTML>
</CFOUTPUT>