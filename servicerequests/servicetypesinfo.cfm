<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: servicetypesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/25/2012 --->
<!--- Date in Production: 05/25/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Service Requests - Service Types --->
<!-- Last modified by John R. Pastori on 05/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/servicetypesinfo.cfm">
<CFSET CONTENT_UPDATED = "May 25, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Service Requests - Service Types</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Service Requests - Service Types</TITLE>
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
		if (document.SERVICETYPE.SERVICETYPENAME.value == "" || document.SERVICETYPE.SERVICETYPENAME.value == " ") {
			alertuser (document.SERVICETYPE.SERVICETYPENAME.name +  ",  A Service Type Name MUST be entered!");
			document.SERVICETYPE.SERVICETYPENAME.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.SERVICETYPEID.selectedIndex == "0") {
			alertuser ("A Service Type Name MUST be selected!");
			document.LOOKUP.SERVICETYPEID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.SERVICETYPE.PROCESSSERVICETYPES.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPSERVICETYPE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SERVICETYPEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SERVICETYPE.SERVICETYPENAME.focus()">
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

<CFQUERY name="ListServiceTypes" datasource="#application.type#SERVICEREQUESTS" blockfactor="9">
	SELECT	SERVICETYPEID, SERVICETYPENAME
	FROM		SERVICETYPES
	ORDER BY	SERVICETYPENAME
</CFQUERY>

<!--- 
************************************************************
* The following code is the ADD Process for Service Types. *
************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Service Requests - Service Types</H1></TD>
		</TR>
	</TABLE>
	
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(SERVICETYPEID) AS MAX_ID
		FROM		SERVICETYPES
	</CFQUERY>
	<CFSET FORM.SERVICETYPEID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="SERVICETYPEID" secure="NO" value="#FORM.SERVICETYPEID#">
	<CFQUERY name="AddServiceTypesID" datasource="#application.type#SERVICEREQUESTS">
		INSERT INTO	SERVICETYPES (SERVICETYPEID)
		VALUES		(#val(Cookie.SERVICETYPEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Service Type Key &nbsp; = &nbsp; #FORM.SERVICETYPEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
			
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processservicetypesinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSERVICETYPES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="SERVICETYPE" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processservicetypesinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" nowrap><H4><LABEL for="SERVICETYPENAME">*Service Types:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="SERVICETYPENAME" id="SERVICETYPENAME" value="" align="LEFT" required="No" size="30" maxlength="25" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSSERVICETYPES" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processservicetypesinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSERVICETYPES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="CENTER" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
***************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Service Types. *
***************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to IDT Service Requests - Service Types</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center"border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPSERVICETYPE')>
		<TR>
				<TH align="center">Service Type Key &nbsp; = &nbsp; #FORM.SERVICETYPEID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPSERVICETYPE')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/servicetypesinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPSERVICETYPE=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="SERVICETYPEID">*Service Types:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="SERVICETYPEID" id="SERVICETYPEID" size="1" query="ListServiceTypes" value="SERVICETYPEID" display="SERVICETYPENAME" required="No" tabindex="2"></CFSELECT>
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
				<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
****************************************************************************
* The following code is the Modify and Delete Processes for Service Types. *
****************************************************************************
 --->

		<CFQUERY name="GetServiceTypes" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SERVICETYPEID, SERVICETYPENAME
			FROM		SERVICETYPES
			WHERE	SERVICETYPEID = <CFQUERYPARAM value="#FORM.SERVICETYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SERVICETYPENAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/servicetypesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="SERVICETYPE" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processservicetypesinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="SERVICETYPEID" secure="NO" value="#FORM.SERVICETYPEID#">
				<TH align="left" nowrap><H4><LABEL for="SERVICETYPENAME">*Service Types:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="SERVICETYPENAME" id="SERVICETYPENAME" value="#GetServiceTypes.SERVICETYPENAME#" align="LEFT" required="No" size="30" maxlength="25" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSSERVICETYPES" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="3" /></TD>
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
<CFFORM action="/#application.type#apps/servicerequests/servicetypesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>