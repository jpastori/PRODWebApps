<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hwarchivewalljacklkuprpt.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Hardware Inventory - Assigned WallJack to Archived Hardware Lookup Report --->
<!-- Last modified by John R. Pastori on 08/13/2013 using ColdFusion Studio. -->

<CFOUTPUT>
<CFIF ListLen(URL.WALLJACKIDS) GT 1000>
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
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/hwarchivewalljacklkuprpt.cfm">
<CFSET CONTENT_UPDATED = "August 13, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory - Assigned WallJack to Archived Hardware Lookup Report</TITLE>
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

<CFQUERY name="LookupJackNumbers" datasource="#application.type#FACILITIES">
	SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAME, WJ.WALLDIRID, WD.WALLDIRID, WD.WALLDIRNAME, WJ.CLOSET,
     		WJ.JACKNUMBER, WJ.PORTLETTER, WJ.HARDWAREID, HI.HARDWAREID, HI.BARCODENUMBER, HI.IPADDRESS, WJ.CUSTOMERID, CUST.CUSTOMERID,
               CUST.FULLNAME, WJ.COMMENTS, WJ.MODIFIEDBYID, WJ.MODIFIEDDATE, BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
	FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN, WALLDIRECTION WD, HARDWMGR.HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	WJ.WALLJACKID IN (#URL.WALLJACKIDS#) AND
			WJ.LOCATIONID = LOC.LOCATIONID AND
			LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
               WJ.WALLDIRID = WD.WALLDIRID AND
			WJ.HARDWAREID = HI.HARDWAREID AND
			WJ.CUSTOMERID = CUST.CUSTOMERID 
	ORDER BY	LOC.ROOMNUMBER, WD.WALLDIRNAME, WJ.JACKNUMBER, WJ.PORTLETTER
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center">
			<H1>IDT Hardware Inventory - Assigned WallJack to Archived Hardware Lookup Report</H1>
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
		<TH align="CENTER" colspan="6"><H2>#LookupJackNumbers.RecordCount# walljack records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="LEFT" valign="BOTTOM">Room Number</TH>
		<TH align="center" valign="BOTTOM">Closet</TH>
          <TH align="LEFT" valign="BOTTOM">Wall Direction</TH>
		<TH align="LEFT" valign="BOTTOM">Jack Number</TH>
		<TH align="center" valign="BOTTOM">Port Letter</TH>
		<TH align="center" valign="BOTTOM">Barcode</TH>
	</TR>

<CFLOOP query="LookupJackNumbers">

	<TR>
		<TD align="LEFT" valign="TOP"><STRONG>#LookupJackNumbers.ROOMNUMBER#</STRONG></TD>
		<TD align="center" valign="TOP"><STRONG>#LookupJackNumbers.CLOSET#</STRONG></TD>
          <TD align="LEFT" valign="TOP"><STRONG>#LookupJackNumbers.WALLDIRNAME#</STRONG></TD>
		<TD align="LEFT" valign="TOP"><STRONG>#LookupJackNumbers.JACKNUMBER#</STRONG></TD>
		<TD align="center" valign="TOP"><DIV>#LookupJackNumbers.PORTLETTER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupJackNumbers.BARCODENUMBER#</DIV></TD>
	</TR>

</CFLOOP>

	<TR>
		<TD align="CENTER" colspan="6"><HR size="5" noshade /></TD>
	</TR>
	<TR>
		<TH align="CENTER" colspan="6"><H2>#LookupJackNumbers.RecordCount# walljack records were selected.</H2></TH>
	</TR>
     <TR>
          <TD align="left" colspan="6">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="2" />
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