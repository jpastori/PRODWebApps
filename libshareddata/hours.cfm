<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hours.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Shared Data Hours --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/hours.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Hours</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Hours</TITLE>
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
		if (document.HOURS.HOURSTEXT.value == "" || document.HOURS.HOURSTEXT.value == " ") {
			alertuser (document.HOURS.HOURSTEXT.name +  ",  An Hour Number MUST be entered!");
			document.HOURS.HOURSTEXT.focus();
			return false;
		}

		if (document.HOURS.HOURS.value == "" || document.HOURS.HOURS.value == " " 
		 || !document.HOURS.HOURS.value.match(/^\d{2}:\d{2}:\d{2} (AM|PM|am|pm)/)) {
			alertuser (document.HOURS.HOURS.name +  ",  An Hour in time format 'HH:MM:SS AMPM' MUST be entered!");
			document.HOURS.HOURS.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.HOURSID.selectedIndex == "0") {
			alertuser ("An Hour Number MUST be selected!");
			document.LOOKUP.HOURSID.focus();
			return false;
		}
	}


	function setDelete() {
		document.HOURS.PROCESSHOURS.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPHOUR') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.HOURSID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.HOURS.HOURSTEXT.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
********************************************
* The following code is for all Processes. *
********************************************
 --->

<CFQUERY name="ListHours" datasource="#application.type#LIBSHAREDDATA" blockfactor="44">
	SELECT	HOURSID, HOURSTEXT, HOURS, TO_CHAR(HOURS, 'HH:MI:SS AM') AS DISPLAYHOURS
	FROM		HOURS
	ORDER BY	HOURS, HOURSID
</CFQUERY>

<BR clear="left" />

<!--- 
****************************************************
* The following code is the ADD Process for Hours. *
****************************************************
 --->
<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Shared Data - Hours</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(HOURSID) AS MAX_ID
			FROM		HOURS
		</CFQUERY>
		<CFSET FORM.HOURSID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="HOURSID" secure="NO" value="#FORM.HOURSID#">
		<CFQUERY name="AddHoursID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	HOURS (HOURSID)
			VALUES		(#val(Cookie.HOURSID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Hours Key &nbsp; = &nbsp; #FORM.HOURSID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processhours.cfm" method="POST">
			<TD align="left" colspan="4">
				<INPUT type="hidden" name="PROCESSHOURS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="HOURS" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processhours.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="HOURSTEXT">*Hour Number</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="HOURS">*Hour in Time Format</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="HOURSTEXT" id="HOURSTEXT" value="" align="LEFT" required="No" size="8" maxlength="8" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="HOURS" id="HOURS" value="HH:MM:SS AM" align="LEFT" required="No" size="12" maxlength="12" tabindex="3"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSHOURS" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processhours.cfm" method="POST">
			<TD align="left" colspan="4">
				<INPUT type="hidden" name="PROCESSHOURS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="5" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="4">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*******************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Hours. *
*******************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Shared Data - Hours</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPHOUR')>
		<TR>
			<TH align="center">Hours Key &nbsp; = &nbsp; #FORM.HOURSID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPHOUR')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/hours.cfm?PROCESS=#URL.PROCESS#&LOOKUPHOUR=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="HOURSID">*Hour Number:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="HOURSID" id="HOURSID" size="1" query="ListHours" value="HOURSID" display="HOURSTEXT" required="No" tabindex="2"></CFSELECT>
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
********************************************************************
* The following code is the Modify and Delete Processes for Hours. *
********************************************************************
 --->

		<CFQUERY name="GetHours" datasource="#application.type#LIBSHAREDDATA">
			SELECT	HOURSID, HOURSTEXT, TO_CHAR(HOURS, 'HH:MI:SS AM') AS HOURS
			FROM		HOURS
			WHERE	HOURSID = <CFQUERYPARAM value="#FORM.HOURSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	HOURSID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/hours.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="4">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="HOURS" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processhours.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="HOURSID" secure="NO" value="#FORM.HOURSID#">
				<TH align="left"><H4><LABEL for="HOURSTEXT">*Hour Number</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="HOURS">*Hour in Time Format</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="HOURSTEXT" id="HOURSTEXT" value="#GetHours.HOURSTEXT#" align="LEFT" required="No" size="8" maxlength="8" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="HOURS" id="HOURS" value="#GetHours.HOURS#" align="LEFT" required="No" size="12" maxlength="12" tabindex="3"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSHOURS" value="MODIFY" /><BR />
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
<CFFORM action="/#application.type#apps/libshareddata/hours.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="4">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="4">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>