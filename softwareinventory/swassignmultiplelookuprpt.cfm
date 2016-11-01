<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: swassignmultiplelookuprpt.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Software Inventory - Assignments Multiple Lookup Report --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFOUTPUT>
<CFIF ListLen(URL.SOFTWASSIGNIDS) GT 1000>
	<H1>More than 1000 records were selected and this is not allowed by ORACLE. Close this screen, Click Cancel on the 
		Modify screen and re-enter your selection criteria."
	<SCRIPT language="JavaScript">
		<!-- 
		alert("More than 1000 records were selected and this is not allowed by ORACLE. Close this screen, Click Cancel on the 
		Modify screen and re-enter your selection criteria.");
		--> 
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/swassignmultiplelookuprpt.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Inventory - Assignments Multiple Lookup Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Software Inventory - Assignments Report";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY>

<CFQUERY name="LookupSoftwareAssignmentDetail" datasource="#application.type#SOFTWARE" blockfactor="100">
	SELECT	SA.SOFTWASSIGNID, SI.SOFTWINVENTID, SI.TITLE, SI.VERSION, SI.FISCALYEARID, SA.SERIALNUMBER, SA.ASSIGNEDHARDWAREID, SI.PRODPLATFORMID,
			PP.PRODUCTPLATFORMNAME, FY.FISCALYEAR_4DIGIT, HI.HARDWAREID, HI.BARCODENUMBER, SA.ASSIGNEDCUSTID, SWCUST.FULLNAME AS SWNAME,
			U.UNITNAME, SWCUST.CAMPUSPHONE, HWCUST.CUSTOMERID, HWCUST.FULLNAME AS HWNAME, HI.DIVISIONNUMBER, HI.STATEFOUNDNUMBER,
			SA.MODIFIEDBYID, MODBYCUST.FULLNAME AS MODBYCUST, TO_CHAR(SA.MODIFIEDDATE, 'MM/DD/YYYY') AS MODIFIEDDATE
	FROM		SOFTWAREASSIGNMENTS SA, SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, LIBSHAREDDATAMGR.FISCALYEARS FY,
			HARDWMGR.HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS SWCUST, LIBSHAREDDATAMGR.UNITS U, LIBSHAREDDATAMGR.CUSTOMERS HWCUST,
			LIBSHAREDDATAMGR.CUSTOMERS MODBYCUST
	WHERE	SA.SOFTWASSIGNID IN (#URL.SOFTWASSIGNIDS#) AND
			SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
			SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
			SI.FISCALYEARID = FY.FISCALYEARID AND
			SA.ASSIGNEDCUSTID = SWCUST.CUSTOMERID AND
			SWCUST.UNITID = U.UNITID AND
			SA.ASSIGNEDHARDWAREID = HI.HARDWAREID AND
			HI.CUSTOMERID = HWCUST.CUSTOMERID AND
			SA.MODIFIEDBYID = MODBYCUST.CUSTOMERID
	ORDER BY	SI.TITLE, SI.VERSION, SI.FISCALYEARID, SWCUST.FULLNAME, HI.BARCODENUMBER
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR>
          <TD align="LEFT">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" />
          </TD>
     </TR>
	<TR align="center">
		<TD align="center">
			<H1>IDT Software Inventory - Assignments Multiple Lookup Report
		</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="CENTER" colspan="5"><H2>#LookupSoftwareAssignmentDetail.RecordCount# software assignment records were selected.</H2></TH>
	</TR>
<CFLOOP query="LookupSoftwareAssignmentDetail">

	<TR>
		<TH align="LEFT" valign="BOTTOM" colspan="2"><u>Software Inventory Title - Key</u></TH>
		<TH align="center" valign="BOTTOM"><u>Version</u></TH>
		<TH align="center" valign="BOTTOM"><u>Platform</u></TH>
		<TH align="center" valign="BOTTOM"><u>Fiscal Year</u></TH>
	</TR>
	<TR>
		<TD align="LEFT" valign="TOP" colspan="2"><STRONG>#LookupSoftwareAssignmentDetail.TITLE# - #LookupSoftwareAssignmentDetail.SOFTWINVENTID#</STRONG></TD>
		<TD align="center" valign="TOP"><STRONG>#LookupSoftwareAssignmentDetail.VERSION#</STRONG></TD>
		<TD align="center" valign="TOP"><STRONG>#LookupSoftwareAssignmentDetail.PRODUCTPLATFORMNAME#</STRONG></TD>
		<TD align="center" valign="TOP"><STRONG>#LookupSoftwareAssignmentDetail.FISCALYEAR_4DIGIT#</STRONG></TD>
	</TR>
	<TR>
		<TD align="CENTER" colspan="5"><HR /></TD>
	</TR>
	<TR>
		<TH align="LEFT" valign="BOTTOM">Assigned SW Customer</TH>
		<TH align="center" valign="BOTTOM">Unit</TH>
		<TH align="center" valign="BOTTOM">Phone</TH>
		<TH align="center" valign="BOTTOM">Serial Number</TH>
		<TH align="center" valign="BOTTOM">Modified By</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="TOP" nowrap><DIV><COM><STRONG>#LookupSoftwareAssignmentDetail.SWNAME#</STRONG></COM></DIV></TD>
		<TD align="LEFT" valign="TOP" nowrap><DIV><COM>#LookupSoftwareAssignmentDetail.UNITNAME#</COM></DIV></TD>
		<TD align="center" valign="TOP"><DIV><COM>#LookupSoftwareAssignmentDetail.CAMPUSPHONE#</COM></DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.SERIALNUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.MODBYCUST#</DIV></TD>
	</TR>
	<TR>
		<TH align="center" valign="BOTTOM">State Found Number</TH>
		<TH align="center" valign="BOTTOM">CPU Assigned /<BR />HW Customer</TH>
		<TH align="center" valign="BOTTOM">Division Number</TH>
		<TH align="center" valign="BOTTOM">Modified Date</TH>
          <TH align="center" valign="BOTTOM">&nbsp;&nbsp;</TH>
	</TR>
	<TR>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.STATEFOUNDNUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.BARCODENUMBER# /<BR />#LookupSoftwareAssignmentDetail.HWNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.DIVISIONNUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSoftwareAssignmentDetail.MODIFIEDDATE#</DIV></TD>
          <TD align="center" valign="TOP"><DIV>&nbsp;&nbsp;</DIV></TD>
	</TR>
	<TR>
		<TD align="CENTER" colspan="5"><HR size="5" noshade /></TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="5"><H2>#LookupSoftwareAssignmentDetail.RecordCount# software assignment records were selected.</H2></TH>
	</TR>
     <TR>
          <TD align="LEFT" colspan="5">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" />
          </TD>
     </TR>
	<TR>
		<TD colspan="5">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>

</BODY>
</HTML>
</CFOUTPUT>