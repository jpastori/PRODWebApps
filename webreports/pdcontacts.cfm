<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: pdcontacts.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2012 --->
<!--- Date in Production: 08/03/2012 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Public Desk Contacts --->
<!-- Last modified by John R. Pastori on 08/03/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/pdcontacts.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Public Desk Contacts</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Public Desk Contacts</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Web Reports";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.CONTACTS.CONTACTNAME.value == "" || document.CONTACTS.CONTACTNAME.value == " ") {
			alertuser (document.CONTACTS.CONTACTNAME.name +  ",  A Contact Name MUST be entered!");
			document.CONTACTS.CONTACTNAME.focus();
			return false;
		}

		if (document.CONTACTS.DEPARTMENT.value == "" || document.CONTACTS.DEPARTMENT.value == "") {
			alertuser (document.CONTACTS.DEPARTMENT.name +  ",  A Department Name MUST be entered!");
			document.CONTACTS.DEPARTMENT.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.CONTACTID.selectedIndex == "0") {
			alertuser ("A Contact Name MUST be selected!");
			document.LOOKUP.CONTACTID.focus();
			return false;
		}
	}


	function setDelete() {
		document.CONTACTS.PROCESSPDCONTACTS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCONTACTNAME') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.CONTACTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CONTACTS.CONTACTNAME.focus()">
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

<CFQUERY name="ListPDContacts" datasource="#application.type#WEBREPORTS" blockfactor="31">
	SELECT	CONTACTID, CONTACTNAME, DEPARTMENT, PHONE, EMAIL
	FROM		PDCONTACTS
	ORDER BY	CONTACTNAME
</CFQUERY>

<BR clear="left" />

<!--- 
******************************************************************
* The following code is the ADD Process for Public Desk Contacts.*
******************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Public Desk Contacts</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
			SELECT	MAX(CONTACTID) AS MAX_ID
			FROM		PDCONTACTS
		</CFQUERY>
		<CFSET FORM.CONTACTID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="CONTACTID" secure="NO" value="#FORM.CONTACTID#">
		<CFQUERY name="AddPDContactsID" datasource="#application.type#WEBREPORTS">
			INSERT INTO	PDCONTACTS (CONTACTID)
			VALUES		(#val(Cookie.CONTACTID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Contacts Key &nbsp; = &nbsp; #FORM.CONTACTID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processpdcontacts.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPDCONTACTS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CONTACTS" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processpdcontacts.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="CONTACTNAME">*Contact Name</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="DEPARTMENT">*Department</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="CONTACTNAME" id="CONTACTNAME" value="" align="LEFT" required="No" size="65" maxlength="300" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="DEPARTMENT" id="DEPARTMENT" value="" align="LEFT" required="No" size="25" maxlength="30" tabindex="3"></TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="PHONE">Phone</LABEL></TH>
			<TH align="left"><LABEL for="EMAIL">E-Mail</LABEL></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="PHONE" id="PHONE" value="" align="LEFT" required="No" size="30" maxlength="50" tabindex="4"></TD>
			<TD align="left"><CFINPUT type="Text" name="EMAIL" id="EMAIL" value="" align="LEFT" required="No" size="50" maxlength="300" tabindex="5"></TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSPDCONTACTS" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="6" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processpdcontacts.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPDCONTACTS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="7" /><BR />
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
*********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Public Desk Contacts.*
*********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPCONTACTNAME')>
			<TD align="center"><H1>Lookup for Modify/Delete Information to Web Reports - Public Desk Contacts</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to Web Reports - Public Desk Contacts</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPCONTACTNAME')>
		<TR>
			<TH align="center">Contacts Key &nbsp; = &nbsp; #FORM.CONTACTID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCONTACTNAME')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/pdcontacts.cfm?PROCESS=#URL.PROCESS#&LOOKUPCONTACTNAME=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="CONTACTID">*Contact Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="CONTACTID" id="CONTACTID" size="1" query="ListPDContacts" value="CONTACTID" display="CONTACTNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
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
**********************************************************************************
* The following code is the Modify and Delete Processes for Public Desk Contacts.*
**********************************************************************************
 --->

		<CFQUERY name="GetPDContacts" datasource="#application.type#WEBREPORTS">
			SELECT	CONTACTID, CONTACTNAME, DEPARTMENT, PHONE, EMAIL
			FROM		PDCONTACTS
			WHERE	CONTACTID = <CFQUERYPARAM value="#FORM.CONTACTID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CONTACTNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/pdcontacts.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="CONTACTS" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processpdcontacts.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="CONTACTID" secure="NO" value="#FORM.CONTACTID#">
				<TH align="left"><H4><LABEL for="CONTACTNAME">*Contact Name</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="DEPARTMENT">*Department</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="CONTACTNAME" id="CONTACTNAME" value="#GetPDContacts.CONTACTNAME#" align="LEFT" required="No" size="65" maxlength="300" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="DEPARTMENT" id="DEPARTMENT" value="#GetPDContacts.DEPARTMENT#" align="LEFT" required="No" size="25" maxlength="30" tabindex="3"></TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="PHONE">Phone</LABEL></TH>
				<TH align="left"><LABEL for="EMAIL">E-Mail</LABEL></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="PHONE" id="PHONE" value="#GetPDContacts.PHONE#" align="LEFT" required="No" size="30" maxlength="50" tabindex="4"></TD>
				<TD align="left"><CFINPUT type="Text" name="EMAIL" id="EMAIL" value="#GetPDContacts.EMAIL#" align="LEFT" required="No" size="50" maxlength="300" tabindex="5"></TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPDCONTACTS" value="MODIFY" /><BR />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="6" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="7" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/webreports/pdcontacts.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="8" /><BR />
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