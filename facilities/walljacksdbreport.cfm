<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: walljacksdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/06/2012 --->
<!--- Date in Production: 07/06/2012 --->
<!--- Module: Facilities - WallJack Report --->
<!-- Last modified by John R. Pastori on on 07/07/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/walljacksdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 07, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - WallJack Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Facilities";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {
		if (document.LOOKUP.BUILDINGNAMEID.selectedIndex == "0"      && document.LOOKUP.LOCATIONID.selectedIndex == "0"
		 && (document.LOOKUP.ROOMNUMBER.value == ""                  || document.LOOKUP.ROOMNUMBER.value == " ")
		 && document.LOOKUP.WALLDIRID.selectedIndex == "0"           
		 && (document.LOOKUP.CLOSET.value == ""                      || document.LOOKUP.CLOSET.value == " ")
		 && document.LOOKUP.JACKNUMBER.value == "0" 
		 && document.LOOKUP.PORTLETTER.selectedIndex == "0"          && document.LOOKUP.ACTIVE.value == "Select" 
		 && document.LOOKUP.INSERTTYPE.value == "Select Insert Type" 
		 && document.LOOKUP.VLANID.selectedIndex == "0"              && document.LOOKUP.CUSTOMERID.selectedIndex == "0"
		 && (document.LOOKUP.CUSTOMERFIRSTNAME.value == ""           || document.LOOKUP.CUSTOMERFIRSTNAME.value == " ")
		 && (document.LOOKUP.CUSTOMERLASTNAME.value == ""            || document.LOOKUP.CUSTOMERLASTNAME.value == " ")
		 && (document.LOOKUP.COMMENTS.value == ""            		 || document.LOOKUP.COMMENTS.value == " ")
		 && document.LOOKUP.HARDWAREID.selectedIndex == "0"
		 && document.LOOKUP.MODIFIEDBYID.selectedIndex == "0" 
		 && (document.LOOKUP.MODIFIEDDATE.value == ""            	 || document.LOOKUP.MODIFIEDDATE.value == " ")) {
			alertuser ("At least one selection field must be entered or selected!");
			document.LOOKUP.BUILDINGNAMEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

<CFOUTPUT>
<CFIF NOT IsDefined("URL.LOOKUPWALLJACK")>
	<CFSET CURSORFIELD = "document.LOOKUP.BUILDINGNAMEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFSET PROCESSPROGRAM = "walljacksdbreport.cfm?PROCESS=REPORT&LOOKUPWALLJACK=FOUND">

<CFSET SCREENTITLE = "Facilities Lookup for WallJack Report">
<CFINCLUDE template="lookupwalljacksinfo.cfm">

<CFIF NOT IsDefined('URL.LOOKUPWALLJACK') OR #GetJackNumbers.RecordCount# EQ 0>
	<CFEXIT>
<CFELSE>
<!--- 
******************************************************************
* The following code is the WallJacks Report Generation Process. *
******************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Facilities - WallJacks Report</H1>
				<H2>#REPORTTITLE#</H2>
			</TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/walljacksdbreport.cfm?PROCESS=REPORT" method="POST">
			<TD align="left" colspan="8"><INPUT type="submit" value="Cancel" tabindex="1" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="8"><H2>#GetJackNumbers.RecordCount# WallJack records were selected.<H2></H2></H2></TH>
		</TR>
		
<CFLOOP query="GetJackNumbers">

		<TR>
		<CFIF #FORM.REPORTCHOICE# EQ 2>
			<TH align="center">Closet</TH>
			<TH align="center">Jack Number</TH>
			<TH align="center">Port Letter</TH>
		</CFIF>
			<TH align="center">Building Name</TH>
			<TH align="center">Room Number</TH>
		<CFIF #FORM.REPORTCHOICE# EQ 1>
			<TH align="center">Closet</TH>
			<TH align="center">Jack Number</TH>
			<TH align="center">Port Letter</TH>
		</CFIF>
			<TH align="center">Wall Direction</TH>
			<TH align="center">Active?</TH>
			<TH align="left">Customer</TH>
		</TR>

		<CFQUERY name="LookupVLanInfo" datasource="#application.type#FACILITIES" blockfactor="9">
			SELECT	VLANID, VLAN_NUMBER, VLAN_NAME, VLAN_NUMBER || ' - ' || VLAN_NAME AS VLANKEY
			FROM		VLANINFO
			WHERE	VLANID = <CFQUERYPARAM value="#GetJackNumbers.VLANID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	VLANID
		</CFQUERY>

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#GetJackNumbers.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<TR>
		<CFIF #FORM.REPORTCHOICE# EQ 2>
			<TD align="center"><DIV>#GetJackNumbers.CLOSET#</DIV></TD>
			<TD align="center"><DIV>#GetJackNumbers.JACKNUMBER#</DIV></TD>
			<TD align="center"><DIV>#GetJackNumbers.PORTLETTER#</DIV></TD>
		</CFIF>
			<TD align="center"><DIV>#GetJackNumbers.BUILDINGNAME#</DIV></TD>
			<TD align="center"><DIV>#GetJackNumbers.ROOMNUMBER#</DIV></TD>
		<CFIF #FORM.REPORTCHOICE# EQ 1>
			<TD align="center"><DIV>#GetJackNumbers.CLOSET#</DIV></TD>
			<TD align="center"><DIV>#GetJackNumbers.JACKNUMBER#</DIV></TD>
			<TD align="center"><DIV>#GetJackNumbers.PORTLETTER#</DIV></TD>
		</CFIF>
			<TD align="center"><DIV>#GetJackNumbers.WALLDIRNAME#</DIV></TD>
			<TD align="center"><DIV>#GetJackNumbers.ACTIVE#</DIV></TD>
			<TD align="left"><DIV>#GetJackNumbers.FULLNAME#</DIV></TD>
		</TR>
		<TR>
			<TH align="center">Insert Type</TH>
			<TH align="center">&nbsp;&nbsp;</TH>
			<TH align="center">VLAN</TH>
			<TH align="center">&nbsp;&nbsp;</TH>
			<TH align="center">Barcode</TH>
			<TH align="center">&nbsp;&nbsp;</TH>
			<TH align="center">IP Address</TH>
			<TH align="center">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="center"><DIV>#GetJackNumbers.INSERTTYPE#</DIV></TD>
			<TD align="center">&nbsp;&nbsp;</TD>
			<TD align="center"><DIV>#LookupVLanInfo.VLANKEY#</DIV></TD>
			<TD align="center">&nbsp;&nbsp;</TD>
			<TD align="center"><DIV>#GetJackNumbers.BARCODENUMBER#</DIV></TD>
			<TD align="center">&nbsp;&nbsp;</TD>
			<TD align="center"><DIV>#GetJackNumbers.IPADDRESS#</DIV></TD>
			<TD align="center">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP">Modified-By:</TH>
			<TD align="left" valign="MIDDLE"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
			<TH align="left" valign="TOP">Date Modified:</TH>
			<TD align="left" valign="MIDDLE"><DIV>#DateFormat(GetJackNumbers.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
			<TH align="left" valign="MIDDLE">Comments:</TH>
			<TD align="left" valign="MIDDLE" colspan="4"><DIV>#GetJackNumbers.COMMENTS#</DIV></TD>
		</TR>
		<TR>
			<TD align="left" colspan="8"><HR width="100%" size="5" noshade /></TD>
		</TR>
</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="8"><H2>#GetJackNumbers.RecordCount# WallJack records were selected.<H2></H2></H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/walljacksdbreport.cfm?PROCESS=REPORT" method="POST">
			<TD align="left" colspan="8"><INPUT type="submit" value="Cancel" tabindex="2" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="8">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>