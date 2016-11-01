<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: fiscalyears.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Shared Data - Fiscal/Academic Years --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/fiscalyears.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Fiscal/Academic Years</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Fiscal/Academic Years</TITLE>
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
		if (document.FISCALYEARS.FISCALYEAR_2DIGIT.value == "" || document.FISCALYEARS.FISCALYEAR_2DIGIT.value == " "
		 || !document.FISCALYEARS.FISCALYEAR_2DIGIT.value.match(/^\d{2}\/\d{2}/)) {
			alertuser (document.FISCALYEARS.FISCALYEAR_2DIGIT.name +  ",  A 2 digit Fiscal Year range MUST be entered!");
			document.FISCALYEARS.FISCALYEAR_2DIGIT.focus();
			return false;
		}

		if (document.FISCALYEARS.FISCALYEAR_4DIGIT.value == "" || document.FISCALYEARS.FISCALYEAR_4DIGIT.value == ""
		 || !document.FISCALYEARS.FISCALYEAR_4DIGIT.value.match(/^\d{4}\-\d{4}/)) {
			alertuser (document.FISCALYEARS.FISCALYEAR_4DIGIT.name +  ",  A 4 digit Fiscal Year range MUST be entered!");
			document.FISCALYEARS.FISCALYEAR_4DIGIT.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.FISCALYEARID.selectedIndex == "0") {
			alertuser ("A Fiscal Year MUST be selected!");
			document.LOOKUP.FISCALYEARID.focus();
			return false;
		}
	}


	function setDelete() {
		document.FISCALYEARS.PROCESSFISCALYEARS.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPFISCALYEAR') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.FISCALYEARID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.FISCALYEARS.FISCALYEAR_2DIGIT.focus()">
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

<CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
	FROM		FISCALYEARS
	ORDER BY	FISCALYEARID
</CFQUERY>

<BR clear="left" />

<!--- 
*******************************************************************
* The following code is the ADD Process for Fiscal/Academic Years.*
*******************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Shared Data - Fiscal/Academic Years</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(FISCALYEARID) AS MAX_ID
			FROM		FISCALYEARS
		</CFQUERY>
		<CFSET FORM.FISCALYEARID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="FISCALYEARID" secure="NO" value="#FORM.FISCALYEARID#">
		<CFQUERY name="AddFiscalYearsID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	FISCALYEARS (FISCALYEARID)
			VALUES		(#val(Cookie.FISCALYEARID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Fiscal Years Key &nbsp; = &nbsp; #FORM.FISCALYEARID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processfiscalyears.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSFISCALYEARS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="FISCALYEARS" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processfiscalyears.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="FISCALYEAR_2DIGIT">*Fiscal Year - 2 Digits</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="FISCALYEAR_4DIGIT">*Fiscal Year - 4 Digits</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="FISCALYEAR_2DIGIT" id="FISCALYEAR_2DIGIT" value="" align="LEFT" required="No" size="5" maxlength="5" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="FISCALYEAR_4DIGIT" id="FISCALYEAR_4DIGIT" value="" align="LEFT" required="No" size="9" maxlength="9" tabindex="3"></TD>
		</TR>
		<TR>
			<TH align="left">Current Fiscal Year Flag</TH>
			<TH align="left">Current Academic Year Flag</TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="CURRENTFISCALYEAR" size="1" tabindex="4">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="CURRENTACADEMICYEAR" size="1" tabindex="5">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSFISCALYEARS" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="6" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processfiscalyears.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSFISCALYEARS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="7" /><BR />
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
**********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Fiscal/Academic Years.*
**********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined("URL.LOOKUPFISCALYEAR")>
			<TD align="center"><H1>Lookup for Modify/Delete Information to Shared Data - Fiscal/Academic Years</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to Shared Data - Fiscal/Academic Years</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPFISCALYEAR')>
		<TR>
			<TH align="center">Fiscal Year Key &nbsp; = &nbsp; #FORM.FISCALYEARID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPFISCALYEAR')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/fiscalyears.cfm?PROCESS=#URL.PROCESS#&LOOKUPFISCALYEAR=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="FISCALYEARID">*Fiscal Year:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" required="No" tabindex="2"></CFSELECT>
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
***********************************************************************************
* The following code is the Modify and Delete Processes for Fiscal/Academic Years.*
***********************************************************************************
 --->

		<CFQUERY name="GetFiscalYears" datasource="#application.type#LIBSHAREDDATA">
			SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
			FROM		FISCALYEARS
			WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FISCALYEARID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/fiscalyears.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="FISCALYEARS" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processfiscalyears.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="FISCALYEARID" secure="NO" value="#FORM.FISCALYEARID#">
				<TH align="left"><H4><LABEL for="FISCALYEAR_2DIGIT">*Fiscal Year - 2 Digits</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="FISCALYEAR_4DIGIT">*Fiscal Year - 4 Digits</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="FISCALYEAR_2DIGIT" id="FISCALYEAR_2DIGIT" value="#GetFiscalYears.FISCALYEAR_2DIGIT#" align="LEFT" required="No" size="5" maxlength="5" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="FISCALYEAR_4DIGIT" id="FISCALYEAR_4DIGIT" value="#GetFiscalYears.FISCALYEAR_4DIGIT#" align="LEFT" required="No" size="9" maxlength="9" tabindex="3"></TD>
			</TR>
			<TR>
				<TH align="left">Current Fiscal Year Flag</TH>
				<TH align="left">Current Academic Year Flag</TH>
			</TR>
			<TR>
				<TD>
					<CFSELECT name="CURRENTFISCALYEAR" size="1" tabindex="4">
						<OPTION selected value="#GetFiscalYears.CURRENTFISCALYEAR#">#GetFiscalYears.CURRENTFISCALYEAR#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="CURRENTACADEMICYEAR" size="1" tabindex="5">
						<OPTION selected value="#GetFiscalYears.CURRENTACADEMICYEAR#">#GetFiscalYears.CURRENTACADEMICYEAR#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
                         <BR /><BR />
				</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSFISCALYEARS" value="MODIFY" /><BR />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="6" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="7" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/fiscalyears.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="8" /><BR />
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