<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: requesttypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/25/2012 --->
<!--- Date in Production: 07/25/2012 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Request Types --->
<!-- Last modified by John R. Pastori on 07/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI ="/#application.type#apps/webreports/requesttypes.cfm">
<CFSET CONTENT_UPDATED = "July 25 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Request Types</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Request Types</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Web Reports";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.REQUESTTYPES.REQUESTTYPENAME.value == "") {
			alertuser (document.REQUESTTYPES.REQUESTTYPENAME.name +  ",  A Request Type Name MUST be entered!");
			document.REQUESTTYPES.REQUESTTYPENAME.focus();
			return false;
		}

		if (document.REQUESTTYPES.REQUESTTYPEFIELDNAME.value == "") {
			alertuser (document.REQUESTTYPES.REQUESTTYPEFIELDNAME.name +  ",  A Request Type Field Name MUST be entered!");
			document.REQUESTTYPES.REQUESTTYPEFIELDNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.REQUESTTYPEID.selectedIndex == "0") {
			alertuser ("A Request Type Name MUST be selected!");
			document.LOOKUP.REQUESTTYPEID.focus();
			return false;
		}
	}


	function setDelete() {
		document.REQUESTTYPES.PROCESSREQUESTTYPES.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPREQUESTTYPE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.REQUESTTYPEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.REQUESTTYPES.REQUESTTYPENAME.focus()">
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

<CFQUERY name="ListRequestTypes" datasource="#application.type#WEBREPORTS" blockfactor="15">
	SELECT	REQUESTTYPEID, REQUESTTYPENAME, REQUESTTYPEFIELDNAME
	FROM		REQUESTTYPES
	ORDER BY	REQUESTTYPENAME
</CFQUERY>

<BR clear="left" />

<!--- 
************************************************************
* The following code is the ADD Process for Request Types. *
************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Request Types</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
		SELECT	MAX(REQUESTTYPEID) AS MAX_ID
		FROM		REQUESTTYPES
	</CFQUERY>
	<CFSET FORM.REQUESTTYPEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="REQUESTTYPEID" secure="NO" value="#FORM.REQUESTTYPEID#">
	<CFQUERY name="AddRequestTypesID" datasource="#application.type#WEBREPORTS">
		INSERT INTO	REQUESTTYPES (REQUESTTYPEID)
		VALUES		(#val(Cookie.REQUESTTYPEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Request Type Key &nbsp; = &nbsp; #FORM.REQUESTTYPEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processrequesttypes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSREQUESTTYPES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
          <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
<CFFORM name="REQUESTTYPES" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processrequesttypes.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="REQUESTTYPENAME">*Request Type Name</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="REQUESTTYPEFIELDNAME">*Request Type Field Name</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="REQUESTTYPENAME" id="REQUESTTYPENAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="REQUESTTYPEFIELDNAME" id="REQUESTTYPEFIELDNAME" value="" align="LEFT" required="No" size="50" tabindex="3"></TD>
		</TR>
          <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSREQUESTTYPES" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
			</TD>
		</TR>
</CFFORM>
		<TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processrequesttypes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSREQUESTTYPES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="5" /><BR />
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
***************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Request Types. *
***************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Web Reports - Request Types</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPREQUESTTYPE')>
		<TR>
			<TH align="center">Request Type Key &nbsp; = &nbsp; #FORM.REQUESTTYPEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPREQUESTTYPE')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
               <TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/requesttypes.cfm?PROCESS=#URL.PROCESS#&LOOKUPREQUESTTYPE=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="REQUESTTYPEID">*Request Type Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="REQUESTTYPEID" id="REQUESTTYPEID" size="1" query="ListRequestTypes" value="REQUESTTYPEID" display="REQUESTTYPENAME" required="No" tabindex="2"></CFSELECT>
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
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
***************************************************************************
* The following code is the Modify and Delete Processes for Request Types.*
***************************************************************************
 --->

		<CFQUERY name="GetRequestTypes" datasource="#application.type#WEBREPORTS">
			SELECT	REQUESTTYPEID, REQUESTTYPENAME, REQUESTTYPEFIELDNAME
			FROM		REQUESTTYPES
			WHERE	REQUESTTYPEID = <CFQUERYPARAM value="#FORM.REQUESTTYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	REQUESTTYPEID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/requesttypes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
               <TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
<CFFORM name="REQUESTTYPES" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processrequesttypes.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="REQUESTTYPEID" secure="NO" value="#FORM.REQUESTTYPEID#">
				<TH align="left"><H4><LABEL for="REQUESTTYPENAME">*Request Type Name</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="REQUESTTYPEFIELDNAME">*Request Type Field Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="REQUESTTYPENAME" id="REQUESTTYPENAME" value="#GetRequestTypes.REQUESTTYPENAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="REQUESTTYPEFIELDNAME" id="REQUESTTYPEFIELDNAME" value="#GetRequestTypes.REQUESTTYPEFIELDNAME#" align="LEFT" required="No" size="50" tabindex="3"></TD>
			</TR>
               <TR>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSREQUESTTYPES" value="MODIFY" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="4" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/webreports/requesttypes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>