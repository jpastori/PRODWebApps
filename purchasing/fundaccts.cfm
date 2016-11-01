<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: fundaccts.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Purchasing - Fund Accounts --->
<!-- Last modified by John R. Pastori on 07/09/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/fundaccts.cfm">
<CFSET CONTENT_UPDATED = "July 09, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Purchasing - Fund Accounts</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Purchasing - Fund Accounts</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Purchasing";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.FUNDACCT.FUNDACCTNAME.value == "" || document.FUNDACCT.FUNDACCTNAME.value == " ") {
			alertuser (document.FUNDACCT.FUNDACCTNAME.name +  ",  A Fund Account Name MUST be entered!");
			document.FUNDACCT.FUNDACCTNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.FUNDACCTID.selectedIndex == "0") {
			alertuser ("A Fund Account Name MUST be selected!");
			document.LOOKUP.FUNDACCTID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.FUNDACCT.PROCESSFUNDACCTS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPFUNDACCT') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.FUNDACCTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.FUNDACCT.FUNDACCTNAME.focus()">
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

<CFQUERY name="ListFundAccts" datasource="#application.type#PURCHASING" blockfactor="15">
	SELECT	FUNDACCTID, FUNDACCTNAME
	FROM		FUNDACCTS
	ORDER BY	FUNDACCTNAME
</CFQUERY>

<BR clear="left" />

<!--- 
************************************************************
* The following code is the ADD Process for Fund Accounts. *
************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Purchasing - Fund Accounts</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#PURCHASING">
		SELECT	MAX(FUNDACCTID) AS MAX_ID
		FROM		FUNDACCTS
	</CFQUERY>
	<CFSET FORM.FUNDACCTID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="FUNDACCTID" secure="NO" value="#FORM.FUNDACCTID#">
	<CFQUERY name="AddFundAcctsID" datasource="#application.type#PURCHASING">
		INSERT INTO	FUNDACCTS (FUNDACCTID)
		VALUES		(#val(Cookie.FUNDACCTID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Fund Accounts Key &nbsp; = &nbsp; #FORM.FUNDACCTID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processfundaccts.cfm" method="POST">
			<TD align="left" colspan="2">
               	<INPUT type="hidden" name="PROCESSFUNDACCTS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="FUNDACCT" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processfundaccts.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="FUNDACCTNAME">*Fund Accounts Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="FUNDACCTNAME" id="FUNDACCTNAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSFUNDACCTS" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processfundaccts.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSFUNDACCTS" value="CANCELADD" />
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
***************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Fund Accounts. *
***************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPFUNDACCT')>
			<TD align="center"><H1>Modify/Delete Lookup Information to IDT Purchasing - Fund Accounts</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to IDT Purchasing - Fund Accounts</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPFUNDACCT')>
		<TR>
			<TH align="center"> Fund Accounts Key &nbsp; = &nbsp; #FORM.FUNDACCTID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPFUNDACCT')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/purchasing/fundaccts.cfm?PROCESS=#URL.PROCESS#&LOOKUPFUNDACCT=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="FUNDACCTID">*Fund Accounts Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="FUNDACCTID" id="FUNDACCTID" size="1" query="ListFundAccts" value="FUNDACCTID" display="FUNDACCTNAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
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
***************************************************************************
* The following code is the Modify and Delete Processes for Fund Accounts.*
***************************************************************************
 --->

		<CFQUERY name="GetFundAccts" datasource="#application.type#PURCHASING">
			SELECT	FUNDACCTID, FUNDACCTNAME
			FROM		FUNDACCTS
			WHERE	FUNDACCTID = <CFQUERYPARAM value="#FORM.FUNDACCTID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FUNDACCTNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/fundaccts.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="FUNDACCT" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processfundaccts.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="FUNDACCTID" secure="NO" value="#FORM.FUNDACCTID#">
				<TH align="left"><H4><LABEL for="FUNDACCTNAME">*Fund Accounts Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="FUNDACCTNAME" id="FUNDACCTNAME" value="#GetFundAccts.FUNDACCTNAME#" align="LEFT" required="No" size="50" tabindex="23"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSFUNDACCTS" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/purchasing/fundaccts.cfm?PROCESS=#URL.PROCESS#" method="POST">
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