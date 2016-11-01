<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: modelnamesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Add/Modify/Delete Information to Library IDT Hardware Inventory Model Names --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/modelnamesinfo.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Hardware Inventory - Model Names</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Hardware Inventory - Model Names</TITLE>
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
		if (document.MODELNAMES.MODELNAME.value == "" || document.MODELNAMES.MODELNAME.value == " ") {
			alertuser (document.MODELNAMES.MODELNAME.name +  ",  A Model Name MUST be entered!");
			document.MODELNAMES.MODELNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.MODELNAMEID.selectedIndex == "0") {
			alertuser ("A Model Name MUST be selected!");
			document.LOOKUP.MODELNAMEID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.MODELNAMES.PROCESSMODELNAMES.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPMODELNAME') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.MODELNAMEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.MODELNAMES.MODELNAME.focus()">
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

<CFQUERY name="ListModelNames" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	MODELNAMEID, MODELNAME, MODIFIEDBYID, MODIFIEDDATE
	FROM		MODELNAMELIST
	ORDER BY	MODELNAME
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
**********************************************************
* The following code is the ADD Process for Model Names. *
**********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Add Information to IDT Hardware Inventory - Model Names</H1></TH>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(MODELNAMEID) AS MAX_ID
		FROM		MODELNAMELIST
	</CFQUERY>
	<CFSET FORM.MODELNAMEID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="MODELNAMEID" secure="NO" value="#FORM.MODELNAMEID#">
	<CFQUERY name="AddModelNamesID" datasource="#application.type#HARDWARE">
		INSERT INTO	MODELNAMELIST (MODELNAMEID)
		VALUES		(#val(Cookie.MODELNAMEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Model Name Key &nbsp; = &nbsp; #FORM.MODELNAMEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/processmodelnamesinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSMODELNAMES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="MODELNAMES" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processmodelnamesinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" nowrap colspan="2"><H4><LABEL for="MODELNAME">*Model Name</LABEL></H4></TH>
          </TR>
          <TR>
			<TD align="left" colspan="2">
				<CFINPUT type="Text" name="MODELNAME" id="MODELNAME" value="" required="No" size="50" tabindex="2">
			</TD>
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
               	<INPUT type="hidden" name="PROCESSMODELNAMES" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/processmodelnamesinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSMODELNAMES" value="CANCELADD" />
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
*************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Model Names. *
*************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Modify/Delete Information to IDT Hardware Inventory - Model Names</H1></TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPMODELNAME')>
		<TR>
			<TH align="center">Model Name Key &nbsp; = &nbsp; #FORM.MODELNAMEID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPMODELNAME')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/hardwareinventory/modelnamesinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPMODELNAME=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="MODELNAMEID">*Model Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="MODELNAMEID" id="MODELNAMEID" size="1" query="ListModelNames" value="MODELNAMEID" display="MODELNAME" required="No" tabindex="2"></CFSELECT>
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
**************************************************************************
* The following code is the Modify and Delete Processes for Model Names. *
**************************************************************************
 --->

		<CFQUERY name="GetModelNames" datasource="#application.type#HARDWARE">
			SELECT	MODELNAMEID, MODELNAME, MODIFIEDBYID, MODIFIEDDATE
			FROM		MODELNAMELIST
			WHERE	MODELNAMEID = <CFQUERYPARAM value="#FORM.MODELNAMEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	MODELNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/modelnamesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="MODELNAMES" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processmodelnamesinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="MODELNAMEID" secure="NO" value="#FORM.MODELNAMEID#">
				<TH align="left" nowrap colspan="2"><H4><LABEL for="MODELNAME">*Model Name</LABEL></H4></TH>
               </TR>
               <TR>
				<TD align="left" colspan="2"><CFINPUT type="Text" name="MODELNAME" id="MODELNAME" value="#GetModelNames.MODELNAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
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
                    	<INPUT type="hidden" name="PROCESSMODELNAMES" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/hardwareinventory/modelnamesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
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