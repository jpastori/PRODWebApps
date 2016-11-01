<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: mediatype.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Software Inventory - Media Type --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/mediatype.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Software Inventory - Media Type</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Software Inventory - Media Type</TITLE>
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
		if (document.MEDIATYPE.MEDIATYPENAME.value == "" || document.MEDIATYPE.MEDIATYPENAME.value == " ") {
			alertuser (document.MEDIATYPE.MEDIATYPENAME.name +  ",  An Media Type Name MUST be entered!");
			document.MEDIATYPE.MEDIATYPENAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.MEDIATYPEID.selectedIndex == "0") {
			alertuser ("An Media Type Name MUST be selected!");
			document.LOOKUP.MEDIATYPEID.focus();
			return false;
		}
	}


	function setDelete() {
		document.MEDIATYPE.PROCESSMEDIATYPES.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPMEDIATYPES') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.MEDIATYPEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.MEDIATYPE.MEDIATYPENAME.focus()">
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

<CFQUERY name="ListMediaType" datasource="#application.type#SOFTWARE" blockfactor="13">
	SELECT	MEDIATYPEID, MEDIATYPENAME
	FROM		MEDIATYPES
	ORDER BY	MEDIATYPENAME
</CFQUERY>

<BR clear="left" />

<!--- 
*********************************************************
* The following code is the ADD Process for Media Type. *
*********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Software Inventory - Media Type</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
		SELECT	MAX(MEDIATYPEID) AS MAX_ID
		FROM		MEDIATYPES
	</CFQUERY>
	<CFSET FORM.MEDIATYPEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="MEDIATYPEID" secure="NO" value="#FORM.MEDIATYPEID#">
	<CFQUERY name="AddMediaTypeID" datasource="#application.type#SOFTWARE">
		INSERT INTO	MEDIATYPES (MEDIATYPEID)
		VALUES		(#val(Cookie.MEDIATYPEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Media Type Key &nbsp; = &nbsp; #FORM.MEDIATYPEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
	<CFFORM action="/#application.type#apps/softwareinventory/processmediatype.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSMEDIATYPES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
	</CFFORM>
		</TR>
	<CFFORM name="MEDIATYPE" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processmediatype.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="MEDIATYPENAME">*Media Type Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="MEDIATYPENAME" id="MEDIATYPENAME" value="" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSMEDIATYPES" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
		</TR>
	</CFFORM>
		<TR>
	<CFFORM action="/#application.type#apps/softwareinventory/processmediatype.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSMEDIATYPES" value="CANCELADD" />
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
************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Media Type. *
************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPMEDIATYPES')>
			<TD align="center"><H1>Lookup for Modify/Delete to IDT Software Inventory - Media Type </H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete to IDT Software Inventory - Media Type </H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPMEDIATYPES')>
		<TR>
			<TH align="center">Media Type Key &nbsp; = &nbsp; #FORM.MEDIATYPEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPMEDIATYPES')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/mediatype.cfm?PROCESS=#URL.PROCESS#&LOOKUPMEDIATYPES=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="MEDIATYPEID">*Media Type Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="MEDIATYPEID" id="MEDIATYPEID" size="1" query="ListMediaType" value="MEDIATYPEID" display="MEDIATYPENAME" required="No" tabindex="2"></CFSELECT>
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
************************************************************************
* The following code is the Modify and Delete Processes for Media Type.*
************************************************************************
 --->

		<CFQUERY name="GetMediaType" datasource="#application.type#SOFTWARE">
			SELECT	MEDIATYPEID, MEDIATYPENAME
			FROM		MEDIATYPES
			WHERE	MEDIATYPEID = <CFQUERYPARAM value="#FORM.MEDIATYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	MEDIATYPENAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/mediatype.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="MEDIATYPE" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processmediatype.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="MEDIATYPEID" secure="NO" value="#FORM.MEDIATYPEID#">
				<TH align="left"><H4><LABEL for="MEDIATYPENAME">*Media Type Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="MEDIATYPENAME" id="MEDIATYPENAME" value="#GetMediaType.MEDIATYPENAME#" align="LEFT" required="No" size="100" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSMEDIATYPES" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/softwareinventory/mediatype.cfm?PROCESS=#URL.PROCESS#" method="POST">
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