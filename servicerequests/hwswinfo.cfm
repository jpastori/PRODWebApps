<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hwswinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/15/2012 --->
<!--- Date in Production: 11/15/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Service Requests - Hardware/Software --->
<!-- Last modified by John R. Pastori on 11/15/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/hwswinfo.cfm">
<CFSET CONTENT_UPDATED = "November 15, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Service Requests - Hardware/Software</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Service Requests - Hardware/Software</TITLE>
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
		if (document.HWSW.HWSW_NAME.value == "" || document.HWSW.HWSW_NAME.value == " ") {
			alertuser (document.HWSW.HWSW_NAME.name +  ",  A Hardware/Software Action Name MUST be entered!");
			document.HWSW.HWSW_NAME.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.HWSW_ID.selectedIndex == "0") {
			alertuser ("A Hardware/Software Action Name MUST be selected!");
			document.LOOKUP.HWSW_ID.focus();
			return false;
		}
	}


	function setDelete() {
		document.HWSW.PROCESSHWSW.value = "DELETE";
		return true;
	}



//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPHWSW') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.HWSW_ID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.HWSW.HWSW_NAME.focus()">
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

<CFQUERY name="ListHWSW" datasource="#application.type#SERVICEREQUESTS" blockfactor="12">
	SELECT	HWSW_ID, HWSW_NAME, HWSW_DESCRIPTION
	FROM		HWSW
	ORDER BY	HWSW_NAME
</CFQUERY>

<!--- 
****************************************************************
* The following code is the ADD Process for Hardware/Software. *
****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Service Requests - Hardware/Software</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(HWSW_ID) AS MAX_ID
		FROM		HWSW
	</CFQUERY>
	<CFSET FORM.HWSW_ID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="HWSW_ID" secure="NO" value="#FORM.HWSW_ID#">
	<CFQUERY name="AddHWSW_ID" datasource="#application.type#SERVICEREQUESTS">
		INSERT INTO	HWSW (HWSW_ID)
		VALUES		(#val(Cookie.HWSW_ID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				HWSW Key &nbsp; = &nbsp; #FORM.HWSW_ID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processhwswinfo.cfm" method="POST">
			<TD align="left" colspan="2">
               	<INPUT type="hidden" name="PROCESSHWSW" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="HWSW" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processhwswinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" nowrap><H4><LABEL for="HWSW_NAME">*HWSW NAME</LABEL></H4></TH>
			<TH align="left" nowrap><H4><LABEL for="HWSW_DESCRIPTION">*HWSW DESCRIPTION</LABEL></H4></TH>
		</TR>
          <TR>
			<TD align="left">
               	<CFINPUT type="Text" name="HWSW_NAME" id="HWSW_NAME" value="" align="LEFT" required="No" size="15" maxlength="15" tabindex="2">
               </TD>
			<TD align="left">
               	<CFINPUT type="Text" name="HWSW_DESCRIPTION" id="HWSW_DESCRIPTION" value="" align="LEFT" required="No" size="100" maxlength="200" tabindex="3">
               </TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSHWSW" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processhwswinfo.cfm" method="POST">
			<TD align="left" colspan="2">
               	<INPUT type="hidden" name="PROCESSHWSW" value="CANCELADD" />
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
*******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Hardware/Software. *
*******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to IDT Service Requests - Hardware/Software</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPHWSW')>
		<TR>
			<TH align="center">HWSW Key &nbsp; = &nbsp; #FORM.HWSW_ID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPHWSW')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/hwswinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPHWSW=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="HWSW_ID">*HWSW:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="HWSW_ID" id="HWSW_ID" size="1" query="ListHWSW" value="HWSW_ID" display="HWSW_NAME" required="No" tabindex="2"></CFSELECT>
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
********************************************************************************
* The following code is the Modify and Delete Processes for Hardware/Software. *
********************************************************************************
 --->

		<CFQUERY name="GetHWSW" datasource="#application.type#SERVICEREQUESTS" blockfactor="12">
			SELECT	HWSW_ID, HWSW_NAME, HWSW_DESCRIPTION
			FROM		HWSW
			WHERE 	HWSW_ID = <CFQUERYPARAM value="#FORM.HWSW_ID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	HWSW_NAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/hwswinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="HWSW" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processhwswinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
                    <TH align="left" nowrap><H4><LABEL for="HWSW_NAME">*HWSW NAME</LABEL></H4></TH>
                    <TH align="left" nowrap><H4><LABEL for="HWSW_DESCRIPTION">*HWSW DESCRIPTION</LABEL></H4></TH>
               </TR>
               <TR>
                    <TD align="left">
                         <CFCOOKIE name="HWSW_ID" secure="NO" value="#FORM.HWSW_ID#">
                         <CFINPUT type="Text" name="HWSW_NAME" id="HWSW_NAME" value="#GetHWSW.HWSW_NAME#" align="LEFT" required="No" size="15" maxlength="15" tabindex="2">
                    </TD>
                    <TD align="left">
                         <CFINPUT type="Text" name="HWSW_DESCRIPTION" id="HWSW_DESCRIPTION" value="#GetHWSW.HWSW_DESCRIPTION#" align="LEFT" required="No" size="100" maxlength="200" tabindex="3">
                    </TD>
               </TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSHWSW" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/servicerequests/hwswinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>