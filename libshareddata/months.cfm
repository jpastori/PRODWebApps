<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: months.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Shared Data Months --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/months.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Months</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Months</TITLE>
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
		if (document.MONTHS.MONTHNAME.value == "" || document.MONTHS.MONTHNAME.value == " ") {
			alertuser (document.MONTHS.MONTHNAME.name +  ",  A Month Name MUST be entered!");
			document.MONTHS.MONTHNAME.focus();
			return false;
		}

		if (document.MONTHS.MONTHNUMBERASCHAR.value == "" || document.MONTHS.MONTHNUMBERASCHAR.value == " ") {
			alertuser (document.MONTHS.MONTHNUMBERASCHAR.name +  ",  A 2 digit Month Number MUST be entered!  Single digit months must have 1st digit as zero.");
			document.MONTHS.MONTHNUMBERASCHAR.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.MONTHID.selectedIndex == "0") {
			alertuser ("A Month Name MUST be selected!");
			document.LOOKUP.MONTHID.focus();
			return false;
		}
	}


	function setDelete() {
		document.MONTHS.PROCESSMONTHS.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPMONTH') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.MONTHID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.MONTHS.MONTHNAME.focus()">
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

<CFQUERY name="ListMonths" datasource="#application.type#LIBSHAREDDATA" blockfactor="13">
	SELECT	MONTHID, MONTHNAME, MONTHNUMBERASCHAR
	FROM		MONTHS
	ORDER BY	MONTHID
</CFQUERY>

<BR clear="left" />

<!--- 
*****************************************************
* The following code is the ADD Process for Months. *
*****************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Shared Data - Months</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(MONTHID) AS MAX_ID
			FROM		MONTHS
		</CFQUERY>
		<CFSET FORM.MONTHID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="MONTHID" secure="NO" value="#FORM.MONTHID#">
		<CFQUERY name="AddMonthsID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	MONTHS (MONTHID)
			VALUES		(#val(Cookie.MONTHID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Months Key &nbsp; = &nbsp; #FORM.MONTHID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processmonths.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSMONTHS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="MONTHS" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processmonths.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="MONTHNAME">*Month Name</LABEL></H4></TH>
			<TH align="Center"><H4><LABEL for="MONTHNUMBERASCHAR">*Month Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="MONTHNAME" id="MONTHNAME" value="" align="LEFT" required="No" size="15" tabindex="2">
			</TD>
			<TD align="CENTER" valign ="TOP">
				<CFINPUT type="Text" name="MONTHNUMBERASCHAR" id="MONTHNUMBERASCHAR" value="" align="LEFT" required="No" size="2" maxlength ="2" tabindex="3"><BR />
				<COM>(A leading zero is required<BR /> for single digit months.)</COM>
			</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSMONTHS" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processmonths.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSMONTHS" value="CANCELADD" />
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
* The following code is the Look Up Process for Modifying and Deleting Months. *
********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Shared Data - Months</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPMONTH')>
		<TR>
			<TH align="center">Months Key &nbsp; = &nbsp; #FORM.MONTHID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPMONTH')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/months.cfm?PROCESS=#URL.PROCESS#&LOOKUPMONTH=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="MONTHID">*Month Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="MONTHID" id="MONTHID" size="1" query="ListMonths" value="MONTHID" display="MONTHNAME" required="No" tabindex="2"></CFSELECT>
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
*********************************************************************
* The following code is the Modify and Delete Processes for Months. *
*********************************************************************
 --->

		<CFQUERY name="GetMonths" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MONTHID, MONTHNAME, MONTHNUMBERASCHAR
			FROM		MONTHS
			WHERE	MONTHID = <CFQUERYPARAM value="#FORM.MONTHID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	MONTHID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/months.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="MONTHS" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processmonths.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="MONTHID" secure="NO" value="#FORM.MONTHID#">
				<TH align="left"><H4><LABEL for="MONTHNAME">*Month Name</LABEL></H4></TH>
				<TH align="Center"><H4><LABEL for="MONTHNUMBERASCHAR">*Month Number</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="MONTHNAME" id="MONTHNAME" value="#GetMonths.MONTHNAME#" align="LEFT" required="No" size="15" tabindex="2">
				</TD>
				<TD align="CENTER" valign ="TOP">
					<CFINPUT type="Text" name="MONTHNUMBERASCHAR" id="MONTHNUMBERASCHAR" value="#GetMonths.MONTHNUMBERASCHAR#" align="LEFT" required="No" size="2" maxlength ="2" tabindex="3"><BR />
					<COM>(A leading zero is required<BR /> for single digit months.)</COM>
				</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSMONTHS" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/libshareddata/months.cfm?PROCESS=#URL.PROCESS#" method="POST">
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