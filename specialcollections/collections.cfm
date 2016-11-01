<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: collections.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/23/2008 --->
<!--- Date in Production: 07/23/2008 --->
<!--- Module: Add/Modify/Delete Information to Special Collections - Collections --->
<!-- Last modified by John R. Pastori on 07/23/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/collections.cfm">
<CFSET CONTENT_UPDATED = "July 23, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Special Collections - Collections</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Special Collections - Collections</TITLE>
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
		if (document.COLLECTIONS.COLLECTIONNAME.value == "" || document.COLLECTIONS.COLLECTIONNAME.value == " ") {
			alertuser (document.COLLECTIONS.COLLECTIONNAME.name +  ",  An Collection Name MUST be entered!");
			document.COLLECTIONS.COLLECTIONNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.COLLECTIONID.selectedIndex == "0") {
			alertuser ("An Collection Name MUST be selected!");
			document.LOOKUP.COLLECTIONID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCOLLECTIONS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.COLLECTIONID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.COLLECTIONS.COLLECTIONNAME.focus()">
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

<CFQUERY name="ListCollections" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="100">
	SELECT	COLLECTIONID, COLLECTIONNAME
	FROM		COLLECTIONS
	ORDER BY	COLLECTIONNAME
</CFQUERY>

<BR clear="left" />

<!--- 
**********************************************************
* The following code is the ADD Process for Collections. *
**********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Special Collections - Collections</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	MAX(COLLECTIONID) AS MAX_ID
			FROM		COLLECTIONS
		</CFQUERY>
		<CFSET FORM.COLLECTIONID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="COLLECTIONID" secure="NO" value="#FORM.COLLECTIONID#">
		<CFQUERY name="AddCollectionID" datasource="#application.type#SPECIALCOLLECTIONS">
			INSERT INTO	COLLECTIONS (COLLECTIONID)
			VALUES		(#val(Cookie.COLLECTIONID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Collection Key &nbsp; = &nbsp; #FORM.COLLECTIONID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processcollections.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCollections" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="COLLECTIONS" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processcollections.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="COLLECTIONNAME">*Collection Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="COLLECTIONNAME" id="COLLECTIONNAME" value="" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessCollections" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processcollections.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCollections" value="CANCELADD" tabindex="4" /><BR />
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
*************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Collections. *
*************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Special Collections - Collections </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPCOLLECTIONS')>
		<TR>
			<TH align="center">Collection Key &nbsp; = &nbsp; #FORM.COLLECTIONID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCollections')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/specialcollections/collections.cfm?PROCESS=#URL.PROCESS#&LOOKUPCOLLECTIONS=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="COLLECTIONID">*Collection Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="COLLECTIONID" id="COLLECTIONID" size="1" query="ListCollections" value="COLLECTIONID" display="COLLECTIONNAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
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
*************************************************************************
* The following code is the Modify and Delete Processes for Collections.*
*************************************************************************
 --->

		<CFQUERY name="GetCollections" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	COLLECTIONID, COLLECTIONNAME
			FROM		COLLECTIONS
			WHERE	COLLECTIONID = <CFQUERYPARAM value="#FORM.COLLECTIONID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	COLLECTIONNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/collections.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessCollections" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="COLLECTIONS" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processcollections.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="COLLECTIONID" secure="NO" value="#FORM.COLLECTIONID#">
				<TH align="left"><H4><LABEL for="COLLECTIONNAME">*Collection Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="COLLECTIONNAME" id="COLLECTIONNAME" value="#GetCollections.COLLECTIONNAME#" align="LEFT" required="No" size="100" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessCollections" value="MODIFY" tabindex="3" /></TD>
			</TR>
			<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessCollections" value="DELETE" tabindex="4" /></TD>
			</TR>
			</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/collections.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessCollections" value="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>