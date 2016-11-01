<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: vendorinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Purchasing - Vendors --->
<!-- Last modified by John R. Pastori on 06/19/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/vendorinfo.cfm">
<CFSET CONTENT_UPDATED = "June 19, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Purchasing - Vendors</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Purchasing - Vendors</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Purchasing";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.VENDOR.VENDORNAME.value == "" || document.VENDOR.VENDORNAME.value == " ") {
			alertuser (document.VENDOR.VENDORNAME.name +  ",  You must enter a Vendor Name.");
			document.VENDOR.VENDORNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.VENDORID.selectedIndex == "0") {
			alertuser ("A Vendor MUST be selected!");
			document.LOOKUP.VENDORID.focus();
			return false;
		}
	}
		
	
	function setAddContact() {
		document.VENDOR.PROCESSVENDORS.value = "ADD CONTACT";
		return true;
	}
		
	
	function setModifyContact() {
		document.VENDOR.PROCESSVENDORS.value = "MODIFY CONTACT";
		return true;
	}
		
	
	function setDelete() {
		document.VENDOR.PROCESSVENDORS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPVENDOR') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.VENDORID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.VENDOR.VENDORNAME.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListVendors" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, ADDRESSLINE2, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS,
			MODIFIEDBYID, MODIFIEDDATE
	FROM		VENDORS
	ORDER BY	VENDORNAME
</CFQUERY>

<CFQUERY name="ListStates" datasource="#application.type#LIBSHAREDDATA" blockfactor="60">
	SELECT	STATEID, STATECODE, STATENAME, STATECODE || ' - ' || STATENAME AS STATECODENAME
	FROM		STATES
	ORDER BY	STATECODE
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 400 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<!--- 
*****************************************************************
* The following code is the ADD Process for Vendor Information. *
*****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Purchasing - Vendors</H1></TD>
		</TR>
	</TABLE>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#PURCHASING">
		SELECT	MAX(VENDORID) AS MAX_ID
		FROM		VENDORS 
	</CFQUERY>
	<CFSET FORM.VENDORID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="VendorID" secure="NO" value="#FORM.VENDORID#">
	<CFQUERY name="AddVendorsID" datasource="#application.type#PURCHASING">
		INSERT INTO	VENDORS (VENDORID)
		VALUES		(#val(Cookie.VENDORID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Vendor Key &nbsp; = &nbsp; #FORM.VENDORID#
			</TH>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processvendorinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSVENDORS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="VENDOR" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processvendorinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="VENDORNAME">*Vendor</LABEL></H4></TH>
			<TH align="left"><LABEL for="PRODUCTS">Products</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="VENDORNAME" id="VENDORNAME" value="" align="LEFT" required="No" size="50" tabindex="2">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="PRODUCTS" id="PRODUCTS" value="" align="LEFT" required="No" size="50" tabindex="3">
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="ADDRESSLINE1">Address Line 1</LABEL></TH>
			<TH align="left"><LABEL for="ADDRESSLINE2">Address Line 2</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="ADDRESSLINE1" id="ADDRESSLINE1" value="" align="LEFT" required="No" size="50" maxlength="100" tabindex="4">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="ADDRESSLINE2" id="ADDRESSLINE2" value="" align="LEFT" required="No" size="50" maxlength="100" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="CITY">City</LABEL></TH>
			<TH align="left"><LABEL for="STATEID">State</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="CITY" id="CITY" value="" align="LEFT" required="No" size="50" tabindex="6">
			</TD>
			<TD align="left">
				<CFSELECT name="STATEID" id="STATEID" size="1" query="ListStates" value="STATEID" display="STATECODENAME" required="No" tabindex="7"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="ZIPCODE">Zip Code</LABEL></TH>
			<TH align="left"><LABEL for="COUNTRY">Country</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="ZIPCODE" id="ZIPCODE" value="" align="LEFT" required="No" size="12" tabindex="8">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="COUNTRY" id="COUNTRY" value="USA" align="LEFT" required="No" size="50" maxlength="100" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TH align="left" ><LABEL for="WEBSITE">Web Site</LABEL></TH>
			<TH align="left"><LABEL for="COMMENTS">Vendor Comments</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="WEBSITE" id="WEBSITE" value="" align="LEFT" required="No" size="50" maxlength="100" tabindex="10">
			</TD>
			<TD align="left">
				<CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="11">#ListVendors.COMMENTS#</CFTEXTAREA>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
			<TH align="left">Date Created</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="12"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSVENDORS" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="13" />
			</TD>
               <TD align="left">
                    <INPUT type="image" src="/images/buttonAddContact.jpg" value="ADD CONTACT" alt="Add Contact" onClick="return setAddContact();" tabindex="14" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processvendorinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSVENDORS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="15" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Vendor Information. *
********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPVENDOR')>
			<TD align="center"><H1>Modify/Delete Lookup Information to IDT Purchasing - Vendors</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to IDT Purchasing - Vendors</H1></TD>
		</CFIF>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPVENDOR')>
		<TR>
			<TH align="center"> Vendor Key &nbsp; = &nbsp; #FORM.VENDORID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	
	<CFIF NOT IsDefined('URL.LOOKUPVENDOR')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/purchasing/vendorinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPVENDOR=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%" nowrap><H4><LABEL for="VENDORID">*Vendor:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="VENDORID" id="VENDORID" size="1" query="ListVendors" value="VENDORID" display="VENDORNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
*********************************************************************************
* The following code is the Modify and Delete Processes for Vendor Information. *
*********************************************************************************
 --->

		<CFQUERY name="GetVendors" datasource="#application.type#PURCHASING">
			SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, ADDRESSLINE2, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS,
					MODIFIEDBYID, MODIFIEDDATE
			FROM		VENDORS
			WHERE	VENDORID = <CFQUERYPARAM value="#FORM.VENDORID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	VENDORNAME
		</CFQUERY>

		<TABLE align="left" width="100%">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/vendorinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="VENDOR" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processvendorinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="VendorID" secure="NO" value="#FORM.VENDORID#">
				<TH align="left"><H4><LABEL for="VENDORNAME">*Vendor</LABEL></H4></TH>
				<TH align="left"><LABEL for="PRODUCTS">Products</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="VENDORNAME" id="VENDORNAME" value="#GetVendors.VENDORNAME#" align="LEFT" required="No" size="50" tabindex="2">
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="PRODUCTS" id="PRODUCTS" value="#GetVendors.PRODUCTS#" align="LEFT" required="No" size="50" tabindex="3">
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="ADDRESSLINE1">Address Line 1</LABEL></TH>
				<TH align="left"><LABEL for="ADDRESSLINE2">Address Line 2</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="ADDRESSLINE1" id="ADDRESSLINE1" value="#GetVendors.ADDRESSLINE1#" align="LEFT" required="No" size="50" maxlength="100" tabindex="4">
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="ADDRESSLINE2" id="ADDRESSLINE2" value="#GetVendors.ADDRESSLINE2#" align="LEFT" required="No" size="50" maxlength="100" tabindex="5">
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="CITY">City</LABEL></TH>
				<TH align="left"><LABEL for="STATEID">State</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="CITY" id="CITY" value="#GetVendors.CITY#" align="LEFT" required="No" size="50" tabindex="6">
				</TD>
				<TD align="left">
					<CFSELECT name="STATEID" id="STATEID" size="1" query="ListStates" value="STATEID" display="STATECODENAME" selected="#GetVendors.STATEID#" required="No" tabindex="7"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="ZIPCODE">Zip Code</LABEL></TH>
				<TH align="left"><LABEL for="COUNTRY">Country</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="ZIPCODE" id="ZIPCODE" value="#GetVendors.ZIPCODE#" align="LEFT" required="No" size="12" tabindex="8">
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="COUNTRY" id="COUNTRY" value="#GetVendors.COUNTRY#" align="LEFT" required="No" size="50" tabindex="9">
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="WEBSITE">Web Site</LABEL></TH>
				<TH align="left"><LABEL for="COMMENTS">Vendor Comments</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="WEBSITE" id="WEBSITE" value="#GetVendors.WEBSITE#" align="LEFT" required="No" size="50" tabindex="10">
				</TD>
				<TD align="left">
					<CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="11">#GetVendors.COMMENTS#</CFTEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
				<TH align="left">Date Modified</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="12"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
				</TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSVENDORS" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="13" />
                    </TD>
                    <TD align="left">
                   		<INPUT type="image" src="/images/buttonModifyContact.jpg" value="MODIFY CONTACT" alt="Modify Contact" onClick="return setModifyContact();" tabindex="14" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="15" />
                    </TD>
              </TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/purchasing/vendorinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="16" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>