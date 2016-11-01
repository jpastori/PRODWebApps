<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: statuses.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/16/2012 --->
<!--- Date in Production: 07/16/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Software Inventory - Status --->
<!-- Last modified by John R. Pastori on 07/16/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/statuses.cfm">
<CFSET CONTENT_UPDATED = "July 16, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Software Inventory - Status</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Software Inventory - Status</TITLE>
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
		if (document.STATUS.STATUSTYPE.value == "" || document.STATUS.STATUSTYPE.value == " ") {
			alertuser (document.STATUS.STATUSTYPE.name +  ",  An Status Type MUST be entered!");
			document.STATUS.STATUSTYPE.focus();
			return false;
		}

		if (document.STATUS.STATUSNAME.value == "" || document.STATUS.STATUSNAME.value == " ") {
			alertuser (document.STATUS.STATUSNAME.name +  ",  A Status Name MUST be entered!");
			document.STATUS.STATUSNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.STATUSID.selectedIndex == "0") {
			alertuser ("A Status Type/Name MUST be selected!");
			document.LOOKUP.STATUSID.focus();
			return false;
		}
	}


	function setDelete() {
		document.STATUS.PROCESSSTATUS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPSTATUS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.STATUSID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.STATUS.STATUSTYPE.focus()">
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

<CFQUERY name="ListStatuses" datasource="#application.type#SOFTWARE" blockfactor="15">
	SELECT	STATUSID, STATUSTYPE, STATUSNAME, STATUSTYPE || ' - ' || STATUSNAME AS TYPENAME
	FROM		STATUSES
	ORDER BY	TYPENAME
</CFQUERY>

<BR clear="left" />

<!--- 
*****************************************************
* The following code is the ADD Process for Status. *
*****************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Software Inventory - Status</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
		SELECT	MAX(STATUSID) AS MAX_ID
		FROM		STATUSES
	</CFQUERY>
	<CFSET FORM.STATUSID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="STATUSID" secure="NO" value="#FORM.STATUSID#">
	<CFQUERY name="AddStatusID" datasource="#application.type#SOFTWARE">
		INSERT INTO	STATUSES (STATUSID)
		VALUES		(#val(Cookie.STATUSID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Status Key &nbsp; = &nbsp; #FORM.STATUSID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processstatuses.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSTATUS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="STATUS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processstatuses.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="STATUSTYPE">*Status Type</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="STATUSNAME">*Status Name</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="STATUSTYPE" id="STATUSTYPE" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="STATUSNAME" id="STATUSNAME" value="" align="LEFT" required="No" size="50" tabindex="3"><BR /><BR /></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSSTATUS" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processstatuses.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSSTATUS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="5" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Status. *
********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPSTATUS')>
			<TD align="center"><H1>Lookup for Modify/Delete to IDT Software Inventory - Status </H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete to IDT Software Inventory - Status </H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPSTATUS')>
		<TR>
			<TH align="center"> Status Key &nbsp; = &nbsp; #FORM.STATUSID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPSTATUS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/statuses.cfm?PROCESS=#URL.PROCESS#&LOOKUPSTATUS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="STATUSID">*Status Type/Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="STATUSID" id="STATUSID" size="1" query="ListStatuses" value="STATUSID" display="TYPENAME" required="No" tabindex="2"></CFSELECT>
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
				<TD colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
********************************************************************
* The following code is the Modify and Delete Processes for Status.*
********************************************************************
 --->

		<CFQUERY name="GetStatuses" datasource="#application.type#SOFTWARE">
			SELECT	STATUSID, STATUSTYPE, STATUSNAME
			FROM		STATUSES
			WHERE	STATUSID = <CFQUERYPARAM value="#FORM.STATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATUSTYPE, STATUSNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/softwareinventory/statuses.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="STATUS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processstatuses.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="STATUSID" secure="NO" value="#FORM.STATUSID#">
				<TH align="left"><H4><LABEL for="STATUSTYPE">*Status Type</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="STATUSNAME">*Status Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="STATUSTYPE" id="STATUSTYPE" value="#GetStatuses.STATUSTYPE#" align="LEFT" required="No" size="50" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="STATUSNAME" id="STATUSNAME" value="#GetStatuses.STATUSNAME#" align="LEFT" required="No" size="50" tabindex="3"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSSTATUS" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/softwareinventory/statuses.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>