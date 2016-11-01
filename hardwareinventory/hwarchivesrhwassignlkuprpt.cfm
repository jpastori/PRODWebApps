<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hwarchivesrhwassignlkuprpt.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Hardware Inventory - Hardware Assigned to Archived Hardware Lookup Report --->
<!-- Last modified by John R. Pastori on 08/12/2013 using ColdFusion Studio. -->

<CFOUTPUT>
<CFIF ListLen(URL.SRASSIGNHARDWIDS) GT 1000>
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
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/hwarchivesrhwassignlkuprpt.cfm">
<CFSET CONTENT_UPDATED = "August 12, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory - Hardware Assigned to Archived Hardware Lookup Report</TITLE>
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

<CFQUERY name="LookupSRHardwareAssignmentDetail" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
	SELECT	SRHA.SRHARDWASSIGNID, SRHA.SRID, SR.SRID, SR.SERVICEREQUESTNUMBER, SRHA.HWSWID, SRHA.HWSWDATE, SRHA.HWSWTIME, SRHA.IMAGEID,
     		SRHA.INSTALLINVENTID, SRHA.INSTALLLOCID, SRHA.INSTALLCUSTID, INSTALLCUST.FULLNAME AS INSTALLNAME, SRHA.RETURNINVENTID, 
               RETURNHI.BARCODENUMBER AS RETURNBARCODE, SRHA.RETURNLOCID, RETURNLOC.ROOMNUMBER AS RETURNROOM, SRHA.RETURNCUSTID,
               SRHA.SALVAGEFLAG, SRHA.MACHINENAME, SRHA.MACADDRESS, SRHA.IPADDRESS, SRHA.TECHCOMMENTS, SRHA.MODIFIEDBYID, 
               SRHA.MODIFIEDDATE, SRHA.CONFIRMFLAG, SRHA.CONFIRMCOMMENTS, SRHA.COMFIRMEDBYID, SRHA.CONFIRMEDDATE
     FROM		SRHARDWASSIGNS SRHA, SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS INSTALLCUST, HARDWMGR.HARDWAREINVENTORY RETURNHI, 
     		FACILITIESMGR.LOCATIONS RETURNLOC
	WHERE	SRHA.RETURNINVENTID IN (#URL.SRASSIGNHARDWIDS#) AND
     		SRHA.SRID = SR.SRID AND
               SRHA.INSTALLCUSTID = INSTALLCUST.CUSTOMERID AND
               SRHA.RETURNINVENTID = RETURNHI.HARDWAREID AND
               SRHA.RETURNLOCID = RETURNLOC.LOCATIONID
	ORDER BY	SR.SERVICEREQUESTNUMBER DESC
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center">
			<H1>IDT Hardware Inventory - Hardware Assigned to Archived Hardware Lookup Report</H1>
          </TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" align="center" border="0">
	<TR>
          <TD align="LEFT" colspan="4">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" />
          </TD>
     </TR>
	<TR>
		<TH align="CENTER" colspan="4"><H2>#LookupSRHardwareAssignmentDetail.RecordCount# SR Hardware Assignment records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="LEFT" valign="BOTTOM">SR</TH>
		<TH align="center" valign="BOTTOM">Installed Customer</TH>
		<TH align="center" valign="BOTTOM">Returned Hardware Barcode</TH>
		<TH align="center" valign="BOTTOM">Room Stored</TH>
	</TR>

<CFLOOP query="LookupSRHardwareAssignmentDetail">

	<TR>
		<TD align="LEFT" valign="TOP"><STRONG>#LookupSRHardwareAssignmentDetail.SERVICEREQUESTNUMBER#</STRONG></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSRHardwareAssignmentDetail.INSTALLNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSRHardwareAssignmentDetail.RETURNBARCODE# </DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupSRHardwareAssignmentDetail.RETURNROOM# </DIV></TD>
	</TR>

</CFLOOP>

	<TR>
		<TD align="CENTER" colspan="4"><HR size="5" noshade /></TD>
	</TR>
	<TR>
		<TH align="CENTER" colspan="4"><H2>#LookupSRHardwareAssignmentDetail.RecordCount# SR Hardware Assignment records were selected.</H2></TH>
	</TR>
     <TR>
          <TD align="left" colspan="4">
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