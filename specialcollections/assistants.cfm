<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: assistants.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/23/2009 --->
<!--- Date in Production: 01/23/2009 --->
<!--- Module: Add/Modify/Delete Information to Special Collections - Assistants --->
<!-- Last modified by John R. Pastori on 01/23/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/assistants.cfm">
<CFSET CONTENT_UPDATED = "January 23, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Special Collections - Assistants</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Special Collections - Assistants</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the Library Shared Data Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.ASSISTANTS.ASSISTANTNAME.value == "" || document.ASSISTANTS.ASSISTANTNAME.value == " ") {
			alertuser (document.ASSISTANTS.ASSISTANTNAME.name +  ",  An Assistant Name MUST be entered!");
			document.ASSISTANTS.ASSISTANTNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.ASSISTANTID.selectedIndex == "0") {
			alertuser ("An Assistant Name MUST be selected!");
			document.LOOKUP.ASSISTANTID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPASSISTANTS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.ASSISTANTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.ASSISTANTS.ASSISTANTNAME.focus()">
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

<CFQUERY name="ListAssistants" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="50">
	SELECT	ASSISTANTID, ASSISTANTNAME
	FROM		ASSISTANTS
	ORDER BY	ASSISTANTNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*********************************************************
* The following code is the ADD Process for Assistants. *
*********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Special Collections - Assistants</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	MAX(ASSISTANTID) AS MAX_ID
			FROM		ASSISTANTS
		</CFQUERY>
		<CFSET FORM.ASSISTANTID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="ASSISTANTID" secure="NO" value="#FORM.ASSISTANTID#">
		<CFQUERY name="AddAssistantID" datasource="#application.type#SPECIALCOLLECTIONS">
			INSERT INTO	ASSISTANTS (ASSISTANTID)
			VALUES		(#val(Cookie.ASSISTANTID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Assistant Key &nbsp; = &nbsp; #FORM.ASSISTANTID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processassistants.cfm" method="POST">
			<TD align="left">
				<INPUT type="submit" name="ProcessAssistants" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="ASSISTANTS" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processassistants.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">
				<H4><LABEL for="ASSISTANTNAME">*Assistant Name:</LABEL></H4>
			</TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="ASSISTANTNAME" id="ASSISTANTNAME" value="" align="LEFT" required="No" size="100" tabindex="2">
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="ACTIVE">Active?</LABEL></TH>
		</TR>
		<TR>
			<TD>
				<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="3">
					<OPTION value="NO">NO</OPTION>
					<OPTION selected value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="APPROVAL">Approval?</LABEL></TH>
		</TR>
		<TR>
			<TD>
				<CFSELECT name="APPROVAL" id="APPROVAL" size="1" tabindex="4">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessAssistants" value="ADD" tabindex="5" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processassistants.cfm" method="POST">
			<TD align="left">
				<INPUT type="submit" name="ProcessAssistants" value="CANCELADD" tabindex="6" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Assistants. *
************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Special Collections - Assistants </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPASSISTANTS')>
		<TR>
			<TH align="center">Assistant Key &nbsp; = &nbsp; #FORM.ASSISTANTID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPAssistants')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/specialcollections/assistants.cfm?PROCESS=#URL.PROCESS#&LOOKUPASSISTANTS=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="ASSISTANTID">*Assistant Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="ASSISTANTID" id="ASSISTANTID" size="1" query="ListAssistants" value="ASSISTANTID" display="ASSISTANTNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
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
************************************************************************
* The following code is the Modify and Delete Processes for Assistants.*
************************************************************************
 --->

		<CFQUERY name="GetAssistants" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	ASSISTANTID, ASSISTANTNAME, ACTIVE, APPROVAL
			FROM		ASSISTANTS
			WHERE	ASSISTANTID = <CFQUERYPARAM value="#FORM.ASSISTANTID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ASSISTANTNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/assistants.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left">
					<INPUT type="submit" name="ProcessAssistants" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="ASSISTANTS" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processassistants.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="ASSISTANTID" secure="NO" value="#FORM.ASSISTANTID#">
				<TH align="left">
					<H4><LABEL for="ASSISTANTNAME">*Assistant Name:</LABEL></H4>
				</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="ASSISTANTNAME" id="ASSISTANTNAME" value="#GetAssistants.ASSISTANTNAME#" align="LEFT" required="No" size="50" tabindex="2">
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="ACTIVE">Active?</LABEL></TH>
			</TR>
			<TR>
				<TD>
					<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="3">
						<OPTION selected value="#GetAssistants.ACTIVE#">#GetAssistants.ACTIVE#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="APPROVAL">Approval?</LABEL></TH>
			</TR>
			<TR>
				<TD>
					<CFSELECT name="APPROVAL" id="APPROVAL" size="1" tabindex="4">
						<OPTION selected value="#GetAssistants.APPROVAL#">#GetAssistants.APPROVAL#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessAssistants" value="MODIFY" tabindex="3" /></TD>
			</TR>
			<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessAssistants" value="DELETE" tabindex="4" /></TD>
			</TR>
			</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/assistants.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left">
					<INPUT type="submit" name="ProcessAssistants" value="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>