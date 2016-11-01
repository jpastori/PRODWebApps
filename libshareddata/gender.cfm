<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: gender.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Shared Data - Gender --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/gender.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Gender</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Gender</TITLE>
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

		if (document.GENDER.GENDERNAME.value == "" || document.GENDER.GENDERNAME.value == " ") {
			alertuser (document.GENDER.GENDERNAME.name +  ",  A Gender Name MUST be entered!");
			document.GENDER.GENDERNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.GENDERID.selectedIndex == "0") {
			alertuser ("A Gender Name MUST be selected!");
			document.LOOKUP.GENDERID.focus();
			return false;
		}
	}


	function setDelete() {
		document.GENDER.PROCESSGENDER.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPGENDERID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.GENDERID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.GENDER.LIBQUALGENDERID.focus()">
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

<CFQUERY name="ListGender" datasource="#application.type#LIBSHAREDDATA" blockfactor="3">
	SELECT	GENDERID, LIBQUALGENDERID, GENDERNAME, LIBQUALGENDERID || ' - ' || GENDERNAME AS GENDERCODENAME
	FROM		GENDER
	ORDER BY	GENDERNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*****************************************************
* The following code is the ADD Process for Gender. *
*****************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Shared Data - Gender</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(GENDERID) AS MAX_ID
			FROM		GENDER
		</CFQUERY>
		<CFSET FORM.GENDERID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="GENDERID" secure="NO" value="#FORM.GENDERID#">
		<CFQUERY name="AddGenderID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	GENDER (GENDERID)
			VALUES		(#val(Cookie.GENDERID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Gender Key &nbsp; = &nbsp; #FORM.GENDERID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processgender.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSGENDER" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="GENDER" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processgender.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><LABEL for="LIBQUALGENDERID">LIBQUAL Gender ID</LABEL></TH>
			<TH align="left" valign ="bottom"><H4><LABEL for="GENDERNAME">*Gender Name</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="LIBQUALGENDERID" id="LIBQUALGENDERID" value="" align="LEFT" required="No" size="6" maxlength="6" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="GENDERNAME" id="GENDERNAME" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSGENDER" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processgender.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSGENDER" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="5" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Gender. *
********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Shared Data - Gender</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPGENDERID')>
		<TR>
			<TH align="center">Gender Key &nbsp; = &nbsp; #FORM.GENDERID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPGENDERID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/gender.cfm?PROCESS=#URL.PROCESS#&LOOKUPGENDERID=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="GENDERID">*Gender Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="GENDERID" id="GENDERID" size="1" query="ListGender" value="GENDERID" display="GENDERNAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
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
*********************************************************************
* The following code is the Modify and Delete Processes for Gender. *
*********************************************************************
 --->

		<CFQUERY name="GetGender" datasource="#application.type#LIBSHAREDDATA">
			SELECT	GENDERID, LIBQUALGENDERID, GENDERNAME
			FROM		GENDER
			WHERE	GENDERID = <CFQUERYPARAM value="#FORM.GENDERID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	GENDERNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/gender.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="GENDER" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processgender.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="GENDERID" secure="NO" value="#FORM.GENDERID#">
				<TH align="left"><LABEL for="LIBQUALGENDERID">LIBQUAL Gender ID</LABEL></TH>
				<TH align="left" valign ="bottom"><H4><LABEL for="GENDERNAME">*Gender Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="LIBQUALGENDERID" id="LIBQUALGENDERID" value="#GetGender.LIBQUALGENDERID#" align="LEFT" required="No" size="2" maxlength="2" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="GENDERNAME" id="GENDERNAME" value="#GetGender.GENDERNAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSGENDER" value="MODIFY" /><BR />
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
<CFFORM action="/#application.type#apps/libshareddata/gender.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
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