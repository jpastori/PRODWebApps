<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: modelnumbersinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Hardware Inventory Model Numbers --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/modelnumbersinfo.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Hardware Inventory - Model Numbers</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Hardware Inventory - Model Numbers</TITLE>
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
		if (document.MODELNUMBERS.MODELNUMBER.value == "" || document.MODELNUMBERS.MODELNUMBER.value == " ") {
			alertuser (document.MODELNUMBERS.MODELNUMBER.name +  ",  A Model Number MUST be entered!");
			document.MODELNUMBERS.MODELNUMBER.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.MODELNUMBERID.selectedIndex == "0") {
			alertuser ("A Model Number MUST be selected!");
			document.LOOKUP.MODELNUMBERID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.MODELNUMBERS.PROCESSMODELNUMBERS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPMODELNUMBER') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.MODELNUMBERID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.MODELNUMBERS.MODELNUMBER.focus()">
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

<CFQUERY name="ListModelNumbers" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	MODELNUMBERID, MODELNUMBER, MODIFIEDBYID, MODIFIEDDATE
	FROM		MODELNUMBERLIST
	ORDER BY	MODELNUMBER
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
************************************************************
* The following code is the ADD Process for Model Numbers. *
************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR>
			<TD align="center"><H1>Add Information to IDT Hardware Inventory - Model Numbers</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(MODELNUMBERID) AS MAX_ID
		FROM		MODELNUMBERLIST
	</CFQUERY>
	<CFSET FORM.MODELNUMBERID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="MODELNUMBERID" secure="NO" value="#FORM.MODELNUMBERID#">
	<CFQUERY name="AddModelNumbersID" datasource="#application.type#HARDWARE">
		INSERT INTO	MODELNUMBERLIST (MODELNUMBERID)
		VALUES		(#val(Cookie.MODELNUMBERID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Model Number Key &nbsp; = &nbsp; #FORM.MODELNUMBERID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/processmodelnumbersinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSMODELNUMBERS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="MODELNUMBERS" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processmodelnumbersinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" width="30%" nowrap colspan="2"><H4><LABEL for="MODELNUMBER">*Model Number</LABEL></H4></TH>
          </TR>
          <TR>
			<TD align="left" width="70%" colspan="2"><CFINPUT type="Text" name="MODELNUMBER" id="MODELNUMBER" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
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
               	<INPUT type="hidden" name="PROCESSMODELNUMBERS" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/processmodelnumbersinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSMODELNUMBERS" value="CANCELADD" />
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
***************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Model Numbers. *
***************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR>
			<TD><H1>Modify/Delete Information to IDT Hardware Inventory - Model Numbers</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPMODELNUMBER')>
		<TR>
			<TH align="center">Model Number Key &nbsp; = &nbsp; #FORM.MODELNUMBERID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined("URL.LOOKUPMODELNUMBER")>
		<TABLE width="100%" align="LEFT" border="0">
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/hardwareinventory/modelnumbersinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPMODELNUMBER=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="MODELNUMBERID">*Model Number:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="MODELNUMBERID" id="MODELNUMBERID" size="1" query="ListModelNumbers" value="MODELNUMBERID" display="MODELNUMBER" required="No" tabindex="2"></CFSELECT>
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
****************************************************************************
* The following code is the Modify and Delete Processes for Model Numbers. *
****************************************************************************
 --->

		<CFQUERY name="GetModelNumbers" datasource="#application.type#HARDWARE">
			SELECT	MODELNUMBERID, MODELNUMBER, MODIFIEDBYID, MODIFIEDDATE
			FROM		MODELNUMBERLIST
			WHERE	MODELNUMBERID = <CFQUERYPARAM value="#FORM.MODELNUMBERID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	MODELNUMBER
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/modelnumbersinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="MODELNUMBERS" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processmodelnumbersinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="MODELNUMBERID" secure="NO" value="#FORM.MODELNUMBERID#">
				<TH align="left" nowrap colspan="2"><H4><LABEL for="MODELNUMBER">*Model Number</LABEL></H4></TH>
               </TR>
               <TR>
				<TD align="left" colspan="2"><CFINPUT type="Text" name="MODELNUMBER" id="MODELNUMBER" value="#GetModelNumbers.MODELNUMBER#" align="LEFT" required="No" size="50" tabindex="2"></TD>
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
                    	<INPUT type="hidden" name="PROCESSMODELNUMBERS" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/hardwareinventory/modelnumbersinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
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