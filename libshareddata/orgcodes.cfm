<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: orgcodes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Shared Data - Organization Codes --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/orgcodes.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Organization Codes</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Organization Codes</TITLE>
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

		if (document.ORGCODES.ORGCODE.value == "" || document.ORGCODES.ORGCODE.value == " ") {
			alertuser (document.ORGCODES.ORGCODE.name +  ",  An Org Code MUST be entered!");
			document.ORGCODES.ORGCODE.focus();
			return false;
		}

		if (document.ORGCODES.ORGCODEDESCRIPTION.value == "" || document.ORGCODES.ORGCODEDESCRIPTION.value == " ") {
			alertuser (document.ORGCODES.ORGCODEDESCRIPTION.name +  ",  An Org Code Description MUST be entered!");
			document.ORGCODES.ORGCODEDESCRIPTION.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.ORGCODEID.selectedIndex == "0") {
			alertuser ("An Org Code MUST be selected!");
			document.LOOKUP.ORGCODEID.focus();
			return false;
		}
	}


	function setDelete() {
		document.ORGCODES.PROCESSORGCODES.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPORGCODEID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.ORGCODEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.ORGCODES.ORGCODE.focus()">
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

<CFQUERY name="ListOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
	SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, MODIFIEDBYID, MODIFIEDDATE, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
	FROM		ORGCODES
	ORDER BY	ORGCODE
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 700 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<BR clear="left" />

<!--- 
********************************************************
* The following code is the ADD Process for Org Codes. *
********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Shared Data - Organization Codes</H1></TD>
		</TR>
	</TABLE>

		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(ORGCODEID) AS MAX_ID
			FROM		ORGCODES
		</CFQUERY>
		<CFSET FORM.ORGCODEID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="ORGCODEID" secure="NO" value="#FORM.ORGCODEID#">
		<CFQUERY name="AddOrgCodesID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	ORGCODES (ORGCODEID)
			VALUES		(#val(Cookie.ORGCODEID)#)
		</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Organization Code Key &nbsp; = &nbsp; #FORM.ORGCODEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processorgcodes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSORGCODES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="ORGCODES" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processorgcodes.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="ORGCODE">*Org Code</LABEL></H4></TH>
			<TH align="left" valign ="bottom"><H4><LABEL for="ORGCODEDESCRIPTION">*Description</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="ORGCODE" id="ORGCODE" value="" align="LEFT" required="No" size="5" maxlength="5" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="ORGCODEDESCRIPTION" id="ORGCODEDESCRIPTION" value="" align="LEFT" required="No" size="50" maxlength="50" tabindex="3"></TD>
		</TR>
          <TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
			<TH align="left">Date Created</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="4"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#<BR /><BR />
			</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSORGCODES" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="5" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processorgcodes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSORGCODES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="6" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Org Codes. *
***********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPORGCODEID')>
			<TD align="center"><H1>Modify/Delete Lookup Information to Shared Data - Organization Codes</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to Shared Data - Organization Codes</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPORGCODEID')>
		<TR>
			<TH align="center">Organization Code Key &nbsp; = &nbsp; #FORM.ORGCODEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPORGCODEID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=#URL.PROCESS#&LOOKUPORGCODEID=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="ORGCODEID">*Org Code:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="ORGCODEID" id="ORGCODEID" size="1" query="ListOrgCodes" value="ORGCODEID" display="ORGCODENAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
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
************************************************************************
* The following code is the Modify and Delete Processes for Org Codes. *
************************************************************************
 --->

		<CFQUERY name="GetOrgCodes" datasource="#application.type#LIBSHAREDDATA">
			SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, MODIFIEDBYID, MODIFIEDDATE
			FROM		ORGCODES
			WHERE	ORGCODEID = <CFQUERYPARAM value="#FORM.ORGCODEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ORGCODE
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="ORGCODES" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processorgcodes.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="ORGCODEID" secure="NO" value="#FORM.ORGCODEID#">
				<TH align="left"><H4><LABEL for="ORGCODE">*Org Code</LABEL></H4></TH>
				<TH align="left" valign ="bottom"><H4><LABEL for="ORGCODEDESCRIPTION">*Description</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="ORGCODE" id="ORGCODE" value="#GetOrgCodes.ORGCODE#" align="LEFT" required="No" size="5" maxlength="5" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="ORGCODEDESCRIPTION" id="ORGCODEDESCRIPTION" value="#GetOrgCodes.ORGCODEDESCRIPTION#" align="LEFT" required="No" size="50" maxlength="50" tabindex="3"></TD>
			</TR>
               <TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
				<TH align="left">Date Modified</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#GetOrgCodes.MODIFIEDBYID#" tabindex="4"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#<BR /><BR />
				</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSORGCODES" value="MODIFY" /><BR />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="5" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="6" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="7" /><BR />
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