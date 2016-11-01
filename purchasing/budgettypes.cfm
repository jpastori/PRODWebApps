<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: budgettypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Purchasing - Budget Types --->
<!-- Last modified by John R. Pastori on 07/09/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/budgettypes.cfm">
<CFSET CONTENT_UPDATED = "July 09, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Purchasing - Budget Types</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Purchasing - Budget Types</TITLE>
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
		if (document.BUDGETTYPES.BUDGETTYPENAME.value == "" || document.BUDGETTYPES.BUDGETTYPENAME.value == " ") {
			alertuser (document.BUDGETTYPES.BUDGETTYPENAME.name +  ",  A Budget Type Name MUST be entered!");
			document.BUDGETTYPES.BUDGETTYPENAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.BUDGETTYPEID.selectedIndex == "0") {
			alertuser ("A Budget Type Name MUST be selected!");
			document.LOOKUP.BUDGETTYPEID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.BUDGETTYPES.PROCESSBUDGETTYPES.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPBUDGETTYPES') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.BUDGETTYPEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.BUDGETTYPES.BUDGETTYPENAME.focus()">
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

<CFQUERY name="ListBudgetTypes" datasource="#application.type#PURCHASING" blockfactor="15">
	SELECT	BUDGETTYPEID, BUDGETTYPENAME
	FROM		BUDGETTYPES
	ORDER BY	BUDGETTYPENAME
</CFQUERY>

<BR clear="left" />

<!--- 
***********************************************************
* The following code is the ADD Process for Budget Types. *
***********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Purchasing - Budget Types</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#PURCHASING">
		SELECT	MAX(BUDGETTYPEID) AS MAX_ID
		FROM		BUDGETTYPES
	</CFQUERY>
	<CFSET FORM.BUDGETTYPEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="BUDGETTYPEID" secure="NO" value="#FORM.BUDGETTYPEID#">
	<CFQUERY name="AddBudgetTypeID" datasource="#application.type#PURCHASING">
		INSERT INTO	BUDGETTYPES (BUDGETTYPEID)
		VALUES		(#val(Cookie.BUDGETTYPEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Budget Types Key &nbsp; = &nbsp; #FORM.BUDGETTYPEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processbudgettypes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSBUDGETTYPES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="BUDGETTYPES" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processbudgettypes.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="BUDGETTYPENAME">*Budget Type Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="BUDGETTYPENAME" id="BUDGETTYPENAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSBUDGETTYPES" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processbudgettypes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSBUDGETTYPES" value="CANCELADD" />
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
* The following code is the Look Up Process for Modifying and Deleting Budget Types. *
**************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPBUDGETTYPES')>
			<TD align="center"><H1>Modify/Delete Lookup Information to IDT Purchasing - Budget Types</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to IDT Purchasing - Budget Types</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPBUDGETTYPES')>
		<TR>
			<TH align="center"> Budget Types Key &nbsp; = &nbsp; #FORM.BUDGETTYPEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPBUDGETTYPES')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br>
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/purchasing/budgettypes.cfm?PROCESS=#URL.PROCESS#&LOOKUPBUDGETTYPES=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="BUDGETTYPEID">*Budget Type Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="BUDGETTYPEID" id="BUDGETTYPEID" size="1" query="ListBudgetTypes" value="BUDGETTYPEID" display="BUDGETTYPENAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
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
**************************************************************************
* The following code is the Modify and Delete Processes for Budget Types.*
**************************************************************************
 --->

		<CFQUERY name="GetBudgetTypes" datasource="#application.type#PURCHASING">
			SELECT	BUDGETTYPEID, BUDGETTYPENAME
			FROM		BUDGETTYPES
			WHERE	BUDGETTYPEID = <CFQUERYPARAM value="#FORM.BUDGETTYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	BUDGETTYPENAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/budgettypes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="BUDGETTYPES" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processbudgettypes.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="BUDGETTYPEID" secure="NO" value="#FORM.BUDGETTYPEID#">
				<TH align="left"><H4><LABEL for="BUDGETTYPENAME">*Budget Type Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="BUDGETTYPENAME" id="BUDGETTYPENAME" value="#GetBudgetTypes.BUDGETTYPENAME#" align="LEFT" required="No" size="50" tabindex="23"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSBUDGETTYPES" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/purchasing/budgettypes.cfm?PROCESS=#URL.PROCESS#" method="POST">
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