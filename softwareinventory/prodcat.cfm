<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: prodcat.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Software Inventory - Product Categories --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/prodcat.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Software Inventory - Product Categories</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Software Inventory - Product Categories</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Software Inventory";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.PRODCAT.PRODCATNAME.value == "" || document.PRODCAT.PRODCATNAME.value == " ") {
			alertuser (document.PRODCAT.PRODCATNAME.name +  ",  A Product Category MUST be entered!");
			document.PRODCAT.PRODCATNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.PRODCATID.selectedIndex == "0") {
			alertuser ("A Product Category MUST be selected!");
			document.LOOKUP.PRODCATID.focus();
			return false;
		}
	}


	function setDelete() {
		document.PRODCAT.PROCESSPRODCATS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPRODCATS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.PRODCATID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.PRODCAT.PRODCATNAME.focus()">
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

<CFQUERY name="ListProdCat" datasource="#application.type#SOFTWARE" blockfactor="30">
	SELECT	PRODCATID, PRODCATNAME
	FROM		PRODUCTCATEGORIES
	ORDER BY	PRODCATNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*****************************************************************
* The following code is the ADD Process for Product Categories. *
*****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Software Inventory - Product Categories</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
		SELECT	MAX(PRODCATID) AS MAX_ID
		FROM		PRODUCTCATEGORIES
	</CFQUERY>
	<CFSET FORM.PRODCATID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="PRODCATID" secure="NO" value="#FORM.PRODCATID#">
	<CFQUERY name="AddProdCatID" datasource="#application.type#SOFTWARE">
		INSERT INTO	PRODUCTCATEGORIES (PRODCATID)
		VALUES		(#val(Cookie.PRODCATID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Product Categories Key &nbsp; = &nbsp; #FORM.PRODCATID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
	<CFFORM action="/#application.type#apps/softwareinventory/processprodcat.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPRODCATS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
	</CFFORM>
		</TR>
	<CFFORM name="PRODCAT" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processprodcat.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="PRODCATNAME">*Product Category Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="PRODCATNAME" id="PRODCATNAME" value="" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSPRODCATS" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
		</TR>
	</CFFORM>
		<TR>
	<CFFORM action="/#application.type#apps/softwareinventory/processprodcat.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPRODCATS" value="CANCELADD" />
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
********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Product Categories. *
********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPPRODCATS')>
			<TD align="center"><H1>Lookup for Modify/Delete to IDT Software Inventory - Product Categories </H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete to IDT Software Inventory - Product Categories </H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPPRODCATS')>
		<TR>
			<TH align="center">Product Categories Key &nbsp; = &nbsp; #FORM.PRODCATID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPPRODCATS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/prodcat.cfm?PROCESS=#URL.PROCESS#&LOOKUPPRODCATS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="PRODCATID">*Product Category Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="PRODCATID" id="PRODCATID" size="1" query="ListProdCat" value="PRODCATID" display="PRODCATNAME" required="No" tabindex="2"></CFSELECT>
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
				<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
********************************************************************************
* The following code is the Modify and Delete Processes for Product Categories.*
********************************************************************************
 --->

		<CFQUERY name="GetProdCat" datasource="#application.type#SOFTWARE">
			SELECT	PRODCATID, PRODCATNAME
			FROM		PRODUCTCATEGORIES
			WHERE	PRODCATID = <CFQUERYPARAM value="#FORM.PRODCATID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PRODCATNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/prodcat.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="PRODCAT" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processprodcat.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="PRODCATID" secure="NO" value="#FORM.PRODCATID#">
				<TH align="left"><H4><LABEL for="PRODCATNAME">*Product Category Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="PRODCATNAME" id="PRODCATNAME" value="#GetProdCat.PRODCATNAME#" align="LEFT" required="No" size="100" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPRODCATS" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/softwareinventory/prodcat.cfm?PROCESS=#URL.PROCESS#" method="POST">
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