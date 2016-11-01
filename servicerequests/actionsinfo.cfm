<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: actionsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Service Requests Actions --->
<!-- Last modified by John R. Pastori on 07/09/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/actionsinfo.cfm">
<CFSET CONTENT_UPDATED = "July 09, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Service Requests - Actions</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Service Requests - Actions</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Service Requests";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {
		if (document.ACTIONS.ACTIONNAME.value == "" || document.ACTIONS.ACTIONNAME.value == " ") {
			alertuser (document.ACTIONS.ACTIONNAME.name +  ",  An Action Name MUST be entered!");
			document.ACTIONS.ACTIONNAME.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.ACTIONID.selectedIndex == "0") {
			alertuser ("An Action Name MUST be selected!");
			document.LOOKUP.ACTIONID.focus();
			return false;
		}
	}


	function setDelete() {
		document.ACTIONS.PROCESSACTIONS.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPACTION') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.ACTIONID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.ACTIONS.ACTIONNAME.focus()">
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

<CFQUERY name="ListActions" datasource="#application.type#SERVICEREQUESTS" blockfactor="18">
	SELECT	ACTIONID, ACTIONNAME
	FROM		ACTIONS
	ORDER BY	ACTIONNAME
</CFQUERY>

<!--- 
******************************************************
* The following code is the ADD Process for Actions. *
******************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Service Requests - Actions</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(ACTIONID) AS MAX_ID
		FROM		ACTIONS
	</CFQUERY>
	<CFSET FORM.ACTIONID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="ACTIONID" secure="NO" value="#FORM.ACTIONID#">
	<CFQUERY name="AddActionsID" datasource="#application.type#SERVICEREQUESTS">
		INSERT INTO	ACTIONS (ACTIONID)
		VALUES		(#val(Cookie.ACTIONID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Actions Key &nbsp; = &nbsp; #FORM.ACTIONID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processactionsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
               	<INPUT type="hidden" name="PROCESSACTIONS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="ACTIONS" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processactionsinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" nowrap><H4><LABEL for="ACTIONNAME">*Actions:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="ACTIONNAME" id="ACTIONNAME" value="" align="LEFT" required="No" size="25" maxlength="20" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSACTIONS" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processactionsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSACTIONS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="4" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Actions. *
*********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to IDT Service Requests - Actions</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPACTION')>
		<TR>
			<TH align="center">Actions Key &nbsp; = &nbsp; #FORM.ACTIONID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPACTION')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/actionsinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPACTION=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="ACTIONID">*Actions:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="ACTIONID" id="ACTIONID" size="1" query="ListActions" value="ACTIONID" display="ACTIONNAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
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
**********************************************************************
* The following code is the Modify and Delete Processes for Actions. *
**********************************************************************
 --->

		<CFQUERY name="GetActions" datasource="#application.type#SERVICEREQUESTS">
			SELECT	ACTIONID, ACTIONNAME
			FROM		ACTIONS
			WHERE 	ACTIONID = <CFQUERYPARAM value="#FORM.ACTIONID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ACTIONNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/actionsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR><TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
<CFFORM name="ACTIONS" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processactionsinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="ACTIONID" secure="NO" value="#FORM.ACTIONID#">
				<TH align="left" nowrap><H4><LABEL for="ACTIONNAME">*Actions:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="ACTIONNAME" id="ACTIONNAME" value="#GetActions.ACTIONNAME#" align="LEFT" required="No" size="25" maxlength="20" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSACTIONS" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/servicerequests/actionsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR><TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>