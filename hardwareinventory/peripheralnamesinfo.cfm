<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: peripheralnamesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Hardware Inventory Peripheral Names --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/peripheralnamesinfo.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Hardware Inventory - Peripheral Names</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Hardware Inventory - Peripheral Names</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.PERIPHERALNAME.PERIPHERALNAME.value == "" || document.PERIPHERALNAME.PERIPHERALNAME.value == " ") {
			alertuser (document.PERIPHERALNAME.PERIPHERALNAME.name +  ",  A Peripheral Name MUST be entered!");
			document.PERIPHERALNAME.PERIPHERALNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.PERIPHERALNAMEID.selectedIndex == "0") {
			alertuser ("A Peripheral Name MUST be selected!");
			document.LOOKUP.PERIPHERALNAMEID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.PERIPHERALNAME.PROCESSPERIPHERALNAMES.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPERIPHERALNAME') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.PERIPHERALNAMEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.PERIPHERALNAME.PERIPHERALNAME.focus()">
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

<CFQUERY name="ListPeripheralNames" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	PERIPHERALNAMEID, PERIPHERALNAME, MODIFIEDBYID, MODIFIEDDATE
	FROM		PERIPHERALNAMELIST
	ORDER BY	PERIPHERALNAME
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 300 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<!--- 
***************************************************************
* The following code is the ADD Process for Peripheral Names. *
***************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Hardware Inventory - Peripheral Names</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(PERIPHERALNAMEID) AS MAX_ID
		FROM		PERIPHERALNAMELIST
	</CFQUERY>
	<CFSET FORM.PERIPHERALNAMEID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="PERIPHERALNAMEID" secure="NO" value="#FORM.PERIPHERALNAMEID#">
	<CFQUERY name="AddPeripheralNamesID" datasource="#application.type#HARDWARE">
		INSERT INTO	PERIPHERALNAMELIST (PERIPHERALNAMEID)
		VALUES		(#val(Cookie.PERIPHERALNAMEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Peripheral Name Key &nbsp; = &nbsp; #FORM.PERIPHERALNAMEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/processperipheralnamesinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPERIPHERALNAMES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="PERIPHERALNAME" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processperipheralnamesinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TD align="left" nowrap colspan="2"><H4><LABEL for="PERIPHERALNAME">*Peripheral Name</LABEL></H4></TD>
          </TR>
          <TR>
			<TD align="left" colspan="2"><CFINPUT type="Text" name="PERIPHERALNAME" id="PERIPHERALNAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
          <TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
			<TH align="left">Date Created</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="3"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
               <TD align="left">
                    <INPUT type="hidden" name="PROCESSPERIPHERALNAMES" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/processperipheralnamesinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPERIPHERALNAMES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="5" /><BR />
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
******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Peripheral Names. *
******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to IDT Hardware Inventory - Peripheral Names</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPPERIPHERALNAME')>
		<TR>
				<TH align="center">Peripheral Name Key &nbsp; = &nbsp; #FORM.PERIPHERALNAMEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPPERIPHERALNAME')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/hardwareinventory/peripheralnamesinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPPERIPHERALNAME=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="PERIPHERALNAMEID">*Peripheral Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="PERIPHERALNAMEID" id="PERIPHERALNAMEID" size="1" query="ListPeripheralNames" value="PERIPHERALNAMEID" display="PERIPHERALNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
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
*******************************************************************************
* The following code is the Modify and Delete Processes for Peripheral Names. *
*******************************************************************************
 --->

		<CFQUERY name="GetPeripheralNames" datasource="#application.type#HARDWARE">
			SELECT	PERIPHERALNAMEID, PERIPHERALNAME, MODIFIEDBYID, MODIFIEDDATE
			FROM		PERIPHERALNAMELIST
			WHERE	PERIPHERALNAMEID = <CFQUERYPARAM value="#FORM.PERIPHERALNAMEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PERIPHERALNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/peripheralnamesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="PERIPHERALNAME" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processperipheralnamesinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="PERIPHERALNAMEID" secure="NO" value="#FORM.PERIPHERALNAMEID#">
				<TH align="left" nowrap colspan="2"><H4><LABEL for="PERIPHERALNAME">*Peripheral Name</LABEL></H4></TH>
               </TR>
			<TR>
				<TD align="left" colspan="2"><CFINPUT type="Text" name="PERIPHERALNAME" id="PERIPHERALNAME" value="#GetPeripheralNames.PERIPHERALNAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
			</TR>
               <TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
				<TH align="left">Date Modified</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="3"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
				</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPERIPHERALNAMES" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="4" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="5" />
                    </TD>
			</TR>
			</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/peripheralnamesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>