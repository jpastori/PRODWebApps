<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: pdtopic.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2012 --->
<!--- Date in Production: 08/03/2012 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Public Desk Topics --->
<!-- Last modified by John R. Pastori on 08/03/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/pdtopic.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Public Desk Topics</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Public Desk Topics</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Web Reports";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.TOPIC.TOPIC.value == "") {
			alertuser (document.TOPIC.TOPIC.name +  ",  A Public Desk Topic MUST be entered!");
			document.TOPIC.TOPIC.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.TOPICID.selectedIndex == "0") {
			alertuser ("A Public Desk Topic MUST be selected!");
			document.LOOKUP.TOPICID.focus();
			return false;
		}
	}


	function setDelete() {
		document.TOPIC.PROCESSPDTOPIC.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPDTOPIC') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.TOPICID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.TOPIC.TOPIC.focus()">
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

<CFQUERY name="ListPDTopic" datasource="#application.type#WEBREPORTS" blockfactor="29">
	SELECT	TOPICID, TOPIC
	FROM		PDTOPIC
	ORDER BY	TOPIC
</CFQUERY>

<BR clear="left" />

<!--- 
*****************************************************************
* The following code is the ADD Process for Public Desk Topics. *
*****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Public Desk Topics</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
			SELECT	MAX(TOPICID) AS MAX_ID
			FROM		PDTOPIC
		</CFQUERY>
		<CFSET FORM.TOPICID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="TOPICID" secure="NO" value="#FORM.TOPICID#">
		<CFQUERY name="AddPDTopicID" datasource="#application.type#WEBREPORTS">
			INSERT INTO	PDTOPIC (TOPICID)
			VALUES		(#val(Cookie.TOPICID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Public Desk Topics Key &nbsp; = &nbsp; #FORM.TOPICID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processpdtopic.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPDTOPIC" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="TOPIC" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processpdtopic.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="TOPIC">*Public Desk Topics:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="TOPIC" id="TOPIC" value="" align="LEFT" required="No" size="65" maxlength="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSPDTOPIC" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processpdtopic.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPDTOPIC" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="4" /><BR />
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
********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Public Desk Topics. *
********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPPDTOPIC')>
			<TD align="center"><H1>Lookup for Modify/Delete Information to Web Reports - Public Desk Topics</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to Web Reports - Public Desk Topics</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPPDTOPIC')>
		<TR>
			<TH align="center">Public Desk Topics Key &nbsp; = &nbsp; #FORM.TOPICID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPPDTOPIC')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/pdtopic.cfm?PROCESS=#URL.PROCESS#&LOOKUPPDTOPIC=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="TOPICID">*Public Desk Topics</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="TOPICID" id="TOPICID" size="1" query="ListPDTopic" value="TOPICID" display="TOPIC" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
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
********************************************************************************
* The following code is the Modify and Delete Processes for Public Desk Topics.*
********************************************************************************
 --->

		<CFQUERY name="GetPDTopic" datasource="#application.type#WEBREPORTS">
			SELECT	TOPICID, TOPIC
			FROM		PDTOPIC
			WHERE	TOPICID = <CFQUERYPARAM value="#FORM.TOPICID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	TOPIC
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/pdtopic.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="TOPIC" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processpdtopic.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="TOPICID" secure="NO" value="#FORM.TOPICID#">
				<TH align="left"><H4><LABEL for="TOPIC">*Public Desk Topics:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="TOPIC" id="TOPIC" value="#GetPDTopic.TOPIC#" align="LEFT" required="No" size="65" maxlength="50" tabindex="2"></TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPDTOPIC" value="MODIFY" /><BR />
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
<CFFORM action="/#application.type#apps/webreports/pdtopic.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
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