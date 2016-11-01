<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: walljacksinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: Add/Modify/Delete Information in Facilities  - Wall Jacks--->
<!-- Last modified by John R. Pastori on 07/08/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/walljacksinfo.cfm">
<CFSET CONTENT_UPDATED = "July 08, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information in Facilities - Wall Jack</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information in Facilities - Wall Jack</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Facilities";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.WALLJACK.JACKROOM.selectedIndex == "0") {
			alertuser (document.WALLJACK.JACKROOM.name +  ",  A  Wall Jack Building/Room MUST be selected!");
			document.WALLJACK.JACKROOM.focus();
			return false;
		}

		if (document.WALLJACK.WALLDIRID.selectedIndex == "0") {
			alertuser (document.WALLJACK.WALLDIRID.name +  ",  A  Wall Direction MUST be selected!");
			document.WALLJACK.WALLDIRID.focus();
			return false;
		}
		
		if (document.WALLJACK.CLOSET.value == "" || document.WALLJACK.CLOSET.value == " ") {
			alertuser (document.WALLJACK.CLOSET.name +  ",  A Closet Number MUST be entered!");
			document.WALLJACK.CLOSET.focus();
			return false;
		}

		if (document.WALLJACK.JACKNUMBER.value == "" || document.WALLJACK.JACKNUMBER.value == " ") {
			alertuser (document.WALLJACK.JACKNUMBER.name +  ",  A Jack Number MUST be entered!");
			document.WALLJACK.JACKNUMBER.focus();
			return false;
		}

		if (document.WALLJACK.PORTLETTER.selectedIndex == "0") {
			alertuser (document.WALLJACK.PORTLETTER.name +  ",  A Port Letter MUST be selected!");
			document.WALLJACK.PORTLETTER.focus();
			return false;
		}

		if (document.WALLJACK.CUSTOMERID.selectedIndex == "0") {
			alertuser (document.WALLJACK.CUSTOMERID.name +  ",  A Customer MUST be selected!");
			document.WALLJACK.CUSTOMERID.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.JACKID.selectedIndex == "0") {
			alertuser ("A Wall Jack MUST be selected!");
			document.LOOKUP.JACKID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPWALLJACK') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.JACKID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.WALLJACK.JACKROOM.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<CFIF IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES">
	<CFSET PROGRAMNAME = "processwalljacksinfo.cfm?SRCALL=YES">
     <CFSET client.SRCALL = "YES">
<CFELSE>
     <CFSET PROGRAMNAME = "processwalljacksinfo.cfm">
     <CFSET client.SRCALL = "NO">
</CFIF>

<!--- 
******************************************************************************************
* The following code is used by both the ADD and Modify/Delete Processes for Wall Jacks. *
******************************************************************************************
 --->

<CFQUERY name="LookupHardwareBarCode" datasource="#application.type#HARDWARE">
	SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.IPADDRESS, CUST.CUSTOMERID, CUST.FULLNAME, HI.BARCODENUMBER || ' - ' || CUST.FULLNAME AS KEYFINDER
	FROM		HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	HI.CUSTOMERID = CUST.CUSTOMERID
	ORDER BY	HI.BARCODENUMBER, CUST.CUSTOMERID
</CFQUERY>

<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
			LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION, 		
			LOC.MODIFIEDBYID, LOC.MODIFIEDDATE, BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
	FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
	WHERE	LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID
	ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
</CFQUERY>

<CFQUERY name="ListWallDirection" datasource="#application.type#FACILITIES" blockfactor="10">
	SELECT	WALLDIRID, WALLDIRNAME
	FROM		WALLDIRECTION
	ORDER BY	WALLDIRNAME
</CFQUERY>

<CFQUERY name="ListVLanInfo" datasource="#application.type#FACILITIES" blockfactor="9">
	SELECT	VLANID, VLAN_NUMBER, VLAN_NAME, VLAN_NUMBER || ' - ' || VLAN_NAME AS VLANKEY
	FROM		VLANINFO
	ORDER BY	VLANID
</CFQUERY>

<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, LASTNAME, FULLNAME, ACTIVE
	FROM		CUSTOMERS
	WHERE	ACTIVE = 'YES'
	ORDER BY	FULLNAME
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			SL.SECURITYLEVELNAME, CUST.FULLNAME || ' - ' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 100 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 20
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<BR clear="left" />
<!--- 
*********************************************************
* The following code is the ADD Process for Wall Jacks. *
*********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information in Facilities - Wall Jack</H1></TD>
		</TR>
	</TABLE>

		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
			SELECT	MAX(WALLJACKID) AS MAX_ID
			FROM		WALLJACKS
		</CFQUERY>
		<CFSET FORM.JACKID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="JACKID" secure="NO" value="#FORM.JACKID#">
		<CFQUERY name="AddWallJackID" datasource="#application.type#FACILITIES">
			INSERT INTO	WALLJACKS (WALLJACKID)
			VALUES		(#val(Cookie.JACKID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Wall Jack Key &nbsp; = &nbsp; #FORM.JACKID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/#PROGRAMNAME#" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessWallJack" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="WALLJACK" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="JACKROOM">*Jack Location</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="WALLDIRID">*Wall Direction</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="JACKROOM" id="JACKROOM" size="1" query="ListRoomNumbers" value="LOCATIONID" display="BUILDINGROOM" selected="0" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="WALLDIRID" id="WALLDIRID" size="1" query="ListWallDirection" value="WALLDIRID" display="WALLDIRNAME" selected="0" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="CLOSET">*Closet</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="JACKNUMBER">*Jack Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" nowrap><CFINPUT type="Text" name="CLOSET" id="CLOSET" value="" align="LEFT" required="No"  size="10" tabindex="4"></TD>
			<TD align="left" nowrap><CFINPUT type="Text" name="JACKNUMBER" id="JACKNUMBER" value="0" align="LEFT" required="No" size="4" tabindex="5"></TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PORTLETTER">*Port Letter</LABEL></H4></TH>
			<TH align="left"><LABEL for="ACTIVE">Active?</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="PORTLETTER" id="PORTLETTER" size="1" required="No" tabindex="6">
					<OPTION value="0">PORT LETTER</OPTION>
					<OPTION value="A">A</OPTION>
					<OPTION value="B">B</OPTION>
					<OPTION value="C">C</OPTION>
					<OPTION value="D">D</OPTION>
					<OPTION value="E">E</OPTION>
					<OPTION value="F">F</OPTION>
					<OPTION value="WL">WIRELESS</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="7">
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="INSERTTYPE">Insert Type</LABEL></TH>
			<TH align="left" valign="BOTTOM" width="45%"><LABEL for="VLANINFOID">VLAN</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="INSERTTYPE" id="INSERTTYPE" size="1" tabindex="8">
					<OPTION value="INSERT">Select Insert Type</OPTION>
					<OPTION value="DATA">DATA</OPTION>
					<OPTION value="ONE CARD">ONE CARD</OPTION>
					<OPTION value="PHONE">PHONE</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="VLANID" id="VLANID" tabindex="9">
					<OPTION VALUE="6"> 62 - FACULTY/STAFF WORKSTATIONS</OPTION>
					<CFLOOP query="ListVLanInfo">
						<OPTION value="#VLANID#"> #VLANKEY#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="HARDWAREID">Barcode</LABEL></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="HARDWAREID" id="HARDWAREID" size="1" query="LookupHardwareBarCode" value="HARDWAREID" display="KEYFINDER" selected="0" required="No" tabindex="10"></CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<TD align="left" nowrap>&nbsp;&nbsp;</TD>
			
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="CUSTOMERID">*Customer</LABEL></H4></TH>
			<TH align="left"><LABEL for="COMMENTS">Comments</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="11"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP"><CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="12"></CFTEXTAREA></TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
			<TH align="left">Date Created</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="13"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessWallJack" value="ADD" tabindex="14" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/facilities/#PROGRAMNAME#" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessWallJack" value="CANCELADD" tabindex="15" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Wall Jacks. *
************************************************************************************
 --->
 
 	<CFQUERY name="ListJackNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.ROOMNUMBER, WJ.WALLDIRID, WD.WALLDIRNAME, WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.CUSTOMERID, CUST.FULLNAME,
				LOC.ROOMNUMBER || ' - ' || WD.WALLDIRNAME || ' - ' || WJ.CLOSET || ' - ' || WJ.JACKNUMBER || ' - ' || WJ.PORTLETTER || ' - ' || CUST.FULLNAME AS KEYFINDER
		FROM		WALLJACKS WJ, LOCATIONS LOC, WALLDIRECTION WD, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WJ.LOCATIONID = LOC.LOCATIONID AND
				WJ.WALLDIRID = WD.WALLDIRID AND
				WJ.CUSTOMERID = CUST.CUSTOMERID
		ORDER BY	LOC.ROOMNUMBER, WJ.JACKNUMBER, WJ.PORTLETTER
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPWALLJACK')>
			<TD align="center"><H1>Modify/Delete Lookup Information in Facilties - Wall Jack</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information in Facilties - Wall Jack</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPWALLJACK')>
		<TR>
			<TH align="center">Wall Jack Key &nbsp; = &nbsp; #FORM.JACKID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPWALLJACK')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPWALLJACK=FOUND" method="POST">
			<TR>
				<TH align="left" nowrap><LABEL for="JACKID">Select by <H4>*Room Number - Wall Direction - Closet - Jack Number - Port Letter - Customer</H4></label></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="JACKID" id="JACKID" size="1" query="ListJackNumbers" value="WALLJACKID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD  align="left"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="#Cookie.INDEXDIR#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
*************************************************************************
* The following code is the Modify and Delete Processes for Wall Jacks. *
*************************************************************************
 --->

		<CFQUERY name="GetJackNumbers" datasource="#application.type#FACILITIES">
			SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAME, WJ.WALLDIRID, WD.WALLDIRNAME,
					WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.ACTIVE, WJ.INSERTTYPE, WJ.VLANID, WJ.HARDWAREID, HI.HARDWAREID,
					HI.BARCODENUMBER, HI.IPADDRESS, WJ.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WJ.COMMENTS,
					WJ.MODIFIEDBYID, WJ.MODIFIEDDATE, BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
			FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN, WALLDIRECTION WD, HARDWMGR.HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	WJ.WALLJACKID = <CFQUERYPARAM value="#FORM.JACKID#" cfsqltype="CF_SQL_NUMERIC"> AND
					WJ.LOCATIONID = LOC.LOCATIONID AND
					LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
					WJ.WALLDIRID = WD.WALLDIRID AND
					WJ.HARDWAREID = HI.HARDWAREID AND
					WJ.CUSTOMERID = CUST.CUSTOMERID 
			ORDER BY	LOC.ROOMNUMBER, WJ.JACKNUMBER, WJ.PORTLETTER
		</CFQUERY>


		<TABLE width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessWallJack" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="WALLJACK" action="/#application.type#apps/facilities/processwalljacksinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="JACKID" secure="NO" value="#FORM.JACKID#">
			</TR>
			<TR>
				<TH align="left"><LABEL for="JACKROOM">Jack Location</LABEL></TH>
				<TH align="left"><LABEL for="WALLDIRID">Wall Direction</LABEL></TH>
			</TR>
			<TR>
				<TD>
					<CFSELECT name="JACKROOM" id="JACKROOM" size="1" query="ListRoomNumbers" value="LOCATIONID" display="BUILDINGROOM" selected="#GetJackNumbers.LOCATIONID#" required="No" tabindex="2"></CFSELECT>
				</TD>
				<TD>
					<CFSELECT name="WALLDIRID" id="WALLDIRID" size="1" query="ListWallDirection" value="WALLDIRID" display="WALLDIRNAME" selected="#GetJackNumbers.WALLDIRID#" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="CLOSET">Closet</LABEL></TH>
				<TH align="left"><LABEL for="JACKNUMBER">Jack Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" nowrap><CFINPUT type="Text" name="CLOSET" id="CLOSET" value="#GetJackNumbers.CLOSET#" align="LEFT" required="No" size="10" tabindex="4"></TD>
				<TD align="left" nowrap><CFINPUT type="Text" name="JACKNUMBER" id="JACKNUMBER" value="#GetJackNumbers.JACKNUMBER#" align="LEFT" required="No" size="4" tabindex="5"></TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="PORTLETTER">Port Letter</LABEL></TH>
				<TH align="left"><LABEL for="ACTIVE">Active?</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="PORTLETTER" id="PORTLETTER" size="1" required="No" tabindex="6">
						<OPTION selected value="#GetJackNumbers.PORTLETTER#">#GetJackNumbers.PORTLETTER#</OPTION>
						<OPTION value="0">PORT LETTER</OPTION>
                              <OPTION value="A">A</OPTION>
                              <OPTION value="B">B</OPTION>
                              <OPTION value="C">C</OPTION>
                              <OPTION value="D">D</OPTION>
                              <OPTION value="E">E</OPTION>
                              <OPTION value="F">F</OPTION>
                              <OPTION value="WL">WIRELESS</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="7">
						<OPTION selected value="#GetJackNumbers.ACTIVE#">#GetJackNumbers.ACTIVE#</OPTION>
						<OPTION value="YES">YES</OPTION>
						<OPTION value="NO">NO</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="INSERTTYPE">Insert Type</LABEL></TH>
				<TH align="left"><LABEL for="VLANID">VLAN</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="INSERTTYPE" id="INSERTTYPE" size="1" tabindex="8">
						<OPTION selected value="#GetJackNumbers.INSERTTYPE#">#GetJackNumbers.INSERTTYPE#</OPTION>
						<OPTION value="INSERT">Select Insert Type</OPTION>
						<OPTION value="DATA">DATA</OPTION>
						<OPTION value="ONE CARD">ONE CARD</OPTION>
						<OPTION value="PHONE">PHONE</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="VLANID" id="VLANID" size="1" query="ListVLanInfo" value="VLANID" selected="#GetJackNumbers.VLANID#" display="VLANKEY" required="No" tabindex="9"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="HARDWAREID">Barcode</LABEL></TH>
				<TH align="left">IP Address</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="HARDWAREID" id="HARDWAREID" size="1" query="LookupHardwareBarCode" value="HARDWAREID" display="KEYFINDER" selected="#GetJackNumbers.HARDWAREID#" required="No" tabindex="10"></CFSELECT>
				</TD>
				<TD align="left" nowrap>#GetJackNumbers.IPADDRESS#</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="CUSTOMERID">Customer</LABEL></TH>
				<TH align="left"><LABEL for="COMMENTS">Comments</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#GetJackNumbers.CUSTOMERID#" required="No" tabindex="11"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP"><CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="12">#GetJackNumbers.COMMENTS#</CFTEXTAREA></TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
				<TH align="left">Date Modified</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="13"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
				</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessWallJack" value="MODIFY" tabindex="14" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessWallJack" value="DELETE" tabindex="15" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessWallJack" value="Cancel" tabindex="16" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>