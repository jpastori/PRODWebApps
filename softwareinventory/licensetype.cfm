<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: licensetype.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012--->
<!--- Module: Add/Modify/Delete Information to IDT Software Inventory - License Type --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/licensetype.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Software Inventory - License Type</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Software Inventory - License Type</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Software Inventory";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.LICENSETYPE.LICENSETYPENAME.value == "" || document.LICENSETYPE.LICENSETYPENAME.value == " ") {
			alertuser (document.LICENSETYPE.LICENSETYPENAME.name +  ",  A License Type Name MUST be entered!");
			document.LICENSETYPE.LICENSETYPENAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.LICENSETYPEID.selectedIndex == "0") {
			alertuser ("An License Type Name MUST be selected!");
			document.LOOKUP.LICENSETYPEID.focus();
			return false;
		}
	}


	function setDelete() {
		document.LICENSETYPE.PROCESSLICENSETYPES.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPLICENSETYPES') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.LICENSETYPEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.LICENSETYPE.LICENSETYPENAME.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined("URL.PROCESS")>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListLicenseType" datasource="#application.type#SOFTWARE" blockfactor="11">
	SELECT	LICENSETYPEID, LICENSETYPENAME
	FROM		LICENSETYPES
	ORDER BY	LICENSETYPENAME
</CFQUERY>

<BR clear="left" />

<!--- 
***********************************************************
* The following code is the ADD Process for License Type. *
***********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Software Inventory - License Type</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
			SELECT	MAX(LICENSETYPEID) AS MAX_ID
			FROM		LICENSETYPES
		</CFQUERY>
		<CFSET FORM.LICENSETYPEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="LICENSETYPEID" secure="NO" value="#FORM.LICENSETYPEID#">
		<CFQUERY name="AddLicenseTypeID" datasource="#application.type#SOFTWARE">
			INSERT INTO	LICENSETYPES (LICENSETYPEID)
			VALUES		(#val(Cookie.LICENSETYPEID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				License Type Key &nbsp; = &nbsp; #FORM.LICENSETYPEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
	<CFFORM action="/#application.type#apps/softwareinventory/processlicensetype.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSLICENSETYPES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
	</CFFORM>
		</TR>
	<CFFORM name="LICENSETYPE" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processlicensetype.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="LICENSETYPENAME">*License Type Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="LICENSETYPENAME" id="LICENSETYPENAME" value="" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessLicenseTypes" value="ADD" tabindex="3" /></TD>
		</TR>
	</CFFORM>
		<TR>
	<CFFORM action="/#application.type#apps/softwareinventory/processlicensetype.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSLICENSETYPES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="4" /><BR />
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
**************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting License Type. *
**************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined("URL.LOOKUPLICENSETYPES")>
			<TD align="center"><H1>Lookup for Modify/Delete to IDT Software Inventory - License Type </H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete to IDT Software Inventory - License Type </H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined("URL.LOOKUPLICENSETYPES")>
		<TR>
			<TH align="center">License Type Key &nbsp; = &nbsp; #FORM.LICENSETYPEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
<BR clear = "left" />

	<CFIF NOT IsDefined("URL.LOOKUPLICENSETYPES")>
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/licensetype.cfm?PROCESS=#URL.PROCESS#&LOOKUPLICENSETYPES=FOUND" method="POST">
		<TR>
			<TH align="left" width="30%"><H4><LABEL for="LICENSETYPEID">*License Type Name:</LABEL></H4></TH>
			<TD align="left" width="70%">
				<CFSELECT name="LICENSETYPEID" id="LICENSETYPEID" size="1" query="ListLicenseType" value="LICENSETYPEID" display="LICENSETYPENAME" required="No" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left">
                    <INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

	<CFELSE>
<!--- 
**************************************************************************
* The following code is the Modify and Delete Processes for License Type.*
**************************************************************************
 --->

		<CFQUERY name="GetLicenseType" datasource="#application.type#SOFTWARE">
			SELECT	LICENSETYPEID, LICENSETYPENAME
			FROM		LICENSETYPES
			WHERE	LICENSETYPEID = <CFQUERYPARAM value="#FORM.LICENSETYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	LICENSETYPENAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/licensetype.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LICENSETYPE" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processlicensetype.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="LICENSETYPEID" secure="NO" value="#FORM.LICENSETYPEID#">
				<TH align="left"><H4><LABEL for="LICENSETYPENAME">*License Type Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="LICENSETYPENAME" id="LICENSETYPENAME" value="#GetLicenseType.LICENSETYPENAME#" align="LEFT" required="No" size="100" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSLICENSETYPES" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="3" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="4" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/licensetype.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
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