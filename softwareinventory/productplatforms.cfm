<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: productplatforms.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2011 --->
<!--- Date in Production: 08/03/2011 --->
<!--- Module: Add/Modify/Delete Information to IDT Software Inventory - Product Platforms --->
<!-- Last modified by John R. Pastori on 08/03/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/productplatforms.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2011">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Software Inventory - Product Platforms</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Software Inventory - Product Platforms</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Facilities";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.PRODUCTPLATFORMS.PRODUCTPLATFORMNAME.value == "" || document.PRODUCTPLATFORMS.PRODUCTPLATFORMNAME.value == " ") {
			alertuser (document.PRODUCTPLATFORMS.PRODUCTPLATFORMNAME.name +  ",  A Product Platform Name MUST be entered!");
			document.PRODUCTPLATFORMS.PRODUCTPLATFORMNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.PRODUCTPLATFORMID.selectedIndex == "0") {
			alertuser ("A Product Platform Name MUST be selected!");
			document.LOOKUP.PRODUCTPLATFORMID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPRODUCTPLATFORM') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.PRODUCTPLATFORMID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.PRODUCTPLATFORMS.PRODUCTPLATFORMNAME.focus()">
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

<CFQUERY name="ListProductPlatforms" datasource="#application.type#SOFTWARE" blockfactor="6">
	SELECT	PRODUCTPLATFORMID, PRODUCTPLATFORMNAME
	FROM		PRODUCTPLATFORMS
	ORDER BY	PRODUCTPLATFORMNAME
</CFQUERY>

<BR clear="left" />

<!--- 
****************************************************************
* The following code is the ADD Process for Product Platforms. *
****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Software Inventory - Product Platforms</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
		SELECT	MAX(PRODUCTPLATFORMID) AS MAX_ID
		FROM		PRODUCTPLATFORMS
	</CFQUERY>
	<CFSET FORM.PRODUCTPLATFORMID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="PRODUCTPLATFORMID" secure="NO" value="#FORM.PRODUCTPLATFORMID#">
	<CFQUERY name="AddProductPlatformsID" datasource="#application.type#SOFTWARE">
		INSERT INTO	PRODUCTPLATFORMS (PRODUCTPLATFORMID)
		VALUES		(#val(Cookie.PRODUCTPLATFORMID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Product Platform Key &nbsp; = &nbsp; #FORM.PRODUCTPLATFORMID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processproductplatforms.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessProductPlatforms" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="PRODUCTPLATFORMS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processproductplatforms.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="PRODUCTPLATFORMNAME">*Product Platform:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="PRODUCTPLATFORMNAME" id="PRODUCTPLATFORMNAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessProductPlatforms" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processproductplatforms.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessProductPlatforms" value="CANCELADD" tabindex="4" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Product Platforms. *
*******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to IDT Software Inventory - Product Platforms</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPPRODUCTPLATFORM')>
		<TR>
			<TH align="center">Product Platform Key &nbsp; = &nbsp; #FORM.PRODUCTPLATFORMID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPPRODUCTPLATFORM')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/productplatforms.cfm?PROCESS=#URL.PROCESS#&LOOKUPPRODUCTPLATFORM=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="PRODUCTPLATFORMID">*Product Platform:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="PRODUCTPLATFORMID" id="PRODUCTPLATFORMID" size="1" query="ListProductPlatforms" value="PRODUCTPLATFORMID" display="PRODUCTPLATFORMNAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
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
*******************************************************************************
* The following code is the Modify and Delete Processes for Product Platforms.*
*******************************************************************************
 --->

		<CFQUERY name="GetProductPlatforms" datasource="#application.type#SOFTWARE">
			SELECT	PRODUCTPLATFORMID, PRODUCTPLATFORMNAME
			FROM		PRODUCTPLATFORMS
			WHERE	PRODUCTPLATFORMID = <CFQUERYPARAM value="#FORM.PRODUCTPLATFORMID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PRODUCTPLATFORMID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/productplatforms.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessProductPlatforms" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="PRODUCTPLATFORMS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processproductplatforms.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="PRODUCTPLATFORMID" secure="NO" value="#FORM.PRODUCTPLATFORMID#">
				<TH align="left"><H4><LABEL for="PRODUCTPLATFORMNAME">*Product Platform Name:</H4></TH>
				<TD align="left"><CFINPUT type="Text" name="PRODUCTPLATFORMNAME" id="PRODUCTPLATFORMNAME" align="LEFT" value="#GetProductPlatforms.PRODUCTPLATFORMNAME#" required="No" size="50" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessProductPlatforms" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessProductPlatforms" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/productplatforms.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessProductPlatforms" value="Cancel" tabindex="5" /><BR />
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