<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: shareddatadbreports.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/28/2012 --->
<!--- Date in Production: 08/28/2012 --->
<!--- Module: Shared Data - Customer Reports--->
<!-- Last modified by John R. Pastori on 01/07/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/shareddatadbreports.cfm">
<CFSET CONTENT_UPDATED = "January 07, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Shared Data - Customer Report Selection Lookup</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Shared Data";
	
	
	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCUSTOMER')>
	<CFSET CURSORFIELD = "document.LOOKUP.CUSTOMERFIRSTNAME.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*********************************************************************
* The following code is the Look Up Process for Shared Data Reports *
*********************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPCUSTOMER')>

	<CFQUERY name="LookupCustomerCategories" datasource="#application.type#LIBSHAREDDATA" blockfactor="15">
		SELECT	CATEGORYID, CATEGORYNAME
		FROM		CATEGORIES
		ORDER BY	CATEGORYNAME
	</CFQUERY>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="60">
		SELECT	UNITID, UNITNAME, UNITNAME || ' - ' || UNITID AS UNITLOOKUP
		FROM		UNITS
		ORDER BY	UNITNAME
	</CFQUERY>

	<CFQUERY name="LookupGroups" datasource="#application.type#LIBSHAREDDATA" blockfactor="7">
		SELECT	GROUPID, GROUPNAME, MANAGEMENTID
		FROM		GROUPS
		ORDER BY	GROUPNAME
	</CFQUERY>

	<CFQUERY name="LookupDepartments" datasource="#application.type#LIBSHAREDDATA" blockfactor="12">
		SELECT	DEPARTMENTID, DEPARTMENTNAME
		FROM		DEPARTMENTS
		ORDER BY	DEPARTMENTID
	</CFQUERY>

	<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOCATIONID, ROOMNUMBER
		FROM		LOCATIONS
		ORDER BY	ROOMNUMBER
	</CFQUERY>

	<CFQUERY name="ListSecurityLevels" datasource="#application.type#LIBSECURITY" blockfactor="8">
		SELECT	SECURITYLEVELID, SECURITYLEVELNUMBER, SECURITYLEVELNAME
		FROM		SECURITYLEVELS
		ORDER BY	SECURITYLEVELNAME
	</CFQUERY>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 700 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 30
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Customer Report Selection Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
				Checking an adjacent checkbox will Negate the selection or data entered.</H2>
			</TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	
     <FIELDSET>
     <LEGEND>Criteria Selection</LEGEND>
<CFFORM name="LOOKUP" action="/#application.type#apps/libshareddata/shareddatadbreports.cfm?LOOKUPCUSTOMER=FOUND" method="POST">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERFIRSTNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERFIRSTNAME">Customer's First Name</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERLASTNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERLASTNAME">Or Customer's Last Name</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERFIRSTNAME" id="NEGATECUSTOMERFIRSTNAME" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="CUSTOMERFIRSTNAME" id="CUSTOMERFIRSTNAME" value="" align="LEFT" required="No" size="17" tabindex="3">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERLASTNAME" id="NEGATECUSTOMERLASTNAME" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="CUSTOMERLASTNAME" id="CUSTOMERLASTNAME" value="" align="LEFT" required="No" size="17" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECATEGORYID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CATEGORYID">Customer Category</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECATEGORYNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CATEGORYNAME">
				(1) a series of Customer Categories separated by commas,NO spaces or <BR />
				&nbsp;(2) two Customer Categories separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECATEGORYID" id="NEGATECATEGORYID" value="" align="LEFT" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="LookupCustomerCategories" value="CATEGORYID" display="CATEGORYNAME" selected="0" required="No" tabindex="7"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECATEGORYNAME" id="NEGATECATEGORYNAME" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="CATEGORYNAME" id="CATEGORYNAME" value="" required="No" size="50" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" width="45%">
				<LABEL for="ACTIVE">Active or Inactive Customers</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDEPARTMENTID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DEPARTMENTID">Department Name</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="10">
					<OPTION value="Make a Selection">Make a Selection</OPTION>
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDEPARTMENTID" id="NEGATEDEPARTMENTID" value="" align="LEFT" required="No" tabindex="11">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="DEPARTMENTID" id="DEPARTMENTID" size="1" query="LookupDepartments" value="DEPARTMENTID" display="DEPARTMENTNAME" selected="0" required="No" tabindex="12"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEUNITID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="UNITID">
				Select (1) Unit Name</LABEL> or <LABEL for="UNITNUMBER">enter (2) a 
				series of Unit Numbers separated by <BR>&nbsp;commas,NO spaces.</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEGROUPID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="GROUPID">Group</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" align="LEFT" required="No" tabindex="13">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="LookupUnits" value="UNITID" display="UNITLOOKUP" selected="0" required="No" tabindex="14"></CFSELECT>
				<CFINPUT type="Text" name="UNITNUMBER" id="UNITNUMBER" value="" required="No" size="20" maxlength="30" tabindex="15">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEGROUPID" id="NEGATEGROUPID" value="" align="LEFT" required="No" tabindex="16">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="GROUPID" id="GROUPID" size="1" query="LookupGroups" value="GROUPID" display="GROUPNAME" required="Yes" message="A Group Name MUST be selected!" tabindex="17"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
          	<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEEMAILADDRESS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
               	<LABEL for="EMAILADDRESS">E-Mail Address</LABEL>
               </TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECAMPUSPHONE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
               <TH align="left" valign="BOTTOM" width="45%">
               	<LABEL for="CAMPUSPHONE">Campus Phone Number</LABEL>
               </TH>
		</TR>
		<TR>
          	<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEEMAILADDRESS" id="NEGATEEMAILADDRESS" value="" align="LEFT" required="No" tabindex="18">
			</TD>
			<TD align="left" valign="TOP" width="45%">
               	<CFINPUT type="Text" name="EMAILADDRESS" id="EMAILADDRESS" value="" align="LEFT" required="No" size="25" tabindex="19">
               </TD>
               <TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECAMPUSPHONE" id="NEGATECAMPUSPHONE" value="" align="LEFT" required="No" tabindex="20">
			</TD>
			<TD align="left" valign="TOP" width="45%">
               	<CFINPUT type="Text" name="CAMPUSPHONE" id="CAMPUSPHONE" value="" align="LEFT" required="No" size="12" tabindex="21">
               </TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESECONDCAMPUSPHONE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
               	<LABEL for="SECONDCAMPUSPHONE">2nd Campus Phone Number</LABEL>
               </TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECELLPHONE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
               <TH align="left" valign="BOTTOM" width="45%">
               	<LABEL for="CELLPHONE">Cell Phone Number</LABEL>
               </TH>
		</TR>
		<TR>
          	<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESECONDCAMPUSPHONE" id="NEGATESECONDCAMPUSPHONE" value="" align="LEFT" required="No" tabindex="22">
			</TD>
			<TD align="left" valign="TOP" width="45%">
               	<CFINPUT type="Text" name="SECONDCAMPUSPHONE" id="SECONDCAMPUSPHONE" value="" align="LEFT" size="25" tabindex="23">
               </TD>
               <TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECELLPHONE" id="NEGATECELLPHONE" value="" align="LEFT" required="No" tabindex="24">
			</TD>
			<TD align="left" valign="TOP" width="45%">
               	<CFINPUT type="Text" name="CELLPHONE" id="CELLPHONE" value="" align="LEFT" required="No" size="25" tabindex="25">
               </TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREDID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REDID">Red ID</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEROOMNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="LOCATIONID">
				(1) Select a Room Number</LABEL> or <LABEL for="ROOMNUMBER">(2) Enter a Room Number or <BR />
				&nbsp;(3) Enter a series of Room Numbers separated by commas,NO spaces.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREDID" id="NEGATEREDID" value="" align="LEFT" required="No" tabindex="26">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="REDID" id="REDID" value="" align="LEFT" required="No" size="12" tabindex="27">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEROOMNUMBER" id="NEGATEROOMNUMBER" value="" align="LEFT" required="No" tabindex="28">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="LookupRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="29"></CFSELECT>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBER" value="" required="No" size="20" maxlength="50" tabindex="30">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESECURITYLEVELID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SECURITYLEVELID">Security Level</LABEL>
			</TH>
               <TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDATACENTERACCESS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DATACENTERACCESS">Data Center Access</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESECURITYLEVELID" id="NEGATESECURITYLEVELID" value="" align="LEFT" required="No" tabindex="31">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="SECURITYLEVELID" id="SECURITYLEVELID" size="1" query="ListSecurityLevels" value="SECURITYLEVELID" display="SECURITYLEVELNAME" selected="0" required="No" tabindex="32"></CFSELECT>
			</TD>
               <TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDATACENTERACCESS" id="NEGATEDATACENTERACCESS" value="" align="LEFT" required="No" tabindex="33">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="DATACENTERACCESS" id="DATACENTERACCESS" size="1" tabindex="34">
                    	<OPTION value="Make a Selection">Make a Selection</OPTION>
                         <OPTION value="NONE">NONE</OPTION>
                         <OPTION value="CONTROLLING">CONTROLLING</OPTION>
                         <OPTION value="ESCORTED">ESCORTED</OPTION>
                         <OPTION value="UNESCORTED">UNESCORTED</OPTION>
                    </CFSELECT>
			</TD>
          </TR>
          <TR>
               <TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEACCOUNTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="ACCOUNTS">Accounts</LABEL>
			</TH>
               <TH align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
               <TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="VOICEMAIL">Voice Mail</LABEL>
			</TH>
		</TR>
		<TR>
		<TR>
               <TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEACCOUNTS" id="NEGATEACCOUNTS" value="" align="LEFT" required="No" tabindex="35">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="ACCOUNTS" id="ACCOUNTS" value="" align="LEFT" required="No" size="20" tabindex="36">
			</TD>
               <TD align="LEFT" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
               <TD align="LEFT" valign="TOP" width="45%">
                    <CFSELECT name="VOICEMAIL" id="VOICEMAIL" size="1" tabindex="37">
                         <OPTION value="Make a Selection">Make a Selection</OPTION>
                         <OPTION value="YES">YES</OPTION>
                         <OPTION value="NO">NO</OPTION>
                    </CFSELECT>
               </TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDIALINGCAPABILITY">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DIALINGCAPABILITY">Dialing Capability</LABEL>
			</TH>
			<TH align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" valign="BOTTOM" width="45%">
				<LABEL for="LONGDISTAUTHCODE">Long Distance Authorization Code</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDIALINGCAPABILITY" id="NEGATEDIALINGCAPABILITY" value="" align="LEFT" required="No" tabindex="38">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="DIALINGCAPABILITY" id="DIALINGCAPABILITY" size="1" tabindex="39">
					<OPTION value="Make a Selection">Make a Selection</OPTION>
					<OPTION value="3-CAMPUS, LOCAL AND SD COUNTY">3-CAMPUS, LOCAL AND SD COUNTY</OPTION>
                         <OPTION value="2-CAMPUS AND LOCAL">2-CAMPUS AND LOCAL</OPTION>
                         <OPTION value="1-CAMPUS">1-CAMPUS</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="LONGDISTAUTHCODE" id="LONGDISTAUTHCODE" size="1" tabindex="40">
					<OPTION value="Make a Selection">Make a Selection</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" width="45%">
				<LABEL for="UNITHEAD">Unit Head</LABEL>
			</TH>
			<TH align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" width="45%">
				<LABEL for="DEPTCHAIR">Department Chair</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="UNITHEAD" id="UNITHEAD" size="1" tabindex="41">
					<OPTION value="Make a Selection">Make a Selection</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="DEPTCHAIR" id="DEPTCHAIR" size="1" tabindex="42">
					<OPTION value="Make a Selection">Make a Selection</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" width="45%">
				<LABEL for="CONTACTBY">Contact-By</LABEL>
			</TH>
			<TH align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" width="45%">
				<LABEL for="BIBLIOGRAPHER">Bibliographer</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="CONTACTBY" id="CONTACTBY" size="1" tabindex="43">
					<OPTION value="Make a Selection">Make a Selection</OPTION>
					<OPTION value="E-MAIL">E-MAIL</OPTION>
					<OPTION value="PHONE">PHONE</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="BIBLIOGRAPHER" id="BIBLIOGRAPHER" size="1" tabindex="44">
					<OPTION value="Make a Selection">Make a Selection</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECOMMENTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="COMMENTS">Comments</LABEL>
			</TH>
			<TH class="TH_negate"align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEAA_COMMENTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="AA_COMMENTS">AA Comments</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOMMENTS" id="NEGATECOMMENTS" value="" align="LEFT" required="No" tabindex="45">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="COMMENTS" id="COMMENTSR" value="" align="LEFT" required="No" size="50" tabindex="46">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAA_COMMENTS" id="NEGATEAA_COMMENTS" value="" align="LEFT" required="No" tabindex="47">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="AA_COMMENTS" id="AA_COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="48">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDBYID">Modified By</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDDATE">
				(1) a single Date Modified or (2) a series of dates separated<BR />
				&nbsp;by commas,NO spaces or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="49">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="50">
					<OPTION value="0">MODIFIED BY</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="51">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="52">
			</TD>
		</TR>
	</TABLE>
     </FIELDSET>
     <BR />
     <FIELDSET>
     <LEGEND>Report Selection</LEGEND>
     <TABLE width="100%" border="0">
		<TR>
			<TH align="LEFT" colspan="6"><H2>Click the radio button on the report you want to run. &nbsp;&nbsp;Only one report can be run at a time.</H2></TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="6">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="BOTTOM" colspan="2">
				CUSTOMER REPORTS
			</TH>
			<TH align="LEFT" valign="BOTTOM" colspan="2">
				UNIT REPORTS
			</TH>
               <TH align="LEFT" valign="BOTTOM" colspan="2">
				ACCESS REPORTS
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="53"><LABEL for="REPORTCHOICE1">Full Customer List</LABEL><BR />

				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="54"><LABEL for="REPORTCHOICE2">IDT Customer List</LABEL><BR />

				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="55"><LABEL for="REPORTCHOICE3">LibAdmin Customer List</LABEL><BR />
				
			</TD>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="56"><LABEL for="REPORTCHOICE4">Customer By Unit</LABEL><BR />

                    <CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="57"><LABEL for="REPORTCHOICE5">Customer Contact List</LABEL><BR />
	
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE6" value="6" align="LEFT" required="No" tabindex="58"><LABEL for="REPORTCHOICE6">Red ID By Group/Unit</LABEL><BR />
               </TD>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE7" value="7" align="LEFT" required="No" tabindex="59"><LABEL for="REPORTCHOICE7">Data Center</LABEL><BR />
                    <CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE8" value="8" align="LEFT" required="No" tabindex="60"><LABEL for="REPORTCHOICE8">Phone Line Access</LABEL><BR />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="6">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="6"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="LEFT" colspan="6"><H2>Clicking the "Match All" Button with no selections equals ALL records for the requested report.</H2></TH>
		</TR>
          <TR>
			<TD align="LEFT" colspan="6">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="61" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="6">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" onClick="return setMatchAll();" tabindex="62" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>

     </FIELDSET>
     <BR />
     <TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="4">
				<BR /><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="63" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*******************************************************************
* The following code is the Shared Data Report Generation Process *
*******************************************************************
 --->

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'CUST.FULLNAME'>
	<CFSET SORTORDER[2] = 'CUST.FULLNAME'>
	<CFSET SORTORDER[3] = 'CUST.FULLNAME'>
	<CFSET SORTORDER[4] = 'U.UNITNAME~ CUST.FULLNAME'>
     <CFSET SORTORDER[5] = 'U.UNITNAME~ CUST.FULLNAME'>
	<CFSET SORTORDER[6] = 'G.GROUPNAME~ U.UNITNAME~ CUST.REDID'>
     <CFSET SORTORDER[7] = 'CUST.DATACENTERACCESS~ CUST.FULLNAME'>
     <CFSET SORTORDER[8] = 'CUST.FULLNAME'>
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>

	<CFIF FIND('~', #REPORTORDER#, 1) NEQ 0>
		<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>
	<!--- REPORT ORDER = #REPORTORDER#<BR><BR>
	<CFELSE>
		REPORT ORDER = #REPORTORDER# --->
	</CFIF>

	<CFIF #FORM.CATEGORYID# GT 0>

		<CFQUERY name="ListCustomerCategories" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CAT.CATEGORYID, CAT.CATEGORYNAME, CUST.CUSTOMERID, CUST.CATEGORYID
			FROM		CATEGORIES CAT, CUSTOMERS CUST
			WHERE	CAT.CATEGORYID = <CFQUERYPARAM value="#FORM.CATEGORYID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CAT.CATEGORYID = CUST.CATEGORYID
			ORDER BY	CATEGORYNAME
		</CFQUERY>

		<CFIF #ListCustomerCategories.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Customer Category were Not Found");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/libshareddata/shareddatadbreports.cfm" />
			<CFEXIT>
		</CFIF>
	</CFIF>

	<CFIF #FORM.CATEGORYNAME# NEQ "">
		<CFSET CATEGORYNAMELIST = "NO">
		<CFSET CATEGORYNAMERANGE = "NO">
		<CFIF FIND(',', #FORM.CATEGORYNAME#, 1) NEQ 0>
			<CFSET CATEGORYNAMELIST = "YES">
			<CFSET FORM.CATEGORYNAME = UCASE(#FORM.CATEGORYNAME#)>
			<CFSET FORM.CATEGORYNAME = ListQualify(FORM.CATEGORYNAME,"'",",","CHAR")>
		<CFELSEIF FIND(';', #FORM.CATEGORYNAME#, 1) NEQ 0>
			<CFSET CATEGORYNAMERANGE = "YES">
			<CFSET FORM.CATEGORYNAME = #REPLACE(FORM.CATEGORYNAME, ";", ",")#>
			<CFSET CATEGORYNAMEARRAY = ListToArray(FORM.CATEGORYNAME)>
			<!--- <CFLOOP index="Counter" from=1 to=#ArrayLen(CATEGORYNAMEARRAY)# >
				CATEGORYNAME FIELD #Counter# = #CATEGORYNAMEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF CATEGORYNAMERANGE EQ "YES">
			<CFSET BEGINCATEGORYNAME = #CATEGORYNAMEARRAY[1]#>
			<CFSET ENDCATEGORYNAME = #CATEGORYNAMEARRAY[2]#>
		</CFIF>
		<CFQUERY name="ListCategoryName" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CATEGORYID, CATEGORYNAME
			FROM		CATEGORIES
		<CFIF CATEGORYNAMELIST EQ "YES">
			WHERE	CATEGORYNAME IN (#PreserveSingleQuotes(FORM.CATEGORYNAME)#)
		<CFELSE>
			WHERE	CATEGORYNAME BETWEEN '#BEGINCATEGORYNAME#' AND '#ENDCATEGORYNAME#'
		</CFIF>
			ORDER BY	CATEGORYNAME
		</CFQUERY>
		<CFIF #ListCategoryName.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Entered Category Names were NOT found.");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/libshareddata/shareddatadbreports.cfm" />
			<CFEXIT>
		</CFIF>
		<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUSTOMERID, LASTNAME, FIRSTNAME, INITIALS, CATEGORYID, EMAIL, CAMPUSPHONE, SECONDCAMPUSPHONE, CELLPHONE, FAX,
					FULLNAME, DIALINGCAPABILITY, LONGDISTAUTHCODE, VOICEMAIL, TELEPHONELISTING, UNITID, LOCATIONID, UNITHEAD,
                         DEPTCHAIR, ALLOWEDTOAPPROVE, CONTACTBY, SECURITYLEVELID, PASSWORD, BIBLIOGRAPHER, COMMENTS, AA_COMMENTS,
                         MODIFIEDBYID, MODIFIEDDATE, ACTIVE, ACCOUNTS
			FROM		CUSTOMERS
			WHERE	CATEGORYID IN (#ValueList(ListCategoryName.CATEGORYID)#)
			ORDER BY	FULLNAME
		</CFQUERY>
		<CFIF #ListCustomers.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Customers were NOT found in the selected Customer Categories.");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/libshareddata/shareddatadbreports.cfm" />
			<CFEXIT>
		</CFIF>
	</CFIF>

	<CFIF #FORM.UNITID# GT 0 OR NOT #FORM.UNITNUMBER# EQ ''>

		<CFQUERY name="ListCustUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUST.CUSTOMERID, CUST.UNITID, U.UNITID, U.UNITNAME
			FROM		CUSTOMERS CUST, UNITS U
		<CFIF #FORM.UNITID# GT 0>
			WHERE	CUST.UNITID = #val(FORM.UNITID)# AND
		<CFELSE>
			WHERE	CUST.UNITID IN (#FORM.UNITNUMBER#) AND
		</CFIF>
					CUST.UNITID = U.UNITID
			ORDER BY	U.UNITNAME
		</CFQUERY>
          
          <CFIF #ListCustUnits.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Customers were NOT found in the selected Customer Unit(s).");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/libshareddata/shareddatadbreports.cfm" />
			<CFEXIT>
		</CFIF>

	</CFIF>

	<CFIF #FORM.GROUPID# GT 0>

		<CFQUERY name="LookupGroupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="60">
			SELECT	U.UNITID, U.UNITNAME, G.GROUPID, G.GROUPNAME
			FROM		UNITS U, GROUPS G
			WHERE	U.GROUPID = #FORM.GROUPID# AND
					U.GROUPID = G.GROUPID
			ORDER BY	G.GROUPNAME, U.UNITNAME
		</CFQUERY>

		<CFQUERY name="ListCustGroups" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUST.CUSTOMERID, CUST.UNITID, U.UNITID, U.UNITNAME
			FROM		CUSTOMERS CUST, UNITS U
			WHERE	CUST.UNITID IN (#ValueList(LookupGroupUnits.UNITID)#) AND
					CUST.UNITID = U.UNITID
			ORDER BY	U.UNITNAME
		</CFQUERY>

	</CFIF>

	<CFIF #FORM.ROOMNUMBER# NEQ "">
		<CFSET ROOMLIST = "NO">
		<CFIF FIND(',', #FORM.ROOMNUMBER#, 1) NEQ 0>
			<CFSET ROOMLIST = "YES">
			<CFSET FORM.ROOMNUMBER = UCASE(#FORM.ROOMNUMBER#)>
			<CFSET FORM.ROOMNUMBER = ListQualify(FORM.ROOMNUMBER,"'",",","CHAR")>
			ROOMNUMBER FIELD = #FORM.ROOMNUMBER#<BR /><BR />
		</CFIF>
		<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
		<CFIF ROOMLIST EQ "YES">
			WHERE	ROOMNUMBER IN (#PreserveSingleQuotes(FORM.ROOMNUMBER)#)
		<CFELSE>
			WHERE	ROOMNUMBER LIKE (UPPER('#FORM.ROOMNUMBER#%'))
		</CFIF>
			ORDER BY	ROOMNUMBER
		</CFQUERY>
		<CFIF #LookupRoomNumbers.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Room Number were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/libshareddata/shareddatadbreports.cfm" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
			ORDER BY	ROOMNUMBER
		</CFQUERY>
	</CFIF>

	<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
		<CFSET MODIFIEDDATELIST = "NO">
		<CFSET MODIFIEDDATERANGE = "NO">
		<CFIF FIND(',', #FORM.MODIFIEDDATE#, 1) EQ 0 AND FIND(';', #FORM.MODIFIEDDATE#, 1) EQ 0>
			<CFSET FORM.MODIFIEDDATE = DateFormat(FORM.MODIFIEDDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.MODIFIEDDATE#, 1) NEQ 0>
				<CFSET MODIFIEDDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.MODIFIEDDATE#, 1) NEQ 0>
				<CFSET MODIFIEDDATERANGE = "YES">
				<CFSET FORM.MODIFIEDDATE = #REPLACE(FORM.MODIFIEDDATE, ";", ",")#>
			</CFIF>
			<CFSET MODIFIEDDATEARRAY = ListToArray(FORM.MODIFIEDDATE)>
			<!--- <CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)# >
				MODIFIEDDATE FIELD #Counter# = #MODIFIEDDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF MODIFIEDDATERANGE EQ "YES">
			<CFSET BEGINMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		MODIFIEDDATELIST = #MODIFIEDDATELIST#<BR /><BR />
		MODIFIEDDATERANGE = #MODIFIEDDATERANGE#<BR /><BR />
	</CFIF>

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = "!=">
	</CFIF>

	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FIRSTNAME, CUST.FULLNAME, CUST.INITIALS, CUST.CATEGORYID,
				CAT.CATEGORYNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.SECONDCAMPUSPHONE, CUST.CELLPHONE, CUST.FAX,
				CUST.DIALINGCAPABILITY, CUST.LONGDISTAUTHCODE, CUST.VOICEMAIL, CUST.PHONEBOOKLISTING, CUST.ANALOGLINE, CUST.UNITID,
				U.UNITNAME, G.GROUPNAME, U.UNITNAME || '/' || G.GROUPNAME AS UNITGROUP, G.GROUPNAME || '/' || U.UNITNAME AS GROUPUNIT,
				U.CAMPUSMAILCODEID, DEPTS.DEPARTMENTNAME, CUST.LOCATIONID, LOC.LOCATIONID, LOC.ROOMNUMBER, CUST.UNITHEAD,
				CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE, CUST.CONTACTBY, CUST.SECURITYLEVELID, CUST.BIBLIOGRAPHER, CUST.COMMENTS,
				CUST.AA_COMMENTS, CUST.MODIFIEDBYID, CUST.MODIFIEDDATE, CUST.ACTIVE, CUST.REDID, CUST.ACCOUNTS, CUST.DATACENTERACCESS
		FROM		CUSTOMERS CUST, CATEGORIES CAT, UNITS U, GROUPS G, DEPARTMENTS DEPTS, FACILITIESMGR.LOCATIONS LOC
		WHERE	(CUST.CUSTOMERID > 0 AND
				CUST.CATEGORYID = CAT.CATEGORYID AND
				CUST.UNITID = U.UNITID AND
				U.GROUPID = G.GROUPID AND
				U.DEPARTMENTID = DEPTS.DEPARTMENTID AND
          	<CFIF #FORM.REPORTCHOICE# EQ 5>
                    CUST.ACTIVE = 'YES' AND
             	</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 3>
				U.DEPARTMENTID = 8 AND   <!--- LIBRARY SERVICES --->
			</CFIF>
				CUST.LOCATIONID = LOC.LOCATIONID) AND (

		<CFIF #FORM.CUSTOMERFIRSTNAME# NEQ "">
			<CFIF IsDefined("FORM.NEGATECUSTOMERFIRSTNAME")>
				NOT CUST.FIRSTNAME LIKE UPPER('#FORM.CUSTOMERFIRSTNAME#%') #LOGICANDOR#
			<CFELSE>
				CUST.FIRSTNAME LIKE UPPER('#FORM.CUSTOMERFIRSTNAME#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CUSTOMERLASTNAME# NEQ "">
			<CFIF IsDefined("FORM.NEGATECUSTOMERLASTNAME")>
				NOT CUST.LASTNAME LIKE UPPER('#FORM.CUSTOMERLASTNAME#%') #LOGICANDOR#
			<CFELSE>
				CUST.LASTNAME LIKE UPPER('#FORM.CUSTOMERLASTNAME#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CATEGORYID# GT 0>
			<CFIF IsDefined("FORM.NEGATECATEGORYID")>
				NOT CUST.CUSTOMERID IN (#ValueList(ListCustomerCategories.CUSTOMERID)#) #LOGICANDOR#
			<CFELSE>
				CUST.CUSTOMERID IN (#ValueList(ListCustomerCategories.CUSTOMERID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CATEGORYNAME# NEQ "">
			<CFIF IsDefined("FORM.NEGATECATEGORYNAME")>
				NOT CUST.CUSTOMERID IN (#ValueList(ListCustomers.CUSTOMERID)#) #LOGICANDOR#
			<CFELSE>
				CUST.CUSTOMERID IN (#ValueList(ListCustomers.CUSTOMERID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ACTIVE# NEQ "Make a Selection">
			CUST.ACTIVE = UPPER('#FORM.ACTIVE#') #LOGICANDOR#
		</CFIF>

		<CFIF #FORM.DEPARTMENTID# GT 0>
			<CFIF IsDefined("FORM.NEGATEDEPARTMENTID")>
				NOT U.DEPARTMENTID = #val(FORM.DEPARTMENTID)# #LOGICANDOR#
			<CFELSE>
				U.DEPARTMENTID = #val(FORM.DEPARTMENTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.UNITID# GT 0 OR NOT #FORM.UNITNUMBER# EQ ''>
			<CFIF IsDefined("FORM.NEGATEUNITID")>
				NOT CUST.CUSTOMERID IN (#ValueList(ListCustUnits.CUSTOMERID)#) #LOGICANDOR#
			<CFELSE>
				CUST.CUSTOMERID IN (#ValueList(ListCustUnits.CUSTOMERID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.GROUPID# GT 0>
			<CFIF IsDefined("FORM.NEGATEGROUPID")>
				NOT CUST.CUSTOMERID IN (#ValueList(ListCustGroups.CUSTOMERID)#) #LOGICANDOR#
			<CFELSE>
				CUST.CUSTOMERID IN (#ValueList(ListCustGroups.CUSTOMERID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.EMAILADDRESS# NEQ "">
			<CFIF IsDefined("FORM.NEGATEEMAILADDRESS")>
				NOT CUST.EMAIL LIKE '%#FORM.EMAILADDRESS#%' #LOGICANDOR#
			<CFELSE>
				CUST.EMAIL LIKE '%#FORM.EMAILADDRESS#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CAMPUSPHONE# NEQ "">
			<CFIF IsDefined("FORM.NEGATECAMPUSPHONE")>
				NOT CUST.CAMPUSPHONE LIKE '%#FORM.CAMPUSPHONE#%' #LOGICANDOR#
			<CFELSE>
				CUST.CAMPUSPHONE LIKE '%#FORM.CAMPUSPHONE#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SECONDCAMPUSPHONE# NEQ "">
			<CFIF IsDefined("FORM.NEGATESECONDCAMPUSPHONE")>
				NOT CUST.SECONDCAMPUSPHONE LIKE '%#FORM.SECONDCAMPUSPHONE#%' #LOGICANDOR#
			<CFELSE>
				CUST.SECONDCAMPUSPHONE LIKE '%#FORM.SECONDCAMPUSPHONE#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CELLPHONE# NEQ "">
			<CFIF IsDefined("FORM.NEGATECELLPHONE")>
				NOT CUST.CELLPHONE LIKE '%#FORM.CELLPHONE#%' #LOGICANDOR#
			<CFELSE>
				CUST.CELLPHONE LIKE '%#FORM.CELLPHONE#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REDID# NEQ "">
			<CFIF IsDefined("FORM.NEGATEREDID")>
				NOT CUST.REDID = '#FORM.REDID#' #LOGICANDOR#
			<CFELSE>
				CUST.REDID = '#FORM.REDID#' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.LOCATIONID# GT 0>
			<CFIF IsDefined("FORM.NEGATEROOMNUMBER")>
				NOT LOC.LOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
			<CFELSE>
				LOC.LOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.ROOMNUMBER# NEQ "">
			<CFIF IsDefined("FORM.NEGATEROOMNUMBER")>
				NOT LOC.LOCATIONID IN (#ValueList(LookupRoomNumbers.LOCATIONID)#) #LOGICANDOR#
			<CFELSE>
				LOC.LOCATIONID IN (#ValueList(LookupRoomNumbers.LOCATIONID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SECURITYLEVELID# GT 0>
			<CFIF IsDefined("FORM.NEGATESECURITYLEVEL")>
				NOT CUST.SECURITYLEVELID = #val(FORM.SECURITYLEVELID)# #LOGICANDOR#
			<CFELSE>
				CUST.SECURITYLEVELID = #val(FORM.SECURITYLEVELID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
          
          <CFIF #FORM.DATACENTERACCESS# NEQ "Make a Selection">
			<CFIF IsDefined("FORM.NEGATEDATACENTERACCESS")>
				NOT CUST.DATACENTERACCESS = '#FORM.DATACENTERACCESS#' #LOGICANDOR#
			<CFELSE>
				CUST.DATACENTERACCESS = '#FORM.DATACENTERACCESS#' #LOGICANDOR#
			</CFIF>
		</CFIF>


		<CFIF #FORM.ACCOUNTS# NEQ "">
			<CFIF IsDefined("FORM.NEGATEACCOUNTS")>
				NOT CUST.ACCOUNTS LIKE UPPER('%#FORM.ACCOUNTS#%') #LOGICANDOR#
			<CFELSE>
               	CUST.ACCOUNTS LIKE UPPER('%#FORM.ACCOUNTS#%') #LOGICANDOR#
			</CFIF>
		</CFIF>
          
          <CFIF #FORM.VOICEMAIL# NEQ "Make a Selection">
				CUST.VOICEMAIL = UPPER('#FORM.VOICEMAIL#') #LOGICANDOR#
		</CFIF>

		<CFIF #FORM.DIALINGCAPABILITY# NEQ "Make a Selection">
			<CFIF IsDefined("FORM.NEGATEDIALINGCAPABILITY")>
				NOT CUST.DIALINGCAPABILITY = UPPER('#FORM.DIALINGCAPABILITY#') #LOGICANDOR#
			<CFELSE>
				CUST.DIALINGCAPABILITY = UPPER('#FORM.DIALINGCAPABILITY#') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.LONGDISTAUTHCODE# NEQ "Make a Selection">
				CUST.LONGDISTAUTHCODE = UPPER('#FORM.LONGDISTAUTHCODE#') #LOGICANDOR#
		</CFIF>

		<CFIF #FORM.CONTACTBY# NEQ "Make a Selection">
				CUST.CONTACTBY = UPPER('#FORM.CONTACTBY#') #LOGICANDOR#
		</CFIF>

		<CFIF #FORM.UNITHEAD# NEQ "Make a Selection">
				CUST.UNITHEAD = UPPER('#FORM.UNITHEAD#') #LOGICANDOR#
		</CFIF>

		<CFIF #FORM.DEPTCHAIR# NEQ "Make a Selection">
				CUST.DEPTCHAIR = UPPER('#FORM.DEPTCHAIR#') #LOGICANDOR#
		</CFIF>

		<CFIF #FORM.BIBLIOGRAPHER# NEQ "Make a Selection">
				CUST.BIBLIOGRAPHER = UPPER('#FORM.BIBLIOGRAPHER#') #LOGICANDOR#
		</CFIF>

		<CFIF #FORM.COMMENTS# NEQ "">
			<CFIF IsDefined("FORM.NEGATECOMMENTS")>
				NOT CUST.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
			<CFELSE>
				CUST.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.AA_COMMENTS# NEQ "">
			<CFIF IsDefined("FORM.NEGATEAA_COMMENTS")>
				NOT CUST.AA_COMMENTS LIKE UPPER('%#FORM.AA_COMMENTS#%') #LOGICANDOR#
			<CFELSE>
				CUST.AA_COMMENTS LIKE UPPER('%#FORM.AA_COMMENTS#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.MODIFIEDBYID# GT 0>
				<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
					NOT CUST.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				<CFELSE>
					CUST.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

		<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
			<CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
						<CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						NOT CUST.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') AND
					</CFLOOP>
					<CFSET FINALTEST = ">">
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
					NOT (CUST.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					NOT CUST.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			<CFELSE>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
					(
					<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
						<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						CUST.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
					</CFLOOP>
					<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
					CUST.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) OR
					<CFSET FINALTEST = "=">
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
						(CUST.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					CUST.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>

				CUST.MODIFIEDBYID #FINALTEST# 0)
		ORDER BY	#REPORTORDER#
	</CFQUERY>

	<CFIF #ListCustomers.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/libshareddata/shareddatadbreports.cfm" />
		<CFEXIT>
	</CFIF>

<!--- 
*******************************************************
* The following code displays the Shared Data Reports *
*******************************************************
 --->

	<CFSWITCH expression = #FORM.REPORTCHOICE#>
		<CFCASE value = 1>
			<CFSET REPORTCHOICE = "FULL">
			<CFINCLUDE template="customerdbreport.cfm">
		</CFCASE>
		<CFCASE value = 2>
			<CFSET REPORTCHOICE = "IDT">
			<CFINCLUDE template="customerdbreport.cfm">
		</CFCASE>
		<CFCASE value = 3>
			<CFSET REPORTCHOICE = "LIBADMIN">
			<CFINCLUDE template="customerdbreport.cfm">
		</CFCASE>
		<CFCASE value = 4>
			<CFINCLUDE template="customerunitreport.cfm">
		</CFCASE>
          <CFCASE value = 5>
			<CFINCLUDE template="customercontactlist.cfm">
		</CFCASE>
		<CFCASE value = 6>
			<CFINCLUDE template="groupunitredidreport.cfm">
		</CFCASE>
          <CFCASE value = 7>
			<CFINCLUDE template="datacenteraccessreport.cfm">
		</CFCASE>
          <CFCASE value = 8>
			<CFINCLUDE template="phonelineaccessreport.cfm">
		</CFCASE>
		<CFDEFAULTCASE>
			<CFSET REPORTCHOICE = "FULL">
			<CFINCLUDE template="customerdbreport.cfm">
		</CFDEFAULTCASE>
	</CFSWITCH> 
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>