<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: pdcontacttime.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2012 --->
<!--- Date in Production: 08/03/2012 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Public Desk Contact Times --->
<!-- Last modified by John R. Pastori on 08/03/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/pdcontacttime.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Public Desk Contact Times</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Public Desk Contact Times</TITLE>
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
		if (document.CONTACTTIME.CONTACTTIME.value == "") {
			alertuser (document.CONTACTTIME.CONTACTTIME.name +  ",  A Public Desk Contact Time MUST be entered!");
			document.CONTACTTIME.CONTACTTIME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.CONTACTTIMEID.selectedIndex == "0") {
			alertuser ("A Public Desk Contact Time MUST be selected!");
			document.LOOKUP.CONTACTTIMEID.focus();
			return false;
		}
	}


	function setDelete() {
		document.CONTACTTIME.PROCESSPDCONTACTTIME.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCONTACTNAME') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.CONTACTS.CONTACTTIMEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CONTACTTIME.CONTACTTIME.focus()">
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

<CFQUERY name="ListPDContactTime" datasource="#application.type#WEBREPORTS" blockfactor="5">
	SELECT	CONTACTTIMEID, CONTACTTIME
	FROM		PDCONTACTTIME
	ORDER BY	CONTACTTIME
</CFQUERY>

<BR clear="left" />

<!--- 
************************************************************************
* The following code is the ADD Process for Public Desk Contact Times. *
************************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Public Desk Contact Times</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
			SELECT	MAX(CONTACTTIMEID) AS MAX_ID
			FROM		PDCONTACTTIME
		</CFQUERY>
		<CFSET FORM.CONTACTTIMEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="CONTACTTIMEID" secure="NO" value="#FORM.CONTACTTIMEID#">
		<CFQUERY name="AddPDContactTimeID" datasource="#application.type#WEBREPORTS">
			INSERT INTO	PDCONTACTTIME (CONTACTTIMEID)
			VALUES		(#val(Cookie.CONTACTTIMEID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Public Desk Contact Times Key &nbsp; = &nbsp; #FORM.CONTACTTIMEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processpdcontacttime.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPDCONTACTTIME" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CONTACTTIME" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processpdcontacttime.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="CONTACTTIME">*Public Desk Contact Times:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="CONTACTTIME" id="CONTACTTIME" value="" align="LEFT" required="No" size="25" maxlength="25" tabindex="2"></TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSPDCONTACTTIME" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processpdcontacttime.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPDCONTACTTIME" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="4" /><BR />
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
***************************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Public Desk Contact Times. *
***************************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPPDCONTACTTIME')>
			<TD align="center"><H1>Lookup for Modify/Delete Information to Web Reports - Public Desk Contact Times</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to Web Reports - Public Desk Contact Times</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPPDCONTACTTIME')>
		<TR>
			<TH align="center">Public Desk Contact Times Key &nbsp; = &nbsp; #FORM.CONTACTTIMEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPPDCONTACTTIME')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/pdcontacttime.cfm?PROCESS=#URL.PROCESS#&LOOKUPPDCONTACTTIME=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="CONTACTTIMEID">*Public Desk Contact Times</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="CONTACTTIMEID" id="CONTACTTIMEID" size="1" query="ListPDContactTime" value="CONTACTTIMEID" display="CONTACTTIME" required="No" tabindex="2"></CFSELECT>
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
***************************************************************************************
* The following code is the Modify and Delete Processes for Public Desk Contact Times.*
***************************************************************************************
 --->

		<CFQUERY name="GetPDContactTime" datasource="#application.type#WEBREPORTS">
			SELECT	CONTACTTIMEID, CONTACTTIME
			FROM		PDCONTACTTIME
			WHERE	CONTACTTIMEID = <CFQUERYPARAM value="#FORM.CONTACTTIMEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CONTACTTIME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/pdcontacttime.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="CONTACTTIME" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processpdcontacttime.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="CONTACTTIMEID" secure="NO" value="#FORM.CONTACTTIMEID#">
				<TH align="left"><H4><LABEL for="CONTACTTIME">*Public Desk Contact Times:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="CONTACTTIME" id="CONTACTTIME" value="#GetPDContactTime.CONTACTTIME#" align="LEFT" required="No" size="25" maxlength="25" tabindex="2"></TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPDCONTACTTIME" value="MODIFY" /><BR />
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
<CFFORM action="/#application.type#apps/webreports/pdcontacttime.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
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