<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: vendorcontactsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Purchasing Vendor Contacts--->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/vendorcontactsinfo.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Purchasing - Vendor Contacts</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Purchasing - Vendor Contacts</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Purchasing";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.VENDORCONTACT.VENDORID.selectedIndex == "0") {
			alertuser (document.VENDORCONTACT.VENDORID.name +  ",  A Vendor Name MUST be selected!");
			document.VENDORCONTACT.VENDORID.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.VENDORCONTACTID.selectedIndex == "0") {
			alertuser ("A Vendor/Contact Name MUST be selected!");
			document.LOOKUP.VENDORCONTACTID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.VENDORCONTACT.PROCESSVENDORCONTACTS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPVENDORCONTACTID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.VENDORCONTACTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.VENDORCONTACT.VENDORID.focus()">
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

<CFQUERY name="ListVendorContacts" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	VC.VENDORCONTACTID, V.VENDORNAME, VC.CONTACTNAME, VC.PHONENUMBER, VC.FAXNUMBER, VC.EMAILADDRESS,
			VC.MODIFIEDBYID, VC.MODIFIEDDATE, VC.COMMENTS, V.VENDORNAME || ' - ' || VC.CONTACTNAME AS KEYFINDER
	FROM		VENDORCONTACTS VC, VENDORS V
	WHERE	VC.VENDORID = V.VENDORID
		<CFIF IsDefined("Cookie.VendorID") AND URL.PROCESS EQ "MODIFYDELETE">
			AND (V.VENDORID = #Cookie.VendorID# OR V.VENDORID = 0)
		</CFIF>
	ORDER BY	V.VENDORNAME, VC.CONTACTNAME
</CFQUERY>

<CFQUERY name="ListVendors" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	VENDORID, VENDORNAME
	FROM		VENDORS
	ORDER BY	VENDORNAME
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
**************************************************************
* The following code is the ADD Process for Vendor Contacts. *
**************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Purchasing - Vendor Contacts</H1></TD>
		</TR>
	</TABLE>
	<BR clear = "left" />
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#PURCHASING">
		SELECT	MAX(VENDORCONTACTID) AS MAX_ID
		FROM		VENDORCONTACTS 
	</CFQUERY>
	<CFSET FORM.VENDORCONTACTID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="VendorContactID" secure="NO" value="#FORM.VENDORCONTACTID#">
	<CFQUERY name="AddVendorContactsID" datasource="#application.type#PURCHASING">
		INSERT INTO	VENDORCONTACTS (VENDORCONTACTID)
		VALUES		(#val(Cookie.VENDORCONTACTID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Vendor Contacts Key &nbsp; = &nbsp; #FORM.VENDORCONTACTID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processvendorcontactsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
               	<INPUT type="hidden" name="PROCESSVENDORCONTACTS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="VENDORCONTACT" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processvendorcontactsinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="VENDORID">*Vendor</LABEL></H4></TH>
			<TH align="left"><LABEL for="CONTACTNAME">Contact</LABEL></TH>
		</TR>
		<TR>
			<CFIF IsDefined("Cookie.VendorID") >
				<TD align="left">
					<CFSELECT name="VENDORID" id="VENDORID" size="1" query="ListVendors" value="VENDORID" display="VENDORNAME" selected="#Cookie.VendorID#" required="No" tabindex="2"></CFSELECT>
				</TD>
			<CFELSE>
				<TD align="left">
					<CFSELECT name="VENDORID" id="VENDORID" size="1" query="ListVendors" value="VENDORID" display="VENDORNAME" selected="0" required="No" tabindex="2"></CFSELECT>
				</TD>
			</CFIF>
			<TD align="left">
				<CFINPUT type="Text" name="CONTACTNAME" id="CONTACTNAME" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3">
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="PHONENUMBER">Phone Number</LABEL></TH>
			<TH align="left"><LABEL for="FAXNUMBER">Fax Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="PHONENUMBER" id="PHONENUMBER" value="" align="LEFT" required="No" size="25" tabindex="4">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="FAXNUMBER" id="FAXNUMBER" value="" align="LEFT" required="No" size="16" tabindex="5">
			</TD>
		</TR>
		<TR>
          	<TH align="left" valign="BOTTOM"><LABEL for="COMMENTS">Comments</LABEL></TH>
			<TH align="left" valign="BOTTOM"><LABEL for="EMAILADDRESS">E-Mail Address</LABEL></TH>
		</TR>
		<TR>
          	<TD align="left" valign="TOP">
                    <CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" rows="6" cols="100" tabindex="6"></CFTEXTAREA>
               </TD>
			<TD align="left" valign="top">
				<CFINPUT type="Text" name="EMAILADDRESS" id="EMAILADDRESS" value="" align="LEFT" required="No" size="50" tabindex="7">
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
			<TH align="left">Date Created</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="8"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSVENDORCONTACTS" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="9" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processvendorcontactsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSVENDORCONTACTS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="10" /><BR />
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
*****************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Vendor Contacts. *
*****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPVENDORCONTACTID')>
			<TD align="center"><H1>Modify/Delete Lookup Information to IDT Purchasing - Vendor Contacts</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to IDT Purchasing - Vendor Contacts</H1></TD>
		</CFIF>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPVENDORCONTACTID')>
		<TR>
			<TH align="center">Vendor Contacts Key &nbsp; = &nbsp; #FORM.VENDORCONTACTID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />
	<CFIF NOT IsDefined('URL.LOOKUPVENDORCONTACTID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPVENDORCONTACTID=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="VENDORCONTACTID">*Vendor Contacts:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="VENDORCONTACTID" id="VENDORCONTACTID" size="1" query="ListVendorContacts" value="VENDORCONTACTID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">
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
				<TD align="LEFT" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
******************************************************************************
* The following code is the Modify and Delete Processes for Vendor Contacts. *
******************************************************************************
 --->

		<CFQUERY name="GetVendorContacts" datasource="#application.type#PURCHASING">
			SELECT	VC.VENDORCONTACTID, VC.VENDORID, V.VENDORNAME, VC.CONTACTNAME, VC.PHONENUMBER, 
               		VC.FAXNUMBER, VC.EMAILADDRESS, VC.MODIFIEDBYID, VC.MODIFIEDDATE, VC.COMMENTS
			FROM		VENDORCONTACTS VC, VENDORS V
			WHERE	VC.VENDORCONTACTID = <CFQUERYPARAM value="#FORM.VENDORCONTACTID#" cfsqltype="CF_SQL_NUMERIC"> AND 
					VC.VENDORID = V.VENDORID
			ORDER BY	V.VENDORNAME, VC.CONTACTNAME
		</CFQUERY>

		<TABLE align="left" width="100%">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="VENDORCONTACT" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processvendorcontactsinfo.cfm" method="POST" ENABLECAB="Yes">
				<CFCOOKIE name="VendorContactID" secure="NO" value="#FORM.VENDORCONTACTID#">
			
			<TR>
				<TH align="left"><H4><LABEL for="VENDORID">*Vendor</LABEL></H4></TH>
				<TH align="left"><LABEL for="CONTACTNAME">Contact</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="VENDORID" id="VENDORID" size="1" query="ListVendors" value="VENDORID" display="VENDORNAME" selected="#GetVendorContacts.VENDORID#" required="No" tabindex="2"></CFSELECT>
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="CONTACTNAME" id="CONTACTNAME" value="#GetVendorContacts.CONTACTNAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="3">
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="PHONENUMBER">Phone Number</LABEL></TH>
				<TH align="left"><LABEL for="FAXNUMBER">Fax Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="PHONENUMBER" id="PHONENUMBER" value="#GetVendorContacts.PHONENUMBER#" align="LEFT" required="No" size="25" tabindex="4">
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="FAXNUMBER" id="FAXNUMBER" value="#GetVendorContacts.FAXNUMBER#" align="LEFT" required="No" size="16" tabindex="5">
				</TD>
			</TR>
                    <TR>
                    <TH align="left" valign="BOTTOM"><LABEL for="COMMENTS">Comments</LABEL></TH>
                    <TH align="left" valign="BOTTOM"><LABEL for="EMAILADDRESS">E-Mail Address</LABEL></TH>
               </TR>
               <TR>
                    <TD align="left" valign="TOP">
                         <CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" rows="6" cols="100" tabindex="6">#GetVendorContacts.COMMENTS#</CFTEXTAREA>
                    </TD>
                    <TD align="left" valign="top">
                         <CFINPUT type="Text" name="EMAILADDRESS" id="EMAILADDRESS" value="#GetVendorContacts.EMAILADDRESS#" align="LEFT" required="No" size="50" tabindex="7">
                    </TD>
               </TR>
			<TR>
				<TH align="left"><H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4></TH>
				<TH align="left">Date Modified</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="8"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
				</TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSVENDORCONTACTS" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="9" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="10" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="11" /><BR />
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