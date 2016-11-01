<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: customerinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Shared Data - Customer Info --->
<!-- Last modified by John R. Pastori on 01/07/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/customerinfo.cfm">
<CFSET CONTENT_UPDATED = "January 07, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Customer</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Customer</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to the Library Shared Data Application";

	if(window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {

		if (document.CUSTOMER.FIRSTNAME.value == "" || document.CUSTOMER.FIRSTNAME.value == " ") {
			alertuser (document.CUSTOMER.FIRSTNAME.name +  ",  A Customer's First Name MUST be entered!");
			document.CUSTOMER.FIRSTNAME.focus();
			return false;
		}

		if (document.CUSTOMER.LASTNAME.value == "" || document.CUSTOMER.LASTNAME.value == " ") {
			alertuser (document.CUSTOMER.LASTNAME.name +  ",  A Customer's Last Name MUST be entered!");
			document.CUSTOMER.LASTNAME.focus();
			return false;
		}

		if (document.CUSTOMER.CATEGORYID.selectedIndex == "0") {
			alertuser (document.CUSTOMER.CATEGORYID.name +  ",  A Customer's Category  MUST be selected!");
			document.CUSTOMER.CATEGORYID.focus();
			return false;
		}

		if (document.CUSTOMER.UNITID.selectedIndex == "0") {
			alertuser (document.CUSTOMER.UNITID.name +  ",  A Customer's Unit/Group Name MUST be selected!");
			document.CUSTOMER.UNITID.focus();
			return false;
		}

		if (document.CUSTOMER.EMAILADDRESS.value == "" || document.CUSTOMER.EMAILADDRESS.value == " "
		 || document.CUSTOMER.EMAILADDRESS.value == "@mail.sdsu.edu") {
			alertuser (document.CUSTOMER.EMAILADDRESS.name +  ",  A Customer's Email Address MUST be entered!");
			document.CUSTOMER.EMAILADDRESS.focus();
			return false;
		}

		if (document.CUSTOMER.LOCATIONID.selectedIndex == "0") {
			alertuser (document.CUSTOMER.LOCATIONID.name +  ",  A Customer's Room Number MUST be selected!");
			document.CUSTOMER.LOCATIONID.focus();
			return false;
		}

		if (document.CUSTOMER.CAMPUSPHONE.value == "" || document.CUSTOMER.CAMPUSPHONE.value == " ") {
			alertuser (document.CUSTOMER.CAMPUSPHONE.name +  ",  A Customer's Campus Phone Number MUST be entered!");
			document.CUSTOMER.CAMPUSPHONE.focus();
			return false;
		}

		if (document.CUSTOMER.PASSWORD != null && document.CUSTOMER.PASSWORD.value != ''
		 && document.CUSTOMER.PASSWORD.value.length != 8) {
			alertuser (document.CUSTOMER.PASSWORD.name +  ",  The New Password must be EXACTLY 8 characters");
			document.CUSTOMER.PASSWORD.focus();
			return false;
		}

		if (document.CUSTOMER.PASSWORD != null && document.CUSTOMER.PASSWORD.value != ''
		 && !document.CUSTOMER.PASSWORD.value.match(/[A-Z_]/)){
			alertuser (document.CUSTOMER.PASSWORD.name +  ",  A Password must have at least 1 Uppercase Letter!");
			document.CUSTOMER.PASSWORD.focus();
			return false;
		}

		if (document.CUSTOMER.PASSWORD != null && document.CUSTOMER.PASSWORD.value != ''
		 && !document.CUSTOMER.PASSWORD.value.match(/[a-z]/)){
			alertuser (document.CUSTOMER.PASSWORD.name +  ",  A Password must have at least 1 lowercase letter!");
			document.CUSTOMER.PASSWORD.focus();
			return false;
		}

		if (document.CUSTOMER.PASSWORD != null && document.CUSTOMER.PASSWORD.value != ''
		 && !document.CUSTOMER.PASSWORD.value.match(/[0-9]/)){
			alertuser (document.CUSTOMER.PASSWORD.name +  ",  A Password must have at least 1 number!");
			document.CUSTOMER.PASSWORD.focus();
			return false;
		}

		if  (document.CUSTOMER.PASSWORD != null && document.CUSTOMER.PASSWORD.value != ''
		 && !document.CUSTOMER.PASSWORD.value.match(/\W/)){
			alertuser (document.CUSTOMER.PASSWORD.name +  ",  A Password must have at least 1 special character!");
			document.CUSTOMER.PASSWORD.focus();
			return false;
		}

		if (document.CUSTOMER.PASSWORD != null && document.CUSTOMER.PASSWORD.value != ''
		 && document.CUSTOMER.PASSWORD.value.match(/\s/)) {
			alertuser (document.CUSTOMER.PASSWORD.name +  ",  A Password CANNOT contain spaces, carriage returns or tabs!");
			document.CUSTOMER.PASSWORD.focus();
			return false;
		}

	}

	function validateLookupField() {
		if (document.LOOKUP.CUSTID.selectedIndex == "0") {
			alertuser ("A Customer Name MUST be selected!");
			document.LOOKUP.CUSTID.focus();
			return false;
		}
	}


	function setDelete() {
		document.CUSTOMER.PROCESSCUSTOMER.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCUST') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.CUSTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CUSTOMER.FIRSTNAME.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*************************************************************
* The following code is for ALL Processes in Customer Info. *
*************************************************************
 --->

<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, LASTNAME, FIRSTNAME, INITIALS, CATEGORYID, EMAIL, CAMPUSPHONE, SECONDCAMPUSPHONE, CELLPHONE,
     		FAX, FULLNAME, DIALINGCAPABILITY, LONGDISTAUTHCODE, UNITID, LOCATIONID, UNITHEAD, DEPTCHAIR,
               ALLOWEDTOAPPROVE, CONTACTBY, DIALINGCAPABILITY, VOICEMAIL, PHONEBOOKLISTING, ANALOGLINE, SECURITYLEVELID, PASSWORD, 
               BIBLIOGRAPHER, COMMENTS, AA_COMMENTS, MODIFIEDBYID, MODIFIEDDATE, ACTIVE, REDID, ACCOUNTS, DATACENTERACCESS
	FROM		CUSTOMERS
	ORDER BY	FULLNAME
</CFQUERY>

<CFQUERY name="ListCustomerCategories" datasource="#application.type#LIBSHAREDDATA" blockfactor="15">
	SELECT	CATEGORYID, CATEGORYNAME
	FROM		CATEGORIES
	ORDER BY	CATEGORYNAME
</CFQUERY>

<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	U.UNITID, U.UNITNAME, CMC.CAMPUSMAILCODE, G.GROUPNAME, DEPT.DEPARTMENTNAME, U.ACTIVEUNIT,
			U.UNITNAME || ' - ' || G.GROUPNAME || ' - ' || DEPT.DEPARTMENTNAME AS UNITGROUPDEPT
	FROM		UNITS U, CAMPUSMAILCODES CMC, GROUPS G, DEPARTMENTS DEPT
	WHERE	U.CAMPUSMAILCODEID = CMC.CAMPUSMAILCODEID AND
			U.GROUPID = G.GROUPID AND
			U.DEPARTMENTID = DEPT.DEPARTMENTID AND
			U.ACTIVEUNIT = 'YES'
	ORDER BY	U.UNITNAME
</CFQUERY>

<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOCATIONID, ROOMNUMBER
	FROM		LOCATIONS
	ORDER BY	ROOMNUMBER
</CFQUERY>

<CFQUERY name="ListSecurityLevels" datasource="#application.type#LIBSECURITY" blockfactor="8">
	SELECT	SECURITYLEVELID, SECURITYLEVELNUMBER, SECURITYLEVELNAME
	FROM		SECURITYLEVELS
	ORDER BY	SECURITYLEVELNAME
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
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

<BR clear="left" />

<!--- 
************************************************************
* The following code is the ADD Process for Customer Info. *
************************************************************
 --->
<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Add Information to Shared Data - Customer</H1></TH>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(CUSTOMERID) AS MAX_ID
			FROM		CUSTOMERS
		</CFQUERY>
		<CFSET FORM.CUSTID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="CustID" secure="NO" value="#FORM.CUSTID#">
		<CFQUERY name="AddCustomerID" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			INSERT INTO	CUSTOMERS (CUSTOMERID)
			VALUES		(#val(Cookie.CUSTID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Customer Key &nbsp; = &nbsp; #FORM.CUSTID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processcustomerinfo.cfm" method="POST">
			<TD align="LEFT">
				<INPUT type="hidden" name="PROCESSCUSTOMER" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CUSTOMER" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processcustomerinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="FIRSTNAME">*First Name</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="LASTNAME">*Last Name</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="FIRSTNAME" id="FIRSTNAME" value="" align="LEFT" required="No" size="15" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="LASTNAME" id="LASTNAME" value="" align="LEFT" required="No" size="20" tabindex="3"></TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="INITIALS">SR Initials</LABEL></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap><CFINPUT type="Text" name="INITIALS" id="INITIALS" value="" align="LEFT" size="4" maxlength="4" tabindex="4"></TD>
			<TD align="left" nowrap>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="CATEGORYID">*Customer Category</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="UNITID">*Unit/Group Name</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="ListCustomerCategories" value="CATEGORYID" display="CATEGORYNAME" selected="0" required="No" tabindex="5"></CFSELECT></TD>
			<TD align="left" nowrap><CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITGROUPDEPT" selected="0" required="No" tabindex="6"></CFSELECT></TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="EMAILADDRESS">*E-Mail Address</LABEL></H4></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="EMAILADDRESS" id="EMAILADDRESS" value="@mail.sdsu.edu" align="LEFT" required="No" size="25" tabindex="7"></TD>
			<TD align="left" nowrap>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="REDID">RedID</LABEL></TH>
			<TH align="left"><H4><LABEL for="LOCATIONID">*Room Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="REDID" id="REDID" value="0" align="LEFT" required="NO" size="9" maxlength="9" tabindex="8"></TD>
			<TD align="left"><CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="9"></CFSELECT></TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="CAMPUSPHONE">*Campus Phone Number</LABEL></H4></TH>
			<TH align="left"><LABEL for="SECONDCAMPUSPHONE">2nd Campus Phone Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="CAMPUSPHONE" id="CAMPUSPHONE" value="" align="LEFT" required="No" size="12" tabindex="10"></TD>
			<TD align="left"><CFINPUT type="Text" name="SECONDCAMPUSPHONE" id="SECONDCAMPUSPHONE" value="" align="LEFT" size="25" tabindex="11"></TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="FAXNUMBER">Fax Number</LABEL></TH>
			<TH align="left"><LABEL for="CELLPHONE">Cell Phone Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="FAXNUMBER" id="FAXNUMBER" value="" align="LEFT" required="No" size="12" tabindex="12"></TD>
			<TD align="left"><CFINPUT type="Text" name="CELLPHONE" id="CELLPHONE" value="" align="LEFT" required="No" size="25" tabindex="13"></TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="PHONEBOOKLISTING">PhoneBook Listing</LABEL></TH>
			<TH align="left"><LABEL for="BIBLIOGRAPHER">Bibliographer?</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="PHONEBOOKLISTING" id="PHONEBOOKLISTING" size="1" tabindex="14">
					<OPTION value="UNLISTED">UNLISTED</OPTION>
					<OPTION value="LISTED">LISTED</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="BIBLIOGRAPHER" id="BIBLIOGRAPHER" size="1" tabindex="15">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="DIALINGCAPABILITY">Dialing Capability</LABEL></TH>
			<TH align="left"><LABEL for="LONGDISTAUTHCODE">Long Distance Authorization Code?</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="DIALINGCAPABILITY" id="DIALINGCAPABILITY" size="1" tabindex="16">
					<OPTION value="3-CAMPUS, LOCAL AND SD COUNTY">3-CAMPUS, LOCAL AND SD COUNTY</OPTION>
					<OPTION value="2-CAMPUS AND LOCAL">2-CAMPUS AND LOCAL</OPTION>
					<OPTION value="1-CAMPUS">1-CAMPUS</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="LONGDISTAUTHCODE" id="LONGDISTAUTHCODE" size="1" tabindex="17">
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
          <TR>
               <TH align="left"><LABEL for="VOICEMAIL">Voice Mail</LABEL></TH>
               <TH align="left"><LABEL for="ANALOGLINE">Analog Line</LABEL></TH>
          </TR>
          <TR>
               <TD align="left">
				<CFSELECT name="VOICEMAIL" id="VOICEMAIL" size="1" tabindex="18">
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
               <TD align="left">
				<CFSELECT name="ANALOGLINE" id="ANALOGLINE" size="1" tabindex="19">
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
          </TR>
		<TR>
			<TH align="left"><LABEL for="CONTACTBY">Contact By</LABEL></TH>
			<TH align="left"><LABEL for="ALLOWEDTOAPPROVE">Allowed To Approve?</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="CONTACTBY" id="CONTACTBY" size="1" tabindex="20">
					<OPTION selected value="E-MAIL">E-MAIL</OPTION>
					<OPTION value="PHONE">PHONE</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="ALLOWEDTOAPPROVE" id="ALLOWEDTOAPPROVE" size="1" tabindex="21">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="UNITHEAD">Unit Head?</LABEL></TH>
			<TH align="left"><LABEL for="DEPTCHAIR">Department Chair?</LABEL></TH>
		</TR>
		<TR>
			<TD>
				<CFSELECT name="UNITHEAD" id="UNITHEAD" size="1" tabindex="22">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD>
				<CFSELECT name="DEPTCHAIR" id="DEPTCHAIR" size="1" tabindex="23">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
	<CFIF #Client.SecurityFlag# EQ "Yes">
		<TR>
			<TH align="left"><LABEL for="SECURITYLEVELID">Security Level</LABEL></TH>
			<TH align="left"><LABEL for="PASSWORD">Password</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="SECURITYLEVELID" id="SECURITYLEVELID" size="1" query="ListSecurityLevels" value="SECURITYLEVELID" display="SECURITYLEVELNAME" selected="0" required="No" tabindex="24"></CFSELECT>
			</TD>
			<TD align="left"><CFINPUT type="Password" name="PASSWORD" id="PASSWORD" value="##Lib123$" align="LEFT" required="No" size="8" maxlength="8" tabindex="25"></TD>
		</TR>
	</CFIF>
		<TR>
			<TH align="left"><LABEL for="ACTIVE">Active Customer</LABEL></TH>
			<TH align="left"><LABEL for="ACCOUNTS">Accounts</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="26">
					<OPTION selected value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left"><CFINPUT type="Text" name="ACCOUNTS" id="ACCOUNTS" value="LIB" align="LEFT" required="No" size="20" tabindex="27"></TD>
		</TR>
          <TR>
               <TH align="left"><LABEL for="DATACENTERACCESS">Data Center Access</LABEL></TH>
               <TH align="left">&nbsp;&nbsp;</TH>
          </TR>
          <TR>
               <TD align="left">
                    <CFSELECT name="DATACENTERACCESS" id="DATACENTERACCESS" size="1" tabindex="28">
                         <OPTION value="NONE">NONE</OPTION>
                         <OPTION value="CONTROLLING">CONTROLLING</OPTION>
                         <OPTION value="ESCORTED">ESCORTED</OPTION>
                         <OPTION value="UNESCORTED">UNESCORTED</OPTION>
                    </CFSELECT>
               </TD>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
			<TH align="left"><LABEL for="COMMENTS">Comments</LABEL></TH>
			<TH align="left"><LABEL for="AA_COMMENTS">AA Comments</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="29">#ListCustomers.COMMENTS#</CFTEXTAREA>
			</TD>
			<TD align="left">
				<CFTEXTAREA name="AA_COMMENTS" id="AA_COMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="30">#ListCustomers.AA_COMMENTS#</CFTEXTAREA>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
			<TH align="left">Date Created</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="31"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#<BR /><BR />
			</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSCUSTOMER" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="32" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processcustomerinfo.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="hidden" name="PROCESSCUSTOMER" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="33" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
***************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Customer Info. *
***************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Modify/Delete Information to Shared Data - Customer</H1></TH>
		</TR>
	</TABLE>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPCUST')>
		<TR>
			<TH align="center">Customer Key &nbsp; = &nbsp; #FORM.CUSTID#</TH>
			<CFCOOKIE name="CustID" secure="NO" value="#FORM.CUSTID#">
		</TR>
		</CFIF>
	</TABLE>
	<BR clear="left" />
	

	<CFIF NOT IsDefined('URL.LOOKUPCUST')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/customerinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPCUST=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="CUSTID">*Customer Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="CUSTID" id="CUSTID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
****************************************************************************
* The following code is the Modify and Delete Processes for Customer Info. *
****************************************************************************
 --->

		<CFQUERY name="GetCustomer" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FIRSTNAME, CUST.INITIALS, CUST.CATEGORYID, CUST.EMAIL, CUST.CAMPUSPHONE,
					CUST.SECONDCAMPUSPHONE, CUST.CELLPHONE, CUST.FAX, CUST.FULLNAME, CUST.DIALINGCAPABILITY, CUST.LONGDISTAUTHCODE,
					CUST.UNITID, U.UNITID, U.DEPARTMENTID, DEPT.DEPARTMENTNAME, CUST.LOCATIONID, CUST.UNITHEAD, CUST.DEPTCHAIR,
					CUST.ALLOWEDTOAPPROVE, CUST.CONTACTBY, CUST.DIALINGCAPABILITY, CUST.VOICEMAIL, CUST.PHONEBOOKLISTING, CUST.ANALOGLINE,
					CUST.SECURITYLEVELID, CUST.PASSWORD, CUST.BIBLIOGRAPHER, CUST.COMMENTS, CUST.AA_COMMENTS, CUST.MODIFIEDBYID, 
					CUST.MODIFIEDDATE, CUST.ACTIVE, CUST.REDID, CUST.ACCOUNTS, CUST.DATACENTERACCESS
			FROM		CUSTOMERS CUST, UNITS U, DEPARTMENTS DEPT
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CUST.UNITID = U.UNITID AND 
					U.DEPARTMENTID = DEPT.DEPARTMENTID
			ORDER BY	CUST.LASTNAME
		</CFQUERY>
		
		<CFQUERY name="GetUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="60">
			SELECT	U.UNITID, U.UNITNAME, CMC.CAMPUSMAILCODE, G.GROUPNAME, DEPT.DEPARTMENTNAME, U.ACTIVEUNIT,
					DEPT.DEPARTMENTNAME, U.UNITNAME || ' - ' || G.GROUPNAME AS UNITGROUP
			FROM		UNITS U, CAMPUSMAILCODES CMC, GROUPS G, DEPARTMENTS DEPT
			WHERE	U.CAMPUSMAILCODEID = CMC.CAMPUSMAILCODEID AND
					U.GROUPID = G.GROUPID AND
					U.DEPARTMENTID = DEPT.DEPARTMENTID AND
					U.ACTIVEUNIT = 'YES'
			ORDER BY	U.UNITNAME
		</CFQUERY>

		<TABLE align="left" width="100%">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/customerinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="CUSTOMER" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processcustomerinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left"><H4><LABEL for="FIRSTNAME">*First Name</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="LASTNAME">*Last Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="FIRSTNAME" id="FIRSTNAME" value="#GetCustomer.FIRSTNAME#" align="LEFT" required="No" size="15" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="LASTNAME" id="LASTNAME" value="#GetCustomer.LASTNAME#" align="LEFT" required="No" size="20" tabindex="3"></TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="INITIALS">SR Initials</LABEL></TH>
				<TH align="left">Full Name</TH>
			</TR>
				<TR>
				<TD align="left" nowrap><CFINPUT type="Text" name="INITIALS" id="INITIALS" value="#GetCustomer.INITIALS#" align="LEFT" size="4" maxlength="4" tabindex="4"></TD>
				<TD align="left" >#GetCustomer.FULLNAME#</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="CATEGORYID">*Customer Category</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="UNITID">*Unit/Group Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD><CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="ListCustomerCategories" value="CATEGORYID" display="CATEGORYNAME" selected="#GetCustomer.CATEGORYID#" required="No" tabindex="5"></CFSELECT></TD>
				<TD align="left" nowrap><CFSELECT name="UNITID" id="UNITID" size="1" query="GetUnits" value="UNITID" display="UNITGROUP" selected="#GetCustomer.UNITID#" required="No" tabindex="6"></CFSELECT></TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="EMAILADDRESS">*E-Mail Address</LABEL></H4></TH>
				<TH align="left">Department Name</TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="EMAILADDRESS" id="EMAILADDRESS" value="#GetCustomer.EMAIL#" align="LEFT" required="No" size="25" tabindex="7"></TD>
				<TD align="left">#GetCustomer.DEPARTMENTNAME#</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="REDID">RedID</LABEL></TH>
				<TH align="left"><LABEL for="LOCATIONID">Room Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="REDID" id="REDID" value="#GetCustomer.REDID#" align="LEFT" required="NO" size="9" maxlength="9" tabindex="8"></TD>
				<TD align="left"><CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetCustomer.LOCATIONID#" required="No" tabindex="9"></CFSELECT></TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="CAMPUSPHONE">*Campus Phone Number</LABEL></H4></TH>
				<TH align="left"><LABEL for="SECONDCAMPUSPHONE">2nd Campus Phone Number</LABEL></TH>
				
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="CAMPUSPHONE" id="CAMPUSPHONE" value="#GetCustomer.CAMPUSPHONE#" align="LEFT" required="No" size="12" tabindex="10"></TD>
				<TD align="left"><CFINPUT type="Text" name="SECONDCAMPUSPHONE" id="SECONDCAMPUSPHONE" value="#GetCustomer.SECONDCAMPUSPHONE#" align="LEFT" size="25" tabindex="11"></TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="FAXNUMBER">Fax Number</LABEL></TH>
				<TH align="left"><LABEL for="CELLPHONE">Cell Phone Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="FAXNUMBER" id="FAXNUMBER" value="#GetCustomer.FAX#" align="LEFT" required="No" size="12" tabindex="12"></TD>
				<TD align="left"><CFINPUT type="Text" name="CELLPHONE" id="CELLPHONE" value="#GetCustomer.CELLPHONE#" align="LEFT" required="No" size="25" tabindex="13"></TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="PHONEBOOKLISTING">PhoneBook Listing</LABEL></TH>
				<TH align="left"><LABEL for="BIBLIOGRAPHER">Bibliographer?</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="PHONEBOOKLISTING" id="PHONEBOOKLISTING" size="1" tabindex="14">
						<OPTION selected value="#GetCustomer.PHONEBOOKLISTING#">#GetCustomer.PHONEBOOKLISTING#</OPTION>
						<OPTION value="UNLISTED">UNLISTED</OPTION>
						<OPTION value="LISTED">LISTED</OPTION>

					</CFSELECT>
				</TD>
				<TD align="left" nowrap>
					<CFSELECT name="BIBLIOGRAPHER" id="BIBLIOGRAPHER" size="1" tabindex="15">
						<OPTION selected value="#GetCustomer.BIBLIOGRAPHER#">#GetCustomer.BIBLIOGRAPHER#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="DIALINGCAPABILITY">Dialing Capability</LABEL></TH>
				<TH align="left"><LABEL for="LONGDISTAUTHCODE">Long Distance Authorization Code?</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="DIALINGCAPABILITY" id="DIALINGCAPABILITY" size="1" tabindex="16">
						<OPTION selected value="#GetCustomer.DIALINGCAPABILITY#">#GetCustomer.DIALINGCAPABILITY#</OPTION>
                              <OPTION value="3-CAMPUS, LOCAL AND SD COUNTY">3-CAMPUS, LOCAL AND SD COUNTY</OPTION>
                              <OPTION value="2-CAMPUS AND LOCAL">2-CAMPUS AND LOCAL</OPTION>
                              <OPTION value="1-CAMPUS">1-CAMPUS</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="LONGDISTAUTHCODE" id="LONGDISTAUTHCODE" size="1" tabindex="17">
						<OPTION selected value="#GetCustomer.LONGDISTAUTHCODE#">#GetCustomer.LONGDISTAUTHCODE#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
               <TR>
                    <TH align="left"><LABEL for="VOICEMAIL">Voice Mail</LABEL></TH>
                    <TH align="left"><LABEL for="ANALOGLINE">Analog Line</LABEL></TH>
               </TR>
               <TR>
                    <TD align="left">
                         <CFSELECT name="VOICEMAIL" id="VOICEMAIL" size="1" tabindex="18">
                              <OPTION selected value="#GetCustomer.VOICEMAIL#">#GetCustomer.VOICEMAIL#</OPTION>
                              <OPTION value="NO">NO</OPTION>
                              <OPTION value="YES">YES</OPTION>
                         </CFSELECT>
                    </TD>
                    <TD align="left">
                         <CFSELECT name="ANALOGLINE" id="ANALOGLINE" size="1" tabindex="19">
                              <OPTION selected value="#GetCustomer.ANALOGLINE#">#GetCustomer.ANALOGLINE#</OPTION>
                              <OPTION value="NO">NO</OPTION>
                              <OPTION value="YES">YES</OPTION>
                         </CFSELECT>
                    </TD>
               </TR>
			<TR>
				<TH align="left"><LABEL for="CONTACTBY">Contact By</LABEL></TH>
				<TH align="left"><LABEL for="ALLOWEDTOAPPROVE">Allowed To Approve?</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="CONTACTBY" id="CONTACTBY" size="1" tabindex="20">
						<OPTION selected value="#GetCustomer.CONTACTBY#">#GetCustomer.CONTACTBY#</OPTION>
						<OPTION value="E-MAIL">E-MAIL</OPTION>
						<OPTION value="PHONE">PHONE</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left" nowrap>
					<CFSELECT name="ALLOWEDTOAPPROVE" id="ALLOWEDTOAPPROVE" size="1" tabindex="21">
						<OPTION selected value="#GetCustomer.ALLOWEDTOAPPROVE#">#GetCustomer.ALLOWEDTOAPPROVE#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="UNITHEAD">Unit Head?</LABEL></TH>
				<TH align="left"><LABEL for="DEPTCHAIR">Department Chair?</LABEL></TH>
			</TR>
			<TR>
				<TD>
					<CFSELECT name="UNITHEAD" id="UNITHEAD" size="1" tabindex="22">
						<OPTION selected value="#GetCustomer.UNITHEAD#">#GetCustomer.UNITHEAD#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
				<TD>
					<CFSELECT name="DEPTCHAIR" id="DEPTCHAIR" size="1" tabindex="23">
						<OPTION selected value="#GetCustomer.DEPTCHAIR#">#GetCustomer.DEPTCHAIR#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
		<CFIF #Client.SecurityFlag# EQ "Yes">
			<TR>
				<TH align="left"><LABEL for="SECURITYLEVELID">Security Level</LABEL></TH>
				<TH align="left"><LABEL for="PASSWORD">Password</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="SECURITYLEVELID" id="SECURITYLEVELID" size="1" query="ListSecurityLevels" value="SECURITYLEVELID" display="SECURITYLEVELNAME" selected="#GetCustomer.SECURITYLEVELID#" required="No" tabindex="24"></CFSELECT>
				</TD>
				<TD align="left"><CFINPUT type="Password" name="PASSWORD" id="PASSWORD" value="" align="LEFT" required="No" size="8" maxlength="8" tabindex="25"></TD>
				
			</TR>
		</CFIF>
			<TR>
				<TH align="left"><LABEL for="ACTIVE">Active Customer</LABEL></TH>
				<TH align="left"><LABEL for="ACCOUNTS">Accounts</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" nowrap>
					<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="26">
						<OPTION selected value="#GetCustomer.ACTIVE#">#GetCustomer.ACTIVE#</OPTION>
						<OPTION value="YES">YES</OPTION>
						<OPTION value="NO">NO</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left"><CFINPUT type="Text" name="ACCOUNTS" id="ACCOUNTS" value="#GetCustomer.ACCOUNTS#" align="LEFT" required="No" size="20" tabindex="27"></TD>
			</TR>
               <TR>
				<TH align="left"><LABEL for="DATACENTERACCESS">Data Center Access</LABEL></TH>
				<TH align="left">&nbsp;&nbsp;</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="DATACENTERACCESS" id="DATACENTERACCESS" size="1" tabindex="28">
						<OPTION selected value="#GetCustomer.DATACENTERACCESS#">#GetCustomer.DATACENTERACCESS#</OPTION>
                              <OPTION value="NONE">NONE</OPTION>
						<OPTION value="CONTROLLING">CONTROLLING</OPTION>
						<OPTION value="ESCORTED">ESCORTED</OPTION>
						<OPTION value="UNESCORTED">UNESCORTED</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="COMMENTS">Comments</LABEL></TH>
				<TH align="left"><LABEL for="AA_COMMENTS">AA Comments</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFTEXTAREA name="COMMENTS" id="COMMENTS" VWRAP="VIRTUAL" required="No" rows="5" cols="60" tabindex="29">#GetCustomer.COMMENTS#</CFTEXTAREA>
				</TD>
				<TD align="left">
					<CFTEXTAREA name="AA_COMMENTS"id="AA_COMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="30">#GetCustomer.AA_COMMENTS#</CFTEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
				<TH align="left">Date Modified</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="31"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#<BR /><BR />
				</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSCUSTOMER" value="MODIFY" /><BR />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="32" />
				</TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="33" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/customerinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="34" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>