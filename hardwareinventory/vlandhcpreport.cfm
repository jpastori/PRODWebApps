<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: vlandhcpreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/05/2014 --->
<!--- Date in Production: 02/05/2014 --->
<!--- Module: Process Information to IDT Data for New VLAN/DHCP Project Report --->
<!-- Last modified by John R. Pastori on 02/05/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/vlandhcpreport.cfm">
<CFSET CONTENT_UPDATED = "February 05 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Data for New VLAN/DHCP Project Report</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JAVASCRIPT">
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

</SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY>

<CFOUTPUT>
<!--- 
*********************************************************************
* The following code displays the Library VLAN/DHCP Project Report. *
*********************************************************************
 --->
<CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
     SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.SERIALNUMBER, HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE, HI.EQUIPMENTLOCATIONID, 
     		LOC.ROOMNUMBER, HI.MACADDRESS, HI.IPADDRESS, HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.CATEGORYID 
     FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE ET, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS CUST
     WHERE	(HI.HARDWAREID > 0 AND
               HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID) AND
               ((HI.EQUIPMENTTYPEID IN (1,8,15)) OR
               (HI.EQUIPMENTTYPEID = 6 AND
               HI.COMMENTS LIKE ('%POE Clocks%'))) AND
               (HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
               HI.CUSTOMERID = CUST.CUSTOMERID AND
               CUST.CATEGORYID IN (1,5,8))
     ORDER BY	CUST.FULLNAME, HI.BARCODENUMBER, ET.EQUIPMENTTYPE
</CFQUERY>

<TABLE width="100%" align="center" border="0">
     <TR align="center">
          <TH align="center" colspan="12"><H1>IDT Data for New VLAN/DHCP Project Report</H1></TH>
     </TR>
     <TR>
          <TH align="left" valign="bottom">Customer<BR> Name</TH>
          <TH align="CENTER" valign="bottom">Barcode</TH>
          <TH align="CENTER" valign="bottom">S/N</TH>
          <TH align="CENTER" valign="bottom">Type</TH>
          <TH align="CENTER" valign="bottom">Location</TH>
          <TH align="CENTER" valign="bottom">Mac Address</TH>
          <TH align="CENTER" valign="bottom">IP Address</TH>
          <TH align="CENTER" valign="bottom">Closet</TH>
          <TH align="CENTER" valign="bottom">Jack ##</TH>
          <TH align="CENTER" valign="bottom">Jack Port</TH>
          <TH align="CENTER" valign="bottom">VLAN</TH>
          <TH align="CENTER" valign="bottom">Wall<BR>Direction</TH>
     </TR>
<CFLOOP query="LookupHardware">

     <CFQUERY name="LookupJackNumbers" datasource="#application.type#FACILITIES">
          SELECT	WJ.WALLJACKID, WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.VLAN, WJ.WALLDIRID, WD.WALLDIRNAME
          FROM		WALLJACKS WJ, WALLDIRECTION WD
          WHERE	WJ.HARDWAREID = <CFQUERYPARAM value="#LookupHardware.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    WJ.WALLDIRID = WD.WALLDIRID
          ORDER BY	WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER
     </CFQUERY>

     <TR>
          <TD align="left" valign="TOP"><DIV>#LookupHardware.FULLNAME#</DIV></TD>
          <TD align="CENTER" valign="TOP" nowrap><DIV>#LookupHardware.BARCODENUMBER#</DIV></TD>
          <TD align="CENTER" valign="TOP"><DIV>#LookupHardware.SERIALNUMBER#</DIV></TD>
          <TD align="CENTER" valign="TOP"><DIV>#LookupHardware.EQUIPMENTTYPE#</DIV></TD>
          <TD align="CENTER" valign="TOP"><DIV>#LookupHardware.ROOMNUMBER#</DIV></TD>
          <TD align="CENTER" valign="TOP"><DIV>#LookupHardware.MACADDRESS#</DIV></TD>
          <TD align="CENTER" valign="TOP"><DIV>#LookupHardware.IPADDRESS#</DIV></TD>
          <TD align="CENTER" valign="TOP"><DIV>#LookupJackNumbers.CLOSET#</DIV></TD>
          <TD align="CENTER" valign="TOP"><DIV>#LookupJackNumbers.JACKNUMBER#</DIV></TD>
          <TD align="CENTER" valign="TOP"><DIV>#LookupJackNumbers.PORTLETTER#</DIV></TD>
          <TD align="CENTER" valign="TOP"><DIV>#LookupJackNumbers.VLAN#</DIV></TD>
          <TD align="CENTER" valign="TOP"><DIV>#LookupJackNumbers.WALLDIRNAME#</DIV></TD>
     </TR>
</CFLOOP>
<BR />
     <TR>
          <TH align="CENTER" colspan="12">#LookupHardware.RecordCount# hardware records were selected.<BR /><BR /></TH>
     </TR>
 </TABLE>
</CFOUTPUT>

/BODY>
</HTML>