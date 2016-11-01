<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: externlshops.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/08/2012 --->
<!--- Date in Production: 02/08/2012 --->
<!--- Module: Add/Modify/Delete Information to Facilities - External Shops --->
<!-- Last modified by John R. Pastori on 02/08/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI ="/#application.type#apps/facilities/externlshops.cfm">
<CFSET CONTENT_UPDATED = "February 08, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Facilities - External Shops</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Facilities - External Shops</TITLE>
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
		if (document.EXTERNLSHOPS.EXTERNLSHOPNAME.value == "") {
			alertuser (document.EXTERNLSHOPS.EXTERNLSHOPNAME.name +  ",  A External Shop Name MUST be entered!");
			document.EXTERNLSHOPS.EXTERNLSHOPNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.EXTERNLSHOPID.selectedIndex == "0") {
			alertuser ("A External Shop Name MUST be selected!");
			document.LOOKUP.EXTERNLSHOPID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPEXTERNLSHOP') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.EXTERNLSHOPID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.EXTERNLSHOPS.EXTERNLSHOPNAME.focus()">
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

<CFQUERY name="ListExternalShops" datasource="#application.type#FACILITIES" blockfactor="16">
	SELECT	EXTERNLSHOPID, EXTERNLSHOPNAME
	FROM		EXTERNLSHOPS
	ORDER BY	EXTERNLSHOPNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*************************************************************
* The following code is the ADD Process for External Shops. *
*************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Facilities - External Shops</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
			SELECT	MAX(EXTERNLSHOPID) AS MAX_ID
			FROM		EXTERNLSHOPS
		</CFQUERY>
		<CFSET FORM.EXTERNLSHOPID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="EXTERNLSHOPID" secure="NO" value="#FORM.EXTERNLSHOPID#">
		<CFQUERY name="AddExternalShopsID" datasource="#application.type#FACILITIES">
			INSERT INTO	EXTERNLSHOPS (EXTERNLSHOPID)
			VALUES		(#val(Cookie.EXTERNLSHOPID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				External Shop Key &nbsp; = &nbsp; #FORM.EXTERNLSHOPID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/processexternlshops.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessExternlShops" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="EXTERNLSHOPS" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processexternlshops.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="EXTERNLSHOPNAME">*External Shop Name</LABEL></H4></TH>
               <TH align="left"><LABEL for="CONTACT_NAME">Contact Name</LABEL></TH>
		</TR>
		<TR>
          	<TD align="left"><CFINPUT type="Text" name="EXTERNLSHOPNAME" id="EXTERNLSHOPNAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
               <TD align="left"><CFINPUT type="Text" name="CONTACT_NAME" id="CONTACT_NAME" value="" align="LEFT" required="No" size="50" tabindex="3"></TD>
		</TR>
          <TR>
               <TH align="left"><LABEL for="CONTACT_PHONE">Contact Phone</LABEL></TH>
               <TH align="left"><LABEL for="SECOND_PHONE">Second Phone</LABEL></TH>
		</TR>
		<TR>
               <TD align="left"><CFINPUT type="Text" name="CONTACT_PHONE" id="CONTACT_PHONE" value="" align="LEFT" required="No" size="50" tabindex="4"></TD>
         		<TD align="left"><CFINPUT type="Text" name="SECOND_PHONE" id="SECOND_PHONE" value="" align="LEFT" required="No" size="50" tabindex="5"></TD>
		</TR>
          <TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessExternlShops" value="ADD" tabindex="6" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/facilities/processexternlshops.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessExternlShops" value="CANCELADD" tabindex="7" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
****************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting External Shops. *
****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Facilities - External Shops</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPEXTERNLSHOP')>
		<TR>
			<TH align="center">External Shop Key &nbsp; = &nbsp; #FORM.EXTERNLSHOPID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPEXTERNLSHOP')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/externlshops.cfm?PROCESS=#URL.PROCESS#&LOOKUPEXTERNLSHOP=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="EXTERNLSHOPID">*External Shop Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="EXTERNLSHOPID" id="EXTERNLSHOPID" size="1" query="ListExternalShops" value="EXTERNLSHOPID" display="EXTERNLSHOPNAME" selected="0" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
****************************************************************************
* The following code is the Modify and Delete Processes for External Shops.*
****************************************************************************
 --->

		<CFQUERY name="GetExternalShops" datasource="#application.type#FACILITIES">
			SELECT	EXTERNLSHOPID, EXTERNLSHOPNAME, CONTACT_NAME, CONTACT_PHONE, SECOND_PHONE
			FROM		EXTERNLSHOPS
			WHERE	EXTERNLSHOPID = <CFQUERYPARAM value="#FORM.EXTERNLSHOPID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	EXTERNLSHOPID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/facilities/externlshops.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessExternlShops" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="EXTERNLSHOPS" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processexternlshops.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="EXTERNLSHOPID" secure="NO" value="#FORM.EXTERNLSHOPID#">
				<TH align="left"><H4><LABEL for="EXTERNLSHOPNAME">*External Shop Name:</LABEL></H4></TH>
                    <TH align="left"><LABEL for="CONTACT_NAME">Contact Name</LABEL></TH>
               </TR>
               <TR>
                    <TD align="left"><CFINPUT type="Text" name="EXTERNLSHOPNAME" id="EXTERNLSHOPNAME" value="#GetExternalShops.EXTERNLSHOPNAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
                    <TD align="left"><CFINPUT type="Text" name="CONTACT_NAME" id="CONTACT_NAME" value="#GetExternalShops.CONTACT_NAME#" align="LEFT" required="No" size="50" tabindex="3"></TD>
               </TR>
               <TR>
                    <TH align="left"><LABEL for="CONTACT_PHONE">Contact Phone</LABEL></TH>
	               <TH align="left"><LABEL for="SECOND_PHONE">Second Phone</LABEL></TH>
               </TR>
               <TR>
                    <TD align="left"><CFINPUT type="Text" name="CONTACT_PHONE" id="CONTACT_PHONE" value="#GetExternalShops.CONTACT_PHONE#" align="LEFT" required="No" size="50" tabindex="4"></TD>
                    <TD align="left"><CFINPUT type="Text" name="SECOND_PHONE" id="SECOND_PHONE" value="#GetExternalShops.SECOND_PHONE#" align="LEFT" required="No" size="50" tabindex="5"></TD>
               </TR>
               <TR>
                    <TD align="left" colspan="2">&nbsp;&nbsp;</TD>
               </TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessExternlShops" value="MODIFY" tabindex="6" /></TD>
			</TR>
			<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessExternlShops" value="DELETE" tabindex="7" /></TD>
			</TR>
			</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/externlshops.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessExternalShops" value="Cancel" tabindex="8" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>