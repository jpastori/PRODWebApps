<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: walljacksmultlookupreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/19/2012 --->
<!--- Date in Production: 06/19/2012 --->
<!--- Module: Facilities WallJacks Report--->
<!-- Last modified by John R. Pastori on 07/08/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/walljacksmultlookupreport.cfm">
<CFSET CONTENT_UPDATED = "July 08, 2015">

<HTML>
<HEAD>
	<TITLE>Multiple Record Modify/Delete Lookup Report for Facilities - WallJacks</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">

<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Facilities";


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<!--- 
******************************************************************
* The following code is the WallJacks Report Generation Process. *
******************************************************************
 --->

<BODY>
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
<CFELSE>
	<CFSET FORM.JACKID = #URL.WALLJACKIDS#>
	WALLJACK IDS = #FORM.JACKID#
</CFIF>

<CFQUERY name="ListJackNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAME, WJ.WALLDIRID, WD.WALLDIRNAME,
			WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.ACTIVE, WJ.INSERTTYPE, WJ.VLANID, WJ.HARDWAREID, HI.HARDWAREID,
			HI.BARCODENUMBER, HI.IPADDRESS, WJ.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WJ.COMMENTS,
			WJ.MODIFIEDBYID, WJ.MODIFIEDDATE, BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
	FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN, WALLDIRECTION WD, HARDWMGR.HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	WJ.WALLJACKID IN (#FORM.JACKID#) AND
			WJ.LOCATIONID = LOC.LOCATIONID AND
			LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			WJ.WALLDIRID = WD.WALLDIRID AND
			WJ.HARDWAREID = HI.HARDWAREID AND
			WJ.CUSTOMERID = CUST.CUSTOMERID 
	ORDER BY	LOC.ROOMNUMBER, WJ.JACKNUMBER, WJ.PORTLETTER
</CFQUERY>

<CFSET LINECOUNT = 0>
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Multiple Record Modify/Delete Lookup Report for Facilities - WallJacks</H1></TD>
	</TR>
</TABLE>
<BR>
<TABLE border="0">
	<TR>
		<TH align="CENTER" colspan="10"><H2>#ListJackNumbers.RecordCount# walljack records were selected.</H2></TH>
	</TR>
	<TR>
		<TD colspan="10"><HR width="100%" size="5" noshade></TD>
	</TR>
	<TR>
		<TH align="center">Building Name</TH>
		<TH align="center">Room Number</TH>
		<TH align="center">Wall Direction</TH>
		<TH align="center">Closet</TH>
		<TH align="center">Jack Number</TH>
		<TH align="center">Port Letter</TH>
		<TH align="center">Active?</TH>
		<TH align="center">Insert Type</TH>
		<TH align="center">VLAN</TH>
		<TH align="left">Customer</TH>
	</TR>
<CFLOOP query="ListJackNumbers">

	<CFQUERY name="LookupVLanInfo" datasource="#application.type#FACILITIES" blockfactor="9">
		SELECT	VLANID, VLAN_NUMBER, VLAN_NAME, VLAN_NUMBER || ' - ' || VLAN_NAME AS VLANKEY
		FROM		VLANINFO
		WHERE	VLANID = <CFQUERYPARAM value="#ListJackNumbers.VLANID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VLANID
	</CFQUERY>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, LASTNAME, FULLNAME
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListJackNumbers.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>

	<TR>
		<CFSET LINECOUNT = #LINECOUNT# + 1>
		<TD align="left"><DIV>#ListJackNumbers.BUILDINGNAME#</DIV></TD>
		<TD align="left"><DIV>#ListJackNumbers.ROOMNUMBER#</DIV></TD>
		<TD align="center"><DIV>#ListJackNumbers.WALLDIRNAME#</DIV></TD>
		<TD align="center"><DIV>#ListJackNumbers.CLOSET#</DIV></TD>
		<TD align="center"><DIV>#ListJackNumbers.JACKNUMBER#</DIV></TD>
		<TD align="center"><DIV>#ListJackNumbers.PORTLETTER#</DIV></TD>
		<TD align="center"><DIV>#ListJackNumbers.ACTIVE#</DIV></TD>
		<TD align="center"><DIV>#ListJackNumbers.INSERTTYPE#</DIV></TD>
		<TD align="center"><DIV>#LookupVLanInfo.VLANKEY#</DIV></TD>
		<TD align="left"><DIV>#ListJackNumbers.FULLNAME#</DIV></TD>
	</TR>
	<TR>
		<TH align="left" valign="TOP">Modified-By:</TH>
		<TD align="left" valign="MIDDLE"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
		<TH align="left" valign="TOP">Date Modified:</TH>
		<TD align="left" valign="MIDDLE"><DIV>#DateFormat(ListJackNumbers.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
		<TH align="left" valign="MIDDLE">Comments:</TH>
		<TD align="left" valign="MIDDLE" colspan="5"><DIV>#ListJackNumbers.COMMENTS#</DIV></TD>
	</TR>
	<TR>
		<TD colspan="10"><HR width="100%" size="5" noshade></TD>
	</TR>
</CFLOOP>

	<TR>
		<TH align="CENTER" colspan="10"><H2>#ListJackNumbers.RecordCount# walljack records were selected.</H2></TH>
	</TR>
</TABLE>
</CFOUTPUT>
<BR><BR>

</BODY>
</HTML>