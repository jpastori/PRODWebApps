<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: years.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Shared Data - Years --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/years.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Years</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Years</TITLE>
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
		if (document.YEARS.YEAR.value == "" || document.YEARS.YEAR.value == " " || !document.YEARS.YEAR.value.match(/^\d{4}/)) {
			alertuser (document.YEARS.YEAR.name +  ",  A 4 digit Year MUST be entered!");
			document.YEARS.YEAR.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.YEARID.selectedIndex == "0") {
			alertuser ("A Year MUST be selected!");
			document.LOOKUP.YEARID.focus();
			return false;
		}
	}


	function setDelete() {
		document.YEARS.PROCESSYEARS.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPYEAR') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.YEARID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.YEARS.YEAR.focus()">
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

<CFQUERY name="ListYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="28">
	SELECT	YEARID, YEAR
	FROM		YEARS
	ORDER BY	YEARID
</CFQUERY>

<BR clear="left" />

<!--- 
****************************************************
* The following code is the ADD Process for Years. *
****************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Shared Data - Years</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(YEARID) AS MAX_ID
			FROM		YEARS
		</CFQUERY>
		<CFSET FORM.YEARID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="YEARID" secure="NO" value="#FORM.YEARID#">
		<CFQUERY name="AddYearsID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	YEARS (YEARID)
			VALUES		(#val(Cookie.YEARID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Years Key &nbsp; = &nbsp; #FORM.YEARID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processyears.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSYEARS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="YEARS" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processyears.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="YEAR">*Year:</LABEL></H4></TH>
			<TD align="left">
				<CFINPUT type="Text" name="YEAR" id="YEAR" value="" align="LEFT" required="No" size="4" maxlength="4" tabindex="2"><BR />
				YYYY
			</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSYEARS" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
          </TR>
</CFFORM>
          <TR>
<CFFORM action="/#application.type#apps/libshareddata/processyears.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSYEARS" value="CANCELADD" />
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
*******************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Years. *
*******************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Shared Data - Years</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPYEAR')>
		<TR>
			<TH align="center">Years Key &nbsp; = &nbsp; #FORM.YEARID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPYEAR')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/years.cfm?PROCESS=#URL.PROCESS#&LOOKUPYEAR=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="YEARID">*Year:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="YEARID" id="YEARID" size="1" query="ListYears" value="YEARID" display="YEAR" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD  align="left">
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
* The following code is the Modify and Delete Processes for Years. *
********************************************************************
 --->

		<CFQUERY name="GetYears" datasource="#application.type#LIBSHAREDDATA">
			SELECT	YEARID, YEAR
			FROM		YEARS
			WHERE	YEARID = <CFQUERYPARAM value="#FORM.YEARID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	YEARID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/years.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="YEARS" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processyears.cfm" method="POST" ENABLECAB="Yes">
				<CFCOOKIE name="YEARID" secure="NO" value="#FORM.YEARID#">
				<TH align="left"><H4><LABEL for="YEAR">*Year:</LABEL></H4></TH>
				<TD align="left">
					<CFINPUT type="Text" name="YEAR" id="YEAR" value="#GetYears.YEAR#" align="LEFT" required="No" size="4" maxlength="4" tabindex="2"><BR />
					YYYY
				</TD>
			
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSYEARS" value="MODIFY" /><BR />
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
<CFFORM action="/#application.type#apps/libshareddata/years.cfm?PROCESS=#URL.PROCESS#" method="POST">
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