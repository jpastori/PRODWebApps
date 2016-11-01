<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: campusmailcodes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Library Shared Data Campus Mail Codes Database--->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/campusmailcodes.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Campus Mail Codes</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Campus Mail Codes</TITLE>
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
		if (document.CAMPUSMAILCODES.CAMPUSMAILCODE.value == "" || document.CAMPUSMAILCODES.CAMPUSMAILCODE.value == " ") {
			alertuser (document.CAMPUSMAILCODES.CAMPUSMAILCODE.name +  ",  A Campus Mail Code MUST be entered!");
			document.CAMPUSMAILCODES.CAMPUSMAILCODE.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.CAMPUSMAILCODEID.selectedIndex == "0") {
			alertuser ("A Campus Mail Code MUST be selected!");
			document.LOOKUP.CAMPUSMAILCODEID.focus();
			return false;
		}
	}


	function setDelete() {
		document.CAMPUSMAILCODES.PROCESSCAMPUSMAILCODES.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCAMPUSMAILCODE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.CAMPUSMAILCODEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CAMPUSMAILCODES.CAMPUSMAILCODE.focus()">
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

<CFQUERY name="ListCampusMailCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
	SELECT	CAMPUSMAILCODEID, CAMPUSMAILCODE
	FROM		CAMPUSMAILCODES
	ORDER BY	CAMPUSMAILCODE
</CFQUERY>

<BR clear="left" />

<!--- 
****************************************************************
* The following code is the ADD Process for Campus Mail Codes. *
****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Shared Data - Campus Mail Codes</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(CAMPUSMAILCODEID) AS MAX_ID
			FROM		CAMPUSMAILCODES
		</CFQUERY>
		<CFSET FORM.CAMPUSMAILCODEID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="CAMPUSMAILCODEID" secure="NO" value="#FORM.CAMPUSMAILCODEID#">
		<CFQUERY name="AddCampusMailCodesID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	CAMPUSMAILCODES (CAMPUSMAILCODEID)
			VALUES		(#val(Cookie.CAMPUSMAILCODEID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Campus Mail Code Key &nbsp; = &nbsp; #FORM.CAMPUSMAILCODEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processcampusmailcodes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSCAMPUSMAILCODES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
		<TR>
<CFFORM name="CAMPUSMAILCODES" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processcampusmailcodes.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="CAMPUSMAILCODE">*Campus Mail Code:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="CAMPUSMAILCODE" id="CAMPUSMAILCODE" value="" align="LEFT" required="No" size="4" maxlength="10" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSCAMPUSMAILCODES" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		</TR><TR>
<CFFORM action="/#application.type#apps/libshareddata/processcampusmailcodes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSCAMPUSMAILCODES" value="CANCELADD" />
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
*******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Campus Mail Codes. *
*******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Shared Data - Campus Mail Codes</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPCAMPUSMAILCODE')>
		<TR>
			<TH align="center">Campus Mail Code Key &nbsp; = &nbsp; #FORM.CAMPUSMAILCODEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCAMPUSMAILCODE')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/campusmailcodes.cfm?PROCESS=#URL.PROCESS#&LOOKUPCAMPUSMAILCODE=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="CAMPUSMAILCODEID">*Campus Mail Code:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="CAMPUSMAILCODEID" id="CAMPUSMAILCODEID" size="1" query="ListCampusMailCodes" value="CAMPUSMAILCODEID" display="CAMPUSMAILCODE" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
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
********************************************************************************
* The following code is the Modify and Delete Processes for Campus Mail Codes. *
********************************************************************************
 --->

		<CFQUERY name="GetCampusMailCodes" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CAMPUSMAILCODEID, CAMPUSMAILCODE
			FROM		CAMPUSMAILCODES
			WHERE	CAMPUSMAILCODEID = <CFQUERYPARAM value="#FORM.CAMPUSMAILCODEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CAMPUSMAILCODE
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/campusmailcodes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="CAMPUSMAILCODES" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processcampusmailcodes.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="CAMPUSMAILCODEID" secure="NO" value="#FORM.CAMPUSMAILCODEID#">
				<TH align="left"><H4><LABEL for="CAMPUSMAILCODE">*Campus Mail Code:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="CAMPUSMAILCODE" id="CAMPUSMAILCODE" value="#GetCampusMailCodes.CAMPUSMAILCODE#" align="LEFT" required="No" size="4" maxlength="10" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSCAMPUSMAILCODES" value="MODIFY" /><BR />
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
<CFFORM action="/#application.type#apps/libshareddata/campusmailcodes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
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