<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: imagesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Software Inventory Images --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/imagesinfo.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Software Inventory - Images</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Software Inventory - Images</TITLE>
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
		if (document.IMAGES.IMAGENAME.value == "" || document.IMAGES.IMAGENAME.value == " ") {
			alertuser (document.IMAGES.IMAGENAME.name +  ",  An Image Name MUST be entered!");
			document.IMAGES.IMAGENAME.focus();
			return false;
		}
		
		if (document.IMAGES.IMAGEDESCRIPTION.value == "" || document.IMAGES.IMAGEDESCRIPTION.value == " ") {
			alertuser (document.IMAGES.IMAGEDESCRIPTION.name +  ",  An Image Description MUST be entered!");
			document.IMAGES.IMAGEDESCRIPTION.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.IMAGEID.selectedIndex == "0") {
			alertuser ("An Image Name MUST be selected!");
			document.LOOKUP.IMAGEID.focus();
			return false;
		}
	}


	function setDelete() {
		document.IMAGES.PROCESSIMAGES.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPIMAGE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.IMAGEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.IMAGES.IMAGENAME.focus()">
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

<CFQUERY name="ListImages" datasource="#application.type#SOFTWARE" blockfactor="13">
	SELECT	IMAGEID, IMAGENAME, IMAGEDESCRIPTION, IMAGENOTES
	FROM		IMAGES
	ORDER BY	IMAGENAME
</CFQUERY>

<!--- 
*****************************************************
* The following code is the ADD Process for Images. *
*****************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Software Inventory - Images</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
		SELECT	MAX(IMAGEID) AS MAX_ID
		FROM		IMAGES
	</CFQUERY>
	<CFSET FORM.IMAGEID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="IMAGEID" secure="NO" value="#FORM.IMAGEID#">
	<CFQUERY name="AddImagesID" datasource="#application.type#SOFTWARE">
		INSERT INTO	IMAGES (IMAGEID)
		VALUES		(#val(Cookie.IMAGEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Images Key &nbsp; = &nbsp; #FORM.IMAGEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processimagesinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSIMAGES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="IMAGES" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processimagesinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" width="5%" nowrap><H4><LABEL for="IMAGENAME">*Images:</LABEL></H4></TH>
			<TD align="left" width="95%"><CFINPUT type="Text" name="IMAGENAME" id="IMAGENAME" value="" align="LEFT" required="No" size="25" tabindex="2"></TD>
		</TR>
          <TR>
			<TH align="left" width="5%" valign="TOP" nowrap><H4><LABEL for="IMAGEDESCRIPTION">*Description:</LABEL></H4></TH>
			<TD align="left" width="95%"><CFTEXTAREA name="IMAGEDESCRIPTION" id="IMAGEDESCRIPTION" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="3"></CFTEXTAREA></TD>
		</TR>
          <TR>
			<TH align="left" width="5%" valign="TOP" nowrap><LABEL for="IMAGENOTES">Notes:</LABEL></TH>
			<TD align="left" width="95%"><CFTEXTAREA name="IMAGENOTES" id="IMAGENOTES" wrap="VIRTUAL" REQUIRED="No" rows="7" cols="80" tabindex="4"></CFTEXTAREA></TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">
               	<INPUT type="hidden" name="PROCESSIMAGES" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="5" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processimagesinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSIMAGES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="6" /><BR />
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
********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Images. *
********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPIMAGE')>
			<TD align="center"><H1>Lookup for Modify/Delete to IDT Software Inventory - Images</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete to IDT Software Inventory - Images</H1></TD>
		</CFIF>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPIMAGE')>
		<TR>
			<TH align="center">Images Key &nbsp; = &nbsp; #FORM.IMAGEID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPIMAGE')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/imagesinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPIMAGE=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="IMAGEID">*Images:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="IMAGEID" id="IMAGEID" size="1" query="ListImages" value="IMAGEID" display="IMAGENAME" required="No" tabindex="2"></CFSELECT>
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
*********************************************************************
* The following code is the Modify and Delete Processes for Images. *
*********************************************************************
 --->

		<CFQUERY name="GetImages" datasource="#application.type#SOFTWARE">
			SELECT	IMAGEID, IMAGENAME, IMAGEDESCRIPTION, IMAGENOTES
			FROM		IMAGES
			WHERE 	IMAGEID = <CFQUERYPARAM value="#FORM.IMAGEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	IMAGENAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/imagesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="IMAGES" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processimagesinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="IMAGEID" secure="NO" value="#FORM.IMAGEID#">
				<TH align="left" width="5%" nowrap><H4><LABEL for="IMAGENAME">*Images:</LABEL></H4></TH>
				<TD align="left" width="95%"><CFINPUT type="Text" name="IMAGENAME" id="IMAGENAME" value="#GetImages.IMAGENAME#" align="LEFT" required="No" size="25" tabindex="2"></TD>
			</TR>
               <TR>
				<TH align="left" width="5%" valign="TOP" nowrap><H4><LABEL for="IMAGENAME">*Description:</LABEL></H4></TH>
				<TD align="left" width="95%"><CFTEXTAREA name="IMAGEDESCRIPTION" id="IMAGEDESCRIPTION" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="3">#GetImages.IMAGEDESCRIPTION#</CFTEXTAREA></TD>
			</TR>
               <TR>
				<TH align="left" width="5%" valign="TOP" nowrap><LABEL for="IMAGENOTES">Notes:</LABEL></TH>
				<TD align="left" width="95%"><CFTEXTAREA name="IMAGENOTES" id="IMAGENOTES" wrap="VIRTUAL" REQUIRED="No" rows="7" cols="80" tabindex="4">#GetImages.IMAGENOTES#</CFTEXTAREA></TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSIMAGES" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="5" />
				</TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" colspan="2">
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="6" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/imagesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="7" /><BR />
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