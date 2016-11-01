<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: customercategories.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Shared Data - Customer Category --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/customercategories.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Customer Categories</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Customer Categories</TITLE>
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
		if (document.CUSTOMERCATEGORY.CATEGORYNAME.value == "" || document.CUSTOMERCATEGORY.CATEGORYNAME.value == " ") {
			alertuser (document.CUSTOMERCATEGORY.CATEGORYNAME.name +  ",  A Customer Category Code MUST be entered!");
			document.CUSTOMERCATEGORY.CATEGORYNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.CATID.selectedIndex == "0") {
			alertuser ("A Customer Category MUST be selected!");
			document.LOOKUP.CATID.focus();
			return false;
		}
	}


	function setDelete() {
		document.CUSTOMERCATEGORY.PROCESSCUSTOMERCATEGORY.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCAT') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.CATID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CUSTOMERCATEGORY.CATEGORYNAME.focus()">
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

<CFQUERY name="ListCustomerCategory" datasource="#application.type#LIBSHAREDDATA" blockfactor="15">
	SELECT	CATEGORYID, CATEGORYNAME
	FROM		CATEGORIES
	ORDER BY	CATEGORYNAME
</CFQUERY>

<BR clear = "left" />

<!--- 
******************************************************************
* The following code is the ADD Process for Customer Categories. *
******************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Add Information to Shared Data - Customer Categories</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(CATEGORYID) AS MAX_ID
			FROM		CATEGORIES
		</CFQUERY>
		<CFSET FORM.CATID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="CATID" secure="NO" value="#FORM.CATID#">
		<CFQUERY name="AddCustomerCategoryID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	CATEGORIES (CATEGORYID)
			VALUES		(#val(Cookie.CATID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Customer Category Key &nbsp; = &nbsp; #FORM.CATID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%"  border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processcustomercategories.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="hidden" name="PROCESSCUSTOMERCATEGORY" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CUSTOMERCATEGORY" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processcustomercategories.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="CATEGORYNAME">*Category Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="CATEGORYNAME" id="CATEGORYNAME" value="" align="left" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSCUSTOMERCATEGORY" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processcustomercategories.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="hidden" name="PROCESSCUSTOMERCATEGORY" value="CANCELADD" />
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
*********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Customer Categories. *
*********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Modify/Delete Information to Shared Data - Customer Categories</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPCAT')>
		<TR>
			<TH align="center">Customer Category Key &nbsp; = &nbsp; #FORM.CATID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCAT')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/customercategories.cfm?PROCESS=#URL.PROCESS#&LOOKUPCAT=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="CATID">*Category Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="CATID" id="CATID" size="1" query="ListCustomerCategory" value="CATEGORYID" display="CATEGORYNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT">
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
**********************************************************************************
* The following code is the Modify and Delete Processes for Customer Categories. *
**********************************************************************************
 --->

		<CFQUERY name="GetCustomerCategory" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CATEGORYID, CATEGORYNAME
			FROM		CATEGORIES
			WHERE	CATEGORYID = <CFQUERYPARAM value="#FORM.CATID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CATEGORYNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/customercategories.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
			</TR>
<CFFORM name="CUSTOMERCATEGORY" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processcustomercategories.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="CATID" secure="NO" value="#FORM.CATID#">
				<TH align="left"><H4><LABEL for="CATEGORYNAME">*Category Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="CATEGORYNAME" id="CATEGORYNAME" value="#GetCustomerCategory.CATEGORYNAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSCUSTOMERCATEGORY" value="MODIFY" /><BR />
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
<CFFORM action="/#application.type#apps/libshareddata/customercategories.cfm?PROCESS=#URL.PROCESS#" method="POST">
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