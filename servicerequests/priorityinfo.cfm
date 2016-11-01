<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: priorityinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/25/2012 --->
<!--- Date in Production: 05/25/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Service Requests Priority --->
<!-- Last modified by John R. Pastori on 05/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/priorityinfo.cfm">
<CFSET CONTENT_UPDATED = "May 25, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Service Requests - Priority</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Service Requests - Priority</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Service Requests";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {
		if (document.PRIORITY.PRIORITYNAME.value == "" || document.PRIORITY.PRIORITYNAME.value == " ") {
			alertuser (document.PRIORITY.PRIORITYNAME.name +  ",  A Priority Name MUST be entered!");
			document.PRIORITY.PRIORITYNAME.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.PRIORITYID.selectedIndex == "0") {
			alertuser ("A Priority Name MUST be selected!");
			document.LOOKUP.PRIORITYID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.PRIORITY.PROCESSPRIORITY.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPRIORITY') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.PRIORITYID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.PRIORITY.PRIORITYNAME.focus()">
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

<CFQUERY name="ListPriority" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
	SELECT	PRIORITYID, PRIORITYNAME
	FROM		PRIORITY
	ORDER BY	PRIORITYNAME
</CFQUERY>

<!--- 
*******************************************************
* The following code is the ADD Process for Priority. *
*******************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Add Information to IDT Service Requests - Priority</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(PRIORITYID) AS MAX_ID
		FROM		PRIORITY
	</CFQUERY>
	<CFSET FORM.PRIORITYID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="PRIORITYID" secure="NO" value="#FORM.PRIORITYID#">
	<CFQUERY name="AddPriorityID" datasource="#application.type#SERVICEREQUESTS">
		INSERT INTO	PRIORITY (PRIORITYID)
		VALUES		(#val(Cookie.PRIORITYID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Priority Key &nbsp; = &nbsp; #FORM.PRIORITYID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processpriorityinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPRIORITY" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
			</TR>
		<TR>
<CFFORM name="PRIORITY" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processpriorityinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" nowrap><H4><LABEL for="PRIORITYNAME">*Priority:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="PRIORITYNAME" id="PRIORITYNAME" value="" align="LEFT" required="No" size="30" maxlength="25" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSPRIORITY" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		</TR><TR>
<CFFORM action="/#application.type#apps/servicerequests/processpriorityinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPRIORITY" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="4" /><BR />
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
**********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Priority. *
**********************************************************************************
 --->


	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to IDT Service Requests - Priority</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPPRIORITY')>
		<TR>
			<TH align="center">Priority Key &nbsp; = &nbsp; #FORM.PRIORITYID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPPRIORITY')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/priorityinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPPRIORITY=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="PRIORITYID">*Priority:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="PRIORITYID" id="PRIORITYID" size="1" query="ListPriority" value="PRIORITYID" display="PRIORITYNAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
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
***********************************************************************
* The following code is the Modify and Delete Processes for Priority. *
***********************************************************************
 --->

		<CFQUERY name="GetPriority" datasource="#application.type#SERVICEREQUESTS">
			SELECT	PRIORITYID, PRIORITYNAME
			FROM		PRIORITY
			WHERE	PRIORITYID = <CFQUERYPARAM value="#FORM.PRIORITYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PRIORITYNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/priorityinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
<CFFORM name="PRIORITY" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processpriorityinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="PRIORITYID" secure="NO" value="#FORM.PRIORITYID#">
				<TH align="left" nowrap><H4><LABEL for="PRIORITYNAME">*Priority:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="PRIORITYNAME" id="PRIORITYNAME" value="#GetPriority.PRIORITYNAME#" align="LEFT" required="No" size="30" maxlength="25" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPRIORITY" value="MODIFY" />
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
			</TR><TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/priorityinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
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