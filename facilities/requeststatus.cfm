<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: requeststatus.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/31/2008 --->
<!--- Date in Production: 01/31/2008 --->
<!--- Module: Add/Modify/Delete Information to Facilities - Request Status --->
<!-- Last modified by John R. Pastori on 01/31/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/requeststatus.cfm">
<CFSET CONTENT_UPDATED = "January 31, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Facilities - Request Status</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Facilities - Request Status</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Facilities";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.REQUESTSTATUS.REQUESTSTATUSNAME.value == "") {
			alertuser (document.REQUESTSTATUS.REQUESTSTATUSNAME.name +  ",  A Request Status Name MUST be entered!");
			document.REQUESTSTATUS.REQUESTSTATUSNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.REQUESTSTATUSID.selectedIndex == "0") {
			alertuser ("A Request Status Name MUST be selected!");
			document.LOOKUP.REQUESTSTATUSID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPREQUESTSTATUS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.REQUESTSTATUSID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.REQUESTSTATUS.REQUESTSTATUSNAME.focus()">
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


<CFQUERY name="ListRequestStatus" datasource="#application.type#FACILITIES" blockfactor="8">
	SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
	FROM		REQUESTSTATUS
	ORDER BY	REQUESTSTATUSNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*************************************************************
* The following code is the ADD Process for Request Status. *
*************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Facilities - Request Status</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
			SELECT	MAX(REQUESTSTATUSID) AS MAX_ID
			FROM		REQUESTSTATUS
		</CFQUERY>
		<CFSET FORM.REQUESTSTATUSID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="REQUESTSTATUSID" secure="NO" value="#FORM.REQUESTSTATUSID#">
		<CFQUERY name="AddRequestStatusID" datasource="#application.type#FACILITIES">
			INSERT INTO	REQUESTSTATUS (REQUESTSTATUSID)
			VALUES		(#val(Cookie.REQUESTSTATUSID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Request Status Key &nbsp; = &nbsp; #FORM.REQUESTSTATUSID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/processrequeststatus.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessRequestStatus" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="REQUESTSTATUS" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processrequeststatus.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4>*Request Status Name:</H4></TH>
			<TD align="left"><CFINPUT type="Text" name="REQUESTSTATUSNAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessRequestStatus" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/facilities/processrequeststatus.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessRequestStatus" value="CANCELADD" tabindex="4" /><BR />
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
****************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Request Status. *
****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Facilities - Request Status</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPREQUESTSTATUS')>
		<TR>
			<TH align="center">Request Status Key &nbsp; = &nbsp; #FORM.REQUESTSTATUSID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPREQUESTSTATUS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/requeststatus.cfm?PROCESS=#URL.PROCESS#&LOOKUPREQUESTSTATUS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4>*Request Status Name:</H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="REQUESTSTATUSID" size="1" query="ListRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
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
****************************************************************************
* The following code is the Modify and Delete Processes for Request Status.*
****************************************************************************
 --->

		<CFQUERY name="GetRequestStatus" datasource="#application.type#FACILITIES">
			SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
			FROM		REQUESTSTATUS
			WHERE	REQUESTSTATUSID = <CFQUERYPARAM value="#FORM.REQUESTSTATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	REQUESTSTATUSNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/facilities/requeststatus.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessRequestStatus" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="REQUESTSTATUS" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processrequeststatus.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="REQUESTSTATUSID" secure="NO" value="#FORM.REQUESTSTATUSID#">
				<TH align="left"><H4>*Request Status Name:</H4></TH>
				<TD align="left"><CFINPUT type="Text" name="REQUESTSTATUSNAME" value="#GetRequestStatus.REQUESTSTATUSNAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessRequestStatus" value="MODIFY" tabindex="3" /></TD>
			</TR>
			<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessRequestStatus" value="DELETE" tabindex="4" /></TD>
			</TR>
			</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/requeststatus.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessRequestStatus" value="Cancel" tabindex="5" /><BR />
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